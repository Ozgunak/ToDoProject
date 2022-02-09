//
//  DetailModels.swift
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

enum DetailTodo {
    struct TodoField {
        var title: String
        var description: String
        var notificationDate: Date
        var notificationId: String?
    }
    
    
    // MARK: Use cases
    enum CreateTodo {
        struct Request {
            var todoField: TodoField
        }
        struct Response {
            var isSuccess: Bool?
        }
        struct ViewModel {
            var isSuccess: Bool?
        }
    }
    enum EditTodo {
        struct Request {
            var todoField: TodoField
        }
        struct Response {
            var isSuccess: Bool?
            var notificationSuccess: Bool?
        }
        struct ViewModel {
            var isSuccess: Bool?
            var notificationSuccess: Bool?
        }
    }
    
    
    enum FetchTodo {
      struct Request {
      }
      struct Response {
          var todo: TodoItem?
      }
      struct ViewModel {
          var title: String
          var descriptions: String
          var notificationDate: Date
      }
    }
}


