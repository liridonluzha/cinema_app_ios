//
//  ImageProvider.swift
//  filmrausch
//
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol ImageFetchable {
    func getFrom(urlString: String, onFinished: @escaping (UIImage?) -> ())
}

class ImageProvider: ImageFetchable {
    func getFrom(urlString: String, onFinished: @escaping (UIImage?) -> ()) {
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                let image = UIImage(data: data)
                onFinished(image)
            }
        }
    }

    
}
