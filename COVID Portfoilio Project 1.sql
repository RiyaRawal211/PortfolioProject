 Select *
From PORTFOLIO..CovidDeaths
where continent is not null
Order by 3,4

--Select *
--From PORTFOLIO..CovidVaccinations
--Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PORTFOLIO..CovidDeaths
where continent is not null
Order by 1,2

--Looking at Total Cases vs Total Deaths
--Likelihood of dying if you contracr covid in your country
Select location, date, total_cases, total_deaths, 
(CAST(total_deaths AS FLOAT) / total_cases) * 100 AS DeathPercentage
From PORTFOLIO..CovidDeaths
where location like '%state%'
and continent is not null
Order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid
Select location, date, Population, total_cases, 
(CAST(total_cases AS FLOAT) / Population) * 100 AS DeathPercentage
From PORTFOLIO..CovidDeaths
--where location like '%state%'
where continent is not null
Order by 1,2

-- Looking at countries with highest infection rate compared to population
Select location, Population, MAX(total_cases) as HighestInfectionCount, 
(CAST(MAX(total_cases) AS FLOAT) / population)  * 100 as PercentagPopulationInfected
From PORTFOLIO..CovidDeaths
--where location like '%state%'
where continent is not null
Group by location, population
Order by PercentagPopulationInfected desc

--Showing countries with highest Death Count
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PORTFOLIO..CovidDeaths
--where location like '%state%'
where continent is not null
Group by location
Order by TotalDeathCount desc


--LETS BREAK THINGS DOWN BY CONTINENT

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PORTFOLIO..CovidDeaths
--where location like '%state%'
where continent is NOT null
Group by location
Order by TotalDeathCount desc


--Showing the continent with the highest death count per population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PORTFOLIO..CovidDeaths
--where location like '%state%'
where continent is NOT null
Group by location
Order by TotalDeathCount desc

--Global Numbers
Select sum(new_cases) as Total_cases, sum(new_deaths) as Total_deaths, 
CAST(SUM(new_deaths) AS FLOAT) / NULLIF(SUM(new_cases), 0) * 100 AS DeathPercentage
From PORTFOLIO..CovidDeaths
--where location like '%state%'
where continent is not null
--Group by date
Order by 1,2

--Looking at total population vs Vaccinations

--using CTE


with PopvsVac(continent, location, date,Population,new_vaccinations, RollingPeopleVaccinated) 
as(
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location Order by 
dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PORTFOLIO..CovidDeaths dea
join PORTFOLIO..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
)
Select *, (CAST(RollingPeopleVaccinated AS FLOAT) / NULLIF(population, 0)) * 100 
from PopvsVac
--order by 2,3


--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location Order by 
dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PORTFOLIO..CovidDeaths dea
join PORTFOLIO..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *, (CAST(RollingPeopleVaccinated AS FLOAT) / NULLIF(population, 0)) * 100 
from #PercentPopulationVaccinated
--order by 2,3


--Creating view to store data for later visualizations
USE PORTFOLIO;
GO

DROP VIEW IF EXISTS PercentPopulationVaccinated;
GO
Create View PercentPopulationVaccinated AS
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location Order by 
dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PORTFOLIO..CovidDeaths dea
join PORTFOLIO..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null




Select *
from PercentPopulationVaccinated
