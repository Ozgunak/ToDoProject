//
//  DetailViewController.swift
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

protocol DetailDisplayLogic: AnyObject {
    func displayCreateTodo(viewModel: DetailTodo.CreateTodo.ViewModel)
    func displayTodo(viewModel: DetailTodo.FetchTodo.ViewModel)
    func displayEditTodo(viewModel: DetailTodo.EditTodo.ViewModel)
    func displayEditTime(viewModel: DetailTodo.EditTime.ViewModel)
}

class DetailViewController: UIViewController, DetailDisplayLogic {
   
  var interactor: DetailBusinessLogic?
  var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?

    @IBOutlet weak var notificationDateLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = DetailInteractor()
    let presenter = DetailPresenter()
    let router = DetailRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
      super.viewDidLoad()
      fetchDetail()
      configurePhoneTextField()
  }
    
    deinit {
        self.saveButton.title = "Save"
        self.editButton.title = "Edit"
    }
    
  
    //MARK: - Save and Edit Button actions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if titleTextField.text != "" {
            let title = titleTextField.text
            let description = descriptionTextField.text
            if title != nil {
                let request = DetailTodo.CreateTodo.Request( todoField: DetailTodo.TodoField(title: title!, description: description ?? "", lastModifiedDate: NSTimeIntervalSince1970))
                interactor?.createTodo(request: request)
            }
        }else {
            shortAlert(title: "Title Empty", message: "Title can not be empty")
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if titleTextField.text != "" {
            let title = titleTextField.text
            let description = descriptionTextField.text
            if title != nil {
                let request = DetailTodo.EditTodo.Request(todoField: DetailTodo.TodoField(title: title!, description: description ?? "", lastModifiedDate: NSTimeIntervalSince1970))
                interactor?.editTodo(request: request)
            }
        }else {
            shortAlert(title: "Title Empty", message: "Title can not be empty")
        }
    }
    @IBAction func notificationSwitch(_ sender: UISwitch) {
        datePicker.isHidden = sender.isOn ? false : true
        notificationDateLabel.isHidden = sender.isOn ? false : true
        if sender.isOn {
            let time = NSTimeIntervalSince1970
            let request = DetailTodo.EditTime.Request(todoField: DetailTodo.TodoTime(notificationDate: time))
            interactor?.editTime(request: request)
        }else {
            let time = 0.0
            let request = DetailTodo.EditTime.Request(todoField: DetailTodo.TodoTime(notificationDate: time))
            interactor?.editTime(request: request)
        }
        
    }
    @IBAction func datePickerTapped(_ sender: UIDatePicker) {
        let time = NSTimeIntervalSince1970
        let request = DetailTodo.EditTime.Request(todoField: DetailTodo.TodoTime(notificationDate: time))
        interactor?.editTime(request: request)
    }
    
    func createPhoneTextFieldKeyboardToolbar() -> UIToolbar {
        let flexibleSpace = UIBarButtonItem.flexibleSpace()
        let doneBarButton = UIBarButtonItem()
        doneBarButton.target = self
        doneBarButton.action = #selector(doneBarButtonTapped(_:))
        doneBarButton.title = "Done"
        doneBarButton.style = .plain
        
        let toolbar = UIToolbar()
        toolbar.items = [flexibleSpace, doneBarButton]
        toolbar.sizeToFit()
        return toolbar
    }
    
    func configurePhoneTextField() {
        let toolbar = createPhoneTextFieldKeyboardToolbar()
        titleTextField.inputAccessoryView = toolbar
        descriptionTextField.inputAccessoryView = toolbar
        
    }
    @objc func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        //firstTextField.resignFirstResponder()
        //textField.becomeFirstResponder()
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
    //MARK: - Data functions

    func fetchDetail() {
        let request = DetailTodo.FetchTodo.Request()
        interactor?.fetchTodo(request: request)
    }

    func displayCreateTodo(viewModel: DetailTodo.CreateTodo.ViewModel) {
        print(viewModel.isSuccess as Any)
        guard let isSuccess = viewModel.isSuccess else {
            self.shortAlert(title: "Failed", message: "Failed creating Todo")
            return
        }
        if isSuccess {
            self.shortAlert(title: "Succesfully Created", message: "Routing to main")
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.router?.routeToTodoList(segue: nil)
            }
        } else {
            self.shortAlert(title: "Failed", message: "Failed creating Todo")
        }
    }
    func displayTodo(viewModel: DetailTodo.FetchTodo.ViewModel) {
        titleTextField.text = viewModel.title
        descriptionTextField.text = viewModel.descriptions
    }
    func displayEditTime(viewModel: DetailTodo.EditTime.ViewModel) {
        notificationDateLabel.text = "Time set to: \(datePicker.date.description)"
    }
    
    func displayEditTodo(viewModel: DetailTodo.EditTodo.ViewModel) {
        print(viewModel.isSuccess as Any)
        guard let isSuccess = viewModel.isSuccess else {
            self.shortAlert(title: "Failed", message: "Failed editing Todo")
            return
        }
        if isSuccess {
            self.shortAlert(title: "Succesfully Editted", message: "Routing to main")
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.router?.routeToTodoList(segue: nil)
            }
            
        } else {
            self.shortAlert(title: "Failed", message: "Failed editing Todo")
        }
    }
    
    

}
