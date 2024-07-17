import SwiftUI
import SDWebImageSwiftUI

struct FullscreenPhotoView: View {
    @EnvironmentObject var model: ImmichModel
    @State var selectedPhoto: Photo
    private let photos: [Photo]
    
    init(photos: [Photo], selectedPhoto: Photo) {
        self.photos = photos
        self.selectedPhoto = selectedPhoto
    }
    
    var body: some View {
        TabView(selection: $selectedPhoto) {
            ForEach(photos) { photo in
                WebImage(url: model.thumbnailUrl(for: photo, size: .preview), options: .handleCookies)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .tag(photo)
                .ignoresSafeArea()
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onSwipeGesture { direction in
            switch direction {
            case .left:
                selectedPhoto = nextPhoto
            case .right:
                selectedPhoto = prevPhoto
            default:
                break
            }
        }
    }
    
    private var prevPhoto: Photo {
        let selectedIndex = photos.firstIndex(of: selectedPhoto) ?? 0
        return photos[max(0, selectedIndex - 1)]
    }
    
    private var nextPhoto: Photo {
        let selectedIndex = photos.firstIndex(of: selectedPhoto) ?? photos.count - 1
        return photos[min(photos.count - 1, selectedIndex + 1)]
    }
}

#Preview {
    FullscreenPhotoView(photos: Array.mockedPhotos, selectedPhoto: Array.mockedPhotos[0])
        .environmentObject(ImmichModel())
}
