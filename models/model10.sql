SELECT *, REPLACE(REPLACE(REPLACE(REPLACE(address, "SOUTH", "S"), "NORTH", "N"), "WEST", "W"), "EAST", "E") AS abbr_address
FROM {{ ref("hospital_general_info")}}
