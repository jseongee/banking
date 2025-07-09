import UIKit

class CustomTabBarController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabBarContainerView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!

    private var currentSelectedIndex: Int = 0
    private var tabButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        showViewController(at: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBarContainerView.layer.cornerRadius = 50
    }

    private func setupTabBar() {
        tabButtons = [homeButton, walletButton, historyButton, profileButton]
        updateTabSelection(selectedIndex: 0)
    }

    private func updateTabSelection(selectedIndex: Int) {
        currentSelectedIndex = selectedIndex

        for (index, button) in tabButtons.enumerated() {
            if index == selectedIndex {
                button.tintColor = .white
                button.backgroundColor = .clear
            } else {
                button.tintColor = .systemGray
                button.backgroundColor = .clear
            }
        }
    }

    private func showViewController(at index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController

        switch index {
        case 0:
            guard let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
            viewController = UINavigationController(rootViewController: homeVC)
        case 1:
            let walletVC = storyboard.instantiateViewController(withIdentifier: "WalletViewController")
            viewController = UINavigationController(rootViewController: walletVC)
        case 2:
            let historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryViewController")
            viewController = UINavigationController(rootViewController: historyVC)
        case 3:
            let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
            viewController = UINavigationController(rootViewController: profileVC)
        default:
            return
        }

        // 기존 child view controller 제거
        children.forEach { child in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        // 새 view controller 추가
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }

    @IBAction func tabButtonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        guard selectedIndex != currentSelectedIndex else { return }

        updateTabSelection(selectedIndex: selectedIndex)
        showViewController(at: selectedIndex)
    }
}
