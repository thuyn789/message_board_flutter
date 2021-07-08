# message_board

A flutter app that allows users to see messages related to specific topics

## Getting Started

- All the bugs and not-working functions have been declared below to the best of my knowledge.  If you can find more bugs, please let me know
- ***For testing purposes*** There are 2 demo login credentials below.
- If the source code on github does not work, please use the zip file attached in icollege submission.
- To install splash screen, run the following command in flutter terminal:
  +  flutter pub run flutter_native_splash:create

## Credits

- https://codelabs.developers.google.com/codelabs/flutter
- https://firebase.flutter.dev/docs/auth/usage
- https://firebase.flutter.dev/docs/firestore/usage
- https://www.filledstacks.com/post/building-flutter-login-and-sign-up-forms/
- https://medium.com/flutter-community/a-chat-application-flutter-firebase-1d2e87ace78f
- https://www.youtube.com/playlist?list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ
- https://www.youtube.com/watch?v=fi2WkznwWbc
- https://www.youtube.com/watch?v=ts9n211n8ZU
- https://www.youtube.com/watch?v=wHIcJDQbBFs


## Github Link

https://github.com/thuyn789/message_board_flutter


## Supported Platform

- Android
- Web


## Supported Login

- Email/password login
- Google social login


## Dependencies

flutter:
    sdk: flutter
  cloud_firestore: ^2.2.2
  google_sign_in: ^5.0.4
  firebase_auth: ^1.4.1
  firebase_core: ^1.3.0
  provider????????


## Dev_Dependencies

flutter_test:
    sdk: flutter
  flutter_native_splash: ^1.2.0

  #This is a configuration for splash screen for android and web app
flutter_native_splash:
  color: "#0096FF"
  image: images/loading_screen.png
  android: true
  ios: false
  web: true
  web_image_mode: center
  color_dark: "#000000"


## defaultConfig

- applicationId "com.example.message_board"
- minSdkVersion 24
- targetSdkVersion 30


## Firebase key for web

var firebaseConfig = {
    apiKey: "AIzaSyCAN6ltkh5UO6UYwLF3FmJrHt73bCfLgj8",
    authDomain: "supercool-rental.firebaseapp.com",
    databaseURL: "https://supercool-rental-default-rtdb.firebaseio.com",
    projectId: "supercool-rental",
    storageBucket: "supercool-rental.appspot.com",
    messagingSenderId: "138927912921",
    appId: "1:138927912921:web:4a28b2011ffb2605464bc8"
};


## Configuration for web app

- Please use the correct firebase web app version (8.4.3) 

  +"<script src="https://www.gstatic.com/firebasejs/8.4.3/firebase-app.js"></script>"
  +"<script src="https://www.gstatic.com/firebasejs/8.4.3/firebase-firestore.js"></script>"
  +"<script src="https://www.gstatic.com/firebasejs/8.4.3/firebase-auth.js"></script>"
  +"<script src="./scripts/firebase-key.js"></script>"


## Basic App Structure

- The root widget: main.dart
- After login, the app will bring user to a home screen where user can choose a topic to chat
- main.dart -> home.dart -> topic -> chat_screen.dart


## Basic Database Structure for chat messages in Firebase Database

- board_message --> topic --> topic--> individual messages


## Login Credentials for Demo Accounts

- Admin: admin@admin.com, password

- Customer: customer@email.com, password


## Bugs and Not Working

- Not working: User cannot update their login credential at the moment.  Will update later