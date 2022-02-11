Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

-- Project Covid 


-- Selecting the data I will going to use 

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2


-- Looking at the mortality rate = total deaths/total cases in Germany

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as MortalityRate
From PortfolioProject..CovidDeaths
Where location = 'Germany'
and continent is not null
order by 1,2
-- Germany	2022-02-09 	1.00958129044902 %


-- Percentage of the population that got Covid  

Select location, date, population, total_cases, (total_cases/population)*100 as InfectionRate
From PortfolioProject..CovidDeaths
Where location = 'Germany'
and continent is not null
order by 1,2
-- Germany	2022-02-09 14.1028183262523 %


-- Countries with the highest infection rate compared to population

Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as InfectionRate
From PortfolioProject..CovidDeaths
--Where location = 'Germany'
Where continent is not null
Group by location, population
order by InfectionRate desc


-- Countries with the highest Death Count per population

Select location, Max(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location = 'Germany'
Where continent is not null
Group by location
order by TotalDeathCount desc

--United States		912255
--Brazil			635421
--India				506520

-- Countinent with the highest Death Count per population

Select location, Max(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location = 'Germany'
Where continent is null
and location not like '%income%'
Group by location
order by TotalDeathCount desc

--Europe			1652124
--North America		1327933
--Asia				1317007
--South America		1231304
--European Union	974899
--Africa			242712
--Oceania			6857
--International		15


-- Global Numbers:

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location = 'Germany'
where continent is not null
--Group by date
order by 1,2

--DeathPercentage=	1.43123229958616


-- Using JOIN, looking at total Population vs Vaccinations:


--Using CTE

With PopvsVac (Continet, location, date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, vac.population, dea.new_vaccinations
, SUM(Convert(int,dea.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidVaccinations dea
join PortfolioProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as Vaccination_Penetration
From PopvsVac

-- Using Temp Table 

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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as BIGINT)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (RollingPeopleVaccinated/Population)*100 as Vaccination_Penetration
From #PercentPopulationVaccinated


-- Creating View to store data for visualizations 

Create view Vaccination_Penetration as 

Select dea.continent, dea.location, dea.date, vac.population, dea.new_vaccinations
, SUM(Convert(int,dea.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidVaccinations dea
join PortfolioProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From Vaccination_Penetration


--////
---Queries for tableau visualizations 

--1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
--Group By date
order by 1,2

--2.

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
and location not like '%income%'
Group by location
order by TotalDeathCount desc

-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc