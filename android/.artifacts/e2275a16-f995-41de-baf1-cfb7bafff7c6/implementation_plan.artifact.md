# Fix IllegalArgumentException: 25.0.2 during Gradle Sync

The error `java.lang.IllegalArgumentException: 25.0.2` is caused by an incompatibility between the Kotlin Gradle Plugin (version 1.9.24) and JDK 25. The version of Kotlin currently used in the project cannot parse the Java 25 version string.

## User Review Required

> [!IMPORTANT]
> This plan involves upgrading the Kotlin Gradle Plugin to a newer version (2.1.20 or higher). This might require small changes in Kotlin syntax if your project uses older deprecated features, but for most Flutter projects, it should be seamless.

## Proposed Changes

### Build Configuration

#### [MODIFY] [settings.gradle.kts](file:///Users/extra/bedal/android/settings.gradle.kts)
- Upgrade `org.jetbrains.kotlin.android` from `1.9.24` to `2.1.20` (or the latest stable version compatible with Java 25).

#### [MODIFY] [gradle-wrapper.properties](file:///Users/extra/bedal/android/gradle/wrapper/gradle-wrapper.properties)
- Ensure Gradle is at version `9.0` or higher to ensure full support for Java 25 runtimes. (Currently `8.14.5`).

---

## Verification Plan

### Automated Tests
- Run `./gradlew help` to verify the build system initializes without the `IllegalArgumentException`.
- Perform a Gradle Sync in Android Studio.

### Manual Verification
- Build the app using `flutter build apk` or by running it on a device/emulator to ensure runtime compatibility.
