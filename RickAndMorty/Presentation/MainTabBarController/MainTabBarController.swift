import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let charactersViewController = CharactersViewController()
        let searchViewController = SearchViewController()
        let favouritesViewController = FavouritesViewController()

        charactersViewController.title = "Characters"
        searchViewController.title = "Search"
        favouritesViewController.title = "Favourites"

        let attributes = [NSAttributedString.Key.font: R.font.interRegular(size: 24)!,
                          NSAttributedString.Key.foregroundColor: R.color.whiteCollectionViewColor()]
        UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key : Any]

        let nav1 = UINavigationController(rootViewController: charactersViewController)
        let nav2 = UINavigationController(rootViewController: searchViewController)
        let nav3 = UINavigationController(rootViewController: favouritesViewController)
        setViewControllers([nav1, nav2, nav3], animated: true)

        setupAppearance()
        viewControllers = [
            generateNavigationController(
                rootViewController: charactersViewController,
                title: "Characters",
                font: R.font.interRegular(size: 20) ?? UIFont.boldSystemFont(
                    ofSize: 20
                )
            ),
            generateNavigationController(
                rootViewController: searchViewController,
                title: "Search",
                font: R.font.interRegular(size: 20) ?? UIFont.boldSystemFont(
                    ofSize: 20
                )
            ),
            generateNavigationController(
                rootViewController: favouritesViewController,
                title: "Favourites",
                font: R.font.interRegular(size: 20) ?? UIFont.boldSystemFont(
                    ofSize: 20
                )
            )
        ]
    }
    private func generateNavigationController(
        rootViewController: UIViewController,
        title: String,
        font: UIFont
    ) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
        return navigationVC
    }

    private func setupAppearance() {
        tabBar.backgroundColor = R.color.tabBarBackgroundColor()
        tabBar.tintColor = .lightGray
        tabBar.unselectedItemTintColor = .white
        tabBar.itemPositioning = .automatic
    }
}
