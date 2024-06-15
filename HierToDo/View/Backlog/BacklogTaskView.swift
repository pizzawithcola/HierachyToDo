//
//  BacklogTaskView.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/4/16.
//

import SwiftUI

struct BacklogTaskView: View {
    @Environment(ModelData.self) var modelData
    
    @State var task: HierTask
    
    @State var checked: Bool = false
    @State private var isPresentingEditView = false
    
    var body: some View {
        HStack {
            TextField("", text: $task.name)
//            Text("\(task.name)")
            Spacer()
        }
        .swipeActions(edge: .trailing) {
            Button {
                if modelData.deleteTask(task) {}
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
        .sheet(isPresented: $isPresentingEditView) {
            TaskEditView(task: $task)
        }
    }
}

#Preview {
    BacklogTaskView(task: HierTask(0))
        .environment(ModelData())
}
