-- Create database
CREATE DATABASE IF NOT EXISTS analytics 
ENGINE = Atomic 
COMMENT 'Analytics Database';

-- Create tables
CREATE TABLE analytics.aggregation_year_diseases
(
	year VARCHAR(4),
	quantity UInt32
) ENGINE = SummingMergeTree()
ORDER BY year;

CREATE TABLE analytics.aggregation_age
(
	age VARCHAR(10),
	quantity UInt32
) ENGINE = SummingMergeTree()
ORDER BY age;

CREATE TABLE analytics.aggregation_gender
(
	gender VARCHAR(10),
	quantity UInt32,
	CONSTRAINT gender_check CHECK (gender IN ('Женщины', 'Мужчины')),
) ENGINE = SummingMergeTree()
ORDER BY gender;

CREATE TABLE analytics.aggregation_covid_variant
(
	variant VARCHAR(10),
	quantity UInt32
) ENGINE = SummingMergeTree()
ORDER BY variant;

CREATE TABLE analytics.aggregation_sign_symptom
(

)
;

CREATE TABLE analytics.aggregation_city
(

)
;

-- Drop all tables and database
DROP TABLE IF EXISTS analytics.aggregation_age;
DROP TABLE IF EXISTS analytics.aggregation_gender;
DROP TABLE IF EXISTS analytics.aggregation_year_diseases;
DROP TABLE IF EXISTS analytics.aggregation_covid_variant;
DROP TABLE IF EXISTS analytics.aggregation_sign_symptom;
DROP TABLE IF EXISTS analytics.aggregation_city;
DROP DATABASE analytics;