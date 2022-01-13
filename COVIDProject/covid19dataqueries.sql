
-- Select Data to use
SELECT Location, Date, TOTAL_CASES, NEW_CASES, TOTAL_DEATHS, POPULATION
FROM Portfolio..CovidDeaths
ORDER BY 1,2;


--Total Cases vs. Total Deaths
SELECT Location, Date, TOTAL_CASES, TOTAL_DEATHS, (TOTAL_DEATHS/TOTAL_CASES) * 100 AS CasesToDeaths
FROM Portfolio..CovidDeaths
WHERE LOCATION LIKE '%states%'
ORDER BY 1,2;


-- Total Cases vs. Population
SELECT LOCATION, DATE, TOTAL_CASES, POPULATION, (TOTAL_CASES/POPULATION)*100 AS PopulationtoCases
FROM Portfolio..CovidDeaths
WHERE LOCATION LIKE '%states%'
ORDER BY LOCATION,DATE;


-- Query countries with highest infection rate compared to Population; Highest 10 results
SELECT Location, MAX(TOTAL_CASES) AS Covid_Cases, MAX((TOTAL_CASES/POPULATION)) * 100 AS PercentPopulationInfected
FROM Portfolio..CovidDeaths
GROUP BY LOCATION, POPULATION
ORDER BY PercentPopulationInfected DESC
OFFSET 0 ROWS
FETCH FIRST 10 ROWS ONLY;


-- Highest COVID-19 Death counts by Country
SELECT LOCATION, MAX(CAST(TOTAL_DEATHS AS INT)) AS TotalDeathCount
FROM Portfolio..CovidDeaths
WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION
ORDER BY TotalDeathCount DESC
OFFSET 0 ROWS
FETCH FIRST 10 ROWS ONLY;


-- Highest COVID-19 Death counts by Continent
SELECT continent, MAX(CAST(TOTAL_DEATHS AS INT)) AS DeathCountByContinent
FROM Portfolio..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY CONTINENT
ORDER BY DeathCountByContinent DESC;


--Rolling Vaccinations of vaccinations from different countries, by country
SELECT D.CONTINENT, D.LOCATION, D.DATE, D.POPULATION, V.NEW_VACCINATIONS , SUM(CONVERT(BIGINT,V.NEW_VACCINATIONS))
OVER (PARTITION BY D.LOCATION ORDER BY D.LOCATION, D.DATE) AS RollingVaccinationsByCountry
FROM Portfolio..CovidDeaths D JOIN Portfolio..CovidVaccinations V ON D.location = V.location AND D.date = V.date
WHERE D.CONTINENT IS NOT NULL
ORDER BY LOCATION,DATE


--Creating a view of the previous query
CREATE VIEW PercentVaccinated AS 
SELECT D.CONTINENT, D.LOCATION, D.DATE, D.POPULATION, V.NEW_VACCINATIONS , SUM(CONVERT(BIGINT,V.NEW_VACCINATIONS))
OVER (PARTITION BY D.LOCATION ORDER BY D.LOCATION, D.DATE) AS RollingVaccinationsByCountry
FROM Portfolio..CovidDeaths D JOIN Portfolio..CovidVaccinations V ON D.location = V.location AND D.date = V.date
WHERE D.CONTINENT IS NOT NULL
--ORDER BY LOCATION,DATE
