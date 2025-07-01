import UIKit

class CustomTabBarController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabBarContainerView: UIView!

    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!

    private var viewControllers: [UIViewController] = []
    private var currentViewController: UIViewController?
    private var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarContainerUI()
        setupViewControllers()
        selectTab(at: selectedIndex)
    }

    private func setupTabBarContainerUI() {
        tabBarContainerView.layer.cornerRadius = 50
        tabBarContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func setupViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        let walletVC = storyboard.instantiateViewController(withIdentifier: "WalletViewController")
        let historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryViewController")
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        viewControllers = [homeVC, walletVC, historyVC, profileVC]
    }

    @IBAction func tabButtonTapped(_ sender: UIButton) {
        selectTab(at: sender.tag)
    }

    private func selectTab(at index: Int) {
        updateButtonSelection(selectedIndex: index)
        switchViewController(to: index)
        selectedIndex = index
    }

    private func updateButtonSelection(selectedIndex: Int) {
        let buttons = [homeButton, walletButton, historyButton, profileButton]

        buttons.forEach({
            $0?.tintColor = $0?.tag == selectedIndex ? .white : .white.withAlphaComponent(0.6)
        })
    }

    private func switchViewController(to index: Int) {
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        let newVC = viewControllers[index]
        addChild(newVC)
        containerView.addSubview(newVC.view)

        newVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            newVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            newVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            newVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        newVC.didMove(toParent: self)
        currentViewController = newVC
    }
}
