import UIKit

final class CharcterCollectionViewCell: UICollectionViewCell {

    static let id = UUID().uuidString
    var imageData: String?
    var characterID = 0
    var characterName: String?

    // MARK: - Private properties

    private lazy var planetLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interBold(size: 15)
        label.textColor = R.color.whiteCollectionViewColor()
        label.text = "Planet:"
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interBold(size: 15)
        label.textColor = R.color.whiteCollectionViewColor()
        label.text = "Name:"
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interBold(size: 15)
        label.textColor = R.color.whiteCollectionViewColor()
        label.text = "Status:"
        return label
    }()

    private lazy var createLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interBold(size: 15)
        label.textColor = R.color.whiteCollectionViewColor()
        label.text = "Created:"
        return label
    }()

    private lazy var planetLabelText: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interRegular(size: 15)
        label.textColor = R.color.whiteCollectionViewColor()
        return label
    }()

    private lazy var nameLabelText: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interRegular(size: 15)
        label.textColor = R.color.whiteCollectionViewColor()
        return label
    }()

    private lazy var statusLabelText: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interRegular(size: 15)
        label.textColor = R.color.whiteCollectionViewColor()
        return label
    }()

    private lazy var createLabelText: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = R.font.interRegular(size: 15)
        label.textColor = R.color.whiteCollectionViewColor()
        return label
    }()

    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 30
        image.isUserInteractionEnabled = true
        return image
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
        backgroundColor = .clear
        configureUI()
        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        favouriteView.favoriteImage.image = R.image.notAddedFavourites()
        planetLabelText.text = nil
        nameLabelText.text = nil
        statusLabelText.text = nil
        createLabelText.text = nil
        iconImage.image = nil
    }

    // MARK: - Public Methods

    private func configureUI() {
        [
            planetLabel,
            planetLabelText,
            nameLabel,
            nameLabelText,
            statusLabel,
            statusLabelText,
            createLabel,
            createLabelText,
            iconImage,
            detailView
        ].forEach({
            contentView.addSubview($0)
        })
        iconImage.addSubview(favouriteView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            planetLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 37),
            planetLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            planetLabelText.centerYAnchor.constraint(equalTo: planetLabel.centerYAnchor),
            planetLabelText.leadingAnchor.constraint(equalTo: planetLabel.trailingAnchor, constant: 10),

            nameLabel.topAnchor.constraint(equalTo: planetLabel.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabelText.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nameLabelText.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),

            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusLabelText.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor),
            statusLabelText.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 10),

            createLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            createLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            createLabelText.centerYAnchor.constraint(equalTo: createLabel.centerYAnchor),
            createLabelText.leadingAnchor.constraint(equalTo: createLabel.trailingAnchor, constant: 10),

            iconImage.topAnchor.constraint(equalTo: createLabel.bottomAnchor, constant: 20),
            iconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            favouriteView.leadingAnchor.constraint(equalTo: iconImage.leadingAnchor, constant: 10),
            favouriteView.topAnchor.constraint(equalTo: iconImage.topAnchor, constant: 13),
            favouriteView.heightAnchor.constraint(equalToConstant: 54),
            favouriteView.widthAnchor.constraint(equalToConstant: 61),

            detailView.trailingAnchor.constraint(equalTo: iconImage.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: iconImage.bottomAnchor),
            detailView.heightAnchor.constraint(equalToConstant: 61),
            detailView.widthAnchor.constraint(equalToConstant: 63)
        ])
    }

    // MARK: - Public Methods

    func configure(with model: CharacterCollectionModelCell) {
        let characterURL = model.characterImageURL?.absoluteString
        characterID = model.characterID
        characterName = model.characterName
        imageData = characterURL
        planetLabelText.text = model.planetNameText
        nameLabelText.text = model.characterName
        statusLabelText.text = model.characterStatusText
        createLabelText.text = model.characterCreated
        model.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.iconImage.image = image
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
