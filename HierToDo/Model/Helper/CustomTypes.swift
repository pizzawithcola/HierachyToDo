//
//  Enums.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/3/21.
//

import Foundation
import UIKit
import SwiftUI

enum PriorityMode: String, Codable, CaseIterable{
    case Default
    case Importance
    case Time
    case Priority
}

enum Importance: Int, Codable, CaseIterable, CustomStringConvertible {
    case Critical = 0
    case Major = 1
    case Moderate = 2
    case Minor = 3
    case Insignificant = 4
    
    var description: String {
        switch self {
        case .Critical: "Critical"
        case .Major: "Major"
        case .Moderate: "Moderate"
        case .Minor: "Minor"
        case .Insignificant: "Insignificant"
        }
    }
}

enum Status: String, Codable, CaseIterable {
    case Idle
    case Working
    case Paused
    case Finishied
    case Deleted
}

enum TaskType: String, Codable, CaseIterable{
    case Epic
    case Story
    case Task
}

struct TaskStatus: Codable {
    let status: Status
    let createdAt: Date
    
    init(_ status: Status, createdAt: Date = .now) {
        self.status = status
        self.createdAt = createdAt
    }
}

struct ColorRGB: Codable {
    var red: Double
    var green: Double
    var blue: Double
    
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    init(_ color: Color) {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            self.init(red: Double(red), green: Double(green), blue: Double(blue))
        } else {
            self.init(red: 1, green: 1, blue: 1)
        }
    }
}

class HierUserInfo {
    var firstName: String
    var lastName: String
    var email: String
    var photo: UIImage
    
    init(email: String = "example@duke.edu", fName: String = "Jared", lName: String = "McCain", photo: UIImage = UIImage(named: "Jared")!) {
        self.firstName = fName
        self.lastName = lName
        self.email = email
        self.photo = photo
    }
}

class IdGenerator {
    var currId: Int = 0
    var nextId: Int {
        currId += 1
        return currId
    }
}
