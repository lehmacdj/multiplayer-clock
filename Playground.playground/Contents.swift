// avoid committing this file. you can use:
// `git update-index --skip-wortree Playground.playground/Contents.swift`
// to avoid seeing this file as changed in `git status`

import Combine
import PlaygroundSupport
import SwiftUI
import UIKit

var angles = [[Double]]()
for n in 1...6 {
    angles.append([])
    for i in 0..<n {
        angles[n - 1].append(Double(i) / Double(n))
    }
}

print(angles)
