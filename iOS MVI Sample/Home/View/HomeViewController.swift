import UIKit
import RxSwift
import RxCocoa

private struct Layout {
    let cellsInRow: CGFloat = 2
    let cellSpacing: CGFloat = 10
    let cellSectionInset = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: 10)
    let collectionContentInset = UIEdgeInsets(top: 10, left: .zero, bottom: .zero, right: .zero)
    let viewDisableAlpha: CGFloat = 0.5
    let viewEnableAlpha: CGFloat = 1
}

final class HomeViewController: RxView<HomePresenter, HomeInteractor> {

    private let layout = Layout()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = layout.collectionContentInset
        return collectionView
    }()

    private let searchBar = UISearchBar(forAutoLayout: true)
    private let loadingIndicator = UIActivityIndicatorView(forAutoLayout: true)

    override func setupHierarchy() {
        view.addSubviews([
            collectionView,
            searchBar,
            loadingIndicator
        ])
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    override func setupViews() {
        title = GenString.Home.View.title

        view.backgroundColor = GenColor.groupedBackground.color

        collectionView.backgroundColor = .clear
        collectionView.register(
            HomeCollectionViewCell.self,
            forCellWithReuseIdentifier: GenString.Home.Collection.DefaultCell.identifier
        )

        searchBar.tintColor = GenColor.blue.color
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.placeholder = GenString.Home.View.searchPlaceholder

        loadingIndicator.style = .large
        loadingIndicator.tintColor = GenColor.black.color
        loadingIndicator.hidesWhenStopped = true
    }

    override func setupBindings() {
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        inputViewModel
            .map { $0.restaurants }
            .drive(collectionView.rx.items(
                cellIdentifier: GenString.Home.Collection.DefaultCell.identifier,
                cellType: HomeCollectionViewCell.self
            ), curriedArgument: { (row, cellViewModel, cell) in
                cell.configureCell(with: cellViewModel)
            })
            .disposed(by: disposeBag)

        inputViewModel
            .map { $0.isLoading }
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        inputViewModel
            .map { !$0.isLoading }
            .do(onNext: { [weak self] searchBarEnabled in
                guard let self = self else { return }
                self.searchBar.alpha = searchBarEnabled ? self.layout.viewEnableAlpha : self.layout.viewDisableAlpha
            })
            .drive(searchBar.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .map { [weak self] in .searchValue(self?.searchBar.text) }
            .bind(to: outputCommand)
            .disposed(by: disposeBag)

        Observable
            .merge(
                searchBar.rx.cancelButtonClicked.asObservable(),
                searchBar.rx.searchButtonClicked.asObservable()
            )
            .asDriver(onErrorDriveWith: .empty())
            .drive(searchBar.rx.resignFirstResponder)
            .disposed(by: disposeBag)

        searchBar.rx.textDidBeginEditing
            .asDriver(onErrorDriveWith: .empty())
            .map { true }
            .drive(searchBar.rx.showsCancelButton)
            .disposed(by: disposeBag)

        searchBar.rx.textDidEndEditing
            .asDriver(onErrorDriveWith: .empty())
            .map { false }
            .drive(searchBar.rx.showsCancelButton)
            .disposed(by: disposeBag)
    }

    private func makeCollectionLayout() -> UICollectionViewLayout {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.sectionInset = layout.cellSectionInset
        collectionLayout.minimumLineSpacing = layout.cellSpacing
        collectionLayout.minimumInteritemSpacing = layout.cellSpacing

        return collectionLayout
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemSpacing = layout.cellSpacing * (layout.cellsInRow - 1)
        let sectionSpacing = layout.cellSectionInset.left + layout.cellSectionInset.right
        let cellTotalSpace = itemSpacing + sectionSpacing
        let cellWidth = (collectionView.bounds.width - cellTotalSpace) / layout.cellsInRow

        return CGSize(width: cellWidth, height: cellWidth)
    }
}
