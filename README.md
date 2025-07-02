# date_line_drawer

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Installation

1.  Clone the repository: `git clone <repository-url>`
2.  Navigate to the project directory: `cd date_line_drawer`
3.  Install dependencies: `flutter pub get`

## Development

To run the application in development mode, use the following command:

```bash
flutter run -d chrome
```

This will start the application in a Chrome browser window.

## Deployment

To build the application for the web, use the following command:

```bash
flutter build web
```

The output will be in the `build/web` directory. You can then deploy this directory to any web server.

## Usage

1.  Open the application in a Chrome browser.
2.  Click on the "Select Date 1" button to choose the first date.
3.  Once the first date is selected, the "Select Date 2" button will become active. Click on it to choose the second date.
4.  After selecting both dates, the `dateResult` will be displayed below the buttons.
5.  A 3x3 grid of points will be drawn, and a line will be animated to connect the points based on the digits of the `dateResult`.