create table User(
				user_id varchar(10) primary key,
                user_name varchar(20),
                user_added_date date,
                user_password varchar(20),
                user_mobile char(20)
);

create table Note(
				note_id varchar(10) primary key,
                note_title char(20),
                note_content char(30),
                note_status char(10),
                note_creation_date date                
);
create table Category(
				category_id varchar(10) primary key,
                category_name char(20),
                category_descr char(20),
                category_creattion_date date,
                category_creator char(20)
);

create table Reminder(
				reminder_id varchar(10) primary key,
                reminder_name char(10),
                reminder_descr char(20),
                reminder_type char(20),
                reminder_creation_date date,
                reminder_creator char(20)
);

create table NoteCategory(
				notecategory_id varchar(10) primary key,
                note_id varchar(10) not null,
                category_id varchar(10) not null
);

create table NoteReminder(
				notereminder_id varchar(10) primary key,
                note_id varchar(10) not null,
                reminder_id varchar(10) not null
);

create table usernote(
				usernote_id varchar(10) primary key,
                user_id varchar(10) not null,
                note_id varchar(10) not null
);


INSERT INTO User (`user_id`, `user_name`, `user_added_date`, `user_password`, `user_mobile`) VALUES ('u1', 'amit', '2010-2-10', 'amit', 'android');
INSERT INTO User (`user_id`, `user_name`, `user_added_date`, `user_password`, `user_mobile`) VALUES ('u2', 'kunal', '2010-10-10', 'kunal', 'iphone');


INSERT INTO Note (`note_id`, `note_title`, `note_content`, `note_status`, `note_creation_date`) VALUES ('n1', 'note_a', 'note', 'true', '2020-01-01');
INSERT INTO Note (`note_id`, `note_title`, `note_content`, `note_status`, `note_creation_date`) VALUES ('n2', 'note_b', 'note', 'true', '2020-02-01');

INSERT INTO Category (`category_id`, `category_name`, `category_descr`, `category_creattion_date`, `category_creator`) VALUES ('c1', 'category_a', 'category', '2020-01-01', 'admin');
INSERT INTO Category (`category_id`, `category_name`, `category_descr`, `category_creattion_date`, `category_creator`) VALUES ('c2', 'category_b', 'category', '2020-02-01', 'me');

INSERT INTO Reminder (`reminder_id`, `reminder_name`, `reminder_descr`, `reminder_type`, `reminder_creation_date`, `reminder_creator`) VALUES ('r1', 'reminder_a', 'reminder', 'urgent', '2020-02-02', 'admin');
INSERT INTO Reminder (`reminder_id`, `reminder_name`, `reminder_descr`, `reminder_type`, `reminder_creation_date`, `reminder_creator`) VALUES ('r2', 'reminder_b', 'reminder', 'unusual', '2020-01-10', 'me');

INSERT INTO NoteCategory (`notecategory_id`, `note_id`, `category_id`) VALUES ('nc1', 'n1', 'c1');
INSERT INTO NoteCategory (`notecategory_id`, `note_id`, `category_id`) VALUES ('nc2', 'n2', 'c2');

INSERT INTO NoteReminder (`notereminder_id`, `note_id`, `reminder_id`) VALUES ('nr1', 'n1', 'r1');
INSERT INTO NoteReminder (`notereminder_id`, `note_id`, `reminder_id`) VALUES ('nr2', 'n2', 'r2');

INSERT INTO usernote (`usernote_id`, `user_id`, `note_id`) VALUES ('un1', 'u1', 'n1');
INSERT INTO usernote (`usernote_id`, `user_id`, `note_id`) VALUES ('un2', 'u2', 'n2');


select * from User where user_id='u1' and user_password='amit';

select * from Note where note_creation_date='2020-01-01';

select category_name from Category where category_creattion_date>'2020-01-01';

select note_id from usernote where user_id='u2';

update Note set note_content='abc' where note_id='note1';

select * from Note inner join usernote on Note.note_id=usernote.note_id where user_id='u1';

select * from Note inner join NoteCategory on Note.note_id=NoteCategory.note_id where category_id='c1';

select * from Reminder where reminder_id=(select reminder_id from NoteReminder where note_id='n1');

select * from Reminder where reminder_id='r1';

INSERT INTO Note (`note_id`, `note_title`, `note_content`, `note_status`, `note_creation_date`) VALUES ('n3', 'note_a', 'note', 'true', '2020-03-01');
INSERT INTO usernote (`usernote_id`, `user_id`, `note_id`) VALUES ('un3', 'u3', 'n3');

INSERT INTO Note (`note_id`, `note_title`, `note_content`, `note_status`, `note_creation_date`) VALUES ('n3', 'note_a', 'note', 'true', '2020-03-01');
INSERT INTO usernote (`usernote_id`, `user_id`, `note_id`) VALUES ('un3', 'u3', 'n3');
INSERT INTO NoteCategory (`notecategory_id`, `note_id`, `category_id`) VALUES ('nc3', 'n3', 'c3');

INSERT INTO Reminder (`reminder_id`, `reminder_name`, `reminder_descr`, `reminder_type`, `reminder_creation_date`, `reminder_creator`) VALUES ('r3', 'reminder_a', 'reminder', 'urgent', '2020-02-02', 'admin');
INSERT INTO NoteReminder (`notereminder_id`, `note_id`, `reminder_id`) VALUES ('nr3', 'n5', 'r3');

delete from Note where note_id=(select note_id from usernote where user_id='u1');

delete from Note where note_id=(select note_id from NoteCategory where category_id='c2');

DELIMITER $$
CREATE TRIGGER `note_AFTER_DELETE` AFTER DELETE ON `note` FOR EACH ROW
BEGIN
delete from NoteCategory where note_id=old.note_id;
delete from NoteReminder where note_id=old.note_id;
delete from usernote where note_id=old.note_id;
END


DELIMITER $$
CREATE TRIGGER `user_AFTER_DELETE` AFTER DELETE ON `user` FOR EACH ROW BEGIN
delete from usernote where user_id=old.user_id;
END
DELIMITER $$
CREATE TRIGGER `usernote_BEFORE_DELETE` BEFORE DELETE ON `usernote` FOR EACH ROW BEGIN
delete from Note where note_id=old.note_id;
delete from NoteCategory where note_id=old.note_id;
delete from NoteReminder where note_id=old.note_id;
END