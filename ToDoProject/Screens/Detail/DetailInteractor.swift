//
//  DetailInteractor.swift
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

protocol DetailBusinessLogic {
    func createTodo(request: CreateTodo.CreateTodo.Request)
    func fetchTodo(request: CreateTodo.FetchTodo.Request)
    func editTodo(request: CreateTodo.EditTodo.Request)
}

protocol DetailDataStore {
    var id: Int? { get set }
    var todo: TodoItem? { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {
    var id: Int?
    var todo: TodoItem?
    
    var presenter: DetailPresentationLogic?
    var worker = DetailWorker(todosStore: TodoStore())
  
  // MARK: Do something
  
    func createTodo(request: CreateTodo.CreateTodo.Request) {
        let title = request.todoField.title
        let description = request.todoField.description
        worker.createTodo(title: title, description: description) { (isSuccess: Bool?) in
            let response = CreateTodo.CreateTodo.Response(isSuccess: isSuccess)
            self.presenter?.presentCreateTodo(response: response)
        }
    }
                                              
    func fetchTodo(request: CreateTodo.FetchTodo.Request) {
        self.presenter?.presentTodo(response: .init(todo: todo))

        if id != nil {
//            worker.fetchTodo(id: id!) { (todo) -> Void in
//                self.todo = todo!
//
//                let response = CreateTodo.FetchTodo.Response(todo: todo!)
//                self.presenter?.presentTodo(response: response)
//            }
        }
    }
    func editTodo(request: CreateTodo.EditTodo.Request) {
        let title = request.todoField.title
        let description = request.todoField.description
        worker.editTodo(id: id!, title: title, description: description) { (isSuccess: Bool?) in
            let response = CreateTodo.EditTodo.Response(isSuccess: isSuccess)
            self.presenter?.presentEditTodo(response: response)
        }
    }
}
