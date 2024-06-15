//
//  HelperFunctions.swift
//  HierToDo
//
//  Created by Xu (Jordan) Han on 2024/4/13.
//

import Foundation
import UIKit
import SwiftUI

extension String {
    func base64ToUIImage() -> UIImage? {
        guard let imageData = Data(base64Encoded: self), let uiImage = UIImage(data: imageData) else {
            return nil
        }
        return uiImage
    }
}

extension UIImage {
    func uiImageToBase64(compress: Bool = false, maxByteSize: Int = 100 * 1024, maxCompressTimes: Int = 10) -> String? {
        var qualityFactor = 1.0
        var imageData = self.jpegData(compressionQuality: qualityFactor)
        
        // Compress
        if compress && imageData != nil {
            for _ in 1..<maxCompressTimes {
                if imageData!.count < maxByteSize {
                    break
                }
                qualityFactor /= 2.0
                imageData = self.jpegData(compressionQuality: qualityFactor)
            }
        }
        
        return imageData?.base64EncodedString()
    }
}

extension Date {
    var timeFactor: Float {
        let oneHour: TimeInterval = 60 * 60  // One Hour in seconds
        let delta = self.timeIntervalSinceNow
        if delta < oneHour { return 2.5 }
        else if delta < 2 * oneHour { return 2 }
        else if delta < 3 * oneHour { return 1.5 }
        else if delta < 4 * oneHour { return 1 }
        else if delta < 5 * oneHour { return 0.5 }
        else { return 0 }
    }
}

/// Sort an Array of HierTask by given PriorityMode
///
/// Example:
///
///     let tasks = modelData.allTasks
///     tasks.sortByPriority(.Default)
///
extension Array where Element == HierTask {
    mutating func sortByPriority(_ mode: PriorityMode = .Default) {
        switch mode {
        case .Default:
            self.sort { t1, t2 in t1.id < t2.id }
        case .Importance:
            self.sort { t1, t2 in t1.importance.rawValue < t2.importance.rawValue }
        case .Time:
            self.sort { t1, t2 in
                let now_ = Date.now
                return t1.dueAt.timeIntervalSince(now_) < t2.dueAt.timeIntervalSince(now_)
            }
        case .Priority:
            self.sort { t1, t2 in
                return (2.5 * Float(t1.importance.rawValue + 1) + t1.dueAt.timeFactor) > (2.5 * Float(t2.importance.rawValue + 1) + t2.dueAt.timeFactor)
            }
        }
    }
}
