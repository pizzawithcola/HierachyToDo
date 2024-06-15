//
//  BacklogEpicRow.swift
//  HierToDo
//
//  Created by Jamie on 4/9/24.
//

import SwiftUI

struct BacklogStoryRow: View {
    @Environment(ModelData.self) var modelData

    @State var story: HierStory
    
    @State private var isExpanded: Bool = false
    @State private var isPresentingEditView = false
    
    var body: some View {
        Group {
            DisclosureGroup(isExpanded: $isExpanded) {
                ForEach(story.tasks) { task in
                    BacklogTaskView(task: task)
                }
            } label: {
                HStack{
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color(red: story.colorRGB.red, green: story.colorRGB.green, blue: story.colorRGB.blue))
                        .shadow(radius: 2)
                    TextField("", text: $story.name)
                    Spacer()
                }
                .swipeActions(edge: .trailing) {
                    Button {
                        if modelData.deleteStory(story: story) {}
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                    Button {
                        isPresentingEditView.toggle()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)

                }
                .swipeActions(edge: .leading) {
                    Button {
                        story.addTask(HierTask(modelData.nextId))
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    .tint(.orange)
                }
                .sheet(isPresented: $isPresentingEditView) {
                    StoryEditView(story: $story)
                }
            }
        }

    }
}

#Preview {
    let story = HierStory(1)
    story.name = "Daily Life"
    story.description = "The todo list for my daily life"
    return BacklogStoryRow(story: story)
        .environment(ModelData())
}
