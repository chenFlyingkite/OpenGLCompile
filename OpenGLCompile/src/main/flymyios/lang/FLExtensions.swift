//
// Created by Eric Chen on 2021/3/25.
//

import Foundation

//class FLExtensions {
//}

extension Date {
    public func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension NSEdgeInsets {
//    public static var zero:Self {
//        get {
//            return .init(top: 0, left: 0, bottom: 0, right: 0)
//        }
//    }
    public static let zero = NSEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
}
