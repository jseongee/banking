import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserData()
        setupProfileUI()
        updateProfileData()
    }

    private func loadUserData() {
        user = SampleDataGenerator.createSampleUser()
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
}
