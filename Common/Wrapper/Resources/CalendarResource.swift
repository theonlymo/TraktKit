//
//  CalendarResource.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 3/8/25.
//

import Foundation

extension TraktManager {
    /// Endpoints for calendar data
    public struct CalendarResource {
        private let traktManager: TraktManager
        private let path: String = "calendars"

        internal init(traktManager: TraktManager) {
            self.traktManager = traktManager
        }

        // MARK: - My Calendar

        /**
         Returns all shows airing during the time period specified.
         
         🔒 OAuth: Required
         
         - parameter startDateString: Start the calendar on this date. E.X. `2014-09-01`
         - parameter days: Number of days to display. Example: `7`.
         */
        public func myShows(startDateString: String, days: Int) -> Route<[CalendarShow]> {
            Route(
                paths: [path, "my", "shows", startDateString, "\(days)"],
                method: .GET,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        /**
         Returns all new show premieres (season 1, episode 1) airing during the time period specified.
         
         🔒 OAuth: Required
         
         - parameter startDateString: Start the calendar on this date. E.X. `2014-09-01`
         - parameter days: Number of days to display. Example: `7`.
         */
        public func myNewShows(startDateString: String, days: Int) -> Route<[CalendarShow]> {
            Route(
                paths: [path, "my", "shows", "new", startDateString, "\(days)"],
                method: .GET,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        /**
         Returns all show premieres (any season, episode 1) airing during the time period specified.
         
         🔒 OAuth: Required
         
         - parameter startDateString: Start the calendar on this date. E.X. `2014-09-01`
         - parameter days: Number of days to display. Example: `7`.
         */
        public func mySeasonPremieres(startDateString: String, days: Int) -> Route<[CalendarShow]> {
            Route(
                paths: [path, "my", "shows", "premieres", startDateString, "\(days)"],
                method: .GET,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        /**
         Returns all movies with a release date during the time period specified.
         
         🔒 OAuth: Required
         
         - parameter startDateString: Start the calendar on this date. E.X. `2014-09-01`
         - parameter days: Number of days to display. Example: `7`.
         */
        public func myMovies(startDateString: String, days: Int) -> Route<[CalendarMovie]> {
            Route(
                paths: [path, "my", "movies", startDateString, "\(days)"],
                method: .GET,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        /**
         Returns all movies with a DVD release date during the time period specified.
         
         🔒 OAuth: Required
         ✨ Extended Info
         🎚 Filters
         */
        public func myDVDReleases(startDateString: String, days: Int) -> Route<[CalendarMovie]> {
            Route(
                paths: [path, "my", "dvd", startDateString, "\(days)"],
                method: .GET,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        // MARK: - All Calendar

        /**
         Returns all shows airing during the time period specified.
         
         - parameter startDateString: Start the calendar on this date. E.X. `2014-09-01`
         - parameter days: Number of days to display. Example: `7`.
         */
        public func allShows(startDateString: String, days: Int) -> Route<[CalendarShow]> {
            Route(
                paths: [path, "all", "shows", startDateString, "\(days)"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        /**
         Returns all new show premieres (season 1, episode 1) airing during the time period specified.
         
         - parameter startDateString: Start the calendar on this date. E.X. `2014-09-01`
         - parameter days: Number of days to display. Example: `7`.
         */
        public func allNewShows(startDateString: String, days: Int) -> Route<[CalendarShow]> {
            Route(
                paths: [path, "all", "shows", "new", startDateString, "\(days)"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        /**
         Returns all show premieres (any season, episode 1) airing during the time period specified.
         
         - parameter startDateString: Start the calendar on this date. E.X. `2014-09-01`
         - parameter days: Number of days to display. Example: `7`.
         */
        public func allSeasonPremieres(startDateString: String, days: Int) -> Route<[CalendarShow]> {
            Route(
                paths: [path, "all", "shows", "premieres", startDateString, "\(days)"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        /**
         Returns all movies with a release date during the time period specified.
         
         - parameter startDateString: Start the calendar on this date. E.X. `2014-09-01`
         - parameter days: Number of days to display. Example: `7`.
         */
        public func allMovies(startDateString: String, days: Int, extended: [ExtendedType] = [.Min], filters: [Filter]? = nil) -> Route<[CalendarMovie]> {
            var query: [String: String] = ["extended": extended.queryString()]
            
            // Filters
            if let filters = filters {
                for (key, value) in (filters.map { $0.value() }) {
                    query[key] = value
                }
            }

            return Route(
                paths: [path, "all", "movies", startDateString, "\(days)"],
                queryItems: query,
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        /**
         Returns all movies with a DVD release date during the time period specified.
         
         - parameter startDateString: Start the calendar on this date. E.X. `2014-09-01`
         - parameter days: Number of days to display. Example: `7`.
         */
        public func allDVD(startDateString: String, days: Int) -> Route<[CalendarMovie]> {
            Route(
                paths: [path, "all", "dvd", startDateString, "\(days)"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }
    }
}