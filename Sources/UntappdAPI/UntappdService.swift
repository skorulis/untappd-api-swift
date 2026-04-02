//  Created by Alexander Skorulis on 2/4/2026.

import Foundation

public enum UntappdServiceError: Error {
    case invalidHTTPStatus(Int)
    case invalidURL
}

/// Performs HTTP requests to the Untappd API. Response handling (decode, persistence, business logic) belongs to the caller.
public final class UntappdService: @unchecked Sendable {

    private static let apiBase = "https://api.untappd.com/v4"

    private let clientID: String
    private let clientSecret: String
    private let urlSession: URLSession

    public init(clientID: String, clientSecret: String, urlSession: URLSession = .shared) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.urlSession = urlSession
    }

    public func fetchBeerData(beerId: String) async throws -> Data {
        try await get(path: "/beer/info/\(beerId)")
    }

    public func fetchBreweryData(breweryId: Int) async throws -> Data {
        try await get(path: "/brewery/info/\(breweryId)")
    }

    private func get(path: String) async throws -> Data {
        var components = URLComponents(string: Self.apiBase + path)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: clientSecret),
        ]
        guard let url = components?.url else {
            throw UntappdServiceError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await urlSession.data(for: request)
        if let http = response as? HTTPURLResponse, http.statusCode >= 400 {
            throw UntappdServiceError.invalidHTTPStatus(http.statusCode)
        }
        return data
    }
}
