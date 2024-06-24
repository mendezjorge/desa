
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010010" is

  procedure pp_abm_perf_usua(v_ind            in varchar2,
                             v_perf_codi      in number,
                             v_perf_desc      in varchar2,
                             v_perf_base      in number,
                             v_perf_user_regi in varchar2,
                             v_perf_fech_regi in date,
                             v_perf_codi_alte in number,
                             v_perf_empr_codi in number) is
  x_perf_codi number;
  x_perf_codi_alte number;

  begin

    if v_ind = 'I' then
      select nvl(max(perf_codi),0)+1, nvl(max(perf_codi_alte),0)+1
      into x_perf_codi, x_perf_codi_alte
      from segu_perf;
      insert into segu_perf
        (perf_codi,
         perf_desc,
         perf_base,
         perf_user_regi,
         perf_fech_regi,
         perf_codi_alte,
         perf_empr_codi)
      values
        (x_perf_codi,
         v_perf_desc,
         v_perf_base,
         gen_user,
         sysdate,
         x_perf_codi_alte,
         v_perf_empr_codi);

    elsif v_ind = 'U' then

      update segu_perf
         set perf_desc      = v_perf_desc,
             perf_base      = v_perf_base,
             perf_user_modi = gen_user,
             perf_fech_modi = sysdate,
             perf_codi_alte = v_perf_codi_alte,
             perf_empr_codi = v_perf_empr_codi
       where perf_codi = v_perf_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_perf_usua;

  -----------------------------------------------------------------------------------------

  procedure pp_borrar_registro(v_perf_codi in number) is

  begin

    I010010.pp_validar_borrado(v_perf_codi);

    delete segu_perf where perf_codi = v_perf_codi;

  end pp_borrar_registro;

  -----------------------------------------------------------------------------------------

  procedure pp_validar_borrado(v_perf_codi in number) is
    v_count number(6);

  begin

    select count(*)
      into v_count
      from segu_pant_perf
     where pape_perf_codi = v_perf_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'pantallas que tienen asignados este perfil de usuario. primero debes borrarlos o asignarlos a otra');
    end if;

    select count(*)
      into v_count
      from segu_user_perf
     where uspe_perf_codi = v_perf_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Usuarios que tienen asignados este perfil. primero debes borrarlos o asignarlos a otra');
    end if;

  end pp_validar_borrado;

end I010010;
