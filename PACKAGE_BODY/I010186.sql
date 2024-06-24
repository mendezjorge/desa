
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010186" is
  procedure pp_abm_come_cent_cost(i_ind                 in varchar2,
                                  i_ceco_empr_codi      in number,
                                  i_ceco_codi           in number,
                                  i_ceco_nume           in number,
                                  i_ceco_desc           in varchar2,
                                  i_ceco_cuco_resu      in number,
                                  i_ceco_cuco_gana_perd in number,
                                  i_ceco_nive           in number,
                                  i_ceco_indi_impu      in varchar2,
                                  i_ceco_ceco_codi      in number,
                                  i_ceco_peri           in varchar2,
                                  i_ceco_base           in number,
                                  i_ceco_user_regi      in varchar2,
                                  i_ceco_fech_regi      in date) is
    v_ceco_codi number;
    v_ceco_nume number;
  begin
    if i_ind = 'I' then
      select nvl(max(ceco_codi), 0) + 1, nvl(max(ceco_nume), 0) + 1
        into v_ceco_codi, v_ceco_nume
        from come_cent_cost;
      insert into come_cent_cost
        (ceco_empr_codi,
         ceco_codi,
         ceco_nume,
         ceco_desc,
         ceco_cuco_resu,
         ceco_cuco_gana_perd,
         ceco_nive,
         ceco_indi_impu,
         ceco_ceco_codi,
         ceco_peri,
         ceco_base,
         ceco_user_regi,
         ceco_fech_regi)
      values
        (i_ceco_empr_codi,
         v_ceco_codi,
         v_ceco_nume,
         i_ceco_desc,
         i_ceco_cuco_resu,
         i_ceco_cuco_gana_perd,
         i_ceco_nive,
         i_ceco_indi_impu,
         i_ceco_ceco_codi,
         i_ceco_peri,
         i_ceco_base,
         gen_user,
         sysdate);
    
    elsif i_ind = 'U' then
    
      update come_cent_cost
         set ceco_empr_codi      = i_ceco_empr_codi,
             ceco_nume           = i_ceco_nume,
             ceco_desc           = i_ceco_desc,
             ceco_cuco_resu      = i_ceco_cuco_resu,
             ceco_cuco_gana_perd = i_ceco_cuco_gana_perd,
             ceco_nive           = i_ceco_nive,
             ceco_indi_impu      = i_ceco_indi_impu,
             ceco_ceco_codi      = i_ceco_ceco_codi,
             ceco_peri           = i_ceco_peri,
             ceco_base           = i_ceco_base,
             ceco_user_modi      = gen_user,
             ceco_fech_modi      = sysdate
       where ceco_codi = i_ceco_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_abm_come_cent_cost;

  ------------------------------------------------------------------------------------

  procedure pp_borrar_registro(i_ceco_codi in number) is
  begin
    --raise_application_error(-20010, i_ceco_codi);
    I010186.pp_validar_borrado(i_ceco_codi);
  
    update come_cent_cost
       set ceco_base = 1 --parameter.i_codi_base
     where ceco_codi = i_ceco_codi;
  
    delete come_cent_cost where ceco_codi = i_ceco_codi;
  
  end pp_borrar_registro;

  ------------------------------------------------------------------------------------
  procedure pp_validar_borrado(i_ceco_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_cent_cost c
     where c.ceco_ceco_codi = i_ceco_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'El Centro de Costos es padre de otros ' ||
                              v_count || ' Centro(s) de Costo(s)' ||
                              chr(10) ||
                              'Primero debe borrar esos Centros o asignarle otro padre');
    end if;
  
  end pp_validar_borrado;

  ---------------------------------------------------------------------------
  procedure pp_muestra_come_cent_cost_padr(i_ceco_nive in number,
                                           i_nume      in number,
                                           o_desc      out char,
                                           o_codi      out number) is
    v_ceco_nive number;
  begin
    if i_nume <> 0 then
      select ceco_desc, ceco_codi, ceco_nive
        into o_desc, o_codi, v_ceco_nive
        from come_cent_cost
       where ceco_nume = i_nume
         and ceco_empr_codi = 1;
    else
      select ceco_desc, ceco_codi, ceco_nive
        into o_desc, o_codi, v_ceco_nive
        from come_cent_cost
       where ceco_nume = i_nume;
    end if;
  
    if nvl(v_ceco_nive, 0) <> (i_ceco_nive - 1) then
      raise_application_error(-20010,
                              'El Centro no corresponde al nivel seleccionado!!');
    end if;
  
  exception
    when no_data_found then
      --raise_application_error(-20010, 'Centro de Costo Padre inexistente!' || i_nume);
      null;
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_muestra_come_cent_cost_padr;

---------------------------------------------------------------------------

end I010186;
