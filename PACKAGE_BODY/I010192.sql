
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010192" is

  procedure pp_abm_tipo_liqui(v_ind            in varchar2,
                              v_tili_codi      in number,
                              v_tili_desc      in varchar2,
                              v_tili_base      in number,
                              v_tili_empr_codi in number,
                              v_tili_codi_alte in number,
                              v_tili_user_regi in varchar2,
                              v_tili_fech_regi in date) is
  
    x_tili_codi      number;
    x_tili_codi_alte number;
  
  begin
  
    if v_ind = 'I' then
      select nvl(max(tili_codi), 0) + 1 tili_codi, nvl(max(tili_codi_alte), 0) + 1 tili_codi_alte
        into x_tili_codi, x_tili_codi_alte
        from rrhh_tipo_liqu;
      insert into rrhh_tipo_liqu
        (tili_codi,
         tili_desc,
         tili_base,
         tili_empr_codi,
         tili_codi_alte,
         tili_user_regi,
         tili_fech_regi)
      values
        (x_tili_codi,
         v_tili_desc,
         v_tili_base,
         v_tili_empr_codi,
         x_tili_codi_alte,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update rrhh_tipo_liqu
         set tili_desc      = v_tili_desc,
             tili_base      = v_tili_base,
             tili_empr_codi = v_tili_empr_codi,
             tili_codi_alte = v_tili_codi_alte,
             tili_user_modi = gen_user,
             tili_fech_modi = sysdate
       where tili_codi = v_tili_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_tipo_liqui;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_tili_codi in number) is
  begin
  
    I010192.pp_validar_borrado(v_tili_codi);
    delete rrhh_tipo_liqu where tili_codi = v_tili_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_tili_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_empl
     where empl_tili_codi = v_tili_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'empleados que tienen asignados este tipo de liquidacion. Primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;

end I010192;
