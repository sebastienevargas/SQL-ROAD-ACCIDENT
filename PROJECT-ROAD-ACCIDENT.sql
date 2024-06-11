--QUESTION ON ACCEDENT IN PROJECT ROAD ACCIDENT

USE [PORTFOLIOCOVID19]

SELECT  * FROM [dbo].[ROAD-ACCIDENT]

--Question2:Identify Accident Hotspots:

----Question1: Where are the most frequent accident locations?
----Objective: Analyze latitude and longitude data to determine high-risk areas.
----Accident Severity Analysis:
SELECT 
	CONCAT([Latitude], [Longitude]) as CITY, 
	 COUNT(*) as 'Number_of_Accident',
	SUM(CASE WHEN Accident_Severity = 'Fatal' THEN 1 ELSE 0 END) AS Fatal_Accidents,
    SUM(CASE WHEN Accident_Severity = 'Serious' THEN 1 ELSE 0 END) AS Serious_Accidents,
    SUM(CASE WHEN Accident_Severity = 'Slight' THEN 1 ELSE 0 END) AS Slight_Accidents

FROM	
	PORTFOLIOCOVID19..[ROAD-ACCIDENT]
Group by
	[Latitude], 
	[Longitude]
ORDER by
	Number_of_Accident DESC
;

----Question2: What factors contribute to severe accidents?
----Objective: Correlate accident severity with factors such as weather conditions, road surface conditions, light conditions, and speed limits.
----Time-Based Accident Trends:
SELECT
    Weather_Conditions,
    Road_Surface_Conditions,
    Light_Conditions,
    Speed_Limit,
    COUNT(*) AS Total_Accidents,
    SUM(CASE WHEN Accident_Severity IN ('Fatal', 'Serious') THEN 1 ELSE 0 END) AS Severe_Accidents,
    SUM(CASE WHEN Accident_Severity IN ('Fatal', 'Serious') THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Severe_Accident_Percentage
FROM
    PORTFOLIOCOVID19..[ROAD-ACCIDENT]
GROUP BY
    Weather_Conditions,
    Road_Surface_Conditions,
    Light_Conditions,
    Speed_Limit
ORDER BY
    Severe_Accident_Percentage DESC;


----Question3: When do most accidents occur?
----Objective: Analyze the data by date, time, day of the week, and month to find peak times for accidents.
----Impact of Weather on Accidents:
--CORRECT by AI
SELECT
    Weather_Conditions,
    COUNT(*) AS Total_Accidents,
    SUM(CASE WHEN DATEPART(HOUR, Time) BETWEEN 6 AND 9 THEN 1 ELSE 0 END) AS Morning_Accidents,
    SUM(CASE WHEN DATEPART(HOUR, Time) BETWEEN 16 AND 19 THEN 1 ELSE 0 END) AS Evening_Accidents,
    SUM(CASE WHEN Day_of_Week IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN 1 ELSE 0 END) AS Weekday_Accidents,
    SUM(CASE WHEN Day_of_Week IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END) AS Weekend_Accidents,
    SUM(CASE WHEN MONTH([Accident Date]) IN (12, 1, 2) THEN 1 ELSE 0 END) AS Winter_Accidents,
    SUM(CASE WHEN MONTH([Accident Date]) IN (6, 7, 8) THEN 1 ELSE 0 END) AS Summer_Accidents
FROM
    PORTFOLIOCOVID19..[ROAD-ACCIDENT]
GROUP BY
    Weather_Conditions
ORDER BY
    Total_Accidents DESC;

---THIS IS MY SOLUTION
SELECT 
    [MONTH],
    [YEAR],	
    [Day_of_Week],
    [Weather_Conditions],
    COUNT(*) AS TOTAL_ACCIDENT,
    SUM(CASE WHEN [Weather_Conditions] = 'Fine no high winds' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Fine_no_high_winds',
    SUM(CASE WHEN [Weather_Conditions] = 'Fine + High winds' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Fine_with_high_winds',
    SUM(CASE WHEN [Weather_Conditions] = 'Fog-mist' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Fog_mist',
    SUM(CASE WHEN [Weather_Conditions] = 'Raining + High winds' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Raining_with_high_winds',
    SUM(CASE WHEN [Weather_Conditions] = 'Raining no high winds' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Raining_no_high_winds',
    SUM(CASE WHEN [Weather_Conditions] = 'Snowing + high winds' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Snowing_with_high_winds',
    SUM(CASE WHEN [Weather_Conditions] = 'Snowing no high winds' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Snowing_no_high_winds',
    SUM(CASE WHEN [Weather_Conditions] = 'Other' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Other'
FROM
	PORTFOLIOCOVID19..[ROAD-ACCIDENT]
GROUP BY 
	[MONTH], [YEAR], [Day_of_Week], [Weather_Conditions]
ORDER BY 
	TOTAL_ACCIDENT DESC
;
----Question4: How do weather conditions affect accident rates?
----Objective: Investigate the relationship between different weather conditions and the number of accidents.
----Casualty Analysis:
SELECT --THIS IS CORRECTED BY AI
    Weather_Conditions,
    COUNT(*) AS Total_Accidents,
    SUM(CASE WHEN Accident_Severity = 'Fatal' THEN 1 ELSE 0 END) AS Fatal_Accidents,
    SUM(CASE WHEN Accident_Severity = 'Serious' THEN 1 ELSE 0 END) AS Serious_Accidents,
    SUM(CASE WHEN Accident_Severity = 'Slight' THEN 1 ELSE 0 END) AS Slight_Accidents,
    AVG(Number_of_Casualties) AS Average_Casualties_Per_Accident
FROM
    PORTFOLIOCOVID19..[ROAD-ACCIDENT]
GROUP BY
    Weather_Conditions
ORDER BY
    Total_Accidents DESC;

SELECT --my SOLUTION
	[Weather_Conditions],
    COUNT(*) AS TOTAL_ACCIDENT,
    SUM(CASE WHEN [Weather_Conditions] = 'Fine' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Fine_Condition',
    SUM(CASE WHEN [Weather_Conditions] = ('High winds''No High winds') THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Wind Condition',
    SUM(CASE WHEN [Weather_Conditions] = 'Fog-mist' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Fog_mist',
    SUM(CASE WHEN [Weather_Conditions] = 'Raining ' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'RainingWeather',
    SUM(CASE WHEN [Weather_Conditions] = 'Snowing ' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'SnowingWeather',
    SUM(CASE WHEN [Weather_Conditions] = 'Other' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'Other'
FROM
	PORTFOLIOCOVID19..[ROAD-ACCIDENT]
GROUP BY 
	 [Weather_Conditions]
ORDER BY 
	TOTAL_ACCIDENT DESC

----Question5: What is the average number of casualties per accident?
----Objective: Calculate the average number of casualties in accidents to understand the typical impact.
----Vehicle Involvement:
--AI SOLUTION
SELECT
    Vehicle_Type,
    COUNT(*) AS Total_Accidents,
    SUM(Number_of_Casualties) AS Total_Casualties,
    AVG(Number_of_Casualties) AS Average_Casualties_Per_Accident
FROM
    PORTFOLIOCOVID19..[ROAD-ACCIDENT]
GROUP BY
    Vehicle_Type
ORDER BY
    Total_Accidents DESC;

--my SOLUTION
SELECT Vehicle_Type, Road_Type, COUNT(*) as 'PerACCIDENT', AVG(Number_of_Casualties) as Average_Casualties
From PORTFOLIOCOVID19..[ROAD-ACCIDENT]
Group BY 
	Vehicle_Type,
	Road_Type
ORDER by 'Average_casualties' DESC
;
----Question6: What types of vehicles are most frequently involved in accidents?
----Objective: Analyze the types of vehicles involved in accidents to identify which ones are most common.
----Urban vs. Rural Accident Comparison:
--AI SOLUTION
SELECT
    Urban_or_Rural_Area,
    Vehicle_Type,
    COUNT(*) AS Total_Accidents,
    SUM(Number_of_Casualties) AS Total_Casualties,
    AVG(Number_of_Casualties) AS Average_Casualties_Per_Accident
FROM
    PORTFOLIOCOVID19..[ROAD-ACCIDENT]
GROUP BY
    Urban_or_Rural_Area,
    Vehicle_Type
ORDER BY
    Urban_or_Rural_Area, Total_Accidents DESC;
--MY SOLUTION
SELECT [Vehicle_Type], [Urban_or_Rural_Area], COUNT(*) AS total_ACCIDENT
FROM PORTFOLIOCOVID19..[ROAD-ACCIDENT]
GROUP BY 
	[Vehicle_Type],
	[Urban_or_Rural_Area]
ORDER BY total_ACCIDENT DESC
;
----Question7: Are accidents more frequent in urban or rural areas?
----Objective: Compare the number of accidents in urban and rural areas to understand where accidents are more common.
----Influence of Junction Control and Detail:
-- AI SOLUTION
SELECT
    Urban_or_Rural_Area,
    Junction_Control,
    Junction_Detail,
    COUNT(*) AS Total_Accidents,
    SUM(Number_of_Casualties) AS Total_Casualties,
    AVG(Number_of_Casualties) AS Average_Casualties_Per_Accident
FROM
    PORTFOLIOCOVID19..[ROAD-ACCIDENT]
GROUP BY
    Urban_or_Rural_Area,
    Junction_Control,
    Junction_Detail
ORDER BY
    Total_Accidents DESC;

--MY SOLUTION
SELECT [Vehicle_Type], 
	[Urban_or_Rural_Area], 
	[Junction_Detail],[Junction_Control], 
	COUNT(*) AS 'total_ACCIDENT'
FROM PORTFOLIOCOVID19..[ROAD-ACCIDENT]

GROUP BY 
	[Vehicle_Type],
	[Urban_or_Rural_Area],
	[Junction_Control],
	[Junction_Detail]
ORDER BY total_ACCIDENT DESC
;
----Question8: How does junction control and detail influence accident occurrences?
----Objective: Assess the role of different types of junction controls and details in the frequency and severity of accidents.
--AI SOLUTION
SELECT
    Junction_Control,
    Junction_Detail,
    COUNT(*) AS Total_Accidents,
    SUM(Number_of_Casualties) AS Total_Casualties,
    AVG(Number_of_Casualties) AS Average_Casualties_Per_Accident,
    SUM(CASE WHEN Accident_Severity = 'Fatal' THEN 1 ELSE 0 END) AS Fatal_Accidents,
    SUM(CASE WHEN Accident_Severity = 'Serious' THEN 1 ELSE 0 END) AS Serious_Accidents,
    SUM(CASE WHEN Accident_Severity = 'Slight' THEN 1 ELSE 0 END) AS Slight_Accidents
FROM
    PORTFOLIOCOVID19..[ROAD-ACCIDENT]
GROUP BY
    Junction_Control, Junction_Detail
ORDER BY
    Total_Accidents DESC;


--MY SOLUTION
SELECT [Junction_Control], [Junction_Detail], COUNT(*) as Total_Accident,
	SUM(CASE WHEN [Accident_Severity] IN ('Fatal', 'Serious') THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Severe_Accident_Percentage

FROM PORTFOLIOCOVID19..[ROAD-ACCIDENT]
GROUP BY
	[Junction_Control], 
	[Junction_Detail]
ORDER BY 
	Total_Accident DESC
;