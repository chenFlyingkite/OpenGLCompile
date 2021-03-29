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

extension DateFormatter {
    public class func of(_ f:String) -> DateFormatter {
        let x = DateFormatter()
        x.dateFormat = f
        return x
    }
}

extension NSEdgeInsets {
    public init(_ v:CGFloat) {
        self.init(top: v, left: v, bottom: v, right: v)
    }

    public init(x: CGFloat, y:CGFloat) {
        self.init(top: y, left: x, bottom: y, right: x)
    }

    public static let zero = Self(0)
}

