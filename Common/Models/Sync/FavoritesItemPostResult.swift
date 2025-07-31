import Foundation

public struct FavoritesItemPostResult: TraktObject {
    public let added: ObjectCount
    public let existing: ObjectCount
    public let notFound: NotFound
    
    public struct ObjectCount: TraktObject {
        public let movies: Int
        public let shows: Int
    }
    
    public struct NotFound: TraktObject {
        public let movies: [NotFoundIds]
        public let shows: [NotFoundIds]
    }
    

    enum CodingKeys: String, CodingKey {
        case added
        case existing
        case notFound = "not_found"
    }
}
