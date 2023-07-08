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
        players = .init(repeatElement(PlayerConfiguration(time: time), count: playerCount))
    }
}
