import Foundation
import SDWebImage
import OpenAPIURLSession
import OpenAPIRuntime
import SDWebImageWebPCoder
import SwiftUI

@MainActor
final class ImmichModel: ObservableObject {
    enum ImmichError: Error {
        case clientNotInitialized
    }

    enum AssetSize: String {
        case thumbnail
        case preview
    }

    @AppStorage("server") private var server: String?

    private var serverURL: URL? {
        guard let server, let serverURL = URL(string: server) else { return nil }
        return serverURL
    }

    private var client: Client?

    // MARK: Init

    init() {
        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
        configureClientIfPossible()
    }

    // MARK: Authentication

    private func configureClientIfPossible() {
        guard let serverURL else { return }

        client = Client(
            serverURL: serverURL,
            configuration: .init(dateTranscoder: ImmichDateTranscoder.shared),
            transport: URLSessionTransport()
        )
    }

    func validateAccessToken() async throws -> Bool {
        guard let client else { return false }

        do {
            let response = try await client.validateAccessToken()

            switch response {
            case let .ok(okResponse):
                switch okResponse.body {
                case .json(let dto):
                    return dto.authStatus
                }
            case .undocumented(statusCode: _, _):
                throw URLError(.unknown)
            }
        } catch {
            throw error
        }
    }

    func login(server: String, email: String, password: String) async throws -> User {
        self.server = server
        configureClientIfPossible()

        guard let client else { throw ImmichError.clientNotInitialized }

        do {
            let loginCredentialDto = Components.Schemas.LoginCredentialDto(email: email, password: password)
            let body = Operations.login.Input.Body.json(loginCredentialDto)
            let response = try await client.login(body: body)

            switch response {
            case .created(let response):
                switch response.body {
                case .json(let user):
                    return user
                }
            case .undocumented(statusCode: _, _):
                throw URLError(.unknown)
            }
        } catch {
            throw error
        }
    }

    func logout() {
        server = nil
        client = nil
        HTTPCookieStorage.shared.removeCookies(since: Date(timeIntervalSince1970: 0))
    }

    // MARK: Fetching data

    func fetchBuckets(album: Album? = nil) async throws -> [Bucket] {
        guard let client else { throw ImmichError.clientNotInitialized }

        do {
            let query = Operations.getTimeBuckets.Input.Query(albumId: album?.id)
            let response = try await client.getTimeBuckets(query: query)

            switch response {
            case let .ok(okResponse):
                switch okResponse.body {
                case .json(let timeBuckets):
                    return timeBuckets
                }
            case .undocumented(statusCode: _, _):
                throw URLError(.unknown)
            }
        } catch {
            throw error
        }
    }

    func fetchPhotos(timeBucket: Bucket, album: Album? = nil) async throws -> [Photo] {
        guard let client else { throw ImmichError.clientNotInitialized }

        do {
            let query = Operations.getTimeBucket.Input.Query(albumId: album?.id, timeBucket: timeBucket.timeBucket)
            let response = try await client.getTimeBucket(query: query)

            switch response {
            case let .ok(okResponse):
                switch okResponse.body {
                case .json(let timeBucket):
                    return timeBucket.id.map { id in
                        Photo(id: id)
                    }
                }
            case .undocumented(statusCode: _, _):
                throw URLError(.unknown)
            }
        } catch {
            throw error
        }
    }

    func fetchAlbums() async throws -> [Album] {
        guard let client else { throw ImmichError.clientNotInitialized }

        do {
            let response = try await client.getAllAlbums()

            switch response {
            case let .ok(okResponse):
                switch okResponse.body {
                case .json(let albums):
                    return albums
                        .sorted { lhs, rhs in
                            guard let lhsEndDate = lhs.endDate, let rhsEndDate = rhs.endDate else { return false }
                            return lhsEndDate.compare(rhsEndDate) == .orderedDescending
                        }
                }
            case .undocumented(statusCode: _, _):
                throw URLError(.unknown)
            }
        } catch {
            throw error
        }
    }
}

// MARK: - Images

extension ImmichModel {
    func thumbnailUrl(for photo: Photo, size: AssetSize) -> URL? {
        thumbnailUrl(for: photo.id, size: size.rawValue)
    }

    func thumbnailUrl(for album: Album, size: AssetSize) -> URL? {
        thumbnailUrl(for: album.albumThumbnailAssetId, size: size.rawValue)
    }

    private func thumbnailUrl(for photoId: String?, size: String) -> URL? {
        guard let photoId, let serverURL else { return nil }

        return URL(string: "\(serverURL.absoluteString)/assets/\(photoId)/thumbnail?size=\(size)")
    }
}

// MARK: - Mocks

extension ImmichModel {
    var thumbnailUrlMock: URL? {
        thumbnailUrl(for: Array.mockedPhotos[0], size: .thumbnail)
    }

    static var userMock: Components.Schemas.UserResponseDto {
        Components.Schemas.UserResponseDto(
            avatarColor: .init(value1: .orange),
            email: "john.doe@domain.com",
            id: "30908ebe-f1d2",
            name: "JohnD",
            profileChangedAt: Date(),
            profileImagePath: ""
        )
    }
}

extension Array where Element == Photo {
    static let mockedPhotos = [
        Photo(id: "30908ebe-f1d2-4618-a369-609a545c7798"),
        Photo(id: "e2ddc3d8-e247-4b0a-b13d-7c98f70eb1ee"),
        Photo(id: "be569c4e-cb17-4535-89a4-d0e78da1a8df")
    ]
}

extension Array where Element == Bucket {
    static let mockedBuckets = [
        Bucket(count: 99, timeBucket: "2024-05-01T00:00:00.000Z"),
        Bucket(count: 4, timeBucket: "2024-04-01T00:00:00.000Z"),
        Bucket(count: 143, timeBucket: "2024-03-01T00:00:00.000Z")
    ]
}

@MainActor
extension Array where Element == Album {
    static let mockedAlbums = [
        Album(albumName: "French Trip", albumThumbnailAssetId: "e3d0b96c-c0aa-4947-8ce6-b81783c0995a", albumUsers: [], assetCount: 1, assets: [], createdAt: Date(), description: "", endDate: Date(), hasSharedLink: true, id: "3e718879-83cd-4d38-b820-3e96ba7e3672", isActivityEnabled: true, owner: ImmichModel.userMock, ownerId: "", shared: true, updatedAt: Date()),
        Album(albumName: "Lindau, Austria, Lihtenshtein", albumThumbnailAssetId: "9af412d7-8718-48d2-b2c8-1892cd09521a", albumUsers: [], assetCount: 18, assets: [], createdAt: Date(), description: "", endDate: Date(),hasSharedLink: true, id: "3af2756e-98d1-41a7-92a1-1a9c9a1eb10b", isActivityEnabled: true, owner: ImmichModel.userMock, ownerId: "", shared: true, updatedAt: Date()),
        Album(albumName: "Ksianzh, Czoch, Jelenia Góra", albumThumbnailAssetId: "308d3c27-2e8f-42d1-b80f-433be39a7382", albumUsers: [], assetCount: 99, assets: [], createdAt: Date(), description: "", endDate: Date(),hasSharedLink: true, id: "12dcc83e-4dc0-4e24-b271-97910a31c518", isActivityEnabled: true, owner: ImmichModel.userMock, ownerId: "", shared: true, updatedAt: Date())
    ]
}
