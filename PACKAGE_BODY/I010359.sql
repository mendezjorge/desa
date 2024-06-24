
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010359" is

  procedure pp_abm_medio_pago(v_ind                      in varchar2,
                              v_mepa_codi                in number,
                              v_mepa_empr_codi           in number,
                              v_mepa_codi_alte           in number,
                              v_mepa_desc                in varchar2,
                              v_mepa_base                in number,
                              v_mepa_user_regi           in varchar2,
                              v_mepa_fech_regi           in date,
                              v_mepa_indi_excl_segu_cobr in varchar2,
                              v_mepa_indi_reca_red_cobr  in varchar2) is

    x_mepa_codi      number;
    x_mepa_codi_alte number;

  begin

    if v_ind = 'I' then
      select nvl(max(mepa_codi), 0) + 1,
             nvl(max(to_number(mepa_codi_alte)), 0) + 1
        into x_mepa_codi, x_mepa_codi_alte
        from come_medi_pago;
      insert into come_medi_pago
        (mepa_codi,
         mepa_empr_codi,
         mepa_codi_alte,
         mepa_desc,
         mepa_base,
         mepa_user_regi,
         mepa_fech_regi,
         mepa_indi_excl_segu_cobr,
         mepa_indi_reca_red_cobr)
      values
        (x_mepa_codi,
         v_mepa_empr_codi,
         x_mepa_codi_alte,
         v_mepa_desc,
         v_mepa_base,
         fa_user,
         sysdate,
         v_mepa_indi_excl_segu_cobr,
         v_mepa_indi_reca_red_cobr);

    elsif v_ind = 'U' then

      update come_medi_pago
         set mepa_empr_codi           = v_mepa_empr_codi,
             mepa_codi_alte           = v_mepa_codi_alte,
             mepa_desc                = v_mepa_desc,
             mepa_base                = v_mepa_base,
             mepa_user_modi           = fa_user,
             mepa_fech_modi           = sysdate,
             mepa_indi_excl_segu_cobr = v_mepa_indi_excl_segu_cobr,
             mepa_indi_reca_red_cobr  = v_mepa_indi_reca_red_cobr
       where mepa_codi = v_mepa_codi;

    elsif v_ind = 'D' then

      delete come_medi_pago where mepa_codi = v_mepa_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_medio_pago;
end I010359;
