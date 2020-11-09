*&---------------------------------------------------------------------*
*& Report  ZALV_REPORT_SFLIGHT
*&
*&---------------------------------------------------------------------*
* Published at SAPTechnical.COM
*&---------------------------------------------------------------------*

REPORT  ZALV_REPORT_SFLIGHT.
TABLES : SFLIGHT.
TYPE-POOLS : SLIS.

**INTERNAL TABLE DECLARTION
DATA : WA_SFLIGHT TYPE SFLIGHT,
       IT_SFLIGHT TYPE TABLE OF SFLIGHT.

**DATA DECLARTION
DATA: FIELDCATALOG TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE,
      GD_LAYOUT    TYPE SLIS_LAYOUT_ALV,
      GD_REPID     LIKE SY-REPID,
      G_SAVE TYPE C VALUE 'X',
      G_VARIANT TYPE DISVARIANT,
      GX_VARIANT TYPE DISVARIANT,
      G_EXIT TYPE C,
      ISPFLI TYPE TABLE OF SPFLI.

* To understand the importance of the following parameter, click here.
**SELECTION SCREEN DETAILS
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-002 .
PARAMETERS: VARIANT LIKE DISVARIANT-VARIANT.
SELECTION-SCREEN END OF BLOCK B1.
**GETTING DEFAULT VARIANT
INITIALIZATION.
  GX_VARIANT-REPORT = SY-REPID.
  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
    EXPORTING
      I_SAVE     = G_SAVE
    CHANGING
      CS_VARIANT = GX_VARIANT
    EXCEPTIONS
      NOT_FOUND  = 2.
  IF SY-SUBRC = 0.
    VARIANT = GX_VARIANT-VARIANT.
  ENDIF.

**PERFORM DECLARATIONS
START-OF-SELECTION.
  PERFORM DATA_RETRIVEL.
  PERFORM BUILD_FIELDCATALOG.
  PERFORM DISPLAY_ALV_REPORT.

*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_FIELDCATALOG .

  FIELDCATALOG-FIELDNAME   = 'CARRID'.
  FIELDCATALOG-SELTEXT_M   = 'Airline Code'.
  FIELDCATALOG-COL_POS     = 0.
  APPEND FIELDCATALOG TO FIELDCATALOG.
  CLEAR  FIELDCATALOG.

  FIELDCATALOG-FIELDNAME   = 'CONNID'.
  FIELDCATALOG-SELTEXT_M   = 'Flight Connection Number'.
  FIELDCATALOG-COL_POS     = 1.
  APPEND FIELDCATALOG TO FIELDCATALOG.
  CLEAR  FIELDCATALOG.

  FIELDCATALOG-FIELDNAME   = 'FLDATE'.
  FIELDCATALOG-SELTEXT_M   = 'Flight date'.
  FIELDCATALOG-COL_POS     = 2.
  APPEND FIELDCATALOG TO FIELDCATALOG.
  CLEAR  FIELDCATALOG.

  FIELDCATALOG-FIELDNAME   = 'PRICE'.
  FIELDCATALOG-SELTEXT_M   = 'Airfare'.
  FIELDCATALOG-COL_POS     = 3.
  FIELDCATALOG-OUTPUTLEN   = 20.
  APPEND FIELDCATALOG TO FIELDCATALOG.
  CLEAR  FIELDCATALOG.
ENDFORM.                    " BUILD_FIELDCATALOG


*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_REPORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY_ALV_REPORT .
  GD_REPID = SY-REPID.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM      = GD_REPID
      I_CALLBACK_TOP_OF_PAGE  = 'TOP-OF-PAGE'  "see FORM
      I_CALLBACK_USER_COMMAND = 'USER_COMMAND'
      IT_FIELDCAT             = FIELDCATALOG[]
      I_SAVE                  = 'X'
      IS_VARIANT              = G_VARIANT
    TABLES
      T_OUTTAB                = IT_SFLIGHT
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.                    "DISPLAY_ALV_REPORT

" DISPLAY_ALV_REPORT
*&---------------------------------------------------------------------*
*&      Form  DATA_RETRIVEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATA_RETRIVEL .
  SELECT * FROM SFLIGHT INTO TABLE IT_SFLIGHT.
ENDFORM.                    " DATA_RETRIVEL

*-------------------------------------------------------------------*
* Form  TOP-OF-PAGE                                                 *
*-------------------------------------------------------------------*
* ALV Report Header                                                 *
*-------------------------------------------------------------------*
FORM TOP-OF-PAGE.
*ALV Header declarations
  DATA: T_HEADER TYPE SLIS_T_LISTHEADER,
        WA_HEADER TYPE SLIS_LISTHEADER,
        T_LINE LIKE WA_HEADER-INFO,
        LD_LINES TYPE I,
        LD_LINESC(10) TYPE C.

* Title
  WA_HEADER-TYP  = 'H'.
  WA_HEADER-INFO = 'SFLIGHT Table Report'.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR WA_HEADER.

* Date
  WA_HEADER-TYP  = 'S'.
  WA_HEADER-KEY = 'Date: '.
  CONCATENATE  SY-DATUM+6(2) '.'
               SY-DATUM+4(2) '.'
               SY-DATUM(4) INTO WA_HEADER-INFO.   "todays date
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = T_HEADER.
ENDFORM.                    "top-of-page
