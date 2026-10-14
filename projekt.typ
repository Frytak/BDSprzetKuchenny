#set page(
  paper: "a4",
  header: align(right)[
    #text(size: 4.5pt, fill: luma(100))[#title()]
  ],
  footer: align(center)[
    #text(size: 9pt)[
      #context counter(page).display("1 / 1", both: true)
    ]
  ]
)

#set document(
  title: [Projekt Baz Danych],
  author: ("Gabriela Kłos", "Paweł Lelakowski", "Gabriel Pilch", "Piotr Niepsuj"),
  description: [Opisanie bazy danych sklepu internetowego zajmującego się sprzedażą sprzętu do kuchni],
  keywords: ("mariadb", "database", "baza danych")
)

#set text(lang: "pl")
#set heading(numbering: "1.1.")

#align(center)[
  #text(size: 18pt, weight: "bold")[KUCHENNY SKLEP INTERNETOWY]\
  #v(2mm)
  #text(size: 13pt)[Bazy Danych]\
  #text(size: 11pt, style: "italic")[Projekt]
  #v(2mm)
  #text(size: 11pt)[*Autorzy:* Gabriela Kłos, Paweł Lelakowski, Gabriel Pilch, Piotr Niepsuj]
  #v(4mm)
]

#outline(title: none, indent: auto)

#pagebreak()

= Relacje w bazie danych

W projekcie występują następujące relacje między encjami:

*Relacje 1:N (jeden do wielu):*
- `users` (1) $->$ (N) `user_sessions` - jeden użytkownik może mieć wiele sesji logowania (`ON DELETE CASCADE`).
- `users` (1) $->$ (N) `addresses` - użytkownik może zapisać wiele adresów w książce adresowej (`ON DELETE CASCADE`).
- `users` (1) $->$ (N) `orders` - użytkownik może złożyć wiele zamówień (`ON DELETE RESTRICT`).
- `addresses` (1) $->$ (N) `orders` (jako `shipping_address_id` oraz `billing_address_id`) - jeden adres może być użyty w wielu zamówieniach (`ON DELETE RESTRICT`).
- `categories` (1) $->$ (N) `categories` (`parent_id`) - relacja rekurencyjna (drzewo kategorii, np. _Noże i akcesoria do krojenia_ $->$ _Noże szefa kuchni_, `ON DELETE SET NULL`).
- `orders` (1) $->$ (N) `order_items` - jedno zamówienie składa się z wielu pozycji (`ON DELETE CASCADE`).
- `orders` (1) $->$ (N) `payments` - zamówienie może mieć wiele prób płatności (np. pierwsza nieudana, druga opłacona, `ON DELETE RESTRICT`).
- `orders` (1) $->$ (N) `shipments` - zamówienie może zostać wysłane w jednej lub kilku paczkach (`ON DELETE CASCADE`).

*Relacje N:M (wiele do wielu):*
- `products` (N) $<->$ (M) `categories` poprzez tabelę asocjacyjną `product_categories` (produkt może należeć do kilku kategorii, a kategoria zawiera wiele produktów).
- `products` (N) $<->$ (M) `warehouses` poprzez tabelę `inventory` (produkt może znajdować się w wielu magazynach w określonej ilości `quantity`).

#pagebreak()

= Słownik danych

// Konfiguracja wyglądu tabel
#show table.cell.where(y: 0): set text(weight: "bold", fill: white)
#set table(
  stroke: 0.5pt + luma(200),
  inset: (x: 7pt, y: 5.5pt),
  fill: (x, y) => if y == 0 { rgb("#2b4c7e") } else if calc.even(y) { luma(246) } else { white },
)

// Funkcja pomocnicza generująca sekcję dla pojedynczej tabeli SQL
#let slownik-tabela(nazwa, opis, ..wiersze) = block(breakable: false, width: 100%, below: 1.4em)[
  === Tabela #raw(nazwa)
  #opis
  #text(size: 9pt)[
    #table(
      columns: (1.3fr, 1.2fr, 1.8fr, 2.3fr),
      align: (left + horizon, left + horizon, left + horizon, left + horizon),
      table.header(
        [Kolumna], [Typ danych], [Ograniczenia (Constraints)], [Opis atrybutu]
      ),
      ..wiersze
    )
  ]
]

Szczegółowe zestawienie wszystkich 12 tabel tworzących schemat bazy danych sklepu internetowego z wyposażeniem kuchennym wraz z opisem ich przeznaczenia, typami danych oraz więzami integralności.

#slownik-tabela(
  "users",
  [Przechowuje dane kont zarejestrowanych klientów sklepu (zarówno klientów indywidualnych, jak i przedstawicieli restauracji). Stanowi główną encję uwierzytelniania oraz właściciela zamówień i książki adresowej.],
  [`user_id`], [`BIGINT UNSIGNED`], [`PK`, `AUTO_INCREMENT`, `NOT NULL`], [Unikalny identyfikator klienta],
  [`email`], [`VARCHAR(255)`], [`NOT NULL`, `UNIQUE`], [Adres e-mail (służy jako login użytkownika)],
  [`password_hash`], [`VARCHAR(255)`], [`NOT NULL`], [Zahaszowane hasło użytkownika (np. algorytm bcrypt)],
  [`first_name`], [`VARCHAR(100)`], [`NOT NULL`], [Imię klienta],
  [`last_name`], [`VARCHAR(100)`], [`NOT NULL`], [Nazwisko klienta],
  [`phone`], [`VARCHAR(30)`], [`NULL`], [Numer telefonu kontaktowego dla kuriera],
  [`created_at`], [`TIMESTAMP`], [`NOT NULL`, `DEFAULT CURRENT_TIMESTAMP`], [Data i czas rejestracji konta],
  [`updated_at`], [`TIMESTAMP`], [`NOT NULL`, `ON UPDATE CURRENT_TIMESTAMP`], [Data i czas ostatniej aktualizacji profilu],
)

#slownik-tabela(
  "user_sessions",
  [Odpowiada za zarządzanie aktywnymi sesjami logowania użytkowników. Pozwala na śledzenie urządzeń, z których korzysta klient, wygaszanie sesji po określonym czasie oraz ich zdalne unieważnianie.],
  [`session_id`], [`VARCHAR(128)`], [`PK`, `NOT NULL`], [Unikalny kryptograficzny token sesji],
  [`user_id`], [`BIGINT UNSIGNED`], [`FK (users.user_id)`, `NOT NULL`], [Identyfikator zalogowanego użytkownika],
  [`ip_address`], [`VARCHAR(45)`], [`NULL`], [Adres IPv4 lub IPv6 urządzenia klienta],
  [`user_agent`], [`VARCHAR(512)`], [`NULL`], [Sygnatura przeglądarki i systemu operacyjnego],
  [`is_revoked`], [`TINYINT(1)`], [`NOT NULL`, `DEFAULT 0`, `CHECK (0,1)`], [Flaga określająca, czy sesja została ręcznie unieważniona],
  [`created_at`], [`TIMESTAMP`], [`NOT NULL`, `DEFAULT CURRENT_TIMESTAMP`], [Czas rozpoczęcia sesji (zalogowania)],
  [`last_active_at`], [`TIMESTAMP`], [`NOT NULL`, `ON UPDATE CURRENT_TIMESTAMP`], [Czas ostatniego żądania HTTP w ramach sesji],
  [`expires_at`], [`TIMESTAMP`], [`NOT NULL`], [Czas automatycznego wygaśnięcia sesji],
)

#pagebreak()

#slownik-tabela(
  "addresses",
  [Książka adresowa użytkowników. Przechowuje adresy dostaw (np. dom, lokal gastronomiczny) oraz dane adresowe wykorzystywane do wystawiania faktur (adresy rozliczeniowe).],
  [`address_id`], [`BIGINT UNSIGNED`], [`PK`, `AUTO_INCREMENT`, `NOT NULL`], [Unikalny identyfikator adresu],
  [`user_id`], [`BIGINT UNSIGNED`], [`FK (users.user_id)`, `NOT NULL`], [Użytkownik, do którego należy dany adres],
  [`recipient_name`], [`VARCHAR(150)`], [`NOT NULL`], [Imię i nazwisko odbiorcy lub nazwa firmy/restauracji],
  [`street_line1`], [`VARCHAR(255)`], [`NOT NULL`], [Ulica wraz z numerem budynku i lokalu],
  [`street_line2`], [`VARCHAR(255)`], [`NULL`], [Dodatkowe wskazówki adresowe (np. piętro, klatka)],
  [`city`], [`VARCHAR(100)`], [`NOT NULL`], [Miejscowość],
  [`state_province`], [`VARCHAR(100)`], [`NOT NULL`], [Województwo lub region administracyjny],
  [`postal_code`], [`VARCHAR(20)`], [`NOT NULL`], [Kod pocztowy],
  [`country_code`], [`CHAR(2)`], [`NOT NULL`, `DEFAULT 'PL'`], [Dwuliterowy kod kraju w standardzie ISO 3166-1],
  [`created_at`], [`TIMESTAMP`], [`NOT NULL`, `DEFAULT CURRENT_TIMESTAMP`], [Data dodania adresu do książki adresowej],
)

#slownik-tabela(
  "categories",
  [Słownik kategorii asortymentu kuchennego obsługujący strukturę drzewiastą (hierarchiczną) dzięki relacji zwrotnej `parent_id`. Pozwala dzielić główne działy (np. _Noże kuchenne_) na węższe podkategorie (np. _Noże Santoku_).],
  [`category_id`], [`INT UNSIGNED`], [`PK`, `AUTO_INCREMENT`, `NOT NULL`], [Unikalny identyfikator kategorii],
  [`parent_id`], [`INT UNSIGNED`], [`FK (categories.category_id)`, `NULL`], [Wskazanie na kategorię nadrzędną (`NULL` dla głównych)],
  [`name`], [`VARCHAR(100)`], [`NOT NULL`], [Nazwa kategorii wyświetlana w menu sklepu],
  [`slug`], [`VARCHAR(120)`], [`NOT NULL`, `UNIQUE`], [Przyjazny identyfikator URL kategorii (SEO)],
)

#pagebreak()

#slownik-tabela(
  "products",
  [Główny katalog produktów oferowanych przez sklep (noże szefa kuchni, zastawa porcelanowa, patelnie żeliwne, garnki i akcesoria). Przechowuje parametry fizyczne towaru oraz jego bieżącą cenę katalogową.],
  [`product_id`], [`BIGINT UNSIGNED`], [`PK`, `AUTO_INCREMENT`, `NOT NULL`], [Unikalny identyfikator artykułu kuchennego],
  [`sku`], [`VARCHAR(64)`], [`NOT NULL`, `UNIQUE`], [Unikalny kod magazynowy produktu (Stock Keeping Unit)],
  [`name`], [`VARCHAR(200)`], [`NOT NULL`], [Pełna nazwa handlowa produktu],
  [`brand`], [`VARCHAR(100)`], [`NOT NULL`], [Marka / producent (np. _Zwilling_, _Gerlach_, _Le Creuset_)],
  [`material`], [`VARCHAR(100)`], [`NULL`], [Główny surowiec wykonania (np. _Stal damasceńska_, _Żeliwo_)],
  [`description`], [`TEXT`], [`NULL`], [Szczegółowy opis zastosowania i parametrów technicznych],
  [`base_price`], [`DECIMAL(10,2)`], [`NOT NULL`, `CHECK (base_price > 0)`], [Aktualna cena katalogowa brutto (w PLN)],
  [`is_active`], [`TINYINT(1)`], [`NOT NULL`, `DEFAULT 1`, `CHECK (0,1)`], [Czy produkt jest aktualnie widoczny i dostępny w sprzedaży],
  [`created_at`], [`TIMESTAMP`], [`NOT NULL`, `DEFAULT CURRENT_TIMESTAMP`], [Data wprowadzenia produktu do oferty],
  [`updated_at`], [`TIMESTAMP`], [`NOT NULL`, `ON UPDATE CURRENT_TIMESTAMP`], [Data ostatniej modyfikacji danych lub ceny produktu],
)

#pagebreak()

#slownik-tabela(
  "product_categories",
  [Tabela asocjacyjna (łącząca) realizująca relację wiele-do-wielu (N:M) pomiędzy produktami a kategoriami. Umożliwia przypisanie jednego artykułu kuchennego do kilku kategorii jednocześnie.],
  [`product_id`], [`BIGINT UNSIGNED`], [`PK`, `FK (products.product_id)`], [Identyfikator przypisywanego produktu],
  [`category_id`], [`INT UNSIGNED`], [`PK`, `FK (categories.category_id)`], [Identyfikator kategorii, do której należy produkt],
)

#slownik-tabela(
  "warehouses",
  [Wykaz fizycznych magazynów i centrów dystrybucyjnych sklepu na terenie kraju, z których realizowana jest wysyłka zamówionego sprzętu kuchennego.],
  [`warehouse_id`], [`INT UNSIGNED`], [`PK`, `AUTO_INCREMENT`, `NOT NULL`], [Unikalny identyfikator magazynu],
  [`name`], [`VARCHAR(100)`], [`NOT NULL`], [Wewnętrzna nazwa magazynu lub centrum logistycznego],
  [`street_line1`], [`VARCHAR(255)`], [`NOT NULL`], [Ulica i numer budynku magazynu],
  [`city`], [`VARCHAR(100)`], [`NOT NULL`], [Miejscowość lokalizacji magazynu],
  [`postal_code`], [`VARCHAR(20)`], [`NOT NULL`], [Kod pocztowy magazynu],
  [`country_code`], [`CHAR(2)`], [`NOT NULL`, `DEFAULT 'PL'`], [Kod kraju lokalizacji magazynu wg ISO 3166-1],
  [`is_active`], [`TINYINT(1)`], [`NOT NULL`, `DEFAULT 1`, `CHECK (0,1)`], [Flaga określająca, czy magazyn aktywnie obsługuje wysyłki],
)

#slownik-tabela(
  "inventory",
  [Przechowuje aktualne stany magazynowe poszczególnych produktów w konkretnych magazynach. Zapobiega sprzedaży towaru poniżej zera dzięki ograniczeniu `CHECK (quantity >= 0)`.],
  [`warehouse_id`], [`INT UNSIGNED`], [`PK`, `FK (warehouses.warehouse_id)`], [Identyfikator magazynu składowania],
  [`product_id`], [`BIGINT UNSIGNED`], [`PK`, `FK (products.product_id)`], [Identyfikator składowanego produktu],
  [`quantity`], [`INT`], [`NOT NULL`, `DEFAULT 0`, `CHECK (>= 0)`], [Liczba dostępnych sztuk produktu w danym magazynie],
  [`updated_at`], [`TIMESTAMP`], [`NOT NULL`, `ON UPDATE CURRENT_TIMESTAMP`], [Czas ostatniej zmiany stanu magazynowego],
)

#pagebreak()

#slownik-tabela(
  "orders",
  [Tabela nagłówków zamówień składanych przez klientów. Łączy kupującego z wybranym adresem dostawy i adresem rozliczeniowym oraz przechowuje aktualny status realizacji i łączną wartość koszyka.],
  [`order_id`], [`BIGINT UNSIGNED`], [`PK`, `AUTO_INCREMENT`, `NOT NULL`], [Unikalny numer zamówienia],
  [`user_id`], [`BIGINT UNSIGNED`], [`FK (users.user_id)`, `NOT NULL`], [Klient składający zamówienie],
  [`shipping_address_id`], [`BIGINT UNSIGNED`], [`FK (addresses.address_id)`, `NOT NULL`], [Adres fizycznej dostawy zamówienia],
  [`billing_address_id`], [`BIGINT UNSIGNED`], [`FK (addresses.address_id)`, `NOT NULL`], [Adres rozliczeniowy (do faktury)],
  [`order_status`], [`ENUM(...)`], [`NOT NULL`, `DEFAULT 'pending'`], [Status zamówienia (`pending`, `paid`, `processing`, `shipped`, `delivered`, `cancelled`)],
  [`total_amount`], [`DECIMAL(10,2)`], [`NOT NULL`, `DEFAULT 0.00`, `CHECK (>= 0)`], [Łączna wartość brutto wszystkich pozycji zamówienia],
  [`created_at`], [`TIMESTAMP`], [`NOT NULL`, `DEFAULT CURRENT_TIMESTAMP`], [Data i czas złożenia zamówienia],
)

#slownik-tabela(
  "order_items",
  [Szczegółowy wykaz pozycji wchodzących w skład zamówienia. Rejestruje zamawianą ilość, magazyn wydania towaru oraz historyczną cenę jednostkową obowiązującą w momencie zakupu.],
  [`order_item_id`], [`BIGINT UNSIGNED`], [`PK`, `AUTO_INCREMENT`, `NOT NULL`], [Unikalny identyfikator pozycji zamówienia],
  [`order_id`], [`BIGINT UNSIGNED`], [`FK (orders.order_id)`, `NOT NULL`], [Odwołanie do nadrzędnego zamówienia],
  [`product_id`], [`BIGINT UNSIGNED`], [`FK (products.product_id)`, `NOT NULL`], [Zamówiony produkt kuchenny],
  [`warehouse_id`], [`INT UNSIGNED`], [`FK (warehouses.warehouse_id)`, `NOT NULL`], [Magazyn, z którego towar zostaje zarezerwowany i wysłany],
  [`quantity`], [`INT UNSIGNED`], [`NOT NULL`, `CHECK (quantity > 0)`], [Liczba zamówionych sztuk danego artykułu],
  [`unit_price`], [`DECIMAL(10,2)`], [`NOT NULL`, `CHECK (unit_price >= 0)`], [Cena jednostkowa brutto produktu w chwili zakupu],
)

#pagebreak()

#slownik-tabela(
  "payments",
  [Rejestr transakcji płatniczych powiązanych z zamówieniami. Pozwala śledzić wybraną metodę płatności, zewnętrzne numery referencyjne bramek płatniczych, nieudane próby oraz zwroty.],
  [`payment_id`], [`BIGINT UNSIGNED`], [`PK`, `AUTO_INCREMENT`, `NOT NULL`], [Unikalny identyfikator operacji płatniczej],
  [`order_id`], [`BIGINT UNSIGNED`], [`FK (orders.order_id)`, `NOT NULL`], [Identyfikator opłacanego zamówienia],
  [`payment_method`], [`ENUM(...)`], [`NOT NULL`], [Kanał płatności (`credit_card`, `paypal`, `bank_transfer`, `stripe`, `blik`)],
  [`transaction_reference`], [`VARCHAR(255)`], [`NOT NULL`, `UNIQUE`], [Unikalny identyfikator transakcji z zewnętrznego systemu płatności],
  [`amount`], [`DECIMAL(10,2)`], [`NOT NULL`, `CHECK (amount > 0)`], [Kwota płatności w PLN],
  [`payment_status`], [`ENUM(...)`], [`NOT NULL`, `DEFAULT 'initiated'`], [Status transakcji (`initiated`, `completed`, `failed`, `refunded`)],
  [`paid_at`], [`TIMESTAMP`], [`NULL`], [Data i czas potwierdzenia wpłaty (`NULL` dla nieopłaconych)],
)

#slownik-tabela(
  "shipments",
  [Ewidencja przesyłek kurierskich i paczkomatowych realizujących dostawę zamówienia. Jedno zamówienie może być podzielone na wiele przesyłek (np. przy wysyłce z różnych magazynów).],
  [`shipment_id`], [`BIGINT UNSIGNED`], [`PK`, `AUTO_INCREMENT`, `NOT NULL`], [Unikalny identyfikator przesyłki],
  [`order_id`], [`BIGINT UNSIGNED`], [`FK (orders.order_id)`, `NOT NULL`], [Identyfikator wysyłanego zamówienia],
  [`carrier`], [`VARCHAR(100)`], [`NOT NULL`], [Nazwa przewoźnika (np. _InPost Paczkomaty_, _DPD Polska_, _DHL_)],
  [`tracking_number`], [`VARCHAR(150)`], [`NULL`, `UNIQUE`], [Unikalny numer listu przewozowego do śledzenia paczki],
  [`shipment_status`], [`ENUM(...)`], [`NOT NULL`, `DEFAULT 'label_created'`], [Status logistyczny (`label_created`, `in_transit`, `out_for_delivery`, `delivered`)],
  [`shipped_at`], [`TIMESTAMP`], [`NULL`], [Data i czas przekazania paczki kurierowi],
  [`delivered_at`], [`TIMESTAMP`], [`NULL`], [Data i czas doręczenia przesyłki odbiorcy],
)

#pagebreak()

= Uzasadnienie normalizacji

Zaprojektowany schemat bazy danych spełnia wymogi co najmniej *trzeciej postaci normalnej (3NF)*:

+ *Pierwsza Postać Normalna (1NF):*
  - Wszystkie atrybuty w tabelach są *atomowe* (niepodzielne) - np. dane osobowe zostały rozbite na `first_name` i `last_name`, a dane adresowe na `street_line1`, `street_line2`, `city`, `state_province`, `postal_code` oraz `country_code`.
  - Brak powtarzających się grup kolumn (np. zamiast kolumn `category_1`, `category_2` w tabeli `products`, wydzielono tabelę łączącą `product_categories`).
  - Każda tabela posiada zdefiniowany klucz główny (`PRIMARY KEY`).

+ *Druga Postać Normalna (2NF):*
  - Spełnione są warunki 1NF, a każdy atrybut niebędący częścią klucza zależy *w pełni funkcjonalnie* od całego klucza głównego.
  - W tabelach ze złożonym kluczem głównym (`inventory` z kluczem `(warehouse_id, product_id)` oraz `product_categories` z kluczem `(product_id, category_id)`) atrybuty niekluczowe (np. `quantity` w `inventory`) zależą od obu elementów klucza jednocześnie - stan magazynowy dotyczy konkretnego produktu w konkretnym magazynie. Dane opisujące sam magazyn (`city`, `name`) znajdują się wyłącznie w tabeli `warehouses`.

+ *Trzecia Postać Normalna (3NF):*
  - Spełnione są warunki 2NF oraz *nie występują zależności przechodnie* (atrybuty niekluczowe zależą wyłącznie od klucza głównego, a nie od innych atrybutów niekluczowych).
  - Adresy dostawy i adresy rozliczeniowe zostały wydzielone do osobnej tabeli `addresses`, dzięki czemu zmiana adresu użytkownika lub przypisanie go do zamówienia nie powoduje duplikowania danych adresowych w tabeli `orders`.
  - *Uwaga projektowa dotycząca cen historycznych:* Kolumna `unit_price` w tabeli `order_items` przechowuje cenę produktu *w momencie zakupu* (np. z uwzględnieniem ówczesnego cennika lub promocji), natomiast `base_price` w tabeli `products` to bieżąca cena katalogowa. Dzięki temu późniejsza zmiana ceny noża czy garnka w katalogu nie fałszuje historycznych faktur i zamówień. Z kolei `total_amount` w tabeli `orders` jest automatycznie synchronizowane przez wyzwalacze (`TRIGGERS`) na poziomie bazy danych.
