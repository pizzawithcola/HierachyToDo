//
//  BacklogView.swift
//  HierToDo
//
//  Created by Jamie on 2024/3/11.
//

import SwiftUI

struct BacklogView: View {
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        let epics = modelData.epics
        NavigationSplitView{
            List{
                ForEach(epics){ep in
                    Section{
                        BacklogEpicRow(epic: ep)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Backlog", displayMode: .automatic)
            .listRowBackground(Color.red)
            .toolbar {
                Button(action: {
                    modelData.addEpic(HierEpic(modelData.nextId))
                }, label: {
                    Label("Add", systemImage: "plus")
                })
            }

        } detail:{
            Text("Backlog")
        }
    }
}

#Preview {
    BacklogView()
        .environment(ModelData())
}
