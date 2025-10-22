REFRESH MATERIALIZED VIEW resilience_index;
SELECT * FROM public.resilience_index --- refreslıyerek calıştırdıq her yeni veri girildiyinde refresliyerek tabloyu yenileye bilerik

----------------------------------------------------------------------------------------
---indi ise dataları yoxlayaq

--1 ci--  cedvel ve setir sayları
SELECT 'countries' AS table_name, COUNT(*) FROM countries
UNION ALL
SELECT 'disaster_types', COUNT(*) FROM disaster_types
UNION ALL
SELECT 'disasters', COUNT(*) FROM disasters
UNION ALL
SELECT 'economic_indicators', COUNT(*) FROM economic_indicators
UNION ALL
SELECT 'climate_indicators', COUNT(*) FROM climate_indicators;

--2 ci--  Ölkelere üzre felaketlerin ümumi sayı
SELECT c.country_name, COUNT(d.disaster_id) AS felaket_sayı
FROM disasters d
JOIN countries c ON d.country_id = c.country_id
GROUP BY c.country_name
ORDER BY felaket_sayı DESC
LIMIT 10

--3 cü-- her felaketin verdiyi zererin dolar bazlı deyeri
SELECT dt.disaster_type, ROUND(SUM(d.total_damage_usd)/1000000,2) AS zerer_usd
FROM disasters d
JOIN disaster_types dt ON d.type_id = dt.type_id
GROUP BY dt.disaster_type
ORDER BY zerer_usd DESC

--4 cü-- ortalama gdp ve ortalama böyüme
SELECT c.region, 
       ROUND(AVG(e.gdp_usd)/1000000000, 2) AS ortalama_gdp_bil,
       ROUND(AVG(e.growth_rate), 2) AS ortalama_böyüme
FROM economic_indicators e
JOIN countries c ON e.country_id = c.country_id
GROUP BY c.region;

--5 ci-- felaketlere qarşı en dayanıqlı ilk 10 ölke
SELECT country_name, YEAR, resilience_score
FROM resilience_index
ORDER BY resilience_score DESC
LIMIT 10

--6 cı-- En az dayanıqlı ölkeler
SELECT country_name, YEAR, resilience_score
FROM resilience_index
ORDER BY resilience_score ASC
LIMIT 10

-- 7 ci-- inkişaf etmiş ve inkişafda olan ölkelerin ortalama dayanıqlılığı
SELECT dev_level, ROUND(AVG(resilience_score),2) AS avg_resilience
FROM resilience_index r 
JOIN public.countries c
ON r.country_name=c.country_name
GROUP BY dev_level
ORDER BY avg_resilience DESC
 
 --8 ci-- iqtisadiyyata zerer verme derecesine göre felaketlerin sıralaması(billion usd)
SELECT 
dt.disaster_type,
dt.subtype,
ROUND(SUM(d.total_damage_usd)/1000000000, 2) AS toplam_zerer
FROM disasters d
JOIN disaster_types dt ON d.type_id = dt.type_id
GROUP BY dt.disaster_type, dt.subtype
ORDER BY toplam_zerer DESC
LIMIT 5




