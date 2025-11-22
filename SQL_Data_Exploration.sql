SELECT *
FROM PortfolioProject..CovidDeaths$
where continent is not null
ORDER BY 3,4;

--SELECT *
--FROM PorfolioProject..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
ORDER BY 1,2

--Total CASES vs Total Deaths
--shows the likelihood of getting covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
where location like '%INDIA%'
ORDER BY 1,2

--Total CASES vs Population
--shows the percentage of population that got covid in India
SELECT location, date, population,total_cases, (total_cases/population)*100 as AffectedPercentage
FROM PortfolioProject..CovidDeaths$
where location like '%INDIA%'
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT location, population, max(total_cases) as Highest_Infection_Rate, max((total_cases/population)*100) as MaxAffectedPercentage
FROM PortfolioProject..CovidDeaths$
group by location, population 
ORDER BY MaxAffectedPercentage desc

-- Showing Countries with Highest Death Count per Population

Select location, max(cast(total_deaths as int)) as MaxDeaths
from PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by MaxDeaths desc;

-- Showing Continents with Highest Death Count per Population

Select Continent, max(cast(total_deaths as int)) as MaxDeaths
from PortfolioProject..CovidDeaths$
where continent is not null
group by Continent
order by MaxDeaths desc;

-- Global Numbers
-- Showing total New death cases percentage all over the world
Select sum(new_cases) AS total_newcases, sum(cast(new_deaths as int)) as total_newdeaths , sum(cast(new_deaths as int))/sum(new_cases)as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2;


-- Looking at Total Population vs Vaccinations

select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, sum(convert(int,cv.new_vaccinations)) OVER (partition by cd.Location ORDER BY cd.location, cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ cd
Join
PortfolioProject..CovidVaccinations cv
On cd.location = cv.location
AND cd.date = cv.date
where cd.continent is not null
order by 2,3;

-- need to the total percentage of new vaccinations based on each country

-- Use CTE
With PopvsVac (Continent, location, date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, sum(convert(int,cv.new_vaccinations)) OVER (partition by cd.Location ORDER BY cd.location, cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ cd
Join
PortfolioProject..CovidVaccinations cv
On cd.location = cv.location
AND cd.date = cv.date
where cd.continent is not null
-- order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as Total_NewVac_Percentage
from PopvsVac


With PopvsVaLoc (Continent, location, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select cd.continent, cd.location, cd.population, cv.new_vaccinations
, sum(convert(int,cv.new_vaccinations)) OVER (partition by cd.Location ORDER BY cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ cd
Join
PortfolioProject..CovidVaccinations cv
On cd.location = cv.location
AND cd.date = cv.date
where cd.continent is not null
-- order by 2,3
)
SELECT 
    location,
    MAX(RollingPeopleVaccinated) AS MaxVaccinated,
    MAX((RollingPeopleVaccinated * 1.0 / population) * 100) AS MaxVaccinatedPercent
FROM PopvsVaLoc
GROUP BY location
ORDER BY MaxVaccinated DESC;


-- Temp Table for PercentPopulationVaccinated

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

Insert into #PercentPopulationVaccinated
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, sum(convert(int,cv.new_vaccinations)) OVER (partition by cd.Location ORDER BY cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ cd
Join
PortfolioProject..CovidVaccinations cv
On cd.location = cv.location
AND cd.date = cv.date
where cd.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- Creating view to store data for later visualisations

USE PortfolioProject;
GO
Create View PercentPopulationVaccinated_vw as
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, sum(convert(int,cv.new_vaccinations)) OVER (partition by cd.Location ORDER BY cd.location, cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ cd
Join
PortfolioProject..CovidVaccinations cv
On cd.location = cv.location
AND cd.date = cv.date
where cd.continent is not null;
--order by 2,3;

Select * From PercentPopulationVaccinated_vw;