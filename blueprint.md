# Project Blueprint

## Overview

This document outlines the structure, features, and design of the Flutter application "CEOLIN mobilidade urbana".

## Current Version

### Features

*   **Login Screen:** A modern login screen with two distinct user flows:
    *   "Login Motorista" navigates to the `DriverDashboardScreen`.
    *   "Login Administrador" navigates to the `AdminDashboardScreen`.
*   **Driver Dashboard Screen (Modernized):**
    *   **Dynamic Scrolling UI:** A `CustomScrollView` provides a fluid user experience.
    *   **Collapsible App Bar:** A `SliverAppBar` creates a header that elegantly expands and collapses on scroll.
    *   **Pull-to-Refresh:** Allows drivers to refresh ride requests with a simple pull-down gesture.
*   **Admin Dashboard Screen:** 
    *   A dedicated placeholder screen (`lib/admin_dashboard_screen.dart`) for future administrator features.
*   **Profile Picture Management:**
    *   An interactive, WhatsApp-style modal for managing the driver's profile picture.
*   **Tabbed Navigation (`DriverDashboardScreen`):**
    *   **Solicitações:** A functional UI displaying a list of incoming ride requests, with sound and visual notifications for new rides. Includes logic for accepting and rejecting rides.
    *   **Conversas:** A functional `ListView` that displays a list of chats with passengers.
    *   **Histórico:** A functional `ListView` that displays a list of completed rides.
    *   **Perfil:** A settings screen with interactive options for personal info, vehicle, and app settings. Includes a confirmation dialog for logging out.
*   **Profile Management Screens:**
    *   **Informações Pessoais:** A screen where drivers can view and edit their personal information.
    *   **Veículo e Documentos:** A screen for managing vehicle information and document uploads.
    *   **Configurações de Corrida:** A screen for defining fare types and values.
*   **Error Handling and Permissions:**
    *   Robust handling for image loading and permissions for camera/gallery access.
*   **Audio Notifications:**
    *   Plays a sound in a loop when a new ride request is simulated.
*   **Ride Navigation Screen:**
    *   A dedicated screen (`lib/screens/corrida_navigation_screen.dart`) with a `GoogleMap` widget to display the map during a ride.
    *   Navigation to this screen is triggered when a ride is accepted.

### Design

*   **App Name:** "CEOLIN mobilidade urbana".
*   **Theme:** A consistent color scheme of blue, red, and white.
*   **Typography:** Custom fonts (Oswald and Roboto) via `google_fonts`.
*   **Layout:**
    *   **Login:** A visually appealing screen with a gradient background and modern, shadowed buttons.
    *   **Driver Dashboard:** A sophisticated layout featuring a `SliverAppBar` for a dynamic, collapsible profile header.
    *   **Conversas Tab:** A clean `ListTile`-based design for chat previews.
    *   **Histórico Tab:** A `Card`-based design for the ride history.
    *   **Perfil Tab:** A clean, card-based settings screen inspired by modern applications, using `ListTile`s with clear icons and navigation cues (`chevron_right`).
    *   **Ride Requests:** Professional `Card`-based design for clarity.

## Plan for Current Request

*   **Enhance Ride Navigation Screen:** Add passenger information and ride controls to the `CorridaNavigationScreen`.
*   **Design the UI:** Create a user-friendly interface with the map as the central element, along with passenger details and ride controls.
*   **Update Documentation:** Document the new enhancements in the `blueprint.md`.
