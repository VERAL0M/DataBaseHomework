
create table types (
	id SERAIAL primary key,
	name TEXT not null unique 
);
create table goods (
id SERIAL primary key,
name TEXT not null,
cost INT not null,
type_id INT not null,
constraint fk_goods_type FOREGIN key (type_id) references type(id) on delete cascade
);

create table revies(
id serial primary key,
review_text TEXT not null,
good_id INT not null,
constraint fk_reviews_goods foreign key (good_id) references  goods(id) on delete cascade
);



insert  into types (name) values ('Продукты'), ('Одежда'), ('Электроника');


insert into goods (name, cost, type_id) values
('Ноутбук', 150000, 3),
('Банан', 180, 1), 
('Джинсы', 4000, 2);



insert into reviews (review_text, good_id) values
('Отличный ноутбук, быстрый!', 1),
('Ноутбук греется, но в целом ок', 1),
('Бананы сладкие, свежие', 2),
('Джинсы не подошли по размеру', 3);