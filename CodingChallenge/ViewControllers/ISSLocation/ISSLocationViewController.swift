//
//  ISSLocationViewController.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

public enum SpacePosition: UInt {
    case insideRadius
    case outsideRadius
}

class ISSLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var spacePosition: SpacePosition = .outsideRadius
    let issLocationManager: ISSLocationManager
    var userLocationCoordinates : CLLocationCoordinate2D?

    init(issLocationManager: ISSLocationManager) {
        self.issLocationManager = issLocationManager
        super.init(nibName: "ISSLocationViewController", bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserLocation(_:)), name: NSNotification.Name(rawValue: "userLocationNotification"), object: nil)
        
    }

    @objc func updateUserLocation(_ notification: Notification) {
        if let location = notification.userInfo?["coordinates"] as? CLLocationCoordinate2D {
            self.userLocationCoordinates = location
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self

        self.issLocationManager.moveISS { [weak self] (spaceShipLocation, error) in
            guard let self = self else { return }
            if let networkingError = error {
                UIAlertHelper.displayUIAlert(error: networkingError, from: self)
                return
            }
            DispatchQueue.main.async {
                self.centerMapOnLocation(location: spaceShipLocation)
            }
            self.notifyObserversIfNeeded(about: spaceShipLocation)
        }

    }


    private func notifyObserversIfNeeded(about location: Location) {
        if let userPoint = self.userLocationCoordinates {
            let userLocation = Location(latitude: userPoint.latitude, longitude: userPoint.longitude)
            var dataDictionary = [String: SpacePosition]()
            let isSpaceShipVisible = location.isVisible(for: userLocation, inside: 10000)

            if (isSpaceShipVisible && self.spacePosition == .outsideRadius) {
                dataDictionary["spaceLocation"] = .insideRadius
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "spaceShipNotification"), object: nil, userInfo: dataDictionary)
                self.spacePosition = .insideRadius

            } else if(!isSpaceShipVisible && self.spacePosition == .insideRadius) {
                dataDictionary["spaceLocation"] = .outsideRadius
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "spaceShipNotification"), object: nil, userInfo: dataDictionary)
                self.spacePosition = .outsideRadius
            }

        }
    }


    func centerMapOnLocation(location: Location) {
        let location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let annotation = MKPointAnnotation()
            annotation.coordinate = location

        let locationCoordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 80)
        let region = MKCoordinateRegion(center: locationCoordinates, span: span)

            // make the map track only the latest position of an annotation.
             let annotations = self.mapView.annotations
            self.mapView.removeAnnotations(annotations)
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
            self.activityIndicator.stopAnimating()

    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.image = UIImage(named: "spaceship")
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }



}
