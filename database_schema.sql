--- Ölkelerin tablosu
CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100),
    region VARCHAR(50),
    dev_level VARCHAR(50)  -- bunlar inkisafda olan veya inkisaf etmis olkeleri gosteriri
);
---Tebii felaketlerin çeşitleri tablosu
CREATE TABLE disaster_types (
    type_id SERIAL PRIMARY KEY,
    disaster_type VARCHAR(50),
    subtype VARCHAR(50)
);
---ölkelerin iqlimsel degısıklıyı tabeli
CREATE TABLE climate_indicators (
    climate_id SERIAL PRIMARY KEY, ---esas açar
    country_id INT REFERENCES countries(country_id), --- ölkeler tabelindeki ölkelere bağlanır xarici açarla
    YEAR INT,
    avg_temperature NUMERIC(5,2),  ---ortalama tempratur
    rainfall_mm NUMERIC(10,2),   ---illik yağış migdarı
    co2_emission_tonnes NUMERIC(15,2)  --- carbon emisyonu migdarı
);
---Bu felaketlerin olduğu sürecde ölke iqtisadıyyatları
CREATE TABLE economic_indicators (
    econ_id SERIAL PRIMARY KEY,
    country_id INT REFERENCES countries(country_id),  --- xarici açarla bağlanıb
    YEAR INT,
    gdp_usd NUMERIC(18,2),
    energy_consumption_twh NUMERIC(10,2),
    growth_rate NUMERIC(5,2)  --- iqtisadiyyatın böyüme derecesi 
);
--- tebii felaketler tablosu
CREATE TABLE disasters (
    disaster_id SERIAL PRIMARY KEY,
    country_id INT REFERENCES countries(country_id),  --- xarici açarla ölkelere bağlanır
    type_id INT REFERENCES disaster_types(type_id), --- xarici açarla felaketlerin çeşitlerine bağlanır
    YEAR INT,
    total_deaths INT,
    total_affected INT,
    total_damage_usd NUMERIC(18,2)
);
--- bu tabelde biz ölkelerin tebii felaketler qarşısında olan direncini ölçürük// dinamiktir
--ve diger tablolara veriler elave etdıyımız zaman bu tabelde 'CREATE MATERIALIZED VIEW resilience_index AS' bu komutu yazaraq yenıleye bilirik
CREATE MATERIALIZED VIEW resilience_index AS
SELECT 
    c.country_name,
    e.year,
    e.gdp_usd,
    d.total_damage_usd,
    cl.co2_emission_tonnes,
    ROUND(
        (e.gdp_usd / NULLIF(d.total_damage_usd, 0)) * 100 
        - (cl.co2_emission_tonnes / 1000000), 2
    ) AS resilience_score
FROM disasters d
JOIN countries c ON d.country_id = c.country_id
JOIN economic_indicators e ON d.country_id = e.country_id AND d.year = e.year
JOIN climate_indicators cl ON d.country_id = cl.country_id AND d.year = cl.year;
