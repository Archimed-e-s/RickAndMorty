import UIKit

final class DetailViewController: UIViewController {

    // MARK: - Private properties

    var characterID = 0

    private lazy var backgroundImage = {
        let image = UIImageView(image: R.image.background())
        image.toAutoLayout()
        image.contentMode = .scaleAspectFill
        return image
    }()

    private lazy var viewContetnt = {
        let viewContent = UIView()
        viewContent.toAutoLayout()
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = 40
        viewContent.backgroundColor = R.color.whiteCollectionViewColor()
        viewContent.layer.borderWidth = 3
        viewContent.layer.borderColor = UIColor(resource: .detailCell).cgColor
        return viewContent
    }()

    private lazy var detailImage = {
        let image = UIImageView()
        image.toAutoLayout()
        image.clipsToBounds = true
        image.layer.cornerRadius = 41
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor(resource: .blackCollectionView).cgColor
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var greenView = {
        let viewContent = UIView()
        viewContent.toAutoLayout()
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = 37
        viewContent.backgroundColor = R.color.detailCellColor()
        viewContent.layer.borderWidth = 2
        viewContent.layer.borderColor = UIColor(resource: .blackCollectionView).cgColor
        return viewContent
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString.init(string: label.text ?? "0")
        attributedString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: 1,
            range: NSRange(
                location: 0,
                length: attributedString.length
            )
        )
        label.attributedText = attributedString
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.textAlignment = .center
        label.font = R.font.interRegular(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var IDLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.text = "ID: "
        label.font = R.font.interBold(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var IDLabelText: UILabel = {
        let label = UILabel()
        label.text = "unknown"
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = R.font.interRegular(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.text = "Status: "
        label.font = R.font.interBold(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var statusLabelText: UILabel = {
        let label = UILabel()
        label.text = "unknown"
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = R.font.interRegular(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.text = "Species: "
        label.font = R.font.interBold(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var speciesLabelText: UILabel = {
        let label = UILabel()
        label.text = "unknown"
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = R.font.interRegular(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.text = "Gender: "
        label.font = R.font.interBold(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var genderLabelText: UILabel = {
        let label = UILabel()
        label.text = "unknown"
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = R.font.interRegular(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var originLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.text = "Origin: "
        label.font = R.font.interBold(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var originLabelText: UILabel = {
        let label = UILabel()
        label.text = "unknown"
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = R.font.interRegular(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var planetLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.text = "Planet: "
        label.font = R.font.interBold(size: 24)
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    private lazy var planetLabelText: UILabel = {
        let label = UILabel()
        label.text = "unknown"
        label.toAutoLayout()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = R.font.interRegular(size: 24)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = R.color.blackCollectionViewColor()
        return label
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
        detailImage.image = nil
        nameLabel.text = nil
        IDLabelText.text = nil
        statusLabelText.text = nil
        speciesLabelText.text = nil
        genderLabelText.text = nil
        originLabelText.text = nil
        planetLabelText.text = nil
    }

    // MARK: - Public Methods

    func fetchData() {
        let  request = RMRequest(
            endpoint: .character,
            pathComponents: ["\(characterID)"]
        )
        RMService.shared.execute(
            request,
            expecting: RMCharacter.self) { result in
                switch result {
                case .success(let responseData):
                    DispatchQueue.main.async {
                        self.nameLabel.text = responseData.name
                        self.IDLabelText.text = String(responseData.id)
                        self.statusLabelText.text = responseData.status.rawValue
                        self.speciesLabelText.text = responseData.species
                        self.genderLabelText.text = responseData.gender.rawValue
                        self.originLabelText.text = responseData.origin.name
                        self.planetLabelText.text = responseData.location.name
                        guard let url = responseData.image else {
                            return
                        }
                        let request = URLRequest(url: url)
                        let task = URLSession.shared.dataTask(with: request) { data, _, error in
                            guard let data = data, error == nil else {
                                return
                            }
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.detailImage.image = image
                            }
                        }
                        task.resume()
                    }
                case .failure(let error):
                    print(String(describing: error))
                }
            }
    }

    // MARK: - Private Methods

    private func configureView() {
        view.addSubview(backgroundImage)
        view.addSubview(viewContetnt)
        viewContetnt.addSubview(detailImage)
        viewContetnt.addSubview(greenView)
        [
            nameLabel,
            IDLabel,
            IDLabelText,
            statusLabel,
            statusLabelText,
            speciesLabel,
            speciesLabelText,
            genderLabel,
            genderLabelText,
            originLabel,
            originLabelText,
            planetLabel,
            planetLabelText
        ].forEach { greenView.addSubview($0) }
    }

    private func setupView() {
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            viewContetnt.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            viewContetnt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 41),
            viewContetnt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -41),
            viewContetnt.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -107),

            detailImage.trailingAnchor.constraint(equalTo: viewContetnt.trailingAnchor, constant: -15),
            detailImage.heightAnchor.constraint(equalToConstant: 155),
            detailImage.leadingAnchor.constraint(equalTo: viewContetnt.leadingAnchor, constant: 15),
            detailImage.topAnchor.constraint(equalTo: viewContetnt.topAnchor, constant: 42),

            greenView.leadingAnchor.constraint(equalTo: viewContetnt.leadingAnchor, constant: 15),
            greenView.trailingAnchor.constraint(equalTo: viewContetnt.trailingAnchor, constant: -15),
            greenView.topAnchor.constraint(equalTo: detailImage.bottomAnchor, constant: 42),
            greenView.bottomAnchor.constraint(equalTo: viewContetnt.bottomAnchor, constant: -44),

            nameLabel.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: greenView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: greenView.topAnchor, constant: 35),

            IDLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 9),
            IDLabel.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant: 16),

            IDLabelText.centerYAnchor.constraint(equalTo: IDLabel.centerYAnchor),
            IDLabelText.leadingAnchor.constraint(equalTo: IDLabel.trailingAnchor),

            statusLabel.topAnchor.constraint(equalTo: IDLabel.bottomAnchor, constant: 9),
            statusLabel.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant: 16),

            statusLabelText.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor),
            statusLabelText.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor),

            speciesLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 9),
            speciesLabel.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant: 16),

            speciesLabelText.centerYAnchor.constraint(equalTo: speciesLabel.centerYAnchor),
            speciesLabelText.leadingAnchor.constraint(equalTo: speciesLabel.trailingAnchor),

            genderLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 9),
            genderLabel.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant: 16),

            genderLabelText.centerYAnchor.constraint(equalTo: genderLabel.centerYAnchor),
            genderLabelText.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor),

            originLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 9),
            originLabel.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant: 16),

            originLabelText.centerYAnchor.constraint(equalTo: originLabel.centerYAnchor),
            originLabelText.leadingAnchor.constraint(equalTo: originLabel.trailingAnchor),

            planetLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 9),
            planetLabel.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant: 16),
            planetLabel.bottomAnchor.constraint(equalTo: greenView.bottomAnchor, constant: -61),

            planetLabelText.centerYAnchor.constraint(equalTo: planetLabel.centerYAnchor),
            planetLabelText.leadingAnchor.constraint(equalTo: planetLabel.trailingAnchor),
            planetLabelText.trailingAnchor.constraint(equalTo: greenView.trailingAnchor),
            planetLabelText.bottomAnchor.constraint(equalTo: greenView.bottomAnchor, constant: -61)
        ])
    }
}
