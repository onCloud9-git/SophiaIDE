# SophiaIDE – Safe Fork README

Ten dokument opisuje zasady pracy z forkiem VS Code tak, aby aktualizacje z upstream NIE psuły Twoich zmian.

## TL;DR
- Pracuj WYŁĄCZNIE na gałęziach funkcjonalnych (domyślnie `sophia`).
- Aktualizuj i testuj jednym poleceniem:
  ```bash
  ./scripts/safe-sync.sh
  ```
- Push na `main` jest zablokowany hookiem – rób PR z `sophia`.
- Zmiany w core (`src/`, `build/`, `cli/`, `remote/`) są blokowane przez hook `commit-msg`, chyba że commit zawiera token `ALLOW-CORE-CHANGE`.
- Konfiguracja polityk: `safe-fork.config`.
- Instrukcje dla agenta AI: patrz `AI_AGENT_README.md`.

## Codzienny workflow
1. Zsynchronizuj `main` z upstream, zrebase’uj `sophia`, odpal testy:
   ```bash
   ./scripts/safe-sync.sh
   ```
2. Wprowadzaj zmiany na `sophia`.
3. Wypchnij gałąź i otwórz PR:
   ```bash
   git push -u origin sophia
   ```

## Zabezpieczenia
- `.githooks/pre-push`: blokuje pushy do `refs/heads/main` (niezależnie od bieżącej gałęzi).
- `.githooks/commit-msg`: blokuje commity dotykające core bez tokenu `ALLOW-CORE-CHANGE`.
- `scripts/update-main-from-upstream.sh`: fast‑forward `main` z `upstream/main` (bez auto-pusha).

## Gdzie wprowadzać zmiany
- Preferowane: `extensions/`, `product.json`, `resources/`, `.SophisticIDE/`, `scripts/`, pliki dokumentacji `*.md`.
- Core (`src/`, `build/`, `cli/`, `remote/`) – tylko gdy konieczne, z tokenem w commicie i w PR.

## Patch sety (opcjonalnie)
- Eksport Twoich zmian względem `main`:
  ```bash
  ./scripts/export-patches.sh sophia
  ```
- Aplikacja na świeżą gałąź po dużym update:
  ```bash
  ./scripts/apply-patches.sh sophia-next
  ```

## Konfiguracja
- `safe-fork.config`:
  - `FEATURE_BRANCH` – domyślnie `sophia`
  - `PROTECTED_BRANCHES` – domyślnie `main`
  - `CORE_CHANGE_PATHS` – ścieżki core
  - `OVERRIDE_TOKEN` – `ALLOW-CORE-CHANGE`

## Agent AI
- ZAWSZE zaczynaj od wklejenia `AI_AGENT_README.md` do agenta.
- Agent pracuje na `sophia`, uruchamia `./scripts/safe-sync.sh`, edytuje tylko dozwolone ścieżki.

## Linki
- Fork repo: https://github.com/onCloud9-git/SophiaIDE.git
- Upstream: https://github.com/microsoft/vscode
