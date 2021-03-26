//
//  HomeViewController.swift
//  OpenGLCompile
//
//  Created by Eric Chen on 2021/3/26.
//
//

import Cocoa
import OpenGL


class HomeViewController : NSViewController {
    
    @IBOutlet weak var panelArea: NSStackView!
    @IBOutlet weak var compile: NSButton!
    
    @IBOutlet weak var inputArea: NSStackView!
    @IBOutlet weak var vertexTitle: NSTextField!
    @IBOutlet weak var vertexScroll: NSScrollView!
    @IBOutlet var vertexSource: NSTextView!
    @IBOutlet weak var fragmentTitle: NSTextField!
    @IBOutlet weak var fragmentScroll: NSScrollView!
    @IBOutlet var fragmentSource: NSTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.view
        setupConstraints()
        Self.usingOpenGL()
        test()
    }

    @IBAction func clickCompile(_ sender: Any) {
        let texts :[NSTextView] = [self.vertexSource, self.fragmentSource]
        let types :[ShaderType] = [.vertex, .fragment]
        let n = texts.count
        for i in 0..<n {
            let vi = texts[i].string
            let ti = types[i]
            print("#\(i) = \(ti) -> \(vi)")
            let cx = ShaderProgram.compileShader(vi, ti)
            print("cx = \(cx)")
            //ShaderProgram.compileShader(code, ti)
        }
    }
    
    override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
    }

    //-- MARK: Layouts
    private func setupConstraints() {
        let tx = [vertexTitle, fragmentTitle]
        let sx = [vertexScroll, fragmentScroll]
        let root = self.view
        var c:[Any] = [
            FLLayouts.view(panelArea, corner: .leftTop, to: root, offsetX: 20, offsetY: 5),
            FLLayouts.view(inputArea, corner: .leftTop, to: root, offsetX: 20, offsetY: 30),
            //FLLayouts.view(vertexTitle, set:.height, to: 20),
            FLLayouts.view(inputArea, sameXTo: root, offset: .init(top: 10, left: 10, bottom: 10, right: 10)),
            //FLLayouts.view(vertexScroll, width: 300, height: 150),
            FLLayouts.view(vertexScroll, set:.height, to: 150),
            FLLayouts.views(tx, set:.height, to: 20),
            FLLayouts.views(sx, set: .height, to: 150),

            //FLLayouts.view(fragmentTitle, align:.height, to: vertexTitle),
            //FLLayouts.view(fragmentScroll, sameWHTo: vertexScroll),
            //FLLayouts.view(fragmentTitle, set:.height, to: 20),
            //FLLayouts.view(fragmentScroll, set:.height, to: 150),
        ]
        FLLayouts.activate(root, forConstraint: c)
    }


    private class func usingOpenGL() {
        // OpenGLContext-OpenGL.swift
        // https://en.wikipedia.org/wiki/Multiple_buffering
        let pixelFormatAttributes:[NSOpenGLPixelFormatAttribute] = [
            //NSOpenGLPixelFormatAttribute(NSOpenGLPFADoubleBuffer),
            NSOpenGLPixelFormatAttribute(NSOpenGLPFATripleBuffer),
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAAccelerated), 0,
            0
        ]

        guard let pixelFormat = NSOpenGLPixelFormat(attributes:pixelFormatAttributes) else {
            fatalError("No appropriate pixel format found when creating OpenGL context.")
        }
        // TODO: Take into account the sharegroup
        guard let generatedContext = NSOpenGLContext(format:pixelFormat, share:nil) else {
            fatalError("Unable to create an OpenGL context. The GPUImage framework requires OpenGL support to work.")
        }
        generatedContext.makeCurrentContext()

//        let context = EAGLContext(api: .openGLES3)
//        if let ctx = context {
//            EAGLContext.setCurrent(ctx)
//        }
    }

    private func test() {
        print("test")
//        if let shareGroup = imageProcessingShareGroup {
//            generatedContext = EAGLContext(api:.openGLES2, sharegroup:shareGroup)
//        } else {
//            generatedContext = EAGLContext(api:.openGLES2)
//        }

    // /Applications/AppCode.app/Contents/Resources/module_cache_12D4e.zip!/5.3.2/x86_64/macosx11.1$macos/OpenGL.GL3/OpenGL.GL3.swift

        let sh = ShaderProgram.init(vertexCode: Self.vertex(), fragmentCode: "asd\n\nfff")
        checkGLError()
    }


    // MARK: Shader Vertex
    class func vertex() -> String {
        var v = [
            "attribute vec4 position;",
            "attribute vec4 inputTextureCoordinate;",
            "attribute vec4 inputTextureCoordinate2;",

            "varying vec2 textureCoordinate;",
            "varying vec2 textureCoordinate2;",
            // Main function
            "void main() {",
            "  gl_Position = position;",
            "  textureCoordinate = inputTextureCoordinate.xy;",
            "  textureCoordinate2 = inputTextureCoordinate2.xy;",
            "}",
        ]
        return FLGLs.join(v)
    }

    // MARK: Shader Fragment
    class func fragment() -> String {
        var f = [
            "precision highp float;",
            "varying highp vec2 textureCoordinate;",
            "varying highp vec2 textureCoordinate2;",

            "uniform sampler2D inputImageTexture;",
            "uniform sampler2D inputImageTexture2;",
            // Parameters
            "void main() {",
            "  vec4 source = texture2D(inputImageTexture, textureCoordinate);",
            "  vec4 target = texture2D(inputImageTexture2, textureCoordinate2);",
            "  vec4 d = source - target;",
            //--
            "  vec4 diff = vec4(abs(d.r), abs(d.g), abs(d.b), abs(d.a));",
            //"  vec4 diff = d;",
            //"  float s = 10.0;",
            "  float s = 1.0;",
            //--
            "  gl_FragColor = diff * s;",
            "}",
        ]
        return FLGLs.join(f)
    }



}
