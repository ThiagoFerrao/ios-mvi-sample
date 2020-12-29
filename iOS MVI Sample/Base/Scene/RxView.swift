import UIKit
import RxSwift
import RxCocoa

protocol RxViewing {
    associatedtype Command
    associatedtype ViewModel

    var disposeBag: DisposeBag { get }
    var inputViewModel: Observable<ViewModel> { get }
    var outputCommand: PublishSubject<Command> { get }

    func setupViews()
    func setupBindings()
    func setupConstraints()
    func configure(with viewModel: ViewModel)
}

class RxView<Command, ViewModel: Equatable, View: UIView>: UIViewController, RxViewing {

    init(screenBinding: ((Observable<Command>) -> Observable<ViewModel>)) {
        inputViewModel = screenBinding(outputCommand)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(GenString.Development.Assertion.initUnimplemented)
    }

    deinit {
        outputCommand.onCompleted()
    }

    final let disposeBag = DisposeBag()

    final let inputViewModel: Observable<ViewModel>

    final let outputCommand = PublishSubject<Command>()

    override func loadView() {
        view = View()
    }

    final override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
        setupConstraints()
    }

    func setupViews() { }

    func setupBindings() {
        inputViewModel
            .asDriver(onErrorDriveWith: .empty())
            .distinctUntilChanged()
            .drive(onNext: { [weak self] in self?.configure(with: $0) })
            .disposed(by: disposeBag)
    }

    func setupConstraints() { }

    func configure(with viewModel: ViewModel) { }
}
