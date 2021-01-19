import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: RxView<HomePresenter, HomeInteractor> {

    private lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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

        view.backgroundColor = .white

        collectionView.backgroundColor = .clear
        collectionView.register(
            HomeCollectionViewCell.self,
            forCellWithReuseIdentifier: GenString.Home.Collection.DefaultCell.identifier
        )

        loadingIndicator.style = .large
        loadingIndicator.hidesWhenStopped = true
    }

    override func setupBindings() {
        super.setupBindings()

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
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.width / 2) - 10
        let cellHeight = cellWidth / 0.9
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
