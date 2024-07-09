import UIKit
import CoreData

final class FavouritesViewController: UIViewController {

    // MARK: - Private properties
    private let detailVC = DetailViewController()
    private var characterID = 0
    private var characterImageURL: String?
    private var characterName: String?
    private let coreData = CoreDataManager.shared
    private var model: [Favourites] = []
    private var indexPathItem = 0
    private lazy var mainView = {
        let view = UIView()
        return view
    }()

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

    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 25
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.toAutoLayout()
        collectionView.isPrefetchingEnabled = false
        collectionView.register(FavouriteCollectionViewCell.self, forCellWithReuseIdentifier: FavouriteCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
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
        setupConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model = coreData.fetchAllFavourites()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }

    // MARK: - Private Methods

    private func configureView() {
        view.addSubview(backgroundImage)
        view.addSubview(viewContetnt)
        viewContetnt.addSubview(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            viewContetnt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            viewContetnt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            viewContetnt.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            viewContetnt.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -109),

            collectionView.leadingAnchor.constraint(equalTo: viewContetnt.leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: viewContetnt.trailingAnchor, constant: -24),
            collectionView.bottomAnchor.constraint(equalTo: viewContetnt.bottomAnchor, constant: -15),
            collectionView.topAnchor.constraint(equalTo: viewContetnt.topAnchor, constant: 15)
        ])
    }
}

    // MARK: - UICollectionViewDataSource

extension FavouritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavouriteCollectionViewCell.id,
            for: indexPath
        ) as? FavouriteCollectionViewCell else {
            return UICollectionViewCell.init()
        }
        cell.favouriteView.delegate = self
        cell.detailView.delegate = self
        cell.configure(with: model[indexPath.item])
        indexPathItem = indexPath.item
        characterID = cell.characterID
        detailVC.characterID = cell.characterID
        return cell
    }
}

    // MARK: - UICollectionViewDelegateFlowLayout

extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height = collectionView.frame.height / 2
        let width = collectionView.frame.width
        return CGSize(width: width, height: height)
    }
}

extension FavouritesViewController: FavouriteViewDelegate {
    func favouriteViewDidTap(isFavourite: Bool, indexPath: IndexPath, characterID: Int) {
        coreData.deleteFavourites(with: Int16(self.characterID))
        model.remove(at: indexPathItem)
        collectionView.reloadData()
    }
}

    // MARK: - DetailViewDelegate

extension FavouritesViewController: DetailViewDelegate {
    func detailViewDidTap(indexPath: Int) {
        detailVC.title = "Details"
        detailVC.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
