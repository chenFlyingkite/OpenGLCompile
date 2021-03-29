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


class HomeViewController : NSViewController, NSTextViewDelegate {
    
    @IBOutlet weak var panelArea: NSStackView!
    @IBOutlet weak var compile: NSButton!
    
    @IBOutlet weak var inputArea: NSStackView!
    @IBOutlet weak var vertexTitle: NSTextField!
    @IBOutlet weak var vertexScroll: NSScrollView!
    @IBOutlet var vertexSource: NSTextView!

    @IBOutlet weak var fragmentTitle: NSTextField!
    @IBOutlet weak var fragmentScroll: NSScrollView!
    @IBOutlet var fragmentSource: NSTextView!

    private let mainCtx = OpenGLContext.start()

    // https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/OpenGL-MacProgGuide/opengl_threading/opengl_threading.html

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        wqe("")
        // Do any additional setup after loading the view.
        //self.view
        setupRes()
        setupConstraints()
        ready.fire()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        wqe("")
    }

    override func viewWillLayout() {
        super.viewWillLayout()
        wqe("")
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        wqe("")
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
    override func viewDidAppear() {
        super.viewDidAppear()
        wqe("")
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        wqe("")
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        wqe("")
    }

    // MARK: click


    @IBAction func clickCompile(_ sender: Any) {
        self.compileProgram()
        q.async(execute: {
            wqe("")
            //self.compileProgram()
        })
    }

    private func compileProgram() {
        wqe("compile")
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

        vertexSource.delegate = self
        aut = Timer.init(timeInterval: 3, repeats: true, block: { timer in
        //aut = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
            self.run()
        })


        let vx = Self.vertex()
        let fx = Self.fragment()
        vertexSource.string = vx
        fragmentSource.string = fx
        // all async = crash

        self.test()
        DispatchQueue.main.async(execute: {
            //self.test()
        })

    }

    // MARK: public protocol NSTextDelegate : NSObjectProtocol {
    // User enter texts
    // textShouldBeginEditing
    // textDidBeginEditing
    // textDidChange
    var q = DispatchQueue(label: "textRun")
    var timSource : DispatchSourceTimer?

    private let ready = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
        wqe("")
    })

    private var aut :Timer?

    // 3 second
    //private let aut = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(run), userInfo: nil, repeats: false)
    //private let autoRun = Timer.scheduledTimer(timeInterval: 3, invocation: self, repeats: #selector(run))
//    private let autoRun = Timer(timeInterval: 3, repeats: false, block: { timer in
//        self().run()
//    })

    @objc
    private func run() {
        wqe("called run")
        self.compileProgram() // x
        q.async(execute: { [weak self] in
            guard let zelf = self else { return }
            wqe("")
            //zelf.compileProgram()
        })
    }


    // YES means do it
    func textShouldBeginEditing(_ textObject: NSText) -> Bool {
        wqe("\(textObject)")
        return true
    }

    // YES means do it
    func textShouldEndEditing(_ textObject: NSText) -> Bool {
        wqe("\(textObject)")
        return true
    }

    func textDidBeginEditing(_ notification: Notification) {
        wqe("\(notification)")
    }

    func textDidEndEditing(_ notification: Notification) {
        wqe("\(notification)")
    }

    // Any keyDown or paste which changes the contents causes this
    func textDidChange(_ notification: Notification) {
        wqe("\(notification)")
        var txtN = 0
        if let tx = notification.object as? NSTextView {
            txtN = tx.string.count
        }
        wqe("txtN = \(txtN)")
//        aut?.invalidate()
//        aut?.fire()

        let runAt:DispatchTime = .now() + .seconds(5)
        //DispatchSourceTimer

        timSource?.cancel()
        let tim = DispatchSource.makeTimerSource(queue: q)
        tim.setEventHandler(handler: {
            let no = self.timSource?.isCancelled ?? true
            wqe("cancel = \(no), \(self.timSource)")
            if (no) {
            } else {
                self.run()
            }
        })
        timSource = tim
        tim.schedule(deadline: runAt)
        tim.resume()
        //timSource?.cancel()
//        q.asyncAfter(deadline: <#T##DispatchTime##Dispatch.DispatchTime#>, execute: {
//
//        })
        //--
//        let date = Date().addingTimeInterval(5)
//        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(runCode), userInfo: nil, repeats: false)
//        RunLoop.main.add(timer, forMode: .common)
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
            // type conversion of int & float
            //"  float x = float(5);",
            //"  int y = int(5.3);",
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
