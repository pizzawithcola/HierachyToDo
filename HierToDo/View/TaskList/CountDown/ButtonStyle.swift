//
//  ButtonStyle.swift
//  HierToDo
//
//  Created by Jamie on 4/4/24.
//  Reference: https://github.com/leonardobilia/Countdown/tree/main


import SwiftUI

struct CircleButton: View {
    
    enum ButtonStyle {
        case start
        case pause
        case reset
        
        var title: String {
            switch self {
            case .start:
                return "Start"
            case .pause:
                return "Pause"
            case .reset:
                return "Reset"
            }
        }
        
        var fillColor: Color {
            switch self {
            case .start:
                return Color(.systemGreen)
            case .pause:
                return Color(.systemOrange)
            case .reset:
                return Color(.secondarySystemBackground)
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .start:
                return Color(.white)
            case .pause:
                return Color(.white)
            case .reset:
                return Color(.label)
            }
        }
    }
    
    var style: ButtonStyle
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style.fillColor, lineWidth: 1)
                .frame(width: 88, height: 88)
            
            Circle()
                .fill(style.fillColor)
                .frame(width: 80, height: 80)
                .overlay(
                    Text(style.title)
                        .font(.headline)
                        .foregroundColor(style.foregroundColor)
                )
        }
    }
}

struct CapsuleButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            CircleButton(style: .start)
            CircleButton(style: .pause)
            CircleButton(style: .reset)
        }
        
    }
}
