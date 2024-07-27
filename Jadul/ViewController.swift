//
//  ViewController.swift
//  Jadul
//
//  Created by Fitsyu  on 27/07/24.
//

import CoreLocation
import MapKit
import UIKit


class ViewController: UIViewController {
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let toCenter: CLLocationCoordinate2D
        if let location = locationManager.location {
            toCenter = location.coordinate
        } else {
            toCenter = CLLocationCoordinate2D(latitude: -6.294143562858167, longitude: 106.78478842425737)
        }

        mapView.setRegion(MKCoordinateRegion(center: toCenter, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://kmbmicro.co.id/angelhack/vendors")!)) { data, response, error in
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let info = try decoder.decode([Vendor].self, from: data!)
                
                print(info)
                    
            } catch {
                print(error)
                
            }
        }
        
        task.resume()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
     
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
}

struct Vendor: Decodable {
    let id: Int
    let name: String
//    let audio: String
    
    let items: [Item]
    let locationTime: [LocationTime]
    
    struct Item: Decodable {
        let id: Int
        let name: String
        let price: Int
    }
    
    struct LocationTime: Decodable {
        let lat: Double
        let lng: Double
        let time: String
    }
}
