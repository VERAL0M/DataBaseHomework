drop table if exists spec cascade;
drop table if exists test cascade;
drop table if exists test2 cascade;

create table spec(
	id int primary key,
	table_name varchar(255) not null,
	column_name varchar(255) not null,
	current_max_value int not null,
	unique(table_name, column_name)
	
);

insert into spec(id, table_name, column_name, current_max_value)
values(1, 'spec', 'id', 1);

create or replace function sync_max_value_func()
returns trigger as $$
declare
	v_col_name text;
	v_new_val int;
	v_current_max int;
begin
	v_col_name := tg_argv[0];
	
	
	execute format( 'SELECT ($1).%i', v_col_name) using new into v_new_val;
	
	select current_max_value into v_current_max
	from spec
	where table_name = TG_TABLE_NAME and column_name = v_col_name;
	
	if found and v_new_val is not null and v_new_val> v_current_max then
	update spec
	set current_max_value = v_new_val
	where table_name = TG_TABLE_NAME and column_name = v_col_name;
	
	end if;
	return new; 
--что я вохвращаю тут?
	

end;
$$ language plpgsql;

create or replace function get_next_id(p_table Text, p_column text)
returns int as $$
declare
	v_current_max int;
	v_next_val int;
	v_real_max int;
	v_tracker_id int;

begin
	select current_max_value into v_current_max
	from spec
	where table_name=p_table and column_name=p_column
	for update; --что это значит
	
	if found then
		v_next_val :=v_current_max +1;
		update spec
		set current_max_value = v_next_val
		where table_name=p_table and column_name=p_column;
		
		return v_next_val;
	
	else 
		execute format('select coalesce(MAX(%I), 0) from %I', p_column, p_table)
		into v_real_max;
		
		v_next_val :=v_real_max+1;
		
		v_tracker_id :=get_next_id('spec', 'id');
		
		INSERT INTO spec(id, table_name, column_name, current_max_value)
		values (v_tracker_id, p_table, p_column, v_next_val);
		
		begin
			execute format(
				'create trigger trg_sync_%I_%I '
				'after insert or update of %I ON %I '
				'for each row '
				'execute function sync_max_value_func(%L) ',
				p_table, p_column, p_column, p_table, p_column
			);
		exception when duplicate_object then
			null;
		end;
		return v_next_val;
	end if;
		
end;
$$ language plpgsql;



-- ==============================================================================
-- ТЕСТИРОВАНИЕ (Шаги 4-23)
-- ==============================================================================

-- ШАГ 4. Вызов ХП с параметрами 'spec', 'id'. Ожидается: 2
SELECT get_next_id('spec', 'id') AS step_4_result;

-- ШАГ 5. Распечатка spec. Ожидается: (1, spec, id, 2)
SELECT * FROM spec ORDER BY id;

-- ШАГ 6. Вызов ХП с параметрами 'spec', 'id'. Ожидается: 3
SELECT get_next_id('spec', 'id') AS step_6_result;

-- ШАГ 7. Распечатка spec. Ожидается: (1, spec, id, 3)
SELECT * FROM spec ORDER BY id;

-- ШАГ 8. Создание новой таблицы test
CREATE TABLE test (id INTEGER);

-- ШАГ 9. Добавление в test записи (10)
INSERT INTO test (id) VALUES (10);

-- ШАГ 10. Вызов ХП с параметрами 'test', 'id'. Ожидается: 11 (здесь сработает рекурсия)
SELECT get_next_id('test', 'id') AS step_10_result;

-- ШАГ 11. Распечатка spec. Ожидается: 2 строки "(1, spec, id, 4)" и "(4, test, id, 11)"
SELECT * FROM spec ORDER BY id;

-- ШАГ 12. Вызов ХП с параметрами 'test', 'id'. Ожидается: 12
SELECT get_next_id('test', 'id') AS step_12_result;

-- ШАГ 13. Распечатка spec. Ожидается: "(1, spec, id, 4)" и "(4, test, id, 12)"
SELECT * FROM spec ORDER BY id;

-- ШАГ 14. Создание таблицы test2
CREATE TABLE test2 (num_value1 INTEGER, num_value2 INTEGER);

-- ШАГ 15. Вызов ХП с параметрами 'test2', 'num_value1'. Ожидается: 1
SELECT get_next_id('test2', 'num_value1') AS step_15_result;

-- ШАГ 16. Распечатка spec. Ожидается: 3 строки, последняя "(5, test2, num_value1, 1)"
SELECT * FROM spec ORDER BY id;

-- ШАГ 17. Вызов ХП с параметрами 'test2', 'num_value1'. Ожидается: 2
SELECT get_next_id('test2', 'num_value1') AS step_17_result;

-- ШАГ 18. Распечатка spec. Ожидается: "(5, test2, num_value1, 2)"
SELECT * FROM spec ORDER BY id;

-- ШАГ 19. Добавление в test2 записи (2, 13). 
-- ВНИМАНИЕ: Это проверка триггера! 13 не превышает текущий максимум (который станет 14 на шаге 20), 
-- но давайте сделаем хитрый тест: вставим 20, чтобы триггер сработал позже, или проверим логику.
-- По заданию: (2, 13). 
INSERT INTO test2 (num_value1, num_value2) VALUES (2, 13);

-- ШАГ 20. Вызов ХП с параметрами 'test2', 'num_value2'. Ожидается: 14
SELECT get_next_id('test2', 'num_value2') AS step_20_result;

-- ШАГ 21. Распечатка spec. Ожидается: 4 строки, последняя "(6, test2, num_value2, 14)"
SELECT * FROM spec ORDER BY id;

-- ШАГ 22. Вызов ХП с параметрами 'test2', 'num_value1' 5 раз. (Было 2, станет 7)
SELECT get_next_id('test2', 'num_value1');
SELECT get_next_id('test2', 'num_value1');
SELECT get_next_id('test2', 'num_value1');
SELECT get_next_id('test2', 'num_value1');
SELECT get_next_id('test2', 'num_value1');

-- ШАГ 23. Распечатка spec. Ожидается: "(5, test2, num_value1, 7)"
SELECT * FROM spec ORDER BY id;

-- ==============================================================================
-- ДОПОЛНИТЕЛЬНАЯ ПРОВЕРКА ТРИГГЕРА (Рассогласование)
-- Вставим значение 99 в обход ХП. Триггер должен автоматически обновить spec!
-- ==============================================================================
INSERT INTO test2 (num_value1) VALUES (99);
SELECT 'После вставки 99 в обход ХП, spec должен показать 99:' AS info;
SELECT * FROM spec WHERE table_name = 'test2' AND column_name = 'num_value1';

-- ==============================================================================
-- ШАГИ 24-25. Удаление ХП и таблиц (Очистка)
-- ==============================================================================
DROP FUNCTION IF EXISTS get_next_id(TEXT, TEXT) CASCADE;
DROP FUNCTION IF EXISTS sync_max_value_func() CASCADE;
DROP TABLE IF EXISTS spec CASCADE;
DROP TABLE IF EXISTS test CASCADE;
DROP TABLE IF EXISTS test2 CASCADE;





















