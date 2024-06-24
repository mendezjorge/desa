
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010145" is

  procedure pp_abm_tipo_familiar(v_ind            in varchar2,
                                 v_fami_empr_codi in number,
                                 v_fami_codi      in number,
                                 v_fami_codi_alte in number,
                                 v_fami_desc      in varchar2,
                                 v_fami_indi_boni in varchar2,
                                 v_fami_base      in number,
                                 v_fami_user_regi in varchar2,
                                 v_fami_fech_regi in date) is
    x_fami_codi      number;
    x_fami_codi_alte number;
  
  begin
  
    if v_ind = 'I' then
      select nvl(max(fami_codi), 0) + 1,
             nvl(max(to_number(fami_codi_alte)), 0) + 1
        into x_fami_codi, x_fami_codi_alte
        from rrhh_tipo_fami;
      insert into rrhh_tipo_fami
        (fami_empr_codi,
         fami_codi,
         fami_codi_alte,
         fami_desc,
         fami_indi_boni,
         fami_base,
         fami_user_regi,
         fami_fech_regi)
      values
        (v_fami_empr_codi,
         x_fami_codi,
         x_fami_codi_alte,
         v_fami_desc,
         v_fami_indi_boni,
         v_fami_base,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update rrhh_tipo_fami
         set fami_empr_codi = v_fami_empr_codi,
             fami_codi_alte = v_fami_codi_alte,
             fami_desc      = v_fami_desc,
             fami_indi_boni = v_fami_indi_boni,
             fami_base      = v_fami_base,
             fami_user_modi = gen_user,
             fami_fech_modi = sysdate
       where fami_codi = v_fami_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_tipo_familiar;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_fami_codi in number) is
  begin
  
    I010145.pp_validar_borrado(v_fami_codi);
    delete rrhh_tipo_fami where fami_codi = v_fami_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_fami_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_empl_fami_deta
     where deta_fami_codi = v_fami_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'detalles asignados a este tipo de movimientos. primero debe borrarlos o asignarlos a otro');
    end if;
  
  end pp_validar_borrado;

end I010145;
