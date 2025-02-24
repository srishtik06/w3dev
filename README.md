# Google Login Integration in Flutter

## Overview

This Flutter project is an **assignment** that integrates Google Login, a tabbed navigation interface, and local notifications. **It is built specifically for Android and has been tested accordingly.**

## Features

### 1. **Google Login Integration**

- Allows users to sign in using their Google account.
- Displays user information (name, email, and profile picture) upon successful login.
- Uses `google_sign_in` package (optionally `firebase_auth` for extended authentication flow).
- Handles login errors and maintains user session state until explicitly logged out.

### 2. **Tabbed View Interface**

- Navigates users to a home screen after login.
- Includes three tabs:
    - **Home:** Displays a greeting and placeholder content.
    - **Profile:** Shows user details and logout option.
    - **Settings/Notifications:** Allows users to manage notifications.
- Utilizes `TabBar` and `TabBarView` for smooth navigation and state management.

### 3. **Notifications**

- Implements local notifications using `flutter_local_notifications` package.
- Allows users to schedule notifications.
- Notifications can be triggered from a button tap in the "Settings/Notifications" tab.

## Prerequisites

Before running the project, ensure you have:

- ✅ [Flutter SDK](https://flutter.dev/docs/get-started/install) installed
- ✅ [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter extension
- ✅ A valid Google API OAuth client ID (if using Google Sign-In)
- ✅ `google-services.json` file (already included in this project for Android support)

## Installation

Clone the repository:

```sh
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
cd YOUR_REPOSITORY
```

Install dependencies:

```sh
flutter pub get
```

## Running the Project

Run the project using:

```sh
flutter run
```

For Android:

- Ensure an emulator or physical device is connected.

## API Configuration

For Google Sign-In, the `google-services.json` file is already added. No additional configuration is required for this assignment.

## How to Use

1. Launch the app and log in using Google.
2. Navigate through the tabs using the bottom navigation bar.
3. Trigger a test notification from the "Settings/Notifications" tab.

## Notes for the Recruiter

- This assignment is designed exclusively for **Android** and has been tested accordingly.
- The **Google Sign-In** functionality is fully implemented and includes proper session management.
- The **`google-services.json`**** file** is already configured and added to the project.
- The application is structured with clean and maintainable code following Flutter best practices.


