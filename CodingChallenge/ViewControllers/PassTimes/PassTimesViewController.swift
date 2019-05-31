//
//  PassTimesViewController.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import UIKit
import CoreLocation

class PassTimesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let passTimeManager: ISSPassTimeManager
    var passTimeList: [String] = []

    init(passTimeManager: ISSPassTimeManager) {
        self.passTimeManager = passTimeManager
        super.init(nibName: "PassTimesViewController", bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getUserPosition(_:)), name: NSNotification.Name(rawValue: "userLocationNotification"), object: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passTimeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")!
        cell.textLabel?.text = self.passTimeList[indexPath.row]
        cell.textLabel?.textAlignment = .center

        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        if(!self.passTimeList.isEmpty) {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func getUserPosition(_ notification: Notification) {

        if let location = notification.userInfo?["coordinates"] as? CLLocationCoordinate2D {
            self.passTimeManager.getPassTimeListFor(latitude: location.latitude, longitude: location.longitude) { [weak self] (passTimes, error) in
                guard let self = self else { return }
                if let networkingError = error {
                    UIAlertHelper.displayUIAlert(error: networkingError, from: self)
                    return
                }

                if let passTimeList = passTimes {
                    self.passTimeList = passTimeList.map {
                         self.passTimeManager.getStringDateFrom(unixTimeInterval: $0.risetime)
                    }
                    if self.isViewLoaded {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }

            }

        }
    }

}
