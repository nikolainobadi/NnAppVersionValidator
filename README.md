# NnAppVersionValidator
NnVersionValidator is a Swift package that allows you to check if the app version on the device is lower than the app version on the App Store. This can be useful for prompting users to update their app to the latest version.

## Installation
To use NnVersionValidator in your Xcode project, you can add it as a Swift Package Dependency, manually add the source files to your project, or you can include it in your own Swift Package.

### Adding as a Swift Package Dependency
To add NnVersionValidator as a Swift Package Dependency, follow these steps:

1. In Xcode, open the project where you want to use NnVersionValidator.
2. Click on "File" > "Swift Packages" > "Add Package Dependency".
3. In the "Choose Package Repository" window, enter `https://github.com/nikolainobadi/NnAppVersionValidator`, then click "Next".
4. Choose the version you want to use, then click "Next".
5. Choose the target where you want to add the package, then click "Finish".
6. Wait for Xcode to download and integrate the package into your project.

### Adding the Source Files Manually
To add the `NnVersionValidator` source files manually to your project, follow these steps:

1. Download or clone the NnVersionValidator repository to your local machine.
2. In Xcode, create a new group for the NnVersionValidator files in your project.
3. Drag the `NnVersionValidator` source files (.swift files) from your local repository to the group you created in your Xcode project.
4. Make sure to check the "Copy items if needed" checkbox when prompted.

### Adding as a Dependency for another Swift Package
To use `NnVersionValidator` as a dependency to your Swift package. Add the following to your Package.swift file:

```
dependencies: [
    .package(url: "https://github.com/nikolainobadi/NnAppVersionValidator", from: "1.0.0"),
]
```
## Usage
Here's an example of how to use NnVersionValidator:

```
import NnVersionValidator

// Get the app's Info.plist dictionary
let infoDictionary = Bundle.main.infoDictionary

// Specify your app's bundle ID
let bundleId = "com.example.MyApp"

// Create a version validator object
let versionValidator = makeVersionValidator(infoDictionary: infoDictionary, bundleId: bundleId)

// Check if an update is required
do {
    let updateRequired = try await versionValidator.checkIfVersionUpateIsRequired()
    if updateRequired {
        // Prompt the user to update the app
    }
} catch {
    // Handle the error
}

```

You can also specify which type of update to check by passing a `VersionNumberType` to `makeVersionValidator`. Here are the available options:

- .major: returns true if the first number in the version number has changed
- .minor: returns true if the first or second number in the version number has changed
- .patch: returns true if any number in the version number has changed

```
// Check for a major update
let versionValidator = makeVersionValidator(infoDictionary: infoDictionary, bundleId: bundleId, selectedVersionNumber: .major)

// Check for a minor update
let versionValidator = makeVersionValidator(infoDictionary: infoDictionary, bundleId: bundleId, selectedVersionNumber: .minor)

// Check for a patch update
let versionValidator = makeVersionValidator(infoDictionary: infoDictionary, bundleId: bundleId, selectedVersionNumber: .patch)

```

And if you would rather compare the `VersionNumber`s yourself, you can use `getAppVersionNumbers`, which will return a pair of `VersionNumber`'s via the `AppVersionNumberComparison` typealias.

```
public struct VersionNumber: Equatable {
    public let majorNum: Int
    public let minorNum: Int
    public let patchNum: Int
}

public extension VersionNumber {
    var fullVersionNumber: String {
        "\(majorNum).\(minorNum).\(patchNum)"
    }
}
```


```
 let versionValidator = makeVersionValidator(infoDictionary: infoDictionary, bundleId: bundleId)
 
 do { 
    let comparison = try await versionValidator.getAppVersionNumbers()
    let deviceVersion = comparison.deviceVersion
    let appStoreVersion = comparison.appStoreVersion

    // compare the version numbers and handle result
 } catch { 
    // handle error
 }
```

## License
`NnVersionValidator` is available under the MIT license. See the LICENSE file for more information.
