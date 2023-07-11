//
//  Duration+Extensions.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/8/23.
//

import Foundation

extension Duration {
    static func minutes<T>(_ minutes: T) -> Self where T: BinaryInteger {
        .seconds(minutes * 60)
    }

    var magnitude: Duration {
        let components = self.components
        return .init(
            secondsComponent: abs(components.seconds),
            attosecondsComponent: abs(components.attoseconds)
        )
    }

    var seconds: Double {
        let v = components
        return Double(v.seconds) + Double(v.attoseconds) * 1e-18
    }
}

struct TimeLeft: FormatStyle {
    func format(_ duration: Duration) -> String {
        if duration.magnitude >= .minutes(100) {
            return duration.formatted(.time(pattern: .hourMinuteSecond))
        } else if duration.magnitude >= .minutes(1) {
            return duration.formatted(.time(pattern: .minuteSecond))
        } else {
            return duration.seconds.formatted(.number.precision(.fractionLength(1)))
        }
    }
}

extension FormatStyle where Self == TimeLeft {
    static var timeLeft: TimeLeft { TimeLeft() }
}

extension Date {
    func durationSince(_ date: Date) -> Duration {
        .seconds(self.timeIntervalSince(date))
    }
}
