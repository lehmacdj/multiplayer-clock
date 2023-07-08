//
//  IconButton.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/7/23.
//

import SwiftUI

struct IconButton: View {
    let icon: Icon
    let action: () -> Void

    init(icon: Icon, action: @escaping () -> Void = {}) {
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                Image(systemName: icon.imageName)
                    .resizable(resizingMode: .stretch)
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(width: 60, height: 60)
        }
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(Icon.allCases) { icon in
                IconButton(icon: icon)
            }
        }
    }
}
