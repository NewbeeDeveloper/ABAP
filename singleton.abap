Skip to content
Search or jump to…

Pull requests
Issues
Marketplace
Explore
 
@eecheverria573 
Learn Git and GitHub without any code!
Using the Hello World guide, you’ll start a branch, write comments, and open a pull request.


eecheverria573
/
ABAP
0
00
 Code Issues 0 Pull requests 0 Actions Projects 0 Wiki Security Insights Settings
ABAP/singleton.txt
 Eduardo Echeverria first commit
15ffd7c on 16 May 2018
75 lines (47 sloc)  1.55 KB
  
*&---------------------------------------------------------------------*
*& Report  YSINGLETON2
*&
*&---------------------------------------------------------------------*
*&Autor: Eduardo Echeverría
*&
*&---------------------------------------------------------------------*
REPORT ysingleton2.

CLASS lcl_demo DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.

    "Método para obtener la instancia
    CLASS-METHODS: get_instance RETURNING VALUE(ref_obj) TYPE REF TO lcl_demo.

    "Métodos para asignar valores a los atributos
    METHODS: set_valor IMPORTING i_valor       TYPE char30,
             get_valor RETURNING VALUE(r_valor) TYPE char30.

  PRIVATE SECTION.

    CLASS-DATA lo_obj TYPE REF TO lcl_demo.

    DATA: lv_valor(30) TYPE c.

ENDCLASS.


CLASS lcl_demo IMPLEMENTATION.

  METHOD get_instance.

    "Validación de la creación del objeto
    IF lo_obj IS INITIAL.

      CREATE OBJECT lo_obj.

    ENDIF.

    "Asignación de referencia
    ref_obj = lo_obj.

  ENDMETHOD.

  METHOD set_valor.
    lv_valor = i_valor.
  ENDMETHOD.

  METHOD get_valor.
    r_valor = me->lv_valor.
  ENDMETHOD.


ENDCLASS.


START-OF-SELECTION.

  DATA: lr_ref_1 TYPE REF TO lcl_demo.
  DATA: lr_ref_2 TYPE REF TO lcl_demo.

  DATA: lv_msj(30) TYPE c.

  "Asignación de referencia No 1
  lr_ref_1 = lcl_demo=>get_instance( ).
  lr_ref_1->set_valor('Objeto 1').

  "Asignación de referencia No 2
  lr_ref_2 = lcl_demo=>get_instance( ).

  "Obtención del atributo
  lv_msj = lr_ref_2->get_valor( ).

  WRITE lv_msj.
© 2020 GitHub, Inc.
Terms
Privacy
Security
Status
Help
Contact GitHub
Pricing
API
Training
Blog
About
