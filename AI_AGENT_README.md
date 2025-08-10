# SophiaIDE – Instrukcje dla Agenta AI (BEZPIECZNA EDYCJA)

Cel: zachować pełną zgodność z upstream VS Code, nie psując forka.

## Szybki start
- Uruchom synchronizację i testy:
  ```bash
  ./scripts/safe-sync.sh
  ```
- Pracuj WYŁĄCZNIE na gałęzi `sophia`, nigdy na `main`.
- Po zmianach:
  ```bash
  ./scripts/ci-checks.sh
  git push -u origin sophia
  # utwórz PR do main
  ```

## Zasady absolutne
- NIE PUSHUJ na `main`. Twórz PR z gałęzi funkcjonalnych (domyślnie `sophia`).
- Preferuj zmiany w: `extensions/`, `product.json`, `resources/` (branding), `.SophisticIDE/`, `scripts/`, plikach `*.md`.
- NIE edytuj core (`src/`, `build/`, `cli/`, `remote/`), chyba że jest to krytyczne. Jeśli MUSISZ, w treści commita dodaj token: `ALLOW-CORE-CHANGE`.

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
3. Testy lokalne:
   ```bash
   ./scripts/ci-checks.sh
   ```
4. Push i PR:
   ```bash
   git push -u origin sophia
   ```

## Patche (opcjonalnie)
- Eksport:
  ```bash
  ./scripts/export-patches.sh sophia
  ```
- Aplikacja:
  ```bash
  ./scripts/apply-patches.sh sophia-next
  ```

## Kontrole bezpieczeństwa (hooki)
- `pre-push`: blokuje push refa `main`.
- `commit-msg`: blokuje commity dotykające core bez `ALLOW-CORE-CHANGE`.

## Konfiguracja automatu
- `safe-fork.config`:
  - `FEATURE_BRANCH="sophia"`
  - `PROTECTED_BRANCHES="main"`
  - `CORE_CHANGE_PATHS="src/ build/ cli/ remote/"`
  - `OVERRIDE_TOKEN="ALLOW-CORE-CHANGE"`

## Uwaga dla powłoki
- Uruchamiaj komendy linia-po-linii (zsh potrafi źle parsować komentarze na końcu linii).

