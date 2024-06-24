
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010453" is

  procedure pp_abm_clas_orde_serv(v_ind            in varchar2,
                                  v_clor_empr_codi in number,
                                  v_clor_codi      in number,
                                  v_clor_codi_alte in number,
                                  v_clor_desc      in varchar2,
                                  v_clor_user_regi in varchar2,
                                  v_clor_fech_regi in date) is
    x_clor_codi      number;
    x_clor_codi_alte number;
  begin
  
    if v_ind = 'I' then
      select nvl(max(clor_codi), 0) + 1,
             nvl(max(to_number(clor_codi_alte)), 0) + 1
        into x_clor_codi, x_clor_codi_alte
        from come_clas_orse;
      insert into come_clas_orse
        (clor_empr_codi,
         clor_codi,
         clor_codi_alte,
         clor_desc,
         clor_user_regi,
         clor_fech_regi)
      values
        (v_clor_empr_codi,
         v_clor_codi,
         v_clor_codi_alte,
         v_clor_desc,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_clas_orse
         set clor_empr_codi = v_clor_empr_codi,
             clor_codi_alte = v_clor_codi_alte,
             clor_desc      = v_clor_desc,
             clor_user_modi = gen_user,
             clor_fech_modi = sysdate
       where clor_codi = v_clor_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_clas_orde_serv;

  -----------------------------------------------------------------------------------------

  procedure pp_borrar_registro(v_clor_codi in number) is
  
  begin
  
    i010453.pp_validar_borrado(v_clor_codi);
  
    delete come_clas_orse where clor_codi = v_clor_codi;
  
  end pp_borrar_registro;

  -----------------------------------------------------------------------------------------

  procedure pp_validar_borrado(v_clor_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_orde_serv
     where orse_clor_codi = v_clor_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'O.S. con esta clasificaci?n. Primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;

---------------------------------------------------------------------------

end i010453;
