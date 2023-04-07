-- Actually, there are 3 triggers for one person table. Let’s merge all our logic to the one main trigger
-- with the name trg_person_audit and a new corresponding trigger function fnc_trg_person_audit.
-- Other words, all DML traffic (INSERT, UPDATE, DELETE) should be handled from the one functional block.
-- Please explicitly define a separated IF-ELSE block for every event (I, U, D)!
-- Additionally, please take the steps below .
--
-- to drop 3 old triggers from the person table.
-- to drop 3 old trigger functions
-- to make a TRUNCATE (or DELETE) of all rows in our person_audit table
--
-- When you are ready, please re-apply the set of DML statements.
-- INSERT INTO person(id, name, age, gender, address)  VALUES (10,'Damir', 22, 'male', 'Irkutsk');
-- UPDATE person SET name = 'Bulat' WHERE id = 10;
-- UPDATE person SET name = 'Damir' WHERE id = 10;
-- DELETE FROM person WHERE id = 10;

DROP TRIGGER IF EXISTS trg_person_insert_audit ON person;
DROP TRIGGER IF EXISTS trg_person_update_audit ON person;
DROP TRIGGER IF EXISTS trg_person_delete_audit ON person;

DROP FUNCTION IF EXISTS fnc_trg_person_insert_audit();
DROP FUNCTION IF EXISTS fnc_trg_person_update_audit();
DROP FUNCTION IF EXISTS fnc_trg_person_delete_audit();

TRUNCATE TABLE person_audit CASCADE;

CREATE OR REPLACE FUNCTION fnc_trg_person_audit()
    RETURNS TRIGGER AS
$trg_person_audit$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO person_audit SELECT now(), 'I', new.*;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO person_audit SELECT now(), 'U', old.*;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO person_audit SELECT now(), 'D', old.*;
    END IF;
    RETURN NULL;
END;
$trg_person_audit$ LANGUAGE plpgsql;

CREATE TRIGGER trg_person_audit
    AFTER INSERT OR UPDATE OR DELETE
    ON person
    FOR EACH ROW
EXECUTE FUNCTION fnc_trg_person_audit();

INSERT INTO person(id, name, age, gender, address) VALUES (10,'Damir', 22, 'male', 'Irkutsk');
UPDATE person SET name = 'Bulat' WHERE id = 10;
UPDATE person SET name = 'Damir' WHERE id = 10;
DELETE FROM person WHERE id = 10;