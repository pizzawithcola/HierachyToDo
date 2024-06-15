//
//  SettingView.swift
//  HierToDo
//
//  Created by Jamie on 4/11/24.
//

import SwiftUI

struct SettingView: View {
    @Environment(ModelData.self) var modelData
    
    @Binding var icloudToggle: Bool
    @Binding var priorityMode: PriorityMode
    
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    var body: some View {
        List{
            Section(header: Text("ToDo List Setting")) {
                Picker("Priority Mode", selection: $priorityMode) {
                    ForEach(PriorityMode.allCases, id: \.self) { pm in
                        Text("\(pm.rawValue)")
                    }
                }
            }
            
            Section(header: Text("iCloud Setting")) {
                HStack{
                    Toggle(isOn: $icloudToggle, label: {
                        Text("iCloud Auto Sync")
                    })
                }
                
                if(!icloudToggle){
                    Button(action: {
                        if modelData.saveToICloud() {
                            showAlert = true
                            alertTitle = "Success"
                            alertMessage = "Sync to iCloud."
                        } else {
                            showAlert = true
                            alertTitle = "Error"
                            alertMessage = "Failed to sync to iCloud."
                        }
                    }, label: {
                        Text("Sync to iCloud")
                    }).alert(alertTitle, isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    } message: { Text(alertMessage) }
                    
                    Button(action: {
                        if modelData.loadFromICloud() {
                            showAlert = true
                            alertTitle = "Success"
                            alertMessage = "Loaded from iCloud."
                        } else {
                            showAlert = true
                            alertTitle = "Error"
                            alertMessage = "Failed to load from iCloud."
                        }
                    }, label: {
                        Text("Load from iCloud")
                    }).alert(alertTitle, isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    } message: { Text(alertMessage) }
                }
                
            }
        }
        .navigationTitle("Setting")
        
    }
}

#Preview {
    SettingView(icloudToggle: .constant(true), 
                priorityMode: Binding.constant(.Default))
        .environment(ModelData())
}
