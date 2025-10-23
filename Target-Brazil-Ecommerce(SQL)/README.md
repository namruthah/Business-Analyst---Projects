# E-Commerce SQL Analysis

## 📌 Project Overview
This project analyzes e-commerce data using SQL to extract meaningful insights. The dataset contains customer, order, payment, and delivery information, allowing us to explore various trends and patterns in online shopping behavior in Brazil.


## 🗂️ Dataset & Tables Used
The analysis is conducted on the `Business_Case_Target_SQL` database, which contains the following CSV files:

- **customers.csv**: Customer demographic details
- **sellers.csv**: Seller demographic details
- **order_items.csv**: Order and pricing details
- **geolocation.csv**: Geographical mapping of customer and seller locations
- **payments.csv**: Payment method and transaction amounts
- **reviews.csv**: Customer reviews and feedback
- **orders.csv**: Order timestamps and delivery information
- **products.csv**: Product category and specification details

## 📊 Key Analyses & Insights

### 1️⃣ Exploratory Data Analysis  
- Analyzed data types for all columns in the `customers` table.  
- Identified the time range during which orders were placed.  
- Counted the number of unique cities and states from which orders were placed.
  
### 2️⃣ Trend & Seasonal Analysis  
- Explored yearly trends in the number of orders placed.  
- Analyzed seasonality patterns to identify peak and low sales periods.  
- Conducted time-of-day analysis to determine when customers most frequently place orders.  

### 3️⃣ Regional Analysis  
- Performed a month-on-month analysis of orders across different states.  
- Mapped customer distribution to understand regional demand patterns.  

### 4️⃣ Economic Impact Analysis  
- Evaluated year-over-year changes in order costs.  
- Analyzed total and average order prices by state.  
- Assessed total and average freight costs across regions.  

### 5️⃣ Logistics & Delivery Insights  
- Calculated delivery times and compared actual vs. estimated delivery dates.  
- Identified states with the highest and lowest freight costs.  
- Ranked states based on delivery speed performance.  

### 6️⃣ Payment Behavior Analysis  
- Analyzed monthly trends in payment methods used.  
- Evaluated the frequency of installment-based purchases.  

## 🔧 Technologies Used
- **SQL** for querying and analysis

