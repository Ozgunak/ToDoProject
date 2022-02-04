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
        // Initialization code
        bubbleView.layer.cornerRadius = bubbleView.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getData(title: String, isDone: Bool){
        listLabel.text = title
        doneImageView.image = isDone ? UIImage(named: K.done) : UIImage(named: K.notDone)
        listLabel.textColor = isDone ? .gray : .white
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
    }
}
