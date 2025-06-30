import Foundation

struct Transaction {
    let amount: Double
    let counterparty: String
    let date: Date
    let iconName: String
    let id: UUID
    let isExpense: Bool // true: 출금, false: 입금

    init(amount: Double, counterparty: String, date: Date, iconName: String, isExpense: Bool) {
        self.amount = amount
        self.counterparty = counterparty
        self.date = date
        self.iconName = iconName
        self.id = UUID()
        self.isExpense = isExpense
    }
}
