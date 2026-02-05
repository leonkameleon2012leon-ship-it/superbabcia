# Superbabcia - Planer Posiłków dla Babci

Aplikacja Flutter stworzona specjalnie dla osób starszych do planowania posiłków.

## Funkcjonalności

- **Ekran powitalny z animacją** - rysunek talerza z unoszącą się parą i napisem "Smacznego! Miłego dnia w pracy!"
- **Lista posiłków na dzień** - śniadanie, obiad, kolacja, przekąski
- **Dodawanie posiłków** - możliwość dodania nazwy dania i listy składników
- **Konfiguracja godziny** - wybór godziny podania każdego posiłku
- **Powiadomienia push** - przypomnienie 15 minut przed posiłkiem
- **Przyjazny interfejs** - duże czcionki, wysokie kontrasty, prosty układ

## Technologie

- Flutter SDK
- Provider - zarządzanie stanem
- flutter_local_notifications - system powiadomień
- timezone - zarządzanie strefami czasowymi
- intl - formatowanie dat i lokalizacja

## Uruchomienie

```bash
cd superbabcia_app
flutter pub get
flutter run
```

## Struktura kodu

```
lib/
├── main.dart              # Punkt wejścia aplikacji
├── babcia_state.dart      # Stan aplikacji i modele danych
├── alerty.dart            # System powiadomień
└── ekrany/
    ├── powitanie.dart         # Ekran powitalny z animacją
    ├── tablica_glowna.dart    # Główny ekran z listą posiłków
    ├── szczegoly_dania.dart   # Szczegóły pojedynczego posiłku
    └── dodaj_danie.dart       # Formularz dodawania posiłku
```

## Przykładowe dane

Aplikacja zawiera przykładowe posiłki:
- Śniadanie (8:00): Kanapki z serem i pomidorem
- Obiad (13:00): Zupa pomidorowa z makaronem
- Przekąska (16:00): Herbata z ciastkiem
- Kolacja (19:00): Jajecznica ze szczypiorkiem

## Projekt

Kod jest przejrzysty i czytelny, z polskimi nazwami zmiennych dla lepszego zrozumienia przez polskich programistów.
