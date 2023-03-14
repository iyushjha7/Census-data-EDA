select * from dataset1;
select * from dataset2;

-- number of rows in both dataset
 select count(*) from dataset1;
 select count(*) from dataset1;
 
 -- details of Maharastra from both dataset in a table
 -- creatinf a temperory table for Maharshtra state
 
 with cte_Maharashtra
 as
 (select dataset1.District, dataset1.State, dataset1.Growth,dataset1.Sex_Ratio, dataset1.Literacy, dataset2.Area_km2, dataset2.Population from dataset1
 left join dataset2
 on dataset1.District = dataset2.District
 where dataset1.State = 'Maharashtra')
 
 select * from cte_maharashtra;
 
 -- data of population and area group by State
 
 select State, sum(Area_km2)as Area_km2, sum(Population)  Population from dataset2
 group by State
 order by 2 desc,3 desc;
 
 -- Top 10 States by population per sqare km

 select State, round(sum(Population)/sum(Area_km2)) as Person_per_km2 from dataset2
 group by State
 order by Person_per_km2 desc
 limit 10;
 
 -- average growth rate by state
 
 select State, avg(growth)*100 as Avg_growth_percent from dataset1
 group by State
 order by State asc;
 
 -- average Sex_ratio  by state
 
 select State, round(avg(Sex_Ratio)) as Avg_Sex_ratio from dataset1
 group by State
 order by State asc;
 
 -- average literacy rate  by state
 select State, round(avg(Literacy)) as Avg_literacy from dataset1
 group by State
 having Avg_literacy > 90;
 
-- top 3 state in area
select State, sum(Area_km2) from dataset2
group by State
order by Area_km2
limit 3;

-- creating combined table of both the dataset

create table all_data
(District text, State text, Growth double, Sex_Ratio int, Literacy double, Area_km2 varchar(20), Population varchar(20));
insert into all_data
select dataset1.District, dataset1.State, dataset1.Growth,dataset1.Sex_Ratio, dataset1.Literacy, dataset2.Area_km2, dataset2.Population from dataset1
 left join dataset2
 on dataset1.District = dataset2.District;

 select * from all_data;
 
 -- states whose name is starting with a
 
 select distinct State from all_data
 where lower(State) like 'a%';
 
 -- number of males and females
 
 -- female/male = Sex_Ratio/1000 and female + male = Population
 -- so, male = Population/(1+(Sex_Ratio)/1000) and female = Population/(1+(1000/Sex_Ratio))
 
 select d1.District, d1.State, d1.Sex_Ratio, d2.Population,
 round(d2.Population/(1+(d1.Sex_Ratio)/1000)) as Male, 
 round(d2.Population/(1+(1000/d1.Sex_Ratio))) as Female 
 from dataset1 d1
 inner join dataset2 d2
 on d1.District = d2.District;

 -- number of literate people by state
 
with cte_Literacy_num
as
(select d1.District, d1.State, d1.Literacy, d2.Population,
 round(d1.Literacy * d2.Population / 100) as Literate_people
 from dataset1 d1
 inner join dataset2 d2
 on d1.District = d2.District)
 
 select State, sum(Population), sum(Literate_people) from cte_Literacy_num
 group by state
 order by sum(Literate_people);

-- population of previous census
-- previous population = present population /(1+growth rate)

with prev_pop_data
as
(select d1.District, d1.State, d1.Growth, d2.Population,
 round(d2.Population/(1+d1.Growth)) as Prev_population
 from dataset1 d1
 inner join dataset2 d2
 on d1.District = d2.District)
 
 
 -- total previous census population of india
 select sum(Population), sum(Prev_population) from prev_pop_data;
 
 -- total previous census population of State 
 with prev_pop_data
as
(select d1.District, d1.State, d1.Growth, d2.Population,
 round(d2.Population/(1+d1.Growth)) as Prev_population
 from dataset1 d1
 inner join dataset2 d2
 on d1.District = d2.District)
 select State, sum(Population), sum(Prev_population) from prev_pop_data
 group by State;
 
 -- How much increase in person per km2 from previous census to present census_data
 
with prev_pop_data
as
(select d1.District, d1.State, d1.Growth, d2.Population,
 round(d2.Population/(1+d1.Growth)) as Prev_population
 from dataset1 d1
 inner join dataset2 d2
 on d1.District = d2.District)
 
 select a.State, round(sum(a.Population)/sum(b.Area_km2)) as Pop_per_km2, round(sum(a.Prev_population)/sum(b.Area_km2)) as Prev_Pop_per_km2
 from prev_pop_data a
 inner join dataset2 b
 on a.District = b.District
 group by a.State
 order by a.State desc;
 
 -- top 3 districts from each state on basis of area
 
 select a.*
 from 
 (select District, State, Area_km2,rank() over( partition by State order by Area_km2 desc) rnk from dataset2) a
 where rnk<4

 
 

 
 


 

 
 
 
