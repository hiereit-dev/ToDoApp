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
    func loadTodoItems() async -> [TodoItem] {
        await withCheckedContinuation { continuation in
            let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
            
            do {
                let result = try viewContext.fetch(request)
                let items = result.compactMap { TodoItem.from($0) }
                continuation.resume(returning: items)
            } catch {
                print("데이터 로드 실패: \(error)")
                continuation.resume(returning: [])
            }
        }
    }
    
    // todo 진행상태 update
    func updateTodoItemStatus(item: TodoItem, isChecked: Bool) async {
        await withCheckedContinuation { continuation in
            let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
            
            do {
                let result = try viewContext.fetch(request)
                if let todoItem = result.first {
                    todoItem.status = isChecked
                    try viewContext.save()
                    print("업데이트 성공")
                } else {
                    print("업데이트 실패")
                }
            } catch {
                print("데이터 로드 실패: \(error.localizedDescription)")
            }
            continuation.resume()
        }
    }
    
    func updateTodoItem(item: TodoItem, title: String) async {
        await withCheckedContinuation { continuation in
            let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
            
            do {
                let result = try viewContext.fetch(request)
                if let todoItem = result.first {
                    todoItem.title = title
                    try viewContext.save()
                    print("업데이트 성공")
                } else {
                    print("업데이트 실패")
                }
            } catch {
                print("데이터 로드 실패: \(error.localizedDescription)")
            }
            continuation.resume()
        }
    }

    
    // todo 삭제 메소드
    func deleteItem(_ item: TodoItem) {
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
    
    func searchTodoItemsWithKeyword(_ text: String) async -> [TodoItem] {
        await withCheckedContinuation { continuation in
            
            let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
            
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
            
            do {
                let result = try viewContext.fetch(request)
                let items = result.compactMap { TodoItem.from($0) }
                continuation.resume(returning: items)
            } catch {
                print("검색 실패 :\(error)")
                continuation.resume(returning: [])
            }
        }
    }
    
    func searchTodoItemsWithChecked(_ isCompleted: Bool) async -> [TodoItem] {
        await withCheckedContinuation { continuation in
            
            let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
            
            // Bool 0 또는 1로 처리 -> 쿼리에서 %d 사용
            request.predicate = NSPredicate(format: "status == %d", isCompleted ? 1 : 0)
            
            do {
                let result = try viewContext.fetch(request)
                let items = result.compactMap { TodoItem.from($0) }
                continuation.resume(returning: items)
            } catch {
                print("검색 실패 :\(error)")
                continuation.resume(returning: [])
            }
        }
    }
    
}
