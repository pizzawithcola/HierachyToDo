//
//  TestColorPicker.swift
//  HierToDo
//
//  Created by Jamie on 4/13/24.
//

import SwiftUI

struct TestColorPicker: View {
    @State private var bgColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    var body: some View {
        ColorPicker("Alignment Guides", selection: $bgColor)
        Rectangle()
            .frame(width: 100, height: 200)
            .foregroundStyle(bgColor)
    }
}

#Preview {
    TestColorPicker()
}
