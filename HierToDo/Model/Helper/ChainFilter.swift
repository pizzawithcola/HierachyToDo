//
//  ChainFilter.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/3/21.
//

import Foundation

final class ChainFilter<T> {
    var filter: (T) -> Bool
    var next: ChainFilter?
    
    init(filter: @escaping (T) -> Bool, next: ChainFilter? = nil) {
        self.filter = filter
        self.next = next
    }
    
    func doFilter(_ obj: T) -> Bool {
        let result = filter(obj)
        
        if let nextFilter = next {
            return result && nextFilter.doFilter(obj)
        } else {
            return result
        }
    }
    
    func addNextChainFilter(_ filter: @escaping (T) -> Bool) {
        if let nextFilter = next {
            nextFilter.addNextChainFilter(filter)
        } else {
            next = ChainFilter(filter: filter)
        }
    }
}
