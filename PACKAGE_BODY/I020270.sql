
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020270" is

  type r_variable is record(
    movi_codi      number,
    movi_fech_emis date,
    movi_asie_codi number,
    movi_oper_codi number,
    movi_timo_codi number,
    movi_codi_padr number);
  bcab r_variable;
  type r_parameter is record(
    --p_codi_timo_reem := to_number(fl_busca_parametro('p_codi_timo_reem'));
    
    --parameter.p_codi_clie_espo := to_number(fl_busca_parametro('p_codi_clie_espo'));
    --parameter.p_codi_prov_espo := to_number(fl_busca_parametro('p_codi_prov_espo'));
    p_codi_base number:= pack_repl.fa_devu_codi_base, 
    --pp_mostrar_clpr_codi (parameter.p_codi_clie_espo, 'C', parameter.p_clpr_codi_clie);
    --pp_mostrar_clpr_codi (parameter.p_codi_prov_espo, 'P', parameter.p_clpr_codi_prov);
    
    --parameter.p_indi_requ_auto_pedi := ltrim(rtrim(fl_busca_parametro('p_indi_requ_auto_pedi')));
    p_fech_inic           date,
    p_fech_fini           date,
    g_indi_borrado        varchar2(1):='S',
    p_codi_timo_rete_emit number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rete_emit'))
    
    --pa_devu_fech_habi(parameter.p_fech_inic,parameter.p_fech_fini );
    
    /*parameter.p_indi_vali_repe_cheq  := ltrim(rtrim(fl_busca_parametro('p_indi_vali_repe_cheq'))); 
      parameter.p_indi_most_mens_sali  := ltrim(rtrim(fl_busca_parametro('p_indi_most_mens_sali')));*/
    
    /*parameter.p_codi_timo_rere       := to_number(fl_busca_parametro('p_codi_timo_rere'));
      parameter.p_codi_timo_orde_pago  := to_number(fl_busca_parametro('p_codi_timo_orde_pago'));
      parameter.p_codi_timo_depo_banc  := to_number(fl_busca_parametro('p_codi_timo_depo_banc'));
      parameter.p_codi_timo_adlr       := to_number(fl_busca_parametro('p_codi_timo_adlr'));
      parameter.p_codi_timo_pcor       := to_number(fl_busca_parametro('p_codi_timo_pcor'));
      parameter.p_codi_timo_pago_pres  := to_number(fl_busca_parametro('p_codi_timo_pago_pres'));
      --parameter.p_anul_vali_codi_padr  := ltrim(rtrim(fl_busca_parametro('p_anul_vali_codi_padr')));
      --parameter.p_codi_oper_tras_mas   := to_number(fl_busca_parametro('p_codi_oper_tras_mas'));
      parameter.p_indi_moti_anul_obli  := ltrim(rtrim(fl_busca_parametro('p_indi_moti_anul_obli'))); */);
  parameter r_parameter;

  procedure pp_muestra_come_tipo_movi(p_timo_codi      in number,
                                      p_timo_Desc      out varchar2,
                                      p_timo_Desc_abre out varchar2,
                                      p_timo_afec_sald out varchar2,
                                      p_timo_dbcr      out varchar2,
                                      p_timo_tico_codi out number) is
  
  begin
  
    select timo_desc,
           timo_desc_abre,
           timo_afec_sald,
           timo_dbcr,
           timo_tico_codi
      into p_timo_desc,
           p_timo_desc_abre,
           p_timo_afec_sald,
           p_timo_dbcr,
           p_timo_tico_codi
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
  Exception
    when no_data_found then
      p_timo_desc_abre := null;
      p_timo_desc      := null;
      p_timo_afec_sald := null;
      p_timo_dbcr      := null;
    
      raise_application_error(-20001, 'Tipo de Movimiento Inexistente!');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_come_tipo_movi;

  procedure pl_muestra_come_stoc_oper(p_oper_codi      in number,
                                      p_oper_Desc      out varchar2,
                                      p_oper_Desc_abre out varchar2,
                                      p_suma_rest      out varchar2,
                                      p_afec_cost_prom out varchar2) is
  begin
    select oper_desc,
           oper_desc_abre,
           oper_stoc_suma_rest,
           oper_stoc_afec_cost_prom
      into p_oper_desc, p_oper_desc_abre, p_suma_rest, p_afec_cost_prom
      from come_stoc_oper
     where oper_codi = p_oper_codi;
  Exception
    when no_data_found then
      p_oper_desc_abre := null;
      p_oper_desc      := null;
      p_suma_rest      := null;
      p_afec_cost_prom := null;
      raise_application_error(-20001, 'Operacion de Stock Inexistente!');
    
    when others then
      raise_application_error(-20001, sqlerrm);
  end pl_muestra_come_stoc_oper;

  procedure pp_mostrar_documento(P_movi_codi           in number,
                                 p_movi_codi_out       out number,
                                 P_movi_timo_codi      out number,
                                 p_movi_clpr_codi      out number,
                                 p_movi_sucu_codi_orig out number,
                                 p_movi_depo_codi_orig out number,
                                 p_movi_sucu_codi_dest out number,
                                 p_movi_depo_codi_dest out number,
                                 p_movi_oper_codi      out number,
                                 p_movi_mone_codi out number,
                                 p_movi_fech_emis out date,
                                 p_movi_fech_grab out varchar2,
                                 p_movi_user      out varchar2,
                                 p_movi_tasa_mone out number,
                                 p_movi_tasa_mmee out number,
                                 p_movi_grav_mmnn out number,
                                 p_movi_exen_mmnn out number,
                                 p_movi_iva_mmnn  out number,
                                 p_movi_grav_mone out number,
                                 p_movi_exen_mone out number,
                                 p_movi_iva_mone  out number,
                                 p_movi_obse      out varchar2,
                                 P_MOVI_NUME_TIMB out varchar2,
                                 p_MOVI_FECH_OPER out date,
                                 p_MOVI_EMPL_CODI out number,
                                 p_movi_ortr_codi out number,
                                 p_movi_orpe_codi out number,
                                 p_movi_asie_codi out number,
                                 P_MOVI_CODI_PADR out number) is
  begin
  
    select movi_codi,
           movi_timo_codi,
           movi_clpr_codi,
           movi_sucu_codi_orig,
           movi_depo_codi_orig,
           movi_sucu_codi_dest,
           movi_depo_codi_dest,
           movi_oper_codi,
           movi_mone_codi,
           movi_fech_emis,
           TO_CHAR(movi_fech_grab, 'DD/MM/YYYY HH24:MI:SS'),
           movi_user,
           movi_tasa_mone,
           movi_tasa_mmee,
           movi_grav_mmnn,
           movi_exen_mmnn,
           movi_iva_mmnn,
           movi_grav_mone,
           movi_exen_mone,
           movi_iva_mone,
           movi_obse,
           MOVI_NUME_TIMB,
           MOVI_FECH_OPER,
           MOVI_EMPL_CODI,
           movi_ortr_codi,
           movi_orpe_codi,
           movi_asie_codi,
           MOVI_CODI_PADR
      into p_movi_codi_out,
           P_movi_timo_codi,
           p_movi_clpr_codi,
           p_movi_sucu_codi_orig,
           p_movi_depo_codi_orig,
           p_movi_sucu_codi_dest,
           p_movi_depo_codi_dest,
           p_movi_oper_codi,
           p_movi_mone_codi,
           p_movi_fech_emis,
           p_movi_fech_grab,
           p_movi_user,
           p_movi_tasa_mone,
           p_movi_tasa_mmee,
           p_movi_grav_mmnn,
           p_movi_exen_mmnn,
           p_movi_iva_mmnn,
           p_movi_grav_mone,
           p_movi_exen_mone,
           p_movi_iva_mone,
           p_movi_obse,
           P_MOVI_NUME_TIMB,
           p_MOVI_FECH_OPER,
           p_MOVI_EMPL_CODI,
           p_movi_ortr_codi,
           p_movi_orpe_codi,
           p_movi_asie_codi,
           P_MOVI_CODI_PADR
      from come_movi
     where movi_codi = P_movi_codi;
  
  end pp_mostrar_documento;

  procedure pl_muestra_come_depo(p_codi_depo in number,
                                 p_codi_sucu out number,
                                 p_desc_depo out varchar2,
                                 p_desc_sucu out varchar2) is
  
  begin
  
    select sucu_desc, sucu_codi, depo_desc, sucu_desc
      into p_desc_sucu, p_codi_sucu, p_desc_depo, p_desc_sucu
      from come_depo, come_sucu
     where depo_sucu_codi = sucu_codi
       and depo_codi = p_codi_depo;
  
  Exception
    when no_data_found then
      p_desc_depo := null;
      p_desc_sucu := null;
      p_codi_sucu := null;
      raise_application_error(-20001, 'Deposito inexistente!');
    
    when others then
      raise_application_error(-20001, sqlerrm);
  end pl_muestra_come_depo;

  procedure pp_muestra_empl(p_empl_codi in number,
                            p_empl_desc out varchar2) is
    v_empl_esta varchar2(1);
  begin
    select empl_desc, empl_esta
      into p_empl_desc, v_empl_esta
      from come_empl
     where empl_codi = p_empl_codi;
  
  Exception
    when no_data_found then
      p_empl_desc := null;
      pl_me('Empleado Inexistente!');
  end pp_muestra_empl;

  Procedure pp_muestra_come_clpr(p_ind_clpr       out VARchar2,
                                 p_clpr_desc      out VARchar2,
                                 p_clpr_ruc       out VARchar2,
                                 p_clpr_dire      out VARchar2,
                                 p_clpr_tele      out VARchar2,
                                 P_CLPR_CODI_ALTE out VARchar2,
                                 p_clpr_codi      in number) is
  
  begin
  
    select clpr_desc,
           clpr_ruc,
           clpr_dire,
           clpr_tele,
           clpr_indi_clie_prov,
           CLPR_CODI_ALTE
      into p_clpr_desc,
           p_clpr_ruc,
           p_clpr_dire,
           p_clpr_tele,
           p_ind_clpr,
           P_CLPR_CODI_ALTE
      from come_clie_prov
     where clpr_codi = p_clpr_codi;
  
  Exception
    when no_data_found then
      p_clpr_desc := null;
      p_ind_clpr  := null;
      if p_ind_clpr = 'P' then
        pl_me('Proveedor inexistente!');
      else
        pl_me('Cliente inexistente!');
      end if;
    when others then
      pl_me(SQLERRM);
  end pp_muestra_come_clpr;

  Procedure pp_mostrar_ot(p_movi_ortr_codi in number,
                          p_ortr_nume      out number,
                          p_ortr_esta      out varchar2) is
  
  begin
    select ortr_nume, ortr_esta
      into p_ortr_nume, p_ortr_esta
      from come_orde_trab
     where ortr_codi = p_movi_ortr_codi;
  
  Exception
    when no_data_found then
      pl_me('O.T. inexistente');
    when others then
      pl_me(SQLERRM);
  end pp_mostrar_ot;

  Procedure pp_mostrar_op(p_codi in number, p_nume out varchar2) is
  
  begin
    select orpe_nume
      into p_nume
      from come_orde_pedi
     where orpe_codi = p_codi;
  
  Exception
    when no_data_found then
      pl_me('O.P. inexistente');
    when others then
      pl_me(SQLERRM);
  end pp_mostrar_op;

  procedure pp_muestra_come_mone(p_movi_mone_codi in number,
                                 p_mone_desc      out varchar2,
                                 p_mone_desc_abre out varchar2,
                                 p_mone_cant_deci out varchar2) is
  begin
    select mone_desc, mone_desc_abre, mone_cant_deci
      into p_mone_desc, p_mone_desc_abre, p_mone_cant_deci
      from come_mone f
     where f.mone_codi = p_movi_mone_codi;
  Exception
    when no_data_found then
      pl_me('Moneda inexistente');
    when others then
      pl_me(SQLERRM);
  end pp_muestra_come_mone;

  procedure pp_muestra_asie_nume(p_codi in number, p_nume out number) is
  
  begin
  
    select asie_nume into p_nume from come_asie where asie_codi = p_codi;
  
  Exception
    when no_data_found then
      p_nume := null;
      pl_me('N¿mero inexistente!');
    when others then
      pl_me(SQLERRM);
  end pp_muestra_asie_nume;

  PROCEDURE pp_mostrar_apli_codi(p_movi_codi in number,
                                 p_apli_codi out number) IS
  BEGIN
  
    select apli_codi
      into p_apli_codi
      from come_apli_cost
     where apli_movi_codi = p_movi_codi;
  Exception
    when no_data_found then
      p_apli_codi := null;
    when too_many_rows then
      pl_me('Codigo duplicado');
    when others then
      pl_me(sqlerrm);
    
  END pp_mostrar_apli_codi;

  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010, v_mensaje);
  end pl_me;

  procedure pp_hab_desh_bton(p_movi_codi in number) is
  
    v_hab_desh_art           number;
    v_hab_desh_art_ortr      number;
    v_hab_desh_concepto      number;
    v_hab_desh_caja          number;
    v_hab_desh_cheque        number;
    v_hab_desh_cuot          number;
    v_hab_desh_impuesto      number;
    v_hab_desh_cancelaciones number;
  begin
  
    ----producto
    select count(*)
      into v_hab_desh_art
      from come_movi_prod_deta
     where deta_movi_codi = p_movi_codi;
  
    -----producto ortr
  
    select count(*)
      into v_hab_desh_art_ortr
      from come_movi_ortr_prod_deta
     where deta_movi_codi = p_movi_codi;
  
    -----concepto
    select count(*)
      into v_hab_desh_concepto
      from come_movi_conc_deta
     where moco_movi_codi = p_movi_codi;
  
    ---caja
    select count(*)
      into v_hab_desh_caja
      from come_movi_impo_deta
     where moim_movi_codi = p_movi_codi;
  
    ----cheque
    select count(*)
      into v_hab_desh_cheque
      from come_movi_cheq
     where chmo_movi_codi = p_movi_codi;
  
    -----cuota
    select count(*)
      into v_hab_desh_cuot
      from come_movi_cuot
     where cuot_movi_codi = p_movi_codi;
  
    ---impuesto
  
    select count(*)
      into v_hab_desh_impuesto
      from come_movi_impu_deta
     where moim_movi_codi = p_movi_codi;
  
    ---cancelacion
    select count(*)
      into v_hab_desh_cancelaciones
      from come_movi_cuot_canc
     where canc_movi_codi = p_movi_codi;
  
    apex_json.open_object;
    apex_json.write(p_name => 'v_hab_desh_art', p_value => v_hab_desh_art);
    apex_json.write(p_name  => 'v_hab_desh_art_ortr',
                    p_value => v_hab_desh_art_ortr);
    apex_json.write(p_name  => 'v_hab_desh_concepto',
                    p_value => v_hab_desh_concepto);
    apex_json.write(p_name  => 'v_hab_desh_caja',
                    p_value => v_hab_desh_caja);
    apex_json.write(p_name  => 'v_hab_desh_cheque',
                    p_value => v_hab_desh_cheque);
    apex_json.write(p_name  => 'v_hab_desh_cuot',
                    p_value => v_hab_desh_cuot);
    apex_json.write(p_name  => 'v_hab_desh_impuesto',
                    p_value => v_hab_desh_impuesto);
    apex_json.write(p_name  => 'v_hab_desh_cancelaciones',
                    p_value => v_hab_desh_cancelaciones);
    -- apex_json.write(p_name => 'mensaje', p_value => 'Actualizado correctamente');
    apex_json.close_object;
  
  end pp_hab_desh_bton;

  procedure pp_cargar_impo_deta(p_movi_codi in number,
                                p_neto      out number,
                                p_neto_mmnn out number) is
  
  begin
  
    select (case
             when d.moim_dbcr = 'D' then
              sum(d.moim_impo_mone)
             else
              0
           end - case
             when d.moim_dbcr = 'C' then
              sum(d.moim_impo_mone)
             else
              0
           end) Neto,
           
           (case
             when d.moim_dbcr = 'D' then
              sum(d.moim_impo_mmnn)
             else
              0
           end -
           
           case
             when d.moim_dbcr = 'C' then
              sum(d.moim_impo_mmnn)
             else
              0
           end) neto_mmnn
      into p_neto, p_neto_mmnn
      from come_movi_impo_deta d, come_movi m
     where d.moim_movi_codi = m.movi_codi
       and m.movi_codi = p_movi_codi
     group by moim_dbcr;
  
  exception
    when no_data_found then
      null;
    
  end pp_cargar_impo_deta;

  procedure pp_set_variable is
  
  begin

    bcab.movi_codi      := v('P23_MOVI_CODI');
    bcab.movi_fech_emis := v('P23_MOVI_FECH_EMIS');
    bcab.movi_asie_codi := v('P23_MOVI_ASIE_CODI');
    bcab.movi_oper_codi := v('P23_MOVI_OPER_CODI');
    bcab.movi_timo_codi := v('P23_MOVI_TIMO_CODI');
    bcab.movi_codi_padr := v('P23_MOVI_CODI_PADR');
    
  end pp_set_variable;

 


  procedure pp_borrar_registro is
    salir     exception;
    v_fech_inic date;
    v_fech_fini date;
  begin
    pp_set_variable;
   
    pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
 
   parameter.g_indi_borrado := 'S';

    pp_la_validacion;
 
    /*if parameter.g_indi_borrado = 'N' then
      raise salir;
    end if;*/
  
    --
    -- Nuevo bloque de borrado
    --
  
    update come_movi_impo_deta set moim_base=parameter.p_codi_base 
    where moim_movi_codi = bcab.movi_codi;
  
     delete come_movi_impo_deta where moim_movi_codi = bcab.movi_codi;
  

    --detalle de cheques
    pp_dele_cheq(bcab.movi_codi);
    
    --detalle de tarj_cupo
    pp_dele_tarj(bcab.movi_codi);
  
    update come_movi
       set movi_indi_cobr_dife = 'S'
     where movi_codi = bcab.movi_codi
       and nvl(movi_indi_cobr_dife, 'N') = 'C';
  
    --
    -- Fin nuevo bloque de borrado
    --
  
 
   
 /*exception
     when others then
       
        pl_me(Sqlerrm||' No se pudo borrar el registro');*/
    /*when salir then
      null; */
  end pp_borrar_registro;

  procedure pp_la_validacion is
    v_cont           number;
    v_oper_desc_padr char(60);
    v_movi_nume_padr number;
    v_timo_desc_padre varchar2(100);
    v_timo_tico_codi  number;
    v_count           number;
    salir exception;
  
  
    cursor c_hijos(p_codi in number) is
      select movi_codi from come_movi where movi_codi_padr = p_codi;
    cursor c_nietos(p_codi in number) is
      select movi_codi from come_movi where movi_codi_padr = p_codi;
    --que no se pueda borrar si tiene un hijo de validacion
    cursor c_hijo_vali(p_codi in number) is
      select movi_codi from come_movi where movi_codi_padr_vali = p_codi;
  
  Begin
       
  -- pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
   --raise_application_error(-20001,parameter.p_fech_inic||' '|| parameter.p_fech_fini);
    pp_valida_fech(bcab.movi_fech_emis);
    
    
    if parameter.g_indi_borrado = 'N' then
      raise salir;
    end if;
  
    declare
      v_caja_codi      number;
      v_caja_cuen_codi number;
      v_caja_fech      date;
    begin
      select max(d.moim_caja_codi)
        into v_caja_codi
        from come_movi_impo_deta d
       where d.moim_movi_codi = bcab.movi_codi
         and d.moim_caja_codi is not null;
    
      if v_caja_codi is not null then
        select c.caja_cuen_codi, c.caja_fech
          into v_caja_cuen_codi, v_caja_fech
          from come_cier_caja c
         where c.caja_codi = v_caja_codi;
        parameter.g_indi_borrado := 'N';
        pl_me('El documento forma parte de un Cierre de Caja de Fecha: ' ||
              to_char(v_caja_fech, 'dd-mm-yyyy') || ' Caja: ' ||
              v_caja_cuen_codi);
        raise salir;
      
      end if;
    exception
      when no_data_found then
        null;
    end;
  
    if bcab.movi_asie_codi is not null then
      parameter.g_indi_borrado := 'N';
    
      if parameter.g_indi_borrado = 'N' then
        pl_me('No se puede borrar porque ya tiene un asiento asignado!');
        raise salir;
      end if;
    end if;
  
    --validar que el usuario tenga acceso al tipo de movimiento y operacion
    if bcab.movi_oper_codi is not null then
      pl_vali_user_stoc_oper(bcab.movi_oper_codi, parameter.g_indi_borrado);
    
      if upper(rtrim(ltrim(parameter.g_indi_borrado))) = 'N' then
        pl_me('El usuario no posee el permiso correspondiente, para anular esta operacion de stock');
        raise salir;
      end if;
    end if;
  
    if bcab.movi_timo_codi is not null then
      pl_vali_user_tipo_movi(bcab.movi_timo_codi, parameter.g_indi_borrado);
      if upper(rtrim(ltrim(parameter.g_indi_borrado))) = 'N' then
        pl_me('El usuario no posee el permiso correspondiente, para anular este tipo de movimiento');
        raise salir;
      end if;
    end if;
  
    if bcab.movi_codi_padr is not null then
      begin
        v_oper_desc_padr  := ' ';
        v_timo_desc_padre := ' ';
      
        select oper_desc, movi_nume, timo_desc, timo_tico_codi
          into v_oper_desc_padr,
               v_movi_nume_padr,
               v_timo_desc_padre,
               v_timo_tico_codi
          from come_movi, come_stoc_oper, come_tipo_movi
         where movi_timo_codi = timo_codi(+)
           and movi_oper_codi = oper_codi(+)
           and movi_codi = bcab.movi_codi_padr;
      
        --**--
        if v_timo_tico_codi = 4 then
          begin
            select count(*)
              into v_count
              from come_movi_cheq
             where chmo_movi_codi = bcab.movi_codi;
            if v_count > 0 then
              pl_me('Este movimiento no se puede anular porque est¿ relacionado con Un movimiento Padre. ' ||
                    'Adem¿s est¿ relacionado a ' || v_count ||
                    ' cheque(s).');
              parameter.g_indi_borrado := 'N';
              raise salir;
            end if;
          end;
        
        else
          /**-
          pl_me ('Este movimiento no se puede anular porque est¿ relacionado con Un movimiento Padre. '||
                 'Debe Anular el Movimiento con Oper. de Stoc. = '||rtrim(ltrim(v_oper_desc_padr))||' y Nume. ='||to_char(v_movi_nume_padr)||
                 ' y con T. movimiento. = '||rtrim(ltrim(v_timo_desc_padre)));          
          parameter.g_indi_borrado := 'N';
          raise salir;
          -**/
          null;
        end if;
      exception
        when too_many_rows then
          /**-
           pl_me ('Este movimiento no se puede anular porque est¿ relacionado con Un movimiento Padre. '||
                  'Debe Anular el Movimiento con Oper. de Stoc. = '||rtrim(ltrim(v_oper_desc_padr))||' y Nume. ='||to_char(v_movi_nume_padr));
           parameter.g_indi_borrado := 'N';
          raise salir;
          -**/
          null;
        when others then
          raise salir;
      end;
    end if;
  
    ---Validar que el movimiento en caso que sea credito, las cuotas no
    ---tengan pagos/cance asignados..
    ---O en el caso q sea contado, (si tiene cheques), que los mismos no tengan movimientos posteriores. Ej. un deposito...
    for x in c_hijos(bcab.movi_codi) loop
      pp_valida_movi_canc(x.movi_codi);
      if parameter.g_indi_borrado = 'N' then
        raise salir;
      end if;
      pp_valida_movi_pres_canc(x.movi_codi);
      if parameter.g_indi_borrado = 'N' then
        raise salir;
      end if;
      pp_valida_cobr_cred(x.movi_codi); --planilla chica de cobradores
      if parameter.g_indi_borrado = 'N' then
        raise salir;
      end if;
      pp_valida_cheq(x.movi_codi);
      if parameter.g_indi_borrado = 'N' then
        raise salir;
      end if;
      pp_valida_tarj_cupo(x.movi_codi);
      if parameter.g_indi_borrado = 'N' then
        raise salir;
      end if;
      pp_valida_fact_depo(x.movi_codi); --descuentos de cheques - factura interes.
      if parameter.g_indi_borrado = 'N' then
        raise salir;
      end if;
      for y in c_nietos(x.movi_codi) loop
        pp_valida_movi_canc(y.movi_codi);
        if parameter.g_indi_borrado = 'N' then
          raise salir;
        end if;
        pp_valida_cheq(y.movi_codi);
        if parameter.g_indi_borrado = 'N' then
          raise salir;
        end if;
        pp_valida_fact_depo(x.movi_codi); --descuentos de cheques - factura interes.
        if parameter.g_indi_borrado = 'N' then
          raise salir;
        end if;
        pp_valida_tarj_cupo(x.movi_codi);
        if parameter.g_indi_borrado = 'N' then
          raise salir;
        end if;
      end loop;
    end loop;
  
    pp_valida_movi_canc(bcab.movi_codi);
    if parameter.g_indi_borrado = 'N' then
      raise salir;
    end if;
  
    pp_valida_movi_pres_canc(bcab.movi_codi);
    if parameter.g_indi_borrado = 'N' then
      raise salir;
    end if;
  
    pp_valida_movi_canc_adel(bcab.movi_codi);
    if parameter.g_indi_borrado = 'N' then
      raise salir;
    end if;
  
    pp_valida_cheq(bcab.movi_codi);
    if parameter.g_indi_borrado = 'N' then
      raise salir;
    end if;
  
    pp_valida_fact_depo(bcab.movi_codi); --descuentos de cheques - factura interes.
    if parameter.g_indi_borrado = 'N' then
      raise salir;
    end if;
  
    pp_valida_tarj_cupo(bcab.movi_codi);
    if parameter.g_indi_borrado = 'N' then
      raise salir;
    end if;
  
  
    --validar que la Factura/Adelanto o nota de Credito no posea Diferencia  de Cambio por saldos
    pp_valida_dife_camb(bcab.movi_codi);
    if parameter.g_indi_borrado = 'N' then
      raise salir;
    end if;
  
    pp_valida_cierre_planilla(bcab.movi_codi);
    if parameter.g_indi_borrado = 'N' then
      raise salir;
    end if;
  
    if bcab.movi_timo_codi = parameter.p_codi_timo_rete_emit then
      begin
        select count(*)
          into v_cont
          from come_orde_pago o
         where o.orpa_rete_movi_codi = bcab.movi_codi;
      
        if nvl(v_cont, 0) > 0 then
          parameter.g_indi_borrado := 'N';
          pl_me('No se puede borrar una Retencion relacionada a una Orden de Pago!.');
          raise salir;
        end if;
      exception
        when no_data_found then
          null;
      end;
    end if;
  
    pp_valida_remision;
    if parameter.g_indi_borrado = 'N' then
      raise salir;
    end if;
  
  exception
    when salir then
      parameter.g_indi_borrado := 'N';
    when others then
      pl_me(sqlerrm);
     -- parameter.g_indi_borrado := 'N';
  end pp_la_validacion;

  procedure pp_dele_cheq(p_movi_codi in number) is
    cursor c_cheq_movi is
      select chmo_cheq_codi,
             cheq_codi,
             chmo_movi_codi,
             chmo_esta_ante,
             chmo_cheq_secu,
             nvl(cheq_indi_ingr_manu, 'N') cheq_indi_ingr_manu
        from come_movi_cheq, come_cheq
       where cheq_codi = chmo_cheq_codi
         and chmo_movi_codi = p_movi_codi;
  
  begin
    
  
    for x in c_cheq_movi loop
          
          
        delete come_movi_cheq
         where chmo_movi_codi = x.chmo_movi_codi
         and chmo_cheq_codi = x.cheq_codi;
         commit;
     
    
      --solo se debe borrar el cheque en caso q el estado anterior sea nulo, o sea q dio ingreso al cheq
      --y la secuencia sea 1, adem¿s q no fuese ingresado manualmente...................................
      if x.chmo_esta_ante is null and x.chmo_cheq_secu = 1 and
         x.cheq_indi_ingr_manu = 'N' then
      
        declare
          v_caja_codi      number;
          v_caja_cuen_codi number;
          v_caja_fech      date;
        begin
          select max(c.cheq_caja_codi)
            into v_caja_codi
            from come_cheq c
           where c.cheq_codi = x.chmo_cheq_codi;
        
          if v_caja_codi is not null then
            select c.caja_cuen_codi, c.caja_fech
              into v_caja_cuen_codi, v_caja_fech
              from come_cier_caja c
             where c.caja_codi = v_caja_codi;
          
            pl_me('Un cheque forma parte de un Cierre de Caja de Fecha: ' ||
                  to_char(v_caja_fech, 'dd-mm-yyyy') || ' Caja: ' ||
                  v_caja_cuen_codi);
          end if;
        exception
          when no_data_found then
            null;
        end;
      
      
  
        delete come_movi_cheq_canj c
         where c.canj_cheq_codi_entr = x.chmo_cheq_codi
           and c.canj_movi_codi = p_movi_codi;
          
        delete come_movi_cheq
         where chmo_movi_codi = x.chmo_movi_codi
         and chmo_cheq_codi = x.chmo_cheq_codi;
        
    
         
         delete come_cheq where cheq_codi = x.chmo_cheq_codi;
         
        pl_me('time'||p_movi_codi);
    
      
      end if;
    
    
    end loop;
 
  end pp_dele_cheq;

  procedure pp_dele_tarj(p_movi_codi in number) is
    cursor c_tarj_movi is
      select mota_tacu_codi, mota_movi_codi, mota_esta_ante, mota_nume_orde
        from come_movi_tarj_cupo, come_tarj_cupo
       where mota_tacu_codi = tacu_codi
         and mota_movi_codi = p_movi_codi;
  
  begin
    for x in c_tarj_movi loop
    
      delete come_movi_tarj_cupo
       where mota_movi_codi = x.mota_movi_codi
         and mota_tacu_codi = x.mota_tacu_codi;
    
      --solo se debe borrar la tarjeta en caso q el estado anterior sea nulo, o sea q dio ingreso a la tarjeta
      --y la secuencia sea 1
      if x.mota_esta_ante is null and x.mota_nume_orde = 1 then
      
        declare
          v_caja_codi      number;
          v_caja_cuen_codi number;
          v_caja_fech      date;
        begin
          select max(c.tacu_caja_codi)
            into v_caja_codi
            from come_tarj_cupo c
           where c.tacu_codi = x.mota_tacu_codi;
        
          if v_caja_codi is not null then
            select c.caja_cuen_codi, c.caja_fech
              into v_caja_cuen_codi, v_caja_fech
              from come_cier_caja c
             where c.caja_codi = v_caja_codi;
          
            pl_me('Un cupon de TC forma parte de un Cierre de Caja de Fecha: ' ||
                  to_char(v_caja_fech, 'dd-mm-yyyy') || ' Caja: ' ||
                  v_caja_cuen_codi);
          end if;
        exception
          when no_data_found then
            null;
        end;
      
      
      
        delete come_tarj_cupo where tacu_codi = x.mota_tacu_codi;
      end if;
    end loop;
  end;

  procedure pp_valida_fech(p_fech in date) is
    salir Exception;
  begin
    if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
      pl_me('La fecha del movimiento debe estar comprendida entre..' ||
            to_char(parameter.p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
            to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
      parameter.g_indi_borrado := 'N';
    
      raise salir;
    end if;
  
  exception
    when salir then
      null;
    
  end pp_valida_fech;

  --El objetivo de este procedimiento es validar que el usuario posea el........ 
  --permiso correspondiente para insertar o anular una operacion de Stock......
  --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
  --de seguridad, que est¿ por debajo del nivl de pantallas.....................

  procedure pl_vali_user_stoc_oper(p_oper_codi  in number,
                                   p_indi_si_no out varchar2) is
    v_oper_codi number;
  begin
  
    select usop_oper_codi
      into v_oper_codi
      from segu_user, segu_user_stoc_oper
     where user_codi = usop_user_codi
       and upper(rtrim(ltrim(user_login))) = upper(user)
       and usop_oper_Codi = p_oper_codi;
  
    p_indi_si_no := 'S';
  
  Exception
    When no_data_found then
      p_indi_si_no := 'N'; --no tiene habilitado
    when others then
      pl_me(sqlerrm);
    
  end pl_vali_user_stoc_oper;

  --El objetivo de este procedimiento es validar que el usuario posea el........ 
  --permiso correspondiente para insertar o anular un tipo de movimiento dado...
  --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
  --de seguridad, que est¿ por debajo del nivl de pantallas.....................

  procedure pl_vali_user_tipo_movi(p_timo_codi  in number,
                                   p_indi_si_no out varchar2) is
    v_timo_codi number;
  begin
  
    select usmo_timo_codi
      into v_timo_codi
      from segu_user, segu_user_tipo_movi
     where user_codi = usmo_user_codi
       and upper(rtrim(ltrim(user_login))) = upper(user)
       and usmo_timo_Codi = p_timo_codi;
  
    p_indi_si_no := 'S';
  
  Exception
    When no_data_found then
      p_indi_si_no := 'N'; --no tiene habilitado
    when others then
      pl_me(sqlerrm);
    
  end;

  procedure pp_valida_movi_canc(p_movi_codi in number) is
    v_cont number;
    salir  exception;
  
  begin
  
    select count(*)
      into v_cont
      from come_movi_cuot_canc
     where canc_cuot_movi_codi = p_movi_codi;
  
    if v_cont > 0 then
      pl_me('Primero debe anular los pagos/Cancelaciones asignados a este Movimiento');
      parameter.g_indi_borrado := 'N';
      raise salir;
    
    end if;
  
  Exception
    When salir then
      null;
  end pp_valida_movi_canc;

  procedure pp_valida_movi_pres_canc(p_movi_codi in number) is
    v_cont number;
    salir  exception;
  
  begin
  
    select count(*)
      into v_cont
      from come_movi_cuot_pres_canc
     where canc_cupe_movi_codi = p_movi_codi;
  
    if v_cont > 0 then
      pl_me('Primero debe anular las Cancelaciones asignadas a este Movimiento');
      parameter.g_indi_borrado := 'N';
      raise salir;
    
    end if;
  
  Exception
    When salir then
      null;
  end;

  procedure pp_valida_cobr_cred(p_movi_codi in number) is
    v_cont number;
    salir  exception;
  begin
  
    select count(*)
      into v_cont
      from come_cobr_cred_deta
     where deta_movi_codi = p_movi_codi;
  
    if v_cont > 0 then
      pl_me('Primero debe Anular la Planilla chica de Cobradores.');
      parameter.g_indi_borrado := 'N';
      raise salir;
    end if;
  
  Exception
    When salir then
      null;
  end pp_valida_cobr_cred;

  --validar que los cheques relacionados con el documento, 
  --no posea operaciones posteriores.....................

  procedure pp_valida_cheq(p_movi_codi in number) is
    cursor c_cheq_movi is
      select c.cheq_codi,
             c.cheq_nume,
             b.banc_desc,
             c.cheq_serie,
             mc.chmo_cheq_secu
        from come_movi_cheq mc, come_cheq c, come_banc b
       where mc.chmo_cheq_codi = c.cheq_codi
         and b.banc_codi = c.cheq_banc_codi
         and mc.chmo_movi_codi = p_movi_codi;
    v_count number;
    salir   exception;
  begin
  
    for x in c_cheq_movi loop
      select count(*)
        into v_count
        from come_movi_cheq
       where chmo_cheq_codi = x.cheq_codi;
    
      if v_count > x.chmo_cheq_secu then
        pl_me('No se puede borrar el documento, porque el cheque _Nro. ' ||
              x.cheq_nume || ' Serie ' || x.cheq_serie ||
              ' de la entidad Bancaria ' || x.banc_desc ||
              ' posee movimiento/s posterior/es');
        parameter.g_indi_borrado := 'N';
        raise salir;
      end if;
    end loop;
  
  Exception
    When salir then
      null;
    
  end;

  procedure pp_valida_tarj_cupo(p_movi_codi in number) is
    cursor c_cupo_movi is
      select mota_tacu_codi, mota_movi_codi, mota_esta_ante, mota_nume_orde
        from come_movi_tarj_cupo, come_tarj_cupo
       where mota_tacu_codi = tacu_codi
         and mota_movi_codi = p_movi_codi;
    v_count number;
    salir   exception;
  begin
  
    for x in c_cupo_movi loop
      select count(*)
        into v_count
        from come_movi_tarj_cupo
       where mota_tacu_codi = x.mota_tacu_codi;
    
      if v_count > x.mota_nume_orde then
        pl_me('No se puede borrar el documento, porque el cupon posee movimiento/s posterior/es');
        parameter.g_indi_borrado := 'N';
        raise salir;
      end if;
    end loop;
  
  Exception
    When salir then
      null;
  end pp_valida_tarj_cupo;

  procedure pp_valida_fact_depo(p_movi_codi in number) is
    cursor c_movi_depo is
      select f.movi_codi, f.movi_nume
        from come_movi f, come_movi_fact_depo fd
       where f.movi_codi = fd.fade_movi_codi_fact -- factura
         and fd.fade_movi_codi_depo = p_movi_codi; -- deposito
    cursor c_movi_fact is
      select d.movi_codi, d.movi_nume
        from come_movi d, come_movi_fact_depo fd
       where d.movi_codi = fd.fade_movi_codi_depo -- deposito
         and fd.fade_movi_codi_fact = p_movi_codi; -- factura
    v_count number;
    salir   exception;
  begin
    --- verifica si deposito tiene factura..
    for x in c_movi_depo loop
      select count(*)
        into v_count
        from come_movi_fact_depo
       where fade_movi_codi_fact = x.movi_codi;
    
      if nvl(v_count, 0) > 0 then
        pl_me('No se puede borrar el documento, porque el deposito posee una factura de descuento Nro ' ||
              x.movi_nume || '.');
        parameter.g_indi_borrado := 'N';
        raise salir;
      end if;
    end loop;
    ---verifica factura.
    for y in c_movi_fact loop
      select count(*)
        into v_count
        from come_movi_fact_depo
       where fade_movi_codi_depo = y.movi_codi;
    
      parameter.g_indi_borrado := 'S';
      exit;
    end loop;
  
  Exception
    When salir then
      null;
    
  end pp_valida_fact_depo;

  procedure pp_valida_movi_canc_adel(p_movi_codi in number) is
    v_cont number;
    salir  exception;
  begin
  
    select count(*)
      into v_cont
      from come_movi_adel_prod_canc
     where canc_movi_codi_adel = p_movi_codi;
  
    if v_cont > 0 then
      --:parameter.p_indi_vali_borr := 'N';
      pl_me('Primero debe anular las Cancelaciones asignados a este Movimiento');
      parameter.g_indi_borrado := 'N';
      raise salir;
    end if;
  
  Exception
    when salir then
      --:parameter.p_indi_vali_borr := 'N';
      NULL;
    
  end;

  procedure pp_valida_dife_camb(p_codi in number) is
  
    cursor c_dife_camb is
      select dica_fech_hasta
        from come_movi_dife_camb
       where dica_movi_codi = p_codi
       order by 1;
  
  Begin
  
    for x in c_dife_camb loop
      pl_me('Esta factura est¿ relacionada a la diferencia de cambio por saldos del periodod ' ||
            to_char(x.dica_fech_hasta, 'mm-yyyy'));
      parameter.g_indi_borrado := 'N';
      exit;
    end loop;
  
  end;
  PROCEDURE pp_valida_cierre_planilla(p_movi_codi in number) IS
    cursor cv_cuot is
      select canc_cupe_movi_codi, c.cupe_nume_cuot
        from come_movi_cuot_pres_canc cc, come_movi_cuot_pres c
       where cupe_movi_codi = canc_cupe_movi_codi
         and cupe_fech_venc = canc_cupe_fech_venc
         and canc_movi_codi = p_movi_codi;
  
    v_deta_cocr_codi number;
 
  
    v_count number;
  BEGIN
    --------
    for r in cv_cuot loop
      begin
        select deta_cocr_codi
          into v_deta_cocr_codi
          from come_cobr_cred_deta_canc z, come_cobr_cred c
         where cocr_codi = z.deta_cocr_codi
           and z.deta_movi_codi = r.canc_cupe_movi_codi
           and z.deta_nume_cuot = r.cupe_nume_cuot
           and nvl(c.cocr_esta, 'P') = 'P';
      
      exception
        when no_data_found then
          select count(deta_cocr_codi)
            into v_count
            from come_cobr_cred_deta_canc z, come_cobr_cred c
           where cocr_codi = z.deta_cocr_codi
             and z.deta_movi_codi = r.canc_cupe_movi_codi
             and z.deta_nume_cuot = r.cupe_nume_cuot
             and nvl(c.cocr_esta, 'P') = 'C';
          if v_count > 0 then
            pl_mE('Este documento est¿ relacionado a una planilla chica de cobradores ya cerrada.');
            parameter.g_indi_borrado := 'N';
            exit;
          end if;
      end;
    end loop;
  
  exception
    when no_data_found then
      null;
  END;

  PROCEDURE pp_valida_remision IS
    v_cont number(2);
  BEGIN
    select count(*)
      into v_cont
      from come_remi r
     where r.remi_come_movi_rece is not null
       and r.remi_movi_codi = bcab.movi_codi;
  
    if v_cont >= 1 then
      pl_me('Debe borrar la recepcion de la remision!!!!');
      parameter.g_indi_borrado := 'N';
    end if;
  END pp_valida_remision;

end I020270;
