import SwiftUI

struct BucketsView: View {
    @EnvironmentObject var model: ImmichModel
    private let buckets: [Bucket]
    private let album: Album?

    init(buckets: [Bucket], album: Album? = nil) {
        self.buckets = buckets
        self.album = album
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 50) {
                ForEach(buckets) { timelineBucket in
                    Section {
                        PhotoGridView(timelineBucket, album: album)
                    } header: {
                        if let simpleDateString = timelineBucket.simpleDateString {
                            timelineBucketHeader(simpleDateString)
                        }
                    }
                }
            }
            .padding(50)
        }
    }

    private func timelineBucketHeader(_ simpleDateString: String) -> some View {
        HStack {
            Text(simpleDateString)
                .font(.title3)
            Spacer()
        }
        .padding(.leading, 50)
    }
}

#Preview {
    BucketsView(buckets: Array.mockedBuckets)
        .environmentObject(ImmichModel())
}
