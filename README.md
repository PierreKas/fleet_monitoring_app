# Fleet Monitoring App

A real-time fleet monitoring application built with Flutter that allows users to track vehicle locations on a map.

## Features

- **Map View**: Shows all vehicles on a Google Map with custom markers
- **Real-Time Updates**: Automatically fetches vehicle data every 5 seconds
- **Car Details**: View detailed information about each vehicle
- **Search & Filter**: Find vehicles by name and filter by status
- **Vehicle Tracking**: Follow a specific vehicle's movements in real-time
- **Offline Support**: Caches vehicle data for offline viewing
- **Error Handling**: Displays appropriate messages when network errors occur

## Screenshots & Demo

### Main Screens
<div align="center">
  <img src="assets/icons/car1.png" alt="Map View" width="250"/>
  <img src="assets/icons/car2.png" alt="Vehicle Details" width="250"/>
  <img src="assets/icons/car1.png" alt="Search and Filter" width="250"/>
</div>

### Feature Demo
<div align="center">
  <img src="assets/demo/video-demo.gif" alt="Real-time Tracking Demo" width="300"/>
</div>

## How to Run

1. Clone this repository
2. Get Flutter dependencies:
   ```
   flutter pub get
   ```
3. Add your Google Maps API key:
   - In `android/app/src/main/AndroidManifest.xml`
   - In `web/index.html` (if you want to use web platform)
   - In `ios/Runner/AppDelegate.swift`
4. Run the app:
   ```
   flutter run
   ```

## Dependencies

- google_maps_flutter: For displaying the map
- provider: For state management
- http: For API requests
- shared_preferences: For local storage
- go_router: for pages routing

## Assumptions and Limitations

- The app assumes the API endpoint will return data in the expected format
- For a production app, proper API authentication would be implemented
- The map is currently centered on Rwanda/Kigali (-1.94995, 30.05885) by default
- Vehicle movement is simulated by the API, not actual GPS data
