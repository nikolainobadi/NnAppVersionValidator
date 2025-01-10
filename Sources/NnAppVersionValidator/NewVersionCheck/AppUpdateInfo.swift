//
//  AppUpdateInfo.swift
//
//
//  Created by Nikolai Nobadi on 1/9/25.
//

import Foundation

public struct AppUpdateInfo: Codable {
    public let version: VersionNumber
    public let releaseNotes: String?
    public let updateURL: String?
    
    public init(version: VersionNumber, releaseNotes: String?, updateURL: String?) {
        self.version = version
        self.releaseNotes = releaseNotes
        self.updateURL = updateURL
    }
}
