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
    *   **Solicitações:** A functional UI displaying a list of incoming ride requests.
    *   **Conversas:** A functional `ListView` that displays a list of chats with passengers.
    *   **Histórico:** A functional `ListView` that displays a list of completed rides.
    *   **Perfil:** A settings screen with interactive options for personal info, vehicle, and app settings. Includes a confirmation dialog for logging out.
*   **Error Handling and Permissions:**
    *   Robust handling for image loading and permissions for camera/gallery access.

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

*   **Create "Informações Pessoais" Screen:** Develop a new screen where drivers can view and edit their personal information.
*   **Implement Navigation:** Add navigation from the "Perfil" tab to the new screen.
*   **Design the UI:** Create a user-friendly interface with editable text fields for personal details.
*   **Update Documentation:** Document the new screen in the `blueprint.md`.
