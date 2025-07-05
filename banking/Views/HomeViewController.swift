import UIKit

class HomeViewController: UIViewController {
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
    
    // MARK: - Properties
    private var user: User?
    private var creditCards: [CreditCard] = []
    private var allExpenseAmount: Double = 0
    private var monthlyExpenseAmount: Double = 0

    // MARK: - Lifecylces
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserData()
        loadCreditCardData()
        loadExpenseData()

        setupProfileUI()
        setupExpenseUI()

        updateProfileData()
        updateCardData()
        updateExpenseData()
    }

    // MARK: - Load Datas
    private func loadUserData() {
        user = SampleDataGenerator.createSampleUser()
    }

    private func loadCreditCardData() {
        creditCards = SampleDataGenerator.createSampleCreditCards()
    }

    private func loadExpenseData() {
        let transactions = SampleDataGenerator.createSampleTransactions()

        let allExpenses = transactions.filter { $0.isExpense }.reduce(0) { $0 + $1.amount }
        let monthlyExpenses = transactions.filter {
            $0.isExpense && Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }.reduce(0) { $0 + $1.amount }

        allExpenseAmount = allExpenses
        monthlyExpenseAmount = monthlyExpenses
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
        cardCollectionView.reloadData()
    }

    private func updateExpenseData() {
        allExpenseAmountLabel.attributedText = formatAmount(allExpenseAmount)
        monthlyExpenseAmountLabel.attributedText = formatAmount(monthlyExpenseAmount)
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
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creditCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreditCardCell", for: indexPath) as! CreditCardCollectionViewCell
        cell.configure(with: creditCards[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20
        return CGSize(width: width, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Activity 화면 열기
        print("카드 선택됨: \(creditCards[indexPath.item].cardName)")
    }
}
