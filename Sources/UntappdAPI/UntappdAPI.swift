//  Created by Alexander Skorulis on 29/3/2024.

import Foundation

public enum UntappdAPI {

    public struct GetBeerResponse: Codable {

        public let response: Response

        public struct Response: Codable {
            public let beer: Beer
        }
    }

    public struct GetBreweryResponse: Codable {
        public let response: Response

        public struct Response: Codable {
            public let brewery: Brewery
        }
    }

    public struct Beer: Codable {
        public let bid: Int
        public let beer_name: String
        public let beer_label: String
        public let beer_label_hd: String
        public let beer_abv: Double
        public let beer_ibu: Int?
        public let beer_description: String
        public let beer_style: String
        public let beer_slug: String
        public let rating_count: Int
        public let rating_score: Double

        public let brewery: Brewery
        public let stats: Stats

        public var url: String {
            "https://untappd.com/b/\(brewery.brewery_slug)-\(beer_slug)/\(bid)"
        }
    }

    public struct Brewery: Codable {
        public let brewery_id: Int
        public let brewery_name: String
        public let brewery_slug: String
        public let brewery_label: String
        public let country_name: String
        public let brewery_in_production: Int?
        public let is_independent: Int?
        public let claimed_status: ClaimedStatus?
        public let contact: Contact
        public let brewery_type: String
        public let brewery_type_id: Int?
        public let location: Location?
    }

    public struct Stats: Codable {
        public let total_count: Int
        public let monthly_count: Int
        public let total_user_count: Int
        public let user_count: Int
    }

    public struct ClaimedStatus: Codable {
        public let is_claimed: Bool
        public let claimed_slug: String
        public let follow_status: Bool
        public let follower_count: Int
        public let uid: Int
        public let mute_status: String
    }

    public struct Contact: Codable {
        public let twitter: String?
        public let facebook: String?
        public let instagram: String?
        public let url: String?
        public let slug: String?
    }

    public struct Location: Codable {
        public let address: String?
        public let lat: Double?
        public let lng: Double?
    }
}
