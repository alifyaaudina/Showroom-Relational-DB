# Online Showroom Relational Database
(Images will be added later)

## Background Problems
The task at hand is to build a relational database for a website that offers the sale of used cars. The website allows anyone to advertise their used cars, while potential buyers can search for cars based on several categories.

## Feature Requirements
* Every user will be able to offer more than one of their used cars.
* Before selling cars, every user must complete their personal data, such as name, contact information, and location.
* Users offer their cars through ads that will be displayed on the website.
* These ads contain a title, detailed information about the product being offered, and the seller's contact information.
    * Some infomation that must be written in the ad includes the car brand, the car model, the body type, and year of manufacture.
* Each user can search for the cars offered based on the seller's location, car brand, and car body type.
* If a potential buyer is interested in the car, they can bid on the product price if the seller allows the bidding feature.
* The purchase transaction is conducted outside the application, so it is not within the project's scope.

## Designing the Database

### Mission Statement
Our mission is to design and build a relational database for our used car selling website that can efficiently store and retrieve data about users, cars, ads, bids, and cities. We aim to create a database that is easy to use and maintain, scalable, and secure. Our goal is to ensure that the data in the database is accurate, consistent, and up-to-date, and that it can support the website's core features, including user registration, ad posting, car search and filtering, and bid management. We will follow best practices in database design and management, and ensure that the database meets the requirements of the website's stakeholders and end-users.

### Creating Table Structure
Creating tables, its necessary fields, keys, and functions of every tables

|        Users        |               Cars               |        Ads        |        Bids        |           City          |
|:-------------------:|:--------------------------------:|:-----------------:|:------------------:|:-----------------------:|
| To store users data | To store the products, used cars | To store ads data | To store bids data | To store locations data |
| -user_id,           | -mobil_id,                       | -iklan_id,        | -bid_id,           | -kota_id,               |
| -nama,              | -merk,                           | -judul,           | -iklan_id,         | -nama_kota,             |
| -kontak,            | -model,                          | -deskripsi,       | -bid_price,        | -latitude,              |
| -kota_id            | -tipe_mobil,                     | -mobil_id,        | -buyer_id,         | -longitude              |
|                     | -tahun,                          | -iklan_time       | -bid_time          |                         |
|                     | -harga,                          |                   |                    |                         |
|                     | -seller_id                       |                   |                    |                         |

### Determine Table Relationship
(In progress, will revise later)

### Determine Business Rules
|              Users             |               Cars               |                        Ads                        |        Bids        |              City              |
|:------------------------------:|:--------------------------------:|:-------------------------------------------------:|:------------------:|:------------------------------:|
| To store users data            | To store the products, used cars | To store ads data                                 | To store bids data | To store locations data        |
| -user_id,                      | -mobil_id,                       | -iklan_id,                                        | -bid_id,           | -kota_id,                      |
| -nama,                         | -merk,                           | -judul,                                           | -iklan_id,         | -nama_kota,                    |
| -kontak,                       | -model,                          | -deskripsi,                                       | -bid_price,        | -latitude,                     |
| -kota_id                       | -tipe_mobil,                     | -mobil_id,                                        | -buyer_id,         | -longitude                     |
|                                | -tahun,                          | -iklan_time                                       | -bid_time          |                                |
|                                | -harga,                          |                                                   |                    |                                |
|                                | -seller_id                       |                                                   |                    |                                |
| There must be no empty columns | There must be no empty columns   | Every columns except for deskripsi must be filled | Optionals          | There must be no empty columns |
|                                |                                  |                                                   |                    |                                |

### Determine Views
(In progress, will revise later)

### Creating Data Definition Language
```
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
```
### Entity Relationship Diagram
ERD:
![image.png](attachment:image.png)


## Populating the Database
### Inserting data provided by Pacmann
```
import pandas as pd

city_dt = pd.read_csv(r'C:\path\to\data.csv', sep = ";")   
car_product_dt = pd.read_csv(r'C:\path\to\data.csv', sep = ";")


city_df = pd.DataFrame(city_dt, columns=['kota_id', 'nama_kota','latitude','longitude'])
car_product_df = pd.DataFrame(car_product_dt, columns=['product_id', 'brand','model','body_type','year','price'])
car_product_df.columns = ['mobil_id', 'merk','model','tipe_mobil','tahun','harga']


city_df['nama_kota'] = pd.Series(city_df['nama_kota'], dtype="string")
city_df['latitude'] = pd.Series(city_df['latitude'], dtype="string")
city_df['longitude'] = pd.Series(city_df['longitude'], dtype="string")

car_product_df['merk'] = pd.Series(car_product_df['merk'], dtype="string")
car_product_df['model'] = pd.Series(car_product_df['model'], dtype="string")
car_product_df['tipe_mobil'] = pd.Series(car_product_df['tipe_mobil'], dtype="string")


city_table = city_df.to_dict()
n_city = city_df.shape[0]
cars_table = car_product_df.to_dict()
n_cars = car_product_df.shape[0]
```

### Creating Dummy Data on Python Using Faker
```
from faker import Faker
from tabulate import tabulate
import random


fake_id = Faker('id_ID')

users_table = {}
n_users = 30
users_table['user_id'] = [i+1 for i in range(n_users)]
users_table['nama'] = [fake_id.name() for i in range(n_users)]
users_table['kontak'] = [fake_id.phone_number() for i in range(n_users)]
users_table['kota_id'] = [random.choice(city_table['kota_id']) \
                             for i in range(n_users)]



seller_id = [random.choice(users_table['user_id'])
            for i in range (n_cars)]
cars_table['seller_id'] = {}
for i, value in enumerate(seller_id):
    cars_table['seller_id'][i] = value
    


ads_table = {}
n_ads = n_cars
iklan_id = [i+1 for i in range(n_ads)]
ads_table['iklan_id'] = {}
for i, value in enumerate(iklan_id):
    ads_table['iklan_id'][i] = value
    
judul = [fake_id.catch_phrase() for i in range(n_ads)]
ads_table['judul'] = {}
for i, value in enumerate(judul):
    ads_table['judul'][i] = value

deskripsi = [fake_id.paragraph(nb_sentences=3, variable_nb_sentences=True, ext_word_list=None)
            for i in range(n_ads)]
ads_table['deskripsi'] = {}
for i, value in enumerate(deskripsi):
    ads_table['deskripsi'][i] = value

ads_table['mobil_id'] = cars_table['mobil_id']

iklan_time = [fake_id.date_time_between(start_date='-1y', end_date='now', tzinfo=None)
                            for i in range(n_ads)]
ads_table['iklan_time'] = {}
for i, value in enumerate(iklan_time):
    ads_table['iklan_time'][i] = value


bids_table = {}
n_bids = 200

bid_id = [i+1 for i in range(n_bids)]
bids_table['bid_id'] = {}
for i, value in enumerate(bid_id):
    bids_table['bid_id'][i] = value
    
iklan_id = [random.choice(ads_table['iklan_id'])
            for i in range (n_bids)]
bids_table['iklan_id'] = {}
for i, value in enumerate(iklan_id):
    bids_table['iklan_id'][i] = value
    
bid_price = [int(fake_id.pydecimal(left_digits=8, right_digits=0, positive=True, min_value = 40000000))
            for i in range(n_bids)]
bids_table['bid_price'] = {}
for i, value in enumerate(bid_price):
    bids_table['bid_price'][i] = value

buyer_id = [random.choice(users_table['user_id'])
            for i in range(n_bids)]
bids_table['buyer_id'] = {}
for i, value in enumerate(buyer_id):
    bids_table['buyer_id'][i] = value
    
bid_time = [fake_id.date_time_between(start_date='-1y', end_date='now', tzinfo=None)
                            for i in range(n_ads)]
bids_table['bid_time'] = {}
for i, value in enumerate(bid_time):
    bids_table['bid_time'][i] = value
    

#CONVERTING TO DF
city_df = pd.DataFrame(city_table)
city_df = city_df.set_index('kota_id')

cars_df = pd.DataFrame(cars_table)
cars_df = cars_df.set_index('mobil_id')

users_df = pd.DataFrame(users_table)
users_df = users_df.set_index('user_id')

ads_df = pd.DataFrame(ads_table)
ads_df = ads_df.set_index('iklan_id')

bids_df = pd.DataFrame(bids_table)
bids_df = bids_df.set_index('bid_id')


#EXPORTING TO CSV
city_df.to_csv('C:\\Path\\To\\Data.csv') 
    
cars_df.to_csv('C:\\Path\\To\\Data.csv')

users_df.to_csv('C:\\Path\\To\\Data.csv')

ads_df.to_csv('C:\\Path\\To\\Data.csv')
    
bids_df.to_csv('C:\\Path\\To\\Data.csv')
```

### Inserting data to database
```
COPY city(
    kota_id,
    nama_kota,
    latitude,
    longitude)
FROM 'C:\\Path\\To\\Data.csv'
DELIMITER ','
CSV
HEADER;

COPY users(
    user_id,
    nama,
    kontak,
	kota_id)
FROM 'C:\\Path\\To\\Data.csv'
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
FROM 'C:\\Path\\To\\Data.csv'
DELIMITER ','
CSV
HEADER;

COPY ads(
	iklan_id,
	judul,
	deskripsi,
	mobil_id,
	iklan_time)
FROM 'C:\\Path\\To\\Data.csv'
DELIMITER ','
CSV
HEADER;

COPY bids(
	bid_id,
	iklan_id,
	bid_price,
	buyer_id,
	bid_time)
FROM 'C:\\Path\\To\\Data.csv'
DELIMITER ','
CSV
HEADER;	  
```

## Database Backup
### Backup
![image.png](attachment:image.png)
Choose backup option
![image-2.png](attachment:image-2.png)
Create backup

### Restore
![image-3.png](attachment:image-3.png)
Choose restore option
![image-4.png](attachment:image-4.png)
Restore

## Creating Transactional Query
```
-- Transactional Query
-- 1. Mencari mobil keluaran 2015 ke atas
SELECT *
FROM cars
WHERE tahun >= 2015;
```
![image.png](attachment:image.png)

```
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
```

## Creating Analytical Query
```
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
```
