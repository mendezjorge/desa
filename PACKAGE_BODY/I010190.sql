
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010190" is

  type r_parameter is record(

    p_codi_base           varchar2(60) := pack_repl.fa_devu_codi_base,
    p_clie_prov           varchar2(60) := 'P',
    p_codi_mone_mmnn      varchar2(60) := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_indi_most_mens_sali varchar2(60) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_most_mens_sali'))),
    p_fech_fini           date,--varchar2(60),
    p_fech_inic           date--varchar2(60)
    );

  parameter r_parameter;

  procedure pp_abm_impor(v_ind                       in varchar2,
                         v_impo_codi                 in number,
                         v_impo_nume                 in number,
                         v_impo_deim_codi            in number,
                         v_impo_fech_emis            in date,
                         v_impo_fech_grab            in date,
                         v_impo_clpr_codi            in number,
                         v_impo_obse                 in varchar2,
                         v_impo_form_entr            in varchar2,
                         v_impo_form_pago            in varchar2,
                         v_impo_mone_codi            in number,
                         v_impo_tasa_mone            in number,
                         v_impo_tasa_mmee            in number,
                         v_impo_indi_cost            in varchar2,
                         v_impo_indi_ingr_stoc       in varchar2,
                         v_impo_fech_prev_emba       in date,
                         v_impo_fech_prev_llega_adua in date,
                         v_impo_fech_prev_llega_depo in date,
                         v_impo_fech_conf_pedi       in date,
                         v_impo_fech_conf_emba       in date,
                         v_impo_fech_conf_llega_adua in date,
                         v_impo_fech_conf_llega_depo in date,
                         v_impo_user                 in varchar2,
                         v_impo_dife_camb            in number,
                         v_impo_tasa_fact            in number,
                         v_impo_base                 in number,
                         v_impo_user_regi            in varchar2,
                         v_impo_fech_regi            in date) is
  x_impo_codi number;
  x_impo_nume number;

  begin

    if v_ind = 'I' then
      I010190.pp_valida_fech(p_fech => v_impo_fech_prev_emba);
      I010190.pp_valida_fech(p_fech => v_impo_fech_prev_llega_adua);
      I010190.pp_valida_fech(p_fech => v_impo_fech_prev_llega_depo);
      I010190.pp_valida_fech(p_fech => v_impo_fech_conf_pedi);
      I010190.pp_valida_fech(p_fech => v_impo_fech_conf_emba);
      I010190.pp_valida_fech(p_fech => v_impo_fech_conf_llega_adua);
      I010190.pp_valida_fech(p_fech => v_impo_fech_conf_llega_depo);
      x_impo_codi := fa_sec_come_impo;
      select  nvl(max(impo_nume),0) + 1
      into x_impo_nume
      from come_impo;
      insert into come_impo
        (impo_codi,
         impo_nume,
         impo_deim_codi,
         impo_fech_emis,
         impo_fech_grab,
         impo_clpr_codi,
         impo_obse,
         impo_form_entr,
         impo_form_pago,
         impo_mone_codi,
         impo_tasa_mone,
         impo_tasa_mmee,
         impo_indi_cost,
         impo_indi_ingr_stoc,
         impo_fech_prev_emba,
         impo_fech_prev_llega_adua,
         impo_fech_prev_llega_depo,
         impo_fech_conf_pedi,
         impo_fech_conf_emba,
         impo_fech_conf_llega_adua,
         impo_fech_conf_llega_depo,
         impo_user,
         impo_dife_camb,
         impo_tasa_fact,
         impo_base,
         impo_user_regi,
         impo_fech_regi)
      values
        (x_impo_codi,
         x_impo_nume,
         v_impo_deim_codi,
         v_impo_fech_emis,
         v_impo_fech_grab,
         v_impo_clpr_codi,
         v_impo_obse,
         v_impo_form_entr,
         v_impo_form_pago,
         v_impo_mone_codi,
         v_impo_tasa_mone,
         v_impo_tasa_mmee,
         'N',
         v_impo_indi_ingr_stoc,
         v_impo_fech_prev_emba,
         v_impo_fech_prev_llega_adua,
         v_impo_fech_prev_llega_depo,
         v_impo_fech_conf_pedi,
         v_impo_fech_conf_emba,
         v_impo_fech_conf_llega_adua,
         v_impo_fech_conf_llega_depo,
         v_impo_user,
         v_impo_dife_camb,
         v_impo_tasa_fact,
         v_impo_base,
         gen_user,
         sysdate);

    elsif v_ind = 'U' then

      update come_impo
         set impo_nume                 = v_impo_nume,
             impo_deim_codi            = v_impo_deim_codi,
             impo_fech_emis            = v_impo_fech_emis,
             impo_fech_grab            = v_impo_fech_grab,
             impo_clpr_codi            = v_impo_clpr_codi,
             impo_obse                 = v_impo_obse,
             impo_form_entr            = v_impo_form_entr,
             impo_form_pago            = v_impo_form_pago,
             impo_mone_codi            = v_impo_mone_codi,
             impo_tasa_mone            = v_impo_tasa_mone,
             impo_tasa_mmee            = v_impo_tasa_mmee,
             impo_indi_cost            = v_impo_indi_cost,
             impo_indi_ingr_stoc       = v_impo_indi_ingr_stoc,
             impo_fech_prev_emba       = v_impo_fech_prev_emba,
             impo_fech_prev_llega_adua = v_impo_fech_prev_llega_adua,
             impo_fech_prev_llega_depo = v_impo_fech_prev_llega_depo,
             impo_fech_conf_pedi       = v_impo_fech_conf_pedi,
             impo_fech_conf_emba       = v_impo_fech_conf_emba,
             impo_fech_conf_llega_adua = v_impo_fech_conf_llega_adua,
             impo_fech_conf_llega_depo = v_impo_fech_conf_llega_depo,
             impo_user                 = v_impo_user,
             impo_dife_camb            = v_impo_dife_camb,
             impo_tasa_fact            = v_impo_tasa_fact,
             impo_base                 = v_impo_base,
             impo_user_modi            = gen_user,
             impo_fech_modi            = sysdate
       where impo_codi = v_impo_codi;
    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_abm_impor;

  ------------------------------------------------------------------

  procedure pp_actualizar_registro(i_ind                       in varchar2,
                                   i_impo_codi                 in number,
                                   i_impo_nume                 in number,
                                   i_impo_deim_codi            in number,
                                   i_impo_fech_emis            in date,
                                   i_impo_fech_grab            in date,
                                   i_impo_clpr_codi            in number,
                                   i_impo_obse                 in varchar2,
                                   i_impo_form_entr            in varchar2,
                                   i_impo_form_pago            in varchar2,
                                   i_impo_mone_codi            in number,
                                   i_impo_tasa_mone            in number,
                                   i_impo_tasa_mmee            in number,
                                   i_impo_indi_cost            in varchar2,
                                   i_impo_indi_ingr_stoc       in varchar2,
                                   i_impo_fech_prev_emba       in date,
                                   i_impo_fech_prev_llega_adua in date,
                                   i_impo_fech_prev_llega_depo in date,
                                   i_impo_fech_conf_pedi       in date,
                                   i_impo_fech_conf_emba       in date,
                                   i_impo_fech_conf_llega_adua in date,
                                   i_impo_fech_conf_llega_depo in date,
                                   i_impo_user                 in varchar2,
                                   i_impo_dife_camb            in number,
                                   i_impo_tasa_fact            in number,
                                   i_impo_base                 in number,
                                   i_impo_user_regi            in varchar2,
                                   i_impo_fech_regi            in date) is
    v_impo_base number;
    v_impo_codi number;
  begin

  if i_impo_fech_prev_emba is not null then

  I010190.pp_valida_fech(p_fech => i_impo_fech_prev_emba);

  end if;

    v_impo_base := parameter.p_codi_base;
    if i_ind = 'I' then
      v_impo_codi := fa_sec_come_impo;
    else
      v_impo_codi := i_impo_codi;
      begin
        -- call the procedure
        i010190.pp_actu_tasa_fact(i_impo_codi      => i_impo_codi,
                                  i_impo_tasa_mone => i_impo_tasa_mone,
                                  i_impo_tasa_mmee => i_impo_tasa_mmee);
      end;

    end if;

    if i_ind = 'I' then

      insert into come_impo
        (impo_codi,
         impo_nume,
         impo_deim_codi,
         impo_fech_emis,
         impo_fech_grab,
         impo_clpr_codi,
         impo_obse,
         impo_form_entr,
         impo_form_pago,
         impo_mone_codi,
         impo_tasa_mone,
         impo_tasa_mmee,
         impo_indi_cost,
         impo_indi_ingr_stoc,
         impo_fech_prev_emba,
         impo_fech_prev_llega_adua,
         impo_fech_prev_llega_depo,
         impo_fech_conf_pedi,
         impo_fech_conf_emba,
         impo_fech_conf_llega_adua,
         impo_fech_conf_llega_depo,
         impo_user,
         impo_dife_camb,
         impo_tasa_fact,
         impo_base,
         impo_user_regi,
         impo_fech_regi)
      values
        (i_impo_codi,
         i_impo_nume,
         i_impo_deim_codi,
         i_impo_fech_emis,
         i_impo_fech_grab,
         i_impo_clpr_codi,
         i_impo_obse,
         i_impo_form_entr,
         i_impo_form_pago,
         i_impo_mone_codi,
         i_impo_tasa_mone,
         i_impo_tasa_mmee,
         i_impo_indi_cost,
         i_impo_indi_ingr_stoc,
         i_impo_fech_prev_emba,
         i_impo_fech_prev_llega_adua,
         i_impo_fech_prev_llega_depo,
         i_impo_fech_conf_pedi,
         i_impo_fech_conf_emba,
         i_impo_fech_conf_llega_adua,
         i_impo_fech_conf_llega_depo,
         i_impo_user,
         i_impo_dife_camb,
         i_impo_tasa_fact,
         i_impo_base,
         gen_user,
         sysdate);

    elsif i_ind = 'U' then
      null;
      update come_impo
         set impo_nume                 = i_impo_nume,
             impo_deim_codi            = i_impo_deim_codi,
             impo_fech_emis            = i_impo_fech_emis,
             impo_fech_grab            = i_impo_fech_grab,
             impo_clpr_codi            = i_impo_clpr_codi,
             impo_obse                 = i_impo_obse,
             impo_form_entr            = i_impo_form_entr,
             impo_form_pago            = i_impo_form_pago,
             impo_mone_codi            = i_impo_mone_codi,
             impo_tasa_mone            = i_impo_tasa_mone,
             impo_tasa_mmee            = i_impo_tasa_mmee,
             impo_indi_cost            = i_impo_indi_cost,
             impo_indi_ingr_stoc       = i_impo_indi_ingr_stoc,
             impo_fech_prev_emba       = i_impo_fech_prev_emba,
             impo_fech_prev_llega_adua = i_impo_fech_prev_llega_adua,
             impo_fech_prev_llega_depo = i_impo_fech_prev_llega_depo,
             impo_fech_conf_pedi       = i_impo_fech_conf_pedi,
             impo_fech_conf_emba       = i_impo_fech_conf_emba,
             impo_fech_conf_llega_adua = i_impo_fech_conf_llega_adua,
             impo_fech_conf_llega_depo = i_impo_fech_conf_llega_depo,
             impo_user                 = i_impo_user,
             impo_dife_camb            = i_impo_dife_camb,
             impo_tasa_fact            = i_impo_tasa_fact,
             impo_base                 = i_impo_base,
             impo_user_modi            = gen_user,
             impo_fech_modi            = sysdate
       where impo_codi = v_impo_codi;
    end if;

  end pp_actualizar_registro;

  ------------------------------------------------------------------

  procedure pp_actu_tasa_fact(i_impo_codi      in number,
                              i_impo_tasa_mone in number,
                              i_impo_tasa_mmee in number) is

    cursor c_fact is
      select imfa_tasa_mone_deud, imfa_tasa_mmee_deud, imfa_codi
        from come_impo_fact
       where imfa_impo_codi = i_impo_codi;

  begin
    for x in c_fact loop
      if i_impo_tasa_mone <> x.imfa_tasa_mone_deud or
         i_impo_tasa_mmee <> x.imfa_tasa_mmee_deud then
        update come_impo_fact
           set imfa_tasa_mone_deud = i_impo_tasa_mone,
               imfa_tasa_mmee_deud = i_impo_tasa_mmee
         where imfa_codi = x.imfa_codi;
      end if;

    end loop;
  end pp_actu_tasa_fact;

  ------------------------------------------------------------------

  procedure pp_muestra_come_mone(i_mone_codi      in number,
                                 o_mone_cant_deci out number) is
  begin
    if i_mone_codi<>nvl(parameter.p_codi_mone_mmnn, 1) then
       select mone_cant_deci
      into o_mone_cant_deci
      from come_mone
     where mone_codi = i_mone_codi
       and mone_codi <> nvl(parameter.p_codi_mone_mmnn, 1);
    else
      o_mone_cant_deci:=0;
    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');--ENTRA AQUI
  end;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(i_impo_codi in number) is
  begin

      I010190.pp_validar_borrado(i_impo_codi);
      delete come_impo where impo_codi = i_impo_codi;

  end pp_borrar_registro;

  ------------------------------------------------------------------

  procedure pp_validar_borrado(i_impo_codi in number) is
    v_count number;
  begin

    select count(*)
      into v_count
      from come_impo_fact
     where imfa_impo_codi = i_impo_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'factura/s que tienen asignados importacion/es. primero debes borrarlos o asignarlos a otra');
    end if;

/*    update come_impo
       set impo_base = parameter.p_codi_base
     where impo_codi = i_impo_codi;*/

  end;

  ------------------------------------------------------------------

  procedure pp_mostrar_despacho(i_nume in number,
                                o_codi out number,
                                o_desc out varchar) is
  begin
    select desp_desc, deim_codi
      into o_desc, o_codi
      from come_desp_impo, come_desp
     where deim_desp_codi = desp_codi
       and deim_nume = i_nume;

  exception
    when no_data_found then
      raise_application_error(-20010, ' NO SE ENCONTRO DATOS');
  end;

  ------------------------------------------------------------------

  procedure pp_valida_fech(p_fech in date) is

  begin
   --- raise_application_error(-20001,p_fech);
    pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
    if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
      raise_application_error(-20010,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(parameter.p_fech_inic, 'dd-mm-yyyy') ||
                              ' y ' ||
                              to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
    end if;

  end pp_valida_fech;

end I010190;
