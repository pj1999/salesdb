

-- 1. List all the columns of the salespeople table
DESCRIBE salespeople;

-- 2. list all the customers - rating of 100
select * from customers where rating = 100;

-- 3. find all records in customer table with NULL values in the city column
select * from customers where city IS NULL;

-- 4. find the largest order taken by each salespeople on each date
select max(amt) largest_amt,odate,snum from orders group by snum,odate;

-- 5. arrange the orders table - descending customer number
select * from customers order by cnum desc;

-- 6. find which salespeople currently have orders in the Orders table
select sname from salespeople where snum = any(select snum from orders);

select sname from salespeople where snum in(select snum from orders);


-- 7. List names of all customers matched with the salespeople serving them
select cname,sname 'salespeople serving' from customers c join salespeople s on s.snum=c.snum;

-- 8. find the names acmdnd numbers of all salespeople who had more than one customer
select snum from customers
group by snum
having count(*) >1;

select * from salespeople 
where snum in 
(   select snum from customers
    group by snum
    having count(*) >1
);

use sales;
select s.snum,sname,cname 
from salespeople s join customers c
on s.snum=c.snum
where s.snum in
(   select snum from customers
    group by snum
    having count(*) >1
);

-- 9. count the orders of each of the salespeople and output the results in descending order
select snum,count(onum)
from orders 
group by snum
order by count(onum) desc;

-- 10. list the customer table if and only if one or more of the customers in the Customer table are located in San Jose
select count(*) from customers where city ="San Jose"

select * from customers 
where
(select count(*) from customers where city ="San Jose") > 1;

-- 11. match salespeople to customers according to what city they lived in
select cname,sname,c.city 
from customers c join salespeople s
on s.city=c.city;

-- 12. find the largest order taken by each salespeople
select snum,max(amt)
from orders
group by snum;

-- 13. Find customers in San Jose who have a rating above 200. 
select cnum,cname,city,rating from customers where city="San Jose" and rating >200;

-- 14. List the names and commissions of all salespeople in London. 
select sname,comm from salespeople where city="London";

-- 15. List all the orders of salesperson Motika from the Orders table. 
select snum from salespeople where sname="Motika";

select * from orders where snum = (select snum from salespeople where sname="Motika");

-- 16. Find all customers with orders on October 3. 
select o.cnum,cname 
from orders o join customers c
on o.cnum = c.cnum 
where day(odate)=3;

-- 17. Give the sums of the amounts from the Orders table, grouped by date, eliminating all those 
--     dates where the SUM was not at least 2000.00 above the MAX amount.
select max(amt) from orders;

select odate,sum(amt) s_amt 
from orders
group by odate
having (s_amt - (select max(amt) from orders)) < 2000;

select odate,sum(amt),max(amt) from orders group by odate having sum(amt)>2000+max(amt);


-- 18. Select all orders that had amounts that were greater than at least one of the orders from 
--     October 6

select amt from orders where day(odate)=6;

select * from orders where amt > any(select amt from orders where day(odate)=6);

-- 19. Write a query that uses the EXISTS operator to extract all salespeople who have customers 
--     with a rating of 300. 

select snum from customers where rating = 300;
        --correlated query
select snum,sname from salespeople s
where exists
(select snum from customers c where rating=300 and s.snum=c.snum);

-- 20. Find all pairs of customers having the same rating. 
select c1.cname,c2.cname
from customers c1 join customers c2
on c1.cnum
where c1.rating=c2.rating and c1.cname <> c2.cname
and c1.cnum > c2.cnum;

-- 21. Find all customers whose CNUM is 1000 above the SNUM of Serres. 
select snum from salespeople where sname="Serres";

select cname from customers 
where 
snum =(1000+(select snum from salespeople where sname="Serres"));

-- 22. Give the salespeople’s commissions as percentages instead of decimal numbers.
select snum,sname,city,concat(lpad((comm*100),4,''),' %') as comm_pct from salespeople;
select snum,sname,city,round((comm*100),2) as comm_pct from salespeople;


-- 23. Find the largest order taken by each salesperson on each date, eliminating those MAX orders
--     which are less than $3000.00 in value.

select snum,odate,max(amt) 
from orders
group by snum,odate;

select snum,odate,max(amt) 
from orders
group by snum,odate
having max(amt) >= 3000;

-- 24. List the largest orders for October 3, for each salesperson.
select snum,odate,max(amt)
from orders
group by snum,odate
having month(odate) =3;

-- 25. Find all customers located in cities where Serres (SNUM 1002) has customers.
select city from customers where snum =(select snum from salespeople where sname= "Serres");

select * from customers where city in (select city from customers where snum =(select snum from salespeople where sname= "Serres"));

-- 26. Select all customers with a rating above 200.00
select * from customers where rating >200;

-- 27. Count the number of salespeople currently listing orders in the Orders table.
select count(distinct snum) 'number of salespeople in orders table' from orders;

-- 28. Write a query that produces all customers serviced by salespeople with a commission above
--     12%. Output the customer’s name and the salesperson’s rate of commission.
select snum,sname,city,round((comm*100),2) as comm_pct from salespeople;

select c.cname, s.sname ,round((comm*100),2) as comm_pct
from customers c join salespeople s
on c.snum = s.snum
where round((comm*100),2) > 12;

-- 29. Find salespeople who have multiple customers.
select c.snum,count(c.cnum) 'count of customers'
from customers c join salespeople s
on c.snum=s.snum
group by c.snum
having count(c.cnum)>1;

-- 30. Find salespeople with customers located in their city
select s.sname 'salespeople name',c.cname 'customer name',
c.city 'common city'
from salespeople s join customers c
on s.city=c.city;

-- 31. Find all salespeople whose name starts with ‘P’ and 
--     the fourth character is ‘l’.
select * from salespeople
where substring(sname,1,1)='P' and
substring(sname,4,4)='l';

-- 32. Write a query that uses a subquery to obtain 
--     all orders for the customer named Cisneros.
--     Assume you do not know his customer number.
select cnum from customers where cname='Cisneros';

select * from orders 
where cnum = (select cnum from customers where cname='Cisneros');

-- 33. Find the largest orders for Serres and Rifkin.
select snum from salespeople
where sname in ('Serres','Rifkin');

select snum,max(amt) from orders 
where snum in (select snum from salespeople
               where sname in ('Serres','Rifkin'))
group by snum;


-- 34. Extract the Salespeople table in the following order : 
    -- SNUM, SNAME, COMMISSION, CITY.
select SNUM,SNAME,comm COMMISION,CITY from salespeople;

-- 35. Select all customers whose names fall in between ‘A’ and ‘G’ 
    -- alphabetical range.
select * from customers 
where 
substring(cname,1,1)>='A' and
substring(cname,1,1)<='G';

-- 36. Select all the possible combinations of customers that you can assign.


-- 37. Select all orders that are greater than the average for October 4.


-- 38. Write a select command using a corelated subquery that selects the names and numbers of all
--     customers with ratings equal to the maximum for their city.


-- 39. Write a query that totals the orders for each day and places the results in descending order.


-- 40. Write a select command that produces the rating followed by the name of each customer in
--     San Jose.









































