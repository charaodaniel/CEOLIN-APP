# Project Blueprint

## Overview

This document outlines the structure, features, and design of the Flutter application "CEOLIN mobilidade urbana".

---

## Integração com Planilhas Google

### Visão Geral

Esta seção detalha como configurar a sincronização de dados do histórico de corridas do aplicativo Flutter para uma Planilha Google em tempo real. A integração utiliza um Google Apps Script, que funciona como uma API, para receber os dados do aplicativo e espelhá-los na planilha. Uma cópia do script necessário está salva neste projeto no arquivo `google_sheets_api_script.js`.

### Passo 1: Preparar a Planilha e o Script

1.  **Crie uma Nova Planilha:**
    *   Acesse o [Google Sheets](https://sheets.new) e crie uma nova planilha em branco.
    *   Renomeie a primeira aba (página) para **`Página1`**. *Atenção: o nome deve ser exatamente este, pois o script a procura por este nome.*

2.  **Abra o Editor de Scripts:**
    *   Com a planilha aberta, vá ao menu **Extensões > Apps Script**.

3.  **Cole o Código do Script:**
    *   No seu projeto, abra o arquivo `google_sheets_api_script.js` e copie todo o seu conteúdo.
    *   No editor do Apps Script, apague qualquer código de exemplo e cole o código que você copiou.
    *   Clique no ícone de **Salvar projeto** (disquete).

### Passo 2: Implantar o Script como um App da Web

1.  **Inicie a Implantação:**
    *   No editor do Apps Script, clique no botão azul **Implantar** e selecione **Nova implantação**.

2.  **Configure o App da Web:**
    *   Clique no ícone de engrenagem (ao lado de "Selecione o tipo") e escolha **App da Web**.
    *   Na tela de configuração, preencha os seguintes campos:
        *   **Descrição:** `API para App de Corridas CEOLIN`
        *   **Executar como:** `Eu (seu-email@gmail.com)`
        *   **Quem pode acessar:** **MUITO IMPORTANTE:** Altere para **`Qualquer pessoa`**. Isso permite que o aplicativo Flutter (que é um sistema externo) envie dados para a planilha.

3.  **Implante e Autorize:**
    *   Clique em **Implantar**.
    *   O Google solicitará permissão para o script acessar e modificar sua planilha. Clique em **Autorizar acesso**.
    *   Escolha sua conta Google. Você verá um aviso de "App não verificado". Isso é normal. Clique em **Avançado** e, em seguida, em **Acessar... (não seguro)**.

4.  **Copie a URL do App da Web:**
    *   Após a autorização, uma janela mostrará a **URL do App da Web**. Esta URL é o endereço da sua nova API. **Copie esta URL**, pois você a usará no próximo passo.

### Passo 3: Conectar o Aplicativo Flutter

1.  **Abra o Arquivo Correto:**
    *   No seu projeto Flutter, navegue e abra o arquivo `lib/widgets/historico_tab.dart`.

2.  **Insira a URL:**
    *   Localize a variável `webAppUrl` dentro da função `syncToGoogleSheets()`.
    *   **Substitua** o valor `'SUA_URL_DO_APP_DA_WEB_VEM_AQUI'` pela URL que você copiou no passo anterior.

    ```dart
    // Exemplo de como deve ficar:
    const String webAppUrl = 'https://script.google.com/macros/s/ABC...XYZ/exec';
    ```

3.  **Execute o Aplicativo:**
    *   Salve o arquivo e execute seu aplicativo. Navegue até a aba **Histórico** e clique no ícone de **sincronização** (nuvem com seta). Os dados da lista de corridas serão enviados e aparecerão na sua planilha.

---

## Current Version Features

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
    *   **Histórico:** A functional `ListView` that displays a list of completed rides. It includes:
        *   **Manual Ride Entry:** A floating action button allows drivers to manually register a new ride through a dedicated form.
        *   **Date-based Filtering:** Users can filter the ride history by selecting a date range.
        *   **Report Export:** Users can export the current view (either full or filtered history) to both **PDF** and **CSV** formats for financial tracking.
    *   **Perfil:** A settings screen with interactive options for personal info, vehicle, and app settings. Includes a confirmation dialog for logging out.
*   **Google Sheets Integration:**
    *   A "Sync to Cloud" button in the History tab allows drivers to mirror their entire ride history to a designated Google Sheet via a custom Google Apps Script API.
*   **Profile Management Screens:**
    *   **Informações Pessoais:** A screen where drivers can view and edit their personal information.
    *   **Veículo e Documentos:** A screen for managing vehicle information and document uploads.
    *   **Configurações de Corrida:** A screen for defining fare types and values.
*   **Ride Navigation Screen:**
    *   A dedicated screen (`lib/screens/corrida_navigation_screen.dart`) with a `GoogleMap` widget to display the map during a ride.
    *   Navigation to this screen is triggered when a ride is accepted.
*   **Code Architecture:**
    *   **Model-View Separation:** The `RideHistory` data model is separated into its own file (`lib/models/ride_history_model.dart`) for better organization.
    *   **Service Layer:** A `ReportGenerator` service (`lib/services/report_generator.dart`) encapsulates the logic for creating PDF and CSV files, promoting code reuse and separation of concerns.
*   **Error Handling and Permissions:**
    *   Robust handling for image loading and permissions for camera/gallery and storage access.
*   **Audio Notifications:**
    *   Plays a sound in a loop when a new ride request is simulated.

### Design

*   **App Name:** "CEOLIN mobilidade urbana".
*   **Theme:** A consistent color scheme of blue, red, and white.
*   **Typography:** Custom fonts (Oswald and Roboto) via `google_fonts`.
*   **Layout:**
    *   **Login:** A visually appealing screen with a gradient background and modern, shadowed buttons.
    *   **Driver Dashboard:** A sophisticated layout featuring a `SliverAppBar` for a dynamic, collapsible profile header.
    *   **Conversas Tab:** A clean `ListTile`-based design for chat previews.
    *   **Histórico Tab:** A `Card`-based design for the ride history with clear visual indicators for active filters.
    *   **Perfil Tab:** A clean, card-based settings screen inspired by modern applications, using `ListTile`s with clear icons and navigation cues (`chevron_right`).
    *   **Ride Requests:** Professional `Card`-based design for clarity.

## Plan for Current Request

*   **COMPLETED:** All requested features, including manual ride entry, filtering, and report exporting, have been implemented.
