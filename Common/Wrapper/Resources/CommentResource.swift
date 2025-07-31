//
//  CommentResource.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 3/8/25.
//

import Foundation

extension TraktManager {
    /// Endpoints for comments
    public struct CommentResource {
        private let traktManager: TraktManager
        private let path: String = "comments"

        internal init(traktManager: TraktManager) {
            self.traktManager = traktManager
        }

        // MARK: - Comments

        /**
         Add a new comment to a movie, show, season, episode, or list. Make sure to allow and encourage spoilers to be indicated in your app and follow the rules listed above.
         
         🔒 OAuth: Required
         */
        public func postComment(comment: Comment) -> Route<Comment> {
            Route(
                path: path,
                body: comment,
                method: .POST,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        /**
         Returns a single comment and indicates how many replies it has. Use GET /comments/:id/replies to get the actual replies.
         
         🔓 OAuth: Optional
         😁 Emojis
         */
        public func getComment<T: CustomStringConvertible>(commentID id: T) -> Route<Comment> {
            Route(
                paths: [path, "\(id)"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        /**
         Update a single comment created within the last hour. The OAuth user must match the author of the comment in order to update it.
         
         🔒 OAuth: Required
         😁 Emojis
         */
        public func updateComment<T: CustomStringConvertible>(commentID id: T, comment: Comment) -> Route<Comment> {
            Route(
                paths: [path, "\(id)"],
                body: comment,
                method: .PUT,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        /**
         Delete a single comment created within the last hour. The OAuth user must match the author of the comment in order to delete it.
         
         🔒 OAuth: Required
         */
        public func deleteComment<T: CustomStringConvertible>(commentID id: T) -> EmptyRoute {
            EmptyRoute(
                paths: [path, "\(id)"],
                method: .DELETE,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        /**
         Returns all replies for a comment. It is possible these replies could have replies themselves, so in that case you would just call GET /comments/:id/replies again with the new comment id.
         
         📄 Pagination
         🔓 OAuth: Optional
         😁 Emojis
         */
        public func getReplies<T: CustomStringConvertible>(commentID id: T) -> Route<[Comment]> {
            Route(
                paths: [path, "\(id)", "replies"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        /**
         Add a new reply to an existing comment. Make sure to allow and encourage spoilers to be indicated in your app.
         
         🔒 OAuth: Required
         😁 Emojis
         */
        public func postReply<T: CustomStringConvertible>(commentID id: T, comment: Comment) -> Route<Comment> {
            Route(
                paths: [path, "\(id)", "replies"],
                body: comment,
                method: .POST,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        /**
         Returns all users who liked a comment.
         
         📄 Pagination
         */
        public func getUsersWhoLikedComment<T: CustomStringConvertible>(commentID id: T) -> Route<[TraktCommentLikedUser]> {
            Route(
                paths: [path, "\(id)", "likes"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        /**
         Votes help determine popular comments. Only one like is allowed per comment per user.
         
         🔒 OAuth: Required
         */
        public func likeComment<T: CustomStringConvertible>(commentID id: T) -> EmptyRoute {
            EmptyRoute(
                paths: [path, "\(id)", "like"],
                method: .POST,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        /**
         Remove a like on a comment.
         
         🔒 OAuth: Required
         */
        public func removeLikeOnComment<T: CustomStringConvertible>(commentID id: T) -> EmptyRoute {
            EmptyRoute(
                paths: [path, "\(id)", "like"],
                method: .DELETE,
                requiresAuthentication: true,
                traktManager: traktManager
            )
        }

        /**
         Returns the most recently written comments across all of Trakt. You can optionally filter by the comment_type and media type to limit what gets returned. If you want to `include_replies` that will return replies in place alongside top level comments.
         
         📄 Pagination
         🔓 OAuth: Optional
         😁 Emojis
         */
        public func getRecentlyCreatedComments(commentType: CommentType? = nil, objectType: WatchedType? = nil, includeReplies: Bool? = nil) -> Route<[Comment]> {
            var query: [String: String] = [:]
            
            if let commentType = commentType {
                query["comment_type"] = "\(commentType)"
            }
            if let objectType = objectType {
                query["type"] = "\(objectType)"
            }
            if let includeReplies = includeReplies {
                query["include_replies"] = "\(includeReplies)"
            }

            return Route(
                paths: [path, "recent"],
                queryItems: query,
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        /**
         Returns the most recently updated comments across all of Trakt. You can optionally filter by the comment_type and media type to limit what gets returned. If you want to `include_replies` that will return replies in place alongside top level comments.
         
         📄 Pagination
         🔓 OAuth: Optional
         😁 Emojis
         */
        public func getRecentlyUpdatedComments(commentType: CommentType? = nil, objectType: WatchedType? = nil, includeReplies: Bool? = nil) -> Route<[Comment]> {
            var query: [String: String] = [:]
            
            if let commentType = commentType {
                query["comment_type"] = "\(commentType)"
            }
            if let objectType = objectType {
                query["type"] = "\(objectType)"
            }
            if let includeReplies = includeReplies {
                query["include_replies"] = "\(includeReplies)"
            }

            return Route(
                paths: [path, "updates"],
                queryItems: query,
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        /**
         Returns the most trending comments across all of Trakt. Trending comments are based on total likes and replies over the last 7 days. You can optionally filter by the comment_type and media type to limit what gets returned. If you want to `include_replies` that will return replies in place alongside top level comments.
         
         📄 Pagination
         🔓 OAuth: Optional
         😁 Emojis
         */
        public func getTrendingComments(commentType: CommentType? = nil, objectType: WatchedType? = nil, includeReplies: Bool? = nil) -> Route<[TraktTrendingComment]> {
            var query: [String: String] = [:]
            
            if let commentType = commentType {
                query["comment_type"] = "\(commentType)"
            }
            if let objectType = objectType {
                query["type"] = "\(objectType)"
            }
            if let includeReplies = includeReplies {
                query["include_replies"] = "\(includeReplies)"
            }

            return Route(
                paths: [path, "trending"],
                queryItems: query,
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }

        /**
         Returns the attached media item if there is one. The `media_type` indicates what type of media is attached to the comment.
         */
        public func getAttachedMediaItem<T: CustomStringConvertible>(commentID id: T) -> Route<TraktAttachedMediaItem> {
            Route(
                paths: [path, "\(id)", "item"],
                method: .GET,
                requiresAuthentication: false,
                traktManager: traktManager
            )
        }
    }
}
