//
//  TodoItem.swift
//  TodoApp
//
//  Created by 박세라 on 3/20/25.
//

import Foundation
import UIKit
import CoreData

struct TodoItem: Hashable {
    let id: UUID
    let title: String
    let content: String?
    var isCompleted: Bool?
  
    init(id: UUID, title: String, content: String? = nil, isCompleted: Bool? = false) {
        self.id = id
        self.title = title
        self.content = content
        self.isCompleted = isCompleted ?? false
    }
    
    init(title: String, content: String? = nil, isCompleted: Bool? = false) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.isCompleted = isCompleted ?? false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension TodoItem {
    func toManagedObject(in context: NSManagedObjectContext) -> TodoItemEntity {
        let entity = TodoItemEntity(context: context)
        
        entity.id = id
        entity.title = title
        entity.content = content ?? ""
        entity.status = isCompleted ?? false
        entity.createdAt = Date()
        return entity
    }
    
    static func from(_ entity: TodoItemEntity) -> TodoItem? {
        guard let id = entity.id,
              let title = entity.title,
              let content = entity.content else {
            return nil
        }
        
        let item = TodoItem(id: id, title: title, content: content, isCompleted: entity.status)
        return item
    }
    
}
