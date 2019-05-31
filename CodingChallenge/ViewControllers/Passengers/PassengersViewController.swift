//
//  PassengersViewController.swift
//  CodingChallenge
//
//  Created by Belkheir Oussama on 29/05/2019.
//  Copyright © 2019 Belkheir Oussama. All rights reserved.
//

import UIKit

class PassengersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    let issPassengerManager: ISSPassengersManager
    var passengersList: [ISSPassenger] = []

    init(issPassengersManager: ISSPassengersManager) {
        self.issPassengerManager = issPassengersManager
        super.init(nibName: "PassengersViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")!
        cell.textLabel?.text = passengersList[indexPath.row].name
        cell.textLabel?.textAlignment = .center

        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.activityIndicator.startAnimating()
        self.issPassengerManager.getAstronostsList { [weak self] (passengers, error) in
            guard let self = self else { return }

            if let networkingError = error {
                UIAlertHelper.displayUIAlert(error: networkingError, from: self)
                return
            }
            if let passengersList = passengers {
                self.passengersList = passengersList
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
    }


}
