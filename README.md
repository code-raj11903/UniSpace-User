# Unispace Flutter Application

Unispace is a Flutter application designed to manage various functionalities within a university resource booking system.

## Table of Contents
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Running the Project](#running-the-project)
- [Directory Structure](#directory-structure)
- [Features](#features)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Getting Started

To start developing and running the Unispace app, you need to have [Flutter](https://flutter.dev) installed. Make sure to install the Flutter SDK and set up the necessary environment variables as described in the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).

You will also need an emulator or a physical device connected to run the application.

## Installation

### Prerequisites

Ensure you have the following installed:
- Flutter SDK: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Git (for cloning the repository)
- A code editor like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Steps

**Clone the Repository**
   
   git clone https://github.com/code-raj11903/UniSpace-User.git

Navigate to the Project Directory
cd flutter_application_1

Install Dependencies After navigating to the project directory, install the Flutter dependencies:
flutter pub get

Run the Project Connect a device or emulator, and then run the following command:
flutter run

Alternatively, you can also use the run button in your code editor (such as Visual Studio Code or Android Studio) to run the app.

**Running the Project**
Once you’ve installed the dependencies, you can run the project as described above. You should ensure that an emulator is running or a physical device is connected.

Additional Run Options
To run on a specific platform (Android/iOS), use:

flutter run -d <platform>
Example:

flutter run -d chrome

For debugging:
flutter run --debug

For release mode (to generate a production-ready app):
flutter build apk --release

**Directory Structure**
The lib folder is the main directory where the core logic of the Flutter application resides. Here is an overview of the directory structure and each folder's purpose:

flutter_application_1/
├── lib/
│   ├── account/
│   │   └── account_settings_page.dart   # Page to manage user account settings
│   │   └── personal_info_page.dart      # Page to manage personal information of the user
│   │   └── profile_page.dart            # User profile page
│   ├── auth/
│   │   └── login_page.dart              # Login page for user authentication
│   │   └── register_page.dart           # Register page for new users
│   ├── checkout/
│   │   └── checkout_page.dart           # Page to handle the checkout process
│   │   └── payments_page.dart           # Page for handling payments
│   ├── home/
│   │   └── filter_sort_page.dart        # Page for filtering and sorting items/resources
│   │   └── home_page.dart               # Main home page displaying resources
│   ├── orders/
│   │   └── cart_page.dart               # Shopping cart page where users can view selected items
│   │   └── order_history_page.dart      # Displays a list of past orders made by the user
│   │   └── order_summary_page.dart      # Summary page after completing an order
│   ├── main.dart                        # Main entry point for the application
├── pubspec.yaml                         # Project's dependencies and assets
├── README.md                            # Project documentation

**Detailed Explanation:**
lib/account/: Handles user-related features like profile management and account settings.
lib/auth/: Contains authentication-related pages like login and registration.
lib/checkout/: Manages checkout and payment processes.
lib/home/: The home page and related pages like filtering and sorting resources.
lib/orders/: Contains pages related to viewing and managing user orders.
pubspec.yaml: The configuration file containing the dependencies and assets used in the project.

**Features**
1.User Authentication: Allows users to register, login, and manage their profiles.
2.Resource Booking: Users can search and book available resources like labs, parking spaces, and more.
3.Order Management: Includes a shopping cart, checkout process, and order history.
4.Payments Integration: Users can make payments for bookings through integrated payment gateways.
5.Filtering and Sorting: Users can filter and sort available resources based on various criteria.

**Contributing**
Contributions are what make the open-source community such a fantastic place to learn, inspire, and create. Any contributions you make are greatly appreciated.

1.Fork the Project.
2.Create your Feature Branch (git checkout -b feature/AmazingFeature).
3.Commit your Changes (git commit -m 'Add some AmazingFeature').
4.Push to the Branch (git push origin feature/AmazingFeature).
5.Open a Pull Request.

**License**
Distributed under the MIT License. See LICENSE for more information.

**C**ontact**
Project Link: https://github.com/code-raj11903/UniSpace-User

### Additional Points:
- **Installation**: This section details how to clone, install dependencies, and run the project.
- **Directory Structure**: A clear breakdown of each directory and its purpose is provided.
- **Running the Project**: Information on how to run the project, including debug options.
- **Features**: List of key features, helping new developers or users understand what the project does.
- **Contributing**: A brief guide on how to contribute to the project.

