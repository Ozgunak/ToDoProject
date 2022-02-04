//
//  ListModels.swift
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

enum List {
  
    enum FetchTodos {
        struct Request {
        }
        struct Response {
            var todos: [TodoItem]
        }
        struct ViewModel {
            struct DisplayedTodo {
                var id: Int
                var title: String
                var isDone: Bool
            }

            var displayedTodos: [DisplayedTodo]
        }
    }

    enum CheckTodo {
        struct Request {
            var id: Int
            var row: Int
        }
        struct Response {
            var row: Int
            var todo: TodoItem
        }
        struct ViewModel {
            var row: Int
            var todo: TodoItem
        }
    }


}
