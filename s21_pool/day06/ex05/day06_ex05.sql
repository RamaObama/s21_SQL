-- To satisfy Data Governance Policies need to add comments for the table and table's columns.
-- Let’s apply this policy for the person_discounts table.
-- Please add English or Russian comments (it's up to you) that explain what is a business goal of a table and all included attributes.

COMMENT ON TABLE person_discounts IS
    'A table with the value of the discount for a customer in a certain establishment. The discount depends on the number of times the person visits the establishment.';

COMMENT ON COLUMN person_discounts.id IS 'Discount identity number.';

COMMENT ON COLUMN person_discounts.person_id IS 'The ID of the person to whom the discount is given.';

COMMENT ON COLUMN person_discounts.pizzeria_id IS 'The ID of the pizzeria providing the discount.';

COMMENT ON COLUMN person_discounts.discount IS 'Discount value in percent.';