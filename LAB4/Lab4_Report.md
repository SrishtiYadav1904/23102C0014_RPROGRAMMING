# Lab 4 Report: Advanced Missing Data Handling in R
**Course Practical**: NA, NULL, NaN, Missing-Value Detection and Imputation  
**Dataset**: UCI Census Income (Adult)  
**Submitted By**: Student Group / Workforce Analytics Group  

---

## 1. Introduction and Objectives

When analyzing demographics or employment records, missing data is a very common problem. Sometimes data is just not recorded (causing missing cells), other times people use placeholders like "999" for age, and sometimes there are blank spaces or invalid mathematical operations. 

In this lab, we loaded the UCI Adult dataset (which has 32,561 records and 15 variables) and deliberately injected some of these issues to test different cleaning techniques. Our main tasks were to:
*   Understand the differences between R's missing value representations: `NA`, `NULL`, `NaN`, and `""` (empty string).
*   Spot missing data using basic logical functions and summary tables from the `naniar` package.
*   Write a custom function to fill in missing numbers using the median.
*   Apply different treatments: replacing blank categories with "Unknown", mapping impossible ages to `NA` before imputing them, and filtering out rows with unrecoverable `NaN` values.
*   Verify our cleaned dataset using `skimr::skim()` to ensure no errors remain.

---

## 2. Structural Differences: NA, NULL, NaN, and ""

We learned that R has distinct ways of representing missing or empty data. They might seem similar, but their behavior in code is very different:

*   **`NA` (Not Available)**: This is R's standard logical placeholder for a missing value. It retains the type of vector it resides in (like integer or character) and is what we use inside data frame cells.
*   **`NaN` (Not a Number)**: This is a numeric value that represents undefined math, such as dividing zero by zero. It behaves like `NA` in logical checks, but is strictly numeric.
*   **`NULL`**: Represents the complete absence of an R object or a vector of length 0. You **cannot** put NULL inside a vector or a data frame cell. If you try to assign NULL to a column of a data frame, R will delete the entire column rather than filling the cells with NULL.
*   **`""` (Blank String)**: This is a valid character string that just happens to be empty (length of 1, but contains zero characters). R does not treat this as missing data automatically (so `is.na("")` returns `FALSE`), meaning we have to find and replace it manually.

### Conceptual Code Checks:
*   `is.na(Row 20 Age)` $\rightarrow$ **`TRUE`** (Successfully matched the NA we injected)
*   `is.nan(Row 40 Capital Gain)` $\rightarrow$ **`TRUE`** (Successfully matched the NaN we injected)
*   `is.null(NULL)` $\rightarrow$ **`TRUE`**
*   `is.null(List element set to NULL)` $\rightarrow$ **`TRUE`**
*   `Columns remaining in data frame after setting column to NULL` $\rightarrow$ **`0`** (The column was completely deleted from the table)
*   `Row 30 Workclass == ""` $\rightarrow$ **`TRUE`** (Successfully matched the blank string we injected)
*   `Row 10 Age == 999` $\rightarrow$ **`TRUE`** (Successfully matched the impossible age we injected)

---

## 3. Custom Median-Imputation Function

We wrote a function called `impute_median` to handle missing numeric values. It looks for `NA` and `NaN` entries in a vector, calculates the median of the valid numbers (using `na.rm = TRUE`), replaces the missing spots with that median, and returns the cleaned vector.

```R
impute_median <- function(x) {
  if (!is.numeric(x)) {
    stop("Input must be a numeric vector.")
  }
  missing_mask <- is.na(x) # catches both NA and NaN
  if (any(missing_mask)) {
    med_val <- median(x, na.rm = TRUE)
    x[missing_mask] <- med_val
  }
  return(x)
}
```

---

## 4. Missingness Analysis: Before vs. After

### Before Cleaning:
When we loaded the dataset, we noticed that raw missing values were stored as `?` with leading spaces (e.g. `" ?"`). By setting `strip.white = TRUE` and `na.strings = "?"` in `read.csv()`, we automatically converted them to `NA`. Adding our injected anomalies, the variables with the most missing values were:

| Variable | Missing Count (`n_miss`) | Missing Percentage (`pct_miss`) |
| :--- | :---: | :---: |
| **`occupation`** | 1,843 | 5.66% |
| **`workclass`** | 1,835 | 5.64% |
| **`native_country`** | 583 | 1.79% |
| **`age`** | 3 | 0.0092% |
| **`capital_gain`** | 3 | 0.0092% |

*   **Complete Rows**: 32,552
*   **Incomplete Rows**: 6 (These were our injected `NA` and `NaN` rows)
*   **Plots**: We saved the before-cleaning missingness patterns to [`missingness_before.png`](file:///e:/R%20Programming/missingness_before.png).

### After Cleaning:
After running our cleaning routine, all columns had 0 missing values:

| Variable | Missing Count (`n_miss`) | Missing Percentage (`pct_miss`) |
| :--- | :---: | :---: |
| **`age`** | 0 | 0.00% |
| **`workclass`** | 0 | 0.00% |
| **`fnlwgt`** | 0 | 0.00% |
| ... | 0 | 0.00% |
| **`native_country`** | 0 | 0.00% |
| **`income`** | 0 | 0.00% |

*   **Plots**: We saved the clean missingness distribution pattern to [`missingness_after.png`](file:///e:/R%20Programming/missingness_after.png), showing flat lines (no missing cells remaining).

---

## 5. Interpretation of Results

1.  **Spotting Issues**: The raw dataset had high missingness rates in `occupation` (1,843 rows) and `workclass` (1,835 rows). Our script successfully mapped these along with our injected problems.
2.  **Imputation and Replacing Categoricals**: The impossible age values (999) and injected `NA`s in the `age` variable were mapped to `NA` and filled with the median age of **`37`**. All character columns containing blank strings (`""`) and `NA` entries were replaced with the string `"Unknown"`.
3.  **Removing NaNs**: We decided that the three observations containing `NaN` in `capital_gain` were unrecoverable because `NaN` represents math errors, so we removed those rows from the dataset.
4.  **Final Checks**: Our validation using `skimr::skim()` confirmed that the final cleaned dataset has **32,558 rows and 15 columns**, with no missing cells, blank strings, or impossible age readings remaining.

The final cleaned dataset has been exported successfully to **[`cleaned_adult_data.csv`](file:///e:/R%20Programming/cleaned_adult_data.csv)**.
