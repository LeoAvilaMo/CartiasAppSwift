import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        let r, g, b, a: CGFloat
        if hexSanitized.count == 6 {
            let start = hexSanitized.startIndex
            let rIndex = hexSanitized.index(start, offsetBy: 2)
            let gIndex = hexSanitized.index(start, offsetBy: 4)
            let bIndex = hexSanitized.index(start, offsetBy: 6)
            let rHex = String(hexSanitized[start..<rIndex])
            let gHex = String(hexSanitized[rIndex..<gIndex])
            let bHex = String(hexSanitized[gIndex..<bIndex])
            var rInt: UInt64 = 0, gInt: UInt64 = 0, bInt: UInt64 = 0
            Scanner(string: rHex).scanHexInt64(&rInt)
            Scanner(string: gHex).scanHexInt64(&gInt)
            Scanner(string: bHex).scanHexInt64(&bInt)
            r = CGFloat(rInt) / 255.0
            g = CGFloat(gInt) / 255.0
            b = CGFloat(bInt) / 255.0
            a = 1.0
        } else if hexSanitized.count == 8 {
            let start = hexSanitized.startIndex
            let rIndex = hexSanitized.index(start, offsetBy: 2)
            let gIndex = hexSanitized.index(start, offsetBy: 4)
            let bIndex = hexSanitized.index(start, offsetBy: 6)
            let aIndex = hexSanitized.index(start, offsetBy: 8)
            let rHex = String(hexSanitized[start..<rIndex])
            let gHex = String(hexSanitized[rIndex..<gIndex])
            let bHex = String(hexSanitized[gIndex..<aIndex])
            let aHex = String(hexSanitized[aIndex...])
            var rInt: UInt64 = 0, gInt: UInt64 = 0, bInt: UInt64 = 0, aInt: UInt64 = 0
            Scanner(string: rHex).scanHexInt64(&rInt)
            Scanner(string: gHex).scanHexInt64(&gInt)
            Scanner(string: bHex).scanHexInt64(&bInt)
            Scanner(string: aHex).scanHexInt64(&aInt)
            r = CGFloat(rInt) / 255.0
            g = CGFloat(gInt) / 255.0
            b = CGFloat(bInt) / 255.0
            a = CGFloat(aInt) / 255.0
        } else {
            self.init(white: 1.0, alpha: 1.0)
            return
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
