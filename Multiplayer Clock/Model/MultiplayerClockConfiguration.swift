//
//  MultiplayerClockConfiguration.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import Foundation

struct MultiplayerClockConfiguration {
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
}
