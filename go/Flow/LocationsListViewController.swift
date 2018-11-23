import UIKit

/// Класс котроллера списка точек
class LocationsListViewController: UIViewController {
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var tableView: UITableView!

    let placesSearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
}

extension LocationsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
        
    }
}
