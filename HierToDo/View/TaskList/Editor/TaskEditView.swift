//
//  TaskEditView.swift
//  HierToDo
//
//  Created by Jamie on 3/21/24.
//

import SwiftUI

struct TaskEditView: View {
    @Environment(ModelData.self) var modelData
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var task: HierTask
    @State var tempTask: HierTask
    
    init(task: Binding<HierTask>) {
        self._task = task
        self._tempTask = State(initialValue: HierTask(task.wrappedValue))
    }
    
    var body: some View {
        NavigationStack{
            HierTaskEditor(task: $tempTask)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if tempTask.showInCalender {
                            CalendarHelper.createTaskEvent(tempTask)
                        } else {
                            CalendarHelper.deleteTaskEvent(tempTask)
                        }
                        if tempTask.showInReminder {
                            CalendarHelper.createTaskReminder(tempTask)
                        } else {
                            CalendarHelper.deleteTaskReminder(tempTask)
                        }
                        task.copyFrom(tempTask)
                        if modelData.save() {}
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let task = HierTask(3)
    task.name = "Test Task"
    task.description = "This is a test task"
    
    return TaskEditView(task: .constant(task))
        .environment(ModelData())
}
