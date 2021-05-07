//
// Created by Eric Chen on 2021/3/25.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public class FLStrings {
    #if os(iOS)
    public typealias Font = UIFont
    public typealias Text = UILabel
//    public typealias StackView = UIStackView
//    public typealias EdgeInsets = UIEdgeInsets
    #elseif os(macOS)
    public typealias Font = NSFont
    public typealias Text = NSText
//    public typealias StackView = NSStackView
//    public typealias EdgeInsets = NSEdgeInsets
    #endif

    public static let fmt_yyyyMMddHHmmssSSS = DateFormatter.of("yyyy-MM-dd HH:mm:ss.SSS")
    public static let fmt_MMddHHmmssSSS = DateFormatter.of("MM-dd HH:mm:ss.SSS")

    // returns Regex = (s){n}
    // Result is same as String.init(repeating: s, count: n)
    // but this method runs faster
    public class func repeats(_ s:String, _ n:Int) -> String {
        //
        var ans = ""
        var now = s
        var x = n
        while (x > 0) {
            if ((x & 0x1) == 1) {
                ans += now
            }
            now += now
            x >>= 1
        }
        return ans
    }


    // Returns now like "07-03 11:22:33.444"
    public class func now() -> String {
        let d = Date()
        return fmt_MMddHHmmssSSS.string(from: d)
    }

    // Returns formatted date of now
    public class func now(_ format:String) -> String {
        let d = Date()
        let f = DateFormatter.of(format)
        return f.string(from: d)
    }

    public class func join(_ a: [String], delim d: String = "") -> String {
        var ans = ""
        for i in 0..<a.count {
            ans += a[i] + d
        }
        return ans
    }

    public class func join(_ a:[AnyObject], pre:String = "", delim d:String = "", post:String = "") -> String {
        let n = a.count
        var s = pre
        for i in 0..<n {
            if (i > 0) {
                s += d
            }
            // is it redundant?
            if let ai = a[i] as? String {
                s += ai
            } else {
                s += String(describing: a[i])
            }
        }
        s += post
        return s
    }

    /**
     LC#165
     Compares version codes with delimiter
     Version code is like int([.]int)* with num = integer numbers
     let v1, v2 are two strings split by dot, then
     return | v1        | v2
      -1    | "7.2.5.3" | "7.2.6"
       0    | "1.0.0"   | "1"
       0    | "1.01"    | "1.001"
      -1    | "0.1"     | "1.1"
       1    | "1.0.1"   | "1.0"
     */
    public class func compareVersion(v1:String, v2:String, delim:String = ".") -> Int {
        let v1s = v1.components(separatedBy: delim)
        let v2s = v2.components(separatedBy: delim)
        let n1 = v1s.count
        let n2 = v2s.count
        let mx = max(n1, n2)
        for i in 0..<mx {
            var x = 0, y = 0
            if (i < n1) {
                x = (v1s[i] as NSString).integerValue
            }
            if (i < n2) {
                y = (v2s[i] as NSString).integerValue
            }
            if (x < y) {
                return -1
            } else if (x > y) {
                return 1
            }
        }
        return 0
    }

//        + (NSString*) join:(NSDictionary*)map pre:(NSString *)pre delimKV:(NSString *)d1 delimEntry:(NSString*)d2 post:(NSString *)post {
//    NSMutableString *s = [NSMutableString new];
//    // Pre
//    [s setString:pre];
//    // array
//    NSArray *keys = map.allKeys;
//    for (int i = 0; i < keys.count; i++) {
//        NSObject *k = keys[i];
//        NSObject *v = map[k];
//        if (i != 0) {
//            [s appendString:d2];
//        }
//        [s appendFormat:@"%@%@%@", k, d1, v];
//    }
//    // Post
//    [s appendString:post];
//    return s;
//}
//
//        + (NSString*) joinAsUrlParameter:(NSDictionary*)map {
//    return [FLStringKit join:map pre:@"" delimKV:@"=" delimEntry:@"&" post:@""];
//}

//    class func peekStringSize(_ key:String) {
//        let a = ["zh-Hans", "zh-Hant", "ja", "ko",
//                 "de", "en", "es", "fr", "it", "pt-BR", "ru",
//                 "Base"]
//        let n = a.count
//        var i = 0
//        var k = key
//        while (i < n) {
//            let ai = a[i]
//            let p = Bundle.main.path(forResource: ai, ofType: "lproj") ?? ""
//            let b = Bundle(path: p)
//            let s = b?.localizedString(forKey: k, value: "", table: nil) ?? ""
//            let w = CGSize(width: 100, height: .max)
//            let z = NSString(string: s).boundingRect(with: w, options: .usesLineFragmentOrigin, attributes: nil, context: nil)
//            let q = Self.measureSize(s, UIFont.systemFont(ofSize: 19), width: 100)
//            wqe("la = \(ai), s(\(s.count)) = \(s), w = \(w), z = \(z), q = \(q), p = \(p)")
//            i++
//        }
//    }

//    class func measureWrapHeight(_ t:UILabel) -> CGRect {
//        return Self.measureWrapContent(t, atMostWidth: t.frame.width.lf())
//    }
//
//    class func measureWrapWidth(_ t:UILabel) -> CGRect {
//        return Self.measureWrapContent(t, atMostHeight: t.frame.height.lf())
//    }

    class func measureWrapContent(_ t:Text, atMostWidth w: Double) -> CGRect {
        return Self.measureSize(Self.getText(t), t.font, width: w)
    }

    class func measureWrapContent(_ t:Text, atMostHeight h: Double) -> CGRect {
        return Self.measureSize(Self.getText(t), t.font, height: h)
    }

    class func getText(_ t:Text) -> String {
        #if os(iOS)
        return t.text ?? ""
        #elseif os(macOS)
        return t.string
        #else
        return ""
        #endif
    }

    // return the rect that measured as compact bounding rect for string in font
    // bottom + 1 is to make additional space for it, too compact may make text still truncated
    class func measureSize(_ str: String, _ font:Font?, width: Double) -> CGRect {
        return Self.measureSize(str, font, width, true)
    }

    // right + 1 is to make additional space for it, too compact may make text still truncated
    class func measureSize(_ str: String, _ font:Font?, height: Double) -> CGRect {
        return Self.measureSize(str, font, height, false)
    }

    private class func measureSize(_ str: String, _ font:Font?, _ value: Double, _ isW:Bool) -> CGRect {
        var attr : [NSAttributedString.Key : Any] = [:]
        if let f = font {
            attr[.font] = f
        }

        var z = CGSize(width: value, height: value)
        if (isW) {
            z = CGSize(width: value, height: 1.0 * Int.max)
        } else {
            z = CGSize(width: 1.0 * Int.max, height: value)
        }

        let r = NSString(string: str).boundingRect(with: z,
                options: .usesLineFragmentOrigin,
                attributes: attr,
                context: nil)

        var ans = CGRect.zero
        if (isW) {
            ans = CGRect(l: r.left, t: r.top, r: r.right, b: r.bottom + 1)
        } else {
            ans = CGRect(l: r.left, t: r.top, r: r.right + 1, b: r.bottom)
        }
        return ans
    }

}
