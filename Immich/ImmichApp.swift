import SwiftUI

@main
struct ImmichApp: App {
    @StateObject private var model = ImmichModel()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .environmentObject(model)
    }
}
