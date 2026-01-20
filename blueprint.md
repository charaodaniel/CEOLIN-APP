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
*   **Profile Picture Management:**
    *   **Interactive Modal:** Clicking the profile picture opens a modern, WhatsApp-style modal.
    *   **View Picture:** An option to view the profile picture in a full-screen, zoomable view (`profile_picture_screen.dart`).
    *   **Change Picture:** Users can change their profile picture by selecting an image from their device's **Gallery** or taking a new one with the **Camera** (using `image_picker`).
    *   **Remove Picture:** An option to remove the current profile picture and revert to the default one.
    *   **State Management:** The dashboard is a `StatefulWidget` to dynamically manage and display the updated profile picture.

### Design

*   **App Name:** The application's name is "CEOLIN mobilidade urbana".
*   **Theme:** The application uses a blue, red, and white color scheme.
*   **Typography:** The `google_fonts` package is used for custom fonts (Oswald and Roboto).
*   **Layout:**
    *   The login screen has a centered column with a welcome message and two buttons, featuring icons, shadows, and rounded corners for a modern look.
    *   The driver dashboard screen has a clean layout with a profile section and a tab bar for navigation.
*   **Background:** A gradient from dark to light blue is used as the background for the login screen. The driver dashboard has a white background.
*   **Profile Modal:** The modal for profile picture options is styled with a title, circular icon buttons for actions ("Ver Foto", "Galeria", "Câmera"), and a clear "Remover foto" option, inspired by modern mobile UI patterns.

## Plan for Current Request

*   **Implement a modern, WhatsApp-style modal** for profile picture options.
*   **Add options to the modal:** "Ver Foto", "Galeria", "Câmera", and "Remover foto".
*   **Create a new screen (`profile_picture_screen.dart`)** to display the profile picture in full-screen with zoom functionality.
*   **Integrate the `image_picker` package** to allow users to select images from the gallery or camera.
*   **Convert `DriverDashboardScreen` to a `StatefulWidget`** to manage the state of the profile picture.
*   **Implement the logic** to update the `CircleAvatar` with the new image and handle image removal.
*   **Update the `blueprint.md`** to reflect all the new features and design changes.
