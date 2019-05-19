//
//  ViewControllers.swift
//  filmrausch
//
//  Created by Liridon Luzha on 28.01.19.
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import UIKit

extension RootViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let baseSize = UIScreen.main.bounds
        let width = baseSize.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
        
    }
}
