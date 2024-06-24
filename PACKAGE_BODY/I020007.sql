
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020007" is
  e_sin_parametro exception;
  g_user          varchar2(100) := fp_user;
  g_empresa       number := v('AI_EMPR_CODI');
  type t_bcab is record(
    movi_clpr_indi_judi          varchar(2),
    movi_clpr_indi_exce          varchar(2),
    movi_nume                    come_movi.movi_nume%type,
    movi_clpr_codi               come_movi.movi_clpr_codi%type,
    movi_fech_emis               come_movi.movi_fech_emis%type,
    movi_mone_codi               come_movi.movi_mone_codi%type,
    movi_timo_codi               come_movi.movi_timo_codi%type,
    movi_codi                    come_movi.movi_codi%type,
    movi_fech_grab               come_movi.movi_fech_grab%type,
    movi_afec_sald               come_movi.movi_afec_sald%type,
    movi_tasa_mmee               come_movi.movi_tasa_mmee%type,
    movi_dbcr                    come_movi.movi_dbcr%type,
    movi_fech_oper               come_movi.movi_fech_oper%type,
    movi_grav_mmee               come_movi.movi_grav_mmee%type,
    movi_grav_mmnn               come_movi.movi_grav_mmnn%type,
    movi_grav_mone               come_movi.movi_grav_mone%type,
    movi_grav10_ii_mmnn          come_movi.movi_grav10_ii_mmnn%type,
    movi_grav10_ii_mone          come_movi.movi_grav10_ii_mone%type,
    movi_grav10_mmnn             come_movi.movi_grav10_mmnn%type,
    movi_grav10_mone             come_movi.movi_grav10_mone%type,
    movi_grav5_ii_mmnn           come_movi.movi_grav5_ii_mmnn%type,
    movi_grav5_ii_mone           come_movi.movi_grav5_ii_mone%type,
    movi_grav5_mmnn              come_movi.movi_grav5_mmnn%type,
    movi_grav5_mone              come_movi.movi_grav5_mone%type,
    movi_impo_mmnn_ii            come_movi.movi_impo_mmnn_ii%type,
    movi_impo_mone_ii            come_movi.movi_impo_mone_ii%type,
    movi_indi_cons               come_movi.movi_indi_cons%type,
    movi_iva_mmnn                come_movi.movi_iva_mmnn%type,
    movi_iva_mone                come_movi.movi_iva_mone%type,
    movi_exen_mmee               come_movi.movi_exen_mmee%type,
    movi_iva_mmee                come_movi.movi_iva_mmee%type,
    movi_sald_mmnn               come_movi.movi_sald_mmnn%type,
    movi_sald_mmee               come_movi.movi_sald_mmee%type,
    movi_sald_mone               come_movi.movi_sald_mone%type,
    movi_iva10_mmnn              come_movi.movi_iva10_mmnn%type,
    movi_iva10_mone              come_movi.movi_iva10_mone%type,
    movi_sucu_codi_orig          come_movi.movi_sucu_codi_orig%type,
    movi_tasa_mone               come_movi.movi_tasa_mone%type,
    movi_exen_mmnn               come_movi.movi_exen_mmnn%type,
    movi_obse                    come_movi.movi_obse%type,
    movi_clpr_desc               come_movi.movi_clpr_desc%type,
    movi_clpr_dire               come_movi.movi_clpr_dire%type,
    movi_clpr_ruc                come_movi.movi_clpr_ruc%type,
    movi_clpr_tele               come_movi.movi_clpr_tele%type,
    movi_depo_codi_orig          come_movi.movi_depo_codi_orig%type,
    movi_empr_codi               come_movi.movi_empr_codi%type,
    movi_exen_mone               come_movi.movi_exen_mone%type,
    movi_iva5_mmnn               come_movi.movi_iva5_mmnn%type,
    movi_iva5_mone               come_movi.movi_iva5_mone%type,
    movi_empl_codi               come_movi.movi_empl_codi%type,
    movi_clpr_situ               come_movi.movi_clpr_situ%type,
    movi_clpr_empl_codi_recl     come_movi.movi_clpr_empl_codi_recl%type,
    movi_indi_auto_impr          come_movi.movi_indi_auto_impr%type,
    movi_emit_reci               come_movi.movi_emit_reci%type,
    movi_codi_adel               number,
    s_clpr_agen_codi             number,
    sucu_nume_item               number,
    movi_nume_orde_pago          number,
    movi_tico_codi               number,
    clpr_codi_det                number,
    cabe_sum_inte_mora_puni_gaad number,
    cabe_inte_mora_puni_cobr     number,
    cabe_impo_maxi_desc_inte     number,
    tota_impo_inte_puni          number,
    tota_impo_inte_mora          number,
    tota_impo_inte_gast_admi     number,
    tico_indi_vali_nume          varchar2(8),
    movi_timo_desc               varchar2(500),
    movi_timo_desc_abre          varchar2(500),
    movi_exen_mone_tota          number,
    mone_codi_det                number,
    movi_mone_cant_deci          number,
    clpr_indi_exce               varchar2(8),
    s_dife                       number,
    s_dife_mmnn                  number,
    sum_impo_pago                number,
    sum_inte_mora_puni           number,
    ---retencion
    movi_nume_rete           number,
    movi_nume_timb_rete      number,
    movi_fech_venc_timb_rete date,
    tare_indi_talo_manu      varchar2(2),
    movi_obse_rete           varchar2(500),
    movi_tare_codi           number,
    ---
    s_impo_efec      number,
    s_impo_cheq      number,
    s_impo_rete      number,
    s_impo_rete_reci number,
    s_impo_rete_rent number,
    s_impo_tarj      number,
    moco_nume_item   number := 0);
  bcab t_bcab;
  type r_parameter is record(
    p_empr_codi                number := 1,
    p_indi_bloq_clie_inforconf varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_bloq_clie_inforconf'))),
    p_codi_tipo_empl_cobr      number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_cobr')),
    p_indi_impr_cheq_emit      varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_impr_cheq_emit'))),
    p_codi_timo_adle           number := to_number(general_skn.fl_busca_parametro('p_codi_timo_adle')),
    p_codi_timo_adlr           number := to_number(general_skn.fl_busca_parametro('p_codi_timo_adlr')),
    p_codi_conc_adle           number := to_number(general_skn.fl_busca_parametro('p_codi_conc_adle')),
    p_codi_conc_adlr           number := to_number(general_skn.fl_busca_parametro('p_codi_conc_adlr')),
    p_codi_timo_reem           number := to_number(general_skn.fl_busca_parametro('p_codi_timo_reem')),
    p_codi_timo_rere           number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rere')),
    p_indi_vali_repe_cheq      varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_repe_cheq'))),
    p_codi_conc_pago_prov      number := to_number(general_skn.fl_busca_parametro('p_codi_conc_pago_prov')),
    p_codi_conc_cobr_clie      number := to_number(general_skn.fl_busca_parametro('p_codi_conc_cobr_clie')),
    p_codi_impu_exen           number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_codi_mone_mmnn           number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_cant_deci_mmnn           number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    ---tercer grupo de parametros
    p_codi_timo_rete_emit      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rete_emit')),
    p_porc_aplic_reten         number := to_number(general_skn.fl_busca_parametro('p_porc_aplic_reten')),
    p_codi_conc_rete_emit      number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_emit')),
    p_form_impr_reci           varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_reci'))),
    p_indi_porc_rete_sucu      varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_porc_rete_sucu'))),
    p_form_calc_rete_emit      number := to_number(general_skn.fl_busca_parametro('p_form_calc_rete_emit')),
    p_indi_rend_comp           varchar2(2) := v('P10_INDI_REND_COMP'),
    p_codi_timo_pcoe           number := to_number(general_skn.fl_busca_parametro('p_codi_timo_pcoe')),
    p_codi_timo_fcoe           number := to_number(general_skn.fl_busca_parametro('p_codi_timo_fcoe')),
    p_indi_cobr_inte_bole_fact varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_cobr_inte_bole_fact'))),
    p_form_impr_fact           varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_fact'))),
    p_codi_timo_rcnadle        varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_timo_rcnadle'))),
    p_codi_timo_rcnadlr        varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_timo_rcnadlr'))),
    p_codi_conc_inte_cobr      number := to_number(general_skn.fl_busca_parametro('p_codi_conc_inte_cobr')),
    p_codi_conc_inte_cobr_puni number := to_number(general_skn.fl_busca_parametro('p_codi_conc_inte_cobr_puni')),
    p_codi_conc_inte_cobr_mora number := to_number(general_skn.fl_busca_parametro('p_codi_conc_inte_cobr_mora')),
    p_codi_conc_gast_admi_cobr number := to_number(general_skn.fl_busca_parametro('p_codi_conc_gast_admi_cobr')),
    p_inte_movi_codi           number := null,
    p_inte_movi_dbcr           varchar2(200) := null,
    p_movi_nume_fact_inte      number := null,
    p_movi_codi_rete           number := null,
    p_movi_nume_rete           number := null,
    p_dias_grac_clie           number := to_number(general_skn.fl_busca_parametro('p_dias_grac_clie')),
    p_indi_inte_cobr_app       varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_inte_cobr_app'))),
    p_indi_nave_form_pago      varchar2(2) := 'N',
    p_para_inic                varchar2(2) := 'C',
    p_clie_desc_inte           number,
    p_user_perf_desc_inte      number,
    p_indi_auto                varchar(2),
    p_emit_reci                varchar(2) := v('p10_emit_reci'),
    p_para_inic_adel           varchar(2) := v('p10_para_inic_adel'),
    p_codi_timo                number := v('p10_codi_timo'),
    p_peco_codi                number := v('p10_peco_codi'),
    p_indi_rete_tesaka         varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_rete_tesaka'))));
  parameter r_parameter;
  cursor c_bdetalle is
    select c001 ind_marcado,
           c002 movi_nume,
           c003 movi_mone_codi,
           c004 movi_fech_emis,
           c005 cuot_nume_desc,
           c006 cuot_fech_venc,
           c007 cuot_sald_mone,
           c008 cuot_sald_mmnn,
           c009 movi_codi,
           c010 cuot_tasa_mone,
           c011 clpr_codi,
           c012 clpr_codi_alte,
           c013 movi_iva_mone,
           c014 movi_codi_rete,
           c015 orte_desc,
           c016 impo_inte_mora_puni_orig,
           c017 impo_inte_mora_orig,
           c018 impo_inte_puni_orig,
           c019 impo_inte_gast_admi_orig,
           c020 impo_inte_gast_admi,
           c021 cuot_impo_mone,
           c022 impo_pago_mone,
           c023 impo_inte_mora_puni,
           c025 impo_rete_mone,
           c026 s_apli_rete,
           c027 impo_inte_gaad,
           c028 impo_inte_puni,
           c029 impo_inte_mora,
           c030 impo_inte_mora_puni_gaad,
           round((c022 * v('P10_MOVI_TASA_MONE')),
                 parameter.p_cant_deci_mmnn) impo_pago_mmnn,
           (select sum(round((c022 * v('P10_MOVI_TASA_MONE')),
                             parameter.p_cant_deci_mmnn))
              from apex_collections a
             where collection_name = 'BDETALLE'
               and c001 = 'X') sum_impo_pago_mmnn,
           seq_id
      from apex_collections a
     where collection_name = 'BDETALLE'
       and c001 = 'X';
  cursor cur_bfp is
    select c001 fopa_codi,
           c002 cheq_nume,
           c003 cheq_serie,
           c004 cheq_banc_codi,
           c005 vale_codi,
           c006 adel_codi
      from apex_collections a
     where a.collection_name = 'CHEQUE';
  procedure pp_cargar_parametros is
    v_codi_timo      number;
    v_empr_retentora varchar2(10);
  begin
    setitem('p10_indi_form_pago', 'N');
    begin
      select nvl(e.empr_retentora, 'NO')
        into v_empr_retentora
        from come_empr e
       where e.empr_codi = 1;
      setitem('p10_empr_retentora', v_empr_retentora);
    end;
    setitem('p10_para_inic', parameter.p_para_inic);
    if rtrim(ltrim(upper(parameter.p_para_inic))) =
       rtrim(ltrim(upper('P'))) then
      setitem('p10_emit_reci', 'R');
      setitem('p10_clie_prov', 'P');
      setitem('p10_codi_conc', parameter.p_codi_conc_pago_prov);
      setitem('p10_codi_timo', parameter.p_codi_timo_rere);
      v_codi_timo := parameter.p_codi_timo_rere;
    elsif rtrim(ltrim(upper(parameter.p_para_inic))) =
          rtrim(ltrim(upper('C'))) then
      setitem('p10_emit_reci', 'E');
      setitem('p10_clie_prov', 'C');
      setitem('p10_para_inic_adel', 'AC');
      setitem('p10_codi_conc', parameter.p_codi_conc_cobr_clie);
      setitem('p10_codi_timo', parameter.p_codi_timo_reem);
      v_codi_timo := parameter.p_codi_timo_reem;
    end if;
    setitem('p10_movi_timo_codi', v_codi_timo);
    pp_muestra_tipo_movi(v_codi_timo);
    setitem('P10_INDI_CONT_CORR_TALO_RECI',
            ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_cont_corr_talo_reci'))));
    setitem('p10_indi_inte_cobr_app',
            ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_inte_cobr_app'))));
    setitem('p10_indi_gast_admi_cobr',
            ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_gast_admi_cobr'))));
    setitem('P10_INDI_REND_COMP', 'N');
    --- inicializar detalle de nota
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDET_NOTA_ADEL');
    apex_collection.add_member(p_collection_name => 'BDET_NOTA_ADEL',
                               p_c002            => null,
                               p_c003            => null,
                               p_c004            => null);
  end pp_cargar_parametros;
  procedure pp_muestra_tipo_movi(p_codi_timo in number) is
    v_movi_tico_codi           number;
    v_tica_codi                number;
    v_timo_dbcr                varchar2(20);
    v_timo_indi_apli_adel_fopa varchar2(20);
    v_timo_tica_codi           number;
    v_timo_dbcr_caja           varchar2(20);
    v_tico_indi_vali_nume      varchar2(10);
    v_timo_afec_sald           varchar2(1);
  begin
    select timo_tica_codi,
           timo_tico_codi,
           timo_indi_apli_adel_fopa,
           timo_tica_codi,
           timo_dbcr_caja,
           timo_dbcr,
           nvl(tico_indi_vali_nume, 'N') tico_indi_vali_nume,
           timo_afec_sald
      into v_tica_codi,
           v_movi_tico_codi,
           v_timo_indi_apli_adel_fopa,
           v_timo_tica_codi,
           v_timo_dbcr_caja,
           v_timo_dbcr,
           v_tico_indi_vali_nume,
           v_timo_afec_sald
      from come_tipo_movi, come_tipo_comp
     where timo_codi = p_codi_timo
       and tico_codi(+) = timo_tico_codi;
    if v_tica_codi is null then
      raise_application_error(-20001,
                              'Debe relacionar el tipo de cambio al tipo de movimiento ' ||
                              p_codi_timo);
    end if;
    if v_movi_tico_codi is null then
      raise_application_error(-20001,
                              'Debe relacionar el tipo de Comprobante al tipo de movimiento ' ||
                              p_codi_timo);
    end if;
    setitem('P10_MOVI_TICO_CODI', v_movi_tico_codi);
    setitem('P10_TICA_CODI', v_tica_codi);
    setitem('P10_MOVI_DBCR', v_timo_dbcr);
    setitem('P10_TIMO_DBCR_CAJA', v_timo_dbcr_caja);
    setitem('P10_MOVI_AFEC_SALD', v_timo_afec_sald);
    setitem('P10_TICO_INDI_VALI_NUME', v_tico_indi_vali_nume);
  exception
    when no_data_found then
      raise_application_error(-20001, 'Tipo de Movimiento inexistente');
    when too_many_rows then
      raise_application_error(-20001, 'Tipo de Movimiento duplicado');
    when others then
      raise_application_error(-20001, 'Error ' || sqlerrm);
  end pp_muestra_tipo_movi;
  procedure pp_mostrar_sucursal(p_movi_sucu_codi_orig in number,
                                p_movi_empr_codi      in number) is
  begin
    if p_movi_sucu_codi_orig is not null then
      declare
        v_exist number;
      begin
        select count(*)
          into v_exist
          from come_sucu s
         where s.sucu_codi = p_movi_sucu_codi_orig
           and s.sucu_empr_codi = p_movi_empr_codi;
        if v_exist = 0 then
          raise_application_error(-20001,
                                  'Sucursal inexistente o no pertenece a la empresa ' ||
                                  p_movi_empr_codi);
        end if;
      exception
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
      -- pl_muestra_come_sucu(p_movi_sucu_codi_orig, p_movi_sucu_desc_orig);
      if upper(nvl(parameter.p_indi_porc_rete_sucu, upper('n'))) =
         upper('s') then
        begin
          select s.sucu_porc_rete
            into parameter.p_porc_aplic_reten
            from come_sucu s
           where s.sucu_codi = p_movi_sucu_codi_orig
             and s.sucu_empr_codi = p_movi_empr_codi;
        exception
          when others then
            raise_application_error(-20001,
                                    'Error en pp_mostrar_sucursal' ||
                                    sqlerrm);
        end;
      end if;
    end if;
  end pp_mostrar_sucursal;
  procedure pp_validar_cliente(p_clpr_codi_alte           in number,
                               p_clpr_desc                out varchar2,
                               p_clpr_codi                out varchar2,
                               p_clpr_prov_retener        out varchar2,
                               p_clpr_situ                out number,
                               p_clpr_empl_codi_recl      out number,
                               p_clpr_indi_inforconf      out varchar2,
                               p_clpr_indi_judi           out varchar2,
                               p_clpr_indi_exce           out varchar2,
                               p_clpr_agen_codi           out number,
                               p_clpr_agen_desc           out varchar2,
                               p_agen_codi_alte           out varchar2,
                               p_s_indi_vali_subc         out varchar2,
                               p_clpr_ruc                 out varchar2,
                               p_porc_inte_clie_atra      out number,
                               p_porc_inte_clie_atra_puni out number,
                               p_clpr_codi_alte_f9        out number) is
  begin
    if p_clpr_codi_alte is not null then
      pp_muestra_clpr(p_clpr_codi_alte,
                      p_clpr_desc,
                      p_clpr_codi,
                      p_clpr_prov_retener,
                      p_clpr_situ,
                      p_clpr_empl_codi_recl,
                      p_clpr_indi_inforconf,
                      p_clpr_indi_judi,
                      p_clpr_indi_exce,
                      p_clpr_ruc,
                      p_porc_inte_clie_atra,
                      p_porc_inte_clie_atra_puni);
    
      p_clpr_codi_alte_f9 := p_clpr_codi_alte;
    
      pp_muestra_clpr_agen(p_clpr_codi,
                           p_clpr_agen_codi,
                           p_clpr_agen_desc,
                           p_agen_codi_alte);
      if nvl(p_clpr_indi_judi, 'N') = 'S' then
        if nvl(p_clpr_indi_exce, 'N') = 'S' then
          -- si esta en excepcion solo se advierte
          raise_application_error(-20001,
                                  'Atencion, El cliente se encuentra en estado Judicial.');
        else
          raise_application_error(-20001,
                                  'El Cliente se encuentra en estado Judicial.. Favor comunicarse con el departamento de Creditos.');
        end if;
      end if;
      if parameter.p_indi_bloq_clie_inforconf = 'S' and
         p_clpr_indi_inforconf = 'S' then
        if nvl(p_clpr_indi_exce, 'N') = 'S' then
          -- si esta en excepcion solo se advierte
          raise_application_error(-20001,
                                  'Atencion, El cliente se encuentra en Inforconf.');
        else
          raise_application_error(-20001,
                                  'El cliente cuenta con Inforconf. Favor comunicarse con el departamento de cobranzas.');
        end if;
      end if;
      --pp_validar_sub_cuenta;
      pp_validar_sub_cuenta(p_clpr_codi, p_s_indi_vali_subc);
    end if;
  end pp_validar_cliente;
  procedure pp_muestra_clpr(p_clpr_codi_alte           in number,
                            p_clpr_desc                out varchar2,
                            p_clpr_codi                out varchar2,
                            p_clpr_prov_retener        out varchar2,
                            p_clpr_situ                out number,
                            p_clpr_empl_codi_recl      out number,
                            p_clpr_indi_inforconf      out varchar2,
                            p_clpr_indi_judi           out varchar2,
                            p_clpr_indi_exce           out varchar2,
                            p_clpr_ruc                 out varchar2,
                            p_porc_inte_clie_atra      out number,
                            p_porc_inte_clie_atra_puni out number) is
    p_user_perf_desc_inte number;
    v_CLPR_EMPL_CODI_COBR number;
  begin
    select clpr_desc,
           clpr_codi,
           nvl(clpr_prov_retener, 'NO'),
           clpr_cli_situ_codi,
           clpr_empl_codi_recl,
           clpr_indi_inforconf,
           nvl(clpr_indi_judi, 'N'),
           clpr_indi_exce,
           clpr_ruc,
           CLPR_EMPL_CODI_COBR
      into p_clpr_desc,
           p_clpr_codi,
           p_clpr_prov_retener,
           p_clpr_situ,
           p_clpr_empl_codi_recl,
           p_clpr_indi_inforconf,
           p_clpr_indi_judi,
           p_clpr_indi_exce,
           p_clpr_ruc,
           v_CLPR_EMPL_CODI_COBR
      from come_clie_prov
     where clpr_codi_alte = p_clpr_codi_alte
       and clpr_indi_clie_prov = 'C';
    setitem('P10_EMPL_CODI_ALTE', v_CLPR_EMPL_CODI_COBR);
    begin
      ---carga los parametros de interes puni y mora
      select c1.clas1_porc_inte_mora, c1.clas1_porc_inte_puni
        into p_porc_inte_clie_atra, p_porc_inte_clie_atra_puni
        from come_clie_clas_1 c1, come_clie_prov c
       where c.clpr_indi_clie_prov = 'C'
         and c.clpr_clie_clas1_codi = c1.clas1_codi
         and c.clpr_codi = p_clpr_codi;
    exception
      when no_data_found then
        setitem('P10_PORC_INTE_CLIE_ATRA', 0);
        setitem('P10_PORC_INTE_CLIE_ATRA_PUNI', 0);
    end;
    begin
      ---recupera el porc. de inte. del usuario
      select p.perf_max_desc
        into p_user_perf_desc_inte
        from segu_user u, come_perf_auto_desc_inte p
       where u.user_perf_desc_inte_codi = p.perf_codi
         and u.user_login = fp_user;
    exception
      when no_data_found then
        --p_user_perf_desc_inte := 0;
        null;
    end;
  exception
    when no_data_found then
      p_clpr_desc := null;
      raise_application_error(20001, 'cliente inexistente!');
    when others then
      raise_application_error(-20001, 'error: ' || sqlerrm);
  end pp_muestra_clpr;
  procedure pp_validar_sub_cuenta(p_movi_clpr_codi   in number,
                                  p_s_indi_vali_subc out varchar2) is
    v_count number := 0;
  begin
    select count(*)
      into v_count
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_movi_clpr_codi;
    if v_count > 0 then
      p_s_indi_vali_subc := 'S';
    else
      p_s_indi_vali_subc := 'N';
    end if;
  end pp_validar_sub_cuenta;
  procedure pp_muestra_clpr_agen(p_clpr_codi      in number,
                                 p_clpr_agen_codi out number,
                                 p_clpr_agen_desc out varchar2,
                                 p_empl_codi_alte out varchar2) is
  begin
    select clpr_empl_codi, empl_desc, empl_codi_alte
      into p_clpr_agen_codi, p_clpr_agen_desc, p_empl_codi_alte
      from come_clie_prov, come_empl
     where clpr_empl_codi = empl_codi
       and clpr_codi = p_clpr_codi;
  exception
    when no_data_found then
      p_clpr_agen_codi := null;
      p_clpr_agen_desc := 'No tiene agente asignado';
      p_empl_codi_alte := null;
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_clpr_agen;
  procedure pp_muestra_sub_cuenta(p_clpr_codi      in number,
                                  p_sucu_nume_item in number,
                                  p_sucu_desc      out varchar2) is
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
  procedure pp_valida_fech(p_fech in date) is
    p_fech_inic date;
    p_fech_fini date;
  begin
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
    if p_fech not between p_fech_inic and p_fech_fini then
      raise_application_error(-20001,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                              to_char(p_fech_fini, 'dd-mm-yyyy'));
    end if;
  end pp_valida_fech;
  procedure pp_muestra_come_empl(p_empl_empr_codi in number,
                                 p_emti_tiem_codi in number,
                                 p_empl_codi_alte in varchar2,
                                 p_empl_desc      out varchar2,
                                 p_empl_codi      out number) is
  begin
    select e.empl_desc, e.empl_codi
      into p_empl_desc, p_empl_codi
      from come_empl e, come_empl_tiem t
     where e.empl_codi = t.emti_empl_codi
       and t.emti_tiem_codi = p_emti_tiem_codi
       and e.empl_empr_codi = p_empl_empr_codi
       and nvl(empl_esta, 'A') = 'A'
       and ltrim(rtrim(lower(e.empl_codi_alte))) =
           ltrim(rtrim(lower(p_empl_codi_alte)));
  exception
    when no_data_found then
      p_empl_desc := null;
      p_empl_codi := null;
      raise_application_error(-20001,
                              'Empleado inexistente o no es del tipo requerido o no se encuentra Activo');
    when others then
      raise_application_error(-20001, sqlerrm || 1);
  end pp_muestra_come_empl;
  procedure pp_validar_cobrador(p_empl_codi_alte           in number,
                                p_empl_desc                out varchar2,
                                p_empl_codi                out number,
                                p_emit_reci                in varchar2,
                                p_movi_tico_codi           in number,
                                p_indi_cont_corr_talo_reci in varchar2,
                                p_movi_nume                out number,
                                p_movi_tare_codi           out number,
                                p_ind_mens_tal             out varchar2,
                                p_empl_codi_alte_f9        out varchar2) is
  begin
    if p_emit_reci = 'E' then
      if parameter.p_para_inic = 'C' then
        if p_empl_codi_alte is null then
          raise_application_error(-20001,
                                  'Debe ingresar el codigo del Cobrador!');
        else
          pp_muestra_come_empl(g_empresa,
                               parameter.p_codi_tipo_empl_cobr,
                               p_empl_codi_alte,
                               p_empl_desc,
                               p_empl_codi);
        
          p_empl_codi_alte_f9 := p_empl_codi_alte;
        end if;
      end if;
    end if;
  
    if parameter.p_para_inic = 'C' then
      if p_indi_cont_corr_talo_reci = 'S' then
        --recupera sgte numero de recibo del cobrador ingresado
        i020007.pp_devu_nume_comp(p_movi_tico_codi => p_movi_tico_codi,
                                  p_movi_empl_codi => p_empl_codi,
                                  p_movi_nume      => p_movi_nume,
                                  p_movi_tare_codi => p_movi_tare_codi,
                                  p_ind_mens_tal   => p_ind_mens_tal);
      end if;
    end if;
  
  end pp_validar_cobrador;
  procedure pp_devu_nume_comp(p_movi_tico_codi in number,
                              p_movi_empl_codi in number,
                              p_movi_nume      out number,
                              p_movi_tare_codi out number,
                              p_ind_mens_tal   out varchar2) is
    v_tare_reci_desd      number;
    v_tare_reci_hast      number;
    v_tare_indi_talo_manu varchar2(2);
  begin
    select nvl(tare_ulti_nume, 0) + 1,
           tare_codi,
           tare_reci_desd,
           tare_reci_hast,
           nvl(tare_indi_talo_manu, 'N')
      into p_movi_nume,
           p_movi_tare_codi,
           v_tare_reci_desd,
           v_tare_reci_hast,
           v_tare_indi_talo_manu
      from come_talo_reci
     where tare_esta = 'A'
       and tare_tico_codi = p_movi_tico_codi
       and tare_empl_codi = p_movi_empl_codi;
    if p_movi_nume > v_tare_reci_hast then
      p_movi_nume := v_tare_reci_desd;
    end if;
  
    setitem('P10_NUME_COMP_DUPL', 'N');
  
    p_ind_mens_tal := 'N';
    setitem('P10_TARE_INDI_TALO_MANU', v_tare_indi_talo_manu);
  exception
    when no_data_found then
      p_ind_mens_tal := 'S';
      setitem('P10_NUME_COMP_DUPL', 'N');
      setitem('P10_TARE_INDI_TALO_MANU', v_tare_indi_talo_manu);
    when too_many_rows then
      ---levantar pantalla de lov....
      setitem('P10_NUME_COMP_DUPL', 'S');
      p_movi_nume := null;
      setitem('P10_TARE_INDI_TALO_MANU', v_tare_indi_talo_manu);
    
  end pp_devu_nume_comp;
  procedure pp_devu_nume_comp_dupl(p_movi_tare_codi in number,
                                   p_movi_nume      out number) is
    v_tare_reci_desd      number;
    v_tare_reci_hast      number;
    v_tare_indi_talo_manu varchar2(2);
  begin
    select nvl(tare_ulti_nume, 0) + 1,
           tare_reci_desd,
           tare_reci_hast,
           nvl(tare_indi_talo_manu, 'N')
      into p_movi_nume,
           v_tare_reci_desd,
           v_tare_reci_hast,
           v_tare_indi_talo_manu
      from come_talo_reci
     where tare_codi = p_movi_tare_codi;
    if p_movi_nume > v_tare_reci_hast then
      p_movi_nume := v_tare_reci_desd;
    end if;
    setitem('P10_NUME_COMP_DUPL', 'N');
    setitem('P10_TARE_INDI_TALO_MANU', v_tare_indi_talo_manu);
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Debe seleccionar uno de los talonarios de la lista de valores');
  end pp_devu_nume_comp_dupl;
  procedure pp_carga_secu(p_secu_nume_cobr out number) is
  begin
    select nvl(secu_nume_cobr, 0) + 1
      into p_secu_nume_cobr
      from come_secu
     where secu_codi = (select f.user_secu_codi
                          from segu_user f
                         where user_login = fp_user)
    /* (select peco_secu_codi
     from come_pers_comp
    where peco_codi = nvl(p_peco_codi, 1))*/
    ;
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Codigo de Secuencia de Cobranzas inexistente');
  end pp_carga_secu;
  procedure pp_veri_nume_libr(p_movi_tare_codi in number,
                              p_movi_nume      in out number) is
    v_nume number;
    v_indi varchar2(1);
    cursor c_compr is
      select m.movi_nume
        from come_movi m, come_tipo_movi t, come_talo_reci r
       where m.movi_timo_codi = t.timo_codi
         and r.tare_codi = p_movi_tare_codi
         and t.timo_tico_codi = 5
         and m.movi_nume >= r.tare_reci_desd
         and m.movi_nume <= r.tare_reci_hast
      union
      select a.anul_nume movi_nume
        from come_movi_anul a, come_tipo_movi t, come_talo_reci r
       where a.anul_timo_codi = t.timo_codi
         and r.tare_codi = p_movi_tare_codi
         and t.timo_tico_codi = 5
         and a.anul_nume >= r.tare_reci_desd
         and a.anul_nume <= r.tare_reci_hast
       order by 1;
  begin
  
    select r.tare_reci_desd - 1
      into v_nume
      from come_talo_reci r
     where r.tare_codi = p_movi_tare_codi;
  
    v_indi := 'N';
    /*for k in c_compr loop
      v_nume := v_nume + 1;
      if v_nume < k.movi_nume then
        v_indi := 'S';
        exit;
      end if;
    end loop;
    
    if v_indi = 'S' then
      p_movi_nume := v_nume;
    else
      p_movi_nume := -1;
    end if;*/
  
    select nvl(min(s.aumo_nume), p_movi_nume) numero
      into p_movi_nume
      from AUDI_COME_MOVI s
      join come_talo_reci r
        on s.aumo_nume >= r.tare_reci_desd
       and s.aumo_nume <= r.tare_reci_hast
     where s.AUMO_INDI_BORR_ANUL = 'B'
          -- AND s.aumo_timo_codi =  parameter.p_codi_timo_reem
       and r.tare_codi = p_movi_tare_codi
       and r.tare_esta = 'A'
       and not exists (select 1
              from come_movi m
              join come_tipo_movi t
                on m.movi_timo_codi = t.timo_codi
             where t.timo_tico_codi = 5
               and m.movi_nume = s.aumo_nume)
       and not exists (select 1
              from come_movi_anul a
              join come_tipo_movi t
                on a.anul_timo_codi = t.timo_codi
             where t.timo_tico_codi = 5
               and a.anul_nume = s.aumo_nume)
     order by 1;
  
  exception
    when others then
      RAISE_APPLICATION_eRROR(-20001,
                              sqlerrm || ' ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  end pp_veri_nume_libr;
  procedure pp_veri_fech_rend_comp(p_movi_tare_codi in number) is
    cursor c_comp_pend is
      select round(trunc(resa_fech_rend) - trunc(sysdate)) saldo_dias,
             resa_nume_comp
        from come_reci_salt_auto
       where resa_tare_codi = p_movi_tare_codi
         and resa_esta = 'A';
  begin
    for r in c_comp_pend loop
      if r.saldo_dias < 0 then
        raise_application_error(-20001,
                                'Existe(n) comprobante(s) que aun no fue(ron) rendido(s). Se debe modificar fecha en que se rendira cuenta.');
      end if;
    end loop;
  end pp_veri_fech_rend_comp;
  procedure pp_vali_nume_comp(p_movi_tare_codi in varchar2,
                              p_movi_tico_codi in varchar2,
                              p_indi_rend_comp in varchar2,
                              p_movi_nume      in out varchar2) is
    v_nume_comp number;
    v_nume_libr number;
    v_count     number;
    salir       exception;
  begin
  
    if p_indi_rend_comp = 'N' then
    
      begin
        select tare_reci_desd
          into v_nume_comp
          from come_talo_reci
         where tare_codi = p_movi_tare_codi;
        i020007.pp_veri_nume_libr(p_movi_tare_codi, v_nume_libr);
        if nvl(v_nume_libr, -1) <> -1 then
          p_movi_nume := v_nume_libr;
          v_nume_comp := v_nume_libr;
        end if;
      
        i020007.pp_veri_nume_libr(p_movi_tare_codi, v_nume_libr);
        if p_movi_nume <> v_nume_comp then
          p_movi_nume := v_nume_comp;
        end if;
      
        --verificar si ese numero ya fue rendido o no.
        begin
          select count(*)
            into v_count
            from come_movi_anul, come_tipo_movi
           where anul_timo_codi = timo_codi
             and timo_tico_codi = p_movi_tico_codi
             and anul_nume = p_movi_nume;
          if v_count > 0 then
            raise_application_error(-20001,
                                    'El comprobante ya ha sido Anulado. Verifique el numero de comprobante. ' ||
                                    p_movi_nume);
          end if;
          select count(*)
            into v_count
            from come_movi m, come_tipo_movi t
           where m.movi_timo_codi = t.timo_codi
             and t.timo_tico_codi = 5
             and m.movi_nume = p_movi_nume;
        
          if v_count > 0 then
            raise_application_error(-20001,
                                    'El comprobante ya ha sido rendido. Verifique el numero de comprobante. f ' ||
                                    p_movi_nume);
          end if;
        
        end;
        --comparar fechas
        begin
          --verificamos si las fechas a rendir comprobantes estan vigentes o no.
          if p_indi_rend_comp = 'N' then
            i020007.pp_veri_fech_rend_comp(p_movi_tare_codi);
          end if;
        end;
      end;
      i020007.pp_veri_nume_libr(p_movi_tare_codi, v_nume_comp);
    
      if nvl(v_nume_comp, -1) <> -1 then
        p_movi_nume := v_nume_comp;
      end if;
      i020007.pp_vali_nume_libr(p_movi_tare_codi, p_movi_nume);
    end if;
    --raise_application_error(-20001,v_nume_libr);
  end pp_vali_nume_comp;
  procedure pp_vali_nume_libr(p_movi_tare_codi in number,
                              p_movi_nume      in out number) is
    v_nume      number;
    v_nume_hast number;
    v_indi      varchar2(1);
  begin
    v_indi := 'N';
    v_nume := p_movi_nume;
    begin
      select m.movi_nume
        into v_nume
        from come_movi m, come_tipo_movi t, come_talo_reci r
       where m.movi_timo_codi = t.timo_codi
         and r.tare_codi = p_movi_tare_codi
         and t.timo_tico_codi = 5
         and m.movi_nume >= r.tare_reci_desd
         and m.movi_nume <= r.tare_reci_hast
         and m.movi_nume = v_nume;
      v_indi := 'S';
      v_nume := v_nume + 1;
    exception
      when no_data_found then
        null;
      when too_many_rows then
        v_indi := 'S';
        v_nume := v_nume + 1;
    end;
    begin
      select a.anul_nume
        into v_nume
        from come_movi_anul a, come_tipo_movi t, come_talo_reci r
       where a.anul_timo_codi = t.timo_codi
         and r.tare_codi = p_movi_tare_codi
         and t.timo_tico_codi = 5
         and a.anul_nume >= r.tare_reci_desd
         and a.anul_nume <= r.tare_reci_hast
         and a.anul_nume = v_nume;
      v_indi := 'S';
      v_nume := v_nume + 1;
    exception
      when no_data_found then
        null;
      when too_many_rows then
        v_indi := 'S';
        v_nume := v_nume + 1;
    end;
    begin
      select resa_nume_comp
        into v_nume
        from come_reci_salt_auto, come_talo_reci
       where resa_tare_codi = p_movi_tare_codi
         and resa_tare_codi = tare_codi
         and resa_esta = 'A'
         and resa_nume_comp = v_nume;
      v_indi := 'S';
      v_nume := v_nume + 1;
    exception
      when no_data_found then
        null;
      when too_many_rows then
        v_indi := 'S';
        v_nume := v_nume + 1;
    end;
    begin
      select r.tare_reci_hast
        into v_nume_hast
        from come_talo_reci r
       where r.tare_codi = p_movi_tare_codi;
    exception
      when no_data_found then
        null;
    end;
  
    if v_nume > v_nume_hast then
      raise_application_error(-20001,
                              'Ya no quedan numeros libres en el talonario');
    end if;
    while v_indi = 'S' loop
      v_indi := 'N';
      begin
        select m.movi_nume
          into v_nume
          from come_movi m, come_tipo_movi t, come_talo_reci r
         where m.movi_timo_codi = t.timo_codi
           and r.tare_codi = p_movi_tare_codi
           and t.timo_tico_codi = 5
           and m.movi_nume >= r.tare_reci_desd
           and m.movi_nume <= r.tare_reci_hast
           and m.movi_nume = v_nume;
        v_indi := 'S';
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          null;
        when too_many_rows then
          v_indi := 'S';
          v_nume := v_nume + 1;
      end;
      begin
        select a.anul_nume
          into v_nume
          from come_movi_anul a, come_tipo_movi t, come_talo_reci r
         where a.anul_timo_codi = t.timo_codi
           and r.tare_codi = p_movi_tare_codi
           and t.timo_tico_codi = 5
           and a.anul_nume >= r.tare_reci_desd
           and a.anul_nume <= r.tare_reci_hast
           and a.anul_nume = v_nume;
        v_indi := 'S';
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          null;
        when too_many_rows then
          v_indi := 'S';
          v_nume := v_nume + 1;
      end;
      begin
        select resa_nume_comp
          into v_nume
          from come_reci_salt_auto, come_talo_reci
         where resa_tare_codi = p_movi_tare_codi
           and resa_tare_codi = tare_codi
           and resa_esta = 'A'
           and resa_nume_comp = v_nume;
        v_indi := 'S';
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          null;
        when too_many_rows then
          v_indi := 'S';
          v_nume := v_nume + 1;
      end;
      if v_nume > v_nume_hast then
        v_indi := 'X';
      end if;
    end loop;
    if v_indi = 'X' then
      raise_application_error(-20001,
                              'Ya no quedan numeros libres en el talonario');
    end if;
    p_movi_nume := v_nume;
  end pp_vali_nume_libr;
  procedure pp_vali_nume_dupl_prov(p_movi_nume      in number,
                                   p_movi_clpr_codi in number,
                                   p_codi_timo      in number) is
    v_count number;
    v_nume  number;
  begin
    v_nume := p_movi_nume;
    select count(*)
      into v_count
      from come_movi
     where movi_nume = v_nume
       and movi_timo_codi = p_codi_timo
       and movi_clpr_codi = p_movi_clpr_codi;
    if v_count > 0 then
      raise_application_error(-20001,
                              'Nro documento existente, favor verifique. ');
    end if;
  end pp_vali_nume_dupl_prov;
  procedure pp_vali_nume_dupl(p_movi_nume in number, p_codi_timo in number) is
    v_count number;
  begin
    select count(*)
      into v_count
      from come_movi
     where movi_nume = p_movi_nume
       and movi_timo_codi = p_codi_timo;
    if v_count > 0 then
      raise_application_error(-20001,
                              'Nro documento existente, favor verifique..');
    end if;
  end pp_vali_nume_dupl;
  procedure pp_validar_nro_recibo(p_emit_reci                in varchar2,
                                  p_movi_tare_codi           in number,
                                  p_movi_tico_codi           in number,
                                  p_movi_clpr_codi           in number,
                                  p_codi_timo                in number,
                                  p_peco_codi                in number,
                                  p_movi_timo_codi           in number,
                                  p_tico_indi_vali_nume      in varchar2,
                                  p_indi_cont_corr_talo_reci in varchar2,
                                  p_indi_rend_comp           in varchar2,
                                  p_movi_nume                in out number) is
  begin
  
    if p_emit_reci = 'E' then
      if p_movi_nume is null then
        pp_carga_secu(p_movi_nume);
      end if;
    end if;
  
    if p_movi_nume is null then
      raise_application_error(-20001,
                              'Debe introducir el nro. de recibo!.');
    else
      if parameter.p_para_inic = 'C' then
        if p_indi_cont_corr_talo_reci = 'S' then
        
          --verificar que sea el ultimo mas uno
          i020007.pp_vali_nume_comp(p_movi_tare_codi,
                                    p_movi_tico_codi,
                                    p_indi_rend_comp,
                                    p_movi_nume);
        end if;
      
        declare
          v_count number;
        begin
          select count(*)
            into v_count
            from come_movi_anul, come_tipo_movi
           where anul_timo_codi = timo_codi
             and timo_tico_codi = p_movi_tico_codi
             and anul_nume = p_movi_nume;
          if v_count > 0 then
            raise_application_error(-20001,
                                    'El comprobante ya ha sido Anulado. Verifique el numero de comprobante. ' ||
                                    p_movi_nume);
          end if;
        end;
      end if;
    end if;
  
    -- verifica duplicacion de documentos.
    if p_tico_indi_vali_nume = 'S' then
      if parameter.p_codi_timo_rere = p_movi_timo_codi then
        i020007.pp_vali_nume_dupl_prov(p_movi_nume,
                                       p_movi_clpr_codi,
                                       p_codi_timo);
      else
        i020007.pp_vali_nume_dupl(p_movi_nume, p_codi_timo);
      end if;
    end if;
  
    --verificar que sea el ultimo mas uno
  
    if nvl(v('p10_ind_mens_tal'), 'N') = 'N' then
      i020007.pp_veri_nume_comp(p_movi_nume);
      -- else
      --    p_movi_nume:=null;
    end if;
  
  end pp_validar_nro_recibo;
  procedure pp_validar_moneda(p_movi_timo_codi      in number,
                              p_tica_codi           in number,
                              p_movi_mone_codi      in number,
                              p_movi_fech_emis      in varchar2,
                              p_tica_desc           out varchar2,
                              p_movi_mone_desc      out varchar2,
                              p_movi_mone_desc_abre out varchar2,
                              p_movi_mone_cant_deci out number,
                              p_movi_mone_codi_f9   out number) is
  begin
    if p_movi_timo_codi is not null then
      if p_tica_codi is not null then
        pp_muestra_tipo_camb(p_tica_codi, p_tica_desc);
      else
        raise_application_error(-20001,
                                'Debe asignar un tipo de cambio al tipo de Movimiento');
      end if;
    end if;
    pp_muestra_come_mone(p_movi_mone_codi,
                         p_movi_mone_desc,
                         p_movi_mone_desc_abre,
                         p_movi_mone_cant_deci);
  
    p_movi_mone_codi_f9 := p_movi_mone_codi;
    /* pp_busca_tasa_mone(p_movi_mone_codi,
    p_movi_fech_emis,
    p_movi_tasa_mone,
    p_tica_codi);*/
  end pp_validar_moneda;
  procedure pp_muestra_tipo_camb(p_tica_codi in number,
                                 p_tica_desc out varchar2) is
  begin
    select tica_desc
      into p_tica_desc
      from come_tipo_camb
     where tica_codi = p_tica_codi;
  exception
    when no_data_found then
      raise_application_error(-20001, 'Tipo de cambio no encontrado!!');
    when others then
      raise_application_error(-20001,
                              'Error en pp_muestra_tipo_camb ' || sqlerrm);
  end pp_muestra_tipo_camb;
  procedure pp_muestra_come_mone(p_mone_codi      in number,
                                 p_mone_desc      out varchar2,
                                 p_mone_desc_abre out varchar2,
                                 p_mone_cant_deci out number) is
  begin
    select mone_desc, mone_desc_abre, mone_cant_deci
      into p_mone_desc, p_mone_desc_abre, p_mone_cant_deci
      from come_mone g
     where mone_codi = p_mone_codi;
  exception
    when others then
      raise_application_error(-20001,
                              'Error en pp_muestra_come_mone ' || sqlerrm);
  end pp_muestra_come_mone;
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
      /*raise_application_error(-20001,
      'Cotizacion Inexistente para la fecha del documento.');*/
    when others then
      raise_application_error(-20001,
                              'Error en pp_busca_tasa_mone' || sqlerrm);
  end pp_busca_tasa_mone;
  procedure pp_validar_tot_pag(p_indi_digi_impo      in varchar,
                               p_movi_exen_mone_tota in number,
                               p_impo_rete           in number,
                               p_movi_tasa_mone      in number,
                               p_movi_exen_mone      in number,
                               p_dife                out number) is
    v_impo_mmnn     number;
    v_sum_impo_pago number;
  
  begin
  
    select sum(c022) impo_pago
    
      into v_sum_impo_pago
      from apex_collections a
     where collection_name = 'BDETALLE'
       and c001 = 'X';
    /*if nvl(p_indi_digi_impo, 'S') = 'S' then
      /* if nvl(p_movi_exen_mone_tota, 0) <= 0 then
        raise_application_error(-20001,
                                'Debe ingresar el total de importe a pagar.');
      end if;
      null;
    else
      if nvl(p_movi_exen_mone_tota, 0) <= 0 then
        p_movi_exen_mone_tota := null;
        p_movi_exen_mone      := null;
      end if;
    end if;*/
  
    v_impo_mmnn := round((nvl(p_movi_exen_mone_tota, 0) -
                         nvl(p_impo_rete, 0)) * p_movi_tasa_mone,
                         parameter.p_cant_deci_mmnn);
    setitem('P10_MOVI_EXEN_MMNN', v_impo_mmnn);
    if not nvl(p_movi_exen_mone_tota, 0) < 0 then
    
      if (nvl(p_indi_digi_impo, 'N') = 'S') then
        p_dife := nvl(nvl(p_movi_exen_mone_tota, 0),
                      nvl(p_movi_exen_mone, 0)) -
                  (nvl(v_sum_impo_pago, 0) +
                   nvl(v('P10_CABE_INTE_MORA_PUNI_COBR'), 0));
        -- raise_application_error(-20001,  p_dife);
        if p_dife < 0 then
          p_dife := null;
        end if;
      else
        p_dife := p_dife;
      end if;
    else
      --  p_movi_exen_mone_tota := 0;
      p_dife := 0;
    end if;
  end pp_validar_tot_pag;
  procedure pp_calcular_interes(p_cuot_fech_venc           in date,
                                p_cuot_sald_mone           in number,
                                p_movi_mone_cant_deci      in number,
                                p_porc_inte_clie_atra      in number,
                                p_porc_inte_clie_atra_puni in number,
                                p_impo_inte_mora_orig      out number,
                                p_impo_inte_puni_orig      out number,
                                p_movi_fech_emis           in date) is
    v_dias_atra number;
  
  begin
    v_dias_atra := to_date(p_movi_fech_emis, 'dd-mm-yyyy') -
                   to_date(p_cuot_fech_venc, 'dd-mm-yyyy');
    if v_dias_atra > nvl(parameter.p_dias_grac_clie, 0) then
      p_impo_inte_mora_orig := round((p_cuot_sald_mone *
                                     nvl(p_porc_inte_clie_atra, 0) / 100 *
                                     v_dias_atra),
                                     p_movi_mone_cant_deci);
      p_impo_inte_puni_orig := round((p_impo_inte_mora_orig *
                                     nvl(p_porc_inte_clie_atra_puni, 0) / 100),
                                     p_movi_mone_cant_deci);
    else
      p_impo_inte_mora_orig := 0;
      p_impo_inte_puni_orig := 0;
    end if;
  end pp_calcular_interes;
  procedure pp_calcular_gast_admi(p_cuot_fech_venc           in date,
                                  p_cuot_sald_mmnn           in number,
                                  p_movi_mone_codi           in number,
                                  p_movi_tasa_mone           in number,
                                  p_movi_mone_cant_deci      in number,
                                  p_impo_inte_gast_admi_orig out number,
                                  p_impo_inte_gast_admi      out number) is
    v_dias_atra      number;
    v_impo_gast_admi number;
  begin
    v_dias_atra := to_date(sysdate, 'dd/mm/yyyy') -
                   to_date(p_cuot_fech_venc, 'dd/mm/yyyy');
    if v_dias_atra > nvl(parameter.p_dias_grac_clie, 0) then
      select m.gaad_impo
        into v_impo_gast_admi
        from come_matr_gast_admi      m,
             come_matr_gast_admi_atra ma,
             come_matr_gast_admi_impo mi
       where m.gaad_gaat_codi = ma.gaat_codi
         and m.gaad_gaim_codi = mi.gaim_codi
         and v_dias_atra between ma.gaat_dias_desd and ma.gaat_dias_hast
         and p_cuot_sald_mmnn between mi.gaim_impo_desd and
             mi.gaim_impo_hast;
      if p_movi_mone_codi = 1 then
        --gs
        p_impo_inte_gast_admi_orig := v_impo_gast_admi;
      else
        --si es en moneda extranjera se realiza la conversi?n
        p_impo_inte_gast_admi_orig := round(v_impo_gast_admi /
                                            nvl(p_movi_tasa_mone, 1),
                                            nvl(p_movi_mone_cant_deci, 0));
      end if;
    else
      p_impo_inte_gast_admi_orig := 0;
    end if;
  exception
    when no_data_found then
      p_impo_inte_gast_admi      := 0;
      p_impo_inte_gast_admi_orig := p_impo_inte_gast_admi;
  end pp_calcular_gast_admi;
  procedure pp_cargar_bloque_det(p_indi_orde_venc_movi      in varchar2,
                                 p_emit_reci                in varchar2,
                                 p_sucu_nume_item           in number,
                                 p_movi_mone_codi           in number,
                                 p_movi_clpr_codi           in number,
                                 p_movi_fech_emis           in date,
                                 p_para_inic                in varchar2,
                                 p_indi_inte_cobr_app       in varchar2,
                                 p_movi_mone_cant_deci      in number,
                                 p_indi_gast_admi_cobr      in varchar2,
                                 p_movi_tasa_mone           in number,
                                 p_porc_inte_clie_atra      in number,
                                 p_porc_inte_clie_atra_puni in number,
                                 p_movi_exen_mone           out number) is
    cursor c_vto1 is
      select orte_desc,
             movi_mone_codi,
             movi_nume,
             movi_fech_emis,
             cuot_fech_venc,
             cuot_impo_mone,
             cuot_sald_mone,
             cuot_sald_mmnn,
             movi_codi,
             cuot_movi_codi,
             movi_tasa_mone,
             cuot_tasa_dife_camb,
             clpr_codi,
             clpr_codi_alte,
             decode(nvl(t.timo_calc_iva, 'N'),
                    'S',
                    movi_grav_mone,
                    round(((movi_exen_mone - nvl(movi_impo_reca, 0)) / 1.1),
                          mone_cant_deci)) movi_grav_mone,
             decode(nvl(t.timo_calc_iva, 'N'),
                    'S',
                    movi_grav_mmnn,
                    round((movi_exen_mmnn - (round(nvl(movi_impo_reca, 0) *
                                                   nvl(movi_tasa_mone, 1),
                                                   0))) / 1.1,
                          mone_cant_deci)) movi_grav_mmnn,
             decode(nvl(t.timo_calc_iva, 'N'),
                    'S',
                    movi_iva_mone,
                    round((movi_exen_mone - nvl(movi_impo_reca, 0)) / 11,
                          mone_cant_deci)) movi_iva_mone,
             round((decode(nvl(t.timo_calc_iva, 'N'),
                           'S',
                           movi_grav_mmnn,
                           round((movi_exen_mmnn - (nvl(movi_impo_reca, 0))) / 1.1,
                                 0)) * 10 / 100),
                   mone_cant_deci) movi_iva_mmnn,
             movi_codi_rete,
             nvl(cuot_nume_desc, ltrim(to_char(cuot_nume))) cuot_nume_desc
        from come_movi,
             come_movi_cuot,
             come_tipo_movi t,
             come_clie_prov,
             come_mone,
             come_orde_term
       where movi_codi = cuot_movi_codi
         and movi_orte_codi = orte_codi(+)
         and movi_mone_codi = mone_codi
         and movi_timo_codi = timo_codi
         and movi_clpr_codi = clpr_codi
         and movi_clpr_codi = p_movi_clpr_codi
         and cuot_sald_mone > 0
         and movi_mone_codi = p_movi_mone_codi
         and ((p_sucu_nume_item is null) or
             (p_sucu_nume_item is not null and
             p_sucu_nume_item = movi_clpr_sucu_nume_item) or
             (p_sucu_nume_item = 0 and movi_clpr_sucu_nume_item is null))
         and movi_dbcr = decode(p_emit_reci, 'E', 'D', 'R', 'C')
       order by cuot_fech_venc, movi_fech_emis, movi_nume;
    cursor c_vto2 is
      select orte_desc,
             movi_mone_codi,
             movi_nume,
             movi_fech_emis,
             cuot_fech_venc,
             cuot_impo_mone,
             cuot_sald_mone,
             cuot_sald_mmnn,
             movi_codi,
             cuot_movi_codi,
             movi_tasa_mone,
             cuot_tasa_dife_camb,
             clpr_codi,
             clpr_codi_alte,
             decode(nvl(t.timo_calc_iva, 'N'),
                    'S',
                    movi_grav_mone,
                    round(((movi_exen_mone - nvl(movi_impo_reca, 0)) / 1.1),
                          mone_cant_deci)) movi_grav_mone,
             decode(nvl(t.timo_calc_iva, 'N'),
                    'S',
                    movi_grav_mmnn,
                    round((movi_exen_mmnn - (round(nvl(movi_impo_reca, 0) *
                                                   nvl(movi_tasa_mone, 1),
                                                   0))) / 1.1,
                          mone_cant_deci)) movi_grav_mmnn,
             decode(nvl(t.timo_calc_iva, 'N'),
                    'S',
                    movi_iva_mone,
                    round((movi_exen_mone - nvl(movi_impo_reca, 0)) / 11,
                          mone_cant_deci)) movi_iva_mone,
             round((decode(nvl(t.timo_calc_iva, 'N'),
                           'S',
                           movi_grav_mmnn,
                           round((movi_exen_mmnn - (nvl(movi_impo_reca, 0))) / 1.1,
                                 0)) * 10 / 100),
                   mone_cant_deci) movi_iva_mmnn,
             movi_codi_rete,
             nvl(cuot_nume_desc, ltrim(to_char(cuot_nume))) cuot_nume_desc
        from come_movi,
             come_movi_cuot,
             come_tipo_movi t,
             come_clie_prov,
             come_mone,
             come_orde_term
       where movi_codi = cuot_movi_codi
         and movi_orte_codi = orte_codi(+)
         and movi_mone_codi = mone_codi
         and movi_timo_codi = timo_codi
         and movi_clpr_codi = clpr_codi
         and movi_clpr_codi = p_movi_clpr_codi
         and cuot_sald_mone > 0
         and movi_mone_codi = p_movi_mone_codi
         and ((p_sucu_nume_item is null) or
             (p_sucu_nume_item is not null and
             p_sucu_nume_item = movi_clpr_sucu_nume_item) or
             (p_sucu_nume_item = 0 and movi_clpr_sucu_nume_item is null))
         and movi_dbcr = decode(p_emit_reci, 'E', 'D', 'R', 'C')
       order by movi_nume, cuot_fech_venc, movi_fech_emis;
    cursor c_dica(p_movi_codi in number, p_fech_venc in date) is
      select dica_tasa
        from come_movi_dife_camb
       where dica_movi_codi = p_movi_codi
         and dica_fech_venc = p_fech_venc
         and dica_fech_hasta <= p_movi_fech_emis
       order by dica_fech_hasta desc;
    v_cuot_tasa_mone           number;
    v_impo_inte_mora_puni_orig number;
    v_impo_inte_mora_orig      number;
    v_impo_inte_puni_orig      number;
    v_impo_inte_gast_admi_orig number;
    v_impo_inte_gast_admi      number;
    v_impo_mora                number := 0;
    v_impo_inte                number := 0;
    v_impo_gaad                number := 0;
  begin
    p_movi_exen_mone := null;
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
    if p_indi_orde_venc_movi = 'V' then
      for x in c_vto1 loop
        v_cuot_tasa_mone := null;
        for i in c_dica(x.cuot_movi_codi, x.cuot_fech_venc) loop
          v_cuot_tasa_mone := i.dica_tasa;
          exit;
        end loop;
        if v_cuot_tasa_mone is null then
          v_cuot_tasa_mone := x.movi_tasa_mone;
        end if;
      
        begin
          select sum(ca.canc_impo_inte_mora_cobr),
                 sum(ca.canc_impo_inte_puni_cobr),
                 sum(ca.canc_impo_gast_admi_cobr)
            into v_impo_mora, v_impo_inte, v_impo_gaad
            from come_movi_cuot_canc ca
           where ca.canc_cuot_movi_codi = X.CUOT_MOVI_CODI
             and ca.canc_cuot_fech_venc = X.CUOT_FECH_VENC
             and ca.canc_tipo = 'C'
             and ca.canc_indi_afec_sald = 'N'; ---interes/gasto admin
        end;
      
        if p_para_inic = 'C' and nvl(p_indi_inte_cobr_app, 'N') = 'S' then
          begin
            i020007.pp_calcular_interes(x.cuot_fech_venc,
                                        x.cuot_impo_mone, --x.cuot_sald_mone,
                                        p_movi_mone_cant_deci,
                                        p_porc_inte_clie_atra,
                                        p_porc_inte_clie_atra_puni,
                                        v_impo_inte_mora_orig,
                                        v_impo_inte_puni_orig,
                                        p_movi_fech_emis);
            --raise_application_Error(-20001,v_impo_inte||' -FF '||v_impo_inte_puni_orig||'..'||v_impo_inte);
          
            -- raise_application_Error(-20001,X.CUOT_MOVI_CODI||'-'|| X.CUOT_FECH_VENC||' -FF '||v_impo_inte_puni_orig||'..'||v_impo_inte);
            v_impo_inte_mora_orig := ABS(nvl(v_impo_inte_mora_orig, 0) -
                                         nvl(v_impo_mora, 0));
            v_impo_inte_puni_orig := ABS(nvl(v_impo_inte_puni_orig, 0) -
                                         nvl(v_impo_inte, 0));
            --raise_application_Error(-20001,v_impo_inte||' -FF '||v_impo_inte_puni_orig||'..'||v_impo_inte);
          
          end;
        end if;
        if p_para_inic = 'C' and nvl(p_indi_gast_admi_cobr, 'N') = 'S' then
          i020007.pp_calcular_gast_admi(x.cuot_fech_venc,
                                        x.cuot_impo_mone, --x.cuot_sald_mmnn,
                                        p_movi_mone_codi,
                                        p_movi_tasa_mone,
                                        p_movi_mone_cant_deci,
                                        v_impo_inte_gast_admi_orig,
                                        v_impo_inte_gast_admi);
        
          v_impo_inte_gast_admi_orig := ABS(nvl(v_impo_inte_gast_admi_orig,
                                                0) - nvl(v_impo_gaad, 0));
          v_impo_inte_gast_admi      := ABS(nvl(v_impo_inte_gast_admi, 0) -
                                            nvl(v_impo_gaad, 0));
        
          /*IF v_impo_inte_gast_admi < 0 THEN
          v_impo_inte_gast_admi_orig:=0;
          v_impo_inte_gast_admi:=0;
          END IF;*/
        
        end if;
      
        v_impo_inte_mora_puni_orig := nvl(v_impo_inte_mora_orig, 0) +
                                      nvl(v_impo_inte_puni_orig, 0) +
                                      nvl(v_impo_inte_gast_admi_orig, 0);
      
        apex_collection.add_member(p_collection_name => 'BDETALLE',
                                   p_c001            => null, ---ind_marcado
                                   p_c002            => x.movi_nume,
                                   p_c003            => x.movi_mone_codi,
                                   p_c004            => x.movi_fech_emis,
                                   p_c005            => x.cuot_nume_desc,
                                   p_c006            => x.cuot_fech_venc,
                                   p_c007            => x.cuot_sald_mone,
                                   p_c008            => x.cuot_sald_mmnn,
                                   p_c009            => x.movi_codi,
                                   p_c010            => v_cuot_tasa_mone,
                                   p_c011            => x.clpr_codi,
                                   p_c012            => x.clpr_codi_alte,
                                   p_c013            => x.movi_iva_mone,
                                   p_c014            => x.movi_codi_rete,
                                   p_c015            => x.orte_desc,
                                   p_c016            => v_impo_inte_mora_puni_orig,
                                   p_c017            => v_impo_inte_mora_orig,
                                   p_c018            => v_impo_inte_puni_orig,
                                   p_c019            => v_impo_inte_gast_admi_orig,
                                   p_c020            => v_impo_inte_gast_admi,
                                   p_c021            => x.cuot_impo_mone,
                                   p_c022            => null,
                                   p_c023            => 0,
                                   p_c024            => 0,
                                   p_c025            => 0,
                                   p_c026            => 0,
                                   p_c027            => 0,
                                   p_c028            => 0,
                                   p_c029            => 0,
                                   p_c030            => 0,
                                   p_c031            => 0);
      
        v_impo_mora := 0;
        v_impo_inte := 0;
        v_impo_gaad := 0;
      end loop;
    elsif p_indi_orde_venc_movi = 'M' then
      for x in c_vto2 loop
        v_cuot_tasa_mone := null;
        for i in c_dica(x.cuot_movi_codi, x.cuot_fech_venc) loop
          v_cuot_tasa_mone := i.dica_tasa;
          exit;
        end loop;
        if v_cuot_tasa_mone is null then
          v_cuot_tasa_mone := x.movi_tasa_mone;
        end if;
        begin
          select sum(ca.canc_impo_inte_mora_cobr),
                 sum(ca.canc_impo_inte_puni_cobr),
                 sum(ca.canc_impo_gast_admi_cobr)
            into v_impo_mora, v_impo_inte, v_impo_gaad
            from come_movi_cuot_canc ca
           where ca.canc_cuot_movi_codi = X.CUOT_MOVI_CODI
             and ca.canc_cuot_fech_venc = X.CUOT_FECH_VENC
             and ca.canc_tipo = 'C'
             and ca.canc_indi_afec_sald = 'N'; ---interes/gasto admin
        end;
        if p_para_inic = 'C' and nvl(p_indi_inte_cobr_app, 'N') = 'S' then
          i020007.pp_calcular_interes(x.cuot_fech_venc,
                                      x.cuot_impo_mone, --x.cuot_sald_mone,
                                      p_movi_mone_cant_deci,
                                      p_porc_inte_clie_atra,
                                      p_porc_inte_clie_atra_puni,
                                      v_impo_inte_mora_orig,
                                      v_impo_inte_puni_orig,
                                      p_movi_fech_emis);
        
          v_impo_inte_mora_orig := ABS(nvl(v_impo_inte_mora_orig, 0) -
                                       nvl(v_impo_mora, 0));
          v_impo_inte_puni_orig := ABS(nvl(v_impo_inte_puni_orig, 0) -
                                       nvl(v_impo_inte, 0));
        end if;
        if p_para_inic = 'C' and nvl(p_indi_gast_admi_cobr, 'N') = 'S' then
          i020007.pp_calcular_gast_admi(x.cuot_fech_venc,
                                        x.cuot_impo_mone, --  x.cuot_sald_mmnn,
                                        p_movi_mone_codi,
                                        p_movi_tasa_mone,
                                        p_movi_mone_cant_deci,
                                        v_impo_inte_gast_admi_orig,
                                        v_impo_inte_gast_admi);
        
          v_impo_inte_gast_admi_orig := ABS(nvl(v_impo_inte_gast_admi_orig,
                                                0) - nvl(v_impo_gaad, 0));
          v_impo_inte_gast_admi      := ABS(nvl(v_impo_inte_gast_admi, 0) -
                                            nvl(v_impo_gaad, 0));
        end if;
        apex_collection.add_member(p_collection_name => 'BDETALLE',
                                   p_c001            => null, ---ind_marcado
                                   p_c002            => x.movi_nume,
                                   p_c003            => x.movi_mone_codi,
                                   p_c004            => x.movi_fech_emis,
                                   p_c005            => x.cuot_nume_desc,
                                   p_c006            => x.cuot_fech_venc,
                                   p_c007            => x.cuot_sald_mone,
                                   p_c008            => x.cuot_sald_mmnn,
                                   p_c009            => x.movi_codi,
                                   p_c010            => v_cuot_tasa_mone,
                                   p_c011            => x.clpr_codi,
                                   p_c012            => x.clpr_codi_alte,
                                   p_c013            => x.movi_iva_mone,
                                   p_c014            => x.movi_codi_rete,
                                   p_c015            => x.orte_desc,
                                   p_c016            => v_impo_inte_mora_puni_orig,
                                   p_c017            => v_impo_inte_mora_orig,
                                   p_c018            => v_impo_inte_puni_orig,
                                   p_c019            => v_impo_inte_gast_admi_orig,
                                   p_c020            => v_impo_inte_gast_admi,
                                   p_c021            => x.cuot_impo_mone,
                                   p_c022            => null,
                                   p_c023            => 0,
                                   p_c024            => 0);
      
        v_impo_mora := 0;
        v_impo_inte := 0;
        v_impo_gaad := 0;
      end loop;
    end if;
    declare
      v_count number;
    begin
      select count(c009) movi_codi
        into v_count
        from apex_collections a
       where collection_name = 'BDETALLE';
      if v_count = 0 then
        raise_application_error(-20001,
                                'El cliente no posee comprobantes pendientes!');
      end if;
    end;
  end pp_cargar_bloque_det;
  procedure pp_cargar_bloque_nota_adel(p_movi_empr_codi in number,
                                       p_movi_clpr_codi in number,
                                       p_sucu_nume_item in number,
                                       p_emit_reci      in varchar2) is
    cursor c_moneda is
      select sum(cuot_sald_mone) cuot_impo_mone,
             mone_codi,
             mone_desc,
             mone_desc_abre
        from come_movi, come_movi_cuot, come_tipo_movi, come_mone m
       where movi_codi = cuot_movi_codi
         and movi_mone_codi = m.mone_codi
         and movi_clpr_codi = p_movi_clpr_codi
         and timo_codi = movi_timo_codi
         and cuot_sald_mone > 0
         and ((p_sucu_nume_item is null) or
             (p_sucu_nume_item is not null and
             p_sucu_nume_item = movi_clpr_sucu_nume_item) or
             (p_sucu_nume_item = 0 and movi_clpr_sucu_nume_item is null))
         and movi_dbcr = decode(p_emit_reci, 'E', 'C', 'R', 'D')
         and nvl(movi_empr_codi, 1) = p_movi_empr_codi
       group by mone_codi, mone_desc, mone_desc_abre;
    v_count number := 0;
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDET_NOTA_ADEL');
    for x in c_moneda loop
      apex_collection.add_member(p_collection_name => 'BDET_NOTA_ADEL',
                                 p_c002            => x.mone_codi,
                                 p_c003            => x.mone_desc,
                                 p_c004            => x.cuot_impo_mone);
      v_count := v_count + 1;
    end loop;
    if v_count = 0 then
      apex_collection.add_member(p_collection_name => 'BDET_NOTA_ADEL',
                                 p_c002            => null,
                                 p_c003            => null,
                                 p_c004            => null);
    end if;
  exception
    when others then
      raise_application_error(-20001,
                              'Error en pp_cargar_bloque_nota_adel ' ||
                              sqlerrm);
  end pp_cargar_bloque_nota_adel;
  procedure pp_ejecutar_consulta(p_indi_orde_venc_movi      in varchar2,
                                 p_emit_reci                in varchar2,
                                 p_sucu_nume_item           in number,
                                 p_movi_mone_codi           in number,
                                 p_movi_clpr_codi           in number,
                                 p_movi_fech_emis           in date,
                                 p_para_inic                in varchar2,
                                 p_indi_inte_cobr_app       in varchar2,
                                 p_movi_mone_cant_deci      in number,
                                 p_indi_gast_admi_cobr      in varchar2,
                                 p_movi_tasa_mone           in number,
                                 p_movi_exen_mone           out number,
                                 p_movi_empr_codi           in number,
                                 p_porc_inte_clie_atra      in number,
                                 p_porc_inte_clie_atra_puni in number,
                                 p_indi_form_pago           in varchar2) is
  begin
    if nvl(p_indi_form_pago, 'N') = 'N' then
      setitem('p10_indi_calc_inte', 'S');
      i020007.pp_cargar_bloque_det(p_indi_orde_venc_movi,
                                   p_emit_reci,
                                   p_sucu_nume_item,
                                   p_movi_mone_codi,
                                   p_movi_clpr_codi,
                                   p_movi_fech_emis,
                                   p_para_inic,
                                   p_indi_inte_cobr_app,
                                   p_movi_mone_cant_deci,
                                   p_indi_gast_admi_cobr,
                                   p_movi_tasa_mone,
                                   p_porc_inte_clie_atra,
                                   p_porc_inte_clie_atra_puni,
                                   p_movi_exen_mone);
      i020007.pp_cargar_bloque_nota_adel(p_movi_empr_codi,
                                         p_movi_clpr_codi,
                                         p_sucu_nume_item,
                                         p_emit_reci);
    else
      null;
    end if;
    if v('P10_TOTAL_IMPORTE') is not null then
      pp_carga_auto_impo_pago;
    end if;
  end pp_ejecutar_consulta;
  procedure pp_validar_imp_pago(p_imp_pago in number, p_seq in number) is
    v_cuot_sald_mone      number;
    v_gasto               number;
    v_impo_inte_mora      number;
    v_impo_inte_puni      number;
    v_impo_inte_gast_admi number;
    v_impo_pago           number;
    v_sum_inte_mora_adm   number;
    v_tota_importe        number := 0;
  begin
  
    begin
      select c007,
             c016 impo_inte_mora_puni_orig,
             c017 impo_inte_mora_orig,
             c018 impo_inte_puni_orig,
             c019 impo_inte_gast_admi_orig
        into v_cuot_sald_mone,
             v_gasto,
             v_impo_inte_mora,
             v_impo_inte_puni,
             v_impo_inte_gast_admi
        from apex_collections a
       where collection_name = 'BDETALLE'
         and seq_id = p_seq;
    exception
      when others then
        null;
    end;
    ---validar monto
    if p_imp_pago > (nvl(v_cuot_sald_mone, 0) + nvl(v_gasto, 0)) then
      v_tota_importe := nvl(v_cuot_sald_mone, 0) + nvl(v_gasto, 0);
    else
      v_tota_importe := p_imp_pago;
    end if;
  
    v_impo_pago := Nvl(v_tota_importe, 0);
  
    if nvl(v_tota_importe, 0) < 0 then
      raise_application_error(-20001,
                              'El importe de pago no puede ser menor a 0.');
    end if;
  
    -- raise_application_error(-20001,'hello marisa');
  
    ----calculo de importes      
  
    if NVL(parameter.p_indi_inte_cobr_app, 'N') = 'S' then
      if (NVL(v_tota_importe, 0) - NVL(v_gasto, 0)) <= 0 then
        -- Calcula el monto de inter?s punitario
        v_impo_inte_puni := LEAST(v_impo_pago, v_impo_inte_puni);
        v_impo_pago      := v_impo_pago - v_impo_inte_puni;
      
        -- Calcula el monto de inter?s por mora
        v_impo_inte_mora := LEAST(v_impo_pago, v_impo_inte_mora);
        v_impo_pago      := v_impo_pago - v_impo_inte_mora;
      
        -- Calcula el monto de gasto administrativo
        v_impo_inte_gast_admi := LEAST(v_impo_pago, v_impo_inte_gast_admi);
        v_impo_pago           := v_impo_pago - v_impo_inte_gast_admi;
      end if;
    end if;
  
    v_sum_inte_mora_adm := v_impo_inte_puni + v_impo_inte_mora +
                           v_impo_inte_gast_admi;
  
    pp_actualizar_member_coll(p_seq, 31, v_tota_importe);
  
    if ((Nvl(v_tota_importe, 0) - nvl(v_sum_inte_mora_adm, 0))) > 0 then
      v_impo_pago := ((Nvl(v_tota_importe, 0) - nvl(v_sum_inte_mora_adm, 0)));
    else
      v_impo_pago := 0;
    end if;
    ---se actualiza la collection de importe a pagar
    pp_actualizar_member_coll(p_seq, 22, v_impo_pago);
    ---se actualiza la collection de importe de los intereses y gasto administrativo..
    pp_actualizar_member_coll(p_seq, 28, v_impo_inte_puni);
    pp_actualizar_member_coll(p_seq, 29, v_impo_inte_mora);
    pp_actualizar_member_coll(p_seq, 27, v_impo_inte_gast_admi);
  
  end pp_validar_imp_pago;
  procedure pp_validar_retencion(p_emit_reci      in varchar2,
                                 p_empr_retentora in varchar2) is
  begin
    if nvl(p_emit_reci, 'R') = 'R' then
      if upper(nvl(p_empr_retentora, 'NO')) <> 'NO' then
        --pp_verif_aplic_reten;
        null;
      end if;
    end if;
  end pp_validar_retencion;
  procedure pp_calcular_importe_det(p_emit_reci           in varchar2,
                                    p_empr_retentora      in varchar2,
                                    p_clpr_prov_retener   in varchar2,
                                    p_s_calc_rete         in varchar2,
                                    p_movi_tasa_mone      in number,
                                    p_s_calc_rete_mini    in varchar2,
                                    p_movi_empr_codi      in number,
                                    p_movi_sucu_codi_orig in number,
                                    p_movi_mone_cant_deci in number) is
    v_impo_rete_mmnn number;
    v_impo_pago_mone number;
    v_impo_pago_mmnn number;
    v_impo_tota_mmnn number;
    v_apli_rete      varchar2(1);
  begin
    for i in c_bdetalle loop
      if nvl(p_emit_reci, 'R') = 'R' and
         upper(nvl(p_empr_retentora, 'NO')) <> 'NO' and
         nvl(p_clpr_prov_retener, 'SI') = 'SI' then
        if i.ind_marcado = 'X' or nvl(i.impo_pago_mone, 0) > 0 then
          if nvl(p_s_calc_rete, 'S') = 'N' then
            apex_collection.update_member_attribute(p_collection_name => 'BDETALLE',
                                                    p_seq             => i.seq_id,
                                                    p_attr_number     => 26,
                                                    p_attr_value      => 'N');
          
            v_apli_rete := 'N';
          elsif nvl(parameter.p_form_calc_rete_emit, 1) = 2 then
            --formula de calculo de retencion prorrateada
            apex_collection.update_member_attribute(p_collection_name => 'BDETALLE',
                                                    p_seq             => i.seq_id,
                                                    p_attr_number     => 26,
                                                    p_attr_value      => 'S');
            v_apli_rete := 'S';
          end if;
          v_impo_pago_mone := i.impo_pago_mone;
          v_impo_pago_mmnn := round((i.impo_pago_mone * p_movi_tasa_mone),
                                    parameter.p_cant_deci_mmnn);
          --:bdet.impo_pago_mmnn := v_impo_pago_mmnn; verificar
          --  v_impo_tota_mmnn     := round(i.sum_impo_pago_mmnn,parameter.p_cant_deci_mmnn); --verificar
          --pp_calcular_retencion;
          general_skn.pl_calc_rete(parameter.p_form_calc_rete_emit,
                                   p_movi_empr_codi,
                                   p_movi_sucu_codi_orig,
                                   i.movi_codi,
                                   v_apli_rete,
                                   v_impo_pago_mone,
                                   v_impo_pago_mmnn,
                                   v_impo_tota_mmnn,
                                   i.impo_rete_mone,
                                   v_impo_rete_mmnn,
                                   0, --:bdet.sum_impo_pago_mone,  --verificar
                                   0, --p_iva_mone  in number default 0,
                                   0, --p_iva_mmnn  in number default 0,
                                   p_movi_mone_cant_deci, --p_cant_deci in number default 0
                                   0,
                                   0,
                                   0,
                                   0,
                                   p_s_calc_rete_mini);
        else
          apex_collection.update_member_attribute(p_collection_name => 'BDETALLE',
                                                  p_seq             => i.seq_id,
                                                  p_attr_number     => 25,
                                                  p_attr_value      => 0);
        end if;
      end if;
      --p_s_impo_rete     := nvl(:bdet.sum_impo_rete_mone, 0);
    --:brete.movi_impo_rete := bcab.s_impo_rete;
    end loop;
  end pp_calcular_importe_det;
  procedure pp_valida_campo_marcado(p_tota_impo_inte_puni      out number,
                                    p_tota_impo_inte_gast_admi out number,
                                    p_tota_impo_inte_mora      out number) is
    v_count number := 0;
  begin
    select sum(c017) impo_inte_mora_orig,
           sum(c018) impo_inte_puni_orig,
           sum(c020) impo_inte_gast_admi,
           count(c002)
      into p_tota_impo_inte_puni,
           p_tota_impo_inte_mora,
           p_tota_impo_inte_gast_admi,
           v_count
      from apex_collections a
     where collection_name = 'BDETALLE'
       and c001 = 'X';
    if nvl(v_count, 0) = 0 then
      raise_application_error(-20001,
                              'No existe comprobante marcado para su cancelacion. Favor, seleccione el(los) documento(s) a cancelar.');
    end if;
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'No existe comprobante marcado para su cancelacion. Favor, seleccione el(los) documento(s) a cancelar.');
    when others then
      raise_application_error(-20001,
                              'Error en pp_valida_campo_marcado ' ||
                              sqlerrm);
  end pp_valida_campo_marcado;
  procedure pp_valida_clie_prov_cheq(p_movi_clpr_codi in number) is
    cursor c is
      select * from v_coll_form_pago f where f.fopa_codi in ('2', '4');
  begin
    for i in c loop
      if nvl(i.cheq_clpr_codi, -999) <> nvl(p_movi_clpr_codi, -888) then
        raise_application_error(-20001,
                                'El codigo del cliente/proveedor de la cabecera no coincide con el del detalle del cheque');
      end if;
    end loop;
  end pp_valida_clie_prov_cheq;
  procedure pp_valida_nume_cheq(p_cheq_nume      in char,
                                p_cheq_serie     in char,
                                p_cheq_banc_codi in number) is
    v_banc_desc varchar2(60);
  begin
    select banc_desc
      into v_banc_desc
      from come_cheq, come_banc
     where cheq_banc_codi = banc_codi
       and rtrim(ltrim(cheq_nume)) = rtrim(ltrim(p_cheq_nume))
       and rtrim(ltrim(cheq_serie)) = rtrim(ltrim(p_cheq_serie))
       and cheq_banc_codi = p_cheq_banc_codi;
    if general_skn.fl_busca_parametro('p_indi_vali_repe_cheq') = 'S' then
      raise_application_error(-20001,
                              'Atenci?n!!! Cheque existente... Numero' ||
                              p_cheq_nume || ' Serie' || p_cheq_serie ||
                              ' Banco ' || v_banc_desc);
    else
      raise_application_error(-20001,
                              'Atenci?n!!! Cheque existente... Numero' ||
                              p_cheq_nume || ' Serie' || p_cheq_serie ||
                              ' Banco ' || v_banc_desc);
    end if;
  exception
    when no_data_found then
      null;
    when too_many_rows then
      if general_skn.fl_busca_parametro('p_indi_vali_repe_cheq') = 'S' then
        raise_application_error(-20001,
                                'Atenci?n!!! Cheque existente... Numero' ||
                                p_cheq_nume || ' Serie' || p_cheq_serie ||
                                ' Banco ' || v_banc_desc);
      else
        raise_application_error(-20001,
                                'Atenci?n!!! Cheque existente... Numero' ||
                                p_cheq_nume || ' Serie' || p_cheq_serie ||
                                ' Banco ' || v_banc_desc);
      end if;
  end pp_valida_nume_cheq;
  procedure pp_insert_movi_conc_deta(p_moco_movi_codi      in number,
                                     p_moco_nume_item      in number,
                                     p_moco_conc_codi      in number,
                                     p_moco_cuco_codi      in number,
                                     p_moco_impu_codi      in number,
                                     p_moco_impo_mmnn      in number,
                                     p_moco_impo_mmee      in number,
                                     p_moco_impo_mone      in number,
                                     p_moco_dbcr           in char,
                                     p_moco_tiim_codi      in number,
                                     p_moco_impo_codi      in number,
                                     p_moco_ceco_codi      in number,
                                     p_moco_impo_mone_ii   in number,
                                     p_moco_impo_mmnn_ii   in number,
                                     p_moco_grav10_ii_mone in number,
                                     p_moco_grav5_ii_mone  in number,
                                     p_moco_grav10_ii_mmnn in number,
                                     p_moco_grav5_ii_mmnn  in number,
                                     p_moco_grav10_mone    in number,
                                     p_moco_grav5_mone     in number,
                                     p_moco_grav10_mmnn    in number,
                                     p_moco_grav5_mmnn     in number,
                                     p_moco_iva10_mone     in number,
                                     p_moco_iva5_mone      in number,
                                     p_moco_iva10_mmnn     in number,
                                     p_moco_iva5_mmnn      in number,
                                     p_moco_exen_mone      in number,
                                     p_moco_exen_mmnn      in number,
                                     p_moco_conc_codi_impu in number,
                                     p_moco_tipo           in varchar2,
                                     p_moco_indi_fact_serv in varchar2 default null,
                                     p_moco_cant           in number default null) is
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
       moco_impo_mone_ii,
       moco_impo_mmnn_ii,
       moco_grav10_ii_mone,
       moco_grav5_ii_mone,
       moco_grav10_ii_mmnn,
       moco_grav5_ii_mmnn,
       moco_grav10_mone,
       moco_grav5_mone,
       moco_grav10_mmnn,
       moco_grav5_mmnn,
       moco_iva10_mone,
       moco_iva5_mone,
       moco_iva10_mmnn,
       moco_iva5_mmnn,
       moco_exen_mone,
       moco_exen_mmnn,
       moco_conc_codi_impu,
       moco_tipo,
       moco_indi_fact_serv,
       moco_cant)
    values
      (p_moco_movi_codi,
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
       p_moco_impo_mone_ii,
       p_moco_impo_mmnn_ii,
       p_moco_grav10_ii_mone,
       p_moco_grav5_ii_mone,
       p_moco_grav10_ii_mmnn,
       p_moco_grav5_ii_mmnn,
       p_moco_grav10_mone,
       p_moco_grav5_mone,
       p_moco_grav10_mmnn,
       p_moco_grav5_mmnn,
       p_moco_iva10_mone,
       p_moco_iva5_mone,
       p_moco_iva10_mmnn,
       p_moco_iva5_mmnn,
       p_moco_exen_mone,
       p_moco_exen_mmnn,
       p_moco_conc_codi_impu,
       p_moco_tipo,
       decode(p_moco_indi_fact_serv, null, '', 'S'),
       decode(p_moco_cant, null, '', 1));
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_movi_conc_deta;
  procedure pp_insert_come_movi_impu_deta(p_moim_impu_codi      in number,
                                          p_moim_movi_codi      in number,
                                          p_moim_impo_mmnn      in number,
                                          p_moim_impo_mmee      in number,
                                          p_moim_impu_mmnn      in number,
                                          p_moim_impu_mmee      in number,
                                          p_moim_impo_mone      in number,
                                          p_moim_impu_mone      in number,
                                          p_moim_tiim_codi      in number,
                                          p_moim_impo_mone_ii   in number,
                                          p_moim_impo_mmnn_ii   in number,
                                          p_moim_grav10_ii_mone in number,
                                          p_moim_grav5_ii_mone  in number,
                                          p_moim_grav10_ii_mmnn in number,
                                          p_moim_grav5_ii_mmnn  in number,
                                          p_moim_grav10_mone    in number,
                                          p_moim_grav5_mone     in number,
                                          p_moim_grav10_mmnn    in number,
                                          p_moim_grav5_mmnn     in number,
                                          p_moim_iva10_mone     in number,
                                          p_moim_iva5_mone      in number,
                                          p_moim_iva10_mmnn     in number,
                                          p_moim_iva5_mmnn      in number,
                                          p_moim_exen_mone      in number,
                                          p_moim_exen_mmnn      in number) is
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
       moim_impo_mone_ii,
       moim_impo_mmnn_ii,
       moim_grav10_ii_mone,
       moim_grav5_ii_mone,
       moim_grav10_ii_mmnn,
       moim_grav5_ii_mmnn,
       moim_grav10_mone,
       moim_grav5_mone,
       moim_grav10_mmnn,
       moim_grav5_mmnn,
       moim_iva10_mone,
       moim_iva5_mone,
       moim_iva10_mmnn,
       moim_iva5_mmnn,
       moim_exen_mone,
       moim_exen_mmnn)
    values
      (p_moim_impu_codi,
       p_moim_movi_codi,
       p_moim_impo_mmnn,
       p_moim_impo_mmee,
       p_moim_impu_mmnn,
       p_moim_impu_mmee,
       p_moim_impo_mone,
       p_moim_impu_mone,
       p_moim_tiim_codi,
       p_moim_impo_mone_ii,
       p_moim_impo_mmnn_ii,
       p_moim_grav10_ii_mone,
       p_moim_grav5_ii_mone,
       p_moim_grav10_ii_mmnn,
       p_moim_grav5_ii_mmnn,
       p_moim_grav10_mone,
       p_moim_grav5_mone,
       p_moim_grav10_mmnn,
       p_moim_grav5_mmnn,
       p_moim_iva10_mone,
       p_moim_iva5_mone,
       p_moim_iva10_mmnn,
       p_moim_iva5_mmnn,
       p_moim_exen_mone,
       p_moim_exen_mmnn);
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end;
  procedure pp_insert_movi_impo_deta(p_moim_movi_codi      in number,
                                     p_moim_nume_item      in number,
                                     p_moim_tipo           in char,
                                     p_moim_cuen_codi      in number,
                                     p_moim_dbcr           in char,
                                     p_moim_afec_caja      in char,
                                     p_moim_fech           in date,
                                     p_moim_impo_mone      in number,
                                     p_moim_impo_mmnn      in number,
                                     p_moim_fech_oper      in date,
                                     p_moim_cheq_codi      in number,
                                     p_moim_tarj_cupo_codi in number,
                                     p_moim_movi_codi_vale in number,
                                     p_moim_viaj_codi      in number,
                                     p_moim_form_pago      in number,
                                     p_moim_impo_movi      in number,
                                     p_moim_tasa_mone      in number,
                                     p_moim_nume_bole_banc in varchar2) is
  begin
    insert into come_movi_impo_deta
      (moim_movi_codi,
       moim_nume_item,
       moim_tipo,
       moim_cuen_codi,
       moim_dbcr,
       moim_afec_caja,
       moim_fech,
       moim_impo_mone,
       moim_impo_mmnn,
       --moim_base       ,
       moim_fech_oper,
       moim_cheq_codi,
       moim_tarj_cupo_codi,
       moim_movi_codi_vale,
       moim_viaj_codi,
       moim_form_pago,
       moim_impo_movi,
       moim_tasa_mone,
       moim_nume_bole_banc)
    values
      (p_moim_movi_codi,
       p_moim_nume_item,
       p_moim_tipo,
       p_moim_cuen_codi,
       p_moim_dbcr,
       p_moim_afec_caja,
       p_moim_fech,
       p_moim_impo_mone,
       p_moim_impo_mmnn,
       -- :parameter.p_codi_base,
       p_moim_fech_oper,
       p_moim_cheq_codi,
       p_moim_tarj_cupo_codi,
       p_moim_movi_codi_vale,
       p_moim_viaj_codi,
       p_moim_form_pago,
       p_moim_impo_movi,
       p_moim_tasa_mone,
       p_moim_nume_bole_banc);
    if p_moim_form_pago in (1, 5) then
      update come_movi
         set movi_cuen_codi = p_moim_cuen_codi
       where movi_codi = p_moim_movi_codi;
    end if;
  end pp_insert_movi_impo_deta;
  procedure pp_actu_clie_exce(p_movi_clpr_indi_exce in varchar2,
                              p_movi_clpr_codi      in number,
                              p_clpr_indi_exce      in varchar2) is
  begin
    if nvl(p_movi_clpr_indi_exce, 'N') = 'S' then
      update come_clie_prov cp
         set cp.clpr_indi_exce = 'N'
       where cp.clpr_codi = p_movi_clpr_codi;
    end if;
    if nvl(p_clpr_indi_exce, 'N') = 'S' then
      update come_clie_prov cp
         set cp.clpr_indi_exce = 'N'
       where cp.clpr_codi = p_movi_clpr_codi;
    end if;
  end pp_actu_clie_exce;
  procedure pp_actu_secu_bole_fact_inte(p_movi_nume in number) is
  begin
    update come_secu
       set secu_nume_fact = p_movi_nume
     where secu_codi = (select f.user_secu_codi
                          from segu_user f
                         where user_login = fp_user);
    /* (select peco_secu_codi
     from come_pers_comp
    where peco_codi = p_peco_codi);*/
  end pp_actu_secu_bole_fact_inte;
  procedure pp_insert_come_movi_adel(p_movi_codi                in number,
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
                                     p_movi_clpr_situ           in number,
                                     p_movi_clpr_empl_codi_recl in number,
                                     p_movi_clpr_sucu_nume_item in number,
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
       -- movi_base                        ,
       movi_fech_oper,
       movi_clpr_situ,
       movi_clpr_empl_codi_recl,
       movi_clpr_sucu_nume_item,
       movi_empl_codi_agen)
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
       --:parameter.p_codi_base            ,
       p_movi_fech_oper,
       p_movi_clpr_situ,
       p_movi_clpr_empl_codi_recl,
       p_movi_clpr_sucu_nume_item,
       p_movi_empl_codi_agen);
  end;
  procedure pp_insert_come_movi_cuot_adel(p_cuot_fech_venc in date,
                                          p_cuot_nume      in number,
                                          p_cuot_impo_mone in number,
                                          p_cuot_impo_mmnn in number,
                                          p_cuot_impo_mmee in number,
                                          p_cuot_sald_mone in number,
                                          p_cuot_sald_mmnn in number,
                                          p_cuot_sald_mmee in number,
                                          p_cuot_movi_codi in number) is
  begin
    insert into come_movi_cuot
      (cuot_fech_venc,
       cuot_nume,
       cuot_impo_mone,
       cuot_impo_mmnn,
       cuot_impo_mmee,
       cuot_sald_mone,
       cuot_sald_mmnn,
       cuot_sald_mmee,
       cuot_movi_codi)
    values
      (p_cuot_fech_venc,
       p_cuot_nume,
       p_cuot_impo_mone,
       p_cuot_impo_mmnn,
       p_cuot_impo_mmee,
       p_cuot_sald_mone,
       p_cuot_sald_mmnn,
       p_cuot_sald_mmee,
       p_cuot_movi_codi);
  end pp_insert_come_movi_cuot_adel;
  procedure pp_devu_dbcr_conc(p_conc_codi in number, p_dbcr out varchar2) is
  begin
    select conc_dbcr
      into p_dbcr
      from come_conc
     where conc_codi = p_conc_codi;
  exception
    when no_data_found then
      raise_application_error(-20001, 'Concepto inexistente!');
  end pp_devu_dbcr_conc;
  procedure pp_actu_comp(p_movi_tico_codi in number,
                         p_movi_empl_codi in number,
                         p_movi_tare_codi in number,
                         p_movi_nume      in number) is
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
  begin
    begin
      select nvl(tare_ulti_nume, 0) + 1
        into v_ulti_comp
        from come_talo_reci
       where tare_esta = 'A'
         and tare_tico_codi = p_movi_tico_codi
         and tare_empl_codi = p_movi_empl_codi;
    exception
      when no_data_found then
        null;
      when others then
        null;
    end;
    if p_movi_nume >= v_ulti_comp then
      begin
        update come_talo_reci a
           set a.tare_ulti_nume = p_movi_nume
         where a.tare_empl_codi = p_movi_empl_codi
           and a.tare_codi = p_movi_tare_codi
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
       where resa_tare_codi = p_movi_tare_codi
         and resa_nume_comp = p_movi_nume
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
       where a.tare_reci_hast = p_movi_nume
         and a.tare_codi = p_movi_tare_codi
         and a.tare_esta = 'A';
      if v_count > 0 then
        select count(*)
          into v_count
          from come_reci_salt_auto
         where resa_tare_codi = p_movi_tare_codi
           and resa_esta = 'A';
        if v_count = 0 then
          begin
            update come_talo_reci
               set tare_esta = 'C'
             where tare_codi = p_movi_tare_codi
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
           where tare_empl_codi = p_movi_empl_codi
             and tare_codi = p_movi_tare_codi
             and tare_esta = 'A';
        end;
        begin
          select t.tare_reci_desd
            into v_tare_desd
            from come_talo_reci t
           where t.tare_empl_codi = p_movi_empl_codi
             and t.tare_tico_codi = p_movi_tico_codi
             and t.tare_codi = p_movi_tare_codi;
        end;
        begin
          select t.tare_reci_hast
            into v_tare_hast
            from come_talo_reci t
           where t.tare_empl_codi = p_movi_empl_codi
             and t.tare_tico_codi = p_movi_tico_codi
             and t.tare_codi = p_movi_tare_codi;
        end;
        begin
          select sum(cant)
            into v_count_tare
            from (select count(distinct(m.movi_nume)) cant
                  --  into v_count_tare
                    from come_movi m
                   where m.movi_timo_codi in (29, 13)
                     and m.movi_empl_codi = p_movi_empl_codi
                     and m.movi_nume between v_tare_desd and v_tare_hast
                  union all
                  select count(distinct(a.anul_nume)) cant
                  --  into v_count_tare
                    from come_movi_anul a
                   where a.anul_timo_codi in (29, 13)
                     and a.anul_nume between v_tare_desd and v_tare_hast);
          if v_count_tare >= v_cant_tare then
            begin
              --pl_mm('aqui es el problema');
              update come_talo_reci
                 set tare_esta = 'C'
               where tare_codi = p_movi_tare_codi
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
  end pp_actu_comp;
  procedure pp_actualizar_auto_desc_inte(p_movi_clpr_codi in number) is
  begin
    update come_auto_desc_inte i
       set i.dein_esta = 'C'
     where i.dein_clpr_codi = p_movi_clpr_codi;
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualizar_auto_desc_inte;
  procedure pp_actu_secu(p_movi_nume in number) is
  begin
    if rtrim(ltrim(upper(parameter.p_para_inic))) =
       rtrim(ltrim(upper('C'))) then
      update come_secu
         set secu_nume_cobr = p_movi_nume
       where secu_codi = (select f.user_secu_codi
                            from segu_user f
                           where user_login = fp_user); /*(select peco_secu_codi
                                                            from come_pers_comp
                                                           where peco_codi = p_peco_codi);*/
    end if;
  end pp_actu_secu;
  procedure pp_muestra_come_tipo_movi_inte(p_timo_codi      in number,
                                           p_timo_desc      out char,
                                           p_timo_desc_abre out char,
                                           p_timo_afec_sald out char,
                                           p_timo_dbcr      out char,
                                           p_timo_calc_iva  out char) is
  begin
    select timo_desc,
           timo_desc_abre,
           timo_afec_sald,
           timo_dbcr,
           timo_calc_iva
      into p_timo_desc,
           p_timo_desc_abre,
           p_timo_afec_sald,
           p_timo_dbcr,
           p_timo_calc_iva
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  exception
    when no_data_found then
      p_timo_desc_abre := null;
      p_timo_desc      := null;
      p_timo_afec_sald := null;
      p_timo_dbcr      := null;
      p_timo_calc_iva  := null;
      raise_application_error(-20001, 'Tipo de Movimiento Inexistente!');
    when others then
      raise_application_error(-20001, 'Error ' || sqlerrm);
  end pp_muestra_come_tipo_movi_inte;
  procedure pp_devu_nume_timb_fech(p_peco_codi      in number,
                                   p_secu_nume_fact out number,
                                   p_nume_timb      out number,
                                   p_fech_venc      out date) is
  begin
    select nvl(s.secu_nume_fact, 0) + 1, t.setc_nume_timb, t.setc_fech_venc
      into p_secu_nume_fact, p_nume_timb, p_fech_venc
      from come_secu s, come_pers_comp c, come_secu_tipo_comp t
     where s.secu_codi = c.peco_secu_codi
       and s.secu_codi = t.setc_secu_codi
       and t.setc_tico_codi = 4
       and c.peco_codi = p_peco_codi
       and t.setc_esta =
           substr(s.secu_nume_fact, 1, (length(s.secu_nume_fact) - 10))
       and t.setc_punt_expe =
           substr(s.secu_nume_fact, length(s.secu_nume_fact) - 9, 3);
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Codigo de Secuencia de Facturaci?n inexistente');
  end pp_devu_nume_timb_fech;
  procedure pp_actu_secu_rete(p_impo_rete      in number,
                              p_movi_nume_rete in number) is
  begin
    if nvl(p_impo_rete, 0) > 0 then
      update come_secu
         set secu_nume_reten = p_movi_nume_rete
       where secu_codi = (select f.user_secu_codi
                            from segu_user f
                           where user_login = fp_user);
    
      /*  (select peco_secu_codi
       from come_pers_comp
      where peco_codi = p_peco_codi);*/
    end if;
  end pp_actu_secu_rete;
  procedure pp_actu_secu_rete_tesa(p_movi_nume in number) is
  begin
    update come_secu
       set secu_nume_reten = p_movi_nume
     where secu_codi = (select f.user_secu_codi
                          from segu_user f
                         where user_login = fp_user); /*(select peco_secu_codi
                                          from come_pers_comp
                                         where peco_codi = p_peco_codi);*/
  end pp_actu_secu_rete_tesa;
  procedure pp_validar_mar_det(p_indi_digi_impo           in varchar2,
                               p_para_inic                in varchar2,
                               p_indi_inte_cobr_app       in varchar2,
                               p_cabe_inte_mora_puni_cobr in out number,
                               p_movi_exen_mone           out number,
                               p_movi_exen_mone_tota      in out number,
                               p_movi_tasa_mone           in number,
                               p_indi_calc_inte           in varchar2,
                               p_dife                     in out number,
                               p_movi_fech_emis           in date,
                               p_seq                      in number,
                               p_impo_inte_gaad           out number,
                               p_sum_impo_pago            out number) is
    cursor c is
      select c001 ind_marcado,
             c002 movi_nume,
             c003 movi_mone_codi,
             c004 movi_fech_emis,
             c005 cuot_nume_desc,
             c006 cuot_fech_venc,
             c007 cuot_sald_mone,
             c008 cuot_sald_mmnn,
             c009 movi_codi,
             c010 cuot_tasa_mone,
             c011 clpr_codi,
             c012 clpr_codi_alte,
             c013 movi_iva_mone,
             c014 movi_codi_rete,
             c015 orte_desc,
             c016 impo_inte_mora_puni_orig,
             c017 impo_inte_mora_orig,
             c018 impo_inte_puni_orig,
             c019 impo_inte_gast_admi_orig,
             c020 impo_inte_gast_admi,
             c021 cuot_impo_mone,
             c022 impo_pago,
             c023 impo_inte_mora_puni,
             c025 impo_rete_mone,
             c026 s_apli_rete,
             c027 impo_inte_gaad,
             c028 impo_inte_puni,
             c029 impo_inte_mora,
             c030 impo_inte_mora_puni_gaad,
             (select sum(c023)
                from apex_collections a
               where collection_name = 'BDETALLE'
                 and c001 = 'X') sum_inte_mora_puni_gaad,
             (select sum(c022)
                from apex_collections a
               where collection_name = 'BDETALLE'
                 and c001 = 'X') sum_impo_pago,
             (select sum(c027)
                from apex_collections a
               where collection_name = 'BDETALLE'
                 and c001 = 'X') sum_impo_inte_gaad,
             seq_id
        from apex_collections a
       where collection_name = 'BDETALLE'
         and seq_id = p_seq;
    v_impo_pago               number;
    v_impo_pago_mmnn          number;
    v_impo_inte_mora_puni     number;
    v_impo_inte_gaad          number;
    v_sum_inte_mora_puni_gaad number;
    v_impo_inte_puni          number;
    v_impo_inte_mora          number;
    v_importe_pagar           number := nvl(v('P10_TOTAL_IMPORTE'), 0);
    v_importe_total           number := 0;
  begin
    if v_importe_pagar is not null then
      p_movi_exen_mone_tota := v_importe_pagar;
    end if;
    for i in c loop
      if i.ind_marcado = 'X' then
        v_impo_pago := i.impo_pago;
      
        if (nvl(p_indi_digi_impo, 'N') = 'S' or v_importe_pagar > 0) then
        
          if v_impo_pago is null then
            if p_para_inic = 'C' and nvl(p_indi_inte_cobr_app, 'N') = 'S' then
              v_impo_inte_mora_puni := nvl(i.impo_inte_mora_orig, 0) +
                                       nvl(i.impo_inte_puni_orig, 0) +
                                       nvl(i.impo_inte_gast_admi_orig, 0);
              v_impo_inte_gaad      := nvl(i.impo_inte_gast_admi_orig, 0);
              v_impo_inte_puni      := nvl(i.impo_inte_puni_orig, 0);
              v_impo_inte_mora      := nvl(i.impo_inte_mora_orig, 0);
            else
              v_impo_inte_mora_puni := null;
              v_impo_inte_gaad      := null;
              v_impo_inte_puni      := null;
              v_impo_inte_mora      := null;
            end if;
            v_sum_inte_mora_puni_gaad := nvl(i.sum_inte_mora_puni_gaad, 0) +
                                         nvl(v_impo_inte_mora_puni, 0);
            --------------------------
            if v_sum_inte_mora_puni_gaad is not null then
              if p_cabe_inte_mora_puni_cobr is null or
                 nvl(p_indi_calc_inte, 'S') = 'S' then
                p_cabe_inte_mora_puni_cobr := v_sum_inte_mora_puni_gaad;
              end if;
            end if;
            p_movi_exen_mone := nvl(p_movi_exen_mone_tota, 0) -
                                nvl(p_cabe_inte_mora_puni_cobr,
                                    nvl(v_sum_inte_mora_puni_gaad, 0));
            if nvl(p_movi_exen_mone, 0) > 0 then
              if i.cuot_sald_mone <=
                 nvl(p_movi_exen_mone, 0) - nvl(i.sum_impo_pago, 0) then
                v_impo_pago      := i.cuot_sald_mone;
                v_impo_pago_mmnn := round((v_impo_pago * p_movi_tasa_mone),
                                          parameter.p_cant_deci_mmnn);
                p_dife           := nvl(p_movi_exen_mone_tota, 0) -
                                    (nvl(i.sum_impo_pago, 0) +
                                     nvl(v_impo_pago, 0)) -
                                    nvl(p_cabe_inte_mora_puni_cobr, 0);
              else
                v_impo_pago      := nvl(p_movi_exen_mone, 0) -
                                    nvl(i.sum_impo_pago, 0);
                v_impo_pago_mmnn := round((v_impo_pago * p_movi_tasa_mone),
                                          parameter.p_cant_deci_mmnn);
                p_dife           := nvl(p_movi_exen_mone_tota, 0) -
                                    (nvl(i.sum_impo_pago, 0) +
                                     nvl(v_impo_pago, 0)) -
                                    nvl(p_cabe_inte_mora_puni_cobr, 0);
                if v_impo_pago = 0 then
                  v_impo_inte_mora_puni := null;
                  v_impo_inte_gaad      := null;
                  v_impo_inte_puni      := null;
                  v_impo_inte_mora      := null;
                end if;
              end if;
            else
              v_impo_inte_mora_puni := null;
              v_impo_inte_gaad      := null;
              v_impo_inte_puni      := null;
              v_impo_inte_mora      := null;
              v_impo_pago           := 0;
              v_impo_pago_mmnn      := 0;
              p_dife                := nvl(p_movi_exen_mone_tota, 0) -
                                       nvl(p_cabe_inte_mora_puni_cobr, 0);
              -- raise_application_error(-20001, 'El saldo de importe a pagar es inferior a los Intereses de la cuota.');
            end if;
          else
            v_impo_pago      := 0;
            v_impo_inte_gaad := i.impo_inte_gaad;
            v_impo_inte_puni := i.impo_inte_puni;
            v_impo_inte_mora := i.impo_inte_mora;
          end if;
        else
          -- v_impo_pago := i.impo_pago;
          if v_impo_pago is null then
          
            if p_para_inic = 'C' and nvl(p_indi_inte_cobr_app, 'N') = 'S' then
            
              v_impo_inte_mora_puni := nvl(i.impo_inte_mora_orig, 0) +
                                       nvl(i.impo_inte_puni_orig, 0) +
                                       nvl(i.impo_inte_gast_admi_orig, 0);
              v_impo_inte_gaad      := nvl(i.impo_inte_gast_admi_orig, 0);
              v_impo_inte_puni      := nvl(i.impo_inte_puni_orig, 0);
              v_impo_inte_mora      := nvl(i.impo_inte_mora_orig, 0);
            else
              v_impo_inte_mora_puni := null;
              v_impo_inte_gaad      := null;
              v_impo_inte_puni      := null;
              v_impo_inte_mora      := null;
            end if;
            v_sum_inte_mora_puni_gaad := nvl(i.sum_inte_mora_puni_gaad, 0) +
                                         v_impo_inte_mora_puni;
            if v_sum_inte_mora_puni_gaad is not null then
              if p_cabe_inte_mora_puni_cobr is null or
                 nvl(p_indi_calc_inte, 'S') = 'S' then
                p_cabe_inte_mora_puni_cobr := v_sum_inte_mora_puni_gaad;
              end if;
            end if;
            if nvl(p_dife, 0) > 0 then
              if i.cuot_sald_mone <= nvl(p_dife, 0) then
                v_impo_pago      := i.cuot_sald_mone;
                v_impo_pago_mmnn := round((v_impo_pago * p_movi_tasa_mone),
                                          parameter.p_cant_deci_mmnn);
                p_dife           := nvl(p_movi_exen_mone_tota, 0) -
                                    (nvl(i.sum_impo_pago, 0) +
                                     nvl(v_impo_pago, 0)) -
                                    nvl(p_cabe_inte_mora_puni_cobr, 0);
              else
                v_impo_pago      := nvl(p_dife, 0) -
                                    nvl(i.sum_impo_pago, 0);
                v_impo_pago_mmnn := round((v_impo_pago * p_movi_tasa_mone),
                                          parameter.p_cant_deci_mmnn);
                p_dife           := nvl(p_movi_exen_mone_tota, 0) -
                                    (nvl(i.sum_impo_pago, 0) +
                                     nvl(v_impo_pago, 0)) -
                                    nvl(p_cabe_inte_mora_puni_cobr, 0);
                if v_impo_pago = 0 then
                  v_impo_inte_mora_puni := null;
                  v_impo_inte_gaad      := null;
                  v_impo_inte_puni      := null;
                  v_impo_inte_mora      := null;
                end if;
              end if;
            else
              v_impo_pago           := i.cuot_sald_mone;
              v_impo_pago_mmnn      := round((v_impo_pago *
                                             p_movi_tasa_mone),
                                             parameter.p_cant_deci_mmnn);
              p_movi_exen_mone      := (nvl(i.sum_impo_pago, 0) +
                                       nvl(v_impo_pago, 0));
              p_movi_exen_mone_tota := nvl(p_movi_exen_mone, 0) +
                                       nvl(p_cabe_inte_mora_puni_cobr,
                                           nvl(v_sum_inte_mora_puni_gaad, 0));
            end if;
          else
            v_impo_pago      := 0;
            v_impo_inte_gaad := i.impo_inte_gaad;
            v_impo_inte_puni := i.impo_inte_puni;
            v_impo_inte_mora := i.impo_inte_mora;
          end if;
        end if;
        p_impo_inte_gaad := nvl(i.sum_impo_inte_gaad, 0) +
                            nvl(v_impo_inte_gaad, 0);
        if i.movi_fech_emis > p_movi_fech_emis then
          raise_application_error(-20001,
                                  'La fecha de pago debe ser mayor o igual a la factura a pagar');
        end if;
        v_importe_total := (nvl(i.impo_inte_mora_puni_orig, 0) +
                           nvl(v_impo_pago, 0));
      else
        v_impo_pago           := null;
        v_impo_pago_mmnn      := null;
        v_impo_inte_mora_puni := null;
        v_impo_inte_gaad      := null;
        v_impo_inte_puni      := null;
        v_impo_inte_mora      := null;
        v_importe_total       := 0;
        if v_importe_pagar is null then
          p_dife :=  /*null; */
           nvl(p_movi_exen_mone_tota, 0) -
                    (nvl(i.sum_impo_pago, 0) + nvl(v_impo_pago, 0)) -
                    nvl(p_cabe_inte_mora_puni_cobr, 0);
        else
          p_dife := nvl(v_importe_pagar, 0) - nvl(p_movi_exen_mone_tota, 0);
        end if;
      end if;
      p_sum_impo_pago := (nvl(i.sum_impo_pago, 0) + nvl(v_impo_pago, 0));
    
      apex_collection.update_member(p_collection_name => 'BDETALLE',
                                    p_seq             => p_seq,
                                    p_c001            => i.ind_marcado,
                                    p_c002            => i.movi_nume,
                                    p_c003            => i.movi_mone_codi,
                                    p_c004            => i.movi_fech_emis,
                                    p_c005            => i.cuot_nume_desc,
                                    p_c006            => i.cuot_fech_venc,
                                    p_c007            => i.cuot_sald_mone,
                                    p_c008            => i.cuot_sald_mmnn,
                                    p_c009            => i.movi_codi,
                                    p_c010            => i.cuot_tasa_mone,
                                    p_c011            => i.clpr_codi,
                                    p_c012            => i.clpr_codi_alte,
                                    p_c013            => i.movi_iva_mone,
                                    p_c014            => i.movi_codi_rete,
                                    p_c015            => i.orte_desc,
                                    p_c016            => i.impo_inte_mora_puni_orig,
                                    p_c017            => i.impo_inte_mora_orig,
                                    p_c018            => i.impo_inte_puni_orig,
                                    p_c019            => i.impo_inte_gast_admi_orig,
                                    p_c020            => i.impo_inte_gast_admi,
                                    p_c021            => i.cuot_impo_mone,
                                    p_c022            => case
                                                           when v_impo_pago < 0 then
                                                            0
                                                           else
                                                            v_impo_pago
                                                         end,
                                    p_c023            => v_impo_inte_mora_puni,
                                    p_c024            => v_impo_pago_mmnn,
                                    p_c025            => i.impo_rete_mone,
                                    p_c026            => i.s_apli_rete,
                                    p_c027            => v_impo_inte_gaad,
                                    p_c028            => v_impo_inte_puni,
                                    p_c029            => v_impo_inte_mora,
                                    p_c030            => i.impo_inte_mora_puni_gaad,
                                    p_c031            => v_importe_total);
    end loop;
  
    /* begin
      -- Call the procedure
      --raise_application_Error(-20001,v_importe_pagar);
      v_importe_pagar:= v('P10_TOTAL_IMPORTE');
      i020007.pp_cargar_importe(p_importe_total =>v_importe_pagar,
                                p_movi_exen_mone_tota => p_movi_exen_mone_tota,
                                p_movi_exen_mone=>p_movi_exen_mone);
    end;*/
  
  end pp_validar_mar_det;
  procedure pp_validar_mont_inte_gas(p_cabe_inte_mora_puni_cobr in number,
                                     p_movi_exen_mone_tota      out number,
                                     p_movi_exen_mone           in number,
                                     p_indi_calc_inte           out varchar2) is
    --V_movi_exen_mone NUMBER; 
  begin
  
    p_movi_exen_mone_tota := nvl(p_movi_exen_mone, 0) +
                             nvl(p_cabe_inte_mora_puni_cobr, 0);
  
    p_indi_calc_inte := 'N';
  
  end pp_validar_mont_inte_gas;
  procedure pp_prorratear_interes(p_seq_id in number default null) is
  
    cursor cd is
      select c001 ind_marcado,
             c016 impo_inte_mora_puni_orig,
             c017 impo_inte_mora_orig,
             c018 impo_inte_puni_orig,
             c019 impo_inte_gast_admi_orig,
             c020 impo_inte_gast_admi,
             case
               when parameter.p_clie_desc_inte > 0 then
                c023
               else
                null
             end impo_inte_mora_puni,
             
             c030 impo_inte_mora_puni_gaad,
             (select nvl(nvl(sum(c028), 0) + nvl(sum(c029), 0) +
                         nvl(sum(c027), 0),
                         0)
                from apex_collections a
               where collection_name = 'BDETALLE'
                 and c001 = 'X') sum_inte_mora_puni_gaad,
             seq_id
        from apex_collections a
       where collection_name = 'BDETALLE'
         and c001 = 'X'
         and (seq_id = p_seq_id or seq_id is not null);
    v_sum_inte_mora_puni_gaad  number := 1;
    v_inte_mora_puni_orig      number := 1;
    v_sum_mora_puni_gast       number := 0;
    v_impo_inte_mora_puni_gaad number;
    v_impo_inte_gast_admi      number;
    v_impo_inte_mora           number;
    v_impo_inte_puni           number;
  begin
    for c in cd loop
      -- raise_application_error(-20001,'ddd');
      if c.impo_inte_mora_puni is not null then
        if nvl(c.sum_inte_mora_puni_gaad, 0) = 0 then
          v_sum_inte_mora_puni_gaad := 1;
        else
          v_sum_inte_mora_puni_gaad := c.sum_inte_mora_puni_gaad;
        end if;
        if nvl(c.impo_inte_mora_puni_orig, 0) = 0 then
          v_inte_mora_puni_orig := 1;
        else
          v_inte_mora_puni_orig := c.impo_inte_mora_puni_orig;
        end if;
        v_impo_inte_mora_puni_gaad := round((nvl(v('P10_CABE_INTE_MORA_PUNI_COBR'),
                                                 0) *
                                            ((nvl(c.impo_inte_mora_puni_orig,
                                                   0) * 100) /
                                            v_sum_inte_mora_puni_gaad)) / 100,
                                            0);
      
        v_impo_inte_gast_admi := round((nvl(v_impo_inte_mora_puni_gaad, 0) *
                                       ((nvl(c.impo_inte_gast_admi_orig, 0) * 100) /
                                       v_inte_mora_puni_orig)) / 100,
                                       0);
        v_impo_inte_mora      := round((nvl(v_impo_inte_mora_puni_gaad, 0) *
                                       ((nvl(c.impo_inte_mora_orig, 0) * 100) /
                                       v_inte_mora_puni_orig)) / 100,
                                       0);
        v_impo_inte_puni      := round((nvl(v_impo_inte_mora_puni_gaad, 0) *
                                       ((nvl(c.impo_inte_puni_orig, 0) * 100) /
                                       v_inte_mora_puni_orig)) / 100,
                                       0);
      
        v_sum_mora_puni_gast := v_sum_mora_puni_gast +
                                nvl(v_impo_inte_gast_admi, 0) +
                                nvl(v_impo_inte_mora, 0) +
                                nvl(v_impo_inte_puni, 0);
      
        -----------------------------------------------------------
        pp_actualizar_member_coll(c.seq_id, 30, v_impo_inte_mora_puni_gaad);
        pp_actualizar_member_coll(c.seq_id, 28, v_impo_inte_mora);
        pp_actualizar_member_coll(c.seq_id, 29, v_impo_inte_puni);
        pp_actualizar_member_coll(c.seq_id, 27, v_impo_inte_gast_admi);
        pp_actualizar_member_coll(c.seq_id, 20, v_impo_inte_gast_admi);
      
      end if;
    end loop;
    --se verifica que no haya diferencias por redondeo en la distribuci?n de intereses,y se ajusta al gasto administrativo del primer registro
    if v_sum_mora_puni_gast <> nvl(v('P10_CABE_INTE_MORA_PUNI_COBR'), 0) then
      for j in cd loop
        if j.impo_inte_mora_puni is not null then
          v_impo_inte_gast_admi := nvl(j.impo_inte_gast_admi, 0) -
                                   (v_sum_mora_puni_gast -
                                    nvl(v('P10_CABE_INTE_MORA_PUNI_COBR'),
                                        0));
          pp_actualizar_member_coll(j.seq_id, 20, v_impo_inte_gast_admi);
        end if;
      end loop;
    end if;
  end pp_prorratear_interes;
  procedure pp_actualizar_member_coll(p_seq         in number,
                                      p_attr_number in number,
                                      p_value       in varchar2) is
  begin
    apex_collection.update_member_attribute(p_collection_name => 'BDETALLE',
                                            p_seq             => p_seq,
                                            p_attr_number     => p_attr_number,
                                            p_attr_value      => p_value);
  end pp_actualizar_member_coll;
  procedure pp_llamar_reporte(p_come_movi in varchar) is
    v_parametros   clob;
    v_contenedores clob;
  begin
    -----GENERA CONSULTA PARA LLAMAR AL RESPORTE
    pp_generar_consulta(i_app_session => v('APP_SESSION'),
                        i_empr_codi   => V('AI_EMPR_CODI'),
                        i_movi_codi   => p_come_movi);
    --v_nombre:=  'comisioncobranzas'; comisioninstalaciones
    --v_contenedores := 'movi_codi'; --'p_come_nro';
    -- v_parametros   := p_come_movi;
    v_contenedores := 'p_app_session:p_app_user';
    v_parametros   := v('APP_SESSION') || ':' || g_user;
    delete from come_parametros_report where usuario = g_user;
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros,
       g_user,
       'I040223' /*'I020007_cama'*/,
       'pdf',
       v_contenedores);
  exception
    when others then
      null;
  end pp_llamar_reporte;
  procedure pp_muestra_come_tipo_movi(p_timo_codi      in number,
                                      p_timo_desc      out char,
                                      p_timo_desc_abre out char,
                                      p_timo_afec_sald out char,
                                      p_timo_dbcr      out char /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      p_timo_indi_adel out char,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      p_timo_indi_ncr  out char,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      p_indi_vali      in char*/) is
    -- v_dbcr varchar2(1);
  begin
    select timo_desc, timo_desc_abre, timo_afec_sald, timo_dbcr /*,
                                                                                     nvl(timo_indi_adel, 'n'),
                                                                                     nvl(timo_indi_ncr, 'n')*/
      into p_timo_desc, p_timo_desc_abre, p_timo_afec_sald, p_timo_dbcr /*,
                                                                                     p_timo_indi_adel,
                                                                                     p_timo_indi_ncr*/
      from come_tipo_movi
     where timo_codi = p_timo_codi;
    /*if p_indi_vali = 's' then
      if p_timo_indi_adel = 'n' and p_timo_indi_ncr = 'n' then
        raise_application_error(-20001,
                                'solo se pueden ingresar movimientos del tipo adelantos/notas de creditos');
      end if;
      if p_timo_indi_adel = 's' and p_timo_indi_ncr = 's' then
        raise_application_error(-20001,
                                'el tipo de movimiento esta configurado como adelanto y nota de credito al mismo tiempo, favor verificar..');
      end if;
    end if;
    if p_emit_reci = 'r' then
      v_dbcr := 'd';
    else
      v_dbcr := 'c';
    end if;*/
    /*if p_indi_vali = 's' then
      if p_timo_dbcr <> v_dbcr then
        raise_application_error(-20001, 'tipo de movimiento incorrecto');
      end if;
    end if;*/
  exception
    when no_data_found then
      p_timo_desc_abre := null;
      p_timo_desc      := null;
      p_timo_afec_sald := null;
      p_timo_dbcr      := null;
      -- p_timo_indi_adel := null;
      -- p_timo_indi_ncr  := null;
      raise_application_error(-20001, 'Tipo de Movimiento Inexistente!');
    when others then
      raise_application_error(-20001, 'error: ' || sqlerrm);
  end pp_muestra_come_tipo_movi;
  procedure pp_veri_nume_comp(p_movi_nume in out varchar2) is
    v_resa_nume_comp number;
    --v_tare_reci_desd number;
    --v_tare_reci_hast number;
    v_nume_comp number;
    v_nume_libr number;
    v_count     number;
    v_movi_nume number := p_movi_nume;
    salir       exception;
  begin
  
    select resa_nume_comp
      into v_resa_nume_comp
      from come_reci_salt_auto, come_talo_reci
     where resa_tare_codi = v('P10_MOVI_TARE_CODI')
       and resa_tare_codi = tare_codi
       and resa_esta = 'A';
  
    --raise_application_error(-20001,v_resa_nume_comp);
    /*if fl_confirmar_reg('desea rendir cuenta del comprobante numero '||v_resa_nume_comp||'?') <> upper('confirmar') then
      :parameter.p_indi_rend_comp := 'n';
      raise salir;
    else
      :parameter.p_indi_rend_comp := 's';
    end if;*/
    v_movi_nume := v_resa_nume_comp;
    --verificar si ese numero ya fue rendido o no.
    begin
      select count(*)
        into v_count
        from come_movi_anul, come_tipo_movi
       where anul_timo_codi = timo_codi
         and timo_tico_codi = v('P10_MOVI_TICO_CODI')
         and anul_nume = v_movi_nume;
      if v_count > 0 then
        raise_application_error(-20001,
                                'El comprobante ya ha sido Anulado. Verifique el numero de comprobante. ' ||
                                v_movi_nume);
      end if;
      select count(*)
        into v_count
        from come_movi m, come_tipo_movi t
       where m.movi_timo_codi = t.timo_codi
         and t.timo_tico_codi = 5
         and m.movi_nume = v_movi_nume;
      if v_count > 0 then
        raise_application_error(-20001,
                                'El comprobante ya ha sido rendido. Verifique el numero de comprobante.');
      end if;
    end;
    p_movi_nume := nvl(v_movi_nume, p_movi_nume);
  exception
    when no_data_found then
    
      begin
      
        select tare_reci_desd
          into v_nume_comp
          from come_talo_reci
         where tare_codi = v('P10_MOVI_TARE_CODI');
      
        pp_veri_nume_libr(v('P10_MOVI_TARE_CODI'), v_nume_libr);
      
        if nvl(v_nume_libr, -1) <> -1 then
          v_movi_nume := v_nume_libr;
          v_nume_comp := v_nume_libr;
        end if;
        pp_vali_nume_libr(v('P10_MOVI_TARE_CODI'), v_nume_comp);
        if v_movi_nume <> v_nume_comp then
          v_movi_nume := v_nume_comp;
        else
          --verificar si ese numero ya fue rendido o no.
          begin
            select count(*)
              into v_count
              from come_movi_anul, come_tipo_movi
             where anul_timo_codi = timo_codi
               and timo_tico_codi = v('P10_MOVI_TICO_CODI')
               and anul_nume = v_movi_nume;
            if v_count > 0 then
              raise_application_error(-20001,
                                      'El comprobante ya ha sido Anulado. Verifique el numero de comprobante.  ' ||
                                      v_movi_nume);
            end if;
            select count(*)
              into v_count
              from come_movi m, come_tipo_movi t
             where m.movi_timo_codi = t.timo_codi
               and t.timo_tico_codi = 5
               and m.movi_nume = v_movi_nume;
            if v_count > 0 then
              raise_application_error(-20001,
                                      'El comprobante ya ha sido rendido. Verifique el numero de comprobante.');
            end if;
          end;
        end if;
      
      end;
      p_movi_nume := nvl(v_movi_nume, p_movi_nume);
      -- RAISE_APPLICATION_eRROR(-20001,' AAA '||p_movi_nume); 
    when salir then
      -- RAISE_APPLICATION_eRROR(-20001,' ss '||p_movi_nume);  
      pp_veri_fech_venc_auto(v_resa_nume_comp, v('P10_MOVI_TARE_CODI'));
    when too_many_rows then
      null;
    
  end pp_veri_nume_comp;
  procedure pp_validar_comprob(p_resa_nume_comp    out number,
                               p_ind_resa_num_dupl out varchar2) is
  begin
    select resa_nume_comp
      into p_resa_nume_comp
      from come_reci_salt_auto, come_talo_reci
     where resa_tare_codi = v('P10_MOVI_TARE_CODI')
       and resa_tare_codi = tare_codi
       and resa_esta = 'A';
    p_ind_resa_num_dupl := 'N';
  
  exception
    when no_data_found then
      null;
    when too_many_rows then
      p_ind_resa_num_dupl := 'S';
      p_resa_nume_comp    := null;
  end pp_validar_comprob;
  procedure pp_cargar_importe(p_importe_total       in out number,
                              p_movi_exen_mone_tota out number,
                              p_movi_exen_mone      out number --,
                              -- P_S_DIFE              out number
                              
                              ) is
    v_impo_inte_puni      number;
    v_impo_inte_gast_admi number;
    v_IMPO_INTE_MORA_PUNI number;
    --v_diferencia number;
  begin
    select nvl(sum(c022), 0) + nvl(sum(c027), 0) + nvl(sum(c028), 0) +
           nvl(sum(c029), 0),
           sum(c022) cuota,
           nvl(nvl(sum(c028), 0) + nvl(sum(c029), 0) + nvl(sum(c027), 0), 0) IMPO_INTE_MORA_PUNI,
           sum(c027) impo_inte_gast_admi,
           (nvl(sum(c028), 0) + nvl(sum(c029), 0)) inte_puni_mora
      into p_movi_exen_mone_tota,
           p_movi_exen_mone,
           v_IMPO_INTE_MORA_PUNI,
           v_impo_inte_gast_admi,
           v_impo_inte_puni
      from apex_collections a
     where collection_name = 'BDETALLE'
       and c001 = 'X';
    --  raise_application_error(-20001,p_movi_exen_mone_tota);
    setitem('P10_SUM_INTE_MORA_PUNI_GAAD', v_IMPO_INTE_MORA_PUNI);
    setitem('P10_CABE_INTE_MORA_PUNI_COBR', v_IMPO_INTE_MORA_PUNI);
    setitem('P10_CABE_SUM_INTE_GAST_ADMI', v_impo_inte_gast_admi);
    setitem('P10_CABE_SUM_INTE_MORA_PUNI', v_impo_inte_puni);
    if p_importe_total > 0 then
      if p_importe_total < p_movi_exen_mone_tota then
        p_importe_total := p_movi_exen_mone_tota;
      end if;
    
    end if;
  
  end pp_cargar_importe;
  procedure pp_veri_fech_venc_auto(p_resa_nume_comp in number,
                                   p_movi_tare_codi in number) is
    v_saldo_dias number;
  begin
    select round(trunc(resa_fech_rend) - trunc(sysdate))
      into v_saldo_dias
      from come_reci_salt_auto
     where resa_tare_codi = p_movi_tare_codi
       and resa_nume_comp = p_resa_nume_comp
       and resa_esta = 'A';
    if v_saldo_dias < 0 then
      raise_application_error(-20001,
                              'El comprobante ' || p_resa_nume_comp ||
                              ' aun no fue rendido y ya sobrepaso la fecha prevista.');
    end if;
  exception
    when no_data_found then
      null;
    when too_many_rows then
      raise_application_error(-20001,
                              'Existe mas de un salto autorizado con el nro ' ||
                              p_resa_nume_comp);
    when others then
      raise_application_error(-20001, sqlerrm);
  end;
  procedure pp_veri_auto_clie is
  begin
    begin
      select i.dein_porc
        into parameter.p_clie_desc_inte
        from come_auto_desc_inte i
       where i.dein_clpr_codi = bcab.movi_clpr_codi
         and i.dein_esta = 'P';
    exception
      when no_data_found then
        parameter.p_clie_desc_inte := 0;
    end;
    begin
      ---Recupera el porc. de inte. del usuario
      select p.perf_max_desc
        into parameter.p_user_perf_desc_inte
        from segu_user u, come_perf_auto_desc_inte p
       where u.user_perf_desc_inte_codi = p.perf_codi
         and u.user_login = g_user;
    exception
      when no_data_found then
        parameter.p_user_perf_desc_inte := 0;
    end;
  end pp_veri_auto_clie;
  procedure pp_veri_auto_clie_1(p_movi_clpr_codi      in number,
                                p_clie_desc_inte      out number,
                                p_user_perf_desc_inte out number) is
  begin
    begin
      select i.dein_porc
        into p_clie_desc_inte
        from come_auto_desc_inte i
       where i.dein_clpr_codi = p_movi_clpr_codi
         and i.dein_esta = 'P';
    exception
      when no_data_found then
        p_clie_desc_inte := 0;
    end;
    begin
      ---Recupera el porc. de inte. del usuario
      select p.perf_max_desc
        into p_user_perf_desc_inte
        from segu_user u, come_perf_auto_desc_inte p
       where u.user_perf_desc_inte_codi = p.perf_codi
         and u.user_login = g_user;
    exception
      when no_data_found then
        p_user_perf_desc_inte := 0;
    end;
  end pp_veri_auto_clie_1;
  procedure pp_validar_importe_auto_inte is
    v_impo_maxi_desc_inte_user number;
    v_impo_maxi_desc_inte_clie number;
  
  begin
    v_impo_maxi_desc_inte_user := round(nvl( /*bdet.*/bcab.cabe_sum_inte_mora_puni_gaad,
                                            bcab.cabe_inte_mora_puni_cobr) -
                                        (nvl( /*bdet.*/bcab.cabe_sum_inte_mora_puni_gaad,
                                             bcab.cabe_inte_mora_puni_cobr) *
                                         nvl(parameter.p_user_perf_desc_inte,
                                             0) / 100));
    v_impo_maxi_desc_inte_clie := round(nvl( /*bdet.*/bcab.cabe_sum_inte_mora_puni_gaad,
                                            bcab.cabe_inte_mora_puni_cobr) -
                                        (nvl( /*bdet.*/bcab.cabe_sum_inte_mora_puni_gaad,
                                             bcab.cabe_inte_mora_puni_cobr) *
                                         nvl(parameter.p_clie_desc_inte, 0) / 100));
    if v_impo_maxi_desc_inte_user < v_impo_maxi_desc_inte_clie then
      bcab.cabe_impo_maxi_desc_inte := v_impo_maxi_desc_inte_user;
    else
      bcab.cabe_impo_maxi_desc_inte := v_impo_maxi_desc_inte_clie;
    end if;
    if nvl(bcab.cabe_inte_mora_puni_cobr, 0) > 0 then
      if bcab.cabe_inte_mora_puni_cobr <
         nvl( /*bdet.*/ bcab.cabe_sum_inte_mora_puni_gaad, 0) then
        if bcab.cabe_inte_mora_puni_cobr <
           nvl(v_impo_maxi_desc_inte_user, 0) then
        
          if parameter.p_clie_desc_inte > 0 then
            if bcab.cabe_inte_mora_puni_cobr <
               nvl(v_impo_maxi_desc_inte_clie, 0) then
              pl_me('El descuento de interes es mayor al autorizado para el cliente.');
            else
              parameter.p_indi_auto := 'S';
            end if;
            /*if bcab.cabe_inte_mora_puni_cobr<0 THEN
            pl_me('El descuento de interes es mayor al autorizado para el cliente.');
            END IF;*/
          else
            pl_me('El descuento de interes es mayor al autorizado para el usuario');
          end if;
        
        end if;
      end if;
    end if;
    setitem('P10_CABE_IMPO_MAXI_DESC_INTE', bcab.cabe_impo_maxi_desc_inte);
  end pp_validar_importe_auto_inte;
  procedure pp_validar_importe_auto_inte_1 is
    v_impo_maxi_desc_inte_user number;
    v_impo_maxi_desc_inte_clie number;
  
  begin
    v_impo_maxi_desc_inte_user := (nvl(bcab.cabe_sum_inte_mora_puni_gaad,
                                       bcab.cabe_inte_mora_puni_cobr) -
                                  (nvl(bcab.cabe_sum_inte_mora_puni_gaad,
                                        bcab.cabe_inte_mora_puni_cobr) *
                                  nvl(parameter.p_user_perf_desc_inte, 0) / 100));
    v_impo_maxi_desc_inte_clie := (nvl(bcab.cabe_sum_inte_mora_puni_gaad,
                                       bcab.cabe_inte_mora_puni_cobr) -
                                  (nvl(bcab.cabe_sum_inte_mora_puni_gaad,
                                        bcab.cabe_inte_mora_puni_cobr) *
                                  nvl(parameter.p_clie_desc_inte, 0) / 100));
    if v_impo_maxi_desc_inte_user < v_impo_maxi_desc_inte_clie then
      bcab.cabe_impo_maxi_desc_inte := v_impo_maxi_desc_inte_user;
    else
      bcab.cabe_impo_maxi_desc_inte := v_impo_maxi_desc_inte_clie;
    end if;
  
    setitem('P10_CABE_IMPO_MAXI_DESC_INTE', bcab.cabe_impo_maxi_desc_inte);
  end pp_validar_importe_auto_inte_1;
  procedure pp_validar_registro_duplicado(p_indi in char) is
    v_cant_reg number; --cantidad de registros en el bloque
    i          number;
    j          number;
    salir      exception;
    v_ant_codi number;
    v_mens     varchar2(1000);
  begin
    for bfp in cur_bfp loop
      --v_cant_reg := to_number(:system.cursor_record);
      if v_cant_reg <= 1 then
        raise salir;
      end if;
      for i in 1 .. v_cant_reg - 1 loop
        --go_record(i);
        if p_indi = 'vale' then
          v_ant_codi := bfp.vale_codi;
        elsif p_indi = 'cheq' then
          v_ant_codi := bfp.cheq_nume;
        else
          v_ant_codi := bfp.adel_codi;
        end if;
        for j in i + 1 .. v_cant_reg loop
          --go_record(j);
          if p_indi = 'vale' then
            if v_ant_codi = bfp.vale_codi then
              v_mens := 'El Nro de Vale del item ' || to_char(i) ||
                        ' se repite con el del item ' || to_char(j) || '.';
              pl_me(v_mens);
            end if;
          elsif p_indi = 'cheq' then
            if v_ant_codi = bfp.cheq_nume then
              v_mens := 'El Nro de Cheque del item ' || to_char(i) ||
                        ' se repite con el del item ' || to_char(j) || '.';
              pl_me(v_mens);
            end if;
          else
            if v_ant_codi = bfp.adel_codi then
              v_mens := 'El Nro de Adelanto del item ' || to_char(i) ||
                        ' se repite con el del item ' || to_char(j) || '.';
              pl_me(v_mens);
            end if;
          end if;
        end loop;
      end loop;
    end loop;
  exception
    when salir then
      null;
  end pp_validar_registro_duplicado;
  procedure pp_valida_campo_marcado_1 is
    v_count number := 0;
  begin
    for bdet in c_bdetalle loop
      if lower(bdet.ind_marcado) = 'x' then
        v_count := v_count + 1;
        --  bcab.tota_impo_inte_puni      := nvl(bcab.tota_impo_inte_puni, 0) +
        -- nvl(bdet.impo_inte_puni, 0);
        --  bcab.tota_impo_inte_mora      := nvl(bcab.tota_impo_inte_mora, 0) +
        -- nvl(bdet.impo_inte_mora, 0);
        -- bcab.tota_impo_inte_gast_admi := nvl(bcab.tota_impo_inte_gast_admi,
        --     0) +
        ---   nvl(bdet.impo_inte_gast_admi, 0);
      
        --  raise_application_error(-20001,  bcab.tota_impo_inte_mora  + bcab.tota_impo_inte_puni);
        /*else
        :bdet.s_marca             := null;
        :bdet.impo_pago           := 0;
        :bdet.impo_pago_mmnn      := 0;
        :bdet.impo_pago_mone      := 0;
        :bdet.impo_inte_mora      := 0;---null;
        :bdet.impo_inte_puni      := 0;---null;
        :bdet.impo_inte_gast_admi := 0;---null;
        :bdet.impo_inte_mora_puni := 0;---null;*/
      end if;
    end loop;
    if nvl(v_count, 0) = 0 then
      pl_me('No existe comprobante marcado para su cancelacion. Favor, seleccione el(los) documento(s) a cancelar.');
    end if;
  end pp_valida_campo_marcado_1;
  procedure pp_valida_forma_pago is
    v_count number := 0;
  begin
    select count(*)
      into v_count
      from apex_collections_full a
     where collection_name = 'FORMA_PAGO';
    if nvl(v_count, 0) = 0 then
      pl_me('No existe Forma de pago para su cancelacion.');
    end if;
  end pp_valida_forma_pago;
  procedure pp_vali_nume_dupl_prov_1 is
    v_count number;
    v_nume  number;
  begin
    v_nume := bcab.movi_nume;
    select count(*)
      into v_count
      from come_movi
     where movi_nume = v_nume
       and movi_timo_codi = parameter.p_codi_timo
       and movi_clpr_codi = bcab.movi_clpr_codi;
    if v_count > 0 then
      pl_me('Nro documento existente, favor verifique.');
    end if;
  end;
  procedure pp_vali_nume_dupl_1 is
    v_count number;
    v_nume  number;
  begin
    v_nume := bcab.movi_nume;
    select count(*)
      into v_count
      from come_movi
     where movi_nume = v_nume
       and movi_timo_codi = parameter.p_codi_timo;
    if v_count > 0 then
      pl_me('Nro documento existente, favor verifique.');
    end if;
  end;
  ---------
  procedure pl_valida_clie_prov_cheq is
  begin
    for bfp in (select c001 fopa_codi, c014 movi_clpr_codi
                  from apex_collections_full a
                 where collection_name = 'FORMA_PAGO'
                   and c001 in ('2', '4')) loop
      if bfp.fopa_codi in ('2', '4') then
        if nvl(bfp.movi_clpr_codi, -999) <> nvl(bcab.movi_clpr_codi, -888) then
          pl_me('El codigo del cliente/proveedor de la cabecera no coincide con el del detalle del cheque');
        end if;
      end if;
    end loop;
  end pl_valida_clie_prov_cheq;
  ---------
  procedure pp_valida_importes is
  begin
    --Validacion de importes para recibos emitidos, (Cobranzas a clientes)
    if parameter.p_emit_reci = 'E' then
      if (nvl(bcab.s_impo_efec, 0) + nvl(bcab.s_impo_cheq, 0) +
         nvl(bcab.s_impo_tarj, 0) + nvl(bcab.s_impo_rete_reci, 0)) <>
         (nvl(bcab.movi_exen_mone_tota, 0) - nvl(bcab.s_impo_rete, 0)) then
        pl_me('El importe del documento menos la retencion debe ser igual al importe cobrado.');
      end if;
    end if;
    --Validacion de importes para recibos Recidos, (Pago a Proveedores)
    if parameter.p_emit_reci = 'R' then
      if (nvl(bcab.s_impo_efec, 0) + nvl(bcab.s_impo_cheq, 0) +
         nvl(bcab.s_impo_tarj, 0)) <>
         (nvl(bcab.movi_exen_mone_tota, 0) - nvl(bcab.s_impo_rete, 0)) then
        pl_me('El importe del documento menos la retencion debe ser igual al importe a pagar.');
      end if;
    end if;
    pl_valida_clie_prov_cheq;
  end pp_valida_importes;
  ---
  procedure pp_valida_cheques is
  begin
    if parameter.p_indi_vali_repe_cheq = 'S' then
      if parameter.p_emit_reci = 'E' then
        for bfp in cur_bfp loop
          if bfp.fopa_codi in ('4') then
            pp_valida_nume_cheq(bfp.cheq_nume,
                                bfp.cheq_serie,
                                bfp.cheq_banc_codi);
          end if;
        end loop;
      end if;
      if parameter.p_emit_reci = 'R' then
        for bfp in cur_bfp loop
          if bfp.fopa_codi in ('2') then
            pp_valida_nume_cheq(bfp.cheq_nume,
                                bfp.cheq_serie,
                                bfp.cheq_banc_codi);
          end if;
        end loop;
      end if;
    end if;
  end;
  -----
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
    v_movi_nume_timb           varchar2(20);
    v_movi_fech_venc_timb      date;
    v_movi_fech_oper           date;
    v_movi_excl_cont           varchar2(1);
    v_movi_impo_reca           number;
    v_movi_clpr_situ           number;
    v_movi_clpr_empl_codi_recl number;
    v_movi_clpr_sucu_nume_item number;
    v_movi_impo_mone_ii        number;
    v_movi_impo_mmnn_ii        number;
    v_movi_grav10_ii_mone      number := 0;
    v_movi_grav5_ii_mone       number := 0;
    v_movi_grav10_ii_mmnn      number := 0;
    v_movi_grav5_ii_mmnn       number := 0;
    v_movi_grav10_mone         number := 0;
    v_movi_grav5_mone          number := 0;
    v_movi_grav10_mmnn         number := 0;
    v_movi_grav5_mmnn          number := 0;
    v_movi_iva10_mone          number := 0;
    v_movi_iva5_mone           number := 0;
    v_movi_iva10_mmnn          number := 0;
    v_movi_iva5_mmnn           number := 0;
    v_movi_empl_codi_agen      number;
    v_movi_nume_orde_pago      number(20);
    v_movi_indi_auto_impr      varchar2(1);
  begin
    --- asignar valores....
    bcab.movi_codi      := fa_sec_come_movi;
    bcab.movi_timo_codi := parameter.p_codi_timo;
    general_skn.pl_muestra_come_tipo_movi(bcab.movi_timo_codi,
                                          bcab.movi_timo_desc,
                                          bcab.movi_timo_desc_abre,
                                          bcab.movi_afec_sald,
                                          bcab.movi_dbcr);
    bcab.movi_fech_grab := sysdate;
    -- bcab.movi_emit_reci := parameter.p_emit_reci;
    bcab.movi_tasa_mmee   := 0;
    bcab.movi_grav_mmnn   := 0;
    bcab.movi_iva_mmnn    := 0;
    bcab.movi_grav_mmee   := 0;
    bcab.movi_exen_mmee   := 0;
    bcab.movi_iva_mmee    := 0;
    bcab.movi_grav_mone   := 0;
    bcab.movi_iva_mone    := 0;
    bcab.movi_sald_mmnn   := 0;
    bcab.movi_sald_mmee   := 0;
    bcab.movi_sald_mone   := 0;
    v_movi_codi           := bcab.movi_codi;
    v_movi_timo_codi      := bcab.movi_timo_codi;
    v_movi_clpr_codi      := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig := null;
    v_movi_sucu_codi_dest := null;
    v_movi_depo_codi_dest := null;
    v_movi_oper_codi      := null;
    v_movi_cuen_codi      := null; --bcab.movi_cuen_codi;
    v_movi_mone_codi      := bcab.movi_mone_codi;
    v_movi_nume           := bcab.movi_nume;
    v_movi_nume_orde_pago := bcab.movi_nume_orde_pago;
    v_movi_fech_emis      := bcab.movi_fech_emis;
    v_movi_fech_oper      := bcab.movi_fech_oper;
    v_movi_fech_grab      := bcab.movi_fech_grab;
    v_movi_user           := g_user;
    v_movi_codi_padr      := null;
    v_movi_tasa_mone      := bcab.movi_tasa_mone;
    v_movi_tasa_mmee      := null;
    v_movi_grav_mmnn      := nvl(bcab.movi_grav_mmnn, 0);
    --bcab.movi_exen_mmnn := round(bcab.movi_exen_mone * bcab.movi_tasa_mone, parameter.p_cant_deci_mmnn);
    v_movi_exen_mmnn           := bcab.movi_exen_mmnn /*nvl(bcab.movi_exen_mmnn, 0) +
                                                                            round(nvl(bcab.cabe_inte_mora_puni_cobr, 0) *
                                                                                  nvl(bcab.movi_tasa_mone, 1),
                                                                                  bcab.movi_mone_cant_deci)*/
     ;
    v_movi_iva_mmnn            := nvl(bcab.movi_iva_mmnn, 0);
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := nvl(bcab.movi_grav_mone, 0);
    v_movi_exen_mone           := nvl(bcab.movi_exen_mone_tota, 0);
    v_movi_iva_mone            := nvl(bcab.movi_iva_mone, 0);
    v_movi_obse                := bcab.movi_obse;
    v_movi_sald_mmnn           := 0;
    v_movi_sald_mmee           := 0;
    v_movi_sald_mone           := 0;
    v_movi_stoc_suma_rest      := null;
    v_movi_clpr_dire           := null;
    v_movi_clpr_tele           := null;
    v_movi_clpr_ruc            := null;
    v_movi_clpr_desc           := bcab.movi_clpr_desc;
    v_movi_emit_reci           := parameter.p_emit_reci; --bcab.movi_emit_reci;
    v_movi_afec_sald           := bcab.movi_afec_sald;
    v_movi_dbcr                := bcab.movi_dbcr;
    v_movi_stoc_afec_cost_prom := null;
    v_movi_empr_codi           := bcab.movi_empr_codi;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := bcab.movi_empl_codi;
    v_movi_empl_codi_agen      := bcab.s_clpr_agen_codi;
    v_movi_nume_timb           := null;
    v_movi_fech_venc_timb      := null;
    v_movi_impo_reca           := 0;
    v_movi_clpr_situ           := bcab.movi_clpr_situ;
    v_movi_clpr_empl_codi_recl := bcab.movi_clpr_empl_codi_recl;
    v_movi_clpr_sucu_nume_item := bcab.sucu_nume_item;
    v_movi_impo_mone_ii        := nvl(v_movi_grav_mone, 0) +
                                  nvl(v_movi_iva_mone, 0) +
                                  nvl(v_movi_exen_mone, 0);
    v_movi_impo_mmnn_ii        := nvl(v_movi_grav_mmnn, 0) +
                                  nvl(v_movi_iva_mmnn, 0) +
                                  nvl(v_movi_exen_mmnn, 0);
    if v_movi_clpr_sucu_nume_item = 0 then
      v_movi_clpr_sucu_nume_item := null;
    end if;
    v_movi_grav10_ii_mone := 0;
    v_movi_grav5_ii_mone  := 0;
    v_movi_grav10_ii_mmnn := 0;
    v_movi_grav5_ii_mmnn  := 0;
    v_movi_grav10_mone    := 0;
    v_movi_grav5_mone     := 0;
    v_movi_grav10_mmnn    := 0;
    v_movi_grav5_mmnn     := 0;
    v_movi_iva10_mone     := 0;
    v_movi_iva5_mone      := 0;
    v_movi_iva10_mmnn     := 0;
    v_movi_iva5_mmnn      := 0;
    v_movi_indi_auto_impr := nvl(bcab.movi_indi_auto_impr, 'N');
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
                        v_movi_impo_reca,
                        v_movi_excl_cont,
                        v_movi_clpr_situ,
                        v_movi_clpr_empl_codi_recl,
                        v_movi_clpr_sucu_nume_item,
                        v_movi_impo_mone_ii,
                        v_movi_impo_mmnn_ii,
                        v_movi_grav10_ii_mone,
                        v_movi_grav5_ii_mone,
                        v_movi_grav10_ii_mmnn,
                        v_movi_grav5_ii_mmnn,
                        v_movi_grav10_mone,
                        v_movi_grav5_mone,
                        v_movi_grav10_mmnn,
                        v_movi_grav5_mmnn,
                        v_movi_iva10_mone,
                        v_movi_iva5_mone,
                        v_movi_iva10_mmnn,
                        v_movi_iva5_mmnn,
                        v_movi_empl_codi_agen,
                        v_movi_nume_orde_pago,
                        v_movi_indi_auto_impr);
  end pp_actualiza_come_movi;
  -----
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
                                p_movi_codi_rete           in number,
                                p_movi_excl_cont           in varchar2,
                                p_movi_clpr_situ           in number,
                                p_movi_clpr_empl_codi_recl in number,
                                p_movi_clpr_sucu_nume_item in number,
                                p_movi_impo_mone_ii        in number,
                                p_movi_impo_mmnn_ii        in number,
                                p_movi_grav10_ii_mone      in number,
                                p_movi_grav5_ii_mone       in number,
                                p_movi_grav10_ii_mmnn      in number,
                                p_movi_grav5_ii_mmnn       in number,
                                p_movi_grav10_mone         in number,
                                p_movi_grav5_mone          in number,
                                p_movi_grav10_mmnn         in number,
                                p_movi_grav5_mmnn          in number,
                                p_movi_iva10_mone          in number,
                                p_movi_iva5_mone           in number,
                                p_movi_iva10_mmnn          in number,
                                p_movi_iva5_mmnn           in number,
                                p_movi_empl_codi_agen      in number,
                                p_movi_nume_orde_pago      in number,
                                p_movi_indi_auto_impr      in varchar2) is
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
       movi_clpr_sucu_nume_item,
       movi_impo_mone_ii,
       movi_impo_mmnn_ii,
       movi_grav10_ii_mone,
       movi_grav5_ii_mone,
       movi_grav10_ii_mmnn,
       movi_grav5_ii_mmnn,
       movi_grav10_mone,
       movi_grav5_mone,
       movi_grav10_mmnn,
       movi_grav5_mmnn,
       movi_iva10_mone,
       movi_iva5_mone,
       movi_iva10_mmnn,
       movi_iva5_mmnn,
       movi_empl_codi_agen,
       movi_nume_orde_pago,
       movi_indi_auto_impr)
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
       p_movi_nume_timb,
       p_movi_fech_oper,
       p_movi_fech_venc_timb,
       p_movi_codi_rete,
       p_movi_excl_cont,
       p_movi_clpr_situ,
       p_movi_clpr_empl_codi_recl,
       p_movi_clpr_sucu_nume_item,
       p_movi_impo_mone_ii,
       p_movi_impo_mmnn_ii,
       p_movi_grav10_ii_mone,
       p_movi_grav5_ii_mone,
       p_movi_grav10_ii_mmnn,
       p_movi_grav5_ii_mmnn,
       p_movi_grav10_mone,
       p_movi_grav5_mone,
       p_movi_grav10_mmnn,
       p_movi_grav5_mmnn,
       p_movi_iva10_mone,
       p_movi_iva5_mone,
       p_movi_iva10_mmnn,
       p_movi_iva5_mmnn,
       p_movi_empl_codi_agen,
       p_movi_nume_orde_pago,
       p_movi_indi_auto_impr);
  exception
    when others then
      pl_me(sqlerrm);
  end pp_insert_come_movi;
  -----
  procedure pp_actualizar_moco is
    --variables para moco
    v_moco_movi_codi number;
    --v_moco_nume_item      number;
    v_moco_conc_codi      number;
    v_moco_cuco_codi      number;
    v_moco_impu_codi      number;
    v_moco_impo_mmnn      number;
    v_moco_impo_mmee      number;
    v_moco_impo_mone      number;
    v_moco_dbcr           varchar2(1);
    v_moco_impo_mone_ii   number := 0;
    v_moco_impo_mmnn_ii   number := 0;
    v_moco_grav10_ii_mone number := 0;
    v_moco_grav5_ii_mone  number := 0;
    v_moco_grav10_ii_mmnn number := 0;
    v_moco_grav5_ii_mmnn  number := 0;
    v_moco_grav10_mone    number := 0;
    v_moco_grav5_mone     number := 0;
    v_moco_grav10_mmnn    number := 0;
    v_moco_grav5_mmnn     number := 0;
    v_moco_iva10_mone     number := 0;
    v_moco_iva5_mone      number := 0;
    v_moco_iva10_mmnn     number := 0;
    v_moco_iva5_mmnn      number := 0;
    v_moco_exen_mone      number := 0;
    v_moco_exen_mmnn      number := 0;
    v_moco_conc_codi_impu number;
    v_moco_tipo           varchar2(1);
  begin
    ----actualizar moco....
    v_moco_movi_codi := bcab.movi_codi;
    --v_moco_nume_item := 0;
    v_moco_conc_codi := v('p10_codi_conc'); --parameter.p_codi_conc;
    v_moco_dbcr      := bcab.movi_dbcr;
    --v_moco_nume_item    := v_moco_nume_item + 1;
    bcab.moco_nume_item := bcab.moco_nume_item + 1;
    v_moco_cuco_codi    := null;
    v_moco_impu_codi    := parameter.p_codi_impu_exen;
    -----Se resta del total los importe de gasto-admi/interes por mora y punitario
    -----ya que desde ahora ya no genera el tipo de movimiento 3 segun pedido de Sol gimenez 18/08/2023
    -----se le resta la diferencia por pedido de Sol Gimenez 15/09/2023
    v_moco_impo_mmnn      := round((nvl(bcab.movi_exen_mone_tota, 0) -
                                   nvl(bcab.s_dife, 0)) *
                                   nvl(bcab.movi_tasa_mone, 1),
                                   bcab.movi_mone_cant_deci) -
                             round((nvl(bcab.sum_inte_mora_puni, 0)) *
                                   nvl(bcab.movi_tasa_mone, 1),
                                   bcab.movi_mone_cant_deci);
    v_moco_impo_mmee      := 0;
    v_moco_impo_mone      := (nvl(bcab.movi_exen_mone_tota, 0) -
                             nvl(bcab.s_dife, 0)) -
                             nvl(bcab.sum_inte_mora_puni, 0);
    v_moco_impo_mone_ii   := v_moco_impo_mone;
    v_moco_impo_mmnn_ii   := v_moco_impo_mmnn;
    v_moco_grav10_ii_mone := 0;
    v_moco_grav5_ii_mone  := 0;
    v_moco_grav10_ii_mmnn := 0;
    v_moco_grav5_ii_mmnn  := 0;
    v_moco_grav10_mone    := 0;
    v_moco_grav5_mone     := 0;
    v_moco_grav10_mmnn    := 0;
    v_moco_grav5_mmnn     := 0;
    v_moco_iva10_mone     := 0;
    v_moco_iva5_mone      := 0;
    v_moco_iva10_mmnn     := 0;
    v_moco_iva5_mmnn      := 0;
    v_moco_exen_mone      := v_moco_impo_mone;
    v_moco_exen_mmnn      := v_moco_impo_mmnn;
    v_moco_conc_codi_impu := null;
    v_moco_tipo           := null;
  
    -- RAISE_APPLICATION_ERROR(-20001,v_moco_impo_mone);
    pp_insert_movi_conc_deta(v_moco_movi_codi,
                             bcab.moco_nume_item,
                             v_moco_conc_codi,
                             v_moco_cuco_codi,
                             v_moco_impu_codi,
                             v_moco_impo_mmnn,
                             v_moco_impo_mmee,
                             v_moco_impo_mone,
                             v_moco_dbcr,
                             null,
                             null,
                             null,
                             v_moco_impo_mone_ii,
                             v_moco_impo_mmnn_ii,
                             v_moco_grav10_ii_mone,
                             v_moco_grav5_ii_mone,
                             v_moco_grav10_ii_mmnn,
                             v_moco_grav5_ii_mmnn,
                             v_moco_grav10_mone,
                             v_moco_grav5_mone,
                             v_moco_grav10_mmnn,
                             v_moco_grav5_mmnn,
                             v_moco_iva10_mone,
                             v_moco_iva5_mone,
                             v_moco_iva10_mmnn,
                             v_moco_iva5_mmnn,
                             v_moco_exen_mone,
                             v_moco_exen_mmnn,
                             v_moco_conc_codi_impu,
                             v_moco_tipo);
  end pp_actualizar_moco;
  -----
  procedure pp_actualizar_moimpu is
    v_impo_mone           number := 0;
    v_impo_mmnn           number := 0;
    v_moim_impo_mone_ii   number := 0;
    v_moim_impo_mmnn_ii   number := 0;
    v_moim_grav10_ii_mone number := 0;
    v_moim_grav5_ii_mone  number := 0;
    v_moim_grav10_ii_mmnn number := 0;
    v_moim_grav5_ii_mmnn  number := 0;
    v_moim_grav10_mone    number := 0;
    v_moim_grav5_mone     number := 0;
    v_moim_grav10_mmnn    number := 0;
    v_moim_grav5_mmnn     number := 0;
    v_moim_iva10_mone     number := 0;
    v_moim_iva5_mone      number := 0;
    v_moim_iva10_mmnn     number := 0;
    v_moim_iva5_mmnn      number := 0;
    v_moim_exen_mone      number := 0;
    v_moim_exen_mmnn      number := 0;
  begin
    v_impo_mone := nvl(bcab.movi_exen_mone_tota, 0);
    --v_impo_mone := :bdet.sum_impo_pago;
    v_impo_mmnn           := round(v_impo_mone * bcab.movi_tasa_mone);
    v_moim_impo_mone_ii   := v_impo_mone;
    v_moim_impo_mmnn_ii   := v_impo_mmnn;
    v_moim_grav10_ii_mone := 0;
    v_moim_grav5_ii_mone  := 0;
    v_moim_grav10_ii_mmnn := 0;
    v_moim_grav5_ii_mmnn  := 0;
    v_moim_grav10_mone    := 0;
    v_moim_grav5_mone     := 0;
    v_moim_grav10_mmnn    := 0;
    v_moim_grav5_mmnn     := 0;
    v_moim_iva10_mone     := 0;
    v_moim_iva5_mone      := 0;
    v_moim_iva10_mmnn     := 0;
    v_moim_iva5_mmnn      := 0;
    v_moim_exen_mone      := v_impo_mone;
    v_moim_exen_mmnn      := v_impo_mmnn;
    --actualizar moim...
    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  bcab.movi_codi,
                                  v_impo_mmnn, --bcab.movi_exen_mmnn,
                                  0,
                                  0,
                                  0,
                                  v_impo_mone, --bcab.movi_exen_mone,
                                  0,
                                  null,
                                  v_moim_impo_mone_ii,
                                  v_moim_impo_mmnn_ii,
                                  v_moim_grav10_ii_mone,
                                  v_moim_grav5_ii_mone,
                                  v_moim_grav10_ii_mmnn,
                                  v_moim_grav5_ii_mmnn,
                                  v_moim_grav10_mone,
                                  v_moim_grav5_mone,
                                  v_moim_grav10_mmnn,
                                  v_moim_grav5_mmnn,
                                  v_moim_iva10_mone,
                                  v_moim_iva5_mone,
                                  v_moim_iva10_mmnn,
                                  v_moim_iva5_mmnn,
                                  v_moim_exen_mone,
                                  v_moim_exen_mmnn);
  end pp_actualizar_moimpu;
  -----
  procedure pp_insertar_cance is
    v_dife_sald      number;
    v_veri_sald      varchar2(1) := 'S';
    v_impo_pago_mmnn number;
    -- v_indi_afec_sald varchar2(1);
  begin
    for bdet in c_bdetalle loop
      if bdet.impo_pago_mone > 0 then
        if v_veri_sald = 'S' then
          v_dife_sald      := bdet.sum_impo_pago_mmnn -
                              (bcab.movi_exen_mmnn - bcab.s_dife_mmnn);
          v_impo_pago_mmnn := bdet.impo_pago_mmnn - nvl(v_dife_sald, 0);
          v_veri_sald      := 'N';
        else
          v_impo_pago_mmnn := bdet.impo_pago_mmnn;
        end if;
        insert into come_movi_cuot_canc
          (canc_movi_codi,
           canc_cuot_movi_codi,
           canc_cuot_fech_venc,
           canc_fech_pago,
           canc_impo_mone,
           canc_impo_mmnn,
           canc_impo_mmee,
           canc_base,
           canc_impo_dife_camb,
           canc_impo_rete_mone,
           canc_impo_rete_mmnn,
           canc_impo_inte_mora_acob,
           canc_impo_inte_mora_cobr,
           canc_impo_inte_puni_acob,
           canc_impo_inte_puni_cobr,
           canc_impo_gast_admi_acob,
           canc_impo_gast_admi_cobr,
           canc_indi_afec_sald)
        values
          (bcab.movi_codi,
           bdet.movi_codi,
           bdet.cuot_fech_venc,
           bcab.movi_fech_emis,
           bdet.impo_pago_mone,
           round(((bdet.impo_pago_mone) * bcab.movi_tasa_mone),
                 parameter.p_cant_deci_mmnn), -- bdet.impo_pago_mmnn,
           0,
           1, --:parameter.p_codi_base,
           round(((nvl(bcab.movi_tasa_mone, 0) -
                 nvl(bdet.cuot_tasa_mone, 0)) * bdet.impo_pago_mone),
                 0),
           bdet.impo_rete_mone,
           round((bdet.impo_rete_mone * bcab.movi_tasa_mone), 0),
           bdet.impo_inte_mora_orig,
           bdet.impo_inte_mora,
           bdet.impo_inte_puni_orig,
           bdet.impo_inte_puni,
           bdet.impo_inte_gast_admi_orig,
           bdet.impo_inte_gaad,
           'S');
      end if;
    end loop;
  end pp_insertar_cance;
  -----
  procedure pp_actualiza_come_movi_mora is
    /*v_movi_codi      number; 
      v_movi_timo_codi number;  
      v_movi_nume number;
      v_movi_fech_grab date;
      v_movi_user      varchar2(500);
      v_movi_emit_reci varchar2(500);
      v_movi_tasa_mmee number(20,4);
      v_movi_grav_mmnn number(20,4);
      v_movi_iva_mmnn number(20,4);
      v_movi_grav_mmee number(20,4);
      v_movi_exen_mmee number(20,4);
      v_movi_iva_mmee number(20,4);
      v_movi_grav_mone number(20,4);
      v_movi_iva_mone number(20,4);
      v_movi_sald_mmnn number(20,4);
      v_movi_sald_mmee number(20,4);
      v_movi_sald_mone number(20,4);
      v_movi_clpr_codi number;
      v_movi_exen_mmnn      number;
      v_movi_exen_mone      number;
      v_movi_afec_sald      varchar2(1);
      v_movi_dbcr           varchar2(1);
      v_movi_nume_timb      varchar2(20);
      v_movi_fech_venc_timb date;  
      v_movi_impo_mone_ii   number;
      v_movi_impo_mmnn_ii   number;
      v_movi_grav10_ii_mone number := 0;
      v_movi_grav5_ii_mone  number := 0;
      v_movi_grav10_ii_mmnn number := 0;
      v_movi_grav5_ii_mmnn  number := 0;
      v_movi_grav10_mone number := 0;
      v_movi_grav5_mone  number := 0;
      v_movi_grav10_mmnn    number := 0;
      v_movi_grav5_mmnn     number := 0;
      v_movi_iva10_mone number := 0;
      v_movi_iva5_mone  number := 0;
      v_movi_iva10_mmnn     number := 0;
      v_movi_iva5_mmnn      number := 0;  
      v_movi_timo_desc           varchar2(100);
      v_movi_timo_desc_abre      varchar2(100);
      v_impu_codi                number;
      v_timo_calc_iva            varchar2(1);
      v_impu_porc                number;
      v_impu_porc_base_impo      number;
      v_impu_indi_baim_impu_incl varchar2(1);
      v_pu_movi_impo_mone_ii     number; --puni
      v_pu_movi_impo_mmnn_ii     number;
      v_pu_movi_grav10_ii_mone   number := 0;
      v_pu_movi_grav5_ii_mone    number := 0;
      v_pu_movi_grav10_ii_mmnn   number := 0;
      v_pu_movi_grav5_ii_mmnn    number := 0;
      v_pu_movi_grav10_mone      number := 0;
      v_pu_movi_grav5_mone       number := 0;
      v_pu_movi_grav10_mmnn      number := 0;
      v_pu_movi_grav5_mmnn       number := 0;
      v_pu_movi_iva10_mone       number := 0;
      v_pu_movi_iva5_mone        number := 0;
      v_pu_movi_iva10_mmnn       number := 0;
      v_pu_movi_iva5_mmnn        number := 0;
      v_pu_movi_exen_mone        number := 0;
      v_pu_movi_exen_mmnn        number := 0;
      v_mo_movi_impo_mone_ii        number; --mora
      v_mo_movi_impo_mmnn_ii        number;
      v_mo_movi_grav10_ii_mone      number := 0;
      v_mo_movi_grav5_ii_mone       number := 0;
      v_mo_movi_grav10_ii_mmnn      number := 0;
      v_mo_movi_grav5_ii_mmnn       number := 0;
      v_mo_movi_grav10_mone         number := 0;
      v_mo_movi_grav5_mone          number := 0;
      v_mo_movi_grav10_mmnn         number := 0;
      v_mo_movi_grav5_mmnn          number := 0;
      v_mo_movi_iva10_mone          number := 0;
      v_mo_movi_iva5_mone           number := 0;
      v_mo_movi_iva10_mmnn          number := 0;
      v_mo_movi_iva5_mmnn           number := 0;
      v_mo_movi_exen_mone           number := 0;
      v_mo_movi_exen_mmnn           number := 0;
      v_ga_movi_impo_mone_ii        number; --gast admi
      v_ga_movi_impo_mmnn_ii        number;
      v_ga_movi_grav10_ii_mone      number := 0;
      v_ga_movi_grav5_ii_mone       number := 0;
      v_ga_movi_grav10_ii_mmnn      number := 0;
      v_ga_movi_grav5_ii_mmnn       number := 0;
      v_ga_movi_grav10_mone         number := 0;
      v_ga_movi_grav5_mone          number := 0;
      v_ga_movi_grav10_mmnn         number := 0;
      v_ga_movi_grav5_mmnn          number := 0;
      v_ga_movi_iva10_mone          number := 0;
      v_ga_movi_iva5_mone           number := 0;
      v_ga_movi_iva10_mmnn          number := 0;
      v_ga_movi_iva5_mmnn           number := 0;
      v_ga_movi_exen_mone           number := 0;
      v_ga_movi_exen_mmnn           number := 0;
      v_pu_impu_codi                number; --pumi
      v_pu_impu_porc                number;
      v_pu_impu_porc_base_impo      number;
      v_pu_impu_indi_baim_impu_incl varchar2(1);
      v_mo_impu_codi                number; --mora
      v_mo_impu_porc                number;
      v_mo_impu_porc_base_impo      number;
      v_mo_impu_indi_baim_impu_incl varchar2(1);
      v_ga_impu_codi                number; --gast admi
      v_ga_impu_porc                number;
      v_ga_impu_porc_base_impo      number;
      v_ga_impu_indi_baim_impu_incl varchar2(1);
      --variables para moco
      v_moco_conc_codi           number;
      v_moco_conc_codi_puni      number;
      v_moco_conc_codi_mora      number;
      v_moco_conc_codi_gast_admi number;  
      --variables para moco_puni
      v_pu_moco_movi_codi number;
      --v_pu_moco_nume_item number;
      v_pu_moco_conc_codi number;
      --v_pu_moco_conc_codi_mora number;
      v_pu_moco_cuco_codi      number;
      v_pu_moco_impu_codi      number;
      v_pu_moco_impo_mmnn      number;
      v_pu_moco_impo_mmee      number;
      v_pu_moco_impo_mone      number;
      v_pu_moco_dbcr           char(1);
      v_pu_moco_impo_mone_ii   number := 0;
      v_pu_moco_impo_mmnn_ii   number := 0;
      v_pu_moco_grav10_ii_mone number := 0;
      v_pu_moco_grav5_ii_mone  number := 0;
      v_pu_moco_grav10_ii_mmnn number := 0;
      v_pu_moco_grav5_ii_mmnn  number := 0;
      v_pu_moco_grav10_mone    number := 0;
      v_pu_moco_grav5_mone     number := 0;
      v_pu_moco_grav10_mmnn    number := 0;
      v_pu_moco_grav5_mmnn     number := 0;
      v_pu_moco_iva10_mone     number := 0;
      v_pu_moco_iva5_mone      number := 0;
      v_pu_moco_iva10_mmnn     number := 0;
      v_pu_moco_iva5_mmnn      number := 0;
      v_pu_moco_exen_mone      number := 0;
      v_pu_moco_exen_mmnn      number := 0;
      v_pu_moco_conc_codi_impu number;
      v_pu_moco_tipo           varchar2(1);
      --variables para moco_mora
      v_mo_moco_movi_codi number;
      v_mo_moco_nume_item      number;
      v_mo_moco_conc_codi      number;
      v_mo_moco_cuco_codi      number;
      v_mo_moco_impu_codi      number;
      v_mo_moco_impo_mmnn      number;
      v_mo_moco_impo_mmee      number;
      v_mo_moco_impo_mone      number;
      v_mo_moco_dbcr           char(1);
      v_mo_moco_impo_mone_ii   number := 0;
      v_mo_moco_impo_mmnn_ii   number := 0;
      v_mo_moco_grav10_ii_mone number := 0;
      v_mo_moco_grav5_ii_mone  number := 0;
      v_mo_moco_grav10_ii_mmnn number := 0;
      v_mo_moco_grav5_ii_mmnn  number := 0;
      v_mo_moco_grav10_mone    number := 0;
      v_mo_moco_grav5_mone     number := 0;
      v_mo_moco_grav10_mmnn    number := 0;
      v_mo_moco_grav5_mmnn     number := 0;
      v_mo_moco_iva10_mone     number := 0;
      v_mo_moco_iva5_mone      number := 0;
      v_mo_moco_iva10_mmnn     number := 0;
      v_mo_moco_iva5_mmnn      number := 0;
      v_mo_moco_exen_mone      number := 0;
      v_mo_moco_exen_mmnn      number := 0;
      v_mo_moco_conc_codi_impu number;
      v_mo_moco_tipo           varchar2(1);
    --  variables para moco_mora
      v_ga_moco_movi_codi number;
      v_ga_moco_nume_item number;
      v_ga_moco_conc_codi number;
      v_ga_moco_conc_codi_mora number;
      v_ga_moco_cuco_codi      number;
      v_ga_moco_impu_codi      number;
      v_ga_moco_impo_mmnn      number;
      v_ga_moco_impo_mmee      number;
      v_ga_moco_impo_mone      number;
      v_ga_moco_dbcr           char(1);
      v_ga_moco_impo_mone_ii   number := 0;
      v_ga_moco_impo_mmnn_ii   number := 0;
      v_ga_moco_grav10_ii_mone number := 0;
      v_ga_moco_grav5_ii_mone  number := 0;
      v_ga_moco_grav10_ii_mmnn number := 0;
      v_ga_moco_grav5_ii_mmnn  number := 0;
      v_ga_moco_grav10_mone    number := 0;
      v_ga_moco_grav5_mone     number := 0;
      v_ga_moco_grav10_mmnn    number := 0;
      v_ga_moco_grav5_mmnn     number := 0;
      v_ga_moco_iva10_mone     number := 0;
      v_ga_moco_iva5_mone      number := 0;
      v_ga_moco_iva10_mmnn     number := 0;
      v_ga_moco_iva5_mmnn      number := 0;
      v_ga_moco_exen_mone      number := 0;
      v_ga_moco_exen_mmnn      number := 0;
      v_impo_inte_mora_puni    number := 0;
      v_ga_moco_conc_codi_impu number;
      v_ga_moco_tipo           varchar2(1);
      --variables para come_movi_impu
    
    */
    v_valo_suma                   number;
    v_movi_codi                   number;
    v_movi_timo_codi              number;
    v_movi_clpr_codi              number;
    v_movi_sucu_codi_orig         number;
    v_movi_depo_codi_orig         number;
    v_movi_sucu_codi_dest         number;
    v_movi_depo_codi_dest         number;
    v_movi_oper_codi              number;
    v_movi_cuen_codi              number;
    v_movi_mone_codi              number;
    v_movi_nume                   number;
    v_movi_nume_orde_pago         number;
    v_movi_fech_emis              date;
    v_movi_fech_grab              date;
    v_movi_user                   varchar2(20);
    v_movi_codi_padr              number;
    v_movi_tasa_mone              number;
    v_movi_tasa_mmee              number;
    v_movi_grav_mmnn              number;
    v_movi_exen_mmnn              number;
    v_movi_iva_mmnn               number;
    v_movi_grav_mmee              number;
    v_movi_exen_mmee              number;
    v_movi_iva_mmee               number;
    v_movi_grav_mone              number;
    v_movi_exen_mone              number;
    v_movi_iva_mone               number;
    v_movi_obse                   varchar2(2000);
    v_movi_sald_mmnn              number;
    v_movi_sald_mmee              number;
    v_movi_sald_mone              number;
    v_movi_stoc_suma_rest         varchar2(1);
    v_movi_clpr_dire              varchar2(100);
    v_movi_clpr_tele              varchar2(50);
    v_movi_clpr_ruc               varchar2(20);
    v_movi_clpr_desc              varchar2(80);
    v_movi_emit_reci              varchar2(1);
    v_movi_afec_sald              varchar2(1);
    v_movi_dbcr                   varchar2(1);
    v_movi_stoc_afec_cost_prom    varchar2(1);
    v_movi_empr_codi              number;
    v_movi_clave_orig             number;
    v_movi_clave_orig_padr        number;
    v_movi_indi_iva_incl          varchar2(1);
    v_movi_empl_codi              number;
    v_movi_nume_timb              varchar2(20);
    v_movi_fech_venc_timb         date;
    v_movi_fech_oper              date;
    v_movi_excl_cont              varchar2(1);
    v_movi_impo_reca              number;
    v_movi_clpr_situ              number;
    v_movi_clpr_empl_codi_recl    number;
    v_movi_clpr_sucu_nume_item    number;
    v_movi_impo_mone_ii           number;
    v_movi_impo_mmnn_ii           number;
    v_movi_grav10_ii_mone         number := 0;
    v_movi_grav5_ii_mone          number := 0;
    v_movi_grav10_ii_mmnn         number := 0;
    v_movi_grav5_ii_mmnn          number := 0;
    v_movi_grav10_mone            number := 0;
    v_movi_grav5_mone             number := 0;
    v_movi_grav10_mmnn            number := 0;
    v_movi_grav5_mmnn             number := 0;
    v_movi_iva10_mone             number := 0;
    v_movi_iva5_mone              number := 0;
    v_movi_iva10_mmnn             number := 0;
    v_movi_iva5_mmnn              number := 0;
    v_movi_empl_codi_agen         number;
    v_movi_timo_desc              varchar2(100);
    v_movi_timo_desc_abre         varchar2(100);
    v_impu_codi                   number;
    v_timo_calc_iva               varchar2(1);
    v_impu_porc                   number;
    v_impu_porc_base_impo         number;
    v_impu_indi_baim_impu_incl    varchar2(1);
    v_pu_movi_impo_mone_ii        number; --puni
    v_pu_movi_impo_mmnn_ii        number;
    v_pu_movi_grav10_ii_mone      number := 0;
    v_pu_movi_grav5_ii_mone       number := 0;
    v_pu_movi_grav10_ii_mmnn      number := 0;
    v_pu_movi_grav5_ii_mmnn       number := 0;
    v_pu_movi_grav10_mone         number := 0;
    v_pu_movi_grav5_mone          number := 0;
    v_pu_movi_grav10_mmnn         number := 0;
    v_pu_movi_grav5_mmnn          number := 0;
    v_pu_movi_iva10_mone          number := 0;
    v_pu_movi_iva5_mone           number := 0;
    v_pu_movi_iva10_mmnn          number := 0;
    v_pu_movi_iva5_mmnn           number := 0;
    v_pu_movi_exen_mone           number := 0;
    v_pu_movi_exen_mmnn           number := 0;
    v_mo_movi_impo_mone_ii        number; --mora
    v_mo_movi_impo_mmnn_ii        number;
    v_mo_movi_grav10_ii_mone      number := 0;
    v_mo_movi_grav5_ii_mone       number := 0;
    v_mo_movi_grav10_ii_mmnn      number := 0;
    v_mo_movi_grav5_ii_mmnn       number := 0;
    v_mo_movi_grav10_mone         number := 0;
    v_mo_movi_grav5_mone          number := 0;
    v_mo_movi_grav10_mmnn         number := 0;
    v_mo_movi_grav5_mmnn          number := 0;
    v_mo_movi_iva10_mone          number := 0;
    v_mo_movi_iva5_mone           number := 0;
    v_mo_movi_iva10_mmnn          number := 0;
    v_mo_movi_iva5_mmnn           number := 0;
    v_mo_movi_exen_mone           number := 0;
    v_mo_movi_exen_mmnn           number := 0;
    v_ga_movi_impo_mone_ii        number; --gast admi
    v_ga_movi_impo_mmnn_ii        number;
    v_ga_movi_grav10_ii_mone      number := 0;
    v_ga_movi_grav5_ii_mone       number := 0;
    v_ga_movi_grav10_ii_mmnn      number := 0;
    v_ga_movi_grav5_ii_mmnn       number := 0;
    v_ga_movi_grav10_mone         number := 0;
    v_ga_movi_grav5_mone          number := 0;
    v_ga_movi_grav10_mmnn         number := 0;
    v_ga_movi_grav5_mmnn          number := 0;
    v_ga_movi_iva10_mone          number := 0;
    v_ga_movi_iva5_mone           number := 0;
    v_ga_movi_iva10_mmnn          number := 0;
    v_ga_movi_iva5_mmnn           number := 0;
    v_ga_movi_exen_mone           number := 0;
    v_ga_movi_exen_mmnn           number := 0;
    v_pu_impu_codi                number; --pumi
    v_pu_timo_calc_iva            varchar2(1);
    v_pu_impu_porc                number;
    v_pu_impu_porc_base_impo      number;
    v_pu_impu_indi_baim_impu_incl varchar2(1);
    v_mo_impu_codi                number; --mora
    v_mo_timo_calc_iva            varchar2(1);
    v_mo_impu_porc                number;
    v_mo_impu_porc_base_impo      number;
    v_mo_impu_indi_baim_impu_incl varchar2(1);
    v_ga_impu_codi                number; --gast admi
    v_ga_timo_calc_iva            varchar2(1);
    v_ga_impu_porc                number;
    v_ga_impu_porc_base_impo      number;
    v_ga_impu_indi_baim_impu_incl varchar2(1);
    --variables para moco
    v_moco_movi_codi           number;
    v_moco_nume_item           number;
    v_moco_conc_codi           number;
    v_moco_conc_codi_puni      number;
    v_moco_conc_codi_mora      number;
    v_moco_conc_codi_gast_admi number;
    v_moco_cuco_codi           number;
    v_moco_impu_codi           number;
    v_moco_impo_mmnn           number;
    v_moco_impo_mmee           number;
    v_moco_impo_mone           number;
    v_moco_dbcr                char(1);
    v_moco_impo_mone_ii        number := 0;
    v_moco_impo_mmnn_ii        number := 0;
    v_moco_grav10_ii_mone      number := 0;
    v_moco_grav5_ii_mone       number := 0;
    v_moco_grav10_ii_mmnn      number := 0;
    v_moco_grav5_ii_mmnn       number := 0;
    v_moco_grav10_mone         number := 0;
    v_moco_grav5_mone          number := 0;
    v_moco_grav10_mmnn         number := 0;
    v_moco_grav5_mmnn          number := 0;
    v_moco_iva10_mone          number := 0;
    v_moco_iva5_mone           number := 0;
    v_moco_iva10_mmnn          number := 0;
    v_moco_iva5_mmnn           number := 0;
    v_moco_exen_mone           number := 0;
    v_moco_exen_mmnn           number := 0;
    --variables para moco_puni
    v_pu_moco_movi_codi      number;
    v_pu_moco_nume_item      number;
    v_pu_moco_conc_codi      number;
    v_pu_moco_conc_codi_mora number;
    v_pu_moco_cuco_codi      number;
    v_pu_moco_impu_codi      number;
    v_pu_moco_impo_mmnn      number;
    v_pu_moco_impo_mmee      number;
    v_pu_moco_impo_mone      number;
    v_pu_moco_dbcr           char(1);
    v_pu_moco_impo_mone_ii   number := 0;
    v_pu_moco_impo_mmnn_ii   number := 0;
    v_pu_moco_grav10_ii_mone number := 0;
    v_pu_moco_grav5_ii_mone  number := 0;
    v_pu_moco_grav10_ii_mmnn number := 0;
    v_pu_moco_grav5_ii_mmnn  number := 0;
    v_pu_moco_grav10_mone    number := 0;
    v_pu_moco_grav5_mone     number := 0;
    v_pu_moco_grav10_mmnn    number := 0;
    v_pu_moco_grav5_mmnn     number := 0;
    v_pu_moco_iva10_mone     number := 0;
    v_pu_moco_iva5_mone      number := 0;
    v_pu_moco_iva10_mmnn     number := 0;
    v_pu_moco_iva5_mmnn      number := 0;
    v_pu_moco_exen_mone      number := 0;
    v_pu_moco_exen_mmnn      number := 0;
    v_pu_moco_conc_codi_impu number;
    v_pu_moco_tipo           varchar2(1);
    --variables para moco_mora
    v_mo_moco_movi_codi      number;
    v_mo_moco_nume_item      number;
    v_mo_moco_conc_codi      number;
    v_mo_moco_conc_codi_mora number;
    v_mo_moco_cuco_codi      number;
    v_mo_moco_impu_codi      number;
    v_mo_moco_impo_mmnn      number;
    v_mo_moco_impo_mmee      number;
    v_mo_moco_impo_mone      number;
    v_mo_moco_dbcr           char(1);
    v_mo_moco_impo_mone_ii   number := 0;
    v_mo_moco_impo_mmnn_ii   number := 0;
    v_mo_moco_grav10_ii_mone number := 0;
    v_mo_moco_grav5_ii_mone  number := 0;
    v_mo_moco_grav10_ii_mmnn number := 0;
    v_mo_moco_grav5_ii_mmnn  number := 0;
    v_mo_moco_grav10_mone    number := 0;
    v_mo_moco_grav5_mone     number := 0;
    v_mo_moco_grav10_mmnn    number := 0;
    v_mo_moco_grav5_mmnn     number := 0;
    v_mo_moco_iva10_mone     number := 0;
    v_mo_moco_iva5_mone      number := 0;
    v_mo_moco_iva10_mmnn     number := 0;
    v_mo_moco_iva5_mmnn      number := 0;
    v_mo_moco_exen_mone      number := 0;
    v_mo_moco_exen_mmnn      number := 0;
    v_mo_moco_conc_codi_impu number;
    v_mo_moco_tipo           varchar2(1);
    --variables para moco_mora
    v_ga_moco_movi_codi      number;
    v_ga_moco_nume_item      number;
    v_ga_moco_conc_codi      number;
    v_ga_moco_conc_codi_mora number;
    v_ga_moco_cuco_codi      number;
    v_ga_moco_impu_codi      number;
    v_ga_moco_impo_mmnn      number;
    v_ga_moco_impo_mmee      number;
    v_ga_moco_impo_mone      number;
    v_ga_moco_dbcr           char(1);
    v_ga_moco_impo_mone_ii   number := 0;
    v_ga_moco_impo_mmnn_ii   number := 0;
    v_ga_moco_grav10_ii_mone number := 0;
    v_ga_moco_grav5_ii_mone  number := 0;
    v_ga_moco_grav10_ii_mmnn number := 0;
    v_ga_moco_grav5_ii_mmnn  number := 0;
    v_ga_moco_grav10_mone    number := 0;
    v_ga_moco_grav5_mone     number := 0;
    v_ga_moco_grav10_mmnn    number := 0;
    v_ga_moco_grav5_mmnn     number := 0;
    v_ga_moco_iva10_mone     number := 0;
    v_ga_moco_iva5_mone      number := 0;
    v_ga_moco_iva10_mmnn     number := 0;
    v_ga_moco_iva5_mmnn      number := 0;
    v_ga_moco_exen_mone      number := 0;
    v_ga_moco_exen_mmnn      number := 0;
    v_ga_moco_conc_codi_impu number;
    v_ga_moco_tipo           varchar2(1);
    --variables para come_movi_impu
    v_impo_mone           number := 0;
    v_impo_mmnn           number := 0;
    v_moim_impo_mone_ii   number := 0;
    v_moim_impo_mmnn_ii   number := 0;
    v_moim_grav10_ii_mone number := 0;
    v_moim_grav5_ii_mone  number := 0;
    v_moim_grav10_ii_mmnn number := 0;
    v_moim_grav5_ii_mmnn  number := 0;
    v_moim_grav10_mone    number := 0;
    v_moim_grav5_mone     number := 0;
    v_moim_grav10_mmnn    number := 0;
    v_moim_grav5_mmnn     number := 0;
    v_moim_iva10_mone     number := 0;
    v_moim_iva5_mone      number := 0;
    v_moim_iva10_mmnn     number := 0;
    v_moim_iva5_mmnn      number := 0;
    v_moim_exen_mone      number := 0;
    v_moim_exen_mmnn      number := 0;
    v_impo_inte_mora_puni number(20, 4);
  
  begin
    --- asignar valores....
    v_movi_codi := fa_sec_come_movi;
    if nvl(parameter.p_indi_cobr_inte_bole_fact, 'B') = 'B' then
      ---si es PCOE
      v_movi_timo_codi := parameter.p_codi_timo_pcoe;
    else
      ---si es FCOE
      v_movi_timo_codi := parameter.p_codi_timo_fcoe;
    end if;
  
    pp_muestra_come_tipo_movi_inte(v_movi_timo_codi, --bcab.movi_timo_codi,
                                   v_movi_timo_desc,
                                   v_movi_timo_desc_abre,
                                   v_movi_afec_sald,
                                   v_movi_dbcr,
                                   v_timo_calc_iva);
    v_moco_conc_codi           := parameter.p_codi_conc_inte_cobr;
    v_moco_conc_codi_puni      := parameter.p_codi_conc_inte_cobr_puni;
    v_moco_conc_codi_mora      := parameter.p_codi_conc_inte_cobr_mora;
    v_moco_conc_codi_gast_admi := parameter.p_codi_conc_gast_admi_cobr;
    --recuperar el tipo de impuesto y datos del impues
    ----------------------------------------------------------
    if v_timo_calc_iva = 'S' then
      select i.impu_codi,
             i.impu_porc,
             i.impu_porc_base_impo,
             i.impu_indi_baim_impu_incl
        into v_impu_codi,
             v_impu_porc,
             v_impu_porc_base_impo,
             v_impu_indi_baim_impu_incl
        from come_conc c, come_impu i
       where conc_impu_codi = impu_codi(+)
         and conc_codi = v_moco_conc_codi;
    else
      v_impu_codi                := parameter.p_codi_impu_exen;
      v_impu_porc                := 0;
      v_impu_porc_base_impo      := 0;
      v_impu_indi_baim_impu_incl := 'N';
    end if;
    --------------
    if v_timo_calc_iva = 'S' then
      --puni
      select i.impu_codi,
             i.impu_porc,
             i.impu_porc_base_impo,
             i.impu_indi_baim_impu_incl
        into v_pu_impu_codi,
             v_pu_impu_porc,
             v_pu_impu_porc_base_impo,
             v_pu_impu_indi_baim_impu_incl
        from come_conc c, come_impu i
       where conc_impu_codi = impu_codi(+)
         and conc_codi = v_moco_conc_codi_puni;
    else
      v_pu_impu_codi                := parameter.p_codi_impu_exen;
      v_pu_impu_porc                := 0;
      v_pu_impu_porc_base_impo      := 0;
      v_pu_impu_indi_baim_impu_incl := 'N';
    end if;
    begin
      select decode(v_movi_dbcr,
                    'C',
                    impu_conc_codi_ivcr,
                    impu_conc_codi_ivdb) conc_iva
        into v_pu_moco_conc_codi_impu
        from come_impu
       where impu_codi = v_pu_impu_codi;
    exception
      when no_data_found then
        pl_me('Concepto de impuesto Interes Punitorio inexistente');
    end;
    ------------
    if v_timo_calc_iva = 'S' then
      --mora
      select i.impu_codi,
             i.impu_porc,
             i.impu_porc_base_impo,
             i.impu_indi_baim_impu_incl
        into v_mo_impu_codi,
             v_mo_impu_porc,
             v_mo_impu_porc_base_impo,
             v_mo_impu_indi_baim_impu_incl
        from come_conc c, come_impu i
       where conc_impu_codi = impu_codi(+)
         and conc_codi = v_moco_conc_codi_mora;
    else
      v_mo_impu_codi                := parameter.p_codi_impu_exen;
      v_mo_impu_porc                := 0;
      v_mo_impu_porc_base_impo      := 0;
      v_mo_impu_indi_baim_impu_incl := 'N';
    end if;
    begin
      select decode(v_movi_dbcr,
                    'C',
                    impu_conc_codi_ivcr,
                    impu_conc_codi_ivdb) conc_iva
        into v_mo_moco_conc_codi_impu
        from come_impu
       where impu_codi = v_mo_impu_codi;
    exception
      when no_data_found then
        pl_me('Concepto de impuesto Interes Moratorio inexistente');
    end;
    ------------
    if v_timo_calc_iva = 'S' then
      --gast admi
      select i.impu_codi,
             i.impu_porc,
             i.impu_porc_base_impo,
             i.impu_indi_baim_impu_incl
        into v_ga_impu_codi,
             v_ga_impu_porc,
             v_ga_impu_porc_base_impo,
             v_ga_impu_indi_baim_impu_incl
        from come_conc c, come_impu i
       where conc_impu_codi = impu_codi(+)
         and conc_codi = v_moco_conc_codi_gast_admi;
    else
      v_ga_impu_codi                := parameter.p_codi_impu_exen;
      v_ga_impu_porc                := 0;
      v_ga_impu_porc_base_impo      := 0;
      v_ga_impu_indi_baim_impu_incl := 'N';
    end if;
    begin
      select decode(v_movi_dbcr,
                    'C',
                    impu_conc_codi_ivcr,
                    impu_conc_codi_ivdb) conc_iva
        into v_ga_moco_conc_codi_impu
        from come_impu
       where impu_codi = v_ga_impu_codi;
    exception
      when no_data_found then
        pl_me('Concepto de impuesto Gasto Administrativo inexistente');
    end;
    v_movi_impo_mone_ii := nvl(bcab.cabe_inte_mora_puni_cobr, 0); --nvl(:bdet.sum_inte_mora_puni,0);
    v_movi_impo_mmnn_ii := round((v_movi_impo_mone_ii * bcab.movi_tasa_mone),
                                 0);
    ----------------------------------
    ---suma de importe punitorio y mora
    v_impo_inte_mora_puni := nvl(bcab.tota_impo_inte_puni, 0) +
                             nvl(bcab.tota_impo_inte_mora, 0);
  
    ----------------------------------
    v_pu_movi_impo_mone_ii := nvl(v_impo_inte_mora_puni, 0);
    v_pu_movi_impo_mmnn_ii := round((v_pu_movi_impo_mone_ii *
                                    bcab.movi_tasa_mone),
                                    0);
    ---------------------------------
    v_mo_movi_impo_mone_ii := nvl(v_impo_inte_mora_puni, 0);
    v_mo_movi_impo_mmnn_ii := round((v_mo_movi_impo_mone_ii *
                                    bcab.movi_tasa_mone),
                                    0);
    ---------------------------------
    v_ga_movi_impo_mone_ii := nvl(bcab.tota_impo_inte_gast_admi, 0);
    v_ga_movi_impo_mmnn_ii := round((v_ga_movi_impo_mone_ii *
                                    bcab.movi_tasa_mone),
                                    0);
    pa_devu_impo_calc(v_movi_impo_mone_ii,
                      bcab.movi_mone_cant_deci,
                      v_impu_porc,
                      v_impu_porc_base_impo,
                      v_impu_indi_baim_impu_incl,
                      v_movi_impo_mone_ii,
                      v_movi_grav10_ii_mone,
                      v_movi_grav5_ii_mone,
                      v_movi_grav10_mone,
                      v_movi_grav5_mone,
                      v_movi_iva10_mone,
                      v_movi_iva5_mone,
                      v_movi_exen_mone);
    --------------
    pa_devu_impo_calc(v_pu_movi_impo_mone_ii, --puni
                      bcab.movi_mone_cant_deci,
                      v_pu_impu_porc,
                      v_pu_impu_porc_base_impo,
                      v_pu_impu_indi_baim_impu_incl,
                      v_pu_movi_impo_mone_ii,
                      v_pu_movi_grav10_ii_mone,
                      v_pu_movi_grav5_ii_mone,
                      v_pu_movi_grav10_mone,
                      v_pu_movi_grav5_mone,
                      v_pu_movi_iva10_mone,
                      v_pu_movi_iva5_mone,
                      v_pu_movi_exen_mone);
    ---------------
    pa_devu_impo_calc(v_mo_movi_impo_mone_ii, --mora
                      bcab.movi_mone_cant_deci,
                      v_mo_impu_porc,
                      v_mo_impu_porc_base_impo,
                      v_mo_impu_indi_baim_impu_incl,
                      v_mo_movi_impo_mone_ii,
                      v_mo_movi_grav10_ii_mone,
                      v_mo_movi_grav5_ii_mone,
                      v_mo_movi_grav10_mone,
                      v_mo_movi_grav5_mone,
                      v_mo_movi_iva10_mone,
                      v_mo_movi_iva5_mone,
                      v_mo_movi_exen_mone);
    -------------
    pa_devu_impo_calc(v_ga_movi_impo_mone_ii, --gast admi
                      bcab.movi_mone_cant_deci,
                      v_ga_impu_porc,
                      v_ga_impu_porc_base_impo,
                      v_ga_impu_indi_baim_impu_incl,
                      v_ga_movi_impo_mone_ii,
                      v_ga_movi_grav10_ii_mone,
                      v_ga_movi_grav5_ii_mone,
                      v_ga_movi_grav10_mone,
                      v_ga_movi_grav5_mone,
                      v_ga_movi_iva10_mone,
                      v_ga_movi_iva5_mone,
                      v_ga_movi_exen_mone);
  
    -------------------------Calcular intereses MMNN
  
    ------Para MMNN-------------------------------------
    pa_devu_impo_calc(v_movi_impo_mmnn_ii,
                      parameter.p_cant_deci_mmnn,
                      v_impu_porc,
                      v_impu_porc_base_impo,
                      v_impu_indi_baim_impu_incl,
                      v_movi_impo_mmnn_ii,
                      v_movi_grav10_ii_mmnn,
                      v_movi_grav5_ii_mmnn,
                      v_movi_grav10_mmnn,
                      v_movi_grav5_mmnn,
                      v_movi_iva10_mmnn,
                      v_movi_iva5_mmnn,
                      v_movi_exen_mmnn);
  
    -----------------------  
    pa_devu_impo_calc(v_pu_movi_impo_mmnn_ii, --puni
                      parameter.p_cant_deci_mmnn,
                      v_pu_impu_porc,
                      v_pu_impu_porc_base_impo,
                      v_pu_impu_indi_baim_impu_incl,
                      v_pu_movi_impo_mmnn_ii,
                      v_pu_movi_grav10_ii_mmnn,
                      v_pu_movi_grav5_ii_mmnn,
                      v_pu_movi_grav10_mmnn,
                      v_pu_movi_grav5_mmnn,
                      v_pu_movi_iva10_mmnn,
                      v_pu_movi_iva5_mmnn,
                      v_pu_movi_exen_mmnn);
  
    -----------------------
    pa_devu_impo_calc(v_mo_movi_impo_mmnn_ii, --mora
                      parameter.p_cant_deci_mmnn,
                      v_mo_impu_porc,
                      v_mo_impu_porc_base_impo,
                      v_mo_impu_indi_baim_impu_incl,
                      v_mo_movi_impo_mmnn_ii,
                      v_mo_movi_grav10_ii_mmnn,
                      v_mo_movi_grav5_ii_mmnn,
                      v_mo_movi_grav10_mmnn,
                      v_mo_movi_grav5_mmnn,
                      v_mo_movi_iva10_mmnn,
                      v_mo_movi_iva5_mmnn,
                      v_mo_movi_exen_mmnn);
  
    -----------------------
    pa_devu_impo_calc(v_ga_movi_impo_mmnn_ii, --gast admi
                      parameter.p_cant_deci_mmnn,
                      v_ga_impu_porc,
                      v_ga_impu_porc_base_impo,
                      v_ga_impu_indi_baim_impu_incl,
                      v_ga_movi_impo_mmnn_ii,
                      v_ga_movi_grav10_ii_mmnn,
                      v_ga_movi_grav5_ii_mmnn,
                      v_ga_movi_grav10_mmnn,
                      v_ga_movi_grav5_mmnn,
                      v_ga_movi_iva10_mmnn,
                      v_ga_movi_iva5_mmnn,
                      v_ga_movi_exen_mmnn);
  
    parameter.p_inte_movi_dbcr := v_movi_dbcr;
    -----------------------------------------------------------
    parameter.p_inte_movi_codi := v_movi_codi;
    parameter.p_inte_movi_dbcr := v_movi_dbcr;
    v_movi_fech_grab           := sysdate;
    v_movi_user                := g_user;
    v_movi_emit_reci           := parameter.p_emit_reci;
    v_movi_tasa_mmee           := 0;
    v_movi_exen_mmnn           := v_movi_exen_mmnn;
    v_movi_grav_mmnn           := v_movi_grav10_mmnn + v_movi_grav5_mmnn;
    v_movi_iva_mmnn            := v_movi_iva10_mmnn + v_movi_iva5_mmnn;
    v_movi_grav_mmee           := 0;
    v_movi_exen_mmee           := 0;
    v_movi_iva_mmee            := 0;
    v_movi_exen_mone           := v_movi_exen_mone;
    v_movi_grav_mone           := v_movi_grav10_mone + v_movi_grav5_mone;
    v_movi_iva_mone            := v_movi_iva10_mone + v_movi_iva5_mone;
    v_movi_sald_mmnn           := 0;
    v_movi_sald_mmee           := 0;
    v_movi_sald_mone           := 0;
    v_movi_clpr_codi           := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig      := null;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := null;
    v_movi_cuen_codi           := null; --bcab.movi_cuen_codi;
    v_movi_mone_codi           := bcab.movi_mone_codi;
  
    v_valo_suma := nvl(v_movi_exen_mone, 0) + nvl(v_movi_grav10_mone, 0) +
                   nvl(v_movi_grav5_mone, 0);
  
    if nvl(parameter.p_indi_cobr_inte_bole_fact, 'B') = 'B' then
      ---si es PCOE
      v_movi_nume           := bcab.movi_nume;
      v_movi_nume_timb      := null;
      v_movi_fech_venc_timb := null;
      null;
    else
      ---si es FCOE
      pp_devu_nume_timb_fech(v('P10_PECO_CODI'),
                             v_movi_nume,
                             v_movi_nume_timb,
                             v_movi_fech_venc_timb);
      parameter.p_movi_nume_fact_inte := v_movi_nume;
    end if;
  
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_oper           := bcab.movi_fech_oper;
    v_movi_codi_padr           := bcab.movi_codi; --Recibo de Cobranza
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_obse                := null; --bcab.movi_obse;
    v_movi_stoc_suma_rest      := null;
    v_movi_clpr_dire           := null;
    v_movi_clpr_tele           := null;
    v_movi_clpr_ruc            := null;
    v_movi_clpr_desc           := bcab.movi_clpr_desc;
    v_movi_stoc_afec_cost_prom := null;
    v_movi_empr_codi           := bcab.movi_empr_codi;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := bcab.movi_empl_codi;
    v_movi_impo_reca           := 0;
    v_movi_clpr_situ           := bcab.movi_clpr_situ;
    v_movi_clpr_empl_codi_recl := bcab.movi_clpr_empl_codi_recl;
    v_movi_clpr_sucu_nume_item := bcab.sucu_nume_item;
    v_movi_excl_cont           := 'S';
    v_movi_empl_codi_agen      := bcab.s_clpr_agen_codi;
    if v_movi_clpr_sucu_nume_item = 0 then
      v_movi_clpr_sucu_nume_item := null;
    end if;
    -----validacion por moraa
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
                        v_movi_impo_reca,
                        v_movi_excl_cont,
                        v_movi_clpr_situ,
                        v_movi_clpr_empl_codi_recl,
                        v_movi_clpr_sucu_nume_item,
                        v_movi_impo_mone_ii,
                        v_movi_impo_mmnn_ii,
                        v_movi_grav10_ii_mone,
                        v_movi_grav5_ii_mone,
                        v_movi_grav10_ii_mmnn,
                        v_movi_grav5_ii_mmnn,
                        v_movi_grav10_mone,
                        v_movi_grav5_mone,
                        v_movi_grav10_mmnn,
                        v_movi_grav5_mmnn,
                        v_movi_iva10_mone,
                        v_movi_iva5_mone,
                        v_movi_iva10_mmnn,
                        v_movi_iva5_mmnn,
                        v_movi_empl_codi_agen,
                        v_movi_nume_orde_pago,
                        nvl(bcab.movi_indi_auto_impr, 'N'));
  
    -- actualizar impo come_movi_impo_deta
    --cargamos este registro para poder completar
    if nvl(parameter.p_indi_cobr_inte_bole_fact, 'B') = 'F' and
       nvl(v_valo_suma, 0) > 0 then
    
      begin
        insert into come_movi_impo_deta
          (moim_movi_codi,
           moim_nume_item,
           moim_tipo,
           moim_cuen_codi,
           moim_dbcr,
           moim_afec_caja,
           moim_fech,
           moim_impo_mone,
           moim_impo_mmnn,
           moim_base,
           moim_fech_oper,
           moim_form_pago,
           moim_impo_movi,
           moim_tasa_mone,
           moim_indi_impo_igua)
        values
          (v_movi_codi,
           1,
           'Efectivo',
           1,
           v_movi_dbcr,
           'N',
           v_movi_fech_emis,
           v_movi_impo_mone_ii,
           v_movi_impo_mmnn_ii,
           1,
           v_movi_fech_oper,
           1,
           v_movi_impo_mone_ii,
           v_movi_tasa_mone,
           'N');
      exception
        when others then
          null;
      end;
    
      ----------actualiza moco puni
      parameter.p_inte_movi_codi := bcab.movi_codi;
      v_pu_moco_movi_codi        := v_movi_codi; --parameter.p_inte_movi_codi;
      v_pu_moco_conc_codi        := parameter.p_codi_conc_inte_cobr_puni;
      v_pu_moco_dbcr             := parameter.p_inte_movi_dbcr;
      v_pu_moco_nume_item        := 1; ---cambio por nueva
      v_pu_moco_nume_item        := bcab.moco_nume_item + 1;
      v_pu_moco_cuco_codi        := null;
      v_pu_moco_impu_codi        := v_pu_impu_codi;
      v_pu_moco_impo_mmnn        := v_pu_movi_grav10_mmnn +
                                    v_pu_movi_grav5_mmnn +
                                    v_pu_movi_exen_mmnn;
      v_pu_moco_impo_mmee        := 0;
      v_pu_moco_impo_mone        := v_pu_movi_grav10_mone +
                                    v_pu_movi_grav5_mone +
                                    v_pu_movi_exen_mone;
      v_pu_moco_impo_mone_ii     := v_pu_movi_impo_mone_ii;
      v_pu_moco_impo_mmnn_ii     := v_pu_movi_impo_mmnn_ii;
      v_pu_moco_grav10_ii_mone   := v_pu_movi_grav10_ii_mone;
      v_pu_moco_grav5_ii_mone    := v_pu_movi_grav5_ii_mone;
      v_pu_moco_grav10_ii_mmnn   := v_pu_movi_grav10_ii_mmnn;
      v_pu_moco_grav5_ii_mmnn    := v_pu_movi_grav5_ii_mmnn;
      v_pu_moco_grav10_mone      := v_pu_movi_grav10_mone;
      v_pu_moco_grav5_mone       := v_pu_movi_grav5_mone;
      v_pu_moco_grav10_mmnn      := v_pu_movi_grav10_mmnn;
      v_pu_moco_grav5_mmnn       := v_pu_movi_grav5_mmnn;
      v_pu_moco_iva10_mone       := v_pu_movi_iva10_mone;
      v_pu_moco_iva5_mone        := v_pu_movi_iva5_mone;
      v_pu_moco_iva10_mmnn       := v_pu_movi_iva10_mmnn;
      v_pu_moco_iva5_mmnn        := v_pu_movi_iva5_mmnn;
      v_pu_moco_exen_mone        := v_pu_movi_exen_mone;
      v_pu_moco_exen_mmnn        := v_pu_movi_exen_mmnn;
      v_pu_moco_tipo             := 'C';
      bcab.moco_nume_item        := bcab.moco_nume_item + 1;
    
      if nvl(v_pu_movi_impo_mone_ii, 0) > 0 then
        pp_insert_movi_conc_deta(v_pu_moco_movi_codi,
                                 v_pu_moco_nume_item, --bcab.moco_nume_item, 
                                 v_pu_moco_conc_codi,
                                 v_pu_moco_cuco_codi,
                                 v_pu_moco_impu_codi,
                                 v_pu_moco_impo_mmnn,
                                 v_pu_moco_impo_mmee,
                                 v_pu_moco_impo_mone,
                                 v_pu_moco_dbcr,
                                 null,
                                 null,
                                 null,
                                 v_pu_moco_impo_mone_ii,
                                 v_pu_moco_impo_mmnn_ii,
                                 v_pu_moco_grav10_ii_mone,
                                 v_pu_moco_grav5_ii_mone,
                                 v_pu_moco_grav10_ii_mmnn,
                                 v_pu_moco_grav5_ii_mmnn,
                                 v_pu_moco_grav10_mone,
                                 v_pu_moco_grav5_mone,
                                 v_pu_moco_grav10_mmnn,
                                 v_pu_moco_grav5_mmnn,
                                 v_pu_moco_iva10_mone,
                                 v_pu_moco_iva5_mone,
                                 v_pu_moco_iva10_mmnn,
                                 v_pu_moco_iva5_mmnn,
                                 v_pu_moco_exen_mone,
                                 v_pu_moco_exen_mmnn,
                                 v_pu_moco_conc_codi_impu,
                                 v_pu_moco_tipo,
                                 'S',
                                 1);
      
      end if;
    
      ----------actualiza moco mora
      v_mo_moco_movi_codi := v_movi_codi; --parameter.p_inte_movi_codi;
      v_mo_moco_conc_codi := parameter.p_codi_conc_inte_cobr_mora;
      v_mo_moco_dbcr      := parameter.p_inte_movi_dbcr;
      v_mo_moco_nume_item := 2;
      --v_mo_moco_nume_item  := bcab.moco_nume_item+1;
      v_mo_moco_cuco_codi      := null;
      v_mo_moco_impu_codi      := v_mo_impu_codi;
      v_mo_moco_impo_mmnn      := v_mo_movi_grav10_mmnn +
                                  v_mo_movi_grav5_mmnn +
                                  v_mo_movi_exen_mmnn;
      v_mo_moco_impo_mmee      := 0;
      v_mo_moco_impo_mone      := v_mo_movi_grav10_mone +
                                  v_mo_movi_grav5_mone +
                                  v_mo_movi_exen_mone;
      v_mo_moco_impo_mone_ii   := v_mo_movi_impo_mone_ii;
      v_mo_moco_impo_mmnn_ii   := v_mo_movi_impo_mmnn_ii;
      v_mo_moco_grav10_ii_mone := v_mo_movi_grav10_ii_mone;
      v_mo_moco_grav5_ii_mone  := v_mo_movi_grav5_ii_mone;
      v_mo_moco_grav10_ii_mmnn := v_mo_movi_grav10_ii_mmnn;
      v_mo_moco_grav5_ii_mmnn  := v_mo_movi_grav5_ii_mmnn;
      v_mo_moco_grav10_mone    := v_mo_movi_grav10_mone;
      v_mo_moco_grav5_mone     := v_mo_movi_grav5_mone;
      v_mo_moco_grav10_mmnn    := v_mo_movi_grav10_mmnn;
      v_mo_moco_grav5_mmnn     := v_mo_movi_grav5_mmnn;
      v_mo_moco_iva10_mone     := v_mo_movi_iva10_mone;
      v_mo_moco_iva5_mone      := v_mo_movi_iva5_mone;
      v_mo_moco_iva10_mmnn     := v_mo_movi_iva10_mmnn;
      v_mo_moco_iva5_mmnn      := v_mo_movi_iva5_mmnn;
      v_mo_moco_exen_mone      := v_mo_movi_exen_mone;
      v_mo_moco_exen_mmnn      := v_mo_movi_exen_mmnn;
      v_mo_moco_tipo           := 'C';
      bcab.moco_nume_item      := bcab.moco_nume_item + 1;
      if NVL(v_mo_moco_impo_mone_ii, 0) > 0 then
        pp_insert_movi_conc_deta(v_mo_moco_movi_codi,
                                 v_mo_moco_nume_item, --bcab.moco_nume_item, ---
                                 v_mo_moco_conc_codi,
                                 v_mo_moco_cuco_codi,
                                 v_mo_moco_impu_codi,
                                 v_mo_moco_impo_mmnn,
                                 v_mo_moco_impo_mmee,
                                 v_mo_moco_impo_mone,
                                 v_mo_moco_dbcr,
                                 null,
                                 null,
                                 null,
                                 v_mo_moco_impo_mone_ii,
                                 v_mo_moco_impo_mmnn_ii,
                                 v_mo_moco_grav10_ii_mone,
                                 v_mo_moco_grav5_ii_mone,
                                 v_mo_moco_grav10_ii_mmnn,
                                 v_mo_moco_grav5_ii_mmnn,
                                 v_mo_moco_grav10_mone,
                                 v_mo_moco_grav5_mone,
                                 v_mo_moco_grav10_mmnn,
                                 v_mo_moco_grav5_mmnn,
                                 v_mo_moco_iva10_mone,
                                 v_mo_moco_iva5_mone,
                                 v_mo_moco_iva10_mmnn,
                                 v_mo_moco_iva5_mmnn,
                                 v_mo_moco_exen_mone,
                                 v_mo_moco_exen_mmnn,
                                 v_mo_moco_conc_codi_impu,
                                 v_mo_moco_tipo,
                                 'S',
                                 1);
      end if;
    
      ----------actualiza moco gast admi
      if nvl(v_ga_movi_impo_mone_ii, 0) > 0 then
        v_ga_moco_movi_codi      := v_movi_codi; --parameter.p_inte_movi_codi;
        v_ga_moco_conc_codi      := parameter.p_codi_conc_gast_admi_cobr;
        v_ga_moco_dbcr           := parameter.p_inte_movi_dbcr;
        v_ga_moco_nume_item      := 3;
        v_ga_moco_cuco_codi      := null;
        v_ga_moco_impu_codi      := v_ga_impu_codi;
        v_ga_moco_impo_mmnn      := v_ga_movi_grav10_mmnn +
                                    v_ga_movi_grav5_mmnn +
                                    v_ga_movi_exen_mmnn;
        v_ga_moco_impo_mmee      := 0;
        v_ga_moco_impo_mone      := v_ga_movi_grav10_mone +
                                    v_ga_movi_grav5_mone +
                                    v_ga_movi_exen_mone;
        v_ga_moco_impo_mone_ii   := v_ga_movi_impo_mone_ii;
        v_ga_moco_impo_mmnn_ii   := v_ga_movi_impo_mmnn_ii;
        v_ga_moco_grav10_ii_mone := v_ga_movi_grav10_ii_mone;
        v_ga_moco_grav5_ii_mone  := v_ga_movi_grav5_ii_mone;
        v_ga_moco_grav10_ii_mmnn := v_ga_movi_grav10_ii_mmnn;
        v_ga_moco_grav5_ii_mmnn  := v_ga_movi_grav5_ii_mmnn;
        v_ga_moco_grav10_mone    := v_ga_movi_grav10_mone;
        v_ga_moco_grav5_mone     := v_ga_movi_grav5_mone;
        v_ga_moco_grav10_mmnn    := v_ga_movi_grav10_mmnn;
        v_ga_moco_grav5_mmnn     := v_ga_movi_grav5_mmnn;
        v_ga_moco_iva10_mone     := v_ga_movi_iva10_mone;
        v_ga_moco_iva5_mone      := v_ga_movi_iva5_mone;
        v_ga_moco_iva10_mmnn     := v_ga_movi_iva10_mmnn;
        v_ga_moco_iva5_mmnn      := v_ga_movi_iva5_mmnn;
        v_ga_moco_exen_mone      := v_ga_movi_exen_mone;
        v_ga_moco_exen_mmnn      := v_ga_movi_exen_mmnn;
        v_ga_moco_tipo           := 'C';
        bcab.moco_nume_item      := bcab.moco_nume_item + 1;
        pp_insert_movi_conc_deta(v_ga_moco_movi_codi,
                                 v_ga_moco_nume_item, -- bcab.moco_nume_item, -- v_ga_moco_nume_item,
                                 v_ga_moco_conc_codi,
                                 v_ga_moco_cuco_codi,
                                 v_ga_moco_impu_codi,
                                 v_ga_moco_impo_mmnn,
                                 v_ga_moco_impo_mmee,
                                 v_ga_moco_impo_mone,
                                 v_ga_moco_dbcr,
                                 null,
                                 null,
                                 null,
                                 v_ga_moco_impo_mone_ii,
                                 v_ga_moco_impo_mmnn_ii,
                                 v_ga_moco_grav10_ii_mone,
                                 v_ga_moco_grav5_ii_mone,
                                 v_ga_moco_grav10_ii_mmnn,
                                 v_ga_moco_grav5_ii_mmnn,
                                 v_ga_moco_grav10_mone,
                                 v_ga_moco_grav5_mone,
                                 v_ga_moco_grav10_mmnn,
                                 v_ga_moco_grav5_mmnn,
                                 v_ga_moco_iva10_mone,
                                 v_ga_moco_iva5_mone,
                                 v_ga_moco_iva10_mmnn,
                                 v_ga_moco_iva5_mmnn,
                                 v_ga_moco_exen_mone,
                                 v_ga_moco_exen_mmnn,
                                 v_ga_moco_conc_codi_impu,
                                 v_ga_moco_tipo,
                                 'S',
                                 1);
        /*begin
        -- prueba 1......
        i020007.pp_insertar_canc_inten_gast(v_ga_moco_conc_codi);
        end;*/
      end if;
      ----actualizar moco....
      v_moco_movi_codi      := v_movi_codi; --parameter.p_inte_movi_codi;
      v_moco_conc_codi      := parameter.p_codi_conc_inte_cobr;
      v_moco_dbcr           := parameter.p_inte_movi_dbcr;
      v_moco_impo_mmnn      := v_movi_grav10_mmnn + v_movi_grav5_mmnn +
                               v_movi_exen_mmnn;
      v_moco_impo_mone      := v_movi_grav10_mone + v_movi_grav5_mone +
                               v_movi_exen_mone;
      v_moco_impo_mone_ii   := v_movi_impo_mone_ii;
      v_moco_impo_mmnn_ii   := v_movi_impo_mmnn_ii;
      v_moco_grav10_ii_mone := v_movi_grav10_ii_mone;
      v_moco_grav5_ii_mone  := v_movi_grav5_ii_mone;
      v_moco_grav10_ii_mmnn := v_movi_grav10_ii_mmnn;
      v_moco_grav5_ii_mmnn  := v_movi_grav5_ii_mmnn;
      v_moco_grav10_mone    := v_movi_grav10_mone;
      v_moco_grav5_mone     := v_movi_grav5_mone;
      v_moco_grav10_mmnn    := v_movi_grav10_mmnn;
      v_moco_grav5_mmnn     := v_movi_grav5_mmnn;
      v_moco_iva10_mone     := v_movi_iva10_mone;
      v_moco_iva5_mone      := v_movi_iva5_mone;
      v_moco_iva10_mmnn     := v_movi_iva10_mmnn;
      v_moco_iva5_mmnn      := v_movi_iva5_mmnn;
      v_moco_exen_mone      := v_movi_exen_mone;
      v_moco_exen_mmnn      := v_movi_exen_mmnn;
      ----moimpu
      v_impo_mone           := v_moco_impo_mone;
      v_impo_mmnn           := v_moco_impo_mmnn;
      v_moim_impo_mone_ii   := v_moco_impo_mone_ii;
      v_moim_impo_mmnn_ii   := v_moco_impo_mmnn_ii;
      v_moim_grav10_ii_mone := v_moco_grav10_ii_mone;
      v_moim_grav5_ii_mone  := v_moco_grav5_ii_mone;
      v_moim_grav10_ii_mmnn := v_moco_grav10_ii_mmnn;
      v_moim_grav5_ii_mmnn  := v_moco_grav5_ii_mmnn;
      v_moim_grav10_mone    := v_moco_grav10_mone;
      v_moim_grav5_mone     := v_moco_grav5_mone;
      v_moim_grav10_mmnn    := v_moco_grav10_mmnn;
      v_moim_grav5_mmnn     := v_moco_grav5_mmnn;
      v_moim_iva10_mone     := v_moco_iva10_mone;
      v_moim_iva5_mone      := v_moco_iva5_mone;
      v_moim_iva10_mmnn     := v_moco_iva10_mmnn;
      v_moim_iva5_mmnn      := v_moco_iva5_mmnn;
      v_moim_exen_mone      := v_moco_exen_mone;
      v_moim_exen_mmnn      := v_moco_exen_mmnn;
      --actualizar moim...
      pp_insert_come_movi_impu_deta(v_impu_codi,
                                    v_moco_movi_codi,
                                    v_impo_mmnn,
                                    0,
                                    0,
                                    0,
                                    v_impo_mone,
                                    0,
                                    null,
                                    v_moim_impo_mone_ii,
                                    v_moim_impo_mmnn_ii,
                                    v_moim_grav10_ii_mone,
                                    v_moim_grav5_ii_mone,
                                    v_moim_grav10_ii_mmnn,
                                    v_moim_grav5_ii_mmnn,
                                    v_moim_grav10_mone,
                                    v_moim_grav5_mone,
                                    v_moim_grav10_mmnn,
                                    v_moim_grav5_mmnn,
                                    v_moim_iva10_mone,
                                    v_moim_iva5_mone,
                                    v_moim_iva10_mmnn,
                                    v_moim_iva5_mmnn,
                                    v_moim_exen_mone,
                                    v_moim_exen_mmnn);
      ----cargar los intereses
    
     -- pp_insertar_canc_inten_gast; 26/03/2024
    
    end if;
  
  end pp_actualiza_come_movi_mora;
  -----
  procedure pp_insertar_canc_inten_gast is
    v_importe number;
    --v_ind_inset varchar2(1);
  begin
    for bdet in c_bdetalle loop
      if bdet.ind_marcado = 'X' then
        v_importe := nvl(bdet.impo_inte_puni, 0) +
                     nvl(bdet.impo_inte_mora, 0) +
                     nvl(bdet.impo_inte_gaad, 0);
        insert into come_movi_cuot_canc f
          (canc_movi_codi,
           canc_cuot_movi_codi,
           canc_cuot_fech_venc,
           canc_fech_pago,
           canc_impo_mone,
           canc_impo_mmnn,
           canc_impo_mmee,
           canc_base,
           canc_impo_dife_camb,
           canc_impo_rete_mone,
           canc_impo_rete_mmnn,
           canc_impo_inte_mora_acob,
           canc_impo_inte_mora_cobr,
           canc_impo_inte_puni_acob,
           canc_impo_inte_puni_cobr,
           canc_impo_gast_admi_acob,
           canc_impo_gast_admi_cobr,
           canc_indi_afec_sald)
        values
          (bcab.movi_codi,
           bdet.movi_codi,
           bdet.cuot_fech_venc,
           bcab.movi_fech_emis,
           v_importe,
           round(((v_importe) * bcab.movi_tasa_mone),
                 parameter.p_cant_deci_mmnn),
           0,
           1,
           round(((nvl(bcab.movi_tasa_mone, 0) -
                 nvl(bdet.cuot_tasa_mone, 0)) * v_importe),
                 0),
           bdet.impo_rete_mone,
           round((bdet.impo_rete_mone * bcab.movi_tasa_mone), 0),
           bdet.impo_inte_mora_orig,
           bdet.impo_inte_mora,
           bdet.impo_inte_puni_orig,
           bdet.impo_inte_puni,
           bdet.impo_inte_gast_admi_orig,
           bdet.impo_inte_gaad,
           'N');
      end if;
    end loop;
  end pp_insertar_canc_inten_gast;
  -----
  procedure pp_actualiza_come_movi_adel is
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
    v_movi_clpr_situ           number;
    v_movi_clpr_empl_codi_recl number;
    v_movi_clpr_sucu_nume_item number;
    v_movi_empl_codi_agen      number;
  begin
    --if bcab.cont_codi is not null then
    --bcab.movi_obse:=fp_concatenar(bcab.cont_codi);
    --end if;
    --- asignar valores....
    if parameter.p_para_inic_adel = 'AP' then
      --adelant a Proveedores
      v_movi_timo_codi := parameter.p_codi_timo_adlr;
    elsif parameter.p_para_inic_adel = 'AC' then
      -- Adelanto de Clientes
      v_movi_timo_codi := parameter.p_codi_timo_adle;
    end if;
    bcab.movi_codi_adel := fa_sec_come_movi;
    bcab.movi_fech_grab := sysdate;
    --  bcab.movi_user      := user;
    v_movi_codi                := bcab.movi_codi_adel;
    v_movi_clpr_codi           := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig      := null;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := null;
    v_movi_cuen_codi           := null; --bcab.movi_cuen_codi;
    v_movi_mone_codi           := bcab.movi_mone_codi;
    v_movi_nume                := bcab.movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_oper           := bcab.movi_fech_oper;
    v_movi_fech_grab           := bcab.movi_fech_grab;
    v_movi_user                := g_user;
    v_movi_codi_padr           := bcab.movi_codi;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := 1;
    v_movi_grav_mmnn           := 0;
    v_movi_exen_mmnn           := round((bcab.s_dife /*s_impo*/
                                        * bcab.movi_tasa_mone),
                                        parameter.p_cant_deci_mmnn);
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := 0;
    v_movi_exen_mmee           := 0;
    v_movi_iva_mmee            := 0;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := bcab.s_dife /*s_impo*/
     ;
    v_movi_iva_mone            := 0;
    v_movi_obse                := bcab.movi_obse;
    v_movi_sald_mmnn           := round((bcab.s_dife /*s_impo*/
                                        * bcab.movi_tasa_mone),
                                        parameter.p_cant_deci_mmnn);
    v_movi_sald_mmee           := 0;
    v_movi_sald_mone           := bcab.s_dife /*s_impo*/
     ;
    v_movi_stoc_suma_rest      := null;
    v_movi_clpr_dire           := bcab.movi_clpr_dire;
    v_movi_clpr_tele           := bcab.movi_clpr_tele;
    v_movi_clpr_ruc            := bcab.movi_clpr_ruc;
    v_movi_clpr_desc           := bcab.movi_clpr_desc;
    v_movi_emit_reci           := bcab.movi_emit_reci;
    v_movi_afec_sald           := bcab.movi_afec_sald;
    v_movi_clpr_situ           := bcab.movi_clpr_situ;
    v_movi_clpr_empl_codi_recl := bcab.movi_clpr_empl_codi_recl;
    if bcab.movi_dbcr = 'C' then
      v_movi_dbcr := 'D';
    else
      v_movi_dbcr := 'C';
    end if;
    v_movi_stoc_afec_cost_prom := null;
    v_movi_empr_codi           := bcab.movi_empr_codi;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := bcab.movi_empl_codi;
    v_movi_clpr_sucu_nume_item := bcab.sucu_nume_item;
    v_movi_empl_codi_agen      := bcab.s_clpr_agen_codi;
    if v_movi_clpr_sucu_nume_item = 0 then
      v_movi_clpr_sucu_nume_item := null;
    end if;
    pp_insert_come_movi_adel(v_movi_codi,
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
                             v_movi_clpr_situ,
                             v_movi_clpr_empl_codi_recl,
                             v_movi_clpr_sucu_nume_item,
                             v_movi_empl_codi_agen);
  exception
    when others then
      pl_me(sqlerrm);
  end pp_actualiza_come_movi_adel;
  -----
  procedure pp_actu_come_movi_cuot_adel is
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
    v_cuot_fech_venc := bcab.movi_fech_emis;
    v_cuot_nume      := 1;
    v_cuot_impo_mone := bcab.s_dife;
    v_cuot_impo_mmnn := round((bcab.s_dife * bcab.movi_tasa_mone),
                              parameter.p_cant_deci_mmnn);
    v_cuot_impo_mmee := null;
    v_cuot_sald_mone := v_cuot_impo_mone;
    v_cuot_sald_mmnn := v_cuot_impo_mmnn;
    v_cuot_sald_mmee := null;
    v_cuot_movi_codi := bcab.movi_codi_adel;
    pp_insert_come_movi_cuot_adel(v_cuot_fech_venc,
                                  v_cuot_nume,
                                  v_cuot_impo_mone,
                                  v_cuot_impo_mmnn,
                                  v_cuot_impo_mmee,
                                  v_cuot_sald_mone,
                                  v_cuot_sald_mmnn,
                                  v_cuot_sald_mmee,
                                  v_cuot_movi_codi);
  exception
    when others then
      pl_me(sqlerrm);
  end pp_actu_come_movi_cuot_adel;
  /* -----
  procedure pp_actualiza_moimpu_adel is
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
    v_moim_movi_codi := bcab.movi_codi_adel;
    v_moim_impo_mmnn := round((bcab.s_dife * bcab.movi_tasa_mone),
                              to_number(parameter.p_cant_deci_mmnn));
    v_moim_impo_mmee := 0;
    v_moim_impu_mmnn := 0;
    v_moim_impu_mmee := 0;
    v_moim_impo_mone := bcab.s_dife;
    v_moim_impu_mone := 0;
   -- raise_application_error(-20001,bcab.s_dife);
    pp_inse_movi_impu_deta_adel(v_moim_impu_codi,
                                v_moim_movi_codi,
                                v_moim_impo_mmnn,
                                v_moim_impo_mmee,
                                v_moim_impu_mmnn,
                                v_moim_impu_mmee,
                                v_moim_impo_mone,
                                v_moim_impu_mone);
  Exception
    when others then
      pl_me(sqlerrm);
  end pp_actualiza_moimpu_adel;
  
  */

  procedure pp_actualiza_moimpu_adel is
    --v_moim_impu_codi number;
    v_moim_exen_mone    number;
    v_moim_exen_mmnn    number;
    v_moim_impo_mmee    number;
    v_moim_impu_mmnn    number;
    v_moim_impu_mmee    number;
    v_moim_impo_mone    number;
    v_moim_impo_mone_ii number;
    v_moim_impo_mmnn_ii number;
    v_impo_mone         number := 0;
    v_impo_mmnn         number := 0;
  begin
  
    --v_moim_impo_mmee := 0;
    --v_moim_impu_mmnn := 0;
    --v_moim_impu_mmee := 0;
    --v_moim_impo_mone := bcab.s_dife;
  
    v_impo_mone := nvl(bcab.s_dife, 0);
    --v_impo_mone := :bdet.sum_impo_pago;
    v_impo_mmnn         := round(v_impo_mone * bcab.movi_tasa_mone);
    v_moim_impo_mone_ii := v_impo_mone;
    v_moim_impo_mmnn_ii := v_impo_mmnn;
    v_moim_exen_mone    := v_impo_mone;
    v_moim_exen_mmnn    := v_impo_mmnn;
  
    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  bcab.movi_codi_adel,
                                  v_impo_mmnn, --bcab.movi_exen_mmnn,
                                  0,
                                  0,
                                  0,
                                  v_impo_mone, --bcab.movi_exen_mone,
                                  0,
                                  null,
                                  v_moim_impo_mone_ii,
                                  v_moim_impo_mmnn_ii,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  v_moim_exen_mone,
                                  v_moim_exen_mmnn);
  exception
    when others then
      pl_me(sqlerrm);
  end pp_actualiza_moimpu_adel;
  -----
  procedure pp_inse_movi_impu_deta_adel(p_moim_impu_codi in number,
                                        p_moim_movi_codi in number,
                                        p_moim_impo_mmnn in number,
                                        p_moim_impo_mmee in number,
                                        p_moim_impu_mmnn in number,
                                        p_moim_impu_mmee in number,
                                        p_moim_impo_mone in number,
                                        p_moim_impu_mone in number) is
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
       moim_base)
    values
      (p_moim_impu_codi,
       p_moim_movi_codi,
       p_moim_impo_mmnn,
       p_moim_impo_mmee,
       p_moim_impu_mmnn,
       p_moim_impu_mmee,
       p_moim_impo_mone,
       p_moim_impu_mone,
       1);
  
  end pp_inse_movi_impu_deta_adel;
  -----
  procedure pp_actualiza_moco_adel is
    v_moco_movi_codi      number;
    v_moco_nume_item      number;
    v_moco_conc_codi      number;
    v_moco_cuco_codi      number;
    v_moco_impu_codi      number;
    v_moco_impo_mmnn      number;
    v_moco_impo_mmee      number;
    v_moco_impo_mone      number;
    v_moco_dbcr           char(1);
    v_moco_impo_mone_ii   number := 0;
    v_moco_impo_mmnn_ii   number := 0;
    v_moco_grav10_ii_mone number := 0;
    v_moco_grav5_ii_mone  number := 0;
    v_moco_grav10_ii_mmnn number := 0;
    v_moco_grav5_ii_mmnn  number := 0;
    v_moco_grav10_mone    number := 0;
    v_moco_grav5_mone     number := 0;
    v_moco_grav10_mmnn    number := 0;
    v_moco_grav5_mmnn     number := 0;
    v_moco_iva10_mone     number := 0;
    v_moco_iva5_mone      number := 0;
    v_moco_iva10_mmnn     number := 0;
    v_moco_iva5_mmnn      number := 0;
    v_moco_exen_mone      number := 0;
    v_moco_exen_mmnn      number := 0;
    v_moco_conc_codi_impu number;
    v_moco_tipo           varchar2(1);
  begin
    v_moco_movi_codi := bcab.movi_codi_adel;
    v_moco_nume_item := 1;
    if parameter.p_para_inic_adel = 'AP' then
      --adelant a Proveedores
      v_moco_conc_codi := parameter.p_codi_conc_adlr;
    elsif parameter.p_para_inic_adel = 'AC' then
      -- Adelanto de Clientes
      v_moco_conc_codi := parameter.p_codi_conc_adle;
    end if;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_exen; --exento
    v_moco_impo_mmnn := round((bcab.s_dife /*s_impo*/
                              * bcab.movi_tasa_mone),
                              parameter.p_cant_deci_mmnn);
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := bcab.s_dife /*s_impo*/
     ;
    pp_devu_dbcr_conc(v_moco_conc_codi, v_moco_dbcr);
    v_moco_impo_mone_ii   := v_moco_impo_mone;
    v_moco_impo_mmnn_ii   := v_moco_impo_mmnn;
    v_moco_grav10_ii_mone := 0;
    v_moco_grav5_ii_mone  := 0;
    v_moco_grav10_ii_mmnn := 0;
    v_moco_grav5_ii_mmnn  := 0;
    v_moco_grav10_mone    := 0;
    v_moco_grav5_mone     := 0;
    v_moco_grav10_mmnn    := 0;
    v_moco_grav5_mmnn     := 0;
    v_moco_iva10_mone     := 0;
    v_moco_iva5_mone      := 0;
    v_moco_iva10_mmnn     := 0;
    v_moco_iva5_mmnn      := 0;
    v_moco_exen_mone      := v_moco_impo_mone;
    v_moco_exen_mmnn      := v_moco_impo_mmnn;
    v_moco_conc_codi_impu := null;
    v_moco_tipo           := null;
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
                             null,
                             v_moco_impo_mone_ii,
                             v_moco_impo_mmnn_ii,
                             v_moco_grav10_ii_mone,
                             v_moco_grav5_ii_mone,
                             v_moco_grav10_ii_mmnn,
                             v_moco_grav5_ii_mmnn,
                             v_moco_grav10_mone,
                             v_moco_grav5_mone,
                             v_moco_grav10_mmnn,
                             v_moco_grav5_mmnn,
                             v_moco_iva10_mone,
                             v_moco_iva5_mone,
                             v_moco_iva10_mmnn,
                             v_moco_iva5_mmnn,
                             v_moco_exen_mone,
                             v_moco_exen_mmnn,
                             v_moco_conc_codi_impu,
                             v_moco_tipo);
  exception
    when others then
      pl_me(sqlerrm);
  end;
  -----
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
    v_movi_nume_orde_pago      number;
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
    v_movi_impo_mone_ii        number;
    v_movi_impo_mmnn_ii        number;
    v_movi_nume_timb           varchar2(20);
    v_movi_fech_venc_timb      date;
    v_movi_grav10_ii_mone      number := 0;
    v_movi_grav5_ii_mone       number := 0;
    v_movi_grav10_ii_mmnn      number := 0;
    v_movi_grav5_ii_mmnn       number := 0;
    v_movi_grav10_mone         number := 0;
    v_movi_grav5_mone          number := 0;
    v_movi_grav10_mmnn         number := 0;
    v_movi_grav5_mmnn          number := 0;
    v_movi_iva10_mone          number := 0;
    v_movi_iva5_mone           number := 0;
    v_movi_iva10_mmnn          number := 0;
    v_movi_iva5_mmnn           number := 0;
    v_movi_empl_codi_agen      number;
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
    v_moco_movi_codi      number;
    v_moco_nume_item      number;
    v_moco_conc_codi      number;
    v_moco_cuco_codi      number;
    v_moco_impu_codi      number;
    v_moco_impo_mmnn      number;
    v_moco_impo_mmee      number;
    v_moco_impo_mone      number;
    v_moco_dbcr           char(1);
    v_moco_impo_mone_ii   number := 0;
    v_moco_impo_mmnn_ii   number := 0;
    v_moco_grav10_ii_mone number := 0;
    v_moco_grav5_ii_mone  number := 0;
    v_moco_grav10_ii_mmnn number := 0;
    v_moco_grav5_ii_mmnn  number := 0;
    v_moco_grav10_mone    number := 0;
    v_moco_grav5_mone     number := 0;
    v_moco_grav10_mmnn    number := 0;
    v_moco_grav5_mmnn     number := 0;
    v_moco_iva10_mone     number := 0;
    v_moco_iva5_mone      number := 0;
    v_moco_iva10_mmnn     number := 0;
    v_moco_iva5_mmnn      number := 0;
    v_moco_exen_mone      number := 0;
    v_moco_exen_mmnn      number := 0;
    v_moco_conc_codi_impu number;
    v_moco_tipo           varchar2(1);
    v_moim_impo_mone_ii   number := 0;
    v_moim_impo_mmnn_ii   number := 0;
    v_moim_grav10_ii_mone number := 0;
    v_moim_grav5_ii_mone  number := 0;
    v_moim_grav10_ii_mmnn number := 0;
    v_moim_grav5_ii_mmnn  number := 0;
    v_moim_grav10_mone    number := 0;
    v_moim_grav5_mone     number := 0;
    v_moim_grav10_mmnn    number := 0;
    v_moim_grav5_mmnn     number := 0;
    v_moim_iva10_mone     number := 0;
    v_moim_iva5_mone      number := 0;
    v_moim_iva10_mmnn     number := 0;
    v_moim_iva5_mmnn      number := 0;
    v_moim_exen_mone      number := 0;
    v_moim_exen_mmnn      number := 0;
  begin
    --- asignar valores....
    select timo_emit_reci, timo_afec_sald, timo_dbcr
      into v_movi_emit_reci, v_movi_afec_sald, v_movi_dbcr
      from come_tipo_movi, come_tipo_comp
     where timo_tico_codi = tico_codi(+)
       and timo_codi = parameter.p_codi_timo_rete_emit;
    v_movi_nume                := bcab.movi_nume_rete;
    v_movi_nume_timb           := bcab.movi_nume_timb_rete;
    v_movi_fech_venc_timb      := bcab.movi_fech_venc_timb_rete;
    v_movi_fech_oper           := bcab.movi_fech_oper;
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
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := sysdate;
    v_movi_user                := g_user;
    v_movi_codi_padr           := bcab.movi_codi;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := null;
    v_movi_grav_mmnn           := 0;
    v_movi_exen_mmnn           := round(bcab.s_impo_rete *
                                        bcab.movi_tasa_mone,
                                        0);
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := bcab.s_impo_rete;
    v_movi_iva_mone            := 0;
    v_movi_obse                := nvl(bcab.movi_obse_rete,
                                      'Retencion Factura Nro. ' ||
                                      bcab.movi_nume);
    v_movi_sald_mmnn           := 0;
    v_movi_sald_mmee           := 0;
    v_movi_sald_mone           := 0;
    v_movi_stoc_suma_rest      := null;
    v_movi_clpr_dire           := null;
    v_movi_clpr_tele           := null;
    v_movi_clpr_ruc            := null;
    v_movi_clpr_desc           := bcab.movi_clpr_desc;
    v_movi_stoc_afec_cost_prom := null;
    v_movi_empr_codi           := null;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := null;
    v_movi_excl_cont           := 'S';
    v_movi_impo_reca           := 0;
    v_movi_clpr_situ           := bcab.movi_clpr_situ;
    v_movi_clpr_empl_codi_recl := bcab.movi_clpr_empl_codi_recl;
    v_movi_clpr_sucu_nume_item := null;
    v_movi_impo_mone_ii        := nvl(v_movi_exen_mone, 0);
    v_movi_impo_mmnn_ii        := nvl(v_movi_exen_mmnn, 0);
    v_movi_grav10_ii_mone      := 0;
    v_movi_grav5_ii_mone       := 0;
    v_movi_grav10_ii_mmnn      := 0;
    v_movi_grav5_ii_mmnn       := 0;
    v_movi_grav10_mone         := 0;
    v_movi_grav5_mone          := 0;
    v_movi_grav10_mmnn         := 0;
    v_movi_grav5_mmnn          := 0;
    v_movi_iva10_mone          := 0;
    v_movi_iva5_mone           := 0;
    v_movi_iva10_mmnn          := 0;
    v_movi_iva5_mmnn           := 0;
    v_movi_empl_codi_agen      := null;
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
                        v_movi_impo_reca,
                        v_movi_excl_cont,
                        v_movi_clpr_situ,
                        v_movi_clpr_empl_codi_recl,
                        v_movi_clpr_sucu_nume_item,
                        v_movi_impo_mone_ii,
                        v_movi_impo_mmnn_ii,
                        v_movi_grav10_ii_mone,
                        v_movi_grav5_ii_mone,
                        v_movi_grav10_ii_mmnn,
                        v_movi_grav5_ii_mmnn,
                        v_movi_grav10_mone,
                        v_movi_grav5_mone,
                        v_movi_grav10_mmnn,
                        v_movi_grav5_mmnn,
                        v_movi_iva10_mone,
                        v_movi_iva5_mone,
                        v_movi_iva10_mmnn,
                        v_movi_iva5_mmnn,
                        v_movi_empl_codi_agen,
                        v_movi_nume_orde_pago,
                        nvl(bcab.movi_indi_auto_impr, 'N'));
    ----detalle de conceptos
    v_moco_movi_codi      := parameter.p_movi_codi_rete;
    v_moco_nume_item      := 0;
    v_moco_conc_codi      := parameter.p_codi_conc_rete_emit;
    v_moco_dbcr           := v_movi_dbcr;
    v_moco_nume_item      := v_moco_nume_item + 1;
    v_moco_cuco_codi      := null;
    v_moco_impu_codi      := parameter.p_codi_impu_exen;
    v_moco_impo_mmnn      := v_movi_Exen_mmnn;
    v_moco_impo_mmee      := 0;
    v_moco_impo_mone      := v_movi_exen_mmnn;
    v_moco_impo_mone_ii   := v_moco_impo_mone;
    v_moco_impo_mmnn_ii   := v_moco_impo_mmnn;
    v_moco_grav10_ii_mone := 0;
    v_moco_grav5_ii_mone  := 0;
    v_moco_grav10_ii_mmnn := 0;
    v_moco_grav5_ii_mmnn  := 0;
    v_moco_grav10_mone    := 0;
    v_moco_grav5_mone     := 0;
    v_moco_grav10_mmnn    := 0;
    v_moco_grav5_mmnn     := 0;
    v_moco_iva10_mone     := 0;
    v_moco_iva5_mone      := 0;
    v_moco_iva10_mmnn     := 0;
    v_moco_iva5_mmnn      := 0;
    v_moco_exen_mone      := v_moco_impo_mone;
    v_moco_exen_mmnn      := v_moco_impo_mmnn;
    v_moco_conc_codi_impu := null;
    v_moco_tipo           := null;
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
                             null,
                             v_moco_impo_mone_ii,
                             v_moco_impo_mmnn_ii,
                             v_moco_grav10_ii_mone,
                             v_moco_grav5_ii_mone,
                             v_moco_grav10_ii_mmnn,
                             v_moco_grav5_ii_mmnn,
                             v_moco_grav10_mone,
                             v_moco_grav5_mone,
                             v_moco_grav10_mmnn,
                             v_moco_grav5_mmnn,
                             v_moco_iva10_mone,
                             v_moco_iva5_mone,
                             v_moco_iva10_mmnn,
                             v_moco_iva5_mmnn,
                             v_moco_exen_mone,
                             v_moco_exen_mmnn,
                             v_moco_conc_codi_impu,
                             v_moco_tipo);
    --detalle de impuestos
    v_moim_impo_mone_ii   := v_movi_exen_mone;
    v_moim_impo_mmnn_ii   := v_movi_exen_mmnn;
    v_moim_grav10_ii_mone := 0;
    v_moim_grav5_ii_mone  := 0;
    v_moim_grav10_ii_mmnn := 0;
    v_moim_grav5_ii_mmnn  := 0;
    v_moim_grav10_mone    := 0;
    v_moim_grav5_mone     := 0;
    v_moim_grav10_mmnn    := 0;
    v_moim_grav5_mmnn     := 0;
    v_moim_iva10_mone     := 0;
    v_moim_iva5_mone      := 0;
    v_moim_iva10_mmnn     := 0;
    v_moim_iva5_mmnn      := 0;
    v_moim_exen_mone      := v_movi_exen_mone;
    v_moim_exen_mmnn      := v_movi_exen_mmnn;
    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  parameter.p_movi_codi_rete,
                                  v_movi_exen_mmnn,
                                  0,
                                  0,
                                  0,
                                  v_movi_exen_mone,
                                  0,
                                  null,
                                  v_moim_impo_mone_ii,
                                  v_moim_impo_mmnn_ii,
                                  v_moim_grav10_ii_mone,
                                  v_moim_grav5_ii_mone,
                                  v_moim_grav10_ii_mmnn,
                                  v_moim_grav5_ii_mmnn,
                                  v_moim_grav10_mone,
                                  v_moim_grav5_mone,
                                  v_moim_grav10_mmnn,
                                  v_moim_grav5_mmnn,
                                  v_moim_iva10_mone,
                                  v_moim_iva5_mone,
                                  v_moim_iva10_mmnn,
                                  v_moim_iva5_mmnn,
                                  v_moim_exen_mone,
                                  v_moim_exen_mmnn);
    if nvl(parameter.p_form_calc_rete_emit, 1) = 2 then
      --Formula de calculo de retencion prorrateada
      update come_movi
         set movi_codi_rete = parameter.p_movi_codi_rete
       where movi_codi = bcab.movi_codi;
    else
      for bdet in c_bdetalle loop
        if nvl(bdet.impo_rete_mone, 0) > 0 then
          update come_movi
             set movi_codi_rete = parameter.p_movi_codi_rete
           where movi_codi = bdet.movi_codi;
        end if;
      end loop;
    end if;
    --  pp_actu_secu_rete;
    pp_actu_secu_rete(bcab.s_impo_rete, bcab.movi_nume_rete);
  end pp_actualizar_rete;
  -----
  -----
  procedure pp_actualizar_rete_tesaka(p_canc_movi_codi in number) is
    cursor cv_canc is
      select canc_movi_codi,
             canc_cuot_movi_codi,
             movi_nume fact_nume,
             sum(canc_impo_rete_mone) rete_impo_mone,
             sum(canc_impo_rete_mmnn) rete_impo_mmnn
        from come_movi_cuot_canc, come_movi
       where canc_cuot_movi_codi = movi_codi
         and canc_movi_codi = p_canc_movi_codi
         and nvl(canc_impo_rete_mone, 0) > 0
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
    v_movi_nume_orde_pago      number;
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
    v_movi_grav10_ii_mone      number := 0;
    v_movi_grav5_ii_mone       number := 0;
    v_movi_grav10_ii_mmnn      number := 0;
    v_movi_grav5_ii_mmnn       number := 0;
    v_movi_grav10_mone         number := 0;
    v_movi_grav5_mone          number := 0;
    v_movi_grav10_mmnn         number := 0;
    v_movi_grav5_mmnn          number := 0;
    v_movi_iva10_mone          number := 0;
    v_movi_iva5_mone           number := 0;
    v_movi_iva10_mmnn          number := 0;
    v_movi_iva5_mmnn           number := 0;
    v_movi_empl_codi_agen      number;
    v_tico_indi_timb           varchar2(1);
    v_movi_nume_timb           varchar2(20);
    v_movi_fech_venc_timb      date;
    v_movi_impo_mone_ii        number;
    v_movi_impo_mmnn_ii        number;
    v_moim_movi_codi           number;
    v_moim_nume_item           number := 0;
    v_moim_tipo                char(20);
    v_moim_cuen_codi           number;
    v_moim_dbcr                char(1);
    v_moim_afec_caja           char(1);
    v_moim_fech                date;
    v_moim_impo_mone           number;
    v_moim_impo_mmnn           number;
    v_moim_fech_oper           date;
    --variables para moco
    v_moco_movi_codi      number;
    v_moco_nume_item      number;
    v_moco_conc_codi      number;
    v_moco_cuco_codi      number;
    v_moco_impu_codi      number;
    v_moco_impo_mmnn      number;
    v_moco_impo_mmee      number;
    v_moco_impo_mone      number;
    v_moco_dbcr           char(1);
    v_moco_impo_mone_ii   number := 0;
    v_moco_impo_mmnn_ii   number := 0;
    v_moco_grav10_ii_mone number := 0;
    v_moco_grav5_ii_mone  number := 0;
    v_moco_grav10_ii_mmnn number := 0;
    v_moco_grav5_ii_mmnn  number := 0;
    v_moco_grav10_mone    number := 0;
    v_moco_grav5_mone     number := 0;
    v_moco_grav10_mmnn    number := 0;
    v_moco_grav5_mmnn     number := 0;
    v_moco_iva10_mone     number := 0;
    v_moco_iva5_mone      number := 0;
    v_moco_iva10_mmnn     number := 0;
    v_moco_iva5_mmnn      number := 0;
    v_moco_exen_mone      number := 0;
    v_moco_exen_mmnn      number := 0;
    v_moco_conc_codi_impu number;
    v_moco_tipo           varchar2(1);
    v_moim_impo_mone_ii   number := 0;
    v_moim_impo_mmnn_ii   number := 0;
    v_moim_grav10_ii_mone number := 0;
    v_moim_grav5_ii_mone  number := 0;
    v_moim_grav10_ii_mmnn number := 0;
    v_moim_grav5_ii_mmnn  number := 0;
    v_moim_grav10_mone    number := 0;
    v_moim_grav5_mone     number := 0;
    v_moim_grav10_mmnn    number := 0;
    v_moim_grav5_mmnn     number := 0;
    v_moim_iva10_mone     number := 0;
    v_moim_iva5_mone      number := 0;
    v_moim_iva10_mmnn     number := 0;
    v_moim_iva5_mmnn      number := 0;
    v_moim_exen_mone      number := 0;
    v_moim_exen_mmnn      number := 0;
    v_tico_codi           number;
    v_esta                number;
    v_expe                number;
    v_nume                number;
    v_more_movi_codi      number;
    v_more_movi_codi_rete number;
    v_more_movi_codi_pago number;
    v_more_tipo_rete      varchar2(2);
    v_more_impo_mone      number(20, 4);
    v_more_impo_mmnn      number(20, 4);
    v_more_tasa_mone      number(20, 4);
    e_secu_nume           exception;
    e_timb                exception;
  begin
    --break;
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
        select substr(lpad(nvl(secu_nume_reten, 0) + 1, 13, 0), 1, 3) establecimiento,
               substr(lpad(nvl(secu_nume_reten, 0) + 1, 13, 0), 4, 3) expedicion,
               substr(lpad(nvl(secu_nume_reten, 0) + 1, 13, 0), 7) numero,
               nvl(secu_nume_reten, 0) + 1
          into v_esta, v_expe, v_nume, v_movi_nume
          from come_secu
         where secu_codi = (select f.user_secu_codi
                              from segu_user f
                             where user_login = fp_user); /*
                                                               (select peco_secu_codi
                                                                  from come_pers_comp
                                                                 where peco_codi = parameter.p_peco_codi);*/
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
                 (select f.user_secu_codi
                    from segu_user f
                   where user_login = fp_user) /* (select peco_secu_codi
                                                                                                                                                    from come_pers_comp
                                                                                                                                                   where peco_codi = parameter.p_peco_codi)*/
                
             and setc_tico_codi = v_tico_codi
             and setc_esta = v_esta
             and setc_punt_expe = v_expe
             and setc_fech_venc >= bcab.movi_fech_emis
             and rownum = 1
           order by setc_fech_venc;
        elsif v_tico_indi_timb = 'C' then
          select deta_nume_timb, deta_fech_venc
            into v_movi_nume_timb, v_movi_fech_venc_timb
            from come_tipo_comp_deta
           where deta_tico_codi = v_tico_codi
             and deta_esta = v_esta
             and deta_punt_expe = v_expe
             and deta_fech_venc >= bcab.movi_fech_emis
             and rownum = 1
           order by deta_fech_venc;
        end if;
      exception
        when others then
          raise e_timb;
      end;
      v_movi_codi                := fa_sec_come_movi;
      v_movi_timo_codi           := parameter.p_codi_timo_rete_emit;
      v_movi_clpr_codi           := bcab.movi_clpr_codi;
      v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
      v_movi_depo_codi_orig      := null;
      v_movi_sucu_codi_dest      := null;
      v_movi_depo_codi_dest      := null;
      v_movi_oper_codi           := null;
      v_movi_cuen_codi           := null;
      v_movi_mone_codi           := bcab.movi_mone_codi;
      v_movi_fech_emis           := bcab.movi_fech_emis;
      v_movi_fech_oper           := bcab.movi_fech_oper;
      v_movi_fech_grab           := sysdate;
      v_movi_user                := user;
      v_movi_codi_padr           := bcab.movi_codi;
      v_movi_tasa_mone           := bcab.movi_tasa_mone;
      v_movi_tasa_mmee           := null;
      v_movi_grav_mmnn           := 0;
      v_movi_exen_mmnn           := r.rete_impo_mmnn;
      v_movi_iva_mmnn            := 0;
      v_movi_grav_mmee           := null;
      v_movi_exen_mmee           := null;
      v_movi_iva_mmee            := null;
      v_movi_grav_mone           := 0;
      v_movi_exen_mone           := r.rete_impo_mone;
      v_movi_iva_mone            := 0;
      v_movi_obse                := nvl(bcab.movi_obse_rete,
                                        'Retenci?n Factura Nro. ' ||
                                        r.fact_nume);
      v_movi_sald_mmnn           := 0;
      v_movi_sald_mmee           := 0;
      v_movi_sald_mone           := 0;
      v_movi_stoc_suma_rest      := null;
      v_movi_clpr_dire           := null;
      v_movi_clpr_tele           := null;
      v_movi_clpr_ruc            := null;
      v_movi_clpr_desc           := bcab.movi_clpr_desc;
      v_movi_stoc_afec_cost_prom := null;
      v_movi_empr_codi           := null;
      v_movi_clave_orig          := null;
      v_movi_clave_orig_padr     := null;
      v_movi_indi_iva_incl       := null;
      v_movi_empl_codi           := null;
      v_movi_excl_cont           := 'S';
      v_movi_impo_reca           := 0;
      v_movi_clpr_situ           := bcab.movi_clpr_situ;
      v_movi_clpr_empl_codi_recl := bcab.movi_clpr_empl_codi_recl;
      v_movi_clpr_sucu_nume_item := null;
      v_movi_impo_mone_ii        := v_movi_exen_mone;
      v_movi_impo_mmnn_ii        := v_movi_exen_mmnn;
      v_movi_grav10_ii_mone      := 0;
      v_movi_grav5_ii_mone       := 0;
      v_movi_grav10_ii_mmnn      := 0;
      v_movi_grav5_ii_mmnn       := 0;
      v_movi_grav10_mone         := 0;
      v_movi_grav5_mone          := 0;
      v_movi_grav10_mmnn         := 0;
      v_movi_grav5_mmnn          := 0;
      v_movi_iva10_mone          := 0;
      v_movi_iva5_mone           := 0;
      v_movi_iva10_mmnn          := 0;
      v_movi_iva5_mmnn           := 0;
      v_movi_empl_codi_agen      := null;
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
                          v_movi_impo_reca,
                          v_movi_excl_cont,
                          v_movi_clpr_situ,
                          v_movi_clpr_empl_codi_recl,
                          v_movi_clpr_sucu_nume_item,
                          v_movi_impo_mone_ii,
                          v_movi_impo_mmnn_ii,
                          v_movi_grav10_ii_mone,
                          v_movi_grav5_ii_mone,
                          v_movi_grav10_ii_mmnn,
                          v_movi_grav5_ii_mmnn,
                          v_movi_grav10_mone,
                          v_movi_grav5_mone,
                          v_movi_grav10_mmnn,
                          v_movi_grav5_mmnn,
                          v_movi_iva10_mone,
                          v_movi_iva5_mone,
                          v_movi_iva10_mmnn,
                          v_movi_iva5_mmnn,
                          v_movi_empl_codi_agen,
                          v_movi_nume_orde_pago,
                          nvl(bcab.movi_indi_auto_impr, 'N'));
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
      ----detalle de conceptos
      v_moco_movi_codi      := v_movi_codi;
      v_moco_nume_item      := 0;
      v_moco_conc_codi      := parameter.p_codi_conc_rete_emit;
      v_moco_dbcr           := v_movi_dbcr;
      v_moco_nume_item      := v_moco_nume_item + 1;
      v_moco_cuco_codi      := null;
      v_moco_impu_codi      := parameter.p_codi_impu_exen;
      v_moco_impo_mmnn      := v_movi_exen_mmnn;
      v_moco_impo_mmee      := 0;
      v_moco_impo_mone      := v_movi_exen_mone;
      v_moco_impo_mone_ii   := v_moco_impo_mone;
      v_moco_impo_mmnn_ii   := v_moco_impo_mmnn;
      v_moco_grav10_ii_mone := 0;
      v_moco_grav5_ii_mone  := 0;
      v_moco_grav10_ii_mmnn := 0;
      v_moco_grav5_ii_mmnn  := 0;
      v_moco_grav10_mone    := 0;
      v_moco_grav5_mone     := 0;
      v_moco_grav10_mmnn    := 0;
      v_moco_grav5_mmnn     := 0;
      v_moco_iva10_mone     := 0;
      v_moco_iva5_mone      := 0;
      v_moco_iva10_mmnn     := 0;
      v_moco_iva5_mmnn      := 0;
      v_moco_exen_mone      := v_moco_impo_mone;
      v_moco_exen_mmnn      := v_moco_impo_mmnn;
      v_moco_conc_codi_impu := null;
      v_moco_tipo           := null;
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
                               null,
                               v_moco_impo_mone_ii,
                               v_moco_impo_mmnn_ii,
                               v_moco_grav10_ii_mone,
                               v_moco_grav5_ii_mone,
                               v_moco_grav10_ii_mmnn,
                               v_moco_grav5_ii_mmnn,
                               v_moco_grav10_mone,
                               v_moco_grav5_mone,
                               v_moco_grav10_mmnn,
                               v_moco_grav5_mmnn,
                               v_moco_iva10_mone,
                               v_moco_iva5_mone,
                               v_moco_iva10_mmnn,
                               v_moco_iva5_mmnn,
                               v_moco_exen_mone,
                               v_moco_exen_mmnn,
                               v_moco_conc_codi_impu,
                               v_moco_tipo);
      --detalle de impuestos
      v_moim_impo_mone_ii   := v_movi_exen_mone;
      v_moim_impo_mmnn_ii   := v_movi_exen_mmnn;
      v_moim_grav10_ii_mone := 0;
      v_moim_grav5_ii_mone  := 0;
      v_moim_grav10_ii_mmnn := 0;
      v_moim_grav5_ii_mmnn  := 0;
      v_moim_grav10_mone    := 0;
      v_moim_grav5_mone     := 0;
      v_moim_grav10_mmnn    := 0;
      v_moim_grav5_mmnn     := 0;
      v_moim_iva10_mone     := 0;
      v_moim_iva5_mone      := 0;
      v_moim_iva10_mmnn     := 0;
      v_moim_iva5_mmnn      := 0;
      v_moim_exen_mone      := v_movi_exen_mone;
      v_moim_exen_mmnn      := v_movi_exen_mmnn;
      pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                    v_movi_codi,
                                    v_movi_exen_mmnn,
                                    0,
                                    0,
                                    0,
                                    v_movi_exen_mone,
                                    0,
                                    null,
                                    v_moim_impo_mone_ii,
                                    v_moim_impo_mmnn_ii,
                                    v_moim_grav10_ii_mone,
                                    v_moim_grav5_ii_mone,
                                    v_moim_grav10_ii_mmnn,
                                    v_moim_grav5_ii_mmnn,
                                    v_moim_grav10_mone,
                                    v_moim_grav5_mone,
                                    v_moim_grav10_mmnn,
                                    v_moim_grav5_mmnn,
                                    v_moim_iva10_mone,
                                    v_moim_iva5_mone,
                                    v_moim_iva10_mmnn,
                                    v_moim_iva5_mmnn,
                                    v_moim_exen_mone,
                                    v_moim_exen_mmnn);
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
  end pp_actualizar_rete_tesaka;
  -----
  procedure pp_actualiza_registro is
    salir exception;
  begin
  
    if bcab.movi_fech_emis is null then
      pl_me('Debe ingresar la fecha del recibo!.');
    end if;
  
    if bcab.movi_clpr_codi <> bcab.clpr_codi_det then
      pl_me('Atencion ! El codigo de cliente ha cambiado, debe cancelar la operacion !!');
    end if;
    if bcab.movi_mone_codi <> bcab.mone_codi_det then
      pl_me('La moneda de las cuotas a cancelar no coincide con la moneda seleccionada en la cabecera');
    end if;
    if nvl(bcab.movi_exen_mone_tota, 0) = 0 then
      pl_me('El pago debe asignarse por lo menos a un documento!');
    end if;
  
    if nvl(bcab.s_dife, 0) < 0 then
      pl_me('Existe diferencia entre el importe del recibo y el detalle de cuotas canceladas');
    end if;
  
    pp_valida_importes;
    pp_valida_cheques;
    pp_validar_registro_duplicado('cheq');
    -- VERIFICA DUPLICACION DE DOCUMENTOS.
    if bcab.tico_indi_vali_nume = 'S' then
      if parameter.p_codi_timo_rere = bcab.movi_timo_codi then
        pp_vali_nume_dupl_prov_1;
      else
        pp_vali_nume_dupl_1;
      end if;
    end if;
    if bcab.movi_codi is null then
      ---se carga la cabecera principal.......
      pp_actualiza_come_movi;
      ----Aca se inicia la carga intereses y gastos administrativo en caso de existir....
      if nvl(bcab.sum_inte_mora_puni, 0) > 0 then
        pp_actualiza_come_movi_mora;
        if nvl(parameter.p_indi_cobr_inte_bole_fact, 'B') = 'B' then
          ---si es PCOE
          null;
        else
          ---si es FCOE
          pp_actu_secu_bole_fact_inte(parameter.p_movi_nume_fact_inte);
        end if;
      end if;
      if nvl(bcab.sum_impo_pago, 0) > 0 then
        ----en caso de existe un importe para cancelar el importe se inserta.....
        pp_actualizar_moco;
      end if;
    
      pp_insertar_cance;
      pp_actualizar_moimpu;
      pack_fpago.pl_fp_actualiza_moimpo(i_movi_clpr_codi      => bcab.movi_clpr_codi,
                                        i_movi_clpr_desc      => bcab.movi_clpr_desc,
                                        i_movi_clpr_ruc       => bcab.movi_clpr_ruc,
                                        i_movi_codi           => bcab.movi_codi,
                                        i_movi_dbcr           => bcab.movi_dbcr,
                                        i_movi_emit_reci      => bcab.movi_emit_reci,
                                        i_movi_empr_codi      => bcab.movi_empr_codi,
                                        i_movi_fech_emis      => bcab.movi_fech_emis,
                                        i_movi_fech_oper      => bcab.movi_fech_oper,
                                        i_movi_mone_cant_deci => bcab.movi_mone_cant_deci,
                                        i_movi_sucu_codi_orig => bcab.movi_sucu_codi_orig,
                                        i_movi_tasa_mone      => bcab.movi_tasa_mone,
                                        i_movi_timo_codi      => bcab.movi_timo_codi,
                                        i_s_impo_rete         => bcab.s_impo_rete,
                                        i_s_impo_rete_rent    => bcab.s_impo_rete_rent);
      pp_actu_clie_exce(bcab.movi_clpr_indi_exce,
                        bcab.movi_clpr_codi,
                        bcab.clpr_indi_exce);
      --- Apartir de aca se validad para verificar si posee diferecia para generar un adelanto.....
    
      if nvl(bcab.sum_impo_pago, 0) + nvl(bcab.sum_inte_mora_puni, 0) <
         nvl(bcab.movi_exen_mone_tota, 0) then
      
        pp_actualiza_come_movi_adel;
        pp_actu_come_movi_cuot_adel;
        pp_actualiza_moimpu_adel;
        pp_actualiza_moco_adel;
      end if;
      ------------
      if nvl(parameter.p_indi_rete_tesaka, 'N') = 'N' then
        if nvl(bcab.s_impo_rete, 0) > 0 then
          pp_actualizar_rete;
        end if;
      else
        if nvl(bcab.s_impo_rete, 0) > 0 then
          pp_actualizar_rete_tesaka(bcab.movi_codi);
        end if;
      end if;
      if parameter.p_para_inic = 'C' then
        pp_actu_comp(v('P10_MOVI_TICO_CODI'),
                     bcab.movi_empl_codi,
                     bcab.movi_tare_codi,
                     bcab.movi_nume);
      end if;
      if parameter.p_indi_auto = 'S' then
        pp_actualizar_auto_desc_inte(bcab.movi_clpr_codi);
      end if;
      -- pp_actu_secu;
      pp_actu_secu(bcab.movi_nume);
      if nvl(parameter.p_indi_impr_cheq_emit, 'N') = 'S' then
        --pp_impr_cheq_emit;
        null;
      end if;
      if nvl(parameter.p_indi_rete_tesaka, 'N') = 'N' then
        if nvl(bcab.s_impo_rete, 0) > 0 then
          --pp_impr_rete;
          null;
        end if;
      else
        --pp_impr_rete_tesaka_1(bcab.movi_codi);
        null;
      end if;
      -- pp_impr_reci;
      if parameter.p_inte_movi_codi is not null and
         nvl(parameter.p_indi_cobr_inte_bole_fact, 'B') <> 'B' then
        --Si p_indi_cobr_inte_bole_fact esta en 'B' no se debe mostrar el mensaje para imprimir Factura de Intereses.
        --por que el interes ya se incluye dentrol del mismo recibo.
        -- pp_impr_fact_bole_tick;
        null;
      end if;
      i020007.pp_llamar_reporte(p_come_movi => bcab.movi_codi);
    else
      pl_me('El Movimiento ya ha sido generado. Avise al Administrador del Sistema.');
    end if;
  exception
    when salir then
      null;
  end pp_actualiza_registro;
  /*procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010,
                            v_mensaje || ' Error:' ||
                            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  end pl_me;*/
  procedure pp_carga_auto_impo_pago is
    v_impo_pago number;
    v_impo_tota number;
    v_gasto     number;
    --v_sum_impo_pago            number;
    v_importe_pago        number;
    v_impo_inte_mora      number;
    v_impo_inte_puni      number;
    v_impo_inte_gast_admi number;
    --v_sum_inte_mora_puni_gaad  number;
    --v_inte_mora_puni_orig      number;
    --v_impo_inte_mora_puni_gaad number;
    v_total_import number;
  begin
    v_impo_pago := v('P10_TOTAL_IMPORTE');
    v_impo_tota := 0;
    if v_impo_pago > 0 then
    
      for bdet in (select c001 marcado,
                          seq_id p_seq,
                          c002 movi_nume,
                          c003 impo_pago,
                          to_number(c007) imp_cuot_sal,
                          c017 impo_inte_mora_orig,
                          c018 impo_inte_puni_orig,
                          c019 impo_inte_gast_admi_orig,
                          c016 impo_inte_mora_puni_orig,
                          case
                            when nvl(parameter.p_indi_inte_cobr_app, 'N') = 'S' then
                             (nvl(c017, 0) + nvl(c018, 0) + nvl(c019, 0))
                          end gasto
                     from apex_collections a
                    where collection_name = 'BDETALLE'
                    order by seq_id) loop
      
        if v_impo_tota <= v('P10_TOTAL_IMPORTE') and v_impo_pago > 0 then
        
          pp_actualizar_member_coll(bdet.p_seq, 1, 'X');
        
          -- Calcula el importe de pago
          if (v_impo_pago - bdet.gasto) > bdet.imp_cuot_sal then
            v_importe_pago := bdet.imp_cuot_sal;
          else
            v_importe_pago := (v_impo_pago - bdet.gasto);
          end if;
        
          -- Verifica el indicador de inter?s cobrable
          if nvl(parameter.p_indi_inte_cobr_app, 'N') = 'S' then
            if v_importe_pago <= 0 then
            
              -- Calcula el monto de inter?s punitario
            
              v_impo_inte_puni := LEAST(v_impo_pago,
                                        bdet.impo_inte_puni_orig);
              v_impo_pago      := v_impo_pago - v_impo_inte_puni;
            
              -- Calcula el monto de inter?s por mora
              v_impo_inte_mora := LEAST(v_impo_pago,
                                        bdet.impo_inte_mora_orig);
              v_impo_pago      := v_impo_pago - v_impo_inte_mora;
            
              -- Calcula el monto de gasto administrativo
              v_impo_inte_gast_admi := LEAST(v_impo_pago,
                                             bdet.impo_inte_gast_admi_orig);
              --v_impo_pago           := v_impo_pago - v_impo_inte_gast_admi;
            
              --v_impo_pago    := 0;
              v_importe_pago := 0;
            else
              v_impo_inte_puni      := bdet.impo_inte_puni_orig;
              v_impo_inte_mora      := bdet.impo_inte_mora_orig;
              v_impo_inte_gast_admi := bdet.impo_inte_gast_admi_orig;
            end if;
          
          end if;
        
          v_gasto := nvl(v_impo_inte_puni, 0) + nvl(v_impo_inte_mora, 0) +
                     nvl(v_impo_inte_gast_admi, 0);
        
          pp_actualizar_member_coll(bdet.p_seq,
                                    22,
                                    case when v_importe_pago < 0 then 0 else
                                    v_importe_pago end);
        
          pp_actualizar_member_coll(bdet.p_seq,
                                    31,
                                    (nvl(v_importe_pago, 0) +
                                    nvl(v_gasto, 0)));
        
          pp_actualizar_member_coll(bdet.p_seq, 28, v_impo_inte_puni);
          pp_actualizar_member_coll(bdet.p_seq, 29, v_impo_inte_mora);
          pp_actualizar_member_coll(bdet.p_seq, 27, v_impo_inte_gast_admi);
          pp_actualizar_member_coll(bdet.p_seq, 30, v_gasto);
        
          select nvl(sum(c031), 0)
            into v_total_import
            from apex_collections a
           where collection_name = 'BDETALLE'
             and c001 = 'X';
        
          v_impo_pago           := (v('P10_TOTAL_IMPORTE') - v_total_import);
          v_impo_tota           := v_impo_tota + v_importe_pago;
          v_impo_inte_puni      := 0;
          v_impo_inte_mora      := 0;
          v_impo_inte_gast_admi := 0;
        end if;
        -- Verifica condiciones de salida del bucle
        if v_impo_tota >= v('P10_TOTAL_IMPORTE') or v_impo_pago <= 0 then
          exit;
        else
          if bdet.movi_nume is null then
            exit;
          end if;
        end if;
      end loop;
    
    end if;
  end pp_carga_auto_impo_pago;

  procedure pp_set_variable is
    v_prueba number;
  begin
    bcab.movi_clpr_indi_judi      := v('P10_CLPR_INDI_JUDI');
    bcab.movi_clpr_indi_exce      := v('P10_CLPR_INDI_EXCE');
    bcab.movi_nume                := v('P10_MOVI_NUME');
    bcab.movi_clpr_codi           := v('P10_CLPR_CODI');
    bcab.movi_fech_emis           := v('P10_S_MOVI_FECH_EMIS');
    bcab.movi_mone_codi           := v('P10_MOVI_MONE_CODI');
    bcab.movi_timo_codi           := v('P10_MOVI_TIMO_CODI');
    bcab.movi_afec_sald           := v('P10_MOVI_AFEC_SALD');
    bcab.movi_dbcr                := v('P10_MOVI_DBCR');
    bcab.movi_fech_oper           := v('P10_MOVI_FECH_OPER');
    bcab.movi_sucu_codi_orig      := v('P10_MOVI_SUCU_CODI_ORIG');
    bcab.movi_tasa_mone           := v('P10_MOVI_TASA_MONE');
    bcab.movi_obse                := v('P10_MOVI_OBSE');
    bcab.movi_clpr_desc           := v('P10_MOVI_CLPR_DESC');
    bcab.movi_clpr_ruc            := v('P10_CLPR_RUC');
    bcab.movi_empr_codi           := v('AI_EMPR_CODI');
    bcab.movi_empl_codi           := v('P10_EMPL_CODI');
    bcab.movi_clpr_situ           := v('P10_CLPR_SITU');
    bcab.movi_clpr_empl_codi_recl := v('P10_CLPR_EMPL_CODI_RECL');
    bcab.movi_emit_reci           := v('P10_EMIT_RECI');
    bcab.s_clpr_agen_codi         := v('P10_CLPR_AGEN_CODI');
    bcab.sucu_nume_item           := v('P10_SUCU_NUME_ITEM');
    bcab.movi_tico_codi           := v('P10_MOVI_TICO_CODI');
    bcab.tico_indi_vali_nume      := v('P10_TICO_INDI_VALI_NUME');
    bcab.s_dife                   := v('P10_S_DIFE');
  
    if v('P10_TOTAL_IMPORTE') > 0 then
      bcab.movi_exen_mone_tota := v('P10_TOTAL_IMPORTE');
    else
      -- +
      bcab.movi_exen_mone_tota := v('P10_MOVI_EXEN_MONE_TOTA');
    end if;
  
    bcab.movi_mone_cant_deci := v('P10_MOVI_MONE_CANT_DECI');
    bcab.clpr_indi_exce      := v('P10_CLPR_INDI_EXCE');
    bcab.movi_tare_codi      := v('P10_MOVI_TARE_CODI');
    bcab.tare_indi_talo_manu := v('P10_tare_indi_talo_manu');
    ---
    bcab.s_impo_efec                  := v('P10_S_IMPO_EFEC');
    bcab.s_impo_cheq                  := v('P10_S_IMPO_CHEQ');
    bcab.s_impo_rete                  := v('P10_S_IMPO_RETE');
    bcab.s_impo_rete_reci             := v('P10_S_IMPO_RETE_RECI');
    bcab.s_impo_tarj                  := v('P10_S_IMPO_TARJ');
    bcab.cabe_sum_inte_mora_puni_gaad := v('P10_SUM_INTE_MORA_PUNI_GAAD');
    bcab.cabe_inte_mora_puni_cobr     := v('P10_CABE_INTE_MORA_PUNI_COBR');
    bcab.cabe_impo_maxi_desc_inte     := v('P10_CABE_IMPO_MAXI_DESC_INTE');
    --bcab.tota_impo_inte_puni          := v('P10_SUM_INTE_MORA_PUNI_GAAD');
    --bcab.tota_impo_inte_mora          := v('P10_CABE_SUM_INTE_MORA_PUNI');
  
    if nvl(bcab.tare_indi_talo_manu, 'N') = 'S' then
      bcab.movi_indi_auto_impr := 'N';
    else
      bcab.movi_indi_auto_impr := 'S';
    end if;
    begin
      select c011 clpr_codi,
             c003 movi_mone_codi,
             sum(c022) impo_pago,
             sum(c028) + sum(c029) + sum(c027) sum_inte_mora_puni,
             sum(c029) impo_inte_mora,
             sum(c028) impo_inte_puni,
             sum(c027) impo_inte_gast_admi,
             sum(c027) ddddd
        into bcab.clpr_codi_det,
             bcab.mone_codi_det,
             bcab.sum_impo_pago,
             bcab.sum_inte_mora_puni,
             bcab.tota_impo_inte_mora,
             bcab.tota_impo_inte_puni,
             bcab.tota_impo_inte_gast_admi,
             v_prueba
        from apex_collections a
       where collection_name = 'BDETALLE'
         and c001 = 'X'
       group by c011, c003;
    exception
      when no_data_found then
        null;
    end;
    --    raise_application_error(-20001, bcab.sum_inte_mora_puni);
    bcab.s_dife_mmnn    := round(((bcab.s_dife) * bcab.movi_tasa_mone),
                                 parameter.p_cant_deci_mmnn);
    bcab.movi_exen_mone := bcab.sum_impo_pago;
    bcab.movi_exen_mmnn := round(((bcab.movi_exen_mone_tota) *
                                 bcab.movi_tasa_mone),
                                 parameter.p_cant_deci_mmnn);
  end pp_set_variable;

  procedure pp_guarda_registro is
  begin
  
    pp_set_variable;
  
    if nvl(bcab.movi_clpr_indi_judi, 'N') = 'S' then
      if nvl(bcab.movi_clpr_indi_exce, 'N') = 'N' then
        -- Si esta en Excepcion solo se advierte
        pl_me('El Cliente se encuentra en estado Judicial.. Favor comunicarse con el departamento de Creditos.');
      end if;
    end if;
    declare
      v_count number;
    begin
      select count(*)
        into v_count
        from come_movi_anul, come_tipo_movi
       where anul_timo_codi = timo_codi
         and timo_tico_codi = bcab.movi_tico_codi
         and anul_nume = bcab.movi_nume;
      if v_count > 0 then
        pl_me('El comprobante ya ha sido Anulado. Verifique el numero de comprobante. ' ||
              bcab.movi_nume);
      end if;
    end;
  
    if bcab.movi_nume is null then
      pl_me('Debe ingresar el numero del recibo!.');
    end if;
  
    pp_veri_auto_clie;
    pp_validar_importe_auto_inte;
  
    pp_valida_campo_marcado_1;
    pp_valida_forma_pago;
    pp_actualiza_registro;
    --apex_application.g_print_success_message:='fellaa';
    --DBMS_LOCK.SLEEP(5);
  
    --INSERT INTO temporal_notification (notification_text, display_until)
    --VALUES ('El proceso se ha completado con ?xito.', SYSTIMESTAMP + INTERVAL '5' SECOND);
  
  end pp_guarda_registro;

  function fp_format(i_number in number, i_decimals in number)
    return varchar2 is
    v_formatted_number varchar2(100);
    v_formato          varchar2(100) := '999G999G999G999G999G999';
  begin
    if i_decimals > 0 then
      v_formato := v_formato || 'D' || rpad('0', i_decimals, '0');
    end if;
    -- Format the number with the specified decimals
    v_formatted_number := trim(to_char(i_number, v_formato));
    -- Return the formatted number
    return v_formatted_number;
  end fp_format;

  procedure pp_generar_consulta(i_app_session in number,
                                i_empr_codi   in number,
                                i_movi_codi   in number default null) is
    v_sql   varchar2(10000);
    v_where varchar2(500);
  begin
  
    v_where := v_where || ' and nvl(m.movi_empr_codi,1) = ' ||
               to_char(i_empr_codi);
  
    if i_movi_codi is not null then
      v_where := v_where || ' and m.movi_codi = ' || to_char(i_movi_codi);
    end if;
  
    delete come_tabl_auxi
     where taax_sess = i_app_session
       and taax_user = fp_user;
    commit;
  
    v_sql := 'insert into come_tabl_auxi
      (taax_sess,
       taax_user,
       taax_n001,
       taax_c002,
       taax_c003,
       taax_c004,
       taax_n002,
       taax_c006,
       taax_c007,
       taax_c008,
       taax_c009,
       taax_c010,
       taax_c011,
       taax_c012,
       taax_c013,
       taax_c014,
       taax_c015,
       taax_c016,
       taax_c017,
       taax_c018,
       taax_c019,
       taax_c020,
       taax_c021,
       taax_c022,
       taax_c023,
       taax_c024,
       taax_c025,
       taax_c026,
       taax_c027,
       taax_c028,
       taax_c029,
       taax_c030,
       taax_c031,
       taax_n003,
       taax_c033,
       taax_c034,
       taax_c035,
       taax_c036,
       taax_n004,
       taax_c038,
       taax_c039,
       taax_c040,
       taax_c041,
       taax_n005,
       taax_n006,
       taax_c044,
       taax_c045,
       taax_n007,
       taax_n008,
       taax_seq)
select ' || i_app_session || ',
       ' || chr(39) || fp_user || chr(39) || ',
       c.*,
       seq_come_tabl_auxi.nextval
  from (
select m.movi_nume,
       (substr(lpad(to_char(m.movi_nume), 13, ' || chr(39) || '0' ||
             chr(39) || '), 1, 3) || ' || chr(39) || '-' || chr(39) || ' ||
       substr(lpad(to_char(m.movi_nume), 13, ' || chr(39) || '0' ||
             chr(39) || '), 4, 3) || ' || chr(39) || '-' || chr(39) || ' ||
       substr(lpad(to_char(m.movi_nume), 13, ' || chr(39) || '0' ||
             chr(39) || '), 7, 8)) inte_movi_nume,
       m.movi_codi,
       m.movi_fech_emis inte_movi_fech_emis,
       m.movi_impo_mone_ii inte_impo_mone,
       m.movi_codi_padr inte_movi_codi_padr,
       to_char(m.movi_fech_emis, ' || chr(39) || 'DD' ||
             chr(39) || ') dia,
       to_char(m.movi_fech_emis, ' || chr(39) || 'Month' ||
             chr(39) || ') mes,
       to_char(m.movi_fech_emis, ' || chr(39) || 'YYYY' ||
             chr(39) || ') ahno,
             ''Pago de Cuot. Fecha Venimiento: ''||cuot_fech_venc movi_obse,
       t.timo_codi,
       t.timo_desc,
       e.empr_codi,
       e.empr_ruc,
       e.empr_desc,
       nvl(o.mone_codi, 1) mone_codi,
       o.mone_desc,
       o.mone_cant_deci,
       cb.cuen_codi,
       cb.cuen_desc,
       cp.clpr_codi,
       cp.clpr_codi_alte,
       cp.clpr_desc,
       cp.clpr_dire,
       cp.clpr_tele,
       ag.empl_codi agen_codi,
       ve.empl_codi vend_codi,
       ag.empl_desc agen_desc,
       ve.empl_desc vend_desc,
       decode(nvl(t.timo_indi_sald, ' || chr(39) || 'N' ||
             chr(39) || '), ' || chr(39) || 'S' || chr(39) || ', ' ||
             chr(39) || 'Credito' || chr(39) || ', ' || chr(39) ||
             'Contado' || chr(39) || ') tipo_fact,
       decode(cp.clpr_indi_clie_prov,
              ' || chr(39) || 'C' || chr(39) || ',
              ' || chr(39) || 'Cliente' || chr(39) || ',
              ' || chr(39) || 'P' || chr(39) || ',
              ' || chr(39) || 'Proveedor' || chr(39) || ',
              null) clpr_label,
       (movi_exen_mone + movi_grav_mone + movi_iva_mone) total,
       cp.clpr_desc clpr_desc_banc,
       cp.clpr_ruc,
       c.cheq_nume,
       d.banc_desc,
       c.cheq_impo_mone,
       c.cheq_fech_depo,
       cuot.de_movi_nume, 
       cuot.de_movi_fech_emis,
       cuot.cuot_fech_venc,
       cuot.impo_cuot,
       cuot.sald_ante_cuot,
       cuot.pa_movi_nume,
       cuot.canc_fech_pago,
       cuot.canc_impo_mone,
       cuot.sald_actu_cuot
  from come_movi m,
       come_tipo_movi t,
       come_empr e,
       come_mone o,
       come_clie_prov cp,
       come_cuen_banc cb,
       come_empl ve,
       come_empl ag,
       come_movi_cheq b,
       come_cheq c,
       come_banc d,
       (select (substr(lpad(to_char(de.movi_nume), 13, ' ||
             chr(39) || '0' || chr(39) || '), 1, 3) || ' || chr(39) || '-' ||
             chr(39) || ' ||
               substr(lpad(to_char(de.movi_nume), 13, ' ||
             chr(39) || '0' || chr(39) || '), 4, 3) || ' || chr(39) || '-' ||
             chr(39) || ' ||
               substr(lpad(to_char(de.movi_nume), 13, ' ||
             chr(39) || '0' || chr(39) || '), 7, 8)) de_movi_nume,
               de.movi_fech_emis de_movi_fech_emis,
               cu.cuot_fech_venc,
               cu.cuot_impo_mone impo_cuot,
               sum(cu.cuot_sald_mone + ca.canc_impo_mone) sald_ante_cuot,
               m.movi_nume pa_movi_nume,
               ca.canc_fech_pago,
               sum(ca.canc_impo_mone) canc_impo_mone,
               cu.cuot_sald_mone sald_actu_cuot,
               m.movi_codi movi_codi_df
          from come_movi           de,
               come_movi_cuot      cu,
               come_movi_cuot_canc ca,
               come_movi           m
         where de.movi_codi = cu.cuot_movi_codi
           and m.movi_codi = ca.canc_movi_codi
           and cu.cuot_movi_codi = ca.canc_cuot_movi_codi
           and cu.cuot_fech_venc = ca.canc_cuot_fech_venc
            group by de.movi_nume,de.movi_fech_emis,cu.cuot_fech_venc,cu.cuot_sald_mone, m.movi_nume,cu.cuot_impo_mone,  m.movi_codi,
               ca.canc_fech_pago) cuot
 where m.movi_timo_codi = t.timo_codi
   and m.movi_empr_codi = e.empr_codi(+)
   and m.movi_mone_codi = o.mone_codi(+)
   and m.movi_clpr_codi = cp.clpr_codi(+)
   and m.movi_cuen_codi = cb.cuen_codi(+)
   and m.movi_empl_codi = ve.empl_codi(+)
   and cp.clpr_empl_codi = ag.empl_codi(+)
   and m.movi_codi = b.chmo_movi_codi(+)
   and b.chmo_cheq_codi = c.cheq_codi(+)
   and c.cheq_banc_codi = d.banc_codi(+)
   and m.movi_codi = cuot.movi_codi_df(+)
   ---and m.movi_aqui_pago_codi is not null
   and m.movi_timo_codi = 13
   ' || v_where || '
 order by cuot.de_movi_fech_emis, cuot.de_movi_nume) c
 ';
    /*insert into come_concat (campo1, otro) values (V_SQL, 'MMMM');
    COMMIT; */
  
    execute immediate v_sql;
  end pp_generar_consulta;

  procedure carga_inicial_deta is
    v_deta number := 0;
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
  
    while v_deta < 3 loop
      v_deta := v_deta + 1;
      apex_collection.add_member(p_collection_name => 'BDETALLE',
                                 p_c001            => null,
                                 p_c002            => null,
                                 p_c003            => null,
                                 p_c004            => null,
                                 p_c005            => null,
                                 p_c006            => null,
                                 p_c007            => null,
                                 p_c008            => null,
                                 p_c009            => null,
                                 p_c010            => null,
                                 p_c011            => null,
                                 p_c012            => null,
                                 p_c013            => null,
                                 p_c014            => null,
                                 p_c015            => null,
                                 p_c016            => null,
                                 p_c017            => null,
                                 p_c018            => null,
                                 p_c019            => null,
                                 p_c020            => null,
                                 p_c021            => null,
                                 p_c022            => null,
                                 p_c023            => 0,
                                 p_c024            => 0,
                                 p_c025            => 0,
                                 p_c026            => 0,
                                 p_c027            => 0,
                                 p_c028            => 0,
                                 p_c029            => 0,
                                 p_c030            => 0,
                                 p_c031            => 0);
    end loop;
  
  end carga_inicial_deta;

  procedure pp_busqueda_clie_prov(p_busc_dato       in varchar2,
                                  p_clpr_codi_alte  out varchar2,
                                  p_indi_list_value out number) is
  
    salir  exception;
    v_cant number;
  
    function fi_buscar_clie_prov_alte(p_busc_dato      in varchar2,
                                      p_clpr_codi_alte out varchar2)
      return boolean is
      v_clpr_esta varchar2(1);
    begin
      select cp.clpr_codi_alte, nvl(cp.clpr_esta, 'A')
        into p_clpr_codi_alte, v_clpr_esta
        from come_clie_prov cp
       where cp.clpr_indi_clie_prov = 'C'
         and cp.clpr_codi_alte = p_busc_dato;
    
      if v_clpr_esta <> 'A' then
        p_indi_list_value := 0;
        raise_application_error(-20001, 'error: ' || sqlerrm);
      end if;
    
      return true;
    
    exception
      when no_data_found then
        return false;
      when invalid_number then
        return false;
      when others then
        return false;
    end;
  
    function fi_buscar_clie_prov_ruc(p_busc_dato      in varchar2,
                                     p_clpr_codi_alte out varchar2)
      return boolean is
      v_clpr_esta varchar2(1);
    begin
      select cp.clpr_codi_alte, nvl(cp.clpr_esta, 'A')
        into p_clpr_codi_alte, v_clpr_esta
        from come_clie_prov cp
       where cp.clpr_indi_clie_prov = 'C'
         and cp.clpr_ruc = p_busc_dato;
    
      if v_clpr_esta <> 'A' then
        p_indi_list_value := 0;
        raise_application_error(-20001, 'error: ' || sqlerrm);
      end if;
    
      return true;
    
    exception
      when no_data_found then
        return false;
      when invalid_number then
        return false;
      when others then
        return false;
    end;
  
  begin
    --buscar cliente/proveedor por codigo de alternativo
    if fi_buscar_clie_prov_alte(p_busc_dato, p_clpr_codi_alte) then
      p_indi_list_value := 0;
      raise salir;
    end if;
  
    --buscar cliente/proveedor por ruc
    if fi_buscar_clie_prov_ruc(p_busc_dato, p_clpr_codi_alte) then
      p_indi_list_value := 0;
      raise salir;
    end if;
  
    begin
      select count(*)
        into v_cant
        from come_clie_prov cp
       where cp.clpr_indi_clie_prov = 'C'
         and nvl(cp.clpr_esta, 'A') = 'A'
         and (upper(cp.clpr_codi_alte) like '%' || p_busc_dato || '%' or
             upper(cp.clpr_ruc) like '%' || p_busc_dato || '%' or
             upper(cp.clpr_desc) like '%' || p_busc_dato || '%');
    end;
  
    if v_cant >= 1 then
      --si existe al menos un cliente/proveedor con esos criterios entonces mostrar la lista      
      setitem('P10_CLPR_CODI', null);
      p_clpr_codi_alte  := p_busc_dato;
      p_indi_list_value := 1;
    else
      p_clpr_codi_alte  := p_busc_dato;
      p_indi_list_value := 1;
    end if;
  
  exception
    when salir then
      p_indi_list_value := 0;
    when others then
      raise_application_error(-20001, 'error: ' || sqlerrm);
  end pp_busqueda_clie_prov;

  procedure pp_busqueda_moneda(p_busc_dato       in varchar2,
                               p_movi_mone_codi  out varchar2,
                               p_indi_list_value out number) is
  
    salir  exception;
    v_cant number;
  
    function fi_buscar_mone_codi(p_busc_dato      in varchar2,
                                 p_movi_mone_codi out varchar2)
      return boolean is
    begin
      select mo.mone_codi_alte
        into p_movi_mone_codi
        from come_mone mo
       where mo.mone_codi_alte = p_busc_dato;
    
      return true;
    
    exception
      when no_data_found then
        return false;
      when invalid_number then
        return false;
      when others then
        return false;
    end;
  
    function fi_buscar_mone_desc(p_busc_dato      in varchar2,
                                 p_movi_mone_codi out varchar2)
      return boolean is
    begin
      select mo.mone_codi_alte
        into p_movi_mone_codi
        from come_mone mo
       where upper(mo.mone_desc) = upper(p_busc_dato);
    
      return true;
    
    exception
      when no_data_found then
        return false;
      when invalid_number then
        return false;
      when others then
        return false;
    end;
  
  begin
    --buscar moneda por codigo de alternativo
    if fi_buscar_mone_codi(p_busc_dato, p_movi_mone_codi) then
      p_indi_list_value := 0;
      raise salir;
    end if;
  
    --buscar moneda por descripcion
    if fi_buscar_mone_desc(p_busc_dato, p_movi_mone_codi) then
      p_indi_list_value := 0;
      raise salir;
    end if;
  
    begin
      select count(*)
        into v_cant
        from come_mone mo
       where (upper(mo.mone_codi_alte) like '%' || p_busc_dato || '%' or
             upper(mo.mone_desc) like '%' || p_busc_dato || '%');
    end;
  
    if v_cant >= 1 then
      --si existe al menos una moneda con esos criterios entonces mostrar la lista      
      setitem('P10_MOVI_MONE_CODI', null);
      p_movi_mone_codi  := p_busc_dato;
      p_indi_list_value := 1;
    else
      p_movi_mone_codi  := p_busc_dato;
      p_indi_list_value := 1;
    end if;
  
  exception
    when salir then
      p_indi_list_value := 0;
    when others then
      raise_application_error(-20001, 'error: ' || sqlerrm);
  end pp_busqueda_moneda;

  procedure pp_busqueda_cobrador(p_busc_dato       in varchar2,
                                 p_empl_codi_alte  out varchar2,
                                 p_indi_list_value out number) is
  
    salir  exception;
    v_cant number;
  
    function fi_buscar_empl_codi_alte(p_busc_dato      in varchar2,
                                      p_empl_codi_alte out varchar2)
      return boolean is
    begin
    
      select e.empl_codi_alte
        into p_empl_codi_alte
        from come_empl e, come_empl_tiem t
       where e.empl_codi = t.emti_empl_codi
         and t.emti_tiem_codi = parameter.p_codi_tipo_empl_cobr
         and e.empl_empr_codi = g_empresa
         and nvl(empl_esta, 'A') = 'A'
         and ltrim(rtrim(lower(e.empl_codi_alte))) =
             ltrim(rtrim(lower(p_busc_dato)));
    
      return true;
    
    exception
      when no_data_found then
        return false;
      when invalid_number then
        return false;
      when others then
        return false;
    end;
  
    function fi_buscar_empl_desc(p_busc_dato      in varchar2,
                                 p_empl_codi_alte out varchar2)
      return boolean is
    begin
      select e.empl_codi_alte
        into p_empl_codi_alte
        from come_empl e, come_empl_tiem t
       where e.empl_codi = t.emti_empl_codi
         and t.emti_tiem_codi = parameter.p_codi_tipo_empl_cobr
         and e.empl_empr_codi = g_empresa
         and nvl(empl_esta, 'A') = 'A'
         and upper(e.empl_desc) = upper(p_busc_dato);
    
      return true;
    
    exception
      when no_data_found then
        return false;
      when invalid_number then
        return false;
      when others then
        return false;
    end;
  
  begin
    --buscar moneda por codigo de alternativo
    if fi_buscar_empl_codi_alte(p_busc_dato, p_empl_codi_alte) then
      p_indi_list_value := 0;
      raise salir;
    end if;
  
    --buscar moneda por descripcion
    if fi_buscar_empl_desc(p_busc_dato, p_empl_codi_alte) then
      p_indi_list_value := 0;
      raise salir;
    end if;
  
    begin
      select count(*)
        into v_cant
        from come_empl e, come_empl_tiem t
       where e.empl_codi = t.emti_empl_codi
         and t.emti_tiem_codi = parameter.p_codi_tipo_empl_cobr
         and e.empl_empr_codi = g_empresa
         and nvl(empl_esta, 'A') = 'A'
         and (upper(e.empl_codi_alte) like '%' || p_busc_dato || '%' or
             upper(e.empl_desc) like '%' || p_busc_dato || '%');
    end;
  
    if v_cant >= 1 then
      --si existe al menos un cobrador con esos criterios entonces mostrar la lista      
      setitem('P10_EMPL_CODI', null);
      p_empl_codi_alte  := p_busc_dato;
      p_indi_list_value := 1;
    else
      p_empl_codi_alte  := p_busc_dato;
      p_indi_list_value := 1;
    end if;
  
  exception
    when salir then
      p_indi_list_value := 0;
    when others then
      raise_application_error(-20001, 'error: ' || sqlerrm);
  end pp_busqueda_cobrador;

end i020007;
