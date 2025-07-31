//
//  LanguageResource.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 3/8/25.
//

import Foundation

extension TraktManager {
    /// Endpoints for languages
    public struct LanguageResource {
        private let traktManager: TraktManager
        private let path: String = "languages"

        internal init(traktManager: TraktManager) {
            self.traktManager = traktManager
        }

        /**
         Get a list of all languages, including names and slugs.
         */
        public func listLanguages(type: WatchedType) -> Route<[Languages]> {
            Route(
                paths: [path, "\(type)"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }
    }
}