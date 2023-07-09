//
//  Geometry.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 7/8/23.
//

import Foundation
import SwiftUI

struct Ray {
    let origin: CGPoint

    /// Direction of the ray, represented by an angle from (1, 0), i.e. the way angles are typically measured on the unit circle
    let direction: Angle

    init(origin: CGPoint, direction: Angle) {
        assert(direction < .radians(2 * .pi))
        self.origin = origin
        self.direction = direction
    }
}

struct Line {
    let start: CGPoint
    let end: CGPoint
}

extension Line {
    /// https://www.hackingwithswift.com/example-code/core-graphics/how-to-calculate-the-point-where-two-lines-intersect
    func intersection(with other: Line) -> CGPoint? {
        // calculate the differences between the start and end X/Y positions for each of our points
        let delta1x = self.end.x - self.start.x
        let delta1y = self.end.y - self.start.y
        let delta2x = other.end.x - other.start.x
        let delta2y = other.end.y - other.start.y

        // create a 2D matrix from our vectors and calculate the determinant
        let determinant = delta1x * delta2y - delta2x * delta1y

        if abs(determinant) < 0.0001 {
            // if the determinant is effectively zero then the lines are parallel/colinear
            return nil
        }

        // if the coefficients both lie between 0 and 1 then we have an intersection
        let ab = ((self.start.y - other.start.y) * delta2x - (self.start.x - other.start.x) * delta2y) / determinant

        if ab > 0 && ab < 1 {
            let cd = ((self.start.y - other.start.y) * delta1x - (self.start.x - other.start.x) * delta1y) / determinant

            if cd > 0 && cd < 1 {
                // lines cross – figure out exactly where and return it
                let intersectX = self.start.x + ab * delta1x
                let intersectY = self.start.y + ab * delta1y
                return CGPoint(x: intersectX, y: intersectY)
            }
        }

        // lines don't cross
        return nil
    }

    func intersection(with ray: Ray) -> CGPoint? {
        let multiplier = 2.0 // arbitrary number to make sure the ray goes far enough
        let otherPoint: CGPoint
        // compute an additional point for the ray guaranteed to intersect if the ray would
        if ray.direction < .radians(.pi / 4) || ray.direction > .radians(7 * .pi / 4) {
            let greaterX = max(self.start.x, self.end.x)
            guard greaterX >= ray.origin.x else { return nil }
            let width = (greaterX - ray.origin.x) * multiplier
            otherPoint = CGPoint(x: ray.origin.x + width, y: ray.origin.y + width * tan(ray.direction.radians))
        } else if ray.direction >= .radians(.pi / 4) && ray.direction < .radians(3 * .pi / 4) {
            let greaterY = max(self.start.y, self.end.y)
            guard greaterY >= ray.origin.y else { return nil }
            let height = (greaterY - ray.origin.y) * multiplier
            otherPoint = CGPoint(x: ray.origin.x + height / tan(ray.direction.radians), y: ray.origin.y + height)
        } else if ray.direction >= .radians(3 * .pi / 4) && ray.direction < .radians(5 * .pi / 4) {
            let lesserX = min(self.start.x, self.end.x)
            guard lesserX <= ray.origin.x else { return nil }
            let width = (lesserX - ray.origin.x) * multiplier
            otherPoint = CGPoint(x: ray.origin.x + width, y: ray.origin.y + width * tan(ray.direction.radians))
        } else {
            let lesserY = min(self.start.y, self.end.y)
            guard lesserY <= ray.origin.y else { return nil }
            let height = (lesserY - ray.origin.y) * multiplier
            otherPoint = CGPoint(x: ray.origin.x + height / tan(ray.direction.radians), y: ray.origin.y + height)
        }
        return self.intersection(with: Line(start: ray.origin, end: otherPoint))
    }
}

extension CGRect {
    var lines: [Line] {
        [
            Line(start: CGPoint(x: minX, y: minY), end: CGPoint(x: minX, y: maxY)),
            Line(start: CGPoint(x: minX, y: maxY), end: CGPoint(x: maxX, y: maxY)),
            Line(start: CGPoint(x: maxX, y: maxY), end: CGPoint(x: maxX, y: minY)),
            Line(start: CGPoint(x: maxX, y: minY), end: CGPoint(x: minX, y: minY)),
        ]
    }

    func intersection(with ray: Ray) -> [CGPoint] {
        lines.compactMap { $0.intersection(with: ray) }
    }
}
