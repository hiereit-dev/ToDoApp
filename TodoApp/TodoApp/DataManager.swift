//
//  DataManager.swift
//  TodoApp
//
//  Created by 박세라 on 3/20/25.
//

import Foundation
import CoreData
import UIKit

class DataManager {
    static let shared = DataManager()
    private init () {}
    
    private var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // todo 추가 메소드
    func saveTodoItems(_ item: TodoItem) {
        let _ = item.toManagedObject(in: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            print("저장 실패: \(error)")
        }
    }
    
    // todo 조회 메소드
    func loadGridItems() -> [TodoItem] {
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        
        do {
            let result = try viewContext.fetch(request)
            return result.compactMap { TodoItem.from($0) }
        } catch {
            print("데이터 로드 실패: \(error)")
        }
        return []
    }
    
    // todo 삭제 메소드
    func deleteGridItem(_ item: TodoItem) {
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", item.id as CVarArg)
        
        do {
            let result = try viewContext.fetch(request)
            guard let object = result.first else { return }
            
            viewContext.delete(object)
            try viewContext.save()
            
        } catch {
            print("삭제 실패: \(error)")
        }
    }
    
}
