# Installation Guide - cordova-sqlite-storage-16kb

## 🚀 Installation rapide

### Méthode 1 : Via GitHub (Recommandé)

Une fois que vous avez créé le repo GitHub :

```bash
# Désinstaller l'ancien plugin
npm uninstall cordova-sqlite-storage

# Installer depuis GitHub
npm install git+https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb.git

# Synchroniser avec Capacitor
npx cap sync android
```

### Méthode 2 : Via clone local (Pour tests)

```bash
# Désinstaller l'ancien plugin
npm uninstall cordova-sqlite-storage

# Installer depuis le dossier local
npm install file:../Plugin/cordova-sqlite-storage

# Synchroniser
npx cap sync android
```

## 📝 Configuration requise

### 1. Variables Gradle

**android/variables.gradle:**

```gradle
ext {
    minSdkVersion = 22
    compileSdkVersion = 35
    targetSdkVersion = 35
    ndkVersion = '29.0.13846066'
    buildToolsVersion = '36.1.0'  // ou 34.0.0 minimum
}
```

### 2. Build Gradle

**android/app/build.gradle:**

```gradle
android {
    ndkVersion rootProject.ext.ndkVersion
    buildToolsVersion rootProject.ext.buildToolsVersion

    // 16KB page size compatibility
    packagingOptions {
        jniLibs {
            useLegacyPackaging = true
        }
    }
}
```

### 3. Java 17

```bash
# Installer Java 17
brew install --cask zulu17

# Configurer
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
```

## 🔄 Migration depuis cordova-sqlite-storage

**Bonne nouvelle :** Aucun changement de code requis !

Le plugin est 100% compatible avec l'API originale. Vos imports et requêtes SQL restent identiques.

### Code TypeScript/Angular (inchangé)

```typescript
import { SQLite, SQLiteObject } from '@awesome-cordova-plugins/sqlite/ngx';

constructor(private sqlite: SQLite) {}

async openDatabase() {
  const db: SQLiteObject = await this.sqlite.create({
    name: 'database.db',
    location: 'default'
  });
  return db;
}

// Toutes vos requêtes existantes fonctionnent
await db.executeSql('SELECT * FROM users', []);
await db.transaction((tx) => {
  tx.executeSql('INSERT INTO users VALUES (?, ?)', ['John', 'Doe']);
});
```

## ✅ Vérification

### 1. Vérifier l'installation

```bash
npm list cordova-sqlite-storage-16kb
```

Vous devriez voir : `cordova-sqlite-storage-16kb@6.1.0-16kb.1`

### 2. Vérifier les bibliothèques natives

```bash
ls -lh node_modules/cordova-sqlite-storage-16kb/node_modules/cordova-sqlite-storage-dependencies/libs/
```

Vous devriez voir :
- `sqlite-ndk-native-driver.jar` (~2.7MB) ← **Compilé 16KB**
- `sqlite-native-ndk-connector.jar`

### 3. Builder l'app

```bash
cd android
./gradlew clean
./gradlew assembleRelease
```

### 4. Vérifier l'APK (16KB compatibility)

```bash
# Trouver zipalign
ZIPALIGN=~/Library/Android/sdk/build-tools/36.1.0/zipalign

# Vérifier l'alignement
$ZIPALIGN -v -c -P 16 4 app/build/outputs/apk/release/app-release.apk
```

Résultat attendu : `Verification successful` ✅

## 🧪 Tests

### Tester sur émulateur Android 15 16KB

1. Ouvrir **Android Studio SDK Manager**
2. Onglet **SDK Tools** → **Show Package Details**
3. Télécharger **"Android 15 16KB Page Size Google Play"** system image
4. Créer un AVD avec cette image
5. Lancer l'app

**L'app devrait démarrer sans crash SIGSEGV** ✅

### Tester les fonctionnalités SQLite

```typescript
// Tester dans votre app
async testSQLite() {
  const db = await this.sqlite.create({ name: 'test.db' });

  // CREATE
  await db.executeSql('CREATE TABLE IF NOT EXISTS test (id, name)', []);

  // INSERT
  await db.executeSql('INSERT INTO test VALUES (?, ?)', [1, 'Test']);

  // SELECT
  const result = await db.executeSql('SELECT * FROM test', []);
  console.log('Rows:', result.rows.length); // Devrait afficher 1

  // UPDATE
  await db.executeSql('UPDATE test SET name = ? WHERE id = ?', ['Updated', 1]);

  // DELETE
  await db.executeSql('DELETE FROM test WHERE id = ?', [1]);

  console.log('✅ SQLite 16KB works!');
}
```

## 🔧 Dépannage

### Si l'app crash encore (SIGSEGV)

1. **Vérifier que le bon plugin est installé :**
   ```bash
   cat node_modules/cordova-sqlite-storage-16kb/package.json | grep version
   ```
   Devrait afficher : `"version": "6.1.0-16kb.1"`

2. **Re-synchroniser :**
   ```bash
   npx cap sync android --force
   ```

3. **Clean build :**
   ```bash
   cd android
   ./gradlew clean
   rm -rf .gradle build app/build
   ./gradlew assembleRelease
   ```

4. **Vérifier les logs Android :**
   ```bash
   adb logcat | grep -i "sqlite\|SIGSEGV"
   ```

### Si "Circular dependency in DI"

Utilisez l'adaptateur fourni dans votre projet :

```typescript
// src/services/sqlite-ext-adapter.ts existe déjà
import { SQLite } from './sqlite-ext-adapter';

// app.module.ts
import { sqliteExtAdapterFactory } from '../services/sqlite-ext-adapter';
{ provide: SQLite, useFactory: sqliteExtAdapterFactory }
```

### Si le build Gradle échoue

1. **Java 17 requis :**
   ```bash
   java -version  # Doit afficher "openjdk version 17"
   ```

2. **NDK r28+ requis :**
   ```bash
   ls ~/Library/Android/sdk/ndk/  # Vérifier 29.0.13846066 ou supérieur
   ```

## 📦 Mettre à jour le plugin

Si une nouvelle version est publiée :

```bash
npm update cordova-sqlite-storage-16kb
npx cap sync android
```

## 🎯 Pour plusieurs projets Ionic

Ce plugin fonctionne pour **tous vos projets Ionic/Cordova/Capacitor** :

```bash
# Projet 1
cd ~/Projects/app1
npm install git+https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb.git

# Projet 2
cd ~/Projects/app2
npm install git+https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb.git

# Etc...
```

Tous partageront les mêmes bibliothèques natives 16KB compilées !

## ✨ Avantages

- ✅ **Compatible Android 15 16KB**
- ✅ **Aucun changement de code**
- ✅ **Réutilisable dans tous vos projets**
- ✅ **Maintenu à jour** (vous contrôlez les updates)
- ✅ **Production ready**

## 📚 Ressources

- [README principal](./README-16KB.md)
- [Script de mise à jour](./update-libs.sh)
- [Documentation Android 16KB](https://developer.android.com/guide/practices/page-sizes)

---

**Problème ?** → Créer une [issue GitHub](https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb/issues)
