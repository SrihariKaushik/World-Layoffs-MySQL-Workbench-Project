
-- Data Clenaing Plan

SELECT * FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. NULL Values and Blank Values
-- 4. Remove Any Cloumns or Row 


-- Create another Table same as Original 


CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;


-- REMOVING DUPICATES

SELECT *, 
ROW_NUMBER() OVER( 
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`, stage,country,funds_raised) AS row_num
FROM layoffs_staging;


WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER( 
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`, stage,country,funds_raised) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1 ;



WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER( 
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`, stage,country,funds_raised) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1 ;







-- ########## Removing Duplicates

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER( 
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`, stage,country,funds_raised) AS row_num
FROM layoffs_staging ;


DELETE
FROM layoffs_staging2
WHERE row_num > 1;




-- ########## STANDARDIZING DATA 

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT `date`
FROM layoffs_staging2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;
	
SELECT *
FROM layoffs_staging2
WHERE  total_laid_off = '' 
AND percentage_laid_off = '';



-- ########## NULL Values or Empty Spaces + Removing Columns or Rows

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '' ;

SELECT *
FROM layoffs_staging2
WHERE  total_laid_off = '' 
AND percentage_laid_off = '';

DELETE 
FROM layoffs_staging2
WHERE  total_laid_off = '' 
AND percentage_laid_off = '';

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
