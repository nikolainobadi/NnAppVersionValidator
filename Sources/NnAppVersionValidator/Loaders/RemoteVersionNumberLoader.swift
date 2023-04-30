//
//  RemoteVersionNumberLoader.swift
//  
//
//  Created by Nikolai Nobadi on 4/29/23.
//

import Foundation

final class RemoteVersionNumberLoader {
    private let bundleId: String?
    
    public init(bundleId: String?) {
        self.bundleId = bundleId
    }
}


// MARK: - Loader
extension RemoteVersionNumberLoader: VersionNumberLoader {
    func loadVersionNumber() async throws -> VersionNumber {
        guard let bundleId = bundleId,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)")
        else {
            throw VersionValidationError.invalidBundleId
        }
        
        if #available(macOS 12.0, *) {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let versionString = results.first?["results"] as? String
            else {
                throw VersionValidationError.missingDeviceVersionString
            }
            
            return try VersionNumberMapper.map(versionString)
        } else {
            // Fallback on earlier versions
            return try await alertnateFetchVersionNumber(url: url)
        }
    }
}


// MARK: - Private
private extension RemoteVersionNumberLoader {
    func alertnateFetchVersionNumber(url: URL) async throws -> VersionNumber {
        return try await withCheckedThrowingContinuation({ continuation in
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard let data = data, error == nil else { return continuation.resume(throwing: VersionValidationError.unableToFetchVersionFromAppStore) }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let results = json["results"] as? [[String: Any]],
                          let versionString = results.first?["results"] as? String
                    else {
                        return continuation.resume(throwing: VersionValidationError.missingDeviceVersionString)
                    }
                    
                    let versionNumber = try VersionNumberMapper.map(versionString)
                    
                    return continuation.resume(returning: versionNumber)
                } catch {
                    if let validationError = error as? VersionValidationError {
                        return continuation.resume(throwing: validationError)
                    } else {
                        return continuation.resume(throwing: VersionValidationError.unableToFetchVersionFromAppStore)
                    }
                }
            }
        })

    }
}
