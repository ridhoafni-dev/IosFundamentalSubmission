//
//  NetworkService.swift
//  IosFundamentalSubmission
//
//  Created by User on 17/09/26.
//

import Foundation

class NetworkService {
    let apiKey = "20ccb0c50b354fdaa94c94ba428798dd"

    func getGames() async throws -> [Game] {
        var components = URLComponents(string: "https://api.rawg.io/api/games")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(GameResponses.self, from: data)
        
        return gamesMapper(input: result.results)
    }
    
    func getGame(id: Int) async throws -> GameDetail {
        var components = URLComponents(string: "https://api.rawg.io/api/games/\(id)")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }
        
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(GameDetailResponse.self, from: data)
        
        return gameDetailMapper(input: result)
    }
    
}

extension NetworkService {
    fileprivate func gamesMapper(
        input gameResponses: [GameResponse]
    ) -> [Game] {
        return gameResponses.map { result in
             Game(
                id: result.id,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage,
                rating: result.rating
            )
        }
    }
    
    fileprivate func gameDetailMapper(
        input gameResponses: GameDetailResponse
    ) -> GameDetail {
        return GameDetail(
            id: gameResponses.id,
            name: gameResponses.name,
            released: gameResponses.released,
            backgroundImage: gameResponses.backgroundImage,
            rating: gameResponses.rating,
            description: gameResponses.description
        )
    }
    
}
