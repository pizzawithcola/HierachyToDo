//
//  CountDownView.swift
//  HierToDo
//
//  Created by Jamie on 3/31/24.
//  Reference: https://github.com/leonardobilia/Countdown/tree/main

import SwiftUI

struct CountdownView: View {
    var taskName: String
    
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    
    // See if the timer is running
    @State private var isTimerRunning = false
    
    // See if it is in editing mode
    @State private var isEditingTime = false
    
    @State private var finishAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var totalTime: TimeInterval {
        return TimeInterval(hours * 3600 + minutes * 60 + seconds)
    }
    
    var formattedTime: String {
        let formattedHours = String(format: "%02d", Int(timeRemaining) / 3600)
        let formattedMinutes = String(format: "%02d", (Int(timeRemaining) % 3600) / 60)
        let formattedSeconds = String(format: "%02d", Int(timeRemaining) % 60)
        return "\(formattedHours):\(formattedMinutes):\(formattedSeconds)"
    }
    
    var body: some View {
        VStack {
            Button(){
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label("Back", systemImage: "arrowshape.turn.up.backward")
            }
            .offset(x: 0, y: 20)
            
            Spacer()
            
            ZStack {
                Text(taskName)
                    .font(.system(size: 26))
                    .bold()
                    .offset(y: -270)
                
                if isEditingTime {
                    TimePickerView(hours: $hours, minutes: $minutes, seconds: $seconds)
                        .frame(width: 300, height: 180)
                        .cornerRadius(10)
                        .shadow(radius: 0)
                        .offset(y: 135)
                }
                
                Group{
                    // The progress circle
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining/totalTime))
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.linear, value: 0.1)
                    
                    // The countdown time
                    Text(formattedTime)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // The edit button
                    Button(action: {
                        isEditingTime.toggle() // 切换时间选择器的显示状态
                    }) {
                        Image(systemName: "timer")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .offset(y: 70)
                    .padding()
                }
                .frame(width: 250, height: 250)
                .offset(y: -100)
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    if isTimerRunning {
                        pauseTimer()
                    } else {
                        startTimer()
                    }
                    isEditingTime = false
                }) {
                    CircleButton(style: isTimerRunning ? .pause : .start)
                }
                .padding()
                .offset(x: -30)
                
                Button(action: {
                    resetTimer()
                }) {
                    CircleButton(style: .reset)
                }
                .padding()
                .offset(x: 30)
            }
            .offset(y: -50)
        }
        .alert(isPresented: $finishAlert) {
            Alert(title: Text("⏰Time's up!"), message: Text("\nYou've been focused for\n \(hours) hrs \(minutes) mins \(seconds) secs!"), dismissButton: .default(Text("Love it")))
        }
    }
    
    func startTimer() {
        isTimerRunning = true
        timeRemaining = totalTime
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isTimerRunning = false
                finishAlert.toggle()
            }
        }
    }
    
    func pauseTimer() {
        isTimerRunning = false
        timer?.invalidate()
    }
    
    func resetTimer() {
        pauseTimer()
        timeRemaining = totalTime
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        let taskName = Binding.constant("YourTaskName")
        CountdownView(taskName: "Test Name")
    }
}



