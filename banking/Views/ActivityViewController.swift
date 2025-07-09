import UIKit

class ActivityViewController: UIViewController {
	// MARK: - Outlets
    @IBOutlet weak var moreButton: UIBarButtonItem!

    // MARK: - Properties
    private let categories = ["Checking", "Savings", "Crypto"]
        private var selectedCategoryIndex = 0

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMoreMenu()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let customTabBarController = findCustomTabBarController() {
            customTabBarController.tabBarContainerView.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let customTabBarController = findCustomTabBarController() {
            customTabBarController.tabBarContainerView.isHidden = false
        }
    }

    private func setupMoreMenu() {
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Export Data", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                print("Export Data tapped")
            },
            UIAction(title: "Account Settings", image: UIImage(systemName: "gear")) { _ in
                print("Account Settings tapped")
            },
            UIAction(title: "Help & Support", image: UIImage(systemName: "questionmark.circle")) { _ in
                print("Help & Support tapped")
            },
            UIAction(title: "Privacy Policy", image: UIImage(systemName: "hand.raised")) { _ in
                print("Privacy Policy tapped")
            }
        ])

        moreButton.menu = menu
    }

    private func findCustomTabBarController() -> CustomTabBarController? {
        var parentVC = self.parent
        while parentVC != nil {
            if let customTabBarController = parentVC as? CustomTabBarController {
                return customTabBarController
            }
            parentVC = parentVC?.parent
        }
        return nil
    }

    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
