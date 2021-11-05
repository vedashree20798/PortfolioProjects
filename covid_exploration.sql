select * from project.covid_deaths where continent is not null;
alter table covid_deaths drop column MyUnknownColumn;

select * from project.covid_vaccinations;
alter table covid_vaccinations drop column MyUnknownColumn;


# COVID DEATHS TABLE


select location, date, total_cases, new_cases, total_deaths, population
from project.covid_deaths
where continent is not null
order by 1,2;


# challenges- many empty columns, too big data to import, data types were different

# looking at total cases vs total deaths
# shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from project.covid_deaths
where location like '%states%' and continent is not null
order by 1,2;



# looking at total cases vs population
# shows that percentage of population got covid
select location, population, total_cases, (total_cases/population)*100 as population_percentage
from project.covid_deaths
where continent is not null
order by 1,2;


# countries with highest infection rate compared to population
select location, population, max(total_cases) as highest_infection_count,
max((total_cases/population))*100 as percent_population_infected
from project.covid_deaths
where continent is not null
group by location, population
order by percent_population_infected desc;


# showing countries with highest death count per population

select location, max(total_deaths) as total_death_count
from project.covid_deaths
where continent is not null
group by location
order by total_death_count desc;



# break down things by continent

select continent, max(total_deaths) as total_death_count
from project.covid_deaths
where continent is not null
group by continent
order by total_death_count desc;

# showing continents with the highest death count per population
select continent, max(total_deaths) as total_death_count
from project.covid_deaths
where continent is not null
group by continent
order by total_death_count desc;

# global numbers

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as death_percentage
from project.covid_deaths
#where location like '%states%' 
where continent is not null
# group by date
order by 1,2;


# COVID VACCINATIONS TABLE


# looking at total population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date)
as rollingpeoplevaccinated
from project.covid_deaths dea
join project.covid_vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
    order by 2,3;
