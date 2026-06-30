# Flutter-specific ProGuard rules
# Keep Flutter's embedding classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep data classes that might be used with reflection/serialization
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Keep the application class
-keep class com.xxh.cibei_space.** { *; }

# Suppress warnings for missing Play Core classes (deferred components)
# These are referenced by Flutter embedding but not used unless you use deferred components
-dontwarn com.google.android.play.core.**

