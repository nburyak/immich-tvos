import SwiftUI

struct AlbumsView: View {
    @EnvironmentObject var model: ImmichModel
    @State private var loadingState: LoadingState<[Album]> = .loading

    var body: some View {
        Group {
            switch loadingState {
            case .loading:
                ProgressView("Loading...")
            case .content(let albums):
                AlbumGridView(albums: albums)
            case .failure(let error):
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            }
        }
        .task {
            do {
                let albums = try await model.fetchAlbums()
                loadingState = .content(albums)
            } catch {
                loadingState = .failure(error)
            }
        }
    }
}

#Preview {
    AlbumsView()
        .environmentObject(ImmichModel())
}
