//
//  Initializable.swift
//

import Foundation

public protocol InitializableClass: AnyObject {
    init()
}

public extension InitializableClass {
    init(_ block: (Self) -> Void) {
        self.init()
        block(self)
    }

    @discardableResult func with(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

public protocol InitializableStruct {
    init()
}

public extension InitializableStruct {
    init(_ block: (inout Self) -> Void) {
        self.init()
        block(&self)
    }

    @discardableResult mutating func with(_ block: (inout Self) -> Void) -> Self {
        block(&self)
        return self
    }
}
