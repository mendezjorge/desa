
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010071" is

  procedure pa_abm_prof(v_ind            in varchar2,
                        v_prof_codi      in number,
                        v_prof_desc      in varchar2,
                        v_prof_empr_codi in number,
                        v_prof_codi_alte in number,
                        v_prof_user_regi in varchar2,
                        v_prof_fech_regi in date,
                        v_prof_base      in number) is

    x_prof_codi      number;
    x_prof_codi_alte number;

  begin

    if v_ind = 'I' then
      select nvl(max(prof_codi), 0) + 1,
             nvl(max(to_number(prof_codi_alte)), 0) + 1
        into x_prof_codi, x_prof_codi_alte
        from come_prof;
      insert into come_prof
        (prof_codi,
         prof_desc,
         prof_empr_codi,
         prof_codi_alte,
         prof_user_regi,
         prof_fech_regi)
      values
        (x_prof_codi,
         v_prof_desc,
         v_prof_empr_codi,
         x_prof_codi_alte,
         gen_user,
         sysdate);

    elsif v_ind = 'U' then

      update come_prof
         set prof_desc      = v_prof_desc,
             prof_base      = v_prof_base,
             prof_empr_codi = v_prof_empr_codi,
             prof_codi_alte = v_prof_codi_alte,
             prof_user_modi = gen_user,
             prof_fech_modi = sysdate
       where prof_codi = v_prof_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pa_abm_prof;

  -----------------------------------------------------------------------------------------

  procedure pa_borrar_registro(v_prof_codi in number) is

  begin

    I010071.pa_validar_borrado(v_prof_codi);

    delete come_prof where prof_codi = v_prof_codi;

  end pa_borrar_registro;

  -----------------------------------------------------------------------------------------

  procedure pa_validar_borrado(v_prof_codi in number) is
    v_count number(6);

  begin

    select count(*)
      into v_count
      from come_clie_prov
     where clpr_prof_codi = v_prof_codi;

    if v_count > 0 then
      raise_application_error(-20010,'No se puede eliminar porque existen' || '  ' ||
                       v_count || ' ' || 'clientes o propietarios relacionados con este registro');
    end if;

  end pa_validar_borrado;

end I010071;
