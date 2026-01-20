# Food Sharing Platform - Projeto II

A full-stack web application for sharing and selling food products between users. This platform enables users to create food advertisements, manage reservations, communicate with other users, rate transactions, and includes admin moderation features.

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [Project Structure](#project-structure)
- [API Documentation](#api-documentation)
- [Testing](#testing)
- [Contributing](#contributing)

## ✨ Features

### User Features
- **User Authentication**: Secure registration and login with JWT authentication
- **User Profiles**: Complete profile management with avatars and user information
- **Food Advertisements**: Create, edit, and manage food product listings
- **Search & Browse**: Filter and search through available food advertisements
- **Reservations**: Book and manage food product reservations
- **Real-time Messaging**: Communicate with other users through the integrated messaging system
- **Notifications**: Receive updates about reservations, messages, and account activities
- **Rating System**: Rate and review transactions with other users
- **User Blocking**: Block unwanted users to prevent interactions
- **Report System**: Report inappropriate content or behavior

### Admin Features
- **User Management**: View and manage user accounts
- **Content Moderation**: Review and handle user reports
- **Block Management**: Moderate user blocks and restrictions
- **Advertisement Oversight**: Monitor and manage all listings

### Payment Integration
- **PayPal Integration**: Secure payment processing for transactions

## 🛠 Tech Stack

### Frontend
- **Vue 3**: Progressive JavaScript framework
- **Vue Router**: Official router for Vue.js
- **Vite**: Next-generation frontend tooling
- **Bootstrap 5**: CSS framework for responsive design
- **Bootstrap Icons**: Icon library
- **Jest**: JavaScript testing framework
- **Selenium WebDriver**: Browser automation for E2E testing

### Backend
- **Node.js**: JavaScript runtime
- **Express**: Web application framework
- **Sequelize**: Promise-based ORM for Node.js
- **MySQL**: Relational database management system
- **JWT**: JSON Web Tokens for authentication
- **Bcrypt**: Password hashing library
- **Cloudinary**: Cloud-based image management
- **Multer**: Middleware for handling multipart/form-data
- **CORS**: Cross-Origin Resource Sharing middleware
- **Nodemon**: Development utility for auto-restarting

## 📦 Prerequisites

Before you begin, ensure you have the following installed:
- **Node.js** (v16 or higher)
- **npm** (v8 or higher)
- **MySQL** (v8 or higher)
- **Git**

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Projeto-2
```

### 2. Install Client Dependencies

```bash
cd Client
npm install
```

### 3. Install Server Dependencies

```bash
cd ../Server
npm install
```

## ⚙️ Configuration

### Database Setup

1. Create a MySQL database for the project
2. Import the database schema (if provided) or let Sequelize create tables

### Server Configuration

Create a `.env` file in the `Server` directory with the following variables:

```env
# Server Configuration
PORT=3000
HOST=localhost

# Database Configuration
DB_HOST=localhost
DB_USER=your_database_user
DB_PASSWORD=your_database_password
DB_NAME=your_database_name
DB_PORT=3306

# JWT Configuration
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=24h

# Cloudinary Configuration
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_API_KEY=your_cloudinary_api_key
CLOUDINARY_API_SECRET=your_cloudinary_api_secret

# PayPal Configuration (Optional)
PAYPAL_CLIENT_ID=your_paypal_client_id
PAYPAL_CLIENT_SECRET=your_paypal_client_secret
PAYPAL_MODE=sandbox # or live for production
```

### Client Configuration

Create a `.env` file in the `Client` directory (if needed):

```env
VITE_API_URL=http://localhost:3000
```

## 🏃 Running the Application

### Development Mode

#### Start the Backend Server

```bash
cd Server
npm run dev
# Or without nodemon:
node server.js
```

The server will start on `http://localhost:3000` (or your configured PORT)

#### Start the Frontend Development Server

```bash
cd Client
npm run dev
```

The client will start on `http://localhost:5173` (Vite default)

### Production Mode

#### Build the Client

```bash
cd Client
npm run build
```

#### Preview Production Build

```bash
npm run preview
```

#### Run Production Server

```bash
cd Server
node server.js
```

## 📁 Project Structure

```
Projeto-2/
├── Client/                      # Frontend Vue.js application
│   ├── public/                  # Static assets
│   ├── src/
│   │   ├── api/                 # API service modules
│   │   │   ├── anuncio.js
│   │   │   ├── utilizador.js
│   │   │   ├── avaliacoes.js
│   │   │   ├── notificacoes.js
│   │   │   └── ...
│   │   ├── assets/              # Stylesheets and images
│   │   ├── components/          # Reusable Vue components
│   │   │   ├── Navbar.vue
│   │   │   ├── Footer.vue
│   │   │   ├── FoodCard.vue
│   │   │   ├── AdminSidebar.vue
│   │   │   └── ...
│   │   ├── router/              # Vue Router configuration
│   │   ├── views/               # Page components
│   │   │   ├── HomePageView.vue
│   │   │   ├── LoginPageView.vue
│   │   │   ├── ProfilePageView.vue
│   │   │   └── ...
│   │   ├── tests/               # Test files
│   │   ├── App.vue              # Root component
│   │   └── main.js              # Application entry point
│   ├── index.html
│   ├── package.json
│   ├── vite.config.js
│   └── jest.config.js
│
├── Server/                      # Backend Node.js application
│   ├── config/                  # Configuration files
│   │   └── cloudinaryConfig.js
│   ├── controllers/             # Route controllers
│   │   ├── anuncios.controllers.js
│   │   ├── utilizadores.controllers.js
│   │   ├── avaliaçoes.controller.js
│   │   ├── mensagens.controllers.js
│   │   ├── notificacoes.controller.js
│   │   └── ...
│   ├── middleware/              # Custom middleware
│   │   ├── jwtAuth.js
│   │   └── multerErrorHandler.js
│   ├── models/                  # Sequelize models
│   │   ├── db.js
│   │   ├── anuncios.model.js
│   │   ├── utilizador.models.js
│   │   ├── avaliaçoes.models.js
│   │   └── ...
│   ├── routes/                  # Express routes
│   │   ├── anuncios.routes.js
│   │   ├── utilizadores.routes.js
│   │   ├── avaliacoes.routes.js
│   │   └── ...
│   ├── uploads/                 # Temporary upload directory
│   ├── utils/                   # Utility functions
│   │   └── error.js
│   ├── server.js                # Application entry point
│   └── package.json
│
└── README.md                    # This file
```

## 📡 API Documentation

### Base URL
```
http://localhost:3000
```

### Main Endpoints

#### Authentication & Users
- `POST /utilizadores/register` - Register new user
- `POST /utilizadores/login` - User login
- `GET /utilizadores/profile` - Get user profile
- `PUT /utilizadores/profile` - Update user profile
- `POST /utilizadores/confirm-code` - Confirm user verification code

#### Advertisements (Anuncios)
- `GET /anuncios` - Get all advertisements
- `GET /anuncios/:id` - Get advertisement by ID
- `POST /anuncios` - Create new advertisement (authenticated)
- `PUT /anuncios/:id` - Update advertisement (authenticated)
- `DELETE /anuncios/:id` - Delete advertisement (authenticated)

#### Ratings (Avaliacoes)
- `GET /avaliacoes` - Get all ratings
- `GET /avaliacoes/:id` - Get rating by ID
- `POST /avaliacoes` - Create new rating (authenticated)

#### Reports (Denuncias)
- `GET /denuncias` - Get all reports (admin)
- `POST /denuncias` - Create new report (authenticated)
- `PUT /denuncias/:id` - Update report status (admin)

#### Messages (Mensagens)
- `GET /mensagens` - Get user messages (authenticated)
- `POST /mensagens` - Send message (authenticated)

#### Notifications (Notificacoes)
- `GET /notificacoes` - Get user notifications (authenticated)
- `PUT /notificacoes/:id` - Mark notification as read (authenticated)

#### Blocks (Bloqueios)
- `GET /bloqueios` - Get user blocks (authenticated)
- `POST /bloqueios` - Block a user (authenticated)
- `DELETE /bloqueios/:id` - Unblock a user (authenticated)

#### Categories (Categorias)
- `GET /categorias` - Get all product categories

> **Note**: All authenticated endpoints require a valid JWT token in the Authorization header:
> ```
> Authorization: Bearer <token>
> ```

## 🧪 Testing

### Run Client Tests

```bash
cd Client
npm test
```

### Run Selenium Tests

```bash
cd Client/src/tests/selenium
node <test-file>.js
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style Guidelines

- Follow Vue 3 Composition API best practices
- Use ES6+ JavaScript features
- Maintain consistent indentation (2 spaces)
- Write meaningful commit messages
- Add comments for complex logic
- Ensure all tests pass before submitting PR

## 👥 Development Team

- **José Guedes** - Full-Stack Developer [40230110@esmad.ipp.pt]
- **Eduardo Sousa** - Full-Stack Developer [40230115@esmad.ipp.pt]
- **Xavier Kooijman** - Full-Stack Developer [40220456@esmad.ipp.pt]  

## 📝 License

This project is developed as part of the academic curriculum at **Instituto Politécnico do Porto**.

---

**Note**: This is an academic project developed for educational purposes.
