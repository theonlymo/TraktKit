//
//  CertificationResource.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 3/8/25.
//

import Foundation

extension TraktManager {
    /// Endpoints for certifications
    public struct CertificationResource {
        private let traktManager: TraktManager
        private let path: String = "certifications"

        internal init(traktManager: TraktManager) {
            self.traktManager = traktManager
        }

        /**
         Most TV shows and movies have a certification to indicate the content rating. Some API methods allow filtering by certification, so it's good to cache this list in your app.

         Note: Only `us` certifications are currently returned.
         */
        public func getCertifications() -> Route<Certifications> {
            Route(
                path: path,
                method: .GET,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }
    }
}