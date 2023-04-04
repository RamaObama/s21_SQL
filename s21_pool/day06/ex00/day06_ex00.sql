-- Let’s expand our data model to involve a new business feature.
--
-- Every person wants to see a personal discount and every business wants to be closer for clients.
-- Please think about personal discounts for people from one side and pizzeria restaurants from other.
-- Need to create a new relational table (please set a name person_discounts) with the next rules.
--
-- set id attribute like a Primary Key (please take a look on id column in existing tables and choose the same data type)
-- set for attributes person_id and pizzeria_id foreign keys for corresponding tables (data types should be the same like for id columns in corresponding parent tables)
-- please set explicit names for foreign keys constraints by pattern fk_{table_name}_{column_name},  for example fk_person_discounts_person_id
--
-- add a discount attribute to store a value of discount in percent.
-- Remember, discount value can be a number with floats (please just use numeric data type).
-- So, please choose the corresponding data type to cover this possibility.

CREATE TABLE person_discounts
(
    id          BIGINT PRIMARY KEY,
    person_id   BIGINT NOT NULL,
    pizzeria_id BIGINT NOT NULL,
    discount    NUMERIC,
    CONSTRAINT fk_person_discounts_person_id FOREIGN KEY (person_id) REFERENCES person (id),
    CONSTRAINT fk_person_discounts_pizzeria_id FOREIGN KEY (pizzeria_id) REFERENCES pizzeria (id)
);