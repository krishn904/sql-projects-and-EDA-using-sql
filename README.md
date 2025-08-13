# 📊 Global Layoffs Analysis — SQL + Power BI

## 📌 Project Overview
This project focuses on cleaning, analyzing, and visualizing global layoff data using **SQL** for preprocessing and **Power BI** for dashboard creation.

---

## 🛠 Tools & Technologies
- **SQL (MySQL)** — Data cleaning & transformation
- **Power BI** — Data visualization & dashboarding

---

## 📂 Dataset
The dataset contains company layoffs information with fields such as:
- Company
- Location
- Industry
- Total laid off
- Percentage laid off
- Date
- Stage
- Country
- Funds raised

---

## 🔄 Data Cleaning Steps in SQL
Key operations performed:
1. **Remove Duplicates** using `ROW_NUMBER()` and `DELETE`.
2. **Standardize Text** — Trim spaces, unify case, correct industry/country names.
3. **Convert Date Formats** — `STR_TO_DATE()` and proper `DATE` data type.
4. **Handle Missing Values** — Fill missing `industry` using other records for the same company.
5. **Remove Null Records** — Dropped rows where both `total_laid_off` and `percentage_laid_off` were null.

Example snippet:
```sql
UPDATE layoff_statiging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

DELETE FROM layoff_statiging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


The data set used can be found here:-
https://github.com/krishn904/sql-projects-and-EDA-using-sql/blob/main/layoffs.csv


