//
//  ResistorShape.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 5/2/23.
//

import SwiftUI

struct ResistorShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: 0)) // top left

        // top indent
        path.addLine(to: CGPoint(x: 60, y: 0))
        path.addLine(to: CGPoint(x: 60, y: 8))
        path.addLine(to: CGPoint(x: rect.width-60, y: 8))
        path.addLine(to: CGPoint(x: rect.width-60, y: 0))

        path.addLine(to: CGPoint(x: rect.width, y: 0)) // top right
        path.addLine(to: CGPoint(x: rect.width, y: rect.height)) // bottom right

        // bottom indent
        path.addLine(to: CGPoint(x: rect.width-60, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width-60, y: rect.height-8))
        path.addLine(to: CGPoint(x: 60, y: rect.height-8))
        path.addLine(to: CGPoint(x: 60, y: rect.height))

        path.addLine(to: CGPoint(x: 0, y: rect.height)) // bottom left

        return path
    }
}

struct ResistorShape_Previews: PreviewProvider {
    static var previews: some View {
        ResistorShape()
            .frame(width: 300, height: 100)
    }
}
