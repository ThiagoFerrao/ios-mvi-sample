import UIKit
import RxSwift
import RxCocoa

protocol RxViewing {
    associatedtype Command
    associatedtype ViewModel

    var disposeBag: DisposeBag { get }
    var inputViewModel: Driver<ViewModel> { get }
    var outputCommand: PublishSubject<Command> { get }

    func setupHierarchy()
    func setupConstraints()
    func setupViews()
    func setupBindings()
    func configure(with viewModel: ViewModel)
}

class RxView<Presenter: RxPresenting, Interactor: RxInteracting>: UIViewController, PresentableViewController, RxViewing {
    typealias Command = Interactor.Command
    typealias ViewModel = Presenter.ViewModel

    final let presenter: Presenter
    final let interactor: Interactor

    final let inputViewModel: Driver<ViewModel>
    final let outputCommand = PublishSubject<Command>()
    final let disposeBag = DisposeBag()

    init(
        presenter: Presenter,
        interactor: Interactor,
        screenBinding: ((Observable<Command>) -> Observable<ViewModel>)
    ) {
        self.presenter = presenter
        self.interactor = interactor
        self.inputViewModel = screenBinding(outputCommand)
            .asDriver(onErrorDriveWith: .empty())
            .distinctUntilChanged()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(GenString.Development.Assertion.initUnimplemented)
    }

    deinit {
        outputCommand.onCompleted()
    }

    final override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupConstraints()
        setupViews()
        setupBindings()
    }

    func setupHierarchy() { }

    func setupConstraints() { }

    func setupViews() { }

    func setupBindings() {
        inputViewModel
            .drive(onNext: { [weak self] in self?.configure(with: $0) })
            .disposed(by: disposeBag)
    }

    func configure(with viewModel: ViewModel) { }
}
