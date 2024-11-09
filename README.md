# FeedMyRSS

FeedMyRSS is a sample iOS RSS feed viewer application built with Swift and SwiftUI. It demonstrates core iOS development practices, including MVVM architecture, dependency injection, state management and navigation.

## Features

- **Feeds View**: Users can see a list of RSS feeds which they've subscribed to.
- **Add Feed**: Allows users to subscribe to various RSS feeds by inserting their URL.
- **Remove Feed**: Users can remove RSS feed from list by swiping left unwanted RSS feed.
- **Items View**: Users can select an RSS feed from the list to view its latest items in a separate screen.
- **Article View**: Users can read news article in popup view by tapping on relevant RSS feed item.
- **MVVM Architecture**: Adheres to MVVM for better organization and testability.
- **Data Persistence**: Stores data locally to persist RSS feeds selection.
- **Unit and UI Testing**: Includes unit and UI tests for essential components.

## Requirements

- **Xcode 16** or later
- **iOS 18** or later
- **Swift 5** or later

## Installation

1. Clone the repository:

```bash
git clone https://github.com/marvukusic/FeedMyRSS.git
```

2.Open the project in Xcode:

```bash
cd FeedMyRSS
open FeedMyRSS.xcodeproj
```

3. Build and run the project on the iOS simulator or a physical device.

## Usage
### Adding RSS Feed
1. Tap on the "Add New Feed" button to add RSS feed to the list.
2. Enter the URL and press "OK".
### Viewing RSS Feed Items 
1. All added RSS feeds are listed on the feeds screen.
2. Tap on any feed to view its items in separate screen.
### Removing Feeds
Swipe left any feed to remove it.
### Viewing News Articles 
1. Latest feed items are listed on the items screen.
2. Tap on an item to view complete news article in popup web browser view.
### Refreshing items
RSS feed items can be refreshed by pull-to-refresh action.

## Architecture
This project follows the Model-View-ViewModel (MVVM) pattern for a clean separation of concerns and testable code. The key components of the architecture include:

- **Model**: Defines the data structures for items and any associated properties.
- **ViewModel**: Manages business logic and state, bridging data and the UI.
- **View**: SwiftUI views that display data from the ViewModel and handle user interaction.

## Testing
This app includes unit tests and UI tests to ensure functionality and maintainability. Key tests include:

- **Unit Tests**: Tests for RSS feed parser and network service9, using mock data where necessary.
- **UI Tests**: Automated tests to check navigation and basic UI functionality.
