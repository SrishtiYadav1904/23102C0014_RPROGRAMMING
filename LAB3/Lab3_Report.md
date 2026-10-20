# Lab 3 Report: Control Flow for Data Cleaning in R
**Course Practical**: Loops, Functions, and Error Handling  
**Dataset**: UCI Heart Disease (Cleveland)  
**Submitted By**: Student Group / Healthcare Analytics Group  

---

## 1. Objectives of the Lab

When we get clinical data from different hospitals or clinics, it is almost never clean. It usually has typos, missing entries, or values that are physically impossible. If we run statistical tests or train models on this raw data, the results will be skewed. 

In this lab, we worked with the resting blood pressure (`trestbps`) variable from the Cleveland heart database. Our main goals were to:
*   Load the dataset and intentionally inject anomalies like negative values, missing data, and extreme outliers.
*   Write a function to clean up these values using standard if-else rules.
*   Set up error handling with `tryCatch()` to safely run calculations (like mean and ratios) without crashing the script.
*   Benchmark a standard for-loop against vectorized methods in R to see the performance differences at scale.
*   Export our cleaned dataset and verify that it matches our rules.

---

## 2. Ingesting the Data and Creating Anomalies

We downloaded the Cleveland dataset directly from the UCI Machine Learning Repository. Since the raw file does not have a header, we assigned the standard 14 column names. R read the `?` characters as `NA` values.

To test our data-cleaning code, we deliberately injected the following errors at specific index positions in the `trestbps` column:
*   **Negatives**: Rows 10, 50, and 100 were changed to `-120`, `-95`, and `-110`.
*   **Missing Values**: Rows 20, 120, and 220 were set to `NA`.
*   **Outliers**: Rows 30, 130, and 230 were set to extreme values (`310`, `360`, and `420`).
*   **Division Test**: Row 15 was set to `0` so we could test our division error handling.

---

## 3. Creating the Cleaning Functions

We wrote a scalar cleaning function using basic `if-else` blocks and then created three ways to apply it to a vector:
1.  **For-Loop**: We iterated through the elements one by one, checked their values, and modified them.
2.  **Logical Indexing**: A vectorized method where we matched indices matching our conditions and changed them in-place.
3.  **Nested ifelse()**: R's built-in vectorized condition checks.

### Cleaning Rules:
*   Blood pressure values $\le 0$ are converted to `NA`.
*   Systolic values $> 250$ are capped at `250`.
*   All valid values remain unchanged.

```R
# Scalar cleaning function
clean_bp_scalar <- function(x) {
  if (is.na(x)) {
    return(NA)
  } else if (x <= 0) {
    return(NA)
  } else if (x > 250) {
    return(250)
  } else {
    return(x)
  }
}

# 1. Loop implementation
clean_bp_loop <- function(vec) {
  cleaned <- numeric(length(vec))
  for (i in seq_along(vec)) {
    cleaned[i] <- clean_bp_scalar(vec[i])
  }
  return(cleaned)
}

# 2. Vectorized implementation (Logical Indexing)
clean_bp_vectorized <- function(vec) {
  cleaned <- vec
  cleaned[!is.na(cleaned) & cleaned <= 0] <- NA
  cleaned[!is.na(cleaned) & cleaned > 250] <- 250
  return(cleaned)
}
```

---

## 4. Setting up tryCatch() Exception Handling

R scripts will terminate if they hit an error like a division by zero or a type mismatch. To make our data cleaning pipeline robust, we used `tryCatch()` to capture warnings and errors and return safe fallbacks.

### A. Calculating the Mean Safely
If the BP vector contains `NA` values, standard R math functions can return `NA`. In our custom function, we look for `NA`s, trigger a warning, catch that warning, and recalculate the mean using `na.rm = TRUE`.
*   **Result**: When we ran this on our vector, R caught the warning and printed:
    `[WARNING CAPTURED] in safe_mean_bp(): Missing values (NA) detected in BP vector. Computing mean with na.rm = TRUE.`
*   **Mean Output**: **131.18 mmHg**

### B. Safe Ratio Calculation (`chol / trestbps`)
We wrote a function to calculate the cholesterol-to-blood pressure ratio. It checks for missing values, non-numeric data types, zero denominators, and negative denominators, printing a warning/error message and returning `NA` rather than crashing the script.

### Captured Outputs during Testing:
*   **Row 1 (Normal)**: `233` chol / `145` BP $\rightarrow$ Returns **`1.606897`** (No issues).
*   **Row 15 (Zero Denominator)**: Captured Error: `Denominator (trestbps) is zero. Division by zero is undefined.` $\rightarrow$ Returns **`NA`**.
*   **Row 10 (Negative Denominator)**: Captured Error: `Denominator (trestbps = -120) is negative and invalid.` $\rightarrow$ Returns **`NA`**.
*   **Row 20 (Missing Denominator)**: Captured Warning: `Missing values detected (chol = 266, trestbps = NA). Returning NA.` $\rightarrow$ Returns **`NA`**.
*   **Row 999 (Non-numeric Input)**: Captured Error: `Inputs must be numeric. Received chol: character, trestbps: numeric` $\rightarrow$ Returns **`NA`**.

---

## 5. Benchmarking Loop vs. Vectorized Cleaning

Since 303 rows execute too quickly to measure, we replicated the blood pressure column **10,000 times** to create a vector of **3,030,000 elements**. We timed the runs using `system.time()`.

### Timing Summary (3,030,000 Elements):
*   **For-Loop Time**: **1.45 seconds**
*   **Vectorized (ifelse)**: **0.34 seconds**
*   **Vectorized (Logical Indexing)**: **0.11 seconds**

### Performance Gains:
*   Logical indexing was **13.18x faster** than the for-loop.
*   Logical indexing was **3.09x faster** than nested `ifelse()`.

### Analysis:
R is an interpreted vector language. Every time a standard `for` loop runs, R has to check variable types, resolve symbols, and evaluate conditions in the interpreter. This causes massive slowdowns. 
Vectorized operations (like logical indexing) bypass this interpreter loop. They pass the memory pointer directly to pre-compiled C/Fortran code, processing the entire array in a single operation. Additionally, logical indexing modifies the array in-place, making it much faster than `ifelse()`, which builds separate vectors for the true/false paths before merging them.

---

## 6. Cleaned Data Validation

We applied our vectorized cleaning code to the dataset. We verified our work by checking the specific rows we injected with errors and compiling final statistics.

### Injected Row Checks:
*   **Row 10** (Original: `-120` mmHg) $\rightarrow$ Cleaned to: **`NA`** (Correctly removed negative value)
*   **Row 15** (Original: `0` mmHg) $\rightarrow$ Cleaned to: **`NA`** (Correctly removed zero value)
*   **Row 20** (Original: `NA`) $\rightarrow$ Cleaned to: **`NA`** (Retained missing value)
*   **Row 30** (Original: `310` mmHg) $\rightarrow$ Cleaned to: **`250`** (Capped at maximum limit)
*   **Row 130** (Original: `360` mmHg) $\rightarrow$ Cleaned to: **`250`** (Capped at maximum limit)

### Statistics of Cleaned BP (`trestbps`):
*   **Total Missing (NA) values**: **7** (Original had 0. We added 3 NAs, 3 negatives, and 1 zero, all of which successfully mapped to `NA`).
*   **Minimum BP**: **94 mmHg** (All negative and zero values removed).
*   **Maximum BP**: **250 mmHg** (All extreme values capped at 250).
*   **Mean BP**: **132.90 mmHg**
*   **Median BP**: **130.00 mmHg**

All constraints were satisfied: there are no negative values, zero values, or values above 250 remaining. The final output is written to `cleaned_heart_data.csv`.
