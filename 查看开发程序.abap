TABLES: trdir, tstc.
DATA: BEGIN OF gs_data,
        sel   TYPE boolean,     " 用于选择多行
        name  TYPE trdir-name,  " 程序名
        subc  TYPE trdir-subc,  " 程序类型
        rstat TYPE trdir-rstat, " 状态
        tcode TYPE tstc-tcode,  " 事务码
        ttext TYPE tstct-ttext, " 事务码描述
        cnam  TYPE trdir-cnam,  " 创建者
        cdat  TYPE trdir-cdat,  " 创建日期
        unam  TYPE trdir-unam,  " 最后修改人
        udat  TYPE trdir-udat,  " 修改日期
      END OF gs_data.
DATA: gt_data LIKE TABLE OF gs_data. " ALV显示內表
DATA: line TYPE i." ALV行数
" 选择屏幕
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_name  FOR trdir-name,            " 程序名
  s_tcode FOR  tstc-tcode,           " 事务码
  s_cnam  FOR  trdir-cnam,           " 创建者
  s_unam  FOR  trdir-unam,           " 最后修改人
  s_subc  FOR  trdir-subc DEFAULT 1, " 程序类型
  s_rstat FOR  trdir-rstat.          " 状态
SELECTION-SCREEN END OF BLOCK b1.
" F8事件

START-OF-SELECTION.
  IF s_name[]  IS INITIAL AND " 程序名
  s_cnam[]  IS INITIAL AND " 创建者
  s_unam[]  IS INITIAL AND " 最后修改人
  s_subc[]  IS INITIAL AND " 程序类型
  s_tcode[] IS INITIAL AND " 事务码
  s_rstat[] IS INITIAL.    " 状态

    MESSAGE '请至少输入一个条件！' TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.
  PERFORM get_data.
  IF gt_data[] IS INITIAL.
    MESSAGE '无符合条件的记录' TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.
  PERFORM alv_data.
*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       text  获取数据
*----------------------------------------------------------------------*
FORM get_data.
  DATA: BEGIN OF ls_tstc,
          tcode TYPE tstc-tcode,
          ttext TYPE tstct-ttext,
        END OF ls_tstc.

  DATA: lt_tstc LIKE TABLE OF ls_tstc.
  " 输入事务码时
  IF s_tcode[] IS NOT INITIAL.
    SELECT
    a~tcode
    b~name
    b~subc
    b~rstat
    b~cnam
    b~cdat
    b~unam
    b~udat
    c~ttext
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM tstc AS a
    INNER JOIN trdir AS b ON a~pgmna = b~name
    INNER JOIN tstct AS c ON a~tcode = c~tcode
    WHERE a~tcode IN s_tcode
    AND   b~name  IN s_name   " 程序名
    AND   b~cnam  IN s_cnam   " 创建者
    AND   b~unam  IN s_unam   " 最后修改人
    AND   b~subc  IN s_subc   " 程序类型
    AND   b~rstat IN s_rstat. " 状态
  ELSE.
    " 没有输入事务码时
    SELECT
    a~name
    a~subc
    a~rstat
    a~cnam
    a~cdat
    a~unam
    a~udat
    b~tcode
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM trdir AS a
    LEFT JOIN tstc AS b ON a~name  = b~pgmna
    WHERE a~name  IN s_name   " 程序名
    AND   a~cnam  IN s_cnam   " 创建者
    AND   a~unam  IN s_unam   " 最后修改人
    AND   a~subc  IN s_subc   " 程序类型
    AND   a~rstat IN s_rstat. " 状态

    IF gt_data[] IS NOT INITIAL.
      " 查询事务码描述文本
      SELECT
      tcode
      ttext
      INTO CORRESPONDING FIELDS OF TABLE lt_tstc
      FROM tstct
      FOR ALL ENTRIES IN gt_data
      WHERE tcode = gt_data-tcode.
      SORT lt_tstc BY tcode." 先排序
      LOOP AT gt_data INTO gs_data.
        READ TABLE lt_tstc INTO ls_tstc WITH KEY tcode = gs_data-tcode BINARY SEARCH.
        IF sy-subrc EQ 0.
          gs_data-ttext = ls_tstc-ttext.
          MODIFY gt_data FROM gs_data TRANSPORTING ttext.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
  " 统计內表行数
  DESCRIBE TABLE gt_data LINES line.
  " 排序
  SORT gt_data BY cnam cdat.
ENDFORM.                    "get_data
*&---------------------------------------------------------------------*
*&      Form  alv_data
*&---------------------------------------------------------------------*
*       text 显示ALV数据
*----------------------------------------------------------------------*
FORM alv_data.
  DATA: fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE,
        layout   TYPE slis_layout_alv.
  PERFORM get_layout CHANGING layout.   " alv布局
  PERFORM get_fieldcat TABLES fieldcat. " 控制报表显示哪些栏位
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid             " 程序名
      is_layout          = layout               " 布局
"     i_callback_pf_status_set = 'PFSTATUS_FORM'      " STATUS
     i_callback_user_command  = 'USER_COMMAND_FORM'  " 定义按钮的功能
      it_fieldcat        = fieldcat[]           " alv栏目（显示字段）内表
    TABLES
      t_outtab           = gt_data              " 将内表数据赋给ALV
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    "alv_data
*&---------------------------------------------------------------------*
*&      Form  get_layout
*&---------------------------------------------------------------------*
*       text  ALV布局设置
*----------------------------------------------------------------------*
*      -->C_LAYOUT   text
*----------------------------------------------------------------------*
FORM get_layout CHANGING c_layout TYPE slis_layout_alv.
  CLEAR: c_layout.
  c_layout-colwidth_optimize = 'X'." 宽度自动调节
  c_layout-box_fieldname = 'SEL'.  " 选择多行
  c_layout-zebra = 'X'.            " 颜色交替显示
ENDFORM.                    "get_layout
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND_FORM
*&---------------------------------------------------------------------*
*       text  自定义按钮功能
*----------------------------------------------------------------------*
*      -->R_UCOMM      text
*      -->RS_SELFIELD  text
*----------------------------------------------------------------------*
FORM user_command_form USING r_ucomm     LIKE sy-ucomm
      rs_selfield TYPE slis_selfield.
  READ TABLE gt_data INTO gs_data INDEX rs_selfield-tabindex.
  IF sy-subrc EQ 0 AND gs_data-tcode IS NOT INITIAL.
    CASE r_ucomm.
      WHEN '&IC1'. " 双击事件
        CALL TRANSACTION gs_data-tcode. " 调用事务码，运行程序
      WHEN OTHERS.
    ENDCASE.
  ENDIF.
ENDFORM.                    "USER_COMMAND_FORM
*&---------------------------------------------------------------------*
*&      Form  get_fieldcat
*&---------------------------------------------------------------------*
*       text 显示字段
*----------------------------------------------------------------------*
*      -->CT_TAB     text
*----------------------------------------------------------------------*
FORM get_fieldcat TABLES ct_tab TYPE slis_t_fieldcat_alv.
  DATA: fcat TYPE slis_fieldcat_alv.
  DEFINE add_fcat.
    CLEAR fcat.
    fcat-fieldname       = &1. " 字段名
    fcat-seltext_l       = &2. " 显示字段文本
    fcat-seltext_m       = &2.
    fcat-seltext_s       = &2.
    fcat-key             = &3. " 主键
    fcat-hotspot         = &4. " 链接
    fcat-checkbox        = &5. " 复选框
    fcat-edit            = &6. " 是否可修改
    fcat-ref_tabname     = &7. " 参考表
    fcat-ref_fieldname   = &8. " 参考表字段
    APPEND fcat TO ct_tab.
  END-OF-DEFINITION.
  add_fcat 'NAME'  '程序名'      ''  ''  ''  ''  ''  ''.
  add_fcat 'SUBC'  '程序类型'    ''  ''  ''  ''  'TRDIR'  'SUBC'.
  add_fcat 'RSTAT' '状态'        ''  ''  ''  ''  'TRDIR'  'RSTAT'.
  add_fcat 'TCODE' '事务码'      ''  ''  ''  ''  ''  ''.
  add_fcat 'TTEXT' '事务码描述'  ''  ''  ''  ''  ''  ''.
  add_fcat 'CNAM'  '创建者'  ''  ''  ''  ''  ''  ''.
  add_fcat 'CDAT'  '创建日期'    ''  ''  ''  ''  ''  ''.
  add_fcat 'UNAM'  '最后修改人'  ''  ''  ''  ''  ''  ''.
  add_fcat 'UDAT'  '修改日期'    ''  ''  ''  ''  ''  ''.
ENDFORM.                    "get_fieldcat
*&---------------------------------------------------------------------*
*&      Form  pfstatus_form
*&---------------------------------------------------------------------*
*       text  STATUS
*----------------------------------------------------------------------*
*      -->RT_EXTAB   text
*----------------------------------------------------------------------*
FORM pfstatus_form USING rt_extab TYPE slis_t_extab.
  SET TITLEBAR 'TITLE_BAR' WITH line. " 标题
  SET PF-STATUS 'STATUS_BAR'.         " 工具条
ENDFORM.