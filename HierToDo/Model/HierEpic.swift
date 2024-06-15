//
//  HierEpic.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/3/21.
//

import Foundation

@Observable
class HierEpic: CustomStringConvertible, Identifiable {
    let id: Int
    var name: String = "name"
    var description: String = "description"
    var stories = [HierStory]()
    var colorRGB: ColorRGB = ColorRGB(red: 1, green: 1, blue: 1)
    
    init(_ id: Int, name: String = "name", description: String = "description", stories: HierStory...) {
        self.id = id
        self.name = name
        self.description = description
        stories.forEach { addStory($0) }
    }
    
    convenience init(_ from: HierEpicDto) {
        self.init(from.id)
        self.name = from.name
        self.description = from.description
        self.colorRGB = from.colorRGB
        from.stories.forEach { self.addStory(HierStory($0)) }
    }
    
    func toCodable() -> HierEpicDto {
        HierEpicDto(id: id, name: name, description: description, stories: stories.map { $0.toCodable() }, colorRGB: colorRGB)
    }
    
    func addStory(_ stories: HierStory...) {
        stories.forEach { s in
            s.epic = self
            self.stories.append(s)
        }
    }
    
    /// Calculate the time distribution of all stories in Seconds by task status
    func statusDist() -> [Status:TimeInterval] {
        var aggregation = [Status:TimeInterval]()
        stories.forEach { s in
            let aggr = s.statusDist()
            aggregation.merge(aggr) { $0 + $1 }
        }
        return aggregation
    }
}

struct HierEpicDto: Codable {
    var id: Int
    var name: String
    var description: String
    var stories: [HierStoryDto]
    var colorRGB: ColorRGB
}
