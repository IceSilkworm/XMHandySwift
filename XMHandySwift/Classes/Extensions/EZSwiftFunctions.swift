//
//  EZSwiftFunctions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 13/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

//TODO: others standart video, gif

import UIKit

public struct ez {
    
    /// - debug: Application is running in debug mode.
    /// - testFlight: Application is installed from Test Flight.
    /// - appStore: Application is installed from the App Store.
    enum Environment {
        /// SwifterSwift: Application is running in debug mode.
        case debug
        /// SwifterSwift: Application is installed from Test Flight.
        case testFlight
        /// SwifterSwift: Application is installed from the App Store.
        case appStore
    }

    /// SwifterSwift: Current inferred app environment.
    static var inferredEnvironment: Environment {
        #if DEBUG
        return .debug

        #elseif targetEnvironment(simulator)
        return .debug

        #else
        if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
            return .testFlight
        }

        guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
            return .debug
        }

        if appStoreReceiptUrl.lastPathComponent.lowercased() == "sandboxreceipt" {
            return .testFlight
        }

        if appStoreReceiptUrl.path.lowercased().contains("simulator") {
            return .debug
        }

        return .appStore
        #endif
    }
    
    /// EZSE: Returns app's name
    static var appDisplayName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    }

    /// EZSE: Returns app's version number
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    /// EZSE: Return app's build number
    static var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }

    /// EZSE: Return app's bundle ID
    static var appBundleID: String {
        return Bundle.main.bundleIdentifier ?? ""
    }

    /// EZSE: Return device version ""
    static var deviceVersion: String {
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
    
    #if !os(macOS)
    /// EZSE: Returns true if app is running in test flight mode
    /// Acquired from : http://stackoverflow.com/questions/12431994/detect-testflight
    static var isInTestFlight: Bool {
        return Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") == true 
    }
    #endif

    #if os(iOS) || os(tvOS)


    #if os(iOS)

    /// EZSE: Returns current screen orientation
    static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }

    #endif
    
    #endif
    
    #if os(iOS) || os(tvOS)

    /// EZSE: Returns screen width
    static var screenWidth: CGFloat {

        #if os(iOS)

        if screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.width
        } else {
            return UIScreen.main.bounds.size.height
        }

        #elseif os(tvOS)

        return UIScreen.main.bounds.size.width

        #endif
    }

    /// EZSE: Returns screen height
    static var screenHeight: CGFloat {

        #if os(iOS)

        if screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.height
        } else {
            return UIScreen.main.bounds.size.width
        }

        #elseif os(tvOS)

            return UIScreen.main.bounds.size.height

        #endif
    }
    
    #endif

    #if os(iOS)

    /// EZSE: Returns StatusBar height
    static var screenStatusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    /// EZSE: Return screen's height without StatusBar
    static var screenHeightWithoutStatusBar: CGFloat {
        if screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.height - screenStatusBarHeight
        } else {
            return UIScreen.main.bounds.size.width - screenStatusBarHeight
        }
    }

    #endif

    /// EZSE: Returns the locale country code. An example value might be "ES". //TODO: Add to readme
    static var currentRegion: String? {
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String
    }
    
    #if os(iOS) || os(tvOS)

    /// EZSE: Calls action when a screen shot is taken
    static func detectScreenShot(_ action: @escaping () -> Void) {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: mainQueue) { _ in
            // executes after screenshot
            action()
        }
    }
    
    #endif

    //TODO: Document this, add tests to this
    /// EZSE: Iterates through enum elements, use with (for element in ez.iterateEnum(myEnum))
    /// http://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type
    static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafePointer(to: &i) { $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee } }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }

    // MARK: - Dispatch

    /// EZSE: Runs the function after x seconds
    static func dispatchDelay(_ second: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(second * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    /// EZSE: Runs function after x seconds
    static func runThisAfterDelay(seconds: Double, after: @escaping () -> Void) {
        runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
    }

    //TODO: Make this easier
    /// EZSE: Runs function after x seconds with dispatch_queue, use this syntax: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
    static func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> Void) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }

    /// EZSE: Submits a block for asynchronous execution on the main queue
    static func runThisInMainThread(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }

    /// EZSE: Runs in Default priority queue
    static func runThisInBackground(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }

    /// EZSE: Runs every second, to cancel use: timer.invalidate()
    @discardableResult
    static func runThisEvery(
        seconds: TimeInterval,
        startAfterSeconds: TimeInterval,
        handler: @escaping (CFRunLoopTimer?) -> Void) -> Timer {
        let fireDate = startAfterSeconds + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, seconds, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }
    
}

extension ez {
    
    /// EZSwiftExtensions
    static func deviceLanguage() -> String {
        return Bundle.main.preferredLocalizations[0]
    }
    
    //TODO: Fix syntax, add docs and readme for these methods:
    //TODO: Delete isSystemVersionOver()
    // MARK: - Device Version Checks
    enum UIDeviceVersions: Float {
        case ten = 10.0
        case eleven = 11.0
    }
    
    static func isVersion(_ version: UIDeviceVersions) -> Bool {
        return  (UIDevice.current.systemVersion as NSString).floatValue >= version.rawValue && (UIDevice.current.systemVersion as NSString).floatValue <  (version.rawValue + 1.0)
    }
    
    static func isVersionOrLater(_ version: UIDeviceVersions) -> Bool {
        return  (UIDevice.current.systemVersion as NSString).floatValue >= version.rawValue
    }
    
    /// EZSwiftExtensions
    static func isSystemVersionOver(_ requiredVersion: String) -> Bool {
        switch UIDevice.current.systemVersion.compare(requiredVersion, options: NSString.CompareOptions.numeric) {
        case .orderedSame, .orderedDescending:
            return true
        case .orderedAscending:
            return false
        }
    }
}

/// EZSE: Pattern matching of strings via defined functions
public func ~=<T> (pattern: ((T) -> Bool), value: T) -> Bool {
    return pattern(value)
}
