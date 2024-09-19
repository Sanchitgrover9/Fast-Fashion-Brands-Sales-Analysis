use jun3;

## Users table
#user_id,uname, age, gender, country,state
##city, contact_no

## Item info 
##item_id,name,Category
## brand, price, brand_cost

## sales info
## purchase_id, order_date, user_id, item_id, category, 
## brand, price, quantity,total_price,Mode


select * from user_info;
select * from sales_info;
select * from item_info;



### Sales Analysis of fast fashion brands 
-- KPI
-- Sales analysis
-- 1. Year wise sales brand wise
-- 2. Month wise sales  brand wise
-- 3. Total Sales  brand wise
-- 4. category wise sales brand wise
-- 5. state wise sales  brand wise
-- 6. MOM% change brand wise
-- 7. YOY% change brand wise
-- 8. city wise sales brand wise
-- 9. Top 3 state with highest sales brand wise
-- 10. Top 3 categories which have highest sales brand wise

-- 11 Top 3 cities which have highest sales brand wise
-- 12 Top 3 name of category which have highest sales brand wise
  --  13 online and offline sales brand wise




# 1  Year wise sales brand wise
select year(str_to_date(order_date,'%Y-%m-%d')) as years,
brand,sum(price*quantity) as  sales
from sales_info
group by years,brand
order by years,brand,sales desc;



# 2  Month wise sales  brand wise
select year(str_to_date(order_date,'%Y-%m-%d')) as years,
monthname(str_to_date(order_date,'%Y-%m-%d')) as months,brand,sum(price*quantity) as  sales
from sales_info
group by months,brand,years
order by years,months,brand;




## 3 Total Sales  brand wise
select brand,sum(price*quantity) as total_sales
from sales_info
group by brand
order by total_sales desc;





## 4  category wise sales brand wise
select category,brand,sum(price*quantity) as total_sales
from sales_info
group by category,brand
order by category,brand;


## 5  state wise sales  brand wise
select t1.state,sum(t2.price*t2.quantity) as sales
from user_info as t1
join sales_info as t2
on t1.user_id=t2.user_id
group by t1.state
order by sales desc;



## 6  MOM% change brand wise   
# brand=1
select *,round(((sales-prev_month_sale)/prev_month_sale)*100 ,2)as  MOM_percentage_change from
(select *,lag(sales) over (order by months) as prev_month_sale from
(select brand,year(str_to_date(order_date,'%Y-%m-%d')) as years,
month(str_to_date(order_date,'%Y-%m-%d')) as months,sum(price*quantity) sales
from sales_info
group by brand,months,years
having  years='2024' and brand='zara')dt)dt1;




# brand=2
select *,round(((sales-prev_month_sale)/prev_month_sale)*100 ,2)as  MOM_percentage_change from
(select *,lag(sales) over (order by months) as prev_month_sale from
(select brand,year(str_to_date(order_date,'%Y-%m-%d')) as years,
month(str_to_date(order_date,'%Y-%m-%d')) as months,sum(price*quantity) sales
from sales_info
group by brand,months,years
having  years='2024' and brand='adidas')dt)dt1;

# brand=3
select *,round(((sales-prev_month_sale)/prev_month_sale)*100 ,2)as  MOM_percentage_change from
(select *,lag(sales) over (order by months) as prev_month_sale from
(select brand,year(str_to_date(order_date,'%Y-%m-%d')) as years,month(str_to_date(order_date,'%Y-%m-%d')) as months,sum(price*quantity) sales
from sales_info
group by brand,months,years
having  years='2024' and brand='H&M')dt)dt1;


## brand=4
select *,round(((sales-prev_month_sale)/prev_month_sale)*100 ,2)as  MOM_percentage_change from
(select *,lag(sales) over (order by months) as prev_month_sale from
(select brand,year(str_to_date(order_date,'%Y-%m-%d')) as years,
month(str_to_date(order_date,'%Y-%m-%d')) as months,sum(price*quantity) sales
from sales_info
group by brand,months,years
having  years='2024' and brand='nike')dt)dt1;

### 7  YOY% change 
select *,round(((sales-prev_year_sale)/prev_year_sale)*100 ,2)as  YOY_percentage_change from
(select *,lag(sales) over (order by years) as prev_year_sale from
(select year(str_to_date(order_date,'%Y-%m-%d')) as years,sum(price*quantity) sales
from sales_info
group by years
order by years)dt)dt1;


-- YOY% change brand wise

select *,round(((sales-prev_year_sale)/prev_year_sale)*100 ,2)as  YOY_percentage_change from
(select *,lag(sales) over (order by years) as prev_year_sale from
(select brand,year(str_to_date(order_date,'%Y-%m-%d')) as years,sum(price*quantity) sales
from sales_info
where brand='Nike'
group by brand,years
order by years)dt)dt1;


select *,round(((sales-prev_year_sale)/prev_year_sale)*100 ,2)as  YOY_percentage_change from
(select *,lag(sales) over (order by years) as prev_year_sale from
(select brand,year(str_to_date(order_date,'%Y-%m-%d')) as years,sum(price*quantity) sales
from sales_info
where brand='H%M'
group by brand,years
order by years)dt)dt1;

select *,round(((sales-prev_year_sale)/prev_year_sale)*100 ,2)as  YOY_percentage_change from
(select *,lag(sales) over (order by years) as prev_year_sale from
(select brand,year(str_to_date(order_date,'%Y-%m-%d')) as years,sum(price*quantity) sales
from sales_info
where brand='Adidas'
group by brand,years
order by years)dt)dt1;



select *,round(((sales-prev_year_sale)/prev_year_sale)*100 ,2)as  YOY_percentage_change from
(select *,lag(sales) over (order by years) as prev_year_sale from
(select brand,year(str_to_date(order_date,'%Y-%m-%d')) as years,sum(price*quantity) sales
from sales_info
where brand='Zara'
group by brand,years
order by years)dt)dt1;



###  8 city wise sales brand wise

select t1.city,t2.brand,sum(t2.price*t2.quantity) as sales
from user_info as t1
join sales_info as t2
on t1.user_id=t2.user_id
group by t1.city,t2.brand
order by sales desc;








select t1.city,sum(t2.price*t2.quantity) as sales
from user_info as t1
join sales_info as t2
on t1.user_id=t2.user_id
group by t1.city
order by sales desc;



## 9 Top 3 state with highest sales brand wise
select * from 
(select *,dense_rank() over (partition by brand order by sales desc) as ranks from
(select t1.state,t2.brand,sum(t2.price*t2.quantity) as sales
from user_info  as t1
join sales_info as t2
on t1.user_id=t2.user_id
group by t1.state,t2.brand)dt)dt1
where dt1.ranks<=3;



## 10 Top 3 categories which have highest sales brand wise

select * from 
(select *,dense_rank() over (partition by brand order by sales desc) as ranks from
(select category,brand,sum(price*quantity) as sales
from sales_info
group by category,brand)dt)dt1
where dt1.ranks<=3;



select * from 
(select *,dense_rank() over (order by sales desc) as ranks from
(select category,sum(price*quantity) as sales
from sales_info
group by category)dt)dt1
where dt1.ranks<=3;



## 11  top 3  cities have highest sales brand wise
select * from 
(select *,dense_rank() over (partition by brand order by sales desc) as ranks from
(select t1.city,t2.brand,sum(t2.price*t2.quantity) as sales
from user_info as t1
join sales_info as t2
on t1.user_id=t2.user_id
group by t1.city,t2.brand)dt)dt1
where dt1.ranks<=3;


## 12   Top 3 name of sub-category which have highest sales brand wise
select * from 
(select *,dense_rank() over (partition by brand order by sales desc) as ranks from
(select t1.name,t2.brand,sum(t2.price*t2.quantity) as sales
from item_info as t1
join sales_info as t2
on t1.item_id=t2.item_id
group by t1.name,t2.brand)dt)dt1
where dt1.ranks<=3;



--  13 online and offline sales brand wise

select mode,brand,sum(price*quantity) as sales
from sales_info
where brand='Zara'
group by mode,brand
order by sales desc;


select mode,brand,sum(price*quantity) as sales
from sales_info
where brand='Adidas'
group by mode,brand
order by sales desc;


select mode,brand,sum(price*quantity) as sales
from sales_info
where brand='Nike'
group by mode,brand
order by sales desc;


select mode,brand,sum(price*quantity) as sales
from sales_info
where brand='H&M'
group by mode,brand
order by sales desc;







select mode,sum(price*quantity) as sales
from sales_info
group by mode
order by sales desc;



###   Customer Analysis


## User table
#user_id,uname, age, gender, country,state
##city, contact_no

## Item info 
##item_id,name,Category
## brand, price, brand_cost

## sales info
## purchase_id, date, user_id, item_id, category, 
## brand, price, quantity,total_price,Mode




# 1 top Customers with highest sales

select t1.uname,sum(t2.price*t2.quantity) sales
from user_info as t1
join sales_info as t2
on t1.user_id=t2.user_id
group by t1.uname
order by sales desc
limit 5;



#  2 top 5 customers brands wise
select * from
(select *,dense_rank() over(partition by brand  order by sales desc) as  ranks from
(select t1.uname,t2.brand,sum(t2.price*t2.quantity) sales
from user_info as t1
join sales_info as t2
on t1.user_id=t2.user_id
group by t1.uname,t2.brand)dt)dt1
where dt1.ranks<=5;

# 3  -- 3. custmers with repeat order brand wise
SELECT 
    si.brand,
    (COUNT(DISTINCT rc.user_id) * 100.0) / COUNT(DISTINCT si.user_id) AS repeat_customer_rate
FROM 
    Sales_Info si
LEFT JOIN (
    SELECT user_id, brand
    FROM Sales_Info
    GROUP BY user_id, brand
    HAVING COUNT(purchase_id) > 1
) rc 
ON si.user_id = rc.user_id AND si.brand = rc.brand
GROUP BY si.brand;



#  4 category wise total customers
select t1.category,count(t2.uname) count_of_cust
from sales_info as t1
join user_info as t2
on t1.user_id=t2.user_id
group by t1.category
order by count_of_cust desc;


#  5  brand wise total customers
select t1.brand,count(t2.uname) count_of_cust
from sales_info as t1
join user_info as t2
on t1.user_id=t2.user_id
group by t1.brand
order by count_of_cust desc;



#  6  Mode  wise total customers
select t1.mode,count(t2.uname) count_of_cust
from sales_info as t1
join user_info as t2
on t1.user_id=t2.user_id
group by t1.mode
order by count_of_cust desc;







#######   Orders analysis

# No of orders per year 
select year(str_to_date(order_date,'%Y-%m-%d')) as years,count(purchase_id) total_orders
from sales_info
group by years
order by years;


# 2 No of orders per month

select month(str_to_date(order_date,'%Y-%m-%d')) as months,count(purchase_id) count_of_order
from sales_info
group by months
order by months;



## 3 No of order brand wise
select brand,count(purchase_id) count_of_order
from sales_info
group by brand
order by count_of_order desc;



## 4 YOY percentage change in orders

select *,round(((total_orders-prev_year_order)/prev_year_order)*100 ,2)as  YOY_percentage_change from
(select *,lag(total_orders) over (order by years) as prev_year_order from
(select year(str_to_date(order_date,'%Y-%m-%d')) as years,count(purchase_id) total_orders
from sales_info
group by years
order by years)dt)dt1;



## 5  MOM change in orders 
select *,round(((total_orders-prev_year_order)/prev_year_order)*100 ,2)as  YOY_percentage_change from
(select *,lag(total_orders) over (order by months) as prev_year_order from
(select month(str_to_date(order_date,'%Y-%m-%d')) as months,count(purchase_id) total_orders
from sales_info
group by months
order by months)dt)dt1;

## 6  category wise order count
select category,count(purchase_id) count_of_order
from sales_info
group by category
order by count_of_order desc;









