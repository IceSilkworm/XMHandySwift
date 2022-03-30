//
//  JSONSerializationExtension.swift
//  
//
//  Created by on 2017/9/1.
//  Copyright © 2017年. All rights reserved.
//

import Foundation

public extension JSONSerialization {
    /// JSONString转换为字典
    ///
    /// - Parameter jsonString: 字符串
    /// - Returns: dictionary
    class func getDictionaryFromJSONString(jsonString:String) -> NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        
        guard let mDict = dict else {
            return NSDictionary()
        }
        
        return mDict as! NSDictionary
    }
    
    /**
     字典转换为JSONString
     
     - parameter dictionary: 字典参数
     
     - returns: JSONString
     */
    class func getJSONStringFromDictionary(dictionary: NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }

}

public func JsonFromFilePath(fileName: String, inDirectory subPath: String = "", bundle:Bundle = Bundle.main ) -> Data {
    guard let path = bundle.path(forResource: fileName, ofType: "json", inDirectory: subPath) else { return Data() }

    if let dataString = try? String(contentsOfFile: path), let data = dataString.data(using: String.Encoding.utf8){
        return data
    } else {
        return Data()
    }
}


