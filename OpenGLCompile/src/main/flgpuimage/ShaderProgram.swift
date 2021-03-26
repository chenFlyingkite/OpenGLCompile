//
// Created by Eric Chen on 2021/3/21.
//

//import OpenGLES
import OpenGL
import Cocoa
//import Foundation

enum ShaderType : String {
//enum ShaderType : UInt32 {
//enum ShaderType : GLenum {
//    case vertex = GLenum(GL_VERTEX_SHADER)
//    case fragment = GLenum(GL_FRAGMENT_SHADER)
    case vertex// = GL_VERTEX_SHADER
    case fragment// = GL_FRAGMENT_SHADER
//    case vertex(GL_VERTEX_SHADER)
//    case fragment(GL_FRAGMENT_SHADER)
    func glID() -> UInt32 {
        switch (self) {
        case .vertex: return GLenum(GL_VERTEX_SHADER)
        case .fragment: return GLenum(GL_FRAGMENT_SHADER)
        }
    }
}

public class ShaderProgram {
    let program : GLuint
    // TODO
    // At some point, the Swift compiler will be able to deal with the early throw and we can convert these to lets
    var vertex:GLuint!
    var fragment:GLuint!

    public init(vertexCode:String, fragmentCode:String) {
        let gls = NSOpenGLContext.current
        print("openGL now = \(gls), \(String(describing: gls))")
        let x = glGetString(GLenum(GL_VERSION))
        if let x = x {
            print("vs = \(String(cString: x))")
            // 2.1 INTEL-16.1.11
        }
        var y = glGetStringi(GLenum(GL_VERSION), 0)
        if let y = y {
            print("y = \(String(cString: y))")
        }
//        if let value = s.cString(using: String.Encoding.utf8) {
//            run(UnsafePointer<GLchar>(value))
//        } else {
//            fatalError("Could not convert this string to UTF8: \(self)")
//        }
        if (1 > 0) {
            program = 0
            return
        }

        program = glCreateProgram()
        // EAGL_MINOR_VERSION = 0, EAGL_MAJOR_VERSION = 1
        print("glCreateProgram at = \(program)")
        print("vertex = \n\(vertexCode)")
        print("fragment = \n\(fragmentCode)")
        self.vertex = ShaderProgram.compileShader(vertexCode, .vertex)
        checkGLError()
        self.fragment = ShaderProgram.compileShader(fragmentCode, .fragment)
        checkGLError()

//        self.vertexShader = try compileShader(vertexShader, type:.vertex)
//        self.fragmentShader = try compileShader(fragmentShader, type:.fragment)
//
//        glAttachShader(program, self.vertexShader)
//        glAttachShader(program, self.fragmentShader)
//
//        try link()
    }

    deinit {
        print("deinit")
//        glDeleteShader(vertex)
//        glDeleteShader(fragment)
//        glDeleteProgram(program)
    }

    class func compileShader(_ codes:String, _ type:ShaderType) -> GLuint {
        let shader:GLuint = glCreateShader(type.glID())
        let id = type.glID();
        //print("shader = \(shader), glCreateShader(\(id.hex()) = \(type))")
        if (shader == 0) {
            print("glCreateShader failed")
        }

        FLGLs.toGLChars(codes, run: { glString in
            var gls:UnsafePointer<GLchar>? = glString
            glShaderSource(shader, 1, &gls, nil)
            glCompileShader(shader)
        })

        var compileOK = GL_FALSE
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &compileOK)
        //print("glGetShaderiv(\(shader), \(GL_COMPILE_STATUS.hex()), &\(compileOK))")
        var compileLogLength: GLint = 0
        glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &compileLogLength)
        //print("glGetShaderiv(\(shader), \(GL_INFO_LOG_LENGTH.hex()), &\(compileLogLength))")
        if (compileLogLength > 0) {
            var compileLog = [CChar](repeating: 0, count: Int(compileLogLength))
            glGetShaderInfoLog(shader, compileLogLength, &compileLogLength, &compileLog)
            print("Compile \(type) log: \n\(String(cString: compileLog))")
            // let compileLogString = String(bytes:compileLog.map{UInt8($0)}, encoding:NSASCIIStringEncoding)
        } else {
            print("Compile \(type) finished")
        }
        return shader
    }
}
