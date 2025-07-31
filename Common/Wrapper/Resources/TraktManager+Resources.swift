//
//  TraktManager+Resources.swift
//  TraktKit
//
//  Created by Maxamilian Litteral on 6/14/21.
//  Copyright © 2021 Maximilian Litteral. All rights reserved.
//

import Foundation

extension TraktManager {
    // MARK: - Recommendations

    public func recommendations() -> RecommendationResource {
        RecommendationResource(traktManager: self)
    }

    
    // MARK: - Authentication

    public func auth() -> AuthenticationResource {
        AuthenticationResource(traktManager: self)
    }

    // MARK: - Checkin

    public func checkin() -> CheckinResource {
        CheckinResource(traktManager: self)
    }

    // MARK: - Search

    public func search() -> SearchResource {
        SearchResource(traktManager: self)
    }

    // MARK: - Movies

    public var movies: MoviesResource {
        MoviesResource(traktManager: self)
    }

    /// - parameter id: Trakt ID, Trakt slug, or IMDB ID
    public func movie(id: CustomStringConvertible) -> MovieResource {
        MovieResource(id: id, traktManager: self)
    }

    // MARK: - TV

    public var shows: ShowsResource {
        ShowsResource(traktManager: self)
    }

    /// - parameter id: Trakt ID, Trakt slug, or IMDB ID
    public func show(id: CustomStringConvertible) -> ShowResource {
        ShowResource(id: id, traktManager: self)
    }

    public func season(showId: CustomStringConvertible, season: Int) -> SeasonResource {
        SeasonResource(showId: showId, seasonNumber: season, traktManager: self)
    }
    
    public func episode(showId: CustomStringConvertible, season: Int, episode: Int) -> EpisodeResource {
        EpisodeResource(showId: showId, seasonNumber: season, episodeNumber: episode, traktManager: self)
    }

    public func sync() -> SyncResource {
        SyncResource(traktManager: self)
    }

    // MARK: - User

    public func currentUser() -> CurrentUserResource {
        CurrentUserResource(traktManager: self)
    }
    
    public func user(_ slug: String) -> UsersResource {
        UsersResource(slug: slug, traktManager: self)
    }
    
    
    //Mark: - scrobble
    
    public func scrobble() -> ScrobbleResource {
        ScrobbleResource(traktManager: self)
    }
    
    // MARK: - Calendar
    
    public func calendar() -> CalendarResource {
        CalendarResource(traktManager: self)
    }
    
    // MARK: - Certification
    
    public func certification() -> CertificationResource {
        CertificationResource(traktManager: self)
    }
    
    // MARK: - Comment
    
    public func comment() -> CommentResource {
        CommentResource(traktManager: self)
    }
    
    // MARK: - Genre
    
    public func genre() -> GenreResource {
        GenreResource(traktManager: self)
    }
    
    // MARK: - Language
    
    public func language() -> LanguageResource {
        LanguageResource(traktManager: self)
    }
    
    // MARK: - List
    
    public func list() -> ListResource {
        ListResource(traktManager: self)
    }
    
    // MARK: - People
    
    public func people() -> PeopleResource {
        PeopleResource(traktManager: self)
    }
}
