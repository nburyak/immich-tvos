import SwiftUI

struct PhotosView: View {
    @EnvironmentObject var model: ImmichModel
    @State var loadingState: LoadingState<[Bucket]> = .loading

    private let album: Album?

    init(album: Album? = nil) {
        self.album = album
    }

    var body: some View {
        Group {
            switch loadingState {
            case .loading:
                ProgressView("Loading...")
            case .content(let buckets):
                BucketsView(buckets: buckets, album: album)
            case .failure(let error):
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            }
        }
        .task {
            do {
                let buckets = try await model.fetchBuckets(album: album)
                loadingState = .content(buckets)
            } catch {
                loadingState = .failure(error)
            }
        }
    }
}

#Preview {
    PhotosView()
        .environmentObject(ImmichModel())
}
