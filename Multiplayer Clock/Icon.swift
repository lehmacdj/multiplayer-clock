//
//  Icon.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import Foundation
import SwiftUI

enum Icon: CaseIterable, Hashable {
    case gear
    case pause
    case reset
}

extension Icon: Identifiable {
    var id: Self { self }
}

extension Icon {
    var imageName: String {
        switch self {
        case .gear:
            return "gearshape"
        case .pause:
            return "pause.fill"
        case .reset:
            return "arrow.triangle.2.circlepath"
        }
    }
}
