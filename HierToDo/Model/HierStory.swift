//
//  HierStory.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/3/21.
//

import Foundation

@Observable
class HierStory: CustomStringConvertible, Identifiable {
    let id: Int
    var name: String
    var description: String
    var tasks = [HierTask]()
    
    var colorRGB = ColorRGB(red: 1, green: 1, blue: 1)
    weak var epic: HierEpic?
    
    init(_ id: Int, name: String = "name", description: String = "description", tasks: HierTask...) {
        self.id = id
        self.name = name
        self.description = description
        tasks.forEach { addTask($0) }
    }
    
    convenience init(_ from: HierStoryDto) {
        self.init(from.id)
        self.name = from.name
        self.description = from.description
        from.tasks.forEach { self.addTask(HierTask($0)) }
    }
    
    func toCodable() -> HierStoryDto {
        HierStoryDto(id: id, name: name, description: description, tasks: tasks.map { $0.toCodable() }, colorRGB: colorRGB)
    }
    
    func addTask(_ tasks: HierTask...) {
        tasks.forEach { t in
            t.story = self
            self.tasks.append(t)
        }
    }
    
    /// Calculate the time distribution of all tasks in Seconds by task status
    func statusDist() -> [Status:TimeInterval] {
        var aggregation = [Status:TimeInterval]()
        tasks.forEach { t in
            let aggr = t.statusDist()
            aggregation.merge(aggr) { $0 + $1 }
        }
        return aggregation
    }
}

struct HierStoryDto: Codable {
    var id: Int
    var name: String
    var description: String
    var tasks: [HierTaskDto]
    var colorRGB: ColorRGB?
}
