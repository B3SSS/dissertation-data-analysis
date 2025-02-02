-- Очистка таблиц (если нужно начать с пустой БД)
TRUNCATE TABLE Fact_CitizenQuarantine RESTART IDENTITY CASCADE;
TRUNCATE TABLE Fact_PatientDrug RESTART IDENTITY CASCADE;
TRUNCATE TABLE Fact_PatientSignSymptom RESTART IDENTITY CASCADE;
TRUNCATE TABLE Fact_Patient RESTART IDENTITY CASCADE;
TRUNCATE TABLE Fact_CitizenVenues RESTART IDENTITY CASCADE;
TRUNCATE TABLE Fact_CitizenDiseaseTests RESTART IDENTITY CASCADE;
TRUNCATE TABLE Fact_CitizenVaccines RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_CitizenDrug RESTART IDENTITY CASCADE;

TRUNCATE TABLE Dim_Year RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_Month RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_Week RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_DayOfWeek RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_Time RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_Quarantine RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_Citizen RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_Disease RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_DiseaseVariant RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_PatientStatus RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_Venue RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_DiseaseTest RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_HealthUnit RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_District RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_City RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_Drug RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_SignSymptom RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dim_Vaccine RESTART IDENTITY CASCADE;


-- 1. Заполнение таблиц измерений (Dim Tables)

INSERT INTO Dim_Year (year_id, year) VALUES (1, 2020), (2, 2021), (3, 2022), (4, 2023), (5, 2024);

-- Dim_Month
INSERT INTO Dim_Month (month_id, month) VALUES
    (1, 'Январь'), (2, 'Февраль'), (3, 'Март'), (4, 'Апрель'), (5, 'Май'), (6, 'Июнь'),
    (7, 'Июль'), (8, 'Август'), (9, 'Сентябрь'), (10, 'Октябрь'), (11, 'Ноябрь'), (12, 'Декабрь');

-- Dim_Week
INSERT INTO Dim_Week (week_id, week)
SELECT generate_series(1,53), generate_series(1,53);

-- Dim_DayOfWeek
INSERT INTO Dim_DayOfWeek (dayofweek_id, dayOfWeek) VALUES
    (1, 'Пон'), (2, 'Вт'), (3, 'Ср'), (4, 'Чт'), (5, 'Пт'), (6, 'Суб'), (7, 'Вск');

-- Dim_Time
INSERT INTO Dim_Time (date, year_id, month_id, week_id, dayOfWeek_id)
SELECT
    date,
    EXTRACT(YEAR FROM date) - 2019,
 EXTRACT(MONTH FROM date),
 EXTRACT(WEEK FROM date),
 EXTRACT(DOW FROM date) +1
FROM generate_series('2020-01-01'::date, '2024-12-31', '1 day') as date;

-- Dim_Quarantine
INSERT INTO Dim_Quarantine (quarantineid, quarantineType, numberOfDays) VALUES(1, 'Домашний', 14), (2, 'Изоляция', 7), (3, 'Обсервация', 21);

-- Dim_Disease
INSERT INTO Dim_Disease (diseaseid, diseaseName) VALUES
    (1, 'Грипп'), (2, 'ОРВИ'), (3, 'COVID-19'), (4, 'Пневмония'), (5, 'Бронхит'), (6, 'Ангина')

-- Dim_DiseaseVariant
INSERT INTO Dim_DiseaseVariant (variantid, diseaseId, variantName) VALUES
    (1, 3, 'Альфа'), (2, 3, 'Бета'), (3, 3, 'Гамма'), (4, 3, 'Дельта'), (5, 3, 'Омикрон'), (6, 10, 'BA.5');

-- Dim_PatientStatus
INSERT INTO Dim_PatientStatus (patientstatusid, patientStatusName) VALUES
    (1, 'Легкое течение'), (2, 'Средне-тяжелое течение'), (3, 'Тяжелое течение'), (4, 'Госпитализирован'), (5, 'Выписан'), (6, 'Лечится дома'), (7, 'Выздоровел'), (8, 'Умер');

-- Dim_Venue
INSERT INTO Dim_Venue (venueid, venueType, venueAddress) VALUES
    (1, 'Больница', 'ул. Ленина, 1'), (2, 'Поликлиника', 'ул. Гагарина, 10'), (3, 'Торговый центр', 'ул. Пушкина, 25'), (4, 'Кинотеатр', 'ул. Островского, 50'),
    (5, 'Школа', 'ул. Учительская, 2'), (6, 'Ресторан', 'ул. Набережная, 15'), (7, 'Стадион', 'ул. Спортивная, 10');

-- Dim_DiseaseTest
INSERT INTO Dim_DiseaseTest (diseasetestid, diseaseTest) VALUES
    (1, 'ПЦР'), (2, 'Антиген'), (3, 'ИФА'), (4, 'Общий анализ крови'), (5, 'Тест на антитела');

-- Dim_HealthUnit
INSERT INTO Dim_HealthUnit (healthunitid, healthUnitName, address, districtId) VALUES
    (1, 'Больница №1', 'ул. Ленина, 1', 1),
 	(2, 'Поликлиника №1', 'ул. Гагарина, 10', 1),
    (3, 'Больница №2', 'ул. Космонавтов, 5', 2),
 	(4, 'Поликлиника №2', 'ул. Мира, 20', 2),
    (5, 'Больница №3', 'ул. Садовая, 20', 3),
    (6, 'Поликлиника №3', 'ул. Зеленая, 10', 3);

-- Dim_City
INSERT INTO Dim_City (cityid, cityName) VALUES
    (1, 'Москва'),
 	(2, 'Санкт-Петербург'),
    (3, 'Екатеринбург');

-- Dim_District
INSERT INTO Dim_District (districtid, districtName, cityId) VALUES
    (1, 'Центральный', 1),
 	(2, 'Заводской', 1),
    (3, 'Советский', 2),
 	(4, 'Ленинский', 2),
    (5, 'Кировский', 3),
    (6, 'Октябрьский', 3);

-- Dim_Drug
INSERT INTO Dim_Drug (drugid, drugName, diseaseId) VALUES
    (1, 'Парацетамол', 1), (2, 'Ибупрофен', 1), (3, 'Азитромицин', 3), (4, 'Амоксициллин', 4), (5, 'Коделак', 5),
    (6, 'Ремдесивир', 7), (7, 'Фавипиравир', 7), (8, 'Молнупиравир', 7), (9, 'Интерферон', 7), (10, 'Дексаметазон', 7);

-- Dim_SignSymptom
INSERT INTO Dim_SignSymptom (signsymptomid, signSymptom) VALUES
	(1, 'Температура'), (2, 'Кашель'), (3, 'Насморк'), (4, 'Боль в горле'), (5, 'Слабость'), 
	(6, 'Одышка'), (7, 'Потеря обоняния'), (8, 'Головная боль'), (9, 'Ломота в теле'), (10, 'Диарея'),
	(11, 'Тошнота'), (12, 'Рвота');

-- Dim_Vaccine
INSERT INTO Dim_Vaccine (vaccineid, vaccineName) VALUES
    (1, 'Спутник V'), (2, 'КовиВак'), (3, 'ЭпиВакКорона');

-- 2. Заполнение таблицы Dim_Citizen
INSERT INTO Dim_Citizen (citizenid, name, surname, gender, dateOfBirth, weight, height, phoneNumber, address, districtId)
select
	i, 
    'Имя' || i,
 'Фамилия' || i,
    CASE WHEN i % 2 = 0 THEN 'Мужской' ELSE 'Женский' END,
    ('1940-01-01'::date + (RANDOM() * (365 * 80))::integer * '1 day'::interval), -- Случайная дата рождения за последние 80 лет
    ROUND(CAST(RANDOM() * 70 + 50 as NUMERIC), 2), -- Случайный вес от 50 до 120 кг
    ROUND(CAST(RANDOM() * 30 + 160 as NUMERIC), 2), -- Случайный рост от 160 до 190 см
 '79' ||  (RANDOM() * 1000000000)::int::text, --Случайный номер телефона, начинающийся на 79
 'Адрес' || i,
 (RANDOM() * 5 + 1)::int
FROM generate_series(1, 10000000) as i;


-- 3. Заполнение таблиц фактов (Fact Tables)
-- Функция для генерации случайных дат между двумя датами (для Fact tables)
CREATE OR REPLACE FUNCTION random_date(start_date DATE, end_date DATE)
RETURNS DATE AS $$
BEGIN
  RETURN start_date + (random() * (end_date - start_date))::integer;
END;
$$ LANGUAGE plpgsql;

INSERT INTO Fact_CitizenQuarantine (citizenId, quarantineId, startDate, endDate)
select distinct 
    citizenId,
    quarantineId,
    startDate,
    CASE
        WHEN endDate < startDate THEN startDate
        ELSE endDate
    END AS endDate
FROM (
    SELECT DISTINCT
        (random() * 9999999 + 1)::int AS citizenId,
        (random() * 2 + 1)::int AS quarantineId,
        random_date('2020-01-01', '2024-12-31') AS startDate,
        random_date('2020-01-01', '2024-12-31') AS endDate
    FROM generate_series(1, 12000000)
) AS subquery;

select count(*) from Fact_CitizenQuarantine;

-- Fact_PatientDrug
INSERT INTO Fact_PatientDrug (patientId, drugId, startDate, endDate, dose)
select distinct 
    patientId,
    drugId,
    startDate,
    CASE
        WHEN endDate < startDate THEN startDate
        ELSE endDate
    END AS endDate,
    CASE WHEN random() > 0.5 THEN '1 таблетка' ELSE '2 таблетки' end as dose
FROM (
    SELECT DISTINCT
        (random() * 9999999 + 1)::int AS patientId,
        (random() * 9 + 1)::int AS drugId,
        random_date('2020-01-01', '2024-12-31') AS startDate,
        random_date('2020-01-01', '2024-12-31') AS endDate
    FROM generate_series(1, 10000000)
) AS subquery;

select count(*) from Fact_PatientDrug;

-- Fact_PatientSignSymptom
INSERT INTO Fact_PatientSignSymptom (patientId, signSymptomId, startDate, endDate)
select distinct 
    patientId,
    signSymptomId,
    startDate,
    CASE
        WHEN endDate < startDate THEN startDate
        ELSE endDate
    END AS endDate
FROM (
    SELECT DISTINCT
        (random() * 9999999 + 1)::int AS patientId,
        (random() * 11 + 1)::int AS signSymptomId,
        random_date('2020-01-01', '2024-12-31') AS startDate,
        random_date('2020-01-01', '2024-12-31') AS endDate
    FROM generate_series(1, 10000000)
) AS subquery;

select count(*) from Fact_PatientSignSymptom;

-- Fact_Patient
INSERT INTO Fact_Patient (patientId, diseaseId, date, patientStatusId)
select distinct 
    (random() * 9999999 + 1)::int AS patientId,
    (random() * 5 + 1)::int AS diseaseId,
    random_date('2020-01-01', '2024-12-31'),
    (random() * 7 + 1)::int AS patientStatusId
FROM generate_series(1, 10000000);

select count(*) from Fact_Patient;

-- Fact_CitizenVenues
INSERT INTO Fact_CitizenVenues (citizenId, venueId, date)
SELECT DISTINCT
    (random() * 9999999 + 1)::int AS citizenId,
    (random() * 6 + 1)::int AS venueId,
    random_date('2020-01-01', '2024-12-31')
FROM generate_series(1, 10000000);

-- Fact_CitizenDiseaseTests
INSERT INTO Fact_CitizenDiseaseTests (citizenId, diseaseTestId, date, healthUnitId, result)
SELECT DISTINCT
    (random() * 9999999 + 1)::int,
    (random() * 4 + 1)::int,
    random_date('2020-01-01', '2024-12-31'),
    (random() * 5 + 1)::int,
    CASE WHEN random() > 0.4 THEN 'Положительный' ELSE 'Отрицательный' END
FROM generate_series(1, 10000000);

SELECT COUNT(*) FROM Fact_CitizenDiseaseTests;

-- Fact_CitizenVaccines
INSERT INTO Fact_CitizenVaccines (citizenId, vaccineId, date, healthUnitId)
SELECT DISTINCT
    (random() * 9999999 + 1)::int,
    (random() * 2 + 1)::int,
    random_date('2020-01-01', '2024-12-31'),
    (random() * 9 + 1)::int
FROM generate_series(1, 10000000);

SELECT COUNT(*) FROM Fact_CitizenVaccines;

-- Dim_CitizenDrug
INSERT INTO Dim_CitizenDrug (citizenId, drugId, dose)
SELECT DISTINCT
    (random() * 9999999 + 1)::int,
    (random() * 9 + 1)::int,
    CASE WHEN random() > 0.5 THEN '1 таблетка' ELSE '2 таблетки' END
FROM generate_series(1, 10000000);

SELECT COUNT(*) FROM Dim_CitizenDrug;

-- Создание индексов на внешние ключи (для ускорения вставки)
CREATE INDEX idx_fact_citizenquarantine_citizenid ON Fact_CitizenQuarantine (citizenId);
CREATE INDEX idx_fact_citizenquarantine_quarantineid ON Fact_CitizenQuarantine (quarantineId);

CREATE INDEX idx_fact_patientdrug_patientid ON Fact_PatientDrug (patientId);
CREATE INDEX idx_fact_patientdrug_drugid ON Fact_PatientDrug (drugId);

CREATE INDEX idx_fact_patientsignsymptom_patientid ON Fact_PatientSignSymptom (patientId);
CREATE INDEX idx_fact_patientsignsymptom_signSymptomId ON Fact_PatientSignSymptom (signSymptomId);

CREATE INDEX idx_fact_patient_patientid ON Fact_Patient (patientId);
CREATE INDEX idx_fact_patient_diseaseid ON Fact_Patient (diseaseId);

CREATE INDEX idx_fact_citizenvenues_citizenid ON Fact_CitizenVenues (citizenId);
CREATE INDEX idx_fact_citizenvenues_venueid ON Fact_CitizenVenues (venueId);

CREATE INDEX idx_fact_citizendiseasetests_citizenid ON Fact_CitizenDiseaseTests (citizenId);
CREATE INDEX idx_fact_citizendiseasetests_diseasetestid ON Fact_CitizenDiseaseTests (diseaseTestId);

CREATE INDEX idx_fact_citizenvaccines_citizenid ON Fact_CitizenVaccines (citizenId);
CREATE INDEX idx_fact_citizenvaccines_vaccineid ON Fact_CitizenVaccines (vaccineId);

CREATE INDEX idx_dim_citizendrug_citizenid ON Dim_CitizenDrug (citizenId);
CREATE INDEX idx_dim_citizendrug_drugid ON Dim_CitizenDrug (drugId);


-- Удаление функции генерации случайных дат
DROP FUNCTION IF EXISTS random_date;