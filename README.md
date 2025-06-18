# Maternity App

A modern, cross-platform Flutter application designed to support mothers throughout pregnancy and early parenting. The app delivers personalized onboarding, health and nutrition tracking, baby care resources, medication and vaccination management, and much more—all with a beautiful, responsive UI.

---

## ✨ Features

- **Personalized Onboarding:** Custom questions and flows to tailor the experience for each user.
- **Pregnancy Tracking:** Week-by-week and trimester tracking, with detailed articles and health tips.
- **Mother’s Health:** Dedicated screens for health before, during, and after pregnancy.
- **Baby Care:** Breastfeeding (natural and formula), newborn tips, and baby care articles.
- **Medication & Vaccination:** Add, manage, and track medication and vaccination schedules, with reminders.
- **Profile Management:** Secure profile management with Firebase authentication and Firestore data storage.
- **Community & FAQ:** Frequently Asked Questions and educational resources.
- **Modern UI:** Gradient-rich, responsive design with custom navigation and theming.
- **Notifications:** (Extendable) for reminders and health tips.
- **Multi-Platform:** Android, iOS, Web, Linux, macOS, and Windows support.

---

## 🏗️ Architecture & Tech Stack

- **Flutter & Dart**: Main development stack
- **Firebase**: Auth, Firestore, and backend
- **Clean Architecture**: Separation into presentation, domain, and data layers
- **Provider & Bloc**: State management
- **get_it**: Dependency injection
- **Freezed & JSON Serialization**: Immutable models and serialization
- **Google Fonts & Custom Themes**: Consistent, beautiful typography and theming
- **Rich Assets**: Images for onboarding, pregnancy, and baby care

---

## 📁 Project Structure

```
lib/
 ├── app/                 # App entry and configuration
 ├── core/                # Utilities, constants, themes, DI
 ├── data/                # Models, repositories, remote/local datasources
 ├── domain/              # Entities, repositories, use cases
 ├── presentation/        # UI: screens, widgets, viewmodels
 │    ├── onboarding/     # Onboarding screens and logic
 │    ├── home/           # Home, navigation, and main features
 │    ├── Questions/      # Personalized onboarding questions
 │    ├── Breastfeeding/  # Breastfeeding and baby care
 │    ├── MotherHealth/   # Mother’s health screens
 │    ├── drug_registration/ # Medication, exercise, water tracking
 │    ├── vaccination/    # Vaccination screens
 │    ├── forgot_password/# Password reset flows
 │    ├── profile/        # Account and profile management
 │    └── ...
 ├── assets/              # Images and static resources
 └── main.dart            # App entrypoint
```

---

## 🚀 Getting Started

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

---

## 🧑‍💻 Usage
- Register or log in to your account
- Complete onboarding and personalize your experience
- Set up your profile and pregnancy details
- Explore articles, track health, and manage medications
- Access baby care tips, FAQs, and community resources
- Update your profile and settings at any time

---

## 🤝 Contributing
Contributions are welcome! Please:
- Fork the repository
- Create a feature branch
- Open a pull request with a clear description
- Follow the existing code style and architecture


