import UIKit
import DropDown

final class SearchViewController: UIViewController {

    // MARK: - Private properties

    private var currentPage = 0
    private let detailVC = DetailViewController()
    private var characterID = 0
    private var characterImageURL: String?
    private var characterName: String?
    private var model: [Favourites] = []
    private var coreData = CoreDataManager.shared

    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let  viewModel = DropDownModel(
                    planetName: location.name
                )
                stringLocations.append(viewModel.planetName)
            }
        }
    }

    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let  viewModel = SearchCollectionModelCell(
                    planetName: character.origin,
                    characterName: character.name,
                    characterImageURL: character.image,
                    characterID: character.id
                )
                cellViewModels.append(viewModel)
            }
        }
    }
    private var stringLocations = [String]()

    private var cellViewModels: [SearchCollectionModelCell] = []

    private lazy var mainView = {
        let view = UIView()
        return view
    }()

    private lazy var viewContetnt = {
        let viewContent = UIView()
        viewContent.toAutoLayout()
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = 50
        viewContent.backgroundColor = R.color.blackCollectionViewColor()
        return viewContent
    }()

    private lazy var planetMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = stringLocations
        menu.anchorView = planetSelector
        menu.selectionAction = { _, title in
            self.cellViewModels.removeAll()
            self.currentPage = 0
            let request = RMRequest(
                endpoint: .location,
                queryParameters: [URLQueryItem(name: "name", value: title)]
            )
            RMService.shared.execute(request, expecting: RMGetAllLocationResponse.self) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let responseModel):
                    let result = responseModel.results.map { $0.residents }
                    var numbersCharacter = [String]()
                    guard !result.isEmpty else { return }
                    for resultData in result {
                        for char in resultData {
                            let newString = char.filter({ $0.isNumber })
                            numbersCharacter.append(newString)
                        }
                    }
                    for index in numbersCharacter {
                        let requestDataCharacter = RMRequest(
                            endpoint: .character,
                            pathComponents: ["\(index)"]
                        )
                        RMService.shared.execute(requestDataCharacter, expecting: RMCharacter.self) { result in
                            switch result {
                            case .success(let characterModel):
                                var results = characterModel
                                self.characters = [results]
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                            case .failure(let error):
                                print(String(describing: error))
                            }
                        }
                    }
                case .failure(let error):
                    print(String(describing: error))
                }
            }
        }
        return menu
    }()

    private lazy var planetSelector = {
        let planetSelector = UIView()
        planetSelector.toAutoLayout()
        planetSelector.backgroundColor = R.color.detailCellColor()
        planetSelector.addGestureRecognizer(planetSelectedGesture)
        planetSelector.clipsToBounds = true
        planetSelector.layer.cornerRadius = 10
        return planetSelector
    }()

    private lazy var planetImage = {
        let image = UIImageView(image: R.image.planetImage())
        image.toAutoLayout()
        return image
    }()

    private lazy var planetLabel = {
       let label = UILabel()
        label.toAutoLayout()
        label.text = "Search by Planet"
        label.font = R.font.interBold(size: 20)
        label.textColor = .black
        return label
    }()

    private lazy var planetSelectedGesture = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapPlanetButton))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        return gesture
    }()

    private lazy var downArrowPlanet = {
        let image = UIImageView(image: R.image.downArrow())
        image.toAutoLayout()
        return image
    }()

    private lazy var backgroundImage = {
        let image = UIImageView(image: R.image.background())
        image.toAutoLayout()
        image.contentMode = .scaleAspectFill
        return image
    }()

    private let collectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.toAutoLayout()
        collectionView.isPrefetchingEnabled = false
        collectionView.isPagingEnabled = true
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
        collectionView.backgroundColor = .clear

        return collectionView
    }()

    private lazy var backButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        button.setImage(R.image.backButton(), for: .normal)
        return button
    }()

    private lazy var nextButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        button.setImage(R.image.nextButton(), for: .normal)
        return button
    }()

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupView()
        fetchLocations()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Private Methods

    private func configureView() {
        view.addSubview(backgroundImage)
        view.addSubview(viewContetnt)
        viewContetnt.addSubview(planetSelector)
        viewContetnt.addSubview(collectionView)
        viewContetnt.addSubview(backButton)
        viewContetnt.addSubview(nextButton)
        planetSelector.addSubview(planetImage)
        planetSelector.addSubview(planetLabel)
        planetSelector.addSubview(downArrowPlanet)
    }

    private func setupView() {
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            viewContetnt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            viewContetnt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            viewContetnt.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            viewContetnt.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -109),

            planetSelector.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor),
            planetSelector.topAnchor.constraint(equalTo: viewContetnt.topAnchor, constant: 46),
            planetSelector.widthAnchor.constraint(equalToConstant: 300),
            planetSelector.heightAnchor.constraint(equalToConstant: 57),

            planetImage.widthAnchor.constraint(equalToConstant: 50),
            planetImage.heightAnchor.constraint(equalToConstant: 49),
            planetImage.leadingAnchor.constraint(equalTo: planetSelector.leadingAnchor, constant: 5),
            planetImage.bottomAnchor.constraint(equalTo: planetSelector.bottomAnchor, constant: -4),

            planetLabel.leadingAnchor.constraint(equalTo: planetImage.trailingAnchor, constant: 15),
            planetLabel.centerYAnchor.constraint(equalTo: planetSelector.centerYAnchor),

            downArrowPlanet.widthAnchor.constraint(equalToConstant: 29),
            downArrowPlanet.heightAnchor.constraint(equalToConstant: 16),
            downArrowPlanet.centerYAnchor.constraint(equalTo: planetSelector.centerYAnchor),
            downArrowPlanet.trailingAnchor.constraint(equalTo: planetSelector.trailingAnchor, constant: -25),

            collectionView.leadingAnchor.constraint(equalTo: viewContetnt.leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: viewContetnt.trailingAnchor, constant: -24),
            collectionView.bottomAnchor.constraint(equalTo: viewContetnt.bottomAnchor, constant: -107),
            collectionView.topAnchor.constraint(equalTo: downArrowPlanet.bottomAnchor, constant: 42),

            backButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 14),
            backButton.leadingAnchor.constraint(equalTo: viewContetnt.leadingAnchor, constant: 70),
            backButton.heightAnchor.constraint(equalToConstant: 62),
            backButton.widthAnchor.constraint(equalToConstant: 35),

            nextButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 14),
            nextButton.trailingAnchor.constraint(equalTo: viewContetnt.trailingAnchor, constant: -70),
            nextButton.heightAnchor.constraint(equalToConstant: 62),
            nextButton.widthAnchor.constraint(equalToConstant: 35)
        ])
    }

    @objc private func didTapPlanetButton() {
        planetMenu.show()
    }

    @objc private func backButtonDidTap() {
        let maxSlide = cellViewModels.count
        if currentPage < maxSlide {
            if currentPage > 0 {
                currentPage -= 1
                collectionView.scrollToItem(
                    at: IndexPath(
                        item: currentPage,
                        section: 0
                    ),
                    at: .centeredHorizontally,
                    animated: true
                )
            }
        }
    }

    @objc private func nextButtonDidTap() {
        let maxSlide = cellViewModels.count
        if currentPage < maxSlide - 1 {
            currentPage += 1
            collectionView.scrollToItem(
                at: IndexPath(
                    item: currentPage,
                    section: 0
                ),
                at: .centeredHorizontally,
                animated: true
            )
        }
    }

    // MARK: - Public Methods

    public func fetchLocations() {
        RMService.shared.execute(.listLocationRequest, expecting: RMGetAllLocationResponse.self
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self.locations = results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

    // MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.id,
            for: indexPath
        ) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: cellViewModels[indexPath.row])
        detailVC.characterID = cell.characterID
        characterID = cell.characterID
        characterName = cell.characterName
        characterImageURL = cell.imageData
        cell.favouriteView.delegate = self
        cell.favouriteView.index = indexPath.item
        cell.detailView.delegate = self
        cell.detailView.index = indexPath.item
        return cell
    }

}

    // MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width
        return CGSize(width: width, height: height)
    }
}

    // MARK: - FavouriteViewDelegate

extension SearchViewController: FavouriteViewDelegate {
    func favouriteViewDidTap(isFavourite: Bool, indexPath: IndexPath, characterID: Int) {
        if isFavourite {
            coreData.addFavourite(Int16(self.characterID), characterImageURL, characterName, isFavourite)
            coreData.getRecordsCount()
        } else {
            coreData.deleteFavourites(with: Int16(self.characterID))
            coreData.getRecordsCount()
        }
    }
}

    // MARK: - DetailViewDelegate

extension SearchViewController: DetailViewDelegate {
    func detailViewDidTap(indexPath: Int) {
        detailVC.title = "Details"
        detailVC.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
