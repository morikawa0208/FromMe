import PhotosUI
import SwiftUI
import SwiftData

struct AddMemoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var text: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    private var canSave: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedImageData != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("テキスト") {
                    TextEditor(text: $text)
                        .frame(minHeight: 120)
                }

                Section("写真") {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("写真を選択", systemImage: "photo")
                    }

                    if let selectedImageData {
                        MemoImageView(imageData: selectedImageData)
                            .frame(maxHeight: 240)
                        Button("写真を削除", role: .destructive) {
                            self.selectedItem = nil
                            self.selectedImageData = nil
                        }
                    }
                }
            }
            .navigationTitle("メモを追加")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveMemo()
                    }
                    .disabled(!canSave)
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                guard let newItem else {
                    selectedImageData = nil
                    return
                }
                Task {
                    selectedImageData = try? await newItem.loadTransferable(type: Data.self)
                }
            }
        }
    }

    private func saveMemo() {
        let service = MemoService(context: modelContext)
        do {
            try service.addMemo(text: text, imageData: selectedImageData)
            dismiss()
        } catch {
            // MVPでは保存失敗時の詳細ハンドリングは省略
        }
    }
}
