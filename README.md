# CEOLIN mobilidade urbana

Este é o repositório oficial do aplicativo de mobilidade urbana "CEOLIN", desenvolvido com Flutter. O projeto visa fornecer uma plataforma robusta e amigável para motoristas gerenciarem suas corridas, interações com passageiros e perfil profissional.

## ✨ Visão Geral

O aplicativo está sendo construído com foco em uma experiência de usuário moderna, desempenho e escalabilidade. Atualmente, ele oferece dois fluxos de login distintos (Motorista e Administrador) e um painel de controle completo para o motorista.

## 🚀 Funcionalidades Implementadas

*   **Autenticação:**
    *   Tela de login com design moderno e duas opções de acesso: "Login Motorista" e "Login Administrador".

*   **Painel do Motorista (`DriverDashboardScreen`):**
    *   **UI Dinâmica:** A interface utiliza `CustomScrollView` e `SliverAppBar` para um efeito de cabeçalho que se expande e retrai, exibindo as informações do perfil do motorista de forma elegante.
    *   **Puxar para Atualizar:** Funcionalidade de `pull-to-refresh` para atualizar a lista de solicitações de corrida.
    *   **Navegação por Abas:**
        *   **Solicitações:** Exibe uma lista de corridas pendentes em `Card`s informativos.
        *   **Conversas:** Apresenta um histórico de chats com passageiros.
        *   **Histórico:** Mostra um registro de corridas concluídas.
        *   **Perfil:** (Placeholder para futuras funcionalidades).

*   **Gestão de Perfil:**
    *   O motorista pode tocar em sua foto de perfil para abrir um modal e:
        *   Visualizar a foto atual.
        *   Alterar a foto usando a **Câmera** ou a **Galeria**.
        *   Remover a foto.

*   **Painel do Administrador (`AdminDashboardScreen`):**
    *   Uma tela dedicada foi criada como um placeholder para futuras funcionalidades de gerenciamento.

## 🎨 Design e Tecnologia

*   **Framework:** Flutter 3.x
*   **Linguagem:** Dart
*   **Design:**
    *   Interface inspirada no Material Design 3.
    *   Uso do pacote `google_fonts` (Oswald e Roboto) para uma tipografia consistente e moderna.
    *   Layouts responsivos e visualmente atraentes com `Card`s, `ListTile`s e efeitos de sombra.
*   **Pacotes Principais:**
    *   `google_fonts`: Para fontes personalizadas.
    *   `image_picker`: Para selecionar imagens da galeria ou câmera.
    *   `permission_handler`: Para gerenciar permissões de forma robusta.

## 🏁 Como Começar

Para executar este projeto localmente, siga os passos abaixo:

1.  **Clone o repositório:**
    ```sh
    git clone <URL_DO_REPOSITORIO>
    ```

2.  **Navegue até o diretório do projeto:**
    ```sh
    cd ceolin_mobilidade_urbana
    ```

3.  **Instale as dependências:**
    ```sh
    flutter pub get
    ```

4.  **Execute o aplicativo:**
    ```sh
    flutter run
    ```

## 📄 Estrutura do Projeto

*   `lib/`: Contém todo o código-fonte Dart.
    *   `main.dart`: O ponto de entrada da aplicação.
    *   `login_screen.dart`: A tela de login.
    *   `driver_dashboard_screen.dart`: O painel principal do motorista.
    *   `admin_dashboard_screen.dart`: O painel do administrador.
    *   `widgets/`: Contém os widgets reutilizáveis, como as abas (`solicitacoes_tab.dart`, `conversas_tab.dart`, etc.).
