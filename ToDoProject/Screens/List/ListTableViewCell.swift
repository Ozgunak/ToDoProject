//
//  ListTableViewCell.swift
//  ToDoProject
//
//  Created by ozgun on 3.02.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var doneImageView: UIImageView!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bubbleView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = bubbleView.frame.height / 10
    }

    func getData(title: String, isDone: Bool){
        listLabel.text = title
        doneImageView.image = isDone ? UIImage(named: K.done) : UIImage(named: K.notDone)
        listLabel.textColor = isDone ? .gray : .white
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
    }
}
