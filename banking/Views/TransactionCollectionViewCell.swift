import UIKit

class TransactionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var counterpartyImageView: UIImageView!
    @IBOutlet weak var counterpartyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    private func setupUI() {
        counterpartyImageView.layer.cornerRadius = counterpartyImageView.bounds.width / 2
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: contentView.bounds.height - 1, width: contentView.bounds.width, height: 1)
        bottomBorder.backgroundColor = UIColor.systemGray5.cgColor
        contentView.layer.addSublayer(bottomBorder)
    }

    func configure(with transaction: Transaction) {
        counterpartyImageView.image = UIImage(systemName: transaction.iconName)
        counterpartyLabel.text = transaction.counterparty
        timeLabel.text = "Today, \(transaction.timeString)"
        amountLabel.text = transaction.formattedAmount
        dateLabel.text = transaction.formattedDate
    }
}
