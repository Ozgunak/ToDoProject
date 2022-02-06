//
//  TodoStore.swift
//  ToDoProject
//
//  Created by ozgun on 2.02.2022.
//

import Foundation
import CoreData


protocol TodosStoreProtocol {
    func fetchTodos(completionHandler: @escaping (() throws -> [TodoItem]) -> Void)
    func checkTodo(id: Int, completionHandler: @escaping (() throws -> Int, TodoItem?) -> Void)
    func deleteTodo(id: Int, row: Int, completionHandler: @escaping (() throws -> Int) -> Void)
}

class TodoStore: TodosStoreProtocol, DetailStoreProtocol {

    // MARK: - CRUD operations - Inner closure

    func fetchTodo(id: Int, completionHandler: @escaping (() throws -> TodoItem?) -> Void) {
        let todo = CoreDataManager().fetchTodo(id: Int64(id))
        completionHandler { return todo }
    }

    func createTodo(title: String, description: String, completionHandler: @escaping (() throws -> Bool?) -> Void) {
        CoreDataManager().saveTodo(title: title, description: description, isDone: false){ onSuccess in

            print("saved =\(onSuccess)")
            completionHandler { return onSuccess }
        }
    }
    
    func checkTodo(id: Int, completionHandler: @escaping (() throws -> Int, TodoItem?) -> Void) {
        CoreDataManager().checkTodo(id: Int64(id)){
            onSuccess in
            print("update =\(onSuccess)")
        }
    }
    func editTodo(id: Int, title: String, description: String, completionHandler: @escaping (() throws -> Bool?) -> Void) {
        CoreDataManager().editTodo(id: Int64(id), title: title, description: description, onSuccess: { onSuccess in
            print("update =\(onSuccess)")
            completionHandler { return onSuccess }
        })
    }
    func editTime(id: Int, time: Double, completionHandler: @escaping (() throws -> Bool?) -> Void) {
        CoreDataManager().editTime(id: Int64(id), time: time, onSuccess: { onSuccess in
            print("time =\(onSuccess)")
            completionHandler { return onSuccess }
        })
    }
    
    func fetchTodos(completionHandler: @escaping (() throws -> [TodoItem]) -> Void) {
        let todos = CoreDataManager().fetchTodoList()
        completionHandler { return todos }
    }
    
    func deleteTodo(id: Int, row: Int, completionHandler: @escaping (() throws -> Int) -> Void) {
        CoreDataManager().deleteTodo(id: Int64(id)){
            onSuccess in
            print("update =\(onSuccess)")
        }
    }
}
