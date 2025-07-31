//
//  PeopleResource.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 3/8/25.
//

import Foundation

extension TraktManager {
    /// Endpoints for people
    public struct PeopleResource {
        private let traktManager: TraktManager
        private let path: String = "people"

        internal init(traktManager: TraktManager) {
            self.traktManager = traktManager
        }

        // MARK: - Summary

        /**
         Returns a single person's details.
         
         ✨ Extended Info
         */
        public func getPersonDetails<T: CustomStringConvertible>(personID id: T, extended: [ExtendedType] = [.Min]) -> Route<Person> {
            Route(
                paths: [path, "\(id)"],
                queryItems: ["extended": extended.queryString()],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        // MARK: - Movies

        /**
         Returns all movies where this person is in the `cast` or `crew`. Each `cast` object will have a `character` and a standard `movie` object.
         
         The `crew` object will be broken up into `production`, `art`, `crew`, `costume & make-up`, `directing`, `writing`, `sound`, and `camera` (if there are people for those crew positions). Each of those members will have a `job` and a standard `movie` object.
         
         ✨ Extended Info
         */
        public func getMovieCredits<T: CustomStringConvertible>(personID id: T, extended: [ExtendedType] = [.Min]) -> Route<CastAndCrew<PeopleMovieCastMember, PeopleMovieCrewMember>> {
            Route(
                paths: [path, "\(id)", "movies"],
                queryItems: ["extended": extended.queryString()],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        // MARK: - Shows

        /**
         Returns all shows where this person is in the `cast` or `crew`, including the `episode_count` for which they appear. Each `cast` object will have a `characters` array and a standard `show` object. If `series_regular` is `true`, this person is a series regular and not simply a guest star.
         
         The `crew` object will be broken up into `production`, `art`, `crew`, `costume & make-up`, `directing`, `writing`, `sound`, `camera`, `visual effects`, `lighting`, and `editing` (if there are people for those crew positions). Each of those members will have a jobs array and a standard `show` object.
         
         ✨ Extended Info
         */
        public func getShowCredits<T: CustomStringConvertible>(personID id: T, extended: [ExtendedType] = [.Min]) -> Route<CastAndCrew<PeopleTVCastMember, PeopleTVCrewMember>> {
            Route(
                paths: [path, "\(id)", "shows"],
                queryItems: ["extended": extended.queryString()],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        // MARK: - Lists

        /**
         Returns all lists that contain this person. By default, `personal` lists are returned sorted by the most `popular`.

         📄 Pagination
         */
        public func getListsContainingPerson<T: CustomStringConvertible>(personId id: T, listType: ListType? = nil, sortBy: ListSortType? = nil) -> Route<[TraktList]> {
            var pathComponents = [path, "\(id)", "lists"]
            
            if let listType = listType {
                pathComponents.append("\(listType)")
                
                if let sortBy = sortBy {
                    pathComponents.append("\(sortBy)")
                }
            }

            return Route(
                paths: pathComponents,
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }
    }
}