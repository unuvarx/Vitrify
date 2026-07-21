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

// Bazı eklentiler (örn. photo_manager, flutter_image_compress) kendi Gradle
// dosyalarında Kotlin ve Java derleyicileri için farklı JVM hedefleri
// kullanıyor, bu da "Inconsistent JVM Target Compatibility" hatasına yol
// açıyor. Tüm alt modülleri projenin JVM hedefiyle (17) eşleyerek bunu
// zorluyoruz. Bu blok, aşağıdaki evaluationDependsOn(":app") satırından önce
// gelmeli — aksi halde ":app" o satırla erken evaluate edildiğinden buradaki
// afterEvaluate çağrısı "project already evaluated" hatası verir.
subprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
    afterEvaluate {
        extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
