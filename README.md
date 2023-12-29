# NnAppVersionValidator
`NnAppVersionValidator` is a Swift package designed to facilitate the comparison of the local app version with the version available on the App Store. This package is essential for prompting users to update their app, ensuring they have access to the latest features and bug fixes.

## Features
- Compare local app version with App Store version.
- Customize version comparison based on major, minor, or patch updates.
- Retrieve and manually compare version numbers.
- Handle various version validation errors.

## Installation

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/nikolainobadi/NnAppVersionValidator", from: "1.0.0"),
]
```
### Adding to an Xcode Project
1. Open your Xcode project.
2. Select your project in the Project Navigator.
3. Navigate to Swift Packages in the project settings.
4. Click the + button to add a package.
5. Enter https://github.com/nikolainobadi/NnAppVersionValidator as the package repository URL.
6. Follow the prompts to add the package to your project.

## Usage

### Basic Usage
Here's an example of how to use NnVersionValidator:

```swift
import NnVersionValidator

// Initialize the version validator
let versionValidator = makeVersionValidator(
    infoDictionary: Bundle.main.infoDictionary, 
    bundleId: "com.example.MyApp"
)

// Check if an update is required
do {
    let updateRequired = try await versionValidator.checkIfVersionUpdateIsRequired()
    if updateRequired {
        // Prompt the user to update the app
    }
} catch {
    // Handle errors
}
```

### Update Type Customization
Adjust the selectedVersionNumber to determine what type of update you want to check for.

```swift
// Check for a major update
let majorUpdateValidator = makeVersionValidator(
    infoDictionary: Bundle.main.infoDictionary, 
    bundleId: "com.example.MyApp", 
    selectedVersionNumber: .major
)

// Check for a minor update
let minorUpdateValidator = makeVersionValidator(
    infoDictionary: Bundle.main.infoDictionary, 
    bundleId: "com.example.MyApp", 
    selectedVersionNumber: .minor
)

// Check for a patch update
let patchUpdateValidator = makeVersionValidator(
    infoDictionary: Bundle.main.infoDictionary, 
    bundleId: "com.example.MyApp", 
    selectedVersionNumber: .patch
)
```

### Manual Version Comparison
Use this approach to fetch and compare the app's version numbers from the device and the App Store directly, allowing for custom comparison logic and handling.

```swift
let versionValidator = makeVersionValidator(
    infoDictionary: Bundle.main.infoDictionary, 
    bundleId: "com.example.MyApp"
)

do {
    let comparison = try await versionValidator.getAppVersionNumbers()
    // Compare deviceVersion and appStoreVersion
} catch {
    // Handle errors
}
```

## License
`NnVersionValidator` is available under the MIT license. See the LICENSE file for more information.
