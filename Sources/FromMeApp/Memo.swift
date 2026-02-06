import Foundation
import SwiftData

@Model
final class Memo {
    var id: UUID
    var createdAt: Date
    var updatedAt: Date
    var text: String?
    var imageData: Data?
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        updatedAt: Date = .now,
        text: String? = nil,
        imageData: Data? = nil,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.text = text
        self.imageData = imageData
        self.isFavorite = isFavorite
    }
}
