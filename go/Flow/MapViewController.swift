import MapKit
import UIKit

/// Класс контроллера карты с контейнерВью
class MapViewController: UIViewController {
    
    // Высота серчБара
    let heightSearchBar: CGFloat = 80
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topConstraintContainer: NSLayoutConstraint!
    
    private var top: CGFloat = 0
    private var middle: CGFloat = 0
    private var lower: CGFloat = 0
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculatePositions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let direction = UISwipeGestureRecognizer.Direction.down
        animate(direction: direction,
                heightConstraint: topConstraintContainer.constant)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue" {
            let controller = segue.destination as? LocationsListViewController
            controller?.delegate = self
        }
    }
    
    // MARK: - Жесты
    
    @IBAction func up(_ sender: UISwipeGestureRecognizer) {
        
        animate(direction: sender.direction,
                heightConstraint: topConstraintContainer.constant)
    }
    
    @IBAction func down(_ sender: UISwipeGestureRecognizer) {
        
        animate(direction: sender.direction,
                heightConstraint: topConstraintContainer.constant)
    }
}

extension MapViewController {
    
    // MARK: - Вычисление позиций
    
    private func calculatePositions() {
        
        top = self.view.bounds.minY
        middle = (self.view.bounds.height * 2 / 3).rounded()
        
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.maxY
        lower = height - (view.safeAreaInsets.bottom + heightSearchBar)
    }
    
    
    // MARK: - Анимация
    
    // Перемещает контейнер на следующую позицию по направлению жеста
    private func animate(direction: UISwipeGestureRecognizer.Direction,
                         heightConstraint: CGFloat) {
        
        var position: CGFloat
        
        if heightConstraint == middle {
            
            if direction == .up {
                position = top
            } else {
                position = lower
            }
            
        } else {
            position = middle
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.topConstraintContainer.constant = position
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
}

extension MapViewController: Connection {
    
    func isActiveSearchBar(state: Bool) {

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
