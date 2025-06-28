
select * from layoffs;
create  table layoff_statiging
like layoffs;
select * from layoff_statiging;

insert layoff_statiging
select *
from layoffs;
select * ,
row_number() over(
partition by company, industry, location, stage, country, funds_raised_millions, total_laid_off, percentage_laid_off, 'date') as row_num
from layoff_statiging;

with duplicate_cte as
(
select * ,
row_number() over(
partition by company, industry, location, stage, country, funds_raised_millions, total_laid_off, percentage_laid_off, 'date') as row_num
from layoff_statiging
)
select * from duplicate_cte
where row_num>1;


CREATE TABLE `layoff_statiging2` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoff_statiging2;

insert into layoff_statiging2
select * ,
row_number() over(
partition by company, industry, location, stage, country, funds_raised_millions, total_laid_off, percentage_laid_off, 'date') as row_num
from layoff_statiging;

select * from layoff_statiging2
where row_num > 1;

delete 
from layoff_statiging2
where row_num > 1;
select * from layoff_statiging2
where row_num > 1;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM layoff_statiging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 1;
select * from layoff_statiging2;
SET SQL_SAFE_UPDATES = 0;

-- --standardasing 
select company , trim(company)
from layoff_statiging2;

update layoff_statiging2
set company=trim(company);

update layoff_statiging2
set industry="crypto"
where industry like "crypto%"
;
select  distinct industry from layoff_statiging2
order by 1;

update layoff_statiging2 
set country = trim(trailing '.' from country)
where country like "united states%";

select distinct country, trim(trailing '.' from country)
from  layoff_statiging2
order by 1; 

UPDATE layoff_statiging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

select `date` from layoff_statiging2;

alter table layoff_statiging2
modify column `date` Date;

select * from layoff_statiging2;
SET SQL_SAFE_UPDATES = 0;

select * from layoff_statiging2 t1
join layoff_statiging2 t2
	on t1.company=t2.company
where (t1.industry is null or t1.industry = "")
and t2.industry is not null;

UPDATE layoff_statiging2
set industry= null
where industry = '';

UPDATE layoff_statiging2 t1
JOIN layoff_statiging2 t2
  ON t1.company = t2.company
  AND t1.industry IS NULL
  AND t2.industry IS NOT NULL
SET t1.industry = t2.industry;

select * from layoff_statiging2
where company='airbnb';

select * from layoff_statiging2
where total_laid_off is null
and percentage_laid_off is null;

delete from layoff_statiging2
where total_laid_off is null
and percentage_laid_off is null;

select * from layoff_statiging2;
alter table  layoff_statiging2
drop column row_num;

-- exploratatory data analysis
-- country with most layoffs
SELECT country, 
       SUM(total_laid_off) AS total_laid_off_employees,
       RANK() OVER (ORDER BY SUM(total_laid_off) DESC) AS ranking
FROM layoff_statiging2
GROUP BY country
ORDER BY ranking ASC;

-- which industry hit the most 
SELECT industry,
       SUM(total_laid_off) AS total_laid_off,
       RANK() OVER (ORDER BY SUM(total_laid_off) DESC) AS ranking
FROM layoff_statiging2
GROUP BY industry
ORDER BY ranking ASC;

-- which year got the most job cuts
SELECT YEAR(`date`) AS layoff_year, 
       SUM(total_laid_off) AS total_laid_off_employees
FROM layoff_statiging2
GROUP BY YEAR(`date`)
ORDER BY layoff_year DESC;

-- at what stage most layoffs happned
select  stage, sum(total_laid_off)
from layoff_statiging2
group by stage
order by 2 desc;
-- no of employees laid off from start of the season
select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoff_statiging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

select  company, year(`date`), sum(total_laid_off)
from layoff_statiging2
group by company, year(`date`)
order by 3  desc;

with company_year (company, years , total_laid_off) as
(
select  company, year(`date`), sum(total_laid_off)
from layoff_statiging2
group by company, year(`date`)
), company_year_rank as
(select *,
dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select * from company_year_rank
where ranking <=5;

-- top 5 companies based on the no of employees laid_off in each year
