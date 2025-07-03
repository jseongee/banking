import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    private var user: User?
    private var creditCards: [CreditCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserData()
        loadCreditCardData()

        setupProfileUI()

        updateProfileData()
        updateCardData()
    }

    private func loadUserData() {
        user = SampleDataGenerator.createSampleUser()
    }

    private func loadCreditCardData() {
        creditCards = SampleDataGenerator.createSampleCreditCards()
    }

    private func setupProfileUI() {
        profileImageView.layer.cornerRadius = profileImageView.layer.frame.width / 2
    }

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
