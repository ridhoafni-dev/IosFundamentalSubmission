//
//  GameModel.swift
//  IosFundamentalSubmission
//
//  Created by User on 17/09/26.
//

import Foundation

struct GameResponses: Codable {
    let count: Int
    let next: String
    let results: [GameResponse]

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.next = try container.decode(String.self, forKey: .next)
        self.results = try container.decode(
            [GameResponse].self,
            forKey: .results
        )
    }

}

struct GameResponse: Codable {
    let id: Int
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
    }
}

struct GameDetailResponse: Codable {
    let id: Int
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let description: String?
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case description
    }
}
