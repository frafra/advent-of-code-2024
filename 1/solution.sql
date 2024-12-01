create view lists as
select column0 as id1,
       column3 as id2
  from read_csv('data/input', delim=' ')
;

create view list1 as
select row_number() over (order by id1) as position,
       id1
  from lists
;

create view list2 as
select row_number() over (order by id2) as position,
       id2
  from lists
;

-- distance
  with distances as (
        select abs(id1-id2) as distance,
          from list1
          join list2
            on list1.position = list2.position
       )
select sum(distance)
  from distances
 group by true
;

-- similarity
  with scores as (
        select list1.id1*count(*) as score
          from list1
          join list2
            on list1.id1 = list2.id2
         group by list1.id1
       )
select sum(score)
  from scores
;
