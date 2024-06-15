//
//  FakeData.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/4/15.
//

import Foundation


func preparedFakeFreeTasks(_ idGen: IdGenerator) -> [HierTask] {
    let task1 = HierTask(idGen.nextId, name: "Free: Grocery Shopping", description: "Compile a list of weekly groceries and purchase them from the local market.")
    let task2 = HierTask(idGen.nextId, name: "Free: Morning Routine", description: "Complete morning routine including exercise, breakfast, and reading the news.")
    let task3 = HierTask(idGen.nextId, name: "Free: Evening Walk", description: "Take a 30-minute walk in the neighborhood park.")
    
    return [task1, task2, task3]
}

func preparedFakeEpics(_ idGen: IdGenerator) -> [HierEpic] {
    var fakeEpics = [HierEpic]()
    
    /// Group A
    let taskA1 = HierTask(idGen.nextId, name: "Debuging on the new feature")
    taskA1.importance = .Critical
    taskA1.startAt = Calendar.current.date(byAdding: .day, value: -4, to: .now)!
    taskA1.dueAt = Calendar.current.date(byAdding: .hour, value: -12, to: .now)!
    taskA1.status = .Finishied
    taskA1.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .day, value: -4, to: .now)!),
        TaskStatus(.Paused, createdAt: Calendar.current.date(byAdding: .day, value: -3, to: .now)!),
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
        TaskStatus(.Finishied, createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
    ]
    
    let taskA2 = HierTask(idGen.nextId, name: "Discussion with teammate")
    taskA2.importance = .Major
    taskA2.startAt = Calendar.current.date(byAdding: .day, value: -4, to: .now)!
    taskA2.dueAt = Calendar.current.date(byAdding: .hour, value: -10, to: .now)!
    taskA2.status = .Finishied
    taskA2.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .day, value: -4, to: .now)!),
        TaskStatus(.Finishied, createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
    ]
    
    let taskA3 = HierTask(idGen.nextId, name: "Explore the new feature")
    taskA3.importance = .Minor
    taskA3.startAt = Calendar.current.date(byAdding: .day, value: -4, to: .now)!
    taskA3.dueAt = Calendar.current.date(byAdding: .hour, value: -9, to: .now)!
    taskA3.status = .Finishied
    taskA3.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .day, value: -4, to: .now)!),
        TaskStatus(.Finishied, createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
    ]
    
    let taskA4 = HierTask(idGen.nextId, name: "Buy shrimps and soy for sushi")
    taskA4.importance = .Critical
    taskA4.startAt = Calendar.current.date(byAdding: .hour, value: -5, to: .now)!
    taskA4.dueAt = Calendar.current.date(byAdding: .minute, value: 1, to: .now)!
    taskA4.status = .Paused
    taskA4.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .hour, value: -5, to: .now)!),
    ]
    
    let taskA5 = HierTask(idGen.nextId, name: "Gym with abs and sholder")
    taskA5.importance = .Minor
    taskA5.startAt = Calendar.current.date(byAdding: .hour, value: -5, to: .now)!
    taskA5.dueAt = Calendar.current.date(byAdding: .minute, value: 10, to: .now)!
    taskA5.status = .Working
    taskA5.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .hour, value: -5, to: .now)!),
    ]
    
    let taskA6 = HierTask(idGen.nextId, name: "Cardio Day")
    taskA6.importance = .Major
    taskA6.startAt = Calendar.current.date(byAdding: .day, value: -10, to: .now)!
    taskA6.dueAt = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
    taskA6.status = .Finishied
    taskA6.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .day, value: -10, to: .now)!),
    ]
    
    let storyA1 = HierStory(idGen.nextId, name: "Homework 6", description: "Homework 6 todo list", tasks: taskA1)
    let storyA2 = HierStory(idGen.nextId, name: "Final Project", description: "Final Project todo list", tasks: taskA2, taskA3)
    let storyA3 = HierStory(idGen.nextId, name: "Daily Reminder", description: "Things to remind me", tasks: taskA4)
    let storyA4 = HierStory(idGen.nextId, name: "Fitness Plan", description: "Let's get strong!", tasks: taskA5, taskA6)
    
    let epicA1 = HierEpic(idGen.nextId, name: "ECE564", description: "The todo list for ECE 564", stories: storyA1, storyA2)
    epicA1.colorRGB = ColorRGB(red: 0.6, green: 0.1, blue: 0.1)
    let epicA2 = HierEpic(idGen.nextId, name: "Daily Life", description: "The todo list for my daily life", stories: storyA3, storyA4)
    epicA2.colorRGB = ColorRGB(red: 0.3, green: 0.2, blue: 0.4)
    
    fakeEpics.append(contentsOf: [epicA1, epicA2])

    /// Group B
    let taskB1 = HierTask(idGen.nextId, name: "Design UI", description: "Create a new user interface for the login page.")
    taskB1.importance = .Critical
    taskB1.startAt = Calendar.current.date(byAdding: .hour, value: -5, to: .now)!
    taskB1.dueAt = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    taskB1.status = .Finishied
    taskB1.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .hour, value: -5, to: .now)!),
        TaskStatus(.Finishied, createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: .now)!),
    ]
    
    let taskB2 = HierTask(idGen.nextId, name: "Develop API", description: "Develop the backend APIs for user authentication.")
    taskB2.importance = .Critical
    taskB2.startAt = Calendar.current.date(byAdding: .day, value: -5, to: .now)!
    taskB2.dueAt = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    taskB2.status = .Finishied
    taskB2.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .day, value: -6, to: .now)!),
        TaskStatus(.Finishied, createdAt: Calendar.current.date(byAdding: .day, value: -2, to: .now)!),
    ]
    
    let taskB3 = HierTask(idGen.nextId, name: "Write Tests", description: "Write unit tests to cover new authentication logic.")
    taskB3.importance = .Major
    taskB3.startAt = Calendar.current.date(byAdding: .day, value: -4, to: .now)!
    taskB3.dueAt = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
    taskB3.status = .Paused
    taskB3.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .day, value: -6, to: .now)!),
        TaskStatus(.Paused, createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
    ]
    
    let taskB4 = HierTask(idGen.nextId, name: "Optimize Database", description: "Improve the database schema for faster queries.")
    taskB4.importance = .Moderate
    taskB4.startAt = Calendar.current.date(byAdding: .day, value: -4, to: .now)!
    taskB4.dueAt = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
    
    let taskB5 = HierTask(idGen.nextId, name: "Refactor Code", description: "Refactor existing code to improve maintainability.")
    taskB5.importance = .Critical
    taskB5.startAt = Calendar.current.date(byAdding: .day, value: -4, to: .now)!
    taskB5.dueAt = Calendar.current.date(byAdding: .day, value: 3, to: .now)!
    
    let taskB6 = HierTask(idGen.nextId, name: "UI Integration", description: "Integrate the new UI with the backend services.")
    taskB6.startAt = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    taskB6.dueAt = Calendar.current.date(byAdding: .day, value: 4, to: .now)!
    taskB6.status = .Finishied
    taskB6.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
        TaskStatus(.Finishied, createdAt: Calendar.current.date(byAdding: .day, value: 0, to: .now)!),
    ]
    
    let storyB1 = HierStory(idGen.nextId,
        name: "User Authentication",
        description: "Implementing a complete user authentication flow.",
        tasks: taskB1, taskB2, taskB3
    )
    let storyB2 = HierStory(idGen.nextId,
        name: "Database Optimization",
        description: "Update and optimize the database to handle more concurrent users.",
        tasks: taskB4, taskB5
    )
    let storyB3 = HierStory(idGen.nextId,
        name: "Deployment and Testing",
        description: "Handling all aspects of deploying and testing the new features before public release.",
        tasks: taskB6
    )
    
    let epicB1 = HierEpic(idGen.nextId,
        name: "ECE661",
        description: "All tasks and stories required for the initial project launch.",
        stories: storyB1, storyB2
    )
    epicB1.colorRGB = ColorRGB(red: 0.9, green: 0.4, blue: 0.4)
    
    let epicB2 = HierEpic(idGen.nextId,
        name: "ECE590",
        description: "Ongoing tasks and stories to maintain and update the project post-launch.",
        stories: storyB3
    )
    epicB2.colorRGB = ColorRGB(red: 0.6, green: 0.9, blue: 0.1)
    
    fakeEpics.append(contentsOf: [epicB1, epicB2])
    
    /// Group C
    let taskC1 = HierTask(idGen.nextId, name: "Security Audit", description: "Conduct a security audit to ensure all endpoints are secure.")
    taskC1.importance = .Critical
    taskC1.startAt = Calendar.current.date(byAdding: .day, value: -10, to: .now)!
    taskC1.dueAt = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    taskC1.status = .Finishied
    taskC1.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .day, value: -10, to: .now)!),
        TaskStatus(.Paused, createdAt: Calendar.current.date(byAdding: .day, value: -9, to: .now)!),
        TaskStatus(.Finishied, createdAt: Calendar.current.date(byAdding: .day, value: -7, to: .now)!),
    ]
    
    let taskC2 = HierTask(idGen.nextId, name: "Documentation", description: "Update the project documentation with new API details and user guides.")
    taskC2.importance = .Critical
    taskC2.startAt = Calendar.current.date(byAdding: .day, value: -9, to: .now)!
    taskC2.dueAt = Calendar.current.date(byAdding: .day, value: -2, to: .now)!
    taskC2.status = .Finishied
    taskC2.statusHistory = [
        TaskStatus(.Working, createdAt: Calendar.current.date(byAdding: .day, value: -8, to: .now)!),
        TaskStatus(.Finishied, createdAt: Calendar.current.date(byAdding: .day, value: -6, to: .now)!),
    ]
    
    let taskC3 = HierTask(idGen.nextId,name: "Implement Dark Mode", description: "Add dark mode support to the application interface.")
    taskC3.startAt = Calendar.current.date(byAdding: .day, value: 2, to: .now)!
    taskC3.dueAt = Calendar.current.date(byAdding: .day, value: 3, to: .now)!
    
    let taskC4 = HierTask(idGen.nextId,name: "Accessibility Enhancements", description: "Improve accessibility features for better compliance with ADA standards.")
    taskC4.startAt = Calendar.current.date(byAdding: .day, value: 2, to: .now)!
    taskC4.dueAt = Calendar.current.date(byAdding: .day, value: 4, to: .now)!
    
    let taskC5 = HierTask(idGen.nextId,name: "Internationalization", description: "Prepare the app for multiple languages support.")
    taskC5.startAt = Calendar.current.date(byAdding: .day, value: 2, to: .now)!
    taskC5.dueAt = Calendar.current.date(byAdding: .day, value: 3, to: .now)!
    
    let taskC6 = HierTask(idGen.nextId,name: "Cloud Integration", description: "Integrate cloud storage solutions for data handling.")
    taskC6.startAt = Calendar.current.date(byAdding: .day, value: 2, to: .now)!
    taskC6.dueAt = Calendar.current.date(byAdding: .day, value: 4, to: .now)!
    
    let storyC1 = HierStory(idGen.nextId,
        name: "Security Enhancements",
        description: "Improve security measures for the entire application.",
        tasks: taskC1
    )
    let storyC2 = HierStory(idGen.nextId,
        name: "Documentation Update",
        description: "Update the documentation to reflect recent changes and add new user guides.",
        tasks: taskC2
    )
    let storyC3 = HierStory(idGen.nextId,
        name: "User Interface Improvements",
        description: "Update the user interface to include dark mode and enhance accessibility.",
        tasks: taskC3, taskC4
    )

    let storyC4 = HierStory(idGen.nextId,
        name: "Global Expansion",
        description: "Prepare the application for a global audience by adding multi-language support.",
        tasks: taskC5
    )

    let storyC5 = HierStory(idGen.nextId,
        name: "Cloud Services",
        description: "Expand the application's capabilities by integrating cloud-based services.",
        tasks: taskC6
    )
    
    let epicC1 = HierEpic(idGen.nextId,
        name: "CS516",
        description: "All tasks and stories required for the 2nd Stage of project.",
        stories: storyC1, storyC2, storyC3, storyC4, storyC5
    )
    epicC1.colorRGB = ColorRGB(red: 0.1, green: 0.1, blue: 0.8)
    
    fakeEpics.append(epicC1)
    
    return fakeEpics
}
