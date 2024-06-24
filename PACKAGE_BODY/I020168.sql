
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020168" is
  /************ carga de parametros ***************/

  v_aux                 number;
  p_indi_mens_vali      varchar2(5);
  v_indi_vali_cier_caja varchar2(30);
  v_cant_cier_caja      number := 0;
  p_peco_codi           number := 1;
  p_fech_inic           date;
  p_fech_fini           date;
  p_empr_codi           number := v('AI_EMPR_CODI');
  p_sucu_codi           number := v('AI_SUCU_CODI');
  p_sess                varchar2(500) := v('APP_SESSION');

  type t_parameter is record(
    p_indi_orte_manu_fact          varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_orte_manu_fact'))),
    p_indi_calc_impo               varchar2(30) := 'S',
    p_modi_fech_fopa_dife          varchar2(30) := 'N',
    p_cobr_vent_indi_cobr_fp       varchar2(30) := 'N',
    p_indi_most_grup_lote_fact     varchar2(300) := ltrim(rtrim(fa_busc_para('p_indi_most_grup_lote_fact'))),
    p_indi_vali_prod_fact_sub_cost varchar2(300) := ltrim(rtrim(fa_busc_para('p_indi_vali_prod_fact_sub_cost'))),
    p_indi_vali_repe_prod_fact     varchar2(300) := ltrim(rtrim(fa_busc_para('p_indi_vali_repe_prod_fact'))),
    p_maxi_line_impr_fact          varchar2(300) := to_number(fa_busc_para('p_maxi_line_impr_fact')),
    p_max_cant_cara_item_fact      varchar2(300) := to_number(fa_busc_para('p_max_cant_cara_item_fact')),
    p_indi_fact_obse_obli          varchar2(300) := rtrim(ltrim(fa_busc_para('p_indi_fact_obse_obli'))),
    p_indi_fact_modi_desc_conc     varchar2(300) := rtrim(ltrim(fa_busc_para('p_indi_fact_modi_desc_conc'))),
    p_fopa_indi_carg_dato_cheq     varchar2(300) := rtrim(ltrim(fa_busc_para('p_fopa_indi_carg_dato_cheq'))),
    p_indi_cons_pres               varchar2(300) := 'N',
    p_indi_suge_exde               varchar2(300) := 'S', --Indicador para que sugiera descuento solo en la validacion de detalle
    p_codi_timo_valr               number(20, 4) := to_number(fa_busc_para('p_codi_timo_valr')),
    p_codi_timo_adlr               number(20, 4) := to_number(fa_busc_para('p_codi_timo_adlr')),
    p_indi_perm_fech_vale_supe     varchar2(500) := rtrim(ltrim(fa_busc_para('p_indi_perm_fech_vale_supe'))),
    p_codi_timo_auto_fact_emit     number(20, 4) := to_number(fa_busc_para('p_codi_timo_auto_fact_emit')),
    p_codi_timo_auto_fact_emit_cr  number(20, 4) := to_number(fa_busc_para('p_codi_timo_auto_fact_emit_cr')),
    p_indi_apli_rete_exen          varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_apli_rete_exen'))),
    p_hoja_ruta_indi_cobr_fp       varchar2(500) := 'N',
    p_indi_diaria                  varchar2(500) := fa_busc_para('p_indi_diaria'),
    p_form_impr_remi_emit          varchar2(500) := fa_busc_para('p_form_impr_remi_emit'),
    p_indi_fact_cred_impr_remi     varchar2(500) := fa_busc_para('p_indi_fact_cred_impr_remi'),
    p_indi_impr_deta_cuot          varchar2(500) := fa_busc_para('p_indi_impr_deta_cuot'),
    p_codi_oper_tras_men           number(20, 4) := to_number(fa_busc_para('p_codi_oper_tras_men')),
    p_indi_vali_depo_user_fact     varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_vali_depo_user_fact'))),
    p_indi_ruc_exis                varchar2(500) := 'N',
    p_indi_clie_pote               varchar2(500) := 'N',
    p_cres_nume_fact               varchar2(500) := null,
    p_cres_fech_fact               date := null,
    p_cres_user_fact               varchar2(500) := null,
    p_cant_dias_feri               number := 0,
    p_form_impr_cont_soli_cred     varchar2(500) := ltrim(rtrim(fa_busc_para('p_form_impr_cont_soli_cred'))),
    p_indi_impr_cont_soli_cred     varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_impr_cont_soli_cred'))),
    p_indi_vali_list_prec          varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_vali_list_prec'))),
    p_indi_list_valo_exis          varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_list_valo_exis'))),
    p_indi_most_mens_sali          varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_most_mens_sali'))),
    p_indi_most_mens_aler          varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_most_mens_aler'))),
    --indicadores de descripcion ot
    p_indi_most_desc_ot varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_most_desc_ot'))),
    --indicadores de forma de pago
    p_indi_most_fopa varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_most_fopa'))),
    p_indi_clpr_fopa varchar2(500) := 'N',
    --parametros por defecto................................
    p_codi_depo_defa_fact         number(20, 4) := to_number(fa_busc_para('p_codi_depo_defa_fact')),
    p_codi_caja_gs_defa_fact      number(20, 4) := to_number(fa_busc_para('p_codi_caja_gs_defa_fact')),
    p_codi_caja_us_defa_fact      number(20, 4) := to_number(fa_busc_para('p_codi_caja_us_defa_fact')),
    p_codi_caja_re_defa_fact      number(20, 4) := to_number(fa_busc_para('p_codi_caja_re_defa_fact')),
    p_codi_timo_rete_reci         number(20, 4) := to_number(fa_busc_para('p_codi_timo_rete_reci')),
    p_codi_conc_rete_reci         number(20, 4) := to_number(fa_busc_para('p_codi_conc_rete_reci')),
    p_codi_conc_rete_reci_rent    number(20, 4) := to_number(fa_busc_para('p_codi_conc_rete_reci_rent')),
    p_codi_conc_rete_reci_ley_530 number(20, 4) := to_number(fa_busc_para('p_codi_conc_rete_reci_ley_530_37')),
    p_codi_clie_espo              number(20, 4) := to_number(fa_busc_para('p_codi_clie_espo')),
    p_indi_perm_modi_vend         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_perm_modi_vend'))),
    p_codi_mone_dola              number(20, 4) := to_number(fa_busc_para('p_codi_mone_dola')),
    p_codi_mone_real              number(20, 4) := to_number(fa_busc_para('p_codi_mone_real')),
    p_codi_mone_guar              number(20, 4) := to_number(fa_busc_para('p_codi_mone_guar')),
    p_codi_tipo_empl_vend         number(20, 4) := to_number(fa_busc_para('p_codi_tipo_empl_vend')),
    p_codi_tipo_empl_tecn         number(20, 4) := to_number(fa_busc_para('p_codi_tipo_empl_tecn')),
    p_codi_empr                   number(20, 4) := to_number(fa_busc_para('p_codi_empr')),
    p_codi_oper_vta               number(20, 4) := to_number(fa_busc_para('p_codi_oper_vta')),
    p_indi_mult_mone_fact         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_mult_mone_fact'))),
    p_codi_oper                   number(20, 4) := to_number(fa_busc_para('p_codi_oper_vta')),
    p_emit_reci                   varchar2(500) := 'E',
    p_codi_impu_exen              number(20, 4) := to_number(fa_busc_para('p_codi_impu_exen')),
    p_codi_impu_grav10            number(20, 4) := to_number(fa_busc_para('p_codi_impu_grav10')),
    p_codi_impu_grav5             number(20, 4) := to_number(fa_busc_para('p_codi_impu_grav5')),
    p_codi_mone_mmnn              number(20, 4) := to_number(fa_busc_para('p_codi_mone_mmnn')),
    p_codi_mone_mmee              number(20, 4) := to_number(fa_busc_para('p_codi_mone_mmee')),
    p_cant_deci_porc              number(20, 4) := to_number(fa_busc_para('p_cant_deci_porc')),
    p_cant_deci_mmnn              number(20, 4) := to_number(fa_busc_para('p_cant_deci_mmnn')),
    p_cant_deci_mmee              number(20, 4) := to_number(fa_busc_para('p_cant_deci_mmee')),
    p_cant_deci_cant              number(20, 4) := to_number(fa_busc_para('p_cant_deci_cant')),
    p_cant_deci_prec_unit_vent    number(20, 4) := to_number(fa_busc_para('p_cant_deci_prec_unit_vent')),
    p_indi_vali_repe_cheq         varchar2(500) := rtrim(ltrim(fa_busc_para('p_indi_vali_repe_cheq'))),
    p_codi_impu_ortr              number(20, 4) := fa_busc_para('p_codi_impu_ortr'),
    p_form_cons_stoc              varchar2(500) := fa_busc_para('p_form_cons_stoc'),
    p_form_anul_stoc              varchar2(500) := fa_busc_para('p_form_anul_stoc'),
    p_form_modi_fact              varchar2(500) := fa_busc_para('p_form_modi_fact'),
    p_codi_base                   number := pack_repl.fa_devu_codi_base,
    p_perm_stoc_nega              varchar2(500) := ltrim(rtrim(fa_busc_para('p_perm_stoc_nega'))),
    p_form_impr_fact              varchar2(500) := ltrim(rtrim(fa_busc_para('p_form_impr_fact'))),
    p_form_impr_paga              varchar2(500) := ltrim(rtrim(fa_busc_para('p_form_impr_paga'))),
    p_form_impr_bole              varchar2(500) := ltrim(rtrim(fa_busc_para('p_form_impr_bole'))),
    p_indi_requ_auto_pedi         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_requ_auto_pedi'))),
    p_indi_most_nume_pres         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_most_nume_pres'))),
    p_indi_nume_pres_obli         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_nume_pres_obli'))),
    p_indi_habi_ortr              varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_habi_ortr'))),
    p_porc_util_mini_fact         varchar2(500) := to_number(fa_busc_para('p_porc_util_mini_fact')),
    p_codi_peri_sgte              varchar2(500) := to_number(fa_busc_para('p_codi_peri_sgte')),
    p_form_abmc_clie_vtas         varchar2(500) := fa_busc_para('p_form_abmc_clie_vtas'),
    p_indi_perm_timo_bole         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_perm_timo_bole'))),
    p_codi_timo_pcoe              number(20, 4) := to_number(fa_busc_para('p_codi_timo_pcoe')),
    p_codi_timo_pcre              number(20, 4) := to_number(fa_busc_para('p_codi_timo_pcre')),
    p_indi_divi_fact_auto         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_divi_fact_auto'))),
    p_indi_most_nume_remi         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_most_nume_remi'))),
    p_ind_validar_cab             varchar2(5) := 'S',
    p_ind_validar_det             varchar2(5) := 'S',
    p_mens_divi_fact              varchar2(5) := 'S',
    p_disp_actu_regi              varchar2(5) := 'N',
    p_indi_nave_form_pago         varchar2(5) := 'N',
    p_indi_modi_prec_unit_fact    varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_modi_prec_unit_fact'))),
    p_indi_modi_nume_fact         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_modi_nume_fact'))),
    p_indi_most_linea_impr_tota   varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_most_linea_impr_tota'))),
    p_indi_obli_form_entr         varchar2(500) := upper(ltrim(rtrim(fa_busc_para('p_indi_obli_form_entr')))),
    p_indi_most_form_entr         varchar2(500) := upper(ltrim(rtrim(fa_busc_para('p_indi_most_form_entr')))),
    p_indi_most_form_pago         varchar2(500) := upper(ltrim(rtrim(fa_busc_para('p_indi_most_form_pago')))),
    p_indi_obli_form_pago         varchar2(500) := upper(ltrim(rtrim(fa_busc_para('p_indi_obli_form_pago')))),
    p_codi_form_pago_defa         number(20, 4) := to_number(fa_busc_para('p_codi_form_pago_defa')),
    p_vali_deto_matr_prec         varchar2(500) := ltrim(rtrim(fa_busc_para('p_vali_deto_matr_prec'))),
    p_camb_prod_auto_fact         varchar2(500) := ltrim(rtrim(fa_busc_para('p_camb_prod_auto_fact'))),
    p_codi_timo_rcnadlr           varchar2(500) := ltrim(rtrim(fa_busc_para('p_codi_timo_rcnadlr'))),
    p_codi_timo_rcnadle           varchar2(500) := ltrim(rtrim(fa_busc_para('p_codi_timo_rcnadle'))),
    p_codi_timo_adle              number(20, 4) := to_number(fa_busc_para('p_codi_timo_adle')),
    p_form_empa                   number(20, 4) := to_number(fa_busc_para('p_form_empa')),
    p_indi_fact_sub_clie          varchar2(5) := 'N', --ltrim(rtrim(fa_busc_para ('p_indi_fact_sub_clie'))),
    p_codi_clas1_clie_subclie     number(20, 4) := to_number(fa_busc_para('p_codi_clas1_clie_subclie')),
    p_most_fact_cobr_dife         varchar2(500) := ltrim(rtrim(fa_busc_para('p_most_fact_cobr_dife'))),
    p_cant_dias_cuot_mens         number(20, 4) := to_number(fa_busc_para('p_cant_dias_cuot_mens')),
    p_indi_entr_depo              varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_entr_depo'))),
    p_codi_oper_prod_mas          number(20, 4) := to_number(fa_busc_para('p_codi_oper_prod_mas')),
    p_codi_oper_prod_men          number(20, 4) := to_number(fa_busc_para('p_codi_oper_prod_men')),
    p_indi_most_tecn_deta         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_most_tecn_deta'))),
    p_indi_fopa_chta_caja         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_fopa_chta_caja'))),
    p_codi_timo_extr_banc         number(20, 4) := to_number(fa_busc_para('p_codi_timo_extr_banc')),
    p_codi_conc_cheq_cred         number(20, 4) := to_number(fa_busc_para('p_codi_conc_cheq_cred')),
    p_codi_conc_vta               number(20, 4) := to_number(fa_busc_para('p_codi_conc_vta')),
    p_vali_remi_nume_anti         varchar2(50) := fa_busc_para('p_vali_remi_nume_anti'),
    p_form_orde_trab              varchar2(500) := ltrim(rtrim(fa_busc_para('p_form_orde_trab'))),
    p_indi_cuot_entr              varchar2(50) := 'N', ---asignar formato de impresion por sucusal
    v_indi_vali_cier_caja         varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_vali_cier_caja'))),
    v_cant_cier_caja              varchar2(500) := ltrim(rtrim(fa_busc_para('p_cant_cier_caja'))),
    p_indi_carg_secu_bole_pres    varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_carg_secu_bole_pres'))),
    p_indi_vali_exis_min_fact     varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_VALI_EXIS_MIN_FACT'))),
    p_indi_vali_clie_prov_dato    varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_vali_clie_prov_dato'))),
    p_indi_mens_vali              varchar2(1),
    p_indi_actu_secu              varchar2(10),
    p_actu_situ_clie              varchar2(1),
    p_peco_codi                   number,
    p_movi_codi_kit_men           number,
    p_movi_codi_kit_mas           number);
  parameter t_parameter;

  type t_bcab is record(
    clpr_codi                come_clie_prov.clpr_codi%type,
    clpr_indi_vali_limi_cred come_clie_prov.clpr_indi_vali_limi_cred%type,
    clpr_cli_situ_codi       come_clie_prov.clpr_cli_situ_codi%type,
    clpr_indi_list_negr      come_clie_prov.clpr_indi_list_negr%type,
    clpr_indi_exce           come_clie_prov.clpr_indi_exce%type,
    clpr_indi_vali_situ_clie come_clie_prov.clpr_indi_vali_situ_clie%type,
    clpr_indi_exen           come_clie_prov.clpr_indi_exen%type,
    clpr_maxi_porc_deto      come_clie_prov.clpr_maxi_porc_deto%type,
    clpr_segm_codi           come_clie_prov.clpr_segm_codi%type,
    clpr_clie_clas1_codi     come_clie_prov.clpr_clie_clas1_codi%type,
    clpr_indi_vali_prec_mini come_clie_prov.clpr_indi_vali_prec_mini%type,
    clpr_orte_codi           come_clie_prov.clpr_orte_codi%type,
    clpr_list_codi           come_clie_prov.clpr_list_codi%type,
    clpr_agen_desc           varchar2(500),
    clpr_fech_regi           come_clie_prov.clpr_fech_regi%type,
    clpr_info_per1           come_clie_docu_info.cldo_info_per1%type,
    clpr_info_per2           come_clie_docu_info.cldo_info_per2%type,
    clpr_info_per3           come_clie_docu_info.cldo_info_per3%type,
    clpr_zona_codi           come_clie_prov.clpr_zona_codi%type,
    colo_obse_timb           varchar2(150),
    s_clpr_agen_codi         come_clie_prov.clpr_empl_codi%type,
    s_clpr_codi_alte         come_clie_prov.clpr_codi_alte%type,
    s_orte_desc              come_orde_term.orte_desc%type,
    s_orte_maxi_porc         come_orde_term.orte_maxi_porc%type,
    s_orte_cant_cuot         come_orde_term.orte_cant_cuot%type,
    s_orte_porc_entr         come_orde_term.orte_porc_entr%type,
    s_orte_impo_cuot         come_orde_term.orte_impo_cuot%type,
    s_orte_dias_cuot         come_orde_term.orte_dias_cuot%type,
    s_timo_calc_iva          come_tipo_movi.timo_calc_iva%type,
    s_timo_indi_caja         come_tipo_movi.timo_indi_caja%type,
    s_limi_cred_mone         number(20, 4),
    s_sald_clie_mone         number(20, 4),
    s_total                  number(20, 4),
    s_pres_codi              number,
    s_exen                   number(20, 4),
    s_grav_5_ii              number(20, 4),
    s_grav_10_ii             number(20, 4),
    s_grav                   number(20, 4),
    s_iva_10                 number(20, 4),
    s_iva_5                  number(20, 4),
    s_iva                    number(20, 4),
    s_tot_iva                number(20, 4),
    s_total_dto              number(20, 4),
    s_impo_adel              number(20, 4),
    s_impo_cheq              number(20, 4),
    s_impo_efec              number(20, 4),
    s_impo_rete_reci         number(20, 4),
    s_impo_tarj              number(20, 4),
    s_impo_vale              number(20, 4),
    s_indi_vali_subc         varchar2(1),
    s_prec_maxi_deto         number(20, 4),
    s_obse_timb              varchar2(500),
    s_pres_impo_deto         number,
    s_sald_limi_cred         number,
    s_sum_impo_mmnn          number,
    s_sum_impo_movi          number,
    sucu_nume_item           come_clpr_sub_cuen.sucu_nume_item%type,
    sucu_desc                come_clpr_sub_cuen.sucu_desc%type,
    movi_indi_cobr_dife      come_movi.movi_indi_cobr_dife%type,
    movi_orte_codi           number,
    movi_oper_desc           varchar2(200),
    movi_oper_desc_abre      varchar2(200),
    movi_afec_sald           come_movi.movi_afec_sald%type,
    movi_banc_codi           number,
    movi_clpr_codi           come_movi.movi_clpr_codi%type,
    movi_clpr_desc           come_movi.movi_clpr_desc%type,
    movi_clpr_dire           come_movi.movi_clpr_dire%type,
    movi_clpr_ruc            come_movi.movi_clpr_ruc%type,
    movi_clpr_tele           come_movi.movi_clpr_tele%type,
    movi_codi                come_movi.movi_codi%type,
    movi_dbcr                come_movi.movi_dbcr%type,
    movi_depo_codi_orig      come_movi.movi_depo_codi_orig%type,
    movi_empl_codi           number,
    movi_inve_codi           number,
    movi_sub_clpr_codi       number,
    movi_emit_rec            varchar2(200),
    movi_emit_reci           come_movi.movi_emit_reci%type,
    movi_empr_codi           come_movi.movi_empr_codi%type,
    movi_exen_mmnn           come_movi.movi_exen_mmnn%type,
    movi_exen_mone           come_movi.movi_exen_mone%type,
    movi_fech_emis           come_movi.movi_fech_emis%type,
    movi_fech_grab           come_movi.movi_fech_grab%type,
    movi_fech_oper           come_movi.movi_fech_oper%type,
    movi_grav_mmee           come_movi.movi_grav_mmee%type,
    movi_grav_mmnn           come_movi.movi_grav_mmnn%type,
    movi_grav_mone           come_movi.movi_grav_mone%type,
    movi_grav10_ii_mmnn      come_movi.movi_grav10_ii_mmnn%type,
    movi_grav10_ii_mone      come_movi.movi_grav10_ii_mone%type,
    movi_grav10_mmnn         come_movi.movi_grav10_mmnn%type,
    movi_grav10_mone         come_movi.movi_grav10_mone%type,
    movi_grav5_ii_mmnn       come_movi.movi_grav5_ii_mmnn%type,
    movi_grav5_ii_mone       come_movi.movi_grav5_ii_mone%type,
    movi_grav5_mmnn          come_movi.movi_grav5_mmnn%type,
    movi_grav5_mone          come_movi.movi_grav5_mone%type,
    movi_impo_mmnn_ii        come_movi.movi_impo_mmnn_ii%type,
    movi_impo_mone_ii        come_movi.movi_impo_mone_ii%type,
    movi_indi_cons           come_movi.movi_indi_cons%type,
    movi_iva_mmnn            come_movi.movi_iva_mmnn%type,
    movi_iva_mone            come_movi.movi_iva_mone%type,
    movi_iva10_ii_mmnn       number,
    movi_iva10_ii_mone       number,
    movi_iva10_mmnn          come_movi.movi_iva10_mmnn%type,
    movi_iva10_mone          come_movi.movi_iva10_mone%type,
    movi_iva5_ii_mmnn        number,
    movi_iva5_ii_mone        number,
    movi_iva5_mmnn           come_movi.movi_iva5_mmnn%type,
    movi_iva5_mone           come_movi.movi_iva5_mone%type,
    movi_mone_cant_deci      number,
    movi_mone_codi           come_movi.movi_mone_codi%type,
    movi_mone_desc_abre      varchar2(50),
    movi_nume                come_movi.movi_nume%type,
    movi_nume_timb           come_movi.movi_nume_timb%type,
    movi_obse                come_movi.movi_obse%type,
    movi_oper_codi           come_movi.movi_oper_codi%type,
    movi_sald_mmee           come_movi.movi_sald_mmee%type,
    movi_sald_mmnn           come_movi.movi_sald_mmnn%type,
    movi_sald_mone           come_movi.movi_sald_mone%type,
    movi_stoc_afec_cost_prom come_movi.movi_stoc_afec_cost_prom%type,
    movi_stoc_suma_rest      come_movi.movi_stoc_suma_rest%type,
    movi_sucu_codi_orig      come_movi.movi_sucu_codi_orig%type,
    movi_tasa_mmee           come_movi.movi_tasa_mmee%type,
    movi_tasa_mone           come_movi.movi_tasa_mone%type,
    movi_tasa_come           number,
    movi_timo_codi           come_movi.movi_timo_codi%type,
    movi_timo_indi_adel      varchar2(200),
    movi_timo_indi_ncr       varchar2(200),
    movi_timo_indi_sald      varchar2(200),
    movi_user                come_movi.movi_user%type,
    movi_nume_orig           number,
    movi_orte_codi_ante      number,
    moco_ceco_codi           number,
    moco_impo_diar_mone      number,
    movi_form_entr_codi      number,
    movi_indi_cant_diar      varchar2(1),
    movi_indi_diar           varchar2(1),
    movi_indi_most_fech      varchar2(1),
    movi_nume_auto_impr      number,
    movi_nume_oc             number,
    deta_impo_mone_ii        number(20, 4),
    depo_codi_alte_orig      number,
    empl_codi_alte           number,
    empl_maxi_porc_deto      number,
    exde_codi                number,
    fech_emis_hora           date,
    fech_inic_timb           date,
    fech_venc_timb           date,
    timo_tica_codi           number,
    timo_indi_cont_cred      varchar2(5000),
    timo_dbcr_caja           varchar2(22),
    timo_indi_apli_adel_fopa varchar(22),
    tico_codi                number,
    tico_indi_vali_nume      varchar2(10),
    tico_fech_rein           date,
    tico_indi_habi_timb      varchar2(10),
    tico_indi_timb           varchar2(4),
    tico_indi_timb_auto      varchar2(22),
    tico_indi_vali_timb      varchar2(22),
    list_codi                number,
    lide_indi_vali_prec_mini varchar2(4),
    lide_maxi_porc_deto      number,
    pres_nume                number,
    orte_list_codi           number,
    ortr_desc                varchar2(500),
    ortr_desc_pres           varchar2(500),
    user_depo_codi_alte      number,
    user_empl_codi_alte      number,
    user_indi_modi_obse_fact varchar2(22),
    user_indi_real_s_exce    varchar2(22));
  bcab t_bcab;

  type t_bdet is record(
    sessio                        varchar2(800),
    usuario                       varchar2(800),
    seq_id                        number,
    nombre_del_informe            varchar2(800),
    indi_prod_ortr                varchar2(1),
    prod_desc                     varchar2(800),
    medi_desc                     varchar2(800),
    prod_codi_alfa                number,
    deta_prod_codi                number,
    coba_codi_barr                varchar2(500),
    deta_medi_codi                number,
    deta_prec_unit                number(20, 4),
    deta_cant_medi                number(20, 4),
    deta_porc_deto                number(20, 4),
    movi_mone_cant_deci           number(20, 4),
    movi_tasa_mone                number(20, 4),
    conc_dbcr                     varchar2(1),
    deta_impu_porc                number(20, 4),
    deta_impu_porc_base_impo      number(20, 4),
    deta_impu_indi_baim_impu_incl varchar2(10),
    s_descuento                   number(20, 4),
    sum_s_descuento               number(20, 4),
    sum_deta_grav10_mone_ii       number(20, 4),
    sum_deta_grav5_mone_ii        number(20, 4),
    sum_deta_exen_mone            number(20, 4),
    sum_deta_iva5_mone            number(20, 4),
    sum_deta_iva10_mone           number(20, 4),
    sum_deta_grav10_mone          number(20, 4),
    sum_deta_grav5_mone           number(20, 4),
    sum_deta_impo_mmnn_ii         number(20, 4),
    sum_deta_exen_mmnn            number(20, 4),
    sum_deta_grav10_mmnn_ii       number(20, 4),
    sum_deta_grav5_mmnn_ii        number(20, 4),
    sum_deta_iva10_mmnn_ii        number(20, 4),
    sum_deta_iva5_mmnn_ii         number(20, 4),
    sum_deta_iva10_mmnn           number(20, 4),
    sum_deta_iva5_mmnn            number(20, 4),
    sum_deta_grav10_mmnn          number(20, 4),
    sum_deta_grav5_mmnn           number(20, 4),
    deta_impo_mone_ii             number(20, 4),
    deta_impo_mmnn_ii             number(20, 4),
    deta_grav10_mone_ii           number(20, 4),
    deta_grav5_mone_ii            number(20, 4),
    deta_grav10_mone              number(20, 4),
    deta_grav5_mone               number(20, 4),
    deta_iva10_mone               number(20, 4),
    deta_iva5_mone                number(20, 4),
    deta_exen_mone                number(20, 4),
    deta_grav10_mmnn_ii           number(20, 4),
    deta_grav5_mmnn_ii            number(20, 4),
    deta_grav10_mmnn              number(20, 4),
    deta_grav5_mmnn               number(20, 4),
    deta_iva10_mmnn               number(20, 4),
    deta_iva5_mmnn                number(20, 4),
    deta_exen_mmnn                number(20, 4),
    deta_impo_mmnn                number(20, 4),
    deta_impo_mone                number(20, 4),
    deta_iva_mmnn                 number(20, 4),
    deta_iva_mone                 number(20, 4),
    coba_fact_conv                number,
    deta_cant                     number,
    deta_lote_codi                number,
    prod_indi_fact_nega           varchar2(2),
    deta_impu_codi                number,
    deta_prec_unit_list           number,
    prod_indi_kitt                varchar2(1),
    deta_nume_item                number,
    deta_prod_prec_maxi_deto      number,
    deta_prod_prec_maxi_deto_exen number,
    deta_empl_codi                number);
  bdet t_bdet;

  type t_deta is record(
    sessio              varchar2(80),
    usuario             varchar2(80),
    seq_id              number,
    nombre_del_informe  varchar2(80),
    indi_prod_ortr      varchar2(1),
    prod_desc           varchar2(80),
    medi_desc           varchar2(80),
    prod_codi_alfa      number,
    deta_prod_codi      number,
    coba_codi_barr      varchar2(50),
    deta_medi_codi      number,
    deta_cant_medi      number(20, 4),
    deta_prec_unit      number(20, 4),
    deta_porc_deto      number(20, 4),
    deta_impo_mone_ii   number(20, 4),
    s_descuento         number(20, 4),
    deta_impo_mmnn_ii   number(20, 4),
    deta_grav10_mone_ii number(20, 4),
    deta_grav5_mone_ii  number(20, 4),
    deta_grav10_mone    number(20, 4),
    deta_grav5_mone     number(20, 4),
    deta_iva10_mone     number(20, 4),
    deta_iva5_mone      number(20, 4),
    deta_exen_mone      number(20, 4),
    deta_grav10_mmnn_ii number(20, 4),
    deta_grav5_mmnn_ii  number(20, 4),
    deta_grav10_mmnn    number(20, 4),
    deta_grav5_mmnn     number(20, 4),
    deta_iva10_mmnn     number(20, 4),
    deta_iva5_mmnn      number(20, 4),
    deta_exen_mmnn      number(20, 4),
    deta_impo_mmnn      number(20, 4),
    deta_impo_mone      number(20, 4),
    deta_iva_mmnn       number(20, 4),
    deta_iva_mone       number(20, 4),
    coba_fact_conv      number,
    deta_cant           number);

  type tt_deta is table of t_deta index by binary_integer;
  ta_bdet tt_deta;

  /********************** funciones reutilizadas **************************/
  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010,
                            dbms_utility.format_error_backtrace || ' ' ||
                            v_mensaje);
  end pl_me;

  procedure pp_envi_resp(i_mensaje varchar2) is
  begin
  
    setitem('P20_O_RESP_DESC', i_mensaje);
    setitem('P20_O_RESP_CODI', 2); --Solo se avisa al usuario, no se corta la operativa
  
  end;

  /********************** ACTUALIZAR REGISTROS **************************/
  procedure pp_actualizar_registro is
    p_indi_mens_vali varchar2(5);
  begin
    --cargamos las variables
    begin
      i020168.pp_set_variable;
    
    exception
      when others then
        raise_application_error(-20010,
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || '11');
    end;
  
    -- validaciones
    I020168.pp_validar_cabecera;
    I020168.pp_validar_detalle;
  
    --iniciamos carga de datos
    declare
    
      salir       exception;
      v_record    number;
      v_list_codi number;
      v_count     number;
    
    begin
    
      begin
        i020168.pp_actualiza_cred_espe;
      exception
        when others then
          raise_application_error(-20010,
                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                  'pp_actualiza_cred_espe');
      end;
    
      --  raise_application_error(-20010, 'PASO ACA');
      if bcab.movi_codi is null then
        -- Si la cantidad de registros supera a limite de impresion se dividen los documentos
        /*if i.w_tot_reg > nvl(parameter.p_maxi_line_impr_fact, 1) and
           nvl(upper(parameter.p_indi_divi_fact_auto), 'N') = 'S' then
          if nvl(bcab.s_timo_calc_iva, 'N') <> 'N' then
            --Si afecta saldo es fact legal y hace la division
            pp_dividir_factura;
          
            if nvl(bcab.movi_afec_sald, 'N') = 'C' then
              --si es Credito
              pp_actualiza_come_movi_cuot_df;
            end if;
            pp_actualiza_moimpu_df_2;
          
            if rtrim(ltrim(bcab.movi_afec_sald)) = 'N' then
              -- si no es Credito
              if nvl(bcab.movi_indi_cobr_dife, 'N') = 'N' then
                pp_actualiza_moimpo_df2;
              end if;
            end if;
          
          else
            if nvl(parameter.p_indi_carg_secu_bole_pres, 'N') <> 'S' then
              --si no carga la misma numeracion del presupuesto como nro de boleta
              pp_dividir_factura;
            
              if nvl(bcab.movi_afec_sald, 'N') = 'C' then
                --si es Credito
                pp_actualiza_come_movi_cuot_df;
              end if;
              pp_actualiza_moimpu_df_2;
            
              if rtrim(ltrim(bcab.movi_afec_sald)) = 'N' then
                -- si no es Credito
                if nvl(bcab.movi_indi_cobr_dife, 'N') = 'N' then
                  pp_actualiza_moimpo_df2;
                end if;
              end if;
            
            else
              --Si la boleta carga con la misma numeracion del presupuesto se hace el proceso normal
              pp_actualiza_come_movi;
              pp_actualiza_movi_conc_prod;
            
              if nvl(bcab.movi_afec_sald, 'N') = 'C' then
                --si es Credito 
                pp_actualiza_come_movi_cuot;
              end if;
              pp_actualiza_moimpu;
            
              if rtrim(ltrim(bcab.movi_afec_sald)) = 'N' then
                -- si no es Credito
                if nvl(bcab.movi_indi_cobr_dife, 'N') = 'N' then
                  pl_fp_actualiza_moimpo;
                end if;
              end if;
            end if;
          end if;
        
        else  
        null;  
         end if;*/
      
        -- Si la cantidad de registros no supera a limite de impresion el proceso es normal
        begin
          i020168.pp_actualiza_come_movi;
        exception
          when others then
            raise_application_error(-20010,
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                    'pp_actualiza_come_movi');
        end;
      
        begin
          i020168.pp_actualiza_movi_conc_prod;
        exception
          when others then
            raise_application_error(-20010,
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                    'pp_actualiza_movi_conc_prod ' ||
                                    sqlerrm);
        end;
      
        if nvl(bcab.movi_afec_sald, 'N') = 'C' then
          --si es Credito 
          begin
          
            --raise_application_error(-20010, bcab.movi_codi ||' every '||bcab.movi_tasa_mone);
          
            pack_cuota.pp_actualiza_come_movi_cuot(i_movi_codi           => bcab.movi_codi,
                                                   i_movi_tasa_mone      => bcab.movi_tasa_mone,
                                                   i_movi_timo_indi_sald => bcab.movi_timo_indi_sald,
                                                   i_movi_impo_mmnn_ii   => bcab.s_total);
          exception
            when others then
              raise_application_error(-20010,
                                      DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                      ' Hay un inconveniente al momento de guardar datos de la cuota, favor comunicarse con el Dto. de Informática');
          end;
        
        end if;
      
        --come_movi_impu_deta
        begin
          i020168.pp_actualiza_moimpu;
        end;
      
        if rtrim(ltrim(bcab.movi_afec_sald)) = 'N' then
          -- si no es Credito
          if nvl(bcab.movi_indi_cobr_dife, 'N') = 'N' then
            begin
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
                                                i_s_impo_rete         => null,
                                                i_s_impo_rete_rent    => null);
            exception
              when others then
                raise_application_error(-20010,
                                        DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                        ' Hay un inconveniente al momento de guardar Importes, favor comunicarse con el Dto. de Informática');
            end;
          end if;
        end if;
      
        -----------Actualizacion de Remision--------------
        /* 
          if nvl(parameter.p_indi_fact_cred_impr_remi, 'N') = 'S' and
             nvl(bcab.movi_afec_sald, 'N') = 'C' and
             nvl(upper(parameter.p_para_inic), 'A') <> 'VEND' then
            if bcab.s_remi_codi is null then
              --verificar si no se factura desde una remision,si es asi ya no genera una nueva remision
              if :bremi_merc.remi_movi_nume =
                 nvl(:bremi_merc.remi_movi_nume_orig, 0) then
                --pp_veri_nume_remi(:bremi_merc.remi_movi_nume); -- ya no busca el nro libre a pedido de JR
                null;
              end if;
            
              pp_actualiza_come_remi;
              pp_actualiza_come_remi_deta;
            
              if bcab.movi_nume <> bcab.movi_nume_orig then
                -- si el numero es distinto al traido de secuencia no se actualiza
                pp_actualiza_come_secu(:bremi_merc.remi_movi_nume, 'N');
              else
                pp_actualiza_come_secu(:bremi_merc.remi_movi_nume, 'S');
              end if;
            
              if bcab.movi_codi is not null then
                pp_actualiza_factura(bcab.movi_codi);
              end if;
            end if;
          end if;
          -------------------------------------------------
        */
      
        begin
          i020168.pp_actu_clie_exce;
        end;
      
        begin
          i020168.pp_gene_mens;
        end;
      
        begin
          i020168.pp_actu_secu(nvl(parameter.p_indi_actu_secu, 'S'));
        end;
      
        begin
          i020168.pp_actu_pres;
        end;
      
        begin
          env_fact_sifen.pp_get_json_fact(bcab.movi_codi);
        end;
      
        commit;
      
        /*if nvl(parameter.p_indi_fact_cred_impr_remi, 'N') = 'S' and
           nvl(bcab.movi_afec_sald, 'N') = 'C' and
           nvl(upper(parameter.p_para_inic), 'A') <> 'VEND' then
          if bcab.s_remi_codi is null then
            pp_impr_remi;
          end if;
        end if;*/
      
        if nvl(parameter.p_actu_situ_clie, 'N') = 'S' then
        
          select count(*)
            into v_count
            from all_triggers a
           where a.trigger_name = 'AUDI_COME_CLIE_PROV';
        
          if v_count > 0 then
            pa_ejecuta_dll_auto('ALTER TRIGGER AUDI_COME_CLIE_PROV ENABLE');
          end if;
        
        end if;
      
        begin
          I020168.pp_llamar_reporte_facturas(p_usuario => gen_user,
                                             p_codigo  => bcab.movi_codi);
        end;
      
        --LIMPIAMOS EL DETALLE 
        pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => p_sess,
                                           i_taax_user => gen_user);
      
        apex_collection.delete_all_collections_session;
      
        /*if bcab.movi_afec_sald = 'C' then
          if parameter.p_indi_impr_cont_soli_cred = 'S' then
            pp_impr_cont_soli_cred;
          end if;
          pp_impr_paga;
          if parameter.p_indi_impr_deta_cuot = 'S' then
            pp_impr_deta_cuot;
          end if;
        end if;
        pp_enviar_empaque;*/
      
      else
        pl_me('El registro ya fue ingresado, favor verifique la Venta!!!!');
      end if;
    
      /*exception
        when salir then
           raise_application_error(-20010,
                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                  '99');
        when others then 
           raise_application_error(-20010,
                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                  '100');
      */
    end;
  exception
    when others then
      raise_application_error(-20010,
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                              'pp_actualiza_cred_espe');
    
  end pp_actualizar_registro;

  /******************** carga de datos y validaciones *****************/

  procedure pp_set_variable is
  begin
  
    bcab.movi_fech_emis      := v('P20_FECH_EMIS');
    bcab.fech_venc_timb      := v('P20_FECH_VENC_TIMB');
    bcab.clpr_segm_codi      := v('P20_CLPR_SEGM_CODI');
    bcab.list_codi           := v('P20_LIST_CODI');
    bcab.movi_orte_codi      := v('P20_MOVI_ORTE_CODI');
    bcab.movi_mone_cant_deci := v('P20_CANT_DECI');
    bcab.movi_tasa_mone      := v('P20_MOVI_TASA_MONE');
  
    bcab.deta_impo_mone_ii := v('P20_DETA_IMPO_MONE_II');
    --bcab.avis_inve                  := v('P20_AVIS_INVE');
    --bcab.buscar_por                 := v('P20_BUSCAR_POR');
    --bcab.cant_deci                  := v('P20_CANT_DECI');
    --bcab.cant_deci_2                := v('P20_CANT_DECI_2');
    bcab.clpr_agen_desc       := v('P20_CLPR_AGEN_DESC');
    bcab.clpr_clie_clas1_codi := v('P20_CLPR_CLIE_CLAS1_CODI');
    bcab.clpr_cli_situ_codi   := v('P20_CLPR_CLI_SITU_CODI');
    bcab.clpr_codi            := v('P20_CLPR_CODI');
    --bcab.clpr_fech_modi             := v('P20_CLPR_FECH_MODI');
    bcab.clpr_fech_regi           := v('P20_CLPR_FECH_REGI');
    bcab.clpr_indi_exce           := v('P20_CLPR_INDI_EXCE');
    bcab.clpr_indi_exen           := v('P20_CLPR_INDI_EXEN');
    bcab.clpr_indi_list_negr      := v('P20_CLPR_INDI_LIST_NEGR');
    bcab.clpr_indi_vali_limi_cred := v('P20_CLPR_INDI_VALI_LIMI_CRED');
    bcab.clpr_indi_vali_prec_mini := v('P20_CLPR_INDI_VALI_PREC_MINI');
    bcab.clpr_indi_vali_situ_clie := v('P20_CLPR_INDI_VALI_SITU_CLIE');
    bcab.clpr_info_per1           := v('P20_CLPR_INFO_PER1');
    bcab.clpr_info_per2           := v('P20_CLPR_INFO_PER2');
    bcab.clpr_info_per3           := v('P20_CLPR_INFO_PER3');
    bcab.clpr_list_codi           := v('P20_CLPR_LIST_CODI');
    bcab.clpr_maxi_porc_deto      := v('P20_CLPR_MAXI_PORC_DETO');
    bcab.clpr_orte_codi           := v('P20_CLPR_ORTE_CODI');
    bcab.clpr_segm_codi           := v('P20_CLPR_SEGM_CODI');
    bcab.clpr_zona_codi           := v('P20_CLPR_ZONA_CODI');
  
    bcab.colo_obse_timb := v('P20_COLO_OBSE_TIMB');
    -- bcab.conc_dbcr                  := v('P20_CONC_DBCR');
    bcab.depo_codi_alte_orig      := v('P20_DEPO_CODI_ALTE_ORIG');
    bcab.empl_codi_alte           := v('P20_EMPL_CODI_ALTE');
    bcab.movi_empl_codi           := v('P20_EMPL_CODI_ALTE');
    bcab.empl_maxi_porc_deto      := v('P20_EMPL_MAXI_PORC_DETO');
    bcab.fech_emis_hora           := v('P20_FECH_EMIS_HORA');
    bcab.fech_inic_timb           := v('P20_FECH_INIC_TIMB');
    bcab.fech_venc_timb           := v('P20_FECH_VENC_TIMB');
    bcab.lide_indi_vali_prec_mini := v('P20_LIDE_INDI_VALI_PREC_MINI');
    bcab.lide_maxi_porc_deto      := v('P20_LIDE_MAXI_PORC_DETO');
    bcab.list_codi                := v('P20_LIST_CODI');
    bcab.moco_ceco_codi           := v('P20_MOCO_CECO_CODI');
    bcab.moco_impo_diar_mone      := v('P20_MOCO_IMPO_DIAR_MONE');
    bcab.movi_clpr_codi           := v('P20_CLPR_CODI');
    bcab.movi_afec_sald           := v('P20_MOVI_AFEC_SALD');
    bcab.movi_clpr_dire           := v('P20_MOVI_CLPR_DIRE');
    bcab.movi_clpr_ruc            := v('P20_MOVI_CLPR_RUC');
    bcab.movi_clpr_tele           := v('P20_MOVI_CLPR_TELE');
    bcab.movi_dbcr                := v('P20_MOVI_DBCR');
    bcab.movi_emit_reci           := v('P20_MOVI_EMIT_RECI');
    bcab.movi_form_entr_codi      := v('P20_MOVI_FORM_ENTR_CODI');
    bcab.movi_indi_cant_diar      := v('P20_MOVI_INDI_CANT_DIAR');
    bcab.movi_indi_cobr_dife      := v('P20_MOVI_INDI_COBR_DIFE');
    bcab.movi_indi_diar           := v('P20_MOVI_INDI_DIAR');
    bcab.movi_indi_most_fech      := v('P20_MOVI_INDI_MOST_FECH');
    bcab.movi_mone_codi           := v('P20_MOVI_MONE_CODI');
    bcab.movi_nume                := v('P20_MOVI_NUME');
    bcab.movi_nume_auto_impr      := v('P20_MOVI_NUME_AUTO_IMPR');
    bcab.movi_nume_oc             := v('P20_MOVI_NUME_OC');
    bcab.movi_nume_orig           := v('P20_MOVI_NUME_ORIG');
    bcab.movi_nume_timb           := v('P20_MOVI_NUME_TIMB');
    bcab.movi_obse                := v('P20_MOVI_OBSE');
    bcab.movi_oper_codi           := v('P20_MOVI_OPER_CODI');
    bcab.movi_orte_codi           := v('P20_MOVI_ORTE_CODI');
    bcab.movi_orte_codi_ante      := v('P20_MOVI_ORTE_CODI_ANTE');
    bcab.movi_tasa_come           := v('P20_MOVI_TASA_COME');
    bcab.movi_tasa_mone           := v('P20_MOVI_TASA_MONE');
    bcab.movi_timo_codi           := v('P20_MOVI_TIMO_CODI');
    bcab.movi_timo_indi_sald      := v('P20_MOVI_TIMO_INDI_SALD');
    bcab.movi_sucu_codi_orig      := v('P20_MOVI_SUCU_CODI_ORIG');
    bcab.movi_empr_codi           := p_empr_codi;
  
    bcab.orte_list_codi := v('P20_ORTE_LIST_CODI');
    bcab.ortr_desc      := v('P20_ORTR_DESC');
    bcab.ortr_desc_pres := v('P20_ORTR_DESC_PRES');
    --  bcab.pres_esta_pres           := v('P20_PRES_ESTA_PRES');
    --  bcab.prec_maxi_deto           := v('P20_PREC_MAXI_DETO');
    --  bcab.pres_indi_user_deto      := v('P20_PRES_INDI_USER_DETO');
    -- bcab.pres_nume                := v('P20_PRES_NUME');
  
    --  bcab.remi_nume                := v('P20_REMI_NUME');
    -- bcab.s_clpr_agen_codi         := v('P20_S_CLPR_AGEN_CODI');
    -- bcab.s_clpr_agen_codi_alte    := v('P20_S_CLPR_AGEN_CODI_ALTE');
    -- bcab.s_cred_espe_mone         := v('P20_S_CRED_ESPE_MONE');
    bcab.s_exen           := v('P20_S_EXEN');
    bcab.s_grav_10_ii     := v('P20_S_GRAV_10_II');
    bcab.s_grav_5_ii      := v('P20_S_GRAV_5_II');
    bcab.s_impo_adel      := v('P20_S_IMPO_ADEL');
    bcab.s_impo_cheq      := v('P20_S_IMPO_CHEQ');
    bcab.s_impo_efec      := v('P20_S_IMPO_EFEC');
    bcab.s_impo_rete_reci := v('P20_S_IMPO_RETE_RECI');
    bcab.s_impo_tarj      := v('P20_S_IMPO_TARJ');
    bcab.s_impo_vale      := v('P20_S_IMPO_VALE');
    bcab.s_indi_vali_subc := v('P20_S_INDI_VALI_SUBC');
    bcab.s_iva            := v('P20_S_IVA');
    bcab.s_iva_10         := v('P20_S_IVA_10');
    bcab.s_iva_5          := v('P20_S_IVA_5');
    bcab.s_limi_cred_mone := v('P20_S_LIMI_CRED_MONE');
  
    --   bcab.s_obse_timb      := v('P20_S_OBSE_TIMB');
    --   bcab.s_orte_cant_cuot         := v('P20_S_ORTE_CANT_CUOT');
    --   bcab.s_orte_desc              := v('P20_S_ORTE_DESC');
    --   bcab.s_orte_dias_cuot         := v('P20_S_ORTE_DIAS_CUOT');
    --   bcab.s_orte_impo_cuot         := v('P20_S_ORTE_IMPO_CUOT');
    --   bcab.s_orte_maxi_porc         := v('P20_S_ORTE_MAXI_PORC');
    --   bcab.s_orte_porc_entr         := v('P20_S_ORTE_PORC_ENTR');
  
    bcab.s_prec_maxi_deto         := v('P20_S_PREC_MAXI_DETO');
    bcab.s_pres_codi              := v('P20_S_PRES_CODI');
    bcab.s_pres_impo_deto         := v('P20_S_PRES_IMPO_DETO');
    bcab.s_sald_clie_mone         := v('P20_S_SALD_CLIE_MONE');
    bcab.s_sald_limi_cred         := v('P20_S_SALD_LIMI_CRED');
    bcab.s_sum_impo_mmnn          := v('P20_S_SUM_IMPO_MMNN');
    bcab.s_sum_impo_movi          := v('P20_S_SUM_IMPO_MOVI');
    bcab.s_timo_calc_iva          := v('P20_S_TIMO_CALC_IVA');
    bcab.s_timo_indi_caja         := v('P20_S_TIMO_INDI_CAJA');
    bcab.s_total                  := v('P20_S_TOTAL');
    bcab.s_total_dto              := v('P20_S_TOTAL_DTO');
    bcab.sucu_nume_item           := v('P20_SUCU_NUME_ITEM');
    bcab.tico_codi                := v('P20_TICO_CODI');
    bcab.tico_fech_rein           := v('P20_TICO_FECH_REIN');
    bcab.tico_indi_habi_timb      := v('P20_TICO_INDI_HABI_TIMB');
    bcab.tico_indi_timb           := v('P20_TICO_INDI_TIMB');
    bcab.tico_indi_timb_auto      := v('P20_TICO_INDI_TIMB_AUTO');
    bcab.tico_indi_vali_nume      := v('P20_TICO_INDI_VALI_NUME');
    bcab.tico_indi_vali_timb      := v('P20_TICO_INDI_VALI_TIMB');
    bcab.timo_dbcr_caja           := v('P20_TIMO_DBCR_CAJA');
    bcab.timo_indi_apli_adel_fopa := v('P20_TIMO_INDI_APLI_ADEL_FOPA');
    bcab.timo_indi_cont_cred      := v('P20_TIMO_INDI_CONT_CRED');
    bcab.timo_tica_codi           := v('P20_TIMO_TICA_CODI');
    bcab.user_depo_codi_alte      := v('P20_USER_DEPO_CODI_ALTE');
    bcab.user_empl_codi_alte      := v('P20_USER_EMPL_CODI_ALTE');
    bcab.user_indi_modi_obse_fact := v('P20_USER_INDI_MODI_OBSE_FACT');
    bcab.user_indi_real_s_exce    := v('P20_USER_INDI_REAL_S_EXCE');
    bcab.movi_depo_codi_orig      := v('P20_MOVI_DEPO_CODI_ORIG');
  
    select mone_desc_abre
      into bcab.movi_mone_desc_abre
      from come_mone
     where mone_codi = bcab.movi_mone_codi;
  
    select taax_sess sessio,
           taax_user usuario,
           taax_seq  seq_id,
           taax_c050 nombre_del_informe,
           taax_c001 indi_prod_ort,
           taax_c002 prod_desc,
           taax_c003 medi_desc,
           taax_c004 prod_codi_alfa,
           taax_n001 deta_prod_codi,
           taax_c005 coba_codi_barr,
           taax_n003 deta_medi_codi,
           taax_n004 deta_cant_medi,
           taax_n005 deta_prec_unit,
           taax_n006 deta_porc_deto,
           taax_n007 deta_impo_mone_ii,
           taax_n008 s_descuento,
           taax_n009 deta_impo_mmnn_ii,
           taax_n010 deta_grav10_mone_ii,
           taax_n011 deta_grav5_mone_ii,
           taax_n012 deta_grav10_mone,
           taax_n013 deta_grav5_mone,
           taax_n014 deta_iva10_mone,
           taax_n015 deta_iva5_mone,
           taax_n016 deta_exen_mone,
           taax_n017 deta_grav10_mmnn_ii,
           taax_n018 deta_grav5_mmnn_ii,
           taax_n019 deta_grav10_mmnn,
           taax_n020 deta_grav5_mmnn,
           taax_n021 deta_iva10_mmnn,
           taax_n022 deta_iva5_mmnn,
           taax_n023 deta_exen_mmnn,
           taax_n024 deta_impo_mmnn,
           taax_n025 deta_impo_mone,
           taax_n026 deta_iva_mmnn,
           taax_n027 deta_iva_mone,
           taax_n028 coba_fact_conv,
           taax_n029
      bulk collect
      into ta_bdet
      from come_tabl_auxi
     where taax_sess = p_sess
       and taax_user = gen_user
       and taax_c050 = 'FACT_DETA';
  
  exception
    when others then
      raise_application_error(-20010,
                              'Error en asignacion de variables' || sqlerrm);
    
  end pp_set_variable;

  procedure pp_set_variable_deta is
  begin
  
    bdet.deta_prec_unit                := v('P20_DETA_PREC_UNIT');
    bdet.deta_cant_medi                := v('P20_DETA_CANT_MEDI');
    bdet.deta_porc_deto                := v('P20_DETA_PORC_DETO');
    bdet.movi_mone_cant_deci           := v('P20_CANT_DECI');
    bdet.movi_tasa_mone                := v('P20_MOVI_TASA_MONE');
    bdet.coba_fact_conv                := v('P20_COBA_FACT_CONV');
    bdet.conc_dbcr                     := v('P20_CONC_DBCR');
    bdet.deta_impu_porc                := v('P20_DETA_IMPU_PORC');
    bdet.deta_impu_porc_base_impo      := v('P20_DETA_IMPU_PORC_BASE_IMPO');
    bdet.deta_impu_indi_baim_impu_incl := v('P20_DETA_IMPU_INDI_BAIM_IMPU');
    bdet.prod_indi_fact_nega           := v('P20_PROD_INDI_FACT_NEGA');
    bdet.deta_impu_codi                := v('P20_DETA_IMPU_CODI');
    bdet.deta_prec_unit_list           := v('P20_DETA_PREC_UNIT_LIST');
    bdet.prod_indi_kitt                := v('P20_PROD_INDI_KITT');
    bdet.deta_prod_prec_maxi_deto      := v('P20_DETA_PROD_PREC_MAXI_DETO');
    bdet.deta_prod_prec_maxi_deto_exen := v('P20_DETA_PROD_PREC_MAXI_D_EXCE');
    bdet.deta_empl_codi                := v('P20_DETA_EMPL_CODI');
    bcab.clpr_list_codi                := v('P20_LIST_CODI');
  
  end pp_set_variable_deta;

  procedure pp_valida_fech(p_fech           in date,
                           p_indi_vali      in varchar2 default 'C',
                           p_indi_mens_vali out varchar2) is
  begin
  
    if p_fech not between p_fech_inic and p_fech_fini then
    
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'La fecha del movimiento debe estar comprendida entre..' ||
                                to_char(p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                                to_char(p_fech_fini, 'dd-mm-yyyy'));
      else
        raise_application_error(-20010,
                                'La fecha del movimiento debe estar comprendida entre..' ||
                                to_char(p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                                to_char(p_fech_fini, 'dd-mm-yyyy'));
        p_indi_mens_vali := 'S';
      end if;
    end if;
  
  end;

  procedure pp_muestra_tipo_movi(i_movi_timo_codi           in number,
                                 o_timo_indi_cont_cred      out come_tipo_movi.timo_indi_cont_cred%type,
                                 o_movi_afec_sald           out come_tipo_movi.timo_afec_sald%type,
                                 o_movi_emit_reci           out come_tipo_movi.timo_emit_reci%type,
                                 o_s_timo_calc_iva          out come_tipo_movi.timo_calc_iva%type,
                                 o_movi_oper_codi           out come_tipo_movi.timo_codi_oper%type,
                                 o_movi_dbcr                out come_tipo_movi.timo_dbcr%type,
                                 o_timo_tica_codi           out come_tipo_movi.timo_tica_codi%type,
                                 o_s_timo_indi_caja         out come_tipo_movi.timo_indi_caja%type,
                                 o_tico_codi                out come_tipo_movi.timo_tico_codi%type,
                                 o_tico_fech_rein           out come_tipo_comp.tico_fech_rein%type,
                                 o_timo_indi_apli_adel_fopa out come_tipo_movi.timo_indi_apli_adel_fopa%type,
                                 o_tico_indi_vali_nume      out come_tipo_comp.tico_indi_vali_nume%type,
                                 o_timo_dbcr_caja           out come_tipo_movi.timo_dbcr_caja%type,
                                 o_tico_indi_timb           out come_tipo_comp.tico_indi_timb%type,
                                 o_tico_indi_habi_timb      out come_tipo_comp.tico_indi_habi_timb%type,
                                 o_tico_indi_timb_auto      out come_tipo_comp.tico_indi_timb_auto%type,
                                 o_tico_indi_vali_timb      out come_tipo_comp.tico_indi_vali_timb%type,
                                 o_movi_timo_indi_sald      out varchar2) is
  
    v_timo_indi_cont_cred      come_tipo_movi.timo_indi_cont_cred%type;
    v_movi_afec_sald           come_tipo_movi.timo_afec_sald%type;
    v_movi_emit_reci           come_tipo_movi.timo_emit_reci%type;
    v_s_timo_calc_iva          come_tipo_movi.timo_calc_iva%type;
    v_movi_oper_codi           come_tipo_movi.timo_codi_oper%type;
    v_movi_dbcr                come_tipo_movi.timo_dbcr%type;
    v_timo_tica_codi           come_tipo_movi.timo_tica_codi%type;
    v_s_timo_indi_caja         come_tipo_movi.timo_indi_caja%type;
    v_tico_codi                come_tipo_movi.timo_tico_codi%type;
    v_tico_fech_rein           come_tipo_comp.tico_fech_rein%type;
    v_timo_indi_apli_adel_fopa come_tipo_movi.timo_indi_apli_adel_fopa%type;
    v_tico_indi_vali_nume      come_tipo_comp.tico_indi_vali_nume%type;
    v_timo_dbcr_caja           come_tipo_movi.timo_dbcr_caja%type;
    v_tico_indi_timb           come_tipo_comp.tico_indi_timb%type;
    v_tico_indi_habi_timb      come_tipo_comp.tico_indi_habi_timb%type;
    v_tico_indi_timb_auto      come_tipo_comp.tico_indi_timb_auto%type;
    v_tico_indi_vali_timb      come_tipo_comp.tico_indi_vali_timb%type;
  
  begin
    select timo_indi_cont_cred,
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
      into v_timo_indi_cont_cred,
           v_movi_afec_sald,
           v_movi_emit_reci,
           v_s_timo_calc_iva,
           v_movi_oper_codi,
           v_movi_dbcr,
           v_timo_tica_codi,
           v_s_timo_indi_caja,
           v_tico_codi,
           v_tico_fech_rein,
           v_timo_indi_apli_adel_fopa,
           v_tico_indi_vali_nume,
           v_timo_dbcr_caja,
           v_tico_indi_timb,
           v_TIco_INDI_HABI_TIMB,
           v_tico_indi_timb_auto,
           v_tico_indi_vali_timb
      from come_tipo_movi, come_tipo_comp a
     where timo_tico_codi = tico_codi(+)
       and timo_codi_oper = parameter.p_codi_oper
       and timo_codi = i_movi_timo_codi;
  
    if v_timo_indi_cont_cred is null then
      raise_application_error(-20010,
                              'Primero debe configurar si el movimiento es Contado o Crédito en el mantenimineto de Tipos de Movimientos');
    end if;
  
    o_movi_timo_indi_sald := v_movi_afec_sald;
    if v_movi_emit_reci <> parameter.p_emit_reci then
      v_movi_afec_sald  := null;
      v_movi_emit_reci  := null;
      v_s_timo_calc_iva := null;
      raise_application_error(-20010,
                              'Tipo de Movimiento no valido para esta operacion');
    end if;
  
    if v_movi_oper_codi <> parameter.p_codi_oper then
      raise_application_error(-20010,
                              'Tipo de Movimiento no valido para esta operacion');
    end if;
  
    if nvl(upper(parameter.p_indi_perm_timo_bole), 'S') = 'N' then
      if i_movi_timo_codi in
         (parameter.p_codi_timo_pcoe, parameter.p_codi_timo_pcre) then
        raise_application_error(-20010,
                                'El tipo de movimiento ' ||
                                i_movi_timo_codi || ' no esta permitido');
      end if;
    end if;
  
    o_timo_indi_cont_cred      := v_timo_indi_cont_cred;
    o_movi_afec_sald           := v_movi_afec_sald;
    o_movi_emit_reci           := v_movi_emit_reci;
    o_s_timo_calc_iva          := v_s_timo_calc_iva;
    o_movi_oper_codi           := v_movi_oper_codi;
    o_movi_dbcr                := v_movi_dbcr;
    o_timo_tica_codi           := v_timo_tica_codi;
    o_s_timo_indi_caja         := v_s_timo_indi_caja;
    o_tico_codi                := v_tico_codi;
    o_tico_fech_rein           := v_tico_fech_rein;
    o_timo_indi_apli_adel_fopa := v_timo_indi_apli_adel_fopa;
    o_tico_indi_vali_nume      := v_tico_indi_vali_nume;
    o_timo_dbcr_caja           := v_timo_dbcr_caja;
    o_tico_indi_timb           := v_tico_indi_timb;
    o_tico_indi_habi_timb      := v_tico_indi_habi_timb;
    o_tico_indi_timb_auto      := v_tico_indi_timb_auto;
    o_tico_indi_vali_timb      := v_tico_indi_vali_timb;
  
  exception
    when no_data_found then
      v_movi_afec_sald  := null;
      v_movi_emit_reci  := null;
      v_s_timo_calc_iva := null;
      raise_application_error(-20010, 'Tipo de Movimiento inexistente');
    when too_many_rows then
      raise_application_error(-20010, 'Tipo de Movimiento duplicado');
  end;

  procedure pp_muestra_sub_cuenta(p_clpr_codi      in number,
                                  p_sucu_nume_item in number,
                                  p_sucu_desc      out varchar2,
                                  p_clpr_dire      out varchar2,
                                  p_clpr_tele      out varchar2) is
  begin
  
    select sucu_desc, sucu_dire, sucu_tele
      into p_sucu_desc, p_clpr_dire, p_clpr_tele
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_clpr_codi
       and sucu_nume_item = p_sucu_nume_item;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'SubCuenta inexistente');
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_muestra_list_prec(p_codi in number, p_desc out char) is
  begin
  
    select list_desc
      into p_desc
      from come_list_prec
     where list_codi = p_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Lista de precios Inexistente!');
    when others then
      raise_application_error(-20010, 'Error en mostrar lista de precio');
  end;

  procedure pp_mostrar_prec_maxi_deto(p_indi_vali                  in varchar2 default 'C',
                                      i_indi_prod_ortr             in varchar2,
                                      i_exde_tipo                  in varchar2,
                                      i_deta_prod_codi             in number,
                                      i_movi_tasa_mone             in number,
                                      i_movi_mone_codi             in number,
                                      i_movi_mone_cant_deci        in number,
                                      i_deta_impu_codi             in number,
                                      i_prod_indi_fact_sub_cost    in varchar2,
                                      i_deta_prec_unit_list        in number,
                                      i_movi_clpr_codi             in number,
                                      i_deta_list_codi             in number,
                                      i_list_codi                  in number,
                                      i_deta_medi_codi             in number,
                                      i_pres_indi_user_deto        in varchar2,
                                      i_user_indi_real_deto_s_exce in varchar2,
                                      i_prod_maxi_porc_desc        in number,
                                      i_lide_maxi_porc_deto        in number,
                                      i_empl_maxi_porc_deto        in number,
                                      i_s_orte_maxi_porc           in number,
                                      i_clpr_segm_codi             in number,
                                      i_movi_orte_codi             in number,
                                      i_exde_deto_prec             in varchar2, --P=Porcentaje, I=Importe
                                      i_exde_porc                  in number,
                                      i_exde_impo                  in number,
                                      i_clpr_maxi_porc_deto        in number,
                                      i_deta_prec_maxi_deto_pres   in number,
                                      i_clpr_indi_vali_prec_mini   in varchar2,
                                      i_lide_indi_vali_prec_mini   in varchar2,
                                      i_deta_prod_prec_maxi_deto   out number,
                                      i_prec_maxi_deto             out number,
                                      i_deta_prod_prec_maxi_d_exce out number,
                                      i_deta_indi_prec_maxi_deto   out varchar2,
                                      i_deta_prod_prec_maxi_exce   out number,
                                      o_deta_indi_prec_maxi_deto   out varchar2) is
  
    v_clpr_maxi_porc_deto  number;
    v_prec_maxi_deto_list  number;
    v_prec_maxi_deto_matr  number;
    v_prec_maxi_deto_util  number;
    v_prec_maxi_deto_exce  number;
    v_prec_maxi_deto_mayor number;
    v_lide_mone_codi       number;
    v_indi_prec_maxi_deto  varchar2(4);
    v_s_prec_maxi_deto     number;
  
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
    if i_indi_prod_ortr = 'S' and nvl(i_deta_prec_unit_list, 0) <> 0 then
    
      v_s_prec_maxi_deto           := nvl(i_deta_prec_unit_list, 0);
      i_deta_prod_prec_maxi_deto   := v_s_prec_maxi_deto;
      i_deta_prod_prec_maxi_d_exce := 0;
      i_deta_indi_prec_maxi_deto   := 'NL';
    
    elsif i_indi_prod_ortr = 'O' and nvl(i_deta_prec_unit_list, 0) <> 0 then
    
      v_s_prec_maxi_deto         := nvl(i_deta_prec_unit_list, 0);
      i_deta_prod_prec_maxi_deto := v_s_prec_maxi_deto;
      i_deta_prod_prec_maxi_exce := 0;
      i_deta_indi_prec_maxi_deto := 'NL';
    
    elsif i_indi_prod_ortr = 'P' then
    
      -- si no existe excepciones de productos
      --if nvl(i_exde_tipo,'N') = 'N' then  
      --Si el Cliente o LP para el producto tiene marcado indicador "valida precio minimo", precio minimo es precio de lista.
      I020168.pp_most_prec_maxi_deto_list(i_deta_prec_unit_list,
                                          i_movi_clpr_codi,
                                          i_deta_prod_codi,
                                          nvl(i_deta_list_codi, i_list_codi),
                                          i_indi_prod_ortr,
                                          i_deta_medi_codi,
                                          i_clpr_indi_vali_prec_mini,
                                          i_lide_indi_vali_prec_mini,
                                          i_pres_indi_user_deto,
                                          i_user_indi_real_deto_s_exce,
                                          v_prec_maxi_deto_list);
    
      -- Indicador del tipo de Excepcion de Matriz
      I020168.pp_most_prec_maxi_deto_matr(p_prec_unit_list             => i_deta_prec_unit_list,
                                          p_list_codi                  => nvl(i_deta_list_codi,
                                                                              i_list_codi),
                                          p_medi_codi                  => i_deta_medi_codi,
                                          p_prod_codi                  => i_deta_prod_codi,
                                          p_clpr_maxi_porc_deto        => i_clpr_maxi_porc_deto,
                                          p_prec_mexi_deto             => v_prec_maxi_deto_matr,
                                          p_indi_prec_maxi_deto        => v_indi_prec_maxi_deto,
                                          p_indi_vali                  => p_indi_vali,
                                          i_pres_indi_user_deto        => i_pres_indi_user_deto,
                                          i_user_indi_real_deto_s_exce => i_user_indi_real_deto_s_exce,
                                          i_movi_mone_cant_deci        => i_movi_mone_cant_deci,
                                          i_prod_maxi_porc_desc        => i_prod_maxi_porc_desc,
                                          i_lide_maxi_porc_deto        => i_lide_maxi_porc_deto,
                                          i_empl_maxi_porc_deto        => i_empl_maxi_porc_deto,
                                          i_s_orte_maxi_porc           => i_s_orte_maxi_porc,
                                          i_list_codi                  => i_list_codi,
                                          i_clpr_segm_codi             => i_clpr_segm_codi,
                                          i_movi_orte_codi             => i_movi_orte_codi);
    
      I020168.pp_most_prec_maxi_deto_cost(p_prec_reto               => v_prec_maxi_deto_util,
                                          i_indi_prod_ortr          => i_indi_prod_ortr,
                                          i_exde_tipo               => i_exde_tipo,
                                          i_deta_prod_codi          => i_deta_prod_codi,
                                          i_movi_tasa_mone          => i_movi_tasa_mone,
                                          i_movi_mone_cant_deci     => i_movi_mone_cant_deci,
                                          i_deta_impu_codi          => i_deta_impu_codi,
                                          i_movi_mone_codi          => i_movi_mone_codi,
                                          i_prod_indi_fact_sub_cost => i_prod_indi_fact_sub_cost);
    
      if nvl(v_prec_maxi_deto_list, 0) >= nvl(v_prec_maxi_deto_matr, 0) then
        v_prec_maxi_deto_mayor     := nvl(v_prec_maxi_deto_list, 0);
        o_deta_indi_prec_maxi_deto := 'NL';
      else
        v_prec_maxi_deto_mayor     := nvl(v_prec_maxi_deto_matr, 0);
        o_deta_indi_prec_maxi_deto := v_indi_prec_maxi_deto;
      end if;
    
      if nvl(v_prec_maxi_deto_mayor, 0) >= nvl(v_prec_maxi_deto_util, 0) then
        v_prec_maxi_deto_mayor := nvl(v_prec_maxi_deto_mayor, 0);
      else
        v_prec_maxi_deto_mayor     := nvl(v_prec_maxi_deto_util, 0);
        o_deta_indi_prec_maxi_deto := 'NU';
      end if;
    
      v_s_prec_maxi_deto         := nvl(v_prec_maxi_deto_mayor, 0);
      i_deta_prod_prec_maxi_deto := v_s_prec_maxi_deto;
      i_deta_prod_prec_maxi_exce := 0;
    
      if i_deta_prec_maxi_deto_pres is not null then
        v_s_prec_maxi_deto         := i_deta_prec_maxi_deto_pres;
        i_deta_prod_prec_maxi_deto := v_s_prec_maxi_deto;
      end if;
    
      --else --excepciones de productos   
      if nvl(i_exde_tipo, 'N') <> 'N' then
        if nvl(i_exde_tipo, 'N') in ('P', 'C', 'O') then
          pp_most_prec_maxi_deto_exce(i_deta_prec_unit_list,
                                      i_exde_deto_prec, --P=Porcentaje, I=Importe
                                      i_exde_porc,
                                      i_exde_impo,
                                      i_movi_mone_cant_deci,
                                      v_prec_maxi_deto_exce);
        
          v_prec_maxi_deto_mayor     := nvl(v_prec_maxi_deto_exce, 0);
          v_s_prec_maxi_deto         := nvl(v_prec_maxi_deto_mayor, 0);
          i_deta_prod_prec_maxi_exce := v_s_prec_maxi_deto;
        
        elsif nvl(i_exde_tipo, 'N') = 'K' then
          v_s_prec_maxi_deto := fa_devu_cost_prom(i_deta_prod_codi,
                                                  parameter.p_codi_peri_sgte);
          if i_movi_mone_codi <> parameter.p_codi_mone_mmnn then
            v_s_prec_maxi_deto := round(v_s_prec_maxi_deto /
                                        nvl(i_movi_tasa_mone, 1),
                                        i_movi_mone_cant_deci);
          end if;
          i_deta_prod_prec_maxi_exce := v_s_prec_maxi_deto;
        else
          --No deberia de ingresar a este lugar al menos que exista un nuevo tipo de excepcion
          v_s_prec_maxi_deto         := nvl(i_deta_prec_unit_list, 0);
          i_deta_prod_prec_maxi_exce := v_s_prec_maxi_deto;
        end if;
      
        o_deta_indi_prec_maxi_deto := i_exde_tipo;
      end if;
    end if;
  
    i_prec_maxi_deto := v_s_prec_maxi_deto;
  
  end pp_mostrar_prec_maxi_deto;

  procedure pp_most_prec_maxi_deto_list(p_prec_unit_list             in number,
                                        p_clpr_codi                  in number,
                                        p_prod_codi                  in number,
                                        p_list_codi                  in number,
                                        p_indi_prod_ortr             in char,
                                        p_medi_codi                  in number,
                                        i_clpr_indi_vali_prec_mini   in varchar2,
                                        i_lide_indi_vali_prec_mini   in varchar2,
                                        i_pres_indi_user_deto        in varchar2,
                                        i_user_indi_real_deto_s_exce in varchar2,
                                        p_prec_reto                  out number) is
  
    v_clpr_indi_vali_prec_mini char(1) := 'N';
    v_lide_indi_vali_prec_mini char(1) := 'N';
  
  begin
  
    v_clpr_indi_vali_prec_mini := i_clpr_indi_vali_prec_mini;
  
    if p_indi_prod_ortr = 'P' then
      v_lide_indi_vali_prec_mini := i_lide_indi_vali_prec_mini;
    end if;
  
    if nvl(i_pres_indi_user_deto, 'N') = 'N' and
       nvl(i_user_indi_real_deto_s_exce, 'N') = 'N' then
      if v_clpr_indi_vali_prec_mini = 'S' or
         v_lide_indi_vali_prec_mini = 'S' then
        p_prec_reto := p_prec_unit_list;
      end if;
    end if;
  
    p_prec_reto := nvl(p_prec_reto, 0);
  end;

  procedure pp_most_prec_maxi_deto_matr(p_prec_unit_list             in number,
                                        p_list_codi                  in number,
                                        p_medi_codi                  in number,
                                        p_prod_codi                  in number,
                                        p_clpr_maxi_porc_deto        in number,
                                        p_prec_mexi_deto             out number,
                                        p_indi_prec_maxi_deto        out varchar2,
                                        p_indi_vali                  in varchar2 default 'C',
                                        i_pres_indi_user_deto        in varchar2,
                                        i_user_indi_real_deto_s_exce in varchar2,
                                        i_movi_mone_cant_deci        in number,
                                        i_prod_maxi_porc_desc        in number,
                                        i_lide_maxi_porc_deto        in number,
                                        i_empl_maxi_porc_deto        in number,
                                        i_s_orte_maxi_porc           in number,
                                        i_list_codi                  in number,
                                        i_clpr_segm_codi             in number,
                                        i_movi_orte_codi             in number) is
  
    v_prod_maxi_porc_desc number;
    v_lide_maxi_porc_deto number;
    v_vend_maxi_porc_deto number;
    v_orte_maxi_porc      number;
    v_mapr_porc_deto      number;
    v_dife                number;
    v_porc                number;
  
    cursor c_matr is
      select m.made_refe, m.made_bloq
        from come_matr_deto m
       where m.made_refe is not null
         and upper(m.made_habi) = 'S'
       order by m.made_orde;
  
  begin
  
    v_prod_maxi_porc_desc := i_prod_maxi_porc_desc;
    v_lide_maxi_porc_deto := i_lide_maxi_porc_deto;
    v_vend_maxi_porc_deto := i_empl_maxi_porc_deto;
    v_orte_maxi_porc      := i_s_orte_maxi_porc;
  
    begin
      select nvl(m.mapr_porc_deto, 0)
        into v_mapr_porc_deto
        from come_matr_prec m
       where m.mapr_list_codi = i_list_codi
         and m.mapr_segm_codi = i_clpr_segm_codi
         and m.mapr_orte_codi = i_movi_orte_codi;
    exception
      when no_data_found then
        v_mapr_porc_deto := 0;
      when others then
        v_mapr_porc_deto := 0;
    end;
  
    for k in c_matr loop
      if lower(k.made_refe) = 'cliente' then
        if p_clpr_maxi_porc_deto <> 0 then
          if nvl(i_pres_indi_user_deto, 'N') = 'N' and
             nvl(i_user_indi_real_deto_s_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           p_clpr_maxi_porc_deto / 100),
                                           i_movi_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NMC';
          end if;
          exit;
        end if;
      
      elsif lower(k.made_refe) = 'matriz_precio' then
        if v_mapr_porc_deto <> 0 then
          if nvl(i_pres_indi_user_deto, 'N') = 'N' and
             nvl(i_user_indi_real_deto_s_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           v_mapr_porc_deto / 100),
                                           i_movi_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NMM';
          end if;
          exit;
        end if;
      
      elsif lower(k.made_refe) = 'lista_precio' then
        if v_lide_maxi_porc_deto <> 0 then
          if nvl(i_pres_indi_user_deto, 'N') = 'N' and
             nvl(i_user_indi_real_deto_s_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           v_lide_maxi_porc_deto / 100),
                                           i_movi_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NML';
          end if;
          exit;
        end if;
      
      elsif lower(k.made_refe) = 'producto' then
        if v_prod_maxi_porc_desc <> 0 then
          if nvl(i_pres_indi_user_deto, 'N') = 'N' and
             nvl(i_user_indi_real_deto_s_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           v_prod_maxi_porc_desc / 100),
                                           i_movi_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NMP';
          end if;
          exit;
        end if;
      
      elsif lower(k.made_refe) = 'forma_pago' then
        if i_movi_orte_codi is not null then
          if nvl(i_pres_indi_user_deto, 'N') = 'N' and
             nvl(i_user_indi_real_deto_s_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           nvl(v_orte_maxi_porc, 0) / 100),
                                           i_movi_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NMF';
          end if;
          exit;
        end if;
      
      elsif lower(k.made_refe) = 'vendedor' then
        if v_vend_maxi_porc_deto <> 0 then
          if nvl(i_pres_indi_user_deto, 'N') = 'N' and
             nvl(i_user_indi_real_deto_s_exce, 'N') = 'N' then
            p_prec_mexi_deto      := round(p_prec_unit_list -
                                           (p_prec_unit_list *
                                           v_vend_maxi_porc_deto / 100),
                                           i_movi_mone_cant_deci);
            p_indi_prec_maxi_deto := 'NMV';
          end if;
          exit;
        end if;
      
      else
      
        if nvl(p_indi_vali, 'C') = 'C' then
          raise_application_error(-20010,
                                  'Metodo de control de descuentos no definido.');
        else
          raise_application_error(-20010,
                                  'Metodo de control de descuentos no definido.');
        end if;
      end if;
    end loop;
    p_prec_mexi_deto := nvl(p_prec_mexi_deto, 0);
  end;

  procedure pp_most_prec_maxi_deto_cost(p_prec_reto               out number,
                                        i_indi_prod_ortr          in varchar2,
                                        i_exde_tipo               in varchar2,
                                        i_deta_prod_codi          in number,
                                        i_movi_tasa_mone          in number,
                                        i_movi_mone_cant_deci     in number,
                                        i_deta_impu_codi          in number,
                                        i_movi_mone_codi          in number,
                                        i_prod_indi_fact_sub_cost in varchar2) is
    v_cost number;
  
  begin
    if i_indi_prod_ortr = 'P' then
      if nvl(i_exde_tipo, 'N') = 'N' then
        parameter.p_porc_util_mini_fact := nvl(parameter.p_porc_util_mini_fact,
                                               0);
        v_cost                          := fa_devu_cost_prom(i_deta_prod_codi,
                                                             parameter.p_codi_peri_sgte);
      
        if i_movi_mone_codi <> parameter.p_codi_mone_mmnn then
          v_cost := round(v_cost / nvl(i_movi_tasa_mone, 1),
                          i_movi_mone_cant_deci);
        end if;
      
        if i_deta_impu_codi = parameter.p_codi_impu_exen then
          v_cost := v_cost;
        elsif i_deta_impu_codi = parameter.p_codi_impu_grav5 then
          v_cost := v_cost + v_cost * 5 / 100;
        elsif i_deta_impu_codi = parameter.p_codi_impu_grav10 then
          v_cost := v_cost + v_cost * 10 / 100;
        end if;
      
        if nvl(v_cost, 0) > 0 then
          /*if nvl(i_pres_indi_user_deto,'N')  = 'N' and nvl(i_user_indi_real_deto_sin_exce,'N') = 'N' then
            p_prec_reto := round(v_cost + (v_cost * parameter.p_porc_util_mini_fact / 100), i_movi_mone_cant_deci);
          else*/
          p_prec_reto := v_cost;
          --end if;   
        end if;
      end if;
    end if;
  
    if nvl(i_prod_indi_fact_sub_cost, 'S') = 'N' or
       nvl(parameter.p_indi_vali_prod_fact_sub_cost, 'S') = 'N' then
      p_prec_reto := 0;
    end if;
  
    p_prec_reto := nvl(p_prec_reto, 0);
  
  end pp_most_prec_maxi_deto_cost;

  procedure pp_most_prec_maxi_deto_exce(p_prec_unit_list      in number,
                                        p_exce_indi           in char,
                                        p_exce_deto_porc      in number,
                                        p_exce_deto_prec      in number,
                                        i_movi_mone_cant_deci in number,
                                        p_prec_reto           out number) is
    v_dife number := 0;
    v_porc number := 0;
  
  begin
    if p_exce_indi = 'P' then
      if nvl(p_prec_unit_list, 0) = 0 then
        null;
        p_prec_reto := 0;
      else
        p_prec_reto := round(p_prec_unit_list -
                             (p_prec_unit_list * p_exce_deto_porc / 100),
                             i_movi_mone_cant_deci);
      end if;
    else
      p_prec_reto := round(p_exce_deto_prec, i_movi_mone_cant_deci);
    end if;
  
    p_prec_reto := nvl(p_prec_reto, 0);
  end;

  procedure pp_mostrar_clpr_vali(p_clpr_codi_alte in number,
                                 p_indi_vali      in varchar2 default 'C') is
  
    v_clpr_esta           varchar(1);
    v_clpr_indi_inforconf varchar2(1);
    v_list_codi           number;
    v_movi_clpr_desc      varchar2(80);
    v_movi_clpr_ruc       varchar2(20);
    v_movi_clpr_tele      varchar2(50);
    v_movi_clpr_dire      varchar2(100);
  
  begin
    select clpr_esta,
           clpr_desc,
           clpr_codi,
           clpr_indi_vali_limi_cred,
           clpr_ruc,
           clpr_dire,
           clpr_tele,
           clpr_cli_situ_codi,
           nvl(clpr_indi_vali_situ_clie, 'S'),
           nvl(clpr_indi_exen, 'N'),
           nvl(clpr_indi_list_negr, 'N'),
           nvl(clpr_indi_exce, 'N'),
           clpr_maxi_porc_deto,
           clpr_segm_codi,
           clpr_clie_clas1_codi,
           nvl(clpr_indi_inforconf, 'N'),
           clpr_indi_vali_prec_mini,
           clpr_empl_codi,
           clpr_codi_alte
      into v_clpr_esta,
           v_movi_clpr_desc,
           bcab.movi_clpr_codi,
           bcab.clpr_indi_vali_limi_cred,
           v_movi_clpr_ruc,
           v_movi_clpr_dire,
           v_movi_clpr_tele,
           bcab.clpr_cli_situ_codi,
           bcab.clpr_indi_vali_situ_clie,
           bcab.clpr_indi_exen,
           bcab.clpr_indi_list_negr,
           bcab.clpr_indi_exce,
           bcab.clpr_maxi_porc_deto,
           bcab.clpr_segm_codi,
           bcab.clpr_clie_clas1_codi,
           v_clpr_indi_inforconf,
           bcab.clpr_indi_vali_prec_mini,
           bcab.s_clpr_agen_codi,
           bcab.s_clpr_codi_alte
      from come_clie_prov, come_orde_term
     where clpr_codi = p_clpr_codi_alte
       and clpr_orte_codi = orte_codi(+)
       and clpr_indi_clie_prov = 'C';
  
    if bcab.s_clpr_codi_alte = parameter.p_codi_clie_espo then
      null;
      --no se reasigna lo que el operador pudo haber cambiado
    else
      if bcab.sucu_nume_item is null then
        bcab.movi_clpr_ruc  := v_movi_clpr_ruc;
        bcab.movi_clpr_dire := v_movi_clpr_dire;
        bcab.movi_clpr_tele := v_movi_clpr_tele;
        bcab.movi_clpr_desc := v_movi_clpr_desc;
      else
        bcab.movi_clpr_ruc := v_movi_clpr_ruc;
        pp_muestra_sub_cuenta(bcab.movi_clpr_codi,
                              bcab.sucu_nume_item,
                              bcab.sucu_desc,
                              bcab.movi_clpr_dire,
                              bcab.movi_clpr_tele);
        bcab.movi_clpr_desc := bcab.sucu_desc;
      
      end if;
    
    end if;
  
    if v_clpr_esta = 'I' then
      parameter.p_indi_mens_vali := 'S';
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'El cliente se encuentra Inactivo.');
      else
        raise_application_error(-20010,
                                'El cliente se encuentra Inactivo.');
      end if;
    end if;
  
    if bcab.clpr_indi_list_negr = 'S' then
      if bcab.clpr_indi_exce <> 'S' then
        -- Si esta en Excepcion solo se advierte
        parameter.p_indi_mens_vali := 'S';
        if nvl(p_indi_vali, 'C') = 'C' then
          pp_envi_resp(i_mensaje => 'Atencion, No se puede facturar al cliente!!! Se encuentra en Lista Negra.');
          /*raise_application_error(-20010,
          'Atencion, No se puede facturar al cliente!!! Se encuentra en Lista Negra.');*/
        else
          pp_envi_resp(i_mensaje => 'Atencion, No se puede facturar al cliente!!! Se encuentra en Lista Negra.');
        end if;
      end if;
    end if;
  
    if nvl(v_clpr_indi_inforconf, 'N') = 'S' then
      if bcab.clpr_indi_exce <> 'S' then
        -- Si esta en Excepcion solo se advierte
        parameter.p_indi_mens_vali := 'S';
        if nvl(p_indi_vali, 'C') = 'C' then
          pp_envi_resp(i_mensaje => 'Atencion, No se puede facturar al cliente!!! Se encuentra en Inforconf.');
        else
          pp_envi_resp(i_mensaje => 'Atencion, No se puede facturar al cliente!!! Se encuentra en Inforconf.');
        end if;
      end if;
    end if;
  
  exception
    when no_data_found then
      bcab.movi_clpr_desc           := null;
      bcab.movi_clpr_codi           := null;
      bcab.clpr_indi_vali_limi_cred := null;
      bcab.movi_clpr_ruc            := null;
      bcab.movi_clpr_dire           := null;
      bcab.movi_clpr_tele           := null;
      bcab.clpr_cli_situ_codi       := null;
      bcab.clpr_indi_vali_situ_clie := null;
      bcab.clpr_indi_exen           := null;
      bcab.clpr_indi_list_negr      := null;
      bcab.clpr_indi_exce           := null;
      bcab.clpr_maxi_porc_deto      := null;
      bcab.clpr_segm_codi           := null;
      bcab.clpr_clie_clas1_codi     := null;
      bcab.clpr_indi_vali_prec_mini := null;
    
      parameter.p_indi_mens_vali := 'S';
    
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010, 'Cliente inexistente!');
      else
        raise_application_error(-20010, 'Cliente inexistente!');
      end if;
    
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_validar_clie_prov(p_clpr_codi           in varchar2,
                                 p_clpr_indi_clie_prov in varchar2) is
  
    v_clpr_esta varchar2(1);
  begin
  
    select nvl(cp.clpr_esta, 'A')
      into v_clpr_esta
      from come_clie_prov cp
     where cp.clpr_indi_clie_prov = p_clpr_indi_clie_prov
       and cp.clpr_codi = p_clpr_codi;
  
    if v_clpr_esta <> 'A' then
      if p_clpr_indi_clie_prov = 'C' then
        raise_application_error(-20010, 'El cliente se encuentra inactivo');
      else
        raise_application_error(-20010,
                                'El proveedor se encuentra inactivo');
      end if;
    end if;
  
  exception
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_validar_timbrado(p_tico_codi           in number,
                                p_esta                in number,
                                p_punt_expe           in number,
                                p_clpr_codi           in number,
                                p_fech_movi           in date,
                                p_timb                out varchar2,
                                p_fech_venc           out date,
                                p_fech_inic           out date,
                                p_nume_auto_timb      out varchar2,
                                p_s_obse_timb         out varchar2,
                                p_tico_indi_timb      in varchar2,
                                i_tico_indi_timb_auto in varchar2,
                                i_tico_indi_vali_timb in varchar2,
                                i_movi_nume_timb      in number,
                                i_fech_venc_timb      in date,
                                i_fech_inic_timb      in date,
                                i_movi_nume_auto_impr in number,
                                o_colo_obse_timb      out number) is
  
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
      select setc_nume_timb,
             setc_fech_venc,
             setc_fech_inic,
             setc_nume_auto_impr
        from come_secu_tipo_comp
       where setc_secu_codi =
             (select f.user_secu_codi
                from segu_user f
               where user_login = gen_user)
            /*(select peco_secu_codi
             from come_pers_comp
            where peco_codi = p_peco_codi)*/
         and setc_tico_codi = p_tico_codi --tipo de comprobante
         and setc_esta = p_esta --establecimiento 
         and setc_punt_expe = p_punt_expe --punto de expedicion
         and setc_fech_venc >= p_fech_movi
       order by setc_fech_venc;
  
    v_indi_entro varchar2(1) := upper('n');
  
  begin
  
    if nvl(i_tico_indi_timb_auto, 'N') = 'S' then
      if nvl(p_tico_indi_timb, 'C') = 'C' then
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
            p_timb           := i_movi_nume_timb;
            p_fech_venc      := i_fech_venc_timb;
            p_fech_inic      := i_fech_inic_timb;
            p_nume_auto_timb := i_movi_nume_auto_impr;
          else
            p_timb           := x.setc_nume_timb;
            p_fech_venc      := x.setc_fech_venc;
            p_fech_inic      := x.setc_fech_inic;
            p_nume_auto_timb := x.SETC_NUME_AUTO_IMPR;
          
          end if;
          exit;
        end loop;
      end if;
    end if;
  
    if v_indi_entro = upper('n') and
       nvl(upper(i_tico_indi_vali_timb), 'N') = 'S' then
      raise_application_error(-20010,
                              'No existe registro de timbrado, o el timbrado cargado se encuentra vencido!!!');
    end if;
  
    if round(trunc(p_fech_venc) - trunc(sysdate)) > 0 then
      p_s_obse_timb := 'El timbrado ' || p_timb || ' vence en ' ||
                       round(trunc(p_fech_venc) - trunc(sysdate)) ||
                       ' días!!!';
      if round(trunc(p_fech_venc) - trunc(sysdate)) <= 30 then
        o_colo_obse_timb := 1;
      end if;
    end if;
  end pp_validar_timbrado;

  procedure pp_valida_nume_fact_fini(i_movi_fech_emis in date,
                                     i_tico_fech_rein in date,
                                     i_tico_codi      in number,
                                     i_movi_nume      in number) is
    v_count   number;
    v_message varchar2(1000) := 'Nro de Comprobante Existente2!!!!! , favor verifique!!';
    salir     exception;
  
  begin
    if i_movi_fech_emis < i_tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = i_movi_nume
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
         and timo_tico_codi = i_tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis >= i_tico_fech_rein;
    
    end if;
  
  exception
    when salir then
      raise_application_error(-20010, 'Reingrese el nro de comprobante');
  end;

  procedure pp_valida_nume_fact(i_movi_fech_emis in date,
                                i_tico_fech_rein in date,
                                i_tico_codi      in number,
                                i_movi_nume      in number) is
  
    v_count   number;
    v_message varchar2(1000) := 'Nro de Comprobante Existente1!!!!! , favor verifique!!';
  
  begin
    if i_movi_fech_emis < i_tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = i_movi_nume
         and timo_tico_codi = i_tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis < i_tico_fech_rein;
    
    elsif i_movi_fech_emis >= i_tico_fech_rein then
    
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = i_movi_nume
         and timo_tico_codi = i_tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis >= i_tico_fech_rein;
    end if;
  
    if v_count > 0 then
      raise_application_error(-20010, v_message); --||'=> '||i_movi_fech_emis ||' '|| i_tico_fech_rein);
    end if;
  end;

  procedure pp_valida_nume_fact_anul(i_movi_nume      in number,
                                     i_movi_nume_timb in number) is
  
    v_count   number;
    v_message varchar2(1000) := 'Nro de Comprobante Existente en Movimientos Anulados!!!!! , favor verifique!!';
    salir     exception;
  
  begin
    select count(*) cant
      into v_count
      from come_movi_anul
     where anul_nume = i_movi_nume
       and anul_nume_timb = i_movi_nume_timb
       and anul_timo_codi in (1, 2, 3, 4, 39, 45);
  
    if v_count > 0 then
      raise_application_error(-20010, v_message);
    end if;
  
  end pp_valida_nume_fact_anul;

  procedure pp_validar_sub_cuenta(i_movi_clpr_codi   in number,
                                  o_s_indi_vali_subc out varchar2) is
  
    v_count number := 0;
  
  begin
  
    select count(*)
      into v_count
      from come_clpr_sub_cuen
     where sucu_clpr_codi = i_movi_clpr_codi;
  
    if v_count > 0 then
      o_s_indi_vali_subc := 'S';
    end if;
  end;

  procedure pp_validar_come_depo(p_depo_empr_codi in number,
                                 p_busc_dato      in varchar2,
                                 p_depo_codi_alte out varchar2) is
    salir            exception;
    v_cant           number;
    v_depo_indi_fact varchar2(1);
  
  begin
    --buscar deposito por codigo de alternativo
    if fp_buscar_come_depo_alte(p_depo_empr_codi,
                                p_busc_dato,
                                p_depo_codi_alte) then
      begin
        select depo_indi_fact
          into v_depo_indi_fact
          from come_depo
         where depo_codi_alte = p_depo_codi_alte;
      
        if nvl(v_depo_indi_fact, 'N') = 'N' then
          raise_application_error(-20010, 'Deposito no facturable.');
        else
          raise salir;
        end if;
      end;
    end if;
  
  end pp_validar_come_depo;

  procedure pp_validar_cabecera is
  
    v_orte_codi number;
  
  begin
  
    begin
      i020168.pp_set_variable;
    
    exception
      when others then
        raise_application_error(-20010,
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || '11');
    end;
  
    pp_mostrar_clpr_vali(bcab.clpr_codi, 'V');
    --pp_deter_situ_clie(bcab.movi_clpr_codi, bcab.clpr_cli_situ_codi, 'V');
    pp_veri_cheq_rech_clpr('V');
  
    if bcab.movi_orte_codi is not null then
    
      pp_cargar_orte('V');
    
      if nvl(upper(parameter.p_vali_deto_matr_prec), 'N') = 'S' then
        pp_vali_orte_matr_prec('V');
      end if;
    
    else
      if parameter.p_indi_obli_form_pago = 'S' then
        parameter.p_indi_mens_vali := 'S';
        raise_application_error(-20010, 'Debe indicar una forma de pago.');
      else
        bcab.movi_orte_codi   := null;
        bcab.s_orte_desc      := null;
        bcab.s_orte_maxi_porc := null;
        bcab.s_orte_cant_cuot := null;
        bcab.s_orte_porc_entr := null;
        bcab.s_orte_impo_cuot := null;
      end if;
    end if;
  
    if nvl(bcab.s_timo_calc_iva, 'N') = 'N' then
      --solo para fact en negro
      pp_busca_nume_movi;
    end if;
  
    if nvl(bcab.movi_afec_sald, 'N') = 'C' then
      -- si es Credito
      if nvl(bcab.timo_indi_cont_cred, 'CO') = 'CR' then
        pp_carga_limi_cred(bcab.movi_clpr_codi,
                           bcab.movi_tasa_mone,
                           bcab.s_limi_cred_mone);
        pp_carga_sald_clie(bcab.movi_clpr_codi,
                           bcab.movi_tasa_mone,
                           bcab.s_sald_clie_mone);
      
      end if;
    
    end if;
  
    if bcab.movi_obse is null then
      if nvl(parameter.p_indi_fact_obse_obli, 'N') = 'S' then
        raise_application_error(-20010, 'Debe ingresar la observación.');
      end if;
    end if;
  
    i020168.pp_verificacion_dupl_fact;
  
  end;

  procedure pp_validar_detalle is
  
    cursor cDeta is
      select taax_sess sessio,
             taax_user usuario,
             taax_seq  seq_id,
             taax_c050 nombre_del_informe,
             taax_c001 indi_prod_ort,
             taax_c002 prod_desc,
             taax_c003 medi_desc,
             taax_c004 prod_codi_alfa,
             taax_n001 deta_prod_codi,
             taax_n002 coba_codi_barr,
             taax_n003 deta_medi_codi,
             taax_n004 deta_cant_medi,
             taax_n005 deta_prec_unit,
             taax_n006 deta_porc_deto,
             taax_n007 deta_impo_mone_ii,
             taax_n008 s_descuento,
             taax_n009 deta_impo_mmnn_ii,
             taax_n010 deta_grav10_mone_ii,
             taax_n011 deta_grav5_mone_ii,
             taax_n012 deta_grav10_mone,
             taax_n013 deta_grav5_mone,
             taax_n014 deta_iva10_mone,
             taax_n015 deta_iva5_mone,
             taax_n016 deta_exen_mone,
             taax_n017 deta_grav10_mmnn_ii,
             taax_n018 deta_grav5_mmnn_ii,
             taax_n019 deta_grav10_mmnn,
             taax_n020 deta_grav5_mmnn,
             taax_n021 deta_iva10_mmnn,
             taax_n022 deta_iva5_mmnn,
             taax_n023 deta_exen_mmnn,
             taax_n024 deta_impo_mmnn,
             taax_n025 deta_impo_mone,
             taax_n026 deta_iva_mmnn,
             taax_n027 deta_iva_mone,
             taax_n028 coba_fact_conv,
             taax_n029 deta_lote_codi,
             taax_c005 prod_indi_fact_nega
        from come_tabl_auxi
       where taax_sess = p_sess
         and taax_user = gen_user
         and taax_c050 = 'FACT_DETA';
  
  begin
  
    begin
      i020168.pp_set_variable;
    
    exception
      when others then
        raise_application_error(-20010,
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || '11');
    end;
  
    for i in cDeta loop
      bdet.sessio              := i.sessio;
      bdet.usuario             := i.usuario;
      bdet.seq_id              := i.seq_id;
      bdet.nombre_del_informe  := i.nombre_del_informe;
      bdet.indi_prod_ortr      := i.indi_prod_ort;
      bdet.prod_desc           := i.prod_desc;
      bdet.medi_desc           := i.medi_desc;
      bdet.prod_codi_alfa      := i.prod_codi_alfa;
      bdet.deta_prod_codi      := i.deta_prod_codi;
      bdet.coba_codi_barr      := i.coba_codi_barr;
      bdet.deta_medi_codi      := i.deta_medi_codi;
      bdet.deta_cant_medi      := i.deta_cant_medi;
      bdet.deta_prec_unit      := i.deta_prec_unit;
      bdet.deta_porc_deto      := i.deta_porc_deto;
      bdet.deta_impo_mone_ii   := i.deta_impo_mone_ii;
      bdet.s_descuento         := i.s_descuento;
      bdet.deta_impo_mmnn_ii   := i.deta_impo_mmnn_ii;
      bdet.deta_grav10_mone_ii := i.deta_grav10_mone_ii;
      bdet.deta_grav5_mone_ii  := i.deta_grav5_mone_ii;
      bdet.deta_grav10_mone    := i.deta_grav10_mone;
      bdet.deta_grav5_mone     := i.deta_grav5_mone;
      bdet.deta_iva10_mone     := i.deta_iva10_mone;
      bdet.deta_iva5_mone      := i.deta_iva5_mone;
      bdet.deta_exen_mone      := i.deta_exen_mone;
      bdet.deta_grav10_mmnn_ii := i.deta_grav10_mmnn_ii;
      bdet.deta_grav5_mmnn_ii  := i.deta_grav5_mmnn_ii;
      bdet.deta_grav10_mmnn    := i.deta_grav10_mmnn;
      bdet.deta_grav5_mmnn     := i.deta_grav5_mmnn;
      bdet.deta_iva10_mmnn     := i.deta_iva10_mmnn;
      bdet.deta_iva5_mmnn      := i.deta_iva5_mmnn;
      bdet.deta_exen_mmnn      := i.deta_exen_mmnn;
      bdet.deta_impo_mmnn      := i.deta_impo_mmnn;
      bdet.deta_impo_mone      := i.deta_impo_mone;
      bdet.deta_iva_mmnn       := i.deta_iva_mmnn;
      bdet.deta_iva_mone       := i.deta_iva_mone;
      bdet.coba_fact_conv      := i.coba_fact_conv;
      bdet.deta_lote_codi      := i.deta_lote_codi;
      bdet.prod_indi_fact_nega := i.prod_indi_fact_nega;
    
      -- validamos descuentos otorgados por item 
      declare
        v_maxi_porc_desc number;
      begin
      
        begin
        
          select lide_maxi_porc_deto maximo_porc
            into v_maxi_porc_desc
            from come_list_prec_deta g,
                 come_mone,
                 come_prod,
                 come_prod_coba_deta s
           where g.lide_list_codi = bcab.clpr_list_codi
             and prod_codi = bdet.deta_prod_codi
             and s.coba_codi_barr = bdet.coba_codi_barr
                
             and mone_codi = lide_mone_codi
             and lide_prod_codi = prod_codi
             and s.coba_prod_codi = prod_codi;
        
        exception
          when no_data_found then
            v_maxi_porc_desc := null;
        end;
      
        --raise_application_error(-20010, i_deta_porc_deto||' '||v_maxi_porc_desc||' '||bcab.clpr_list_codi);
      
        if bdet.deta_porc_deto > v_maxi_porc_desc and
           v_maxi_porc_desc is not null then
          raise_application_error(-20010,
                                  'El maximo porciento de descuento de este item ' ||
                                  bdet.prod_desc || ' es: ' ||
                                  v_maxi_porc_desc || '%');
        end if;
      
      end;
    
      --valdiacion 1 
      i020168.pp_valida_deta_cant_medi;
    
      --validacion 2
      i020168.pp_ajustar_importes;
    
    end loop;
  
    /*   pp_ajustar_importes;
    
      pp_validar_cant_line_fact;
    
      if nvl(ta_bdet(x).sum_s_total_item, 0) <= 0 then
      
        parameter.p_indi_mens_vali := 'S';
        :raise_application_error(-20010,            := 'El importe de la factura debe ser mayor a cero.';
      end if;
    */
  end;

  procedure pp_valida_deta_cant_medi is
  begin
  
    /* comentado ya que no se implementó aun presupuesto
     if bcab.s_pres_codi is not null then
      
        if bdet.deta_cant_medi <> bdet.deta_cant_pres and
           bdet.deta_cant_pres is not null then
        
          bdet.deta_cant_medi        := bdet.deta_cant_pres;
          parameter.p_indi_mens_vali := 'S';
          raise_application_error(-20010,             'No puede modificar datos cargados de un Presupuesto.';
        end if;
      end if;
    */
    /* comentado ya que solo se trabajo por P y S en primera instancia
     if bdet.indi_prod_ortr in ('O', 'C') then
      
        bdet.deta_cant      := 1;
        bdet.deta_cant_medi := 1;
      end if;
    */
    if bdet.deta_cant_medi is null then
    
      parameter.p_indi_mens_vali := 'S';
      raise_application_error(-20010,
                              'Debe ingresar un valor para el campo Cantidad.');
    elsif nvl(bdet.deta_cant_medi, 0) <= 0 then
    
      parameter.p_indi_mens_vali := 'S';
      raise_application_error(-20010, 'La Cantidad debe ser mayor a cero.');
    else
    
      bdet.deta_cant := bdet.deta_cant_medi * NVL(bdet.coba_fact_conv, 1);
    end if;
  
    /* --busca las excepciones que pueda tener por producto,cantidad u obsequio
    
      pp_busca_exde_deto;
    
      --Mostrar precio maximo de descuento
      pp_mostrar_prec_maxi_deto('V');
    */
    if bdet.indi_prod_ortr = 'P' then
      if nvl(parameter.p_indi_cons_pres, 'N') = 'N' then
        if bdet.deta_lote_codi is not null then
          i020168.pp_valida_stock_lote(bdet.deta_prod_codi,
                                       bcab.movi_depo_codi_orig,
                                       bdet.deta_lote_codi,
                                       bdet.deta_cant,
                                       bdet.prod_indi_fact_nega,
                                       bdet.prod_desc,
                                       bdet.prod_codi_alfa,
                                       'V');
        else
          i020168.pp_valida_stock(bdet.deta_prod_codi,
                                  bcab.movi_depo_codi_orig,
                                  bdet.deta_cant,
                                  bdet.prod_indi_fact_nega,
                                  bdet.prod_desc,
                                  bdet.prod_codi_alfa,
                                  'V');
        end if;
      end if;
    end if;
  end pp_valida_deta_cant_medi;

  procedure pp_valida_limi_cred(p_indi_vali                in varchar2 default 'C',
                                i_movi_afec_sald           in varchar2,
                                i_movi_clpr_codi           in number,
                                i_movi_mone_codi           in number,
                                i_s_pres_codi              in number,
                                i_clpr_indi_vali_limi_cred in varchar2,
                                i_s_total                  in number,
                                i_movi_nume                in number,
                                p_indi_calc_impo           out varchar2,
                                p_indi_mens_vali           out varchar2,
                                o_s_cred_espe_mone         out number,
                                o_s_limi_cred_mone         out number,
                                o_s_sald_clie_mone         out number,
                                o_s_sald_limi_cred         out number,
                                o_s_pres_impo_deto         out number) is
  
    v_sald_limi_cred   number;
    v_impo_deto        number;
    v_impo_pedi_conf   number;
    v_cred_espe_mone   number;
    v_s_cred_espe_mone number;
    v_s_pres_impo_deto number;
  
  begin
    --validar que el total de la factura no supere el limite de credito
    --Antes q nada reasignar el limite de credito, para que no tengan 
    --que cargar toda la factura, si reasignaron el limite al cliente post carga de la 
    --factura
    --Ojo solo en caso que la factura sea credito   
  
    if nvl(i_movi_afec_sald, 'N') = 'C' then
      begin
        pa_devu_limi_cred_espe(i_movi_clpr_codi,
                               i_movi_mone_codi,
                               v_s_cred_espe_mone);
      
        pp_veri_limi_cred_espe(nvl(i_s_pres_codi, -999),
                               i_movi_clpr_codi,
                               v_cred_espe_mone);
      
        o_s_cred_espe_mone := nvl(v_s_cred_espe_mone, 0) -
                              nvl(v_cred_espe_mone, 0);
      
      exception
        when others then
          raise_application_error(-20010, sqlerrm);
      end;
    
      begin
        pa_devu_limi_cred_clie(i_movi_clpr_codi,
                               i_movi_mone_codi,
                               o_s_limi_cred_mone,
                               o_s_sald_clie_mone,
                               o_s_sald_limi_cred);
      exception
        when others then
          raise_application_error(-20010, sqlerrm);
      end;
    
      -----------*-*-*-*-----------------------------
      begin
        pa_devu_pedi_conf(i_movi_clpr_codi,
                          i_movi_mone_codi,
                          v_s_pres_impo_deto);
      
        pp_veri_pedi_conf(i_s_pres_codi, v_impo_deto);
      
        o_s_pres_impo_deto := nvl(v_s_pres_impo_deto, 0) -
                              nvl(v_impo_deto, 0);
      
      exception
        when others then
          raise_application_error(-20010, sqlerrm);
      end;
    
      -----------*-*-*-*-----------------------------    
      v_sald_limi_cred := nvl(o_s_limi_cred_mone, 0) +
                          nvl(o_s_cred_espe_mone, 0) -
                          nvl(o_s_sald_clie_mone, 0) -
                          nvl(o_s_pres_impo_deto, 0);
    
      if nvl(i_clpr_indi_vali_limi_cred, 'S') = 'S' then
        if nvl(i_s_total, 0) > nvl(v_sald_limi_cred, 0) /*nvl(i_s_sald_limi_cred,0)*/
         then
          if nvl(i_s_total, 0) > nvl(o_s_cred_espe_mone, 0) then
            if nvl(p_indi_vali, 'C') = 'C' then
              parameter.p_indi_calc_impo := 'S';
              raise_application_error(-20010,
                                      'El importe de la factura supera al limite de Credito que posee el cliente');
            else
              parameter.p_indi_calc_impo := 'S';
              parameter.p_indi_mens_vali := 'S';
              raise_application_error(-20010,
                                      'El importe de la factura supera al limite de Credito que posee el cliente');
            end if;
          else
            parameter.p_cres_nume_fact := i_movi_nume;
            parameter.p_cres_fech_fact := sysdate;
            parameter.p_cres_user_fact := gen_user;
          end if;
        end if;
      end if;
    end if;
  
  end pp_valida_limi_cred;

  procedure pp_valida_vigencia_timbrado(p_tico_indi_timb in char,
                                        p_tico_codi      in number,
                                        p_esta           in number,
                                        p_punt_expe      in number,
                                        p_fech_movi      in date,
                                        p_timb_nume      in number) is
    v_count number := 0;
  begin
    if nvl(p_tico_indi_timb, 'C') = 'C' then
      select count(*)
        into v_count
        from come_tipo_comp_deta
       where deta_tico_codi = p_tico_codi --tipo de comprobante
         and deta_esta = p_esta --establecimiento 
         and deta_punt_expe = p_punt_expe --punto de expedicion
         and deta_fech_venc >= p_fech_movi
         and deta_nume_timb = p_timb_nume;
      if v_count = 0 then
        raise_application_error(-20010,
                                'Timbrado inexistente. Verifique el mantenimiento de Comprobantes.');
      end if;
    elsif nvl(p_tico_indi_timb, 'C') = 'S' then
      select count(*)
        into v_count
        from come_secu_tipo_comp
       where setc_secu_codi =
             (select f.user_secu_codi
                from segu_user f
               where user_login = gen_user)
            /* (select peco_secu_codi
             from come_pers_comp
            where peco_codi = p_peco_codi)*/
         and setc_tico_codi = p_tico_codi --tipo de comprobante
         and setc_esta = p_esta --establecimiento 
         and setc_punt_expe = p_punt_expe --punto de expedicion
         and setc_fech_venc >= p_fech_movi
         and setc_nume_timb = p_timb_nume;
      if v_count = 0 then
        raise_application_error(-20010,
                                'Timbrado inexistente. Verifique la secuencia de documentos.');
      end if;
    end if;
  end;

  procedure pp_valida_exist_min_prod(p_prod_codi in number,
                                     p_exis_min  in number,
                                     p_cant      in number) is
    v_cant_actu number;
  begin
  
    if nvl(parameter.p_indi_vali_exis_min_fact, 'N') = 'S' then
      if nvl(p_exis_min, 0) > 0 then
        v_cant_actu := fa_dev_stoc_actu_tota(p_prod_codi);
      
        if (v_cant_actu - p_cant) <= p_exis_min then
          raise_Application_error(-20010,
                                  'ATENCIÓN!!!, El producto ya alcanzó su stock mínimo: ' ||
                                  p_exis_min);
        end if;
      end if;
    
    end if;
  
  end pp_valida_exist_min_prod;

  procedure pp_valida_prec_unit_deto(p_indi_vali                    in varchar2 default 'C',
                                     i_indi_prod_ortr               in varchar2,
                                     i_deta_prec_unit_neto          in number,
                                     i_deta_prec_unit_list          in number,
                                     i_s_prec_maxi_deto             in number,
                                     i_deta_indi_prec_maxi_deto     in varchar2,
                                     i_deta_prod_codi               in number,
                                     i_deta_impu_codi               in number,
                                     i_deta_porc_deto               in number,
                                     i_deta_prec_unit               in number,
                                     i_coba_fact_conv               in number,
                                     i_movi_tasa_mone               in number,
                                     i_cant_deci                    in number,
                                     i_mone_codi                    in number,
                                     i_pres_indi_user_deto          in varchar2,
                                     i_user_indi_real_deto_sin_exce in varchar2,
                                     i_exde_tipo                    in varchar2,
                                     p_indi_mens_vali               out varchar2) is
  
  begin
  
    if i_indi_prod_ortr = 'S' then
      if nvl(i_deta_prec_unit_neto, 0) < nvl(i_deta_prec_unit_list, 0) and
         nvl(i_deta_prec_unit_list, 0) <> 0 then
        p_indi_mens_vali := 'S';
        if nvl(p_indi_vali, 'C') = 'C' then
          raise_application_error(-20010,
                                  'No se puede facturar el servicio por debajo del Precio de Lista.');
        else
          raise_application_error(-20010,
                                  'No se puede facturar el servicio por debajo del Precio de Lista.');
        end if;
      end if;
    else
      if i_deta_prec_unit_neto + 10 < i_s_prec_maxi_deto then
        if nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'NMC' then
          -- NMC= sin excepcion,por Matriz-Cliente
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para el Cliente seleccionado.');
          else
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para el Cliente seleccionado.');
          end if;
        elsif nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'NMM' then
          -- NMM= sin excepcion,por Matriz-Matriz Precio
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Matriz de LP,Segmento y Forma de Pago.');
          else
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Matriz de LP,Segmento y Forma de Pago.');
          end if;
        elsif nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'NML' then
          -- NML= sin excepcion,por Matriz-Lista de Precio
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para el precio de la LP seleccionada.');
          else
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para el precio de la LP seleccionada.');
          end if;
        elsif nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'NMP' then
          -- NMP= sin excepcion,por Matriz-Producto
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para el Producto seleccionado.');
          else
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para el Producto seleccionado.');
          end if;
        elsif nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'NMF' then
          -- NMF= sin excepcion,por Matriz-Forma de Pago
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Forma de Pago seleccionada.');
          else
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Forma de Pago seleccionada.');
          end if;
        elsif nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'NMV' then
          -- NMV= sin excepcion,por Matriz-Vendedor
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para el Vendedor seleccionado.');
          else
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para el Vendedor seleccionado.');
          end if;
        elsif nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'NL' then
          -- NL = sin excepcion,por Lista de Precio
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Precio del Producto para esta LP o Cliente seleccionado no permite facturar por debajo del Precio de Lista (Validación Precio Minimo).');
          else
            raise_application_error(-20010,
                                    'El Precio del Producto para esta LP o Cliente seleccionado no permite facturar por debajo del Precio de Lista (Validación Precio Minimo).');
          end if;
        elsif nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'NU' then
          -- NU = sin excepcion,por Costo
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Precio del item esta por debajo del costo');
          else
            raise_application_error(-20010,
                                    'El Porcentaje de Utilidad del item esta por debajo de lo permitido ' ||
                                    parameter.p_porc_util_mini_fact || '%.');
          end if;
        elsif nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'P' then
          -- P = con excepcion,por Producto
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Excepción del Producto seleccionado.');
          else
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Excepción del Producto seleccionado.');
          end if;
        elsif nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'C' then
          -- C = con excepcion,por Cantidad
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Excepción por Cantidad del Producto seleccionado.');
          else
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Excepción por Cantidad del Producto seleccionado.');
          end if;
        elsif nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'O' then
          -- O = con excepcion,por Obsequio
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Excepción por Obsequio Producto seleccionado.');
          else
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Excepción por Obsequio Producto seleccionado.');
          end if;
        elsif nvl(i_deta_indi_prec_maxi_deto, 'NL') = 'K' then
          -- K = con excepcion,por Cliente al Costo  
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Excepción del Producto al Costo.');
          else
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido para la Excepción del Producto al Costo.');
          end if;
        else
          --No deberia de ingresar aqui al menos que exista una nueva excepcion
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido.');
          else
            raise_application_error(-20010,
                                    'El Descuento del item supera el máximo permitido.');
          end if;
        end if;
      end if;
    end if;
  
    begin
      -- validacion de utilidad donde se valida costo/precio
      I020168.pp_vali_utilidad(p_indi_vali                    => p_indi_vali,
                               i_indi_prod_ortr               => i_indi_prod_ortr,
                               i_deta_prod_codi               => i_deta_prod_codi,
                               i_deta_impu_codi               => i_deta_impu_codi,
                               i_deta_porc_deto               => i_deta_porc_deto,
                               i_deta_prec_unit               => i_deta_prec_unit,
                               i_coba_fact_conv               => i_coba_fact_conv,
                               i_movi_tasa_mone               => i_movi_tasa_mone,
                               i_cant_deci                    => i_cant_deci,
                               i_mone_codi                    => i_mone_codi,
                               i_pres_indi_user_deto          => i_pres_indi_user_deto,
                               i_user_indi_real_deto_sin_exce => i_user_indi_real_deto_sin_exce,
                               i_exde_tipo                    => i_exde_tipo,
                               p_indi_mens_vali               => p_indi_mens_vali);
    end;
  
  end pp_valida_prec_unit_deto;

  procedure pp_valida_nume_fact_anul is
  
    v_count   number;
    v_message varchar2(1000) := 'Nro de Comprobante Existente en Movimientos Anulados!!!!! , favor verifique!!';
    salir     exception;
  
  begin
    select count(*) cant
      into v_count
      from come_movi_anul
     where anul_nume = bcab.movi_nume
       and anul_nume_timb = bcab.movi_nume_timb
       and anul_timo_codi in (1, 2, 3, 4, 39, 45);
  
    if v_count > 0 then
      pl_me(v_message);
    end if;
  
  exception
    when salir then
      pl_me('Reigrese el nro de comprobante');
  end;

  procedure pp_valida_stock_lote(p_prod           in number,
                                 p_depo           in number,
                                 p_lote           in number,
                                 p_cant           in number,
                                 p_indi_fact_nega in varchar2,
                                 p_prod_desc      in varchar2,
                                 p_prod_alfa      in varchar2,
                                 p_indi_vali      in varchar2 default 'C') is
  
    v_stock               number;
    v_actu_cant           number;
    v_pres_cant           number;
    v_remi_cant           number;
    v_prod_indi_fact_nega varchar2(10) := p_indi_fact_nega;
    v_cant_pedi           number;
    v_cant_remi           number;
  
  begin
    parameter.p_perm_stoc_nega := ltrim(rtrim(fa_busc_para('p_perm_stoc_nega')));
  
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
      when no_data_found then
        v_actu_cant := 0;
        v_pres_cant := 0;
        v_remi_cant := 0;
      when others then
        v_actu_cant := 0;
        v_pres_cant := 0;
        v_remi_cant := 0;
      
    end;
  
    v_stock := v_actu_cant - v_pres_cant - v_remi_cant;
  
    if bcab.s_pres_codi is not null then
      begin
        select nvl(b.dpre_cant, 0)
          into v_cant_pedi
          from come_pres_clie a, come_pres_clie_deta b
         where a.pres_codi = b.dpre_pres_codi
           and nvl(a.pres_tipo, 'A') = 'A'
           and nvl(a.pres_esta_pres, 'P') in ('P', 'C')
           and b.dpre_prod_codi = p_prod
           and b.dpre_depo_codi = p_depo
           and b.dpre_lote_codi = p_lote
           and a.pres_codi = bcab.s_pres_codi;
      
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
            pp_envi_resp(i_mensaje => 'Atención.!! La cantidad del articulo ' ||
                                      p_prod_alfa || ' ' || p_prod_desc ||
                                      ' supera el Stock!!! =>'); --||v_stock||' => '||p_prod||', '|| p_depo||', '|| p_lote);
          end if;
        else
          parameter.p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            pp_envi_resp(i_mensaje => 'Atención..!! La cantidad del articulo ' ||
                                      p_prod_alfa || ' ' || p_prod_desc ||
                                      ' supera el Stock!!');
          else
            pp_envi_resp(i_mensaje => 'Atención!! La cantidad del articulo ' ||
                                      p_prod_alfa || ' ' || p_prod_desc ||
                                      ' supera el Stock!!');
          end if;
        end if;
      else
        parameter.p_indi_mens_vali := 'S';
        if nvl(p_indi_vali, 'C') = 'C' then
          pl_me('Atención...!! La cantidad del articulo ' || p_prod_alfa || ' ' ||
                p_prod_desc || ' supera el Stock!');
        else
          raise_application_error(-20010,
                                  'Atención!! La cantidad del articulo ' ||
                                  p_prod_alfa || ' ' || p_prod_desc ||
                                  ' supera el Stock!');
        end if;
      end if;
    end if;
  end;

  procedure pp_valida_stock(p_prod           in number,
                            p_depo           in number,
                            p_cant           in number,
                            p_indi_fact_nega in varchar2,
                            p_prod_desc      in varchar2,
                            p_prod_alfa      in varchar2,
                            p_indi_vali      in varchar2 default 'C') is
  
    v_stock               number;
    v_actu_cant           number;
    v_pres_cant           number;
    v_pres_cant_sucu      number;
    v_remi_cant           number;
    v_prod_indi_fact_nega varchar2(1) := p_indi_fact_nega;
    v_cant_pedi           number;
    v_cant_remi           number;
  
  begin
  
    parameter.p_perm_stoc_nega := ltrim(rtrim(fa_busc_para('p_perm_stoc_nega')));
  
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
  
    if bcab.s_pres_codi is not null then
    
      begin
        select nvl(b.dpre_cant, 0)
          into v_cant_pedi
          from come_pres_clie a, come_pres_clie_deta b
         where a.pres_codi = b.dpre_pres_codi
           and nvl(a.pres_tipo, 'A') = 'A'
           and nvl(a.pres_esta_pres, 'P') in ('P', 'C')
           and b.dpre_prod_codi = p_prod
           and b.dpre_depo_codi = p_depo
           and a.pres_codi = bcab.s_pres_codi;
      
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
          
            pp_envi_resp(i_mensaje => 'Atención-!! La cantidad del articulo ' ||
                                      p_prod_alfa || ' ' || p_prod_desc ||
                                      ' supera el Stock!!!');
          end if;
        else
        
          parameter.p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
          
            pp_envi_resp(i_mensaje => 'Atención--!! La cantidad del articulo ' ||
                                      p_prod_alfa || ' ' || p_prod_desc ||
                                      ' supera el Stock!!');
          else
          
            pp_envi_resp(i_mensaje => 'Atención!! La cantidad del articulo ' ||
                                      p_prod_alfa || ' ' || p_prod_desc ||
                                      ' supera el Stock!!');
          end if;
        end if;
      else
      
        parameter.p_indi_mens_vali := 'S';
        if nvl(p_indi_vali, 'C') = 'C' then
        
          pl_me('Atención---!! La cantidad del articulo ' || p_prod_alfa || ' ' ||
                p_prod_desc || ' supera el Stock!');
        else
        
          raise_application_error(-20010,
                                  'Atención!! La cantidad del articulo ' ||
                                  p_prod_alfa || ' ' || p_prod_desc ||
                                  ' supera el Stock!');
        end if;
      end if;
    end if;
  
  end pp_valida_stock;

  procedure pp_vali_orte_matr_prec(p_indi_vali in varchar2 default 'C') is
    --valida lista de precio,segmento,forma de pago
    v_cant number := 0;
  
  begin
    select count(*)
      into v_cant
      from come_orde_term a, come_matr_prec m
     where a.orte_codi = m.mapr_orte_codi
       and m.mapr_segm_codi = bcab.clpr_segm_codi
       and m.mapr_list_codi = bcab.list_codi
       and a.orte_codi = bcab.movi_orte_codi;
  
    if v_cant = 0 then
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'Forma de Pago no pertenece al Segmento/Lista de Precio. Favor verificar.');
      end if;
    end if;
  
  end pp_vali_orte_matr_prec;

  procedure pp_vali_utilidad(p_indi_vali                    in varchar2 default 'C',
                             i_indi_prod_ortr               in varchar2,
                             i_deta_prod_codi               in number,
                             i_deta_impu_codi               in number,
                             i_deta_porc_deto               in number,
                             i_deta_prec_unit               in number,
                             i_coba_fact_conv               in number,
                             i_movi_tasa_mone               in number,
                             i_cant_deci                    in number,
                             i_mone_codi                    in number,
                             i_pres_indi_user_deto          in varchar2,
                             i_user_indi_real_deto_sin_exce in varchar2,
                             i_exde_tipo                    in varchar2,
                             p_indi_mens_vali               out varchar2) is
    v_cost           number;
    v_deto           number;
    v_prec           number;
    v_util           number;
    v_porc           number;
    v_dpre_impu_codi number;
    v_cost_ulti      number;
  begin
  
    if i_indi_prod_ortr = 'P' then
      if nvl(i_exde_tipo, 'N') = 'N' then
        parameter.p_porc_util_mini_fact := nvl(parameter.p_porc_util_mini_fact,
                                               0);
        v_cost                          := fa_devu_cost_prom(i_deta_prod_codi,
                                                             parameter.p_codi_peri_sgte);
      
        if i_deta_impu_codi = parameter.p_codi_impu_exen then
          v_cost := v_cost;
        elsif i_deta_impu_codi = parameter.p_codi_impu_grav5 then
          v_cost := v_cost + v_cost * 5 / 100;
        elsif i_deta_impu_codi = parameter.p_codi_impu_grav10 then
          v_cost := v_cost + v_cost * 10 / 100;
        end if;
      
        if nvl(v_cost, 0) > 0 then
          v_deto := nvl(i_deta_porc_deto, 0);
          v_prec := i_deta_prec_unit - (i_deta_prec_unit * v_deto / 100);
          v_prec := v_prec / nvl(i_coba_fact_conv, 1);
          v_prec := round(v_prec * i_movi_tasa_mone,
                          parameter.p_cant_deci_mmnn);
          v_util := v_prec + 10 - v_cost;
          v_porc := v_util * 100 / v_cost;
        
          if nvl(i_pres_indi_user_deto, 'N') = 'N' and
             nvl(i_user_indi_real_deto_sin_exce, 'N') = 'N' then
            if v_porc < parameter.p_porc_util_mini_fact then
              if nvl(i_exde_tipo, 'N') = 'K' then
                v_cost_ulti := fp_cost_ulti_comp(i_deta_prod_codi,
                                                 i_movi_tasa_mone,
                                                 i_cant_deci,
                                                 i_mone_codi);
                if v_cost_ulti > v_prec then
                  p_indi_mens_vali := 'S';
                  if nvl(p_indi_vali, 'C') = 'C' then
                    raise_application_error(-20010,
                                            'El precio unitario no debe ser menor al costo.');
                  else
                    raise_application_error(-20010,
                                            'El precio unitario no debe ser menor al costo.');
                  end if;
                end if;
              else
                p_indi_mens_vali := 'S';
                if nvl(p_indi_vali, 'C') = 'C' then
                  raise_application_error(-20010,
                                          'El porcentaje minimo de utilidad debe ser ' ||
                                          parameter.p_porc_util_mini_fact || '%');
                else
                  raise_application_error(-20010,
                                          'El porcentaje minimo de utilidad debe ser ' ||
                                          parameter.p_porc_util_mini_fact || '%');
                end if;
              end if;
            end if;
          else
            if v_cost > v_prec then
              p_indi_mens_vali := 'S';
              if nvl(p_indi_vali, 'C') = 'C' then
                raise_application_error(-20010,
                                        'El precio unitario no debe ser menor al costo.');
              else
                raise_application_error(-20010,
                                        'El precio unitario no debe ser menor al costo.');
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  end;

  procedure pp_orte_matr_prec(p_indi_vali in varchar2 default 'C') is
    --valida lista de precio,segmento,forma de pago
    v_cant number := 0;
  
  begin
    select count(*)
      into v_cant
      from come_orde_term a, come_matr_prec m
     where a.orte_codi = m.mapr_orte_codi
       and m.mapr_segm_codi = bcab.clpr_segm_codi
       and m.mapr_list_codi = bcab.list_codi
       and a.orte_codi = bcab.movi_orte_codi;
  
    if v_cant = 0 then
      parameter.p_indi_mens_vali := 'S';
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'Forma de Pago no pertenece al Segmento/Lista de Precio. Favor verificar.');
      else
        raise_application_error(-20010,
                                'Forma de Pago no pertenece al Segmento/Lista de Precio. Favor verificar.');
      end if;
    end if;
  end;

  procedure pp_validar_presupuesto(p_indi_vali in varchar2 default 'C') is
    v_timo_codi      number;
    v_logi_auto      varchar2(20);
    v_esta_pres      varchar2(1);
    v_pres_tipo      varchar2(1);
    v_pres_mone_codi number;
    v_tasa_mone      number;
    v_tasa_come      number;
    v_pres_codi      number;
  
    v_cant_cont number;
    v_cant_gene number;
  begin
    select pres_timo_codi,
           pres_logi_auto,
           pres_esta_pres,
           pres_tipo,
           pres_mone_codi,
           pres_codi
      into v_timo_codi,
           v_logi_auto,
           v_esta_pres,
           v_pres_tipo,
           v_pres_mone_codi,
           v_pres_codi
      from come_pres_clie
     where pres_nume = bcab.pres_nume
       and pres_movi_codi is null
       and nvl(pres_tipo_pres, 'C') = 'C'; --Costeo
  
    bcab.s_pres_codi := v_pres_codi;
  
    select count(*)
      into v_cant_cont
      from come_cont_alqu
     where coal_pres_codi = v_pres_codi;
  
    if v_cant_cont > 0 then
      select count(*)
        into v_cant_gene
        from come_cont_alqu, come_cont_alqu_deta
       where coal_codi = deta_coal_codi
         and nvl(deta_indi_gene, 'N') = 'N'
         and coal_pres_codi = v_pres_codi;
    
      if v_cant_gene > 0 then
        p_indi_mens_vali := 'S';
        raise_application_error(-20010,
                                'El presupuesto posee ' || v_cant_gene ||
                                ' Contratos que aún no fueron generados.');
      end if;
    end if;
  
    if v_esta_pres = 'F' then
      p_indi_mens_vali := 'S';
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'El presupuesto posee estado Facturado.');
      else
        raise_application_error(-20010,
                                'El presupuesto posee estado Facturado.');
      end if;
    elsif v_esta_pres = 'P' then
      if parameter.p_indi_requ_auto_pedi = 'S' then
        if v_timo_codi in (2, 4) then
          p_indi_mens_vali := 'S';
          if nvl(p_indi_vali, 'C') = 'C' then
            raise_application_error(-20010,
                                    'El presupuesto debe ser Autorizado.');
          else
            raise_application_error(-20010,
                                    'El presupuesto debe ser Autorizado.');
          end if;
        end if;
      end if;
    end if;
  
    if v_pres_tipo = 'P' then
      p_indi_mens_vali := 'S';
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'El presupuesto debe ser de tipo Pedido.');
      else
        raise_application_error(-20010,
                                'El presupuesto debe ser de tipo Pedido.');
      end if;
    end if;
  
    if v_pres_mone_codi is not null then
      pp_busca_tasa_mone(v_pres_mone_codi, --bcab.movi_mone_codi,
                         bcab.movi_fech_emis,
                         v_tasa_mone, --bcab.movi_tasa_mone,
                         bcab.timo_tica_codi,
                         v_tasa_come,
                         nvl(p_indi_vali, 'C'));
    
      if parameter.p_codi_mone_dola is not null then
        pp_busca_tasa_mone(parameter.p_codi_mone_dola,
                           bcab.movi_fech_emis,
                           v_tasa_mone, --bcab.movi_tasa_us,
                           bcab.timo_tica_codi,
                           v_tasa_come,
                           nvl(p_indi_vali, 'C')); --bcab.movi_tasa_come);
      end if;
    end if;
  
  exception
    when no_data_found then
      bcab.s_pres_codi := -1;
      p_indi_mens_vali := 'S';
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'Presupuesto inexistente o ya ha sido Facturado.');
      else
        raise_application_error(-20010,
                                'Presupuesto inexistente o ya ha sido Facturado.');
      end if;
  end pp_validar_presupuesto;

  procedure pp_validar_contrato_alquiler(p_indi_vali in varchar2 default 'C') is
    v_timo_codi number;
    v_pres_codi number;
    v_esta_cont varchar2(1);
  
    v_cant_cont number;
    v_cant_gene number;
  begin
    select pres_timo_codi, nvl(coal_esta_cont, 'P'), pres_codi
      into v_timo_codi, v_esta_cont, v_pres_codi
      from come_pres_clie p, come_cont_alqu a
     where pres_nume = bcab.pres_nume
       and pres_movi_codi is null
       and nvl(pres_tipo_pres, 'C') = 'C'
       and p.pres_codi = a.coal_pres_codi(+); --Costeo
  
    bcab.s_pres_codi := v_pres_codi;
  
    select count(*)
      into v_cant_cont
      from come_cont_alqu
     where coal_pres_codi = v_pres_codi;
  
    if v_cant_cont > 0 then
      select count(*)
        into v_cant_gene
        from come_cont_alqu, come_cont_alqu_deta
       where coal_codi = deta_coal_codi
         and nvl(deta_indi_gene, 'N') = 'N'
         and coal_pres_codi = v_pres_codi;
    
      if v_cant_gene > 0 then
        p_indi_mens_vali := 'S';
        raise_application_error(-20010,
                                'El presupuesto posee ' || v_cant_gene ||
                                ' Contratos que aún no fueron generados.');
      end if;
    
      if v_esta_cont != 'A' then
        p_indi_mens_vali := 'S';
        raise_application_error(-20010,
                                'El contrato no se encuentra autorizado.');
      end if;
    
    end if;
  
  exception
    when no_data_found then
      bcab.s_pres_codi := -1;
      p_indi_mens_vali := 'S';
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'Presupuesto inexistente o ya ha sido Facturado.');
      else
        raise_application_error(-20010,
                                'Presupuesto inexistente o ya ha sido Facturado.');
      end if;
  end pp_validar_contrato_alquiler;

  procedure pp_veri_pedi_conf(p_pres_codi in number,
                              p_impo_deto out number) is
  
  begin
  
    select p.pres_impo_deto
      into p_impo_deto
      from come_pres_clie p, come_pres_clie_requ r
     where p.pres_codi = p_pres_codi
       and r.prre_pres_codi = p.pres_codi
       and p.pres_esta_pres <> 'F'
       and (r.prre_core_codi =
           (select dd.core_codi
               from come_conf_requ_pres_deta dd
              where dd.core_acci = 'LC') and r.prre_esta = 'C')
     group by p.pres_impo_deto;
  
  exception
    when no_data_found then
      p_impo_deto := 0;
    when others then
      p_impo_deto := 0;
  end;

  procedure pp_veri_limi_cred_espe(p_pres_codi      in number,
                                   p_clpr_codi      in number,
                                   p_cred_espe_mone out number) is
  
  begin
  
    select sum(cres_impo_mone)
      into p_cred_espe_mone
      from come_clie_cred_espe
     where cres_pres_codi <> p_pres_codi
       and cres_clpr_codi = p_clpr_codi
       and cres_pres_codi is not null
       and cres_esta = 'P';
  
  exception
    when no_data_found then
      p_cred_espe_mone := 0;
    when others then
      p_cred_espe_mone := 0;
  end;

  procedure pp_veri_codi_barr_mens is
  begin
    if parameter.p_indi_cons_pres = 'N' then
      null; /*raise_application_error(-20010,
                              'Debe indicar el codigo de barra del producto.');*/
    end if;
  end pp_veri_codi_barr_mens;

  procedure pp_veri_cheq_rech_clpr(p_indi_vali in varchar2 default 'C') is
    v_cant number := 0;
  
  begin
    select count(*)
      into v_cant
      from come_cheq ch
     where ch.cheq_clpr_codi = bcab.movi_clpr_codi
       and (ch.cheq_esta = 'R' or ch.cheq_esta = 'J')
       and nvl(ch.cheq_sald_mone, ch.cheq_impo_mone) > 0;
  
    if v_cant > 0 then
      if nvl(bcab.clpr_indi_exce, 'N') = 'S' then
        -- Si esta en Excepcion solo se advierte
        pp_envi_resp(i_mensaje => 'El cliente posee Cheques Rechazados. Favor comuniquese con el Dpto. de Creditos!');
      else
        p_indi_mens_vali := 'S';
        if nvl(p_indi_vali, 'C') = 'C' then
          pp_envi_resp(i_mensaje => 'El cliente posee Cheques Rechazados. Favor comuniquese con el Dpto. de Creditos!');
        else
          pp_envi_resp(i_mensaje => 'El cliente posee Cheques Rechazados. Favor comuniquese con el Dpto. de Creditos!');
        end if;
      end if;
    end if;
  
  exception
    when no_data_found then
      null;
  end;

  procedure pp_veri_nume(p_nume                in out number,
                         p_tico_codi           in number,
                         p_nume_timb           in varchar2,
                         p_fech_venc_timb      in date,
                         p_tico_indi_vali_nume in varchar2) is
    v_nume number;
  begin
    v_nume := p_nume;
    if nvl(p_tico_indi_vali_nume, 'N') = 'S' then
      loop
        begin
          select movi_nume
            into v_nume
            from come_movi, come_tipo_movi
           where movi_timo_codi = timo_codi
             and movi_nume = v_nume
             and timo_tico_codi = p_tico_codi
             and movi_nume_timb = p_nume_timb
             and movi_fech_venc_timb = p_fech_venc_timb;
        
          v_nume := v_nume + 1;
        exception
          when no_data_found then
            exit;
          when too_many_rows then
            v_nume := v_nume + 1;
        end;
      end loop;
    end if;
    p_nume := v_nume;
  
  end pp_veri_nume;

  procedure pp_veri_nume_dife(p_movi_nume           in number,
                              p_indi_nave           in varchar2,
                              p_indi_vali           in varchar2 default 'C',
                              p_tico_indi_vali_nume in varchar2,
                              p_movi_fech_emis      in date,
                              p_tico_fech_rein      in date,
                              p_tico_codi           in number) is
    v_count number := 0;
  begin
    if nvl(p_tico_indi_vali_nume, 'N') = 'S' then
      if p_movi_fech_emis <
         nvl(p_tico_fech_rein, to_date('01-01-1900', 'dd-mm-yyyy')) then
        select count(*)
          into v_count
          from come_movi, come_tipo_movi, come_tipo_comp
         where movi_nume = p_movi_nume
           and movi_timo_codi = timo_codi
           and timo_tico_codi = tico_codi
           and timo_tico_codi = p_tico_codi
           and movi_fech_emis < p_tico_fech_rein;
      elsif p_movi_fech_emis >=
            nvl(p_tico_fech_rein, to_date('01-01-1900', 'dd-mm-yyyy')) then
        select count(*)
          into v_count
          from come_movi, come_tipo_movi, come_tipo_comp
         where movi_nume = p_movi_nume
           and movi_timo_codi = timo_codi
           and timo_tico_codi = tico_codi
           and timo_tico_codi = p_tico_codi
           and movi_fech_emis >= p_tico_fech_rein;
      end if;
    end if;
    if v_count > 0 then
      if nvl(p_indi_vali, 'C') = 'C' then
        pl_me('Numero de comprobante ya existe. Favor verifique!');
      else
        pl_me('Numero de comprobante ya existe. Favor verifique!');
      end if;
    end if;
  end pp_veri_nume_dife;

  procedure pp_verificacion_dupl_fact is
  begin
    ---*****Verificacion de duplicacion de comprobante
    if parameter.p_indi_modi_nume_fact = 'N' then
      -- si el usuario tiene permiso o no de modificar el numero de factura.
      I020168.pp_veri_nume(p_nume                => bcab.movi_nume,
                           p_tico_codi           => bcab.tico_codi,
                           p_nume_timb           => bcab.movi_nume_timb,
                           p_fech_venc_timb      => bcab.fech_venc_timb,
                           p_tico_indi_vali_nume => bcab.tico_indi_vali_nume); -- verifica el numero de comprobante.. en caso que exista hace un loop y devuelve el siguiente numero libre..                                                             
    
      bcab.movi_nume_orig        := bcab.movi_nume;
      parameter.p_indi_actu_secu := 'S';
    else
      if bcab.movi_nume <> bcab.movi_nume_orig then
        -- si el numero de comprobante es distinto al numero traido de secuencia se esta cargando en diferido entonces no se actualiza secuencia.
        -- Pero verifica si existe!!!
        I020168.pp_veri_nume_dife(p_movi_nume           => bcab.movi_nume,
                                  p_indi_nave           => 'N',
                                  p_indi_vali           => 'V',
                                  p_tico_indi_vali_nume => bcab.tico_indi_vali_nume,
                                  p_movi_fech_emis      => bcab.movi_fech_emis,
                                  p_tico_fech_rein      => bcab.tico_fech_rein,
                                  p_tico_codi           => bcab.tico_codi);
      
        parameter.p_indi_actu_secu := 'N';
      else
        I020168.pp_veri_nume(p_nume                => bcab.movi_nume,
                             p_tico_codi           => bcab.tico_codi,
                             p_nume_timb           => bcab.movi_nume_timb,
                             p_fech_venc_timb      => bcab.fech_venc_timb,
                             p_tico_indi_vali_nume => bcab.tico_indi_vali_nume);
        bcab.movi_nume_orig        := bcab.movi_nume;
        parameter.p_indi_actu_secu := 'S';
      end if;
    end if;
    -- Volver a verificar para evitar que otro usuario registre al mismo tiempo
    --pp_valida_nume_fact_fini;
    pp_valida_nume_fact_anul;
  end pp_verificacion_dupl_fact;

  procedure pp_carg_dato_depo is
    v_form_impr number;
    v_rownum    number;
  
    v_movi_depo_codi_orig number;
    v_movi_depo_desc_orig varchar2(500);
    v_depo_codi_alte_orig number;
    v_movi_sucu_codi_orig number;
    v_movi_sucu_desc_orig varchar2(500);
    v_sucu_codi_alte_orig number;
    v_moco_ceco_codi      number;
  
    i_depo_codi_alte_orig number;
  
  begin
    if v('P20_USER_DEPO_CODI_ALTE') is not null then
      i_depo_codi_alte_orig := v('P20_USER_DEPO_CODI_ALTE');
    end if;
  
    select depo_codi,
           depo_desc,
           depo_codi_alte,
           rownum,
           sucu_codi,
           sucu_desc,
           sucu_codi_alte,
           sucu_ceco_codi
    
      into v_movi_depo_codi_orig,
           v_movi_depo_desc_orig,
           v_depo_codi_alte_orig,
           v_rownum,
           v_movi_sucu_codi_orig,
           v_movi_sucu_desc_orig,
           v_sucu_codi_alte_orig,
           v_moco_ceco_codi
      from come_depo, come_sucu
     where depo_sucu_codi = V('AI_SUCU_CODI')
       and sucu_codi = depo_sucu_codi
       and depo_indi_fact = 'S'
       and (i_depo_codi_alte_orig is null or
           depo_codi_alte = v('P20_DEPO_CODI_ALTE_ORIG'))
       and rownum = 1
     order by depo_codi;
  
    setitem('P20_MOVI_DEPO_CODI_ORIG', v_movi_depo_codi_orig);
    setitem('P20_MOVI_DEPO_DESC_ORIG', v_movi_depo_desc_orig);
    setitem('P20_DEPO_CODI_ALTE_ORIG', v_depo_codi_alte_orig);
    setitem('P20_MOVI_SUCU_CODI_ORIG', v_movi_sucu_codi_orig);
    setitem('P20_MOVI_SUCU_DESC_ORIG', v_movi_sucu_desc_orig);
    setitem('P20_SUCU_CODI_ALTE_ORIG', v_sucu_codi_alte_orig);
    setitem('P20_MOCO_CECO_CODI', v_moco_ceco_codi);
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              sqlerrm || ' ' || i_depo_codi_alte_orig || '--' ||
                              V('AI_SUCU_CODI') || '--' ||
                              v('P20_DEPO_CODI_ALTE_ORIG') ||
                              'Error al momento de asignancion de deposito');
  end;

  procedure pp_carga_limi_cred(p_clpr_codi           in number,
                               p_mone_tasa           in number,
                               i_movi_mone_codi      in number,
                               i_movi_mone_cant_deci in number,
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
  
    if i_movi_mone_codi = parameter.p_codi_mone_mmnn then
      v_limi_cred := v_limi_cred_gs +
                     round((v_limi_cred_us + v_limi_cred_eu * p_mone_tasa),
                           0);
    end if;
  
    if i_movi_mone_codi = parameter.p_codi_mone_dola then
      v_limi_cred := round(v_limi_cred_gs / p_mone_tasa,
                           i_movi_mone_cant_deci) + v_limi_cred_us +
                     v_limi_cred_eu;
    end if;
  
    if i_movi_mone_codi = 4 then
      v_limi_cred := round(v_limi_cred_gs / p_mone_tasa,
                           i_movi_mone_cant_deci) + v_limi_cred_us +
                     v_limi_cred_eu;
    end if;
  
    p_limi_cred_mone := v_limi_cred;
  
  exception
    when no_data_found then
      p_limi_cred_mone := 0;
    when others then
      p_limi_cred_mone := 0;
  end;

  procedure pp_carga_sald_clie(p_clpr_codi           in number,
                               p_mone_tasa           in number,
                               i_movi_mone_cant_deci in number,
                               p_sald_clie_mone      out number) is
  begin
    select round(nvl(((sum(decode(tm.timo_dbcr,
                                  'D',
                                  c.cuot_sald_mmnn,
                                  -c.cuot_sald_mmnn))) / p_mone_tasa),
                     0),
                 i_movi_mone_cant_deci) Saldo
      into p_sald_clie_mone
      from come_movi m, come_movi_cuot c, come_tipo_movi tm
     where m.movi_codi = c.cuot_movi_codi
       and m.movi_timo_codi = tm.timo_codi
       and m.movi_clpr_codi = p_clpr_codi;
  
  exception
    when no_data_found then
      p_sald_clie_mone := 0;
    when others then
      p_sald_clie_mone := 0;
  end;

  procedure pp_carga_secu(o_movi_nume       out varchar2,
                          o_s_nro_1         out varchar2,
                          o_s_nro_2         out varchar2,
                          o_s_nro_3         out varchar2,
                          i_s_timo_calc_iva in varchar2,
                          i_s_pres_codi     in number,
                          i_pres_nume       in number) is
  begin
    if nvl(i_s_timo_calc_iva, 'N') = 'N' then
      --solo para fact en negro 
      if nvl(parameter.p_indi_carg_secu_bole_pres, 'N') = 'S' and
         i_s_pres_codi is not null then
        o_movi_nume := i_pres_nume;
      else
        select nvl(secu_nume_fact_negr, 0) + 1
          into o_movi_nume
          from come_secu
         where secu_codi = (select f.user_secu_codi
                              from segu_user f
                             where user_login = gen_user);
        /* (select peco_secu_codi
         from come_pers_comp
        where peco_codi = p_peco_codi);*/
      end if;
    else
    
      select nvl(secu_nume_fact, 0) + 1
        into o_movi_nume
        from come_secu
       where secu_codi = (select f.user_secu_codi
                            from segu_user f
                           where user_login = gen_user);
      /*  (select peco_secu_codi
       from come_pers_comp
      where peco_codi = p_peco_codi);*/
    end if;
  
    o_s_nro_1 := substr(lpad(o_movi_nume, 13, '0'), 1, 3);
    o_s_nro_2 := substr(lpad(o_movi_nume, 13, '0'), 4, 3);
    o_s_nro_3 := substr(lpad(o_movi_nume, 13, '0'), 7, 7);
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Codigo de Secuencia de Facturacion inexistente');
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_cargar_orte(p_indi_vali           in varchar2 default 'C',
                           i_clpr_orte_codi      in number,
                           i_movi_orte_codi      in number,
                           i_movi_orte_codi_ante in number,
                           i_s_pres_codi         in number,
                           i_list_codi           in number,
                           i_clpr_list_codi      in number,
                           i_s_timo_indi_caja    in varchar2,
                           o_s_orte_desc         out come_orde_term.orte_desc%type,
                           o_s_orte_maxi_porc    out come_orde_term.orte_maxi_porc%type,
                           o_s_orte_cant_cuot    out come_orde_term.orte_cant_cuot%type,
                           o_s_orte_porc_entr    out number,
                           o_s_orte_impo_cuot    out number,
                           o_s_orte_dias_cuot    out come_orde_term.orte_dias_cuot%type,
                           o_list_codi           out number,
                           o_orte_list_codi      out number) is
    v_cant_cuot number;
    v_list_codi number;
  
  begin
  
    select a.orte_desc,
           a.orte_maxi_porc,
           a.orte_cant_cuot,
           a.orte_list_codi,
           nvl(a.orte_porc_entr, 0),
           nvl(a.orte_impo_cuot, 0),
           a.orte_dias_cuot
      into o_s_orte_desc,
           o_s_orte_maxi_porc,
           o_s_orte_cant_cuot,
           v_list_codi,
           o_s_orte_porc_entr,
           o_s_orte_impo_cuot,
           o_s_orte_dias_cuot
      from come_orde_term a
     where a.orte_codi = i_movi_orte_codi
       and ((nvl(a.orte_indi_most_fopa, 'S') = 'S' and
           parameter.p_indi_most_fopa = 'S') or
           parameter.p_indi_most_fopa = 'N' or
           (a.orte_codi = i_clpr_orte_codi or i_s_pres_codi is not null));
  
    if i_s_pres_codi is null then
      if v_list_codi is not null and i_clpr_list_codi is null then
        o_list_codi      := v_list_codi;
        o_orte_list_codi := i_list_codi;
      else
        o_orte_list_codi := null;
      end if;
    end if;
  
    if nvl(i_s_timo_indi_caja, 'N') = 'N' and
       nvl(o_s_orte_cant_cuot, 0) <= 0 then
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'Para movimientos Credito solo puede seleccionar ' ||
                                'formas de pago cuya cantidad de cuotas sea mayor a 0 (cero).');
      end if;
    end if;
  
    if i_movi_orte_codi <> nvl(i_movi_orte_codi_ante, -99) then
      parameter.p_indi_cuot_entr := 'N';
    end if;
  exception
    when no_data_found then
      o_s_orte_desc              := null;
      o_s_orte_maxi_porc         := null;
      o_s_orte_cant_cuot         := null;
      o_s_orte_porc_entr         := null;
      o_s_orte_impo_cuot         := null;
      parameter.p_indi_cuot_entr := 'N';
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'Forma de Pago inexistente o No habilitado para visualizar. Favor verificar.');
      end if;
    
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_cargar_orte;

  procedure pp_cargar_orte(p_indi_vali in varchar2 default 'C') is
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
     where a.orte_codi = bcab.movi_orte_codi
       and ((nvl(a.orte_indi_most_fopa, 'S') = 'S' and
           parameter.p_indi_most_fopa = 'S') or
           parameter.p_indi_most_fopa = 'N' or
           (a.orte_codi = bcab.clpr_orte_codi or
           bcab.s_pres_codi is not null));
  
    if bcab.s_pres_codi is null then
      if v_list_codi is not null and bcab.clpr_list_codi is null then
        bcab.list_codi      := v_list_codi;
        bcab.orte_list_codi := bcab.list_codi;
      else
        bcab.orte_list_codi := null;
      end if;
    end if;
  
    if nvl(bcab.s_timo_indi_caja, 'N') = 'N' and
       nvl(bcab.s_orte_cant_cuot, 0) <= 0 then
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'Para movimientos Credito solo puede seleccionar ' ||
                                'formas de pago cuya cantidad de cuotas sea mayor a 0 (cero).');
      else
        parameter.p_indi_mens_vali := 'S';
        raise_application_error(-20010,
                                'Para movimientos Credito solo puede seleccionar ' ||
                                'formas de pago cuya cantidad de cuotas sea mayor a 0 (cero).');
      end if;
    end if;
  
    if bcab.movi_orte_codi <> nvl(bcab.movi_orte_codi_ante, -99) then
      parameter.p_indi_cuot_entr := 'N';
    end if;
  exception
    when no_data_found then
      bcab.s_orte_desc           := null;
      bcab.s_orte_maxi_porc      := null;
      bcab.s_orte_cant_cuot      := null;
      bcab.s_orte_porc_entr      := null;
      bcab.s_orte_impo_cuot      := null;
      parameter.p_indi_cuot_entr := 'N';
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'Forma de Pago inexistente o No habilitado para visualizar. Favor verificar.');
      else
        parameter.p_indi_mens_vali := 'S';
        raise_application_error(-20010,
                                'Forma de Pago inexistente o No habilitado para visualizar. Favor verificar.');
      end if;
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

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
  
    if bcab.movi_mone_codi = parameter.p_codi_mone_mmnn then
      v_limi_cred := v_limi_cred_gs +
                     round((v_limi_cred_us + v_limi_cred_eu * p_mone_tasa),
                           0);
    end if;
  
    if bcab.movi_mone_codi = parameter.p_codi_mone_dola then
      v_limi_cred := round(v_limi_cred_gs / p_mone_tasa,
                           bcab.movi_mone_cant_deci) + v_limi_cred_us +
                     v_limi_cred_eu;
    end if;
  
    if bcab.movi_mone_codi = 4 then
      v_limi_cred := round(v_limi_cred_gs / p_mone_tasa,
                           bcab.movi_mone_cant_deci) + v_limi_cred_us +
                     v_limi_cred_eu;
    end if;
  
    p_limi_cred_mone := v_limi_cred;
  
  exception
    when no_data_found then
      p_limi_cred_mone := 0;
    when others then
      p_limi_cred_mone := 0;
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
                 bcab.movi_mone_cant_deci) Saldo
      into p_sald_clie_mone
      from come_movi m, come_movi_cuot c, come_tipo_movi tm
     where m.movi_codi = c.cuot_movi_codi
       and m.movi_timo_codi = tm.timo_codi
       and m.movi_clpr_codi = p_clpr_codi;
  
  exception
    when no_data_found then
      p_sald_clie_mone := 0;
    when others then
      p_sald_clie_mone := 0;
  end;

  procedure pp_calcular_importe_item is
    v_impo_tota      number := 0;
    v_impo_tota_mmnn number := 0;
    v_prec_deto      number := 0;
  begin
  
    if nvl(parameter.p_ind_validar_det, 'N') = 'S' then
    
      bdet.s_descuento := round((bdet.deta_prec_unit * bdet.deta_cant_medi *
                                bdet.deta_porc_deto / 100),
                                bdet.movi_mone_cant_deci);
    
      v_impo_tota := round((nvl(bdet.deta_prec_unit, 0) *
                           (1 - (nvl(bdet.deta_porc_deto, 0) / 100)) *
                           nvl(bdet.deta_cant_medi, 0)),
                           bdet.movi_mone_cant_deci);
    
      bdet.deta_impo_mone_ii := v_impo_tota;
      bdet.deta_impo_mmnn_ii := round((bdet.deta_impo_mone_ii *
                                      bdet.movi_tasa_mone),
                                      parameter.p_cant_Deci_mmnn);
    
      if nvl(bdet.conc_dbcr, 'D') = 'C' then
        bdet.deta_impo_mone_ii := bdet.deta_impo_mone_ii * -1;
        bdet.deta_impo_mmnn_ii := bdet.deta_impo_mmnn_ii * -1;
      
      end if;
    
      pa_devu_impo_calc(bdet.deta_impo_mone_ii,
                        bdet.movi_mone_cant_deci,
                        bdet.deta_impu_porc,
                        bdet.deta_impu_porc_base_impo,
                        bdet.deta_impu_indi_baim_impu_incl,
                        bdet.deta_impo_mone_ii,
                        bdet.deta_grav10_mone_ii,
                        bdet.deta_grav5_mone_ii,
                        bdet.deta_grav10_mone,
                        bdet.deta_grav5_mone,
                        bdet.deta_iva10_mone,
                        bdet.deta_iva5_mone,
                        bdet.deta_exen_mone);
    
      pa_devu_impo_calc(bdet.deta_impo_mmnn_ii,
                        parameter.p_cant_deci_mmnn,
                        bdet.deta_impu_porc,
                        bdet.deta_impu_porc_base_impo,
                        bdet.deta_impu_indi_baim_impu_incl,
                        bdet.deta_impo_mmnn_ii,
                        bdet.deta_grav10_mmnn_ii,
                        bdet.deta_grav5_mmnn_ii,
                        bdet.deta_grav10_mmnn,
                        bdet.deta_grav5_mmnn,
                        bdet.deta_iva10_mmnn,
                        bdet.deta_iva5_mmnn,
                        bdet.deta_exen_mmnn);
    
      bdet.deta_impo_mmnn := nvl(bdet.deta_exen_mmnn, 0) +
                             nvl(bdet.deta_grav10_mmnn, 0) +
                             nvl(bdet.deta_grav5_mmnn, 0);
      bdet.deta_impo_mone := nvl(bdet.deta_exen_mone, 0) +
                             nvl(bdet.deta_grav10_mone, 0) +
                             nvl(bdet.deta_grav5_mone, 0);
      bdet.deta_iva_mmnn  := nvl(bdet.deta_iva10_mmnn, 0) +
                             nvl(bdet.deta_iva5_mmnn, 0);
      bdet.deta_iva_mone  := nvl(bdet.deta_iva10_mone, 0) +
                             nvl(bdet.deta_iva5_mone, 0);
    end if;
  
  exception
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_calcular_importe_cab is
  begin
  
    i020168.pp_set_variable;
  
    select sum(taax_n008) sum_s_descuento,
           sum(taax_n010) sum_deta_grav10_mone_ii,
           sum(taax_n011) sum_deta_grav5_mone_ii,
           sum(taax_n016) sum_deta_exen_mone
      into bdet.sum_s_descuento,
           bdet.sum_deta_grav10_mone_ii,
           bdet.sum_deta_grav5_mone_ii,
           bdet.sum_deta_exen_mone
      from come_tabl_auxi
     where taax_sess = p_sess
       and taax_user = gen_user
       and taax_c050 = 'FACT_DETA';
  
    bcab.movi_grav10_ii_mone := bdet.sum_deta_grav10_mone_ii;
    bcab.movi_grav5_ii_mone  := bdet.sum_deta_grav5_mone_ii;
  
    bcab.movi_exen_mone := bdet.sum_deta_exen_mone;
  
    bcab.movi_impo_mone_ii := bcab.movi_grav10_ii_mone +
                              bcab.movi_grav5_ii_mone + bcab.movi_exen_mone;
    bcab.s_total           := bcab.movi_impo_mone_ii;
  
    ---importe iva incluido en mmnn
    bcab.movi_grav10_ii_mmnn := round((bcab.movi_grav10_ii_mone *
                                      bcab.movi_tasa_mone),
                                      parameter.p_cant_deci_mmnn);
    bcab.movi_grav5_ii_mmnn  := round((bcab.movi_grav5_ii_mone *
                                      bcab.movi_tasa_mone),
                                      parameter.p_cant_deci_mmnn);
    bcab.movi_exen_mmnn      := round((bcab.movi_exen_mone *
                                      bcab.movi_tasa_mone),
                                      parameter.p_cant_deci_mmnn);
  
    bcab.movi_iva10_mone := round((bcab.movi_grav10_ii_mone / 11),
                                  bcab.movi_mone_cant_deci);
    bcab.movi_iva5_mone  := round((bcab.movi_grav5_ii_mone / 21),
                                  bcab.movi_mone_cant_deci);
  
    bcab.s_iva_10  := bcab.movi_iva10_mone;
    bcab.s_iva_5   := bcab.movi_iva5_mone;
    bcab.s_tot_iva := bcab.movi_iva10_mone + bcab.movi_iva5_mone;
  
    bcab.movi_iva10_mmnn := round((bcab.movi_grav10_ii_mmnn / 11),
                                  parameter.p_cant_deci_mmnn);
    bcab.movi_iva5_mmnn  := round((bcab.movi_grav5_ii_mmnn / 21),
                                  parameter.p_cant_deci_mmnn);
  
    bcab.movi_grav10_mone := round((bcab.movi_grav10_ii_mone / 1.1),
                                   bcab.movi_mone_cant_deci);
    bcab.movi_grav5_mone  := round((bcab.movi_grav5_ii_mone / 1.05),
                                   bcab.movi_mone_cant_deci);
  
    bcab.movi_grav10_mmnn  := round((bcab.movi_grav10_ii_mmnn / 1.1),
                                    parameter.p_cant_deci_mmnn);
    bcab.movi_grav5_mmnn   := round((bcab.movi_grav5_ii_mmnn / 1.05),
                                    parameter.p_cant_deci_mmnn);
    bcab.movi_impo_mmnn_ii := bcab.movi_grav10_ii_mmnn +
                              bcab.movi_grav5_ii_mmnn + bcab.movi_exen_mmnn;
  
    --importes netos
    bcab.movi_grav_mone := bcab.movi_grav10_mone + bcab.movi_grav5_mone;
    bcab.movi_iva_mone  := bcab.movi_iva10_mone + bcab.movi_iva5_mone;
  
    bcab.movi_grav_mmnn := bcab.movi_grav10_mmnn + bcab.movi_grav5_mmnn;
    bcab.movi_iva_mmnn  := bcab.movi_iva10_mmnn + bcab.movi_iva5_mmnn;
  
    --saldo 
    if nvl(bcab.movi_timo_indi_sald, 'N') = 'N' then
      -- si no afecta el saldo del cliente o proveedor
      bcab.movi_sald_mone := 0;
      bcab.movi_sald_mmnn := 0;
    else
      bcab.movi_sald_mone := bcab.movi_impo_mone_ii;
      bcab.movi_sald_mmnn := bcab.movi_impo_mmnn_ii;
    end if;
    --para no borrar campos de la cabecera se le asigna los importes correspondientes ya calculados
    bcab.s_exen       := bcab.movi_exen_mone;
    bcab.s_grav_5_ii  := bcab.movi_grav5_ii_mone;
    bcab.s_grav_10_ii := bcab.movi_grav10_ii_mone;
    bcab.s_grav       := bcab.movi_grav_mone;
    bcab.s_iva_10     := bcab.movi_iva10_mone;
    bcab.s_iva_5      := bcab.movi_iva5_mone;
    bcab.s_iva        := bcab.s_tot_iva;
    bcab.s_total_dto  := bdet.sum_s_descuento;
  
    setitem('P20_S_EXEN', nvl(bcab.s_exen, 0));
    setitem('P20_S_GRAV_5_II', nvl(bcab.s_grav_5_ii, 0));
    setitem('P20_S_GRAV_10_II', nvl(bcab.s_grav_10_ii, 0));
    setitem('P20_S_IVA_5', nvl(bcab.s_iva_5, 0));
    setitem('P20_S_IVA_10', nvl(bcab.s_iva_10, 0));
    setitem('P20_S_IVA', nvl(bcab.s_iva, 0));
    setitem('P20_S_TOTAL_DTO', nvl(bcab.s_total_dto, 0));
    setitem('P20_S_TOTAL', nvl(bcab.s_total, 0));
  
  exception
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_mostrar_clpr(i_clpr_codi_alte           in number,
                            i_indi_vali                in varchar2 default 'C',
                            i_s_pres_codi              in number,
                            o_clpr_indi_vali_limi_cred out come_clie_prov.clpr_indi_vali_limi_cred%type,
                            o_movi_clpr_ruc            out come_clie_prov.clpr_ruc%type,
                            o_movi_clpr_dire           out come_clie_prov.clpr_dire%type,
                            o_movi_clpr_tele           out come_clie_prov.clpr_tele%type,
                            o_clpr_cli_situ_codi       out come_clie_prov.clpr_cli_situ_codi%type,
                            o_clpr_indi_vali_situ_clie out come_clie_prov.clpr_indi_vali_situ_clie%type,
                            o_clpr_indi_exen           out come_clie_prov.clpr_indi_exen%type,
                            o_clpr_indi_list_negr      out come_clie_prov.clpr_indi_list_negr%type,
                            o_clpr_indi_exce           out come_clie_prov.clpr_indi_exce%type,
                            o_clpr_maxi_porc_deto      out come_clie_prov.clpr_maxi_porc_deto%type,
                            o_clpr_segm_codi           out come_clie_prov.clpr_segm_codi%type,
                            o_clpr_clie_clas1_codi     out come_clie_prov.clpr_clie_clas1_codi%type,
                            o_clpr_orte_codi           out come_clie_prov.clpr_orte_codi%type,
                            o_clpr_indi_vali_prec_mini out come_clie_prov.clpr_indi_vali_prec_mini%type,
                            o_s_clpr_agen_codi         out come_clie_prov.clpr_empl_codi%type,
                            o_clpr_zona_codi           out come_clie_prov.clpr_zona_codi%type,
                            o_clpr_fech_regi           out come_clie_prov.clpr_fech_regi%type,
                            o_clpr_fech_modi           out come_clie_prov.clpr_fech_modi%type,
                            o_list_codi                out number,
                            o_p_indi_mens_vali         out varchar2,
                            o_movi_orte_codi           out number,
                            o_erro_codi                out number) is
  
    v_clpr_esta           varchar(1);
    v_clpr_indi_inforconf varchar2(1);
    v_list_codi           number;
    v_cant_cuot           number;
  
  begin
  
    select clpr_esta,
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
           orte_cant_cuot,
           clpr_zona_codi,
           clpr_fech_regi,
           clpr_fech_modi
    
      into v_clpr_esta,
           o_clpr_indi_vali_limi_cred,
           o_movi_clpr_ruc,
           o_movi_clpr_dire,
           o_movi_clpr_tele,
           o_clpr_cli_situ_codi,
           o_clpr_indi_vali_situ_clie,
           o_clpr_indi_exen,
           o_clpr_indi_list_negr,
           o_clpr_indi_exce,
           o_clpr_maxi_porc_deto,
           o_clpr_segm_codi,
           v_list_codi,
           o_clpr_clie_clas1_codi,
           o_clpr_orte_codi,
           v_clpr_indi_inforconf,
           o_clpr_indi_vali_prec_mini,
           o_s_clpr_agen_codi,
           v_cant_cuot,
           o_clpr_zona_codi,
           o_clpr_fech_regi,
           o_clpr_fech_modi
      from come_clie_prov, come_orde_term
     where clpr_codi = i_clpr_codi_alte
       and clpr_orte_codi = orte_codi(+)
       and clpr_indi_clie_prov = i_indi_vali;
  
    if v_clpr_esta = 'I' then
      o_p_indi_mens_vali := 'S';
      if nvl(i_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'El cliente se encuentra Inactivo.');
      end if;
    end if;
  
    if i_s_pres_codi is null then
      if o_clpr_orte_codi is not null then
        --En caso de volver a recorrer,que no recargue nulo
        o_movi_orte_codi := o_clpr_orte_codi;
      end if;
    
      if v_list_codi is not null then
        o_list_codi := v_list_codi;
      end if;
    end if;
  
    if o_clpr_indi_list_negr = 'S' then
      if o_clpr_indi_exen = 'S' then
        -- Si esta en Excepcion solo se advierte               
        o_erro_codi := 1;
      
      else
        o_p_indi_mens_vali := 'S';
        if nvl(i_indi_vali, 'C') = 'C' then
          raise_application_error(-20010,
                                  'Atencion, No se puede facturar al cliente!!! Se encuentra en Lista Negra.');
        end if;
      end if;
    end if;
  
    if nvl(v_clpr_indi_inforconf, 'N') = 'S' then
      if o_clpr_indi_exce = 'S' then
        -- Si esta en Excepcion solo se advierte            
        o_erro_codi := 1;
      
      else
        o_erro_codi := 1;
      
      end if;
    end if;
  
  exception
    when no_data_found then
      o_clpr_indi_vali_limi_cred := null;
      o_movi_clpr_ruc            := null;
      o_movi_clpr_dire           := null;
      o_movi_clpr_tele           := null;
      o_clpr_cli_situ_codi       := null;
      o_clpr_indi_vali_situ_clie := null;
      o_clpr_indi_exen           := null;
      o_clpr_indi_list_negr      := null;
      o_clpr_indi_exce           := null;
      o_clpr_maxi_porc_deto      := null;
      o_clpr_segm_codi           := null;
      o_clpr_clie_clas1_codi     := null;
      o_movi_orte_codi           := null;
      o_clpr_indi_vali_prec_mini := null;
      o_clpr_zona_codi           := null;
      o_clpr_fech_regi           := null;
      o_clpr_fech_modi           := null;
    
      o_p_indi_mens_vali := 'S';
      if nvl(i_indi_vali, 'C') = 'C' then
        raise_application_error(-20010, 'Cliente inexistente!');
      end if;
    when others then
      o_p_indi_mens_vali := 'S';
      raise_application_error(-20010,
                              'Error al momento de mostrar cliente. ' ||
                              sqlerrm);
  end;

  procedure pp_muestra_clpr_docu_info(i_clpr_codi      in number,
                                      o_clpr_info_per1 out varchar2,
                                      o_clpr_info_per2 out varchar2,
                                      o_clpr_info_per3 out varchar2) is
  begin
    select cldo_info_per1, cldo_info_per2, cldo_info_per3
      into o_clpr_info_per1, o_clpr_info_per2, o_clpr_info_per3
      from come_clie_docu_info
     where cldo_info_clpr_codi = i_clpr_codi;
  
  exception
    when no_data_found then
      o_clpr_info_per1 := null;
      o_clpr_info_per2 := null;
      o_clpr_info_per3 := null;
    when others then
      raise_application_error(-20010,
                              'Error al momento de mostrar docu_info. ' ||
                              sqlerrm);
  end;

  procedure pp_muestra_clpr_agen(i_clpr_agen_codi      in number,
                                 o_clpr_agen_codi_alte out varchar2,
                                 o_clpr_agen_desc      out varchar2) is
  begin
  
    select empl_codi_alte || ' - ' || empl_desc, empl_codi_alte
      into o_clpr_agen_desc, o_clpr_agen_codi_alte
      from come_empl
     where empl_codi = i_clpr_agen_codi;
  
  exception
    when no_data_found then
      o_clpr_agen_desc      := 'No tiene agente asignado.';
      o_clpr_agen_codi_alte := null;
    when others then
      raise_application_error(-20010,
                              'Error al momento de buscar agente. ' ||
                              sqlerrm);
  end;

  procedure pp_muestra_come_depo_alte(p_depo_empr_codi in number,
                                      p_depo_codi_alte in varchar2,
                                      p_depo_desc      out varchar2,
                                      p_depo_codi      out number,
                                      p_sucu_codi_alte out varchar2,
                                      p_sucu_desc      out varchar2,
                                      p_sucu_codi      out number) is
  
  begin
    if nvl(parameter.p_indi_vali_depo_user_fact, 'S') = 'S' then
      select d.depo_desc,
             d.depo_codi,
             s.sucu_codi_alte,
             s.sucu_desc,
             s.sucu_codi
        into p_depo_desc,
             p_depo_codi,
             p_sucu_codi_alte,
             p_sucu_desc,
             p_sucu_codi
        from come_depo d, come_sucu s, segu_user_depo_orig du, segu_user u
       where d.depo_sucu_codi = s.sucu_codi(+)
         and d.depo_empr_codi = p_depo_empr_codi
         and ltrim(rtrim(lower(d.depo_codi_alte))) =
             ltrim(rtrim(lower(p_depo_codi_alte)))
         and d.depo_codi = du.udor_depo_codi
         and du.udor_user_codi = u.user_codi
         and u.user_login = gen_user;
    else
      select d.depo_desc,
             d.depo_codi,
             s.sucu_codi_alte,
             s.sucu_desc,
             s.sucu_codi
        into p_depo_desc,
             p_depo_codi,
             p_sucu_codi_alte,
             p_sucu_desc,
             p_sucu_codi
        from come_depo d, come_sucu s
       where d.depo_sucu_codi = s.sucu_codi(+)
         and d.depo_empr_codi = p_depo_empr_codi
         and ltrim(rtrim(lower(d.depo_codi))) =
             ltrim(rtrim(lower(p_depo_codi_alte)));
    end if;
  
  exception
    when no_data_found then
      p_depo_desc      := null;
      p_depo_codi      := null;
      p_sucu_codi_alte := null;
      p_sucu_desc      := null;
      p_sucu_codi      := null;
      raise_application_error(-20010, 'Deposito inexistente');
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_muestra_come_empl_alte(p_empl_empr_codi      in number,
                                      p_emti_tiem_codi      in number,
                                      p_empl_codi_alte      in number,
                                      p_empl_desc           out varchar2,
                                      p_empl_codi           out number,
                                      p_empl_maxi_porc_deto out number) is
  begin
  
    select e.empl_desc, e.empl_codi, nvl(e.empl_maxi_porc_deto, 0)
      into p_empl_desc, p_empl_codi, p_empl_maxi_porc_deto
      from come_empl e, come_empl_tiem t
     where e.empl_codi = t.emti_empl_codi
       and t.emti_tiem_codi = p_emti_tiem_codi
       and e.empl_empr_codi = p_empl_empr_codi
       and ltrim(rtrim(lower(e.empl_codi))) =
           ltrim(rtrim(lower(p_empl_codi_alte)));
  
  exception
    when no_data_found then
      null;
      /* p_empl_desc           := null;
      p_empl_codi           := null;
      p_empl_maxi_porc_deto := 0;
      raise_application_error(-20010,
                              'Empleado inexistente o no es del tipo requerido.');*/
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_muestra_impu(i_deta_impu_codi           in number,
                            i_s_timo_calc_iva          in varchar2,
                            i_movi_dbcr                in varchar2,
                            o_deta_impu_codi           out number,
                            o_deta_impu_conc_codi      out number,
                            o_deta_impu_desc           out varchar2,
                            o_deta_impu_porc           out number,
                            o_deta_impu_porc_base_impo out number,
                            o_deta_impu_indi_baim_impu out varchar2) is
  begin
  
    select impu_desc,
           impu_porc,
           impu_porc_base_impo,
           impu_indi_baim_impu_incl
      into o_deta_impu_desc,
           o_deta_impu_porc,
           o_deta_impu_porc_base_impo,
           o_deta_impu_indi_baim_impu
      from come_impu
     where impu_codi = i_deta_impu_codi;
  
    --si El tipo de movimiento tiene el indicador de calculo de iva 'N'
    --entonces siempre será exento....
    if i_s_timo_calc_iva = 'N' then
      o_deta_impu_codi           := parameter.p_codi_impu_exen;
      o_deta_impu_porc           := 0;
      o_deta_impu_porc_base_impo := 0;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Tipo de Impuesto inexistente');
    when too_many_rows then
      raise_application_error(-20010, 'Tipo de Impuesto duplicado');
    when others then
      raise_application_error(-20010, sqlerrm);
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
                              'Error al momento de buscar Decimales de la moneda.');
  end;

  procedure pp_busca_tasa_mone(p_mone_codi in number,
                               p_coti_fech in date,
                               p_mone_coti out number,
                               p_tica_codi in number,
                               p_tasa_come out number,
                               p_indi_vali in varchar2 default 'C') is
    p_mone_coti_p number;
    p_tasa_come_p number;
    b             number := 0;
  begin
  
    if parameter.p_codi_mone_mmnn = p_mone_codi then
      p_mone_coti := 1;
      p_tasa_come := 1;
      b           := 1;
      select coti_tasa, coti_tasa_come
        into p_mone_coti_p, p_tasa_come_p
        from come_coti
       where coti_mone = 2
         and coti_fech = p_coti_fech
         and coti_tica_codi = p_tica_codi;
    
    else
    
      select coti_tasa, coti_tasa_come
        into p_mone_coti, p_tasa_come
        from come_coti
       where coti_mone = p_mone_codi
         and coti_fech = p_coti_fech
         and coti_tica_codi = p_tica_codi;
    
    end if;
  
    if parameter.p_codi_mone_mmnn <> p_mone_codi and
       (nvl(p_mone_coti, 0) in (0, 1) or nvl(p_tasa_come, 0) in (0, 1)) then
    
      if nvl(p_indi_vali, 'C') = 'C' then
        raise_application_error(-20010,
                                'Cotización no válida para la moneda ' ||
                                p_mone_codi ||
                                ' para la fecha del documento.');
      end if;
    end if;
  
  exception
    when no_data_found then
      p_mone_coti := null;
      p_tasa_come := null;
      if nvl(p_indi_vali, 'C') = 'C' then
        if b = 1 then
          raise_application_error(-20010,
                                  'Cotizacion Inexistente de la moneda 2 para la fecha del documento.');
        else
          raise_application_error(-20010,
                                  'Cotizacion Inexistente de la moneda ' ||
                                  p_mone_codi ||
                                  ' para la fecha del documento.');
        end if;
      end if;
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_busca_exce_deto_fp_impo(p_indi_cab_deta       in varchar2,
                                       p_clpr_codi           in number,
                                       p_fech_emis           in date,
                                       p_fech_emis_hora      in date,
                                       p_mone_codi           in number,
                                       i_s_pres_codi         in number,
                                       i_movi_tasa_come      in number,
                                       i_movi_tasa_mone      in number,
                                       i_movi_mone_cant_deci in number,
                                       p_exde_codi           out number,
                                       p_deto_prec           out varchar2,
                                       p_exde_tipo           out varchar2,
                                       p_exde_peri           out varchar2,
                                       p_exde_porc           out number,
                                       p_exde_impo           out number) is
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
       where ((p_indi_cab_deta = 'C' and exde_tipo in ('F', 'I')) or
             (p_indi_cab_deta = 'D' and exde_tipo = 'K'))
         and exde_clpr_codi = p_clpr_codi
         and exde_form = 'C'
         and ((exde_tipo_peri = 'V') or
             (exde_tipo_peri in ('D', 'M') and
             p_fech_emis between exde_fech_desd and exde_fech_hast) or
             (exde_tipo_peri = 'H' and
             p_fech_emis_hora between exde_fech_desd and exde_fech_hast))
         and exde_esta = 'A'
         and (exde_pres_codi is null or
             (exde_pres_codi is not null and i_s_pres_codi is not null and
             exde_pres_codi = i_s_pres_codi))
       order by exde_codi;
  
  begin
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
                                 nvl(i_movi_tasa_come, i_movi_tasa_mone),
                                 i_movi_mone_cant_deci);
          else
            v_exde_impo := round(v_exde_impo /
                                 nvl(i_movi_tasa_come, i_movi_tasa_mone),
                                 i_movi_mone_cant_deci);
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
  
  end pp_busca_exce_deto_fp_impo;

  procedure pp_busca_conce_prod(p_clco_codi in number,
                                p_oper_codi in number,
                                p_conc_codi out number,
                                p_conc_dbcr out char) is
  begin
  
    select deta_conc_codi, conc_dbcr
      into p_conc_codi, p_conc_dbcr
      from come_prod_clas_conc, come_prod_clas_conc_deta, come_conc
     where clco_codi = deta_clco_codi
       and deta_conc_codi = conc_codi
       and deta_oper_codi = p_oper_codi
       and deta_clco_codi = p_clco_codi;
  
  exception
    when no_data_found then
      p_conc_dbcr := null;
      p_conc_codi := null;
      raise_application_error(-20010,
                              'Concepto de producto no encontrado!');
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end;

  procedure pp_buscar_precio_conc(i_deta_prod_codi      in number,
                                  i_list_codi           in number,
                                  i_movi_mone_codi      in number,
                                  i_movi_tasa_mone      in number,
                                  i_movi_mone_cant_deci in number,
                                  i_deta_prec_unit      out number,
                                  i_deta_prec_unit_list out number,
                                  i_prod_codi_ante      in number) is
    v_prec           number;
    v_lide_mone_codi number;
    v_prec_list      number;
  begin
    select lide_prec, lide_mone_codi
      into v_prec, v_lide_mone_codi
      from come_list_prec_conc_deta
     where lide_list_codi = i_list_codi
       and lide_conc_codi = i_deta_prod_codi;
  
    if v_lide_mone_codi = i_movi_mone_codi then
      --si La moneda de la Factura es igual a la moneda del precio del producto   
      v_prec_list := v_prec;
    else
      -- si la moneda del precio del producto no es igual a la moneda de la factura
      if i_movi_mone_codi = parameter.p_codi_mone_mmnn then
        --Si la moneda de la Factura es en Gs..
        v_prec_list := round((v_prec * i_movi_tasa_mone),
                             i_movi_mone_cant_deci);
      else
        --si la moneda de la Factura es en US, tenemos que dividir por la tasa
        v_prec_list := round((v_prec / i_movi_tasa_mone),
                             i_movi_mone_cant_deci);
      end if;
    end if;
  
    if nvl(i_deta_prec_unit, 0) <= 0 or
       nvl(i_prod_codi_ante, -1) <> nvl(i_deta_prod_codi, -1) then
      i_deta_prec_unit      := v_prec_list;
      i_deta_prec_unit_list := i_deta_prec_unit;
    end if;
  
    i_deta_prec_unit_list := v_prec_list;
    i_deta_prec_unit_list := v_prec_list;
  
  exception
    when no_data_found then
      if parameter.p_indi_most_mens_aler = 'S' then
      
        i_deta_prec_unit_list := null;
        if fp_exis_pres = false then
          i_deta_prec_unit      := 0;
          i_deta_prec_unit_list := 0;
        else
          if nvl(i_deta_prec_unit, 0) <= 0 or
             nvl(i_prod_codi_ante, -1) <> nvl(i_deta_prod_codi, -1) then
            i_deta_prec_unit      := 0;
            i_deta_prec_unit_list := 0;
          end if;
        end if;
        pp_envi_resp('El producto no posee Precio en La lista de precio 02');
      else
        i_deta_prec_unit_list := i_deta_prec_unit;
      end if;
    
  end;

  procedure pp_busca_prec_cant(i_deta_cant_medi           in number,
                               i_deta_prod_Codi           in number,
                               i_deta_medi_codi           in number,
                               i_movi_mone_codi           in number,
                               i_movi_tasa_mone           in number,
                               i_movi_tasa_come           in number,
                               i_movi_mone_cant_deci      in number,
                               i_list_codi                in number,
                               i_deta_prec_unit_pres      in number,
                               o_deta_list_codi           out number,
                               o_deta_prec_unit           out number,
                               o_lide_indi_vali_prec_mini out number,
                               o_prod_maxi_porc_desc      out number,
                               o_lide_maxi_porc_deto      out number) is
  
    v_list_codi                number;
    v_count                    number;
    v_deta_prec_unit_list      number;
    v_lide_indi_vali_prec_mini number;
    v_prod_maxi_porc_desc      number;
    v_lide_maxi_porc_deto      number;
  
  begin
  
    if i_deta_cant_medi > 0 then
    
      select count(*)
        into v_count
        from come_prod_list_cant lc
       where lc.lica_coba_prod_codi = i_deta_prod_Codi;
    
      if v_count > 0 then
      
        begin
          select lc.lica_list_codi_mayo
            into v_list_codi
            from come_prod_list_cant lc
           where i_deta_cant_medi between lica_cant_desd_mayo and
                 lica_cant_hast_mayo
             and lc.lica_coba_prod_codi = i_deta_prod_Codi;
        
        exception
          when others then
            begin
              select lc.lica_list_codi_mino
                into v_list_codi
                from come_prod_list_cant lc
               where i_deta_cant_medi between lica_cant_desd_mino and
                     lica_cant_hast_mino
                 and lc.lica_coba_prod_codi = i_deta_prod_Codi;
            
            exception
              when others then
                v_list_codi := null;
              
            end;
        end;
      
        if v_list_codi is not null then
          o_deta_list_codi := v_list_codi;
          pp_busca_prec_list_prec(nvl(v_list_codi, i_list_codi),
                                  i_movi_mone_codi,
                                  i_deta_prod_codi,
                                  i_deta_medi_codi,
                                  i_movi_tasa_mone,
                                  i_movi_tasa_come,
                                  i_movi_mone_cant_deci,
                                  v_deta_prec_unit_list,
                                  v_lide_indi_vali_prec_mini,
                                  v_prod_maxi_porc_desc,
                                  v_lide_maxi_porc_deto);
        
          if i_deta_prec_unit_pres is null then
            o_deta_prec_unit := v_deta_prec_unit_list;
          else
            o_deta_prec_unit := i_deta_prec_unit_pres;
          end if;
        end if;
      end if;
    
      o_lide_indi_vali_prec_mini := v_lide_indi_vali_prec_mini;
      o_prod_maxi_porc_desc      := v_prod_maxi_porc_desc;
      o_lide_maxi_porc_deto      := v_lide_maxi_porc_deto;
    
    end if;
  
  end pp_busca_prec_cant;

  procedure pp_busca_prec_list_prec(p_list_prec                in number,
                                    p_mone_codi                in number,
                                    p_prod_codi                in number,
                                    p_medi_codi                in number,
                                    p_movi_tasa_mone           in number,
                                    p_movi_tasa_come           in number,
                                    p_movi_mone_cant_deci      in number,
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
    -- and b.lide_mone_codi = p_mone_codi;
  
    if v_lide_mone_codi = p_mone_codi then
      --si La moneda de la Factura es igual a la moneda del precio del producto   
      p_prec_unit := v_prec_list_prec;
    else
      -- si la moneda del precio del producto no es igual a la moneda de la factura
      if p_mone_codi = parameter.p_codi_mone_mmnn then
        --Si la moneda de la Factura es en Gs..
        p_prec_unit := round((v_prec_list_prec * nvl(p_movi_tasa_come, 1)),
                             parameter.p_cant_deci_mmnn);
      else
        --si la moneda de la Factura es en US, tenemos que dividir por la tasa
        p_prec_unit := round((v_prec_list_prec / p_movi_tasa_mone),
                             p_movi_mone_cant_deci);
      end if;
    end if;
  
  exception
    when others then
      p_prec_unit                := 0;
      p_lide_indi_vali_prec_mini := 'N';
      p_prod_maxi_porc_desc      := 0;
      p_lide_maxi_porc_deto      := 0;
    
  end pp_busca_prec_list_prec;

  procedure pp_busca_exde_deto(i_movi_clpr_codi      in number,
                               i_movi_fech_emis      in date,
                               i_movi_fech_emis_hora in date,
                               i_movi_mone_codi      in number,
                               i_movi_tasa_come      in number,
                               i_movi_tasa_mone      in number,
                               i_movi_mone_cant_deci in number,
                               i_s_pres_codi         in number,
                               i_exde_tipo           in varchar2,
                               i_exde_deto_prec      in varchar2,
                               i_exde_peri           in varchar2,
                               i_deta_prod_codi      in number,
                               i_deta_proc_deto      in number,
                               i_deta_prec_unit      in out number,
                               i_deta_list_codi      in number,
                               i_list_codi           in number,
                               i_movi_orte_codi      in number,
                               i_deta_cant_medi      in number,
                               i_Deta_porc_deto      in out number,
                               i_deta_prec_unit_list in number,
                               i_clpr_segm_codi      in number,
                               i_deta_medi_codi      in number,
                               i_exde_cant_fact      in number,
                               i_exde_porc           in number,
                               i_exde_impo           in number,
                               
                               o_exde_codi        out number,
                               o_exde_deto_prec   out varchar2,
                               o_exde_tipo        out varchar2,
                               o_exde_peri        out varchar2,
                               o_exde_porc        out number,
                               o_exde_impo        out number,
                               o_s_exde_tipo      out varchar2,
                               o_s_exde_tipo_peri out varchar2,
                               o_s_exde_deto_prec out varchar2) is
  begin
    --Por cliente
  
    pp_busca_exce_deto_fp_impo('D', --detalle
                               i_movi_clpr_codi,
                               i_movi_fech_emis,
                               i_movi_fech_emis_hora,
                               i_movi_mone_codi,
                               i_movi_tasa_come,
                               i_movi_tasa_mone,
                               i_movi_mone_cant_deci,
                               i_s_pres_codi,
                               --
                               o_exde_codi,
                               o_exde_deto_prec,
                               o_exde_tipo,
                               o_exde_peri,
                               o_exde_porc,
                               o_exde_impo);
  
    --- Por producto
    if nvl(i_exde_tipo, 'N') in ('N', 'P', 'C', 'O') then
      -- "P" en caso que sea el segundo registro y el primero haya tenido excepcion.
      pp_busca_exce_deto_prod(i_movi_clpr_codi,
                              i_deta_prod_codi,
                              nvl(i_deta_list_codi, i_list_codi),
                              i_movi_orte_codi,
                              i_clpr_segm_codi,
                              i_movi_fech_emis,
                              i_movi_mone_codi,
                              i_movi_tasa_come,
                              i_movi_mone_cant_deci,
                              i_s_pres_codi,
                              --
                              o_exde_codi,
                              o_exde_deto_prec,
                              o_exde_tipo,
                              o_exde_peri,
                              o_exde_porc,
                              o_exde_impo);
    end if;
  
    --Por cantidad
    if nvl(i_exde_tipo, 'N') in ('N', 'C') then
      -- "C" en caso que sea el segundo registro y el primero haya tenido excepcion.
      pp_busca_exce_deto_cant(i_movi_clpr_codi,
                              i_deta_prod_codi,
                              nvl(i_deta_list_codi, i_list_codi),
                              i_movi_orte_codi,
                              i_clpr_segm_codi,
                              i_movi_fech_emis,
                              i_movi_mone_codi,
                              i_deta_cant_medi,
                              
                              i_movi_tasa_come,
                              i_movi_mone_cant_deci,
                              i_exde_cant_fact,
                              
                              --
                              o_exde_codi,
                              o_exde_deto_prec,
                              o_exde_tipo,
                              o_exde_peri,
                              o_exde_porc,
                              o_exde_impo);
    end if;
  
    --Por obsequio
    if nvl(i_exde_tipo, 'N') in ('N', 'O') then
      -- "C" en caso que sea el segundo registro y el primero haya tenido excepcion.
      pp_busca_exce_deto_obse(i_movi_clpr_codi,
                              i_deta_prod_codi,
                              i_movi_fech_emis,
                              i_movi_mone_codi,
                              i_deta_cant_medi,
                              i_deta_medi_codi,
                              i_movi_tasa_come,
                              i_movi_mone_cant_deci,
                              i_s_pres_codi,
                              --
                              o_exde_codi,
                              o_exde_deto_prec,
                              o_exde_tipo,
                              o_exde_peri,
                              o_exde_porc,
                              o_exde_impo);
    end if;
  
    if nvl(parameter.p_indi_suge_exde, 'S') = 'S' then
      --Indicador para que solo sugiera descuentos en la validacion del detalle
      if nvl(i_exde_deto_prec, 'I') = 'P' then
        if i_deta_porc_deto is null then
          if nvl(i_exde_porc, 0) <> 0 then
            i_deta_porc_deto := i_exde_porc;
          end if;
        end if;
      else
        if i_deta_prec_unit = i_deta_prec_unit_list then
          if nvl(i_exde_impo, 0) <> 0 then
            i_deta_prec_unit := i_exde_impo;
          end if;
        end if;
      end if;
    end if;
  
    if i_exde_tipo is not null then
      if i_exde_tipo = 'P' then
        o_s_exde_tipo := 'Producto';
      elsif i_exde_tipo = 'C' then
        o_s_exde_tipo := 'Descuento Producto por Cantidad';
      elsif i_exde_tipo = 'K' then
        o_s_exde_tipo := 'Cliente al Costo';
      elsif i_exde_tipo = 'O' then
        o_s_exde_tipo := 'Obsequio';
      end if;
    end if;
  
    if i_exde_peri is not null then
      if i_exde_peri = 'V' then
        o_s_exde_tipo_peri := 'Venta';
      elsif i_exde_peri = 'D' then
        o_s_exde_tipo_peri := 'Dia';
      elsif i_exde_peri = 'H' then
        o_s_exde_tipo_peri := 'Hora';
      elsif i_exde_peri = 'M' then
        o_s_exde_tipo_peri := 'Mes';
      end if;
    end if;
  
    if i_exde_deto_prec is not null then
      if i_exde_deto_prec = 'I' then
        o_s_exde_deto_prec := 'Importe';
      elsif i_exde_deto_prec = 'P' then
        o_s_exde_deto_prec := 'Porcentaje';
      end if;
    end if;
  
  end pp_busca_exde_deto;

  procedure pp_busca_exce_deto_fp_impo(p_indi_cab_deta       in varchar2,
                                       p_clpr_codi           in number,
                                       p_fech_emis           in date,
                                       p_fech_emis_hora      in date,
                                       p_mone_codi           in number,
                                       i_movi_tasa_come      in number,
                                       i_movi_tasa_mone      in number,
                                       i_movi_mone_cant_deci in number,
                                       i_s_pres_codi         in number,
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
       where ((p_indi_cab_deta = 'C' and exde_tipo in ('F', 'I')) or
             (p_indi_cab_deta = 'D' and exde_tipo = 'K'))
         and exde_clpr_codi = p_clpr_codi
         and exde_form = 'C'
         and ((exde_tipo_peri = 'V') or
             (exde_tipo_peri in ('D', 'M') and
             p_fech_emis between exde_fech_desd and exde_fech_hast) or
             (exde_tipo_peri = 'H' and
             p_fech_emis_hora between exde_fech_desd and exde_fech_hast))
         and exde_esta = 'A'
         and (exde_pres_codi is null or
             (exde_pres_codi is not null and i_s_pres_codi is not null and
             exde_pres_codi = i_s_pres_codi))
       order by exde_codi;
  
  begin
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
                                 nvl(i_movi_tasa_come, i_movi_tasa_mone),
                                 i_movi_mone_cant_deci);
          else
            v_exde_impo := round(v_exde_impo /
                                 nvl(i_movi_tasa_come, i_movi_tasa_mone),
                                 i_movi_mone_cant_deci);
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
  
  end pp_busca_exce_deto_fp_impo;

  procedure pp_busca_exce_deto_prod(p_clpr_codi           in number,
                                    p_prod_codi           in number,
                                    p_lipr_codi           in number,
                                    p_orte_codi           in number,
                                    p_segm_codi           in number,
                                    p_fech_emis           in date,
                                    p_mone_codi           in number,
                                    i_movi_tasa_come      in number,
                                    i_movi_mone_cant_deci in number,
                                    i_s_pres_codi         in number,
                                    --
                                    p_exde_codi out number,
                                    p_deto_prec out char,
                                    p_exde_tipo out char,
                                    p_exde_peri out char,
                                    p_exde_porc out number,
                                    p_exde_impo out number) is
  
    v_exde_codi      number;
    v_exde_tipo      char(1) := 'N';
    v_exde_form      char(1) := '';
    v_exde_porc      number;
    v_exde_impo      number;
    v_deto_prec      char(1) := 'N'; -- si es importe o porcentaje
    v_exde_tipo_peri char(1);
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
            --and (exde_mone_codi is null or exde_mone_codi = p_mone_codi)
         and exde_esta = 'A'
         and (exde_pres_codi is null or
             (exde_pres_codi is not null and i_s_pres_codi is not null and
             exde_pres_codi = i_s_pres_codi));
  
  begin
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
            v_exde_impo := round(v_exde_impo * i_movi_tasa_come,
                                 parameter.p_cant_deci_mmnn);
          else
            v_exde_impo := round(v_exde_impo / i_movi_tasa_come,
                                 i_movi_mone_cant_deci);
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
  
  end pp_busca_exce_deto_prod;

  procedure pp_busca_exce_deto_cant(p_clpr_codi           in number,
                                    p_prod_codi           in number,
                                    p_lipr_codi           in number,
                                    p_orte_codi           in number,
                                    p_segm_codi           in number,
                                    p_fech_emis           in date,
                                    p_mone_codi           in number,
                                    i_s_pres_codi         in number,
                                    i_movi_tasa_come      in number,
                                    i_movi_mone_cant_deci in number,
                                    p_exde_cant_fact      in number,
                                    --
                                    
                                    p_exde_codi out number,
                                    p_deto_prec out char,
                                    p_exde_tipo out char,
                                    p_exde_peri out char,
                                    p_exde_porc out number,
                                    p_exde_impo out number) is
  
    v_exde_codi      number;
    v_exde_tipo      char(1) := 'N';
    v_exde_form      char(1) := '';
    v_exde_porc      number;
    v_exde_impo      number;
    v_deto_prec      char(1) := 'N'; -- si es importe o porcentaje
    v_exde_tipo_peri char(1);
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
             (exde_pres_codi is not null and i_s_pres_codi is not null and
             exde_pres_codi = i_s_pres_codi));
  
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
                                 nvl(i_movi_tasa_come,
                                     1 /*i_movi_tasa_mone*/),
                                 parameter.p_cant_deci_mmnn);
          else
            v_exde_impo := round(v_exde_impo /
                                 nvl(i_movi_tasa_come,
                                     1 /*i_movi_tasa_mone*/),
                                 i_movi_mone_cant_deci);
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

  procedure pp_busca_exce_deto_obse(p_clpr_codi           in number,
                                    p_prod_codi           in number,
                                    p_fech_emis           in date,
                                    p_mone_codi           in number,
                                    p_exde_cant_fact      in number,
                                    p_exde_medi_codi      in number,
                                    i_movi_tasa_come      in number,
                                    i_movi_mone_cant_deci in number,
                                    i_s_pres_codi         in number,
                                    
                                    --
                                    p_exde_codi out number,
                                    p_deto_prec out char,
                                    p_exde_tipo out char,
                                    p_exde_peri out char,
                                    p_exde_porc out number,
                                    p_exde_impo out number) is
  
    v_exde_codi      number;
    v_exde_tipo      char(1) := 'N';
    v_exde_form      char(1) := '';
    v_exde_porc      number;
    v_exde_impo      number;
    v_deto_prec      char(1) := 'N'; -- si es importe o porcentaje
    v_exde_tipo_peri char(1);
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
             (exde_pres_codi is not null and i_s_pres_codi is not null and
             exde_pres_codi = i_s_pres_codi));
  
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
                                 nvl(i_movi_tasa_come,
                                     1 /*i_movi_tasa_mone*/),
                                 parameter.p_cant_deci_mmnn);
          else
            v_exde_impo := round(v_exde_impo /
                                 nvl(i_movi_tasa_come,
                                     1 /*i_movi_tasa_mone*/),
                                 i_movi_mone_cant_deci);
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

  procedure pp_busca_nume_movi is
  
    v_existe    varchar2(1) := 'N';
    v_movi_nume number;
    v_cant      number := 0;
  
  begin
    v_movi_nume := bcab.movi_nume;
  
    while v_existe = 'N' loop
      begin
        select count(*) --movi_nume
          into v_cant
          from come_movi
         where movi_nume = v_movi_nume --p_nume
           and movi_timo_codi in
               (select timo_codi
                  from come_tipo_movi
                 where timo_codi_oper = parameter.p_codi_oper_vta
                   and nvl(timo_calc_iva, 'N') = 'N');
      
        if v_cant > 0 then
          v_movi_nume := v_movi_nume + 1;
          v_existe    := 'N';
        else
          v_existe := 'S';
        end if;
      end;
    end loop;
    bcab.movi_nume := v_movi_nume;
  
  exception
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_traer_desc_conce(p_codi      in number,
                                p_desc      out varchar2,
                                p_impu      out number,
                                p_conc_dbcr out varchar2) is
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
      raise_application_error(-20010,
                              'No puede seleccionar un concepto de IVA');
    end loop;
  
    select conc_desc, conc_dbcr, conc_impu_codi
      into p_desc, p_conc_dbcr, p_impu
      from come_conc
     where conc_codi = p_codi
       and nvl(conc_indi_fact, 'N') = 'S';
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Concepto inexistente o no es facturable!');
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_traer_datos_codi_barr(p_prod_codi in number,
                                     p_medi_codi out number,
                                     p_codi_barr in varchar2,
                                     p_fact_conv out number) is
  begin
  
    select d.coba_fact_conv, coba_medi_codi
      into p_fact_conv, p_medi_codi
      from come_prod_coba_deta d
     where d.coba_codi_barr = p_codi_barr
       and d.coba_prod_codi = p_prod_codi;
  
  exception
    when no_data_found then
      p_medi_codi := null;
      p_fact_conv := null;
    when too_many_rows then
      begin
        select d.coba_fact_conv, d.coba_medi_codi
          into p_fact_conv, p_medi_codi
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
      raise_application_error(-20010,
                              'Error al momento de traer Cod. Barra: ' ||
                              sqlerrm);
  end;

  /*********************** inserciones ********************************/
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
                                p_movi_orte_codi           in number,
                                p_movi_form_entr_codi      in number,
                                p_movi_sub_clpr_codi       in number,
                                p_movi_indi_cobr_dife      in varchar2,
                                p_movi_nume_timb           in varchar2,
                                p_MOVI_NUME_AUTO_IMPR      in varchar2,
                                
                                p_movi_fech_venc_timb in date,
                                p_movi_fech_inic_timb in date,
                                
                                p_movi_indi_entr_depo      in char,
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
                                p_movi_inve_codi           in number,
                                p_movi_indi_diar           in varchar2,
                                p_movi_indi_cant_diar      in varchar2,
                                p_movi_indi_most_fech      in varchar2,
                                p_movi_clpr_sucu_nume_item in number,
                                p_movi_nume_oc             in number) is
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
       movi_orte_codi,
       movi_base,
       movi_form_entr_codi,
       movi_sub_clpr_codi,
       movi_indi_cobr_dife,
       movi_nume_timb,
       MOVI_NUME_AUTO_IMPR,
       movi_fech_venc_timb,
       movi_Fech_inic_timb,
       movi_indi_entr_depo,
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
       movi_inve_codi,
       movi_indi_diar,
       movi_indi_cant_diar,
       movi_indi_most_fech,
       movi_clpr_sucu_nume_item,
       movi_nume_oc)
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
       p_movi_orte_codi,
       parameter.p_codi_base,
       p_movi_form_entr_codi,
       p_movi_sub_clpr_codi,
       p_movi_indi_cobr_dife,
       p_movi_nume_timb,
       p_MOVI_NUME_AUTO_IMPR,
       p_movi_fech_venc_timb,
       p_movi_fech_inic_timb,
       
       p_movi_indi_entr_depo,
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
       p_movi_inve_codi,
       p_movi_indi_diar,
       p_movi_indi_cant_diar,
       p_movi_indi_most_fech,
       p_movi_clpr_sucu_nume_item,
       p_movi_nume_oc);
  
  end;

  procedure pp_insert_come_movi_prod_deta(p_deta_movi_codi           in number,
                                          p_deta_nume_item           in number,
                                          p_deta_impu_codi           in number,
                                          p_deta_prod_codi           in number,
                                          p_deta_cant                in number,
                                          p_deta_obse                in varchar2,
                                          p_deta_porc_deto           in number,
                                          p_deta_impo_mone           in number,
                                          p_deta_impo_mmnn           in number,
                                          p_deta_impo_mmee           in number,
                                          p_deta_iva_mmnn            in number,
                                          p_deta_iva_mmee            in number,
                                          p_deta_iva_mone            in number,
                                          p_deta_prec_unit           in number,
                                          p_deta_movi_codi_padr      in number,
                                          p_deta_nume_item_padr      in number,
                                          p_deta_impo_mone_deto_nc   in number,
                                          p_deta_movi_codi_deto_nc   in number,
                                          p_deta_list_codi           in number,
                                          p_deta_lote_codi           in number,
                                          p_deta_cant_medi           in number,
                                          p_deta_medi_codi           in number,
                                          p_deta_remi_codi           in number,
                                          p_deta_remi_nume_item      in number,
                                          p_deta_prec_unit_list      in number,
                                          p_deta_impo_deto_mone      in number,
                                          p_deta_porc_deto_prec      in number,
                                          p_deta_impo_mone_ii        in number,
                                          p_deta_impo_mmnn_ii        in number,
                                          p_deta_grav10_ii_mone      in number,
                                          p_deta_grav5_ii_mone       in number,
                                          p_deta_grav10_ii_mmnn      in number,
                                          p_deta_grav5_ii_mmnn       in number,
                                          p_deta_grav10_mone         in number,
                                          p_deta_grav5_mone          in number,
                                          p_deta_grav10_mmnn         in number,
                                          p_deta_grav5_mmnn          in number,
                                          p_deta_iva10_mone          in number,
                                          p_deta_iva5_mone           in number,
                                          p_deta_iva10_mmnn          in number,
                                          p_deta_iva5_mmnn           in number,
                                          p_deta_exen_mone           in number,
                                          p_deta_exen_mmnn           in number,
                                          p_deta_exde_codi           in number,
                                          p_deta_exde_tipo           in varchar2,
                                          p_deta_prod_codi_barr      in varchar2,
                                          p_deta_prod_prec_maxi_deto in number,
                                          p_deta_prec_maxi_deto_exce in number) is
  begin
    insert into come_movi_prod_deta
      (deta_movi_codi,
       deta_nume_item,
       deta_impu_codi,
       deta_prod_codi,
       deta_cant,
       deta_obse,
       deta_porc_deto,
       deta_impo_mone,
       deta_impo_mmnn,
       deta_impo_mmee,
       deta_iva_mmnn,
       deta_iva_mmee,
       deta_iva_mone,
       deta_prec_unit,
       deta_movi_codi_padr,
       deta_nume_item_padr,
       deta_impo_mone_deto_nc,
       deta_movi_codi_deto_nc,
       deta_list_codi,
       deta_lote_codi,
       deta_cant_medi,
       deta_medi_codi,
       deta_remi_codi,
       deta_remi_nume_item,
       deta_prec_unit_list,
       deta_impo_deto_mone,
       deta_porc_deto_prec,
       deta_impo_mone_ii,
       deta_impo_mmnn_ii,
       deta_grav10_ii_mone,
       deta_grav5_ii_mone,
       deta_grav10_ii_mmnn,
       deta_grav5_ii_mmnn,
       deta_grav10_mone,
       deta_grav5_mone,
       deta_grav10_mmnn,
       deta_grav5_mmnn,
       deta_iva10_mone,
       deta_iva5_mone,
       deta_iva10_mmnn,
       deta_iva5_mmnn,
       deta_exen_mone,
       deta_exen_mmnn,
       deta_exde_codi,
       deta_exde_tipo,
       deta_prod_codi_barr,
       deta_prod_prec_maxi_deto,
       deta_prod_prec_maxi_deto_exce,
       deta_base)
    values
      (p_deta_movi_codi,
       p_deta_nume_item,
       p_deta_impu_codi,
       p_deta_prod_codi,
       p_deta_cant,
       p_deta_obse,
       p_deta_porc_deto,
       p_deta_impo_mone,
       p_deta_impo_mmnn,
       p_deta_impo_mmee,
       p_deta_iva_mmnn,
       p_deta_iva_mmee,
       p_deta_iva_mone,
       p_deta_prec_unit,
       p_deta_movi_codi_padr,
       p_deta_nume_item_padr,
       p_deta_impo_mone_deto_nc,
       p_deta_movi_codi_deto_nc,
       p_deta_list_codi,
       p_deta_lote_codi,
       p_deta_cant_medi,
       p_deta_medi_codi,
       p_deta_remi_codi,
       p_deta_remi_nume_item,
       p_deta_prec_unit_list,
       p_deta_impo_deto_mone,
       p_deta_porc_deto_prec,
       p_deta_impo_mone_ii,
       p_deta_impo_mmnn_ii,
       p_deta_grav10_ii_mone,
       p_deta_grav5_ii_mone,
       p_deta_grav10_ii_mmnn,
       p_deta_grav5_ii_mmnn,
       p_deta_grav10_mone,
       p_deta_grav5_mone,
       p_deta_grav10_mmnn,
       p_deta_grav5_mmnn,
       p_deta_iva10_mone,
       p_deta_iva5_mone,
       p_deta_iva10_mmnn,
       p_deta_iva5_mmnn,
       p_deta_exen_mone,
       p_deta_exen_mmnn,
       p_deta_exde_codi,
       p_deta_exde_tipo,
       p_deta_prod_codi_barr,
       p_deta_prod_prec_maxi_deto,
       p_deta_prec_maxi_deto_exce,
       parameter.p_codi_base);
    /* exception
    when others then
      pl_me(sqlerrm);*/
  end;

  procedure pp_insert_movi_conc_deta(p_moco_movi_codi      number,
                                     p_moco_nume_item      number,
                                     p_moco_conc_codi      number,
                                     p_moco_cuco_codi      number,
                                     p_moco_impu_codi      number,
                                     p_moco_impo_mmnn      number,
                                     p_moco_impo_mmee      number,
                                     p_moco_impo_mone      number,
                                     p_moco_dbcr           char,
                                     p_moco_desc           varchar2,
                                     p_moco_indi_fact_serv varchar2,
                                     p_moco_impo_mone_ii   in number,
                                     p_moco_cant           in number,
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
                                     p_moco_tipo           in char,
                                     p_moco_prod_codi      in number,
                                     p_moco_ortr_codi_fact in number,
                                     p_moco_sofa_sose_codi in number,
                                     p_moco_sofa_nume_item in number,
                                     p_moco_sofa_codi      in number,
                                     p_moco_empl_codi      in number,
                                     p_moco_anex_codi      in number,
                                     p_moco_impo_diar_mone in number,
                                     p_moco_ceco_codi      in number,
                                     p_moco_maqu_codi      in number) is
  
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
       moco_desc,
       moco_indi_fact_serv,
       moco_impo_mone_ii,
       moco_cant,
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
       moco_prod_codi,
       moco_ortr_codi_fact,
       moco_sofa_sose_codi,
       moco_sofa_nume_item,
       moco_sofa_codi,
       moco_empl_codi,
       moco_anex_codi,
       moco_impo_diar_mone,
       moco_ceco_codi,
       moco_base,
       moco_maqu_codi)
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
       p_moco_desc,
       p_moco_indi_fact_serv,
       p_moco_impo_mone_ii,
       p_moco_cant,
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
       p_moco_prod_codi,
       p_moco_ortr_codi_fact,
       p_moco_sofa_sose_codi,
       p_moco_sofa_nume_item,
       p_moco_sofa_codi,
       p_moco_empl_codi,
       p_moco_anex_codi,
       p_moco_impo_diar_mone,
       p_moco_ceco_codi,
       parameter.p_codi_base,
       p_moco_maqu_codi);
  
    /*exception
    when others then
      raise_application_error(-20010, sqlerrm);*/
  end;

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
                                          p_moim_grav10_ii_mmnn in number,
                                          p_moim_grav5_ii_mone  in number,
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
       moim_grav10_ii_mmnn,
       moim_grav5_ii_mone,
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
       moim_exen_mmnn,
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
       p_moim_tiim_codi,
       p_moim_impo_mone_ii,
       p_moim_impo_mmnn_ii,
       p_moim_grav10_ii_mone,
       p_moim_grav10_ii_mmnn,
       p_moim_grav5_ii_mone,
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
       p_moim_exen_mmnn,
       parameter.p_codi_base);
  
  exception
    when others then
      raise_application_error(-20010, sqlerrm);
  end;

  procedure pp_insert_come_movi_ortr_deta(p_deta_movi_codi      in number,
                                          p_deta_nume_item      in number,
                                          p_deta_ortr_codi      in number,
                                          p_deta_impu_codi      in number,
                                          p_deta_cant           in number,
                                          p_deta_porc_deto      in number,
                                          p_deta_impo_mone      in number,
                                          p_deta_impo_mmnn      in number,
                                          p_deta_impo_mmee      in number,
                                          p_deta_iva_mone       in number,
                                          p_deta_iva_mmnn       in number,
                                          p_deta_iva_mmee       in number,
                                          p_deta_prec_unit      in number,
                                          p_deta_movi_codi_padr in number,
                                          p_deta_nume_item_padr in number,
                                          p_deta_obse           in varchar2,
                                          p_deta_impo_mone_ii   in number,
                                          p_deta_impo_mmnn_ii   in number,
                                          p_deta_grav10_ii_mone in number,
                                          p_deta_grav5_ii_mone  in number,
                                          p_deta_grav10_ii_mmnn in number,
                                          p_deta_grav5_ii_mmnn  in number,
                                          p_deta_grav10_mone    in number,
                                          p_deta_grav5_mone     in number,
                                          p_deta_grav10_mmnn    in number,
                                          p_deta_grav5_mmnn     in number,
                                          p_deta_iva10_mone     in number,
                                          p_deta_iva5_mone      in number,
                                          p_deta_iva10_mmnn     in number,
                                          p_deta_iva5_mmnn      in number,
                                          p_deta_exen_mone      in number,
                                          p_deta_exen_mmnn      in number) is
  
  begin
    insert into come_movi_ortr_deta
      (deta_movi_codi,
       deta_nume_item,
       deta_ortr_codi,
       deta_impu_codi,
       deta_cant,
       deta_porc_deto,
       deta_impo_mone,
       deta_impo_mmnn,
       deta_impo_mmee,
       deta_iva_mone,
       deta_iva_mmnn,
       deta_iva_mmee,
       deta_prec_unit,
       deta_movi_codi_padr,
       deta_nume_item_padr,
       deta_obse,
       deta_impo_mone_ii,
       deta_impo_mmnn_ii,
       deta_grav10_ii_mone,
       deta_grav5_ii_mone,
       deta_grav10_ii_mmnn,
       deta_grav5_ii_mmnn,
       deta_grav10_mone,
       deta_grav5_mone,
       deta_grav10_mmnn,
       deta_grav5_mmnn,
       deta_iva10_mone,
       deta_iva5_mone,
       deta_iva10_mmnn,
       deta_iva5_mmnn,
       deta_exen_mone,
       deta_exen_mmnn,
       deta_base)
    values
      (p_deta_movi_codi,
       p_deta_nume_item,
       p_deta_ortr_codi,
       p_deta_impu_codi,
       p_deta_cant,
       p_deta_porc_deto,
       p_deta_impo_mone,
       p_deta_impo_mmnn,
       p_deta_impo_mmee,
       p_deta_iva_mone,
       p_deta_iva_mmnn,
       p_deta_iva_mmee,
       p_deta_prec_unit,
       p_deta_movi_codi_padr,
       p_deta_nume_item_padr,
       p_deta_obse,
       p_deta_impo_mone_ii,
       p_deta_impo_mmnn_ii,
       p_deta_grav10_ii_mone,
       p_deta_grav5_ii_mone,
       p_deta_grav10_ii_mmnn,
       p_deta_grav5_ii_mmnn,
       p_deta_grav10_mone,
       p_deta_grav5_mone,
       p_deta_grav10_mmnn,
       p_deta_grav5_mmnn,
       p_deta_iva10_mone,
       p_deta_iva5_mone,
       p_deta_iva10_mmnn,
       p_deta_iva5_mmnn,
       p_deta_exen_mone,
       p_deta_exen_mmnn,
       parameter.p_codi_base);
  
  exception
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end;

  procedure pp_ABM_deta(i_indi                in varchar2,
                        i_seq                 in number,
                        i_indi_prod_ort       in varchar2,
                        i_deta_prod_codi      in number,
                        i_deta_prod_desc      in varchar2,
                        i_coba_codi_barr      in varchar2,
                        i_deta_medi_codi      in number,
                        i_deta_cant_medi      in number,
                        i_deta_prec_unit      in number,
                        i_deta_porc_deto      in number,
                        i_deta_lote_codi      in number,
                        i_s_prec_maxi_deto    in number,
                        i_deta_prec_unit_neto in number,
                        i_moco_impo_diar_mone in number) is
  
    v_prod_codi_alfa come_prod.prod_codi_alfa%type;
    v_medi_desc      come_unid_medi.medi_desc%type;
    v_maxi_porc_desc number;
    v_seq_exis       number;
  
  begin
  
  --raise_application_error(-20010, i_coba_codi_barr);
  
    I020168.pp_set_variable_deta;
  
    begin
      -- calculamos el importe
      I020168.pp_calcular_importe_item;
    end;
  
    if i_indi = 'N' then
    
      if i_indi_prod_ort = 'P' then
      
        select prod_codi_alfa
          into v_prod_codi_alfa
          from come_prod
         where prod_codi = i_deta_prod_codi;
      
        select t.medi_desc
          into v_medi_desc
          from come_unid_medi t
         where medi_codi = i_deta_medi_codi;
      
        begin
          select taax_seq
            into v_seq_exis
            from come_tabl_auxi k
           where k.taax_n001 = i_deta_prod_codi
             and k.taax_c005 = i_coba_codi_barr
             and taax_sess = p_sess
             and taax_user = gen_user
             and taax_c050 = 'FACT_DETA';
        exception
          when no_data_found then
            null;
          when others then
            raise_application_error(-20010,
                                    'Error, comiuncarse con el departamento de Informática. Error: #21');
        end;
      
      elsif i_indi_prod_ort = 'S' then
      
        select conc_codi
          into v_prod_codi_alfa
          from come_conc
         where conc_codi = i_deta_prod_codi;
      
      end if;
    
      --verificamos que el registros exista o no previamente, si existe lo adjuntamos.
      if v_seq_exis is not null then
        update come_tabl_auxi
           set taax_c001 = i_indi_prod_ort, --Indi,
               taax_c002 = i_deta_prod_desc, --descripcion,
               taax_c003 = v_medi_desc, --um_Desc,
               taax_c004 = v_prod_codi_alfa, --codigo alfa
               taax_n001 = i_deta_prod_codi, --codigo,
               taax_c005 = i_coba_codi_barr, --codigo_barra,
               taax_n003 = i_deta_medi_codi, --um_codi,
               taax_n004 = nvl(taax_n004, 0) + nvl(i_deta_cant_medi, 0), --cant,
               taax_n005 = case
                             when nvl(taax_n005, 0) <>
                                  nvl(i_deta_prec_unit, 0) then
                              nvl(taax_n005, 0) + nvl(i_deta_prec_unit, 0)
                             else
                              nvl(i_deta_prec_unit, 0)
                           end, --precio_unit,
               taax_n006 = nvl(taax_n006, 0) + nvl(i_deta_porc_deto, 0), --porc_desc,
               
               /*taax_n007 = bdet.deta_impo_mone_ii,
               taax_n008 = bdet.s_descuento,
               taax_n009 = bdet.deta_impo_mmnn_ii,
               taax_n010 = bdet.deta_grav10_mone_ii,
               taax_n011 = bdet.deta_grav5_mone_ii,
               taax_n012 = bdet.deta_grav10_mone,
               taax_n013 = bdet.deta_grav5_mone,
               taax_n014 = bdet.deta_iva10_mone,
               taax_n015 = bdet.deta_iva5_mone,
               taax_n016 = bdet.deta_exen_mone,
               taax_n017 = bdet.deta_grav10_mmnn_ii,
               taax_n018 = bdet.deta_grav5_mmnn_ii,
               taax_n019 = bdet.deta_grav10_mmnn,
               taax_n020 = bdet.deta_grav5_mmnn,
               taax_n021 = bdet.deta_iva10_mmnn,
               taax_n022 = bdet.deta_iva5_mmnn,
               taax_n023 = bdet.deta_exen_mmnn,
               taax_n024 = bdet.deta_impo_mmnn,
               taax_n025 = bdet.deta_impo_mone,
               taax_n026 = bdet.deta_iva_mmnn,
               taax_n027 = bdet.deta_iva_mone,*/
               
               taax_n007 = nvl(taax_n007, 0) +
                           nvl(bdet.deta_impo_mone_ii, 0),
               taax_n008 = nvl(taax_n008, 0) + nvl(bdet.s_descuento, 0),
               taax_n009 = nvl(taax_n009, 0) +
                           nvl(bdet.deta_impo_mmnn_ii, 0),
               taax_n010 = nvl(taax_n010, 0) +
                           nvl(bdet.deta_grav10_mone_ii, 0),
               taax_n011 = nvl(taax_n011, 0) +
                           nvl(bdet.deta_grav5_mone_ii, 0),
               taax_n012 = nvl(taax_n012, 0) + nvl(bdet.deta_grav10_mone, 0),
               taax_n013 = nvl(taax_n013, 0) + nvl(bdet.deta_grav5_mone, 0),
               taax_n014 = nvl(taax_n014, 0) + nvl(bdet.deta_iva10_mone, 0),
               taax_n015 = nvl(taax_n015, 0) + nvl(bdet.deta_iva5_mone, 0),
               taax_n016 = nvl(taax_n016, 0) + nvl(bdet.deta_exen_mone, 0),
               taax_n017 = nvl(taax_n017, 0) +
                           nvl(bdet.deta_grav10_mmnn_ii, 0),
               taax_n018 = nvl(taax_n018, 0) +
                           nvl(bdet.deta_grav5_mmnn_ii, 0),
               taax_n019 = nvl(taax_n019, 0) + nvl(bdet.deta_grav10_mmnn, 0),
               taax_n020 = nvl(taax_n020, 0) + nvl(bdet.deta_grav5_mmnn, 0),
               taax_n021 = nvl(taax_n021, 0) + nvl(bdet.deta_iva10_mmnn, 0),
               taax_n022 = nvl(taax_n022, 0) + nvl(bdet.deta_iva5_mmnn, 0),
               taax_n023 = nvl(taax_n023, 0) + nvl(bdet.deta_exen_mmnn, 0),
               taax_n024 = nvl(taax_n024, 0) + nvl(bdet.deta_impo_mmnn, 0),
               taax_n025 = nvl(taax_n025, 0) + nvl(bdet.deta_impo_mone, 0),
               taax_n026 = nvl(taax_n026, 0) + nvl(bdet.deta_iva_mmnn, 0),
               taax_n027 = nvl(taax_n027, 0) + nvl(bdet.deta_iva_mone, 0),
               
               taax_n028 = bdet.coba_fact_conv,
               taax_n029 = i_deta_lote_codi,
               taax_c006 = bdet.prod_indi_fact_nega,
               taax_c030 = bdet.deta_impu_codi,
               taax_c031 = bdet.deta_prec_unit_list,
               taax_c007 = bdet.prod_indi_kitt,
               taax_n032 = bdet.deta_prod_prec_maxi_deto,
               taax_n033 = bdet.deta_prod_prec_maxi_deto_exen,
               taax_n034 = bdet.deta_empl_codi
         where taax_seq = v_seq_exis;
      
      else
        insert into come_tabl_auxi
          (taax_sess,
           taax_user,
           taax_seq,
           taax_c050,
           taax_c001, --Indi,
           taax_c002, --descripcion,
           taax_c003, --um_Desc,
           taax_c004, --codigo alfa
           taax_n001, --codigo,
           taax_c005, --codigo_barra,
           taax_n003, --um_codi,
           taax_n004, --cant,
           taax_n005, --precio_unit,
           taax_n006, --porc_desc,            
           taax_n007, --total_item         
           taax_n008,
           taax_n009,
           taax_n010,
           taax_n011,
           taax_n012,
           taax_n013,
           taax_n014,
           taax_n015,
           taax_n016,
           taax_n017,
           taax_n018,
           taax_n019,
           taax_n020,
           taax_n021,
           taax_n022,
           taax_n023,
           taax_n024,
           taax_n025,
           taax_n026,
           taax_n027,
           taax_n028,
           taax_n029,
           taax_c006,
           taax_n030,
           taax_n031,
           
           taax_c007,
           taax_n032,
           taax_n033,
           taax_n034)
        values
          (p_sess,
           gen_user,
           seq_come_tabl_auxi.nextval,
           'FACT_DETA',
           i_indi_prod_ort,
           i_deta_prod_desc,
           v_medi_desc,
           v_prod_codi_alfa,
           i_deta_prod_codi,
           i_coba_codi_barr,
           i_deta_medi_codi,
           i_deta_cant_medi,
           i_deta_prec_unit,
           i_deta_porc_deto,
           bdet.deta_impo_mone_ii,
           bdet.s_descuento,
           bdet.deta_impo_mmnn_ii,
           bdet.deta_grav10_mone_ii,
           bdet.deta_grav5_mone_ii,
           bdet.deta_grav10_mone,
           bdet.deta_grav5_mone,
           bdet.deta_iva10_mone,
           bdet.deta_iva5_mone,
           bdet.deta_exen_mone,
           bdet.deta_grav10_mmnn_ii,
           bdet.deta_grav5_mmnn_ii,
           bdet.deta_grav10_mmnn,
           bdet.deta_grav5_mmnn,
           bdet.deta_iva10_mmnn,
           bdet.deta_iva5_mmnn,
           bdet.deta_exen_mmnn,
           bdet.deta_impo_mmnn,
           bdet.deta_impo_mone,
           bdet.deta_iva_mmnn,
           bdet.deta_iva_mone,
           bdet.coba_fact_conv,
           i_deta_lote_codi,
           bdet.prod_indi_fact_nega,
           bdet.deta_impu_codi,
           bdet.deta_prec_unit_list,
           bdet.prod_indi_kitt,
           bdet.deta_prod_prec_maxi_deto,
           bdet.deta_prod_prec_maxi_deto_exen,
           bdet.deta_empl_codi);
      end if;
    
    elsif i_indi = 'D' then
    
      delete from come_tabl_auxi where taax_seq = i_seq;
    
    elsif i_indi = 'U' then
    
      if i_indi_prod_ort = 'P' then
      
        select prod_codi_alfa
          into v_prod_codi_alfa
          from come_prod
         where prod_codi = i_deta_prod_codi;
      
        select t.medi_desc
          into v_medi_desc
          from come_unid_medi t
         where medi_codi = i_deta_medi_codi;
      
      elsif i_indi_prod_ort = 'S' then
      
        select conc_codi
          into v_prod_codi_alfa
          from come_conc
         where conc_codi = i_deta_prod_codi;
      
      end if;
    
      update come_tabl_auxi
         set taax_c001 = i_indi_prod_ort, --Indi,
             taax_c002 = i_deta_prod_desc, --descripcion,
             taax_c003 = v_medi_desc, --um_Desc,
             taax_c004 = v_prod_codi_alfa, --codigo alfa
             taax_n001 = i_deta_prod_codi, --codigo,
             taax_c005 = i_coba_codi_barr, --codigo_barra,
             taax_n003 = i_deta_medi_codi, --um_codi,
             taax_n004 = i_deta_cant_medi, --cant,
             taax_n005 = i_deta_prec_unit, --precio_unit,
             taax_n006 = i_deta_porc_deto, --porc_desc,
             
             taax_n007 = bdet.deta_impo_mone_ii,
             taax_n008 = bdet.s_descuento,
             taax_n009 = bdet.deta_impo_mmnn_ii,
             taax_n010 = bdet.deta_grav10_mone_ii,
             taax_n011 = bdet.deta_grav5_mone_ii,
             taax_n012 = bdet.deta_grav10_mone,
             taax_n013 = bdet.deta_grav5_mone,
             taax_n014 = bdet.deta_iva10_mone,
             taax_n015 = bdet.deta_iva5_mone,
             taax_n016 = bdet.deta_exen_mone,
             taax_n017 = bdet.deta_grav10_mmnn_ii,
             taax_n018 = bdet.deta_grav5_mmnn_ii,
             taax_n019 = bdet.deta_grav10_mmnn,
             taax_n020 = bdet.deta_grav5_mmnn,
             taax_n021 = bdet.deta_iva10_mmnn,
             taax_n022 = bdet.deta_iva5_mmnn,
             taax_n023 = bdet.deta_exen_mmnn,
             taax_n024 = bdet.deta_impo_mmnn,
             taax_n025 = bdet.deta_impo_mone,
             taax_n026 = bdet.deta_iva_mmnn,
             taax_n027 = bdet.deta_iva_mone,
             taax_n028 = bdet.coba_fact_conv,
             taax_n029 = i_deta_lote_codi,
             taax_c006 = bdet.prod_indi_fact_nega,
             taax_c030 = bdet.deta_impu_codi,
             taax_c031 = bdet.deta_prec_unit_list,
             taax_c007 = bdet.prod_indi_kitt,
             taax_n032 = bdet.deta_prod_prec_maxi_deto,
             taax_n033 = bdet.deta_prod_prec_maxi_deto_exen,
             taax_n034 = bdet.deta_empl_codi
       where taax_seq = i_seq;
    
    end if;
  exception
    when others then
      raise_application_error(-20010,
                              sqlerrm || ' =>' || i_deta_medi_codi || ' ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  end pp_ABM_deta;

  procedure pp_ajustar_importes is
    v_movi_impo_mmnn_ii       number := 0;
    v_sum_deta_impo_mmnn_ii   number := 0;
    v_movi_exen_mmnn          number := 0;
    v_sum_deta_exen_mmnn      number := 0;
    v_movi_grav10_ii_mmnn     number := 0;
    v_sum_deta_grav10_ii_mmnn number := 0;
    v_movi_grav5_ii_mmnn      number := 0;
    v_sum_deta_grav5_ii_mmnn  number := 0;
    v_movi_iva10_mmnn         number := 0;
    v_sum_deta_iva10_mmnn     number := 0;
    v_movi_iva5_mmnn          number := 0;
    v_sum_deta_iva5_mmnn      number := 0;
    v_movi_grav10_mmnn        number := 0;
    v_sum_deta_grav10_mmnn    number := 0;
    v_movi_grav5_mmnn         number := 0;
    v_sum_deta_grav5_mmnn     number := 0;
    v_nro_item                number := 0;
    v_movi_exen_mone          number := 0;
    v_sum_deta_exen_mone      number := 0;
    v_movi_grav10_ii_mone     number := 0;
    v_sum_deta_grav10_ii_mone number := 0;
    v_movi_grav5_ii_mone      number := 0;
    v_sum_deta_grav5_ii_mone  number := 0;
    v_movi_iva10_mone         number := 0;
    v_sum_deta_iva10_mone     number := 0;
    v_movi_iva5_mone          number := 0;
    v_sum_deta_iva5_mone      number := 0;
    v_movi_grav10_mone        number := 0;
    v_sum_deta_grav10_mone    number := 0;
    v_movi_grav5_mone         number := 0;
    v_sum_deta_grav5_mone     number := 0;
  
    v_item_mayor number := 0;
    v_impo_mayor number := 0;
  begin
  
    v_impo_mayor := bdet.deta_impo_mone_ii;
    v_item_mayor := 1;
  
    i020168.pp_calcular_importe_cab;
  
    v_movi_exen_mone     := bcab.movi_exen_mone;
    v_sum_deta_exen_mone := bdet.sum_deta_exen_mone;
  
    if v_movi_exen_mone <> v_sum_deta_exen_mone then
      bdet.deta_exen_mone := bdet.deta_exen_mone +
                             (v_movi_exen_mone - v_sum_deta_exen_mone);
      bdet.deta_impo_mone := bdet.deta_exen_mone + bdet.deta_grav10_mone +
                             bdet.deta_grav5_mone;
    end if;
  
    v_movi_grav10_ii_mone     := bcab.movi_grav10_ii_mone;
    v_sum_deta_grav10_ii_mone := bdet.sum_deta_grav10_mone_ii;
  
    if v_movi_grav10_ii_mone <> v_sum_deta_grav10_ii_mone then
      bdet.deta_grav10_mone_ii := bdet.deta_grav10_mone_ii +
                                  (v_movi_grav10_ii_mone -
                                  v_sum_deta_grav10_ii_mone);
    end if;
  
    v_movi_grav5_ii_mone     := bcab.movi_grav5_ii_mone;
    v_sum_deta_grav5_ii_mone := bdet.sum_deta_grav5_mone_ii;
  
    if v_movi_grav5_ii_mone <> v_sum_deta_grav5_ii_mone then
      bdet.deta_grav5_mone_ii := bdet.deta_grav5_mone_ii +
                                 (v_movi_grav5_ii_mone -
                                 v_sum_deta_grav5_ii_mone);
    end if;
  
    v_movi_iva10_mone     := bcab.movi_iva10_mone;
    v_sum_deta_iva10_mone := bdet.sum_deta_iva10_mone;
  
    if v_movi_iva10_mone <> v_sum_deta_iva10_mone then
      bdet.deta_iva10_mone := bdet.deta_iva10_mone +
                              (v_movi_iva10_mone - v_sum_deta_iva10_mone);
      bdet.deta_iva_mone   := bdet.deta_iva10_mone + bdet.deta_iva5_mone;
    end if;
  
    v_movi_iva5_mone     := bcab.movi_iva5_mone;
    v_sum_deta_iva5_mone := bdet.sum_deta_iva5_mone;
  
    if v_movi_iva5_mone <> v_sum_deta_iva5_mone then
      bdet.deta_iva5_mone := bdet.deta_iva5_mone +
                             (v_movi_iva5_mone - v_sum_deta_iva5_mone);
      bdet.deta_iva_mone  := bdet.deta_iva10_mone + bdet.deta_iva5_mone;
    end if;
  
    v_movi_grav10_mone     := bcab.movi_grav10_mone;
    v_sum_deta_grav10_mone := bdet.sum_deta_grav10_mone;
  
    if v_movi_grav10_mone <> v_sum_deta_grav10_mone then
      bdet.deta_grav10_mone := bdet.deta_grav10_mone +
                               (v_movi_grav10_mone - v_sum_deta_grav10_mone);
      bdet.deta_impo_mone   := bdet.deta_exen_mone + bdet.deta_grav10_mone +
                               bdet.deta_grav5_mone;
    
    end if;
  
    v_movi_grav5_mone     := bcab.movi_grav5_mone;
    v_sum_deta_grav5_mone := bdet.sum_deta_grav5_mone;
  
    if v_movi_grav5_mone <> v_sum_deta_grav5_mone then
      bdet.deta_grav5_mone := bdet.deta_grav5_mone +
                              (v_movi_grav5_mone - v_sum_deta_grav5_mone);
      bdet.deta_impo_mone  := bdet.deta_exen_mone + bdet.deta_grav10_mone +
                              bdet.deta_grav5_mone;
    
    end if;
  
    v_movi_impo_mmnn_ii     := bcab.movi_impo_mmnn_ii;
    v_sum_deta_impo_mmnn_ii := bdet.sum_deta_impo_mmnn_ii;
  
    if v_movi_impo_mmnn_ii <> v_sum_deta_impo_mmnn_ii then
      bdet.deta_impo_mmnn_ii := bdet.deta_impo_mmnn_ii +
                                (v_movi_impo_mmnn_ii -
                                v_sum_deta_impo_mmnn_ii);
    end if;
  
    v_movi_exen_mmnn     := bcab.movi_exen_mmnn;
    v_sum_deta_exen_mmnn := bdet.sum_deta_exen_mmnn;
  
    if v_movi_exen_mmnn <> v_sum_deta_exen_mmnn then
      bdet.deta_exen_mmnn := bdet.deta_exen_mmnn +
                             (v_movi_exen_mmnn - v_sum_deta_exen_mmnn);
      bdet.deta_impo_mmnn := bdet.deta_exen_mmnn + bdet.deta_grav10_mmnn +
                             bdet.deta_grav5_mmnn;
    end if;
  
    v_movi_grav10_ii_mmnn     := bcab.movi_grav10_ii_mmnn;
    v_sum_deta_grav10_ii_mmnn := bdet.sum_deta_grav10_mmnn_ii;
  
    if v_movi_grav10_ii_mmnn <> v_sum_deta_grav10_ii_mmnn then
      bdet.deta_grav10_mmnn_ii := bdet.deta_grav10_mmnn_ii +
                                  (v_movi_grav10_ii_mmnn -
                                  v_sum_deta_grav10_ii_mmnn);
    end if;
  
    v_movi_grav5_ii_mmnn     := bcab.movi_grav5_ii_mmnn;
    v_sum_deta_grav5_ii_mmnn := bdet.sum_deta_grav5_mmnn_ii;
  
    if v_movi_grav5_ii_mmnn <> v_sum_deta_grav5_ii_mmnn then
      bdet.deta_grav5_mmnn_ii := bdet.deta_grav5_mmnn_ii +
                                 (v_movi_grav5_ii_mmnn -
                                 v_sum_deta_grav5_ii_mmnn);
    end if;
  
    v_movi_iva10_mmnn     := bcab.movi_iva10_mmnn;
    v_sum_deta_iva10_mmnn := bdet.sum_deta_iva10_mmnn;
  
    if v_movi_iva10_mmnn <> v_sum_deta_iva10_mmnn then
      bdet.deta_iva10_mmnn := bdet.deta_iva10_mmnn +
                              (v_movi_iva10_mmnn - v_sum_deta_iva10_mmnn);
      bdet.deta_iva_mmnn   := bdet.deta_iva10_mmnn + bdet.deta_iva5_mmnn;
    end if;
  
    v_movi_iva5_mmnn     := bcab.movi_iva5_mmnn;
    v_sum_deta_iva5_mmnn := bdet.sum_deta_iva5_mmnn;
  
    if v_movi_iva5_mmnn <> v_sum_deta_iva5_mmnn then
      bdet.deta_iva5_mmnn := bdet.deta_iva5_mmnn +
                             (v_movi_iva5_mmnn - v_sum_deta_iva5_mmnn);
    end if;
  
    v_movi_grav10_mmnn     := bcab.movi_grav10_mmnn;
    v_sum_deta_grav10_mmnn := bdet.sum_deta_grav10_mmnn;
  
    if v_movi_grav10_mmnn <> v_sum_deta_grav10_mmnn then
      bdet.deta_grav10_mmnn := bdet.deta_grav10_mmnn +
                               (v_movi_grav10_mmnn - v_sum_deta_grav10_mmnn);
      bdet.deta_impo_mmnn   := bdet.deta_exen_mmnn + bdet.deta_grav10_mmnn +
                               bdet.deta_grav5_mmnn;
    end if;
  
    v_movi_grav5_mmnn     := bcab.movi_grav5_mmnn;
    v_sum_deta_grav5_mmnn := bdet.sum_deta_grav5_mmnn;
  
    if v_movi_grav5_mmnn <> v_sum_deta_grav5_mmnn then
      bdet.deta_grav5_mmnn := bdet.deta_grav5_mmnn +
                              (v_movi_grav5_mmnn - v_sum_deta_grav5_mmnn);
      bdet.deta_impo_mmnn  := bdet.deta_exen_mmnn + bdet.deta_grav10_mmnn +
                              bdet.deta_grav5_mmnn;
    end if;
  
    bdet.deta_impo_mmnn := bdet.deta_exen_mmnn + bdet.deta_grav10_mmnn +
                           bdet.deta_grav5_mmnn;
    bdet.deta_impo_mone := bdet.deta_exen_mone + bdet.deta_grav10_mone +
                           bdet.deta_grav5_mone;
  
    bdet.deta_iva_mmnn := bdet.deta_iva10_mmnn + bdet.deta_iva5_mmnn;
    bdet.deta_iva_mone := bdet.deta_iva10_mone + bdet.deta_iva5_mone;
  
    parameter.p_ind_validar_det := 'S';
    parameter.p_indi_calc_impo  := 'N';
  
  end;

  procedure pp_asignar_valores is
    v_stoc_suma_rest      char(1);
    v_stoc_afec_cost_prom char(1);
  
  begin
  
    bcab.movi_codi      := fa_sec_come_movi;
    bcab.movi_oper_codi := parameter.p_codi_oper;
    bcab.movi_fech_grab := sysdate;
    bcab.movi_user      := gen_user;
    bcab.movi_empr_codi := p_empr_codi;
  
    pl_muestra_come_stoc_oper(parameter.p_codi_oper,
                              bcab.movi_oper_desc,
                              bcab.movi_oper_desc_abre,
                              bcab.movi_stoc_suma_rest,
                              bcab.movi_stoc_afec_cost_prom);
  
  end pp_asignar_valores;

  procedure pp_actualiza_cred_espe is
  begin
  
    if parameter.p_cres_nume_fact is not null then
    
      update come_clie_cred_espe
         set cres_nume_fact = parameter.p_cres_nume_fact,
             cres_fech_fact = parameter.p_cres_fech_fact,
             cres_user_fact = parameter.p_cres_user_fact,
             cres_esta      = 'F'
       where cres_clpr_codi = bcab.movi_clpr_codi
         and cres_esta = 'P'
         and (cres_pres_codi = bcab.s_pres_codi or cres_pres_codi is null);
    
    end if;
  
  end;

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
    v_movi_orte_codi           number;
    v_movi_form_entr_codi      number;
    v_movi_sub_clpr_codi       number;
    v_movi_indi_cobr_dife      varchar2(1);
    v_movi_nume_timb           varchar2(20);
    V_MOVI_NUME_AUTO_IMPR      varchar2(20);
    v_movi_fech_venc_timb      date;
    v_movi_fech_inic_timb      date;
    v_movi_indi_entr_depo      varchar2(1);
  
    v_movi_impo_mone_ii number;
    v_movi_impo_mmnn_ii number;
  
    v_movi_grav10_ii_mone number;
    v_movi_grav5_ii_mone  number;
    v_movi_grav10_ii_mmnn number;
    v_movi_grav5_ii_mmnn  number;
  
    v_movi_grav10_mone number;
    v_movi_grav5_mone  number;
    v_movi_grav10_mmnn number;
    v_movi_grav5_mmnn  number;
  
    v_movi_iva10_mone number;
    v_movi_iva5_mone  number;
    v_movi_iva10_mmnn number;
    v_movi_iva5_mmnn  number;
  
    v_movi_inve_codi           number;
    v_movi_indi_diar           varchar2(1);
    v_movi_indi_cant_diar      varchar2(1);
    v_movi_indi_most_fech      varchar2(1);
    v_movi_clpr_sucu_nume_item number;
    v_movi_nume_oc             number(20);
  
  begin
    --- asignar valores....
    bcab.movi_codi      := fa_sec_come_movi;
    bcab.movi_oper_codi := parameter.p_codi_oper;
    bcab.movi_fech_grab := sysdate;
    bcab.movi_user      := gen_user;
  
    pl_muestra_come_stoc_oper(parameter.p_codi_oper,
                              bcab.movi_oper_desc,
                              bcab.movi_oper_desc_abre,
                              bcab.movi_stoc_suma_rest,
                              bcab.movi_stoc_afec_cost_prom);
    v_movi_codi      := bcab.movi_codi;
    v_movi_timo_codi := bcab.movi_timo_codi;
  
    /*if parameter.p_indi_clie_pote = 'S' then
      pp_agregar_clie_pote(bcab.clpo_codi_alte, v_movi_clpr_codi);
      update come_clie_pote
         set clpo_esta = 'F'
       where clpo_codi = bcab.clpo_codi_alte;
    else
      v_movi_clpr_codi := bcab.movi_clpr_codi;
    end if;*/
  
    v_movi_clpr_codi := bcab.movi_clpr_codi;
  
    begin
      i020168.pp_actu_inve;
    end;
  
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig := bcab.movi_depo_codi_orig;
    v_movi_sucu_codi_dest := null;
    v_movi_depo_codi_dest := null;
    v_movi_oper_codi      := parameter.p_codi_oper;
    v_movi_cuen_codi      := null;
    v_movi_mone_codi      := bcab.movi_mone_codi;
    v_movi_nume           := bcab.movi_nume;
  
    --parameter.p_movi_nume      := bcab.movi_nume; --s_movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := bcab.movi_fech_grab;
    v_movi_user                := bcab.movi_user;
    v_movi_codi_padr           := null;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := null;
    v_movi_grav_mmnn           := bcab.movi_grav_mmnn;
    v_movi_exen_mmnn           := bcab.movi_exen_mmnn;
    v_movi_iva_mmnn            := bcab.movi_iva_mmnn;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := bcab.movi_grav_mone;
    v_movi_exen_mone           := bcab.movi_exen_mone;
    v_movi_iva_mone            := bcab.movi_iva_mone;
    v_movi_obse                := bcab.movi_obse;
    v_movi_sald_mmnn           := bcab.movi_sald_mmnn;
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := bcab.movi_sald_mone;
    v_movi_stoc_suma_rest      := bcab.movi_stoc_suma_rest;
    v_movi_clpr_dire           := bcab.movi_clpr_dire;
    v_movi_clpr_tele           := bcab.movi_clpr_tele;
    v_movi_clpr_ruc            := bcab.movi_clpr_ruc;
    v_movi_clpr_desc           := bcab.movi_clpr_desc;
    v_movi_emit_reci           := bcab.movi_emit_reci;
    v_movi_afec_sald           := bcab.movi_afec_sald;
    v_movi_dbcr                := bcab.movi_dbcr;
    v_movi_stoc_afec_cost_prom := bcab.movi_stoc_afec_cost_prom;
    v_movi_empr_codi           := bcab.movi_empr_codi;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := 'S';
    v_movi_empl_codi           := bcab.movi_empl_codi;
    v_movi_orte_codi           := bcab.movi_orte_codi;
    v_movi_form_entr_codi      := bcab.movi_form_entr_codi;
    v_movi_indi_cobr_dife      := bcab.movi_indi_cobr_dife;
    v_movi_nume_timb           := bcab.movi_nume_timb;
    V_MOVI_NUME_AUTO_IMPR      := bcab.MOVI_NUME_AUTO_IMPR;
    v_movi_fech_venc_timb      := bcab.fech_venc_timb;
    v_movi_fech_inic_timb      := bcab.fech_inic_timb;
  
    v_movi_indi_entr_depo := parameter.p_indi_entr_depo;
  
    v_movi_impo_mone_ii        := bcab.movi_impo_mone_ii;
    v_movi_impo_mmnn_ii        := bcab.movi_impo_mmnn_ii;
    v_movi_grav10_ii_mone      := bcab.movi_grav10_ii_mone;
    v_movi_grav5_ii_mone       := bcab.movi_grav5_ii_mone;
    v_movi_grav10_ii_mmnn      := bcab.movi_grav10_ii_mmnn;
    v_movi_grav5_ii_mmnn       := bcab.movi_grav5_ii_mmnn;
    v_movi_grav10_mone         := bcab.movi_grav10_mone;
    v_movi_grav5_mone          := bcab.movi_grav5_mone;
    v_movi_grav10_mmnn         := bcab.movi_grav10_mmnn;
    v_movi_grav5_mmnn          := bcab.movi_grav5_mmnn;
    v_movi_iva10_mone          := bcab.movi_iva10_mone;
    v_movi_iva5_mone           := bcab.movi_iva5_mone;
    v_movi_iva10_mmnn          := bcab.movi_iva10_mmnn;
    v_movi_iva5_mmnn           := bcab.movi_iva5_mmnn;
    v_movi_inve_codi           := bcab.movi_inve_codi;
    v_movi_indi_diar           := bcab.movi_indi_diar;
    v_movi_indi_cant_diar      := bcab.movi_indi_cant_diar;
    v_movi_indi_most_fech      := bcab.movi_indi_most_fech;
    v_movi_clpr_sucu_nume_item := bcab.sucu_nume_item;
    v_movi_nume_oc             := bcab.movi_nume_oc;
  
    --subcliente
    if parameter.p_indi_fact_sub_clie = 'S' then
      v_movi_sub_clpr_codi := bcab.movi_sub_clpr_codi;
    else
      v_movi_sub_clpr_codi := null;
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
                        v_movi_orte_codi,
                        v_movi_form_entr_codi,
                        v_movi_sub_clpr_codi,
                        v_movi_indi_cobr_dife,
                        v_movi_nume_timb,
                        V_MOVI_NUME_AUTO_IMPR,
                        v_movi_fech_venc_timb,
                        v_movi_fech_inic_timb,
                        v_movi_indi_entr_depo,
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
                        v_movi_inve_codi,
                        v_movi_indi_diar,
                        v_movi_indi_cant_diar,
                        v_movi_indi_most_fech,
                        v_movi_clpr_sucu_nume_item,
                        v_movi_nume_oc);
    --------------------------------------------------------------------------------------------------------------
    /*Exception
    when form_trigger_failure then
      raise form_trigger_failure;
    when others then
      raise_application_error(-20010,  sqlerrm);*/
  
  end;

  procedure pp_actualiza_movi_conc_prod is
    v_deta_movi_codi           number;
    v_deta_nume_item           number := 0;
    v_deta_impu_codi           number;
    v_deta_prod_codi           number;
    v_deta_cant                number;
    v_deta_obse                varchar2(2000);
    v_deta_porc_deto           number;
    v_deta_impo_mone           number;
    v_deta_impo_mmnn           number;
    v_deta_impo_mmee           number;
    v_deta_iva_mmnn            number;
    v_deta_iva_mmee            number;
    v_deta_iva_mone            number;
    v_deta_prec_unit           number;
    v_deta_movi_codi_padr      number;
    v_deta_nume_item_padr      number;
    v_deta_impo_mone_deto_nc   number;
    v_deta_movi_codi_deto_nc   number;
    v_deta_list_codi           number;
    v_deta_lote_codi           number;
    v_deta_cant_medi           number;
    v_deta_medi_codi           number;
    v_deta_movi_codi_ante      number;
    v_deta_remi_codi           number;
    v_deta_remi_nume_item      number;
    v_deta_prec_unit_list      number;
    v_deta_impo_deto_mone      number;
    v_deta_porc_deto_prec      number;
    v_deta_impo_mone_ii        number;
    v_deta_impo_mmnn_ii        number;
    v_deta_grav10_ii_mone      number;
    v_deta_grav5_ii_mone       number;
    v_deta_grav10_ii_mmnn      number;
    v_deta_grav5_ii_mmnn       number;
    v_deta_grav10_mone         number;
    v_deta_grav5_mone          number;
    v_deta_grav10_mmnn         number;
    v_deta_grav5_mmnn          number;
    v_deta_iva10_mone          number;
    v_deta_iva5_mone           number;
    v_deta_iva10_mmnn          number;
    v_deta_iva5_mmnn           number;
    v_deta_exen_mone           number;
    v_deta_exen_mmnn           number;
    v_deta_exde_codi           number;
    v_deta_exde_tipo           varchar2(1);
    v_deta_prod_codi_barr      varchar2(30);
    v_deta_prod_prec_maxi_deto number;
    v_deta_prec_maxi_deto_exce number;
  
    v_moco_movi_codi      number;
    v_moco_nume_item      number;
    v_moco_conc_codi      number;
    v_moco_cuco_codi      number;
    v_moco_impu_codi      number;
    v_moco_impo_mmnn      number;
    v_moco_impo_mmee      number;
    v_moco_impo_mone      number;
    v_moco_dbcr           varchar2(1);
    v_moco_desc           varchar(2000);
    v_moco_indi_fact_serv varchar2(1);
    v_moco_movi_codi_ante number;
    v_moco_cant           number;
    v_moco_impo_mone_ii   number;
    v_moco_impo_mmnn_ii   number;
    v_moco_grav10_ii_mone number;
    v_moco_grav5_ii_mone  number;
    v_moco_grav10_ii_mmnn number;
    v_moco_grav5_ii_mmnn  number;
    v_moco_grav10_mone    number;
    v_moco_grav5_mone     number;
    v_moco_grav10_mmnn    number;
    v_moco_grav5_mmnn     number;
    v_moco_iva10_mone     number;
    v_moco_iva5_mone      number;
    v_moco_iva10_mmnn     number;
    v_moco_iva5_mmnn      number;
    v_moco_exen_mone      number;
    v_moco_exen_mmnn      number;
    v_moco_conc_codi_impu number;
    v_moco_tipo           char(2);
    v_moco_prod_codi      number;
    v_moco_ortr_codi_fact number;
    v_moco_sofa_sose_codi number;
    v_moco_sofa_nume_item number;
    v_moco_sofa_codi      number;
    v_moco_empl_codi      number;
    v_moco_anex_codi      number;
    v_moco_impo_diar_mone number;
    v_moco_ceco_codi      number;
    v_moco_maqu_codi      number;
  
    cursor cDeta is
      select taax_sess sessio,
             taax_user usuario,
             taax_seq  seq_id,
             taax_c050 nombre_del_informe,
             taax_c001 indi_prod_ortr,
             taax_c002 prod_desc,
             taax_c003 medi_desc,
             taax_c004 prod_codi_alfa,
             taax_n001 deta_prod_codi,
             taax_n002 coba_codi_barr,
             taax_n003 deta_medi_codi,
             taax_n004 deta_cant_medi,
             taax_n005 deta_prec_unit,
             taax_n006 deta_porc_deto,
             taax_n007 deta_impo_mone_ii,
             taax_n008 s_descuento,
             taax_n009 deta_impo_mmnn_ii,
             taax_n010 deta_grav10_mone_ii,
             taax_n011 deta_grav5_mone_ii,
             taax_n012 deta_grav10_mone,
             taax_n013 deta_grav5_mone,
             taax_n014 deta_iva10_mone,
             taax_n015 deta_iva5_mone,
             taax_n016 deta_exen_mone,
             taax_n017 deta_grav10_mmnn_ii,
             taax_n018 deta_grav5_mmnn_ii,
             taax_n019 deta_grav10_mmnn,
             taax_n020 deta_grav5_mmnn,
             taax_n021 deta_iva10_mmnn,
             taax_n022 deta_iva5_mmnn,
             taax_n023 deta_exen_mmnn,
             taax_n024 deta_impo_mmnn,
             taax_n025 deta_impo_mone,
             taax_n026 deta_iva_mmnn,
             taax_n027 deta_iva_mone,
             taax_n028 coba_fact_conv,
             taax_n029 deta_lote_codi,
             taax_c005 prod_indi_fact_nega,
             taax_n030 deta_impu_codi,
             taax_n031 deta_prec_unit_list,
             taax_c006 prod_indi_kitt,
             taax_n032 deta_prod_prec_maxi_deto,
             taax_n033 deta_prod_prec_maxi_d_exce,
             taax_n034 deta_empl_codi
        from come_tabl_auxi
       where taax_sess = p_sess
         and taax_user = gen_user
         and taax_c050 = 'FACT_DETA';
  
    o_deta_conc_codi      number;
    o_deta_moco_dbcr      varchar2(1);
    v_deta_prod_clco      number;
    o_deta_impu_conc_codi number;
  
  begin
    v_deta_movi_codi := bcab.movi_codi;
    v_moco_movi_codi := bcab.movi_codi;
  
    for i in cDeta loop
      v_deta_nume_item := v_deta_nume_item + 1;
    
      bdet.deta_cant                     := i.deta_cant_medi *
                                            NVL(i.coba_fact_conv, 1);
      bdet.deta_nume_item                := v_deta_nume_item;
      bdet.prod_codi_alfa                := i.prod_codi_alfa;
      bdet.deta_prod_codi                := i.deta_prod_codi;
      bdet.deta_cant_medi                := i.deta_cant_medi;
      bdet.deta_medi_codi                := i.deta_medi_codi;
      bdet.coba_codi_barr                := i.coba_codi_barr;
      bdet.deta_prod_prec_maxi_deto      := i.deta_prod_prec_maxi_deto;
      bdet.deta_prod_prec_maxi_deto_exen := i.deta_prod_prec_maxi_d_exce;
    
      /*if i.w_movi_codi_cabe is not null then
        v_deta_movi_codi := i.w_movi_codi_cabe;
        if nvl(v_deta_movi_codi_ante, 0) <> v_deta_movi_codi then
          v_deta_nume_item      := 0;
          v_deta_movi_codi_ante := v_deta_movi_codi;
        end if;
        v_deta_nume_item := v_deta_nume_item + 1;
      else
        v_deta_nume_item := i.deta_nume_item;
      end if;*/
    
      v_deta_impu_codi         := i.deta_impu_codi;
      v_deta_prod_codi         := i.deta_prod_codi;
      v_deta_cant              := bdet.deta_cant;
      v_deta_obse              := i.prod_desc;
      v_deta_porc_deto         := i.deta_porc_deto;
      v_deta_impo_mone         := i.deta_impo_mone;
      v_deta_impo_mmnn         := i.deta_impo_mmnn;
      v_deta_impo_mmee         := null;
      v_deta_iva_mmnn          := i.deta_iva_mmnn;
      v_deta_iva_mmee          := null;
      v_deta_iva_mone          := i.deta_iva_mone;
      v_deta_prec_unit         := i.deta_prec_unit;
      v_deta_movi_codi_padr    := null;
      v_deta_nume_item_padr    := null;
      v_deta_impo_mone_deto_nc := null;
      v_deta_movi_codi_deto_nc := null;
      v_deta_list_codi         := bcab.list_codi;
      --v_deta_lote_codi          := fp_devu_lote_000000(v_deta_prod_codi);
      v_deta_lote_codi           := i.deta_lote_codi;
      v_deta_cant_medi           := i.deta_cant_medi;
      v_deta_medi_codi           := i.deta_medi_codi;
      v_deta_remi_codi           := null; --i.deta_remi_codi;
      v_deta_remi_nume_item      := null; --i.deta_remi_nume_item;
      v_deta_prec_unit_list      := i.deta_prec_unit_list;
      v_deta_impo_deto_mone      := null; --i.deta_impo_deto_mone;
      v_deta_porc_deto_prec      := null; --i.deta_porc_deto_prec;
      v_deta_impo_mone_ii        := i.deta_impo_mone_ii;
      v_deta_impo_mmnn_ii        := i.deta_impo_mmnn_ii;
      v_deta_grav10_ii_mone      := i.deta_grav10_mone_ii;
      v_deta_grav5_ii_mone       := i.deta_grav5_mone_ii;
      v_deta_grav10_ii_mmnn      := i.deta_grav10_mmnn_ii;
      v_deta_grav5_ii_mmnn       := i.deta_grav5_mmnn_ii;
      v_deta_grav10_mone         := i.deta_grav10_mone;
      v_deta_grav5_mone          := i.deta_grav5_mone;
      v_deta_grav10_mmnn         := i.deta_grav10_mmnn;
      v_deta_grav5_mmnn          := i.deta_grav5_mmnn;
      v_deta_iva10_mone          := i.deta_iva10_mone;
      v_deta_iva5_mone           := i.deta_iva5_mone;
      v_deta_iva10_mmnn          := i.deta_iva10_mmnn;
      v_deta_iva5_mmnn           := i.deta_iva5_mmnn;
      v_deta_exen_mone           := i.deta_exen_mone;
      v_deta_exen_mmnn           := i.deta_exen_mmnn;
      v_deta_prod_codi_barr      := i.coba_codi_barr;
      v_deta_prod_prec_maxi_deto := i.deta_prod_prec_maxi_deto;
      v_deta_prec_maxi_deto_exce := i.deta_prod_prec_maxi_d_exce;
    
      -- if i.exde_codi is not null then
      --   v_deta_exde_codi := i.exde_codi;
      --  v_deta_exde_tipo := i.exde_tipo;
      -- else
      v_deta_exde_codi := null;
      v_deta_exde_tipo := null;
      -- end if;
    
      if v_deta_prod_codi is not null then
        if i.indi_prod_ortr = 'P' then
          if i.prod_indi_kitt = 'S' then
            i020168.pp_actualiza_movi_kit;
            pp_actualiza_movi_prod_kit;
          end if;
        
          pp_insert_come_movi_prod_deta(v_deta_movi_codi,
                                        v_deta_nume_item,
                                        v_deta_impu_codi,
                                        v_deta_prod_codi,
                                        v_deta_cant,
                                        v_deta_obse,
                                        v_deta_porc_deto,
                                        v_deta_impo_mone,
                                        v_deta_impo_mmnn,
                                        v_deta_impo_mmee,
                                        v_deta_iva_mmnn,
                                        v_deta_iva_mmee,
                                        v_deta_iva_mone,
                                        v_deta_prec_unit,
                                        v_deta_movi_codi_padr,
                                        v_deta_nume_item_padr,
                                        v_deta_impo_mone_deto_nc,
                                        v_deta_movi_codi_deto_nc,
                                        v_deta_list_codi,
                                        v_deta_lote_codi,
                                        v_deta_cant_medi,
                                        v_deta_medi_codi,
                                        v_deta_remi_codi,
                                        v_deta_remi_nume_item,
                                        v_deta_prec_unit_list,
                                        v_deta_impo_deto_mone,
                                        v_deta_porc_deto_prec,
                                        v_deta_impo_mone_ii,
                                        v_deta_impo_mmnn_ii,
                                        v_deta_grav10_ii_mone,
                                        v_deta_grav5_ii_mone,
                                        v_deta_grav10_ii_mmnn,
                                        v_deta_grav5_ii_mmnn,
                                        v_deta_grav10_mone,
                                        v_deta_grav5_mone,
                                        v_deta_grav10_mmnn,
                                        v_deta_grav5_mmnn,
                                        v_deta_iva10_mone,
                                        v_deta_iva5_mone,
                                        v_deta_iva10_mmnn,
                                        v_deta_iva5_mmnn,
                                        v_deta_exen_mone,
                                        v_deta_exen_mmnn,
                                        v_deta_exde_codi,
                                        v_deta_exde_tipo,
                                        v_deta_prod_codi_barr,
                                        v_deta_prod_prec_maxi_deto,
                                        v_deta_prec_maxi_deto_exce);
        
        elsif i.indi_prod_ortr = 'O' then
        
          pp_insert_come_movi_ortr_deta(v_deta_movi_codi,
                                        v_deta_nume_item,
                                        v_deta_prod_codi,
                                        v_deta_impu_codi,
                                        v_deta_cant,
                                        v_deta_porc_deto,
                                        v_deta_impo_mone,
                                        v_deta_impo_mmnn,
                                        v_deta_impo_mmee,
                                        v_deta_iva_mone,
                                        v_deta_iva_mmnn,
                                        v_deta_iva_mmee,
                                        v_deta_prec_unit,
                                        v_deta_movi_codi_padr,
                                        v_deta_nume_item_padr,
                                        v_deta_obse,
                                        v_deta_impo_mone_ii,
                                        v_deta_impo_mmnn_ii,
                                        v_deta_grav10_ii_mone,
                                        v_deta_grav5_ii_mone,
                                        v_deta_grav10_ii_mmnn,
                                        v_deta_grav5_ii_mmnn,
                                        v_deta_grav10_mone,
                                        v_deta_grav5_mone,
                                        v_deta_grav10_mmnn,
                                        v_deta_grav5_mmnn,
                                        v_deta_iva10_mone,
                                        v_deta_iva5_mone,
                                        v_deta_iva10_mmnn,
                                        v_deta_iva5_mmnn,
                                        v_deta_exen_mone,
                                        v_deta_exen_mmnn);
        
          pp_actu_esta_ortr(v_deta_movi_codi,
                            v_deta_prod_codi,
                            i.deta_prod_codi);
        end if;
      end if;
    
      --actualiza come_movi_conc_deta
      if i.indi_prod_ortr = 'P' then
      
        select prod_clco_codi
          into v_deta_prod_clco
          from come_prod
         where prod_codi = i.deta_prod_codi;
      
        I020168.pp_busca_conce_prod(p_clco_codi => v_deta_prod_clco,
                                    p_oper_codi => bcab.movi_oper_codi,
                                    p_conc_codi => o_deta_conc_codi,
                                    p_conc_dbcr => o_deta_moco_dbcr);
      
        v_moco_conc_codi      := o_deta_conc_codi;
        v_moco_dbcr           := o_deta_moco_dbcr;
        v_moco_indi_fact_serv := 'N';
        v_moco_desc           := null;
        v_moco_tipo           := 'P';
        v_moco_prod_codi      := i.deta_prod_codi;
        v_moco_ortr_codi_fact := null;
        v_moco_sofa_sose_codi := null;
        v_moco_sofa_nume_item := null;
        v_moco_empl_codi      := null;
        v_moco_anex_codi      := null;
        /*elsif i.indi_prod_ortr = 'O' then
          if i.deta_prod_clco is null then
            v_moco_conc_codi := i.deta_conc_codi;
            v_moco_dbcr      := o_deta_moco_dbcr;
          else
            v_moco_conc_codi := parameter.p_codi_conc_vta; ---i.deta_prod_clco;
          end if;
          v_moco_indi_fact_serv := 'N';
          v_moco_desc           := null;
          v_moco_tipo           := 'O';
          v_moco_prod_codi      := null;
          v_moco_ortr_codi_fact := i.deta_prod_codi;
          v_moco_sofa_sose_codi := null;
          v_moco_sofa_nume_item := null;
          v_moco_empl_codi      := null;
          v_moco_anex_codi      := null;
        elsif i.indi_prod_ortr = 'C' then
          v_moco_conc_codi      := o_deta_conc_codi;
          v_moco_dbcr           := o_deta_moco_dbcr;
          v_moco_indi_fact_serv := 'N';
          v_moco_desc           := i.ortr_desc;
          v_moco_tipo           := 'C';
          v_moco_prod_codi      := null;
          v_moco_ortr_codi_fact := null;
          v_moco_sofa_sose_codi := i.deta_prod_codi;
          v_moco_sofa_nume_item := i.sofa_nume_item;
          v_moco_sofa_codi      := i.sofa_codi;
          v_moco_empl_codi      := null;
          v_moco_anex_codi      := null;
        elsif i.indi_prod_ortr = 'A' then
          v_moco_conc_codi      := o_deta_conc_codi;
          v_moco_dbcr           := o_deta_moco_dbcr;
          v_moco_indi_fact_serv := 'N';
          v_moco_desc           := i.ortr_desc;
          v_moco_tipo           := 'A';
          v_moco_prod_codi      := null;
          v_moco_ortr_codi_fact := null;
          v_moco_sofa_sose_codi := null;
          v_moco_sofa_nume_item := null;
          v_moco_empl_codi      := null;
          v_moco_anex_codi      := i.deta_prod_codi;
          pp_actualizar_anexo(v_moco_anex_codi);
        */
      else
        v_moco_conc_codi      := i.prod_codi_alfa;
        v_moco_dbcr           := 'D';
        v_moco_indi_fact_serv := 'S';
        v_moco_desc           := i.prod_desc;
        v_moco_tipo           := 'C';
        v_moco_prod_codi      := null;
        v_moco_ortr_codi_fact := null;
        v_moco_sofa_sose_codi := null;
        v_moco_sofa_nume_item := null;
        v_moco_empl_codi      := i.deta_empl_codi;
        v_moco_anex_codi      := null;
        v_moco_impo_diar_mone := null; --i.moco_impo_diar_mone;
      end if;
    
      select decode(CHR(39) || bcab.movi_dbcr || CHR(39),
                    'C',
                    impu_conc_codi_ivcr,
                    impu_conc_codi_ivdb) conc_iva
        into o_deta_impu_conc_codi
        from come_impu
       where impu_codi = i.deta_impu_codi;
    
      v_moco_nume_item      := v_deta_nume_item; --bdet.deta_nume_item;
      v_moco_cuco_codi      := null;
      v_moco_impu_codi      := i.deta_impu_codi;
      v_moco_impo_mmnn      := (i.deta_impo_mmnn);
      v_moco_impo_mmee      := 0;
      v_moco_impo_mone      := (i.deta_impo_mone);
      v_moco_impo_mone_ii   := i.deta_impo_mone_ii;
      v_moco_cant           := i.deta_cant_medi;
      v_moco_impo_mmnn_ii   := i.deta_impo_mmnn_ii;
      v_moco_grav10_ii_mone := i.deta_grav10_mone_ii;
      v_moco_grav5_ii_mone  := i.deta_grav5_mone_ii;
      v_moco_grav10_ii_mmnn := i.deta_grav10_mmnn_ii;
      v_moco_grav5_ii_mmnn  := i.deta_grav5_mmnn_ii;
      v_moco_grav10_mone    := i.deta_grav10_mone;
      v_moco_grav5_mone     := i.deta_grav5_mone;
      v_moco_grav10_mmnn    := i.deta_grav10_mmnn;
      v_moco_grav5_mmnn     := i.deta_grav5_mmnn;
      v_moco_iva10_mone     := i.deta_iva10_mone;
      v_moco_iva5_mone      := i.deta_iva5_mone;
      v_moco_iva10_mmnn     := i.deta_iva10_mmnn;
      v_moco_iva5_mmnn      := i.deta_iva5_mmnn;
      v_moco_exen_mone      := i.deta_exen_mone;
      v_moco_exen_mmnn      := i.deta_exen_mmnn;
      v_moco_conc_codi_impu := o_deta_impu_conc_codi;
      v_moco_ceco_codi      := bcab.moco_ceco_codi;
      v_moco_maqu_codi      := null; --i.moco_maqu_codi;
    
      pp_insert_movi_conc_deta(v_moco_movi_codi,
                               v_moco_nume_item,
                               v_moco_conc_codi,
                               v_moco_cuco_codi,
                               v_moco_impu_codi,
                               v_moco_impo_mmnn,
                               v_moco_impo_mmee,
                               v_moco_impo_mone,
                               v_moco_dbcr,
                               v_moco_desc,
                               v_moco_indi_fact_serv,
                               v_moco_impo_mone_ii,
                               v_moco_cant,
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
                               v_moco_tipo,
                               v_moco_prod_codi,
                               v_moco_ortr_codi_fact,
                               v_moco_sofa_sose_codi,
                               v_moco_sofa_nume_item,
                               v_moco_sofa_codi,
                               v_moco_empl_codi,
                               v_moco_anex_codi,
                               v_moco_impo_diar_mone,
                               v_moco_ceco_codi,
                               v_moco_maqu_codi);
    
    --actualiza come_exce_deto en caso que exista 
    /*begin
                                                                                                                                                                                                    if nvl(:bdet.exde_tipo, 'N') in ('P','C','O','K') then
                                                                                                                                                                                                      if :bdet.exde_peri = 'V' then
                                                                                                                                                                                                        update come_exce_deto
                                                                                                                                                                                                           set exde_esta = 'I'
                                                                                                                                                                                                         where exde_codi = :bdet.exde_codi;
                                                                                                                                                                                                      end if;
                                                                                                                                                                                                    end if;
                                                                                                                                                                                                 end;*/
    
    end loop;
  
    -- pp_actu_exce_deto_cabe;
    /*procedure pp_actu_exce_deto_cabe is
    begin
      if nvl(bcab.exde_tipo, 'N') <> 'N' then
        if bcab.exde_peri = 'V' then
          update come_exce_deto
             set exde_esta = 'I'
           where exde_codi = bcab.exde_codi;
        end if;
      end if;
    end;*/
  
    /*exception
    when others then
      pl_me(sqlerrm);*/
  end;

  procedure pp_actualiza_moimpu is
    v_indi_regi varchar2(1) := 'N';
  
    cursor c_conc is
      select a.moco_movi_codi,
             a.moco_impu_codi,
             a.moco_tiim_codi,
             i.impu_porc,
             i.impu_porc_base_impo,
             nvl(i.impu_indi_baim_impu_incl, 'N') impu_indi_baim_impu_incl,
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
             sum(a.moco_exen_mmnn) moco_exen_mmnn
        from come_movi_conc_deta a, come_impu i
       where a.moco_impu_codi = impu_codi
         and a.moco_movi_codi = bcab.movi_codi
       group by a.moco_movi_codi,
                a.moco_impu_codi,
                a.moco_tiim_codi,
                i.impu_porc,
                i.impu_porc_base_impo,
                i.impu_indi_baim_impu_incl
       order by a.moco_movi_codi, a.moco_impu_codi, a.moco_tiim_codi;
  
    v_impoii_mmnn number := 0;
    v_impoii_mmee number := 0;
    v_impoii_mone number := 0;
  
    v_impo_mmnn           number := 0;
    v_impu_mmnn           number := 0;
    v_impo_mmee           number := 0;
    v_impu_mmee           number := 0;
    v_impo_mone           number := 0;
    v_impu_mone           number := 0;
    v_impo_grav           number := 0;
    v_impo_iva            number := 0;
    v_impo_exen           number := 0;
    v_moim_impo_mone_ii   number;
    v_moim_impo_mmnn_ii   number;
    v_moim_grav10_ii_mone number;
    v_moim_grav10_ii_mmnn number;
    v_moim_grav5_ii_mone  number;
    v_moim_grav5_ii_mmnn  number;
    v_moim_grav10_mone    number;
    v_moim_grav5_mone     number;
    v_moim_grav10_mmnn    number;
    v_moim_grav5_mmnn     number;
    v_moim_iva10_mone     number;
    v_moim_iva5_mone      number;
    v_moim_iva10_mmnn     number;
    v_moim_iva5_mmnn      number;
    v_moim_exen_mone      number;
    v_moim_exen_mmnn      number;
    v_impo                number := 0;
    v_dife                number := 0;
  
  begin
    v_indi_regi := 'N';
    for x in c_conc loop
      v_indi_regi           := 'S';
      v_impoii_mmnn         := x.moco_impo_mmnn_ii;
      v_impoii_mmee         := x.moco_impo_mmee;
      v_impoii_mone         := x.moco_impo_mone_ii;
      v_impo_grav           := x.moco_grav10_mone + x.moco_grav5_mone;
      v_impo_iva            := x.moco_iva10_mone + x.moco_iva5_mone;
      v_impo_exen           := x.moco_impo_mone_ii -
                               (v_impo_grav + v_impo_iva);
      v_impo_mmee           := 0;
      v_impu_mmee           := 0;
      v_impo_mone           := v_impo_grav + v_impo_exen;
      v_impu_mone           := v_impo_iva;
      v_impu_mmnn           := x.moco_iva10_mmnn + x.moco_iva5_mmnn;
      v_impo_mmnn           := x.moco_impo_mmnn_ii - v_impu_mmnn;
      v_moim_impo_mone_ii   := x.moco_impo_mone_ii;
      v_moim_impo_mmnn_ii   := x.moco_impo_mmnn_ii;
      v_moim_grav10_ii_mone := x.moco_grav10_ii_mone;
      v_moim_grav10_ii_mmnn := x.moco_grav10_ii_mmnn;
      v_moim_grav5_ii_mone  := x.moco_grav5_ii_mone;
      v_moim_grav5_ii_mmnn  := x.moco_grav5_ii_mmnn;
      v_moim_grav10_mone    := x.moco_grav10_mone;
      v_moim_grav5_mone     := x.moco_grav5_mone;
      v_moim_grav10_mmnn    := x.moco_grav10_mmnn;
      v_moim_grav5_mmnn     := x.moco_grav5_mmnn;
      v_moim_iva10_mone     := x.moco_iva10_mone;
      v_moim_iva5_mone      := x.moco_iva5_mone;
      v_moim_iva10_mmnn     := x.moco_iva10_mmnn;
      v_moim_iva5_mmnn      := x.moco_iva5_mmnn;
      v_moim_exen_mone      := x.moco_exen_mone;
      v_moim_exen_mmnn      := x.moco_exen_mmnn;
    
      pp_insert_come_movi_impu_deta(x.moco_impu_codi,
                                    x.moco_movi_codi,
                                    v_impo_mmnn,
                                    v_impo_mmee,
                                    v_impu_mmnn,
                                    v_impu_mmee,
                                    v_impo_mone,
                                    v_impu_mone,
                                    x.moco_tiim_codi,
                                    v_moim_impo_mone_ii,
                                    v_moim_impo_mmnn_ii,
                                    v_moim_grav10_ii_mone,
                                    v_moim_grav10_ii_mmnn,
                                    v_moim_grav5_ii_mone,
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
  
    if v_indi_regi = 'N' then
      pl_me('Atención!!!!!.. Debe ingresar los totales');
    end if;
  
  exception
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_actu_clie_exce is
    v_count number;
  
  begin
  
    parameter.p_actu_situ_clie := 'N';
  
    if nvl(bcab.clpr_indi_exce, 'N') = 'S' then
    
      select count(*)
        into v_count
        from all_triggers a
       where a.trigger_name = 'AUDI_COME_CLIE_PROV';
    
      if v_count > 0 then
        pa_ejecuta_dll_auto('ALTER TRIGGER AUDI_COME_CLIE_PROV DISABLE');
      end if;
    
      update come_clie_prov cp
         set cp.clpr_indi_exce = 'N'
       where cp.clpr_codi = bcab.movi_clpr_codi;
    
      parameter.p_actu_situ_clie := 'S';
    end if;
  
  end;

  procedure pp_actu_secu(p_indi in char) is
  begin
  
    if p_indi = 'S' then
      if nvl(bcab.s_timo_calc_iva, 'N') = 'N' then
      
        update come_secu
           set secu_nume_fact_negr = bcab.movi_nume
         where secu_codi = (select user_secu_codi
                              from segu_user a
                             where a.user_login = gen_user);
        /*(select peco_secu_codi
         from come_pers_comp
        where peco_codi = parameter.p_peco_codi);*/
      
      else
      
        update come_secu
           set secu_nume_fact = bcab.movi_nume
         where secu_codi = (select user_secu_codi
                              from segu_user a
                             where a.user_login = gen_user);
        /*(select peco_secu_codi
         from come_pers_comp
        where peco_codi = parameter.p_peco_codi);*/
      
      end if;
    end if;
  end;

  procedure pp_actu_pres is
  begin
    --Actualizar el Presupuesto.. para que deje de estar como pendiente
    if bcab.s_pres_codi is not null then
      update come_pres_clie
         set pres_movi_codi = bcab.movi_codi, pres_esta_pres = 'F'
       where pres_codi = bcab.s_pres_codi;
    
      update come_exce_deto
         set exde_esta = 'I'
       where exde_pres_codi = bcab.s_pres_codi;
    
      /*update come_pres_clie_deta set dpre_pres_tipo = bcab.pres_tipo,
                                    dpre_pres_esta_pres = 'F'
      where dpre_pres_codi = bcab.s_pres_codi;  */
    end if;
  end;

  procedure pp_actu_inve is
  begin
    --Actualizar la Intencion de Venta.. para que deje de estar como pendiente
    if bcab.movi_inve_codi is not null then
      update come_inte_vent
         set inve_esta = 'F'
       where inve_codi = bcab.movi_inve_codi;
    end if;
  end;

  procedure pp_actu_esta_ortr(p_codi_padr      in number,
                              p_ortr_codi      in number,
                              p_deta_prod_codi in number) is
  
    v_tipo_serv    varchar2(1);
    v_dura_cont    number;
    v_indi_timo    varchar2(1);
    v_tipo_fact    varchar2(1);
    v_count        number;
    v_actualizarOK boolean;
  
  begin
    begin
      select sose_tipo_serv, sose_dura_cont, sose_indi_timo, sose_tipo_fact
        into v_tipo_serv, v_dura_cont, v_indi_timo, v_tipo_fact
        from come_orde_trab,
             come_orde_trab_vehi,
             come_soli_serv_anex_deta,
             come_soli_serv_anex,
             come_soli_serv s
       where vehi_ortr_codi = ortr_codi
         and vehi_anex_codi = deta_anex_codi
         and vehi_anex_nume_item = deta_nume_item
         and deta_anex_codi = anex_codi
         and anex_sose_codi = sose_codi
         and ortr_codi = p_ortr_codi;
    exception
      when others then
        v_tipo_serv := 'O';
    end;
  
    if v_tipo_serv = 'O' then
      v_actualizarOK := true;
    else
      if v_indi_timo = 'C' or v_tipo_fact = 'C' then
        --si es contado o si en financiado por contrato entonces se actualiza a Facturado.
        v_actualizarOK := true;
      else
        -- si no, se ve las cantidades de veces que se facturo la OT. Debe ser  igual a duración del contrato.
        select count(*)
          into v_count
          from come_movi_conc_deta
         where moco_ortr_codi_fact = p_deta_prod_codi;
        if v_count + 1 >= v_dura_cont then
          v_actualizarOK := true;
        else
          v_actualizarOK := false;
        end if;
      end if;
    end if;
    if v_actualizarOK then
      update come_orde_trab a
         set ortr_indi_fact = 'S'
       where ortr_codi = p_ortr_codi;
    end if;
  end;

  procedure pp_actualiza_movi_kit is
    v_movi_codi                number(20);
    v_movi_timo_codi           number(10);
    v_movi_clpr_codi           number(20);
    v_movi_sucu_codi_orig      number(10);
    v_movi_depo_codi_orig      number(10);
    v_movi_sucu_codi_dest      number(10);
    v_movi_depo_codi_dest      number(10);
    v_movi_oper_codi           number(10);
    v_movi_cuen_codi           number(4);
    v_movi_mone_codi           number(4);
    v_movi_nume                number(20);
    v_movi_fech_emis           date;
    v_movi_fech_grab           date;
    v_movi_user                varchar2(20);
    v_movi_codi_padr           number(20);
    v_movi_tasa_mone           number(20, 4);
    v_movi_tasa_mmee           number(20, 4);
    v_movi_grav_mmnn           number(20, 4);
    v_movi_exen_mmnn           number(20, 4);
    v_movi_iva_mmnn            number(20, 4);
    v_movi_grav_mmee           number(20, 4);
    v_movi_exen_mmee           number(20, 4);
    v_movi_iva_mmee            number(20, 4);
    v_movi_grav_mone           number(20, 4);
    v_movi_exen_mone           number(20, 4);
    v_movi_iva_mone            number(20, 4);
    v_movi_obse                varchar2(2000);
    v_movi_sald_mmnn           number(20, 4);
    v_movi_sald_mmee           number(20, 4);
    v_movi_sald_mone           number(20, 4);
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(100);
    v_movi_clpr_tele           varchar2(50);
    v_movi_clpr_ruc            varchar2(20);
    v_movi_clpr_desc           varchar2(80);
    v_movi_emit_reci           varchar2(1);
    v_movi_afec_sald           varchar2(1);
    v_movi_dbcr                varchar2(1);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_empr_codi           number(2);
    v_movi_clave_orig          number(20);
    v_movi_clave_orig_padr     number(20);
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           number(10);
    v_movi_obse_deta           varchar2(500);
    v_movi_base                number(2);
    v_movi_ortr_codi           number(20);
    v_movi_codi_padr_vali      number(20);
    v_movi_rrhh_movi_codi      number(20);
    v_movi_asie_codi           number(10);
    v_movi_orpa_codi           number(20);
    v_movi_impo_codi           number(20);
    v_movi_indi_conta          varchar2(1);
    v_movi_excl_cont           varchar2(1);
    v_movi_impo_dife_camb      number(20, 4);
    v_movi_mone_codi_liqu      number(20, 4);
    v_movi_mone_liqu           number(20, 4);
    v_movi_tasa_mone_liqu      number(20, 4);
    v_movi_impo_mone_liqu      number(20, 4);
    v_movi_codi_rete           number(20);
    v_movi_orpe_codi           number(20);
    v_movi_cons_codi           number(10);
    v_movi_indi_inte           varchar2(1);
    v_movi_indi_deve_gene      varchar2(1);
    v_movi_fech_oper           date;
    v_movi_orpe_codi_loca      number(20);
    v_movi_impo_reca           number(20, 4);
    v_movi_fech_inic_tras      date;
    v_movi_fech_term_tras      date;
    v_movi_tran_codi           number(4);
    v_movi_vehi_marc           varchar2(50);
    v_movi_vehi_chap           varchar2(20);
    v_movi_cont_tran_nomb      varchar2(100);
    v_movi_cont_tran_ruc       varchar2(20);
    v_movi_cond_empl_codi      number(10);
    v_movi_cond_nomb           varchar2(100);
    v_movi_cond_cedu_nume      varchar2(20);
    v_movi_cond_dire           varchar2(200);
    v_movi_sucu_codi_movi      number(10);
    v_movi_depo_codi_movi      number(10);
    v_movi_impo_deto           number(20, 4);
    v_movi_orte_codi           number(10);
    v_movi_cheq_indi_desc      varchar2(1);
    v_movi_indi_liqu_tarj      varchar2(1);
    v_movi_impo_deto_mone      number(20, 4);
    v_movi_tiva_codi           number(10);
    v_movi_serv_movi_codi      number(20);
    v_movi_serv_sald_mone      number(20, 4);
    v_movi_serv_sald_mmnn      number(20, 4);
    v_movi_soco_codi           number(20);
    v_movi_inmu_codi           number(10);
    v_movi_indi_expe_proc      varchar2(1);
    v_movi_liqu_codi           number(20);
    v_movi_liqu_codi_expe      number(10);
    v_movi_vale_indi_impo      varchar2(1);
    v_movi_form_entr_codi      number(10);
    v_movi_indi_tipo_pres      varchar2(2);
    v_movi_soma_codi           number(20);
  
    v_movi_sub_clpr_codi       number;
    v_movi_indi_cobr_dife      varchar2(1);
    v_movi_nume_timb           varchar2(20);
    V_MOVI_NUME_AUTO_IMPR      varchar2(20);
    v_movi_fech_venc_timb      date;
    v_movi_indi_entr_depo      varchar2(1);
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
    v_movi_inve_codi           number;
    v_movi_indi_diar           varchar2(1);
    v_movi_indi_cant_diar      varchar2(1);
    v_movi_indi_most_fech      varchar2(1);
    v_movi_clpr_sucu_nume_item number;
    v_movi_nume_oc             number(20);
  
    v_cost_tota number;
  begin
  
    select nvl(round(sum(round((nvl(t.kide_cant_fini, 0) *
                               nvl(t.kide_fact_conv, 1)) *
                               nvl(bdet.deta_cant, 0),
                               parameter.p_cant_deci_cant) *
                         nvl(t.kide_cost_prom_mmnn, 0)),
                     parameter.p_cant_deci_mmnn),
               0)
      into v_cost_tota
      from temp_fact_prod_kit t
     where t.kide_nume_item = bdet.deta_nume_item;
  
    -- primero insertar el ingreso por produccion (+)
    -- asignar valores....
    --bcab.movi_codi            := fa_sec_come_movi;
    v_movi_codi                   := fa_sec_come_movi;
    parameter.p_movi_codi_kit_mas := v_movi_codi;
    v_movi_timo_codi              := null;
    v_movi_clpr_codi              := null;
    v_movi_sucu_codi_orig         := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig         := bcab.movi_depo_codi_orig;
    v_movi_sucu_codi_dest         := null;
    v_movi_depo_codi_dest         := null;
    v_movi_oper_codi              := parameter.p_codi_oper_prod_mas;
    v_movi_cuen_codi              := null;
    v_movi_mone_codi              := parameter.p_codi_mone_mmnn;
    v_movi_nume                   := bcab.movi_nume;
    v_movi_fech_emis              := bcab.movi_fech_emis;
    v_movi_fech_grab              := sysdate;
    v_movi_user                   := gen_user;
    v_movi_codi_padr              := null;
    v_movi_tasa_mone              := 1;
    v_movi_tasa_mmee              := null;
    v_movi_grav_mmnn              := 0;
    v_movi_exen_mmnn              := v_cost_tota;
    v_movi_iva_mmnn               := 0;
    v_movi_grav_mmee              := 0;
    v_movi_exen_mmee              := 0;
    v_movi_iva_mmee               := 0;
    v_movi_grav_mone              := 0;
    v_movi_exen_mone              := v_cost_tota;
    v_movi_iva_mone               := 0;
    v_movi_obse                   := 'Generacion por factura ' ||
                                     bcab.movi_nume || ' kit ' ||
                                     bdet.prod_codi_alfa;
    v_movi_sald_mmnn              := 0;
    v_movi_sald_mmee              := 0;
    v_movi_sald_mone              := 0;
    v_movi_stoc_suma_rest         := fp_dev_indi_suma_rest(parameter.p_codi_oper_prod_mas);
    v_movi_clpr_dire              := null;
    v_movi_clpr_tele              := null;
    v_movi_clpr_ruc               := null;
    v_movi_clpr_desc              := null;
    v_movi_emit_reci              := null;
    v_movi_afec_sald              := null;
    v_movi_dbcr                   := null;
    v_movi_stoc_afec_cost_prom    := 'N';
    v_movi_empr_codi              := bcab.movi_empr_codi;
    v_movi_clave_orig             := null;
    v_movi_clave_orig_padr        := null;
    v_movi_indi_iva_incl          := null;
    v_movi_empl_codi              := null;
    v_movi_obse_deta              := null;
    v_movi_base                   := parameter.p_codi_base;
    v_movi_ortr_codi              := null;
    v_movi_codi_padr_vali         := null;
    v_movi_rrhh_movi_codi         := null;
    v_movi_asie_codi              := null;
    v_movi_orpa_codi              := null;
    v_movi_impo_codi              := null;
    v_movi_indi_conta             := null;
    v_movi_nume_timb              := null;
    V_MOVI_NUME_AUTO_IMPR         := null;
    v_movi_excl_cont              := null;
    v_movi_impo_dife_camb         := null;
    v_movi_mone_codi_liqu         := null;
    v_movi_mone_liqu              := null;
    v_movi_tasa_mone_liqu         := null;
    v_movi_impo_mone_liqu         := null;
    v_movi_codi_rete              := null;
    v_movi_orpe_codi              := null;
    v_movi_cons_codi              := null;
    v_movi_indi_inte              := null;
    v_movi_indi_deve_gene         := null;
    v_movi_fech_oper              := bcab.movi_fech_emis;
    v_movi_fech_venc_timb         := null;
    v_movi_orpe_codi_loca         := null;
    v_movi_impo_reca              := null;
    v_movi_fech_inic_tras         := null;
    v_movi_fech_term_tras         := null;
    v_movi_tran_codi              := null;
    v_movi_vehi_marc              := null;
    v_movi_vehi_chap              := null;
    v_movi_cont_tran_nomb         := null;
    v_movi_cont_tran_ruc          := null;
    v_movi_cond_empl_codi         := null;
    v_movi_cond_nomb              := null;
    v_movi_cond_cedu_nume         := null;
    v_movi_cond_dire              := null;
    v_movi_sucu_codi_movi         := null;
    v_movi_depo_codi_movi         := null;
    v_movi_impo_deto              := null;
    v_movi_orte_codi              := null;
    v_movi_cheq_indi_desc         := null;
    v_movi_indi_liqu_tarj         := null;
    v_movi_impo_deto_mone         := null;
    v_movi_tiva_codi              := null;
    v_movi_serv_movi_codi         := null;
    v_movi_serv_sald_mone         := null;
    v_movi_serv_sald_mmnn         := null;
    v_movi_soco_codi              := null;
    v_movi_inmu_codi              := null;
    v_movi_indi_expe_proc         := null;
    v_movi_liqu_codi              := null;
    v_movi_liqu_codi_expe         := null;
    v_movi_vale_indi_impo         := null;
    v_movi_form_entr_codi         := null;
    v_movi_indi_tipo_pres         := null;
    v_movi_soma_codi              := null;
    v_movi_indi_entr_depo         := null;
    v_movi_impo_mone_ii           := null;
    v_movi_impo_mmnn_ii           := null;
    v_movi_grav10_ii_mone         := null;
    v_movi_grav5_ii_mone          := null;
    v_movi_grav10_ii_mmnn         := null;
    v_movi_grav5_ii_mmnn          := null;
    v_movi_grav10_mone            := null;
    v_movi_grav5_mone             := null;
    v_movi_grav10_mmnn            := null;
    v_movi_grav5_mmnn             := null;
    v_movi_iva10_mone             := null;
    v_movi_iva5_mone              := null;
    v_movi_iva10_mmnn             := null;
    v_movi_iva5_mmnn              := null;
    v_movi_inve_codi              := bcab.movi_inve_codi;
    v_movi_clpr_sucu_nume_item    := bcab.sucu_nume_item;
    v_movi_nume_oc                := bcab.movi_nume_oc;
  
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
                        v_movi_orte_codi,
                        v_movi_form_entr_codi,
                        v_movi_sub_clpr_codi,
                        v_movi_indi_cobr_dife,
                        v_movi_nume_timb,
                        V_MOVI_NUME_AUTO_IMPR,
                        v_movi_fech_venc_timb,
                        null,
                        v_movi_indi_entr_depo,
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
                        v_movi_inve_codi,
                        v_movi_indi_diar,
                        v_movi_indi_cant_diar,
                        v_movi_indi_most_fech,
                        v_movi_clpr_sucu_nume_item,
                        v_movi_nume_oc);
  
    -- ahora insertar la salida por produccion (-)
    -- asignar valores....
    --bcab.movi_codi_padr       := bcab.movi_codi;
    --bcab.movi_codi            := fa_sec_come_movi;
    v_movi_codi_padr              := v_movi_codi;
    v_movi_codi                   := fa_sec_come_movi;
    parameter.p_movi_codi_kit_men := v_movi_codi;
    v_movi_timo_codi              := null;
    v_movi_clpr_codi              := null;
    v_movi_sucu_codi_orig         := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig         := bcab.movi_depo_codi_orig;
    v_movi_sucu_codi_dest         := null;
    v_movi_depo_codi_dest         := null;
    v_movi_oper_codi              := parameter.p_codi_oper_prod_men;
    v_movi_cuen_codi              := null;
    v_movi_mone_codi              := parameter.p_codi_mone_mmnn;
    v_movi_nume                   := bcab.movi_nume;
    v_movi_fech_emis              := bcab.movi_fech_emis;
    v_movi_fech_grab              := sysdate;
    v_movi_user                   := gen_user;
    --v_movi_codi_padr           := bcab.movi_codi_padr;
    v_movi_tasa_mone           := 1;
    v_movi_tasa_mmee           := null;
    v_movi_grav_mmnn           := 0;
    v_movi_exen_mmnn           := v_cost_tota;
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := 0;
    v_movi_exen_mmee           := 0;
    v_movi_iva_mmee            := 0;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := v_cost_tota;
    v_movi_iva_mone            := 0;
    v_movi_obse                := 'Generacion por factura ' ||
                                  bcab.movi_nume || ' kit ' ||
                                  bdet.prod_codi_alfa;
    v_movi_sald_mmnn           := 0;
    v_movi_sald_mmee           := 0;
    v_movi_sald_mone           := 0;
    v_movi_stoc_suma_rest      := fp_dev_indi_suma_rest(parameter.p_codi_oper_prod_men);
    v_movi_clpr_dire           := null;
    v_movi_clpr_tele           := null;
    v_movi_clpr_ruc            := null;
    v_movi_clpr_desc           := null;
    v_movi_emit_reci           := null;
    v_movi_afec_sald           := null;
    v_movi_dbcr                := null;
    v_movi_stoc_afec_cost_prom := 'N';
    v_movi_empr_codi           := bcab.movi_empr_codi;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := null;
    v_movi_obse_deta           := null;
    v_movi_base                := parameter.p_codi_base;
    v_movi_ortr_codi           := null;
    v_movi_codi_padr_vali      := null;
    v_movi_rrhh_movi_codi      := null;
    v_movi_asie_codi           := null;
    v_movi_orpa_codi           := null;
    v_movi_impo_codi           := null;
    v_movi_indi_conta          := null;
    v_movi_nume_timb           := null;
    v_movi_excl_cont           := null;
    v_movi_impo_dife_camb      := null;
    v_movi_mone_codi_liqu      := null;
    v_movi_mone_liqu           := null;
    v_movi_tasa_mone_liqu      := null;
    v_movi_impo_mone_liqu      := null;
    v_movi_codi_rete           := null;
    v_movi_orpe_codi           := null;
    v_movi_cons_codi           := null;
    v_movi_indi_inte           := null;
    v_movi_indi_deve_gene      := null;
    v_movi_fech_oper           := bcab.movi_fech_emis;
    v_movi_fech_venc_timb      := null;
    v_movi_orpe_codi_loca      := null;
    v_movi_impo_reca           := null;
    v_movi_fech_inic_tras      := null;
    v_movi_fech_term_tras      := null;
    v_movi_tran_codi           := null;
    v_movi_vehi_marc           := null;
    v_movi_vehi_chap           := null;
    v_movi_cont_tran_nomb      := null;
    v_movi_cont_tran_ruc       := null;
    v_movi_cond_empl_codi      := null;
    v_movi_cond_nomb           := null;
    v_movi_cond_cedu_nume      := null;
    v_movi_cond_dire           := null;
    v_movi_sucu_codi_movi      := null;
    v_movi_depo_codi_movi      := null;
    v_movi_impo_deto           := null;
    v_movi_orte_codi           := null;
    v_movi_cheq_indi_desc      := null;
    v_movi_indi_liqu_tarj      := null;
    v_movi_impo_deto_mone      := null;
    v_movi_tiva_codi           := null;
    v_movi_serv_movi_codi      := null;
    v_movi_serv_sald_mone      := null;
    v_movi_serv_sald_mmnn      := null;
    v_movi_soco_codi           := null;
    v_movi_inmu_codi           := null;
    v_movi_indi_expe_proc      := null;
    v_movi_liqu_codi           := null;
    v_movi_liqu_codi_expe      := null;
    v_movi_vale_indi_impo      := null;
    v_movi_form_entr_codi      := null;
    v_movi_indi_tipo_pres      := null;
    v_movi_soma_codi           := null;
    v_movi_indi_entr_depo      := null;
    v_movi_impo_mone_ii        := null;
    v_movi_impo_mmnn_ii        := null;
    v_movi_grav10_ii_mone      := null;
    v_movi_grav5_ii_mone       := null;
    v_movi_grav10_ii_mmnn      := null;
    v_movi_grav5_ii_mmnn       := null;
    v_movi_grav10_mone         := null;
    v_movi_grav5_mone          := null;
    v_movi_grav10_mmnn         := null;
    v_movi_grav5_mmnn          := null;
    v_movi_iva10_mone          := null;
    v_movi_iva5_mone           := null;
    v_movi_iva10_mmnn          := null;
    v_movi_iva5_mmnn           := null;
    v_movi_indi_diar           := bcab.movi_indi_diar;
    v_movi_indi_cant_diar      := bcab.movi_indi_cant_diar;
    v_movi_indi_most_fech      := bcab.movi_indi_most_fech;
    v_movi_clpr_sucu_nume_item := bcab.sucu_nume_item;
    v_movi_nume_oc             := bcab.movi_nume_oc;
  
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
                        v_movi_orte_codi,
                        v_movi_form_entr_codi,
                        v_movi_sub_clpr_codi,
                        v_movi_indi_cobr_dife,
                        v_movi_nume_timb,
                        V_MOVI_NUME_AUTO_IMPR,
                        v_movi_fech_venc_timb,
                        null,
                        v_movi_indi_entr_depo,
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
                        v_movi_inve_codi,
                        v_movi_indi_diar,
                        v_movi_indi_cant_diar,
                        v_movi_indi_most_fech,
                        v_movi_clpr_sucu_nume_item,
                        v_movi_nume_oc);
  
    /*if nvl(:bdet.w_merm_tota, 0) > 0 then
      -- ahora insertar la merma por produccion (-)
      -- asignar valores....
      --bcab.movi_codi_padr     := bcab.movi_codi;
      bcab.movi_codi_merm       := fa_sec_come_movi;
      v_movi_codi                := bcab.movi_codi_merm;
      v_movi_timo_codi           := null;
      v_movi_clpr_codi           := null;
      v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
      v_movi_depo_codi_orig      := bcab.movi_depo_codi_orig;
      v_movi_sucu_codi_dest      := null;
      v_movi_depo_codi_dest      := null;
      v_movi_oper_codi           := parameter.p_codi_oper_merm_prod;
      v_movi_cuen_codi           := null;
      v_movi_mone_codi           := parameter.p_codi_mone_mmnn;
      v_movi_nume                := bcab.movi_nume;
      v_movi_fech_emis           := bcab.movi_fech_emis;
      v_movi_fech_grab           := sysdate;
      v_movi_user                := gen_user;
      v_movi_codi_padr           := bcab.movi_codi_padr;
      v_movi_tasa_mone           := 1;
      v_movi_tasa_mmee           := null;
      v_movi_grav_mmnn           := 0;
      v_movi_exen_mmnn           := 0;
      v_movi_iva_mmnn            := 0;
      v_movi_grav_mmee           := 0;
      v_movi_exen_mmee           := 0;
      v_movi_iva_mmee            := 0;
      v_movi_grav_mone           := 0;
      v_movi_exen_mone           := 0;
      v_movi_iva_mone            := 0;
      v_movi_obse                := bcab.movi_obse;
      v_movi_sald_mmnn           := 0;
      v_movi_sald_mmee           := 0;
      v_movi_sald_mone           := 0;
      v_movi_stoc_suma_rest      := fp_dev_indi_suma_rest(parameter.p_codi_oper_merm_prod);
      v_movi_clpr_dire           := null;
      v_movi_clpr_tele           := null;
      v_movi_clpr_ruc            := null;
      v_movi_clpr_desc           := null;
      v_movi_emit_reci           := null;
      v_movi_afec_sald           := null;
      v_movi_dbcr                := null;
      v_movi_stoc_afec_cost_prom := 'N';
      v_movi_empr_codi           := bcab.movi_empr_codi;
      v_movi_clave_orig          := null;
      v_movi_clave_orig_padr     := null;
      v_movi_indi_iva_incl       := null;
      v_movi_empl_codi           := null;
      v_movi_obse_deta           := null;
      v_movi_base                := parameter.p_codi_base;
      v_movi_ortr_codi           := null;
      v_movi_codi_padr_vali      := null;
      v_movi_rrhh_movi_codi      := null;
      v_movi_asie_codi           := null;
      v_movi_orpa_codi           := null;
      v_movi_impo_codi           := null;
      v_movi_indi_conta          := null;
      v_movi_nume_timb           := null;
      v_movi_excl_cont           := null;
      v_movi_impo_dife_camb      := null;
      v_movi_mone_codi_liqu      := null;
      v_movi_mone_liqu           := null;
      v_movi_tasa_mone_liqu      := null;
      v_movi_impo_mone_liqu      := null;
      v_movi_codi_rete           := null;
      v_movi_orpe_codi           := null;
      v_movi_cons_codi           := null;
      v_movi_indi_inte           := null;
      v_movi_indi_deve_gene      := null;
      v_movi_fech_oper           := bcab.movi_fech_emis;
      v_movi_fech_venc_timb      := null;
      v_movi_orpe_codi_loca      := null;
      v_movi_impo_reca           := null;
      v_movi_fech_inic_tras      := null;
      v_movi_fech_term_tras      := null;
      v_movi_tran_codi           := null;
      v_movi_vehi_marc           := null;
      v_movi_vehi_chap           := null;
      v_movi_cont_tran_nomb      := null;
      v_movi_cont_tran_ruc       := null;
      v_movi_cond_empl_codi      := null;
      v_movi_cond_nomb           := null;
      v_movi_cond_cedu_nume      := null;
      v_movi_cond_dire           := null;
      v_movi_sucu_codi_movi      := null;
      v_movi_depo_codi_movi      := null;
      v_movi_impo_deto           := null;
      v_movi_orte_codi           := null;
      v_movi_cheq_indi_desc      := null;
      v_movi_indi_liqu_tarj      := null;
      v_movi_impo_deto_mone      := null;
      v_movi_tiva_codi           := null;
      v_movi_serv_movi_codi      := null;
      v_movi_serv_sald_mone      := null;
      v_movi_serv_sald_mmnn      := null;
      v_movi_soco_codi           := null;
      v_movi_inmu_codi           := null;
      v_movi_indi_expe_proc      := null;
      v_movi_liqu_codi           := null;
      v_movi_liqu_codi_expe      := null;
      v_movi_vale_indi_impo      := null;
      v_movi_form_entr_codi      := null;
      v_movi_indi_tipo_pres      := null;
      v_movi_soma_codi           := null;
      v_movi_zara_tipo           := bcab.movi_zara_tipo;
      v_movi_clas_codi           := bcab.clas_codi_alte;
      
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
                          v_movi_obse_deta,
                          v_movi_base,
                          v_movi_ortr_codi,
                          v_movi_codi_padr_vali,
                          v_movi_rrhh_movi_codi,
                          v_movi_asie_codi,
                          v_movi_orpa_codi,
                          v_movi_impo_codi,
                          v_movi_indi_conta,
                          v_movi_nume_timb,
                          v_movi_excl_cont,
                          v_movi_impo_dife_camb,
                          v_movi_mone_codi_liqu,
                          v_movi_mone_liqu,
                          v_movi_tasa_mone_liqu,
                          v_movi_impo_mone_liqu,
                          v_movi_codi_rete,
                          v_movi_orpe_codi,
                          v_movi_cons_codi,
                          v_movi_indi_inte,
                          v_movi_indi_deve_gene,
                          v_movi_fech_oper,
                          v_movi_fech_venc_timb,
                          v_movi_orpe_codi_loca,
                          v_movi_impo_reca,
                          v_movi_fech_inic_tras,
                          v_movi_fech_term_tras,
                          v_movi_tran_codi,
                          v_movi_vehi_marc,
                          v_movi_vehi_chap,
                          v_movi_cont_tran_nomb,
                          v_movi_cont_tran_ruc,
                          v_movi_cond_empl_codi,
                          v_movi_cond_nomb,
                          v_movi_cond_cedu_nume,
                          v_movi_cond_dire,
                          v_movi_sucu_codi_movi,
                          v_movi_depo_codi_movi,
                          v_movi_impo_deto,
                          v_movi_orte_codi,
                          v_movi_cheq_indi_desc,
                          v_movi_indi_liqu_tarj,
                          v_movi_impo_deto_mone,
                          v_movi_tiva_codi,
                          v_movi_serv_movi_codi,
                          v_movi_serv_sald_mone,
                          v_movi_serv_sald_mmnn,
                          v_movi_soco_codi,
                          v_movi_inmu_codi,
                          v_movi_indi_expe_proc,
                          v_movi_liqu_codi,
                          v_movi_liqu_codi_expe,
                          v_movi_vale_indi_impo,
                          v_movi_form_entr_codi,
                          v_movi_indi_tipo_pres,
                          v_movi_soma_codi,
                          v_movi_zara_tipo,
                          v_movi_clas_codi);
    end if;*/
  end;

  procedure pp_actualiza_movi_prod_kit is
    v_deta_movi_codi           number(20);
    v_deta_nume_item           number(5);
    v_deta_impu_codi           number(10);
    v_deta_prod_codi           number(20);
    v_deta_cant                number(20, 4);
    v_deta_obse                varchar2(2000);
    v_deta_porc_deto           number(20, 6);
    v_deta_impo_mone           number(20, 4);
    v_deta_impo_mmnn           number(20, 4);
    v_deta_impo_mmee           number(20, 4);
    v_deta_iva_mmnn            number(20, 4);
    v_deta_iva_mmee            number(20, 4);
    v_deta_iva_mone            number(20, 4);
    v_deta_prec_unit           number(20, 4);
    v_deta_movi_codi_padr      number(20);
    v_deta_nume_item_padr      number(5);
    v_deta_impo_mone_deto_nc   number(20, 4);
    v_deta_movi_codi_deto_nc   number(20);
    v_deta_list_codi           number(4);
    v_deta_movi_clave_orig     number(20);
    v_deta_impo_mmnn_deto_nc   number(20, 4);
    v_deta_base                number(2);
    v_deta_lote_codi           number(10);
    v_deta_movi_orig_codi      number(20);
    v_deta_movi_orig_item      number(4);
    v_deta_impo_mmee_deto_nc   number(20, 4);
    v_deta_asie_codi           number(10);
    v_deta_cant_medi           number(20, 4);
    v_deta_medi_codi           number(10);
    v_deta_remi_codi           number(20);
    v_deta_remi_nume_item      number(5);
    v_deta_bien_codi           number(20);
    v_deta_prec_unit_list      number(20, 4);
    v_deta_impo_deto_mone      number(20, 4);
    v_deta_porc_deto_prec      number(20, 6);
    v_deta_bene_codi           number(4);
    v_deta_ceco_codi           number(20);
    v_deta_clpr_codi           number(20);
    v_deta_movi_codi_merm      number(20);
    v_deta_nume_item_merm      number(5);
    v_deta_impo_mone_ii        number;
    v_deta_impo_mmnn_ii        number;
    v_deta_grav10_ii_mone      number;
    v_deta_grav5_ii_mone       number;
    v_deta_grav10_ii_mmnn      number;
    v_deta_grav5_ii_mmnn       number;
    v_deta_grav10_mone         number;
    v_deta_grav5_mone          number;
    v_deta_grav10_mmnn         number;
    v_deta_grav5_mmnn          number;
    v_deta_iva10_mone          number;
    v_deta_iva5_mone           number;
    v_deta_iva10_mmnn          number;
    v_deta_iva5_mmnn           number;
    v_deta_exen_mone           number;
    v_deta_exen_mmnn           number;
    v_deta_exde_codi           number;
    v_deta_exde_tipo           varchar2(1);
    v_deta_prod_codi_barr      varchar2(30);
    v_deta_prod_prec_maxi_deto number;
    v_deta_prec_maxi_deto_exce number;
  
    v_cost_tota number;
  
    cursor c_temp is
      select t.kide_prod_comp_codi,
             t.kide_cant_fini kide_cant,
             t.kide_medi_codi,
             t.kide_fact_conv,
             t.kide_cost_prom_mmnn
        from temp_fact_prod_kit t
       where t.kide_nume_item = bdet.deta_nume_item
       order by t.kide_nume_item, t.kide_prod_comp_codi;
  
  begin
    select nvl(round(sum(round((nvl(t.kide_cant_fini, 0) *
                               nvl(t.kide_fact_conv, 1)) *
                               nvl(bdet.deta_cant, 0),
                               parameter.p_cant_deci_cant) *
                         nvl(t.kide_cost_prom_mmnn, 0)),
                     parameter.p_cant_deci_mmnn),
               0)
      into v_cost_tota
      from temp_fact_prod_kit t
     where t.kide_nume_item = bdet.deta_nume_item;
  
    -- insertar el detalle para ingreso, salida y merma por produccion
    v_deta_movi_codi           := parameter.p_movi_codi_kit_mas;
    v_deta_nume_item           := 1;
    v_deta_impu_codi           := null;
    v_deta_prod_codi           := bdet.deta_prod_codi;
    v_deta_cant                := round(nvl(bdet.deta_cant, 0),
                                        parameter.p_cant_deci_cant);
    v_deta_obse                := null;
    v_deta_porc_deto           := null;
    v_deta_impo_mone           := v_cost_tota;
    v_deta_impo_mmnn           := v_cost_tota;
    v_deta_impo_mmee           := 0;
    v_deta_iva_mmnn            := 0;
    v_deta_iva_mmee            := 0;
    v_deta_iva_mone            := 0;
    v_deta_prec_unit           := 0;
    v_deta_movi_codi_padr      := null;
    v_deta_nume_item_padr      := null;
    v_deta_impo_mone_deto_nc   := null;
    v_deta_movi_codi_deto_nc   := null;
    v_deta_list_codi           := null;
    v_deta_movi_clave_orig     := null;
    v_deta_impo_mmnn_deto_nc   := null;
    v_deta_base                := parameter.p_codi_base;
    v_deta_lote_codi           := null;
    v_deta_movi_orig_codi      := null;
    v_deta_movi_orig_item      := null;
    v_deta_impo_mmee_deto_nc   := null;
    v_deta_asie_codi           := null;
    v_deta_cant_medi           := bdet.deta_cant_medi;
    v_deta_medi_codi           := bdet.deta_medi_codi;
    v_deta_remi_codi           := null;
    v_deta_remi_nume_item      := null;
    v_deta_bien_codi           := null;
    v_deta_prec_unit_list      := null;
    v_deta_impo_deto_mone      := null;
    v_deta_porc_deto_prec      := null;
    v_deta_bene_codi           := null;
    v_deta_ceco_codi           := null;
    v_deta_clpr_codi           := null;
    v_deta_impo_mone_ii        := 0;
    v_deta_impo_mmnn_ii        := 0;
    v_deta_grav10_ii_mone      := 0;
    v_deta_grav5_ii_mone       := 0;
    v_deta_grav10_ii_mmnn      := 0;
    v_deta_grav5_ii_mmnn       := 0;
    v_deta_grav10_mone         := 0;
    v_deta_grav5_mone          := 0;
    v_deta_grav10_mmnn         := 0;
    v_deta_grav5_mmnn          := 0;
    v_deta_iva10_mone          := 0;
    v_deta_iva5_mone           := 0;
    v_deta_iva10_mmnn          := 0;
    v_deta_iva5_mmnn           := 0;
    v_deta_exen_mone           := 0;
    v_deta_exen_mmnn           := 0;
    v_deta_exde_codi           := null;
    v_deta_exde_tipo           := null;
    v_deta_prod_codi_barr      := bdet.coba_codi_barr;
    v_deta_prod_prec_maxi_deto := bdet.deta_prod_prec_maxi_deto;
    v_deta_prec_maxi_deto_exce := bdet.deta_prod_prec_maxi_deto_exen;
  
    pp_insert_come_movi_prod_deta(v_deta_movi_codi,
                                  v_deta_nume_item,
                                  v_deta_impu_codi,
                                  v_deta_prod_codi,
                                  v_deta_cant,
                                  v_deta_obse,
                                  v_deta_porc_deto,
                                  v_deta_impo_mone,
                                  v_deta_impo_mmnn,
                                  v_deta_impo_mmee,
                                  v_deta_iva_mmnn,
                                  v_deta_iva_mmee,
                                  v_deta_iva_mone,
                                  v_deta_prec_unit,
                                  v_deta_movi_codi_padr,
                                  v_deta_nume_item_padr,
                                  v_deta_impo_mone_deto_nc,
                                  v_deta_movi_codi_deto_nc,
                                  v_deta_list_codi,
                                  v_deta_lote_codi,
                                  v_deta_cant_medi,
                                  v_deta_medi_codi,
                                  v_deta_remi_codi,
                                  v_deta_remi_nume_item,
                                  v_deta_prec_unit_list,
                                  v_deta_impo_deto_mone,
                                  v_deta_porc_deto_prec,
                                  v_deta_impo_mone_ii,
                                  v_deta_impo_mmnn_ii,
                                  v_deta_grav10_ii_mone,
                                  v_deta_grav5_ii_mone,
                                  v_deta_grav10_ii_mmnn,
                                  v_deta_grav5_ii_mmnn,
                                  v_deta_grav10_mone,
                                  v_deta_grav5_mone,
                                  v_deta_grav10_mmnn,
                                  v_deta_grav5_mmnn,
                                  v_deta_iva10_mone,
                                  v_deta_iva5_mone,
                                  v_deta_iva10_mmnn,
                                  v_deta_iva5_mmnn,
                                  v_deta_exen_mone,
                                  v_deta_exen_mmnn,
                                  v_deta_exde_codi,
                                  v_deta_exde_tipo,
                                  v_deta_prod_codi_barr,
                                  v_deta_prod_prec_maxi_deto,
                                  v_deta_prec_maxi_deto_exce);
  
    v_deta_movi_codi      := parameter.p_movi_codi_kit_men;
    v_deta_movi_codi_merm := null; --bcab.movi_codi_merm;
    v_deta_nume_item_merm := 0;
    v_deta_nume_item      := 0;
  
    for k in c_temp loop
      v_deta_nume_item           := v_deta_nume_item + 1;
      v_deta_impu_codi           := null;
      v_deta_prod_codi           := k.kide_prod_comp_codi;
      v_deta_cant                := round((nvl(k.kide_cant, 0) *
                                          nvl(k.kide_fact_conv, 1)) *
                                          nvl(bdet.deta_cant, 0),
                                          parameter.p_cant_deci_cant);
      v_deta_obse                := null;
      v_deta_porc_deto           := null;
      v_deta_impo_mone           := round(round((nvl(k.kide_cant, 0) *
                                                nvl(k.kide_fact_conv, 1)) *
                                                nvl(bdet.deta_cant, 0),
                                                parameter.p_cant_deci_cant) *
                                          nvl(k.kide_cost_prom_mmnn, 0),
                                          parameter.p_cant_deci_mmnn);
      v_deta_impo_mmnn           := v_deta_impo_mone;
      v_deta_impo_mmee           := 0;
      v_deta_iva_mmnn            := 0;
      v_deta_iva_mmee            := 0;
      v_deta_iva_mone            := 0;
      v_deta_prec_unit           := 0;
      v_deta_movi_codi_padr      := null;
      v_deta_nume_item_padr      := null;
      v_deta_impo_mone_deto_nc   := null;
      v_deta_movi_codi_deto_nc   := null;
      v_deta_list_codi           := null;
      v_deta_movi_clave_orig     := null;
      v_deta_impo_mmnn_deto_nc   := null;
      v_deta_base                := parameter.p_codi_base;
      v_deta_lote_codi           := null;
      v_deta_movi_orig_codi      := null;
      v_deta_movi_orig_item      := null;
      v_deta_impo_mmee_deto_nc   := null;
      v_deta_asie_codi           := null;
      v_deta_cant_medi           := round(nvl(k.kide_cant, 0) *
                                          nvl(bdet.deta_cant, 0),
                                          parameter.p_cant_deci_cant);
      v_deta_medi_codi           := k.kide_medi_codi;
      v_deta_remi_codi           := null;
      v_deta_remi_nume_item      := null;
      v_deta_bien_codi           := null;
      v_deta_prec_unit_list      := null;
      v_deta_impo_deto_mone      := null;
      v_deta_porc_deto_prec      := null;
      v_deta_bene_codi           := null;
      v_deta_ceco_codi           := null;
      v_deta_clpr_codi           := null;
      v_deta_impo_mone_ii        := 0;
      v_deta_impo_mmnn_ii        := 0;
      v_deta_grav10_ii_mone      := 0;
      v_deta_grav5_ii_mone       := 0;
      v_deta_grav10_ii_mmnn      := 0;
      v_deta_grav5_ii_mmnn       := 0;
      v_deta_grav10_mone         := 0;
      v_deta_grav5_mone          := 0;
      v_deta_grav10_mmnn         := 0;
      v_deta_grav5_mmnn          := 0;
      v_deta_iva10_mone          := 0;
      v_deta_iva5_mone           := 0;
      v_deta_iva10_mmnn          := 0;
      v_deta_iva5_mmnn           := 0;
      v_deta_exen_mone           := 0;
      v_deta_exen_mmnn           := 0;
      v_deta_exde_codi           := null;
      v_deta_exde_tipo           := null;
      v_deta_prod_codi_barr      := bdet.coba_codi_barr;
      v_deta_prod_prec_maxi_deto := null;
      v_deta_prec_maxi_deto_exce := null;
    
      pp_insert_come_movi_prod_deta(v_deta_movi_codi,
                                    v_deta_nume_item,
                                    v_deta_impu_codi,
                                    v_deta_prod_codi,
                                    v_deta_cant,
                                    v_deta_obse,
                                    v_deta_porc_deto,
                                    v_deta_impo_mone,
                                    v_deta_impo_mmnn,
                                    v_deta_impo_mmee,
                                    v_deta_iva_mmnn,
                                    v_deta_iva_mmee,
                                    v_deta_iva_mone,
                                    v_deta_prec_unit,
                                    v_deta_movi_codi_padr,
                                    v_deta_nume_item_padr,
                                    v_deta_impo_mone_deto_nc,
                                    v_deta_movi_codi_deto_nc,
                                    v_deta_list_codi,
                                    v_deta_lote_codi,
                                    v_deta_cant_medi,
                                    v_deta_medi_codi,
                                    v_deta_remi_codi,
                                    v_deta_remi_nume_item,
                                    v_deta_prec_unit_list,
                                    v_deta_impo_deto_mone,
                                    v_deta_porc_deto_prec,
                                    v_deta_impo_mone_ii,
                                    v_deta_impo_mmnn_ii,
                                    v_deta_grav10_ii_mone,
                                    v_deta_grav5_ii_mone,
                                    v_deta_grav10_ii_mmnn,
                                    v_deta_grav5_ii_mmnn,
                                    v_deta_grav10_mone,
                                    v_deta_grav5_mone,
                                    v_deta_grav10_mmnn,
                                    v_deta_grav5_mmnn,
                                    v_deta_iva10_mone,
                                    v_deta_iva5_mone,
                                    v_deta_iva10_mmnn,
                                    v_deta_iva5_mmnn,
                                    v_deta_exen_mone,
                                    v_deta_exen_mmnn,
                                    v_deta_exde_codi,
                                    v_deta_exde_tipo,
                                    v_deta_prod_codi_barr,
                                    v_deta_prod_prec_maxi_deto,
                                    v_deta_prec_maxi_deto_exce);
    
    end loop;
  
  end pp_actualiza_movi_prod_kit;

  procedure pp_gene_mens is
    v_codi    number;
    v_aux     varchar(2000);
    v_user    varchar(60);
    v_formato varchar(60);
  
    cursor c_user(p_clpr_codi in number) is
      select u.user_login
        from come_clie_prov cp, come_empl e, segu_user u
       where cp.clpr_empl_codi = e.empl_codi
         and e.empl_codi = u.user_empl_codi
         and cp.clpr_codi = p_clpr_codi;
  
  begin
    select user_desc
      into v_user
      from segu_user
     where upper(user_login) = upper(gen_user);
  
    if bcab.movi_mone_cant_deci = 0 then
      v_formato := '999G999G990';
    else
      v_formato := '999G999G990D90';
    end if;
  
    if bcab.pres_nume is not null then
      for x in c_user(bcab.movi_clpr_codi) loop
        v_codi := fa_sec_come_mens_sist;
        v_aux  := 'El Pedido Nro. ' || bcab.pres_nume || ' Cod. ' ||
                  bcab.s_clpr_codi_alte || ' ' || bcab.movi_clpr_desc ||
                  ', ha sido facturado por ' || v_user ||
                  ', por un valor de ' || bcab.movi_mone_desc_abre || ' ' ||
                  to_char(bcab.s_total,
                          rtrim(ltrim(v_formato)),
                          'NLS_NUMERIC_CHARACTERS = '',.''');
      
        insert into come_mens_sist
          (mesi_codi,
           mesi_desc,
           mesi_user_dest,
           mesi_user_envi,
           mesi_fech,
           mesi_indi_leid)
        values
          (v_codi, v_aux, x.user_login, gen_user, sysdate, 'N');
      end loop;
    end if;
  
  end;

  /******************** reportes *****************************************/

  procedure pp_llamar_reporte_facturas(p_usuario in varchar2,
                                       p_codigo  in number) is
    nombre       varchar2(50);
    parametros   varchar2(50);
    contenedores clob;
  begin
  
    nombre       := 'factura';
    contenedores := 'p_movi_codi';
    parametros   := p_codigo;
  
    delete from come_parametros_report where usuario = p_usuario;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (parametros, p_usuario, nombre, 'pdf', contenedores);
  
  end pp_llamar_reporte_facturas;

  /********************* funciones ***************************************/
  function fp_buscar_come_depo_alte(p_depo_empr_codi in number,
                                    p_busc_dato      in varchar2,
                                    p_depo_codi_alte out varchar2)
    return boolean is
  begin
  
    if nvl(parameter.p_indi_vali_depo_user_fact, 'S') = 'S' then
      select d.depo_codi_alte
        into p_depo_codi_alte
        from come_depo d, segu_user_depo_orig du, segu_user u
       where d.depo_empr_codi = p_depo_empr_codi
            --and d.depo_indi_fact = 'S'
         and d.depo_codi_alte = p_busc_dato
         and d.depo_codi = du.udor_depo_codi
         and du.udor_user_codi = u.user_codi
         and u.user_login = user;
    else
      select d.depo_codi_alte
        into p_depo_codi_alte
        from come_depo d
       where d.depo_empr_codi = p_depo_empr_codi
            --and d.depo_indi_fact = 'S'
         and d.depo_codi_alte = p_busc_dato;
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

  function fp_exis_pres return boolean is
    v_count number;
  begin
    select count(a.pres_nume)
      into v_count
      from come_pres_clie a
     where a.pres_nume = v('P20_PRES_NUME');
    if v_count > 0 then
      return true;
    else
      return false;
    end if;
  end;

  function fp_cost_ulti_comp(p_prod_codi           in number,
                             p_movi_tasa_mone      in number,
                             p_movi_mone_cant_deci in number,
                             p_movi_mone_codi      in number) return number is
  
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
      if p_movi_mone_codi <> parameter.p_codi_mone_mmnn then
        v_cost := round(v_cost * p_movi_tasa_mone, p_movi_mone_cant_deci);
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
      
        if p_movi_mone_codi <> parameter.p_codi_mone_mmnn then
          v_cost := round(v_cost * p_movi_tasa_mone, p_movi_mone_cant_deci);
        else
          v_cost := round(v_cost, parameter.p_cant_deci_mmnn);
        end if;
    end;
  
    return v_cost;
  end;

  function fp_dev_indi_suma_rest(p_oper_codi in number) return char is
    v_stoc_suma_rest char(1);
  begin
    select oper_stoc_suma_rest
      into v_stoc_suma_rest
      from come_stoc_oper
     where oper_codi = p_oper_codi;
  
    return v_stoc_suma_rest;
  
  exception
    when no_data_found then
      pl_me('Codigo de Operacion Inexistente');
  end;

  function fp_retu_prod_deta(v_prod_codi in number) return number is
    v_cant number;
  
  begin
  
    select count(*)
      into v_cant
      from come_prod, come_prod_coba_deta d
     where d.coba_prod_codi = prod_codi
       and prod_codi = v_prod_codi;
  
    if v_cant = 1 then
      v_cant := 1;
    elsif v_cant > 1 then
      v_cant := 2;
    end if;
    return v_cant;
  end;

  procedure pl_muestra_come_stoc_oper(p_oper_codi      in number,
                                      p_oper_Desc      out char,
                                      p_oper_Desc_abre out char,
                                      p_suma_rest      out char,
                                      p_afec_cost_prom out char) is
  begin
  
    select oper_desc,
           oper_desc_abre,
           oper_stoc_suma_rest,
           oper_stoc_afec_cost_prom
      into p_oper_desc, p_oper_desc_abre, p_suma_rest, p_afec_cost_prom
      from come_stoc_oper
     where oper_codi = p_oper_codi;
  
  exception
    when no_data_found then
      p_oper_desc_abre := null;
      p_oper_desc      := null;
      p_suma_rest      := null;
      p_afec_cost_prom := null;
      pl_me('Operacion de Stock Inexistente!');
    when others then
      raise_application_Error(-20010, 'Error al momento');
    
  end;

/*************** PROCEDIMIENTO DE ARRANQUE   ****************/
begin

  if parameter.p_indi_most_form_pago = 'N' then
    parameter.p_indi_obli_form_pago := 'N';
  end if;

  if parameter.p_indi_most_form_entr = 'N' then
    parameter.p_indi_obli_form_entr := 'N';
  end if;

  pa_devu_fech_habi(p_fech_inic, p_fech_fini);

  v_aux := 1;

end;
