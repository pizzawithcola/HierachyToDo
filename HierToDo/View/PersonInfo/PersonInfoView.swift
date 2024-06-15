//
//  PersonInfoView.swift
//  HierToDo
//
//  Created by Jamie on 2024/3/11.
//

import SwiftUI

struct PersonInfoView: View {
//    @State var icloudToggle: Bool = false
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        @Bindable var modelData_ = modelData
        NavigationView {
            VStack {
                List{
                    Section{
                        if modelData.isLoggedIn {
                            UserInfoView(userInfo: $modelData_.loggedInUser)
                        } else {
                            SignInButton()
                        }
                        Toggle(isOn: $modelData_.isLoggedIn) { Text("Login") }
                    }
                    
                    Section{
                        let epicNames = modelData.epics.map { $0.name }
                        let epicWorkTimes = modelData.epics.map { ($0.statusDist()[.Working] ?? 0.0) / 3600 }
                        let epicColors = modelData.epics.map { e in
                            Color(red: e.colorRGB.red,
                                  green: e.colorRGB.green,
                                  blue: e.colorRGB.blue)
                        }
                        PieChartView(values: epicWorkTimes, 
                                     names: epicNames,
                                     formatter: {value in String(format: "%.1f hrs", value)},
                                     colors: epicColors)
                            .frame(height: 520)
                    }
                    
                    NavigationLink(destination: SettingView(icloudToggle: $modelData_.useICloud, priorityMode: $modelData_.priorityMode)) {
                        HStack{
                            Text("Setting")
                        }
                        
                    }
                }
                
            }
        }

    }
}

#Preview {
    PersonInfoView()
        .environment(ModelData())
}
