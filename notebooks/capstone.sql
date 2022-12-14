select * from florida;

select * from ohio;

select * from georgia;

select * from golf;

select avg(strokes/n_rounds), date, tournament_name
from golf
where tournament_name like '%Memorial%'
group by date, tournament_name
order by date;
--average strokes by year for The Memorial
--71.6320754716981132	"2015-06-07"
--71.0370370370370370	"2016-06-05"
--72.9026548672566372	"2017-06-04"
--71.4824561403508772	"2018-06-03"
--72.2241379310344828	"2019-06-02"
--74.1615384615384615	"2020-07-19"
--73.1016949152542373	"2021-06-06"
--73.0434782608695652	"2022-06-05"

select avg(strokes/n_rounds), date, tournament_name
from golf
where tournament_name like '%Masters%'
group by date, tournament_name
order by date;
/* Average Strokes by year for the Masters
72.2278481012658228	"2015-04-12"
74.2500000000000000	"2016-04-10"
73.8395061728395062	"2017-04-09"
72.8354430379746835	"2018-04-08"
71.8048780487804878	"2019-04-14"
71.9021739130434783	"2020-11-15"
73.3103448275862069	"2021-04-11"
73.9047619047619048	"2022-04-10" */

select avg(strokes/n_rounds), date, tournament_name
from golf
where tournament_name like '%Players%'
group by date, tournament_name
order by date;

/* Average strokes by year for the Players
72.2692307692307692	"2015-05-10"
71.9477611940298507	"2016-05-15"
73.1985815602836879	"2017-05-14"
71.5000000000000000	"2018-05-13"
71.7083333333333333	"2019-03-17"
72.7467532467532468	"2021-03-14"
72.9440559440559441	"2022-03-13" */

select avg(strokes/n_rounds), golf.date, tournament_name, "AWND", "TMAX", "TMIN", "WSF5"
from golf
inner join ohio
on golf.date = ohio."DATE"
where tournament_name like '%Memorial%'
group by date, tournament_name, "AWND", "TMAX", "TMIN", "WSF5"
order by "AWND" desc;


select avg(strokes/n_rounds), golf.date, tournament_name, "AWND", "TMAX", "TMIN", "WSF5"
from golf
inner join georgia
on golf.date = georgia."DATE"
where tournament_name like '%Masters%'
group by date, tournament_name, "AWND", "TMAX", "TMIN", "WSF5"
order by "AWND" desc;

with wind as (select "AWND", "DATE",
                 avg("AWND") OVER(ORDER by "DATE" Rows between 3 preceding and current row)
                 as average_wind
                 from ohio),
             
     max_temp as (select "TMAX", "DATE",
                 avg("TMAX") OVER(ORDER by "DATE" Rows between 3 preceding and current row)
                 as average_max
                 from ohio),
               
     min_temp as (select "TMIN", "DATE",
                 avg("TMIN") OVER(ORDER by "DATE" Rows between 3 preceding and current row)
                 as average_min
                 from ohio),
                 
     gusts as (select "WSF5", "DATE",
                 avg("WSF5") OVER(ORDER by "DATE" Rows between 3 preceding and current row)
                 as average_gust
                 from ohio)
                 
    select avg(strokes/n_rounds), golf.date, round(average_wind,2)as wind, round(average_max,2) as max, round(average_min,2) as min, round(average_gust,2)as gust, tournament_name
    from golf
    inner join wind 
    on golf.date = wind."DATE"
    inner join max_temp
    on golf.date = max_temp."DATE"
    inner join min_temp 
    on golf.date = min_temp."DATE"
    inner join gusts 
    on golf.date = gusts."DATE"
    where tournament_name like '%Memorial%'
    group by golf.date, tournament_name, wind, max, min, gust
    order by wind desc;
      
      
with wind as (select "AWND", "DATE",
                 avg("AWND") OVER(ORDER by "DATE" Rows between 3 preceding and current row)
                 as average_wind
                 from georgia),
             
     max_temp as (select "TMAX", "DATE",
                 avg("TMAX") OVER(ORDER by "DATE" Rows between 3 preceding and current row)
                 as average_max
                 from georgia),
               
     min_temp as (select "TMIN", "DATE",
                 avg("TMIN") OVER(ORDER by "DATE" Rows between 3 preceding and current row)
                 as average_min
                 from georgia),
                 
     gusts as (select "WSF5", "DATE",
                 avg("WSF5") OVER(ORDER by "DATE" Rows between 3 preceding and current row)
                 as average_gust
                 from georgia)
                 
    select avg(strokes/n_rounds), golf.date, round(average_wind,2)as wind, round(average_max,2) as max, round(average_min,2) as min, round(average_gust,2)as gust, tournament_name
    from golf
    inner join wind 
    on golf.date = wind."DATE"
    inner join max_temp
    on golf.date = max_temp."DATE"
    inner join min_temp 
    on golf.date = min_temp."DATE"
    inner join gusts 
    on golf.date = gusts."DATE"
    where tournament_name like '%Masters%'
    group by golf.date, tournament_name, wind, max, min, gust
    order by wind desc;
                    
with rain as (select "PRCP", "DATE",
                 avg("PRCP") OVER(ORDER by "DATE" Rows between 3 preceding and current row)
                 as average_rain
                 from florida),
             
     max_temp as (select "TMAX", "DATE",
                 avg("TMAX") OVER(ORDER by "DATE" Rows between 3 preceding and current row)
                 as average_max
                 from florida),
               
     min_temp as (select "TMIN", "DATE",
                 avg("TMIN") OVER(ORDER by "DATE" Rows between 3 preceding and current row)
                 as average_min
                 from florida)
                 
                 
    select avg(strokes/n_rounds), golf.date, round(average_rain,2)as rain, round(average_max,2) as max, round(average_min,2) as min, tournament_name
    from golf
    inner join rain 
    on golf.date = rain."DATE"
    inner join max_temp
    on golf.date = max_temp."DATE"
    inner join min_temp 
    on golf.date = min_temp."DATE"
    where tournament_name like '%Players%'
    group by golf.date, tournament_name, rain, max, min 
    order by rain desc;
    