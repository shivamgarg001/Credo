# Credo - AI-Powered Business Ledger App (Frontend)

Credo is a full-stack mobile app built to streamline business operations through intelligent invoice management, client relationship management, and query resolution. The frontend is developed using **Flutter**, and integrates seamlessly with the backend, powered by Django REST Framework.

## Features

- **AI-Powered Invoice Extraction**: Extracts invoice data from photos and audio using **Google Gemini API**.
- **Multilingual Support**: Supports 8 languages for a global user base.
- **Client-Supplier Relationship Management**: Users can manage and track client and supplier details.
- **Chat-Based Query Resolution**: Facilitates smooth communication and issue resolution between users.
- **PDF Invoice Generation**: Allows users to generate and share invoices in PDF format.
- **Real-Time Sync**: Syncs with the Django backend for seamless data handling.
  
## Tech Stack

- **Frontend**: Flutter
- **State Management**: Provider (or any state management solution you used)
- **API**: REST API calls to the Django backend
- **PDF Generation**: Flutter libraries for PDF creation
- **Internationalization (i18n)**: Multi-language support for 8 languages
- **Libraries**:
  - `http` – For API requests
  - `flutter_localizations` – For multilingual support
  - `pdf` – For generating PDF invoices
  - `cloudinary` – For media storage integration

## Setup & Installation

### Prerequisites

- Flutter SDK (version 3.x or higher)
- Android Studio or VS Code with Flutter plugin installed
- An emulator or a physical device for testing

### Clone the Repository

```bash
git clone https://github.com/shivamgarg001/Credo-Frontend.git
cd Credo-Frontend
