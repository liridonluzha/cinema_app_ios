//
//  RootViewController+Scroll.swift
//  filmrausch
//
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import UIKit

extension RootViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2

        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }

}
