
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010034" is

  procedure pp_abm_pais(v_ind            in varchar2,
                        v_pais_empr_codi in number,
                        v_pais_codi      in number,
                        v_pais_codi_alte in number,
                        v_pais_desc      in varchar2,
                        v_pais_base      in number,
                        v_pais_user_regi in varchar2,
                        v_pais_fech_regi in date,
                        v_pais_user_modi in varchar2,
                        v_pais_fech_modi in varchar2) is
    x_pais_codi      number;
    x_pais_codi_alte number;

  begin

    if v_ind = 'I' then
      select nvl(max(pais_codi), 0) + 1, nvl(max(to_number(pais_codi_alte)), 0) + 1
        into x_pais_codi, x_pais_codi_alte
        from come_pais;
      insert into come_pais
        (pais_empr_codi,
         pais_codi,
         pais_codi_alte,
         pais_desc,
         pais_user_regi,
         pais_fech_regi)
      values
        (v_pais_empr_codi,
         x_pais_codi,
         x_pais_codi_alte,
         v_pais_desc,
         v_pais_user_regi,
         v_pais_fech_regi);

    elsif v_ind = 'U' then

      update come_pais
         set pais_empr_codi = v_pais_empr_codi,
             pais_codi_alte = v_pais_codi_alte,
             pais_desc      = v_pais_desc,
             pais_base      = v_pais_base,
             pais_user_modi = gen_user,
             pais_fech_modi = v_pais_fech_modi
       where pais_codi = v_pais_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_pais;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_pais_codi in number) is
  begin

    I010034.pp_validar_borrado(v_pais_codi);
    delete come_pais where pais_codi = v_pais_codi;

  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_pais_codi in number) is
    v_ciud number(6);
    v_depa number(6);
  begin
    select count(*)
      into v_ciud
      from come_ciud
     where ciud_pais_codi = v_pais_codi;

    if v_ciud > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_ciud || ' ' ||
                              'Ciudades que tienen asignados este registro. primero debes borrarlos o asignarlos a otro');
    end if;

    select count(*)
      into v_depa
      from come_depa
     where depa_pais_codi = v_pais_codi;

    if v_depa > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_depa || ' ' ||
                              'Ciudades que tienen asignados este registro. primero debes borrarlos o asignarlos a otro');
    end if;

  end pp_validar_borrado;

end I010034;
