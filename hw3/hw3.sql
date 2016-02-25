-----------------------------------------HW3 by Sam Yuxiao Sun---------------------------------------------

--Question 1: Handlers Exploration
--The hhandler table contains registration forms for hazardous waste handlers. See the data dictionary here.

--(a) How many forms have been received by the EPA?
SELECT count(*) as forms_total
FROM hhandler;

--(b) How many facilities have registered? Hint: use the count(distinct ) function
--Here I interpret a facility as a handler
SELECT count(distinct epa_handler_id) as handlers_total
FROM hhandler;

--(c) How many forms were received per year over the last 5 years?
--I am using data for year 2011-2015
--Use extract function to get the year
SELECT extract(year from receive_date) as year, count(*) as count
FROM hhandler
WHERE receive_date between '2011-01-01' and '2015-12-31' 
GROUP BY 1
ORDER BY 1;

--Question 2: Evaluations
--The cmecomp3 table contains a list of evaluations (inspections) of these handlers. See thedata dictionary here.
--Below I treat each row as a distint evaluation

--(a) How many evaluations are there?
SELECT count(*)
FROM cmecomp3;

--(b) How many evaluations found violations?
SELECT count(*)
FROM cmecomp3
WHERE found_violation_flag = 'Y';

--(c) What proportion of evaluations found violations?
SELECT sum((found_violation_flag='Y')::int):float/count(*)
from cmecomp3;

--(d) Which five handler_ids have been found in violation the most times? How many times? Also find these handlers' site names in the hhandlers table.
--Aggregate by handler_id, and save in a temp table
CREATE temp table h as (
SELECT count(*) as count, handler_id
FROM cmecomp3
WHERE found_violation_flag = 'Y'
GROUP BY handler_id
ORDER BY count DESC
LIMIT 5
);
--Join tables to retrieve site name, use grouping to avoid repetition
SELECT h.handler_id, hhandler.current_site_name
FROM h
LEFT JOIN hhandler
ON h.handler_id=hhandler.epa_handler_id
GROUP BY h.handler_id, hhandler.current_site_name

--Question 3: Industries
--The North American Industry Classification System is a system used by federal agencies to classify a business according to its industry. The naics table contains this information as retrieved from here. Start by skimming this file.

--(a) How many different naics codes are there? How many six-digit industry classifications are there? How many two-digit classifications are there? These determine the sectors as described here.
SELECT count(distinct naics) as codes_total
FROM naics;

SELECT count(*) as codes_six_digit
FROM naics
WHERE naics similar to '\d{6}';

--it is observable that the two-digit codes start with numbers followed by '-' (should not use ----, since some sectors have pattern dd----/)
SELECT count(*) as codes_two_digit
FROM naics
WHERE naics similar to '\d{2}-%';

--(b) The hnaics table contains naics codes for some handlers. How many handlers have naics codes? How many don't?
SELECT count(distinct epa_handler_id) as handlers_with_codes
FROM hnaics
WHERE naics_code is not null;

SELECT count(distinct epa_handler_id) as handlers_total
FROM hhandler;

SELECT 856529::int-438053 as handlers_no_codes

--(c) Join the hnaics table with the naics table and use a GROUP BY to determine which the number of facilities in each sector. Which sector has the most hazardous-waste handlers? The least?
CREATE temp table h2 as(
SELECT substring(naics_code for 2) || '----' as hnaics2, epa_handler_id
FROM hnaics
);
--Select only sector-level data from naics. I use substring command again to unify the form of nacis codes, otherwise it will only return 16 sectors after 'Join'.
CREATE temp table n2 as(
SELECT substring(naics for 2) || '----' as naics2, naics_description
FROM naics
WHERE naics similar to '\d{2}-%'
);
--Finaly join them together, count only the distinct handler ids within each sector
SELECT n2.naics_description as sector, count(distinct h2.epa_handler_id) as handlers_number
FROM h2
LEFT JOIN n2
ON h2.hnaics2=n2.naics2
WHERE n2.naics_description is not null
GROUP BY n2.naics_description
ORDER BY handlers_number DESC

--(d) Create a temporary table called hsectors containing unique pairs of handler ids and sector descriptions.
CREATE temp table hsectors as(
SELECT h2.epa_handler_id as handler_id, n2.naics_description as sector_description
FROM h2
LEFT JOIN n2
ON h2.hnaics2=n2.naics2
GROUP BY n2.naics_description, h2.epa_handler_id
);
--
--(e) Join hsectors to cmecomp3, to determine for each sector, the number of handlers evaluated, the number of evaluations, the number of violations, and the proportion of evaluations finding violations. Which sector has the most violations? The highest proportion of evaluations finding violations? 
CREATE temp table sector1 as(
SELECT hsectors.sector_description, 
       count(distinct cmecomp3.handler_id) as handlers_evaluated, 
       count(*) as evaluations_total 
FROM cmecomp3
LEFT JOIN hsectors
ON cmecomp3.handler_id=hsectors.handler_id
GROUP BY hsectors.sector_description 
);
--Since found_violation_flag is a string, I need another algorithm to calculate violations_total.
CREATE temp table sector2 as(
SELECT hsectors.sector_description, count(cmecomp3.found_violation_flag) as violations_total 
FROM cmecomp3
LEFT JOIN hsectors
ON cmecomp3.handler_id=hsectors.handler_id
WHERE cmecomp3.found_violation_flag='Y'
GROUP BY hsectors.sector_description 
);
--Combine the two temp tables above we can get the main variables of interests
CREATE temp table sector as(
SELECT sector1.sector_description as sectors, sector1.handlers_evaluated, sector1.evaluations_total, sector2. violations_total
FROM sector1
LEFT JOIN sector2
ON sector1.sector_description=sector2.sector_description
WHERE sector1.sector_description is not null
);
--Use division to get proportion, use order by to find the sector with most violations
SELECT sectors, handlers_evaluated, evaluations_total, violations_total, violations_total::float/evaluations_total as violations_proportion
FROM sector
ORDER BY violations_total DESC
--Use another order by to find the sector with the highest proportion of violations
SELECT sectors, handlers_evaluated, evaluations_total, violations_total, violations_total::float/evaluations_total as violations_proportion
FROM sector
ORDER BY violations_proportion DESC
