//
//  BacklogEpicRow.swift
//  HierToDo
//
//  Created by Jamie on 4/9/24.
//

import SwiftUI

struct BacklogEpicRow: View {
    @Environment(ModelData.self) var modelData
    
    @State var epic: HierEpic
    
    @State private var isExpanded: Bool = false
    @State private var isPresentingEditView = false
    
    var body: some View {
        Group {
            DisclosureGroup(isExpanded: $isExpanded) {
                ForEach(epic.stories) { s in
                    BacklogStoryRow(story: s)
                }
            } label: {
                HStack{
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color(red: epic.colorRGB.red, green: epic.colorRGB.green, blue: epic.colorRGB.blue))
                        .shadow(radius: 2)
                    TextField("", text: $epic.name)
                    Spacer()
                }
                .swipeActions(edge: .trailing) {
                    // delete function
                    Button {
                        // Delete Function
                        if modelData.deleteEpic(epic: epic, deleteTasks: true) {}
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
                        epic.addStory(HierStory(modelData.nextId))
                    } label: {
                        Label("Add", systemImage: "folder.badge.plus")
                    }
                    .tint(.orange)
                }
                .sheet(isPresented: $isPresentingEditView) {
                    EpicEditView(epic: $epic)
                }
            }
        }

    }
}

#Preview {
    let epic = HierEpic(1)
    epic.name = "Daily Life"
    epic.description = "The todo list for my daily life"
    return BacklogEpicRow(epic: epic)
        .environment(ModelData())
}
