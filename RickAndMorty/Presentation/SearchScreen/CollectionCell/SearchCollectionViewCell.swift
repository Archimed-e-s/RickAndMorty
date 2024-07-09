import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    static let id = UUID().uuidString
    var imageData: String?
    var characterID = 0
    var characterName: String?

    // MARK: - Private properties

    private lazy var characterImage = {
        let path = UIBezierPath(
        roundedRect: bounds,
        byRoundingCorners: [.topLeft, .topRight],
        cornerRadii: CGSize(width: 21, height: 21))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        let image = UIImageView()
        image.toAutoLayout()
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        return image
    }()

    private let greenBackground = {
        let background = UIView()
        background.toAutoLayout()
        background.backgroundColor = R.color.detailCellColor()
        return background
    }()
    private let planetLabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interBold(size: 20)
        label.textColor = .black
        label.text = "Planet:"
        label.textAlignment = .left
        return label
    }()

    private let planetLabelText = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interRegular(size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private let nameLabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interBold(size: 20)
        label.textColor = .black
        label.text = "Name:"
        label.textAlignment = .left
        return label
    }()

    private let nameLabelText = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interRegular(size: 20)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

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
        setupView()
        setupConstraints()
        prepareForReuse()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()
        favouriteView.favoriteImage.image = R.image.notAddedFavourites()
        characterImage.image = nil
        planetLabelText.text = nil
        nameLabelText.text = nil
    }

    // MARK: - Private Methods

    private func setupView() {
        contentView.addSubview(characterImage)
        contentView.addSubview(greenBackground)
        characterImage.addSubview(favouriteView)
        greenBackground.addSubview(nameLabel)
        greenBackground.addSubview(nameLabelText)
        greenBackground.addSubview(planetLabel)
        greenBackground.addSubview(planetLabelText)
        greenBackground.addSubview(detailView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            characterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImage.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            characterImage.heightAnchor.constraint(equalToConstant: contentView.frame.height - 140),

            favouriteView.leadingAnchor.constraint(equalTo: characterImage.leadingAnchor, constant: 10),
            favouriteView.topAnchor.constraint(equalTo: characterImage.topAnchor, constant: 12),
            favouriteView.heightAnchor.constraint(equalToConstant: 54),
            favouriteView.widthAnchor.constraint(equalToConstant: 61),

            greenBackground.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            greenBackground.heightAnchor.constraint(equalToConstant: 140),
            greenBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            greenBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            planetLabel.topAnchor.constraint(equalTo: greenBackground.topAnchor, constant: 11),
            planetLabel.leadingAnchor.constraint(equalTo: greenBackground.leadingAnchor, constant: 16),

            planetLabelText.topAnchor.constraint(equalTo: planetLabel.bottomAnchor, constant: 3),
            planetLabelText.leadingAnchor.constraint(equalTo: greenBackground.leadingAnchor, constant: 16),
            planetLabelText.trailingAnchor.constraint(equalTo: greenBackground.trailingAnchor, constant: -16),

            nameLabel.topAnchor.constraint(equalTo: planetLabelText.bottomAnchor, constant: 9),
            nameLabel.leadingAnchor.constraint(equalTo: greenBackground.leadingAnchor, constant: 16),

            nameLabelText.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            nameLabelText.leadingAnchor.constraint(equalTo: greenBackground.leadingAnchor, constant: 16),

            detailView.topAnchor.constraint(equalTo: greenBackground.topAnchor, constant: -21),
            detailView.trailingAnchor.constraint(equalTo: greenBackground.trailingAnchor),
            detailView.heightAnchor.constraint(equalToConstant: 61),
            detailView.widthAnchor.constraint(equalToConstant: 63)
        ])
    }

    // MARK: - Public Methods

    func configure(with model: SearchCollectionModelCell) {
        let characterURL = model.characterImageURL?.absoluteString
        characterID = model.characterID
        characterName = model.characterName
        imageData = characterURL
        nameLabelText.text = model.characterName
        planetLabelText.text = model.planetNameText
        characterID = model.characterID
        model.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.characterImage.image = image
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
