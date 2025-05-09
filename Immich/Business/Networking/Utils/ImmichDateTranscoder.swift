import Foundation
import OpenAPIRuntime

struct ImmichDateTranscoder: DateTranscoder {
    static let shared = ImmichDateTranscoder()

    private let formatters: [DateFormatter]

    init() {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSS'+00:00'",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss'+00:00'"
        ]

        formatters = formats.map { format in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
        }
    }

    func decode(_ string: String) throws -> Date {
        for formatter in formatters {
            if let date = formatter.date(from: string) {
                return date
            }
        }

        throw DecodingError.dataCorrupted(DecodingError.Context(
            codingPath: [],
            debugDescription: "Expected date string to be in ISO8601 format, actual value: \(string)"
        ))
    }

    func encode(_ date: Date) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
            .withColonSeparatorInTime,
            .withTimeZone
        ]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return isoFormatter.string(from: date)
    }
}
