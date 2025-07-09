import Foundation

struct Transaction: Hashable {
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

	var formattedAmount: String {
        let prefix = isExpense ? "-" : "+"
        return "\(prefix)$\(String(format: "%.0f", amount))"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter.string(from: date)
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
