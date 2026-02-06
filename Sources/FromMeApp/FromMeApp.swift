import SwiftData
import SwiftUI

@main
struct FromMeApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Memo.self)
    }
}
