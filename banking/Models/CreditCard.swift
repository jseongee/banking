import Foundation

struct CreditCard {
    let availableBalance: Double
    let cardName: String
    let cardNumber: String
    let id: UUID

    init(availableBalance: Double, cardName: String, cardNumber: String) {
        self.availableBalance = availableBalance
        self.cardName = cardName
        self.cardNumber = cardNumber
        self.id = UUID()
    }
}
