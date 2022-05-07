//
//  FavoritosTableViewCell.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 05/05/22.
//

import UIKit
protocol FavoriteCellDelegate {
    func eliminarFavorito(cell:UITableViewCell)
}
class FavoritosTableViewCell: UITableViewCell {
    var delegate: FavoriteCellDelegate?
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnEliminar(_ sender: Any) {
        delegate?.eliminarFavorito(cell: self)
    }
    
    
}
