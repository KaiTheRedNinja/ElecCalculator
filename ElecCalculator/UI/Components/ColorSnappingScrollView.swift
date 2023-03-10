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
    @State var currentOffset: Int
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

        self.currentOffset = values.firstIndex(of: currentValue.wrappedValue)!
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
                            .offset(y: height * ((CGFloat(values.count) / 2) - CGFloat(currentOffset)) + offset)
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
                        let newValue = currentOffset - offsetCount
                        withAnimation {
                            if newValue >= 0 && newValue < values.count {
                                currentOffset -= offsetCount
                                currentValue = values[currentOffset]
                            }
                            offset = 0
                        }
                    }
                )
                .frame(height: geom.size.height)
                .offset(y: -height / 2)
            }
            .mask {
                Rectangle()
                    .frame(height: height*3)
            }
        }
        .onChange(of: currentValue) { _ in
            self.currentOffset = values.firstIndex(of: currentValue)!
        }
    }
}

struct ColorSnappingScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSnappingScrollViewWrapper()
    }

    struct ColorSnappingScrollViewWrapper: View {
        @State var curValue = 0

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
