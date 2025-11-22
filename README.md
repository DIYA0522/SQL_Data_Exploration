## 📊 COVID-19 Data Exploration Using SQL

A data exploration project using SQL Server Management Studio (SSMS) to analyze global COVID-19 cases, deaths, infections, and vaccination progress.
The project uses two datasets:

CovidDeaths.csv
CovidVaccinations.csv

- The goal is to understand how COVID-19 spread across countries and continents, the severity of infections, and the global progress of vaccinations.

## 🗂️ Project Files
CovidDeaths — Contains daily global data on cases, deaths, population, etc.
CovidVaccinations — Contains daily vaccination counts for each location.

## 🛠️ Technologies Used

- SQL Server Management Studio (SSMS)
- T-SQL (Transact-SQL)
- Window functions (OVER, PARTITION BY)
- Common Table Expressions (CTEs)
- Temp tables
- Views

## 📘 Key SQL Explorations & Analysis
1️⃣ Total Cases vs Total Deaths
Analyzed likelihood of death when infected with COVID-19.
Used total_cases and total_deaths
Calculated Death Percentage
Used WHERE to filter by country (e.g., India)

2️⃣ Total Cases vs Population
Shows the percentage of the population infected in each country.
Calculated infection rate
Useful for understanding which countries were most affected

3️⃣ Countries With Highest Infection Rate Compared to Population
Found the maximum affected percentage per country.
Grouped by location and population
Used MAX() to extract peak infection rate

4️⃣ Countries With Highest Death Count
Analyzed the countries with the highest cumulative deaths.
Used MAX(total_deaths)
Ensured CAST for numeric accuracy (since data may be stored as text)

5️⃣ Continents With Highest Death Count
Aggregated data by continent to compare severity at a higher level.

6️⃣ Global Numbers
Computed overall global COVID-19 impact:
SUM of new cases
SUM of new deaths
Global death percentage

7️⃣ Total Population vs Vaccinations
Integrated vaccination data to calculate progress across countries.

8️⃣ Vaccination Percentage by Country (CTE + Window Function)
Created a rolling total using a CTE:
SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY date)
Calculated % of population vaccinated
Also repeated the same logic using a Temporary Table for comparison.

9️⃣ Maximum Vaccinated Count & Percent (CTE)
Found:
Highest cumulative vaccinated per country
Highest vaccination percentage

🔟 Created Views for Re-use
