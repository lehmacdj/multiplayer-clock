//
//  FixedDecrementClockVM.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import Combine
import Foundation

/// A ClockVM that decrements by a fixed amount when pausing or switching turns
final class FixedDecrementClockVM: ClockVM {
    init(settings: AnySettings, decrement: Duration) {
        self.settings = settings
        self.clock = MultiplayerClock(configuration: settings.configuration)
        self.decrement = decrement

        settings.configurationPublisher.sink { [weak self] configuration in
            if self?.clock.state == .unstarted {
                self?.reset(with: configuration)
            }
        }
        .store(in: &subscriptions)
    }

    private var settings: AnySettings
    @Published private var clock: MultiplayerClock
    private let decrement: Duration
    private var subscriptions = Set<AnyCancellable>()

    var currentPlayer: Int {
        clock.currentPlayer
    }
    var currentPlayerPublisher: some Publisher<Int, Never> {
        $clock.map(\.currentPlayer)
    }

    var players: [Player] {
        clock.players
    }
    var playerTimesPublisher: some Publisher<[Player], Never> {
        $clock.map(\.players)
    }

    var state: MultiplayerClock.State {
        clock.state
    }
    var statePublisher: some Publisher<MultiplayerClock.State, Never> {
        $clock.map(\.state)
    }

    func play() {
        clock.play()
    }

    func pause() {
        clock.elapse(time: decrement)
        guard state == .running else { return }
        clock.pause()
    }

    /// Sadly we need a stub like this for protocol conformance even though it would be
    /// possible to call reset without arguments anyways
    func reset() {
        reset(with: nil)
    }

    private func reset(with configuration: MultiplayerClockConfiguration? = nil) {
        let configuration = configuration ?? settings.configuration
        clock = MultiplayerClock(configuration: configuration)
    }

    func switchToNextPlayer() {
        clock.elapse(time: decrement)
        guard state == .running else { return }
        clock.switchToNextPlayer()
    }
}
