# 📝 Instrukcja tworzenia GitHub Repository

## Krok 1: Utwórz repo na GitHub.com

1. Idź na https://github.com/new
2. Uzupełnij:
   - **Repository name**: `hack-volunteers`
   - **Description**: `🤝 Flutter app for connecting youth with volunteer opportunities in Kraków. Swipe through events Tinder-style! Built with Clean Architecture, BLoC, and Isar.`
   - **Public** ✅
   - **NIE dodawaj** README, .gitignore, license (mamy już lokalnie)

3. Kliknij "Create repository"

## Krok 2: Push do GitHub

Skopiuj komendy które GitHub ci pokaże, będą wyglądać mniej więcej tak:

```bash
# Dodaj remote
git remote add origin https://github.com/[TWOJA-NAZWA-UZYTKOWNIKA]/hack-volunteers.git

# Push do GitHub
git push -u origin main
```

## Lub użyj tych komend:

```bash
cd /home/mecharolnik/Documents/GitHub/HackVolunteers/hack_volunteers

# Zastąp [USERNAME] swoją nazwą użytkownika GitHub
git remote add origin https://github.com/[USERNAME]/hack-volunteers.git
git branch -M main
git push -u origin main
```

## ✅ Gotowe!

Twoje repo będzie widoczne na:
`https://github.com/[USERNAME]/hack-volunteers`
