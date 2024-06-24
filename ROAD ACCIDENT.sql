SELECT * FROM road_accident

--•	Total Casualties for year 2022
SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'

--•	Total Casualties for Dry season
SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND road_surface_conditions = 'Dry'

--•	Total Casualties for fatal accidents
SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Fatal'

--•	Total Serious casualties
SELECT SUM(number_of_casualties) AS CY_Serious_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Serious'

--•	Total Accidents with Slight Casualties
SELECT SUM(number_of_casualties) AS CY_Slight_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Slight'

--•	Total Number of casualties by different vehicles
SELECT 
    CASE
	    WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultutral'
		WHEN vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and upto 500cc','Motorcycle over 500cc','Pedal cycle') THEN 'Bike'
		WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus(8 - 16 passenger seats') THEN 'Bus'
		WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and 7.5t.','Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
		ELSE 'Other'
		END As vehicle_group,
		SUM(number_of_casualties) as CY_Casualties
		FROM road_accident
		WHERE YEAR(accident_date)= '2022'
		GROUP BY 
		CASE
		   WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultutral'
		WHEN vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and upto 500cc','Motorcycle over 500cc','Pedal cycle') THEN 'Bike'
		WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus(8 - 16 passenger seats') THEN 'Bus'
		WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and 7.5t.','Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
		ELSE 'Other'
		END

--•	Total number of casualties month wise for year 2022
SELECT DATENAME(MONTH, accident_date) AS Month_Name, SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY DATENAME(MONTH,accident_date)

--•	Total number of casualties month wise for year 2021
SELECT DATENAME(MONTH, accident_date) AS Month_Name, SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2021'
GROUP BY DATENAME(MONTH,accident_date)

--•	Casualties by Road type
SELECT road_type, SUM(number_of_casualties) As CY_Casualties FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY road_type

--•	Number of casualties area wise
SELECT urban_or_rural_area, SUM(number_of_casualties) FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY urban_or_rural_area

--•	Percentage of casualties area wise
SELECT urban_or_rural_area, SUM(number_of_casualties)*100/
(SELECT SUM(number_of_casualties) FROM road_accident WHERE YEAR(accident_date) = '2022')
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY urban_or_rural_area

--•	Casualties by Light condition
SELECT 
        CASE
		     WHEN light_conditions IN ('Daylight') THEN 'Day'
			 WHEN light_conditions IN ('Darkness - lightning unknown','Darkness - lights lit','Darkness - lights unlit', 'Darkness - no lightning') THEN 'Night'
			 END AS Light_Condition
			 CAST(CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100 /
			 (SELECT CAST(SUM(number_of_casualties) AS DECIMAL (10,2)) FROM road_accident 
			 WHERE YEAR(accident_date) = '2022') AS DECIMAL(10,2))
			 AS CY_Casualties_PCT
			 FROM road_accident
			 WHERE YEAR(accident_date) = '2022'
			 GROUP BY
			 CASE
			          WHEN light_conditions IN ('Daylight') THEN 'Day'
					  WHEN light_conditions IN('Darkness - lightning unknown','Darkness = lights lit', 'Darkness - lights unlit', 'Darkness - no lightning') THEN 'Night'
					  END

--•	Number of casualties distribution in local authority
SELECT local_authority, SUM(number_of_casualties) AS Total_Casualties
FROM road_accident
GROUP BY local_authority 
ORDER BY Total_Casualties DESC
