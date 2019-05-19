//
//  RootViewController.swift
//  filmrausch
//
//  Created by Liridon Luzha on 16.12.18.
//  Copyright © 2018 Liridon Luzha. All rights reserved.
//

import UIKit

struct Meta: Codable {
    let semester, hVs: String
    
    enum CodingKeys: String, CodingKey {
        case semester
        case hVs = "HVs"
    }
}

class RootViewController: UIViewController {
    
    var movies = [Movie]()
    
    var movieFetchable: MovieFetchable?
    var imageFetchable: ImageFetchable?
    
    var startPoint = CGPoint()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.initCollectionView()
        }
        self.getMovies()
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            startPoint = recognizer.location(in: self.view)
        } else {
            let dist = startPoint.y - recognizer.location(in: self.view).y
            if dist > 100,
                let cell = collectionView.visibleCells.first,
                let path = collectionView.indexPath(for: cell) {
                self.showDetail(indexPath: path)
            }
        }
        let velocity = recognizer.velocity(in: self.view)
        // swipe up
        guard velocity.y < 0 else {
            return
        }
        
    }
    
    /// updates the movies via the injected movieFetchable
    func getMovies() {
        movieFetchable?.getMovies(onSuccess: { movies in
            self.movies = movies
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }, onError: { error in
            DispatchQueue.main.async {
                self.displayError(title: "We are sorry",
                                  message: "An error occured: \(error.localizedDescription)")
            }
        })
    }
    
    func getNextMovie() {
        // get Next Movie by Date or last Movie
    }
    
    private func initCollectionView() {
        collectionView.register(CollectionViewCell.getNib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.isPagingEnabled = true
        
        let flowLayout = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView.reloadData()
    }
    
    private func showDetail(indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
}

// API NETWORKING
extension RootViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        let movie = movies[indexPath.row]
        
        // get the image async and display it
        imageFetchable?.getFrom(urlString: movie.poster, onFinished: { image in
            DispatchQueue.main.async {
                cell.set(movie: image)
                cell.set(background: image)
            }
        })
        
        let title = movie.name
        let movieDate = movie.date.toDate()
        let detail = String.combine(first: movieDate.asString(style: .short), second: movie.special)
        cell.set(title: title, detail: detail)
        
        cell.addButtonTapAction = {
            self.showDetail(indexPath: indexPath)
        }
        return cell
    }
    
    // Pass Data to Detail View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath else {
            return
        }
        let rowSelected = indexPath.row
        if segue.identifier == "showDetail"{
            if let destinationVC = segue.destination as? DetailViewController{
                destinationVC.imageFetchable = imageFetchable
                destinationVC.movie = movies[rowSelected]
            }
        }
    }
}


