import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Tab = .photos
    @EnvironmentObject var model: ImmichModel
    @Binding var isLoggedIn: Bool

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                PhotosView()
                    .tabItem(.photos)
                AlbumsView()
                    .tabItem(.albums)
                AccountView(isLoggedIn: $isLoggedIn, selectedTab: $selectedTab)
                    .tabItem(.account)
            }
        }
    }
}

#Preview {
    HomeView(isLoggedIn: .constant(true))
        .environmentObject(ImmichModel())
}
