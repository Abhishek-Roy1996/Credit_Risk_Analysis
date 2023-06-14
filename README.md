# Credit_Risk_Analysis

The dataset has performance tags in the form of whether a person defaulted the loan or not.
We are using other attributes available to find the segment of customers who have higher probability of defaulting on their loan.
There are 10 such variables available in the given dataset out of which 3 variables are of string datatype and 7 are of integer datatype.
The base default rate of the entire population is 21%.

Objective  Using historical data, identify segments of population that are risky than the average/base default rate. In other words, to find the subset of the population whose default rate is significantly higher than the base default rate.

For continuous variables, using percentile distribution (ntile function) to differentiate between default and non-default from population (default-1, non-default-0). This will help us to find trends in the data.
We want to find a threshold value to identify the part of the population where risk is significantly elevated.
For categorical variables, finding out default rate in each categories to see whether any particular category has more risk. 
After analysing each variable, shortlisting some of the variables for final analysis.
Using combination of thresholds/categories and business sense to identify a population that has higher chance to default. 

