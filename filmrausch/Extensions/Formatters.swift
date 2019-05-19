//
//  Formatters.swift
//  filmrausch
//
//  Created by Liridon Luzha on 28.01.19.
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//
import UIKit

// convert Date Format to String
extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}

// convert String to Date (ISO 8601 Format)
extension String {
    func toDate() -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        let movieDateRes = formatter.date(from: self)
        return movieDateRes!
    }
}

// Combine two Strings when filled with Data (used in combining Date and Special Event String in Collection View)
extension String {
    static func combine(first: String?, second: String?) -> String {
        if (second?.isEmpty)! {
            return first!
        }
        return [first, second].compactMap{ $0 }.joined(separator: " - ")
    }
}

extension UIButton
{
    // Make Button Text Label align under Icon
    func alignTextUnderImage(spacing: CGFloat = 6.0)
    {
        if let image = self.imageView?.image
        {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    // Add white Borders to Buttons (used in Detail View Controller)
    func borderBtn() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 8.5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    
}

