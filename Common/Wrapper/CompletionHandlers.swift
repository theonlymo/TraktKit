//
//  CompletionHandlers.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 10/29/16.
//  Copyright © 2016 Maximilian Litteral. All rights reserved.
//

import Foundation

/// Generic result type
public enum ObjectResultType<T: TraktObject>: Sendable {
    case success(object: T)
    case error(error: Error?)
}

/// Generic results type + Pagination
public enum ObjectsResultTypePagination<T: TraktObject>: Sendable {
    case success(objects: [T], currentPage: Int, limit: Int)
    case error(error: Error?)
}

extension TraktManager {
    
    // MARK: - Result Types
    
    public enum DataResultType: Sendable {
        case success(data: Data)
        case error(error: Error?)
    }
    
    public enum SuccessResultType: Sendable {
        case success
        case fail
    }

    public enum TraktError: LocalizedError, Equatable {
        /// 204. Some methods will succeed but not return any content. The network manager doesn't handle this well at the moment as it wants to decode the data when it is empty. Instead I'll throw this error so that it can be ignored for now.
        case noContent

        /// Bad Request (400) - request couldn't be parsed
        case badRequest
        /// Oauth must be provided (401)
        case unauthorized
        /// Forbidden - invalid API key or unapproved app (403)
        case forbidden
        /// Not Found - method exists, but no record found (404)
        case noRecordFound
        /// Method Not Found - method doesn't exist (405)
        case noMethodFound
        /// Conflict - resource already created (409)
        case resourceAlreadyCreated
        /// Precondition Failed - use application/json content type (412)
        case preconditionFailed
        /// Account Limit Exceeded - list count, item count, etc (420)
        case accountLimitExceeded
        /// Unprocessable Entity - validation errors (422)
        case unprocessableEntity
        /// Locked User Account - have the user contact support (423)
        case accountLocked
        /// VIP Only - user must upgrade to VIP (426)
        case vipOnly
        /// Rate Limit Exceede (429)
        case retry(after: TimeInterval)
        /// Rate Limit Exceeded, retry interval not available (429)
        case rateLimitExceeded(HTTPURLResponse)
        /// Server Error - please open a support ticket (500)
        case serverError
        /// Service Unavailable - server overloaded (try again in 30s) (502 / 503 / 504)
        case serverOverloaded
        /// Service Unavailable - Cloudflare error (520 / 521 / 522)
        case cloudflareError
        /// Full url response
        case unhandled(URLResponse)

        public var errorDescription: String? {
            switch self {
            case .noContent:
                nil
            case .badRequest:
                "Request could not be parsed."
            case .unauthorized:
                "Unauthorized. Please sign in with Trakt."
            case .forbidden:
                "Forbidden. Invalid API key or unapproved app."
            case .noRecordFound:
                "No record found."
            case .noMethodFound:
                "Method not found."
            case .resourceAlreadyCreated:
                "Resource has already been created."
            case .preconditionFailed:
                "Invalid content type."
            case .accountLimitExceeded:
                "The number of Trakt lists or list items has been exceeded. Please see Trakt.tv for account limits and support."
            case .unprocessableEntity:
                "Invalid entity."
            case .accountLocked:
                "Trakt.tv has indicated that this account is locked. Please contact Trakt support to unlock your account."
            case .vipOnly:
                "This feature is VIP only with Trakt. Please see Trakt.tv for more information."
            case .retry:
                nil
            case .rateLimitExceeded:
                "Rate Limit Exceeded. Please try again in a minute."
            case .serverError, .serverOverloaded, .cloudflareError:
                "Trakt.tv is down. Please try again later."
            case .unhandled(let urlResponse):
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    "Unhandled response. Status code \(httpResponse.statusCode)"
                } else {
                    "Unhandled response. \(urlResponse.description)"
                }
            }
        }
    }
    
    // MARK: - Completion handlers
    
    // MARK: Common
    public typealias ObjectCompletionHandler<T: TraktObject> = @Sendable (_ result: ObjectResultType<T>) -> Void
    public typealias paginatedCompletionHandler<T: TraktObject> = @Sendable (_ result: ObjectsResultTypePagination<T>) -> Void

    public typealias DataResultCompletionHandler = @Sendable (_ result: DataResultType) -> Void
    public typealias SuccessCompletionHandler = @Sendable (_ result: SuccessResultType) -> Void
    public typealias CommentsCompletionHandler = paginatedCompletionHandler<Comment>

    public typealias SearchCompletionHandler = ObjectCompletionHandler<[TraktSearchResult]>
    public typealias statsCompletionHandler = ObjectCompletionHandler<TraktStats>
    
    // MARK: Shared
    public typealias UpdateCompletionHandler = paginatedCompletionHandler<Update>
    public typealias AliasCompletionHandler = ObjectCompletionHandler<[Alias]>
    public typealias RatingDistributionCompletionHandler = ObjectCompletionHandler<RatingDistribution>
    
    // MARK: Calendar
    public typealias dvdReleaseCompletionHandler = ObjectCompletionHandler<[TraktDVDReleaseMovie]>
    
    // MARK: Checkin
    public typealias checkinCompletionHandler = ObjectCompletionHandler<TraktCheckinResponse>

    // MARK: Shows
    public typealias TrendingShowsCompletionHandler = paginatedCompletionHandler<TraktTrendingShow>
    public typealias MostShowsCompletionHandler = paginatedCompletionHandler<TraktMostShow>
    public typealias AnticipatedShowCompletionHandler = paginatedCompletionHandler<TraktAnticipatedShow>
    public typealias ShowTranslationsCompletionHandler = ObjectCompletionHandler<[TraktShowTranslation]>
    public typealias SeasonsCompletionHandler = ObjectCompletionHandler<[TraktSeason]>
    
    public typealias WatchedShowsCompletionHandler = ObjectCompletionHandler<[TraktWatchedShow]>
    public typealias ShowWatchedProgressCompletionHandler = ObjectCompletionHandler<TraktShowWatchedProgress>
    
    // MARK: Episodes
    public typealias EpisodeCompletionHandler = ObjectCompletionHandler<TraktEpisode>
    public typealias EpisodesCompletionHandler = ObjectCompletionHandler<[TraktEpisode]>
    
    // MARK: Movies
    public typealias MovieCompletionHandler = ObjectCompletionHandler<TraktMovie>
    public typealias MoviesCompletionHandler = ObjectCompletionHandler<[TraktMovie]>
    public typealias TrendingMoviesCompletionHandler = paginatedCompletionHandler<TraktTrendingMovie>
    public typealias MostMoviesCompletionHandler = paginatedCompletionHandler<TraktMostMovie>
    public typealias AnticipatedMovieCompletionHandler = paginatedCompletionHandler<TraktAnticipatedMovie>
    public typealias MovieTranslationsCompletionHandler = ObjectCompletionHandler<[TraktMovieTranslation]>
    public typealias WatchedMoviesCompletionHandler = paginatedCompletionHandler<TraktWatchedMovie>
    public typealias BoxOfficeMoviesCompletionHandler = ObjectCompletionHandler<[TraktBoxOfficeMovie]>
    
    // MARK: Sync
    public typealias LastActivitiesCompletionHandler = ObjectCompletionHandler<TraktLastActivities>
    public typealias RatingsCompletionHandler = ObjectCompletionHandler<[TraktRating]>
    public typealias HistoryCompletionHandler = paginatedCompletionHandler<TraktHistoryItem>
    public typealias CollectionCompletionHandler = ObjectCompletionHandler<[TraktCollectedItem]>
    
    // MARK: Users
    public typealias ListCompletionHandler = ObjectCompletionHandler<TraktList>
    public typealias ListsCompletionHandler = ObjectCompletionHandler<[TraktList]>
    public typealias ListItemCompletionHandler = ObjectCompletionHandler<[TraktListItem]>
    public typealias WatchlistCompletionHandler = paginatedCompletionHandler<TraktListItem>
    public typealias HiddenItemsCompletionHandler = paginatedCompletionHandler<HiddenItem>
    public typealias UserCommentsCompletionHandler = ObjectCompletionHandler<[UsersComments]>
    public typealias AddListItemCompletion = ObjectCompletionHandler<ListItemPostResult>
    public typealias RemoveListItemCompletion = ObjectCompletionHandler<RemoveListItemResult>
    public typealias FollowUserCompletion = ObjectCompletionHandler<FollowUserResult>
    public typealias FollowersCompletion = ObjectCompletionHandler<[FollowResult]>
    public typealias FriendsCompletion = ObjectCompletionHandler<[Friend]>
    public typealias WatchingCompletion = ObjectCompletionHandler<TraktWatching>
    public typealias UserStatsCompletion = ObjectCompletionHandler<UserStats>
    public typealias UserWatchedCompletion = ObjectCompletionHandler<[TraktWatchedItem]>
    
    // MARK: - Error handling
    
    private func handleResponse(response: URLResponse?) throws(TraktError) {
        guard let response else { return }
        guard let httpResponse = response as? HTTPURLResponse else { throw .unhandled(response) }

        guard 200...299 ~= httpResponse.statusCode else {
            switch httpResponse.statusCode {
            case 400: throw .badRequest
            case 401: throw .unauthorized
            case 403: throw .forbidden
            case 404: throw .noRecordFound
            case 405: throw .noMethodFound
            case 409: throw .resourceAlreadyCreated
            case 412: throw .preconditionFailed
            case 420: throw .accountLimitExceeded
            case 422: throw .unprocessableEntity
            case 423: throw .accountLocked
            case 426: throw .vipOnly
            case 429:
                let rawRetryAfter = httpResponse.allHeaderFields["retry-after"]
                if let retryAfterString = rawRetryAfter as? String,
                   let retryAfter = TimeInterval(retryAfterString) {
                    throw .retry(after: retryAfter)
                } else if let retryAfter = rawRetryAfter as? TimeInterval {
                    throw .retry(after: retryAfter)
                } else {
                    throw .rateLimitExceeded(httpResponse)
                }
            case 500: throw .serverError
            // Try again in 30 seconds throw
            case 502, 503, 504: throw .serverOverloaded
            case 500...600: throw .cloudflareError
            default:
                throw .unhandled(httpResponse)
            }
        }
    }

    // MARK: - Perform Requests
    
    /// Data
    func performRequest(request: URLRequest, completion: @escaping DataResultCompletionHandler) -> URLSessionDataTask? {
        let datatask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            if let error {
                completion(.error(error: error))
                return
            }
            
            // Check response
            do throws(TraktError) {
                try self.handleResponse(response: response)
            } catch {
                switch error {
                case .retry(let after):
                    DispatchQueue.global().asyncAfter(deadline: .now() + after) { [weak self, completion] in
                        _ = self?.performRequest(request: request, completion: completion)
                    }
                default:
                    completion(.error(error: error))
                }
                return
            }
            
            // Check data
            guard let data = data else {
                completion(.error(error: TraktKitError.couldNotParseData))
                return
            }
            completion(.success(data: data))
        }
        datatask.resume()
        return datatask
    }
    
    /// Success / Failure
    func performRequest(request: URLRequest, completion: @escaping SuccessCompletionHandler) -> URLSessionDataTask? {
        let datatask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            guard error == nil else {
                completion(.fail)
                return
            }
            
            // Check response
            do throws(TraktError) {
                try self.handleResponse(response: response)
            } catch {
                switch error {
                case .retry(let after):
                    DispatchQueue.global().asyncAfter(deadline: .now() + after) { [weak self, completion] in
                        _ = self?.performRequest(request: request, completion: completion)
                    }
                default:
                    completion(.fail)
                }
                return
            }
            
            completion(.success)
        }
        datatask.resume()
        return datatask
    }

    // Generic array of Trakt objects
    func performRequest<T: TraktObject>(request: URLRequest, completion: @escaping ObjectCompletionHandler<T>) -> URLSessionDataTask? {
        let aCompletion: DataResultCompletionHandler = { (result) -> Void in
            switch result {
            case .success(let data):
                guard !data.isEmpty else {
                    completion(.error(error: TraktError.noContent))
                    return
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom(customDateDecodingStrategy)
                do {
                    let object = try decoder.decode(T.self, from: data)
                    completion(.success(object: object))
                } catch {
                    completion(.error(error: error))
                }
            case .error(let error):
                completion(.error(error: error))
            }
        }
        
        let dataTask = performRequest(request: request, completion: aCompletion)
        return dataTask
    }

    /// Array of ObjectsResultTypePagination objects
    func performRequest<T: TraktObject>(request: URLRequest, completion: @escaping paginatedCompletionHandler<T>) -> URLSessionDataTask? {
        let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            if let error {
                completion(.error(error: error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else { return completion(.error(error: nil)) }
            
            // Check response
            do throws(TraktError) {
                try self.handleResponse(response: response)
            } catch {
                switch error {
                case .retry(let after):
                    DispatchQueue.global().asyncAfter(deadline: .now() + after) { [weak self, completion] in
                        _ = self?.performRequest(request: request, completion: completion)
                    }
                default:
                    completion(.error(error: error))
                }
                return
            }
            
            var pageCount: Int = 0
            if let pCount = httpResponse.allHeaderFields["x-pagination-page-count"] as? String,
                let pCountInt = Int(pCount) {
                pageCount = pCountInt
            }
            
            var currentPage: Int = 0
            if let cPage = httpResponse.allHeaderFields["x-pagination-page"] as? String,
                let cPageInt = Int(cPage) {
                currentPage = cPageInt
            }
            
            // Check data
            guard let data = data else {
                completion(.error(error: TraktKitError.couldNotParseData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom(customDateDecodingStrategy)
            do {
                let array = try decoder.decode([T].self, from: data)
                completion(.success(objects: array, currentPage: currentPage, limit: pageCount))
            } catch {
                completion(.error(error: error))
            }
        }
        
        dataTask.resume()
        return dataTask
    }

    // MARK: - Async await

    /**
     Downloads the contents of a URL based on the specified URL request. Handles ``TraktError/retry(after:)`` up to the specified `retryLimit`
     */
    func fetchData(request: URLRequest, retryLimit: Int = 3) async throws -> (Data, URLResponse) {
        var retryCount = 0

        while true {
            do {
                let (data, response) = try await session.data(for: request)
                try handleResponse(response: response)
                return (data, response)
            } catch let error as TraktError {
                switch error {
                case .retry(let retryDelay):
                    retryCount += 1
                    if retryCount >= retryLimit {
                        throw error
                    }
                    print("Retrying after delay: \(retryDelay)")
                    try await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
                    try Task.checkCancellation()
                default:
                    throw error
                }
            } catch {
                throw error
            }
        }
    }

    /**
     Downloads the contents of a URL based on the specified URL request, and decodes the data into a `TraktObject`
     */
    func perform<T: TraktObject>(request: URLRequest, retryLimit: Int = 3) async throws -> T {
        let (data, response) = try await fetchData(request: request, retryLimit: retryLimit)
        return try decodeTraktObject(from: data, response: response)
    }

    /// Decodes data into a TraktObject. If the `TraktObject` type is `PagedObject` the headers will be extracted from the response.
    private func decodeTraktObject<T: TraktObject>(from data: Data, response: URLResponse) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(customDateDecodingStrategy)

        if let pagedType = T.self as? PagedObjectProtocol.Type {
            let decodedItems = try decoder.decode(pagedType.objectType, from: data)
            var currentPage = 0
            var pageCount = 0
            if let r = response as? HTTPURLResponse {
                currentPage = Int(r.value(forHTTPHeaderField: "x-pagination-page") ?? "0") ?? 0
                pageCount = Int(r.value(forHTTPHeaderField: "x-pagination-page-count") ?? "0") ?? 0
            }
            return pagedType.createPagedObject(with: decodedItems, currentPage: currentPage, pageCount: pageCount) as! T
        }

        return try decoder.decode(T.self, from: data)
    }
}
