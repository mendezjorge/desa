
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020117" is
  g_user varchar2(200) := gen_user;
  type r_variable is record(
    clpr_codi                     number,
    pres_clpr_desc                varchar2(200),
    pres_clpr_codi                number,
    clpr_indi_vali_limi_cred      varchar2(2),
    pres_clpr_ruc                 varchar2(30),
    pres_clpr_dire                varchar2(300),
    pres_clpr_tele                varchar2(300),
    s_orte_desc                   varchar2(300),
    pres_clpr_cli_situ_codi       number,
    pres_clpr_indi_vali_situ_clie varchar2(30),
    clpr_indi_exen                varchar2(30),
    pres_tipo                     varchar2(2),
    pres_clpr_indi_list_negr      varchar2(2),
    pres_clpr_indi_exce           varchar2(2),
    clpr_maxi_porc_deto           number,
    clpr_segm_codi                number,
    clpr_clie_clas1_codi          number,
    clpr_indi_vali_prec_mini      varchar2(2),
    clpr_agen_codi                number,
    sum_s_total_item_most         number,
    s_limi_cred_mone              number,
    s_sald_clie_mone              number,
    s_sald_limi_cred              number,
    pres_mone_codi                number,
    pres_auto_limi_cred           varchar2(2),
    s_cred_espe_mone              number,
    s_pres_impo_deto              number,
    clpr_orte_codi                number,
    pres_orte_codi                number,
    s_orte_maxi_porc              number,
    s_orte_porc_entr              number,
    pres_auto_cheq_rech           varchar2(2),
    pres_auto_situ_clie           varchar2(2),
    s_orte_cant_cuot              number,
    s_orte_impo_cuot              number,
    s_orte_dias_cuot              number,
    pres_codi_a_modi              number,
    clpr_list_codi                number,
    pres_list_prec                number,
    orte_list_codi                number,
    pres_form_entr_codi           number,
    pres_fech_emis                date,
    pres_empl_codi                number,
    s_timo_indi_caja              varchar2(2),
    pres_afec_sald                varchar2(2),
    s_form_entr_desc              varchar2(200),
    pres_tasa_mone                number,
    pres_mone_cant_deci           number,
    s_total                       number,
    s_total_bruto                 number,
    indi_mano_obra                varchar2(20),
    timo_indi_cont_cred           varchar2(200),
    pres_desc_mano_obra           varchar2(200),
    pres_codi                     number,
    pres_nume                     number,
    pres_numep_pres_nume          number,
    nume_pres_ante                number,
    pres_inve_codi                number,
    pres_timo_codi                number,
    pres_clpr_cont                number,
    pres_clpr_sres                varchar2(200),
    pres_vali_ofer                varchar2(200),
    pres_obse                     varchar2(200),
    pres_fech_grab                date,
    pres_user                     varchar2(200),
    pres_plaz_entr                number,
    pres_cond_vent                number,
    pres_porc_deto                number,
    pres_impo_mano_obra           number,
    pres_impo_mano_obra_deto      number,
    pres_porc_reca                number,
    pres_impo_mano_obra_reca      number,
    sucu_nume_item                number,
    pres_depo_codi                number,
    pres_indi_vent_comp           varchar2(20),
    pres_refe                     varchar2(200),
    user_indi_real_deto_sin_exce  varchar2(20),
    pres_empl_codi_vent_comp      number,
    empl_codi_alte_vent           number,
    pres_empr_codi                number,
    empl_desc_vent_comp           varchar2(200),
    pres_auto_desc_prod           varchar2(200),
    pres_indi_user_deto           varchar2(200),
    exde_tipo                     varchar2(20),
    pres_tasa_come                number,
    clpr_codi_alte                number,
    pres_fech_emis_hora           date
    
    );
  bcab r_variable;

  type r_parameter is record(
    p_empr_codi                number := v('AI_EMPR_CODI'),
    p_indi_impr_dire_puer      varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_impr_dire_puer'))),
    p_indi_most_vent_comp_pres varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_vent_comp_pres'))),
    p_indi_cons_pres           varchar2(1) := 'N',
    p_ind_validar_cab          varchar2(1) := 'S',
    p_ind_validar_det          varchar2(1) := 'S',
    p_form_impr_fact           varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_fact'))),
    p_codi_clas1_clie_subclie  number := to_number(general_skn.fl_busca_parametro('p_codi_clas1_clie_subclie')),
    p_indi_fact_sub_clie       varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_fact_sub_clie'))),
    p_indi_ruc_exis            varchar2(1) := 'N',
    p_indi_vali_list_prec      varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_list_prec'))),
    p_codi_impu_ortr           varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_impu_ortr'))),
    --:parameter.p_indi_suge_exde          := 'S'; --Indicador para que sugiera descuento solo en la validacion de detalle
    -- p_indi_suge_exde varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_suge_exde'))),
    
    p_cant_deci_prec_unit_vent number := to_number(general_skn.fl_busca_parametro('p_cant_deci_prec_unit_vent')),
    p_cant_deci_porc           number := to_number(general_skn.fl_busca_parametro('p_cant_deci_porc')),
    p_cant_deci_cant           number := to_number(general_skn.fl_busca_parametro('p_cant_deci_cant')),
    p_indi_most_fopa           varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_fopa'))),
    p_indi_most_desc_ot        varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_desc_ot'))),
    p_emit_reci                varchar2(1) := 'E',
    p_indi_orte_vali           varchar2(1) := 'S',
    
    p_pres_nume              number := null,
    p_lv_prod_pres_clie      varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_lv_prod_pres_clie'))),
    p_lv_prod_pres_clie_pres varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_lv_prod_pres_clie_pres'))),
    p_indi_list_valo_exis    varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_list_valo_exis'))),
    p_indi_most_mens_sali    varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_sali'))),
    p_indi_most_mano_obra    varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mano_obra'))),
    p_indi_most_mens_aler    varchar2(5) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_aler'))),
    
    p_codi_tipo_empl_vend      number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_vend')),
    p_codi_empr                number := to_number(general_skn.fl_busca_parametro('p_codi_empr')),
    p_codi_mone_mmnn           number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_codi_mone_dola           number := to_number(general_skn.fl_busca_parametro('p_codi_mone_dola')),
    p_cant_deci_mmnn           number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_cant_deci_mmee           number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmee')),
    P_INDI_MOSTRAR_REC_PREC    varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('P_INDI_MOSTRAR_REC_PREC'))),
    p_indi_most_form_entr      varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_deto_cabe_deta'))), -- indica si el calculo de descuento se hara en cabecera o detalle
    p_indi_deto_cabe_deta      varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_deto_cabe_deta'))),
    p_form_cons_pres           varchar2(10) := general_skn.fl_busca_parametro('p_form_cons_pres'),
    p_codi_base                varchar2(10) := pack_repl.fa_devu_codi_base,
    p_indi_requ_auto_pedi      varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_requ_auto_pedi'))), -- Requiere Autorizacion de pedido
    p_peco_codi                number := 1, --:global.g_peco;
    p_form_abmc_clie_vtas      varchar2(50) := general_skn.fl_busca_parametro('p_form_abmc_clie_vtas'),
    p_indi_vali_prec_list_prec varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_prec_list_prec'))),
    p_indi_most_list_prec      varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_list_prec'))),
    p_indi_habi_ortr           varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_habi_ortr'))),
    p_perm_stoc_nega           varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_perm_stoc_nega'))),
    p_indi_busc_prod_cost_prec varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_busc_prod_cost_prec'))),
    
    p_indi_most_form_pago varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_form_pago'))),
    p_indi_obli_form_pago varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_obli_form_pago'))),
    
    p_indi_most_camp_tipo_pres varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_camp_tipo_pres'))),
    p_porc_util_mini_fact      number := to_number(general_skn.fl_busca_parametro('p_porc_util_mini_fact')),
    
    p_codi_peri_sgte      number := to_number(general_skn.fl_busca_parametro('p_codi_peri_sgte')),
    p_codi_form_pago_defa number := to_number(general_skn.fl_busca_parametro('p_codi_form_pago_defa')),
    
    p_repo_pres_clie      varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_repo_pres_clie'))),
    p_indi_perm_timo_bole varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_perm_timo_bole'))),
    p_codi_timo_pcoe      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_pcoe')),
    p_codi_timo_pcre      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_pcre')),
    
    p_codi_oper_vta            number := to_number(general_skn.fl_busca_parametro('p_codi_oper_vta')),
    p_indi_modi_prec_unit_pres varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_modi_prec_unit_pres'))),
    
    p_vali_deto_matr_prec varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_vali_deto_matr_prec'))),
    p_camb_prod_auto_fact varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_camb_prod_auto_fact'))),
    
    P_INDI_VALI_REPE_PROD_PRESU varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('P_INDI_VALI_REPE_PROD_PRESU'))),
    
    p_codi_clie_espo      varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_clie_espo'))),
    p_indi_obli_form_entr varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_obli_form_entr'))),
    p_indi_perm_modi_vend varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_perm_modi_vend'))),
    p_codi_oper           number := to_number(general_skn.fl_busca_parametro('p_codi_oper_vta')), --p_codi_oper_vta;
    
    p_presu_bloq_dato_clie varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_presu_bloq_dato_clie'))),
    
    p_codi_impu_exen   number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_codi_impu_grav5  number := to_number(general_skn.fl_busca_parametro('p_codi_impu_grav5')),
    p_codi_impu_grav10 number := to_number(general_skn.fl_busca_parametro('p_codi_impu_grav10')),
    
    p_cant_line_impr_pres  number := to_number(general_skn.fl_busca_parametro('p_cant_line_impr_pres')),
    p_indi_mens_vali       varchar(2) := 'S',
    p_indi_func_prog_presu varchar(2),
    p_mens_vali            varchar(2) := null,
    p_indi_suge_exde       varchar(2) := null,
    p_inve_codi            number,
    p_codi_clpo            number,
    p_clpr_codi            number,
    p_codi_secu            number,
    
    P_MAXI_LINE_IMPR_FACT number := to_number(general_skn.fl_busca_parametro('P_MAXI_LINE_IMPR_FACT')));
  parameter r_parameter;

  cursor detalle is
    select seq_id nro,
           C001   PROD_CODI_ALFA,
           C002   indi_prod_ortr,
           C003   dpre_prod_codi,
           C004   MEDI_DESC_ABRE,
           C005   dpre_indi_esta_conf,
           C006   s_dpre_indi_auto_conf,
           C007   dpre_indi_auto_conf,
           C008   dpre_medi_codi,
           C009   coba_codi_barr,
           C010   dpre_cant_medi,
           C011   dpre_prec_unit,
           C012   dpre_porc_deto,
           C013   s_total_item_deto,
           C014   dpre_prec_unit_deto,
           C015   dpre_prec_unit_reca,
           C016   s_total_item_reca,
           C017   dpre_prec_unit_list,
           C018   prod_maxi_porc_desc,
           C019   prod_desc,
           C020   dpre_lote_codi,
           C021   s_prec_maxi_deto,
           C022   dpre_prec_unit_neto,
           C023   lide_indi_vali_prec_mini,
           C024   lide_maxi_porc_deto,
           C025   dpre_obse,
           c026   DPRE_PORC_DETO_TOTA,
           C027   s_total_item,
           c028   auto_desc_prod,
           c029   s_dpre_indi_esta_conf,
           c030   dpre_porc_reca,
           c031   S_TOTAL_ITEM_MOST,
           c032   exde_tipo,
           c033   dpre_impu_codi,
           c034   coba_fact_conv,
           c036   CONC_DBCR
      from apex_collections
     where collection_name = 'BDET_DETALLE';

  procedure pp_obt_para is
  begin
    select distinct (conf_tipo)
      into parameter.p_indi_func_prog_presu
      from COME_CONF_REQU_PRES
     where conf_codi is not null;
  
  exception
    when no_data_found then
      parameter.p_indi_func_prog_presu := 'E'; --ltrim(rtrim(fl_busca_parametro('p_indi_func_prog_presu')));
    when too_many_rows then
      begin
        select distinct (conf_tipo)
          into parameter.p_indi_func_prog_presu
          from COME_CONF_REQU_PRES
         where conf_codi = 1;
      exception
        when no_data_found then
          pl_me('Debe configurar el Tipo de Validaci?n que tendra el Presupuesto!');
      end;
  end pp_obt_para;

  -- Private type declarations
  FUNCTION fp_exis_pres(p_pres_nume in number) RETURN boolean IS
    v_count number;
  BEGIN
    select count(a.pres_nume)
      into v_count
      from come_pres_clie a
     where a.pres_nume = p_pres_nume
       and nvl(a.pres_empr_codi, 1) = parameter.p_empr_codi;
  
    if v_count > 0 then
      return true;
    else
      return false;
    end if;
  END fp_exis_pres;

  procedure pp_validar_presupuesto(p_pres_nume        in number,
                                   p_pres_codi_a_modi out number) is
  
  begin
    select pres_codi
      into p_pres_codi_a_modi
      from come_pres_clie
     where pres_nume = p_pres_nume;
  
  exception
    when no_data_found then
      p_pres_codi_a_modi := -1;
    
  END pp_validar_presupuesto;

  procedure pp_mostrar_clpr_vali(p_clpr_codi in number,
                                 p_indi_vali in varchar2 default 'C') is
    v_clpr_esta           varchar(1);
    v_clpr_indi_inforconf varchar2(1);
  
  begin
    select clpr_esta,
           clpr_desc,
           clpr_codi,
           clpr_codi_alte,
           clpr_indi_vali_limi_cred,
           clpr_ruc,
           clpr_dire,
           clpr_tele,
           clpr_cli_situ_codi,
           nvl(clpr_indi_vali_situ_clie, 'S'),
           nvl(clpr_indi_exen, 'N'),
           nvl(clpr_indi_list_negr, 'N'),
           clpr_indi_exce,
           clpr_maxi_porc_deto,
           clpr_segm_codi,
           clpr_clie_clas1_codi,
           clpr_indi_inforconf,
           clpr_indi_vali_prec_mini,
           clpr_empl_codi
    
      into v_clpr_esta,
           bcab.pres_clpr_desc,
           bcab.pres_clpr_codi,
           bcab.clpr_codi_alte,
           bcab.clpr_indi_vali_limi_cred,
           bcab.pres_clpr_ruc,
           bcab.pres_clpr_dire,
           bcab.pres_clpr_tele,
           bcab.pres_clpr_cli_situ_codi,
           bcab.pres_clpr_indi_vali_situ_clie,
           bcab.clpr_indi_exen,
           bcab.pres_clpr_indi_list_negr,
           bcab.pres_clpr_indi_exce,
           bcab.clpr_maxi_porc_deto,
           bcab.clpr_segm_codi,
           bcab.clpr_clie_clas1_codi,
           v_clpr_indi_inforconf,
           bcab.clpr_indi_vali_prec_mini,
           bcab.clpr_agen_codi
      from come_clie_prov, come_orde_term
     where clpr_codi = p_clpr_codi
       and clpr_orte_codi = orte_codi(+)
       and clpr_indi_clie_prov = 'C';
  
    if v_clpr_esta = 'I' then
      pl_me('El cliente se encuentra Inactivo.');
    end if;
  
    if nvl(bcab.pres_tipo, 'A') <> 'P' then
      if bcab.pres_clpr_indi_list_negr = 'S' then
        if bcab.clpr_indi_exen <> 'S' then
          -- Si esta en Excepcion solo se advierte
          pl_me('Atencion, No se puede facturar al cliente!!! Se encuentra en Lista Negra.');
        
        end if;
      end if;
    
      if nvl(v_clpr_indi_inforconf, 'N') = 'S' then
        if bcab.clpr_indi_exen <> 'S' then
          -- Si esta en Excepcion solo se advierte
          parameter.p_indi_mens_vali := 'S';
          pl_me('Atencion, No se puede facturar al cliente!!! Se encuentra en Inforconf.');
        end if;
      end if;
    end if;
  
  exception
    when no_data_found then
      bcab.pres_clpr_desc                := null;
      bcab.pres_clpr_codi                := null;
      bcab.clpr_indi_vali_limi_cred      := null;
      bcab.pres_clpr_ruc                 := null;
      bcab.pres_clpr_dire                := null;
      bcab.pres_clpr_tele                := null;
      bcab.pres_clpr_cli_situ_codi       := null;
      bcab.pres_clpr_indi_vali_situ_clie := null;
      bcab.clpr_indi_exen                := null;
      bcab.pres_clpr_indi_list_negr      := null;
      bcab.pres_clpr_indi_exce           := null;
      bcab.clpr_maxi_porc_deto           := null;
      bcab.clpr_segm_codi                := null;
      bcab.clpr_clie_clas1_codi          := null;
      bcab.clpr_indi_vali_prec_mini      := null;
      bcab.clpr_agen_codi                := null;
    
      pl_me('Cliente inexistente!');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_deter_situ_clie(p_clpr_codi in number,
                               p_situ_actu in number) is
    v_dias_atra      number;
    v_situ_indi_auma varchar2(1);
    v_situ_indi_fact varchar2(1);
  
    v_situ_colo varchar2(1);
    v_situ_desc varchar2(60);
  
  begin
    --- primero determinamos si la situacion actual es o no manual
    if bcab.pres_clpr_cli_situ_codi is not null then
      begin
        select situ_indi_auma, situ_indi_fact, situ_colo, situ_desc
          into v_situ_indi_auma, v_situ_indi_fact, v_situ_colo, v_situ_desc
          from come_situ_clie
         where situ_codi = bcab.pres_clpr_cli_situ_codi;
      
      exception
        When others then
          v_situ_indi_auma := 'A';
          v_situ_indi_fact := null;
          v_situ_colo      := null;
          v_situ_desc      := null;
      end;
    else
      v_situ_indi_auma := 'A';
      v_situ_indi_fact := 'S';
      v_situ_colo      := null;
      v_situ_desc      := null;
    end if;
  
    if v_situ_indi_auma = 'A' then
      --si es automatico se realiza un refresh para determinar la situacion en el momento    
      v_dias_atra := fa_devu_dias_atra_clie(p_clpr_codi);
      begin
        select situ_colo, situ_indi_fact, situ_desc
          into v_situ_colo, v_situ_indi_fact, v_situ_desc
          from come_situ_clie
         where v_dias_atra between situ_dias_atra_desd and
               situ_dias_atra_hast;
      
      exception
        when no_data_found then
          pl_me('No existe ninguna siuacion para los dias de atraso');
          v_situ_colo      := 'B';
          v_situ_indi_fact := 'S';
          v_situ_desc      := ' ';
        when too_many_rows then
          parameter.p_indi_mens_vali := 'S';
          pl_me('Existe mas de una situacion de cliente que contiene ' ||
                v_dias_atra || ' dias de atraso dentro de su rango');
      end;
    end if;
  
    ---setear el color 
    if v_situ_colo = 'R' then
      --Rojo
      null;
      --set_item_property('bcab.clpr_codi_alte', current_record_attribute, 'visual_reg_rojo');
    elsif v_situ_colo = 'G' then
      null;
      --set_item_property('bcab.clpr_codi_alte', current_record_attribute, 'visual_reg_gris');
    elsif v_situ_colo = 'A' then
      --Amarillo
      null;
      -- set_item_property('bcab.clpr_codi_alte', current_record_attribute, 'visual_reg_amarillo');
    elsif v_situ_colo = 'B' then
      --Blanco
      null;
      --set_item_property('bcab.clpr_codi_alte', current_record_attribute, 'visual_reg_blanco');    
    elsif v_situ_colo = 'Z' then
      --azul
      null;
      -- set_item_property('bcab.clpr_codi_alte', current_record_attribute, 'visual_reg_azul');               
    elsif v_situ_colo = 'N' then
      --Naranja
      null;
      --set_item_property('bcab.clpr_codi_alte', current_record_attribute, 'visual_reg_naranja');                  
    else
      null;
      --  set_item_property('bcab.clpr_codi_alte', current_record_attribute, 'visual_reg_blanco');     
    end if;
    --synchronize;  
    -- 
    --mensaje de alerta!!
    if nvl(bcab.pres_clpr_indi_vali_situ_clie, 'S') = 'S' then
      if nvl(v_situ_indi_fact, 'N') = 'N' then
        if nvl(bcab.pres_clpr_indi_exce, 'N') = 'S' then
          -- Si esta en Excepcion solo se advierte
          pl_me('Atencion, El cliente se encuentra en la Situacion. ' ||
                v_situ_desc);
        else
          parameter.p_indi_mens_vali := 'S';
          pl_me('Atencion, No se puede facturar al cliente!!!, Se encuentra en la Situacion. ' ||
                v_situ_desc);
        end if;
      end if;
    end if;
  end;

  procedure pp_vali_tipo_movi(p_pres_timo_codi      in number,
                              p_pres_timo_dbcr      out varchar2,
                              p_pres_tica_codi      out number,
                              p_timo_indi_cont_cred out varchar2,
                              p_pres_afec_sald      out varchar2) is
  
    v_timo_calc_iva  varchar2(1);
    V_timo_indi_caja varchar2(2);
  
  begin
    select timo_dbcr,
           timo_tica_codi,
           timo_indi_cont_cred,
           timo_afec_sald,
           nvl(timo_calc_iva, 'N'),
           timo_indi_caja
      into p_pres_timo_dbcr,
           p_pres_tica_codi,
           p_timo_indi_cont_cred,
           p_pres_afec_sald,
           v_timo_calc_iva,
           V_timo_indi_caja
      from come_tipo_movi
     where timo_codi = p_pres_timo_codi
       and timo_codi_oper = parameter.p_codi_oper_vta;
    setitem('P135_S_TIMO_INDI_CAJA', V_timo_indi_caja);
  
    if nvl(upper(parameter.p_indi_perm_timo_bole), 'S') = 'N' then
      if v_timo_calc_iva <> 'S' then
        pl_me('No se permiten movimientos de Tipo Boleta.');
      end if;
    end if;
  
  exception
    when no_data_found then
      pl_me('Los tipos de movimientos deben ser de operaci?n Ventas!');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_veri_cheq_rech_clpr is
    v_cant number := 0;
  
  begin
    select count(*)
      into v_cant
      from come_cheq ch
     where ch.cheq_clpr_codi = bcab.pres_clpr_codi
       and (ch.cheq_esta = 'R' or ch.cheq_esta = 'J')
       and nvl(ch.cheq_sald_mone, ch.cheq_impo_mone) > 0;
  
    if v_cant > 0 then
      if nvl(bcab.pres_clpr_indi_exce, 'N') = 'S' then
        -- Si esta en Excepcion solo se advierte
        pl_me('El cliente posee Cheques Rechazados. Favor comuniquese con el Dpto. de Creditos!');
      else
        parameter.p_indi_mens_vali := 'S';
        pl_me('El cliente posee Cheques Rechazados. Favor comuniquese con el Dpto. de Creditos!');
      end if;
    end if;
  
  exception
    when no_data_found then
      null;
  end;
  procedure pp_veri_auto(p_veri in varchar2) is
    v_situ_colo      varchar2(1);
    v_situ_indi_fact varchar2(1);
    v_dias_atra      number;
    v_cant           number;
  
  begin
    if lower(p_veri) = 'lc' or lower(p_veri) = 't' then
      begin
        pa_devu_limi_cred_clie(bcab.pres_clpr_codi,
                               bcab.pres_mone_codi,
                               bcab.s_limi_cred_mone,
                               bcab.s_sald_clie_mone,
                               bcab.s_sald_limi_cred);
      
      exception
        when others then
          pl_me(sqlerrm);
      end;
    
      if /*:bdet*/
       bcab.sum_s_total_item_most > bcab.s_sald_limi_cred then
        bcab.pres_auto_limi_cred := 'N';
      end if;
    end if;
  
    ---------------*-*-*-
    pa_devu_limi_cred_espe(bcab.pres_clpr_codi,
                           bcab.pres_mone_codi,
                           bcab.s_cred_espe_mone);
    ---------------*-*-*-
    pa_devu_pedi_conf(bcab.pres_clpr_codi,
                      bcab.pres_mone_codi,
                      bcab.s_pres_impo_deto);
    ---------------*-*-*-
  
    if lower(p_veri) = 'sc' or lower(p_veri) = 't' then
      v_dias_atra := fa_devu_dias_atra_clie(bcab.pres_clpr_codi);
      begin
        select s.situ_colo, s.situ_indi_fact
          into v_situ_colo, v_situ_indi_fact
          from come_situ_clie s
         where v_dias_atra between s.situ_dias_atra_desd and
               s.situ_dias_atra_hast
           and nvl(s.situ_empr_codi, 1) = parameter.p_empr_codi;
      exception
        when no_data_found then
          --pl_mm('No existe ninguna siuacion para los dias d atraso');
          --v_situ_colo      := 'B';
          v_situ_indi_fact := 'S';
      end;
    
      if nvl(v_situ_indi_fact, 'N') = 'N' then
        bcab.pres_auto_situ_clie := 'N';
      end if;
    end if;
  
    if lower(p_veri) = 'cr' or lower(p_veri) = 't' then
      begin
        select count(*)
          into v_cant
          from come_cheq ch
         where ch.cheq_clpr_codi = bcab.pres_clpr_codi
           and (ch.cheq_esta = 'R' or ch.cheq_esta = 'J')
           and nvl(ch.cheq_sald_mone, ch.cheq_impo_mone) > 0;
      exception
        when others then
          v_cant := 0;
      end;
    
      if v_cant > 0 then
        bcab.pres_auto_cheq_rech := 'N';
      end if;
    end if;
  
    if lower(p_veri) = 'dp' or lower(p_veri) = 't' then
    
      for bdet in detalle loop
        if nvl(bdet.auto_desc_prod, 'S') = 'N' then
          bcab.pres_auto_desc_prod := 'N';
          exit;
        end if;
      end loop;
    
    end if;
  end;
  procedure pp_cargar_orte_vali is
    v_list_codi number;
  
  begin
  
    select a.orte_desc,
           a.orte_maxi_porc,
           a.orte_cant_cuot,
           a.orte_list_codi,
           nvl(a.orte_porc_entr, 0),
           nvl(a.orte_impo_cuot, 0),
           a.orte_dias_cuot
      into bcab.s_orte_desc,
           bcab.s_orte_maxi_porc,
           bcab.s_orte_cant_cuot,
           v_list_codi,
           bcab.s_orte_porc_entr,
           bcab.s_orte_impo_cuot,
           bcab.s_orte_dias_cuot
      from come_orde_term a
     where a.orte_codi = bcab.pres_orte_codi
       and ((nvl(a.orte_indi_most_fopa, 'S') = 'S' and
           parameter.p_indi_most_fopa = 'S') or
           parameter.p_indi_most_fopa = 'N' or
           a.orte_codi = bcab.clpr_orte_codi);
  
    if nvl(bcab.pres_codi_a_modi, -1) = -1 then
      if v_list_codi is not null and bcab.clpr_list_codi is null then
        bcab.pres_list_prec := v_list_codi;
        bcab.orte_list_codi := bcab.pres_list_prec;
      else
        bcab.orte_list_codi := null;
      end if;
    end if;
  
    if nvl(bcab.s_timo_indi_caja, 'N') = 'N' and
       nvl(bcab.s_orte_cant_cuot, 0) <= 0 then
      parameter.p_indi_orte_vali := 'N';
      pl_me('Para movimientos Credito solo puede seleccionar ' ||
            'formas de pago cuya cantidad de cuotas sea mayor a 0 (cero).');
    end if;
  
    /*if p_pres_orte_codi <> nvl(p_pres_orte_codi_ante, -99) then
      :parameter.p_indi_cuot_entr := 'N';
    end if;*/
  exception
    when no_data_found then
      bcab.pres_orte_codi   := null;
      bcab.s_orte_desc      := null;
      bcab.s_orte_maxi_porc := null;
      bcab.s_orte_cant_cuot := null;
      bcab.s_orte_porc_entr := null;
      bcab.s_orte_impo_cuot := null;
    
      parameter.p_indi_orte_vali := 'N';
      if nvl(parameter.p_indi_cons_pres, 'N') = 'N' then
        pl_me('Forma de Pago inexistente,no habilitado para visualizar o no pertenece al cliente. Favor verificar.');
      else
        pl_me('Forma de Pago inexistente,no habilitado para visualizar o no pertenece al cliente. Favor verificar.');
      end if;
    
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_vali_orte_matr_prec is
    --valida lista de precio,segmento,forma de pago
    v_cant number := 0;
  
  begin
    select count(*)
      into v_cant
      from come_orde_term a, come_matr_prec m
     where a.orte_codi = m.mapr_orte_codi
       and m.mapr_segm_codi = bcab.clpr_segm_codi
       and m.mapr_list_codi = bcab.pres_list_prec
       and a.orte_codi = bcab.pres_orte_codi;
  
    if v_cant = 0 then
      pl_me('Forma de Pago no pertenece al Segmento/Lista de Precio. Favor verificar.');
    end if;
  end;
  PROCEDURE pp_trae_form_entr IS
  BEGIN
  
    select entr_desc
      into bcab.s_form_entr_desc
      from come_form_entr_fact
     where entr_codi = bcab.pres_form_entr_codi;
  
  Exception
    When no_data_found then
      pl_me('Forma de entrega inexistente.');
    
    when others then
      pl_me(sqlerrm);
    
  END;

  procedure pp_carga_limi_cred(p_clpr_codi      in number,
                               p_mone_tasa      in number,
                               p_limi_cred_mone out number) is
  
    v_limi_cred_gs number := 0;
    v_limi_cred_us number := 0;
    v_limi_cred_eu number := 0;
    v_limi_cred    number := 0;
  
    cursor c_limi_cred is
      select cpmo_limi_cred_mone, cpmo_mone_codi
        from come_clie_prov_mone
       where cpmo_clpr_codi = p_clpr_codi;
  
  begin
  
    pl_me('we thi love the photografe');
    for x in c_limi_cred loop
      if x.cpmo_mone_codi = parameter.p_codi_mone_mmnn then
        v_limi_cred_gs := x.cpmo_limi_cred_mone;
      end if;
    
      if x.cpmo_mone_codi = parameter.p_codi_mone_dola then
        v_limi_cred_us := x.cpmo_limi_cred_mone;
      end if;
    
      if x.cpmo_mone_codi = 4 then
        v_limi_cred_eu := x.cpmo_limi_cred_mone;
      end if;
    
    end loop;
  
    if bcab.pres_mone_codi = parameter.p_codi_mone_mmnn then
      v_limi_cred := v_limi_cred_gs +
                     round((v_limi_cred_us + v_limi_cred_eu * p_mone_tasa),
                           0);
    end if;
  
    if bcab.pres_mone_codi = parameter.p_codi_mone_dola then
      v_limi_cred := round(v_limi_cred_gs / p_mone_tasa,
                           bcab.pres_mone_cant_deci) + v_limi_cred_us +
                     v_limi_cred_eu;
    end if;
  
    if bcab.pres_mone_codi = 4 then
      v_limi_cred := round(v_limi_cred_gs / p_mone_tasa,
                           bcab.pres_mone_cant_deci) + v_limi_cred_us +
                     v_limi_cred_eu;
    end if;
  
    p_limi_cred_mone := v_limi_cred;
  
  Exception
    When no_data_found then
      p_limi_cred_mone := 0;
    When others then
      p_limi_cred_mone := 0;
  end;
  procedure pp_validar_cabecera is
  
    v_sald_limi_cred number;
  
  begin
  
    pp_mostrar_clpr_vali(bcab.clpr_codi);
    pp_obt_para;
    if nvl(parameter.p_indi_func_prog_presu, 'E') = 'E' and
       nvl(bcab.pres_tipo, 'A') <> 'P' then
      pp_deter_situ_clie(bcab.pres_clpr_codi, bcab.pres_clpr_cli_situ_codi);
      pp_veri_cheq_rech_clpr;
    end if;
  
    pp_veri_auto('t');
  
    if bcab.pres_orte_codi is not null then
      pp_cargar_orte_vali;
      if nvl(upper(parameter.p_vali_deto_matr_prec), 'N') = 'S' then
        pp_vali_orte_matr_prec;
      end if;
    else
      if parameter.p_indi_obli_form_pago = 'S' then
        pl_me('Debe indicar una forma de pago.');
      else
        bcab.pres_orte_codi   := null;
        bcab.s_orte_desc      := null;
        bcab.s_orte_maxi_porc := null;
        bcab.s_orte_cant_cuot := null;
        bcab.s_orte_porc_entr := null;
        bcab.s_orte_impo_cuot := null;
      end if;
    end if;
  
    if bcab.pres_form_entr_codi is not null then
      pp_trae_form_entr;
    else
      if parameter.p_indi_obli_form_entr = 'S' then
        if nvl(parameter.p_indi_cons_pres, 'N') = 'N' then
          pl_me('Debe ingresar una forma de entrega.');
        else
          pl_me('Debe ingresar una forma de entrega.');
        end if;
      end if;
    end if;
  
    if nvl(bcab.pres_afec_sald, 'N') = 'C' then
      -- si es Credito
    
      if nvl(bcab.timo_indi_cont_cred, 'CO') = 'CR' then
        pp_carga_limi_cred(bcab.pres_clpr_codi,
                           bcab.pres_tasa_mone,
                           bcab.s_limi_cred_mone);
        pp_carga_sald_clie(bcab.pres_clpr_codi,
                           bcab.pres_tasa_mone,
                           bcab.s_sald_clie_mone);
      end if;
    
      v_sald_limi_cred := nvl(bcab.s_limi_cred_mone, 0) +
                          nvl(bcab.s_cred_espe_mone, 0) -
                          nvl(bcab.s_sald_clie_mone, 0) -
                          nvl(bcab.s_pres_impo_deto, 0);
      pp_obt_para;
      if nvl(parameter.p_indi_func_prog_presu, 'E') = 'E' and
         nvl(bcab.pres_tipo, 'A') <> 'P' then
        if nvl(bcab.s_total, 0) >
           nvl(v_sald_limi_cred /*p_s_sald_limi_cred*/, 0) then
          parameter.p_mens_vali := parameter.p_mens_vali ||
                                   'El importe de la factura supera la linea de credito asignada al cliente, Favor comunicarse con el Dpto. de Creditosj' ||
                                   chr(10);
          pl_me('El importe de la factura supera la linea de credito asignada al cliente. Favor comunicarse con el Dpto. de Creditos');
        end if;
      end if;
    
    end if;
  
    if bcab.s_total_bruto <= 0 then
      pl_me('Atenci?n!!!!!.. Debe ingresar los totales');
    end if;
  
    if bcab.indi_mano_obra = 'S' then
      if bcab.pres_desc_mano_obra is null then
        pl_me('Debe ingresar la descripcion de la Mano de Obra..');
      end if;
    end if;
  
  end;

  procedure pp_carga_sald_clie(p_clpr_codi      in number,
                               p_mone_tasa      in number,
                               p_sald_clie_mone out number) is
  begin
    select round(nvl(((sum(decode(tm.timo_dbcr,
                                  'D',
                                  c.cuot_sald_mmnn,
                                  -c.cuot_sald_mmnn))) / p_mone_tasa),
                     0),
                 bcab.pres_mone_cant_deci) Saldo
      into p_sald_clie_mone
      from come_movi m, come_movi_cuot c, come_tipo_movi tm
     where m.movi_codi = c.cuot_movi_codi
       and m.movi_timo_codi = tm.timo_codi
       and m.movi_clpr_codi = p_clpr_codi;
  
  Exception
    When no_data_found then
      p_sald_clie_mone := 0;
    When others then
      p_sald_clie_mone := 0;
  end;

  PROCEDURE pp_trae_list_prec(p_pres_list_prec in number,
                              p_S_DESC_LIPR    out varchar2) IS
  BEGIN
    select list_desc
      into p_S_DESC_LIPR
      from come_list_prec
     where list_codi = p_pres_list_prec;
  exception
    when no_data_found then
      pl_me('La lista de precio es inexistente. Favor verificar');
  END pp_trae_list_prec;

  procedure pp_trae_form_pago(p_orte_codi           in number,
                              p_clpr_segm_codi      in number,
                              p_pres_orte_codi      in number,
                              p_pres_orte_codi_clpr in out number,
                              p_pres_list_prec      in out number,
                              p_s_orte_desc         out varchar2,
                              p_s_orte_maxi_porc    out number,
                              p_S_DESC_LIPR         out varchar2) is
    v_cant_cuot number;
    v_list_codi number;
  begin
  
    if nvl(upper(parameter.p_vali_deto_matr_prec), 'N') = 'S' then
      begin
        select a.orte_desc,
               a.orte_maxi_porc,
               a.orte_cant_cuot,
               a.orte_list_codi
          into p_s_orte_desc, p_s_orte_maxi_porc, v_cant_cuot, v_list_codi
          from come_orde_term a, come_matr_prec m
         where a.orte_codi = m.mapr_orte_codi
           and m.mapr_segm_codi = p_clpr_segm_codi
           and m.mapr_list_codi = p_pres_list_prec
           and a.orte_codi = nvl(p_pres_orte_codi, p_pres_orte_codi_clpr);
      
        -- Primero ve si ya se cargo lista de precio de la ficha del cliente, en caso que no, carga la 
        --lista de precio de la forma de pago.
        if nvl(p_pres_orte_codi_clpr, -99) <> p_pres_orte_codi then
          if v_list_codi is not null then
            p_pres_list_prec := v_list_codi;
          end if;
        end if;
        if p_pres_list_prec is not null then
          pp_trae_list_prec(p_pres_list_prec, p_S_DESC_LIPR);
        end if;
      
      exception
        when no_data_found then
          pl_me('Forma de Pago inexistente o no pertenece al Segmento/Lista de Precio. Favor verificar');
        when others then
          pl_me(sqlerrm);
      end;
    
    else
      begin
        select a.orte_desc,
               a.orte_maxi_porc,
               a.orte_cant_cuot,
               a.orte_list_codi
          into p_s_orte_desc, p_s_orte_maxi_porc, v_cant_cuot, v_list_codi
          from come_orde_term a
         where a.orte_codi = p_orte_codi;
      
        -- Primero ve si ya se cargo lista de precio de la ficha del cliente, en caso que no, carga la 
        --lista de precio de la forma de pago.
        if p_pres_orte_codi <> nvl(p_pres_orte_codi_clpr, -99) then
          p_pres_orte_codi_clpr := null;
          if v_list_codi is not null then
            p_pres_list_prec := v_list_codi;
          end if;
        end if;
        if p_pres_list_prec is not null then
          pp_trae_list_prec(p_pres_list_prec, p_S_DESC_LIPR);
        end if;
      
      exception
        when no_data_found then
          pl_me('Forma de Pago inexistente. Favor verificar');
        when others then
          pl_me(sqlerrm);
      end;
    end if;
  end pp_trae_form_pago;

  procedure pp_busca_nume_movi(p_pres_codi            in number,
                               p_pres_nume            out number,
                               p_pres_numep_pres_nume out number,
                               p_nume_pres_ante       out number) is
  
    v_nume      number := p_pres_nume;
    v_nume_ante number := p_pres_nume;
    v_cant      number;
  begin
  
    p_pres_nume := v_nume;
  
    loop
      select count(*)
        into v_cant
        from come_pres_clie c
       where pres_nume = v_nume
         and pres_codi <> p_pres_codi
         and c.pres_empr_codi = parameter.p_empr_codi;
    
      if v_cant > 0 then
        v_nume := v_nume + 1;
      else
        exit;
      end if;
    end loop;
  
    if v_nume_ante <> v_nume then
      p_nume_pres_ante := p_pres_nume;
      p_pres_nume      := v_nume;
    end if;
  
  exception
    when others then
      pl_me(sqlerrm);
  end pp_busca_nume_movi;

  procedure pp_veri_exis_inve(p_clpr_codi   in varchar2,
                              p_inve_codi   out number,
                              p_s_avis_inve out varchar2) is
  
  begin
    select inve_codi
      into p_inve_codi
      from come_inte_vent
     where inve_codi_clpo = p_clpr_codi
       and (inve_esta = 'P' or inve_esta = 'C');
  
    if p_inve_codi is not null then
      /*if get_item_property('bcab.s_avis_inve', visible) = 'FALSE' then
        set_item_property('bcab.s_avis_inve', visible, property_true);
      end if;*/
      --  set_item_property('bcab.s_avis_inve', current_record_attribute, 'visual_reg_amarillo');
      p_s_avis_inve := 'El Cliente posee una Intenci?n de Venta Pendiente o Cerrada!!!';
    end if;
  
  Exception
    when no_data_found then
      p_inve_codi := null;
  end pp_veri_exis_inve;

  procedure pp_muestra_clpr_agen(p_clpr_agen_codi      in number,
                                 p_clpr_agen_codi_alte out varchar2,
                                 p_clpr_agen_desc      out varchar2) is
  begin
  
    select empl_desc, empl_codi_alte
      into p_clpr_agen_desc, p_clpr_agen_codi_alte
      from come_empl
     where empl_codi = p_clpr_agen_codi;
  
  exception
    when no_data_found then
      p_clpr_agen_desc      := 'No tiene agente asignado.';
      p_clpr_agen_codi_alte := null;
    when others then
      pl_me(sqlerrm);
  end pp_muestra_clpr_agen;

  procedure pp_muestra_empl_vent_comp(p_empl_codi_alte      out number,
                                      p_empl_desc_vent_comp out varchar2,
                                      p_pres_indi_vent_comp out varchar2) is
  
  begin
    select e.empl_codi_alte, empl_desc
      into p_empl_codi_alte, p_empl_desc_vent_comp
      from come_empl e, segu_user u
     where u.user_login = gen_user
       and e.empl_codi = u.user_empl_codi;
  
    p_pres_indi_vent_comp := 'S';
  
  exception
    when no_data_found then
      p_empl_codi_alte      := null;
      p_empl_desc_vent_comp := null;
      p_pres_indi_vent_comp := 'N';
    
    when others then
      pl_me(sqlerrm);
  end pp_muestra_empl_vent_comp;

  Procedure pp_mostrar_clpr(p_clpr_codi                in number,
                            p_pres_codi_a_modi         in number,
                            p_s_timo_indi_caja         in varchar2,
                            p_pres_tipo                in varchar2,
                            p_pres_clpr_desc           out varchar2,
                            p_clpr_indi_vali_limi_cred out varchar2,
                            p_pres_clpr_ruc            out varchar2,
                            p_pres_clpr_dire           out varchar2,
                            p_pres_clpr_tele           out varchar2,
                            p_pres_clpr_cli_situ_codi  out varchar2,
                            p_clpr_indi_vali_situ_clie out varchar2,
                            p_clpr_indi_exen           out varchar2,
                            p_pres_clpr_indi_list_negr out varchar2,
                            p_pres_clpr_indi_exce      out varchar2,
                            p_clpr_maxi_porc_deto      out varchar2,
                            p_clpr_segm_codi           out varchar2,
                            p_clpr_list_codi           out varchar2,
                            p_clpr_clie_clas1_codi     out varchar2,
                            p_clpr_orte_codi           out varchar2,
                            p_clpr_indi_vali_prec_mini out varchar2,
                            p_pres_orte_codi           out varchar2,
                            p_clpr_codi_pres           in out varchar2,
                            p_pres_list_prec           out varchar2,
                            p_pres_clpr_sres           out varchar2,
                            p_clpr_agen_codi           out varchar2) is
    v_clpr_esta           varchar(1);
    v_clpr_indi_inforconf varchar2(1);
    v_cant_cuot           number;
    v_pres_clpr_sres      varchar2(80);
  
  begin
    select clpr_esta,
           clpr_desc,
           clpr_desc,
           clpr_indi_vali_limi_cred,
           clpr_ruc,
           clpr_dire,
           clpr_tele,
           clpr_cli_situ_codi,
           nvl(clpr_indi_vali_situ_clie, 'S'),
           nvl(clpr_indi_exen, 'N'),
           nvl(clpr_indi_list_negr, 'N'),
           clpr_indi_exce,
           clpr_maxi_porc_deto,
           clpr_segm_codi,
           clpr_list_codi,
           clpr_clie_clas1_codi,
           clpr_orte_codi,
           clpr_indi_inforconf,
           clpr_indi_vali_prec_mini,
           clpr_empl_codi,
           orte_cant_cuot
    
      into v_clpr_esta,
           p_pres_clpr_desc,
           v_pres_clpr_sres,
           p_clpr_indi_vali_limi_cred,
           p_pres_clpr_ruc,
           p_pres_clpr_dire,
           p_pres_clpr_tele,
           p_pres_clpr_cli_situ_codi,
           p_clpr_indi_vali_situ_clie,
           p_clpr_indi_exen,
           p_pres_clpr_indi_list_negr,
           p_pres_clpr_indi_exce,
           p_clpr_maxi_porc_deto,
           p_clpr_segm_codi,
           p_clpr_list_codi,
           p_clpr_clie_clas1_codi,
           p_clpr_orte_codi,
           v_clpr_indi_inforconf,
           p_clpr_indi_vali_prec_mini,
           p_clpr_agen_codi,
           v_cant_cuot
      from come_clie_prov, come_orde_term
     where clpr_codi = p_clpr_codi
       and clpr_orte_codi = orte_codi(+)
       and clpr_indi_clie_prov = 'C';
  
    if v_clpr_esta = 'I' then
      pl_me('El cliente se encuentra Inactivo.');
    end if;
  
    if nvl(p_pres_codi_a_modi, -1) = -1 or p_clpr_codi <> p_clpr_codi_pres or
       nvl(parameter.p_indi_orte_vali, 'S') = 'N' then
      if p_clpr_orte_codi is not null then
        --En caso de volver a recorrer,que no recargue nulo
        if nvl(p_s_timo_indi_caja, 'N') = 'N' and nvl(v_cant_cuot, 0) <= 0 then
          --:parameter.p_indi_mens_vali := 'S';
          pl_me('Para movimientos Credito solo puede seleccionar ' ||
                'formas de pago cuya cantidad de cuotas sea mayor a 0 (cero).');
        else
        
          p_clpr_codi_pres := p_clpr_codi;
          p_pres_orte_codi := p_clpr_orte_codi;
        end if;
      end if;
      if p_clpr_list_codi is not null then
      
        p_pres_list_prec := p_clpr_list_codi;
      end if;
    end if;
  
    if nvl(p_pres_tipo, 'A') <> 'P' then
      if p_pres_clpr_indi_list_negr = 'S' then
        if p_clpr_indi_exen = 'S' then
          -- Si esta en Excepcion solo se advierte
          --pl_mm('Atencion, El cliente se encuentra en Lista Negra.');
          null;
        else
          --:parameter.p_indi_mens_vali := 'S';
          pl_me('Atencion, No se puede facturar al cliente!!! Se encuentra en Lista Negra.');
        end if;
      end if;
    
      if nvl(v_clpr_indi_inforconf, 'N') = 'S' then
        if p_clpr_indi_exen = 'S' then
          -- Si esta en Excepcion solo se advierte
          null;
          -- pl_mm('Atencion, El cliente se encuentra en Inforconf.');
        else
          pl_me('Atencion, No se puede facturar al cliente!!! Se encuentra en Inforconf.');
        end if;
      end if;
    end if;
  
    if parameter.p_indi_cons_pres <> 'S' then
      p_pres_clpr_sres := v_pres_clpr_sres;
    end if;
  
  exception
    when no_data_found then
      p_pres_clpr_desc           := null;
      p_clpr_indi_vali_limi_cred := null;
      p_pres_clpr_ruc            := null;
      p_pres_clpr_dire           := null;
      p_pres_clpr_tele           := null;
      p_pres_clpr_cli_situ_codi  := null;
      p_clpr_indi_vali_situ_clie := null;
      p_clpr_indi_exen           := null;
      p_pres_clpr_indi_list_negr := null;
      p_pres_clpr_indi_exce      := null;
      p_clpr_maxi_porc_deto      := null;
      p_clpr_segm_codi           := null;
      p_clpr_list_codi           := null;
      p_clpr_clie_clas1_codi     := null;
      p_pres_orte_codi           := null;
      p_clpr_indi_vali_prec_mini := null;
      p_pres_clpr_sres           := null;
      ---:parameter.p_indi_mens_vali := 'S';
    -- pl_me('Cliente inexistente!');
    when others then
      pl_me(sqlerrm);
  end pp_mostrar_clpr;

  procedure pp_actu_secu(p_secu_codi in number) is
  begin
  
    update come_secu
       set secu_nume_pres_clie = bcab.pres_nume
     where secu_codi = p_secu_codi;
  
  exception
    when others then
      pl_me(sqlerrm);
    
  end pp_actu_secu;

  procedure pp_actualizar_registro is
  
    salir exception;
  begin
  
    pp_set_variable;
  
    begin
      -- Call the procedure
      I020117.pp_validaciones;
    end;
    --pl_me('who says');
  
    if nvl(bcab.pres_codi_a_modi, -1) <> -1 then
      bcab.pres_codi := bcab.pres_codi_a_modi;
    else
    
      --  if bcab.pres_codi is not null then
      I020117.pp_busca_nume_movi(p_pres_codi            => bcab.pres_codi,
                                 p_pres_nume            => bcab.pres_nume,
                                 p_pres_numep_pres_nume => bcab.pres_numep_pres_nume,
                                 p_nume_pres_ante       => bcab.nume_pres_ante);
      --  end if;
    
      pp_actu_secu(parameter.p_peco_codi);
    end if;
  
    pp_actu_inve_clpo;
    pp_actu_pres_clie_pack(bcab.pres_codi);
  
    if bcab.pres_tipo = 'A' then
      if nvl(parameter.p_indi_func_prog_presu, 'S') = 'S' then
        if parameter.p_indi_requ_auto_pedi = 'S' then
          parameter.p_mens_vali := parameter.p_mens_vali || ' ' ||
                                   ' -"Se Requiere de una Autorizacion".';
        end if;
      end if;
    end if;
  
    if parameter.p_mens_vali is not null then
      PP_ACTU_MOTI_PRES;
      PA_GENE_MENS_AUTO_PRES(bcab.pres_codi);
    end if;
  
    --commit_form;    
  
    /*if not form_success then
       go_block('bcab');
       clear_form(no_validate, full_rollback);
       message('Registro no actualizado.'); message('Registro no actualizado.');bell;bell;
    else
      if :parameter.p_mens_vali is not null then
        pl_mm(:parameter.p_mens_vali);
      end if;
      if :parameter.p_nume_pres_ante <> :bcab.pres_nume then
        pl_mm('El presupuesto numero '||:parameter.p_nume_pres_ante||' ya ha sido guardado previamente.'||chr(10)||
            'Este presupuesto se guardo con el numero '||:bcab.pres_nume||'.');
      end if;
      :parameter.p_mens_vali := null;
       pp_llama_reporte;
       message('Registro actualizado.'); bell;
      clear_form(no_validate, full_rollback);
    end if;*/
  
  Exception
    when salir then
      null;
  end pp_actualizar_registro;

  procedure pp_actu_inve_clpo is
  begin
    if parameter.p_inve_codi is not null and
       bcab.pres_inve_codi is not null then
      update come_inte_vent
         set inve_esta = 'C'
       where inve_codi = parameter.p_inve_codi;
    end if;
  
    if parameter.p_codi_clpo is not null and
       (parameter.p_clpr_codi = bcab.pres_clpr_codi) then
      update come_clie_pote
         set clpo_esta = 'F'
       where clpo_codi = parameter.p_codi_clpo;
    
      update come_para
         set para_valo = bcab.clpr_codi_alte
       where ltrim(rtrim(upper(para_nomb))) = upper('p_secu_nume_clie');
    end if;
  end pp_actu_inve_clpo;

  procedure pp_actu_pres_clie_pack(p_pres_codi out number) is
  
    ta_pedi      pack_app.tt_pres;
    ta_pedi_deta pack_app.tt_pres_deta;
  
    v_idx  number;
    v_cant number := 0;
  
    v_codResp  number;
    v_descResp varchar2(500);
  
  begin
  
    ta_pedi(1).pres_codi := bcab.pres_codi;
    ta_pedi(1).pres_nume := bcab.pres_nume;
    ta_pedi(1).pres_fech_emis := bcab.pres_fech_emis;
    ta_pedi(1).pres_clpr_codi := bcab.pres_clpr_codi;
    ta_pedi(1).pres_empl_codi := bcab.pres_empl_codi;
    ta_pedi(1).pres_mone_codi := bcab.pres_mone_codi;
    ta_pedi(1).pres_user := gen_user;
    ta_pedi(1).pres_fech_grab := sysdate;
    ta_pedi(1).pres_grav_mone := 0;
    ta_pedi(1).pres_exen_mone := 0;
    ta_pedi(1).pres_iva_mone := 0;
    ta_pedi(1).pres_indi_iva_incl := null;
    ta_pedi(1).pres_timo_codi := bcab.pres_timo_codi;
    ta_pedi(1).pres_tasa_mone := bcab.pres_tasa_mone;
    ta_pedi(1).pres_vali := null;
    ta_pedi(1).pres_movi_codi := null;
    ta_pedi(1).pres_base := parameter.p_codi_base;
    ta_pedi(1).pres_clpr_cont := bcab.pres_clpr_cont;
    ta_pedi(1).pres_clpr_sres := bcab.pres_clpr_sres;
    ta_pedi(1).pres_clpr_ruc := bcab.pres_clpr_ruc;
    ta_pedi(1).pres_vali_ofer := bcab.pres_vali_ofer;
    ta_pedi(1).pres_plaz_entr := bcab.pres_plaz_entr;
    ta_pedi(1).pres_clpr_tele := bcab.pres_clpr_tele;
    ta_pedi(1).pres_cond_vent := bcab.pres_cond_vent;
    ta_pedi(1).pres_obse := bcab.pres_obse;
    ta_pedi(1).pres_clpr_dire := bcab.pres_clpr_dire;
    ta_pedi(1).pres_clpr_desc := bcab.pres_clpr_desc;
    ta_pedi(1).pres_porc_deto := bcab.pres_porc_deto;
    ta_pedi(1).pres_desc_mano_obra := bcab.pres_desc_mano_obra;
    ta_pedi(1).pres_impo_mano_obra := bcab.pres_impo_mano_obra;
    ta_pedi(1).pres_impo_mano_obra_deto := bcab.pres_impo_mano_obra_deto;
    ta_pedi(1).pres_porc_reca := bcab.pres_porc_reca;
    ta_pedi(1).pres_impo_mano_obra_reca := bcab.pres_impo_mano_obra_reca;
    ta_pedi(1).pres_tipo_pres := 'C';
    ta_pedi(1).pres_seri := null;
    ta_pedi(1).pres_refe := bcab.pres_refe;
    ta_pedi(1).pres_obra := null;
    ta_pedi(1).pres_nume_char := bcab.pres_nume || '/' ||
                                 to_char(bcab.pres_fech_emis, 'yy');
    ta_pedi(1).pres_indi_adic := null;
    ta_pedi(1).pres_firm := null;
    ta_pedi(1).pres_firm_baut := null;
    ta_pedi(1).pres_clpr_mail := null;
    ta_pedi(1).pres_resp_codi := null;
    ta_pedi(1).pres_impo_deto := bcab.s_total;
    ta_pedi(1).pres_espr_codi := null;
    ta_pedi(1).pres_esta_pres := 'P';
    ta_pedi(1).pres_logi_auto := null;
    ta_pedi(1).pres_fech_auto := null;
    ta_pedi(1).pres_list_prec := bcab.pres_list_prec;
    ta_pedi(1).pres_form_entr_codi := bcab.pres_form_entr_codi;
    ta_pedi(1).pres_orte_codi := bcab.pres_orte_codi;
    ta_pedi(1).pres_tipo := nvl(bcab.pres_tipo, 'A');
    ta_pedi(1).pres_depo_codi := bcab.pres_depo_codi;
    ta_pedi(1).pres_indi_user_deto := bcab.user_indi_real_deto_sin_exce;
    ta_pedi(1).pres_obse_rech := null;
    ta_pedi(1).pres_empr_codi := nvl(parameter.p_empr_codi, 1);
    ta_pedi(1).pres_clpr_sucu_nume_item := bcab.sucu_nume_item;
    ta_pedi(1).pres_indi_app_movil := null;
    ta_pedi(1).pres_clpr_codi_orig := null;
    ta_pedi(1).pres_clpr_sucu_nume_item_orig := null;
    ta_pedi(1).pres_inve_codi := nvl(parameter.p_inve_codi,
                                     bcab.pres_inve_codi);
    ta_pedi(1).pres_auto_limi_cred := nvl(bcab.pres_auto_limi_cred, 'S');
    ta_pedi(1).pres_auto_situ_clie := nvl(bcab.pres_auto_situ_clie, 'S');
    ta_pedi(1).pres_auto_cheq_rech := nvl(bcab.pres_auto_cheq_rech, 'S');
    ta_pedi(1).pres_auto_desc_prod := nvl(bcab.pres_auto_desc_prod, 'S');
    ta_pedi(1).pres_auto_anal_cred := 'N';
    ta_pedi(1).pres_auto_supe_vent := 'N';
    ta_pedi(1).pres_auto_gere_gene := 'N';
    ta_pedi(1).pres_moti_limi_cred := null;
    ta_pedi(1).pres_moti_situ_clie := null;
    ta_pedi(1).pres_moti_cheq_rech := null;
    ta_pedi(1).pres_moti_desc_prod := null;
    ta_pedi(1).pres_moti_anal_cred := null;
    ta_pedi(1).pres_moti_supe_vent := null;
    ta_pedi(1).pres_moti_gere_gene := null;
    ta_pedi(1).pres_indi_impr_auto := null;
    ta_pedi(1).pres_indi_code := null;
    if parameter.p_indi_most_vent_comp_pres = 'S' then
      ta_pedi(1).pres_indi_vent_comp := nvl(bcab.pres_indi_vent_comp, 'N');
      ta_pedi(1).pres_empl_codi_vent_comp := bcab.pres_empl_codi_vent_comp;
    else
      ta_pedi(1).pres_indi_vent_comp := null;
      ta_pedi(1).pres_empl_codi_vent_comp := null;
    end if;
    ta_pedi(1).pres_indi_tipo_vali_pres := nvl(parameter.p_indi_func_prog_presu,
                                               'E');
    ta_pedi(1).pres_fech_conf := null;
  
    --go_block('bdet');
    --first_record;
  
    v_idx := 0;
    for bdet in detalle loop
      v_idx := v_idx + 1;
    
      if v_cant <= 0 and bcab.pres_timo_codi in (1, 2) and
         bdet.indi_prod_ortr = 'P' then
        begin
          select prod_impu_codi
            into ta_pedi_deta(v_idx).dpre_impu_codi
            from come_prod
           where prod_codi = bdet.dpre_prod_codi;
        
        Exception
          when no_data_found then
            ta_pedi_deta(v_idx).dpre_impu_codi := 1;
        end;
      else
        ta_pedi_deta(v_idx).dpre_impu_codi := 1;
      end if;
    
      if bdet.s_dpre_indi_esta_conf is not null and
         bdet.s_dpre_indi_esta_conf = 'C' then
        ta_pedi_deta(v_idx).dpre_indi_esta_conf := 'C';
      else
        ta_pedi_deta(v_idx).dpre_indi_esta_conf := nvl(bdet.dpre_indi_esta_conf,
                                                       'C');
      end if;
    
      if bdet.s_dpre_indi_auto_conf is not null then
        ta_pedi_deta(v_idx).dpre_indi_esta_conf := bdet.s_dpre_indi_auto_conf;
      else
        ta_pedi_deta(v_idx).dpre_indi_esta_conf := nvl(bdet.dpre_indi_auto_conf,
                                                       'S');
      end if;
    
      if bdet.indi_prod_ortr = 'P' then
        ta_pedi_deta(v_idx).dpre_prod_codi := bdet.dpre_prod_codi;
        ta_pedi_deta(v_idx).dpre_ortr_codi_fact := null;
        ta_pedi_deta(v_idx).dpre_conc_codi := null;
        ta_pedi_deta(v_idx).dpre_medi_codi := nvl(bdet.dpre_medi_codi, 1);
        ta_pedi_deta(v_idx).dpre_prod_codi_barr := bdet.coba_codi_barr;
      elsif bdet.indi_prod_ortr = 'S' then
        ta_pedi_deta(v_idx).dpre_conc_codi := bdet.dpre_prod_codi;
        ta_pedi_deta(v_idx).dpre_ortr_codi_fact := null;
        ta_pedi_deta(v_idx).dpre_prod_codi := null;
        ta_pedi_deta(v_idx).dpre_medi_codi := null;
        ta_pedi_deta(v_idx).dpre_prod_codi_barr := null;
      elsif bdet.indi_prod_ortr = 'O' then
        ta_pedi_deta(v_idx).dpre_conc_codi := null;
        ta_pedi_deta(v_idx).dpre_ortr_codi_fact := bdet.dpre_prod_codi;
        ta_pedi_deta(v_idx).dpre_prod_codi := null;
        ta_pedi_deta(v_idx).dpre_medi_codi := null;
        ta_pedi_deta(v_idx).dpre_prod_codi_barr := null;
      
        update come_orde_trab
           set ortr_pres_codi = bcab.pres_codi
         where ortr_codi = ta_pedi_deta(v_idx).dpre_ortr_codi_fact;
      end if;
    
      ta_pedi_deta(v_idx).dpre_pres_codi := bcab.pres_codi;
      ta_pedi_deta(v_idx).dpre_nume_item := v_idx;
      ta_pedi_deta(v_idx).dpre_list_codi := nvl(bcab.pres_list_prec, 1);
      ta_pedi_deta(v_idx).dpre_cant := bdet.dpre_cant_medi;
      ta_pedi_deta(v_idx).dpre_prec_unit := bdet.dpre_prec_unit;
      ta_pedi_deta(v_idx).dpre_porc_deto := nvl(bdet.dpre_porc_deto, 0);
      ta_pedi_deta(v_idx).dpre_iva_mone := 0;
      ta_pedi_deta(v_idx).dpre_impo_mone := bdet.s_total_item;
      ta_pedi_deta(v_idx).dpre_base := parameter.p_codi_base;
      ta_pedi_deta(v_idx).dpre_impo_deto_mone := 0;
      ta_pedi_deta(v_idx).dpre_impo_reca_mone := 0;
      ta_pedi_deta(v_idx).dpre_porc_reca := nvl(bcab.pres_porc_reca, 0);
      ta_pedi_deta(v_idx).dpre_prec_unit_deto := bdet.dpre_prec_unit_deto;
      ta_pedi_deta(v_idx).dpre_impo_mone_deto := bdet.s_total_item_deto;
      ta_pedi_deta(v_idx).dpre_prec_unit_reca := bdet.dpre_prec_unit_reca;
      ta_pedi_deta(v_idx).dpre_impo_mone_reca := bdet.s_total_item_reca;
      ta_pedi_deta(v_idx).dpre_seot_codi := null;
      ta_pedi_deta(v_idx).dpre_nume_item_char := null;
      ta_pedi_deta(v_idx).dpre_medi_anch := null;
      ta_pedi_deta(v_idx).dpre_medi_alto := null;
      ta_pedi_deta(v_idx).dpre_medi_supe := null;
      ta_pedi_deta(v_idx).dpre_tota_iva_incl := null;
      ta_pedi_deta(v_idx).dpre_desc := bdet.prod_desc;
      ta_pedi_deta(v_idx).dpre_refe := null;
      ta_pedi_deta(v_idx).dpre_nive := null;
      ta_pedi_deta(v_idx).dpre_porc_ejec := null;
      ta_pedi_deta(v_idx).dpre_fech_cert := null;
      ta_pedi_deta(v_idx).dpre_opci := null;
      ta_pedi_deta(v_idx).dpre_tota_deto := null;
      ta_pedi_deta(v_idx).dpre_tota_iva_incl_bruto := null;
      ta_pedi_deta(v_idx).dpre_ortr := bdet.indi_prod_ortr;
      ta_pedi_deta(v_idx).dpre_cant_usad := null;
      ta_pedi_deta(v_idx).dpre_cant_soli := null;
      ta_pedi_deta(v_idx).dpre_prec_unit_list := bdet.dpre_prec_unit_list;
      ta_pedi_deta(v_idx).dpre_fcab_codi := null;
      ta_pedi_deta(v_idx).dpre_pres_esta_pres := null;
      ta_pedi_deta(v_idx).dpre_pres_tipo := null;
      ta_pedi_deta(v_idx).dpre_depo_codi := bcab.pres_depo_codi;
      ta_pedi_deta(v_idx).dpre_lote_codi := bdet.dpre_lote_codi; --null;
      ta_pedi_deta(v_idx).dpre_prec_maxi_deto := bdet.s_prec_maxi_deto;
      ta_pedi_deta(v_idx).dpre_prec_unit_neto := bdet.dpre_prec_unit_neto;
      ta_pedi_deta(v_idx).dpre_moti_rech := null;
      ta_pedi_deta(v_idx).dpre_indi_auto_conf := null;
      ta_pedi_deta(v_idx).dpre_indi_stock := null;
      ta_pedi_deta(v_idx).dpre_obse := bdet.dpre_obse;
      --ta_pedi_deta(v_idx).s_exde_codi              := :bdet.exde_codi;
    
    --   exit when :system.last_record = upper('true');
    --   next_record;
    end loop;
  
    pack_app.pa_envi_datos(ta_pedi,
                           ta_pedi_deta,
                           p_pres_codi,
                           v_codResp,
                           v_descResp);
  
    if v_codResp <> 1 then
      pl_me(v_descResp);
    end if;
  
  Exception
    when no_data_found then
      null;
  end pp_actu_pres_clie_pack;

  PROCEDURE PP_ACTU_MOTI_PRES IS
    v_mopr_codi number(10);
  
  BEGIN
    v_mopr_codi := fp_devu_mopr_codi;
    insert into come_moti_pres
      (mopr_codi, mopr_pres_codi, mopr_desc)
    values
      (v_mopr_codi, bcab.pres_codi, parameter.p_mens_vali);
  
  END PP_ACTU_MOTI_PRES;

  FUNCTION FP_DEVU_MOPR_CODI RETURN number IS
    v_mopr_codi number(10);
  begin
    select nvl(max(mopr_codi), 0) + 1 into v_mopr_codi from come_moti_pres;
    return v_mopr_codi + 1;
  Exception
    when others then
      pl_me('entro en when others');
  end FP_DEVU_MOPR_CODI;

  procedure pp_validar_cliente(p_clpr_codi                in number,
                               p_pres_codi_a_modi         in number,
                               p_s_timo_indi_caja         in varchar2,
                               p_pres_tipo                in varchar2,
                               p_pres_clpr_desc           out varchar2,
                               p_clpr_indi_vali_limi_cred out varchar2,
                               p_pres_clpr_ruc            out varchar2,
                               p_pres_clpr_dire           out varchar2,
                               p_pres_clpr_tele           out varchar2,
                               p_pres_clpr_cli_situ_codi  out varchar2,
                               p_clpr_indi_vali_situ_clie out varchar2,
                               p_clpr_indi_exen           out varchar2,
                               p_pres_clpr_indi_list_negr out varchar2,
                               p_pres_clpr_indi_exce      out varchar2,
                               p_clpr_maxi_porc_deto      out varchar2,
                               p_clpr_segm_codi           out varchar2,
                               p_clpr_list_codi           out varchar2,
                               p_clpr_clie_clas1_codi     out varchar2,
                               p_clpr_orte_codi           out varchar2,
                               p_clpr_indi_vali_prec_mini out varchar2,
                               p_pres_orte_codi           out varchar2,
                               p_clpr_codi_pres           in out varchar2,
                               p_pres_list_prec           out varchar2,
                               p_pres_clpr_sres           out varchar2,
                               p_pres_inve_codi           out varchar2,
                               p_s_avis_inve              out varchar2,
                               p_clpr_agen_codi_alte      out varchar2,
                               p_clpr_agen_desc           out varchar2,
                               p_empl_codi_alte           out varchar2,
                               p_pres_indi_vent_comp      out varchar2,
                               p_empl_desc_vent_comp      out varchar2,
                               p_s_indi_vali_subc         out varchar2,
                               p_user_empl_codi_alte      in out varchar2,
                               p_clpr_agen_codi           out varchar2) is
  begin
  
    if nvl(parameter.p_ind_validar_cab, 'N') = 'S' then
      -- if nvl(parameter.p_indi_vali_clpr, 'S') = 'S' then
      if p_clpr_codi is null then
        --:parameter.p_indi_mens_vali := 'S';
        pl_me('Debe ingresar el Cliente.');
      else
        --  pp_mostrar_clpr(:bcab.clpr_codi_alte);
      
        pp_mostrar_clpr(p_clpr_codi,
                        p_pres_codi_a_modi,
                        p_s_timo_indi_caja,
                        p_pres_tipo,
                        p_pres_clpr_desc,
                        p_clpr_indi_vali_limi_cred,
                        p_pres_clpr_ruc,
                        p_pres_clpr_dire,
                        p_pres_clpr_tele,
                        p_pres_clpr_cli_situ_codi,
                        p_clpr_indi_vali_situ_clie,
                        p_clpr_indi_exen,
                        p_pres_clpr_indi_list_negr,
                        p_pres_clpr_indi_exce,
                        p_clpr_maxi_porc_deto,
                        p_clpr_segm_codi,
                        p_clpr_list_codi,
                        p_clpr_clie_clas1_codi,
                        p_clpr_orte_codi,
                        p_clpr_indi_vali_prec_mini,
                        p_pres_orte_codi,
                        p_clpr_codi_pres,
                        p_pres_list_prec,
                        p_pres_clpr_sres,
                        p_clpr_agen_codi);
      
        pp_veri_exis_inve(p_clpr_codi, p_pres_inve_codi, p_s_avis_inve); -- Intencion de Venta
      
        pp_muestra_clpr_agen(p_clpr_agen_codi,
                             p_clpr_agen_codi_alte,
                             p_clpr_agen_desc);
      
        if p_clpr_agen_codi_alte is not null then
          p_empl_codi_alte := p_clpr_agen_codi_alte;
          --set_item_property('bcab.empl_codi_alte', navigable, property_false);
        elsif p_user_empl_codi_alte is not null then
          p_empl_codi_alte := p_user_empl_codi_alte;
          -- set_item_property('bcab.empl_codi_alte', navigable, property_false);
        else
          null;
          /*if get_item_property('bcab.empl_codi_alte', enabled) = 'FALSE' then
            set_item_property('bcab.empl_codi_alte', enabled, property_true);
            set_item_property('bcab.empl_codi_alte', navigable, property_true);
          end if;*/
        end if;
        -- p_empl_codi_alte
        if nvl(p_pres_codi_a_modi, -1) = -1 then
          --if (p_s_clpr_agen_codi_alte is not null and p_user_empl_codi_alte is not null and p_s_clpr_agen_codi_alte <> p_user_empl_codi_alte ) then
          pp_muestra_empl_vent_comp(p_empl_codi_alte,
                                    p_empl_desc_vent_comp,
                                    p_pres_indi_vent_comp);
          --end if; 
        end if;
      
        if nvl(p_pres_codi_a_modi, -1) = -1 then
          if nvl(parameter.p_indi_func_prog_presu, 'E') = 'E' and
             nvl(p_pres_tipo, 'A') <> 'P' then
            pp_deter_situ_clie(p_clpr_codi, p_pres_clpr_cli_situ_codi);
          end if;
        end if;
      
        /*if :bcab.pres_tipo = 'A' then
          pp_habilitar_campo('d');
        else
          pp_habilitar_campo('h');
        end if;*/
      
        if nvl(parameter.p_indi_func_prog_presu, 'E') = 'E' and
           nvl(parameter.p_indi_cons_pres, 'N') = 'N' and
           nvl(p_pres_tipo, 'A') <> 'P' then
          pp_veri_cheq_rech_clpr;
        end if;
      
        pp_validar_sub_cuenta(p_clpr_codi, p_s_indi_vali_subc);
      
      end if;
      --end if;
    end if;
  
  end pp_validar_cliente;

  PROCEDURE pp_validar_sub_cuenta(p_pres_clpr_codi   in number,
                                  p_s_indi_vali_subc out varchar2) IS
    v_count number := 0;
  BEGIN
    select count(*)
      into v_count
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_pres_clpr_codi;
  
    if v_count > 0 then
      p_s_indi_vali_subc := 'S';
      -- set_item_property('bcab.sucu_nume_item', enabled, property_true);
      ---set_item_property('bcab.sucu_nume_item', navigable, property_true);
    else
      --:bcab.sucu_nume_item := null;
      --:bcab.sucu_desc := null;
      p_s_indi_vali_subc := 'N';
      --  set_item_property('bcab.sucu_nume_item', enabled, property_false);
    end if;
  END;

  procedure pp_recargar_precios(p_pres_tasa_come      in number,
                                p_pres_tasa_mone      in number,
                                p_pres_mone_cant_deci in number,
                                p_pres_mone_codi      in number) is
    v_unid_medi number;
    v_cant      number;
  begin
    bcab.pres_tasa_mone      := p_pres_tasa_mone;
    bcab.pres_mone_cant_deci := p_pres_mone_cant_deci;
    bcab.pres_mone_codi      := p_pres_mone_codi;
  
    for bdet in detalle loop
      v_unid_medi := bdet.dpre_medi_codi;
      v_cant      := bdet.dpre_cant_medi;
      pp_busca_prec_cost(bdet.dpre_prod_codi,
                         bdet.dpre_prec_unit,
                         bcab.pres_mone_codi);
      if bdet.dpre_prec_unit = 0 or bdet.dpre_prec_unit is null then
      
        pp_busca_prec_list_prec(bcab.pres_list_prec,
                                bcab.pres_mone_codi,
                                bdet.dpre_prod_codi,
                                bdet.dpre_medi_codi,
                                p_pres_tasa_come,
                                p_pres_mone_codi,
                                p_pres_tasa_mone,
                                p_pres_mone_cant_deci,
                                bdet.dpre_prec_unit_list,
                                bdet.lide_indi_vali_prec_mini,
                                bdet.prod_maxi_porc_desc,
                                bdet.lide_maxi_porc_deto);
      
      end if;
    
      bdet.dpre_medi_codi := v_unid_medi;
      bdet.dpre_cant_medi := v_cant;
      --go_item('bdet.dpre_porc_deto');
    --do_key('next_item');
    
    end loop;
  
  end pp_recargar_precios;

  procedure pp_busca_prec_cost(p_prod_codi in number,
                               p_prec_cost out number,
                               p_mone_codi in number) is
  
    v_cost_mmnn number;
    v_cost_mmee number;
  
  begin
    select a.prpe_cost_prom_fini_mmnn, a.prpe_cost_prom_fini_mmee
      into v_cost_mmnn, v_cost_mmee
      from come_prod_peri a
     where a.prpe_prod_codi = p_prod_codi
       and a.prpe_peri_codi = (select max(peri_codi) from come_peri);
  
    if p_mone_codi = parameter.p_codi_mone_mmnn then
      p_prec_cost := round(v_cost_mmnn, parameter.p_cant_deci_mmnn);
    else
      p_prec_cost := round(v_cost_mmee, parameter.p_cant_deci_mmee);
    end if;
  
  Exception
    When others then
      --v_cost_mmnn := 0;
      --v_cost_mmee := 0;
      null;
    
  end pp_busca_prec_cost;

  procedure pp_busca_prec_list_prec(p_list_prec           in number,
                                    p_mone_codi           in number,
                                    p_prod_codi           in number,
                                    p_medi_codi           in number,
                                    p_pres_tasa_come      in number,
                                    p_pres_mone_codi      in number,
                                    p_pres_tasa_mone      in number,
                                    p_pres_mone_cant_deci in number,
                                    ---
                                    p_prec_unit                out number,
                                    p_lide_indi_vali_prec_mini out varchar2,
                                    p_prod_maxi_porc_desc      out number,
                                    p_lide_maxi_porc_deto      out number) is
  
    v_prec_list_prec number;
    v_lide_mone_codi number;
  
  begin
  
    select b.lide_prec,
           lide_mone_codi,
           lide_indi_vali_prec_mini,
           nvl(prod_maxi_porc_desc, 0),
           nvl(lide_maxi_porc_deto, 0)
      into v_prec_list_prec,
           v_lide_mone_codi,
           p_lide_indi_vali_prec_mini,
           p_prod_maxi_porc_desc,
           p_lide_maxi_porc_deto
      from come_list_prec a, come_list_prec_deta b, come_prod p
     where a.list_codi = b.lide_list_codi
       and b.lide_prod_codi = p.prod_codi
       and b.lide_list_codi = p_list_prec
       and b.lide_prod_codi = p_prod_codi
       and lide_medi_codi = p_medi_codi;
  
    if v_lide_mone_codi = p_pres_mone_codi then
      --si La moneda de la Factura es igual a la moneda del precio del producto   
      p_prec_unit := v_prec_list_prec;
    else
      -- si la moneda del precio del producto no es igual a la moneda de la factura
      if p_pres_mone_codi = parameter.p_codi_mone_mmnn then
        --Si la moneda de la Factura es en Gs..
        p_prec_unit := round((v_prec_list_prec * nvl(p_pres_tasa_come, 1)),
                             parameter.p_cant_deci_mmnn);
      else
        --si la moneda de la Factura es en US, tenemos que dividir por la tasa
        p_prec_unit := round((v_prec_list_prec / p_pres_tasa_mone),
                             p_pres_mone_cant_deci);
      end if;
    end if;
  
  Exception
    When others then
      p_prec_unit                := 0;
      p_lide_indi_vali_prec_mini := 'N';
      p_prod_maxi_porc_desc      := 0;
      p_lide_maxi_porc_deto      := 0;
  end pp_busca_prec_list_prec;

  procedure pp_Actualizar_registro_cons is
    salir exception;
    --v_record number;
  begin
  
    if bcab.s_total_bruto = 0 then
      pl_me('Atenci?n!!!!!.. Debe ingresar los totales');
    end if;
  
    --pp_reenumerar_nro_item;      
  
    if bcab.pres_codi_a_modi is not null then
      pp_borrar_presup(bcab.pres_codi_a_modi);
    end if;
  
    if bcab.pres_codi_a_modi is null then
      pp_busca_nume_movi(bcab.pres_codi,
                         bcab.pres_nume,
                         bcab.pres_numep_pres_nume,
                         bcab.nume_pres_ante);
      pp_actu_secu(parameter.p_codi_secu);
    end if;
  
    pp_actu_pres_clie;
    pp_actu_pres_clie_deta_cons;
  
  Exception
    when salir then
      null;
  end pp_Actualizar_registro_cons;

  procedure pp_borrar_presup(p_pres_codi in number) is
    v_ortr_codi number;
  
  begin
  
    begin
      select ot.ortr_codi
        into v_ortr_codi
        from come_orde_trab ot
       where ot.ortr_pres_codi = p_pres_codi;
    
      update come_orde_trab
         set ortr_pres_codi = null
       where ortr_codi = v_ortr_codi;
    
    exception
      when no_data_found then
        null;
      when too_many_rows then
        pl_me('Mas de una Orden de Trabajo esta relacionada a este Presupuesto.' ||
              ' Avise al Administrador de Sistemas.');
    end;
  
    if bcab.pres_inve_codi is not null then
      update come_inte_vent
         set inve_esta = 'P'
       where inve_codi = bcab.pres_inve_codi;
    end if;
    ---llam_pres_codi campos no encontrado....
    /* update come_clie_llam_cobr set llam_pres_codi = null
    where llam_pres_codi = p_pres_codi;*/
  
    delete come_clie_cred_espe where cres_pres_codi = p_pres_codi;
    delete come_exce_deto where exde_pres_codi = p_pres_codi;
    delete come_pres_clie_requ where prre_pres_codi = p_pres_codi;
    delete come_pres_clie_deta where dpre_pres_codi = p_pres_codi;
    delete come_pres_clie where pres_codi = p_pres_codi;
  
  exception
    when others then
      pl_me(sqlerrm);
  end pp_borrar_presup;

  procedure pp_actu_pres_clie is
  
    v_pres_codi                number(20);
    v_pres_nume                number(20);
    v_pres_nume_char           varchar2(30);
    v_pres_refe                varchar2(1500);
    v_pres_fech_emis           date;
    v_pres_clpr_codi           number(20);
    v_pres_empl_codi           number(10);
    v_pres_mone_codi           number(4);
    v_pres_user                varchar2(10);
    v_pres_fech_grab           date;
    v_pres_grav_mone           number(20, 4);
    v_pres_exen_mone           number(20, 4);
    v_pres_iva_mone            number(20, 4);
    v_pres_indi_iva_incl       varchar2(1);
    v_pres_timo_codi           number(10);
    v_pres_tasa_mone           number(20, 4);
    v_pres_vali                number(4);
    v_pres_movi_codi           number(20);
    v_pres_base                number(2);
    v_pres_clpr_cont           varchar2(100);
    v_pres_clpr_sres           varchar2(100);
    v_pres_clpr_ruc            varchar2(20);
    v_pres_vali_ofer           varchar2(500);
    v_pres_plaz_entr           varchar2(500);
    v_pres_clpr_tele           varchar2(80);
    v_pres_cond_vent           varchar2(1500);
    v_pres_obse                varchar2(1500);
    v_pres_clpr_dire           varchar2(100);
    v_pres_clpr_desc           varchar2(80);
    v_pres_porc_deto           number;
    v_pres_desc_mano_obra      varchar2(500);
    v_pres_impo_mano_obra      number;
    v_pres_impo_mano_obra_deto number;
    v_pres_impo_mano_obra_reca number;
    v_pres_porc_reca           number;
    v_pres_tipo_pres           varchar2(1) := 'C'; --S = Salon de Ventas , C=Costeo 
    v_pres_esta_pres           varchar2(1) := 'P'; --nvl(:bcab.pres_esta_pres, 'P');
    v_pres_list_prec           number;
    v_pres_impo_deto           number;
    v_pres_form_entr_codi      number;
    v_pres_orte_codi           number;
    v_pres_tipo                varchar2(1) := nvl(bcab.pres_tipo, 'A');
    v_pres_depo_codi           number;
    v_pres_indi_user_deto      varchar2(1) := nvl(bcab.user_indi_real_deto_sin_exce,
                                                  'N');
    v_pres_empr_codi           number(10);
    v_pres_inve_codi           number(10);
    v_pres_auto_limi_cred      varchar2(1);
    v_pres_auto_situ_clie      varchar2(1);
    v_pres_auto_cheq_rech      varchar2(1);
    v_pres_auto_desc_prod      varchar2(1);
    v_pres_auto_anal_cred      varchar2(1);
    v_pres_auto_supe_vent      varchar2(1);
    v_pres_auto_gere_gene      varchar2(1);
    v_pres_indi_vent_comp      varchar2(1);
    v_pres_empl_codi_vent_comp number(10);
    v_pres_indi_tipo_vali_pres varchar2(1);
    v_pres_clpr_sucu_nume_item number;
  
    --v_conf_limi_cred varchar2(1);
    --v_conf_situ_clie varchar2(1);
    --v_conf_cheq_rech varchar2(1);
    --v_conf_desc_prod varchar2(1);
    --v_conf_anal_cred varchar2(1);
    --v_conf_supe_vent varchar2(1);
    --v_conf_gere_gene varchar2(1);
  
  begin
  
    bcab.pres_codi      := fa_sec_come_pres_clie;
    bcab.pres_fech_grab := sysdate;
    bcab.pres_user      := g_user;
  
    v_pres_codi      := bcab.pres_codi;
    v_pres_nume      := bcab.pres_nume;
    v_pres_nume_char := bcab.pres_nume || '/' ||
                        to_char(bcab.pres_fech_emis, 'yy');
    v_pres_refe      := bcab.pres_refe;
    v_pres_fech_emis := bcab.pres_fech_emis;
    v_pres_clpr_codi := bcab.pres_clpr_codi;
    v_pres_empl_codi := bcab.pres_empl_codi;
    v_pres_mone_codi := bcab.pres_mone_codi;
    v_pres_user      := g_user;
    v_pres_fech_grab := sysdate;
  
    v_pres_grav_mone     := 0; --:bcab.pres_grav_mone;
    v_pres_exen_mone     := 0; --:bcab.pres_exen_mone;
    v_pres_iva_mone      := 0; --:bcab.pres_iva_mone;
    v_pres_indi_iva_incl := null;
    v_pres_timo_codi     := bcab.pres_timo_codi;
    v_pres_tasa_mone     := bcab.pres_tasa_mone;
    v_pres_vali          := null;
    v_pres_movi_codi     := null;
    v_pres_base          := parameter.p_codi_base;
    v_pres_clpr_cont     := bcab.pres_clpr_cont;
    v_pres_clpr_sres     := bcab.pres_clpr_sres;
    v_pres_clpr_ruc      := bcab.pres_clpr_ruc;
    v_pres_vali_ofer     := bcab.pres_vali_ofer;
    v_pres_plaz_entr     := bcab.pres_plaz_entr;
    v_pres_clpr_tele     := bcab.pres_clpr_tele;
    v_pres_cond_vent     := bcab.pres_cond_vent;
  
    v_pres_obse      := bcab.pres_obse;
    v_pres_clpr_dire := bcab.pres_clpr_dire;
    v_pres_clpr_desc := bcab.pres_clpr_desc;
  
    v_pres_porc_deto           := bcab.pres_porc_deto;
    v_pres_desc_mano_obra      := bcab.pres_desc_mano_obra;
    v_pres_impo_mano_obra      := bcab.pres_impo_mano_obra;
    v_pres_impo_mano_obra_deto := bcab.pres_impo_mano_obra_deto;
    v_pres_impo_mano_obra_reca := bcab.pres_impo_mano_obra_reca;
    v_pres_porc_reca           := bcab.pres_porc_reca;
    v_pres_list_prec           := bcab.pres_list_prec;
    v_pres_impo_deto           := bcab.s_total;
    v_pres_form_entr_codi      := bcab.pres_form_entr_codi;
    v_pres_orte_codi           := bcab.pres_orte_codi;
    v_pres_depo_codi           := bcab.pres_depo_codi;
    v_pres_clpr_sucu_nume_item := bcab.sucu_nume_item;
  
    v_pres_indi_user_deto      := bcab.user_indi_real_deto_sin_exce;
    v_pres_empr_codi           := nvl(parameter.p_empr_codi, 1);
    v_pres_inve_codi           := nvl(parameter.p_inve_codi,
                                      bcab.pres_inve_codi);
    v_pres_auto_limi_cred      := nvl(bcab.pres_auto_limi_cred, 'S');
    v_pres_auto_situ_clie      := nvl(bcab.pres_auto_situ_clie, 'S');
    v_pres_auto_cheq_rech      := nvl(bcab.pres_auto_cheq_rech, 'S');
    v_pres_auto_desc_prod      := nvl(bcab.pres_auto_desc_prod, 'S');
    v_pres_auto_anal_cred      := 'N';
    v_pres_auto_supe_vent      := 'N';
    v_pres_auto_gere_gene      := 'N';
    v_pres_indi_vent_comp      := nvl(bcab.pres_indi_vent_comp, 'N');
    v_pres_empl_codi_vent_comp := bcab.pres_empl_codi_vent_comp;
    v_pres_indi_tipo_vali_pres := nvl(parameter.p_indi_func_prog_presu, 'E');
  
    pp_insert_come_pres_clie(v_pres_codi,
                             v_pres_nume,
                             v_pres_nume_char,
                             v_pres_refe,
                             v_pres_fech_emis,
                             v_pres_clpr_codi,
                             v_pres_empl_codi,
                             v_pres_mone_codi,
                             v_pres_user,
                             v_pres_fech_grab,
                             v_pres_grav_mone,
                             v_pres_exen_mone,
                             v_pres_iva_mone,
                             v_pres_indi_iva_incl,
                             v_pres_timo_codi,
                             v_pres_tasa_mone,
                             v_pres_vali,
                             v_pres_movi_codi,
                             v_pres_base,
                             v_pres_clpr_cont,
                             v_pres_clpr_sres,
                             v_pres_clpr_ruc,
                             v_pres_vali_ofer,
                             v_pres_plaz_entr,
                             v_pres_clpr_tele,
                             v_pres_cond_vent,
                             v_pres_obse,
                             v_pres_clpr_dire,
                             v_pres_clpr_desc,
                             v_pres_porc_deto,
                             v_pres_desc_mano_obra,
                             v_pres_impo_mano_obra,
                             v_pres_impo_mano_obra_deto,
                             v_pres_impo_mano_obra_reca,
                             v_pres_porc_reca,
                             v_pres_tipo_pres,
                             v_pres_esta_pres,
                             v_pres_list_prec,
                             v_pres_impo_deto,
                             v_pres_form_entr_codi,
                             v_pres_orte_codi,
                             v_pres_tipo,
                             v_pres_depo_codi,
                             v_pres_indi_user_deto,
                             v_pres_empr_codi,
                             v_pres_inve_codi,
                             v_pres_auto_limi_cred,
                             v_pres_auto_situ_clie,
                             v_pres_auto_cheq_rech,
                             v_pres_auto_desc_prod,
                             v_pres_auto_anal_cred,
                             v_pres_auto_supe_vent,
                             v_pres_auto_gere_gene,
                             v_pres_indi_vent_comp,
                             v_pres_empl_codi_vent_comp,
                             v_pres_indi_tipo_vali_pres,
                             v_pres_clpr_sucu_nume_item);
  
  end pp_actu_pres_clie;

  procedure pp_actu_pres_clie_deta_cons is
    v_dpre_pres_codi      number;
    v_dpre_nume_item      number := 0;
    v_dpre_impu_codi      number;
    v_dpre_list_codi      number;
    v_dpre_prod_codi      number;
    v_dpre_cant           number;
    v_dpre_prec_unit      number;
    v_dpre_porc_deto      number;
    v_dpre_iva_mone       number;
    v_dpre_impo_mone      number;
    v_dpre_base           number;
    v_dpre_impo_deto_mone number;
    v_dpre_impo_reca_mone number;
    v_dpre_porc_reca      number;
  
    v_cant number := 0;
  
    v_dpre_prec_unit_deto number;
    v_dpre_impo_mone_deto number;
  
    v_dpre_prec_unit_reca number;
    v_dpre_impo_mone_reca number;
    v_dpre_desc           varchar2(800);
    v_indi_prod_ortr      varchar2(1);
    v_dpre_medi_codi      number;
    v_dpre_conc_codi      number;
    v_dpre_ortr_codi_fact number;
    v_dpre_coba_codi_barr varchar2(20);
    v_dpre_indi_esta_conf varchar2(1);
    v_dpre_indi_auto_conf varchar2(1);
    v_dpre_prec_unit_list number;
    v_dpre_prec_maxi_deto number;
    v_dpre_prec_unit_neto number;
  
    cursor c_pres_cons(p_pres_codi in number) is
      select dpre_prod_codi,
             dpre_pres_codi,
             min(dpre_nume_item),
             sum(dpre_cant) dpre_cant,
             avg(dpre_prec_unit) dpre_prec_unit,
             avg(dpre_porc_deto) dpre_porc_deto,
             avg(dpre_porc_reca) dpre_porc_reca,
             
             sum(dpre_impo_mone) dpre_impo_mone,
             min(dpre_base) dpre_base,
             sum(dpre_impo_deto_mone) dpre_impo_deto_mone,
             sum(dpre_impo_reca_mone) dpre_impo_reca_mone,
             
             avg(dpre_prec_unit_deto) dpre_prec_unit_deto,
             sum(dpre_impo_mone_deto) dpre_impo_mone_deto,
             avg(dpre_prec_unit_reca) dpre_prec_unit_reca,
             sum(dpre_impo_mone_reca) dpre_impo_mone_reca
      
        from come_pres_clie_deta
       where dpre_pres_codi = p_pres_codi
      
       group by dpre_list_codi, dpre_prod_codi, dpre_pres_codi
       order by min(dpre_nume_item), dpre_prod_codi;
  
    type tipo_tab_dpre_pres_codi is table of number(20) index by binary_integer;
    tab_dpre_pres_codi tipo_tab_dpre_pres_codi;
  
    type tipo_tab_dpre_nume_item is table of number(20) index by binary_integer;
    tab_dpre_nume_item tipo_tab_dpre_nume_item;
  
    type tipo_tab_dpre_list_codi is table of number(20) index by binary_integer;
    tab_dpre_list_codi tipo_tab_dpre_list_codi;
  
    type tipo_tab_dpre_prod_codi is table of number(20) index by binary_integer;
    tab_dpre_prod_codi tipo_tab_dpre_prod_codi;
  
    type tipo_tab_dpre_cant is table of number(20) index by binary_integer;
    tab_dpre_cant tipo_tab_dpre_cant;
  
    type tipo_tab_dpre_prec_unit is table of number(20, 4) index by binary_integer;
    tab_dpre_prec_unit tipo_tab_dpre_prec_unit;
  
    type tipo_tab_dpre_porc_deto is table of number(20, 4) index by binary_integer;
    tab_dpre_porc_deto tipo_tab_dpre_porc_deto;
  
    type tipo_tab_dpre_porc_reca is table of number(20, 4) index by binary_integer;
    tab_dpre_porc_reca tipo_tab_dpre_porc_reca;
  
    type tipo_tab_dpre_impo_mone is table of number(20, 4) index by binary_integer;
    tab_dpre_impo_mone tipo_tab_dpre_impo_mone;
  
    type tipo_tab_dpre_prec_unit_deto is table of number(20, 4) index by binary_integer;
    tab_dpre_prec_unit_deto tipo_tab_dpre_prec_unit_deto;
  
    type tipo_tab_dpre_impo_mone_deto is table of number(20, 4) index by binary_integer;
    tab_dpre_impo_mone_deto tipo_tab_dpre_impo_mone_deto;
  
    type tipo_tab_dpre_prec_unit_reca is table of number(20, 4) index by binary_integer;
    tab_dpre_prec_unit_reca tipo_tab_dpre_prec_unit_reca;
  
    type tipo_tab_dpre_impo_mone_reca is table of number(20, 4) index by binary_integer;
    tab_dpre_impo_mone_reca tipo_tab_dpre_impo_mone_reca;
  
    i binary_integer;
  
  begin
    --go_block('bdet');
    --  first_record;
    for bdet in detalle loop
      v_dpre_pres_codi := bcab.pres_codi;
      v_dpre_nume_item := v_dpre_nume_item + 1;
    
      -----------------     
      if v_cant <= 0 and bcab.pres_timo_codi in (1, 2) and
         bdet.indi_prod_ortr = 'P' then
        begin
          select prod_impu_codi
            into v_dpre_impu_codi
            from come_prod
           where prod_codi = bdet.dpre_prod_codi;
        
        Exception
          when no_data_found then
            v_dpre_impu_codi := 1;
        end;
      else
        v_dpre_impu_codi := 1;
      end if;
      -----------------       
    
      v_dpre_list_codi := null;
      v_dpre_cant      := bdet.dpre_cant_medi;
      v_dpre_prec_unit := bdet.dpre_prec_unit;
      v_dpre_porc_deto := nvl(bcab.pres_porc_deto, 0);
      --v_dpre_porc_reca := nvl(bcab.pres_porc_reca, 0);
    
      v_dpre_iva_mone       := 0;
      v_dpre_impo_mone      := bdet.s_total_item;
      v_dpre_base           := 1;
      v_dpre_impo_deto_mone := 0;
      v_dpre_impo_reca_mone := 0;
      v_dpre_porc_reca      := 0;
    
      v_dpre_prec_unit_list := bdet.dpre_prec_unit_list;
      v_dpre_prec_maxi_deto := bdet.s_prec_maxi_deto;
      v_dpre_prec_unit_neto := bdet.dpre_prec_unit_neto;
    
      v_dpre_prec_unit_deto := bdet.dpre_prec_unit_deto;
      v_dpre_impo_mone_deto := bdet.s_total_item_deto;
    
      v_dpre_prec_unit_reca := bdet.dpre_prec_unit_reca;
      v_dpre_impo_mone_reca := bdet.s_total_item_reca;
      v_dpre_desc           := bdet.prod_desc;
      v_indi_prod_ortr      := bdet.indi_prod_ortr;
      v_dpre_indi_esta_conf := nvl(bdet.dpre_indi_esta_conf, 'C');
      v_dpre_indi_auto_conf := nvl(bdet.dpre_indi_auto_conf, 'S');
    
      if bdet.indi_prod_ortr = 'P' then
        v_dpre_prod_codi      := bdet.dpre_prod_codi;
        v_dpre_conc_codi      := null;
        v_dpre_medi_codi      := nvl(bdet.dpre_medi_codi, 1);
        v_dpre_coba_codi_barr := bdet.coba_codi_barr;
      elsif bdet.indi_prod_ortr = 'S' then
        v_dpre_conc_codi      := bdet.dpre_prod_codi;
        v_dpre_prod_codi      := null;
        v_dpre_medi_codi      := null;
        v_dpre_coba_codi_barr := null;
      elsif bdet.indi_prod_ortr = 'O' then
        v_dpre_ortr_codi_fact := bdet.dpre_prod_codi;
        v_dpre_prod_codi      := null;
        v_dpre_medi_codi      := null;
        v_dpre_coba_codi_barr := null;
      end if;
    
      pp_insert_come_pres_clie_deta(v_dpre_pres_codi,
                                    v_dpre_nume_item,
                                    v_dpre_impu_codi,
                                    v_dpre_list_codi,
                                    v_dpre_prod_codi,
                                    v_dpre_cant,
                                    v_dpre_prec_unit,
                                    v_dpre_porc_deto,
                                    v_dpre_iva_mone,
                                    v_dpre_impo_mone,
                                    v_dpre_base,
                                    v_dpre_impo_deto_mone,
                                    v_dpre_impo_reca_mone,
                                    v_dpre_porc_reca,
                                    v_dpre_prec_unit_deto,
                                    v_dpre_impo_mone_deto,
                                    v_dpre_prec_unit_reca,
                                    v_dpre_impo_mone_reca,
                                    v_dpre_desc,
                                    v_indi_prod_ortr,
                                    v_dpre_medi_codi,
                                    v_dpre_conc_codi,
                                    v_dpre_ortr_codi_fact,
                                    v_dpre_coba_codi_barr,
                                    v_dpre_indi_esta_conf,
                                    v_dpre_indi_auto_conf,
                                    v_dpre_prec_unit_list,
                                    v_dpre_prec_maxi_deto,
                                    v_dpre_prec_unit_neto);
      --exit when :system.last_record = upper('true');
    --next_record;
    
    end loop;
  
    i := 0;
    for x in c_pres_cons(bcab.pres_codi) loop
      i := i + 1;
    
      tab_dpre_prod_codi(i) := x.dpre_pres_codi;
      tab_dpre_nume_item(i) := i;
      tab_dpre_list_codi(i) := null;
      tab_dpre_prod_codi(i) := x.dpre_prod_codi;
      tab_dpre_cant(i) := x.dpre_cant;
      tab_dpre_prec_unit(i) := x.dpre_prec_unit;
      tab_dpre_porc_deto(i) := x.dpre_porc_deto;
      tab_dpre_porc_reca(i) := x.dpre_porc_reca;
      tab_dpre_impo_mone(i) := x.dpre_impo_mone;
      tab_dpre_porc_reca(i) := x.dpre_porc_reca;
    
      tab_dpre_prec_unit_deto(i) := x.dpre_prec_unit_deto;
      tab_dpre_impo_mone_deto(i) := x.dpre_impo_mone_deto;
    
      tab_dpre_prec_unit_reca(i) := x.dpre_prec_unit_reca;
      tab_dpre_impo_mone_reca(i) := x.dpre_impo_mone_reca;
    end loop;
  
    delete come_pres_clie_deta where dpre_pres_codi = bcab.pres_codi;
  
    for x in 1 .. i loop
      v_dpre_pres_codi := bcab.pres_codi;
      v_dpre_nume_item := x;
      v_dpre_impu_codi := 1; --siempre exento;
      v_dpre_list_codi := tab_dpre_list_codi(x);
      v_dpre_prod_codi := tab_dpre_prod_codi(x);
      v_dpre_cant      := tab_dpre_cant(x);
      v_dpre_prec_unit := tab_dpre_prec_unit(x);
      v_dpre_porc_deto := nvl(bcab.pres_porc_deto, 0);
      --v_dpre_porc_reca := nvl(bcab.pres_porc_reca, 0);
    
      v_dpre_iva_mone       := 0;
      v_dpre_impo_mone      := tab_dpre_impo_mone(x);
      v_dpre_base           := 1;
      v_dpre_impo_deto_mone := 0;
      v_dpre_impo_reca_mone := 0;
      v_dpre_porc_reca      := 0;
    
      v_dpre_prec_unit_deto := tab_dpre_prec_unit_deto(x);
      v_dpre_impo_mone_deto := tab_dpre_impo_mone_deto(x);
    
      v_dpre_prec_unit_reca := tab_dpre_prec_unit_reca(x);
      v_dpre_impo_mone_reca := tab_dpre_impo_mone_reca(x);
      v_dpre_coba_codi_barr := null;
      v_dpre_indi_esta_conf := 'C'; --tab_dpre_indi_esta_conf(x);
      v_dpre_indi_auto_conf := 'S'; --tab_dpre_indi_auto_conf(x);
      v_dpre_prec_unit_list := null;
      v_dpre_prec_maxi_deto := null;
      v_dpre_prec_unit_neto := null;
    
      pp_insert_come_pres_clie_deta(v_dpre_pres_codi,
                                    v_dpre_nume_item,
                                    v_dpre_impu_codi,
                                    v_dpre_list_codi,
                                    v_dpre_prod_codi,
                                    v_dpre_cant,
                                    v_dpre_prec_unit,
                                    v_dpre_porc_deto,
                                    v_dpre_iva_mone,
                                    v_dpre_impo_mone,
                                    v_dpre_base,
                                    v_dpre_impo_deto_mone,
                                    v_dpre_impo_reca_mone,
                                    v_dpre_porc_reca,
                                    v_dpre_prec_unit_deto,
                                    v_dpre_impo_mone_deto,
                                    v_dpre_prec_unit_reca,
                                    v_dpre_impo_mone_reca,
                                    v_dpre_desc,
                                    v_indi_prod_ortr,
                                    v_dpre_medi_codi,
                                    v_dpre_conc_codi,
                                    v_dpre_ortr_codi_fact,
                                    v_dpre_coba_codi_barr,
                                    v_dpre_indi_esta_conf,
                                    v_dpre_indi_auto_conf,
                                    v_dpre_prec_unit_list,
                                    v_dpre_prec_maxi_deto,
                                    v_dpre_prec_unit_neto);
    
    end loop;
  
  end pp_actu_pres_clie_deta_cons;

  procedure pp_insert_come_pres_clie(p_pres_codi                in number,
                                     p_pres_nume                in number,
                                     p_pres_nume_char           in varchar2,
                                     p_pres_refe                in varchar2,
                                     p_pres_fech_emis           in date,
                                     p_pres_clpr_codi           in number,
                                     p_pres_empl_codi           in number,
                                     p_pres_mone_codi           in number,
                                     p_pres_user                in varchar2,
                                     p_pres_fech_grab           in date,
                                     p_pres_grav_mone           in number,
                                     p_pres_exen_mone           in number,
                                     p_pres_iva_mone            in number,
                                     p_pres_indi_iva_incl       in varchar2,
                                     p_pres_timo_codi           in number,
                                     p_pres_tasa_mone           in number,
                                     p_pres_vali                in number,
                                     p_pres_movi_codi           in number,
                                     p_pres_base                in number,
                                     p_pres_clpr_cont           in varchar2,
                                     p_pres_clpr_sres           in varchar2,
                                     p_pres_clpr_ruc            in varchar2,
                                     p_pres_vali_ofer           in varchar2,
                                     p_pres_plaz_entr           in varchar2,
                                     p_pres_clpr_tele           in varchar2,
                                     p_pres_cond_vent           in varchar2,
                                     p_pres_obse                in varchar2,
                                     p_pres_clpr_dire           in varchar2,
                                     p_pres_clpr_desc           in varchar2,
                                     p_pres_porc_deto           in number,
                                     p_pres_desc_mano_obra      in varchar2,
                                     p_pres_impo_mano_obra      in number,
                                     p_pres_impo_mano_obra_deto in number,
                                     p_pres_impo_mano_obra_reca in number,
                                     p_pres_porc_reca           in number,
                                     p_pres_tipo_pres           in varchar2,
                                     p_pres_esta_pres           in varchar2,
                                     p_pres_list_prec           in number,
                                     p_pres_impo_deto           in number,
                                     p_pres_form_entr_codi      in number,
                                     p_pres_orte_codi           in number,
                                     p_pres_tipo                in varchar2,
                                     p_pres_depo_codi           in number,
                                     p_pres_indi_user_deto      in varchar2,
                                     p_pres_empr_codi           in number,
                                     p_pres_inve_codi           in number,
                                     p_pres_auto_limi_cred      in varchar2,
                                     p_pres_auto_situ_clie      in varchar2,
                                     p_pres_auto_cheq_rech      in varchar2,
                                     p_pres_auto_desc_prod      in varchar2,
                                     p_pres_auto_anal_cred      in varchar2,
                                     p_pres_auto_supe_vent      in varchar2,
                                     p_pres_auto_gere_gene      in varchar2,
                                     p_pres_indi_vent_comp      in varchar2,
                                     p_pres_empl_codi_vent_comp in number,
                                     p_pres_indi_tipo_vali_pres in varchar2,
                                     p_pres_clpr_sucu_nume_item in number) is
  
  begin
    insert into come_pres_clie
      (pres_codi,
       pres_nume,
       pres_fech_emis,
       pres_clpr_codi,
       pres_empl_codi,
       pres_mone_codi,
       pres_user,
       pres_fech_grab,
       pres_grav_mone,
       pres_exen_mone,
       pres_iva_mone,
       pres_indi_iva_incl,
       pres_timo_codi,
       pres_tasa_mone,
       pres_vali,
       pres_movi_codi,
       pres_base,
       pres_clpr_cont,
       pres_clpr_sres,
       pres_clpr_ruc,
       pres_vali_ofer,
       pres_plaz_entr,
       pres_clpr_tele,
       pres_cond_vent,
       pres_obse,
       pres_clpr_dire,
       pres_clpr_desc,
       pres_porc_deto,
       pres_desc_mano_obra,
       pres_impo_mano_obra,
       pres_impo_mano_obra_deto,
       pres_impo_mano_obra_reca,
       pres_porc_reca,
       pres_tipo_pres,
       pres_nume_char,
       pres_esta_pres,
       pres_list_prec,
       pres_impo_deto,
       pres_form_entr_codi,
       pres_orte_codi,
       pres_tipo,
       pres_depo_codi,
       pres_indi_user_deto,
       pres_empr_codi,
       pres_inve_codi,
       pres_auto_limi_cred,
       pres_auto_situ_clie,
       pres_auto_cheq_rech,
       pres_auto_desc_prod,
       pres_auto_anal_cred,
       pres_auto_supe_vent,
       pres_auto_gere_gene,
       pres_refe,
       pres_indi_vent_comp,
       pres_empl_codi_vent_comp,
       pres_indi_tipo_vali_pres,
       pres_clpr_sucu_nume_item)
    values
      (p_pres_codi,
       p_pres_nume,
       p_pres_fech_emis,
       p_pres_clpr_codi,
       p_pres_empl_codi,
       p_pres_mone_codi,
       p_pres_user,
       p_pres_fech_grab,
       p_pres_grav_mone,
       p_pres_exen_mone,
       p_pres_iva_mone,
       p_pres_indi_iva_incl,
       p_pres_timo_codi,
       p_pres_tasa_mone,
       p_pres_vali,
       p_pres_movi_codi,
       p_pres_base,
       p_pres_clpr_cont,
       p_pres_clpr_sres,
       p_pres_clpr_ruc,
       p_pres_vali_ofer,
       p_pres_plaz_entr,
       p_pres_clpr_tele,
       p_pres_cond_vent,
       p_pres_obse,
       p_pres_clpr_dire,
       p_pres_clpr_desc,
       p_pres_porc_deto,
       p_pres_desc_mano_obra,
       p_pres_impo_mano_obra,
       p_pres_impo_mano_obra_deto,
       p_pres_impo_mano_obra_reca,
       p_pres_porc_reca,
       p_pres_tipo_pres,
       p_pres_nume_char,
       p_pres_esta_pres,
       p_pres_list_prec,
       p_pres_impo_deto,
       p_pres_form_entr_codi,
       p_pres_orte_codi,
       p_pres_tipo,
       p_pres_depo_codi,
       p_pres_indi_user_deto,
       p_pres_empr_codi,
       p_pres_inve_codi,
       p_pres_auto_limi_cred,
       p_pres_auto_situ_clie,
       p_pres_auto_cheq_rech,
       p_pres_auto_desc_prod,
       p_pres_auto_anal_cred,
       p_pres_auto_supe_vent,
       p_pres_auto_gere_gene,
       p_pres_refe,
       p_pres_indi_vent_comp,
       p_pres_empl_codi_vent_comp,
       p_pres_indi_tipo_vali_pres,
       p_pres_clpr_sucu_nume_item);
  
  exception
    when others then
      pl_me(sqlerrm);
  end pp_insert_come_pres_clie;

  procedure pp_insert_come_pres_clie_deta(
                                          
                                          p_dpre_pres_codi      in number,
                                          p_dpre_nume_item      in number,
                                          p_dpre_impu_codi      in number,
                                          p_dpre_list_codi      in number,
                                          p_dpre_prod_codi      in number,
                                          p_dpre_cant           in number,
                                          p_dpre_prec_unit      in number,
                                          p_dpre_porc_deto      in number,
                                          p_dpre_iva_mone       in number,
                                          p_dpre_impo_mone      in number,
                                          p_dpre_base           in number,
                                          p_dpre_impo_deto_mone in number,
                                          p_dpre_impo_reca_mone in number,
                                          p_dpre_porc_reca      in number,
                                          p_dpre_prec_unit_deto in number,
                                          p_dpre_impo_mone_deto in number,
                                          p_dpre_prec_unit_reca in number,
                                          p_dpre_impo_mone_reca in number,
                                          p_dpre_desc           in varchar2,
                                          p_indi_prod_ortr      in varchar2,
                                          p_dpre_medi_codi      in number,
                                          p_dpre_conc_codi      in number,
                                          p_dpre_ortr_codi_fact in number,
                                          p_dpre_coba_codi_barr in varchar2,
                                          p_dpre_indi_esta_conf in varchar2,
                                          p_dpre_indi_auto_conf in varchar2,
                                          p_dpre_prec_unit_list in number,
                                          p_dpre_prec_maxi_deto in number,
                                          p_dpre_prec_unit_neto in number) is
  begin
  
    insert into come_pres_clie_deta
      (dpre_pres_codi,
       dpre_nume_item,
       dpre_impu_codi,
       dpre_list_codi,
       dpre_prod_codi,
       dpre_cant,
       dpre_prec_unit,
       dpre_porc_deto,
       dpre_iva_mone,
       dpre_impo_mone,
       dpre_base,
       dpre_impo_deto_mone,
       dpre_impo_reca_mone,
       dpre_porc_reca,
       dpre_prec_unit_deto,
       dpre_impo_mone_deto,
       dpre_prec_unit_reca,
       dpre_impo_mone_reca,
       dpre_desc,
       dpre_ortr,
       dpre_medi_codi,
       dpre_conc_codi,
       dpre_ortr_codi_fact,
       dpre_prod_codi_barr,
       dpre_indi_esta_conf,
       dpre_indi_auto_conf,
       dpre_prec_unit_list,
       dpre_prec_maxi_deto,
       dpre_prec_unit_neto)
    values
      (p_dpre_pres_codi,
       p_dpre_nume_item,
       p_dpre_impu_codi,
       p_dpre_list_codi,
       p_dpre_prod_codi,
       p_dpre_cant,
       p_dpre_prec_unit,
       p_dpre_porc_deto,
       p_dpre_iva_mone,
       p_dpre_impo_mone,
       p_dpre_base,
       p_dpre_impo_deto_mone,
       p_dpre_impo_reca_mone,
       p_dpre_porc_reca,
       p_dpre_prec_unit_deto,
       p_dpre_impo_mone_deto,
       p_dpre_prec_unit_reca,
       p_dpre_impo_mone_reca,
       p_dpre_desc,
       p_indi_prod_ortr,
       p_dpre_medi_codi,
       p_dpre_conc_codi,
       p_dpre_ortr_codi_fact,
       p_dpre_coba_codi_barr,
       p_dpre_indi_esta_conf,
       p_dpre_indi_auto_conf,
       p_dpre_prec_unit_list,
       p_dpre_prec_maxi_deto,
       p_dpre_prec_unit_neto);
  
  end;

  procedure pp_guardar is
  begin
  
    if bcab.pres_codi_a_modi is not null then
    
      if bcab.empl_codi_alte_vent is not null and
         bcab.pres_empl_codi_vent_comp is null then
        declare
          v_empl_maxi_porc_deto number;
          v_vend_tele           varchar2(60);
          v_vend_mail           varchar2(60);
        begin
          pp_muestra_come_empl_alte(bcab.pres_empr_codi,
                                    parameter.p_codi_tipo_empl_vend,
                                    bcab.empl_codi_alte_vent,
                                    bcab.empl_desc_vent_comp,
                                    bcab.pres_empl_codi_vent_comp,
                                    v_empl_maxi_porc_deto,
                                    v_vend_tele,
                                    v_vend_mail);
        end;
      end if;
    
      pp_actualiza_empl_vent_comp(bcab.pres_codi_a_modi);
      --pp_iniciar;
    end if;
  end pp_guardar;

  procedure pp_actualiza_empl_vent_comp(p_pres_codi in number) is
  begin
  
    if nvl(bcab.pres_indi_vent_comp, 'N') <>
       nvl(bcab.pres_indi_vent_comp, 'N') or
       bcab.pres_empl_codi_vent_comp <> bcab.pres_empl_codi_vent_comp then
    
      if nvl(bcab.pres_indi_vent_comp, 'N') = 'N' then
        bcab.pres_indi_vent_comp := null;
      end if;
    
      update come_pres_clie p
         set p.pres_empl_codi_vent_comp = bcab.pres_empl_codi_vent_comp,
             p.pres_indi_vent_comp      = nvl(bcab.pres_indi_vent_comp, 'N')
       where p.pres_codi = p_pres_codi;
    
      commit;
    
    end if;
  
  exception
    when others then
      pl_me(sqlerrm);
    
  end pp_actualiza_empl_vent_comp;

  procedure pp_muestra_come_empl_alte(p_empl_empr_codi      in number,
                                      p_emti_tiem_codi      in number,
                                      p_empl_codi_alte      in varchar2,
                                      p_empl_desc           out varchar2,
                                      p_empl_codi           out number,
                                      p_empl_maxi_porc_deto out number,
                                      p_empl_tele           out varchar2,
                                      p_empl_mail           out varchar2) is
  begin
    select e.empl_desc,
           e.empl_codi,
           nvl(e.empl_maxi_porc_deto, 0),
           empl_tele,
           empl_mail
      into p_empl_desc,
           p_empl_codi,
           p_empl_maxi_porc_deto,
           p_empl_tele,
           p_empl_mail
      from come_empl e, come_empl_tiem t
     where e.empl_codi = t.emti_empl_codi
       and t.emti_tiem_codi = p_emti_tiem_codi
       and e.empl_empr_codi = p_empl_empr_codi
       and ltrim(rtrim(lower(e.empl_codi_alte))) =
           ltrim(rtrim(lower(p_empl_codi_alte)));
  
  exception
    when no_data_found then
      p_empl_desc           := null;
      p_empl_codi           := null;
      p_empl_maxi_porc_deto := 0;
      pl_me('Empleado inexistente o no es del tipo requerido.');
    when others then
      pl_me(sqlerrm);
  end pp_muestra_come_empl_alte;

  procedure pp_muestra_come_empl(p_empl_empr_codi in number,
                                 --p_emti_tiem_codi in number,
                                 p_empl_codi           in varchar2,
                                 p_empl_desc           out varchar2,
                                 p_empl_maxi_porc_deto out number,
                                 p_empl_tele           out varchar2,
                                 p_empl_mail           out varchar2) is
  begin
    select e.empl_desc, nvl(e.empl_maxi_porc_deto, 0), empl_tele, empl_mail
      into p_empl_desc, p_empl_maxi_porc_deto, p_empl_tele, p_empl_mail
      from come_empl e, come_empl_tiem t
     where e.empl_codi = t.emti_empl_codi
       and t.emti_tiem_codi = PARAMETER.p_codi_tipo_empl_vend --p_emti_tiem_codi
       and e.empl_empr_codi = p_empl_empr_codi
       and ltrim(rtrim(lower(e.empl_codi))) =
           ltrim(rtrim(lower(p_empl_codi)));
  
  exception
    when no_data_found then
      p_empl_desc           := null;
      p_empl_maxi_porc_deto := 0;
      pl_me('Empleado inexistente o no es del tipo requerido.');
    when others then
      pl_me(sqlerrm);
  end pp_muestra_come_empl;

  procedure pl_muestra_come_mone(p_mone_codi      in number,
                                 p_mone_desc      out varchar2,
                                 p_mone_desc_abre out varchar2,
                                 p_mone_cant_deci out number) is
  begin
    select mone_desc, mone_desc_abre, mone_cant_deci
      into p_mone_desc, p_mone_desc_abre, p_mone_cant_deci
      from come_mone
     where mone_codi = p_mone_codi;
  Exception
    when no_data_found then
      p_mone_desc := null;
      pl_me('Moneda Inexistente!');
    when others then
      pl_me(sqlerrm);
  end pl_muestra_come_mone;

  procedure pp_busca_tasa_mone(p_mone_codi in number,
                               p_coti_fech in date,
                               p_mone_coti out number,
                               p_tica_codi in number,
                               p_tasa_come out number) is
  begin
    if parameter.p_codi_mone_mmnn = p_mone_codi then
      p_mone_coti := 1;
      p_tasa_come := 1;
    else
      select coti_tasa, nvl(coti_tasa_come, coti_tasa)
        into p_mone_coti, p_tasa_come
        from come_coti
       where coti_mone = p_mone_codi
         and coti_fech = p_coti_fech
         and coti_tica_codi = p_tica_codi;
    
    end if;
  
    if parameter.p_codi_mone_mmnn <> p_mone_codi and
       (nvl(p_mone_coti, 0) in (0, 1) or nvl(p_tasa_come, 0) in (0, 1)) then
      --:parameter.p_indi_mens_vali := 'S'; 
      pl_me('Cotizaci?n no v?lida para la moneda ' || p_mone_codi ||
            ' para la fecha del documento.');
    end if;
  
  exception
    when no_data_found then
      p_mone_coti := null;
      p_tasa_come := null;
      ---:parameter.p_indi_mens_vali := 'S'; 
      pl_me('Cotizacion Inexistente para la fecha del documento.');
    when others then
      pl_me(sqlerrm);
  end pp_busca_tasa_mone;

  procedure pp_carga_limi_cred(p_clpr_codi           in number,
                               p_mone_tasa           in number,
                               p_pres_mone_codi      in number,
                               p_pres_mone_cant_deci in number,
                               p_limi_cred_mone      out number) is
  
    v_limi_cred_gs number := 0;
    v_limi_cred_us number := 0;
    v_limi_cred_eu number := 0;
    v_limi_cred    number := 0;
  
    cursor c_limi_cred is
      select cpmo_limi_cred_mone, cpmo_mone_codi
        from come_clie_prov_mone
       where cpmo_clpr_codi = p_clpr_codi;
  
  begin
  
    for x in c_limi_cred loop
      if x.cpmo_mone_codi = parameter.p_codi_mone_mmnn then
        v_limi_cred_gs := x.cpmo_limi_cred_mone;
      end if;
    
      if x.cpmo_mone_codi = parameter.p_codi_mone_dola then
        v_limi_cred_us := x.cpmo_limi_cred_mone;
      end if;
    
      if x.cpmo_mone_codi = 4 then
        v_limi_cred_eu := x.cpmo_limi_cred_mone;
      end if;
    
    end loop;
  
    if p_pres_mone_codi = parameter.p_codi_mone_mmnn then
      v_limi_cred := v_limi_cred_gs +
                     round((v_limi_cred_us + v_limi_cred_eu * p_mone_tasa),
                           0);
    end if;
  
    if p_pres_mone_codi = parameter.p_codi_mone_dola then
      v_limi_cred := round(v_limi_cred_gs / p_mone_tasa,
                           p_pres_mone_cant_deci) + v_limi_cred_us +
                     v_limi_cred_eu;
    end if;
  
    if p_pres_mone_codi = 4 then
      v_limi_cred := round(v_limi_cred_gs / p_mone_tasa,
                           p_pres_mone_cant_deci) + v_limi_cred_us +
                     v_limi_cred_eu;
    end if;
  
    p_limi_cred_mone := v_limi_cred;
  
  Exception
    When no_data_found then
      p_limi_cred_mone := 0;
    When others then
      p_limi_cred_mone := 0;
  end;

  procedure pp_carga_sald_clie_1(p_clpr_codi           in number,
                                 p_mone_tasa           in number,
                                 p_pres_mone_cant_deci in number,
                                 p_sald_clie_mone      out number) is
  begin
    select round(nvl(((sum(decode(tm.timo_dbcr,
                                  'D',
                                  c.cuot_sald_mmnn,
                                  -c.cuot_sald_mmnn))) / p_mone_tasa),
                     0),
                 p_pres_mone_cant_deci) Saldo
      into p_sald_clie_mone
      from come_movi m, come_movi_cuot c, come_tipo_movi tm
     where m.movi_codi = c.cuot_movi_codi
       and m.movi_timo_codi = tm.timo_codi
       and m.movi_clpr_codi = p_clpr_codi;
  
  Exception
    When no_data_found then
      p_sald_clie_mone := 0;
    When others then
      p_sald_clie_mone := 0;
  end pp_carga_sald_clie_1;

  procedure pp_muestra_come_depo(p_depo_empr_codi in number,
                                 p_depo_codi      in varchar2,
                                 p_depo_desc      out varchar2,
                                 --p_sucu_desc      out varchar2,
                                 p_sucu_codi out number) is
  begin
    select d.depo_desc,
           --d.depo_codi,
           --s.sucu_codi_alte,
           --s.sucu_desc,
           s.sucu_codi
      into p_depo_desc,
           --p_depo_codi,
           --p_sucu_codi_alte,
           --p_sucu_desc,
           p_sucu_codi
      from come_depo d, come_sucu s
     where d.depo_sucu_codi = s.sucu_codi(+)
       and d.depo_empr_codi = p_depo_empr_codi
       and ltrim(rtrim(lower(d.depo_codi))) =
           ltrim(rtrim(lower(p_depo_codi)));
  
  exception
    when no_data_found then
      p_depo_desc := null;
      --p_depo_codi      := null;
      --p_sucu_codi_alte := null;
      --p_sucu_desc      := null;
      p_sucu_codi := null;
      pl_me('Deposito inexistente.');
    when others then
      pl_me(sqlerrm);
  end pp_muestra_come_depo;

  procedure pp_traer_desc_prod(p_prod_codi_alfa      in number,
                               p_clpr_indi_exen      in varchar2,
                               p_movi_oper_codi      in number,
                               p_dpre_prod_codi      out number,
                               p_prod_desc           out varchar2,
                               p_deta_prod_clco      out number,
                               p_dpre_impu_codi      out number,
                               p_prod_indi_fact_nega out varchar2,
                               p_prod_indi_auto_fact out varchar2,
                               p_dpre_lote_codi      out number,
                               p_prod_indi_lote      out varchar2,
                               p_dpre_conc_codi      out number,
                               p_dpre_moco_dbcr      out varchar2,
                               p_coba_codi_barr      out number,
                               p_prod_desc_exte      out varchar2) is
    v_prod_indi_inac varchar2(1);
    --v_dbcr           char(1);
    v_lote_desc      varchar2(100);
    v_lote_obse      varchar2(100);
    v_lote_codi_barr varchar2(100);
    --v_IND_VAL_COBA_CODI varchar2(100);
  
  begin
    select prod_codi,
           prod_desc,
           prod_clco_codi,
           prod_impu_codi,
           prod_indi_inac,
           prod_indi_fact_nega,
           nvl(prod_indi_auto_fact, 'S'),
           nvl(prod_indi_lote, 'N')
      into p_dpre_prod_codi,
           p_prod_desc,
           p_deta_prod_clco,
           p_dpre_impu_codi,
           v_prod_indi_inac,
           p_prod_indi_fact_nega,
           p_prod_indi_auto_fact,
           p_prod_indi_lote
      from come_prod
     where prod_codi_alfa = p_prod_codi_alfa;
  
    if nvl(p_clpr_indi_exen, 'N') = 'S' then
      p_dpre_impu_codi := parameter.p_codi_impu_exen;
    end if;
  
    if v_prod_indi_inac = 'S' then
      pl_me('El producto se encuentra inactivo');
    end if;
  
    if fp_validar_coba_codi(p_dpre_prod_codi, p_prod_codi_alfa) > 1 then
    
      --v_IND_VAL_COBA_CODI := 'S';
      null;
    
      -- if get_item_property('bdet.coba_codi_barr', navigable) = 'FALSE' then
      --   set_item_property('bdet.coba_codi_barr', navigable, property_true);
      -- end if;
    
    else
    
      begin
        select d.coba_codi_barr
          into p_coba_codi_barr
          from come_prod, come_prod_coba_deta d
         where prod_codi = d.coba_prod_codi
           and prod_codi_alfa = p_prod_codi_alfa;
      
        -- p_coba_codi_barr := v_coba_codi_barr;
      
        /*if get_item_property('bdet.coba_codi_barr', navigable) = 'TRUE' then
          set_item_property('bdet.coba_codi_barr', navigable, property_false);
        end if;*/
      
        --v_IND_VAL_COBA_CODI := 'N';
        null;
      exception
        when others then
        
          /*if get_item_property('bdet.coba_codi_barr', navigable) = 'FALSE' then
            set_item_property('bdet.coba_codi_barr', navigable, property_true);
          end if;*/
        
          null;
          --v_IND_VAL_COBA_CODI := 'N';
      
      end;
    
    end if;
  
    if nvl(upper(parameter.p_camb_prod_auto_fact), 'N') = 'S' then
      if p_prod_indi_auto_fact = 'N' then
        pl_me('El producto no se encuentra habilitado para facturacion por un cambio de costo');
      end if;
    end if;
  
    if p_deta_prod_clco is null then
      pl_me('El producto no tiene definido la Clasificacion de Conceptos');
    else
      pp_busca_conce_prod(p_deta_prod_clco,
                          p_movi_oper_codi,
                          p_dpre_conc_codi,
                          p_dpre_moco_dbcr);
    end if;
  
    if nvl(p_prod_indi_lote, 'N') = 'N' then
      p_dpre_lote_codi := fa_devu_lote_000000(p_dpre_prod_codi);
    
      begin
        select lote_desc, lote_obse, lote_codi_barr
          into v_lote_desc, v_lote_obse, v_lote_codi_barr
          from come_lote
         where lote_codi = p_dpre_lote_codi;
      
        p_prod_desc_exte := v_lote_desc || ' ' || v_lote_obse || ' ' ||
                            v_lote_codi_barr;
      end;
    end if;
  
  exception
    when no_data_found then
      pl_me('Producto inexistente.');
    when others then
      pl_me(sqlerrm);
  end pp_traer_desc_prod;

  procedure pp_busca_conce_prod(p_clco_codi in number,
                                p_oper_codi in number,
                                p_conc_codi out number,
                                p_conc_dbcr out varchar2) is
  begin
  
    select deta_conc_codi, conc_dbcr
      into p_conc_codi, p_conc_dbcr
      from come_prod_clas_conc, come_prod_clas_conc_deta, come_conc
     where clco_codi = deta_clco_codi
       and deta_conc_codi = conc_codi
       and deta_oper_codi = p_oper_codi
       and deta_clco_codi = p_clco_codi;
  
  Exception
    when no_data_found then
      p_conc_dbcr := null;
      p_conc_codi := null;
      pl_me('Concepto de producto no encontrado!');
    when others then
      pl_me(sqlerrm);
    
  end pp_busca_conce_prod;

  procedure pp_traer_desc_conce(p_codi      in number,
                                p_desc      out varchar2,
                                p_impu      out number,
                                P_CONC_DBCR OUT VARCHAR2) is
    v_conc_dbcr varchar2(1);
  
    cursor c_conc_iva(p_conc_codi in number) is
      select conc_codi
        from (select nvl(impu_conc_codi_ivdb, -1) conc_codi
                from come_impu
              union
              select nvl(impu_conc_codi_ivcr, -1) conc_codi
                from come_impu)
       where conc_codi = p_conc_codi
       order by 1;
  
  begin
  
    for x in c_conc_iva(p_codi) loop
      pl_me('No puede seleccionar un concepto de IVA');
    end loop;
  
    select conc_desc, conc_dbcr, conc_impu_codi, CONC_DBCR
      into p_desc, v_conc_dbcr, p_impu, P_CONC_DBCR
      from come_conc
     where conc_codi = p_codi
       and nvl(conc_indi_fact, 'N') = 'S';
  
  Exception
    When no_data_found then
      pl_me('Concepto inexistente o no es facturable!');
    
    when others then
      pl_me(sqlerrm);
  end pp_traer_desc_conce;

  procedure pp_buscar_precio_conc(p_pres_list_prec      in number,
                                  p_conc_codi           in number,
                                  p_pres_nume           in number,
                                  p_pres_mone_cant_deci in number,
                                  p_pres_tasa_mone      in number,
                                  p_pres_mone_codi      in number,
                                  p_prod_codi_ante      in number,
                                  p_dpre_prod_codi      in number,
                                  p_dpre_prec_unit      in out number,
                                  p_dpre_prec_unit_list in out number) is
    v_prec           number;
    v_lide_mone_codi number;
    v_prec_list      number;
  begin
    select lide_prec, lide_mone_codi
      into v_prec, v_lide_mone_codi
      from come_list_prec_conc_deta
     where lide_list_codi = p_pres_list_prec
       and lide_conc_codi = p_conc_codi;
  
    if v_lide_mone_codi = p_pres_mone_codi then
      --si La moneda de la Factura es igual a la moneda del precio del producto   
      v_prec_list := v_prec;
    else
      -- si la moneda del precio del producto no es igual a la moneda de la factura
      if p_pres_mone_codi = parameter.p_codi_mone_mmnn then
        --Si la moneda de la Factura es en Gs..
        v_prec_list := round((v_prec * p_pres_tasa_mone),
                             nvl(p_pres_mone_cant_deci, 0));
      else
        --si la moneda de la Factura es en US, tenemos que dividir por la tasa
        v_prec_list := round((v_prec / p_pres_tasa_mone),
                             nvl(p_pres_mone_cant_deci, 0));
      end if;
    end if;
  
    if nvl(p_dpre_prec_unit, 0) <= 0 or
       nvl(p_prod_codi_ante, -1) <> nvl(p_conc_codi, -1) then
      p_dpre_prec_unit      := v_prec_list;
      p_dpre_prec_unit_list := p_DPRE_PREC_UNIT;
    end if;
  
    p_dpre_prec_unit_list := v_prec_list;
  
    setitem('P135_IND_MOSTRAR_SMS', 'N');
  exception
    when no_data_found then
      if parameter.p_indi_most_mens_aler = 'S' then
        p_dpre_prec_unit_list := null;
        if fp_exis_pres(p_pres_nume) = false then
          p_dpre_prec_unit      := 0;
          p_dpre_prec_unit_list := 0;
        else
          if nvl(p_dpre_prec_unit, 0) <= 0 or
             nvl(p_prod_codi_ante, -1) <> nvl(p_dpre_prod_codi, -1) then
            p_dpre_prec_unit      := null; --0;
            p_dpre_prec_unit_list := null; --0;
          end if;
        end if;
      
        setitem('P135_IND_MOSTRAR_SMS', 'S');
        -- pl_me('El producto no posee Precio en La lista de precio.');
      else
        setitem('P135_IND_MOSTRAR_SMS', 'N');
        p_dpre_prec_unit_list := p_dpre_prec_unit;
      end if;
  end pp_buscar_precio_conc;

  procedure pp_validar_concepto(p_codi                in number,
                                p_clpr_indi_exen      in varchar2,
                                p_pres_list_prec      in number,
                                p_pres_mone_cant_deci in number,
                                p_pres_tasa_mone      in number,
                                p_pres_mone_codi      in number,
                                p_pres_nume           in number,
                                p_ortr_desc           out varchar2,
                                p_dpre_impu_codi      out number,
                                p_dpre_prec_unit      in out number,
                                p_dpre_prec_unit_list in out number,
                                p_CONC_DBCR           out varchar2) is
    --v_prod_alfa_ante number;
    v_dpre_prod_codi number;
    v_prod_codi_ante number;
  begin
  
    -- if :bdet.ortr_desc is null or nvl(:bdet.prod_codi_alfa, '-1') <> nvl(:bdet.prod_alfa_ante, '-1') then
    pp_traer_desc_conce(p_codi, p_ortr_desc, p_dpre_impu_codi, p_CONC_DBCR);
  
    --v_prod_alfa_ante := p_codi;
    v_dpre_prod_codi := p_codi;
    --if nvl(:bcab.pres_codi_a_modi, -1) = -1 then
    if parameter.p_indi_vali_list_prec = 'S' then
      --pp_buscar_precio_conc;
    
      I020117.pp_buscar_precio_conc(p_pres_list_prec      => p_pres_list_prec,
                                    p_conc_codi           => p_codi,
                                    p_pres_nume           => p_pres_nume,
                                    p_pres_mone_cant_deci => p_pres_mone_cant_deci,
                                    p_pres_tasa_mone      => p_pres_tasa_mone,
                                    p_pres_mone_codi      => p_pres_mone_codi,
                                    p_prod_codi_ante      => v_prod_codi_ante,
                                    p_dpre_prod_codi      => v_dpre_prod_codi,
                                    p_dpre_prec_unit      => p_dpre_prec_unit,
                                    p_dpre_prec_unit_list => p_dpre_prec_unit_list);
    
    end if;
    -- end if;
    --v_prod_codi_ante := v_dpre_prod_codi; 
    --end if;
  
    -- :bdet.dpre_prod_codi := :bdet.prod_codi_alfa;
  
    if p_ortr_desc is null then
      ----para casos de modificacion de descripcion de concepto
      p_ortr_desc := p_ortr_desc;
    end if;
  
    if p_dpre_impu_codi is null then
      p_dpre_impu_codi := parameter.p_codi_impu_ortr;
    end if;
    if nvl(p_clpr_indi_exen, 'N') = 'S' then
      p_dpre_impu_codi := parameter.p_codi_impu_exen;
    end if;
  
  end pp_validar_concepto;

  procedure pp_mostrar_ot(p_ortr_nume           in number,
                          p_pres_mone_codi      in number,
                          p_pres_tasa_mone      in number,
                          p_pres_mone_cant_deci in number,
                          p_pres_clpr_codi      in number,
                          p_pres_esta_pres      in varchar2,
                          p_prod_desc           out varchar2,
                          p_dpre_prec_unit      in out number,
                          p_dpre_prod_codi      out number,
                          p_dpre_prec_unit_list out number,
                          p_s_indi_ot           out varchar2,
                          p_deta_prod_clco      out number) is
  
    v_clpr_codi      number;
    v_cant           number;
    v_prec_vent      number;
    v_mone_codi_prec number;
    v_prec_unit      number;
    v_excl_fact      varchar2(1);
    v_indi_fact      varchar2(1);
    v_sose_codi      number;
    v_count          number;
    v_indi_timo      varchar2(1);
    v_tipo_fact      varchar2(1);
    v_serv_tipo      varchar2(1);
    v_serv_tipo_inst varchar2(1);
    v_desc           varchar2(500);
    v_vehi_mode      varchar2(20);
    v_vehi_iden      varchar2(20);
    v_sose_nume_poli varchar2(20);
  
  begin
  
    begin
    
      select ortr_codi,
             ortr_desc ortr_desc,
             ortr_clpr_codi,
             ortr_clco_codi,
             nvl(ORTR_MONE_CODI_PREC, parameter.p_codi_mone_mmnn),
             ORTR_PREC_VENT,
             nvl(ortr_excl_fact, 'N'),
             nvl(ortr_indi_fact, 'N'),
             ortr_sose_codi
        into p_dpre_prod_codi,
             v_desc,
             v_clpr_codi,
             p_deta_prod_clco,
             v_mone_codi_prec,
             v_prec_vent,
             v_excl_fact,
             v_indi_fact,
             v_sose_codi
        from come_orde_trab, come_orde_trab_vehi
       where ortr_codi = vehi_ortr_codi(+)
         and ortr_nume = p_ortr_nume;
    
      if v_mone_codi_prec = p_pres_mone_codi then
        v_prec_unit := v_prec_vent;
      else
        if p_pres_mone_codi = parameter.p_codi_mone_mmnn then
          v_prec_unit := round((v_prec_vent * p_pres_tasa_mone),
                               p_pres_mone_cant_deci);
        else
          v_prec_unit := round((v_prec_vent / p_pres_tasa_mone),
                               p_pres_mone_cant_deci);
        end if;
      end if;
    
      if nvl(p_dpre_prec_unit, 0) <= 0 then
        p_dpre_prec_unit      := v_prec_unit;
        p_dpre_prec_unit_list := v_prec_unit;
      end if;
    
      --verificar que la orden de trabajo pertenezca al cliente...
      if v_clpr_codi <> p_pres_clpr_codi then
        pl_me('La orden de trabajo no pertenece al cliente, Favor Verifique!!!');
      end if;
    
      if p_deta_prod_clco is null then
        --se debe cargar concepto para OT.
      
        begin
          select sose_indi_timo,
                 sose_tipo_fact,
                 ortr_serv_tipo,
                 ortr_serv_tipo_inst,
                 vehi_mode,
                 vehi_iden,
                 sose_nume_poli
            into v_indi_timo,
                 v_tipo_fact,
                 v_serv_tipo,
                 v_serv_tipo_inst,
                 v_vehi_mode,
                 v_vehi_iden,
                 v_sose_nume_poli
            from come_orde_trab      o,
                 come_orde_trab_vehi,
                 come_soli_serv_anex,
                 come_soli_serv      s
           where ortr_codi = vehi_ortr_codi
             and vehi_anex_codi = anex_codi(+)
             and anex_sose_codi = sose_codi(+)
             and ortr_codi = p_dpre_prod_codi
           group by sose_indi_timo,
                    sose_tipo_fact,
                    ortr_serv_tipo,
                    ortr_serv_tipo_inst,
                    vehi_mode,
                    vehi_iden,
                    sose_nume_poli;
        
          if v_serv_tipo in ('I', 'RI', 'V', 'N') then
            --Instalacion, Reinstalacion, verificacion, Renovacion
            if v_serv_tipo = 'RI' then
              v_desc := 'Reinstalacion  de ';
            elsif v_serv_tipo = 'N' then
              v_desc := 'Renovacion de ';
            end if;
            if v_serv_tipo_inst = 'G' then
              --GPS
              if v_indi_timo = 'C' or v_tipo_fact = 'C' then
                p_deta_prod_clco := 101;
                v_desc           := v_desc ||
                                    'Servicio de Monitoreo Satelital Vehicular ' ||
                                    '(Comodato) UN A?O DE MONITOREO (' ||
                                    v_vehi_iden || ')';
              else
                select count(*)
                  into v_count
                  from come_movi_conc_deta
                 where moco_ortr_codi_fact = p_dpre_prod_codi;
              
                if v_count = 0 then
                  p_deta_prod_clco := 101;
                else
                  p_deta_prod_clco := 248;
                end if;
                v_desc := v_desc ||
                          'Monitoreo Satelital Vehicular (Mes: ) ' || '(' ||
                          v_vehi_iden || ')';
              end if;
            elsif v_serv_tipo_inst = 'P' then
              --Bloqueo
              p_deta_prod_clco := 107;
              v_desc           := 'Bloqueo de Puertas.';
              if v_vehi_iden is not null then
                v_desc := v_desc || ' Identificador (' || v_vehi_iden || ')';
              end if;
            elsif v_serv_tipo_inst = 'A' then
              --Alarmas
              p_deta_prod_clco := 102;
              v_desc           := 'Kit de Alarma.';
              if v_vehi_iden is not null then
                v_desc := v_desc || ' Identificador (' || v_vehi_iden || ')';
              end if;
            elsif v_serv_tipo_inst = 'R' then
              --Roamming
              p_deta_prod_clco := 103;
              v_desc           := 'Servicio de Roaming. Mes ().';
              if v_vehi_iden is not null then
                v_desc := v_desc || ' Identificador (' || v_vehi_iden || ')';
              end if;
            elsif v_serv_tipo_inst = 'C' then
              --Sensor de Combustible
              p_deta_prod_clco := 290;
              v_desc           := 'Sensor de movimiento.';
            elsif v_serv_tipo_inst = 'T' then
              --Tapa de combustible
              p_deta_prod_clco := 396;
              v_desc           := 'Sensor de tapa de tanque.';
              if v_vehi_iden is not null then
                v_desc := v_desc || ' Identificador (' || v_vehi_iden || ')';
              end if;
            end if;
          elsif v_serv_tipo in ('R') then
            --Cambio a RPY
            p_deta_prod_clco := 254;
            v_desc           := 'Servicio de Monitoreo Satelital Vehicular (Mes: )';
            if v_vehi_iden is not null then
              v_desc := v_desc || '(' || v_vehi_iden || ')';
            end if;
          
          elsif v_serv_tipo in ('S') then
            --Cambio de Seguro
            p_deta_prod_clco := 254;
            v_desc           := 'Servicio de Monitoreo Satelital Vehicular (Mes: )';
            if v_vehi_iden is not null then
              v_desc := v_desc || '(' || v_vehi_iden || ')';
            end if;
          
          elsif v_serv_tipo in ('T') then
            --Cambio de Titularidad
            p_deta_prod_clco := 254;
            v_desc           := 'Servicio de Monitoreo Satelital Vehicular (Mes: )';
            if v_vehi_iden is not null then
              v_desc := v_desc || '(' || v_vehi_iden || ')';
            end if;
          
          end if;
        end;
      end if;
    
      -- En caso de que no se este consultando un Presupuesto ya facturado
      -- Verificar que la orden de trabajo no fue facturarda a?n...
      if nvl(p_pres_esta_pres, 'P') <> 'F' then
        if v_indi_timo is null then
          select nvl(sum(decode(o.oper_stoc_suma_rest,
                                'S',
                                deta_cant,
                                -deta_cant)),
                     0) cant
            into v_cant
            from come_movi_ortr_deta d, come_movi m, come_stoc_oper o
           where m.movi_codi = d.deta_movi_codi
             and m.movi_oper_codi = o.oper_codi
             and deta_ortr_codi = p_dpre_prod_codi;
        
          if v_cant < 0 then
            pl_me('La orden de trabajo ya fue facturada!!!!');
          end if;
        end if;
      end if;
    
      p_prod_desc := v_desc;
    
      if v_prec_vent <= 0 or v_prec_vent is null then
        p_s_indi_ot := 'N';
      else
        p_s_indi_ot := 'S';
      end if;
    
      if p_deta_prod_clco is null then
        pl_me('El producto OT no tiene definido la Clasificacion de Conceptos');
      end if;
    
      /* if p_deta_prod_clco is not null then
        pp_busca_conce_prod(p_deta_prod_clco,
                            p_movi_oper_codi,
                            p_dpre_conc_codi,
                            p_dpre_moco_dbcr);
      end if;*/
    
    Exception
      when no_data_found then
        pl_me('Orden de trabajo inexistente!');
      
      when others then
        pl_me(sqlerrm);
    end;
  
    -- En caso de que no se este consultando un Presupuesto ya facturado
    if nvl(p_pres_esta_pres, 'P') <> 'F' then
      begin
        --verificar que la orden de trabajo est? disponible para facturar..
        --solo si saldo = 0...
        --se puede tener el caso de notas de creditos...
        --y entonces se puede volver a facturar...
        ------------------------------------------------------------------------------
        select nvl(sum(decode(o.oper_stoc_suma_rest,
                              'S',
                              deta_cant,
                              -deta_cant)),
                   0)
          into v_cant
          from come_movi_ortr_deta d, come_movi m, come_stoc_oper o
         where m.movi_codi = d.deta_movi_codi
           and m.movi_oper_codi = o.oper_codi
           and deta_ortr_codi = p_dpre_prod_codi;
      
        if v_cant > 0 then
          pl_me('La orden de trabajo ya est? facturada!!!');
        end if;
        ---------------------------------------------------------------------------------
      end;
    end if;
  
  Exception
    when others then
      pl_me(sqlerrm);
  end pp_mostrar_ot;

  procedure pp_add_det(p_PROD_CODI_ALFA          in number,
                       p_indi_prod_ortr          in varchar2,
                       p_dpre_prod_codi          in varchar2,
                       p_coba_codi_barr          in varchar2,
                       p_dpre_medi_codi          in number,
                       p_dpre_cant_medi          in number,
                       p_dpre_prec_unit          in number,
                       p_dpre_porc_deto          in number,
                       p_dpre_prec_unit_list     in number,
                       p_prod_desc               in varchar2,
                       p_dpre_lote_codi          in number,
                       p_s_prec_maxi_deto        in number,
                       p_dpre_prec_unit_neto     in number,
                       p_DPRE_PORC_DETO_TOTA     in number,
                       p_ide_indi_vali_prec_mini varchar2,
                       p_MEDI_DESC_ABRE          in varchar2) as
    v_S_TOTAL_ITEM_MOST number;
    v_S_TOTAL_ITEM      number;
    v_S_TOTAL_ITEM_DETO number;
    v_S_TOTAL_ITEM_RECA number;
  begin
  
    if nvl(p_dpre_cant_medi, 0) <= 0 then
      raise_application_error(-20001, 'La Cantidad debe ser mayor a 0 ');
    end if;
  
    if p_dpre_prec_unit is null then
      pl_me('El precio no puede ser nulo.');
    elsif p_dpre_prec_unit <= 0 then
      if p_dpre_prec_unit = 0 and nvl(v('P135_EXDE_TIPO'), 'N') = 'O' then
        null;
      else
        pl_me('El precio no puede ser menor a cero.');
      end if;
    end if;
    -- v_s_total_item_deto
  
    ------se calcula el importe por item
    I020117.PP_CALCULAR_IMPORTE_ITEM(p_dpre_prec_unit      => p_dpre_prec_unit,
                                     p_dpre_porc_deto      => p_dpre_porc_deto,
                                     p_dpre_cant_medi      => p_dpre_cant_medi,
                                     p_pres_mone_cant_deci => v('P135_PRES_MONE_CANT_DECI'),
                                     p_dpre_prec_unit_deto => v('P135_DPRE_PREC_UNIT_DETO'),
                                     p_dpre_prec_unit_reca => v('P135_DPRE_PREC_UNIT_RECA'),
                                     p_conc_dbcr           => v('P135_CONC_DBCR'),
                                     p_S_TOTAL_ITEM_MOST   => v_S_TOTAL_ITEM_MOST,
                                     p_S_TOTAL_ITEM        => v_S_TOTAL_ITEM,
                                     p_S_TOTAL_ITEM_DETO   => v_S_TOTAL_ITEM_DETO,
                                     p_S_TOTAL_ITEM_RECA   => v_S_TOTAL_ITEM_RECA);
  
    ----
  
    apex_collection.add_member(p_collection_name => 'BDET_DETALLE',
                               p_C001            => p_PROD_CODI_ALFA, --_auto_desc_prod,
                               p_C002            => p_indi_prod_ortr,
                               p_C003            => p_dpre_prod_codi,
                               p_C004            => p_MEDI_DESC_ABRE,
                               p_C005            => null, --i_dpre_indi_esta_conf,
                               p_C006            => null, --i_s_dpre_indi_auto_conf,
                               p_C007            => null, --i_dpre_indi_auto_conf,
                               p_C008            => p_dpre_medi_codi,
                               p_C009            => p_coba_codi_barr,
                               p_C010            => p_dpre_cant_medi,
                               p_C011            => p_dpre_prec_unit,
                               p_C012            => p_dpre_porc_deto,
                               p_C013            => v_S_TOTAL_ITEM_DETO, --i_s_total_item_deto,
                               p_C014            => v('P135_DPRE_PREC_UNIT_DETO'), --i_dpre_prec_unit_deto,
                               p_C015            => v('P135_DPRE_PREC_UNIT_RECA'), --i_dpre_prec_unit_reca,
                               p_C016            => v_S_TOTAL_ITEM_RECA, --i_s_total_item_reca,
                               p_C017            => p_dpre_prec_unit_list,
                               p_C018            => v('P135_PROD_MAXI_PORC_DESC'), --i_prod_maxi_porc_desc,
                               p_C019            => p_prod_desc,
                               p_C020            => p_dpre_lote_codi,
                               p_C021            => p_s_prec_maxi_deto,
                               p_C022            => p_dpre_prec_unit_neto,
                               p_C023            => p_ide_indi_vali_prec_mini,
                               p_C024            => v('P135_LIDE_MAXI_PORC_DETO'), --lide_maxi_porc_deto,
                               p_C025            => null, --dpre_obse,
                               p_c026            => p_DPRE_PORC_DETO_TOTA,
                               p_C027            => v_S_TOTAL_ITEM, --s_total_item
                               p_c031            => v_S_TOTAL_ITEM_MOST,
                               p_c032            => v('P135_EXDE_TIPO'), --P135_exde_tipo,
                               p_c033            => v('P135_DPRE_IMPU_CODI'), --dpre_impu_codi,
                               p_c034            => v('P135_COBA_FACT_CONV'), --coba_fact_conv
                               p_c036            =>v('P135_CONC_DBCR'));
  
  end pp_add_det;

  procedure pp_muestra_tipo_movi(p_pres_timo_codi           in number,
                                 p_timo_indi_cont_cred      out varchar2,
                                 p_pres_afec_sald           out varchar2,
                                 p_movi_emit_reci           out varchar2,
                                 p_s_timo_calc_iva          out varchar2,
                                 p_movi_oper_codi           out varchar2,
                                 p_movi_dbcr                out varchar2,
                                 p_timo_tica_codi           out varchar2,
                                 p_s_timo_indi_caja         out varchar2,
                                 p_tico_codi                out varchar2,
                                 p_tico_fech_rein           out varchar2,
                                 p_timo_indi_apli_adel_fopa out varchar2,
                                 p_tico_indi_vali_nume      out varchar2,
                                 p_timo_dbcr_caja           out varchar2,
                                 p_tico_indi_timb           out varchar2,
                                 p_TICO_INDI_HABI_TIMB      out varchar2,
                                 p_tico_indi_timb_auto      out varchar2,
                                 p_tico_indi_vali_timb      out varchar2,
                                 p_movi_timo_indi_sald      out varchar2) is
  begin
    select --timo_desc,
     timo_indi_cont_cred,
     timo_afec_sald,
     timo_emit_reci,
     nvl(timo_calc_iva, 'S'),
     timo_codi_oper,
     timo_dbcr,
     timo_tica_codi,
     timo_indi_caja,
     timo_tico_codi,
     tico_fech_rein,
     timo_indi_apli_adel_fopa,
     tico_indi_vali_nume,
     timo_dbcr_caja,
     tico_indi_timb,
     TICO_INDI_HABI_TIMB,
     tico_indi_timb_auto,
     tico_indi_vali_timb
      into --p_s_tipo_mov,
           p_timo_indi_cont_cred,
           p_pres_afec_sald,
           p_movi_emit_reci,
           p_s_timo_calc_iva,
           p_movi_oper_codi,
           p_movi_dbcr,
           p_timo_tica_codi,
           p_s_timo_indi_caja,
           p_tico_codi,
           p_tico_fech_rein,
           p_timo_indi_apli_adel_fopa,
           p_tico_indi_vali_nume,
           p_timo_dbcr_caja,
           p_tico_indi_timb,
           p_TICO_INDI_HABI_TIMB,
           p_tico_indi_timb_auto,
           p_tico_indi_vali_timb
      from come_tipo_movi, come_tipo_comp a
     where timo_tico_codi = tico_codi(+)
       and timo_codi_oper = parameter.p_codi_oper
       and timo_codi = p_pres_timo_codi;
  
    p_movi_timo_indi_sald := p_pres_afec_sald;
    if p_movi_emit_reci <> parameter.p_emit_reci then
      -- p_s_tipo_mov      := null;
      p_pres_afec_sald  := null;
      p_movi_emit_reci  := null;
      p_s_timo_calc_iva := null;
      pl_me('Tipo de Movimiento no valido para esta operacion');
    end if;
  
    if p_movi_oper_codi <> parameter.p_codi_oper then
      pl_me('Tipo de Movimiento no valido para esta operacion');
    end if;
  
  Exception
    when no_data_found then
      --p_s_tipo_mov      := null;
      p_pres_afec_sald  := null;
      p_movi_emit_reci  := null;
      p_s_timo_calc_iva := null;
      pl_me('Tipo de Movimiento inexistente');
    When too_many_rows then
      pl_me('Tipo de Movimiento duplicado');
  End pp_muestra_tipo_movi;

  procedure pp_muestra_impu(p_movi_dbcr                in varchar2,
                            p_dpre_impu_codi           in out number,
                            p_s_timo_calc_iva          in varchar2,
                            p_deta_impu_desc           out varchar2,
                            p_deta_impu_porc           out varchar2,
                            p_deta_impu_porc_base_impo out varchar2,
                            p_deta_impu_indi_impu_incl out varchar2,
                            p_deta_impu_conc_codi      out varchar2) is
  begin
  
    --pl_me('Hello world.. fff fffff....');
    select impu_desc,
           impu_porc,
           impu_porc_base_impo,
           impu_indi_baim_impu_incl
      into p_deta_impu_desc,
           p_deta_impu_porc,
           p_deta_impu_porc_base_impo,
           p_deta_impu_indi_impu_incl
      from come_impu
     where impu_codi = p_dpre_impu_codi;
  
    --si El tipo de movimiento tiene el indicador de calculo de iva 'N'
    --entonces siempre ser? exento....
  
    if p_s_timo_calc_iva = 'N' then
      p_dpre_impu_codi           := parameter.p_codi_impu_exen;
      p_deta_impu_porc           := 0;
      p_deta_impu_porc_base_impo := 0;
    end if;
    begin
      select decode(p_movi_dbcr,
                    'C',
                    impu_conc_codi_ivcr,
                    impu_conc_codi_ivdb) conc_iva
        into p_deta_impu_conc_codi
        from come_impu
       where impu_codi = p_dpre_impu_codi;
    
    exception
      when no_data_found then
        pl_me('Concepto de impuesto Inexistente');
    end;
  
  exception
    when no_data_found then
      pl_me('Tipo de Impuesto inexistente');
    when too_many_rows then
      pl_me('Tipo de Impuesto duplicado');
  end pp_muestra_impu;

  FUNCTION fp_validar_coba_codi(p_dpre_prod_codi in number,
                                p_prod_codi_alfa in number) RETURN number IS
    v_cont number;
  BEGIN
    select count(*)
      into v_cont
      from come_prod, come_prod_coba_deta d
     where d.coba_prod_codi = p_dpre_prod_codi
       and prod_codi_alfa = p_prod_codi_alfa;
  
    return v_cont;
  Exception
    when no_data_found then
      return null;
    when others then
      pl_me(sqlerrm);
    
  END fp_validar_coba_codi;

  procedure pp_buscar_prod_cod_barr(p_prod_codi_alfa in number,
                                    p_empr_codi      in number,
                                    p_dpre_medi_codi out number,
                                    p_coba_codi_barr out number,
                                    p_coba_fact_conv out number) is
    v_indi_inac varchar2(1);
  
  begin
  
    select nvl(prod_indi_inac, 'N'),
           coba_medi_codi,
           coba_codi_barr,
           coba_fact_conv
      into v_indi_inac,
           p_dpre_medi_codi,
           p_coba_codi_barr,
           p_coba_fact_conv
      from come_prod, come_prod_coba_deta
     where prod_codi = coba_prod_codi
       and nvl(prod_empr_codi, 1) = p_empr_codi
       and upper(ltrim(rtrim(coba_codi_barr))) =
           upper(ltrim(rtrim(p_prod_codi_alfa)));
  
    if v_indi_inac = 'S' then
      pl_me('El producto se encuentra inactivo!');
    end if;
  
    /*if get_item_property('bdet.coba_codi_barr', navigable) = 'TRUE' then
     set_item_property('bdet.coba_codi_barr', navigable, property_false);
    end if;*/
  
    --return true;
  
  Exception
    when no_data_found then
      null; --return false;
    when others then
      null; --return false;
  end pp_buscar_prod_cod_barr;

  procedure pp_mostrar_unid_medi(p_codi in number, p_desc out varchar2) is
  begin
  
    select ltrim(rtrim(medi_desc_abre))
      into p_desc
      from come_unid_medi u
     where medi_codi = p_codi;
  
  Exception
    When no_data_found then
      p_desc := 'No tiene U.M. asignado';
    when others then
      pl_me(sqlerrm);
  end pp_mostrar_unid_medi;

  procedure pp_busca_exde_deto(p_dpre_prod_codi      in number,
                               p_dpre_cant_medi      in number,
                               p_dpre_medi_codi      in number,
                               p_dpre_prec_unit_list in number,
                               
                               p_exde_codi      out number,
                               p_exde_deto_prec out varchar2,
                               p_exde_tipo      out varchar2,
                               p_exde_peri      out varchar2,
                               p_exde_porc      out number,
                               p_exde_impo      out number,
                               p_dpre_porc_deto in out number,
                               p_dpre_prec_unit in out number) is
  begin
    --Por cliente
  

    bcab.pres_clpr_codi      := v('P135_CLPR_CODI');
    bcab.pres_fech_emis      := v('P135_S_PRES_FECH_EMIS');
    bcab.pres_fech_emis_hora := v('P135_S_PRES_FECH_EMIS');
    bcab.pres_mone_codi      := v('P135_PRES_MONE_CODI');
  
    bcab.pres_list_prec := v('P135_PRES_LIST_PREC');
    bcab.pres_orte_codi := v('P135_PRES_ORTE_CODI');
    bcab.clpr_segm_codi := v('P135_CLPR_SEGM_CODI');

    pp_busca_exce_deto_fp_impo('D', --detalle
                               bcab.pres_clpr_codi,
                               bcab.pres_fech_emis,
                               bcab.pres_fech_emis_hora,
                               bcab.pres_mone_codi,
                               --
                               p_exde_codi,
                               p_exde_deto_prec,
                               p_exde_tipo,
                               p_exde_peri,
                               p_exde_porc,
                               p_exde_impo);
  
    --- Por producto
 
    if nvl(p_exde_tipo, 'N') in ('N', 'P', 'C', 'O') then
      -- "P" en caso que sea el segundo registro y el primero haya tenido excepcion.
      pp_busca_exce_deto_prod(bcab.pres_clpr_codi,
                              p_dpre_prod_codi,
                              bcab.pres_list_prec,
                              bcab.pres_orte_codi,
                              bcab.clpr_segm_codi,
                              bcab.pres_fech_emis,
                              bcab.pres_mone_codi,
                              --
                              p_exde_codi,
                              p_exde_deto_prec,
                              p_exde_tipo,
                              p_exde_peri,
                              p_exde_porc,
                              p_exde_impo);
    end if;
  
    --Por cantidad
    if nvl(p_exde_tipo, 'N') in ('N', 'C') then
      -- "C" en caso que sea el segundo registro y el primero haya tenido excepcion.
      pp_busca_exce_deto_cant(bcab.pres_clpr_codi,
                              p_dpre_prod_codi,
                              bcab.pres_list_prec,
                              bcab.pres_orte_codi,
                              bcab.clpr_segm_codi,
                              bcab.pres_fech_emis,
                              bcab.pres_mone_codi,
                              p_dpre_cant_medi,
                              --
                              p_exde_codi,
                              p_exde_deto_prec,
                              p_exde_tipo,
                              p_exde_peri,
                              p_exde_porc,
                              p_exde_impo);
    end if;
  
    --Por obsequio
    if nvl(p_exde_tipo, 'N') in ('N', 'O') then
      -- "C" en caso que sea el segundo registro y el primero haya tenido excepcion.
      pp_busca_exce_deto_obse(bcab.pres_clpr_codi,
                              p_dpre_prod_codi,
                              bcab.pres_fech_emis,
                              bcab.pres_mone_codi,
                              p_dpre_cant_medi,
                              p_dpre_medi_codi,
                              --
                              p_exde_codi,
                              p_exde_deto_prec,
                              p_exde_tipo,
                              p_exde_peri,
                              p_exde_porc,
                              p_exde_impo);
    end if;
    if nvl(parameter.p_indi_suge_exde, 'S') = 'S' then
      --Indicador para que solo sugiera descuentos en la validacion del detalle
      if nvl(p_exde_deto_prec, 'I') = 'P' then
        if p_dpre_porc_deto is null then
          if nvl(p_exde_porc, 0) <> 0 then
            p_dpre_porc_deto := p_exde_porc;
          end if;
        end if;
      else
        if p_dpre_prec_unit = p_dpre_prec_unit_list then
          if nvl(p_exde_impo, 0) <> 0 then
            p_dpre_prec_unit := p_exde_impo;
          end if;
        end if;
      end if;
    end if;
    

  
  end pp_busca_exde_deto;

  PROCEDURE pp_busca_exce_deto_fp_impo(p_indi_cab_deta  in varchar2,
                                       p_clpr_codi      in number,
                                       p_fech_emis      in date,
                                       p_fech_emis_hora in date,
                                       p_mone_codi      in number,
                                       p_exde_codi      out number,
                                       p_deto_prec      out varchar2,
                                       p_exde_tipo      out varchar2,
                                       p_exde_peri      out varchar2,
                                       p_exde_porc      out number,
                                       p_exde_impo      out number) IS
    v_exde_codi      number;
    v_exde_tipo      varchar2(1) := 'N';
    v_exde_form      varchar2(1) := '';
    v_exde_porc      number;
    v_exde_impo      number;
    v_deto_prec      varchar2(1) := 'N'; -- si es importe o porcentaje
    v_exde_tipo_peri varchar2(1);
    v_exde_fech_desd date;
    v_exde_fech_hast date;
    v_exde_mone_codi number;
  
    cursor c_exce_deto is
      select exde_codi,
             exde_tipo,
             exde_form,
             exde_clpr_codi,
             exde_lipr_codi,
             exde_orte_codi,
             exde_segm_codi,
             exde_prod_codi,
             decode(exde_porc, null, 'I', 'P') deto_prec,
             exde_porc,
             exde_impo,
             exde_tipo_peri,
             exde_fech_desd,
             exde_fech_hast,
             exde_mone_codi
        from come_exce_deto
       where (p_indi_cab_deta = 'C' and exde_tipo in ('F', 'I'))
          or (p_indi_cab_deta = 'D' and exde_tipo = 'K')
         and exde_clpr_codi = p_clpr_codi
         and exde_form = 'C'
         and ((exde_tipo_peri = 'V') or
             (exde_tipo_peri in ('D', 'M') and
             p_fech_emis between exde_fech_desd and exde_fech_hast) or
             (exde_tipo_peri = 'H' and
             p_fech_emis_hora between exde_fech_desd and exde_fech_hast))
         and exde_esta = 'A'
         and (exde_pres_codi is null or
             (exde_pres_codi is not null and bcab.pres_codi is not null and
             exde_pres_codi = bcab.pres_codi))
       order by exde_codi;
  
  BEGIN
    for r in c_exce_deto loop
      v_exde_codi      := r.exde_codi;
      v_exde_tipo      := r.exde_tipo;
      v_exde_form      := r.exde_form;
      v_deto_prec      := r.deto_prec;
      v_exde_porc      := nvl(r.exde_porc, 0);
      v_exde_impo      := nvl(r.exde_impo, 0);
      v_exde_tipo_peri := r.exde_tipo_peri;
      v_exde_fech_desd := r.exde_fech_desd;
      v_exde_fech_hast := r.exde_fech_hast;
      v_exde_mone_codi := r.exde_mone_codi;
      exit;
    end loop;
    -- si es N no existe excepciones de descuentos.
    if nvl(v_deto_prec, 'N') <> 'N' then
      p_deto_prec := v_deto_prec;
      p_exde_porc := v_exde_porc;
      p_exde_impo := v_exde_impo;
      p_exde_codi := v_exde_codi;
      p_exde_peri := v_exde_tipo_peri;
      p_exde_tipo := v_exde_tipo;
    
      if nvl(v_exde_impo, 0) <> 0 then
        if v_exde_mone_codi is null or v_exde_mone_codi = p_mone_codi then
          p_exde_impo := v_exde_impo;
        else
          if p_mone_codi = parameter.p_codi_mone_mmnn then
            v_exde_impo := round(v_exde_impo *
                                 nvl(bcab.pres_tasa_come,
                                     bcab.pres_tasa_mone),
                                 bcab.pres_mone_cant_deci);
          else
            v_exde_impo := round(v_exde_impo /
                                 nvl(bcab.pres_tasa_come,
                                     bcab.pres_tasa_mone),
                                 bcab.pres_mone_cant_deci);
          end if;
          p_exde_impo := v_exde_impo;
        end if;
      end if;
    
    else
      p_deto_prec := v_deto_prec;
      p_exde_porc := null;
      p_exde_impo := null;
      p_exde_codi := null;
      p_exde_peri := null;
      p_exde_tipo := 'N';
    end if;
  
  END pp_busca_exce_deto_fp_impo;

  PROCEDURE pp_busca_exce_deto_prod(p_clpr_codi in number,
                                    p_prod_codi in number,
                                    p_lipr_codi in number,
                                    p_orte_codi in number,
                                    p_segm_codi in number,
                                    p_fech_emis in date,
                                    p_mone_codi in number,
                                    --
                                    p_exde_codi out number,
                                    p_deto_prec out varchar2,
                                    p_exde_tipo out varchar2,
                                    p_exde_peri out varchar2,
                                    p_exde_porc out number,
                                    p_exde_impo out number) IS
  
    v_exde_codi      number;
    v_exde_tipo      varchar2(1) := 'N';
    v_exde_form      varchar2(1) := '';
    v_exde_porc      number;
    v_exde_impo      number;
    v_deto_prec      varchar2(1) := 'N'; -- si es importe o porcentaje
    v_exde_tipo_peri varchar2(1);
    v_exde_fech_desd date;
    v_exde_fech_hast date;
    v_exde_mone_codi number;
  
    cursor c_exce_deto is
      select exde_codi,
             exde_tipo,
             exde_form,
             decode(exde_porc, null, 'I', 'P') deto_prec,
             exde_porc,
             exde_impo,
             exde_tipo_peri,
             exde_fech_desd,
             exde_fech_hast,
             exde_mone_codi
        from come_exce_deto
       where exde_tipo = 'P'
         and -- por producto
             ((exde_form = 'C' and exde_clpr_codi = p_clpr_codi and
             (exde_prod_codi = p_prod_codi or exde_prod_codi is null)) or
             (exde_form = 'P' and exde_prod_codi = p_prod_codi) or
             (exde_form = 'F' and exde_orte_codi = p_orte_codi) or
             (exde_form = 'L' and exde_lipr_codi = p_lipr_codi) or
             (exde_form = 'M' and exde_lipr_codi = p_lipr_codi and
             exde_segm_codi = p_segm_codi and
             exde_orte_codi = p_orte_codi))
         and ((exde_tipo_peri = 'V') or
             (exde_tipo_peri = 'D' and p_fech_emis between exde_fech_desd and
             exde_fech_hast))
         and (exde_pres_codi is null or
             (exde_pres_codi is not null and bcab.pres_codi is not null and
             exde_pres_codi = bcab.pres_codi))
         and exde_esta = 'A';
  
  BEGIN
    for r in c_exce_deto loop
      v_exde_codi      := r.exde_codi;
      v_exde_tipo      := r.exde_tipo;
      v_exde_form      := r.exde_form;
      v_deto_prec      := r.deto_prec;
      v_exde_porc      := nvl(r.exde_porc, 0);
      v_exde_impo      := nvl(r.exde_impo, 0);
      v_exde_tipo_peri := r.exde_tipo_peri;
      v_exde_fech_desd := r.exde_fech_desd;
      v_exde_fech_hast := r.exde_fech_hast;
      v_exde_mone_codi := r.exde_mone_codi;
      exit;
    end loop;
  
    -- si es N no existe excepciones de descuentos.
    if nvl(v_deto_prec, 'N') <> 'N' then
      p_deto_prec := v_deto_prec;
      p_exde_porc := v_exde_porc;
      p_exde_impo := v_exde_impo;
      p_exde_codi := v_exde_codi;
      p_exde_tipo := v_exde_tipo;
      p_exde_peri := v_exde_tipo_peri;
    
      if nvl(v_exde_impo, 0) <> 0 then
        if v_exde_mone_codi is null or v_exde_mone_codi = p_mone_codi then
          p_exde_impo := v_exde_impo;
        else
          if p_mone_codi = parameter.p_codi_mone_mmnn then
            v_exde_impo := round(v_exde_impo * bcab.pres_tasa_come,
                                 parameter.p_cant_deci_mmnn);
          else
            v_exde_impo := round(v_exde_impo / bcab.pres_tasa_come,
                                 bcab.pres_mone_cant_deci);
          end if;
          p_exde_impo := v_exde_impo;
        end if;
      end if;
    
    else
      p_deto_prec := v_deto_prec;
      p_exde_porc := null;
      p_exde_impo := null;
      p_exde_codi := null;
      p_exde_peri := null;
      p_exde_tipo := v_exde_tipo;
    end if;
  END;
  procedure pp_busca_exce_deto_cant(p_clpr_codi in number,
                                    p_prod_codi in number,
                                    p_lipr_codi in number,
                                    p_orte_codi in number,
                                    p_segm_codi in number,
                                    p_fech_emis in date,
                                    p_mone_codi in number,
                                    --
                                    p_exde_cant_fact in number,
                                    p_exde_codi      out number,
                                    p_deto_prec      out varchar2,
                                    p_exde_tipo      out varchar2,
                                    p_exde_peri      out varchar2,
                                    p_exde_porc      out number,
                                    p_exde_impo      out number) is
  
    v_exde_codi      number;
    v_exde_tipo      varchar2(1) := 'N';
    v_exde_form      varchar2(1) := '';
    v_exde_porc      number;
    v_exde_impo      number;
    v_deto_prec      varchar2(1) := 'N'; -- si es importe o porcentaje
    v_exde_tipo_peri varchar2(1);
    v_exde_fech_desd date;
    v_exde_fech_hast date;
    v_exde_mone_codi number;
  
    cursor c_exce_deto is
      select exde_codi,
             exde_tipo,
             exde_form,
             decode(exde_impo, null, 'P', 'I') deto_prec,
             exde_porc,
             exde_impo,
             exde_tipo_peri,
             exde_fech_desd,
             exde_fech_hast,
             exde_mone_codi
        from come_exce_deto
       where exde_tipo = 'C'
         and -- por cantidad
             ((exde_form = 'C' and exde_clpr_codi = p_clpr_codi and
             exde_prod_codi = p_prod_codi and
             exde_cant_fact = p_exde_cant_fact) or
             (exde_form = 'P' and exde_prod_codi = p_prod_codi and
             exde_cant_fact = p_exde_cant_fact) or
             (exde_form = 'F' and exde_orte_codi = p_orte_codi and
             exde_prod_codi = p_prod_codi and
             exde_cant_fact = p_exde_cant_fact) or
             (exde_form = 'L' and exde_lipr_codi = p_lipr_codi and
             exde_prod_codi = p_prod_codi and
             exde_cant_fact = p_exde_cant_fact) or
             (exde_form = 'M' and exde_lipr_codi = p_lipr_codi and
             exde_segm_codi = p_segm_codi and
             exde_orte_codi = p_orte_codi and
             exde_prod_codi = p_prod_codi and
             exde_cant_fact = p_exde_cant_fact))
         and ((exde_tipo_peri = 'V') or
             (exde_tipo_peri = 'D' and p_fech_emis between exde_fech_desd and
             exde_fech_hast))
         and exde_esta = 'A'
         and (exde_pres_codi is null or
             (exde_pres_codi is not null and bcab.pres_codi is not null and
             exde_pres_codi = bcab.pres_codi));
  
  begin
    for r in c_exce_deto loop
      v_exde_codi := r.exde_codi;
      v_exde_tipo := r.exde_tipo;
      v_exde_form := r.exde_form;
      v_deto_prec := r.deto_prec;
      v_exde_porc := nvl(r.exde_porc, 0);
    
      if r.exde_impo is not null then
        v_exde_impo := r.exde_impo;
      else
        v_exde_impo := null;
      end if;
    
      v_exde_tipo_peri := r.exde_tipo_peri;
      v_exde_fech_desd := r.exde_fech_desd;
      v_exde_fech_hast := r.exde_fech_hast;
      v_exde_mone_codi := r.exde_mone_codi;
      exit;
    end loop;
    -- si es N no existe excepciones de descuentos.
    if nvl(v_deto_prec, 'N') <> 'N' then
      p_deto_prec := v_deto_prec;
      p_exde_porc := v_exde_porc;
      p_exde_impo := v_exde_impo;
      p_exde_codi := v_exde_codi;
      p_exde_tipo := v_exde_tipo;
      p_exde_peri := v_exde_tipo_peri;
    
      if nvl(v_exde_impo, 0) <> 0 then
        if v_exde_mone_codi is null or v_exde_mone_codi = p_mone_codi then
          p_exde_impo := v_exde_impo;
        else
          if p_mone_codi = parameter.p_codi_mone_mmnn then
            v_exde_impo := round(v_exde_impo * nvl(bcab.pres_tasa_come, 1),
                                 parameter.p_cant_deci_mmnn);
          else
            v_exde_impo := round(v_exde_impo / nvl(bcab.pres_tasa_come, 1),
                                 bcab.pres_mone_cant_deci);
          end if;
          p_exde_impo := v_exde_impo;
        end if;
      end if;
    
    else
      p_deto_prec := v_deto_prec;
      p_exde_porc := null;
      p_exde_impo := null;
      p_exde_codi := null;
      p_exde_peri := null;
      p_exde_tipo := v_exde_tipo;
    end if;
  end;

  procedure pp_busca_exce_deto_obse(p_clpr_codi      in number,
                                    p_prod_codi      in number,
                                    p_fech_emis      in date,
                                    p_mone_codi      in number,
                                    p_exde_cant_fact in number,
                                    p_exde_medi_codi in number,
                                    --
                                    p_exde_codi out number,
                                    p_deto_prec out varchar2,
                                    p_exde_tipo out varchar2,
                                    p_exde_peri out varchar2,
                                    p_exde_porc out number,
                                    p_exde_impo out number) is
  
    v_exde_codi      number;
    v_exde_tipo      varchar2(1) := 'N';
    v_exde_form      varchar2(1) := '';
    v_exde_porc      number;
    v_exde_impo      number;
    v_deto_prec      varchar2(1) := 'N'; -- si es importe o porcentaje
    v_exde_tipo_peri varchar2(1);
    v_exde_fech_desd date;
    v_exde_fech_hast date;
    v_exde_mone_codi number;
  
    cursor c_exce_deto is
      select exde_codi,
             exde_tipo,
             exde_form,
             'I' deto_prec,
             100 exde_porc,
             0 exde_impo,
             exde_tipo_peri,
             exde_fech_desd,
             exde_fech_hast,
             exde_mone_codi
        from come_exce_deto
       where exde_tipo = 'O'
         and -- por cantidad
             ((exde_form = 'C' and exde_clpr_codi = p_clpr_codi and
             exde_prod_codi = p_prod_codi and
             exde_cant_fact >= p_exde_cant_fact and
             exde_medi_codi = p_exde_medi_codi) or
             (exde_form = 'P' and exde_prod_codi = p_prod_codi and
             exde_cant_fact >= p_exde_cant_fact and
             exde_medi_codi = p_exde_medi_codi))
         and ((exde_tipo_peri = 'V') or
             (exde_tipo_peri = 'D' and p_fech_emis between exde_fech_desd and
             exde_fech_hast))
         and exde_esta = 'A'
         and (exde_pres_codi is null or
             (exde_pres_codi is not null and bcab.pres_codi is not null and
             exde_pres_codi = bcab.pres_codi));
  
  begin
    for r in c_exce_deto loop
      v_exde_codi := r.exde_codi;
      v_exde_tipo := r.exde_tipo;
      v_exde_form := r.exde_form;
      v_deto_prec := r.deto_prec;
      v_exde_porc := nvl(r.exde_porc, 0);
    
      if r.exde_impo is not null then
        v_exde_impo := r.exde_impo;
      else
        v_exde_impo := null;
      end if;
    
      v_exde_tipo_peri := r.exde_tipo_peri;
      v_exde_fech_desd := r.exde_fech_desd;
      v_exde_fech_hast := r.exde_fech_hast;
      v_exde_mone_codi := r.exde_mone_codi;
      exit;
    end loop;
    -- si es N no existe excepciones de descuentos.
    if nvl(v_deto_prec, 'N') <> 'N' then
      p_deto_prec := v_deto_prec;
      p_exde_porc := v_exde_porc;
      p_exde_impo := v_exde_impo;
      p_exde_codi := v_exde_codi;
      p_exde_tipo := v_exde_tipo;
      p_exde_peri := v_exde_tipo_peri;
    
      if nvl(v_exde_impo, 0) <> 0 then
        if v_exde_mone_codi is null or v_exde_mone_codi = p_mone_codi then
          p_exde_impo := v_exde_impo;
        else
          if p_mone_codi = parameter.p_codi_mone_mmnn then
            v_exde_impo := round(v_exde_impo *
                                 nvl(bcab.pres_tasa_come,
                                     1 /*:bcab.movi_tasa_mone*/),
                                 parameter.p_cant_deci_mmnn);
          else
            v_exde_impo := round(v_exde_impo /
                                 nvl(bcab.pres_tasa_come,
                                     1 /*:bcab.movi_tasa_mone*/),
                                 bcab.pres_mone_cant_deci);
          end if;
          p_exde_impo := v_exde_impo;
        end if;
      end if;
    
    else
      p_deto_prec := v_deto_prec;
      p_exde_porc := null;
      p_exde_impo := null;
      p_exde_codi := null;
      p_exde_peri := null;
      p_exde_tipo := v_exde_tipo;
    end if;
  end;

  PROCEDURE pp_traer_datos_codi_barr(p_prod_codi in number,
                                     p_medi_codi out number,
                                     p_codi_barr in varchar2,
                                     p_fact_conv out number) IS
  BEGIN
  
    select d.coba_fact_conv, coba_medi_Codi
      into p_fact_conv, p_medi_Codi
      from come_prod_coba_deta d
     where d.coba_codi_barr = p_codi_barr
       and d.coba_prod_codi = p_prod_codi;
  
  Exception
    when no_data_found then
      p_medi_codi := null;
      p_fact_conv := null;
    when too_many_rows then
      begin
        select d.coba_fact_conv, d.coba_medi_Codi
          into p_fact_conv, p_medi_Codi
          from come_prod_coba_deta d
         where d.coba_prod_codi = p_prod_codi
           and d.coba_codi_barr = p_codi_barr
           and d.coba_nume_item =
               (select min(coba_nume_item)
                  from come_prod_coba_deta
                 where coba_prod_codi = p_prod_codi
                   and coba_codi_barr = p_codi_barr);
      end;
    when others then
      pl_me(sqlerrm);
  END pp_traer_datos_codi_barr;

  procedure pp_valida_codi_barr(p_dpre_prod_codi in number,
                                p_coba_codi_barr in varchar2,
                                p_pres_mone_codi in number,
                                p_pres_list_prec in number,
                                p_pres_tasa_come in number,
                                
                                p_coba_fact_conv           out number,
                                p_dpre_medi_codi           out number,
                                p_medi_desc_abre           out varchar2,
                                p_dpre_prec_unit_list      out varchar2,
                                p_lide_indi_vali_prec_mini out varchar2,
                                p_prod_maxi_porc_desc      out varchar2,
                                p_lide_maxi_porc_deto      out varchar2,
                                p_dpre_prec_unit           out number) is
  begin
    --pl_me(p_dpre_prec_unit);
  
    pp_traer_datos_codi_barr(p_dpre_prod_codi,
                             p_dpre_medi_codi,
                             p_coba_codi_barr,
                             p_coba_fact_conv);
  
    pp_mostrar_unid_medi(p_dpre_medi_codi, p_medi_desc_abre);
  
    /*if (p_coba_codi_barr <> nvl(p_coba_codi_barr_ante, '-9999'))
    or (nvl(p_dpre_prec_unit,0) = 0 and nvl(p_exde_tipo, 'N') <> 'O') then */
  
    pp_busca_prec_list_prec(p_pres_list_prec,
                            p_pres_mone_codi,
                            p_dpre_prod_codi,
                            p_dpre_medi_codi,
                            p_pres_tasa_come,
                            p_pres_mone_codi,
                            v('P135_PRES_TASA_MONE'), --p_pres_tasa_mone,
                            v('p135_pres_mone_cant_deci'), -- p_pres_mone_cant_deci,
                            p_dpre_prec_unit_list,
                            p_lide_indi_vali_prec_mini,
                            p_prod_maxi_porc_desc,
                            p_lide_maxi_porc_deto);
  
    --p_coba_codi_barr_ante := p_coba_codi_barr;
  
    if nvl(parameter.p_indi_cons_pres, 'N') = 'N' then
      p_dpre_prec_unit := p_dpre_prec_unit_list;
    end if;
  
  end pp_valida_codi_barr;

  procedure pp_mostrar_prec_maxi_deto(p_indi_prod_ortr               in varchar2,
                                      p_dpre_prec_unit_list          in number,
                                      p_dpre_prod_codi               in varchar2,
                                      p_pres_list_prec               in varchar2,
                                      p_pres_mone_codi               in varchar2,
                                      p_pres_tasa_mone               in varchar2,
                                      p_exde_tipo                    in varchar2,
                                      p_pres_orte_codi               in varchar2,
                                      p_exde_deto_prec               in varchar2,
                                      p_exde_porc                    in varchar2,
                                      p_exde_impo                    in varchar2,
                                      p_lide_maxi_porc_deto          in varchar2,
                                      p_pres_mone_cant_deci          in number,
                                      p_prod_maxi_porc_desc          in varchar2,
                                      p_clpr_indi_vali_prec_mini     in varchar2,
                                      p_lide_indi_vali_prec_mini     in varchar2,
                                      p_user_ind_r_det_sin_exc       in varchar2,
                                      p_pres_indi_user_deto          in varchar2,
                                      p_clpr_segm_codi               in varchar2,
                                      p_clpr_maxi_porc_deto          in varchar2,
                                      p_s_orte_maxi_porc             in varchar2,
                                      p_empl_maxi_porc_deto          in varchar2,
                                      p_dpre_impu_codi               in varchar2,
                                      p_user_indi_real_deto_sin_exce in varchar2,
                                      
                                      p_s_prec_maxi_deto          out varchar2,
                                      p_dpre_prod_prec_maxi_deto  out varchar2,
                                      p_dpre_prod_prec_max_dto_ex out varchar2,
                                      p_dpre_indi_prec_maxi_deto  out varchar2) is
    --v_clpr_maxi_porc_deto     number;
    v_prec_maxi_deto_list  number;
    v_prec_maxi_deto_matr  number;
    v_prec_maxi_deto_util  number;
    v_prec_maxi_deto_exce  number;
    v_prec_maxi_deto_mayor number;
    --v_lide_mone_codi          number;
    v_indi_prec_maxi_deto varchar2(4);
  
    --Referencias para indicador de Maximo Descuento que se aplica  
    -- NMC= sin excepcion,por Matriz-Cliente
    -- NMM= sin excepcion,por Matriz-Matriz Precio
    -- NML= sin excepcion,por Matriz-Lista de Precio
    -- NMP= sin excepcion,por Matriz-Producto
    -- NMF= sin excepcion,por Matriz-Forma de Pago
    -- NMV= sin excepcion,por Matriz-Vendedor
    -- NL = sin excepcion,por Lista de Precio
    -- NU = sin excepcion,por Utilidad
    -- P = con excepcion,por Producto
    -- C = con excepcion,por Cantidad
    -- O = con excepcion,por Obsequio
    -- K = con excepcion,por Cliente al Costo  
    -- I = con excepcion,por Importe minimo cuota
    -- F = con excepcion,por Entrega minima
  
  begin
  
    if p_indi_prod_ortr = 'S' and nvl(p_dpre_prec_unit_list, 0) <> 0 then
      p_s_prec_maxi_deto          := nvl(p_dpre_prec_unit_list, 0);
      p_dpre_prod_prec_maxi_deto  := p_s_prec_maxi_deto;
      p_dpre_prod_prec_max_dto_ex := 0;
      p_dpre_indi_prec_maxi_deto  := 'NL';
    elsif p_indi_prod_ortr = 'O' and nvl(p_dpre_prec_unit_list, 0) <> 0 then
      p_s_prec_maxi_deto          := nvl(p_dpre_prec_unit_list, 0);
      p_dpre_prod_prec_maxi_deto  := p_s_prec_maxi_deto;
      p_dpre_prod_prec_max_dto_ex := 0;
      p_dpre_indi_prec_maxi_deto  := 'NL';
    elsif p_indi_prod_ortr = 'P' then
    
      -- si no existe excepciones de productos
      --if nvl(:bdet.exde_tipo,'N') = 'N' then  
      --Si el Cliente o LP para el producto tiene marcado indicador "valida precio minimo", precio minimo es precio de lista.
      pp_most_prec_maxi_deto_list(p_dpre_prec_unit_list,
                                  p_indi_prod_ortr,
                                  p_clpr_indi_vali_prec_mini,
                                  p_lide_indi_vali_prec_mini,
                                  p_user_ind_r_det_sin_exc,
                                  p_pres_indi_user_deto,
                                  v_prec_maxi_deto_list);
    
 
     pp_most_prec_maxi_deto_matr(p_dpre_prec_unit_list,
                                  p_lide_maxi_porc_deto,
                                  p_prod_maxi_porc_desc,
                                  p_empl_maxi_porc_deto,
                                  p_clpr_maxi_porc_deto,
                                  p_s_orte_maxi_porc,
                                  p_pres_orte_codi,
                                  p_clpr_segm_codi,
                                  p_pres_indi_user_deto,
                                  p_pres_list_prec,
                                  p_user_indi_real_deto_sin_exce,
                                  p_pres_mone_cant_deci,
                                  --
                                  v_prec_maxi_deto_matr,
                                  v_indi_prec_maxi_deto); -- Indicador del tipo de Excepcion de Matriz
    

      pp_most_prec_maxi_deto_util(p_indi_prod_ortr,
                                  p_exde_tipo,
                                  p_dpre_prod_codi,
                                  p_pres_mone_codi,
                                  p_pres_tasa_mone,
                                  p_pres_mone_cant_deci,
                                  p_dpre_impu_codi,
                                  p_user_indi_real_deto_sin_exce,
                                  p_pres_indi_user_deto,
                                  v_prec_maxi_deto_util);
    
         
      if nvl(v_prec_maxi_deto_list, 0) >= nvl(v_prec_maxi_deto_matr, 0) then
        v_prec_maxi_deto_mayor     := nvl(v_prec_maxi_deto_list, 0);
        p_dpre_indi_prec_maxi_deto := 'NL';
      else
        v_prec_maxi_deto_mayor     := nvl(v_prec_maxi_deto_matr, 0);
        p_dpre_indi_prec_maxi_deto := v_indi_prec_maxi_deto;
      end if;
    
      if nvl(v_prec_maxi_deto_mayor, 0) >= nvl(v_prec_maxi_deto_util, 0) then
        v_prec_maxi_deto_mayor := nvl(v_prec_maxi_deto_mayor, 0);
      else
        v_prec_maxi_deto_mayor     := nvl(v_prec_maxi_deto_util, 0);
        p_dpre_indi_prec_maxi_deto := 'NU';
      end if;
    
      p_s_prec_maxi_deto          := nvl(v_prec_maxi_deto_mayor, 0);
      p_dpre_prod_prec_maxi_deto  := p_s_prec_maxi_deto;
      p_dpre_prod_prec_max_dto_ex := 0;
    
      --else --excepciones de productos   
      if nvl(p_exde_tipo, 'N') <> 'N' then
        if nvl(p_exde_tipo, 'N') in ('P', 'C', 'O') then
          pp_most_prec_maxi_deto_exce(p_dpre_prec_unit_list,
                                      p_exde_deto_prec, --P=Porcentaje, I=Importe
                                      p_exde_porc,
                                      p_exde_impo,
                                      p_pres_mone_cant_deci,
                                      v_prec_maxi_deto_exce);
        
          v_prec_maxi_deto_mayor      := nvl(v_prec_maxi_deto_exce, 0);
          p_s_prec_maxi_deto          := nvl(v_prec_maxi_deto_mayor, 0);
          p_dpre_prod_prec_max_dto_ex := p_s_prec_maxi_deto;
        
        elsif nvl(p_exde_tipo, 'N') = 'K' then
          p_s_prec_maxi_deto := fa_devu_cost_prom(p_dpre_prod_codi,
                                                  parameter.p_codi_peri_sgte);
          if p_pres_mone_codi <> parameter.p_codi_mone_mmnn then
            p_s_prec_maxi_deto := round(p_s_prec_maxi_deto /
                                        nvl(p_pres_tasa_mone, 1),
                                        p_pres_mone_cant_deci);
          end if;
          p_dpre_prod_prec_max_dto_ex := p_s_prec_maxi_deto;
        else
          --No deberia de ingresar a este lugar al menos que exista un nuevo tipo de excepcion
          p_s_prec_maxi_deto          := nvl(p_dpre_prec_unit_list, 0);
          p_dpre_prod_prec_max_dto_ex := p_s_prec_maxi_deto;
        end if;
        p_dpre_indi_prec_maxi_deto := p_exde_tipo;
      end if;
    end if;
  
  
 
  end;

  procedure pp_most_prec_maxi_deto_list(p_prec_unit_list           in number,
                                        p_indi_prod_ortr           in varchar2,
                                        p_clpr_indi_vali_prec_mini in varchar2,
                                        p_lide_indi_vali_prec_mini in varchar2,
                                        p_user_ind_r_det_sin_exc   in varchar2,
                                        p_pres_indi_user_deto      in varchar2,
                                        p_prec_reto                out number) is
  
    v_clpr_indi_vali_prec_mini varchar2(1) := 'N';
    v_lide_indi_vali_prec_mini varchar2(1) := 'N';
  
  begin
  
    v_clpr_indi_vali_prec_mini := p_clpr_indi_vali_prec_mini;
  
    if p_indi_prod_ortr = 'P' then
      v_lide_indi_vali_prec_mini := p_lide_indi_vali_prec_mini;
    end if;
    --p_user_indi_real_deto_sin_exce 
    if nvl(p_pres_indi_user_deto, 'N') = 'N' and
       nvl(p_user_ind_r_det_sin_exc, 'N') = 'N' then
      if v_clpr_indi_vali_prec_mini = 'S' or
         v_lide_indi_vali_prec_mini = 'S' then
        p_prec_reto := p_prec_unit_list;
      end if;
    end if;
  
    p_prec_reto := nvl(p_prec_reto, 0);
  end pp_most_prec_maxi_deto_list;

  procedure pp_most_prec_maxi_deto_matr(p_prec_unit_list               in number,
                                        p_lide_maxi_porc_deto          in number,
                                        p_prod_maxi_porc_desc          in number,
                                        p_empl_maxi_porc_deto          in number,
                                        p_clpr_maxi_porc_deto          in number,
                                        p_s_orte_maxi_porc             in number,
                                        p_pres_orte_codi               in number,
                                        p_clpr_segm_codi               in number,
                                        p_pres_indi_user_deto          in varchar2,
                                        p_pres_list_prec               in number,
                                        p_user_indi_real_deto_sin_exce in varchar2,
                                        p_pres_mone_cant_deci          in number,
                                        --
                                        p_prec_mexi_deto      out number,
                                        p_indi_prec_maxi_deto out varchar2) is
  
    v_prod_maxi_porc_desc number;
    v_lide_maxi_porc_deto number;
    v_vend_maxi_porc_deto number;
    v_orte_maxi_porc      number;
    v_mapr_porc_deto      number;
    --v_dife                number;
    --v_porc                number;
  
    cursor c_matr is
      select m.made_refe, m.made_bloq
        from come_matr_deto m
       where m.made_refe is not null
         and upper(m.made_habi) = 'S'
       order by m.made_orde;
  
  begin
  
    v_prod_maxi_porc_desc := p_prod_maxi_porc_desc;
    v_lide_maxi_porc_deto := p_lide_maxi_porc_deto;
    v_vend_maxi_porc_deto := p_empl_maxi_porc_deto;
    v_orte_maxi_porc      := p_s_orte_maxi_porc;
  
    begin
      select nvl(m.mapr_porc_deto, 0)
        into v_mapr_porc_deto
        from come_matr_prec m
       where m.mapr_list_codi = p_pres_list_prec
         and m.mapr_segm_codi = p_clpr_segm_codi
         and m.mapr_orte_codi = p_pres_orte_codi;
    exception
      when no_data_found then
        v_mapr_porc_deto := 0;
      when others then
        v_mapr_porc_deto := 0;
    end;
  
    for k in c_matr loop
      if lower(k.made_refe) = 'cliente' then
        if p_clpr_maxi_porc_deto <> 0 then
          if nvl(p_pres_indi_user_deto, 'N') = 'N' and
             nvl(p_user_indi_real_deto_sin_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           p_clpr_maxi_porc_deto / 100),
                                           p_pres_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NMC';
          end if;
          exit;
        end if;
      
      elsif lower(k.made_refe) = 'matriz_precio' then
        if v_mapr_porc_deto <> 0 then
          if nvl(p_pres_indi_user_deto, 'N') = 'N' and
             nvl(p_user_indi_real_deto_sin_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           v_mapr_porc_deto / 100),
                                           p_pres_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NMM';
          end if;
          exit;
        end if;
      
      elsif lower(k.made_refe) = 'lista_precio' then
        if v_lide_maxi_porc_deto <> 0 then
          if nvl(p_pres_indi_user_deto, 'N') = 'N' and
             nvl(p_user_indi_real_deto_sin_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           v_lide_maxi_porc_deto / 100),
                                           p_pres_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NML';
          end if;
          exit;
        end if;
      
      elsif lower(k.made_refe) = 'producto' then
        if v_prod_maxi_porc_desc <> 0 then
          if nvl(p_pres_indi_user_deto, 'N') = 'N' and
             nvl(p_user_indi_real_deto_sin_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           v_prod_maxi_porc_desc / 100),
                                           p_pres_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NMP';
          end if;
          exit;
        end if;
      
      elsif lower(k.made_refe) = 'forma_pago' then
        if p_pres_orte_codi is not null then
          if nvl(p_pres_indi_user_deto, 'N') = 'N' and
             nvl(p_user_indi_real_deto_sin_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           nvl(v_orte_maxi_porc, 0) / 100),
                                           p_pres_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NMF';
          end if;
          exit;
        end if;
      
      elsif lower(k.made_refe) = 'vendedor' then
        if v_vend_maxi_porc_deto <> 0 then
          if nvl(p_pres_indi_user_deto, 'N') = 'N' and
             nvl(p_user_indi_real_deto_sin_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           v_vend_maxi_porc_deto / 100),
                                           p_pres_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NMV';
          end if;
          exit;
        end if;
      
      else
        parameter.p_indi_mens_vali := 'S';
        pl_me('Metodo de control de descuentos no definido.');
      end if;
    end loop;
    p_prec_mexi_deto := nvl(p_prec_mexi_deto, 0);
  end;
  procedure pp_most_prec_maxi_deto_util(p_indi_prod_ortr               in varchar2,
                                        p_exde_tipo                    in varchar2,
                                        p_dpre_prod_codi               in number,
                                        p_pres_mone_codi               in number,
                                        p_pres_tasa_mone               in number,
                                        p_pres_mone_cant_deci          in number,
                                        p_dpre_impu_codi               in number,
                                        p_user_indi_real_deto_sin_exce in varchar2,
                                        p_pres_indi_user_deto          in varchar2,
                                        
                                        p_prec_reto out number) is
    v_cost number;
  
  begin
    if p_indi_prod_ortr = 'P' then
      if nvl(p_exde_tipo, 'N') = 'N' then
        parameter.p_porc_util_mini_fact := nvl(parameter.p_porc_util_mini_fact,
                                               0);
        v_cost                          := fa_devu_cost_prom(p_dpre_prod_codi,
                                                             parameter.p_codi_peri_sgte);
      
        if p_pres_mone_codi <> parameter.p_codi_mone_mmnn then
          v_cost := round(v_cost / nvl(p_pres_tasa_mone, 1),
                          p_pres_mone_cant_deci);
        end if;
      
        if p_dpre_impu_codi = parameter.p_codi_impu_exen then
          v_cost := v_cost;
        elsif p_dpre_impu_codi = parameter.p_codi_impu_grav5 then
          v_cost := v_cost + v_cost * 5 / 100;
        elsif p_dpre_impu_codi = parameter.p_codi_impu_grav10 then
          v_cost := v_cost + v_cost * 10 / 100;
        end if;
      
        if nvl(v_cost, 0) > 0 then
          if nvl(p_pres_indi_user_deto, 'N') = 'N' and
             nvl(p_user_indi_real_deto_sin_exce, 'N') = 'N' then
            p_prec_reto := round(v_cost +
                                 (v_cost * parameter.p_porc_util_mini_fact / 100),
                                 p_pres_mone_cant_deci);
          else
            p_prec_reto := v_cost;
          end if;
        end if;
      end if;
    end if;
  
    p_prec_reto := nvl(p_prec_reto, 0);
  end;

  PROCEDURE pp_most_prec_maxi_deto_exce(p_prec_unit_list      in number,
                                        p_exce_indi           in varchar2,
                                        p_exce_deto_porc      in number,
                                        p_exce_deto_prec      in number,
                                        p_pres_mone_cant_deci in number,
                                        p_prec_reto           out number) IS
    --v_dife  number := 0;
    --v_porc  number := 0;
  
  BEGIN
    if p_exce_indi = 'P' then
      if nvl(p_prec_unit_list, 0) = 0 then
        null;
        p_prec_reto := 0;
      else
        p_prec_reto := round(p_prec_unit_list -
                             (p_prec_unit_list * p_exce_deto_porc / 100),
                             p_pres_mone_cant_deci);
      end if;
    else
      p_prec_reto := round(p_exce_deto_prec, p_pres_mone_cant_deci);
    end if;
  
    p_prec_reto := nvl(p_prec_reto, 0);
  END pp_most_prec_maxi_deto_exce;

  procedure pp_valida_stock_lote(p_prod             in number,
                                 p_depo             in number,
                                 p_lote             in number,
                                 p_cant             in number,
                                 p_indi_fact_nega   in varchar2,
                                 p_prod_desc        in varchar2,
                                 p_prod_alfa        in varchar2,
                                 p_pres_codi_a_modi in number) is
  
    v_stock               number;
    v_actu_cant           number;
    v_pres_cant           number;
    v_remi_cant           number;
    v_prod_indi_fact_nega varchar2(1) := p_indi_fact_nega;
    v_cant_pedi           number;
    --v_cant_remi      number;
  
  begin
    parameter.p_perm_stoc_nega := ltrim(rtrim(general_skn.fl_busca_parametro('p_perm_stoc_nega')));
  
    begin
      select nvl(a.prde_cant_actu, 0),
             nvl(a.prde_cant_pedi, 0),
             nvl(a.prde_cant_remi, 0)
        into v_actu_cant, v_pres_cant, v_remi_cant
        from come_prod_depo_lote a
       where a.prde_prod_codi = p_prod
         and a.prde_depo_codi = p_depo
         and a.prde_lote_codi = p_lote;
    
    exception
      When no_data_found then
        v_actu_cant := 0;
        v_pres_cant := 0;
        v_remi_cant := 0;
      When others then
        v_actu_cant := 0;
        v_pres_cant := 0;
        v_remi_cant := 0;
      
    end;
    v_stock := v_actu_cant - v_pres_cant - v_remi_cant;
  
    if p_pres_codi_a_modi is not null then
      begin
        select nvl(sum(b.dpre_cant), 0)
          into v_cant_pedi
          from come_pres_clie a, come_pres_clie_deta b
         where a.pres_codi = b.dpre_pres_codi
           and nvl(a.pres_tipo, 'A') = 'A'
           and nvl(a.pres_esta_pres, 'P') in ('P', 'C')
           and b.dpre_prod_codi = p_prod
           and b.dpre_depo_codi = p_depo
           and b.dpre_lote_codi = p_lote
           and a.pres_codi = p_pres_codi_a_modi;
      
        v_stock := v_stock + v_cant_pedi;
      exception
        when no_data_found then
          null;
      end;
    end if;
  
    if p_cant > v_stock then
      if nvl(parameter.p_perm_stoc_nega, 'S') = 'S' then
        if nvl(v_prod_indi_fact_nega, 'N') = 'S' then
          if parameter.p_indi_most_mens_aler = 'S' then
            pl_me('Atenci?n!!! La cantidad del articulo ' || p_prod_alfa || ' ' ||
                  p_prod_desc || ' supera el Stock!!!');
          end if;
        else
          parameter.p_indi_mens_vali := 'S';
          pl_me('Atenci?n!!! La cantidad del articulo ' || p_prod_alfa || ' ' ||
                p_prod_desc || ' supera el Stock!!');
        end if;
      else
        parameter.p_indi_mens_vali := 'S';
        pl_me('Atenci?n!!! La cantidad del articulo ' || p_prod_alfa || ' ' ||
              p_prod_desc || ' supera el Stock!');
      end if;
    end if;
  end;
  procedure pp_valida_stock(p_prod             in number,
                            p_depo             in number,
                            p_cant             in number,
                            p_indi_fact_nega   in varchar2,
                            p_prod_desc        in varchar2,
                            p_prod_alfa        in varchar2,
                            p_pres_codi_a_modi in number) is
  
    v_stock               number;
    v_actu_cant           number;
    v_pres_cant           number;
    v_pres_cant_sucu      number;
    v_remi_cant           number;
    v_prod_indi_fact_nega varchar2(1) := p_indi_fact_nega;
    v_cant_pedi           number;
  
  begin
  
    parameter.p_perm_stoc_nega := ltrim(rtrim(general_skn.fl_busca_parametro('p_perm_stoc_nega')));
  
    begin
      select nvl(a.prde_cant_actu, 0),
             nvl(a.prde_cant_pedi, 0),
             nvl(a.prde_cant_pedi_sucu, 0),
             nvl(a.prde_cant_remi, 0)
        into v_actu_cant, v_pres_cant, v_pres_cant_sucu, v_remi_cant
        from come_prod_depo a
       where a.prde_prod_codi = p_prod
         and a.prde_depo_codi = p_depo;
    
    exception
      when no_data_found then
        v_actu_cant      := 0;
        v_pres_cant      := 0;
        v_pres_cant_sucu := 0;
        v_remi_cant      := 0;
    end;
  
    v_stock := v_actu_cant - v_pres_cant - v_pres_cant_sucu - v_remi_cant;
  
    if p_pres_codi_a_modi is not null then
    
      begin
        select nvl(sum(b.dpre_cant), 0)
          into v_cant_pedi
          from come_pres_clie a, come_pres_clie_deta b
         where a.pres_codi = b.dpre_pres_codi
           and nvl(a.pres_tipo, 'A') = 'A'
           and nvl(a.pres_esta_pres, 'P') in ('P', 'C')
           and b.dpre_prod_codi = p_prod
           and b.dpre_depo_codi = p_depo
           and a.pres_codi = p_pres_codi_a_modi;
      
        v_stock := v_stock + v_cant_pedi;
      exception
        when no_data_found then
          null;
        
      end;
    end if;
  
    if p_cant > v_stock then
      if nvl(parameter.p_perm_stoc_nega, 'S') = 'S' then
        if nvl(v_prod_indi_fact_nega, 'N') = 'S' then
          if parameter.p_indi_most_mens_aler = 'S' then
            pl_me('Atenci?n!! La cantidad del articulo ' || p_prod_alfa || ' ' ||
                  p_prod_desc || ' supera el Stock!!!');
          end if;
        else
          parameter.p_indi_mens_vali := 'S';
          pl_me('Atenci?n!! La cantidad del articulo ' || p_prod_alfa || ' ' ||
                p_prod_desc || ' supera el Stock!!!');
        end if;
      else
        parameter.p_indi_mens_vali := 'S';
        pl_me('Atenci?n!! La cantidad del articulo ' || p_prod_alfa || ' ' ||
              p_prod_desc || ' supera el Stock!!!');
      end if;
    end if;
  end;

  procedure pp_carga_datos_usuario(o_user_ind_r_dto_sin_exce  out varchar2,
                                   o_user_empl_codi_alte      out varchar2,
                                   o_user_depo_codi_alte      out varchar2,
                                   o_user_indi_modi_pres      out varchar2,
                                   o_user_indi_modi_vent_comp out varchar2) is
  
  begin
    select user_indi_real_deto_sin_exce,
           nvl(empl_codi_alte, empl_codi),
           nvl(depo_codi_alte, depo_codi),
           nvl(user_indi_modi_pres, 'N') user_indi_modi_pres,
           user_indi_modi_vent_comp
      into o_user_ind_r_dto_sin_exce,
           o_user_empl_codi_alte,
           o_user_depo_codi_alte,
           o_user_indi_modi_pres,
           o_user_indi_modi_vent_comp
      from segu_user, come_empl, come_depo
     where user_empl_codi = empl_codi(+)
       and user_depo_codi = depo_codi(+)
       and user_login = g_user;
  
  exception
    when no_data_found then
      o_user_ind_r_dto_sin_exce := 'N';
  end pp_carga_datos_usuario;

  PROCEDURE PP_CALCULAR_IMPORTE_ITEM(p_dpre_prec_unit      in number,
                                     p_dpre_porc_deto      in number,
                                     p_dpre_cant_medi      in number,
                                     p_pres_mone_cant_deci in number,
                                     p_dpre_prec_unit_deto in number,
                                     p_dpre_prec_unit_reca in number,
                                     p_CONC_DBCR           in varchar2,
                                     p_S_TOTAL_ITEM_MOST   out number,
                                     p_S_TOTAL_ITEM        out number,
                                     p_S_TOTAL_ITEM_DETO   out number,
                                     p_S_TOTAL_ITEM_RECA   out number) IS
  BEGIN
    p_S_TOTAL_ITEM_MOST := round((nvl(p_dpre_prec_unit, 0) *
                                 (1 - (nvl(p_dpre_porc_deto, 0) / 100)) *
                                 nvl(p_dpre_cant_medi, 0)),
                                 p_pres_mone_cant_deci);
    p_S_TOTAL_ITEM      := round((nvl(p_dpre_prec_unit, 0) *
                                 (1 - (nvl(p_dpre_porc_deto, 0) / 100)) *
                                 nvl(p_dpre_cant_medi, 0)),
                                 p_pres_mone_cant_deci);
  
    p_S_TOTAL_ITEM_DETO := round((round(nvl(p_dpre_prec_unit_deto, 0), 4) *
                                 p_dpre_cant_medi),
                                 4);
    p_S_TOTAL_ITEM_RECA := round((round(nvl(p_dpre_prec_unit_reca, 0), 4) *
                                 p_dpre_cant_medi),
                                 4);
  
    IF NVL(p_CONC_DBCR, 'D') = 'C' THEN
      p_S_TOTAL_ITEM_MOST := p_S_TOTAL_ITEM_MOST * -1;
      p_S_TOTAL_ITEM      := p_S_TOTAL_ITEM * -1;
      p_S_TOTAL_ITEM_DETO := p_S_TOTAL_ITEM_DETO * -1;
      p_S_TOTAL_ITEM_RECA := p_S_TOTAL_ITEM_RECA * -1;
    END IF;
  
  END PP_CALCULAR_IMPORTE_ITEM;

  procedure pp_valida_prec_unit_deto(p_indi_prod_ortr               IN VARCHAR2,
                                     p_dpre_prec_unit_neto          IN NUMBER,
                                     p_dpre_prec_unit_list          IN NUMBER,
                                     p_s_prec_maxi_deto             IN NUMBER,
                                     p_dpre_prod_codi               in number,
                                     p_dpre_impu_codi               in number,
                                     p_dpre_porc_deto               in number,
                                     p_exde_tipo                    in varchar2,
                                     p_pres_porc_deto               in number,
                                     p_pres_tasa_mone               in number,
                                     p_coba_fact_conv               in number,
                                     p_user_indi_real_deto_sin_exce in varchar2,
                                     p_pres_indi_user_deto          in varchar2,
                                     p_pres_mone_codi               in number,
                                     p_pres_mone_cant_deci          in number,
                                     p_dpre_prec_unit               in number,
                                     p_dpre_indi_prec_maxi_deto     IN NUMBER) is
  
  begin
    if p_indi_prod_ortr = 'S' then
      if nvl(p_dpre_prec_unit_neto, 0) < nvl(p_dpre_prec_unit_list, 0) and
         nvl(p_dpre_prec_unit_list, 0) <> 0 then
        parameter.p_indi_mens_vali := 'S';
        pl_me('No se puede facturar el servicio por debajo del Precio de Lista.');
      end if;
    else
      if p_dpre_prec_unit_neto < p_s_prec_maxi_deto then
        if nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'NMC' then
          -- NMC= sin excepcion,por Matriz-Cliente
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del item supera el m?ximo permitido para el Cliente seleccionado.');
        elsif nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'NMM' then
          -- NMM= sin excepcion,por Matriz-Matriz Precio
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del item supera el m?ximo permitido para la Matriz de LP,Segmento y Forma de Pago.');
        elsif nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'NML' then
          -- NML= sin excepcion,por Matriz-Lista de Precio
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del item supera el m?ximo permitido para el precio de la LP seleccionada.');
        elsif nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'NMP' then
          -- NMP= sin excepcion,por Matriz-Producto
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del item supera el m?ximo permitido para el Producto seleccionado.');
        elsif nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'NMF' then
          -- NMF= sin excepcion,por Matriz-Forma de Pago
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del item supera el m?ximo permitido para la Forma de Pago seleccionada.');
        elsif nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'NMV' then
          -- NMV= sin excepcion,por Matriz-Vendedor
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del item supera el m?ximo permitido para el Vendedor seleccionado.');
        elsif nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'NL' then
          -- NL = sin excepcion,por Lista de Precio
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Precio del Producto para esta LP o Cliente seleccionado no permite facturar por debajo del Precio de Lista (Validaci?n Precio Minimo).');
        elsif nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'NU' then
          -- NU = sin excepcion,por Utilidad
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del Item supera al maximo Permitido, debe Solicitar una Autorizacion');
        elsif nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'P' then
          -- P = con excepcion,por Producto
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del item supera el m?ximo permitido para la Excepci?n del Producto seleccionado.');
        elsif nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'C' then
          -- C = con excepcion,por Cantidad
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del item supera el m?ximo permitido para la Excepci?n por Cantidad del Producto seleccionado.');
        elsif nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'O' then
          -- O = con excepcion,por Obsequio
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del item supera el m?ximo permitido para la Excepci?n por Obsequio Producto seleccionado.');
        elsif nvl(p_dpre_indi_prec_maxi_deto, 'NL') = 'K' then
          -- K = con excepcion,por Cliente al Costo  
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del item supera el m?ximo permitido para la Excepci?n del Producto al Costo.');
        else
          --No deberia de ingresar aqui al menos que exista una nueva excepcion
          parameter.p_indi_mens_vali := 'S';
          pl_me('El Descuento del item supera el m?ximo permitido.');
        end if;
      end if;
    end if;
  
    pp_vali_utilidad(p_indi_prod_ortr,
                     p_dpre_prod_codi,
                     p_dpre_impu_codi,
                     p_dpre_porc_deto,
                     p_exde_tipo,
                     p_pres_porc_deto,
                     p_pres_tasa_mone,
                     p_coba_fact_conv,
                     p_user_indi_real_deto_sin_exce,
                     p_pres_indi_user_deto,
                     p_pres_mone_codi,
                     p_pres_mone_cant_deci,
                     p_dpre_prec_unit);
  end;

  procedure pp_vali_utilidad(p_indi_prod_ortr               in varchar2,
                             p_dpre_prod_codi               in number,
                             p_dpre_impu_codi               in number,
                             p_dpre_porc_deto               in number,
                             p_exde_tipo                    in varchar2,
                             p_pres_porc_deto               in number,
                             p_pres_tasa_mone               in number,
                             p_coba_fact_conv               in number,
                             p_user_indi_real_deto_sin_exce in varchar2,
                             p_pres_indi_user_deto          in varchar2,
                             p_pres_mone_codi               in number,
                             p_pres_mone_cant_deci          in number,
                             p_dpre_prec_unit               in number) is
    v_cost      number;
    v_deto      number;
    v_prec      number;
    v_util      number;
    v_porc      number;
    v_cost_ulti number;
  
  begin
    if p_indi_prod_ortr = 'P' then
      if nvl(p_exde_tipo, 'N') = 'N' then
        parameter.p_porc_util_mini_fact := nvl(parameter.p_porc_util_mini_fact,
                                               0);
        v_cost                          := fa_devu_cost_prom(p_dpre_prod_codi,
                                                             parameter.p_codi_peri_sgte);
      
        if p_dpre_impu_codi = parameter.p_codi_impu_exen then
          v_cost := v_cost;
        elsif p_dpre_impu_codi = parameter.p_codi_impu_grav5 then
          v_cost := v_cost + v_cost * 5 / 100;
        elsif p_dpre_impu_codi = parameter.p_codi_impu_grav10 then
          v_cost := v_cost + v_cost * 10 / 100;
        end if;
      
        if nvl(v_cost, 0) > 0 then
          if parameter.p_indi_deto_cabe_deta = 'S' then
            v_deto := nvl(p_pres_porc_deto, 0);
          else
            v_deto := nvl(p_dpre_porc_deto, 0);
          end if;
        
          v_prec := p_dpre_prec_unit - (p_dpre_prec_unit * v_deto / 100);
          v_prec := v_prec / nvl(p_coba_fact_conv, 1);
          v_prec := round(v_prec * p_pres_tasa_mone,
                          parameter.p_cant_deci_mmnn);
          v_util := v_prec - v_cost;
          v_porc := v_util * 100 / v_cost;
        
          if nvl(p_user_indi_real_deto_sin_exce, 'N') = 'N' and
             nvl(p_pres_indi_user_deto, 'N') = 'N' then
            if v_porc < parameter.p_porc_util_mini_fact then
              if nvl(p_exde_tipo, 'N') = 'K' then
                v_cost_ulti := fp_cost_ulti_comp(p_dpre_prod_codi,
                                                 p_pres_tasa_mone,
                                                 p_pres_mone_codi,
                                                 p_pres_mone_cant_deci);
                if v_cost_ulti > v_prec then
                  parameter.p_indi_mens_vali := 'S';
                  pl_me('El precio unitario no debe ser menor al costo.');
                end if;
              else
                parameter.p_indi_mens_vali := 'S';
                pl_me('El Descuento supera al maximo Permitido, debe Solicitar una Autorizacion');
              end if;
            end if;
          else
            if v_cost > v_prec then
              pl_me('El precio unitario no debe ser menor al costo.');
            end if;
          end if;
        end if;
      end if;
    end if;
  end pp_vali_utilidad;

  function fp_cost_ulti_comp(p_prod_codi           in number,
                             p_pres_tasa_mone      in number,
                             p_pres_mone_codi      in number,
                             p_pres_mone_cant_deci in number) return number is
    v_ulco_cost_mmnn number;
    v_deta_impu_codi number;
    v_dpre_impu_codi number;
    v_cost           number;
  begin
    begin
      select u.ulco_cost_mmnn, d.deta_impu_codi
        into v_ulco_cost_mmnn, v_deta_impu_codi
        from come_prod_cost_ulti_comp u, come_movi_prod_deta d
       where u.ulco_deta_movi_codi = d.deta_movi_codi(+)
         and u.ulco_deta_nume_item = d.deta_nume_item(+)
         and u.ulco_prod_codi = p_prod_codi;
    
      if v_deta_impu_codi is null then
        begin
          select prod_impu_codi
            into v_deta_impu_codi
            from come_prod
           where prod_codi = p_prod_codi;
        exception
          when no_data_found then
            v_deta_impu_codi := parameter.p_codi_impu_exen;
        end;
      end if;
    
      if v_deta_impu_codi = parameter.p_codi_impu_exen then
        v_cost := v_ulco_cost_mmnn;
      elsif v_deta_impu_codi = parameter.p_codi_impu_grav5 then
        v_cost := v_ulco_cost_mmnn + v_ulco_cost_mmnn * 5 / 100;
      elsif v_deta_impu_codi = parameter.p_codi_impu_grav10 then
        v_cost := v_ulco_cost_mmnn + v_ulco_cost_mmnn * 10 / 100;
      end if;
      if p_pres_mone_codi <> parameter.p_codi_mone_mmnn then
        v_cost := round(v_cost * p_pres_tasa_mone, p_pres_mone_cant_deci);
      else
        v_cost := round(v_cost, parameter.p_cant_deci_mmnn);
      end if;
    
    exception
      when no_data_found then
        v_cost := fa_devu_cost_prom(p_prod_codi, parameter.p_codi_peri_sgte);
        begin
          select prod_impu_codi
            into v_dpre_impu_codi
            from come_prod
           where prod_codi = p_prod_codi;
        exception
          when no_data_found then
            v_dpre_impu_codi := parameter.p_codi_impu_exen;
        end;
        if v_dpre_impu_codi = parameter.p_codi_impu_exen then
          v_cost := v_cost;
        elsif v_dpre_impu_codi = parameter.p_codi_impu_grav5 then
          v_cost := v_cost + v_cost * 5 / 100;
        elsif v_dpre_impu_codi = parameter.p_codi_impu_grav10 then
          v_cost := v_cost + v_cost * 10 / 100;
        end if;
      
        if p_pres_mone_codi <> parameter.p_codi_mone_mmnn then
          v_cost := round(v_cost * p_pres_tasa_mone, p_pres_mone_cant_deci);
        else
          v_cost := round(v_cost, parameter.p_cant_deci_mmnn);
        end if;
    end;
  
    return v_cost;
  end fp_cost_ulti_comp;

  procedure pp_calc_deto_reca(p_pres_porc_deto in number,
                              p_pres_porc_reca in number,
                              p_pres_impo_mano_obra in number,
                              p_pres_mone_cant_deci in number,
                              p_pres_impo_mano_obra_deto out number,
                              p_pres_impo_mano_obra_reca out number) is
    v_dpre_prec_unit_deto number;
    v_dpre_prec_unit_reca number;
    v_S_TOTAL_ITEM_MOST   number;
    v_S_TOTAL_ITEM        number;
    v_S_TOTAL_ITEM_DETO   number;
    v_S_TOTAL_ITEM_RECA  number;
  begin
  
    for bdet in detalle loop
     v_dpre_prec_unit_deto := round((bdet.dpre_prec_unit *
                                        (1 -
                                        (nvl(p_pres_porc_deto, 0) / 100))),
                                        4);
                                       
 
       
     v_dpre_prec_unit_reca := round((bdet.dpre_prec_unit *
                                        (1 +
                                        (nvl(p_pres_porc_reca, 0) / 100))),
                                        4);
                                       
      
                                        
                                        
    
      v_dpre_prec_unit_deto := round((v_dpre_prec_unit_deto *
                                        (1 -
                                        (nvl(bdet.dpre_porc_deto, 0) / 100))),
                                        4);
      v_dpre_prec_unit_reca := round((v_dpre_prec_unit_reca *
                                        (1 +
                                        (nvl(bdet.dpre_porc_reca, 0) / 100))),
                                        4);
                                       
           
    
      p_pres_impo_mano_obra_deto := round( p_pres_impo_mano_obra,
                                              p_pres_mone_cant_deci);
      p_pres_impo_mano_obra_reca := round( p_pres_impo_mano_obra,
                                              p_pres_mone_cant_deci);
                                             
     
      
      ----- calculo por item
      v_S_TOTAL_ITEM_MOST := round((nvl(bdet.dpre_prec_unit, 0) * (1 - (nvl(bdet.dpre_porc_deto, 0) / 100)) * nvl(bdet.dpre_cant_medi, 0)), p_pres_mone_cant_deci);
      v_S_TOTAL_ITEM      := round((nvl(bdet.dpre_prec_unit, 0) * (1 - (nvl(bdet.dpre_porc_deto, 0) / 100)) * nvl(bdet.dpre_cant_medi, 0)), p_pres_mone_cant_deci);
  
      v_S_TOTAL_ITEM_DETO :=round ((round(v_dpre_prec_unit_deto, 4) *bdet.dpre_cant_medi), 4);
      v_S_TOTAL_ITEM_RECA :=round ((round(v_dpre_prec_unit_reca, 4) *bdet.dpre_cant_medi), 4);
  
  IF NVL(BDET.CONC_DBCR, 'D') = 'C' THEN
  	 v_S_TOTAL_ITEM_MOST :=  v_S_TOTAL_ITEM_MOST*-1;
  	 v_S_TOTAL_ITEM      :=  v_S_TOTAL_ITEM *-1;
  	 v_S_TOTAL_ITEM_DETO :=  v_S_TOTAL_ITEM_DETO *-1;
  	 v_S_TOTAL_ITEM_RECA := v_S_TOTAL_ITEM_RECA *-1;
  END IF;	
  
  ----actualizacion de registro de la collection.
      pp_actualizar_member_coll(bdet.nro, 14, v_dpre_prec_unit_deto);
      pp_actualizar_member_coll(bdet.nro, 15,  v_dpre_prec_unit_reca);
      pp_actualizar_member_coll(bdet.nro, 31,  v_S_TOTAL_ITEM_MOST);
      pp_actualizar_member_coll(bdet.nro, 27,  v_S_TOTAL_ITEM);
      pp_actualizar_member_coll(bdet.nro, 13,  v_S_TOTAL_ITEM_DETO);
      pp_actualizar_member_coll(bdet.nro, 16,  v_S_TOTAL_ITEM_RECA);
  
   end loop;
  end pp_calc_deto_reca;

  procedure pp_validar_tota_mano(p_indi_mano_obra           in varchar2,
                                 p_pres_impo_mano_obra      in number,
                                 p_pres_impo_mano_obra_deto out number,
                                 p_pres_mone_cant_deci      in number,
                                 p_pres_impo_mano_obra_reca out number) is
  begin
    --if nvl(:parameter.p_win_hist, 'N') = 'N' then
    if p_indi_mano_obra = 'S' then
      if p_pres_impo_mano_obra <= 0 then
        pl_me('Debe ingresar un valor mayor a cero al importe de la Mano de Obra..');
      else
        p_pres_impo_mano_obra_deto := round(p_pres_impo_mano_obra,
                                            p_pres_mone_cant_deci);
        p_pres_impo_mano_obra_reca := round(p_pres_impo_mano_obra,
                                            p_pres_mone_cant_deci);
      end if;
      -- end if;
    end if;
  
  end;

  procedure pp_set_variable is
  begin
    --bcab.clpr_codi_alte                := v('p135_clpr_codi_alte');
    bcab.CLPR_CODI                     := v('p135_clpr_codi');
    bcab.pres_clpr_desc                := v('p135_pres_clpr_desc');
    bcab.pres_clpr_codi                := v('P135_CLPR_CODI');
    bcab.clpr_indi_vali_limi_cred      := v('P135_CLPR_INDI_VALI_LIMI_CRED');
    bcab.pres_clpr_ruc                 := v('P135_CLPR_INDI_VALI_LIMI_CRED');
    bcab.pres_clpr_dire                := v('P135_PRES_CLPR_RUC');
    bcab.pres_clpr_tele                := v('P135_PRES_CLPR_DIRE');
    bcab.s_orte_desc                   := v('P135_S_ORTE_DESC');
    bcab.pres_clpr_cli_situ_codi       := v('P135_PRES_CLPR_CLI_SITU_CODI');
    bcab.pres_clpr_indi_vali_situ_clie := v('');
  
    bcab.clpr_indi_exen           := v('P135_CLPR_INDI_EXEN');
    bcab.pres_tipo                := v('P135_PRES_TIPO');
    bcab.pres_clpr_indi_list_negr := v('P135_PRES_CLPR_INDI_LIST_NEGR');
    bcab.pres_clpr_indi_exce      := v('P135_PRES_CLPR_INDI_EXCE');
    bcab.clpr_maxi_porc_deto      := v('P135_CLPR_MAXI_PORC_DETO');
    bcab.clpr_segm_codi           := v('P135_CLPR_SEGM_CODI');
    bcab.clpr_clie_clas1_codi     := v('P135_CLPR_SEGM_CODI');
    bcab.clpr_indi_vali_prec_mini := v('P135_CLPR_INDI_VALI_PREC_MINI');
    bcab.clpr_agen_codi           := v('P135_CLPR_AGEN_CODI');
    bcab.PRES_INDI_USER_DETO      := v('P135_PRES_INDI_USER_DETO');
  
    bcab.s_limi_cred_mone    := v('P135_S_LIMI_CRED_MONE');
    bcab.s_sald_clie_mone    := v('P135_S_SALD_CLIE_MONE');
    bcab.s_sald_limi_cred    := v('P135_S_SALD_LIMI_CRED');
    bcab.pres_mone_codi      := v('P135_PRES_MONE_CODI');
    bcab.pres_auto_limi_cred := v('P135_PRES_AUTO_LIMI_CRED');
    bcab.s_cred_espe_mone    := v('P135_S_CRED_ESPE_MONE');
    bcab.s_pres_impo_deto    := v('P135_S_PRES_IMPO_DETO');
    bcab.clpr_orte_codi      := v('P135_CLPR_ORTE_CODI');
    bcab.pres_orte_codi      := v('P135_PRES_ORTE_CODI');
    bcab.s_orte_maxi_porc    := v('P135_S_ORTE_MAXI_PORC');
  
    bcab.pres_auto_cheq_rech := v('P135_PRES_AUTO_CHEQ_RECH');
    bcab.pres_auto_situ_clie := v('P135_PRES_AUTO_SITU_CLIE');
    bcab.pres_codi_a_modi    := v('P135_PRES_CODI_A_MODI');
    bcab.clpr_list_codi      := v('P135_CLPR_LIST_CODI');
    bcab.pres_list_prec      := v('P135_PRES_LIST_PREC');
  
    bcab.pres_form_entr_codi := v('P135_PRES_FORM_ENTR_CODI');
    bcab.pres_fech_emis      := v('P135_S_PRES_FECH_EMIS');
    bcab.pres_empl_codi      := v('P135_PRES_EMPL_CODI');
    bcab.s_timo_indi_caja    := v('P135_S_TIMO_INDI_CAJA');
    bcab.pres_afec_sald      := v('P135_PRES_AFEC_SALD');
  
    bcab.pres_tasa_mone      := v('P135_PRES_TASA_MONE');
    bcab.pres_mone_cant_deci := v('P135_PRES_MONE_CANT_DECI');
    bcab.s_total             := v('P135_S_TOTAL');
    bcab.s_total_bruto       := v('P135_S_TOTAL_BRUTO');
    bcab.indi_mano_obra      := v('P135_INDI_MANO_OBRA');
    bcab.timo_indi_cont_cred := v('P135_TIMO_INDI_CONT_CRED');
    bcab.pres_desc_mano_obra := v('P135_PRES_DESC_MANO_OBRA');
    bcab.pres_codi           := v('P135_PRES_CODI');
    bcab.pres_nume           := v('P135_PRES_NUME');
  
    bcab.pres_inve_codi               := v('P135_PRES_INVE_CODI');
    bcab.pres_timo_codi               := v('P135_PRES_TIMO_CODI');
    bcab.pres_clpr_cont               := v('P135_PRES_CLPR_CONT');
    bcab.pres_clpr_sres               := v('P135_PRES_CLPR_SRES');
    bcab.pres_vali_ofer               := v('P135_PRES_VALI_OFER');
    bcab.pres_obse                    := v('P135_PRES_OBSE');
    bcab.pres_fech_grab               := sysdate;
    bcab.pres_user                    := nvl(v('P135_PRES_USER'), g_user);
    bcab.pres_plaz_entr               := v('P135_PRES_PLAZ_ENTR');
    bcab.pres_cond_vent               := v('P135_PRES_COND_VENT');
    bcab.pres_porc_deto               := v('P135_PRES_PORC_DETO');
    bcab.pres_impo_mano_obra          := v('P135_PRES_IMPO_MANO_OBRA');
    bcab.pres_impo_mano_obra_deto     := v('P135_PRES_IMPO_MANO_OBRA_DETO');
    bcab.pres_porc_reca               := v('P135_PRES_PORC_RECA');
    bcab.pres_impo_mano_obra_reca     := v('P135_PRES_IMPO_MANO_OBRA_RECA');
    bcab.sucu_nume_item               := v('P135_SUCU_NUME_ITEM');
    bcab.pres_depo_codi               := v('P135_PRES_DEPO_CODI');
    bcab.pres_indi_vent_comp          := v('P135_PRES_INDI_VENT_COMP');
    bcab.pres_refe                    := v('P135_PRES_REFE');
    bcab.user_indi_real_deto_sin_exce := v('p135_user_ind_r_dto_sin_exce');
  
    bcab.empl_codi_alte_vent      := v('P135_EMPL_CODI_ALTE_VENT');
    bcab.pres_empr_codi           := v('AI_EMPR_CODI');
    bcab.empl_desc_vent_comp      := v('P135_EMPL_DESC_VENT_COMP');
    bcab.pres_auto_desc_prod      := v('P135_PRES_AUTO_DESC_PROD');
    bcab.pres_tasa_come           := v('P135_PRES_TASA_COME');
    bcab.pres_empl_codi_vent_comp := v('P135_PRES_EMPL_CODI_VENT_COMP');
    --  pl_me('i hatew');
    --bcab.pres_numep_pres_nume             := v('');
    --bcab.s_orte_porc_entr                 := v('');
    --bcab.s_orte_cant_cuot                 := v('');
    --bcab.s_orte_dias_cuot                 := v('');
    --bcab.orte_list_codi                   := v('');
    --bcab.s_form_entr_desc                 := v('');
    -- bcab.nume_pres_ante                   := v('');
  
    bcab.pres_fech_emis_hora := v('');
  
    select sum(c031) TOTAL_ITEM_MOST
      into bcab.sum_s_total_item_most
      from apex_collections
     where collection_name = 'BDET_DETALLE';
  
  end pp_set_variable;

  procedure pp_validar_ot(p_ortr_nume           in number,
                          p_pres_mone_codi      in number,
                          p_pres_tasa_mone      in number,
                          p_pres_mone_cant_deci in number,
                          p_pres_clpr_codi      in number,
                          p_pres_esta_pres      in varchar2,
                          p_prod_desc           out varchar2,
                          p_clpr_indi_exen      out varchar2,
                          p_ortr_desc           out varchar2,
                          p_dpre_prec_unit      in out number,
                          p_dpre_prod_codi      out number,
                          p_dpre_impu_codi      out number,
                          p_dpre_prec_unit_list out number,
                          p_s_indi_ot           out varchar2,
                          p_deta_prod_clco      out number) is
  begin
    p_dpre_impu_codi := parameter.p_codi_impu_ortr;
    if nvl(p_clpr_indi_exen, 'N') = 'S' then
      p_dpre_impu_codi := parameter.p_codi_impu_exen;
    end if;
  
    I020117.pp_mostrar_ot(p_ortr_nume           => p_ortr_nume,
                          p_pres_mone_codi      => p_pres_mone_codi,
                          p_pres_tasa_mone      => p_pres_tasa_mone,
                          p_pres_mone_cant_deci => p_pres_mone_cant_deci,
                          p_pres_clpr_codi      => p_pres_clpr_codi,
                          p_pres_esta_pres      => p_pres_esta_pres,
                          p_prod_desc           => p_prod_desc,
                          p_dpre_prec_unit      => p_dpre_prec_unit,
                          p_dpre_prod_codi      => p_dpre_prod_codi,
                          p_dpre_prec_unit_list => p_dpre_prec_unit_list,
                          p_s_indi_ot           => p_s_indi_ot,
                          p_deta_prod_clco      => p_deta_prod_clco);
  
    if p_ortr_desc is null then
      p_ortr_desc := p_prod_desc;
    end if;
  
    p_dpre_prec_unit_list := p_dpre_prec_unit;
  end pp_validar_ot;

  procedure pp_carg_dato_depo(p_pres_depo_codi in number,
                              p_sucu_codi      in number,
                              p_pres_depo_desc out varchar2,
                              p_pres_sucu_codi out number,
                              p_pres_sucu_desc out varchar2,
                              p_form_impr_fact out varchar2) is
    v_form_impr number;
    v_rownum    number;
  
  begin
    /*if p_user_depo_codi_alte is not null then
      p_depo_codi_alte_orig := p_user_depo_codi_alte;
    end if;*/
  
    select --depo_codi,
     depo_desc,
     --depo_codi_alte,
     rownum,
     sucu_codi,
     sucu_desc,
     sucu_form_impr_fact
      into --p_pres_depo_codi,
           p_pres_depo_desc,
           -- p_depo_codi_alte_orig,
           v_rownum,
           p_pres_sucu_codi,
           p_pres_sucu_desc,
           v_form_impr
      from come_depo, come_sucu
     where depo_sucu_codi = p_sucu_codi
       and sucu_codi = depo_sucu_codi
       and depo_indi_fact = 'S'
       and (p_pres_depo_codi is null or depo_codi = p_pres_depo_codi)
       and rownum = 1
     order by depo_codi;
  
    if nvl(v_form_impr, 0) <> 0 then
      p_form_impr_fact := v_form_impr;
    end if;
  
  exception
    when no_data_found then
      null;
      -- set_item_property('bcab.depo_codi_alte_orig', navigable, property_true);
  end pp_carg_dato_depo;

  procedure pp_totales(p_pres_impo_mano_obra      in number,
                       p_pres_impo_mano_obra_deto in number,
                       p_pres_impo_mano_obra_reca in number,
                       P_S_TOTAL_BRUTO            out number,
                       P_S_TOTAL_DESCUENTO        out number,
                       p_S_TOTAL_RECARGO          out number,
                       p_s_total                  out number) is
    v_sum_s_total_item      number;
    v_sum_s_total_item_deto number;
    v_sum_s_total_item_reca number;
  begin
    select sum(c027) sum_s_total_item,
           sum(c013) TOTAL_ITEM_DETO,
           sum(c016) v_total_item_reca
      into v_sum_s_total_item,
           v_sum_s_total_item_deto,
           v_sum_s_total_item_reca
      from apex_collections
     where collection_name = 'BDET_DETALLE';
  



    P_S_TOTAL_BRUTO     := nvl(p_pres_impo_mano_obra, 0) +
                           nvl(v_sum_s_total_item, 0);
    P_S_TOTAL_DESCUENTO := (nvl(v_sum_s_total_item, 0) +
                           nvl(p_pres_impo_mano_obra, 0)) -
                           (nvl(v_sum_s_total_item_deto, 0) +
                           nvl(p_pres_impo_mano_obra_deto, 0));
  
    -- pl_me(v_sum_s_total_item_deto);
  
    p_S_TOTAL_RECARGO := (nvl(v_sum_s_total_item_reca, 0) +
                         nvl(p_pres_impo_mano_obra_reca, 0)) -
                         (nvl(v_sum_s_total_item, 0) +
                         nvl(p_pres_impo_mano_obra, 0));
                        
    
    --pl_me(p_S_TOTAL_RECARGO);                    
    p_s_total         := nvl(p_s_total_bruto, 0) -
                         nvl(p_s_total_descuento, 0) +
                         nvl(p_s_total_recargo, 0);
  
  end pp_totales;

  procedure pp_validar_dto(p_dpre_porc_deto      in number,
                           p_dpre_prec_unit      in number,
                           p_dpre_prec_unit_list in number,
                           p_pres_mone_cant_deci in number,
                           p_dpre_prec_unit_neto out number,
                           p_dpre_porc_deto_tota out number) is
  begin
  
    /*if p_dpre_porc_deto is null then   
      p_dpre_porc_deto := 0;   
    end if;*/
  
    if nvl(p_dpre_porc_deto, 0) >= 100 then
      pl_me('El porcentaje debe ser menor a 100.');
    elsif nvl(p_dpre_porc_deto, 0) < 0 then
      pl_me('El porcentaje debe ser mayor o igual a 0.');
    end if;
  
    p_dpre_prec_unit_neto := round((nvl(p_dpre_prec_unit, 0) *
                                   (1 - (nvl(p_dpre_porc_deto, 0) / 100))),
                                   p_pres_mone_cant_deci);
  
    if nvl(p_dpre_prec_unit_list, 0) > 0 then
      p_dpre_porc_deto_tota := (nvl(p_dpre_prec_unit_list, 0) -
                               nvl(p_dpre_prec_unit_neto, 0)) * 100 /
                               p_dpre_prec_unit_list;
    end if;
  
  end pp_validar_dto;

  procedure pp_calc_deto_reca1(p_dpre_prec_unit      in number,
                               p_pres_porc_deto      in number,
                               p_dpre_porc_deto      in number,
                               p_pres_porc_reca      in number,
                               p_dpre_porc_reca      in number,
                               p_pres_mone_cant_deci in number,
                               p_pres_impo_mano_obra in number,
                               
                               p_dpre_prec_unit_deto      out number,
                               p_dpre_prec_unit_reca      out number,
                               p_pres_impo_mano_obra_deto out number,
                               p_pres_impo_mano_obra_reca out number) is
  begin
    p_dpre_prec_unit_deto := round((p_dpre_prec_unit *
                                   (1 - (nvl(p_pres_porc_deto, 0) / 100))),
                                   4);
    p_dpre_prec_unit_reca := round((p_dpre_prec_unit *
                                   (1 + (nvl(p_pres_porc_reca, 0) / 100))),
                                   4);
  
    p_dpre_prec_unit_deto := round((p_dpre_prec_unit_deto *
                                   (1 - (nvl(p_dpre_porc_deto, 0) / 100))),
                                   4);
    p_dpre_prec_unit_reca := round((p_dpre_prec_unit_reca *
                                   (1 + (nvl(p_dpre_porc_reca, 0) / 100))),
                                   4);
  
    p_pres_impo_mano_obra_deto := round(p_pres_impo_mano_obra,
                                        p_pres_mone_cant_deci);
    p_pres_impo_mano_obra_reca := round(p_pres_impo_mano_obra,
                                        p_pres_mone_cant_deci);
  
  end;

  procedure pp_validaciones is
  begin
    pp_validar_cabecera;
  
    parameter.p_indi_suge_exde := 'N'; --Indicador para que solo sugiera descuentos en la validacion
    pp_validar_detalle;
  
  end pp_validaciones;

  procedure pp_validar_detalle is
    v_nro_item number := 0;
  begin
  
    pp_validar_deta_cant_deto;
    -- pl_me('attack');
    --pp_reenumerar_nro_item;
  
    /*if parameter.P_INDI_VALI_REPE_PROD_PRESU = 'S' then
      if bdet.INDI_PROD_ORTR = 'P' then
       pp_validar_repeticion_prod;
      end if;
    end if; */
  
  end pp_validar_detalle;

  procedure pp_validar_deta_cant_deto is
    v_nro_item  number := 0;
    v_exist     number := 0;
    v_indi_esta varchar2(1);
  begin
    select count(*)
      into v_exist
      from apex_collections
     where collection_name = 'BDET_DETALLE';
  
    if v_exist = 0 then
      pl_me('Debe ingresar al menos un item.');
    end if;
    -- :parameter.p_ind_validar_det := 'S';
  
    for bdet in detalle loop
      --pp_valida_deta_cant_medi;
      --pp_valida_deta_porc_deto;
    
      --pp_veri_requ_desc_prod (bdet.dpre_indi_esta_conf, bdet.dpre_indi_auto_conf);
    
      if bdet.indi_prod_ortr in ('O', 'S') then
        if nvl(bdet.dpre_prec_unit_neto, 0) <
           nvl(bdet.dpre_prec_unit_list, 0) and
           nvl(bdet.dpre_prec_unit_list, 0) <> 0 then
          pp_actualizar_member_coll(bdet.nro, 5, 'P');
          pp_actualizar_member_coll(bdet.nro, 7, 'N');
        else
          v_indi_esta := 'C';
          --p_indi_conf        := 'S';
          pp_actualizar_member_coll(bdet.nro, 5, 'C');
          pp_actualizar_member_coll(bdet.nro, 7, 'S');
        end if;
      
      else
      
        if nvl(bdet.dpre_prec_unit_neto, 0) < bdet.s_prec_maxi_deto then
          v_indi_esta := 'P';
          --p_indi_conf        := 'N';
          pp_actualizar_member_coll(bdet.nro, 5, 'P');
          pp_actualizar_member_coll(bdet.nro, 7, 'N');
        else
          v_indi_esta := 'C';
          --p_indi_conf        := 'S'; 
          pp_actualizar_member_coll(bdet.nro, 5, 'C');
          pp_actualizar_member_coll(bdet.nro, 7, 'S');
        end if;
      end if;
    
      if v_indi_esta = 'C' then
        --pp_vali_utilidad_requ(v_indi_esta);
        begin
          -- Call the procedure
          I020117.pp_vali_utilidad_requ(bdet.indi_prod_ortr,
                                        bdet.exde_tipo,
                                        bdet.dpre_prod_codi,
                                        bdet.dpre_impu_codi,
                                        bdet.dpre_porc_deto,
                                        bdet.dpre_prec_unit,
                                        bdet.coba_fact_conv,
                                        v_indi_esta);
        end;
      
        if nvl(v_indi_esta, 'C') = 'P' then
          -- p_indi_esta        := v_indi_esta;
          pp_actualizar_member_coll(bdet.nro, 5, v_indi_esta);
          pp_actualizar_member_coll(bdet.nro, 7, 'N');
          --  p_indi_conf        := 'N';
        
        end if;
      end if;
    
    end loop;
  end;

  procedure pp_vali_utilidad_requ(p_indi_prod_ortr in varchar2,
                                  p_exde_tipo      in varchar2,
                                  p_dpre_prod_codi in number,
                                  p_dpre_impu_codi in number,
                                  p_dpre_porc_deto in number,
                                  p_dpre_prec_unit in number,
                                  p_coba_fact_conv in number,
                                  p_indi_esta      out varchar2) is
    v_cost           number;
    v_deto           number;
    v_prec           number;
    v_util           number;
    v_porc           number;
    v_dpre_impu_codi number;
    v_cost_ulti      number;
  
  begin
    p_indi_esta := 'C';
  
    if p_indi_prod_ortr = 'P' then
      if nvl(p_exde_tipo, 'N') = 'N' then
        parameter.p_porc_util_mini_fact := nvl(parameter.p_porc_util_mini_fact,
                                               0);
        v_cost                          := fa_devu_cost_prom(p_dpre_prod_codi,
                                                             parameter.p_codi_peri_sgte);
      
        if p_dpre_impu_codi = parameter.p_codi_impu_exen then
          v_cost := v_cost;
        elsif p_dpre_impu_codi = parameter.p_codi_impu_grav5 then
          v_cost := v_cost + v_cost * 5 / 100;
        elsif p_dpre_impu_codi = parameter.p_codi_impu_grav10 then
          v_cost := v_cost + v_cost * 10 / 100;
        end if;
      
        if nvl(v_cost, 0) > 0 then
          if parameter.p_indi_deto_cabe_deta = 'S' then
            v_deto := nvl(bcab.pres_porc_deto, 0);
          else
            v_deto := nvl(p_dpre_porc_deto, 0);
          end if;
        
          v_prec := p_dpre_prec_unit - (p_dpre_prec_unit * v_deto / 100);
          v_prec := v_prec / nvl(p_coba_fact_conv, 1);
          v_prec := round(v_prec * bcab.pres_tasa_mone,
                          parameter.p_cant_deci_mmnn);
          v_util := v_prec - v_cost;
          v_porc := v_util * 100 / v_cost;
        
          if nvl(bcab.user_indi_real_deto_sin_exce, 'N') = 'N' and
             nvl(bcab.pres_indi_user_deto, 'N') = 'N' then
            if v_porc < parameter.p_porc_util_mini_fact then
              if nvl(bcab.exde_tipo, 'N') = 'K' then
                v_cost_ulti := fp_cost_ulti_comp(p_dpre_prod_codi,
                                                 bcab.pres_tasa_mone,
                                                 bcab.pres_mone_codi,
                                                 bcab.pres_mone_cant_deci);
                if v_cost_ulti > v_prec then
                  p_indi_esta := 'P';
                end if;
              else
                p_indi_esta := 'P';
              end if;
            end if;
          else
            if v_cost > v_prec then
              p_indi_esta := 'P';
            end if;
          end if;
        end if;
      end if;
    end if;
  end pp_vali_utilidad_requ;

  procedure pp_actualizar_member_coll(p_seq         in number,
                                      p_attr_number in number,
                                      p_value       in varchar2) is
  begin
    apex_collection.update_member_attribute(p_collection_name => 'BDET_DETALLE',
                                            p_seq             => p_seq,
                                            p_attr_number     => p_attr_number,
                                            p_attr_value      => p_value);
  end pp_actualizar_member_coll;

  procedure pp_borrar_registro is
    salir       exception;
    v_record    number;
    v_indi_borr varchar2(1);
  begin
    pp_set_variable;
    if upper(g_user) <> bcab.pres_user then
      begin
        select nvl(upper(u.user_indi_borr_pres_clie), 'N')
          into v_indi_borr
          from segu_user u
         where upper(u.user_login) = upper(g_user);
        if v_indi_borr <> 'S' then
          pl_me('Su usuario no esta autorizado para borrar presupuestos');
        end if;
      exception
        when no_data_found then
          pl_me('Su usuario no esta autorizado para borrar presupuestos');
      end;
    end if;
  
    /*if fl_confirmar_reg('Realmente desea Borrar el Presupuesto?') <> upper('confirmar') then
      raise salir;
    end if;*/
  
    if bcab.pres_codi_a_modi is not null then
      pp_borrar_presup(bcab.pres_codi_a_modi);
    else
      pl_me('Primero debe seleccionar un presupuesto');
    end if;
  
    /*commit_form;    
    if not form_success then
       go_block('bcab');
       clear_form(no_validate, full_rollback);
       message('Registro no borrado.'); bell;
    else     
       message('Registro Borrado.'); bell;
       clear_form(no_validate, full_rollback);
    end if;
    if form_failure then
       raise form_trigger_failure;
    end if;*/
  
  Exception
    when salir then
      --go_block('bcab');
      --lear_form(no_validate, full_rollback);
      pl_me('Registro no borrado.');
  end pp_borrar_registro;

  procedure pp_veri_user_borr_pres(p_user_indi_borr_pres_clie out varchar2) is
  
  begin
  
    select nvl(u.user_indi_borr_pres_clie, 'N') user_indi_borr_pres_clie
      into p_user_indi_borr_pres_clie
      from segu_user u
     where u.user_login = g_user;
  
  exception
    when no_data_found then
      p_user_indi_borr_pres_clie := 'N';
    when others then
      pl_me(sqlerrm);
  end pp_veri_user_borr_pres;

  procedure pp_cargar_pedido(p_pres_codi                in number,
                             p_pres_user                in varchar2,
                             p_pres_mone_cant_deci      in number,
                             p_pres_impo_mano_obra      in number,
                             p_s_avis_inve              out varchar2,
                             p_pres_porc_deto           in number,
                             p_pres_porc_reca           in number,
                             p_user_indi_borr_pres_clie out varchar2,
                             p_pres_impo_mano_obra_deto out varchar2,
                             p_pres_impo_mano_obra_reca out varchar2,
                             p_indi_mano_obra           out varchar2) is
  
    cursor c_pres_cab is
      select pres_nume,
             pres_codi,
             clpr_codi_alte,
             pres_timo_codi,
             pres_obse,
             nvl(e.empl_codi_alte, e.empl_codi) empl_codi_alte,
             pres_mone_codi,
             nvl(pres_esta_pres, 'P') pres_esta_pres,
             pres_list_prec,
             pres_form_entr_codi,
             pres_orte_codi,
             nvl(pres_tipo, 'A') pres_tipo,
             nvl(depo_codi_alte, depo_codi) depo_codi_alte,
             pres_indi_user_deto,
             pres_clpr_sres,
             pres_clpr_cont,
             pres_refe,
             pres_fech_emis,
             pres_vali_ofer,
             pres_plaz_entr,
             pres_cond_vent,
             nvl(pres_porc_deto, 0) pres_porc_deto,
             nvl(pres_porc_reca, 0) pres_porc_reca,
             pres_inve_codi,
             pres_desc_mano_obra,
             nvl(pres_impo_mano_obra, 0) pres_impo_mano_obra,
             nvl(pres_impo_mano_obra_deto, 0) pres_impo_mano_obra_deto,
             nvl(pres_impo_mano_obra_reca, 0) pres_impo_mano_obra_reca,
             pres_user,
             pres_fech_grab,
             decode(nvl(pres_indi_app_movil, 'N'),
                    'S',
                    'SI',
                    'N',
                    'NO',
                    'NO') pres_indi_app_movil,
             decode(nvl(pres_indi_impr_auto, 'N'),
                    'S',
                    'SI',
                    'N',
                    'NO',
                    'NO') pres_indi_impr_auto,
             pres_auto_limi_cred,
             pres_auto_situ_clie,
             pres_auto_cheq_rech,
             pres_auto_desc_prod,
             pres_indi_vent_comp,
             --dpre_prec_unit_list,
             pres_empl_codi_vent_comp,
             nvl(ev.empl_codi_alte, ev.empl_codi) empl_codi_alte_vent,
             user_desc,
             ec.empl_codi_alte empl_codi_alte_clpr,
             eu.empl_codi_alte empl_codi_alte_user,
             pres_clpr_sucu_nume_item
      
        from come_pres_clie,
             come_clie_prov,
             come_depo,
             come_empl      e,
             segu_user,
             come_empl      ev,
             come_Empl      ec,
             come_Empl      eu
      
       where clpr_codi = pres_clpr_codi
         and pres_depo_codi = depo_codi
            
         and pres_empl_codi = e.empl_codi
         and pres_empl_codi_vent_comp = ev.empl_codi(+)
            
         and upper(pres_user) = upper(user_login)
         and clpr_empl_codi = ec.empl_Codi(+)
         and user_empl_codi = eu.empl_codi(+)
         and pres_codi = p_pres_codi
       order by pres_codi;
  
    cursor c_pres_deta is
      select dpre_nume_item,
             dpre_prod_codi,
             prod_codi_alfa,
             nvl(dpre_prod_codi_barr, prod_codi_alfa) dpre_prod_codi_barr,
             dpre_cant,
             dpre_prec_unit,
             dpre_desc,
             dpre_ortr,
             dpre_porc_deto,
             dpre_conc_codi,
             dpre_ortr_codi_fact,
             ortr_nume,
             nvl(dpre_prec_unit_deto, dpre_prec_unit) dpre_prec_unit_deto,
             nvl(dpre_prec_unit_reca, dpre_prec_unit) dpre_prec_unit_reca,
             dpre_indi_esta_conf,
             dpre_indi_auto_conf,
             dpre_moti_rech,
             dpre_obse,
             dpre_lote_codi,
             dpre_prec_unit_neto,
             dpre_prec_unit_list,
             dpre_porc_reca,
             dpre_medi_codi,
             d.prod_codi,
             -- DPRE_PORC_DETO,
             conc_dbcr
      
        from come_pres_clie_deta, come_prod d, come_orde_trab, come_conc
       where dpre_prod_codi = prod_codi(+)
         and dpre_ortr_codi_fact = ortr_codi(+)
         and dpre_conc_codi = conc_codi(+)
         and dpre_pres_codi = p_pres_codi
       order by dpre_nume_item;
  
    v_inve_codi      number;
    v_cant_coba      number := 0;
    v_lote_desc      varchar2(100);
    v_lote_obse      varchar2(100);
    v_lote_codi_barr varchar2(100);
    v_ortr_desc      varchar2(500);
    v_dpre_prod_codi number;
    v_prod_codi_alfa number;
    v_coba_codi_barr number;
    v_dpre_medi_codi number;
    v_prod_alfa_ante number;
    v_dpre_cant_medi number;
    v_dpre_lote_codi number;
  
    v_S_TOTAL_ITEM_DETO number;
  
    v_CONC_DBCR               varchar2(500);
    v_prod_desc               varchar2(500);
    v_prod_desc_exte          varchar2(500);
    v_MEDI_DESC_ABRE          varchar2(100);
    v_PROD_MAXI_PORC_DESC     varchar2(100);
    v_S_TOTAL_ITEM            number;
    v_S_TOTAL_ITEM_MOST       number;
    v_S_TOTAL_ITEM_RECA       number;
    v_s_prec_maxi_deto        number;
    v_ide_indi_vali_prec_mini varchar2(100);
    v_lide_maxi_porc_deto     varchar2(100);
    v_dpre_prec_unit_deto     number;
    v_dpre_prec_unit_reca     number;
  
  begin
  
    for x in c_pres_cab loop
    
      /*:bcab.pres_codi_a_modi         := x.pres_codi;
      :bcab.pres_timo_codi           := x.pres_timo_codi;
      :bcab.clpr_codi_alte           := x.clpr_codi_alte;
      :bcab.clpr_codi_alte_pres      := x.clpr_codi_alte;
      :bcab.depo_codi_alte_orig      := x.depo_codi_alte;
      :bcab.pres_obse                := x.pres_obse; 
      :bcab.empl_codi_alte           := nvl(nvl(x.empl_codi_alte,x.empl_codi_alte_clpr), x.empl_codi_alte_user); 
      :bcab.pres_mone_codi           := x.pres_mone_codi; 
      :bcab.pres_list_prec           := nvl(x.pres_list_prec,1);
      :bcab.pres_indi_user_deto      := x.pres_indi_user_deto;
      :bcab.pres_form_entr_codi      := x.pres_form_entr_codi;
      :bcab.pres_orte_codi           := x.pres_orte_codi;        
      :bcab.pres_esta_pres           := x.pres_esta_pres; 
      :bcab.pres_tipo                := x.pres_tipo; 
      :bcab.pres_fech_emis           := x.pres_fech_emis;
      :bcab.s_pres_fech_emis         := to_char(x.pres_fech_emis, 'dd-mm-yyyy');    
      :bcab.pres_clpr_sres           := x.pres_clpr_sres;
      :bcab.pres_clpr_cont           := x.pres_clpr_cont;
      :bcab.pres_refe                := x.pres_refe;       
      :bcab.pres_vali_ofer           := x.pres_vali_ofer;
      :bcab.pres_plaz_entr           := x.pres_plaz_entr;
      :bcab.pres_cond_vent           := x.pres_cond_vent;
      :bcab.pres_porc_deto           := x.pres_porc_deto;
      :bcab.pres_porc_reca           := x.pres_porc_reca;    
      :bcab.pres_inve_codi           := x.pres_inve_codi;  
      :bcab.pres_desc_mano_obra      := x.pres_desc_mano_obra;
      :bcab.pres_impo_mano_obra      := x.pres_impo_mano_obra;
      :bcab.pres_impo_mano_obra_deto := x.pres_impo_mano_obra_deto;
      :bcab.pres_impo_mano_obra_reca := x.pres_impo_mano_obra_reca;
      pres_mone_cant_deci
      :bcab.sucu_nume_item           := x.pres_clpr_sucu_nume_item;*/
    
      pp_veri_exis_inve(x.pres_codi, v_inve_codi, p_s_avis_inve);
    
      --v_pres_mone_cant_deci:=x.pres_mone_cant_deci;
      if nvl(x.pres_impo_mano_obra, 0) = 0 then
        p_indi_mano_obra := 'N';
      else
        p_indi_mano_obra := 'S';
      end if;
    
    /* --:bcab.pres_user               := x.pres_user;
            --:bcab.pres_fech_grab          := x.pres_fech_grab;
            --:bcab.pres_auto_limi_cred     := x.pres_auto_limi_cred;
            --:bcab.pres_auto_situ_clie     := x.pres_auto_situ_clie;
            --:bcab.pres_auto_cheq_rech     := x.pres_auto_cheq_rech;
            --:bcab.pres_auto_desc_prod     := x.pres_auto_desc_prod;
            --:bcab.pres_indi_impr_auto     := x.pres_indi_impr_auto;
            --:bcab.pres_indi_app_movil     := x.pres_indi_app_movil;
            --:bcab.pres_indi_vent_comp     := x.pres_indi_vent_comp;
            --:bcab.empl_codi_alte_vent     := x.empl_codi_alte_vent; */
    
    end loop;
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDET_DETALLE');
    for x in c_pres_deta loop
      --:bdet.indi_prod_ortr       := x.dpre_ortr;
      --:bdet.dpre_nume_item       := x.dpre_nume_item;
    
      if x.dpre_ortr <> 'P' then
        -- si el registro se trata de un servicio el codigo de producto es de concepto
        if x.dpre_ortr = 'O' then
          --- si es una O.T.
          v_ortr_desc      := x.dpre_desc;
          v_dpre_prod_codi := x.dpre_ortr_codi_fact;
          v_prod_codi_alfa := x.ortr_nume;
          v_dpre_medi_codi := null;
        else
          v_ortr_desc      := x.dpre_desc;
          v_dpre_prod_codi := x.dpre_conc_codi;
          v_prod_codi_alfa := x.dpre_conc_codi;
          v_prod_alfa_ante := x.dpre_conc_codi;
          v_dpre_medi_codi := null;
          v_CONC_DBCR      := x.conc_dbcr;
        
          v_prod_desc := x.dpre_desc; ----para casos de modificacion de descripcion de concepto
        end if;
      else
        v_prod_desc      := x.dpre_desc;
        v_ortr_desc      := x.dpre_desc;
        v_prod_codi_alfa := x.prod_codi_alfa;
         v_dpre_prod_codi :=x.prod_codi;
      
        begin
          select count(*)
            into v_cant_coba
            from come_prod_coba_deta
           where coba_codi_barr = x.dpre_prod_codi_barr
             and coba_prod_codi =
                 (select prod_codi
                    from come_prod
                   where prod_codi_alfa = x.prod_codi_alfa);
        
          if v_cant_coba > 0 then
            v_coba_codi_barr := x.dpre_prod_codi_barr;
          else
            begin
              select coba_codi_barr
                into v_coba_codi_barr
                from come_prod_coba_deta
               where coba_nume_item = 1
                 and coba_prod_codi =
                     (select prod_codi
                        from come_prod
                       where prod_codi_alfa = x.prod_codi_alfa);
            exception
              when no_data_found then
                v_coba_codi_barr := null;
            end;
          
          end if;
        end;
      end if;
    
      v_dpre_lote_codi := x.dpre_lote_codi;
    
      if v_dpre_lote_codi is not null then
        begin
          select lote_desc, lote_obse, lote_codi_barr
            into v_lote_desc, v_lote_obse, v_lote_codi_barr
            from come_lote
           where lote_codi = v_dpre_lote_codi;
        
          v_prod_desc_exte := v_lote_desc || ' ' || v_lote_obse || ' ' ||
                              v_lote_codi_barr;
        end;
      else
        v_prod_desc_exte := null;
      end if;
    
      v_dpre_cant_medi := x.dpre_cant;
    
      /*if nvl(v_dpre_indi_esta_conf, 'C') = 'R' then
        set_item_instance_property('bdet.dpre_nume_item',to_number(:system.cursor_record), visual_attribute, 'visual_reg_rojo');
      else
        set_item_instance_property('bdet.dpre_nume_item',to_number(:system.cursor_record), visual_attribute, 'visual_reg_gris_02');
      end if;
      next_record;*/
    
      I020117.pp_mostrar_unid_medi(x.DPRE_MEDI_CODI, v_MEDI_DESC_ABRE);
    
      I020117.pp_calc_deto_reca1(x.dpre_prec_unit,
                                 p_pres_porc_deto,
                                 x.dpre_porc_deto,
                                 p_pres_porc_reca,
                                 x.dpre_porc_reca,
                                 p_pres_mone_cant_deci,
                                 p_pres_impo_mano_obra,
                                 ---
                                 v_dpre_prec_unit_deto,
                                 v_dpre_prec_unit_reca,
                                 p_pres_impo_mano_obra_deto,
                                 p_pres_impo_mano_obra_reca);
    
      I020117.PP_CALCULAR_IMPORTE_ITEM(p_dpre_prec_unit      => x.dpre_prec_unit,
                                       p_dpre_porc_deto      => x.dpre_porc_deto,
                                       p_dpre_cant_medi      => v_dpre_cant_medi,
                                       p_pres_mone_cant_deci => p_pres_mone_cant_deci,
                                       p_dpre_prec_unit_deto => v_dpre_prec_unit_deto,
                                       p_dpre_prec_unit_reca => v_dpre_prec_unit_reca,
                                       p_conc_dbcr           => v_conc_dbcr,
                                       p_S_TOTAL_ITEM_MOST   => v_S_TOTAL_ITEM_MOST,
                                       p_S_TOTAL_ITEM        => v_S_TOTAL_ITEM,
                                       p_S_TOTAL_ITEM_DETO   => v_S_TOTAL_ITEM_DETO,
                                       p_S_TOTAL_ITEM_RECA   => v_S_TOTAL_ITEM_RECA);
    
      apex_collection.add_member(p_collection_name => 'BDET_DETALLE',
                                 p_C001            => v_prod_codi_alfa, --_auto_desc_prod,
                                 p_C002            => x.dpre_ortr,
                                 p_C003            => v_dpre_prod_codi,
                                 p_C004            => v_MEDI_DESC_ABRE,
                                 p_C005            => x.dpre_indi_esta_conf,
                                 p_C006            => x.dpre_indi_auto_conf,
                                 p_C007            => x.dpre_indi_auto_conf,
                                 p_C008            => x.dpre_medi_codi,
                                 p_C009            => v_coba_codi_barr,
                                 p_C010            => v_dpre_cant_medi,
                                 p_C011            => x.dpre_prec_unit,
                                 p_C012            => x.dpre_porc_deto,
                                 p_C013            => v_S_TOTAL_ITEM_DETO, --i_s_total_item_deto,
                                 p_C014            => v_DPRE_PREC_UNIT_DETO, --i_dpre_prec_unit_deto,
                                 p_C015            => v_DPRE_PREC_UNIT_RECA, --i_dpre_prec_unit_reca,
                                 p_C016            => v_S_TOTAL_ITEM_RECA, --i_s_total_item_reca,
                                 p_C017            => x.dpre_prec_unit_list,
                                 p_C018            => v_PROD_MAXI_PORC_DESC, --i_prod_maxi_porc_desc,
                                 p_C019            => v_prod_desc,
                                 p_C020            => v_dpre_lote_codi,
                                 p_C021            => v_s_prec_maxi_deto,
                                 p_C022            => x.dpre_prec_unit_neto,
                                 p_C023            => v_ide_indi_vali_prec_mini,
                                 p_C024            => v_lide_maxi_porc_deto,
                                 p_C025            => x.dpre_obse,
                                 p_c026            => null, --x.DPRE_PORC_DETO_TOTA,
                                 p_C027            => v_S_TOTAL_ITEM, --s_total_item
                                 p_c031            => v_S_TOTAL_ITEM_MOST,
                                 p_c032            => null, --P135_exde_tipo,
                                 p_c033            => null, --dpre_impu_codi,
                                 p_c034            => null, --coba_fact_conv
                                 p_c035            => x.dpre_moti_rech,
                                 p_c036            =>v_CONC_DBCR);
    
    -- PL_ME(v_S_TOTAL_ITEM); 
    end loop;
  
    I020117.pp_veri_user_borr_pres(p_user_indi_borr_pres_clie); ---verifica si tiene permiso para borrar presupuestos
  
    /* if upper(g_user) <> upper(p_pres_user) then   ---Parametro contiene usuario que registro
     
       if p_user_indi_borr_pres_clie = 'S' then
         if get_item_property('bpie.borrar', enabled) = 'FALSE' then
           set_item_property('bpie.borrar', enabled, property_true);
         end if;
       else
         if get_item_property('bpie.borrar', enabled) = 'TRUE' then
           set_item_property('bpie.borrar', enabled, property_false);
         end if;   
       end if;
       
    else
    
       if get_item_property('bpie.borrar', enabled) = 'FALSE' then
         set_item_property('bpie.borrar', enabled, property_true);
       end if; 
       
    end if;*/
  
  exception
    when no_data_found then
      pl_me('No se ha encontrado el Pedido.'); --no deberia de ingresar aqui,ya debe tener validado que exista el pedido
  end pp_cargar_pedido;

  procedure pp_borrar_det is
    v_seq_id number := v('P135_SEQ_ID');
  begin
  
    apex_collection.delete_member(p_collection_name => 'BDET_DETALLE',
                                  p_seq             => v_seq_id);
    apex_collection.resequence_collection(p_collection_name => 'BDET_DETALLE');
  
  end pp_borrar_det;

  function CF_existencia_Actual(p_dpre_prod_codi in number) return Number is
    v_existencia number;
  begin
    select nvl(sum(d.prde_cant_actu), 0)
      into v_existencia
      from come_prod_depo d
     where d.prde_prod_codi = p_dpre_prod_codi;
  
    return v_existencia;
  
  exception
    when others then
      return 0;
  END CF_existencia_Actual;

  function cf_comprar(p_dpre_cant in number, p_dpre_prod_codi in number)
    return Number is
  
    v_comprar number;
  begin
    v_comprar := nvl(p_dpre_cant, 0) -
                 nvl(cf_existencia_actual(p_dpre_prod_codi), 0);
  
    if v_comprar < 0 then
      v_comprar := 0;
    end if;
  
    return v_comprar;
  end cf_comprar;

  procedure pp_llama_reporte(p_tipo_impr in varchar2,
                             p_pres_codi in number) is
    v_parametros   clob;
    v_contenedores clob;
    v_report       varchar2(100);
  
  begin
  
    /*if nvl(:parameter.p_indi_impr_dire_puer, 'N') = 'S' then
      pp_busca_impr_codi(:bcab.pres_empr_codi, :parameter.p_peco_codi, v_impr_codi);
      pp_impr_pres(v_pres_codi, v_impr_codi);
    else*/
    if nvl(p_tipo_impr, 'E') = 'T' then
      --modo econofast, para impresoras matriciales, sin el logo y otras chucherias..
      v_report := 'I020117A';
    elsif nvl(p_tipo_impr, 'E') = 'E' then
      --formato para email.. mas tuti
      v_report := nvl(parameter.p_repo_pres_clie, 'I020117');
      --v_report := ('I020117');
    elsif nvl(p_tipo_impr, 'E') = 'D' then
      --para deposito
      v_report := 'I020117B';
    elsif nvl(p_tipo_impr, 'E') = 'C' then
      --para deposito
      v_report := 'I020117C';
     
    end if;
  
    -- end if;
  
    v_contenedores := 'p_pres_codi';
    v_parametros   := p_pres_codi || '';
    delete from come_parametros_report where usuario = g_user;
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, g_user, v_report, 'pdf', v_contenedores);
  
  Exception
    when others then
      null;
  end pp_llama_reporte;
  
  
 
  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010, v_mensaje);
  end pl_me;

  procedure pp_carg_nume_pres(p_pres_nume out number) is
  begin
    select nvl(max(pres_nume), 0) + 1
      into p_pres_nume
      from come_pres_clie
     where nvl(pres_empr_codi, 1) = parameter.p_empr_codi;
  end pp_carg_nume_pres;

end I020117;
