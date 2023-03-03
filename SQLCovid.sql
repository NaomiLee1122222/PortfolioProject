select location, date, total_cases, new_cases, total_deaths, population  from CovidDeaths
order by 1,2;

--Looking at Total Cases vs Total Deaths in United States
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 DeathPercentage
FROM CovidDeaths
WHERE location LIKE '%viet%'
ORDER BY 1,2;

--Looking at Total Cases vs Population in VietNam
SELECT location, date, population, total_cases, (total_cases/population)*100 CasePercentage
FROM CovidDeaths
WHERE location LIKE '%viet%'
ORDER BY 1,2;

--Which country has the highest infection rate compared to population?
SELECT location, MAX((total_cases/population)*100) CasePercentage
FROM CovidDeaths
WHERE (total_cases/population)*100 IS NOT NULL
GROUP BY location
ORDER BY  CasePercentage DESC;

-- Showing countries with highest death count per population
SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeaths
FROM CovidDeaths
WHERE continent is  NULL
GROUP BY location
ORDER BY TotalDeaths DESC;

-- Showing countries with highest death count per population

SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeaths
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeaths DESC

--lOOKING AT TOTAL POPULATION VS VACCINATIONS

CREATE VIEW PercentPopulationVaccinated AS
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
		SUM(CAST(V.new_vaccinations AS int)) OVER (PARTITION BY D.Location ORDER BY D.location, D. date) AS RollingPeopleVaccinated,
		(SUM(CAST(V.new_vaccinations AS int)) OVER (PARTITION BY D.Location ORDER BY D.location, D. date))/D.Population*100 AS PercentPopulationVaccinated
FROM CovidDeaths D
JOIN CovidVaccinations V
ON D.location = V.location
WHERE D.continent IS NOT NULL
AND D.date = V.date;

SELECT * 
FROM PercentPopulationVaccinated;