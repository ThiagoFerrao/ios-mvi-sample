import UIKit

extension UIView {
    convenience init(forAutoLayout: Bool) {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = !forAutoLayout
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
