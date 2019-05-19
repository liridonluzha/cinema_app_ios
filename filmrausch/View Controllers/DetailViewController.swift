import UIKit
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var iBeaconDistance = false
    
    var movie: Movie!
    var imageFetchable: ImageFetchable?
    // should be injected
    var eventStorable: EventStorable? = EventService()
    var moviedate = Date()
    var startPoint = CGPoint()
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieDuration: UILabel!
    @IBOutlet weak var movieIntro: UITextView!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var lessInfo: UIButton!
    @IBOutlet weak var auslosungButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func openCalendar(_ sender: Any) {
        eventStorable?.newEvent(for: movie, with: self)
    }
    
    @IBAction func openTrailer(_ sender: Any) {
        if let url = URL(string: movie.trailerlink) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            startPoint = recognizer.location(in: self.view)
        } else {
            let dist = startPoint.y - recognizer.location(in: self.view).y
            if dist < -100 {
                hideDetail(self)
            }
        }
    }
    
    @IBAction func hideDetail(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        
        trailerButton.borderBtn()
        calendarButton.borderBtn()
        auslosungButton.borderBtn()
        lessInfo.alignTextUnderImage()
        
        self.view.backgroundColor = .clear
        
        auslosungButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        
        if (moviedate.timeIntervalSinceNow.sign == .minus) {
            // This is set to false, to show the Lottery Function, when this App goes live, this has to be true!
            auslosungButton.isHidden = false
        }
        
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        // get the image async and display it
        imageFetchable?.getFrom(urlString: movie.poster, onFinished: { image in
            DispatchQueue.main.async {
                self.backgroundImage.image = image
            }
        })
        
        movieTitle.text = movie.name
        movieYear.text = "Jahr: " + movie.year
        movieDirector.text = "Regie: " + movie.director
        movieGenre.text = "Genre: " + movie.genre
        movieDuration.text = " Dauer: " + movie.length
        movieIntro.text = movie.intro
        movieDescription.text = movie.description
    }
    
    /*createLottery Button
     create Ticket func in first Alert is only possible if iBeacons are nearby.
     If the User is nearby then TicketView gets opened
     If not, the User gets a Abort Alert.
     */
    @IBAction func createLottery(_ sender: Any) {
        showLotteryAlert()
    }
    
    func getTicket() {
        self.performSegue(withIdentifier: "showTicket", sender: self)
    }
    
    private func showLotteryAlert() {
        let alert = UIAlertController(title: "HdM Filmrausch Auslosung",
                                      message: "Du hast die Möglichkeit was tolles zu gewinnen! \nBedenke, dass eine Teilnahme nur funktioniert wenn du im Kino sitzt.",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Losnummer generieren",
                                      style: UIAlertAction.Style.default) {  _ in
                                        self.handleLotteryAlertAction()
        })
        alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAbortAlert() {
        self.displayError(title: "Abbruch", message: "Leider befindest du dich nicht im Kino!")
    }
    
    private func handleLotteryAlertAction() {
        if iBeaconDistance == false {
            getTicket()
        } else {
            showAbortAlert()
        }
    }
    
    
    //pass Data to Ticket View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTicket"{
            if let destinationVC = segue.destination as? TicketViewController{
                destinationVC.bgimg = backgroundImage.image!
                destinationVC.date = movie.date
            }
        }
    }
    
    //IBEACON DISTANCE CHECK
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    // Scan for iBeacon with specific UUID, replace String with real UIID of Beacon in HdM Cinema
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "HdMiBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) { [unowned self] in
            switch distance {
            case (.unknown), (.far):
                self.iBeaconDistance = false
            case (.near), (.immediate):
                self.iBeaconDistance = true
            }
        }
    }
    
    
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return scrollView.contentOffset.y == 0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
