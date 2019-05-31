//
//  UserLocationViewController.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import UIKit
import MapKit

class UserLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var spaceShipPosition: SpacePosition?
    var userLocationCoordinates: CLLocationCoordinate2D?

    init() {
        super.init(nibName: "UserLocationViewController", bundle: nil)
        self.observeNotifications()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation = true
        self.mapView.tintColor = .red
        self.mapView.delegate = self
        self.updateLocationOnMap(location: self.userLocationCoordinates)
        self.changeUserPinColor(from: self.spaceShipPosition)
    }

    private func observeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserColor(_:)), name: NSNotification.Name(rawValue: "spaceShipNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserLocation(_:)), name: NSNotification.Name(rawValue: "userLocationNotification"), object: nil)
    }

    private func updateLocationOnMap(location: CLLocationCoordinate2D?) {
        guard let location = location else { return  }
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))

        let circle = MKCircle(center: location, radius: 10000)
        if(self.isViewLoaded) {
            DispatchQueue.main.async {
                self.mapView.addOverlay(circle)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }

    @objc func updateUserLocation(_ notification: Notification) {
        if let location = notification.userInfo?["coordinates"] as? CLLocationCoordinate2D {
            self.userLocationCoordinates = location
            self.updateLocationOnMap(location: location)
        }
    }

    private func changeUserPinColor(from spaceShipPosition: SpacePosition?) {
        if let position = spaceShipPosition, self.isViewLoaded {
            DispatchQueue.main.async {
                self.mapView.tintColor = (position == .insideRadius) ? .green : .red
            }
        }
    }

    @objc func updateUserColor(_ notification: Notification) {
            self.spaceShipPosition = notification.userInfo?["spaceLocation"] as? SpacePosition
            self.changeUserPinColor(from: spaceShipPosition)
    }

}

extension UserLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circelOverLay = overlay as? MKCircle else { return MKOverlayRenderer() }

        let circleRenderer = MKCircleRenderer(circle: circelOverLay)
        circleRenderer.fillColor = .lightGray
        circleRenderer.alpha = 0.2

        return circleRenderer
    }

}
