## Input DB
PhoneRates, Places, Calls

## To analyze
Income and number of calls based on location, day and phone rate

## Solution
* Fact table with price and number of calls
* Dimension PhoneRate with the type name
* Dimension of Time with day of week, day of month, date month, date year.

## Queries
* Select the yearly income for each phone rate, the total income for each phone rate, the total yearly
income and the total income
```sql
SELECT P.phoneratetype, 
    T.dateyear,
    sum(F.price) as YearlyTypeIncome,
    sum(sum(F.price)) OVER (partition by p.phonerateType) as RateIncome,
    sum(sum(F.price)) OVER (partition by t.dateyear) as YearlyIncome,
    sum(sum(F.price)) OVER () as TotalIncome

FROM FACTS F, phonerate P, timedim T
WHERE f.id_phonerate=p.id_phonerate and f.id_time=t.id_time
GROUP BY p.phoneratetype, T.dateyear;
```
* Select the monthly number of calls and the monthly income. Associate the RANK() to each
month according to its income (1 for the month with the highest income, 2 for the second, etc., the
last month is the one with the least income)
