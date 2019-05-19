//
//  EventService.swift
//  filmrausch
//
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

protocol EventStorable {
    func newEvent(for movie: Movie, with viewController: UIViewController)
}

class EventService: NSObject, EventStorable {
    let eventStore = EKEventStore()
    
    func newEvent(for movie: Movie, with viewController: UIViewController) {
        self.eventStore.requestAccess(to: .event) { [unowned self] (granted, error) in
            if granted && error == nil {
                let event = self.createEvent(for: movie)
                let eventViewController = EKEventEditViewController()
                eventViewController.editViewDelegate = self
                eventViewController.event = event
                eventViewController.eventStore = self.eventStore
                
                viewController.present(eventViewController, animated: true, completion: nil)
            }
        }
    }
    
    func createEvent(for movie: Movie) -> EKEvent {
        let event = EKEvent(eventStore: eventStore)
        event.title = "HdM Filmrausch Kino: " + movie.name
        event.location = "Nobelstraße 10, 70569 Stuttgart"
        event.notes = "Treppenstudio (2U12)"
        event.url = URL(string: "http://filmrausch.hdm-stuttgart.de")
        let movieDate = movie.date.toDate()
        event.startDate = movieDate.addingTimeInterval(19.5 * 60 * 60)
        event.endDate = movieDate.addingTimeInterval(22 * 60 * 60)
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.addAlarm(EKAlarm(absoluteDate: event.startDate))
        return event
    }
}


extension EventService: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        guard controller.event != nil else {
            fatalError("event should not be nil")
        }
        
        switch action {
        case .saved:
            save(controller.event!, from: controller)
        case .canceled:
            print("Event not added to calendar")
        case .deleted:
            print("Event deleted from calendar")
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func save(_ event: EKEvent, from controller: EKEventEditViewController) {
        do {
            try self.eventStore.save(event, span: .thisEvent)
        } catch {
            print("Failure saving event")
        }
    }
}
