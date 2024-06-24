
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010449" is

  procedure pp_abm_ciclo_fact(v_ind            in varchar2,
                              v_cifa_empr_codi in number,
                              v_cifa_codi      in number,
                              v_cifa_nume      in number,
                              v_cifa_desc      in varchar2,
                              v_cifa_tipo      in varchar2,
                              v_cifa_dia_fact  in number,
                              v_cifa_dia_desd  in number,
                              v_cifa_dia_hast  in number,
                              v_cifa_base      in number,
                              v_cifa_user_regi in varchar2,
                              v_cifa_fech_regi in date) is
    x_cifa_codi      number;
    x_cifa_nume      number;
  begin
    if v_ind = 'I' then
      select nvl(max(cifa_codi), 0) + 1,nvl(max(to_number(cifa_nume)), 0) + 1
        into x_cifa_codi,x_cifa_nume
        from come_cicl_fact;
      insert into come_cicl_fact
        (cifa_empr_codi,
         cifa_codi,
         cifa_nume,
         cifa_desc,
         cifa_tipo,
         cifa_dia_fact,
         cifa_dia_desd,
         cifa_dia_hast,
         cifa_base,
         cifa_user_regi,
         cifa_fech_regi)
      values
        (v_cifa_empr_codi,
         x_cifa_codi,
         x_cifa_nume,
         v_cifa_desc,
         v_cifa_tipo,
         v_cifa_dia_fact,
         v_cifa_dia_desd,
         v_cifa_dia_hast,
         v_cifa_base,
         gen_user,
         sysdate);
    
    elsif v_ind = 'U' then
    
      update come_cicl_fact
         set cifa_empr_codi = v_cifa_empr_codi,
             cifa_nume      = v_cifa_nume,
             cifa_desc      = v_cifa_desc,
             cifa_tipo      = v_cifa_tipo,
             cifa_dia_fact  = v_cifa_dia_fact,
             cifa_dia_desd  = v_cifa_dia_desd,
             cifa_dia_hast  = v_cifa_dia_hast,
             cifa_base      = v_cifa_base,
             cifa_user_modi = gen_user,
             cifa_fech_modi = sysdate
       where cifa_codi = v_cifa_codi;
    
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, sqlerrm || ' NO SE ENCONTRO DATOS');
    when too_many_rows then
      raise_application_error(-20010, sqlerrm || ' HAY MUCHOS DATOS');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_abm_ciclo_fact;

  ----------------------------------------------------------------------------------------

  procedure PP_vali_cifa_tipo(i_cifa_tipo     in varchar2,
                              i_cifa_dia_fact in number,
                              i_cifa_dia_desd in number,
                              i_cifa_dia_hast in number) is
  begin
  
    if nvl(i_cifa_tipo, 'F') = 'F' then
      if i_cifa_dia_fact is null then
        raise_application_error(-20010,
                                'Debe ingresar el dia de facturacion.');
      elsif i_cifa_dia_fact < 1 then
        raise_application_error(-20010,
                                'El dia de facturacion no puede ser menor a 0.');
      end if;
    
      if i_cifa_dia_desd is not null then
        if nvl(i_cifa_dia_hast, 0) > i_cifa_dia_desd and
           i_cifa_dia_desd <> 1 then
          raise_application_error(-20010,
                                  'El dia a partir el cual se genera el ciclo, no puede ser inferior al dia a hasta el cual se genera el ciclo.');
        end if;
        if i_cifa_dia_desd < 1 then
          raise_application_error(-20010,
                                  'El dia a partir el cual se genera el ciclo no puede ser menor a 0.');
        end if;
      else
        raise_application_error(-20010,
                                'Debe ingresar el dia a partir el cual se genera el ciclo.');
      end if;
    
      if i_cifa_dia_hast is not null then
        if i_cifa_dia_hast > i_cifa_dia_desd and i_cifa_dia_desd <> 1 then
          raise_application_error(-20010,
                                  'El dia hasta el cual se genera el ciclo, no puede ser mayor al dia a partir del cual se genera el ciclo.');
        end if;
        if i_cifa_dia_hast < 1 then
          raise_application_error(-20010,
                                  'El dia hasta el cual se genera el ciclo no puede ser menor a 0.');
        end if;
      else
        raise_application_error(-20010,
                                'Debe ingresar el dia hasta el cual se genera el ciclo.');
      end if;
    end if;
  
  end pp_vali_cifa_tipo;

  ----------------------------------------------------------------------------------------

  procedure pp_borrar_registro(v_cifa_codi in number) is
  
  begin
  
    I010449.pp_validar_borrado(v_cifa_codi);
  
    if v_cifa_codi is null then
      raise_application_error(-20001,
                              'Primero debe seleccionar un registro');
    else
      delete come_cicl_fact where cifa_codi = v_cifa_codi;
    end if;
  
  end pp_borrar_registro;

  ----------------------------------------------------------------------------------------

  procedure pp_validar_borrado(v_cifa_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_soli_serv_anex_plan
     where anpl_cifa_codi = v_cifa_codi;
  
    if v_count > 0 then
      raise_application_error(-20001,
                              'Existen' || '  ' || v_count || ' ' ||
                              'planificaciones que tienen asignados este ciclo. Primero debes borrarlos o asignarlos a otro.');
    end if;
  
  end pp_validar_borrado;

end I010449;
