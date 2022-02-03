//
//  ListWorker.swift
//  ToDoProject
//
//  Created by ozgun on 31.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit


// MARK: - Todos store API

protocol TodosStoreProtocol {
    func fetchTodos(completionHandler: @escaping (() throws -> [TodoItem]) -> Void)
    func checkTodo(todoIdToCheck: Int, completionHandler: @escaping (() throws -> Int, TodoItem?) -> Void)
}

class ListWorker {
    var todosStore: TodosStoreProtocol

    init(todosStore: TodosStoreProtocol) {
        self.todosStore = todosStore
    }

    func fetchTodos(completionHandler: @escaping ([TodoItem]) -> Void) {
        todosStore.fetchTodos { (todos: () throws -> [TodoItem])
            -> Void in
            do {
                let todos = try todos()
                DispatchQueue.main.async {
                    completionHandler(todos)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }
   

    func checkTodo(todoIdToCheck: Int, todoRowToCheck: Int, completionHandler: @escaping (Int, TodoItem?) -> Void) {
        todosStore.checkTodo(todoIdToCheck: todoIdToCheck) {
            (row: () throws -> Int, todo: TodoItem?) -> Void in

            do {
                let row = try row()
                DispatchQueue.main.async {
                    completionHandler(row, todo)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(0, nil)
                }
            }
        }
    }
}




