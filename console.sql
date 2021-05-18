-- pokedex
-- Привидение в 1НФ
create table parse as
select distinct unnest(string_to_array(substring(ability from 2 for length(ability) - 2), ', ')) as ability
from pokedex_csv;

create table pokedex as
select *
from parse
         right join pokedex_csv on pokedex_csv.abilities LIKE concat('%', parse.ability, '%');

drop table parse;
alter table pokedex
    drop abilities;

-- Привидение в 2НФ

-- create abilities
create table abilities as
select id, ability
from pokedex;

alter table pokedex
    drop ability;

-- Удаляем дубликаты
delete
from pokedex p1
where p1.ctid <> (SELECT min(p2.ctid)
                  FROM pokedex p2
                  WHERE p1.id = p2.id);


-- create pokedex_x_type
create table a as
select *
from pokedex;

create table b as
select *
from pokedex;

drop table pokedex;

alter table a
    drop column type2;

alter table b
    drop column type1;

delete
from b
where type2 is null;

alter table a
    rename column type1 to type;

alter table b
    rename column type2 to type;

create table pokedex as
select *
from a
union
select *
from b;

drop table a, b;



create table types as
select id, type
from pokedex;

alter table pokedex
    drop type;

CREATE SEQUENCE type_id;
alter table pokedex_x_type
    add column_3 int default nextval('type_id');


delete
from pokedex p1
where p1.ctid <> (SELECT min(p2.ctid)
                  FROM pokedex p2
                  WHERE p1.id = p2.id);

alter table pokedex
    add primary key (id);
-- Привидение к 3НФ
-- Уже находится

-- trainers
create table friends as
select distinct unnest(string_to_array(substring(friends_series from 2 for length(friends_series) - 2),
                                       ', ')) as friends,
                trainer_id
from trainer;

alter table trainer
    drop friends_series;

alter table trainer_csv rename to trainer;



