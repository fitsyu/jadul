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
    
    @IBOutlet weak var loaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(VendorMarkView.self, forAnnotationViewWithReuseIdentifier: "vendor")
        mapView.delegate = self
        
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
        
        self.center(to: toCenter)
        
        loaderView.isHidden = false
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://kmbmicro.co.id/angelhack/vendors")!)) { [weak self] data, response, error in
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let vendors = try decoder.decode([Vendor].self, from: data!)
                
                DispatchQueue.main.async { [weak self] in
                    self?.handleSuccessfulFetch(vendors: vendors)
                }
                
            } catch {}
        }
        
        task.resume()
    }
    
    private func handleSuccessfulFetch(vendors: [Vendor]) {
        vendors.forEach { vendor in
            
            let firstLocation = vendor.locationTime.first!
            let coordinate = CLLocationCoordinate2D(latitude: firstLocation.lat, longitude: firstLocation.lng)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = vendor.name
            
            self.mapView.addAnnotation(annotation)
            
            
            let points = vendor.locationTime.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng) }
            
            let line = MKPolyline(coordinates: points, count: points.count)
            self.mapView.addOverlay(line)
            
            self.loaderView.isHidden = true
        }
    }
    
    private func center(to coordinate: CLLocationCoordinate2D) {
        let delta = 0.05
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)), animated: true)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.center(to: location.coordinate)
        locationManager.stopUpdatingLocation()
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation), let title = annotation.title else {
            return nil
        }
        
        var annotationView: VendorMarkView? = mapView.dequeueReusableAnnotationView(withIdentifier: "vendor") as? VendorMarkView
        
        if annotationView == nil {
            annotationView = VendorMarkView(annotation: annotation, reuseIdentifier: "vendor")
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "vendor")
        annotationView?.setMessage(msg: title)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            
            let colors: [UIColor] = [UIColor.systemMint, UIColor.systemCyan, UIColor.systemRed]
            let index = Int.random(in: 0 ..< colors.count-1)
            let color = colors[index]
            
            renderer.strokeColor = color
            renderer.lineWidth = 3.0
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation { return }
        
        let dvc = VendorDetailViewController()
        self.present(dvc, animated: true)
    }
}

