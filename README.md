# Muslim Book

Muslim Book is a Flutter project designed to provide a modern and user-friendly Quran application for users to read and explore the Quranic text. Please note that this project is a **work in progress**, and contributions are welcome.

## Tech
- Flutter 3.13.1
- Clean Architecture
- Freezed
- Easy Localization
- Bloc
- Dio
- Get It & Injectable

## Features
- [✔] Display Quranic (Surah and Juz mode) text with translations.
- [✔] Localization in English and Bahasa Indonesia.
- [✔] Search functionality for finding specific Surah.
- [✔] Search functionality for finding specific Surah.
- [✔] Display Shalat time by location.
- [✔] Bookmark and save favorite verses.
- [✔] Audio recitations of Quranic verses.
- [✔] User-friendly and responsive design.
- [In Progress] Night mode for comfortable reading at night.
- [In Progress] Setting for changing font size, font type, language, etc.
- [In Progress] Display Quranic text with tajweed.

## Installation
To run this Flutter project on your local machine, follow these steps:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/rfaturriza/quran_flutter.git

2. **Navigate to the project directory:**

   ```bash
   cd quran_flutter

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
We welcome contributions from the community to help improve and expand the Aplikasi Quran project. If you'd like to contribute, please follow these guidelines:

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
We appreciate your interest in contributing to the Aplikasi Quran project!
