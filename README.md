# [Solving UW Math Summer Scheduling Problem](https://mathsummerproject.github.io/MathSummerScheduling/)

Scheduling non-major summer courses for MATH 381 group project at UW

## Team members Info
- Yanmeng (Anny) Kong [@Annykong](https://github.com/AnnyKong)
- Lini Cai [@cai20170929](https://github.com/cai20170929)

## Scripts Info
- R scripts for diagrams
- Python scripts are mostly for creating tables with two steps:
  
### Read csv data
- read csv
- generate a dictionary for storing all necessary data

### Generate customized table
An example of Math 120 table would look like the following:
```
Math 120
  year  Percent. Enrollment sec 1    Percent. Enrollment sec 2    Percent. Enrollment sec 3
------  ---------------------------  ---------------------------  ---------------------------
  2008  57.14(1050✓)                 71.43(940✓)                  77.14(1200✓)
  2009  72.00(1050✓)                 88.00(940✗)                  104.00(1200✗)
  2010  60.00(1200✓)                 74.29(1050✓)
  2011  85.71(1050✗)                 97.14(1200✗)
  2012  42.86(1050✗)                 74.29(1200✓)                 80.00(940✓)
  2013  62.86(1050✓)                 63.33(1200✓)
  2014  28.57(1050✗)                 74.29(1200✓)
  2015  91.43(1200✗)
  2016  85.71(1200✗)
  2017  88.57(1200✗)
  2018  100.00(1200✗)
```
Notes: 
- - check mark(✓) if the percentage within the preferred range (57% - 80%)
  - cross mark(✗) otherwise
  
- `(1050✓)` means 
  - the class was scheduled at 1050am;
  - and the percentage of enrollment is in the preferred range.
  

## Output files (better open with firefox)
  - `data.json` gives 
  
    ```
    course num -> year -> percentage of enrollment
    ```
    which is dict -> dict-> list
    
    - i.e.
    <p align="center">
      <img src="data/data-example.png" width="250" height="450" alt="accessibility text">
    </p>
  
  - `data2.json` gives
  
    ```
    course num -> year -> time -> percentage of enrollment
    ```
    which is dict -> dict -> dict -> list
    
    - i.e.
    <p align="center">
      <img src="data/data2-example.png" width="250" height="450" alt="accessibility text">
    </p>
    
## Command line Outputs

  - i.e.
  ```
  Math 124
    year  Percent. Enrollment sec 1    Percent. Enrollment sec 2    Percent. Enrollment sec 3    Percent. Enrollment sec 4
  ------  ---------------------------  ---------------------------  ---------------------------  ---------------------------
    2008  51.42857143(✗)               62.85714286(✓)               77.14285714(✓)
    2009  40(✗)                        62.85714286(✓)               71.42857143(✓)               85.71428571(✗)
    2010  57.14285714(✓)               71.42857143(✓)               74.28571429(✓)               94.28571429(✗)
    2011  53.33333333(✗)               70(✓)                        76.66666667(✓)               80(✓)
    2012  77.14285714(✓)               85.71428571(✗)               91.42857143(✗)               100(✗)
    2013  25.71428571(✗)               54.28571429(✗)               57.14285714(✓)               71.42857143(✓)
    2014  34.28571429(✗)               48.57142857(✗)               65.71428571(✓)               88.57142857(✗)
    2015  46.66666667(✗)               73.33333333(✓)               76.66666667(✓)               76.66666667(✓)
    2016  80(✓)                        85.71428571(✗)               88.57142857(✗)
    2017  45.71428571(✗)               82.85714286(✗)               85.71428571(✗)
    2018  51.42857143(✗)               57.14285714(✓)               57.14285714(✓)
  ```
    

  - i.e.
  ```
  Math 124
  year  Percent. Enrollment sec 1    Percent. Enrollment sec 2    Percent. Enrollment sec 3    Percent. Enrollment sec 4
------  ---------------------------  ---------------------------  ---------------------------  ---------------------------
  2008  51.43(110✗)                  62.86(940✓)                  77.14(1200✓)
  2009  40.00(110✗)                  62.86(940✓)                  71.43(1200✓)                 85.71(1050✗)
  2010  57.14(1050✓)                 71.43(940✓)                  74.29(1200✓)                 94.29(110✗)
  2011  53.33(110✗)                  70.00(940✓)                  76.67(1050✓)                 80.00(1200✓)
  2012  77.14(110✓)                  85.71(1050✗)                 91.43(1200✗)                 100.00(940✗)
  2013  25.71(110✗)                  54.29(1050✗)                 57.14(1200✓)                 71.43(940✓)
  2014  34.29(940✗)                  48.57(1050✗)                 65.71(110✓)                  88.57(1200✗)
  2015  46.67(110✗)                  73.33(940✓)                  76.67(1050✓)                 76.67(1200✓)
  2016  80.00(1050✓)                 85.71(110✗)                  88.57(940✗)
  2017  45.71(110✗)                  82.86(1050✗)                 85.71(940✗)
  2018  51.43(1200✗)                 57.14(940✓)                  57.14(1050✓)
  ```
