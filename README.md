# VetLig (farmhand-vet)

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

**VetLig** is a full-stack mobile application designed to bridge the gap between livestock farmers and veterinary professionals in Namibia and eventually across Africa. The platform provides a directory of verified veterinarians, user authentication, and direct contact functionalities, empowering farmers with timely access to animal healthcare.

This repository contains the complete source code for both the **Flutter frontend** and the **Python (FastAPI) backend**.

## Table of Contents

- [Key Features](#key-features)
- [Project Structure](#project-structure)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Backend Setup](#backend-setup)
  - [Frontend Setup](#frontend-setup)
- [Usage](#usage)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

## Key Features

- **User Authentication:** Secure user registration and login for both farmers and veterinarians. Persistent sessions keep users logged in.
- **Vet Directory:** A searchable and filterable list of verified veterinarians.
- **Vet Profiles:** Detailed view for each vet, showing their qualifications, contact information, and more.
- **User Profiles:** Logged-in users can view their own profile information.
- **Native Integration:** "Call Now" and "Send Message" buttons that integrate with the device's native dialer and messaging apps.
- **Full-Stack Architecture:** A robust FastAPI backend connected to a modern Flutter frontend.

## Project Structure

This project is a monorepo containing two primary sub-projects:


## Technology Stack

### Backend
- **Framework:** [FastAPI](https://fastapi.tiangolo.com/)
- **Language:** Python 3.9+
- **Database:** [PostgreSQL](https://www.postgresql.org/)
- **Authentication:** JWT (JSON Web Tokens)
- **ORM:** [SQLAlchemy](https://www.sqlalchemy.org/)

### Frontend
- **Framework:** [Flutter](https://flutter.dev/)
- **Language:** Dart
- **State Management:** `StatefulWidget` with `setState`
- **API Communication:** `http` package
- **Secure Storage:** `flutter_secure_storage`

## Getting Started

Follow these instructions to get a local copy of the project up and running for development and testing.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Python](https://www.python.org/downloads/) (version 3.9 or higher)
- [PostgreSQL](https://www.postgresql.org/download/) database server
- [Git](https://git-scm.com/downloads/)

### Backend Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/perinai/farmhand-vet.git
    cd farmhand-vet
    ```

2.  **Navigate to the backend directory:**
    ```bash
    cd backend
    ```

3.  **Create and activate a Python virtual environment:**
    ```bash
    python -m venv venv
    # On Windows
    .\venv\Scripts\activate
    # On macOS/Linux
    source venv/bin/activate
    ```

4.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

5.  **Configure your database:**
    - Create a `.env` file in the `backend` directory.
    - Add your database connection string and a secret key:
      ```env
      DATABASE_URL="postgresql://USER:PASSWORD@localhost/vetlig"
      SECRET_KEY="your_super_secret_key_here"
      ```

6.  **Run the backend server:**
    ```bash
    # Make sure you are in the root VetLig directory
    cd ..
    uvicorn backend.main:app --reload
    ```
    The server will be running at `http://127.0.0.1:8000`.

### Frontend Setup

1.  **Navigate to the frontend directory:**
    ```bash
    cd frontend
    ```

2.  **Get Flutter packages:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    - Ensure a device is running (Windows, Chrome, or an Android emulator).
    - Run the app:
      ```bash
      flutter run
      ```

## Usage

Once both the backend and frontend are running:
1.  Register a new account through the application's UI.
2.  Register at least one "vet" user and manually verify them in the database (`vet_profiles` table, set `is_verified` to `true`).
3.  Log in as any user to view the list of verified vets.
4.  Search, view details, and test the contact buttons.

## Roadmap

- [ ] **Android Build:** Finalize the setup for building and running on Android devices.
- [ ] **Pull-to-Refresh:** Implement pull-to-refresh on the vet directory.
- [ ] **Role-Based UI:** Show a different home screen for logged-in vets.
- [ ] **Appointment Booking:** A full scheduling system.
- [ ] **Real-Time Chat:** Direct messaging between farmers and vets.

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.