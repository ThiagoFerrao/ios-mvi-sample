import UIKit
import RxSwift
import RxCocoa

private struct Layout {
    let cellsInRow: CGFloat = 2
    let cellSpacing: CGFloat = 10
    let cellSectionInset = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: 10)
    let collectionContentInset = UIEdgeInsets(top: 10, left: .zero, bottom: .zero, right: .zero)
}

final class HomeViewController: RxView<HomePresenter, HomeInteractor> {

    private let layout = Layout()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = layout.collectionContentInset
        return collectionView
    }()

    private let loadingIndicator = UIActivityIndicatorView(forAutoLayout: true)

    override func setupHierarchy() {
        view.addSubviews([
            collectionView,
            loadingIndicator
        ])
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    override func setupViews() {
        title = GenString.Home.View.title

        collectionView.backgroundColor = GenColor.groupedBackground.color
        collectionView.register(
            HomeCollectionViewCell.self,
            forCellWithReuseIdentifier: GenString.Home.Collection.DefaultCell.identifier
        )

        loadingIndicator.style = .large
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
