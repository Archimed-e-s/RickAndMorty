import UIKit

protocol DetailViewDelegate: AnyObject {
    func detailViewDidTap(indexPath: Int)
}

class DetailView: UIView, UIGestureRecognizerDelegate {

    private let gesture = UITapGestureRecognizer()
    var index = 0
    weak var delegate: DetailViewDelegate?

    private lazy var favoriteImage = {
        let image = UIImageView(image: R.image.showDetails())
        image.toAutoLayout()
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(gesture)
        gesture.addTarget(self, action: #selector(tapDetailView(_ :)))
        return image
    }()

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

    @objc private func tapDetailView(_ sender: UITapGestureRecognizer) {
        delegate?.detailViewDidTap(indexPath: self.index)
    }

}
