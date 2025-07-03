import UIKit

class CreditCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    private func setupUI() {
        cardBackgroundView.layer.cornerRadius = 30
    }

    func configure(with card: CreditCard) {
        cardNameLabel.text = card.cardName
        balanceAmountLabel.text = String(format: "$%.2f", card.availableBalance)
        cardNumberLabel.text = "Card Code \(card.maskedCardNumber)"
        cardBackgroundView.backgroundColor = UIColor(hex: card.cardType.backgroundColor)
    }
}
