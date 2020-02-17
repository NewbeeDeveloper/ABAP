*&---------------------------------------------------------------------*
*& Report z02_adbc_p100220
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_adbc_p100220.

"Variable que se requieren para hacer la consulta SQL

DATA: go_connection TYPE REF TO cl_sql_connection.
DATA: go_statement  TYPE REF TO cl_sql_statement.
DATA: go_result TYPE REF TO cl_sql_result_set,
      gx_sql_ex TYPE REF TO cx_sql_exception,

      gv_sql    TYPE string,
      gr_result TYPE REF TO data,
      gt_flight TYPE STANDARD TABLE OF sflight.

TRY.
    "Obtenemos la conexión
    go_connection = cl_sql_connection=>get_connection( 'P100220HDB' ).

    "Creamos el objeto que ejecutará la sentencia
    CREATE OBJECT go_statement EXPORTING con_ref = go_connection.

    "Sentencia en caso de querer conectarnos a una base de datos primaria
    "go_statement = new cl_sql_statement( ).

    "Simplificar sentencia con almohadilla
    "go_statement = new #( ).

    "Realizamos la sentencia de consulta
    gv_sql = |SELECT * FROM "P100220"."SFLIGHT" WHERE CARRID = 'LH'|.

    "Realizamos el Query
    go_result = go_statement->execute_query( gv_sql ).

    "Realizamos un referencia para obtener los datos en la tabla interna
    GET REFERENCE OF gt_flight INTO gr_result.

    go_result->set_param_table( gr_result ).

    "Liberamos los registros
    go_result->next_package( ).

    "Cerramos conexión
    go_result->close( ).

  CATCH cx_sql_exception INTO gx_sql_ex.  "Excepciones
    WRITE gx_sql_ex->get_text( ).
ENDTRY.

IF NOT gt_flight IS  INITIAL.
  cl_demo_output=>display( gt_flight ).
ELSE.
  WRITE 'No hay registros'.
ENDIF.

BREAK-POINT.
