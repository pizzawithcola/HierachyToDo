//
//  ModelData.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/3/21.
//

import Foundation
import os
import UIKit

struct ModelDataStorage: Codable {
    let epics: [HierEpicDto]
    let freeTasks: [HierTaskDto]
    let deletedTasks: [HierTaskDto]
    let lastId: Int
    
    var priorityMode: PriorityMode
    var useICloud: Bool
    var photoBytesMap: [String:String]
    var isLoggedIn: Bool
    var email: String
    var firstName: String
    var lastName: String
}

@Observable class ModelData {
    
    static let logger = Logger()
    
    let idGenerator = IdGenerator()
    var nextId: Int { idGenerator.nextId }
    
    var epics = [HierEpic]()
    var freeTasks = [HierTask]()
    var deletedTasks = [HierTask]()
    
    var priorityMode: PriorityMode = .Default // sort mode for HierTask
    
    var photoBytesMap = [String:String]()
    var loggedInUser: HierUserInfo
    var isLoggedIn: Bool
    
    var useICloud: Bool
    var localURL: URL
    var iCloudURL: URL? // Optional due to the user might not subscribe iCloud
    
    /// computed properties
    var allTasks: [HierTask] {
        epics.flatMap { $0.stories.flatMap { $0.tasks } } + freeTasks
    }
    
    
    init(_ filename: String = "db", useICloud: Bool = false) {
        self.localURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("\(filename).json")
        self.iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?
            .appendingPathComponent("Documents").appendingPathComponent("\(filename).json")
        self.useICloud = useICloud
        self.loggedInUser = HierUserInfo()
        self.isLoggedIn = false
        
        if !self.load() {
            Self.logger.warning("database not found.")
            // Create fake data for test.
            Self.logger.warning("Creating demonstration data.")
            
            self.freeTasks = preparedFakeFreeTasks(idGenerator)
            self.epics = preparedFakeEpics(idGenerator)
            
            if !save() {
                Self.logger.error("Failed to save default data into database")
            }
            // End
        }
        
    }
    
    
    func loadFrom(_ url: URL) -> Bool {
        do {
            let decoder = JSONDecoder()
            let rawData = try Data(contentsOf: url)
            let modeldataStorage = try decoder.decode(ModelDataStorage.self, from: rawData)
            epics = modeldataStorage.epics.map { HierEpic($0) }
            freeTasks = modeldataStorage.freeTasks.map{ HierTask($0) }
            deletedTasks = modeldataStorage.deletedTasks.map{ HierTask($0) }
            idGenerator.currId = modeldataStorage.lastId
            
            priorityMode = modeldataStorage.priorityMode
            
            useICloud = modeldataStorage.useICloud
            photoBytesMap = modeldataStorage.photoBytesMap
            login(email: modeldataStorage.email, fName: modeldataStorage.firstName, lName: modeldataStorage.lastName)

            isLoggedIn = modeldataStorage.isLoggedIn
            
            return true
        } catch {
            Self.logger.error("\(error)")
            return false
        }
    }

    func saveTo(_ url: URL) -> Bool {
        do {
            let encoder = JSONEncoder()
            let modeldataStorage = ModelDataStorage(epics: epics.map{ $0.toCodable() },
                                                    freeTasks: freeTasks.map{ $0.toCodable() },
                                                    deletedTasks: deletedTasks.map{ $0.toCodable() },
                                                    lastId: idGenerator.currId,
                                                    priorityMode: priorityMode,
                                                    useICloud: useICloud,
                                                    photoBytesMap: photoBytesMap,
                                                    isLoggedIn: isLoggedIn,
                                                    email: loggedInUser.email,
                                                    firstName: loggedInUser.firstName,
                                                    lastName: loggedInUser.lastName)
            let encodedData = try encoder.encode(modeldataStorage)
            try encodedData.write(to: url)
            return true
        } catch {
            Self.logger.error("saveTo(\(url)) \n \(error)")
            return false
        }
    }
    
    func loadFromLocal() -> Bool { loadFrom(localURL) }
    
    func loadFromICloud() -> Bool {
        guard let iCldUrl = iCloudURL else { return false }
        return loadFrom(iCldUrl)
    }
    
    func saveToLocal() -> Bool { saveTo(localURL) }
    
    func saveToICloud() -> Bool {
        guard let iCldUrl = iCloudURL else { return false }
        return saveTo(iCldUrl)
    }
    
    
    /// load data from iCloud if useICloud is true,
    /// else load from local database.
    func load() -> Bool {
        if useICloud {
            if !loadFromICloud() {
                Self.logger.error("Failed to load from iCloud")
                return false
            }
        } else {
            if !loadFromLocal() {
                Self.logger.error("Failed to load from local db")
                return false
            }
        }
        return true
    }
    
    /// save data to both iCloud and local database if useICloud is true,
    /// else save to local database only.
    func save() -> Bool {
        if !saveToLocal() {
            Self.logger.error("Failed to save to local db")
            return false
        }
        if useICloud {
            if !saveToICloud() {
                Self.logger.error("Failed to save to iCloud")
                return false
            }
        }
        return true
    }
    
    func login(email: String, fName: String, lName: String) {
        loggedInUser = HierUserInfo(email: email, fName: fName, lName: lName)
        
        // search photo by email
        if let photoBytes = photoBytesMap[loggedInUser.email] {
            loggedInUser.photo = photoBytes.base64ToUIImage() ?? loggedInUser.photo
        }
        
        isLoggedIn = true
    }
    
    func updatePhoto(uiImage: UIImage) -> Bool {
        if let photoBytes = uiImage.uiImageToBase64() {
            loggedInUser.photo = uiImage
            photoBytesMap[loggedInUser.email] = photoBytes
            return true
        }
        return false
    }
    
    func logout() {
        isLoggedIn = false
        loggedInUser = HierUserInfo()
    }
    
    /// Add a HierEpic to ModelData
    func addEpic(_ epic: HierEpic) {
        epics.append(epic)
    }
    
    /// Add a free HierTask to ModelData
    func addFreeTask(_ task: HierTask) {
        freeTasks.append(task)
    }
    
    /// Build a filter chain based on condition closures to query
    /// all HierTasks in the ModelData.
    ///
    /// Example:
    ///
    ///     let tasks = queryTasks(
    ///         { $0.priority == .High },
    ///         { $0.importance == .Critical },
    ///         { $0.cost >= 0.5 && $0.cost < 1.0 })
    ///
    func queryTasks(_ conditions: (HierTask) -> Bool...) -> [HierTask] {
        let ft = ChainFilter<HierTask>(filter: { _ in true })
        conditions.forEach { ft.addNextChainFilter($0) }
        return allTasks.filter { ft.doFilter($0) }
    }
    
    /// Build a filter chain based on condition closures to query
    /// all HierStories in the ModelData.
    ///
    /// Example:
    ///
    ///     let stories = queryStories({ $0.tasks.count > 2 })
    ///
    func queryStories(_ conditions: (HierStory) -> Bool...) -> [HierStory] {
        let ft = ChainFilter<HierStory>(filter: { _ in true })
        conditions.forEach { ft.addNextChainFilter($0) }
        return epics.flatMap { $0.stories.filter { ft.doFilter($0) } }
    }
    
    /// Build a filter chain based on condition closures to query
    /// all HierEpics in the ModelData.
    ///
    /// Example:
    ///
    ///     let epics = queryEpics({ $0.stories.count > 2 })
    ///
    func queryEpics(_ conditions: (HierEpic) -> Bool...) -> [HierEpic] {
        let ft = ChainFilter<HierEpic>(filter: { _ in true })
        conditions.forEach { ft.addNextChainFilter($0) }
        return epics.filter { ft.doFilter($0) }
    }
    
    /// Delete a HierEpic from Modeldata, you can choose to either
    /// delete all subordinate tasks or add them to free-task list.
    func deleteEpic(epic: HierEpic, deleteTasks: Bool = true) -> Bool {
        let epics_count_before = epics.count
        epics = epics.filter { $0.id != epic.id }
        let epics_count_after = epics.count
        
        if epics_count_before > epics_count_after {
            epic.stories.forEach { $0.tasks.forEach{ task in
                task.story = nil
                if deleteTasks {
                    deletedTasks.append(task)
                } else {
                    freeTasks.append(task)
                }
            } }
        }
        
        return epics_count_before > epics_count_after
    }
    
    /// Delete a HierStory from Modeldata, you can choose to either
    /// delete all subordinate tasks or add them to free-task list.
    func deleteStory(story: HierStory, deleteTasks: Bool = true) -> Bool {
        let stories_count_before = epics.reduce(0) { $0 + $1.stories.count }
        epics.forEach { $0.stories = $0.stories.filter { $0.id != story.id } }
        let stories_count_after = epics.reduce(0) { $0 + $1.stories.count }
        
        if stories_count_before > stories_count_after {
            story.epic = nil
            story.tasks.forEach{ task in
                task.story = nil
                if deleteTasks {
                    deletedTasks.append(task)
                } else {
                    freeTasks.append(task)
                }
            }
        }
        
        return stories_count_before > stories_count_after
    }
    
    /// Delete a HierTask from Modeldata's Hierarchy
    func deleteNonfreeTask(_ task: HierTask) -> Bool {
        let tasks_count_before = epics.reduce(0) { $0 + $1.stories.reduce(0) { $0 + $1.tasks.count } }
        epics.forEach { $0.stories.forEach{ $0.tasks = $0.tasks.filter { $0.id != task.id } } }
        let tasks_count_after = epics.reduce(0) { $0 + $1.stories.reduce(0) { $0 + $1.tasks.count } }
        if tasks_count_before > tasks_count_after {
            task.story = nil
            deletedTasks.append(task)
        }
        return tasks_count_before > tasks_count_after
    }
    
    /// Delete a HierTask from Modeldata's freetask list
    func deleteFreeTask(_ task: HierTask) -> Bool {
        let tasks_count_before = freeTasks.count
        freeTasks = freeTasks.filter { $0.id != task.id }
        let tasks_count_after = freeTasks.count
        return tasks_count_before > tasks_count_after
    }
    
    /// Delete a HierTask from Modeldata, no matter it is in HierStory or
    /// free-task list.
    func deleteTask(_ task: HierTask) -> Bool {
        deleteNonfreeTask(task) || deleteFreeTask(task)
    }
    
    /// Move a Free HierTask into a HierStory.
    func moveFreeTaskToStory(_ task: HierTask, story: HierStory) -> Bool {
        if task.story != nil { return false }
        if !deleteFreeTask(task) { return false }
        story.addTask(task)
        return true
    }
    
    /// Move a Non-free HierTask from its HierStory to FreeTasks List.
    func moveTaskToFreeList(_ task: HierTask) -> Bool {
        guard let story = task.story else { return false }
        story.tasks = story.tasks.filter { $0.id != task.id }
        addFreeTask(task)
        return true
    }
    
}

