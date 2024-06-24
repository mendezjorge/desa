
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010317" is

  procedure pp_abm_tipo_vale(v_ind                      in varchar2,
                             v_tiva_codi                in number,
                             v_tiva_desc                in varchar2,
                             v_tiva_cuco_codi           in number,
                             v_tiva_conc_codi_valr      in number,
                             v_tiva_conc_codi_dval      in number,
                             v_tiva_conc_codi_valr_impo in number,
                             v_tiva_conc_codi_rval      in number,
                             v_tiva_indi_comb           in varchar2,
                             v_tiva_indi_flet           in varchar2,
                             v_tiva_emit_reci           in varchar2,
                             v_tiva_devo_cuco_codi      in number,
                             v_tiva_base                in number,
                             v_tiva_user_regi           in varchar2,
                             v_tiva_fech_regi           in date,
                             v_tiva_empr_codi           in number,
                             v_tiva_codi_alte           in number) is
    x_tiva_codi number;
    x_tiva_codi_alte number;
  begin

    if v_ind = 'I' then
      select nvl(max(tiva_codi), 0) + 1, nvl(max(tiva_codi_alte), 0) + 1
        into x_tiva_codi, x_tiva_codi_alte
        from come_tipo_vale;
      insert into come_tipo_vale
        (tiva_codi,
         tiva_desc,
         tiva_cuco_codi,
         tiva_conc_codi_valr,
         tiva_conc_codi_dval,
         tiva_conc_codi_valr_impo,
         tiva_conc_codi_rval,
         tiva_indi_comb,
         tiva_indi_flet,
         tiva_emit_reci,
         tiva_devo_cuco_codi,
         tiva_base,
         tiva_user_regi,
         tiva_fech_regi,
         tiva_empr_codi,
         tiva_codi_alte)
      values
        (x_tiva_codi,
         v_tiva_desc,
         v_tiva_cuco_codi,
         v_tiva_conc_codi_valr,
         v_tiva_conc_codi_dval,
         v_tiva_conc_codi_valr_impo,
         v_tiva_conc_codi_rval,
         v_tiva_indi_comb,
         v_tiva_indi_flet,
         v_tiva_emit_reci,
         v_tiva_devo_cuco_codi,
         v_tiva_base,
         gen_user,
         sysdate,
         v_tiva_empr_codi,
         x_tiva_codi_alte);

    elsif v_ind = 'U' then

      update come_tipo_vale
         set tiva_desc                = v_tiva_desc,
             tiva_cuco_codi           = v_tiva_cuco_codi,
             tiva_conc_codi_valr      = v_tiva_conc_codi_valr,
             tiva_conc_codi_dval      = v_tiva_conc_codi_dval,
             tiva_conc_codi_valr_impo = v_tiva_conc_codi_valr_impo,
             tiva_conc_codi_rval      = v_tiva_conc_codi_rval,
             tiva_indi_comb           = v_tiva_indi_comb,
             tiva_indi_flet           = v_tiva_indi_flet,
             tiva_emit_reci           = v_tiva_emit_reci,
             tiva_devo_cuco_codi      = v_tiva_devo_cuco_codi,
             tiva_base                = v_tiva_base,
             tiva_user_modi           = gen_user,
             tiva_fech_modi           = sysdate,
             tiva_empr_codi           = v_tiva_empr_codi,
             tiva_codi_alte           = v_tiva_codi_alte
       where tiva_codi = v_tiva_codi;

    elsif v_ind = 'D' then

      delete come_tipo_vale where tiva_codi = v_tiva_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_abm_tipo_vale;

end I010317;
