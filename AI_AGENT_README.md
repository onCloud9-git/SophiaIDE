# SophiaIDE – Instrukcje dla Agenta AI (BEZPIECZNA EDYCJA)

Cel: zachować pełną zgodność z upstream VS Code, nie psując forka.

## Zasady absolutne
- NIE PUSHUJ na `main`. Twórz PR z gałęzi funkcjonalnych (domyślnie `sophia`).
- Zanim cokolwiek zmienisz, uruchom: `./scripts/safe-sync.sh`.
- Preferuj zmiany w:
  - `extensions/`, `product.json`, `resources/` (branding), `.SophisticIDE/`, `scripts/`, plikach `*.md`.
- NIE edytuj core (`src/`, `build/`, `cli/`, `remote/`), chyba że jest to krytyczne. Jeśli MUSISZ:
  - W treści commita dodaj token: `ALLOW-CORE-CHANGE`.

## Dozwolone operacje
- Dodawanie/aktualizacja rozszerzeń, motywów, ikon i konfiguracji produktu.
- Modyfikacje w `.SophisticIDE/**` (specy, automaty, dokumenty).
- Skrypty pomocnicze w `scripts/**`.
- Dokumentacja `*.md`.

## Niedozwolone/ograniczone
- Zmiany w `src/`, `build/`, `cli/`, `remote/` bez jasnego uzasadnienia i tokenu `ALLOW-CORE-CHANGE`.
- Push bezpośrednio na `main` – zablokowane hookiem.

## Workflow
1. Synchronizacja i testy:
   ```bash
   ./scripts/safe-sync.sh
   ```
2. Wprowadzaj zmiany na gałęzi `sophia`.
3. Uruchom testy lokalne:
   ```bash
   ./scripts/ci-checks.sh
   ```
4. Wypchnij gałąź i utwórz PR:
   ```bash
   git push -u origin sophia
   # utwórz PR w GitHub (lub gh pr create)
   ```

## Patche (opcjonalnie)
- Eksport:
  ```bash
  ./scripts/export-patches.sh sophia
  ```
- Aplikacja na świeżą gałąź:
  ```bash
  ./scripts/apply-patches.sh sophia-next
  ```

## Kontrole bezpieczeństwa (hooki)
- `pre-push`: blokuje push refa `main`.
- `commit-msg`: blokuje commity dotykające core bez `ALLOW-CORE-CHANGE`.

## Zasady edycji dla Agenta
- Edytuj tylko pliki i katalogi wymienione w „Dozwolone operacje”.
- Nie zmieniaj konfiguracji hooków i polityk bez zgody.
- Nie twórz nowych folderów w `src/` bez tokenu i opisu celu.
- Zachowaj styl i linter projektu.

