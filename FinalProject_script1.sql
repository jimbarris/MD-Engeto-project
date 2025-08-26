
 -- TABLE1 (data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) 


-- Tabulky cen potravin a průměrných mezd mají společné roky 2006 - 2018
CREATE TABLE IF NOT EXISTS t_marek_duda_project_SQL_primary_final as
 SELECT 
	cp.value food_price 
	,cp.date_from
	,cp.date_to
	,cpay.payroll_year
	,cpay.value avg_wages
	,cpc.name AS food_category
	,cpc.price_value
	,cpc.price_unit
	,cpib.name industry_branch_name
FROM czechia_price cp
JOIN czechia_payroll cpay 
	ON date_part('year', cp.date_from) = cpay.payroll_year
	AND cpay.value_type_code = 5958
	AND cp.region_code IS NULL
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code 
JOIN czechia_payroll_industry_branch cpib 
	ON cpay.industry_branch_code = cpib.code;

-- Select do nově vytvořené tabulky FINAL1 pro kontrolu.

SELECT 
	* 
FROM t_marek_duda_project_SQL_primary_final
ORDER BY date_from, food_category;