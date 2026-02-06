import SwiftUI
import SwiftData

struct MemoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Memo.createdAt, order: .reverse)]) private var memos: [Memo]

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    var body: some View {
        List {
            ForEach(memos) { memo in
                NavigationLink(destination: MemoDetailView(memo: memo)) {
                    HStack(alignment: .top, spacing: 12) {
                        if let imageData = memo.imageData {
                            MemoImageView(imageData: imageData)
                                .frame(width: 64, height: 64)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text(previewText(for: memo))
                                .lineLimit(3)
                            Text(Self.formatter.string(from: memo.createdAt))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("メモ一覧")
    }

    private func previewText(for memo: Memo) -> String {
        if let text = memo.text, !text.isEmpty {
            return text
        }
        if memo.imageData != nil {
            return "写真"
        }
        return "メモ"
    }

    private func delete(at offsets: IndexSet) {
        let service = MemoService(context: modelContext)
        for index in offsets {
            do {
                try service.delete(memos[index])
            } catch {
                // MVPでは削除失敗時の詳細ハンドリングは省略
            }
        }
    }
}
