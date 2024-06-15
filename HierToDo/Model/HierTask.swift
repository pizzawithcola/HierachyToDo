//
//  HierTask.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/3/21.
//

import Foundation
import MapKit

@Observable
class HierTask : CustomStringConvertible, Identifiable {
    
    let id: Int
    var name: String
    var description: String
    
    var importance: Importance = .Moderate
    var cost: Float = 0.0
    var status: Status = .Working {
        didSet {
            statusHistory.append(TaskStatus(status))
        }
    }
    var statusHistory = [TaskStatus(.Idle)]
    var showDate: Bool = false
    var isAllDay: Bool = false
    var startAt: Date = .now
    var dueAt: Date = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
    var colorRGB = ColorRGB(red: 1, green: 1, blue: 1)
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var showInCalender: Bool = false
    var eventId: String = ""
    
    var showInReminder: Bool = false
    var reminderId: String = ""
    
    weak var story: HierStory?
    
    init(_ id: Int, name: String = "name", description: String = "description") {
        self.id = id
        self.name = name
        self.description = description
    }
    
    convenience init(_ other: HierTask) {
        self.init(other.id)
        copyFrom(other)
    }
    
    init(_ from: HierTaskDto) {
        self.id = from.id
        self.name = from.name
        self.description = from.description
        self.importance = from.importance
        self.cost = from.cost
        self.status = from.statusHistory.last!.status
        self.statusHistory = from.statusHistory
        self.showDate = from.showDate
        self.isAllDay = from.isAllDay
        self.startAt = from.startAt
        self.dueAt = from.dueAt
        self.colorRGB = from.colorRGB
        self.coordinate = CLLocationCoordinate2D(latitude: from.latitude, longitude: from.longitutde)
        self.showInCalender = from.showInCalender
        self.eventId = from.eventId
        self.showInReminder = from.showInReminder
        self.reminderId = from.reminderId
    }
    
    func copyFrom(_ other: HierTask) {
        self.name = other.name
        self.description = other.description
        self.importance = other.importance
        self.cost = other.cost
        self.status = other.status
        self.showDate = other.showDate
        self.isAllDay = other.isAllDay
        self.startAt = other.startAt
        self.dueAt = other.dueAt
        self.colorRGB = other.colorRGB
        self.coordinate = other.coordinate
        self.showInCalender = other.showInCalender
        self.eventId = other.eventId
        self.showInReminder = other.showInReminder
        self.reminderId = other.reminderId
    }
    
    func toCodable() -> HierTaskDto {
        HierTaskDto(id: self.id,
                    name: self.name,
                    description: self.description,
                    importance: self.importance,
                    cost: self.cost,
                    statusHistory: self.statusHistory,
                    showDate: self.showDate,
                    isAllDay: self.isAllDay,
                    startAt: self.startAt,
                    dueAt: self.dueAt,
                    colorRGB: self.colorRGB,
                    latitude: self.coordinate.latitude,
                    longitutde: self.coordinate.longitude,
                    showInCalender: self.showInCalender,
                    eventId: self.eventId,
                    showInReminder: self.showInReminder,
                    reminderId: self.reminderId
        )
    }
    
    
    /// Calculate the time distribution in Seconds by task status
    func statusDist() -> [Status:TimeInterval] {
        var aggregation = [Status:TimeInterval]()
        for i in 0..<statusHistory.count {
            let sts = statusHistory[i]
            let nextDate = (i == statusHistory.count - 1) ? Date.now : statusHistory[i + 1].createdAt
            aggregation[sts.status] = (aggregation[sts.status] ?? 0.0) + nextDate.timeIntervalSince(sts.createdAt)
        }
        return aggregation
    }
}

struct HierTaskDto: Codable {
    let id: Int
    let name: String
    let description: String
    let importance: Importance
    let cost: Float
    let statusHistory: [TaskStatus]
    var showDate: Bool
    let isAllDay: Bool
    let startAt: Date
    let dueAt: Date
    let colorRGB: ColorRGB
    let latitude: Double
    let longitutde: Double
    let showInCalender: Bool
    let eventId: String
    let showInReminder: Bool
    let reminderId: String
}
