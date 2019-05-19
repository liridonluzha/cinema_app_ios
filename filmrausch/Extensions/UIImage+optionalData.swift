//
//  UIImage+optionalData.swift
//  filmrausch
//
//  Created by Liridon Luzha on 28.01.19.
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//
import UIKit

extension UIImage {
    convenience init?(data: Data?) {
        guard let data = data else { return nil }
        self.init(data: data)
    }
}
