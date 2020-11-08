*&---------------------------------------------------------------------*
*& Report  ZALV_LIST
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zalv_list.

***********************************************************************
* TYPE-POOLS DECLARATION
***********************************************************************
TYPE-POOLS:
slis.

***********************************************************************
* DATA DECLARATIONS
***********************************************************************

DATA:
  w_ebeln     TYPE ekko-ebeln,
  w_prog      TYPE sy-repid,
  t_fieldcat  TYPE slis_t_fieldcat_alv,
  fs_fieldcat LIKE LINE OF t_fieldcat,
  t_eventcat  TYPE slis_t_event,
  w_eventcat  LIKE LINE OF t_eventcat.

***********************************************************************
* SELECT-OPTIONS DECLARATION
***********************************************************************

SELECT-OPTIONS:
s_ebeln FOR w_ebeln.

***********************************************************************
* INTERNAL TABLE AND FIELD-STRING DECLARATIONS
***********************************************************************

DATA:
  t_ekko  LIKE
   STANDARD TABLE
   OF ekko,
  fs_ekko LIKE LINE OF t_ekko.

DATA:
  t_ekpo  LIKE
   STANDARD TABLE
   OF ekpo,
  fs_ekpo LIKE LINE OF t_ekpo.

***********************************************************************
* START-OF-SELECTION
***********************************************************************
START-OF-SELECTION.

  SELECT *
  FROM ekko
  INTO TABLE t_ekko
  WHERE ebeln IN s_ebeln.

  w_prog = sy-repid.

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      i_callback_program      = w_prog
      i_callback_user_command = 'PICK'
      i_structure_name        = 'EKKO'
    TABLES
      t_outtab                = t_ekko
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
* WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

*&--------------------------------------------------------------------*
*& Form pick
*&--------------------------------------------------------------------*
* -->UCOMM text
* -->SELFIELD text
*---------------------------------------------------------------------*
FORM pick USING command LIKE sy-ucomm
selfield TYPE slis_selfield.
  READ TABLE t_ekko INTO fs_ekko INDEX selfield-tabindex.

  CASE command.
    WHEN '&IC1'.
      SELECT *
      FROM ekpo
      INTO TABLE t_ekpo
      WHERE ebeln EQ fs_ekko-ebeln.

      w_prog = sy-repid.

      CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name       = 'EKPO'
        CHANGING
          ct_fieldcat            = t_fieldcat
        EXCEPTIONS
          inconsistent_interface = 1
          program_error          = 2
          OTHERS                 = 3.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
* WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      DELETE t_fieldcat WHERE fieldname EQ 'EBELN'.
      DELETE t_fieldcat WHERE fieldname EQ 'BUKRS'.
      DELETE t_fieldcat WHERE fieldname EQ 'LGORT'.
      DELETE t_fieldcat WHERE fieldname EQ 'WERKS'.

      PERFORM t_eventcat.

      CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
        EXPORTING
          i_callback_program = w_prog
          it_fieldcat        = t_fieldcat
          it_events          = t_eventcat
        TABLES
          t_outtab           = t_ekpo
        EXCEPTIONS
          program_error      = 1
          OTHERS             = 2.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
* WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

  ENDCASE. " CASE COMMAND
ENDFORM. " FORM PICK

FORM t_eventcat.
  w_eventcat-name = 'TOP_OF_PAGE'.
  w_eventcat-form = 'TOP'.
  APPEND w_eventcat TO t_eventcat.
ENDFORM.

FORM top.
  READ TABLE t_ekpo INTO fs_ekpo INDEX 1.
  WRITE:/ 'Purchase Document Number'(001),30 fs_ekpo-ebeln,
  / 'Company Code'(002), 30 fs_ekpo-bukrs,
  / 'Plant'(003), 30 fs_ekpo-werks,
  / 'Storage Location'(004),30 fs_ekpo-lgort.
ENDFORM.
