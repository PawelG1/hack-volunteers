allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Fix for isar_flutter_libs compileSdk issue in release builds  
subprojects {
    afterEvaluate {
        // Force isar_flutter_libs to use higher compileSdk
        if (project.name == "isar_flutter_libs") {
            extensions.findByType<com.android.build.gradle.LibraryExtension>()?.apply {
                compileSdk = 36
                defaultConfig {
                    minSdk = 21
                }
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
