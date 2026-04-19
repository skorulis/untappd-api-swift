//  Created by Alex Skorulis on 19/4/2026.

import Foundation

public struct UntappdSearchResponse: Codable, Hashable {
    public let response: Inner
}

public extension UntappdSearchResponse {
    
    struct Inner: Codable, Hashable {
        public let term: String
        public let beers: BeerList
    }
    
    struct BeerList: Codable, Hashable {
        public let count: Int
        public let items: [Item]
    }
    
    struct Item: Codable, Identifiable, Hashable {
        public let have_had: Bool
        public let beer: Beer
        public let brewery: Brewery
        
        public var id: Int { beer.bid }
        
        public var imageURL: URL? {
            URL(string: beer.beer_label)
        }
        
        public var pctString: String {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            let value = formatter.string(from: beer.beer_abv as NSNumber) ?? ""
            return "\(value)"
        }
    }
    
    struct Beer: Codable, Hashable {
        public let bid: Int
        public let beer_name: String
        public let beer_label: String
        public let beer_abv: Float
        public let beer_style: String?
    }
    
    struct Brewery: Codable, Hashable {
        public let brewery_id: Int
        public let brewery_name: String
        public let country_name: String?
        public let location: Location?
    }
    
    struct Location: Codable, Hashable {
        public let brewery_city: String?
        public let brewery_state: String?
    }
}
