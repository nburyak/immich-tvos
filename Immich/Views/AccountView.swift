import SwiftUI

struct AccountView: View {
    @EnvironmentObject var model: ImmichModel
    @Binding var isLoggedIn: Bool
    @Binding var selectedTab: Tab

    var body: some View {
        Button("Logout") {
            model.logout()
            selectedTab = .photos
            isLoggedIn = false
        }
    }
}

#Preview {
    AccountView(isLoggedIn: .constant(true), selectedTab: .constant(.account))
        .environmentObject(ImmichModel())
}
