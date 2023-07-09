//
//  MultiplayerClock.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import Foundation

struct MultiplayerClock {
    var currentPlayer: Int
    var players: [Player]
    var state: State

    enum State: CaseIterable, Hashable {
        case unstarted
        case running
        case paused
        case finished
    }

    init(playerCount: Int, time: Duration) {
        self.init(configuration: .init(playerCount: playerCount, time: time))
    }

    init(configuration: MultiplayerClockConfiguration) {
        currentPlayer = 0
        players = configuration.players.map { Player(configuration: $0) }
        state = .unstarted
    }

    mutating func elapse(time: Duration) {
        assert(state == .running)
        players[currentPlayer].time -= time
        if players[currentPlayer].time <= .zero {
            players[currentPlayer].time = .zero
            state = .finished
        }
    }

    mutating func switchToNextPlayer() {
        assert(state == .running)
        currentPlayer = (currentPlayer + 1) % players.count
    }

    mutating func play() {
        assert(state == .unstarted || state == .paused)
        state = .running
    }

    mutating func pause() {
        assert(state == .running)
        state = .paused
    }
}
