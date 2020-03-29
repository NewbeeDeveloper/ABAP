*&---------------------------------------------------------------------*
*& Report zdpp_seg_lang_mpah018
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdpp_seg_lang_mpah018.

DATA gt_seg_key             TYPE TABLE OF zif_zdpp_seg_lang_mpah018=>it_seg_key.
DATA gt_relevance_value     TYPE TABLE OF zif_zdpp_seg_lang_mpah018=>et_relevance_value.


TRY.
  CALL DATABASE PROCEDURE zdpp_seg_lang_mpah018
  EXPORTING
    it_seg_key         = gt_seg_key
  IMPORTING
    et_relevance_value = gt_relevance_value
  .
  CATCH cx_sy_db_procedure_sql_error INTO DATA(cx).
  WRITE cx->get_text( ).
ENDTRY.

cl_demo_output=>display( gt_relevance_value ).
