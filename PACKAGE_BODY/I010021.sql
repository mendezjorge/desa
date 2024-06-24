
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010021" is

  procedure pp_abm_tipo_impu(v_ind                      in varchar2,
                             v_impu_empr_codi           in number,
                             v_impu_codi                in number,
                             v_impu_codi_alte           in number,
                             v_impu_desc                in varchar2,
                             v_impu_porc                in number,
                             v_impu_porc_base_impo      in number,
                             v_impu_indi_baim_impu_incl in varchar2,
                             v_impu_conc_codi_ivdb      in number,
                             v_impu_conc_codi_ivcr      in number,
                             v_impu_conc_codi_ivdb_afac in number,
                             v_impu_conc_codi_ivcr_afac in number,
                             v_impu_cuco_codi           in number,
                             v_impu_base                in number,
                             v_impu_user_regi           in varchar2,
                             v_impu_fech_regi           in date) is
    x_impu_codi      number;
    x_impu_codi_alte number;
  begin
    if v_ind = 'I' then
      select nvl(max(impu_codi), 0) + 1,
             nvl(max(to_number(impu_codi_alte)), 0) + 1
        into x_impu_codi, x_impu_codi_alte
        from come_impu;
      insert into come_impu
        (impu_empr_codi,
         impu_codi,
         impu_codi_alte,
         impu_desc,
         impu_porc,
         impu_porc_base_impo,
         impu_indi_baim_impu_incl,
         impu_conc_codi_ivdb,
         impu_conc_codi_ivcr,
         impu_conc_codi_ivdb_afac,
         impu_conc_codi_ivcr_afac,
         impu_cuco_codi,
         impu_base,
         impu_user_regi,
         impu_fech_regi)
      values
        (v_impu_empr_codi,
         x_impu_codi,
         x_impu_codi_alte,
         v_impu_desc,
         v_impu_porc,
         v_impu_porc_base_impo,
         v_impu_indi_baim_impu_incl,
         v_impu_conc_codi_ivdb,
         v_impu_conc_codi_ivcr,
         v_impu_conc_codi_ivdb_afac,
         v_impu_conc_codi_ivcr_afac,
         v_impu_cuco_codi,
         v_impu_base,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_impu
         set impu_empr_codi           = v_impu_empr_codi,
             impu_codi_alte           = v_impu_codi_alte,
             impu_desc                = v_impu_desc,
             impu_porc                = v_impu_porc,
             impu_porc_base_impo      = v_impu_porc_base_impo,
             impu_indi_baim_impu_incl = v_impu_indi_baim_impu_incl,
             impu_conc_codi_ivdb      = v_impu_conc_codi_ivdb,
             impu_conc_codi_ivcr      = v_impu_conc_codi_ivcr,
             impu_conc_codi_ivdb_afac = v_impu_conc_codi_ivdb_afac,
             impu_conc_codi_ivcr_afac = v_impu_conc_codi_ivcr_afac,
             impu_cuco_codi           = v_impu_cuco_codi,
             impu_base                = v_impu_base,
             impu_user_modi           = gen_user,
             impu_fech_modi           = sysdate
       where impu_codi = v_impu_codi;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_abm_tipo_impu;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_impu_codi in number) is
  begin
  
    I010021.pp_validar_borrado(v_impu_codi);
    delete come_impu where impu_codi = v_impu_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_impu_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_prod
     where prod_impu_codi = v_impu_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'productos que tienen asignados este tipo de impuesto. primero debes borrarlos o asignarlos a otra');
    end if;
  
    select count(*)
      into v_count
      from come_movi_prod_Deta
     where deta_impu_codi = v_impu_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'detalles de movimientos de productos que tienen asignados este tipo de impuesto. primero debes borrarlos o asignarlos a otra');
    end if;
  
    select count(*)
      into v_count
      from come_movi_conc_Deta
     where moco_impu_codi = v_impu_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'detalles de conceptos que tienen asignados este tipo de impuesto. primero debes borrarlos o asignarlos a otra');
    end if;
  
    select count(*)
      into v_count
      from come_movi_impu_Deta
     where moim_impu_codi = v_impu_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'detalles de impuestos que tienen asignados este tipo de impuesto. primero debes borrarlos o asignarlos a otra');
    end if;
  end pp_validar_borrado;

end I010021;
