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




