# EduNexus

EduNexus is a modern Flutter application designed as a demo educational platform. It demonstrates clean UI/UX, strict MVC architecture, and best practices for Flutter app development. Firebase and backend dependencies have been removed, so all logic is handled locally for demonstration purposes.

## Features

- Clean, modern UI with custom color palette and fonts
- Strict MVC architecture: controllers handle logic, views handle UI
- Login, Signup, Profile, and About Us pages
- Animated buttons and well-aligned input fields
- Asset management for images and logos
- Navigation between pages using Flutter's Navigator
- Profile page with password visibility toggle and logout
- About Us page with rounded image and developer info

## Screenshots

> Add screenshots of your app here (e.g., login, signup, profile, about us pages)

## Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or later recommended)
- Dart SDK

### Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/Tasnia0204/EduNexus2.git
   cd EduNexus2
   ```
2. Get dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

## Project Structure

```
lib/
  controllers/   # All logic controllers (MVC)
  models/        # Data models (if any)
  views/         # All UI screens (views)
  widgets/       # Custom reusable widgets
assets/          # Images and logos
```

## Main Pages
- **LoginView**: User login (demo credentials: tasnia0204@gmail.com / hello1234)
- **SignupView**: User registration (local validation only)
- **ProfileView**: Shows user info, password toggle, and logout
- **AboutUsView**: Developer info and rounded image
- **WelcomeView**: App landing page

## Customization
- Update assets in the `assets/` folder and register them in `pubspec.yaml`.
- Change color scheme and fonts in `main.dart`.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
This project is for educational/demo purposes only.

---

Developed by Tasnia Jahan
