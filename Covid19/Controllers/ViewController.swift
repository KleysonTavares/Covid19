//
//  ViewController.swift
//  Covid19
//
//  Created by Kleyson on 16/02/2021.
//  Copyright © 2021 Kleyson Tavares. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avgDeathLabel: UILabel!
    private var cases : [Case] = []
    private let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestUserLocation()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CasesTableViewCell", bundle: nil), forCellReuseIdentifier: "CasesTableViewCell")
        fetchCases()
    }
    
    private func fetchCases() {
        API.fetchCases(completion: { (casesArray) in
            self.cases = Array(casesArray.suffix(from: casesArray.count - 180))
            self.tableView.reloadData()
            self.avgDeathLabel.text = String(self.calculateAvgDeath())
            self.saveMaxCase(maxCase: self.calculateMaxConfirmedCases())
            self.saveMaxDeath(maxDeath: self.calculateMaxDeath())
            
        }) { (errorMessage) in
            self.showErrorMessage(message: errorMessage)
        }
    }
    
    private func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Ops!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func formatDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateToString(date: dateFormatter.date(from: dateString))
    }
    
    private func dateToString(date: Date?) -> String {
        guard let date = date else {return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func calculateAvgDeath() -> Int {
        let arrayDeath = self.cases.suffix(from: self.cases.count - 14)
        var avgDeath = 0
        for item in arrayDeath {
            avgDeath += item.Deaths
        }
        return avgDeath
    }
    
    private func calculateMaxDeath() -> Int {
        let arrayDeath = self.cases.suffix(from: self.cases.count - 30)
        let maxDeath = arrayDeath.max{
            $0.Deaths < $1.Deaths
        }
        return maxDeath?.Deaths ?? 0
    }
    
    private func calculateMaxConfirmedCases() -> Int {
        let arrayConfirmedCases = self.cases.suffix(from: self.cases.count - 30)
        let maxConfirmedCases = arrayConfirmedCases.max{
            $0.Confirmed < $1.Confirmed
        }
        return maxConfirmedCases?.Confirmed ?? 0
    }
    
    private func saveMaxCase(maxCase: Int) {
        UserDefaultCases.salveCasesOrDeath(max: maxCase, key: .maxCase)
    }
    
    private func saveMaxDeath(maxDeath: Int) {
        UserDefaultCases.salveCasesOrDeath(max: maxDeath, key: .maxDeath)
    }
    
    private func saveUserLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        UserDefaultCases.salveLatitudeOrLongitude(latLng: latitude, key: .latitude)
        
        UserDefaultCases.salveLatitudeOrLongitude(latLng: longitude, key: .longitude)
    }
    
    private func requestUserLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CasesTableViewCell", for: indexPath) as? CasesTableViewCell
            else { return UITableViewCell()}
        let confirmed = String(cases[indexPath.row].Confirmed)
        let deaths = String(cases[indexPath.row].Deaths)
        let date = cases[indexPath.row].Date
        cell.setupCell(date: formatDate(dateString: date), deaths: deaths, confimed: confirmed)
        
        return cell
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        saveUserLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("error GPS")
        }
    }
}
