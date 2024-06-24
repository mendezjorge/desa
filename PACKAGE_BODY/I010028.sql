
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010028" is

  procedure pp_abm_enti_banc(v_ind                      in varchar2,
                             v_banc_empr_codi           in number,
                             v_banc_codi                in number,
                             v_banc_codi_alte           in number,
                             v_banc_indi_paga           in varchar2,
                             v_banc_desc                in varchar2,
                             v_banc_clpr_codi           in number,
                             v_banc_cuco_codi_mas       in number,
                             v_banc_cuco_codi_men       in number,
                             v_banc_mone_codi           in number,
                             v_banc_limi_cheq_paga_deto in number,
                             v_banc_limi_pres           in number,
                             v_banc_sobr                in number,
                             v_banc_tipo                in varchar2,
                             v_banc_base                in number,
                             v_banc_user_regi           in varchar2,
                             v_banc_fech_regi           in date) is
  
    x_banc_codi      number;
    x_banc_codi_alte number;
  begin
  
    if v_ind = 'I' then
      select nvl(max(banc_codi), 0) + 1, nvl(max(to_number(banc_codi_alte)), 0) + 1
        into x_banc_codi, x_banc_codi_alte
        from come_banc;
      insert into come_banc
        (banc_empr_codi,
         banc_codi,
         banc_codi_alte,
         banc_indi_paga,
         banc_desc,
         banc_clpr_codi,
         banc_cuco_codi_regu_desc_mas,
         banc_cuco_codi_regu_desc_men,
         banc_mone_codi,
         banc_limi_cheq_paga_deto,
         banc_limi_pres,
         banc_sobr,
         banc_tipo,
         banc_base,
         banc_user_regi,
         banc_fech_regi)
      values
        (v_banc_empr_codi,
         x_banc_codi,
         x_banc_codi_alte,
         v_banc_indi_paga,
         v_banc_desc,
         v_banc_clpr_codi,
         v_banc_cuco_codi_mas,
         v_banc_cuco_codi_men,
         v_banc_mone_codi,
         v_banc_limi_cheq_paga_deto,
         v_banc_limi_pres,
         v_banc_sobr,
         v_banc_tipo,
         v_banc_base,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_banc
         set banc_empr_codi               = v_banc_empr_codi,
             banc_codi_alte               = v_banc_codi_alte,
             banc_indi_paga               = v_banc_indi_paga,
             banc_desc                    = v_banc_desc,
             banc_clpr_codi               = v_banc_clpr_codi,
             banc_cuco_codi_regu_desc_mas = v_banc_cuco_codi_mas,
             banc_cuco_codi_regu_desc_men = v_banc_cuco_codi_men,
             banc_mone_codi               = v_banc_mone_codi,
             banc_limi_cheq_paga_deto     = v_banc_limi_cheq_paga_deto,
             banc_limi_pres               = v_banc_limi_pres,
             banc_sobr                    = v_banc_sobr,
             banc_tipo                    = v_banc_tipo,
             banc_base                    = v_banc_base,
             banc_user_modi               = gen_user,
             banc_fech_modi               = sysdate
       where banc_codi = v_banc_codi;
    
    elsif v_ind = 'D' then
    
      delete come_banc where banc_codi = v_banc_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_abm_enti_banc;

  -----------------------------------------------------------------------------------------

  procedure pp_borrar_registro(v_banc_codi in number) is
  
  begin
  
    i010028.pp_validar_borrado(v_banc_codi);
  
    delete come_banc where banc_codi = v_banc_codi;
  
  end pp_borrar_registro;

  -----------------------------------------------------------------------------------------

  procedure pp_validar_borrado(v_banc_codi in number) is
    v_count number(6);
  
  begin
  
    select count(*)
      into v_count
      from come_cuen_banc
     where cuen_banc_codi = v_banc_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Cuentas Bancarias que tienen asignados esta Entidad. primero debes borrarlos o asignarlos a otra');
    end if;
  
    select count(*)
      into v_count
      from come_cheq
     where cheq_banc_codi = v_banc_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Cheques que tienen asignados esta Entidad. primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;
  
  ------------------------------------------------------------------------------
  
  procedure pp_cant_deci(i_cod_mone in number, o_cant_deci out number) is
  
  begin
    
  select mone_cant_deci
  into o_cant_deci
  from come_mone
  where mone_codi=i_cod_mone;
  exception
  when others then
    raise_application_error(-20010,'Error al buscar cantidad de decimal'||sqlerrm);
  end;
  

end i010028;
