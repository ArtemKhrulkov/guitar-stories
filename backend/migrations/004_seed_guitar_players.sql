-- Guitar Stock - Seed Players and Guitar-Player Associations
-- Migration 004: Insert players and their guitar associations

-- Insert Players
INSERT INTO players (id, name, genre, bio, image_url) VALUES
('11111111-1111-1111-1111-111111111111', 'Jimmy Page', 'Rock', 
'Jimmy Page is an English rock guitarist who formed Led Zeppelin. Known for his Gibson Les Paul and Gibson SG, he created some of the most iconic rock recordings in history including "Stairway to Heaven" and "Whole Lotta Love."',
'https://via.placeholder.com/100x100?text=Jimmy+Page'),

('22222222-2222-2222-2222-222222222222', 'Slash', 'Rock', 
'Slash is a British-American musician best known as the lead guitarist of Guns N'' Roses. Famous for his work with Gibson Les Paul Standard, he created legendary riffs on albums like "Appetite for Destruction."',
'https://via.placeholder.com/100x100?text=Slash'),

('33333333-3333-3333-3333-333333333333', 'Eddie Van Halen', 'Rock', 
'Eddie Van Halen was a Dutch-American musician and founding member of Van Halen. He revolutionized guitar playing with his two-handed tapping technique and used various signature guitars throughout his career.',
'https://via.placeholder.com/100x100?text=Eddie+Van+Halen'),

('44444444-4444-4444-4444-444444444444', 'Steve Vai', 'Rock', 
'Steve Vai is an American guitarist known for his technical proficiency and work with Frank Zappa and his solo career. Famous for his signature Ibanez JEM777 with the distinctive "Monkey Grip" handle.',
'https://via.placeholder.com/100x100?text=Steve+Vai'),

('55555555-5555-5555-5555-555555555555', 'Jimi Hendrix', 'Rock', 
'Jimi Hendrix was an American guitarist widely considered the greatest electric guitarist in history. His innovative use of feedback, distortion, and wah-wah effects revolutionized rock music.',
'https://via.placeholder.com/100x100?text=Jimi+Hendrix'),

('66666666-6666-6666-6666-666666666666', 'Kurt Cobain', 'Rock', 
'Kurt Cobain was the lead vocalist and guitarist of Nirvana. Known for his grunge sound and emotionally powerful songwriting, he used various Fender guitars including the Jag-Stang.',
'https://via.placeholder.com/100x100?text=Kurt+Cobain'),

('77777777-7777-7777-7777-777777777777', 'Brian Setzer', 'Rock', 
'Brian Setzer is best known as the lead guitarist for The Stray Cats. Famous for his Gretsch White Falcon, he revitalized rockabilly music with his incredible tone and technique.',
'https://via.placeholder.com/100x100?text=Brian+Setzer'),

('88888888-8888-8888-8888-888888888888', 'Tony Iommi', 'Rock', 
'Tony Iommi is an English musician best known as the guitarist for Black Sabbath. His heavy riffing and distinctive tone with Gibson SG guitars defined heavy metal music.',
'https://via.placeholder.com/100x100?text=Tony+Iommi'),

('99999999-9999-9999-9999-999999999999', 'Joe Perry', 'Rock', 
'Joe Perry is an American musician best known as the lead guitarist and co-songwriter for Aerosmith. Famous for his Gibson Les Paul and rock ''n'' roll lifestyle.',
'https://via.placeholder.com/100x100?text=Joe+Perry'),

('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'John Petrucci', 'Metal', 
'John Petrucci is an American musician and the guitarist for Dream Theater. Known for his progressive metal virtuosity and signature Music Man guitars.',
'https://via.placeholder.com/100x100?text=John+Petrucci');

-- Insert Guitar-Player Associations
-- Gibson Associations
INSERT INTO guitar_players (guitar_id, player_id, note) VALUES
('0d111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', 'Jimmy Page used the Les Paul Standard on all Led Zeppelin albums, creating some of rocks most recognizable riffs.'),
('0d111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'Slash used the Les Paul Standard on Appetite for Destruction, defining 80s rock guitar tone.'),
('0d111111-1111-1111-1111-111111111111', '99999999-9999-9999-9999-999999999999', 'Joe Perry has used Les Paul Standards throughout his career with Aerosmith.'),
('0d333333-3333-3333-3333-333333333333', '88888888-8888-8888-8888-888888888888', 'Tony Iommi used the SG as his main guitar with Black Sabbath, pioneering heavy metal guitar sound.'),
('0d333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'Jimmy Page also famously used an SG during early Led Zeppelin tours.');

-- Fender Associations
INSERT INTO guitar_players (guitar_id, player_id, note) VALUES
('0c111111-1111-1111-1111-111111111111', '55555555-5555-5555-5555-555555555555', 'Jimi Hendrix famously played a Stratocaster at Woodstock 1969, inspiring generations of guitarists.'),
('0c666666-6666-6666-6666-666666666666', '66666666-6666-6666-6666-666666666666', 'Kurt Cobain designed the Jag-Stang, combining features of his Jaguar and Mustang guitars.');

-- Ibanez Associations
INSERT INTO guitar_players (guitar_id, player_id, note) VALUES
('1a111111-1111-1111-1111-111111111111', '44444444-4444-4444-4444-444444444444', 'Steve Vai''s signature JEM777 featuring the iconic "Monkey Grip" handle cutout.'),
('1a222222-2222-2222-2222-222222222222', '44444444-4444-4444-4444-444444444444', 'RG550 was one of Vai''s early favorite guitars before the JEM signature.'),
('1a555555-5555-5555-5555-555555555555', '44444444-4444-4444-4444-444444444444', 'Steve Vai has multiple signature models, all featuring his distinctive playing style.');

-- Music Man Associations
INSERT INTO guitar_players (guitar_id, player_id, note) VALUES
('1b222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333', 'Eddie Van Halen collaborated with Music Man to create his signature Axis guitar.'),
('1b111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333', 'Music Man StingRay was one of the first high-quality alternatives to vintage guitars.'),
('1e555555-5555-5555-5555-555555555555', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'John Petrucci''s signature model features his progressive metal playing style.'),
('1b444444-4444-4444-4444-444444444444', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petrucci uses Music Man guitars exclusively with Dream Theater.');

-- Gretsch Associations
INSERT INTO guitar_players (guitar_id, player_id, note) VALUES
('0f222222-2222-2222-2222-222222222222', '77777777-7777-7777-7777-777777777777', 'Brian Setzer''s White Falcon defined the rockabilly renaissance sound of The Stray Cats.'),
('0f111111-1111-1111-1111-111111111111', '77777777-7777-7777-7777-777777777777', 'G5420 is Setzer''s more affordable option for live performance and recording.');
