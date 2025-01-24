CREATE DATABASE tokopedia_notification;

USE tokopedia_notification;

SHOW TABLES;

# User

CREATE TABLE user
(
id VARCHAR(100) NOT NULL,
name VARCHAR(100) NOT NULL,
PRIMARY KEY (id)
)Engine = InnoDB;

INSERT INTO user(id, name)
VALUES ('zul', 'Zulvika Kusumadevi');
INSERT INTO user(id, name)
VALUES ('ich', 'Ichvanur Solichin');

SELECT *
FROM user;

# Notification

CREATE TABLE notification
(
id INT NOT NULL AUTO_INCREMENT,
title VARCHAR(255) NOT NULL,
detail TEXT NOT NULL,
create_at TIMESTAMP NOT NULL,
user_id VARCHAR(100),
PRIMARY KEY (id)
) Engine = InnoDB;

SHOW TABLES;

# Relasi antara User dan Notification
ALTER TABLE notification
ADD CONSTRAINT fk_notification_user
FOREIGN KEY (user_id) REFERENCES user (id);

DESC notification;

# Contoh Dummy
INSERT INTO notification(title, detail, create_at, user_id)
VALUES ('Contoh Pesanan', 'Detail Pesanan', CURRENT_TIMESTAMP(), 'zul');
INSERT INTO notification(title, detail, create_at, user_id)
VALUES ('Contoh Promo', 'Detail Promo', CURRENT_TIMESTAMP(), null);
INSERT INTO notification(title, detail, create_at, user_id)
VALUES ('Contoh Pembayaran', 'Detail Pembayaran', CURRENT_TIMESTAMP(), 'ich');
INSERT INTO notification(title, detail, create_at, user_id)
VALUES ('Contoh Informasi', 'Detail Informasi', CURRENT_TIMESTAMP(), 'zul');

SELECT * FROM notification;

# Query ini akan menampilkan daftar notifikasi untuk pengguna "zul" dan notifikasi umum, diurutkan dari yang paling baru.
SELECT *
FROM notification
WHERE (user_id = 'zul' OR user_id IS NULL)
ORDER BY create_at DESC;

SELECT *
FROM notification
WHERE (user_id = 'ich' OR user_id IS NULL)
ORDER BY create_at DESC;

# Category

CREATE TABLE category
(
id VARCHAR(100) NOT NULL,
name VARCHAR(100) NOT NULL,
PRIMARY KEY (id)
) ENGINE = InnoDB;

SHOW TABLES;

# Query ini melakukan perubahan pada struktur tabel notification
ALTER TABLE notification
ADD COLUMN category_id VARCHAR(100);

DESCRIBE notification;

# Query ini menambahkan sebuah foreign key constraint ke tabel notification
ALTER TABLE notification
ADD CONSTRAINT fk_notification_category
FOREIGN KEY (category_id) REFERENCES category (id);

DESCRIBE notification;

SELECT *
FROM notification;

# Query ini menambahkan data baru ke dalam tabel category
INSERT INTO category(id, name)
VALUES ('TRANSAKSI', 'Transaksi');
INSERT INTO category(id, name)
VALUES ('INFO', 'Info');
INSERT INTO category(id, name)
VALUES ('PROMO', 'Promo');
INSERT INTO category(id, name)
VALUES ('FEED', 'Feed');

SELECT *
FROM category;

UPDATE notification
SET category_id = 'TRANSAKSI'
WHERE id = 1;

UPDATE notification
SET category_id = 'PROMO'
WHERE id = 2;

UPDATE notification
SET category_id = 'TRANSAKSI'
WHERE id = 3;

UPDATE notification
SET category_id = 'INFO'
WHERE id = 4;

SELECT *
FROM notification;

# Query ini akan menampilkan daftar notifikasi untuk pengguna "zul" dan notifikasi umum, diurutkan dari yang paling baru
SELECT *
FROM notification
WHERE (user_id = 'zul' OR user_id IS NULL)
ORDER BY create_at DESC;

# Query ini digunakan untuk mengambil data dari tabel notification dengan menggabungkan data dari tabel category
SELECT *
FROM notification n
JOIN category c ON (n.category_id = c.id)
WHERE (n.user_id = 'zul' OR n.user_id IS NULL)
ORDER BY n.create_at DESC;

# Query ini digunakan untuk mengambil data dari tabel notification dengan menggabungkan data dari tabel category
SELECT *
FROM notification n
JOIN category c ON (n.category_id = c.id)
WHERE (n.user_id = 'ich' OR n.user_id IS NULL)
ORDER BY n.create_at DESC;

SELECT *
FROM notification n
JOIN category c ON (n.category_id = c.id)
WHERE (n.user_id = 'ich' OR n.user_id IS NULL)
AND c.id = 'INFO'
ORDER BY n.create_at DESC;

SELECT *
FROM notification n
JOIN category c ON (n.category_id = c.id)
WHERE (n.user_id = 'zul' OR n.user_id IS NULL)
AND c.id = 'INFO'
ORDER BY n.create_at DESC;

# Notification Read

CREATE TABLE notification_read
(
id INT NOT NULL AUTO_INCREMENT,
is_read BOOLEAN NOT NULL,
notification_id INT NOT NULL,
user_id VARCHAR(100) NOT NULL,
PRIMARY KEY (id)
) ENGINE = InnoDB;

SHOW TABLES;

ALTER TABLE notification_read
ADD CONSTRAINT fk_notification_read_notification
FOREIGN KEY (notification_id) REFERENCES notification (id);

ALTER TABLE notification_read
ADD CONSTRAINT fk_notification_read_user
FOREIGN KEY (user_id) REFERENCES user (id);

DESC notification_read;

SELECT *
FROM notification;

# Menandai notifikasi dengan ID (promo) 2 telah dibaca oleh pengguna dengan ID 'zul'
INSERT INTO notification_read(is_read, notification_id, user_id)
VALUES (true, 2, 'zul');
INSERT INTO notification_read(is_read, notification_id, user_id)
VALUES (true, 2, 'ich');

SELECT *
FROM notification_read;

SELECT *
FROM notification;

SELECT *
FROM notification n
JOIN category c ON (n.category_id = c.id)
LEFT JOIN notification_read nr ON (nr.notification_id = n.id)
WHERE (n.user_id = 'zul' OR n.user_id IS NULL)
AND (nr.user_id = 'zul' OR nr.user_id IS NULL)
ORDER BY n.create_at DESC;

# Insert contoh data baru untuk notifikasi
INSERT INTO notification(title, detail, category_id, user_id, create_at)
VALUES ('Contoh Pesanan Lagi', 'Detail Pesanan lagi', 'TRANSAKSI', 'zul', CURRENT_TIMESTAMP());
INSERT INTO notification(title, detail, category_id, user_id, create_at)
VALUES ('Contoh Promo Lagi', 'Detail Promo lagi', 'PROMO', null, CURRENT_TIMESTAMP());
INSERT INTO notification(title, detail, category_id, user_id, create_at)
VALUES ('Contoh Informasi', 'Detail Informasi', 'INFO', 'ich', CURRENT_TIMESTAMP());

# Apabila menambahkan feature counter di notifikasi
SELECT COUNT(*) 
FROM notification n
JOIN category c ON (n. category_id =  c.id)
LEFT JOIN notification_read nr ON (nr.notification_id = n.id)
WHERE (n.user_id = 'zul' OR n.user_id IS NULL)
AND (nr.user_id = 'zul' OR nr.user_id IS NULL)
ORDER BY n.create_at DESC;

# Count untuk yang belum dibaca, berarti user_id NULL
SELECT COUNT(*) 
FROM notification n
JOIN category c ON (n. category_id =  c.id)
LEFT JOIN notification_read nr ON (nr.notification_id = n.id)
WHERE (n.user_id = 'zul' OR n.user_id IS NULL)
AND (nr.user_id IS NULL)
ORDER BY n.create_at DESC;

# Count untuk yang udah dibaca
SELECT COUNT(*) 
FROM notification n
JOIN category c ON (n. category_id =  c.id)
LEFT JOIN notification_read nr ON (nr.notification_id = n.id)
WHERE (n.user_id = 'zul' OR n.user_id IS NULL)
AND (nr.user_id = 'zul')
ORDER BY n.create_at DESC;


INSERT INTO notification_read(is_read, notification_id, user_id)
VALUES (true, 5, 'zul' );

