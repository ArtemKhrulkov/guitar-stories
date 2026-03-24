-- Seed data for guitar stock application

-- Insert Brands (UUIDs must match those in 003_seed_guitars.sql)
INSERT INTO brands (id, name, country, founded_year, description) VALUES
('0e4d24d6-21d4-4dc7-b642-0d9c000a7f7d', 'Gibson', 'USA', 1902, 'Gibson Brands Inc. is an American manufacturer of guitars, other musical instruments, and consumer and professional electronics, founded in 1902 by Orville Gibson in Kalamazoo, Michigan.'),
('40294847-34c1-42f0-896b-c729e035a3ad', 'Fender', 'USA', 1946, 'Fender Musical Instruments Corporation, commonly known as Fender, is an American manufacturer of stringed instruments and amplifiers. It is known for its solid-body electric guitars and bass guitars.'),
('fd9f9ce8-52e4-4f3a-9bbe-d89f47c6ed24', 'Ibanez', 'Japan', 1927, 'Ibanez is a Japanese guitar brand owned by Hoshino Gakki. Ibanez produces effects, accessories, builds and imports guitars, and synthesizers.'),
('a19b0f09-fd6e-4505-b943-131f76f43afe', 'ESP', 'Japan', 1975, 'ESP Guitar Company is a Japanese manufacturer of electric guitars and bass guitars. It is best known for producing signature models for famous metal guitarists.'),
('9b3a7bf7-2990-45f9-97c5-52441ef83c68', 'Schecter', 'USA', 1979, 'Schecter Guitar Research is an American guitar manufacturer. The company produces a range of electric guitars, acoustic guitars, and bass guitars.'),
('6b7d1a5c-a8c4-4d9d-a95b-739a15b65748', 'Yamaha', 'Japan', 1887, 'Yamaha Corporation is a Japanese multinational corporation and conglomerate that produces motorcycles, musical instruments, and audio equipment.'),
('4f3d343c-63a9-408b-9882-493184eb442a', 'Music Man', 'USA', 1984, 'Music Man is an American guitar manufacturing company based in San Luis Obispo, California. Known for their high-quality electric guitars and basses.'),
('7681f153-c51c-4b09-acfe-037dd270ee4c', 'Greco', 'Japan', 1960, 'Greco is a Japanese guitar manufacturer founded in 1960. Known for producing high-quality instruments, many as reproductions of classic American designs.'),
('f8a94cbe-b62c-4ef0-ac4a-4814c23deece', 'Burny', 'Japan', 1965, 'Burny is a Japanese guitar brand specializing in Les Paul style guitars. The brand is known for their high-quality craftsmanship and attention to detail.'),
('2df8bf10-842d-41ea-8851-bcbfe0d598fa', 'Squier', 'Japan', 1982, 'Squier is a brand of electric guitars, electric bass guitars, and acoustic guitars manufactured in Japan and later Indonesia under the Fender Musical Instruments Corporation umbrella.'),
('66eb300e-bbf6-4fc2-96af-00f6a510eecc', 'Gretsch', 'USA', 1883, 'Gretsch is an American company that manufactures guitars and drums. Founded in 1883, it is known for its distinctive hollow-body electric guitars and country music heritage.'),
('b3feebf4-aab2-4015-8f53-6d59404fe13a', 'Sterling', 'Japan', 1982, 'Sterling by Music Man is a sub-brand of Music Man, offering more affordable versions of their iconic guitar designs while maintaining quality construction and tone.')
ON CONFLICT (name) DO NOTHING;

-- Insert sample Players
INSERT INTO players (id, name, genre, bio) VALUES
(uuid_generate_v4(), 'Jimmy Page', 'Rock', 'English rock guitarist who formed Led Zeppelin. Known for his Gibson Les Paul and Gibson SG.'),
(uuid_generate_v4(), 'Slash', 'Rock', 'Saul Hudson, known professionally as Slash, is a British-American musician. Best known as the lead guitarist of Guns N'' Roses.'),
(uuid_generate_v4(), 'Eddie Van Halen', 'Rock', 'Dutch-American musician who was the lead guitarist of the band Van Halen. Revolutionized guitar playing with tapping technique.'),
(uuid_generate_v4(), 'Steve Vai', 'Rock', 'American guitarist, multi-instrumentalist, and composer. Known for his technical proficiency and work with Frank Zappa and solo career.'),
(uuid_generate_v4(), 'Jimi Hendrix', 'Rock', 'American guitarist, singer, and songwriter. Widely considered the greatest electric guitarist in history.'),
(uuid_generate_v4(), 'Kurt Cobain', 'Rock', 'American musician, best known as the lead vocalist and guitarist of Nirvana. Iconic user of Fender guitars.'),
(uuid_generate_v4(), 'Brian Setzer', 'Rock', 'American musician, best known as the lead guitarist for The Stray Cats. Famous for his Gretsch guitars.'),
(uuid_generate_v4(), 'Tony Iommi', 'Rock', 'English musician, best known as the guitarist for Black Sabbath. Known for his Gibson SG sound.'),
(uuid_generate_v4(), 'Joe Perry', 'Rock', 'American musician, best known as the lead guitarist and co-songwriter for Aerosmith.'),
(uuid_generate_v4(), 'John Petrucci', 'Metal', 'American musician, best known as the guitarist for Dream Theater. Known for his Music Man signature models.')
ON CONFLICT DO NOTHING;

-- Note: In production, you would reference actual brand IDs
-- This is a template - actual guitar data should be inserted with proper foreign key references
