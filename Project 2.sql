Select *
From [Project 2].dbo.CovidDeaths


Select *
From [Project 2].dbo.CovidVaccinations;


Select location, date, total_cases, total_deaths, population
From [Project 2].dbo.CovidDeaths
Order by 1,2;

-- Total Cases VS Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Project 2].dbo.CovidDeaths
Order by 1,2;


-- Total Cases VS Population

Select location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage
From [Project 2].dbo.CovidDeaths
Where location like 'Asia'
Order by 1,2;

-- Top 10 Countries with Highest infection


Select location, population, Max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as InfectedPercentage
From [Project 2].dbo.CovidDeaths
Group by location, population
Order by InfectedPercentage desc
Offset 0 Rows
Fetch Next 10 Rows Only;


-- Top 20 Countries with Highets Death Count Per Population


Select location, Max(cast(total_deaths as int)) as TotalDeaths
From [Project 2].dbo.CovidDeaths
Where continent is not null
Group by location
Order by TotalDeaths desc
Offset 0 Rows
Fetch Next 20 Rows Only;


-- Global Covid Deaths

Select sum(cast(total_deaths as int)) as GlobalCovidDeaths
From [Project 2].dbo.CovidDeaths


-- Total Population VS Vaccination

Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vacs.new_vaccinations, 
Sum(Convert(int, Vacs.new_vaccinations)) OVER (Partition by Deaths.location Order by Deaths.location, Deaths.date) as OngoingVacs
From [Project 2].dbo.CovidDeaths as Deaths
join [Project 2].dbo.CovidVaccinations as Vacs
on Deaths.location = Vacs.location
and Deaths.date = Vacs.date
Where Deaths.continent is not null
Order by 2,3


-- Using CTE

with Pop_Vac (continent, location, date, population, new_vaccinations, RollingVacs)
as
(
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vacs.new_vaccinations, 
Sum(Convert(int, Vacs.new_vaccinations)) OVER (Partition by Deaths.location Order by Deaths.location, Deaths.date) as RollingVacs
From [Project 2].dbo.CovidDeaths as Deaths
join [Project 2].dbo.CovidVaccinations as Vacs
on Deaths.location = Vacs.location
and Deaths.date = Vacs.date
Where Deaths.continent is not null
)

Select *, (RollingVacs/population)*100 as PercentageVaccinated
From Pop_Vac
Where location like 'Nigeria' and date Between '2021-01-01' and '2022-01-01'


-- Create View Top 20 Countries with Highets Death Count Per Population

Create View HighestDeathsPerPopulation as

Select location, Max(cast(total_deaths as int)) as TotalDeaths
From [Project 2].dbo.CovidDeaths
Where continent is not null
Group by location
Order by TotalDeaths desc
Offset 0 Rows
Fetch Next 20 Rows Only;


