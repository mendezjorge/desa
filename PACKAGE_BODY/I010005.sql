
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010005" is

  procedure pp_abm_unid_medi(v_ind                in varchar2,
                             v_medi_codi          in number,
                             v_medi_empr_codi     in number,
                             v_medi_codi_alte     in number,
                             v_medi_desc          in varchar2,
                             v_medi_desc_abre     in varchar2,
                             v_medi_base          in number,
                             v_medi_user_regi     in varchar2,
                             v_medi_fech_regi     in date,
                             v_medi_cod_ind_sifen in number) is
    x_medi_codi      number;
    x_medi_codi_alte number;
  
  begin
  
    if v_ind = 'I' then
      --Inserci¿n
      select nvl(max(medi_codi), 0) + 1,
             nvl(max(to_number(medi_codi_alte)), 0) + 1
        into x_medi_codi, x_medi_codi_alte
        from come_unid_medi;
      I010005.pp_validar_duplicacion(v_medi_desc_abre);
      insert into come_unid_medi
        (medi_codi,
         medi_empr_codi,
         medi_codi_alte,
         medi_desc,
         medi_desc_abre,
         medi_user_regi,
         medi_fech_regi,
         medi_cod_ind_sifen)
      values
        (x_medi_codi,
         v_medi_empr_codi,
         x_medi_codi_alte,
         v_medi_desc,
         v_medi_desc_abre,
         gen_user,
         sysdate,
         v_medi_cod_ind_sifen);
    
    elsif v_ind = 'U' then
      --Modificacion
      I010005.pp_validar_duplicacion(v_medi_desc_abre);
      update come_unid_medi
         set medi_empr_codi = v_medi_empr_codi,
             medi_codi_alte = v_medi_codi_alte,
             medi_desc      = v_medi_desc,
             medi_desc_abre = v_medi_desc_abre,
             medi_base      = v_medi_base,
             medi_user_modi = gen_user,
             medi_fech_modi = sysdate
       where medi_codi = v_medi_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_unid_medi;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_medi_codi in number) is
  begin
  
    I010005.pp_validar_borrado(v_medi_codi);
    delete come_unid_medi where medi_codi = v_medi_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_medi_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_prod
     where prod_medi_codi = v_medi_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'productos que tienen asignados este registro. primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_duplicacion(v_medi_desc_abre in varchar2) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_unid_medi
     where medi_desc_abre = v_medi_desc_abre;
    if v_count > 0 then
      raise_application_error(-20010,
                              'La descripcion abreviada esta duplicada con otro registro cargado previamente');
    end if;
  
  end pp_validar_duplicacion;

end I010005;
