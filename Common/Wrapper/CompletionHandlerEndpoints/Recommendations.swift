//
//  Recommendations.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 11/14/15.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import Foundation

extension TraktManager {
    
    // MARK: - Public
    
    /**
     Personalized movie recommendations for a user. Results returned with the top recommendation first. By default, `10` results are returned. You can send a limit to get up to `100` results per page.
     
     🔒 OAuth: Required
     ✨ Extended Info
     */
    @discardableResult
    public func getRecommendedMovies(pagination: Pagination? = nil, completion: @escaping ObjectCompletionHandler<[TraktMovie]>) -> URLSessionDataTask? {
        return getRecommendations(.Movies, pagination: pagination, completion: completion)
    }
    
    /**
     Hide a movie from getting recommended anymore.
     
     🔒 OAuth: Required
     */
    @discardableResult
    public func hideRecommendedMovie<T: CustomStringConvertible>(movieID id: T, completion: @escaping SuccessCompletionHandler) -> URLSessionDataTask? {
        return hideRecommendation(type: .Movies, id: id, completion: completion)
    }
    
    /**
     Personalized show recommendations for a user. Results returned with the top recommendation first.
     
     🔒 OAuth: Required
     */
    @discardableResult
    public func getRecommendedShows(pagination: Pagination? = nil, completion: @escaping ObjectCompletionHandler<[TraktShow]>) -> URLSessionDataTask? {
        return getRecommendations(.Shows, pagination: pagination, completion: completion)
    }
    
    /**
     Hide a show from getting recommended anymore.
     
     🔒 OAuth: Required
     */
    @discardableResult
    public func hideRecommendedShow<T: CustomStringConvertible>(showID id: T, completion: @escaping SuccessCompletionHandler) -> URLSessionDataTask? {
        return hideRecommendation(type: .Shows, id: id, completion: completion)
    }
    
    // MARK: - Private
    
    @discardableResult
    private func getRecommendations<T>(_ type: WatchedType, pagination: Pagination? = nil, completion: @escaping ObjectCompletionHandler<[T]>) -> URLSessionDataTask? {
        var query: [String: String] = [:]
        if let pagination = pagination {
            for (key, value) in pagination.value() {
                query[key] = value
            }
        }
        guard let request = try? mutableRequest(forPath: "recommendations/\(type)",
                                               withQuery: query,
                                               isAuthorized: true,
                                               withHTTPMethod: .GET) else {
            completion(.error(error: nil))
            return nil
        }
        return performRequest(request: request,
                              completion: completion)
    }
    
    @discardableResult
    private func hideRecommendation<T: CustomStringConvertible>(type: WatchedType, id: T, completion: @escaping SuccessCompletionHandler) -> URLSessionDataTask? {
        guard let request = try? mutableRequest(forPath: "recommendations/\(type)/\(id)",
            withQuery: [:],
            isAuthorized: true,
            withHTTPMethod: .DELETE) else {
                completion(.fail)
                return nil
        }
        return performRequest(request: request,
                              completion: completion)
    }
}

