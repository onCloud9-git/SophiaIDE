# Requirements Document

## Introduction

Celem jest stworzenie własnej dystrybucji IDE opartej na Visual Studio Code/VSCodium z modyfikacjami, które nie są nadpisywane przy aktualizacjach z upstream. System ma wspierać bezpieczny model forka, separację zmian, automatyczną weryfikację po merge/rebase oraz możliwie najmniejszą ingerencję w core (preferencja: rozszerzenia/tematy/ustawienia nad zmianami w core).

## Requirements

### Requirement 1: Fork i konfiguracja remotes

**User Story:** Jako maintainer własnej dystrybucji IDE chcę mieć prawidłowo skonfigurowanego forka z remotes `origin` i `upstream`, aby móc bezpiecznie pobierać aktualizacje i nie tracić moich zmian.

#### Acceptance Criteria
1. WHEN projekt jest inicjalizowany THEN system SHALL skonfigurować remotes `origin` (fork) i `upstream` (oryginał) z nazwami zgodnymi z konwencją.
2. IF branch `main` nie istnieje lokalnie THEN system SHALL utworzyć lokalny `main` śledzący `origin/main`.
3. WHEN polityki brancha są definiowane THEN system SHALL wymagać ochrony `main` przed bezpośrednimi pushami.

### Requirement 2: Strategia branchy i aktualizacji

**User Story:** Jako maintainer chcę trzymać własne zmiany na oddzielnych gałęziach, aby aktualizacje z upstream były bezpiecznie nakładane.

#### Acceptance Criteria
1. IF dostępny jest update w `upstream/main` THEN system SHALL umożliwić merge albo rebase do lokalnego `main` w sposób powtarzalny.
2. WHEN `main` zostanie zaktualizowany THEN system SHALL umożliwić bezkonfliktowe nałożenie zmian na gałąź funkcjonalną (np. `my-custom-version`).
3. WHEN konflikt wystąpi THEN system SHALL raportować pliki konfliktowe i kończyć proces z kodem błędu.

### Requirement 3: Preferencja rozszerzeń i konfiguracji nad zmianami core

**User Story:** Jako maintainer chcę modyfikować IDE głównie przez rozszerzenia, motywy i konfigurację produktu, aby minimalizować ryzyko konfliktów z upstream.

#### Acceptance Criteria
1. WHEN nowa funkcja jest dodawana THEN system SHALL preferować implementację jako extension/theme/product configuration zamiast modyfikacji core.
2. IF funkcja wymaga zmiany core THEN system SHALL izolować zmiany w minimalnych, jasno zidentyfikowanych modułach.
3. WHEN konfiguracja produktu jest używana THEN system SHALL przechowywać ją w plikach możliwych do przeniesienia między wersjami.

### Requirement 4: Zarządzanie patch setami

**User Story:** Jako maintainer chcę móc eksportować i nakładać moje zmiany jako zestawy łatek (patch sets), aby łatwiej je przenosić po aktualizacjach.

#### Acceptance Criteria
1. WHEN eksport zmian jest uruchamiany THEN system SHALL generować serie łatek `git format-patch` względem `main` do katalogu `patches/`.
2. WHEN aktualizacja z upstream została wykonana THEN system SHALL umożliwić `git am --3way` nakładanie łatek i raportowanie konfliktów.
3. IF łata nie może być zastosowana czysto THEN system SHALL wskazać konkretny commit i pliki do manualnej interwencji.

### Requirement 5: Automatyczne testy po aktualizacji

**User Story:** Jako maintainer chcę, aby po każdej aktualizacji z upstream uruchamiały się testy moich modyfikacji, abym szybko widział regresje.

#### Acceptance Criteria
1. WHEN `main` zostanie zmergowany z `upstream/main` THEN system SHALL uruchomić zestaw testów (lokalnie lub w CI) i zwrócić status.
2. IF testy zakończą się niepowodzeniem THEN system SHALL zatrzymać dalsze wydawanie i zgłosić raport.
3. WHEN testy przejdą THEN system SHALL umożliwić publikację artefaktów (np. build IDE) zgodnie z polityką wydawniczą.

### Requirement 6: Wersjonowanie i release’y

**User Story:** Jako maintainer chcę mieć jasne wersjonowanie własnej dystrybucji, aby użytkownicy wiedzieli, z czym mają do czynienia.

#### Acceptance Criteria
1. WHEN powstaje release THEN system SHALL nadawać wersję semantyczną powiązaną z bazową wersją upstream (np. `1.93.0-sophia.1`).
2. WHEN changelog jest generowany THEN system SHALL rozróżniać zmiany własne i pochodzące z upstream.
3. IF release jest pre-release THEN system SHALL oznaczać go jako preview/beta/rc zgodnie z polityką.

### Requirement 7: Bezpieczeństwo i zgodność licencyjna

**User Story:** Jako maintainer chcę, aby mój fork był bezpieczny i zgodny licencyjnie.

#### Acceptance Criteria
1. WHEN zależności są aktualizowane THEN system SHALL sprawdzać znane podatności (SCA) i raportować krytyczne.
2. WHEN dołączane są zasoby (np. ikony, nazwy) THEN system SHALL weryfikować zgodność z licencją upstream oraz znakami towarowymi.
3. IF naruszenie zostanie wykryte THEN system SHALL blokować build i wymagać decyzji maintainerów.
