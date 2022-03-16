drop table if exists users, tasks, projects, tasks2;


create table users (
	name varchar(32) not null,
	login varchar(32) not null,
	email varchar(32),
	department varchar(16) check (department in ('production', 'support', 'accounting', 'admimistration') ),
	primary key (login)
);

create table projects (
	name varchar(32),
	description text,
	date_start date not null,
	date_finish date,
	primary key (name)
);

create table tasks (
	project_name varchar(32) not null,
	name varchar(32) not null,
	priority int,
	description text,
	state varchar(16) check (state in ('new', 'reopened', 'in progress', 'closed') ),
	estimate int,
	spent int,
	performer varchar(32),
	creator varchar(32) not null,
	date_start date,
	task_key serial,
	primary key (task_key),
	foreign key (project_name) references projects (name),
	foreign key (performer) references users (login),
	foreign key (creator) references users (login)
);


insert into users (name, login, email, department) values
('Касаткин Артём', 'a.kasatkin', 'a.kasatkin@mail.ru', 'admimistration'),
('Петрова Софья', 's.petrova', 's.petrova@yandex.ru', 'accounting'),
('Дроздов Фёдр', 'f.drozdov', 'f.drozdov@outlook.com', 'support'),
('Иванова Васелина', 'v.ivanova', 'v.ivanova@gmail.com', 'accounting'),
('Беркут Алексей', 'a.berkut', 'a.berkut@ya.ru', 'production'),
('Белова Вера', 'v.belova', 'v.belova@gmail.com', 'admimistration'),
('Макенрой Алексей', 'a.makenroy', 'a.makenroy@mail.ru', 'support'),
('Петров Олег', 'o.petrov', 'o.petrov@mail.ru', 'production');

insert into projects (name, description, date_start, date_finish) values
('РТК', null, '2016/01/31', null),
('СС.Коннект', null, '2015/02/23', '2016/12/31'),
('Демо-Сибирь', null, '2015/05/11', '2015/01/31'),
('МВД-Онлайн', null, '2015/05/22', '5016/01/31'),
('Поддержка', null, '2016/06/07', null);

insert into tasks (project_name, name, priority, description, state, estimate, spent, performer, creator, date_start) values
('РТК', 'Важные дела', 30, 'очень важные', 'new', 28, 45, 'a.makenroy', 'v.belova', '2016/02/05'),
('СС.Коннект', '1', 40, '1', 'reopened', 14, 12, 'a.makenroy', 'a.berkut', '2015/02/04'),
('Демо-Сибирь', '2', 60, '2', 'new', 35, 16, 'f.drozdov', 'a.kasatkin', '2015/05/07'),
('МВД-Онлайн', 'покушать', 70, '', 'closed', 1, 2, 'a.berkut', 'f.drozdov', '2016/04/08'),
('Поддержка', '3', 10, '3', 'in progress', 45, 38, 'v.ivanova', 'a.kasatkin', '2016/02/01'),

('РТК', '4', 28, '', 'new', 72, 78, 'o.petrov', 'f.drozdov', '2016/02/05'),
('СС.Коннект', '5', 47, '', 'reopened', 68, 54, 'v.belova', 'a.berkut', '2015/02/04'),
('Демо-Сибирь', '6', 34, '', 'new', 19, 13, 'f.drozdov', 'o.petrov', '2015/05/07'),
('МВД-Онлайн', '7', 84, '', 'closed', 70, 82, 'a.berkut', 's.petrova', '2016/04/08'),
('Поддержка', '8', 18, '', 'in progress', 45, 46, 'o.petrov', 'a.kasatkin', '2016/02/01'),

('РТК', '9', 54, '', 'new', 54, 78, 'o.petrov', 'v.belova', '2016/02/05'),
('СС.Коннект', '10', 72, '', 'reopened', 12, 75, 'a.makenroy', 'a.berkut', '2015/02/04'),
('Демо-Сибирь', '11', 42, '', 'new', 53, 25, 'v.belova', 'o.petrov', '2015/05/07'),
('МВД-Онлайн', '12', 89, '', 'closed', 15, 15, 'a.berkut', 'f.drozdov', '2016/04/08'),
('Поддержка', '13', 45, '', 'in progress', 54, 74, 'o.petrov', 'a.kasatkin', '2016/02/01'),

('РТК', '14', 78, '', 'new', 24, 12, 'o.petrov', 'v.belova', '2016/02/05'),
('СС.Коннект', '15', 21, '', 'reopened', 78, 25, 'a.makenroy', 'v.belova', '2015/02/04'),
('Демо-Сибирь', '16', 45, '', 'new', 35, 45, 'f.drozdov', 'o.petrov', '2015/05/07'),
('МВД-Онлайн', '17', 68, '', 'closed', 24, 83, 'a.berkut', 's.petrova', '2016/04/08'),
('Поддержка', '18', 46, '', 'in progress', 27, 83, 'o.petrov', 'a.kasatkin', '2016/02/01');


-- 1-3 a
select *
from tasks;

select project_name, name, priority, description, state, estimate, spent, performer, creator, date_start, task_key
from tasks;

-- 1-3 b
select name, department
from users;

-- 1-3 c
select login, email
from users;

-- 1-3 d
select *
from tasks
where priority > 50;

-- 1-3 e
select distinct performer
from tasks
where performer is not null;

-- 1-3 f
select distinct performer
from tasks
where performer is not null
union select creator
from tasks;

-- 1-3 k
select *
from tasks
where creator != 's.petrova'
and performer in ('v.ivanova', 'f.drozdov', 'a.berkut');


-- 1-4
select *
from tasks
where performer = 'v.ivanova'
and date_start in ('2016/01/01', '2016/02/01', '2016/03/01');


-- 1-5
select *
from tasks
where performer = 'a.berkut'
and (select department from users where login = creator) in ('administration', 'accounting', 'production');


-- 1-6
insert into tasks (project_name, name, state, creator) values
('Поддержка', 'задача', 'reopened', 'a.kasatkin'),
('РТК', 'другая задача', 'closed', 'v.belova');

select *
from tasks
where performer is null;

update tasks
set performer = 's.petrova'
where performer is null;


-- 1-7
drop table if exists tasks2;

create table tasks2 (
	project_name varchar(32) not null,
	name varchar(32) not null,
	priority int,
	description text,
	state varchar(16) check (state in ('new', 'reopened', 'in progress', 'closed') ),
	estimate int,
	spent int,
	performer varchar(32),
	creator varchar(32) not null,
	date_start date,
	task_key serial,
	primary key (task_key),
	foreign key (project_name) references projects (name),
	foreign key (performer) references users (login),
	foreign key (creator) references users (login)
);

insert into tasks2 (project_name, name, priority, description, state, estimate, spent, performer, creator, date_start, task_key)
select * from tasks;


-- 1-8
select *
from users
where name not like '%а'
and login like 'p%r%'



-- 2-1
select performer, avg(priority) as avg_priority
from tasks
group by performer
order by avg_priority desc
limit 3;


-- 2-2
select concat(count(task_key), ' - ', extract (month from date_start), ' - ', performer) as request
from tasks
where extract (year from date_start) = '2015'
group by performer, extract (month from date_start);


-- 2-3
select distinct performer, (sum(abs(estimate - spent) ) + sum(estimate - spent) ) / 2 as nedo, (sum(abs(estimate - spent) ) + sum(spent - estimate) ) / 2 as pere
from tasks
where performer is not null
group by performer;


-- 2-4
select creator, performer
from tasks
where creator < performer
union
select creator, performer
from tasks
where creator > performer
union
select creator, performer
from tasks
where creator = performer;


-- 2-5
select login, length(login) as len
from users
order by len desc
limit 1;


-- 2-6
drop table if exists varchar_and_char;

create table varchar_and_char (
	char_data char(100),
	varchar_data varchar(100)
);

insert into varchar_and_char values
('this string is 30 symbols long', 'this string is 30 symbols long');

select pg_column_size(char_data) as char_size, pg_column_size(varchar_data) as varchar_size
from varchar_and_char;


-- 2-7
select performer, name, max(priority) as max_priority
from tasks
where performer is not null
group by performer, name
order by max_priority;


-- 2-8
select performer, sum(estimate) as sum_estimate
from tasks,
	(select avg(estimate) from tasks where state != 'closed') as A
where estimate >= A.avg
and performer is not null
and state != 'closed'
group by performer;


-- 2-9
drop view if exists stats;

create view stats as
select st.performer, count(st.task_key) as total_tasks,
(select count(on_time.task_key) from
	(select task_key, performer from tasks where (estimate - spent) >= 0)
	as on_time where on_time.performer = st.performer group by on_time.performer) as on_time,
(select count(delayed.task_key) from
	(select task_key, performer from tasks where (spent - estimate) > 0)
	as delayed where delayed.performer = st.performer group by delayed.performer) as delayed,
(select count(opened.task_key) from
	(select task_key, performer from tasks where state in ('reopened', 'new') )
	as opened where opened.performer = st.performer group by opened.performer) as opened,
(select count(closed.task_key) from
	(select task_key, performer from tasks where state = 'closed')
	as closed where closed.performer = st.performer group by closed.performer) as closed,
(select count(in_progress.task_key) from
	(select task_key, performer from tasks where state = 'in progress')
	as in_progress where in_progress.performer = st.performer group by in_progress.performer) as in_progress,
(select sum(total_spent.spent) from
	(select task_key, spent, performer from tasks where spent is not null)
	as total_spent where total_spent.performer = st.performer group by total_spent.performer) as total_spent,
(select sum(overwork.ovrwrk) from
	(select performer, task_key, (spent - estimate) as ovrwrk from tasks where (spent - estimate) >= 0)
	as overwork where overwork.performer = st.performer group by overwork.performer) as overwork,
(select sum(underwork.undrwrk) from
	(select performer, task_key, (estimate - spent) as undrwrk from tasks where (estimate - spent) >= 0)
	as underwork where underwork.performer = st.performer group by underwork.performer) as underwork,
(select sum(total_priority.priority) from
	(select task_key, performer, priority from tasks)
	as total_priority where total_priority.performer = st.performer group by total_priority.performer) as total_priority,
(select avg(avg_priority.priority) from
	(select task_key, performer, priority from tasks)
	as avg_priority where avg_priority.performer = st.performer group by avg_priority.performer) as avg_priority,
(select avg(avg_spent.spent) from
	(select task_key, spent, performer from tasks where spent is not null)
	as avg_spent where avg_spent.performer = st.performer group by avg_spent.performer) as avg_spent,
(select avg(avg_priority_above_50.priority) from
	(select task_key, performer, priority from tasks)
	as avg_priority_above_50 where avg_priority_above_50.performer = st.performer and avg_priority_above_50.priority > 50 group by avg_priority_above_50.performer) as avg_priority_above_50
from tasks st
group by st.performer;


-- 2-10
select users.login, tasks.name
from users, tasks
where users.login = tasks.performer;

select a.login, b.name
from (select login from users) as a,
	(select name, performer from tasks) as b
where a.login = b.performer;

select (select users.login from users where users.login = tasks.performer), tasks.name
from tasks;


-- 4-1
drop table if exists tA, tB;

create table tA (
	col integer
);

create table tB (
	col integer
);

insert into tA (col) values
(1),
(2),
(3);

insert into tB (col) values
(4),
(5),
(6);


select *
from tasks
full outer join users
on tasks.performer = users.login
where tasks.performer is null;

select *
from tasks
full outer join users
on tasks.performer = users.login;

select *
from tasks
inner join users
on tasks.performer = users.login;

select *
from tasks
left outer join users
on tasks.performer = users.login;

select *
from tasks
left outer join users
on tasks.performer = users.login
where users.login is null;

select *
from tasks
right join users
on tasks.performer = users.login;

select *
from tasks
right join users
on tasks.performer = users.login
where tasks.performer is null;


-- 4-2
select task_key, name, priority
from tasks
as out
where priority = (select max(priority) from tasks as int where int.creator = out.creator);

select out.task_key, out.name, out.priority
from tasks out
left join tasks int
on out.creator = int.creator
and int.priority > out.priority
where int.creator is null;


-- 4-5
select p.name, t.name
from tasks as t, projects as p;

select projects.name, tasks.name
from projects
cross join tasks;


-- 4-3
select *
from ta
union
select *
from tb;

select login
from users
where login in (select performer from tasks where performer is not null);

select u.login
from users as u, tasks as t
where t.performer = u.login;

select u.login
from users as u
left outer join tasks t
on u.login = t.performer
where t.performer is not null;


-- 5-1
update ta
set col = 1
where col = 999
or col = 888;

begin;
update tasks
set description = 'test 123'
where name = '1';
select pg_sleep(10);
update projects
set description = '123 test'
where name = 'РТК';
commit;

begin;
update projects
set description = '123 test'
where name = 'РТК';
select pg_sleep(10);
update tasks
set description = 'test 123'
where name = '1';
commit;