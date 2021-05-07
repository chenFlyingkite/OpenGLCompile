//
// Created by Eric Chen on 2021/5/3.
//

import Foundation
import AppKit

class FLToast : NSView {

    let text = NSText()
    var margin = NSEdgeInsets(10)
//    var centerX = 50.0
//    var centerY = 100.0
    var maxWidth = 40.0
    var textWidthLC : NSLayoutConstraint?
    var textHeightLC : NSLayoutConstraint?
    var textCenterXLC : NSLayoutConstraint?
    var textCenterYLC : NSLayoutConstraint?

    var wrapping = "-"

    // -- Layout by code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layout() {
        super.layout()
        wqe("text = \(text.string)")
        let r = FLStrings.measureWrapContent(text, atMostWidth: maxWidth)
        wqe("r = \(r.ltrb)")
//        textWidthLC?.constant = r.width
//        textHeightLC?.constant = r.height
//        needsLayout = true
//        let w = r.width.lf()
//        let h = r.height.lf()
//        let l = centerX - w / 2
//        let t = centerY - h / 2
//        textWidthLC?.constant = r.width
//        textHeightLC?.constant = r.height
        //self.frame = NSRect.init(l: l, t: t, r: l + w, b: t + h)
    }

    // MARK: UI Layouts
    private func setup() -> Void {
        setupRes()
        setupViewTree()
        setupConstraint()
        setupAction()
    }

    private func setupRes() {
//        textWidthLC = FLLayouts.view(text, set: .width, to: 10)
//        textHeightLC = FLLayouts.view(text, set: .height, to: 10)
//        textCenterXLC = FLLayouts.view(text, align: .centerX, to: self, of: .left, offset: 100)
//        textCenterYLC = FLLayouts.view(text, align: .centerY, to: self, of: .top, offset: 100)
        self.layer?.backgroundColor = NSColor.ofHex("#ff0").cgColor
        self.layer?.cornerRadius = margin.left // failed

        text.layer?.backgroundColor = NSColor.ofHex("#f00").cgColor
        text.layer?.cornerRadius = 5
        text.textColor = NSColor.ofHex("#f0f0")
        text.string = "Hello World \(FLStrings.now())"
    }

    private func setupViewTree() {
        let vs = [text]
        FLLayouts.addViewTo(self, child: vs)
    }

    private func setupConstraint() {
        //self.translatesAutoresizingMaskIntoConstraints = false
        let a:[Any] = [
            //textWidthLC!, textHeightLC!,
            //textCenterXLC!, textCenterYLC!,
            FLLayouts.view(text, sameTo: self, offset: margin),
        ]
        FLLayouts.activate(self, forConstraint: a)
    }

    private func setupAction() {

    }
}
