//
//  TaskListView.swift
//  HierToDo
//
//  Created by Jamie on 2024/3/11.
//

import SwiftUI

struct TaskListView: View {
    @Environment(ModelData.self) var modelData
    
    @State var addNewRandomTask = false
    
    @State var fireworkViewTrigger = false
    
    var body: some View {
        ZStack{
            NavigationStack{
                List{
                    Section{
                        TaskListGroup(addNewRandomTask: $addNewRandomTask, fireworkViewTrigger: $fireworkViewTrigger)
                    }
                }
                .listRowInsets(EdgeInsets())
                .navigationTitle("Today's tasks")
                .toolbar {
                    Button(action: {
                        addNewRandomTask.toggle()
                    }, label: {
                        Label("Add", systemImage: "plus")
                    })
                }
            }
            if fireworkViewTrigger {
                FireworksEffect()
            }
        }
        
        
        
    }
}

#Preview {
    TaskListView()
        .environment(ModelData())
}
