import UIKit

final class CityDetailDestination: Destinating {
    
    let city: City
    
    init(city: City) {
        self.city = city
    }
    
    var view: UIViewController {
        return CityDetailViewController(city: city)
    }
}

final class PlaceDestination: Destinating {
    let place: Place
    
    init(place: Place) {
        self.place = place
    }
    
    var view: UIViewController {
        return PlaceViewController(place: place)
    }
}
