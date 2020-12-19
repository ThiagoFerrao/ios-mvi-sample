import Foundation

struct HomeCategoriesModel: Decodable {
    let categories: [HomeCategoryModel]
}

struct HomeCategoryModel: Decodable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case categories
    }

    enum CategoryKeys: String, CodingKey {
        case id
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let category = try container.nestedContainer(keyedBy: CategoryKeys.self, forKey: .categories)

        self.id = try category.decode(Int.self, forKey: .id)
        self.name = try category.decode(String.self, forKey: .name)
    }
}
