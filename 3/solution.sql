create view memory as
select content as chunk
  from read_text('data/input')
;

-- multiply and sum corrupted memory chunks 
select sum(list_dot_product(
           regexp_extract_all(chunk, 'mul\((\d{1,3}),(\d{1,3})\)', 1)::integer[],
           regexp_extract_all(chunk, 'mul\((\d{1,3}),(\d{1,3})\)', 2)::integer[]
       ))::integer as sum_of_multiplied
  from memory
;

-- multiply and sum corrupted memory chunks + do/dont's
  with split_do as (
        select unnest(string_split(chunk, 'do()')) as chunk
          from memory
       ),
       without_dont as (
        select string_split(chunk, 'don''t()')[1] as chunk
          from split_do
       )
select sum(list_dot_product(
           regexp_extract_all(chunk, 'mul\((\d{1,3}),(\d{1,3})\)', 1)::integer[],
           regexp_extract_all(chunk, 'mul\((\d{1,3}),(\d{1,3})\)', 2)::integer[]
       ))::integer as sum_of_multiplied_clean
  from without_dont
;

