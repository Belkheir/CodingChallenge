//
//  ISSTabBarController.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


enum PageType: CustomStringConvertible {
    case ISSLocation
    case Passengers
    case PassTimes
    case CheckPoint

    public var description: String {
        switch self {
        case .ISSLocation:
            return "ISS Location"
        case .Passengers:
            return "Passengers list"
        case .PassTimes:
            return "Pass Times"
        case .CheckPoint:
            return "Check points"
        }
    }
    public var tabBarItemTitle: String {
        switch self {
        case .ISSLocation:
            return "Location"
        case .Passengers:
            return "Passengers"
        case .PassTimes:
            return "PassTime"
        case .CheckPoint:
            return "Track"
        }
    }
    public var tabBarIcon: String {
        switch self {
        case .ISSLocation:
            return "location"
        case .Passengers:
            return "list"
        case .PassTimes:
            return "passTime"
        case .CheckPoint:
            return "trackChange"
        }
    }
}



class ISSTabBarController: UITabBarController {
    var locationManager: CLLocationManager!

    private let networkingClient: NetworkingClient

    init() {
        self.networkingClient = NetworkingClient.sharedInstance
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpLocationManager() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        let locationNavigationController = UINavigationController(rootViewController: locationViewController)
        let passengersNavigationController = UINavigationController(rootViewController: passengersViewController)
        let passTimesNavigationController = UINavigationController(rootViewController: passTimesViewController)
        let checkPointNavigationController = UINavigationController(rootViewController: userLocationViewController)

        viewControllers = [locationNavigationController, passengersNavigationController, passTimesNavigationController, checkPointNavigationController]
         }

    lazy var locationViewController: ISSLocationViewController = {

        let locationManager = ISSLocationManager(networkingClient: networkingClient)
        let viewController = ISSLocationViewController(issLocationManager: locationManager)
        viewController.title  = PageType.ISSLocation.description
        viewController.tabBarItem = UITabBarItem(title: PageType.ISSLocation.tabBarItemTitle, image: UIImage(named: PageType.ISSLocation.tabBarIcon), selectedImage: nil)

        return viewController
    }()

    lazy var passengersViewController: PassengersViewController = {
        let passengersManager = ISSPassengersManager(networkingClient: networkingClient)
        let viewController = PassengersViewController(issPassengersManager: passengersManager)
        viewController.title  = PageType.Passengers.description
        viewController.tabBarItem = UITabBarItem(title: PageType.Passengers.tabBarItemTitle, image: UIImage(named: PageType.Passengers.tabBarIcon), selectedImage: nil)

        return viewController
    }()

    lazy var passTimesViewController: PassTimesViewController = {
        let passTimesManager = ISSPassTimeManager(networkingClient: networkingClient)
        let viewController = PassTimesViewController(passTimeManager: passTimesManager)
        viewController.title  = PageType.PassTimes.description
        viewController.tabBarItem = UITabBarItem(title: PageType.PassTimes.tabBarItemTitle, image: UIImage(named: PageType.PassTimes.tabBarIcon), selectedImage: nil)

        return viewController
    }()

    lazy var userLocationViewController: UserLocationViewController = {
        let viewController = UserLocationViewController()
        viewController.title  = PageType.CheckPoint.description
        viewController.tabBarItem = UITabBarItem(title: PageType.CheckPoint.tabBarItemTitle, image: UIImage(named: PageType.CheckPoint.tabBarIcon), selectedImage: nil)

        return viewController
    }()

}

extension ISSTabBarController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

            let dataDictionary: [String: CLLocationCoordinate2D] = ["coordinates": center]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLocationNotification"), object: nil, userInfo: dataDictionary)
        }
    }
}
