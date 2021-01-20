import UIKit

private struct Layout {
    let screenMargin: CGFloat = 10
    let contentCornerRadius: CGFloat = 10
    let contentBorderWidth: CGFloat = 2
    let labelMargin: CGFloat = 4
    let labelNumberOfLines = 2
    let labelScaleFactor: CGFloat = 0.8
}

final class HomeCollectionViewCell: UICollectionViewCell {

    private let layout = Layout()

    private let stackView = UIStackView(forAutoLayout: true)
    private let nameLabel = UILabel(forAutoLayout: true)
    private let addressLabel = UILabel(forAutoLayout: true)
    private let cuisinesLabel = UILabel(forAutoLayout: true)
    private let timingsLabel = UILabel(forAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }

    private func viewInit() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

    private func buildViewHierarchy() {
        stackView.addArrangedSubviews([
            nameLabel,
            addressLabel,
            cuisinesLabel,
            timingsLabel
        ])

        contentView.addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.screenMargin),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -layout.screenMargin),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: layout.screenMargin),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -layout.screenMargin)
        ])
    }

    private func configureViews() {
        contentView.layer.cornerRadius = layout.contentCornerRadius
        contentView.layer.borderWidth = layout.contentBorderWidth
        contentView.layer.borderColor = GenColor.black.color.cgColor
        contentView.backgroundColor = GenColor.blue.color

        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        [nameLabel, addressLabel, cuisinesLabel, timingsLabel].forEach { cellLabel in
            cellLabel.textAlignment = .center
            cellLabel.numberOfLines = layout.labelNumberOfLines
            cellLabel.adjustsFontSizeToFitWidth = true
            cellLabel.minimumScaleFactor = layout.labelScaleFactor
        }
    }

    func configureCell(with model: HomeRestaurantModel) {
        nameLabel.text = model.name
        addressLabel.text = model.address
        cuisinesLabel.text = model.cuisines
        timingsLabel.text = model.timings
    }
}
