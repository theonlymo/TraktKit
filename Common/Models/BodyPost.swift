//
//  BodyPost.swift
//  TraktKitTests
//
//  Created by Maximilian Litteral on 11/7/20.
//  Copyright © 2020 Maximilian Litteral. All rights reserved.
//

import Foundation

/// Body data for endpoints like `/sync/history` that contains Trakt Ids.
struct TraktMediaBody<ID: EncodableTraktObject>: EncodableTraktObject {
    let movies: [ID]?
    let shows: [ID]?
    let seasons: [ID]?
    let episodes: [ID]?
    let ids: [Int]?
    /// Cast and crew, not users
    let people: [ID]?
    let users: [ID]?

    init(
        movies: [ID]? = nil,
        shows: [ID]? = nil,
        seasons: [ID]? = nil,
        episodes: [ID]? = nil,
        ids: [Int]? = nil,
        people: [ID]? = nil,
        users: [ID]? = nil
    ) {
        self.movies = movies
        self.shows = shows
        self.seasons = seasons
        self.episodes = episodes
        self.ids = ids
        self.people = people
        self.users = users
    }
}

/// Data for containing a single object
class TraktSingleObjectBody<ID: Encodable>: Encodable {
    let movie: ID?
    let show: ID?
    let season: ID?
    let episode: ID?
    let list: ID?
    
    init(movie: ID? = nil, show: ID? = nil, season: ID? = nil, episode: ID? = nil, list: ID? = nil) {
        self.movie = movie
        self.show = show
        self.season = season
        self.episode = episode
        self.list = list
    }
}

class TraktCommentBody: TraktSingleObjectBody<SyncId> {
    let comment: String
    let spoiler: Bool?
    
    init(movie: SyncId? = nil, show: SyncId? = nil, season: SyncId? = nil, episode: SyncId? = nil, list: SyncId? = nil, comment: String, spoiler: Bool?) {
        self.comment = comment
        self.spoiler = spoiler
        super.init(movie: movie, show: show, season: season, episode: episode, list: list)
    }
}

/**
 Trakt or Slug ID to send to Trakt in POST requests related to media objects and users.
 */
public struct SyncId: TraktObject {
    /// Trakt id of the movie / show / season / episode
    public let trakt: Int?
    /// Slug id for movie / show / season / episode / user
    public let slug: String?

    /// TMDB id of the movie / show / season / episode
    public let tmdb: Int?

    public let imdb: String?

    enum CodingKeys: String, CodingKey {
        case ids
    }
    
    enum IDCodingKeys: String, CodingKey {
        case trakt
        case slug
        case tmdb = "tmdb"
        case imdb = "imdb"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nested = container.nestedContainer(keyedBy: IDCodingKeys.self, forKey: .ids)
        try nested.encodeIfPresent(trakt, forKey: .trakt)
        try nested.encodeIfPresent(slug, forKey: .slug)
        try nested.encodeIfPresent(tmdb, forKey: .tmdb)
        try nested.encodeIfPresent(imdb, forKey: .imdb)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: IDCodingKeys.self, forKey: .ids)
        self.trakt = try nested.decodeIfPresent(Int.self, forKey: .trakt)
        self.slug = try nested.decodeIfPresent(String.self, forKey: .slug)
        self.tmdb = try nested.decodeIfPresent(Int.self, forKey: .tmdb)
        self.imdb = try nested.decodeIfPresent(String.self, forKey: .tmdb)
    }
    
    public init(trakt: Int? = nil, slug: String? = nil, tmdb: Int? = nil, imdb: String? = nil) {
        self.trakt = trakt
        self.slug = slug
        self.tmdb = tmdb
        self.imdb = imdb
    }
}

public struct AddToHistoryId: EncodableTraktObject {
    /// Trakt id of the movie / show / season / episode
    public let id: SyncId
    /// UTC datetime when the item was watched.
    public let watchedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case ids, watchedAt = "watched_at"
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .ids)
        try container.encodeIfPresent(watchedAt, forKey: .watchedAt)
    }
    
    public init(id: SyncId, watchedAt: Date?) {
        self.id = id
        self.watchedAt = watchedAt
    }
}

public struct RatingId: EncodableTraktObject {
    /// Trakt id of the movie / show / season / episode
    public let trakt: Int
    /// Between 1 and 10.
    public let rating: Int
    /// UTC datetime when the item was rated.
    public let ratedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case ids, rating, ratedAt = "rated_at"
    }
    
    enum IDCodingKeys: String, CodingKey {
        case trakt
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nested = container.nestedContainer(keyedBy: IDCodingKeys.self, forKey: .ids)
        try nested.encode(trakt, forKey: .trakt)
        try container.encode(rating, forKey: .rating)
        try container.encodeIfPresent(ratedAt, forKey: .ratedAt)
    }
    
    public init(trakt: Int, rating: Int, ratedAt: Date?) {
        self.trakt = trakt
        self.rating = rating
        self.ratedAt = ratedAt
    }
}

public struct CollectionId: EncodableTraktObject {
    /// Trakt id of the movie / show / season / episode
    public let trakt: Int
    /// UTC datetime when the item was collected. Set to `released` to automatically use the inital release date.
    public let collectedAt: Date
    public let mediaType: TraktCollectedItem.MediaType?
    public let resolution: TraktCollectedItem.Resolution?
    public let hdr: TraktCollectedItem.HDR?
    public let audio: TraktCollectedItem.Audio?
    public let audioChannels: TraktCollectedItem.AudioChannels?
    /// Set true if in 3D.
    public let is3D: Bool?
    
    enum CodingKeys: String, CodingKey {
        case ids
        case collectedAt = "collected_at"
        case mediaType = "media_type"
        case resolution
        case hdr
        case audio
        case audioChannels = "audio_channels"
        case is3D = "3d"
    }
    
    enum IDCodingKeys: String, CodingKey {
        case trakt
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nested = container.nestedContainer(keyedBy: IDCodingKeys.self, forKey: .ids)
        try nested.encode(trakt, forKey: .trakt)
        try container.encode(collectedAt, forKey: .collectedAt)
        try container.encodeIfPresent(mediaType, forKey: .mediaType)
        try container.encodeIfPresent(resolution, forKey: .resolution)
        try container.encodeIfPresent(hdr, forKey: .hdr)
        try container.encodeIfPresent(audio, forKey: .audio)
        try container.encodeIfPresent(audioChannels, forKey: .audioChannels)
        try container.encodeIfPresent(is3D, forKey: .is3D)
    }
    
    public init(trakt: Int, collectedAt: Date, mediaType: TraktCollectedItem.MediaType? = nil, resolution: TraktCollectedItem.Resolution? = nil, hdr: TraktCollectedItem.HDR? = nil, audio: TraktCollectedItem.Audio? = nil, audioChannels: TraktCollectedItem.AudioChannels? = nil, is3D: Bool? = nil) {
        self.trakt = trakt
        self.collectedAt = collectedAt
        self.mediaType = mediaType
        self.resolution = resolution
        self.hdr = hdr
        self.audio = audio
        self.audioChannels = audioChannels
        self.is3D = is3D
    }
}

// MARK: - HistoryShow
public struct AddToHistoryShow: TraktObject {
  
    public let ids: AddToHistoryIDS
    public let seasons: [AddToHistorySeason]

    enum CodingKeys: String, CodingKey {
        case ids = "ids"
        case seasons
    }
    
    public init(ids: AddToHistoryIDS, seasons: [AddToHistorySeason]) {
        self.ids = ids
        self.seasons = seasons
    }
    
}

// MARK: - IDS
public struct AddToHistoryIDS: TraktObject {
   
    public let tmdb: Int

    enum CodingKeys: String, CodingKey {
        case tmdb
    }
    public init(tmdb: Int) {
        self.tmdb = tmdb
    }
    
}

// MARK: - Season
public struct AddToHistorySeason: TraktObject {
    
    public let number: Int
    public let episodes: [AddToHistoryEpisode]

    enum CodingKeys: String, CodingKey {
        case number
        case episodes
    }
    public init(number: Int, episodes: [AddToHistoryEpisode]) {
        self.number = number
        self.episodes = episodes
    }
    
}

// MARK: - Episode
public struct AddToHistoryEpisode: TraktObject {
    public init(watchedAt: Date? = nil, number: Int) {
        self.watchedAt = watchedAt
        self.number = number
    }
    
    let watchedAt: Date?
    let number: Int

    enum CodingKeys: String, CodingKey {
        case watchedAt
        case number
    }
}
