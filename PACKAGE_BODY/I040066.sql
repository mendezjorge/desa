
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I040066" is

  type r_parameter is record(
    p_app_session varchar2(100),--number,
    p_where       varchar2(500),
    p_report      varchar2(20) := 'I040066',
    p_titulo      varchar2(50) := ' - Reporte de Liquidacion de Sueldos');

  parameter r_parameter;

  procedure pp_muestra_empl(i_empl_codi_alte in varchar2,
                            o_empl_desc      out varchar2,
                            o_empl_codi      out number,
                            o_empl_esta      out char) is
  begin
    select empl_codi, empl_desc, empl_esta
      into o_empl_codi, o_empl_desc, o_empl_esta
      from come_empl
     where empl_codi_alte = i_empl_codi_alte;
  
    if o_empl_esta <> 'A' then
      raise_application_error(-20001, 'El empleado se encuentra Inactivo');
    end if;
  
  Exception
    when no_data_found then
      raise_application_error(-20002,
                              'Empleado no asignado en el perfil del usuario o Inexistente!');
    when others then
      raise_application_error(-20003, sqlcode || sqlerrm);
  end;

  procedure pp_mostrar_sucursal(i_sucu_codi in number,
                                o_sucu_desc out varchar2) is
  begin
  
    select b.sucu_desc
      into o_sucu_desc
      from come_sucu b
     where b.sucu_codi = i_sucu_codi;
  
  exception
    When no_data_found then
      raise_application_error(-20001, 'Sucursal inexistente');
    when too_many_rows then
      raise_application_error(-20002,
                              'Muchos resultados, llame a su administrador');
    when others then
      raise_application_error(-20003, sqlcode || sqlerrm);
  end pp_mostrar_sucursal;

  procedure pp_muestra_come_empr_dept(i_codi in number,
                                      o_desc out varchar2) is
  begin
    select emde_desc
      into o_desc
      from come_empr_dept
     where emde_codi = i_codi;
  
  Exception
    When no_data_found then
      raise_application_error(-20003,
                              'Departamento de la Empresa Inexistente');
    when others then
      raise_application_error(-20004, sqlcode || sqlerrm);
  end pp_muestra_come_empr_dept;

  procedure pp_muestra_come_empr_secc(i_emse_codi      in number,
                                      i_emse_emde_codi in number default null,
                                      o_emse_desc      out varchar2) is
    v_cant number;
  begin
    select emse_desc
      into o_emse_desc
      from come_empr_secc
     where emse_codi = i_emse_codi;
  
    if i_emse_emde_codi is not null then
      select count(*)
        into v_cant
        from come_empr_secc
       where emse_emde_codi = i_emse_emde_codi
         and emse_codi = i_emse_codi;
    end if;
  
    if v_cant = 0 then
      raise_application_error(-20005,
                              'La seccion no corresponde al departamento seleccionado');
    end if;
  
  Exception
    When no_data_found then
      raise_application_error(-20006, 'Secci?n de la empresa Inexistente');
    when others then
      raise_application_error(-20007, sqlcode || sqlerrm);
  end pp_muestra_come_empr_secc;

  procedure pp_muestra_plant_sueld(i_codi in number, o_desc out varchar2) is
  begin
    select plsu_desc
      into o_desc
      from rrhh_plan_suel
     where plsu_codi = i_codi;
  
  Exception
    When no_data_found then
      raise_application_error(-20008, 'Plantilla de sueldo inexistente.');
    when others then
      raise_application_error(-20009, sqlcode || sqlerrm);
  end pp_muestra_plant_sueld;

  procedure pp_muestra_conc(i_codi_alte in number,
                            o_codi      out number,
                            o_desc      out varchar2) is
  begin
    select conc_desc, conc_codi
      into o_desc, o_codi
      from rrhh_conc
     where conc_codi_alte = i_codi_alte;
  
  Exception
    When no_data_found then
      raise_application_error(-20010, 'Concepto inexistente.');
    when others then
      raise_application_error(-20011, sqlcode || sqlerrm);
  end pp_muestra_conc;

  procedure pp_muestra_moneda(i_codi      in number,
                              o_desc      out varchar2,
                              o_cant_deci out number) is
  begin
    select mone_desc, mone_cant_deci
      into o_desc, o_cant_deci
      from come_mone
     where mone_codi = i_codi;
  
  Exception
    When no_data_found then
      raise_application_error(-20012, 'Moneda inexistente.');
    when others then
      raise_application_error(-20013, sqlcode || sqlerrm);
  end pp_muestra_moneda;

  procedure pp_mostrar_peri(i_peri_codi      in number,
                            o_peri_fech_inic out date,
                            o_peri_fech_fini out date) is
  begin
  
    select peri_fech_inic, peri_fech_fini
    --to_char(peri_anho_mess, 'Month'),
    --to_char(peri_anho_mess, 'yyyy')
      into o_peri_fech_inic, o_peri_fech_fini
    --:parameter.p_peri_mess,
    --:parameter.p_peri_anho
      from rrhh_peri
     where peri_codi = i_peri_codi;
  
  exception
    When no_data_found then
      raise_application_error(-20014, 'Periodo inexistente');
    when others then
      raise_application_error(-20015, sqlcode || sqlerrm);
  end pp_mostrar_peri;

  procedure pp_llama_reporte is
    v_parametros   CLOB;
    v_contenedores CLOB;
  begin
    v_contenedores := 'p_app_session:p_user:p_titulo';
  
    v_parametros := parameter.p_app_session || ':' || CHR(39) || gen_user ||
                    CHR(39) || ':' || parameter.p_report ||
                    parameter.p_titulo;
  
    DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = gen_user;
  
    INSERT INTO COME_PARAMETROS_REPORT
      (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
    VALUES
      (V_PARAMETROS, gen_user, parameter.p_report, 'pdf', V_CONTENEDORES);
  
    commit;
  end pp_llama_reporte;

  procedure pp_generar_consulta(i_app_session in number,
                                i_mone_codi   in number default null,
                                i_empl_codi   in number default null,
                                i_sucu_codi   in number default null,
                                i_emde_codi   in number default null,
                                i_emse_codi   in number default null,
                                i_plsu_codi   in number default null,
                                i_liqu_nume   in number default null,
                                i_tipo_liqu   in varchar2,
                                i_peri_codi   in number default null,
                                i_tipo_repo   in varchar2) is
    v_sql varchar2(10000);
  begin
    
    
    parameter.p_app_session := i_app_session;
    if i_mone_codi is not null then
      parameter.p_where := parameter.p_where ||
                           ' and nvl(liqu_mone_codi, 1) =' ||
                           to_char(i_mone_codi) || '  ';
    end if;
  
    if i_empl_codi is not null then
      parameter.p_where := parameter.p_where || ' and liqu_empl_codi =' ||
                           to_char(i_empl_codi) || '  ';
    else
      parameter.p_where := parameter.p_where ||
                           ' and empl_codi in (select pe.peem_empl_codi from rrhh_perf p, rrhh_perf_empl pe, segu_user u where p.perf_codi = pe.peem_perf_codi and p.perf_codi = user_perf_codi and user_login = gen_user)' || '  ';
    end if;
    
    if i_sucu_codi is not null then
      parameter.p_where := parameter.p_where || ' and sucu.sucu_codi =' ||
                           to_char(i_sucu_codi) || '  ';
    end if;
  
    if i_emde_codi is not null then
      parameter.p_where := parameter.p_where || ' and dep.emde_codi =' ||
                           to_char(i_emde_codi) || '  ';
    end if;
  
    if i_emse_codi is not null then
      parameter.p_where := parameter.p_where || ' and secc.emse_codi =' ||
                           to_char(i_emse_codi) || '  ';
    end if;
  
    if i_plsu_codi is not null then
      parameter.p_where := parameter.p_where || ' and ps.plsu_codi =' ||
                           to_char(i_plsu_codi) || '  ';
    end if;
  
    if i_liqu_nume is not null then
      parameter.p_where := parameter.p_where || ' and liqu_nume =' ||
                           to_char(i_liqu_nume) || '  ';
    end if;
  
    if nvl(i_tipo_liqu, 'M') = 'M' then
      --Salario mensual
      parameter.p_where := parameter.p_where || ' and nvl(liqu_tipo_liqu, ' ||
                           chr(39) || 'M' || chr(39) || ') = ' || chr(39) || 'M' ||
                           chr(39) || '  ';
    elsif nvl(i_tipo_liqu, 'M') = 'A' then
      --Aguinaldo
      parameter.p_where := parameter.p_where || ' and nvl(liqu_tipo_liqu, ' ||
                           chr(39) || 'M' || chr(39) || ') = ' || chr(39) || 'A' ||
                           chr(39) || '  ';
    end if;
  
    if i_peri_codi is not null then
      parameter.p_where := parameter.p_where || ' and liqu_peri_codi =' ||
                           to_char(i_peri_codi) || '  ';
    end if;
  
    delete come_tabl_auxi
     where taax_sess = parameter.p_app_session--V('APP_SESSION')
       and taax_user = gen_user;
    commit;
  
    if i_tipo_repo = 'M' then
      parameter.p_report := 'I040066';
      ---Ministerio
      v_sql := 'insert into come_tabl_auxi
      (taax_sess,
       taax_user,
       taax_c001,
       taax_c002,
       taax_c003,
       taax_c004,
       taax_c005,
       taax_c006,
       taax_c007,
       taax_c008,
       taax_c009,
       taax_c010,
       taax_c011,
       taax_n002,
       taax_c013,
       taax_c014,
       taax_c015,
       taax_c016,
       taax_c017,
       taax_c018,
       taax_n009,
       taax_n010,
       taax_n011,
       taax_n012,
       taax_n013,
       taax_n014,
       taax_c025,
       taax_n016,
       taax_seq)
select ' || parameter.p_app_session || ',
       ' || chr(39) || gen_user || chr(39) || ',
       liqu.*,
       seq_come_tabl_auxi.nextval
  from (
select 1 || ' || chr(39) || ' al ' || chr(39) ||
               ' || to_char(trunc(last_day(liqu_fech_desd)), ' || chr(39) || 'dd' ||
               chr(39) || ') || ' || chr(39) || ' ' || chr(39) || ' ||
       initcap(trim(TO_char(liqu_fech_desd, ' || chr(39) ||
               'MONTH' || chr(39) || '))) || ' || chr(39) || ' del ' ||
               chr(39) || ' ||
       TO_char(liqu_fech_desd, ' || chr(39) || 'YYYY' ||
               chr(39) || ') periodo,
       e.empl_codi,
       e.empl_desc,
       e.empl_cedu_nume,
       m.mone_codi,
       l.liqu_fech_emis,
       m.mone_desc_abre,
       m.mone_desc,
       m.mone_cant_deci,
       nvl(sum(decode(c.conc_codi, 5, d.deta_cant, 24, d.deta_cant)), 0) dias_trabaj,
       nvl(sum(decode(c.conc_codi, 26, deta_cant)), 0) ausencias,
       l.liqu_suel_base salario,
       sucu.sucu_regi_patr,
       l.liqu_nume,
       l.liqu_codi,
       empr.empr_desc,
       empr.empr_tele,
       empr.empr_dire,
       nvl(sum(decode(c.conc_codi,
                      5,
                      d.deta_impo_ingre,
                      24,
                      d.deta_impo_ingre,
                      null)),
           0) norma,
       nvl(sum(decode(c.conc_codi,
                      6,
                      d.deta_impo_egre,
                      29,
                      d.deta_impo_egre,
                      null)),
           0) ips,
       nvl(sum(decode(c.conc_codi, 9, d.deta_impo_egre, null)), 0) comi,
       nvl(sum(decode(c.conc_codi,
                      11,
                      d.deta_impo_ingre,
                      12,
                      d.deta_impo_ingre,
                      13,
                      d.deta_impo_ingre,
                      null)),
           0) extra,
       nvl(sum(decode(c.conc_dbcr, ' || chr(39) || 'D' ||
               chr(39) || ', d.deta_impo_ingre, null)), 0) tota_ingre,
       nvl(sum(decode(c.conc_dbcr, ' || chr(39) || 'C' ||
               chr(39) || ', d.deta_impo_egre, null)), 0) tota_egre,
       empr.empr_ruc,
       0 cero
  from rrhh_liqu           l,
       rrhh_conc_liqu_deta d,
       rrhh_conc           c,
       rrhh_plan_suel      ps,
       come_empl           e,
       come_mone           m,
       come_empr           empr,
       come_empr_dept      dep,
       come_empr_secc      secc,
       come_sucu           sucu
 where l.liqu_codi = d.deta_liqu_codi
   and nvl(d.deta_indi_sala_comp, ' || chr(39) || 'N' ||
               chr(39) || ') = ' || chr(39) || 'N' || chr(39) || '
   and l.liqu_empl_codi = e.empl_codi
   and e.empl_plsu_codi = ps.plsu_codi
   and l.liqu_mone_codi = m.mone_codi
   and sucu_empr_codi = 1
   and dep.emde_codi = secc.emse_emde_codi
   and secc.emse_codi = e.Empl_Emse_Codi
   and c.conc_codi = d.deta_conc_codi
   and e.empl_sucu_codi = sucu.sucu_codi(+)
   and e.empl_empr_codi = empr.empr_codi
   ' || parameter.p_where || '
 group by e.empl_codi,
          e.empl_desc,
          e.empl_cedu_nume,
          m.mone_codi,
          m.mone_desc_abre,
          m.mone_desc,
          m.mone_cant_deci,
          l.liqu_suel_base,
          1 || ' || chr(39) || ' al ' || chr(39) ||
               ' || to_char(trunc(last_day(liqu_fech_desd)), ' || chr(39) || 'dd' ||
               chr(39) || ') || ' || chr(39) || ' ' || chr(39) || ' ||
          initcap(trim(TO_char(liqu_fech_desd, ' || chr(39) ||
               'MONTH' || chr(39) || '))) || ' || chr(39) || ' del ' ||
               chr(39) || ' ||
          TO_char(liqu_fech_desd, ' || chr(39) || 'YYYY' ||
               chr(39) || '),
          l.liqu_nume,
          l.liqu_codi,
          sucu.sucu_regi_patr,
          l.liqu_fech_emis,
          empr_ruc,
          empr_desc,
          empr_tele,
          empr.empr_dire
 order by liqu_nume
  ) liqu ';
    
    else
      ---interno
      parameter.p_report := 'I040066I';
      v_sql              := 'insert into come_tabl_auxi
      (taax_sess,
       taax_user,
       taax_c001,
       taax_c002,
       taax_c003,
       taax_n004,
       taax_c005,
       taax_c006,
       taax_c007,
       taax_c008,
       taax_n009,
       taax_c010,
       taax_c011,
       taax_c012,
       taax_n013,
       taax_n014,
       taax_c015,
       taax_c016,
       taax_c017,
       taax_n018,
       taax_n019,
       taax_n020,
       taax_c021,
       taax_c022,
       taax_n003,
       taax_c024,
       taax_seq)
select ' || parameter.p_app_session || ',
       ' || chr(39) || gen_user || chr(39) || ',
       liqu.*,
       seq_come_tabl_auxi.nextval
  from (
select liqu_fech_desd,
       liqu_fech_hast,
       c.conc_unit_medi,
       m.mone_codi,
       m.mone_desc_abre,
       m.mone_desc,
       m.mone_cant_deci,
       upper((e.empl_desc || ' || chr(39) || '(' ||
                            chr(39) || ' || to_char(e.empl_codi) || ' ||
                            chr(39) || ')' || chr(39) || ')) empl_desc,
       e.empl_codi,
       e.empl_fech_naci,
       e.empl_cedu_nume,
       e.empl_tele,
       l.liqu_codi,
       l.liqu_nume,
       l.liqu_fech_emis,
       l.liqu_fech_grab,
       d.deta_nume_item,
       d.deta_impo_ingre,
       d.deta_impo_egre,
       d.deta_cant,
       d.deta_obse,
       d.deta_fech,
       c.conc_codi,
       upper(c.conc_desc) conc_desc
  from rrhh_liqu           l,
       rrhh_conc_liqu_deta d,
       rrhh_conc           c,
       come_empl           e,
       come_mone           m,
       rrhh_plan_suel      ps,
       come_empr_secc      secc,
       come_empr_dept      dep
 where l.liqu_codi = d.deta_liqu_codi
   and l.liqu_empl_codi = e.empl_codi
   and l.liqu_mone_codi = m.mone_codi
   and c.conc_codi = d.deta_conc_codi
   and e.empl_emse_Codi = secc.emse_codi
   and e.empl_plsu_codi = ps.plsu_codi
   and secc.EMSE_EMDE_CODI = dep.emde_codi
   ' || parameter.p_where || '
 order by e.empl_desc, l.liqu_nume, d.deta_nume_item
  ) liqu ';
    end if;
   -- insert into come_concat (campo1, otro) values (V_SQL, 'CONSULTA_DL');
   -- COMMIT;
  
    execute immediate v_sql;
    pp_llama_reporte;
  exception
    when others then
      --raise_application_error(-20016, sqlcode || sqlerrm);
      raise_application_error(-20010, 'error: '|| dbms_utility.format_error_backtrace);
  end pp_generar_consulta;
end I040066;
