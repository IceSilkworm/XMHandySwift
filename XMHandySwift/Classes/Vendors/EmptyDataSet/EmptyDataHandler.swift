//
//  EmptyDataHandler.swift
//  SwiftKit
//
//  Created by ring on 2022/3/30.
//

import UIKit

public enum EmptyDataDisplayType {
    case Unknown
    case Error
    case NoResult
    case NoLogin
}

typealias EmptyDataButtonTappedBlock = ((EmptyDataDisplayType)->Void)

class EmptyDataHandler: NSObject {

    open var type: EmptyDataDisplayType = .NoResult
    open var errorDescription: String = ""
    open var noResultDescription: String = ""
    open var imageForEmptyDataSet: UIImage?
    open var buttonTappedCallback: EmptyDataButtonTappedBlock?

    init(_ buttonTappedCallback: EmptyDataButtonTappedBlock? = nil) {
        super.init()
        self.buttonTappedCallback = buttonTappedCallback
    }
}

extension EmptyDataHandler: EmptyDataSetSource, EmptyDataSetDelegate {

//MARK: - DZNEmptyDataSetSource
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = noResultDescription
        switch (type) {
        default:
            let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.pingFangMediumWithSize(14.auto())!, NSAttributedString.Key.foregroundColor: UIColor.init("#86989F")]
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes(attributes, range: NSRange(location: 0, length: text.length))
            if let _ = text.range(of: "\n\n"), let strPara = text.components(separatedBy: "\n\n").last, let strRange = text.range(of: strPara) {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .left
                paragraph.firstLineHeadIndent = 16.auto()
                paragraph.headIndent = 16.auto()
                paragraph.tailIndent = -16.auto()
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: text.nsRange(from: strRange))
            }
            return attributedString
        }
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = errorDescription
        switch (type) {
        default:
            let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.pingFangMediumWithSize(14.auto())!, NSAttributedString.Key.foregroundColor: UIColor.init("#86989F")]
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes(attributes, range: NSRange(location: 0, length: text.length))
            return attributedString
        }
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return imageForEmptyDataSet
    }

//    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
//        return config.imageAnimation
//    }

//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
//        return NSAttributedString(string: "text")
//    }

//    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
//        return imageForEmptyDataSet
//    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return .white
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -170.auto()
    }

    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 20.auto()
    }

    //MARK: - DZNEmptyDataSetDelegate Methods
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {

    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {

    }
}
