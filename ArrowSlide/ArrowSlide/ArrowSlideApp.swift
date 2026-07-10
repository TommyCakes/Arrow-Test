import SwiftUI

@main
struct ArrowSlideApp: App {
    @StateObject private var progress = ProgressStore.shared

    var body: some Scene {
        WindowGroup {
            LevelSelectView()
                .environmentObject(progress)
        }
    }
}
