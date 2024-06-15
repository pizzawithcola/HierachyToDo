//
//  TestTaskView.swift
//  HierToDo
//
//  Created by Jamie on 4/11/24.
//

import SwiftUI

struct TestTaskView: View {
    var task: HierTask
    var body: some View {
        ZStack{
            Rectangle()
                .frame(height: 50)
                .foregroundColor(Color.gray)
            
            HStack{
                Text("\(task.name)")
                Spacer()
                Label("", systemImage: "backpack.fill")
            }
        }
        .frame(height: 45)
        
    }
}

#Preview {
    let task: HierTask = HierTask(1)
    task.name = "Task1"
    return TestTaskView(task: task)
}
