*&---------------------------------------------------------------------*
*& Report zcode_generator_report
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcode_generator_report.


TYPE-POOLS: ole2.

TABLES: sscrfields.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (6) text.
SELECTION-SCREEN POSITION 7.
PARAMETERS p_prog TYPE programm.
SELECTION-SCREEN PUSHBUTTON 50(10) gen USER-COMMAND gen.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN FUNCTION KEY 1.
SELECTION-SCREEN FUNCTION KEY 2.
SELECTION-SCREEN FUNCTION KEY 3.
SELECTION-SCREEN FUNCTION KEY 4.

*----------------------------------------------------------------------*
*       CLASS lcl_alv_event_handler DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_alv_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_toolbar        FOR EVENT toolbar
                            OF cl_gui_alv_grid
                            IMPORTING e_object e_interactive,

      handle_f4             FOR EVENT onf4
                            OF cl_gui_alv_grid
                            IMPORTING e_fieldname e_fieldvalue es_row_no er_event_data et_bad_cells,

      handle_user_command   FOR EVENT user_command
                            OF cl_gui_alv_grid
                            IMPORTING e_ucomm.
ENDCLASS.                    "lcl_alv_event_handler DEFINITION

TYPES:
  BEGIN OF typ_table,
    tabname   TYPE tabname,
    leftjoin  TYPE c,
    astable   TYPE tabname,
  END OF typ_table,

  BEGIN OF typ_join,
    tab1      TYPE tabname,
    field1    TYPE fieldname,
    tab2      TYPE tabname,
    field2    TYPE fieldname,
  END OF typ_join,

  BEGIN OF typ_field1,
    astable     TYPE tabname,
    fieldname   TYPE fieldname,
    asfield     TYPE lvc_fname,
    query       TYPE c,
    query_pos   TYPE i,
    single      TYPE c,
    display     TYPE c,
    qfieldname  TYPE lvc_qfname,
    cfieldname  TYPE lvc_cfname,
    ref_table   TYPE lvc_rtname,
    ref_field   TYPE lvc_rfname,
    convexit    TYPE convexit,
    emphasize   TYPE lvc_emphsz,
    scrtext_l   TYPE scrtext_l,
    sel_field   TYPE fieldname,
    sql_field   TYPE c LENGTH 60,
    out_field   TYPE fieldname,
    typ_field   TYPE c LENGTH 60,
    mark        TYPE c LENGTH 60,
  END OF typ_field1,

  BEGIN OF typ_field2,
    fieldname   TYPE lvc_fname,
    qfieldname  TYPE lvc_qfname,
    cfieldname  TYPE lvc_cfname,
    ref_table   TYPE lvc_rtname,
    ref_field   TYPE lvc_rfname,
    convexit    TYPE convexit,
    emphasize   TYPE lvc_emphsz,
    scrtext_l   TYPE scrtext_l,
    typ_field   TYPE c LENGTH 60,
  END OF typ_field2.

DATA:
  go_docking_con        TYPE REF TO cl_gui_docking_container,
  go_splitter_con       TYPE REF TO cl_gui_splitter_container,
  go_splitter_con_left  TYPE REF TO cl_gui_splitter_container,
  go_splitter_con_right TYPE REF TO cl_gui_splitter_container,
  go_con_tables         TYPE REF TO cl_gui_container,
  go_con_joins          TYPE REF TO cl_gui_container,
  go_con_fields1        TYPE REF TO cl_gui_container,
  go_con_fields2        TYPE REF TO cl_gui_container,
  go_alv_tables         TYPE REF TO cl_gui_alv_grid,
  go_alv_joins          TYPE REF TO cl_gui_alv_grid,
  go_alv_fields1        TYPE REF TO cl_gui_alv_grid,
  go_alv_fields2        TYPE REF TO cl_gui_alv_grid,
  go_event_tables       TYPE REF TO lcl_alv_event_handler,
  go_event_joins        TYPE REF TO lcl_alv_event_handler,
  go_event_fields1      TYPE REF TO lcl_alv_event_handler,
  go_event_fields2      TYPE REF TO lcl_alv_event_handler.

DATA:
  gt_tables             TYPE TABLE OF typ_table,
  gs_table              TYPE typ_table,
  gt_joins              TYPE TABLE OF typ_join,
  gs_join               TYPE typ_join,
  gt_fields1            TYPE TABLE OF typ_field1,
  gs_field1             TYPE typ_field1,
  gt_fields2            TYPE TABLE OF typ_field2,
  gs_field2             TYPE typ_field2,
  gt_query              TYPE TABLE OF typ_field1,
  gs_query              TYPE typ_field1.

DATA:
  gt_fieldcat_tables    TYPE lvc_t_fcat,
  gt_fieldcat_joins     TYPE lvc_t_fcat,
  gt_fieldcat_fields1   TYPE lvc_t_fcat,
  gt_fieldcat_fields2   TYPE lvc_t_fcat,
  gs_fieldcat           TYPE lvc_s_fcat,
  gt_f4_tables          TYPE lvc_t_f4,
  gt_f4_joins           TYPE lvc_t_f4,
  gt_f4_fields1         TYPE lvc_t_f4,
  gt_f4_fields2         TYPE lvc_t_f4,
  gs_f4                 TYPE lvc_s_f4,
  gt_exclude            TYPE ui_functions,
  gs_layout             TYPE lvc_s_layo.

DATA:
  BEGIN OF gt_color OCCURS 0,
    sel TYPE c,
    color TYPE c LENGTH 4,
    value TYPE c LENGTH 4,
  END OF gt_color.

DATA:
  ok_code TYPE sy-ucomm,
  g_flag_error TYPE c,
  g_indxid TYPE indx_srtfd,
  gt_codes TYPE TABLE OF string,
  g_code TYPE string,
  go_excel TYPE ole2_object,
  go_books TYPE ole2_object,
  go_book TYPE ole2_object,
  go_sheet TYPE ole2_object,
  go_cell TYPE ole2_object,
  g_row TYPE i,
  g_col TYPE i,
  g_value TYPE string.

DEFINE d_build_fieldcat.
  gs_fieldcat-fieldname  = &3.
  gs_fieldcat-edit       = &4.
  gs_fieldcat-checkbox   = &5.
  gs_fieldcat-f4availabl = &6.
  gs_fieldcat-outputlen  = &7.
  gs_fieldcat-coltext    = &8.
  append gs_fieldcat to &1.
  clear gs_fieldcat.

  if &6 = 'X'.
    gs_f4-fieldname = &3.
    gs_f4-register = 'X'.
    insert gs_f4 into table &2.
    clear gs_f4.
  endif.
END-OF-DEFINITION.

DEFINE append_code.
  append &1 to gt_codes.
END-OF-DEFINITION.
*----------------------------------------------------------------------*
*       CLASS lcl_alv_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_alv_event_handler IMPLEMENTATION .
  METHOD handle_toolbar.
    PERFORM handle_toolbar USING  e_object e_interactive.
  ENDMETHOD.                    "HANDLE_TOOLBAR

  METHOD handle_f4.
    PERFORM handle_f4 USING e_fieldname e_fieldvalue es_row_no er_event_data et_bad_cells.
  ENDMETHOD.                                                "HANDLE_F4

  METHOD handle_user_command.
    PERFORM handle_user_command USING e_ucomm.
  ENDMETHOD.                    "HANDLE_USER_COMMAND
ENDCLASS.                    "lcl_alv_event_handler IMPLEMENTATION

INITIALIZATION.
  text = '程序'.
  gen = '生成程序'.
  sscrfields-functxt_01 = '保存设置'.
  sscrfields-functxt_02 = '加载设置'.
  sscrfields-functxt_03 = '下载到Excel'.
  sscrfields-functxt_04 = '从Excel上载'.

AT SELECTION-SCREEN OUTPUT.
  CHECK go_docking_con IS INITIAL.
  "创建容器
  CREATE OBJECT go_docking_con
    EXPORTING
      ratio = 95
      side  = cl_gui_docking_container=>dock_at_bottom.

  "拆分为左、右
  CREATE OBJECT go_splitter_con
    EXPORTING
      parent  = go_docking_con
      rows    = 1
      columns = 2.
  go_splitter_con->set_column_width( EXPORTING id = 1 width = 25 ).

  "左侧再次拆分为上下
  CREATE OBJECT go_splitter_con_left
    EXPORTING
      parent  = go_splitter_con->get_container( row = 1 column = 1 )
      rows    = 2
      columns = 1.
  go_splitter_con_left->set_row_height( EXPORTING id = 1 height = 40 ).

  "右侧再次拆分为上下
  CREATE OBJECT go_splitter_con_right
    EXPORTING
      parent  = go_splitter_con->get_container( row = 1 column = 2 )
      rows    = 2
      columns = 1.
  go_splitter_con_right->set_row_height( EXPORTING id = 2 height = 40 ).

  "创建TABLES的ALV
  go_con_tables = go_splitter_con_left->get_container( row = 1 column = 1 ).
  CREATE OBJECT go_alv_tables
    EXPORTING
      i_parent = go_con_tables.

  "创建JOINS的ALV
  go_con_joins = go_splitter_con_left->get_container( row = 2 column = 1 ).
  CREATE OBJECT go_alv_joins
    EXPORTING
      i_parent = go_con_joins.

  "创建FIELDS1的ALV
  go_con_fields1 = go_splitter_con_right->get_container( row = 1 column = 1 ).
  CREATE OBJECT go_alv_fields1
    EXPORTING
      i_parent = go_con_fields1.

  "创建FIELDS2的ALV
  go_con_fields2 = go_splitter_con_right->get_container( row = 2 column = 1 ).
  CREATE OBJECT go_alv_fields2
    EXPORTING
      i_parent = go_con_fields2.

  "事件响应
  CREATE OBJECT: go_event_tables, go_event_joins, go_event_fields1, go_event_fields2.
  SET HANDLER:
    go_event_tables->handle_f4  FOR go_alv_tables,
    go_event_joins->handle_f4   FOR go_alv_joins,
    go_event_fields1->handle_f4 FOR go_alv_fields1,
    go_event_fields1->handle_toolbar FOR go_alv_fields1,
    go_event_fields1->handle_user_command FOR go_alv_fields1,
    go_event_fields2->handle_f4 FOR go_alv_fields2.

  "显示ALV
  PERFORM alv_prepare_toolbar   TABLES    gt_exclude.
  PERFORM alv_prepare_layout    CHANGING  gs_layout.

  d_build_fieldcat:
    gt_fieldcat_tables  gt_f4_tables  'TABNAME'    'X'   ' '   'X'  12  '表名',
    gt_fieldcat_tables  gt_f4_tables  'LEFTJOIN'   'X'   'X'   ' '   6  '左连接',
    gt_fieldcat_tables  gt_f4_tables  'ASTABLE'    'X'   ' '   ' '   4  '别名'.
  gs_layout-grid_title = '表清单【表顺序可以上下拖动】'.
  CALL METHOD go_alv_tables->set_table_for_first_display
    EXPORTING
      it_toolbar_excluding = gt_exclude
      is_layout            = gs_layout
    CHANGING
      it_outtab            = gt_tables
      it_fieldcatalog      = gt_fieldcat_tables.

  d_build_fieldcat:
    gt_fieldcat_joins  gt_f4_joins  'TAB1'       'X'   ' '   'X'  12  '表1',
    gt_fieldcat_joins  gt_f4_joins  'FIELD1'     'X'   ' '   'X'  15  '字段1',
    gt_fieldcat_joins  gt_f4_joins  'TAB2'       'X'   ' '   'X'  12  '表2',
    gt_fieldcat_joins  gt_f4_joins  'FIELD2'     'X'   ' '   'X'  15  '字段2(或特定值)'.
  gs_layout-grid_title = '表关联【请遵循本程序约定：表1在“表清单”中的位置需要在表2以下】'.
  CALL METHOD go_alv_joins->set_table_for_first_display
    EXPORTING
      it_toolbar_excluding = gt_exclude
      is_layout            = gs_layout
    CHANGING
      it_outtab            = gt_joins
      it_fieldcatalog      = gt_fieldcat_joins.

  d_build_fieldcat:
    gt_fieldcat_fields1  gt_f4_fields1  'ASTABLE'      'X'   ' '  'X'  12  '表名',
    gt_fieldcat_fields1  gt_f4_fields1  'FIELDNAME'    'X'   ' '  'X'  15  '字段名',
    gt_fieldcat_fields1  gt_f4_fields1  'ASFIELD'      'X'   ' '  ' '   8  '字段别名',
    gt_fieldcat_fields1  gt_f4_fields1  'QUERY'        'X'   'X'  ' '   4  '查询',
    gt_fieldcat_fields1  gt_f4_fields1  'QUERY_POS'    'X'   ' '  ' '   4  '位置',
    gt_fieldcat_fields1  gt_f4_fields1  'SINGLE'       'X'   'X'  ' '   4  '单值',
    gt_fieldcat_fields1  gt_f4_fields1  'DISPLAY'      'X'   'X'  ' '   4  '输出',
    gt_fieldcat_fields1  gt_f4_fields1  'QFIELDNAME'   'X'   ' '  'X'   8  '单位字段',
    gt_fieldcat_fields1  gt_f4_fields1  'CFIELDNAME'   'X'   ' '  'X'   8  '货币字段',
    gt_fieldcat_fields1  gt_f4_fields1  'REF_TABLE'    'X'   ' '  ' '  12  '参照表',
    gt_fieldcat_fields1  gt_f4_fields1  'REF_FIELD'    'X'   ' '  ' '  15  '参照字段',
    gt_fieldcat_fields1  gt_f4_fields1  'CONVEXIT'     'X'   ' '  ' '   7  '转换例程',
    gt_fieldcat_fields1  gt_f4_fields1  'EMPHASIZE'    'X'   ' '  'X'   6  '列颜色',
    gt_fieldcat_fields1  gt_f4_fields1  'SCRTEXT_L'    'X'   ' '  ' '  20  '字段描述'.
  gs_layout-grid_title = '字段设置【该表格中的所有字段都会出现在SELECT中，查询字段出现在选择屏幕中，输出字段出现在ALV中】'.
  CALL METHOD go_alv_fields1->set_table_for_first_display
    EXPORTING
      it_toolbar_excluding = gt_exclude
      is_layout            = gs_layout
    CHANGING
      it_outtab            = gt_fields1
      it_fieldcatalog      = gt_fieldcat_fields1.

  d_build_fieldcat:
    gt_fieldcat_fields2  gt_f4_fields2  'FIELDNAME'    'X'   ' '  ' '  15  '字段名',
    gt_fieldcat_fields2  gt_f4_fields2  'QFIELDNAME'   'X'   ' '  'X'   8  '单位字段',
    gt_fieldcat_fields2  gt_f4_fields2  'CFIELDNAME'   'X'   ' '  'X'   8  '货币字段',
    gt_fieldcat_fields2  gt_f4_fields2  'REF_TABLE'    'X'   ' '  ' '  12  '参照表',
    gt_fieldcat_fields2  gt_f4_fields2  'REF_FIELD'    'X'   ' '  ' '  15  '参照字段',
    gt_fieldcat_fields2  gt_f4_fields2  'CONVEXIT'     'X'   ' '  ' '   7  '转换例程',
    gt_fieldcat_fields2  gt_f4_fields2  'EMPHASIZE'    'X'   ' '  'X'   6  '列颜色',
    gt_fieldcat_fields2  gt_f4_fields2  'SCRTEXT_L'    'X'   ' '  ' '  20  '字段描述'.
  gs_layout-grid_title = '附加字段【如：汇总字段、合并字段等】'.
  CALL METHOD go_alv_fields2->set_table_for_first_display
    EXPORTING
      it_toolbar_excluding = gt_exclude
      is_layout            = gs_layout
    CHANGING
      it_outtab            = gt_fields2
      it_fieldcatalog      = gt_fieldcat_fields2.

  "注册事件
  go_alv_tables->register_f4_for_fields(  EXPORTING it_f4 = gt_f4_tables  ).
  go_alv_joins->register_f4_for_fields(   EXPORTING it_f4 = gt_f4_joins   ).
  go_alv_fields1->register_f4_for_fields( EXPORTING it_f4 = gt_f4_fields1 ).
  go_alv_fields2->register_f4_for_fields( EXPORTING it_f4 = gt_f4_fields2 ).
  go_alv_tables->register_edit_event(  EXPORTING i_event_id = cl_gui_alv_grid=>mc_evt_modified ).
  go_alv_joins->register_edit_event(   EXPORTING i_event_id = cl_gui_alv_grid=>mc_evt_modified ).
  go_alv_fields1->register_edit_event( EXPORTING i_event_id = cl_gui_alv_grid=>mc_evt_modified ).
  go_alv_fields2->register_edit_event( EXPORTING i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_prog.
  PERFORM f4_prog.

AT SELECTION-SCREEN.
  go_alv_tables->check_changed_data( ).
  go_alv_joins->check_changed_data( ).
  go_alv_fields1->check_changed_data( ).
  go_alv_fields2->check_changed_data( ).

  g_indxid = p_prog && 'RG'.
  ok_code = sy-ucomm.
  CLEAR sy-ucomm.
  CASE ok_code.
    WHEN 'FC01'.
      EXPORT tables = gt_tables joins = gt_joins fields1 = gt_fields1 fields2 = gt_fields2 TO DATABASE indx(st) ID g_indxid.
    WHEN 'FC02'.
      IMPORT tables = gt_tables joins = gt_joins fields1 = gt_fields1 fields2 = gt_fields2 FROM DATABASE indx(st) ID g_indxid.
      PERFORM alv_refresh_display.
    WHEN 'FC03'.
      PERFORM download.
    WHEN 'FC04'.
      PERFORM upload.
      PERFORM alv_refresh_display.
    WHEN 'GEN'.
      PERFORM check.
      CHECK g_flag_error IS INITIAL.
      PERFORM process_data.
      PERFORM generate.
  ENDCASE.

*&---------------------------------------------------------------------*
*&      Form  alv_prepare_toolbar
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_prepare_toolbar  TABLES  pt_exclude TYPE ui_functions.
  REFRESH: pt_exclude.

  APPEND cl_gui_alv_grid=>mc_fc_maximum TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_minimum TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_subtot TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_sum TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_average TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_mb_sum TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_mb_subtot TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_sort_asc TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_sort_dsc TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_find TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_filter TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_print TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_print_prev TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_mb_export TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_graph TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_mb_export TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_mb_view TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_detail TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_help TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_info TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_mb_variant TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_refresh TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_check TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy TO pt_exclude.
*  APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO pt_exclude.
*  APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO pt_exclude.
*  APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_undo TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO pt_exclude.
  APPEND cl_gui_alv_grid=>mc_mb_paste TO pt_exclude.
ENDFORM.                    "alv_prepare_toolbar
*&---------------------------------------------------------------------*
*&      Form  alv_prepare_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PS_LAYOUT  text
*----------------------------------------------------------------------*
FORM alv_prepare_layout  CHANGING ps_layout TYPE lvc_s_layo.
  ps_layout-zebra = 'X'.
  ps_layout-sel_mode = 'A'.
  ps_layout-smalltitle = 'X'.
ENDFORM.                    "alv_prepare_layout
*&---------------------------------------------------------------------*
*&      Form  handle_toolbar
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM handle_toolbar USING  e_object TYPE REF TO cl_alv_event_toolbar_set
                            e_interactive TYPE char1.
  DATA: ls_toolbar TYPE stb_button.

  ls_toolbar-function = 'IMPORT'.
  ls_toolbar-icon = icon_import.
  ls_toolbar-text = '导入表格字段'.
  ls_toolbar-quickinfo = '导入表格字段'.
  APPEND ls_toolbar TO e_object->mt_toolbar.
  CLEAR: ls_toolbar.

  ls_toolbar-function = 'ALL'.
  ls_toolbar-text = '输出：全选'.
  ls_toolbar-quickinfo = '全部输出'.
  APPEND ls_toolbar TO e_object->mt_toolbar.
  CLEAR: ls_toolbar.

  ls_toolbar-function = 'NONE'.
  ls_toolbar-text = '输出：取消全选'.
  ls_toolbar-quickinfo = '全部不输出'.
  APPEND ls_toolbar TO e_object->mt_toolbar.
  CLEAR: ls_toolbar.
ENDFORM.                    "handle_toolbar
*&---------------------------------------------------------------------*
*&      Form  handle_user_command
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM handle_user_command  USING    e_ucomm.
  DATA: l_astable TYPE tabname,
        l_tabname TYPE tabname,
        lt_dfies_tab TYPE TABLE OF dfies WITH HEADER LINE.

  ok_code = e_ucomm.
  CLEAR e_ucomm.

  CASE ok_code.
    WHEN 'IMPORT'.
      "选择表
      PERFORM f4_table CHANGING l_astable.
      CHECK l_astable IS NOT INITIAL.

      "获取真实表名
      READ TABLE gt_tables WITH KEY astable = l_astable INTO gs_table.
      IF sy-subrc = 0.
        l_tabname = gs_table-tabname.
      ELSE.
        l_tabname = l_astable.
      ENDIF.

      "获取字段
      CALL FUNCTION 'DDIF_FIELDINFO_GET'
        EXPORTING
          tabname        = l_tabname
          langu          = sy-langu
        TABLES
          dfies_tab      = lt_dfies_tab[]
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      CHECK sy-subrc = 0.

      "添加到ALV
      LOOP AT lt_dfies_tab.
        CHECK lt_dfies_tab-fieldname <> 'MANDT'.
        CLEAR: gs_field1.
        gs_field1-astable = l_astable.
        gs_field1-fieldname = lt_dfies_tab-fieldname.
        gs_field1-scrtext_l = lt_dfies_tab-fieldtext.
        gs_field1-ref_table = l_tabname.
        gs_field1-ref_field = lt_dfies_tab-fieldname.
        APPEND gs_field1 TO gt_fields1.
      ENDLOOP.

      go_alv_fields1->refresh_table_display( ).

    WHEN 'ALL'.
      gs_field1-display = 'X'.
      MODIFY gt_fields1 FROM gs_field1 TRANSPORTING display WHERE display = ''.
      go_alv_fields1->refresh_table_display( ).
    WHEN 'NONE'.
      gs_field1-display = ''.
      MODIFY gt_fields1 FROM gs_field1 TRANSPORTING display WHERE display = 'X'.
      go_alv_fields1->refresh_table_display( ).
  ENDCASE.
ENDFORM.                    "handle_user_command
*&---------------------------------------------------------------------*
*&      Form  handle_f4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM handle_f4  USING           e_fieldname TYPE lvc_fname
                                e_fieldvalue TYPE lvc_value
                                es_row_no TYPE lvc_s_roid
                                er_event_data TYPE REF TO cl_alv_event_data
                                et_bad_cells TYPE lvc_t_modi.
  DATA: ls_row TYPE lvc_s_row,
        ls_col TYPE lvc_s_col,
        ls_modi TYPE lvc_s_modi,
        l_tabname TYPE tabname,
        l_fieldtext TYPE fieldtext,
        l_ref_table TYPE lvc_rtname,
        l_ref_field TYPE lvc_rfname.
  FIELD-SYMBOLS: <lt_modi> TYPE lvc_t_modi.

  er_event_data->m_event_handled = 'X'.

  CASE e_fieldname.
    WHEN 'TABNAME'.
      PERFORM f4_dd_table(rsaqddic) USING 'SAPLAQJD_CNTRL'
                                          '0300'
                                          'G_DYN_0300-TNAME'
                                    CHANGING e_fieldvalue.  "搜索帮助代码，来于SQVI中“插入表”的搜索帮助

    WHEN 'TAB1' OR 'TAB2' OR 'ASTABLE'.
      PERFORM f4_table CHANGING e_fieldvalue.

    WHEN 'FIELD1' OR 'FIELD2' OR 'FIELDNAME'.
      go_alv_tables->check_changed_data( ).

      IF e_fieldname = 'FIELD1'.
        READ TABLE gt_joins INDEX es_row_no-row_id INTO gs_join.
        CHECK gs_join-tab1 IS NOT INITIAL.
        l_tabname = gs_join-tab1.
      ELSEIF e_fieldname = 'FIELD2'.
        READ TABLE gt_joins INDEX es_row_no-row_id INTO gs_join.
        CHECK gs_join-tab2 IS NOT INITIAL.
        l_tabname = gs_join-tab2.
      ELSEIF e_fieldname = 'FIELDNAME'.
        READ TABLE gt_fields1 INDEX es_row_no-row_id INTO gs_field1.
        CHECK gs_field1-astable IS NOT INITIAL.
        l_tabname = gs_field1-astable.
        l_fieldtext = gs_field1-scrtext_l.
        l_ref_table = gs_field1-ref_table.
        l_ref_field = gs_field1-ref_field.
      ENDIF.

      READ TABLE gt_tables WITH KEY astable = l_tabname INTO gs_table.
      IF sy-subrc = 0.
        l_tabname = gs_table-tabname.
      ENDIF.

      PERFORM f4_field USING l_tabname CHANGING e_fieldvalue l_fieldtext l_ref_table l_ref_field.

    WHEN 'QFIELDNAME' OR 'CFIELDNAME'.
      PERFORM f4_field_in_itab CHANGING e_fieldvalue.

    WHEN 'EMPHASIZE'.
      PERFORM f4_color CHANGING e_fieldvalue.

    WHEN OTHERS.
      EXIT.
  ENDCASE.

  ASSIGN er_event_data->m_data->* TO <lt_modi>.
  ls_modi-row_id    = es_row_no-row_id."
  ls_modi-fieldname = e_fieldname.
  ls_modi-value     = e_fieldvalue.
  APPEND ls_modi TO <lt_modi>.
  IF e_fieldname = 'FIELDNAME'.
    ls_modi-row_id    = es_row_no-row_id."
    ls_modi-fieldname = 'SCRTEXT_L'.
    ls_modi-value     = l_fieldtext.
    APPEND ls_modi TO <lt_modi>.

    ls_modi-row_id    = es_row_no-row_id."
    ls_modi-fieldname = 'REF_TABLE'.
    ls_modi-value     = l_ref_table.
    APPEND ls_modi TO <lt_modi>.

    ls_modi-row_id    = es_row_no-row_id."
    ls_modi-fieldname = 'REF_FIELD'.
    ls_modi-value     = l_ref_field.
    APPEND ls_modi TO <lt_modi>.
  ENDIF.

ENDFORM.                                                    "handle_f4
*&---------------------------------------------------------------------*
*&      Form  F4_PROG
*&---------------------------------------------------------------------*
*       程序名称的搜索帮助（同SE38）
*----------------------------------------------------------------------*
FORM f4_prog .
  DATA: lt_dynpfields TYPE TABLE OF dynpread WITH HEADER LINE.

  lt_dynpfields-fieldname  = 'P_PROG'.
  APPEND lt_dynpfields.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname     = sy-repid
      dynumb     = sy-dynnr
    TABLES
      dynpfields = lt_dynpfields[].

  READ TABLE lt_dynpfields INDEX 1.
  p_prog = lt_dynpfields-fieldvalue.

  CALL FUNCTION 'REPOSITORY_INFO_SYSTEM_F4'
    EXPORTING
      object_type          = 'PROG'
      object_name          = p_prog
      suppress_selection   = 'X'
    IMPORTING
      object_name_selected = p_prog
    EXCEPTIONS
      cancel               = 01.
ENDFORM.                                                    " F4_PROG
*&---------------------------------------------------------------------*
*&      Form  PROCESS_DATA
*&---------------------------------------------------------------------*
*       处理数据
*----------------------------------------------------------------------*
FORM process_data .
  DATA: l_tabname TYPE tabname,
        l_as_flag TYPE c.

  LOOP AT gt_fields1 INTO gs_field1.
    "取真实表名
    READ TABLE gt_tables WITH KEY astable = gs_field1-astable INTO gs_table.
    IF sy-subrc = 0.
      l_tabname = gs_table-tabname.
      l_as_flag = 'X'.
    ELSE.
      l_tabname = gs_field1-astable.
      l_as_flag = ''.
    ENDIF.

    "根据单选和多选情况，确定选择条件的参数
    IF gs_field1-query = 'X'.
      IF gs_field1-asfield IS INITIAL.
        gs_field1-sel_field = gs_field1-fieldname.
      ELSE.
        gs_field1-sel_field = gs_field1-asfield.
      ENDIF.

      IF gs_field1-single = 'X'.
        gs_field1-sel_field = 'P_' && gs_field1-sel_field.
      ELSE.
        gs_field1-sel_field = 'S_' && gs_field1-sel_field.
      ENDIF.
    ENDIF.

    "确定SQL字段的名称
    IF l_as_flag = ''.
      gs_field1-sql_field = l_tabname && '~' && gs_field1-fieldname.
    ELSE.
      gs_field1-sql_field = gs_field1-astable && '~' && gs_field1-fieldname.
    ENDIF.

    "确定显示字段的名称
    IF gs_field1-asfield IS INITIAL.
      gs_field1-out_field = gs_field1-fieldname.
    ELSE.
      gs_field1-out_field = gs_field1-asfield.
      "SQL字段别名处理
      CONCATENATE gs_field1-sql_field 'AS' gs_field1-asfield INTO gs_field1-sql_field SEPARATED BY space.
    ENDIF.

    "确定参照字段的名称
    gs_field1-typ_field = l_tabname && '-' && gs_field1-fieldname.

    gs_field1-mark = '"' && gs_field1-scrtext_l.
    SHIFT gs_field1-mark RIGHT BY 10 PLACES.
    MODIFY gt_fields1 FROM gs_field1 TRANSPORTING sel_field sql_field out_field typ_field mark.
  ENDLOOP.

  gt_query = gt_fields1.
  DELETE gt_query WHERE query  = ''.
  SORT gt_query STABLE BY query_pos.

  LOOP AT gt_fields2 INTO gs_field2.
    IF gs_field2-ref_table IS INITIAL.
      gs_field2-typ_field = gs_field2-ref_field.
    ELSE.
      gs_field2-typ_field = gs_field2-ref_table && '-' && gs_field2-ref_field.
    ENDIF.
    MODIFY gt_fields2 FROM gs_field2 TRANSPORTING typ_field.
  ENDLOOP.
ENDFORM.                    " PROCESS_DATA

*&---------------------------------------------------------------------*
*&      Form  generate
*&---------------------------------------------------------------------*
*       生成程序
*----------------------------------------------------------------------*
FORM generate.
  REFRESH gt_codes.

  CHECK p_prog(1) = 'Y' OR p_prog(1) = 'Z'.

  IF strlen( p_prog ) > 20.
    MESSAGE '程序名长度不能超过20' TYPE 'E' DISPLAY LIKE 'I'.
  ENDIF.

  SELECT SINGLE progname INTO p_prog FROM reposrc WHERE progname = p_prog.
  IF sy-subrc = 0.
*    MESSAGE '程序已经存在' TYPE 'E' DISPLAY LIKE 'I'.
  ENDIF.

  "程序名
  PERFORM gen_report_name.
  "TABLES
  PERFORM gen_tables_clause.
  "SELECTION-SCREEN
  PERFORM gen_selection_screen.
  "类型定义
  PERFORM gen_types.
  "数据定义
  PERFORM gen_data_defination.
  "初始化
  PERFORM gen_initialization.
  "START-OF-SELECTION
  PERFORM gen_start_of_selection.
  "FORM GET_DATA
  PERFORM gen_form_get_data.
  "FORM PROCESS_DATA
  PERFORM gen_form_process_data.
  "FORM BUILD_FIELDCAT
  PERFORM gen_form_build_fieldcat.
  "FORM DISPLAY_DATA
  PERFORM gen_form_display_data.
  "FORM PF_STATUS_ALV
  PERFORM gen_form_pf_status_alv.
  "FORM USER_COMMAND_ALV
  PERFORM gen_form_user_command_alv.

  INSERT REPORT p_prog FROM gt_codes.
ENDFORM.                    "GENERATE
*&---------------------------------------------------------------------*
*&      Form  GEN_REPORT_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_report_name .
  CONCATENATE 'REPORT' p_prog INTO g_code SEPARATED BY space.
  g_code = g_code && '.'.
  append_code: g_code, ''.
ENDFORM.                    " GEN_REPORT_NAME
*&---------------------------------------------------------------------*
*&      Form  GEN_TABLES_CLAUSE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_tables_clause .
  DATA: lt_tables TYPE TABLE OF typ_table.

  lt_tables = gt_tables.
  SORT lt_tables BY tabname.
  DELETE ADJACENT DUPLICATES FROM lt_tables COMPARING tabname.

  g_code = 'TABLES:'.
  LOOP AT lt_tables INTO gs_table.
    CONCATENATE g_code gs_table-tabname INTO g_code SEPARATED BY space.
    IF sy-tabix = lines( lt_tables ).
      g_code = g_code && '.'.
    ELSE.
      g_code = g_code && ','.
    ENDIF.
  ENDLOOP.
  append_code: g_code, ''.
ENDFORM.                    " GEN_TABLES_CLAUSE
*&---------------------------------------------------------------------*
*&      Form  GEN_SELECTION_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_selection_screen .
  append_code 'SELECTION-SCREEN BEGIN OF BLOCK 001 WITH FRAME TITLE TEXT-001.'.

  LOOP AT gt_query INTO gs_query.
    IF gs_query-single = 'X'.
      CONCATENATE 'PARAMETERS' gs_query-sel_field 'TYPE' gs_query-typ_field INTO g_code SEPARATED BY space.
    ELSE.
      CONCATENATE 'SELECT-OPTIONS' gs_query-sel_field 'FOR' gs_query-typ_field INTO g_code SEPARATED BY space.
    ENDIF.
    g_code = g_code && '.' && gs_query-mark.
    append_code g_code.
  ENDLOOP.

  append_code 'SELECTION-SCREEN END OF BLOCK 001.'.
  append_code ''.
ENDFORM.                    " GEN_SELECTION_SCREEN
*&---------------------------------------------------------------------*
*&      Form  GEN_TYPES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_types .
  DATA: l_mark TYPE c LENGTH 60.

  append_code:
    'TYPES:',
    '  BEGIN OF TYP_DATA,'.
  LOOP AT gt_fields1 INTO gs_field1.
    CONCATENATE gs_field1-out_field 'TYPE' gs_field1-typ_field INTO g_code SEPARATED BY space.
    g_code = g_code && ',' && gs_field1-mark.
    SHIFT g_code RIGHT BY 4 PLACES.
    append_code g_code.
  ENDLOOP.

  LOOP AT gt_fields2 INTO gs_field2.
    CONCATENATE gs_field2-fieldname 'TYPE' gs_field2-typ_field INTO g_code SEPARATED BY space.
    l_mark = '"' && gs_field2-scrtext_l.
    SHIFT l_mark RIGHT BY 10 PLACES.
    g_code = g_code && ',' && l_mark.
    SHIFT g_code RIGHT BY 4 PLACES.
    append_code g_code.
  ENDLOOP.

  append_code: '  END OF TYP_DATA.', ''.
ENDFORM.                    " GEN_TYPES
*&---------------------------------------------------------------------*
*&      Form  GEN_DATA_DEFINATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_data_defination .
  append_code:
    '  DATA:',
    '    GT_DATA     TYPE TABLE OF TYP_DATA,',
    '    GS_DATA     TYPE TYP_DATA,',
    '    GT_FIELDCAT TYPE LVC_T_FCAT,',
    '    GS_FIELDCAT TYPE LVC_S_FCAT,',
    '    GS_LAYOUT   TYPE LVC_S_LAYO.',
    ''.
ENDFORM.                    " GEN_DATA_DEFINATION
*&---------------------------------------------------------------------*
*&      Form  GEN_INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_initialization .
  append_code 'INITIALIZATION.'.
  LOOP AT gt_query INTO gs_query.
    g_code = '  %_' && gs_query-sel_field && '_%_APP_%-TEXT'.
    g_code = g_code && ' = ''' && gs_query-scrtext_l && '''.'.
    append_code g_code.
  ENDLOOP.
  append_code ''.
ENDFORM.                    " GEN_INITIALIZATION
*&---------------------------------------------------------------------*
*&      Form  GEN_START_OF_SELECTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_start_of_selection .
  append_code:
    'START-OF-SELECTION.',
    '  PERFORM GET_DATA.',
    '  PERFORM PROCESS_DATA.',
    '  PERFORM DISPLAY_DATA.',
    ''.
ENDFORM.                    " GEN_START_OF_SELECTION
*&---------------------------------------------------------------------*
*&      Form  GEN_FORM_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_form_get_data .
  DATA: l_joinfield TYPE string,
        l_tabname TYPE tabname,
        l_join_counts TYPE i,
        l_index TYPE i.

  append_code:
    '*&---------------------------------------------------------------------*',
    '*&      FORM  GET_DATA                                                  ',
    '*&---------------------------------------------------------------------*',
    '*       获取数据                                                        ',
    '*----------------------------------------------------------------------*',
    'FORM GET_DATA.                                                          '.

  "SELECT字段
  append_code '  SELECT'.
  LOOP AT gt_fields1 INTO gs_field1.
    g_code = gs_field1-sql_field && gs_field1-mark.
    SHIFT g_code RIGHT BY 4 PLACES.
    append_code g_code.
  ENDLOOP.
  IF gt_fields2 IS INITIAL.
    append_code '    INTO TABLE GT_DATA'.
  ELSE.
    append_code '    INTO CORRESPONDING FIELDS OF TABLE GT_DATA'.
  ENDIF.

  "FROM语句
  READ TABLE gt_tables INDEX 1 INTO gs_table.
  CONCATENATE 'FROM' gs_table-tabname INTO g_code SEPARATED BY space.
  IF gs_table-astable IS NOT INITIAL.
    CONCATENATE g_code 'AS' gs_table-astable INTO g_code SEPARATED BY space.
  ENDIF.
  SHIFT g_code RIGHT BY 4 PLACES.
  append_code g_code.

  "JOIN语句
  LOOP AT gt_tables INTO gs_table FROM 2.
    IF gs_table-leftjoin = 'X'.
      CONCATENATE '    LEFT JOIN' gs_table-tabname INTO g_code SEPARATED BY space.
    ELSE.
      CONCATENATE '    INNER JOIN' gs_table-tabname INTO g_code SEPARATED BY space.
    ENDIF.

    IF gs_table-astable IS INITIAL.
      l_tabname = gs_table-tabname.
    ELSE.
      l_tabname = gs_table-astable.
      CONCATENATE g_code 'AS' l_tabname INTO g_code SEPARATED BY space.
    ENDIF.

    CONCATENATE g_code 'ON' INTO g_code SEPARATED BY space.

    CLEAR: l_join_counts.
    LOOP AT gt_joins INTO gs_join WHERE tab1 = l_tabname.
      ADD 1 TO l_join_counts.
      IF l_join_counts > 1.
        CONCATENATE g_code 'AND' INTO g_code SEPARATED BY space.
      ENDIF.

      l_joinfield = gs_join-tab1 && '~' && gs_join-field1.
      CONCATENATE g_code l_joinfield '=' INTO g_code SEPARATED BY space.

      IF gs_join-tab2 IS INITIAL.
        l_joinfield = gs_join-field2.
      ELSE.
        l_joinfield = gs_join-tab2 && '~' && gs_join-field2.
      ENDIF.
      CONCATENATE g_code l_joinfield INTO g_code SEPARATED BY space.
    ENDLOOP.
    append_code g_code.
  ENDLOOP.

  "WHERE语句
  LOOP AT gt_query INTO gs_query.
    l_index = sy-tabix.

    g_code = gs_query-astable && '~' && gs_query-fieldname.
    IF l_index = 1.
      CONCATENATE '    WHERE' g_code INTO g_code SEPARATED BY space.
    ELSE.
      CONCATENATE '      AND' g_code INTO g_code SEPARATED BY space.
    ENDIF.
    IF gs_query-single = 'X'.
      CONCATENATE g_code '=' gs_query-sel_field INTO g_code SEPARATED BY space.
    ELSE.
      CONCATENATE g_code 'IN' gs_query-sel_field INTO g_code SEPARATED BY space.
    ENDIF.

    IF l_index = lines( gt_query ).
      g_code = g_code && '.'.
    ENDIF.

    append_code g_code.
  ENDLOOP.

  append_code 'ENDFORM.                    "GET_DATA'.
ENDFORM.                    " GEN_FORM_GET_DATA
*&---------------------------------------------------------------------*
*&      Form  GEN_FORM_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_form_process_data .
  append_code:
    '*&---------------------------------------------------------------------*',
    '*&      FORM  PROCESS_DATA                                              ',
    '*&---------------------------------------------------------------------*',
    '*       处理数据                                                        ',
    '*----------------------------------------------------------------------*',
    'FORM PROCESS_DATA.                                                       ',
    '                                                                         ',
    'ENDFORM.                    "PROCESS_DATA                                '.
ENDFORM.                    "GEN_FORM_PROCESS_DATA
*&---------------------------------------------------------------------*
*&      Form  GEN_FORM_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_form_build_fieldcat .
  append_code:
    '*&---------------------------------------------------------------------*',
    '*&      Form  BUILD_FIELDCAT                                            ',
    '*&---------------------------------------------------------------------*',
    '*       TEXT                                                            ',
    '*----------------------------------------------------------------------*',
    'FORM BUILD_FIELDCAT USING P_FIELDNAME   TYPE FIELDNAME                  ',
    '                          P_QFIELDNAME  TYPE LVC_QFNAME                 ',
    '                          P_CFIELDNAME  TYPE LVC_CFNAME                 ',
    '                          P_REF_TABLE   TYPE LVC_RTNAME                 ',
    '                          P_REF_FIELD   TYPE LVC_RFNAME                 ',
    '                          P_CONVEXIT    TYPE CONVEXIT                   ',
    '                          P_EMPHASIZE   TYPE LVC_EMPHSZ                 ',
    '                          P_SCRTEXT_L   TYPE SCRTEXT_L.                 ',
    '  GS_FIELDCAT-FIELDNAME     = P_FIELDNAME.                              ',
    '  GS_FIELDCAT-QFIELDNAME    = P_QFIELDNAME.                             ',
    '  GS_FIELDCAT-CFIELDNAME    = P_CFIELDNAME.                             ',
    '  GS_FIELDCAT-REF_TABLE     = P_REF_TABLE.                              ',
    '  GS_FIELDCAT-REF_FIELD     = P_REF_FIELD.                              ',
    '  GS_FIELDCAT-CONVEXIT      = P_CONVEXIT.                               ',
    '  GS_FIELDCAT-EMPHASIZE     = P_EMPHASIZE.                              ',
    '  GS_FIELDCAT-SCRTEXT_L     = P_SCRTEXT_L.                              ',
    '  GS_FIELDCAT-COLDDICTXT    = ''L''.                                    ',
    '  APPEND GS_FIELDCAT TO GT_FIELDCAT.                                    ',
    '  CLEAR: GS_FIELDCAT.                                                   ',
    'ENDFORM.                    "BUILD_FIELDCAT                             '.
ENDFORM.                    " GEN_FORM_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  GEN_FORM_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_form_display_data .
  append_code:
   '*&---------------------------------------------------------------------*',
   '*&      FORM  DISPLAY_DATA                                              ',
   '*&---------------------------------------------------------------------*',
   '*       显示数据                                                        ',
   '*----------------------------------------------------------------------*',
   'FORM DISPLAY_DATA.                                                      '.

  "FIELDCAT
  LOOP AT gt_fields1 INTO gs_field1 WHERE display = 'X'.
    g_code = '  PERFORM BUILD_FIELDCAT USING ''' &&
              gs_field1-out_field && ''' ''' &&
              gs_field1-qfieldname && ''' ''' &&
              gs_field1-cfieldname && ''' ''' &&
              gs_field1-ref_table && ''' ''' &&
              gs_field1-ref_field && ''' ''' &&
              gs_field1-convexit && ''' ''' &&
              gs_field1-emphasize && ''' ''' &&
              gs_field1-scrtext_l && '''.'.
    append_code g_code.
  ENDLOOP.
  LOOP AT gt_fields2 INTO gs_field2.
    g_code = '  PERFORM BUILD_FIELDCAT USING ''' &&
              gs_field2-fieldname && ''' ''' &&
              gs_field2-qfieldname && ''' ''' &&
              gs_field2-cfieldname && ''' ''' &&
              gs_field2-ref_table && ''' ''' &&
              gs_field2-ref_field && ''' ''' &&
              gs_field2-convexit && ''' ''' &&
              gs_field2-emphasize && ''' ''' &&
              gs_field2-scrtext_l && '''.'.
    append_code g_code.
  ENDLOOP.
  append_code ''.

  "LAYOUT
  append_code:
    '  gs_layout-cwidth_opt = ''X''.',
    '  gs_layout-zebra = ''X''.',
    ''.

  append_code:
    '  CALL FUNCTION ''REUSE_ALV_GRID_DISPLAY_LVC''        ',
    '    EXPORTING                                         ',
    '      I_CALLBACK_PROGRAM       = SY-REPID             ',
    '"      I_CALLBACK_PF_STATUS_SET = ''PF_STATUS_ALV''   ',
    '      I_CALLBACK_USER_COMMAND  = ''USER_COMMAND_ALV'' ',
    '      IT_FIELDCAT_LVC          = GT_FIELDCAT          ',
    '      IS_LAYOUT_LVC            = GS_LAYOUT            ',
    '      I_DEFAULT                = ''X''                ',
    '      I_SAVE                   = ''A''                ',
    '    TABLES                                            ',
    '      T_OUTTAB                 = GT_DATA              ',
    '    EXCEPTIONS                                        ',
    '      OTHERS                   = 1.                   '.
  "ALV展示
  append_code 'ENDFORM.                    "DISPLAY_DATA'.
ENDFORM.                    " GEN_FORM_DISPLAY_DATA
*&---------------------------------------------------------------------*
*&      Form  GEN_FORM_PF_STATUS_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_form_pf_status_alv .
  append_code:
    '**&---------------------------------------------------------------------*',
    '**&      FORM  PF_STATUS_ALV                                             ',
    '**&---------------------------------------------------------------------*',
    '**       TEXT                                                            ',
    '**----------------------------------------------------------------------*',
    '*FORM PF_STATUS_ALV USING RT_EXTAB TYPE SLIS_T_EXTAB .                   ',
    '*  SET PF-STATUS ''STATUS_ALV'' EXCLUDING RT_EXTAB.                      ',
    '*ENDFORM.                    "PF_STATUS_ALV                              '.
ENDFORM.                    " GEN_FORM_PF_STATUS_ALV
*&---------------------------------------------------------------------*
*&      Form  GEN_FORM_USER_COMMAND_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM gen_form_user_command_alv .
  append_code:
    '*&---------------------------------------------------------------------*',
    '*&      FORM  USER_COMMAND_ALV                                          ',
    '*&---------------------------------------------------------------------*',
    '*       TEXT                                                            ',
    '*----------------------------------------------------------------------*',
    'FORM USER_COMMAND_ALV USING R_UCOMM     LIKE SY-UCOMM                   ',
    '                            RS_SELFIELD TYPE SLIS_SELFIELD.             ',
    '  CASE R_UCOMM.                                                         ',
    '    WHEN ''&IC1''.                                                      ',
    '      CASE RS_SELFIELD-FIELDNAME.                                       ',
    '        WHEN ''''.                                                      ',
    '*          CHECK RS_SELFIELD-VALUE IS NOT INITIAL.                      ',
    '*          SET PARAMETER ID ''MBN'' FIELD RS_SELFIELD-VALUE.            ',
    '*          CALL TRANSACTION ''MB03'' AND SKIP FIRST SCREEN.             ',
    '      ENDCASE.                                                          ',
    '  ENDCASE.                                                              ',
    'ENDFORM.                    "USER_COMMAND_ALV                           '.
ENDFORM.                    " GEN_FORM_USER_COMMAND_ALV
*&---------------------------------------------------------------------*
*&      Form  f4_table
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f4_table CHANGING p_tabname.
  DATA: lt_return TYPE TABLE OF ddshretval WITH HEADER LINE.
  DATA: BEGIN OF lt_tables OCCURS 0,
          astable TYPE tabname,
          tabname TYPE tabname,
        END OF lt_tables.

  go_alv_tables->check_changed_data( ).

  LOOP AT gt_tables INTO gs_table.
    IF gs_table-astable IS INITIAL.
      lt_tables-astable = gs_table-tabname.
    ELSE.
      lt_tables-astable = gs_table-astable.
    ENDIF.

    lt_tables-tabname = gs_table-tabname.
    APPEND lt_tables.
  ENDLOOP.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'ASTABLE'
      window_title = '选择'
      value_org    = 'S'
    TABLES
      value_tab    = lt_tables[]
      return_tab   = lt_return[].

  IF lt_return[] IS NOT INITIAL.
    READ TABLE lt_return INDEX 1.
    p_tabname = lt_return-fieldval.
  ENDIF.
ENDFORM.                                                    "f4_table
*&---------------------------------------------------------------------*
*&      Form  f4_field
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f4_field USING p_tabname TYPE tabname
              CHANGING p_fieldname p_fieldtext p_ref_table p_ref_field.
  DATA: lt_return TYPE TABLE OF ddshretval WITH HEADER LINE,
        lt_dfies_tab TYPE TABLE OF dfies WITH HEADER LINE,
        BEGIN OF lt_fields OCCURS 0,
          fieldname TYPE fieldname,
          fieldtext TYPE fieldtext,
          keyflag   TYPE keyflag,
          datatype  TYPE dynptype,
          leng      TYPE ddleng,
          decimals  TYPE decimals,
        END OF lt_fields.

  CALL FUNCTION 'DDIF_FIELDINFO_GET'
    EXPORTING
      tabname        = p_tabname
      langu          = sy-langu
    TABLES
      dfies_tab      = lt_dfies_tab[]
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.

  CHECK sy-subrc = 0.

  DELETE lt_dfies_tab WHERE fieldname = 'MANDT'.
  LOOP AT lt_dfies_tab.
    lt_fields-fieldname = lt_dfies_tab-fieldname.
    lt_fields-fieldtext = lt_dfies_tab-fieldtext.
    lt_fields-keyflag   = lt_dfies_tab-keyflag  .
    lt_fields-datatype  = lt_dfies_tab-datatype .
    lt_fields-leng      = lt_dfies_tab-leng     .
    lt_fields-decimals  = lt_dfies_tab-decimals .
    APPEND lt_fields.
  ENDLOOP.
                                                            "调用F4
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'FIELDNAME'
      window_title = '选择'
      value_org    = 'S'
    TABLES
      value_tab    = lt_fields[]
      return_tab   = lt_return[].

  IF lt_return[] IS NOT INITIAL.
    READ TABLE lt_return INDEX 1.
    p_fieldname = lt_return-fieldval.
    READ TABLE lt_fields WITH KEY fieldname = p_fieldname.
    p_fieldtext = lt_fields-fieldtext.
    p_ref_table = p_tabname.
    p_ref_field = p_fieldname.
  ENDIF.
ENDFORM.                                                    "f4_field
*&---------------------------------------------------------------------*
*&      Form  F4_FIELD_IN_ITAB
*&---------------------------------------------------------------------*
*       GT_FIELDS的字段
*----------------------------------------------------------------------*
FORM f4_field_in_itab CHANGING p_fieldname.
  DATA: lt_return TYPE TABLE OF ddshretval WITH HEADER LINE,
        BEGIN OF lt_fields OCCURS 0,
          fieldname TYPE fieldname,
          fieldtext TYPE fieldtext,
        END OF lt_fields.

  LOOP AT gt_fields1 INTO gs_field1.
    IF gs_field1-asfield IS INITIAL.
      lt_fields-fieldname = gs_field1-fieldname.
    ELSE.
      lt_fields-fieldname = gs_field1-asfield.
    ENDIF.
    lt_fields-fieldtext = gs_field1-scrtext_l.
    APPEND lt_fields.
  ENDLOOP.

  LOOP AT gt_fields2 INTO gs_field2.
    lt_fields-fieldname = gs_field2-fieldname.
    lt_fields-fieldtext = gs_field2-scrtext_l.
    APPEND lt_fields.
  ENDLOOP.
                                                            "调用F4
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'FIELDNAME'
      window_title = '选择'
      value_org    = 'S'
    TABLES
      value_tab    = lt_fields[]
      return_tab   = lt_return[].

  IF lt_return[] IS NOT INITIAL.
    READ TABLE lt_return INDEX 1.
    p_fieldname = lt_return-fieldval.
  ENDIF.
ENDFORM.                    " F4_FIELD_IN_ITAB
*&---------------------------------------------------------------------*
*&      Form  f4_color
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_COLOR    text
*----------------------------------------------------------------------*
FORM f4_color CHANGING p_color.
  DATA:
    lt_fieldcat TYPE TABLE OF slis_fieldcat_alv,
    ls_fieldcat TYPE slis_fieldcat_alv,
    ls_layout TYPE slis_layout_alv.

  CLEAR: gt_color, gt_color[].
  DO 7 TIMES.
    gt_color-color = gt_color-value = 'C' && sy-index && '00'. APPEND gt_color.
    gt_color-color = gt_color-value = 'C' && sy-index && '01'. APPEND gt_color.
    gt_color-color = gt_color-value = 'C' && sy-index && '10'. APPEND gt_color.
  ENDDO.

  ls_fieldcat-fieldname = 'VALUE'.
  ls_fieldcat-seltext_l = '颜色码'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_layout-box_fieldname = 'SEL'.
  ls_layout-info_fieldname = 'COLOR'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_COMMAND_COLOR'
      is_layout               = ls_layout
      it_fieldcat             = lt_fieldcat
      i_screen_start_column   = 130
      i_screen_start_line     = 5
      i_screen_end_column     = 150
      i_screen_end_line       = 25
    TABLES
      t_outtab                = gt_color[].

  READ TABLE gt_color WITH KEY sel = 'X'.
  p_color = gt_color-value.
ENDFORM.                                                    "f4_color
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND_COLOR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM user_command_color USING r_ucomm     LIKE sy-ucomm
                              rs_selfield TYPE slis_selfield.
  DATA: lt_color LIKE TABLE OF gt_color.
  CASE r_ucomm.
    WHEN '&ONT'.
      lt_color[] = gt_color[].
      DELETE lt_color WHERE sel = ''.
      IF lines( lt_color ) <> 1.
        MESSAGE '请选择一个行项目' TYPE 'E'.
      ENDIF.
    WHEN '&IC1'.
      gt_color-sel = 'X'.
      MODIFY gt_color INDEX rs_selfield-tabindex TRANSPORTING sel.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDFORM.                    "USER_COMMAND_COLOR
*&---------------------------------------------------------------------*
*&      Form  download
*&---------------------------------------------------------------------*
*       下载到Excel
*----------------------------------------------------------------------*
FORM download.
  DATA: l_file TYPE string,
        l_path TYPE string,
        l_fullpath TYPE string,
        l_action TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      default_file_name = l_file
    CHANGING
      filename          = l_file
      path              = l_path
      fullpath          = l_fullpath
      user_action       = l_action.

  CHECK l_action = 0.

  PERFORM create_excel_app.
  PERFORM open_workbook USING l_fullpath.

* =========TABLES==========
  CALL METHOD OF
      go_book
      'Sheets' = go_sheet
    EXPORTING
      #1       = 'TABLES'.
  IF sy-subrc <> 0.
    MESSAGE '打开TABLES工作表失败' TYPE 'E'.
  ENDIF.

  LOOP AT gt_tables INTO gs_table.
    g_row = sy-tabix + 1.
    PERFORM set_cell_value USING g_row 1 gs_table-tabname.
    IF gs_table-leftjoin = 'X'.
      PERFORM set_cell_value USING g_row 2 1.
    ENDIF.
    PERFORM set_cell_value USING g_row 3 gs_table-astable.
  ENDLOOP.
  CALL METHOD cl_gui_cfw=>flush.

* =========JOINS==========
  CALL METHOD OF
      go_book
      'Sheets' = go_sheet
    EXPORTING
      #1       = 'JOINS'.
  IF sy-subrc <> 0.
    MESSAGE '打开JOINS工作表失败' TYPE 'E'.
  ENDIF.

  LOOP AT gt_joins INTO gs_join.
    g_row = sy-tabix + 1.
    PERFORM set_cell_value USING g_row 1 gs_join-tab1.
    PERFORM set_cell_value USING g_row 2 gs_join-field1.
    PERFORM set_cell_value USING g_row 3 gs_join-tab2.
    PERFORM set_cell_value USING g_row 4 gs_join-field2.
  ENDLOOP.
  CALL METHOD cl_gui_cfw=>flush.

* =========FIELDS1==========
  CALL METHOD OF
      go_book
      'Sheets' = go_sheet
    EXPORTING
      #1       = 'FIELDS1'.
  IF sy-subrc <> 0.
    MESSAGE '打开FIELDS1工作表失败' TYPE 'E'.
  ENDIF.

  LOOP AT gt_fields1 INTO gs_field1.
    g_row = sy-tabix + 1.
    PERFORM set_cell_value USING g_row 1 gs_field1-astable.
    PERFORM set_cell_value USING g_row 2 gs_field1-fieldname.
    PERFORM set_cell_value USING g_row 3 gs_field1-asfield.
    IF gs_field1-query = 'X'.
      PERFORM set_cell_value USING g_row 4 1.
    ENDIF.
    PERFORM set_cell_value USING g_row 5 gs_field1-query_pos.
    IF gs_field1-single = 'X'.
      PERFORM set_cell_value USING g_row 6 1.
    ENDIF.
    IF gs_field1-display = 'X'.
      PERFORM set_cell_value USING g_row 7 1.
    ENDIF.
    PERFORM set_cell_value USING g_row 8 gs_field1-qfieldname.
    PERFORM set_cell_value USING g_row 9 gs_field1-cfieldname.
    PERFORM set_cell_value USING g_row 10 gs_field1-ref_table.
    PERFORM set_cell_value USING g_row 11 gs_field1-ref_field.
    PERFORM set_cell_value USING g_row 12 gs_field1-convexit.
    PERFORM set_cell_value USING g_row 13 gs_field1-emphasize.
    PERFORM set_cell_value USING g_row 14 gs_field1-scrtext_l.
  ENDLOOP.
  CALL METHOD cl_gui_cfw=>flush.

* =========FIELDS2==========
  CALL METHOD OF
      go_book
      'Sheets' = go_sheet
    EXPORTING
      #1       = 'FIELDS2'.
  IF sy-subrc <> 0.
    MESSAGE '打开FIELDS2工作表失败' TYPE 'E'.
  ENDIF.

  LOOP AT gt_fields2 INTO gs_field2.
    g_row = sy-tabix + 1.
    PERFORM set_cell_value USING g_row 1 gs_field2-fieldname.
    PERFORM set_cell_value USING g_row 2 gs_field2-qfieldname.
    PERFORM set_cell_value USING g_row 3 gs_field2-cfieldname.
    PERFORM set_cell_value USING g_row 4 gs_field2-ref_table.
    PERFORM set_cell_value USING g_row 5 gs_field2-ref_field.
    PERFORM set_cell_value USING g_row 6 gs_field2-convexit.
    PERFORM set_cell_value USING g_row 7 gs_field2-emphasize.
    PERFORM set_cell_value USING g_row 8 gs_field2-scrtext_l.
  ENDLOOP.
  CALL METHOD cl_gui_cfw=>flush.

  CALL METHOD OF
      go_book
      'SAVE'.
  SET PROPERTY OF go_excel 'Visible' = 1.

  MESSAGE '已下载到Excel文件中，请查看' TYPE 'S'.
ENDFORM.                    "download
*&---------------------------------------------------------------------*
*&      Form  upload
*&---------------------------------------------------------------------*
*       从Excel上载
*----------------------------------------------------------------------*
FORM upload.
  DATA: lt_list TYPE TABLE OF spopli WITH HEADER LINE,
        l_answer TYPE c,
        lt_filetable TYPE filetable WITH HEADER LINE,
        l_rc TYPE i,
        l_action TYPE i,
        l_flag_close TYPE c.

  IF go_excel IS NOT INITIAL.
    lt_list-varoption = '从刚下载的Excel文件上载'. APPEND lt_list.
    lt_list-varoption = '选择新的Excel文件进行上载'. APPEND lt_list.

    CALL FUNCTION 'POPUP_TO_DECIDE_LIST'
      EXPORTING
        textline1 = '如果还未关闭已经下载的Excel，可以选择从该Excel文件上载'
        titel     = '选择'
      IMPORTING
        answer    = l_answer
      TABLES
        t_spopli  = lt_list[].

    CHECK l_answer <> 'A'.
  ENDIF.

  IF go_excel IS INITIAL OR l_answer = 2.
    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        default_extension       = 'XLS'
        default_filename        = '*.xls;*.xlsx'
        file_filter             = 'Excel File (*.xls;*.xlsx)'
        multiselection          = ''
      CHANGING
        file_table              = lt_filetable[]
        rc                      = l_rc
        user_action             = l_action
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5.

    CHECK l_action = 0.

    PERFORM create_excel_app.

    READ TABLE lt_filetable INDEX 1.
    PERFORM open_workbook USING lt_filetable-filename.

    l_flag_close = 'X'.
  ENDIF.

  CLEAR: gt_tables, gt_joins, gt_fields1, gt_fields2.

* =========TABLES==========
  CALL METHOD OF
      go_book
      'Sheets' = go_sheet
    EXPORTING
      #1       = 'TABLES'.
  IF sy-subrc <> 0.
    MESSAGE '打开TABLES工作表失败' TYPE 'E'.
  ENDIF.

  WHILE 1 = 1.
    CLEAR: gs_table.
    g_row = sy-index + 1.
    PERFORM get_cell_value USING g_row 1 CHANGING gs_table-tabname.
    IF gs_table-tabname IS INITIAL.
      EXIT.
    ENDIF.
    PERFORM get_cell_value USING g_row 2 CHANGING gs_table-leftjoin.
    IF gs_table-leftjoin = '1'.
      gs_table-leftjoin = 'X'.
    ELSE.
      gs_table-leftjoin = ''.
    ENDIF.
    PERFORM get_cell_value USING g_row 3 CHANGING gs_table-astable.
    APPEND gs_table TO gt_tables.
  ENDWHILE.

* =========JOINS==========
  CALL METHOD OF
      go_book
      'Sheets' = go_sheet
    EXPORTING
      #1       = 'JOINS'.
  IF sy-subrc <> 0.
    MESSAGE '打开JOINS工作表失败' TYPE 'E'.
  ENDIF.

  WHILE 1 = 1.
    CLEAR: gs_join.
    g_row = sy-index + 1.
    PERFORM get_cell_value USING g_row 1 CHANGING gs_join-tab1.
    IF gs_join-tab1 IS INITIAL.
      EXIT.
    ENDIF.
    PERFORM get_cell_value USING g_row 2 CHANGING gs_join-field1.
    PERFORM get_cell_value USING g_row 3 CHANGING gs_join-tab2.
    PERFORM get_cell_value USING g_row 4 CHANGING gs_join-field2.
    APPEND gs_join TO gt_joins.
  ENDWHILE.

* =========FIELDS1==========
  CALL METHOD OF
      go_book
      'Sheets' = go_sheet
    EXPORTING
      #1       = 'FIELDS1'.
  IF sy-subrc <> 0.
    MESSAGE '打开FIELDS1工作表失败' TYPE 'E'.
  ENDIF.

  WHILE 1 = 1.
    CLEAR: gs_field1.
    g_row = sy-index + 1.
    PERFORM get_cell_value USING g_row 1 CHANGING gs_field1-astable.
    IF gs_field1-astable IS INITIAL.
      EXIT.
    ENDIF.
    PERFORM get_cell_value USING g_row 2 CHANGING gs_field1-fieldname.
    PERFORM get_cell_value USING g_row 3 CHANGING gs_field1-asfield.
    PERFORM get_cell_value USING g_row 4 CHANGING gs_field1-query.
    IF gs_field1-query = '1'.
      gs_field1-query = 'X'.
    ELSE.
      gs_field1-query = ''.
    ENDIF.
    PERFORM get_cell_value USING g_row 5 CHANGING gs_field1-query_pos.
    PERFORM get_cell_value USING g_row 6 CHANGING gs_field1-single.
    IF gs_field1-single = '1'.
      gs_field1-single = 'X'.
    ELSE.
      gs_field1-single = ''.
    ENDIF.
    PERFORM get_cell_value USING g_row 7 CHANGING gs_field1-display.
    IF gs_field1-display = '1'.
      gs_field1-display = 'X'.
    ELSE.
      gs_field1-display = ''.
    ENDIF.
    PERFORM get_cell_value USING g_row 8 CHANGING gs_field1-qfieldname.
    PERFORM get_cell_value USING g_row 9 CHANGING gs_field1-cfieldname.
    PERFORM get_cell_value USING g_row 10 CHANGING gs_field1-ref_table.
    PERFORM get_cell_value USING g_row 11 CHANGING gs_field1-ref_field.
    PERFORM get_cell_value USING g_row 12 CHANGING gs_field1-convexit.
    PERFORM get_cell_value USING g_row 13 CHANGING gs_field1-emphasize.
    PERFORM get_cell_value USING g_row 14 CHANGING gs_field1-scrtext_l.
    APPEND gs_field1 TO gt_fields1.
  ENDWHILE.

* =========FIELDS2==========
  CALL METHOD OF
      go_book
      'Sheets' = go_sheet
    EXPORTING
      #1       = 'FIELDS2'.
  IF sy-subrc <> 0.
    MESSAGE '打开FIELDS2工作表失败' TYPE 'E'.
  ENDIF.

  WHILE 1 = 1.
    CLEAR: gs_field2.
    g_row = sy-index + 1.
    PERFORM get_cell_value USING g_row 1 CHANGING gs_field2-fieldname.
    IF gs_field2-fieldname IS INITIAL.
      EXIT.
    ENDIF.
    PERFORM get_cell_value USING g_row 2 CHANGING gs_field2-qfieldname.
    PERFORM get_cell_value USING g_row 3 CHANGING gs_field2-cfieldname.
    PERFORM get_cell_value USING g_row 4 CHANGING gs_field2-ref_table.
    PERFORM get_cell_value USING g_row 5 CHANGING gs_field2-ref_field.
    PERFORM get_cell_value USING g_row 6 CHANGING gs_field2-convexit.
    PERFORM get_cell_value USING g_row 7 CHANGING gs_field2-emphasize.
    PERFORM get_cell_value USING g_row 8 CHANGING gs_field2-scrtext_l.
    APPEND gs_field2 TO gt_fields2.
  ENDWHILE.

  IF l_flag_close = 'X'.
    CALL METHOD OF
        go_book
        'Close'.
    CALL METHOD OF
        go_excel
        'QUIT'.
    FREE OBJECT: go_sheet, go_book, go_books, go_excel.
  ENDIF.

  MESSAGE '上载完成' TYPE 'S'.
ENDFORM.                    "upload
*&---------------------------------------------------------------------*
*&      Form  create_excel_app
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM create_excel_app.
  IF go_excel IS INITIAL.
    CREATE OBJECT go_excel 'Excel.Application'.
    IF sy-subrc <> 0.
      MESSAGE '创建Excel程序失败' TYPE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.                    "create_excel_app
*&---------------------------------------------------------------------*
*&      Form  open_workbook
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM open_workbook USING p_path.
  CALL METHOD OF
      go_excel
      'Workbooks' = go_books.
  CALL METHOD OF
      go_books
      'Open'   = go_book
    EXPORTING
      #1       = p_path.
  IF sy-subrc <> 0.
    MESSAGE '打开Excel文件失败' TYPE 'E'.
  ENDIF.
ENDFORM.                    "open_workbook
*&---------------------------------------------------------------------*
*&      Form  set_cell_value
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM set_cell_value USING p_row TYPE i
                          p_col TYPE i
                          p_value.
  g_row = p_row.
  g_col = p_col.
  g_value = p_value.

  CALL METHOD OF
      go_sheet
      'CELLS'  = go_cell
      NO
      FLUSH

    EXPORTING
      #1       = g_row
      #2       = g_col.
  SET PROPERTY OF go_cell 'Value' = g_value NO FLUSH.
ENDFORM.                    "set_cell_value
*&---------------------------------------------------------------------*
*&      Form  get_cell_value
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_cell_value USING p_row TYPE i
                          p_col TYPE i
                    CHANGING p_value.
  CALL METHOD OF
      go_sheet
      'CELLS'  = go_cell
    EXPORTING
      #1       = p_row
      #2       = p_col.
  GET PROPERTY OF go_cell 'Value' = p_value.
ENDFORM.                    "get_cell_value
*&---------------------------------------------------------------------*
*&      Form  CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM check .
  DATA: l_index TYPE i VALUE 1,
        l_index1 TYPE i,
        l_index2 TYPE i,
        l_tabix TYPE i,
        l_len TYPE i,
        l_off TYPE i,
        l_msg TYPE string,
        l_flag TYPE c,
        ls_dd02l TYPE dd02l,
        BEGIN OF lt_astable OCCURS 0,
          astable TYPE tabname,
          tabname TYPE tabname,
          index TYPE i,
        END OF lt_astable,
        BEGIN OF lt_asfield OCCURS 0,
          fieldname TYPE fieldname,
        END OF lt_asfield,
        BEGIN OF lt_syst OCCURS 0,
          fieldname TYPE fieldname,
        END OF lt_syst.

  DEFINE d_store_message.
    g_flag_error = 'X'.
    call function 'MESSAGE_STORE'
      exporting
        arbgb = '00'
        msgty = 'E'
        txtnr = '001'
        msgv1 = l_msg
        msgv2 = ''
        msgv3 = ''
        msgv4 = ''
        zeile = l_index.
    l_index = l_index + 1.
  END-OF-DEFINITION.

  SELECT fieldname INTO TABLE lt_syst FROM dd03l WHERE tabname = 'SYST' ORDER BY fieldname.
  LOOP AT lt_syst.
    lt_syst-fieldname = 'SY-' && lt_syst-fieldname.
    MODIFY lt_syst.
  ENDLOOP.

  CALL FUNCTION 'MESSAGES_INITIALIZE'.
  CLEAR g_flag_error.

  "表清单校验
  LOOP AT gt_tables INTO gs_table.
    l_tabix = sy-tabix.
    SELECT SINGLE * INTO ls_dd02l FROM dd02l WHERE tabname = gs_table-tabname AND as4vers = 'A'.
    IF sy-subrc <> 0.
      l_msg = '表清单：行' && l_tabix && '，表或视图' && gs_table-tabname && '不存在或未激活'.
      d_store_message.
    ELSEIF ls_dd02l-tabclass = 'CLUSTER'.
      IF lines( gt_tables ) > 1.
        l_msg = '表清单：行' && l_tabix && '，不能使用簇表' && gs_table-tabname.
        d_store_message.
      ENDIF.
    ELSEIF ls_dd02l-tabclass = 'VIEW'.
      IF ls_dd02l-viewclass <> 'D'.
        l_msg = '表清单：行' && l_tabix && '，视图' && gs_table-tabname && '不是数据库视图'.
        d_store_message.
      ENDIF.
    ENDIF.

    IF gs_table-astable IS NOT INITIAL.
      IF 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' NA gs_table-astable(1).
        l_msg = '表清单：行' && l_tabix && '，别名' && gs_table-astable && '必须以字母开头'.
        d_store_message.
      ENDIF.
      lt_astable-astable = gs_table-astable.
      lt_astable-tabname = gs_table-tabname.
      ADD 1 TO lt_astable-index.
      APPEND lt_astable.
    ELSE.
      lt_astable-astable = gs_table-tabname.
      lt_astable-tabname = gs_table-tabname.
      ADD 1 TO lt_astable-index.
      APPEND lt_astable.
    ENDIF.
  ENDLOOP.

  SORT lt_astable BY astable.
  DELETE ADJACENT DUPLICATES FROM lt_astable COMPARING astable.
  IF lines( lt_astable ) <> lines( gt_tables ).
    l_msg = '表清单：存在重复的表名或表别名'.
    d_store_message.
  ENDIF.

  "表关联校验
  LOOP AT gt_joins INTO gs_join.
    l_tabix = sy-tabix.
    CLEAR: l_index1, l_index2.

    IF gs_join-tab1 IS INITIAL OR gs_join-field1 IS INITIAL.
      l_msg = '表关联：行' && l_tabix && '，表1和字段1不能为空'.
      d_store_message.
    ELSE.
      READ TABLE lt_astable WITH KEY astable = gs_join-tab1 BINARY SEARCH.
      IF sy-subrc <> 0.
        l_msg = '表关联：行' && l_tabix && '，表1-' && gs_join-tab1 && '不存在'.
        d_store_message.
      ELSE.
        l_index1 = lt_astable-index.
        PERFORM check_field_exist USING lt_astable-tabname gs_join-field1 CHANGING l_flag.
        IF l_flag = 'X'.
          l_msg = '表关联：行' && l_tabix && '，表1-' && gs_join-tab1 && '中字段' && gs_join-field1 &&'不存在或未激活'.
          d_store_message.
        ENDIF.
      ENDIF.
    ENDIF.

    IF gs_join-tab2 IS INITIAL. "校验特定值
      IF gs_join-field2 IS INITIAL.
        l_msg = '表关联：行' && l_tabix && '，字段2或特定值不存在'.
        d_store_message.
      ELSEIF gs_join-field2(1) <> ''''.
        READ TABLE lt_syst WITH KEY fieldname = gs_join-field2 BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          l_msg = '表关联：行' && l_tabix && '，特定值' && gs_join-field2 && '填写错误，只能为SYST中字段或常数'.
          d_store_message.
        ENDIF.
      ELSE.
        l_len = strlen( gs_join-field2 ).
        IF l_len = 1.
          l_msg = '表关联：行' && l_tabix && '，特定值' && gs_join-field2 && '填写错误，只能为SYST中字段或常数'.
          d_store_message.
        ELSE.
          l_off = l_len - 1.
          IF gs_join-field2+l_off(1) <> ''''.
            l_msg = '表关联：行' && l_tabix && '，特定值' && gs_join-field2 && '填写错误，只能为SYST中字段或常数'.
            d_store_message.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE.
      READ TABLE lt_astable WITH KEY astable = gs_join-tab2 BINARY SEARCH.
      IF sy-subrc <> 0.
        l_msg = '表关联：行' && l_tabix && '，表2-' && gs_join-tab2 && '不存在'.
        d_store_message.
      ELSE.
        l_index2 = lt_astable-index.
        PERFORM check_field_exist USING lt_astable-tabname gs_join-field2 CHANGING l_flag.
        IF l_flag = 'X'.
          l_msg = '表关联：行' && l_tabix && '，表2-' && gs_join-tab2 && '中字段' && gs_join-field2 &&'不存在或未激活'.
          d_store_message.
        ELSE.
          IF l_index1 < l_index2 AND l_index1 > 0.
            l_msg = '表关联：行' && l_tabix && '，请遵循约定：表1-' && gs_join-tab1 && '在“表清单”位置需要在表2-' && gs_join-tab2 && '以下'.
            d_store_message.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

  "字段重复性校验
  LOOP AT gt_fields1 INTO gs_field1.
    IF gs_field1-asfield IS INITIAL.
      lt_asfield-fieldname = gs_field1-fieldname.
    ELSE.
      lt_asfield-fieldname = gs_field1-asfield.
    ENDIF.
    APPEND lt_asfield.
    CLEAR lt_asfield.
  ENDLOOP.

  LOOP AT gt_fields2 INTO gs_field2.
    lt_asfield-fieldname = gs_field2-fieldname.
    APPEND lt_asfield.
    CLEAR lt_asfield.
  ENDLOOP.

  SORT lt_asfield BY fieldname.
  DELETE ADJACENT DUPLICATES FROM lt_asfield COMPARING fieldname.
  IF lines( lt_asfield ) <> lines( gt_fields1 ) + lines( gt_fields2 ).
    l_msg = '字段设置、附加字段：存在重复的字段名或字段别名'.
    d_store_message.
  ENDIF.

  "字段设置
  READ TABLE gt_fields1 WITH KEY query = 'X' TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0.
    l_msg = '字段设置：请至少设置一个查询条件'.
    d_store_message.
  ENDIF.
  READ TABLE gt_fields1 WITH KEY display = 'X' TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0.
    l_msg = '字段设置：请至少设置一个输出字段'.
    d_store_message.
  ENDIF.
  LOOP AT gt_fields1 INTO gs_field1.
    l_tabix = sy-tabix.
    IF gs_field1-astable IS INITIAL OR gs_field1-fieldname IS INITIAL.
      l_msg = '字段设置：行' && l_tabix && '，表和字段不能为空'.
    ELSE.
      READ TABLE lt_astable WITH KEY astable = gs_field1-astable BINARY SEARCH.
      IF sy-subrc <> 0.
        l_msg = '字段设置：行' && l_tabix && '，表' && gs_field1-astable && '不存在'.
        d_store_message.
      ELSE.
        PERFORM check_field_exist USING lt_astable-tabname gs_field1-fieldname CHANGING l_flag.
        IF l_flag = 'X'.
          l_msg = '字段设置：行' && l_tabix && '，表' && gs_field1-astable && '中字段' && gs_field1-fieldname &&'不存在或未激活'.
          d_store_message.
        ENDIF.
      ENDIF.
    ENDIF.
    IF gs_field1-asfield IS NOT INITIAL.
      IF 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' NA gs_field1-asfield(1).
        l_msg = '字段设置：行' && l_tabix && '，字段' && gs_field1-fieldname && '的别名' && gs_field1-asfield && '必须以字母开头'.
        d_store_message.
      ENDIF.
    ENDIF.
    IF gs_field1-ref_table IS NOT INITIAL.
      SELECT SINGLE tabname INTO gs_field1-ref_table FROM dd02l WHERE tabname = gs_field1-ref_table AND as4vers = 'A'.
      IF sy-subrc <> 0.
        l_msg = '字段设置：行' && l_tabix && '，字段' && gs_field1-fieldname && '的参照表' && gs_field1-ref_table && '不存在或未激活'.
        d_store_message.
      ELSEIF gs_field1-ref_field IS NOT INITIAL.
        PERFORM check_field_exist USING gs_field1-ref_table gs_field1-ref_field CHANGING l_flag.
        IF l_flag = 'X'.
          l_msg = '字段设置：行' && l_tabix && '，字段' && gs_field1-fieldname && '的参照表' && gs_field1-ref_table && '中参照字段' && gs_field1-ref_field &&'不存在或未激活'.
          d_store_message.
        ENDIF.
      ENDIF.
    ELSE.
      IF gs_field1-ref_field IS NOT INITIAL.
        SELECT SINGLE rollname INTO gs_field1-ref_field FROM dd04l WHERE rollname = gs_field1-ref_field AND as4vers = 'A'.
        IF sy-subrc <> 0.
          l_msg = '字段设置：行' && l_tabix && '，字段' && gs_field1-fieldname && '的参照字段(数据元素)' && gs_field1-ref_field &&'不存在或未激活'.
          d_store_message.
        ENDIF.
      ENDIF.
    ENDIF.
    IF gs_field1-qfieldname IS NOT INITIAL.
      READ TABLE lt_asfield WITH KEY fieldname = gs_field1-qfieldname BINARY SEARCH TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        l_msg = '字段设置：行' && l_tabix && '，字段' && gs_field1-fieldname && '的单位字段' && gs_field1-qfieldname &&'不存在'.
        d_store_message.
      ENDIF.
    ENDIF.
    IF gs_field1-cfieldname IS NOT INITIAL.
      READ TABLE lt_asfield WITH KEY fieldname = gs_field1-cfieldname BINARY SEARCH TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        l_msg = '字段设置：行' && l_tabix && '，字段' && gs_field1-fieldname && '的货币字段' && gs_field1-cfieldname &&'不存在'.
        d_store_message.
      ENDIF.
    ENDIF.
  ENDLOOP.

  "附加字段
  LOOP AT gt_fields2 INTO gs_field2.
    l_tabix = sy-tabix.
    IF gs_field2-ref_table IS NOT INITIAL.
      SELECT SINGLE tabname INTO gs_field2-ref_table FROM dd02l WHERE tabname = gs_field2-ref_table AND as4vers = 'A'.
      IF sy-subrc <> 0.
        l_msg = '附加字段：行' && l_tabix && '，字段' && gs_field2-fieldname && '的参照表' && gs_field2-ref_table && '不存在或未激活'.
        d_store_message.
      ELSEIF gs_field2-ref_field IS NOT INITIAL.
        PERFORM check_field_exist USING gs_field2-ref_table gs_field2-ref_field CHANGING l_flag.
        IF l_flag = 'X'.
          l_msg = '附加字段：行' && l_tabix && '，字段' && gs_field2-fieldname && '的参照表' && gs_field2-ref_table && '中参照字段' && gs_field2-ref_field &&'不存在或未激活'.
          d_store_message.
        ENDIF.
      ENDIF.
    ELSE.
      IF gs_field2-ref_field IS NOT INITIAL.
        SELECT SINGLE rollname INTO gs_field2-ref_field FROM dd04l WHERE rollname = gs_field2-ref_field AND as4vers = 'A'.
        IF sy-subrc <> 0.
          l_msg = '附加字段：行' && l_tabix && '，字段' && gs_field2-fieldname && '的参照字段(数据元素)' && gs_field2-ref_field &&'不存在或未激活'.
          d_store_message.
        ENDIF.
      ELSE.
        l_msg = '附加字段：行' && l_tabix && '，字段' && gs_field2-fieldname && '的参照属性必须指定'.
        d_store_message.
      ENDIF.
    ENDIF.
    IF gs_field2-qfieldname IS NOT INITIAL.
      READ TABLE lt_asfield WITH KEY fieldname = gs_field2-qfieldname BINARY SEARCH TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        l_msg = '附加字段：行' && l_tabix && '，字段' && gs_field2-fieldname && '的单位字段' && gs_field2-qfieldname &&'不存在'.
        d_store_message.
      ENDIF.
    ENDIF.
    IF gs_field2-cfieldname IS NOT INITIAL.
      READ TABLE lt_asfield WITH KEY fieldname = gs_field2-cfieldname BINARY SEARCH TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        l_msg = '附加字段：行' && l_tabix && '，字段' && gs_field2-fieldname && '的货币字段' && gs_field2-cfieldname &&'不存在'.
        d_store_message.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF g_flag_error = 'X'.
    CALL FUNCTION 'MESSAGES_SHOW'.
  ENDIF.
ENDFORM.                    " CHECK
*&---------------------------------------------------------------------*
*&      Form  ALV_REFRESH_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_refresh_display .
  go_alv_tables->refresh_table_display( ).
  go_alv_joins->refresh_table_display( ).
  go_alv_fields1->refresh_table_display( ).
  go_alv_fields2->refresh_table_display( ).
ENDFORM.                    " ALV_REFRESH_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  check_field_exist
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM check_field_exist USING p_tabname TYPE tabname
                             p_fieldname TYPE fieldname
                       CHANGING p_flag TYPE c.
  DATA: l_fieldname TYPE fieldname.

  CLEAR p_flag.
  SELECT SINGLE fieldname INTO l_fieldname
    FROM dd03l
    WHERE tabname = p_tabname
      AND fieldname = p_fieldname
      AND as4local = 'A'.
  CHECK sy-subrc <> 0.
  p_flag = 'X'.
ENDFORM.                    "check_field_exist