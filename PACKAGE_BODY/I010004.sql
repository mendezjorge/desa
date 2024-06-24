
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010004" is
  procedure pp_abm_sub_fami(v_ind             in varchar2,
                            v_clas2_empr_codi in number,
                            v_clas1_codi      in number,
                            v_clas2_codi      in number,
                            v_clas2_codi_alte in number,
                            v_clas2_desc      in varchar2,
                            v_clas2_base      in number,
                            v_clas2_codi_ori  in number,
                            v_clas2_user_regi in varchar2,
                            v_clas2_fech_regi in date) is
    x_clas2_codi      number;
    x_clas2_codi_alte number;
  begin
    if v_ind = 'I' then
      select nvl(max(clas2_codi), 0) + 1,
             nvl(max(to_number(clas2_codi_alte)), 0) + 1
        into x_clas2_codi, x_clas2_codi_alte
        from come_prod_clas_2;
      insert into come_prod_clas_2
        (clas2_empr_codi,
         clas1_codi,
         clas2_codi,
         clas2_codi_alte,
         clas2_desc,
         clas2_user_regi,
         clas2_fech_regi)
      values
        (v_clas2_empr_codi,
         v_clas1_codi,
         x_clas2_codi,
         x_clas2_codi_alte,
         v_clas2_desc,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_prod_clas_2
         set clas2_empr_codi = v_clas2_empr_codi,
             clas1_codi      = v_clas1_codi,
             clas2_codi_alte = v_clas2_codi_alte,
             clas2_desc      = v_clas2_desc,
             clas2_base      = v_clas2_base,
             clas2_codi_ori  = v_clas2_codi_ori,
             clas2_user_modi = gen_user,
             clas2_fech_modi = sysdate
       where clas2_codi = v_clas2_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_sub_fami;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_clas2_codi in number) is
  begin
  
    i010004.pp_validar_borrado(v_clas2_codi);
    delete come_prod_clas_2 where clas2_codi = v_clas2_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_clas2_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_prod
     where prod_clas2 = v_clas2_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'productos que tienen asignados este registro. Primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;

  function fp_obte_user(p_login in varchar2) return varchar2 is
  
    v_user_desc varchar2(1000);
  begin
    select u.user_desc
      into v_user_desc
      from segu_user u
     where u.user_login = p_login
    --and nvl(u.user_empl_codi, 1) = nvl(v('ai_empr_codi'), 1)
    ;
    return v_user_desc;
  exception
    when others then
      return null;
  end fp_obte_user;

end i010004;
