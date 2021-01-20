import Foundation

struct HomeRestaurantsModel: Decodable {
    let restaurants: [HomeRestaurantModel]
}

struct HomeRestaurantModel: Equatable, Decodable {
    let id: String
    let name: String
    let address: String
    let cuisines: String
    let timings: String
}

extension HomeRestaurantModel {
    enum CodingKeys: String, CodingKey {
        case restaurant
    }

    enum RestaurantKeys: String, CodingKey {
        case id
        case name
        case location
        case cuisines
        case timings
    }

    enum LocationKeys: String, CodingKey {
        case address
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let restaurant = try container.nestedContainer(keyedBy: RestaurantKeys.self, forKey: .restaurant)
        let location = try restaurant.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)

        self.id = try restaurant.decode(String.self, forKey: .id)
        self.name = try restaurant.decode(String.self, forKey: .name)
        self.address = try location.decode(String.self, forKey: .address)
        self.cuisines = try restaurant.decode(String.self, forKey: .cuisines)
        self.timings = try restaurant.decode(String.self, forKey: .timings)
    }
}
