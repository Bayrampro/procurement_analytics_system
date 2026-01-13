# Инструкция по сборке установщика Windows

## Автоматическая сборка через GitHub Actions

При каждом push в ветку `main` или `master`, а также при создании тега (например, `v1.0.0`), автоматически запускается сборка установщика Windows.

### Как получить установщик:

1. **Через GitHub Actions:**
   - Перейдите в раздел "Actions" вашего репозитория
   - Выберите последний успешный workflow "Build Windows Installer"
   - В разделе "Artifacts" скачайте `windows-installer`

2. **Через Release (при создании тега):**
   - Создайте тег: `git tag v1.0.0 && git push origin v1.0.0`
   - GitHub Actions автоматически создаст Release с установщиком

## Локальная сборка

### Требования:
- Flutter SDK (3.24.0 или выше)
- Inno Setup 6 (https://jrsoftware.org/isdl.php)

### Шаги:

1. **Соберите Flutter приложение:**
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   flutter build windows --release
   ```

2. **Создайте установщик:**
   - Откройте `installer.iss` в Inno Setup Compiler
   - Нажмите "Build" -> "Compile"
   - Установщик будет создан в папке `installer/`

### Настройка версии:

Версия приложения берется из `pubspec.yaml` (поле `version`). 
Для изменения версии установщика отредактируйте `installer.iss`:
```iss
#define AppVersion "1.0.0"
```

## Структура установщика

Установщик включает:
- Исполняемый файл приложения
- Все необходимые DLL и зависимости
- Ассеты (logo.png, procurements_source.csv)
- Шрифты (RussoOne-Regular.ttf)
- Ярлыки на рабочем столе и в меню "Пуск"

## Примечания

- Установщик требует права администратора для установки
- Приложение устанавливается в `C:\Program Files\Procurement Analytics System`
- База данных SQLite создается автоматически при первом запуске
