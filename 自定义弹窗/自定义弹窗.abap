
" 全局定义

DATA: ok_code TYPE syst-ucomm.
DATA: lv_x.
DATA: txt1 TYPE char40,
      txt2 TYPE char40.

" 函数。
FUNCTION ztest_fm_01.
*"----------------------------------------------------------------------
*"*"本地接口：
*"  IMPORTING
*"     VALUE(I_TEXTLINE1) TYPE  CHAR40
*"     VALUE(I_TEXTLINE2) TYPE  CHAR40 OPTIONAL
*"     VALUE(I_STARCOL) TYPE  SY-CUCOL DEFAULT 10
*"     VALUE(I_STARROW) TYPE  SY-CUROW DEFAULT 5
*"  EXPORTING
*"     VALUE(ANSWER) TYPE  CHAR01
*"----------------------------------------------------------------------
  CLEAR:txt1,txt2,answer.
  txt1 = i_textline1.
  txt2 = i_textline2.
  CLEAR: lv_x.

  IF i_starcol IS INITIAL.
    i_starcol = 10.
  ENDIF.
  IF i_starrow IS INITIAL.
    i_starrow = 5.
  ENDIF.

  i_endcol = i_starcol + 60.
  i_endrow = i_starrow + 3.

  CALL SCREEN 100 STARTING AT i_starcol i_starrow ENDING AT i_endcol i_endrow .

  answer = lv_x.
ENDFUNCTION.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*& 逻辑流
*&---------------------------------------------------------------------*
PROCESS BEFORE OUTPUT.
MODULE STATUS_0100.
*
PROCESS AFTER INPUT.
MODULE USER_COMMAND_0100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*& PBO
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'ZSTATU'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*& PAI
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA: lv_ucomm TYPE syst-ucomm.
  lv_ucomm = ok_code.
  CLEAR: ok_code.
  CLEAR: lv_x.
  CASE lv_ucomm.
    WHEN 'BTN1' OR 'YES'. " 确认。
      lv_x = 'X'.
      LEAVE TO SCREEN 0.
    WHEN 'BTN2' OR 'NO'. " 取消
      lv_x = 'Y'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS. " 其他
      lv_x = 'Y'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.