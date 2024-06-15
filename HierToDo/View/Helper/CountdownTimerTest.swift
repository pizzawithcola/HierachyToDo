//
//  CountdownWarningTest.swift
//  HierToDo
//
//  Created by Jamie on 4/15/24.
//

import SwiftUI

struct CountdownNoticeView: View {
    var dueAt: Date
    
    @State private var remainingSeconds = 0

    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()

    var body: some View {
        Text(timeString(from: remainingSeconds))
            .font(.system(size: 15))
            .bold()
            .foregroundStyle(Color(red: 0.8, green: 0.0, blue: 0.1))
            .onReceive(timer) { _ in
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                }
            }
            .onAppear {
                self.calculateRemainingTime()
            }
            .opacity(self.remainingSeconds > 3600 ? 0 : 1)
            
            
    }

    func calculateRemainingTime() {
        let calendar = Calendar.current
        let currentDate = Date()
        let remainingTime = calendar.dateComponents([.second], from: currentDate, to: dueAt)
        if let seconds = remainingTime.second {
            self.remainingSeconds = max(0, seconds)
        }
    }

    func timeString(from seconds: Int) -> String {
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview{
    CountdownNoticeView(dueAt: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)
}
