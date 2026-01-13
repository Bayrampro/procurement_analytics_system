# Инструкция по сборке релизной версии для macOS

## Быстрая сборка

### 1. Сборка релизной версии

```bash
flutter build macos --release
```

После выполнения команды приложение будет находиться в:
```
build/macos/Build/Products/Release/procurement_analytics_system.app
```

### 2. Создание DMG для распространения (опционально)

Для удобной установки на другом Mac можно создать DMG образ:

```bash
# Установите create-dmg (если еще не установлен)
brew install create-dmg

# Создайте DMG
create-dmg \
  --volname "Procurement Analytics System" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "procurement_analytics_system.app" 200 190 \
  --hide-extension "procurement_analytics_system.app" \
  --app-drop-link 600 185 \
  "ProcurementAnalyticsSystem-1.0.0.dmg" \
  "build/macos/Build/Products/Release/"
```

## Важные моменты

### Подпись кода (Code Signing)

По умолчанию приложение может требовать подпись для запуска на других Mac. Есть несколько вариантов:

#### Вариант 1: Отключить Gatekeeper (для тестирования)

На Mac получателя выполните:
```bash
sudo xattr -cr /path/to/procurement_analytics_system.app
sudo spctl --master-disable  # ВНИМАНИЕ: отключает защиту системы
```

#### Вариант 2: Подписать приложение (рекомендуется для распространения)

1. Откройте проект в Xcode:
```bash
open macos/Runner.xcworkspace
```

2. В Xcode:
   - Выберите Runner в навигаторе
   - Перейдите в "Signing & Capabilities"
   - Выберите вашу команду разработчика (Team)
   - Убедитесь, что "Automatically manage signing" включено

3. Соберите через Xcode:
   - Product → Archive
   - После архивации: Distribute App → Copy App
   - Сохраните подписанное приложение

#### Вариант 3: Ad-hoc подпись (для внутреннего использования)

```bash
codesign --force --deep --sign - \
  build/macos/Build/Products/Release/procurement_analytics_system.app
```

### Распространение

1. **Простой способ**: Скопируйте `.app` файл на другой Mac через:
   - USB флешку
   - Облачное хранилище (Dropbox, Google Drive, iCloud)
   - AirDrop

2. **DMG образ**: Создайте DMG (см. выше) для более профессионального распространения

3. **ZIP архив**: Заархивируйте `.app`:
```bash
cd build/macos/Build/Products/Release/
zip -r ProcurementAnalyticsSystem-1.0.0.zip procurement_analytics_system.app
```

## Запуск на другом Mac

1. Скопируйте `.app` файл на другой Mac
2. Если появится предупреждение о безопасности:
   - Откройте "Системные настройки" → "Безопасность и конфиденциальность"
   - Нажмите "Открыть в любом случае" рядом с предупреждением
   
   Или выполните в Terminal:
   ```bash
   sudo xattr -cr /path/to/procurement_analytics_system.app
   ```

3. Запустите приложение двойным кликом

## Автоматизация сборки

Можно добавить скрипт для автоматической сборки и создания DMG:

```bash
#!/bin/bash
# build_macos_release.sh

echo "🧹 Очистка предыдущих сборок..."
flutter clean

echo "📦 Получение зависимостей..."
flutter pub get

echo "🔨 Генерация кода..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "🏗️ Сборка релизной версии..."
flutter build macos --release

echo "✅ Сборка завершена!"
echo "📱 Приложение находится в: build/macos/Build/Products/Release/procurement_analytics_system.app"
```

Сделайте скрипт исполняемым:
```bash
chmod +x build_macos_release.sh
./build_macos_release.sh
```
