-- Please change the price for “greek pizza” on -10% from the current value.
--
-- Warning: this exercise will probably be the cause  of changing data in the wrong way. Actually, you can restore the initial database model with data from the link in the “Rules of the day” section and replay script from Exercises 07 , 08 ,09 and 10.

UPDATE menu
SET price = price - (0.1 * menu.price)
WHERE pizza_name = 'greek pizza';

-- SELECT * FROM menu;