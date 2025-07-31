import Foundation

extension TraktManager {
    public struct RecommendationResource {
        private let traktManager: TraktManager

        internal init(traktManager: TraktManager) {
            self.traktManager = traktManager
        }

        // MARK: - Endpoints

        public func recommendedMovies(pagination: Pagination? = nil) -> Route<PagedObject<[TraktMovie]>> {
            var query: [String: String] = [:]
            if let pagination = pagination {
                for (key, value) in pagination.value() {
                    query[key] = value
                }
            }
            return Route<PagedObject<[TraktMovie]>>(
                path: "recommendations/movies",
                queryItems: query,
                method: .GET,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        public func recommendedShows(pagination: Pagination? = nil) -> Route<PagedObject<[TraktShow]>> {
            var query: [String: String] = [:]
            if let pagination = pagination {
                for (key, value) in pagination.value() {
                    query[key] = value
                }
            }
            return Route<PagedObject<[TraktShow]>>(
                path: "recommendations/shows",
                queryItems: query,
                method: .GET,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        public func hideRecommendedMovie<T: CustomStringConvertible>(id: T) -> EmptyRoute {
            EmptyRoute(
                paths: ["recommendations", "movies", "\(id)"],
                method: .DELETE,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        public func hideRecommendedShow<T: CustomStringConvertible>(id: T) -> EmptyRoute {
            EmptyRoute(
                paths: ["recommendations", "shows", "\(id)"],
                method: .DELETE,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }
    }
}
