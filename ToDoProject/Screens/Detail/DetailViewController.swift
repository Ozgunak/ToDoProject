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
}

class DetailViewController: UIViewController, DetailDisplayLogic {
   
  var interactor: DetailBusinessLogic?
  var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?

    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewDetail: UIView!
    @IBOutlet weak var notificationDateLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
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
  
  // MARK: - Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
      super.viewDidLoad()
      fetchDetail()
      configureKeyboardToolbar()
      setBackButtonTitle()
      containerView.addShadowAndCornerRadius()
      containerViewDetail.addShadowAndCornerRadius()
  }
    
    deinit {
        self.saveButton.title = "Save"
        self.editButton.title = "Save"
    }
    
  
    //MARK: - Save and Edit Button actions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if titleTextField.text != "" {
            let title = titleTextField.text
            let description = descriptionTextView.text
             
            let date = notificationSwitch.isOn ? datePicker.date : NSDate.distantPast
            if title != nil {
                let request = DetailTodo.CreateTodo.Request( todoField: DetailTodo.TodoField(title: title!, description: description ?? "", notificationDate: date))
                interactor?.createTodo(request: request)
            }
        }else {
            shortAlert(title: "Title Empty", message: "Title can not be empty")
        }
    }
    //MARK: - Edit Button

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if titleTextField.text != "" {
            let title = titleTextField.text
            let description = descriptionTextView.text
            let date = notificationSwitch.isOn ? datePicker.date : NSDate.distantPast
            if title != nil {
                let request = DetailTodo.EditTodo.Request(todoField: DetailTodo.TodoField(title: title!, description: description ?? "", notificationDate: date))
                interactor?.editTodo(request: request)
            }
        }else {
            shortAlert(title: "Title Empty", message: "Title can not be empty")
        }
    }
    
    //MARK: - Switch

    @IBAction func notificationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            datePicker.isHidden = false
            notificationDateLabel.isHidden = false
            notificationDateLabel.text = "Dont forget to save!"
            datePicker.minimumDate = Date()
        }else {
            notificationDateLabel.isHidden = true
            datePicker.isHidden = true
        }
        
    }
    //MARK: - Date Picker

    @IBAction func datePickerTapped(_ sender: UIDatePicker) {
    }
    
    //MARK: - Back button as Cancel

    func setBackButtonTitle() {
        let backButton = UIBarButtonItem()
        backButton.title = "Cancel"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    //MARK: - Done button toolbar

    func createKeyboardToolbar() -> UIToolbar {
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
    
    func configureKeyboardToolbar() {
        let toolbar = createKeyboardToolbar()
        titleTextField.inputAccessoryView = toolbar
        descriptionTextView.inputAccessoryView = toolbar
        
    }
    @objc func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        titleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    //MARK: - Data functions

    func fetchDetail() {
        let request = DetailTodo.FetchTodo.Request()
        interactor?.fetchTodo(request: request)
    }

    func displayCreateTodo(viewModel: DetailTodo.CreateTodo.ViewModel) {
        guard let isSuccess = viewModel.isSuccess else {
            self.shortAlert(title: "Failed", message: "Failed creating Todo")
            return
        }
        if (viewModel.notificationSuccess == false || viewModel.notificationSuccess == nil) && notificationSwitch.isOn == true  {
            showAlertToSettings(title: "Todo saved but notification not set!", message: "Please go settings and give permission")
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
        descriptionTextView.text = viewModel.descriptions
        if viewModel.notificationDate != NSDate.distantPast && viewModel.notificationDate >= Date() {
            notificationSwitch.isOn = true
            notificationDateLabel.text = viewModel.notificationDate.toString()
            datePicker.date = viewModel.notificationDate
        }else {
            notificationSwitch.isOn = false
            notificationDateLabel.text = ""
        }
    }
    
    func displayEditTodo(viewModel: DetailTodo.EditTodo.ViewModel) {
        guard let isSuccess = viewModel.isSuccess else {
            self.shortAlert(title: "Failed", message: "Failed editing Todo")
            return
        }
        if (viewModel.notificationSuccess == false || viewModel.notificationSuccess == nil) && notificationSwitch.isOn == true {
            showAlertToSettings(title: "Todo saved but notification not set!", message: "Please go settings and give permission")
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
