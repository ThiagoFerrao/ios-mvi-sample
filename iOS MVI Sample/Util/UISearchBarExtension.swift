import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISearchBar {

    var resignFirstResponder: AnyObserver<Void> {
        return Binder(base) { base, _ in
            base.resignFirstResponder()
        }.asObserver()
    }

    var showsCancelButton: AnyObserver<Bool> {
        return Binder(base) { base, showsButton in
            base.showsCancelButton = showsButton
        }.asObserver()
    }
}
