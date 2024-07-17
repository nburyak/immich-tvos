import Foundation
import HTTPTypes
import OpenAPIURLSession
import OpenAPIRuntime

struct AuthenticationMiddleware: ClientMiddleware {
    private let accessTokenHeader: HTTPField

    init?(accessToken: String?) {
        guard let accessToken, let headerName = HTTPField.Name("immich_access_token") else { return nil }
        accessTokenHeader = HTTPField(name: headerName, value: accessToken)
    }

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        request.headerFields.append(accessTokenHeader)
        return try await next(request, body, baseURL)
    }
}
