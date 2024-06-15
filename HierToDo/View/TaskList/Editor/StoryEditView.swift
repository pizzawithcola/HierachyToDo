//
//  StoryEditView.swift
//  HierToDo
//
//  Created by Jamie on 4/5/24.
//

import SwiftUI

struct StoryEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(ModelData.self) var modelData
    
    @Binding var story: HierStory
    
    @State private var storyName: String
    @State private var storyDescription: String
    @State private var storyColor: Color
    
    init(story: Binding<HierStory>) {
        self._story = story
        self._storyName = State(initialValue: story.wrappedValue.name)
        self._storyDescription = State(initialValue: story.wrappedValue.description)
        self._storyColor = State(initialValue: Color(
            red: story.wrappedValue.colorRGB.red,
            green: story.wrappedValue.colorRGB.green,
            blue: story.wrappedValue.colorRGB.blue))
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Information")){
                    TextField("Name", text: $storyName)
                    TextField("Description", text: $storyDescription)
                }
                Section(header: Text("Theme")) {
                    ColorPicker("Color", selection: $storyColor)
                }
            }
            .navigationTitle("Story Editor")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        story.name = storyName
                        story.description = storyDescription
                        story.colorRGB = ColorRGB(storyColor)
                        if modelData.save() {}
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            })
        }
    }
}

#Preview {
    StoryEditView(story: .constant(HierStory(1)))
        .environment(ModelData())
}
