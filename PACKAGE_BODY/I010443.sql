
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010443" is

  procedure pp_muestra_gast_admi_atra(p_gaat_codi      in number,
                                      p_gaat_dias_desd out number,
                                      p_gaat_dias_hast out number) is
  
  begin
  
    select gaat_dias_desd, gaat_dias_hast
      into p_gaat_dias_desd, p_gaat_dias_hast
      from come_matr_gast_admi_atra
     where gaat_codi = p_gaat_codi;
  
  exception
    when no_data_found then
      p_gaat_dias_desd := null;
      p_gaat_dias_hast := null;
      raise_application_error(-20001, 'Dias de Atraso inexistente');
  end pp_muestra_gast_admi_atra;

  procedure pp_actualizar_registro_deud(p_gaim_impo_desd in number,
                                        p_gaim_impo_hast in number,
                                        p_gaim_codi      in number,
                                        p_gaim_empr_codi in number) is
  begin
  
    if p_gaim_impo_desd is null then
    
      raise_application_error(-20001, 'Debe ingresar el importe desde');
    end if;
  
    if p_gaim_impo_hast is null then
    
      raise_application_error(-20001, 'Debe ingresar el importe hasta');
    end if;
  
    pp_actu_matr_gast_admi_impo(p_gaim_impo_desd,
                                p_gaim_impo_hast,
                                p_gaim_codi,
                                p_gaim_empr_codi);
  
  end pp_actualizar_registro_deud;

  procedure pp_actu_matr_gast_admi_impo(p_gaim_impo_desd in number,
                                        p_gaim_impo_hast in number,
                                        p_gaim_codi      in number,
                                        p_gaim_empr_codi in number) is
    v_count number;
    v_codi  number;
  begin
  
    if p_gaim_codi is not null then
      select count(*)
        into v_count
        from come_matr_gast_admi_impo
       where gaim_codi = p_gaim_codi;
    end if;
  
    if nvl(v_count, 0) > 0 then
      update come_matr_gast_admi_impo
         set gaim_impo_desd = p_gaim_impo_desd,
             gaim_impo_hast = p_gaim_impo_hast
       where gaim_codi = p_gaim_codi;
    else
    
      begin
        select nvl(max(gaim_codi), 0) + 1 gaim_codi
          into v_codi
          from come_matr_gast_admi_impo;
      end;
      insert into come_matr_gast_admi_impo
        (gaim_impo_desd, gaim_impo_hast, gaim_codi, gaim_empr_codi)
      values
        (p_gaim_impo_desd, p_gaim_impo_hast, v_codi, p_gaim_empr_codi);
    
    end if;
  
    commit;
  
  end pp_actu_matr_gast_admi_impo;

  procedure pp_actualizar_registro_atra(p_gaat_dias_desd in number,
                                        p_gaat_dias_hast in number,
                                        p_gaat_codi      in number,
                                        p_gaat_empr_codi in number) is
  begin
  
    if p_gaat_dias_desd is null then
    
      raise_application_error(-20001, 'Debe ingresar el dia desde');
    end if;
  
    if p_gaat_dias_hast is null then
    
      raise_application_error(-20001, 'Debe ingresar el dia hasta');
    end if;
  
    pp_actu_matr_gast_admi_atra(p_gaat_codi,
                                p_gaat_dias_desd,
                                p_gaat_dias_hast,
                                p_gaat_empr_codi);
  
  end pp_actualizar_registro_atra;

  procedure pp_actu_matr_gast_admi_atra(p_gaat_codi      in number,
                                        p_gaat_dias_desd in number,
                                        p_gaat_dias_hast in number,
                                        p_gaat_empr_codi in number) is
    v_count number;
  begin
  
    if p_gaat_codi is not null then
      select count(*)
        into v_count
        from come_matr_gast_admi_atra
       where gaat_codi = p_gaat_codi;
    end if;
  
    if nvl(v_count, 0) > 0 then
      update come_matr_gast_admi_atra   
         set gaat_dias_desd = p_gaat_dias_desd,
             gaat_dias_hast = p_gaat_dias_hast
       where gaat_codi = p_gaat_codi;
    else
      insert into come_matr_gast_admi_atra
        (gaat_dias_desd, gaat_dias_hast, gaat_codi, gaat_empr_codi)
      values
        (p_gaat_dias_desd, p_gaat_dias_hast, p_gaat_codi, p_gaat_empr_codi);
    
    end if;
  
    commit;
  
  end pp_actu_matr_gast_admi_atra;

  procedure pp_valida_rango_desd_atra(p_gaat_codi      in number,
                                      p_gaat_dias_desd in number) is
    v_count number := 0;
  
  begin
  
    select count(*)
      into v_count
      from come_matr_gast_admi_atra
     where gaat_codi <> p_gaat_codi
       and p_gaat_dias_desd between gaat_dias_desd and gaat_dias_hast;
  
    if v_count > 0 then
      raise_application_error(-20001,
                              'El rango de dias de atraso seleccionado ya se encuentra registrado, favor verifique!');
    end if;
  
  end pp_valida_rango_desd_atra;

  procedure pp_valida_rango_hast_atra(p_gaat_dias_desd in number,
                                      p_gaat_dias_hast in number,
                                      p_gaat_codi      in number) is
    v_count number := 0;
  
  begin
  
    if p_gaat_dias_hast is not null then
      if p_gaat_dias_desd > p_gaat_dias_hast then
        raise_application_error(-20001,
                                'El Dia Hasta debe ser mayor al Dia Desde.');
      end if;
    
      select count(*)
        into v_count
        from come_matr_gast_admi_atra
       where gaat_codi <> p_gaat_codi
         and gaat_dias_desd between p_gaat_dias_desd and p_gaat_dias_hast;
    
      if v_count > 0 then
        raise_application_error(-20001,
                                'El rango de dias de atraso ya se encuentra registrado, favor verifique!');
      end if;
    end if;
  end pp_valida_rango_hast_atra;

  procedure pp_muestra_gast_admi_deud(p_gaim_codi      in number,
                                      p_gaim_impo_desd out number,
                                      p_gaim_impo_hast out number) is
  
  begin
  
    select gaim_impo_desd, gaim_impo_hast
      into p_gaim_impo_desd, p_gaim_impo_hast
      from come_matr_gast_admi_impo
     where gaim_codi = p_gaim_codi;
  
  exception
    when no_data_found then
      p_gaim_impo_desd := null;
      p_gaim_impo_hast := null;
      raise_application_error(-20001, 'Deuda inexistente');
  end pp_muestra_gast_admi_deud;

  procedure pp_valida_rango_hast_deud(p_gaim_impo_hast in number,
                                      p_gaim_impo_desd in number,
                                      p_gaim_codi      in number) is
    v_count number := 0;
  
  begin
  
    if p_gaim_impo_desd > p_gaim_impo_hast then
      raise_application_error(-20001,
                              'El Importe Hasta debe ser mayor al Importe Desde.');
    end if;
  
    select count(*)
      into v_count
      from come_matr_gast_admi_impo
     where gaim_codi <> p_gaim_codi
       and gaim_impo_desd between p_gaim_impo_desd and p_gaim_impo_hast;
  
    if v_count > 0 then
      raise_application_error(-20001,
                              'El rango de la deuda ya se encuentra registrada, favor verifique!');
    end if;
  
  end;

  procedure pp_valida_rango_desd_deud(p_gaim_codi      in number,
                                      p_gaim_impo_desd in number) is
    v_count number := 0;
  
  begin
  
    select count(*)
      into v_count
      from come_matr_gast_admi_impo
     where gaim_codi <> p_gaim_codi
       and p_gaim_impo_desd between gaim_impo_desd and gaim_impo_hast;
  
    if v_count > 0 then
      raise_application_error(-20001,
                              'El rango de la deuda seleccionada ya se encuentra registrada, favor verifique!');
    end if;
  
  end pp_valida_rango_desd_deud;

  procedure pp_actualizar_registro(p_gaad_gaim_codi in number,
                                   p_gaad_impo      in number,
                                   p_gaad_gaat_codi in number,
                                   p_gaad_empr_codi in number) is
  begin
  
    if p_gaad_gaim_codi is null then
    
      raise_application_error(-20001,
                              'Debe ingresar el codigo de la deuda');
    end if;
  
    if p_gaad_gaim_codi is null then
    
      raise_application_error(-20001, 'Debe ingresar el codigo de importe');
    end if;
  
    if p_gaad_impo is null then
      raise_application_error(-20001,
                              'Debe ingresar el gasto administrativo');
    end if;
  
    pp_actu_matr_gast_admi(p_gaad_gaim_codi,
                           p_gaad_gaat_codi,
                           p_gaad_impo,
                           p_gaad_empr_codi);
  
  end pp_actualizar_registro;

  procedure pp_actu_matr_gast_admi(p_gaad_gaim_codi in number,
                                   p_gaad_gaat_codi in number,
                                   p_gaad_impo      in number,
                                   p_gaad_empr_codi in number) is
    v_count number;
  begin
  
    if p_gaad_gaim_codi is not null and p_gaad_gaat_codi is not null then
      select count(*)
        into v_count
        from come_matr_gast_admi
       where gaad_gaim_codi = p_gaad_gaim_codi
         and gaad_gaat_codi = p_gaad_gaat_codi;
    end if;
  
    if nvl(v_count, 0) > 0 then
      update come_matr_gast_admi
         set gaad_impo = p_gaad_impo,
             gaad_fech_modi=sysdate,
             gaad_user_modi=gen_user
       where gaad_gaim_codi = p_gaad_gaim_codi
         and gaad_gaat_codi = p_gaad_gaat_codi;
    else
      insert into come_matr_gast_admi
        (gaad_gaim_codi, gaad_gaat_codi, gaad_impo, gaad_empr_codi, gaad_fech_regi,
       gaad_user_regi)
      values
        (p_gaad_gaim_codi, p_gaad_gaat_codi, p_gaad_impo, p_gaad_empr_codi,sysdate,gen_user);
    
    end if;
  
    commit;
  
  end pp_actu_matr_gast_admi;

  procedure pp_borrar_registro(p_gaad_gaim_codi in number,
                               p_gaad_gaat_codi in number) is
   
  begin
  
    --pp_validar_borrado;
  
    delete come_matr_gast_admi
     where gaad_gaim_codi = p_gaad_gaim_codi
       and gaad_gaat_codi = p_gaad_gaat_codi;
  
    commit;
  
  end pp_borrar_registro;
  
  
  PROCEDURE PP_BORRAR_REGISTRO_ATRA(p_gaat_codi in number) IS

    BEGIN
       pp_validar_borrado_atra(p_gaat_codi);
 
        delete come_matr_gast_admi_atra 
        where gaat_codi = p_gaat_codi;

      COMMIT;

END PP_BORRAR_REGISTRO_ATRA;


procedure pp_validar_borrado_atra(p_gaat_codi in number) is
v_count_atra number(10);
begin
	
  select count(*)
  into v_count_atra
  from come_matr_gast_admi
  where gaad_gaat_codi =  p_gaat_codi;
  
  if v_count_atra > 0 then 
  	   raise_application_error(-20001,'Existen'||'  '||v_count_atra||' '|| 'Gastos Administrativos asignados este Dia de Atraso. Primero debes borrarlos o asignarlos a otra');
  end if;
 
end;



procedure pp_validar_borrado_deud(p_gaim_codi in number) is
v_count_deud number(10);
begin
	
  select count(*)
  into v_count_deud
  from come_matr_gast_admi
  where gaad_gaim_codi =  p_gaim_codi;
  
  if v_count_deud > 0 then 
   raise_application_error(-20001, 'Existen'||'  '||v_count_deud||' '|| 'Gastos Administrativos asignados esta Deuda. Primero debes borrarlos o asignarlos a otra');
  end if;
 
end pp_validar_borrado_deud;

  

PROCEDURE pp_borrar_registro_deud(p_gaim_codi in number) IS


BEGIN

     pp_validar_borrado_deud(p_gaim_codi);
     

        delete come_matr_gast_admi_impo 
        where gaim_codi = p_gaim_codi;
        
      COMMIT;
      
   
  
END pp_borrar_registro_deud;



end i010443;
