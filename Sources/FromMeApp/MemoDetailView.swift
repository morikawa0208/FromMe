import SwiftUI
import SwiftData

struct MemoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let memo: Memo

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageData = memo.imageData {
                    MemoImageView(imageData: imageData)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                if let text = memo.text, !text.isEmpty {
                    Text(text)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text("保存日: \(Self.formatter.string(from: memo.createdAt))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Button("削除", role: .destructive) {
                    deleteMemo()
                }
                .padding(.top, 8)
            }
            .padding(20)
        }
        .navigationTitle("メモ詳細")
        .modifier(InlineTitleDisplayMode())
    }

    private func deleteMemo() {
        let service = MemoService(context: modelContext)
        do {
            try service.delete(memo)
            dismiss()
        } catch {
            // MVPでは削除失敗時の詳細ハンドリングは省略
        }
    }
}

private struct InlineTitleDisplayMode: ViewModifier {
    func body(content: Content) -> some View {
        #if os(iOS)
        content.navigationBarTitleDisplayMode(.inline)
        #else
        content
        #endif
    }
}
