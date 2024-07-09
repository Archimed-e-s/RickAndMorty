import UIKit

protocol FavouriteViewDelegate: AnyObject {
    func favouriteViewDidTap(isFavourite: Bool, indexPath: IndexPath, characterID: Int)
}

class FavouriteView: UIView, UIGestureRecognizerDelegate {

    private let gesture = UITapGestureRecognizer()
    var index = 0
    var characterID = 0
    lazy var favoriteImage = {
        let image = UIImageView(image: isSelected ? R.image.addedFavourites() : R.image.notAddedFavourites())
        image.toAutoLayout()
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(gesture)
        gesture.addTarget(self, action: #selector(tapFavouriteView(_ :)))
        return image
    }()

    private var isSelected: Bool = false
    weak var delegate: FavouriteViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(favoriteImage)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            favoriteImage.topAnchor.constraint(equalTo: topAnchor),
            favoriteImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            favoriteImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            favoriteImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func tapFavouriteView(_ sender: UITapGestureRecognizer) {
        animateTap()
        delegate?.favouriteViewDidTap(
            isFavourite: isSelected,
            indexPath: IndexPath(index: index),
            characterID: characterID
        )

    }

    private func animateTap() {
        isSelected.toggle()
        UIView.transition(
            with: self,
            duration: 0.2) { [self] in
                if isSelected {
                    favoriteImage.image = R.image.addedFavourites()
                } else {
                    favoriteImage.image = R.image.notAddedFavourites()
                }
            }
    }
}
