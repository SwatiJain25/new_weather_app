
```markdown
# Flutter Weather App

This Flutter application allows users to enter a city name and fetch weather details from the OpenWeatherMap API.

## Features
- Enter a city name to get the current weather details.
- Fetch weather data using the OpenWeatherMap API.
- Display the weather information on the screen.
- Save the last searched city and load its weather details on app restart.
- Refresh the weather details.

## Prerequisites
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- OpenWeatherMap API Key: [Get API Key](https://home.openweathermap.org/users/sign_up)

## Getting Started

### Clone the Repository
Clone the repository to your local machine using the following command:
```bash
git clone https://github.com/your-repository/flutter-weather-app.git
cd flutter-weather-app
```

### Install Dependencies
Navigate to the project directory and install the necessary dependencies by running:
```bash
flutter pub get
```

### Configuration
1. Create a file named `config.dart` in the `lib` directory.
2. Add the following code to `config.dart` and replace `YOUR_API_KEY` with your OpenWeatherMap API key:
```dart
const String apiKey = 'YOUR_API_KEY';
```

### Run the App
Connect a device or start an emulator, then run the app using the following command:
```bash
flutter run
```

## Usage
1. When the app launches, you will see an input field to enter a city name.
2. Enter the desired city name and press the "Search" button.
3. The app will fetch the weather details from the OpenWeatherMap API and display them on the screen.
4. You can refresh the weather details by pressing the "Refresh" button.
5. The last searched city will be saved and its weather details will be displayed when the app is restarted.

## Notes
- Ensure that you have a stable internet connection to fetch weather data.
- The app uses the OpenWeatherMap API to fetch weather details. Make sure to handle API rate limits as per the OpenWeatherMap guidelines.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
If you have any questions or suggestions, feel free to reach out to me at swatijain2021s@gmail.com.
```
