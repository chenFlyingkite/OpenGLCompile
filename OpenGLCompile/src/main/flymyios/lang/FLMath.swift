//
// Created by Eric Chen on 2021/5/3.
//

import Foundation

class FLMath {
    class func radToDeg(_ r:Double) -> Double {
        //return r * 180.0 / M_PI
        return r * 180.0 / Double.pi
    }
    class func degToRad(_ d:Double) -> Double {
        //return d / 180.0 * M_PI
        return d / 180.0 / Double.pi
    }
}