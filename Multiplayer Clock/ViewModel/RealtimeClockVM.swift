//
//  RealtimeClockVM.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/9/23.
//

import Combine
import Foundation

/// A ClockVM that decrements by a fixed amount when pausing or switching turns
final class RealtimeClockVM: ClockVM {
    init(settings: AnySettings) {
        self.settings = settings
        self.clock = MultiplayerClock(configuration: settings.configuration)

        settings.configurationPublisher.sink { [weak self] configuration in
            if self?.clock.state == .unstarted {
                self?.reset(with: configuration)
            }
        }
        .store(in: &subscriptions)

    }

    private var settings: AnySettings
    @Published private var clock: MultiplayerClock
    private var subscriptions = Set<AnyCancellable>()

    private var timerSubscription: AnyCancellable?
    private var lastTime: Date?

    private func elapseTime() {
        guard let lastTime else { fatalError("last time should be set whenever timer is set") }
        let now = Date.now
        let delta = now.durationSince(lastTime)
        self.lastTime = now
        guard clock.state == .running else {
            stopTimer()
            return
        }
        clock.elapse(time: delta)
    }

    private func startTimer() {
        lastTime = .now
        timerSubscription = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.elapseTime() }
    }

    private func stopTimer() {
        timerSubscription = nil
        lastTime = nil
    }

    var currentPlayer: UUID {
        clock.players[clock.currentPlayer].id
    }
    var currentPlayerPublisher: some Publisher<UUID, Never> {
        $clock.map { $0.players[$0.currentPlayer].id }
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
        startTimer()
    }

    func pause() {
        elapseTime()
        stopTimer()
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
        elapseTime()
        guard state == .running else { return }
        clock.switchToNextPlayer()
    }
}
