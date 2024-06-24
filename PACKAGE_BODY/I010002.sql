
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010002" is

  procedure pp_abm_marc(v_ind            in varchar2,
                        v_marc_codi      in number,
                        v_marc_desc      in varchar2,
                        v_marc_empr_codi in number,
                        v_marc_codi_alte in number,
                        v_marc_user_regi in varchar2,
                        v_marc_fech_regi in date,
                        v_marc_base      in number) is
  
    x_marc_codi      number;
    x_marc_codi_alte number;
  
  begin
  
    if v_ind = 'I' then
      select nvl(max(marc_codi), 0) + 1,
             nvl(max(to_number(marc_codi_alte)), 0) + 1
        into x_marc_codi, x_marc_codi_alte
        from come_marc;
      insert into come_marc
        (marc_codi,
         marc_desc,
         marc_empr_codi,
         marc_codi_alte,
         marc_user_regi,
         marc_fech_regi)
      values
        (x_marc_codi,
         v_marc_desc,
         v_marc_empr_codi,
         x_marc_codi_alte,
         fa_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_marc
         set marc_desc      = v_marc_desc,
             marc_base      = v_marc_base,
             marc_empr_codi = v_marc_empr_codi,
             marc_codi_alte = v_marc_codi_alte,
             marc_user_modi = fa_user,
             marc_fech_modi = sysdate
       where marc_codi = v_marc_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_marc;

  -----------------------------------------------------------------------------------------

  procedure pp_borrar_registro(v_marc_codi in number) is
  
  begin
  
    I010002.pp_validar_borrado(v_marc_codi);
  
    delete come_marc where marc_codi = v_marc_codi;
  
  end pp_borrar_registro;

  -----------------------------------------------------------------------------------------

  procedure pp_validar_borrado(v_marc_codi in number) is
    v_count number(6);
  
  begin
    select count(*)
      into v_count
      from come_prod
     where prod_marc_codi = v_marc_codi;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'productos que tienen asignados esta marca. Primero debes borrarlos o asignarlos a otra');
    end if;
  
  end pp_validar_borrado;

end I010002;
