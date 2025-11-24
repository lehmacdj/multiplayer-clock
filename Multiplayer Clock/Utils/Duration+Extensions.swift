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
    let showTenthsOfASecond: Bool

    func format(_ duration: Duration) -> String {
        let formatted: String
        if duration.magnitude >= .minutes(100) {
            formatted = duration.formatted(.time(pattern: .hourMinuteSecond))
        } else if duration.magnitude >= .minutes(1) {
            formatted = duration.formatted(.time(pattern: .minuteSecond))
        } else if showTenthsOfASecond {
            formatted = duration.seconds.formatted(.number.precision(.fractionLength(1)))
        } else {
            formatted = duration.seconds.formatted(.number.precision(.fractionLength(0)))
        }

        // Avoid showing "-0" or "-0.0" by replacing with positive zero
        if formatted == "-0" || formatted == "-0.0" {
            return formatted.replacingOccurrences(of: "-", with: "")
        }
        return formatted
    }
}

extension FormatStyle where Self == TimeLeft {
    static func timeLeft(showTenthsOfASecond: Bool) -> TimeLeft {
        TimeLeft(showTenthsOfASecond: showTenthsOfASecond)
    }

    static var timeLeft: TimeLeft { timeLeft(showTenthsOfASecond: true) }
}

extension Date {
    func durationSince(_ date: Date) -> Duration {
        .seconds(self.timeIntervalSince(date))
    }
}
