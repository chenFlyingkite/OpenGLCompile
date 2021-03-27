//
// Created by Eric Chen on 2021/3/21.
//

//import OpenGLES
import OpenGL
//import Cocoa
import Foundation

public class ShaderProgram : NSObject {
    private(set) var programID : GLuint = 0
    private(set) var vertexID : ShaderCode?
    private(set) var fragmentID : ShaderCode?
    private(set) var delete : GLint = GL_FALSE
    private(set) var isLinked : GLint = GL_FALSE
    private(set) var linkLog = ""

    public class func from(_ vertexCode:String, _ fragmentCode:String) -> ShaderProgram {
        print("vertex = \n\(vertexCode)")
        print("fragment = \n\(fragmentCode)")

        let vid = ShaderCode.compile(vertexCode, .vertex)
        let fid = ShaderCode.compile(fragmentCode, .fragment)
        return Self.from(vid, fid)
    }

    public class func from(_ vertex:ShaderCode, _ fragment:ShaderCode) -> ShaderProgram {
        let ans = ShaderProgram()

        let pgid = glCreateProgram()
        ans.programID = pgid
        ans.vertexID = vertex
        ans.fragmentID = fragment

        glAttachShader(pgid, vertex.shaderID)
        glAttachShader(pgid, fragment.shaderID)

        glLinkProgram(pgid)

        // https://www.khronos.org/registry/OpenGL-Refpages/es3/html/glLinkProgram.xhtml
        // Link Program

        // https://www.khronos.org/registry/OpenGL-Refpages/es3/html/glGetProgramiv.xhtml
        var del:GLint = 0
        glGetProgramiv(pgid, GLenum(GL_DELETE_STATUS), &del)
        ans.delete = del

        var linked:GLint = 0
        glGetProgramiv(pgid, GLenum(GL_LINK_STATUS), &linked)
        ans.isLinked = linked

        var logLen:GLint = 0
        glGetProgramiv(pgid, GLenum(GL_INFO_LOG_LENGTH), &logLen)
        if (logLen > 0) {
            var logCChar = [CChar](repeating: 0, count: Int(logLen))
            glGetProgramInfoLog(pgid, logLen, &logLen, &logCChar)
            let logs = String(cString: logCChar)
            ans.linkLog = logs
        } else {
            ans.linkLog = ""
        }

        print("program = \(ans)")
        return ans
    }

    public func use() {
        glUseProgram(programID)
    }

    public override var description: String {
        let pid = programID
        let vid = vertexID?.shaderID ?? 0
        let fid = fragmentID?.shaderID ?? 0
        return "#\(pid), v = #\(vid), f = #\(fid), link = \(glOX(isLinked)), del = \(glOX(delete)) log: \n\(linkLog)"
    }

    deinit {
        print("deinit")
        if let v = self.vertexID {
            glDeleteShader(v.shaderID)
        }
        if let f = self.fragmentID {
            glDeleteShader(f.shaderID)
        }
        glDeleteProgram(programID)
    }

    //let program : GLuint
    // TODO
    // At some point, the Swift compiler will be able to deal with the early throw and we can convert these to lets
    //var vertex:GLuint!
    //var fragment:GLuint!

//    public init(vertexCode:String, fragmentCode:String) {
//
//        print("vertex = \n\(vertexCode)")
//        print("fragment = \n\(fragmentCode)")
//
//        let gls = NSOpenGLContext.current
//        print("openGL now = \(gls), \(String(describing: gls))")
//        let x = glGetString(GLenum(GL_VERSION))
//        if let x = x {
//            print("vs = \(String(cString: x))")
//            // 2.1 INTEL-16.1.11
//        }
//        var y = glGetStringi(GLenum(GL_VERSION), 0)
//        if let y = y {
//            print("y = \(String(cString: y))")
//        }
////        if let value = s.cString(using: String.Encoding.utf8) {
////            run(UnsafePointer<GLchar>(value))
////        } else {
////            fatalError("Could not convert this string to UTF8: \(self)")
////        }
//        if (1 > 0) {
//            program = 0
//            return
//        }
//
//        program = glCreateProgram()
//        // EAGL_MINOR_VERSION = 0, EAGL_MAJOR_VERSION = 1
//        print("glCreateProgram at = \(program)")
//        print("vertex = \n\(vertexCode)")
//        print("fragment = \n\(fragmentCode)")
//        self.vertex = ShaderProgram.compileShader(vertexCode, .vertex)
//        checkGLError()
//        self.fragment = ShaderProgram.compileShader(fragmentCode, .fragment)
//        checkGLError()
//
////        self.vertexShader = try compileShader(vertexShader, type:.vertex)
////        self.fragmentShader = try compileShader(fragmentShader, type:.fragment)
////
////        glAttachShader(program, self.vertexShader)
////        glAttachShader(program, self.fragmentShader)
////
////        try link()
//    }

}
