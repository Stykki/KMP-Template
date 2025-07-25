# Kotlin Multiplatform Project: Your Starting Point for Cross-Platform Development

This project provides a solid foundation for building applications targeting Android and iOS using Kotlin Multiplatform. It's designed to help you hit the ground running with a well-structured setup and essential libraries.

## Project Structure

The project is organized to promote code sharing while allowing for platform-specific implementations when necessary:

*   **`/composeApp`**: This is the heart of your shared UI and business logic, built with Compose Multiplatform.
  *   `commonMain`: Contains Kotlin code that is common to all target platforms (Android and iOS). This is where you'll write the bulk of your application logic and UI.
  *   Platform-Specific Folders (e.g., `androidMain`, `iosMain`): These folders are for Kotlin code that needs to be compiled for a specific platform. For example, if you need to access platform-specific APIs like Apple's CoreCrypto on iOS, the `iosMain` folder is the place for that code.

*   **`/iosApp`**: This directory contains the iOS application project. Even when sharing your UI with Compose Multiplatform, this serves as the entry point for your iOS app. You can also integrate SwiftUI code here if needed.

## Key Dependencies

This project comes pre-configured with a selection of powerful libraries to accelerate your development:

*   **Ktor Client**: For making network requests.
  *   `libs.ktor.client.core`: The core Ktor HTTP client functionality.
  *   `libs.ktor.client.content.negotiation`: Enables automatic content negotiation for request and response bodies (e.g., handling JSON).
  *   `libs.ktor.serialization.kotlinx.json`: Provides Kotlinx.serialization support for Ktor, allowing easy serialization and deserialization of JSON data.

*   **Coil**: An image loading library for Android and Compose Multiplatform, backed by Kotlin Coroutines.
  *   `libs.coil.compose`: Provides Jetpack Compose bindings for Coil, making it simple to display images in your Compose UI.
  *   `libs.coil.network.ktor`: Integrates Coil with Ktor, allowing Coil to use Ktor for network operations when fetching images.

*   **Koin**: A pragmatic and lightweight dependency injection framework for Kotlin.
  *   `libs.koin.core`: The core Koin dependency injection functionality.
  *   `libs.koin.compose.viewmodel`: Provides integration with Jetpack Compose `ViewModel`s, making it easy to inject dependencies into your ViewModels.

## Get Started!

This template is designed to be a launchpad for your Kotlin Multiplatform journey. Clone the repository, explore the structure, and start building your amazing cross-platform application!

---

Learn more about [Kotlin Multiplatform](https://www.jetbrains.com/help/kotlin-multiplatform-dev/get-started.html).
