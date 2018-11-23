import UIKit
import MapKit

/// Класс котроллера списка точек
class LocationsListViewController: UIViewController {
    
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationService = LocationService()
    let placesSearchController = UISearchController(searchResultsController: nil)
    var matchingItems = [MKMapItem]()
    let routeItems = [MKMapItem]()
    
    
    func searchBarIsEmpty() -> Bool {
        //returns true if the text is empty or nil
        return placesSearchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return placesSearchController.isActive && !searchBarIsEmpty()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
}

extension LocationsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if isFiltering() { return matchingItems.count } else { return routeItems.count }
        //return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var selectedItem = MKMapItem().placemark
        if isFiltering() {
            selectedItem = matchingItems[indexPath.row].placemark
        } else {
            selectedItem = routeItems[indexPath.row].placemark
        }
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = (selectedItem.subThoroughfare ?? "") + " " + (selectedItem.thoroughfare ?? "")
        return cell
       /*
        cell.textLabel?.text = "Название"
        cell.detailTextLabel?.text = "Детали"
        return cell
        */
    }
    
}

extension LocationsListViewController: UISearchResultsUpdating {
    
    private func setupSearchBar() {
        
        placesSearchController.searchResultsUpdater = self
        placesSearchController.hidesNavigationBarDuringPresentation = false
        placesSearchController.dimsBackgroundDuringPresentation = true
        
        let searchBar = placesSearchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Insert address here:"
        definesPresentationContext = true
        
        
        searchBarView.addSubview(searchBar)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else { return }
        
        locationService.searchLocationforAddress(address: searchBarText, region: MapViewController.globalRegion, completion: {[weak self] resultItems in
            if resultItems.count != 0 {
                self!.matchingItems = resultItems
                print("Найдено: \(self!.matchingItems.count)")
                for item in (self!.matchingItems) {
                    print(item.name!)
                }
                self!.tableView.reloadData()
            }
        })
        self.tableView.reloadData()
    }
}
