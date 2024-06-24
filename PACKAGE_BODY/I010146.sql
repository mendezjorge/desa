
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010146" is

  procedure pp_abm_rrhh_conceptos(v_ind                    in varchar2,
                                  v_conc_empr_codi         in number,
                                  v_conc_codi              in number,
                                  v_conc_codi_alte         in number,
                                  v_conc_desc              in varchar2,
                                  v_conc_indi_auto         in varchar2,
                                  v_conc_dbcr              in varchar2,
                                  v_conc_indi_caja         in varchar2,
                                  v_conc_come_codi         in number,
                                  v_conc_cuco_codi         in number,
                                  v_conc_grco_codi         in number,
                                  v_conc_unit_medi         in varchar2,
                                  v_conc_indi_cant         in varchar2,
                                  v_conc_indi_ips          in varchar2,
                                  v_conc_indi_cuot         in varchar2,
                                  v_conc_indi_agui         in varchar2,
                                  v_conc_indi_adel_suel    in varchar2,
                                  v_conc_tipo_conc         in varchar2,
                                  v_conc_indi_iva          in varchar2,
                                  v_conc_orde_liqu         in number,
                                  v_conc_clas_codi         in number,
                                  v_conc_indi_tipo_pre_avi in varchar2,
                                  v_conc_text_conc_banc    in varchar2,
                                  v_conc_divi              in number,
                                  v_conc_porc              in number,
                                  v_conc_base_calc         in varchar2,
                                  v_conc_base              in number,
                                  v_conc_user_regi         in varchar2,
                                  v_conc_fech_regi         in date) is
    x_conc_codi      number;
    x_conc_codi_alte number;
  begin
  
    if v_conc_indi_caja = 'S' and v_conc_come_codi is null then
      raise_application_error(-20010, 'Debe ingresar el tipo de pago');
    end if;
    if v_ind = 'I' then
      select nvl(max(conc_codi), 0) + 1, nvl(max(conc_codi_alte), 0) + 1
        into x_conc_codi, x_conc_codi_alte
        from rrhh_conc;
      insert into rrhh_conc
        (conc_empr_codi,
         conc_codi,
         conc_codi_alte,
         conc_desc,
         conc_indi_auto,
         conc_dbcr,
         conc_indi_caja,
         conc_come_codi,
         conc_cuco_codi,
         conc_grco_codi,
         conc_unit_medi,
         conc_indi_cant,
         conc_indi_ips,
         conc_indi_cuot,
         conc_indi_agui,
         conc_indi_adel_suel,
         conc_tipo_conc,
         conc_indi_iva,
         conc_orde_liqu,
         conc_clas_codi,
         conc_indi_tipo_pre_avis_egre,
         conc_text_conc_banc,
         conc_divi,
         conc_porc,
         conc_base_calc,
         conc_base,
         conc_user_regi,
         conc_fech_regi)
      values
        (v_conc_empr_codi,
         x_conc_codi,
         x_conc_codi_alte,
         v_conc_desc,
         v_conc_indi_auto,
         v_conc_dbcr,
         v_conc_indi_caja,
         v_conc_come_codi,
         v_conc_cuco_codi,
         v_conc_grco_codi,
         v_conc_unit_medi,
         v_conc_indi_cant,
         v_conc_indi_ips,
         v_conc_indi_cuot,
         v_conc_indi_agui,
         v_conc_indi_adel_suel,
         v_conc_tipo_conc,
         v_conc_indi_iva,
         v_conc_orde_liqu,
         v_conc_clas_codi,
         v_conc_indi_tipo_pre_avi,
         v_conc_text_conc_banc,
         v_conc_divi,
         v_conc_porc,
         v_conc_base_calc,
         v_conc_base,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update rrhh_conc
         set conc_empr_codi               = v_conc_empr_codi,
             conc_codi_alte               = v_conc_codi_alte,
             conc_desc                    = v_conc_desc,
             conc_indi_auto               = v_conc_indi_auto,
             conc_dbcr                    = v_conc_dbcr,
             conc_indi_caja               = v_conc_indi_caja,
             conc_come_codi               = v_conc_come_codi,
             conc_cuco_codi               = v_conc_cuco_codi,
             conc_grco_codi               = v_conc_grco_codi,
             conc_unit_medi               = v_conc_unit_medi,
             conc_indi_cant               = v_conc_indi_cant,
             conc_indi_ips                = v_conc_indi_ips,
             conc_indi_cuot               = v_conc_indi_cuot,
             conc_indi_agui               = v_conc_indi_agui,
             conc_indi_adel_suel          = v_conc_indi_adel_suel,
             conc_tipo_conc               = v_conc_tipo_conc,
             conc_indi_iva                = v_conc_indi_iva,
             conc_orde_liqu               = v_conc_orde_liqu,
             conc_clas_codi               = v_conc_clas_codi,
             conc_indi_tipo_pre_avis_egre = v_conc_indi_tipo_pre_avi,
             conc_text_conc_banc          = v_conc_text_conc_banc,
             conc_divi                    = v_conc_divi,
             conc_porc                    = v_conc_porc,
             conc_base_calc               = v_conc_base_calc,
             conc_base                    = v_conc_base,
             conc_user_modi               = gen_user,
             conc_fech_modi               = sysdate
       where conc_codi = v_conc_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_abm_rrhh_conceptos;

  -------------------------------------------------------------------------------------------

  procedure pp_borrar_registro(v_conc_codi in number) is
  begin
  
    i010007.pp_validar_borrado(v_conc_codi);
  
    delete rrhh_conc where conc_codi = v_conc_codi;
  
  end pp_borrar_registro;

  -------------------------------------------------------------------------------------------

  procedure pp_validar_borrado(v_conc_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from rrhh_movi
     where movi_conc_codi = v_conc_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'movimientos asignados a este tipo de conceptos. primero debe borrarlos o asignarlos a otro');
    end if;
  
  end pp_validar_borrado;

end i010146;
