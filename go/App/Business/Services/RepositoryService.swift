import MapKit
import Foundation

fileprivate let UDRouteKey = "route"

/// Реализация хранилища данных на основе UserDefaults
final class RepositoryService {
    
    // MARK: - Fields
    
    private lazy var elements: [MKMapItem] = {
        
        guard let array = UserDefaults.standard.array(forKey: UDRouteKey) else {
            return [MKMapItem]()
        }
        
        return array as! [MKMapItem]
    }()
    
    
    // MARK: - Functions
    
    func read() -> [MKMapItem] {
        return elements
    }
    
    func create(element: MKMapItem) {
        elements.append(element)
        save()
    }
    
    func update(element: MKMapItem) -> Bool {
        // TODO: Реализовать обновление элемента в хранилище
        return true
    }
    
    func delete(element: MKMapItem) -> Bool {
        
        if let index = elements.firstIndex(where: { $0 == element }) {
            
            elements.remove(at: index)
            save()
            
            return true
        }
        
        return false
    }
    
    fileprivate func save() {
        
        UserDefaults.standard.set(elements, forKey: UDRouteKey)
    }
}
