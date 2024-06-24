
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010193" is

  procedure pp_abm_tipo_periodo(v_ind            in varchar2,
                                v_tipe_codi      in number,
                                v_tipe_desc      in varchar2,
                                v_tipe_cant_dias in number,
                                v_tipe_base      in number,
                                v_tipe_empr_codi in number,
                                v_tipe_codi_alte in number,
                                v_tipe_user_regi in varchar2,
                                v_tipe_fech_regi in date) is
  
    x_tipe_codi number;
    x_tipe_codi_alte number;
  begin
  
    if v_ind = 'I' then
      select nvl(max(tipe_codi), 0) + 1, nvl(max(tipe_codi_alte), 0) + 1
        into x_tipe_codi, x_tipe_codi_alte
        from rrhh_tipo_peri;
      insert into rrhh_tipo_peri
        (tipe_codi,
         tipe_desc,
         tipe_cant_dias,
         tipe_base,
         tipe_empr_codi,
         tipe_codi_alte,
         tipe_user_regi,
         tipe_fech_regi)
      values
        (x_tipe_codi,
         v_tipe_desc,
         v_tipe_cant_dias,
         v_tipe_base,
         v_tipe_empr_codi,
         x_tipe_codi_alte,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update rrhh_tipo_peri
         set tipe_desc      = v_tipe_desc,
             tipe_cant_dias = v_tipe_cant_dias,
             tipe_base      = v_tipe_base,
             tipe_empr_codi = v_tipe_empr_codi,
             tipe_codi_alte = v_tipe_codi_alte,
             tipe_user_modi = gen_user,
             tipe_fech_modi = sysdate
       where tipe_codi = v_tipe_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_tipo_periodo;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_tipe_codi in number) is
  begin
  
    I010193.pp_validar_borrado(v_tipe_codi);
    delete rrhh_tipo_peri where tipe_codi = v_tipe_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_tipe_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_empl
     where empl_tipe_codi = v_tipe_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'empleados que tienen asignados este tipo de periodo. Primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;

end I010193;
