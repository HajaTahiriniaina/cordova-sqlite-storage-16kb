# cordova-sqlite-storage-16kb

**Fork de cordova-sqlite-storage avec support Android 15 16KB page size**

[![Android 15](https://img.shields.io/badge/Android-15%20Compatible-brightgreen.svg)](https://developer.android.com/guide/practices/page-sizes)
[![16KB Page Size](https://img.shields.io/badge/16KB-Page%20Size-blue.svg)](https://developer.android.com/guide/practices/page-sizes)

## 🎯 Pourquoi ce fork ?

Google Play impose à partir du **1er mai 2026** que toutes les apps Android 15+ (API 35) supportent les appareils avec **16KB page size**.

Le plugin original `cordova-sqlite-storage` utilise des bibliothèques natives (`.so`) qui **ne sont pas compatibles** et causent des crashs sur Android 15 :

```
Fatal signal 11 (SIGSEGV), code 2 (SEGV_ACCERR)
dlopen failed: empty/missing DT_HASH/DT_GNU_HASH in libsqlc-ndk-native-driver.so
```

## ✅ Ce qui a été fait

Ce fork contient les bibliothèques natives **recompilées avec NDK r29** et le flag d'alignement 16KB :

```makefile
LOCAL_LDFLAGS += -Wl,-z,max-page-size=16384
```

### Modifications

1. **`libsqlc-ndk-native-driver.so`** recompilé pour toutes les architectures :
   - `arm64-v8a` ✅
   - `armeabi-v7a` ✅
   - `x86` ✅
   - `x86_64` ✅

2. **JARs mis à jour** dans `node_modules/cordova-sqlite-storage-dependencies/libs/` :
   - `sqlite-ndk-native-driver.jar` (2.7MB) - **Compilé 16KB**
   - `sqlite-native-ndk-connector.jar` - Original

3. **API 100% compatible** avec le plugin original

## 📦 Installation

### Via GitHub

```bash
npm install git+https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb.git
```

### Ou clone local

```bash
npm install file:../Plugin/cordova-sqlite-storage
```

### Puis synchroniser

```bash
npx cap sync android
```

## 🚀 Utilisation

**Aucun changement de code requis !** L'API reste identique :

```typescript
import { SQLite, SQLiteObject } from '@awesome-cordova-plugins/sqlite/ngx';

async openDatabase() {
  const db: SQLiteObject = await this.sqlite.create({
    name: 'data.db',
    location: 'default'
  });
  return db;
}

await db.executeSql('INSERT INTO users VALUES (?)', ['John']);
```

## 🔍 Vérification

Pour vérifier que votre APK est compatible 16KB :

```bash
cd android
zipalign -v -c -P 16 4 app/build/outputs/apk/release/app-release.apk
```

Vous devriez voir : `Verification successful`

## 🏗️ Build depuis les sources

Si vous voulez recompiler les bibliothèques vous-même :

```bash
# Prérequis
export ANDROID_NDK_HOME=~/Library/Android/sdk/ndk/29.0.13846066

# Cloner et compiler
git clone https://github.com/brodybits/android-sqlite-ndk-native-driver.git
cd android-sqlite-ndk-native-driver
git submodule update --init
ndk-build
jar cf sqlite-ndk-native-driver.jar lib

# Copier le JAR
cp sqlite-ndk-native-driver.jar \
   /path/to/cordova-sqlite-storage-16kb/node_modules/cordova-sqlite-storage-dependencies/libs/
```

## 📋 Configuration requise

- **Android Gradle Plugin**: 8.5.1+
- **NDK**: r28+ (r29 recommandé)
- **Build Tools**: 34.0.0+
- **Target SDK**: 35
- **Java**: 17+

### android/variables.gradle

```gradle
ext {
    minSdkVersion = 22
    compileSdkVersion = 35
    targetSdkVersion = 35
    ndkVersion = '29.0.13846066'
    buildToolsVersion = '36.1.0'
}
```

### android/app/build.gradle

```gradle
android {
    ndkVersion rootProject.ext.ndkVersion
    buildToolsVersion rootProject.ext.buildToolsVersion

    packagingOptions {
        jniLibs {
            useLegacyPackaging = true
        }
    }
}
```

## 🧪 Tests

Testé sur :
- ✅ Android 15 émulateur 16KB page size
- ✅ Android 14 (rétro-compatible)
- ✅ Production apps (plusieurs projets Ionic)

## 📚 Ressources

- [Android 16KB Page Size Guide](https://developer.android.com/guide/practices/page-sizes)
- [Google Play 16KB Requirement](https://android-developers.googleblog.com/2025/05/prepare-play-apps-for-devices-with-16kb-page-size.html)
- [cordova-sqlite-storage Issue #1021](https://github.com/storesafe/cordova-sqlite-storage/issues/1021)
- [android-sqlite-ndk-native-driver](https://github.com/brodybits/android-sqlite-ndk-native-driver)

## 📅 Deadline Google Play

- ✅ **1er novembre 2025** : Nouvelles apps (passé)
- ⚠️ **1er mai 2026** : Mises à jour d'apps existantes
- 📌 **Extension possible** jusqu'au 31 mai 2026 (one-time)

## 🤝 Contribution

Ce fork est maintenu pour répondre à l'exigence Google Play 16KB. Les contributions sont bienvenues !

1. Fork ce repo
2. Créer une branche feature
3. Commit vos changements
4. Push et créer une Pull Request

## 📄 License

MIT - Identique au plugin original cordova-sqlite-storage

## ⚠️ Important

- Les bibliothèques natives sont **pré-compilées** et incluses dans le repo
- Pas besoin de recompiler à chaque installation
- Compatible avec tous les projets Ionic/Cordova/Capacitor
- Fonctionne en production sur plusieurs apps

## 🎉 Crédits

- Plugin original : [storesafe/cordova-sqlite-storage](https://github.com/storesafe/cordova-sqlite-storage)
- Native driver : [brodybits/android-sqlite-ndk-native-driver](https://github.com/brodybits/android-sqlite-ndk-native-driver)
- Fork 16KB : Votre nom

---

**Questions ou problèmes ?** Ouvrir une [issue](https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb/issues)
