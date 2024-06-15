//
//  Firework.swift
//  HierToDo
//
//  Created by Jamie on 4/6/24.
//

import SwiftUI

struct Firework: View {
    @Binding var isActive: Bool
    
    let coordinatorPoints: [[CGFloat]] = [[-100, 0], [-70.5, 70.5], [0, 100], [70.5, 70.5], [100, 0], [70.5, -70.5], [0, -100], [-70.5, -70.5]]

    
    let midX = UIScreen.main.bounds.size.width / 2
    let midY = UIScreen.main.bounds.size.height / 2
    
    var body: some View {
        ZStack {
            ForEach(0..<8){ particleIndex in
                Circle()
                    .fill(isActive ? Color.purple : Color.yellow)
                    .frame(width: 15, height: 15)
                    .position(isActive ? CGPoint(x: midX + coordinatorPoints[particleIndex][0], y: midY + coordinatorPoints[particleIndex][1]) : CGPoint(x: midX, y:midY))
                    .opacity(isActive ? 0 : 1)
                
                Circle()
                    .fill(isActive ? Color.blue : Color.yellow)
                    .frame(width: 10, height: 10)
                    .position(isActive ? CGPoint(x: (midX + coordinatorPoints[particleIndex][0]) * 0.8, y: (midY + coordinatorPoints[particleIndex][1]) * 0.8) : CGPoint(x: midX * 0.8, y:midY * 0.8))
                    .opacity(isActive ? 0 : 1)
            }
        }
    }
}



#Preview {
    Firework(isActive: Binding.constant(false))
}
