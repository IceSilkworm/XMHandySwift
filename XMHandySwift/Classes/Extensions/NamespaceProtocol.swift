//
//  NamespaceProtocol.swift
//  voicetotext_swift
//
//

import UIKit

extension String: NamespaceTrappable {}
extension Array: NamespaceTrappable {}
extension Dictionary: NamespaceTrappable {}
extension Float: NamespaceTrappable {}
extension Double: NamespaceTrappable {}
extension Int: NamespaceTrappable {}
extension UIView: NamespaceTrappable {}

/// 类型协议
protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let wrappedValue: T
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

extension NamespaceWrapper where T: UIView {

    @discardableResult
    public func addSuperView(superView: UIView) -> T {
        superView.addSubview(wrappedValue)
        return wrappedValue
    }

    /**
    @discardableResult
    public func layout(snapKitMaker: (ConstraintMaker) -> Void) -> T {
        wrappedValue.snp.makeConstraints { (make) in
            snapKitMaker(make)
        }
        return wrappedValue
    }
     */

    @discardableResult
    public func config(_ config: (T) -> Void) -> T {
        config(wrappedValue)
        return wrappedValue
    }
}




