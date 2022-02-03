//
//  TodoStore.swift
//  ToDoProject
//
//  Created by ozgun on 2.02.2022.
//

import Foundation
import CoreData

class TodoStore: TodosStoreProtocol, DetailStoreProtocol {
    func fetchTodos(completionHandler: @escaping (() throws -> [TodoItem]) -> Void) {
        let todos = CoreDataManager().fetchTodoList()
//        let todos = CoreDataManager.shared.fetchTodos(ascending: true)
        completionHandler { return todos }
    }
    
    
   

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
    
//    func checkTodo(todoIdToCheck: Int, completionHandler: @escaping (() throws -> Int, Todo?) -> Void) {
//        
//        CoreDataManager().checkTodo(id: Int64(todoIdToCheck)){
//            onSuccess in
//            print("update =\(onSuccess)")
//        }
//    }
    
}
