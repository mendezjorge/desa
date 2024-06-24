
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010147" is
  procedure pp_abm_periodos(v_ind            in varchar2,
                            v_peri_codi      in number,
                            v_peri_fech_inic in date,
                            v_peri_fech_fini in date,
                            v_peri_base      in number,
                            v_peri_anho_mess in varchar2,
                            v_peri_codi_alte in number,
                            v_peri_empr_codi in number,
                            v_peri_user_regi in varchar2,
                            v_peri_fech_regi in date) is
  
    p_variable       varchar2(20);
    x_peri_codi      number;
    x_peri_codi_alte number;
  
  begin
    if v_ind in ('I', 'U') then
      p_variable := to_date('01-' || v_peri_anho_mess, 'dd/mm/yyyy');
    end if;
    if v_ind = 'I' then
      select nvl(max(peri_codi), 0) + 1, nvl(max(peri_codi_alte), 0) + 1
        into x_peri_codi, x_peri_codi_alte
        from rrhh_peri;
      insert into rrhh_peri
        (peri_codi,
         peri_fech_inic,
         peri_fech_fini,
         peri_base,
         peri_anho_mess,
         peri_codi_alte,
         peri_empr_codi,
         peri_user_regi,
         peri_fech_regi)
      values
        (x_peri_codi,
         v_peri_fech_inic,
         v_peri_fech_fini,
         v_peri_base,
         p_variable, --en reemplazo de v_peri_anho_mess
         x_peri_codi_alte,
         v_peri_empr_codi,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update rrhh_peri
         set peri_fech_inic = v_peri_fech_inic,
             peri_fech_fini = v_peri_fech_fini,
             peri_base      = v_peri_base,
             peri_anho_mess = p_variable,
             peri_codi_alte = v_peri_codi_alte,
             peri_empr_codi = v_peri_empr_codi,
             peri_user_modi = gen_user,
             peri_fech_modi = sysdate
       where peri_codi = v_peri_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_periodos;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_peri_codi in number) is
  begin
  
    I010147.pp_validar_borrado(v_peri_codi);
    delete rrhh_peri where peri_codi = v_peri_codi;
  
  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_peri_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from rrhh_liqu
     where liqu_peri_codi = v_peri_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'No se puede eliminar porque existe/n' || '  ' ||
                              v_count || ' ' ||
                              ' liquidaci¿n /es relacionada/s con este registro');
    end if;
  
  end pp_validar_borrado;

end I010147;
