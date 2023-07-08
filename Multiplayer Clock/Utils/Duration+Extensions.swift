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
}
