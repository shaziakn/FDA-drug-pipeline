SELECT *, REPLACE(REPLACE(REPLACE(REPLACE(street, "SOUTH", "S"), "NORTH", "N"), "WEST", "W"), "EAST", "E") AS abbr_street
FROM {{ ref("model8")}}
