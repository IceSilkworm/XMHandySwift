//
//  NSRangeExtension.swift
//  
//
//  Created by on 2017/8/30.
//  Copyright © 2017年. All rights reserved.
//

import Foundation

public extension NSRange {
    /**
     Init with location and length
     
     - parameter ts_location: location
     - parameter ts_length:   length
     
     - returns: NSRange
     */
    init(location:Int, length:Int) {
        self.init()
        self.location = location
        self.length = length
    }
    
    /**
     Init with location and length
     
     - parameter ts_location: location
     - parameter ts_length:   length
     
     - returns: NSRange
     */
    init(_ location:Int, _ length:Int) {
        self.init()
        self.location = location
        self.length = length
    }
    
    /**
     Init from Range
     
     - parameter ts_range:   Range
     
     - returns: NSRange
     */
    init(range:Range <Int>) {
        self.init()
        self.location = range.lowerBound
        self.length = range.upperBound - range.lowerBound
    }
    
    /**
     Init from Range
     
     - parameter ts_range:   Range
     
     - returns: NSRange
     */
    init(_ range:Range <Int>) {
        self.init()
        self.location = range.lowerBound
        self.length = range.upperBound - range.lowerBound
    }
    
    
    /// Get NSRange start index
    var startIndex:Int { get { return location } }
    
    /// Get NSRange end index
    var endIndex:Int { get { return location + length } }
    
    /// Convert NSRange to Range
    var asRange:Range<Int> { get { return location..<location + length } }
    
    /// Check empty
    var isEmpty:Bool { get { return length == 0 } }
    
    /**
     Check NSRange contains index
     
     - parameter index: index
     
     - returns: Bool
     */
    func contains(index:Int) -> Bool {
        return index >= location && index < endIndex
    }
    
    /**
     Get NSRange's clamp Index
     
     - parameter index: index
     
     - returns: Bool
     */
    func clamp(index:Int) -> Int {
        return max(self.startIndex, min(self.endIndex - 1, index))
    }
    
    /**
     Check NSRange intersects another NSRange
     
     - parameter range: NSRange
     
     - returns: Bool
     */
    func intersects(range:NSRange) -> Bool {
        return NSIntersectionRange(self, range).isEmpty == false
    }
    
    /**
     Get the two NSRange's intersection
     
     - parameter range: NSRange
     
     - returns: NSRange
     */
    func intersection(range:NSRange) -> NSRange {
        return NSIntersectionRange(self, range)
    }
    
    /**
     Get the two NSRange's union value
     
     - parameter range: NSRange
     
     - returns: NSRange
     */
    func union(range:NSRange) -> NSRange {
        return NSUnionRange(self, range)
    }
}


extension String {
    
    subscript(range:ClosedRange<Int>) -> String{
        let range = self.index(startIndex, offsetBy: range.lowerBound )...self.index(startIndex, offsetBy: range.upperBound)
        return String(self[range])
    }
    
    //range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }
    
    //NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}
