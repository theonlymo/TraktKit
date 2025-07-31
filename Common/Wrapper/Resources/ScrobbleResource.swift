import Foundation

extension TraktManager {
    
    public struct ScrobbleResource {
        
        private let traktManager: TraktManager

        internal init(traktManager: TraktManager) {
            self.traktManager = traktManager
        }

        // MARK: - Actions
        
        public func scrobbleStart(_ scrobble: TraktScrobble) -> Route<ScrobbleResult> {
            Route<ScrobbleResult>(path: "scrobble/start", body: scrobble, method: .POST, requiresAuthentication: true, traktManager: traktManager)
        }
        
        public func scrobblePause(_ scrobble: TraktScrobble) -> Route<ScrobbleResult> {
            Route<ScrobbleResult>(path: "scrobble/pause", body: scrobble, method: .POST,requiresAuthentication: true, traktManager: traktManager)
        }
        
        public func scrobbleStop(_ scrobble: TraktScrobble) -> Route<ScrobbleResult> {
            Route<ScrobbleResult>(path: "scrobble/stop", body: scrobble, method: .POST, requiresAuthentication: true, traktManager: traktManager)
        }
    }
    
}
