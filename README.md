# FeedMyRSS

FeedMyRSS is a sample iOS RSS feed viewer application built with Swift and SwiftUI. It demonstrates core iOS development practices, including MVVM architecture, dependency injection, state management, navigation and testing.

| Feeds View | Add New Feed | Items View | Notifications |
| :-: | :-: | :-: | :-: |
|![IMG_6685](https://github.com/user-attachments/assets/e7eebb69-2cbf-4284-87ef-19301cf7b3a1)|![IMG_6687](https://github.com/user-attachments/assets/6c8daf87-c066-4d3b-83fc-74ddedb11625)|![IMG_6686](https://github.com/user-attachments/assets/0b885d0b-d217-4dfe-b532-15211f111296)|![IMG_6689](https://github.com/user-attachments/assets/799f86d6-a6c3-47bc-b96e-d7b3fcfcf49c)| 


## Features

- **Feeds View**: Browse a list of subscribed RSS feeds
- **Items View**: Browse an item list of selected RSS feed
- **Article View**: Read a news article in popup browser view by tapping on relevant RSS feed item
- **Favorite Feeds**: Mark specific RSS feeds as favorites for easier access and to enable feed update notifications
- **Background Fetching**: When app is in background, favourited feeds are periodically checked for new items
- **Notifications**: Enable notifications for new items from favourited feeds
- **Deep Linking**: Go directy to items view when tapping on notification


## Requirements

- **Xcode 16** or later
- **iOS 18** or later
- **Swift 5** or later

## Installation

1. Clone the repository:

```bash
git clone https://github.com/marvukusic/FeedMyRSS.git
```

2. Open the project in Xcode:

```bash
cd FeedMyRSS
open FeedMyRSS.xcodeproj
```

3. Build and run the project on the iOS simulator or a physical device

## Usage
### Adding RSS Feed
1. Tap on the "Add New Feed" button to add RSS feed to the list
2. Enter the URL and press "OK"
### Favouriting RSS Feed
1. Tap on the star to favourite an RSS feed
2. Pull-to-refresh to re-sort the feed list so favourited feeds come on top
### Viewing RSS Feed Items 
1. All added RSS feeds are listed on the feeds screen
2. Tap on any feed to view its items in separate screen
### Removing Feeds
- Swipe left any feed to remove it
### Viewing News Articles 
1. Latest feed items are listed on the items screen
2. Tap on an item to view complete news article in popup web browser view
### Refreshing items
- RSS feed items can be refreshed by pull-to-refresh action
### Notifications
- Allow notifications to get alerts when new items are available in favourited feeds
- Tap on notification banner opens the app with proper feed items displayed

## Architecture
This project follows the Model-View-ViewModel (MVVM) pattern for a clean separation of concerns and testable code. 
The key components of the architecture include:

- **Model**: Defines the data structures for items and any associated properties
- **ViewModel**: Manages business logic and state, bridging data and the UI
- **View**: SwiftUI views that display data from the ViewModel and handle user interaction

## Frameworks
- XML Parser
- URL Session (foreground and background)
- WebView
- Combine
- Background App Refresh Tasking
- Local Notifications
- UserDefaults Data Persistence
- Navigation Path Routing

## Patterns
- Enivronment Objects
- Static Type Methods
- Singletons
- Generics
- Delegating
- Protocol Composition
- Property Wrappers
- Dependancy Injection
- State Management
- Error Handling
- Deep Linking
- Custom View Styles
- Custom View Modifiers

## Testing
This app includes unit tests and UI tests to ensure functionality and maintainability. Key tests include:

- **Unit Tests**: Tests for RSS feed parser and network service, using mock data where necessary
- **UI Tests**: Automated tests to check UI functionality of adding an RSS feed
