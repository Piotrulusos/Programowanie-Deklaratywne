# System Zarządzania Produkcją
Ten oparty na Prologu System Zarządzania Produkcją zapewnia interfejs użytkownika do zarządzania zasobami, stanem magazynu i harmonogramami produkcji. System umożliwia użytkownikom wyświetlanie aktualnych zasobów i stanu magazynu, dodawanie zasobów, produkcję produktów, harmonogramowanie produkcji na określonych maszynach oraz dodawanie nowych produktów.

## Funkcje
- Wyświetlanie stanu magazynu: Wyświetla bieżący stan magazynu produktów.
- Wyświetlanie zasobów: Wyświetla dostępne zasoby i ich ilości.
- Dodawanie zasobu: Dodaje nowy zasób lub zwiększa ilość istniejącego zasobu.
- Produkcja produktu: Produkuje określoną ilość produktu, zużywając niezbędne zasoby.
- Harmonogramowanie produkcji: Harmonogramuje produkcję produktu na określonej maszynie.
- Dodawanie produktu: Dodaje nowe produkty do systemu z określonymi wymaganiami dotyczącymi zasobów i czasem produkcji.

## Struktura plików
- main.pl: Główny plik Prolog zawierający logikę systemu zarządzania produkcją.
- README.md: Dokumentacja pliku.
- Dokumentacja.odt Dokumentacja pliku nr2.

# Jak uruchomić
Upewnij się, że masz zainstalowany SWI-Prolog na swoim komputerze.
Otwórz SWI-Prolog i skompiluj plik main.pl używając następującego polecenia:

?- [main].

Uruchom interfejs użytkownika, wykonując predykat start_interface/0:

?- start_interface.

Pojawi się okno dialogowe, zapewniające przyciski do różnych operacji.

# Wyjaśnienie kodu
## Dynamiczne predykaty
- resource/2: Przechowuje dostępne zasoby i ich ilości.
- inventory/2: Przechowuje bieżący stan magazynu produktów i ich ilości.
- machine_schedule/2: Przechowuje harmonogram produkcji dla każdej maszyny.
- new_product/3: Przechowuje definicję nowych produktów, ich wymagania dotyczące zasobów i czas produkcji.
- machine/2: Przechowuje maszyny i produkty, które mogą one produkować.

## Predykaty
- available_resource/2: Sprawdza, czy określona ilość zasobu jest dostępna.
- product/3: Pobiera definicję produktu.
- can_produce/2: Sprawdza, czy można wyprodukować określoną ilość produktu na podstawie dostępnych zasobów.
- consume_resources/2: Zużywa wymagane zasoby do produkcji określonej ilości produktu.
- update_inventory/2: Aktualizuje stan magazynu po produkcji.
- produce/2: Produkuje określoną ilość produktu, jeśli jest to możliwe.
- add_resource/2: Dodaje określoną ilość zasobu.
- display_inventory/0: Wyświetla bieżący stan magazynu.
- display_resources/0: Wyświetla dostępne zasoby.
- schedule_production/3: Harmonogramuje produkcję produktu na określonej maszynie.
- display_schedule/1: Wyświetla harmonogram produkcji dla określonej maszyny.
- validate_resource/2: Waliduje dane dla dodawania zasobu.
- validate_product/3: Waliduje dane dla dodawania produktu.
- add_product_ui_action/3: Dodaje nowy produkt do systemu.

## Interfejs użytkownika
- start_interface/0: Inicjalizuje i otwiera główne okno dialogowe.
- display_inventory_ui/0: Wyświetla bieżący stan magazynu w oknie dialogowym.
- display_resources_ui/0: Wyświetla dostępne zasoby w oknie dialogowym.
- add_resource_ui/0: Otwiera okno dialogowe do dodawania nowego zasobu.
- add_resource_ui_action/2: Obsługuje akcję dodawania zasobu z interfejsu użytkownika.
- produce_product_ui/0: Otwiera okno dialogowe do produkcji produktu.
- produce_product_ui_action/2: Obsługuje akcję produkcji produktu z interfejsu użytkownika.
- schedule_production_ui/0: Otwiera okno dialogowe do harmonogramowania produkcji.
- schedule_production_ui_action/3: Obsługuje akcję harmonogramowania produkcji z interfejsu użytkownika.
- add_product_ui/0: Otwiera okno dialogowe do dodawania nowego produktu.
- get_name_and_time/3: Pobiera nazwę i czas dla nowego produktu z interfejsu użytkownika.
- create_resource_fields/4: Tworzy pola wprowadzania dla ilości zasobów w oknie dialogowym dodawania produktu.
- add_product_ui_action/3: Obsługuje akcję dodawania nowego produktu z interfejsu użytkownika.
- get_values/2: Pobiera wartości z pól wprowadzania.
- create_resources/3: Tworzy struktury zasobów z wartości wprowadzonych.
# Przykładowe użycie

Aby dodać 100 jednostek drewna, można uruchomić następujące polecenie w konsoli Prolog:

?- add_resource(wood, 100).

Aby wyprodukować 10 krzeseł, można uruchomić:

?- produce(chair, 10).

Aby harmonogramować produkcję 5 stołów na maszynie 1, można uruchomić:

?- schedule_production(table, 5, machine1).




