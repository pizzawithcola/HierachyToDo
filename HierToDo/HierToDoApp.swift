//
//  HierToDoApp.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/3/21.
//

import SwiftUI

@main
struct HierToDoApp: App {
    
    @State private var modelData = ModelData()
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(timer) { _ in if modelData.save() {} }
                .environment(modelData)
        }
    }
}
