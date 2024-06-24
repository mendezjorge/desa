
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020273_A" is
  v_leng number := 0;
  procedure pp_iniciar is
  
    v_user_indi_modi_dato_ot_fini  varchar2(100);
    v_user_indi_modi_dato_vehi     varchar2(100);
    v_p_user_indi_gene_pre_anex_ot varchar2(100);
  begin
  
    setitem('P53_HAB_BOTON', 'H');
    setitem('P53_VALIDA_CAMPO', 'S');
  
    --if :parameter.p_codi is not null then
    --  :parameter.p_ortr_codi := :parameter.p_codi;
    --- end if;
  
    select nvl(user_indi_modi_dato_ot_fini, 'N'),
           nvl(user_indi_modi_dato_vehi, 'N'),
           nvl(user_indi_gene_pre_anex_ot, 'N')
      into v_user_indi_modi_dato_ot_fini,
           v_user_indi_modi_dato_vehi,
           v_p_user_indi_gene_pre_anex_ot
      from segu_user
     where user_login = fp_user;
  
    setitem('P53_USER_INDI_MODI_DATO_OT_FINI',
            v_user_indi_modi_dato_ot_fini);
    setitem('P53_USER_INDI_MODI_DATO_VEHI', v_user_indi_modi_dato_vehi);
    setitem('P53_P_USER_INDI_GENE_PRE_ANEX_OT',
            v_p_user_indi_gene_pre_anex_ot);
  
    /*set_item_property('bcab.s_faau_nume'     , visible, property_false);
    set_item_property('bcab.s_movi_nume'     , visible, property_false);
    set_item_property('bcab.s_movi_fech_emis', visible, property_false);
    */
  
    if v('P53_ORTR_CODI') is not null then
      setitem('P53_P_INDI_CONS', 'S');
    
    end if;
  
  end pp_iniciar;

  function fp_get_last_lote_disp(i_ortr_codi in number,
                                 i_vehi_codi in number) return number is
    v_return number;
  begin
    select orden_padre
      into v_return
      from (select a.*,
                   lag(i020273_a.fp_get_code_from_desc_lote(i_desc => vehi_equi_imei)) over(partition by vehi_codi order by ultimo) orden_padre
              from (select v1.vehi_ortr_codi,
                           v1.vehi_codi,
                           v1.vehi_secu,
                           v1.vehi_equi_imei,
                           max(v1.vehi_secu) over(partition by vehi_codi, v1.vehi_ortr_codi) ultimo
                      from come_vehi_hist v1
                     where v1.vehi_ortr_codi is not null) a
             where vehi_secu = ultimo)
     where vehi_codi = i_vehi_codi
       and vehi_ortr_codi = i_ortr_codi;
    return v_return;
  exception
    when no_data_found then
      return null;
  end fp_get_last_lote_disp;

  function fp_get_last_change_disp(i_ortr_codi in number,
                                   i_vehi_codi in number) return number is
    v_return number;
  begin
    select orden_padre
      into v_return
      from (select a.*,
                   lag(vehi_ortr_codi) over(partition by vehi_codi order by ultimo) orden_padre
              from (select v1.vehi_ortr_codi,
                           v1.vehi_codi,
                           v1.vehi_secu,
                           v1.vehi_equi_imei,
                           max(v1.vehi_secu) over(partition by vehi_codi, v1.vehi_ortr_codi) ultimo
                      from come_vehi_hist v1
                     where v1.vehi_ortr_codi is not null) a
             where vehi_secu = ultimo)
     where vehi_codi = i_vehi_codi
       and vehi_ortr_codi = i_ortr_codi;
    return v_return;
  exception
    when no_data_found then
      return null;
  end fp_get_last_change_disp;

  procedure pp_generar_saldev_producto is
  
    v_ind_salida     varchar2(5);
    v_ind_devolucion varchar2(5);
    v_ortr           come_orde_trab%rowtype;
    v_ortr_codi      number;
    v_lote_salida    number;
    v_lote_entrada   number;
    v_ultimo_lote    number;
  begin
  
    v_ortr.ortr_clpr_codi   := v('P53_ORTR_CLPR_CODI');
    v_ortr.ortr_codi        := v('P53_ORTR_CODI');
    v_ortr.ortr_codi_padr   := v('P53_ORTR_CODI_PADR');
    v_ortr.ortr_empl_codi   := v('P53_VEHI_EMPL_CODI');
    v_ortr.ortr_form_insu   := v('P53_ORTR_FORM_INSU');
    v_ortr.ortr_lote_equipo := v('P53_VEHI_LOTE_RASTREO');
    v_ortr.ortr_nume        := v('P53_ORTR_NUME');
    v_ortr.ortr_serv_obse   := v('P53_ORTR_SERV_OBSE');
    v_ortr.ortr_serv_tipo   := v('P53_ORTR_SERV_TIPO');
    v_ortr.ortr_vehi_codi   := v('P53_ORTR_VEHI_CODI');
    v_ortr_codi             := v_ortr.ortr_codi;
  
    if v_ortr.ortr_serv_tipo in ('I', 'RI') then
      v_ind_salida  := 'S';
      v_lote_salida := v_ortr.ortr_lote_equipo;
    end if;
  
    if v_ortr.ortr_serv_tipo = 'D' then
      v_ortr_codi := fp_get_last_change_disp(i_ortr_codi => v_ortr.ortr_codi,
                                             i_vehi_codi => v_ortr.ortr_vehi_codi);
    
      if v_ortr_codi is not null then
        v_ortr.ortr_codi_padr := v_ortr_codi;
      end if;
    
      v_lote_entrada := v_ortr.ortr_lote_equipo;
    
      v_ind_salida     := 'N';
      v_ind_devolucion := 'S';
    end if;
  
    if v_ortr.ortr_serv_tipo = 'V' then
      if fp_ind_camb_disp_ortr(i_ortr_codi => v_ortr.ortr_codi,
                               i_vehi_codi => v_ortr.ortr_vehi_codi) then
      
        v_ortr_codi := fp_get_last_change_disp(i_ortr_codi => v_ortr.ortr_codi,
                                               i_vehi_codi => v_ortr.ortr_vehi_codi);
      
        v_ultimo_lote := fp_get_last_lote_disp(i_ortr_codi => v_ortr.ortr_codi,
                                               i_vehi_codi => v_ortr.ortr_vehi_codi);
      
        if v_ortr_codi is not null then
          v_ortr.ortr_codi_padr := v_ortr_codi;
        end if;
        --v_ortr.ortr_lote_equipo:= 
        v_ind_salida     := 'S';
        v_ind_devolucion := 'S';
      
        v_lote_salida  := v_ortr.ortr_lote_equipo;
        v_lote_entrada := v_ultimo_lote;
      
        --para que la salida de material se relacione siempre con la instalacion
      else
        ---** mientras cargamos los datos historicos
        v_ind_salida     := 'N';
        v_ind_devolucion := 'N';
      end if;
    end if;
  
    if v_ind_salida = 'S' then
      i020040.pp_generar_salida_producto(i_ortr_codi        => v_ortr.ortr_codi,
                                         i_ortr_serv_obse   => v_ortr.ortr_serv_obse,
                                         i_ortr_form_insu   => v_ortr.ortr_form_insu,
                                         i_ortr_empl_codi   => v_ortr.ortr_empl_codi,
                                         i_ortr_lote_equipo => v_lote_salida,
                                         i_ortr_clpr_codi   => v_ortr.ortr_clpr_codi,
                                         i_ortr_nume        => v_ortr.ortr_nume);
    end if;
  
    if v_ind_devolucion = 'S' then
      i020041.pp_generar_devolucion(i_vehi_codi      => v_ortr.ortr_vehi_codi,
                                    i_empl_codi      => v_ortr.ortr_empl_codi,
                                    i_ortr_codi_inst => v_ortr.ortr_codi_padr,
                                    i_ortr_codi_des  => v_ortr.ortr_codi,
                                    i_ortr_lote_codi => v_lote_entrada,
                                    i_ortr_clpr_codi => v_ortr.ortr_clpr_codi,
                                    i_ortr_nume      => v_ortr.ortr_nume);
    end if;
  end pp_generar_saldev_producto;

  procedure pp_cargar_parametros is
  begin
    -- :benca.version := :parameter.p_version;
    --  pa_devu_fech_habi(:parameter.p_fech_inic,:parameter.p_fech_fini );
  
    setitem('P53_P_IMPO_MONE_ANEX_REIN_VEHI',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_impo_mone_anex_rein_vehi'));
    setitem('P53_P_CONC_CODI_ANEX_REIN_VEHI',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_conc_codi_anex_rein_vehi'));
    setitem('P53_P_INDI_DURA_MINI_CONT',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_indi_dura_mini_cont'));
    setitem('P53_P_INDI_DESI_RENO_DURA_MINI',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_indi_desi_reno_dura_mini'));
    setitem('P53_P_INDI_DIAS_PRE_AVISO', 'N');
    --  general_skn.fl_busca_parametro(p_para_nomb => 'p_indi_dias_pre_aviso'));
    setitem('P53_P_INDI_DESI_CON_DURA_MINI',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_indi_desi_con_dura_mini'));
  
    setitem('P53_P_PECO_CODI', 1);
  
    -- :parameter.p_indi_desi_con_dura_mini      := ltrim(rtrim(fl_busca_parametro ('p_indi_desi_con_dura_mini')));
  
    -- :parameter.p_ind_clpr                     := 'c';
    --:parameter.p_codi_mone_mmee               := fl_busca_parametro('p_codi_mone_mmee');
    --:parameter.p_codi_clie_espo               := to_number(fl_busca_parametro ('p_codi_clie_espo'));
    -- :parameter.p_perm_dife_num_otpr           := ltrim(rtrim(fl_busca_parametro('p_perm_dife_num_otpr')));
    --:parameter.p_indi_vali_signo_nume_ortr    := ltrim(rtrim(fl_busca_parametro('p_indi_vali_signo_nume_ortr')));
  
    setitem('P53_P_INDI_MOST_CORT_CORR',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_indi_most_cort_corr'));
    setitem('P53_P_INDI_MOST_CLIE_VERI_VEHI',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_indi_most_clie_veri_vehi'));
    setitem('P53_P_INDI_MOST_GRAB_DIRE',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_indi_most_grab_dire'));
    setitem('P53_P_MOSTRAR_ORDE_TRAB_RESP',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_mostrar_orde_trab_resp'));
    setitem('P53_P_ORTR_AUTONUM',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_ortr_autonum'));
    setitem('P53_P_INDI_MOST_GRAB_OBSE',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_indi_most_grab_obse'));
    setitem('P53_P_CONC_CODI_SERV_MONI_ANUA',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_conc_codi_serv_moni_anua'));
    setitem('P53_P_CONC_CODI_SERV_MONI_MENS',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_conc_codi_serv_moni_mens'));
    setitem('P53_P_CONC_CODI_ANEX_GRUA_VEHI',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_conc_codi_anex_grua_vehi'));
  
    setitem('P53_P_CODI_TIPO_EMPL_TECN',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_codi_tipo_empl_tecn'));
    setitem('P53_P_CODI_BASE', pack_repl.fa_devu_codi_base);
    setitem('P53_P_CODI_MONE_MMNN',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_codi_mone_mmnn'));
    setitem('P53_P_INDI_CONS', 'N');
    setitem('P53_P_ORTR_AUTONUM',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_ortr_autonum'));
    --setitem('p53_p_indi_prov_ortr',general_skn.fl_busca_parametro(p_para_nomb => 'p_indi_prov_ortr'));
    setitem('P53_P_MOSTRAR_ORDE_TRAB_RESP',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_mostrar_orde_trab_resp'));
    setitem('P53_P_CODI_TIPO_EMPL_VEND',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_codi_tipo_empl_vend'));
    setitem('P53_P_CODI_CLAS1_CLIE_SUBCLIE',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_codi_clas1_clie_subclie'));
    setitem('P53_P_INDI_GENE_PLAN_LIQU_OT',
            general_skn.fl_busca_parametro(p_para_nomb => 'p_indi_gene_plan_liqu_ot'));
    --  setitem('p53_',general_skn.fl_busca_parametro(p_para_nomb => ''));
    -- setitem('p53_',general_skn.fl_busca_parametro(p_para_nomb => ''));
  
    --:parameter.p_form_impr_orde_trab          := to_number(fl_busca_parametro ('p_form_impr_orde_trab'));
    --:parameter.p_mostrar_orde_trab_herr       := ltrim(rtrim(fl_busca_parametro('p_mostrar_orde_trab_herr')));
    --:parameter.p_mostrar_orde_trab_mode       := ltrim(rtrim(fl_busca_parametro('p_mostrar_orde_trab_mode')));
    -- :parameter.p_mostrar_orde_trab_resp_tele  := ltrim(rtrim(fl_busca_parametro('p_mostrar_orde_trab_resp_tele')));
    -- :parameter.p_mostrar_orde_trab_herr       := ltrim(rtrim(fl_busca_parametro('p_mostrar_orde_trab_herr')));
    -- :parameter.p_mostrar_orde_trab_herr_marca := ltrim(rtrim(fl_busca_parametro('p_mostrar_orde_trab_herr_marca')));
    -- :parameter.p_codi_oper_prod_mas           := to_number(fl_busca_parametro ('p_codi_oper_prod_mas'));
    -- :parameter.p_codi_oper_prod_men           := to_number(fl_busca_parametro ('p_codi_oper_prod_men'));
    -- :parameter.p_cant_dias_para_liqu_ot       := to_number(fl_busca_parametro('p_cant_dias_para_liqu_ot'));
  
    -- :parameter.p_form_impr_ot                 := ltrim(rtrim(fl_busca_parametro('p_form_impr_ot')));
    -- :parameter.p_form_impr_ot_gara            := ltrim(rtrim(fl_busca_parametro('p_form_impr_ot_gara')));
  
    setitem('P53_ORTR_TIPO_COST_TRAN', 1);
    setitem('P53_P_EMPR_CODI', 1);
  
    if v('P53_ORTR_MONE_CODI_PREC') is null then
      setitem('P53_ORTR_MONE_CODI_PREC', v('P53_P_CODI_MONE_MMNN'));
    
    end if;
    begin
      i020273_a.pp_mostrar_moneda;
    end;
  
  end pp_cargar_parametros;

  procedure pp_buscar_orden is
  
    v_ortr_codi                varchar2(500);
    v_ortr_clpr_codi           varchar2(500);
    v_ortr_nume                varchar2(500);
    v_ortr_fech_emis           varchar2(500);
    v_ortr_esta                varchar2(500);
    v_ortr_desc                varchar2(500);
    v_ortr_desc_prob           varchar2(500);
    v_ortr_mone_codi_prec      varchar2(500);
    v_ortr_prec_vent           varchar2(500);
    v_ortr_tipo_cost_tran      varchar2(500);
    v_ortr_sose_codi           varchar2(500);
    v_ortr_empl_codi_vend      varchar2(500);
    v_ortr_serv_tipo           varchar2(500);
    v_ortr_serv_poli_nume      varchar2(500);
    v_ortr_serv_obse           varchar2(500);
    v_ortr_user_regi           varchar2(500);
    v_ortr_fech_regi           varchar2(500);
    v_ortr_user_modi           varchar2(500);
    v_ortr_fech_modi           varchar2(500);
    v_ortr_sode_codi           varchar2(500);
    v_ortr_vehi_codi           varchar2(500);
    v_ortr_fech_inst           varchar2(500);
    v_ortr_luga_inst           varchar2(500);
    v_ortr_anex_codi           varchar2(500);
    v_ortr_serv_tipo_moti      varchar2(500);
    v_ortr_vehi_iden           varchar2(500);
    v_ortr_deta_codi           varchar2(500);
    v_ortr_esta_pre_liqu       varchar2(500);
    v_ortr_indi_clie_veri_vehi varchar2(500);
    v_ortr_indi_rein_futu_gene varchar2(500);
    v_ortr_indi_cort_corr      varchar2(500);
    v_ortr_clpr_sucu_nume_item varchar2(500);
    v_ortr_fech_liqu           varchar2(500);
    v_ortr_codi_padr           varchar2(500);
  
    v_vehi_nume_item      varchar2(500);
    v_vehi_empl_codi      varchar2(500);
    v_vehi_pola           varchar2(500);
    v_vehi_leva_vidr_elec varchar2(500);
    v_vehi_retr_elec      varchar2(500);
    v_vehi_limp_para_dela varchar2(500);
    v_vehi_limp_para_tras varchar2(500);
    v_vehi_tanq           varchar2(500);
    v_vehi_dire_hidr      varchar2(500);
    v_vehi_auto_radi      varchar2(500);
    v_vehi_ante_elec      varchar2(500);
    v_vehi_aire_acon      varchar2(500);
    v_vehi_bloq_cent      varchar2(500);
    v_vehi_abag           varchar2(500);
    v_vehi_fabs           varchar2(500);
    v_vehi_tapi           varchar2(500);
    v_vehi_alar           varchar2(500);
    v_vehi_boci           varchar2(500);
    v_vehi_lava_faro      varchar2(500);
    v_vehi_llan           varchar2(500);
    v_vehi_cubi           varchar2(500);
    v_vehi_comb           varchar2(500);
    v_vehi_cent           varchar2(500);
    v_vehi_chap           varchar2(500);
    v_vehi_pint           varchar2(500);
    v_vehi_lalt           varchar2(500);
    v_vehi_lbaj           varchar2(500);
    v_vehi_lrev           varchar2(500);
    v_vehi_lgir           varchar2(500);
    v_vehi_lpos           varchar2(500);
    v_vehi_lint           varchar2(500);
    v_vehi_lsto           varchar2(500);
    v_vehi_lest           varchar2(500);
    v_vehi_ltab           varchar2(500);
    v_vehi_user_regi      varchar2(500);
    v_vehi_fech_regi      varchar2(500);
    v_vehi_user_modi      varchar2(500);
    v_vehi_fech_modi      varchar2(500);
    v_vehi_clve_clpr_codi varchar2(500);
    v_vehi_clve_nume_item varchar2(500);
  
    v_empl_desc           varchar2(500);
    v_empl_codi_alte      varchar2(500);
    v_ortr_deta_codi_veri number;
    v_ortr_exti           varchar2(500);
    v_ortr_form_insu      number;
  
    v_ortr_lote_equipo number;
  
  begin
  
    select ortr_codi,
           ortr_clpr_codi,
           ortr_nume,
           ortr_fech_emis,
           ortr_esta,
           ortr_desc,
           ortr_desc_prob,
           ortr_mone_codi_prec,
           ortr_prec_vent,
           ortr_tipo_cost_tran,
           ortr_sose_codi,
           ortr_empl_codi_vend,
           ortr_serv_tipo,
           ortr_serv_poli_nume,
           ortr_serv_obse,
           ortr_user_regi,
           ortr_fech_regi,
           ortr_user_modi,
           ortr_fech_modi,
           ortr_sode_codi,
           ortr_vehi_codi,
           ortr_fech_inst,
           ortr_luga_inst,
           ortr_anex_codi,
           ortr_serv_tipo_moti,
           ortr_vehi_iden,
           ortr_deta_codi,
           ortr_esta_pre_liqu,
           ortr_indi_clie_veri_vehi,
           ortr_indi_rein_futu_gene,
           ortr_indi_cort_corr,
           ortr_clpr_sucu_nume_item,
           ortr_fech_liqu,
           ortr_codi_padr,
           ortr_indi_hora_extr,
           ortr_form_insu,
           ortr_lote_equipo
      into v_ortr_codi,
           v_ortr_clpr_codi,
           v_ortr_nume,
           v_ortr_fech_emis,
           v_ortr_esta,
           v_ortr_desc,
           v_ortr_desc_prob,
           v_ortr_mone_codi_prec,
           v_ortr_prec_vent,
           v_ortr_tipo_cost_tran,
           v_ortr_sose_codi,
           v_ortr_empl_codi_vend,
           v_ortr_serv_tipo,
           v_ortr_serv_poli_nume,
           v_ortr_serv_obse,
           v_ortr_user_regi,
           v_ortr_fech_regi,
           v_ortr_user_modi,
           v_ortr_fech_modi,
           v_ortr_sode_codi,
           v_ortr_vehi_codi,
           v_ortr_fech_inst,
           v_ortr_luga_inst,
           v_ortr_anex_codi,
           v_ortr_serv_tipo_moti,
           v_ortr_vehi_iden,
           v_ortr_deta_codi,
           v_ortr_esta_pre_liqu,
           v_ortr_indi_clie_veri_vehi,
           v_ortr_indi_rein_futu_gene,
           v_ortr_indi_cort_corr,
           v_ortr_clpr_sucu_nume_item,
           v_ortr_fech_liqu,
           v_ortr_codi_padr,
           v_ortr_exti,
           v_ortr_form_insu,
           v_ortr_lote_equipo
      from come_orde_trab
     where ortr_nume = v('P53_ORTR_NUME');
  
    /*  if fp_user = 'skn' then
       raise_application_error(-20001,'adsf');
    end if;*/
    --raise_application_error(-20001, v_ortr_fech_regi);
    ---setitem('p53_clpr_codi_alte',v_ortr_clpr_codi);
    setitem('P53_P_INDI_CONS', 'S');
    setitem('P53_ORTR_CODI', v_ortr_codi);
    setitem('P53_ORTR_CLPR_CODI', v_ortr_clpr_codi);
    setitem('P53_ORTR_FECH_EMIS', v_ortr_fech_emis);
    setitem('P53_ORTR_ESTA', v_ortr_esta);
    setitem('P53_ORTR_DESC', v_ortr_desc);
    setitem('P53_ORTR_DESC_PROB', v_ortr_desc_prob);
    setitem('P53_ORTR_MONE_CODI_PREC', v_ortr_mone_codi_prec);
    setitem('P53_ORTR_PREC_VENT', v_ortr_prec_vent);
    setitem('P53_ORTR_TIPO_COST_TRAN', v_ortr_tipo_cost_tran);
    setitem('P53_ORTR_SOSE_CODI', v_ortr_sose_codi);
    setitem('P53_ORTR_EMPL_CODI_VEND', v_ortr_empl_codi_vend);
    setitem('P53_ORTR_SERV_TIPO', v_ortr_serv_tipo);
    setitem('P53_ORTR_SERV_POLI_NUME', v_ortr_serv_poli_nume);
    setitem('P53_ORTR_SERV_OBSE', v_ortr_serv_obse);
    setitem('P53_ORTR_USER_REGI', v_ortr_user_regi);
    setitem('P53_ORTR_FECH_REGI', v_ortr_fech_regi);
    setitem('P53_ORTR_USER_MODI', v_ortr_user_modi);
    setitem('P53_ORTR_FECH_MODI', v_ortr_fech_modi);
    setitem('P53_ORTR_SODE_CODI', v_ortr_sode_codi);
    setitem('P53_ORTR_VEHI_CODI', v_ortr_vehi_codi);
    setitem('P53_ORTR_FECH_INST', v_ortr_fech_inst);
    setitem('P53_ORTR_LUGA_INST', v_ortr_luga_inst);
    setitem('P53_ORTR_ANEX_CODI', v_ortr_anex_codi);
    setitem('P53_ORTR_SERV_TIPO_MOTI', v_ortr_serv_tipo_moti);
    setitem('P53_ORTR_VEHI_IDEN', v_ortr_vehi_iden);
    setitem('P53_ORTR_DETA_CODI', v_ortr_deta_codi);
    setitem('P53_ORTR_ESTA_PRE_LIQU', v_ortr_esta_pre_liqu);
    setitem('P53_ORTR_INDI_CLIE_VERI_VEHI', v_ortr_indi_clie_veri_vehi);
    setitem('P53_ORTR_INDI_REIN_FUTU_GENE', v_ortr_indi_rein_futu_gene);
    setitem('P53_ORTR_INDI_CORT_CORR', v_ortr_indi_cort_corr);
    setitem('P53_ORTR_CLPR_SUCU_NUME_ITEM', v_ortr_clpr_sucu_nume_item);
    setitem('P53_ORTR_FECH_LIQU', v_ortr_fech_liqu);
    setitem('P53_ORTR_CODI_PADR', v_ortr_codi_padr);
  
    setitem('P53_OTRO_LUGAR', v_ortr_exti);
  
    setitem('P53_ORTR_FORM_INSU', v_ortr_form_insu);
    setitem('P53_VEHI_LOTE_RASTREO', v_ortr_lote_equipo);
  
    ------------------------------verificacion del vehiculo
    begin
      select
      
       vehi_nume_item,
       vehi_empl_codi,
       vehi_pola,
       vehi_leva_vidr_elec,
       vehi_retr_elec,
       vehi_limp_para_dela,
       vehi_limp_para_tras,
       vehi_tanq,
       vehi_dire_hidr,
       vehi_auto_radi,
       vehi_ante_elec,
       vehi_aire_acon,
       vehi_bloq_cent,
       vehi_abag,
       vehi_fabs,
       vehi_tapi,
       vehi_alar,
       vehi_boci,
       vehi_lava_faro,
       vehi_llan,
       vehi_cubi,
       vehi_comb,
       vehi_cent,
       vehi_chap,
       vehi_pint,
       vehi_lalt,
       vehi_lbaj,
       vehi_lrev,
       vehi_lgir,
       vehi_lpos,
       vehi_lint,
       vehi_lsto,
       vehi_lest,
       vehi_ltab,
       vehi_user_regi,
       vehi_fech_regi,
       vehi_user_modi,
       vehi_fech_modi,
       vehi_clve_clpr_codi,
       vehi_clve_nume_item
        into v_vehi_nume_item,
             v_vehi_empl_codi,
             v_vehi_pola,
             v_vehi_leva_vidr_elec,
             v_vehi_retr_elec,
             v_vehi_limp_para_dela,
             v_vehi_limp_para_tras,
             v_vehi_tanq,
             v_vehi_dire_hidr,
             v_vehi_auto_radi,
             v_vehi_ante_elec,
             v_vehi_aire_acon,
             v_vehi_bloq_cent,
             v_vehi_abag,
             v_vehi_fabs,
             v_vehi_tapi,
             v_vehi_alar,
             v_vehi_boci,
             v_vehi_lava_faro,
             v_vehi_llan,
             v_vehi_cubi,
             v_vehi_comb,
             v_vehi_cent,
             v_vehi_chap,
             v_vehi_pint,
             v_vehi_lalt,
             v_vehi_lbaj,
             v_vehi_lrev,
             v_vehi_lgir,
             v_vehi_lpos,
             v_vehi_lint,
             v_vehi_lsto,
             v_vehi_lest,
             v_vehi_ltab,
             v_vehi_user_regi,
             v_vehi_fech_regi,
             v_vehi_user_modi,
             v_vehi_fech_modi,
             v_vehi_clve_clpr_codi,
             v_vehi_clve_nume_item
        from come_orde_trab_vehi
       where vehi_ortr_codi = v_ortr_codi;
    
      setitem('P53_VEHI_ORTR_CODI', v_ortr_codi);
      setitem('P53_VEHI_NUME_ITEM', v_vehi_nume_item);
      setitem('P53_VEHI_EMPL_CODI', v_vehi_empl_codi);
      setitem('P53_VEHI_POLA', v_vehi_pola);
      setitem('P53_VEHI_LEVA_VIDR_ELEC', v_vehi_leva_vidr_elec);
      setitem('P53_VEHI_RETR_ELEC', v_vehi_retr_elec);
      setitem('P53_VEHI_LIMP_PARA_DELA', v_vehi_limp_para_dela);
      setitem('P53_VEHI_LIMP_PARA_TRAS', v_vehi_limp_para_tras);
      setitem('P53_VEHI_TANQ', v_vehi_tanq);
      setitem('P53_VEHI_DIRE_HIDR', v_vehi_dire_hidr);
      setitem('P53_VEHI_AUTO_RADI', v_vehi_auto_radi);
      setitem('P53_VEHI_ANTE_ELEC', v_vehi_ante_elec);
      setitem('P53_VEHI_AIRE_ACON', v_vehi_aire_acon);
      setitem('P53_VEHI_BLOQ_CENT', v_vehi_bloq_cent);
      setitem('P53_VEHI_ABAG', v_vehi_abag);
      setitem('P53_VEHI_FABS', v_vehi_fabs);
      setitem('P53_VEHI_TAPI', v_vehi_tapi);
      setitem('P53_VEHI_ALAR', v_vehi_alar);
      setitem('P53_VEHI_BOCI', v_vehi_boci);
      setitem('P53_VEHI_LAVA_FARO', v_vehi_lava_faro);
      setitem('P53_VEHI_LLAN', v_vehi_llan);
      setitem('P53_VEHI_CUBI', v_vehi_cubi);
      setitem('P53_VEHI_COMB', v_vehi_comb);
      setitem('P53_VEHI_CENT', v_vehi_cent);
      setitem('P53_VEHI_CHAP', v_vehi_chap);
      setitem('P53_VEHI_PINT', v_vehi_pint);
      setitem('P53_VEHI_LALT', v_vehi_lalt);
      setitem('P53_VEHI_LBAJ', v_vehi_lbaj);
      setitem('P53_VEHI_LREV', v_vehi_lrev);
      setitem('P53_VEHI_LGIR', v_vehi_lgir);
      setitem('P53_VEHI_LPOS', v_vehi_lpos);
      setitem('P53_VEHI_LINT', v_vehi_lint);
      setitem('P53_VEHI_LSTO', v_vehi_lsto);
      setitem('P53_VEHI_LEST', v_vehi_lest);
      setitem('P53_VEHI_LTAB', v_vehi_ltab);
      setitem('P53_VEHI_CLVE_CLPR_CODI', v_vehi_clve_clpr_codi);
      setitem('P53_VEHI_CLVE_NUME_ITEM', v_vehi_clve_nume_item);
      if v_vehi_empl_codi is not null then
      
        pp_muestra_come_empl_qry(v_vehi_empl_codi,
                                 v_empl_desc,
                                 v_empl_codi_alte);
      
        setitem('P53_EMPL_CODI_ALTE_VEHI', v_empl_codi_alte);
        setitem('P53_EMPL_DESC', v_empl_desc);
      
      end if;
    exception
      when no_data_found then
        setitem('P53_VEHI_NUME_ITEM', null);
        setitem('P53_VEHI_EMPL_CODI', null);
        setitem('P53_VEHI_POLA', null);
        setitem('P53_VEHI_LEVA_VIDR_ELEC', null);
        setitem('P53_VEHI_RETR_ELEC', null);
        setitem('P53_VEHI_LIMP_PARA_DELA', null);
        setitem('P53_VEHI_LIMP_PARA_TRAS', null);
        setitem('P53_VEHI_TANQ', null);
        setitem('P53_VEHI_DIRE_HIDR', null);
        setitem('P53_VEHI_AUTO_RADI', null);
        setitem('P53_VEHI_ANTE_ELEC', null);
        setitem('P53_VEHI_AIRE_ACON', null);
        setitem('P53_VEHI_BLOQ_CENT', null);
        setitem('P53_VEHI_ABAG', null);
        setitem('P53_VEHI_FABS', null);
        setitem('P53_VEHI_TAPI', null);
        setitem('P53_VEHI_ALAR', null);
        setitem('P53_VEHI_BOCI', null);
        setitem('P53_VEHI_LAVA_FARO', null);
        setitem('P53_VEHI_LLAN', null);
        setitem('P53_VEHI_CUBI', null);
        setitem('P53_VEHI_COMB', null);
        setitem('P53_VEHI_CENT', null);
        setitem('P53_VEHI_CHAP', null);
        setitem('P53_VEHI_PINT', null);
        setitem('P53_VEHI_LALT', null);
        setitem('P53_VEHI_LBAJ', null);
        setitem('P53_VEHI_LREV', null);
        setitem('P53_VEHI_LGIR', null);
        setitem('P53_VEHI_LPOS', null);
        setitem('P53_VEHI_LINT', null);
        setitem('P53_VEHI_LSTO', null);
        setitem('P53_VEHI_LEST', null);
        setitem('P53_VEHI_LTAB', null);
        setitem('P53_VEHI_CLVE_CLPR_CODI', null);
        setitem('P53_VEHI_CLVE_NUME_ITEM', null);
        setitem('P53_EMPL_CODI_ALTE_VEHI', null);
        setitem('P53_EMPL_DESC', null);
    end;
  
    if v_ortr_clpr_codi is not null then
    
      pp_muestra_clie_prov(v_ortr_clpr_codi);
    
    end if;
  
    if v_ortr_empl_codi_vend is not null then
      pp_muestra_come_empl_qry(v_ortr_empl_codi_vend,
                               v_empl_desc,
                               v_empl_codi_alte);
    
      setitem('P53_EMPL_CODI_ALTE_VEND', v_empl_codi_alte);
      setitem('P53_EMPL_DESC_VEND', v_empl_desc);
    
    end if;
  
    if v_ortr_sode_codi is not null then
      pp_devu_soli_desi_codi(v_ortr_sode_codi);
    end if;
  
    if v_ortr_clpr_sucu_nume_item is not null then
      pp_muestra_come_clpr_sub_cuen(v_ortr_clpr_codi,
                                    v_ortr_clpr_sucu_nume_item);
    end if;
  
    pp_cargar_secuencia_alias(v_ortr_clpr_codi);
  
    ----***** vaciar datos de equipo primero
  
    setitem('P53_VEHI_EQUI_MODE_ANTE', '');
    setitem('P53_VEHI_EQUI_ID_ANTE', '');
    setitem('P53_VEHI_EQUI_IMEI_ANTE', '');
    setitem('P53_VEHI_EQUI_SIM_CARD_ANTE', '');
    setitem('P53_VEHI_ALAR_ID_ANTE', '');
  
    setitem('P53_VEHI_ALAR_ID_NUEV', '');
    setitem('P53_VEHI_EQUI_MODE_NUEV', '');
    setitem('P53_VEHI_EQUI_ID_NUEV', '');
    setitem('P53_VEHI_EQUI_IMEI_NUEV', '');
    setitem('P53_VEHI_EQUI_SIM_CARD_NUEV', '');
  
    /*
    
    setitem('p53_vehi_tive_codi', null);
    setitem('p53_vehi_mave_codi', null);
    setitem('p53_vehi_chap_nume', null);
    setitem('p53_vehi_chas_nume', null);
    setitem('p53_vehi_mode', null);
    setitem('p53_vehi_colo', null);
    setitem('p53_vehi_anho', null);
    setitem('p53_vehi_iden', null);
    setitem('p53_vehi_iden_ante',null);
    setitem('p53_vehi_fech_vige_inic', null);
    setitem('p53_vehi_fech_vige_fini', null);
    setitem('p53_vehi_equi_mode', null);
    setitem('p53_vehi_equi_id', null);*/
    --raise_application_error(-20001,v_ortr_vehi_codi);
    if v_ortr_vehi_codi is not null then
      pp_carga_vehiculo(v_ortr_vehi_codi);
    
      pp_muestra_vehi_deta_codi(v_ortr_vehi_codi, v_ortr_deta_codi_veri);
    
      ----- setitem('p53_ortr_vehi_codi',v_ortr_vehi_codi);
      setitem('P53_ORTR_DETA_CODI_VERI', v_ortr_deta_codi_veri);
    end if;
  
    if v('P53_P_INDI_MOST_GRAB_DIRE') = 'S' and
       v_ortr_sose_codi is not null then
      pp_devu_datos_contrato(v_ortr_sose_codi);
      pp_devu_datos_dire(v_ortr_anex_codi);
    end if;
  
    if v('P53_P_INDI_MOST_GRAB_DIRE') = 'S' and
       v_ortr_anex_codi is not null then
      --   pp_devu_datos_contrato(v_ortr_sose_codi);
      pp_devu_datos_dire(v_ortr_anex_codi);
    end if;
  
    setitem('P53_ORTR_ESTA_ORIG', nvl(v_ortr_esta, 'N'));
    setitem('P53_ORTR_ESTA_PRE_LIQU_ORIG', nvl(v_ortr_esta_pre_liqu, 'N'));
  
    if v_ortr_codi is not null then
      pp_muestra_factura(v_ortr_codi);
    end if;
  
    if v_ortr_fech_liqu is null then
      setitem('P53_HAB_BOTON', 'H');
    else
      if (nvl(v('P53_USER_INDI_MODI_DATO_OT_FINI'), 'N') = 'N' and
         v_ortr_esta = 'L') or
         v_ortr_codi_padr is not null and
         nvl(v('P53_USER_INDI_MODI_DATO_OT_FINI'), 'N') = 'N' then
        setitem('P53_HAB_BOTON', 'D');
      else
        setitem('P53_HAB_BOTON', 'H');
      end if;
    
      --habilita o no boton de pre-anexo para las ot de desinstalacion por reinstalacion a futuro
      --depenediendo del indicador del usuario
      if nvl(v('USER_INDI_GENE_PRE_ANEX_OT'), 'N') = 'S' and
         v_ortr_esta = 'L' and nvl(v_ortr_serv_tipo, 'I') = 'D' and
         nvl(v_ortr_serv_tipo_moti, 'R') = 'RF' and
         nvl(v_ortr_indi_rein_futu_gene, 'N') = 'N' then
      
        setitem('P53_M_ANEXO', 'S');
      else
        setitem('P53_M_ANEXO', 'N');
      end if;
    end if;
  
    ---------------------------------------
    apex_collection.create_or_truncate_collection(p_collection_name => 'ORDE_TRAB_CONT');
    for x in (select cont_ortr_codi,
                     cont_nume_item,
                     cont_tipo,
                     cont_apel,
                     cont_nomb,
                     cont_vinc,
                     cont_nume_docu,
                     cont_pass,
                     cont_tele,
                     cont_celu,
                     cont_hora,
                     cont_user_regi,
                     cont_fech_regi,
                     cont_user_modi,
                     cont_fech_modi
                from come_orde_trab_cont a
               where cont_ortr_codi = v_ortr_codi) loop
    
      apex_collection.add_member(p_collection_name => 'ORDE_TRAB_CONT',
                                 p_c001            => x.cont_ortr_codi,
                                 p_c002            => x.cont_nume_item,
                                 p_c003            => x.cont_tipo,
                                 p_c004            => x.cont_apel,
                                 p_c005            => x.cont_nomb,
                                 p_c006            => x.cont_vinc,
                                 p_c007            => x.cont_nume_docu,
                                 p_c008            => x.cont_pass,
                                 p_c009            => x.cont_tele,
                                 p_c010            => x.cont_celu,
                                 p_c011            => x.cont_hora,
                                 p_c012            => x.cont_user_regi,
                                 p_c013            => x.cont_fech_regi,
                                 p_c014            => x.cont_user_modi,
                                 p_c015            => x.cont_fech_modi);
    
    end loop;
    ---------------------------------------
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'La orden ingresada no existe');
    
  end pp_buscar_orden;

  procedure pp_cargar_secuencia is
  
    p_secu_nume_ortr number;
  
  begin
  
    if v('P53_P_ORTR_AUTONUM') is null then
      raise_application_error(-20001,
                              'Debe cargar el parametro P_ORTR_AUTONUM');
    end if;
  
    select nvl(max(to_number(ortr_nume)), 0) + 1
      into p_secu_nume_ortr
      from come_orde_trab;
  
    setitem('P53_ORTR_NUME', p_secu_nume_ortr);
    setitem('P53_ORTR_FECH_EMIS', to_char(sysdate, 'DD/MM/YYYY'));
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Codigo de Secuencia de Numero de O.T. inexistente');
    
  end pp_cargar_secuencia;

  procedure pp_muestra_clie_prov(p_clpr_codi in number) is
    v_clpr_esta varchar2(1);
    v_indi_clpr varchar2(1);
  
    v_clpr_codi_alte  varchar2(100);
    v_clpr_desc       varchar2(100);
    v_clpr_tipo_docu  varchar2(100);
    v_clpr_ruc        varchar2(100);
    v_clpr_dire       varchar2(100);
    v_barr_desc       varchar2(100);
    v_ciud_desc       varchar2(100);
    v_clpr_email      varchar2(100);
    v_clpr_email_fact varchar2(100);
    v_clpr_tele       varchar2(100);
  begin
  
    select cp.clpr_codi_alte,
           cp.clpr_desc,
           decode(cp.clpr_tipo_docu,
                  'RUC',
                  'R.U.C.',
                  'CI',
                  'C.I',
                  'TDEF',
                  'T.D.E.F.'),
           cp.clpr_ruc,
           cp.clpr_dire,
           b.barr_desc,
           c.ciud_desc,
           cp.clpr_email,
           cp.clpr_email_fact,
           cp.clpr_tele,
           cp.clpr_indi_clie_prov,
           cp.clpr_esta
      into v_clpr_codi_alte,
           v_clpr_desc,
           v_clpr_tipo_docu,
           v_clpr_ruc,
           v_clpr_dire,
           v_barr_desc,
           v_ciud_desc,
           v_clpr_email,
           v_clpr_email_fact,
           v_clpr_tele,
           v_indi_clpr,
           v_clpr_esta
      from come_clie_prov cp, come_barr b, come_ciud c
     where cp.clpr_barr_codi = b.barr_codi(+)
       and cp.clpr_ciud_codi = c.ciud_codi(+)
       and cp.clpr_codi = p_clpr_codi;
  
    setitem('P53_CLPR_CODI_ALTE', v_clpr_codi_alte);
    setitem('P53_CLPR_DESC', v_clpr_desc);
    setitem('P53_CLPR_TIPO_DOCU', v_clpr_tipo_docu);
    setitem('P53_CLPR_RUC', v_clpr_ruc);
    setitem('P53_CLPR_DIRE', v_clpr_dire);
    setitem('P53_BARR_DESC', v_barr_desc);
    setitem('P53_CIUD_DESC', v_ciud_desc);
    setitem('P53_CLPR_EMAIL', v_clpr_email);
    setitem('P53_CLPR_EMAIL_FACT', v_clpr_email_fact);
    setitem('P53_CLPR_TELE', v_clpr_tele);
  
    if v_clpr_esta = 'I' then
      if v_indi_clpr = 'C' then
        raise_application_error(-20001, 'El cliente se encuentra inactivo');
      else
        raise_application_error(-20001,
                                'El proveedor se encuentra inactivo');
      end if;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'No existe registro');
  end pp_muestra_clie_prov;

  procedure pp_devu_soli_desi_codi(p_ortr_sode_codi in number) is
  
    v_sode_nume varchar2(100);
    v_sode_esta varchar2(100);
  begin
  
    select sode_nume, sode_esta
      into v_sode_nume, v_sode_esta
      from come_soli_desi, come_clie_prov
     where sode_clpr_codi = clpr_codi
       and sode_codi = p_ortr_sode_codi;
  
    setitem('P53_SODE_NUME', v_sode_nume);
    setitem('P53_SODE_ESTA', v_sode_esta);
  
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Solicitud de Desinstalaci?n Inexistente.');
    
  end pp_devu_soli_desi_codi;

  procedure pp_muestra_come_clpr_sub_cuen(p_clpr_codi      in number,
                                          p_sucu_nume_item in number) is
  
    v_sucu_desc varchar2(100);
    v_sucu_tele varchar2(100);
    v_sucu_ruc  varchar2(100);
  
  begin
  
    raise_application_error(-20001, p_clpr_codi || '' || p_sucu_nume_item);
  
    select sucu_desc, sucu_tele, sucu_ruc
      into v_sucu_desc, v_sucu_tele, v_sucu_ruc
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_clpr_codi
       and sucu_nume_item = p_sucu_nume_item;
  
    setitem('P53_S_SUCU_DESC', v_sucu_desc);
    setitem('P53_S_SUCU_TELE', v_sucu_tele);
    setitem('P53_S_SUCU_RUC', v_sucu_ruc);
  exception
    when no_data_found then
      raise_application_error(-20001, 'Subcuenta Inexistente!');
    
  end pp_muestra_come_clpr_sub_cuen;

  procedure pp_cargar_secuencia_alias(p_clpr_codi in number) is
  
    v_seal_desc      varchar2(100);
    v_seal_ulti_nume varchar2(100);
    v_seal_codi      varchar2(100);
  begin
  
    select seal_desc_abre, seal_ulti_nume, seal_codi
      into v_seal_desc, v_seal_ulti_nume, v_seal_codi
      from come_clie_secu_alia
     where ((seal_clpr_codi = p_clpr_codi) or
           (seal_clpr_codi is null and p_clpr_codi is null));
  
  exception
    when no_data_found then
      begin
        select seal_desc_abre, seal_ulti_nume, seal_codi
          into v_seal_desc, v_seal_ulti_nume, v_seal_codi
          from come_clie_secu_alia
         where seal_desc_abre = 'RPY'
           and seal_clpr_codi is null;
      
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'Debe registrar un Alias para la Aseguradora seleccionada.');
      end;
      setitem('P53_SEAL_DESC_ABRE', v_seal_desc);
      setitem('P53_SEAL_ULTI_NUME', v_seal_ulti_nume);
      setitem('P53_SEAL_CODI', v_seal_codi);
    
  end pp_cargar_secuencia_alias;

  procedure pp_carga_vehiculo(p_vehi_codi in number) is
  
    v_vehi_equi_mode_ante     varchar2(40);
    v_vehi_equi_id_ante       varchar2(20);
    v_vehi_equi_imei_ante     varchar2(20);
    v_vehi_equi_sim_card_ante varchar2(20);
    v_vehi_alar_id_ante       varchar2(20);
    v_vehi_esta               varchar2(2);
  
    v_vehi_tive_codi      varchar2(40);
    v_vehi_mave_codi      varchar2(40);
    v_nume_pate           varchar2(40);
    v_nume_chas           varchar2(40);
    v_vehi_mode           varchar2(40);
    v_vehi_colo           varchar2(40);
    v_vehi_anho           varchar2(40);
    v_vehi_iden           varchar2(40);
    v_vehi_iden_ante      varchar2(40);
    v_vehi_fech_vige_inic varchar2(40);
    v_vehi_fech_vige_fini varchar2(40);
    v_vehi_equi_mode      varchar2(40);
    v_vehi_equi_id        varchar2(40);
    v_vehi_equi_imei      varchar2(40);
    v_vehi_equi_sim_card  varchar2(40);
    v_vehi_alar_id        varchar2(40);
  
  begin
  
    select vehi_tive_codi,
           vehi_mave_codi,
           nvl(vehi_nume_pate, 'S/D') deta_nume_pate,
           nvl(vehi_nume_chas, 'S/D') deta_nume_chas,
           nvl(vehi_mode, 'S/D') deta_mode,
           nvl(vehi_colo, 'S/D') deta_colo,
           nvl(vehi_anho, 'S/D') deta_anho,
           vehi_iden deta_iden,
           vehi_iden_ante,
           vehi_fech_vige_inic,
           vehi_fech_vige_fini,
           vehi_equi_mode,
           vehi_equi_id,
           vehi_equi_imei,
           vehi_equi_sim_card,
           vehi_alar_id
      into v_vehi_tive_codi,
           v_vehi_mave_codi,
           v_nume_pate,
           v_nume_chas,
           v_vehi_mode,
           v_vehi_colo,
           v_vehi_anho,
           v_vehi_iden,
           v_vehi_iden_ante,
           v_vehi_fech_vige_inic,
           v_vehi_fech_vige_fini,
           v_vehi_equi_mode,
           v_vehi_equi_id,
           v_vehi_equi_imei,
           v_vehi_equi_sim_card,
           v_vehi_alar_id
      from come_vehi
     where vehi_codi = p_vehi_codi;
  
    setitem('P53_VEHI_TIVE_CODI', v_vehi_tive_codi);
    setitem('P53_VEHI_MAVE_CODI', v_vehi_mave_codi);
    setitem('P53_VEHI_CHAP_NUME', v_nume_pate);
    setitem('P53_VEHI_CHAS_NUME', v_nume_chas);
    setitem('P53_VEHI_MODE', v_vehi_mode);
    setitem('P53_VEHI_COLO', v_vehi_colo);
    setitem('P53_VEHI_ANHO', v_vehi_anho);
    setitem('P53_VEHI_IDEN', v_vehi_iden);
    setitem('P53_VEHI_IDEN_ANTE', v_vehi_iden_ante);
    setitem('P53_VEHI_FECH_VIGE_INIC', v_vehi_fech_vige_inic);
    setitem('P53_VEHI_FECH_VIGE_FINI', v_vehi_fech_vige_fini);
    setitem('P53_VEHI_EQUI_MODE', v_vehi_equi_mode);
    setitem('P53_VEHI_EQUI_IMEI', v_vehi_equi_imei);
    setitem('P53_VEHI_EQUI_SIM_CARD', v_vehi_equi_sim_card);
    setitem('P53_VEHI_ALAR_ID', v_vehi_alar_id);
    setitem('P53_VEHI_EQUI_ID', v_vehi_equi_id);
  
    begin
      select vehi_equi_mode,
             vehi_equi_id,
             vehi_equi_imei,
             vehi_equi_sim_card,
             vehi_alar_id
        into v_vehi_equi_mode_ante,
             v_vehi_equi_id_ante,
             v_vehi_equi_imei_ante,
             v_vehi_equi_sim_card_ante,
             v_vehi_alar_id_ante
        from come_vehi_hist v1
       where vehi_codi = p_vehi_codi
         and vehi_secu =
             (select max(vehi_secu)
                from come_vehi_hist v2, come_vehi v
               where v.vehi_codi = v2.vehi_codi
                 and v.vehi_codi = p_vehi_codi
                 and v.vehi_equi_id <> v2.vehi_equi_id);
    
      if v_vehi_equi_id_ante <> v_vehi_equi_id then
        setitem('P53_VEHI_EQUI_MODE_ANTE', v_vehi_equi_mode_ante);
        setitem('P53_VEHI_EQUI_ID_ANTE', v_vehi_equi_id_ante);
        setitem('P53_VEHI_EQUI_IMEI_ANTE', v_vehi_equi_imei_ante);
        setitem('P53_VEHI_EQUI_SIM_CARD_ANTE', v_vehi_equi_sim_card_ante);
        setitem('P53_VEHI_ALAR_ID_ANTE', v_vehi_alar_id_ante);
      end if;
    
    exception
      when others then
        null;
    end;
  
    if v_vehi_tive_codi is not null then
      pp_mostrar_tipo_vehi(v_vehi_tive_codi);
    end if;
  
    if v_vehi_mave_codi is not null then
      pp_mostrar_marc_vehi(v_vehi_mave_codi);
    end if;
  
    if v('P53_VEHI_LOTE_RASTREO') is null and v_vehi_equi_imei is not null then
      null;
      setitem('P53_VEHI_LOTE_RASTREO',
              fp_get_code_from_desc_lote(v_vehi_equi_imei));
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'No se encontro vehiculo');
    
  end pp_carga_vehiculo;

  procedure pp_devu_datos_contrato(p_sose_codi in number) is
  
    v_dura_cont varchar2(40);
    v_dire_obse varchar2(40);
    v_fech_emis varchar2(40);
  
  begin
    select sose_dura_cont, sose_dire_obse, sose_fech_emis
      into v_dura_cont, v_dire_obse, v_fech_emis
      from come_soli_serv
     where sose_codi = p_sose_codi;
  
    setitem('P53_SOSE_DURA_CONT', v_dura_cont);
    setitem('P53_SOSE_DIRE_OBSE', v_dire_obse);
    setitem('P53_SOSE_FECH_EMIS', v_fech_emis);
    setitem('P53_SOSE_DIRE_OBSE_ORIG', v_dire_obse);
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Contrato Inexistente.');
    
  end pp_devu_datos_contrato;

  procedure pp_devu_datos_dire(p_anex_codi in number) is
  
    v_anex_sose_codi number;
    v_sose_codi      number;
    v_sose_dire_obse varchar2(60);
  begin
  
    begin
      select anex_sose_codi
        into v_anex_sose_codi
        from come_soli_serv_anex
       where anex_codi = p_anex_codi;
    end;
  
    begin
      select sose_dire_obse, sose_codi
        into v_sose_dire_obse, v_sose_codi
        from come_soli_serv
       where sose_codi = v_anex_sose_codi;
    
      setitem('P53_SOSE_DIRE_OBSE', v_sose_dire_obse);
      --  :parameter.p_sose_codi, :bcab.
      setitem('P53_SOSE_DIRE_OBSE_ORIG', v_sose_dire_obse);
    
    exception
      when no_data_found then
        null;
    end;
  end pp_devu_datos_dire;

  procedure pp_mostrar_tipo_vehi(p_tive_codi in number) is
    v_tive_desc      varchar2(60);
    v_tive_codi_alte varchar2(60);
  begin
    select tive_desc, tive_codi_alte
      into v_tive_desc, v_tive_codi_alte
      from come_tipo_vehi
     where tive_codi = p_tive_codi;
  
    setitem('P53_TIVE_DESC', v_tive_desc);
    setitem('P53_TIVE_CODI_ALTE', v_tive_codi_alte);
  exception
    when no_data_found then
      raise_application_error(-20001, 'Tipo de Vehiculo Inexistente 222');
    
  end pp_mostrar_tipo_vehi;

  procedure pp_mostrar_marc_vehi(p_mave_codi in number) is
  
    v_mave_desc      varchar2(60);
    v_mave_codi_alte varchar2(60);
  
  begin
    select mave_desc, mave_codi_alte
      into v_mave_desc, v_mave_codi_alte
      from come_marc_vehi
     where mave_codi = p_mave_codi;
  
    setitem('P53_MAVE_DESC', v_mave_desc);
    setitem('P53_MAVE_CODI_ALTE', v_mave_codi_alte);
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Marca de Vehiculo Inexistente 111');
    
  end pp_mostrar_marc_vehi;

  procedure pp_muestra_factura(p_ortr_codi in number) is
  
    v_faau_nume      varchar2(40);
    v_movi_nume      varchar2(40);
    v_movi_fech_emis varchar2(40);
  
  begin
    select f.faau_nume, m.movi_nume, m.movi_fech_emis
      into v_faau_nume, v_movi_nume, v_movi_fech_emis
      from come_orde_trab           o,
           come_soli_serv_anex_plan p,
           come_fact_auto           f,
           come_movi                m
     where o.ortr_deta_codi = p.anpl_deta_codi
       and p.anpl_faau_codi = f.faau_codi
       and p.anpl_movi_codi = m.movi_codi
       and p.anpl_nume_item = 1
       and o.ortr_codi = p_ortr_codi;
  
    setitem('P53_FAAU_NUME', v_faau_nume);
    setitem('P53_MOVI_NUME', v_movi_nume);
    setitem('P53_MOVI_FECH_EMIS', v_movi_fech_emis);
  
  exception
    when no_data_found then
      null;
  end pp_muestra_factura;

  procedure pp_muestra_come_empl_qry(p_empl_codi      in number,
                                     p_empl_desc      out varchar2,
                                     p_empl_codi_alte out number) is
  
  begin
    select e.empl_desc, e.empl_codi_alte
      into p_empl_desc, p_empl_codi_alte
      from come_empl e
     where e.empl_codi = p_empl_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Empleado inexistente');
    
  end pp_muestra_come_empl_qry;

  procedure pp_validar_servicio is
    v_ortr_desc varchar2(60);
  
  begin
  
    if v('P53_ORTR_CODI') is null then
      if v('P53_ORTR_SERV_TIPO') in ('RI', 'R', 'S', 'T', 'O', 'RAS', 'D') then
        raise_application_error(-20001,
                                'Tipo de servicio no v?lido para carga manual.');
      elsif v('P53_ORTR_SERV_TIPO') in ('I') then
        raise_application_error(-20001,
                                'Tipo de servicio no v?lido para carga manual. Las instalaciones de vehiculos se deben realizar en base a un Contrato!');
      end if;
    end if;
  
    --if v('p53_ortr_desc') is null
    /*or lower(ltrim(rtrim( v('p53_ortr_desc')))) in ('instalaci?n',
    'cambio a rpy',
    'renovacion',
    'verificaci?n',
    'reinstalaci?n',
    'desinstalaci?n',
    'cambio de seguro',
    'cambio de titularidad',
    'otros') then*/
    if v('P53_ORTR_SERV_TIPO') = 'I' then
      v_ortr_desc := 'Instalaci?n';
    elsif v('P53_ORTR_SERV_TIPO') = 'R' then
      v_ortr_desc := 'Cambio a RPY';
    elsif v('P53_ORTR_SERV_TIPO') = 'N' then
      v_ortr_desc := 'Renovaci?n';
    elsif v('P53_ORTR_SERV_TIPO') = 'V' then
      v_ortr_desc := 'Verificaci?n';
    elsif v('P53_ORTR_SERV_TIPO') = 'RI' then
      v_ortr_desc := 'Reinstalaci?n';
    elsif v('P53_ORTR_SERV_TIPO') = 'D' then
      v_ortr_desc := 'Desinstalaci?n';
    elsif v('P53_ORTR_SERV_TIPO') = 'S' then
      v_ortr_desc := 'Cambio de Seguro';
    elsif v('P53_ORTR_SERV_TIPO') = 'T' then
      v_ortr_desc := 'Cambio de Titularidad';
    elsif v('P53_ORTR_SERV_TIPO') = 'FC' then
      v_ortr_desc := 'Firma de Contrato';
    elsif v('P53_ORTR_SERV_TIPO') = 'C' then
      v_ortr_desc := 'Cobranza';
    elsif v('P53_ORTR_SERV_TIPO') = 'O' then
      v_ortr_desc := 'Otros';
    end if;
    setitem('P53_ORTR_DESC', v_ortr_desc);
  
    --end if;
  
    ----pp_deshabilitar_campos_vehicul; ya lo hace en apex
  
  end pp_validar_servicio;

  procedure pp_grab_obse is
  
  begin
    if v('P53_ORTR_CODI') is not null then
      --:parameter.p_ortr_obse := :bcab.ortr_serv_obse;
      -- :parameter.p_ortr_codi_update := :bcab.ortr_codi;
      update come_orde_trab
         set ortr_serv_obse = v('P53_ORTR_SERV_OBSE') --   :parameter.p_ortr_obse
       where ortr_codi = v('P53_ORTR_CODI'); --:parameter.p_ortr_codi_update;
    
      -- pp_iniciar;
    end if;
  
  end pp_grab_obse;

  procedure pp_grabar_dire is
  
  begin
  
    if v('P53_ORTR_SOSE_CODI') is not null then
      ---or :parameter.p_sose_codi is not null then
    
      update come_soli_serv
         set sose_dire_obse = v('P53_SOSE_DIRE_OBSE')
       where sose_codi = v('P53_ORTR_SOSE_CODI');
    
      -- pl_mm('grabado con exito!');
      --pp_iniciar;
    
    end if;
  
  end pp_grabar_dire;

  procedure pp_muestra_clie_prov_alte(p_clpr_codi in number) is
  
    v_clpr_esta      varchar2(1);
    v_indi_clpr      varchar2(1);
    v_empl_codi_alte varchar2(100);
  
    v_empl_desc  varchar2(100);
    v_empl_codi  varchar2(100);
    v_clas1_desc varchar2(100);
    v_clas1_codi varchar2(100);
  
    v_clpr_codi       varchar2(100);
    v_clpr_codi_alte  varchar2(100);
    v_clpr_desc       varchar2(100);
    v_clpr_tipo_docu  varchar2(100);
    v_clpr_ruc        varchar2(100);
    v_clpr_dire       varchar2(100);
    v_barr_desc       varchar2(100);
    v_ciud_desc       varchar2(100);
    v_clpr_email      varchar2(100);
    v_clpr_email_fact varchar2(100);
    v_clpr_tele       varchar2(100);
  begin
  
    select cp.clpr_codi,
           cp.clpr_desc,
           decode(cp.clpr_tipo_docu,
                  'RUC',
                  'R.U.C.',
                  'CI',
                  'C.I',
                  'TDEF',
                  'T.D.E.F.'),
           cp.clpr_ruc,
           cp.clpr_dire,
           b.barr_desc,
           c.ciud_desc,
           cp.clpr_email,
           cp.clpr_email_fact,
           cp.clpr_tele,
           e.empl_codi_alte,
           e.empl_desc,
           e.empl_codi,
           cp.clpr_esta,
           clas1_desc,
           clas1_codi
      into v_clpr_codi,
           v_clpr_desc,
           v_clpr_tipo_docu,
           v_clpr_ruc,
           v_clpr_dire,
           v_barr_desc,
           v_ciud_desc,
           v_clpr_email,
           v_clpr_email_fact,
           v_clpr_tele,
           v_empl_codi_alte,
           v_empl_desc,
           v_empl_codi,
           v_clpr_esta,
           v_clas1_desc,
           v_clas1_codi
      from come_clie_prov   cp,
           come_barr        b,
           come_ciud        c,
           come_empl        e,
           come_clie_clas_1
     where cp.clpr_barr_codi = b.barr_codi(+)
       and cp.clpr_ciud_codi = c.ciud_codi(+)
       and cp.clpr_empl_codi = e.empl_codi(+)
       and cp.clpr_clie_clas1_codi = clas1_codi(+)
       and cp.clpr_indi_clie_prov = 'C'
       and cp.clpr_codi_alte = p_clpr_codi;
  
    setitem('P53_ORTR_CLPR_CODI', v_clpr_codi);
    setitem('P53_CLPR_DESC', v_clpr_desc);
    setitem('P53_CLPR_TIPO_DOCU', v_clpr_tipo_docu);
    setitem('P53_CLPR_RUC', v_clpr_ruc);
    setitem('P53_CLPR_DIRE', v_clpr_dire);
    setitem('P53_BARR_DESC', v_barr_desc);
    setitem('P53_CIUD_DESC', v_ciud_desc);
    setitem('P53_CLPR_EMAIL', v_clpr_email);
    setitem('P53_CLPR_EMAIL_FACT', v_clpr_email_fact);
    setitem('P53_CLPR_TELE', v_clpr_tele);
    setitem('P53_EMPL_CODI_ALTE_VEND', v_empl_codi_alte);
    setitem('P53_EMPL_DESC_VEND', v_empl_desc);
    setitem('P53_ORTR_EMPL_CODI_VEND', v_empl_codi);
    setitem('P53_CLAS1_CODI', v_clas1_codi);
    setitem('P53_S_CLAS1_DESC', v_clas1_desc);
  
    if v_clpr_esta = 'I' then
      if v_indi_clpr = 'C' then
        raise_application_error(-20001, 'El cliente se encuentra inactivo');
      else
        raise_application_error(-20001,
                                'El proveedor se encuentra inactivo');
      end if;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'No existe registro');
  end pp_muestra_clie_prov_alte;

  procedure pp_buscar_vendedor(p_codi_tipo_empl      in number,
                               p_empl_codi_alte_vend in number,
                               p_empl_codi           out varchar2,
                               p_empl_desc           out varchar2) is
  
    v_cant      number;
    v_empl_codi varchar2(60);
    v_empl_desc varchar2(60);
  begin
  
    if p_empl_codi_alte_vend is null then
      raise_application_error(-20001,
                              'Debe ingresar el codigo del vendedor!');
    else
    
      begin
        select count(*)
          into v_cant
          from come_empl e, come_empl_tiem t
         where e.empl_codi = t.emti_empl_codi
           and e.empl_empr_codi = 1
           and t.emti_tiem_codi = p_codi_tipo_empl -- v('p53_p_codi_tipo_empl_vend')
           and (upper(e.empl_codi_alte) like
               '%' || p_empl_codi_alte_vend || '%' or
               upper(e.empl_desc) like '%' || p_empl_codi_alte_vend || '%');
      end;
    
      if v_cant >= 1 then
        --si existe al menos un deposito con esos criterios entonces mostrar la lista
        --para ver si se acepto un valor o no despues del list_values
        -- p_empl_codi_alte_vend:= null;
      
        if p_empl_codi_alte_vend is not null then
          begin
            select e.empl_desc, e.empl_codi
              into p_empl_desc, p_empl_codi
              from come_empl e, come_empl_tiem t
             where e.empl_codi = t.emti_empl_codi
               and t.emti_tiem_codi = p_codi_tipo_empl ---v('p53_p_codi_tipo_empl_vend')
               and nvl(e.empl_empr_codi, 1) = 1 ---el uno envia estatico
               and e.empl_codi_alte = p_empl_codi_alte_vend;
          
          exception
            when no_data_found then
              raise_application_error(-20001,
                                      'Empleado inexistente o no es del tipo requerido');
            
          end;
        end if;
      end if;
    end if;
  
  end pp_buscar_vendedor;

  procedure pp_val_vehiculo is
  
    v_count_ident         number;
    v_ortr_vehi_codi      varchar2(100);
    v_ortr_deta_codi_veri varchar2(100);
  
  begin
  
    if v('P53_VALIDA_CAMPO') = 'S' then
    
      if v('P53_VEHI_IDEN') is not null then
        ------- pp_valida_identificador----------
      
        select count(*)
          into v_count_ident
          from come_vehi
         where replace(replace(vehi_iden, ''), '-', '') =
               replace(replace(v('P53_VEHI_IDEN'), ''), '-', '')
           and (vehi_codi = v('P53_ORTR_VEHI_CODI') or
                v('P53_ORTR_VEHI_CODI IS') is null)
           and (vehi_clpr_codi <> v('P53_ORTR_CLPR_CODI') or
                v('P53_ORTR_CLPR_CODI') is null)
           and nvl(vehi_esta, 'I') <> 'D';
      
        if v_count_ident > 0 then
          raise_application_error(-20001,
                                  'El identificador se encuentra registrado, verifique en consultas de veh?culos!');
        
        else
        
          begin
            select vehi_codi
              into v_ortr_vehi_codi
              from come_vehi_hist
             where vehi_iden like '%' || v('P53_VEHI_IDEN') || '%'
               and (vehi_codi = v('P53_ORTR_VEHI_CODI') or
                   v('P53_ORTR_VEHI_CODI') is null)
               and (vehi_clpr_codi = v('P53_ORTR_CLPR_CODI'))
             group by vehi_codi;
          
            setitem('P53_ORTR_VEHI_CODI', v_ortr_vehi_codi);
          
          exception
            when no_data_found then
              select s.vehi_codi
                into v_ortr_vehi_codi
                from come_vehi s, come_tipo_vehi
               where vehi_tive_codi = tive_codi(+)
                 and vehi_clpr_codi = v('P53_ORTR_CLPR_CODI')
                 and nvl(vehi_esta_vehi, 'A') = 'A'
                 and nvl(vehi_esta, 'I') = 'I'
                 and vehi_iden like '%' || v('P53_VEHI_IDEN') || '%'
                 and v('P53_ORTR_CODI') is null
                 and v('P53_ORTR_SERV_TIPO') = 'V';
            
            when too_many_rows then
            
              select s.vehi_codi
                into v_ortr_vehi_codi
                from come_vehi s, come_tipo_vehi
               where vehi_tive_codi = tive_codi(+)
                 and vehi_clpr_codi = v('P53_ORTR_CLPR_CODI')
                 and nvl(vehi_esta_vehi, 'A') = 'A'
                 and nvl(vehi_esta, 'I') = 'I'
                 and vehi_iden like '%' || v('P53_VEHI_IDEN') || '%'
                 and v('P53_ORTR_CODI') is null
                 and v('P53_ORTR_SERV_TIPO') = 'V';
          end;
        end if;
      
        pp_carga_vehiculo(v_ortr_vehi_codi);
      
        pp_muestra_vehi_deta_codi(v_ortr_vehi_codi, v_ortr_deta_codi_veri);
      
        setitem('P53_ORTR_VEHI_CODI', v_ortr_vehi_codi);
        setitem('P53_ORTR_DETA_CODI_VERI', v_ortr_deta_codi_veri);
      
      else
        if v('P53_ORTR_SERV_TIPO') = 'I' then
          raise_application_error(-20001,
                                  'Debe ingresar el Identificador del Veh?culo del Cliente seleccionado.');
        end if;
      end if;
    
      if v('P53_ORTR_CODI') is null then
        if v('P53_ORTR_VEHI_CODI') is null then
          if v('P53_ORTR_SERV_TIPO') = 'V' then
            raise_application_error(-20001,
                                    'Debe seleccionar un vehiculo existente del Cliente seleccionado!');
          end if;
        end if;
      end if;
    
    end if;
  
  end pp_val_vehiculo;

  procedure pp_muestra_vehi_deta_codi(p_vehi_codi in number,
                                      p_deta_codi out number) is
  
    v_deta_codi number;
  
  begin
  
    select deta_codi
      into p_deta_codi
      from come_soli_serv_anex_deta d, come_vehi v
     where v.vehi_codi = d.deta_vehi_codi
       and d.deta_vehi_codi = p_vehi_codi
       and d.deta_esta = 'I';
  
  exception
    when no_data_found then
    
      begin
        select deta_codi
          into p_deta_codi
          from come_soli_serv_anex_deta d, come_vehi v
         where v.vehi_codi = d.deta_vehi_codi
           and d.deta_vehi_codi = p_vehi_codi
           and (d.deta_esta = 'P' and v.vehi_esta = 'I');
      
      exception
        when no_data_found then
          p_deta_codi := null;
        when too_many_rows then
          begin
            select max(deta_codi)
              into p_deta_codi
              from come_soli_serv_anex_deta d, come_vehi v
             where v.vehi_codi = d.deta_vehi_codi
               and d.deta_vehi_codi = p_vehi_codi
               and (d.deta_esta = 'P' and v.vehi_esta = 'I');
          
          exception
            when others then
              p_deta_codi := null;
          end;
        when others then
          p_deta_codi := null;
      end;
    
    when too_many_rows then
      begin
        select max(deta_codi)
          into p_deta_codi
          from come_soli_serv_anex_deta d, come_vehi v
         where v.vehi_codi = d.deta_vehi_codi
           and d.deta_vehi_codi = p_vehi_codi
           and d.deta_esta = 'I';
      exception
        when others then
          p_deta_codi := null;
      end;
    
    when others then
      p_deta_codi := null;
  end pp_muestra_vehi_deta_codi;

  procedure pp_mostrar_tipo_vehi_alte is
  
    v_tive_desc varchar2(100);
    v_tive_codi varchar2(100);
  begin
  
    select tive_desc, tive_codi
      into v_tive_desc, v_tive_codi
      from come_tipo_vehi
     where rtrim(ltrim(tive_codi_alte)) =
           rtrim(ltrim(v('P53_TIVE_CODI_ALTE')))
       and tive_empr_codi = 1;
  
    setitem('P53_TIVE_DESC', v_tive_desc);
    setitem('P53_VEHI_TIVE_CODI', v_tive_codi);
  exception
    when no_data_found then
    
      raise_application_error(-20001, 'Tipo de Vehiculo Inexistente 111');
    
  end pp_mostrar_tipo_vehi_alte;

  procedure pp_mostrar_marc_vehi_alte is
    v_mave_desc varchar2(100);
    v_mave_codi varchar2(100);
  begin
    select mave_desc, mave_codi
      into v_mave_desc, v_mave_codi
      from come_marc_vehi
     where rtrim(ltrim(mave_codi_alte)) =
           rtrim(ltrim(v('P53_MAVE_CODI_ALTE')))
       and mave_empr_codi = 1;
  
    setitem('P53_MAVE_DESC', v_mave_desc);
    setitem('P53_VEHI_MAVE_CODI', v_mave_codi);
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Marca de Vehiculo Inexistente');
    
  end pp_mostrar_marc_vehi_alte;

  procedure pp_actualizar_email is
  
  begin
  
    if v('P53_ORTR_CLPR_CODI') is not null then
    
      update come_clie_prov
         set clpr_email      = v('P53_CLPR_EMAIL'),
             clpr_email_fact = v('P53_CLPR_EMAIL_FACT')
       where clpr_codi = v('P53_ORTR_CLPR_CODI');
    
    end if;
  
  end pp_actualizar_email;

  procedure pp_validar_existencia(i_lote_codi      in number,
                                  i_vehi_empl_codi in number,
                                  i_ortr_serv_tipo in varchar2) is
  
    v_product        number := 30173201; --crx
    v_depo_codi      number;
    v_existencia     number;
    v_exist          number;
    v_nuevo          number;
    p_perm_stoc_nega varchar2(500) := trim(general_skn.fl_busca_parametro('p_perm_stoc_nega'));
    e_salir          exception;
    v_ultimo_lote    number;
  begin
  
    if i_ortr_serv_tipo in ('D', 'T', 'C') then
      raise e_salir;
    end if;
  
    if i_ortr_serv_tipo = 'V' then
      if not
          (fp_ind_camb_disp_ortr(i_ortr_codi => v('P53_ORTR_CODI'),
                                 i_vehi_codi => v('P53_ORTR_VEHI_CODI'))) then
        raise e_salir;
      end if;
    
      v_ultimo_lote := fp_get_last_lote_disp(i_ortr_codi => v('P53_ORTR_CODI'),
                                             i_vehi_codi => v('P53_ORTR_VEHI_CODI'));
    
      if v_ultimo_lote = i_lote_codi then
        raise e_salir;
      end if;
    
    end if;
  
    if p_perm_stoc_nega = 'N' then
      select t.user_depo_codi
        into v_depo_codi
        from segu_user t
       where t.user_empl_codi = i_vehi_empl_codi;
    
      -- call the function
      v_existencia := fa_dev_stoc_actu_lote(p_prod_codi => v_product,
                                            p_depo_codi => v_depo_codi,
                                            p_lote_codi => i_lote_codi);
    
      if v_existencia < 1 then
        raise_application_error(-20010,
                                'ATENCION!!!, El producto no permite stock en negativo cantidad actual:' ||
                                v_existencia || ' dep:' || v_depo_codi);
      end if;
    end if;
  
  exception
    when e_salir then
      null;
  end pp_validar_existencia;

  procedure pp_valida_movi_ent_sal is
    v_mensaje   varchar2(1000);
    v_ortr_codi number := v('P53_ORTR_CODI');
  begin
  
    for c in (select m.movi_nume, m.movi_fech_emis, o.oper_desc
                from come_movi m, come_stoc_oper o
               where m.movi_oper_codi = oper_codi
                 and m.movi_ortr_codi = v_ortr_codi
                 and oper_codi in (13, 12)) loop
      v_mensaje := v_mensaje || 'Nro.:' || c.movi_nume;
      v_mensaje := v_mensaje || ' *Operacion.:' || c.oper_desc;
      v_mensaje := v_mensaje || ' *fecha.:' || c.movi_fech_emis;
    end loop;
    if v_mensaje is not null then
      v_mensaje := 'Primero debe anular movi:*' || v_mensaje;
      pl_me(v_mensaje);
    end if;
  end pp_valida_movi_ent_sal;

  procedure pp_actualizar_registro is
  
    v_count          number;
    v_nume           number;
    v_ortr_codi      number;
    v_ortr_nume      number;
    v_ortr_esta      varchar2(2);
    v_ortr_vehi_codi number;
    ---
    v_token_fcm     varchar2(200);
    v_codresp       number;
    v_descresp      varchar2(200);
    v_p53_clpr_desc varchar2(200);
    v_mensaje       varchar2(2000);
  
    v_cnt_codigo    varchar2(1000) := crm_neg_ticket_seq.nextval;
    v_ortr_codi_liq number;
    v_codi_padre    number;
    ---
    v_plan      number;
    v_form_inst number;
  begin
    ---raise_application_error (-20001, v('p53_ortr_vehi_codi'));
  
    --if v('p53_ortr_deta_codi_veri') is null then
    --  raise_application_error (-20001, 'no esta recibiendo el codigo del vehiculox');
  
    --end if;
  
    if v('P53_ORTR_CODI') is null then
      if v('P53_ORTR_SERV_TIPO') in ('RI', 'R', 'S', 'T', 'O', 'RAS', 'D') then
        raise_application_error(-20001,
                                'Tipo de servicio no valido para carga manual.');
      elsif v('P53_ORTR_SERV_TIPO') in ('I') then
        raise_application_error(-20001,
                                'Tipo de servicio no valido para carga manual. Las instalaciones de vehiculos se deben realizar en base a un Contrato!');
      end if;
    end if;
  
    if upper(v('P53_ORTR_SERV_TIPO')) not in ('I', 'RI') then
      begin
        select max(t.ortr_codi)
          into v_codi_padre
          from come_orde_trab t
         where t.ortr_vehi_codi = v('P53_ORTR_VEHI_CODI')
           and t.ortr_serv_tipo in ('I', 'RI');
      
        select t.ortr_form_insu
          into v_form_inst
          from come_orde_trab t
         where t.ortr_codi = v_codi_padre;
      exception
        when no_data_found then
          null;
      end;
      setitem('P53_ORTR_CODI_PADR', v_codi_padre);
      setitem('P53_ORTR_FORM_INSU', v_form_inst);
    
    end if;
  
    if v('P53_ORTR_VEHI_CODI') is null and v('P53_ORTR_SERV_TIPO') <> 'C' then
      raise_application_error(-20001,
                              'No esta recibiendo el codigo del vehiculo');
    
    end if;
  
    if v('P53_ORTR_MONE_CODI_PREC') is null then
      raise_application_error(-20001,
                              'El tipo de moneda esta quedando vacia');
    
    end if;
  
    if v('P53_ORTR_PREC_VENT') is null then
      raise_application_error(-20001,
                              'El precio de venta esta quedando vacio');
    
    end if;
  
    if v('P53_P_INDI_CONS') = 'N' then
      pp_validar_ots_pend;
    end if;
  
    --------------valido antes de guardar las ot 
    ---------------equipos------------------
    if v('P53_VEHI_EQUI_IMEI') is not null or
       v('P53_VEHI_EQUI_IMEI_NUEV') is not null then
    
      if v('P53_VEHI_EQUI_MODE') is null and
         v('P53_VEHI_EQUI_MODE_NUEV') is null then
      
        raise_application_error(-20001,
                                'Debe ingresar todos los Datos de Equipo Nuevo.');
      end if;
      if v('P53_VEHI_EQUI_ID') is null and
         v('P53_VEHI_EQUI_ID_NUEV') is null then
      
        raise_application_error(-20001,
                                'Debe ingresar todos los Datos de Equipo Nuevo.');
      end if;
      if v('P53_VEHI_EQUI_IMEI') is null and
         v('P53_VEHI_EQUI_IMEI_NUEV') is null then
        raise_application_error(-20001,
                                'Debe ingresar todos los Datos de Equipo Nuevo.');
      end if;
      if v('P53_VEHI_EQUI_SIM_CARD') is null and
         v('P53_VEHI_EQUI_SIM_CARD_NUEV') is null then
        raise_application_error(-20001,
                                'Debe ingresar todos los Datos de Equipo Nuevo.');
      end if;
    end if;
  
    v_ortr_codi := v('P53_ORTR_CODI');
    v_ortr_nume := v('P53_ORTR_NUME');
    v_ortr_esta := v('P53_ORTR_ESTA');
  
    if v('P53_ORTR_CODI') is null then
      ----------  pp_veri_ot;-----------------
    
      select nvl(max(to_number(ortr_nume)), 0) + 1
        into v_ortr_nume
        from come_orde_trab;
      /*v_nume := v('p53_ortr_nume');
      
      
                select count(*)
                  into v_count
                  from come_orde_trab
                 where ortr_nume = v_nume;
      
                if v_count > 0 then
      
                select nvl(max(to_number(ortr_nume)), 0) + 1
                  into v_nume
                  from come_orde_trab;
                else
                  if v('p53_ortr_nume') <> v_nume then
                  --  pl_mm('la ot ' ||v('p53_ortr_nume')  ||
                    --      ' ya existe. la nueva ot se guardar? con el n?mero ' ||
                      --    v_nume || '.');
                      null;
                  end if;
                  v_ortr_nume := v_nume;
                ---else
      
            --    v_ortr_nume :=v('p53_ortr_nume');
                end if;
      
      */
      v_ortr_esta := 'P';
    
    end if;
  
    -------------------------------------------
    setitem('P53_ORTR_ESTA', v_ortr_esta);
    setitem('P53_ORTR_NUME', v_ortr_nume);
  
    ---------------------------------------------
    v_mensaje                                := 'NRO:' || v_ortr_nume ||
                                                '</br> REGISTRO ACTUALIZADO CORRECTAMENTE
                 </br>' ||
                                                '<a href="javascript:$s(''P74_NRO_SOLI'',' ||
                                                v('P53_ORTR_CODI') ||
                                                ');">Imprimir</a> ';
    apex_application.g_print_success_message := v_mensaje;
  
    if v('P53_ORTR_SERV_TIPO') = 'IA' then
      ---instalacion de alarmas
      -- si es un vehiculo que a?n no se registro, se debe insertar en la tabla come_vehi, y asignar el id del vehiculo al campo ortr_vehi_codi
      if v('P53_ORTR_VEHI_CODI') is null then
        pp_insertar_vehiculo(v_ortr_vehi_codi);
        setitem('P53_ORTR_VEHI_CODI', v_ortr_vehi_codi);
      end if;
    end if;
  
    if v('P53_ORTR_SERV_TIPO') in ('V') then
      pp_validar_estado_vehiculo;
    end if;
  
    --a verificar
    if v_ortr_esta <> 'L' then
      pp_veri_esta(v('P53_ORTR_SERV_TIPO'));
    end if;
  
    if v('P53_ORTR_SERV_TIPO') not in ('T', 'S', 'R', 'RAS') then
      if v('P53_EMPL_CODI_ALTE_VEHI') is null then
        raise_application_error(-20001, 'Debe seleccionar un t?cnico!');
      end if;
    end if;
  
    --
  
    if v('P53_ORTR_CLPR_CODI') is not null then
      if v('P53_CLPR_EMAIL') is null then
        raise_application_error(-20001,
                                'Debe Ingresar el Email del Cliente!');
      end if;
    
      if v('P53_CLPR_EMAIL_FACT') is null then
        raise_application_error(-20001,
                                'Debe Ingresar el Email de Facturaci?n del Cliente!');
      end if;
    
      if v('P53_CLPR_EMAIL_ORIG') != v('P53_CLPR_EMAIL') and
         v('P53_ORTR_CLPR_CODI') is not null then
        update come_clie_prov
           set clpr_email = v('P53_CLPR_EMAIL')
         where clpr_codi = v('P53_ORTR_CLPR_CODI');
      end if;
    
      if v('P53_CLPR_EMAIL_FACT_ORIG') != v('P53_CLPR_EMAIL_FACT') and
         v('P53_ORTR_CLPR_CODI') is not null then
        update come_clie_prov
           set clpr_email_fact = v('P53_CLPR_EMAIL_FACT')
         where clpr_codi = v('P53_ORTR_CLPR_CODI');
      end if;
    end if;
  
    --- validar stock antes de actualizar la ot porque genera un movimiento
    if (v_ortr_esta = 'L' and nvl(v('P53_ORTR_ESTA_ORIG'), 'P') = 'P') or
       (v('P53_ORTR_ESTA_PRE_LIQU') = 'S' and
       v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'N') then
    
      pp_validar_existencia(i_lote_codi      => v('P53_VEHI_LOTE_RASTREO'),
                            i_vehi_empl_codi => v('P53_VEHI_EMPL_CODI'),
                            i_ortr_serv_tipo => v('P53_ORTR_SERV_TIPO'));
    end if;
  
    pp_guardar_orde_trab_cont;
    pp_guardar_orden_trabajo;
    pp_guardar_orde_trab_vehi;
  
    /* if fp_user = 'skn' then
        raise_application_error (-20001,v_ortr_esta||'-'||v('p53_ortr_esta_pre_liqu')||'-'||v('p53_ortr_esta_pre_liqu_orig')||'-'||v('p53_ortr_esta_orig'));
    end if;*/
  
    if (v_ortr_esta = 'L' and nvl(v('P53_ORTR_ESTA_ORIG'), 'P') = 'P') or
       (v('P53_ORTR_ESTA_PRE_LIQU') = 'S' and
       v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'N') then
    
      /*  pp_validar_existencia(i_lote_codi      => v('p53_vehi_lote_rastreo'),
      i_vehi_empl_codi => v('p53_vehi_empl_codi'),
      i_ortr_serv_tipo => v('p53_ortr_serv_tipo'));*/
      pp_valida_liqu_ot;
      pp_generar_saldev_producto;
      pp_liquida_ot;
    
    end if;
    --pl_me('aca');
  
    if (v_ortr_esta = 'P' and v('P53_ORTR_ESTA_ORIG') = 'L') or
       (v('P53_ORTR_ESTA_PRE_LIQU') = 'N' and
       v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'S') then
      pp_valida_movi_ent_sal;
      pp_valida_desliqu_ot;
      pp_desliquida_ot;
    end if;
  
    --------
    pp_actu_vehi_equi;
    --------
  
    if v('P53_SOSE_DIRE_OBSE_ORIG') <> v('P53_SOSE_DIRE_OBSE') then
      update come_soli_serv
         set sose_dire_obse = v('P53_SOSE_DIRE_OBSE')
       where sose_codi = nvl(v('P53_ORTR_SOSE_CODI'), v('P53_P_SOSE_CODI'));
    end if;
  
    if v('P53_ORTR_SERV_TIPO') in ('RI', 'I', 'T', 'N') and
       v_ortr_esta = 'L' then
      select count(*) cant
        into v_plan
        from come_orde_trab           t,
             come_soli_serv_anex      a,
             come_soli_serv_anex_deta d,
             come_soli_serv_anex_plan p
       where a.anex_codi = p.anpl_anex_codi
         and a.anex_codi = d.deta_anex_codi
         and t.ortr_deta_codi = d.deta_codi
         and t.ortr_codi = v('P53_ORTR_CODI');
    
      if v_plan = 0 then
        raise_application_error(-20001,
                                'Fallo en la generacion del plan y la factura, favor volver a liquidar');
      
      end if;
    
      if v_plan < 12 and v('P53_ORTR_SERV_TIPO') = 'I' then
        raise_application_error(-20001,
                                'Fallo en la generacion del plan y la factura, favor volver a liquidar');
      
      end if;
    end if;
  
    --  pp_llamar_reporte (v('p53_ortr_codi'), 'i020273_a');
    if v('ORTR_SERV_TIPO') in ('IA') then
      --    pp_llama_reporte_garantia;
      null;
    end if;
  
    --  if fp_user = 'skn' then
    --- raise_application_error(-20001, 'final');
  
    --  end if;
    ---raise_application_error (-20001, 'pasooooo');
  
    --------------------------------
  
    ---todas las ot liquidadas , automaticamente genera una tarjeta en ese embudo.
    /*if v_ortr_esta = 'l' then---------------se comenta hasta volver a trabajar por el ticket de seguimiento de tecnicos
      \*  update crm_neg_ticket x
        set ctn_etap_cont_cali =1,
            ctn_etap_fech_grab = sysdate,
            ctn_etap_usug_grab = fp_user
      where x.ctn_ortr_codi = v('p53_ortr_codi');*\
      -- raise_application_error(-20001, 'adf' );
      begin
        select s.ctn_codi
          into v_ortr_codi_liq
          from crm_neg_ticket s
         where s.ctn_ortr_codi = v('p53_ortr_codi');
      exception
        when no_data_found then
          null;
      end;
    
      --raise_application_error (-20001, v('p53_ortr_codi') );
      insert into crm_neg_ticket
        (ctn_codi,
         ctn_tickt_embu,
         ctn_clpr_codi,
         ctn_etap_codi,
         ctn_tipo_serv,
         ctn_codi_padr)
      values
        (v_cnt_codigo,
         3, --v_ctn_tickt_embu,
         v('p53_ortr_clpr_codi'),
         1, --v_ctn_etap_codi,
         v('p53_ortr_serv_tipo'),
         v_ortr_codi_liq);
    
      insert into crm_nego_resp_ccal
        (crmr_ticket, crmr_perg, crmr_user_grab, crmr_fech_grab)
        select v_cnt_codigo, t.crmp_codi, fp_user, sysdate
          from crm_neg_preg_ccal t;
    
    end if;*/
    /*
    if fp_user = 'skn' then
        raise_application_error (-20001,'error');
    end if;
    */
  end pp_actualizar_registro;

  procedure pp_insertar_vehiculo(p_ortr_vehi_codi out number) is
  
    v_count          number := 0;
    v_vehi_codi      number;
    v_vehi_iden      varchar2(20);
    v_vehi_iden_ante varchar2(20);
  
    v_ortr_vehi_codi number;
  begin
  
    -- v_ortr_vehi_codi := v('p53_ortr_vehi_codi');
    if v('P53_VEHI_IDEN') is null then
      if v('P53_VEHI_TIVE_CODI') is not null and
         v('P53_VEHI_MAVE_CODI') is not null then
        v_vehi_codi      := fa_sec_come_vehi;
        v_vehi_iden      := null;
        v_vehi_iden_ante := null;
      
        p_ortr_vehi_codi := v_vehi_codi;
      
        insert into come_vehi
          (vehi_codi,
           vehi_iden,
           vehi_esta,
           vehi_clpr_codi,
           vehi_clpr_sucu_nume_item,
           vehi_tive_codi,
           vehi_mave_codi,
           vehi_mode,
           vehi_anho,
           vehi_colo,
           vehi_nume_chas,
           vehi_nume_pate,
           vehi_fech_vige_inic,
           vehi_fech_vige_fini,
           vehi_iden_ante,
           vehi_base,
           vehi_user_regi,
           vehi_fech_regi,
           vehi_indi_old)
        values
          (v_vehi_codi,
           v_vehi_iden,
           'P',
           v('P53_ORTR_CLPR_CODI'),
           v('P53_ORTR_CLPR_SUCU_NUME_ITEM'),
           v('P53_VEHI_TIVE_CODI'),
           v('P53_VEHI_MAVE_CODI'),
           nvl(v('P53_VEHI_MODE'), 'S/D'),
           nvl(v('P53_VEHI_ANHO'), 'S/D'),
           nvl(v('P53_VEHI_COLO'), 'S/D'),
           nvl(v('P53_VEHI_CHAS_NUME'), 'S/D'),
           nvl(v('P53_VEHI_CHAP_NUME'), 'S/D'),
           v('P53_ORTR_FECH_EMIS'), --nvl(:bvehi.deta_fech_inic_vige, :babmc.anex_fech_emis),
           null, ---add_months(:babmc.anex_fech_emis, :babmc.sose_dura_cont) - 1,--nvl(:bvehi.deta_fech_fini_vige, :babmc.anex_fech_venc),
           v_vehi_iden_ante,
           1,
           fp_user,
           sysdate,
           'N');
      end if;
    end if;
  end pp_insertar_vehiculo;

  procedure pp_validar_estado_vehiculo is
  
    v_vehi_esta varchar2(1);
  begin
    select vehi_esta
      into v_vehi_esta
      from come_vehi
     where vehi_codi = v('P53_ORTR_VEHI_CODI');
  
    if v('P53_ORTR_CODI') is null then
      if v_vehi_esta = 'D' then
        raise_application_error(-20001,
                                'El veh?culo est? desinstalado, no se puede realizar una revisi?n!');
      end if;
    end if;
  
    if v('P53_ORTR_ESTA') = 'L' then
      if nvl(v('P53_VEHI_POLA'), 'N') = 'N' and
         nvl(v('P53_VEHI_LEVA_VIDR_ELEC'), 'N') = 'N' and
         nvl(v('P53_VEHI_RETR_ELEC'), 'N') = 'N' and
         nvl(v('P53_VEHI_LIMP_PARA_DELA'), 'N') = 'N' and
         nvl(v('P53_VEHI_LIMP_PARA_TRAS'), 'N') = 'N' and
         nvl(v('P53_VEHI_TANQ'), 'N') = 'N' and
         nvl(v('P53_VEHI_DIRE_HIDR'), 'N') = 'N' and
         nvl(v('P53_VEHI_AUTO_RADI'), 'N') = 'N' and
         nvl(v('P53_VEHI_ANTE_ELEC'), 'N') = 'N' and
         nvl(v('P53_VEHI_AIRE_ACON'), 'N') = 'N' and
         nvl(v('P53_VEHI_BLOQ_CENT'), 'N') = 'N' and
         nvl(v('P53_VEHI_ABAG'), 'N') = 'N' and
         nvl(v('P53_VEHI_FABS'), 'N') = 'N' and
         nvl(v('P53_VEHI_TAPI'), 'N') = 'N' and
         nvl(v('P53_VEHI_ALAR'), 'N') = 'N' and
         nvl(v('P53_VEHI_BOCI'), 'N') = 'N' and
         nvl(v('P53_VEHI_LAVA_FARO'), 'N') = 'N' and
         nvl(v('P53_VEHI_LLAN'), 'N') = 'N' and
         nvl(v('P53_VEHI_CENT'), 'N') = 'N' and
         nvl(v('P53_VEHI_CHAP'), 'N') = 'N' and
         nvl(v('P53_VEHI_PINT'), 'N') = 'N' and
         nvl(v('P53_VEHI_LALT'), 'N') = 'N' and
         nvl(v('P53_VEHI_LBAJ'), 'N') = 'N' and
         nvl(v('P53_VEHI_LREV'), 'N') = 'N' and
         nvl(v('P53_VEHI_LGIR'), 'N') = 'N' and
         nvl(v('P53_VEHI_LPOS'), 'N') = 'N' and
         nvl(v('P53_VEHI_LINT'), 'N') = 'N' and
         nvl(v('P53_VEHI_LSTO'), 'N') = 'N' and
         nvl(v('P53_VEHI_LEST'), 'N') = 'N' and
         nvl(v('P53_VEHI_LTAB'), 'N') = 'N' then
        raise_application_error(-20001,
                                'Se debe verificar al menos una de las caracter?sticas del veh?culo!');
      end if;
    
      if rtrim(ltrim(nvl(v('P53_VEHI_MODE'), 'S/D'))) = 'S/D' or
        /*rtrim(ltrim(nvl(v('p53_vehi_anho'), 's/d'))) = 's/d' or*/
         rtrim(ltrim(nvl(v('P53_VEHI_CHAS_NUME'), 'S/D'))) = 'S/D' or
        -- rtrim(ltrim(nvl(v('p53_vehi_chap_nume'),'s/d'))) = 's/d' or
         rtrim(ltrim(nvl(v('P53_VEHI_COLO'), 'S/D'))) = 'S/D' then
        raise_application_error(-20001,
                                'Se debe verificar que los datos del modelo, a?o, chasis, chapa y color del veh?culo est?n completos!');
      end if;
    end if;
  
    ---se asigna codigo de detalle de anexo, del anexo donde esta el vehiculo verificado
    if v('P53_ORTR_DETA_CODI_VERI') is not null then
    
      setitem('P53_ORTR_DETA_CODI', v('P53_ORTR_DETA_CODI_VERI'));
      --:bcab.ortr_deta_codi := v('p53_ortr_deta_codi_veri');
    end if;
  
  exception
    when no_data_found then
      null;
  end pp_validar_estado_vehiculo;

  procedure pp_veri_esta(p_tipo_serv in varchar2) is
  
    v_vehi_esta varchar2(1);
    v_count     number := 0;
  
  begin
    select count(vehi_codi)
      into v_count
      from come_vehi v
     where vehi_iden = v('P53_VEHI_IDEN')
       and nvl(vehi_esta, 'P') = 'I'
       and (vehi_codi <> v('P53_ORTR_VEHI_CODI') or
           v('P53_ORTR_VEHI_CODI') is null);
  
    if v('P53_ORTR_CODI') is not null then
      select v.vehi_esta
        into v_vehi_esta
        from come_vehi v
       where vehi_codi = v('P53_ORTR_VEHI_CODI');
    else
      if v('P53_ORTR_VEHI_CODI') is not null then
        select v.vehi_esta
          into v_vehi_esta
          from come_vehi v
         where vehi_codi = v('P53_ORTR_VEHI_CODI');
      else
        select v.vehi_esta
          into v_vehi_esta
          from come_vehi v
         where vehi_iden = v('P53_VEHI_IDEN');
      end if;
    end if;
  
    /*if p_tipo_serv in ('i', 'ri') then
      if v_vehi_esta = 'i' then
         pl_me('el estado del vehiculo es instalado, no puede crear una orden de instalaci?n o reinstalaci?n.');
       end if;
       ---a verificar
    elsif p_tipo_serv in ('d') then
       if v_vehi_esta = 'd' then
          pl_me('el estado del vehiculo es desinstalado, no puede crear una orden de desinstalaci?n.');
       else
          if :bcab.s_sode_nume is null then
            pl_me('no puede realizar una orden de desinstalac?n sin una solicitud.');
          end if;
       end if;
    end if;*/
  
    if p_tipo_serv not in ('V', 'RI') then
      --se agrego para que no salte este mensaje en las verificaciones a vehiculos que anteriormente se generaban varias veces.
      --actualmente ya no se generan varios codigos para un mismo vehiculo,por ello el identificador ya no se repite.
      if v_count > 0 then
        raise_application_error(-20001,
                                'El identificador est? asignado a m?s de un veh?culo!');
      end if;
    end if;
  
  exception
    when no_data_found then
      null;
  end pp_veri_esta;

  procedure pp_valida_liqu_ot is
    v_anex_impo_mone number := 0;
    v_cant_vehi_rein number := 0;
  begin
  
    --------pp_valida_fecha_liquidacion-------------------
    if v('P53_ORTR_FECH_INST') not between v('P53_P_FECH_INIC') and
       v('P53_P_FECH_FINI') then
      raise_application_error(-20001,
                              'La OT no puede ser liquidada, el periodo est? cerrado!');
    end if;
  
    if v('P53_ORTR_SERV_TIPO') = 'D' then
      if nvl(v('P53_SODE_ESTA'), 'P') = 'P' then
        raise_application_error(-20001,
                                'La solicitud de Desinstalaci?n debe estar autorizada!');
      end if;
    
      begin
        select anex_impo_mone
          into v_anex_impo_mone
          from come_soli_serv_anex, come_soli_serv_anex_deta
         where anex_codi = deta_anex_codi
           and deta_codi =
               (select sode_deta_codi
                  from come_soli_desi
                 where sode_codi = v('P53_ORTR_SODE_CODI'));
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'Verificar datos que relacionan Solicitud de Desinstalaci?n con Anexo donde est? el Vehiculo a desinstalar.');
      end;
    
      if nvl(v_anex_impo_mone, 0) <= 0 then
        raise_application_error(-20001,
                                'Verificar dato de importe en el Anexo donde est? vehiculo que ser? desinstalado.');
      end if;
    
    elsif v('P53_ORTR_SERV_TIPO') = 'RI' then
      --------- pp_vali_vehi_rein-------------
      select count(*)
        into v_cant_vehi_rein
        from come_orde_trab
       where ortr_codi = v('P53_ORTR_CODI')
         and ortr_vehi_codi is not null;
    
      if v_cant_vehi_rein <= 0 then
        raise_application_error(-20001,
                                'No se puede realizar Liquidaci?n de la OT de Reinstalaci?n, a?n no se asigno el vehiculo.');
      end if;
    
    end if;
  
    if v('P53_P_USER_INDI_MODI_DATO_VEHI') = 'S' or
       v('P53_ORTR_SERV_TIPO NOT') in ('D', 'V') then
      if v('P53_VEHI_CHAS_NUME') is null then
        raise_application_error(-20001,
                                'Debe ingresar un chasis al veh?culo!');
      end if;
      if v('P53_VEHI_CHAP_NUME') is null then
        raise_application_error(-20001,
                                'Debe ingresar una chapa al veh?culo!');
      end if;
    end if;
  
    if v('P53_ORTR_FECH_INST') is null then
      -- v('p53_ortr_fech_inst') := nvl(v('p53_ortr_fech_liqu'), v('p53_ortr_fech_emis');
      setitem('P53_ORTR_FECH_INST',
              nvl(v('P53_ORTR_FECH_LIQU'), v('P53_ORTR_FECH_EMIS')));
    end if;
  
    if v('P53_ORTR_FECH_LIQU') is null and v('P53_ORTR_ESTA') = 'L' then
      -- v('p53_ortr_fech_inst') := nvl(v('p53_ortr_fech_liqu'), v('p53_ortr_fech_emis');
      setitem('P53_ORTR_FECH_LIQU', nvl(v('P53_ORTR_FECH_INST'), sysdate));
    end if;
  
    if v('P53_ORTR_LUGA_INST') is null then
      raise_application_error(-20001,
                              'Debe asignar un lugar donde se realiz? el Trabajo!');
    end if;
    if v('P53_ORTR_SERV_OBSE') is null then
      raise_application_error(-20001,
                              'Debe ingresar las observaciones del Trabajo!');
    end if;
  
    ---------------equipos------------------
    if v('P53_ORTR_SERV_TIPO') in ('T', 'S', 'RAS', 'R', 'I') or
       (v('P53_ORTR_SERV_TIPO') = 'RI' and
        (v('P53_ORTR_ESTA') = 'L' and v('P53_ORTR_ESTA_ORIG') = 'P')) then
    
      if v('P53_VEHI_EQUI_MODE') is null and
         v('P53_VEHI_EQUI_MODE_NUEV') is null then
      
        raise_application_error(-20001,
                                'Debe ingresar todos los Datos de Equipo Nuevo.');
      end if;
      if v('P53_VEHI_EQUI_ID') is null and
         v('P53_VEHI_EQUI_ID_NUEV') is null then
      
        raise_application_error(-20001,
                                'Debe ingresar todos los Datos de Equipo Nuevo.');
      end if;
      if v('P53_VEHI_EQUI_IMEI') is null and
         v('P53_VEHI_EQUI_IMEI_NUEV') is null then
        raise_application_error(-20001,
                                'Debe ingresar todos los Datos de Equipo Nuevo.');
      end if;
      if v('P53_VEHI_EQUI_SIM_CARD') is null and
         v('P53_VEHI_EQUI_SIM_CARD_NUEV') is null then
        raise_application_error(-20001,
                                'Debe ingresar todos los Datos de Equipo Nuevo.');
      end if;
    end if;
  
  end pp_valida_liqu_ot;

  procedure pp_liquida_ot is
  
    --cursor para cambiar estado de plan, cuando se realiza desinstalacion
    cursor c_plan(p_ortr_deta_codi in number) is
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_deta_codi = p_ortr_deta_codi;
  
    cursor c_plan_mini(p_ortr_deta_codi in number) is
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_nume_item > nvl(v('P53_P_INDI_DURA_MINI_CONT'), 8) + 2 --(2 meses de pre aviso)
         and ap.anpl_deta_codi = p_ortr_deta_codi;
  
    cursor c_plan_mini_sin_pre(p_ortr_deta_codi in number) is -- sin pre aviso
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_nume_item > nvl(v('P53_P_INDI_DURA_MINI_CONT'), 8)
         and ap.anpl_deta_codi = p_ortr_deta_codi;
  
    --cursor para cambiar estado de plan, cuando se realizan cambios de tit., seguro a rpy, seguro a seguro, rpy a seguro, reinstalacion
    cursor c_plan_cambio(p_ortr_deta_codi in number) is
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_deta_codi =
             (select d.deta_codi_anex_padr
                from come_soli_serv_anex_deta d
               where d.deta_codi = p_ortr_deta_codi);
  
    cursor c_plan_reno(p_ortr_deta_codi in number, p_nume_item in number) is
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_nume_item > p_nume_item + 2 --plan maximo + 2 meses por no llegar a la permanencia minima
         and ap.anpl_deta_codi = p_ortr_deta_codi;
  
    cursor c_plan_reno_fact(p_ortr_deta_codi in number,
                            p_nume_item      in number) is
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_nume_item <= p_nume_item + 2 --cambiaran fecha de facturacion los meses pendientes menores al plan maximo + 2 meses por no llegar a la permanencia minima
         and ap.anpl_deta_codi = p_ortr_deta_codi;
  
    cursor c_anex is ----- cursor de anexo para generar el plan
      select a.anex_codi,
             a.anex_fech_venc,
             a.anex_dura_cont,
             a.anex_cant_cuot_modu,
             a.anex_impo_mone_unic,
             a.anex_prec_unit,
             s.sose_tipo_fact,
             c.clpr_dia_tope_fact,
             'N' cuot_inic,
             nvl(cl.clas1_dias_venc_fact, 5) clas1_dias_venc_fact,
             a.anex_empr_codi,
             s.sose_sucu_nume_item,
             0 mone_cant_deci,
             a.anex_indi_fact_impo_unic,
             a.anex_cifa_codi,
             a.anex_cifa_tipo,
             a.anex_cifa_dia_fact,
             a.anex_cifa_dia_desd,
             a.anex_cifa_dia_hast,
             a.anex_aglu_cicl
        from come_soli_serv_anex      a,
             come_soli_serv_anex_deta d,
             come_soli_serv           s,
             come_clie_prov           c,
             come_clie_clas_1         cl
       where a.anex_sose_codi = s.sose_codi
         and c.clpr_indi_clie_prov = 'C'
         and s.sose_clpr_codi = c.clpr_codi
         and c.clpr_clie_clas1_codi = cl.clas1_codi
         and a.anex_codi = d.deta_anex_codi
         and d.deta_codi = v('P53_ORTR_DETA_CODI')
       group by a.anex_codi,
                a.anex_fech_venc,
                a.anex_dura_cont,
                a.anex_cant_cuot_modu,
                a.anex_impo_mone_unic,
                a.anex_prec_unit,
                s.sose_tipo_fact,
                c.clpr_dia_tope_fact,
                nvl(cl.clas1_dias_venc_fact, 5),
                a.anex_empr_codi,
                s.sose_sucu_nume_item,
                a.anex_indi_fact_impo_unic,
                a.anex_cifa_codi,
                a.anex_cifa_tipo,
                a.anex_cifa_dia_fact,
                a.anex_cifa_dia_desd,
                a.anex_cifa_dia_hast,
                a.anex_aglu_cicl;
    ----------------------------------------------------------------------
  
    cursor c_fact is ------------cursor paga generar la factura
      select s.sose_clpr_codi,
             a.anex_cifa_codi,
             s.sose_codi,
             s.sose_nume,
             a.anex_codi,
             s.sose_tipo_fact,
             'A' agru_anex,
             (t.ortr_fech_inst) fech_fact_desd,
             (t.ortr_fech_inst) fech_fact_hast,
             (t.ortr_fech_inst) movi_fech_emis,
             1 sucu_codi,
             1 depo_codi,
             c.clpr_clie_clas1_codi clas1_codi,
             0 anpl_impo_reca_red_cobr,
             'N' indi_excl_clie_clas1_aseg,
             null v_faau_codi,
             null v_codresp,
             null v_descresp,
             d.deta_indi_prom_pror
        from come_soli_serv           s,
             come_soli_serv_anex      a,
             come_soli_serv_anex_deta d,
             come_orde_trab           t,
             come_clie_prov           c
       where s.sose_codi = a.anex_sose_codi
         and a.anex_codi = d.deta_anex_codi
         and d.deta_codi = t.ortr_deta_codi
         and s.sose_clpr_codi = c.clpr_codi
         and t.ortr_codi = v('P53_ORTR_CODI');
  
    -- cursor para dar de baja los servicios de grua relacionados
    cursor c_grua(p_c_deta_codi in number) is
      select dh.deta_codi, v.vehi_codi
        from come_soli_serv_anex_deta dh,
             come_soli_serv_anex_deta dp,
             come_vehi                v
       where dh.deta_codi_anex_padr = dp.deta_codi
         and dp.deta_vehi_codi = v.vehi_codi(+)
         and dh.deta_conc_codi = v('P53_P_CONC_CODI_ANEX_GRUA_VEHI')
         and dp.deta_codi = p_c_deta_codi
       order by dh.deta_codi, v.vehi_codi;
  
    ----------------------------------------------------------------------
  
    v_sose_tipo varchar2(2);
    v_nume_item number;
  
    --variables para generacion de plan y factura automatica
  
    v_codresp   number;
    v_descresp  varchar2(1000);
    v_faau_codi number;
    v_user_codi number;
  
    v_plan         number;
    v_cant_padr    number;
    v_ortr_nume    varchar2(20);
    v_movi_codi    number;
    v_nume_item_ri number := 0;
  
    tiempo_inicial   timestamp;
    tiempo_actual    timestamp;
    espera           number;
    tiempo_espera    number := 3; -- variable para controlar el tiempo de espera en segundos
    intervalo        interval day to second; -- variable para almacenar el intervalo de tiempo
    v_fech_fact_desd date;
    v_fech_fact_hast date;
    v_anex_codi      NUMBER;
  begin
  
    ---si es desinstalacion
    if v('P53_ORTR_SERV_TIPO') = 'D' then
      if nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') = 'R' then
        --reinstalacion, reinstalacion al instante
        --genera anexo de reinstalacion en contrato donde estaba instalado el vehiculo
        pp_generar_anex_desi;
      elsif nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') = 'RN' then
        --reinstalacion al instante
        begin
          select count(*)
            into v_cant_padr
            from come_soli_serv_anex      a,
                 come_soli_serv_anex_deta d,
                 come_soli_serv_anex_deta dd
           where a.anex_codi = d.deta_anex_codi
             and a.anex_tipo in ('RN', 'RI')
             and d.deta_anex_codi_padr = dd.deta_anex_codi
             and dd.deta_codi = v('P53_ORTR_DETA_CODI');
        exception
          when others then
            v_cant_padr := 0;
        end;
      
        --si no se ha generado el anexo para reinstalaci?n
        if v_cant_padr = 0 then
          pp_generar_anex_desi;
        end if;
      
      elsif nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') = 'RF' then
        --reinstalacion a futuro
        --ya cambia todos los indicadores del plan para no facturar
        for x in c_plan(v('P53_ORTR_DETA_CODI')) loop
          update come_soli_serv_anex_plan ap
             set ap.anpl_deta_esta_plan = 'N',
                 ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
           where ap.anpl_codi = x.anpl_codi;
        end loop;
      
        --indicador si se genero pre-anexo por reinstalacion a futuro
      
        setitem('P53_ORTR_INDI_REIN_FUTU_GENE', 'N');
      
      elsif nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') not in
            ( /*'RN'*/ 'R', 'RF', 'FM', 'FR') then
        --reinstalacion al instante
        begin
          select nvl(sose_tipo, 'I')
            into v_sose_tipo
            from come_soli_serv s
           where s.sose_codi =
                 (select anex_sose_codi
                    from come_soli_serv_anex a
                   where a.anex_codi =
                         (select deta_anex_codi
                            from come_soli_serv_anex_deta d
                           where d.deta_codi = v('P53_ORTR_DETA_CODI')));
        exception
          when others then
            raise_application_error(-20001,
                                    'Favor verifique la Solicitud, del detalle de Anexo del vehiculo a Desinstalar.');
        end;
      
        --si la desinstalacion no es a un vehiculo renovado.
        if nvl(v_sose_tipo, 'I') <> 'N' then
          --verifica parametro si se aplicara permanencia minima o no
          if nvl(v('P53_P_INDI_DESI_CON_DURA_MINI'), 'N') = 'S' then
          
            if nvl(v('P53_P_INDI_DIAS_PRE_AVISO'), 'S') = 'S' then
              --cambia indicador en tabla de plan de facturacion, para que el panel ya no tenga en cuenta
              --las cuotas de meses superiores al minimo requerido
              for x in c_plan_mini(v('P53_ORTR_DETA_CODI')) loop
                update come_soli_serv_anex_plan ap
                   set ap.anpl_deta_esta_plan = 'N',
                       ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
                 where ap.anpl_codi = x.anpl_codi;
              end loop;
            else
              --cambia indicador en tabla de plan de facturacion, para que el panel ya no tenga en cuenta
              --las cuotas de meses superiores al minimo requerido
              for x in c_plan_mini_sin_pre(v('P53_ORTR_DETA_CODI')) loop
                update come_soli_serv_anex_plan ap
                   set ap.anpl_deta_esta_plan = 'N',
                       ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
                 where ap.anpl_codi = x.anpl_codi;
              end loop;
            end if;
          
          else
            for x in c_plan(v('P53_ORTR_DETA_CODI')) loop
              update come_soli_serv_anex_plan ap
                 set ap.anpl_deta_esta_plan = 'N',
                     ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
               where ap.anpl_codi = x.anpl_codi;
            end loop;
          end if;
        
        else
          begin
            select max(ap.anpl_nume_item)
              into v_nume_item
              from come_soli_serv_anex_plan ap
             where (ap.anpl_movi_codi is not null and
                   nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
               and ap.anpl_deta_codi = v('P53_ORTR_DETA_CODI');
          
            -----------------27/09/2022 no estaba teniendo en cuenta la instalacion anterior
            -----------que se da haber una reinstalacion..
          
            select max(t.anpl_nume_item)
              into v_nume_item_ri
              from come_soli_serv_anex_plan t
             where anpl_indi_fact = 'S'
               and anpl_deta_esta_plan = 'S'
               and (anpl_anex_codi || '-' || t.anpl_deta_codi) in
                   (select deta_anex_codi_padr || '-' || deta_codi_anex_padr --, a.anex_codi
                      from come_soli_desi,
                           come_soli_serv,
                           come_soli_serv_anex      a,
                           come_soli_serv_anex_deta d,
                           come_vehi
                     where sode_vehi_codi = vehi_codi
                       and vehi_codi = deta_vehi_codi
                       and deta_anex_codi = anex_codi
                          
                       and anex_sose_codi = sose_codi
                       and sode_nume = v('P53_SODE_NUME'));
          
          exception
            when others then
              v_nume_item := 1;
          end;
        
          v_nume_item := v_nume_item + nvl(v_nume_item_ri, 0);
        
          --  raise_application_error (-20001, v_nume_item);
          --si alcanzo o supero la permanencia minima , o si parametro de las renovaciones tendran permanencia minima es 'n'
          --ya cambia todos los indicadores del plan para no facturar
          --sino se debe facturar 2 meses m?s, y la fecha de facturaci?n pasa a ser la de la liquidacion de la ot..si hay mas planes cambian para no facturar
          if v_nume_item >= nvl(v('P53_P_INDI_DURA_MINI_CONT'), 8) or
             nvl(v('P53_P_INDI_DESI_RENO_DURA_MINI'), 'S') = 'N' then
          
            for x in c_plan(v('P53_ORTR_DETA_CODI')) loop
              update come_soli_serv_anex_plan ap
                 set ap.anpl_deta_esta_plan = 'N',
                     ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
               where ap.anpl_codi = x.anpl_codi;
            end loop;
          else
          
            for x in c_plan_reno(v('P53_ORTR_DETA_CODI'), v_nume_item) loop
              update come_soli_serv_anex_plan ap
                 set ap.anpl_deta_esta_plan = 'N',
                     ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
               where ap.anpl_codi = x.anpl_codi;
            end loop;
          
            for x in c_plan_reno_fact(v('P53_ORTR_DETA_CODI'), v_nume_item) loop
              update come_soli_serv_anex_plan ap
                 set ap.anpl_fech_fact = trunc(to_date(v('P53_ORTR_FECH_INST'))),
                     ap.anpl_fech_venc = trunc(to_date(v('P53_ORTR_FECH_INST')) + 6),
                     ap.anpl_ortr_codi = v('P53_ORTR_CODI')
               where ap.anpl_codi = x.anpl_codi;
            end loop;
          
          end if;
        end if;
      
        select min(a.anpl_fech_desd),
               max(a.anpl_fech_hast),
               max(a.anpl_anex_codi)
          into v_fech_fact_desd, v_fech_fact_hast, v_anex_codi
          from come_soli_serv_anex_plan a
         where a.anpl_deta_codi = v('P53_ORTR_DETA_CODI')
           and a.anpl_indi_fact = 'N'
           and a.anpl_deta_esta_plan = 'S'
           and a.anpl_nume_item <= 8;
      
        if v_fech_fact_desd is not null and v_fech_fact_hast is not null then
        
          begin
            --busca usuario
            select user_codi
              into v_user_codi
              from segu_user
             where user_login = fp_user;
          end;
        
          pack_fact_ciclo.pa_gene_plan_fact_movi(p_clpr_codi          => v('P53_ORTR_CLPR_CODI'),
                                                 p_cifa_codi          => null,
                                                 p_sose_codi          => null,
                                                 p_sose_nume          => null,
                                                 p_anex_codi          => v_anex_codi,
                                                 p_tipo_fact          => 'A',
                                                 p_agru_anex          => 'C',
                                                 p_fech_fact_desd     => v_fech_fact_desd,
                                                 p_fech_fact_hast     => v_fech_fact_hast,
                                                 p_movi_fech_emis     => trunc(sysdate),
                                                 p_peco_codi          => 0,
                                                 p_user_codi          => v_user_codi,
                                                 p_sucu_codi          => 1,
                                                 p_depo_codi          => 1,
                                                 p_clas1_codi         => null,
                                                 p_impo_reca_red_cobr => 0,
                                                 p_indi_excl_aseg     => 'N',
                                                 p_faau_codi          => v_faau_codi,
                                                 p_codResp            => v_codResp,
                                                 p_descResp           => v_descResp,
                                                 p_movicodi           => v_movi_codi);
        
          if nvl(v_codresp, 1) = 1 then
            --  env_fact_sifen.pp_get_json_fact(v_movi_codi);
          
            begin
            
              --     i020273_a.pp_enviar_sms_fact(p_movi_codi => v_movi_codi);
              NULL;
            end;
          
            update come_soli_serv_anex_plan a
               set a.anpl_obse      = 'Facturacion Automatica por permanencia minima',
                   a.anpl_ortr_codi = v('P53_ORTR_CODI')
             where a.anpl_deta_codi = v('P53_ORTR_DETA_CODI')
                  /*   and a.anpl_indi_fact = 'N'
                  and a.anpl_deta_esta_plan  ='S'*/
               and anpl_fech_desd >= v_fech_fact_desd
               and anpl_fech_hast <= v_fech_fact_hast
               and a.anpl_nume_item <= 8;
          
          else
            raise_application_error(-20001, v_descresp);
          end if;
        
        end if;
      
      end if;
    
      if nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') in ('FM', 'FR') then
      
        begin
          -- call the procedure
          pack_fact_arti.pp_actualizar_registro(p_cliente   => v('P53_ORTR_CLPR_CODI'),
                                                p_tipo_desc => nvl(v('P53_ORTR_SERV_TIPO_MOTI'),
                                                                   'N'),
                                                p_ortr_codi => v('P53_ORTR_CODI'));
        end;
      
        if nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') in ('FR') then
          for x in c_plan(v('P53_ORTR_DETA_CODI')) loop
            update come_soli_serv_anex_plan ap
               set ap.anpl_deta_esta_plan = 'N',
                   ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
             where ap.anpl_codi = x.anpl_codi;
          end loop;
        end if;
      
      end if;
      -- dar de baja los servicios de grua
      for k in c_grua(v('P53_ORTR_DETA_CODI')) loop
        if nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') not in ('R', 'RN') then
          --reinstalacion, reinstalacion al instante
          update come_soli_serv_anex_deta d
             set d.deta_esta_plan = 'N'
           where deta_codi = k.deta_codi;
        
          update come_soli_serv_anex_plan p
             set p.anpl_deta_esta_plan = 'N'
           where p.anpl_deta_codi = k.deta_codi
             and p.anpl_indi_fact = 'N';
        end if;
      
        if k.vehi_codi is not null then
          update come_vehi v
             set v.vehi_indi_grua = 'N'
           where v.vehi_codi = k.vehi_codi
             and v.vehi_indi_grua = 'S';
        end if;
      end loop;
    
      update come_vehi
         set vehi_esta = 'D'
       where vehi_codi = v('P53_ORTR_VEHI_CODI');
    
      update come_soli_serv_anex_deta
         set deta_esta = 'D'
       where deta_codi = v('P53_ORTR_DETA_CODI');
      --  raise_application_Error(-20001, v('P53_ORTR_SERV_TIPO')||'//'|| nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N')||'/'||v('P53_ORTR_DETA_CODI'));
    else
      --si no es desinstalacion
    
      --si es instalacion
    
      if v('P53_ORTR_SERV_TIPO') in ('I') then
      
        update come_vehi
           set vehi_esta = 'I'
         where vehi_codi = v('P53_ORTR_VEHI_CODI');
      
        update come_soli_serv_anex_deta
           set deta_esta = 'I'
         where deta_codi = v('P53_ORTR_DETA_CODI');
        begin
        
          pack_gene_nota_cred_refe.pp_gene_nota_cred_refe(p_ortr_codi => v('P53_ORTR_CODI'),
                                                          p_faau_codi => v_faau_codi);
        end;
        if nvl(v('P53_P_INDI_GENE_PLAN_LIQU_OT'), 'N') = 'S' then
        
          --- si el parametro esta en s para alarmas
          begin
            --- verifica si ya tiene plan para generar al liquidar la ot
          
            select count(*) cant
              into v_plan
              from come_orde_trab           t,
                   come_soli_serv_anex      a,
                   come_soli_serv_anex_deta d,
                   come_soli_serv_anex_plan p
             where a.anex_codi = p.anpl_anex_codi
               and a.anex_codi = d.deta_anex_codi
               and t.ortr_deta_codi = d.deta_codi
               and t.ortr_codi = v('P53_ORTR_CODI');
          
          exception
            when others then
              v_plan := 0;
          end;
        
          if v_plan = 0 then
          
            -- procedimiento para generar el plan
            for x in c_anex loop
              begin
              
                pack_fact_ciclo.pa_generar_detalle_plan(x.anex_codi,
                                                        to_date(v('P53_ORTR_FECH_INST')) - 1, --se envia con fecha - 1 porque el proceso que usa hace fecha + 1
                                                        x.anex_dura_cont,
                                                        x.anex_cant_cuot_modu,
                                                        x.anex_impo_mone_unic,
                                                        x.anex_prec_unit,
                                                        x.sose_tipo_fact,
                                                        x.clpr_dia_tope_fact,
                                                        x.cuot_inic,
                                                        x.clas1_dias_venc_fact,
                                                        x.anex_empr_codi,
                                                        x.sose_sucu_nume_item,
                                                        x.mone_cant_deci,
                                                        x.anex_indi_fact_impo_unic,
                                                        x.anex_cifa_codi,
                                                        x.anex_cifa_tipo,
                                                        x.anex_cifa_dia_fact,
                                                        x.anex_cifa_dia_desd,
                                                        x.anex_cifa_dia_hast,
                                                        x.anex_aglu_cicl);
              
              end;
            end loop;
          end if;
        
          ------------------------ genera la factura automatica
          begin
            --busca usuario
            select user_codi
              into v_user_codi
              from segu_user
             where user_login = fp_user;
          end;
        
          for x in c_fact loop
            begin
            
              -----------lv, si se ejecuta al mismo tiempo duplica el nro de factura 
              -----------agregue un intervalo de tiempo aleatorio para que de tiempo entre ambos
              begin
                tiempo_inicial := systimestamp; -- obtener la marca de tiempo inicial
                intervalo      := numtodsinterval(tiempo_espera, 'SECOND'); -- convertir segundos a un intervalo de tiempo
                loop
                  tiempo_actual := systimestamp; -- obtener la marca de tiempo actual
                  exit when(tiempo_actual - tiempo_inicial) >= intervalo; -- salir del bucle despu?s de x segundos
                end loop;
              end;
            
              ---     raise_application_error (-20001,x.sucu_codi||'--'||x.sucu_codi||'--'||x.clas1_codi||'-'||x.sose_tipo_fact );
            
              pack_fact_ciclo.pa_gene_plan_fact_movi(x.sose_clpr_codi,
                                                     x.anex_cifa_codi,
                                                     x.sose_codi,
                                                     x.sose_nume,
                                                     x.anex_codi,
                                                     x.sose_tipo_fact,
                                                     x.agru_anex,
                                                     x.fech_fact_desd,
                                                     x.fech_fact_hast,
                                                     x.movi_fech_emis,
                                                     v('P53_P_PECO_CODI'),
                                                     v_user_codi,
                                                     x.sucu_codi,
                                                     x.depo_codi,
                                                     x.clas1_codi,
                                                     x.anpl_impo_reca_red_cobr,
                                                     x.indi_excl_clie_clas1_aseg,
                                                     v_faau_codi,
                                                     v_codresp,
                                                     v_descresp,
                                                     v_movi_codi);
            
              -- si v_codresp es distinto a 1 significa que ocurri? una excepcion
            
              if nvl(v_codresp, 1) = 1 then
                env_fact_sifen.pp_get_json_fact(v_movi_codi);
              
                begin
                
                  i020273_a.pp_enviar_sms_fact(p_movi_codi => v_movi_codi);
                
                end;
              
                /*              begin
                  -- call the procedure
                  if nvl(x.deta_indi_prom_pror,'n')='s' then
                    pa_ gene_nota_cred_pror(p_clave_fact => v_movi_codi,
                                             p_clave_ot   => v('p53_ortr_codi'));
                  end if;
                end;*/
              
              else
                raise_application_error(-20001, v_descresp);
              end if;
            
            end;
          end loop;
          update come_vehi
             set vehi_iden                = v('P53_ORTR_VEHI_IDEN'),
                 vehi_clpr_codi           = v('P53_ORTR_CLPR_CODI'),
                 vehi_clpr_sucu_nume_item = v('P53_ORTR_CLPR_SUCU_NUME_ITEM'),
                 vehi_iden_ante           = v('P53_ORTR_VEHI_IDEN_ANTE')
           where vehi_codi = v('P53_ORTR_VEHI_CODI');
        
          ----------------genera la nota de creito
          --  pa_ gene_nota_cred_refe(v('p53_ortr_codi'), v_faau_codi);
        
        end if;
      
        --t= camb titularidad, r= camb seguro a rpy, s= camb seguro a seguro, ras= camb rpy a seguro
      elsif v('P53_ORTR_SERV_TIPO') in ('T', 'R', 'S', 'RAS') then
        if ((v('P53_ORTR_ESTA') = 'L' and v('P53_ORTR_ESTA_ORIG') = 'P') and
           v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'N') or
           (v('P53_ORTR_ESTA_PRE_LIQU') = 'S' and
           v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'N') then
        
          --    v('p53_ortr_esta_pre_liqu') := 's';
          setitem('P53_ORTR_ESTA_PRE_LIQU', 'S');
          update come_soli_serv_anex_deta
             set deta_esta = 'I'
           where deta_codi = v('P53_ORTR_DETA_CODI');
        
          update come_soli_serv_anex_deta
             set deta_esta = 'D'
           where deta_codi =
                 (select d.deta_codi_anex_padr
                    from come_soli_serv_anex_deta d
                   where d.deta_codi = v('P53_ORTR_DETA_CODI'));
        
          for x in c_plan_cambio(v('P53_ORTR_DETA_CODI')) loop
            update come_soli_serv_anex_plan ap
               set ap.anpl_deta_esta_plan = 'N',
                   ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
             where ap.anpl_codi = x.anpl_codi;
          end loop;
        
          pp_generar_desi_ot;
        
          --debe actualizar datos del vehiculo, que puede ser iden, cliente, asegurado
          update come_vehi
             set vehi_iden                = v('P53_ORTR_VEHI_IDEN'),
                 vehi_clpr_codi           = v('P53_ORTR_CLPR_CODI'),
                 vehi_clpr_sucu_nume_item = v('P53_ORTR_CLPR_SUCU_NUME_ITEM'),
                 vehi_iden_ante           = v('P53_ORTR_VEHI_IDEN_ANTE')
           where vehi_codi = v('P53_ORTR_VEHI_CODI');
        end if;
      
        ----------****
        --cambio de titularidad
      
        if v('P53_ORTR_SERV_TIPO') = 'T' then
          -- raise_application_error(-20001, 'titulalridad 1');
        
          if nvl(v('P53_P_INDI_GENE_PLAN_LIQU_OT'), 'N') = 'S' then
            --- si el parametro esta en s para alarmas
          
            --verifica si ya tiene plan para generar al liquidar la ot
            begin
              select count(*) cant
                into v_plan
                from come_orde_trab           t,
                     come_soli_serv_anex      a,
                     come_soli_serv_anex_deta d,
                     come_soli_serv_anex_plan p
               where a.anex_codi = p.anpl_anex_codi
                 and a.anex_codi = d.deta_anex_codi
                 and t.ortr_deta_codi = d.deta_codi
                 and t.ortr_codi = v('P53_ORTR_CODI');
            
            exception
              when others then
                v_plan := 0;
            end;
          
            if v_plan = 0 then
              --procedimiento para generar el plan
              for x in c_anex loop
              
                begin
                
                  pack_fact_ciclo.pa_generar_detalle_plan(x.anex_codi,
                                                          to_date(v('P53_ORTR_FECH_INST')) - 1, --se envia con fecha - 1 porque el proceso que usa hace fecha + 1
                                                          x.anex_dura_cont,
                                                          x.anex_cant_cuot_modu,
                                                          x.anex_impo_mone_unic,
                                                          x.anex_prec_unit,
                                                          x.sose_tipo_fact,
                                                          x.clpr_dia_tope_fact,
                                                          x.cuot_inic,
                                                          x.clas1_dias_venc_fact,
                                                          x.anex_empr_codi,
                                                          x.sose_sucu_nume_item,
                                                          x.mone_cant_deci,
                                                          x.anex_indi_fact_impo_unic,
                                                          x.anex_cifa_codi,
                                                          x.anex_cifa_tipo,
                                                          x.anex_cifa_dia_fact,
                                                          x.anex_cifa_dia_desd,
                                                          x.anex_cifa_dia_hast,
                                                          x.anex_aglu_cicl);
                
                  /* pack_fact_ciclo.pa_generar_detalle_plan(x.anex_codi,
                  to_date(v('p53_ortr_fech_inst')) - 1, --se envia con fecha - 1 porque el proceso que usa hace fecha + 1
                  x.anex_dura_cont,
                  x.anex_cant_cuot_modu,
                  x.anex_impo_mone_unic,
                  x.anex_prec_unit,
                  x.sose_tipo_fact,
                  x.clpr_dia_tope_fact,
                  x.cuot_inic,
                  x.clas1_dias_venc_fact,
                  x.anex_empr_codi,
                  x.sose_sucu_nume_item,
                  x.mone_cant_deci,
                  x.anex_indi_fact_impo_unic,
                  x.anex_cifa_codi,
                  x.anex_cifa_tipo,
                  x.anex_cifa_dia_fact,
                  x.anex_cifa_dia_desd,
                  x.anex_cifa_dia_hast,
                  x.anex_aglu_cicl);*/
                
                exception
                
                  when others then
                  
                    raise_application_error(-20001,
                                            'Error en PA_GENERAR_DETALLE_PLAN');
                end;
              end loop;
            end if;
          
            --genera la factura automatica
            begin
              --busca usuario
              select user_codi
                into v_user_codi
                from segu_user
               where user_login = fp_user;
            end;
          
            for x in c_fact loop
            
              begin
              
                pack_fact_ciclo.pa_gene_plan_fact_movi(x.sose_clpr_codi,
                                                       x.anex_cifa_codi,
                                                       x.sose_codi,
                                                       x.sose_nume,
                                                       x.anex_codi,
                                                       x.sose_tipo_fact,
                                                       x.agru_anex,
                                                       x.fech_fact_desd,
                                                       x.fech_fact_hast,
                                                       x.movi_fech_emis,
                                                       v('P53_P_PECO_CODI'),
                                                       v_user_codi,
                                                       x.sucu_codi,
                                                       x.depo_codi,
                                                       x.clas1_codi,
                                                       x.anpl_impo_reca_red_cobr,
                                                       x.indi_excl_clie_clas1_aseg,
                                                       v_faau_codi,
                                                       v_codresp,
                                                       v_descresp,
                                                       v_movi_codi);
              
                -- si v_codresp es distinto a 1 significa que ocurri? una excepcion
                if nvl(v_codresp, 1) = 1 then
                  env_fact_sifen.pp_get_json_fact(v_movi_codi);
                  begin
                    i020273_a.pp_enviar_sms_fact(p_movi_codi => v_movi_codi);
                  end;
                
                  /*              begin
                    -- call the procedure
                    if nvl(x.deta_indi_prom_pror,'n')='s' then
                      pa_ gene_nota_cred_pror(p_clave_fact => v_movi_codi,
                                               p_clave_ot   => v('p53_ortr_codi'));
                    end if;
                  end;*/
                
                else
                  raise_application_error(-20001, v_descresp);
                end if;
              
                -- exception
                --   when others then
                --   raise_application_error(-20001,'error plan factura');
              end;
            end loop;
          end if;
        end if;
        --####################
      
        --raise_application_error(-20001, 'awwqui');
      
        update come_vehi
           set vehi_iden                = v('P53_ORTR_VEHI_IDEN'),
               vehi_clpr_codi           = v('P53_ORTR_CLPR_CODI'),
               vehi_clpr_sucu_nume_item = v('P53_ORTR_CLPR_SUCU_NUME_ITEM'),
               vehi_iden_ante           = v('P53_ORTR_VEHI_IDEN_ANTE')
         where vehi_codi = v('P53_ORTR_VEHI_CODI');
      
        --ri= reinstalacion
      elsif v('P53_ORTR_SERV_TIPO') = 'RI' then
      
        if ((v('P53_ORTR_ESTA') = 'L' and v('P53_ORTR_ESTA_ORIG') = 'P') and
           v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'N') or
           (v('P53_ORTR_ESTA_PRE_LIQU') = 'S' and
           v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'N') then
        
          begin
            select count(*)
              into v_cant_padr
              from come_soli_serv_anex      a,
                   come_soli_serv_anex_deta d,
                   come_orde_trab           o
             where a.anex_codi = d.deta_anex_codi
               and d.deta_codi_anex_padr = o.ortr_deta_codi
               and a.anex_tipo in ('RN', 'RI')
               and o.ortr_serv_tipo = 'D'
               and o.ortr_serv_tipo_moti = 'RN'
               and o.ortr_esta != 'L'
               and d.deta_codi = v('P53_ORTR_DETA_CODI');
          exception
            when no_data_found then
              v_cant_padr := 0;
          end;
        
          if nvl(v_cant_padr, 0) > 0 then
          
            begin
              select max(o.ortr_nume)
                into v_ortr_nume
                from come_soli_serv_anex      a,
                     come_soli_serv_anex_deta d,
                     come_orde_trab           o
               where a.anex_codi = d.deta_anex_codi
                 and d.deta_codi_anex_padr = o.ortr_deta_codi
                 and a.anex_tipo in ('RN', 'RI')
                 and o.ortr_serv_tipo = 'D'
                 and o.ortr_serv_tipo_moti = 'RN'
                 and o.ortr_esta != 'L'
                 and d.deta_codi = v('P53_ORTR_DETA_CODI');
            exception
              when no_data_found then
                v_ortr_nume := null;
            end;
          
            raise_application_error(-20001,
                                    'Primero debe liquidar la OT (' ||
                                    v_ortr_nume ||
                                    ') de desinstalaci?n relacionada');
          end if;
        
          setitem('P53_ORTR_ESTA_PRE_LIQU', 'S');
          for x in c_plan_cambio(v('P53_ORTR_DETA_CODI')) loop
            update come_soli_serv_anex_plan ap
               set ap.anpl_deta_esta_plan = 'N',
                   ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
             where ap.anpl_codi = x.anpl_codi;
          end loop;
        
          update come_vehi
             set vehi_esta = 'I'
           where vehi_codi = v('P53_ORTR_VEHI_CODI');
        
          update come_soli_serv_anex_deta
             set deta_esta = 'I'
           where deta_codi = v('P53_ORTR_DETA_CODI');
        
          --####################
          if nvl(v('P53_P_INDI_GENE_PLAN_LIQU_OT'), 'N') = 'S' then
            --- si el parametro esta en s para alarmas
            --verifica si ya tiene plan para generar al liquidar la ot
          
            begin
              select count(*) cant
                into v_plan
                from come_orde_trab           t,
                     come_soli_serv_anex      a,
                     come_soli_serv_anex_deta d,
                     come_soli_serv_anex_plan p
               where a.anex_codi = p.anpl_anex_codi
                 and a.anex_codi = d.deta_anex_codi
                 and t.ortr_deta_codi = d.deta_codi
                 and t.ortr_codi = v('P53_ORTR_CODI');
            
            exception
              when others then
                v_plan := 0;
            end;
          
            if v_plan = 0 then
              --procedimiento para generar el plan
              for x in c_anex loop
              
                begin
                  pack_fact_ciclo.pa_generar_detalle_plan(x.anex_codi,
                                                          to_date(v('P53_ORTR_FECH_INST')) - 1, --se envia con fecha - 1 porque el proceso que usa hace fecha + 1
                                                          x.anex_dura_cont,
                                                          x.anex_cant_cuot_modu,
                                                          x.anex_impo_mone_unic,
                                                          x.anex_prec_unit,
                                                          x.sose_tipo_fact,
                                                          x.clpr_dia_tope_fact,
                                                          x.cuot_inic,
                                                          x.clas1_dias_venc_fact,
                                                          x.anex_empr_codi,
                                                          x.sose_sucu_nume_item,
                                                          x.mone_cant_deci,
                                                          x.anex_indi_fact_impo_unic,
                                                          x.anex_cifa_codi,
                                                          x.anex_cifa_tipo,
                                                          x.anex_cifa_dia_fact,
                                                          x.anex_cifa_dia_desd,
                                                          x.anex_cifa_dia_hast,
                                                          x.anex_aglu_cicl);
                exception
                  when others then
                    raise_application_error(-20001, 'ERROR2');
                end;
              end loop;
            end if;
          
            --genera la factura automatica
            begin
              --busca usuario
              select user_codi
                into v_user_codi
                from segu_user
               where user_login = fp_user;
            end;
          
            for x in c_fact loop
              begin
                -----------lv, si se ejecuta al mismo tiempo duplica el nro de factura 
                -----------agregue un intervalo de tiempo aleatorio para que de tiempo entre ambos
                begin
                  tiempo_inicial := systimestamp; -- obtener la marca de tiempo inicial
                  intervalo      := numtodsinterval(tiempo_espera, 'SECOND'); -- convertir segundos a un intervalo de tiempo
                  loop
                    tiempo_actual := systimestamp; -- obtener la marca de tiempo actual
                    exit when(tiempo_actual - tiempo_inicial) >= intervalo; -- salir del bucle despu?s de x segundos
                  end loop;
                end;
              
                pack_fact_ciclo.pa_gene_plan_fact_movi(x.sose_clpr_codi,
                                                       x.anex_cifa_codi,
                                                       x.sose_codi,
                                                       x.sose_nume,
                                                       x.anex_codi,
                                                       x.sose_tipo_fact,
                                                       x.agru_anex,
                                                       x.fech_fact_desd,
                                                       x.fech_fact_hast,
                                                       x.movi_fech_emis,
                                                       v('P53_P_PECO_CODI'),
                                                       v_user_codi,
                                                       x.sucu_codi,
                                                       x.depo_codi,
                                                       x.clas1_codi,
                                                       x.anpl_impo_reca_red_cobr,
                                                       x.indi_excl_clie_clas1_aseg,
                                                       v_faau_codi,
                                                       v_codresp,
                                                       v_descresp,
                                                       v_movi_codi);
              
                --raise_application_error(-20001,v_faau_codi);
              
                -- si v_codresp es distinto a 1 significa que ocurri? una excepcion
                if nvl(v_codresp, 1) = 1 then
                  env_fact_sifen.pp_get_json_fact(v_movi_codi);
                  begin
                    i020273_a.pp_enviar_sms_fact(p_movi_codi => v_movi_codi);
                  end;
                
                  /*              begin
                    -- call the procedure
                    if nvl(x.deta_indi_prom_pror,'n')='s' then
                      pa_ gene_nota_cred_pror(p_clave_fact => v_movi_codi,
                                               p_clave_ot   => v('p53_ortr_codi'));
                    end if;
                  end;*/
                
                else
                
                  raise_application_error(-20001, v_descresp);
                end if;
              
              end;
            end loop;
          
            update come_vehi
               set vehi_iden                = v('P53_ORTR_VEHI_IDEN'),
                   vehi_clpr_codi           = v('P53_ORTR_CLPR_CODI'),
                   vehi_clpr_sucu_nume_item = v('P53_ORTR_CLPR_SUCU_NUME_ITEM'),
                   vehi_iden_ante           = v('P53_ORTR_VEHI_IDEN_ANTE')
             where vehi_codi = v('P53_ORTR_VEHI_CODI');
          
          end if;
          --####################
        
        end if;
      end if;
    
    end if;
  
    -- pl_me('pasa');
  end pp_liquida_ot;

  procedure pp_generar_anex_desi is
    v_ortr_codi      number;
    v_ortr_nume      number;
    v_clpr_desc      varchar2(100);
    v_sode_tipo_moti varchar2(10);
    v_sode_fech_emis date;
  
    v_anex_codi           number;
    v_anex_sose_codi      number;
    v_anex_nume           number;
    v_anex_dura_cont      number;
    v_anex_mone_codi      number;
    v_anex_tasa_mone      number;
    v_anex_impo_mone      number;
    v_anex_impo_mmnn      number;
    v_anex_prec_unit      number;
    v_anex_equi_prec      number;
    v_anex_fech_venc      date;
    v_anex_fech_inic_vige date;
    v_anex_nume_poli      varchar2(40);
    v_anex_nume_orde_serv varchar2(20);
    v_anex_fech_inic_poli date;
    v_anex_fech_fini_poli date;
  
    v_vehi_iden                varchar2(60);
    v_deta_base                number(10);
    v_deta_calc_gran           varchar2(1);
    v_deta_calc_pequ           varchar2(1);
    v_deta_ning_calc           varchar2(1);
    v_deta_indi_moni           varchar2(1);
    v_deta_indi_nexo_recu      varchar2(1);
    v_deta_indi_para_moto      varchar2(1);
    v_deta_indi_boto_esta      varchar2(1);
    v_deta_indi_acce_aweb      varchar2(1);
    v_deta_indi_roam           varchar2(1);
    v_deta_indi_boto_pani      varchar2(1);
    v_deta_indi_mant_equi      varchar2(1);
    v_deta_indi_cort_corr_auto varchar2(1);
    v_deta_tipo_roam           varchar2(1);
    v_deta_roam_fech_inic_vige date;
    v_deta_roam_fech_fini_vige date;
    v_deta_esta_vehi           varchar2(1);
    v_deta_esta                varchar2(1);
    v_deta_iden_ante           varchar2(60);
    v_deta_fech_vige_inic      date;
    v_deta_fech_vige_fini      date;
    v_vehi_codi                number(20);
    v_deta_indi_sens_tapa_tanq varchar2(1);
    v_deta_indi_sens_comb      varchar2(1);
    v_deta_indi_sens_temp      varchar2(1);
    v_deta_indi_aper_puer      varchar2(1);
    v_deta_impo_mone           number(20, 4);
    v_deta_esta_plan           varchar2(1);
    v_deta_indi_anex_vehi      varchar2(1);
    v_deta_indi_anex_requ_vehi varchar2(1);
    v_deta_indi_anex_requ_fech varchar2(1);
    v_deta_indi_anex_modu      varchar2(1);
    v_deta_indi_anex_sele_modu varchar2(1);
    v_deta_codi                number(10);
    v_deta_conc_codi           number(10);
    v_deta_anex_codi_padr      number(10);
    v_deta_prec_unit           number(20, 4);
  
    v_anex_codi_padr number;
    v_deta_codi_padr number;
    v_sose_tipo_fact varchar2(10);
    v_sose_tasa_mone number;
  
  begin
    --recuperar datos de cabecera de anexo
    begin
      select anex_codi,
             anex_sose_codi,
             anex_dura_cont,
             nvl(anex_mone_codi, s.sose_mone_codi) anex_mone_codi,
             anex_tasa_mone,
             anex_impo_mone,
             anex_impo_mmnn,
             anex_prec_unit,
             anex_equi_prec,
             anex_fech_venc,
             anex_fech_inic_vige,
             anex_nume_poli,
             anex_nume_orde_serv,
             anex_fech_inic_poli,
             anex_fech_fini_poli,
             sose_tipo_fact,
             nvl(sose_tasa_mone, 1)
        into v_anex_codi_padr,
             v_anex_sose_codi,
             v_anex_dura_cont,
             v_anex_mone_codi,
             v_anex_tasa_mone,
             v_anex_impo_mone,
             v_anex_impo_mmnn,
             v_anex_prec_unit,
             v_anex_equi_prec,
             v_anex_fech_venc,
             v_anex_fech_inic_vige,
             v_anex_nume_poli,
             v_anex_nume_orde_serv,
             v_anex_fech_inic_poli,
             v_anex_fech_fini_poli,
             v_sose_tipo_fact,
             v_sose_tasa_mone
        from come_soli_serv           s,
             come_soli_serv_anex      a,
             come_soli_serv_anex_deta ad
       where s.sose_codi = a.anex_sose_codi
         and a.anex_codi = ad.deta_anex_codi
         and ad.deta_codi = v('P53_ORTR_DETA_CODI');
    end;
  
    begin
      select nvl(max(anex_codi), 0) + 1
        into v_anex_codi
        from come_soli_serv_anex;
    end;
  
    begin
      select nvl(max(anex_nume), 0) + 1
        into v_anex_nume
        from come_soli_serv_anex
       where anex_sose_codi = v_anex_sose_codi;
    exception
      when no_data_found then
        v_anex_nume := 1;
    end;
  
    --insertar cabecera de anexo
    insert into come_soli_serv_anex
      (anex_empr_codi,
       anex_codi,
       anex_sose_codi,
       anex_nume,
       anex_fech_emis,
       anex_fech_venc,
       anex_fech_inic_vige,
       anex_base,
       anex_user_regi,
       anex_fech_regi,
       anex_user_modi,
       anex_fech_modi,
       anex_esta,
       anex_dura_cont,
       anex_mone_codi,
       anex_tasa_mone,
       anex_impo_mone,
       anex_impo_mmnn,
       anex_prec_unit,
       anex_entr_inic,
       anex_cant_movi,
       anex_tipo,
       anex_equi_prec,
       anex_impo_mone_unic,
       anex_nume_poli,
       anex_nume_orde_serv,
       anex_fech_inic_poli,
       anex_fech_fini_poli,
       anex_nume_refe,
       anex_ortr_codi_desi)
    values
      (nvl(v('P53_P_EMPR_CODI'), 1),
       v_anex_codi,
       v_anex_sose_codi,
       v_anex_nume,
       nvl(v('P53_ORTR_FECH_INST'), trunc(sysdate)),
       v_anex_fech_venc,
       v_anex_fech_inic_vige,
       nvl(v('P53_P_CODI_BASE'), 1),
       fp_user,
       sysdate,
       null,
       null,
       'P',
       v_anex_dura_cont,
       v_anex_mone_codi,
       v_anex_tasa_mone,
       v_anex_impo_mone,
       v_anex_impo_mmnn,
       v_anex_prec_unit,
       0,
       1,
       'RI',
       v_anex_equi_prec,
       nvl(v('P53_P_IMPO_MONE_ANEX_REIN_VEHI'), 70000),
       v_anex_nume_poli,
       v_anex_nume_orde_serv,
       v_anex_fech_inic_poli,
       v_anex_fech_fini_poli,
       v_anex_nume,
       v('P53_ORTR_CODI'));
  
    --recuperar datos de detalle de anexo, del vehiculo a reinstalar
    begin
      select deta_iden,
             deta_base,
             deta_calc_gran,
             deta_calc_pequ,
             deta_ning_calc,
             deta_indi_moni,
             deta_indi_nexo_recu,
             deta_indi_para_moto,
             deta_indi_boto_esta,
             deta_indi_acce_aweb,
             deta_indi_roam,
             deta_indi_boto_pani,
             deta_indi_mant_equi,
             deta_indi_cort_corr_auto,
             deta_tipo_roam,
             deta_roam_fech_inic_vige,
             deta_roam_fech_fini_vige,
             deta_esta_vehi,
             deta_esta,
             deta_iden_ante,
             deta_fech_vige_inic,
             deta_fech_vige_fini,
             deta_vehi_codi,
             deta_indi_sens_tapa_tanq,
             deta_indi_sens_comb,
             deta_indi_sens_temp,
             deta_indi_aper_puer,
             deta_impo_mone,
             deta_esta_plan,
             deta_indi_anex_vehi,
             deta_indi_anex_requ_vehi,
             deta_indi_anex_requ_fech,
             deta_indi_anex_modu,
             deta_indi_anex_sele_modu,
             deta_codi,
             deta_conc_codi,
             deta_prec_unit
        into v_vehi_iden,
             v_deta_base,
             v_deta_calc_gran,
             v_deta_calc_pequ,
             v_deta_ning_calc,
             v_deta_indi_moni,
             v_deta_indi_nexo_recu,
             v_deta_indi_para_moto,
             v_deta_indi_boto_esta,
             v_deta_indi_acce_aweb,
             v_deta_indi_roam,
             v_deta_indi_boto_pani,
             v_deta_indi_mant_equi,
             v_deta_indi_cort_corr_auto,
             v_deta_tipo_roam,
             v_deta_roam_fech_inic_vige,
             v_deta_roam_fech_fini_vige,
             v_deta_esta_vehi,
             v_deta_esta,
             v_deta_iden_ante,
             v_deta_fech_vige_inic,
             v_deta_fech_vige_fini,
             v_vehi_codi,
             v_deta_indi_sens_tapa_tanq,
             v_deta_indi_sens_comb,
             v_deta_indi_sens_temp,
             v_deta_indi_aper_puer,
             v_deta_impo_mone,
             v_deta_esta_plan,
             v_deta_indi_anex_vehi,
             v_deta_indi_anex_requ_vehi,
             v_deta_indi_anex_requ_fech,
             v_deta_indi_anex_modu,
             v_deta_indi_anex_sele_modu,
             v_deta_codi_padr,
             v_deta_conc_codi,
             v_deta_prec_unit
        from come_soli_serv_anex_deta
       where deta_codi = v('P53_ORTR_DETA_CODI');
    end;
  
    --segun tipo de factura, selecciona el codigo de concepto por instalacion de monitoreo
    if v_sose_tipo_fact = 'C' then
      v_deta_conc_codi := v('P53_P_CONC_CODI_SERV_MONI_ANUA');
    else
      v_deta_conc_codi := v('P53_P_CONC_CODI_SERV_MONI_MENS');
    end if;
  
    --recupera datos de indicadores de concepto
    begin
      select nvl(conc_indi_anex_requ_vehi, 'V'),
             nvl(conc_indi_anex_requ_fech, 'N'),
             nvl(conc_indi_anex_modu, 'N'),
             nvl(conc_indi_anex_sele_modu, 'N')
        into v_deta_indi_anex_requ_vehi,
             v_deta_indi_anex_requ_fech,
             v_deta_indi_anex_modu,
             v_deta_indi_anex_sele_modu
        from come_conc
       where conc_codi = v_deta_conc_codi;
    end;
  
    v_deta_codi := fa_sec_soli_serv_anex_deta;
  
    --inserta datos de detalle de anexo
    insert into come_soli_serv_anex_deta
      (deta_anex_codi,
       deta_nume_item,
       deta_iden,
       deta_base,
       deta_calc_gran,
       deta_calc_pequ,
       deta_ning_calc,
       deta_indi_moni,
       deta_indi_nexo_recu,
       deta_indi_para_moto,
       deta_indi_boto_esta,
       deta_indi_acce_aweb,
       deta_indi_roam,
       deta_indi_boto_pani,
       deta_indi_mant_equi,
       deta_indi_cort_corr_auto,
       deta_tipo_roam,
       deta_roam_fech_inic_vige,
       deta_roam_fech_fini_vige,
       deta_esta_vehi,
       deta_esta,
       deta_iden_ante,
       deta_fech_vige_inic,
       deta_fech_vige_fini,
       deta_vehi_codi,
       deta_indi_sens_tapa_tanq,
       deta_indi_sens_comb,
       deta_indi_sens_temp,
       deta_indi_aper_puer,
       deta_impo_mone,
       deta_esta_plan,
       deta_indi_anex_vehi,
       deta_indi_anex_requ_vehi,
       deta_indi_anex_requ_fech,
       deta_indi_anex_modu,
       deta_indi_anex_sele_modu,
       deta_codi,
       deta_conc_codi,
       deta_anex_codi_padr,
       deta_prec_unit,
       deta_codi_anex_padr)
    values
      (v_anex_codi,
       1,
       v('P53_ORTR_VEHI_IDEN'), --guarda el identificador, ya que no se modificara en la reinstalacion
       v_deta_base,
       v_deta_calc_gran,
       v_deta_calc_pequ,
       v_deta_ning_calc,
       v_deta_indi_moni,
       v_deta_indi_nexo_recu,
       v_deta_indi_para_moto,
       v_deta_indi_boto_esta,
       v_deta_indi_acce_aweb,
       v_deta_indi_roam,
       v_deta_indi_boto_pani,
       v_deta_indi_mant_equi,
       v_deta_indi_cort_corr_auto,
       v_deta_tipo_roam,
       v_deta_roam_fech_inic_vige,
       v_deta_roam_fech_fini_vige,
       v_deta_esta_vehi,
       'P',
       v_deta_iden_ante,
       v_deta_fech_vige_inic,
       v_deta_fech_vige_fini,
       null,
       v_deta_indi_sens_tapa_tanq,
       v_deta_indi_sens_comb,
       v_deta_indi_sens_temp,
       v_deta_indi_aper_puer,
       v_deta_impo_mone,
       v_deta_esta_plan,
       v_deta_indi_anex_vehi,
       v_deta_indi_anex_requ_vehi,
       v_deta_indi_anex_requ_fech,
       v_deta_indi_anex_modu,
       v_deta_indi_anex_sele_modu,
       v_deta_codi,
       v_deta_conc_codi,
       v_anex_codi_padr,
       v_deta_prec_unit,
       v_deta_codi_padr);
  
    v_deta_codi := fa_sec_soli_serv_anex_deta;
  
    --inserta detalle de anexo con concepto de reinstalacion
    insert into come_soli_serv_anex_deta
      (deta_anex_codi,
       deta_nume_item,
       deta_vehi_codi,
       deta_iden,
       deta_base,
       deta_roam_fech_inic_vige,
       deta_roam_fech_fini_vige,
       deta_conc_codi,
       deta_prec_unit,
       deta_indi_anex_vehi,
       deta_indi_anex_requ_vehi,
       deta_indi_anex_requ_fech,
       deta_indi_anex_modu,
       deta_indi_anex_sele_modu,
       deta_codi,
       deta_impo_mone,
       deta_esta_plan,
       deta_anex_codi_padr,
       deta_codi_anex_padr)
    values
      (v_anex_codi,
       2,
       null,
       null,
       v_deta_base,
       v_deta_roam_fech_inic_vige,
       v_deta_roam_fech_fini_vige,
       v('P53_P_CONC_CODI_ANEX_REIN_VEHI'),
       nvl(v('P53_P_IMPO_MONE_ANEX_REIN_VEHI'), 70000),
       'S',
       'N',
       'N',
       'S',
       'N',
       v_deta_codi,
       nvl(v('P_IMPO_MONE_ANEX_REIN_VEHI'), 70000),
       'S',
       v_anex_codi_padr,
       v_deta_codi_padr);
  
    --actualiza importes de cabecera de anexo
    update come_soli_serv_anex
       set anex_impo_mone = v_deta_impo_mone,
           anex_impo_mmnn = round(v_deta_impo_mone * v_sose_tasa_mone, 0),
           anex_prec_unit = v_deta_prec_unit
     where anex_codi = v_anex_codi;
  
  end pp_generar_anex_desi;

  procedure pp_generar_desi_ot is
  
    v_sode_codi           number(10);
    v_sode_nume           number(20);
    v_sode_empr_codi      number(10);
    v_sode_anex_codi      number(20);
    v_sode_deta_nume_item number(10);
    v_sode_fech_emis      date;
    v_sode_user_regi      varchar2(20);
    v_sode_fech_regi      date;
    v_sode_user_modi      varchar2(20);
    v_sode_fech_modi      date;
    v_sode_base           number(10);
    v_sode_clpr_codi      number(20);
    v_sode_sucu_nume_item number(20);
    v_sode_clve_iden      varchar2(20);
    v_sode_esta           varchar2(1);
    v_sode_vehi_codi      number(20);
    v_sode_moti           varchar2(100);
    v_sode_tipo_moti      varchar2(10);
    v_sode_deta_codi      number(20);
  
    v_ortr_codi      number(20);
    v_ortr_nume      varchar2(20);
    v_ortr_desc      varchar2(1000);
    v_ortr_sose_codi number(20);
    v_sose_codi      number(20);
    v_anex_codi      number(20);
  
    v_clpr_codi           number;
    v_clpr_sucu_nume_item number;
    v_nume                number;
    v_count               number;
  
  begin
    -- pl_me('entra');
    begin
      select nvl(max(sode_codi), 0) + 1
        into v_sode_codi
        from come_soli_desi;
    end;
  
    begin
      select nvl(max(sode_nume), 0) + 1
        into v_sode_nume
        from come_soli_desi
       where sode_empr_codi = nvl(v('P53_P_EMPR_CODI'), 1);
    end;
  
    --se relaciona la desinstalacion al detalle de anexo donde esta el vehiculo a cambiar
    begin
      select d.deta_codi_anex_padr
        into v_sode_deta_codi
        from come_soli_serv_anex_deta d
       where d.deta_codi = v('P53_ORTR_DETA_CODI');
    end;
  
    --se recupera codigo de cliente donde esta el vehiculo antes del cambio
    begin
      select vehi_clpr_codi, vehi_clpr_sucu_nume_item
        into v_clpr_codi, v_clpr_sucu_nume_item
        from come_vehi
       where vehi_codi = v('P53_ORTR_VEHI_CODI');
    end;
  
    if v('P53_ORTR_SERV_TIPO') = 'T' then
      v_sode_moti      := 'Cambio de Titularidad';
      v_sode_tipo_moti := 'C' || v('P53_ORTR_SERV_TIPO');
      v_ortr_desc      := 'Desinstalaci?n por Cambio de Titularidad';
    elsif v('P53_RTR_SERV_TIPO') = 'S' then
      v_sode_moti      := 'Cambio de Seguro';
      v_sode_tipo_moti := 'C' || v('P53_ORTR_SERV_TIPO');
      v_ortr_desc      := 'Desinstalaci?n por Cambio de Seguro';
    elsif v('P53_ORTR_SERV_TIPO') = 'R' then
      v_sode_moti      := 'Cambio de RPY';
      v_sode_tipo_moti := 'C' || v('P53_ORTR_SERV_TIPO');
      v_ortr_desc      := 'Desinstalaci?n por Cambio de RPY';
    elsif v('P53_ORTR_SERV_TIPO') = 'RAS' then
      v_sode_moti      := 'Cambio de RPY a Seguro';
      v_sode_tipo_moti := 'C' || v('P53_ORTR_SERV_TIPO');
      v_ortr_desc      := 'Desinstalaci?n por Cambio de RPY a Seguro';
    end if;
  
    v_sode_fech_emis := v('P53_ORTR_FECH_EMIS');
    v_sode_esta      := 'L';
    v_sode_vehi_codi := v('P53_ORTR_VEHI_CODI');
    v_sode_user_regi := fp_user;
    v_sode_fech_regi := sysdate;
  
    insert into come_soli_desi
      (sode_codi,
       sode_nume,
       sode_empr_codi,
       sode_anex_codi,
       sode_deta_nume_item,
       sode_fech_emis,
       sode_user_regi,
       sode_fech_regi,
       sode_user_modi,
       sode_fech_modi,
       sode_base,
       sode_clpr_codi,
       sode_sucu_nume_item,
       sode_clve_iden,
       sode_esta,
       sode_vehi_codi,
       sode_moti,
       sode_tipo_moti,
       sode_deta_codi)
    values
      (v_sode_codi,
       v_sode_nume,
       nvl(v('P53_P_EMPR_CODI'), 1),
       null,
       null,
       v_sode_fech_emis,
       v_sode_user_regi,
       v_sode_fech_regi,
       null,
       null,
       nvl(v('P53_P_CODI_BASE'), 1),
       v_clpr_codi,
       v_clpr_sucu_nume_item,
       null,
       v_sode_esta,
       v_sode_vehi_codi,
       v_sode_moti,
       v_sode_tipo_moti,
       v_sode_deta_codi);
  
    -------------------ot------------------------------
  
    v_ortr_codi := fa_sec_come_orde_trab;
  
    --se dejo el nro de orden libre para la desinstalacion, y que siga un orden de secuencia real
    v_nume      := v('P53_ORTR_NUME') - 1;
    v_ortr_nume := v('P53_ORTR_NUME') - 1;
  
    loop
      select count(*)
        into v_count
        from come_orde_trab
       where ortr_nume = v_nume;
    
      if v_count > 0 then
        v_nume := v_nume + 1;
      else
        if v_ortr_nume <> v_nume then
          /* pl_mm('la ot ' || v_ortr_nume||
          ' ya existe. la nueva ot se guardar? con el n?mero ' ||
          v_nume || '.');
          */
        
          null;
          ---------ver como emitir mensajes
        
        end if;
      
        v_ortr_nume := v_nume;
        exit;
      end if;
    end loop;
    apex_application.g_print_success_message := 'NRO OT DESINSTALACION: ' ||
                                                v_nume || '   ';
  
    begin
      select anex_sose_codi
        into v_ortr_sose_codi
        from come_soli_serv_anex
       where anex_codi = v('P53_ORTR_ANEX_CODI');
    end;
  
    insert into come_orde_trab
      (ortr_codi,
       ortr_clpr_codi,
       ortr_clpr_sucu_nume_item,
       ortr_nume,
       ortr_fech_emis,
       ortr_fech_grab,
       ortr_user,
       ortr_fech_liqu,
       ortr_esta,
       ortr_desc,
       ortr_base,
       ortr_empr_codi,
       ortr_sucu_codi,
       ortr_mone_codi_prec,
       ortr_prec_vent,
       ortr_excl_fact,
       ortr_codi_padr,
       ortr_tipo_cost_tran,
       ortr_serv_tipo,
       ortr_serv_cate,
       ortr_serv_dato,
       ortr_user_regi,
       ortr_fech_regi,
       ortr_user_modi,
       ortr_fech_modi,
       ortr_sose_codi,
       ortr_sode_codi,
       ortr_vehi_codi,
       ortr_cant,
       ortr_fech_inst,
       ortr_luga_inst,
       ortr_anex_codi,
       ortr_serv_tipo_moti,
       ortr_deta_codi,
       ortr_form_insu,
       ortr_lote_equipo)
    values
      (v_ortr_codi,
       v_clpr_codi,
       v_clpr_sucu_nume_item,
       v_ortr_nume,
       v('P53_ORTR_FECH_EMIS'),
       sysdate,
       fp_user,
       nvl(v('P53_ORTR_FECH_INST'), sysdate),
       'L',
       v_ortr_desc,
       nvl(v('P53_P_CODI_BASE'), 1),
       nvl(v('P53_P_EMPR_CODI'), 1),
       nvl(v('P53_P_SUCU_CODI'), 1),
       1,
       0,
       null,
       v('P53_ORTR_CODI'),
       1,
       'D',
       'P',
       'K',
       fp_user,
       sysdate,
       null,
       null,
       v_ortr_sose_codi,
       v_sode_codi,
       v('P53_ORTR_VEHI_CODI'),
       null,
       nvl(v('P53_ORTR_FECH_INST'), sysdate),
       'Rastreo Paraguay S.A.',
       v('P53_ORTR_ANEX_CODI'),
       v_sode_tipo_moti,
       v_sode_deta_codi,
       v('P53_ORTR_FORM_INSU'),
       v('P53_VEHI_LOTE_RASTREO'));
  
  end pp_generar_desi_ot;

  procedure pp_valida_desliqu_ot is
  
    v_ortr_nume varchar2(200);
    v_cant_fact number := 0;
    v_anex_codi number;
    v_anex_esta varchar2(1);
  
    cursor c_come_ortr is
      select ortr_nume
        from come_orde_trab
       where ortr_codi > v('P53_ORTR_CODI')
         and ortr_vehi_codi = v('P53_ORTR_VEHI_CODI')
         and ortr_serv_tipo_moti not in ('CT', 'CR', 'CS', 'CRAS'); --desinstalaciones por cambios
  
  begin
  
    for x in c_come_ortr loop
      v_ortr_nume := v_ortr_nume || x.ortr_nume || ' - ';
    end loop;
  
    if v_ortr_nume is not null then
      raise_application_error(-20001,
                              'No puede Desliquidar la OT, porque existen OTS posteriores ' ||
                              v_ortr_nume || ' asignados al vehiculo.');
    end if;
  
    if nvl(v('P53_ORTR_SERV_TIPO'), 'I') <> 'D' then
      begin
        select count(*)
          into v_cant_fact
          from come_soli_serv_anex_plan
         where anpl_deta_codi = v('P53_ORTR_DETA_CODI')
           and (anpl_movi_codi is not null or
               nvl(anpl_indi_fact, 'N') = 'S');
      
        if v_cant_fact > 0 then
          raise_application_error(-20001,
                                  'No puede Desliquidar la OT, porque ya existen Facturas generadas en su Plan de Facturaci?n.');
        end if;
      
      exception
        when no_data_found then
          null;
      end;
    else
      if nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') in ('R', 'RF') then
        begin
        
          select distinct (deta_anex_codi)
            into v_anex_codi
            from come_soli_serv_anex_deta
           where deta_codi_anex_padr = v('P53_ORTR_DETA_CODI');
        exception
          when no_data_found then
            v_anex_codi := null;
          when too_many_rows then
          
            /* select distinct (deta_anex_codi)
             into v_anex_codi
             from come_soli_serv_anex_deta
            where deta_codi_anex_padr =v('p53_ortr_deta_codi')
            and deta_vehi_codi = v('p53_ortr_vehi_codi')
            ;*/
            v_anex_codi := null;
        end;
      
        if v_anex_codi is not null then
          begin
          
            select nvl(anex_esta, 'P')
              into v_anex_esta
              from come_soli_serv_anex
             where anex_codi = v_anex_codi;
          
            if v_anex_esta = 'A' then
              raise_application_error(-20001,
                                      'No puede Desliquidar la OT, porque ya esta Autorizado el Anexo generado por Reinstalaci?n.');
            end if;
          
          exception
            when no_data_found then
              null;
          end;
        end if;
      end if;
    end if;
  
  exception
    when no_data_found then
      null;
  end pp_valida_desliqu_ot;

  procedure pp_desliquida_ot is
    -- cursor para restablecer los servicios de grua relacionados
    cursor c_grua(p_c_deta_codi in number) is
      select dh.deta_codi, v.vehi_codi
        from come_soli_serv_anex_deta dh,
             come_soli_serv_anex_deta dp,
             come_vehi                v
       where dh.deta_codi_anex_padr = dp.deta_codi
         and dp.deta_vehi_codi = v.vehi_codi(+)
         and dh.deta_conc_codi = v('P53_P_CONC_CODI_ANEX_GRUA_VEHI')
         and dp.deta_codi = p_c_deta_codi
       order by dh.deta_codi, v.vehi_codi;
  
    v_vehi_iden           varchar2(20);
    v_vehi_clpr_codi      number;
    v_clpr_sucu_nume_item number;
    v_cant_plan           number;
  begin
  
    ---si es desinstalacion
    if v('P53_ORTR_SERV_TIPO') = 'D' then
    
      select count(a.anpl_anex_codi)
        into v_cant_plan
        from come_soli_serv_anex_plan a
       where a.anpl_ortr_codi = v('P53_ORTR_CODI')
         and a.anpl_indi_fact = 'S';
    
      if v_cant_plan > 0 then
        raise_application_error(-20001,
                                'Ya se emitio factura al cliente por permanencia minina, no puede cambiar de estado');
      
      end if;
    
      if nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') = 'R' then
        --eliminar anexo de reinstalacion en contrato donde estaba instalado el vehiculo
        pp_eliminar_anex_desi;
      
      elsif nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') = 'RF' then
        --eliminar anexo de reinstalacion en contrato donde estaba instalado el vehiculo en caso que ya se haya generado
        pp_eliminar_anex_desi;
      
        update come_soli_serv_anex_plan ap
           set ap.anpl_deta_esta_plan = 'S', ap.anpl_ortr_codi = null
         where ap.anpl_ortr_codi = v('P53_ORTR_CODI')
           and nvl(ap.anpl_deta_esta_plan, 'N') = 'N';
      
        --indicador si se genero pre-anexo por reinstalacion a futuro
        --:bcab.ortr_indi_rein_futu_gene := 'n';
        setitem('P53_ORTR_INDI_REIN_FUTU_GENE', 'N');
      else
      
        update come_soli_serv_anex_plan ap
           set ap.anpl_deta_esta_plan = 'S', ap.anpl_ortr_codi = null
         where ap.anpl_ortr_codi = v('P53_ORTR_CODI')
           and nvl(ap.anpl_deta_esta_plan, 'N') = 'N';
      
        --cuando se desinstala por renovacion puede cambiar fecha de fact, pero no indicador en 2 pagos, ajustar devuelta fecha si existe alguno..
        update come_soli_serv_anex_plan ap
           set ap.anpl_fech_fact = to_date('01' ||
                                           to_char(ap.anpl_fech_desd,
                                                   'mm/yyyy'),
                                           'dd/mm/yyyy'),
               ap.anpl_fech_venc = to_date('06' ||
                                           to_char(ap.anpl_fech_desd,
                                                   'mm/yyyy'),
                                           'dd/mm/yyyy'),
               ap.anpl_ortr_codi = null
         where ap.anpl_ortr_codi = v('P53_ORTR_CODI')
           and nvl(ap.anpl_deta_esta_plan, 'N') = 'S';
      end if;
    
      -- restablecer los servicios de grua
      for k in c_grua(v('P53_ORTR_DETA_CODI')) loop
        update come_soli_serv_anex_deta d
           set d.deta_esta_plan = 'S'
         where deta_codi = k.deta_codi;
      
        update come_soli_serv_anex_plan p
           set p.anpl_deta_esta_plan = 'S'
         where p.anpl_deta_codi = k.deta_codi
           and p.anpl_indi_fact = 'N';
      
        if k.vehi_codi is not null then
          update come_vehi v
             set v.vehi_indi_grua = 'S'
           where v.vehi_codi = k.vehi_codi
             and v.vehi_indi_grua = 'N';
        end if;
      end loop;
    
      update come_vehi
         set vehi_esta = 'I'
       where vehi_codi = v('P53_ORTR_VEHI_CODI');
    
      update come_soli_serv_anex_deta
         set deta_esta = 'I'
       where deta_codi = v('P53_ORTR_DETA_CODI');
    
    else
      --si no es desinstalacion
    
      --si es instalacion
      if v('P53_ORTR_SERV_TIPO') = 'I' then
      
        update come_vehi
           set vehi_esta = 'P'
         where vehi_codi = v('P53_ORTR_VEHI_CODI');
      
        update come_soli_serv_anex_deta
           set deta_esta = 'P'
         where deta_codi = v('P53_ORTR_DETA_CODI');
      
        --t= camb titularidad, r= camb seguro a rpy, s= camb seguro a seguro, ras= camb rpy a seguro
      elsif v('P53_ORTR_SERV_TIPO') in ('T', 'R', 'S', 'RAS') then
      
        if (v('P53_ORTR_ESTA_PRE_LIQU') = 'N' and
           v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'S') then
          update come_soli_serv_anex_deta
             set deta_esta = 'P'
           where deta_codi = v('P53_ORTR_DETA_CODI');
        
          update come_soli_serv_anex_deta
             set deta_esta = 'I'
           where deta_codi =
                 (select d.deta_codi_anex_padr
                    from come_soli_serv_anex_deta d
                   where d.deta_codi = v('P53_ORTR_DETA_CODI'));
        
          update come_soli_serv_anex_plan ap
             set ap.anpl_deta_esta_plan = 'S', ap.anpl_ortr_codi = null
           where ap.anpl_ortr_codi = v('P53_ORTR_CODI')
             and nvl(ap.anpl_deta_esta_plan, 'N') = 'N';
        
          --debe actualizar datos del vehiculo, que puede ser iden, cliente, asegurado
          begin
            select d.deta_iden, s.sose_clpr_codi, s.sose_sucu_nume_item
              into v_vehi_iden, v_vehi_clpr_codi, v_clpr_sucu_nume_item
              from come_soli_serv           s,
                   come_soli_serv_anex      a,
                   come_soli_serv_anex_deta d
             where s.sose_codi = a.anex_sose_codi
               and a.anex_codi = d.deta_anex_codi
               and d.deta_codi =
                   (select d.deta_codi_anex_padr
                      from come_soli_serv_anex_deta d
                     where d.deta_codi = v('P53_ORTR_DETA_CODI'));
          exception
            when no_data_found then
              v_vehi_iden           := null;
              v_vehi_clpr_codi      := null;
              v_clpr_sucu_nume_item := null;
          end;
        
          update come_vehi
             set vehi_iden                = v_vehi_iden,
                 vehi_clpr_codi           = v_vehi_clpr_codi,
                 vehi_clpr_sucu_nume_item = v_clpr_sucu_nume_item,
                 vehi_iden_ante           = null
           where vehi_codi = v('P53_ORTR_VEHI_CODI');
        
          pp_eliminar_desi_ot_plan;
        end if;
        --ri= reinstalacion
      elsif v('P53_ORTR_SERV_TIPO') = 'RI' then
        if --((:bcab.ortr_esta = 'p' and :bcab.ortr_esta_orig = 'l') and :bcab.ortr_esta_pre_liqu_orig = 's') or
         (v('P53_ORTR_ESTA_PRE_LIQU') = 'N' and
         v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'S') then
        
          update come_soli_serv_anex_plan ap
             set ap.anpl_deta_esta_plan = 'S', ap.anpl_ortr_codi = null
           where ap.anpl_ortr_codi = v('P53_ORTR_CODI')
             and nvl(ap.anpl_deta_esta_plan, 'N') = 'N';
        
          update come_vehi
             set vehi_esta = 'P'
           where vehi_codi = v('P53_ORTR_VEHI_CODI');
        
          update come_soli_serv_anex_deta
             set deta_esta = 'P'
           where deta_codi = v('P53_ORTR_DETA_CODI');
        end if;
      end if;
    
    end if;
  
  end pp_desliquida_ot;

  procedure pp_eliminar_anex_desi is
  
    v_anex_codi number;
    v_vehi_codi number;
  
  begin
  
    begin
      select distinct (deta_anex_codi)
        into v_anex_codi
        from come_soli_serv_anex_deta
       where deta_codi_anex_padr = v('P53_ORTR_DETA_CODI');
    exception
      when no_data_found then
        v_anex_codi := null;
      when too_many_rows then
        v_anex_codi := null;
    end;
  
    begin
      select distinct (deta_vehi_codi)
        into v_vehi_codi
        from come_soli_serv_anex_deta
       where deta_codi_anex_padr = v('P53_ORTR_DETA_CODI')
         and deta_vehi_codi is not null;
    exception
      when no_data_found then
        v_vehi_codi := null;
      when too_many_rows then
        v_vehi_codi := null;
    end;
  
    if v_anex_codi is not null then
      delete come_docu_requ_vehi t
       where t.dove_anex_deta in
             (select deta_codi
                from come_soli_serv_anex_deta d
               where d.deta_codi_anex_padr = v('P53_ORTR_DETA_CODI'));
    end if;
    delete come_soli_serv_anex_deta d
     where d.deta_codi_anex_padr = v('P53_ORTR_DETA_CODI');
    delete come_soli_serv_anex a where a.anex_codi = v_anex_codi;
  
    if v_vehi_codi is not null then
      delete come_vehi v where v.vehi_codi = v_vehi_codi;
    end if;
  
  end pp_eliminar_anex_desi;

  procedure pp_eliminar_desi_ot_plan is
  
    v_ortr_sode_codi number(20);
  
  begin
  
    begin
      select ortr_sode_codi
        into v_ortr_sode_codi
        from come_orde_trab
       where ortr_codi =
             (select ortr_codi
                from come_orde_trab
               where ortr_codi_padr = v('P53_ORTR_CODI'));
    exception
      when no_data_found then
        null;
    end;
  
    --eliminar datos de tabla de plan, solic. desinst. y ot
    delete come_soli_serv_anex_plan
     where anpl_deta_codi = v('P53_ORTR_DETA_CODI');
    delete come_orde_trab
     where ortr_codi =
           (select ortr_codi
              from come_orde_trab
             where ortr_codi_padr = v('P53_ORTR_CODI'));
    delete come_soli_desi where sode_codi = v_ortr_sode_codi;
  
  end pp_eliminar_desi_ot_plan;

  procedure pp_actu_vehi_equi is
  
    v_indi_ajus varchar2(1);
  
    v_vehi_codi                number(20);
    v_vehi_secu                number(10);
    v_vehi_iden                varchar2(60);
    v_vehi_esta                varchar2(1);
    v_vehi_clpr_codi           number(20);
    v_vehi_clpr_sucu_nume_item number(20);
    v_vehi_fech_vige_inic      date;
    v_vehi_fech_vige_fini      date;
    v_vehi_base                number(2);
    v_vehi_equi_mode           varchar2(40);
    v_vehi_equi_id             varchar2(20);
    v_vehi_equi_imei           varchar2(20);
    v_vehi_equi_sim_card       varchar2(20);
    v_vehi_alar_id             varchar2(20);
    v_vehi_serv_tipo           varchar2(10);
    v_vehi_sose_codi           number(10);
    v_vehi_sode_codi           number(10);
    v_vehi_user_regi           varchar2(20);
    v_vehi_fech_regi           date;
    v_vehi_codi_hist           number(10);
    v_vehi_iden_ante           varchar2(20);
    v_vehi_ortr_codi           number(10);
    v_vehi_anex_codi           number(10);
    v_vehi_indi_hist_prin      varchar2(1);
    v_vehi_indi_old            varchar2(1);
  
  begin
  
    v_indi_ajus := 'N';
  
    if v('P53_VEHI_EQUI_MODE_NUEV') is not null then
      v_vehi_equi_mode := v('P53_VEHI_EQUI_MODE_NUEV');
      v_indi_ajus      := 'S';
    else
      v_vehi_equi_mode := v('P53_VEHI_EQUI_MODE');
    end if;
  
    if v('P53_VEHI_EQUI_ID_NUEV') is not null then
      v_vehi_equi_id := v('P53_VEHI_EQUI_ID_NUEV');
      v_indi_ajus    := 'S';
    else
      v_vehi_equi_id := v('P53_VEHI_EQUI_ID');
    end if;
  
    if v('P53_VEHI_EQUI_IMEI_NUEV') is not null then
      v_vehi_equi_imei := v('P53_VEHI_EQUI_IMEI_NUEV');
      v_indi_ajus      := 'S';
    else
      v_vehi_equi_imei := v('P53_VEHI_EQUI_IMEI');
    end if;
  
    if v('P53_VEHI_EQUI_SIM_CARD_NUEV') is not null then
      v_vehi_equi_sim_card := v('P53_VEHI_EQUI_SIM_CARD_NUEV');
      v_indi_ajus          := 'S';
    else
      v_vehi_equi_sim_card := v('P53_VEHI_EQUI_SIM_CARD');
    end if;
  
    if v('P53_VEHI_ALAR_ID_NUEV') is not null then
      v_vehi_alar_id := v('P53_VEHI_ALAR_ID_NUEV');
      v_indi_ajus    := 'S';
    else
      v_vehi_alar_id := v('P53_VEHI_ALAR_ID');
    end if;
  
    if v_indi_ajus = 'S' then
      if v_vehi_equi_imei is null or v_vehi_equi_sim_card is null or
         v_vehi_equi_id is null or v_vehi_equi_mode is null then
        raise_application_error(-20001,
                                'Los datos del dispositivo no pueden quedar vacios ');
      end if;
    
      update come_vehi
         set vehi_equi_mode     = v_vehi_equi_mode,
             vehi_equi_id       = v_vehi_equi_id,
             vehi_equi_imei     = v_vehi_equi_imei,
             vehi_equi_sim_card = v_vehi_equi_sim_card,
             vehi_alar_id       = v_vehi_alar_id
       where vehi_codi = v('P53_ORTR_VEHI_CODI');
    
      begin
        select nvl(max(vehi_secu), 0) + 1
          into v_vehi_secu
          from come_vehi_hist
         where vehi_codi = v('P53_ORTR_VEHI_CODI');
      
      exception
        when no_data_found then
          v_vehi_secu := 1;
      end;
    
      begin
        select nvl(vehi_esta, 'P')
          into v_vehi_esta
          from come_vehi
         where vehi_codi = v('P53_ORTR_VEHI_CODI');
      exception
        when no_data_found then
          v_vehi_esta := 'P';
      end;
    
      v_vehi_codi                := v('P53_ORTR_VEHI_CODI');
      v_vehi_iden                := v('P53_VEHI_IDEN');
      v_vehi_clpr_codi           := v('P53_ORTR_CLPR_CODI');
      v_vehi_clpr_sucu_nume_item := v('P53_ORTR_CLPR_SUCU_NUME_ITEM');
      v_vehi_fech_vige_inic      := v('P53_VEHI_FECH_VIGE_INIC');
      v_vehi_fech_vige_fini      := v('P53_VEHI_FECH_VIGE_FINI');
      v_vehi_base                := nvl(v('P53_P_CODI_BASE'), 1);
      v_vehi_serv_tipo           := v('P53_ORTR_SERV_TIPO');
      v_vehi_sose_codi           := v('P53_ORTR_SOSE_CODI');
      v_vehi_sode_codi           := v('P53_ORTR_SODE_CODI');
      v_vehi_user_regi           := fp_user;
      v_vehi_fech_regi           := sysdate;
      v_vehi_codi_hist           := fa_sec_vehi_hist;
      v_vehi_iden_ante           := null;
      v_vehi_ortr_codi           := v('P53_ORTR_CODI');
      v_vehi_anex_codi           := v('P53_ORTR_ANEX_CODI');
      v_vehi_indi_hist_prin      := null;
      v_vehi_indi_old            := 'N';
    
      insert into come_vehi_hist
        (vehi_codi,
         vehi_secu,
         vehi_iden,
         vehi_esta,
         vehi_clpr_codi,
         vehi_clpr_sucu_nume_item,
         vehi_fech_vige_inic,
         vehi_fech_vige_fini,
         vehi_base,
         vehi_equi_mode,
         vehi_equi_id,
         vehi_equi_imei,
         vehi_equi_sim_card,
         vehi_alar_id,
         vehi_serv_tipo,
         vehi_sose_codi,
         vehi_sode_codi,
         vehi_user_regi,
         vehi_fech_regi,
         vehi_codi_hist,
         vehi_iden_ante,
         vehi_ortr_codi,
         vehi_anex_codi,
         vehi_indi_hist_prin,
         vehi_indi_old)
      values
        (v_vehi_codi,
         v_vehi_secu,
         v_vehi_iden,
         v_vehi_esta,
         v_vehi_clpr_codi,
         v_vehi_clpr_sucu_nume_item,
         v_vehi_fech_vige_inic,
         v_vehi_fech_vige_fini,
         v_vehi_base,
         v_vehi_equi_mode,
         v_vehi_equi_id,
         v_vehi_equi_imei,
         v_vehi_equi_sim_card,
         v_vehi_alar_id,
         v_vehi_serv_tipo,
         v_vehi_sose_codi,
         v_vehi_sode_codi,
         v_vehi_user_regi,
         v_vehi_fech_regi,
         v_vehi_codi_hist,
         v_vehi_iden_ante,
         v_vehi_ortr_codi,
         v_vehi_anex_codi,
         v_vehi_indi_hist_prin,
         v_vehi_indi_old);
    end if;
  
  end pp_actu_vehi_equi;

  procedure pp_validar_ots_pend is
    v_ortr_nume varchar2(200);
  
    cursor c_come_ortr is
      select ortr_nume
        from come_orde_trab, come_vehi
       where ortr_vehi_codi = vehi_codi
         and ortr_esta = 'P'
         and vehi_codi = v('P53_ORTR_VEHI_CODI');
  
  begin
  
    for x in c_come_ortr loop
      v_ortr_nume := v_ortr_nume || x.ortr_nume || ' - ';
    end loop;
  
    if v_ortr_nume is not null then
      raise_application_error(-20001,
                              'No puede cargar otra OT para el vehiculo porque tiene OTS en estado pendiente ' ||
                              v_ortr_nume || ' asignados al vehiculo');
    end if;
  
  exception
    when no_data_found then
      null;
  end pp_validar_ots_pend;

  procedure pp_guardar_orden_trabajo is
    v_ortr_codi number;
    v_ortr_base number;
    v_esta      varchar2(1);
    --
    v_token_fcm varchar2(2000);
    v_user_fcm  varchar2(50);
    --
  begin
  
    if v('P53_ORTR_FECH_LIQU') is null and v('P53_ORTR_ESTA') = 'L' then
      -- v('p53_ortr_fech_inst') := nvl(v('p53_ortr_fech_liqu'), v('p53_ortr_fech_emis');
      setitem('P53_ORTR_FECH_LIQU', nvl(v('P53_ORTR_FECH_INST'), sysdate));
    end if;
  
    if v('P53_ORTR_FECH_INST') is null and v('P53_ORTR_ESTA') = 'L' then
      raise_application_error(-20001,
                              'La fecha de instalacion no puede quedar vacia');
    
    end if;
  
    if v('P53_ORTR_CODI') is null then
    
      v_ortr_codi := fa_sec_come_orde_trab;
      v_ortr_base := v('P53_P_CODI_BASE');
    
      setitem('P53_ORTR_CODI', v_ortr_codi);
      setitem('P53_ORTR_BASE', v_ortr_base);
    
      insert into come_orde_trab
        (ortr_codi,
         ortr_clpr_codi,
         ortr_empl_codi, --
         ortr_nume,
         ortr_fech_emis,
         ortr_fech_grab,
         ortr_user,
         ortr_fech_prev,
         ortr_fech_liqu,
         ortr_esta,
         ortr_desc,
         ortr_base,
         ortr_desc_prob,
         ortr_empr_codi,
         ortr_sucu_codi,
         ortr_mone_codi,
         ortr_mone_codi_prec,
         ortr_prec_vent,
         ortr_codi_padr,
         -- ortr_asie_codi_liqu,
         ortr_tran_cost_unit,
         ortr_tipo_cost_tran,
         ortr_clpr_codi_prov,
         ortr_fech_prev_cobr,
         ortr_pers_resp,
         ortr_sose_codi,
         ortr_empl_codi_vend,
         ortr_serv_tipo,
         --ortr_serv_cate,
         --ortr_serv_dato,
         ortr_serv_poli_nume,
         ortr_serv_obse,
         ortr_user_regi,
         ortr_fech_regi,
         ortr_user_modi,
         ortr_fech_modi,
         ortr_sode_codi,
         ortr_clpr_sucu_nume_item,
         --ortr_serv_tipo_inst,
         ortr_vehi_codi,
         ortr_fech_inst,
         --ortr_luga_inst,
         ortr_anex_codi,
         ortr_serv_tipo_moti,
         ortr_vehi_iden_ante,
         ortr_vehi_iden,
         ortr_deta_codi,
         ortr_esta_pre_liqu,
         ortr_indi_clie_veri_vehi,
         ortr_indi_rein_futu_gene,
         ortr_indi_cort_corr,
         ortr_indi_hora_extr,
         ortr_sistema,
         ortr_form_insu,
         ortr_lote_equipo
         --  ortr_fech_grab,
         ---  ortr_user
         --ortr_indi_hora_extr
         
         )
      values
        (v_ortr_codi,
         v('P53_ORTR_CLPR_CODI'),
         v('P53_VEHI_EMPL_CODI'), --v('p53_ortr_empl_codi'),--
         v('P53_ORTR_NUME'),
         v('P53_ORTR_FECH_EMIS'),
         sysdate,
         fp_user,
         v('P53_ORTR_FECH_PREV'),
         v('P53_ORTR_FECH_LIQU'),
         nvl(v('P53_ORTR_ESTA'), 'P'),
         v('P53_ORTR_DESC'),
         v_ortr_base, --v('p53_ortr_base'),
         v('P53_ORTR_DESC_PROB'),
         v('P53_P_EMPR_CODI'),
         nvl(v('P53_P_SUCU_CODI'), 1),
         v('P53_ORTR_MONE_CODI'),
         v('P53_ORTR_MONE_CODI_PREC'),
         v('P53_ORTR_PREC_VENT'),
         v('P53_ORTR_CODI_PADR'),
         -- v('p53_ortr_asie_codi_liqu'),
         v('P53_ORTR_TRAN_COST_UNIT'),
         v('P53_ORTR_TIPO_COST_TRAN'),
         v('P53_ORTR_CLPR_CODI_PROV'),
         v('P53_ORTR_FECH_PREV_COBR'),
         v('P53_ORTR_PERS_RESP'),
         v('P53_ORTR_SOSE_CODI'),
         v('P53_ORTR_EMPL_CODI_VEND'),
         v('P53_ORTR_SERV_TIPO'),
         --v('p53_ortr_serv_cate'),
         --v('p53_ortr_serv_dato'),
         v('P53_ORTR_SERV_POLI_NUME'),
         v('P53_ORTR_SERV_OBSE'),
         fp_user,
         sysdate,
         v('P53_ORTR_USER_MODI'),
         v('P53_ORTR_FECH_MODI'),
         v('P53_ORTR_SODE_CODI'),
         v('P53_ORTR_CLPR_SUCU_NUME_ITEM'),
         --v('p53_ortr_serv_tipo_inst'),
         v('P53_ORTR_VEHI_CODI'),
         v('P53_ORTR_FECH_INST'),
         --v('p53_ortr_luga_inst'),
         v('P53_ORTR_ANEX_CODI'),
         v('P53_ORTR_SERV_TIPO_MOTI'),
         v('P53_ORTR_VEHI_IDEN_ANTE'),
         v('P53_ORTR_VEHI_IDEN'),
         v('P53_ORTR_DETA_CODI'),
         nvl(v('P53_ORTR_ESTA_PRE_LIQU'), 'N'),
         v('P53_ORTR_INDI_CLIE_VERI_VEHI'),
         v('P53_ORTR_INDI_REIN_FUTU_GENE'),
         v('P53_ORTR_INDI_CORT_CORR'),
         v('P53_OTRO_LUGAR'),
         'APEX',
         v('P53_ORTR_FORM_INSU'),
         v('P53_VEHI_LOTE_RASTREO')
         
         --v('p53_ortr_indi_hora_extr')
         );
    
      --notificacion cobranzas app
      ---
      if v('P53_ORTR_SERV_TIPO') = 'C' and v('P53_ORTR_ESTA') = 'P' then
        pp_notification_fcm('I');
      end if;
      ---
    
    else
    
      --a verificar
      v_ortr_base := v('P53_P_CODI_BASE');
      setitem('P53_ORTR_BASE', v_ortr_base);
      if v('P53_ORTR_SODE_CODI') is not null then
        update come_soli_desi
           set sode_esta = 'L'
         where sode_codi = v('P53_ORTR_SODE_CODI');
      end if;
    
      if v('P53_ORTR_PRES_CODI_ORIG') is not null then
        update come_pres_clie
           set pres_esta_pres = 'P'
         where pres_codi = v('P53_ORTR_PRES_CODI_ORIG');
      end if;
    
      --notificacion cobranzas app
      ----
      if v('P53_ORTR_SERV_TIPO') = 'C' and v('P53_ORTR_ESTA') = 'P' then
      
        begin
          select s.user_token_fcm, s.user_login
            into v_token_fcm, v_user_fcm
            from come_orde_trab_vehi v,
                 come_orde_trab      o,
                 come_empl           e,
                 segu_user           s
           where o.ortr_codi = v('P53_ORTR_CODI')
             and v.vehi_ortr_codi = o.ortr_codi
             and v.vehi_empl_codi = e.empl_codi
             and s.user_empl_codi = e.empl_codi;
        exception
          when no_data_found then
            null;
          when others then
            raise_application_error(-20001, 'adf');
        end;
      
        --raise_application_error(-20001,'adfadf'||v('p53_vehi_ortr_codi')  );
      end if;
      ----
    
      update come_orde_trab
         set ortr_clpr_codi = v('P53_ORTR_CLPR_CODI'),
             ortr_empl_codi = v('P53_VEHI_EMPL_CODI'),
             ortr_nume      = v('P53_ORTR_NUME'),
             ortr_fech_emis = v('P53_ORTR_FECH_EMIS'),
             --  ortr_fech_grab          = v('p53_ortr_fech_grab'),
             ---  ortr_user               = v('p53_ortr_user '),
             ortr_fech_prev      = v('P53_ORTR_FECH_PREV'),
             ortr_fech_liqu      = v('P53_ORTR_FECH_LIQU'),
             ortr_esta           = nvl(v('P53_ORTR_ESTA'), 0),
             ortr_desc           = v('P53_ORTR_DESC'),
             ortr_base           = v_ortr_base,
             ortr_desc_prob      = v('P53_ORTR_DESC_PROB'),
             ortr_empr_codi      = v('P53_P_EMPR_CODI'),
             ortr_sucu_codi      = nvl(v('P53_P_SUCU_CODI'), 1),
             ortr_mone_codi      = v('P53_ORTR_MONE_CODI'),
             ortr_mone_codi_prec = v('P53_ORTR_MONE_CODI_PREC'),
             ortr_prec_vent      = v('P53_ORTR_PREC_VENT'),
             ortr_codi_padr      = v('P53_ORTR_CODI_PADR'),
             --- ortr_asie_codi_liqu     = v('p53_ortr_asie_codi_liqu'),
             ortr_tran_cost_unit = v('P53_ORTR_TRAN_COST_UNIT'),
             ortr_tipo_cost_tran = v('P53_ORTR_TIPO_COST_TRAN'),
             ortr_clpr_codi_prov = v('P53_ORTR_CLPR_CODI_PROV'),
             ortr_fech_prev_cobr = v('P53_ORTR_FECH_PREV_COBR'),
             ortr_pers_resp      = v('P53_ORTR_PERS_RESP'),
             ortr_sose_codi      = v('P53_ORTR_SOSE_CODI'),
             ortr_empl_codi_vend = v('P53_ORTR_EMPL_CODI_VEND'),
             ortr_serv_tipo      = v('P53_ORTR_SERV_TIPO'),
             -- ortr_serv_cate       = v('p53_ortr_empl_codi_vend'),
             --ortr_serv_dato        = v('p53_ortr_empl_codi_vend'),
             ortr_serv_poli_nume = v('P53_ORTR_SERV_POLI_NUME'),
             ortr_serv_obse      = v('P53_ORTR_SERV_OBSE'),
             ---  ortr_user_regi          = v('p53_ortr_user_regi'),
             --  ortr_fech_regi          = v('p53_ortr_fech_regi'),
             ---  ortr_user_regi          = fp_user,
             --- ortr_fech_regi          = sysdate,
             ortr_user_modi           = fp_user,
             ortr_fech_modi           = sysdate,
             ortr_sode_codi           = v('P53_ORTR_SODE_CODI'),
             ortr_clpr_sucu_nume_item = v('P53_ORTR_CLPR_SUCU_NUME_ITEM'),
             --  ortr_serv_tipo_inst                = v('p53_ortr_serv_tipo_inst'),
             ortr_vehi_codi           = v('P53_ORTR_VEHI_CODI'),
             ortr_fech_inst           = v('P53_ORTR_FECH_INST'),
             ortr_luga_inst           = v('P53_ORTR_LUGA_INST'),
             ortr_anex_codi           = v('P53_ORTR_ANEX_CODI'),
             ortr_serv_tipo_moti      = v('P53_ORTR_SERV_TIPO_MOTI'),
             ortr_vehi_iden_ante      = v('P53_ORTR_VEHI_IDEN_ANTE'),
             ortr_vehi_iden           = v('P53_ORTR_VEHI_IDEN'),
             ortr_deta_codi           = v('P53_ORTR_DETA_CODI'),
             ortr_esta_pre_liqu       = nvl(v('P53_ORTR_ESTA_PRE_LIQU'), 'N'),
             ortr_indi_clie_veri_vehi = v('P53_ORTR_INDI_CLIE_VERI_VEHI'),
             ortr_indi_rein_futu_gene = v('P53_ORTR_INDI_REIN_FUTU_GENE'),
             ortr_indi_cort_corr      = v('P53_ORTR_INDI_CORT_CORR'),
             ortr_indi_hora_extr      = v('P53_OTRO_LUGAR'),
             ortr_sistema             = 'APEX',
             ortr_form_insu           = v('P53_ORTR_FORM_INSU'),
             ortr_lote_equipo         = v('P53_VEHI_LOTE_RASTREO')
       where ortr_codi = v('P53_ORTR_CODI');
    
      --notificacion cobranzas app
      --
      if v('P53_ORTR_SERV_TIPO') = 'C' and v('P53_ORTR_ESTA') = 'P' then
        pp_notification_fcm('U', v_token_fcm, v_user_fcm);
        null;
      end if;
      --
    
    end if;
  
  end pp_guardar_orden_trabajo;

  procedure pp_guardar_orde_trab_vehi is
    v_vehi_cod  number;
    v_ortr_codi number;
    v_esta      varchar2(1);
  begin
  
    if v('P53_VEHI_ORTR_CODI') is null then
    
      insert into come_orde_trab_vehi
        (vehi_ortr_codi,
         vehi_nume_item,
         vehi_empl_codi,
         vehi_pola,
         vehi_leva_vidr_elec,
         vehi_retr_elec,
         vehi_limp_para_dela,
         vehi_limp_para_tras,
         vehi_tanq,
         vehi_dire_hidr,
         vehi_auto_radi,
         vehi_ante_elec,
         vehi_aire_acon,
         vehi_bloq_cent,
         vehi_abag,
         vehi_fabs,
         vehi_tapi,
         vehi_alar,
         vehi_boci,
         vehi_lava_faro,
         vehi_llan,
         vehi_cubi,
         vehi_comb,
         vehi_cent,
         vehi_chap,
         vehi_pint,
         vehi_lalt,
         vehi_lbaj,
         vehi_lrev,
         vehi_lgir,
         vehi_lpos,
         vehi_lint,
         vehi_lsto,
         vehi_lest,
         vehi_ltab,
         vehi_user_regi,
         vehi_fech_regi,
         vehi_user_modi,
         vehi_fech_modi,
         vehi_clve_clpr_codi,
         vehi_clve_nume_item)
      values
        (v('P53_ORTR_CODI'),
         1, --v('p53_vehi_nume_item'),
         v('P53_VEHI_EMPL_CODI'),
         v('P53_VEHI_POLA'),
         v('P53_VEHI_LEVA_VIDR_ELEC'),
         v('P53_VEHI_RETR_ELEC'),
         v('P53_VEHI_LIMP_PARA_DELA'),
         v('P53_VEHI_LIMP_PARA_TRAS'),
         v('P53_VEHI_TANQ'),
         v('P53_VEHI_DIRE_HIDR'),
         v('P53_VEHI_AUTO_RADI'),
         v('P53_VEHI_ANTE_ELEC'),
         v('P53_VEHI_AIRE_ACON'),
         v('P53_VEHI_BLOQ_CENT'),
         v('P53_VEHI_ABAG'),
         v('P53_VEHI_FABS'),
         v('P53_VEHI_TAPI'),
         v('P53_VEHI_ALAR'),
         v('P53_VEHI_BOCI'),
         v('P53_VEHI_LAVA_FARO'),
         v('P53_VEHI_LLAN'),
         v('P53_VEHI_CUBI'),
         v('P53_VEHI_COMB'),
         v('P53_VEHI_CENT'),
         v('P53_VEHI_CHAP'),
         v('P53_VEHI_PINT'),
         v('P53_VEHI_LALT'),
         v('P53_VEHI_LBAJ'),
         v('P53_VEHI_LREV'),
         v('P53_VEHI_LGIR'),
         v('P53_VEHI_LPOS'),
         v('P53_VEHI_LINT'),
         v('P53_VEHI_LSTO'),
         v('P53_VEHI_LEST'),
         v('P53_VEHI_LTAB'),
         fp_user,
         sysdate, --v('p53_vehi_fech_regi'),
         null, --v('p53_vehi_user_modi'),
         null, --v('p53_vehi_fech_modi'),
         v('P53_VEHI_CLVE_CLPR_CODI'),
         v('P53_VEHI_CLVE_NUME_ITEM'));
    
    else
    
      update come_orde_trab_vehi
         set vehi_empl_codi      = v('P53_VEHI_EMPL_CODI'),
             vehi_pola           = v('P53_VEHI_POLA'),
             vehi_leva_vidr_elec = v('P53_VEHI_LEVA_VIDR_ELEC'),
             vehi_retr_elec      = v('P53_VEHI_RETR_ELEC'),
             vehi_limp_para_dela = v('P53_VEHI_LIMP_PARA_DELA'),
             vehi_limp_para_tras = v('P53_VEHI_LIMP_PARA_TRAS'),
             vehi_tanq           = v('P53_VEHI_TANQ'),
             vehi_dire_hidr      = v('P53_VEHI_DIRE_HIDR'),
             vehi_auto_radi      = v('P53_VEHI_AUTO_RADI'),
             vehi_ante_elec      = v('P53_VEHI_ANTE_ELEC'),
             vehi_aire_acon      = v('P53_VEHI_AIRE_ACON'),
             vehi_bloq_cent      = v('P53_VEHI_BLOQ_CENT'),
             vehi_abag           = v('P53_VEHI_ABAG'),
             vehi_fabs           = v('P53_VEHI_FABS'),
             vehi_tapi           = v('P53_VEHI_TAPI'),
             vehi_alar           = v('P53_VEHI_ALAR'),
             vehi_boci           = v('P53_VEHI_BOCI'),
             vehi_lava_faro      = v('P53_VEHI_LAVA_FARO'),
             vehi_llan           = v('P53_VEHI_LLAN'),
             vehi_cubi           = v('P53_VEHI_CUBI'),
             vehi_comb           = v('P53_VEHI_COMB'),
             vehi_cent           = v('P53_VEHI_CENT'),
             vehi_chap           = v('P53_VEHI_CHAP'),
             vehi_pint           = v('P53_VEHI_PINT'),
             vehi_lalt           = v('P53_VEHI_LALT'),
             vehi_lbaj           = v('P53_VEHI_LBAJ'),
             vehi_lrev           = v('P53_VEHI_LREV'),
             vehi_lgir           = v('P53_VEHI_LGIR'),
             vehi_lpos           = v('P53_VEHI_LPOS'),
             vehi_lint           = v('P53_VEHI_LINT'),
             vehi_lsto           = v('P53_VEHI_LSTO'),
             vehi_lest           = v('P53_VEHI_LEST'),
             vehi_ltab           = v('P53_VEHI_LTAB'),
             -- vehi_user_regi         = v('p53_vehi_user_regi'),
             --vehi_fech_regi         = v('p53_vehi_fech_regi'),
             vehi_user_modi      = fp_user,
             vehi_fech_modi      = sysdate,
             vehi_clve_clpr_codi = v('P53_VEHI_CLVE_CLPR_CODI'),
             vehi_clve_nume_item = v('P53_VEHI_CLVE_NUME_ITEM')
       where vehi_ortr_codi = v('P53_VEHI_ORTR_CODI')
         and vehi_nume_item = v('P53_VEHI_NUME_ITEM');
    
    end if;
    /* update come_orde_trab_vehi
                 set vehi_empl_codi =  v('p53_vehi_empl_codi')
                where ortr_deta_codi = v('p53_ortr_deta_codi');
    */
  
    if v('P53_ORTR_SERV_TIPO') in ('RI', 'I') then
    
      begin
        select v.vehi_ortr_codi, t.ortr_codi, nvl(t.ortr_esta, 'P')
          into v_vehi_cod, v_ortr_codi, v_esta
          from come_orde_trab t, come_orde_trab_vehi v
         where t.ortr_codi <> v('P53_ORTR_CODI')
           and t.ortr_deta_codi = v('P53_ORTR_DETA_CODI')
           and t.ortr_codi = v.vehi_ortr_codi(+)
           and t.ortr_serv_tipo in ('C', 'I');
        /*  if fp_user = 'skn' then
            raise_application_error (-20001,'error1111');
        end if;*/
        if v_esta = 'P' then
        
          if v_vehi_cod is null then
            --  raise_application_error(-20001, v('p53_ortr_serv_tipo') );
            -- raise_application_error(-20001, v_vehi_cod );
            insert into come_orde_trab_vehi
              (vehi_ortr_codi,
               vehi_nume_item,
               vehi_empl_codi,
               vehi_pola,
               vehi_leva_vidr_elec,
               vehi_retr_elec,
               vehi_limp_para_dela,
               vehi_limp_para_tras,
               vehi_tanq,
               vehi_dire_hidr,
               vehi_auto_radi,
               vehi_ante_elec,
               vehi_aire_acon,
               vehi_bloq_cent,
               vehi_abag,
               vehi_fabs,
               vehi_tapi,
               vehi_alar,
               vehi_boci,
               vehi_lava_faro,
               vehi_llan,
               vehi_cubi,
               vehi_comb,
               vehi_cent,
               vehi_chap,
               vehi_pint,
               vehi_lalt,
               vehi_lbaj,
               vehi_lrev,
               vehi_lgir,
               vehi_lpos,
               vehi_lint,
               vehi_lsto,
               vehi_lest,
               vehi_ltab,
               vehi_user_regi,
               vehi_fech_regi,
               vehi_user_modi,
               vehi_fech_modi,
               vehi_clve_clpr_codi,
               vehi_clve_nume_item)
            values
              (v_ortr_codi,
               1, --v('p53_vehi_nume_item'),
               v('P53_VEHI_EMPL_CODI'),
               v('P53_VEHI_POLA'),
               v('P53_VEHI_LEVA_VIDR_ELEC'),
               v('P53_VEHI_RETR_ELEC'),
               v('P53_VEHI_LIMP_PARA_DELA'),
               v('P53_VEHI_LIMP_PARA_TRAS'),
               v('P53_VEHI_TANQ'),
               v('P53_VEHI_DIRE_HIDR'),
               v('P53_VEHI_AUTO_RADI'),
               v('P53_VEHI_ANTE_ELEC'),
               v('P53_VEHI_AIRE_ACON'),
               v('P53_VEHI_BLOQ_CENT'),
               v('P53_VEHI_ABAG'),
               v('P53_VEHI_FABS'),
               v('P53_VEHI_TAPI'),
               v('P53_VEHI_ALAR'),
               v('P53_VEHI_BOCI'),
               v('P53_VEHI_LAVA_FARO'),
               v('P53_VEHI_LLAN'),
               v('P53_VEHI_CUBI'),
               v('P53_VEHI_COMB'),
               v('P53_VEHI_CENT'),
               v('P53_VEHI_CHAP'),
               v('P53_VEHI_PINT'),
               v('P53_VEHI_LALT'),
               v('P53_VEHI_LBAJ'),
               v('P53_VEHI_LREV'),
               v('P53_VEHI_LGIR'),
               v('P53_VEHI_LPOS'),
               v('P53_VEHI_LINT'),
               v('P53_VEHI_LSTO'),
               v('P53_VEHI_LEST'),
               v('P53_VEHI_LTAB'),
               fp_user,
               sysdate, --v('p53_vehi_fech_regi'),
               null, --v('p53_vehi_user_modi'),
               null, --v('p53_vehi_fech_modi'),
               v('P53_VEHI_CLVE_CLPR_CODI'),
               v('P53_VEHI_CLVE_NUME_ITEM'));
          else
          
            update come_orde_trab_vehi
               set vehi_empl_codi = v('P53_VEHI_EMPL_CODI')
             where vehi_ortr_codi = v_vehi_cod;
          
          end if;
        end if;
      exception
        when no_data_found then
          null;
        
      end;
    
      --   raise_application_error(-20001, 'afdasdf' );
    end if;
  
  end pp_guardar_orde_trab_vehi;

  procedure pp_borrar_registro is
  
    v_count          number := 0;
    v_vehi_esta      varchar2(1);
    v_vehi_esta_ante varchar2(1);
  
    v_message varchar2(70) := '?Confirma la eliminaci?n del registro?';
    v_codi    number;
  begin
    pp_validar_borrado;
  
    if v('P53_ORTR_CODI') is null then
      raise_application_error(-20001,
                              'Debe elegir algun registro para eliminar');
    else
      pp_valida_movi_ent_sal;
    
      pp_borrar_datos;
    
      delete from come_orde_trab_cont c
       where c.cont_ortr_codi = v('P53_BCAB.ORTR_CODI');
    
      delete from come_orde_trab_vehi c
       where c.vehi_ortr_codi = v('P53_ORTR_CODI');
    
      delete from come_orde_trab x where x.ortr_codi = v('P53_ORTR_CODI');
    
    end if;
    /*if fp_user = 'skn' then
        raise_application_error (-20001,'654adf');
    end if;*/
  end pp_borrar_registro;

  procedure pp_validar_borrado is
  
    v_count     number;
    v_cant      number;
    v_cant_ot   number;
    v_cant_plan number;
  
    v_vehi      number;
    v_vehi_codi number;
    v_fech_inst date;
    v_fech_emis date;
    v_ortr_nume varchar2(20);
  
  begin
    if v('P53_ORTR_SERV_TIPO') in
       ('I', 'RI', 'R', 'S', 'T', 'O', 'RAS', 'D') then
      raise_application_error(-20001,
                              'Solo se pueden borrar OT de Servicio de carga manual. Deben ser eliminados desde Programas de Autorizaciones que los genero.');
    end if;
  
    v_cant := 0;
  
    begin
      select count(*)
        into v_count
        from come_movi, come_orde_trab
       where movi_ortr_codi = ortr_codi
         and ortr_codi = v('P53_ORTR_CODI');
    
      v_cant := v_cant + v_count;
    
      if v_cant > 0 then
        raise_application_error(-20001,
                                'No se puede eliminar porque existe/n' || '  ' ||
                                v_cant || ' ' ||
                                ' registro/s relacionado/s');
      end if;
    end;
  
    /*select count(*)
    into v_count
    from come_ortr_tran, come_orde_trab
    where ortr_ortr_codi = ortr_codi
    and ortr_codi = :bcab.ortr_codi;
    
    v_cant := v_cant + v_count;
    
    select count (*)
    into v_count
    from come_ortr_etap, come_orde_trab
    where oret_ortr_codi = ortr_codi
    and ortr_codi = :bcab.ortr_codi;
    
    v_cant := v_cant + v_count;
    
    select count (*)
    into v_count
    from come_mano_obra_deta, come_orde_trab
    where made_ortr_codi = ortr_codi
    and ortr_codi = :bcab.ortr_codi;
    
    v_cant := v_cant + v_count;
    
    select count (*)
    into v_count
    from come_movi_apli_adel_ortr
    where ador_ortr_codi = :bcab.ortr_codi;
    
    v_cant := v_cant + v_count;
    
    if v_cant > 0 then
      pl_mostrar_error('no se puede eliminar porque existe/n'||'  '||v_cant||' '|| ' registro/s relacionado/s');
    end if;
    
    select count(*)
    into v_count
    from come_ortr_limi_cost
    where lico_ortr_codi = :bcab.ortr_codi;
    
    if v_count > 0 then
       pl_me('primero debe eliminar el l?mite de costo');
    end if;*/
  
    if v('P53_ORTR_ESTA_ORIG') = 'L' or
       v('P53_USER_INDI_MODI_DATO_OT_FINI') <> 'S' then
      --if :bcab.ortr_esta = 'l' then
      raise_application_error(-20001, 'La OT ya ha sido Liquidada!');
      --end if;
    end if;
  
    -----------------------------------------
    begin
      select count(ortr_nume)
        into v_cant_ot
        from come_orde_trab
       where ortr_codi > v('P53_ORTR_CODI')
         and ortr_vehi_codi = v('P53_ORTR_VEHI_CODI')
         and ortr_serv_tipo_moti not in ('CT', 'CR', 'CS', 'CRAS'); --desinstalaciones por cambios
    
      if v_cant_ot > 0 then
        raise_application_error(-20001,
                                'No puede eliminar la OT, porque existen OTS posteriores asignados al vehiculo.');
      end if;
    end;
  
    if v('P53_ORTR_SERV_TIPO') not in ('D', 'IA', 'V', 'VA') then
      --este tipo de ot no afectan plan de facturacion asi que no bloquea borrado
      begin
        select count(anpl_codi)
          into v_cant_plan
          from come_soli_serv_anex_plan
         where anpl_deta_codi = v('P53_ORTR_DETA_CODI');
      
        if v_cant_plan > 0 then
          raise_application_error(-20001,
                                  'No puede eliminar la OT, porque existe Plan de Facturaci?n asignados al vehiculo.');
        end if;
      end;
    end if;
  
    if v('P53_ORTR_CODI_PADR') is not null then
      select ortr_nume
        into v_ortr_nume
        from come_orde_trab
       where ortr_codi = v('P53_ORTR_CODI_PADR');
    
      raise_application_error(-20001,
                              'No se puede borrar OT ya que est? relacionada a OT padre n?mero ' ||
                              v_ortr_nume || '.');
    end if;
  end pp_validar_borrado;

  procedure pp_borrar_datos is
    v_vehi_esta   varchar2(1);
    v_vehi_estado varchar2(1);
    v_count       number := 0;
    v_vehi_codi   number;
    v_movi_codi   number;
    v_movi_codi2  number;
    cursor cv_ortr_hija is
      select ortr_codi,
             ortr_nume,
             ortr_sode_codi,
             ortr_vehi_codi,
             ortr_sose_codi
        from come_orde_trab
       where ortr_codi_padr = v('P53_ORTR_CODI');
  begin
    --si tiene ot hija
    --
    for r in cv_ortr_hija loop
      --   pl_mm('se borrar? ot hija n?mero '||r.ortr_nume);
      --volver a pendiente solicitud de desinstalacion.
      update come_soli_desi
         set sode_esta = 'P'
       where sode_codi = r.ortr_sode_codi;
    
      --si es una ot de reinstalacion.. debe borrar la ot y volver a pendiente el contrato si
      if v('P53_P_CODI_CLAS1_CLIE_SUBCLIE') <> v('P53_S_CLAS1_CODI') then
        update come_soli_serv
           set sose_esta = 'P'
         where sose_codi = r.ortr_sose_codi;
      end if;
    
      begin
        select vehi_esta
          into v_vehi_estado
          from come_vehi v
         where vehi_codi = r.ortr_vehi_codi;
        -----------------
      
      exception
        when others then
          v_vehi_esta := 'P';
      end;
    
      update come_vehi
         set vehi_esta = v_vehi_esta, vehi_esta_vehi = 'A'
       where vehi_codi = r.ortr_vehi_codi;
    
      -----------------------------
      if v('P53_ORTR_SERV_TIPO') = 'D' then
        if v_vehi_estado = 'I' then
          if v_vehi_esta = 'P' then
            update come_vehi
               set vehi_esta = v_vehi_estado, vehi_esta_vehi = 'A'
             where vehi_codi = r.ortr_vehi_codi;
          end if;
        end if;
      end if;
      -----------------------------
    
      -----------------------desde aqui***lv 19-04-2023
      begin
        select movi_codi
          into v_movi_codi
          from come_movi a
         where movi_ortr_codi = r.ortr_codi;
      
        delete come_movi_prod_deta where deta_movi_codi = v_movi_codi;
        delete come_movi a where a.movi_codi = v_movi_codi;
      
      exception
        when no_data_found then
          null;
      end;
      ------------------------------------ hasta aqui***lv 19-04-2023  
    
      delete come_orde_trab_cont c where cont_ortr_codi = r.ortr_codi;
      delete from come_orde_trab_vehi where vehi_ortr_codi = r.ortr_codi;
      delete from come_orde_trab_equi where equi_ortr_codi = r.ortr_codi;
      delete from come_orde_trab where ortr_codi = r.ortr_codi;
    end loop;
    --
    --
    update come_orde_trab
       set ortr_vehi_codi = null
     where ortr_codi = v('P53_ORTR_CODI');
    update come_orde_trab
       set ortr_base = v('P53_P_CODI_BASE')
     where ortr_codi = v('P53_ORTR_CODI');
    if v('P53_ORTR_PRES_CODI_ORIG') is not null then
      update come_pres_clie
         set pres_esta_pres = 'P'
       where pres_codi = v('P53_ORTR_PRES_CODI_ORIG');
    end if;
    --volver a pendiente solicitud de desinstalacion.
    update come_soli_desi
       set sode_esta = 'P'
     where sode_codi = v('P53_ORTR_SODE_CODI');
    --si es una ot de reinstalacion.. debe borrar la ot y volver a pendiente el contrato si
    if v('P53_P_CODI_CLAS1_CLIE_SUBCLIE') <> v('P53_S_CLAS1_CODI') then
      update come_soli_serv
         set sose_esta = 'P'
       where sose_codi = v('P53_ORTR_SOSE_CODI');
    end if;
    --colocar anexo a pendiente nuevamente al borrar ot.
    update come_soli_serv_anex
       set anex_esta = 'P'
     where anex_codi = v('P53_ORTR_ANEX_CODI');
    --
    /* if nvl(:parameter.p_borr_vehi,'n') = 's' then
      ---primero se nulea el campo de vehiculo
      update come_orde_trab
         set ortr_vehi_codi = null
       where ortr_codi = :bcab.ortr_codi;
    
      v_vehi_codi := :bcab.ortr_vehi_codi;
      :bcab.ortr_vehi_codi := null;
    
      delete come_vehi where vehi_codi = v_vehi_codi;
    else
      --se debe revertir el estado de un vehiculo. recupera el ultimo estado distinto al actual. o sino pendiente.
      begin
        select vehi_esta
          into v_vehi_esta
          from come_vehi_hist
         where vehi_codi = :bcab.ortr_vehi_codi
           and vehi_secu = (select max(vehi_secu)
                              from come_vehi_hist vh, come_vehi v
                             where v.vehi_codi = vh.vehi_codi
                               and vh.vehi_esta <> v.vehi_esta
                               and v.vehi_codi = :bcab.ortr_vehi_codi);
    -----------------
     select vehi_esta
      into v_vehi_estado
        from come_vehi v
     where vehi_codi = :bcab.ortr_vehi_codi;
    -----------------
      exception
        when others then
          v_vehi_esta := 'p';
      end;
    
      update come_vehi
         set vehi_esta = v_vehi_esta,
             vehi_esta_vehi = 'a'
       where vehi_codi = :bcab.ortr_vehi_codi;
    end if;*/
  
    -----------------------------
    if v('P53_ORTR_SERV_TIPO') = 'D' then
      if v_vehi_estado = 'I' then
        if v_vehi_esta = 'P' then
          update come_vehi
             set vehi_esta = v_vehi_estado, vehi_esta_vehi = 'A'
           where vehi_codi = v('P53_ORTR_VEHI_CODI');
        end if;
      end if;
    end if;
    -----------------------------
  
    -----------------------desde aqui***lv 19-04-2023
    begin
      select movi_codi
        into v_movi_codi2
        from come_movi a
       where movi_ortr_codi = v('P53_ORTR_CODI');
    
      delete come_movi_prod_deta where deta_movi_codi = v_movi_codi2;
    
      delete come_movi a where a.movi_codi = v_movi_codi2;
    
    exception
      when no_data_found then
        null;
    end;
    ------------------------------------ hasta aqui***lv 19-04-2023  
  
    delete come_orde_trab_cont c
     where c.cont_ortr_codi = v('P53_ORTR_CODI');
    delete come_orde_trab_vehi v
     where v.vehi_ortr_codi = v('P53_ORTR_CODI');
    delete come_orde_trab_equi e
     where e.equi_ortr_codi = v('P53_ORTR_CODI');
    --delete come_orde_trab where ortr_codi = v('p53_ortr_codi');
  end pp_borrar_datos;

  procedure pp_generar_anex_rein_futu is
  
  begin
  
    if nvl(v('P53_ORTR_INDI_REIN_FUTU_GENE'), 'N') = 'S' then
    
      raise_application_error(-20001,
                              'El Pre-Anexo de la OT de Desinstalaci?n por Reinstalaci?n a Futuro ya fue generado.');
    else
      pp_generar_anex_desi;
    
      setitem('P53_ORTR_INDI_REIN_FUTU_GENE', 'S');
    
      update come_orde_trab
         set ortr_indi_rein_futu_gene = v('P53_ORTR_INDI_REIN_FUTU_GENE')
       where ortr_codi = v('P53_ORTR_CODI');
    
    end if;
  
  end pp_generar_anex_rein_futu;

  procedure pp_mostrar_moneda is
    v_mone_desc varchar2(100);
    v_cant_deci varchar2(100);
  begin
  
    if v('P53_ORTR_MONE_CODI_PREC') is not null then
      setitem('P53_ORTR_MONE_CODI_PREC', v('P53_P_CODI_MONE_MMNN'));
    end if;
  
    if v('P53_ORTR_MONE_CODI') is not null then
      select m.mone_desc, m.mone_cant_deci
        into v_mone_desc, v_cant_deci
        from come_mone m
       where m.mone_codi = v('P53_ORTR_MONE_CODI');
    
      setitem('P53_MONE_DESC', v_mone_desc);
      setitem('P53_MONE_CANT_DECI', v_cant_deci);
    
      setitem('P53_ORTR_TRAN_COST_UNIT',
              round(v('P53_ORTR_TRAN_COST_UNIT', v_cant_deci)));
      setitem('P53_IMPO_APLI', round(v('P53_IMPO_APLI', v_cant_deci)));
      setitem('P53_SUM_IMPO_APLI',
              round(v('P53_SUM_IMPO_APLI', v_cant_deci)));
    
    else
      if v('P53_ORTR_TIPO_COST_TRAN') = 2 then
        raise_application_error(-20001,
                                'Debe ingresar la moneda del costeo!');
      end if;
    
    end if;
  
    if v('P53_ORTR_MONE_CODI') not in
       (v('P53_P_CODI_MONE_MMNN'), v('P53_P_CODI_MONE_MMEE')) then
      raise_application_error(-20001,
                              'El codigo de moneda debe ser Moneda Nacional o Moneda Extranjera.');
    end if;
  
    if nvl(v('P53_ORTR_PREC_VENT'), 0) <= 0 then
      setitem('P53_ORTR_PREC_VENT', 0);
    
      ---  :bcab.ortr_prec_vent := 0;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Moneda Inexistente!');
    
  end pp_mostrar_moneda;

  procedure pp_imprimir_reportes is
  
  begin
    if v('P53_EMPL_CODI_ALTE_VEHI') is not null then
      null; -- pp_llama_reporte;
      if v('P53_ORTR_SERV_TIPO') in ('IA') then
        null; -- pp_llama_reporte_garantia;
      end if;
    else
      if v('P53_ORTR_SERV_TIPO') in ('T', 'S', 'R', 'RAS') then
        null; -- pp_llama_reporte;
        if v('P53_ORTR_SERV_TIPO') in ('IA') then
          null; --pp_llama_reporte_garantia;
        end if;
      else
        raise_application_error(-20001, 'Debe seleccionar un T?cnico!');
      end if;
    end if;
  
  end pp_imprimir_reportes;
  /*
  -----------------------validaciones antes de hacer algun cambio
  /*
  if ortr_nume is null then
    raise_appliaction_error (-20001,debe ingresar el nro de ot.);
  end if;
  if ortr_desc is null then
    raise_appliaction_error (-20001,debe ingresar la descripcion de la ot);
  end if;
  
  if :p53_ortr_fech_inst is not null then
    if :p53_ortr_fech_inst < :p53_ortr_fech_emis then
     raise_application_error(-20001, 'la fecha de realizado no puede ser inferior a la fecha de emisi?n.');
    end if;
  end if;
  
  if :bcab.ortr_codi is null then
    if :bcab.ortr_esta = 'l' then
      :bcab.ortr_esta := 'p';
      pl_me('el estado debe ser pendiente al crear la ot.');
    end if;
  end if;
  
  
  if :p53_ortr_esta_pre_liqu_orig= 's' then
    if :p53_ortr_esta_pre_liqu = 'n' and :p53_ortr_esta = 'l' then
      raise_application_error(-20001,'primero debe cambiar estado de la ot, para modificar la pre-liquidaci?n.');
    end if;
  end if;
  
  if p53_clpr_codi_alte is null then
  
    raise_application_error(-20001,'el cliente no puede quedar vacio');
  
  
  
  end if;
  
  
  
  if :bcab.s_vehi_fech_vige_inic is null then
    :bcab.s_vehi_fech_vige_inic := to_char(:bcab.ortr_fech_emis, 'dd-mm-yyyy');
  end if;
  
  af_validar_fecha(upper('ovf'), upper('bcab.s_vehi_fech_vige_inic'), null, :global.fecha_sistema);
  :bcab.vehi_fech_vige_inic := to_date(:bcab.s_vehi_fech_vige_inic, 'dd-mm-yyyy');
  
  if :bcab.vehi_fech_vige_inic is not null and :bcab.vehi_fech_vige_fini is null then
    :bcab.vehi_fech_vige_fini := add_months(:bcab.vehi_fech_vige_inic, nvl(:bcab.sose_dura_cont,12)- 1);
    :bcab.s_vehi_fech_vige_fini := to_char(:bcab.vehi_fech_vige_fini, 'dd-mm-yyyy');
  end if;
  next_item;
  */

  procedure pp_agregar_cont is
  
  begin
  
    if v('P53_OPCION') = 'A' then
      apex_collection.add_member(p_collection_name => 'ORDE_TRAB_CONT',
                                 p_c001            => v('P53_CONT_ORTR_CODI'),
                                 p_c002            => v('P53_CONT_NUME_ITEM'),
                                 p_c003            => v('P53_CONT_TIPO'),
                                 p_c004            => v('P53_CONT_APEL'),
                                 p_c005            => v('P53_CONT_NOMB'),
                                 p_c006            => v('P53_CONT_VINC'),
                                 p_c007            => v('P53_CONT_NUME_DOCU'),
                                 p_c008            => null,
                                 p_c009            => v('P53_CONT_TELE'),
                                 p_c010            => v('P53_CONT_CELU'),
                                 p_c011            => null,
                                 p_c012            => fp_user,
                                 p_c013            => sysdate,
                                 p_c014            => null,
                                 p_c015            => null);
    else
    
      apex_collection.delete_member(p_collection_name => 'ORDE_TRAB_CONT',
                                    p_seq             => v('P53_SEQ_ID'));
    
      apex_collection.add_member(p_collection_name => 'ORDE_TRAB_CONT',
                                 p_c001            => v('P53_CONT_ORTR_CODI'),
                                 p_c002            => v('P53_CONT_NUME_ITEM'),
                                 p_c003            => v('P53_CONT_TIPO'),
                                 p_c004            => v('P53_CONT_APEL'),
                                 p_c005            => v('P53_CONT_NOMB'),
                                 p_c006            => v('P53_CONT_VINC'),
                                 p_c007            => v('P53_CONT_NUME_DOCU'),
                                 p_c008            => null,
                                 p_c009            => v('P53_CONT_TELE'),
                                 p_c010            => v('P53_CONT_CELU'),
                                 p_c011            => null,
                                 p_c012            => v('P53_CONT_USER_REGI'),
                                 p_c013            => v('P53_CONT_FECH_REGI'),
                                 p_c014            => fp_user,
                                 p_c015            => sysdate);
    
    end if;
  
  end pp_agregar_cont;

  procedure pp_guardar_orde_trab_cont is
  
  begin
    delete come_orde_trab_cont where cont_ortr_codi = v('P53_ORTR_CODI');
  
    insert into come_orde_trab_cont
      (cont_ortr_codi,
       cont_nume_item,
       cont_tipo,
       cont_apel,
       cont_nomb,
       cont_vinc,
       cont_nume_docu,
       cont_pass,
       cont_tele,
       cont_celu,
       cont_hora,
       cont_user_regi,
       cont_fech_regi,
       cont_user_modi,
       cont_fech_modi)
      (select c001 cont_ortr_codi,
              c002 cont_nume_item,
              c003 cont_tipo,
              c004 cont_apel,
              c005 cont_nomb,
              c006 cont_vinc,
              c007 cont_nume_docu,
              c008 cont_pass,
              c009 cont_tele,
              c010 cont_celu,
              c011 cont_hora,
              c012 cont_user_regi,
              c013 cont_fech_regi,
              c014 cont_user_modi,
              c015 cont_fech_modi
         from apex_collections
        where collection_name = 'ORDE_TRAB_CONT');
  
  end pp_guardar_orde_trab_cont;

  procedure pp_llamar_reporte(p_orden_tra in varchar2,
                              p_reporte   in varchar2) is
    v_nombre       varchar2(50);
    v_parametros   clob;
    v_contenedores clob;
  
  begin
  
    --v_nombre:=  'comisioncobranzas'; comisioninstalaciones
    v_contenedores := 'p_ortr_codi';
    v_parametros   := p_orden_tra;
  
    delete from come_parametros_report where usuario = v('APP_USER');
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, v('APP_USER'), 'ORTR', 'pdf', v_contenedores);
  
  end pp_llamar_reporte;

  procedure pp_crear_usuario_mapa is
    v_existe number;
  begin
  
    if v('P53_ORTR_CODI') is null then
      raise_application_error(-20001, 'LA ORDEN AUN NO EXITE');
    end if;
  
    if v('P53_ORTR_CLPR_CODI') is null then
      raise_application_error(-20001, 'EL CLIENTE NO PUEDE ESTAR VACIO');
    end if;
  
    if v('P53_CLPR_EMAIL') is null then
      raise_application_error(-20001, 'EL E-MAIL NO PUEDE ESTAR VACIO');
    end if;
  
    if v('P53_VEHI_EQUI_IMEI') is null then
      raise_application_error(-20001,
                              'EL EMEI ACTUAL NO PUEDE ESTAR VACIO');
    end if;
    if v('P53_VEHI_EQUI_ID') is null then
      raise_application_error(-20001, 'EL ID ACTUAL NO PUEDE ESTAR VACIO');
    end if;
  
    if v('P53_ORTR_CLPR_CODI') is null then
      raise_application_error(-20001, 'EL VEHICULO NO PUEDE QUEDAR VACIO');
    end if;
  
    /*select count(*)
     into v_existe
     from come_mapa_get_chas_mail t
    where gmch_email = v('p53_clpr_email');
    
    if v_existe = 0 then*/
  
    pack_mapas_gpswox.pa_add_cliente_mapa(p_cliente => v('P53_CLPR_EMAIL'));
    --- end if;/*
  
    pack_mapas_gpswox.pa_add_device_mapa(p_cliente  => v('p53_ortr_clpr_codi'),
                                         p_vehiculo => v('p53_ortr_vehi_codi'));
  
 /*   pack_mapas_gpswox.pa_add_cliente_device(p_cliente  => v('p53_ortr_clpr_codi'),
                                            p_vehiculo => v('p53_ortr_vehi_codi'));
*/  
    if v_existe = 1 then
      setitem('p53_mens_usuario',
              'se creo correctamente el dispositivo, el usuario ya exitia');
    
    else
      setitem('p53_mens_usuario',
              'se creo correctamente el usuario y el dispositivo');
    end if;
  
  end pp_crear_usuario_mapa;

  procedure pp_buscar_dispositivo(p_cliente        in varchar2,
                                  p_vehiculo       in varchar2,
                                  p_ortr_codi      in number,
                                  p_names          out varchar2,
                                  p_timezone_id    out varchar2,
                                  p_sim_number     out varchar2,
                                  p_vin            out varchar2,
                                  p_device_model   out varchar2,
                                  p_plate_number   out varchar2,
                                  p_object_owner   out varchar2,
                                  p_correo         out varchar2,
                                  p_vehi_equi_imei out varchar2,
                                  p_name_ant       out varchar2,
                                  p_dis_id         out varchar2) is
  
    v_param          varchar2(32000);
    v_url            varchar2(4000);
    v_status         varchar2(20);
    v_mensaje        varchar2(1000);
    v_hash           varchar2(1000);
    x_contador       number := 0;
    v_comp_user varchar2(50);
    v_comp_pass varchar2(100);
    v_comp_host varchar2(1000);
  
    v_sysdate       date := sysdate;
    v_array         varchar2(2000);
    v_json          clob;
    l_json_doc      clob;
    v_ultima_pagina number;
    v_email_cliente varchar2(60);
    vl_url          varchar2(200);
    v_hash_cli      varchar2(1000);
    v_ult_letra     varchar2(2000);
    cantidad        number;
  
    v_names          varchar2(2000);
    v_timezone_id    varchar2(2000);
    v_sim_number     varchar2(2000);
    v_vin            varchar2(2000);
    v_device_model   varchar2(2000);
    v_plate_number   varchar2(2000);
    v_object_owner   varchar2(2000);
    v_correo         varchar2(2000);
    v_vehi_equi_imei varchar2(2000);
  
    v_ortr_serv_tipo varchar2(5);
    v_ortr_esta      varchar2(5);
  
  begin
    --  raise_application_error(-20001, vl_url);
    if p_cliente is null then
      raise_application_error(-20001, 'el cliente no puede estar vacio');
    end if;
  
    if p_vehiculo is null then
      raise_application_error(-20001, 'el vehiculo no puede estar vacio');
    end if;
  
    begin
      select t.ortr_serv_tipo, t.ortr_esta
        into v_ortr_serv_tipo, v_ortr_esta
        from come_orde_trab t
       where t.ortr_codi = p_ortr_codi;
    exception
      when no_data_found then
        raise_application_error(-20001, 'tiene que crear primero la ot');
    end datos_ot;
  
    if v_ortr_serv_tipo = 't' and nvl(v_ortr_esta, 'p') <> 'l' then
      raise_application_error(-20001, 'primero tiene que liquidar la ot.');
    end if;
  
     
      select e.comp_user, e.comp_pass, e.comp_host
        into v_comp_user, v_comp_pass,v_comp_host
        from segu_comp_sist e
       where e.comp_empr_codi = 1;
  
    apex_json.initialize_clob_output;
    apex_json.open_object;
  
    apex_json.write('email', v_comp_user);
    apex_json.write('password', v_comp_pass);
  
    apex_json.close_object;
  
    v_param := apex_json.get_clob_output;
    apex_json.free_output;
    pack_mapas.pa_obtiene_hash(v_param, v_hash);
  
    select to_Char(vehi_nume_pate) || ' - ' || c.clpr_nomb || ' ' || clpr_apel names,
          to_char(case
             when upper(vehi_equi_mode) = upper('crx3') then
              73
             else
              41
           end) timezone_id, ---id de zona horaria
           to_char(v.vehi_equi_sim_card) sim_number, ---n?mero sim
           to_char(v.vehi_nume_chas) vin,
           to_char(v.vehi_equi_mode) device_model, ---modelo de dispositivo
           to_char(v.vehi_nume_pate) plate_number, ---n?mero de placa
           to_char(clpr_codi_alte) object_owner, ---propietaria de objetos
           nvl(clpr_email, clpr_email_fact) correo,
           to_char(vehi_equi_imei)
      into p_names,
           p_timezone_id,
           p_sim_number,
           p_vin,
           p_device_model,
           p_plate_number,
           p_object_owner,
           p_correo,
           p_vehi_equi_imei
      from come_vehi v, come_clie_prov c
     where v.vehi_clpr_codi = c.clpr_codi
       and c.clpr_codi = p_cliente
       and v.vehi_codi = p_vehiculo;
  
    v_vehi_equi_imei := p_vehi_equi_imei;
    
    

  
    apex_collection.create_or_truncate_collection(p_collection_name => 'ddispositivo');
    apex_collection.create_or_truncate_collection(p_collection_name => 'DISP_MAPA');
  
    vl_url := v_comp_host||'/api/admin/devices?user_api_hash=' ||
              v_hash || '&imei=' || v_vehi_equi_imei;
    /* if gen_user  ='kiarak'   then                                 
    raise_application_error(-20001, 'hola'|| vl_url);
    end if;*/
    l_json_doc :=  apex_web_service.make_rest_request(p_url         => vl_url,
                                                      p_http_method => 'GET');
  
    ------------------------------------------------------------------------------***
    for x in (select  id,
                     active,
                     nombre,
                     imei,
                     sim_number,
                     device_model,
                     j.plate_number           plate_numero,
                     j.chas                   chasis,
                     registration_number,
                     object_owner,
                     additional_notes,
                     protocol,
                     expiration_date,
                     sysdate fecha,
                     dtvo_timezone_id,
                     dtvo_icon_id,
                     dtvo_fuel_measurement_id,
                     dtvo_tail_length,
                     dtvo_min_moving_speed,
                     dtvo_min_fuel_fillings,
                     dtvo_min_fuel_thefts,
                     dtvo_fuel_quantity,
                     dtvo_fuel_price,
                     dtvo_group_id,
                     dtvo_device_icons_type,
                     dtvo_icon_moving,
                     dtvo_icon_stopped,
                     dtvo_icon_offline,
                     dtvo_icon_engine
                from json_table(l_json_doc,
                                '$'
                                columns(estatus number path '$.status',
                                        nested path '$.data[*]'
                                        columns(id number path '$.id',
                                                active varchar path '$.active',
                                                nombre varchar path '$.name',
                                                imei varchar path '$.imei',
                                                sim_number varchar path
                                                '$.sim_number',
                                                device_model varchar path
                                                '$.device_model',
                                                plate_number varchar path
                                                '$.plate_number',
                                                chas varchar path '$.vin',
                                                registration_number varchar path
                                                '$.registration_number',
                                                object_owner varchar path
                                                '$.object_owner',
                                                additional_notes varchar path
                                                '$.additional_notes',
                                                protocol varchar path
                                                '$.protocol',
                                                expiration_date varchar path
                                                '$.expiration_date',
                                                dtvo_timezone_id varchar path
                                                '$.timezone_id',
                                                dtvo_icon_id varchar path
                                                '$.icon_id',
                                                dtvo_fuel_measurement_id
                                                varchar path
                                                '$.fuel_measurement_id',
                                                dtvo_tail_length varchar path
                                                '$.tail_length',
                                                dtvo_min_moving_speed varchar path
                                                '$.min_moving_speed',
                                                dtvo_min_fuel_fillings varchar path
                                                '$.min_fuel_fillings',
                                                dtvo_min_fuel_thefts varchar path
                                                '$.min_fuel_thefts',
                                                dtvo_fuel_quantity varchar path
                                                '$.fuel_quantity',
                                                dtvo_fuel_price varchar path
                                                '$.fuel_price',
                                                dtvo_group_id varchar path
                                                '$.group_id',
                                                dtvo_device_icons_type varchar path
                                                '$.device_icons_type',
                                                dtvo_icon_moving varchar path
                                                '$.icon_colors.moving',
                                                dtvo_icon_stopped varchar path
                                                '$.icon_colors.stopped',
                                                dtvo_icon_offline varchar path
                                                '$.icon_colors.offline',
                                                dtvo_icon_engine varchar path
                                                '$.icon_colors.yellow'))) j) loop
    
      p_name_ant := x.nombre;
      p_dis_id   := x.id;
 
      apex_collection.add_member(p_collection_name => 'DISP_MAPA',
                                 p_c001 => x.id,
                                 p_c002 => x.active,
                                 p_c003 => x.nombre,
                                 p_c004 => x.imei,
                                 p_c005 => x.sim_number,
                                 p_c006 => x.device_model,
                                 p_c007 => x.plate_numero,
                                 p_c008 => x.chasis,
                                 p_c009 => x.registration_number,
                                 p_c010 => x.object_owner,
                                 p_c011 => x.additional_notes,
                                 p_c012 => x.protocol,
                                 p_c013 => x.expiration_date,
                                 p_c014 => x.fecha,
                                 p_c015 => x.dtvo_timezone_id,
                                 p_c016 => x.dtvo_icon_id,
                                 p_c017 => x.dtvo_fuel_measurement_id,
                                 p_c018 => x.dtvo_tail_length,
                                 p_c019 => x.dtvo_min_moving_speed,
                                 p_c020 => x.dtvo_min_fuel_fillings,
                                 p_c021 => x.dtvo_min_fuel_thefts,
                                 p_c022 => x.dtvo_fuel_quantity,
                                 p_c023 => x.dtvo_fuel_price,
                                 p_c024 => x.dtvo_group_id,
                                 p_c025 => x.dtvo_device_icons_type,
                                 p_c026 => x.dtvo_icon_moving,
                                 p_c027 => x.dtvo_icon_stopped,
                                 p_c028 => x.dtvo_icon_offline,
                                 p_c029 => x.dtvo_icon_engine );
   
    end loop;
  exception
    when no_data_found then
    
      raise_application_error(-20001,
                              'Tiene que liquidar la ot primeramente');
    
  end pp_buscar_dispositivo;

  procedure pp_crear_usuario_mapa2(p_cliente           in varchar2,
                                   p_vehiculo          in varchar2,
                                   p_notas_adicionales in varchar2,
                                   p_id                in varchar2) is
    v_existe        number;
    v_param         varchar2(32000);
    v_hash          varchar2(1000);
    vl_url          varchar2(4000);
    v_url           varchar2(4000);
    v_status        varchar2(20);
    v_mensaje       varchar2(1000);
    l_json_doc      clob;
    v_ultima_pagina number;
    v_sysdate       date := sysdate;
  
    v_comp_user varchar2(50);
    v_comp_pass varchar2(100);
    v_comp_host varchar2(1000);
  
    v_names          varchar2(2000);
    v_timezone_id    varchar2(2000);
    v_sim_number     varchar2(2000);
    v_vin            varchar2(2000);
    v_device_model   varchar2(2000);
    v_plate_number   varchar2(2000);
    v_object_owner   varchar2(2000);
    v_correo         varchar2(2000);
    v_vehi_equi_imei varchar2(2000);
    v_status2        varchar2(2000);
    v_usuario        varchar2(30) := gen_user;
    v_imei           varchar2(1000);
    v_tipo_disp      varchar2(1000);
  begin
  
    if p_id is null then
      raise_application_error(-20001,
                              p_vehiculo || '--' || p_cliente || '--' || p_id);
    end if;
  
    if p_cliente is null then
      raise_application_error(-20001,
                              p_vehiculo || '--' || p_cliente || '--' || p_id);
    end if;
  
    if p_vehiculo is null then
      raise_application_error(-20001,
                              p_vehiculo || '--' || p_cliente || '--' || p_id);
    end if;
  
    select vehi_nume_pate || ' - ' || c.clpr_nomb || ' ' || clpr_apel names,
           case
             when upper(vehi_equi_mode) = 'CRX3' then
              73
             else
              41
           end timezone_id, ---id de zona horaria
           v.vehi_equi_sim_card sim_number, ---n?mero sim
           v.vehi_nume_chas vin,
           v.vehi_equi_mode device_model, ---modelo de dispositivo
           v.vehi_nume_pate plate_number, ---n?mero de placa
           clpr_codi_alte object_owner, ---propietaria de objetos
           nvl(clpr_email, clpr_email_fact) correo,
           vehi_equi_imei
      into v_names,
           v_timezone_id,
           v_sim_number,
           v_vin,
           v_device_model,
           v_plate_number,
           v_object_owner,
           v_correo,
           v_vehi_equi_imei
      from come_vehi v, come_clie_prov c
     where v.vehi_clpr_codi = c.clpr_codi
       and c.clpr_codi = p_cliente
       and v.vehi_codi = p_vehiculo;
  
    
  
    begin
     select e.comp_user, e.comp_pass, e.comp_host
        into v_comp_user, v_comp_pass,v_comp_host
        from segu_comp_sist e
       where e.comp_empr_codi = 1;
    
      apex_json.initialize_clob_output;
      apex_json.open_object;
      apex_json.write('email', v_comp_user);
      apex_json.write('password', v_comp_pass);
      apex_json.close_object;
    
      v_param := apex_json.get_clob_output;
      apex_json.free_output;
    
      pack_mapas.pa_obtiene_hash(v_param, v_hash);
    end;
   
  pack_mapas.pa_add_cliente_mapa(p_cliente => v_correo,
                                 p_hash    => v_hash); 
    
    
    --raise_application_error(-20001,'--'||p_id);
  
/*    vl_url := 'https://gps.alarmas.com.py/api/admin/device/' || p_id ||
              '?user_api_hash=' || v_hash;
  
    l_json_doc :=  apex_web_service.make_rest_request(p_url         => vl_url,
                                                      p_http_method => 'GET');
    for x in (select id,
                     active,
                     nombre,
                     imei,
                     sim_number,
                     device_model,
                     j.plate_number           plate_numero,
                     j.chas                   chasis,
                     registration_number,
                     object_owner,
                     additional_notes,
                     protocol,
                     expiration_date,
                     sysdate,
                     dtvo_timezone_id,
                     dtvo_icon_id,
                     dtvo_fuel_measurement_id,
                     dtvo_tail_length,
                     dtvo_min_moving_speed,
                     dtvo_min_fuel_fillings,
                     dtvo_min_fuel_thefts,
                     dtvo_fuel_quantity,
                     dtvo_fuel_price,
                     dtvo_group_id,
                     dtvo_device_icons_type,
                     dtvo_icon_moving,
                     dtvo_icon_stopped,
                     dtvo_icon_offline,
                     dtvo_icon_engine
              
                from json_table(l_json_doc,
                                '$'
                                columns(estatus number path '$.status',
                                        id number path '$.data.id',
                                        active varchar path '$.data.active',
                                        nombre varchar path '$.data.name',
                                        imei varchar path '$.data.imei',
                                        sim_number varchar path
                                        '$.data.sim_number',
                                        device_model varchar path
                                        '$.data.device_model',
                                        plate_number varchar path
                                        '$.data.plate_number',
                                        chas varchar path '$.data.vin',
                                        registration_number varchar path
                                        '$.data.registration_number',
                                        object_owner varchar path
                                        '$.data.object_owner',
                                        additional_notes varchar path
                                        '$.data.additional_notes',
                                        protocol varchar path
                                        '$.data.protocol',
                                        expiration_date varchar path
                                        '$.data.expiration_date',
                                        dtvo_timezone_id varchar path
                                        '$.data.timezone_id',
                                        dtvo_icon_id varchar path
                                        '$.data.icon_id',
                                        dtvo_fuel_measurement_id varchar path
                                        '$.data.fuel_measurement_id',
                                        dtvo_tail_length varchar path
                                        '$.data.tail_length',
                                        dtvo_min_moving_speed varchar path
                                        '$.data.min_moving_speed',
                                        dtvo_min_fuel_fillings varchar path
                                        '$.data.min_fuel_fillings',
                                        dtvo_min_fuel_thefts varchar path
                                        '$.data.min_fuel_thefts',
                                        dtvo_fuel_quantity varchar path
                                        '$.data.fuel_quantity',
                                        dtvo_fuel_price varchar path
                                        '$.data.fuel_price',
                                        dtvo_group_id varchar path
                                        '$.data.group_id',
                                        dtvo_device_icons_type varchar path
                                        '$.data.device_icons_type',
                                        dtvo_icon_moving varchar path
                                        '$.data.icon_colors.moving',
                                        dtvo_icon_stopped varchar path
                                        '$.data.icon_colors.stopped',
                                        dtvo_icon_offline varchar path
                                        '$.data.icon_colors.offline',
                                        dtvo_icon_engine varchar path
                                        '$.data.icon_colors.yellow'
                                        
                                        )) j) loop*/
  

      for x in(select  c001 id,
                       c002 active,
                       c003 nombre,
                       c004 imei,
                       c005 sim_number,
                       c006 device_model,
                       c007 plate_numero,
                       c008 chasis,
                       c009 registration_number,
                       c010 object_owner,
                       c011 additional_notes,
                       c012 protocol,
                       c013 expiration_date,
                       c014 fecha,
                       c015 dtvo_timezone_id,
                       c016 dtvo_icon_id,
                       c017 dtvo_fuel_measurement_id,
                       c018 dtvo_tail_length,
                       c019 dtvo_min_moving_speed,
                       c020 dtvo_min_fuel_fillings,
                       c021 dtvo_min_fuel_thefts,
                       c022 dtvo_fuel_quantity,
                       c023 dtvo_fuel_price,
                       c024 dtvo_group_id,
                       c025 dtvo_device_icons_type,
                       c026 dtvo_icon_moving,
                       c027 dtvo_icon_stopped,
                       c028 dtvo_icon_offline,
                       c029 dtvo_icon_engine 
                    from apex_collections a
                    where collection_name = 'DISP_MAPA'
                     ) loop

      v_imei      := x.imei;
    
      if x.imei is null then
        raise_application_error(-20001,
                                'El imei se encuentra vacio, por favor, verificar');
      end if;
    
      if x.sim_number is null then
        raise_application_error(-20001,
                                'El N?mero SIM se encuentra vacio, por favor, verificar');
      end if;
    
      if v_vin is null then
        raise_application_error(-20001,
                                'El vin se encuentra vacio, por favor, verificar');
      end if;
    
      if v_device_model is null then
        raise_application_error(-20001,
                                'El modelo se encuentra vacio, por favor, verificar');
      end if;
    
      v_url   := v_comp_host||'/api/edit_device?user_api_hash=' ||
                 v_hash || '&device_id=' || p_id;
      v_param := 'name=' || apex_util.url_encode(v_names) || chr(38) ||
                 'imei=' || apex_util.url_encode(x.imei) || chr(38) ||
                 'icon_id=' || apex_util.url_encode(x.dtvo_icon_id) ||
                 chr(38) || 'fuel_measurement_id=' ||
                 apex_util.url_encode(x.dtvo_fuel_measurement_id) ||
                 chr(38) || 'tail_length=' ||
                 apex_util.url_encode(x.dtvo_tail_length) || chr(38) ||
                 'min_moving_speed=' ||
                 apex_util.url_encode(x.dtvo_min_moving_speed) || chr(38) ||
                 'min_fuel_fillings=' ||
                 apex_util.url_encode(x.dtvo_min_fuel_fillings) || chr(38) ||
                 'min_fuel_thefts=' ||
                 apex_util.url_encode(x.dtvo_min_fuel_thefts) || chr(38) ||
                 'fuel_quantity=' ||
                 apex_util.url_encode(x.dtvo_fuel_quantity) || chr(38) ||
                 'fuel_price=' || apex_util.url_encode(x.dtvo_fuel_price) ||
                 chr(38) || 'group_id=' ||
                 apex_util.url_encode(x.dtvo_group_id) || chr(38) ||
                 'device_icons_type=' ||
                 apex_util.url_encode(nvl(x.dtvo_device_icons_type, 'arrow')) ||
                 chr(38) || 'timezone_id=' ||
                 apex_util.url_encode(x.dtvo_timezone_id) || chr(38) ||
                 'icon_moving=' || apex_util.url_encode(x.dtvo_icon_moving) ||
                 chr(38) || 'icon_stopped=' ||
                 apex_util.url_encode(x.dtvo_icon_stopped) || chr(38) ||
                 'icon_offline=' ||
                 apex_util.url_encode(x.dtvo_icon_offline) || chr(38) ||
                 'icon_engine=' || apex_util.url_encode(x.dtvo_icon_engine) ||
                 chr(38) || 'sim_number=' ||
                 apex_util.url_encode(x.sim_number) || chr(38) || 'vin=' ||
                 apex_util.url_encode(v_vin) || chr(38) || 'device_model=' ||
                 apex_util.url_encode(v_device_model) || chr(38) ||
                 'plate_number=' || apex_util.url_encode(v_plate_number) ||
                 chr(38) || 'registration_number=' ||
                 apex_util.url_encode(x.registration_number) || chr(38) ||
                 'object_owner=' || 
                 apex_util.url_encode(v_object_owner) ||chr(38) || 
                 'additional_notes=' ||
                 apex_util.url_encode(p_notas_adicionales)|| chr(38) ||
                 'tail_color=' ||
                 apex_util.url_encode('#33cc33')|| chr(38) ||
                  'tail_length=' ||
                 apex_util.url_encode(5)|| chr(38) ||
                 'detect_engine=' ||
                 apex_util.url_encode('gps')|| chr(38) ||
                 'engine_hours=' ||
                 apex_util.url_encode('gps')|| chr(38) ||
                 'detect_speed=' ||
                 apex_util.url_encode('gps')|| chr(38) ||
                 'min_moving_speed=' ||
                 apex_util.url_encode(6)|| chr(38) ||
                 'min_fuel_fillings=' ||
                 apex_util.url_encode(10)|| chr(38) ||
                 'min_fuel_thefts=' ||
                 apex_util.url_encode(10)|| chr(38) ||
                 'snap_to_road=' ||
                 apex_util.url_encode(0)|| chr(38) ||
                 'gprs_templates_only=' ||
                 apex_util.url_encode(0)|| chr(38) ||
                 'valid_by_avg_speed=' ||
                 apex_util.url_encode(1)
                 ;
                 
      pack_mapas.pa_upd_clpr_mapa(v_url, v_param, v_status, v_mensaje);
    
      if v_status = '1' then
        insert into mapa_proc_aud
          (mpa_evento,
           mpa_fec_grab,
           mpa_usu_grab,
           mpa_email,
           mpa_dispositivo,
           mpa_accion)
        values
          (substr(v_url || '-' || v_param, 1, 2000),
           sysdate,
           v_usuario,
           p_cliente,
           p_id,
           'dispositivo_editar');
       -- commit;
        null;
      else
        if lower(v_mensaje) like lower('%timezone%') then
          v_url   := v_comp_host||'/api/edit_device?user_api_hash=' ||
                     v_hash || '&device_id=' || p_id;
          v_param := 'name=' || apex_util.url_encode(v_names) || chr(38) ||
                     'imei=' || apex_util.url_encode(x.imei) || chr(38) ||
                     'icon_id=' || apex_util.url_encode(x.dtvo_icon_id) ||
                     chr(38) || 'fuel_measurement_id=' ||
                     apex_util.url_encode(x.dtvo_fuel_measurement_id) ||
                     chr(38) || 'tail_length=' ||
                     apex_util.url_encode(x.dtvo_tail_length) || chr(38) ||
                     'min_moving_speed=' ||
                     apex_util.url_encode(x.dtvo_min_moving_speed) ||
                     chr(38) || 'min_fuel_fillings=' ||
                     apex_util.url_encode(x.dtvo_min_fuel_fillings) ||
                     chr(38) || 'min_fuel_thefts=' ||
                     apex_util.url_encode(x.dtvo_min_fuel_thefts) ||
                     chr(38) || 'fuel_quantity=' ||
                     apex_util.url_encode(x.dtvo_fuel_quantity) || chr(38) ||
                     'fuel_price=' ||
                     apex_util.url_encode(x.dtvo_fuel_price) || chr(38) ||
                     'group_id=' || apex_util.url_encode(x.dtvo_group_id) ||
                     chr(38) || 'device_icons_type=' ||
                     apex_util.url_encode(nvl(x.dtvo_device_icons_type,
                                              'arrow')) || chr(38) ||
                     'timezone_id=' ||
                     apex_util.url_encode(x.dtvo_timezone_id) || chr(38) ||
                     'icon_moving=' ||
                     apex_util.url_encode(x.dtvo_icon_moving) || chr(38) ||
                     'icon_stopped=' ||
                     apex_util.url_encode(x.dtvo_icon_stopped) || chr(38) ||
                     'icon_offline=' ||
                     apex_util.url_encode(x.dtvo_icon_offline) || chr(38) ||
                     'icon_engine=' ||
                     apex_util.url_encode(x.dtvo_icon_engine) || chr(38) ||
                     'sim_number=' || apex_util.url_encode(x.sim_number) ||
                     chr(38) || 'vin=' || apex_util.url_encode(v_vin) ||
                     chr(38) || 'device_model=' ||
                     apex_util.url_encode(v_device_model) || chr(38) ||
                     'plate_number=' ||
                     apex_util.url_encode(v_plate_number) || chr(38) ||
                     'registration_number=' ||
                     apex_util.url_encode(x.registration_number) || chr(38) ||
                     'object_owner=' ||
                     apex_util.url_encode(v_object_owner) || chr(38) ||
                     'additional_notes=' ||
                     apex_util.url_encode(p_notas_adicionales)|| chr(38) ||
                     'tail_color=' ||
                     apex_util.url_encode('#33cc33')|| chr(38) ||
                      'tail_length=' ||
                     apex_util.url_encode(5)|| chr(38) ||
                     'detect_engine=' ||
                     apex_util.url_encode('gps')|| chr(38) ||
                     'engine_hours=' ||
                     apex_util.url_encode('gps')|| chr(38) ||
                     'detect_speed=' ||
                     apex_util.url_encode('gps')|| chr(38) ||
                     'min_moving_speed=' ||
                     apex_util.url_encode(6)|| chr(38) ||
                     'min_fuel_fillings=' ||
                     apex_util.url_encode(10)|| chr(38) ||
                     'min_fuel_thefts=' ||
                     apex_util.url_encode(10)|| chr(38) ||
                     'snap_to_road=' ||
                     apex_util.url_encode(0)|| chr(38) ||
                     'gprs_templates_only=' ||
                     apex_util.url_encode(0)|| chr(38) ||
                     'valid_by_avg_speed=' ||
                     apex_util.url_encode(1)
                     ;
        
          pack_mapas.pa_upd_clpr_mapa(v_url, v_param, v_status2, v_mensaje);
          if v_status2 = 1 then
            null;
            insert into mapa_proc_aud
              (mpa_evento,
               mpa_fec_grab,
               mpa_usu_grab,
               mpa_email,
               mpa_dispositivo,
               mpa_accion)
            values
              (substr(v_url || '-' || v_param, 1, 2000),
               sysdate,
               v_usuario,
               p_cliente,
               p_id,
               'dispositivo_editar');
        
          else
          
            raise_application_error(-20001,
                                    'Error al agregar dispositivo  mensaje:1' ||
                                    v_mensaje); 
          
          end if;
        end if;
       
      end if;
    end loop;
 
    pack_mapas_gpswox.pa_add_cliente_device(p_cliente  => p_cliente,
                                     p_vehiculo => p_vehiculo,
                                     p_id_disp   => p_id,
                                     p_imei      => v_imei,
                                     p_tipo_disp => v_device_model,
                                     p_hash      => v_hash,
                                     p_correo    => v_correo);
  
  end pp_crear_usuario_mapa2;

  procedure pp_buscar_dispositivo2(p_vehi_equi_imei in varchar2,
                                   p_sim_number     out varchar2,
                                   p_device_model   out varchar2,
                                   p_emei2          out varchar2) is
  
    v_param     varchar2(32000);
    v_url       varchar2(4000);
    v_status    varchar2(20);
    v_mensaje   varchar2(1000);
    v_hash      varchar2(1000);
    x_contador  number := 0;
    v_comp_user varchar2(50);
    v_comp_pass varchar2(100);
    v_comp_host varchar2(100);
  
    v_sysdate       date := sysdate;
    v_array         varchar2(2000);
    v_json          clob;
    l_json_doc      clob;
    v_ultima_pagina number;
    v_email_cliente varchar2(60);
    vl_url          varchar2(200);
    v_hash_cli      varchar2(1000);
    v_ult_letra     varchar2(2000);
    cantidad        number;
  
    v_names          varchar2(2000);
    v_timezone_id    varchar2(2000);
    v_sim_number     varchar2(2000);
    v_vin            varchar2(2000);
    v_device_model   varchar2(2000);
    v_plate_number   varchar2(2000);
    v_object_owner   varchar2(2000);
    v_correo         varchar2(2000);
    v_vehi_equi_imei varchar2(2000);
  begin
  
    select t.comp_user, t.comp_pass, t.comp_host
      into v_comp_user, v_comp_pass, v_comp_host
      from segu_comp_sist t
     where comp_empr_codi = 1;
  
    apex_json.initialize_clob_output;
    apex_json.open_object;
  
    apex_json.write('email', v_comp_user);
    apex_json.write('password', v_comp_pass);
  
    apex_json.close_object;
  
    v_param := apex_json.get_clob_output;
    apex_json.free_output;
    pack_mapas_gpswox.pa_obtiene_hash(v_param, v_hash);
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'DDISPOSITIVO');
    vl_url := v_comp_host || '/api/admin/devices?user_api_hash=' || v_hash ||
              '&imei=' || p_vehi_equi_imei;
  
    /*    vl_url := v_comp_host||'/api/admin/devices?user_api_hash=' ||
                  v_hash || '=' || p_vehi_equi_imei;
    */
    l_json_doc := apex_web_service.make_rest_request(p_url         => vl_url,
                                                      p_http_method => 'GET');
  
    ------------------------------------------------------------------------------***
    --   raise_application_error(-20010, vl_url);
    select
    
     sim_number, -- imei,
     device_model,
     imei
      into p_sim_number, p_device_model, p_emei2
      from json_table(l_json_doc,
                      '$'
                      columns(estatus number path '$.status',
                              nested path '$.data[*]'
                              columns(id number path '$.id',
                                      active varchar path '$.active',
                                      nombre varchar path '$.name',
                                      imei varchar path '$.imei',
                                      sim_number varchar path '$.sim_number',
                                      device_model varchar path
                                      '$.device_model',
                                      plate_number varchar path
                                      '$.plate_number',
                                      chas varchar path '$.vin',
                                      registration_number varchar path
                                      '$.registration_number',
                                      object_owner varchar path
                                      '$.object_owner',
                                      additional_notes varchar path
                                      '$.additional_notes',
                                      protocol varchar path '$.protocol',
                                      expiration_date varchar path
                                      '$.expiration_date',
                                      dtvo_timezone_id varchar path
                                      '$.timezone_id',
                                      dtvo_icon_id varchar path '$.icon_id',
                                      dtvo_fuel_measurement_id varchar path
                                      '$.fuel_measurement_id',
                                      dtvo_tail_length varchar path
                                      '$.tail_length',
                                      dtvo_min_moving_speed varchar path
                                      '$.min_moving_speed',
                                      dtvo_min_fuel_fillings varchar path
                                      '$.min_fuel_fillings',
                                      dtvo_min_fuel_thefts varchar path
                                      '$.min_fuel_thefts',
                                      dtvo_fuel_quantity varchar path
                                      '$.fuel_quantity',
                                      dtvo_fuel_price varchar path
                                      '$.fuel_price',
                                      dtvo_group_id varchar path '$.group_id',
                                      dtvo_device_icons_type varchar path
                                      '$.device_icons_type',
                                      dtvo_icon_moving varchar path
                                      '$.icon_colors.moving',
                                      dtvo_icon_stopped varchar path
                                      '$.icon_colors.stopped',
                                      dtvo_icon_offline varchar path
                                      '$.icon_colors.offline',
                                      dtvo_icon_engine varchar path
                                      '$.icon_colors.yellow'))) j;
    --raise_application_error(-20010, vl_url);
  end pp_buscar_dispositivo2;

  procedure pp_liquida_ot2 is
  
    --cursor para cambiar estado de plan, cuando se realiza desinstalacion
    cursor c_plan(p_ortr_deta_codi in number) is
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_deta_codi = p_ortr_deta_codi;
  
    cursor c_plan_mini(p_ortr_deta_codi in number) is
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_nume_item > nvl(v('P53_P_INDI_DURA_MINI_CONT'), 8) + 2 --(2 meses de pre aviso)
         and ap.anpl_deta_codi = p_ortr_deta_codi;
  
    cursor c_plan_mini_sin_pre(p_ortr_deta_codi in number) is -- sin pre aviso
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_nume_item > nvl(v('P53_P_INDI_DURA_MINI_CONT'), 8)
         and ap.anpl_deta_codi = p_ortr_deta_codi;
  
    --cursor para cambiar estado de plan, cuando se realizan cambios de tit., seguro a rpy, seguro a seguro, rpy a seguro, reinstalacion
    cursor c_plan_cambio(p_ortr_deta_codi in number) is
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_deta_codi =
             (select d.deta_codi_anex_padr
                from come_soli_serv_anex_deta d
               where d.deta_codi = p_ortr_deta_codi);
  
    cursor c_plan_reno(p_ortr_deta_codi in number, p_nume_item in number) is
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_nume_item > p_nume_item + 2 --plan maximo + 2 meses por no llegar a la permanencia minima
         and ap.anpl_deta_codi = p_ortr_deta_codi;
  
    cursor c_plan_reno_fact(p_ortr_deta_codi in number,
                            p_nume_item      in number) is
      select ap.anpl_codi
        from come_soli_serv_anex_plan ap
       where (ap.anpl_movi_codi is null and
             nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
         and ap.anpl_nume_item <= p_nume_item + 2 --cambiaran fecha de facturacion los meses pendientes menores al plan maximo + 2 meses por no llegar a la permanencia minima
         and ap.anpl_deta_codi = p_ortr_deta_codi;
  
    cursor c_anex is ----- cursor de anexo para generar el plan
      select a.anex_codi,
             a.anex_fech_venc,
             a.anex_dura_cont,
             a.anex_cant_cuot_modu,
             a.anex_impo_mone_unic,
             a.anex_prec_unit,
             s.sose_tipo_fact,
             c.clpr_dia_tope_fact,
             'N' cuot_inic,
             nvl(cl.clas1_dias_venc_fact, 5) clas1_dias_venc_fact,
             a.anex_empr_codi,
             s.sose_sucu_nume_item,
             0 mone_cant_deci,
             a.anex_indi_fact_impo_unic,
             a.anex_cifa_codi,
             a.anex_cifa_tipo,
             a.anex_cifa_dia_fact,
             a.anex_cifa_dia_desd,
             a.anex_cifa_dia_hast,
             a.anex_aglu_cicl
        from come_soli_serv_anex      a,
             come_soli_serv_anex_deta d,
             come_soli_serv           s,
             come_clie_prov           c,
             come_clie_clas_1         cl
       where a.anex_sose_codi = s.sose_codi
         and c.clpr_indi_clie_prov = 'C'
         and s.sose_clpr_codi = c.clpr_codi
         and c.clpr_clie_clas1_codi = cl.clas1_codi
         and a.anex_codi = d.deta_anex_codi
         and d.deta_codi = v('P53_ORTR_DETA_CODI')
       group by a.anex_codi,
                a.anex_fech_venc,
                a.anex_dura_cont,
                a.anex_cant_cuot_modu,
                a.anex_impo_mone_unic,
                a.anex_prec_unit,
                s.sose_tipo_fact,
                c.clpr_dia_tope_fact,
                nvl(cl.clas1_dias_venc_fact, 5),
                a.anex_empr_codi,
                s.sose_sucu_nume_item,
                a.anex_indi_fact_impo_unic,
                a.anex_cifa_codi,
                a.anex_cifa_tipo,
                a.anex_cifa_dia_fact,
                a.anex_cifa_dia_desd,
                a.anex_cifa_dia_hast,
                a.anex_aglu_cicl;
    ----------------------------------------------------------------------
  
    cursor c_fact is ------------cursor paga generar la factura
      select s.sose_clpr_codi,
             a.anex_cifa_codi,
             s.sose_codi,
             s.sose_nume,
             a.anex_codi,
             s.sose_tipo_fact,
             'A' agru_anex,
             (t.ortr_fech_inst) fech_fact_desd,
             (t.ortr_fech_inst) fech_fact_hast,
             (t.ortr_fech_inst) movi_fech_emis,
             1 sucu_codi,
             1 depo_codi,
             c.clpr_clie_clas1_codi clas1_codi,
             0 anpl_impo_reca_red_cobr,
             'N' indi_excl_clie_clas1_aseg,
             null v_faau_codi,
             null v_codresp,
             null v_descresp,
             deta_indi_prom_pror
        from come_soli_serv           s,
             come_soli_serv_anex      a,
             come_soli_serv_anex_deta d,
             come_orde_trab           t,
             come_clie_prov           c
       where s.sose_codi = a.anex_sose_codi
         and a.anex_codi = d.deta_anex_codi
         and d.deta_codi = t.ortr_deta_codi
         and s.sose_clpr_codi = c.clpr_codi
         and t.ortr_codi = v('P53_ORTR_CODI');
  
    -- cursor para dar de baja los servicios de grua relacionados
    cursor c_grua(p_c_deta_codi in number) is
      select dh.deta_codi, v.vehi_codi
        from come_soli_serv_anex_deta dh,
             come_soli_serv_anex_deta dp,
             come_vehi                v
       where dh.deta_codi_anex_padr = dp.deta_codi
         and dp.deta_vehi_codi = v.vehi_codi(+)
         and dh.deta_conc_codi = v('P53_P_CONC_CODI_ANEX_GRUA_VEHI')
         and dp.deta_codi = p_c_deta_codi
       order by dh.deta_codi, v.vehi_codi;
  
    ----------------------------------------------------------------------
  
    v_sose_tipo varchar2(2);
    v_nume_item number;
  
    --variables para generacion de plan y factura automatica
  
    v_codresp   number;
    v_descresp  varchar2(100);
    v_faau_codi number;
    v_user_codi number;
  
    v_plan         number;
    v_cant_padr    number;
    v_ortr_nume    varchar2(20);
    v_movi_codi    number;
    v_nume_item_ri number;
  
    tiempo_inicial timestamp;
    tiempo_actual  timestamp;
    espera         number;
    tiempo_espera  number := 3; -- variable para controlar el tiempo de espera en segundos
    intervalo      interval day to second; -- variable para almacenar el intervalo de tiempo
  begin
  
    ---si es desinstalacion
    if v('P53_ORTR_SERV_TIPO') = 'D' then
    
      if nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') = 'R' then
        --reinstalacion, reinstalacion al instante
        --genera anexo de reinstalacion en contrato donde estaba instalado el vehiculo
        pp_generar_anex_desi;
      
        /*
        elsif nvl(v('p53_ortr_serv_tipo_moti'), 'n') = 'rn' then --reinstalacion al instante
          begin
            select count(*)
              into v_cant_padr
              from come_soli_serv_anex      a,
                   come_soli_serv_anex_deta d,
                   come_soli_serv_anex_deta dd
             where a.anex_codi = d.deta_anex_codi
               and a.anex_tipo in ('rn', 'ri')
               and d.deta_anex_codi_padr = dd.deta_anex_codi
               and dd.deta_codi = v('p53_ortr_deta_codi');
          exception
            when others then
              v_cant_padr := 0;
          end;*/
      
        --si no se ha generado el anexo para reinstalaci?n
        /* if v_cant_padr = 0 then
          pp_generar_anex_desi;
        end if;*/
      
      elsif nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') = 'RF' then
        --reinstalacion a futuro
        --ya cambia todos los indicadores del plan para no facturar
        for x in c_plan(v('P53_ORTR_DETA_CODI')) loop
          update come_soli_serv_anex_plan ap
             set ap.anpl_deta_esta_plan = 'N',
                 ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
           where ap.anpl_codi = x.anpl_codi;
        end loop;
      
        --indicador si se genero pre-anexo por reinstalacion a futuro
      
        setitem('P53_ORTR_INDI_REIN_FUTU_GENE', 'N');
      
      elsif nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') = 'RN' then
        --reinstalacion al instante
        begin
          select nvl(sose_tipo, 'I')
            into v_sose_tipo
            from come_soli_serv s
           where s.sose_codi =
                 (select anex_sose_codi
                    from come_soli_serv_anex a
                   where a.anex_codi =
                         (select deta_anex_codi
                            from come_soli_serv_anex_deta d
                           where d.deta_codi = v('P53_ORTR_DETA_CODI')));
        
          ----reinstalacion al instante
          begin
            select count(*)
              into v_cant_padr
              from come_soli_serv_anex      a,
                   come_soli_serv_anex_deta d,
                   come_soli_serv_anex_deta dd
             where a.anex_codi = d.deta_anex_codi
               and a.anex_tipo in ('RN', 'RI')
               and d.deta_anex_codi_padr = dd.deta_anex_codi
               and dd.deta_codi = v('P53_ORTR_DETA_CODI');
          exception
            when others then
              v_cant_padr := 0;
          end;
        
          --si no se ha generado el anexo para reinstalaci?n
          if v_cant_padr = 0 then
            pp_generar_anex_desi;
          end if;
        
        exception
          when others then
            raise_application_error(-20001,
                                    'Favor verifique la Solicitud, del detalle de Anexo del vehiculo a Desinstalar.');
        end;
      
        --si la desinstalacion no es a un vehiculo renovado.
        if nvl(v_sose_tipo, 'I') <> 'N' then
        
          --verifica parametro si se aplicara permanencia minima o no
          if nvl(v('P53_P_INDI_DESI_CON_DURA_MINI'), 'N') = 'S' then
          
            if nvl(v('P53_P_INDI_DIAS_PRE_AVISO'), 'S') = 'S' then
              --cambia indicador en tabla de plan de facturacion, para que el panel ya no tenga en cuenta
              --las cuotas de meses superiores al minimo requerido
              for x in c_plan_mini(v('P53_ORTR_DETA_CODI')) loop
                update come_soli_serv_anex_plan ap
                   set ap.anpl_deta_esta_plan = 'N',
                       ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
                 where ap.anpl_codi = x.anpl_codi;
              end loop;
            else
              --cambia indicador en tabla de plan de facturacion, para que el panel ya no tenga en cuenta
              --las cuotas de meses superiores al minimo requerido
              for x in c_plan_mini_sin_pre(v('P53_ORTR_DETA_CODI')) loop
                update come_soli_serv_anex_plan ap
                   set ap.anpl_deta_esta_plan = 'N',
                       ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
                 where ap.anpl_codi = x.anpl_codi;
              end loop;
            end if;
          
          else
            for x in c_plan(v('P53_ORTR_DETA_CODI')) loop
              update come_soli_serv_anex_plan ap
                 set ap.anpl_deta_esta_plan = 'N',
                     ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
               where ap.anpl_codi = x.anpl_codi;
            end loop;
          end if;
        
        else
          begin
            select max(ap.anpl_nume_item)
              into v_nume_item
              from come_soli_serv_anex_plan ap
             where (ap.anpl_movi_codi is not null and
                   nvl(ap.anpl_indi_fact_cuot, 'N') = 'N')
               and ap.anpl_deta_codi = v('P53_ORTR_DETA_CODI');
            -----------------27/09/2022 no estaba teniendo en cuenta la instalacion anterior
            -----------que se da haber una reinstalacion..
          
            select max(t.anpl_nume_item)
              into v_nume_item_ri
              from come_soli_serv_anex_plan t
             where anpl_indi_fact = 'S'
               and anpl_deta_esta_plan = 'S'
               and (anpl_anex_codi || '-' || t.anpl_deta_codi) in
                   (select deta_anex_codi_padr || '-' || deta_codi_anex_padr --, a.anex_codi
                      from come_soli_desi,
                           come_soli_serv,
                           come_soli_serv_anex      a,
                           come_soli_serv_anex_deta d,
                           come_vehi
                     where sode_vehi_codi = vehi_codi
                       and vehi_codi = deta_vehi_codi
                       and deta_anex_codi = anex_codi
                          
                       and anex_sose_codi = sose_codi
                       and sode_nume = v('P53_SODE_NUME'));
          
          exception
            when others then
              v_nume_item := 1;
          end;
        
          v_nume_item := v_nume_item + nvl(v_nume_item_ri, 0);
        
          --si alcanzo o supero la permanencia minima , o si parametro de las renovaciones tendran permanencia minima es 'n'
          --ya cambia todos los indicadores del plan para no facturar
          --sino se debe facturar 2 meses m?s, y la fecha de facturaci?n pasa a ser la de la liquidacion de la ot..si hay mas planes cambian para no facturar
          if v_nume_item >= nvl(v('P53_P_INDI_DURA_MINI_CONT'), 8) or
             nvl(v('P53_P_INDI_DESI_RENO_DURA_MINI'), 'S') = 'N' then
          
            for x in c_plan(v('P53_ORTR_DETA_CODI')) loop
              update come_soli_serv_anex_plan ap
                 set ap.anpl_deta_esta_plan = 'N',
                     ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
               where ap.anpl_codi = x.anpl_codi;
            end loop;
          else
          
            for x in c_plan_reno(v('P53_ORTR_DETA_CODI'), v_nume_item) loop
              update come_soli_serv_anex_plan ap
                 set ap.anpl_deta_esta_plan = 'N',
                     ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
               where ap.anpl_codi = x.anpl_codi;
            end loop;
          
            for x in c_plan_reno_fact(v('P53_ORTR_DETA_CODI'), v_nume_item) loop
              update come_soli_serv_anex_plan ap
                 set ap.anpl_fech_fact = trunc(to_date(v('P53_ORTR_FECH_INST'))),
                     ap.anpl_fech_venc = trunc(to_date(v('P53_ORTR_FECH_INST')) + 6),
                     ap.anpl_ortr_codi = v('P53_ORTR_CODI')
               where ap.anpl_codi = x.anpl_codi;
            end loop;
          
          end if;
        end if;
      end if;
    
      -- dar de baja los servicios de grua
      for k in c_grua(v('P53_ORTR_DETA_CODI')) loop
        if nvl(v('P53_ORTR_SERV_TIPO_MOTI'), 'N') not in ('R' /*, 'rn'*/) then
          --reinstalacion, reinstalacion al instante
          update come_soli_serv_anex_deta d
             set d.deta_esta_plan = 'N'
           where deta_codi = k.deta_codi;
        
          update come_soli_serv_anex_plan p
             set p.anpl_deta_esta_plan = 'N'
           where p.anpl_deta_codi = k.deta_codi
             and p.anpl_indi_fact = 'N';
        
          if k.vehi_codi is not null then
            update come_vehi v
               set v.vehi_indi_grua = 'N'
             where v.vehi_codi = k.vehi_codi
               and v.vehi_indi_grua = 'S';
          end if;
        end if; ----***cambio de lugar
      
      end loop;
    
      update come_vehi
         set vehi_esta = 'D'
       where vehi_codi = v('P53_ORTR_VEHI_CODI');
    
      update come_soli_serv_anex_deta
         set deta_esta = 'D'
       where deta_codi = v('P53_ORTR_DETA_CODI');
    
    else
      --si no es desinstalacion
    
      if v('P53_ORTR_SERV_TIPO') in ('I') then
        update come_vehi
           set vehi_esta = 'I'
         where vehi_codi = v('P53_ORTR_VEHI_CODI');
      
        update come_soli_serv_anex_deta
           set deta_esta = 'I'
         where deta_codi = v('P53_ORTR_DETA_CODI');
      
        if nvl(v('P53_P_INDI_GENE_PLAN_LIQU_OT'), 'N') = 'S' then
          --- si el parametro esta en s para alarmas
          begin
            --- verifica si ya tiene plan para generar al liquidar la ot
          
            select count(*) cant
              into v_plan
              from come_orde_trab           t,
                   come_soli_serv_anex      a,
                   come_soli_serv_anex_deta d,
                   come_soli_serv_anex_plan p
             where a.anex_codi = p.anpl_anex_codi
               and a.anex_codi = d.deta_anex_codi
               and t.ortr_deta_codi = d.deta_codi
               and t.ortr_codi = v('P53_ORTR_CODI');
          
          exception
            when others then
              v_plan := 0;
          end;
        
          if v_plan = 0 then
          
            -- procedimiento para generar el plan
            for x in c_anex loop
              begin
                pack_fact_ciclo.pa_generar_detalle_plan(x.anex_codi,
                                                        to_date(v('P53_ORTR_FECH_INST')) - 1, --se envia con fecha - 1 porque el proceso que usa hace fecha + 1
                                                        x.anex_dura_cont,
                                                        x.anex_cant_cuot_modu,
                                                        x.anex_impo_mone_unic,
                                                        x.anex_prec_unit,
                                                        x.sose_tipo_fact,
                                                        x.clpr_dia_tope_fact,
                                                        x.cuot_inic,
                                                        x.clas1_dias_venc_fact,
                                                        x.anex_empr_codi,
                                                        x.sose_sucu_nume_item,
                                                        x.mone_cant_deci,
                                                        x.anex_indi_fact_impo_unic,
                                                        x.anex_cifa_codi,
                                                        x.anex_cifa_tipo,
                                                        x.anex_cifa_dia_fact,
                                                        x.anex_cifa_dia_desd,
                                                        x.anex_cifa_dia_hast,
                                                        x.anex_aglu_cicl);
              
                -- exception
                -- when form_trigger_failure then
                --    raise form_trigger_failure;
                -- when others then
                -- pl_me(sqlerrm);
              end;
            end loop;
          end if;
        
          ------------------------ genera la factura automatica
          begin
            --busca usuario
            select user_codi
              into v_user_codi
              from segu_user
             where user_login = fp_user;
          end;
        
          for x in c_fact loop
            begin
            
              --  raise_application_error (-20001,x.sucu_codi||'--'||x.sucu_codi||'--'||x.clas1_codi||'-'||x.sose_tipo_fact||'-'||x.fech_fact_desd );
            
              pack_fact_ciclo.pa_gene_plan_fact_movi(x.sose_clpr_codi,
                                                     x.anex_cifa_codi,
                                                     x.sose_codi,
                                                     x.sose_nume,
                                                     x.anex_codi,
                                                     x.sose_tipo_fact,
                                                     x.agru_anex,
                                                     x.fech_fact_desd,
                                                     x.fech_fact_hast,
                                                     x.movi_fech_emis,
                                                     v('P53_P_PECO_CODI'),
                                                     v_user_codi,
                                                     x.sucu_codi,
                                                     x.depo_codi,
                                                     x.clas1_codi,
                                                     x.anpl_impo_reca_red_cobr,
                                                     x.indi_excl_clie_clas1_aseg,
                                                     v_faau_codi,
                                                     v_codresp,
                                                     v_descresp,
                                                     v_movi_codi);
            
              -- si v_codresp es distinto a 1 significa que ocurri? una excepcion
              if nvl(v_codresp, 1) = 1 then
              
                begin
                  env_fact_sifen.pp_get_json_fact(v_movi_codi);
                
                  begin
                    i020273_a.pp_enviar_sms_fact(p_movi_codi => v_movi_codi);
                  end;
                
                exception
                  when others then
                    null;
                end;
              
                /*              begin
                  -- call the procedure
                  if nvl(x.deta_indi_prom_pror,'n')='s' then
                    pa_ gene_nota_cred_pror(p_clave_fact => v_movi_codi,
                                             p_clave_ot   => v('p53_ortr_codi'));
                  end if;
                end;*/
              else
                raise_application_error(-20001, v_descresp);
              
                --   pl_me(v_descresp);
              
                ---     raise_application_error (-20001,  v('p53_p_peco_codi'));
              
              end if;
            
              --  exception
              --when form_trigger_failure then
              --     raise form_trigger_failure;
              --when others then
              --pl_me(sqlerrm);
            end;
          end loop;
        
          ----------------genera la nota de creito
          --   pa_ gene_nota_cred_refe(v('p53_ortr_codi'), v_faau_codi);
        
          begin
          
            pack_gene_nota_cred_refe.pp_gene_nota_cred_refe(p_ortr_codi => v('P53_ORTR_CODI'),
                                                            p_faau_codi => v_faau_codi);
          end;
        
        end if;
      
        --t= camb titularidad, r= camb seguro a rpy, s= camb seguro a seguro, ras= camb rpy a seguro
      elsif v('P53_ORTR_SERV_TIPO') in ('T', 'R', 'S', 'RAS') then
      
        if ((v('P53_ORTR_ESTA') = 'L' and v('P53_ORTR_ESTA_ORIG') = 'P') and
           v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'N') or
           (v('P53_ORTR_ESTA_PRE_LIQU') = 'S' and
           v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'N') then
        
          --    v('p53_ortr_esta_pre_liqu') := 's';
          setitem('P53_ORTR_ESTA_PRE_LIQU', 'S');
          update come_soli_serv_anex_deta
             set deta_esta = 'I'
           where deta_codi = v('P53_ORTR_DETA_CODI');
        
          update come_soli_serv_anex_deta
             set deta_esta = 'D'
           where deta_codi =
                 (select d.deta_codi_anex_padr
                    from come_soli_serv_anex_deta d
                   where d.deta_codi = v('P53_ORTR_DETA_CODI'));
        
          for x in c_plan_cambio(v('P53_ORTR_DETA_CODI')) loop
            update come_soli_serv_anex_plan ap
               set ap.anpl_deta_esta_plan = 'N',
                   ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
             where ap.anpl_codi = x.anpl_codi;
          end loop;
        
          pp_generar_desi_ot;
        
          --debe actualizar datos del vehiculo, que puede ser iden, cliente, asegurado
          update come_vehi
             set vehi_iden                = v('P53_ORTR_VEHI_IDEN'),
                 vehi_clpr_codi           = v('P53_ORTR_CLPR_CODI'),
                 vehi_clpr_sucu_nume_item = v('P53_ORTR_CLPR_SUCU_NUME_ITEM'),
                 vehi_iden_ante           = v('P53_ORTR_VEHI_IDEN_ANTE')
           where vehi_codi = v('P53_ORTR_VEHI_CODI');
          --- end if;
        
          --####################
          --cambio de titularidad
        
          if v('P53_ORTR_SERV_TIPO') = 'T' then
            raise_application_error(-20001, 'titulalridad 1');
          
            if nvl(v('P53_P_INDI_GENE_PLAN_LIQU_OT'), 'N') = 'S' then
              --- si el parametro esta en s para alarmas
            
              --verifica si ya tiene plan para generar al liquidar la ot
              begin
                select count(*) cant
                  into v_plan
                  from come_orde_trab           t,
                       come_soli_serv_anex      a,
                       come_soli_serv_anex_deta d,
                       come_soli_serv_anex_plan p
                 where a.anex_codi = p.anpl_anex_codi
                   and a.anex_codi = d.deta_anex_codi
                   and t.ortr_deta_codi = d.deta_codi
                   and t.ortr_codi = v('P53_ORTR_CODI');
              
              exception
                when others then
                  v_plan := 0;
              end;
            
              if v_plan = 0 then
                --procedimiento para generar el plan
                for x in c_anex loop
                
                  begin
                  
                    pack_fact_ciclo.pa_generar_detalle_plan(x.anex_codi,
                                                            to_date(v('P53_ORTR_FECH_INST')) - 1, --se envia con fecha - 1 porque el proceso que usa hace fecha + 1
                                                            x.anex_dura_cont,
                                                            x.anex_cant_cuot_modu,
                                                            x.anex_impo_mone_unic,
                                                            x.anex_prec_unit,
                                                            x.sose_tipo_fact,
                                                            x.clpr_dia_tope_fact,
                                                            x.cuot_inic,
                                                            x.clas1_dias_venc_fact,
                                                            x.anex_empr_codi,
                                                            x.sose_sucu_nume_item,
                                                            x.mone_cant_deci,
                                                            x.anex_indi_fact_impo_unic,
                                                            x.anex_cifa_codi,
                                                            x.anex_cifa_tipo,
                                                            x.anex_cifa_dia_fact,
                                                            x.anex_cifa_dia_desd,
                                                            x.anex_cifa_dia_hast,
                                                            x.anex_aglu_cicl);
                  
                    /* pack_fact_ciclo.pa_generar_detalle_plan(x.anex_codi,
                    to_date(v('p53_ortr_fech_inst')) - 1, --se envia con fecha - 1 porque el proceso que usa hace fecha + 1
                    x.anex_dura_cont,
                    x.anex_cant_cuot_modu,
                    x.anex_impo_mone_unic,
                    x.anex_prec_unit,
                    x.sose_tipo_fact,
                    x.clpr_dia_tope_fact,
                    x.cuot_inic,
                    x.clas1_dias_venc_fact,
                    x.anex_empr_codi,
                    x.sose_sucu_nume_item,
                    x.mone_cant_deci,
                    x.anex_indi_fact_impo_unic,
                    x.anex_cifa_codi,
                    x.anex_cifa_tipo,
                    x.anex_cifa_dia_fact,
                    x.anex_cifa_dia_desd,
                    x.anex_cifa_dia_hast,
                    x.anex_aglu_cicl);*/
                  
                  exception
                  
                    when others then
                    
                      raise_application_error(-20001,
                                              'Error en PA_GENERAR_DETALLE_PLAN');
                  end;
                end loop;
              end if;
            
              --genera la factura automatica
              begin
                --busca usuario
                select user_codi
                  into v_user_codi
                  from segu_user
                 where user_login = fp_user;
              end;
            
              for x in c_fact loop
              
                begin
                
                  pack_fact_ciclo.pa_gene_plan_fact_movi(x.sose_clpr_codi,
                                                         x.anex_cifa_codi,
                                                         x.sose_codi,
                                                         x.sose_nume,
                                                         x.anex_codi,
                                                         x.sose_tipo_fact,
                                                         x.agru_anex,
                                                         x.fech_fact_desd,
                                                         x.fech_fact_hast,
                                                         x.movi_fech_emis,
                                                         v('P53_P_PECO_CODI'),
                                                         v_user_codi,
                                                         x.sucu_codi,
                                                         x.depo_codi,
                                                         x.clas1_codi,
                                                         x.anpl_impo_reca_red_cobr,
                                                         x.indi_excl_clie_clas1_aseg,
                                                         v_faau_codi,
                                                         v_codresp,
                                                         v_descresp,
                                                         v_movi_codi);
                
                  -- si v_codresp es distinto a 1 significa que ocurri? una excepcion
                  if nvl(v_codresp, 1) = 1 then
                    env_fact_sifen.pp_get_json_fact(v_movi_codi);
                    begin
                      i020273_a.pp_enviar_sms_fact(p_movi_codi => v_movi_codi);
                    end;
                  
                    /*              begin
                      -- call the procedure
                      if nvl(x.deta_indi_prom_pror,'n')='s' then
                        pa_ gene_nota_cred_pror(p_clave_fact => v_movi_codi,
                                                 p_clave_ot   => v('p53_ortr_codi'));
                      end if;
                    end;*/
                  
                  else
                    raise_application_error(-20001, v_descresp);
                  end if;
                
                  -- exception
                  --   when others then
                  --   raise_application_error(-20001,'error plan factura');
                end;
              end loop;
            end if;
          end if;
          --####################
        end if;
        --raise_application_error(-20001, 'awwqui');
      
        update come_vehi
           set vehi_iden                = v('P53_ORTR_VEHI_IDEN'),
               vehi_clpr_codi           = v('P53_ORTR_CLPR_CODI'),
               vehi_clpr_sucu_nume_item = v('P53_ORTR_CLPR_SUCU_NUME_ITEM'),
               vehi_iden_ante           = v('P53_ORTR_VEHI_IDEN_ANTE')
         where vehi_codi = v('P53_ORTR_VEHI_CODI');
      
        --ri= reinstalacion
      elsif v('P53_ORTR_SERV_TIPO') = 'RI' then
      
        if ((v('P53_ORTR_ESTA') = 'L' and v('P53_ORTR_ESTA_ORIG') = 'P') and
           v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'N') or
           (v('P53_ORTR_ESTA_PRE_LIQU') = 'S' and
           v('P53_ORTR_ESTA_PRE_LIQU_ORIG') = 'N') then
        
          begin
            select count(*)
              into v_cant_padr
              from come_soli_serv_anex      a,
                   come_soli_serv_anex_deta d,
                   come_orde_trab           o
             where a.anex_codi = d.deta_anex_codi
               and d.deta_codi_anex_padr = o.ortr_deta_codi
               and a.anex_tipo in ('RN', 'RI')
               and o.ortr_serv_tipo = 'D'
               and o.ortr_serv_tipo_moti = 'RN'
               and o.ortr_esta != 'L'
               and d.deta_codi = v('P53_ORTR_DETA_CODI');
          exception
            when no_data_found then
              v_cant_padr := 0;
          end;
        
          if nvl(v_cant_padr, 0) > 0 then
          
            begin
              select max(o.ortr_nume)
                into v_ortr_nume
                from come_soli_serv_anex      a,
                     come_soli_serv_anex_deta d,
                     come_orde_trab           o
               where a.anex_codi = d.deta_anex_codi
                 and d.deta_codi_anex_padr = o.ortr_deta_codi
                 and a.anex_tipo in ('RN', 'RI')
                 and o.ortr_serv_tipo = 'D'
                 and o.ortr_serv_tipo_moti = 'RN'
                 and o.ortr_esta != 'L'
                 and d.deta_codi = v('P53_ORTR_DETA_CODI');
            exception
              when no_data_found then
                v_ortr_nume := null;
            end;
          
            raise_application_error(-20001,
                                    'Primero debe liquidar la OT (' ||
                                    v_ortr_nume ||
                                    ') de desinstalaci?n relacionada');
          end if;
        
          setitem('P53_ORTR_ESTA_PRE_LIQU', 'S');
          for x in c_plan_cambio(v('P53_ORTR_DETA_CODI')) loop
            update come_soli_serv_anex_plan ap
               set ap.anpl_deta_esta_plan = 'N',
                   ap.anpl_ortr_codi      = v('P53_ORTR_CODI')
             where ap.anpl_codi = x.anpl_codi;
          end loop;
        
          update come_vehi
             set vehi_esta = 'I'
           where vehi_codi = v('P53_ORTR_VEHI_CODI');
        
          update come_soli_serv_anex_deta
             set deta_esta = 'I'
           where deta_codi = v('P53_ORTR_DETA_CODI');
        
          --####################
          if nvl(v('P53_P_INDI_GENE_PLAN_LIQU_OT'), 'N') = 'S' then
            --- si el parametro esta en s para alarmas
            --verifica si ya tiene plan para generar al liquidar la ot
          
            begin
              select count(*) cant
                into v_plan
                from come_orde_trab           t,
                     come_soli_serv_anex      a,
                     come_soli_serv_anex_deta d,
                     come_soli_serv_anex_plan p
               where a.anex_codi = p.anpl_anex_codi
                 and a.anex_codi = d.deta_anex_codi
                 and t.ortr_deta_codi = d.deta_codi
                 and t.ortr_codi = v('P53_ORTR_CODI');
            
            exception
              when others then
                v_plan := 0;
            end;
          
            if v_plan = 0 then
              --procedimiento para generar el plan
              for x in c_anex loop
              
                begin
                  pack_fact_ciclo.pa_generar_detalle_plan(x.anex_codi,
                                                          to_date(v('P53_ORTR_FECH_INST')) - 1, --se envia con fecha - 1 porque el proceso que usa hace fecha + 1
                                                          x.anex_dura_cont,
                                                          x.anex_cant_cuot_modu,
                                                          x.anex_impo_mone_unic,
                                                          x.anex_prec_unit,
                                                          x.sose_tipo_fact,
                                                          x.clpr_dia_tope_fact,
                                                          x.cuot_inic,
                                                          x.clas1_dias_venc_fact,
                                                          x.anex_empr_codi,
                                                          x.sose_sucu_nume_item,
                                                          x.mone_cant_deci,
                                                          x.anex_indi_fact_impo_unic,
                                                          x.anex_cifa_codi,
                                                          x.anex_cifa_tipo,
                                                          x.anex_cifa_dia_fact,
                                                          x.anex_cifa_dia_desd,
                                                          x.anex_cifa_dia_hast,
                                                          x.anex_aglu_cicl);
                exception
                  when others then
                    raise_application_error(-20001, 'ERROR2');
                end;
              end loop;
            end if;
          
            --genera la factura automatica
            begin
              --busca usuario
              select user_codi
                into v_user_codi
                from segu_user
               where user_login = fp_user;
            end;
          
            for x in c_fact loop
              begin
                -----------lv, si se ejecuta al mismo tiempo duplica el nro de factura 
                -----------agregue un intervalo de tiempo aleatorio para que de tiempo entre ambos
                begin
                  tiempo_inicial := systimestamp; -- obtener la marca de tiempo inicial
                  intervalo      := numtodsinterval(tiempo_espera, 'SECOND'); -- convertir segundos a un intervalo de tiempo
                  loop
                    tiempo_actual := systimestamp; -- obtener la marca de tiempo actual
                    exit when(tiempo_actual - tiempo_inicial) >= intervalo; -- salir del bucle despu?s de x segundos
                  end loop;
                end;
              
                pack_fact_ciclo.pa_gene_plan_fact_movi(x.sose_clpr_codi,
                                                       x.anex_cifa_codi,
                                                       x.sose_codi,
                                                       x.sose_nume,
                                                       x.anex_codi,
                                                       x.sose_tipo_fact,
                                                       x.agru_anex,
                                                       x.fech_fact_desd,
                                                       x.fech_fact_hast,
                                                       x.movi_fech_emis,
                                                       v('P53_P_PECO_CODI'),
                                                       v_user_codi,
                                                       x.sucu_codi,
                                                       x.depo_codi,
                                                       x.clas1_codi,
                                                       x.anpl_impo_reca_red_cobr,
                                                       x.indi_excl_clie_clas1_aseg,
                                                       v_faau_codi,
                                                       v_codresp,
                                                       v_descresp,
                                                       v_movi_codi);
              
                --raise_application_error(-20001,v_faau_codi);
              
                -- si v_codresp es distinto a 1 significa que ocurri? una excepcion
                if nvl(v_codresp, 1) = 1 then
                  env_fact_sifen.pp_get_json_fact(v_movi_codi);
                  begin
                    i020273_a.pp_enviar_sms_fact(p_movi_codi => v_movi_codi);
                  end;
                
                  /*              begin
                    -- call the procedure
                    if nvl(x.deta_indi_prom_pror,'n')='s' then
                      pa_ gene_nota_cred_pror(p_clave_fact => v_movi_codi,
                                               p_clave_ot   => v('p53_ortr_codi'));
                    end if;
                  end;*/
                
                else
                
                  raise_application_error(-20001, v_descresp);
                end if;
              
              end;
            end loop;
          
            update come_vehi
               set vehi_iden                = v('P53_ORTR_VEHI_IDEN'),
                   vehi_clpr_codi           = v('P53_ORTR_CLPR_CODI'),
                   vehi_clpr_sucu_nume_item = v('P53_ORTR_CLPR_SUCU_NUME_ITEM'),
                   vehi_iden_ante           = v('P53_ORTR_VEHI_IDEN_ANTE')
             where vehi_codi = v('P53_ORTR_VEHI_CODI');
          
          end if;
          --####################
        
        end if;
      end if;
    
    end if;
    --0raise_application_error(-20001, 'kdajf');
  end pp_liquida_ot2;

  --------------------------------------------------
  procedure pp_notification_fcm(type_notificacion in varchar,
                                i_token_fcm       in varchar2 default null,
                                i_user_fcm        in varchar2 default null) is
  
    v_codresp       number;
    v_descresp      varchar2(200);
    v_p53_clpr_desc varchar2(200);
    v_token_fcm     varchar2(200);
    v_mesi_desc     varchar2(1000);
  
    procedure pp_get_token(id_user in number, o_token out varchar2) is
    
    begin
      select user_token_fcm
        into o_token
        from segu_user
       where user_empl_codi = id_user;
    end;
  
  begin
  
    if type_notificacion = 'I' then
    
      if v('P53_ORTR_SERV_TIPO') = 'C' and v('P53_ORTR_ESTA') = 'P' then
      
        pp_get_token(v('P53_VEHI_EMPL_CODI'), v_token_fcm);
      
        if v_token_fcm is not null then
        
          v_p53_clpr_desc := v('P53_CLPR_DESC');
          pack_notification_fcm.pp_send_notificacion(token_fcm    => v_token_fcm,
                                                     title        => 'Cobranzas',
                                                     subtitle     => '',
                                                     body_message => '- Se ha agregado el cliente ' ||
                                                                     v_p53_clpr_desc ||
                                                                     ' a la lista de cobranzas!',
                                                     p_codresp    => v_codresp,
                                                     p_descresp   => v_descresp);
        
          if v_codresp < 0 then
            --habilitar cuando todos tengan la misma version
            --raise_application_error (-20001, ''||v_descresp);
            null;
          end if;
        else
          ----habilitar cuando todos tengan la misma version
          --raise_application_error (-20001, 'el cliente no tiene asignado ning?n token de firebase, notificacion no enviada.!');
          null;
        end if;
      
      end if;
    
    else
      --notifica al tecnico la asignacion de la ot
      --comentar para pruebas
      if v_token_fcm is not null then
      
        v_p53_clpr_desc := v('P53_CLPR_DESC');
        pack_notification_fcm.pp_send_notificacion(token_fcm    => v_token_fcm,
                                                   title        => 'Cobranzas',
                                                   subtitle     => '',
                                                   body_message => '- Se ha agregado el cliente ' ||
                                                                   v_p53_clpr_desc ||
                                                                   ' a la lista de cobranzas!',
                                                   p_codresp    => v_codresp,
                                                   p_descresp   => v_descresp);
      
        if v_codresp < 0 then
          ----habilitar cuando todos tengan la misma version
          --raise_application_error (-20001, ''||v_descresp);
          null;
        end if;
      else
        --habilitar cuando todos tengan la misma version
        --raise_application_error (-20001, 'el cliente no tiene asignado ningun token de firebase, notificacion no enviada.!');
        null;
      end if;
    
      --notifica al tecnico la re-asignacion de la ot a otro tecnico
      if i_token_fcm is not null then
      
        v_mesi_desc := 'Se ha reasignado la orden de servicio con Nro. ' ||
                       v('P53_ORTR_NUME') || ' para el cliente ' ||
                       v('P53_CLPR_DESC') || ', con fecha de emision' ||
                       v('P53_ORTR_FECH_REGI');
        -------
        insert into come_mens_sist
          (mesi_codi,
           mesi_desc,
           mesi_user_dest,
           mesi_user_envi,
           mesi_fech,
           mesi_indi_leid,
           mesi_tipo_docu,
           mesi_docu_codi,
           mesi_tipo)
        values
          (sec_come_mens_sist.nextval,
           v_mesi_desc,
           i_user_fcm,
           fp_user,
           sysdate,
           'S',
           'OT',
           v('P53_ORTR_CODI'),
           'Reasignacion');
        ---   commit;
        -------
        pack_notification_fcm.pp_send_notificacion(token_fcm    => i_token_fcm,
                                                   title        => 'Cobranzas',
                                                   subtitle     => '',
                                                   body_message => '- Se ha reasignado el cliente ' ||
                                                                   v('P53_CLPR_DESC') ||
                                                                   ' a otro tecnico!',
                                                   p_codresp    => v_codresp,
                                                   p_descresp   => v_descresp);
      
        if v_codresp < 0 then
          --habilitar cuando todos tengan la misma version
          --raise_application_error (-20001, ''||v_descresp||'up');
          null;
        end if;
      
      else
        --habilitar cuando todos tengan la misma version
        --raise_application_error (-20001, 'el cliente no tiene asignado ningun token de firebase, notificacion no enviada.up!');
        null;
      end if;
    
    end if;
  
  end;
  --------------------------------------------------

  procedure pp_enviar_sms_fact(p_movi_codi in number) is
  
    cursor c_fact is
      select movi_codi,
             movi_nume,
             movi_fech_emis,
             nvl(cp.clpr_indi_omit_sms, 'N') clpr_indi_omit_sms,
             fa_devu_tele_form(nvl(cp.clpr_celu, cp.clpr_tele)) clpr_tele,
             clpr_codi,
             clpr_codi_alte,
             clpr_desc,
             max(cuot_fech_venc) max_cuot_fech_venc,
             min(cuot_fech_venc) min_cuot_fech_venc,
             sum(cuot_impo_mone) sum_cuot_impo_mone,
             count(*) cant_cuot
        from come_movi m, come_movi_cuot, come_clie_prov cp
       where movi_codi = cuot_movi_codi
         and movi_clpr_codi = clpr_codi
         and movi_timo_codi = 2
         and nvl(m.movi_indi_sms, 'N') = 'N'
         and movi_codi = p_movi_codi
       group by movi_codi,
                movi_nume,
                movi_fech_emis,
                nvl(cp.clpr_indi_omit_sms, 'N'),
                fa_devu_tele_form(nvl(cp.clpr_celu, cp.clpr_tele)),
                clpr_codi,
                clpr_codi_alte,
                clpr_desc;
  
    v_msgfrom     varchar2(30);
    v_text_envi   varchar2(1000);
    v_resp        varchar2(4000);
    v_smco_codi   number(10);
    v_tipo_desc   varchar2(100);
    v_text_1      varchar2(1000);
    v_tipo_desc_1 varchar2(100);
  
    v_ensm_codi           number(20);
    v_ensm_fech_envi      date;
    v_ensm_user_envi      varchar2(20);
    v_ensm_clpr_codi      number(20);
    v_ensm_clpr_tele      varchar2(50);
    v_ensm_text           varchar2(4000);
    v_ensm_resp           varchar2(4000);
    v_ensm_tipo           varchar2(2);
    v_ensm_indi_envi      varchar2(1);
    v_ensm_fech_regi      date;
    v_ensm_tipo_desc      varchar2(100);
    v_ensm_dias_atra      number(10);
    v_ensm_cuot_fech_venc date;
    v_ensm_cant_cuot_venc number(10);
    v_ensm_clpr_desc      varchar2(200);
    v_ensm_clpr_codi_alte number(20);
    v_ensm_smco_codi      number(10);
    v_ensm_indi_omit_sms  varchar2(1);
  begin
  
    begin
      select smco_text, smco_desc
        into v_text_1, v_tipo_desc_1
        from come_envi_sms_conf
       where smco_codi = 1; --emision de factura
    exception
      when no_data_found then
        v_text_1      := null;
        v_tipo_desc_1 := null;
    end;
  
    for x in c_fact loop
      v_text_envi := v_text_1;
      v_tipo_desc := v_tipo_desc_1;
      v_smco_codi := 1;
    
      v_text_envi := replace(v_text_envi,
                             'P_CUOT_FECH_VENC',
                             x.max_cuot_fech_venc);
    
      v_text_envi := replace(v_text_envi, 'P_MOVI_NUME', x.movi_nume);
    
      v_text_envi := replace(v_text_envi,
                             'P_CUOT_IMPO_MONE',
                             x.sum_cuot_impo_mone);
    
      v_ensm_codi           := sec_come_envi_sms.nextval;
      v_ensm_fech_envi      := null;
      v_ensm_user_envi      := 'ALARMAS';
      v_ensm_clpr_codi      := x.clpr_codi;
      v_ensm_clpr_tele      := x.clpr_tele;
      v_ensm_text           := v_text_envi;
      v_ensm_resp           := null;
      v_ensm_tipo           := 'A';
      v_ensm_indi_envi      := 'N';
      v_ensm_fech_regi      := sysdate;
      v_ensm_tipo_desc      := v_tipo_desc;
      v_ensm_dias_atra      := null;
      v_ensm_cuot_fech_venc := x.max_cuot_fech_venc;
      v_ensm_cant_cuot_venc := null;
      v_ensm_clpr_desc      := x.clpr_desc;
      v_ensm_clpr_codi_alte := x.clpr_codi_alte;
      v_ensm_smco_codi      := v_smco_codi;
      v_ensm_indi_omit_sms  := x.clpr_indi_omit_sms;
    
      insert into come_envi_sms
        (ensm_codi,
         ensm_fech_envi,
         ensm_user_envi,
         ensm_clpr_codi,
         ensm_clpr_tele,
         ensm_text,
         ensm_resp,
         ensm_tipo,
         ensm_indi_envi,
         ensm_fech_regi,
         ensm_tipo_desc,
         ensm_dias_atra,
         ensm_cuot_fech_venc,
         ensm_cant_cuot_venc,
         ensm_clpr_desc,
         ensm_clpr_codi_alte,
         ensm_smco_codi,
         ensm_indi_omit_sms)
      values
        (v_ensm_codi,
         v_ensm_fech_envi,
         v_ensm_user_envi,
         v_ensm_clpr_codi,
         v_ensm_clpr_tele,
         v_ensm_text,
         v_ensm_resp,
         v_ensm_tipo,
         v_ensm_indi_envi,
         v_ensm_fech_regi,
         v_ensm_tipo_desc,
         v_ensm_dias_atra,
         v_ensm_cuot_fech_venc,
         v_ensm_cant_cuot_venc,
         v_ensm_clpr_desc,
         v_ensm_clpr_codi_alte,
         v_ensm_smco_codi,
         v_ensm_indi_omit_sms);
    
      update come_movi
         set movi_indi_sms = 'S'
       where movi_codi = x.movi_codi;
    
      --commit;
    
      pack_envi_sms.pa_send_twilio_msg(v_ensm_text,
                                       v_ensm_clpr_tele,
                                       null,
                                       v_resp);
    
      v_leng := length(replace(v_resp, '"', '')); -- esto hacemos para saber si el envio retorno "0" o algun error html por eso la expresion >35
    
      if v_leng = 1 or v_leng >= 35 then
      
        update come_envi_sms
           set ensm_fech_envi = sysdate,
               ensm_resp      = v_resp,
               ensm_indi_envi = 'N'
         where ensm_codi = v_ensm_codi;
      
      else
      
        update come_envi_sms
           set ensm_fech_envi = sysdate,
               ensm_resp      = v_resp,
               ensm_indi_envi = 'S'
         where ensm_codi = v_ensm_codi;
      
      end if;
      --commit;
    
    end loop;
  
  exception
    when others then
      raise_application_error(-20000, 'ERROR ' || sqlerrm);
    
  end pp_enviar_sms_fact;

  procedure pp_buscar_imei_linea(i_lote_codi in number,
                                 o_imei      out varchar2,
                                 o_linea     out varchar2) is
    v_imei  varchar2(500);
    v_linea varchar2(500);
    salir   exception;
    cursor cur_busc_linea is
      select lot.lote_desc, de.deta_prod_codi
        from come_movi mo,
             come_lote lot,
             come_movi_prod_deta de,
             (select max(m.movi_codi) movi_codi
                from come_movi m, come_movi_prod_deta d
               where movi_codi = d.deta_movi_codi
                 and m.movi_oper_codi = 46
                 and d.deta_lote_codi = i_lote_codi) padre
       where mo.movi_codi_padr = padre.movi_codi
         and mo.movi_codi = de.deta_movi_codi
         and de.deta_lote_codi = lot.lote_codi;
  
    function fp_es_linea(i_prod_codi in number) return boolean is
      v_count number;
    begin
      select count(*)
        into v_count
        from come_prod t
       where (upper(t.prod_desc) like '%LIN%TIGO%' or
             upper(t.prod_desc) like '%LIN%PERSONAL%')
         and t.prod_codi = i_prod_codi;
      if v_count > 0 then
        return true;
      else
        return false;
      end if;
    end fp_es_linea;
  
  begin
  
    if i_lote_codi is null then
      raise salir;
    end if;
    select t.lote_desc
      into v_imei
      from come_lote t
     where t.lote_codi = i_lote_codi;
  
    for c in cur_busc_linea loop
      if fp_es_linea(c.deta_prod_codi) then
        v_linea := c.lote_desc;
      end if;
    end loop;
  
    o_imei  := v_imei;
    o_linea := v_linea;
  exception
    when salir then
      null;
  end pp_buscar_imei_linea;

  function fp_ind_camb_disp_ortr(i_ortr_codi in number,
                                 i_vehi_codi in number) return boolean as
    v_count number := 0;
  begin
    select count(*)
      into v_count
      from come_vehi_hist v1
     where vehi_codi = i_vehi_codi
       and vehi_ortr_codi = i_ortr_codi
    /*and vehi_secu =
    (select max(vehi_secu)
       from come_vehi_hist v2, come_vehi v
      where v.vehi_codi = v2.vehi_codi
        and v.vehi_codi = i_vehi_codi
        and vehi_ortr_codi = i_ortr_codi
        and v.vehi_equi_id <> v2.vehi_equi_id)*/
    ;
  
    if v_count > 0 then
      return true;
    else
      return false;
    end if;
  end fp_ind_camb_disp_ortr;

  function fp_ind_camb_disp(i_vehi_codi in number) return boolean as
    v_count number := 0;
  begin
    select count(*)
      into v_count
    /*vehi_equi_mode,
    vehi_equi_id,
    vehi_equi_imei,
    vehi_equi_sim_card,
    vehi_alar_id*/
      from come_vehi_hist v1
     where vehi_codi = i_vehi_codi
       and vehi_secu =
           (select max(vehi_secu)
              from come_vehi_hist v2, come_vehi v
             where v.vehi_codi = v2.vehi_codi
               and v.vehi_codi = i_vehi_codi
               and v.vehi_equi_id <> v2.vehi_equi_id);
  
    if v_count > 0 then
      return true;
    else
      return false;
    end if;
  end fp_ind_camb_disp;

  procedure pp_completar_historico is
    cursor cur_ortr is
      select *
        from come_orde_trab t
       where t.ortr_codi_padr is null
         and t.ortr_serv_tipo not in ('I', 'RI');
  
    v_codi_padre number;
    v_form_inst  number;
    v_row_count  number := 0;
  begin
  
    for c in cur_ortr loop
      if upper(c.ortr_serv_tipo) not in ('I', 'RI') and
         c.ortr_vehi_codi is not null then
        v_row_count := v_row_count + 1;
        select max(t.ortr_codi)
          into v_codi_padre
          from come_orde_trab t
         where t.ortr_vehi_codi = c.ortr_vehi_codi
           and t.ortr_serv_tipo in ('I', 'RI');
      
        dbms_output.put_line('codi=' || c.ortr_codi || ' -padre=' ||
                             v_codi_padre);
      
        if v_codi_padre is not null then
        
          select t.ortr_form_insu
            into v_form_inst
            from come_orde_trab t
           where t.ortr_codi = v_codi_padre;
        
          update come_orde_trab u
             set u.ortr_codi_padr = v_codi_padre,
                 u.ortr_form_insu = v_form_inst
           where u.ortr_codi = c.ortr_codi;
        
          if mod(v_row_count, 10) = 0 then
            commit;
          end if;
        end if;
      
      end if;
    end loop;
    commit;
  end pp_completar_historico;

  function fp_get_code_from_desc_lote(i_desc in varchar2) return number is
    v_return number;
  begin
    select t.lote_codi
      into v_return
      from come_lote t
     where t.lote_desc = i_desc;
    return v_return;
  exception
    when no_data_found then
      return null;
    when too_many_rows then
      select t.lote_codi
        into v_return
        from come_lote t, come_prod a
       where t.lote_prod_codi = a.prod_codi
         and t.lote_desc = i_desc
         and upper(a.prod_desc) like upper('%Equipo Rastreo%');
    
      return v_return;
  end fp_get_code_from_desc_lote;

  function fp_get_lote_desc(i_lote_codi in number) return varchar2 as
    v_return varchar2(100);
    e_salir  exception;
  begin
    if i_lote_codi is null then
      raise e_salir;
    end if;
    select t.lote_desc
      into v_return
      from come_lote t
     where t.lote_codi = i_lote_codi;
    return v_return;
  exception
    when e_salir then
      return null;
  end fp_get_lote_desc;
  
  
  
 procedure pp_enviar_comando_gprs(p_tipo_coma in number,
                                    p_imei      in varchar2,
                                   p_cliente   in number) is

  v_estado         varchar2(100);
  v_param          varchar2(32000);
  v_hash           varchar2(1000);
  v_tipo_comando1  varchar2(100);
  v_tipo_comando2  varchar2(100);
  v_tipo_comando3  varchar2(100);
  v_user           varchar2(100) := fp_user;
  v_empr_user_mapa varchar2(50);
  v_empr_pass_mapa varchar2(100);
  v_url            varchar2(4000);
  vl_url           varchar2(4000);
  v_status         varchar2(20);
  v_mensaje        varchar2(1000);
  v_gmch_clave     number;
  v_resp           varchar2(100);
  v_json           clob;
  l_json_doc       clob;

  v_cont               number := 0;
  v_tipo_comando       varchar2(100);
  v_codigo_dispositivo number;
begin

  if p_tipo_coma = 1 then
    ------------apagar motor 
    v_tipo_comando := 'engineStop';
  elsif p_tipo_coma = 2 then
    --------------Reanudar motor
    v_tipo_comando := 'engineResume';
  else
    raise_application_error(-20001, 'Error con el tipo de comando');
  end if;
  
  

  begin
    select e.empr_user_mapa, e.empr_pass_mapa
      into v_empr_user_mapa, v_empr_pass_mapa
      from come_empr e
     where e.empr_codi = 1;
  
    apex_json.initialize_clob_output;
    apex_json.open_object;
    apex_json.write('email', v_empr_user_mapa);
    apex_json.write('password', v_empr_pass_mapa);
    apex_json.close_object;
  
    v_param := apex_json.get_clob_output;
    apex_json.free_output;
  
    pack_mapas.pa_obtiene_hash(v_param, v_hash);
  end;

 -------------buscamos el codigo del dispositivo en el mapa
 
        /*select distinct (gmch_id)
          into v_codi
          from come_mapa_get_chas_mail t
         where gmch_imei = '862292051757987';
        */
   vl_url := 'https://gps.alarmas.com.py/api/admin/devices?user_api_hash=' ||
              v_hash || '&imei=' || p_imei;
              
              
    l_json_doc :=  apex_web_service.make_rest_request(p_url         => vl_url,
                                                      p_http_method => 'GET');
  
    ------------------------------------------------------------------------------***
    for x in (select id
                from json_table(l_json_doc,
                                '$'
                                columns(estatus number path '$.status',
                                        nested path '$.data[*]'
                                        columns(id number path '$.id'
                                                ))) j) loop
    
      v_codigo_dispositivo   := x.id;
    
    end loop;

  if v_codigo_dispositivo is null then
    raise_application_error(-20001,'Debe elegir el dispositivo al cual enviar el comando');
  end if;


  v_url := 'https://gps.alarmas.com.py/api/send_gprs_command?user_api_hash=' ||
           v_hash || '&device_id=' || v_codigo_dispositivo;

  v_param := 'type=' ||apex_util.url_encode(v_tipo_comando);

  pack_mapas.pa_upd_clpr_mapa(v_url, v_param, v_status, v_mensaje);

  if v_status = '1' then
    apex_application.g_print_success_message := 'Comando enviado con exito';
  else
    raise_application_error(-20001,'Error al enviar comando:' || v_mensaje);
  end if;

  insert into mapa_comando_aud
    (com_evento,
     com_divec,
     com_tipo,
     com_login,
     com_fec_grab,
     COM_PROG,
     COM_RESP,
     COM_IMEI,
     COM_CLIE)
  values
    (NULL,
     v_codigo_dispositivo,
     v_tipo_comando,
     gen_user,
     sysdate,
     'i020273_a',
     substr(v_mensaje, 1, 1000),
     p_imei,
     p_cliente);

  commit;

end pp_enviar_comando_gprs;
function fp_most_envi_coma(p_vehi in number) return number is
  v_cant_horas number;
begin
  -- consulta para obtener la cantidad m nima de horas pasadas desde la grabaci n
  select min(round((sysdate - t.mpa_fec_grab) * 24, 2))
    into v_cant_horas
    from mapa_proc_aud t
   where t.mpa_accion = 'dispositivo_usuario'
     and t.mpa_dispositivo = p_vehi;

  -- condici n para retornar 1 si las horas son menores o iguales a 2
  if  v_cant_horas <= 2  then
    return 1;
  else
    return 0;
  end if;
 

exception
  when others then
    return 0;
end fp_most_envi_coma;

end i020273_a;
