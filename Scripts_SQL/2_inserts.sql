insert
	into
	titles_clean (
    id,
	type,
	title,
	rating,
	date_added,
	release_year,
	duration_value,
	duration_unit,
	description,
	director,
	cast_members,
	country,
	genres
)
select
	show_id as id,
	LOWER(type) as type,
	title,
	LOWER(coalesce(rating, 'not_rated')) as rating,
	TO_DATE(TRIM(date_added), 'Month DD, YYYY') as date_added,
	release_year::INTEGER,
	case
		when duration is not null then SPLIT_PART(duration, ' ', 1)::INTEGER
		else null
	end as duration_value,
	case
		when duration is not null then LOWER(replace(split_part(duration, ' ', 2), 'seasons', 'season'))
		else null
	end as duration_unit,
	description,
	director,
	"cast" as cast_members,
	country,
	listed_in as genres
from
	raw_titles;

insert
	into
	genres(name)
select
	distinct lower(trim(unnest(string_to_array(listed_in, ','))))
from
	raw_titles
order by
	1;

with all_countries as (
select
	lower(trim(unnest(string_to_array(country, ',')))) as country_name
from
	raw_titles
where
	country is not null 
)
insert
	into
	countries (name)
select
	distinct country_name
from
	all_countries
where
	country_name != ''
order by
	1;

insert
	into
	actors (name)
select
	distinct trim(unnest(string_to_array("cast", ',')))
from
	raw_titles
where
	"cast" is not null
order by
	1;

insert
	into
	directors (name)
select
	distinct trim(unnest(string_to_array(director, ',')))
from
	raw_titles
where
	director is not null
order by
	1;

insert
	into
	titles_by_genre (show_id, genre_id)
select
	t.id,
	g.id
from
	titles_clean t
join genres g on
	g.name in (
	select
		lower(trim(unnest(string_to_array(t.genres, ',')))));

with imputed_countries as (
    select
      show_id,
      coalesce(country,
        CASE
            WHEN description ILIKE '%Poland%' THEN 'Poland'
            WHEN description ILIKE '%Chicago%' OR description ILIKE '%New York%' THEN 'United States'
            WHEN description ILIKE '%Peru%' THEN 'Peru'
            WHEN description ILIKE '%São Paulo%' OR description ILIKE '%Brazilian%' THEN 'Brazil'
            WHEN description ILIKE '%French%' THEN 'France'
            WHEN description ILIKE '%Egypt%' THEN 'Egypt'
            WHEN description ILIKE '%Palestinian%' THEN 'Palestine'
            WHEN description ILIKE '%Berlin%' OR description ILIKE '%German%' THEN 'Germany'
            WHEN description ILIKE '%Nigerian%' OR description ILIKE '%Nigeria%' THEN 'Nigeria'
            WHEN description ILIKE '%Canadian%' THEN 'Canada'
            WHEN description ILIKE '%Colombia%' THEN 'Colombia'
            WHEN description ILIKE '%Russia%' THEN 'Russia'
            WHEN description ILIKE '%Australia%' THEN 'Australia'
            WHEN description ILIKE '%Amsterdam%' THEN 'Netherlands'
            WHEN description ILIKE '%Mexico%' THEN 'Mexico'
            ELSE NULL 
        END,
        CASE
            WHEN listed_in ILIKE '%korean%' THEN 'South Korea'
            WHEN listed_in ILIKE '%british%' THEN 'United Kingdom'
            WHEN listed_in ILIKE '%anime%' OR listed_in ILIKE '%japanese%' OR description ILIKE '%samurai%' OR description ILIKE '%yakuza%' OR description ILIKE '%Japan%' THEN 'Japan'
            WHEN listed_in ILIKE '%spanish-language%' OR listed_in ILIKE '%spanish%' THEN 'Spain'
            WHEN listed_in ILIKE '%indian%' THEN 'India'
            WHEN listed_in ILIKE '%turkish%' THEN 'Turkey'
            WHEN listed_in ILIKE '%chinese%' THEN 'China'
            ELSE null 
        end
      ) as final_country
    from raw_titles 
),
pairs as (select distinct show_id, lower(trim(unnest(string_to_array(final_country, ',')))) as country_name from imputed_countries)
--select p.show_id, c.id from pairs p join countries c on p.country_name = c.name;
insert into titles_by_country (show_id, country_id) select p.show_id, c.id from pairs p join countries c on p.country_name = c.name;

with aux as (
select
	distinct show_id,
	trim(unnest(string_to_array("cast", ','))) as actor_name
from
	raw_titles
where
	"cast" is not null)
insert
	into
	titles_by_actor (show_id,
	actor_id)
select
	aux.show_id,
	a.id
from
	aux
join actors a on
	aux.actor_name = a.name;

WITH title_director_pairs AS (
    SELECT DISTINCT
        t.id AS show_id,
        LOWER(TRIM(unnest(string_to_array(t.director, ',')))) AS director_name
    FROM
        titles_clean t
    WHERE
        t.director IS NOT NULL AND t.director != ''
)
INSERT INTO titles_by_director (show_id, director_id)
SELECT
    p.show_id,
    d.id
FROM
    title_director_pairs p
JOIN
    directors d ON p.director_name = d.name;

