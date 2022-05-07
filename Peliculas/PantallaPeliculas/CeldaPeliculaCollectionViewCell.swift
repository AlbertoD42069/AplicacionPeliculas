//
//  CeldaPeliculaCollectionViewCell.swift
//  Peliculas
//
//  Created by Jesus Alberto Diaz Dominguez on 05/05/22.
//

import UIKit

class CeldaPeliculaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblFechaEstreno: UILabel!
    @IBOutlet weak var lblNombrePelicula: UILabel!
    @IBOutlet weak var imgPelicula: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
