-- Please write a SQL statement that returns the total volume (sum of all money) of transactions from user balance aggregated by user and balance type.
-- Please be aware, all data should be processed including data with anomalies.

WITH eur AS (SELECT *
             FROM currency
             WHERE name = 'EUR'
             ORDER BY updated DESC
             LIMIT 1),
     usd AS (SELECT *
             FROM currency
             WHERE name = 'USD'
             ORDER BY updated DESC
             LIMIT 1),
     jpy AS (SELECT *
             FROM currency
             WHERE name = 'JPY'
             ORDER BY updated DESC
             LIMIT 1),
     currency AS (SELECT *
                  FROM eur
                  UNION
                  SELECT *
                  FROM usd
                  UNION
                  SELECT *
                  FROM jpy)
SELECT COALESCE("user".name, 'not defined')                       AS name,
       COALESCE("user".lastname, 'not defined')                   AS lastname,
       balance.type                                               AS type,
       SUM(balance.money)                                         AS volume,
       COALESCE(currency.name, 'not defined')                     AS currency_name,
       COALESCE(currency.rate_to_usd, 1)                          AS last_rate_to_usd,
       SUM(COALESCE(balance.money, 1)) * COALESCE(rate_to_usd, 1) AS total_volume_in_usd
FROM "user"
         FULL JOIN balance ON balance.user_id = public."user".id
         FULL JOIN currency ON balance.currency_id = currency.id
GROUP BY "user".name,
         "user".lastname,
         balance.type,
         currency_name,
         currency.rate_to_usd
ORDER BY name DESC, lastname, type;