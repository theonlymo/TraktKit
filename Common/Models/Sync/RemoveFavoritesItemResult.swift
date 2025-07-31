
import Foundation

public struct RemoveFavoritesItemResult: TraktObject {
    public let deleted: Deleted
    public let notFound: NotFound

    public struct Deleted: TraktObject {
        public let movies: Int
        public let shows: Int
    }
    
    public struct NotFound: TraktObject {
        public let movies: [NotFoundIds]
        public let shows: [NotFoundIds]
    }
    
    enum CodingKeys: String, CodingKey {
        case deleted
        case notFound = "not_found"
    }
}
