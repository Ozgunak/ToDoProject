//
//  ListViewController.swift
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

protocol ListDisplayLogic: AnyObject {
    func displayTodoList(viewModel: List.FetchTodos.ViewModel)
    func displayUpdatedTodoList(viewModel: List.CheckTodo.ViewModel)
    func displayDeletedTodoList(viewModel: List.DeleteTodo.ViewModel)
}

class ListViewController: UIViewController, ListDisplayLogic {
    
    @IBOutlet weak var searchbarText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: ListBusinessLogic?
    var router: (NSObjectProtocol & ListRoutingLogic & ListDataPassing)?
    
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
        let interactor = ListInteractor()
        let presenter = ListPresenter()
        let router = ListRouter()
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
        let nib = UINib(nibName: K.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: K.listCell)
        configureKeyboardToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTodos()
    }
    
    // MARK: - Display Functions
    
    var displayedTodos: [List.FetchTodos.ViewModel.DisplayedTodo] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    func fetchTodos() {
        let request = List.FetchTodos.Request()
        interactor?.fetchTodos(request: request)
    }
    
    func displayTodoList(viewModel: List.FetchTodos.ViewModel) {
        displayedTodos = viewModel.displayedTodos
    }
    
    
    func displayUpdatedTodoList(viewModel: List.CheckTodo.ViewModel) {
        displayedTodos[viewModel.row].isDone = viewModel.todo.isDone
    }
    
    func displayDeletedTodoList(viewModel: List.DeleteTodo.ViewModel) {
        displayedTodos.remove(at: viewModel.row)
    }
    
    @IBAction func createButtonPressed(_ sender: UIBarButtonItem) {
        router?.routeToCreateTodo(segue: nil)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        sortByMotifiedDate()
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
        searchbarText.inputAccessoryView = toolbar
    }
    @objc func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        searchbarText.resignFirstResponder()
    }
    
    //MARK: - Sorting

    func sortByMotifiedDate() {
        switch displayedTodos.count {
        case 0:
            shortAlert(title: "Empty List", message: "Can not sort Empty List")
        case 1:
            shortAlert(title: "Only 1 Todo to sort", message: "Same List Everytime")
        default:
            if displayedTodos[0].lastModifiedDate > displayedTodos[displayedTodos.count - 1].lastModifiedDate {
                displayedTodos = displayedTodos.sorted() { $0.lastModifiedDate < $1.lastModifiedDate }
                shortAlert(title: "Sort by first", message: "Sorted by first motified date")
            }else {
                displayedTodos = displayedTodos.sorted() { $0.lastModifiedDate > $1.lastModifiedDate }
                shortAlert(title: "Sort by last", message: "Sorted by last motified date")
            }
            tableView.reloadData()
        }
    }
    
    //MARK: - Check Button

    @objc func checkButtonConnected(sender : UIButton!) {
        self.displayedTodos[sender.tag].isDone = !self.displayedTodos[sender.tag].isDone
        self.displayedTodos[sender.tag].lastModifiedDate = NSDate.timeIntervalSinceReferenceDate
        let request = List.CheckTodo.Request(id: self.displayedTodos[sender.tag].id, row: sender.tag, notificationId:  self.displayedTodos[sender.tag].notificationId)
        interactor?.checkTodo(request: request)
        tableView.reloadData()
    }
}

//MARK: - Table View Data Source

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.listCell, for: indexPath) as! ListTableViewCell
        let displayedData = displayedTodos[indexPath.row]
        cell.getModel(item: displayedData)
        cell.doneButton.tag = indexPath.row
        cell.doneButton.addTarget(self, action: #selector(checkButtonConnected), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if displayedTodos.isEmpty {
            return "No ToDo Yet"
        }else {
            return "ToDo's"
        }
        
    }
    
}

//MARK: - Table View Delegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToDetailTodo(index: indexPath.row, id: self.displayedTodos[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: (Bool) -> Void) in
            let request = List.DeleteTodo.Request(id: self.displayedTodos[indexPath.row].id, row: indexPath.row)
            self.interactor?.deleteTodo(request: request)
            actionPerformed(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}


extension ListViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            fetchTodos()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }        }else {
                interactor?.fetchTodos(request: List.FetchTodos.Request(text: searchBar.text ?? ""))
            }
    }
}

