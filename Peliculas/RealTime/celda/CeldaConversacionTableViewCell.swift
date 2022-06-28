//
//  CeldaConversacionTableViewCell.swift
//  Peliculas
//
//  Created by Hector Guadalupe Climaco Flores on 23/06/22.
//

import UIKit

class CeldaConversacionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTexto: UILabel!
    @IBOutlet weak var lblContacto: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func configure(with mode: Conversacion) {
        self.lblContacto.text = "hello"
        //self.lblContacto.text = mode.id
        //self.lblTexto.text = mode.latestMenssaage.text
        self.lblTexto.text = "nil"
    }
}
