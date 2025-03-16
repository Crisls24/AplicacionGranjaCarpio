plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.granjacerdos"
    compileSdk = 34 // Actualizado a la versión adecuada

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11" // Especificar el target de JVM como cadena
    }

    defaultConfig {
        applicationId = "com.example.granjacerdos"
        minSdk = 21 // O la versión mínima que necesites
        targetSdk = 34 // Asegúrate de que esto coincida con compileSdk
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("com.google.android.material:material:1.8.0") // Usa la sintaxis de Kotlin para las dependencias
    // Agrega aquí otras dependencias que necesites
}
