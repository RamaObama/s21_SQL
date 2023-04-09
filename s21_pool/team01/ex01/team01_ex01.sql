-- Please write a SQL statement that returns all Users , all Balance transactions (in this task please ignore currencies that do not have a key in the Currency table )
-- with currency name and calculated value of currency in USD for the nearest day.
--
-- need to find a nearest rate_to_usd of currency at the past (t1)
-- if t1 is empty (means no any rates at the past) then find a nearest rate_to_usd of currency at the future (t2)
-- use t1 OR t2 rate to calculate a currency in USD format

-- INSERT INTO currency
-- VALUES (100, 'EUR', 0.85, '2022-01-01 13:29');
-- INSERT INTO currency
-- VALUES (100, 'EUR', 0.79, '2022-01-08 13:29');

SELECT COALESCE("user".name, 'not defined')     AS name,
       COALESCE("user".lastname, 'not defined') AS lastname,
       cur.name                                 AS currency_name,
       cur.money * COALESCE(min, max)           AS currency_in_usd
FROM (SELECT balance.user_id,
             currency.id,
             currency.name,
             balance.money,
             (SELECT currency.rate_to_usd
              FROM currency
              WHERE currency.id = balance.currency_id
                AND currency.updated < balance.updated
              ORDER BY rate_to_usd
              LIMIT 1) AS min,
             (SELECT currency.rate_to_usd
              FROM currency
              WHERE currency.id = balance.currency_id
                AND currency.updated > balance.updated
              ORDER BY rate_to_usd
              LIMIT 1) AS max
      FROM currency
               JOIN balance ON currency.id = balance.currency_id
      GROUP BY balance.money,
               currency.name,
               currency.id,
               balance.updated,
               balance.currency_id,
               balance.user_id
      ORDER BY min DESC, max) AS cur
         LEFT JOIN "user" ON cur.user_id = "user".id
ORDER BY name DESC, lastname, currency_name