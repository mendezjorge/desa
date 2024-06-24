
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I040067" is

  type r_parameter is record(
    p_where             varchar2(500),
    p_where_inic_fini   varchar2(500),
    p_report            varchar2(20),
    p_titulo            varchar2(50) := ' - Resumen Mensual de Operaciones',
    p_app_session       number,
    p_clas_prod_term    number := to_number(ltrim(rtrim(general_skn.fl_busca_parametro(upper('p_clas_prod_term'))))),
    p_clas_prod_en_proc number := to_number(ltrim(rtrim(general_skn.fl_busca_parametro(upper('p_clas_prod_en_proc'))))));

  parameter r_parameter;

  procedure pp_mostrar_peri(i_peri_codi in number,
                            o_peri_desc out varchar2) is

  begin
    select to_char(peri_fech_inic, 'dd-mm-yyyy') || '   -   ' ||
           to_char(peri_fech_fini, 'dd-mm-yyyy') peri_desc
      into o_peri_desc
      from come_peri
     where peri_codi = i_peri_codi;

  exception
    when no_data_found then
      raise_application_error(-20001, 'Periodo Inexistente!!!');
  end pp_mostrar_peri;

  procedure pp_mostrar_producto(i_codi_alfa in varchar2,
                                o_codi      out number,
                                o_desc      out varchar2) is

  begin
    select prod_codi, prod_desc
      into o_codi, o_desc
      from come_prod
     where prod_codi_alfa = i_codi_alfa;

  exception
    when no_data_found then
      raise_application_error(-20002, 'Producto Inexistente!!!');
  end pp_mostrar_producto;

  procedure pp_mostrar_lote(i_codi      in number,
                            i_prod_codi in number default null,
                            o_desc      out varchar2) is
    v_prod_codi number;
  begin
    select lote_desc, lote_prod_codi
      into o_desc, v_prod_codi
      from come_lote, come_prod
     where lote_prod_Codi = prod_codi
       and lote_codi = i_codi;

    if i_prod_codi is not null then
      if v_prod_codi <> i_prod_codi then
        raise_application_error(-20003,
                                'El lote no pertenece al producto!');
      end if;
    end if;

  exception
    when no_data_found then
      raise_application_error(-20004, 'Lote Inexistente!!!');
  end pp_mostrar_lote;

  procedure pp_mostrar_clco(i_codi in number, o_desc out varchar2) is

  begin
    select clco_desc
      into o_desc
      from come_prod_clas_conc
     where clco_codi = i_codi;

  exception
    when no_data_found then
      raise_application_error(-20005,
                              'clasificacion Contable inexistente!');
    when too_many_rows then
      raise_application_error(-20006, 'Codigo duplicado');
    when others then
      raise_application_error(-20007, sqlcode || sqlerrm);
  end pp_mostrar_clco;

  procedure pp_mostrar_familia(i_codi in number, o_desc out varchar2) is

  begin
    select clas1_desc
      into o_desc
      from come_prod_clas_1
     where clas1_codi = i_codi;

  exception
    when no_data_found then
      raise_application_error(-20008, 'Producto Inexistente!!!');
  end pp_mostrar_familia;

  procedure pp_mostrar_grupo(i_codi in number, o_desc out varchar2) is

  begin
    select grop_desc
      into o_desc
      from come_oper_stoc_grup
     where grop_codi = i_codi;

  exception
    when no_data_found then
      raise_application_error(-20009, 'Producto Inexistente!!!');
  end;

  procedure pp_muestra_oper_desc(i_oper_codi in number,
                                 o_oper_desc out varchar2) is
  begin
    select a.oper_desc
      into o_oper_desc
      from come_stoc_oper a
     where a.oper_codi = i_oper_codi;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Tipo de Operacion inexistente.');
    when others then
      raise_application_error(-20011, sqlcode || sqlerrm);
  end pp_muestra_oper_desc;

  procedure pp_llama_reporte is
    v_parametros   CLOB;
    v_contenedores CLOB;
  begin
    v_contenedores := 'p_app_session:p_user:p_titulo';

    v_parametros := parameter.p_app_session || ':' || chr(39) || gen_user ||
                    chr(39) || ':' || parameter.p_report || parameter.p_titulo;

    DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = gen_user;

    INSERT INTO COME_PARAMETROS_REPORT
      (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
    VALUES
      (V_PARAMETROS, gen_user, parameter.p_report, 'pdf', V_CONTENEDORES);

    commit;
  end pp_llama_reporte;

  procedure pp_generar_consulta(i_app_session    in number,
                                i_peri_codi      in number,
                                i_peri_desc      in varchar2,
                                i_prod_codi      in number default null,
                                i_prod_codi_alfa in number default null,
                                i_prod_desc      in varchar2,
                                i_lote_codi      in number default null,
                                i_lote_desc      in varchar2,
                                i_clco_codi      in number default null,
                                i_clco_desc      in varchar2,
                                i_clas1_codi     in number default null,
                                i_clas1_desc     in varchar2,
                                i_grop_codi      in number default null,
                                i_grop_desc      in varchar2,
                                i_oper_codi      in number default null,
                                i_oper_desc      in varchar2,
                                i_tipo_repo      in char) is
    v_sql       varchar2(10000);
    v_clco_codi number;
  begin
    parameter.p_app_session     := i_app_session;
    parameter.p_where           := parameter.p_where ||
                                   ' and pe.peri_codi = ' ||
                                   to_char(i_peri_codi);
    parameter.p_where_inic_fini := parameter.p_where_inic_fini ||
                                   ' and pe.peri_codi = ' ||
                                   to_char(i_peri_codi);

    if i_prod_codi is not null then
      parameter.p_where := parameter.p_where || ' and p.prod_codi = ' ||
                           to_char(i_prod_codi);
    end if;

    if i_clas1_codi is not null then
      parameter.p_where := parameter.p_where || ' and fa.clas1_codi = ' ||
                           to_char(i_clas1_codi);
    end if;

    if i_grop_codi is not null then
      parameter.p_where := parameter.p_where || ' and g.grop_codi = ' ||
                           to_char(i_grop_codi);
    end if;

    if i_lote_codi is not null then
      parameter.p_where           := parameter.p_where ||
                                     ' and d.deta_lote_codi = ' ||
                                     i_lote_codi || ' ';
      parameter.p_where_inic_fini := parameter.p_where_inic_fini ||
                                     ' and PELO_LOTE_CODI = ' ||
                                     i_lote_codi || ' ';
    end if;

    if i_clco_codi is not null then

      if parameter.p_clas_prod_term <> 0 and
         parameter.p_clas_prod_en_proc <> 0 then
        ---caso alpacasa

        v_clco_Codi := i_clco_codi;

        if i_clco_codi = parameter.p_clas_prod_en_proc then
          ---prodcuto en proceso
          parameter.p_where           := parameter.p_where ||
                                         ' and lote_Desc = ' || chr(39) ||
                                         '000000' || chr(39) || ' ';
          parameter.p_where_inic_fini := parameter.p_where_inic_fini ||
                                         ' and lote_Desc = ' || chr(39) ||
                                         '000000' || chr(39) || ' ';
        end if;

        if i_clco_codi = parameter.p_clas_prod_term then
          ---prodcuto terminado
          parameter.p_where           := parameter.p_where ||
                                         ' and lote_Desc <> ' || chr(39) ||
                                         '000000' || chr(39) || ' ';
          parameter.p_where_inic_fini := parameter.p_where_inic_fini ||
                                         ' and lote_Desc <> ' || chr(39) ||
                                         '000000' || chr(39) || ' ';

          v_clco_codi := 3;
        end if;
      else
        v_Clco_codi := i_clco_codi;

      end if;

      parameter.p_where           := parameter.p_where ||
                                     ' and prod_clco_codi = ' ||
                                     v_clco_Codi || ' ';
      parameter.p_where_inic_fini := parameter.p_where_inic_fini ||
                                     ' and prod_clco_Codi = ' ||
                                     v_clco_Codi || ' ';

    end if;
    parameter.p_where           := parameter.p_where ||
                                   ' and pe.peri_codi = ' ||
                                   to_char(i_peri_codi);
    parameter.p_where_inic_fini := parameter.p_where_inic_fini ||
                                   ' and pe.peri_codi = ' ||
                                   to_char(i_peri_codi);

    if i_prod_codi is not null then
      parameter.p_where := parameter.p_where || ' and p.prod_codi = ' ||
                           to_char(i_prod_codi);
    end if;

    if i_clas1_codi is not null then
      parameter.p_where := parameter.p_where || ' and fa.clas1_codi = ' ||
                           to_char(i_clas1_codi);
    end if;

    if i_grop_codi is not null then
      parameter.p_where := parameter.p_where || ' and g.grop_codi = ' ||
                           to_char(i_grop_codi);
    end if;

    if i_lote_codi is not null then
      parameter.p_where           := parameter.p_where ||
                                     ' and d.deta_lote_codi = ' ||
                                     i_lote_codi || ' ';
      parameter.p_where_inic_fini := parameter.p_where_inic_fini ||
                                     ' and PELO_LOTE_CODI = ' ||
                                     i_lote_codi || ' ';
    end if;

    if i_oper_codi is not null then
      parameter.p_where := parameter.p_where || ' and oper_codi = ' ||
                           to_char(i_oper_codi);
    end if;

    if i_clco_codi is not null then

      if parameter.p_clas_prod_term <> 0 and
         parameter.p_clas_prod_en_proc <> 0 then
        ---caso alpacasa

        v_clco_codi := i_clco_codi;

        if i_clco_codi = parameter.p_clas_prod_en_proc then
          ---prodcuto en proceso
          parameter.p_where           := parameter.p_where ||
                                         ' and lote_Desc = ' || chr(39) ||
                                         '000000' || chr(39) || ' ';
          parameter.p_where_inic_fini := parameter.p_where_inic_fini ||
                                         ' and lote_Desc = ' || chr(39) ||
                                         '000000' || chr(39) || ' ';
        end if;

        if i_clco_codi = parameter.p_clas_prod_term then
          ---prodcuto terminado
          parameter.p_where           := parameter.p_where ||
                                         ' and lote_Desc <> ' || chr(39) ||
                                         '000000' || chr(39) || ' ';
          parameter.p_where_inic_fini := parameter.p_where_inic_fini ||
                                         ' and lote_Desc <> ' || chr(39) ||
                                         '000000' || chr(39) || ' ';

          v_clco_codi := 3;
        end if;
      else
        v_clco_codi := i_clco_codi;
      end if;

      parameter.p_where           := parameter.p_where ||
                                     ' and prod_clco_codi = ' ||
                                     v_clco_Codi || ' ';
      parameter.p_where_inic_fini := parameter.p_where_inic_fini ||
                                     ' and prod_clco_Codi = ' ||
                                     v_clco_Codi || ' ';

    end if;

    delete come_tabl_auxi
     where taax_sess = parameter.p_app_session
       and taax_user = gen_user;
    commit;

    if i_tipo_repo = 'RO' then
      parameter.p_report := 'I040067RO';
      v_sql              := 'insert into come_tabl_auxi
      (taax_sess,
       taax_user,
       taax_c001,
       taax_c002,
       taax_n003,
       taax_n004,
       taax_n005,
       taax_n006,
       taax_n007,
       taax_n008,
       taax_n009,
       taax_n010,
       taax_n011,
       taax_n012,
       taax_n013, --fields
       taax_c014, --parameters
       taax_c015,
       taax_c016,
       taax_c017,
       taax_c018,
       taax_c019,
       taax_c020,
       taax_c021,
       taax_c022,
       taax_c023,
       taax_c024,
       taax_c025,
       taax_c026,
       taax_seq)
select ' || parameter.p_app_session || ',
       ' || chr(39) || gen_user || chr(39) || ',
       oper.*,
       ' || chr(39) || i_peri_desc || chr(39) || ',
       ' || chr(39) || i_prod_codi_alfa || chr(39) || ',
       ' || chr(39) || i_prod_desc || chr(39) || ',
       ' || chr(39) || i_lote_codi || chr(39) || ',
       ' || chr(39) || i_lote_desc || chr(39) || ',
       ' || chr(39) || i_clco_codi || chr(39) || ',
       ' || chr(39) || i_clco_desc || chr(39) || ',
       ' || chr(39) || i_clas1_codi || chr(39) || ',
       ' || chr(39) || i_clas1_desc || chr(39) || ',
       ' || chr(39) || i_grop_codi || chr(39) || ',
       ' || chr(39) || i_grop_desc || chr(39) || ',
       ' || chr(39) || i_oper_codi || chr(39) || ',
       ' || chr(39) || i_oper_desc || chr(39) || ',
       seq_come_tabl_auxi.nextval
  from (
select o.oper_desc,
       o.oper_codi,
       sum(decode(o.oper_stoc_suma_rest, ' ||
                            chr(39) || 'R' || chr(39) ||
                            ', -d.deta_cant, deta_cant)) cant,
       sum(decode(o.oper_codi,
                  6,
                  (d.deta_impo_mmnn),
                  8,
                  -1 * (d.deta_impo_mmnn),
                  0)) Importe_mmnn,
       sum(decode(o.oper_codi,
                  6,
                  (d.deta_impo_mmee),
                  8,
                  -1 * (d.deta_impo_mmee),
                  0)) Importe_mmee,
       sum(round((decode(o.oper_stoc_suma_rest, ' ||
                            chr(39) || 'R' || chr(39) ||
                            ', (-1), 1) *
                 decode(nvl(o.oper_indi_valo_cost, ' ||
                            chr(39) || 'C' || chr(39) || '),
                         ' || chr(39) || 'C' ||
                            chr(39) || ',
                         d.deta_cant * pp.pelo_cost_fini_mmnn,
                         d.deta_impo_mmnn)),
                 0)) Costo_mmnn,
       sum(round((decode(o.oper_stoc_suma_rest, ' ||
                            chr(39) || 'R' || chr(39) ||
                            ', (-1), 1) *
                 decode(nvl(o.oper_indi_valo_cost, ' ||
                            chr(39) || 'C' || chr(39) || '),
                         ' || chr(39) || 'C' ||
                            chr(39) || ',
                         d.deta_cant * pp.pelo_cost_fini_mmee,
                         d.deta_impo_mmee)),
                 0)) Costo_mmee,
       s.stoc_inic_mmnn,
       s.stoc_fini_mmnn,
       s.stoc_inic_mmee,
       s.stoc_fini_mmee,
       s.cant_fini,
       s.cant_inic
  from come_stoc_oper      o,
       come_movi           m,
       come_movi_prod_deta d,
       come_prod           p,
       come_lote           l,
       come_prod_peri_lote pp,
       come_peri           pe,
       come_prod_clas_1    fa,
       come_oper_stoc_grup g,
       (select sum(pp.pelo_cost_inic_mmnn * pp.pelo_cant_inic) stoc_inic_mmnn,
       sum(pp.pelo_cost_fini_mmnn * pp.pelo_cant_fini) stoc_fini_mmnn,
       sum(pp.pelo_cost_inic_mmee * pp.pelo_cant_inic) stoc_inic_mmee,
       sum(pp.pelo_cost_fini_mmee * pp.pelo_cant_fini) stoc_fini_mmee,
       sum(pp.pelo_cant_fini) cant_fini,
       sum(pp.pelo_cant_inic) cant_inic
  from come_prod_peri_lote pp, come_peri pe, come_prod p, come_lote l
 where pp.pelo_peri_codi = pe.peri_codi
   and pp.pelo_lote_codi = l.lote_codi
   and p.prod_codi = pp.pelo_prod_codi
   ' || parameter.p_where_inic_fini || ') s
 where o.oper_codi = m.movi_oper_codi
   and m.movi_codi = d.deta_movi_codi
   and deta_lote_codi = lote_codi
   and d.deta_prod_codi = p.prod_codi
   and pp.pelo_prod_codi = p.prod_codi
   and pp.pelo_peri_codi = pe.peri_codi
   and pp.pelo_lote_codi = d.deta_lote_codi
   and p.prod_clas1 = fa.clas1_codi
   and o.oper_grop_codi = g.grop_codi(+)
   and m.movi_fech_emis between pe.peri_fech_inic and pe.peri_fech_fini
   ' || parameter.p_where || '
 group by o.oper_desc,
       o.oper_codi,
       s.stoc_inic_mmnn,
       s.stoc_fini_mmnn,
       s.stoc_inic_mmee,
       s.stoc_fini_mmee,
       s.cant_fini,
       s.cant_inic
 order by 1, 2
) oper ';
    elsif i_tipo_repo = 'DO' then
      parameter.p_report := 'I040067DO';
      v_sql              := 'insert into come_tabl_auxi
      (taax_sess,
       taax_user,
       taax_c001,
       taax_n002,
       taax_n003,
       taax_c004,
       taax_c005,
       taax_c006,
       taax_n007,
       taax_n008,
       taax_n009,
       taax_n010,
       taax_n011,
       taax_n012,
       taax_n013,
       taax_n014,
       taax_n015,
       taax_n016, --fields
       taax_c017,
       taax_c018,
       taax_c019,
       taax_c020,
       taax_c021,
       taax_c022,
       taax_c023,
       taax_c024,
       taax_c025,
       taax_c026,
       taax_c027,
       taax_c028,
       taax_c029,
       taax_seq)
select ' || parameter.p_app_session || ',
       ' || chr(39) || gen_user || chr(39) || ',
       oper.*,
       ' || chr(39) || i_peri_desc || chr(39) || ',
       ' || chr(39) || i_prod_codi_alfa ||
                            chr(39) || ',
       ' || chr(39) || i_prod_desc || chr(39) || ',
       ' || chr(39) || i_lote_codi || chr(39) || ',
       ' || chr(39) || i_lote_desc || chr(39) || ',
       ' || chr(39) || i_clco_codi || chr(39) || ',
       ' || chr(39) || i_clco_desc || chr(39) || ',
       ' || chr(39) || i_clas1_codi || chr(39) || ',
       ' || chr(39) || i_clas1_desc || chr(39) || ',
       ' || chr(39) || i_grop_codi || chr(39) || ',
       ' || chr(39) || i_grop_desc || chr(39) || ',
       ' || chr(39) || i_oper_codi || chr(39) || ',
       ' || chr(39) || i_oper_desc || chr(39) || ',
       seq_come_tabl_auxi.nextval
  from (
select o.oper_desc,
       o.oper_codi,
       m.movi_nume,
       m.movi_fech_emis,
       m.movi_obse,
       prov.clpr_desc,
       sum(decode(o.oper_stoc_suma_rest, ' ||
                            chr(39) || 'R' || chr(39) ||
                            ', (-1), 1) * d.deta_cant) deta_cant,
       sum(decode(o.oper_codi,
                  6,
                  (d.deta_impo_mmnn),
                  8,
                  -1 * (d.deta_impo_mmnn),
                  0)) Importe_mmnn,
       sum(round((decode(o.oper_stoc_suma_rest, ' ||
                            chr(39) || 'R' || chr(39) ||
                            ', (-1), 1) *
                 decode(nvl(o.oper_indi_valo_cost, ' ||
                            chr(39) || 'C' || chr(39) || '),
                         ' || chr(39) || 'C' ||
                            chr(39) || ',
                         d.deta_cant * pp.pelo_cost_fini_mmnn,
                         d.deta_impo_mmnn)),
                 0)) Costo_mmnn,
       sum(decode(o.oper_codi,
                  6,
                  (d.deta_impo_mmee),
                  8,
                  -1 * (d.deta_impo_mmee),
                  0)) Importe_mmee,
       sum(round((decode(o.oper_stoc_suma_rest, ' ||
                            chr(39) || 'R' || chr(39) ||
                            ', (-1), 1) *
                 decode(nvl(o.oper_indi_valo_cost, ' ||
                            chr(39) || 'C' || chr(39) || '),
                         ' || chr(39) || 'C' ||
                            chr(39) || ',
                         d.deta_cant * pp.pelo_cost_fini_mmee,
                         d.deta_impo_mmee)),
                 0)) Costo_mmee,
       rownum registro,
       null stoc_inic_mmnn,
       null stoc_fini_mmnn,
       null stoc_inic_mmee,
       null stoc_fini_mmee
  from come_stoc_oper      o,
       come_movi           m,
       come_movi_prod_deta d,
       come_prod           p,
       come_prod_peri_lote pp,
       come_peri           pe,
       come_prod_clas_1    fa,
       come_oper_stoc_grup g,
       come_clie_prov      prov
 where o.oper_codi = m.movi_oper_codi
   and m.movi_codi = d.deta_movi_codi
   and d.deta_prod_codi = p.prod_codi
   and pp.pelo_prod_codi = p.prod_codi
   and pp.pelo_peri_codi = pe.peri_codi
   and pp.pelo_lote_codi = d.deta_lote_codi
   and p.prod_clas1 = fa.clas1_codi
   and m.movi_clpr_codi = prov.clpr_codi(+)
   and o.oper_grop_codi = g.grop_codi(+)
   and m.movi_fech_emis between pe.peri_fech_inic and pe.peri_fech_fini
   ' || parameter.p_where || '
 group by o.oper_codi,
          o.oper_desc,
          p.prod_desc,
          clpr_desc,
          m.movi_obse,
          m.movi_nume,
          m.movi_fech_emis,
          rownum
union all
select null,
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       sum(pp.pelo_cost_inic_mmnn * pp.pelo_cant_inic) stoc_inic_mmnn,
       sum(pp.pelo_cost_fini_mmnn * pp.pelo_cant_fini) stoc_fini_mmnn,
       sum(pp.pelo_cost_inic_mmee * pp.pelo_cant_inic) stoc_inic_mmee,
       sum(pp.pelo_cost_fini_mmee * pp.pelo_cant_fini) stoc_fini_mmee
  from come_prod_peri_lote pp, come_peri pe, come_prod p
 where pp.pelo_peri_codi = pe.peri_codi
   and p.prod_codi = pp.pelo_prod_codi
   ' || parameter.p_where_inic_fini || '
 order by 1, 3
) oper ';
    elsif i_tipo_repo = 'DP' then
      parameter.p_report := 'I040067DP';
      v_sql              := 'insert into come_tabl_auxi
      (taax_sess,
       taax_user,
       taax_c001,
       taax_n002,
       taax_c003,
       taax_c004,
       taax_n005,
       taax_c006,
       taax_c007,
       taax_n008,
       taax_n009,
       taax_n010,
       taax_n011,
       taax_n012,
       taax_n013,
       taax_n014,
       taax_n015,
       taax_n016,
       taax_n017, --fields
       taax_c018,
       taax_c019,
       taax_c020,
       taax_c021,
       taax_c022,
       taax_c023,
       taax_c024,
       taax_c025,
       taax_c026,
       taax_c027,
       taax_c028,
       taax_c029,
       taax_c030,
       taax_seq)
select ' || parameter.p_app_session || ',
       ' || chr(39) || gen_user || chr(39) || ',
       oper.*,
       ' || chr(39) || i_peri_desc || chr(39) || ',
       ' || chr(39) || i_prod_codi_alfa ||
                            chr(39) || ',
       ' || chr(39) || i_prod_desc || chr(39) || ',
       ' || chr(39) || i_lote_codi || chr(39) || ',
       ' || chr(39) || i_lote_desc || chr(39) || ',
       ' || chr(39) || i_clco_codi || chr(39) || ',
       ' || chr(39) || i_clco_desc || chr(39) || ',
       ' || chr(39) || i_clas1_codi || chr(39) || ',
       ' || chr(39) || i_clas1_desc || chr(39) || ',
       ' || chr(39) || i_grop_codi || chr(39) || ',
       ' || chr(39) || i_grop_desc || chr(39) || ',
       ' || chr(39) || i_oper_codi || chr(39) || ',
       ' || chr(39) || i_oper_desc || chr(39) || ',
       seq_come_tabl_auxi.nextval
  from (
select o.oper_desc,
       o.oper_codi,
       p.prod_codi_alfa,
       p.prod_desc,
       m.movi_nume,
       m.movi_fech_emis,
       m.movi_obse,
       sum(decode(o.oper_stoc_suma_rest, ' ||
                            chr(39) || 'R' || chr(39) ||
                            ', (-1), 1) * d.deta_cant) deta_cant,
       sum(decode(o.oper_codi,
                  6,
                  (d.deta_impo_mmnn),
                  8,
                  -1 * (d.deta_impo_mmnn),
                  0)) Importe_mmnn,
       sum(round((decode(o.oper_stoc_suma_rest, ' ||
                            chr(39) || 'R' || chr(39) ||
                            ', (-1), 1) *
                 decode(nvl(o.oper_indi_valo_cost, ' ||
                            chr(39) || 'C' || chr(39) || '),
                         ' || chr(39) || 'C' ||
                            chr(39) || ',
                         d.deta_cant * pp.pelo_cost_fini_mmnn,
                         d.deta_impo_mmnn)),
                 0)) Costo_mmnn,
       sum(decode(o.oper_codi,
                  6,
                  (d.deta_impo_mmee),
                  8,
                  -1 * (d.deta_impo_mmee),
                  0)) Importe_mmee,
       sum(round((decode(o.oper_stoc_suma_rest, ' ||
                            chr(39) || 'R' || chr(39) ||
                            ', (-1), 1) *
                 decode(nvl(o.oper_indi_valo_cost, ' ||
                            chr(39) || 'C' || chr(39) || '),' || chr(39) || 'C' ||
                            chr(39) || ',
                         d.deta_cant * pp.pelo_cost_fini_mmee,
                         d.deta_impo_mmee)),
                 0)) Costo_mmee,
       rownum registro,
       null stoc_inic_mmnn,
       null stoc_fini_mmnn,
       null stoc_inic_mmee,
       null stoc_fini_mmee
  from come_stoc_oper      o,
       come_movi           m,
       come_movi_prod_deta d,
       come_prod           p,
       come_prod_peri_lote pp,
       come_peri           pe,
       come_prod_clas_1    fa,
       come_oper_stoc_grup g
 where o.oper_codi = m.movi_oper_codi
   and m.movi_codi = d.deta_movi_codi
   and d.deta_prod_codi = p.prod_codi
   and pp.pelo_prod_codi = p.prod_codi
   and pp.pelo_peri_codi = pe.peri_codi
   and pp.pelo_lote_codi = d.deta_lote_codi
   and p.prod_clas1 = fa.clas1_codi
   and o.oper_grop_codi = g.grop_codi(+)
   and m.movi_fech_emis between pe.peri_fech_inic and pe.peri_fech_fini
   ' || parameter.p_where || '
 group by o.oper_desc,
          o.oper_codi,
          p.prod_codi_alfa,
          p.prod_desc,
          rownum,
          m.movi_nume,
          m.movi_fech_emis,
          m.movi_obse
union all
select null,
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       sum(pp.pelo_cost_inic_mmnn * pp.pelo_cant_inic) stoc_inic_mmnn,
       sum(pp.pelo_cost_fini_mmnn * pp.pelo_cant_fini) stoc_fini_mmnn,
       sum(pp.pelo_cost_inic_mmee * pp.pelo_cant_inic) stoc_inic_mmee,
       sum(pp.pelo_cost_fini_mmee * pp.pelo_cant_fini) stoc_fini_mmee
  from come_prod_peri_lote pp, come_peri pe, come_prod p
 where pp.pelo_peri_codi = pe.peri_codi
   and p.prod_codi = pp.pelo_prod_codi
   ' || parameter.p_where_inic_fini || '
 order by 1, 2
) oper ';
    end if;

    /*insert into come_concat (campo1, otro) values (V_SQL, 'CONSULTA_DL');
    COMMIT;*/

    execute immediate v_sql;
    pp_llama_reporte;

  end pp_generar_consulta;
end I040067;
