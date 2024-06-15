//
//  DataPreview.swift
//  HierToDo
//
//  Created by Jamie on 4/9/24.
//

import SwiftUI

struct DataPreview: View {
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DataPreview()
        .environment(ModelData())
}
