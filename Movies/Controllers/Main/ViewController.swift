//
//  ViewController.swift
//  Movies
//
//  Created by Faizyy on 02/04/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    
    var viewModel: ViewModel!
    var debounce_timer: Timer?
    var searchController: UISearchController!
    var paginationActivity = UIActivityIndicatorView(style: .large)
    var fetchingMore = false
    var currentPage = 1
    let FOOTER_ID = "footer"
    let HEADER_ID = "header"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModelImplementation() // Make this a dependency
        setupCollectionView()
        configureSearch()
        
        bindViewModel()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.backgroundColor = .systemGray6
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MoviewCollectionViewCell.nib(), forCellWithReuseIdentifier: MoviewCollectionViewCell.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FOOTER_ID)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HEADER_ID)
    }
    
    private func configureSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type movie name here to search"
        search.searchBar.delegate = self
        navigationItem.searchController = search
        self.searchController = search
        
//        let searchBarTextField = search.searchBar.searchTextField
//        searchBarTextField.textColor = UIColor.black
//        searchBarTextField.font = UIFont.systemFont(ofSize: 14)
//        searchBarTextField.layer.cornerRadius = 4
//        searchBarTextField.layer.borderWidth = 1
//        searchBarTextField.layer.borderColor = UIColor.clear.cgColor
//        searchBarTextField.leftView = UIImageView(image: UIImage(named: "Search"))

    }

    private func bindViewModel() {
        viewModel.didFetchMoviesSucceed = { [weak self] in
            guard let self = self else {
                return
            }
            self.fetchingMore = false
            DispatchQueue.main.async {
                self.paginationActivity.stopAnimating()
                self.refreshUI()
            }
        }
        
        viewModel.didFetchMoviesFail = { [weak self] error in
            guard let self = self else {
                return
            }
            self.fetchingMore = false
            self.paginationActivity.stopAnimating()
            // Show alert to user.
            DispatchQueue.main.async {
                let errorString = error?.localizedDescription ?? "Something went wrong."
                let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                let button = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func refreshUI() {
        emptyView.isHidden = !(viewModel.movies?.count == 0)
        collectionView.reloadSections(IndexSet.init(integer: 0))
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies?.count ?? 0
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
        let movie = viewModel.getMovie(at: indexPath.row)
        cell.movieImageView.fetchImage(for: movie.Poster ?? "")
        cell.movieNameLabel.text = movie.Title
        cell.movieGenreLabel.text = movie.Year
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (view.frame.size.width / CGFloat(3)) - 15
        return CGSize(width: cellWidth, height: 223.0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return ITEM_SPACING
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return ROW_SPACING
//    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HEADER_ID, for: indexPath)
            let label = UILabel()
            label.text = "Search Results"
            headerView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FOOTER_ID, for: indexPath)
            footerView.addSubview(paginationActivity)
            paginationActivity.translatesAutoresizingMaskIntoConstraints = false
            paginationActivity.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
            paginationActivity.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
            return footerView
            
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: 60.0, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let moviesCount = viewModel.movies?.count else {
            return
        }
        if (indexPath.row == moviesCount - 1 ) { //it's your last cell
          //Load more data & reload your collection view
           if !fetchingMore {
               beginBatchFetch()
           }
        }
    }
    
    private func beginBatchFetch() {
        self.paginationActivity.startAnimating()
        self.fetchingMore = true
        viewModel.isPaginating = true
        
        viewModel.fetchMovies(for: searchController.searchBar.searchTextField.text, pageNumber: currentPage)
        
    }
    
}

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.currentPage = 1
        viewModel.isPaginating = false
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        debounce_timer?.invalidate()
        debounce_timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.viewModel.fetchMovies(for: text, pageNumber: self.currentPage)
        }
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        let searchBarTextField = searchController.searchBar.searchTextField
//        searchBarTextField.layer.borderColor = UIColor(red: 0.37, green: 0.34, blue: 0.91, alpha: 1.00).cgColor
//
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        let searchBarTextField = searchController.searchBar.searchTextField
//        searchBarTextField.layer.borderColor = UIColor.clear.cgColor
//    }
    
}

class MovieImageView: UIImageView {
    
    var urlString: String?
    
    func fetchImage(for urlString: String) {
        self.urlString = urlString
        if let url =  URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        // show alert or retry
                        self.image = UIImage(named: "placeholder")
                        return
                    }
                    if urlString == self.urlString {
                        self.image = UIImage(data: data)
                    }
                }
                
            }.resume()
        } else {
            self.image = UIImage(named: "placeholder")
        }
    }

}

