//
//  TaskListRow.swift
//  HierToDo
//
//  Created by Jamie on 3/21/24.
//

import SwiftUI

struct TaskListRow: View {
    @Environment(ModelData.self) var modelData
    
    @State var task: HierTask
    
    @State var checked: Bool = false
    
    @State private var isPresentingEditView = false
    @State private var isPresentingCountdownView = false
    
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    @Binding var fireworkViewTrigger: Bool
    
    var body: some View {
        ZStack{
            HStack{
                Checkbox(isChecked: $checked)
                    .onChange(of: checked) {
                        if checked {
                            task.status = .Finishied
                            fireworkViewTrigger.toggle()
                        }
                        else { 
                            task.status = .Working
                            fireworkViewTrigger.toggle()                        }
                    }
                
                if (task.dueAt.timeIntervalSinceNow < 3600) {
                    Text("\(task.name)")
                        .bold()
                        .font(.system(size: 16))
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .black]), startPoint: .topLeading, endPoint: .bottomTrailing))
                }else{
                    Text(task.name)
                        .font(.system(size: 16))
                }
                
                Spacer()
                
                CountdownNoticeView(dueAt: task.dueAt)
                
                Image("\(task.importance.description)")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .frame(height: 30)
            .swipeActions(edge: .leading) {
                // countdown button
                Button {
                    isPresentingCountdownView.toggle()
                } label: {
                    Label("Start", systemImage: "play")
                }
                .tint(.blue)
            }
            .swipeActions(edge: .trailing) {
                // delete function
                Button {
                    // Delete Function
                    if !modelData.deleteTask(task) {
                        showAlert = true
                        alertTitle = "Error"
                        alertMessage = "Failed to delete"
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
                
                // edit button
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
            .fullScreenCover(isPresented: $isPresentingCountdownView) {
                CountdownView(taskName: task.name)
            }
        }
        
    }
}

#Preview {
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.year = 2024
    dateComponents.month = 4
    dateComponents.day = 16
    dateComponents.hour = 2
    dateComponents.minute = 54
    dateComponents.second = 00
    let task: HierTask = HierTask(1)
    task.importance = .Insignificant
    task.dueAt = calendar.date(from: dateComponents)!
    return TaskListRow(task: task, fireworkViewTrigger: Binding.constant(true))
        .environment(ModelData())
}
