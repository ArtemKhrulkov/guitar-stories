-- Guitar Stock - Seed Guitars Data
-- Migration 003: Insert guitars for all brands
-- Note: Using valid PostgreSQL UUIDs (hexadecimal characters only)

-- Burny Guitars (uuid: f8a94cbe-b62c-4ef0-ac4a-4814c23deece)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('0a111111-1111-1111-1111-111111111111', 'f8a94cbe-b62c-4ef0-ac4a-4814c23deece', 'RLG-85', 'electric', '600 - 1 200 USD / 60 000 - 120 000 RUB', 
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Burny RLG-85 is a premium Japanese Les Paul-style guitar known for its exceptional craftsmanship. Features a mahogany body with a maple top, delivering rich, warm tones perfect for rock and blues.',
'https://via.placeholder.com/400x300?text=Burny+RLG-85'),

('0a222222-2222-2222-2222-222222222222', 'f8a94cbe-b62c-4ef0-ac4a-4814c23deece', 'FLG-85', 'electric', '500 - 1 000 USD / 50 000 - 100 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Mahogany", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Gold", "bridge": "Tune-o-Matic"}',
'Burny FLG-85 is a versatile Les Paul-style guitar with a stunning flamed maple top. Perfect for players seeking professional-grade tone at an accessible price point.',
'https://via.placeholder.com/400x300?text=Burny+FLG-85'),

('0a333333-3333-3333-3333-333333333333', 'f8a94cbe-b62c-4ef0-ac4a-4814c23deece', 'Les Paul Custom', 'electric', '700 - 1 400 USD / 70 000 - 140 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Mahogany", "fretboard": "Ebony", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Gold", "bridge": "Tune-o-Matic"}',
'Burny Les Paul Custom replicates the iconic Gibson Les Paul Custom with meticulous attention to detail. Features multi-ply binding, split diamond inlays, and premium electronics for professional performance.',
'https://via.placeholder.com/400x300?text=Burny+Les+Paul+Custom'),

('0a444444-4444-4444-4444-444444444444', 'f8a94cbe-b62c-4ef0-ac4a-4814c23deece', 'SG Custom', 'electric', '500 - 1 000 USD / 50 000 - 100 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Mahogany", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Burny SG Custom offers the aggressive double-cutaway design of the Gibson SG in a Japanese-made package. Lightweight mahogany construction provides excellent sustain and resonance.',
'https://via.placeholder.com/400x300?text=Burny+SG+Custom');

-- ESP Guitars (uuid: a19b0f09-fd6e-4505-b943-131f76f43afe)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('0b111111-1111-1111-1111-111111111111', 'a19b0f09-fd6e-4505-b943-131f76f43afe', 'Horizon', 'electric', '1 200 - 2 000 USD / 120 000 - 200 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Ebony", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Black", "bridge": "Floyd Rose"}',
'ESP Horizon is a flagship guitar designed for serious metal musicians. Features an aggressive body shape, premium electronics, and a Floyd Rose tremolo system for extreme dive bombs.',
'https://via.placeholder.com/400x300?text=ESP+Horizon'),

('0b222222-2222-2222-2222-222222222222', 'a19b0f09-fd6e-4505-b943-131f76f43afe', 'M-II', 'electric', '1 500 - 2 500 USD / 150 000 - 250 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Ebony", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Black", "bridge": "Floyd Rose"}',
'ESP M-II is a premium shred machine with exceptional playability and tone. The combination of mahogany body and ebony fretboard delivers tight, aggressive sounds perfect for metal.',
'https://via.placeholder.com/400x300?text=ESP+M-II'),

('0b333333-3333-3333-3333-333333333333', 'a19b0f09-fd6e-4505-b943-131f76f43afe', 'EC-256', 'electric', '400 - 700 USD / 40 000 - 70 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Roasted Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'ESP EC-256 offers professional features at an accessible price. The single-cutaway design provides easy access to upper frets while maintaining classic rock aesthetics.',
'https://via.placeholder.com/400x300?text=ESP+EC-256'),

('0b444444-4444-4444-4444-444444444444', 'a19b0f09-fd6e-4505-b943-131f76f43afe', 'LTD EC-256', 'electric', '300 - 600 USD / 30 000 - 60 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'LTD EC-256 is the entry-level version of ESP guitars, offering quality construction and great tone for beginning to intermediate players.',
'https://via.placeholder.com/400x300?text=LTD+EC-256'),

('0b555555-5555-5555-5555-555555555555', 'a19b0f09-fd6e-4505-b943-131f76f43afe', 'SN-200', 'electric', '500 - 900 USD / 50 000 - 90 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Maple", "pickup_config": "SS (Single-Single)", "frets": 22, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Tremolo"}',
'ESP SN-200 is a Stratocaster-style guitar with ESP quality at an affordable price. Perfect for players seeking classic single-coil tones.',
'https://via.placeholder.com/400x300?text=ESP+SN-200');

-- Fender Guitars (uuid: 40294847-34c1-42f0-896b-c729e035a3ad)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('0c111111-1111-1111-1111-111111111111', '40294847-34c1-42f0-896b-c729e035a3ad', 'Stratocaster Standard', 'electric', '800 - 1 500 USD / 80 000 - 150 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Maple", "pickup_config": "SSS (Single-Single-Single)", "frets": 21, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Synchronized Tremolo"}',
'Fender Stratocaster is the most iconic electric guitar in music history. Introduced in 1954, it has been featured on countless recordings across all genres of music.',
'https://via.placeholder.com/400x300?text=Fender+Stratocaster'),

('0c222222-2222-2222-2222-222222222222', '40294847-34c1-42f0-896b-c729e035a3ad', 'Telecaster Standard', 'electric', '800 - 1 500 USD / 80 000 - 150 000 RUB',
'{"body_wood": "Ash", "neck_wood": "Maple", "fretboard": "Maple", "pickup_config": "SS (Single-Single)", "frets": 21, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Fixed Bridge"}',
'Fender Telecaster is the first mass-produced electric guitar, originally released in 1951. Known for its bright, cutting tone perfect for country, rock, and blues.',
'https://via.placeholder.com/400x300?text=Fender+Telecaster'),

('0c333333-3333-3333-3333-333333333333', '40294847-34c1-42f0-896b-c729e035a3ad', 'Jazzmaster', 'electric', '900 - 1 600 USD / 90 000 - 160 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "SS (Single-Single)", "frets": 21, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Floating Tremolo"}',
'Fender Jazzmaster features offset waist body shape and unique offset vibrato system. Originally designed for jazz musicians, it became popular in alternative rock and shoegaze.',
'https://via.placeholder.com/400x300?text=Fender+Jazzmaster'),

('0c444444-4444-4444-4444-444444444444', '40294847-34c1-42f0-896b-c729e035a3ad', 'Jaguar', 'electric', '900 - 1 600 USD / 90 000 - 160 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "SS (Single-Single)", "frets": 22, "scale_length": "24\"", "hardware": "Chrome", "bridge": "Jaguar Bridge"}',
'Fender Jaguar is a shorter-scale guitar with distinctive tone circuits. Popular among surf rock, alternative, and indie musicians for its unique sound and aesthetics.',
'https://via.placeholder.com/400x300?text=Fender+Jaguar'),

('0c555555-5555-5555-5555-555555555555', '40294847-34c1-42f0-896b-c729e035a3ad', 'Mustang', 'electric', '500 - 900 USD / 50 000 - 90 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "SS (Single-Single)", "frets": 22, "scale_length": "24\"", "hardware": "Chrome", "bridge": "Mustang Bridge"}',
'Fender Mustang features a shorter 24-inch scale length, making it comfortable for younger players. Originally a student model, it gained cult status in alternative music.',
'https://via.placeholder.com/400x300?text=Fender+Mustang'),

('0c666666-6666-6666-6666-666666666666', '40294847-34c1-42f0-896b-c729e035a3ad', 'Jag-Stang', 'electric', '700 - 1 200 USD / 70 000 - 120 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HS (Humbucker-Single)", "frets": 22, "scale_length": "24\"", "hardware": "Chrome", "bridge": "Jag-Stang Bridge"}',
'Fender Jag-Stang is a signature model designed by Kurt Cobain. Combining features of the Jaguar and Mustang, it became iconic after Nirvana used it extensively.',
'https://via.placeholder.com/400x300?text=Fender+Jag-Stang');

-- Gibson Guitars (uuid: 0e4d24d6-21d4-4dc7-b642-0d9c000a7f7d)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('0d111111-1111-1111-1111-111111111111', '0e4d24d6-21d4-4dc7-b642-0d9c000a7f7d', 'Les Paul Standard', 'electric', '1 000 - 2 500 USD / 100 000 - 250 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Mahogany", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Gibson Les Paul Standard is one of the most legendary electric guitars. Introduced in 1952, it revolutionized rock music with its warm, thick tone and sustain.',
'https://via.placeholder.com/400x300?text=Gibson+Les+Paul+Standard'),

('0d222222-2222-2222-2222-222222222222', '0e4d24d6-21d4-4dc7-b642-0d9c000a7f7d', 'Les Paul Custom', 'electric', '1 500 - 3 500 USD / 150 000 - 350 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Mahogany", "fretboard": "Ebony", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Gold", "bridge": "Tune-o-Matic"}',
'Gibson Les Paul Custom is the premium version featuring multi-ply binding, split diamond inlays, and ebony fretboard. Often called the "Black Beauty" for its stunning appearance.',
'https://via.placeholder.com/400x300?text=Gibson+Les+Paul+Custom'),

('0d333333-3333-3333-3333-333333333333', '0e4d24d6-21d4-4dc7-b642-0d9c000a7f7d', 'SG Standard', 'electric', '800 - 1 500 USD / 80 000 - 150 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Mahogany", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Gibson SG features a distinctive double-cutaway design allowing easy access to upper frets. Lightweight and agile, it became the weapon of choice for heavy rock and metal.',
'https://via.placeholder.com/400x300?text=Gibson+SG'),

('0d444444-4444-4444-4444-444444444444', '0e4d24d6-21d4-4dc7-b642-0d9c000a7f7d', 'Explorer', 'electric', '1 200 - 2 000 USD / 120 000 - 200 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Mahogany", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Gibson Explorer features an angular, futuristic body shape that stands out visually. Despite its unconventional appearance, it offers excellent playability and powerful tone.',
'https://via.placeholder.com/400x300?text=Gibson+Explorer'),

('0d555555-5555-5555-5555-555555555555', '0e4d24d6-21d4-4dc7-b642-0d9c000a7f7d', 'ES-335', 'electric', '1 800 - 3 000 USD / 180 000 - 300 000 RUB',
'{"body_wood": "Maple", "neck_wood": "Mahogany", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "ABR-1 Bridge"}',
'Gibson ES-335 is a groundbreaking semi-hollow body guitar that pioneered the archtop electric design. Perfect blend of acoustic warmth and electric power.',
'https://via.placeholder.com/400x300?text=Gibson+ES-335'),

('0d666666-6666-6666-6666-666666666666', '0e4d24d6-21d4-4dc7-b642-0d9c000a7f7d', 'Flying V', 'electric', '1 200 - 2 000 USD / 120 000 - 200 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Mahogany", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Gibson Flying V features an aggressive V-shaped body design that was ahead of its time. Favored by blues and rock guitarists for its unique ergonomics and tone.',
'https://via.placeholder.com/400x300?text=Gibson+Flying+V'),

('0d777777-7777-7777-7777-777777777777', '0e4d24d6-21d4-4dc7-b642-0d9c000a7f7d', 'Les Paul Studio', 'electric', '700 - 1 200 USD / 70 000 - 120 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Gibson Les Paul Studio offers the essential Les Paul features at a more accessible price point. Perfect for players seeking professional tone without the premium cosmetics.',
'https://via.placeholder.com/400x300?text=Gibson+Les+Paul+Studio'),

('0d888888-8888-8888-8888-888888888888', '0e4d24d6-21d4-4dc7-b642-0d9c000a7f7d', 'Firebird', 'electric', '1 500 - 2 500 USD / 150 000 - 250 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Gibson Firebird features a unique "reverse" body shape with offset waist and through-neck construction. Known for its bright, cutting tone and distinctive appearance.',
'https://via.placeholder.com/400x300?text=Gibson+Firebird');

-- Greco Guitars (uuid: 7681f153-c51c-4b09-acfe-037dd270ee4c)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('0e111111-1111-1111-1111-111111111111', '7681f153-c51c-4b09-acfe-037dd270ee4c', 'EG-800', 'electric', '500 - 1 000 USD / 50 000 - 100 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Greco EG-800 is a premium Japanese Les Paul-style guitar known for exceptional craftsmanship. Often compared favorably to American originals in quality and tone.',
'https://via.placeholder.com/400x300?text=Greco+EG-800'),

('0e222222-2222-2222-2222-222222222222', '7681f153-c51c-4b09-acfe-037dd270ee4c', 'Genesis Series', 'electric', '400 - 800 USD / 40 000 - 80 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Greco Genesis Series recreates classic vintage designs with modern reliability. Excellent choice for players seeking vintage tones without vintage prices.',
'https://via.placeholder.com/400x300?text=Greco+Genesis'),

('0e333333-3333-3333-3333-333333333333', '7681f153-c51c-4b09-acfe-037dd270ee4c', 'J-GR', 'electric', '600 - 1 200 USD / 60 000 - 120 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Maple", "pickup_config": "SS (Single-Single)", "frets": 21, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Synchronized Tremolo"}',
'Greco J-GR is a Stratocaster-style guitar offering excellent value and quality. Features proper vintage-style tremolo and authentic single-coil tones.',
'https://via.placeholder.com/400x300?text=Greco+J-GR'),

('0e444444-4444-4444-4444-444444444444', '7681f153-c51c-4b09-acfe-037dd270ee4c', 'Les Paul Custom', 'electric', '700 - 1 400 USD / 70 000 - 140 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Mahogany", "fretboard": "Ebony", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Gold", "bridge": "Tune-o-Matic"}',
'Greco Les Paul Custom features premium appointments including ebony fretboard and gold hardware. One of the finest Japanese Les Paul replicas available.',
'https://via.placeholder.com/400x300?text=Greco+Les+Paul+Custom'),

('0e555555-5555-5555-5555-555555555555', '7681f153-c51c-4b09-acfe-037dd270ee4c', 'Explorer', 'electric', '500 - 900 USD / 50 000 - 90 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Greco Explorer recreates the iconic angular Gibson design with Japanese precision. Rare to find in vintage reissues, making this a special addition to any collection.',
'https://via.placeholder.com/400x300?text=Greco+Explorer');

-- Gretsch Guitars (uuid: 66eb300e-bbf6-4fc2-96af-00f6a510eecc)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('0f111111-1111-1111-1111-111111111111', '66eb300e-bbf6-4fc2-96af-00f6a510eecc', 'G5420', 'electric', '600 - 1 200 USD / 60 000 - 120 000 RUB',
'{"body_wood": "Maple", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.6\"", "hardware": "Chrome", "bridge": "Adjustable Bridge"}',
'Gretsch G5420 is a classic hollow-body electric guitar with big, resonant tone. Features FilterTron pickups for that signature Gretsch "country twang."',
'https://via.placeholder.com/400x300?text=Gretsch+G5420'),

('0f222222-2222-2222-2222-222222222222', '66eb300e-bbf6-4fc2-96af-00f6a510eecc', 'White Falcon', 'electric', '1 500 - 3 000 USD / 150 000 - 300 000 RUB',
'{"body_wood": "Maple", "neck_wood": "Maple", "fretboard": "Ebony", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "25.5\"", "hardware": "Gold", "bridge": "Adjustable Bridge"}',
'Gretsch White Falcon is the flagship hollow-body guitar with stunning appointments including gold hardware, aged-white finish, and massive tone.',
'https://via.placeholder.com/400x300?text=Gretsch+White+Falcon'),

('0f333333-3333-3333-3333-333333333333', '66eb300e-bbf6-4fc2-96af-00f6a510eecc', 'Penguin', 'electric', '800 - 1 500 USD / 80 000 - 150 000 RUB',
'{"body_wood": "Maple", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.6\"", "hardware": "Chrome", "bridge": "Adjustable Bridge"}',
'Gretsch Penguin features a distinctive small body shape with upright bass and treble horns. Unique visual design with exceptional hollow-body tone.',
'https://via.placeholder.com/400x300?text=Gretsch+Penguin'),

('0f444444-4444-4444-4444-444444444444', '66eb300e-bbf6-4fc2-96af-00f6a510eecc', 'Electromatic', 'electric', '400 - 800 USD / 40 000 - 80 000 RUB',
'{"body_wood": "Maple", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.6\"", "hardware": "Chrome", "bridge": "Adjustable Bridge"}',
'Gretsch Electromatic offers professional features at an accessible price. Perfect entry point to the Gretsch sound and aesthetic.',
'https://via.placeholder.com/400x300?text=Gretsch+Electromatic'),

('0f555555-5555-5555-5555-555555555555', '66eb300e-bbf6-4fc2-96af-00f6a510eecc', 'Synchromatic', 'electric', '500 - 1 000 USD / 50 000 - 100 000 RUB',
'{"body_wood": "Laminated Maple", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.6\"", "hardware": "Chrome", "bridge": "Adjustable Bridge"}',
'Gretsch Synchromatic is an archtop guitar inspired by classic Gretsch designs from the 1940s. Features laminated body construction for reduced feedback.',
'https://via.placeholder.com/400x300?text=Gretsch+Synchromatic');

-- Ibanez Guitars (uuid: fd9f9ce8-52e4-4f3a-9bbe-d89f47c6ed24)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('1a111111-1111-1111-1111-111111111111', 'fd9f9ce8-52e4-4f3a-9bbe-d89f47c6ed24', 'JEM777', 'electric', '800 - 1 500 USD / 80 000 - 150 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Gold", "bridge": "Edge Tremolo"}',
'Ibanez JEM777 is the legendary Steve Vai signature model featuring the distinctive "Monkey Grip" handle cutout. Revolutionary design that changed guitar aesthetics forever.',
'https://via.placeholder.com/400x300?text=Ibanez+JEM777'),

('1a222222-2222-2222-2222-222222222222', 'fd9f9ce8-52e4-4f3a-9bbe-d89f47c6ed24', 'RG550', 'electric', '600 - 1 200 USD / 60 000 - 120 000 RUB',
'{"body_wood": "Basswood", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Cosmo Black", "bridge": "Edge Tremolo"}',
'Ibanez RG550 is the quintessential superstrat guitar. Thin neck profile, flat fretboard radius, and high-output pickups make it ideal for shredding.',
'https://via.placeholder.com/400x300?text=Ibanez+RG550'),

('1a333333-3333-3333-3333-333333333333', 'fd9f9ce8-52e4-4f3a-9bbe-d89f47c6ed24', 'Artcore', 'electric', '400 - 800 USD / 40 000 - 80 000 RUB',
'{"body_wood": "Maple", "neck_wood": "Mahogany", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Adjustable Bridge"}',
'Ibanez Artcore is a popular series of semi-hollow and hollow-body guitars. Excellent value for players seeking jazz and blues tones.',
'https://via.placeholder.com/400x300?text=Ibanez+Artcore'),

('1a444444-4444-4444-4444-444444444444', 'fd9f9ce8-52e4-4f3a-9bbe-d89f47c6ed24', 'AZ2204', 'electric', '1 000 - 1 800 USD / 100 000 - 180 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Roasted Maple", "fretboard": "Rosewood", "pickup_config": "HSH (Humbucker-Single-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Tremolo"}',
'Ibanez AZ2204 is a modern guitar designed for versatility. Features dynaverse-style single coil and modern ergonomics for contemporary players.',
'https://via.placeholder.com/400x300?text=Ibanez+AZ2204'),

('1a555555-5555-5555-5555-555555555555', 'fd9f9ce8-52e4-4f3a-9bbe-d89f47c6ed24', 'Steve Vai Signature', 'electric', '1 200 - 2 000 USD / 120 000 - 200 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Gold", "bridge": "Edge Tremolo"}',
'Ibanez Steve Vai Signature models represent the pinnacle of Ibanez craftsmanship. Used by Vai on countless albums and tours worldwide.',
'https://via.placeholder.com/400x300?text=Ibanez+Steve+Vai+Signature'),

('1a666666-6666-6666-6666-666666666666', 'fd9f9ce8-52e4-4f3a-9bbe-d89f47c6ed24', 'Prestige Series', 'electric', '800 - 1 500 USD / 80 000 - 150 000 RUB',
'{"body_wood": "Basswood", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Cosmo Black", "bridge": "Edge Tremolo"}',
'Ibanez Prestige Series represents the highest quality Japanese manufacturing. Features premium hardware, woods, and exceptional fit and finish.',
'https://via.placeholder.com/400x300?text=Ibanez+Prestige');

-- Music Man Guitars (uuid: 4f3d343c-63a9-408b-9882-493184eb442a)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('1b111111-1111-1111-1111-111111111111', '4f3d343c-63a9-408b-9882-493184eb442a', 'StingRay', 'electric', '1 500 - 2 500 USD / 150 000 - 250 000 RUB',
'{"body_wood": "Ash", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Music Man Bridge"}',
'Music Man StingRay features the iconic 5-bolt neck construction and distinctive humbucker design. Known for powerful, punchy tones with excellent clarity.',
'https://via.placeholder.com/400x300?text=Music+Man+StingRay'),

('1b222222-2222-2222-2222-222222222222', '4f3d343c-63a9-408b-9882-493184eb442a', 'Axis', 'electric', '1 200 - 2 000 USD / 120 000 - 200 000 RUB',
'{"body_wood": "Basswood", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Music Man Bridge"}',
'Music Man Axis is the signature model of Eddie Van Halen. Features a unique sustain block and high-performance design.',
'https://via.placeholder.com/400x300?text=Music+Man+Axis'),

('1b333333-3333-3333-3333-333333333333', '4f3d343c-63a9-408b-9882-493184eb442a', 'Silhouette', 'electric', '1 800 - 3 000 USD / 180 000 - 300 000 RUB',
'{"body_wood": "Basswood", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HSH (Humbucker-Single-Humbucker)", "frets": 22, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Music Man Tremolo"}',
'Music Man Silhouette offers versatile tones with its HSH pickup configuration. Premium construction and exceptional playability.',
'https://via.placeholder.com/400x300?text=Music+Man+Silhouette'),

('1b444444-4444-4444-4444-444444444444', '4f3d343c-63a9-408b-9882-493184eb442a', 'Bongo', 'electric', '1 400 - 2 400 USD / 140 000 - 240 000 RUB',
'{"body_wood": "Basswood", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Music Man Bridge"}',
'Music Man Bongo features an ergonomic body shape and powerful electronics. Known for its bold, aggressive tone and comfortable playing experience.',
'https://via.placeholder.com/400x300?text=Music+Man+Bongo');

-- Schecter Guitars (uuid: 9b3a7bf7-2990-45f9-97c5-52441ef83c68)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('1c111111-1111-1111-1111-111111111111', '9b3a7bf7-2990-45f9-97c5-52441ef83c68', 'Solo-II', 'electric', '1 200 - 2 000 USD / 120 000 - 200 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Schecter Solo-II is a premium Les Paul-style guitar with modern enhancements. Features premium woods and Seymour Duncan pickups for exceptional tone.',
'https://via.placeholder.com/400x300?text=Schecter+Solo-II'),

('1c222222-2222-2222-2222-222222222222', '9b3a7bf7-2990-45f9-97c5-52441ef83c68', 'C-1', 'electric', '600 - 1 200 USD / 60 000 - 120 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Tremolo"}',
'Schecter C-1 is a versatile guitar available with various pickup configurations. Comfortable contoured body and fast neck for modern playing styles.',
'https://via.placeholder.com/400x300?text=Schecter+C-1'),

('1c333333-3333-3333-3333-333333333333', '9b3a7bf7-2990-45f9-97c5-52441ef83c68', 'Damien', 'electric', '500 - 900 USD / 50 000 - 90 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Black", "bridge": "Tremolo"}',
'Schecter Damien is an affordable guitar designed for metal players. Aggressive styling and high-output pickups deliver crushing tone.',
'https://via.placeholder.com/400x300?text=Schecter+Damien'),

('1c444444-4444-4444-4444-444444444444', '9b3a7bf7-2990-45f9-97c5-52441ef83c68', 'Omen', 'electric', '300 - 600 USD / 30 000 - 60 000 RUB',
'{"body_wood": "Basswood", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Tremolo"}',
'Schecter Omen is the entry-level model offering impressive features at an affordable price. Perfect for beginning metal guitarists.',
'https://via.placeholder.com/400x300?text=Schecter+Omen'),

('1c555555-5555-5555-5555-555555555555', '9b3a7bf7-2990-45f9-97c5-52441ef83c68', 'Reaper', 'electric', '400 - 800 USD / 40 000 - 80 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Black", "bridge": "Tremolo"}',
'Schecter Reaper features an angular, aggressive design with premium features. Excellent choice for modern metal and rock players.',
'https://via.placeholder.com/400x300?text=Schecter+Reaper');

-- Squier Guitars (uuid: 2df8bf10-842d-41ea-8851-bcbfe0d598fa)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('1d111111-1111-1111-1111-111111111111', '2df8bf10-842d-41ea-8851-bcbfe0d598fa', 'Stratocaster', 'electric', '150 - 300 USD / 15 000 - 30 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Maple", "pickup_config": "SSS (Single-Single-Single)", "frets": 21, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Synchronized Tremolo"}',
'Squier Stratocaster is the affordable entry point to the Fender family. Classic Strat design with authentic tones at a budget-friendly price.',
'https://via.placeholder.com/400x300?text=Squier+Stratocaster'),

('1d222222-2222-2222-2222-222222222222', '2df8bf10-842d-41ea-8851-bcbfe0d598fa', 'Telecaster', 'electric', '150 - 300 USD / 15 000 - 30 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Maple", "pickup_config": "SS (Single-Single)", "frets": 21, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Fixed Bridge"}',
'Squier Telecaster offers the classic two-pickup design at an affordable price. Perfect for beginners seeking authentic Fender tone.',
'https://via.placeholder.com/400x300?text=Squier+Telecaster'),

('1d333333-3333-3333-3333-333333333333', '2df8bf10-842d-41ea-8851-bcbfe0d598fa', 'Bass', 'electric', '200 - 400 USD / 20 000 - 40 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Maple", "pickup_config": "SS (Single-Single)", "frets": 20, "scale_length": "34\"", "hardware": "Chrome", "bridge": "Standard Bridge"}',
'Squier Bass offers quality construction and classic Precision Bass styling. Great starting point for aspiring bass players.',
'https://via.placeholder.com/400x300?text=Squier+Bass'),

('1d444444-4444-4444-4444-444444444444', '2df8bf10-842d-41ea-8851-bcbfe0d598fa', 'Jagmaster', 'electric', '150 - 300 USD / 15 000 - 30 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "SS (Single-Single)", "frets": 22, "scale_length": "24\"", "hardware": "Chrome", "bridge": "Jaguar Bridge"}',
'Squier Jagmaster combines Jaguar and Mustang features with humbucking pickups. Offers unique tones perfect for alternative and indie music.',
'https://via.placeholder.com/400x300?text=Squier+Jagmaster'),

('1d555555-5555-5555-5555-555555555555', '2df8bf10-842d-41ea-8851-bcbfe0d598fa', 'Classic Vibe', 'electric', '200 - 400 USD / 20 000 - 40 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Maple", "pickup_config": "SSS (Single-Single-Single)", "frets": 21, "scale_length": "25.5\"", "hardware": "Nickel", "bridge": "Synchronized Tremolo"}',
'Squier Classic Vibe series offers vintage-inspired designs with modern playability. Excellent quality-to-price ratio.',
'https://via.placeholder.com/400x300?text=Squier+Classic+Vibe');

-- Sterling Guitars (uuid: b3feebf4-aab2-4015-8f53-6d59404fe13a)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('1e111111-1111-1111-1111-111111111111', 'b3feebf4-aab2-4015-8f53-6d59404fe13a', 'Silhouette', 'electric', '400 - 700 USD / 40 000 - 70 000 RUB',
'{"body_wood": "Basswood", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Sterling Bridge"}',
'Sterling by Music Man Silhouette delivers Music Man quality at an accessible price. Features the iconic body shape with budget-friendly components.',
'https://via.placeholder.com/400x300?text=Sterling+Silhouette'),

('1e222222-2222-2222-2222-222222222222', 'b3feebf4-aab2-4015-8f53-6d59404fe13a', 'Axis', 'electric', '400 - 700 USD / 40 000 - 70 000 RUB',
'{"body_wood": "Basswood", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Sterling Bridge"}',
'Sterling by Music Man Axis offers the popular Eddie Van Halen-inspired design at a lower price point. Great gateway to Music Man quality.',
'https://via.placeholder.com/400x300?text=Sterling+Axis'),

('1e333333-3333-3333-3333-333333333333', 'b3feebf4-aab2-4015-8f53-6d59404fe13a', 'Cutlass', 'electric', '350 - 600 USD / 35 000 - 60 000 RUB',
'{"body_wood": "Basswood", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "SSS (Single-Single-Single)", "frets": 22, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Tremolo"}',
'Sterling by Music Man Cutlass features a traditional single-coil design with modern refinements. Comfortable and versatile for various styles.',
'https://via.placeholder.com/400x300?text=Sterling+Cutlass'),

('1e444444-4444-4444-4444-444444444444', 'b3feebf4-aab2-4015-8f53-6d59404fe13a', 'StingRay Bass', 'electric', '450 - 800 USD / 45 000 - 80 000 RUB',
'{"body_wood": "Ash", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "H (Humbucker)", "frets": 21, "scale_length": "34\"", "hardware": "Chrome", "bridge": "Sterling Bridge"}',
'Sterling StingRay Bass offers the iconic Music Man bass tone at an affordable price. Famous for its powerful, punchy sound.',
'https://via.placeholder.com/400x300?text=Sterling+StingRay+Bass'),

('1e555555-5555-5555-5555-555555555555', 'b3feebf4-aab2-4015-8f53-6d59404fe13a', 'JP150', 'electric', '400 - 700 USD / 40 000 - 70 000 RUB',
'{"body_wood": "Basswood", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 24, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Tremolo"}',
'Sterling JP150 is the affordable version of John Petrucci signature models. Features premium specs for serious musicians on a budget.',
'https://via.placeholder.com/400x300?text=Sterling+JP150');

-- Yamaha Guitars (uuid: 6b7d1a5c-a8c4-4d9d-a95b-739a15b65748)
INSERT INTO guitars (id, brand_id, model, guitar_type, price_range, specifications, history, image_url) VALUES
('1f111111-1111-1111-1111-111111111111', '6b7d1a5c-a8c4-4d9d-a95b-739a15b65748', 'Pacifica 112', 'electric', '200 - 400 USD / 20 000 - 40 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HSS (Humbucker-Single-Single)", "frets": 22, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Tremolo"}',
'Yamaha Pacifica 112 is legendary among beginner guitars. Inspired by Fender designs with Yamaha quality construction and versatile tones.',
'https://via.placeholder.com/400x300?text=Yamaha+Pacifica+112'),

('1f222222-2222-2222-2222-222222222222', '6b7d1a5c-a8c4-4d9d-a95b-739a15b65748', 'Pacifica 512', 'electric', '300 - 600 USD / 30 000 - 60 000 RUB',
'{"body_wood": "Alder", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HSS (Humbucker-Single-Single)", "frets": 22, "scale_length": "25.5\"", "hardware": "Chrome", "bridge": "Tremolo"}',
'Yamaha Pacifica 512 offers upgraded features including coil splitting for the humbucker. Excellent step up from the 112 model.',
'https://via.placeholder.com/400x300?text=Yamaha+Pacifica+512'),

('1f333333-3333-3333-3333-333333333333', '6b7d1a5c-a8c4-4d9d-a95b-739a15b65748', 'Revstar', 'electric', '400 - 800 USD / 40 000 - 80 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Maple", "fretboard": "Rosewood", "pickup_config": "HH (Humbucker-Humbucker)", "frets": 22, "scale_length": "24.75\"", "hardware": "Chrome", "bridge": "Tune-o-Matic"}',
'Yamaha Revstar is a modern Japanese guitar inspired by vintage designs. Features unique aesthetic and high-quality construction.',
'https://via.placeholder.com/400x300?text=Yamaha+Revstar'),

('1f444444-4444-4444-4444-444444444444', '6b7d1a5c-a8c4-4d9d-a95b-739a15b65748', 'FG800', 'acoustic', '200 - 400 USD / 20 000 - 40 000 RUB',
'{"body_wood": "Spruce", "neck_wood": "Nato", "fretboard": "Walnut", "pickup_config": "None", "frets": 20, "scale_length": "25.6\"", "hardware": "Chrome", "bridge": "Walnut Bridge"}',
'Yamaha FG800 is the entry-level acoustic in the legendary FG series. Solid spruce top delivers impressive projection and tone.',
'https://via.placeholder.com/400x300?text=Yamaha+FG800'),

('1f555555-5555-5555-5555-555555555555', '6b7d1a5c-a8c4-4d9d-a95b-739a15b65748', 'SLG200', 'acoustic', '300 - 600 USD / 30 000 - 60 000 RUB',
'{"body_wood": "Mahogany", "neck_wood": "Mahogany", "fretboard": "Rosewood", "pickup_config": "Piezo", "frets": 22, "scale_length": "25\"", "hardware": "Gold", "bridge": "Rosewood Bridge"}',
'Yamaha SLG200 is a silent guitar with headphone output, perfect for practice without disturbing others. Compact and portable design.',
'https://via.placeholder.com/400x300?text=Yamaha+SLG200');
