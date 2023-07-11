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
    var settings: AnySettings

    enum State: CaseIterable, Hashable {
        case unstarted
        case running
        case paused
        case finished
    }

    init(playerCount: Int, time: Duration, settings: AnySettings) {
        self.init(configuration: .init(playerCount: playerCount, time: time), settings: settings)
    }

    init(configuration: MultiplayerClockConfiguration, settings: AnySettings) {
        currentPlayer = 0
        players = configuration.players.map { Player(configuration: $0) }
        state = .unstarted
        self.settings = settings
    }

    mutating func elapse(time: Duration) {
        assert(state == .running)
        players[currentPlayer].time -= time
        if players[currentPlayer].time <= .zero && !settings.countPastZero {
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
