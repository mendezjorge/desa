
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I0202024" is
  g_come_movi come_movi%rowtype;
  g_user      varchar2(100) := gen_user;
  type r_bortr is record(
    sum_ador_impo number,
    ortr_codi     number,
    s_ador_impo   number);
  bortr r_bortr;

  /* type r_forma_pago is record(
  moim_cuen_codi number,
  vale_codi number );
  bfp r_forma_pago; */

  type r_variable is record(
    s_impo              number,
    movi_mone_cant_deci number,
    movi_timo_indi_caja varchar2(2),
    s_impo_cheq         number,
    s_impo_efec         number,
    s_impo_tarj         number,
    s_impo_adel         number,
    s_impo_vale         number,
    s_impo_viaj         number,
    s_impo_sald         number,
    cont_codi           number,
    p_para_inic         varchar2(5),
    w_movi_codi         number,
    w_movi_fech_emis    date,
    movi_tare_codi      number,
    movi_tico_codi      number,
    s_impo_rete         number,
    s_impo_rete_rent    number,
    w_movi_sald         number);
  var r_variable;

  type r_parameter is record(
    p_form_impr_reci_adel varchar2(10) := to_number(general_skn.fl_busca_parametro('p_form_impr_reci_adel')),
    p_codi_timo_adle      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_adle')),
    p_codi_timo_adlr      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_adlr')),
    p_codi_timo_valr      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_valr')),
    p_codi_timo_dadle     number := to_number(general_skn.fl_busca_parametro('p_codi_timo_dadle')),
    p_codi_timo_dadlr     number := to_number(general_skn.fl_busca_parametro('p_codi_timo_dadlr')),
    p_codi_timo_rcnadle   number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rcnadle')),
    p_codi_timo_rcnadlr   number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rcnadlr')),
    p_codi_timo_cnncre    number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnncre')),
    p_codi_timo_cnncrr    number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnncrr')),
    p_codi_timo_cnfcre    number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnfcre')),
    p_codi_timo_cnfcrr    number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnfcrr')),
    p_indi_most_ortr_adel varchar2(10) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_most_ortr_adel'))),
    
    p_codi_timo_auto_fact_emit    number := to_number(general_skn.fl_busca_parametro('p_codi_timo_auto_fact_emit')),
    p_codi_timo_auto_fact_emit_cr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_auto_fact_emit_cr')),
    p_codi_timo_rete_reci         number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rete_reci')),
    p_codi_conc_rete_reci         number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_reci')),
    
    p_indi_apli_rete_exen      varchar2(10) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_apli_rete_exen'))),
    p_indi_perm_fech_vale_supe varchar2(10) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_perm_fech_vale_supe'))),
    
    p_codi_tipo_empl_vend number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_vend')),
    p_codi_tipo_empl_cobr number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_cobr')),
    p_codi_conc_adle      number := to_number(general_skn.fl_busca_parametro('p_codi_conc_adle')),
    p_codi_conc_adlr      number := to_number(general_skn.fl_busca_parametro('p_codi_conc_adlr')),
    
    p_codi_conc_dadle number := to_number(general_skn.fl_busca_parametro('p_codi_conc_dadle')),
    p_codi_conc_dadlr number := to_number(general_skn.fl_busca_parametro('p_codi_conc_dadlr')),
    
    --pp_mostrar_tipo_movi,
    
    p_codi_impu_exen number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_codi_mone_mmnn number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_codi_mone_mmee number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmee')),
    
    p_cant_deci_mmnn number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_cant_deci_mmee number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmee')),
    
    p_indi_impr_cheq_emit varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_impr_cheq_emit'))),
    p_indi_vali_repe_cheq varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_repe_cheq'))),
    
    p_indi_habi_vuelto varchar2(10) := general_skn.fl_busca_parametro('p_indi_habi_vuelto_cob'),
    
    p_indi_cont_corr_talo_reci varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_cont_corr_talo_reci'))),
    p_indi_most_mens_sali      varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_sali'))),
    
    p_indi_fopa_chta_caja varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_fopa_chta_caja'))),
    p_codi_timo_extr_banc number := to_number(general_skn.fl_busca_parametro('p_codi_timo_extr_banc')),
    p_codi_conc_cheq_cred number := to_number(general_skn.fl_busca_parametro('p_codi_conc_cheq_cred')),
    
    p_indi_rend_comp         varchar2(10) := 'N',
    p_cobr_vent_indi_cobr_fp varchar2(10) := 'N',
    p_hoja_ruta_indi_cobr_fp varchar2(10) := 'N',
    
    -- pa_devu_fech_habi(p_fech_inic,p_fech_fini ),
    
    p_codi_base                number := pack_repl.fa_devu_codi_base,
    p_movi_codi_reci_hoja_ruta varchar2(2),
    p_movi_codi_vale           number,
    p_peco_codi                number,
    movi_tico_codi             number,
    movi_tare_codi             number);
  parameter r_parameter;

  procedure pp_iniciar(p_para_inic in varchar2) is
    V_movi_timo_codi number;
  begin
    if p_para_inic = 'DAC' then
      -- devolucion de Adelanto de Clientes
      setitem('p124_indi_emit_reci', 'E');
      setitem('p124_movi_timo_codi', parameter.p_codi_timo_dadle);
      V_movi_timo_codi := parameter.p_codi_timo_dadle;
      setitem('p124_CLPR_INDI_CLIE_PROV', 'C');
      setitem('p124_indi_most_ortr_adel', 'N');
      setitem('p124_timo_codi', parameter.p_codi_timo_adle);
      setitem('p124_ETIQUETA', 'Cliente:');
    end if;
    
  
    pp_mostrar_tipo_movi(V_movi_timo_codi);
  
  end pp_iniciar;

  procedure pp_mostrar_tipo_movi(p_movi_timo_codi in number) is
    v_timo_ingr_dbcr_vari      char(1);
    V_timo_desc                varchar(500);
    V_movi_afec_sald           varchar(20);
    V_movi_emit_reci           varchar2(20);
    V_s_timo_calc_iva          varchar2(10);
    V_movi_dbcr                varchar2(20);
    V_timo_ingr_cheq_dbcr_vari varchar2(20);
    V_movi_timo_indi_sald      varchar2(20);
    V_movi_timo_indi_caja      varchar2(20);
    V_movi_timo_indi_adel      varchar2(20);
    V_movi_timo_indi_ncr       varchar2(20);
    V_timo_tica_codi           number;
    V_movi_tico_codi           number;
    V_timo_indi_apli_adel_fopa varchar2(20);
    V_timo_dbcr_caja           varchar2(20);
  
  begin
  
    select timo_desc,
           timo_afec_sald,
           timo_emit_reci,
           nvl(timo_calc_iva, 'S'),
           timo_dbcr,
           timo_ingr_dbcr_vari,
           timo_ingr_cheq_dbcr_vari,
           nvl(timo_indi_sald, 'N'),
           nvl(timo_indi_caja, 'N'),
           nvl(timo_indi_adel, 'N'),
           nvl(timo_indi_ncr, 'N'),
           timo_tica_codi,
           timo_tico_codi,
           timo_indi_apli_adel_fopa,
           timo_dbcr_caja
      into V_timo_desc,
           V_movi_afec_sald,
           V_movi_emit_reci,
           V_s_timo_calc_iva,
           V_movi_dbcr,
           v_timo_ingr_dbcr_vari,
           V_timo_ingr_cheq_dbcr_vari,
           V_movi_timo_indi_sald,
           V_movi_timo_indi_caja,
           V_movi_timo_indi_adel,
           V_movi_timo_indi_ncr,
           V_timo_tica_codi,
           V_movi_tico_codi,
           V_timo_indi_apli_adel_fopa,
           V_timo_dbcr_caja
      from come_tipo_movi
     where timo_codi = p_movi_timo_codi;
  
    setitem('p124_movi_afec_sald', v_movi_afec_sald);
    setitem('p124_movi_emit_reci', V_movi_emit_reci);
    setitem('p124_timo_tica_codi', V_timo_tica_codi);
    setitem('p124_MOVI_TICO_CODI', v_MOVI_TICO_CODI);
    setitem('p124_MOVI_TIMO_INDI_CAJA', v_MOVI_TIMO_INDI_CAJA);
    setitem('p124_MOVI_DBCR', v_MOVI_DBCR);
  
  Exception
    when no_data_found then
      raise_application_error(-20001, 'Tipo de Movimiento inexistente');
    When too_many_rows then
      raise_application_error(-20001, 'Tipo de Movimiento duplicado');
    
  End pp_mostrar_tipo_movi;

  procedure pp_validar_moneda(p_movi_mone_codi in out number) is
  begin
    if p_movi_mone_codi is null then
      p_movi_mone_codi := parameter.p_codi_mone_mmnn;
    end if;
  end pp_validar_moneda;

  procedure pp_val_tasa(p_movi_mone_codi in number,
                        p_ind_tasa       out varchar2) is
  begin
    if p_movi_mone_codi = parameter.p_codi_mone_mmnn then
      p_ind_tasa := 'N';
    else
      p_ind_tasa := 'S';
    end if;
  end pp_val_tasa;

  Procedure pp_muestra_clpr(p_ind_clpr            in varchar2,
                            p_clpr_codi_alte      in number,
                            p_clpr_desc           out varchar2,
                            p_clpr_codi           out varchar2,
                            p_clpr_tele           out varchar2,
                            p_clpr_dire           out varchar2,
                            p_clpr_ruc            out varchar2,
                            p_indi_chac           out varchar2,
                            p_indi_judi           out varchar2,
                            p_clpr_empl_codi_agen out varchar2) is
  begin
    -- raise_application_error(-20001,p_clpr_codi_alte);
  
    select clpr_desc,
           clpr_codi,
           rtrim(ltrim(substr(clpr_tele, 1, 50))) Tele,
           rtrim(ltrim(substr(clpr_dire, 1, 100))) dire,
           rtrim(ltrim(substr(clpr_ruc, 1, 20))) Ruc,
           clpr_indi_chac,
           clpr_indi_judi,
           clpr_empl_codi
      into p_clpr_desc,
           p_clpr_codi,
           p_clpr_tele,
           p_clpr_dire,
           p_clpr_ruc,
           p_indi_chac,
           p_indi_judi,
           p_clpr_empl_codi_agen
      from come_clie_prov
     where clpr_codi = p_clpr_codi_alte --clpr_codi_alte = p_clpr_codi_alte
       and clpr_indi_clie_prov = p_ind_clpr /*decode(p_ind_clpr, 'R', 'P', 'E', 'C')*/
    ;
  
  Exception
    when no_data_found then
      p_clpr_desc           := null;
      p_clpr_codi           := null;
      p_clpr_tele           := null;
      p_clpr_dire           := null;
      p_clpr_ruc            := null;
      p_indi_chac           := null;
      p_indi_judi           := null;
      p_clpr_empl_codi_agen := null;
    
      if p_ind_clpr = 'R' then
        raise_application_error(-20001, 'Proveedor inexistente!');
      else
        raise_application_error(-20001, 'Cliente inexistente!');
      end if;
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_clpr;

  PROCEDURE pp_validar_sub_cuenta(p_movi_clpr_codi in number,
                                  p_indi_vali_subc out varchar2) IS
    v_count number := 0;
  BEGIN
    select count(*)
      into v_count
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_movi_clpr_codi;
    if v_count > 0 then
      p_indi_vali_subc := 'S';
    else
      p_indi_vali_subc := 'N';
      -- set_item_property('bcab.sucu_nume_item', enabled, property_false);
    end if;
  END pp_validar_sub_cuenta;

  procedure pp_busca_movi_codi_adel(p_movi_codi        in number,
                                    p_movi_mone_codi   in number,
                                    p_clpr_codi        in number,
                                    p_timo_codi        in number,
                                    p_w_movi_sald      out number,
                                    p_w_movi_fech_emis out date,
                                    p_movi_nume        out varchar2) is
  begin
    begin
      select movi_sald_mone, movi_fech_emis, movi_nume
        into p_w_movi_sald, p_w_movi_fech_emis, p_movi_nume
        from come_movi
       where movi_timo_codi = p_timo_codi
         and movi_codi = p_movi_codi
         and movi_clpr_codi = p_clpr_codi
         and movi_mone_codi = p_movi_mone_codi;
    
    Exception
      When no_data_found then
        raise_application_error(-20001, 'Numero de Movimiento inexistente');
      When too_many_rows then
        raise_application_error(-20001,
                                'Existe m?s de un movimiento con ese N?mero');
      
    end;
  
    if p_w_movi_sald <= 0 then
      raise_application_error(-20001, 'El Movimiento no posee saldo');
    end if;
  
  Exception
    When no_data_found then
      raise_application_error(-20001, 'Movimiento Inexistente');
    When too_many_rows then
      raise_application_error(-20001, 'Nro. de Movimiento Duplicado');
    when others then
      raise_application_error(-20001,
                              'Error en pp_busca_movi_codi_adel ' ||
                              sqlerrm);
  end pp_busca_movi_codi_adel;

  procedure pp_valida_fech(p_fech in date) is
    v_fech_inic date;
    v_fech_fini date;
  begin
    pa_devu_fech_habi(v_fech_inic, v_fech_fini);
    if p_fech not between v_fech_inic and v_fech_fini then
      raise_application_error(-20001,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(v_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                              to_char(v_fech_fini, 'dd-mm-yyyy'));
    end if;
  
  end pp_valida_fech;

  PROCEDURE pp_muestra_sub_cuenta(p_clpr_codi      in number,
                                  p_sucu_nume_item in number,
                                  p_sucu_desc      out char) IS
  BEGIN
    select sucu_desc
      into p_sucu_desc
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_clpr_codi
       and sucu_nume_item = p_sucu_nume_item;
  Exception
    when no_data_found then
      raise_application_error(-20001, 'SubCuenta inexistente');
    when others then
      raise_application_error(-20001, sqlerrm);
  END pp_muestra_sub_cuenta;

  procedure pp_mostrar_moneda(p_mone_codi      in number,
                              p_mone_desc      out varchar2,
                              p_mone_desc_abre out varchar2,
                              p_mone_cant_deci out varchar2) is
  begin
    select f.mone_desc, f.mone_desc_abre, f.mone_cant_deci
      into p_mone_desc, p_mone_desc_abre, p_mone_cant_deci
      from come_mone f
     where f.mone_codi = p_mone_codi;
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_mostrar_moneda;

  procedure pp_busca_tasa_mone(p_mone_codi in number,
                               p_coti_fech in date,
                               p_mone_coti out number,
                               p_tica_codi in number) is
  begin
    if parameter.p_codi_mone_mmnn = p_mone_codi then
      p_mone_coti := 1;
    else
      select coti_tasa
        into p_mone_coti
        from come_coti
       where coti_mone = p_mone_codi
         and coti_fech = p_coti_fech
         and coti_tica_codi = p_tica_codi;
    end if;
  
  exception
    when no_data_found then
      p_mone_coti := null;
      raise_application_error(-20001,
                              'Cotizacion Inexistente para la fecha del documento.');
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

  procedure pp_muestra_come_empl(p_empl_empr_codi in number,
                                 p_emti_tiem_codi in number,
                                 p_empl_codi_alte in varchar2,
                                 p_empl_desc      out varchar2,
                                 p_empl_codi      out number) is
  begin
  
    --RAISE_APPLICATION_ERROR(-20001,p_empl_codi_alte);
    select e.empl_desc, e.empl_codi
      into p_empl_desc, p_empl_codi
      from come_empl e, come_empl_tiem t
     where e.empl_codi = t.emti_empl_codi
       and t.emti_tiem_codi = parameter.p_codi_tipo_empl_cobr --p_emti_tiem_codi
       and e.empl_empr_codi = p_empl_empr_codi
       and nvl(empl_esta, 'A') = 'A'
       --and ltrim(rtrim(lower(e.empl_codi_alte))) = ltrim(rtrim(lower(p_empl_codi_alte)))
       and e.empl_codi = to_number(p_empl_codi_alte)
       ;
  
  exception
    when no_data_found then
      p_empl_desc := null;
      p_empl_codi := null;
      raise_application_error(-20001,
                              'Empleado inexistente o no es del tipo requerido o no se encuentra Activo');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_come_empl;

  PROCEDURE pp_valida IS
  BEGIN
    if nvl(var.s_impo, 0) <= 0 then
      raise_application_error(-20001,
                              'Debe ingresar un Valor Mayor a cero!');
    end if;
    if nvl(var.s_impo, 0) > nvl(var.w_movi_sald, 0) then
      raise_application_error(-20001,
                              'El importe no puede ser mayor al saldo del documento.');
    end if;
    if g_come_movi.movi_empl_codi is null then
      if g_come_movi.movi_timo_codi = parameter.p_codi_timo_adle then
        --adelanto de clientes..
        raise_application_error(-20001,
                                'Debe ingresar el codigo del empleado!');
      end if;
    end if;
    if g_come_movi.movi_nume is null then
      raise_application_error(-20001,
                              'Debe introducir el nro. de comprobante!.');
    end if;
    if g_come_movi.movi_clpr_codi is null then
      if g_come_movi.movi_afec_sald = 'P' then
        raise_application_error(-20001, 'Debe ingresar el Proveedor.!');
      elsif g_come_movi.movi_afec_sald = 'C' then
        raise_application_error(-20001, 'Debe ingresar el Cliente.!');
      else
        raise_application_error(-20001,
                                'Debe ingresar el cliente/Proveedor.!');
      end if;
    end if;
  
  END pp_valida;

  procedure pp_valida_importes is
  begin
  
    if var.movi_timo_indi_caja = 'S' then
      --mov. q afecta a caja
      if (nvl(var.s_impo_cheq, 0) + nvl(var.s_impo_efec, 0) +
         nvl(var.s_impo_tarj, 0) + nvl(var.s_impo_adel, 0) +
         nvl(var.s_impo_vale, 0) ---(nvl(g_come_movi.s_impo_vale,0) * -1)
         + nvl(var.s_impo_viaj, 0)) <> (nvl(var.s_impo, 0)) then
        raise_application_error(-20001,
                                'El importe total de cheques + el importe en efectivo ' ||
                                '+ el importe en Vales a rendir ' ||
                                'debe ser igual al importe del documento');
      end if; --no se agrego aun adelanto en el mensaje. 
      pl_valida_clie_prov_cheq; --validar
      if var.s_impo_sald <> 0 then
        raise_application_error(-20001,
                                'Existe una diferencia en montos. Saldo distinto a 0(cero).');
      end if;
    end if;
    if nvl(bortr.sum_ador_impo, 0) <> 0 then
      -- se cargo OT.
      if bortr.sum_ador_impo <> var.s_impo then
        raise_application_error(-20001,
                                'El importe total de ?rdenes de Trabajo es distinto al importe del documento.');
      end if;
    end if;
  end pp_valida_importes;

  procedure pp_actualiza_come_movi is
    v_movi_codi                number;
    v_movi_timo_codi           number;
    v_movi_clpr_codi           number;
    v_movi_sucu_codi_orig      number;
    v_movi_depo_codi_orig      number;
    v_movi_sucu_codi_dest      number;
    v_movi_depo_codi_dest      number;
    v_movi_oper_codi           number;
    v_movi_cuen_codi           number;
    v_movi_mone_codi           number;
    v_movi_nume                number;
    v_movi_fech_emis           date;
    v_movi_fech_grab           date;
    v_movi_user                varchar2(20);
    v_movi_codi_padr           number;
    v_movi_tasa_mone           number;
    v_movi_tasa_mmee           number;
    v_movi_grav_mmnn           number;
    v_movi_exen_mmnn           number;
    v_movi_iva_mmnn            number;
    v_movi_grav_mmee           number;
    v_movi_exen_mmee           number;
    v_movi_iva_mmee            number;
    v_movi_grav_mone           number;
    v_movi_exen_mone           number;
    v_movi_iva_mone            number;
    v_movi_obse                varchar2(2000);
    v_movi_sald_mmnn           number;
    v_movi_sald_mmee           number;
    v_movi_sald_mone           number;
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(100);
    v_movi_clpr_tele           varchar2(50);
    v_movi_clpr_ruc            varchar2(20);
    v_movi_clpr_desc           varchar2(80);
    v_movi_emit_reci           varchar2(1);
    v_movi_afec_sald           varchar2(1);
    v_movi_dbcr                varchar2(1);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_empr_codi           number;
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           number;
    v_movi_fech_oper           date;
    v_movi_clpr_sucu_nume_item number;
    v_movi_Excl_cont           varchar2(1);
    v_movi_empl_codi_agen      number;
  
  begin
  
    if var.cont_codi is not null then
      g_come_movi.movi_obse := fp_concatenar(var.cont_codi);
    end if;
    --- asignar valores....
    g_come_movi.movi_codi      := fa_sec_come_movi;
    g_come_movi.movi_fech_grab := sysdate;
    g_come_movi.movi_user      := g_user;
  
    v_movi_timo_codi := g_come_movi.movi_timo_codi;
  
    v_movi_codi                := g_come_movi.movi_codi;
    v_movi_clpr_codi           := g_come_movi.movi_clpr_codi;
    v_movi_sucu_codi_orig      := g_come_movi.movi_sucu_codi_orig;
    v_movi_depo_codi_orig      := null;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := null;
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := g_come_movi.movi_mone_codi;
    v_movi_nume                := g_come_movi.movi_nume;
    v_movi_fech_emis           := g_come_movi.movi_fech_emis;
    v_movi_fech_oper           := g_come_movi.movi_fech_oper;
    v_movi_fech_grab           := g_come_movi.movi_fech_grab;
    v_movi_user                := g_come_movi.movi_user;
    v_movi_codi_padr           := null;
    v_movi_tasa_mone           := g_come_movi.movi_tasa_mone;
    v_movi_tasa_mmee           := 1;
    v_movi_grav_mmnn           := 0;
    v_movi_exen_mmnn           := round((var.s_impo *
                                        g_come_movi.movi_tasa_mone),
                                        parameter.p_cant_deci_mmnn);
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := 0;
    v_movi_exen_mmee           := 0;
    v_movi_iva_mmee            := 0;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := var.s_impo;
    v_movi_iva_mone            := 0;
    v_movi_obse                := g_come_movi.movi_obse;
    v_movi_sald_mmnn           := round((var.s_impo *
                                        g_come_movi.movi_tasa_mone),
                                        parameter.p_cant_deci_mmnn);
    v_movi_sald_mmee           := 0;
    v_movi_sald_mone           := var.s_impo;
    v_movi_stoc_suma_rest      := null;
    v_movi_clpr_dire           := g_come_movi.movi_clpr_dire;
    v_movi_clpr_tele           := g_come_movi.movi_clpr_tele;
    v_movi_clpr_ruc            := g_come_movi.movi_clpr_ruc;
    v_movi_clpr_desc           := g_come_movi.movi_clpr_desc;
    v_movi_emit_reci           := g_come_movi.movi_emit_reci;
    v_movi_afec_sald           := g_come_movi.movi_afec_sald;
    v_movi_dbcr                := g_come_movi.movi_dbcr;
    v_movi_stoc_afec_cost_prom := null;
    v_movi_empr_codi           := g_come_movi.movi_empr_codi;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := g_come_movi.movi_empl_codi;
    v_movi_clpr_sucu_nume_item := g_come_movi.movi_clpr_sucu_nume_item;
    v_movi_Excl_cont           := null;
    v_movi_empl_codi_agen      := g_come_movi.movi_empl_codi_agen;
  
    pp_insert_come_movi(v_movi_codi,
                        v_movi_timo_codi,
                        v_movi_clpr_codi,
                        v_movi_sucu_codi_orig,
                        v_movi_depo_codi_orig,
                        v_movi_sucu_codi_dest,
                        v_movi_depo_codi_dest,
                        v_movi_oper_codi,
                        v_movi_cuen_codi,
                        v_movi_mone_codi,
                        v_movi_nume,
                        v_movi_fech_emis,
                        v_movi_fech_grab,
                        v_movi_user,
                        v_movi_codi_padr,
                        v_movi_tasa_mone,
                        v_movi_tasa_mmee,
                        v_movi_grav_mmnn,
                        v_movi_exen_mmnn,
                        v_movi_iva_mmnn,
                        v_movi_grav_mmee,
                        v_movi_exen_mmee,
                        v_movi_iva_mmee,
                        v_movi_grav_mone,
                        v_movi_exen_mone,
                        v_movi_iva_mone,
                        v_movi_obse,
                        v_movi_sald_mmnn,
                        v_movi_sald_mmee,
                        v_movi_sald_mone,
                        v_movi_stoc_suma_rest,
                        v_movi_clpr_dire,
                        v_movi_clpr_tele,
                        v_movi_clpr_ruc,
                        v_movi_clpr_desc,
                        v_movi_emit_reci,
                        v_movi_afec_sald,
                        v_movi_dbcr,
                        v_movi_stoc_afec_cost_prom,
                        v_movi_empr_codi,
                        v_movi_clave_orig,
                        v_movi_clave_orig_padr,
                        v_movi_indi_iva_incl,
                        v_movi_empl_codi,
                        v_movi_fech_oper,
                        v_movi_clpr_sucu_nume_item,
                        v_movi_Excl_cont,
                        v_movi_empl_codi_agen);
  
  Exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualiza_come_movi;

  procedure pp_actualiza_come_movi_cuot is
    v_cuot_fech_venc date;
    v_cuot_nume      number;
    v_cuot_impo_mone number;
    v_cuot_impo_mmnn number;
    v_cuot_impo_mmee number;
    v_cuot_sald_mone number;
    v_cuot_sald_mmnn number;
    v_cuot_sald_mmee number;
    v_cuot_movi_codi number;
  
  begin
  
    --Generar una cuota con f. de venc igual a la fecha del documento  
    v_cuot_fech_venc := g_come_movi.movi_fech_emis;
    v_cuot_nume      := 1;
    v_cuot_impo_mone := var.s_impo;
    v_cuot_impo_mmnn := round((var.s_impo * g_come_movi.movi_tasa_mone),
                              parameter.p_cant_deci_mmnn);
    v_cuot_impo_mmee := null;
    v_cuot_sald_mone := v_cuot_impo_mone;
    v_cuot_sald_mmnn := v_cuot_impo_mmnn;
    v_cuot_sald_mmee := null;
    v_cuot_movi_codi := g_come_movi.movi_codi;
  
    /* pp_insert_come_movi_cuot(v_cuot_fech_venc,
    v_cuot_nume,
    v_cuot_impo_mone,
    v_cuot_impo_mmnn,
    v_cuot_impo_mmee,
    v_cuot_sald_mone,
    v_cuot_sald_mmnn,
    v_cuot_sald_mmee,
    v_cuot_movi_codi);*/
  
    insert into come_movi_cuot
      (cuot_fech_venc,
       cuot_nume,
       cuot_impo_mone,
       cuot_impo_mmnn,
       cuot_impo_mmee,
       cuot_sald_mone,
       cuot_sald_mmnn,
       cuot_sald_mmee,
       cuot_movi_codi,
       cuot_base)
    values
      (v_cuot_fech_venc,
       v_cuot_nume,
       v_cuot_impo_mone,
       v_cuot_impo_mmnn,
       v_cuot_impo_mmee,
       v_cuot_sald_mone,
       v_cuot_sald_mmnn,
       v_cuot_sald_mmee,
       v_cuot_movi_codi,
       parameter.p_codi_base);
  
  Exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualiza_come_movi_cuot;

  procedure pp_actualiza_moimpu is
    v_moim_impu_codi number;
    v_moim_movi_codi number;
    v_moim_impo_mmnn number;
    v_moim_impo_mmee number;
    v_moim_impu_mmnn number;
    v_moim_impu_mmee number;
    v_moim_impo_mone number;
    v_moim_impu_mone number;
  
  Begin
  
    v_moim_impu_codi := to_number(parameter.p_codi_impu_exen);
    v_moim_movi_codi := g_come_movi.movi_codi;
    v_moim_impo_mmnn := round((var.s_impo * g_come_movi.movi_tasa_mone),
                              to_number(parameter.p_cant_deci_mmnn));
    v_moim_impo_mmee := 0;
    v_moim_impu_mmnn := 0;
    v_moim_impu_mmee := 0;
    v_moim_impo_mone := var.s_impo;
    v_moim_impu_mone := 0;
  
    /*pp_insert_come_movi_impu_deta(v_moim_impu_codi,
    v_moim_movi_codi,
    v_moim_impo_mmnn,
    v_moim_impo_mmee,
    v_moim_impu_mmnn,
    v_moim_impu_mmee,
    v_moim_impo_mone,
    v_moim_impu_mone);*/
  
    insert into come_movi_impu_deta
      (moim_impu_codi,
       moim_movi_codi,
       moim_impo_mmnn,
       moim_impo_mmee,
       moim_impu_mmnn,
       moim_impu_mmee,
       moim_impo_mone,
       moim_impu_mone,
       moim_base)
    values
      (v_moim_impu_codi,
       v_moim_movi_codi,
       v_moim_impo_mmnn,
       v_moim_impo_mmee,
       v_moim_impu_mmnn,
       v_moim_impu_mmee,
       v_moim_impo_mone,
       v_moim_impu_mone,
       parameter.p_codi_base);
  
  Exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualiza_moimpu;

  procedure pp_actualiza_moco is
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      char(1);
  
  begin
    v_moco_movi_codi := g_come_movi.movi_codi;
    v_moco_nume_item := 1;
  
    if var.p_para_inic = 'AP' then
      --adelant a Proveedores
      v_moco_conc_codi := parameter.p_codi_conc_adlr;
    elsif var.p_para_inic = 'AC' then
      -- Adelanto de Clientes
      v_moco_conc_codi := parameter.p_codi_conc_adle;
    elsif var.p_para_inic = 'DAP' then
      -- Devolcion de Adelanto de proveedores
      v_moco_conc_codi := parameter.p_codi_conc_dadlr;
    elsif var.p_para_inic = 'DAC' then
      -- devolucion de Adelanto de Clientes
      v_moco_conc_codi := parameter.p_codi_conc_dadle;
    end if;
  
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_exen; --exento
    v_moco_impo_mmnn := round((var.s_impo * g_come_movi.movi_tasa_mone),
                              parameter.p_cant_deci_mmnn);
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := var.s_impo;
    v_moco_dbcr      := g_come_movi.movi_dbcr;
  
    /*pp_insert_movi_conc_deta(v_moco_movi_codi,
    v_moco_nume_item,
    v_moco_conc_codi,
    v_moco_cuco_codi,
    v_moco_impu_codi,
    v_moco_impo_mmnn,
    v_moco_impo_mmee,
    v_moco_impo_mone,
    v_moco_dbcr);*/
    --raise_application_error(-20001,'call me overr '||v_moco_conc_codi);                        
    insert into come_movi_conc_deta
      (moco_movi_codi,
       moco_nume_item,
       moco_conc_codi,
       moco_cuco_codi,
       moco_impu_codi,
       moco_impo_mmnn,
       moco_impo_mmee,
       moco_impo_mone,
       moco_dbcr,
       moco_base)
    values
      (v_moco_movi_codi,
       v_moco_nume_item,
       v_moco_conc_codi,
       v_moco_cuco_codi,
       v_moco_impu_codi,
       v_moco_impo_mmnn,
       v_moco_impo_mmee,
       v_moco_impo_mone,
       v_moco_dbcr,
       parameter.p_codi_base);
    --raise_application_error(-20001,'call me over');
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualiza_moco;

  procedure pp_actualiza_como is
  
    v_como_movi_codi      number;
    v_como_cont_codi      number;
    v_como_nume_item      number;
    v_como_impo_mone      number;
    v_como_impo_mmnn      number;
    v_como_impo_mmee      number;
    v_como_cant           number;
    v_como_movi_codi_desh number;
    v_como_impo_uni       number;
    v_como_base           number;
  
  begin
  
    v_como_movi_codi := g_come_movi.movi_codi;
    v_como_nume_item := 1;
    v_como_cont_codi := var.cont_codi;
  
    v_como_impo_mmnn := round((var.s_impo * g_come_movi.movi_tasa_mone),
                              parameter.p_cant_deci_mmnn);
    v_como_impo_mmee := 0;
    v_como_impo_mone := var.s_impo;
  
    /* pp_insert_movi_cont_deta(v_como_movi_codi,
    v_como_cont_codi,
    v_como_nume_item,
    v_como_impo_mone,
    v_como_impo_mmnn,
    v_como_impo_mmee,
    v_como_cant,
    v_como_movi_codi_desh,
    v_como_impo_uni);*/
  
    insert into come_movi_cont_deta
      (como_movi_codi,
       como_cont_codi,
       como_nume_item,
       como_impo_mone,
       como_impo_mmnn,
       como_impo_mmee,
       como_cant,
       como_movi_codi_desh,
       como_impo_uni,
       como_base)
    values
      (v_como_movi_codi,
       v_como_cont_codi,
       v_como_nume_item,
       v_como_impo_mone,
       v_como_impo_mmnn,
       v_como_impo_mmee,
       v_como_cant,
       v_como_movi_codi_desh,
       v_como_impo_uni,
       parameter.p_codi_base);
  
  Exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualiza_como;

  procedure pp_actu_secu is
  begin
    update come_secu
       set secu_nume_adle = g_come_movi.movi_nume
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  
  Exception
  
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_actu_secu;

  procedure pp_actualiza_canc is
    --insertar los recibos de cancelaciones
    --Cancelacion de la NC/Adel..................
    --Cancelacion de la Factura/Nota de Debito....
    v_movi_codi                number;
    v_movi_timo_codi           number;
    v_movi_timo_desc           varchar2(20);
    v_movi_timo_desc_abre      varchar2(10);
    v_movi_clpr_codi           number;
    v_movi_sucu_codi_orig      number;
    v_movi_depo_codi_orig      number;
    v_movi_sucu_codi_dest      number;
    v_movi_depo_codi_dest      number;
    v_movi_oper_codi           number;
    v_movi_cuen_codi           number;
    v_movi_mone_codi           number;
    v_movi_nume                number;
    v_movi_fech_emis           date;
    v_movi_fech_grab           date;
    v_movi_user                varchar2(20);
    v_movi_codi_padr           number;
    v_movi_tasa_mone           number;
    v_movi_tasa_mmee           number;
    v_movi_grav_mmnn           number;
    v_movi_exen_mmnn           number;
    v_movi_iva_mmnn            number;
    v_movi_grav_mmee           number;
    v_movi_exen_mmee           number;
    v_movi_iva_mmee            number;
    v_movi_grav_mone           number;
    v_movi_exen_mone           number;
    v_movi_iva_mone            number;
    v_movi_obse                varchar2(2000);
    v_movi_sald_mmnn           number;
    v_movi_sald_mmee           number;
    v_movi_sald_mone           number;
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(100);
    v_movi_clpr_tele           varchar2(50);
    v_movi_clpr_ruc            varchar2(20);
    v_movi_clpr_desc           varchar2(80);
    v_movi_emit_reci           varchar2(1);
    v_movi_afec_sald           varchar2(1);
    v_movi_dbcr                varchar2(1);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_empr_codi           number;
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           number;
    v_movi_fech_oper           date;
    v_movi_clpr_sucu_nume_item number;
    v_movi_Excl_cont           varchar2(1) := 'S';
    v_movi_empl_codi_agen      number;
  
    --variables para come_movi_cuot_canc...
    v_canc_movi_codi      number;
    v_canc_cuot_movi_codi number;
    v_canc_cuot_fech_venc date;
    v_canc_fech_pago      date;
    v_canc_impo_mone      number;
    v_canc_impo_mmnn      number;
    v_canc_impo_mmee      number;
    v_canc_impo_dife_camb number := 0;
  
    cursor c_movi_cuot(p_movi_codi in number) is
      select cuot_movi_codi, cuot_fech_venc, cuot_sald_mone
        from come_movi_cuot
       where cuot_movi_codi = p_movi_codi
         and cuot_sald_mone > 0;
  
    v_impo_canc number;
    v_impo_deto number;
  
    v_indi_adel char(1);
    v_indi_ncr  char(1);
  begin
    --  |------------------------------------------------------------|
    --  |-Insertar la cancelacion de adelanto...|
    --  |------------------------------------------------------------|  
    --Determinar el Tipo de movimiento.......
    --Primero determinamos si el documento es emitido o Recibido
    if g_come_movi.movi_emit_reci = 'E' then
      --es emitido
      v_movi_timo_codi := parameter.p_codi_timo_rcnadle;
    else
      --si es Recibido..
      v_movi_timo_codi := parameter.p_codi_timo_rcnadlr;
    end if;
  
    pp_muestra_come_tipo_movi(v_movi_timo_codi,
                              v_movi_timo_desc,
                              v_movi_timo_desc_abre,
                              v_movi_afec_sald,
                              v_movi_dbcr,
                              v_indi_adel,
                              v_indi_ncr,
                              'N');
  
    v_movi_codi           := fa_sec_come_movi;
    v_movi_clpr_codi      := g_come_movi.movi_clpr_codi;
    v_movi_sucu_codi_orig := g_come_movi.movi_sucu_codi_orig;
    v_movi_mone_codi      := g_come_movi.movi_mone_codi;
    v_movi_nume           := g_come_movi.movi_nume;
    v_movi_fech_emis      := g_come_movi.movi_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := g_user;
    v_movi_codi_padr      := g_come_movi.movi_codi;
    v_movi_tasa_mone      := g_come_movi.movi_tasa_mone;
    v_movi_tasa_mmee      := 0;
    v_movi_grav_mmnn      := 0;
    v_movi_exen_mmnn      := round((var.s_impo * g_come_movi.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_movi_iva_mmnn       := 0;
    v_movi_grav_mmee      := 0;
    v_movi_exen_mmee      := 0;
    v_movi_iva_mmee       := 0;
    v_movi_grav_mone      := 0;
    v_movi_exen_mone      := var.s_impo;
    v_movi_iva_mone       := 0;
    v_movi_clpr_desc      := g_come_movi.movi_clpr_desc;
    v_movi_emit_reci      := g_come_movi.movi_emit_reci;
    v_movi_empr_codi      := g_come_movi.movi_empr_codi;
    -- Cancelacion de Adelanto.
    /* pp_insert_come_movi_adel(v_movi_codi,
    v_movi_timo_codi,
    v_movi_clpr_codi,
    v_movi_sucu_codi_orig,
    v_movi_mone_codi,
    v_movi_nume,
    v_movi_fech_emis,
    v_movi_fech_grab,
    v_movi_user,
    v_movi_codi_padr,
    v_movi_tasa_mone,
    v_movi_tasa_mmee,
    v_movi_grav_mmnn,
    v_movi_exen_mmnn,
    v_movi_iva_mmnn,
    v_movi_grav_mmee,
    v_movi_exen_mmee,
    v_movi_iva_mmee,
    v_movi_grav_mone,
    v_movi_exen_mone,
    v_movi_iva_mone,
    v_movi_clpr_desc,
    v_movi_emit_reci,
    v_movi_afec_sald,
    v_movi_dbcr,
    v_movi_empr_codi, 
    v_movi_Excl_cont);*/
  
    insert into come_movi
      (movi_codi,
       movi_timo_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
       movi_mone_codi,
       movi_nume,
       movi_fech_emis,
       movi_fech_grab,
       movi_user,
       movi_codi_padr,
       movi_tasa_mone,
       movi_tasa_mmee,
       movi_grav_mmnn,
       movi_exen_mmnn,
       movi_iva_mmnn,
       movi_grav_mmee,
       movi_exen_mmee,
       movi_iva_mmee,
       movi_grav_mone,
       movi_exen_mone,
       movi_iva_mone,
       movi_clpr_desc,
       movi_emit_reci,
       movi_afec_sald,
       movi_dbcr,
       movi_empr_codi,
       movi_excl_cont,
       movi_base)
    values
      (
       
       v_movi_codi,
       v_movi_timo_codi,
       v_movi_clpr_codi,
       v_movi_sucu_codi_orig,
       v_movi_mone_codi,
       v_movi_nume,
       v_movi_fech_emis,
       v_movi_fech_grab,
       v_movi_user,
       v_movi_codi_padr,
       v_movi_tasa_mone,
       v_movi_tasa_mmee,
       v_movi_grav_mmnn,
       v_movi_exen_mmnn,
       v_movi_iva_mmnn,
       v_movi_grav_mmee,
       v_movi_exen_mmee,
       v_movi_iva_mmee,
       v_movi_grav_mone,
       v_movi_exen_mone,
       v_movi_iva_mone,
       v_movi_clpr_desc,
       v_movi_emit_reci,
       v_movi_afec_sald,
       v_movi_dbcr,
       v_movi_empr_codi,
       v_movi_excl_cont,
       parameter.p_codi_base);
    --
    --Obse. Los Adelantos tendr?n siempre una sola cuota..
    --con fecha de vencimiento igual a la fecha del documento.................
    v_canc_movi_codi      := v_movi_codi; --clave del recibo de cn de nc/adel
    v_canc_cuot_movi_codi := var.w_movi_codi; --clave de la nota de credito/ adel
    if var.p_para_inic not in ('AC', 'AP') then
      v_canc_cuot_fech_venc := var.w_movi_fech_emis;
    else
      v_canc_cuot_fech_venc := g_come_movi.movi_fech_emis; --fecha de venc. de la cuota de NC/Adel (= a la fecha de la nc/Adel)
    end if;
    v_canc_fech_pago      := g_come_movi.movi_fech_emis; --fecha de aplicacion de la cuota de NC (= a la fecha de la nc)
    v_canc_impo_mone      := v_movi_exen_mone; --siempre el importe de cancelacion ser? exento...
    v_canc_impo_mmnn      := v_movi_exen_mmnn;
    v_canc_impo_mmee      := v_movi_exen_mmee;
    v_canc_impo_dife_camb := 0;
  
    /* pp_insert_come_movi_cuot_canc(v_canc_movi_codi,
    v_canc_cuot_movi_codi,
    v_canc_cuot_fech_venc,
    v_canc_fech_pago,
    v_canc_impo_mone,
    v_canc_impo_mmnn,
    v_canc_impo_mmee,
    0);*/
  
    insert into come_movi_cuot_canc
      (canc_movi_codi,
       canc_cuot_movi_codi,
       canc_cuot_fech_venc,
       canc_fech_pago,
       canc_impo_mone,
       canc_impo_mmnn,
       canc_impo_mmee,
       canc_impo_dife_camb,
       canc_base)
    values
      (v_canc_movi_codi,
       v_canc_cuot_movi_codi,
       v_canc_cuot_fech_venc,
       v_canc_fech_pago,
       v_canc_impo_mone,
       v_canc_impo_mmnn,
       v_canc_impo_mmee,
       0,
       parameter.p_codi_base);
    -----------------------------------------------------------------------------------------------------------------------
    --Fin de la cancelacion de  Adelanto...
  
    ------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------
    ---insertar la cancelacion de la/s Factura/s..../ Notas de Debitos......................................................
    ------------------------------------------------------------------------------------------------------------------------
    --Determinar el Tipo de movimiento.......
    --Primero determinamos si el documento es emitido o Recibido y luego si es una nota de credito o un adelanto....
    if g_come_movi.movi_emit_reci = 'E' then
      --es emitido
      v_movi_timo_codi := parameter.p_codi_timo_cnfcre;
    else
      --si es Recibido..
      v_movi_timo_codi := parameter.p_codi_timo_cnfcrr;
    end if;
  
    pp_muestra_come_tipo_movi(v_movi_timo_codi,
                              v_movi_timo_desc,
                              v_movi_timo_desc_abre,
                              v_movi_afec_sald,
                              v_movi_dbcr,
                              v_indi_adel,
                              v_indi_ncr,
                              'N');
  
    v_movi_codi_padr           := g_come_movi.movi_codi; --clave de la cancelacion del adel/Nota de Credito
    v_movi_codi                := fa_sec_come_movi;
    v_movi_clpr_codi           := g_come_movi.movi_clpr_codi;
    v_movi_sucu_codi_orig      := g_come_movi.movi_sucu_codi_orig;
    v_movi_mone_codi           := g_come_movi.movi_mone_codi;
    v_movi_nume                := g_come_movi.movi_nume;
    v_movi_fech_emis           := g_come_movi.movi_fech_emis;
    v_movi_fech_grab           := sysdate;
    v_movi_user                := g_user;
    v_movi_tasa_mone           := g_come_movi.movi_tasa_mone;
    v_movi_tasa_mmee           := 0;
    v_movi_grav_mmnn           := 0;
    v_movi_exen_mmnn           := round((var.s_impo *
                                        g_come_movi.movi_tasa_mone),
                                        parameter.p_cant_deci_mmnn);
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := 0;
    v_movi_exen_mmee           := 0;
    v_movi_iva_mmee            := 0;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := var.s_impo;
    v_movi_iva_mone            := 0;
    v_movi_clpr_desc           := g_come_movi.movi_clpr_desc;
    v_movi_emit_reci           := g_come_movi.movi_emit_reci;
    v_movi_empr_codi           := g_come_movi.movi_empr_codi;
    v_movi_clpr_sucu_nume_item := g_come_movi.movi_clpr_sucu_nume_item;
    v_movi_empl_codi_agen      := g_come_movi.movi_empl_codi_agen;
  
    pp_insert_come_movi(v_movi_codi,
                        v_movi_timo_codi,
                        v_movi_clpr_codi,
                        v_movi_sucu_codi_orig,
                        v_movi_depo_codi_orig,
                        v_movi_sucu_codi_dest,
                        v_movi_depo_codi_dest,
                        v_movi_oper_codi,
                        v_movi_cuen_codi,
                        v_movi_mone_codi,
                        v_movi_nume,
                        v_movi_fech_emis,
                        v_movi_fech_grab,
                        v_movi_user,
                        v_movi_codi_padr,
                        v_movi_tasa_mone,
                        v_movi_tasa_mmee,
                        v_movi_grav_mmnn,
                        v_movi_exen_mmnn,
                        v_movi_iva_mmnn,
                        v_movi_grav_mmee,
                        v_movi_exen_mmee,
                        v_movi_iva_mmee,
                        v_movi_grav_mone,
                        v_movi_exen_mone,
                        v_movi_iva_mone,
                        v_movi_obse,
                        v_movi_sald_mmnn,
                        v_movi_sald_mmee,
                        v_movi_sald_mone,
                        v_movi_stoc_suma_rest,
                        v_movi_clpr_dire,
                        v_movi_clpr_tele,
                        v_movi_clpr_ruc,
                        v_movi_clpr_desc,
                        v_movi_emit_reci,
                        v_movi_afec_sald,
                        v_movi_dbcr,
                        v_movi_stoc_afec_cost_prom,
                        v_movi_empr_codi,
                        v_movi_clave_orig,
                        v_movi_clave_orig_padr,
                        v_movi_indi_iva_incl,
                        v_movi_empl_codi,
                        v_movi_fech_oper,
                        v_movi_clpr_sucu_nume_item,
                        v_movi_Excl_cont,
                        v_movi_empl_codi_agen);
  
    v_canc_movi_codi      := v_movi_codi; --clave del recibo de cn de Fac
    v_canc_cuot_movi_codi := g_come_movi.movi_codi;
    v_canc_cuot_fech_venc := g_come_movi.movi_fech_emis;
    v_canc_fech_pago      := g_come_movi.movi_fech_emis; --fecha de cancelacion de la cuota de NC/adel (= a la fecha de la nc/adel)      
    v_canc_impo_mone      := var.s_impo;
    v_canc_impo_mmnn      := round((var.s_impo * g_come_movi.movi_tasa_mone),
                                   0);
    v_canc_impo_mmee      := 0;
    v_canc_impo_dife_camb := 0;
  
    pp_insert_come_movi_cuot_canc(v_canc_movi_codi,
                                  v_canc_cuot_movi_codi,
                                  v_canc_cuot_fech_venc,
                                  v_canc_fech_pago,
                                  v_canc_impo_mone,
                                  v_canc_impo_mmnn,
                                  v_canc_impo_mmee,
                                  v_canc_impo_dife_camb);
    -----------------------------------------------------------------------------------------------------------------------
    --Fin de la cancelacion de la/s Factura/s  
    -----------------------------------------------------------------------------------------------------------------------
  
    --    |-------------------------------------------------------------|
    --    |Obse. Los movimientos de tipo cance., no afectan caja, ni    |
    --    |tampoco tienen saldo, sirven unicamente para la aplicacion   |
    --    |conrrespondiente de los adelantos y Notas de Creditos,       |
    --    |-------------------------------------------------------------|
  
  Exception
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end;

  PROCEDURE pp_actualiza_apli_adel_ortr IS
    v_ador_codi           number;
    v_ador_fech           date;
    v_ador_fech_grab      date;
    v_ador_user           varchar2(20);
    v_ador_base           number;
    v_ador_adel_movi_codi number;
    v_ador_ortr_codi      number;
    v_ador_impo_mmnn      number;
    v_ador_impo_mone      number;
  
  BEGIN
    --go_block('bortr');
    -- first_record;
    loop
      v_ador_codi           := fa_sec_come_movi_adel_ortr;
      v_ador_fech           := g_come_movi.movi_fech_emis;
      v_ador_fech_grab      := sysdate;
      v_ador_user           := g_user;
      v_ador_base           := parameter.p_codi_base;
      v_ador_adel_movi_codi := g_come_movi.movi_codi;
      v_ador_ortr_codi      := bortr.ortr_codi;
      v_ador_impo_mmnn      := bortr.s_ador_impo *
                               g_come_movi.movi_tasa_mone;
      v_ador_impo_mone      := bortr.s_ador_impo;
      --
      pp_insert_apli_adel_ortr(v_ador_codi,
                               v_ador_fech,
                               v_ador_fech_grab,
                               v_ador_user,
                               v_ador_base,
                               v_ador_adel_movi_codi,
                               v_ador_ortr_codi,
                               v_ador_impo_mmnn,
                               v_ador_impo_mone);
    
    end loop;
  END;

  function fp_concatenar(p_codi in number) return varchar2 IS
  
    v_obse varchar2(100);
  
  BEGIN
  
    if p_codi is not null then
      v_obse := g_come_movi.movi_obse || ' Cont N. ' ||
                to_char(nvl(p_codi, ' '));
    else
      v_obse := g_come_movi.movi_obse;
    end if;
  
    return(ltrim(rtrim(v_obse)));
  
  END fp_concatenar;

  procedure pp_insert_come_movi(p_movi_codi                in number,
                                p_movi_timo_codi           in number,
                                p_movi_clpr_codi           in number,
                                p_movi_sucu_codi_orig      in number,
                                p_movi_depo_codi_orig      in number,
                                p_movi_sucu_codi_dest      in number,
                                p_movi_depo_codi_dest      in number,
                                p_movi_oper_codi           in number,
                                p_movi_cuen_codi           in number,
                                p_movi_mone_codi           in number,
                                p_movi_nume                in number,
                                p_movi_fech_emis           in date,
                                p_movi_fech_grab           in date,
                                p_movi_user                in varchar2,
                                p_movi_codi_padr           in number,
                                p_movi_tasa_mone           in number,
                                p_movi_tasa_mmee           in number,
                                p_movi_grav_mmnn           in number,
                                p_movi_exen_mmnn           in number,
                                p_movi_iva_mmnn            in number,
                                p_movi_grav_mmee           in number,
                                p_movi_exen_mmee           in number,
                                p_movi_iva_mmee            in number,
                                p_movi_grav_mone           in number,
                                p_movi_exen_mone           in number,
                                p_movi_iva_mone            in number,
                                p_movi_obse                in varchar2,
                                p_movi_sald_mmnn           in number,
                                p_movi_sald_mmee           in number,
                                p_movi_sald_mone           in number,
                                p_movi_stoc_suma_rest      in varchar2,
                                p_movi_clpr_dire           in varchar2,
                                p_movi_clpr_tele           in varchar2,
                                p_movi_clpr_ruc            in varchar2,
                                p_movi_clpr_desc           in varchar2,
                                p_movi_emit_reci           in varchar2,
                                p_movi_afec_sald           in varchar2,
                                p_movi_dbcr                in varchar2,
                                p_movi_stoc_afec_cost_prom in varchar2,
                                p_movi_empr_codi           in number,
                                p_movi_clave_orig          in number,
                                p_movi_clave_orig_padr     in number,
                                p_movi_indi_iva_incl       in varchar2,
                                p_movi_empl_codi           in number,
                                p_movi_fech_oper           in date,
                                p_movi_clpr_sucu_nume_item in number,
                                p_movi_excl_cont           in varchar2,
                                p_movi_empl_codi_agen      in number) is
  begin
    insert into come_movi
      (movi_codi,
       movi_timo_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
       movi_depo_codi_orig,
       movi_sucu_codi_dest,
       movi_depo_codi_dest,
       movi_oper_codi,
       movi_cuen_codi,
       movi_mone_codi,
       movi_nume,
       movi_fech_emis,
       movi_fech_grab,
       movi_user,
       movi_codi_padr,
       movi_tasa_mone,
       movi_tasa_mmee,
       movi_grav_mmnn,
       movi_exen_mmnn,
       movi_iva_mmnn,
       movi_grav_mmee,
       movi_exen_mmee,
       movi_iva_mmee,
       movi_grav_mone,
       movi_exen_mone,
       movi_iva_mone,
       movi_obse,
       movi_sald_mmnn,
       movi_sald_mmee,
       movi_sald_mone,
       movi_stoc_suma_rest,
       movi_clpr_dire,
       movi_clpr_tele,
       movi_clpr_ruc,
       movi_clpr_desc,
       movi_emit_reci,
       movi_afec_sald,
       movi_dbcr,
       movi_stoc_afec_cost_prom,
       movi_empr_codi,
       movi_clave_orig,
       movi_clave_orig_padr,
       movi_indi_iva_incl,
       movi_empl_codi,
       movi_fech_oper,
       movi_clpr_sucu_nume_item,
       movi_excl_cont,
       movi_empl_codi_agen,
       movi_base)
    values
      (p_movi_codi,
       p_movi_timo_codi,
       p_movi_clpr_codi,
       p_movi_sucu_codi_orig,
       p_movi_depo_codi_orig,
       p_movi_sucu_codi_dest,
       p_movi_depo_codi_dest,
       p_movi_oper_codi,
       p_movi_cuen_codi,
       p_movi_mone_codi,
       p_movi_nume,
       p_movi_fech_emis,
       p_movi_fech_grab,
       p_movi_user,
       p_movi_codi_padr,
       p_movi_tasa_mone,
       p_movi_tasa_mmee,
       p_movi_grav_mmnn,
       p_movi_exen_mmnn,
       p_movi_iva_mmnn,
       p_movi_grav_mmee,
       p_movi_exen_mmee,
       p_movi_iva_mmee,
       p_movi_grav_mone,
       p_movi_exen_mone,
       p_movi_iva_mone,
       p_movi_obse,
       p_movi_sald_mmnn,
       p_movi_sald_mmee,
       p_movi_sald_mone,
       p_movi_stoc_suma_rest,
       p_movi_clpr_dire,
       p_movi_clpr_tele,
       p_movi_clpr_ruc,
       p_movi_clpr_desc,
       p_movi_emit_reci,
       p_movi_afec_sald,
       p_movi_dbcr,
       p_movi_stoc_afec_cost_prom,
       p_movi_empr_codi,
       p_movi_clave_orig,
       p_movi_clave_orig_padr,
       p_movi_indi_iva_incl,
       p_movi_empl_codi,
       p_movi_fech_oper,
       p_movi_clpr_sucu_nume_item,
       p_movi_excl_cont,
       p_movi_empl_codi_agen,
       parameter.p_codi_base);
  
  end;

  procedure pp_muestra_come_tipo_movi(p_timo_codi      in number,
                                      p_timo_Desc      out char,
                                      p_timo_Desc_abre out char,
                                      p_timo_afec_sald out char,
                                      p_timo_dbcr      out char,
                                      p_timo_indi_adel out char,
                                      p_timo_indi_ncr  out char,
                                      p_indi_vali      in char) is
  
    v_dbcr varchar2(1);
  begin
  
    select timo_desc,
           timo_desc_abre,
           timo_afec_sald,
           timo_dbcr,
           nvl(timo_indi_adel, 'N'),
           nvl(timo_indi_ncr, 'N')
      into p_timo_desc,
           p_timo_desc_abre,
           p_timo_afec_sald,
           p_timo_dbcr,
           p_timo_indi_adel,
           p_timo_indi_ncr
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
    if p_indi_vali = 'S' then
      if p_timo_indi_adel = 'N' and p_timo_indi_ncr = 'N' then
        raise_application_error(-20001,
                                'Solo se pueden ingresar movimientos del tipo Adelantos/Notas de Creditos');
      end if;
    
      if p_timo_indi_adel = 'S' and p_timo_indi_ncr = 'S' then
        raise_application_error(-20001,
                                'El tipo de movimiento esta configurado como Adelanto y Nota de Credito al mismo tiempo, Favor Verificar..');
      end if;
    end if;
    if g_come_movi.movi_emit_reci = 'R' then
      v_dbcr := 'D';
    else
      v_dbcr := 'C';
    end if;
  
    if p_indi_vali = 'S' then
      if p_timo_dbcr <> v_dbcr then
        raise_application_error(-20001, 'Tipo de Movimiento incorrecto');
      end if;
    end if;
  
  Exception
    when no_data_found then
      p_timo_desc_abre := null;
      p_timo_desc      := null;
      p_timo_afec_sald := null;
      p_timo_dbcr      := null;
      p_timo_indi_adel := null;
      p_timo_indi_ncr  := null;
      raise_application_error(-20001, 'Tipo de Movimiento Inexistente!');
    
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

  procedure pp_insert_come_movi_cuot_canc(p_canc_movi_codi      in number,
                                          p_canc_cuot_movi_codi in number,
                                          p_canc_cuot_fech_venc in date,
                                          p_canc_fech_pago      in date,
                                          p_canc_impo_mone      in number,
                                          p_canc_impo_mmnn      in number,
                                          p_canc_impo_mmee      in number,
                                          p_canc_impo_dife_camb in number
                                          
                                          ) is
  begin
    insert into come_movi_cuot_canc
      (canc_movi_codi,
       canc_cuot_movi_codi,
       canc_cuot_fech_venc,
       canc_fech_pago,
       canc_impo_mone,
       canc_impo_mmnn,
       canc_impo_mmee,
       canc_impo_dife_camb,
       canc_base)
    values
      (p_canc_movi_codi,
       p_canc_cuot_movi_codi,
       p_canc_cuot_fech_venc,
       p_canc_fech_pago,
       p_canc_impo_mone,
       p_canc_impo_mmnn,
       p_canc_impo_mmee,
       p_canc_impo_dife_camb,
       parameter.p_codi_base);
  end;

  PROCEDURE pp_insert_apli_adel_ortr(p_ador_codi           in number,
                                     p_ador_fech           in date,
                                     p_ador_fech_grab      in date,
                                     p_ador_user           in char,
                                     p_ador_base           in number,
                                     p_ador_adel_movi_codi in number,
                                     p_ador_ortr_codi      in number,
                                     p_ador_impo_mmnn      in number,
                                     p_ador_impo_mone      in number) is
  BEGIN
    insert into come_movi_apli_adel_ortr
      (ador_codi,
       ador_fech,
       ador_fech_grab,
       ador_user,
       ador_base,
       ador_adel_movi_codi,
       ador_ortr_codi,
       ador_impo_mmnn,
       ador_impo_mone)
    values
      (p_ador_codi,
       p_ador_fech,
       p_ador_fech_grab,
       p_ador_user,
       p_ador_base,
       p_ador_adel_movi_codi,
       p_ador_ortr_codi,
       p_ador_impo_mmnn,
       p_ador_impo_mone);
  END pp_insert_apli_adel_ortr;
  procedure pp_calcular_importe_cab(p_impo_efec  out varchar2,
                                    P_impo_cheq  out varchar2,
                                    P_impo_tarj  out varchar2,
                                    P_impo_vale  out varchar2,
                                    p_impo_viaje out varchar2) is
  begin
  
    --:bcab.movi_exen_mmnn := round(((:bcab.movi_exen_mone)*:bcab.movi_tasa_mone), parameter.p_cant_deci_mmnn);
  
    -- raise_application_error(-20001,'prueba de marisa');
    p_impo_efec := fl_obtener_fmonto('E');
    P_impo_cheq := fl_obtener_fmonto('CH');
    P_impo_tarj := fl_obtener_fmonto('T');
    --P_impo_adel      := i020007.fl_obtener_fmonto('A');
    P_impo_vale  := fl_obtener_fmonto('V');
    p_impo_viaje := fl_obtener_fmonto('VL');
  end pp_calcular_importe_cab;

  function fl_obtener_fmonto(p_tipo_impo in varchar2) return varchar2 is
    v_importe varchar2(200);
  begin
  
    select nvl(ingreso, 0) - nvl(egreso, 0)
      into v_importe
      from (select case
                     when fopa_codi in (1, 5) then
                      'E'
                     when fopa_codi in (2, 4) then
                      'CH'
                     when fopa_codi in (3) then
                      'T'
                     when fopa_codi in (6) then
                      'A'
                     when fopa_codi in (8) then
                      'R'
                   end tipo_importe,
                   
                   sum(case
                         when f.TIFO_SUMA_REST = 'S' then
                          impo
                       end) ingreso,
                   sum(case
                         when f.TIFO_SUMA_REST = 'R' then
                          impo
                       end) egreso
              from v_coll_form_pago f
             group by case
                        when fopa_codi in (1, 5) then
                         'E'
                        when fopa_codi in (2, 4) then
                         'CH'
                        when fopa_codi in (3) then
                         'T'
                        when fopa_codi in (6) then
                         'A'
                        when fopa_codi in (8) then
                         'R'
                      end)
     where tipo_importe = p_tipo_impo;
    return v_importe;
    --  raise_application_error(-20001,v_importe);
  exception
    when no_data_found then
      --  raise_application_error(-20001,v_importe||' Prueba de marisa..');
      return 0;
  end fl_obtener_fmonto;

  PROCEDURE pp_actu_comp IS
    cursor c_tare is
      select t.tare_codi, t.tare_reci_desd, t.tare_reci_hast, t.tare_cant
        from come_talo_reci t
       where t.tare_esta = 'A'
       order by t.tare_codi;
  
    v_ulti_comp  number;
    v_count      number;
    v_count_tare number;
    v_cant_tare  number;
    v_tare_desd  number;
    v_tare_hast  number;
  
  BEGIN
    begin
      select nvl(tare_ulti_nume, 0) + 1
        into v_ulti_comp
        from come_talo_reci
       where tare_esta = 'A'
         and tare_tico_codi = parameter.movi_tico_codi
         and tare_empl_codi = g_come_movi.movi_empl_codi;
    exception
      when no_data_found then
        null;
      when others then
        null;
    end;
  
    if g_come_movi.movi_nume >= v_ulti_comp then
      begin
        update come_talo_reci a
           set a.tare_ulti_nume = g_come_movi.movi_nume
         where a.tare_empl_codi = g_come_movi.movi_empl_codi
           and a.tare_codi = var.movi_tare_codi
           and a.tare_esta = 'A';
      exception
        when others then
          raise_application_error(-20001,
                                  'Error al actualizar ultimo numero de recibo del cobrador seleccionado.');
      end;
    end if;
  
    begin
      update come_reci_salt_auto a
         set a.resa_esta = 'R'
       where resa_tare_codi = var.movi_tare_codi
         and resa_nume_comp = g_come_movi.movi_nume
         and resa_esta = 'A';
    
    exception
      when others then
        raise_application_error(-20001,
                                'Error al actualizar estado de comprobante Autorizado a salto.');
    end;
  
    begin
      select count(*)
        into v_count
        from come_talo_reci a
       where a.tare_reci_hast = g_come_movi.movi_nume
         and a.tare_codi = var.movi_tare_codi
         and a.tare_esta = 'A';
    
      if v_count > 0 then
        select count(*)
          into v_count
          from come_reci_salt_auto
         where resa_tare_codi = var.movi_tare_codi
           and resa_esta = 'A';
      
        if v_count = 0 then
          begin
            update come_talo_reci
               set tare_esta = 'C'
             where tare_codi = var.movi_tare_codi
               and tare_esta = 'A';
          exception
            when others then
              raise_application_error(-20001,
                                      'Error al actualizar estado del Talonario.');
          end;
        end if;
      else
      
        begin
          select tare_cant
            into v_cant_tare
            from come_talo_reci
           where tare_empl_codi = g_come_movi.movi_empl_codi
             and tare_codi = var.movi_tare_codi
             and tare_esta = 'A';
        end;
      
        begin
          select t.tare_reci_desd
            into v_tare_desd
            from come_talo_reci t
           where t.tare_empl_codi = g_come_movi.movi_empl_codi
             and t.tare_tico_codi = var.movi_tico_codi
             and t.tare_codi = var.movi_tare_codi;
        end;
      
        begin
          select t.tare_reci_hast
            into v_tare_hast
            from come_talo_reci t
           where t.tare_empl_codi = g_come_movi.movi_empl_codi
             and t.tare_tico_codi = var.movi_tico_codi
             and t.tare_codi = var.movi_tare_codi;
        end;
      
        begin
          select sum(cant)
            into v_count_tare
            from (select count(distinct(m.movi_nume)) cant
                  --  into v_count_tare
                    from come_movi m
                   where m.movi_timo_codi in (29, 13)
                     and m.movi_empl_codi = g_come_movi.movi_empl_codi
                     and m.movi_nume between v_tare_desd and v_tare_hast
                  union all
                  select count(distinct(a.anul_nume)) cant
                  --  into v_count_tare
                    from come_movi_anul a
                   where a.anul_timo_codi in (29, 13)
                     and a.anul_nume between v_tare_desd and v_tare_hast);
        
          if v_count_tare >= v_cant_tare then
            begin
              update come_talo_reci
                 set tare_esta = 'C'
               where tare_codi = var.movi_tare_codi
                 and tare_esta = 'A';
            exception
              when others then
                raise_application_error(-20001,
                                        'Error al actualizar estado del Talonario.');
            end;
          end if;
        exception
          when others then
            raise_application_error(-20001,
                                    'Error al actualizar estado del Talonario.');
        end;
      end if;
    
    exception
      when no_data_found then
        null;
      when others then
        null;
    end;
  
    -- se verifican todos los talonarios por si alguno quedo activo por error
    for k in c_tare loop
      begin
        select sum(cant)
          into v_count_tare
          from (select count(distinct(m.movi_nume)) cant
                  from come_movi m
                 where m.movi_timo_codi in (29, 13)
                   and m.movi_nume between k.tare_reci_desd and
                       k.tare_reci_hast
                union all
                select count(distinct(a.anul_nume)) cant
                  from come_movi_anul a
                 where a.anul_timo_codi in (29, 13)
                   and a.anul_nume between k.tare_reci_desd and
                       k.tare_reci_hast);
      exception
        when others then
          v_count_tare := 0;
      end;
    
      if v_count_tare >= k.tare_cant or
         v_count_tare >=
         ((nvl(k.tare_reci_hast, 0) - nvl(k.tare_reci_desd, 0)) + 1) then
        begin
          update come_talo_reci
             set tare_esta = 'C'
           where tare_codi = k.tare_codi
             and tare_esta = 'A';
        exception
          when others then
            null;
        end;
      end if;
    end loop;
  
  END pp_actu_comp;

  PROCEDURE pl_valida_clie_prov_cheq IS
  BEGIN
    for i in (select cheq_clpr_codi, fopa_codi
                from v_coll_form_pago
               where fopa_codi in ('2', '4')) loop
      if i.fopa_codi in ('2', '4') then
        if nvl(i.cheq_clpr_codi, -999) <>
           nvl(g_come_movi.movi_clpr_codi, -888) then
          raise_application_error(-20001,
                                  'El codigo del cliente/proveedor de la cabecera no coincide con el del detalle del cheque');
        end if;
      end if;
    
    end loop;
  
  END pl_valida_clie_prov_cheq;

  procedure pp_set_variable is
  begin
  
    var.s_impo                 := v('p124_S_IMPO');
    var.w_movi_sald            := v('P124_W_MOVI_SALD');
    var.p_para_inic            := v('p124_para_inic');
    var.movi_timo_indi_caja    := V('p124_MOVI_TIMO_INDI_CAJA');
    var.s_impo_efec            := (V('p124_S_IMPO_EFEC'));
    var.s_impo_cheq            := (V('p124_S_IMPO_CHEQ'));
    var.s_impo_tarj            := (v('p124_S_IMPO_TARJ'));
    var.s_impo_vale            := (v('p124_S_IMPO_VALE'));
    var.s_impo_viaj            := (v('p124_S_IMPO_VIAJ'));
    var.movi_mone_cant_deci    := v('p124_movi_mone_cant_deci');
    var.w_movi_codi            := v('P124_MOVI_CODI');
    var.w_movi_fech_emis       := v('P124_W_MOVI_FECH_EMIS');
    g_come_movi.movi_nume      := v('p124_MOVI_NUME');
    g_come_movi.movi_clpr_codi := v('p124_CLPR_CODI');
    g_come_movi.movi_fech_emis := v('p124_S_MOVI_FECH_EMIS');
    g_come_movi.movi_mone_codi := v('p124_MOVI_MONE_CODI');
    g_come_movi.movi_fech_oper := v('p124_S_MOVI_FECH_OPER');
    g_come_movi.movi_fech_grab := sysdate;
    g_come_movi.movi_user      := g_user;
  
    g_come_movi.movi_sucu_codi_orig := v('p124_MOVI_SUCU_CODI_ORIG');
    g_come_movi.movi_timo_codi      := v('p124_MOVI_TIMO_CODI');
    g_come_movi.movi_tasa_mone      := v('p124_MOVI_TASA_MONE');
    g_come_movi.movi_obse           := v('p124_MOVI_OBSE');
    g_come_movi.movi_clpr_dire      := v('p124_CLPR_DIRE');
    g_come_movi.movi_clpr_tele      := v('p124_CLPR_TELE');
    g_come_movi.movi_clpr_ruc       := v('p124_CLPR_RUC');
    g_come_movi.movi_clpr_desc      := v('p124_MOVI_CLPR_DESC');
    g_come_movi.movi_emit_reci      := v('p124_MOVI_EMIT_RECI');
    g_come_movi.movi_afec_sald      := v('p124_MOVI_AFEC_SALD');
    g_come_movi.movi_dbcr           := v('p124_MOVI_DBCR');
    g_come_movi.movi_empr_codi      := nvl(v('AI_EMPR_CODI'), 1);
    g_come_movi.movi_empl_codi      := v('p124_MOVI_EMPL_CODI');
  
    g_come_movi.movi_clpr_sucu_nume_item := v('p124_SUCU_NUME_ITEM');
    --  raise_application_error(-20001,'aa');
    g_come_movi.movi_empl_codi_agen := v('p124_MOVI_EMPL_CODI');
  
  end pp_set_variable;

  PROCEDURE pp_vali_comp_exis IS
    v_count number;
  BEGIN
    select count(*)
      into v_count
      from come_movi
     where movi_timo_codi = g_come_movi.movi_timo_codi
       and movi_nume = g_come_movi.movi_nume;
    if v_count > 0 then
      raise_application_error(-20001, 'Numero de Comprobante ya Existe.');
    end if;
  END pp_vali_comp_exis;

  procedure pp_devu_nume_comp(p_movi_tico_codi in number,
                              p_movi_empl_codi in number,
                              p_movi_nume      out number,
                              p_movi_tare_codi out number,
                              p_ind_duplicado  out varchar2) is
    v_tare_reci_desd number;
    v_tare_reci_hast number;
  begin
    select nvl(tare_ulti_nume, 0) + 1,
           tare_codi,
           tare_reci_desd,
           tare_reci_hast
      into p_movi_nume,
           p_movi_tare_codi,
           v_tare_reci_desd,
           v_tare_reci_hast
      from come_talo_reci
     where tare_esta = 'A'
       and tare_tico_codi = p_movi_tico_codi
       and tare_empl_codi = p_movi_empl_codi;
    if p_movi_nume > v_tare_reci_hast then
      p_movi_nume := v_tare_reci_desd;
    end if;
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'El cobrador no tiene un talonario activo. Asigne un talonario al cobrador seleccionado.');
    when too_many_rows then
      p_ind_duplicado  := 'S';
      p_movi_tare_codi := null;
    
    --pp_devu_nume_comp_dupl;
    -- pl_me('El cobrador tiene mas de un talonario activo.');
  
  end pp_devu_nume_comp;

  procedure pp_Actualizar_registro is
    salir    exception;
    v_record number;
  begin
    pp_set_variable;
    pp_valida; --ok
  
    pp_valida_importes; --ok
  
    pp_actualiza_come_movi; --ok
  
    pp_actualiza_come_movi_cuot; --ok
  
    pp_actualiza_moimpu; --ok
  
    pp_actualiza_moco; --ok
  
    if var.cont_codi is not null then
    
      pp_actualiza_como; --ok
    
    end if;
  
/*    pack_fpago.pl_fp_actualiza_moimpo(i_movi_clpr_codi      => g_come_movi.movi_clpr_codi,
                                      i_movi_clpr_desc      => g_come_movi.movi_clpr_desc,
                                      i_movi_clpr_ruc       => g_come_movi.movi_clpr_ruc,
                                      i_movi_codi           => g_come_movi.movi_codi,
                                      i_movi_dbcr           => g_come_movi.movi_dbcr,
                                      i_movi_emit_reci      => g_come_movi.movi_emit_reci,
                                      i_movi_empr_codi      => g_come_movi.movi_empr_codi,
                                      i_movi_fech_emis      => g_come_movi.movi_fech_emis,
                                      i_movi_fech_oper      => g_come_movi.movi_fech_oper,
                                      i_movi_mone_cant_deci => var.movi_mone_cant_deci,
                                      i_movi_sucu_codi_orig => g_come_movi.movi_sucu_codi_orig,
                                      i_movi_tasa_mone      => g_come_movi.movi_tasa_mone,
                                      i_movi_timo_codi      => g_come_movi.movi_timo_codi,
                                      i_s_impo_rete         => var.s_impo_rete,
                                      i_s_impo_rete_rent    => var.s_impo_rete_rent);*/
  
    pp_actu_secu;
  
    if parameter.p_indi_most_ortr_adel = 'N' then
      null;
    else
      if bortr.sum_ador_impo <> 0 then
        pp_actualiza_apli_adel_ortr;
      end if;
    end if;
  
    if var.p_para_inic not in ('AC', 'AP') then
      pp_actualiza_canc;
    end if;
  
    if var.p_para_inic = 'AC' then
      pp_actu_comp;
    end if;
  
    --pp_llama_reporte;
    if g_come_movi.movi_emit_reci = 'E' then
      --pl_impr_reci(g_come_movi.movi_codi, parameter.p_form_impr_reci_adel, null, null);
      null;
    end if;
  
    if parameter.p_indi_impr_cheq_emit = 'S' then
    
      --pp_impr_cheq_emit;
      null;
    
    end if;
  
    -- end if;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_Actualizar_registro;

  ---------------------------------------------------------------------------------------
  function fp_get_come_tipo_movi(i_filtro    in varchar2,
                                 i_emit_reci in varchar2) return varchar2 is
  
    v_return varchar2(1000) := null;
  
  begin
  
    -- Busqueda por codigo alternativo
    begin
      select t.timo_codi
        into v_return
        from come_tipo_movi t
       where timo_emit_reci = NVL(i_emit_reci,'E')
         and t.timo_codi_alte = i_filtro
         and t.timo_empr_codi = fa_empresa
         and (nvl(timo_indi_adel, 'N') = 'S' or nvl(timo_indi_ncr, 'N') = 'S')
         and timo_dbcr = decode(timo_emit_reci, 'R', 'D', 'C');
      return v_return;
    exception
      when no_data_found then
        null;
      when invalid_number then
        null;
      when others then
        return null;
    end;
  
    -- Busqueda por descripcion
    begin
      select t.timo_codi
        into v_return
        from come_tipo_movi t
       where timo_emit_reci = NVL(i_emit_reci,'E')
         and t.timo_empr_codi = fa_empresa
         and (nvl(timo_indi_adel, 'N') = 'S' or nvl(timo_indi_ncr, 'N') = 'S')
         and timo_dbcr = decode(timo_emit_reci, 'R', 'D', 'C')
         and upper(t.timo_Desc) like '%' || upper(i_filtro) || '%';         
      return v_return;
    exception
      when no_data_found then
        null;
      when others then
        return null;
    end;
  
    return null;
  
  end fp_get_come_tipo_movi;

  ---------------------------------------------------------------------------------------
  function fp_get_empl_cobr(i_filtro    in varchar2) return varchar2 is
  
    v_return varchar2(1000) := null;
  
  begin
  
    -- Busqueda por codigo alternativo
    begin
      select e.empl_codi
        into v_return
        from come_empl e, come_empl_tiem t
       where e.empl_codi_alte = i_filtro
         and e.empl_codi = t.emti_empl_codi
         and nvl(empl_esta, 'A') = 'A'
         and t.emti_tiem_codi = to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_cobr'))
         and e.empl_empr_codi = fa_empresa;
   
      return v_return;
    exception
      when no_data_found then
        null;
      when invalid_number then
        null;
      when others then
        return null;
    end;
  
    -- Busqueda por descripcion
    begin
      select e.empl_codi
        into v_return
        from come_empl e, come_empl_tiem t
       where e.empl_codi = t.emti_empl_codi
         and nvl(empl_esta, 'A') = 'A'
         and t.emti_tiem_codi = to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_cobr'))
         and e.empl_empr_codi = fa_empresa
         and upper(empl_desc) like '%' || upper(i_filtro) || '%';

      return v_return;
    exception
      when no_data_found then
        null;
      when others then
        return null;
    end;
  
    return null;
  
  end fp_get_empl_cobr;

end I0202024;
