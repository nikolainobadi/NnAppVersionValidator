import Foundation

public func makeVersionValidator(infoDictionary: [String: Any]?, bundleId: String?, selectedVersionNumber: VersionNumberType = .major) -> NnVersionValidator {
    
    let localLoader = LocalVersionNumberLoader(infoDictionary: infoDictionary)
    let remoteLoader = RemoteVersionNumberLoader(bundleId: bundleId)
    
    return VersionValidator(local: localLoader, remote: remoteLoader, selectedVersionNumber: selectedVersionNumber)
}



public protocol NnVersionValidator {
    func checkIfVersionUpateIsRequired() async throws -> Bool
}







public enum VersionNumberType: Int {
    case major, minor, patch
}

enum VersionValidationError: Error {
    case missingNumber
    case invalidBundleId
    case missingDeviceVersionString
    case unableToFetchVersionFromAppStore
}

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
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let versionString = results.first?["results"] as? String
        else {
            throw VersionValidationError.missingDeviceVersionString
        }
        
        return try VersionNumberMapper.map(versionString)
    }
}

