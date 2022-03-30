//
//  StringExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//
// swiftlint:disable line_length

import CommonCrypto

#if os(OSX)
    import AppKit
#endif

#if os(iOS) || os(tvOS)
    import UIKit
#endif

extension String {
    /// EZSE: Init string with a base64 encoded string
    init ? (base64: String) {
        let pad = String(repeating: "=", count: base64.length % 4)
        let base64Padded = base64 + pad
        if let decodedData = Data(base64Encoded: base64Padded, options: NSData.Base64DecodingOptions(rawValue: 0)), let decodedString = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue) {
            self.init(decodedString)
            return
        }
        return nil
    }
    
    /// EZSE: length of string
    public var length: Int {
        return count;
    }
    
    /// EZSE: base64 encoded of string
    var base64: String {
        let plainData = (self as NSString).data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    /// EZSE: Cut string from integerIndex to the end
    public subscript(integerIndex: Int) -> Character {
        let index = self.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
    
    /// EZSE: Cut string from range
    public subscript(integerRange: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = self.index(startIndex, offsetBy: integerRange.upperBound)
        return String(self[start..<end])
    }
    
    /// EZSE: Counts number of instances of the input inside String
    public func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }
    
    /// EZSE: Capitalizes first character of String
    public mutating func capitalizeFirst() {
        guard length > 0 else { return }
        self.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
    }
    
    /// EZSE: Capitalizes first character of String, returns a new string
    public func capitalizedFirst() -> String {
        guard length > 0 else { return self }
        var result = self
        
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
        return result
    }
    
    /// EZSE: Checks if string is empty or consists only of whitespace and newline characters
    public var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    /// EZSE: Trims white space and new line characters
    public mutating func trim() {
        self = self.trimmed()
    }
    
    /// EZSE: Trims white space and new line characters, returns a new string
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// EZSE: Position of begining character of substing
    public func positionOfSubstring(_ subString: String, caseInsensitive: Bool = false, fromEnd: Bool = false) -> Int {
        if subString.isEmpty {
            return -1
        }
        var searchOption = fromEnd ? NSString.CompareOptions.anchored : NSString.CompareOptions.backwards
        if caseInsensitive {
            searchOption.insert(NSString.CompareOptions.caseInsensitive)
        }
        if let range = self.range(of: subString, options: searchOption), !range.isEmpty {
            return self.distance(from: self.startIndex, to: range.lowerBound)
        }
        return -1
    }
    
    /// EZSE: split string using a spearator string, returns an array of string
    public func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator).filter {
            !$0.trimmed().isEmpty
        }
    }
    
    /// EZSE: split string with delimiters, returns an array of string
    public func split(_ characters: CharacterSet) -> [String] {
        return self.components(separatedBy: characters).filter {
            !$0.trimmed().isEmpty
        }
    }
    
    /// EZSE: joined string with separator, returns an separator of string
    public func joined(_ separator: String) -> String {
        let r = self.map { (c) -> String in
            return String(c)
        }
        return r.joined(separator: separator)
    }
    
    /// EZSE: Checks if String contains Email
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    
    /// EZSE: Returns if String is a number
    public func isNumber() -> Bool {
        if NumberFormatter().number(from: self) != nil {
            return true
        }
        return false
    }
    
    /// EZSE: Extracts URLS from String
    public var extractURLs: [URL] {
        var urls: [URL] = []
        let detector: NSDataDetector?
        do {
            detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        } catch _ as NSError {
            detector = nil
        }
        
        let text = self
        
        if let detector = detector {
            detector.enumerateMatches(in: text, options: [], range: NSRange(location: 0, length: text.count), using: {(result: NSTextCheckingResult?, _, _) -> Void in
                if let result = result, let url = result.url {
                    urls.append(url)
                }
            })
        }
        
        return urls
    }
    
    /// EZSE: Checking if String contains input with comparing options
    public func contains(_ find: String, compareOption: NSString.CompareOptions) -> Bool {
        return self.range(of: find, options: compareOption) != nil
    }
    
    /// EZSE: Converts String to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Bool
    public func toBool() -> Bool? {
        let trimmedString = trimmed().lowercased()
        if trimmedString == "true" || trimmedString == "false" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }
    
    ///EZSE: Returns the first index of the occurency of the character in String
    public func getIndexOf(_ char: Character) -> Int? {
        for (index, c) in enumerated() where c == char {
            return index
        }
        return nil
    }
    
    /// EZSE: Converts String to NSString
    public var toNSString: NSString { return self as NSString }
    
    #if os(iOS)
    
    ///EZSE: Returns bold NSAttributedString
    public func bold() -> NSAttributedString {
        let boldString = NSMutableAttributedString(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
        return boldString
    }
    
    #endif
    
    ///EZSE: Returns underlined NSAttributedString
    public func underline() -> NSAttributedString {
        let underlineString = NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        return underlineString
    }
    
    #if os(iOS)
    
    ///EZSE: Returns italic NSAttributedString
    public func italic() -> NSAttributedString {
        let italicString = NSMutableAttributedString(string: self, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
        return italicString
    }
    
    #endif
    
    #if os(iOS) || os(tvOS)
    
    ///EZSE: Returns NSAttributedString
    public func color(_ color: UIColor) -> NSAttributedString {
        let colorString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
        return colorString
    }
    
    ///EZSE: Returns NSAttributedString
    public func colorSubString(_ subString: String, color: UIColor) -> NSMutableAttributedString {
        var start = 0
        var ranges: [NSRange] = []
        while true {
            let range = (self as NSString).range(of: subString, options: NSString.CompareOptions.literal, range: NSRange(location: start, length: (self as NSString).length - start))
            if range.location == NSNotFound {
                break
            } else {
                ranges.append(range)
                start = range.location + range.length
            }
        }
        let attrText = NSMutableAttributedString(string: self)
        for range in ranges {
            attrText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        return attrText
    }
    
    #endif
    
    /// EZSE: Checks if String contains Emoji
    public func includesEmoji() -> Bool {
        for i in 0...length {
            let c: unichar = (self as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }
    
    #if os(iOS)
    
    /// EZSE: copy string to pasteboard
    public func addToPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
    
    #endif
    
    // EZSE: URL encode a string (percent encoding special chars)
    public func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    // EZSE: URL encode a string (percent encoding special chars) mutating version
    mutating func urlEncode() {
        self = urlEncoded()
    }
    
    // EZSE: Removes percent encoding from string
    public func urlDecoded() -> String {
        return removingPercentEncoding ?? self
    }
    
    // EZSE : Mutating versin of urlDecoded
    mutating func urlDecode() {
        self = urlDecoded()
    }
    
    // EZSE : AppendingPathComponent
    public func appendingPathComponent(path: String) -> String{
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    // EZSE : escapedFilename
    func escapedFilename() -> String {
        return [ "\0":"%00", ":":"%3A", "/":"%2F" ]
            .reduce(self.components(separatedBy: "%").joined(separator: "%25")) {
                str, m in str.components(separatedBy: m.0).joined(separator: m.1)
        }
    }
    
    // EZSE : md5 String
    public var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }

    // EZSE : MD5Filename
    func fileNameMd5() -> String {
        // NSString.pathExtension alone could return a query string, which can lead to very long filenames.
        let pathExtension = URL(string: self)?.pathExtension ?? (self as NSString).pathExtension
        
        if pathExtension.length > 0 {
            return (md5 as NSString).appendingPathExtension(pathExtension) ?? md5
        } else {
            return md5
        }
    }
    
    // EZSE : URL Encode
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
}

extension String {
    init(_ value: Float, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
    
    init(_ value: Double, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
}

/// EZSE: Pattern matching of strings via defined functions
public func ~=<T> (pattern: ((T) -> Bool), value: T) -> Bool {
    return pattern(value)
}

/// EZSE: Can be used in switch-case
public func hasPrefix(_ prefix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasPrefix(prefix)
    }
}

/// EZSE: Can be used in switch-case
public func hasSuffix(_ suffix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasSuffix(suffix)
    }
}

/// EZSE: Creating random strings
public func getRandomStr(length: Int) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomStr = ""
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomStr += NSString(characters: &nextChar, length: 1) as String
    }
    return randomStr
}
