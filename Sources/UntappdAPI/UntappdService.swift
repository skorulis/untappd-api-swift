//  Created by Alexander Skorulis on 2/4/2026.

import Foundation

public enum UntappdServiceError: Error {
    case invalidHTTPStatus(Int)
    case invalidURL
    case invalidIDs
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
    
    public func search(text: String) async throws -> UntappdSearchResponse {
        return try await get(path: "/search/beer", params: ["q": text])
    }

    public func fetchBeerData(beerId: String) async throws -> GetBeerResponse {
        try await get(path: "/beer/info/\(beerId)")
    }

    public func fetchBreweryData(breweryId: Int) async throws -> Data {
        try await get(path: "/brewery/info/\(breweryId)")
    }
    
    private func get<T: Decodable>(path: String, params: [String: String] = [:]) async throws -> T {
        let data = try await get(path: path, params: params)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    private func get(path: String, params: [String: String] = [:]) async throws -> Data {
        guard !clientID.isEmpty && !clientSecret.isEmpty else {
            throw UntappdServiceError.invalidIDs
        }
        var components = URLComponents(string: Self.apiBase + path)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: clientSecret),
        ]
        for (key, value) in params {
            components?.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        guard let url = components?.url else {
            throw UntappdServiceError.invalidURL
        }
        
        print("UNTAPPD: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, response) = try await urlSession.data(for: request)
        if let http = response as? HTTPURLResponse, http.statusCode >= 400 {
            throw UntappdServiceError.invalidHTTPStatus(http.statusCode)
        }
        return data
    }
}
