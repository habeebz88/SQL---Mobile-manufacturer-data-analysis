--SQL Advance Case Study


--Q1--BEGIN 
select distinct state from(	
	select l.State, sum(quantity)as tot_quantity,year(t.date)as years from DIM_LOCATION l
	join FACT_TRANSACTIONS t
	on l.IDLocation=t.IDLocation
	where year(t.date)>=2005
	group by l.State,year(t.date))as A


--Q1--END

--Q2--BEGIN
select top 1 l.state,count(*)as cnt from DIM_LOCATION l
join FACT_TRANSACTIONS t
on l.IDLocation=t.IDLocation
join DIM_MODEL m
on m.IDModel=t.IDModel
join DIM_MANUFACTURER dm
on dm.IDManufacturer=m.IDManufacturer
where Country=	'us' and Manufacturer_Name='samsung'
group by l.State
order by cnt desc


--Q2--END

--Q3--BEGIN      
	
select idmodel,state,zipcode,count(*) as tot_trans
from FACT_TRANSACTIONS t
join DIM_LOCATION l
on t.IDLocation=l.IDLocation
group by IDModel,state,ZipCode 

--Q3--END

--Q4--BEGIN
select top 1 model_name,unit_price from DIM_MODEL
order by Unit_price 

--Q4--END

--Q5--BEGIN

 select t.idmodel,AVG(totalprice)as avg_price,sum(quantity) as tot_qty from FACT_TRANSACTIONS t
 join DIM_MODEL m
on t.IDModel=m.IDModel
join DIM_MANUFACTURER dm
on m.IDManufacturer=dm.IDManufacturer
 where manufacturer_name in (select top 5 manufacturer_name from FACT_TRANSACTIONS t
							join DIM_MODEL m
							on t.IDModel=m.IDModel
							join DIM_MANUFACTURER dm
							on m.IDManufacturer=dm.IDManufacturer
							group by Manufacturer_Name
							order by sum(totalprice) desc)
 group by t.idmodel
 order by avg_price desc


--Q5--END

--Q6--BEGIN

select Customer_Name,AVG(totalprice)as avg_price from DIM_CUSTOMER c
join FACT_TRANSACTIONS t
on c.IDCustomer=t.IDCustomer
where YEAR(date)=2009
group by Customer_Name
having AVG(totalprice)>500	


--Q6--END
	
--Q7--BEGIN  
select * from (
select top 5 IDModel from FACT_TRANSACTIONS
where YEAR(date)=2008
group by IDModel,YEAR(date)
order by sum(quantity) desc
)as A
intersect
select * from (
select top 5 IDModel from FACT_TRANSACTIONS
where YEAR(date)=2009
group by IDModel,YEAR(date)
order by sum(quantity) desc
) as B
intersect
select * from (
select top 5 IDModel from FACT_TRANSACTIONS
where YEAR(date)=2010
group by IDModel,YEAR(date)
order by sum(quantity) desc)as C
	

--Q7--END	
--Q8--BEGIN
select * from (
select top 1* from(
select top 2 manufacturer_name,YEAR(date)as year,sum(totalprice) as sales from FACT_TRANSACTIONS t
join DIM_MODEL m
on t.IDModel=m.IDModel
join DIM_MANUFACTURER dm
on m.IDManufacturer=dm.IDManufacturer
where YEAR(date)=2009
group by Manufacturer_Name,YEAR(date)
order by sales desc
)as A
order by sales 
) as B
union
select * from (
select top 1* from(
select top 2 manufacturer_name,YEAR(date)as year,sum(totalprice) as sales from FACT_TRANSACTIONS t
join DIM_MODEL m
on t.IDModel=m.IDModel
join DIM_MANUFACTURER dm
on m.IDManufacturer=dm.IDManufacturer
where YEAR(date)=2010
group by Manufacturer_Name,YEAR(date)
order by sales desc
)as C
order by sales 
)as D


--Q8--END
--Q9--BEGIN
	
select manufacturer_name from FACT_TRANSACTIONS t
join DIM_MODEL m
on t.IDModel=m.IDModel
join DIM_MANUFACTURER dm
on m.IDManufacturer=dm.IDManufacturer
where YEAR(date)=2010
group by Manufacturer_Name
except
select manufacturer_name from FACT_TRANSACTIONS t
join DIM_MODEL m
on t.IDModel=m.IDModel
join DIM_MANUFACTURER dm
on m.IDManufacturer=dm.IDManufacturer
where YEAR(date)=2009
group by Manufacturer_Name



--Q9--END

--Q10--BEGIN
	
select *,((avg_price-lag_price)/lag_price) as percentage_change from(
select *,lag(avg_price,1) over(partition by idcustomer order by year) as lag_price from(
select IDCustomer,year(date)as year,AVG(totalprice)as avg_price,sum(quantity)as qty from FACT_TRANSACTIONS
where IDCustomer in (select top 100 IDCustomer from FACT_TRANSACTIONS
						 group by IDCustomer
						order by sum(totalprice) desc)
group by IDCustomer,YEAR(date)
 )as A
 ) as B



--Q10--END
	