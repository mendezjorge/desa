
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010012" is

  type r_parameter is record(
    p_report      varchar2(20) := 'I010012',
    p_titulo      varchar2(50) := ' - Pantallas',
    p_app_session number);

  parameter r_parameter;

  procedure pp_llama_reporte is
    v_parametros   CLOB;
    v_contenedores CLOB;
  
  begin
    v_contenedores := 'p_app_session:p_user:p_titulo';
  
    v_parametros := parameter.p_app_session || ':' || CHR(39) || fa_user ||
                    CHR(39) || ':' || parameter.p_report ||
                    parameter.p_titulo;
  
    DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = fa_user;
  
    INSERT INTO COME_PARAMETROS_REPORT
      (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
    VALUES
      (V_PARAMETROS, fa_user, parameter.p_report, 'pdf', V_CONTENEDORES);
  
    commit;
  end pp_llama_reporte;

  --------------------------------------------------------------------------------------- 

  procedure pp_generar_consulta(i_app_session in number) is
    v_sql varchar2(10000);
  begin
    parameter.p_app_session := i_app_session;
    
    delete come_tabl_auxi
     where taax_sess = parameter.p_app_session
       and taax_user = fa_user;
    commit;
  
    v_sql := 'insert into come_tabl_auxi
      (taax_sess,
       taax_user,
       taax_n001,--son paramters (que se usa en el detalle del reporte)
       taax_c002,--son paramters (que se usa en el detalle del reporte)
       taax_c003,--son paramters (que se usa en el detalle del reporte)
       taax_c004,--son paramters (que se usa en el detalle del reporte)
       taax_c005,--son paramters (que se usa en el detalle del reporte)
       taax_c006,--son paramters (que se usa en el detalle del reporte)
       taax_seq)
select ' || parameter.p_app_session || ',
       ' || chr(39) || fa_user || chr(39) || ',
       repo_pant.*,
       seq_come_tabl_auxi.nextval
  from (
select s.pant_codi,
       s.pant_desc,
       s.modu_desc,
       s.clas_desc,
       s.pant_nomb,
       s.pant_file
  from v_segu_pant_modu_clas s
  order by 1) repo_pant ';
  
    execute immediate v_sql;
    pp_llama_reporte;
  
  end pp_generar_consulta;

  ---------------------------------------------------------------------------------------

  procedure pp_abm_pantallas(v_ind            in varchar2,
                             v_pant_codi      in number,
                             v_pant_desc      in varchar2,
                             v_pant_modu      in number,
                             v_pant_clas      in number,
                             v_pant_nomb      in varchar2,
                             v_pant_file      in varchar2,
                             v_pant_para_inic in varchar2,
                             v_pant_indi_admi in varchar2,
                             v_pant_tecn      in varchar2,
                             v_pant_nume_app  in number,
                             v_pant_nume_pagi in varchar2,
                             v_pant_nume      in number,
                             v_pant_file_web  in varchar2,
                             v_pant_imag      in varchar2,
                             v_pant_tool_tips in varchar2,
                             v_pant_pagi_alia in varchar2,
                             v_pant_ord       in number,
                             v_pant_base      in number,
                             v_pant_user_regi in varchar2,
                             v_pant_fech_regi in date) is
    x_pant_codi number;
  
  begin
  

    if v_ind = 'I' then
      select nvl(max(pant_codi), 0) + 1 into x_pant_codi from segu_pant;
      insert into segu_pant
        (pant_codi,
         pant_desc,
         pant_modu,
         pant_clas,
         pant_nomb,
         pant_file,
         pant_para_inic,
         pant_indi_admi,
         pant_tecn,
         pant_nume_app,
         pant_nume_pagi,
         pant_nume,
         pant_file_web,
         pant_imag,
         pant_tool_tips,
         pant_pagi_alia,
         pant_ord,
         pant_base,
         pant_user_regi,
         pant_fech_regi)
      values
        (x_pant_codi,
         v_pant_desc,
         v_pant_modu,
         v_pant_clas,
         v_pant_nomb,
         v_pant_file,
         v_pant_para_inic,
         v_pant_indi_admi,
         v_pant_tecn,
         v_pant_nume_app,
         v_pant_nume_pagi,
         v_pant_nume,
         v_pant_file_web,
         v_pant_imag,
         v_pant_tool_tips,
         v_pant_pagi_alia,
         v_pant_ord,
         v_pant_base,
        fa_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update segu_pant
         set pant_desc      = v_pant_desc,
             pant_modu      = v_pant_modu,
             pant_clas      = v_pant_clas,
             pant_nomb      = v_pant_nomb,
             pant_file      = v_pant_file,
             pant_para_inic = v_pant_para_inic,
             pant_indi_admi = v_pant_indi_admi,
             pant_tecn      = v_pant_tecn,
             pant_nume_app  = v_pant_nume_app,
             pant_nume_pagi = v_pant_nume_pagi,
             pant_nume      = v_pant_nume,
             pant_file_web  = v_pant_file_web,
             pant_imag      = v_pant_imag,
             pant_tool_tips = v_pant_tool_tips,
             pant_pagi_alia = v_pant_pagi_alia,
             pant_ord       = v_pant_ord,
             pant_base      = v_pant_base,
             pant_user_modi = fa_user,
             pant_fech_modi = sysdate
       where pant_codi = v_pant_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_abm_pantallas;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_pant_codi in number) is
  begin
  
    I010012.pp_validar_borrado(v_pant_codi);
    delete segu_pant where pant_codi = v_pant_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_pant_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from segu_user_pant
     where uspa_pant_codi = v_pant_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Usuarios asignados a esta Pantalla. primero debe borrarlos o asignarlos a otro');
    end if;
  
    select count(*)
      into v_count
      from segu_pant_perf
     where pape_pant_codi = v_pant_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'perfiles asignados a esta Pantalla. primero debe borrarlos o asignarlos a otro');
    end if;
  
  end pp_validar_borrado;

end I010012;
