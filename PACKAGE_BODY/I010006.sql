
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010006" is
  procedure pp_abm_sucursales(v_ind                      in varchar2,
                              v_sucu_empr_codi           in number,
                              v_sucu_codi                in number,
                              v_sucu_codi_alte           in number,
                              v_sucu_desc                in varchar2,
                              v_sucu_desc_abre           in varchar2,
                              v_sucu_base                in number,
                              v_sucu_dire                in varchar2,
                              v_sucu_localidad           in varchar2,
                              v_sucu_telefono            in varchar2,
                              v_sucu_ceco_codi           in number,
                              v_sucu_regi_patr           in varchar2,
                              v_sucu_porc_rete           in number,
                              v_sucu_form_impr_fact      in number,
                              v_sucu_form_impr_cred      in number,
                              v_sucu_form_impr_remi      in number,
                              v_sucu_indi_perm_exis_nega in varchar2,
                              v_sucu_maxi_cant_item_fact in number,
                              v_sucu_user_regi           in varchar2,
                              v_sucu_fech_regi           in date) is
  x_sucu_codi number;
  x_sucu_codi_alte number;
  begin
  
    if v_ind = 'I' then
      select nvl(max(sucu_codi),0)+1, nvl(max(to_number(sucu_codi_alte)),0)+1
	    into x_sucu_codi,x_sucu_codi_alte
	    from come_sucu
	    where sucu_empr_codi = v_sucu_empr_codi;
      insert into come_sucu
        (sucu_empr_codi,
         sucu_codi,
         sucu_codi_alte,
         sucu_desc,
         sucu_desc_abre,
         sucu_base,
         sucu_dire,
         sucu_localidad,
         sucu_telefono,
         sucu_ceco_codi,
         sucu_regi_patr,
         sucu_porc_rete,
         sucu_form_impr_fact,
         sucu_form_impr_cred,
         sucu_form_impr_remi,
         sucu_indi_perm_exis_nega,
         sucu_maxi_cant_item_fact,
         sucu_user_regi,
         sucu_fech_regi)
      values
        (v_sucu_empr_codi,
         x_sucu_codi,
         x_sucu_codi_alte,
         v_sucu_desc,
         v_sucu_desc_abre,
         v_sucu_base,
         v_sucu_dire,
         v_sucu_localidad,
         v_sucu_telefono,
         v_sucu_ceco_codi,
         v_sucu_regi_patr,
         v_sucu_porc_rete,
         v_sucu_form_impr_fact,
         v_sucu_form_impr_cred,
         v_sucu_form_impr_remi,
         v_sucu_indi_perm_exis_nega,
         v_sucu_maxi_cant_item_fact,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_sucu
         set sucu_empr_codi           = v_sucu_empr_codi,
             sucu_codi_alte           = v_sucu_codi_alte,
             sucu_desc                = v_sucu_desc,
             sucu_desc_abre           = v_sucu_desc_abre,
             sucu_base                = v_sucu_base,
             sucu_dire                = v_sucu_dire,
             sucu_localidad           = v_sucu_localidad,
             sucu_telefono            = v_sucu_telefono,
             sucu_ceco_codi           = v_sucu_ceco_codi,
             sucu_regi_patr           = v_sucu_regi_patr,
             sucu_porc_rete           = v_sucu_porc_rete,
             sucu_form_impr_fact      = v_sucu_form_impr_fact,
             sucu_form_impr_cred      = v_sucu_form_impr_cred,
             sucu_form_impr_remi      = v_sucu_form_impr_remi,
             sucu_indi_perm_exis_nega = v_sucu_indi_perm_exis_nega,
             sucu_maxi_cant_item_fact = v_sucu_maxi_cant_item_fact,
             sucu_user_modi           = gen_user,
             sucu_fech_modi           = sysdate
       where sucu_codi = v_sucu_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_abm_sucursales;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_sucu_codi in number) is
  begin
  
    I010006.pp_validar_borrado(v_sucu_codi);
    delete come_sucu where sucu_codi = v_sucu_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_sucu_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_movi
     where movi_sucu_codi_orig = v_sucu_codi
        or movi_sucu_codi_dest = v_sucu_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'movimientos que tienen asignados esta sucursal. Primero debes borrarlos o asignarlos a otra');
    end if;
  
    select count(*)
      into v_count
      from come_depo
     where depo_sucu_codi = v_sucu_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existe/n' || '  ' || v_count || ' ' ||
                              'deposito/s que tienen asignado/s a esta sucursal. Primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;

end I010006;
