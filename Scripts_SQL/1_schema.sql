drop table if exists titles_clean cascade;
CREATE TABLE titles_clean (
    id VARCHAR(10) PRIMARY KEY,
    type TEXT,
    title TEXT,
    rating VARCHAR(50),
    date_added DATE,
    release_year INTEGER,
    duration_value INTEGER,
    duration_unit VARCHAR(10),
    description TEXT,
    director TEXT,
    cast_members TEXT,
    country TEXT,
    genres TEXT
);

drop table if exists genres cascade;
create table genres (
    id serial primary key,
    name varchar(255) unique not null
);

drop table if exists countries cascade;
create table countries (
    id serial primary key,
    name varchar(255) unique not null
);

drop table if exists actors cascade;
create table actors (
    id serial primary key,
    name varchar(255) unique not null
);

drop table if exists directors cascade;
create table directors (
    id serial primary key,
    name varchar(255) unique not null
);

drop table if exists titles_by_genre cascade;
create table titles_by_genre (
    show_id varchar(10) references titles_clean(id),
    genre_id integer references genres(id),
    primary key (show_id, genre_id)
);

drop table if exists titles_by_country cascade;

create table titles_by_country (
    show_id varchar(10) references titles_clean(id),
    country_id integer references countries(id),
    primary key (show_id, country_id)
);

drop table if exists titles_by_actor cascade;

create table titles_by_actor (show_id varchar(10) references titles_clean(id),
actor_id integer references actors(id),
primary key (show_id,
actor_id));

drop table if exists titles_by_director cascade;

create table titles_by_director (
    show_id varchar(10) references titles_clean(id),
    director_id integer references directors(id),
    primary key (show_id, director_id)
);