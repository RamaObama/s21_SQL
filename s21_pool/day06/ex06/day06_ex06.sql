-- Let’s create a Database Sequence with the name seq_person_discounts (starting from 1 value) and set a default value for id attribute of person_discounts table to take a value from seq_person_discounts each time automatically.
-- Please be aware that your next sequence number is 1, in this case please set an actual value for database sequence based on formula “amount of rows in person_discounts table” + 1.
-- Otherwise you will get errors about Primary Key violation constraint.

CREATE SEQUENCE seq_person_discounts START 1;

-- #1.
-- SELECT setval('seq_person_discounts', max(id))
-- FROM person_discounts;

-- #2. amount of rows in person_discounts
SELECT setval('seq_person_discounts', (SELECT count(*) FROM person_discounts));

ALTER TABLE person_discounts
    ALTER COLUMN id SET default nextval('seq_person_discounts');