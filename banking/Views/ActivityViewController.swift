import UIKit

class ActivityViewController: UIViewController {
	// MARK: - Outlets
    @IBOutlet weak var moreButton: UIBarButtonItem!
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardButtonStackView: UIStackView!
    
    // MARK: - Properties
    private var selectedCategoryIndex = 0
    private var categoryButtons: [UIButton] = []

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMoreMenu()
        setupCategoryButtons()
        setupCardButtons()
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

    private func setupCategoryButtons() {
        categoryStackView.arrangedSubviews.forEach {
            if let subview = $0 as? UIButton {
                categoryButtons.append(subview)
            }
        }
    }

    private func setupCardButtons() {
        for cardButton in cardButtonStackView.arrangedSubviews {
            cardButton.layer.cornerRadius = cardButton.frame.width / 2
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

    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        let newIndex = sender.tag
        guard newIndex != selectedCategoryIndex else { return }

        selectedCategoryIndex = newIndex
        updateButtonStates()
        updateIndicatorPosition()
    }

    private func updateButtonStates() {
        for (index, button) in categoryButtons.enumerated() {
            let isSelected = index == selectedCategoryIndex

            var config = button.configuration
            config?.baseForegroundColor = isSelected ? .label : .systemGray

            button.configuration = config
        }
    }

    private func updateIndicatorPosition() {
        guard !categoryButtons.isEmpty else { return }

        let selectedButton = categoryButtons[selectedCategoryIndex]
        let newLeadingConstant = selectedButton.frame.origin.x

        UIView.animate(withDuration: 0.3) {
            self.indicatorLeadingConstraint.constant = newLeadingConstant
            self.view.layoutIfNeeded()
        }
    }
}
