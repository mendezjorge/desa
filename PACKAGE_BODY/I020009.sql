
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020009" is

  /**********************************************************************/
  /************************** PARAMETROS*********************************/
  /**********************************************************************/

  p_cant_dias_feri number := 0;

  p_codi_timo_extr_banc    number := to_number(fa_busc_para('p_codi_timo_extr_banc'));
  p_codi_conc_cheq_cred    number := to_number(fa_busc_para('p_codi_conc_cheq_cred'));
  p_modi_fech_fopa_dife    varchar2(1) := 'N';
  p_cobr_vent_indi_cobr_fp varchar2(1) := 'N';
  p_hoja_ruta_indi_cobr_fp varchar2(1) := 'N';

  ---Indicador si aplicara retencion y retencion reta sobre el exento
  p_indi_apli_rete_exen varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_apli_rete_exen'))));

  p_codi_oper_com       number := to_number(fa_busc_para('p_codi_oper_com'));
  p_indi_most_secc_dbcr varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_most_secc_dbcr'))));

  p_indi_exig_talo              varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_exig_talo'))));
  p_codi_timo_fcor              number := to_number(fa_busc_para('p_codi_timo_fcor'));
  p_codi_timo_fcrr              number := to_number(fa_busc_para('p_codi_timo_fcrr'));
  p_codi_timo_pcor              number := to_number(fa_busc_para('p_codi_timo_pcor'));
  p_codi_timo_pcrr              number := to_number(fa_busc_para('p_codi_timo_pcrr'));
  p_codi_timo_rete_emit         number := to_number(fa_busc_para('p_codi_timo_rete_emit'));
  p_codi_timo_rete_reci         number := to_number(fa_busc_para('p_codi_timo_rete_reci'));
  p_codi_timo_adlr              number := to_number(fa_busc_para('p_codi_timo_adlr'));
  p_codi_timo_adle              number := to_number(fa_busc_para('p_codi_timo_adle'));
  p_codi_timo_rcnadle           number := to_number(fa_busc_para('p_codi_timo_rcnadle'));
  p_codi_timo_cnncre            number := to_number(fa_busc_para('p_codi_timo_cnncre'));
  p_codi_timo_rcnadlr           number := to_number(fa_busc_para('p_codi_timo_rcnadlr'));
  p_codi_timo_cnncrr            number := to_number(fa_busc_para('p_codi_timo_cnncrr'));
  p_codi_timo_valr              number := to_number(fa_busc_para('p_codi_timo_valr'));
  p_codi_timo_auto_fact_emit    number := to_number(fa_busc_para('p_codi_timo_auto_fact_emit'));
  p_codi_timo_auto_fact_emit_cr number := to_number(fa_busc_para('p_codi_timo_auto_fact_emit_cr'));

  p_codi_impu_exen   number := to_number(fa_busc_para('p_codi_impu_exen'));
  p_codi_impu_grav10 number := to_number(fa_busc_para('p_codi_impu_grav10'));
  p_codi_impu_grav5  number := to_number(fa_busc_para('p_codi_impu_grav5'));
  p_codi_mone_mmnn   number := to_number(fa_busc_para('p_codi_mone_mmnn'));

  p_cant_deci_porc      number := to_number(fa_busc_para('p_cant_deci_porc'));
  p_cant_deci_mmnn      number := to_number(fa_busc_para('p_cant_deci_mmnn'));
  p_cant_deci_mmee      number := to_number(fa_busc_para('p_cant_deci_mmee'));
  p_cant_deci_cant      number := to_number(fa_busc_para('p_cant_deci_cant'));
  p_cant_deci_prec_unit number := to_number(fa_busc_para('p_cant_deci_prec_unit'));

  p_indi_impr_cheq_emit varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_impr_cheq_emit'))));
  p_indi_vali_repe_cheq varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_vali_repe_cheq'))));

  p_indi_habi_vuelto         varchar2(1) := fa_busc_para('p_indi_habi_vuelto_cob');
  p_habi_camp_cent_cost_dbcr varchar2(500) := rtrim(ltrim(fa_busc_para('p_habi_camp_cent_cost_dbcr')));

  p_codi_clie_espo number := to_number(fa_busc_para('p_codi_clie_espo'));
  p_codi_prov_espo number := to_number(fa_busc_para('p_codi_prov_espo'));

  p_form_impr_dbcr_auto varchar2(500) := ltrim((rtrim(fa_busc_para('p_form_impr_dbcr_auto'))));
  p_form_impr_dbcr_fcor varchar2(500) := ltrim((rtrim(fa_busc_para('p_form_impr_dbcr_fcor'))));
  p_form_impr_movi_cont varchar2(500) := ltrim((rtrim(fa_busc_para('p_form_impr_movi_cont'))));

  p_indi_perm_fech_futu_dbcr varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_perm_fech_futu_dbcr'))));

  p_form_impr_nota_debi      number := to_number(fa_busc_para('p_form_impr_nota_debi'));
  p_tipo_comp_nota_debi_emit number := to_number(fa_busc_para('p_tipo_comp_nota_debi_emit'));

  p_fech_inic date;
  p_fech_fini date;

  p_codi_base number := pack_repl.fa_devu_codi_base;

  p_indi_vali_nume_dbcr      varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_vali_nume_dbcr'))));
  p_indi_most_apli_tick_dbcr varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_most_apli_tick_dbcr'))));

  p_imp_min_aplic_reten        number := to_number(fa_busc_para('p_imp_min_aplic_reten'));
  p_porc_aplic_reten           number := to_number(fa_busc_para('p_porc_aplic_reten'));
  p_codi_conc_rete_emit        number := to_number(fa_busc_para('p_codi_conc_rete_emit'));
  p_codi_conc_rete_reci        number := to_number(fa_busc_para('p_codi_conc_rete_reci'));
  p_form_calc_rete_emit        number := to_number(fa_busc_para('p_form_calc_rete_emit'));
  p_indi_most_mens_sali        varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_most_mens_sali'))));
  p_form_impr_rete             varchar2(500) := ltrim((rtrim(fa_busc_para('p_form_impr_rete'))));
  p_indi_impr_dbcr             varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_impr_dbcr'))));
  p_indi_porc_rete_sucu        varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_porc_rete_sucu'))));
  p_nave_dato_rete             varchar2(500) := ltrim((rtrim(fa_busc_para('p_nave_dato_rete'))));
  p_apli_rete_exen_defe        varchar2(500) := ltrim((rtrim(fa_busc_para('p_apli_rete_exen_defe'))));
  p_codi_conc_rete_rent_emit   number := to_number(fa_busc_para('p_codi_conc_rete_rent_emit'));
  p_porc_aplic_reten_iva_ext   number := to_number(fa_busc_para('p_porc_aplic_reten_iva_ext'));
  p_porc_aplic_reten_rent      number := to_number(fa_busc_para('p_porc_aplic_reten_rent'));
  p_porc_aplic_reten_rent_abso number := to_number(fa_busc_para('p_porc_aplic_reten_rent_abso'));
  p_indi_most_fact_bole        varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_most_fact_bole'))));
  p_indi_nave_dato_rete        varchar2(1) := 'N';
  p_para_inic                  varchar2(500) := 'MDBCR';

  p_indi_modi varchar2(1) := case
                               when nvl(p_para_inic, 'DBCR') = 'MDBCR' then
                                'S'
                               else
                                'N'
                             end;

  --orden de servicio
  p_indi_rela_nume_serv      varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_rela_nume_serv'))));
  p_indi_perm_fech_vale_supe varchar2(500) := rtrim(ltrim(fa_busc_para('p_indi_perm_fech_vale_supe')));

  p_indi_most_desc_conc_dbcr varchar2(500) := rtrim(ltrim(fa_busc_para('p_indi_most_desc_conc_dbcr')));
  p_indi_rete_tesaka         varchar2(500) := rtrim(ltrim(fa_busc_para('p_indi_rete_tesaka')));
  p_indi_most_chec_rete_mini varchar2(500) := rtrim(ltrim(fa_busc_para('p_indi_most_chec_rete_mini')));
  p_indi_asie_on_line        varchar2(500) := rtrim(ltrim(fa_busc_para('p_indi_asie_on_line')));
  p_indi_auto_fact_impu_calc varchar2(500) := rtrim(ltrim(fa_busc_para('p_indi_auto_fact_impu_calc')));
  p_indi_fopa_chta_caja      varchar2(500) := ltrim((rtrim(fa_busc_para('p_indi_fopa_chta_caja'))));

  ---codigo por defecto de empleado, concepto, sucursal y cliente/proveedor
  p_codi_empl_defa           number := to_number(fa_busc_para('p_codi_empl_defa'));
  p_codi_sucu_defa           number := to_number(fa_busc_para('p_codi_sucu_defa'));
  p_codi_conc_dbcr_defa      number := to_number(fa_busc_para('p_codi_conc_dbcr_defa'));
  p_codi_clpr_dbcr_defa      number := to_number(fa_busc_para('p_codi_clpr_dbcr_defa'));
  p_indi_vali_limi_costo     varchar2(500) := upper(ltrim(rtrim(fa_busc_para('p_indi_vali_limi_costo'))));
  p_indi_most_camp_sucu_dbcr varchar2(500) := upper(ltrim(rtrim(fa_busc_para('p_indi_most_camp_sucu_dbcr'))));
  p_codi_impr_defe           number := to_number(fa_busc_para('p_codi_impr_defe'));
  p_form_impr_fact           varchar2(500) := ltrim(rtrim(fa_busc_para('p_form_impr_fact')));
  p_indi_most_dist           varchar2(500) := rtrim(ltrim(fa_busc_para('p_indi_most_dist')));
  p_indi_pres_dist           varchar2(1) := 'N';
  p_tipo_cons_inte           varchar2(1) := fa_busc_para('p_tipo_cons_inte');

  p_indi_vali_clie_prov_dato varchar2(100) := upper(ltrim(rtrim(fa_busc_para('p_indi_vali_clie_prov_dato'))));
  p_maxi_line_impr_fact      number;
  p_max_cant_cara_item_fact  number;

  p_sucu_codi number := v('AI_SUCU_CODI');
  p_empr_codi number := v('AI_EMPR_CODI');
  p_session   varchar2(500) := v('APP_SESSION');
  p_usuario   varchar2(500) := gen_user;
  p_peco_codi number := 1;

  p_movi_codi_rete      number;
  p_movi_codi_rete_rent number;
  p_empr_retentora      varchar2(50);

  p_ind_validar_det varchar2(5) := 'S';

  --parametros de forma de pago
  p_vali_tipo_cheq_emit    varchar2(50) := null;
  p_impo_ante              varchar2(50) := null;
  p_validar_bloque_bfp_gen varchar2(50) := null;
  p_pago_tipo              varchar2(50) := null;
  p_validar_fp             varchar2(50) := null;
  p_record_bfp             varchar2(50) := null;
  p_validar_cheques        varchar2(50) := null;
  p_validar_tarjeta        varchar2(50) := null;

  p_emit_reci number;
  p_movi_codi number;
  
  p_indi_cons_docu         varchar2(500);
  
  
  /**********************************************************************/
  /************************** INICIAR  **********************************/
  /**********************************************************************/
  procedure pp_iniciar is
  begin
  
    p_movi_codi_rete      := null;
    p_movi_codi_rete_rent := null;
  
    begin
      select nvl(e.empr_retentora, 'NO')
        into p_empr_retentora
        from come_empr e
       where e.empr_codi = p_empr_codi;
    exception
      when no_data_found then
        raise_application_error(-20010, 'Empresa seleccionada inexistente');
      when others then
        raise_application_error(-20010, sqlerrm);
    end;
  
  end;

  procedure pp_asig_form_impr_secu_sucu(p_sucu_codi in number) is
    v_form_impr number;
    v_cant_line number;
    v_cant_cara number;
  begin
  
    select secu_form_impr_fact, SECU_CANT_LINE_FACT, SECU_CANT_CARA_FACT
      into v_form_impr, v_cant_line, v_cant_cara
      from come_secu s, come_pers_comp p
     where p.peco_secu_codi = s.secu_codi(+)
       and p.peco_codi = p_peco_codi;
  
    if nvl(v_form_impr, 0) <> 0 then
    
      p_form_impr_fact := v_form_impr;
    
      if nvl(v_cant_line, 0) <> 0 then
        p_maxi_line_impr_fact := v_cant_line;
      end if;
    
      if nvl(v_cant_cara, 0) <> 0 then
        p_max_cant_cara_item_fact := v_cant_cara;
      end if;
    
    else
    
      select sucu_form_impr_fact
        into v_form_impr
        from come_sucu
       where sucu_codi = nvl(p_sucu_codi, -1);
    
      if nvl(v_form_impr, 0) <> 0 then
        p_form_impr_fact := v_form_impr;
      end if;
    end if;
  
  exception
    when no_data_found then
      null;
    
  end;

  /**********************************************************************/
  /***********************ACTUALIZAR REGISTROS***************************/
  /**********************************************************************/

  procedure pp_actualizar_registro(ii_movi_indi_dist            in varchar2,
                                   ii_movi_codi                 in number,
                                   ii_f_dif_impo                in number,
                                   ii_f_dif_impo_exen_mone      in number,
                                   ii_f_dif_impo_grav5_ii_mone  in number,
                                   ii_f_dif_impo_grav10_ii_mone in number,
                                   ii_movi_afec_sald            in varchar2,
                                   ii_movi_mone_codi            in number,
                                   ii_movi_timo_codi            in number,
                                   ii_movi_timo_indi_caja       in varchar2,
                                   ii_movi_timo_indi_sald       in varchar2,
                                   ii_movi_timo_indi_adel       in varchar2,
                                   ii_movi_timo_indi_ncr        in varchar2,
                                   ii_clpr_indi_clie_prov       in varchar2,
                                   ii_s_total                   in number,
                                   
                                   ii_movi_clpr_codi           in number,
                                   ii_movi_nume                in number,
                                   ii_movi_fech_emis           in date,
                                   ii_movi_fech_oper           in date,
                                   ii_movi_tasa_mone           in number,
                                   ii_movi_grav_mmnn           in number,
                                   ii_movi_exen_mmnn           in number,
                                   ii_movi_iva_mmnn            in number,
                                   ii_movi_grav_mone           in number,
                                   ii_movi_exen_mone           in number,
                                   ii_movi_iva_mone            in number,
                                   ii_movi_obse                in varchar2,
                                   ii_movi_sald_mmnn           in number,
                                   ii_movi_sald_mone           in number,
                                   ii_movi_stoc_suma_rest      in number,
                                   ii_movi_clpr_dire           in varchar2,
                                   ii_movi_clpr_tele           in varchar2,
                                   ii_movi_clpr_ruc            in varchar2,
                                   ii_movi_clpr_desc           in varchar2,
                                   ii_movi_emit_reci           in varchar2,
                                   ii_movi_dbcr                in varchar2,
                                   ii_movi_stoc_afec_cost_prom in varchar2,
                                   ii_movi_empl_codi           in number,
                                   ii_movi_nume_timb           in number,
                                   ii_fech_venc_timb           in date,
                                   ii_movi_impo_mone_ii        in number,
                                   ii_movi_impo_mmnn_ii        in number,
                                   ii_movi_grav10_ii_mone      in number,
                                   ii_movi_grav5_ii_mone       in number,
                                   ii_movi_grav10_ii_mmnn      in number,
                                   ii_movi_grav5_ii_mmnn       in number,
                                   ii_movi_grav10_mone         in number,
                                   ii_movi_grav5_mone          in number,
                                   ii_movi_grav10_mmnn         in number,
                                   ii_movi_grav5_mmnn          in number,
                                   ii_movi_iva10_mone          in number,
                                   ii_movi_iva5_mone           in number,
                                   ii_movi_iva10_mmnn          in number,
                                   ii_movi_iva5_mmnn           in number,
                                   ii_sucu_nume_item           in number,
                                   ii_movi_indi_apli_tick      in varchar2,
                                   ii_movi_ticl_codi           in number,
                                   ii_movi_re90_codi           in number,
                                   ii_movi_re90_tipo           in number,
                                   ii_MOVI_INDI_IMPU_IRE       in varchar2,
                                   ii_MOVI_INDI_IMPU_IRP_RSP   in varchar2,
                                   ii_MOVI_INDI_NO_IMPU        in varchar2,
                                   ii_MOVI_INDI_IMPU_IVA       in varchar2,
                                   ii_s_impo_rete              in number,
                                   ii_s_impo_rete_rent         in number,
                                   ii_timo_dbcr_caja           in varchar2) is
    v_record number;
    v_resp   varchar2(1000);
  
    i_movi_codi  number;
  
    v_sum_cuot_impo_mone number;
  begin
    
  --cargamos unos parametros mas para actualizar registro
  begin
  I020009.pp_iniciar;
  end;

 -- raise_application_error(-20010, 'holaaas');

    begin
    
      select --taax_c001 as dias,
      --taax_c002 as fech_vencimiento,
       sum(taax_c003) as importe
        into v_sum_cuot_impo_mone
        from come_tabl_auxi
       where taax_sess = p_session
         and taax_user = p_usuario
         and taax_c050 = 'CUOTA';
    exception
      when no_data_found then
        v_sum_cuot_impo_mone := 0;
      
    end;
  
    if p_sucu_codi is null then
      raise_application_error(-20010, 'Debe indicar una sucursal');
    end if;
  
    if ii_movi_indi_dist = 'S' then
      if p_indi_pres_dist = 'N' then
        raise_application_error(-20010,
                                'Atención! Debe presionar el boton distribuir antes de guardar. ');
      end if;
    end if;
  
    ---***********************
   i_movi_codi := ii_movi_codi;
    --Eliminar documento en caso que exista movi_codi
    if ii_movi_codi is not null then
      I020009.pp_validar_asiento(ii_movi_codi);
      I020009.pp_borrar_registro(ii_movi_codi);
      i_movi_codi := null;
    end if;


    ---**********************
  
    /*if nvl(p_indi_cons_docu,'N') = 'N' then
      if p_win_hist = 'N' then
        pp_validar_nro;
        if i_tico_codi is not null then 
            pp_validar_timbrado (i_tico_codi, 
                                 i_s_nro_1,
                                 i_s_nro_2, 
                                 i_movi_clpr_codi, 
                                 i_movi_fech_emis, 
                                 i_movi_nume_timb, 
                                 i_fech_venc_timb,
                                 i_tico_indi_timb);   
             i_s_fech_venc_timb := to_char(i_fech_venc_timb, 'dd-mm-yyyy');                    
        end if;
      end if;
    end if; */
  
    -- pp_validar_registro_duplicado('adel');
    -- pp_validar_registro_duplicado('vale');
    -- pp_validar_registro_duplicado('cheq');
    --
  
    --pp_valida_totales
    begin
      I020009.pp_valida_totales(i_f_dif_impo                => ii_f_dif_impo,
                                i_F_DIF_IMPO_EXEN_MONE      => ii_F_DIF_IMPO_EXEN_MONE,
                                i_F_DIF_IMPO_GRAV5_II_MONE  => ii_F_DIF_IMPO_GRAV5_II_MONE,
                                i_F_DIF_IMPO_GRAV10_II_MONE => ii_F_DIF_IMPO_GRAV10_II_MONE,
                                i_movi_afec_sald            => ii_movi_afec_sald,
                                i_movi_mone_codi            => ii_movi_mone_codi);
    end;
  
    begin
      i020009.pp_valida_cheques;
    end;
  
    /* if (nvl(i_s_impo_rete, 0) > 0 or nvl(i_s_impo_rete_rent, 0) > 0) and :brete.movi_nume_timb_rete is null then
        go_item('brete.s_nro_3_rete');
        raise_application_error(-20010,'Debe indicar un numero de timbrado para la retencion');
      end if;
    */
  
    begin
      I020009.pp_validar_importes(i_movi_timo_codi      => ii_movi_timo_codi,
                                  i_movi_timo_indi_caja => ii_movi_timo_indi_caja,
                                  i_clpr_indi_clie_prov => ii_clpr_indi_clie_prov,
                                  i_s_total             => ii_s_total);
    
    end;
  
    if nvl(ii_movi_timo_indi_sald, 'N') = 'N' then
      ---si no afecta al saldo del cliente o proveedor
      null;
    else
      --afecta el saldo del cliente o proveedor 
      if ii_movi_afec_sald = 'N' then
        --pp_valida_forma_pago;
        declare
          V_s_impo_efec number;
        begin
          select sum(taax_c010)
            into V_s_impo_efec
            from come_tabl_auxi
           where taax_sess = p_session
             and taax_user = p_usuario
             and taax_c050 = 'FP';
        
          if V_s_impo_efec = 0 then
            raise_application_error(-200100,
                                    'No existe Forma de pago para su cancelacion.');
          end if;
        
        exception
          when no_data_found then
            raise_application_error(-200100,
                                    'No existe Forma de pago para su cancelacion.');
          
        end;
      
      end if;
    
      if nvl(ii_s_total, 0) <> nvl(v_sum_cuot_impo_mone, 0) then
        raise_application_error(-20010,
                                'Diferencia entre el total del Movimientos y el total de las cuotas, Favor Verificar');
      end if;
    end if;
  
    begin
      i020009.pp_validar_conceptos;
    
   /* exception
      when others then
        raise_application_error(-20010,
                                'Error el momento de validar Conceptos');*/
    end;
  
    --pp_ajustar_importes;  ignoro este porque en conceptos se cargo a detalles los importes y vamos a validar al momento de cargar, nuuuevamente
  
    /*********************** INICIAMOS ACTUALIZACIONN   *******************************/
    if i_movi_codi is null then
      --pp_actualiza_come_movi;   
      begin
        I020009.pp_actualiza_come_movi(i_movi_timo_codi           => ii_movi_timo_codi,
                                       i_movi_clpr_codi           => ii_movi_clpr_codi,
                                       i_movi_mone_codi           => ii_movi_mone_codi,
                                       i_movi_nume                => ii_movi_nume,
                                       i_movi_fech_emis           => ii_movi_fech_emis,
                                       i_movi_fech_oper           => ii_movi_fech_oper,
                                       i_movi_tasa_mone           => ii_movi_tasa_mone,
                                       i_movi_grav_mmnn           => ii_movi_grav_mmnn,
                                       i_movi_exen_mmnn           => ii_movi_exen_mmnn,
                                       i_movi_iva_mmnn            => ii_movi_iva_mmnn,
                                       i_movi_grav_mone           => ii_movi_grav_mone,
                                       i_movi_exen_mone           => ii_movi_exen_mone,
                                       i_movi_iva_mone            => ii_movi_iva_mone,
                                       i_movi_obse                => ii_movi_obse,
                                       i_movi_sald_mmnn           => ii_movi_sald_mmnn,
                                       i_movi_sald_mone           => ii_movi_sald_mone,
                                       i_movi_stoc_suma_rest      => ii_movi_stoc_suma_rest,
                                       i_movi_clpr_dire           => ii_movi_clpr_dire,
                                       i_movi_clpr_tele           => ii_movi_clpr_tele,
                                       i_movi_clpr_ruc            => ii_movi_clpr_ruc,
                                       i_movi_clpr_desc           => ii_movi_clpr_desc,
                                       i_movi_emit_reci           => ii_movi_emit_reci,
                                       i_movi_afec_sald           => ii_movi_afec_sald,
                                       i_movi_dbcr                => ii_movi_dbcr,
                                       i_movi_stoc_afec_cost_prom => ii_movi_stoc_afec_cost_prom,
                                       i_movi_empl_codi           => ii_movi_empl_codi,
                                       i_movi_nume_timb           => ii_movi_nume_timb,
                                       i_fech_venc_timb           => ii_fech_venc_timb,
                                       i_movi_impo_mone_ii        => ii_movi_impo_mone_ii,
                                       i_movi_impo_mmnn_ii        => ii_movi_impo_mmnn_ii,
                                       i_movi_grav10_ii_mone      => ii_movi_grav10_ii_mone,
                                       i_movi_grav5_ii_mone       => ii_movi_grav5_ii_mone,
                                       i_movi_grav10_ii_mmnn      => ii_movi_grav10_ii_mmnn,
                                       i_movi_grav5_ii_mmnn       => ii_movi_grav5_ii_mmnn,
                                       i_movi_grav10_mone         => ii_movi_grav10_mone,
                                       i_movi_grav5_mone          => ii_movi_grav5_mone,
                                       i_movi_grav10_mmnn         => ii_movi_grav10_mmnn,
                                       i_movi_grav5_mmnn          => ii_movi_grav5_mmnn,
                                       i_movi_iva10_mone          => ii_movi_iva10_mone,
                                       i_movi_iva5_mone           => ii_movi_iva5_mone,
                                       i_movi_iva10_mmnn          => ii_movi_iva10_mmnn,
                                       i_movi_iva5_mmnn           => ii_movi_iva5_mmnn,
                                       i_sucu_nume_item           => ii_sucu_nume_item,
                                       i_movi_indi_apli_tick      => ii_movi_indi_apli_tick,
                                       i_movi_ticl_codi           => ii_movi_ticl_codi,
                                       i_movi_re90_codi           => ii_movi_re90_codi,
                                       i_movi_re90_tipo           => ii_movi_re90_tipo,
                                       i_MOVI_INDI_IMPU_IRE       => ii_MOVI_INDI_IMPU_IRE,
                                       i_MOVI_INDI_IMPU_IRP_RSP   => ii_MOVI_INDI_IMPU_IRP_RSP,
                                       i_MOVI_INDI_NO_IMPU        => ii_MOVI_INDI_NO_IMPU,
                                       i_MOVI_INDI_IMPU_IVA       => ii_MOVI_INDI_IMPU_IVA);
      
      exception
        when others then
          raise_application_error(-20010,
                                  'Error al momento de actualizar come_movi: ' ||
                                  sqlerrm);
      end;
    
      --  pp_actualiza_come_movi_cuot;  
      begin
        I020009.pp_actualiza_come_movi_cuot(i_movi_timo_indi_sald => ii_movi_timo_indi_sald,
                                            i_movi_impo_mmnn_ii   => ii_movi_impo_mmnn_ii,
                                            i_movi_tasa_mone      => ii_movi_tasa_mone);
      exception
        when others then
          raise_application_error(-20010,
                                  'Error al momento de actualizar cuota: ' ||
                                  sqlerrm);
      end;
    
      --pp_actualiza_moco;  
      begin
      
        I020009.pp_actualiza_moco(i_movi_timo_codi => ii_movi_timo_codi);
      
      exception
        when others then
          raise_application_error(-20010,
                                  'Error al momento de actualizar cuota: ' ||
                                  sqlerrm);
        
      end;
    
      --  pp_actualiza_moimpu;  
      begin
        I020009.pp_actualiza_moimpu(ii_movi_timo_codi   => ii_movi_timo_codi,
                                    ii_s_impo_rete      => ii_s_impo_rete,
                                    ii_s_impo_rete_rent => ii_s_impo_rete_rent,
                                    i_movi_tasa_mone    => ii_movi_tasa_mone);
      exception 
        when others then 
          raise_application_error(-20010, 'Error al momento de actualizar moimpu: '||sqlerrm);
      
      end;

     --pp_gene_asie
      begin
         i020009.pp_gene_asie(ii_movi_fech_emis);
      end;

     --pp_llama_reporte
      begin
        if p_indi_impr_dbcr = 'S' then
          I020009.pp_reporte(i_movi_codi => p_movi_codi, i_movi_timo_codi => ii_movi_timo_codi);
        end if;
      end;

         if ii_timo_dbcr_caja = 'C' then
            if ii_movi_afec_sald = 'N' then
              begin
                 I020009.pp_reporte_Orden_pago(i_movi_codi => p_movi_codi);
              end;
            end if;
          end if;
          
     
     
    /******************************
            if ii_movi_afec_sald = 'N' then
              pl_fp_actualiza_moimpo;
            end if;
            if nvl(ii_s_impo_rete,0) > 0 or nvl(ii_s_impo_rete_rent,0) > 0 then   
              pp_actualizar_rete;   
            end if; 
            
          --Generar archivo tesaka
          if nvl(ii_s_impo_rete, 0) > 0 then    
            if p_indi_rete_tesaka = 'S' then
              pp_generar_tesaka;
            end if;
          end if;
      
            -- ya no se usa este procedimiento, todo va en pp_actualizar_rete
            --if nvl(i_s_impo_rete_rent,0) > 0 then   
            --  pp_actualizar_rete_rent;
            --end if;
           
           if p_indi_impr_cheq_emit = 'S' then
              pp_impr_cheq_emit;
           end if; 

          pp_veri_timo_tico_codi;
          if i_timo_tico_codi = p_tipo_comp_nota_debi_emit then
           pp_impr_nota_debi;
          end if;   
      
          if nvl(i_s_impo_rete,0) > 0 or nvl(i_s_impo_rete_rent,0) > 0 then
            pp_impr_rete;
          end if;
          
          IF i_MOVI_TIMO_CODI IN (1,2,3,4) THEN
           pp_impr_fact;
              
          END IF; 
           
  *********************************/   
  
   
    end if;
 /*  exception 
     when others then 
       rollback; */ 
  end pp_actualizar_Registro;

  procedure pp_actualiza_come_movi(i_movi_timo_codi           in number,
                                   i_movi_clpr_codi           in number,
                                   i_movi_mone_codi           in number,
                                   i_movi_nume                in number,
                                   i_movi_fech_emis           in date,
                                   i_movi_fech_oper           in date,
                                   i_movi_tasa_mone           in number,
                                   i_movi_grav_mmnn           in number,
                                   i_movi_exen_mmnn           in number,
                                   i_movi_iva_mmnn            in number,
                                   i_movi_grav_mone           in number,
                                   i_movi_exen_mone           in number,
                                   i_movi_iva_mone            in number,
                                   i_movi_obse                in varchar2,
                                   i_movi_sald_mmnn           in number,
                                   i_movi_sald_mone           in number,
                                   i_movi_stoc_suma_rest      in number,
                                   i_movi_clpr_dire           in varchar2,
                                   i_movi_clpr_tele           in varchar2,
                                   i_movi_clpr_ruc            in varchar2,
                                   i_movi_clpr_desc           in varchar2,
                                   i_movi_emit_reci           in varchar2,
                                   i_movi_afec_sald           in varchar2,
                                   i_movi_dbcr                in varchar2,
                                   i_movi_stoc_afec_cost_prom in varchar2,
                                   i_movi_empl_codi           in number,
                                   i_movi_nume_timb           in number,
                                   i_fech_venc_timb           in date,
                                   i_movi_impo_mone_ii        in number,
                                   i_movi_impo_mmnn_ii        in number,
                                   i_movi_grav10_ii_mone      in number,
                                   i_movi_grav5_ii_mone       in number,
                                   i_movi_grav10_ii_mmnn      in number,
                                   i_movi_grav5_ii_mmnn       in number,
                                   i_movi_grav10_mone         in number,
                                   i_movi_grav5_mone          in number,
                                   i_movi_grav10_mmnn         in number,
                                   i_movi_grav5_mmnn          in number,
                                   i_movi_iva10_mone          in number,
                                   i_movi_iva5_mone           in number,
                                   i_movi_iva10_mmnn          in number,
                                   i_movi_iva5_mmnn           in number,
                                   i_sucu_nume_item           in number,
                                   i_movi_indi_apli_tick      in varchar2,
                                   i_movi_ticl_codi           in number,
                                   i_movi_re90_codi           in number,
                                   i_movi_re90_tipo           in number,
                                   i_MOVI_INDI_IMPU_IRE       in varchar2,
                                   i_MOVI_INDI_IMPU_IRP_RSP   in varchar2,
                                   i_MOVI_INDI_NO_IMPU        in varchar2,
                                   i_MOVI_INDI_IMPU_IVA       in varchar2) is
  
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
    v_movi_fech_oper           date;
    v_movi_fech_venc_timb      date;
    v_movi_codi_rete           number;
    v_movi_excl_cont           varchar2(1);
    v_movi_impo_mone_ii        number;
    v_movi_impo_mmnn_ii        number;
    v_movi_grav10_ii_mone      number;
    v_movi_grav5_ii_mone       number;
    v_movi_grav10_ii_mmnn      number;
    v_movi_grav5_ii_mmnn       number;
    v_movi_grav10_mone         number;
    v_movi_grav5_mone          number;
    v_movi_grav10_mmnn         number;
    v_movi_grav5_mmnn          number;
    v_movi_iva10_mone          number;
    v_movi_iva5_mone           number;
    v_movi_iva10_mmnn          number;
    v_movi_iva5_mmnn           number;
    v_movi_clpr_sucu_nume_item number;
    v_movi_indi_apli_tick      varchar2(1);
  
    V_MOVI_TICL_CODI number(10);
    V_MOVI_RE90_CODI number(10);
    V_MOVI_RE90_TIPO number(10);
  
    V_MOVI_INDI_IMPU_IRE     varchar2(1);
    V_MOVI_INDI_IMPU_IRP_RSP varchar2(1);
    V_MOVI_INDI_NO_IMPU      varchar2(1);
    V_MOVI_INDI_IMPU_IVA     varchar2(1);
  
  begin
    
  select clpr_desc into v_movi_clpr_desc from come_clie_prov where clpr_codi = i_movi_clpr_codi;
   
  
    --- asignar valores....
    p_movi_codi := fa_sec_come_movi;
    --i_movi_oper_codi       := null;
    v_movi_codi                := p_movi_codi;
    v_movi_timo_codi           := i_movi_timo_codi;
    v_movi_clpr_codi           := i_movi_clpr_codi;
    v_movi_sucu_codi_orig      := p_sucu_codi;
    v_movi_depo_codi_orig      := null;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := null;
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := i_movi_mone_codi;
    v_movi_nume                := i_movi_nume;
    v_movi_fech_emis           := i_movi_fech_emis;
    v_movi_fech_oper           := i_movi_fech_oper;
    v_movi_fech_grab           := sysdate;
    v_movi_user                := p_usuario;
    v_movi_codi_padr           := null;
    v_movi_tasa_mone           := i_movi_tasa_mone;
    v_movi_tasa_mmee           := null;
    v_movi_grav_mmnn           := i_movi_grav_mmnn;
    v_movi_exen_mmnn           := i_movi_exen_mmnn;
    v_movi_iva_mmnn            := i_movi_iva_mmnn;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := i_movi_grav_mone;
    v_movi_exen_mone           := i_movi_exen_mone;
    v_movi_iva_mone            := i_movi_iva_mone;
    v_movi_obse                := i_movi_obse;
    v_movi_sald_mmnn           := i_movi_sald_mmnn;
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := i_movi_sald_mone;
    v_movi_stoc_suma_rest      := i_movi_stoc_suma_rest;
    v_movi_clpr_dire           := i_movi_clpr_dire;
    v_movi_clpr_tele           := i_movi_clpr_tele;
    v_movi_clpr_ruc            := i_movi_clpr_ruc;
   -- v_movi_clpr_desc           := v_movi_clpr_desc;
    v_movi_emit_reci           := i_movi_emit_reci;
    v_movi_afec_sald           := i_movi_afec_sald;
    v_movi_dbcr                := i_movi_dbcr;
    v_movi_stoc_afec_cost_prom := i_movi_stoc_afec_cost_prom;
    v_movi_empr_codi           := p_empr_codi;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := i_movi_empl_codi;
    v_movi_nume_timb           := i_movi_nume_timb;
    v_movi_fech_venc_timb      := i_fech_venc_timb;
    v_movi_codi_rete           := null; --se actualizara cuando se grabe la retencion
    v_movi_impo_mone_ii        := i_movi_impo_mone_ii;
    v_movi_impo_mmnn_ii        := i_movi_impo_mmnn_ii;
    v_movi_grav10_ii_mone      := i_movi_grav10_ii_mone;
    v_movi_grav5_ii_mone       := i_movi_grav5_ii_mone;
    v_movi_grav10_ii_mmnn      := i_movi_grav10_ii_mmnn;
    v_movi_grav5_ii_mmnn       := i_movi_grav5_ii_mmnn;
    v_movi_grav10_mone         := i_movi_grav10_mone;
    v_movi_grav5_mone          := i_movi_grav5_mone;
    v_movi_grav10_mmnn         := i_movi_grav10_mmnn;
    v_movi_grav5_mmnn          := i_movi_grav5_mmnn;
    v_movi_iva10_mone          := i_movi_iva10_mone;
    v_movi_iva5_mone           := i_movi_iva5_mone;
    v_movi_iva10_mmnn          := i_movi_iva10_mmnn;
    v_movi_iva5_mmnn           := i_movi_iva5_mmnn;
    v_movi_clpr_sucu_nume_item := i_sucu_nume_item;
    v_movi_indi_apli_tick      := i_movi_indi_apli_tick;
  
    if v_movi_clpr_sucu_nume_item = 0 then
      v_movi_clpr_sucu_nume_item := null;
    end if;
  
    V_MOVI_TICL_CODI := i_MOVI_TICL_CODI;
    V_MOVI_RE90_CODI := i_MOVI_RE90_CODI;
    V_MOVI_RE90_TIPO := i_MOVI_RE90_TIPO;
  
    V_MOVI_INDI_IMPU_IRE     := i_MOVI_INDI_IMPU_IRE;
    V_MOVI_INDI_IMPU_IRP_RSP := i_MOVI_INDI_IMPU_IRP_RSP;
    V_MOVI_INDI_NO_IMPU      := i_MOVI_INDI_NO_IMPU;
    V_MOVI_INDI_IMPU_IVA     := i_MOVI_INDI_IMPU_IVA;
  
    i020009.pp_insert_come_movi(v_movi_codi,
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
                                v_movi_fech_oper,
                                v_movi_fech_venc_timb,
                                v_movi_codi_rete,
                                v_movi_excl_cont,
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
                                v_movi_clpr_sucu_nume_item,
                                v_movi_indi_apli_tick,
                                
                                V_MOVI_TICL_CODI,
                                V_MOVI_RE90_CODI,
                                V_MOVI_RE90_TIPO,
                                V_MOVI_INDI_IMPU_IRE,
                                V_MOVI_INDI_IMPU_IRP_RSP,
                                V_MOVI_INDI_NO_IMPU,
                                V_MOVI_INDI_IMPU_IVA
                                
                                );
  end;

  procedure pp_actualiza_come_movi_cuot(i_movi_timo_indi_sald in varchar2,
                                        i_MOVI_IMPO_MMNN_II   in number,
                                        i_movi_tasa_mone      in number) is
  
    v_cuot_fech_venc date;
    v_cuot_nume      number := 0;
    v_cuot_impo_mone number;
    v_cuot_impo_mmnn number;
    v_cuot_impo_mmee number;
    v_cuot_sald_mone number;
    v_cuot_sald_mmnn number;
    v_cuot_sald_mmee number;
    v_cuot_movi_codi number;
    ---control de diferencia con cabecera.
    v_movi_impo_mmnn number := i_MOVI_IMPO_MMNN_II;
    v_impo_cuot_mmnn number := 0;
    v_cuot_mmnn      number := 0;
    v_dife           number := 0;
    ---
  
    cursor c_cuot is
      select taax_c001 Pago_A,
             taax_c002 cuot_fech_venc,
             to_number(taax_c003) cuot_impo_mone
        from come_tabl_auxi
       where taax_sess = p_session
         and taax_user = p_usuario
         and taax_c050 = 'CUOTA';
  
    v_sum_cuot_impo_mmnn number := 0;
  
  begin
    if i_movi_timo_indi_sald = 'S' then
      ---si afecta al saldo del cliente o proveedor 
      --v_cuot_mmnn := round(v_movi_impo_mmnn / :bsel_cuota.s_cant_cuotas,
      --                     p_cant_deci_mmnn);
    
      for i in c_cuot loop
        v_cuot_impo_mmnn     := round((i.cuot_impo_mone * i_movi_tasa_mone),
                                      p_cant_deci_mmnn);
        v_sum_cuot_impo_mmnn := v_sum_cuot_impo_mmnn + v_cuot_impo_mmnn;
      end loop;
    
      if i_movi_impo_mmnn_ii <> v_sum_cuot_impo_mmnn then
        v_cuot_impo_mmnn := v_cuot_impo_mmnn +
                            (i_movi_impo_mmnn_ii - v_cuot_impo_mmnn);
      end if;
    
      for i in c_cuot loop
      
        v_cuot_fech_venc := i.cuot_fech_venc;
        v_cuot_nume      := v_cuot_nume + 1;
        v_cuot_impo_mone := i.cuot_impo_mone;
        v_cuot_impo_mmnn := round((i.cuot_impo_mone * i_movi_tasa_mone),
                                  p_cant_deci_mmnn);
        v_cuot_impo_mmee := null;
        v_cuot_sald_mone := i.cuot_impo_mone;
        v_cuot_sald_mmnn := round((i.cuot_impo_mone * i_movi_tasa_mone),
                                  p_cant_deci_mmnn);
        v_cuot_sald_mmee := null;
        v_cuot_movi_codi := p_movi_codi;
      
        i020009.pp_insert_come_movi_cuot(v_cuot_fech_venc,
                                         v_cuot_nume,
                                         v_cuot_impo_mone,
                                         v_cuot_impo_mmnn,
                                         v_cuot_impo_mmee,
                                         v_cuot_sald_mone,
                                         v_cuot_sald_mmnn,
                                         v_cuot_sald_mmee,
                                         v_cuot_movi_codi);
      
      end loop;
    end if;
  end;

  procedure pp_actualiza_moco(i_MOVI_TIMO_CODI in number) is
    v_moco_movi_codi      number(20);
    v_moco_nume_item      number(10);
    v_moco_conc_codi      number(10);
    v_moco_cuco_codi      number(10);
    v_moco_impu_codi      number(10);
    v_moco_impo_mmnn      number(20, 4);
    v_moco_impo_mmee      number(20, 4);
    v_moco_impo_mone      number(20, 4);
    v_moco_dbcr           varchar2(1);
    v_moco_base           number(2);
    v_moco_desc           varchar2(2000);
    v_moco_tiim_codi      number(10);
    v_moco_indi_fact_serv varchar2(1);
    v_moco_impo_mone_ii   number(20, 4);
    v_moco_ortr_codi      number(20);
    v_moco_impo_codi      number(20);
    v_moco_cant           number(20, 4);
    v_moco_cant_pulg      number(20, 4);
    v_moco_movi_codi_padr number(20);
    v_moco_nume_item_padr number(10);
    v_moco_ceco_codi      number(20);
    v_moco_orse_codi      number(20);
    v_moco_osli_codi      number(20);
    v_moco_tran_codi      number(20);
    v_moco_bien_codi      number(20);
    v_moco_emse_codi      number(4);
    v_moco_impo_mmnn_ii   number(20, 4);
    v_moco_sofa_sose_codi number(20);
    v_moco_sofa_nume_item number(20);
    v_moco_tipo_item      varchar2(2);
    v_moco_clpr_codi      number(20);
    v_moco_prod_nume_item number(20);
    v_moco_guia_nume      number(20);
    v_moco_grav10_ii_mone number(20, 4);
    v_moco_grav5_ii_mone  number(20, 4);
    v_moco_grav10_ii_mmnn number(20, 4);
    v_moco_grav5_ii_mmnn  number(20, 4);
    v_moco_grav10_mone    number(20, 4);
    v_moco_grav5_mone     number(20, 4);
    v_moco_grav10_mmnn    number(20, 4);
    v_moco_grav5_mmnn     number(20, 4);
    v_moco_iva10_mone     number(20, 4);
    v_moco_iva5_mone      number(20, 4);
    v_moco_conc_codi_impu number(10);
    v_moco_tipo           varchar2(2);
    v_moco_prod_codi      number(20);
    v_moco_ortr_codi_fact number(20);
    v_moco_iva10_mmnn     number(20, 4);
    v_moco_iva5_mmnn      number(20, 4);
    v_moco_exen_mone      number(20, 4);
    v_moco_exen_mmnn      number(20, 4);
    v_moco_empl_codi      number(10);
    v_moco_lote_codi      number(10);
    v_moco_bene_codi      number(4);
    v_moco_medi_codi      number(10);
    v_moco_cant_medi      number(20, 4);
    v_moco_anex_codi      number(20);
    v_moco_indi_excl_cont varchar2(1);
    v_moco_anex_nume_item number(10);
    v_moco_juri_codi      number(20);
    v_MOCO_INDI_ORSE_ADM  varchar2(1);
    v_moco_sucu_codi      number(20);
    v_moco_fech_emis      date;
    v_moco_porc_dist      number(20, 4);
  
    v_conc_iva       number;
    v_moco_gatr_codi number(20);
  
    cursor c_conc_deta is
      select taax_c001 moco_conc_codi,
             taax_c002 moco_conc_desc,
             taax_c003 moco_dbcr,
             taax_c004 conc_indi_kilo_vehi,
             taax_c005 moco_indi_impo,
             taax_c006 conc_indi_ortr,
             taax_c007 conc_indi_gt_judi,
             taax_c008 conc_indi_cent_cost,
             taax_c009 conc_indi_acti_fijo,
             taax_c010 cuco_nume,
             taax_c011 cuco_desc,
             taax_c012 impo_mone_ii,
             taax_c013 movi_ta_mone,
             taax_c014 movi_mone_cant_deci,
             taax_c015 moco_impu_porc,
             taax_c016 moco_impu_porc_be_impo,
             taax_c017 moco_impu_indi_baim_impu,
             taax_c020 moco_impo_mmnn_ii,
             taax_c021 moco_impo_mone_ii,
             taax_c022 moco_grav10_ii_mone,
             taax_c023 moco_grav5_ii_mone,
             taax_c024 moco_grav10_mone,
             taax_c025 moco_grav5_mone,
             taax_c026 moco_iva10_mone,
             taax_c027 moco_iva5_mone,
             taax_c028 moco_Exen_mone,
             taax_c029 moco_grav10_ii_mmnn,
             taax_c030 moco_grav5_ii_mmnn,
             taax_c031 moco_grav10_mmnn,
             taax_c032 moco_grav5_mmnn,
             taax_c033 moco_iva10_mmnn,
             taax_c034 moco_iva5_mmnn,
             taax_c035 moco_exen_mmnn,
             taax_c036 moco_impo_mmnn,
             taax_c037 moco_impo_mone,
             taax_c038 v_item_nro,
             taax_c039 impu_desc,
             taax_c040 moco_impu_codi,
             taax_c041 moco_tiim_codi,
             taax_c042 tiim_desc,
             taax_c050 tipo_cuota
        from come_tabl_auxi
       where taax_sess = p_session
         and taax_user = p_usuario
         and taax_c050 = 'DETALLES';
  
    p_moco_ortr_codi      number;
    p_moco_impo_codi      number;
    p_moco_ceco_codi      number;
    p_moco_orse_codi      number;
    p_moco_osli_codi      number;
    p_moco_tran_codi      number;
    p_moco_emse_codi      number;
    p_moco_conc_codi_impu number;
    p_moco_juri_codi      number;
    p_moco_fech_emis      date;
    p_moco_porc_dist      number;
  
  begin
  
    v_moco_movi_codi := p_movi_codi;
    v_moco_nume_item := 0;
  
    for i in c_conc_deta loop
    
      begin
        select /*moco_conc_codi,
                      moco_impu_codi,
                      moco_tiim_codi,
                      moco_nume_item,
                      moco_impo_mone_ii,
                      moco_desc,
                      moco_impo_codi,
                      moco_juri_codi,
                      moco_orse_codi,
                      moco_osli_codi,
                      osli_nume_liqu,
                      moco_ortr_codi,
                      moco_ceco_codi,
                      moco_tran_codi,
                      moco_emse_codi,
                      moco_sucu_codi,              
                      impo_nume,
                      ortr_nume,
                      orse_nume_char,
                      tran_codi_alte,
                      ceco_nume,
                      emse_codi_alte,
                      juri_nume  */
         moco_ortr_codi,
         moco_impo_codi,
         moco_ceco_codi,
         moco_orse_codi,
         moco_osli_codi,
         moco_tran_codi,
         moco_emse_codi,
         moco_conc_codi_impu,
         moco_juri_codi,
         moco_fech_emis,
         moco_porc_dist
          into p_moco_ortr_codi,
               p_moco_impo_codi,
               p_moco_ceco_codi,
               p_moco_orse_codi,
               p_moco_osli_codi,
               p_moco_tran_codi,
               p_moco_emse_codi,
               p_moco_conc_codi_impu,
               p_moco_juri_codi,
               p_moco_fech_emis,
               p_moco_porc_dist
          from come_movi_conc_deta,
               come_orde_trab,
               come_impo,
               come_empr_secc,
               come_cent_cost,
               come_tran,
               come_clie_juri,
               (select osli_codi, osli_nume_liqu, orse_nume_char
                  from come_orde_serv, come_orde_serv_liqu_deta
                 where orse_codi = osli_orse_codi) osli
         where moco_ortr_codi = ortr_codi(+)
           and moco_impo_codi = impo_codi(+)
           and moco_emse_codi = emse_codi(+)
           and moco_Ceco_codi = ceco_codi(+)
           and moco_tran_codi = tran_codi(+)
           and moco_juri_codi = juri_codi(+)
           and moco_osli_codi = osli.osli_codi(+)
           and moco_movi_codi = p_movi_codi
           and moco_conc_codi not in
               (select impu_conc_codi_ivcr
                  from come_impu
                 where impu_conc_codi_ivcr is not null
                union
                select impu_conc_codi_ivdb
                  from come_impu
                 where impu_conc_codi_ivdb is not null);
      
      exception
        when no_data_found then
          null;
      end;
    
      v_moco_nume_item := v_moco_nume_item + 1;
      v_moco_conc_codi := i.moco_conc_codi;
      v_moco_cuco_codi := null;
      v_moco_impu_codi := i.moco_impu_codi;
      v_moco_impo_mmnn := i.moco_impo_mmnn;
      v_moco_impo_mmee := 0;
      v_moco_impo_mone := i.moco_impo_mone;
      v_moco_dbcr      := i.moco_dbcr;
      v_moco_base      := p_codi_base;
    
      v_moco_desc := i.moco_conc_desc;
    
      v_moco_tiim_codi := i.moco_tiim_codi;
    
      if i_MOVI_TIMO_CODI in (1, 2, 3, 4) then
        v_moco_indi_fact_serv := 'S';
        if v_moco_desc is null then
          v_moco_desc := i.moco_conc_desc;
        end if;
      
      else
        v_moco_indi_fact_serv := null;
      end if;
    
      v_moco_impo_mone_ii   := i.moco_impo_mone_ii;
      v_moco_ortr_codi      := p_moco_ortr_codi;
      v_moco_impo_codi      := p_moco_impo_codi;
      v_moco_cant           := 1;
      v_moco_cant_pulg      := null;
      v_moco_movi_codi_padr := null;
      v_moco_nume_item_padr := null;
      v_moco_ceco_codi      := p_moco_ceco_codi;
      v_moco_orse_codi      := p_moco_orse_codi;
      v_moco_osli_codi      := p_moco_osli_codi;
      v_moco_tran_codi      := p_moco_tran_codi;
      v_moco_bien_codi      := null;
      v_moco_emse_codi      := p_moco_emse_codi;
      v_moco_impo_mmnn_ii   := i.moco_impo_mmnn_ii;
      v_moco_sofa_sose_codi := null;
      v_moco_sofa_nume_item := null;
      v_moco_tipo_item      := 'C'; ---igual que moco_tipo
      v_moco_clpr_codi      := null;
      v_moco_prod_nume_item := null;
      v_moco_guia_nume      := null;
      v_moco_grav10_ii_mone := i.moco_grav10_ii_mone;
      v_moco_grav5_ii_mone  := i.moco_grav5_ii_mone;
      v_moco_grav10_ii_mmnn := i.moco_grav10_ii_mmnn;
      v_moco_grav5_ii_mmnn  := i.moco_grav5_ii_mmnn;
      v_moco_grav10_mone    := i.moco_grav10_mone;
      v_moco_grav5_mone     := i.moco_grav5_mone;
      v_moco_grav10_mmnn    := i.moco_grav10_mmnn;
      v_moco_grav5_mmnn     := i.moco_grav5_mmnn;
      v_moco_iva10_mone     := i.moco_iva10_mone;
      v_moco_iva5_mone      := i.moco_iva5_mone;
      v_moco_conc_codi_impu := p_moco_conc_codi_impu;
      v_moco_tipo           := 'C'; --c= concepto P= producto O= Orden de trabajo
      v_moco_prod_codi      := null;
      v_moco_ortr_codi_fact := null;
      v_moco_iva10_mmnn     := i.moco_iva10_mmnn;
      v_moco_iva5_mmnn      := i.moco_iva5_mmnn;
      v_moco_exen_mone      := i.moco_exen_mone;
      v_moco_exen_mmnn      := i.moco_exen_mmnn;
      v_moco_empl_codi      := null;
      v_moco_lote_codi      := null;
      v_moco_bene_codi      := null;
      v_moco_medi_codi      := null;
      v_moco_cant_medi      := null;
      v_moco_anex_codi      := null;
      v_moco_indi_excl_cont := null;
      v_moco_anex_nume_item := null;
      v_moco_juri_codi      := p_moco_juri_codi;
      --  v_MOCO_INDI_ORSE_ADM    := i.ORSE_INDI_GAST_ADMI;
      v_moco_sucu_codi := p_sucu_codi;
      v_moco_fech_emis := p_moco_fech_emis;
      v_moco_porc_dist := p_moco_porc_dist;
    
      if nvl(i.conc_indi_kilo_vehi, 'N') in ('S', 'M') then
        null; --v_moco_gatr_codi := fa_sec_come_movi_gast_tran;
      end if;
    
      i020009.pp_insert_movi_conc_deta(v_moco_movi_codi,
                                       v_moco_nume_item,
                                       v_moco_conc_codi,
                                       v_moco_cuco_codi,
                                       v_moco_impu_codi,
                                       v_moco_impo_mmnn,
                                       v_moco_impo_mmee,
                                       v_moco_impo_mone,
                                       v_moco_dbcr,
                                       v_moco_base,
                                       v_moco_desc,
                                       v_moco_tiim_codi,
                                       v_moco_indi_fact_serv,
                                       v_moco_impo_mone_ii,
                                       v_moco_ortr_codi,
                                       v_moco_impo_codi,
                                       v_moco_cant,
                                       v_moco_cant_pulg,
                                       v_moco_movi_codi_padr,
                                       v_moco_nume_item_padr,
                                       v_moco_ceco_codi,
                                       v_moco_orse_codi,
                                       v_moco_osli_codi,
                                       v_moco_tran_codi,
                                       v_moco_bien_codi,
                                       v_moco_emse_codi,
                                       v_moco_impo_mmnn_ii,
                                       v_moco_sofa_sose_codi,
                                       v_moco_sofa_nume_item,
                                       v_moco_tipo_item,
                                       v_moco_clpr_codi,
                                       v_moco_prod_nume_item,
                                       v_moco_guia_nume,
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
                                       v_moco_conc_codi_impu,
                                       v_moco_tipo,
                                       v_moco_prod_codi,
                                       v_moco_ortr_codi_fact,
                                       v_moco_iva10_mmnn,
                                       v_moco_iva5_mmnn,
                                       v_moco_exen_mone,
                                       v_moco_exen_mmnn,
                                       v_moco_empl_codi,
                                       v_moco_lote_codi,
                                       v_moco_bene_codi,
                                       v_moco_medi_codi,
                                       v_moco_cant_medi,
                                       v_moco_anex_codi,
                                       v_moco_indi_excl_cont,
                                       v_moco_anex_nume_item,
                                       v_moco_juri_codi,
                                       v_MOCO_INDI_ORSE_ADM,
                                       v_moco_sucu_codi,
                                       v_moco_fech_emis,
                                       v_moco_porc_dist,
                                       v_moco_gatr_codi);
    
    /*if nvl(i.conc_indi_kilo_vehi, 'N') in ('S', 'M') then
              pp_actualiza_gast_vehi(v_moco_gatr_codi);
            end if;*/
    
    end loop;
  end;
  /*
  procedure pp_actualiza_gast_vehi(p_gatr_codi number) is
  v_gatr_movi_codi number;
  v_gatr_tran_codi number;
  v_gatr_litr_carg number;
  
  
  v_gatr_kilo_actu number;
  
  v_gatr_kilo_ante number;
  v_gatr_kilo_inme_ante number;
  v_gatr_kilo_cont number;
  v_dife_kilo number;
  v_moco_porc_dist number;
  
  v_kilo_calc number;
  
  begin
    if nvl(i_conc_indi_kilo_vehi, 'N') in ('S' , 'M')  then 
      if i_moco_tran_codi is not null then
        v_gatr_movi_codi := p_movi_codi;
        v_gatr_tran_codi := i_moco_tran_codi;
        v_gatr_litr_carg := i_gatr_litr_carg;
        v_gatr_kilo_actu := i_gatr_kilo_actu;
        
        select nvl(max(gatr_kilo_actu),0)
          into v_gatr_kilo_ante
        from  come_movi_gast_tran
        where gatr_kilo_actu < :bdet.gatr_kilo_actu
        and gatr_tran_codi = :bdet.moco_tran_codi
        and gatr_movi_codi <> v_gatr_movi_codi;
        
        select nvl(max(gatr_kilo_actu),0)
          into v_gatr_kilo_cont
        from  come_movi_gast_tran
        where gatr_kilo_actu > :bdet.gatr_kilo_actu
        and gatr_tran_codi = :bdet.moco_tran_codi;
        
        --if v_gatr_kilo_cont > 0 then
        --  raise_application_error(-20010,'Existen cargas con kilometraje posterior al actual');
        --end if  ;
        
        begin
          select moco_porc_dist
            into v_moco_porc_dist
          from  come_movi_conc_deta
          where moco_gatr_codi = p_gatr_codi;
        exception
          when no_data_found then
            v_moco_porc_dist := 100;
        end;  
        
        if v_moco_porc_dist > 0 and v_moco_porc_dist < 100 then
        
        
            v_dife_kilo := nvl(v_gatr_kilo_actu,0) - v_gatr_kilo_ante;
            
            v_kilo_calc := v_dife_kilo * v_moco_porc_dist / 100;
            
            select nvl(max(gatr_kilo_actu),0)
              into v_gatr_kilo_inme_ante
            from  come_movi_gast_tran
            where gatr_kilo_actu < :bdet.gatr_kilo_actu
            and gatr_tran_codi = :bdet.moco_tran_codi
            and gatr_movi_codi = v_gatr_movi_codi;
            
            if v_gatr_kilo_inme_ante = 0 then
            
              v_gatr_kilo_actu := v_gatr_kilo_ante + v_kilo_calc;
            else
              v_gatr_kilo_actu := v_gatr_kilo_inme_ante + v_kilo_calc;
            end if;
            
            v_gatr_litr_carg := v_gatr_litr_carg * v_moco_porc_dist / 100;
        
        
        end if;
        
        pp_insert_come_movi_gast_tran (
        v_gatr_movi_codi ,
        v_gatr_tran_codi ,
        v_gatr_litr_carg ,
        v_gatr_kilo_actu,
        p_gatr_codi
         );
      end if;
    end if; 
    
  end ;
  */

  procedure pp_actualiza_moimpu(ii_movi_timo_codi   in number,
                                ii_s_impo_rete      in number,
                                ii_s_impo_rete_rent in number,
                                i_movi_tasa_mone    in number) is
  
    cursor c_movi_conc(p_movi_codi in number) is
      select a.moco_movi_codi,
             a.moco_impu_codi,
             a.moco_tiim_codi,
             sum(a.moco_impo_mmnn) moco_impo_mmnn,
             sum(a.moco_impo_mmee) moco_impo_mmee,
             sum(a.moco_impo_mone) moco_impo_mone,
             sum(a.moco_impo_mone_ii) moco_impo_mone_ii,
             sum(a.moco_impo_mmnn_ii) moco_impo_mmnn_ii,
             sum(a.moco_grav10_ii_mone) moco_grav10_ii_mone,
             sum(a.moco_grav10_ii_mmnn) moco_grav10_ii_mmnn,
             sum(a.moco_grav5_ii_mone) moco_grav5_ii_mone,
             sum(a.moco_grav5_ii_mmnn) moco_grav5_ii_mmnn,
             sum(a.moco_grav10_mone) moco_grav10_mone,
             sum(a.moco_grav10_mmnn) moco_grav10_mmnn,
             sum(a.moco_grav5_mone) moco_grav5_mone,
             sum(a.moco_grav5_mmnn) moco_grav5_mmnn,
             sum(a.moco_iva10_mone) moco_iva10_mone,
             sum(a.moco_iva10_mmnn) moco_iva10_mmnn,
             sum(a.moco_iva5_mone) moco_iva5_mone,
             sum(a.moco_iva5_mmnn) moco_iva5_mmnn,
             sum(a.moco_exen_mone) moco_exen_mone,
             sum(a.moco_exen_mmnn) moco_Exen_mmnn
      
        from come_movi_conc_deta a
       where a.moco_movi_codi = p_movi_codi
       group by a.moco_movi_codi, a.moco_impu_codi, a.moco_tiim_codi
       order by a.moco_movi_codi, a.moco_impu_codi, a.moco_tiim_codi;
  
    v_moim_impu_codi      number(10);
    v_moim_movi_codi      number(20);
    v_moim_impo_mmnn      number(20, 4);
    v_moim_impo_mmee      number(20, 4);
    v_moim_impu_mmnn      number(20, 4);
    v_moim_impu_mmee      number(20, 4);
    v_moim_impo_mone      number(20, 4);
    v_moim_impu_mone      number(20, 4);
    v_moim_base           number(2);
    v_moim_tiim_codi      number(10);
    v_moim_impo_mone_ii   number(20, 4);
    v_moim_impo_mmnn_ii   number(20, 4);
    v_moim_grav10_ii_mone number(20, 4);
    v_moim_grav5_ii_mone  number(20, 4);
    v_moim_grav10_ii_mmnn number(20, 4);
    v_moim_grav5_ii_mmnn  number(20, 4);
    v_moim_grav10_mone    number(20, 4);
    v_moim_grav5_mone     number(20, 4);
    v_moim_grav10_mmnn    number(20, 4);
    v_moim_grav5_mmnn     number(20, 4);
    v_moim_iva10_mone     number(20, 4);
    v_moim_iva5_mone      number(20, 4);
    v_moim_iva10_mmnn     number(20, 4);
    v_moim_iva5_mmnn      number(20, 4);
    v_moim_exen_mone      number(20, 4);
    v_moim_exen_mmnn      number(20, 4);
  
  begin
  
    if ii_movi_timo_codi in
       (p_codi_timo_auto_fact_emit, p_codi_timo_auto_fact_emit_cr) and
       (nvl(ii_s_impo_rete, 0) + nvl(ii_s_impo_rete_rent, 0)) > 0 and
       nvl(P_INDI_AUTO_FACT_IMPU_CALC, 'N') = 'S' then
    
      ----solo la retencion iva, se registra como iva 10%, calculando en forma invertida es decir a partir del iva 
      v_moim_impu_codi := 2;
      v_moim_movi_codi := p_movi_codi;
    
      v_moim_impo_mmee    := null;
      v_moim_impu_mmnn    := round((nvl(ii_s_impo_rete, 0) *
                                   i_movi_tasa_mone),
                                   p_cant_deci_mmnn);
      v_moim_impu_mmee    := null;
      v_moim_impu_mone    := nvl(ii_s_impo_rete, 0);
      v_moim_base         := p_Codi_base;
      v_moim_tiim_codi    := 1;
      v_moim_impo_mone_ii := nvl(ii_s_impo_rete_rent, 0);
      v_moim_impo_mmnn_ii := nvl(ii_s_impo_rete_rent, 0);
    
      v_moim_impo_mmnn := v_moim_impu_mmnn * 10;
      v_moim_impo_mone := v_moim_impu_mone * 10;
    
      v_moim_grav10_ii_mone := v_moim_impu_mone + v_moim_impo_mone;
      v_moim_grav10_ii_mmnn := v_moim_impu_mmnn + v_moim_impo_mmnn;
    
      v_moim_grav5_ii_mone := 0;
      v_moim_grav5_ii_mmnn := 0;
    
      v_moim_grav10_mone := v_moim_impo_mone;
      v_moim_grav10_mmnn := v_moim_impo_mmnn;
    
      v_moim_grav5_mone := 0;
      v_moim_grav5_mmnn := 0;
    
      v_moim_iva10_mone := v_moim_impu_mone;
      v_moim_iva10_mmnn := v_moim_impu_mmnn;
    
      v_moim_iva5_mone := 0;
      v_moim_iva5_mmnn := 0;
    
      v_moim_exen_mone := 0;
      v_moim_exen_mmnn := 0;
    
      i020009.pp_insert_come_movi_impu_deta(v_moim_impu_codi,
                                            v_moim_movi_codi,
                                            v_moim_impo_mmnn,
                                            v_moim_impo_mmee,
                                            v_moim_impu_mmnn,
                                            v_moim_impu_mmee,
                                            v_moim_impo_mone,
                                            v_moim_impu_mone,
                                            v_moim_base,
                                            v_moim_tiim_codi,
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
    
    else
      for x in c_movi_conc(p_movi_codi) loop
        v_moim_impu_codi    := x.moco_impu_codi;
        v_moim_movi_codi    := x.moco_movi_codi;
        v_moim_impo_mmnn    := x.moco_impo_mmnn;
        v_moim_impo_mmee    := null;
        v_moim_impu_mmnn    := x.moco_iva10_mmnn + x.moco_iva5_mmnn;
        v_moim_impu_mmee    := null;
        v_moim_impo_mone    := x.moco_impo_mone;
        v_moim_impu_mone    := x.moco_iva10_mone + x.moco_iva5_mone;
        v_moim_base         := p_Codi_base;
        v_moim_tiim_codi    := x.moco_tiim_codi;
        v_moim_impo_mone_ii := x.moco_impo_mone_ii;
        v_moim_impo_mmnn_ii := x.moco_impo_mmnn_ii;
      
        v_moim_grav10_ii_mone := x.moco_grav10_ii_mone;
        v_moim_grav10_ii_mmnn := x.moco_grav10_ii_mmnn;
      
        v_moim_grav5_ii_mone := x.moco_grav5_ii_mone;
        v_moim_grav5_ii_mmnn := x.moco_grav5_ii_mmnn;
      
        v_moim_grav10_mone := x.moco_grav10_mone;
        v_moim_grav10_mmnn := x.moco_grav10_mmnn;
      
        v_moim_grav5_mone := x.moco_grav5_mone;
        v_moim_grav5_mmnn := x.moco_grav5_mmnn;
      
        v_moim_iva10_mone := x.moco_iva10_mone;
        v_moim_iva10_mmnn := x.moco_iva10_mmnn;
      
        v_moim_iva5_mone := x.moco_iva5_mone;
        v_moim_iva5_mmnn := x.moco_iva5_mmnn;
      
        v_moim_exen_mone := x.moco_exen_mone;
        v_moim_exen_mmnn := x.moco_exen_mmnn;
      
        pp_insert_come_movi_impu_deta(v_moim_impu_codi,
                                      v_moim_movi_codi,
                                      v_moim_impo_mmnn,
                                      v_moim_impo_mmee,
                                      v_moim_impu_mmnn,
                                      v_moim_impu_mmee,
                                      v_moim_impo_mone,
                                      v_moim_impu_mone,
                                      v_moim_base,
                                      v_moim_tiim_codi,
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
      end loop;
    end if;
  end;


procedure pp_gene_asie(ii_movi_fech_emis  in date) is
v_mensaje varchar2(2000);
Begin  
  
  if nvl(p_indi_asie_on_line, 'N') = 'S' then
   pack_conta.pa_Gene_asie_comp(p_movi_codi, ii_movi_fech_emis, ii_movi_fech_emis, p_codi_base, v_mensaje);
   pack_conta.pa_gene_asie_vent(p_movi_codi, ii_movi_fech_emis, ii_movi_fech_emis, p_codi_base, v_mensaje);
   pack_conta.pa_gene_asie_dev_vent(p_movi_codi, ii_movi_fech_emis, ii_movi_fech_emis, p_codi_base, v_mensaje);
   pack_conta.pa_gene_asie_nota_debi_emit(p_movi_codi, ii_movi_fech_emis, ii_movi_fech_emis, p_codi_base, v_mensaje);
   pack_conta.pa_gene_Asie_nota_debi_reci(p_movi_codi, ii_movi_fech_emis, ii_movi_fech_emis, p_codi_base, v_mensaje);   
  end if;
  
  
end;




  /**********************************************************************/
  /******************CARGA DE DATOS Y VALIDACIONES***********************/
  /**********************************************************************/

  procedure pp_muestra_re90_tipo_desc(p_codi in number,
                                      p_desc out varchar2) is
  begin
  
    select re90_desc
      into p_desc
      from come_re90_tipo
     where re90_tipo = p_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Tipo de Res90 inexistente');
    
  end;

  procedure pp_muestra_re90_codi_desc(p_codi in number,
                                      p_desc out varchar2) is
  begin
  
    select re90_comp_desc
      into p_desc
      from come_re90_comp
     where re90_codi = p_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Tipo de Comprobante Res90 inexistente');
    
  end;

  --El objetivo de este procedimiento es validar que el usuario posea el........ 
  --permiso correspondiente para insertar o anular un tipo de movimiento dado...
  --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
  --de seguridad, que está por debajo del nivl de pantallas.....................

  procedure pl_vali_user_tipo_movi(p_timo_codi  in number,
                                   p_indi_si_no out char) is
    v_timo_codi number;
  begin
  
    select usmo_timo_codi
      into v_timo_codi
      from segu_user, segu_user_tipo_movi
     where user_codi = usmo_user_codi
       and upper(rtrim(ltrim(user_login))) = upper(p_usuario) --ot 
       and usmo_timo_Codi = p_timo_codi;
  
    p_indi_si_no := 'S';
  
  exception
    when no_data_found then
      p_indi_si_no := 'N'; --no tiene habilitado
    when others then
      raise_application_error(-20010,
                              'Error el momento de validar usuario con TM.');
    
  end;

  procedure pp_vali_fech(i_fecha in date) is
  begin
  
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
  
    if i_fecha not between p_fech_inic and p_fech_fini then
      raise_application_error(-20010,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                              to_char(p_fech_fini, 'dd-mm-yyyy'));
    end if;
  
  end pp_vali_fech;

  procedure pp_valida_clie_prov_datos(i_clpr_codi      in number,
                                      i_movi_fech_emis in date,
                                      i_movi_emit_reci in varchar2,
                                      i_timo_indi_clpr in varchar2) is
    v_fech date;
    v_indi varchar2(1);
    v_dife number;
  
    i_clpr_zona_codi number;
    i_clpr_capr_codi number;
    i_clpr_fech_regi date;
    i_clpr_fech_modi date;
  
  begin
    if p_indi_vali_clie_prov_dato = 'S' then
      if i_timo_indi_clpr is null then
        if nvl(i_movi_emit_reci, 'E') = 'E' then
          v_indi := 'C';
        else
          v_indi := 'P';
        end if;
      
      elsif i_timo_indi_clpr = 'C' then
        v_indi := 'C';
      elsif i_timo_indi_clpr = 'P' then
        v_indi := 'P';
      end if;
    
    else
      v_indi := 'N';
    end if;
  
    if v_indi = 'N' then
      null; --no debe hacer nada
    else
    
      select --clpr_prov_retener,
      -- clpr_pais_codi,
       clpr_zona_codi, clpr_capr_codi, clpr_fech_regi, clpr_fech_modi
        into --i_clpr_prov_retener,
             --i_clpr_pais_codi,
              i_clpr_zona_codi,
             i_clpr_capr_codi,
             i_clpr_fech_regi,
             i_clpr_fech_modi
        from come_clie_prov
       where clpr_codi = i_clpr_codi;
    
      if i_clpr_fech_modi is null then
        v_fech := nvl(i_clpr_fech_regi, trunc(sysdate));
      else
        v_fech := nvl(i_clpr_fech_modi, trunc(sysdate));
      end if;
    
      v_dife := i_movi_fech_emis - v_fech;
    
      if v_indi = 'C' then
        if i_clpr_zona_codi is null then
          raise_application_error(-20010,
                                  '1. Datos de clientes desactualizados, favor verifique para continuar!');
        end if;
      
        if v_dife > 365 then
          raise_application_error(-20010,
                                  '2. Datos de clientes desactualizados, favor verifique para continuar!');
        end if;
      
      elsif v_indi = 'P' then
        if i_clpr_capr_codi is null then
          raise_application_error(-20010,
                                  '1. Datos de proveedores desactualizados, favor verifique para continuar!');
        end if;
      
        if v_dife > 365 then
          raise_application_error(-20010,
                                  '2. Datos de proveedores desactualizados, favor verifique para continuar!');
        end if;
      
      end if;
    
    end if;
  
  end;

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
      raise_application_error(-20010, 'SubCuenta inexistente');
    when others then
      raise_application_error(-20010,
                              'Error el momento de validar sub cuenta');
  end;

  procedure pp_validar_nro(i_tico_fech_rein      in date,
                           i_movi_fech_emis      in date,
                           i_tico_codi           in number,
                           i_clpr_indi_clie_prov in varchar2,
                           i_movi_clpr_codi      in number,
                           i_movi_nume           in number) is
    v_count   number;
    v_message varchar2(1000) := 'Nro de Comprobante Existente!!!!! , favor verifique!!';
    salir     exception;
  
  begin
  
    if i_movi_fech_emis < i_tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = i_movi_nume
         and ((i_clpr_indi_clie_prov = 'P' and
             movi_clpr_codi = i_movi_clpr_codi) or
             nvl(i_clpr_indi_clie_prov, 'N') = 'C')
         and timo_tico_codi = i_tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis < i_tico_fech_rein;
    
    elsif i_movi_fech_emis > i_tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = i_movi_nume
         and ((i_clpr_indi_clie_prov = 'P' and
             movi_clpr_codi = i_movi_clpr_codi) or
             nvl(i_clpr_indi_clie_prov, 'N') = 'C')
         and timo_tico_codi = i_tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis >= i_tico_fech_rein;
    
    end if;
  
    if v_count > 0 then
      raise_application_error(-20010, v_message);
    end if;
  
  exception
    when salir then
      raise_application_error(-20010, 'Reingrese el nro de comprobante');
  end;

  procedure pp_validar_timbrado(p_tico_codi           in number,
                                p_esta                in number,
                                p_punt_expe           in number,
                                p_clpr_codi           in number,
                                p_fech_movi           in date,
                                p_timb                out varchar2,
                                p_fech_venc           out date,
                                p_tico_indi_timb      in varchar2,
                                i_clpr_indi_clie_prov in varchar2,
                                i_s_clpr_codi_alte    in number,
                                i_tico_indi_timb_auto in varchar2,
                                i_tico_indi_vali_timb in varchar2,
                                i_movi_nume_timb      in varchar2,
                                i_fech_venc_timb      in date) is
  
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
               where peco_codi = p_peco_codi)
         and setc_tico_codi = p_tico_codi --tipo de comprobante
         and setc_esta = p_esta --establecimiento 
         and setc_punt_expe = p_punt_expe --punto de expedicion
         and setc_fech_venc >= p_fech_movi
       order by setc_fech_venc;
  
    v_indi_entro varchar2(1) := upper('n');
  
    v_indi_espo varchar2(1) := upper('n');
  begin
  
    if i_clpr_indi_clie_prov = upper('p') then
      if i_s_clpr_codi_alte = p_codi_prov_espo then
        v_indi_espo := upper('s');
      end if;
    else
      if i_s_clpr_codi_alte = p_codi_clie_espo then
        v_indi_espo := upper('s');
      end if;
    end if;
  
    if nvl(i_tico_indi_timb_auto, 'N') = 'S' then
      if nvl(p_tico_indi_timb, 'C') = 'P' then
      
        if i_clpr_indi_clie_prov = upper('p') and
           nvl(v_indi_espo, 'N') = 'N' then
        
          for x in c_timb loop
            v_indi_entro := upper('s');
          
            if i_movi_nume_timb is not null then
              p_timb      := i_movi_nume_timb;
              p_fech_venc := i_fech_venc_timb;
            else
              p_timb      := x.cptc_nume_timb;
              p_fech_venc := x.cptc_fech_venc;
            end if;
            exit;
          end loop;
        else
          v_indi_entro := upper('s');
        
        end if;
      elsif nvl(p_tico_indi_timb, 'C') = 'C' then
        ---si es por tipo de comprobante
        for y in c_timb_2 loop
          v_indi_entro := upper('s');
          if i_movi_nume_timb is not null then
            p_timb      := i_movi_nume_timb;
            p_fech_venc := i_fech_venc_timb;
          else
            p_timb      := y.deta_nume_timb;
            p_fech_venc := y.deta_fech_venc;
          end if;
          exit;
        end loop;
      elsif nvl(p_tico_indi_timb, 'C') = 'S' then
        for x in c_timb_3 loop
          v_indi_entro := upper('s');
          if i_movi_nume_timb is not null then
            p_timb      := i_movi_nume_timb;
            p_fech_venc := i_fech_venc_timb;
          else
            p_timb      := x.setc_nume_timb;
            p_fech_venc := x.setc_fech_venc;
          end if;
          exit;
        end loop;
      end if;
    end if;
  
    if v_indi_entro = upper('n') and
       nvl(upper(i_tico_indi_vali_timb), 'N') = 'S' then
      raise_application_error(-20010,
                              'No existe registro de timbrado cargado para este proveedor, o el timbrado cargado se encuentra vencido!!!');
    end if;
  
  end;

  procedure pl_muestra_come_mone(p_mone_codi      in number,
                                 p_mone_desc      out char,
                                 p_mone_desc_abre out char,
                                 p_mone_cant_deci out number) is
  begin
    select mone_desc, mone_desc_abre, mone_cant_deci
      into p_mone_desc, p_mone_desc_abre, p_mone_cant_deci
      from come_mone
     where mone_codi = p_mone_codi;
  exception
    when no_data_found then
      p_mone_desc := null;
      raise_application_error(-20010, 'Moneda Inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error el momento de mostrar moneda ');
  end;

  procedure pp_busca_tasa_mone(p_mone_codi in number,
                               p_coti_fech in date,
                               p_mone_coti out number,
                               p_tica_codi in number) is
  begin
    if p_codi_mone_mmnn = p_mone_codi then
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
      raise_application_error(-20010,
                              'Cotizacion Inexistente para la fecha del documento.');
    when others then
      raise_application_error(-20010,
                              'Error al momenot de mostrar tasa: ' ||
                              sqlerrm);
  end;

  procedure pp_muestra_ticl_desc(p_codi in number, p_desc out varchar2) is
  begin
  
    select ticl_Desc
      into p_desc
      from come_tipo_comp_clas
     where ticl_codi = p_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Tipo de factura ');
    
  end;

  procedure pp_valida_conc_iva(p_conc_codi in number) is
    --validar que no se seleccione un concepto de Tipo Iva..
  
    cursor c_conc_iva is
      select impu_conc_codi_ivdb, impu_conc_codi_ivcr
        from come_impu
       order by 1;
  
  begin
  
    for x in c_conc_iva loop
      if x.impu_conc_codi_ivcr = p_conc_codi or
         x.impu_conc_codi_ivdb = p_conc_codi then
        raise_application_error(-20010,
                                'No puede seleccionar un concepto de Tipo Iva');
      end if;
    end loop;
  
  end;

  procedure pp_muestra_come_conc(p_conc_codi           in number,
                                 i_movi_sucu_codi_orig in number,
                                 i_movi_dbcr           in varchar2,
                                 p_conc_desc           out varchar2,
                                 p_conc_dbcr           out varchar2,
                                 p_conc_indi_kilo_vehi out varchar2,
                                 p_moco_indi_impo      out varchar2,
                                 p_conc_indi_ortr      out varchar2,
                                 p_conc_indi_gast_judi out varchar2,
                                 p_conc_indi_cent_cost out varchar2,
                                 p_conc_indi_acti_fijo out varchar2,
                                 p_cuco_nume           out varchar2,
                                 p_cuco_desc           out varchar2) is
    v_dbcr_desc      char(7);
    v_conc_sucu_codi number;
    v_conc_indi_inac varchar2(1);
  begin
  
    select conc_desc,
           rtrim(ltrim(conc_dbcr)),
           conc_indi_kilo_vehi,
           conc_sucu_codi,
           nvl(conc_indi_inac, 'N'),
           nvl(conc_indi_impo, 'N'),
           nvl(conc_indi_ortr, 'N'),
           nvl(conc_indi_gast_judi, 'N'),
           nvl(conc_indi_cent_Cost, 'N'),
           nvl(conc_indi_acti_fijo, 'N'),
           cuco_nume,
           cuco_Desc
    
      into p_conc_desc,
           p_conc_dbcr,
           p_conc_indi_kilo_vehi,
           v_conc_sucu_codi,
           v_conc_indi_inac,
           p_moco_indi_impo,
           p_conc_indi_ortr,
           p_conc_indi_gast_judi,
           p_conc_indi_cent_cost,
           p_conc_indi_acti_fijo,
           p_cuco_nume,
           p_cuco_desc
    
      from come_conc c, come_cuen_cont cc
     where c.conc_cuco_codi = cc.cuco_codi(+)
       and conc_codi = p_conc_codi;
  
    if v_conc_sucu_codi is not null then
      if v_conc_sucu_codi <> i_movi_sucu_codi_orig then
        raise_application_error(-20010,
                                'El concepto seleccionado no pertenece a la sucursal!');
      end if;
    end if;
  
    if rtrim(ltrim(p_conc_dbcr)) <> rtrim(ltrim(i_movi_dbcr)) then
      if i_movi_dbcr = 'D' then
        v_dbcr_desc := 'Debito';
      else
        v_dbcr_desc := 'Credito';
      end if;
      raise_application_error(-20010,
                              'Debe ingresar un Concepto de tipo ' ||
                              rtrim(ltrim(v_dbcr_desc)));
    end if;
  
    if v_conc_indi_inac = 'S' then
      raise_application_error(-20010, 'El concepto se encuentra inactivo');
    end if;
  
  exception
    when no_data_found then
      p_conc_desc := null;
      p_conc_dbcr := null;
      raise_application_error(-20010, 'Concepto Inexistente!');
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_validar_user_conc(p_conc_codi in number) is
    v_count number;
  begin
    select count(*)
      into v_count
      from segu_user_conc, segu_user
     where usco_user_codi = user_codi
       and user_login = user
       and usco_conc_codi = p_conc_codi;
    if v_count > 0 then
      raise_application_error(-20010,
                              'Concepto bloqueado. Favor verifique.');
    end if;
  end;

  procedure pp_mostrar_impu(i_moco_impu_codi           in number,
                            i_movi_dbcr                in varchar2,
                            p_moco_impu_desc           out varchar2,
                            p_moco_impu_porc           out number,
                            p_moco_impu_porc_base_impo out number,
                            p_moco_impu_indi_baim_impu out varchar2,
                            p_moco_conc_codi_impu      out number) is
  
  begin
  
    select impu_desc,
           impu_porc,
           impu_porc_base_impo,
           nvl(impu_indi_baim_impu_incl, 'S'),
           decode(i_movi_dbcr,
                  'C',
                  IMPU_CONC_CODI_IVCR,
                  IMPU_CONC_CODI_IVDB)
      into p_moco_impu_desc,
           p_moco_impu_porc,
           p_moco_impu_porc_base_impo,
           p_moco_impu_indi_baim_impu,
           p_moco_conc_codi_impu
      from come_impu
     where impu_codi = i_moco_impu_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Tipo de Impuesto inexistente');
    when too_many_rows then
      raise_application_error(-20010, 'Tipo de Impuesto duplicado');
    when others then
      raise_application_error(-20010, 'When others... ' || sqlerrm);
  end;

  procedure pp_mostrar_tipo_impuesto(p_codi in number, p_desc out varchar2) is
  begin
  
    if lower(nvl(p_ind_validar_Det, 's')) = 's' then
      if p_codi is not null then
      
        select tiim_desc
          into p_desc
          from come_tipo_impu
         where tiim_codi = p_codi;
      
      else
        p_desc := null;
        raise_application_error(-20010,
                                'Debe ingresar el tipo de impuesto');
      end if;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Tipo de impuesto inexistente');
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_validar_asiento(p_movi_codi in number) is
  
    cursor c_moas is
      select moas_asie_codi, nvl(moas_tipo, 'A') moas_tipo
        from come_movi_asie
       where moas_movi_codi = p_movi_codi;
  
  begin
  
    for x in c_moas loop
      if x.moas_tipo <> 'M' then
        raise_application_error(-20010,
                                'No se puede eliminar el Documento porque posee un asiento automatico. Primero debes borrar el asiento relacionado');
      end if;
    
    end loop;
  
  end;

  procedure pp_borrar_registro(p_movi_codi in number) is
    salir     exception;
    v_message varchar2(100) := 'Desea borrar definitivamente el documento?';
  begin
  
    pp_borrar_Asiento(p_movi_codi);
  
    pp_borrar_movi_hijos(p_movi_codi);
  
    --Detalle de productos..................
    delete from come_movi_prod_deta c where c.deta_movi_codi = p_movi_codi;
    --Detalle de Cuotas.....................
    delete from come_movi_cuot where cuot_movi_codi = p_movi_codi;
    ---detalle de Impuestos.................
    delete come_movi_impu_deta where moim_movi_codi = p_movi_codi;
  
    ---detalle de conceptos.................
    delete come_movi_conc_deta where moco_movi_codi = p_movi_codi;
  
    --detalle de importes...
    delete come_movi_impo_deta where moim_movi_codi = p_movi_codi;
  
    --detalle de cheques
  
    pp_dele_cheq(p_movi_codi);
  
    delete come_movi where movi_codi = p_movi_codi;
  
  exception
    when salir then
      null;
  end;

  procedure pp_dele_cheq(p_movi_codi in number) is
    cursor c_cheq_movi is
      select chmo_cheq_codi,
             chmo_movi_codi,
             chmo_esta_ante,
             chmo_cheq_secu,
             nvl(cheq_indi_ingr_manu, 'N') cheq_indi_ingr_manu
        from come_movi_cheq, come_cheq
       where cheq_codi = chmo_cheq_codi
         and chmo_movi_codi = p_movi_codi;
  
  begin
    for x in c_cheq_movi loop
      update come_movi_cheq
         set chmo_base = p_codi_base
       where chmo_movi_codi = x.chmo_movi_codi
         and chmo_cheq_codi = x.chmo_cheq_codi;
    
      delete come_movi_cheq
       where chmo_movi_codi = x.chmo_movi_codi
         and chmo_cheq_codi = x.chmo_cheq_codi;
    
      --solo se debe borrar el cheque en caso q el estado anterior sea nulo, o sea q dio ingreso al cheq
      --y la secuencia sea 1, además q no fuese ingresado manualmente...................................
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
          
            raise_application_error(-20010,
                                    'Un cheque forma parte de un Cierre de Caja de Fecha: ' ||
                                    to_char(v_caja_fech, 'dd-mm-yyyy') ||
                                    ' Caja: ' || v_caja_cuen_codi);
          end if;
        exception
          when no_data_found then
            null;
        end;
      
        update come_movi_cheq_canj c
           set c.canj_base = p_codi_base
         where c.canj_cheq_codi_entr = x.chmo_cheq_codi
           and c.canj_movi_codi = p_movi_codi;
      
        delete come_movi_cheq_canj c
         where c.canj_cheq_codi_entr = x.chmo_cheq_codi
           and c.canj_movi_codi = p_movi_codi;
      
        update come_cheq
           set cheq_base = p_codi_base
         where cheq_codi = x.chmo_cheq_codi;
      
        delete come_cheq where cheq_codi = x.chmo_cheq_codi;
      end if;
    end loop;
  end;

  procedure pp_borrar_Asiento(p_movi_codi in number) is
  
    cursor c_moas is
      select moas_asie_codi, nvl(moas_tipo, 'A') moas_tipo
        from come_movi_asie
       where moas_movi_codi = p_movi_codi;
  
  begin
  
    for x in c_moas loop
      if x.moas_tipo <> 'M' then
        raise_application_error(-20010,
                                'No se puede eliminar el Documento porque el asiento relacionado no fue generado desde un movimiento');
      else
        delete come_movi_asie where moas_asie_codi = x.moas_asie_codi;
      
        delete come_asie_deta where deta_asie_codi = x.moas_asie_codi;
        delete come_asie where asie_codi = x.moas_asie_codi;
      
      end if;
    
    end loop;
  
  end;

  procedure pp_borrar_movi_hijos(p_movi_codi in number) is
  
    cursor c_hijos(p_codi in number) is
      select movi_codi from come_movi where movi_codi_padr = p_codi;
  
    cursor c_nietos(p_codi in number) is
      select movi_codi from come_movi where movi_codi_padr = p_codi;
  
  begin
  
    for x in c_hijos(p_movi_codi) loop
    
      for y in c_nietos(x.movi_codi) loop
      
        update come_movi_prod_deta
           set deta_base = p_codi_base
         where deta_movi_codi = y.movi_codi;
        delete come_movi_prod_deta where deta_movi_codi = y.movi_codi;
      
        update come_movi_ortr_deta
           set deta_base = p_codi_base
         where deta_movi_codi = y.movi_codi;
        delete come_movi_ortr_deta where deta_movi_codi = y.movi_codi;
      
        update come_movi_cuot
           set cuot_base = p_codi_base
         where cuot_movi_codi = y.movi_codi;
        delete come_movi_cuot where cuot_movi_codi = y.movi_codi;
      
        update come_movi_impu_deta
           set moim_base = p_codi_base
         where moim_movi_codi = y.movi_codi;
        delete come_movi_impu_deta where moim_movi_codi = y.movi_codi;
      
        update come_movi_ortr_prod_deta
           set deta_base = p_codi_base
         where deta_movi_codi = y.movi_codi;
        delete come_movi_ortr_prod_deta where deta_movi_codi = y.movi_codi;
      
        update come_movi
           set movi_base = p_codi_base, movi_codi_rete = null
         where movi_codi_rete = y.movi_codi;
      
        --*****************************************
        declare
          v_caja_codi      number;
          v_caja_cuen_codi number;
          v_caja_fech      date;
        begin
          select max(d.moim_caja_codi)
            into v_caja_codi
            from come_movi_impo_deta d
           where d.moim_movi_codi = y.movi_codi;
          if v_caja_codi is not null then
            select c.caja_cuen_codi, c.caja_fech
              into v_caja_cuen_codi, v_caja_fech
              from come_cier_caja c
             where c.caja_codi = v_caja_codi;
            raise_application_error(-20010,
                                    'Un documento nieto forma parte de un Cierre de Caja de Fecha: ' ||
                                    to_char(v_caja_fech, 'dd-mm-yyyy') ||
                                    ' Caja: ' || v_caja_cuen_codi);
          end if;
        exception
          when no_data_found then
            null;
        end;
        update come_movi_impo_deta
           set moim_base = p_codi_base
         where moim_movi_codi = y.movi_codi;
        delete come_movi_impo_deta where moim_movi_codi = y.movi_codi;
        --*****************************************
      
        update come_movi_conc_deta
           set moco_base = p_codi_base
         where moco_movi_codi = y.movi_codi;
        delete come_movi_conc_deta where moco_movi_codi = y.movi_codi;
      
        pp_dele_cheq(y.movi_codi);
      
        update come_movi_cuot_canc
           set canc_base = p_codi_base
         where canc_movi_codi = y.movi_codi;
        delete come_movi_cuot_canc where canc_movi_codi = y.movi_codi;
      
        update come_pres_clie
           set pres_movi_codi = null, pres_base = p_codi_base
         where pres_movi_codi = y.movi_codi;
      
        --borra detalle de contratos
        update come_movi_cont_deta
           set como_base = p_codi_base
         where como_movi_codi = y.movi_codi;
      
        delete come_movi_cont_deta where como_movi_codi = y.movi_codi;
      
        update come_movi
           set movi_base = p_codi_base
         where movi_codi = y.movi_codi;
        delete come_movi where movi_codi = y.movi_codi;
      
      end loop;
    
      update come_movi_prod_deta
         set deta_base = p_codi_base
       where deta_movi_codi = x.movi_codi;
      delete come_movi_prod_deta where deta_movi_codi = x.movi_codi;
    
      update come_movi_cuot
         set cuot_base = p_codi_base
       where cuot_movi_codi = x.movi_codi;
      delete come_movi_cuot where cuot_movi_codi = x.movi_codi;
    
      update come_movi_impu_deta
         set moim_base = p_codi_base
       where moim_movi_codi = x.movi_codi;
      delete come_movi_impu_deta where moim_movi_codi = x.movi_codi;
    
      --*****************************************
      declare
        v_caja_codi      number;
        v_caja_cuen_codi number;
        v_caja_fech      date;
      begin
        select max(d.moim_caja_codi)
          into v_caja_codi
          from come_movi_impo_deta d
         where d.moim_movi_codi = x.movi_codi;
        if v_caja_codi is not null then
          select c.caja_cuen_codi, c.caja_fech
            into v_caja_cuen_codi, v_caja_fech
            from come_cier_caja c
           where c.caja_codi = v_caja_codi;
          raise_application_error(-20010,
                                  'Un documento hijo forma parte de un Cierre de Caja de Fecha: ' ||
                                  to_char(v_caja_fech, 'dd-mm-yyyy') ||
                                  ' Caja: ' || v_caja_cuen_codi);
        end if;
      exception
        when no_data_found then
          null;
      end;
      update come_movi_impo_deta
         set moim_base = p_codi_base
       where moim_movi_codi = x.movi_codi;
      delete come_movi_impo_deta where moim_movi_codi = x.movi_codi;
      --*****************************************
    
      update come_movi_conc_deta
         set moco_base = p_codi_base
       where moco_movi_codi = x.movi_codi;
      delete come_movi_conc_deta where moco_movi_codi = x.movi_codi;
    
      pp_dele_cheq(x.movi_codi);
    
      update come_movi_cuot_canc
         set canc_base = p_codi_base
       where canc_movi_codi = x.movi_codi;
      delete come_movi_cuot_canc where canc_movi_codi = x.movi_codi;
    
      update come_pres_clie
         set pres_movi_codi = null, pres_base = p_codi_base
       where pres_movi_codi = x.movi_codi;
    
      --borra detalle de contratos
    
      update come_movi_cont_deta
         set como_base = p_codi_base
       where como_movi_codi = x.movi_codi;
    
      delete come_movi_cont_deta where como_movi_codi = x.movi_codi;
    
      update come_movi
         set movi_base = p_codi_base
       where movi_codi = x.movi_codi;
      delete come_movi where movi_codi = x.movi_codi;
    
      update come_movi
         set movi_base = p_codi_base, movi_codi_rete = null
       where movi_codi_rete = x.movi_codi;
    
    end loop;
  
  end;

  procedure pp_generar_cuotas(i_s_tipo_vto          in varchar2,
                              i_s_entrega           in number,
                              i_s_cant_cuotas       in number,
                              i_movi_fech_emis      in date,
                              i_s_total             in number,
                              i_movi_mone_cant_deci in number) is
    v_dias        number;
    v_importe     number;
    v_cant_cuotas number;
    v_entrega     number := 0;
    v_vto         number;
    v_diferencia  number;
    v_count       number := 0;
    v_fech_venc   date;
  
  begin
  
    if i_s_tipo_vto = 'M' then
      v_vto := 30;
    elsif i_s_tipo_vto = 'Q' then
      v_vto := 15;
    elsif i_s_tipo_vto = 'S' then
      v_vto := 7;
    end if;
  
    if i_s_entrega = 0 then
      --si no tiene entrega
      v_dias := v_vto;
    
      v_entrega     := 0;
      v_cant_cuotas := i_s_cant_cuotas;
      v_importe     := round(i_s_total / v_cant_cuotas,
                             i_movi_mone_cant_deci);
      v_diferencia  := (i_s_total - (v_importe * v_cant_cuotas));
    
      for x in 1 .. v_cant_cuotas loop
      
        v_fech_venc := i_movi_fech_emis + v_dias;
        pp_veri_fech_venc_feri(v_fech_venc);
        v_dias := v_dias + p_cant_dias_feri;
      
        v_dias  := v_dias + v_vto - p_cant_dias_feri;
        v_count := v_count + 1;
      
        insert into come_tabl_auxi
          (taax_c001,
           taax_c002,
           taax_c003,
           taax_sess,
           taax_user,
           taax_seq,
           taax_c050)
        values
          (v_dias,
           v_fech_venc,
           v_importe,
           p_session,
           p_usuario,
           seq_come_tabl_auxi.nextval,
           'CUOTA');
      
      end loop;
    
      ---------------------
      if v_diferencia <> 0 then
        --sumar la diferencia a la ultima cuota 
      
        update come_tabl_auxi
           set taax_c003 = to_number(taax_c003) + v_diferencia
         where taax_seq = (select max(taax_seq)
                             from come_tabl_auxi
                            where taax_sess = p_session
                              and taax_user = p_usuario
                              and taax_c050 = 'CUOTA');
      
      end if;
      ----------------------
    else
      --si tiene entrega
      v_dias        := 0;
      v_entrega     := i_s_entrega;
      v_cant_cuotas := i_s_cant_cuotas;
      v_importe     := round((i_s_total - v_entrega) / v_cant_cuotas,
                             i_movi_mone_cant_deci);
      v_diferencia  := (i_s_total -
                       ((v_importe * v_cant_cuotas) + v_entrega));
    
      v_fech_venc := i_movi_fech_emis + v_dias;
      pp_veri_fech_venc_feri(v_fech_venc);
      v_dias := v_dias + p_cant_dias_feri;
    
      --  :bcuota.dias           := v_dias; --0;    
      --  :bcuota.cuot_impo_mone := v_entrega;
      v_dias := v_vto - p_cant_dias_feri;
    
      for x in 1 .. v_cant_cuotas loop
      
        v_fech_venc := i_movi_fech_emis + v_dias;
        pp_veri_fech_venc_feri(v_fech_venc);
        v_dias := v_dias + p_cant_dias_feri;
      
        v_dias  := v_dias + v_vto - p_cant_dias_feri;
        v_count := v_count + 1;
      
        insert into come_tabl_auxi
          (taax_c001,
           taax_c002,
           taax_c003,
           taax_sess,
           taax_user,
           taax_seq,
           taax_c050)
        values
          (v_dias,
           v_fech_venc,
           v_importe,
           p_session,
           p_usuario,
           seq_come_tabl_auxi.nextval,
           'CUOTA');
      
      end loop;
      ---------------------
      if v_diferencia <> 0 then
        --sumar la diferencia a la ultima cuota   
      
        update come_tabl_auxi
           set taax_c003 = to_number(taax_c003) + v_diferencia
         where taax_seq = (select max(taax_seq)
                             from come_tabl_auxi
                            where taax_sess = p_session
                              and taax_user = p_usuario
                              and taax_c050 = 'CUOTA');
      
      end if;
    end if;
  
  end;

  procedure pp_veri_fech_venc_feri(p_cuot_fech_venc in date) is
    v_fech_veri      varchar2(1);
    v_feri_fech      date;
    v_feri_cont_anho varchar2(1);
    v_cuot_fech_venc date;
  
  begin
    v_fech_veri      := 'N';
    v_cuot_fech_venc := p_cuot_fech_venc;
    p_cant_dias_feri := 0;
  
    while v_fech_veri <> 'S' loop
      begin
        select feri_fech, feri_cont_anho
          into v_feri_fech, v_feri_cont_anho
          from come_feri
         where feri_empr_codi = p_empr_codi
           and to_char(feri_fech, 'dd-mm') =
               to_char(v_cuot_fech_venc, 'dd-mm');
      
        if nvl(v_feri_cont_anho, 'S') = 'S' then
          v_cuot_fech_venc := v_cuot_fech_venc + 1;
          v_fech_veri      := 'N';
          p_cant_dias_feri := p_cant_dias_feri + 1;
        else
          if v_cuot_fech_venc = v_feri_fech then
            v_cuot_fech_venc := v_cuot_fech_venc + 1;
            v_fech_veri      := 'N';
            p_cant_dias_feri := p_cant_dias_feri + 1;
          else
            --p_cuot_fech_venc := v_cuot_fech_venc;
            v_fech_veri := 'S';
          end if;
        end if;
      exception
        when no_data_found then
          --p_cuot_fech_venc := v_cuot_fech_venc;
          v_fech_veri := 'S';
      end;
    end loop;
  end;

  procedure pp_valida_totales(i_f_dif_impo                in number,
                              i_F_DIF_IMPO_EXEN_MONE      in number,
                              i_F_DIF_IMPO_GRAV5_II_MONE  in number,
                              i_F_DIF_IMPO_GRAV10_II_MONE in number,
                              i_movi_afec_sald            in varchar2,
                              i_movi_mone_codi            in number) is
  
    v_S_IMPO_MONE     number;
    v_SUM_S_IMPO_MOVI number;
  
  begin
  
    select sum(taax_c008) p_impo, sum(taax_c009) p_impo_naci
      into v_S_IMPO_MONE, v_SUM_S_IMPO_MOVI
      from come_tabl_auxi
     where taax_sess = p_session
       and taax_c050 = 'FP';
  
    if i_f_dif_impo <> 0 then
      raise_application_error(-20010,
                              'Existe una diferencia entre el total importe y el detalle de conceptos');
    end if;
  
    if i_F_DIF_IMPO_EXEN_MONE <> 0 then
      raise_application_error(-20010,
                              'Existe una diferencia entre el total exento y el detalle de conceptos');
    end if;
  
    if i_F_DIF_IMPO_GRAV5_II_MONE <> 0 then
      raise_application_error(-20010,
                              'Existe una diferencia entre el total Grav5 y el detalle de conceptos');
    end if;
  
    if i_F_DIF_IMPO_GRAV10_II_MONE <> 0 then
      raise_application_error(-20010,
                              'Existe una diferencia entre el total grav10 y el detalle de conceptos');
    end if;
  
    if i_movi_afec_sald = 'N' then
      if nvl(v_SUM_S_IMPO_MOVI, 0) <> nvl(v_S_IMPO_MONE, 0) then
        -- si existe diferencia y el documento es en gs. el pago es en otra moneda, 
        -- por ende se ajustará en importe nacional si es menor a 100gs
      
        --si el documento es en otra moneda, el importe del movimiento debe coincidir si o si con el importe de forma de pago.
        --en caso de mas de un tipo de moneda, se ajustara en gs.   
        raise_application_error(-20010,
                                'Existe una diferencia entre el total del movimiento y el detalle de pago en la forma de pago.');
      
      end if;
    end if;
  end;

  procedure pp_valida_cheques is
  
    cursor c_fp_cq is
      select taax_c001 p_form_pago,
             taax_c011 p_cheq_serie,
             taax_c012 p_cheq_nume,
             taax_c013 p_cheq_banc_codi
        from come_tabl_auxi
       where taax_c050 = 'FP'
         and taax_sess = p_session;
  
  begin
    if p_indi_vali_repe_cheq = 'S' then
    
      for i in c_fp_cq loop
        if i.p_form_pago in ('4') then
          i020009.pp_valida_nume_cheq(i.p_cheq_nume,
                                      i.p_cheq_serie,
                                      i.p_cheq_banc_codi);
        end if;
      end loop;
    
    end if;
  end;

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
  
    if p_indi_vali_repe_cheq = 'S' then
      raise_application_error(-20010,
                              'Atención!!! Cheque existente... Numero' ||
                              p_cheq_nume || ' Serie' || p_cheq_serie ||
                              ' Banco ' || v_banc_desc);
    else
      raise_application_error(-20010,
                              'Atención!!! Cheque existente... Numero' ||
                              p_cheq_nume || ' Serie' || p_cheq_serie ||
                              ' Banco ' || v_banc_desc);
    end if;
  exception
    when no_data_found then
      null;
    when too_many_rows then
      if p_indi_vali_repe_cheq = 'S' then
        raise_application_error(-20010,
                                'Atención!!! Cheque existente... Numero' ||
                                p_cheq_nume || ' Serie' || p_cheq_serie ||
                                ' Banco ' || v_banc_desc);
      else
        raise_application_error(-20010,
                                'Atención!!! Cheque existente... Numero' ||
                                p_cheq_nume || ' Serie' || p_cheq_serie ||
                                ' Banco ' || v_banc_desc);
      end if;
  end;

  procedure pp_validar_importes(i_movi_timo_codi      in number,
                                i_movi_timo_indi_caja in varchar2,
                                i_clpr_indi_clie_prov in varchar2,
                                i_s_total             in number) is
  
    v_s_impo_cheq      number := 0;
    v_s_impo_efec      number := 0;
    v_s_impo_tarj      number := 0;
    v_s_impo_adel      number := 0;
    v_s_impo_vale      number := 0;
    v_s_impo_rete_reci number := 0;
    v_s_impo_viaj      number := 0;
    v_s_impo_rete      number := 0;
    v_s_impo_rete_rent number := 0;
  
  begin
  
    select sum(taax_c010)
      into V_s_impo_efec
      from come_tabl_auxi
     where taax_sess = p_session
       and taax_user = p_usuario
       and taax_c050 = 'FP'
       and taax_c049 = 'EFECTIVO';
    select sum(taax_c010)
      into v_s_impo_cheq
      from come_tabl_auxi
     where taax_sess = p_session
       and taax_user = p_usuario
       and taax_c050 = 'FP'
       and taax_c049 = 'CHEQUE';
    --select sum(taax_c010) into V_s_impo_efec from come_table_auxi where taax_sess = p_session and taax_user = p_usuario and taax_c050 = 'FP' and taax_c049 = 'CHEQUE_EMIT';
    select sum(taax_c010)
      into v_s_impo_tarj
      from come_tabl_auxi
     where taax_sess = p_session
       and taax_user = p_usuario
       and taax_c050 = 'FP'
       and taax_c049 = 'TARJETA';
    select sum(taax_c010)
      into v_s_impo_rete_reci
      from come_tabl_auxi
     where taax_sess = p_session
       and taax_user = p_usuario
       and taax_c050 = 'FP'
       and taax_c049 = 'RETE';
  
    if i_movi_timo_indi_caja = 'S' then
    
      --mov. q afecta a caja
      if i_movi_timo_codi in
         (p_codi_timo_auto_fact_emit, p_codi_timo_auto_fact_emit_cr) then
      
        if p_indi_apli_rete_exen = 'S' and
           nvl(i_clpr_indi_clie_prov, 'C') = 'P' then
        
          if (nvl(v_s_impo_cheq, 0) + nvl(v_s_impo_efec, 0) +
             nvl(v_s_impo_tarj, 0) + nvl(v_s_impo_adel, 0) +
             nvl(v_s_impo_vale, 0)) + nvl(v_s_impo_rete_reci, 0) +
             nvl(v_s_impo_viaj, 0) <>
             (nvl(i_s_total, 0) - nvl(v_s_impo_rete, 0) -
             nvl(v_s_impo_rete_rent, 0)) then
          
            raise_application_error(-20010,
                                    'El importe total de cheques + el importe en efectivo + el importe en tarjetas ' ||
                                    '+ el importe en Vales a rendir + el importe de Retenciones Recibidas ' ||
                                    'debe ser igual al importe del documento - las Retenciones');
          end if; --no se agrego aun adelanto en el mensaje. 
        
        else
        
          if (nvl(v_s_impo_cheq, 0) + nvl(v_s_impo_efec, 0) +
             nvl(v_s_impo_tarj, 0) + nvl(v_s_impo_adel, 0) +
             nvl(v_s_impo_vale, 0)) + nvl(v_s_impo_rete_reci, 0) +
             nvl(v_s_impo_viaj, 0) <> (nvl(i_s_total, 0)) then
          
            raise_application_error(-20010,
                                    'El importe total de cheques + el importe en efectivo + el importe en tarjetas ' ||
                                    '+ el importe en Vales a rendir + el importe de Retenciones Recibidas ' ||
                                    'debe ser igual al importe del documento');
          end if; --no se agrego aun adelanto en el mensaje.
        end if;
      
      else
      
        if (nvl(v_s_impo_cheq, 0) + nvl(v_s_impo_efec, 0) +
           nvl(v_s_impo_tarj, 0) + nvl(v_s_impo_adel, 0) +
           nvl(v_s_impo_vale, 0)) + nvl(v_s_impo_rete_reci, 0) +
           nvl(v_s_impo_viaj, 0) <>
           (nvl(i_s_total, 0) - nvl(v_s_impo_rete, 0) -
           nvl(v_s_impo_rete_rent, 0)) then
        
     raise_application_error(-20010,
                                  'El importe total de cheques + el importe en efectivo + el importe en tarjetas ' ||
                                  '+ el importe en Vales a rendir + el importe de Retenciones Recibidas ' ||
                                  'debe ser igual al importe del documento - las retenciones...');
                                  
        end if; --no se agrego aun adelanto en el mensaje. 
      
      end if;
    
    end if;
  
  
    /* raise_application_error(-20010, nvl(v_s_impo_cheq, 0) ||' '|| nvl(v_s_impo_efec, 0)  ||' '||
                                       nvl(v_s_impo_tarj, 0)  ||' '|| nvl(v_s_impo_adel, 0)  ||' '||
                                       nvl(v_s_impo_vale, 0)  ||' '|| nvl(v_s_impo_rete_reci, 0)  ||' '||
                                       nvl(v_s_impo_viaj, 0)  ||' <> '||
                                       nvl(i_s_total, 0)  ||' '|| nvl(v_s_impo_rete, 0)  ||' '||
                                       nvl(v_s_impo_rete_rent, 0)|| 'hola');**/
  
  end;

  procedure pp_validar_conceptos is
  
    v_indi_ot varchar2(1) := 'n';
  
    cursor c_conc is
      select taax_c001 i_moco_conc_codi,
             taax_c002 p_conc_desc,
             taax_c004 i_conc_indi_kilo_vehi,
             taax_c005 i_conc_indi_impo,
             taax_c006 i_conc_indi_ortr,
             taax_c007 i_conc_indi_gast_judi,
             taax_c008 i_conc_indi_cent_cost,
             taax_c009 i_conc_indi_acti_fijo,
             
             taax_c043    i_moco_juri_codi,
             taax_c044    i_juri_nume,
             taax_c045    i_moco_impo_codi,
             taax_c046    i_moco_ceco_codi,
             taax_c047    i_moco_emse_codi,
             taax_c048    i_moco_ortr_codi,
             taax_c049    i_moco_Tran_codi
             
        from come_tabl_auxi
       where taax_sess = p_session
         and taax_user = p_usuario
         and taax_c050 = 'DETALLES';
  
    v_moco_juri_codi number;
    v_juri_nume      number;
    v_moco_impo_codi number;
    v_moco_ceco_codi number;
    v_moco_emse_codi number;
    v_moco_ortr_codi number;
    v_moco_Tran_codi number;
    v_tran_codi_alte number;
  
    v_impo_nume number;
    v_ceco_nume number;
    v_ortr_nume number;
  
  begin
  
    for i in c_conc loop
    
    begin
      select moco_juri_codi,
             juri_nume,
             moco_impo_codi,
             moco_ceco_codi,
             moco_emse_codi,
             moco_ortr_codi,
             moco_Tran_codi,
             tran_codi_alte
      /*moco_conc_codi,
      moco_impu_codi,
      moco_tiim_codi,
      moco_nume_item,
      moco_impo_mone_ii,
      moco_desc,
      moco_impo_codi,
      moco_juri_codi,
      moco_orse_codi,
      moco_osli_codi,
      osli_nume_liqu,
      moco_ortr_codi,
      moco_ceco_codi,
      moco_tran_codi,
      moco_emse_codi,
      moco_sucu_codi,           
      impo_nume,
      ortr_nume,
      orse_nume_char,
      tran_codi_alte,
      ceco_nume,
      emse_codi_alte,
      juri_nume*/
        into v_moco_juri_codi,
             v_juri_nume,
             v_moco_impo_codi,
             v_moco_ceco_codi,
             v_moco_emse_codi,
             v_moco_ortr_codi,
             v_moco_Tran_codi,
             v_tran_codi_alte
        from come_movi_conc_deta,
             come_orde_trab,
             come_impo,
             come_empr_secc,
             come_cent_cost,
             come_tran,
             come_clie_juri,
             (select osli_codi, osli_nume_liqu, orse_nume_char
                from come_orde_serv, come_orde_serv_liqu_deta
               where orse_codi = osli_orse_codi) osli
       where moco_ortr_codi = ortr_codi(+)
         and moco_impo_codi = impo_codi(+)
         and moco_emse_codi = emse_codi(+)
         and moco_Ceco_codi = ceco_codi(+)
         and moco_tran_codi = tran_codi(+)
         and moco_juri_codi = juri_codi(+)
         and moco_osli_codi = osli.osli_codi(+)
         and moco_movi_codi = i.i_moco_conc_codi
         and moco_conc_codi not in
             (select impu_conc_codi_ivcr
                from come_impu
               where impu_conc_codi_ivcr is not null
              union
              select impu_conc_codi_ivdb
                from come_impu
               where impu_conc_codi_ivdb is not null);
    
    exception 
      when no_data_found then 
        null;
    end;   
     
    
      --validar gastos judiciales
      if nvl(lower(i.i_conc_indi_gast_judi), 'n') = 's' then
        if i.i_moco_juri_codi is null then
          raise_application_error(-20010,
                                  'Debe ingresar un nro de expediente judicial para el concepto ' ||
                                  i.i_moco_conc_codi || ' ' ||
                                  i.p_conc_desc);
        end if;
      end if;
    
      ---validar importaciones
      if nvl(lower(i.i_conc_indi_impo), 'n') = 's' then
        if i.i_moco_impo_codi is null then
          raise_application_error(-20010,
                                 'Debe ingresar una importacion para el concepto ' ||
                                  i.i_moco_conc_codi || ' ' ||
                                  i.p_conc_desc);
        end if;
      end if;
    
      --validar centro de costos
      if lower(nvl(i.i_conc_indi_cent_cost, 'n')) = 's' then
        if i.i_moco_ceco_codi is null then
          raise_application_error(-20010,
                                  'Debe ingresar el centro de costo');
        end if;
      end if;
    
      --validar Orden de servicio
      -----no se valida ------
    
      --validar secciones de empresa
      if nvl(lower(p_indi_most_secc_dbcr), 'n') = 's' then
        if i.i_moco_emse_codi is null then
          raise_application_error(-20010,
                                  'Debe ingresar la seccion de la empresa');
        end if;
      end if;
    
      --validar OT
      if nvl(lower(i.i_conc_indi_ortr), 'n') = 's' then
        if i.i_moco_ortr_codi is null then
          raise_application_error(-20010, 'Debe ingresar el Nro de OT');
        end if;
      end if;
    
      ---validar gastos de veihicuos y km
      if nvl(lower(i.i_conc_indi_kilo_vehi), 'n') <> 'n' then
        if nvl(lower(i.i_conc_indi_kilo_vehi), 'n') in ('s', 'sg') then
          if i.i_moco_Tran_codi is null then
            raise_application_error(-20010,
                                    'Debe ingresar el codigo del vehiculo');
          end if;
        end if;
      end if;
    
      if v_moco_ortr_codi is not null then
        v_indi_ot := 's';
      end if;
    end loop;
  
    if v_indi_ot = 's' then
      if nvl(p_indi_vali_limi_costo, 'N') = 'S' then
        i020009.pp_valida_limite_costo;
      end if;
    
    end if;
  end;

  procedure pp_valida_limite_costo is
    cursor c_ortr is
      select t.ortr_codi, o.ortr_nume, sum(t.ortr_impo) impo
        from come_ortr_impo_temp t, come_orde_trab o
       where o.ortr_codi = t.ortr_codi
       group by t.ortr_codi, o.ortr_nume
       order by t.ortr_codi, o.ortr_nume;
  
    v_limi_cost number;
    v_cost_actu number;
  
    cursor c_conc_deta is
      select taax_c001 i_moco_conc_codi,
             taax_c020 i_moco_impo_mmnn_ii,
             taax_c002 p_conc_desc,
             taax_c004 i_conc_indi_kilo_vehi,
             taax_c005 i_conc_indi_impo,
             taax_c006 i_conc_indi_ortr,
             taax_c007 i_conc_indi_gast_judi,
             taax_c008 i_conc_indi_cent_cost,
             taax_c009 i_conc_indi_acti_fijo
        from come_tabl_auxi
       where taax_sess = p_session
         and taax_user = p_usuario
         and taax_c050 = 'DETALLES';
  
    v_moco_ortr_codi number;
  
  begin
  
    pack_ortr.pa_agru_ortr_temp(null, null, 'D');
  
    for i in c_conc_deta loop
    
      select moco_ortr_codi
        into v_moco_ortr_codi
        from come_movi_conc_deta,
             come_orde_trab,
             come_impo,
             come_empr_secc,
             come_cent_cost,
             come_tran,
             come_clie_juri,
             (select osli_codi, osli_nume_liqu, orse_nume_char
                from come_orde_serv, come_orde_serv_liqu_deta
               where orse_codi = osli_orse_codi) osli
       where moco_ortr_codi = ortr_codi(+)
         and moco_impo_codi = impo_codi(+)
         and moco_emse_codi = emse_codi(+)
         and moco_Ceco_codi = ceco_codi(+)
         and moco_tran_codi = tran_codi(+)
         and moco_juri_codi = juri_codi(+)
         and moco_osli_codi = osli.osli_codi(+)
         and moco_movi_codi = i.i_moco_conc_codi
         and moco_conc_codi not in
             (select impu_conc_codi_ivcr
                from come_impu
               where impu_conc_codi_ivcr is not null
              union
              select impu_conc_codi_ivdb
                from come_impu
               where impu_conc_codi_ivdb is not null);
    
      if v_moco_ortr_codi is not null then
        pack_ortr.pa_agru_ortr_temp(v_moco_ortr_codi,
                                    i.i_moco_impo_mmnn_ii,
                                    'I');
      end if;
    end loop;
  
    for x in c_ortr loop
      v_limi_cost := pack_ortr.fa_dev_limi_cost(x.ortr_codi);
      v_cost_actu := pack_ortr.fa_dev_cost_ortr(x.ortr_codi);
    
      if nvl(v_cost_actu, 0) + nvl(x.impo, 0) > nvl(v_limi_cost, 0) then
        raise_application_error(-20010,
                                'El Costo de la OT ' || x.ortr_nume ||
                                ' supera el límite de Costo');
      end if;
    end loop;
  end;


procedure pp_valida_movi_a_modi (p_movi_codi in number) is
--|.....................................................................|
--| validar el documento a modificar....................................|
--| 1)- Si es contado, y se pagó con cheques, validar que los cheques...|
--|     no hayan sido depositados, o tenido alguna operacion............|
--| 2)- Si es Credito, que el movi no tenga ningún pago asignado........|
--| 3)- o que no tnga asociado ninguna nota de credito..................|
--|.....................................................................| 

v_cont              number;
v_oper_desc_padr    varchar(60);
v_movi_nume_padr    number;

v_count number;
cursor c_movi is
  select movi_fech_emis
    from come_movi
   where movi_codi = p_movi_codi;

cursor c_hijos (p_codi in number)is
  select movi_codi
    from come_movi
   where movi_codi_padr = p_codi;

cursor c_nietos (p_codi in number)is
  select movi_codi
    from come_movi
   where movi_codi_padr = p_codi;


CURSOR C_OP (P_MOVI_CODI IN NUMBER) IS
SELECT  ORPA_NUME
FROM COME_ORDE_PAGO_DETA OPD, COME_ORDE_PAGO OP
WHERE OP.ORPA_CODI = OPD.DETA_ORPA_CODI
AND OPD.DETA_CUOT_MOVI_CODI = P_MOVI_CODI
GROUP BY ORPA_NUME;





Begin
 
   
  ---Validar que el movimiento en caso que sea credito, las cuotas no
  ---tengan pagos/cance asignados..
  ---O en el caso q sea contado, (si tiene cheques), que los mismos no tengan movimientos posteriores. Ej. un deposito...
   
  for x in c_hijos (p_movi_codi) loop
      i020009.pp_valida_movi_canc(x.movi_codi);
      i020009.pp_valida_cheq(x.movi_codi);
      for y in c_nietos(x.movi_codi) loop
        i020009.pp_valida_movi_canc(y.movi_codi);           
        i020009.pp_valida_cheq(y.movi_codi);
        null;
      end loop;     
  end loop;  

 i020009.pp_valida_movi_canc(p_movi_codi);
 i020009.pp_valida_cheq(p_movi_codi);

  --validar el rango de fecha..
  for w in c_movi loop
    i020009.pp_valida_fech_modi(w.movi_fech_emis);  
  end loop; 


  ---validar que no posea asiento
  
  select  count(*)
  into v_count
from come_movi_asie
where moas_movi_codi = p_movi_codi;

if v_count > 0 then
      
      /*if get_item_property('bpie.aceptar', enabled) = upper('true') then
       set_item_property('bpie.aceptar', enabled,  property_false);
      end if;*/
     raise_application_error(-20010,'No se puede modificar el movimiento porque ya posee asiento');
end if; 

  
  ---validar que no tenga relacionado una Op
  FOR X IN C_OP (P_MOVI_CODI)LOOP
     
      /*
      if get_item_property('bpie.aceptar', enabled) = upper('true') then
       set_item_property('bpie.aceptar', enabled,  property_false);
      end if;*/
     raise_application_error(-20010,'No se puede modificar el movimiento porque se encuentra relacionado a una OP');
     
  END LOOP;
  
  

  

exception
  when others then
    raise_application_error(-20010,'error valida movi-modi: '||SQLERRM);
end;

procedure pp_valida_movi_canc (p_movi_codi in number) is
v_cont number;
begin
  
   select count(*)
   into v_cont
   from come_movi_cuot_canc
   where canc_cuot_movi_codi = p_movi_codi;

   if v_cont > 0 then   	 
   	 --:parameter.p_indi_vali_modi := 'S';
   	  
   	  /*if get_item_property('bpie.aceptar', enabled) = upper('true') then
   	   set_item_property('bpie.aceptar', enabled,  property_false);
      end if;*/
	   raise_application_error(-20010,'Primero debe anular los pagos/Cancelaciones asignados a este Movimiento');
  
   end if;	 
  
end;

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

begin

  for x in c_cheq_movi loop
    select count(*)
      into v_count
      from come_movi_cheq
     where chmo_cheq_codi = x.cheq_codi;
  
    if v_count > x.chmo_cheq_secu then
      --:parameter.p_indi_vali_modi := 'S';
      raise_application_error(-20010,'No se puede modificar el documento, porque el cheque _Nro. ' ||
            x.cheq_nume || ' Serie ' || x.cheq_serie ||
            ' de la entidad Bancaria ' || x.banc_desc ||
            ' posee movimiento/s posterior/es');
    end if;
  end loop;

end;

procedure pp_valida_fech_modi (p_fech in date) is
begin               
 

   pa_devu_fech_habi(p_fech_inic, p_fech_fini);

  if p_fech not between p_fech_inic and p_fech_fini then
  	raise_application_error(-20010, 'La fecha del movimiento debe estar comprendida entre..'||to_char(p_fech_inic, 'dd-mm-yyyy') 
  	                 ||' y '||to_char(p_fech_fini, 'dd-mm-yyyy'));
  end if;	
                          
end;
       
/*
procedure pp_cargar_forma_pago(p_movi_codi in number) is
  
  cursor cv_fp(p_codi in number) is
    select decode(lower(rtrim(ltrim(moim_tipo))),
                  'efectivo',
                  1,
                  'tarjeta',
                  3,
                  'cheq. dif. rec.',
                  2,
                  'cheq. día. rec.',
                  2,
                  'cheq. dif. emit.',
                  4,
                  'cheq. día. emit.',
                  4,
                  'vuelto',
                  5) pago_tipo,
           cuen_mone_codi,
           moim_dbcr,
           moim_cuen_codi,
           moim_fech,
           moim_impo_mone
      from come_movi_impo_deta, come_movi, come_tipo_movi, come_cuen_banc
     where movi_codi = moim_movi_codi
       and movi_timo_codi = timo_codi
       and moim_cuen_codi = cuen_codi
       and lower(substr(moim_tipo, 1, 4)) <> 'rete'
       and moim_movi_codi = p_codi
     order by moim_nume_item;
begin
  

  for r in cv_fp(p_movi_codi) loop
    
  
     --agregado por Juan para usar en modificacion de movimientos variosss 29-03-2023 
        delete from come_tabl_auxi where taax_c050 = 'FP' and taax_sess = v('APP_SESSION') and taax_user = gen_user;        
           
        insert into come_tabl_auxi (taax_sess,
                                    taax_user,
                                    taax_seq,
                                    taax_c001,
                                    taax_c002,
                                    taax_c003,
                                    taax_c004,
                                    taax_c005,
                                    taax_c006,
                                    taax_c007,
                                    taax_c008,
                                    taax_c009,
                                    taax_c010,
                                    taax_c011,
                                    taax_c012,
                                    taax_c013,
                                    taax_c049,
                                    taax_c050) 
                           values (v('APP_SESSION'),
                                   gen_user,
                                   seq_come_tabl_auxi.nextval,
                                   p_form_pago,
                                   v_fopa_desc,
                                   p_cuen_banc,
                                   v_cuen_desc,
                                   p_come_mone,
                                   v_mone_desc,
                                   p_mone_coti,
                                   p_impo,
                                   p_impo_naci,
                                   round(p_impo_docu, nvl(p_mone_cant_deci,  0)),
                                   v_tifo_dbcr,
                                   v_pago_cobr_indi,     
                                   v_fopa_indi_afec_caja,
                                   'EFECTIVO',
                                   'FP');
  
  
  
    
    :bfp.fopa_codi      := r.pago_tipo;
    :bfp.cuen_mone_codi := r.cuen_mone_codi;
    :bfp.moim_cuen_codi := r.moim_cuen_codi;
    :bfp.moim_impo_mone := r.moim_impo_mone;
    
    
    if :bfp.fopa_codi in ('2', '4') then
      --cheques
      select cheq_serie,
             cheq_nume,
             cheq_cuen_codi,
             cheq_banc_codi,
             to_char(cheq_fech_emis, 'dd-mm-yyyy'),
             to_char(cheq_fech_venc, 'dd-mm-yyyy'),
             cheq_nume_cuen,
             cheq_titu,
             cheq_indi_terc
        into :bfp.cheq_serie,
             :bfp.cheq_nume,
             :bfp.cheq_cuen_codi,
             :bfp.cheq_banc_codi,
             :bfp.s_cheq_fech_emis,
             :bfp.s_cheq_fech_venc,
             :bfp.cheq_nume_cuen,
             :bfp.cheq_titu,
             :bfp.cheq_indi_terc
        from come_cheq, come_movi_cheq b
       where cheq_codi = chmo_cheq_codi
         and chmo_movi_codi = p_movi_codi;
    
    elsif :bfp.fopa_codi in ('3') then
      --tarjeta
      select tacu_tapr_codi,
             tacu_tade_codi,
             tacu_tane_codi,
             tacu_tarj_nume,
             to_char(tacu_fech_emis, 'dd-mm-yyyy'),
             to_char(tacu_fech_venc, 'dd-mm-yyyy')
        into :bfp.tarj_proc,
             :bfp.tarj_prod,
             :bfp.tarj_nego,
             :bfp.tarj_nume,
             :bfp.s_tarj_fech_emis,
             :bfp.s_tarj_fech_venc
        from come_tarj_cupo, come_movi_tarj_cupo
       where tacu_codi = mota_tacu_codi
         and mota_movi_codi = p_movi_codi;
    
    end if;
 
  end loop;
end;

/*
  /**********************************************************************/
  /***********************    INSERCIONES  ******************************/
  /**********************************************************************/

  procedure pp_insert_item(i_moco_impo_mone_ii        in number,
                           i_movi_tasa_mone           in number,
                           i_movi_mone_cant_deci      in number,
                           i_moco_impu_porc           in number,
                           i_moco_impu_porc_base_impo in number,
                           i_moco_impu_indi_baim_impu in varchar2,
                           i_moco_conc_codi           in number,
                           i_moco_impu_codi           in number,
                           i_movi_dbcr                in varchar2,
                           i_indi                     in varchar2,
                           i_moco_tiim_codi           in number,
                           i_seq                      in number) is
  
    v_moco_impo_mmnn_ii   number := 0;
    v_moco_impo_mone_ii   number := 0;
    v_moco_grav10_ii_mone number := 0;
    v_moco_grav5_ii_mone  number := 0;
    v_moco_grav10_mone    number := 0;
    v_moco_grav5_mone     number := 0;
    v_moco_iva10_mone     number := 0;
    v_moco_iva5_mone      number := 0;
    v_moco_Exen_mone      number := 0;
    v_moco_impo_mone      number;
  
    v_moco_grav10_ii_mmnn number := 0;
    v_moco_grav5_ii_mmnn  number := 0;
    v_moco_grav10_mmnn    number := 0;
    v_moco_grav5_mmnn     number := 0;
    v_moco_iva10_mmnn     number := 0;
    v_moco_iva5_mmnn      number := 0;
    v_moco_exen_mmnn      number := 0;
    v_moco_impo_mmnn      number;
  
    p_conc_desc           varchar2(500);
    p_conc_dbcr           varchar2(500);
    p_conc_indi_kilo_vehi varchar2(500);
    p_moco_indi_impo      varchar2(500);
    p_conc_indi_ortr      varchar2(500);
    p_conc_indi_gast_judi varchar2(500);
    p_conc_indi_cent_cost varchar2(500);
    p_conc_indi_acti_fijo varchar2(500);
    p_cuco_nume           varchar2(500);
    p_cuco_desc           varchar2(500);
    v_item_nro            number;
  
    v_moco_juri_codi number;
    v_juri_nume      number;
    v_moco_impo_codi number;
    v_moco_ceco_codi number;
    v_moco_emse_codi number;
    v_moco_ortr_codi number;
    v_moco_Tran_codi number;
    v_tran_codi_alte number;
  
  
  begin
  
    select nvl(max(taax_c038) + 1, 1)
      into v_item_nro
      from come_tabl_auxi
     where taax_sess = p_session
       and taax_user = p_usuario;
  
    begin
      -- Call the procedure
      I020009.pp_muestra_come_conc(p_conc_codi           => i_moco_conc_codi,
                                   i_movi_sucu_codi_orig => p_sucu_codi,
                                   i_movi_dbcr           => i_movi_dbcr,
                                   p_conc_desc           => p_conc_desc,
                                   p_conc_dbcr           => p_conc_dbcr,
                                   p_conc_indi_kilo_vehi => p_conc_indi_kilo_vehi,
                                   p_moco_indi_impo      => p_moco_indi_impo,
                                   p_conc_indi_ortr      => p_conc_indi_ortr,
                                   p_conc_indi_gast_judi => p_conc_indi_gast_judi,
                                   p_conc_indi_cent_cost => p_conc_indi_cent_cost,
                                   p_conc_indi_acti_fijo => p_conc_indi_acti_fijo,
                                   p_cuco_nume           => p_cuco_nume,
                                   p_cuco_desc           => p_cuco_desc);
    end;
  
    v_moco_impo_mmnn_ii := round((i_moco_impo_mone_ii * i_movi_tasa_mone),
                                 p_cant_Deci_mmnn);
  
    pa_devu_impo_calc(i_moco_impo_mone_ii,
                      i_movi_mone_cant_deci,
                      i_moco_impu_porc,
                      i_moco_impu_porc_base_impo,
                      i_moco_impu_indi_baim_impu,
                      --
                      v_moco_impo_mone_ii,
                      v_moco_grav10_ii_mone,
                      v_moco_grav5_ii_mone,
                      v_moco_grav10_mone,
                      v_moco_grav5_mone,
                      v_moco_iva10_mone,
                      v_moco_iva5_mone,
                      v_moco_Exen_mone);
  
    pa_devu_impo_calc(v_moco_impo_mmnn_ii,
                      p_cant_deci_mmnn,
                      i_moco_impu_porc,
                      i_moco_impu_porc_base_impo,
                      i_moco_impu_indi_baim_impu,
                      --
                      v_moco_impo_mmnn_ii,
                      v_moco_grav10_ii_mmnn,
                      v_moco_grav5_ii_mmnn,
                      v_moco_grav10_mmnn,
                      v_moco_grav5_mmnn,
                      v_moco_iva10_mmnn,
                      v_moco_iva5_mmnn,
                      v_moco_exen_mmnn);
  
    v_moco_impo_mmnn := v_moco_exen_mmnn + v_moco_grav10_mmnn +
                        v_moco_grav5_mmnn;
    v_moco_impo_mone := v_moco_exen_mone + v_moco_grav10_mone +
                        v_moco_grav5_mone;
  
   if i_indi = 'A' then  
       
        select moco_juri_codi,
             juri_nume,
             moco_impo_codi,
             moco_ceco_codi,
             moco_emse_codi,
             moco_ortr_codi,
             moco_Tran_codi,
             tran_codi_alte
      /*moco_conc_codi,
      moco_impu_codi,
      moco_tiim_codi,
      moco_nume_item,
      moco_impo_mone_ii,
      moco_desc,
      moco_impo_codi,
      moco_juri_codi,
      moco_orse_codi,
      moco_osli_codi,
      osli_nume_liqu,
      moco_ortr_codi,
      moco_ceco_codi,
      moco_tran_codi,
      moco_emse_codi,
      moco_sucu_codi,           
      impo_nume,
      ortr_nume,
      orse_nume_char,
      tran_codi_alte,
      ceco_nume,
      emse_codi_alte,
      juri_nume*/
        into v_moco_juri_codi,
             v_juri_nume,
             v_moco_impo_codi,
             v_moco_ceco_codi,
             v_moco_emse_codi,
             v_moco_ortr_codi,
             v_moco_Tran_codi,
             v_tran_codi_alte
        from come_movi_conc_deta,
             come_orde_trab,
             come_impo,
             come_empr_secc,
             come_cent_cost,
             come_tran,
             come_clie_juri,
             (select osli_codi, osli_nume_liqu, orse_nume_char
                from come_orde_serv, come_orde_serv_liqu_deta
               where orse_codi = osli_orse_codi) osli
       where moco_ortr_codi = ortr_codi(+)
         and moco_impo_codi = impo_codi(+)
         and moco_emse_codi = emse_codi(+)
         and moco_Ceco_codi = ceco_codi(+)
         and moco_tran_codi = tran_codi(+)
         and moco_juri_codi = juri_codi(+)
         and moco_osli_codi = osli.osli_codi(+)
         and moco_movi_codi = i_seq -- usamos este como movi_codi whatever
         and moco_conc_codi not in
             (select impu_conc_codi_ivcr
                from come_impu
               where impu_conc_codi_ivcr is not null
              union
              select impu_conc_codi_ivdb
                from come_impu
               where impu_conc_codi_ivdb is not null);
   
   
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
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
         taax_c032,
         taax_c033,
         taax_c034,
         taax_c035,
         taax_c036,
         taax_c037,
         taax_c038,
         taax_c039,
         taax_c040,
         taax_c041,
         taax_c042,
         
         taax_c043,
         taax_c044,
         taax_c045,
         taax_c046,
         taax_c047,
         taax_c048,
         taax_c049,
         
         taax_c050)
      values
        (p_session,
         p_usuario,
         seq_come_tabl_auxi.nextval,
         i_moco_conc_codi,
         p_conc_desc,
         p_conc_dbcr,
         p_conc_indi_kilo_vehi,
         p_moco_indi_impo,
         p_conc_indi_ortr,
         p_conc_indi_gast_judi,
         p_conc_indi_cent_cost,
         p_conc_indi_acti_fijo,
         p_cuco_nume,
         p_cuco_desc,
         i_moco_impo_mone_ii,
         i_movi_tasa_mone,
         i_movi_mone_cant_deci,
         i_moco_impu_porc,
         i_moco_impu_porc_base_impo,
         i_moco_impu_indi_baim_impu,
         p_sucu_codi,
         'N',
         v_moco_impo_mmnn_ii,
         v_moco_impo_mone_ii,
         v_moco_grav10_ii_mone,
         v_moco_grav5_ii_mone,
         v_moco_grav10_mone,
         v_moco_grav5_mone,
         v_moco_iva10_mone,
         v_moco_iva5_mone,
         v_moco_Exen_mone,
         
         v_moco_grav10_ii_mmnn,
         v_moco_grav5_ii_mmnn,
         v_moco_grav10_mmnn,
         v_moco_grav5_mmnn,
         v_moco_iva10_mmnn,
         v_moco_iva5_mmnn,
         v_moco_exen_mmnn,
         v_moco_impo_mmnn,
         v_moco_impo_mone,
         v_item_nro,
         (select impu_desc from come_impu where impu_codi = i_moco_impu_codi),
         i_moco_impu_codi,
         i_moco_tiim_codi,
         (select tiim_desc
            from come_tipo_impu
           where tiim_codi = i_moco_tiim_codi),
          
         v_moco_juri_codi,
         v_juri_nume,
         v_moco_impo_codi,
         v_moco_ceco_codi,
         v_moco_emse_codi,
         v_moco_ortr_codi,
         v_moco_Tran_codi,
           
         'DETALLES');
    
    
   elsif i_indi = 'I' then
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
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
         taax_c032,
         taax_c033,
         taax_c034,
         taax_c035,
         taax_c036,
         taax_c037,
         taax_c038,
         taax_c039,
         taax_c040,
         taax_c041,
         taax_c042,
         taax_c050)
      values
        (p_session,
         p_usuario,
         seq_come_tabl_auxi.nextval,
         i_moco_conc_codi,
         p_conc_desc,
         p_conc_dbcr,
         p_conc_indi_kilo_vehi,
         p_moco_indi_impo,
         p_conc_indi_ortr,
         p_conc_indi_gast_judi,
         p_conc_indi_cent_cost,
         p_conc_indi_acti_fijo,
         p_cuco_nume,
         p_cuco_desc,
         i_moco_impo_mone_ii,
         i_movi_tasa_mone,
         i_movi_mone_cant_deci,
         i_moco_impu_porc,
         i_moco_impu_porc_base_impo,
         i_moco_impu_indi_baim_impu,
         p_sucu_codi,
         'N',
         v_moco_impo_mmnn_ii,
         v_moco_impo_mone_ii,
         v_moco_grav10_ii_mone,
         v_moco_grav5_ii_mone,
         v_moco_grav10_mone,
         v_moco_grav5_mone,
         v_moco_iva10_mone,
         v_moco_iva5_mone,
         v_moco_Exen_mone,
         
         v_moco_grav10_ii_mmnn,
         v_moco_grav5_ii_mmnn,
         v_moco_grav10_mmnn,
         v_moco_grav5_mmnn,
         v_moco_iva10_mmnn,
         v_moco_iva5_mmnn,
         v_moco_exen_mmnn,
         v_moco_impo_mmnn,
         v_moco_impo_mone,
         v_item_nro,
         (select impu_desc from come_impu where impu_codi = i_moco_impu_codi),
         i_moco_impu_codi,
         i_moco_tiim_codi,
         (select tiim_desc
            from come_tipo_impu
           where tiim_codi = i_moco_tiim_codi),
         'DETALLES');
    
    elsif i_indi = 'U' then
    
      update come_tabl_auxi
         set taax_c001 = i_moco_conc_codi,
             taax_c002 = p_conc_desc,
             taax_c003 = p_conc_dbcr,
             taax_c004 = p_conc_indi_kilo_vehi,
             taax_c005 = p_moco_indi_impo,
             taax_c006 = p_conc_indi_ortr,
             taax_c007 = p_conc_indi_gast_judi,
             taax_c008 = p_conc_indi_cent_cost,
             taax_c009 = p_conc_indi_acti_fijo,
             taax_c010 = p_cuco_nume,
             taax_c011 = p_cuco_desc,
             taax_c012 = i_moco_impo_mone_ii,
             taax_c013 = i_movi_tasa_mone,
             taax_c014 = i_movi_mone_cant_deci,
             taax_c015 = i_moco_impu_porc,
             taax_c016 = i_moco_impu_porc_base_impo,
             taax_c017 = i_moco_impu_indi_baim_impu,
             taax_c018 = p_sucu_codi,
             taax_c019 = 'S',
             taax_c020 = v_moco_impo_mmnn_ii,
             taax_c021 = v_moco_impo_mone_ii,
             taax_c022 = v_moco_grav10_ii_mone,
             taax_c023 = v_moco_grav5_ii_mone,
             taax_c024 = v_moco_grav10_mone,
             taax_c025 = v_moco_grav5_mone,
             taax_c026 = v_moco_iva10_mone,
             taax_c027 = v_moco_iva5_mone,
             taax_c028 = v_moco_Exen_mone
       where taax_seq = i_seq;
    
    end if;
  
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
                                p_movi_fech_oper           in date,
                                p_movi_fech_venc_timb      in date,
                                p_movi_codi_rete           in number,
                                p_movi_excl_cont           in varchar2,
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
                                p_movi_clpr_sucu_nume_item in number,
                                p_movi_indi_apli_tick      in varchar2,
                                
                                P_MOVI_TICL_CODI         in number,
                                P_MOVI_RE90_CODI         in number,
                                P_MOVI_RE90_TIPO         in number,
                                P_MOVI_INDI_IMPU_IRE     in varchar2,
                                P_MOVI_INDI_IMPU_IRP_RSP in varchar2,
                                P_MOVI_INDI_NO_IMPU      in varchar2,
                                P_MOVI_INDI_IMPU_IVA     in varchar2) is
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
       movi_clpr_sucu_nume_item,
       movi_indi_apli_tick,
       MOVI_TICL_CODI,
       MOVI_RE90_CODI,
       MOVI_RE90_TIPO,
       MOVI_INDI_IMPU_IRE,
       MOVI_INDI_IMPU_IRP_RSP,
       MOVI_INDI_NO_IMPU,
       MOVI_INDI_IMPU_IVA)
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
       p_codi_base,
       p_movi_nume_timb,
       p_movi_fech_oper,
       p_movi_fech_venc_timb,
       p_movi_codi_rete,
       p_movi_excl_cont,
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
       p_movi_clpr_sucu_nume_item,
       p_movi_indi_apli_tick,
       P_MOVI_TICL_CODI,
       P_MOVI_RE90_CODI,
       P_MOVI_RE90_TIPO,
       P_MOVI_INDI_IMPU_IRE,
       P_MOVI_INDI_IMPU_IRP_RSP,
       P_MOVI_INDI_NO_IMPU,
       P_MOVI_INDI_IMPU_IVA);
  
  end;

  procedure pp_insert_come_movi_cuot(p_cuot_fech_venc in date,
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
       cuot_movi_codi,
       cuot_base)
    
    values
      (p_cuot_fech_venc,
       p_cuot_nume,
       p_cuot_impo_mone,
       p_cuot_impo_mmnn,
       p_cuot_impo_mmee,
       p_cuot_sald_mone,
       p_cuot_sald_mmnn,
       p_cuot_sald_mmee,
       p_cuot_movi_codi,
       p_codi_base);
  
  end;
  procedure pp_insert_movi_conc_deta(p_moco_movi_codi      in number,
                                     p_moco_nume_item      in number,
                                     p_moco_conc_codi      in number,
                                     p_moco_cuco_codi      in number,
                                     p_moco_impu_codi      in number,
                                     p_moco_impo_mmnn      in number,
                                     p_moco_impo_mmee      in number,
                                     p_moco_impo_mone      in number,
                                     p_moco_dbcr           in varchar,
                                     p_moco_base           in number,
                                     p_moco_desc           in varchar2,
                                     p_moco_tiim_codi      in number,
                                     p_moco_indi_fact_serv in varchar2,
                                     p_moco_impo_mone_ii   in number,
                                     p_moco_ortr_codi      in number,
                                     p_moco_impo_codi      in number,
                                     p_moco_cant           in number,
                                     p_moco_cant_pulg      in number,
                                     p_moco_movi_codi_padr in number,
                                     p_moco_nume_item_padr in number,
                                     p_moco_ceco_codi      in number,
                                     p_moco_orse_codi      in number,
                                     p_moco_osli_codi      in number,
                                     p_moco_tran_codi      in number,
                                     p_moco_bien_codi      in number,
                                     p_moco_emse_codi      in number,
                                     p_moco_impo_mmnn_ii   in number,
                                     p_moco_sofa_sose_codi in number,
                                     p_moco_sofa_nume_item in number,
                                     p_moco_tipo_item      in varchar2,
                                     p_moco_clpr_codi      in number,
                                     p_moco_prod_nume_item in number,
                                     p_moco_guia_nume      in number,
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
                                     p_moco_conc_codi_impu in number,
                                     p_moco_tipo           in varchar2,
                                     p_moco_prod_codi      in number,
                                     p_moco_ortr_codi_fact in number,
                                     p_moco_iva10_mmnn     in number,
                                     p_moco_iva5_mmnn      in number,
                                     p_moco_exen_mone      in number,
                                     p_moco_exen_mmnn      in number,
                                     p_moco_empl_codi      in number,
                                     p_moco_lote_codi      in number,
                                     p_moco_bene_codi      in number,
                                     p_moco_medi_codi      in number,
                                     p_moco_cant_medi      in number,
                                     p_moco_anex_codi      in number,
                                     p_moco_indi_excl_cont in varchar,
                                     p_moco_anex_nume_item in number,
                                     p_moco_juri_codi      in number,
                                     p_MOCO_INDI_ORSE_ADM  in varchar2,
                                     p_moco_sucu_codi      in number,
                                     p_fech_emis           in date,
                                     p_moco_porc_dist      in number,
                                     p_moco_gatr_codi      in number) is
  
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
       moco_base,
       moco_desc,
       moco_tiim_codi,
       moco_indi_fact_serv,
       moco_impo_mone_ii,
       moco_ortr_codi,
       moco_impo_codi,
       moco_cant,
       moco_cant_pulg,
       moco_movi_codi_padr,
       moco_nume_item_padr,
       moco_ceco_codi,
       moco_orse_codi,
       moco_osli_codi,
       moco_tran_codi,
       moco_bien_codi,
       moco_emse_codi,
       moco_impo_mmnn_ii,
       moco_sofa_sose_codi,
       moco_sofa_nume_item,
       moco_tipo_item,
       moco_clpr_codi,
       moco_prod_nume_item,
       moco_guia_nume,
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
       moco_conc_codi_impu,
       moco_tipo,
       moco_prod_codi,
       moco_ortr_codi_fact,
       moco_iva10_mmnn,
       moco_iva5_mmnn,
       moco_exen_mone,
       moco_exen_mmnn,
       moco_empl_codi,
       moco_lote_codi,
       moco_bene_codi,
       moco_medi_codi,
       moco_cant_medi,
       moco_anex_codi,
       moco_indi_excl_cont,
       moco_anex_nume_item,
       moco_juri_codi,
       MOCO_INDI_ORSE_ADM,
       moco_sucu_codi,
       moco_fech_emis,
       moco_porc_dist,
       moco_gatr_codi)
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
       p_moco_base,
       p_moco_desc,
       p_moco_tiim_codi,
       p_moco_indi_fact_serv,
       p_moco_impo_mone_ii,
       p_moco_ortr_codi,
       p_moco_impo_codi,
       p_moco_cant,
       p_moco_cant_pulg,
       p_moco_movi_codi_padr,
       p_moco_nume_item_padr,
       p_moco_ceco_codi,
       p_moco_orse_codi,
       p_moco_osli_codi,
       p_moco_tran_codi,
       p_moco_bien_codi,
       p_moco_emse_codi,
       p_moco_impo_mmnn_ii,
       p_moco_sofa_sose_codi,
       p_moco_sofa_nume_item,
       p_moco_tipo_item,
       p_moco_clpr_codi,
       p_moco_prod_nume_item,
       p_moco_guia_nume,
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
       p_moco_conc_codi_impu,
       p_moco_tipo,
       p_moco_prod_codi,
       p_moco_ortr_codi_fact,
       p_moco_iva10_mmnn,
       p_moco_iva5_mmnn,
       p_moco_exen_mone,
       p_moco_exen_mmnn,
       p_moco_empl_codi,
       p_moco_lote_codi,
       p_moco_bene_codi,
       p_moco_medi_codi,
       p_moco_cant_medi,
       p_moco_anex_codi,
       p_moco_indi_excl_cont,
       p_moco_anex_nume_item,
       p_moco_juri_codi,
       p_MOCO_INDI_ORSE_ADM,
       p_moco_sucu_codi,
       p_fech_emis,
       p_moco_porc_dist,
       p_moco_gatr_codi);
  
  end;

  procedure pp_insert_come_movi_impu_deta(p_moim_impu_codi      in number,
                                          p_moim_movi_codi      in number,
                                          p_moim_impo_mmnn      in number,
                                          p_moim_impo_mmee      in number,
                                          p_moim_impu_mmnn      in number,
                                          p_moim_impu_mmee      in number,
                                          p_moim_impo_mone      in number,
                                          p_moim_impu_mone      in number,
                                          p_moim_base           in number,
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
       moim_base,
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
       p_moim_base,
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
  
  end;

/**********************************************************************/
/**************************  REPORTES  ********************************/
/**********************************************************************/

 procedure pp_reporte(i_movi_codi      in number,
                      i_movi_timo_codi in number) is 
   
 
  p_where     varchar2(2000);
  v_sql       varchar2(32000);
   
  v_cant_regi number := 0;
  v_para      varchar2(500);
  v_cont      varchar2(500);
  v_repo      varchar2(500);
  p_titulo    varchar2(500);
      
    
   begin
     
  p_where  := 'and m.movi_codi = '||i_movi_codi;
   
  if i_movi_timo_codi = p_codi_timo_fcor then
    p_titulo := 'FACTURA CONTADO RECIBIDA';       
  elsif i_movi_timo_codi in (p_codi_timo_auto_fact_emit, p_codi_timo_auto_fact_emit_cr) then
    p_titulo :=  'AUTOFACTURA EMITIDA';          
  end if;
      
 delete from come_tabl_auxi where taax_sess = p_session and taax_c050 = 'REPORTE';
 
   v_sql := '
   
insert into come_tabl_auxi
  (taax_sess,
   taax_user,
   taax_seq,
   taax_c001,
   taax_c002,
   taax_c003,
   taax_c004,
   taax_c005,
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
   taax_c032,
   taax_c033,
   taax_c034,
   taax_c035,
   taax_c036,
   taax_c037,
   taax_c038,
   taax_c039,
   taax_c040,
   taax_c050) 

  select '''||p_session||''',
         '''||p_usuario||''',
         seq_come_tabl_auxi.nextval,
         movi_codi,
         movi_nume,
         movi_fech_emis,
         movi_obse,
         oper_codi,
         oper_desc,
         sucu_codi_1,
         sucu_desc_1,
         depo_codi,
         depo_desc,
         timo_codi,
         timo_desc,
         empr_codi,
         empr_desc,
         mone_codi,
         mone_desc,
         mone_cant_deci,
         cuen_codi,
         cuen_desc,
         clpr_codi,
         clpr_desc,
         clpr_label,
         Exen_mone,
         Grav10_mone,
         Grav5_mone,
         Iva10_mone,
         Iva5_mone,
         tot_iva,
         tot_mone,
         moco_nume_item,
         moco_impo_mone,
         moco_dbcr,
         conc_codi,
         conc_desc,
         impu_codi,
         impu_desc,
         sucu_codi,
         sucu_desc,
         moco_fech_emis,
         titulo,
         descr
    from (select   
          m.movi_codi,
          (substr(lpad(to_char(m.movi_nume), 13, ''0''), 1,3)||
          ''-''||
          substr(lpad(to_char(m.movi_nume), 13, ''0''), 4,3)||
          ''-''||
          substr(lpad(to_char(m.movi_nume), 13, ''0''), 7,8)) movi_nume,   
          m.movi_fech_emis, 
          m.movi_obse,          
          o.oper_codi, 
          o.oper_desc, 
          so.sucu_codi sucu_codi_1,
          so.sucu_desc sucu_desc_1,
          do.depo_codi depo_codi,
          do.depo_desc depo_desc,
          t.timo_codi,
          t.timo_desc ,
          e.empr_codi,
          e.empr_desc,
          o.mone_codi,
          o.mone_desc,
          o.mone_cant_deci,
          cb.cuen_codi,
          cb.cuen_desc,
          cp.clpr_codi_alte clpr_codi,
          cp.clpr_desc,
          decode(cp.clpr_indi_clie_prov, ''C'', ''Cliente'', ''P'', ''Proveedor'', null) clpr_label,
          sum(decode(ip.moim_impu_codi, 1, ip.moim_impo_mone,0)) Exen_mone,
          sum(decode(ip.moim_impu_codi, 2, ip.moim_impo_mone,0)) Grav10_mone,
          sum(decode(ip.moim_impu_codi, 3, ip.moim_impo_mone,0)) Grav5_mone,
          sum(decode(ip.moim_impu_codi, 2, ip.moim_impu_mone,0)) Iva10_mone,
          sum(decode(ip.moim_impu_codi, 3, ip.moim_impu_mone,0)) Iva5_mone,
          sum(ip.moim_impu_mone) tot_iva,
          sum(ip.moim_impu_mone+ip.moim_impo_mone) tot_mone,
          cd.moco_nume_item,
          cd.moco_impo_mone,
          cd.moco_dbcr,
          cc.conc_codi,
          cc.conc_desc,
          ci.impu_codi,
          ci.impu_desc,
          cs.sucu_codi,
          cs.sucu_desc,
          cd.moco_fech_emis,
          '''||p_titulo||''' titulo,
          ''REPORTE'' descr
    from come_movi m, 
         come_stoc_oper o, 
         come_sucu so,   
         come_tipo_movi t, 
         come_empr e, 
         come_mone o, 
         come_clie_prov cp, 
         come_movi_impu_deta ip, 
         come_cuen_banc cb, 
         come_depo do,
         --concepto
         come_movi           cm,
         come_movi_conc_deta cd,
         come_conc           cc,
         come_impu           ci,
         come_sucu           cs

    where m.movi_oper_codi       = o.oper_codi(+)
      and m.movi_sucu_codi_orig  = so.sucu_codi (+)
      and m.movi_timo_codi       = t.timo_codi
      and m.movi_depo_codi_orig  = do.depo_codi(+)
      and m.movi_empr_codi       = e.empr_codi(+)
      and m.movi_mone_codi       = o.mone_codi
      and m.movi_clpr_codi       = cp.clpr_codi
      and m.movi_cuen_codi       = cb.cuen_codi(+)
      and m.movi_codi            = ip.moim_movi_codi
      and m.movi_codi            =  cm.movi_codi
      and m.movi_codi =  '||i_movi_codi||'
      
      -- concepto
      and cm.movi_codi = cd.moco_movi_codi
      and cd.moco_conc_codi = cc.conc_codi
      and cd.moco_impu_codi = ci.impu_codi
      and cd.moco_sucu_codi = cs.sucu_codi(+) 
      -- cm.movi_codi =  14754601
      
group by m.movi_nume, 
          m.movi_fech_emis, 
          m.movi_obse,
          o.oper_codi, 
          o.oper_desc, 
          so.sucu_codi ,
          so.sucu_desc ,
          do.depo_codi ,
          do.depo_desc ,          
          t.timo_codi,
          t.timo_desc,
          e.empr_codi,
          e.empr_desc,
          o.mone_codi,
          o.mone_desc,
          o.mone_cant_deci,
          cb.cuen_codi,
          cb.cuen_desc,
          cp.clpr_codi_alte,
          cp.clpr_desc,
          m.movi_codi,
          decode(cp.clpr_indi_clie_prov, ''C'', ''Cliente'', ''P'', ''Proveedor'', null),
          cd.moco_nume_item,
          cd.moco_impo_mone,
          cd.moco_dbcr,
          cc.conc_codi,
          cc.conc_desc,
          ci.impu_codi,
          ci.impu_desc,
          cs.sucu_codi,
          cs.sucu_desc,
          cd.moco_fech_emis)';
   --insert into come_concat (campo1, otro) values (v_sql, 'se acerca el fin'); commit;
   execute immediate v_sql;
   
  v_cont := 'p_app_session:p_app_user';
  v_para := p_session || ':' || gen_user;
  v_repo := 'I020009';
  
    delete from come_parametros_report where usuario = gen_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_para, gen_user, v_repo, 'pdf', v_cont);
  
    commit;


   end pp_reporte;

  procedure pp_reporte_Orden_pago(i_movi_codi      in number) is 
   
  v_sql       varchar2(32000);
   
  v_cant_regi number := 0;
  v_para      varchar2(500);
  v_cont      varchar2(500);
  v_repo      varchar2(500);
  p_titulo    varchar2(500);
      
    
   begin
     

      
 delete from come_tabl_auxi where taax_sess = p_session and taax_c050 = 'REPORTE';
 
   v_sql := '
   
insert into come_tabl_auxi
  (taax_sess,
   taax_user,
   taax_seq,
   taax_c001,
   taax_c002,
   taax_c003,
   taax_c004,
   taax_c005,
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
   taax_c050) 
  select 
      '''||p_session||''',
       '''||p_usuario||''',
       seq_come_tabl_auxi.nextval,
       movi_timo_codi,
       empr_desc,
       sucu_Desc,
       numero,
       clpr_desc,
       movi_fech_emis,
       movi_nume,
       clpr_ruc,
       movi_obse,
       fac_movi_codi,
       fac_movi_fech,
       deta_impo_mone,
       deta_rete_iva_mone,
       conc_codi,
       conc_desc,
       ''REPORTE''
from(select m.movi_timo_codi,
       empr_desc,
       sucu_desc,
       m.movi_nume numero,
       clpr_desc,
       m.movi_fech_emis,
       m.movi_nume,
       clpr_ruc,
       movi_obse,
       deta.fac_movi_codi,
       deta.fac_movi_fech,
       deta.deta_impo_mone,
       deta.deta_rete_iva_mone,
       concepto.conc_codi, 
       concepto.conc_desc
  from come_clie_prov,
       come_movi m,
       come_empr,
       come_sucu,
       --reci_op
       (select m.movi_codi fac_movi_codi,
               m.movi_nume fac_movi_nume,
               m.movi_fech_emis fac_movi_fech,
               m.movi_exen_mone + m.movi_grav_mone + m.movi_iva_mone deta_impo_mone,
               nvl(c.movi_exen_mone, 0) + nvl(c.movi_grav_mone, 0) +
               nvl(c.movi_iva_mone, 0) deta_rete_iva_mone
          from come_movi m, come_movi c
         where m.movi_codi = c.movi_codi_padr(+)
           and m.movi_codi = '||i_movi_codi||') deta,
       --concepto
       (select conc.conc_codi, conc.conc_desc, m.movi_codi 
          from come_movi m, come_movi_conc_deta mconc, come_conc conc
         where m.movi_codi = mconc.moco_movi_codi
           and conc.conc_codi = mconc.moco_conc_codi
           and conc.conc_codi not in
               (select conc_iva
                  from (select impu_conc_codi_ivdb conc_iva
                          from come_impu
                        union
                        select impu_conc_codi_ivcr
                          from come_impu)
                 where conc_iva is not null)
           and movi_codi = '||i_movi_codi||') concepto

 where m.movi_clpr_codi = clpr_codi
   and m.movi_empr_codi = empr_codi
   and sucu_empr_codi = empr_codi
   and m.movi_sucu_codi_orig = sucu_codi
   and deta.fac_movi_codi = m.movi_codi
   and concepto.movi_codi = m.movi_codi
   and m.movi_codi = '||i_movi_codi||')';
   
   insert into come_concat (campo1, otro) values (v_sql, 'k kreizi'); commit;
   execute immediate v_sql;
   
  v_cont := 'p_app_session:p_app_user';
  v_para := p_session || ':' || gen_user;
  v_repo := 'I020089contado_alar';
  
    delete from come_parametros_report where usuario = gen_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_para, gen_user, v_repo, 'pdf', v_cont);
  
    commit;


   end pp_reporte_Orden_pago;


end I020009;
