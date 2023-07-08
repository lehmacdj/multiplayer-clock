//
//  ClockVM.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import Combine
import Foundation

protocol ClockVM: ObservableObject {
    var currentPlayer: UUID { get }
    associatedtype CurrentPlayerPublisher: Publisher<UUID, Never>
    var currentPlayerPublisher: CurrentPlayerPublisher { get }

    var players: [Player] { get }
    associatedtype PlayersPublisher: Publisher<[Player], Never>
    var playerTimesPublisher: PlayersPublisher { get }

    var state: MultiplayerClock.State { get }
    associatedtype StatePublisher: Publisher<MultiplayerClock.State, Never>
    var statePublisher: StatePublisher { get }

    func play()
    func pause()
    func reset()
    func switchToNextPlayer()
}
