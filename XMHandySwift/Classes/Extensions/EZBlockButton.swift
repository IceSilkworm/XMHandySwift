//
//  EZBlockButton.swift
//
//
//  Created by Cem Olcay on 12/08/15.
//
//

#if os(iOS) || os(tvOS)

import UIKit

public typealias EZBlockButtonAction = (_ sender: EZBlockButton) -> Void

///Make sure you use  "[weak self] (sender) in" if you are using the keyword self inside the closure or there might be a memory leak
open class EZBlockButton: UIButton {
    // MARK: Propeties

    open var highlightLayer: CALayer?
    open var action: EZBlockButtonAction?

    // MARK: Init

    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        defaultInit()
    }

    public init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, action: EZBlockButtonAction?) {
        super.init (frame: CGRect(x: x, y: y, width: w, height: h))
        self.action = action
        defaultInit()
    }

    public init(action: @escaping EZBlockButtonAction) {
        super.init(frame: CGRect.zero)
        self.action = action
        defaultInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }

    public init(frame: CGRect, action: @escaping EZBlockButtonAction) {
        super.init(frame: frame)
        self.action = action
        defaultInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }

    private func defaultInit() {
        addTarget(self, action: #selector(EZBlockButton.didPressed(_:)), for: UIControl.Event.touchUpInside)
        //addTarget(self, action: #selector(BlockButton.highlight), for: [UIControlEvents.touchDown, UIControlEvents.touchDragEnter])
        addTarget(self, action: #selector(EZBlockButton.unhighlight), for: [
            .touchUpInside,
            .touchUpOutside,
            .touchCancel,
            .touchDragExit
        ])
        setTitleColor(UIColor.black, for: .normal)
        setTitleColor(UIColor.blue, for: .selected)
    }

    open func addAction(_ action: @escaping EZBlockButtonAction) {
        self.action = action
    }

    // MARK: Action

    @objc open func didPressed(_ sender: EZBlockButton) {
        action?(sender)
    }

    // MARK: Highlight

    open func highlight() {
        if action == nil {
            return
        }
        let highlightLayer = CALayer()
        highlightLayer.frame = layer.bounds
        highlightLayer.backgroundColor = UIColor.black.cgColor
        highlightLayer.opacity = 0.5
        var maskImage: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            maskImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        let maskLayer = CALayer()
        maskLayer.contents = maskImage?.cgImage
        maskLayer.frame = highlightLayer.frame
        highlightLayer.mask = maskLayer
        layer.addSublayer(highlightLayer)
        self.highlightLayer = highlightLayer
    }

    @objc open func unhighlight() {
        if action == nil {
            return
        }
        highlightLayer?.removeFromSuperlayer()
        highlightLayer = nil
    }
}

#endif
