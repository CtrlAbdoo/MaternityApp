# Maternity App

A comprehensive Flutter application designed to support mothers throughout pregnancy and early parenting. The app offers personalized guidance, health tracking, educational resources, and community support, all in one place.

## Features

- **Personalized Onboarding**: Custom experience tailored to user needs.
- **Pregnancy Tracking**: Track pregnancy progress by week and trimester.
- **Health & Nutrition Guidance**: Articles and tips for nutrition, rest, and physical activity during pregnancy and postpartum.
- **Medication & Vaccination Management**: Log medications, track vaccination schedules, and receive reminders.
- **Baby Care Tips**: Practical advice for newborn care, breastfeeding, and formula feeding.
- **User Profile**: Manage and update user information securely.
- **Firebase Integration**: Secure authentication and cloud data storage.
- **Modern UI**: Beautiful, gradient-rich interface for a pleasant user experience.

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Firebase account](https://firebase.google.com/) (for authentication and backend)

### Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/maternity_app.git
   cd maternity_app
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure Firebase:**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files to the respective directories.
   - Update `firebase.json` as needed.
4. **Run the app:**
   ```bash
   flutter run
   ```

### Project Structure
- `lib/` — Main Dart codebase (UI, logic, viewmodels)
- `assets/` — Images and static resources
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` — Platform-specific code

## Usage
- Register or log in to your account
- Set up your profile and pregnancy details
- Explore articles, track health, and manage medications
- Access baby care tips and community resources

## Contributing
Contributions are welcome! Please open issues or submit pull requests for improvements and bug fixes.

## License
[MIT](LICENSE)

---

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.
