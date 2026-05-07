-- ===============================
-- HR ANALYTICS PROJECT
-- ===============================

USE hr_analytics;

-- ===============================
-- TABLE PREPARATION
-- ===============================

-- Rename table (run only once)
RENAME TABLE `untitled spreadsheet - hr_clean_dataset` TO hr_table;

-- Preview data
SELECT * FROM hr_table;

-- ===============================
-- BASIC METRICS
-- ===============================

-- Total Employees
SELECT COUNT(*) AS total_employees
FROM hr_table;

-- Employees who left
SELECT COUNT(*) AS attrition_employee_count
FROM hr_table
WHERE Attrition = 'Yes';

-- Attrition Rate
SELECT 
    CONCAT(
        ROUND(
            (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2),
    '%') AS attrition_Percentage
FROM hr_table;

-- Average Age
SELECT ROUND(AVG(Age)) AS average_age
FROM hr_table;

-- ===============================
-- DISTRIBUTION ANALYSIS
-- ===============================

-- Employees by Department
SELECT Department, COUNT(*) AS employee_count
FROM hr_table
GROUP BY Department
ORDER BY employee_count DESC;

-- Employees by Gender
SELECT Gender, COUNT(*) AS employee_count
FROM hr_table
GROUP BY Gender
ORDER BY employee_count DESC;

-- Employees by Age Group
SELECT AgeGroup, COUNT(*) AS employee_count
FROM hr_table
GROUP BY AgeGroup
ORDER BY employee_count DESC;

-- Employees by Job Role
SELECT JobRole, COUNT(*) AS employee_count
FROM hr_table
GROUP BY JobRole
ORDER BY employee_count DESC;

-- ===============================
-- SALARY ANALYSIS
-- ===============================

-- Average Salary by Department
SELECT Department,
       ROUND(AVG(MonthlyIncome)) AS average_salary
FROM hr_table
GROUP BY Department
ORDER BY average_salary DESC;

-- ===============================
-- ATTRITION ANALYSIS (CORE)
-- ===============================

-- Attrition by Department
WITH total AS (
    SELECT Department, COUNT(*) AS employee_count
    FROM hr_table
    GROUP BY Department
),
left_emp AS (
    SELECT Department, COUNT(*) AS employee_left
    FROM hr_table
    WHERE Attrition = 'Yes'
    GROUP BY Department
)

SELECT 
    total.Department,
    CONCAT(
        ROUND(
            COALESCE(left_emp.employee_left, 0) * 100.0 / total.employee_count, 
        2),
    '%') AS attrition_rate
FROM total
LEFT JOIN left_emp
ON total.Department = left_emp.Department
ORDER BY COALESCE(left_emp.employee_left, 0) * 1.0 / total.employee_count DESC;

-- Attrition by Gender
WITH total AS (
    SELECT Gender, COUNT(*) AS employee_count
    FROM hr_table
    GROUP BY Gender
),
left_emp AS (
    SELECT Gender, COUNT(*) AS employee_left
    FROM hr_table
    WHERE Attrition = 'Yes'
    GROUP BY Gender
)

SELECT 
    total.Gender,
    CONCAT(
        ROUND(
            COALESCE(left_emp.employee_left, 0) * 100.0 / total.employee_count, 
        2),
    '%') AS attrition_rate
FROM total
LEFT JOIN left_emp
ON total.Gender = left_emp.Gender
ORDER BY COALESCE(left_emp.employee_left, 0) * 1.0 / total.employee_count DESC;

-- Attrition by Age Group
WITH total AS (
    SELECT AgeGroup, COUNT(*) AS employee_count
    FROM hr_table
    GROUP BY AgeGroup
),
left_emp AS (
    SELECT AgeGroup, COUNT(*) AS employee_left
    FROM hr_table
    WHERE Attrition = 'Yes'
    GROUP BY AgeGroup
)

SELECT 
    total.AgeGroup,
    CONCAT(
        ROUND(
            COALESCE(left_emp.employee_left, 0) * 100.0 / total.employee_count, 
        2),
    '%') AS attrition_rate
FROM total
LEFT JOIN left_emp
ON total.AgeGroup = left_emp.AgeGroup
ORDER BY COALESCE(left_emp.employee_left, 0) * 1.0 / total.employee_count DESC;

-- Attrition by Job Role
WITH total AS (
    SELECT JobRole, COUNT(*) AS employee_count
    FROM hr_table
    GROUP BY JobRole
),
left_emp AS (
    SELECT JobRole, COUNT(*) AS employee_left
    FROM hr_table
    WHERE Attrition = 'Yes'
    GROUP BY JobRole
)

SELECT 
    total.JobRole,
    CONCAT(
        ROUND(
            COALESCE(left_emp.employee_left, 0) * 100.0 / total.employee_count, 
        2),
    '%') AS attrition_rate
FROM total
LEFT JOIN left_emp
ON total.JobRole = left_emp.JobRole
ORDER BY COALESCE(left_emp.employee_left, 0) * 1.0 / total.employee_count DESC;

-- Attrition by Marital Status
WITH total AS (
    SELECT MaritalStatus, COUNT(*) AS employee_count
    FROM hr_table
    GROUP BY MaritalStatus
),
left_emp AS (
    SELECT MaritalStatus, COUNT(*) AS employee_left
    FROM hr_table
    WHERE Attrition = 'Yes'
    GROUP BY MaritalStatus
)

SELECT 
    total.MaritalStatus,
    CONCAT(
        ROUND(
            COALESCE(left_emp.employee_left, 0) * 100.0 / total.employee_count, 
        2),
    '%') AS attrition_rate
FROM total
LEFT JOIN left_emp
ON total.MaritalStatus = left_emp.MaritalStatus
ORDER BY COALESCE(left_emp.employee_left, 0) * 1.0 / total.employee_count DESC;

-- ===============================
-- SALARY & BENEFITS INSIGHTS
-- ===============================

-- Attrition by Salary Slab
WITH total AS (
    SELECT SalarySlab, COUNT(*) AS employee_count
    FROM hr_table
    GROUP BY SalarySlab
),
left_emp AS (
    SELECT SalarySlab, COUNT(*) AS employee_left
    FROM hr_table
    WHERE Attrition = 'Yes'
    GROUP BY SalarySlab
)

SELECT 
    total.SalarySlab,
    CONCAT(
        ROUND(
            COALESCE(left_emp.employee_left, 0) * 100.0 / total.employee_count, 
        2),
    '%') AS attrition_rate
FROM total
LEFT JOIN left_emp
ON total.SalarySlab = left_emp.SalarySlab
ORDER BY COALESCE(left_emp.employee_left, 0) * 1.0 / total.employee_count DESC;

-- Average Salary (Stayed vs Left)
SELECT 
    Attrition,
    ROUND(AVG(MonthlyIncome), 2) AS average_income
FROM hr_table
GROUP BY Attrition
ORDER BY average_income DESC;

-- Attrition vs Salary Hike
WITH cte AS (
    SELECT 
        PercentSalaryHike,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
        COUNT(*) AS employee_count
    FROM hr_table
    GROUP BY PercentSalaryHike
)

SELECT 
    PercentSalaryHike,
    CONCAT(
        ROUND(attrition_count * 100.0 / employee_count, 2),
    '%') AS attrition_rate
FROM cte
ORDER BY PercentSalaryHike DESC;

-- Attrition vs Stock Option Level
WITH total AS (
    SELECT StockOptionLevel, COUNT(*) AS employee_count
    FROM hr_table
    GROUP BY StockOptionLevel
),
left_emp AS (
    SELECT StockOptionLevel, COUNT(*) AS employee_left
    FROM hr_table
    WHERE Attrition = 'Yes'
    GROUP BY StockOptionLevel
)

SELECT 
    total.StockOptionLevel,
    CONCAT(
        ROUND(
            COALESCE(left_emp.employee_left, 0) * 100.0 / total.employee_count, 
        2),
    '%') AS attrition_rate
FROM total
LEFT JOIN left_emp
ON total.StockOptionLevel = left_emp.StockOptionLevel
ORDER BY COALESCE(left_emp.employee_left, 0) * 1.0 / total.employee_count DESC;

-- ===============================
-- WORK CONDITION ANALYSIS
-- ===============================

-- Work-Life Balance vs Attrition
WITH base AS (
    SELECT 
        CASE 
            WHEN WorkLifeBalance IN (1,2) THEN 'Poor'
            WHEN WorkLifeBalance = 3 THEN 'Average'
            ELSE 'Good'
        END AS balance_category,
        Attrition
    FROM hr_table
)

SELECT 
    balance_category,
    CONCAT(
        ROUND(
            SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2),
    '%') AS attrition_rate
FROM base
GROUP BY balance_category
ORDER BY attrition_rate DESC;

-- Job Satisfaction vs Attrition
SELECT 
    CASE 
        WHEN JobSatisfaction IN (1,2) THEN 'Low'
        WHEN JobSatisfaction = 3 THEN 'Medium'
        ELSE 'High'
    END AS satisfaction_level,

    CONCAT(
        ROUND(
            SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2),
    '%') AS attrition_rate

FROM hr_table
GROUP BY satisfaction_level
ORDER BY attrition_rate DESC;

-- Environment Satisfaction vs Attrition
SELECT 
    CASE 
        WHEN EnvironmentSatisfaction IN (1,2) THEN 'Low'
        WHEN EnvironmentSatisfaction = 3 THEN 'Medium'
        ELSE 'High'
    END AS environment_level,

    CONCAT(
        ROUND(
            SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2),
    '%') AS attrition_rate

FROM hr_table
GROUP BY environment_level
ORDER BY attrition_rate DESC;

With cte_example as 
(SELECT Attrition,
CASE 
  WHEN OverTime = 'Yes' AND MonthlyIncome < 4000 THEN 'High Risk'
  WHEN JobSatisfaction <= 2 THEN 'Medium Risk'
  ELSE 'Low Risk'
END AS RiskLevel
FROM hr_table )
 # Count employees in each risk category
select RiskLevel , 
count(*) as Employee_count 
from cte_example
group by RiskLevel;
# Find how many high-risk employees already left
With cte_example as 
(SELECT Attrition,
CASE 
  WHEN OverTime = 'Yes' AND MonthlyIncome < 4000 THEN 'High Risk'
  
  ELSE 'Low Risk' end as RiskLevel
  from hr_table) 
  select RiskLevel ,
  count(*) Employee_Left
  from cte_example
  where Attrition = 'Yes'
  and RiskLevel = 'High Risk';
  
  # Overtime 
with cte_example as 
(select Attrition , OverTime , 
count(*) as count_Employees
from hr_table
group by OverTime , 
Attrition)
select Attrition , Overtime , 
concat(round((count_Employees / sum(count_Employees) over())* 100 ,2),'%') as percent_employees
from cte_example; 