-- Analytical Query
-- 1. Ranking popularitas model mobil berdasarkan jumlah bid
SELECT 
    model, 
    COUNT(DISTINCT cars.mobil_id) AS num_products,
    COUNT(bids.bid_id) AS num_bids
FROM cars 
LEFT JOIN ads
ON cars.mobil_id = ads.mobil_id
LEFT JOIN bids
ON ads.iklan_id = bids.iklan_id
GROUP BY model
ORDER BY num_bids DESC;


-- 2. Membandingkan harga mobil berdasarkan harga rata-rata per kota
SELECT 
    nama_kota,
    merk,
    model,
    tahun,
    harga,
    (AVG(harga) OVER (PARTITION BY city.kota_id))::int AS avg_car_city
FROM cars
LEFT JOIN users ON cars.seller_id = users.user_id
LEFT JOIN city ON users.kota_id = city.kota_id;

-- 3. Dari penawaran suatu model mobil,
-- cari perbandingan tanggal user melakukan bid dengan bid selanjutnya beserta harga tawar yang diberikan
WITH car_bids AS (
    SELECT 
        model,
        buyer_id,
        bid_time, 
        bid_price,
        LEAD(bid_price) OVER (PARTITION BY model ORDER BY bid_time) AS next_bid_price,
        LEAD(bid_time) OVER (PARTITION BY model ORDER BY bid_time) AS next_bid_time
    FROM bids
    JOIN ads ON bids.iklan_id = ads.iklan_id
    JOIN cars ON ads.mobil_id = cars.mobil_id
    WHERE cars.model ILIKE '%Toyota Yaris%'
)
SELECT 
    model,
    buyer_id,
    bid_time, 
    bid_price,
    next_bid_time,
    next_bid_price,
    (next_bid_price - bid_price) AS price_difference,
    (next_bid_time - bid_time) AS time_difference
FROM car_bids
WHERE next_bid_price IS NOT NULL
	AND next_bid_time IS NOT NULL
ORDER BY bid_time ASC;


-- 4. Membandingkan persentase perbedaan rata-rata harga mobil berdasarkan modelnya dan rata-rata harga bid yang ditawarkan oleh customer pada 6 bulan terakhir (4% bobot)
-- Difference adalah selisih antara rata-rata harga model mobil(avg_price) dengan rata-rata harga bid yang ditawarkan terhadap model tersebut(avg_bid_6month)
-- Difference dapat bernilai negatif atau positif
-- Difference_percent adalah persentase dari selisih yang telah dihitung, yaitu dengan cara difference dibagi rata-rata harga model mobil(avg_price) dikali 100%
-- Difference_percent dapat bernilai negatif atau positif
SELECT 
    cars.model, 
    AVG(cars.harga) AS avg_price, 
    AVG(CASE WHEN bids.bid_time >= NOW() - INTERVAL '6 months' THEN bids.bid_price END) AS avg_bid_6_months,
    AVG(cars.harga) - AVG(CASE WHEN bids.bid_time >= NOW() - INTERVAL '6 months' THEN bids.bid_price END) AS difference,
    (AVG(cars.harga) - AVG(CASE WHEN bids.bid_time >= NOW() - INTERVAL '6 months' THEN bids.bid_price END)) / AVG(cars.harga) * 100 AS difference_percentage
FROM 
    cars 
    LEFT JOIN ads ON cars.mobil_id = ads.mobil_id 
    LEFT JOIN bids ON ads.iklan_id = bids.iklan_id 
GROUP BY 
    cars.model;


-- 5. Membuat window function
-- rata-rata harga bid sebuah merk dan model mobil selama 6 bulan terakhir
SELECT merk, model,
  AVG(CASE WHEN DATE_TRUNC('month', bid_time) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '6' MONTH) THEN bid_price END) AS month_6,
  AVG(CASE WHEN DATE_TRUNC('month', bid_time) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '5' MONTH) THEN bid_price END) AS month_5,
  AVG(CASE WHEN DATE_TRUNC('month', bid_time) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '4' MONTH) THEN bid_price END) AS month_4,
  AVG(CASE WHEN DATE_TRUNC('month', bid_time) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '3' MONTH) THEN bid_price END) AS month_3,
  AVG(CASE WHEN DATE_TRUNC('month', bid_time) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '2' MONTH) THEN bid_price END) AS month_2,
  AVG(CASE WHEN DATE_TRUNC('month', bid_time) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1' MONTH) THEN bid_price END) AS month_1
FROM bids
JOIN ads
	ON bids.iklan_id = ads.iklan_id
JOIN cars
	ON cars.mobil_id = cars.mobil_id
WHERE 
  merk ILIKE '%Toyota%' 
  AND model ILIKE '%Toyota Yaris%'
  AND DATE_TRUNC('month', bid_time) >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '6' MONTH)
GROUP BY merk, model;