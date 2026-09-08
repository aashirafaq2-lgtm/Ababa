allprojects {
    repositories {
        google()
        mavenCentral()
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

subprojects {
    plugins.withId("com.android.library") {
        val extension = extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)
        if (extension != null) {
            if (extension.namespace == null) {
                extension.namespace = "dev.isar." + project.name.replace("-", "_")
            }
            if (extension.compileSdk == null || (extension.compileSdk ?: 0) < 34) {
                extension.compileSdk = 34
            }
        }
    }
}


tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
