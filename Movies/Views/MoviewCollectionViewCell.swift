//
//  MoviewCollectionViewCell.swift
//  Movies
//
//  Created by Faizyy on 02/04/21.
//

import UIKit

class MoviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    
    static var identifier = "MoviewCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MoviewCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
