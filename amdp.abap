CLASS zcl_amdp_demo_001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES: if_amdp_marker_hdb,
      if_oo_adt_classrun.

    TYPES:
      BEGIN OF ty_result_line,
        airline           TYPE s_carrname,
        flight_connection TYPE s_conn_id,
        old_price         TYPE s_price,
        old_currency      TYPE s_currcode,
        new_price         TYPE s_price,
        new_currency      TYPE s_currcode,
      END OF ty_result_line,

      BEGIN OF ty_flights_line,
        airline           TYPE s_carrname,
        flight_connection TYPE s_conn_id,
        price             TYPE s_price,
        currency          TYPE s_currcode,
      END OF ty_flights_line,

      ty_result_table  TYPE STANDARD TABLE OF ty_result_line WITH EMPTY KEY,
      ty_flights_table TYPE STANDARD TABLE OF ty_flights_line WITH EMPTY KEY,
      ty_flights       TYPE STANDARD TABLE OF sflights.


  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS:
      convert_currency
        IMPORTING
                  VALUE(flights) TYPE ty_flights_table
        EXPORTING
                  VALUE(result)  TYPE ty_result_table
        RAISING   cx_amdp_execution_error,
      get_flights
        EXPORTING
                  VALUE(result) TYPE ty_result_table
        RAISING   cx_amdp_execution_error.
    .
ENDCLASS.



CLASS zcl_amdp_demo_001 IMPLEMENTATION.

  METHOD convert_currency BY DATABASE PROCEDURE
                          FOR HDB
                          LANGUAGE SQLSCRIPT
                          OPTIONS READ-ONLY
                          .

    declare today date;
    declare new_currency nvarchar(3);

    select current_date into today from dummy;
    new_currency := 'EUR';

    result = select distinct
      airline, 
      flight_connection,
      price    as old_price,
      currency as old_currency,
      convert_currency(
        "AMOUNT"          => price,
        "SOURCE_UNIT"     => currency,
        "TARGET_UNIT"     => :new_currency,
        "REFERENCE_DATE"  => :today,
        "CLIENT"          => '100',
        "ERROR_HANDLING"  => 'set to null',
        "SCHEMA"          => current_schema
      ) as new_price,
      :new_currency as new_currency
      from :flights;

  ENDMETHOD.
  METHOD get_flights BY DATABASE PROCEDURE
                     FOR HDB
                     LANGUAGE SQLSCRIPT
                     OPTIONS READ-ONLY
                     USING sflight
                           scarr
                           zcl_amdp_demo_001=>convert_currency.

    flights = select distinct
                  c.carrid   as airline,
                  f.connid   as flight_connection,
                  f.price    as price,
                  f.currency as currency
                  from "SFLIGHT"  as f
                  inner join "SCARR" as c
                    on f.carrid = c.carrid;


    call "ZCL_AMDP_DEMO_001=>CONVERT_CURRENCY"(:flights, result);

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.


    TRY.
        me->get_flights(
          IMPORTING
            result = DATA(lt_result) ).

      CATCH cx_amdp_execution_error INTO DATA(lx_amdp).
        out->write( lx_amdp->get_longtext( ) ).
    ENDTRY.

    out->write( lt_result ).


  ENDMETHOD.

ENDCLASS.