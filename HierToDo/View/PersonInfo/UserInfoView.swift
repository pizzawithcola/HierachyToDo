//
//  UserInfoView.swift
//  HierToDo
//
//  Created by Jamie on 4/9/24.
//

import SwiftUI

struct UserInfoView: View {
    @Environment(ModelData.self) var modelData
    
    @Binding var userInfo: HierUserInfo
    
    let infoTagX = 125.0
    let infoTagY = 100.0
    let infoContentY = 125.0
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white)
                .frame(height: 300)
                .offset(y: 0)
                
            ZStack{
                Circle()
                    .fill(Color.white)
                    .shadow(color: Color.gray, radius: 10)
                    .frame(width: 150, height: 150)
                
                PhotoPicker(uiImage: $userInfo.photo)
            }
            .offset(y: -55)
            
            Text("\(userInfo.firstName) \(userInfo.lastName)")
                .bold()
                .offset(y: 50)
                .font(.system(size: 25))
            
            Text("Focused")
                .bold()
                .offset(x: -infoTagX, y: infoTagY)
            
            Text("Finished")
                .bold()
                .offset(y: infoTagY)
            
            Text("Stars")
                .bold()
                .offset(x: infoTagX, y: infoTagY)
            
            let totalFocusHours = (
                modelData.allTasks.reduce(0.0) { res, tsk in res + (tsk.statusDist()[.Working] ?? 0.0)}
            ) / 3600
            Text("\(String(format: "%.1f", totalFocusHours)) hrs")
                .offset(x: -infoTagX, y: infoContentY)
            
            let totalFinishedTasks = modelData.queryTasks { $0.status == .Finishied } .count

            Text("\(totalFinishedTasks) tasks")
                .offset(x: 0, y: infoContentY)
            
            Text("10 🌟")
                .offset(x: infoTagX, y: infoContentY)
        }
        .frame(height: 275)
    }
}

#Preview {
    UserInfoView(userInfo: .constant(HierUserInfo()))
        .environment(ModelData())
}
