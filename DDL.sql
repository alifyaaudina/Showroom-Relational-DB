-- Buat tabel-tabel yang dibutuhkan

CREATE TABLE IF NOT EXISTS city(
    kota_id INT PRIMARY KEY,
    nama_kota TEXT,
    latitude TEXT,
    longitude TEXT
);

CREATE TABLE IF NOT EXISTS users(
    user_id SERIAL PRIMARY KEY,
    nama TEXT,
    kontak TEXT,
	kota_id INT,
	CONSTRAINT fk_kota_id
		FOREIGN KEY (kota_id)
		REFERENCES city(kota_id)
);
	
CREATE TABLE IF NOT EXISTS cars(
	mobil_id SERIAL PRIMARY KEY,
	merk TEXT,
	model TEXT,
	tipe_mobil TEXT,
	tahun INT,
	harga INT,
	seller_id INT,
	CONSTRAINT fk_seller_id
		FOREIGN KEY (seller_id)
		REFERENCES users(user_id)
);
	
CREATE TABLE IF NOT EXISTS ads(
	iklan_id SERIAL PRIMARY KEY,
	judul TEXT,
	deskripsi TEXT,
	mobil_id INT,
	iklan_time TIMESTAMP,
	CONSTRAINT fk_mobil_id
		FOREIGN KEY (mobil_id)
		REFERENCES cars(mobil_id)
);

CREATE TABLE IF NOT EXISTS bids(
	bid_id SERIAL PRIMARY KEY,
	iklan_id INT,
	bid_price INT,
	buyer_id INT,
	bid_time TIMESTAMP,
	CONSTRAINT fk_iklan_id
		FOREIGN KEY (iklan_id)
		REFERENCES ads(iklan_id)
);
	
-- Masukkan data dengan COPY
COPY city(
    kota_id,
    nama_kota,
    latitude,
    longitude)
FROM 'C:\\Users\\Public\\Dataset\\city.csv'
DELIMITER ','
CSV
HEADER;

COPY users(
    user_id,
    nama,
    kontak,
	kota_id)
FROM 'C:\\Users\\Public\\Dataset\\users.csv'
DELIMITER ','
CSV
HEADER;

COPY cars(
	mobil_id,
	merk,
	model,
	tipe_mobil,
	tahun,
	harga,
	seller_id)
FROM 'C:\\Users\\Public\\Dataset\\cars.csv'
DELIMITER ','
CSV
HEADER;

COPY ads(
	iklan_id,
	judul,
	deskripsi,
	mobil_id,
	iklan_time)
FROM 'C:\\Users\\Public\\Dataset\\ads.csv'
DELIMITER ','
CSV
HEADER;

COPY bids(
	bid_id,
	iklan_id,
	bid_price,
	buyer_id,
	bid_time)
FROM 'C:\\Users\\Public\\Dataset\\bids.csv'
DELIMITER ','
CSV
HEADER;	  

