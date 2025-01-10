//
//  AppUpdateInfoLoader.swift
//  
//
//  Created by Nikolai Nobadi on 1/9/25.
//

import Foundation

final class AppUpdateInfoLoader: AppUpdateInfoProvider {
    func loadVersionInfo(url: URL?) async throws -> AppUpdateInfo {
        guard let url else {
            throw VersionValidationError.missingURL
        }
        
        do {
            let data = try await URLSession.shared.data(from: url).0
            let decoder = JSONDecoder()
            
            return try decoder.decode(AppUpdateInfo.self, from: data)
        } catch {
            throw VersionValidationError.invalidVersionInfo(url)
        }
    }
}
