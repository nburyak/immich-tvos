import SwiftUI
import SDWebImageSwiftUI

struct AlbumGridView: View {
    @EnvironmentObject var model: ImmichModel
    @FocusState private var focusedAlbum: Album?

    private let albums: [Album]

    init(albums: [Album]) {
        self.albums = albums
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 50) {
                    ForEach(albums) { album in
                        NavigationLink {
                            PhotosView(album: album)
                        } label: {
                            albumView(album)
                        }
                        .buttonStyle(GridItemButtonStyle())
                        .focused($focusedAlbum, equals: album)
                        .scaleEffect(focusedAlbum == album ? 1.1 : 1.0)
                        .animation(.easeInOut, value: focusedAlbum == album)
                    }
                }
            }
        }
    }

    private func albumView(_ album: Album) -> some View {
        VStack {
            albumCoverView(album)
            titleView(album)
        }
    }

    fileprivate func albumCoverView(_ album: Album) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white, lineWidth: 5)
                .frame(width: 300, height: 300)
                .rotationEffect(.degrees(5))
            WebImage(url: model.thumbnailUrl(for: album, size: .thumbnail), options: .handleCookies)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white, lineWidth: 5)
                )
        }
    }

    private func titleView(_ album: Album) -> some View {
        VStack(alignment: .leading) {
            Text(album.albumName)
                .fontWeight(.bold)
                .font(.caption)
                .foregroundColor(.white)
            Group {
                if let dateString = album.endDate?.simpleDate {
                    Text(dateString)
                }
                Text("\(album.assetCount) items")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    AlbumGridView(albums: Array.mockedAlbums)
        .environmentObject(ImmichModel())
}
