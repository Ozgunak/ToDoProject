//
//  ListTableViewCell.swift
//  ToDoProject
//
//  Created by ozgun on 3.02.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var notificationDateLabel: UILabel!
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
        if item.notificationDate > Date() {
            timerLabel.isHidden = false
            notificationDateLabel.isHidden = false
            notificationDateLabel.text = item.notificationDate.toString(format: "HH:mm")
        }else {
            notificationDateLabel.isHidden = true
            timerLabel.isHidden = true
        }
        bubbleView.backgroundColor = item.isDone ? UIColor(named: "light") : UIColor(named: "dark")
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
    }
}
