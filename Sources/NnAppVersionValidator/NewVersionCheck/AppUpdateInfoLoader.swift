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
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Validate the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                throw VersionValidationError.invalidBundleId
            }
            
            // Decode the JSON into AppUpdateInfo
            let decoder = JSONDecoder()
            return try decoder.decode(AppUpdateInfo.self, from: data)
        } catch let decodingError as DecodingError {
            print("Decoding Error: \(decodingError)")
            throw VersionValidationError.invalidBundleId
        } catch {
            print("Unexpected Error: \(error)")
            throw VersionValidationError.invalidVersionInfo(url)
        }
    }
}
