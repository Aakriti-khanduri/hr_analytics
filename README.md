# hr_analytics
## 📊 Project Overview
This project analyzes employee attrition using SQL and Power BI to identify key factors influencing employee turnover.

## 🔍 Key Insights
- Overall attrition rate: 16.16%
- Highest attrition in Sales department
- Young employees (18–25) show higher attrition
- Salary impacts attrition but is not the main factor
- Combination of low salary + overtime leads to 50%+ attrition
- Job satisfaction and environment are key drivers

## 🧠 Tools Used
- SQL

## 📌 Key Query Example
```sql
SELECT Department,
ROUND(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 END)/COUNT(*),2) AS attrition_rate
FROM hr_data
GROUP BY Department;
