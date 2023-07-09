//
//  AnySettings.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/8/23.
//

import Combine
import Foundation

final class AnySettings: Settings {
    init<S: Settings>(settings: S) {
        self.settings = settings
        settingsChangeSubscription = settings.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    private let settings: any Settings
    private var settingsChangeSubscription: AnyCancellable?

    var configuration: MultiplayerClockConfiguration {
        settings.configuration
    }
    var configurationPublisher: AnyPublisher<MultiplayerClockConfiguration, Never> {
        settings.configurationPublisher
    }

    var playerTimesIndividuallyConfigurable: Bool {
        settings.playerTimesIndividuallyConfigurable
    }
    var playerTimesIndividuallyConfigurablePublisher: AnyPublisher<Bool, Never> {
        settings.playerTimesIndividuallyConfigurablePublisher
    }

    var countPastZero: Bool {
        settings.countPastZero
    }
    var countPastZeroPublisher: AnyPublisher<Bool, Never> {
        settings.countPastZeroPublisher
    }
}

extension Settings {
    func eraseToAnySettings() -> AnySettings {
        AnySettings(settings: self)
    }
}

final class AnyWritableSettings: WritableSettings {
    init<S: WritableSettings>(settings: S) {
        self.settings = settings
        settingsChangeSubscription = settings.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    private let settings: any WritableSettings
    private var settingsChangeSubscription: AnyCancellable?

    var configuration: MultiplayerClockConfiguration {
        get {
            settings.configuration
        }
        set {
            settings.configuration = newValue
        }
    }
    var configurationPublisher: AnyPublisher<MultiplayerClockConfiguration, Never> {
        settings.configurationPublisher
    }

    var playerTimesIndividuallyConfigurable: Bool {
        get {
            settings.playerTimesIndividuallyConfigurable
        }
        set {
            settings.playerTimesIndividuallyConfigurable = newValue
        }
    }
    var playerTimesIndividuallyConfigurablePublisher: AnyPublisher<Bool, Never> {
        settings.playerTimesIndividuallyConfigurablePublisher
    }

    var countPastZero: Bool {
        get {
            settings.countPastZero
        }
        set {
            settings.countPastZero = newValue
        }
    }
    var countPastZeroPublisher: AnyPublisher<Bool, Never> {
        settings.countPastZeroPublisher
    }
}

extension WritableSettings {
    func eraseToAnyWritableSettings() -> AnyWritableSettings {
        AnyWritableSettings(settings: self)
    }
}
