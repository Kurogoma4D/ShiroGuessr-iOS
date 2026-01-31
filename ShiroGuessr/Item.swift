//
//  Item.swift
//  ShiroGuessr
//
//  Created by Kurogoma4D on 2026/01/31.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
