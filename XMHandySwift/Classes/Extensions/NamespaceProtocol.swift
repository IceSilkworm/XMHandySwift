//
//  NamespaceProtocol.swift
//  voicetotext_swift
//
//

import UIKit

/// 类型协议
protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    let wrappedValue: T
    init(value: T) {
        self.wrappedValue = value
    }
}

/// 命名空间协议
public protocol NamespaceTrappable {
    associatedtype WrapperType
    var eg: WrapperType { get }
    static var eg: WrapperType.Type { get }
}

public extension NamespaceTrappable {
    var eg: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    
    static var eg: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}
