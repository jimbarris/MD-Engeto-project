-- TABLE 2 - Dodatečná data o dalších evropských státech (období 2006–2018) 


CREATE OR REPLACE TABLE t_marek_duda_project_SQL_secondary_final AS 
SELECT 
	c.country
	,e.year
	,e.population 
	,e.gini
	,e.gdp	
FROM countries AS c
	JOIN economies AS e ON e.country = c.country
		WHERE c.continent = 'Europe'
			AND e.year BETWEEN 2006 AND 2018
		ORDER BY c.country, e.year;


-- Select do nově vytvořené tabulky FINAL2 pro kontrolu.

SELECT 
	* 
FROM t_marek_duda_project_SQL_secondary_final;