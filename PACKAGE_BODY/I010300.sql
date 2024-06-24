
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010300" is

  procedure pp_abm_clpr_acti (v_ind           in varchar2,
                             v_acti_codi      in number,
                             v_acti_desc      in varchar2,
                             v_acti_empr_codi in number,
                             v_acti_codi_alte in number,
                             v_acti_user_regi in varchar2,
                             v_acti_fech_regi in date,
                             v_acti_base      in number) is
   x_acti_codi number;
   x_acti_codi_alte number;
   begin
   if v_ind = 'I' then
       select nvl(max(acti_codi), 0) + 1, nvl(max(to_number(acti_codi_alte)),0)+1
       into x_acti_codi, x_acti_codi_alte
       from come_clpr_acti;
     insert into come_clpr_acti
          (acti_codi,
           acti_desc,
           acti_empr_codi,
           acti_codi_alte,
           acti_user_regi,
           acti_fech_regi,
           acti_base)
        values
          (x_acti_codi,
           v_acti_desc,
           v_acti_empr_codi,
           x_acti_codi_alte,
           gen_user,
           sysdate,
           v_acti_base);

  elsif  v_ind  = 'U' then

          update come_clpr_acti
        set acti_desc      = v_acti_desc,
            acti_base      = v_acti_base,
            acti_empr_codi = v_acti_empr_codi,
            acti_codi_alte = v_acti_codi_alte,
            acti_user_modi = gen_user,
            acti_fech_modi = sysdate
        where acti_codi = v_acti_codi;
  end if;


 exception
   when no_data_found then
     raise_application_error(-20010, sqlerrm||' NO SE ENCONTRO DATOS');
   when too_many_rows then
     raise_application_error(-20010, sqlerrm||' HAY MUCHOS DATOS');
   when others then
     raise_application_error(-20010, sqlerrm);

   end pp_abm_clpr_acti;

  ---------------------------------------------------------------------------------------
  procedure pp_borrar_registro(v_acti_codi in number) is
  begin

    i010300.pp_validar_borrado(v_acti_codi);
    delete come_clpr_acti where acti_codi = v_acti_codi;

  end pp_borrar_registro;

  ---------------------------------------------------------------------------------------
  procedure pp_validar_borrado(v_acti_codi in number) is
    v_count number(6);
  begin
    select count(*)
    into v_count
    from come_clie_prov c
   where c.clpr_acti_codi = v_acti_codi;

  if v_count > 0 then
    raise_application_error(-20010,'Existen' || '  ' || v_count || ' ' ||
          'clientes que tienen asignados esta Actividad. Primero debe borrarlos o asignarlos a otro');
  end if;

  end pp_validar_borrado;

end i010300;
