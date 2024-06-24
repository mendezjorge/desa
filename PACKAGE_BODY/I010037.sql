
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010037" is

  procedure pp_abm_list_prec(v_ind                 in varchar2,
                             v_list_empr_codi      in number,
                             v_list_codi           in number,
                             v_list_codi_alte      in number,
                             v_list_desc           in varchar2,
                             v_list_desc_abre      in varchar2,
                             v_list_esta           in varchar2,
                             v_list_codi_padr      in number,
                             v_list_mone_codi      in number,
                             v_list_porc_reca      in varchar2,
                             v_list_tipo_actu      in varchar2,
                             v_list_iva_incl       in varchar2,
                             v_list_redo           in number,
                             v_list_indi_form_pago in varchar2,
                             v_list_base           in number,
                             v_list_user_regi      in varchar2,
                             v_list_fech_regi      in date) is

  x_list_codi number;
  x_list_codi_alte number;

  begin

    if v_list_codi_padr = v_list_codi then
      raise_application_error(-20010,
                              'La lista padre no puede ser igual a la lista hija');
    end if;

    if v_ind = 'I' then
      select  nvl(max(list_codi),0)+1, nvl(max(to_number(list_codi_alte)),0)+1
      into x_list_codi, x_list_codi_alte
      from come_list_prec;
      insert into come_list_prec
        (list_empr_codi,
         list_codi,
         list_codi_alte,
         list_desc,
         list_desc_abre,
         list_esta,
         list_codi_padr,
         list_mone_codi,
         list_porc_reca,
         list_tipo_actu,
         list_iva_incl,
         list_redo,
         list_indi_apli_redo_form_pago,
         list_base,
         list_user_regi,
         list_fech_regi)
      values
        (v_list_empr_codi,
         x_list_codi,
         x_list_codi_alte,
         v_list_desc,
         v_list_desc_abre,
         v_list_esta,
         v_list_codi_padr,
         v_list_mone_codi,
         v_list_porc_reca,
         v_list_tipo_actu,
         v_list_iva_incl,
         v_list_redo,
         v_list_indi_form_pago,
         v_list_base,
         v_list_user_regi,
         v_list_fech_regi);

    elsif v_ind = 'U' then

      update come_list_prec
         set list_empr_codi                = v_list_empr_codi,
             list_codi_alte                = v_list_codi_alte,
             list_desc                     = v_list_desc,
             list_desc_abre                = v_list_desc_abre,
             list_esta                     = v_list_esta,
             list_codi_padr                = v_list_codi_padr,
             list_mone_codi                = v_list_mone_codi,
             list_porc_reca                = v_list_porc_reca,
             list_tipo_actu                = v_list_tipo_actu,
             list_iva_incl                 = v_list_iva_incl,
             list_redo                     = v_list_redo,
             list_indi_apli_redo_form_pago = v_list_indi_form_pago,
             list_base                     = v_list_base,
             list_user_modi                = gen_user,
             list_fech_modi                = sysdate
       where list_codi = v_list_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_list_prec;

  ---------------------------------------------------------------------------------------------------

  procedure pp_borrar_registro(v_list_codi in number) is

  begin

    I010037.pp_validar_borrado(v_list_codi);

    if v_list_codi is null then
      raise_application_error(-20001,
                              'Primero debe seleccionar un registro');
    else
      delete come_list_prec where list_codi = v_list_codi;
    end if;

  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------------------

  procedure pp_validar_borrado(v_list_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_list_prec_deta
     where lide_list_codi = v_list_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Productos que tienen asignados este registro. Primero debes borrarlos o asignarlos a otra');
    end if;

    select count(*)
      into v_count
      from come_movi_prod_deta
     where deta_list_codi = v_list_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Detalles de Mov.  que tienen asignados este registro. Primero debes borrarlos o asignarlos a otra');
    end if;

  end pp_validar_borrado;

end I010037;
