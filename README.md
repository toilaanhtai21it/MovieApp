# 🎬 MovieApp - Flutter Movie Mobile Application

**MovieApp** is a cross-platform mobile application built with **Flutter** and powered by **Firebase** services. It allows users to search for movies, view detailed information, and manage their personalized list of favorites. The app uses the **TMDB API** to fetch real-time movie data.

## 🚀 Features

- 🔍 **Movie Search**  
  Search for movies by title, genre, or release date using the TMDB API.

- 🎥 **Movie Details Page**  
  View detailed information about each movie including synopsis, release date, cast, and ratings.

- 🔐 **User Authentication**  
  Sign in or register using email/password or social logins (Google, Facebook) with Firebase Authentication.

- ❤️ **Favorites Management**  
  Mark movies as favorites and sync them in real-time using Firebase Cloud Firestore.

- 🔄 **Real-Time Updates**  
  Enjoy seamless synchronization of data across devices using Firestore's real-time capabilities.

- ☁️ **Cloud Storage**  
  Firebase Storage is used for managing media like posters or movie-related images.

- 📲 **Cross-Platform Support**  
  Built with Flutter for both **Android** and **iOS** using a single codebase.

- 🔔 **Push Notifications**  
  Receive updates and alerts via Firebase Cloud Messaging.

---

## 🛠️ Tech Stack

| Technology     | Usage                                        |
|----------------|----------------------------------------------|
| Flutter        | Frontend development                         |
| Firebase       | Backend services (Auth, Firestore, Storage)  |
| TMDB API       | Movie data source                            |
| State Management | Provider, Riverpod, or Bloc (choose one)    |

---

## 📦 Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/MovieApp_Flutter.git
cd MovieApp_Flutter

### 2️⃣ Install Flutter Dependencies

```bash
flutter pub get
```

### 3️⃣ Configure Firebase

1. Create a Firebase project at [https://console.firebase.google.com](https://console.firebase.google.com)
2. Add your Android/iOS app to the Firebase project.
3. Download configuration files:
   - `google-services.json` for **Android**
   - `GoogleService-Info.plist` for **iOS**
4. Place files in the appropriate directories:
   - `android/app/` for `google-services.json`
   - `ios/Runner/` for `GoogleService-Info.plist`

### 4️⃣ Enable Firebase Services

In the Firebase Console, enable the following services:

- ✅ Firebase Authentication (Email/Password, Google Sign-In)
- ✅ Firestore Database
- ✅ Firebase Storage
- ✅ Firebase Cloud Messaging (FCM)

### 5️⃣ Add Required Dependencies in `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.27.0
  firebase_auth: ^5.3.3
  cloud_firestore: ^5.5.0
  firebase_storage: ^12.3.6
  firebase_messaging: ^15.3.0
  shared_preferences: ^2.2.2
  flutter_stripe: ^11.2.0
```

### 6️⃣ Initialize Firebase in `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  SharedPreferences sp = await SharedPreferences.getInstance();
  
  Stripe.publishableKey = 'pk_test_XXXXXXXXXXXXXXXXXXXXXXXXXXXX';
  String imagepath = sp.getString('imagepath') ?? '';
  
  runApp(MyApp(imagepath: imagepath));
}
```

### 7️⃣ Run the App

```bash
flutter run
```

---

## 🌐 TMDB API Integration

- Sign up at [TMDB](https://www.themoviedb.org/)
- Go to the **API** section in your account
- Generate an API key
- Use endpoints like:

```bash
Search:         /search/movie?api_key=YOUR_KEY&query=query
Popular:        /movie/popular?api_key=YOUR_KEY
Movie Details:  /movie/{movie_id}?api_key=YOUR_KEY
```

Example response:

```json
{
  "results": [
    {
      "title": "Inception",
      "overview": "A thief who steals corporate secrets...",
      "poster_path": "/abc.jpg",
      "release_date": "2010-07-16"
    }
  ]
}
```

---

## 🖼 Screenshots

> _(Add screenshots in this section after uploading to GitHub or Cloud)_

- ✅ Home Screen  
- 🔍 Search Results  
- 🎞 Movie Details  
- ❤️ Favorites Page  
- 🔐 Login/Signup Screen  

---

## 📘 User Guide

### 🧭 Navigation

- Search movies using the top search bar
- Tap a movie to view detailed info
- Click the ❤️ icon to favorite a movie
- Access your favorite list from the menu
- Login to sync favorites across devices

### 🔐 Authentication

- Email/Password and Google login supported
- All user data is secured via Firebase

### 🔔 Notifications

- Get real-time updates on new movies and releases

---

## 🗺 Roadmap

- [x] Movie search and detail view
- [x] Firebase Authentication
- [x] Favorite movie storage
- [x] Real-time sync with Firestore
- [ ] Theme customization (dark/light mode)
- [ ] Offline caching
- [ ] Watchlist with reminders
- [ ] Admin dashboard for movie uploads

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/new-feature`
3. Commit your changes: `git commit -am 'Add new feature'`
4. Push to the branch: `git push origin feature/new-feature`
5. Create a new Pull Request

---


## 📧 Contact

For suggestions, issues, or collaboration:

📬 toilaanhtai41322@gmail.com  
📎 GitHub: https://github.com/toilaanhtai21it

---

**Happy Movie Browsing! 🎥🍿**

