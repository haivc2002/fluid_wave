# fluid_wave 🌊

`fluid_wave` is a powerful Flutter package designed to create ultra-smooth "fluid reveal" transitions and radial warp distortions. By leveraging the power of **Shaders**, this package brings a premium, modern, and vivid UI experience to your applications.

## 🚀 Key Features

*   **Radial Warp Effect**: Mimics the experience of looking through a liquid lens while transitioning between views.
*   **Smooth Transitions**: Uses `CustomPaint` and `Shader` to optimize rendering performance.
*   **Flexible Customization**:
    *   Change the wave origin point (`topLeft`, `center`, `bottomRight`, etc.).
    *   Adjust distortion strength (`warpStrength`).
    *   Customize animation `Duration` and `Curve`.
*   **Easy Integration**: Simple wrapper with `FluidWaveView` and control via `FluidWaveController`.

## 📸 Demo

<p align="center">
  <img src="https://raw.githubusercontent.com/haivc2002/fluid_wave/main/demo/demo.gif"
       width="300"
       style="border-radius:12px;" />
  <br><b>Auto-loop demo animation</b>
</p>

*Illustration of the fluid wave effect revealing a Settings interface.*

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  fluid_wave: ^1.0.0
```

### Android Configuration
To ensure correct performance on Android devices, it is recommended to disable `EnableImpeller` in your `AndroidManifest.xml`:

```xml
<meta-data
    android:name="io.flutter.embedding.android.EnableImpeller"
    android:value="false" />
```

## 🛠 Usage

### 1. Initialize the Controller

```dart
final controller = FluidWaveController(
  align: Alignment.center,
  duration: const Duration(milliseconds: 1000),
  curve: Curves.easeInOutQuart,
  warpStrength: 0.6, // Supports negative values for inverted warp
);
```

### 2. Wrap your Widget

Wrap the widget you want to apply the effect to:

```dart
FluidWaveView(
  controller: controller,
  child: MyCurrentPage(),
)
```

### 3. Trigger the Effect

When you want to transition to a new view state:

```dart
controller.forward(() {
  setState(() {
    // Update your application state here
    // e.g., Change page, toggle Theme, etc.
    isFirstImage = !isFirstImage;
  });
});
```

### 4. Full Example

```dart
class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool isFirstImage = true;
  late FluidWaveController controller;

  @override
  void initState() {
    controller = FluidWaveController();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FluidWaveView(
        controller: controller,
        child: isFirstImage 
          ? Image.network("url1")
          : Image.network("url2")
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          controller.forward(() {
            setState(() {
              isFirstImage = !isFirstImage;
            });
          });
        }, 
        child: Icon(Icons.change_circle),
      ),
    );
  }
}
```

## 🧹 Resource Cleanup

Don't forget to dispose of the controller to prevent memory leaks:

```dart
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

## 📜 License

This project is licensed under the MIT License.
# fluid_wave
