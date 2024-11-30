# myicon

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# myicon

iOS
# ไฟล์ที่สร้างขึ้นมาใหม่ 
    # lib/dynamic_icon_service.dart
    # ios/Runner/MyIconSwitcherPlugin.swift
    # แก้ไข 
    if let registrar = self.registrar(forPlugin: "MyIconSwitcherPlugin") {
        MyIconSwitcherPlugin.register(with: registrar)
    }
# Add File "MyIconSwitcherPlugin.swift" to Runner in Xcode
# สร้าง Icon ด้วย flutter_launcher_icons และเปลี่ยนชื่อ Folder ใน /ios/Runner/Assets.xcassets
# แก้ไข Info.plist
# Runner -> Build Setting -> 
    Include All App Icon Assets : Yes
    Primary App Icon Set Name : AppIcon หรือ icon ที่ต้องการ
    Alternate App Icon Set : ชื่อ Icon set เช่น "ChristmasIcon NewyearIcon"
    STANDALONE_ICON_BEHAVIOR : none