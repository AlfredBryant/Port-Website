Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2


-- Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2


-- Total Cases vs Populations

Select location, date, population ,total_cases, (total_cases/population)*100 as PercentagePopulationInfected 
From PortfolioProject..CovidDeaths
--where location like '%state%'
order by 1,2

-- Countries with highest Infection Rate compared to Population

Select location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as
     PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%state%'
Group by location, population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%state%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%state%'
Where continent is not null
Group by location
order by TotalDeathCount desc


--Global Numbers

Select date, SUM(new_cases) as total_cases, Sum(cast(total_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%state%'
where continent is not null
Group By date
order by 1,2

Select SUM(new_cases) as total_cases, Sum(cast(total_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM
(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%state%'
where continent is not null
--Group By date
order by 1,2

-- Total Population vs Vaccinations


Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
     and dea.date = vac.date
     where dea.continent is not null
order by 1,2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) 
as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
     and dea.date = vac.date
     where dea.continent is not null
order by 2,3

-- CTE

With PopsvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) 
as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)
Select * , (RollingPeopleVaccinated/population)*100
From PopsvsVac



-- Temp Table



Drop Table if exists #PercentPopulatedVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
-- order by 2,3


Select * , (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



-- View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated



