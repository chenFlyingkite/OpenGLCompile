//
// Created by Eric Chen on 2021/5/2.
//

import Foundation
import AppKit

class FLColors {
}

// NSColor + Hex
extension NSColor {

    /**
     * Return the color defined by argb in strings, available syntax are as follows :
     * #rgb #argb #rrggbb #aarrggbb, as Regex is {
     *   d = ([0-9]|[a-f]|[A-F])
     *   hexColor = [#](d3|d4|d6|d8)
     * }
     */
    public class func ofHex(_ hex:String) -> NSColor {
        let c = Self.argb(hex)
        return Self.color(a: c[0], r: c[1], g: c[2], b: c[3])
    }

    private class func argb(_ hex:String) -> Array<Int> {
        var argbF4:Array<Int> = [0, 0, 0, 0]
        let n = hex.count
        let s = hex.toChars()
        let rgb = n == 4 // #rgb
        let argb = n == 5 // #argb
        let rrggbb = n == 7 // #rrggbb
        let aarrggbb = n == 9 // #aarrggbb
        let valid = rgb || argb || rrggbb || aarrggbb
        let ok = s[0] == "#" && valid
        if (!ok) {
            print("Unknown color syntax : \(hex) (Valid = #rgb, #argb, #rrggbb, #aarrggbb)")
            return argbF4
        }

        // Parsing color by each syntax
        if (rgb) {
            argbF4[0] = 255
            argbF4[1] = Self.toInt(s[1], s[1])
            argbF4[2] = Self.toInt(s[2], s[2])
            argbF4[3] = Self.toInt(s[3], s[3])
        } else if (argb) {
            argbF4[0] = Self.toInt(s[1], s[1])
            argbF4[1] = Self.toInt(s[2], s[2])
            argbF4[2] = Self.toInt(s[3], s[3])
            argbF4[3] = Self.toInt(s[4], s[4])
        } else if (rrggbb) {
            argbF4[0] = 255
            argbF4[1] = Self.toInt(s[1], s[2])
            argbF4[2] = Self.toInt(s[3], s[4])
            argbF4[3] = Self.toInt(s[5], s[6])
        } else if (aarrggbb) {
            argbF4[0] = Self.toInt(s[1], s[2])
            argbF4[1] = Self.toInt(s[3], s[4])
            argbF4[2] = Self.toInt(s[5], s[6])
            argbF4[3] = Self.toInt(s[7], s[8])
        }
        return argbF4
    }

    /**
     * Return int format of 0xaarrggbb of color, like red = 0xFFFF0000
     */
    public func colorInt() -> Int {
        let a = self.alphaComponent
        let r = self.redComponent
        let g = self.greenComponent
        let b = self.blueComponent
        let argb = [a, r, g, b]
        var ans = 0
        var i = 0
        while (i < 4) {
            let x = (argb[i] * 255).roundedInt()
            let sh = (3 - i) << 3 // (3-i)*8
            ans |= (0xFF & x) << sh
            i++
        }
        return ans
    }

    /**
     * Return the color defined by argb in integer of 0xaarrggbb,
     * Red = 0xFFFF0000, Green = 0xFF00FF00, Blue = 0xFF0000FF
     */
    public class func ofInt(_ v:Int) -> NSColor {
        var cs:Array<Int> = [0, 0, 0, 0]
        var i = 0
        while (i < 4) {
            let sh = (3 - i) << 3 // (3-i)*8
            cs[i] = (v >> sh) & 0xFF
            i++
        }
        return Self.color(a: cs[0], r: cs[1], g: cs[2], b: cs[3])
    }

    /**
     * Return the color defined by argb in integers, each value of alpha, red, green and blue should be in [0, 255]
     */
    public class func color(a:Int, r:Int, g:Int, b:Int) -> NSColor {
        let fa = CGFloat(a / 255.0)
        let fr = CGFloat(r / 255.0)
        let fg = CGFloat(g / 255.0)
        let fb = CGFloat(b / 255.0)
        return Self.init(srgbRed: fr, green: fg, blue: fb, alpha: fa)
    }

    private class func toInt(_ c:Character, _ d:Character) -> Int {
        return (toInt(c) << 4) | toInt(d)
    }

//        if (c.isHexDigit) {
//
//            c.isLetter
//        }
//        if (isxdigit(c)) { // 0-9, a-f, A-F
//            int p = isalpha(c);  // a/A ? 0
//            if (p) {
//                int a = isupper(c) ? 'A' : 'a'; // A ? a
//                return 10 + c - a;
//            } else {
//                return c - '0';
//            }
//        }
//        return 0;
    private class func toInt(_ c:Character) -> Int {
        return c.hexDigitValue ?? 0
    }

    /**
     * Return "#aarrggbb" of color
     */
    public func hex() -> String {
        let c = self.colorInt()
        return String.init(format: "#%X", c)
    }

    /**
     * Return alpha component of color in integer, within [0, 255]
     */
    public class func alpha(_ c:NSColor) -> Int {
        return Self.component(c, 24)
    }
    /**
     * Return red component of color in integer, within [0, 255]
     */
    public class func red(_ c:NSColor) -> Int {
        return Self.component(c, 16)
    }
    /**
     * Return green component of color in integer, within [0, 255]
     */
    public class func green(_ c:NSColor) -> Int {
        return Self.component(c, 8)
    }
    /**
     * Return blue component of color in integer, within [0, 255]
     */
    public class func blue(_ c:NSColor) -> Int {
        return Self.component(c, 0)
    }
    private class func component(_ c:NSColor, _ k:Int) -> Int {
        let ci = c.colorInt()
        let FF = 0xFF
        let m = FF << k
        return ((ci & m) >> k) & FF
    }

    /**
     * Return the color by alpha = a, and keep its rgb color
     * If color = 0x55AA6699, then [color makeAlpha:0xFF]
     * returns new color of 0xFFAA6699
     */
    public func makeAlpha(_ a:Int) -> NSColor {
        let c = self.colorInt()
        let rgb = c & 0x00FFFFFF
        let na = (a & 0xFF) << 24
        let nc = na | rgb
        return Self.ofInt(nc)
    }
}
