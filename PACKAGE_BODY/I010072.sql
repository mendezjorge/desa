
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010072" is

  procedure pp_abm_naci(v_ind            in varchar2,
                        v_naci_codi      in number,
                        v_naci_desc      in varchar2,
                        v_naci_empr_codi in number,
                        v_naci_codi_alte in number,
                        v_naci_user_regi in varchar2,
                        v_naci_fech_regi in date,
                        v_naci_base      in number) is

    x_naci_codi      number;
    x_naci_codi_alte number;

  begin

    if v_ind = 'I' then
      select nvl(max(naci_codi), 0) + 1,
             nvl(max(to_number(naci_codi_alte)), 0) + 1
        into x_naci_codi, x_naci_codi_alte
        from come_naci;
      insert into come_naci
        (naci_codi,
         naci_desc,
         naci_empr_codi,
         naci_codi_alte,
         naci_user_regi,
         naci_fech_regi)
      values
        (x_naci_codi,
         v_naci_desc,
         v_naci_empr_codi,
         x_naci_codi_alte,
         v_naci_user_regi,
         v_naci_fech_regi);

    elsif v_ind = 'U' then

      update come_naci
         set naci_desc      = v_naci_desc,
             naci_base      = v_naci_base,
             naci_empr_codi = v_naci_empr_codi,
             naci_codi_alte = v_naci_codi_alte,
             naci_user_modi = v('APP_USER'),
             naci_fech_modi = sysdate
       where naci_codi = v_naci_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_naci;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_naci_codi in number) is
  begin

    I010072.pp_validar_borrado(v_naci_codi);
    delete come_naci where naci_codi = v_naci_codi;

  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_naci_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_clie_prov
     where clpr_naci_codi = v_naci_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'No se puede eliminar porque Existe/n' || '  ' ||
                              v_count || ' ' ||
                              'cliente/s o propietario/s relacionado/s con este registro');
    end if;

  end pp_validar_borrado;

end I010072;
