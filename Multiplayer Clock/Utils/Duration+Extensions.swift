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

    var seconds: Double {
        let v = components
        return Double(v.seconds) + Double(v.attoseconds) * 1e-18
    }
}

extension Date {
    func durationSince(_ date: Date) -> Duration {
        .seconds(self.timeIntervalSince(date))
    }
}
