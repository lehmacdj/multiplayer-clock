//
//  MultiplayerClockConfiguration.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import Foundation
import Foil

struct MultiplayerClockConfiguration: Codable {
    var players: [PlayerConfiguration]

    init(playerCount: Int, time: Duration) {
        assert(playerCount <= Constants.maxPlayerCount && playerCount >= Constants.minPlayerCount)
        players = .init(repeatElement(PlayerConfiguration(time: time), count: playerCount))
    }

    mutating func addPlayer() {
        assert(players.count > 0 && players.count < Constants.maxPlayerCount)
        players.append(PlayerConfiguration(time: players.last!.time))
    }

    mutating func removePlayer() {
        assert(players.count > Constants.minPlayerCount, "can't have less than one player")
        players.removeLast()
    }

    static let `default` = Self(playerCount: 3, time: .minutes(5))
}

extension MultiplayerClockConfiguration: UserDefaultsSerializable {
    typealias StoredValue = Data

    var storedValue: Data {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            return Data()
        }
    }

    init(storedValue: Data) {
        let decoder = JSONDecoder()
        do {
            self = try decoder.decode(MultiplayerClockConfiguration.self, from: storedValue)
        } catch {
            self = .default
        }
    }
}
