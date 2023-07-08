//
//  DurationPicker.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/8/23.
//

import SwiftUI

struct DurationPicker: View {
    @Binding var duration: Duration

    @State var minutes: Int
    @State var seconds: Int

    init(duration: Binding<Duration>) {
        _duration = duration
        let seconds = duration.wrappedValue.components.seconds
        _minutes = State(initialValue: Int(seconds / 60))
        _seconds = State(initialValue: Int(seconds % 60))
    }

    func updateDuration(_: Int) {
        duration = .minutes(minutes) + .seconds(seconds)
    }

    var body: some View {
        HStack {
            Picker("Minutes", selection: $minutes) {
                ForEach(0..<61) { minute in
                    Text("\(minute) minutes")
                }
            }
            .pickerStyle(WheelPickerStyle())
            Picker("Seconds", selection: $seconds) {
                ForEach((0..<4).map { $0 * 15 }, id: \.self) { second in
                    Text("\(second) seconds")
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
        .onChange(of: minutes, perform: updateDuration)
        .onChange(of: seconds, perform: updateDuration)
    }
}

struct DurationPickerPreivews: PreviewProvider {
    @State static var duration: Duration = .minutes(5) + .seconds(30)

    static var previews: some View {
        DurationPicker(duration: $duration)
    }
}
