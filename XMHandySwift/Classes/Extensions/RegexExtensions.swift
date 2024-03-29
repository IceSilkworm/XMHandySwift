//
//  Regex.swift
//
//
//  Created by apple on 2017/11/14.
//  Copyright © 2017年. All rights reserved.
//

import UIKit

public struct Regex {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}


//swift 中新加操作符的时候需要先对其进行声明，告诉编译器这个符合其实是一个操作符合
//precedencegroup 定义了一个操作符的优先级别
precedencegroup MatchPrecedence {
    //associativity 定义了结合定律，多个同类操作符顺序出现的计算顺序
    associativity: none
    //higherThan 运算的优先级
    higherThan: DefaultPrecedence
}

//infix 表示定位的是一个中位操作符，意思是前后都是输入；
//其他的修饰子还包括prefix和postfix
infix operator =~: MatchPrecedence

public func =~(object: String, template: String) -> Bool {
    do {
        return try Regex(template).match(object)
    } catch _ {
        return false
    }
}


infix operator %%/*<--infix operator is required for custom infix char combos*/
/**
 * Brings back simple modulo syntax (was removed in swift 3)
 * Calculates the remainder of expression1 divided by expression2
 * The sign of the modulo result matches the sign of the dividend (the first number). For example, -4 % 3 and -4 % -3 both evaluate to -1
 * EXAMPLE:
 * print(12 %% 5)    // 2
 * print(4.3 %% 2.1) // 0.0999999999999996
 * print(4 %% 4)     // 0
 * NOTE: The first print returns 2, rather than 12/5 or 2.4, because the modulo (%) operator returns only the remainder. The second trace returns 0.0999999999999996 instead of the expected 0.1 because of the limitations of floating-point accuracy in binary computing.
 * NOTE: Int's can still use single %
 * NOTE: there is also .remainder which supports returning negatives as oppose to truncatingRemainder (aka the old %) which returns only positive.
 */
public func %% (left: CGFloat, right: CGFloat) -> CGFloat {
    return left.truncatingRemainder(dividingBy: right)
}

/**
 * Swift 3 removed the possibility to cast CGFloat to Bool. This method brings back this functionality.
 * JUSTIFICATION: Most other languages allow this functionality, and is familiar to the user the alternative is verbose code. Which makes code cognitively harder to read.
 * NOTE: Bool(Int(1)) still works natively
 * EXAMPLE: (expected results from other languages)
 * Bool(CGFloat(0))//false
 * Bool(CGFloat(-2))//true
 * Bool(CGFloat(20))//true
 * Bool(CGFloat.nan)//true
 */
public extension Bool {
    init(_ value: CGFloat) {
        self.init(value != 0)
    }
}

/// 邮箱匹配
let mail: String = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"

/// 匹配用户名 字面或者数字组合 4到16位
let Username: String = "^[a-z0-9_-]{4,16}$"

/// 匹配密码 字面加下划线，6到18位
let Password: String = "^[a-z0-9_-]{6,18}$"

/// 匹配16进制
let HexValue: String = "^#?([a-f0-9]{6}|[a-f0-9]{3})$"

///内容带分割符号 “Anne-Blair”
let Slug: String = "^[a-z0-9-]+$"

/// 匹配URL
let isURL: String = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"

/// 匹配IP地址
let IPAddress: String = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

/// 是HTML <center>内容<\center>  符合
let HTMLTag: String = "^<([a-z]+)([^<]+)*(?:>(.*)<\\/\\1>|\\s+\\/>)$"

/// 日期(年-月-日)
let isDate1: String = "(\\d{4}|\\d{2})-((1[0-2])|(0?[1-9]))-(([12][0-9])|(3[01])|(0?[1-9]))"

/// 日期(月/日/年)
let isDate2: String = "((1[0-2])|(0?[1-9]))/(([12][0-9])|(3[01])|(0?[1-9]))/(\\d{4}|\\d{2})"

/// 时间(小时:分钟, 24小时制)
let TimeFormat: String = "((1|0?)[0-9]|2[0-3]):([0-5][0-9])"

/// 是汉字
let isChinese: String = "^[\\u4e00-\\u9fa5]*$"

//是英文
let isEnglish: String = "^[a-zA-Z]*$"

/// 中文及全角标点符号(字符)
let ChineseParagraph: String = "[\\u3000-\\u301e\\ufe10-\\ufe19\\ufe30-\\ufe44\\ufe50-\\ufe6b\\uff01-\\uffee]"

/// 中国大陆固定电话号码
let fixedLineTelephone: String = "(\\d{4}-|\\d{3}-)?(\\d{8}|\\d{7})"

/// 中国大陆身份证号(15位或18位)
let IdNum: String = "\\d{15}(\\d\\d[0-9xX])?"

/// 手机号
let isIphoneNum: String = "1\\d{10}"

/// 邮政编码
let zipCode: String = "[1-9]\\d{5}"

/// 大于0的整数
let integer = "[1-9]\\d"

/// 字母
let letter  = "^[A-Z]+$"

