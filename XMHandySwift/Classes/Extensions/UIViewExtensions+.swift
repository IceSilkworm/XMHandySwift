//
//  UIViewExtensions.swift
//  EZSwiftExtensions
//
//

#if os(iOS) || os(tvOS)

import UIKit


// MARK: - Properties
public extension UIView {
    
    
    /// SwifterSwift: Size of view.
    var yy_size: CGSize {
        get {
            return frame.size
        }
        set {
            yy_width = newValue.width
            yy_height = newValue.height
        }
    }
    
    /// SwifterSwift: Width of view.
    var yy_width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    /// SwifterSwift: Height of view.
    var yy_height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    /// SwifterSwift: x origin of view.
    var yy_x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    /// SwifterSwift: y origin of view.
    var yy_y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    /// SwifterSwift: Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }


}


// MARK: Layer Extensions
public extension UIView {
    /// EZSwiftExtensions
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func setCornerRadius(byRoundingCorners corners: UIRectCorner, radii: CGFloat, rect: CGRect = CGRect.zero) {
        guard corners != .allCorners else {
            layer.cornerRadius = radii
            layer.masksToBounds = true
            return
        }
        let frame = rect == .zero ? bounds : rect
        let maskPath = UIBezierPath(roundedRect: frame, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

    //TODO: add this to readme
    /// EZSwiftExtensions
    func setCornerShadow(shadowOffset: CGSize, shadowRadius: CGFloat, shadowColor: UIColor, shadowOpacity: Float, roundingCorners: UIRectCorner, cornerRadius: CGFloat? = nil) {
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor.cgColor
        if let r = cornerRadius {
            self.layer.cornerRadius = r
            let shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: r, height: r))
            self.layer.shadowPath = shadowPath.cgPath
        }
    }
}


public extension UIView {
    ///EZSE: Loops until it finds the top root view. //TODO: Add to readme
    var rootView: UIView {
        guard let parentView = superview else {
            return self
        }
        return parentView.rootView
    }
    
    ///EZSE: Loops until it finds the top root view controller. //TODO: Add to readme
    var viewController: UIViewController? {
        for view in sequence(first: self.superview, next: {$0?.superview}){
            if let responder = view?.next{
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}

// MARK: Fade Extensions
public let UIViewDefaultFadeDuration: TimeInterval = 0.4

public extension UIView {
    ///EZSE: Fade in with duration, delay and completion block.
    func fadeIn(_ duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        fadeTo(1.0, duration: duration, delay: delay, completion: completion)
    }

    /// EZSwiftExtensions
    func fadeOut(_ duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        fadeTo(0.0, duration: duration, delay: delay, completion: completion)
    }

    /// Fade to specific value	 with duration, delay and completion block.
    func fadeTo(_ value: CGFloat, duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration ?? UIViewDefaultFadeDuration, delay: delay ?? UIViewDefaultFadeDuration, options: .curveEaseInOut, animations: {
            self.alpha = value
        }, completion: completion)
    }
}

/// MARK: EZSwiftExtensions DrawBoardDottedLine
///
public extension UIView {

    func drawBoardDottedLine(width: CGFloat, length: CGFloat, space: CGFloat, cornerRadius: CGFloat, color: UIColor){
        self.layer.cornerRadius = cornerRadius
        let borderLayer =  CAShapeLayer()
        borderLayer.bounds = self.bounds

        borderLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY);
        borderLayer.path = UIBezierPath(roundedRect: borderLayer.bounds, cornerRadius: cornerRadius).cgPath
        borderLayer.lineWidth = width / UIScreen.main.scale

        //虚线边框---小边框的长度

        borderLayer.lineDashPattern = [length, space] as? [NSNumber] //前边是虚线的长度，后边是虚线之间空隙的长度
        borderLayer.lineDashPhase = 0.1;
        //实线边框

        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        self.layer.addSublayer(borderLayer)
    }
}

#endif
