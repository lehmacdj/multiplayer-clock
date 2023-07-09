//
//  ClockVM.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import Combine
import Foundation

protocol ClockVM: ObservableObject {
    /// index of the current player in the players array
    var currentPlayer: Int { get }
    associatedtype CurrentPlayerPublisher: Publisher<Int, Never>
    var currentPlayerPublisher: CurrentPlayerPublisher { get }

    /// array of players; the order of these is assumed to be fixed
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
