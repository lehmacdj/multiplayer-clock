//
//  PlayerTime.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import Foundation

struct Player: Identifiable {
    let id = UUID()
    var time: Duration

    init(configuration: PlayerConfiguration) {
        time = configuration.time
    }
}
