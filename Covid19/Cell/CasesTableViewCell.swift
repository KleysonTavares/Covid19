//
//  CasesTableViewCell.swift
//  Covid19
//
//  Created by Kleyson on 18/02/2021.
//  Copyright © 2021 Kleyson Tavares. All rights reserved.
//

import UIKit

class CasesTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(date: String, deaths: String, confimed: String){
        dateLabel.text = date
        deathsLabel.text = deaths
        confirmedLabel.text = confimed
    }
}
