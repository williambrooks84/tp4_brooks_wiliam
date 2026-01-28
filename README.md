# 🎬 Application Flutter – Films & Favoris

Une application Flutter permettant de :
- Parcourir une **liste de films**
- Gérer une liste de **films favoris**
- Consulter les **détails d’un film**

L’application utilise l’API **Watchmode** pour récupérer les données.

Inspiration de design : https://dribbble.com/shots/20639553-Video-Streaming-mobile-ui

---

## 📱 Aperçu de l’application

### 🎞️ Liste des films
<img width="198" height="422" alt="Liste des films" src="https://github.com/user-attachments/assets/d4d36689-f5c1-4f6a-8d24-7ccaf3f5b1db" />

### ⭐ Favoris
<img width="210" height="432" alt="Favoris" src="https://github.com/user-attachments/assets/6ba46c03-aa76-4cba-8be2-1dbe0cdcc2f7" />

### 📄 Détails d’un film
<img width="221" height="431" alt="Détails" src="https://github.com/user-attachments/assets/f622f221-0cfd-4ac4-a531-fed7984ea03f" />

---

## 🚀 Lancer l’application

### 1️⃣ Récupérer une clé API

Rendez-vous sur le site officiel de Watchmode :  
👉 https://api.watchmode.com/

Créez un compte et récupérez votre **clé API**.

---

### 2️⃣ Configuration de VS Code

À la racine du projet, créez un dossier `.vscode` puis un fichier `launch.json` :

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (Development)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=WATCHMODE_API_KEY=VotreCleAPIIci"
      ]
    }
  ]
}
