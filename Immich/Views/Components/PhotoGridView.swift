import SwiftUI
import SDWebImageSwiftUI

struct PhotoGridView: View {
    @EnvironmentObject var model: ImmichModel

    @State var selectedPhoto: Photo?
    @FocusState private var focusedPhoto: Photo?

    @State private var loadingState: LoadingState<[Photo]> = .loading
    @State private var hasPrepared = false

    private let timelineBucket: Bucket
    private let album: Album?

    init(_ timelineBucket: Bucket, album: Album? = nil) {
        self.timelineBucket = timelineBucket
        self.album = album
    }

    var body: some View {
        Group {
            switch loadingState {
            case .loading:
                fakePhotoGrid(count: timelineBucket.count)
            case .content(let photos):
                photoGrid(photos)
            case .failure(let error):
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            }
        }
        .task {
            do {
                let photos = try await model.fetchPhotos(timeBucket: timelineBucket, album: album)
                loadingState = .content(photos)
            } catch {
                loadingState = .failure(error)
            }
        }
        .sheet(item: $selectedPhoto) { photo in
            if case .content(let photos) = loadingState {
                FullscreenPhotoView(photos: photos, selectedPhoto: photo)
            }
        }
    }

    private func fakePhotoGrid(count: Int) -> some View {
        Rectangle()
            .frame(width: 300, height: 300)
            .foregroundColor(.black)
            .opacity(0.1)
//        LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 50) {
//            ForEach(0..<count, id: \.self) { index in
//                Rectangle()
//                    .frame(width: 300, height: 300)
//                    .foregroundColor(.black)
//                    .opacity(0.2)
//            }
//        }
    }

    private func photoGrid(_ photos: [Photo]) -> some View {
        ForEach(photos) { photo in
            Button(action: {
                selectedPhoto = photo
            }) {
                WebImage(url: model.thumbnailUrl(for: photo, size: .thumbnail), options: .handleCookies)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
                .clipped()
            }
            .buttonStyle(GridItemButtonStyle())
            .focused($focusedPhoto, equals: photo)
            .scaleEffect(focusedPhoto == photo ? 1.1 : 1.0)
            .animation(.easeInOut, value: focusedPhoto == photo)
        }
    }
}

#Preview {
    PhotoGridView(Array.mockedBuckets[0])
        .environmentObject(ImmichModel())
}
