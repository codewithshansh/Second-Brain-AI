plugins {
    // remove kotlin("android") completely
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.4.2")
        // no kotlin plugin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
