
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020017" is

  type r_variable is record(
    movi_fech_emis           come_movi.movi_fech_emis%type,
    movi_clpr_codi           come_movi.movi_clpr_codi%type,
    movi_sucu_codi_orig      come_movi.movi_sucu_codi_orig%type,
    movi_mone_codi           come_movi.movi_mone_codi%type,
    movi_nume                come_movi.movi_nume%type,
    movi_tasa_mone           come_movi.movi_tasa_mone%type,
    movi_clpr_desc           come_movi.movi_clpr_desc%type,
    movi_empr_codi           come_movi.movi_empr_codi%type,
    movi_impo_inte_mmnn      come_movi.movi_impo_inte_mmnn%type,
    sucu_nume_item           number, 
    movi_codi                come_movi.movi_codi%type,
    movi_impo_inte_mone      come_movi.movi_impo_inte_mone%type,
    movi_empl_codi           come_movi.movi_empl_codi%type,
    sum_impo_pago            number,
    s_dife                   number,
    movi_timo_indi_adel      varchar2(5),
    movi_timo_indi_ncr       varchar2(5),
    calc_rete                varchar2(2),
    sum_impo_rete_mone       number,
    movi_mone_cant_deci      number,
    impu_porc                number,
    movi_timo_codi           number,
    impu_porc_base_impo      number,
    p_para_inic              varchar2(5),
    impu_indi_baim_impu_incl number,
    w_movi_fech_emis         date,
    cuot_impu_codi           number,
    movi_tico_codi           number,
    s_total                  number,
    s_impo_rete_rent         number,
    movi_fech_apli           date,
    impo_rete_mone           number,
    movi_codi_nota           number,
    MOVI_FACT_CODI           number,
    movi_codi_apli           number);
  bcab r_variable;

  type r_retencion is record(
    movi_nume_rete           number,
    movi_nume_timb_rete      number,
    movi_fech_venc_timb_rete date,
    movi_obse                varchar2(2000));
  rete r_retencion;

  type r_parameter is record(
    p_peco_codi         number := 1,
    ---adelanto a cliente...
    p_codi_timo_adle    number := to_number(general_skn.fl_busca_parametro('p_codi_timo_adle')),
    p_codi_timo_rcnadle number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rcnadle')),
    p_codi_timo_rcnadlr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rcnadlr')),
    
    --recibo de cn notas de cred. de clientes y proveedores  
    p_codi_timo_cnncre number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnncre')),
    p_codi_timo_cnncrr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnncrr')),
    
    --recibo de cn de facturas emitidas y recibidas
    p_codi_timo_cnfcrr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnfcrr')),
    p_codi_timo_cnfcre number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnfcre')),
    
    p_codi_impu_exen number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_codi_mone_mmnn number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    
    p_cant_deci_mmnn      number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_cant_deci_mmee      number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmee')),
    p_codi_timo_rete_emit number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rete_emit')),
    p_imp_min_aplic_reten number := to_number(general_skn.fl_busca_parametro('p_imp_min_aplic_reten')),
    p_porc_aplic_reten    number := to_number(general_skn.fl_busca_parametro('p_porc_aplic_reten')),
    p_codi_conc_rete_emit number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_emit')),
    p_form_impr_rete      varchar2(5) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_rete'))),
    p_codi_prov_espo      number := to_number(general_skn.fl_busca_parametro('p_codi_prov_espo')),
    p_nave_dato_rete      varchar2(5) := ltrim(rtrim(general_skn.fl_busca_parametro('p_nave_dato_rete'))),
    p_indi_nave_dato_rete varchar2(1) := 'N',
    p_form_calc_rete_emit number := to_number(general_skn.fl_busca_parametro('p_form_calc_rete_emit')),
    
    p_indi_porc_rete_sucu varchar2(2) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_porc_rete_sucu'))),
    
    p_indi_rete_tesaka varchar2(2) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_rete_tesaka'))),
    
    p_canc_codi_fcrr number,
    p_movi_codi_rete number,
    p_movi_nume_rete number,
    p_emit_reci      varchar2(2) := v('P105_EMIT_RECI')
    
    );

  parameter r_parameter;

  cursor detalle is
    select seq_id,
           c001   ind_marcado,
           c002   movi_nume,
           c003   movi_mone_codi,
           c004   movi_fech_emis,
           c005   cuot_fech_venc,
           c006   cuot_tasa_mone, --movi_tasa_mone,
           c007   timo_desc_abre,
           c008   cuot_impo_mone,
           c009   cuot_sald_mone,
           c010   cuot_movi_codi,
           c011   cuot_tipo,
           c012   impo_pago,
           c013   impo_rete_mone,
           c014   S_IMPO_PAGO_ADEL,
           c015   apli_rete,
           c016   v_impo_pago_mmnn,
           c017   movi_fact_codi
      from apex_collections a
     where collection_name = 'BDETALLE'
       and c001 = 'X';

  procedure pp_iniciar(p_para_inic in varchar2) is
    v_empr_retentora varchar2(3);
  begin
    if rtrim(ltrim(upper(p_para_inic))) = rtrim(ltrim(upper('P'))) then
      setitem('P105_EMIT_RECI', 'R');
      setitem('P105_CLPR_INDI_CLIE_PROV', 'P');
      
    elsif rtrim(ltrim(upper(p_para_inic))) = rtrim(ltrim(upper('C'))) then
      setitem('P105_CLPR_INDI_CLIE_PROV', 'C');
      setitem('P105_EMIT_RECI', 'E');
      setitem('P105_S_CALC_RETE', 'N');
    end if;
  
    begin
      select nvl(e.empr_retentora, 'NO')
        into v_empr_retentora
        from come_empr e
       where e.empr_codi = v('AI_EMPR_CODI');
      setitem('P105_EMPR_RETENTORA', v_empr_retentora);
    
    exception
      when no_data_found then
        raise_application_error(-20001, 'Empresa seleccionada inexistente');
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  end pp_iniciar;

  procedure pp_muestra_come_tipo_movi(p_timo_codi      in number,
                                      p_timo_desc      out varchar2,
                                      p_timo_desc_abre out varchar2,
                                      p_timo_afec_sald out varchar2,
                                      p_timo_dbcr      out varchar2,
                                      p_timo_indi_adel out varchar2,
                                      p_timo_indi_ncr  out varchar2,
                                      p_indi_vali      in varchar2) is
  
    v_dbcr varchar2(1);
  begin
   dbms_output.put_line('tipomovi 1: '||p_timo_codi);
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
      dbms_output.put_line('tipomovi 2: '||p_timo_codi);
      if p_timo_indi_adel = 'N' and p_timo_indi_ncr = 'N' then
        dbms_output.put_line('tipomovi 4: '||p_timo_codi);
        raise_application_error(-20001,
                                'Solo se pueden ingresar movimientos del tipo Adelantos/Notas de Creditos');
      end if;
    
      if p_timo_indi_adel = 'S' and p_timo_indi_ncr = 'S' then
         dbms_output.put_line('tipomovi 5: '||p_timo_codi);
        raise_application_error(-20001,
                                'El tipo de movimiento esta configurado como Adelanto y Nota de Credito al mismo tiempo, Favor Verificar..');
      end if;
    end if;
     dbms_output.put_line('tipomovi 6: '||p_timo_codi);
    if parameter.p_emit_reci = 'R' then
      v_dbcr := 'D';
    else
      v_dbcr := 'C';
    end if;
   dbms_output.put_line('tipomovi 7: '||p_timo_codi);
    if p_indi_vali = 'S' then
      if p_timo_dbcr <> v_dbcr then
         dbms_output.put_line('tipomovi 8: '||p_timo_codi);
        raise_application_error(-20001, 'Tipo de Movimiento incorrecto');
      end if;
    end if;
  
    if nvl(p_timo_indi_adel, 'N') = 'N' then
      --set_item_property('bcab.s_calc_rete', enabled, property_false);
      bcab.calc_rete := 'N';
    end if;
   dbms_output.put_line('tipomovi 9: '||p_timo_codi);
  exception
    when no_data_found then
       dbms_output.put_line('tipomovi 10: '||p_timo_codi);
      p_timo_desc_abre := null;
      p_timo_desc      := null;
      p_timo_afec_sald := null;
      p_timo_dbcr      := null;
      p_timo_indi_adel := null;
      p_timo_indi_ncr  := null;
      raise_application_error(-20001, 'Tipo de Movimiento Inexistente!');
    when others then
       dbms_output.put_line('tipomovi 11: '||p_timo_codi);
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_come_tipo_movi;

  procedure pp_muestra_come_mone(p_movi_mone_codi      in number,
                                 p_movi_mone_desc      out varchar2,
                                 p_movi_mone_desc_abre out varchar2,
                                 p_movi_mone_cant_deci out varchar2)
  
   is
  begin
    select j.mone_desc, j.mone_desc_abre, j.mone_cant_deci
      into p_movi_mone_desc, p_movi_mone_desc_abre, p_movi_mone_cant_deci
      from come_mone j
     where j.mone_codi = p_movi_mone_codi;
  exception
    when no_data_found then
      raise_application_error(-20001, 'Moneda inexistente.');
    when others then
      raise_application_error(-20001,
                              'Error en pp_muestra_come_mone ' || sqlerrm);
    
  end pp_muestra_come_mone;

  procedure pp_muestra_come_clpr(p_clpr_codi           in number,
                                 p_clpr_indi_clie_prov in varchar2,
                                 p_movi_clpr_desc      out varchar2)
  
   is
  begin
    select clpr_desc
      into p_movi_clpr_desc
      from come_clie_prov f
     where f.clpr_codi = p_clpr_codi
       and f.clpr_indi_clie_prov = p_clpr_indi_clie_prov;
  
  exception
    when no_data_found then
      if p_clpr_indi_clie_prov = 'C' then
        raise_application_error(-20001, 'Cliente inexistente.');
      elsif p_clpr_indi_clie_prov = 'P' then
        raise_application_error(-20001, 'Proveedor inexistente.');
      end if;
    
  end pp_muestra_come_clpr;

  procedure pp_muestra_sub_cuenta(p_clpr_codi      in number,
                                  p_sucu_nume_item in number,
                                  p_sucu_desc      out char) is
  begin
    if p_sucu_nume_item = 0 then
      p_sucu_desc := 'Cuenta Principal';
    else
      select sucu_desc
        into p_sucu_desc
        from come_clpr_sub_cuen
       where sucu_clpr_codi = p_clpr_codi
         and sucu_nume_item = p_sucu_nume_item;
    end if;
  exception
    when no_data_found then
      raise_application_error(-20001, 'SubCuenta inexistente');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_sub_cuenta;

  procedure pp_validar_sub_cuenta(p_movi_clpr_codi in number,
                                  p_indi_vali_subc out varchar2) is
    v_count number := 0;
  begin
    select count(*)
      into v_count
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_movi_clpr_codi;
    if v_count > 0 then
      p_indi_vali_subc := 'S';
    else
      p_indi_vali_subc := 'N';
    end if;
  
  end pp_validar_sub_cuenta;

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
  
  end;
  procedure pp_validar_fech_apli(p_movi_fech_apli in date,
                                 p_movi_fech_emis in date) is
  begin
  
    pp_valida_fech(p_movi_fech_apli);
  
    if p_movi_fech_emis is not null then
      if p_movi_fech_apli < p_movi_fech_emis then
        raise_application_error(-20001,
                                'La fecha de aplicacion no puede ser inferior a la fecha de adelanto o nota de credito!');
      end if;
    end if;
  end pp_validar_fech_apli;

  procedure pp_validar_nume(p_movi_nume      in number,
                            p_movi_fech_apli in date,
                            p_movi_fech_emis in date) is
  begin
    if p_movi_nume is null then
      raise_application_error(-20001,
                              'Debe introducir el nro. de recibo!.');
    end if;
  
    if p_movi_fech_apli < p_movi_fech_emis then
      raise_application_error(-20001,
                              'La fecha de aplicacion no puede ser inferior a la fecha de adelanto o nota de credito!');
    end if;
  end pp_validar_nume;

  procedure pp_busca_movi_nume(p_movi_nume                in number,
                               p_movi_timo_codi           in number,
                               p_movi_mone_codi           in number,
                               p_movi_clpr_codi           in number,
                               p_sucu_nume_item           in number,
                               p_movi_codi                out number,
                               p_total                    out number,
                               p_movi_fech_emis           out date,
                               p_movi_sucu_codi_orig      out number,
                               p_movi_tasa_mone           out number,
                               p_movi_sald_mone           out number,
                               p_cuot_impu_codi           out number,
                               p_impu_porc                out number,
                               p_impu_porc_base_impo      out number,
                               p_impu_indi_baim_impu_incl out number) is
    v_sucu_nume_item number;
    v_ind_movi_codi  varchar2(10);
    v_movi_fact_codi number;
  begin
  
    begin
      select movi_codi,
             sum(cuot_impo_mone) total,
             movi_fech_emis,
             movi_sucu_codi_orig,
             movi_tasa_mone,
             movi_clpr_sucu_nume_item,
             sum(cuot_sald_mone) movi_sald_mone,
             cuot_impu_codi,
             movi_fact_codi
        into p_movi_codi,
             p_total,
             p_movi_fech_emis,
             p_movi_sucu_codi_orig,
             p_movi_tasa_mone,
             v_sucu_nume_item,
             p_movi_sald_mone,
             p_cuot_impu_codi,
             v_movi_fact_codi
        from come_movi, come_movi_cuot
       where movi_codi = cuot_movi_codi
         and movi_timo_codi = p_movi_timo_codi
         and movi_nume = p_movi_nume
         and movi_clpr_codi = p_movi_clpr_codi
         and movi_mone_codi = p_movi_mone_codi
       group by movi_codi,
                movi_fech_emis,
                movi_sucu_codi_orig,
                movi_tasa_mone,
                movi_clpr_sucu_nume_item,
                cuot_impu_codi,
                movi_fact_codi;
    
   
      if p_sucu_nume_item = 0 then
        if v_sucu_nume_item is not null then
          p_movi_codi := null;
          raise_application_error(-20001,
                                  'El documento seleccionado pertenece a una Subcuenta');
        end if;
      elsif nvl(p_sucu_nume_item, 0) <> 0 then
        if v_sucu_nume_item <> p_sucu_nume_item then
          p_movi_codi := null;
          raise_application_error(-20001,
                                  'El documento seleccionado pertenece a una Subcuenta distinta a la seleccionada');
        end if;
      end if;
    
      if p_cuot_impu_codi is not null then
        pp_mostrar_impu(p_cuot_impu_codi,
                        p_impu_porc,
                        p_impu_porc_base_impo,
                        p_impu_indi_baim_impu_incl);
      end if;
      
     
    exception
      when no_data_found then
      setitem(v('P105_MOVI_FACT_CODI'),null);
    
        raise_application_error(-20001, 'Numero de Movimiento inexistente');
      when too_many_rows then
        pp_valida_nume_movi(p_movi_timo_codi, p_movi_nume, v_ind_movi_codi);
    end;
  
    if p_movi_sald_mone <= 0 then
      raise_application_error(-20001, 'El Movimiento no posee saldo..');
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Movimiento Inexistente');
    when too_many_rows then
      raise_application_error(-20001, 'Nro. de Movimiento Duplicado');
    when others then
      raise_application_error(-20001, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||' - '||sqlerrm);
  end pp_busca_movi_nume;

  procedure pp_mostrar_impu(p_cuot_impu_codi           in number,
                            p_impu_porc                out number,
                            p_impu_porc_base_impo      out number,
                            p_impu_indi_baim_impu_incl out number) is
  begin
  
    select impu_porc,
           impu_porc_base_impo,
           nvl(impu_indi_baim_impu_incl, 'S')
      into p_impu_porc, p_impu_porc_base_impo, p_impu_indi_baim_impu_incl
      from come_impu
     where impu_codi = p_cuot_impu_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Tipo de Impuesto inexistente');
    when too_many_rows then
      raise_application_error(-20001, 'Tipo de Impuesto duplicado');
    when others then
      raise_application_error(-20001, 'When others...' || sqlerrm);
  end pp_mostrar_impu;

  procedure pp_validar_fecha_aplicacion(p_fech_apli      in date,
                                        p_fech_fact      in date,
                                        p_movi_timo_desc in varchar2) is
  begin
    if p_fech_apli < p_fech_fact then
      raise_application_error(-20001,
                              'No se puede aplicar ' || p_movi_timo_desc ||
                              ' a esta factura ya que la fecha de aplicacion' ||
                              ' es menor que la fecha de la factura.');
    end if;
  end pp_validar_fecha_aplicacion;

  procedure pp_valida_nume_movi(p_movi_timo_codi in number,
                                p_movi_nume      in number,
                                p_ind_movi_codi  out varchar2) is
    salir  exception;
    v_cant number := 0;
  
  begin
  
    begin
      select count(*)
        into v_cant
        from come_movi
       where movi_nume = p_movi_nume
         and (movi_timo_codi = p_movi_timo_codi)
         and (movi_nume = p_movi_nume);
    end;
  
    if v_cant > 1 then
      --si existe mas de una factura con el mismo nro
      --p_movi_codi      := null;      --para ver si se acepto un valor o no despues del list_values
      --list_values;     
      -- pp_busca_movi_codi;
      p_ind_movi_codi := 'S';
    end if;
    if v_cant = 0 then
      raise_application_error(-20001, 'Movimiento inexistente');
    end if;
  
    ----------------------------------------------------------------------------------
  
  exception
    when salir then
      null;
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_valida_nume_movi;

  procedure pp_cargar_bloque_det(p_sucu_nume_item in number,
                                 p_movi_empr_codi in number,
                                 p_movi_mone_codi in number,
                                 p_movi_clpr_codi in number,
                                 p_emit_reci      in varchar2,
                                 p_impo_a_apli    out varchar2) is
  
    cursor c_vto is
      select movi_nume,
             movi_fech_emis,
             cuot_fech_venc,
             cuot_impo_mone ,
             cuot_sald_mone,
             movi_codi,
             movi_tasa_mone,
             timo_desc,
             timo_desc_abre,
             cuot_tipo,
             movi_mone_codi,
             d.movi_fact_codi
        from come_movi d, come_movi_cuot, come_tipo_movi
       where movi_codi = cuot_movi_codi
         and movi_clpr_codi = p_movi_clpr_codi
         and timo_codi = movi_timo_codi
         and cuot_sald_mone > 0
         and movi_mone_codi = p_movi_mone_codi
         and movi_dbcr = decode(p_emit_reci, 'E', 'D', 'R', 'C')
         and nvl(movi_empr_codi, 1) = p_movi_empr_codi
         and ((p_sucu_nume_item is null) or
             (p_sucu_nume_item is not null and
             p_sucu_nume_item = movi_clpr_sucu_nume_item) or
             (p_sucu_nume_item = 0 and movi_clpr_sucu_nume_item is null))
       order by cuot_fech_venc, movi_fech_emis, movi_nume;
  
  begin
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
  
    for x in c_vto loop
      apex_collection.add_member(p_collection_name => 'BDETALLE',
                                 p_c001            => null, ---ind_marcado
                                 p_c002            => x.movi_nume,
                                 p_c003            => x.movi_mone_codi,
                                 p_c004            => x.movi_fech_emis,
                                 p_c005            => x.cuot_fech_venc,
                                 p_c006            => x.movi_tasa_mone,
                                 p_c007            => x.timo_desc_abre,
                                 p_c008            => x.cuot_impo_mone,
                                 p_c009            => x.cuot_sald_mone,
                                 p_c010            => x.movi_codi,
                                 p_c011            => x.cuot_tipo,
                                 p_c017            => x.movi_fact_codi);
    
    end loop;
  
    declare
      v_count              number;
      v_sald_mone_con_rete number;
      v_sum_cuot_sald_mone number;
    begin
      select count(c010) movi_codi,
              sum(c009) v_sum_cuot_sald_mone,
              sum(c013) v_sald_mone_con_rete
        into v_count, v_sum_cuot_sald_mone, v_sald_mone_con_rete
        from apex_collections a
       where collection_name = 'BDETALLE';
   
      if v_count = 0 then
        if v('P105_CLPR_INDI_CLIE_PROV') = 'C' then
          raise_application_error(-20001,
                                  'El Cliente no posee comprobantes pendientes!');
        else
          raise_application_error(-20001,
                                  'El Proveedor no posee comprobantes pendientes!');
        end if;
      end if;
    
      if v_sum_cuot_sald_mone > v_sald_mone_con_rete then
        p_impo_a_apli := v_sald_mone_con_rete;
      else
        p_impo_a_apli := v_sum_cuot_sald_mone;
      end if;
    end;
 
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_cargar_bloque_det;

  procedure pp_valida_importes is
  
  begin
   IF NVL(v('P105_IMPO_A_APLI'), 0) > 0 THEN
      IF NVL(v('P105_IMPO_A_APLI'), 0) > NVL(v('P105_MOVI_SALD_MONE'), 0) THEN
        raise_application_error(-20001,
                                'El importe a aplicar no puede ser mayor al saldo del documento '||v('P105_MOVI_SALD_MONE'));
      END IF;
    
   
    
    END IF;

    if bcab.s_dife < 0 then
      raise_application_error(-20001,
                              'El Saldo del movimiento no puede ser menor a la sumatoria aplicada');
    end if;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_valida_importes;

  procedure pp_validar_marcado(p_seq_id         in number,
                               p_dife           in number,
                               p_movi_fech_apli in date,
                               p_movi_timo_desc in varchar2,
                               p_estado         in varchar2) is
    v_impo_pago number;
  begin
  if p_estado='X' THEN
    if p_dife <= 0 then
      raise_application_error(-20001,
                              'El importe de la distribucion de pagos es mayor al importe del recibo.');
    end if;
    
    END IF;

  
    for i in (select c004 movi_fech_emis,
                     c008 cuot_impo_mone,
                     round(to_number(c009),v('P105_MOVI_MONE_CANT_DECI')) cuot_sald_mone,
                     c012 impo_pago,
                     c013 impo_rete_mone,
                     c010  cuot_movi_codi
                from apex_collections a
               where collection_name = 'BDETALLE'
                 and seq_id = p_seq_id) loop
                 
                 pp_validar_aplicacion_nc(i.cuot_movi_codi);
    
      IF NVL(p_DIFE, 0) > 0 THEN
               --   raise_application_error(-20001,'El Importe de la nota de credito no puede se mayor que la cuota'||v('P105_S_TOTAL'));
         
         /*if v('P105_S_TOTAL')>  round(to_number(i.cuot_sald_mone),v('P105_MOVI_MONE_CANT_DECI')) and v('P105_MOVI_TIMO_CODI')=9 then
          raise_application_error(-20001,'La nota de credito aplicada no puede exceder el monto de la cuota.
                                           Verifica la informacion e intenta nuevamente. '||round(i.cuot_sald_mone,v('P105_MOVI_MONE_CANT_DECI'))||' - '||v('P105_S_TOTAL')||' - '||p_DIFE);
         end if;*/
         
         
        if i.cuot_sald_mone <= p_dife and i.impo_pago is null then
          v_impo_pago := i.cuot_sald_mone;
        else
        
          if i.impo_pago is null then
            v_impo_pago := p_dife;
          end if;
        end if;
      END IF;
      I020017.pp_update_member(p_seq_id  => p_seq_id,
                               p_valor   => v_impo_pago,
                               p_nro_upd => 12);
    
      pp_validar_fecha_aplicacion(p_movi_fech_apli,
                                  i.movi_fech_emis,
                                  p_movi_timo_desc);
    
    end loop;
    
        I020017.pp_update_member(p_seq_id, P_ESTADO, 1);
  
  end pp_validar_marcado;

  procedure pp_update_member(p_seq_id  in number,
                             p_valor   in varchar2,
                             p_nro_upd in number) is
  begin
    apex_collection.update_member_attribute(p_collection_name => 'BDETALLE',
                                            p_seq             => p_seq_id,
                                            p_attr_number     => p_nro_upd,
                                            p_attr_value      => p_valor);
  end pp_update_member;

  procedure pp_import_dif(p_movi_sald_mone in number, p_dife out varchar2) is
  begin
    for i in (select sum(c012) sum_impo_pago, sum(c013) sum_impo_rete_mone
                from apex_collections a
               where collection_name = 'BDETALLE'
                 and c001 = 'X'
                 ) loop
      p_dife := nvl(p_movi_sald_mone, 0) - nvl(i.sum_impo_pago, 0) +
                nvl(i.sum_impo_rete_mone, 0);
    
    end loop;
  end pp_import_dif;

  procedure pp_calcular_importe_det(p_emit_reci           in varchar2,
                                    p_empr_retentora      in varchar2,
                                    p_calc_rete           in varchar2,
                                    p_movi_tasa_mone      in number,
                                    p_movi_empr_codi      in number,
                                    p_movi_sald_mone      in number,
                                    p_movi_mone_cant_deci in number,
                                    p_movi_sucu_codi_orig in number,
                                    p_movi_impo_rete     out number,
                                    p_impo_rete_mone     out number,
                                    p_SALD_MONE_CON_RETE out number,
                                    p_impo_a_apli out number) is
    v_impo_rete_mmnn     number;
    v_impo_pago_mone     number;
    v_impo_pago_mmnn     number;
    v_impo_tota_mmnn     number;
    v_sum_impo_pago_mmnn number;
    --v_apli_rete          varchar2(2);
    v_sum_impo_pago  number;
    v_IMPO_PAGO_ADEL number;
    v_impo_rete_mone number;
    v_sum_cuot_sald_mone  number;
  begin
 -- raise_application_error(-20001,'sss');
    for i in detalle loop
      if nvl(p_emit_reci, 'R') = 'R' and
         upper(nvl(p_empr_retentora, 'NO')) <> 'NO' then
      
        if i.ind_marcado = 'X' and nvl(i.impo_pago, 0) > 0 then
          if nvl(p_calc_rete, 'S') = 'N' then
            I020017.pp_update_member(i.seq_id, 'N', 15);
          elsif nvl(parameter.p_form_calc_rete_emit, 1) = 2 then
            --Formula de calculo de retencion prorrateada
          
            I020017.pp_update_member(i.seq_id, 'S', 15);
          end if;
        
          v_impo_pago_mone := i.impo_pago;
          v_impo_pago_mmnn := round((i.impo_pago * p_movi_tasa_mone),
                                    parameter.p_cant_deci_mmnn);
          -- i.impo_pago_mmnn :=  v_impo_pago_mmnn;
          I020017.pp_update_member(i.seq_id, v_impo_pago_mmnn, 15);
          v_sum_impo_pago_mmnn := nvl(v_sum_impo_pago_mmnn, 0) +
                                  v_impo_pago_mmnn;
          v_impo_tota_mmnn     := round(v_sum_impo_pago_mmnn,
                                        parameter.p_cant_deci_mmnn);
          v_sum_impo_pago      := nvl(v_sum_impo_pago, 0) +
                                  nvl(i.impo_pago, 0);
        
          --pp_calcular_retencion;
          general_skn.pl_calc_rete(parameter.p_form_calc_rete_emit,
                                   p_movi_empr_codi,
                                   p_movi_sucu_codi_orig,
                                   i.cuot_movi_codi,
                                   i.apli_rete,
                                   v_impo_pago_mone,
                                   v_impo_pago_mmnn,
                                   v_impo_tota_mmnn,
                                   i.impo_rete_mone,
                                   v_impo_rete_mmnn,
                                   v_sum_impo_pago,
                                   0, --p_iva_mone  in number default 0,
                                   0, --p_iva_mmnn  in number default 0,
                                   p_movi_mone_cant_deci, --p_cant_deci in number default 0
                                   0,
                                   0,
                                   0,
                                   0,
                                   'N');
        
        else
          -- i.impo_rete_mone     := 0;
          I020017.pp_update_member(i.seq_id, 0, 13);
        
        end if;
      end if;
      v_IMPO_RETE_MONE := nvl(v_IMPO_RETE_MONE, 0) +
                          nvl(i.impo_rete_mone, 0);
      p_movi_impo_rete := i.impo_rete_mone;
      v_IMPO_PAGO_ADEL := i.impo_pago - i.impo_rete_mone;
      I020017.pp_update_member(i.seq_id, v_impo_rete_mone, 13);
    
      I020017.pp_update_member(i.seq_id, v_IMPO_PAGO_ADEL, 14);
    
      if v_IMPO_PAGO_ADEL < 0 then
        raise_application_error(-20001,
                                'El importe a aplicar al adelanto no puede ser negativo');
      end if;
    end loop;
  
    p_impo_rete_mone     := nvl(v_IMPO_RETE_MONE, 0);
    p_SALD_MONE_CON_RETE := p_movi_sald_mone + p_impo_rete_mone;
    
       select 
             sum(c009) v_sum_cuot_sald_mone--,
           --  sum(c013) v_sald_mone_con_rete
        into v_sum_cuot_sald_mone--, v_sald_mone_con_rete
        from apex_collections a
       where collection_name = 'BDETALLE';
       
       if v_sum_cuot_sald_mone > p_SALD_MONE_CON_RETE then
        p_impo_a_apli := p_SALD_MONE_CON_RETE;
       else
        p_impo_a_apli := v_sum_cuot_sald_mone;
       end if;
      
      
  
  end pp_calcular_importe_det;

  procedure pp_validar_imp_pago(p_seq in number, p_impo_pago in number) is
    v_cuot_sald_mone number;
    v_ind_marcado    varchar2(2);
  begin
    --raise_application_error(-20001,p_seq);
    begin
      select c009 sald, nvl(c001, 'X') marcado
        into v_cuot_sald_mone, v_ind_marcado
        from apex_collections a
       where collection_name = 'BDETALLE'
         and seq_id = p_seq;
    exception
      when others then
        null;
    end;
    if nvl(p_impo_pago, 0) > nvl(v_cuot_sald_mone, 0) then
      raise_application_error(-20001,
                              'El importe de pago no puede sobrepasar el saldo de la cuota!.');
    end if;
    
    if v('P105_S_TOTAL')>p_impo_pago then
      raise_application_error(-20001,'La nota de credito aplicada no puede exceder el monto de la cuota.
                                Verifica la informacion e intenta nuevamente.');
      end if;
  
    IF NVL(v_ind_marcado, 'X') = 'X' OR v_ind_marcado IS NOT NULL THEN
      if nvl(p_impo_pago, 0) <= 0 then
        -- raise_application_error(-20001,p_impo_pago);
        I020017.pp_update_member(p_seq, null, 12);
        I020017.pp_update_member(p_seq, null, 1);
      else
        I020017.pp_update_member(p_seq, p_impo_pago, 12);
        I020017.pp_update_member(p_seq, 'X', 1);
      end if;
    ELSE
      --SI ES NULO
      I020017.pp_update_member(p_seq, null, 12);
      I020017.pp_update_member(p_seq, null, 1);
    END IF;
  end pp_validar_imp_pago;
  
  procedure pp_actualiza_canc is
    --insertar los recibos de cancelaciones
    --Cancelacion de la NC/Adel..................
    --Cancelacion de la Factura/Nota de Debito....
    v_movi_codi           number;
    v_movi_timo_codi      number;
    v_movi_timo_desc      varchar2(60);
    v_movi_timo_desc_abre varchar2(10);
    v_movi_clpr_codi      number;
    v_movi_sucu_codi_orig number;
    v_movi_mone_codi      number;
    v_movi_nume           number;
    v_movi_fech_emis      date;
    v_movi_fech_grab      date;
    v_movi_user           char(20);
    v_movi_codi_padr      number;
    v_movi_tasa_mone      number;
    v_movi_tasa_mmee      number;
    v_movi_grav_mmnn      number;
    v_movi_exen_mmnn      number;
    v_movi_iva_mmnn       number;
    v_movi_grav_mmee      number;
    v_movi_exen_mmee      number;
    v_movi_iva_mmee       number;
    v_movi_grav_mone      number;
    v_movi_exen_mone      number;
    v_movi_iva_mone       number;
    v_movi_clpr_desc      char(80);
    v_movi_emit_reci      char(1);
    v_movi_afec_sald      char(1);
    v_movi_dbcr           char(1);
    v_movi_empr_codi      number;
  
    v_movi_depo_codi_orig number;
    v_movi_sucu_codi_dest number;
    v_movi_depo_codi_dest number;
    v_movi_oper_codi      number;
    v_movi_cuen_codi      number;
    v_movi_obse           varchar2(2000);
  
    v_movi_sald_mmnn           number;
    v_movi_sald_mmee           number;
    v_movi_sald_mone           number;
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(80);
    v_movi_clpr_tele           varchar2(80);
    v_movi_clpr_ruc            varchar2(80);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           number;
    v_movi_nume_timb           number;
    v_movi_fech_venc_timb      date;
    v_movi_fech_oper           date;
    v_movi_excl_cont           varchar2(1);
    v_movi_clpr_sucu_nume_item number;
  
    --variables para come_movi_cuot_canc...
    v_canc_movi_codi      number;
    v_canc_cuot_movi_codi number;
    v_canc_cuot_fech_venc date;
    v_canc_fech_pago      date;
    v_canc_impo_mone      number;
    v_canc_impo_mmnn      number;
    v_canc_impo_mmee      number;
    v_canc_impo_dife_camb number := 0;
    v_canc_impo_rete_mone number := 0;
    v_canc_impo_rete_mmnn number := 0;
    v_canc_tipo           varchar2(2);
    v_canc_impu_codi      number;
  
    v_canc_impo_mone_ii number(20, 4);
    v_canc_impo_mmnn_ii number(20, 4);
    v_canc_impu_mone    number(20, 4);
    v_canc_impu_mmnn    number(20, 4);
  
    v_canc_grav10_ii_mone number(20, 4);
    v_canc_grav5_ii_mone  number(20, 4);
    v_canc_exen_mone      number(20, 4);
    v_canc_iva10_mone     number(20, 4);
    v_canc_iva5_mone      number(20, 4);
    v_canc_grav10_ii_mmnn number(20, 4);
    v_canc_grav5_ii_mmnn  number(20, 4);
    v_canc_exen_mmnn      number(20, 4);
    v_canc_iva10_mmnn     number(20, 4);
    v_canc_iva5_mmnn      number(20, 4);
    v_canc_grav10_mone    number(20, 4);
    v_canc_grav5_mone     number(20, 4);
    v_canc_grav10_mmnn    number(20, 4);
    v_canc_grav5_mmnn     number(20, 4);
  
    cursor c_movi_cuot(p_movi_codi in number) is
      select cuot_movi_codi, cuot_fech_venc, cuot_sald_mone
        from come_movi_cuot
       where cuot_movi_codi = p_movi_codi
         and cuot_sald_mone > 0;
  
    --v_impo_canc number;
    --v_impo_deto number;
  
    v_indi_adel char(1);
    v_indi_ncr  char(1);
  
  begin
    --  |------------------------------------------------------------|
    --  |-Insertar la cancelacion de la nota de Credito/o adelanto...|
    --  |------------------------------------------------------------|  
  
    --Determinar el Tipo de movimiento.......
    --Primero determinamos si el documento es emitido o Recibido y luego si es una nota de credito o un adelanto....
    if parameter.p_emit_reci = 'E' then
    
      --es emitido
      if bcab.movi_timo_indi_adel = 'S' and bcab.movi_timo_indi_ncr = 'N' then
        --si es un adelanto
        v_movi_timo_codi := parameter.p_codi_timo_rcnadle;
      elsif bcab.movi_timo_indi_adel = 'N' and
            bcab.movi_timo_indi_ncr = 'S' then
        --si es una Nota de Credito
        v_movi_timo_codi := parameter.p_codi_timo_cnncre;
      end if;
    else
      --si es Recibido..
      if bcab.movi_timo_indi_adel = 'S' and bcab.movi_timo_indi_ncr = 'N' then
        --si es un adelanto
        v_movi_timo_codi := parameter.p_codi_timo_rcnadlr;
      elsif bcab.movi_timo_indi_adel = 'N' and
            bcab.movi_timo_indi_ncr = 'S' then
        --si es una Nota de Credito
        v_movi_timo_codi := parameter.p_codi_timo_cnncrr;
      end if;
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
    bcab.movi_codi_apli   := v_movi_codi;
    v_movi_clpr_codi      := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    v_movi_mone_codi      := bcab.movi_mone_codi;
    v_movi_nume           := bcab.movi_nume;
    v_movi_fech_emis      := bcab.movi_fech_apli;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_codi_padr      := null;
    v_movi_tasa_mone      := bcab.movi_tasa_mone;
    v_movi_tasa_mmee      := 0;
    v_movi_grav_mmnn      := 0;
    v_movi_exen_mmnn      := round(((bcab.sum_impo_pago -
                                   nvl(bcab.sum_impo_rete_mone, 0)) *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_movi_iva_mmnn       := 0;
    v_movi_grav_mmee      := 0;
    v_movi_exen_mmee      := 0;
    v_movi_iva_mmee       := 0;
    v_movi_grav_mone      := 0;
    v_movi_exen_mone      := nvl(bcab.sum_impo_pago, 0) -
                             nvl(bcab.sum_impo_rete_mone, 0);
    v_movi_iva_mone       := 0;
    v_movi_clpr_desc      := bcab.movi_clpr_desc;
    v_movi_emit_reci      := parameter.p_emit_reci;
    v_movi_empr_codi      := bcab.movi_empr_codi;
  
    v_movi_depo_codi_orig      := null;
    v_movi_clpr_sucu_nume_item := bcab.sucu_nume_item;
  
    if v_movi_clpr_sucu_nume_item = 0 then
      v_movi_clpr_sucu_nume_item := null;
    end if;
  
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
                        v_movi_nume_timb,
                        v_movi_fech_venc_timb,
                        v_movi_fech_oper,
                        v_movi_excl_cont,
                        v_movi_clpr_sucu_nume_item);
  
    --Obse. Los Adelantos y notas de creditos tendr?n siempre una sola cuota..
    --con fecha de vencimiento igual a la fecha del documento.................
  
    --------
    v_canc_impo_mone_ii := nvl(bcab.sum_impo_pago, 0) -
                           nvl(bcab.sum_impo_rete_mone, 0);
    v_canc_impo_mmnn_ii := round((v_canc_impo_mone_ii * bcab.movi_tasa_mone),
                                 parameter.p_cant_deci_mmnn);
  
    pa_devu_impo_calc(v_canc_impo_mone_ii,
                      bcab.movi_mone_cant_deci,
                      bcab.impu_porc,
                      bcab.impu_porc_base_impo,
                      bcab.impu_indi_baim_impu_incl,
                      v_canc_impo_mone_ii,
                      v_canc_grav10_ii_mone,
                      v_canc_grav5_ii_mone,
                      v_canc_grav10_mone,
                      v_canc_grav5_mone,
                      v_canc_iva10_mone,
                      v_canc_iva5_mone,
                      v_canc_exen_mone);
  
    pa_devu_impo_calc(v_canc_impo_mmnn_ii,
                      parameter.p_cant_deci_mmnn,
                      bcab.impu_porc,
                      bcab.impu_porc_base_impo,
                      bcab.impu_indi_baim_impu_incl,
                      v_canc_impo_mmnn_ii,
                      v_canc_grav10_ii_mmnn,
                      v_canc_grav5_ii_mmnn,
                      v_canc_grav10_mmnn,
                      v_canc_grav5_mmnn,
                      v_canc_iva10_mmnn,
                      v_canc_iva5_mmnn,
                      v_canc_exen_mmnn);
  
    --v_canc_impo_mmnn := v_canc_exen_mmnn + v_canc_grav10_mmnn + v_canc_grav5_mmnn;
    --v_canc_impo_mone := v_canc_exen_mone + v_canc_grav10_mone + v_canc_grav5_mone;
    v_canc_impu_mone := v_canc_iva10_mone + v_canc_iva5_mone;
    v_canc_impu_mmnn := v_canc_iva10_mmnn + v_canc_iva5_mmnn;
    v_canc_impu_codi := bcab.cuot_impu_codi;
    -------------------
  
    v_canc_movi_codi      := v_movi_codi; --clave del recibo de cn de nc/adel
    v_canc_cuot_movi_codi := bcab.movi_codi; --clave de la nota de credito/ adel
    v_canc_cuot_fech_venc := bcab.movi_fech_emis; --fecha de venc. de la cuota de NC/Adel (= a la fecha de la nc/Adel)
    v_canc_fech_pago      := bcab.movi_fech_apli; --fecha de aplicacion de la cuota de NC (= a la fecha de la nc)
    v_canc_impo_mone      := v_canc_impo_mone_ii; --v_movi_exen_mone; --siempre el importe de cancelacion ser? exento...
    v_canc_impo_mmnn      := v_canc_impo_mmnn_ii; --v_movi_exen_mmnn;
    v_canc_impo_mmee      := 0; --v_movi_exen_mmee;
    v_canc_impo_dife_camb := 0;
    v_canc_impo_rete_mone := 0;
    v_canc_impo_rete_mmnn := 0;
  
  ----PRUEBAA

      pp_insert_movi_cuot_canc_adnc(v_canc_movi_codi,
                                    v_canc_cuot_movi_codi,
                                    v_canc_cuot_fech_venc,
                                    v_canc_fech_pago,
                                    v_canc_impo_mone,
                                    v_canc_impo_mmnn,
                                    v_canc_impo_mmee,
                                    0,
                                    0,
                                    0,
                                    'C',
                                    v_canc_impu_codi,
                                    v_canc_impu_mone,
                                    v_canc_impu_mmnn,
                                    v_canc_grav10_ii_mone,
                                    v_canc_grav5_ii_mone,
                                    v_canc_grav10_mone,
                                    v_canc_grav5_mone,
                                    v_canc_iva10_mone,
                                    v_canc_iva5_mone,
                                    v_canc_exen_mone,
                                    v_canc_grav10_ii_mmnn,
                                    v_canc_grav5_ii_mmnn,
                                    v_canc_grav10_mmnn,
                                    v_canc_grav5_mmnn,
                                    v_canc_iva10_mmnn,
                                    v_canc_iva5_mmnn,
                                    v_canc_exen_mmnn);
    
  
    -----------------------------------------------------------------------------------------------------------------------
    --Fin de la cancelacion de la nota de credito  / Adelanto...
    -----------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------
    ---insertar la cancelacion de la/s Factura/s..../ Notas de Debitos......................................................
    ------------------------------------------------------------------------------------------------------------------------
    --Determinar el Tipo de movimiento.......
    --Primero determinamos si el documento es emitido o Recibido y luego si es una nota de credito o un adelanto....
    if parameter.p_emit_reci = 'E' then
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
  
   
    v_movi_codi_padr           := v_movi_codi; --clave de la cancelacion del adel/Nota de Credito
    v_movi_codi                := fa_sec_come_movi;
    parameter.p_canc_codi_fcrr := v_movi_codi;
    v_movi_clpr_codi           := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
    v_movi_mone_codi           := bcab.movi_mone_codi;
    v_movi_nume                := bcab.movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_apli;
    v_movi_fech_grab           := sysdate;
    v_movi_user                := gen_user;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := 0;
    v_movi_grav_mmnn           := 0;
    v_movi_exen_mmnn           := round((bcab.sum_impo_pago *
                                        bcab.movi_tasa_mone),
                                        parameter.p_cant_deci_mmnn);
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := 0;
    v_movi_exen_mmee           := 0;
    v_movi_iva_mmee            := 0;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := bcab.sum_impo_pago;
    v_movi_iva_mone            := 0;
    v_movi_clpr_desc           := bcab.movi_clpr_desc;
    v_movi_emit_reci           := parameter.p_emit_reci;
    v_movi_empr_codi           := bcab.movi_empr_codi;
    v_movi_clpr_sucu_nume_item := bcab.sucu_nume_item;
  
    if v_movi_clpr_sucu_nume_item = 0 then
      v_movi_clpr_sucu_nume_item := null;
    end if;
  
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
                        v_movi_nume_timb,
                        v_movi_fech_venc_timb,
                        v_movi_fech_oper,
                        v_movi_excl_cont,
                        v_movi_clpr_sucu_nume_item);
  
  

    for bdet in detalle loop
      if bdet.ind_marcado = 'X' then
      
        if nvl(bdet.impo_pago, 0) > 0 then
           
          v_canc_movi_codi      := v_movi_codi; --clave del recibo de cn de Fac
          v_canc_cuot_movi_codi := bdet.cuot_movi_codi;
          v_canc_cuot_fech_venc := bdet.cuot_fech_venc;
          v_canc_fech_pago      := bcab.movi_fech_apli; --fecha de cancelacion de la cuota de NC/adel (= a la fecha de la nc/adel)      
          v_canc_impo_mone      := bdet.impo_pago;
          v_canc_tipo           := bdet.cuot_tipo;
          v_canc_impo_mmnn      := round((bdet.impo_pago *
                                         bcab.movi_tasa_mone),
                                         0);
          v_canc_impo_mmee      := 0;
          v_canc_impo_dife_camb := round(((bcab.movi_tasa_mone -
                                         bdet.cuot_tasa_mone) *
                                         v_canc_impo_mone),
                                         0);
          v_canc_impo_rete_mone := bdet.impo_rete_mone;
          v_canc_impo_rete_mmnn := round((bdet.impo_rete_mone *
                                         nvl(bcab.movi_tasa_mone, 1)),
                                         0);
    
    
          pp_insert_come_movi_cuot_canc(v_canc_movi_codi,
                                        v_canc_cuot_movi_codi,
                                        v_canc_cuot_fech_venc,
                                        v_canc_fech_pago,
                                        v_canc_impo_mone,
                                        v_canc_impo_mmnn,
                                        v_canc_impo_mmee,
                                        v_canc_impo_dife_camb,
                                        v_canc_impo_rete_mone,
                                        v_canc_impo_rete_mmnn,
                                        v_canc_tipo);
        
          if bcab.movi_timo_indi_adel = 'S' and
             bcab.movi_timo_indi_ncr = 'N' then
            if bcab.movi_impo_inte_mone is not null then
              pp_insertar_interes(v_canc_cuot_movi_codi, v_canc_impo_mone);
            end if;
          end if;
          
            if bcab.MOVI_FACT_CODI is not null then
             raise_application_error(-20001,'Nota de credito asociado a otra factura favor verificar..');
             end if;
          if bcab.movi_timo_codi=9 and bcab.MOVI_FACT_CODI is null then
            update come_movi
            set movi_fact_codi=bdet.cuot_movi_codi
            where movi_codi= bcab.movi_codi_nota ;
            end if;
            
          
          
        end if;
      end if;
    
    end loop;
   -- raise_application_error(-20001,'auu');
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
                                p_movi_nume_timb           in varchar2,
                                p_movi_fech_venc_timb      in date,
                                p_movi_fech_oper           in date,
                                p_movi_excl_cont           in varchar2,
                                p_movi_clpr_sucu_nume_item in number) is
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
       movi_base,
       movi_fech_oper,
       movi_excl_cont,
       movi_clpr_sucu_nume_item)
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
       1, -- parameter.p_codi_base            ,
       p_movi_fech_oper,
       p_movi_excl_cont,
       p_movi_clpr_sucu_nume_item);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_come_movi;

  procedure pp_insert_come_movi_cuot_canc(p_canc_movi_codi      in number,
                                          p_canc_cuot_movi_codi in number,
                                          p_canc_cuot_fech_venc in date,
                                          p_canc_fech_pago      in date,
                                          p_canc_impo_mone      in number,
                                          p_canc_impo_mmnn      in number,
                                          p_canc_impo_mmee      in number,
                                          p_canc_impo_dife_camb in number,
                                          p_canc_impo_rete_mone in number,
                                          p_canc_impo_rete_mmnn in number,
                                          p_canc_tipo           in varchar2) is
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
       canc_impo_rete_mone,
       canc_impo_rete_mmnn,
       canc_base,
       canc_tipo,
       canc_indi_afec_sald)
    values
      (p_canc_movi_codi,
       p_canc_cuot_movi_codi,
       p_canc_cuot_fech_venc,
       p_canc_fech_pago,
       p_canc_impo_mone,
       p_canc_impo_mmnn,
       p_canc_impo_mmee,
       p_canc_impo_dife_camb,
       p_canc_impo_rete_mone,
       p_canc_impo_rete_mmnn,
       1, --parameter.p_codi_base  ,
       p_canc_tipo,
       'S');

  exception
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_insert_come_movi_cuot_canc;

  procedure pp_insertar_interes(p_factura_codi in number,
                                p_impo_pago    in number) is
  
    --cursor del detalle de la factura(se le pasa el codigo de la factura) 
    cursor c_fact_deta is
      select deta_movi_codi,
             deta_nume_item,
             d.deta_impo_mone,
             d.deta_impo_mmnn
        from come_movi_prod_deta d
       where d.deta_movi_codi = p_factura_codi;
  
    v_impo_inte_mmnn      number;
    v_impo_inte_mone      number;
    v_porc_inte_apli      number;
    v_porc_inte_item      number;
    v_inte_apli_mmnn      number;
    v_inte_apli_mone      number;
    v_apli_movi_codi      number;
    v_apli_movi_codi_adel number;
  
    v_impo_pago      number;
    v_tota_fact_mone number;
  
  begin
  
    select sum(deta_impo_mone)
      into v_tota_fact_mone
      from come_movi_prod_deta
     where deta_movi_codi = p_factura_codi;
  
    v_apli_movi_codi_adel := bcab.movi_codi; 
    v_apli_movi_codi      := bcab.movi_codi_apli; -- g_come_movi.movi_codi_apli;
    v_impo_pago           := p_impo_pago;
  
    v_porc_inte_apli := (v_impo_pago * 100) / bcab.s_total; --porcentaje de interes de la aplicacion con respecto al interes del adelanto
    v_inte_apli_mone := round(((v_porc_inte_apli *
                              bcab.movi_impo_inte_mone) / 100),
                              4); --importe de interes de la aplicacion 
    v_inte_apli_mmnn := round(((v_porc_inte_apli *
                              bcab.movi_impo_inte_mmnn) / 100),
                              4); --importe de interes de la aplicacion mmnn
    for z in c_fact_deta loop
    
      v_porc_inte_item := (z.deta_impo_mone * 100) / v_tota_fact_mone; --porcentaje a aplicar del interes por item
      v_impo_inte_mmnn := round(((v_inte_apli_mmnn * v_porc_inte_item) / 100),
                                4); --importe del interes por item mmnn
      v_impo_inte_mone := round(((v_inte_apli_mone * v_porc_inte_item) / 100),
                                4); --importe del interes por item         
    
      insert into come_movi_apli_inte_comp
        (apli_movi_codi_adel,
         apli_movi_codi_comp,
         apli_nume_item_comp,
         apli_movi_codi_apli,
         apli_impo_mone,
         apli_impo_mmnn)
      values
        (v_apli_movi_codi_adel,
         z.deta_movi_codi,
         z.deta_nume_item,
         v_apli_movi_codi,
         v_impo_inte_mone,
         v_impo_inte_mmnn);
    
    end loop;
  
  end pp_insertar_interes;

  procedure pp_actualizar_rete is
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
    v_movi_excl_cont           varchar2(1);
    v_movi_clpr_sucu_nume_item number;
  
    --v_timo_tico_codi      number;
    --v_tico_indi_timb      varchar2(1);
    --v_nro_1               varchar2(3);
    --v_nro_2               varchar2(3);
    v_movi_nume_timb      varchar2(20);
    v_movi_fech_venc_timb date;
  
    --v_moim_movi_codi number;
    --v_moim_nume_item number := 0;
    --v_moim_tipo      char(20);
    --v_moim_cuen_codi number;
    --v_moim_dbcr      char(1);
    --v_moim_afec_caja char(1);
    --v_moim_fech      date;
    --v_moim_impo_mone number;
    --v_moim_impo_mmnn number;
    --v_moim_fech_oper date;
  
    --variables para moco
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      char(1);
    --v_conc_indi_ortr varchar2(1);
  
  begin
    --- asignar valores....
    select timo_emit_reci, timo_afec_sald, timo_dbcr
      into v_movi_emit_reci, v_movi_afec_sald, v_movi_dbcr
      from come_tipo_movi, come_tipo_comp
     where timo_tico_codi = tico_codi(+)
       and timo_codi = parameter.p_codi_timo_rete_emit;
  
    v_movi_nume           := rete.movi_nume_rete;
    v_movi_nume_timb      := rete.movi_nume_timb_rete;
    v_movi_fech_venc_timb := rete.movi_fech_venc_timb_rete;
    v_movi_fech_oper      := bcab.movi_fech_emis; -- cab.movi_fech_emis;
  
    v_movi_codi                := fa_sec_come_movi;
    parameter.p_movi_codi_rete := v_movi_codi;
    v_movi_timo_codi           := parameter.p_codi_timo_rete_emit;
    v_movi_clpr_codi           := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig      := null;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := null;
    v_movi_cuen_codi           := null; --bcab.movi_cuen_codi;
    v_movi_mone_codi           := bcab.movi_mone_codi;
  
    parameter.p_movi_nume_rete := v_movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis; --to_date(to_char(sysdate, 'dd-mm-yyyy'), 'dd-mm-yyyy');--bcab.movi_fech_emis;
    v_movi_fech_grab           := sysdate; --bcab.movi_fech_grab;
    v_movi_user                := gen_user; --bcab.movi_user;
    v_movi_codi_padr           := bcab.movi_codi_apli; ---clave de la aplicacion no clave del adelanto
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := null;
    v_movi_grav_mmnn           := 0; --bcab.movi_grav_mmnn;
    v_movi_exen_mmnn           := round(bcab.impo_rete_mone *
                                        bcab.movi_tasa_mone,
                                        0); --bcab.movi_exen_mmnn;
    v_movi_iva_mmnn            := 0; --bcab.movi_iva_mmnn;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := 0; --bcab.movi_grav_mone;
    v_movi_exen_mone           := bcab.impo_rete_mone; --bcab.movi_exen_mone;
    v_movi_iva_mone            := 0; --bcab.movi_iva_mone;
    v_movi_obse                := nvl(rete.movi_obse,
                                      'Retencion Aplicacion Adel. Nro. ' ||
                                      bcab.movi_nume);
    v_movi_sald_mmnn           := 0;
    v_movi_sald_mmee           := 0;
    v_movi_sald_mone           := 0;
    v_movi_stoc_suma_rest      := null;
  
    v_movi_clpr_dire := null;
    v_movi_clpr_tele := null;
    v_movi_clpr_ruc  := null;
    v_movi_clpr_desc := bcab.movi_clpr_desc;
  
    --v_movi_emit_reci                  := bcab.movi_emit_reci;
    --v_movi_afec_sald                  := bcab.movi_afec_sald;
    --v_movi_dbcr                       := bcab.movi_dbcr;
  
    v_movi_stoc_afec_cost_prom := null;
    v_movi_empr_codi           := null;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := null; --bcab.movi_empl_codi;
    v_movi_excl_cont           := 'S';
    v_movi_clpr_sucu_nume_item := null;
  
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
                        v_movi_nume_timb,
                        v_movi_fech_venc_timb,
                        v_movi_fech_oper,
                        v_movi_excl_cont,
                        v_movi_clpr_sucu_nume_item);
  
    ----detalle de caja
  
    --v_moim_movi_codi := parameter.p_movi_codi_rete;
    --v_moim_dbcr      := v_movi_dbcr;
    --v_moim_nume_item := v_moim_nume_item + 1;
    --v_moim_cuen_codi := g_come_movi.movi_cuen_codi;
    --v_moim_afec_caja := 'S'; --si es cheque dif emitido debe afectar caja... pero tniendo en cuenta la fecha de venc.
    --v_moim_fech      := g_come_movi.movi_fech_emis;
    --v_moim_tipo      := 'Efectivo';
    --v_moim_impo_mone := v_movi_exen_mone;
    --v_moim_impo_mmnn := v_movi_exen_mmnn;
    --v_moim_fech_oper := v_movi_fech_oper;
  
    /*
    pp_insert_come_movi_impo_deta (
    v_moim_movi_codi ,
    v_moim_nume_item ,
    v_moim_tipo      ,
    v_moim_cuen_codi ,
    v_moim_dbcr      ,
    v_moim_afec_caja ,
    v_moim_fech      ,
    v_moim_impo_mone ,
    v_moim_impo_mmnn ,
    v_moim_fech_oper       
    );  
    */
  
    ----detalle de conceptos
    v_moco_movi_codi := parameter.p_movi_codi_rete;
    v_moco_nume_item := 0;
    v_moco_conc_codi := parameter.p_codi_conc_rete_emit;
    v_moco_dbcr      := v_movi_dbcr;
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_exen;
    v_moco_impo_mmnn := v_movi_exen_mmnn;
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := v_movi_exen_mmnn;
  
    pp_insert_movi_conc_deta(v_moco_movi_codi,
                             v_moco_nume_item,
                             v_moco_conc_codi,
                             v_moco_cuco_codi,
                             v_moco_impu_codi,
                             v_moco_impo_mmnn,
                             v_moco_impo_mmee,
                             v_moco_impo_mone,
                             v_moco_dbcr,
                             null,
                             null,
                             null);
  
    --detalle de impuestos
    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  parameter.p_movi_codi_rete,
                                  v_movi_exen_mmnn,
                                  0,
                                  0,
                                  0,
                                  v_movi_exen_mone,
                                  0,
                                  null);
  
    if nvl(parameter.p_form_calc_rete_emit, 1) = 2 then
      --formula de calculo de retencion prorrateada
      update come_movi
         set movi_codi_rete = parameter.p_movi_codi_rete
       where movi_codi = bcab.movi_codi;
    else
      for bdet in detalle loop
        if bdet.ind_marcado = 'X' then
          if nvl(bdet.impo_rete_mone, 0) > 0 then
            update come_movi
               set movi_codi_rete = parameter.p_movi_codi_rete
             where movi_codi = bdet.cuot_movi_codi;
          end if;
        end if;
      
      end loop;
    end if;
  
    pp_actu_secu_rete;
  
  end;

  procedure pp_insert_movi_conc_deta(p_moco_movi_codi number,
                                     p_moco_nume_item number,
                                     p_moco_conc_codi number,
                                     p_moco_cuco_codi number,
                                     p_moco_impu_codi number,
                                     p_moco_impo_mmnn number,
                                     p_moco_impo_mmee number,
                                     p_moco_impo_mone number,
                                     p_moco_dbcr      char,
                                     p_moco_tiim_codi in number,
                                     p_moco_impo_codi in number,
                                     p_moco_ceco_codi in number) is
  
  begin
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
       moco_tiim_codi,
       moco_impo_codi,
       moco_ceco_codi,
       moco_base)
    values
      (
       
       p_moco_movi_codi,
       p_moco_nume_item,
       p_moco_conc_codi,
       p_moco_cuco_codi,
       p_moco_impu_codi,
       p_moco_impo_mmnn,
       p_moco_impo_mmee,
       p_moco_impo_mone,
       p_moco_dbcr,
       p_moco_tiim_codi,
       p_moco_impo_codi,
       p_moco_ceco_codi,
       1 --parameter.p_codi_base
       );
  exception
  
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end;

  procedure pp_insert_come_movi_impu_deta(p_moim_impu_codi in number,
                                          p_moim_movi_codi in number,
                                          p_moim_impo_mmnn in number,
                                          p_moim_impo_mmee in number,
                                          p_moim_impu_mmnn in number,
                                          p_moim_impu_mmee in number,
                                          p_moim_impo_mone in number,
                                          p_moim_impu_mone in number,
                                          p_moim_tiim_codi in number) is
  begin
    insert into come_movi_impu_deta
      (moim_impu_codi,
       moim_movi_codi,
       moim_impo_mmnn,
       moim_impo_mmee,
       moim_impu_mmnn,
       moim_impu_mmee,
       moim_impo_mone,
       moim_impu_mone,
       moim_tiim_codi,
       moim_base)
    values
      (
       
       p_moim_impu_codi,
       p_moim_movi_codi,
       p_moim_impo_mmnn,
       p_moim_impo_mmee,
       p_moim_impu_mmnn,
       p_moim_impu_mmee,
       p_moim_impo_mone,
       p_moim_impu_mone,
       p_moim_tiim_codi,
       1 --parameter.p_codi_base
       );
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_insert_come_movi_impu_deta;



PROCEDURE pp_actualizar_rete_tesaka(p_canc_movi_codi in number) IS
  cursor cv_canc is
    select canc_movi_codi,
           canc_cuot_movi_codi,
           movi_nume fact_nume,
           sum(canc_impo_rete_mone) rete_impo_mone,
           sum(canc_impo_rete_mmnn) rete_impo_mmnn
      from come_movi_cuot_canc, come_movi
     where canc_cuot_movi_codi = movi_codi
       and canc_movi_codi = p_canc_movi_codi
       and nvl(canc_impo_rete_mone,0) > 0
     group by canc_movi_codi, canc_cuot_movi_codi, movi_nume
     order by canc_cuot_movi_codi;

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
  v_movi_excl_cont           varchar2(1);
  v_movi_impo_reca           number;
  v_movi_clpr_situ           number;
  v_movi_clpr_empl_codi_recl number;
  v_movi_clpr_sucu_nume_item number;

  --v_timo_tico_codi      number;
  v_tico_indi_timb      varchar2(1);
  --v_nro_1               varchar2(3);
  --v_nro_2               varchar2(3);
  v_movi_nume_timb      varchar2(20);
  v_movi_fech_venc_timb date;

  v_moim_movi_codi number;
  v_moim_nume_item number := 0;
  v_moim_tipo      char(20);
  v_moim_cuen_codi number;
  v_moim_dbcr      char(1);
  v_moim_afec_caja char(1);
  v_moim_fech      date;
  v_moim_impo_mone number;
  v_moim_impo_mmnn number;
  v_moim_fech_oper date;

  --variables para moco
  v_moco_movi_codi number;
  v_moco_nume_item number;
  v_moco_conc_codi number;
  v_moco_cuco_codi number;
  v_moco_impu_codi number;
  v_moco_impo_mmnn number;
  v_moco_impo_mmee number;
  v_moco_impo_mone number;
  v_moco_dbcr      char(1);
  --v_conc_indi_ortr varchar2(1);
  v_tico_codi      number;
  v_esta           number;
  v_expe           number;
  v_nume           number;

  v_more_movi_codi      number;
  v_more_movi_codi_rete number;
  v_more_movi_codi_pago number;
  v_more_tipo_rete      varchar2(2);
  v_more_impo_mone      number(20, 4);
  v_more_impo_mmnn      number(20, 4);
  v_more_tasa_mone      number(20, 4);
  --v_resp      varchar2(1000);
  e_secu_nume exception;
  e_timb      exception;

BEGIN

  --- asignar valores....
  select timo_emit_reci,
         timo_afec_sald,
         timo_dbcr,
         tico_indi_timb,
         tico_codi
    into v_movi_emit_reci,
         v_movi_afec_sald,
         v_movi_dbcr,
         v_tico_indi_timb,
         v_tico_codi
    from come_tipo_movi, come_tipo_comp
   where timo_tico_codi = tico_codi(+)
     and timo_codi = parameter.p_codi_timo_rete_emit;
  for r in cv_canc loop
    
    
  
    begin
      select substr(lpad(nvl(secu_nume_reten,0) + 1, 13, 0), 1, 3) establecimiento,
             substr(lpad(nvl(secu_nume_reten,0) + 1, 13, 0), 4, 3) expedicion,
             substr(lpad(nvl(secu_nume_reten,0) + 1, 13, 0), 7) numero,
             nvl(secu_nume_reten,0) + 1
        into v_esta, v_expe, v_nume, v_movi_nume
        from come_secu
       where secu_codi =
             (select peco_secu_codi
                from come_pers_comp
               where peco_codi = parameter.p_peco_codi);
    exception
      when others then
        raise e_secu_nume;
    end;
    begin
      if v_tico_indi_timb = 'S' then
        select setc_nume_timb, setc_fech_venc
          into v_movi_nume_timb, v_movi_fech_venc_timb
          from come_secu_tipo_comp
         where setc_secu_codi =
               (select peco_secu_codi
                  from come_pers_comp
                 where peco_codi = parameter.p_peco_codi)
           and setc_tico_codi = v_tico_codi
           and setc_esta = v_esta
           and setc_punt_expe = v_expe
           and setc_fech_venc >= bcab.movi_fech_apli
           and rownum = 1
         order by setc_fech_venc;
      
      elsif v_tico_indi_timb = 'C' then
        select deta_nume_timb, deta_fech_venc
          into v_movi_nume_timb, v_movi_fech_venc_timb
          from come_tipo_comp_deta
         where deta_tico_codi = v_tico_codi
           and deta_esta = v_esta
           and deta_punt_expe = v_expe
           and deta_fech_venc >= bcab.movi_fech_apli
           and rownum = 1
         order by deta_fech_venc;
      end if;
    exception
      when others then
        raise e_timb;
    end;
    v_movi_codi           := fa_sec_come_movi;
    v_movi_timo_codi      := parameter.p_codi_timo_rete_emit;
    v_movi_clpr_codi      := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig := null;
    v_movi_sucu_codi_dest := null;
    v_movi_depo_codi_dest := null;
    v_movi_oper_codi      := null;
    v_movi_cuen_codi      := null;
    v_movi_mone_codi      := bcab.movi_mone_codi;
    v_movi_fech_emis      := bcab.movi_fech_apli;
    v_movi_fech_oper      := bcab.MOVI_FECH_APLI;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_codi_padr      := bcab.movi_codi_apli;
    v_movi_tasa_mone      := bcab.movi_tasa_mone;
    v_movi_tasa_mmee      := null;
    v_movi_grav_mmnn      := 0;
    v_movi_exen_mmnn      := r.rete_impo_mmnn;
    v_movi_iva_mmnn       := 0;
    v_movi_grav_mmee      := null;
    v_movi_exen_mmee      := null;
    v_movi_iva_mmee       := null;
    v_movi_grav_mone      := 0;
    v_movi_exen_mone      := r.rete_impo_mone;
    v_movi_iva_mone       := 0;
    v_movi_obse           := nvl(rete.movi_obse,
                                 'Retenci?n Factura Nro. ' || r.fact_nume);
    v_movi_sald_mmnn      := 0;
    v_movi_sald_mmee      := 0;
    v_movi_sald_mone      := 0;
    v_movi_stoc_suma_rest := null;
  
    v_movi_clpr_dire := null;
    v_movi_clpr_tele := null;
    v_movi_clpr_ruc  := null;
    v_movi_clpr_desc := bcab.movi_clpr_desc;
  
    v_movi_stoc_afec_cost_prom := null;
    v_movi_empr_codi           := null;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := null;
    v_movi_excl_cont           := 'S';
    v_movi_impo_reca           := 0;
    v_movi_clpr_situ           := null;--bcab.movi_clpr_situ;
    v_movi_clpr_empl_codi_recl := null;--bcab.movi_clpr_empl_codi_recl;
    v_movi_clpr_sucu_nume_item := null;

    pp_insert_come_movi2(v_movi_codi,
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
                        v_movi_nume_timb,
                        v_movi_fech_venc_timb,
                        v_movi_fech_oper,
                        v_movi_impo_reca,
                        v_movi_excl_cont,
                        v_movi_clpr_situ,
                        v_movi_clpr_empl_codi_recl,
                        v_movi_clpr_sucu_nume_item);

    ----detalle de caja
    v_moim_movi_codi := v_movi_codi;
    v_moim_dbcr      := v_movi_dbcr;
    v_moim_nume_item := v_moim_nume_item + 1;
    v_moim_cuen_codi := null;
    v_moim_afec_caja := 'S';
    v_moim_fech      := bcab.movi_fech_emis;
    v_moim_tipo      := 'Efectivo';
    v_moim_impo_mone := v_movi_exen_mone;
    v_moim_impo_mmnn := v_movi_exen_mmnn;
    v_moim_fech_oper := v_movi_fech_oper;
  
    /* 
      pp_insert_come_movi_impo_deta (
      v_moim_movi_codi ,
      v_moim_nume_item ,
      v_moim_tipo      ,
      v_moim_cuen_codi ,
      v_moim_dbcr      ,
      v_moim_afec_caja ,
      v_moim_fech      ,
      v_moim_impo_mone ,
      v_moim_impo_mmnn ,
      v_moim_fech_oper       
      );
    */
    
    ----detalle de conceptos
    v_moco_movi_codi := v_movi_codi;
    v_moco_nume_item := 0;
    v_moco_conc_codi := parameter.p_codi_conc_rete_emit;
    v_moco_dbcr      := v_movi_dbcr;
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_exen;
    v_moco_impo_mmnn := v_movi_exen_mmnn;
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := v_movi_exen_mone;

    pp_insert_movi_conc_deta(v_moco_movi_codi,
                             v_moco_nume_item,
                             v_moco_conc_codi,
                             v_moco_cuco_codi,
                             v_moco_impu_codi,
                             v_moco_impo_mmnn,
                             v_moco_impo_mmee,
                             v_moco_impo_mone,
                             v_moco_dbcr,
                             null,
                             null,
                             null);
    --detalle de impuestos

    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  v_movi_codi,
                                  v_movi_exen_mmnn,
                                  0,
                                  0,
                                  0,
                                  v_movi_exen_mone,
                                  0,
                                  null);

    pp_actu_secu_rete_tesa(v_movi_nume);

    v_more_movi_codi      := r.canc_cuot_movi_codi;
    v_more_movi_codi_rete := v_movi_codi;
    v_more_movi_codi_pago := r.canc_movi_codi;
    v_more_tipo_rete      := parameter.p_form_calc_rete_emit;
    v_more_impo_mone      := r.rete_impo_mone;
    v_more_impo_mmnn      := r.rete_impo_mmnn;
    v_more_tasa_mone      := bcab.movi_tasa_mone;
  
    insert into come_movi_rete
      (more_movi_codi,
       more_movi_codi_rete,
       more_movi_codi_pago,
       more_tipo_rete,
       more_impo_mone,
       more_impo_mmnn,
       more_tasa_mone)
    values
      (v_more_movi_codi,
       v_more_movi_codi_rete,
       v_more_movi_codi_pago,
       v_more_tipo_rete,
       v_more_impo_mone,
       v_more_impo_mmnn,
       v_more_tasa_mone);
  end loop;
  
exception
  when e_secu_nume then
    pl_me('Error al recuperar la Secuencia de Retencion Emitida.');
  when e_timb then
    pl_me('Error al recuperar Timbrado de Retencion Emitida');
END pp_actualizar_rete_tesaka;


  procedure pp_insert_come_movi2(p_movi_codi                in number,
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
                                 p_movi_nume_timb           in varchar2,
                                 p_movi_fech_venc_timb      in date,
                                 p_movi_fech_oper           in date,
                                 p_movi_codi_rete           in number,
                                 p_movi_excl_cont           in varchar2,
                                 p_movi_clpr_situ           in number,
                                 p_movi_clpr_empl_codi_recl in number,
                                 p_movi_clpr_sucu_nume_item in number) is
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
       movi_base,
       movi_nume_timb,
       movi_fech_oper,
       movi_fech_venc_timb,
       movi_codi_rete,
       movi_excl_cont,
       movi_clpr_situ,
       movi_clpr_empl_codi_recl,
       movi_clpr_sucu_nume_item)
    values
      (
       
       p_movi_codi,
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
       1, --parameter.p_codi_base            ,
       p_movi_nume_timb,
       p_movi_fech_oper,
       p_movi_fech_venc_timb,
       p_movi_codi_rete,
       p_movi_excl_cont,
       p_movi_clpr_situ,
       p_movi_clpr_empl_codi_recl,
       p_movi_clpr_sucu_nume_item);
  
  exception
  
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

  procedure pp_actu_secu_rete_tesa(p_movi_nume in number) is
  begin
    update come_secu
       set secu_nume_reten = p_movi_nume
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  end pp_actu_secu_rete_tesa;

  procedure pp_actu_secu_rete is
  begin
  
    if nvl(bcab.impo_rete_mone, 0) > 0 then
      update come_secu
         set secu_nume_reten = rete.movi_nume_rete
       where secu_codi =
             (select peco_secu_codi
                from come_pers_comp
               where peco_codi = parameter.p_peco_codi);
    end if;
  
  end pp_actu_secu_rete;

  procedure pp_set_variable is
  begin
  
    bcab.s_dife                   := v('P105_S_DIFE');
    bcab.movi_codi                := v('P105_MOVI_CODI');
     bcab.movi_codi_nota          := v('P105_MOVI_CODI');
    bcab.movi_timo_indi_adel      := v('P105_TIMO_INDI_ADEL');
    bcab.movi_fech_emis           := v('P105_MOVI_FECH_EMIS');
    bcab.movi_timo_indi_ncr       := v('P105_TIMO_INDI_NCR');
    bcab.calc_rete                := v('P105_S_CALC_RETE');
    bcab.movi_mone_cant_deci      := v('P105_MOVI_MONE_CANT_DECI');
    bcab.impu_porc                := v('P105_IMPU_PORC');
    bcab.movi_timo_codi           := v('P105_MOVI_TIMO_CODI');
    bcab.MOVI_FACT_CODI           := v('P105_MOVI_FACT_CODI'); 
    bcab.impu_porc_base_impo      := v('p105_impu_porc_base_impo');
    bcab.p_para_inic              := 'C';
    bcab.impu_indi_baim_impu_incl := v('P105_IMPU_INDI_BAIM_IMPU_INCL');
    bcab.cuot_impu_codi           := v('P105_CUOT_IMPU_CODI');
    bcab.movi_tico_codi           := v('p105_movi_tico_codi');
    bcab.s_total                  := v('P105_S_TOTAL');
    bcab.movi_fech_apli           := v('P105_S_MOVI_FECH_APLI');
    bcab.impo_rete_mone           := v('p105_IMPO_RETE_MONE');
  
    -----retencion
    rete.movi_nume_rete           := v('P105_MOVI_NUME_RETE');
    rete.movi_nume_timb_rete      := v('P105_MOVI_NUME_TIMB_RETE');
    rete.movi_fech_venc_timb_rete := v('P105_FECH_VENC_TIMB_RETE');
    rete.movi_obse                := v('P105_MOVI_OBSE');
  
    begin
      select sum(c012) sald, sum(c013) sum_impo_rete_mone
        into bcab.sum_impo_pago, bcab.sum_impo_rete_mone
        from apex_collections a
       where collection_name = 'BDETALLE'
         and c001 = 'X';
    exception
      when others then
        null;
    end;
 
   
  
    bcab.movi_nume           := v('P105_MOVI_NUME');
    bcab.movi_clpr_desc      := v('P105_MOVI_CLPR_DESC');
    bcab.movi_clpr_codi      := v('P105_CLPR_CODI');
    bcab.movi_empr_codi      := nvl(v('AI_EMPR_CODI'), 0);
    bcab.movi_sucu_codi_orig := v('P105_MOVI_SUCU_CODI_ORIG');
    bcab.movi_mone_codi      := v('P105_MOVI_MONE_CODI');
    bcab.movi_tasa_mone      := v('P105_MOVI_TASA_MONE');
    bcab.movi_fech_emis      := v('P105_MOVI_FECH_EMIS');
  
  end pp_set_variable;

  procedure pp_generar_tesaka is
    salir  exception;
    v_resp varchar2(1000);
  begin
    --preguntar si se desea imprimir el reporte...  
    /*if fl_confirmar_reg('desea generar el archivo para tesaka?') <> upper('confirmar') then
      raise salir;
    end if;*/
  
/*    pa_gene_tesaka('APLI_' || bcab.movi_nume || '_' ||
                   bcab.movi_clpr_desc || '_' ||
                   to_char(bcab.movi_fech_apli, 'yyyymmdd') || '.txt',
                   null,
                   null,
                   null,
                   null,
                   null,
                   parameter.p_canc_codi_fcrr,
                   null,
                   v_resp);*/--7
                   null;
  exception
    when salir then
      null;
  end pp_generar_tesaka;

  procedure pp_actualiza_registro is
  
    salir exception;
  
  begin
    pp_set_variable;
  
    I020017.pp_valida_campo_marcado;
  
    pp_valida_fech(bcab.movi_fech_apli);
  
    if bcab.movi_fech_emis is null then
      pl_me('Debe ingresar la fecha del recibo!.');
    end if;
  
    if nvl(bcab.sum_impo_pago, 0) = 0 then
      pl_me('El pago debe asignarse por lo menos a un documento!');
    end if;
  
    if bcab.s_dife < 0 then
      pl_me('El saldo del Adelanto/Nota de Credito es menor a los  importes de los documentos asignados!');
    end if;
  
    pp_valida_importes;
  
    pp_actualiza_canc;
  
    if nvl(parameter.p_indi_rete_tesaka, 'N') = 'N' then
      if nvl(bcab.sum_impo_rete_mone, 0) > 0 then
      
        pp_actualizar_rete;
      end if;
    else
      if nvl(bcab.sum_impo_rete_mone, 0) > 0 then
      
        pp_actualizar_rete_tesaka(parameter.p_canc_codi_fcrr);
      end if;
    end if;
  
    /*if nvl(bcab.impo_rete_mone,0) > 0 then
      pp_impr_rete;
    end if;*/
  
    --Generar archivo tesaka
    if nvl(bcab.impo_rete_mone, 0) > 0 then
      if parameter.p_indi_rete_tesaka = 'S' then
        pp_generar_tesaka;
      end if;
    end if;
  
  exception
    when salir then
      null;
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualiza_registro;

  procedure pp_cargar_timb_rete(p_nro_1_rete               in number,
                                p_nro_2_rete               in number,
                                p_nro_3_rete               in number,
                                p_movi_clpr_codi           in number,
                                p_movi_fech_emis           in date,
                                p_movi_nume_timb_rete      in out varchar2,
                                p_movi_fech_venc_timb_rete in out varchar2,
                                p_clpr_codi_alte           in number) is
    v_tico_codi      number := 3;
    v_tico_indi_timb varchar2(1) := 'C';
  begin
  
    begin
      select timo_tico_codi, tico_indi_timb
        into v_tico_codi, v_tico_indi_timb
        from come_tipo_movi, come_tipo_comp
       where timo_tico_codi = tico_codi
         and timo_codi = parameter.p_codi_timo_rete_emit;
    
    Exception
      When no_data_found then
        Raise_application_error(-20001,
                                'Tipo de comprobante no configurado!');
    end;
  
    pp_validar_timbrado_rete(v_tico_codi,
                             to_number(p_nro_1_rete),
                             to_number(p_nro_2_rete),
                             p_movi_clpr_codi,
                             p_movi_fech_emis,
                             p_movi_nume_timb_rete,
                             p_movi_fech_venc_timb_rete,
                             v_tico_indi_timb,
                             p_clpr_codi_alte);
  
  END pp_cargar_timb_rete;

  procedure pp_validar_timbrado_rete(p_tico_codi      in number,
                                     p_esta           in number,
                                     p_punt_expe      in number,
                                     p_clpr_codi      in number,
                                     p_fech_movi      in date,
                                     p_timb           in out varchar2,
                                     p_fech_venc      in out date,
                                     p_tico_indi_timb in varchar2,
                                     p_clpr_codi_alte in number) is
  
    cursor c_timb is
      select cptc_nume_timb, cptc_fech_venc
        from come_clpr_tipo_comp
       where cptc_clpr_codi = p_clpr_codi --proveedor, cliente
         and cptc_tico_codi = p_tico_codi --tipo de comprobante
         and cptc_esta = p_esta --establecimiento 
         and cptc_punt_expe = p_punt_expe --punto de expedicion
         and cptc_fech_venc >= p_fech_movi
       order by cptc_fech_venc;
  
    cursor c_timb_2 is
      select deta_nume_timb, deta_fech_venc
        from come_tipo_comp_deta
       where deta_tico_codi = p_tico_codi --tipo de comprobante
         and deta_esta = p_esta --establecimiento 
         and deta_punt_expe = p_punt_expe --punto de expedicion
         and deta_fech_venc >= p_fech_movi
       order by deta_fech_venc;
  
    cursor c_timb_3 is
      select setc_nume_timb, setc_fech_venc
        from come_secu_tipo_comp
       where setc_secu_codi =
             (select peco_secu_codi
                from come_pers_comp
               where peco_codi = parameter.p_peco_codi)
         and setc_tico_codi = p_tico_codi --tipo de comprobante
         and setc_esta = p_esta --establecimiento 
         and setc_punt_expe = p_punt_expe --punto de expedicion
         and setc_fech_venc >= p_fech_movi
       order by setc_fech_venc;
  
    v_indi_entro varchar2(1) := upper('n');
    v_indi_espo  varchar2(1) := upper('n');
  
    v_tico_indi_habi_timb varchar2(10);
    v_tico_indi_timb_auto varchar2(10);
  begin
    if p_clpr_codi_alte = parameter.p_codi_prov_espo then
      v_indi_espo := upper('s');
    end if;
    v_indi_espo := 'N';
    begin
      select tico_indi_habi_timb, tico_indi_timb_auto
        into v_tico_indi_habi_timb, v_tico_indi_timb_auto
        from come_tipo_movi, come_tipo_comp
       where timo_tico_codi = tico_codi(+)
         and timo_codi = parameter.p_codi_timo_rete_emit;
    exception
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
    if nvl(v_tico_indi_timb_auto, 'N') = 'S' then
      if nvl(p_tico_indi_timb, 'C') = 'P' then
        if nvl(v_indi_espo, 'N') = 'N' then
          for x in c_timb loop
            v_indi_entro := upper('s');
            if p_timb is not null then
              p_timb      := p_timb; -- p_movi_nume_timb_rete;
              p_fech_venc := p_fech_venc; --p_fech_venc_timb_rete;
            else
              p_timb      := x.cptc_nume_timb;
              p_fech_venc := x.cptc_fech_venc;
            end if;
            exit;
          end loop;
        end if;
      elsif nvl(p_tico_indi_timb, 'C') = 'S' then
        ---si es por tipo de secuencia
        for x in c_timb_3 loop
          v_indi_entro := upper('s');
          if p_timb is not null then
            p_timb      := p_timb; -- p_movi_nume_timb_rete;
            p_fech_venc := p_fech_venc; --p_fech_venc_timb_rete;
          else
            p_timb      := x.setc_nume_timb;
            p_fech_venc := x.setc_fech_venc;
          end if;
          exit;
        end loop;
      else
        ---si es por tipo de comprobante
        for y in c_timb_2 loop
          v_indi_entro := upper('s');
          if p_timb is not null then
            p_timb      := p_timb; -- p_movi_nume_timb_rete;
            p_fech_venc := p_fech_venc; --p_fech_venc_timb_rete;
          else
            p_timb      := y.deta_nume_timb;
            p_fech_venc := y.deta_fech_venc;
          end if;
          exit;
        end loop;
      end if;
    
      if v_indi_entro = upper('n') then
        raise_application_error(-20001,
                                'No existe registro de timbrado cargado para este proveedor, o el timbrado cargado se encuentra vencido!!!');
      end if;
    end if;
  
  end pp_validar_timbrado_rete;

  PROCEDURE pp_valida_campo_marcado IS
    v_count number := 0;
  BEGIN
  
    select count(*)
      into v_count
      from apex_collections a
     where collection_name = 'BDETALLE'
       and c001 = 'X';
    if nvl(v_count, 0) = 0 then
      raise_application_error(-20001,
                              'No existe comprobante marcado para su cancelacion. Favor, seleccione el(los) documento(s) a cancelar.');
    end if;
  
  END pp_valida_campo_marcado;

  procedure pp_validar_impo_a_apli(p_impo_a_apli    in number,
                                   p_movi_sald_mone in number) is
    v_sum_cuot_sald_mone number := 0;
  begin
    select sum(c009) v_sum_cuot_sald_mone
      into v_sum_cuot_sald_mone
      from apex_collections a
     where collection_name = 'BDETALLE';
    IF NVL(p_impo_a_apli, 0) > 0 THEN
      IF NVL(p_impo_a_apli, 0) > NVL(p_movi_sald_mone, 0) THEN
        raise_application_error(-20001,
                                'El importe a aplicar no puede ser mayor al saldo del documento');
      END IF;
    
      IF NVL(p_impo_a_apli, 0) > NVL(v_SUM_CUOT_SALD_MONE, 0) THEN
        raise_application_error(-20001,
                                'El importe a aplicar no puede ser mayor al saldo Total de las cuotas ');
      END IF;
    
    END IF;
    pp_aplicar_cuotas(p_impo_a_apli);
  end pp_validar_impo_a_apli;

procedure pp_insert_movi_cuot_canc_adnc (
p_canc_movi_codi        in number,     
p_canc_cuot_movi_codi   in number, 
p_canc_cuot_fech_venc   in date, 
p_canc_fech_pago        in date, 
p_canc_impo_mone        in number, 
p_canc_impo_mmnn        in number, 
p_canc_impo_mmee        in number,
p_canc_impo_dife_camb   in number,
p_canc_impo_rete_mone   in number,
p_canc_impo_rete_mmnn   in number,
p_canc_tipo             in varchar2,
p_canc_impu_codi        in number,
p_canc_impu_mone        in number,
p_canc_impu_mmnn        in number,
p_canc_grav10_ii_mone   in number,
p_canc_grav5_ii_mone    in number,
p_canc_grav10_mone      in number,
p_canc_grav5_mone       in number,
p_canc_iva10_mone       in number,
p_canc_iva5_mone        in number,
p_canc_exen_mone        in number,
p_canc_grav10_ii_mmnn   in number,
p_canc_grav5_ii_mmnn    in number,
p_canc_grav10_mmnn      in number,
p_canc_grav5_mmnn       in number,
p_canc_iva10_mmnn       in number,
p_canc_iva5_mmnn        in number,
p_canc_exen_mmnn        in number
) is
   
   sin_saldo EXCEPTION;
   PRAGMA EXCEPTION_INIT(sin_saldo, -20009);
begin
  /*
    message(p_canc_movi_codi        );     
    message(p_canc_cuot_movi_codi   ); 
    message(p_canc_cuot_fech_venc   ); 
    message(p_canc_fech_pago        ); 
    message(p_canc_impo_mone        ); 
    message(p_canc_impo_mmnn        ); 
    message(p_canc_impo_mmee        );
    message(p_canc_impo_dife_camb   );
    message(p_canc_impo_rete_mone   );
    message(p_canc_impo_rete_mmnn   );
    message(:parameter.p_codi_base  );
    message(p_canc_tipo             );
    message(p_canc_impu_codi        );
    message(p_canc_impu_mone);
    message(p_canc_impu_mmnn);
    message(p_canc_grav10_ii_mone);
    message(p_canc_grav5_ii_mone);
    message(p_canc_grav10_mone);
    message(p_canc_grav5_mone);
    message(p_canc_iva10_mone);
    message(p_canc_iva5_mone);
    message(p_canc_exen_mone);
    message(p_canc_grav10_ii_mmnn);
    message(p_canc_grav5_ii_mmnn);
    message(p_canc_grav10_mmnn);
    message(p_canc_grav5_mmnn);
    message(p_canc_iva10_mmnn);
    message(p_canc_iva5_mmnn);
    message(p_canc_exen_mmnn);
  */
   --raise_application_error(-20001,'auu '||p_canc_cuot_movi_codi||' '||p_canc_cuot_fech_venc||' '||p_canc_tipo);
  insert into come_movi_cuot_canc (
  canc_movi_codi        ,     
  canc_cuot_movi_codi   , 
  canc_cuot_fech_venc   , 
  canc_fech_pago        , 
  canc_impo_mone        , 
  canc_impo_mmnn        , 
  canc_impo_mmee        ,
  canc_impo_dife_camb   ,
  canc_impo_rete_mone   ,
  canc_impo_rete_mmnn   ,
  canc_base             ,
  canc_tipo             ,
  canc_impu_codi        ,
  canc_impu_mone,
  canc_impu_mmnn,
  canc_grav10_ii_mone,
  canc_grav5_ii_mone,
  canc_grav10_mone,
  canc_grav5_mone,
  canc_iva10_mone,
  canc_iva5_mone,
  canc_exen_mone,
  canc_grav10_ii_mmnn,
  canc_grav5_ii_mmnn,
  canc_grav10_mmnn,
  canc_grav5_mmnn,
  canc_iva10_mmnn,
  canc_iva5_mmnn,
  canc_exen_mmnn,
  canc_indi_afec_sald
  ) values (
  p_canc_movi_codi        ,     
  p_canc_cuot_movi_codi   , 
  p_canc_cuot_fech_venc   , 
  p_canc_fech_pago        , 
  p_canc_impo_mone        , 
  p_canc_impo_mmnn        , 
  p_canc_impo_mmee        ,
  p_canc_impo_dife_camb   ,
  p_canc_impo_rete_mone   ,
  p_canc_impo_rete_mmnn   ,
  1,--:parameter.p_codi_base  ,
  p_canc_tipo             ,
  p_canc_impu_codi        ,
  p_canc_impu_mone,
  p_canc_impu_mmnn,
  p_canc_grav10_ii_mone,
  p_canc_grav5_ii_mone,
  p_canc_grav10_mone,
  p_canc_grav5_mone,
  p_canc_iva10_mone,
  p_canc_iva5_mone,
  p_canc_exen_mone,
  p_canc_grav10_ii_mmnn,
  p_canc_grav5_ii_mmnn,
  p_canc_grav10_mmnn,
  p_canc_grav5_mmnn,
  p_canc_iva10_mmnn,
  p_canc_iva5_mmnn,
  p_canc_exen_mmnn,
  'S'
  );
  
  
  
Exception  
  when sin_saldo then
    pl_me('El Movimiento no posee saldo...');
  when others then
     pl_me(SQLERRM);
    
end;


  procedure pp_aplicar_cuotas(p_impo_a_apli in number) is
  
    v_impo_a_apli number;
    v_sald_a_apli number;
    v_item        number := 0;
    v_impo_pago   number := 0;
    cursor c is
      select seq_id, c009 cuot_sald_mone, c012 impo_pago
        from apex_collections a
       where collection_name = 'BDETALLE';
  
  begin
  -- raise_application_error(-20001,'ssss');
    v_impo_a_apli := p_impo_a_apli;
    v_sald_a_apli := v_impo_a_apli;
  
    for i in c loop
    
      i020017.pp_update_member(i.seq_id, null, 1);
      i020017.pp_update_member(i.seq_id, null, 12);
    end loop;
    --raise_application_error(-20001,'aaaa');
    for bdet in c loop
      v_item := v_item + 1;
   
      
    if  v('P105_MOVI_TIMO_CODI') = parameter.p_codi_timo_adle then
--raise_application_error(-20001,'aaaa');
      if v_sald_a_apli > bdet.cuot_sald_mone then
      
        v_impo_pago   := bdet.cuot_sald_mone;
        v_sald_a_apli := v_sald_a_apli - v_impo_pago;
        -- :bdet.s_marca := 'x';
        i020017.pp_update_member(bdet.seq_id, 'X', 1);
        i020017.pp_update_member(bdet.seq_id, v_impo_pago, 12);
      else
        v_impo_pago   := v_sald_a_apli;
        v_sald_a_apli := 0;
        -- :bdet.s_marca   := 'x';
        i020017.pp_update_member(bdet.seq_id, 'X', 1);
        i020017.pp_update_member(bdet.seq_id, v_impo_pago, 12);
      
        exit;
      end if;
      
      else
       
      if v_sald_a_apli<= to_number(bdet.cuot_sald_mone) then
        
        v_impo_pago   := v_sald_a_apli;
        v_sald_a_apli := 0;
        -- :bdet.s_marca   := 'x';
        i020017.pp_update_member(bdet.seq_id, 'X', 1);
        i020017.pp_update_member(bdet.seq_id, v_impo_pago, 12);
          exit;
          
        end if;
      
      end if;
      
    --raise_application_error(-20001,'No paso por aca');
      if v_sald_a_apli <= 0 then
        exit;
      end if;
    
    end loop;
  
  end pp_aplicar_cuotas;

  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010, v_mensaje);
  end pl_me;


function fp_format(i_number in number, i_decimals in number)
    return varchar2 is
    v_formatted_number varchar2(100);
    v_formato          varchar2(100) := '999g999g999g999g999g999';
  begin
    if i_decimals > 0 then
      v_formato := v_formato || 'd' || rpad('0', i_decimals, '0');
    end if;
    -- Format the number with the specified decimals
    v_formatted_number := trim(to_char(i_number, v_formato));
    -- Return the formatted number
    return v_formatted_number;
  end fp_format;
  
  procedure pp_validar_aplicacion_nc(p_cuot_movi_codi in number)
    is
    begin
      for n in detalle loop
       if n.cuot_movi_codi<> p_cuot_movi_codi then
         pl_me('No es posible aplicar una nota de credito a dos diferente factura. Favor verificar.');
         end if;
        end loop;
      end pp_validar_aplicacion_nc;
       

  ---------------------------------------------------------------------------------------
  function fp_get_come_soli_tras_depo(i_filtro in varchar2) return varchar2 is
  
    v_return varchar2(1000) := null;
  
  begin
  
    -- Busqueda por codigo alternativo
    begin
      select s.sotr_nume
        into v_return
        from come_soli_tras_depo s
       where sotr_nume = i_filtro
       and s.sotr_empr_codi = fa_empresa;
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
      select s.sotr_nume
        into v_return
        from come_soli_tras_depo s
       where s.sotr_empr_codi = fa_empresa
         and upper(s.sotr_obse) like '%' || upper(i_filtro) || '%';
      return v_return;
    exception
      when no_data_found then
        null;
      when others then
        return null;
    end;
  
    return null;
  
  end fp_get_come_soli_tras_depo;

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


end i020017;
