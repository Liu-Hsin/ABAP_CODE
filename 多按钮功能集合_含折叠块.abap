*&---------------------------------------------------------------------*
*& Report ZPPR000
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zppr000.
TABLES:  sscrfields.
TYPE-POOLS:slis,ole2.
TYPE-POOLS icon.
DATA:  g_code TYPE sscrfields-ucomm.  "FUNCTION CODE
DATA itab TYPE TABLE OF sy-ucomm.

PARAMETERS: p_cb0(1) TYPE c NO-DISPLAY,   "Close Block 0
            p_cb1(1) TYPE c NO-DISPLAY,   "Close Block 1
            p_cb2(1) TYPE c NO-DISPLAY.   "Close Block 2

SELECTION-SCREEN FUNCTION KEY 1."expand all blocks
SELECTION-SCREEN FUNCTION KEY 2. "collapse all blocks

***************** Block 00 *** Description data file
SELECTION-SCREEN: PUSHBUTTON /1(80) pushb_o0         "Open Block 00
  USER-COMMAND ucomm_o0 MODIF ID mo0,                       "#EC NEEDED
PUSHBUTTON /1(80) pushb_c0         "Close Block 00
  USER-COMMAND ucomm_c0 MODIF ID mc0.

***********************主数据批导入开始**************************************
SELECTION-SCREEN BEGIN OF BLOCK b00 WITH FRAME TITLE TEXT-000.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF LINE .
    SELECTION-SCREEN PUSHBUTTON 2(20) but1 USER-COMMAND zppr001 MODIF ID mc0. " BOM批导
    SELECTION-SCREEN PUSHBUTTON 24(20) but2 USER-COMMAND zppr002 MODIF ID mc0. " 工艺批导
    SELECTION-SCREEN PUSHBUTTON 46(20) but3 USER-COMMAND zppr003 MODIF ID mc0. " 生产版本批导
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b00.

***********************主数据批导入结束**************************************

***********************主数据查询开始**************************************

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON 2(20) but4 USER-COMMAND zppr009 MODIF ID mc0. " BOM查询
    SELECTION-SCREEN PUSHBUTTON 24(20) but5 USER-COMMAND zppr019 MODIF ID mc0. " 工艺路线查询
    SELECTION-SCREEN PUSHBUTTON 46(20) but6 USER-COMMAND zppr020 MODIF ID mc0. " 生产版本查询
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON 2(20) but7 USER-COMMAND zppr028 MODIF ID mc0. " 物料查询
    SELECTION-SCREEN PUSHBUTTON 24(20) but8 USER-COMMAND zppr029 MODIF ID mc0. " BOM修改查询
    SELECTION-SCREEN PUSHBUTTON 46(20) but9 USER-COMMAND zppr032 MODIF ID mc0. " BOM批量反查
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b01.

***********************主数据查询结束**************************************

SELECTION-SCREEN: PUSHBUTTON /1(80) pushb_o1         "Open Block 01
  USER-COMMAND ucomm_o1 MODIF ID mo1,                       "#EC NEEDED
PUSHBUTTON /1(80) pushb_c1         "Close Block 01
  USER-COMMAND ucomm_c1 MODIF ID mc1.                       "#EC NEEDED
***********************生产业务*************************************
SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-002.
  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON 2(20) but10 USER-COMMAND zppr027 MODIF ID MC1. " 成品排产（按周计划）
    SELECTION-SCREEN PUSHBUTTON 24(20) but11 USER-COMMAND zppr008 MODIF ID MC1. " 总成半成品排产（按周计划）
    SELECTION-SCREEN PUSHBUTTON 46(20) but12 USER-COMMAND zppr013 MODIF ID MC1. " 备料半成品排产
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON 2(20) but13 USER-COMMAND zppr014 MODIF ID MC1. " 销售订单转生产订单
    SELECTION-SCREEN PUSHBUTTON 24(20) but14 USER-COMMAND zppr004 MODIF ID MC1. " 批量生产订单创建
    SELECTION-SCREEN PUSHBUTTON 46(20) but15 USER-COMMAND zppr005 MODIF ID MC1. " PIR
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b02.


SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON 2(20) but16 USER-COMMAND zppr007 MODIF ID MC1. " ATP
    SELECTION-SCREEN PUSHBUTTON 24(20) but17 USER-COMMAND zppr011 MODIF ID MC1. " 例外信息
    SELECTION-SCREEN PUSHBUTTON 46(20) but18 USER-COMMAND zppr031 MODIF ID MC1. " PIR查询
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON 2(20) but19 USER-COMMAND zppr015 MODIF ID MC1. " 状态订单
    SELECTION-SCREEN PUSHBUTTON 24(20) but20 USER-COMMAND zppr030 MODIF ID MC1. " 订单组件计划订单查询
    SELECTION-SCREEN PUSHBUTTON 46(20) but21 USER-COMMAND zppr033 MODIF ID MC1. " 计划订单查询
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b03.

SELECTION-SCREEN BEGIN OF BLOCK b04 WITH FRAME TITLE TEXT-004.
  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON 2(20) but22 USER-COMMAND zppr006 MODIF ID MC1. " 周计划差异分析
    SELECTION-SCREEN PUSHBUTTON 24(20) but23 USER-COMMAND zppr016 MODIF ID MC1. " 入库发货分析
    SELECTION-SCREEN PUSHBUTTON 46(20) but24 USER-COMMAND zppr010 MODIF ID MC1. " 库存地点扩展
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON 2(20) but25 USER-COMMAND zppr012 MODIF ID MC1 ." 派工单
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b04.


***************** Block 02 *** Report 02
SELECTION-SCREEN: PUSHBUTTON /1(80) pushb_o2         "Open Block 02
  USER-COMMAND ucomm_o2 MODIF ID mo2,                       "#EC NEEDED
PUSHBUTTON /1(80) pushb_c2         "Close Block 02
  USER-COMMAND ucomm_c2 MODIF ID mc2.                       "#EC NEEDED
SELECTION-SCREEN BEGIN OF BLOCK b05 WITH FRAME TITLE TEXT-005.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON 2(20) but26 USER-COMMAND zppr017 MODIF ID MC2. " 工序文本码发布
    SELECTION-SCREEN PUSHBUTTON 24(20) but27 USER-COMMAND zppr023 MODIF ID MC2. " 生产订单发布
    SELECTION-SCREEN PUSHBUTTON 46(20) but28 USER-COMMAND zppr018 MODIF ID MC2. " 订单预留明细发布
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON 2(20) but32 USER-COMMAND zppr024 MODIF ID MC2. " 订单查询

  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b05.

SELECTION-SCREEN BEGIN OF BLOCK b06 WITH FRAME TITLE TEXT-006.
  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN PUSHBUTTON 2(20) but29 USER-COMMAND zppr022 MODIF ID MC2. " 生产报工处理
    SELECTION-SCREEN PUSHBUTTON 24(20) but30 USER-COMMAND zppr026 MODIF ID MC2. " 生产入库处理
    SELECTION-SCREEN PUSHBUTTON 46(20) but31 USER-COMMAND zppr025 MODIF ID MC2. " 生产订单关闭处理
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b06.




INITIALIZATION.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_position
      text       = 'BOM批导'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but1
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_position
      text       = '工艺路线批导'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but2
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_position   "
      text       = '生产版本批导'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but3
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_search
      text       = 'BOM展开查询'
      info       = ''
      add_stdinf = ''
    IMPORTING
      result     = but4
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_search
      text       = '工艺路线查询'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but5
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_search
      text       = '生产版本查询'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but6
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_search
      text       = '物料主数据查询'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but7
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_search
      text       = 'BOM修改查询'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but8
    EXCEPTIONS
      OTHERS     = 0.


  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_search
      text       = '多物料BOM反查'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but9
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_align
      text       = '总成排产(按周计划)'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but10
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_align
      text       = '半成品排产(按周计划)'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but11
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_align
      text       = '备料中心半成品排产'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but12
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_create
      text       = '按销售订单创建工单'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but13
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_create
      text       = '批量生产订单创建'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but14
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_next_node
      text       = '计划独立需求批导入'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but15
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_check
      text       = '物料可用性检查'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but16
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_personal_help
      text       = 'MRP例外信息'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but17
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_variants
      text       = '计划独立需求查询'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but18
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_icon_list
      text       = '按状态查工单'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but19
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_move
      text       = '按订单查组件计划订单'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but20
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_display_text
      text       = '计划订单报表'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but21
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_graphics
      text       = '周计划差异分析'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but22
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_compare
      text       = '产品入库/销售分析'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but23
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_replace
      text       = '批量库存地点扩展'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but24
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_annotation
      text       = '零工派工单功能'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but25
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_workflow_fork
      text       = '工序文本码发布'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but26
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_workflow_fork
      text       = '生产订单发布'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but27
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_workflow_fork
      text       = '备料中心需求明细发布'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but28
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_bw_rotate_left
      text       = 'MES生产报工处理'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but29
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_bw_rotate_left
      text       = 'MES生产入库处理'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but30
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_bw_rotate_left
      text       = 'MES订单关闭处理'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but31
    EXCEPTIONS
      OTHERS     = 0.

  CALL FUNCTION 'ICON_CREATE' " 给按钮添加图标和文本
    EXPORTING
      name       = icon_workflow_fork
      text       = '订单发布MES查询'
      info       = ' '
      add_stdinf = ''
    IMPORTING
      result     = but32
    EXCEPTIONS
      OTHERS     = 0.

* Close Selection-Screen
  p_cb0 = ' '.
  p_cb1 = ' '.
  p_cb2 = ' '.
* Set Text & Icon for application bar
  CONCATENATE icon_expand: '全部展开' INTO sscrfields-functxt_01.
  CONCATENATE icon_collapse: '全部折叠' INTO sscrfields-functxt_02.

* Set Text & Icon for Pushbutton
  CONCATENATE icon_collapse: '< 生 产 主 数 据 管 理 >' INTO pushb_c0,
                             '< 生 产 计 划 执 行 管 理 >' INTO pushb_c1,
                             '< 系 统 集 成 功 能 管理 >' INTO pushb_c2.

  CONCATENATE icon_expand: '< 生 产 主 数 据 管 理 >' INTO pushb_o0,
                           '< 生 产 计 划 执 行 管 理 >' INTO pushb_o1,
                           '< 系 统 集 成 功 能 管理 >' INTO pushb_o2.

AT SELECTION-SCREEN.
  g_code = sscrfields-ucomm.
  CASE g_code.
*Expand all blocks
    WHEN 'FC01'.
      PERFORM expand_all_blocks.
*Collapse all blocks
    WHEN 'FC02'.      "Collapse all blocks
      PERFORM collapse_all_blocks.
*Open/close individual block functions
    WHEN 'UCOMM_O0'.                   "Open Block 0
      CLEAR p_cb0.
    WHEN 'UCOMM_C0'.                   "Close Block 0
      p_cb0 = 'X'.
    WHEN 'UCOMM_O1'.                   "Open Block 1
      CLEAR p_cb1.
    WHEN 'UCOMM_C1'.                   "Close Block 1
      p_cb1 = 'X'.
    WHEN 'UCOMM_O2'.                   "Open Block 2
      CLEAR p_cb2.
    WHEN 'UCOMM_C2'.                   "Close Block 2
      p_cb2 = 'X'.
    WHEN OTHERS.

      PERFORM callfunction USING: g_code.

  ENDCASE.

AT SELECTION-SCREEN OUTPUT.

  APPEND: 'ONLI' TO itab.

  CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
    EXPORTING
      p_status  = sy-pfkey
    TABLES
      p_exclude = itab.
*


*modify screen according predefined screen group
  LOOP AT SCREEN.
    screen-intensified = 1.
    CASE screen-group1.
      WHEN 'MC0'.
        PERFORM close_block USING: p_cb0 'MC0' space.
      WHEN 'MO0'.
        PERFORM close_block USING: p_cb0 'MO0' 'X'  .
      WHEN 'MC1'.
        PERFORM close_block USING: p_cb1 'MC1' space.
      WHEN 'MO1'.
        PERFORM close_block USING: p_cb1 'MO1' 'X'  .
      WHEN 'MC2'.
        PERFORM close_block USING: p_cb2 'MC2' space.
      WHEN 'MO2'.
        PERFORM close_block USING: p_cb2 'MO2' 'X'  .
      WHEN OTHERS.
        CONTINUE.
    ENDCASE.
  ENDLOOP.


*&---------------------------------------------------------------------*
*&      Form  close_block
*&---------------------------------------------------------------------*
FORM close_block USING  VALUE(i_close_block) LIKE p_cb1
                        VALUE(i_modify_id) LIKE screen-group1
                        VALUE(i_convert) TYPE char1.
  IF NOT i_convert IS INITIAL.
    IF i_close_block IS INITIAL.
      i_close_block = 'X'.
    ELSE.
      CLEAR i_close_block.
    ENDIF.
  ENDIF.

  IF ( screen-group1 = i_modify_id )
  AND ( NOT i_close_block IS INITIAL ).
    screen-active = 0.
    MODIFY SCREEN.
  ENDIF.

ENDFORM.                    "close_block

*&---------------------------------------------------------------------*
*&      Form  collapse_all_blocks
*&---------------------------------------------------------------------*
FORM collapse_all_blocks.
  p_cb0 = 'X'.p_cb1 = 'X'.p_cb2 = 'X'.
ENDFORM.                    "collapse_all_blocks

*&---------------------------------------------------------------------*
*&      Form  expand_all_blocks
*&---------------------------------------------------------------------*
FORM expand_all_blocks.
  CLEAR: p_cb0,p_cb1,p_cb2 .
ENDFORM.


*&---------------------------------------------------------------------*
*& Form CALLFUNCTION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> G_CODE
*&---------------------------------------------------------------------*
FORM callfunction  USING    p_g_code.

  CALL FUNCTION 'ABAP4_CALL_TRANSACTION'
    STARTING NEW TASK 'NEW_SESSION'
    EXPORTING
      tcode                   = p_g_code
*     SKIP_SCREEN             = ' '
*     MODE_VAL                = 'A'
*     UPDATE_VAL              = 'A'
* IMPORTING
*     SUBRC                   =
* TABLES
*     USING_TAB               =
*     SPAGPA_TAB              =
*     MESS_TAB                =
    EXCEPTIONS
      call_transaction_denied = 1
      tcode_invalid           = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.