import Foundation

enum Tab {
    case photos
    case albums
    case account

    var title: String {
        switch self {
        case .photos:
            "Photos"
        case .albums:
            "Albums"
        case .account:
            "Account"
        }
    }

    var systemImage: String {
        switch self {
        case .photos:
            "photo"
        case .albums:
            "rectangle.stack"
        case .account:
            "person.crop.circle"
        }
    }
}

