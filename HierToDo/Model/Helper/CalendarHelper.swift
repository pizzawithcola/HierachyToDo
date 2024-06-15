//
//  CalendarManager.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/3/31.
//

import Foundation
import os
import EventKit
import MapKit


class CalendarHelper {
    static let logger = Logger()
    
    static let eventStore = EKEventStore()
    
    static func requestEvents(_ completion: @escaping (EKEventStore) -> Void) {
        eventStore.requestFullAccessToEvents { granted, error in
            if let err = error {
                Self.logger.error("Failed to request access to events: \(err)")
            } else if !granted {
                Self.logger.warning("Denied to access to events")
            } else {
                completion(self.eventStore)
            }
        }
    }
    
    static func createTaskEvent(_ task: HierTask) {
        requestEvents { eventStore in
            let event = EKEvent(eventStore: eventStore)
            event.title = task.name
            event.notes = task.description
            event.isAllDay = task.isAllDay
            event.startDate = task.startAt
            event.endDate = task.dueAt
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
                task.eventId = event.eventIdentifier
            } catch {
                Self.logger.error("\(error)")
            }
        }
    }
    
    static func deleteTaskEvent(_ task: HierTask) {
        if task.eventId != "" {
            requestEvents { eventStore in
                if let evt = eventStore.event(withIdentifier: task.eventId) {
                    do {
                        try eventStore.remove(evt, span: .thisEvent)
                        task.eventId = ""
                    } catch {
                        Self.logger.error("\(error)")
                    }
                }
            }
        }
    }
    
    static func requestReminders(_ completion: @escaping (EKEventStore) -> Void) {
        eventStore.requestFullAccessToReminders { granted, error in
            if let err = error {
                Self.logger.error("Failed to request access to reminders: \(err)")
            } else if !granted {
                Self.logger.warning("Denied to access to reminders")
            } else {
                completion(self.eventStore)
            }
        }
    }
    
    static func createTaskReminder(_ task: HierTask) {
        requestReminders { eventStore in
            let reminder = EKReminder(eventStore: eventStore)
            reminder.title = task.name
            reminder.notes = task.description
            let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
            reminder.dueDateComponents = Calendar.current.dateComponents(components, from: task.dueAt)
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            do {
                try eventStore.save(reminder, commit: true)
                task.reminderId = reminder.calendarItemIdentifier
            } catch {
                Self.logger.error("\(error)")
            }
        }
    }
    
    static func deleteTaskReminder(_ task: HierTask) {
        if task.reminderId != "" {
            requestReminders { eventStore in
                if let reminder = eventStore.calendarItem(withIdentifier: task.reminderId) as? EKReminder {
                    do {
                        try eventStore.remove(reminder, commit: true)
                        task.eventId = ""
                    } catch {
                        Self.logger.error("\(error)")
                    }
                }
            }
        }
    }
}
