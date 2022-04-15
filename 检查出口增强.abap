REPORT  zbb_find_exit
NO STANDARD PAGE HEADING LINE-SIZE 255.

TABLES : tstc,     "SAP Transaction Codes(SAP 事务代码)
         tadir,    "Directory of Repository Objects(资源库对象的目录)
         modsapt,  "SAP Enhancements - Short Texts(SAP增强-短文件)
         sxs_attrt,"Exit: Definition side: Attributes, Text table
         modact,   "Modifications(修正)
         trdir,    "System table TRDIR(系统表 TRDIR)
         tfdir,    "Function Module(功能模块)
         enlfdir,  "Additional Attributes for Function Modules(功能模块的附加属性)
         tstct.    "Transaction Code Texts(事务代码文本)

DATA : jtab LIKE tadir OCCURS 0 WITH HEADER LINE. "SMOD
DATA : itab LIKE tadir OCCURS 0 WITH HEADER LINE. "SE18-BADI
DATA : ktab LIKE tadir OCCURS 0 WITH HEADER LINE. "Enhancement implementation-ENHO
DATA : ltab LIKE tadir OCCURS 0 WITH HEADER LINE. "Enhancement Spot-ENHS
DATA : mtab LIKE tadir OCCURS 0 WITH HEADER LINE. "Composite Enhancement implementation-ENHC
DATA : field1(30).
DATA : v_devclass LIKE tadir-devclass.
DATA : t_count LIKE sy-tfill.
DATA: bdcdata_wa  TYPE bdcdata,
      bdcdata_tab TYPE TABLE OF bdcdata.

DATA opt TYPE ctu_params.


SELECTION-SCREEN BEGIN OF BLOCK a01 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN SKIP.
  PARAMETERS : p_tcode LIKE tstc-tcode OBLIGATORY.
  SELECTION-SCREEN SKIP.
SELECTION-SCREEN END OF BLOCK a01.


START-OF-SELECTION.
  CLEAR: itab,jtab.
  REFRESH:itab,jtab.
  SELECT SINGLE * FROM tstc WHERE tcode EQ p_tcode.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM tadir
    WHERE pgmid    = 'R3TR'
    AND object   = 'PROG'
    AND obj_name = tstc-pgmna.

    MOVE : tadir-devclass TO v_devclass.
    IF sy-subrc NE 0.
      SELECT SINGLE * FROM trdir
      WHERE name = tstc-pgmna.
      IF trdir-subc EQ 'F'.
        SELECT SINGLE * FROM tfdir
        WHERE pname = tstc-pgmna.
        SELECT SINGLE * FROM enlfdir
        WHERE funcname = tfdir-funcname.
        SELECT SINGLE * FROM tadir
        WHERE pgmid    = 'R3TR'
        AND object   = 'FUGR'
        AND obj_name = enlfdir-area.
        MOVE : tadir-devclass TO v_devclass.
      ENDIF.
    ENDIF.

    SELECT * FROM tadir
    INTO TABLE jtab
    WHERE pgmid    = 'R3TR'
    AND object   = 'SMOD'
    AND devclass = v_devclass.
    SELECT * FROM tadir
    INTO TABLE itab
    WHERE pgmid    = 'R3TR'
    AND object   = 'SXSD'
    AND devclass = v_devclass.
    SELECT * FROM tadir
    INTO TABLE ktab
    WHERE pgmid    = 'R3TR'
    AND object   = 'ENHO'
    AND devclass = v_devclass.
    SELECT * FROM tadir
    INTO TABLE ltab
    WHERE pgmid    = 'R3TR'
    AND object   = 'ENHS'
    AND devclass = v_devclass.
    SELECT * FROM tadir
    INTO TABLE mtab
    WHERE pgmid    = 'R3TR'
    AND object   = 'ENHC'
    AND devclass = v_devclass.

    SELECT SINGLE * FROM tstct
    WHERE sprsl EQ sy-langu
    AND tcode EQ p_tcode.


    FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
    WRITE:/(12) '事务代码 - ',
    13(20) p_tcode,
    34(10) '功能 - ' ,
    45(50) tstct-ttext.
    SKIP.
    IF NOT jtab[] IS INITIAL.
      WRITE:/(117) sy-uline.
      FORMAT COLOR COL_HEADING INTENSIFIED ON.
      WRITE:/1 sy-vline,
      2 'Exit Name',
      43 sy-vline ,
      44 'Description',
      117 sy-vline.
      WRITE:/(117) sy-uline.

      LOOP AT jtab.
        CLEAR modsapt.
        SELECT SINGLE * FROM modsapt
        WHERE sprsl = sy-langu AND
        name = jtab-obj_name.
        FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
        WRITE:/1 sy-vline,
        2 jtab-obj_name HOTSPOT ON,
        43 sy-vline ,
        44 modsapt-modtext,
        117 sy-vline.
      ENDLOOP.
      WRITE:/(117) sy-uline.
      FORMAT COLOR COL_HEADING INTENSIFIED ON.
      WRITE:/1 sy-vline,
      2 'Badi Name(definition)',
      43 sy-vline ,
      44 'Description',
      117 sy-vline.
      WRITE:/(117) sy-uline.
      LOOP AT itab.
        CLEAR sxs_attrt.
        SELECT SINGLE * FROM sxs_attrt
        WHERE sprsl = sy-langu AND
        exit_name = itab-obj_name.
        FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
        WRITE:/1 sy-vline,
        2 itab-obj_name HOTSPOT ON,
        43 sy-vline ,
        44 sxs_attrt-text,
        117 sy-vline.
      ENDLOOP.

      WRITE:/(117) sy-uline.
      FORMAT COLOR COL_HEADING INTENSIFIED ON.
      WRITE:/1 sy-vline,
      2 'Enhancement Implementation',
      43 sy-vline ,
      44 'Description',
      117 sy-vline.
      WRITE:/(117) sy-uline.
      LOOP AT ktab.
        CLEAR sxs_attrt.
        SELECT SINGLE * FROM sxs_attrt
        WHERE sprsl = sy-langu AND
        exit_name = ktab-obj_name.
        FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
        WRITE:/1 sy-vline,
        2 ktab-obj_name HOTSPOT ON,
        43 sy-vline ,
        44 sxs_attrt-text,
        117 sy-vline.
      ENDLOOP.

      WRITE:/(117) sy-uline.
      FORMAT COLOR COL_HEADING INTENSIFIED ON.
      WRITE:/1 sy-vline,
      2 'Enhancement Spot',
      43 sy-vline ,
      44 'Description',
      117 sy-vline.
      WRITE:/(117) sy-uline.
      LOOP AT ltab.
        CLEAR sxs_attrt.
        SELECT SINGLE * FROM sxs_attrt
        WHERE sprsl = sy-langu AND
        exit_name = ltab-obj_name.
        FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
        WRITE:/1 sy-vline,
        2 ltab-obj_name HOTSPOT ON,
        43 sy-vline ,
        44 sxs_attrt-text,
        117 sy-vline.
      ENDLOOP.

      WRITE:/(117) sy-uline.
      FORMAT COLOR COL_HEADING INTENSIFIED ON.
      WRITE:/1 sy-vline,
      2 'Composite Enhancement Implementation',
      43 sy-vline ,
      44 'Description',
      117 sy-vline.
      WRITE:/(117) sy-uline.
      LOOP AT mtab.
        CLEAR sxs_attrt.
        SELECT SINGLE * FROM sxs_attrt
        WHERE sprsl = sy-langu AND
        exit_name = mtab-obj_name.
        FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
        WRITE:/1 sy-vline,
        2 mtab-obj_name HOTSPOT ON,
        43 sy-vline ,
        44 sxs_attrt-text,
        117 sy-vline.
      ENDLOOP.


      WRITE:/(117) sy-uline.
      CLEAR t_count.
      DESCRIBE TABLE jtab.
      t_count = sy-tfill.
      DESCRIBE TABLE itab.
      t_count = t_count + sy-tfill.
      DESCRIBE TABLE ktab.
      t_count = t_count + sy-tfill.
      DESCRIBE TABLE ltab.
      t_count = t_count + sy-tfill.
      DESCRIBE TABLE mtab.
      t_count = t_count + sy-tfill.

      SKIP.
      FORMAT COLOR COL_TOTAL INTENSIFIED ON.
      WRITE:/ '用户出口数量:' , t_count.
    ELSE.
      FORMAT COLOR COL_NEGATIVE INTENSIFIED ON.
      WRITE:/(95) '此TCode没有用户出口！'.
    ENDIF.
  ELSE.
    FORMAT COLOR COL_NEGATIVE INTENSIFIED ON.
    WRITE:/(95) '事务代码不存在！'.
  ENDIF.

AT LINE-SELECTION.
  GET CURSOR FIELD field1.
  IF field1(4) EQ 'JTAB'.
    SET PARAMETER ID 'MON' FIELD sy-lisel+1(10).
    CALL TRANSACTION 'SMOD' AND SKIP FIRST SCREEN.
  ELSEIF field1(4) EQ 'ITAB'.
*    SET PARAMETER ID 'EXN' FIELD sy-lisel+1(40).
*    CALL TRANSACTION 'SE18' AND SKIP FIRST SCREEN.
    CLEAR bdcdata_wa.
    bdcdata_wa-program  = 'SAPLSEXO'.
    bdcdata_wa-dynpro   = '0100'.
    bdcdata_wa-dynbegin = 'X'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'BDC_CURSOR'.
    bdcdata_wa-fval = 'G_ENHSPOTNAME'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'G_IS_BADI'.
    bdcdata_wa-fval = 'X'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'BDC_OKCODE'.
    bdcdata_wa-fval = '=ISSPOT'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-program  = 'SAPLSEXO'.
    bdcdata_wa-dynpro   = '0100'.
    bdcdata_wa-dynbegin = 'X'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'BDC_CURSOR'.
    bdcdata_wa-fval = 'G_BADINAME'.
    APPEND bdcdata_wa TO bdcdata_tab.
    CLEAR bdcdata_wa.

    bdcdata_wa-fnam = 'G_BADINAME'.
    bdcdata_wa-fval = sy-lisel+1(40).
    APPEND bdcdata_wa TO bdcdata_tab.

    opt-dismode = 'E'.
    opt-defsize = 'X'.

    CALL TRANSACTION 'SE18' USING bdcdata_tab OPTIONS FROM opt.
    REFRESH bdcdata_tab.
  ELSEIF field1(4) EQ 'KTAB'.
*    SET PARAMETER ID 'IMN_BADI' FIELD sy-lisel+1(40).
*    CALL TRANSACTION 'SE19' AND SKIP FIRST SCREEN.
    CLEAR bdcdata_wa.
    bdcdata_wa-program  = 'SAPLENHANCEMENTS'.
    bdcdata_wa-dynpro   = '0100'.
    bdcdata_wa-dynbegin = 'X'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'BDC_CURSOR'.
    bdcdata_wa-fval = 'RSEUX-CXH_VALUE'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'RSEUX-CXH'.
    bdcdata_wa-fval = 'X'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'RSEUX-CXH_VALUE'.
    bdcdata_wa-fval = sy-lisel+1(40).
    APPEND bdcdata_wa TO bdcdata_tab.

*    CLEAR bdcdata_wa.
*    bdcdata_wa-fnam = 'BDC_OKCODE'.
*    bdcdata_wa-fval = '/00'.
*    APPEND bdcdata_wa TO bdcdata_tab.

    opt-dismode = 'E'.
    opt-defsize = 'X'.

    CALL TRANSACTION 'SE20' USING bdcdata_tab OPTIONS FROM opt.
    REFRESH bdcdata_tab.
  ELSEIF field1(4) EQ 'LTAB'.
*    SET PARAMETER ID 'ENHSPOT' FIELD sy-lisel+1(40).
*    CALL TRANSACTION 'SE18' AND SKIP FIRST SCREEN.
    CLEAR bdcdata_wa.
    bdcdata_wa-program  = 'SAPLENHANCEMENTS'.
    bdcdata_wa-dynpro   = '0100'.
    bdcdata_wa-dynbegin = 'X'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'BDC_CURSOR'.
    bdcdata_wa-fval = 'RSEUX-C_XS_VALUE'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'RSEUX-C_XS'.
    bdcdata_wa-fval = 'X'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'RSEUX-C_XS_VALUE'.
    bdcdata_wa-fval = sy-lisel+1(40).
    APPEND bdcdata_wa TO bdcdata_tab.

*    CLEAR bdcdata_wa.
*    bdcdata_wa-fnam = 'BDC_OKCODE'.
*    bdcdata_wa-fval = '/00'.
*    APPEND bdcdata_wa TO bdcdata_tab.

    opt-dismode = 'E'.
    opt-defsize = 'X'.

    CALL TRANSACTION 'SE20' USING bdcdata_tab OPTIONS FROM opt.
    REFRESH bdcdata_tab.
  ELSEIF field1(4) EQ 'MTAB'.
*    SET PARAMETER ID 'IMN_BADI' FIELD sy-lisel+1(40).
    CLEAR bdcdata_wa.
    bdcdata_wa-program  = 'SAPLENHANCEMENTS'.
    bdcdata_wa-dynpro   = '0100'.
    bdcdata_wa-dynbegin = 'X'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'BDC_CURSOR'.
    bdcdata_wa-fval = 'RSEUX-CXT_VALUE'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'RSEUX-CXT'.
    bdcdata_wa-fval = 'X'.
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'RSEUX-CXT_VALUE'.
    bdcdata_wa-fval = sy-lisel+1(40).
    APPEND bdcdata_wa TO bdcdata_tab.

    CLEAR bdcdata_wa.
    bdcdata_wa-fnam = 'BDC_OKCODE'.
    bdcdata_wa-fval = '/00'.
    APPEND bdcdata_wa TO bdcdata_tab.

    opt-dismode = 'E'.
    opt-defsize = 'X'.

    CALL TRANSACTION 'SE20' USING bdcdata_tab OPTIONS FROM opt.
    REFRESH bdcdata_tab.
  ENDIF.