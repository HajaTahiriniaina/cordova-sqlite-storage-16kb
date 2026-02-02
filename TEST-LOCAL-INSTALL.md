# Test d'installation locale

## 🧪 Tester le plugin avant de publier sur GitHub

Avant de publier, testez l'installation locale dans votre projet ubix-chantier.

### 1. Désinstaller l'ancien plugin

```bash
cd ~/Mobile/ubix-chantier
npm uninstall cordova-sqlite-storage
```

### 2. Installer depuis le dossier local

```bash
npm install file:../Plugin/cordova-sqlite-storage
```

### 3. Vérifier l'installation

```bash
# Vérifier que le package est installé
ls -la node_modules/ | grep cordova-sqlite-storage

# Vérifier la version
npm list cordova-sqlite-storage-16kb
```

Vous devriez voir :
```
cordova-sqlite-storage-16kb@6.1.0-16kb.1
```

### 4. Vérifier les JARs

```bash
ls -lh node_modules/cordova-sqlite-storage-16kb/node_modules/cordova-sqlite-storage-dependencies/libs/
```

Vous devriez voir :
- `sqlite-ndk-native-driver.jar` (~2.7MB) ← Le JAR compilé 16KB
- `sqlite-native-ndk-connector.jar` (~12KB)

### 5. Synchroniser Capacitor

```bash
npx cap sync android
```

Vérifiez que le plugin apparaît dans les logs :
```
[info] Found 11 Cordova plugins for android:
       ...
       cordova-sqlite-storage@6.1.0
       ...
```

### 6. Builder l'app

```bash
# S'assurer que Java 17 est actif
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Builder
cd android
./gradlew clean
./gradlew assembleRelease
```

### 7. Vérifier 16KB

```bash
cd ..
./android/verify-16kb.sh
```

Résultat attendu : `✅ SUCCESS! All native libraries are properly aligned for 16KB page size.`

### 8. Tester l'app

Lancez l'app sur un émulateur Android 15 16KB ou un appareil réel.

**Test rapide dans le code :**

```typescript
// Dans un composant ou service
async testSQLite() {
  try {
    const db = await this.sqlite.create({
      name: 'test-16kb.db',
      location: 'default'
    });

    console.log('✅ Database opened successfully');

    await db.executeSql('CREATE TABLE IF NOT EXISTS test (id INTEGER, name TEXT)', []);
    console.log('✅ Table created');

    await db.executeSql('INSERT INTO test VALUES (?, ?)', [1, '16KB Test']);
    console.log('✅ Insert successful');

    const result = await db.executeSql('SELECT * FROM test', []);
    console.log('✅ Select successful, rows:', result.rows.length);

    return true;
  } catch (error) {
    console.error('❌ SQLite test failed:', error);
    return false;
  }
}
```

### 9. Vérifier les logs Android

```bash
adb logcat | grep -i "sqlite\|SIGSEGV"
```

**Vous NE devriez PAS voir :**
- `Fatal signal 11 (SIGSEGV)`
- `dlopen failed: empty/missing DT_HASH/DT_GNU_HASH`

**Vous DEVRIEZ voir :**
- Logs SQLite normaux
- Aucun crash

## ✅ Si tout fonctionne

Votre plugin est prêt ! Vous pouvez :

1. **Publier sur GitHub** (voir GITHUB-SETUP.md)
2. **Installer dans tous vos projets Ionic**

## ❌ Si ça ne fonctionne pas

### Problème : "Module not found"

```bash
# Réinstaller
npm uninstall cordova-sqlite-storage-16kb
rm -rf node_modules/cordova-sqlite-storage-16kb
npm install file:../Plugin/cordova-sqlite-storage
npx cap sync android
```

### Problème : Crash SIGSEGV persiste

1. **Vérifier que le bon JAR est copié :**
   ```bash
   ls -lh node_modules/cordova-sqlite-storage-16kb/node_modules/cordova-sqlite-storage-dependencies/libs/sqlite-ndk-native-driver.jar
   ```
   Doit faire ~2.7MB

2. **Vérifier le contenu du JAR :**
   ```bash
   unzip -l node_modules/cordova-sqlite-storage-16kb/node_modules/cordova-sqlite-storage-dependencies/libs/sqlite-ndk-native-driver.jar | grep "\.so"
   ```

   Vous devriez voir 4 architectures

3. **Vérifier dans l'APK final :**
   ```bash
   unzip -l android/app/build/outputs/apk/release/app-release.apk | grep libsqlc
   ```

   Les `.so` doivent être présents

### Problème : Build Gradle échoue

```bash
# Vérifier Java 17
java -version

# Vérifier NDK
ls ~/Library/Android/sdk/ndk/29.0.13846066

# Clean complet
cd android
rm -rf .gradle build app/build
./gradlew clean
./gradlew assembleRelease
```

## 📝 Checklist de test

- [ ] Plugin installé localement
- [ ] JARs présents (2.7MB + 12KB)
- [ ] Capacitor sync réussi
- [ ] Build Android réussi
- [ ] verify-16kb.sh passe
- [ ] App démarre sans crash
- [ ] SQLite fonctionne (CRUD)
- [ ] Logs Android clean (pas de SIGSEGV)

## 🎉 Test réussi ?

Si tous les tests passent, votre plugin est **production ready** !

Prochaine étape : **Publier sur GitHub** (voir GITHUB-SETUP.md)

---

## 🔄 Revenir à l'ancien plugin

Si vous voulez revenir en arrière :

```bash
npm uninstall cordova-sqlite-storage-16kb
npm install cordova-sqlite-storage@6.1.0
npx cap sync android
```

(Mais vous aurez à nouveau le problème 16KB)
