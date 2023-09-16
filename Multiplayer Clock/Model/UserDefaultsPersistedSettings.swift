//
//  AppStorageSettings.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 9/15/23.
//

import Combine
import Foil
import Foundation

class UserDefaultsPersistedSettings: WritableSettings {
    @WrappedDefault(key: "configuration") var configuration: MultiplayerClockConfiguration = .init(playerCount: 3, time: .minutes(5))
    var configurationPublisher: AnyPublisher<MultiplayerClockConfiguration, Never> {
        $configuration
    }

    @WrappedDefault(key: "playerTimesIndividuallyConfigurable") var playerTimesIndividuallyConfigurable = false {
        didSet {
            if playerTimesIndividuallyConfigurable == false && oldValue {
                configuration = MultiplayerClockConfiguration(
                    playerCount: configuration.players.count,
                    time: configuration.players.first!.time
                )
            }
        }
    }
    var playerTimesIndividuallyConfigurablePublisher: AnyPublisher<Bool, Never> {
        $playerTimesIndividuallyConfigurable
    }

    @WrappedDefault(key: "countPastZero") var countPastZero = false
    var countPastZeroPublisher: AnyPublisher<Bool, Never> {
        $countPastZero
    }

    @WrappedDefault(key: "pauseClockWhenBackgrounding") var pauseClockWhenBackgrounding = true
    var pauseClockWhenBackgroundingPublisher: AnyPublisher<Bool, Never> {
        $pauseClockWhenBackgrounding
    }

    @WrappedDefault(key: "pauseClockWhenBackgrounding") var showTenthsOfASecond = false
    var showTenthsOfASecondPublisher: AnyPublisher<Bool, Never> {
        $pauseClockWhenBackgrounding
    }
}
