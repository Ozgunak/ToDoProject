//
//  ListTableViewCell.swift
//  ToDoProject
//
//  Created by ozgun on 3.02.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var timerSetLabel: UILabel!
    @IBOutlet weak var doneImageView: UIImageView!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bubbleView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.addShadowAndCornerRadius()
    }

    func getModel(item: List.FetchTodos.ViewModel.DisplayedTodo) {
        listLabel.text = item.title
        doneImageView.image = item.isDone ? UIImage(named: K.done) : UIImage(named: K.notDone)
//        listLabel.textColor = item.isDone ?  : .white
    }
    
    
    func timerSet(isSet: Bool) {
        timerSetLabel.isHidden = !isSet
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
    }
}
