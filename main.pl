
:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- dynamic(resource/2).
:- dynamic(inventory/2).
:- dynamic(machine_schedule/2).
:- dynamic(new_product/3).
:- dynamic(machine/2).

% Fakty dotyczace zasobów
resource(wood, 1000).
resource(iron, 500).
resource(plastic, 300).

% Fakty dotyczace produktów
new_product(chair, [resource(wood, 5), resource(plastic, 2)], 30).
new_product(table, [resource(wood, 15), resource(iron, 5)], 60).
new_product(toy_car, [resource(plastic, 10), resource(iron, 1)], 120).

% Fakty dotyczace stanu magazynu
inventory(chair, 50).
inventory(table, 20).
inventory(toy_car, 100).

% Fakty dotyczace dostepnych maszyn
machine(machine1, [chair, table]).
machine(machine2, [toy_car]).

% Fakty dotyczace harmonogramu maszyn
machine_schedule(machine1, []).
machine_schedule(machine2, []).

% Predykaty sprawdzajace dostepnosc zasobów
available_resource(Name, Quantity) :-
    resource(Name, Available), Available >= Quantity.

% Predykat do tworzenia nowego produktu
product(Name, Resources, Time) :-
    new_product(Name, Resources, Time).

% Predykaty do produkcji
can_produce(Product, Quantity) :-
    product(Product, Resources, _),
    can_produce_resources(Resources, Quantity).
can_produce_resources([], _).
can_produce_resources([resource(Name, RequiredQuantity)|T], Quantity) :-
    TotalRequired is RequiredQuantity * Quantity,
    available_resource(Name, TotalRequired),
    can_produce_resources(T, Quantity).

% Predykaty zuzywajace zasoby
consume_resources([], _).
consume_resources([resource(Name, RequiredQuantity)|T], Quantity) :-
    TotalRequired is RequiredQuantity * Quantity,
    resource(Name, Available),
    NewQuantity is Available - TotalRequired,
    retract(resource(Name, Available)),
    assert(resource(Name, NewQuantity)),
    consume_resources(T, Quantity).

% Aktualizacja stanu magazynu
update_inventory(Product, Quantity) :-
    inventory(Product, CurrentQuantity),
    NewQuantity is CurrentQuantity + Quantity,
    retract(inventory(Product, CurrentQuantity)),
    assert(inventory(Product, NewQuantity)).

% Produkcja produktów
produce(Product, Quantity) :-
    can_produce(Product, Quantity),
    product(Product, Resources, Time),
    consume_resources(Resources, Quantity),
    update_inventory(Product, Quantity),
    format('Produced ~w ~w(s) in ~w minutes~n', [Quantity, Product, Time]).

% Predykat do dodawania zasobów
add_resource(Name, Quantity) :-
    validate_resource(Name, Quantity),
    (   retract(resource(Name, CurrentQuantity))
    ->  NewQuantity is CurrentQuantity + Quantity
    ;   NewQuantity is Quantity),
    assert(resource(Name, NewQuantity)).

add_new_resource(Name, InitialQuantity) :-
    validate_resource(Name, InitialQuantity),
    assert(resource(Name, InitialQuantity)).

% Predykaty do wyswietlania stanu magazynu
display_inventory :-
    findall((Product, Quantity), inventory(Product, Quantity), InventoryList),
    display_inventory_list(InventoryList).
display_inventory_list([]).
display_inventory_list([(Product, Quantity)|T]) :-
    format('~w: ~w~n', [Product, Quantity]),
    display_inventory_list(T).

% Predykaty do wyswietlania zasobów
display_resources :-
    findall((Name, Quantity), resource(Name, Quantity), ResourceList),
    display_resource_list(ResourceList).
display_resource_list([]).
display_resource_list([(Name, Quantity)|T]) :-
    format('~w: ~w~n', [Name, Quantity]),
    display_resource_list(T).

% Predykaty do zarzadzania harmonogramem maszyn
schedule_production(Product, Quantity, Machine) :-
    machine(Machine, CapableProducts),
    member(Product, CapableProducts),
    can_produce(Product, Quantity), % Sprawdzanie, czy mozliwa jest produkcja
    produce(Product, Quantity), % Produkcja
    machine_schedule(Machine, Schedule),
    append(Schedule, [(Product, Quantity)], NewSchedule),
    retract(machine_schedule(Machine, Schedule)),
    assert(machine_schedule(Machine, NewSchedule)).

% Wyswietlanie harmonogramu maszyn
display_schedule(Machine) :-
    machine_schedule(Machine, Schedule),
    format('Schedule for ~w: ~w~n', [Machine, Schedule]).

% Predykat sprawdzajacy poprawnosc danych dla dodawania zasobu
validate_resource(Name, Quantity) :-
    nonvar(Name), nonvar(Quantity),
    atom(Name), integer(Quantity), Quantity >= 0.

% Predykat sprawdzajacy poprawnosc danych dla dodawania produktu
validate_product(Name, Resources, Time) :-
    nonvar(Name), nonvar(Resources), nonvar(Time),
    atom(Name), is_list(Resources), all_resources_valid(Resources),
    integer(Time), Time >= 0.

% Predykat pomocniczy sprawdzajacy, czy wszystkie zasoby w liscie sa poprawne
all_resources_valid([]).
all_resources_valid([resource(Name, Quantity)|T]) :-
    atom(Name), integer(Quantity), Quantity >= 0,
    all_resources_valid(T).

% Predykat do dodawania nowych produktów
%add_product(Name, Resources, Time) :-
%    \+ new_product(Name, _, _), % Sprawdz, czy produkt juz istnieje
%    assert(new_product(Name, Resources, Time)),
%    format('Added new product: ~w~n', [Name]).
%
%add_product(Name, _, _) :-
%    format('Product ~w already exists. Cannot add duplicate products.~n', [Name]),
%    fail.

% Interfejs użytkownika
start_interface :-
    new(Dialog, dialog('Production Management System')),

    % Przycisk do wyświetlania stanu magazynu
    send_list(Dialog, append,
              [ new(DisplayInventory, button('Display Inventory',
                                             message(@prolog, display_inventory_ui))),

                % Przycisk do wyświetlania zasobów
                new(DisplayResources, button('Display Resources',
                                             message(@prolog, display_resources_ui))),

                % Przycisk do dodawania zasobów
                new(AddResource, button('Add Resource',
                                        message(@prolog, add_resource_ui))),

                % Przycisk do produkcji produktów
                new(ProduceProduct, button('Produce Product',
                                           message(@prolog, produce_product_ui))),

                % Przycisk do harmonogramu produkcji
                new(ScheduleProduction, button('Schedule Production',
                                               message(@prolog, schedule_production_ui))),
                % Przycisk do dodawania nowych produkt�w
                new(AddProduct, button('Add Product',
                                               message(@prolog, add_product_ui))),

                % Przycisk do wyjścia
                new(Exit, button('Exit', message(Dialog, destroy)))
              ]),
    send(Dialog, open).

% Funkcja wyświetlająca stan magazynu
display_inventory_ui :-
    findall((Product, Quantity), inventory(Product, Quantity), InventoryList),
    new(Dialog, dialog('Inventory')),
    display_inventory_list_ui(InventoryList, Dialog),
    send(Dialog, open).

display_inventory_list_ui([], _).
display_inventory_list_ui([(Product, Quantity)|T], Dialog) :-
    send(Dialog, append, label(text, string('%s: %d', Product, Quantity))),
    display_inventory_list_ui(T, Dialog).

% Funkcja wyświetlająca zasoby
display_resources_ui :-
    findall((Name, Quantity), resource(Name, Quantity), ResourceList),
    new(Dialog, dialog('Resources')),
    display_resource_list_ui(ResourceList, Dialog),
    send(Dialog, open).

display_resource_list_ui([], _).
display_resource_list_ui([(Name, Quantity)|T], Dialog) :-
    send(Dialog, append, label(text, string('%s: %d', Name, Quantity))),
    display_resource_list_ui(T, Dialog).

% Funkcja do dodawania zasobów
add_resource_ui :-
    new(Dialog, dialog('Add Resource')),
    send_list(Dialog, append,
              [ new(NameItem, text_item(name)),
                new(QuantityItem, int_item(quantity)),
                button(ok, message(@prolog, add_resource_ui_action,
                                   NameItem?selection, QuantityItem?selection)),
                button(cancel, message(Dialog, destroy))
              ]),
    send(Dialog, open).

add_resource_ui_action(Name, Quantity) :-
    (   integer(Quantity), Quantity > 0
    ->  add_resource(Name, Quantity),
        send(@display, inform, 'Resource added successfully.')
    ;   send(@display, inform, 'Invalid quantity.')
    ).

% Funkcja do produkcji produktów
produce_product_ui :-
    new(Dialog, dialog('Produce Product')),
    send_list(Dialog, append,
              [ new(ProductItem, text_item(product)),
                new(QuantityItem, int_item(quantity)),
                button(ok, message(@prolog, produce_product_ui_action,
                                   ProductItem?selection, QuantityItem?selection)),
                button(cancel, message(Dialog, destroy))
              ]),
    send(Dialog, open).

produce_product_ui_action(Product, Quantity) :-
    (   produce(Product, Quantity)
    ->  send(@display, inform, 'Product produced successfully.')
    ;   send(@display, inform, 'Failed to produce product.')
    ).

% Funkcja do harmonogramowania produkcji
schedule_production_ui :-
    new(Dialog, dialog('Schedule Production')),
    send_list(Dialog, append,
              [ new(ProductItem, text_item(product)),
                new(QuantityItem, int_item(quantity)),
                new(MachineItem, text_item(machine)),
                button(ok, message(@prolog, schedule_production_ui_action,
                                   ProductItem?selection, QuantityItem?selection,
                                   MachineItem?selection)),
                button(cancel, message(Dialog, destroy))
              ]),
    send(Dialog, open).

schedule_production_ui_action(Product, Quantity, Machine) :-
    (   schedule_production(Product, Quantity, Machine)
    ->  send(@display, inform, 'Production scheduled successfully.')
    ;   send(@display, inform, 'Failed to schedule production.')
    ).

% Predykat do dodawania nowych produktów
add_product_ui :-
    findall(Name, resource(Name, _), ResourceNames),
    new(Dialog, dialog('Add Product')),
    send(Dialog, append, new(NameItem, text_item(name))),
    send(Dialog, append, new(TimeItem, int_item(time))),
    create_resource_fields(ResourceNames, Fields, Dialog, []),
    send(Dialog, append, button(ok, message(@prolog, add_product_ui_action, NameItem?selection, TimeItem?selection, Fields))),
    send(Dialog, append, button(cancel, message(Dialog, destroy))),
    send(Dialog, open).

get_name_and_time(NameItem, TimeItem, Fields) :-
    get(NameItem, selection, Name),
    get(TimeItem, selection, Time),
    add_product_ui_action(Name, Fields, Time).

create_resource_fields([], [], _, _).
create_resource_fields([ResourceName|ResourceNames], [Field|Fields], Dialog, Acc) :-
    new(Field, int_item(ResourceName)),
    send(Dialog, append, Field),
    create_resource_fields(ResourceNames, Fields, Dialog, Acc).

add_product_ui_action(Name, Time, Fields) :-
    get_values(Fields, Values),
    findall(ResourceName, resource(ResourceName, _), ResourceNames),
    create_resources(ResourceNames, Values, Resources),
    (   new_product(Name, _, _)
    ->  send(@display, inform, 'Product ~w already exists. Cannot add duplicate products.', [Name])
    ;   assert(new_product(Name, Resources, Time)),
        send(@display, inform, 'Product added successfully.')
    ).

get_values([], []).
get_values([Field|Fields], [Value|Values]) :-
    get(Field, selection, Value),
    get_values(Fields, Values).

create_resources([], [], []).
create_resources([ResourceName|ResourceNames], [Value|Values], [resource(ResourceName, Value)|Resources]) :-
    create_resources(ResourceNames, Values, Resources).

%:- export(add_product_ui_action/3).


% Uruchomienie interfejsu
:- start_interface.
