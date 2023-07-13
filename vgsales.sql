#This is a video games sales data downloaded from kaggle for mysql entry level practices. 
# create empty table, 新建空白表
CREATE TABLE Sales_data(
Rank_number integer,
Name varchar(100),
Platform varchar(100),
Year int,
Genre varchar(100),
Publisher varchar(100),
NA_Sales float,
EU_Sales float,
JP_Sales float,
Other_Sales float,
Global_Sales float);
# make sure the path is correct. 查看默认路径，避免csv文件导不进去
SHOW VARIABLES LIKE '%secure%';
# make sure local_infile is on to get the permission 检查导入许可
Show variables like "local_infile";
set global local_infile = 1;
# my schema
use book;

#import csv file 导入文件
load data local infile 'D:/R_file/vgsales.csv'
into table book.sales_data
character set 'utf8'
fields terminated by ','
LINES TERMINATED BY '\n'
ignore 1 rows;

#Step 1:overview，此表可能更适合直接通过tableau或power BI做interactive visulization，但也可以通过简单的查询语句观察此表
SELECT *
FROM sales_data
LIMIT 20;

# Step 2: obervation. see wheter Global_Sales are equal to the total sales from 4 regions
SELECT name, Na_Sales,Eu_Sales,JP_Sales,Other_Sales,Global_Sales, 
round(sum(Na_Sales+Eu_Sales+JP_Sales+Other_Sales) over (partition by Rank_number),2) as total_sales,
round(sum(Na_Sales+Eu_Sales+JP_Sales+Other_Sales-Global_Sales) over (partition by Rank_number),2) as error
from sales_data;
# as we can see, the global_sales are pretty accurate. so we can keep further exploring
# we have columns like, publisher, platform,video game name,genre. So we can do some aggreigate function to see how the sale goes on by these variables.

#  total sales from 1996 to 2016
SELECT Year, round(sum(Global_Sales),2) as total_sales
FROM sales_data
WHERE year between 1996 and 2016
GROUP BY Year
ORDER BY year desc

#  total 10 platform by sales
SELECT platform, round(sum(Global_Sales),2) as total_sales
FROM sales_data
GROUP BY platform
ORDER BY total_sales desc
limit 10

#  total 10 publisher by sales
SELECT publisher, round(sum(Global_Sales),2) as total_sales
FROM sales_data
GROUP BY publisher
ORDER BY total_sales desc
limit 10

#  total 10 video game by sales
SELECT name, round(sum(Global_Sales),2) as total_sales
FROM sales_data
GROUP BY name
ORDER BY total_sales desc
limit 10

#  total 10 genre by sales
SELECT genre, round(sum(Global_Sales),2) as total_sales
FROM sales_data
GROUP BY genre
ORDER BY total_sales desc
limit 10

# by far we have an general idea about this sales table based on total_sales
# now we can go detail to see the sales performance by different region and years
SELECT Year, round(sum(na_sales),2) as NA, round(sum(eu_sales),2) as EU,
 round(sum(jp_sales),2) as JP, round(sum(other_sales),2) as Other, round(sum(Global_sales),2) as total_sales
FROM sales_data
WHERE year between 2000 and 2015
GROUP BY Year
ORDER BY year desc

#we have seen Pokemon rank 7 on the total_sales. we can check the JP to see how it goes in homecourt lol
SELECT name, round(sum(JP_sales),2) as JP
FROM sales_data
GROUP BY name
ORDER BY JP desc
limit 10
# what about north america?
SELECT name, round(sum(na_sales),2) as na
FROM sales_data
GROUP BY name
ORDER BY na desc
limit 10
#seems like the table has some wrong values
select * from sales_data
where name = '"Hi! Hamtaro - Little Hamsters'
#year =0 that's weird, there are about 300 rows with year=0 out of 16598 rows
#It may due to the encode issue when I import the data.
#now we can go back to see north america
select count(*) from sales_data
where year = 0;

#drop invaild rows
DELETE FROM sales_data
WHERE year = 0;

#by comparing JP and NA, it tells that gamers have different preferences geographically.alter
#let's see the sales in JP and NA by genre
SELECT genre, round(sum(jp_sales),2) as na
FROM sales_data
GROUP BY genre
ORDER BY na desc
limit 10;
# RPG is really popular in JP, also action and sports
SELECT genre, round(sum(na_sales),2) as na
FROM sales_data
GROUP BY genre
ORDER BY na desc
limit 10;
# besides Action and Sports, shooter is also popular in NA.

#we can also observe what kind of platforms people like to play games on in different regions
SELECT platform, round(sum(na_sales),2) as NA, round(sum(eu_sales),2) as EU,
 round(sum(jp_sales),2) as JP, round(sum(other_sales),2) as Other, round(sum(Global_sales),2) as total_sales
FROM sales_data
WHERE year between 2010 and 2016
GROUP BY platform
ORDER BY total_sales desc;

# or maybe check how different publishers perform in different regions
SELECT publisher, round(sum(na_sales),2) as NA, round(sum(eu_sales),2) as EU,
 round(sum(jp_sales),2) as JP, round(sum(other_sales),2) as Other, round(sum(Global_sales),2) as total_sales
FROM sales_data
WHERE year between 2010 and 2016
GROUP BY publisher
ORDER BY total_sales desc



