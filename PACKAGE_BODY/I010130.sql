
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010130" is

  procedure pp_abm_emde(v_ind            in varchar2,
                        v_emde_codi      in number,
                        v_emde_empr_codi in number,
                        v_emde_codi_alte in number,
                        v_emde_desc      in varchar2,
                        v_emde_base      in number,
                        v_emde_user_regi in varchar2,
                        v_emde_fech_regi in date,
                        v_emde_desc_abre in varchar2) is
    x_emde_codi      number;
    x_emde_codi_alte number;
  
  begin
  
    if v_ind = 'I' then
      select nvl(max(emde_codi), 0) + 1,
             nvl(max(to_number(emde_codi_alte)), 0) + 1
        into x_emde_codi, x_emde_codi_alte
        from come_empr_dept;
      insert into come_empr_dept
        (emde_codi,
         emde_empr_codi,
         emde_codi_alte,
         emde_desc,
         emde_user_regi,
         emde_fech_regi,
         emde_desc_abre)
      values
        (x_emde_codi,
         v_emde_empr_codi,
         x_emde_codi_alte,
         v_emde_desc,
         gen_user,
         sysdate,
         v_emde_desc_abre);
    
    elsif v_ind = 'U' then
    
      update come_empr_dept
         set emde_empr_codi = v_emde_empr_codi,
             emde_codi_alte = v_emde_codi_alte,
             emde_desc      = v_emde_desc,
             emde_user_modi = gen_user,
             emde_fech_modi = sysdate,
             emde_base      = v_emde_base,
             emde_desc_abre = v_emde_desc_abre
       where emde_codi = v_emde_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_emde;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_emde_codi in number) is
  begin
  
    I010130.pp_validar_borrado(v_emde_codi);
    delete come_empr_dept where emde_codi = v_emde_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_emde_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_empr_secc
     where emse_emde_codi = v_emde_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'No se puede eliminar porque existe/n' || '  ' ||
                              v_count || ' ' ||
                              ' empresa/s relacionada/s con este registro');
    end if;
  
  end pp_validar_borrado;

end I010130;
