import Foundation

struct CreditCard {
    let availableBalance: Double
    let cardName: String
    let cardNumber: String
    let cardType: CardType
    let id: UUID

    init(availableBalance: Double, cardName: String, cardNumber: String, cardType: CardType) {
        self.availableBalance = availableBalance
        self.cardName = cardName
        self.cardNumber = cardNumber
        self.cardType = cardType
        self.id = UUID()
    }

    var maskedCardNumber: String {
        let willShowNumber = String(cardNumber.suffix(4))
        return "....\(willShowNumber)"
    }

    enum CardType {
        case visa
        case masterCard
        case payPal

        var backgroundColor: String {
            switch self {
            case .visa:
                return "#2162FF" // 파란색
            case .masterCard:
                return "#FF6B6B" // 빨간색
            case .payPal:
                return "#4ECDC4" // 청록색
            }
        }

		// TODO: logo 추가
//        var logo: String {}
    }
}
