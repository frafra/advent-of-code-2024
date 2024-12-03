create view reports as
select row_number() over () as position,
       string_split(column0, ' ')::integer[] as levels
  from read_csv('data/input', header=false)
;

-- safe levels
select count(*)
  from reports
 where list_reduce(levels, (x, y) -> if(x>y and x-y <= 3, y, NULL)) or
       list_reduce(levels, (x, y) -> if(x<y and y-x <= 3, y, NULL))
;

-- safe levels + extra tolerance
  with reports_extra as (
        select position,
               levels
          from reports
         union
        select position,
               list_concat(levels[:unnest], levels[unnest+2:])
          from reports,
               unnest(range(len(levels)))
       )
select count(distinct position)
  from reports_extra
 where list_reduce(levels, (x, y) -> if(x>y and x-y <= 3, y, NULL)) or
       list_reduce(levels, (x, y) -> if(x<y and y-x <= 3, y, NULL))
;
