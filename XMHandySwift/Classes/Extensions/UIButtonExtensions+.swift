//
//  UIButtonExtension.swift
//  
//
//  Created by on 2017/8/23.
//  Copyright © 2017年. All rights reserved.
//

//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit

extension UIButton {
    /// This method sets an image and title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    @objc public func set(image: UIImage?, title: String, titlePosition: UIView.ContentMode, additionalSpacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        titleLabel?.contentMode = .center
        setTitle(title, for: state)
    }
    
    /// This method sets an image and an attributed title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button attributed title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    @objc public func set(image: UIImage?, attributedTitle title: NSAttributedString, at position: UIView.ContentMode, width spacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        
        adjust(title: title, at: position, with: spacing)
        
        titleLabel?.contentMode = .center
        setAttributedTitle(title, for: state)
    }
    
    
    // MARK: Private Methods
    private func adjust(title: NSAttributedString, at position: UIView.ContentMode, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        let titleSize = title.size()
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func adjust(title: NSString, at position: UIView.ContentMode, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIView.ContentMode, spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func arrange(titleSize: CGSize, imageRect:CGRect, atPosition position: UIView.ContentMode, withSpacing spacing: CGFloat) {
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position) {
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        titleEdgeInsets = titleInsets
        imageEdgeInsets = imageInsets
    }
}


extension UIControl {
    
    /// 闭包内部实现实现事件响应
    public func handleControlEvent(events controlEvent: UIControl.Event = .touchUpInside, completionHandle: @escaping(_ sender: UIControl) -> ()) -> Void {
        
        objc_setAssociatedObject(self, SenderAssociatedKeys.callBlockKey!, completionHandle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(callActionBlock(_:)), for: controlEvent)
    }
    
    @objc func callActionBlock(_ control: AnyObject) -> () {
        let block = objc_getAssociatedObject(self, SenderAssociatedKeys.callBlockKey!) as? ((_ sender: UIControl) -> ())
        block?(self)
    }
    
    /// 使用Runtime在分类Extension中添加属性
    public var context: String? {
        set { objc_setAssociatedObject(self, UnsafeRawPointer.init(bitPattern: SenderAssociatedKeys.bitPatternKey.hashValue)!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
        get { objc_getAssociatedObject(self, UnsafeRawPointer.init(bitPattern: SenderAssociatedKeys.bitPatternKey.hashValue)!) as? String }
    }
    
    //【推荐】
    private struct SenderAssociatedKeys {
        /// ...其他Key声明

        static let callBlockKey = UnsafeRawPointer.init(bitPattern: "callBlockKey".hashValue)
        static let bitPatternKey = "bitPatternKey"
    }
    
}
