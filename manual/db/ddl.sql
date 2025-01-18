-- Dimensions

CREATE TABLE Dim_Year (
    year_id INTEGER PRIMARY KEY,
    year INTEGER NOT NULL
);

CREATE TABLE Dim_Month (
    month_id INTEGER PRIMARY KEY,
    month VARCHAR(20) NOT NULL
);


CREATE TABLE Dim_Week (
    week_id INTEGER PRIMARY KEY,
    week INTEGER NOT NULL
);


CREATE TABLE Dim_DayOfWeek (
    dayOfWeek_id INTEGER PRIMARY KEY,
    dayOfWeek VARCHAR(10) NOT NULL
);

CREATE TABLE Dim_Time (
    date DATE PRIMARY KEY,
    year_id INTEGER REFERENCES Dim_Year(year_id),
    month_id INTEGER REFERENCES Dim_Month(month_id),
    week_id INTEGER REFERENCES Dim_Week(week_id),
    dayOfWeek_id INTEGER REFERENCES Dim_DayOfWeek(dayOfWeek_id)
);

CREATE TABLE Dim_Quarantine (
    quarantineId INTEGER PRIMARY KEY,
    quarantineType VARCHAR(50),
    numberOfDays INTEGER
);

CREATE TABLE Dim_City (
    cityId INTEGER PRIMARY KEY,
    cityName VARCHAR(100) NOT NULL
);

CREATE TABLE Dim_District (
    districtId INTEGER PRIMARY KEY,
    districtName VARCHAR(100) NOT NULL,
    cityId INTEGER REFERENCES Dim_City(cityId)
);

CREATE TABLE Dim_Citizen (
    citizenId INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100),
    gender VARCHAR(10),
    dateOfBirth DATE,
    weight DECIMAL(5, 2),
    height DECIMAL(5, 2),
    phoneNumber VARCHAR(20),
    address TEXT,
    districtId INTEGER REFERENCES Dim_District(districtId)
);

CREATE TABLE Dim_Disease (
    diseaseId INTEGER PRIMARY KEY,
    diseaseName VARCHAR(255) NOT NULL
);

CREATE TABLE Dim_DiseaseVariant (
    variantId INTEGER PRIMARY KEY,
    diseaseId INTEGER REFERENCES Dim_Disease(diseaseId),
    variantName VARCHAR(255)
);


CREATE TABLE Dim_PatientStatus (
    patientStatusId INTEGER PRIMARY KEY,
    patientStatusName VARCHAR(50) NOT NULL
);


CREATE TABLE Dim_Venue (
    venueId INTEGER PRIMARY KEY,
    venueType VARCHAR(50),
    venueAddress TEXT
);


CREATE TABLE Dim_DiseaseTest (
   diseaseTestId INTEGER PRIMARY KEY,
   diseaseTest VARCHAR(50) NOT NULL
);


CREATE TABLE Dim_HealthUnit (
    healthUnitId INTEGER PRIMARY KEY,
    healthUnitName VARCHAR(255) NOT NULL,
    address TEXT,
    districtId INTEGER
);

CREATE TABLE Dim_Drug (
    drugId INTEGER PRIMARY KEY,
    drugName VARCHAR(255) NOT NULL,
    diseaseId INTEGER REFERENCES Dim_Disease(diseaseId)
);

CREATE TABLE Dim_SignSymptom(
    signSymptomId INTEGER PRIMARY KEY,
    signSymptom VARCHAR(255)
);

CREATE TABLE Dim_Vaccine (
    vaccineId INTEGER PRIMARY KEY,
    vaccineName VARCHAR(255)
);

-- Facts

CREATE TABLE Fact_CitizenQuarantine (
    citizenId INTEGER REFERENCES Dim_Citizen(citizenId),
    quarantineId INTEGER REFERENCES Dim_Quarantine(quarantineId),
    startDate DATE REFERENCES Dim_Time(date),
    endDate DATE REFERENCES Dim_Time(date),
    PRIMARY KEY (citizenId, quarantineId, startDate, endDate) -- Composite Primary Key
);

CREATE TABLE Fact_PatientDrug (
    patientId INTEGER REFERENCES Dim_Citizen(citizenId),
    drugId INTEGER REFERENCES Dim_Drug(drugId),
    startDate DATE REFERENCES Dim_Time(date),
    endDate DATE REFERENCES Dim_Time(date),
    dose VARCHAR(50),
    PRIMARY KEY (patientId, drugId, startDate) -- Composite Primary Key
);


CREATE TABLE Fact_PatientSignSymptom (
    patientId INTEGER REFERENCES Dim_Citizen(citizenId),
    signSymptomId INTEGER REFERENCES Dim_SignSymptom(signSymptomId),
    startDate DATE REFERENCES Dim_Time(date),
    endDate DATE REFERENCES Dim_Time(date),
    PRIMARY KEY (patientId, signSymptomId, startDate) -- Composite Primary Key
);


CREATE TABLE Fact_Patient (
    patientId INTEGER REFERENCES Dim_Citizen(citizenId),
    diseaseId INTEGER REFERENCES Dim_Disease(diseaseId),
    date DATE REFERENCES Dim_Time(date),
    patientStatusId INTEGER REFERENCES Dim_PatientStatus(patientStatusId),
    PRIMARY KEY (patientId, diseaseId, date) -- Composite Primary Key
);


CREATE TABLE Fact_CitizenVenues (
    citizenId INTEGER REFERENCES Dim_Citizen(citizenId),
    venueId INTEGER REFERENCES Dim_Venue(venueId),
    date DATE REFERENCES Dim_Time(date),
    PRIMARY KEY (citizenId, venueId, date)
);

CREATE TABLE Fact_CitizenDiseaseTests (
    citizenId INTEGER REFERENCES Dim_Citizen(citizenId),
    diseaseTestId INTEGER REFERENCES Dim_DiseaseTest(diseaseTestId),
    date DATE REFERENCES Dim_Time(date),
    healthUnitId INTEGER REFERENCES Dim_HealthUnit(healthUnitId),
    result VARCHAR(50),
    PRIMARY KEY (citizenId, diseaseTestId, date)
);


CREATE TABLE Fact_CitizenVaccines (
    citizenId INTEGER REFERENCES Dim_Citizen(citizenId),
    vaccineId INTEGER REFERENCES Dim_Vaccine(vaccineId),
    date DATE REFERENCES Dim_Time(date),
    healthUnitId INTEGER REFERENCES Dim_HealthUnit(healthUnitId),
    PRIMARY KEY (citizenId, vaccineId, date) -- Composite Primary Key
);


CREATE TABLE Dim_CitizenDrug (
    citizenId INTEGER REFERENCES Dim_Citizen(citizenId),
    drugId INTEGER REFERENCES Dim_Drug(drugId),
    dose VARCHAR(50),
    PRIMARY KEY (citizenId, drugId) -- Composite Primary Key
);