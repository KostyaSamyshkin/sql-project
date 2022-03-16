drop table if exists classes, lessons, parents, students, students_parents_link, teachers, teachers_lessons_link, homework, marks, rebukes;

CREATE  TABLE classes (
	name                 varchar(3)  NOT NULL  ,
	CONSTRAINT pk_classes PRIMARY KEY ( name )
 );

CREATE  TABLE lessons (
	name                 varchar(50)  NOT NULL  ,
	CONSTRAINT pk_lessons PRIMARY KEY ( name )
 );

CREATE  TABLE parents (
	name                 varchar(50)  NOT NULL  ,
	gender               varchar(1)  NOT NULL  ,
	phone                varchar(20)  NOT NULL  ,
	"password"           varchar(50)  NOT NULL  ,
	username             varchar(50)  NOT NULL  ,
	CONSTRAINT pk_parents PRIMARY KEY ( username )
 );

CREATE  TABLE students (
	name                 varchar(50)  NOT NULL  ,
	class_name           varchar(3)  NOT NULL  ,
	gender               varchar(1)  NOT NULL  ,
	"password"           varchar(50)  NOT NULL  ,
	username             varchar(50)  NOT NULL  ,
	CONSTRAINT pk_studens PRIMARY KEY ( username ),
	CONSTRAINT fk_studens FOREIGN KEY ( class_name ) REFERENCES classes( name )
 );

CREATE  TABLE students_parents_link (
	student              varchar(50)  NOT NULL  ,
	parent               varchar(50)  NOT NULL  ,
	CONSTRAINT fk_students_parents_link FOREIGN KEY ( student ) REFERENCES students( username )   ,
	CONSTRAINT fk_students_parents_link_1 FOREIGN KEY ( parent ) REFERENCES parents( username )
 );

CREATE  TABLE teachers (
	name                 varchar(50)  NOT NULL  ,
	gender               varchar(1)  NOT NULL  ,
	"password"           varchar(50)  NOT NULL  ,
	username             varchar(50)  NOT NULL  ,
	CONSTRAINT pk_teachers PRIMARY KEY ( username )
 );

CREATE  TABLE teachers_lessons_link (
	lesson               varchar(50)  NOT NULL  ,
	teacher              varchar(50)  NOT NULL  ,
	CONSTRAINT fk_teachers_lessons_link FOREIGN KEY ( lesson ) REFERENCES lessons( name )   ,
	CONSTRAINT fk_teachers_lessons_link_1 FOREIGN KEY ( teacher ) REFERENCES teachers( username )
 );

CREATE  TABLE homework (
	id                   serial  NOT NULL  ,
	date_on              date DEFAULT CURRENT_DATE NOT NULL  ,
	class_name           varchar(3)  NOT NULL  ,
	lesson               varchar(50)  NOT NULL  ,
	teacher              varchar(50)  NOT NULL  ,
	text                 text  NOT NULL  ,
	CONSTRAINT pk_homework PRIMARY KEY ( id ),
	CONSTRAINT fk_homework_classes FOREIGN KEY ( class_name ) REFERENCES classes( name )   ,
	CONSTRAINT fk_homework_1 FOREIGN KEY ( teacher ) REFERENCES teachers( username )   ,
	CONSTRAINT fk_homework_lessons FOREIGN KEY ( lesson ) REFERENCES lessons( name )
 );

CREATE  TABLE marks (
	id                   serial  NOT NULL  ,
	"day"                date DEFAULT CURRENT_DATE NOT NULL  ,
	mark                 integer  NOT NULL  ,
	student              varchar(50)  NOT NULL  ,
	lesson               varchar(50)  NOT NULL  ,
	teacher              varchar(50)  NOT NULL  ,
	CONSTRAINT pk_marks PRIMARY KEY ( id ),
	CONSTRAINT fk_marks_students FOREIGN KEY ( student ) REFERENCES students( username )   ,
	CONSTRAINT fk_marks_1 FOREIGN KEY ( lesson ) REFERENCES lessons( name )   ,
	CONSTRAINT fk_marks_2 FOREIGN KEY ( teacher ) REFERENCES teachers( username )
 );

CREATE  TABLE rebukes (
	id                   serial  NOT NULL  ,
	"day"                date DEFAULT CURRENT_DATE NOT NULL  ,
	student              varchar(50)  NOT NULL  ,
	lesson               varchar(50)  NOT NULL  ,
	teacher              varchar(50)  NOT NULL  ,
	text                 text  NOT NULL  ,
	CONSTRAINT pk_rebukes PRIMARY KEY ( id ),
	CONSTRAINT fk_rebukes_students FOREIGN KEY ( student ) REFERENCES students( username )   ,
	CONSTRAINT fk_rebukes_1 FOREIGN KEY ( lesson ) REFERENCES lessons( name )   ,
	CONSTRAINT fk_rebukes_2 FOREIGN KEY ( teacher ) REFERENCES teachers( username )
 );





insert into teachers (name, gender, password, username) values
('Учитель1', 'Ж', 'qazWSX123', 'teacher1'),
('Учитель2', 'М', '123456789', 'teacher2');

insert into classes (name) values ('1А');

insert into lessons (name) values ('Биология');






drop function if exists register_student, register_parent, link_student_parent, add_homework, add_mark, add_rebuke;


create or replace function register_student(t_username varchar(50), s_name varchar(50), s_class_name varchar(3), s_gender varchar(1), s_password varchar(50), s_username varchar(50) ) returns varchar as
$$
declare
	username_t varchar;
	username_s varchar;
begin
	select username from teachers where username = t_username into username_t;

	insert into students (name, class_name, gender, password, username)
	values (s_name, s_class_name, s_gender, s_password, s_username);

	return 'Ученик зарегестрирован';
exception
	when others then return 'Error!';
end
$$ language plpgsql;

create or replace function register_parent(t_username varchar(50), p_name varchar(50), p_gender varchar(1), p_phone varchar(20), p_password varchar(50), p_username varchar(50) ) returns varchar as
$$
declare
	username_t varchar;
	username_p varchar;
begin
	select username from teachers where username = t_username into username_t;

	insert into parents (name, gender, phone, password, username)
	values (p_name, p_gender, p_phone, p_password, p_username);

	return 'Родитель зарегестрирован';
exception
	when others then return 'Error!';
end
$$ language plpgsql;

create or replace function link_student_parent(t_username varchar(50), p_username varchar(50), s_username varchar(50) ) returns varchar as
$$
declare
	username_t varchar;
begin
	select username from teachers where username = t_username into username_t;

	insert into students_parents_link (student, parent)
	values (s_username, p_username);

	return 'Аккаунты связаны';
exception
	when others then return 'Error!';
end
$$ language plpgsql;


create or replace function add_homework(t_username varchar(50), hw_date_on date, hw_class_name varchar(3), hw_lesson varchar(50), hw_text text) returns varchar as
$$
declare
	username_t varchar;
begin
	select username from teachers where username = t_username into username_t;

	insert into homework (date_on, class_name, lesson, teacher, text)
	values (hw_date_on, hw_class_name, hw_lesson, username_t, hw_text);

	return 'ДЗ добавлено';
exception
	when others then return 'Error!';
end
$$ language plpgsql;

create or replace function add_mark(t_username varchar(50), mrk_day date, mrk_mark integer, mrk_student varchar(50), mrk_lesson varchar(50) ) returns varchar as
$$
declare
	username_t varchar;
begin
	select username from teachers where username = t_username into username_t;

	insert into marks (day, mark, student, lesson, teacher)
	values (mrk_day, mrk_mark, mrk_student, mrk_lesson, username_t);

	return 'Отметка добавлена';
exception
	when others then return 'Error!';
end
$$ language plpgsql;

create or replace function add_rebuke(t_username varchar(50), rb_date_on date, rb_student varchar(50), rb_lesson varchar(50), rb_text text) returns varchar as
$$
declare
	username_t varchar;
begin
	select username from teachers where username = t_username into username_t;

	insert into rebukes (day, student, lesson, teacher, text)
	values (rb_date_on, rb_student, rb_lesson, username_t, rb_text);

	return 'Замечание добавлено';
exception
	when others then return 'Error!';
end
$$ language plpgsql;
