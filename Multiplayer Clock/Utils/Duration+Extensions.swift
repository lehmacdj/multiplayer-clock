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
        // apple's time formatter formats negative durations weirdly as "-6:-23" for example
        let nonNegativeFormat = formatNonNegative(duration.magnitude)
        let prefix = duration < .zero ? "-" : ""
        return prefix + nonNegativeFormat
    }

    private func formatNonNegative(_ duration: Duration) -> String {
        if duration >= .minutes(100) {
            return duration.formatted(.time(pattern: .hourMinuteSecond))
        } else if duration >= .minutes(1) {
            return duration.formatted(.time(pattern: .minuteSecond))
        } else if showTenthsOfASecond {
            return duration.seconds.formatted(.number.precision(.fractionLength(1)))
        } else {
            return duration.seconds.formatted(.number.precision(.fractionLength(0)))
        }
    }
}

extension FormatStyle where Self == TimeLeft {
    static func timeLeft(showTenthsOfASecond: Bool) -> TimeLeft {
        TimeLeft(showTenthsOfASecond: showTenthsOfASecond)
    }
}

extension Date {
    func durationSince(_ date: Date) -> Duration {
        .seconds(self.timeIntervalSince(date))
    }
}
