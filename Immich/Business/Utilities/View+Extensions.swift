import SwiftUI

extension View {
    func tabItem(_ item: Tab) -> some View {
        tabItem {
            Label(item.title, systemImage: item.systemImage)
        }
        .tag(item)
    }
}
