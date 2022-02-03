//
//  DetailRouter.swift
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

@objc protocol DetailRoutingLogic
{
  func routeToTodoList(segue: UIStoryboardSegue?)
}

protocol DetailDataPassing: AnyObject {
  var dataStore: DetailDataStore? { get set }
}

class DetailRouter: NSObject, DetailRoutingLogic, DetailDataPassing
{
  weak var viewController: DetailViewController?
  var dataStore: DetailDataStore?
  
  // MARK: Routing
  
  func routeToTodoList(segue: UIStoryboardSegue?) {
    if let segue = segue {
      let destinationVC = segue.destination as! ListViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let destinationVC = storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
      var destinationDS = destinationVC.router!.dataStore!
        destinationVC.fetchTodos()
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
      navigateToList(source: viewController!, destination: destinationVC)
    }
  }

  // MARK: Navigation
  
  func navigateToList(source: DetailViewController, destination: ListViewController)
  {
      source.navigationController?.popToRootViewController(animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: DetailDataStore, destination: inout ListDataStore)
  {
//      destination.todos = source.todo
  }
}
