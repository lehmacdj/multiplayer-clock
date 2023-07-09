//
//  Collections+Extensions.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/9/23.
//

import Foundation

extension Array {
    func shifted(by shift: Int) -> Self {
        var copy = self
        for i in 0..<copy.count {
            copy[i] = self[(i + shift) % count]
        }
        return copy
    }
}
