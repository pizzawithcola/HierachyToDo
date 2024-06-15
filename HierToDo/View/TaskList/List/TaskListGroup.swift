//
//  TaskListGroup.swift
//  HierToDo
//
//  Created by Jamie on 3/21/24.
//

import SwiftUI

struct TaskListGroup: View {
    @Environment(ModelData.self) var modelData
    
    @Binding var addNewRandomTask: Bool
    
    @State var newTaskName:String = ""
    
    @State var emptyAlert:Bool = false
    
    @Binding var fireworkViewTrigger: Bool
    
    var body: some View {
        var todayTasks = modelData.allTasks.filter { tsk in
            let today = Calendar.current.startOfDay(for: Date())
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            return tsk.startAt < tomorrow && tsk.startAt > yesterday
        }
        todayTasks.sortByPriority(modelData.priorityMode)
        return Group {
            ForEach(todayTasks, id: \.id) { task in
                TaskListRow(task: task, fireworkViewTrigger: $fireworkViewTrigger)
            }
            if addNewRandomTask{
                HStack{
                    TextField("Add new task", text: $newTaskName)
                        .autocapitalization(.none)
                    Spacer()
                    Button(action: {
                        if newTaskName.isEmpty {
                            emptyAlert.toggle()
                        }else{
                            modelData.addFreeTask(HierTask(modelData.nextId, name: newTaskName))
                            newTaskName = ""
                            addNewRandomTask.toggle()
                        }
                    }, label: {
                        Text("Add")
                    })
                    .alert("Alert", isPresented: $emptyAlert) {
                        Button("Got it", role: .cancel){}
                    } message: {
                        Text("The task name cannot be empty!")
                    }
                }
            }
        }
    }
}

#Preview {
    let addNew = Binding.constant(false)
    return TaskListGroup(addNewRandomTask: addNew, fireworkViewTrigger: Binding.constant(true))
        .environment(ModelData())
}
