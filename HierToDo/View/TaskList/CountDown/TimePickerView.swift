//
//  TimePickerView.swift
//  HierToDo
//
//  Created by Jamie on 4/4/24.
//  Reference: https://github.com/leonardobilia/Countdown/tree/main

import SwiftUI

struct TimePickerView: View {
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    var body: some View {
        VStack {
            HStack {
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                
                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                
                Picker("Seconds", selection: $seconds) {
                    ForEach(0..<60) { second in
                        Text("\(second)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
            }
            .padding()
        }
    }
}
