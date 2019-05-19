//
//  TicketViewController.swift
//  filmrausch
//
//  Created by Liridon Luzha on 28.01.19.
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var ticketNumber: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    
    @IBAction func tapOK(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // should be injected
    var ticketFetchable: TicketFetchable? = TicketService()
    var bgimg = UIImage()
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ticketNumber.text = ""
        okButton.borderBtn()
        backgroundImage.image = bgimg
        if let date = date {
            ticketFetchable?.get(for: date, onSuccess: { ticket in
                DispatchQueue.main.async {
                    self.ticketNumber.text = "\(ticket.ticket)"
                }
            }, onError: { error in
                self.displayError(title: "We are sorry",
                                  message: "An error occured: \(error.localizedDescription)")
            })
        }
    }
    
}
