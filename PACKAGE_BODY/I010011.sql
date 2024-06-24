
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010011" is

  procedure pp_abm_modulos(v_ind            in varchar2,
                           v_modu_codi      in number,
                           v_modu_desc      in varchar2,
                           v_modu_label     in varchar2,
                           v_modu_base      in number,
                           v_modu_user_regi in varchar2,
                           v_modu_fech_regi in date,
                           v_modu_imag      in varchar2,
                           v_modu_empr_codi in number,
                           v_modu_codi_alte in number) is
    x_modu_codi      number;
    x_modu_codi_alte number;
  begin

    if v_ind = 'I' then
      select nvl(max(modu_codi), 0) + 1, nvl(max(modu_codi_alte), 0) + 1
        into x_modu_codi, x_modu_codi_alte
        from segu_modu;
      insert into segu_modu
        (modu_codi,
         modu_desc,
         modu_label,
         modu_user_regi,
         modu_fech_regi,
         modu_imag,
         modu_empr_codi,
         modu_codi_alte)
      values
        (x_modu_codi,
         v_modu_desc,
         v_modu_label,
         gen_user,
         sysdate,
         v_modu_imag,
         v_modu_empr_codi,
         x_modu_codi_alte);

    elsif v_ind = 'U' then

      update segu_modu
         set modu_desc      = v_modu_desc,
             modu_label     = v_modu_label,
             modu_base      = v_modu_base,
             modu_user_modi = gen_user,
             modu_fech_modi = sysdate,
             modu_imag      = v_modu_imag,
             modu_empr_codi = v_modu_empr_codi,
             modu_codi_alte = v_modu_codi_alte
       where modu_codi = v_modu_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_modulos;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_modu_codi in number) is
  begin

    I010011.pp_validar_borrado(v_modu_codi);
    delete segu_modu where modu_codi = v_modu_codi;

  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_modu_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from segu_pant
     where pant_modu = V_modu_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Pantallas que tienen asignados este modulo. primero debes borrarlos o asignarlos a otra');
    end if;

  end pp_validar_borrado;

end I010011;
