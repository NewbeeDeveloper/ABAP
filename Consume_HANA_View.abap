*&---------------------------------------------------------------------*
*& Report zrev_bkpf_mpah018
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrev_bkpf_mpah018.

SELECT *
 FROM zev_bkpf_mpah018  "EXternal View
 UP TO 10 ROWS
 INTO TABLE @DATA(it_bkpf).
 
IF sy-subrc EQ 0.
 cl_demo_output=>display( it_bkpf ).
ENDIF.
