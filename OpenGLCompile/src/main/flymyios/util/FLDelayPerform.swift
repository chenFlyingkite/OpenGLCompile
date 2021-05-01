//
// Created by Eric Chen on 2021/5/1.
//

import Foundation

/*
 perform delayed run() by
 let de = FLDelayPerform()
 de.delay = 2 // seconds
 de.run = { print("Hello World") }
 for i in 0..<5 {
     de.perform() // keep calling it
 }
 // it will run the last one

 */
class FLDelayPerform : NSObject {
    var run: (()->())? = nil
    var delay :TimeInterval = 0
    // used for recognizing time
    private let token = FLStrings.now()
    // true = will called run(), false = already called
    private var sent = false

    override init() {
        super.init()
    }

    func perform() {
        let target = self
        let method = #selector(runMe)
        let key = token

        if (sent) {
            NSObject.cancelPreviousPerformRequests(withTarget: target, selector: method, object: key)
        }
        target.perform(method, with: key, afterDelay: self.delay)
        sent = true
    }

    @objc
    private func runMe(_ s:String) {
        sent = false
        if let r = run {
            r()
        }
    }
}
