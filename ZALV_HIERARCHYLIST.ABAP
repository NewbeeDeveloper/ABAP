*&-----------------------------------------------------------------------------
*& Report  ZALV_HIERARCHYLIST                                                    *
*& Author : Swarna.S.                                                            *
*&-----------------------------------------------------------------------------
*& AS : ALV code for simple hierarchical sequential list display(single child)   
*& List of SAP tables and their characteristics are displayed as the header
*& table ( the parent table) and the list of fields and their characteristics 

*& form the item table(child table)                                                   
*&----------------------------------------------------------------------------  

REPORT  ZALV_HIERARCHYLIST .

* type-pools declarations for alv and icon
TYPE-POOLS: slis,icon.

*structure declaration for table details
TYPES : BEGIN OF ty_dd02l,
        icon type icon_d,
        tabname TYPE tabname,
        tabclass TYPE tabclass,
        contflag type contflag,
        actflag type actflag,
        mainflag type maintflag,
        buffered type buffered,
        as4user type as4user,
        as4date type as4date,
        as4time type as4time,
        expand,
        END OF ty_dd02l.

*internal table and wa decln for table details
DATA : it_dd02l TYPE STANDARD TABLE OF ty_dd02l,
       wa_dd02l TYPE ty_dd02l.

*structure declarations for field details
TYPES : BEGIN OF ty_dd03l,
        tabname TYPE tabname,
        fieldname TYPE fieldname,
        keyflag type keyflag,
        mandatory type mandatory,
        checktable type checktable,
        rollname type rollname,
        END OF ty_dd03l.

*Internal table and wa decln for field details
DATA : it_dd03l TYPE STANDARD TABLE OF ty_dd03l,
       wa_dd03l TYPE ty_dd03l.

*data declarations for ALV

DATA : it_fieldcat TYPE slis_t_fieldcat_alv,
       wa_fieldcat TYPE slis_fieldcat_alv,
       it_layout TYPE slis_layout_alv,
       key TYPE slis_keyinfo_alv.

*Input the tables.User cannot enter a range but can enter any number
*of tables one by one in this select-options
SELECT-OPTIONS : s_table FOR wa_dd02l-tabname NO INTERVALS.

*initializatin event
INITIALIZATION.
*start-of-selection event
START-OF-SELECTION.

*subroutine to fetch the data from the tables
  PERFORM fetch_tabledata.
*subroutine to build alv hierarchy output
  PERFORM hierarchyalv_build.

*&---------------------------------------------------------------------*
*&      Form  hierarchyalv_build
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form hierarchyalv_build .

*fieldcatalogue
perform build_fieldcat.
*layout
perform build_layout.
*key information for hierarchy
perform build_key.
*output
perform list_display.

endform.                    " hierarchyalv_build
*&---------------------------------------------------------------------*
*&      Form  build_fieldcat
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form build_fieldcat .

  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos = 1.
  wa_fieldcat-fieldname = 'TABNAME'.
  wa_fieldcat-tabname = 'IT_DD02L'.
  wa_fieldcat-seltext_m = 'Tablename'.
  wa_fieldcat-key = 'X'.
  wa_fieldcat-emphasize = 'C610'.
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR wa_fieldcat.
  wa_fieldcat-col_pos = 2.
  wa_fieldcat-fieldname = 'TABCLASS'.
  wa_fieldcat-tabname = 'IT_DD02L'.
  wa_fieldcat-seltext_m = 'Tablecategory'.
    wa_fieldcat-emphasize = 'C600'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  CLEAR wa_fieldcat.
  wa_fieldcat-col_pos = 3.
  wa_fieldcat-fieldname = 'CONTFLAG'.
  wa_fieldcat-tabname = 'IT_DD02L'.
  wa_fieldcat-seltext_m = 'DeliveryClass'.
    wa_fieldcat-emphasize = 'C510'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

 CLEAR wa_fieldcat.
  wa_fieldcat-col_pos = 4.
  wa_fieldcat-fieldname = 'ACTFLAG'.
  wa_fieldcat-tabname = 'IT_DD02L'.
  wa_fieldcat-seltext_m = 'Activationstatus'.
  wa_fieldcat-emphasize = 'C500'.

  APPEND wa_fieldcat TO it_fieldcat.

   CLEAR wa_fieldcat.

  wa_fieldcat-col_pos = 5.
  wa_fieldcat-fieldname = 'MAINFLAG'.
  wa_fieldcat-tabname = 'IT_DD02L'.
  wa_fieldcat-seltext_m = 'MaintainenceFlag'.
    wa_fieldcat-emphasize = 'C410'.

  APPEND wa_fieldcat TO it_fieldcat.

CLEAR wa_fieldcat.
  wa_fieldcat-col_pos = 6.
  wa_fieldcat-fieldname = 'BUFFERED'.
  wa_fieldcat-tabname = 'IT_DD02L'.
  wa_fieldcat-seltext_m = 'BufferFlag'.
  wa_fieldcat-emphasize = 'C400'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

CLEAR wa_fieldcat.
  wa_fieldcat-col_pos = 7.
  wa_fieldcat-fieldname = 'AS4USER'.
  wa_fieldcat-tabname = 'IT_DD02L'.
  wa_fieldcat-seltext_m = 'User'.
  wa_fieldcat-emphasize = 'C310'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

CLEAR wa_fieldcat.
  wa_fieldcat-col_pos = 8.
  wa_fieldcat-fieldname = 'AS4DATE'.
  wa_fieldcat-tabname = 'IT_DD02L'.
    wa_fieldcat-seltext_m = 'Date'.
  wa_fieldcat-emphasize = 'C300'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

CLEAR wa_fieldcat.
  wa_fieldcat-col_pos = 9.
  wa_fieldcat-fieldname = 'AS4TIME'.
  wa_fieldcat-tabname = 'IT_DD02L'.
    wa_fieldcat-seltext_m = 'Time'.
  wa_fieldcat-emphasize = 'C210'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos = 10.
  wa_fieldcat-fieldname = 'ICON'.
  wa_fieldcat-tabname = 'IT_DD02L'.
  wa_fieldcat-seltext_m = 'ICON'.
  wa_fieldcat-ICON = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos = 11.
  wa_fieldcat-fieldname = 'FIELDNAME'.
  wa_fieldcat-tabname = 'IT_DD03L'.
  wa_fieldcat-key = 'X'.
  wa_fieldcat-seltext_m = 'Field'.
  wa_fieldcat-EMPHASIZE = 'C600'.

  APPEND wa_fieldcat TO it_fieldcat.

 CLEAR wa_fieldcat.

  wa_fieldcat-col_pos = 12.
  wa_fieldcat-fieldname = 'KEYFLAG'.
  wa_fieldcat-tabname = 'IT_DD03L'.
  wa_fieldcat-seltext_m = 'Key'.
  wa_fieldcat-EMPHASIZE = 'C500'.

  APPEND wa_fieldcat TO it_fieldcat.


 CLEAR wa_fieldcat.

  wa_fieldcat-col_pos = 13.
  wa_fieldcat-fieldname = 'CHECKTABLE'.
  wa_fieldcat-tabname = 'IT_DD03L'.
  wa_fieldcat-seltext_m = 'Checktable'.
  wa_fieldcat-EMPHASIZE = 'C400'.

  APPEND wa_fieldcat TO it_fieldcat.

 CLEAR wa_fieldcat.

  wa_fieldcat-col_pos = 14.
  wa_fieldcat-fieldname = 'MANDATORY'.
  wa_fieldcat-tabname = 'IT_DD03L'.
  wa_fieldcat-seltext_m = 'Mandatory'.
    wa_fieldcat-EMPHASIZE = 'C300'.

  APPEND wa_fieldcat TO it_fieldcat.

 CLEAR wa_fieldcat.

  wa_fieldcat-col_pos = 15.
  wa_fieldcat-fieldname = 'ROLLNAME'.
  wa_fieldcat-tabname = 'IT_DD03L'.
  wa_fieldcat-seltext_m = 'Dataelement'.
  wa_fieldcat-EMPHASIZE = 'C200'.

  APPEND wa_fieldcat TO it_fieldcat.

endform.                    " build_fieldcat
*&---------------------------------------------------------------------*
*&      Form  build_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form build_layout .

*to expand the header table for item details
  it_layout-expand_fieldname = 'EXPAND'.

  it_layout-window_titlebar = 'Hierarchical ALV list display'.
  it_layout-lights_tabname = 'IT_DD03L'.
  it_layout-colwidth_optimize = 'X'.

endform.                    " build_layout
*&---------------------------------------------------------------------*
*&      Form  build_key
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form build_key .

*key infomation for the header and item table
  key-header01 = 'TABNAME'.
  key-item01 = 'TABNAME'.

endform.                    " build_key

*&---------------------------------------------------------------------*
*&      Form  list_display
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form list_display .

*ALV output
  CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
    EXPORTING
      i_callback_program = sy-cprog
      is_layout          = it_layout
      it_fieldcat        = it_fieldcat
      i_tabname_header   = 'IT_DD02L'
      i_tabname_item     = 'IT_DD03L'
      is_keyinfo         = key
    TABLES
      t_outtab_header    = it_dd02l
      t_outtab_item      = it_dd03l.

endform.                    " list_display
*&---------------------------------------------------------------------*
*&      Form  fetch_tabledata
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form fetch_tabledata .

*select table data
 SELECT tabname
         tabclass
         contflag
         actflag
         mainflag
         buffered
         as4user
         as4date
         as4time
         FROM dd02l
         INTO CORRESPONDING FIELDS OF TABLE it_dd02l
         WHERE tabname IN s_table.

*select field data
  IF it_dd02l[] IS NOT INITIAL.

    SELECT tabname
          fieldname
          keyflag
          mandatory
          checktable
          rollname
          FROM dd03l
          INTO CORRESPONDING FIELDS OF TABLE it_dd03l
          FOR ALL ENTRIES IN it_dd02l
          WHERE tabname EQ it_dd02l-tabname.

  ENDIF.

*adding icon to the header table
loop at it_dd02l into wa_dd02l.

at new tabname.

wa_dd02l-icon = '@3M@'.

MODIFY it_dd02l FROM wa_dd02l TRANSPORTING icon WHERE tabname EQ wa_dd02l-tabname.
CLEAR :  wa_dd02l.

endat.

endloop.

endform.    
