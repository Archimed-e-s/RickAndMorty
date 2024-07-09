import UIKit
import CoreData

final class FavouriteCollectionViewCell: UICollectionViewCell {

    static let id = UUID().uuidString
    var characterID = 0

    // MARK: - Private properties

    private lazy var favouriteImage = {
        let path = UIBezierPath(
        roundedRect: self.bounds,
        byRoundingCorners: [.topLeft, .topRight],
        cornerRadii: CGSize(width: 21, height: 21))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        let image = UIImageView(image: R.image.addedFavourites())
        image.toAutoLayout()
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        return image
    }()

    private lazy var greenView = {
        let greenView = UIView()
        greenView.toAutoLayout()
        greenView.backgroundColor = R.color.detailCellColor()
        return greenView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.font = R.font.interBold(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var nameLabelText: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = R.font.interRegular(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    // MARK: - Public Properties

    lazy var favouriteView: FavouriteView = {
        let view = FavouriteView()
        view.toAutoLayout()
        view.isUserInteractionEnabled = true
        return view
    }()

    lazy var detailView: DetailView = {
        let view = DetailView()
        view.toAutoLayout()
        view.isUserInteractionEnabled = true
        return view
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabelText.text = nil
        favouriteImage.image = nil
    }

    // MARK: - Private Methods

    private func configureUI() {
        contentView.addSubview(favouriteImage)
        contentView.addSubview(greenView)
        greenView.addSubview(nameLabel)
        greenView.addSubview(nameLabelText)
        favouriteImage.addSubview(favouriteView)
        greenView.addSubview(detailView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            favouriteImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            favouriteImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            favouriteImage.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            favouriteImage.heightAnchor.constraint(equalToConstant: contentView.frame.height-66),

            favouriteView.leadingAnchor.constraint(equalTo: favouriteImage.leadingAnchor, constant: 10),
            favouriteView.topAnchor.constraint(equalTo: favouriteImage.topAnchor, constant: 12),
            favouriteView.heightAnchor.constraint(equalToConstant: 54),
            favouriteView.widthAnchor.constraint(equalToConstant: 61),

            greenView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            greenView.topAnchor.constraint(equalTo: favouriteImage.bottomAnchor),
            greenView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            greenView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            detailView.topAnchor.constraint(equalTo: greenView.topAnchor, constant: -21),
            detailView.trailingAnchor.constraint(equalTo: greenView.trailingAnchor),
            detailView.heightAnchor.constraint(equalToConstant: 61),
            detailView.widthAnchor.constraint(equalToConstant: 63),

            nameLabel.topAnchor.constraint(equalTo: greenView.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant: 10),

            nameLabelText.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            nameLabelText.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant: 10),
            nameLabelText.bottomAnchor.constraint(equalTo: greenView.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Public Methods

    func configure(with model: Favourites) {
        characterID = Int(model.id)
        nameLabelText.text = model.name
        let url = URL(string: model.imageData ?? "")
        URLSession.shared.dataTask(with: url ?? URL(fileURLWithPath: "")) { (data, _ , _) in
            guard let imageData = data else { return }
            DispatchQueue.main.async {
                self.favouriteImage.image = UIImage(data: imageData)
            }
        }.resume()
    }
}
