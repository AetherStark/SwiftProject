//
//  TableViewCellExp.swift
//  SwiftProject
//
//  Created by Francisco on 07/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit

class TableViewCellExp: UITableViewCell {
    
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var numReporte: UILabel!
    @IBOutlet weak var titulo: UILabel!
    //Outlets de nuestra celda prototipo
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
