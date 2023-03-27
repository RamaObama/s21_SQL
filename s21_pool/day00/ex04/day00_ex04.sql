SELECT CONCAT(per.name, ' (age:', per.age, ',gender:''', per.gender,
              ''',address:''', per.address, ''')')
           AS person_information
FROM person AS per
ORDER BY person_information;