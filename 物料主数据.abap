*&---------------------------------------------------------------------*
*& Report ZBAW_MM_004
*&---------------------------------------------------------------------*
*&  2021/10/08    XX-GAOJ
*&---------------------------------------------------------------------*
REPORT ZBAW_MM_004.

*----------------------------------------------------------------------*
* Tables
*----------------------------------------------------------------------*
TABLES:SSCRFIELDS.
*-----------------------------------------------------------------------
* CONSTANTS
*-----------------------------------------------------------------------
CONSTANTS:GC_GREEN TYPE CHAR4 VALUE '@5B@',
          GC_RED   TYPE CHAR4 VALUE '@5C@'.
*----------------------------------------------------------------------*
* TYPES
*----------------------------------------------------------------------*
TYPES: BEGIN OF GTY_FILE,
         ZZZXM     TYPE  STRING, "项目
         BLDAT     TYPE  STRING, "凭证日期
         BUDAT     TYPE  STRING, "过账日期
         BWART     TYPE  STRING, "移动类型
         WERKS     TYPE  STRING, "工厂
         LGORT     TYPE  STRING, "库存地点
         MATNR     TYPE  STRING, "物料编码
         MOVE_MAT  TYPE  STRING, "接收/发出物料
         CHARG     TYPE  STRING, "批次
         MENGE     TYPE  STRING, "数量
         MEINS     TYPE  STRING, "单位
         BPMNG     TYPE  STRING, "数量
         BBPRM     TYPE  STRING, "单位
         SOBKZ     TYPE  STRING, "特殊库存标记
         KDAUF     TYPE  STRING, "销售订单
         KDPOS     TYPE  STRING, "销售订单项次
         KUNNR     TYPE  STRING, "客户
         SERIALNO  TYPE  GERNR,  "序列号
         HSDAT     TYPE  STRING, "生产日期
         UMWRK     TYPE  STRING, "收发工厂
         UMLGO     TYPE  STRING, "收发库存地点
         AUFNR     TYPE  STRING, "订单号
         EBELN     TYPE  STRING, "采购订单
         EBELP     TYPE  STRING, "采购订单项次
         SAKTO     TYPE  STRING, "总账科目编号
         KOSTL     TYPE  STRING, "成本中心
         POSID     TYPE  STRING, "WBS元素
         VBELN     TYPE  STRING, "销售订单
         POSNR     TYPE  STRING, "销售订单项次
         SGTXT     TYPE  STRING, "项目文本
         CHARG_SID TYPE  STRING,
         MOVE_REAS TYPE  STRING, "移动原因
         LIFNR     TYPE  STRING,
         ZSPNO     TYPE  LFSNR1,  "ASN
       END OF GTY_FILE.

TYPES: BEGIN OF GTY_LIST,
         ZZZXM     TYPE  CHAR100,
         BLDAT     TYPE  MATDOC-BLDAT,
         BUDAT     TYPE  MATDOC-BUDAT,
         BWART     TYPE  MATDOC-BWART,
         WERKS     TYPE  MATDOC-WERKS,
         LGORT     TYPE  MATDOC-LGORT,
         MATNR     TYPE  MATDOC-MATNR,
         MOVE_MAT  TYPE  UMMAT18,
         CHARG     TYPE  MATDOC-CHARG,
         MENGE     TYPE  MATDOC-MENGE,
         MEINS     TYPE  MATDOC-MEINS,
         BPMNG     TYPE  BPMNG, "数量
         BBPRM     TYPE  BBPRM, "单位
         SOBKZ     TYPE  MATDOC-SOBKZ,
         KDAUF     TYPE  MATDOC-KDAUF,
         KDPOS     TYPE  MATDOC-KDPOS,
         KUNNR     TYPE  MATDOC-KUNNR,
         SERIALNO  TYPE  GERNR,      "序列号
         HSDAT     TYPE  MATDOC-HSDAT,
         UMWRK     TYPE  MSEG-UMWRK, "收发工厂
         UMLGO     TYPE  MATDOC-UMLGO,
         AUFNR     TYPE  MATDOC-AUFNR,
         EBELN     TYPE  MATDOC-EBELN,
         EBELP     TYPE  MATDOC-EBELP,
         VBELN     TYPE  MATDOC-MAT_KDAUF,
         POSNR     TYPE  MATDOC-MAT_KDPOS,
         SAKTO     TYPE  MSEG-SAKTO,
         KOSTL     TYPE  MATDOC-KOSTL,
         POSID     TYPE  PRPS-POSID,
         SGTXT     TYPE  MATDOC-SGTXT,
         LIFNR     TYPE  MSEG-LIFNR,
         ZZROW     TYPE I,
         ICON      TYPE ICON_D,
         ZZMSG     TYPE BAPI_MSG,
         ERROR     TYPE CHAR1,
         MAKTX     TYPE MAKT-MAKTX,
         MBLNR     TYPE MATDOC-MBLNR,
         PSPNR     TYPE PRPS-PSPNR,
         LFBJA     TYPE MATDOC-LFBJA,
         LFBNR     TYPE MATDOC-LFBNR,
         LFPOS     TYPE MATDOC-LFPOS,
         MOVE_REAS TYPE MB_GRBEW,   "移动原因
         CHARG_SID TYPE MATDOC-CHARG_SID,
         ZSPNO     TYPE ZBAW_DE_ZSPNO,  "ASN
       END OF GTY_LIST.

TYPES: BEGIN OF GTY_HEAD,
         ZZZXM TYPE CHAR100,
         ZZMSG TYPE BAPI_MSG,
         ERROR TYPE CHAR1,
       END OF GTY_HEAD.

TYPES: BEGIN OF GTY_MAKT,
         MATNR TYPE MAKT-MATNR,
         MAKTX TYPE MAKT-MAKTX,
       END OF GTY_MAKT.

TYPES: BEGIN OF GTY_MATDOC,
         KEY1  TYPE   MATDOC-KEY1,
         KEY2  TYPE   MATDOC-KEY2,
         KEY3  TYPE   MATDOC-KEY3,
         KEY4  TYPE   MATDOC-KEY4,
         KEY5  TYPE   MATDOC-KEY5,
         KEY6  TYPE   MATDOC-KEY6,
         BWART TYPE   MATDOC-BWART,
         MENGE TYPE   MATDOC-MENGE,
         EBELN TYPE   MATDOC-EBELN,
         EBELP TYPE   MATDOC-EBELP,
         MBLNR TYPE   MATDOC-MBLNR,
         MJAHR TYPE   MATDOC-MJAHR,
         ZEILE TYPE   MATDOC-ZEILE,
         LFBJA TYPE   MATDOC-LFBJA,
         LFBNR TYPE   MATDOC-LFBNR,
         LFPOS TYPE   MATDOC-LFPOS,
       END OF GTY_MATDOC.

TYPES:BEGIN OF GTY_MARC,
        WERKS TYPE MARC-WERKS,
        MATNR TYPE MARC-MATNR,
        SERNP TYPE SERAIL,
      END OF GTY_MARC.

*-----------------------------------------------------------------------
* DATA
*-----------------------------------------------------------------------
DATA:GT_FILE    TYPE GTY_FILE     OCCURS 0 WITH HEADER LINE,
     GT_LIST    TYPE GTY_LIST     OCCURS 0 WITH HEADER LINE,
     GT_HEAD    TYPE GTY_HEAD     OCCURS 0 WITH HEADER LINE,
     GT_MAKT    TYPE GTY_MAKT     OCCURS 0 WITH HEADER LINE,
     GT_MATDOC1 TYPE GTY_MATDOC   OCCURS 0 WITH HEADER LINE,
     GT_MATDOC2 TYPE GTY_MATDOC   OCCURS 0 WITH HEADER LINE.
DATA:GS_REPID    TYPE SY-REPID,
     GS_FIELDCAT TYPE LVC_T_FCAT,
     GS_LAYOUT   TYPE LVC_S_LAYO,
     GS_SORTINFO TYPE LVC_T_SORT.
DATA:GS_HEADER  TYPE BAPI2017_GM_HEAD_01,
     GS_CODE    TYPE BAPI2017_GM_CODE,
     GS_HEADRET TYPE BAPI2017_GM_HEAD_RET,
     GT_ITEM    TYPE BAPI2017_GM_ITEM_CREATE OCCURS 0 WITH HEADER LINE.
DATA:GV_RUN    TYPE CHAR1,
     GV_ERROR1 TYPE CHAR1.

DATA:lt_GOODSMVT_SERIALNUMBER TYPE TABLE OF BAPI2017_GM_SERIALNUMBER,
     ls_GOODSMVT_SERIALNUMBER LIKE LINE OF lt_GOODSMVT_SERIALNUMBER.

DATA : LT_MARC TYPE TABLE OF GTY_MARC,
       LS_MARC LIKE LINE OF LT_MARC.
*-----------------------------------------------------------------------
* SELECTION SCREEN
*-----------------------------------------------------------------------
SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME.
  PARAMETERS: P_FILE TYPE RLGRAP-FILENAME.
SELECTION-SCREEN:END OF BLOCK B1.
SELECTION-SCREEN FUNCTION KEY 1.
*-----------------------------------------------------------------------
* INITIALIZATION
*-----------------------------------------------------------------------
INITIALIZATION.
  PERFORM FRM_INIT.
*---------------------------------------------------------------*
*AT SELECTION-SCREEN
*---------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR  P_FILE.
  PERFORM FRM_EXECL_HELP USING P_FILE.

AT SELECTION-SCREEN.
  CASE SY-UCOMM.
    WHEN 'FC01'.
      PERFORM FRM_DOWNLOAD_PUBLIC USING  '物料凭证导入模板' 'ZBAW_MM_004'.
  ENDCASE.
*&----------------------------------------------------------------------*
*&功能概述：
*&物料凭证导入
*&----------------------------------------------------------------------*
  INCLUDE:
          ZBAW_MM_004_FRM,
          ZBAW_MM_004_DIS.
*-----------------------------------------------------------------------
* START-OF-SELECTION
*-----------------------------------------------------------------------
START-OF-SELECTION.
  PERFORM FRM_UPLOAD_PBLIC TABLES GT_FILE USING P_FILE."上传数据
  PERFORM FRM_CONVERT_DATA.     "数据转换
  PERFORM FRM_GET_DATA.         "抓取其它数据
  PERFORM FRM_FILL_DATA.        "填充其它数据
  PERFORM FRM_DISPLAY_DATA.     "显示数据
*-----------------------------------------------------------------------
* END-OF-SELECTION
*-----------------------------------------------------------------------
END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      FORM  USER_COMMAND
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->R_UCOMM      TEXT
*      -->RS_SELFIELD  TEXT
*----------------------------------------------------------------------*
FORM USER_COMMAND  USING R_UCOMM TYPE SY-UCOMM  RS_SELFIELD TYPE SLIS_SELFIELD.
  DATA:LR_GRID TYPE REF TO CL_GUI_ALV_GRID.
* 将界面中的选择数据更新到内表中
*=====GET_GLOBALS_FROM_SLVC_FULLSCR  START==========
  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      E_GRID = LR_GRID.
  CALL METHOD LR_GRID->CHECK_CHANGED_DATA.
*=====GET_GLOBALS_FROM_SLVC_FULLSCR  END============
  CASE R_UCOMM.
    WHEN 'CMD_TEST'.
      PERFORM FRM_TEST.
    WHEN 'CMD_POST'.
      PERFORM FRM_POST.
  ENDCASE.
  RS_SELFIELD-ROW_STABLE = 'X'.
  RS_SELFIELD-COL_STABLE = 'X'.
  RS_SELFIELD-REFRESH = 'X'.
ENDFORM.                    "USER_COMMAND
