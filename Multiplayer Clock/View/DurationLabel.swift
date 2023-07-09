//
//  DurationLabel.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/9/23.
//

import SwiftUI

struct DurationLabel: View {
    let duration: Duration

    private var formattedDuration: String {
        if duration >= .minutes(100) {
            return duration.formatted(.time(pattern: .hourMinuteSecond))
        } else if duration >= .minutes(1) {
            return duration.formatted(.time(pattern: .minuteSecond))
        } else {
            return duration.seconds.formatted(.number.precision(.fractionLength(1)))
        }
    }

    var body: some View {
        Text(formattedDuration)
            .font(.largeTitle)
    }
}

struct DurationLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DurationLabel(duration: .minutes(150) + .seconds(12))
            DurationLabel(duration: .minutes(99) + .seconds(59))
            DurationLabel(duration: .minutes(5) + .seconds(17.3))
            DurationLabel(duration: .seconds(17.310481084018))
        }
    }
}
