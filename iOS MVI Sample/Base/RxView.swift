import UIKit
import RxSwift
import RxCocoa

protocol RxViewing {
    associatedtype Command
    associatedtype ViewModel

    var inputViewModel: Observable<ViewModel> { get }
    var outputCommand: PublishSubject<Command> { get }
    var disposeBag: DisposeBag { get }
}

class RxView<Command, ViewModel: Equatable, StatusView: UIView>: UIViewController, RxViewing {

    init(screenBinding: ((Observable<Command>) -> Observable<ViewModel>)) {
        inputViewModel = screenBinding(outputCommand)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }

    deinit {
        outputCommand.onCompleted()
    }

    let statusView = StatusView()

    let inputViewModel: Observable<ViewModel>

    let outputCommand = PublishSubject<Command>()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }

    func setupViews() {
        view.addSubview(statusView)

        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: view.topAnchor),
            statusView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            statusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        statusView.isHidden = true
    }

    func setupBindings() {
        inputViewModel
            .asDriver(onErrorDriveWith: .empty())
            .distinctUntilChanged()
            .drive(onNext: { [weak self] in self?.configure(with: $0) })
            .disposed(by: disposeBag)
    }

    func configure(with viewModel: ViewModel) {
        preconditionFailure("This method must be overridden")
    }
}
