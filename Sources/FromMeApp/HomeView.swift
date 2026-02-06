import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    @State private var currentMemo: Memo?
    @State private var lastMemoID: UUID?
    @State private var showAddSheet = false

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                if let memo = currentMemo {
                    memoCard(for: memo)
                        .padding(.horizontal, 20)
                        .transition(.opacity)
                } else {
                    emptyState
                        .padding(.horizontal, 28)
                }

                Spacer()

                HStack(spacing: 12) {
                    Button("シャッフル") {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            pickRandomMemo()
                        }
                    }
                    .buttonStyle(.bordered)

                    Button("追加") {
                        showAddSheet = true
                    }
                    .buttonStyle(.borderedProminent)

                    NavigationLink("一覧", destination: MemoListView())
                        .buttonStyle(.bordered)
                }
                .padding(.bottom, 24)
            }
            .navigationTitle("FromMe")
            .sheet(isPresented: $showAddSheet, onDismiss: reloadAfterAdd) {
                AddMemoView()
            }
            .task {
                pickRandomMemo()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    pickRandomMemo()
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("まだメモがありません")
                .font(.title3.weight(.semibold))
            Text("思いついた一言や写真を残してみよう")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("最初のメモを追加") {
                showAddSheet = true
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
    }

    private func memoCard(for memo: Memo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let text = memo.text, !text.isEmpty {
                Text(text)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if let imageData = memo.imageData {
                MemoImageView(imageData: imageData)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            Text("保存日 \(Self.formatter.string(from: memo.createdAt))")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

    private func pickRandomMemo() {
        let service = MemoService(context: modelContext)
        do {
            let selected = try service.randomMemo(avoiding: lastMemoID)
            currentMemo = selected
            lastMemoID = selected?.id
        } catch {
            currentMemo = nil
            lastMemoID = nil
        }
    }

    private func reloadAfterAdd() {
        pickRandomMemo()
    }
}
