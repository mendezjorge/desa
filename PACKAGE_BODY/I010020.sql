
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010020" is

  procedure pp_abm_conceptos(v_ind                      in varchar2,
                             v_conc_empr_codi           in number,
                             v_conc_codi                in number,
                             v_conc_codi_alte           in number,
                             v_conc_desc                in varchar2,
                             v_conc_desc_exte           in varchar2,
                             v_conc_dbcr                in varchar2,
                             v_conc_cuco_codi           in number,
                             v_conc_sucu_codi           in number,
                             v_conc_grup_codi           in number,
                             v_conc_indi_kilo_vehi      in varchar2,
                             v_conc_indi_cost_fijo_vari in varchar2,
                             v_conc_impu_codi           in number,
                             v_conc_indi_anex_requ_vehi in varchar2,
                             v_conc_indi_cost_dire      in varchar2,
                             v_conc_indi_ortr           in varchar2,
                             v_conc_indi_gast_vent      in varchar2,
                             v_conc_indi_inac           in varchar2,
                             v_conc_indi_gast_logi      in varchar2,
                             v_conc_indi_impo           in varchar2,
                             v_conc_indi_gast_judi      in varchar2,
                             v_conc_indi_fact           in varchar2,
                             v_conc_indi_acti_fijo      in varchar2,
                             v_conc_indi_cent_cost      in varchar2,
                             v_conc_indi_anex_deta      in varchar2,
                             v_conc_indi_coib           in varchar2,
                             v_conc_indi_anex_vehi      in varchar2,
                             v_conc_indi_anex_requ_fech in varchar2,
                             v_conc_indi_anex_modu      in varchar2,
                             v_conc_indi_anex_sele_modu in varchar2,
                             v_conc_indi_sose_tipo_inst in varchar2,
                             v_conc_indi_sose_tipo_rpy  in varchar2,
                             v_conc_indi_sose_tipo_rpse in varchar2,
                             v_conc_indi_sose_tipo_segu in varchar2,
                             v_conc_indi_sose_tipo_titu in varchar2,
                             v_conc_indi_sose_tipo_reno in varchar2,
                             v_conc_indi_sose_tipo_rein in varchar2,
                             v_conc_indi_sose_tipo_fact in varchar2,
                             v_conc_base                in number,
                             v_conc_user_regi           in varchar2,
                             v_conc_fech_regi           in date) is
  
  x_conc_codi number;
  x_conc_codi_alte number;
  
  begin
  
    if v_ind = 'I' then
      select  nvl(max(conc_codi),0) + 1, nvl(max(to_number(conc_codi_alte)),0) + 1
      into x_conc_codi, x_conc_codi_alte
      from come_conc;
      insert into come_conc
        (conc_empr_codi,
         conc_codi,
         conc_codi_alte,
         conc_desc,
         conc_desc_exte,
         conc_dbcr,
         conc_cuco_codi,
         conc_sucu_codi,
         conc_grup_codi,
         conc_indi_kilo_vehi,
         conc_indi_cost_fijo_vari,
         conc_impu_codi,
         conc_indi_anex_requ_vehi,
         conc_indi_cost_dire,
         conc_indi_ortr,
         conc_indi_gast_vent,
         conc_indi_inac,
         conc_indi_gast_logi,
         conc_indi_impo,
         conc_indi_gast_judi,
         conc_indi_fact,
         conc_indi_acti_fijo,
         conc_indi_cent_cost,
         conc_indi_anex_deta,
         conc_indi_coib,
         conc_indi_anex_vehi,
         conc_indi_anex_requ_fech,
         conc_indi_anex_modu,
         conc_indi_anex_sele_modu,
         conc_indi_sose_tipo_inst,
         conc_indi_sose_tipo_rpy,
         conc_indi_sose_tipo_rpse,
         conc_indi_sose_tipo_segu,
         conc_indi_sose_tipo_titu,
         conc_indi_sose_tipo_reno,
         conc_indi_sose_tipo_rein,
         conc_indi_sose_tipo_fact,
         conc_base,
         conc_user_regi,
         conc_fech_regi)
      values
        (v_conc_empr_codi,
         x_conc_codi,
         x_conc_codi_alte,
         v_conc_desc,
         v_conc_desc_exte,
         v_conc_dbcr,
         v_conc_cuco_codi,
         v_conc_sucu_codi,
         v_conc_grup_codi,
         v_conc_indi_kilo_vehi,
         v_conc_indi_cost_fijo_vari,
         v_conc_impu_codi,
         v_conc_indi_anex_requ_vehi,
         v_conc_indi_cost_dire,
         v_conc_indi_ortr,
         v_conc_indi_gast_vent,
         v_conc_indi_inac,
         v_conc_indi_gast_logi,
         v_conc_indi_impo,
         v_conc_indi_gast_judi,
         v_conc_indi_fact,
         v_conc_indi_acti_fijo,
         v_conc_indi_cent_cost,
         v_conc_indi_anex_deta,
         v_conc_indi_coib,
         v_conc_indi_anex_vehi,
         v_conc_indi_anex_requ_fech,
         v_conc_indi_anex_modu,
         v_conc_indi_anex_sele_modu,
         v_conc_indi_sose_tipo_inst,
         v_conc_indi_sose_tipo_rpy,
         v_conc_indi_sose_tipo_rpse,
         v_conc_indi_sose_tipo_segu,
         v_conc_indi_sose_tipo_titu,
         v_conc_indi_sose_tipo_reno,
         v_conc_indi_sose_tipo_rein,
         v_conc_indi_sose_tipo_fact,
         v_conc_base,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_conc
         set conc_empr_codi           = v_conc_empr_codi,
             conc_codi                = v_conc_codi,
             conc_codi_alte           = v_conc_codi_alte,
             conc_desc                = v_conc_desc,
             conc_desc_exte           = v_conc_desc_exte,
             conc_dbcr                = v_conc_dbcr,
             conc_cuco_codi           = v_conc_cuco_codi,
             conc_sucu_codi           = v_conc_sucu_codi,
             conc_grup_codi           = v_conc_grup_codi,
             conc_indi_kilo_vehi      = v_conc_indi_kilo_vehi,
             conc_indi_cost_fijo_vari = v_conc_indi_cost_fijo_vari,
             conc_impu_codi           = v_conc_impu_codi,
             conc_indi_anex_requ_vehi = v_conc_indi_anex_requ_vehi,
             conc_indi_cost_dire      = v_conc_indi_cost_dire,
             conc_indi_ortr           = v_conc_indi_ortr,
             conc_indi_gast_vent      = v_conc_indi_gast_vent,
             conc_indi_inac           = v_conc_indi_inac,
             conc_indi_gast_logi      = v_conc_indi_gast_logi,
             conc_indi_impo           = v_conc_indi_impo,
             conc_indi_gast_judi      = v_conc_indi_gast_judi,
             conc_indi_fact           = v_conc_indi_fact,
             conc_indi_acti_fijo      = v_conc_indi_acti_fijo,
             conc_indi_cent_cost      = v_conc_indi_cent_cost,
             conc_indi_anex_deta      = v_conc_indi_anex_deta,
             conc_indi_coib           = v_conc_indi_coib,
             conc_indi_anex_vehi      = v_conc_indi_anex_vehi,
             conc_indi_anex_requ_fech = v_conc_indi_anex_requ_fech,
             conc_indi_anex_modu      = v_conc_indi_anex_modu,
             conc_indi_anex_sele_modu = v_conc_indi_anex_sele_modu,
             conc_indi_sose_tipo_inst = v_conc_indi_sose_tipo_inst,
             conc_indi_sose_tipo_rpy  = v_conc_indi_sose_tipo_rpy,
             conc_indi_sose_tipo_rpse = v_conc_indi_sose_tipo_rpse,
             conc_indi_sose_tipo_segu = v_conc_indi_sose_tipo_segu,
             conc_indi_sose_tipo_titu = v_conc_indi_sose_tipo_titu,
             conc_indi_sose_tipo_reno = v_conc_indi_sose_tipo_reno,
             conc_indi_sose_tipo_rein = v_conc_indi_sose_tipo_rein,
             conc_indi_sose_tipo_fact = v_conc_indi_sose_tipo_fact,
             conc_base                = v_conc_base,
             conc_user_modi           = gen_user,
             conc_fech_modi           = sysdate
       where conc_codi = v_conc_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_abm_conceptos;

  -------------------------------------------------------------------------------------------  

  procedure pp_borrar_registro(i_conc_codi in number) is
  begin
  
    i010020.pp_validar_borrado(i_conc_codi);
    
    delete come_conc where conc_codi = i_conc_codi;
  
  end;

  -------------------------------------------------------------------------------------------

  procedure pp_validar_borrado(p_conc_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_movi_conc_deta
     where moco_conc_codi = p_conc_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existe/n' || '  ' || v_count || ' ' ||
                              'Registro/s en Clasificacion de prod. por concepto,  asignado/s a este concepto. primero debe borrarlos o asignarlos a otro');
    end if;
  
  end pp_validar_borrado;

end I010020;
