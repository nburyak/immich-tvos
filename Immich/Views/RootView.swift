import SwiftUI

struct RootView: View {
    @EnvironmentObject var model: ImmichModel
    @State var isLoggedIn: Bool = false

    var body: some View {
        if isLoggedIn {
            HomeView(isLoggedIn: $isLoggedIn)
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(ImmichModel())
}
