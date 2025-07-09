import UIKit

class ActivityViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func closeVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
