
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020093" is

  -- Private type declarations
  type r_parameter is record(
    collection_name varchar2(30):='COLL_REGISTRO',
    collection_name1 varchar2(30):='COLL_BCUOTA',
    
    
    p_codi_oper_com      varchar2(100) :=to_number(general_skn.fl_busca_parametro ('p_codi_oper_com')),
  
  p_codi_timo_fcor     varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_codi_timo_fcor')),
  p_codi_timo_fcrr     varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_codi_timo_fcrr')),
  p_codi_timo_pcor     varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_codi_timo_pcor')),
  p_codi_timo_pcrr     varchar2(100):=to_number(general_skn.fl_busca_parametro ('p_codi_timo_pcrr')),    
  
  p_codi_impu_exen     varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_codi_impu_exen')),                        
  p_codi_impu_grav10   varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_codi_impu_grav10')),   
  p_codi_impu_grav5    varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_codi_impu_grav5')),   
  p_codi_mone_mmnn     varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_codi_mone_mmnn')),   
  
  
  p_cant_deci_porc     varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_cant_deci_porc')),   
  p_cant_deci_mmnn     varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmnn')),   
  p_cant_deci_mmee     varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmee')),   
  p_cant_deci_cant     varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_cant_deci_cant')),   
  p_cant_deci_prec_unit varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_cant_deci_prec_unit')),  
  
  p_indi_impr_cheq_emit  varchar2(100):= ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_impr_cheq_emit'))),  
  p_indi_vali_repe_cheq  varchar2(100):= ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_repe_cheq'))), 
  
  
  p_indi_habi_vuelto varchar2(100):= general_skn.fl_busca_parametro('p_indi_habi_vuelto_cob'),  
  
  p_codi_clie_espo     varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_codi_clie_espo')),                        
  p_codi_prov_espo     varchar2(100):= to_number(general_skn.fl_busca_parametro ('p_codi_prov_espo')), 
  p_codi_conc_dias_norm  varchar2(100):= to_number(general_skn.fl_busca_parametro('p_codi_conc_dias_norm')),     
                    
  
  p_codi_peri_actu_rrhh     varchar2(100):= to_number(ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_peri_actu_rrhh')))), 
  p_codi_peri_sgte_rrhh     varchar2(100):= to_number(ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_peri_sgte_rrhh')))), 
  
  p_fech_inic                date,
  p_fech_fini                date,           
  p_fech_inic_rrhh            date,
  p_fech_fini_rrhh            date,               
  p_codi_base varchar2(100):= pack_repl.fa_devu_codi_base 
  
    
    
  );
  parameter r_parameter;
  
  type r_bsel is record(
      s_nume number,
      conc_codi number,
      s_fech date,
      s_mes number,
      s_anho number,
      s_codi varchar2(30),
      perf_codi number
  );
  bsel r_bsel;
  
  type r_bcab is record(
     movi_codi number,
     movi_nume number,
     movi_conc_codi number,
     movi_fech_emis date,
     movi_empl_codi number,
     movi_mone_codi number,
     movi_tasa_mone number,
     movi_impo_mone number,
     movi_obse      varchar2(500),
     movi_fech_grab date,
     movi_user      varchar2(100),
     movi_mone_cant_deci number,
     movi_mone_desc_abre varchar2(100),
     conc_desc varchar2(100),
     conc_codi_alte number,
     empl_desc varchar2(100),
     empl_codi_alte number,
     s_movi_fech_emis varchar2(10),
     s_movi_fech_grab varchar2(30),
     s_movi_user varchar2(100),
     conc_indi_caja varchar2(1),
     conc_indi_cuot varchar2(1),
     movi_fech_caja date,
     cuen_codi_alte number,
     cuen_Desc varchar2(100),
     movi_codi_gest number,
     g_indi_borrado varchar2(20)
  );
  bcab r_bcab;


-----------------------------------------------
  FUNCTION fP_vali_user_empl(p_perf_codi in number, p_empl_codi in number)
    return boolean is
    --El objetivo de este procedimiento es validar que el usuario posea el........ 
    --permiso correspondiente para ver los movimientos de un empleado determinado...
    --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
    --de seguridad, que esta por debajo del nivl de pantallas.....................

    v_Count number;
  begin

    select count(*)
      into v_count
      from rrhh_perf_empl pe
     where pe.peem_perf_codi = p_perf_codi
       and pe.peem_empl_codi = p_empl_codi;

    if v_count = 0 then
      return false;
    else
      return true;
    end if;

  Exception
    When no_data_found then
      return false;
    when others then
      raise_application_error(-20010,'Error al validar usuario! ' || sqlerrm);
  end fP_vali_user_empl;

-----------------------------------------------
  procedure pp_mostrar_come_empl(p_empl_codi_alte in number,
                                 p_empl_desc      out char,
                                 p_empl_codi      out number) is
    v_esta varchar2(1);
  begin

    select empl_desc, empl_esta, empl_codi
      into p_empl_desc, v_esta, p_empl_codi
      from come_empl
     where empl_codi_alte = p_empl_codi_alte;

    if v_esta <> 'A' then
      --pl_me('El empleado se encuentra Inactivo');
      null;
    end if;

  Exception
    when no_data_found then
      p_empl_desc := null;
      p_empl_codi := null;
      --  pl_me('Empleado inexistente');
    when too_many_rows then
      raise_application_error(-20010,
                              'too_many_rows llame a su administrador');
    when others then
      raise_application_error(-20010,
                              'Error al buscar Empleado! ' || sqlerrm);
  end pp_mostrar_come_empl;

-----------------------------------------------
  procedure pp_validar_empl(p_busc_dato in varchar2, p_empr_codi in varchar2) is
    v_cant number;
  begin

    select count(*)
      into v_cant
      from come_empl
     where empl_empr_codi = p_empr_codi
       and empl_codi_alte = p_busc_dato;

    if v_cant = 0 then
      raise_application_error(-20010, 'Empleado inexistente en la Empresa');
    end if;

  exception
    when others then
      raise_application_error(-20010,'Error al validar Empleado!' || sqlerrm);
  end pp_validar_empl;

-----------------------------------------------
  procedure pp_vali_empl(empl_codi_alte in number,
                         empr_codi      in number,
                         perf_codi      in number,
                         s_empl_desc    out varchar2,
                         empl_codi      out number) is 
    
  begin
    
    --raise_application_error(-20010, 'empr_codi: '||empr_codi);
    if empl_codi_alte is not null then

      pp_validar_empl(empl_codi_alte, empr_codi);
       
      pp_mostrar_come_empl(empl_codi_alte, s_empl_desc, empl_codi);
            
      if not(fp_vali_user_empl(perf_codi, empl_Codi)) then
        raise_application_error(-20010, 'El usuario no posee permiso para consultar el empleado seleccionado');
      end if;

    else
      s_empl_desc  := null;
    end if;
    
  end pp_vali_empl;
  
-----------------------------------------------
  procedure pp_muestra_rrhh_conc(p_conc_codi_alte in number,
                                 p_conc_desc      out varchar2,
                                 p_conc_codi      out number) is

  begin
    select conc_desc, conc_codi
      into p_conc_desc, p_conc_codi
      from rrhh_conc
     where conc_codi_alte = p_conc_codi_alte;

  Exception
    when no_data_found then
      p_conc_desc := null;
      p_conc_codi := null;
      raise_application_error(-20010, 'Concepto Inexistente!');
    when others then
      raise_application_error(-20010,'Error al buscar Concepto! ' || sqlerrm);
  end pp_muestra_rrhh_conc;

-----------------------------------------------
  procedure pp_validar_concepto(i_conc_codi_alte in number) is
    v_cant number := 0;
  begin

    select count(*)
      into v_cant
      from rrhh_conc
     where conc_codi_alte = i_conc_codi_alte
     order by 1;
              
    if v_cant = 0 then 
      raise_application_error(-20010, 'Concepto inexistente!');
    end if;

  exception 
    when others then 
      raise_application_error(-20010, 'Error al buscar Concepto! ' || sqlerrm);
  end pp_validar_concepto;

-----------------------------------------------
  procedure pp_validar_item_conc(conc_codi_alte in number,
                                conc_codi      out number,
                                s_conc_desc    out varchar2) is
    
  begin
    
    if conc_codi_alte is not null then
       pp_validar_concepto(conc_codi_alte);
       pp_muestra_rrhh_conc (conc_codi_alte, s_conc_desc, conc_codi);
       null;
    else
      conc_codi := null;
      s_conc_desc  := null;
    end if;
    
  end pp_validar_item_conc;
-----------------------------------------------
  procedure pp_busca_perf_codi(o_perf_codi out number,
                               o_perf_desc out varchar2) is

  begin

    select perf_codi, perf_desc
      into o_perf_codi, o_perf_desc
      from rrhh_perf p, segu_user u
     where p.perf_codi = u.user_perf_codi
       and u.user_login = gen_user;

  Exception
    when no_data_found then
      null;
    when others then
      raise_application_error(-20010, 'Error al buscar Perfil! ' || sqlerrm);
  end pp_busca_perf_codi;
       
-----------------------------------------------
  PROCEDURE pp_cargar_datos_gestion(p_movi_Codi      in number,
                                    p_movi_codi_gest out number) is
  BEGIN

    select movi_codi, moim_fech, cuen_Codi_alte, cuen_desc
      into p_movi_codi_gest,
           bcab.movi_fech_caja,
           bcab.cuen_codi_alte,
           bcab.cuen_Desc
      from come_movi, come_movi_impo_deta, come_cuen_banc
     where movi_codi = moim_movi_codi
       and moim_cuen_codi = cuen_codi
       and movi_rrhh_movi_codi = p_movi_codi;

  exception
    When others then
      p_movi_codi_gest := null;
    
  END pp_cargar_datos_gestion;

-----------------------------------------------
  procedure pp_mostrar_caja_cuot(p_conc_codi in number,
                                 p_indi_caja out varchar2,
                                 p_indi_cuot out varchar2) is

  begin
    select c.conc_indi_caja, c.conc_indi_cuot
      into p_indi_caja, p_indi_cuot
      from rrhh_conc c
     where c.conc_codi = p_conc_codi;
     
  end pp_mostrar_caja_cuot;

-----------------------------------------------
  procedure pp_muestra_empl_codi(p_empl_codi      in number,
                                 p_empl_desc      out varchar2,
                                 p_empl_codi_alte out number) is
    v_empl_esta varchar2(1);
  begin
    select empl_codi_alte||'- '||empl_desc, empl_esta, empl_codi_alte
      into p_empl_desc, v_empl_esta, p_empl_codi_alte
      from come_empl
     where empl_codi = p_empl_codi;

    if v_empl_esta <> 'A' then
      --revisar
      --pl_mm ('El empleado se encuentra Inactivo');
      null;
    end if;

  Exception
    when no_data_found then
      p_empl_desc      := null;
      p_empl_codi_alte := null;
      --pl_me('Empleado Inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al buscar Empleado! ' || sqlerrm);
  end pp_muestra_empl_codi;

-----------------------------------------------
  procedure pp_muestra_rrhh_conc_codi(p_conc_codi      in number,
                                      p_conc_desc      out varchar2,
                                      p_conc_codi_alte out number) is

  begin
    select conc_codi_alte||'- '||conc_desc, conc_codi_alte
      into p_conc_desc, p_conc_codi_alte
      from rrhh_conc
     where conc_codi = p_conc_codi;

  Exception
    when no_data_found then
      p_conc_desc      := null;
      p_conc_codi_alte := null;
      --pl_me('Concepto Inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al buscar Concepto! ' || sqlerrm);
  end pp_muestra_rrhh_conc_codi;

-----------------------------------------------
  procedure pp_mostrar_come_mone(p_mone_codi      in number,
                                 p_mone_desc_abre out char,
                                 p_mone_cant_deci out number) is

  begin

    select mone_codi||'- '||mone_desc_abre, mone_cant_deci
      into p_mone_desc_abre, p_mone_cant_deci
      from come_mone
     where mone_codi = p_mone_codi;

  Exception
    when no_data_found then
      p_mone_Desc_abre := null;
      p_mone_cant_deci := null;
      --pl_mostrar_error('Moneda inexistente!');
    when others then
      raise_application_error(-20010, 'Error al buscar Moneda! ' || sqlerrm);
  end pp_mostrar_come_mone;

-----------------------------------------------
  procedure pp_cargar_bcab(i_movi_codi in number) is 
    
    cursor c_bcab(c_movi_codi in number) is
      select 
        MOVI_CODI,
        MOVI_NUME,
        MOVI_CONC_CODI,
        MOVI_FECH_EMIS,
        MOVI_EMPL_CODI,
        MOVI_MONE_CODI,
        MOVI_TASA_MONE,
        MOVI_IMPO_MONE,
        MOVI_OBSE,
        MOVI_FECH_GRAB,
        MOVI_USER
      from rrhh_movi
      where movi_codi = c_movi_codi;
      
  begin
    
    for x in c_bcab(i_movi_codi) loop
      
      bcab.movi_codi := x.movi_codi;
      bcab.movi_nume := x.movi_nume;
      bcab.movi_conc_codi := x.movi_conc_codi;
      bcab.movi_fech_emis := x.movi_fech_emis;
      bcab.movi_empl_codi := x.movi_empl_codi;
      bcab.movi_mone_codi := x.movi_mone_codi;
      bcab.movi_tasa_mone := x.movi_tasa_mone;
      bcab.movi_impo_mone := x.movi_impo_mone;
      bcab.movi_obse := x.movi_obse;
      bcab.movi_fech_grab := x.movi_fech_grab;
      bcab.movi_user := x.movi_user;

      
      if bcab.movi_mone_codi is not null then
        pp_mostrar_come_mone(bcab.movi_mone_codi, bcab.movi_mone_desc_abre, bcab.movi_mone_cant_deci);
      else
        bcab.movi_mone_cant_deci := 0;
      end if;
      
      if bcab.movi_conc_codi is not null then
        pp_muestra_rrhh_conc_codi (bcab.movi_conc_codi, bcab.conc_desc, bcab.conc_codi_alte);
      end if;

      if bcab.movi_empl_codi is not null then
        pp_muestra_empl_codi(bcab.movi_empl_codi, bcab.empl_desc, bcab.empl_codi_alte);
      end if;

      if bcab.movi_fech_emis  is not null then
        bcab.s_movi_fech_emis  := to_char(bcab.movi_fech_emis , 'dd-mm-yyyy');
      end if;
      
      if bcab.movi_fech_grab  is not null then
        bcab.s_movi_fech_grab  := to_char(bcab.movi_fech_grab, 'dd-mm-yyyy hh24:mi:ss');
      end if;
      
      if bcab.movi_user  is not null then
        bcab.s_movi_user := (bcab.movi_user);
      end if;  
      
      pp_mostrar_caja_cuot (bcab.movi_conc_codi, bcab.conc_indi_caja, bcab.conc_indi_cuot);
      
      pp_cargar_datos_gestion (bcab.movi_codi, bcab.movi_codi_gest);
      
    end loop;
    
    
  end pp_cargar_bcab;

-----------------------------------------------
  procedure pp_ejecutar_consulta_nume is
    v_movi_codi      number;
    v_movi_empl_codi number;
  Begin

    select movi_codi, movi_Empl_codi
      into v_movi_codi, v_movi_empl_codi
      from rrhh_movi, rrhh_conc
    
     where movi_conc_codi = conc_codi
       and (bsel.conc_codi is null or movi_conc_codi = bsel.conc_codi)
       and (bsel.s_fech is null or movi_fech_emis = bsel.s_fech)
       and (bsel.s_mes is null or
           to_number(to_char(movi_fech_emis, 'mm')) = (bsel.s_mes))
       and (bsel.s_anho is null or
           to_number(to_char(movi_fech_emis, 'yyyy')) = (bsel.s_anho))
       and (bsel.s_nume is null or movi_nume = bsel.s_nume);

    if not (fp_vali_user_empl(bsel.perf_codi, v_movi_empl_codi)) then
      --:parameter.p_indi_validar := 'S';
      raise_application_error(-20010,'El usuario no posee permiso para consultar el empleado seleccionado');
    else
    
      --REVISAR
      /*
      go_block('bcab');
      set_block_property('bcab',default_where, 'movi_codi = '||to_char(v_movi_codi));
      clear_block(no_validate) ;
      Execute_query; 
      go_block('bpie');
      */
      --raise_application_error(-20010,'v_movi_codi: '||v_movi_codi);
      pp_cargar_bcab(v_movi_codi);
    end if;

  Exception
    When no_data_found then
      raise_application_error(-20010, 'Movimiento Inexistente');
    When too_many_rows then
      raise_application_error(-20010,'Existen dos Movimientos con el mismo numero, aviste a su administrador');
      --aca deberia consultar todos los ajustes con el mismo nro..            

  End pp_ejecutar_consulta_nume;

-----------------------------------------------
  procedure pp_ejecutar_consulta_codi is
    v_movi_codi number;

    v_movi_empl_codi number;
  Begin

    select movi_codi, movi_empl_Codi
      into v_movi_codi, v_movi_empl_codi
      from rrhh_movi
     where movi_codi = bsel.s_codi;

    if not (fp_vali_user_empl(bsel.perf_codi, v_movi_empl_codi)) then

      --:parameter.p_indi_validar := 'S';
      raise_application_error(-20010,'El usuario no posee permiso para consultar el empleado seleccionado');
    else
    
      --REVISAR
      
      /*
      go_block('bcab');
      set_block_property('bcab',default_where, 'movi_codi = '||to_char(v_movi_codi));
      clear_block(no_validate) ;
      Execute_query;
      
      go_block('bpie');
      */
      pp_cargar_bcab(v_movi_codi);
    
    end if;
  Exception
    When no_data_found then
      raise_application_error(-20010, 'Movimiento Inexistente');
    When too_many_rows then
      raise_application_error(-20010,
                              'Existen dos facturas con el mismo Codigo, aviste a su administrador');
      --no deberia entrar ak..... 

  End pp_ejecutar_consulta_codi;
  
-----------------------------------------------
  procedure pp_validar_movi is
    salir  exception;
    v_nume varchar2(200);
    v_cant number := 0;

  begin

    if bsel.s_codi is not null then
      pp_ejecutar_consulta_codi;
    else
    
      v_nume := bsel.s_nume;
      --set_item_property('bsel.s_nume', lov_name, 'lov_nume');
      begin
        select count(*)
          into v_cant
          from rrhh_movi
         where movi_nume = v_nume
           and (bsel.conc_codi is null or movi_conc_codi = bsel.conc_codi)
           and (bsel.s_fech is null or movi_fech_emis = bsel.s_fech)
           and (bsel.s_mes is null or
               to_number(to_char(movi_fech_emis, 'mm')) = (bsel.s_mes))
           and (bsel.s_anho is null or
               to_number(to_char(movi_fech_emis, 'yyyy')) = (bsel.s_anho))
           and (bsel.s_nume is null or movi_nume = bsel.s_nume)
        
        ;
      end;
    
      if v_cant > 1 then
        --si existe mas de una factura con el mismo nro
        bsel.s_nume := v_nume; --para que muestre la lista de acuerdo al nuevo string
        bsel.s_codi := null; --para ver si se acepto un valor o no despues del list_values
        --list_values;
      
        if bsel.s_codi is not null then
          pp_ejecutar_consulta_codi;
        end if;
      
      elsif v_cant = 1 then
        pp_ejecutar_consulta_nume;
      elsif v_cant = 0 then
        raise_application_error(-20010,'Movimiento Inexistente');
      end if;
    end if;
    ----------------------------------------------------------------------------------

  exception
    when salir then
      null;
  end pp_validar_movi;
  
-----------------------------------------------
  procedure pp_cargar_parametros(s_nume in number,
                                  conc_codi in number,
                                  s_fech in date,
                                  s_mes in number,
                                  s_anho in number,
                                  s_codi in varchar2,
                                  perf_codi in number) is
    
  begin    
      
      bsel.s_nume := s_nume;
      bsel.conc_codi := conc_codi;
      bsel.s_fech := s_fech;
      bsel.s_mes := s_mes;
      bsel.s_anho := s_anho;
      bsel.s_codi := s_codi;
      bsel.perf_codi := perf_codi;
      
  end pp_cargar_parametros;
  
-----------------------------------------------  
  procedure pp_send_value is
    
  begin
    --SETITEM('P28_S_SALD_FINI', fp_devu_mask(nvl(bsel.mone_cant_deci,0),bsel.s_sald_fini));
    
    SETITEM('P103_MOVI_NUME',bcab.MOVI_NUME);
    SETITEM('P103_MOVI_MONE_CODI',bcab.MOVI_MONE_CODI);
    SETITEM('P103_MOVI_TASA_MONE',bcab.MOVI_TASA_MONE);
    --SETITEM('P103_MOVI_IMPO_MONE',bcab.MOVI_IMPO_MONE);
    
    SETITEM('P103_MOVI_IMPO_MONE',fp_devu_mask(nvl(bcab.movi_mone_cant_deci,0),bcab.MOVI_IMPO_MONE));
    
    SETITEM('P103_MOVI_OBSE',bcab.MOVI_OBSE);
    SETITEM('P103_MOVI_MONE_DESC_ABRE',bcab.MOVI_MONE_DESC_ABRE);
    SETITEM('P103_CONC_DESC',bcab.CONC_DESC);
    SETITEM('P103_CONC_CODI_ALTE_D',bcab.CONC_CODI_ALTE);
    SETITEM('P103_EMPL_DESC',bcab.EMPL_DESC);
    SETITEM('P103_EMPL_CODI_ALTE_D',bcab.EMPL_CODI_ALTE);
    SETITEM('P103_S_MOVI_FECH_EMIS',bcab.S_MOVI_FECH_EMIS);
    SETITEM('P103_S_MOVI_FECH_GRAB',bcab.S_MOVI_FECH_GRAB);
    SETITEM('P103_S_MOVI_USER',bcab.S_MOVI_USER);
    SETITEM('P103_CONC_INDI_CAJA',bcab.CONC_INDI_CAJA);
    SETITEM('P103_CONC_INDI_CUOT',bcab.CONC_INDI_CUOT);
    SETITEM('P103_MOVI_FECH_CAJA',bcab.MOVI_FECH_CAJA);
    SETITEM('P103_CUEN_CODI_ALTE',bcab.CUEN_CODI_ALTE);
    SETITEM('P103_CUEN_DESC',bcab.CUEN_DESC);
    SETITEM('P103_MOVI_CODI_GEST',bcab.MOVI_CODI_GEST);
    SETITEM('P103_MOVI_CODI',bcab.movi_codi);
    SETITEM('P103_MOVI_MONE_CANT_DECI',bcab.movi_mone_cant_deci);
    SETITEM('P103_S_CODI',null);
    
    
  end pp_send_value;
-----------------------------------------------
  procedure pp_consultar_datos(s_nume in number,
                                  conc_codi in number,
                                  s_fech in date,
                                  s_mes in number,
                                  s_anho in number,
                                  s_codi in varchar2,
                                  perf_codi in number) is
    
  begin
   -- raise_application_error(-20010,s_nume||''||s_codi);
    pp_cargar_parametros(s_nume,conc_codi,s_fech,s_mes,s_anho,s_codi,perf_codi);
    
     if bsel.s_codi is not null then
      pp_ejecutar_consulta_codi;
      pp_send_value;
    else
      pp_ejecutar_consulta_nume;
      pp_send_value;
    end if;
    
    
  end pp_consultar_datos;

-----------------------------------------------
  procedure pp_cargar_registros(i_nume in number) is
    cursor c_regi(i_movi_nume in number) is
     select 
      conc_desc,
      to_char(movi_nume) Nume,  
      to_char(movi_fech_emis, 'dd-mm-yy') Fecha, 
      empl_codi_alte, 
      empl_Desc,
      substr(to_char(movi_impo_mone, DECODE(MONE_CANT_DECI, 0, '999G999G990', '999G999G990D90')),1,20) importe, 
      movi_codi
      from rrhh_movi, rrhh_conc, come_empl, come_mone
      where movi_conc_codi = conc_codi
      and movi_mone_codi = mone_codi
      and movi_empl_codi = empl_codi
      and   conc_indi_auto = 'M'
      and movi_empl_codi in (
      (select pe.peem_empl_codi
      from rrhh_perf p, rrhh_perf_empl pe, segu_user u
      where p.perf_codi = pe.peem_perf_codi
      and u.user_login = gen_user
      and pe.peem_indi = 'L'
      and p.perf_codi = u.user_perf_codi)
      )
      and movi_nume = i_movi_nume
      order by conc_desc, movi_nume, movi_fech_emis;
      
  begin
    
    --Truncate collection
    apex_collection.create_or_truncate_collection(p_collection_name => parameter.collection_name);
  
    for x in c_regi(i_nume) loop 

      apex_collection.add_member(p_collection_name => parameter.collection_name,
                                 p_c001            => x.conc_desc,
                                 p_c002            => x.nume,  
                                 p_c003            => x.fecha, 
                                 p_c004            => x.empl_codi_alte, 
                                 p_c005            => x.empl_Desc,
                                 p_c006            => x.importe, 
                                 p_c007            => x.movi_codi);
    end loop;
    
  end pp_cargar_registros;
-----------------------------------------------
 procedure pp_validar_cant_docu(i_nume in number,
                                o_cant out number) is
   
   v_cant number; 
   
 begin
  -- raise_application_error(-20010,i_nume);
   if i_nume is not null then
   
     select count(*)
      into v_cant
      from rrhh_movi
      where movi_codi = i_nume;
   --  where movi_nume = i_nume;
     
     if v_cant = 0 then
       raise_application_error(-20010,'Movimiento Inexistente');
     elsif v_cant >= 2 then
       pp_cargar_registros(i_nume);
       o_cant:=v_cant;
     else
       o_cant:=v_cant;
     end if;
     
   else
     raise_application_error(-20010,'Debe de ingresar un Numero de Movimiento!');
   end if;
         
 end pp_validar_cant_docu;
 
-----------------------------------------------
 procedure pp_cargar_cuotas(p_movi_codi in number) is
    cursor c_cuot(i_movi_codi in number) is
      select d.cuot_movi_codi,
             d.cuot_nume_item,
             d.cuot_fech_venc,
             d.cuot_impo_mone,
             d.cuot_impo_mmnn,
             d.cuot_nume
      
        from rrhh_movi_cuot_deta d
       where d.cuot_movi_codi = i_movi_codi;

  begin

    --cargar cuotas
    --raise_application_error(-20010,'p_movi_codi: '||p_movi_codi);

    apex_collection.create_or_truncate_collection(p_collection_name => parameter.collection_name1);

    for y in c_cuot(p_movi_codi) loop
    
      apex_collection.add_member(p_collection_name => parameter.collection_name1,
                                 p_c001            => y.cuot_nume,
                                 p_c002            => y.cuot_fech_venc,
                                 p_c003            => y.cuot_impo_mone,
                                 p_c004            => y.cuot_impo_mmnn);
    
    end loop;

  end pp_cargar_cuotas;

-----------------------------------------------
  procedure pp_imprimir_reportes (i_movi_codi in number) is

    v_report       VARCHAR2(50);
    v_parametros   CLOB;
    v_contenedores CLOB;

    p_where varchar2(500);
    v_title varchar2(100):='File I020093 - Consulta de Movimientos Varios';
    
    begin
                            
      p_where   := p_where||' and m.movi_codi =  '|| i_movi_codi ||' ';
       
      
      V_CONTENEDORES := 'p_where:p_titulo';

      V_PARAMETROS   :=   p_where || ':' ||
                          v_title ;

      v_report       :='I020091';

      DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = gen_user;

      INSERT INTO COME_PARAMETROS_REPORT
        (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
      VALUES
        (V_PARAMETROS, v('APP_USER'), v_report, 'pdf', V_CONTENEDORES);

      commit;
    end pp_imprimir_reportes;

-----------------------------------------------

procedure pp_validar_liqu (p_movi_codi in number) is
v_count number(4);
begin

  select count(*)
  into v_count
  from rrhh_movi m, 
       rrhh_conc c, 
       rrhh_movi_cuot_deta cu
  where m.movi_conc_codi = c.conc_codi
  and m.movi_codi = cu.cuot_movi_codi
  and m.movi_codi = p_movi_codi
  and cu.cuot_liqu_codi is not null;
  
  if v_count > 0 then
  	 bcab.g_indi_borrado := 'N';
  	 raise_application_error(-20001,'El movimiento no se puede borrar porque ya fue Liquidado!!!!');
  	 
  end if;	
  




end pp_validar_liqu;
procedure pp_validar_movi_gest (p_movi_codi in number) is
salir Exception;

v_fech date;
v_Caja_codi number;
v_count number;


begin
  

  select i.moim_fech, i.moim_caja_codi
  into v_fech, v_caja_codi
  from come_movi m, come_movi_impo_deta i
  where  m.movi_codi = i.moim_movi_codi
  and m.movi_codi = p_movi_codi;

  if v_fech not between parameter.p_fech_inic and parameter.p_fech_fini then 
    bcab.g_indi_borrado := 'N';     
    raise_application_error(-20001,'La fecha del movimiento debe estar comprendida entre..'||parameter.p_fech_inic ||' y '||parameter.p_fech_fini);
      
    raise salir;                 
  end if; 
  
  if v_caja_codi is not null then
    bcab.g_indi_borrado := 'N';  
     raise_application_error(-20001,'El movimineto se encuentra en un cierre de caja id= '||v_caja_codi);     
  end if; 
  
  
  select count(*)
  into v_count 
  from come_movi_asie
  where moas_movi_codi = p_movi_codi;
  
  if v_count > 0 then
   bcab.g_indi_borrado := 'N';  
   raise_application_error(-20001,'El movimineto ya posee un asiento contable');      
    
  end if;

end pp_validar_movi_gest;

procedure pp_delete(p_movi_codi in number, p_movi_codi_gest in number) is
v_count number;

cursor c_rrhh_movi  is
select * 
from rrhh_movi m, rrhh_movi_cuot_deta mc
where m.movi_codi = mc.cuot_movi_codi
and m.movi_codi = p_movi_codi;


v_movi_id number ;
v_cuot_id number ;

begin

 --Gestion
if p_movi_codi_gest is not null then                       
  delete come_movi_impo_deta
  where  moim_movi_codi = p_movi_codi_gest;
  
  delete come_movi_conc_deta
  where  moco_movi_codi = p_movi_codi_gest;
  
  delete come_movi
  where  movi_codi = p_movi_codi_gest;
end if;
  

---------se comenta ya que la tabla no existe
 for x in c_rrhh_movi loop
      ---rrhh
      select sec_anul_rrhh_movi.nextval into v_movi_id from dual;
      
      insert into rrhh_movi_anul( 
          movi_id,
          movi_codi, 
          movi_conc_codi, 
          movi_empl_codi, 
          movi_mone_codi, 
          movi_fech_emis, 
          movi_fech_grab, 
          movi_user, 
          movi_base, 
          movi_impo_mone, 
          movi_impo_mmnn, 
          movi_tasa_mone, 
          movi_indi_cuot, 
          movi_cond_pago, 
          movi_nume, 
          movi_obse, 
          movi_auto_manu, 
          movi_cant, 
          movi_mone_codi_liqu, 
          movi_tasa_mone_liqu, 
          movi_impo_mone_liqu/*, 
          movi_mone_liqu, 
          movi_indi_extr, 
          movi_clas_codi, 
          movi_turn_codi, 
          movi_zara_codi, 
          movi_impo_mmnn_apor_patr, 
          movi_tipo_liqu, 
          movi_indi_liqu_ortr,
         movi_fech_caja,
         movi_cuen_codi*/
   )values(v_movi_id,
          x.movi_codi, 
          x.movi_conc_codi, 
          x.movi_empl_codi, 
          x.movi_mone_codi, 
          x.movi_fech_emis, 
          x.movi_fech_grab, 
          x.movi_user, 
          x.movi_base, 
          x.movi_impo_mone, 
          x.movi_impo_mmnn, 
          x.movi_tasa_mone, 
          x.movi_indi_cuot, 
          x.movi_cond_pago, 
          x.movi_nume, 
          x.movi_obse, 
          x.movi_auto_manu, 
          x.movi_cant, 
          x.movi_mone_codi_liqu, 
          x.movi_tasa_mone_liqu, 
          x.movi_impo_mone_liqu/*, 
          x.movi_mone_liqu, 
          x.movi_indi_extr, 
          x.movi_clas_codi, 
          x.movi_turn_codi, 
          x.movi_zara_codi, 
          x.movi_impo_mmnn_apor_patr, 
          x.movi_tipo_liqu, 
          x.movi_indi_liqu_ortr,
          x.movi_fech_caja,
          x.movi_cuen_codi */ 
   );
     
   select sec_anul_rrhh_cuot.nextval into v_cuot_id from dual;
      insert into rrhh_movi_cuot_deta_anul(
          cuot_id,
          cuot_movi_codi, 
          cuot_nume_item, 
          cuot_fech_venc, 
          cuot_impo_mone, 
          cuot_impo_mmnn, 
          cuot_nume, 
          cuot_base, 
          cuot_liqu_codi, 
          cuot_impo_mone_liqu, 
          cuot_impo_desc_rete, 
          cuot_indi_sala_comp
   
   )values(v_cuot_id,
          x.cuot_movi_codi, 
          x.cuot_nume_item, 
          x.cuot_fech_venc, 
          x.cuot_impo_mone, 
          x.cuot_impo_mmnn, 
          x.cuot_nume, 
          x.cuot_base, 
          x.cuot_liqu_codi, 
          x.cuot_impo_mone_liqu, 
          x.cuot_impo_desc_rete, 
          x.cuot_indi_sala_comp   
   );
   

   
   
    
  end loop;
  
      delete rrhh_movi_cuot_deta
      where  cuot_movi_codi = p_movi_codi; 
      
      delete prod_pago_jorn_deta 
      where deta_movi_codi = p_movi_codi;
      
      delete rrhh_movi
      where  movi_codi = p_movi_codi;  
      
end pp_delete;

procedure pp_borrar_registro (p_movi_codi in number,
                              p_movi_codi_gest  in number) is         
salir exception;
begin	  

pa_devu_fech_habi(parameter.p_fech_inic,parameter.p_fech_fini );  

I020091.pp_carga_fech_habi_rrhh(parameter.p_fech_inic_rrhh, parameter.p_fech_fini_rrhh);



bcab.g_indi_borrado :='S';

 if p_movi_codi_gest is not null then
 	

   pp_validar_movi_gest (p_movi_codi_gest);
   
 end if;
 pp_validar_liqu(p_movi_codi) ;

 --- 'Realmente desea borrar el Movimiento?'


pp_delete(p_movi_codi, p_movi_codi_gest);
	  
  --raise_application_error(-20001, p_movi_codi||'--'||p_movi_codi_gest);
  
end pp_borrar_registro;




procedure pp_carga_fech_habi_rrhh (p_fech_inic out date, p_fech_fini out date)is
begin
  select  peri_fech_inic
  into  p_fech_inic
  from rrhh_peri
  where peri_codi = parameter.p_codi_peri_actu_rrhh;
  
  
  select  peri_fech_fini
  into  p_fech_fini
  from rrhh_peri
  where peri_codi = parameter.p_codi_peri_sgte_rrhh;
  
  
exception
	  when no_data_found then
	    raise_application_error(-20001, 'Periodo actual o siguiente no encontrado');
	  when others then
	   raise_application_error(-20001, 'Error al recuperar el rango de fecha habilitada')  ;
  
  
end pp_carga_fech_habi_rrhh;
 
end I020093;
