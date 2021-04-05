//
//  GenreCollectionViewCell.swift
//  Movies
//
//  Created by Faizyy on 05/04/21.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    
    static var identifier = "GenreCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "GenreCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }

}
