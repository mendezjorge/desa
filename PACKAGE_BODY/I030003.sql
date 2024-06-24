
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I030003" is

  -- Private type declarations
  type r_parameter is record(
    collection_name varchar2(30):='COLL_BDATOS',
    collection_name1 varchar2(30):='BDET_PROD',
    collection_name2 varchar2(30):='BDEPO_PROD',
    p_formulario     varchar2(30):='I0403001'
  );
  parameter r_parameter;

  type r_bsel is record(
    producto number,
    s_fech_inic varchar2(10),
    s_fech_fini varchar2(10),
    depo_codi_orig number,
    depo_codi_dest number,
    oper_codi number,
    timo_codi number,
    s_movi_nume number,
    sum_sald_inic number,
    fech_inic date,
    indi_inte varchar2(1)
  );
  bsel r_bsel;

  type r_bdatos is record(
    PROD_CODI_ALFA varchar2(20),
    PROD_DESC varchar2(200),
    TIMO_DESC_ABRE varchar2(10),
    OPER_DESC_ABRE varchar2(10),
    MOVI_CODI      number,
    MOVI_NUME      number,
    MOVI_FECH_EMIS date,
    MOVI_DEPO_CODI_ORIG number,
    MOVI_SUCU_CODI_ORIG number,
    MOVI_DEPO_CODI_DEST number,
    MOVI_SUCU_CODI_DEST number,
    CANT_ENTR           number,
    CANT_SALI           number,
    TOTA_ITEM           number,
    TOTA_ITEM_CON_INTE  number,
    CF_TOTA_ITEM        number,
    DETA_IMPO_INTE_MMNN number,
    CF_IMPO_UNIT        number,
    SUM_CANT_ENTR       number,
    SUM_CANT_SALI       number,
    SUM_SALD_FINI       number,
    DETA_CANT           number,
    MONE_CODI           number
  );
  bdatos r_bdatos;

  type r_bsel_prod is record(
    exist_cero varchar2(1),
    buscar_por varchar2(1),
    s_producto_cf varchar2(100)
  );
  bsel_prod r_bsel_prod;

  type r_bdet_prod is record(
    PROD_CODI number,
    DEPO_CODI number,
    COBA_CODI_BARR varchar2(20),
    PROD_CODI_FABR varchar2(20),
    PROD_CODI_ALFA varchar2(20),
    PROD_DESC      varchar2(80),
    PROD_MEDI_CODI number,
    PROD_MARC_CODI number,
    MEDI_DESC_ABRE varchar2(20),
    MEDI_DESC      varchar2(30),
    PROD_PREC      number,
    PROD_MARC      varchar2(50),
    S_MENS_AUXI    varchar2(200)
  );
  bdet_prod r_bdet_prod;


  type r_bdepo_prod is record(
    PRDE_PROD_CODI number,
    PRDE_DEPO_CODI varchar2(10),
    DEPO_DESC      varchar2(100),
    SUCU_CODI      number,
    SUCU_DESC      varchar2(30),
    PRDE_CANT_REMI number,
    PRDE_CANT_PEDI number,
    PRDE_CANT_PEDI_SUCU number,
    PRDE_CANT_ACTU number,
    PRDE_EXIS_NETA number,
    PRDE_DEPO_INDI_VISI varchar2(1),
    S_EXIS_DEPO_FACT number,
    SUMA_EXIS_DEPO_FACT number
  );
  bdepo_prod r_bdepo_prod;


-----------------------------------------------
  procedure pp_validar_tipo_movi(timo_codi in number,
                                  timo_desc out varchar2,
                                  timo_desc_abre out varchar2,
                                  timo_afec_sald out varchar2,
                                  timo_dbcr out varchar2) is

  begin

    if timo_codi is not null then
       general_skn.pl_muestra_come_tipo_movi(timo_codi, timo_desc,timo_desc_abre, timo_afec_sald, timo_dbcr );
    else
      timo_desc      := null;
      timo_desc_abre := null;
    end if;

  end;

-----------------------------------------------
  procedure pp_validar_operacion(oper_codi in number,
                                  oper_desc out varchar2,
                                  oper_desc_abre out varchar2,
                                  oper_suma_rest out varchar2,
                                  oper_afec_cost_prom out varchar2) is

  begin

    if oper_codi is not null then
       general_skn.pl_muestra_come_stoc_oper(oper_codi,
                                 oper_desc,
                                 oper_desc_abre,
                                 oper_suma_rest,
                                 oper_afec_cost_prom );

    else
      oper_desc      := null;
      oper_desc_abre := null;
    end if;

  end pp_validar_operacion;

-----------------------------------------------
  procedure pp_validar_deposito_dest(depo_codi_dest in number,
                                      depo_desc_dest out varchar2,
                                      sucu_codi_dest out number,
                                      sucu_desc_dest out varchar2) is

  begin

    if depo_codi_dest is not null then
       general_skn.pl_muestra_come_depo(depo_codi_dest, sucu_codi_dest,depo_desc_dest, sucu_desc_dest );
    else
       depo_desc_dest := null;
       sucu_codi_dest := null;
       sucu_desc_dest := null;
    end if;

  end pp_validar_deposito_dest;
-----------------------------------------------
  procedure pp_validar_deposito_orig(depo_codi_orig in number,
                                depo_desc_orig out varchar2,
                                sucu_codi_orig out number,
                                sucu_desc_orig out varchar2
                                ) is

  begin

    if depo_codi_orig is not null then
       general_skn.pl_muestra_come_depo(depo_codi_orig, sucu_codi_orig,depo_desc_orig, sucu_desc_orig );
    else
       depo_desc_orig := null;
       sucu_codi_orig := null;
       sucu_desc_orig := null;
    end if;

  end pp_validar_deposito_orig;

-----------------------------------------------
  procedure pp_mostrar_producto(s_producto_cf   in number,
                                s_producto_desc out varchar2,
                                producto        out number,
                                s_prod_codi_alfa  out number) is
    v_ind_inactivo char(1);

  begin

    select prod_desc, prod_codi, nvl(prod_indi_inac, 'N'),prod_codi_alfa
      into s_producto_desc, producto, v_ind_inactivo, s_prod_codi_alfa
      from come_prod
      --prod_codi_alfa = s_producto_cf;
     where prod_codi = s_producto_cf;


    if v_ind_inactivo = 'S' then
      raise_application_error(-20010,'Atencion!!!!. El producto se encuentra inactivo');
    end if;

  Exception
    when no_data_found then
      s_producto_desc := null;
      producto        := null;
      raise_application_error(-20010, 'Producto inexistente!');
    when too_many_rows then
      raise_application_error(-20010, 'Codigo duplicado');
    when others then
      raise_application_error(-20010,
                              'Error al buscar producto! ' || sqlerrm);
  end pp_mostrar_producto;

-----------------------------------------------
  procedure pp_validar_producto(s_producto_cf in number,
                                producto      out number,
                                s_producto_desc out varchar2,
                                s_prod_codi_alfa out number) is

  begin

    if s_producto_cf is not null then
        --pp_validar_producto;
        --pl_validar_entrada;
        --null;
        pp_mostrar_producto(s_producto_cf,s_producto_desc,producto,s_prod_codi_alfa);
    else
       producto        := null;
       s_producto_desc := null;
    end if;

  end pp_validar_producto;
-----------------------------------------------
  procedure pp_cargar_cursor(v_where in varchar2 ) is
    v_sql varchar2(4000);
  begin

    v_sql:='select
              PROD_CODI_ALFA,
              PROD_DESC ,
              TIMO_DESC_ABRE ,
              OPER_DESC_ABRE ,
              MOVI_CODI      ,
              MOVI_NUME      ,
              MOVI_FECH_EMIS ,
              MOVI_DEPO_CODI_ORIG ,
              MOVI_SUCU_CODI_ORIG ,
              MOVI_DEPO_CODI_DEST ,
              MOVI_SUCU_CODI_DEST ,
              CANT_ENTR           ,
              CANT_SALI           ,
              TOTA_ITEM           ,
              TOTA_ITEM_CON_INTE  ,
              DETA_IMPO_INTE_MMNN ,
              DETA_CANT,
              MONE_CODI
            from v_movi_deta ' || v_where;

     if apex_collection.collection_exists(p_collection_name => parameter.collection_name) then
       apex_collection.delete_collection(p_collection_name => parameter.collection_name);
     end if;

     apex_collection.create_collection_from_query(p_collection_name => parameter.collection_name,
                                                  p_query           => v_sql);

  exception
    when others then
        raise_application_error(-20010,'Error al cargar la collection! '|| sqlerrm );
  end pp_cargar_cursor;
-----------------------------------------------
  procedure pp_cargar_bdatos(p_where in varchar2)is

    cursor c_bdatos is
      select
        c001 PROD_CODI_ALFA,
        c002 PROD_DESC ,
        c003 TIMO_DESC_ABRE ,
        c004 OPER_DESC_ABRE ,
        c005 MOVI_CODI      ,
        c006 MOVI_NUME      ,
        c007 MOVI_FECH_EMIS ,
        c008 MOVI_DEPO_CODI_ORIG ,
        c009 MOVI_SUCU_CODI_ORIG ,
        c010 MOVI_DEPO_CODI_DEST ,
        c011 MOVI_SUCU_CODI_DEST ,
        c012 CANT_ENTR           ,
        c013 CANT_SALI           ,
        c014 TOTA_ITEM           ,
        c015 TOTA_ITEM_CON_INTE  ,
        c016 DETA_IMPO_INTE_MMNN ,
        c017 DETA_CANT,
        c018 MONE_CODI
      from apex_collections
      where collection_name = parameter.collection_name;

      v_cf_tota_item number;
      v_cf_impo_unit number;
      v_sum_cant_entr number:=0;
      v_sum_cant_sali number:=0;
      v_sum_sald_fini number:=0;
      v_mone          number;
  begin

    --CLEAR COLLECTIONS
    pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => v('APP_SESSION'),
                                         i_taax_user => gen_user);
    --
    pp_cargar_cursor(p_where);

    for x in c_bdatos loop


      if bsel.indi_inte = 'S' then
         v_cf_tota_item := x.tota_item_con_inte;
      else
         v_cf_tota_item := x.tota_item;
      end if;

      if nvl(x.deta_cant,0) <> 0 then
        v_cf_impo_unit := v_cf_tota_item / x.deta_cant;
      end if;

       pack_mane_tabl_auxi.pp_add_members(i_taax_sess => v('APP_SESSION'),
                                           i_taax_user => gen_user,
                                           i_taax_c001 => x.PROD_CODI_ALFA,
                                            i_taax_c002 => x.PROD_DESC ,
                                            i_taax_c003 => x.TIMO_DESC_ABRE ,
                                            i_taax_c004 => x.OPER_DESC_ABRE ,
                                            i_taax_c005 => x.MOVI_CODI      ,
                                            i_taax_c006 => x.MOVI_NUME      ,
                                            i_taax_c007 => x.MOVI_FECH_EMIS ,
                                            i_taax_c008 => x.MOVI_DEPO_CODI_ORIG ,
                                            i_taax_c009 => x.MOVI_SUCU_CODI_ORIG ,
                                            i_taax_c010 => x.MOVI_DEPO_CODI_DEST ,
                                            i_taax_c011 => x.MOVI_SUCU_CODI_DEST ,
                                            i_taax_c012 => x.CANT_ENTR           ,
                                            i_taax_c013 => x.CANT_SALI           ,
                                            i_taax_c014 => x.TOTA_ITEM           ,
                                            i_taax_c015 => x.TOTA_ITEM_CON_INTE  ,
                                            i_taax_c016 => x.DETA_IMPO_INTE_MMNN ,
                                            i_taax_c017 => x.DETA_CANT,
                                            i_taax_c019 => v_cf_tota_item,
                                            i_taax_c020 => v_cf_impo_unit
                                           );
    v_sum_cant_entr := v_sum_cant_entr + x.CANT_ENTR;
    v_sum_cant_sali := v_sum_cant_sali + x.CANT_SALI;
    v_mone := x.mone_codi;

    end loop;

      bdatos.SUM_CANT_ENTR := v_sum_cant_entr;
      bdatos.SUM_CANT_SALI := v_sum_cant_sali;
      v_sum_sald_fini:=nvl(bsel.sum_sald_inic, 0) + nvl(bdatos.sum_cant_entr, 0) - nvl(bdatos.sum_cant_sali, 0);
      bdatos.SUM_SALD_FINI:=v_sum_sald_fini;
      bdatos.MONE_CODI:= v_mone;

  end pp_cargar_bdatos;

-----------------------------------------------
  procedure pp_send_values is
    v_cant_deci number;
  begin
    --SETITEM('P28_S_SALD_FINI', fp_devu_mask(nvl(bsel.mone_cant_deci,0),bsel.s_sald_fini));
    select mo.mone_cant_deci
     into v_cant_deci
    from come_mone mo
    where mo.mone_codi= bdatos.MONE_CODI;


    SETITEM('P56_SUM_SALD_INIC', fp_devu_mask(nvl(v_cant_deci,0),bsel.sum_sald_inic));
    SETITEM('P56_SUM_CANT_ENTR', fp_devu_mask(nvl(v_cant_deci,0),bdatos.SUM_CANT_ENTR));
    SETITEM('P56_SUM_CANT_SALI', fp_devu_mask(nvl(v_cant_deci,0),bdatos.SUM_CANT_SALI));
    SETITEM('P56_SUM_SALD_FINI', fp_devu_mask(nvl(v_cant_deci,0),bdatos.SUM_SALD_FINI));
    SETITEM('P56_MONE_CANT_DECI', v_cant_deci);

  end pp_send_values;
-----------------------------------------------
  procedure pp_cargar_variables(producto in number,
                                  s_fech_inic in varchar2,
                                  s_fech_fini in varchar2,
                                  depo_codi_orig in number,
                                  depo_codi_dest in number,
                                  oper_codi in number,
                                  timo_codi in number,
                                  s_movi_nume in number) is

  begin

    bsel.producto:= producto;
    bsel.s_fech_inic:= s_fech_inic;
    bsel.s_fech_fini:= s_fech_fini;
    bsel.depo_codi_orig:= depo_codi_orig;
    bsel.depo_codi_dest:= depo_codi_dest;
    bsel.oper_codi:= oper_codi;
    bsel.timo_codi:= timo_codi;
    bsel.s_movi_nume:= s_movi_nume;

    bsel.fech_inic:= s_fech_inic;

  end pp_cargar_variables;
-----------------------------------------------
  procedure pp_ejecutar_consulta(producto in number,
                                  s_fech_inic in varchar2,
                                  s_fech_fini in varchar2,
                                  depo_codi_orig in number,
                                  depo_codi_dest in number,
                                  oper_codi in number,
                                  timo_codi in number,
                                  s_movi_nume in number) is

    v_where varchar2(2000) := null;
  begin

    pp_cargar_variables(producto,s_fech_inic,s_fech_fini,depo_codi_orig,
                        depo_codi_dest,oper_codi,timo_codi,s_movi_nume);


    --
    v_where := 'where 1 = 1  ';

    if bsel.producto is not null then
      v_where := v_where || 'and prod_codi =' || to_char(bsel.producto) || '  ';
    end if;

    if bsel.s_fech_inic is not null then
      v_where := v_where || 'and movi_fech_emis >= ''' ||
                 to_char(to_date(bsel.s_fech_inic, 'dd-mm-yyyy'),
                         'dd/mm/yyyy') || '''';
    end if;

    if bsel.s_fech_fini is not null then
      v_where := v_where || 'and movi_fech_emis <= ''' ||
                 to_char(to_date(bsel.s_fech_fini, 'dd-mm-yyyy'),
                         'dd/mm/yyyy') || '''';
    end if;

    if bsel.depo_codi_orig is not null then
      v_where := v_where || 'and movi_depo_codi_orig =' ||
                 to_char(bsel.depo_codi_orig) || '  ';
    end if;

    if bsel.depo_codi_dest is not null then
      v_where := v_where || 'and movi_depo_codi_dest =' ||
                 to_char(bsel.depo_codi_dest) || '  ';
    end if;

    if bsel.oper_codi is not null then
      v_where := v_where || 'and movi_oper_codi =' || to_char(bsel.oper_codi) || '  ';
    end if;

    if bsel.timo_codi is not null then
      v_where := v_where || 'and movi_timo_codi =' || to_char(bsel.timo_codi) || '  ';
    end if;

    if bsel.s_movi_nume is not null then
      v_where := v_where || 'and movi_nume =' || to_char(bsel.s_movi_nume) || '  ';
    end if;

    --v_where:= v_where ||' and movi_nume = 10020012488';

    --pp_cargar_cursor(v_where);
    --pp_cargar_bdatos(v_where);
    /*
    go_block('bdatos');
    set_block_property('bdatos', default_where, v_where);
    clear_block(no_validate);
    execute_query;
    */

    begin

      select nvl(sum(m.cant_entr - m.cant_sali), 0)
        into bsel.sum_sald_inic
        from v_movi_deta m
       where (m.movi_fech_emis <nvl(to_date(bsel.fech_inic, 'dd-mm-yyyy'), to_date('01-01-0001', 'dd-mm-yyyy')))
         and (m.prod_codi = bsel.producto or bsel.producto is null)
         and (m.movi_depo_codi_orig = bsel.depo_codi_orig or bsel.depo_codi_orig is null)
         and (m.movi_depo_codi_dest = bsel.depo_codi_dest or bsel.depo_codi_dest is null)
         and (m.movi_oper_codi = bsel.oper_codi or bsel.oper_codi is null)
         and (m.movi_timo_codi = bsel.timo_codi or bsel.timo_codi is null)
         and (m.movi_nume = bsel.s_movi_nume or bsel.s_movi_nume is null);

    exception
      when others then
        raise_application_error(-20010,'Error al ejecutar consulta! ' || sqlerrm);
    end;


    pp_cargar_bdatos(v_where);

    pp_send_values;


  end pp_ejecutar_consulta;

-----------------------------------------------
--=============================================================
-----------------------------------------------
  PROCEDURE pp_ejecuta_ddl(V_DDL IN CHAR) IS
    --OJO: dejar V_DDL como CHAR porque estaba como varchar2 y al recibir
    --     un string > 1000 letras da error en tiempo de ejecucion
    V_CURSOR    INTEGER;
    V_RESULTADO INTEGER;

  BEGIN
    V_CURSOR := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(V_CURSOR, V_DDL, 2); -- la constante (2) significa PL/SQL V.7
    V_RESULTADO := DBMS_SQL.EXECUTE(V_CURSOR);
    DBMS_SQL.CLOSE_CURSOR(V_CURSOR);

  END pp_ejecuta_ddl;

-----------------------------------------------
  procedure pp_recrea_tabla is
    v_user   varchar2(20) := gen_user;
    v_count  number;
    v_drop   varchar2(2000);
    v_create varchar2(2000);
    v_where  varchar2(200);

  begin
    select count(*)
      into v_count
      from user_views
     where view_name = upper('v_temp_prod_depo_fact');

    if v_count = 1 then
      v_drop := 'drop view ' || v_user || '.v_temp_prod_depo_fact';
      pp_ejecuta_ddl(v_drop);
    end if;

    if bsel_prod.exist_cero = 'N' then
      v_where := ' and nvl(prde_cant_actu, 0) > 0 ';
    end if;

    v_create := 'create or replace view ' || v_user ||
                '.v_temp_prod_depo_fact as
      select p.prod_codi,
             cb.coba_codi_barr,
             p.prod_codi_fabr,
             p.prod_codi_alfa,
             cb.coba_desc prod_desc,
             cb.coba_medi_codi prod_medi_codi,
             p.prod_clas1,
             p.prod_clas2
        from come_prod p,
             come_prod_coba_deta cb,
             (select distinct prod_codi
                from v_come_depo_sucu_prod where 1=1' || v_where || ') x
       where p.prod_codi = cb.coba_prod_codi(+)
         and p.prod_codi = x.prod_codi';

    --where depo_indi_visi = ' || chr(39) || 'S' || chr(39)
    pp_ejecuta_ddl(v_create);

    if upper(v_user) <> upper('skn') then
      -- se comenta esta linea porque para vistas da un error de privilegios
      --pp_ejecuta_ddl('grant select on ' || v_user || '.v_temp_prod_depo_fact to skn');
      null;
    end if;

  exception
    when others then
      raise_application_error(-20010, 'Error al recrear la tabla! '|| sqlerrm);

  end pp_recrea_tabla;

-----------------------------------------------
  procedure pp_cargar_bsel_prod(buscar_por in varchar2,
                                s_producto_cf in varchar2) is

  begin

    bsel_prod.buscar_por:= buscar_por;
    bsel_prod.s_producto_cf:= s_producto_cf;

  end pp_cargar_bsel_prod;

-----------------------------------------------
  PROCEDURE pp_filtrar(buscar_por in varchar2,
                       s_producto_cf in varchar2,
                       codi_inic out number)IS

    v_where varchar2(2000);
    v_list_codi number;

    --CURSOR_DINAMICO
    TYPE CURSOR_DINAMICO IS REF CURSOR;
    c_cursor CURSOR_DINAMICO;
    fila    v_temp_prod_depo_fact%ROWTYPE;
    v_query VARCHAR2(4000);
    v_prod_prec number:= null;
    v_count number:=0;
    v_codi_inic number;

  BEGIN
    if s_producto_cf is null then
      raise_application_error(-20010,'El campo producto no puede estar vacio!.');
    end if;

    pp_cargar_bsel_prod(buscar_por,s_producto_cf);

      pp_recrea_tabla;

      if bsel_prod.buscar_por = 'A' then
        v_where := 'lower(prod_codi_alfa) like '||chr(39)||'%'||lower(bsel_prod.s_producto_cf)||'%'||chr(39);
      elsif bsel_prod.buscar_por = 'D' then
        v_where := 'lower(prod_desc) like '||chr(39)||'%'||lower(bsel_prod.s_producto_cf)||'%'||chr(39);
      elsif bsel_prod.buscar_por = 'C' then
        v_where := 'lower(prod_codi_fabr) like '||chr(39)||'%'||lower(bsel_prod.s_producto_cf)||'%'||chr(39);
      elsif bsel_prod.buscar_por = 'B' then
        v_where := 'lower(coba_codi_barr) like '||chr(39)||'%'||lower(bsel_prod.s_producto_cf)||'%'||chr(39);
      elsif bsel_prod.buscar_por = 'T' then
        v_where := '(lower(prod_codi_alfa) like '||chr(39)||'%'||lower(bsel_prod.s_producto_cf)||'%'||chr(39)||
                   ' or lower(prod_desc) like '||chr(39)||'%'||lower(bsel_prod.s_producto_cf)||'%'||chr(39)||
                   ' or lower(coba_codi_barr) like '||chr(39)||'%'||lower(bsel_prod.s_producto_cf)||'%'||chr(39)||
                   ' or lower(prod_codi_fabr) like '||chr(39)||'%'||lower(bsel_prod.s_producto_cf)||'%'||chr(39)||')';
      end if;

      /*
      set_block_property('bdet_prod', default_where, :parameter.p_where);
      execute_query;
      first_record;
      */
      APEX_COLLECTION.TRUNCATE_COLLECTION(parameter.collection_name1);

      v_query := 'select * from v_temp_prod_depo_fact where ' || v_where;

      OPEN c_cursor FOR v_query; -- Se abre el cursor dinamico
      LOOP
        FETCH c_cursor
          INTO fila;
        EXIT WHEN c_cursor%NOTFOUND;

        --DBMS_OUTPUT.PUT_LINE(fila.prod_desc);
        v_count:=v_count+1;
        if v_count = 1 then
          v_codi_inic:= fila.PROD_CODI;
        end if;

        bdet_prod.PROD_CODI:=fila.PROD_CODI;
        bdet_prod.COBA_CODI_BARR:=fila.COBA_CODI_BARR;
        bdet_prod.PROD_CODI_FABR:=fila.PROD_CODI_FABR;
        bdet_prod.PROD_CODI_ALFA:=fila.PROD_CODI_ALFA;
        bdet_prod.PROD_DESC:=fila.PROD_DESC;
        bdet_prod.PROD_MEDI_CODI:=fila.PROD_MEDI_CODI;

        if bdet_prod.prod_medi_codi is not null then
          begin
            select medi_desc_abre
              into bdet_prod.medi_desc_abre
              from come_unid_medi
             where medi_codi = bdet_prod.prod_medi_codi;
          exception
            when no_data_found then
              bdet_prod.medi_desc_abre := null;
          end;
        end if;

        if bdet_prod.prod_codi is not null then
          begin
            select marc_desc
              into bdet_prod.prod_marc
              from come_marc, come_prod
             where prod_codi = bdet_prod.prod_codi
             and prod_marc_codi = marc_codi;

          exception
            when no_data_found then
              bdet_prod.prod_marc := null;
          end;
        end if;

        apex_collection.add_member(p_collection_name => parameter.collection_name1,
                                     p_c001            => bdet_prod.PROD_CODI,
                                     p_c002            => bdet_prod.COBA_CODI_BARR,
                                     p_c003            => bdet_prod.PROD_CODI_FABR,
                                     p_c004            => bdet_prod.PROD_CODI_ALFA,
                                     p_c005            => bdet_prod.PROD_DESC,
                                     p_c006            => bdet_prod.PROD_MEDI_CODI,
                                     p_c007            => bdet_prod.medi_desc_abre,
                                     p_c008            => bdet_prod.prod_marc,
                                     p_c009            => v_prod_prec
                                     );


      END LOOP;
      CLOSE c_cursor;

      codi_inic := v_codi_inic;

  END pp_filtrar;

-----------------------------------------------
  FUNCTION fp_exis_depo_fact RETURN number IS
    v_return number;
  BEGIN
    if bdepo_prod.prde_depo_codi = bsel.depo_codi_orig then
      v_return := bdepo_prod.prde_exis_neta;
    else
      v_return := 0;
    end if;

    return v_return;
  END fp_exis_depo_fact;

-----------------------------------------------
  procedure pp_cargar_bdepo_prod(i_prod_codi in number) is

    cursor c_depo_prod( prod_codi in number) is
      select
         PRDE_PROD_CODI,
          PRDE_DEPO_CODI,
          PRDE_CANT_REMI,
          PRDE_CANT_PEDI,
          PRDE_CANT_PEDI_SUCU,
          PRDE_CANT_ACTU
      from come_prod_depo
      WHERE PRDE_CANT_ACTU > 0
      and prde_prod_codi = prod_codi;

    v_suma_exis_depo_fact number:=0;

  begin

    APEX_COLLECTION.TRUNCATE_COLLECTION(parameter.collection_name2);

    for x in c_depo_prod(i_prod_codi) loop

      bdepo_prod.prde_prod_codi := x.prde_prod_codi;
      bdepo_prod.prde_depo_codi := x.prde_depo_codi;
      bdepo_prod.prde_cant_remi := x.prde_cant_remi;
      bdepo_prod.prde_cant_pedi := x.prde_cant_pedi;
      bdepo_prod.prde_cant_pedi_sucu := x.prde_cant_pedi_sucu;
      bdepo_prod.prde_cant_actu := x.prde_cant_actu;

      general_skn.pl_muestra_come_depo(bdepo_prod.prde_depo_codi, bdepo_prod.sucu_codi,
                            bdepo_prod.depo_desc, bdepo_prod.sucu_desc);

       bdepo_prod.prde_exis_neta:=nvl(bdepo_prod.prde_cant_actu,0)
                       - nvl(bdepo_prod.PRDE_CANT_PEDI,0)
                       - nvl(bdepo_prod.PRDE_CANT_REMI,0)
                       -nvl(bdepo_prod.PRDE_CANT_pedi_sucu,0);

        bdepo_prod.s_exis_depo_fact:= fp_exis_depo_fact;

        v_suma_exis_depo_fact:= v_suma_exis_depo_fact + bdepo_prod.s_exis_depo_fact;
        bdepo_prod.suma_exis_depo_fact:=v_suma_exis_depo_fact;

        apex_collection.add_member(p_collection_name => parameter.collection_name2,
                                     p_c001            => bdepo_prod.prde_prod_codi,
                                      p_c002            => bdepo_prod.prde_depo_codi,
                                      p_c003            => bdepo_prod.prde_cant_remi,
                                      p_c004            => bdepo_prod.prde_cant_pedi,
                                      p_c005            => bdepo_prod.prde_cant_pedi_sucu,
                                      p_c006            => bdepo_prod.prde_cant_actu,
                                      p_c007            => bdepo_prod.sucu_codi,
                                      p_c008            => bdepo_prod.depo_desc,
                                      p_c009            => bdepo_prod.sucu_desc,
                                      p_c010            => bdepo_prod.prde_exis_neta,
                                      p_c011            => bdepo_prod.s_exis_depo_fact,
                                      p_c012            => bdepo_prod.suma_exis_depo_fact
                                     );


    end loop;

  end pp_cargar_bdepo_prod;

-----------------------------------------------
  procedure pp_abrir_formulario(o_open_forms out varchar2) is
    v_clave_form number;
    v_count      number;
  begin
    --verificar si tiene habiliado para utilizar esta pantalla...
    select count(*)
      into v_count
      from (select lpad(to_char(modu_codi), 2, '0') modu_codi,
                   lpad(to_char(clas_codi), 2, '0') clas_codi,
                   substr(pant_nomb, 6, 3) pant_nomb,
                   pant_desc pant_desc
              from segu_user,
                   segu_perf,
                   segu_pant,
                   segu_pant_perf,
                   segu_user_perf,
                   segu_modu,
                   segu_clas_pant
             where pape_perf_codi = perf_codi
               and pant_codi = pape_pant_codi
               and uspe_perf_codi = perf_codi
               and user_codi = uspe_user_codi
               and modu_codi = pant_modu
               and clas_codi = pant_clas
               and user_login = gen_user
               and rtrim(ltrim(pant_nomb)) = rtrim(ltrim(parameter.p_formulario))
            union
            select lpad(to_char(modu_codi), 2, '0'),
                   lpad(to_char(clas_codi), 2, '0'),
                   substr(pant_nomb, 6, 3),
                   pant_desc
              from segu_user,
                   segu_pant,
                   segu_user_pant,
                   segu_modu,
                   segu_clas_pant
             where uspa_user_codi = user_codi
               and uspa_pant_codi = pant_codi
               and modu_codi = pant_modu
               and clas_codi = pant_clas
               and user_login = gen_user
               and rtrim(ltrim(pant_nomb)) = rtrim(ltrim(parameter.p_formulario)));

    if v_count = 0 then
--      raise_application_error(-20010,'No se puede acceder al formulario no posee el permiso correspondiente!');
      o_open_forms := 'false';
    else
      o_open_forms := 'true';
      --pp_abrir_form(p_formulario);
    end if;
  end pp_abrir_formulario;

-----------------------------------------------
  procedure pp_imprimir_reportes (i_prod_codi_alfa varchar2,
                                  i_prod_desc varchar2,
                                  i_fech_inic varchar2,
                                  i_fech_fini varchar2,
                                  i_depo_codi_orig varchar2,
                                  i_depo_desc_orig varchar2,
                                  i_depo_codi_dest varchar2,
                                  i_depo_desc_dest varchar2,
                                  i_timo_codi varchar2,
                                  i_timo_desc varchar2,
                                  i_oper_codi varchar2,
                                  i_oper_desc varchar2,
                                  i_movi_nume varchar2
                                                      ) is

  v_report       VARCHAR2(50);
  v_parametros   CLOB;
  v_contenedores CLOB;

  p_where varchar2(500);

  begin

    V_CONTENEDORES := 'p_session:p_user:p_prod_codi_alfa:p_prod_desc:p_fech_inic:p_fech_fini:p_depo_codi_orig:p_depo_desc_orig:p_depo_codi_dest:p_depo_desc_dest:p_timo_codi:p_timo_desc:p_oper_codi:p_oper_desc:p_movi_nume';

    V_PARAMETROS   :=   v('APP_SESSION') || ':' ||
                        gen_user         || ':' ||
                        i_prod_codi_alfa || ':' ||
                        i_prod_desc || ':' ||
                        i_fech_inic || ':' ||
                        i_fech_fini || ':' ||
                        i_depo_codi_orig || ':' ||
                        i_depo_desc_orig || ':' ||
                        i_depo_codi_dest || ':' ||
                        i_depo_desc_dest || ':' ||
                        i_timo_codi || ':' ||
                        i_timo_desc || ':' ||
                        i_oper_codi || ':' ||
                        i_oper_desc || ':' ||
                        i_movi_nume ;

    v_report       :='I030003MB';

    DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = gen_user;

    INSERT INTO COME_PARAMETROS_REPORT
      (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
    VALUES
      (V_PARAMETROS,gen_user, v_report, 'pdf', V_CONTENEDORES);

    commit;
  end pp_imprimir_reportes;

-----------------------------------------------






end I030003;
