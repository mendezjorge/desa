
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010022" is

  procedure pp_abm_mone(v_ind                      in varchar2,
                        v_mone_empr_codi           in number,
                        v_mone_codi                in number,
                        v_mone_codi_alte           in number,
                        v_mone_desc                in varchar2,
                        v_mone_desc_abre           in varchar2,
                        v_mone_cant_deci           in number,
                        v_mone_prec_unit_comp      in number,
                        v_mone_prec_unit_vent      in number,
                        v_mone_prec_unit_impo      in number,
                        v_mone_tasa_dife_camb_cuen in number,
                        v_mone_tasa_dife_camb_clie in number,
                        v_mone_tasa_dife_camb_prov in number,
                        v_mone_tasa_dife_camb      in number,
                        v_mone_ind_den_iso_4217    in varchar2,
                        v_mone_base                in number,
                        v_mone_user_regi           in varchar2,
                        v_mone_fech_regi           in date) is
  x_mone_codi_alte number;
  x_mone_codi number;

  begin

    if v_ind = 'I' then
      select  max(nvl(to_number(mone_codi_alte),1))+1, max(nvl(mone_codi,1))+1
	    into x_mone_codi_alte, x_mone_codi
	    from come_mone;
      insert into come_mone
        (mone_empr_codi,
         mone_codi,
         mone_codi_alte,
         mone_desc,
         mone_desc_abre,
         mone_cant_deci,
         mone_cant_deci_prec_unit_comp,
         mone_cant_deci_prec_unit_vent,
         mone_cant_deci_prec_unit_impo,
         mone_tasa_dife_camb_cuen,
         mone_tasa_dife_camb_clie,
         mone_tasa_dife_camb_prov,
         mone_tasa_dife_camb,
         mone_ind_den_iso_4217,
         mone_base,
         mone_user_regi,
         mone_fech_regi)
      values
        (v_mone_empr_codi,
         x_mone_codi,
         x_mone_codi_alte,
         v_mone_desc,
         v_mone_desc_abre,
         v_mone_cant_deci,
         v_mone_prec_unit_comp,
         v_mone_prec_unit_vent,
         v_mone_prec_unit_impo,
         v_mone_tasa_dife_camb_cuen,
         v_mone_tasa_dife_camb_clie,
         v_mone_tasa_dife_camb_prov,
         v_mone_tasa_dife_camb,
         v_mone_ind_den_iso_4217,
         v_mone_base,
         v_mone_user_regi,
         v_mone_fech_regi);

    elsif v_ind = 'U' then

      update come_mone
         set mone_empr_codi                = v_mone_empr_codi,
             mone_codi_alte                = v_mone_codi_alte,
             mone_desc                     = v_mone_desc,
             mone_desc_abre                = v_mone_desc_abre,
             mone_cant_deci                = v_mone_cant_deci,
             mone_cant_deci_prec_unit_comp = v_mone_prec_unit_comp,
             mone_cant_deci_prec_unit_vent = v_mone_prec_unit_vent,
             mone_cant_deci_prec_unit_impo = v_mone_prec_unit_impo,
             mone_tasa_dife_camb_cuen      = v_mone_tasa_dife_camb_cuen,
             mone_tasa_dife_camb_clie      = v_mone_tasa_dife_camb_clie,
             mone_tasa_dife_camb_prov      = v_mone_tasa_dife_camb_prov,
             mone_tasa_dife_camb           = v_mone_tasa_dife_camb,
             mone_ind_den_iso_4217         = v_mone_ind_den_iso_4217,
             mone_base                     = v_mone_base,
             mone_user_modi                = gen_user,
             mone_fech_modi                = sysdate
       where mone_codi = v_mone_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_mone;

  ---------------------------------------------------------------------------------------------------

  procedure pp_borrar_registro(v_mone_codi in number) is

  begin

    I010022.pp_validar_borrado(v_mone_codi);

    if v_mone_codi is null then
      raise_application_error(-20001,
                              'Primero debe seleccionar un registro');
    else
      delete come_mone where mone_codi = v_mone_codi;
    end if;

  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------------------

  procedure pp_validar_borrado(v_mone_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_movi
     where movi_mone_codi = v_mone_codi;

    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'movimientos que tienen asignados esta moneda. primero debes borrarlos o asignarlos a otra');
    end if;

  end pp_validar_borrado;

end I010022;
