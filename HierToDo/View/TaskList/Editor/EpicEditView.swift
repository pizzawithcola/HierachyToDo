//
//  EpicEditView.swift
//  HierToDo
//
//  Created by Jamie on 4/5/24.
//

import SwiftUI

struct EpicEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(ModelData.self) var modelData
    
    @Binding var epic: HierEpic
    
    @State private var epicName: String
    @State private var epicDescription: String
    @State private var epicColor: Color
    
    init(epic: Binding<HierEpic>) {
        self._epic = epic
        self._epicName = State(initialValue: epic.wrappedValue.name)
        self._epicDescription =  State(initialValue: epic.wrappedValue.description)
        self._epicColor = State(initialValue: Color(
            red: epic.wrappedValue.colorRGB.red,
            green: epic.wrappedValue.colorRGB.green,
            blue: epic.wrappedValue.colorRGB.blue))
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Information")){
                    TextField("Name", text: $epicName)
                    TextField("Description", text: $epicDescription)
                }
                Section(header: Text("Theme")) {
                    ColorPicker("Color", selection: $epicColor)
                }  
            }
            .navigationTitle("Epic Editor")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        epic.name = epicName
                        epic.description = epicDescription
                        epic.colorRGB = ColorRGB(epicColor)
                        if modelData.save() {}
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            })
        }
    }
}

#Preview {
    EpicEditView(epic: .constant(HierEpic(1)))
        .environment(ModelData())
}
