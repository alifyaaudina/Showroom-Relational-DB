-- Transactional Query
-- 1. Mencari mobil keluaran 2015 ke atas
SELECT *
FROM cars
WHERE tahun >= 2015;

--2. Menambahkan satu data bid produk baru
INSERT INTO bids (iklan_id,
				  bid_price,
				  buyer_id)
VALUES (
    (SELECT iklan_id 
	 FROM ads 
	 WHERE mobil_id = 12345),
	50000000,
    1
);

-- 3. Melihat semua mobil yg dijual 1 akun dari yg paling baru
SELECT seller_id, ads.mobil_id, merk, model, tipe_mobil, tahun, harga, iklan_time
FROM ads
LEFT JOIN cars as c
ON ads.mobil_id = c.mobil_id
WHERE seller_id = 2
ORDER BY iklan_time desc;

-- 4. Mencari mobil bekas yang termurah berdasarkan keyword
SELECT mobil_id, seller_id, merk, model, tipe_mobil, tahun, harga
FROM cars
LEFT JOIN users
ON cars.seller_id = users.user_id
LEFT JOIN city
ON users.kota_id = city.kota_id
WHERE merk ILIKE '%Yaris%'
	OR model ILIKE '%Yaris%'
	OR tipe_mobil ILIKE '%Yaris%'
	OR nama_kota ILIKE '%Yaris%'
ORDER BY harga asc;

-- 5. Mencari mobil bekas yang terdekat berdasarkan sebuah id kota, 
-- jarak terdekat dihitung berdasarkan latitude longitude.
-- Perhitungan jarak dapat dihitung menggunakan rumus jarak euclidean berdasarkan latitude dan longitude
WITH origin_city AS(
	SELECT replace(city.latitude, ',', '.')::float as lat1,
	replace(city.longitude, ',', '.')::float as long1,
	'aa' as dummy_col
	FROM city
	WHERE kota_id = 3173
),
cars2 AS (
	SELECT *, 'aa' as dummy_col
	FROM cars)
	
SELECT cars2.mobil_id, merk, model, tipe_mobil, tahun, harga,
	sqrt(power((origin_city.lat1 - replace(city.latitude, ',', '.')::float), 2) + 
     power((origin_city.long1 - replace(city.longitude, ',', '.')::float), 2)) AS distance
FROM cars2
LEFT JOIN users ON cars2.seller_id = users.user_id
LEFT JOIN city ON users.kota_id = city.kota_id
LEFT JOIN origin_city ON cars2.dummy_col = origin_city.dummy_col
ORDER BY distance asc;