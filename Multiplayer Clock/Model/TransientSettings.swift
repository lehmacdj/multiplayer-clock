//
//  TransientSettings.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/8/23.
//

import Combine
import Foundation

/// Settings that are only stored in memory and restored from the default value whenever the app is restarted
class TransientSettings: WritableSettings {
    @Published var configuration: MultiplayerClockConfiguration = .init(playerCount: 3, time: .seconds(30))
    var configurationPublisher: AnyPublisher<MultiplayerClockConfiguration, Never> {
        $configuration.eraseToAnyPublisher()
    }

    @Published var playerTimesIndividuallyConfigurable: Bool = false
    var playerTimesIndividuallyConfigurablePublisher: AnyPublisher<Bool, Never> {
        $playerTimesIndividuallyConfigurable.eraseToAnyPublisher()
    }
}
