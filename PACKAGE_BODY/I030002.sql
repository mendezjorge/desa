
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I030002" is

  -- Private type declarations
  type r_bsel is record(
     prod_codi number,
     fech_desd date,
     fech_hast date,
     movi_sucu_codi_orig number,
     indi_iva_incl varchar2(30),
     mone_codi     number
  );
  bsel r_bsel;

  type r_bsel_prod is record(
    exist_cero varchar2(1),
    buscar_por varchar2(1),
    s_producto_cf varchar2(100)
  );
  bsel_prod r_bsel_prod;

  type r_parameter is record(
   p_codi_oper_com number := to_number(general_skn.fl_busca_parametro ('p_codi_oper_com')),
   p_cant_deci_mmnn number:= to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmnn')),
   collection_name1 varchar2(30):='BDET_PROD',
   collection_name2 varchar2(30):='BDEPO_PROD'
  );
  parameter r_parameter;

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
  procedure pp_mostrar_sucu(p_sucu_codi in number,
                            p_sucu_desc out varchar2) is

  begin

    select sucu_desc
      into p_sucu_desc
      from come_sucu
     where sucu_codi = p_sucu_codi;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Sucursal inexistente!');
    when others then
      raise_application_error(-20010, 'Error al buscar sucursal!' || sqlerrm);

  end pp_mostrar_sucu;

-----------------------------------------------
  procedure pp_validar_producto(i_prod_codi in number,
                                o_prod_desc out varchar2,
                                o_cod_alfa  out number) is

  Begin

      select prod_desc, prod_codi_alfa
      into o_prod_desc, o_cod_alfa
      from come_prod
      where prod_codi = i_prod_codi;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Producto inexistente!');
    when others then
      raise_application_error(-20010, 'Error al buscar producto!' || sqlerrm);
  end;

-----------------------------------------------
  procedure pp_asig_bsel(i_prod_codi in number,
                         i_fech_desd in date,
                         i_fech_hast in date,
                         i_movi_sucu_codi_orig in number,
                         i_indi_iva_incl       in varchar2,
                         i_mone_codi           in number
                        ) is

  begin

    if i_prod_codi is null then
      raise_application_error(-20010, 'Debe de seleccionar un producto!');
    end if;

    bsel.prod_codi := i_prod_codi;
    bsel.fech_desd := i_fech_desd;
    bsel.fech_hast := i_fech_hast;
    bsel.movi_sucu_codi_orig := i_movi_sucu_codi_orig;
    bsel.indi_iva_incl := i_indi_iva_incl;
    bsel.mone_codi := i_mone_codi;

  end pp_asig_bsel;

-----------------------------------------------
  procedure pp_ejecutar_consulta(i_prod_codi in number,
                                 i_fech_desd in date,
                                 i_fech_hast in date,
                                 i_movi_sucu_codi_orig in number,
                                 i_indi_iva_incl       in varchar2,
                                 i_mone_codi           in number,
                                 o_cant_deci out number) is

    cursor cur_bdatos is
         select oper_desc_abre,
         prod_codi,
         movi_nume,
         movi_codi,
         mone_codi,
         movi_fech_emis,
         clpr_codi_alte,
         rtrim(ltrim(TRANSLATE(clpr_desc, ',/-.', ' ')))clpr_desc,
         mone_desc_abre,
         movi_sucu_codi_orig,
         sucu_desc,
         deta_cant,
         impo_unit_bruto,
         impo_unit_sin_iva,
         deta_impo_inte_mmnn_unit,
         impo_unit_bruto_mone,
         impo_unit_sin_iva_mone,
         deta_impo_inte_mone_unit,
         deta_impo_mone_deto_nc_unit,
         impo_unit_neto,
         impo_unit_neto_sin_iva,
         deta_impo_mmnn_deto_nc_unit,
         impo_unit_neto_mone,
         impo_unit_neto_mone_sin_iva
    from v_movi_deta
   where prod_codi = bsel.prod_codi
     and movi_oper_codi = parameter.p_codi_oper_com
     and (bsel.fech_Desd is null or movi_fech_emis >= bsel.fech_desd)
     and (bsel.fech_hast is null or movi_fech_emis <= bsel.fech_hast)
     and (bsel.movi_sucu_codi_orig is null or movi_sucu_codi_orig = bsel.movi_sucu_codi_orig)
     and (bsel.mone_codi is null or mone_codi = bsel.mone_codi)
   order by movi_fech_emis desc;

  S_IMPO_UNIT_BRUTO_MONE number;
  S_IMPO_UNIT_BRUTO number;
  S_IMPO_UNIT_NETO_MONE number;
  S_IMPO_UNIT_NETO number;

  begin
    /*go_block('bdatos');
    clear_block(no_validate);
    execute_query;
    first_record;*/
    --null;

    /*pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => v('APP_SESSION'),
                                       i_taax_user => gen_user--v('APP_USER')
                                       );*/

/*    raise_application_error(-20010, 'i_prod_codi: '|| i_prod_codi||';'||
                                    'i_fech_desd: '|| i_fech_desd||';'||
                                    'i_fech_hast: '|| i_fech_hast||';'||
                                    'i_movi_sucu_codi_orig: '|| i_movi_sucu_codi_orig||';'||
                                    'i_indi_iva_incl: '|| i_indi_iva_incl
                                    );*/

    pp_asig_bsel(i_prod_codi,i_fech_desd,i_fech_hast,
                 i_movi_sucu_codi_orig,i_indi_iva_incl, i_mone_codi);

    FOR bdet IN cur_bdatos LOOP

      if bdet.mone_codi = 1 then
        if bsel.indi_iva_incl = 'S' then
          S_IMPO_UNIT_BRUTO_MONE :=  bdet.IMPO_UNIT_BRUTO_MONE;
          S_IMPO_UNIT_BRUTO :=  bdet.IMPO_UNIT_BRUTO;
          S_IMPO_UNIT_NETO_MONE := bdet.IMPO_UNIT_NETO_MONE;
          S_IMPO_UNIT_NETO := bdet.IMPO_UNIT_NETO;

          --pp_formato('bdatos.S_IMPO_UNIT_BRUTO_MONE'  , :parameter.p_cant_deci_mmnn);
          --pp_formato('bdatos.S_IMPO_UNIT_NETO_MONE'   , :parameter.p_cant_deci_mmnn);

        else
          S_IMPO_UNIT_BRUTO_MONE :=  bdet.IMPO_UNIT_SIN_IVA;
          S_IMPO_UNIT_BRUTO      :=  bdet.IMPO_UNIT_SIN_IVA;
          S_IMPO_UNIT_NETO_MONE  := bdet.IMPO_UNIT_NETO_MONE_SIN_IVA;
          S_IMPO_UNIT_NETO       := bdet.IMPO_UNIT_NETO_SIN_IVA;

          --pp_formato('bdatos.S_IMPO_UNIT_BRUTO_MONE'  , :parameter.p_cant_deci_mmnn);
          --pp_formato('bdatos.S_IMPO_UNIT_NETO_MONE'   , :parameter.p_cant_deci_mmnn);
        end if;
        --pp_formato('bdatos.DETA_IMPO_INTE_MONE_UNIT'   , :parameter.p_cant_deci_mmnn);
        --pp_formato('bdatos.DETA_IMPO_MONE_DETO_NC_UNIT'   , :parameter.p_cant_deci_mmnn);
      else
        if bsel.indi_iva_incl = 'S' then
          S_IMPO_UNIT_BRUTO_MONE :=  bdet.IMPO_UNIT_BRUTO_MONE;
          S_IMPO_UNIT_BRUTO :=  bdet.IMPO_UNIT_BRUTO;
          S_IMPO_UNIT_NETO_MONE := bdet.IMPO_UNIT_NETO_MONE;
          S_IMPO_UNIT_NETO := bdet.IMPO_UNIT_NETO;
         --pp_formato('bdatos.S_IMPO_UNIT_BRUTO_MONE'        , 2);
         --pp_formato('bdatos.DETA_IMPO_INTE_MONE_UNIT'    , 2);
         --pp_formato('bdatos.DETA_IMPO_MONE_DETO_NC_UNIT' , 2);
         --pp_formato('bdatos.S_IMPO_UNIT_NETO_MONE'         , 2);
        else
          S_IMPO_UNIT_BRUTO_MONE :=  bdet.IMPO_UNIT_SIN_IVA;
          S_IMPO_UNIT_BRUTO :=  bdet.IMPO_UNIT_SIN_IVA;
          S_IMPO_UNIT_NETO_MONE := bdet.IMPO_UNIT_NETO_MONE_SIN_IVA;
          S_IMPO_UNIT_NETO := bdet.IMPO_UNIT_NETO_SIN_IVA;
         --pp_formato('bdatos.S_IMPO_UNIT_BRUTO_MONE'        , 2);
         --pp_formato('bdatos.DETA_IMPO_INTE_MONE_UNIT'    , 2);
         --pp_formato('bdatos.DETA_IMPO_MONE_DETO_NC_UNIT' , 2);
         --|pp_formato('bdatos.S_IMPO_UNIT_NETO_MONE'         , 2);
        end if;

      end if;



      pack_mane_tabl_auxi.pp_add_members(i_taax_sess            => v('APP_SESSION'),
                                          i_taax_user            => gen_user,
                                          i_taax_c001            =>   bdet.oper_desc_abre,
                                          i_taax_c002            =>   bdet.prod_codi,
                                          i_taax_c003            =>   bdet.movi_nume,
                                          i_taax_c004            =>   bdet.movi_codi,
                                          i_taax_c005            =>   bdet.mone_codi,
                                          i_taax_c006            =>   bdet.movi_fech_emis,
                                          i_taax_c007            =>   bdet.clpr_codi_alte,
                                          i_taax_c008            =>   bdet.clpr_desc,
                                          i_taax_c009            =>   bdet.mone_desc_abre,
                                          i_taax_c010            =>   bdet.movi_sucu_codi_orig,
                                          i_taax_c011            =>   bdet.sucu_desc,
                                          i_taax_c012            =>   bdet.deta_cant,
                                          i_taax_c013            =>   bdet.impo_unit_bruto,
                                          i_taax_c014            =>   bdet.impo_unit_sin_iva,
                                          i_taax_c015            =>   bdet.deta_impo_inte_mmnn_unit,
                                          i_taax_c016            =>   bdet.impo_unit_bruto_mone,
                                          i_taax_c017            =>   bdet.impo_unit_sin_iva_mone,
                                          i_taax_c018            =>   bdet.deta_impo_inte_mone_unit,
                                          i_taax_c019            =>   bdet.deta_impo_mone_deto_nc_unit,
                                          i_taax_c020            =>   bdet.impo_unit_neto,
                                          i_taax_c021            =>   bdet.impo_unit_neto_sin_iva,
                                          i_taax_c022            =>   bdet.deta_impo_mmnn_deto_nc_unit,
                                          i_taax_c023            =>   bdet.impo_unit_neto_mone,
                                          i_taax_c024            =>   bdet.impo_unit_neto_mone_sin_iva,
                                          i_taax_c025            =>   S_IMPO_UNIT_BRUTO_MONE,
                                          i_taax_c026            =>   S_IMPO_UNIT_BRUTO,
                                          i_taax_c027            =>   S_IMPO_UNIT_NETO_MONE,
                                          i_taax_c028            =>   S_IMPO_UNIT_NETO
                                          );



    end loop;


    o_cant_deci:= parameter.p_cant_deci_mmnn;

  end pp_ejecutar_consulta;

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
  procedure pp_cargar_bsel_prod(buscar_por in varchar2,
                                s_producto_cf in varchar2) is

  begin

    bsel_prod.buscar_por:= buscar_por;
    bsel_prod.s_producto_cf:= s_producto_cf;

  end pp_cargar_bsel_prod;

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
    /*if s_producto_cf is null then
      raise_application_error(-20010,'El campo producto no puede estar vacio!.');
    end if;*/

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
    /*if bdepo_prod.prde_depo_codi = bsel.depo_codi_orig then
      v_return := bdepo_prod.prde_exis_neta;
    else
      v_return := 0;
    end if;*/
    v_return := 0;

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
  procedure pp_imprimir_reportes (i_prod_codi in number,
                                  i_sucu_codi in number,
                                  i_fech_inic in varchar2,
                                  i_fech_fini in varchar2,
                                  i_prod_desc in varchar2,
                                  i_sucu_desc in varchar2,
                                  i_mone_codi in number
                                  ) is

  v_report       VARCHAR2(50);
  v_parametros   CLOB;
  v_contenedores CLOB;

  p_cuen_indi_caja_banc_desc varchar2(50);
  p_where varchar2(500);

  v_sald_inic number;
  v_prod_desc varchar2(500);


  begin

    if i_prod_codi is null then
      raise_application_error(-20010, 'Debe de seleccionar primero un producto!');
    end if;

    v_prod_desc := rtrim(ltrim(TRANSLATE(i_prod_desc, ',/-.', ' ')));
    --raise_application_error(-20010, 'v_prod_desc: '||v_prod_desc);

    V_CONTENEDORES := 'p_user:p_session:p_prod_codi:p_sucu_codi:p_fech_inic:p_fech_fini:p_prod_desc:p_sucu_desc:p_mone_codi';


    V_PARAMETROS   :=   gen_user         || ':' ||
                        v('APP_SESSION') || ':' ||
                        i_prod_codi      || ':' ||
                        i_sucu_codi      || ':' ||
                        i_fech_inic      || ':' ||
                        i_fech_fini      || ':' ||
                        v_prod_desc      || ':' ||
                        i_sucu_desc      || ':' ||
                        nvl(i_mone_codi, 0)
                        ;

    v_report       :='I030002';

    DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = gen_user;

    INSERT INTO COME_PARAMETROS_REPORT
      (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
    VALUES
      (V_PARAMETROS, v('APP_USER'), v_report, 'pdf', V_CONTENEDORES);

    commit;
  end pp_imprimir_reportes;

-----------------------------------------------


end I030002;
