import UIKit

extension UIView {

    static var identifier: String { String(describing: self) }

    func toAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
