import Foundation

class DateHelper {
    private static let timeBucketDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static let simpleDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, yyyy"
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    static func simpleDateString(from iso8601DateString: String) -> String? {
        guard let date = timeBucketDateFormatter.date(from: iso8601DateString) else { return nil }

        return simpleDateFormatter.string(from: date)
    }
}

extension Date {
    var simpleDate: String {
        DateHelper.simpleDateFormatter.string(from: self)
    }
}
