//
//  ViewController.swift
//  Movies
//
//  Created by Faizyy on 02/04/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MoviewCollectionViewCell.nib(), forCellWithReuseIdentifier: MoviewCollectionViewCell.identifier)
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviewCollectionViewCell.identifier, for: indexPath) as? MoviewCollectionViewCell else {
            fatalError("Cannot dequeue cell of type \(MoviewCollectionViewCell.description())")
        }
        configure(cell, for: indexPath)
        return cell
    }
    
    // cell congifuration here
    private func configure(_ cell: MoviewCollectionViewCell, for indexPath: IndexPath) {
        cell.movieNameLabel.text = "Some Dummy name"
        cell.movieGenreLabel.text = "Smome dummy genre"
    }
    
}
