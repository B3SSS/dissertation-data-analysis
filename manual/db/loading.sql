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

-- Dim_Year
INSERT INTO Dim_Year (year) VALUES (2020), (2021), (2022), (2023), (2024);

-- Dim_Month
INSERT INTO Dim_Month (month) VALUES
    ('Январь'), ('Февраль'), ('Март'), ('Апрель'), ('Май'), ('Июнь'),
    ('Июль'), ('Август'), ('Сентябрь'), ('Октябрь'), ('Ноябрь'), ('Декабрь');

-- Dim_Week
INSERT INTO Dim_Week (week)
SELECT generate_series(1,53);

-- Dim_DayOfWeek
INSERT INTO Dim_DayOfWeek (dayOfWeek) VALUES
    ('Понедельник'), ('Вторник'), ('Среда'), ('Четверг'), ('Пятница'), ('Суббота'), ('Воскресенье');

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
INSERT INTO Dim_Quarantine (quarantineType, numberOfDays) VALUES('Домашний', 14), ('Изоляция', 7), ('Обсервация', 21), ('Локдаун', 30);

-- Dim_Disease
INSERT INTO Dim_Disease (diseaseName) VALUES
    ('Грипп'), ('ОРВИ'), ('COVID-19'), ('Пневмония'), ('Бронхит'), ('Ангина'),
 ('COVID-19 Альфа'), ('COVID-19 Дельта'), ('COVID-19 Омикрон'), ('COVID-19 BA.5');

-- Dim_DiseaseVariant
INSERT INTO Dim_DiseaseVariant (diseaseId, variantName) VALUES
    (3, 'Альфа'), (3, 'Бета'), (3, 'Гамма'), (3, 'Дельта'), (3, 'Омикрон'), (10, 'BA.5');


-- Dim_PatientStatus
INSERT INTO Dim_PatientStatus (patientStatusName) VALUES
    ('Легкое течение'), ('Средне-тяжелое течение'), ('Тяжелое течение'), ('Госпитализирован'), ('Выписан'), ('Лечится дома'), ('Выздоровел'), ('Умер');

-- Dim_Venue
INSERT INTO Dim_Venue (venueType, venueAddress) VALUES
    ('Больница', 'ул. Ленина, 1'), ('Поликлиника', 'ул. Гагарина, 10'), ('Торговый центр', 'ул. Пушкина, 25'), ('Кинотеатр', 'ул. Островского, 50'),
 ('Школа', 'ул. Учительская, 2'), ('Ресторан', 'ул. Набережная, 15'), ('Стадион', 'ул. Спортивная, 10');

-- Dim_DiseaseTest
INSERT INTO Dim_DiseaseTest (diseaseTest) VALUES
    ('ПЦР'), ('Антиген'), ('ИФА'), ('Общий анализ крови'), ('Тест на антитела');

-- Dim_HealthUnit
INSERT INTO Dim_HealthUnit (healthUnitName, address, districtId) VALUES
    ('Больница №1', 'ул. Ленина, 1', 1),
 ('Поликлиника №1', 'ул. Гагарина, 10', 1),
    ('Больница №2', 'ул. Космонавтов, 5', 2),
 ('Поликлиника №2', 'ул. Мира, 20', 2),
    ('Больница №3', 'ул. Садовая, 20', 3),
    ('Поликлиника №3', 'ул. Зеленая, 10', 3);

-- Dim_District
INSERT INTO Dim_District (districtName, cityId) VALUES
    ('Центральный', 1),
 ('Заводской', 1),
    ('Советский', 2),
 ('Ленинский', 2),
    ('Кировский', 3),
    ('Октябрьский', 3);

-- Dim_City
INSERT INTO Dim_City (cityName) VALUES
    ('Москва'),
 ('Санкт-Петербург'),
    ('Екатеринбург');


-- Dim_Drug
INSERT INTO Dim_Drug (drugName, diseaseId) VALUES
    ('Парацетамол', 1), ('Ибупрофен', 1), ('Азитромицин', 3), ('Амоксициллин', 4), ('Коделак', 5),
     ('Ремдесивир', 7), ('Фавипиравир', 7), ('Молнупиравир', 7), ('Интерферон', 7),
    ('Дексаметазон', 7);

-- Dim_SignSymptom
INSERT INTO Dim_SignSymptom (signSymptom) VALUES('Температура'), ('Кашель'), ('Насморк'), ('Боль в горле'), ('Слабость'), ('Одышка'), ('Потеря обоняния'),
    ('Головная боль'), ('Ломота в теле'), ('Диарея'), ('Тошнота'), ('Рвота');

-- Dim_Vaccine
INSERT INTO Dim_Vaccine (vaccineName) VALUES
    ('Спутник V'), ('КовиВак'), ('ЭпиВакКорона'), ('Pfizer'), ('Moderna'), ('AstraZeneca');


-- 2. Заполнение таблицы Dim_Citizen
INSERT INTO Dim_Citizen (name, surname, gender, dateOfBirth, weight, height, phoneNumber, address, districtId)
SELECT
    'Имя' || i,
 'Фамилия' || i,
    CASE WHEN i % 2 = 0 THEN 'Мужской' ELSE 'Женский' END,
    ('1940-01-01'::date + (random() * (365 * 80))::integer * '1 day'::interval), -- Случайная дата рождения за последние 80 лет
    ROUND(random() * 70 + 50, 2), -- Случайный вес от 50 до 120 кг
    ROUND(random() * 30 + 160, 2), -- Случайный рост от 160 до 190 см
 '79' ||  (random() * 1000000000)::int::text, --Случайный номер телефона, начинающийся на 79
 'Адрес' || i,
 (random() * 6 + 1)::int
FROM generate_series(1, 10000000) as i;


-- 3. Заполнение таблиц фактов (Fact Tables)
-- Функция для генерации случайных дат между двумя датами (для Fact tables)
CREATE OR REPLACE FUNCTION random_date(start_date DATE, end_date DATE)
RETURNS DATE AS $$
BEGIN
  RETURN start_date + (random() * (end_date - start_date))::integer;
END;
$$ LANGUAGE plpgsql;

-- Fact_CitizenQuarantine (меньше записей)
\COPY (SELECT
    (random() * 9999999 + 1)::int,
    (random() * 4 + 1)::int,
    random_date('2020-01-01', '2024-12-31'),
    random_date('2020-01-01', '2024-12-31')
FROM generate_series(1, 10000000)
    where random() < 0.3
) TO 'fact_citizenquarantine.csv' WITH (FORMAT CSV);

\echo 'Data for Fact_CitizenQuarantine exported, Starting import'
COPY Fact_CitizenQuarantine(citizenId, quarantineId, startDate, endDate)
FROM 'fact_citizenquarantine.csv'
WITH (FORMAT CSV);
\echo 'Data for Fact_CitizenQuarantine imported'

-- Fact_PatientDrug
\COPY (SELECT
    (random() * 9999999 + 1)::int,
    (random() * 10 + 1)::int,
    random_date('2020-01-01', '2024-12-31'),
 random_date('2020-01-01', '2024-12-31'),
 CASE WHEN random() > 0.5 THEN '1 таблетка' ELSE '2 таблетки' END
FROM generate_series(1, 10000000)
    where random() < 0.4
) TO 'fact_patientdrug.csv' WITH (FORMAT CSV);

\echo 'Data for Fact_PatientDrug exported, Starting import'
COPY Fact_PatientDrug(patientId, drugId, startDate, endDate, dose)
FROM 'fact_patientdrug.csv'
WITH (FORMAT CSV);
\echo 'Data for Fact_PatientDrug imported'



-- Fact_PatientSignSymptom
\COPY (SELECT
    (random() * 9999999 + 1)::int,
    (random() * 12 + 1)::int,
    random_date('2020-01-01', '2024-12-31'),
    random_date('2020-01-01', '2024-12-31')
FROM generate_series(1, 10000000)
    where random() < 0.5
) TO 'fact_patientsignsymptom.csv' WITH (FORMAT CSV);

\echo 'Data for Fact_PatientSignSymptom exported, Starting import'
COPY Fact_PatientSignSymptom(patientId, signSymptomId, startDate, endDate)
FROM 'fact_patientsignsymptom.csv'
WITH (FORMAT CSV);
\echo 'Data for Fact_PatientSignSymptom imported'

-- Fact_Patient
\COPY (SELECT
    (random() * 9999999 + 1)::int,
    (random() * 10 + 1)::int,
     random_date('2020-01-01', '2024-12-31'),
 (random() * 8 + 1)::int
FROM generate_series(1, 10000000)
     where random() < 0.5
) TO 'fact_patient.csv' WITH (FORMAT CSV);

\echo 'Data for Fact_Patient exported, Starting import'
COPY Fact_Patient(patientId, diseaseId, date, patientStatusId)
FROM 'fact_patient.csv'
WITH (FORMAT CSV);
\echo 'Data for Fact_Patient imported'


-- Fact_CitizenVenues
\COPY (SELECT
    (random() * 9999999 + 1)::int,
    (random() * 7 + 1)::int,
     random_date('2020-01-01', '2024-12-31')
FROM generate_series(1, 10000000)
    where random() < 0.7
) TO 'fact_citizenvenues.csv' WITH (FORMAT CSV);

\echo 'Data for Fact_CitizenVenues exported, Starting import'
COPY Fact_CitizenVenues(citizenId, venueId, date)
FROM 'fact_citizenvenues.csv'
WITH (FORMAT CSV);
\echo 'Data for Fact_CitizenVenues imported'

-- Fact_CitizenDiseaseTests
\COPY (SELECT
    (random() * 9999999 + 1)::int,
    (random() * 5 + 1)::int,
     random_date('2020-01-01', '2024-12-31'),
    (random() * 6 + 1)::int,
     CASE WHEN random() > 0.4 THEN 'Положительный' ELSE 'Отрицательный' END
FROM generate_series(1, 10000000)
    where random() < 0.7
) TO 'fact_citizendiseasetests.csv' WITH (FORMAT CSV);

\echo 'Data for Fact_CitizenDiseaseTests exported, Starting import'
COPY Fact_CitizenDiseaseTests(citizenId, diseaseTestId, date, healthUnitId, result)
FROM 'fact_citizendiseasetests.csv'
WITH (FORMAT CSV);
\echo 'Data for Fact_CitizenDiseaseTests imported'

-- Fact_CitizenVaccines
\COPY (SELECT
    (random() * 9999999 + 1)::int,
 (random() * 6 + 1)::int,
    random_date('2020-01-01', '2024-12-31'),
    (random() * 6 + 1)::int
FROM generate_series(1, 10000000)
      where random() < 0.6
) TO 'fact_citizenvaccines.csv' WITH (FORMAT CSV);

\echo 'Data for Fact_CitizenVaccines exported, Starting import'
COPY Fact_CitizenVaccines(citizenId, vaccineId, date, healthUnitId)
FROM 'fact_citizenvaccines.csv'
WITH (FORMAT CSV);
\echo 'Data for Fact_CitizenVaccines imported'


-- Dim_CitizenDrug
\COPY (SELECT
    (random() * 9999999 + 1)::int,
 (random() * 10 + 1)::int,
 CASE WHEN random() > 0\.5 THEN '1 таблетка' ELSE '2 таблетки' END
FROM generate_series(1, 10000000)
      where random() < 0.4
) TO 'dim_citizendrug.csv' WITH (FORMAT CSV);

\echo 'Data for Dim_CitizenDrug exported, Starting import'
COPY Dim_CitizenDrug(citizenId, drugId, dose)
FROM 'dim_citizendrug.csv'
WITH (FORMAT CSV);
\echo 'Data for Dim_CitizenDrug imported'

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