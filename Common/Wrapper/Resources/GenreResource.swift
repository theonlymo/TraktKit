//
//  GenreResource.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 3/8/25.
//

import Foundation

extension TraktManager {
    /// Endpoints for genres
    public struct GenreResource {
        private let traktManager: TraktManager
        private let path: String = "genres"

        internal init(traktManager: TraktManager) {
            self.traktManager = traktManager
        }

        /**
         Get a list of all genres, including names and slugs.
         */
        public func listGenres(type: WatchedType) -> Route<[Genres]> {
            Route(
                paths: [path, "\(type)"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }
    }
}