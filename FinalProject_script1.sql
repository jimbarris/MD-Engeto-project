

-- Tabulky cen potravin a průměrných mezd mají společné roky 2006 - 2018

CREATE OR REPLACE TABLE t_marek_duda_project_SQL_primary_final AS
SELECT
	cp.value AS price
	,cp.date_from
	,cp.date_to
	,cpay.payroll_year
	,cpay.value AS avg_wages
	,cpc.name AS food_category
	,cpc.price_value
	,cpc.price_unit
	,cpib.name AS industry_branch_name
FROM czechia_price AS cp
	JOIN czechia_payroll AS cpay 
		ON YEAR(cp.date_from) = cpay.payroll_year
		AND cpay.value_type_code = 5958
		AND cp.region_code IS NULL	
	JOIN czechia_price_category AS cpc 
		ON cp.category_code = cpc.code 
	JOIN czechia_payroll_industry_branch AS cpib 
		ON cpay.industry_branch_code = cpib.code;

-- Select do nově vytvořené tabulky FINAL1 pro kontrolu.

SELECT * FROM t_marek_duda_project_SQL_primary_final;
