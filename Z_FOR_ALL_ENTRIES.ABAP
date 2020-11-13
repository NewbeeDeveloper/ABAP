DATA city TYPE spfli-cityfrom VALUE 'FRANKFURT'.

cl_demo_input=>request( CHANGING field = city ).

SELECT carrid, connid
       FROM spfli
       WHERE cityfrom = @( to_upper( city ) )
       INTO TABLE @DATA(entry_tab).

IF entry_tab IS NOT INITIAL.
  SELECT carrid, connid, fldate
         FROM sflight
         FOR ALL ENTRIES IN @entry_tab
         WHERE carrid = @entry_tab-carrid AND
               connid = @entry_tab-connid
         ORDER BY PRIMARY KEY
         INTO TABLE @DATA(result_tab).
  cl_demo_output=>display( result_tab ).
ENDIF. 
