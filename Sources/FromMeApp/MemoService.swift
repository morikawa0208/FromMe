import Foundation
import SwiftData

struct MemoService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func addMemo(text: String?, imageData: Data?) throws {
        let normalizedText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalText = normalizedText?.isEmpty == false ? normalizedText : nil

        guard finalText != nil || imageData != nil else {
            return
        }

        let now = Date()
        let memo = Memo(
            createdAt: now,
            updatedAt: now,
            text: finalText,
            imageData: imageData,
            isFavorite: false
        )
        context.insert(memo)
        try context.save()
    }

    func delete(_ memo: Memo) throws {
        context.delete(memo)
        try context.save()
    }

    func fetchAllSorted() throws -> [Memo] {
        var descriptor = FetchDescriptor<Memo>()
        descriptor.sortBy = [SortDescriptor(\Memo.createdAt, order: .reverse)]
        return try context.fetch(descriptor)
    }

    func randomMemo(avoiding lastID: UUID?) throws -> Memo? {
        let memos = try fetchAllSorted()
        guard !memos.isEmpty else {
            return nil
        }

        if memos.count == 1 {
            return memos.first
        }

        if let lastID {
            let candidates = memos.filter { $0.id != lastID }
            if !candidates.isEmpty {
                return candidates.randomElement()
            }
        }

        return memos.randomElement()
    }
}
