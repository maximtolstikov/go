import MapKit
import UIKit

/// Класс контроллера карты с контейнерВью
class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topConstraintContainer: NSLayoutConstraint!
    @IBOutlet var containerManager: ContainerViewManager!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerManager.view = self.view
        containerManager.constraint = topConstraintContainer
        setupLocationManager()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerManager.calculatePositions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let direction = UISwipeGestureRecognizer.Direction.down
        containerManager.moveContainer(direction: direction,
                heightConstraint: topConstraintContainer.constant)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue" {
            let controller = segue.destination as? LocationsListViewController
            controller?.placesSearchController.delegate = self
        }
    }
    
    // MARK: - Жесты
    
    @IBAction func up(_ sender: UISwipeGestureRecognizer) {
        
        containerManager.moveContainer(direction: sender.direction,
                heightConstraint: topConstraintContainer.constant)
    }
    
    @IBAction func down(_ sender: UISwipeGestureRecognizer) {
        
        containerManager.moveContainer(direction: sender.direction,
                heightConstraint: topConstraintContainer.constant)
    }
}

extension MapViewController: UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
    
        let position = containerManager.top
       containerManager.animate(to: position)
    }
    
}


// MARK: - CLLicationManager

extension MapViewController: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            print("LOCATION---->>\(location)")
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR---->>\(error.localizedDescription)")
    }
}
