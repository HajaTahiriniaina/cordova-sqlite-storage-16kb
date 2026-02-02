# Guide de publication sur GitHub

## 📋 Étapes pour créer le repo GitHub

### 1. Créer le repo sur GitHub

1. Aller sur https://github.com/new
2. **Repository name:** `cordova-sqlite-storage-16kb`
3. **Description:** `Cordova SQLite Storage plugin with Android 15 16KB page size support`
4. **Public** (ou Private selon vos besoins)
5. **Ne PAS** initialiser avec README (on a déjà tout)
6. Cliquer **Create repository**

### 2. Pousser le code

```bash
cd /Users/macos/Mobile/Plugin/cordova-sqlite-storage

# Configurer le remote
git remote add origin https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb.git

# Premier commit
git commit -m "Initial commit: cordova-sqlite-storage with Android 15 16KB support

- Recompiled libsqlc-ndk-native-driver.so with NDK r29
- Added -Wl,-z,max-page-size=16384 flag
- Compatible with Android 15 16KB page size devices
- API 100% compatible with original cordova-sqlite-storage
- Version 6.1.0-16kb.1"

# Pousser
git branch -M main
git push -u origin main
```

### 3. Créer un release tag

```bash
# Créer un tag
git tag -a v6.1.0-16kb.1 -m "Release v6.1.0-16kb.1

Android 15 16KB page size compatible

Changes:
- Recompiled native libraries with NDK r29
- 16KB alignment flag enabled
- Tested on Android 15 emulator
- Production ready"

# Pousser le tag
git push origin v6.1.0-16kb.1
```

### 4. Créer une GitHub Release

1. Aller sur `https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb/releases`
2. Cliquer **"Draft a new release"**
3. **Choose a tag:** `v6.1.0-16kb.1`
4. **Release title:** `v6.1.0-16kb.1 - Android 15 16KB Compatible`
5. **Description:**

```markdown
## 🎉 Android 15 16KB Page Size Support

This release adds full support for Android 15 devices with 16KB page size, resolving the `SIGSEGV` crash issue.

### ✅ What's included

- **Native libraries recompiled** with NDK r29
- **16KB alignment flag** enabled (`-Wl,-z,max-page-size=16384`)
- **All architectures** supported (arm64-v8a, armeabi-v7a, x86, x86_64)
- **100% API compatible** with cordova-sqlite-storage@6.1.0

### 🚀 Installation

```bash
npm install git+https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb.git
npx cap sync android
```

See [INSTALLATION.md](./INSTALLATION.md) for detailed setup instructions.

### 📋 Requirements

- Android Gradle Plugin 8.5.1+
- NDK r28+ (r29 recommended)
- Target SDK 35
- Java 17+

### 🧪 Tested on

- ✅ Android 15 emulator (16KB page size)
- ✅ Android 14 (backward compatible)
- ✅ Production apps

### 📚 Resources

- [Installation Guide](./INSTALLATION.md)
- [16KB README](./README-16KB.md)
- [Google Play 16KB Requirement](https://developer.android.com/guide/practices/page-sizes)

### 🐛 Known Issues

None at this time.

### 📅 Google Play Deadline

- **May 1, 2026**: All app updates must support 16KB page sizes
- **Extension available** until May 31, 2026 (one-time)
```

6. Cliquer **"Publish release"**

## 📝 Mettre à jour le package.json avec la bonne URL

Avant de commit, remplacer `HajaTahiriniaina` par votre vrai username GitHub :

```bash
# Remplacer dans package.json
sed -i '' 's/HajaTahiriniaina/votre-username-github/g' package.json
sed -i '' 's/YOUR_NAME/Votre Nom/g' package.json

# Remplacer dans README-16KB.md
sed -i '' 's/HajaTahiriniaina/votre-username-github/g' README-16KB.md

# Recommit
git add package.json README-16KB.md
git commit --amend --no-edit
git push -f origin main
```

## 🔧 Configuration du repo GitHub

### Topics

Ajouter ces topics au repo (dans Settings → Topics) :

- `cordova`
- `sqlite`
- `android`
- `android-15`
- `16kb-page-size`
- `capacitor`
- `ionic`
- `cordova-plugin`

### README

Le README principal sera automatiquement affiché. Vous pouvez aussi renommer `README-16KB.md` en `README.md` :

```bash
mv README.md README-ORIGINAL.md
mv README-16KB.md README.md
git add .
git commit -m "Use 16KB README as main README"
git push
```

## 📦 Installation dans vos projets

Une fois publié sur GitHub, dans n'importe quel projet Ionic :

```bash
# Méthode 1 : Via npm avec GitHub
npm install git+https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb.git

# Méthode 2 : Via package.json
{
  "dependencies": {
    "cordova-sqlite-storage-16kb": "git+https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb.git#v6.1.0-16kb.1"
  }
}
```

## 🔄 Mettre à jour les bibliothèques natives

Si vous devez recompiler les `.so` :

```bash
cd /Users/macos/Mobile/Plugin/cordova-sqlite-storage
./update-libs.sh

git add node_modules/cordova-sqlite-storage-dependencies/libs/
git commit -m "Update native libraries to latest SQLite version"
git tag v6.1.0-16kb.2
git push && git push --tags
```

## 📊 Badge pour le README

Ajouter des badges dans README.md :

```markdown
[![GitHub release](https://img.shields.io/github/v/release/HajaTahiriniaina/cordova-sqlite-storage-16kb)](https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb/releases)
[![npm](https://img.shields.io/npm/dt/cordova-sqlite-storage-16kb)](https://www.npmjs.com/package/cordova-sqlite-storage-16kb)
[![License](https://img.shields.io/github/license/HajaTahiriniaina/cordova-sqlite-storage-16kb)](./LICENSE.md)
```

## ✅ Checklist finale

Avant de pousser :

- [ ] Remplacer `HajaTahiriniaina` par votre username GitHub
- [ ] Remplacer `YOUR_NAME` par votre nom
- [ ] Vérifier que les JARs sont bien dans `node_modules/cordova-sqlite-storage-dependencies/libs/`
- [ ] Vérifier `sqlite-ndk-native-driver.jar` fait ~2.7MB
- [ ] Tester l'installation dans un projet test
- [ ] Créer le premier commit
- [ ] Pousser sur GitHub
- [ ] Créer un release tag
- [ ] Publier une GitHub Release

## 🎯 Résultat final

Vos projets pourront installer le plugin avec :

```bash
npm install git+https://github.com/HajaTahiriniaina/cordova-sqlite-storage-16kb.git
```

Et auront immédiatement le support Android 15 16KB sans aucun changement de code ! 🎉
