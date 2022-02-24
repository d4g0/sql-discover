#   SQL/Postgres build in Functions

## Numeric
-   max ( see text ) → same as input type
-   min ( see text ) → same as input type
-   sum ( smallint ) → bigint
-   count ( * ) → bigint
-   count ( "any" ) → bigint
-   avg ( integer ) → numeric

## Logics
-   bool_and ( boolean ) → boolean
-   bool_or ( boolean ) → boolean


## Cast
-   cast( column_reference as data_type) 
