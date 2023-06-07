
# Мобильное приложение "Книга жестов"

## Запуск

##### Prerequisites

В файле gradle.build нужно установить версию java, которая используется для сборки android-приложения:

compileOptions {
    sourceCompatibility JavaVersion.VERSION_<java_version>
    targetCompatibility JavaVersion.VERSION_<java_version>
}

Перед запуском программы необходимо установить:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio) (для запуска на андроид устройствах и эмуляторах)

Конфигурационный файл приложения app_settings.json расположен в директории assets/config. По умолчанию приложение запускается в режиме dev (переменная среды "env"), в котором api запросы не выполняются. Для запуска приложения в режиме работы с сетью нужно изменить значение переменной на "prod" и указать адрес сервера в переменной "domain".

##### Команды

Перед запуском выполнить:
`flutter pub get`
Запуск приложения на подключенном устройстве:
`flutter run`

*Подключение устройства (с помощью командной строки)*
Показать список доступных устройств для подключения:
`flutter devices`
Подключить устройство:
`flutter attach -d device_id` ,  где device_id - id подключаемого устройства

### Дополнительно

Очистить папки  build/ and .dart_tool/:
`flutter clean`
Генерация файлов:
`flutter packages pub run build_runner build --delete-conflicting-outputs`
Включить наблюдатель для автоматического ребилда файлов:
`flutter packages pub run build_runner watch`
