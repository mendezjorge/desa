
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010395" is

  procedure pp_abm_buzo_vent(v_ind                 in varchar2,
                             v_cont_empr_codi      in number,
                             v_cont_codi           in number,
                             v_cont_codi_alte      in number,
                             v_cont_desc           in varchar2,
                             v_cont_indi_veri_buzo in varchar2,
                             v_cont_excl_segu      in varchar2,
                             v_cont_indi_veri_llam in varchar2,
                             v_cont_indi_prom_pago in varchar2,
                             v_cont_tipo           in varchar2,
                             v_cont_indi_refe      in varchar2,
                             v_cont_orden          in varchar2,
                             v_cont_indi_llam      in varchar2,
                             v_cont_indi_plac      in varchar2,
                             v_cont_indi_visi      in varchar2,
                             v_cont_base           in number,
                             v_cont_user_regi      in varchar2,
                             v_cont_fech_regi      in date) is
    x_cont_codi      number;
    x_cont_codi_alte number;
  begin

    if v_ind = 'I' then
      select nvl(max(cont_codi), 0) + 1, nvl(max(cont_codi_alte), 0) + 1
        into x_cont_codi, x_cont_codi_alte
        from come_tipo_cont;
      insert into come_tipo_cont
        (cont_empr_codi,
         cont_codi,
         cont_codi_alte,
         cont_desc,
         cont_indi_veri_buzo,
         cont_excl_segu,
         cont_indi_veri_llam,
         cont_indi_prom_pago,
         cont_tipo,
         cont_indi_refe,
         cont_orden,
         cont_indi_llam,
         cont_indi_plac,
         cont_indi_visi,
         cont_base,
         cont_user_regi,
         cont_fech_regi)
      values
        (v_cont_empr_codi,
         x_cont_codi,
         x_cont_codi_alte,
         v_cont_desc,
         v_cont_indi_veri_buzo,
         v_cont_excl_segu,
         v_cont_indi_veri_llam,
         v_cont_indi_prom_pago,
         v_cont_tipo,
         v_cont_indi_refe,
         v_cont_orden,
         v_cont_indi_llam,
         v_cont_indi_plac,
         v_cont_indi_visi,
         v_cont_base,
         gen_user,
         sysdate);

    elsif v_ind = 'U' then

      update come_tipo_cont
         set cont_empr_codi      = v_cont_empr_codi,
             cont_codi_alte      = v_cont_codi_alte,
             cont_desc           = v_cont_desc,
             cont_indi_veri_buzo = v_cont_indi_veri_buzo,
             cont_excl_segu      = v_cont_excl_segu,
             cont_indi_veri_llam = v_cont_indi_veri_llam,
             cont_indi_prom_pago = v_cont_indi_prom_pago,
             cont_tipo           = v_cont_tipo,
             cont_indi_refe      = v_cont_indi_refe,
             cont_orden          = v_cont_orden,
             cont_indi_llam      = v_cont_indi_llam,
             cont_indi_plac      = v_cont_indi_plac,
             cont_indi_visi      = v_cont_indi_visi,
             cont_base           = v_cont_base,
             cont_user_modi      = gen_user,
             cont_fech_modi      = sysdate
       where cont_codi = v_cont_codi;
    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_buzo_vent;

  -----------------------------------------------------------------------------------------

  procedure pp_borrar_registro(v_cont_codi in number) is

  begin

    i010395.pp_validar_borrado(v_cont_codi);

    delete come_tipo_cont where cont_codi = v_cont_codi;

  end pp_borrar_registro;

  -----------------------------------------------------------------------------------------

  procedure pp_validar_borrado(v_cont_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_clie_llam_cobr
     where llam_cont_codi = v_cont_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen ' || v_count ||
                              ' buzones de cobranza que tienen asignados este tipo de contacto. ' ||
                              'Primero se deben borrar o asignar a otro');
    end if;

  end pp_validar_borrado;

end i010395;
