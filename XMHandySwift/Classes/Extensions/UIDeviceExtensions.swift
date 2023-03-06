//
//  UIDeviceExtensions.swift
//  SwiftKit
//
//  Created by ring on 2022/3/30.
//

import DeviceKit

public extension UIDevice {
    static var isIphoneX: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        } else {
            return false
        }
    }

    static var statusBarHeight: CGFloat {
        UIApplication.shared.statusBarFrame.height
    }
    
    static var topSafeAreaWithoutStatusBarHeight: CGFloat {
        isIphoneX ? 24.0 : 0.0
    }
    
    static var navigationBarHeight: CGFloat {
        isIphoneX ? 88.0 : 64.0
    }

    static var bottomSafeAreaHeight: CGFloat {
        isIphoneX ? 34.0 : 0.0
    }
    
    static var tabBarHeight: CGFloat {
        isIphoneX ? 83.0 : 49.0
    }
    
    static var scale: CGFloat {
        UIScreen.main.scale
    }

    // https://uiiiuiii.com/screen/
    static var isScreenHeightLessTo667: Bool {
        UIScreen.main.bounds.size.height <= 667
    }
}

public extension Device {
    
}
