//
//  FireworksEffect.swift
//  HierToDo
//
//  Created by Jamie on 4/6/24.
//

import SwiftUI

struct FireworksEffect: View {
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack{
            Firework(isActive: $isActive)
                .onAppear(perform: {
                    withAnimation(Animation.spring().delay(0)) {
                       isActive = true
                   }
                })
            
            Firework(isActive: $isActive)
                .offset(x: 150, y: 100)
                .animation(.bouncy.delay(0.2), value: isActive)
            
            Firework(isActive: $isActive)
                .offset(x: -80, y: 60)
                .animation(.bouncy.delay(0.3), value: isActive)
            
        }
    }
}

#Preview {
    FireworksEffect()
}
