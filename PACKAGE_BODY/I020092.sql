
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020092" is

  -- private type declarations
  type r_parameter is record (
      p_codi_peri_actu_rrhh number       := to_number(general_skn.fl_busca_parametro('p_codi_peri_actu_rrhh')),
      collection_name       varchar2(30) := 'COLL_AUSE',
      p_codi_conc_dias_norm number       := to_number(general_skn.fl_busca_parametro('p_codi_conc_dias_norm')),
      p_codi_base           number       := pack_repl.fa_devu_codi_base
  
  );
  parameter r_parameter;
  
  type r_bcab is record (
     ause_peri_codi number,
     peri_anho_mess date,
     fech_inic      date,
     fech_fini      date,
     empl_codi number
  
  );
  bcab r_bcab;
  
-----------------------------------------------
  procedure pp_muestra_rrhh_peri(p_peri_codi in number,
                                 p_fech_inic out date,
                                 p_fech_fini out date,
                                 p_anho_mess out date) is
  begin

    select peri_fech_inic, peri_fech_fini, peri_anho_mess
      into p_fech_inic, p_fech_fini, p_anho_mess
      from rrhh_peri
     where peri_codi = p_peri_codi;

  exception
    when no_data_found then
      p_fech_inic := null;
      p_fech_fini := null;
      raise_application_error(-20010, 'Periodo inexistente');
    when too_many_rows then
      raise_application_error(-20010, 'too_many_rows llame a su administrador');
    when others then
      raise_application_error(-20010, 'Error al consultar Periodo! ' || sqlerrm);
    
  end pp_muestra_rrhh_peri;

-----------------------------------------------
  procedure pp_muestra_rrhh_tipo_ause(p_tiau_codi in number,
                                      p_tiau_desc out varchar2) is
  begin

    if p_tiau_codi is not null then
      select tiau_desc
        into p_tiau_desc
        from rrhh_tipo_ause
       where tiau_codi = p_tiau_codi;
     
    else
      p_tiau_desc := null;
    end if;

  Exception
    when no_data_found then
      p_tiau_desc := null;
      raise_application_error(-20010, 'Tipo de Ausencia inexistente');
    when too_many_rows then
      raise_application_error(-20010, 'too_many_rows llame a su administrador');
    when others then
      raise_application_error(-20010, 'Error al buscar Tipo de Ausencia! ' || sqlerrm);
  end pp_muestra_rrhh_tipo_ause;

-----------------------------------------------
  procedure pp_cargar_ause is
    
    cursor cur_ause(i_ause_peri_codi in number) is
     select 
        rr.ause_empl_codi,
        rr.ause_peri_codi,
        rr.ause_fech,
        rr.ause_tiau_codi,
        rr.ause_minu,
        rr.ause_obse,
        rr.ause_indi_feri,
        rr.ause_indi_saba,
        em.empl_codi_alte,
        em.empl_desc
      from rrhh_ause rr, COME_EMPL em
      where ause_peri_codi = i_ause_peri_codi
      and   rr.ause_minu   > 0
      and   em.empl_codi   = rr.AUSE_EMPL_CODI;
        
    v_tiau_desc varchar2(100);
           
  begin
    
    if bcab.ause_peri_codi is not null then
      
      apex_collection.create_or_truncate_collection(p_collection_name => parameter.collection_name);
      
      for x in cur_ause(bcab.ause_peri_codi) loop
        
        if x.ause_tiau_codi is not null then
          pp_muestra_rrhh_tipo_ause(x.ause_tiau_codi, v_tiau_desc);
        end if; 
        
        apex_collection.add_member(p_collection_name => parameter.collection_name,
                                    p_c001            =>  x.ause_empl_codi,
                                    p_c002            =>  x.ause_peri_codi,
                                    p_c003            =>  x.ause_fech,
                                    p_c004            =>  x.ause_tiau_codi,
                                    p_c005            =>  x.ause_minu,
                                    p_c006            =>  x.ause_obse,
                                    p_c007            =>  x.ause_indi_feri,
                                    p_c008            =>  x.ause_indi_saba,
                                    p_c009            =>  v_tiau_desc,
                                    p_c010            =>  x.empl_codi_alte,
                                    p_c011            =>  x.empl_desc
                                    );
                                 
        null; 
      end loop;
      
    end if;
    
  end pp_cargar_ause;
  
-----------------------------------------------
  procedure pp_iniciar(ause_peri_codi out number,
                       peri_anho_mess out date,
                       fech_inic      out date,
                       fech_fini      out date) is
  begin    
    --pp_cargar_parametros;
    
    bcab.ause_peri_codi := parameter.p_codi_peri_actu_rrhh;
    ause_peri_codi      := bcab.ause_peri_codi;
    
    if bcab.ause_peri_codi is not null then
      pp_muestra_rrhh_peri(bcab.ause_peri_codi, bcab.fech_inic, bcab.fech_fini, bcab.peri_anho_mess);
      peri_anho_mess := bcab.peri_anho_mess;
      fech_inic      := bcab.fech_inic;
      fech_fini      := bcab.fech_fini;
      
      pp_cargar_ause;
      
    else
      peri_anho_mess := null;
      fech_inic      := null;
      fech_fini      := null;
      
    end if;  
    
  end;
  
-----------------------------------------------
  procedure pp_validar_empl(p_empl_codi_alte in number,
                            p_empr_codi      in varchar2
                            ) is
    v_emple_codi number;

  begin

    begin
    
      select empl_codi_alte
        into v_emple_codi
        from come_empl
       where empl_empr_codi = p_empr_codi
         and empl_codi_alte = p_empl_codi_alte;
    
    end;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Empleado inexistente en la Empresa');
    when too_many_rows then
      raise_application_error(-20010, 'Codigo de Empleado duplicado, llame a su administrador');
    when others then
      raise_application_error(-20010, 'Error al validar Empleado! ' || sqlerrm);
  end pp_validar_empl;

-----------------------------------------------
  procedure pp_validar_ause(i_empl_codi in number,
                            i_fech_inic in date,
                            i_fech_fini in date
                            ) is
    v_count number(4);
  begin
    bcab.empl_codi := i_empl_codi;
    bcab.fech_inic := i_fech_inic;
    bcab.fech_fini := i_fech_fini;

    select count(*)
      into v_count
      from rrhh_movi m, rrhh_conc c, rrhh_movi_cuot_deta cu
     where m.movi_conc_codi = c.conc_codi
       and m.movi_codi = cu.cuot_movi_codi
       and m.movi_empl_codi = bcab.empl_codi
       and cu.cuot_fech_venc between bcab.fech_inic and bcab.fech_fini
       and m.movi_conc_codi = parameter.p_codi_conc_dias_norm -- en caso que tnga una liquidacion, adel vacaciones..
       and c.conc_indi_auto = 'A'; -- mov generados automaticamente

    if v_count > 0 then
    
      raise_application_error(-20010,'El empleado tiene generado conceptos de manera automatica en estas fechas!');
    
    end if;

  end pp_validar_ause;


-----------------------------------------------
  procedure pp_validar_ause is
    v_count number(4);
  begin

    select count(*)
      into v_count
      from rrhh_movi m, rrhh_conc c, rrhh_movi_cuot_deta cu
     where m.movi_conc_codi = c.conc_codi
       and m.movi_codi = cu.cuot_movi_codi
       and m.movi_empl_codi = bcab.empl_codi
       and cu.cuot_fech_venc between bcab.fech_inic and bcab.fech_fini
       and m.movi_conc_codi = parameter.p_codi_conc_dias_norm -- en caso que tnga una liquidacion, adel vacaciones..
       and c.conc_indi_auto = 'A'; -- mov generados automaticamente

    if v_count > 0 then
      raise_application_error(-20010, 'El empleado tiene generado conceptos de manera automatica en estas fechas');
    end if;

  end pp_validar_ause;

-----------------------------------------------
  procedure pp_indi_feri(i_ause_fech      in  date,
                         o_ause_indi_feri out varchar2
                         ) is
    
    v_feri_fech date;
    
  begin
    
    select feri_fech
    into   v_feri_fech
    from   come_feri
    where  feri_fech = i_ause_fech;
    
    o_ause_indi_feri := 'S';
      
  exception
    when no_data_found then
      o_ause_indi_feri := 'N';
    when too_many_rows then
      raise_application_error(-20010, 'Error Feriado duplicado, llame a su administrador!');
    when others then
      raise_application_error(-20010, 'Error al validar feriado! ' || sqlerrm);
      
  end pp_indi_feri;
  
-----------------------------------------------
  procedure pp_validar_fecha(i_fech_inic      in date,
                             i_fech_fini      in date,
                             i_ause_fech      in date,
                             o_ause_indi_feri out varchar2
                             ) is
    
  begin
    
    if i_ause_fech is null then
      raise_application_error(-20010, 'Debe ingresar una fecha!');
    end if;
    
    if i_ause_fech < i_fech_inic or i_ause_fech > i_fech_fini then
      
      raise_application_error(-20010, 'La fecha debe de estar comprendida entre ' || i_fech_inic ||' y ' || i_fech_fini ||' .!');
    else
      --verifica Feriado
      pp_indi_feri(i_ause_fech,o_ause_indi_feri);
      --raise_application_error(-20010, 'o_ause_indi_feri: '||o_ause_indi_feri);
    end if;
    
  end pp_validar_fecha;

-----------------------------------------------
  procedure pp_validar_ause_minu(i_ause_minu      in number,
                                 i_ause_tiau_codi in number
                                 ) is

  begin

    if nvl(i_ause_minu, 0) < 0 or nvl(i_ause_minu, 0) > 480 then
      raise_application_error(-20010, 'Los minutos de ausencia no pueden superar las 8hs. ');
    end if;

    if i_ause_tiau_codi is not null and nvl(i_ause_minu, 0) <= 0 then
      raise_application_error(-20010, 'La cantidad de minutos debe ser mayor a 0.');
    end if;

    if i_ause_tiau_codi is null then
      raise_application_error(-20010, 'Primero debe ingresar el Tipo de Ausencia del Empleado.');
    end if;
    

  end pp_validar_ause_minu;

-----------------------------------------------
  procedure pp_indi_sabados_domingos(/*i_fech_inic      in  date,
                                     i_fech_fini      in  date,*/
                                     i_ause_fech      in  date,
                                     o_ause_indi_domi out varchar2,
                                     o_ause_indi_saba out varchar2
                                     )is
    
    
    v_dia       varchar2(30);
    
    
  begin
    
    select upper(rtrim(ltrim(to_char(to_date(i_ause_fech, 'dd/mm/yyyy'), 'day')))) dia
    into   v_dia
    from   dual;
    
    --para los domingos
    if v_dia = 'DOMINGO' then
      o_ause_indi_domi := 'S';
    else
      o_ause_indi_domi := 'N';
    end if;
    
    --para los sabados
    if v_dia = 'SABADO' then
      o_ause_indi_saba := 'S';
    else
      o_ause_indi_saba := 'N';
    end if;
                            
  end pp_indi_sabados_domingos;
  
-----------------------------------------------
  procedure pp_actualizar_registro (i_empl_codi_alte in number,
                                    i_ause_fech      in date,
                                    i_ause_tiau_codi in number,
                                    i_ause_minu      in number,
                                    i_ause_obse      in varchar2,
                                    i_fech_inic      in date,
                                    i_fech_fini      in date,
                                    i_indi           in varchar2,
                                    i_ause_peri_codi in number,
                                    i_empr_codi      in number,
                                    o_indi_msg       out varchar2
                                    )is
                                    
                                    
    v_ause_indi_feri varchar2(2);
    v_ause_indi_domi varchar2(2);
    v_ause_indi_saba varchar2(2);
    v_indi_feri      varchar2(2);
    v_cant           number;
  begin
    
    if i_empl_codi_alte is null then
       raise_application_error(-20010, 'Debe ingresar el Empleado!');
    end if;
    
    if i_ause_fech is null then
       raise_application_error(-20010, 'Debe de ingresar una fecha!');
    end if;
    
    --validaciones
    pp_validar_empl(i_empl_codi_alte,i_empr_codi);
    pp_validar_fecha(i_fech_inic,i_fech_fini,i_ause_fech,v_ause_indi_feri);
    pp_validar_ause_minu(i_ause_minu,i_ause_tiau_codi);
    pp_indi_sabados_domingos(i_ause_fech,v_ause_indi_domi,v_ause_indi_saba);
    
    if v_ause_indi_feri = 'S' or v_ause_indi_domi = 'S' then
      v_indi_feri := 'S';
    elsif v_ause_indi_feri = 'N' or v_ause_indi_domi = 'N' then
      v_indi_feri := 'N';
    elsif v_ause_indi_feri = 'S' or v_ause_indi_domi = 'N' then
      v_indi_feri := 'S';
    elsif v_ause_indi_feri = 'N' or v_ause_indi_domi = 'S' then
      v_indi_feri := 'S';
    end if;
      
    --operaciones
    if i_indi = 'I' then
      
      pp_validar_ause(i_empl_codi_alte,i_fech_inic,i_fech_fini);
                            
      select count(*)
      into v_cant
      from  rrhh_ause
      where ause_empl_codi = i_empl_codi_alte
        and ause_peri_codi = i_ause_peri_codi
        and ause_fech      = i_ause_fech;
      
      if v_cant >=1 then
        raise_application_error(-20010, 'Esta ausencia ya fue cargada!');
      end if;
      
      insert into rrhh_ause
        (ause_empl_codi,
         ause_peri_codi,
         ause_fech,
         ause_tiau_codi,
         ause_minu,
         ause_indi_feri,
         ause_obse,
         ause_base,
         ause_indi_saba,
         ause_just)
      values
        (i_empl_codi_alte,
         i_ause_peri_codi,
         i_ause_fech,
         i_ause_tiau_codi,
         i_ause_minu,
         v_indi_feri,
         i_ause_obse,
         parameter.p_codi_base,
         v_ause_indi_saba,
         null);
         
       o_indi_msg := 'I';
       
       apex_application.g_print_success_message := 'Registro insertado correctamente!';

    elsif i_indi = 'U' then
      
      pp_validar_ause(i_empl_codi_alte,i_fech_inic,i_fech_fini);
      
      select count(*)
      into  v_cant
      from  rrhh_ause
      where ause_empl_codi = i_empl_codi_alte
        and ause_peri_codi = i_ause_peri_codi
        and ause_fech      = i_ause_fech;
      
      if v_cant <=0 then
        raise_application_error(-20010, 'Este registro no existe!');
      end if;
      
      update rrhh_ause
         set ause_tiau_codi = i_ause_tiau_codi,
             ause_minu      = i_ause_minu,
             ause_indi_feri = v_indi_feri,
             ause_obse      = i_ause_obse,
             ause_base      = parameter.p_codi_base,
             ause_indi_saba = v_ause_indi_saba
       where ause_empl_codi = i_empl_codi_alte
         and ause_peri_codi = i_ause_peri_codi
         and ause_fech      = i_ause_fech;
         
      o_indi_msg := 'U';
      
      apex_application.g_print_success_message := 'Registro actualizado correctamente!';
      
    else
      raise_application_error(-20010, 'Accion no definida contacte con el Soporte Tecnico!');
    end if;
      
  end pp_actualizar_registro;

-----------------------------------------------
  procedure pp_eliminar_registro(i_empl_codi_alte in number,
                                 i_ause_fech      in date,
                                 i_ause_peri_codi in number,
                                 i_indi           in varchar2,
                                 i_fech_inic      in date,
                                 i_fech_fini      in date,
                                 o_indi_msg       out varchar2
                                 ) is
    v_cant number;
    
  begin
    
    if i_indi = 'D' then
    
      pp_validar_ause(i_empl_codi_alte,i_fech_inic,i_fech_fini);
      
      select count(*)
      into  v_cant
      from  rrhh_ause
      where ause_empl_codi = i_empl_codi_alte
        and ause_peri_codi = i_ause_peri_codi
        and ause_fech      = i_ause_fech;
      
      if v_cant = 0 then
        raise_application_error(-20010, 'Este registro no existe!');
      end if;
      
        
      delete rrhh_ause
       where ause_empl_codi = i_empl_codi_alte
         and ause_peri_codi = i_ause_peri_codi
         and ause_fech      = i_ause_fech;
         
      o_indi_msg := 'D';
      apex_application.g_print_success_message := 'Registro eliminado correctamente!';
      
    else
      raise_application_error(-20010, 'Accion no definida contacte con el Soporte Tecnico!');
    end if;
  
  exception 
    when others then
        raise_application_error(-20010, 'Error al borrar registro! '||sqlerrm);
        
  end pp_eliminar_registro;
    
-----------------------------------------------
  procedure pp_actualizar_grilla(i_ause_peri_codi in number) is
    
  begin
    
    bcab.ause_peri_codi := i_ause_peri_codi;
    
    pp_cargar_ause;
    
  end pp_actualizar_grilla;
    
-----------------------------------------------

end i020092;
