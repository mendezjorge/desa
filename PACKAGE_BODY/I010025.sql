
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010025" is

  procedure pp_abm_tipo_empleado(v_ind            in varchar2,
                                 v_tiem_empr_codi in number,
                                 v_tiem_codi      in number,
                                 v_tiem_codi_alte in number,
                                 v_tiem_desc      in varchar2,
                                 v_tiem_base      in number,
                                 v_tiem_user_regi in varchar2,
                                 v_tiem_fech_regi in date) is
    x_tiem_codi      number;
    x_tiem_codi_alte number;
  
  begin
  
    if v_ind = 'I' then
      select nvl(max(to_number(tiem_codi_alte)), 0) + 1,
             nvl(max(tiem_codi), 0) + 1
        into x_tiem_codi_alte, x_tiem_codi
        from come_tipo_empl;
      insert into come_tipo_empl
        (tiem_empr_codi,
         tiem_codi,
         tiem_codi_alte,
         tiem_desc,
         tiem_base,
         tiem_user_regi,
         tiem_fech_regi)
      values
        (v_tiem_empr_codi,
         x_tiem_codi,
         x_tiem_codi_alte,
         v_tiem_desc,
         v_tiem_base,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_tipo_empl
         set tiem_empr_codi = v_tiem_empr_codi,
             tiem_codi_alte = v_tiem_codi_alte,
             tiem_desc      = v_tiem_desc,
             tiem_base      = v_tiem_base,
             tiem_user_modi = gen_user,
             tiem_fech_modi = sysdate
       where tiem_codi = v_tiem_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_tipo_empleado;

  ---------------------------------------------------------------------------------------

  procedure pp_borrar_registro(v_tiem_codi in number) is
  
  begin
  
    I010025.pp_validar_borrado(v_tiem_codi);
    delete come_tipo_empl where tiem_codi = v_tiem_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------

  procedure pp_validar_borrado(v_tiem_codi in number) is
    v_count number(6);
  
  begin
    select count(*)
      into v_count
      from come_empl_tiem
     where emti_tiem_codi = v_tiem_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Empleados que tienen asignados este Tipo. primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;

end I010025;
