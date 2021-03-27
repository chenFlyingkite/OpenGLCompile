//
//  HomeViewController.swift
//  OpenGLCompile
//
//  Created by Eric Chen on 2021/3/26.
//
//

//import Cocoa
import Foundation
import AppKit
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

    private var myContext : OpenGLContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.view
        setupRes()
        setupConstraints()
        myContext = OpenGLContext()
        test()
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        print("panelArea = \(panelArea.frame)")
        print(" compile = \(compile.frame)")
        print("inputArea = \(inputArea.frame)")
        print(" vertexTitle = \(vertexTitle.frame)")
        print(" vertexScroll = \(vertexScroll.frame)")
        print("  vertexSource = \(vertexSource.frame)")
        print(" fragmentTitle = \(fragmentTitle.frame)")
        print(" fragmentScroll = \(fragmentScroll.frame)")
        print("  fragmentSource = \(fragmentSource.frame)")

    }

    @IBAction func clickCompile(_ sender: Any) {
        let texts :[NSTextView] = [self.vertexSource, self.fragmentSource]
        let types :[ShaderType] = [.vertex, .fragment]
        var codes :[ShaderCode] = []
        let n = texts.count
        for i in 0..<n {
            let vi = texts[i].string
            let ti = types[i]
            print("#\(i) = \(ti) -> \(vi)")
            let cx = ShaderCode.compile(vi, ti)
            codes.append(cx)
            print("cx = \(cx)")
        }
        let pg = ShaderProgram.from(texts[0].string, texts[1].string)
        print("pg = \(pg)")
    }
    
    override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
    }

    private func setupRes() {
        // https://developer.apple.com/fonts/system-fonts/#preinstalled
        let fnt = NSFont(name: "Courier New", size: 18)
        vertexSource.font = fnt
        fragmentSource.font = fnt
    }

    //-- MARK: Layouts
    private func setupConstraints() {
        let tx = [vertexTitle, fragmentTitle]
        let sx = [vertexScroll, fragmentScroll]
        let root = self.view
        var c:[Any] = [
            FLLayouts.view(panelArea, corner: .leftTop, to: root, offsetX: 20, offsetY: 5),
            // TODO this layout makes overlap?
            //FLLayouts.view(inputArea, below: panelArea, offset: 10), // x
            FLLayouts.view(inputArea, align: .top, to:root, offset: 30), // o

            FLLayouts.view(inputArea, sameXTo: root, offset: .init(top: 10, left: 10, bottom: 10, right: 10)),
            FLLayouts.views(tx, set:.height, to: 20),
            FLLayouts.views(sx, set: .height, to: 150),
        ]
        FLLayouts.activate(root, forConstraint: c)
    }

    private func test() {
        print("test")
//        if let shareGroup = imageProcessingShareGroup {
//            generatedContext = EAGLContext(api:.openGLES2, sharegroup:shareGroup)
//        } else {
//            generatedContext = EAGLContext(api:.openGLES2)
//        }

    // /Applications/AppCode.app/Contents/Resources/module_cache_12D4e.zip!/5.3.2/x86_64/macosx11.1$macos/OpenGL.GL3/OpenGL.GL3.swift

        let vx = Self.vertex()
        let fx = Self.fragment()
        let sh = ShaderProgram.from(vx, "asd\n\nfff")
        let xh = ShaderProgram.from(vx, fx)
        checkGLError()
        vertexSource.string = vx
        fragmentSource.string = fx
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
            //"precision highp float;", // this is for OpenGLES
            "varying vec2 textureCoordinate;",
            "varying vec2 textureCoordinate2;",

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
