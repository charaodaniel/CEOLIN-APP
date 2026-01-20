# Project Blueprint

## Overview

This document outlines the structure, features, and design of the Flutter application "CEOLIN mobilidade urbana".

## Current Version

### Features

*   **Login Screen:** A modern login screen with a "Bem-vindo" message and two buttons:
    *   "Login Motorista"
    *   "Login Administrador"
*   **Driver Dashboard Screen:** A screen for the driver's panel, accessible from the "Login Motorista" button. It includes:
    *   Driver's profile information (picture, name, rating).
    *   An "Online" status switch.
    *   Tabs for "Solicitações", "Histórico", "Conversas", and "Perfil".

### Design

*   **App Name:** The application's name is "CEOLIN mobilidade urbana".
*   **Theme:** The application uses a blue, red, and white color scheme.
*   **Typography:** The `google_fonts` package is used for custom fonts (Oswald and Roboto).
*   **Layout:**
    *   The login screen has a centered column with a welcome message and two buttons, featuring icons, shadows, and rounded corners for a modern look.
    *   The driver dashboard screen has a clean layout with a profile section and a tab bar for navigation.
*   **Background:** A gradient from dark to light blue is used as the background for the login screen. The driver dashboard has a white background.

## Plan for Current Request

*   Create the "Painel do Motorista" screen based on the provided layout.
*   Create the folder structure `lib/src/database` and a placeholder file `banco.js`.
*   Implement the UI for the driver dashboard, including profile information, online status, and tabs.
*   Connect the "Login Motorista" button to navigate to the new dashboard screen.
