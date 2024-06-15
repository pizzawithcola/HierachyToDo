//
//  checkbox.swift
//  HierToDo
//
//  Created by Jamie on 3/21/24.
//

import SwiftUI

struct Checkbox: View {
    @Binding var isChecked: Bool
    var body: some View {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 20, height: 20, alignment: .center)
            .foregroundColor(isChecked ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture {
                isChecked.toggle()
            }
    }
}


#Preview {
    Checkbox(isChecked: .constant(true))
}
