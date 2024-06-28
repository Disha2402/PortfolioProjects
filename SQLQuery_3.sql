select location , date , total_cases , new_cases , total_deaths , population from CovidDeaths order by 1,2;
 -- looking at total cases vs total deaths
 --Shows the liklehood of dying if you contract covid in your country
 select location , date , total_cases ,  total_deaths , (total_deaths/total_cases)*100 as "Death Percentage" from CovidDeaths where 
 location like '%india%' order by 1,2;

 --looking at the total cases vs population
 -- Shows the percentage of people infected
  select location , date , total_cases ,  population , (total_cases/population)*100 as "Infection Percentage" from CovidDeaths where 
 location like '%india%' order by 1,2;

 -- Shows the country with highest infection rates
 select location , max(total_cases) as HighestInfectionCount ,  population , max((total_cases/population))*100 as "Infection Percentage" from CovidDeaths 
 group by location , population order by 'Infection Percentage' desc;

 -- Showing countires with highest death count per population
 select location , max(cast(total_deaths as int)) as TotalDeathCount from CovidDeaths 
 where continent is not null
 group by location order by TotalDeathCount desc;

  select continent , max(cast(total_deaths as int)) as TotalDeathCount from CovidDeaths 
 where continent is not null
 group by continent order by TotalDeathCount desc;

 --Showing the continents with highest death count
 select continent , max(cast(total_deaths as int)) as TotalDeathCount from CovidDeaths
 where continent is not null 
 group by continent order by TotalDeathCount desc;

 --Global Numbers
SELECT 
   -- date, 
    SUM(CAST(new_cases AS BIGINT)) AS total_new_cases, 
    SUM(CAST(new_deaths AS BIGINT)) AS total_new_deaths, 
    CASE 
        WHEN SUM(CAST(new_cases AS BIGINT)) = 0 THEN 0
        ELSE (SUM(CAST(new_deaths AS DECIMAL(18, 2))) / SUM(CAST(new_cases AS DECIMAL(18, 2)))) * 100 
    END AS "Death Percentage"
FROM 
    CovidDeaths
WHERE 
    continent IS NOT NULL
--GROUP BY 
    --date
ORDER BY 1,2;

--looking at total populations vs vaccinations
select dea.continent , dea.location ,dea.date , dea. population , vac.new_vaccinations , sum(convert(bigint , vac.new_vaccinations))
over (partition by dea.location , dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date where dea.continent is not null order by 1,2,3;

-- USE CTE
with PopvsVac (continent , location , date , population , new_vaccinations , RollingPeopleVaccinated)
as 
(
select dea.continent , dea.location ,dea.date , dea. population , vac.new_vaccinations , sum(convert(bigint , vac.new_vaccinations))
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
)
select * , RollingPeopleVaccinated from PopVsVac;


--TEmp table
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime ,
    Population numeric , 
    new_vaccinations numeric,
    RollingPeopleVaccinated numeric
)


insert into #percentpopulationvaccinated
select dea.continent , dea.location ,dea.date , dea. population , vac.new_vaccinations , sum(convert(bigint , vac.new_vaccinations))
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null

select * , (RollingPeopleVaccinated/Population) *100 from #percentpopulationvaccinated;

--Creating views to store data for later visulaizations
Create View percentpopulationvaccinated as 
select dea.continent , dea.location ,dea.date , dea. population , vac.new_vaccinations , sum(convert(bigint , vac.new_vaccinations))
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null

select * from percentpopulationvaccinated

