// UIFontExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(UIKit)
import UIKit

// MARK: - Properties

public extension UIFont {
    /// SwifterSwift: Font as bold font.
    var bold: UIFont {
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
    }

    /// SwifterSwift: Font as italic font.
    var italic: UIFont {
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitItalic)!, size: 0)
    }

    /// SwifterSwift: Font as monospaced font.
    ///
    ///     UIFont.preferredFont(forTextStyle: .body).monospaced
    ///
    var monospaced: UIFont {
        let settings = [[
            UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
            UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
        ]]

        let attributes = [UIFontDescriptor.AttributeName.featureSettings: settings]
        let newDescriptor = fontDescriptor.addingAttributes(attributes)
        return UIFont(descriptor: newDescriptor, size: 0)
    }

    /*
     苹方主族有 PingFang TC，PingFang HK，PingFang SC三种，具体释义就不添加了
...
family: PingFang TC
	font: PingFangTC-Regular
	font: PingFangTC-Thin
	font: PingFangTC-Medium
	font: PingFangTC-Semibold
	font: PingFangTC-Light
	font: PingFangTC-Ultralight
-------------
family: PingFang HK
	font: PingFangHK-Medium
	font: PingFangHK-Thin
	font: PingFangHK-Regular
	font: PingFangHK-Ultralight
	font: PingFangHK-Semibold
	font: PingFangHK-Light
-------------
family: PingFang SC
	font: PingFangSC-Medium
	font: PingFangSC-Semibold
	font: PingFangSC-Light
	font: PingFangSC-Ultralight
	font: PingFangSC-Regular//UI要求的fontName
	font: PingFangSC-Thin
-------------
...
      */

    func setFontWithSize(_ size:CGFloat)->UIFont?{
        let font : UIFont? = UIFont(name: "PingFangSC-Regular", size: size) ?? UIFont(name: "HelveticaNeue-Regular", size: size)
        return font
    }

    class func pingFangBoldWithSize(_ size:CGFloat)->UIFont? {
        return UIFont(name: "PingFangSC-Semibold", size: size)
    }

    class func pingFangMediumWithSize(_ size:CGFloat)->UIFont? {
        return UIFont(name: "PingFangSC-Medium", size: size)
    }

    class func pingFangLightWithSize(_ size:CGFloat)->UIFont? {
        return UIFont(name: "PingFangSC-Light", size: size)
    }

    class func pingFangRegularWithSize(_ size:CGFloat)->UIFont? {
        return UIFont(name: "PingFangSC-Regular", size: size)
    }

}

extension UIFont {
    /// boundingRect height
    func sizeHeightOfString (string: String, constrainedToWidth width: Double) -> CGFloat {
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: string).boundingRect(
                with: CGSize(width: width, height: .greatestFiniteMagnitude),
                options: options,
                attributes: [NSMutableAttributedString.Key.font: self],
                context: nil).size.height
    }

    /// boundingRect width
    func sizeWidthOfString (string: String, constrainedToHeight height: Double) -> CGFloat {
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: string).boundingRect(
                with: CGSize(width: .greatestFiniteMagnitude, height: height),
                options: options,
                attributes: [NSMutableAttributedString.Key.font: self],
                context: nil).size.width
    }
}

#endif
