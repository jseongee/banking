import UIKit

class ActivityViewController: UIViewController {
    enum Section: CaseIterable {
        case main
    }

	// MARK: - Outlets
    @IBOutlet weak var moreButton: UIBarButtonItem!
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var transactionCollectionView: UICollectionView!
    @IBOutlet weak var transactionCollectionViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var selectedCategoryIndex = 0
    private var categoryButtons: [UIButton] = []
    private var transactions: [Transaction] = []
    private var transactionDataSource: UICollectionViewDiffableDataSource<Section, Transaction>!

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTransactionData()

        setupMoreMenu()
        setupCategoryButtons()
        setupTransactionDataSource()
        updateTransactionData()
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

    private func loadTransactionData() {
        transactions = SampleDataGenerator.createSampleTransactions()
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

    private func setupTransactionDataSource() {
        transactionDataSource = UICollectionViewDiffableDataSource<Section, Transaction>(collectionView: transactionCollectionView) {
            collectionView, indexPath, transaction in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TransactionCell",
                for: indexPath
            ) as! TransactionCollectionViewCell
            cell.configure(with: transaction)
            return cell
        }
    }

    private func updateTransactionData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Transaction>()
        snapshot.appendSections([.main])
        snapshot.appendItems(transactions)
        transactionDataSource.apply(snapshot)

        let itemHeight: CGFloat = 100
        let totalHeight = CGFloat(transactions.count) * itemHeight
        transactionCollectionViewHeightConstraint.constant = totalHeight
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

    @IBAction func seeAllButtonTapped(_ sender: UIButton) {
        print("See all Button Tapped")
    }
}

extension ActivityViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 100)
    }
}
