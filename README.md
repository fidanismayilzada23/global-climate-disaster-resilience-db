# 🌍 Global Climate Disaster Resilience Database (2000–2024)

A **PostgreSQL-based analytical database** that explores the relationship between **climate-related disasters**, **economic indicators**, and **resilience capacity** across **20 countries**.

---

## 🧱 Database Overview

This project models how countries' economic and environmental resilience responds to natural disasters between **2000–2024**.

### **Schema Structure**
| Table | Description |
|--------|--------------|
| **countries** | Lists all countries with their region and development status (Developed / Developing). |
| **disaster_types** | Defines disaster categories and subtypes (e.g., Flood, Earthquake, Drought). |
| **disasters** | Records disaster events per country and year, including deaths, affected population, and total damages. |
| **economic_indicators** | Contains GDP (USD), energy consumption, and economic growth rates. |
| **climate_indicators** | Includes CO₂ emissions, rainfall (mm), and average temperature (°C). |

---

## 🔬 Materialized View: `resilience_index`
The **resilience index** quantifies each country's capacity to recover from disasters:

\[
\text{Resilience Score} = \frac{GDP}{Total Damage} \times 100 - \frac{CO₂}{1,000,000}
\]

It dynamically updates whenever new data is added using:
```sql
REFRESH MATERIALIZED VIEW resilience_index;
📊 Sample Analytical Queries
1️⃣ Countries with the Most Disasters
SELECT c.country_name, COUNT(d.disaster_id) AS total_disasters
FROM disasters d
JOIN countries c ON d.country_id = c.country_id
GROUP BY c.country_name
ORDER BY total_disasters DESC
LIMIT 10;

2️⃣ Most Economically Damaging Disaster Type
SELECT dt.disaster_type, 
       ROUND(SUM(d.total_damage_usd)/1000000000, 2) AS total_damage_billion
FROM disasters d
JOIN disaster_types dt ON d.type_id = dt.type_id
GROUP BY dt.disaster_type
ORDER BY total_damage_billion DESC
LIMIT 5;

3️⃣ Average Resilience by Development Level
SELECT dev_level, ROUND(AVG(resilience_score),2) AS avg_resilience
FROM resilience_index r 
JOIN countries c ON r.country_name = c.country_name
GROUP BY dev_level
ORDER BY avg_resilience DESC;
⚙️ Run Instructions

Clone the repository:

git clone https://github.com/fidanismayilzada23/global-climate-disaster-resilience-db.git


Open PostgreSQL / Valentina Studio.



