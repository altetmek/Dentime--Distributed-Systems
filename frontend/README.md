# Dentime

## Launcher icon

- Place launcher icon in assets directory  
- Configure launch icons in pubspec, as follows at time of writing 
  ```yaml
    flutter_icons:
    image_path: assets/images/launcher/launcher_icon.png
    android: true
    ios: true
    ```
- Run ```flutter pub pub run flutter_launcher_icons:main``` in your terminal, to generate all icons.
