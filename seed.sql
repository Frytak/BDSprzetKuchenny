USE `projekt`;

-- ============================================================================
-- 1. UŻYTKOWNICY - users (18 rekordów)
-- ============================================================================
INSERT INTO `users` (`user_id`, `email`, `password_hash`, `first_name`, `last_name`, `phone`, `created_at`) VALUES
(1, 'anna.kowalska@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Anna', 'Kowalska', '+48 501 234 567', '2026-01-10 10:15:00'),
(2, 'piotr.nowak@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Piotr', 'Nowak', '+48 602 345 678', '2026-01-18 14:20:00'),
(3, 'katarzyna.wisniewska@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Katarzyna', 'Wiśniewska', '+48 703 456 789', '2026-02-02 09:00:00'),
(4, 'marek.wojcik@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Marek', 'Wójcik', '+48 504 567 890', '2026-02-14 18:30:00'),
(5, 'magdalena.kaminska@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Magdalena', 'Kamińska', '+48 605 678 901', '2026-03-01 11:45:00'),
(6, 'tomasz.lewandowski@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tomasz', 'Lewandowski', '+48 706 789 012', '2026-03-19 16:10:00'),
(7, 'agnieszka.zielinska@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Agnieszka', 'Zielińska', '+48 507 890 123', '2026-04-05 08:25:00'),
(8, 'michal.szymanski@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Michał', 'Szymański', '+48 608 901 234', '2026-04-22 12:00:00'),
(9, 'natalia.wozniak@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Natalia', 'Woźniak', '+48 509 012 345', '2026-05-10 15:50:00'),
(10, 'krzysztof.dabrowski@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Krzysztof', 'Dąbrowski', '+48 610 123 456', '2026-05-28 20:05:00'),
(11, 'karolina.kozlowska@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Karolina', 'Kozłowska', '+48 711 234 567', '2026-06-11 13:40:00'),
(12, 'pawel.jankowski@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Paweł', 'Jankowski', '+48 512 345 678', '2026-06-25 17:15:00'),
(13, 'monika.mazur@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Monika', 'Mazur', '+48 613 456 789', '2026-07-08 10:00:00'),
(14, 'lukasz.kwiatkowski@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Łukasz', 'Kwiatkowski', '+48 714 567 890', '2026-07-29 19:20:00'),
(15, 'dorota.krawczyk@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Dorota', 'Krawczyk', '+48 515 678 901', '2026-08-14 09:35:00'),
(16, 'marcin.kaczmarek@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Marcin', 'Kaczmarek', '+48 616 789 012', '2026-09-02 14:55:00'),
(17, 'julia.piotrowska@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Julia', 'Piotrowska', NULL, '2026-09-20 11:10:00'),
(18, 'grzegorz.grabowski@example.pl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Grzegorz', 'Grabowski', '+48 518 901 234', '2026-10-01 08:00:00');

-- ============================================================================
-- 2. SESJE UŻYTKOWNIKÓW - user_sessions (18 rekordów)
-- ============================================================================
INSERT INTO `user_sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `is_revoked`, `expires_at`) VALUES
('sess_01_a1b2c3d4e5', 1, '192.168.1.10', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0', 0, DATE_ADD(NOW(), INTERVAL 7 DAY)),
('sess_02_a1b2c3d4e5', 1, '83.10.20.30', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X)', 0, DATE_ADD(NOW(), INTERVAL 14 DAY)),
('sess_03_a1b2c3d4e5', 2, '10.0.0.25', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) Safari/605.1', 0, DATE_ADD(NOW(), INTERVAL 7 DAY)),
('sess_04_a1b2c3d4e5', 3, '172.16.0.5', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0)', 0, DATE_ADD(NOW(), INTERVAL 3 DAY)),
('sess_05_a1b2c3d4e5', 4, '192.168.1.55', 'Mozilla/5.0 (X11; Linux x86_64) Firefox/129.0', 1, DATE_SUB(NOW(), INTERVAL 5 DAY)),
('sess_06_a1b2c3d4e5', 5, '192.168.2.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Edge/127.0', 0, DATE_ADD(NOW(), INTERVAL 5 DAY)),
('sess_07_a1b2c3d4e5', 6, '10.10.1.99', 'Mozilla/5.0 (Android 14; Mobile; rv:128.0)', 0, DATE_ADD(NOW(), INTERVAL 2 DAY)),
('sess_08_a1b2c3d4e5', 7, '195.114.0.12', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0', 1, DATE_SUB(NOW(), INTERVAL 2 DAY)),
('sess_09_a1b2c3d4e5', 8, '89.64.12.45', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 14_6) Chrome/129.0', 0, DATE_ADD(NOW(), INTERVAL 10 DAY)),
('sess_10_a1b2c3d4e5', 8, '89.64.12.46', 'Mozilla/5.0 (iPad; CPU OS 17_5 like Mac OS X)', 0, DATE_ADD(NOW(), INTERVAL 10 DAY)),
('sess_11_a1b2c3d4e5', 9, '31.179.40.11', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Firefox/130.0', 0, DATE_ADD(NOW(), INTERVAL 6 DAY)),
('sess_12_a1b2c3d4e5', 10, '77.253.11.80', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64) Chrome/128.0', 0, DATE_ADD(NOW(), INTERVAL 4 DAY)),
('sess_13_a1b2c3d4e5', 11, '188.146.22.10', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_7)', 1, DATE_SUB(NOW(), INTERVAL 10 DAY)),
('sess_14_a1b2c3d4e5', 12, '91.210.55.3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/129.0', 0, DATE_ADD(NOW(), INTERVAL 8 DAY)),
('sess_15_a1b2c3d4e5', 13, '178.42.19.200', 'Mozilla/5.0 (Android 13; SM-G991B)', 0, DATE_ADD(NOW(), INTERVAL 1 DAY)),
('sess_16_a1b2c3d4e5', 14, '83.24.119.50', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_6)', 0, DATE_ADD(NOW(), INTERVAL 5 DAY)),
('sess_17_a1b2c3d4e5', 15, '212.160.10.15', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 1, DATE_SUB(NOW(), INTERVAL 1 DAY)),
('sess_18_a1b2c3d4e5', 16, '46.205.88.91', 'Mozilla/5.0 (Windows NT 11.0; Win64; x64) Chrome/129.0', 0, DATE_ADD(NOW(), INTERVAL 9 DAY));

-- ============================================================================
-- 3. ADRESY - addresses (20 rekordów)
-- ============================================================================
INSERT INTO `addresses` (`address_id`, `user_id`, `recipient_name`, `street_line1`, `street_line2`, `city`, `state_province`, `postal_code`, `country_code`) VALUES
(1, 1, 'Anna Kowalska', 'ul. Floriańska 15/4', NULL, 'Kraków', 'Małopolskie', '31-019', 'PL'),
(2, 2, 'Piotr Nowak', 'ul. Marszałkowska 88/12', 'Klatka B', 'Warszawa', 'Mazowieckie', '00-517', 'PL'),
(3, 3, 'Katarzyna Wiśniewska', 'ul. Długa 42/7', NULL, 'Gdańsk', 'Pomorskie', '80-827', 'PL'),
(4, 4, 'Marek Wójcik', 'ul. Piotrkowska 120', 'Piętro 2', 'Łódź', 'Łódzkie', '90-006', 'PL'),
(5, 5, 'Magdalena Kamińska', 'ul. Świdnicka 19/3', NULL, 'Wrocław', 'Dolnośląskie', '50-066', 'PL'),
(6, 6, 'Tomasz Lewandowski', 'ul. Półwiejska 14/8', NULL, 'Poznań', 'Wielkopolskie', '61-888', 'PL'),
(7, 7, 'Agnieszka Zielińska', 'ul. 3 Maja 9/2', NULL, 'Katowice', 'Śląskie', '40-096', 'PL'),
(8, 8, 'Restauracja Smaki - Kuchnia (Dostawy)', 'ul. Grodzka 22', 'Wejście od podwórza', 'Kraków', 'Małopolskie', '31-044', 'PL'),
(9, 9, 'Natalia Woźniak', 'Al. Niepodległości 30/10', NULL, 'Szczecin', 'Zachodniopomorskie', '70-404', 'PL'),
(10, 10, 'Krzysztof Dąbrowski', 'ul. Krakowskie Przedmieście 51/6', NULL, 'Lublin', 'Lubelskie', '20-076', 'PL'),
(11, 11, 'Karolina Kozłowska', 'ul. Lipowa 18/9', NULL, 'Białystok', 'Podlaskie', '15-427', 'PL'),
(12, 12, 'Paweł Jankowski', 'ul. Rejtana 10/45', 'Blok C', 'Rzeszów', 'Podkarpackie', '35-310', 'PL'),
(13, 13, 'Monika Mazur', 'ul. Gdańska 27/4', NULL, 'Bydgoszcz', 'Kujawsko-Pomorskie', '85-005', 'PL'),
(14, 14, 'Łukasz Kwiatkowski', 'ul. Staromiejska 5/1', NULL, 'Olsztyn', 'Warmińsko-Mazurskie', '10-017', 'PL'),
(15, 15, 'Dorota Krawczyk', 'ul. Sienkiewicza 33/11', NULL, 'Kielce', 'Świętokrzyskie', '25-007', 'PL'),
(16, 16, 'Marcin Kaczmarek', 'ul. Bohaterów Westerplatte 12/3', NULL, 'Zielona Góra', 'Lubuskie', '65-034', 'PL'),
(17, 17, 'Julia Piotrowska', 'ul. Krakowska 40/8', NULL, 'Opole', 'Opolskie', '45-075', 'PL'),
(18, 18, 'Grzegorz Grabowski', 'ul. Kościuszki 11/2', NULL, 'Toruń', 'Kujawsko-Pomorskie', '87-100', 'PL'),
(19, 1, 'Biuro Rachunkowe Anna Kowalska', 'ul. Mogilska 65', 'Lokal 4B', 'Kraków', 'Małopolskie', '31-545', 'PL'),
(20, 8, 'Gastro-Smaki Sp. z o.o. (Siedziba / Faktury)', 'ul. Królewska 90', 'Biuro Zarządu', 'Kraków', 'Małopolskie', '30-079', 'PL');

-- ============================================================================
-- 4. KATEGORIE ZASOBÓW KUCHENNYCH - categories (16 rekordów - drzewo)
-- ============================================================================
INSERT INTO `categories` (`category_id`, `parent_id`, `name`, `slug`) VALUES
(1, NULL, 'Noże i akcesoria do krojenia', 'noze-i-akcesoria-do-krojenia'),
(2, NULL, 'Zastawa stołowa i serwowanie', 'zastawa-stolowa-i-serwowanie'),
(3, NULL, 'Garnki, patelnie i gotowanie', 'garnki-patelnie-i-gotowanie'),
(4, NULL, 'Pieczenie i formy kuchenne', 'pieczenie-i-formy-kuchenne'),
(5, NULL, 'Kawa, herbata i bar', 'kawa-herbata-i-bar'),
(6, NULL, 'Przechowywanie i organizacja', 'przechowywanie-i-organizacja'),
(7, 1, 'Noże szefa kuchni', 'noze-szefa-kuchni'),
(8, 1, 'Noże japońskie Santoku i Nakiri', 'noze-japonskie-santoku-i-nakiri'),
(9, 1, 'Deski do krojenia i bloki', 'deski-do-krojenia-i-bloki'),
(10, 1, 'Ostrzałki i kamienie wodne', 'ostrzalki-i-kamienie-wodne'),
(11, 2, 'Talerze porcelanowe i ceramiczne', 'talerze-porcelanowe-i-ceramiczne'),
(12, 2, 'Sztućce stołowe', 'sztucce-stolowe'),
(13, 2, 'Szklanki, karafki i kieliszki', 'szklanki-karafki-i-kieliszki'),
(14, 3, 'Patelnie żeliwne, stalowe i węglowe', 'patelnie-zeliwne-stalowe-i-weglowe'),
(15, 3, 'Garnki i rondle', 'garnki-i-rondle'),
(16, 3, 'Brytfanny i naczynia żeliwne', 'brytfanny-i-naczynia-zeliwne');

-- ============================================================================
-- 5. PRODUKTY KUCHENNE - products (20 rekordów)
-- ============================================================================
INSERT INTO `products` (`product_id`, `sku`, `name`, `brand`, `material`, `description`, `base_price`, `is_active`) VALUES
(1, 'KNIFE-ZW-200', 'Nóż szefa kuchni Pro 20 cm', 'Zwilling', 'Stal nierdzewna wysokowęglowa', 'Profesjonalny kuty nóż szefa kuchni o ostrzu 20 cm, hartowany lodem FRIODUR.', 350.00, 1),
(2, 'KNIFE-SHUN-180', 'Nóż Santoku Damast 18 cm', 'Kai Shun', 'Stal damasceńska VG-MAX', 'Japoński nóż Santoku z 32-warstwowej stali damasceńskiej z rękojeścią z drewna Pakka.', 800.00, 1),
(3, 'BOARD-OAK-XL', 'Deska do krojenia dębowa sztorcowa 45x30 cm', 'DąbPol', 'Drewno dębowe', 'Gruba deska sztorcowa (end-grain) z rowkiem na soki, impregnowana olejem lnianym.', 230.00, 1),
(4, 'PLATE-BOL-SET6', 'Zestaw 6 talerzy obiadowych ręcznie malowanych 26 cm', 'Ceramika Bolesławiec', 'Ceramika kamionkowa', 'Tradycyjne talerze obiadowe dekorowane metodą stempelkową, odporne na piekarnik.', 420.00, 1),
(5, 'PLATE-LUB-DEEP6', 'Komplet 6 talerzy głębokich do makaronu i zup', 'Lubiana', 'Porcelana biała', 'Nowoczesna zastawa gastronomiczna o wzmocnionych brzegach odpornych na obtłuczenia.', 190.00, 1),
(6, 'PAN-LODGE-26', 'Patelnia żeliwna klasyczna 26 cm', 'Lodge', 'Żeliwo sezonowane', 'Niezawodna patelnia żeliwna do smażenia steków i zapiekania w piekarniku do 300°C.', 220.00, 1),
(7, 'POT-GER-SET5', 'Zestaw garnków ze stali nierdzewnej 10 el.', 'Gerlach', 'Stal nierdzewna 18/10', 'Komplet 5 garnków z pokrywkami, wewnętrzną miarką i trójwarstwowym dnem indukcyjnym.', 650.00, 1),
(8, 'CUTLERY-GER-24', 'Komplet sztućców w walizce 24 el. (6 osób)', 'Gerlach', 'Stal nierdzewna 18/10', 'Elegancki zestaw łyżek, widelców, noży stołowych i łyżeczek o wysokim połysku.', 390.00, 1),
(9, 'BLOCK-MAG-BAM', 'Magnetyczny stojak na noże kuchenne', 'Fiskars', 'Bambus / Magnes neodymowy', 'Bezpieczny blok magnetyczny mieszczący do 6 dużych noży kuchennych.', 160.00, 1),
(10, 'SHARP-WUST-2ST', 'Ostrzałka dwustopniowa do noży kuchennych', 'Wüsthof', 'Węglik wolframu / Ceramika', 'Ostrzałka do szybkiego przywracania ostrości i codziennego polerowania krawędzi tnącej.', 120.00, 1),
(11, 'DUTCH-LEC-24', 'Garnek żeliwny emaliowany Signature 4.2 l', 'Le Creuset', 'Żeliwo emaliowane', 'Kultowy francuski garnek żeliwny typu Dutch Oven do duszenia, pieczenia chleba i wolnego gotowania.', 1450.00, 1),
(12, 'PAN-DEBUY-28', 'Patelnia ze stali węglowej Mineral B 28 cm', 'De Buyer', 'Stal węglowa', 'Francuska patelnia pokryta woskiem pszczelim, zyskująca naturalną powłokę non-stick.', 260.00, 1),
(13, 'GLASS-KRO-SET6', 'Komplet 6 kieliszków do wina czerwonego 450 ml', 'Krosno', 'Szkło Crystalline', 'Kieliszki o wysokiej przejrzystości i dźwięczności szkła z długą nóżką.', 110.00, 1),
(14, 'COFFEE-BIAL-6TZ', 'Kawiarka ciśnieniowa Moka Express 6 TZ', 'Bialetti', 'Aluminium spożywcze', 'Oryginalna włoska kawiarka ośmiokątna na 6 filiżanek aromatycznego espresso.', 150.00, 1),
(15, 'BAKE-EMIL-TART', 'Forma ceramiczna do tarty 28 cm', 'Emile Henry', 'Ceramika HR', 'Francuska forma z falowanym brzegiem równomiernie rozprowadzająca ciepło podczas pieczenia.', 180.00, 1),
(16, 'STONE-SHAP-1000', 'Kamień wodny do ostrzenia gradacja 1000/6000', 'Shapton', 'Korund syntetyczny', 'Dwustronny japoński kamień ceramiczny typu Splash & Go do ostrzenia noży szefa kuchni.', 290.00, 1),
(17, 'CONT-ZW-VAC5', 'Zestaw próżniowych pojemników szklanych Fresh & Save 5 el.', 'Zwilling', 'Szkło borokrzemowe', 'Zestaw 3 szklanych pojemników z pompką próżniową przedłużający świeżość potraw 5-krotnie.', 320.00, 1),
(18, 'KNIFE-VICT-PAR', 'Zestaw 3 nożyków pikutków do warzyw i pomidorów', 'Victorinox', 'Stal nierdzewna', 'Niezwykle ostre szwajcarskie nożyki z ząbkowanym ostrzem do codziennych prac w kuchni.', 75.00, 1),
(19, 'BOWL-BOL-RAM4', 'Komplet 4 kokilek ceramicznych do zapiekania i crème brûlée', 'Ceramika Bolesławiec', 'Ceramika kamionkowa', 'Naczynia żaroodporne do przystawek, deserów i zapiekanek.', 140.00, 1),
(20, 'POT-COPP-16', 'Rondel miedziany profesjonalny 16 cm', 'Mauviel', 'Miedź cynowana', 'Luksusowy rondel z czystej miedzi dla profesjonalnych szefów kuchni (edycja wycofana).', 980.00, 0);

-- ============================================================================
-- 6. PRZYPISANIE PRODUKTÓW DO KATEGORII - product_categories (32 rekordy)
-- ============================================================================
INSERT INTO `product_categories` (`product_id`, `category_id`) VALUES
(1, 1), (1, 7),
(2, 1), (2, 8),
(3, 1), (3, 9),
(4, 2), (4, 11),
(5, 2), (5, 11),
(6, 3), (6, 14),
(7, 3), (7, 15),
(8, 2), (8, 12),
(9, 1), (9, 9), (9, 6),
(10, 1), (10, 10),
(11, 3), (11, 16),
(12, 3), (12, 14),
(13, 2), (13, 13), (13, 5),
(14, 5),
(15, 4),
(16, 1), (16, 10),
(17, 6),
(18, 1), (18, 7),
(19, 4), (19, 11),
(20, 3), (20, 15);

-- ============================================================================
-- 7. MAGAZYNY - warehouses (15 rekordów)
-- ============================================================================
INSERT INTO `warehouses` (`warehouse_id`, `name`, `street_line1`, `city`, `postal_code`, `country_code`, `is_active`) VALUES
(1, 'Magazyn Centralny Kraków-Rybitwy', 'ul. Logistyczna 10', 'Kraków', '30-798', 'PL', 1),
(2, 'Hub Dystrybucyjny Warszawa-Pruszków', 'ul. Magazynowa 4', 'Pruszków', '05-800', 'PL', 1),
(3, 'Magazyn Północ Gdańsk-Port', 'ul. Portowa 18', 'Gdańsk', '80-542', 'PL', 1),
(4, 'Magazyn Dolny Śląsk Wrocław', 'ul. Przemysłowa 7', 'Wrocław', '54-204', 'PL', 1),
(5, 'Magazyn Centralna Polska Łódź', 'ul. Składowa 2', 'Łódź', '90-127', 'PL', 1),
(6, 'Magazyn Wielkopolska Poznań-Komorniki', 'ul. Transportowa 15', 'Komorniki', '62-052', 'PL', 1),
(7, 'Magazyn Górny Śląsk Katowice', 'ul. Hutnicza 30', 'Katowice', '40-241', 'PL', 1),
(8, 'Magazyn Pomorze Zachodnie Szczecin', 'ul. Portowców 9', 'Szczecin', '70-633', 'PL', 1),
(9, 'Magazyn Wschód Lublin', 'ul. Mełgiewska 44', 'Lublin', '20-234', 'PL', 1),
(10, 'Magazyn Podkarpacie Rzeszów', 'ul. Przemysłowa 12', 'Rzeszów', '35-105', 'PL', 1),
(11, 'Magazyn Kujawy Bydgoszcz', 'ul. Fordońska 110', 'Bydgoszcz', '85-739', 'PL', 1),
(12, 'Magazyn Podlasie Białystok', 'ul. Hurtowa 6', 'Białystok', '15-399', 'PL', 1),
(13, 'Magazyn Warmia Olsztyn', 'ul. Towarowa 21', 'Olsztyn', '10-416', 'PL', 1),
(14, 'Magazyn Archiwalny Kielce (Zamknięty)', 'ul. Zakładowa 3', 'Kielce', '25-672', 'PL', 0),
(15, 'Magazyn Sezonowy Zielona Góra (Nieaktywny)', 'ul. Trasa Północna 19', 'Zielona Góra', '65-119', 'PL', 0);

-- ============================================================================
-- 8. STANY MAGAZYNOWE - inventory (32 rekordy)
-- ============================================================================
INSERT INTO `inventory` (`warehouse_id`, `product_id`, `quantity`) VALUES
(1, 1, 35), (1, 2, 12), (1, 3, 45), (1, 4, 25), (1, 11, 8), (1, 18, 60),
(2, 1, 20), (2, 5, 80), (2, 6, 40), (2, 7, 18), (2, 12, 30), (2, 14, 50),
(3, 8, 25), (3, 9, 40), (3, 13, 65), (3, 17, 15),
(4, 6, 25), (4, 10, 55), (4, 15, 22), (4, 19, 35),
(5, 3, 15), (5, 7, 10), (5, 16, 14),
(6, 1, 10), (6, 4, 12), (6, 8, 18),
(7, 2, 5),  (7, 11, 4), (7, 12, 20),
(8, 13, 30), (9, 14, 25), (10, 18, 40);

-- ============================================================================
-- 9. ZAMÓWIENIA - orders (18 rekordów)
-- ============================================================================
INSERT INTO `orders` (`order_id`, `user_id`, `shipping_address_id`, `billing_address_id`, `order_status`, `total_amount`, `created_at`) VALUES
(1, 1, 1, 1, 'delivered', 580.00, '2026-05-12 14:20:00'),
(2, 2, 2, 2, 'delivered', 1080.00, '2026-05-25 10:05:00'),
(3, 3, 3, 3, 'delivered', 1060.00, '2026-06-08 18:45:00'),
(4, 8, 8, 20, 'delivered', 2550.00, '2026-06-20 09:15:00'),
(5, 5, 5, 5, 'cancelled', 380.00, '2026-07-03 16:30:00'),
(6, 1, 1, 19, 'delivered', 800.00, '2026-07-15 11:00:00'),
(7, 4, 4, 4, 'delivered', 1630.00, '2026-07-28 19:10:00'),
(8, 6, 6, 6, 'shipped', 890.00, '2026-08-05 12:40:00'),
(9, 7, 7, 7, 'delivered', 430.00, '2026-08-19 15:20:00'),
(10, 9, 9, 9, 'delivered', 740.00, '2026-09-01 08:50:00'),
(11, 10, 10, 10, 'processing', 640.00, '2026-09-12 17:05:00'),
(12, 11, 11, 11, 'paid', 640.00, '2026-09-22 13:30:00'),
(13, 12, 12, 12, 'delivered', 810.00, '2026-09-29 10:15:00'),
(14, 8, 8, 20, 'shipped', 3680.00, '2026-10-03 09:00:00'),
(15, 13, 13, 13, 'pending', 300.00, '2026-10-08 20:45:00'),
(16, 14, 14, 14, 'delivered', 305.00, '2026-10-10 11:25:00'),
(17, 15, 15, 15, 'cancelled', 650.00, '2026-10-11 14:10:00'),
(18, 2, 2, 2, 'paid', 500.00, '2026-10-13 16:00:00');

-- ============================================================================
-- 10. POZYCJE ZAMÓWIEŃ - order_items (34 rekordy)
-- ============================================================================
INSERT INTO `order_items` (`order_item_id`, `order_id`, `product_id`, `warehouse_id`, `quantity`, `unit_price`) VALUES
-- Zamówienie 1 (Suma: 580.00)
(1, 1, 1, 1, 1, 350.00),
(2, 1, 3, 1, 1, 230.00),
-- Zamówienie 2 (Suma: 1080.00 - realizowane z 3 magazynów)
(3, 2, 2, 1, 1, 800.00),
(4, 2, 9, 3, 1, 160.00),
(5, 2, 10, 4, 1, 120.00),
-- Zamówienie 3 (Suma: 1060.00)
(6, 3, 4, 1, 2, 420.00),
(7, 3, 13, 3, 2, 110.00),
-- Zamówienie 4 - Restauracja (Suma: 2550.00)
(8, 4, 5, 2, 5, 190.00),
(9, 4, 2, 1, 2, 800.00),
-- Zamówienie 5 - Anulowane (Suma: 380.00)
(10, 5, 6, 2, 1, 220.00),
(11, 5, 9, 3, 1, 160.00),
-- Zamówienie 6 (Suma: 800.00)
(12, 6, 7, 2, 1, 650.00),
(13, 6, 18, 1, 2, 75.00),
-- Zamówienie 7 (Suma: 1630.00)
(14, 7, 11, 1, 1, 1450.00),
(15, 7, 15, 4, 1, 180.00),
-- Zamówienie 8 (Suma: 890.00)
(16, 8, 8, 6, 2, 390.00),
(17, 8, 13, 3, 1, 110.00),
-- Zamówienie 9 (Suma: 430.00)
(18, 9, 14, 2, 1, 150.00),
(19, 9, 19, 4, 2, 140.00),
-- Zamówienie 10 (Suma: 740.00)
(20, 10, 12, 2, 2, 260.00),
(21, 10, 6, 4, 1, 220.00),
-- Zamówienie 11 (Suma: 640.00)
(22, 11, 1, 2, 1, 350.00),
(23, 11, 16, 5, 1, 290.00),
-- Zamówienie 12 (Suma: 640.00)
(24, 12, 17, 3, 2, 320.00),
-- Zamówienie 13 (Suma: 810.00)
(25, 13, 4, 6, 1, 420.00),
(26, 13, 8, 3, 1, 390.00),
-- Zamówienie 14 - Restauracja (Suma: 3680.00)
(27, 14, 11, 1, 2, 1450.00),
(28, 14, 12, 7, 3, 260.00),
-- Zamówienie 15 (Suma: 300.00)
(29, 15, 14, 9, 2, 150.00),
-- Zamówienie 16 (Suma: 305.00)
(30, 16, 3, 5, 1, 230.00),
(31, 16, 18, 10, 1, 75.00),
-- Zamówienie 17 - Anulowane (Suma: 650.00)
(32, 17, 7, 5, 1, 650.00),
-- Zamówienie 18 (Suma: 500.00)
(33, 18, 15, 4, 2, 180.00),
(34, 18, 19, 4, 1, 140.00);

-- ============================================================================
-- 11. PŁATNOŚCI - payments (20 rekordów - w tym próby nieudane i zwroty)
-- ============================================================================
INSERT INTO `payments` (`payment_id`, `order_id`, `payment_method`, `transaction_reference`, `amount`, `payment_status`, `paid_at`) VALUES
(1, 1, 'blik', 'TXN-BLIK-20260512-001', 580.00, 'completed', '2026-05-12 14:21:10'),
(2, 2, 'credit_card', 'TXN-CARD-20260525-002A', 1080.00, 'failed', NULL),
(3, 2, 'credit_card', 'TXN-CARD-20260525-002B', 1080.00, 'completed', '2026-05-25 10:08:00'),
(4, 3, 'stripe', 'TXN-STRP-20260608-003', 1060.00, 'completed', '2026-06-08 18:46:22'),
(5, 4, 'bank_transfer', 'TXN-BANK-20260620-004', 2550.00, 'completed', '2026-06-20 12:00:00'),
(6, 5, 'paypal', 'TXN-PAYP-20260703-005', 380.00, 'failed', NULL),
(7, 6, 'blik', 'TXN-BLIK-20260715-006', 800.00, 'completed', '2026-07-15 11:01:05'),
(8, 7, 'stripe', 'TXN-STRP-20260728-007A', 1630.00, 'failed', NULL),
(9, 7, 'blik', 'TXN-BLIK-20260728-007B', 1630.00, 'completed', '2026-07-28 19:14:00'),
(10, 8, 'credit_card', 'TXN-CARD-20260805-008', 890.00, 'completed', '2026-08-05 12:42:00'),
(11, 9, 'blik', 'TXN-BLIK-20260819-009', 430.00, 'completed', '2026-08-19 15:21:30'),
(12, 10, 'paypal', 'TXN-PAYP-20260901-010', 740.00, 'completed', '2026-09-01 08:52:10'),
(13, 11, 'stripe', 'TXN-STRP-20260912-011', 640.00, 'completed', '2026-09-12 17:06:45'),
(14, 12, 'blik', 'TXN-BLIK-20260922-012', 640.00, 'completed', '2026-09-22 13:31:00'),
(15, 13, 'bank_transfer', 'TXN-BANK-20260929-013', 810.00, 'completed', '2026-09-29 14:10:00'),
(16, 14, 'bank_transfer', 'TXN-BANK-20261003-014', 3680.00, 'completed', '2026-10-03 11:30:00'),
(17, 15, 'paypal', 'TXN-PAYP-20261008-015', 300.00, 'initiated', NULL),
(18, 16, 'blik', 'TXN-BLIK-20261010-016', 305.00, 'completed', '2026-10-10 11:26:00'),
(19, 17, 'credit_card', 'TXN-CARD-20261011-017', 650.00, 'refunded', '2026-10-11 14:12:00'),
(20, 18, 'stripe', 'TXN-STRP-20261013-018', 500.00, 'completed', '2026-10-13 16:01:20');

-- ============================================================================
-- 12. PRZESYŁKI - shipments (16 rekordów - w tym zamówienia wielopaczkowe)
-- ============================================================================
INSERT INTO `shipments` (`shipment_id`, `order_id`, `carrier`, `tracking_number`, `shipment_status`, `shipped_at`, `delivered_at`) VALUES
(1, 1, 'InPost Kurier', 'INP-2026-000101', 'delivered', '2026-05-13 08:30:00', '2026-05-14 13:15:00'),
(2, 2, 'DPD Polska', 'DPD-2026-000201', 'delivered', '2026-05-26 09:00:00', '2026-05-27 15:40:00'),
(3, 2, 'InPost Paczkomaty', 'INP-2026-000202', 'delivered', '2026-05-26 10:15:00', '2026-05-27 11:20:00'),
(4, 3, 'DHL Parcel', 'DHL-2026-000301', 'delivered', '2026-06-09 11:20:00', '2026-06-10 14:00:00'),
(5, 4, 'DPD Polska', 'DPD-2026-000401', 'delivered', '2026-06-21 08:00:00', '2026-06-22 10:30:00'),
(6, 4, 'DPD Polska', 'DPD-2026-000402', 'delivered', '2026-06-21 08:05:00', '2026-06-22 10:30:00'),
(7, 6, 'InPost Paczkomaty', 'INP-2026-000601', 'delivered', '2026-07-16 15:00:00', '2026-07-17 09:45:00'),
(8, 7, 'DHL Parcel', 'DHL-2026-000701', 'delivered', '2026-07-29 10:00:00', '2026-07-30 16:10:00'),
(9, 8, 'InPost Kurier', 'INP-2026-000801', 'out_for_delivery', '2026-08-06 09:30:00', NULL),
(10, 9, 'InPost Paczkomaty', 'INP-2026-000901', 'delivered', '2026-08-20 12:00:00', '2026-08-21 10:00:00'),
(11, 10, 'DPD Polska', 'DPD-2026-001001', 'delivered', '2026-09-02 08:45:00', '2026-09-03 13:50:00'),
(12, 11, 'DHL Parcel', 'DHL-2026-001101', 'label_created', NULL, NULL),
(13, 13, 'InPost Kurier', 'INP-2026-001301', 'delivered', '2026-09-30 09:15:00', '2026-10-01 14:20:00'),
(14, 14, 'DHL Parcel', 'DHL-2026-001401', 'in_transit', '2026-10-04 07:30:00', NULL),
(15, 14, 'DHL Parcel', 'DHL-2026-001402', 'in_transit', '2026-10-04 08:10:00', NULL),
(16, 16, 'InPost Paczkomaty', 'INP-2026-001601', 'delivered', '2026-10-11 10:00:00', '2026-10-12 11:30:00');
