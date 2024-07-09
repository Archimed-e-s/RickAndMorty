import UIKit
import CoreData

final class CharactersViewController: UIViewController {

    // MARK: - Private properties

    private var currentPage = 0
    private var detailVC = DetailViewController()
    private var characterID = 0
    private var characterImageURL: String?
    private var characterName: String?
    private var model: [Favourites] = []
    private var coreData = CoreDataManager.shared
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let  viewModel = CharacterCollectionModelCell(
                    characterID: character.id,
                    planetName: character.origin,
                    characterName: character.name,
                    characterStatus: character.status,
                    characterCreated: character.created,
                    characterImageURL:  character.image
                )
                cellViewModels.append(viewModel)
            }
        }
    }

    private var cellViewModels: [CharacterCollectionModelCell] = []

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
        viewContent.layer.cornerRadius = 50
        viewContent.backgroundColor = R.color.blackCollectionViewColor()
        return viewContent
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.toAutoLayout()
        collectionView.register(CharcterCollectionViewCell.self, forCellWithReuseIdentifier: CharcterCollectionViewCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPrefetchingEnabled = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()

    private lazy var backButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.addTarget(self, action: #selector(backWhiteButtonDidTap), for: .touchUpInside)
        button.setImage(R.image.backWhiteButton(), for: .normal)
        return button
    }()

    private lazy var nextButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.addTarget(self, action: #selector(nextWhiteButtonDidTap), for: .touchUpInside)
        button.setImage(R.image.nextWhiteButton(), for: .normal)
        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupConstraints()
        fetchCharacters()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    // MARK: - Public Methods

    public func fetchCharacters() {
        RMService.shared.execute(
            .listCharacterRequests,
            expecting: RMGetAllCharactersResponse.self
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self.characters = results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }

    // MARK: - Private Methods

    private func configure() {
        view.addSubview(backgroundImage)
        view.addSubview(viewContetnt)
        viewContetnt.addSubview(collectionView)
        viewContetnt.addSubview(backButton)
        viewContetnt.addSubview(nextButton)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            viewContetnt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            viewContetnt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            viewContetnt.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            viewContetnt.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -102),

            collectionView.leadingAnchor.constraint(equalTo: viewContetnt.leadingAnchor, constant: 22),
            collectionView.trailingAnchor.constraint(equalTo: viewContetnt.trailingAnchor, constant: -22),
            collectionView.bottomAnchor.constraint(equalTo: viewContetnt.bottomAnchor, constant: -99),
            collectionView.topAnchor.constraint(equalTo: viewContetnt.topAnchor),

            backButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 19),
            backButton.leadingAnchor.constraint(equalTo: viewContetnt.leadingAnchor, constant: 68),
            backButton.heightAnchor.constraint(equalToConstant: 62),
            backButton.widthAnchor.constraint(equalToConstant: 35),

            nextButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 19),
            nextButton.trailingAnchor.constraint(equalTo: viewContetnt.trailingAnchor, constant: -68),
            nextButton.heightAnchor.constraint(equalToConstant: 62),
            nextButton.widthAnchor.constraint(equalToConstant: 35)
        ])
    }

    @objc private func backWhiteButtonDidTap() {
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

    @objc private func nextWhiteButtonDidTap() {
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
}

    // MARK: - UICollectionViewDataSource

extension CharactersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharcterCollectionViewCell.id,
            for: indexPath
        ) as? CharcterCollectionViewCell else {
            return UICollectionViewCell.init()
        }
        cell.configure(with: cellViewModels[indexPath.row])
        detailVC.characterID = cell.characterID
        characterID = cell.characterID
        characterName = cell.characterName
        characterImageURL = cell.imageData
        cell.favouriteView.index = indexPath.row
        cell.detailView.index = indexPath.row
        cell.favouriteView.delegate = self
        cell.detailView.delegate = self
        return cell
    }
}

    // MARK: - UICollectionViewDelegate

extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(
       _ collectionView: UICollectionView,
       willDisplay cell: UICollectionViewCell,
       forItemAt indexPath: IndexPath
   ) {
       currentPage = indexPath.item
   }
}

    // MARK: - UICollectionViewDelegateFlowLayout

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
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

extension CharactersViewController: FavouriteViewDelegate {
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

extension CharactersViewController: DetailViewDelegate {
    func detailViewDidTap(indexPath: Int) {
        detailVC.title = "Details"
        detailVC.navigationItem.hidesBackButton = true
        navigationController?.show(detailVC, sender: self)
    }
}
