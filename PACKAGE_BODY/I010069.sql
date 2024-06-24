
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010069" is

  procedure pp_abm_depa(v_ind            in varchar2,
                        v_depa_codi      in number,
                        v_depa_desc      in varchar2,
                        v_depa_empr_codi in number,
                        v_depa_codi_alte in number,
                        v_depa_user_regi in varchar2,
                        v_depa_fech_regi in date,
                        v_depa_base      in number,
                        v_depa_cod_sifen in number,
                        v_depa_pais_codi in number) is
    x_depa_codi      number;
    x_depa_codi_alte number;

  begin

    if v_ind = 'I' then
      select nvl(max(depa_codi), 0) + 1, max(nvl(to_number(depa_codi_alte),1))+1
        into x_depa_codi, x_depa_codi_alte
        from come_depa;
      insert into come_depa
        (depa_codi,
         depa_desc,
         depa_empr_codi,
         depa_codi_alte,
         depa_user_regi,
         depa_fech_regi,
         depa_base,
         depa_cod_sifen,
         depa_pais_codi)
      values
        (x_depa_codi,
         v_depa_desc,
         v_depa_empr_codi,
         x_depa_codi_alte,
         gen_user,
         sysdate,
         v_depa_base,
         v_depa_cod_sifen,
         v_depa_pais_codi);

    elsif v_ind = 'U' then

      update come_depa
         set depa_desc      = v_depa_desc,
             depa_base      = v_depa_base,
             depa_empr_codi = v_depa_empr_codi,
             depa_codi_alte = v_depa_codi_alte,
             depa_user_modi = gen_user,
             depa_fech_modi = sysdate,
             depa_pais_codi = v_depa_pais_codi
       where depa_codi = v_depa_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_depa;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_depa_codi in number) is
  begin

    I010069.pp_validar_borrado(v_depa_codi);
    delete come_depa where depa_codi = v_depa_codi;

  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_depa_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_ciud
     where ciud_depa_codi = v_depa_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'No se puede eliminar porque existe/n' || '  ' ||
                              v_count || ' ' ||
                              ' ciudades relacionada/s con este departamento');
    end if;

  end pp_validar_borrado;

end I010069;
