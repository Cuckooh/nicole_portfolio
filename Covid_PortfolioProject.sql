/* 
Covid 19 Data Exploration

Skills used: Joins, CTE's, Temp Tables, Windows Functions, 
Aggregate Functions, Creating Views, Converting Data Types
*/


Select *
From PortfolioProject..CovidDeaths
Order by 3,4;


--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4;


Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2


-- -------------------------------------------------
-- Change date format and update to YYYY-MM-DD

SELECT 
	CONVERT(VARCHAR, date, 23) AS FormattedDate
FROM 
    PortfolioProject..CovidDeaths

EXEC sp_help 'PortfolioProject..CovidDeaths';

SELECT 
    CONVERT(VARCHAR, CAST(date AS DATE), 23) AS FormattedDate
FROM 
    PortfolioProject..CovidDeaths;

UPDATE PortfolioProject..CovidDeaths
SET date = CAST(date AS DATE);

Select *
From PortfolioProject..CovidDeaths
-- -------------------------------------------------


-- -------------------------------------------------
-- Total Cases vs Total Deaths
-- how many cases are there in a country
-- how many deaths do they have for their entire cases
-- shows likelyhood of dying if you contract covid in your country

SELECT 
    Location, 
    date, 
    total_cases, 
    total_deaths, 
    CASE 
        WHEN total_cases = 0 THEN 0
        ELSE (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100
    END AS DeathPercentage
FROM 
    PortfolioProject..CovidDeaths
ORDER BY 
    1, 2;

SELECT 
    Location, 
    date, 
    total_cases, 
    total_deaths, 
    CASE 
        WHEN total_cases = 0 THEN 0
        ELSE (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100
    END AS DeathPercentage
FROM 
    PortfolioProject..CovidDeaths
Where 
	location like '%states%'
ORDER BY 
    1, 2;

SELECT 
    Location, 
    date, 
    total_cases, 
    total_deaths, 
    CASE 
        WHEN total_cases = 0 THEN 0
        ELSE (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100
    END AS DeathPercentage
FROM 
    PortfolioProject..CovidDeaths
Where 
	location like '%Philippines%'
ORDER BY 
    1, 2;
-- -------------------------------------------------


-- -------------------------------------------------
-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT 
    Location, 
    date, 
    CAST(Population AS BIGINT) AS Population, 
    total_cases, 
    CASE 
        WHEN CAST(Population AS BIGINT) = 0 THEN 0
        ELSE (CAST(total_cases AS FLOAT) / CAST(Population AS BIGINT)) * 100
    END AS PercentPopulationInfected
FROM 
    PortfolioProject..CovidDeaths
ORDER BY 
    1, 2;

SELECT 
    Location, 
    date, 
    CAST(Population AS BIGINT) AS Population, 
    total_cases, 
    CASE 
        WHEN CAST(Population AS BIGINT) = 0 THEN 0
        ELSE (CAST(total_cases AS FLOAT) / CAST(Population AS BIGINT)) * 100
    END AS PercentPopulationInfected
FROM 
    PortfolioProject..CovidDeaths
--WHERE
--	location like '%states%'
ORDER BY 
    1, 2;

SELECT 
    Location, 
    date, 
    CAST(Population AS BIGINT) AS Population, 
    total_cases, 
    CASE 
        WHEN CAST(Population AS BIGINT) = 0 THEN 0
        ELSE (CAST(total_cases AS FLOAT) / CAST(Population AS BIGINT)) * 100
    END AS PercentPopulationInfected
FROM 
    PortfolioProject..CovidDeaths
WHERE
	location like '%Philippines%'
ORDER BY 
    1, 2;
-- -------------------------------------------------


-- -------------------------------------------------
-- Countries with Highest Infection Rate compared to Population

SELECT 
    Location, 
    CAST(Population AS BIGINT) AS Population, 
    MAX(CAST(total_cases AS BIGINT)) AS HighestInfectionCount,  
    MAX(CASE 
        WHEN CAST(Population AS BIGINT) = 0 THEN 0
        ELSE (CAST(total_cases AS FLOAT) / CAST(Population AS FLOAT)) * 100
    END) AS PercentPopulationInfected
FROM 
    PortfolioProject..CovidDeaths
GROUP BY 
    Location, 
    CAST(Population AS BIGINT)
ORDER BY 
    PercentPopulationInfected DESC;
-- -------------------------------------------------



-- -------------------------------------------------
-- Countries with Highest Death Count per Population

SELECT 
    Location, 
    MAX(CAST(total_deaths AS int)) AS TotalDeathCount 
From 
PortfolioProject..CovidDeaths
Where
	continent is not null
Group by
	location
order by
	TotalDeathCount desc;


Select *
From PortfolioProject..CovidDeaths
Order by 3,4;

Select *
From PortfolioProject..CovidDeaths
where location is not null
Order by 3,4;
-- -------------------------------------------------



-- -------------------------------------------------
-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc


Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by location
order by TotalDeathCount desc
-- -------------------------------------------------



-- -------------------------------------------------
-- GLOBAL NUMBERS

SELECT 
    date,
    SUM(CAST(new_cases AS INT)) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    (SUM(CAST(new_deaths AS FLOAT)) / SUM(CAST(new_cases AS FLOAT))) * 100 AS DeathPercentage
FROM 
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL AND CAST(new_cases AS INT) > 0
GROUP BY 
    date
ORDER BY 
    1,2;


SELECT 
    SUM(CAST(new_cases AS INT)) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    (SUM(CAST(new_deaths AS FLOAT)) / SUM(CAST(new_cases AS FLOAT))) * 100 AS DeathPercentage
FROM 
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL AND CAST(new_cases AS INT) > 0
ORDER BY 
    1,2;
-- -------------------------------------------------
-- -------------------------------------------------



-- -------------------------------------------------
SELECT *
FROM
	PortfolioProject..CovidVaccinations
-- -------------------------------------------------


-- -------------------------------------------------
-- Change date format and update to YYYY-MM-DD

SELECT 
	CONVERT(VARCHAR, date, 23) AS FormattedDate
FROM 
    PortfolioProject..CovidVaccinations

SELECT 
    CONVERT(VARCHAR, CAST(date AS DATE), 23) AS FormattedDate
FROM 
    PortfolioProject..CovidVaccinations;

UPDATE PortfolioProject..CovidVaccinations
SET date = CAST(date AS DATE);

Select *
From PortfolioProject..CovidVaccinations
-- -------------------------------------------------


-- -------------------------------------------------
-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT *
FROM 
	PortfolioProject..CovidDeaths dea
JOIN
	PortfolioProject..CovidVaccinations vac
ON
	dea.location = vac.location
	and dea.date = vac.date


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM 
	PortfolioProject..CovidDeaths dea
JOIN
	PortfolioProject..CovidVaccinations vac
ON
	dea.location = vac.location
	and dea.date = vac.date
WHERE
	dea.continent is not null
ORDER By
	2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS
(
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        CAST(dea.population AS BIGINT) AS Population,
        vac.new_vaccinations,
        SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    FROM 
        PortfolioProject..CovidDeaths dea
    JOIN 
        PortfolioProject..CovidVaccinations vac
    ON 
        dea.location = vac.location
        AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL
)
SELECT *
FROM PopvsVac;


WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS
(
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        CAST(dea.population AS BIGINT) AS Population,
        vac.new_vaccinations,
        SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    FROM 
        PortfolioProject..CovidDeaths dea
    JOIN 
        PortfolioProject..CovidVaccinations vac
    ON 
        dea.location = vac.location
        AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL
)
SELECT *, 
       CASE 
           WHEN Population = 0 THEN 0
           ELSE (CAST(RollingPeopleVaccinated AS FLOAT) / CAST(Population AS FLOAT)) * 100 
       END AS PercentPopulationVaccinated
FROM PopvsVac;
-- -------------------------------------------------



-- -------------------------------------------------
-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    TRY_CAST(dea.population AS NUMERIC) AS Population, 
    TRY_CAST(vac.new_vaccinations AS NUMERIC) AS New_Vaccinations, 
    SUM(TRY_CAST(vac.new_vaccinations AS NUMERIC)) OVER (
        PARTITION BY dea.Location 
        ORDER BY dea.location, dea.Date
    ) AS RollingPeopleVaccinated
FROM 
    PortfolioProject..CovidDeaths dea
JOIN 
    PortfolioProject..CovidVaccinations vac
ON 
    dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated
-- -------------------------------------------------



-- -------------------------------------------------
-- Creating View to store data for later visualizations
DROP VIEW PercentPopulationVaccinated;


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


SELECT *
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = 'PercentPopulationVaccinated';

SELECT *
FROM PercentPopulationVaccinated;
-- -------------------------------------------------
-- -------------------------------------------------


/*
SELECT HAS_PERMS_BY_NAME('PercentPopulationVaccinated', 'OBJECT', 'VIEW DEFINITION');

DROP VIEW PercentPopulationVaccinated;

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations, 
       SUM(CONVERT(INT, vac.new_vaccinations)) OVER (
           PARTITION BY dea.Location 
           ORDER BY dea.location, dea.Date
       ) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

*/

