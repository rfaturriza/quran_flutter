# Muslim Book

Muslim Book is a Flutter project designed to provide a modern and user-friendly Quran application for users to read and explore the Quranic text.  contributions are welcome.

<div style="display: flex; justify-content: center; align-items: center">
  <a href="https://apps.apple.com/id/app/kajianhub/id6739066951" target="_blank">
    <img src="https://github.com/user-attachments/assets/170a7c12-ab9b-470b-8a88-dd1f1d68f0e7" alt="Download on the App Store" height="60">
  </a>
  <a href="https://play.google.com/store/apps/details?id=com.rizz.quranku" target="_blank">
    <img src="https://github.com/user-attachments/assets/46fa6300-2ca2-48e1-afe3-a4004ddda5e7" alt="Get it on Google Play" height="60" style="margin-left: 50px;">
  </a>
</div>


## Tech
- Flutter
- Clean Architecture
- Freezed
- Easy Localization
- Bloc
- Dio
- Get It & Injectable
- Github action CI
- Fastlane CD

## Features
- [✔] Display Quranic (Surah and Juz mode) text with translations.
- [✔] Localization in English and Bahasa Indonesia.
- [✔] Search functionality for finding specific Surah.
- [✔] Search functionality for finding specific Juz.
- [✔] Display Shalat time by location.
- [✔] Bookmark and save favorite verses.
- [✔] Audio recitations of Quranic verses.
- [✔] User-friendly and responsive design.
- [✔] Share your favorite verses with your friends on Instagram, WhatsApp, etc.
- [✔] Setting for changing font size, font type, language, etc.
- [✔] Light and Dark mode for more comfortable reading.
- [✔] Display Quranic text with tajweed.
- [In Progress] Display detail Shalat time in calendar/permonth.
- [In Progress] Localization more languages.

## Installation
To run this Flutter project on your local machine, follow these steps:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/rfaturriza/muslim_book.git

2. **Navigate to the project directory:**

   ```bash
   cd muslim_book

3. **Install dependencies:**

    ```bash
    flutter pub get

3. **Run build runner and generate localization**

    ```bash
    flutter pub run build_runner build
    flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations

4. **Run the application:**

    ```bash
    flutter run
    
## Contributing
We welcome contributions from the community to help improve and expand the Muslim Book project. If you'd like to contribute, please follow these guidelines:

Fork the repository and create a new branch for your feature or bug fix.

Make your changes, ensuring that the code is well-documented and follows best practices.

Write tests if necessary and ensure existing tests pass.

Open a pull request describing your changes, the problem you're solving, and any relevant information.

Your pull request will be reviewed, and once approved, it will be merged into the main project.

## License
This project is licensed under the MIT License - see the LICENSE.md file for details.

## Contact
If you have any questions or suggestions regarding the project, feel free to reach out to us:

Email: rfaturriza@gmail.com
We appreciate your interest in contributing to the Muslim Book project!
