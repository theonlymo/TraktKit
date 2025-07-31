//
//  ListResource.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 3/8/25.
//

import Foundation

extension TraktManager {
    /// Endpoints for lists
    public struct ListResource {
        private let traktManager: TraktManager
        private let path: String = "lists"

        internal init(traktManager: TraktManager) {
            self.traktManager = traktManager
        }

        /**
         Returns all lists with the most likes and comments over the last 7 days.

         📄 Pagination
         */
        public func getTrendingLists() -> Route<[TraktTrendingList]> {
            Route(
                paths: [path, "trending"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        /**
         Returns the most popular lists. Popularity is calculated using total number of likes and comments.

         📄 Pagination
         */
        public func getPopularLists() -> Route<[TraktTrendingList]> {
            Route(
                paths: [path, "popular"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }
    }
}