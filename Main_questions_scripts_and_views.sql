
 -- 1.	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

CREATE OR REPLACE VIEW v_marek_duda_avg_wages_sector_and_year AS 
SELECT 
	industry_branch_name
	,payroll_year
	,round(avg(avg_wages)) AS avg_wages_czk
FROM t_marek_duda_project_SQL_primary_final
GROUP BY industry_branch_name, payroll_year
ORDER BY industry_branch_name;

SELECT * FROM v_marek_duda_avg_wages_sector_and_year;

-- Trend růstu mezd dle odvětví a roků
CREATE OR REPLACE VIEW v_marek_duda_wages_sector_and_year AS 
SELECT
	new_avg.industry_branch_name
	,old_avg.payroll_year AS old_year
	,old_avg.avg_wages_czk AS old_wages
	,new_avg.payroll_year AS new_year
	,new_avg.avg_wages_czk AS new_wages
	,new_avg.avg_wages_czk - old_avg.avg_wages_czk AS wages_diff_czk
	,round(new_avg.avg_wages_czk * 100 / old_avg.avg_wages_czk, 2) - 100 AS wages_diff_percentage,
	CASE
		WHEN new_avg.avg_wages_czk > old_avg.avg_wages_czk
			THEN 'UP'
			ELSE 'DOWN'
	END AS wages_trend
FROM v_marek_duda_avg_wages_sector_and_year AS new_avg
JOIN v_marek_duda_avg_wages_sector_and_year AS old_avg
	ON new_avg.industry_branch_name = old_avg.industry_branch_name
	AND new_avg.payroll_year = old_avg.payroll_year +1
ORDER BY industry_branch_name;

SELECT * FROM v_marek_duda_wages_sector_and_year;
-- Mzdy ve všech sledovaných odvětvích od roku 2006 do roku 2018 rostou, nicméně růst mezd nebyl lineární a v některých letech byl zaznamenán i pokles.


SELECT *
FROM v_marek_duda_wages_sector_and_year
WHERE wages_trend = 'DOWN'
ORDER BY wages_diff_percentage;



SELECT *
FROM v_marek_duda_avg_wages_sector_and_year
WHERE payroll_year IN (2006, 2018);

 
SELECT
	new_avg.industry_branch_name
	,new_avg.payroll_year AS new_year
	,new_avg.avg_wages_czk AS new_wages
	,old_avg.payroll_year AS old_year
	,old_avg.avg_wages_czk AS old_wages
	,new_avg.avg_wages_czk - old_avg.avg_wages_czk AS wages_diff_czk
	,round(new_avg.avg_wages_czk * 100 / old_avg.avg_wages_czk, 2) - 100 AS wages_diff_percentage
FROM v_marek_duda_avg_wages_sector_and_year AS new_avg
JOIN v_marek_duda_avg_wages_sector_and_year AS old_avg
	ON new_avg.industry_branch_name = old_avg.industry_branch_name
		WHERE old_avg.payroll_year = 2006 
			AND new_avg.payroll_year = 2018
ORDER BY round(new_avg.avg_wages_czk * 100 / old_avg.avg_wages_czk, 2) - 100 DESC;
-- Největší nárůst mezd byl v odvětví Zdravotní a sociální péče, kde byla v roce 2018 průměrná mzda o 76,9 % vyšší, než v roce 2006.


-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 
-- Kupní síla obyvatel v ČR v letech 2006 a 2018 (mléko + chleba)
SELECT
	food_category
	,price_value
	,price_unit
	,payroll_year
	,round(avg(food_price), 2) AS avg_price
	,round(avg(avg_wages), 2) AS avg_wages
	,round((round(avg(avg_wages), 2)) / (round(avg(food_price), 2))) AS avg_purchase_pow
FROM t_marek_duda_project_SQL_primary_final
WHERE payroll_year IN(2006, 2018)
	AND food_category IN('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
GROUP BY food_category, payroll_year;
-- V roce 2006 bylo za průměrnou cenu chleba 16,12, a průměrnou mzdu 20 753,78 Kč možné koupit 1 287,18 Kg chleba nebo 1 437 l mléka za průměrnou cenu 14,44,-. V roce 2018 bylo za cenu 24,24,- a průměrnou mzdu 32 536,- možné koupit 1 342 Kg chleba nebo 1 642 l mléka za průměrnou cenu 19,82,-.



SELECT
    industry_branch_name
    ,food_category
    ,payroll_year
    ,ROUND(AVG(food_price::numeric), 2) AS avg_price
    ,ROUND(AVG(avg_wages::numeric), 2) AS avg_wages
    ,ROUND(AVG(avg_wages::numeric) / AVG(food_price::numeric), 2) AS avg_purchase_pow
FROM t_marek_duda_project_SQL_primary_final
WHERE payroll_year IN (2006, 2018)
  AND food_category IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
GROUP BY industry_branch_name, food_category, payroll_year;



SELECT
    food_category
    ,price_value
    ,price_unit
    ,payroll_year
    ,ROUND(AVG(food_price::numeric), 2) AS avg_price
    ,ROUND(AVG(avg_wages::numeric), 2) AS avg_wages
    ,ROUND(AVG(avg_wages::numeric) / AVG(food_price::numeric), 2) AS avg_purchase_pow
    ,industry_branch_name
FROM t_marek_duda_project_SQL_primary_final
WHERE payroll_year IN (2006, 2018)
  AND food_category IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
GROUP BY industry_branch_name, food_category, price_value, price_unit, payroll_year
ORDER BY avg_purchase_pow DESC;



-- 3.	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší procentuální meziroční nárůst)?


-- Roční průměrná cena potravin
CREATE OR REPLACE VIEW v_marek_duda_avg_foodprice_by_year AS 
SELECT 	
	food_category
	,price_value AS value
	,price_unit AS unit
	,payroll_year AS year
	,round(avg(food_price::numeric), 2) AS avg_price
FROM t_marek_duda_project_SQL_primary_final
GROUP BY food_category, YEAR, value, unit;

SELECT * FROM v_marek_duda_avg_foodprice_by_year;


-- Trend cen potravin 2006 až 2018
CREATE OR REPLACE VIEW v_marek_duda_food_price AS 
SELECT 
	DISTINCT old_year.food_category
	,old_year.value
	,old_year.unit
	,old_year.year AS old_year
	,old_year.avg_price AS old_price
	,new_year.year AS new_year
	,new_year.avg_price AS new_price 
	,new_year.avg_price - old_year.avg_price AS price_difference_czk
	,round((new_year.avg_price - old_year.avg_price) / old_year.avg_price * 100, 2) AS price_diff_percentage,
	CASE
		WHEN new_year.avg_price > old_year.avg_price
		THEN 'up'
		ELSE 'down'
	END AS price_trend
FROM v_marek_duda_avg_foodprice_by_year AS old_year
JOIN v_marek_duda_avg_foodprice_by_year AS new_year 
	ON old_year.food_category = new_year.food_category
		AND new_year.year = old_year.YEAR +1
ORDER BY food_category, old_year.year;



-- Průměrný meziroční nárůst cen potravin mezi roky 2006-2018
SELECT 
	old_year AS year_from
	,max(new_year) AS year_to
	,food_category
	,round(avg(price_diff_percentage), 2) AS avg_price_growth_in_percent
FROM v_marek_duda_food_price 
GROUP BY food_category, old_year 
ORDER BY round(avg(price_diff_percentage), 2);
-- Cukr krystalový patří mezi potravinové kategorie, jejichž cena se zvyšovala nejméně. Výsledky ukazují, že cena této kategorie se meziročně dokonce snižovala, a to průměrně o -1,92 %. V období od roku 2006 do roku 2018 se průměrná cena za 1 kg cukru postupně zvyšovala a klesala z původních 21,73 Kč v roce 2006, na konečných 15,75 Kč v roce 2018. Na druhé straně, největší meziroční procentuální nárůst byl zaznamenán u paprik. Jejich cena se zvyšovala průměrně  o 7,29 %.


SELECT * FROM v_marek_duda_food_price
ORDER BY price_diff_percentage DESC;

SELECT * FROM v_marek_duda_food_price
ORDER BY price_diff_percentage;


-- Průměrné ceny potravin (porovnání roků 2006 a 2018)
CREATE OR REPLACE VIEW v_marek_duda_food_price_compare_2006_2018 AS 
SELECT 
	old_year.food_category
	,old_year.value
	,old_year.unit
	,old_year.year AS old_year
	,old_year.avg_price AS older_price
	,new_year.year AS new_year
	,new_year.avg_price AS newer_price
	,new_year.avg_price - old_year.avg_price AS price_diff_czk
	,round((new_year.avg_price - old_year.avg_price) / old_year.avg_price *100, 2) AS price_diff_percentage
FROM v_marek_duda_avg_foodprice_by_year AS old_year
JOIN v_marek_duda_avg_foodprice_by_year AS new_year
	ON old_year.food_category = new_year.food_category
		WHERE old_year.year = 2006
			AND new_year.year = 2018;


		
SELECT * FROM v_marek_duda_food_price_compare_2006_2018
ORDER BY price_diff_percentage DESC;



-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 

SELECT * FROM v_marek_duda_avg_wages_sector_and_year;


CREATE OR REPLACE VIEW v_marek_duda_avg_wages_2006_2018 AS 
SELECT 
	industry_branch_name 
	,payroll_year 
	,round(avg(avg_wages_czk)) AS avg_wages_CR_CZK
FROM v_marek_duda_avg_wages_sector_and_year
GROUP BY payroll_year, industry_branch_name;


SELECT * FROM v_marek_duda_avg_wages_2006_2018;



-- Růst mezd v ČR v letech 2006-2018
CREATE OR REPLACE VIEW v_marek_duda_avg_wages_diff_cr_2006_2018 AS 
SELECT
	awcz1.payroll_year AS old_year 
	,awcz1.avg_wages_CR_CZK AS old_wages
	,awcz2.payroll_year AS new_year
	,awcz2.avg_wages_CR_CZK AS new_wages
	,round((awcz2.avg_wages_CR_CZK - awcz1.avg_wages_CR_CZK) / awcz1.avg_wages_CR_CZK * 100, 2) AS avg_wages_diff_percentage
FROM v_marek_duda_avg_wages_2006_2018 AS awcz1
JOIN v_marek_duda_avg_wages_2006_2018 AS awcz2
	ON awcz2.industry_branch_name = awcz1.industry_branch_name 
		AND awcz2.payroll_year = awcz1.payroll_year + 1;


SELECT * FROM v_marek_duda_avg_wages_diff_cr_2006_2018;



-- Půměrné ceny potravin v ČR v letech 2006-2018
CREATE OR REPLACE VIEW v_marek_duda_avg_food_price_cz_2006_2018 AS 
SELECT 
	food_category
	,year
	,round(avg(avg_price), 2) AS avg_food_price_cr_czk
FROM v_marek_duda_avg_foodprice_by_year
GROUP BY YEAR, food_category;

SELECT * FROM v_marek_duda_avg_food_price_cz_2006_2018;


-- Vývoj růstu cen potravin v ČR v letech 2006-2018
CREATE OR REPLACE VIEW v_marek_duda_avg_food_price_diff_CZ_2006_2018 AS
SELECT
	afp1.year AS older_year
	,afp1.avg_food_price_cr_czk AS older_price
	,afp2.year AS newer_year
	,afp2.avg_food_price_cr_czk AS newer_price
	,(afp2.avg_food_price_cr_czk - afp1.avg_food_price_cr_czk) AS price_diff_czk
	,ROUND( (afp2.avg_food_price_cr_czk - afp1.avg_food_price_cr_czk) / afp1.avg_food_price_cr_czk * 100, 2 ) AS price_diff_percentage
FROM v_marek_duda_avg_food_price_cz_2006_2018 AS afp1
	JOIN v_marek_duda_avg_food_price_cz_2006_2018 AS afp2
  	ON afp2.food_category = afp1.food_category
 		AND afp2.year = afp1.year + 1
GROUP BY
  afp1.year
  ,afp1.avg_food_price_cr_czk
  ,afp2.year
  ,afp2.avg_food_price_cr_czk;

SELECT * FROM v_marek_duda_avg_food_price_diff_CZ_2006_2018;





-- 5.   Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?


-- HDP v ČR 2006-2018
CREATE OR REPLACE VIEW v_marek_duda_hdp_CZ_2006_2018 AS 
SELECT * FROM t_marek_duda_project_sql_secondary_final
	WHERE country = 'Czech Republic';

SELECT * FROM v_marek_duda_hdp_CZ_2006_2018;

-- HDP meziroční vývoj
CREATE OR REPLACE VIEW v_marek_duda_hdp_dif_CZ_2006_2018 AS
SELECT
	hdp1.year AS old_year
	,MAX(hdp1.GDP) AS older_gdp
	,MAX(hdp2.year) AS new_year
	,MAX(hdp2.GDP) AS newer_gdp
	,ROUND(
    	AVG( (hdp2.GDP::numeric - hdp1.GDP::numeric) / NULLIF(hdp1.GDP::numeric, 0) ) * 100, 2)::numeric(12,2) AS hdp_diff_percentage
FROM v_marek_duda_hdp_CZ_2006_2018 AS hdp1
	JOIN v_marek_duda_hdp_CZ_2006_2018 AS hdp2
  	ON hdp2.country = hdp1.country
 		AND hdp2.year = hdp1.year + 1
	GROUP BY hdp1.year
	ORDER BY old_year;



SELECT * FROM v_marek_duda_hdp_dif_CZ_2006_2018;


--DROP VIEW v_marek_duda_foodprice_wages_hdp_trend;

-- VIEW Meziroční vývoj Cen potravin, Mezd a HDP v ČR 2006-2018
CREATE OR REPLACE VIEW v_marek_duda_foodprice_wages_hdp_trend AS 
SELECT 
	hdp.old_year 
	,hdp.new_year
	,fpt.older_year
	,fpt.price_diff_percentage 
	,wag.avg_wages_diff_percentage 
	,hdp.hdp_diff_percentage
FROM v_marek_duda_hdp_dif_CZ_2006_2018 AS hdp
	JOIN v_marek_duda_avg_wages_diff_cr_2006_2018 AS wag
		ON wag.old_year = hdp.old_year
	JOIN v_marek_duda_avg_food_price_diff_cz_2006_2018 AS fpt 
		ON fpt.older_year = hdp.old_year;

SELECT * FROM v_marek_duda_foodprice_wages_hdp_trend;



SELECT 
	old_year AS year_from
	,max(new_year) AS year_to
	,round(avg(price_diff_percentage), 2) AS avg_foodprice_growth_trend_percentage
	,round(avg(avg_wages_diff_percentage), 2) AS avg_wages_growth_trend_percentage 
	,round(avg(hdp_diff_percentage), 2) AS avg_hdp_growgh_trend_percentage
FROM v_marek_duda_foodprice_wages_hdp_trend
GROUP BY old_year;


SELECT 
	old_year AS year_from,
	max(new_year) AS year_to,
	round(sum(price_diff_percentage), 2) AS avg_foodprice_growth_trend_percentage, 
	round(sum(avg_wages_diff_percentage), 2) AS avg_wages_growth_trend_percentage, 
	round(sum(hdp_diff_percentage), 2) AS avg_hdp_growgh_trend_percentage
FROM v_marek_duda_foodprice_wages_hdp_trend
GROUP BY old_year;