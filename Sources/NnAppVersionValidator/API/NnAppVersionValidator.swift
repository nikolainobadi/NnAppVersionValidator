import Foundation

public func makeVersionValidator(infoDictionary: [String: Any]?, bundleId: String?, selectedVersionNumber: VersionNumberType = .major) -> NnVersionValidator {
    
    let localLoader = LocalVersionNumberLoader(infoDictionary: infoDictionary)
    let remoteLoader = RemoteVersionNumberLoader(bundleId: bundleId)
    
    return VersionValidator(local: localLoader, remote: remoteLoader, selectedVersionNumber: selectedVersionNumber)
}



public protocol NnVersionValidator {
    func checkIfVersionUpateIsRequired() async throws -> Bool
}



final class LocalVersionNumberLoader {
    private let infoDictonary: [String: Any]?
    private let versionStringId = "CFBundleShortVersionString"
    
    init(infoDictionary: [String: Any]?) {
        self.infoDictonary = infoDictionary
    }
}


// MARK: - Loader
extension LocalVersionNumberLoader: VersionNumberLoader {
    func loadVersionNumber() async throws -> VersionNumber {
        guard let deviceVersionString = infoDictonary?[versionStringId] as? String else {
            throw VersionValidationError.missingDeviceVersionString
        }

        return try DeviceVersionMapper.map(deviceVersionString)
    }
}

enum DeviceVersionMapper {
    static func map(_ versionString: String) throws -> VersionNumber {
        let noDecimals = removeDecimals(from: versionString)
        let array = noDecimals.compactMap { Int($0) }
        
        guard array.count == noDecimals.count else {
            throw VersionValidationError.missingNumber
        }
        
        return makeVersionNumber(from: array)
    }
}


// MARK: - Private Methods
private extension DeviceVersionMapper {
    static func removeDecimals(from string: String) -> [String] {
        string.components(separatedBy: ".")
    }
    
    static func makeVersionNumber(from array: [Int]) -> VersionNumber {
        VersionNumber(majorNum: getNumber(.major, in: array),
                      minorNum: getNumber(.minor, in: array),
                      patchNum: getNumber(.patch, in: array))
    }
    
    static func getNumber(_ numtype: VersionNumberType, in array: [Int]) -> Int {
        let index = numtype.rawValue
        
        return array.count > index ? array[index] : 0
    }
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
        
        return try DeviceVersionMapper.map(versionString)
    }
}

