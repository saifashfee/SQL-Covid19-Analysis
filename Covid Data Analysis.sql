--Select * 
--From CovidDeaths
--Order by location

--Select * 
--From CovidVaccinations
--Order by location


--Selecting Data that we will be using
--Select location, Date, total_cases, new_cases, total_deaths, population
--From CovidDeaths
--Order by location, date




--Total cases vs total deaths
--Deleting because in calculating DeathPercentage dividing by total_cases (which are equal to 0)gives error
--With dividing_Zero_totalCases As
--(
--Select *
--From CovidDeaths
--Where total_cases = 0
--)
--Delete From dividing_Zero_totalCases

--Likelihood of dying if you contract Covid in your country
--Select location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From CovidDeaths
----Where location = 'India'
--Order by location, date


--Total Cases vs Population

--Select location, Date, total_cases, population, (total_cases/population)*100 as PercentageContracted
--From CovidDeaths
--Where location = 'India'
--Order by location, date


--Countries with highest infection rate compared to location
--Select location, population, Max(total_cases) as [Highest Infection Count], Max((total_cases/population)*100) as [Percentage of Population Infected] 
--From CovidDeaths
--Group by location, population
--Order by [Percentage of Population Infected] desc


--Countries with Highest death count per population

--Select location, Max(cast(total_deaths as int)) as [Total Death Count] 
--From CovidDeaths
--Where Continent is not null
--Group by location
--Order by [Total Death Count] desc


--Let's break things by Continent
--Select location, Max(cast(total_deaths as int)) as [Total Death Count] 
--From CovidDeaths
--Where continent is null
--Group by location
--Order by [Total Death Count] desc


--Continents with highest death counts
--Select continent, Max(total_deaths) as [Total Death Count]
--From CovidDeaths
--Where continent is not null
--Group by continent
--Order by [Total Death Count]


--Global Numbers


--Select date, Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, 
--(Sum(cast(new_deaths as int))/Sum(cast(new_cases as int)))*100 as Death_Percentage
--From CovidDeaths
--Where continent is not null
--Group by date
--Order by 1,2


--------------------------------------------------------
--Looking at total population vs vaccinations
--Select deaths.continent, deaths.location, deaths.date, deaths.population, vaxx.new_vaccinations, 
--Sum(cast(vaxx.new_vaccinations as bigint)) Over (Partition by deaths.location Order by deaths.location, deaths.date) as RollingPeopleVaccinated                              
--From CovidDeaths as deaths
--Join CovidVaccinations as vaxx
--	On deaths.location = vaxx.location
--	and deaths.date = vaxx.date
--Where deaths.continent is not null 
----and deaths.location = 'India'
--Order by 2,3


--CTE

--With PopulationVsVaccination (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
--as
--(
--Select deaths.continent, deaths.location, deaths.date, deaths.population, vaxx.new_vaccinations,
--	Sum(cast(vaxx.new_vaccinations as bigint)) Over (Partition by deaths.location Order by deaths.location, deaths.date) as RollingPeopleVaccinated
--From CovidDeaths as deaths
--Join CovidVaccinations as vaxx
--	On deaths.location = vaxx.location
--	and deaths.date = vaxx.date
--Where deaths.continent is not null 
----and deaths.location = 'India'
----Order by 2,3
--)
--Select *, (RollingPeopleVaccinated/population)*100
--From PopulationVsVaccination




--Temp table

--Drop table if exists #Percent_Population_Vaccinated 
--Create Table #Percent_Population_Vaccinated
--(
--Continent nvarchar(255),
--location nvarchar(255),
--date datetime,
--population numeric,
--new_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--Insert Into #Percent_Population_Vaccinated
--Select deaths.continent, deaths.location, deaths.date, deaths.population, vaxx.new_vaccinations,
--	Sum(cast(vaxx.new_vaccinations as bigint)) Over (Partition by deaths.location Order by deaths.location, deaths.date) as RollingPeopleVaccinated
--From CovidDeaths as deaths
--Join CovidVaccinations as vaxx
--	On deaths.location = vaxx.location
--	and deaths.date = vaxx.date
--Where deaths.continent is not null 

--Select * , (RollingPeopleVaccinated/population)*100
--From #Percent_Population_Vaccinated


--View

--Create View PercentagePopulationVaccinated as 
--Select deaths.continent, deaths.location, deaths.date, deaths.population, vaxx.new_vaccinations,
--	Sum(cast(vaxx.new_vaccinations as bigint)) Over (Partition by deaths.location Order by deaths.location, deaths.date) as RollingPeopleVaccinated
--From CovidDeaths as deaths
--Join CovidVaccinations as vaxx
--	On deaths.location = vaxx.location
--	and deaths.date = vaxx.date
--Where deaths.continent is not null

--Select * 
--From PercentagePopulationVaccinated
