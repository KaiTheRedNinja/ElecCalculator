//
//  ColorSnappingScrollView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 4/2/23.
//

import SwiftUI

struct ColorSnappingScrollView: View {
    @State var values: [Int]
    @State var height: CGFloat = 100
    @Binding var currentValue: Int
    @State var colorForValue: (Int) -> Color

    init(values: [Int],
         height: CGFloat = 100,
         currentValue: Binding<Int>,
         colorForValue: @escaping (Int) -> Color) {
        self.values = values
        self.height = height
        self._currentValue = currentValue
        self.colorForValue = colorForValue
    }

    @State var offset: CGFloat = 0

    var body: some View {
        GeometryReader { geom in
            ZStack {
                VStack {
                    ForEach(values, id: \.self) { value in
                        colorForValue(value)
                            .frame(height: height)
                            .padding(.vertical, -4)
                            .offset(y: height * ((CGFloat(values.count) / 2) - CGFloat(currentValue) - CGFloat(1)) + offset)
                    }
                }
                .gesture(DragGesture()
                    .onChanged { value in
                        withAnimation {
                            offset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        // evaluate the nearest item
                        let offsetCount = Int((offset/height).rounded())
                        let newValue = currentValue - offsetCount
                        withAnimation {
                            if newValue >= 0 && newValue < values.count {
                                currentValue -= offsetCount
                            }
                            offset = 0
                        }
                    }
                )
                .frame(height: geom.size.height)

                VStack {
                    Rectangle()
                        .fill(LinearGradient(stops: [.init(color: .white, location: 0),
                                                     .init(color: .clear, location: 1)],
                                             startPoint: .top,
                                             endPoint: .bottom))
                        .frame(height: height)
                        .padding(.vertical, -4)
                    Rectangle()
                        .fill(.clear)
                        .frame(height: height)
                        .padding(.vertical, -4)
                    Rectangle()
                        .fill(LinearGradient(stops: [.init(color: .clear, location: 0),
                                                     .init(color: .white, location: 1)],
                                             startPoint: .top,
                                             endPoint: .bottom))
                        .frame(height: height)
                        .padding(.vertical, -4)
                }
                .offset(y: -height / 2)
            }
            .mask {
                Rectangle()
                    .frame(height: height*3)
                    .offset(y: -height/2)
            }
        }
    }
}

struct ColorSnappingScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSnappingScrollViewWrapper()
    }

    struct ColorSnappingScrollViewWrapper: View {
        @State var curValue = 2

        var body: some View {
            ZStack {
                HStack {
                    Text("Cur: \(curValue)")
                    ColorSnappingScrollView(values: Array(0..<10), currentValue: $curValue) { val in
                        Resistor.valueToColor(value: val)
                    }
                    .frame(width: 20, height: 200)
                }
            }
            .frame(height: 100)
            .background {
                Color.blue
            }
        }
    }
}
