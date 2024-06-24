
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010233" is

  procedure pp_abm_tipo_ortr(v_ind                 in varchar2,
                             v_tiot_empr_codi      in number,
                             v_tiot_codi           in number,
                             v_tiot_codi_alte      in number,
                             v_tiot_desc           in varchar2,
                             v_tiot_porc_reca_maob in number,
                             v_tiot_porc_reca_mate in number,
                             v_tiot_porc_reca_kive in number,
                             v_tiot_porc_reca_gava in number,
                             v_tiot_porc_reca_gadi in number,
                             v_tiot_indi_gast_elec in varchar2,
                             v_tiot_user_regi      in varchar2,
                             v_tiot_fech_regi      in date) is
    x_tiot_codi      number;
    x_tiot_codi_alte number;
  begin
    if v_ind = 'I' then
      select nvl(max(tiot_codi), 0) + 1, nvl(max(tiot_codi_alte), 0) + 1
        into x_tiot_codi, x_tiot_codi_alte
        from come_ortr_tipo;
      insert into come_ortr_tipo
        (tiot_empr_codi,
         tiot_codi,
         tiot_codi_alte,
         tiot_desc,
         tiot_porc_reca_maob,
         tiot_porc_reca_mate,
         tiot_porc_reca_kive,
         tiot_porc_reca_gava,
         tiot_porc_reca_gadi,
         tiot_indi_gast_elec,
         tiot_user_regi,
         tiot_fech_regi)
      values
        (v_tiot_empr_codi,
         x_tiot_codi,
         x_tiot_codi_alte,
         v_tiot_desc,
         v_tiot_porc_reca_maob,
         v_tiot_porc_reca_mate,
         v_tiot_porc_reca_kive,
         v_tiot_porc_reca_gava,
         v_tiot_porc_reca_gadi,
         v_tiot_indi_gast_elec,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_ortr_tipo
         set tiot_empr_codi      = v_tiot_empr_codi,
             tiot_codi_alte      = v_tiot_codi_alte,
             tiot_desc           = v_tiot_desc,
             tiot_porc_reca_maob = v_tiot_porc_reca_maob,
             tiot_porc_reca_mate = v_tiot_porc_reca_mate,
             tiot_porc_reca_kive = v_tiot_porc_reca_kive,
             tiot_porc_reca_gava = v_tiot_porc_reca_gava,
             tiot_porc_reca_gadi = v_tiot_porc_reca_gadi,
             tiot_indi_gast_elec = v_tiot_indi_gast_elec,
             tiot_user_modi      = gen_user,
             tiot_fech_modi      = sysdate
       where tiot_codi = v_tiot_codi;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_abm_tipo_ortr;

  -------------------------------------------------------------------------------------

  procedure pp_borrar_registro(v_tiot_codi in number) is
  
  begin
  
    i010233.pp_validar_borrado(v_tiot_codi);
  
    delete come_ortr_tipo where tiot_codi = v_tiot_codi;
  
  end;

  -------------------------------------------------------------------------------------

  procedure pp_validar_borrado(v_tiot_codi in number) is
    v_count number(6);
  begin
  
    select count(*)
      into v_count
      from come_orde_trab
     where ortr_tiot_codi = v_tiot_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'tipos de movimientos que tienen asignados a esta orden de trabajo. Primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;

end i010233;
