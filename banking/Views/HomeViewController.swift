import UIKit

class HomeViewController: UIViewController {
    enum Section: CaseIterable {
        case main
    }

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var allExpenesCardView: UIView!
    @IBOutlet weak var allExpenseAmountLabel: UILabel!
    @IBOutlet weak var allExpenseArrowIconContainerView: UIView!
    @IBOutlet weak var allExpenseWalletIconContainerView: UIView!
    @IBOutlet weak var monthlyExpenseCardView: UIView!
    @IBOutlet weak var monthlyExpenseAmountLabel: UILabel!
    @IBOutlet weak var monthlyExpenseArrowIconContainerView: UIView!
    @IBOutlet weak var monthlyExpenseWalletIconContainerView: UIView!
    @IBOutlet weak var transactionCollectionView: UICollectionView!
    @IBOutlet weak var transactionCollectionViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties
    private var user: User?
    private var creditCards: [CreditCard] = []
    private var allExpenseAmount: Double = 0
    private var monthlyExpenseAmount: Double = 0
    private var transactions: [Transaction] = []
    private var cardDataSource: UICollectionViewDiffableDataSource<Section, CreditCard>!
    private var transactionDataSource: UICollectionViewDiffableDataSource<Section, Transaction>!


    // MARK: - Lifecylces
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserData()
        loadCreditCardData()
        loadExpenseData()
        loadTransactionData()

        setupProfileUI()
        setupExpenseUI()
        setupCardDataSource()
        setupTransactionDataSource()

        updateProfileData()
        updateCardData()
        updateExpenseData()
        updateTransactionData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: - Load Datas
    private func loadUserData() {
        user = SampleDataGenerator.createSampleUser()
    }

    private func loadCreditCardData() {
        creditCards = SampleDataGenerator.createSampleCreditCards()
    }

    private func loadExpenseData() {
        loadTransactionData()

        let allExpenses = transactions.filter { $0.isExpense }.reduce(0) { $0 + $1.amount }
        let monthlyExpenses = transactions.filter {
            $0.isExpense && Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }.reduce(0) { $0 + $1.amount }

        allExpenseAmount = allExpenses
        monthlyExpenseAmount = monthlyExpenses
    }

    private func loadTransactionData() {
        transactions = SampleDataGenerator.createSampleTransactions()
    }

    // MARK: - Setup UIs
    private func setupProfileUI() {
        profileImageView.layer.cornerRadius = profileImageView.layer.frame.width / 2
    }

    private func setupExpenseUI() {
        configureCardView(allExpenesCardView)
        configureIconContainerView(allExpenseArrowIconContainerView, borderColor: UIColor.systemGray2.cgColor)
        configureIconContainerView(allExpenseWalletIconContainerView, borderColor: UIColor.systemGray5.cgColor)

        configureCardView(monthlyExpenseCardView)
        configureIconContainerView(monthlyExpenseArrowIconContainerView, borderColor: UIColor.systemGray2.cgColor)
        configureIconContainerView(monthlyExpenseWalletIconContainerView, borderColor: UIColor.systemGray5.cgColor)
    }

    private func configureCardView(_ view: UIView) {
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
    }

    private func configureIconContainerView(_ view: UIView, borderColor: CGColor) {
        view.layer.cornerRadius = view.bounds.width / 2
        view.layer.borderWidth = 1
        view.layer.borderColor = borderColor
    }

    // MARK: - Setup Data Sources
    private func setupCardDataSource() {
        cardDataSource = UICollectionViewDiffableDataSource<Section, CreditCard>(collectionView: cardCollectionView) {
            collectionView, indexPath, card in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CreditCardCell",
                for: indexPath
            ) as! CreditCardCollectionViewCell
            cell.configure(with: card)
            return cell
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

    // MARK: - Update Datas
    private func updateProfileData() {
        guard let user else {
            print("유저 데이터가 없습니다.")
            return
        }

        profileImageView.image = UIImage(systemName: user.profileImage)
        nameLabel.text = "Hello \(user.name)!"
    }

    private func updateCardData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CreditCard>()
        snapshot.appendSections([.main])
        snapshot.appendItems(creditCards)

        cardDataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    private func updateExpenseData() {
        allExpenseAmountLabel.attributedText = formatAmount(allExpenseAmount)
        monthlyExpenseAmountLabel.attributedText = formatAmount(monthlyExpenseAmount)
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

    // MARK: - Utils
    private func formatAmount(_ amount: Double) -> NSAttributedString {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0

        let amountString = formatter.string(from: NSNumber(value: amount)) ?? "0"
        let parts = amountString.components(separatedBy: ",")

        let attributedString = NSMutableAttributedString()
        let majorAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 30),
            .foregroundColor: UIColor.black
        ]
        let minorAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.systemGray
        ]

        if parts.count > 1 {
            attributedString.append(NSAttributedString(string: parts[0], attributes: majorAttributes))
            attributedString.append(NSAttributedString(string: ",", attributes: minorAttributes))
            attributedString.append(NSAttributedString(string: parts[1], attributes: minorAttributes))
        } else {
            attributedString.append(NSAttributedString(string: amountString, attributes: majorAttributes))
        }

        return attributedString
    }

    @IBAction func seeAllButtonTapped(_ sender: Any) {
        print("See all Button Tapped")
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cardCollectionView {
            let width = collectionView.frame.width - 20
            return CGSize(width: width, height: 250)
        } else if collectionView == transactionCollectionView {
            let width = collectionView.frame.width
            return CGSize(width: width, height: 100)
        } else {
            return CGSize.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cardCollectionView {
            // TODO: Activity 화면 열기
            print("Credit Card selected: \(creditCards[indexPath.item].cardName)")
        }
    }
}
