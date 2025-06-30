import Foundation

struct User {
    let id: UUID
    let name: String
    let profileImage: String

    init(name: String, profileImage: String) {
        self.id = UUID()
        self.name = name
        self.profileImage = profileImage
    }
}
