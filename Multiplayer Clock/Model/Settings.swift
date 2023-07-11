//
//  Settings.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import Combine
import Foundation
import SwiftUI

protocol Settings: ObservableObject {
    var configuration: MultiplayerClockConfiguration { get }
    var configurationPublisher: AnyPublisher<MultiplayerClockConfiguration, Never> { get }

    /// Implementers should ensure that setting this corrects the configuration so that it is compliant
    var playerTimesIndividuallyConfigurable: Bool { get }
    var playerTimesIndividuallyConfigurablePublisher: AnyPublisher<Bool, Never> { get }

    var countPastZero: Bool { get }
    var countPastZeroPublisher: AnyPublisher<Bool, Never> { get }

    var pauseClockWhenBackgrounding: Bool { get }
    var pauseClockWhenBackgroundingPublisher: AnyPublisher<Bool, Never> { get }
}

protocol WritableSettings: Settings {
    var configuration: MultiplayerClockConfiguration { get set }
    var playerTimesIndividuallyConfigurable: Bool { get set }
    var countPastZero: Bool { get set }
    var pauseClockWhenBackgrounding: Bool { get set }
}

/// Common operations on settings irrespective of storage implementation
extension WritableSettings {
    var addPlayer: (() -> Void)? {
        guard configuration.players.count < Constants.maxPlayerCount else {
            return nil
        }
        return { [weak self] in self?.configuration.addPlayer() }
    }

    var removePlayer: (() -> Void)? {
        guard configuration.players.count > Constants.minPlayerCount else {
            return nil
        }
        return { [weak self] in self?.configuration.removePlayer() }
    }

    var allPlayersTime: Binding<Duration> {
        .init(
            get: { [weak self] in self!.configuration.players.first!.time },
            set: { [weak self] newValue in
                guard let self else { return }
                configuration = .init(playerCount: configuration.players.count, time: newValue)
            }
        )
    }
}
