//
//  CollectionViewCell.swift
//  filmrausch
//
//  Created by Liridon Luzha on 25.01.19.
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var moreInfo: UIButton!
    
    @IBAction func showDetail(_ sender: Any) {
        addButtonTapAction?()
    }
    
    override func prepareForReuse() {
        backgroundImageView.image = nil
        moviePoster.image = nil
        addButtonTapAction = nil
    }
    
    var addButtonTapAction : (()->())?
    
    static let identifier = "CollectionViewCell"
    
    static func getNib() -> UINib {
        return UINib(nibName: CollectionViewCell.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        moreInfo.alignTextUnderImage()
        super.awakeFromNib()
    }
    
    func set(title: String, detail: String) {
        self.titleLabel.text = title
        self.detailLabel.text = detail
    }
    
    func set(background image: UIImage?) {
        self.backgroundImageView.image = image
    }
    
    func set(movie image: UIImage?) {
        self.moviePoster.image = image
    }
    
}
