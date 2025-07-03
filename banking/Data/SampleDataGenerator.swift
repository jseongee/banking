import Foundation

struct SampleDataGenerator {
    static func createSampleUser() -> User {
        return User(name: "Adom", profileImage: "person.circle.fill")
    }

    static func createSampleCreditCards() -> [CreditCard] {
        return [
            CreditCard(
                availableBalance: 8300.90,
                cardName: "Adom Shafi 1",
                cardNumber: "1234567890129658",
                cardType: .visa
            ),
            CreditCard(
                availableBalance: 12500.45,
                cardName: "Adom Shafi 2",
                cardNumber: "1234567890122847",
                cardType: .masterCard
            ),
            CreditCard(
                availableBalance: 5670.20,
                cardName: "Adom Shafi 3",
                cardNumber: "1234567890121934",
                cardType: .payPal
            )
        ]
    }

    static func createSampleTransactions() -> [Transaction] {
        let sampleData = [
            ("Netflix", 120.0, "tv.circle.fill", true),
            ("Tony Stark", 950.0, "person.circle.fill", false),
            ("Spotify", 15.99, "music.note.circle.fill", true),
            ("Apple Store", 299.99, "applelogo", true),
            ("Uber", 25.50, "car.circle.fill", true),
            ("Amazon", 89.95, "shippingbox.circle.fill", true),
            ("Starbucks", 12.45, "cup.and.saucer.fill", true),
            ("McDonald's", 8.99, "fork.knife.circle.fill", true),
            ("Google Pay", 45.00, "creditcard.circle.fill", false),
            ("Steam", 59.99, "gamecontroller.fill", true),
            ("Adobe", 20.99, "paintbrush.fill", true),
            ("Grocery Store", 156.78, "cart.circle.fill", true),
            ("Gas Station", 45.20, "fuelpump.circle.fill", true),
            ("Movie Theater", 34.50, "tv.circle.fill", true),
            ("Pharmacy", 28.90, "cross.circle.fill", true),
            ("Bank Transfer", 500.00, "banknote.fill", false),
            ("Freelance Work", 1250.00, "laptopcomputer", false),
            ("Electric Bill", 78.45, "bolt.circle.fill", true),
            ("Internet Bill", 49.99, "wifi.circle.fill", true),
            ("Insurance", 125.00, "shield.fill", true),
            ("Gym Membership", 39.99, "figure.run.circle.fill", true),
            ("Book Store", 24.95, "book.circle.fill", true),
            ("Coffee Shop", 6.75, "cup.and.saucer.fill", true),
            ("Online Course", 99.99, "graduationcap.fill", true),
            ("Clothing Store", 89.50, "tshirt.fill", true)
        ]

        return sampleData.enumerated().map { index, item in
            let daysAgo = index / 3
            let hoursAgo = index % 24
            let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
            let finalDate = Calendar.current.date(byAdding: .hour, value: -hoursAgo, to: date) ?? Date()

            return Transaction(
                amount: item.1,
                counterparty: item.0,
                date: finalDate,
                iconName: item.2,
                isExpense: item.3
            )
        }.sorted { $0.date > $1.date }
    }
}
