//
//  PartitionedRectanglesLayout.swift
//  Multiplayer Clock
//
//  Created by Devin Lehmacher on 9/15/23.
//

import SwiftUI

struct PartitionedRectanglesLayout: Layout {
    private enum Dimension {
        case width
        case height
    }
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        // we assume we're placing views starting from the top side 
        // switching sides when we get a subview whose ideal size is longer in a different dimension than the previous side
        var side = 0 // represents the top side, 3 represents the leading side and 1 represents the trailing side w/ 2 representing the bottom
        var longestDimension: Dimension = .height // since we start placing at the top we pretend that we were just placing on the leading edge
        // keep track of the total contribution to the size of this view by the views placed along each of this views sides
        // for the dimension matching the side (e.g. for side 1 the height) this is the sum of all of the subviews
        // for the dimension not matching the side (e.g. for side 1 the width) this is the max of all of the subviews
        var sideWidths: [CGFloat] = [0, 0, 0, 0]
        var sideHeights: [CGFloat] = [0, 0, 0, 0]
        for subview in subviews {
            let ideal = subview.sizeThatFits(.unspecified)
            let previousLongestDimension = longestDimension
            if ideal.width > ideal.height {
                longestDimension = .width
            } else if ideal.height > ideal.width {
                longestDimension = .height
            } // we don't switch which dimension we're placing along if the view we're placing is square
            if longestDimension != previousLongestDimension {
                // if we get more switches than expected, we just lump everything on the last side
                // the user of the layout should try to give the subviews in a good arrangement
                side = min(3, side + 1)
            }
            if side % 2 == 0 {
                // dimension's subviews have width long
                sideWidths[side] = sideWidths[side] + ideal.width
                sideHeights[side] = max(sideHeights[side], ideal.width)
            } else {
                // dimension's subviews have height long
                sideWidths[side] = max(sideWidths[side], ideal.width)
                sideHeights[side] = sideHeights[side] + ideal.width
            }
        }

        let aspectRatioGoal: CGFloat
        switch (proposal.height, proposal.width) {
        case (nil, nil):
            // default to trying to make the bounding rectangle as square as possible
            aspectRatioGoal = 1
        case (.some(_), nil):
            aspectRatioGoal = 0
        case (nil, .some(_)):
            aspectRatioGoal = .infinity
        case (.some(let height), .some(let width)):
            aspectRatioGoal = height / width
        }

        // there are two possible configurations, either the top / bottom are stacked above/below the leading/trailing
        // or the leading/trailing are stacked left/right of the top / bottom
        // this leads to a stacked/minimum number for each dimension
        let minWidth = max(sideWidths[0], sideWidths[2], sideWidths[1] + sideWidths[3])
        let minHeight = max(sideHeights[1], sideHeights[3], sideHeights[0] + sideHeights[1])
        let stackedWidth = sideWidths[1] + sideWidths[3] + max(sideWidths[0], sideWidths[2])
        let stackedHeight = sideWidths[1] + sideWidths[3] + max(sideWidths[0], sideWidths[2])
        let topBottomStackedAspectRatio = stackedHeight / minWidth
        let leadingTrailingStackedAspectRatio = stackedWidth / minHeight

        let replacingDimensions: CGSize
        if abs(aspectRatioGoal - topBottomStackedAspectRatio) <= abs(aspectRatioGoal - leadingTrailingStackedAspectRatio) {
            replacingDimensions = CGSize(width: minWidth, height: stackedHeight)
        } else {
            replacingDimensions = CGSize(width: stackedWidth, height: minHeight)
        }
        return proposal.replacingUnspecifiedDimensions(by: replacingDimensions)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        <#code#>
    }
}
