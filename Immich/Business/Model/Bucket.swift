typealias Bucket = Components.Schemas.TimeBucketResponseDto

extension Bucket: Identifiable {
    var id: String {
        timeBucket
    }
}

extension Bucket {
    var simpleDateString: String? {
        DateHelper.simpleDateString(from: timeBucket)
    }
}
