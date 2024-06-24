
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010013" is

  procedure pp_abm_clasif_pantalla(v_ind            in varchar2,
                                   v_clas_codi      in number,
                                   v_clas_desc      in varchar2,
                                   v_clas_base      in number,
                                   v_clas_user_regi in varchar2,
                                   v_clas_fech_regi in date,
                                   v_clas_empr_codi in number,
                                   v_clas_codi_alte in number) is
    x_clas_codi      number;
    x_clas_codi_alte number;
  begin
    if v_ind = 'I' then
      SELECT NVL(MAX(clas_codi), 0) + 1, NVL(MAX(clas_codi_alte), 0) + 1
        INTO x_clas_codi, x_clas_codi_alte
        FROM segu_clas_pant;
      insert into segu_clas_pant
        (clas_codi,
         clas_desc,
         clas_user_regi,
         clas_fech_regi,
         clas_empr_codi,
         clas_codi_alte)
      values
        (x_clas_codi,
         v_clas_desc,
         gen_user,
         sysdate,
         v_clas_empr_codi,
         x_clas_codi_alte);

    elsif v_ind = 'U' then

      update segu_clas_pant
         set clas_desc      = v_clas_desc,
             clas_base      = v_clas_base,
             clas_user_modi = gen_user,
             clas_fech_modi = sysdate,
             clas_empr_codi = v_clas_empr_codi,
             clas_codi_alte = v_clas_codi_alte
       where clas_codi = v_clas_codi;

    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);

  end pp_abm_clasif_pantalla;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_clas_codi in number) is
  begin

    I010013.pp_validar_borrado(v_clas_codi);
    delete segu_clas_pant where clas_codi = v_clas_codi;

  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_clas_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from segu_pant
     where pant_clas = v_clas_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Pantallas que tienen asignados esta Clasificacion. primero debes borrarlos o asignarlos a otra');
    end if;

  end pp_validar_borrado;

end I010013;
