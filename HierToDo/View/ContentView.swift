//
//  ContentView.swift
//  HierToDo
//
//  Created by Jamie on 2024/3/11.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .list
    
    enum Tab {
        case list
        case backlog
        case info
    }
    
    var body: some View {
        ZStack{
            TabView(selection: $selection) {
                BacklogView()
                    .tabItem {
                        Label("Backlog", systemImage: "rectangle.stack")
                    }.tag(Tab.backlog)
                TaskListView()
                    .tabItem {
                        Label("Tasks", systemImage: "checklist")
                    }.tag(Tab.list)
                PersonInfoView()
                    .tabItem {
                        Label("Me", systemImage: "person")
                    }.tag(Tab.info)
            }
        }
    }
}

#Preview {
    ContentView()
}
