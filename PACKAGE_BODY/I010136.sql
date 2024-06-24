
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010136" is

  procedure pp_abm_emse(v_ind            in varchar2,
                        v_emse_empr_codi in number,
                        v_emse_emde_codi in number,
                        v_emse_codi      in number,
                        v_emse_codi_alte in number,
                        v_emse_desc      in varchar2,
                        v_emse_base      in number,
                        v_emse_user_regi in varchar2,
                        v_emse_fech_regi in date,
                        v_emse_indi_salo in varchar2) is
  
    x_emse_codi      number;
    x_emse_codi_alte number;
  
  begin
  
    if v_ind = 'I' then
      select nvl(max(emse_codi), 0) + 1,
             nvl(max(to_number(emse_codi_alte)), 0) + 1
        into x_emse_codi, x_emse_codi_alte
        from come_empr_secc;
      insert into come_empr_secc
        (emse_empr_codi,
         emse_emde_codi,
         emse_codi,
         emse_codi_alte,
         emse_desc,
         emse_base,
         emse_user_regi,
         emse_fech_regi,
         emse_indi_salo)
      values
        (v_emse_empr_codi,
         v_emse_emde_codi,
         x_emse_codi,
         x_emse_codi_alte,
         v_emse_desc,
         v_emse_base,
         gen_user,
         sysdate,
         v_emse_indi_salo);
    
    elsif v_ind = 'U' then
    
      update come_empr_secc
         set emse_empr_codi = v_emse_empr_codi,
             emse_emde_codi = v_emse_emde_codi,
             emse_codi_alte = v_emse_codi_alte,
             emse_desc      = v_emse_desc,
             emse_base      = v_emse_base,
             emse_user_modi = gen_user,
             emse_fech_modi = sysdate,
             emse_indi_salo = v_emse_indi_salo
       where emse_codi = v_emse_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_emse;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_emse_codi in number) is
  begin
  
    I010136.pp_validar_borrado(v_emse_codi);
    delete come_empr_secc where emse_codi = v_emse_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_emse_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_empl
     where empl_emse_codi = v_emse_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'No se puede eliminar porque existe/n' || '  ' ||
                              v_count || ' ' ||
                              ' empleados/s relacionada/s con este registro');
    end if;
  
  end pp_validar_borrado;

end I010136;
