
# Task Manager App

A simple Task Manager application with a Flutter frontend and a Laravel backend. The project allows users to register, log in, and manage their tasks.

## Tech Stack

*   **Backend:** Laravel, PHP, Laravel Sanctum, MySQL
*   **Frontend:** Flutter, Dart, Provider (for state management)

## Prerequisites

Before you begin, ensure you have the following installed on your system:

*   PHP (version 8.1 or higher)
*   Composer
*   A local server environment like XAMPP, WAMP, or MAMP (for MySQL)
*   Flutter SDK (version 3.0 or higher)
*   Node.js and npm (for Laravel dependencies)
*   An IDE like VS Code or Android Studio

---

## Backend Setup (Laravel API)

Follow these steps to get the backend server running. All commands should be executed from the `backend` directory of the project.

1.  **Navigate to the backend directory:**
    ```bash
    cd backend
    ```

2.  **Install PHP dependencies:**
    ```bash
    composer install
    ```

3.  **Create the environment file:**
    Copy the example environment file.
    ```bash
    cp .env.example .env
    ```

4.  **Generate Application Key:**
    This command will generate a unique key for your application and place it in the `.env` file.
    ```bash
    php artisan key:generate
    ```

5.  **Configure the Database:**
    *   Using a tool like phpMyAdmin, create a new MySQL database. For this guide, we will name it `task_manager`.
    *   Open the `.env` file and update the database connection variables to match your local setup. For a standard XAMPP installation, the configuration should look like this:
    ```env
    DB_CONNECTION=mysql
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE=task_manager
    DB_USERNAME=root
    DB_PASSWORD=
    ```

6.  **Run Database Migrations:**
    This command will create all the necessary tables in your database (`users`, `tasks`, etc.).
    ```bash
    php artisan migrate
    ```

7.  **Start the local server:**
    To ensure the server is accessible from a mobile device on the same network, use the `--host=0.0.0.0` flag.
    ```bash
    php artisan serve --host=0.0.0.0
    ```
    The server will be running at `http://<your-local-ip-address>:8000`.

---

## Frontend Setup (Flutter App)

Follow these steps to get the mobile application running.

1.  **Navigate to the frontend directory:**
    ```bash
    cd frontend/manager_test_task
    ```

2.  **Install Flutter dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure the API URL (Crucial Step):**
    The Flutter application needs to know the address of the running Laravel backend.
    *   Open the file: `lib/services/api_service.dart`.
    *   Find the `_baseUrl` variable at the top of the `ApiService` class.
    *   **You must replace the IP address in this string depending on where you run the app.**

    **Scenario A: Running on the same PC (Windows/Web build)**
    If you are running the Flutter app as a Windows desktop app or in a browser, use `localhost`.
    ```dart
    final String _baseUrl = "http://127.0.0.1:8000/api";
    ```

    **Scenario B: Running on the Android Emulator**
    For the official Android Emulator, use the special alias `10.0.2.2`, which points to your computer's `localhost`.
    ```dart
    final String _baseUrl = "http://10.0.2.2:8000/api";
    ```    
    **Scenario C: Running on a Physical Phone (Android/iOS)**
    The phone and the computer must be connected to the **same Wi-Fi network**.
    1.  On the computer running the Laravel server, open a terminal (or Command Prompt on Windows).
    2.  Run the command `ipconfig` (on Windows) or `ifconfig` / `ip addr` (on macOS/Linux).
    3.  Find the "IPv4 Address" of your Wi-Fi adapter. It usually looks like `192.168.x.x`.
    4.  Use this IP address in the code.

    *Example, if your IPv4 address is `192.168.1.10`*:
    ```dart
    final String _baseUrl = "http://192.168.1.10:8000/api";
    ```

4.  **Run the application:**
    Connect a physical device or start an emulator, then run the following command from the project root:
    ```bash
    flutter run
    ```

## Assumptions & Notes

*   This project is configured for a local development environment where the backend and frontend are on the same network.
*   The user interface is based on the provided sample images but is not a pixel-perfect implementation. Features shown in the UI but not mentioned in the text requirements (e.g., categories, start/end times) have not been implemented.
*   State management in the Flutter application is handled using the `Provider` package.

---

<br>

# Приложение "Менеджер Задач"

Простое приложение для управления задачами с фронтендом на Flutter и бэкендом на Laravel. Проект позволяет пользователям регистрироваться, входить в систему и управлять своими задачами (создавать, просматривать, редактировать, удалять).

## Технологический стек

*   **Бэкенд:** Laravel, PHP, Laravel Sanctum, MySQL
*   **Фронтенд:** Flutter, Dart, Provider (для управления состоянием)

## Требования для запуска

Перед началом убедитесь, что на вашем компьютере установлены:

*   PHP (версия 8.1 или выше)
*   Composer
*   Локальный сервер (например, XAMPP, WAMP, MAMP) для работы с MySQL
*   Flutter SDK (версия 3.0 или выше)
*   Node.js и npm (требуется для установки зависимостей Laravel)
*   Среда разработки, например VS Code или Android Studio

---

## Настройка Бэкенда (Laravel API)

Следуйте этим шагам, чтобы запустить серверную часть. Все команды необходимо выполнять в терминале из директории `backend`.

1.  **Перейдите в директорию бэкенда:**
    ```bash
    cd backend
    ```

2.  **Установите PHP-зависимости:**
    Эта команда скачает все необходимые библиотеки для работы Laravel.
    ```bash
    composer install
    ```

3.  **Создайте файл окружения:**
    Скопируйте файл с примером переменных окружения.
    ```bash
    cp .env.example .env
    ```

4.  **Сгенерируйте ключ приложения:**
    Эта команда создаст уникальный ключ шифрования и запишет его в файл `.env`.
    ```bash
    php artisan key:generate
    ```

5.  **Настройте подключение к базе данных:**
    *   С помощью инструмента вроде phpMyAdmin создайте новую базу данных MySQL. Для этого руководства мы назовем ее `task_manager`.
    *   Откройте файл `.env` и измените переменные для подключения к вашей базе данных. Для стандартной установки XAMPP они будут выглядеть так:
    ```env
    DB_CONNECTION=mysql
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE=task_manager
    DB_USERNAME=root
    DB_PASSWORD=
    ```

6.  **Выполните миграции базы данных:**
    Эта команда создаст в вашей базе данных все необходимые таблицы (`users`, `tasks` и другие).
    ```bash
    php artisan migrate
    ```

7.  **Запустите локальный сервер:**
    Чтобы сервер был доступен с мобильного устройства в той же сети, используйте флаг `--host=0.0.0.0`.
    ```bash
    php artisan serve --host=0.0.0.0
    ```
    Сервер будет запущен по адресу `http://<ваш-локальный-ip-адрес>:8000`.

---

## Настройка Фронтенда (Flutter приложение)

Следуйте этим шагам, чтобы запустить мобильное приложение.

1.  **Перейдите в директорию фронтенда:**
    ```bash
    cd frontend/manager_test_task
    ```

2.  **Установите Flutter-зависимости:**
    ```bash
    flutter pub get
    ```

3.  **Настройте URL для API (Важный шаг):**
    Приложение должно знать, по какому адресу обращаться к вашему бэкенду.
    *   Откройте файл `lib/services/api_service.dart`.
    *   Найдите переменную `_baseUrl` в начале класса `ApiService`.
    *   **Вам нужно заменить IP-адрес в этой строке в зависимости от того, где вы запускаете приложение.**

    **Сценарий A: Запуск на том же компьютере (Windows/Веб-версия)**
    Если вы запускаете Flutter-приложение как десктопное приложение для Windows или в браузере (Chrome), используйте `localhost`.
    ```dart
    final String _baseUrl = "http://127.0.0.1:8000/api";
    ```

    **Сценарий Б: Запуск на эмуляторе Android**
    Для стандартного эмулятора Android используйте специальный псевдоним `10.0.2.2`, который указывает на `localhost` вашего компьютера.
    ```dart
    final String _baseUrl = "http://10.0.2.2:8000/api";
    ```    
    **Сценарий В: Запуск на физическом телефоне (Android/iOS)**
    Телефон и компьютер должны быть подключены к **одной и той же сети Wi-Fi**.
    1.  На компьютере, где запущен сервер Laravel, откройте командную строку (в Windows: `cmd`).
    2.  Выполните команду `ipconfig`.
    3.  Найдите раздел "Адаптер беспроводной локальной сети Wi-Fi" и скопируйте оттуда значение "IPv4-адрес". Обычно он выглядит как `192.168.x.x`.
    4.  Вставьте этот IP-адрес в код.

    *Пример, если ваш IPv4-адрес — `192.168.1.10`*:
    ```dart
    final String _baseUrl = "http://192.168.1.10:8000/api";
    ```

4.  **Запустите приложение:**
    Подключите физическое устройство или запустите эмулятор, а затем выполните команду из корневой папки проекта:
    ```bash
    flutter run
    ```

## Допущения и Примечания

*   Проект рассчитан на запуск в локальной среде разработки, где бэкенд и фронтенд находятся в одной сети.
*   Пользовательский интерфейс основан на предоставленных макетах, но не является их точной копией. Функции, показанные в UI, но не упомянутые в текстовых требованиях (например, категории, время начала/окончания задач), не были реализованы.
*   Управление состоянием в приложении Flutter осуществляется с помощью пакета `Provider`.