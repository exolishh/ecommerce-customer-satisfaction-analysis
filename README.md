# Olist E-Commerce — Customer Satisfaction Analysis

I wanted to understand why customers leave bad reviews on 
e-commerce platforms. This project uses real data from Olist, 
a Brazilian e-commerce company, to find the operational factors 
behind customer dissatisfaction — and what the business can 
actually do about it.

Short answer: it's almost entirely about delivery.

---

## The Problem
Olist wanted to understand why satisfaction scores were 
dropping. Instead of guessing, I let the data answer it.

---

## Dataset
- Brazilian E-Commerce Public Dataset by Olist (Kaggle)
- 95,824 delivered orders across 9 related tables
- Covers 2016 to 2018
- Includes orders, reviews, sellers, products, payments, 
  customers and geolocation

---

## What I Set Out to Test
Before touching the data I wrote down 5 hypotheses:

H1: Longer delivery delays increase the likelihood of 
    negative reviews

H2: Customer satisfaction varies significantly across 
    product categories

H3: Seller performance and satisfaction vary across 
    geographic regions

H4: Higher freight costs are associated with lower 
    customer satisfaction

H5: Delivery performance has a stronger relationship 
    with satisfaction than purchase value

I did not want to design the conclusion before the analysis. 
The data would decide.

---

## Tools Used
- Python — Pandas, Matplotlib, Seaborn, Scikit-learn
- SQL — SQLite with CTEs, window functions, multi-table joins
- Logistic Regression with class balancing
- Tableau Public for the dashboard

---

## What I Found

H1 — Confirmed
Late deliveries had a 62.4% bad review rate vs 9.3% 
for on-time orders. That is 6.7x higher. Delivery 
timing is the single biggest lever.

H2 — Confirmed
Bad review rates ranged from 4.1% for food and drink 
to 22.9% for male fashion clothing — an 18.8 point gap. 
Not all categories are created equal.

H3 — Confirmed
Northern states like AL and MA averaged 23+ day 
deliveries and 2x higher dissatisfaction than SP 
which averaged 8.3 days. Interestingly RJ had 
relatively fast delivery but still high complaints — 
something else is going on there.

H4 — Not Confirmed
Freight cost had a statistically significant but 
practically negligible correlation with satisfaction 
(r = -0.027). With 95K rows even tiny patterns look 
significant. Freight is not the problem.

H5 — Confirmed
The Logistic Regression confirmed delivery performance 
is 3.4x more predictive of bad reviews than purchase 
value. One thing I did not expect — item count came 
in as the second strongest predictor. More items in 
an order means more chances for something to go wrong.

---

## Model
I used Logistic Regression with class_weight=balanced 
because only 12.8% of reviews were bad. A standard 
model would just predict good review every time and 
look accurate without learning anything useful.

After balancing:
- AUC: 0.744
- Recall improved from 32% to 53%
- 66% better at catching dissatisfied customers

For this use case catching more unhappy customers 
matters more than raw accuracy.

---

## SQL Analysis
Wrote 7 business queries to dig into seller performance:
- Ranked sellers by bad review rate
- Identified chronic late delivery sellers
- Built a seller risk scorecard using CTEs
- Ranked sellers within each state using window functions
- Found high revenue sellers with high complaint rates 
— the most actionable targets

---

## Recommendations
1. The 519 high risk sellers need direct intervention — 
   they have 20%+ bad review rates
2. Logistics in northern states needs improvement — 
   customers there wait 3x longer than SP customers
3. Fashion and furniture categories have the highest 
   complaint rates — worth investigating product quality
4. Improving delivery speed will have 3.4x more impact 
   than reducing prices
5. SP sellers handle 71% of all orders — small improvements 
   there affect the most customers

---

## Dashboard
Interactive Tableau dashboard covering seller performance, 
delivery times by state, and category satisfaction:
[View Dashboard](https://public.tableau.com/views/OlistE-CommerceCustomerSatisfactionAnalysis/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

## Repository Structure
olist_analysis.ipynb — full analysis notebook
sql/seller_analysis.sql — all 7 SQL queries
dashboard_screenshot.png — dashboard preview
README.md — you are here

---

## Status
✅ 9 tables merged and cleaned
✅ 6 features engineered from raw timestamps
✅ 5 hypotheses tested
✅ 7 SQL queries with CTEs and window functions
✅ Logistic Regression AUC 0.744
✅ Tableau dashboard published
