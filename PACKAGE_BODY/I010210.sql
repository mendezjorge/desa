
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010210" is

  procedure pp_abm_form_pago(v_ind                 in varchar2,
                             v_orte_empr_codi      in number,
                             v_orte_codi           in number,
                             v_orte_codi_alte      in number,
                             v_orte_desc           in varchar2,
                             v_orte_punt           in varchar2,
                             v_orte_cali           in number,
                             v_orte_maxi_porc      in varchar2,
                             v_orte_porc_comi_vent in varchar2,
                             v_orte_dias_cuot      in varchar2,
                             v_orte_porc_entr      in varchar2,
                             v_orte_cant_cuot      in varchar2,
                             v_orte_list_codi      in number,
                             v_orte_impo_cuot      in varchar2,
                             v_orte_indi_most_fopa in varchar2,
                             v_orte_indi_impr_paga in varchar2,
                             v_orte_base           in number,
                             v_orte_user_regi      in varchar2,
                             v_orte_fech_regi      in date) is
    x_orte_codi_alte number;
    x_orte_codi      number;
  begin
    if v_ind = 'I' then
      if v_orte_desc is null then
        raise_application_error(-20010,'La descripcion no puede ser nula');
      end if;
      select nvl(max(to_number(orte_codi_alte)), 0) + 1,
             nvl(max(orte_codi), 0) + 1
        into x_orte_codi_alte, x_orte_codi
        from come_orde_term;
      insert into come_orde_term
        (orte_empr_codi,
         orte_codi,
         orte_codi_alte,
         orte_desc,
         orte_punt,
         orte_cali,
         orte_maxi_porc,
         orte_porc_comi_vent,
         orte_dias_cuot,
         orte_porc_entr,
         orte_cant_cuot,
         orte_list_codi,
         orte_impo_cuot,
         orte_indi_most_fopa,
         orte_indi_impr_paga,
         orte_base,
         orte_user_regi,
         orte_fech_regi)
      values
        (v_orte_empr_codi,
         x_orte_codi,
         x_orte_codi_alte,
         v_orte_desc,
         v_orte_punt,
         v_orte_cali,
         v_orte_maxi_porc,
         v_orte_porc_comi_vent,
         v_orte_dias_cuot,
         v_orte_porc_entr,
         v_orte_cant_cuot,
         v_orte_list_codi,
         v_orte_impo_cuot,
         v_orte_indi_most_fopa,
         v_orte_indi_impr_paga,
         v_orte_base,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
      if v_orte_desc is null then
        raise_application_error(-20010,'La descripcion no puede ser nula');
      end if;
      update come_orde_term
         set orte_empr_codi      = v_orte_empr_codi,
             orte_codi_alte      = v_orte_codi_alte,
             orte_desc           = v_orte_desc,
             orte_punt           = v_orte_punt,
             orte_cali           = v_orte_cali,
             orte_maxi_porc      = v_orte_maxi_porc,
             orte_porc_comi_vent = v_orte_porc_comi_vent,
             orte_dias_cuot      = v_orte_dias_cuot,
             orte_porc_entr      = v_orte_porc_entr,
             orte_cant_cuot      = v_orte_cant_cuot,
             orte_list_codi      = v_orte_list_codi,
             orte_impo_cuot      = v_orte_impo_cuot,
             orte_indi_most_fopa = v_orte_indi_most_fopa,
             orte_indi_impr_paga = v_orte_indi_impr_paga,
             orte_base           = v_orte_base,
             orte_user_modi      = gen_user,
             orte_fech_modi      = sysdate
       where orte_codi = v_orte_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    /*when others then
      raise_application_error(-20010, sqlerrm);*/
  end pp_abm_form_pago;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_orte_codi in number) is
  begin
  
    i010210.pp_validar_borrado(v_orte_codi);
    delete come_orde_term where orte_codi = v_orte_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_orte_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_orde_pedi
     where orpe_orte_codi = v_orte_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'orden de pedidos que tienen asignados este registro. Primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;

end i010210;
