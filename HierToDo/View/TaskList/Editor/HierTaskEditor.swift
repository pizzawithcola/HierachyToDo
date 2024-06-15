//
//  HierTaskEditor.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/4/15.
//

import SwiftUI

struct HierTaskEditor: View {
    @Binding var task: HierTask
    
    @State private var costInput: String = ""
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2  // Set maximum decimal places
        return formatter
    }()
    
    var body: some View {
        Form {
            Section(header: Text("Information")){
                TextField("Name", text: $task.name)
                TextField("Description", text: $task.description)
            }
            
            Section(header: Text("Date and Time")){
                Toggle(isOn: $task.showDate) { Text("Show Date") }
                if task.showDate {
                    Toggle(isOn: $task.isAllDay) { Text("All Day") }
                    if task.isAllDay {
                        DatePicker("Start Date", selection: $task.startAt, displayedComponents: .date)
                        DatePicker("Due Date", selection: $task.dueAt, in: task.startAt..., displayedComponents: .date)
                    } else {
                        DatePicker("Start Date", selection: $task.startAt)
                        DatePicker("Due Date", selection: $task.dueAt, in: task.startAt...)
                    }
                    Toggle(isOn: $task.showInCalender) { Text("Show in Calendar") }
                    Toggle(isOn: $task.showInReminder) { Text("Show in Reminder") }
                }
            }
            
            Section(header: Text("Priority")){
                Picker("Importance", selection: $task.importance) {
                    ForEach(Importance.allCases, id: \.self) { imp in
                        Text("\(imp.description)")
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                HStack{
                    Text("Cost")
                    Spacer()
                    TextField("Cost", text: $costInput)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onAppear {
                            costInput = formatter.string(for: task.cost) ?? ""
                        }
                        .onChange(of: costInput) {
                            if let value = formatter.number(from: costInput)?.floatValue {
                                task.cost = value
                            } else {
                                showAlert = true
                                alertTitle = "Invalid input"
                                alertMessage = "Please input number"
                            }
                        }
                }
            }
            
            Section("Status") {
                Picker("Status", selection: $task.status) {
                    ForEach(Status.allCases, id: \.self) { st in
                        Text("\(st.rawValue)")
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: { Text(alertMessage) }
    }
}

#Preview {
    HierTaskEditor(task: .constant(HierTask(0)))
}
