
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020337" is

  
 type r_parameter is record(
   
  p_cant_dias_feri             number := 0,

  p_codi_timo_extr_banc        number := to_number(general_skn.fl_busca_parametro ('p_codi_timo_extr_banc')),
  p_codi_conc_cheq_cred        number := to_number(general_skn.fl_busca_parametro ('p_codi_conc_cheq_cred')),
  p_modi_fech_fopa_dife        varchar2(10) := 'N',
  p_cobr_vent_indi_cobr_fp     varchar2(10) := 'N',
  p_hoja_ruta_indi_cobr_fp     varchar2(10) := 'N', 
  p_indi_apli_rete_exen        varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_apli_rete_exen'))), 
  p_codi_oper_com              number := to_number(general_skn.fl_busca_parametro ('p_codi_oper_com')),
  p_indi_most_secc_dbcr        varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_secc_dbcr'))),
  p_indi_exig_talo             varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_exig_talo'))), 
  p_codi_timo_fcor             number := to_number(general_skn.fl_busca_parametro ('p_codi_timo_fcor')),
  p_codi_timo_fcrr             number := to_number(general_skn.fl_busca_parametro ('p_codi_timo_fcrr')),
  p_codi_timo_pcor             number := to_number(general_skn.fl_busca_parametro ('p_codi_timo_pcor')),
  p_codi_timo_rete_emit        number := to_number(general_skn.fl_busca_parametro ('p_codi_timo_rete_emit')),
  p_codi_impu_exen             number := to_number(general_skn.fl_busca_parametro ('p_codi_impu_exen')),                        
  p_codi_impu_grav10           number := to_number(general_skn.fl_busca_parametro ('p_codi_impu_grav10')),   
  p_codi_impu_grav5            number := to_number(general_skn.fl_busca_parametro ('p_codi_impu_grav5')),   
  p_codi_mone_mmnn             number := to_number(general_skn.fl_busca_parametro ('p_codi_mone_mmnn')),   
  p_cant_deci_porc             number := to_number(general_skn.fl_busca_parametro ('p_cant_deci_porc')),   
  p_cant_deci_mmnn             number := to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmnn')),   
  p_cant_deci_mmee             number := to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmee')),   
  p_cant_deci_cant             number := to_number(general_skn.fl_busca_parametro ('p_cant_deci_cant')),   
  p_cant_deci_prec_unit        number := to_number(general_skn.fl_busca_parametro ('p_cant_deci_prec_unit')),  
  p_indi_impr_cheq_emit        varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_impr_cheq_emit'))),  
  p_indi_vali_repe_cheq        varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_repe_cheq'))), 
  p_indi_habi_vuelto           varchar2(10) := general_skn.fl_busca_parametro('p_indi_habi_vuelto_cob'),
  p_habi_camp_cent_cost_dbcr   varchar2(100) := rtrim(ltrim(general_skn.fl_busca_parametro('p_habi_camp_cent_cost_dbcr'))),    
  p_codi_clie_espo             varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_clie_espo')),                        
  p_codi_prov_espo             varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_prov_espo')),                        
  p_form_impr_dbcr_auto        varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_dbcr_auto'))),
  p_form_impr_dbcr_fcor        varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_dbcr_fcor'))),
  p_form_impr_movi_cont        varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_movi_cont'))),
  p_indi_perm_fech_futu_dbcr   varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro ('p_indi_perm_fech_futu_dbcr'))),
  p_codi_base                  varchar2(100) := pack_repl.fa_devu_codi_base,   
  p_fech_inic                  varchar2(100),
  p_fech_fini                  varchar2(110),
  
  ---
  p_vali_deta                  varchar2(10),
 
  p_orden_cuco_nume            varchar2(5):= 'asc',
  p_orden_cuco_desc            varchar2(5):= 'asc',
  p_empr_codi                  varchar2(100) := v('AI_EMPR_CODI'),
  p_sucu_codi                  varchar2(100):=v('AI_SUCU_CODI'),
 /* pa_devu_fech_habi(p_fech_inic, p_fech_fini ),
  if upper(nvl(p_indi_perm_fech_futu_dbcr, 'N')) = 'S' then
     p_fech_fini := add_months(p_fech_fini,12),
  end if,
  
    
  bcab.movi_empr_codi      := p_empr_codi,
  bcab.movi_sucu_codi_orig := p_sucu_codi,
  
  if bcab.movi_empr_codi is not null then
     pl_muestra_come_empr(bcab.movi_empr_codi, bcab.movi_empr_desc),
  end if,
  
  if bcab.movi_sucu_codi_orig is not null then
     pl_muestra_come_sucu(bcab.movi_sucu_codi_orig, bcab.movi_sucu_desc_orig),
  end if,*/
  
  p_indi_vali_nume_dbcr          varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_nume_dbcr'))),
  p_imp_min_aplic_reten          number := to_number(general_skn.fl_busca_parametro('p_imp_min_aplic_reten')),
  p_porc_aplic_reten             number := to_number(general_skn.fl_busca_parametro('p_porc_aplic_reten')),
  p_codi_conc_rete_emit          number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_emit')),
  p_codi_conc_rete_reci          number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_reci')),
  p_form_calc_rete_emit          number := to_number(general_skn.fl_busca_parametro('p_form_calc_rete_emit')),
  p_indi_most_mens_sali          varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_sali'))),
  p_form_impr_rete               varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_rete'))),
  p_indi_impr_dbcr               varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_impr_dbcr'))),
  p_indi_porc_rete_sucu          varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_porc_rete_sucu'))),
  p_nave_dato_rete               varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_nave_dato_rete'))),
  p_apli_rete_exen_defe          varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_apli_rete_exen_defe'))),
  p_codi_conc_rete_rent_emit     number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_rent_emit')),
  p_porc_aplic_reten_iva_ext     number := to_number(general_skn.fl_busca_parametro('p_porc_aplic_reten_iva_ext')),
  p_porc_aplic_reten_rent        number := to_number(general_skn.fl_busca_parametro('p_porc_aplic_reten_rent')),
  p_porc_aplic_reten_rent_abso   number := to_number(general_skn.fl_busca_parametro('p_porc_aplic_reten_rent_abso')),
  
  p_indi_nave_dato_rete          varchar2(10) := 'N',
  p_para_inic                    varchar2(10) := 'DBCR',
  p_indi_modi                    varchar2(10) := 'N',
  p_empr_retentora               varchar2(100),
/*  if nvl(p_para_inic,'DBCR') = 'MDBCR' then
    p_indi_modi := 'S',
  else
    p_indi_modi := 'N',
  end if,*/
  
  --orden de servicio
  p_indi_rela_nume_serv           varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_rela_nume_serv'))),
  p_indi_perm_fech_vale_supe      varchar2(100) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_perm_fech_vale_supe'))),
  p_indi_most_desc_conc_dbcr      varchar2(10) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_most_desc_conc_dbcr'))),
  p_indi_rete_tesaka              varchar2(10) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_rete_tesaka'))),
  p_indi_most_chec_rete_mini      varchar2(10) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_most_chec_rete_mini'))),
  p_indi_asie_on_line             varchar2(10) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_asie_on_line'))),
  p_indi_auto_fact_impu_calc      varchar2(10) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_auto_fact_impu_calc'))),
  p_indi_fopa_chta_caja           varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro ('p_indi_fopa_chta_caja'))),
  p_peco_codi                     varchar2(100),
  p_movi_codi_rete                varchar2(100),
  p_indi_vali_timo                varchar2(100),
  p_emit_reci                     varchar2(100),
  p_vali_cabe                     varchar2(100)       
    );
  
  parameter r_parameter;
  

  type r_bsel is record(
   indi_regi_apli varchar2(2)
   );
   bsel r_bsel;

  type r_bcab is record(
   movi_codi           number,
   movi_tasa_mone      number,
   sald_apli_fact      number,
   movi_fech_apli      date,
   movi_mone_cant_deci  number,
   movi_grav10_ii_mone number,
   movi_grav5_ii_mone  number,
   movi_exen_mone      number,
   movi_impo_mone_ii   number,
   s_total             number,
   movi_grav10_ii_mmnn number,
   movi_grav5_ii_mmnn  number,
   movi_exen_mmnn      number,
   movi_iva10_mone     number,
   movi_iva5_mone      number,
   s_grav_10_ii        number,
   s_grav_5_ii         number,
   s_exen              number,
   s_iva_10            number,
   s_iva_5             number,
   s_tot_iva           number,
   movi_iva10_mmnn     number,
   movi_iva5_mmnn      number,
   movi_grav10_mone    number,
   movi_grav5_mone     number,
   movi_grav10_mmnn    number,
   movi_grav5_mmnn     number,
   movi_impo_mmnn_ii   number,
   movi_grav_mone      number,    
   movi_iva_mone       number,
   movi_grav_mmnn      number,     
   movi_iva_mmnn       number,
   movi_timo_indi_sald varchar2(20),
   movi_sald_mone      number,
   movi_sald_mmnn      number,
   movi_timo_indi_caja varchar2(20),
   s_impo_rete         number,
   movi_oper_codi      number,
   movi_fech_grab      date,
   movi_user           varchar2(60),
   movi_timo_codi      number,
   movi_clpr_codi      number,
   movi_sucu_codi_orig number,
   movi_mone_codi      number,
   movi_nume           number,
   movi_fech_emis      date,
   movi_fech_oper      date,
   movi_obse           varchar2(200),
   movi_stoc_suma_rest varchar2(1),
   movi_clpr_dire      varchar2(200),
   movi_clpr_tele      varchar2(200),
   movi_clpr_ruc       varchar2(200),
   movi_clpr_desc      varchar2(200),
   movi_emit_reci      varchar2(20),
   movi_afec_sald      varchar2(2),
   movi_dbcr           varchar2(2),
   movi_stoc_afec_cost_prom   varchar2(2),
   movi_empr_codi             number,
   fech_venc_timb             date,
   movi_nume_timb             number,
   sucu_nume_item             number,
   movi_empl_codi             number
   );
   bcab r_bcab;
  
  type r_bdet is record(
    f_dif_impo                    number,
    f_dif_impo_exen_mone          number,
    f_dif_impo_grav5_ii_mone      number,
    f_dif_impo_grav10_ii_mone     number,
    conc_indi_gast_judi           varchar2(1),
    moco_juri_codi                number,
    moco_conc_desc                varchar2(500),
    juri_nume                     number,
    conc_indi_impo                varchar2(1),
    moco_impo_codi                number,     
    moco_nume_item                number,
    impo_nume                     number,
    conc_indi_cent_cost           varchar2(1),
    moco_ceco_codi                number,
    ceco_nume                     number,
    moco_emse_codi                number,
    conc_indi_ortr                varchar2(1),
    moco_ortr_codi                number,
    conc_indi_kilo_vehi           varchar2(1),
    moco_tran_codi                number,
    tran_codi_alte                number,
    moco_conc_codi                number,
    moco_impo_mmnn_ii             number,
    moco_impu_porc                number,
    moco_impu_porc_base_impo      number,
    moco_impu_indi_baim_impu_incl  varchar2(500),
    moco_impo_mone_ii             number,
    moco_grav10_ii_mone           number,
    moco_grav5_ii_mone            number,
    moco_grav10_mone              number,
    moco_grav5_mone               number,
    moco_iva10_mone               number,
    moco_iva5_mone                number,
    moco_Exen_mone                number,
    moco_grav10_ii_mmnn           number,
    moco_grav5_ii_mmnn            number,
    moco_grav10_mmnn              number,
    moco_grav5_mmnn               number,
    moco_iva10_mmnn               number,
    moco_iva5_mmnn                number,
    moco_exen_mmnn                number,
    moco_impo_mmnn                number,
    moco_impo_mone                number,
    sum_moco_exen_mone            number,
    sum_moco_grav10_ii_mone       number,
    sum_moco_grav5_ii_mone        number,
    sum_moco_iva10_mone           number,
    sum_moco_iva5_mone            number,
    sum_moco_grav10_mone          number,
    sum_moco_grav5_mone           number,
    sum_moco_impo_mmnn_ii         number,
    sum_moco_exen_mmnn            number,
    sum_moco_grav10_ii_mmnn       number,
    sum_moco_grav5_ii_mmnn        number,
    sum_moco_iva10_mmnn           number,
    sum_moco_iva5_mmnn            number,
    sum_moco_grav10_mmnn          number,
    sum_moco_grav5_mmnn           number,
    ortr_nume                     number,
    gatr_litr_carg                number,
    gatr_kilo_actu                number,
    moco_impu_codi                number,
    moco_dbcr                     varchar2(60),
    moco_desc                     varchar2(60),
    moco_tiim_codi                number,
    moco_orse_codi                number,
    moco_conc_codi_impu           number
                   );
   bdet r_bdet;
   
   
   type r_brete is record(
   movi_nume_timb_rete            number,
   movi_nume_rete                 number,  
   movi_impo_rete                 number,
   movi_impo_rete_rent            number,
   movi_fech_venc_timb_rete       date,
   movi_fech_rete                 date
   );
   brete r_brete;
  
  cursor cur_det is
 select c001 apli_codi,
        c002 apli_fech,
        c003 deta_liqu_codi,
        c004 deta_nume_item,
        c005 empl_codi_alte,
        c006 empl_desc,
        c007 liqu_nume,
        c008 liqu_fech_emis,
        c009 conc_codi,
        c010 conc_desc,
        c011 liqu_impo,
        c012 liqu_saldo,
        c013 saldo_sele,
        c014 deta_impo_desc_rete, --rete_impo,
        c015 indi,
        c016 indi_elim
   from apex_collections
  where collection_name = 'DETALLE';

-------------------------------------------------------------------------------------------------------    
procedure pp_generar_tesaka is
	salir exception;
	v_resp	varchar2(1000);
begin
	  --preguntar si se desea imprimir el reporte...	
  /*if fl_confirmar_reg('Desea generar el Archivo para Tesaka?') <> upper('confirmar') then
    null
  end if;*/

  pa_gene_tesaka('COMPRA_'||bcab.movi_nume||'_'||bcab.movi_clpr_desc||'_'||bcab.movi_fech_emis||'.txt',
                 null,
                 null,
                 bcab.movi_codi,
                 null,
                 null,
                 null,
                 null,
                 v_resp);

end pp_generar_tesaka;

procedure pp_gene_asie is
v_mensaje varchar2(2000);
Begin  
  
  if nvl(parameter.p_indi_asie_on_line, 'N') = 'S' then
   pack_conta.pa_Gene_asie_comp(bcab.movi_codi, bcab.movi_fech_emis, bcab.movi_fech_emis, parameter.p_codi_base, v_mensaje);
   pack_conta.pa_gene_asie_vent(bcab.movi_codi, bcab.movi_fech_emis, bcab.movi_fech_emis, parameter.p_codi_base, v_mensaje);
   pack_conta.pa_gene_asie_dev_vent(bcab.movi_codi, bcab.movi_fech_emis, bcab.movi_fech_emis, parameter.p_codi_base, v_mensaje);
   pack_conta.pa_gene_asie_nota_debi_emit(bcab.movi_codi, bcab.movi_fech_emis, bcab.movi_fech_emis, parameter.p_codi_base, v_mensaje);
   pack_conta.pa_gene_Asie_nota_debi_reci(bcab.movi_codi, bcab.movi_fech_emis, bcab.movi_fech_emis, parameter.p_codi_base, v_mensaje);   
  end if;
  
  
end pp_gene_asie;

procedure pp_actu_secu_rete  is
begin        
	
  if nvl(bcab.s_impo_rete,0)  > 0 then
    update come_secu set SECU_NUME_RETEN = brete.movi_nume_rete
    where secu_codi = (select peco_secu_codi
                       from come_pers_comp
                       where peco_codi = parameter.p_peco_codi);  
  end if;
  
end pp_actu_secu_rete;
procedure pp_insert_come_movi_impu_deta(
p_moim_impu_codi      in number,
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
    (moim_impu_codi      ,
moim_movi_codi      ,
moim_impo_mmnn      , 
moim_impo_mmee      ,
moim_impu_mmnn      , 
moim_impu_mmee      , 
moim_impo_mone      , 
moim_impu_mone      , 
moim_base           , 
moim_tiim_codi      ,
moim_impo_mone_ii   ,
moim_impo_mmnn_ii   , 
moim_grav10_ii_mone , 
moim_grav5_ii_mone  , 
moim_grav10_ii_mmnn , 
moim_grav5_ii_mmnn  , 
moim_grav10_mone    , 
moim_grav5_mone     , 
moim_grav10_mmnn    , 
moim_grav5_mmnn     , 
moim_iva10_mone     , 
moim_iva5_mone      , 
moim_iva10_mmnn     , 
moim_iva5_mmnn      , 
moim_exen_mone      , 
moim_exen_mmnn      )  values    (p_moim_impu_codi      ,
p_moim_movi_codi      ,
p_moim_impo_mmnn      , 
p_moim_impo_mmee      ,
p_moim_impu_mmnn      , 
p_moim_impu_mmee      , 
p_moim_impo_mone      , 
p_moim_impu_mone      , 
p_moim_base           , 
p_moim_tiim_codi      ,
p_moim_impo_mone_ii   ,
p_moim_impo_mmnn_ii   , 
p_moim_grav10_ii_mone , 
p_moim_grav5_ii_mone  , 
p_moim_grav10_ii_mmnn , 
p_moim_grav5_ii_mmnn  , 
p_moim_grav10_mone    , 
p_moim_grav5_mone     , 
p_moim_grav10_mmnn    , 
p_moim_grav5_mmnn     , 
p_moim_iva10_mone     , 
p_moim_iva5_mone      , 
p_moim_iva10_mmnn     , 
p_moim_iva5_mmnn      , 
p_moim_exen_mone      , 
p_moim_exen_mmnn      );


end pp_insert_come_movi_impu_deta;

procedure pp_insert_movi_conc_deta(
p_moco_movi_codi                in        number,
p_moco_nume_item                in        number,
p_moco_conc_codi                in        number,
p_moco_cuco_codi                in        number,
p_moco_impu_codi                in        number,
p_moco_impo_mmnn                in        number,
p_moco_impo_mmee                in        number,
p_moco_impo_mone                in        number,
p_moco_dbcr                     in        varchar,
p_moco_base                     in        number,
p_moco_desc                     in        varchar2,
p_moco_tiim_codi                in        number,
p_moco_indi_fact_serv           in        varchar2,
p_moco_impo_mone_ii             in        number,
p_moco_ortr_codi                in        number,
p_moco_impo_codi                in        number,
p_moco_cant                     in        number,
p_moco_cant_pulg                in        number,
p_moco_movi_codi_padr           in        number,
p_moco_nume_item_padr           in        number,
p_moco_ceco_codi                in        number,
p_moco_orse_codi                in        number,
p_moco_tran_codi                in        number,
p_moco_bien_codi                in        number,
p_moco_emse_codi                in        number,
p_moco_impo_mmnn_ii             in        number,
p_moco_sofa_sose_codi           in        number,
p_moco_sofa_nume_item           in        number,
p_moco_tipo_item                in        varchar2,
p_moco_clpr_codi                in        number,
p_moco_prod_nume_item           in        number,
p_moco_guia_nume                in        number,
p_moco_grav10_ii_mone           in        number,
p_moco_grav5_ii_mone            in        number,
p_moco_grav10_ii_mmnn           in        number,
p_moco_grav5_ii_mmnn            in        number,
p_moco_grav10_mone              in        number,
p_moco_grav5_mone               in        number,
p_moco_grav10_mmnn              in        number,
p_moco_grav5_mmnn               in        number,
p_moco_iva10_mone               in        number,
p_moco_iva5_mone                in        number,
p_moco_conc_codi_impu           in        number,
p_moco_tipo                     in        varchar,
p_moco_prod_codi                in        number,
p_moco_ortr_codi_fact           in        number,
p_moco_iva10_mmnn               in        number,
p_moco_iva5_mmnn                in        number,
p_moco_exen_mone                in        number,
p_moco_exen_mmnn                in        number,
p_moco_empl_codi                in        number,
p_moco_lote_codi                in        number,
p_moco_bene_codi                in        number,
p_moco_medi_codi                in        number,
p_moco_cant_medi                in        number,
p_moco_anex_codi                in        number,
p_moco_indi_excl_cont           in        varchar,
p_moco_anex_nume_item           in        number,
p_moco_juri_codi                in        number) is

begin
  
      insert into come_movi_conc_deta
      (moco_movi_codi               ,
      moco_nume_item                ,
      moco_conc_codi                ,
      moco_cuco_codi                ,
      moco_impu_codi                ,
      moco_impo_mmnn                ,
      moco_impo_mmee                ,
      moco_impo_mone                ,
      moco_dbcr                     ,
      moco_base                     ,
      moco_desc                     ,
      moco_tiim_codi                ,
      moco_indi_fact_serv           ,
      moco_impo_mone_ii             ,
      moco_ortr_codi                ,
      moco_impo_codi                ,
      moco_cant                     ,
      moco_cant_pulg                ,
      moco_movi_codi_padr           ,
      moco_nume_item_padr           ,
      moco_ceco_codi                ,
      moco_orse_codi                ,
      moco_tran_codi                ,
      moco_bien_codi                ,
      moco_emse_codi                ,
      moco_impo_mmnn_ii             ,
      moco_sofa_sose_codi           ,
      moco_sofa_nume_item           ,
      moco_tipo_item                ,
      moco_clpr_codi                ,
      moco_prod_nume_item           ,
      moco_guia_nume                ,
      moco_grav10_ii_mone           ,
      moco_grav5_ii_mone            ,
      moco_grav10_ii_mmnn           ,
      moco_grav5_ii_mmnn            ,
      moco_grav10_mone              ,
      moco_grav5_mone               ,
      moco_grav10_mmnn              ,
      moco_grav5_mmnn               ,
      moco_iva10_mone               ,
      moco_iva5_mone                ,
      moco_conc_codi_impu           ,
      moco_tipo                     ,
      moco_prod_codi                ,
      moco_ortr_codi_fact           ,
      moco_iva10_mmnn               ,
      moco_iva5_mmnn                ,
      moco_exen_mone                ,
      moco_exen_mmnn                ,
      moco_empl_codi                ,
      moco_lote_codi                ,
      moco_bene_codi                ,
      moco_medi_codi                ,
      moco_cant_medi                ,
      moco_anex_codi                ,
      moco_indi_excl_cont           ,
      moco_anex_nume_item           ,
      moco_juri_codi                )  values    (
      p_moco_movi_codi                ,
      p_moco_nume_item                ,
      p_moco_conc_codi                ,
      p_moco_cuco_codi                ,
      p_moco_impu_codi                ,
      p_moco_impo_mmnn                ,
      p_moco_impo_mmee                ,
      p_moco_impo_mone                ,
      p_moco_dbcr                     ,
      p_moco_base                     ,
      p_moco_desc                     ,
      p_moco_tiim_codi                ,
      p_moco_indi_fact_serv           ,
      p_moco_impo_mone_ii             ,
      p_moco_ortr_codi                ,
      p_moco_impo_codi                ,
      p_moco_cant                     ,
      p_moco_cant_pulg                ,
      p_moco_movi_codi_padr           ,
      p_moco_nume_item_padr           ,
      p_moco_ceco_codi                ,
      p_moco_orse_codi                ,
      p_moco_tran_codi                ,
      p_moco_bien_codi                ,
      p_moco_emse_codi                ,
      p_moco_impo_mmnn_ii             ,
      p_moco_sofa_sose_codi           ,
      p_moco_sofa_nume_item           ,
      p_moco_tipo_item                ,
      p_moco_clpr_codi                ,
      p_moco_prod_nume_item           ,
      p_moco_guia_nume                ,
      p_moco_grav10_ii_mone           ,
      p_moco_grav5_ii_mone            ,
      p_moco_grav10_ii_mmnn           ,
      p_moco_grav5_ii_mmnn            ,
      p_moco_grav10_mone              ,
      p_moco_grav5_mone               ,
      p_moco_grav10_mmnn              ,
      p_moco_grav5_mmnn               ,
      p_moco_iva10_mone               ,
      p_moco_iva5_mone                ,
      p_moco_conc_codi_impu           ,
      p_moco_tipo                     ,
      p_moco_prod_codi                ,
      p_moco_ortr_codi_fact           ,
      p_moco_iva10_mmnn               ,
      p_moco_iva5_mmnn                ,
      p_moco_exen_mone                ,
      p_moco_exen_mmnn                ,
      p_moco_empl_codi                ,
      p_moco_lote_codi                ,
      p_moco_bene_codi                ,
      p_moco_medi_codi                ,
      p_moco_cant_medi                ,
      p_moco_anex_codi                ,
      p_moco_indi_excl_cont           ,
      p_moco_anex_nume_item           ,
      p_moco_juri_codi                );

end pp_insert_movi_conc_deta;
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
                              p_movi_indi_apli_rrhh			 in varchar2) is
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
     movi_indi_apli_rrhh)
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
     parameter.p_codi_base,
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
     p_movi_indi_apli_rrhh);


end pp_insert_come_movi;
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
  v_movi_nume_timb           varchar2(20);
  v_movi_fech_venc_timb      date;
  v_movi_impo_reca           number;
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

  v_timo_tico_codi number;
  v_tico_indi_timb varchar2(1);
  v_nro_1          varchar2(3);
  v_nro_2          varchar2(3);

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
  v_moco_movi_codi                number(20);
v_moco_nume_item                number(10);
v_moco_conc_codi                number(10);
v_moco_cuco_codi                number(10);
v_moco_impu_codi                number(10);
v_moco_impo_mmnn                number(20,4);
v_moco_impo_mmee                number(20,4);
v_moco_impo_mone                number(20,4);
v_moco_dbcr                     varchar2(1);
v_moco_base                     number(2);
v_moco_desc                     varchar2(2000);
v_moco_tiim_codi                number(10);
v_moco_indi_fact_serv           varchar2(1);
v_moco_impo_mone_ii             number(20,4);
v_moco_ortr_codi                number(20);
v_moco_impo_codi                number(20);
v_moco_cant                     number(20,4);
v_moco_cant_pulg                number(20,4);
v_moco_movi_codi_padr           number(20);
v_moco_nume_item_padr           number(10);
v_moco_ceco_codi                number(20);
v_moco_orse_codi                number(20);
v_moco_tran_codi                number(20);
v_moco_bien_codi                number(20);
v_moco_emse_codi                number(4);
v_moco_impo_mmnn_ii             number(20,4);
v_moco_sofa_sose_codi           number(20);
v_moco_sofa_nume_item           number(20);
v_moco_tipo_item                varchar2(2);
v_moco_clpr_codi                number(20);
v_moco_prod_nume_item           number(20);
v_moco_guia_nume                number(20);
v_moco_grav10_ii_mone           number(20,4);
v_moco_grav5_ii_mone            number(20,4);
v_moco_grav10_ii_mmnn           number(20,4);
v_moco_grav5_ii_mmnn            number(20,4);
v_moco_grav10_mone              number(20,4);
v_moco_grav5_mone               number(20,4);
v_moco_grav10_mmnn              number(20,4);
v_moco_grav5_mmnn               number(20,4);
v_moco_iva10_mone               number(20,4);
v_moco_iva5_mone                number(20,4);
v_moco_conc_codi_impu           number(10);
v_moco_tipo                     varchar2(2);
v_moco_prod_codi                number(20);
v_moco_ortr_codi_fact           number(20);
v_moco_iva10_mmnn               number(20,4);
v_moco_iva5_mmnn                number(20,4);
v_moco_exen_mone                number(20,4);
v_moco_exen_mmnn                number(20,4);
v_moco_empl_codi                number(10);
v_moco_lote_codi                number(10);
v_moco_bene_codi                number(4);
v_moco_medi_codi                number(10);
v_moco_cant_medi                number(20,4);
v_moco_anex_codi                number(20);
v_moco_indi_excl_cont           varchar2(1);
v_moco_anex_nume_item           number(10);
v_moco_juri_codi                number(20);
  
  -- movi_rete
  v_more_movi_codi      number;
  v_more_movi_codi_rete number;
  v_more_tipo_rete      number;
  v_more_impo_mone      number;
  v_more_impo_mmnn      number;
  v_more_tasa_mone      number;

  v_resp      varchar2(100);
begin
  --- asignar valores....
  select timo_emit_reci, timo_afec_sald, timo_dbcr
    into v_movi_emit_reci, v_movi_afec_sald, v_movi_dbcr
    from come_tipo_movi, come_tipo_comp
   where timo_tico_codi = tico_codi(+)
     and timo_codi = parameter.p_codi_timo_rete_emit;

  v_movi_nume                 := brete.movi_nume_rete;
  v_movi_nume_timb            := brete.movi_nume_timb_rete;
  v_movi_fech_venc_timb       := brete.movi_fech_venc_timb_rete;
  v_movi_fech_oper            := bcab.movi_fech_oper;
  v_movi_codi                 := fa_sec_come_movi;
  parameter.p_movi_codi_rete  := v_movi_codi;
  v_movi_timo_codi            := parameter.p_codi_timo_rete_emit;
  v_movi_clpr_codi            := bcab.movi_clpr_codi;
  v_movi_sucu_codi_orig       := bcab.movi_sucu_codi_orig;
  v_movi_depo_codi_orig       := null;
  v_movi_sucu_codi_dest       := null;
  v_movi_depo_codi_dest       := null;
  v_movi_oper_codi            := null;
  v_movi_cuen_codi            := null; -- bcab.movi_cuen_codi;
  v_movi_mone_codi            := bcab.movi_mone_codi;
  v_movi_fech_emis            := nvl(brete.movi_fech_rete,bcab.movi_fech_emis);
  v_movi_fech_grab            := sysdate; --bcab.movi_fech_grab;
  v_movi_user                 := gen_user; --bcab.movi_user;
  v_movi_codi_padr            := bcab.movi_codi;
  v_movi_tasa_mone            := bcab.movi_tasa_mone;
  v_movi_tasa_mmee            := null;
  v_movi_grav_mmnn            := 0; --bcab.movi_grav_mmnn;
  v_movi_exen_mmnn            := round((nvl(brete.movi_impo_rete, 0) +
                                       nvl(brete.movi_impo_rete_rent, 0)) *
                                       bcab.movi_tasa_mone,
                                       0); --bcab.movi_exen_mmnn;
  v_movi_iva_mmnn             := 0; --bcab.movi_iva_mmnn;
  v_movi_grav_mmee            := null;
  v_movi_exen_mmee            := null;
  v_movi_iva_mmee             := null;
  v_movi_grav_mone            := 0; --bcab.movi_grav_mone;
  v_movi_exen_mone            := nvl(brete.movi_impo_rete, 0) +nvl(brete.movi_impo_rete_rent, 0); --bcab.movi_exen_mone;
  v_movi_iva_mone             := 0; --bcab.movi_iva_mone;
  v_movi_obse                 := 'Retencion Factura Nro. ' ||
                                 bcab.movi_nume;
  v_movi_sald_mmnn            := 0;
  v_movi_sald_mmee            := 0;
  v_movi_sald_mone            := 0;
  v_movi_stoc_suma_rest       := null;
  v_movi_clpr_dire            := null;
  v_movi_clpr_tele            := null;
  v_movi_clpr_ruc             := null;
  v_movi_clpr_desc            := bcab.movi_clpr_desc;
  v_movi_stoc_afec_cost_prom  := null;
  v_movi_empr_codi            := null;
  v_movi_clave_orig           := null;
  v_movi_clave_orig_padr      := null;
  v_movi_indi_iva_incl        := null;
  v_movi_empl_codi            := null; --bcab.movi_empl_codi;
  v_movi_excl_cont            := 'S';
  v_movi_impo_reca            := 0;
  v_movi_impo_mone_ii         := v_movi_exen_mone;
  v_movi_impo_mmnn_ii         := v_movi_exen_mmnn;
  v_movi_grav10_ii_mone       := 0;
  v_movi_grav5_ii_mone        := 0;
  v_movi_grav10_ii_mmnn       := 0;
  v_movi_grav5_ii_mmnn        := 0;
  v_movi_grav10_mone          := 0;
  v_movi_grav5_mone           := 0;
  v_movi_grav10_mmnn          := 0;
  v_movi_grav5_mmnn           := 0;
  v_movi_iva10_mone           := 0;
  v_movi_iva5_mone            := 0;
  v_movi_iva10_mmnn           := 0;
  v_movi_iva5_mmnn            := 0;
  v_movi_clpr_sucu_nume_item  := null;

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
                      null);

  ----detalle de conceptos
  v_moco_movi_codi      := parameter.p_movi_codi_rete;
  v_moco_nume_item      := 0;
  v_moco_dbcr           := v_movi_dbcr;
  v_moco_cuco_codi      := null;
  v_moco_tiim_codi      := 1;
  v_moco_impu_codi      := parameter.p_codi_impu_exen;
  v_moco_impo_mmee      := 0;
  v_moco_ortr_codi      := null;
  v_moco_impo_codi      := null; -- codigo de importacion
  v_moco_ceco_codi      := null;
  v_moco_orse_codi      := null;
  v_moco_ortr_codi      := null;
  v_moco_emse_codi      := null;
  v_moco_impo_mone_ii   := null;
  v_moco_impo_mmnn_ii   := null;
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
  v_moco_conc_codi_impu := null;
  v_moco_tipo           := 'C';
  v_moco_prod_codi      := null;
  v_moco_ortr_codi_fact := null;
  v_moco_juri_codi      := null;

  if nvl(brete.movi_impo_rete, 0) > 0 then
  
    v_moco_conc_codi := parameter.p_codi_conc_rete_emit;
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_impo_mmnn := round(nvl(brete.movi_impo_rete, 0) *
                              bcab.movi_tasa_mone,
                              0); --v_movi_exen_mmnn;
    v_moco_impo_mone := nvl(brete.movi_impo_rete, 0); --v_movi_exen_mone;
    v_moco_exen_mmnn := v_moco_impo_mmnn;
    v_moco_exen_mone := v_moco_impo_mone;
  
    pp_insert_movi_conc_deta(
        v_moco_movi_codi                ,
        v_moco_nume_item                ,
        v_moco_conc_codi                ,
        v_moco_cuco_codi                ,
        v_moco_impu_codi                ,
        v_moco_impo_mmnn                ,
        v_moco_impo_mmee                ,
        v_moco_impo_mone                ,
        v_moco_dbcr                     ,
        v_moco_base                     ,
        v_moco_desc                     ,
        v_moco_tiim_codi                ,
        v_moco_indi_fact_serv           ,
        v_moco_impo_mone_ii             ,
        v_moco_ortr_codi                ,
        v_moco_impo_codi                ,
        v_moco_cant                     ,
        v_moco_cant_pulg                ,
        v_moco_movi_codi_padr           ,
        v_moco_nume_item_padr           ,
        v_moco_ceco_codi                ,
        v_moco_orse_codi                ,
        v_moco_tran_codi                ,
        v_moco_bien_codi                ,
        v_moco_emse_codi                ,
        v_moco_impo_mmnn_ii             ,
        v_moco_sofa_sose_codi           ,
        v_moco_sofa_nume_item           ,
        v_moco_tipo_item                ,
        v_moco_clpr_codi                ,
        v_moco_prod_nume_item           ,
        v_moco_guia_nume                ,
        v_moco_grav10_ii_mone           ,
        v_moco_grav5_ii_mone            ,
        v_moco_grav10_ii_mmnn           ,
        v_moco_grav5_ii_mmnn            ,
        v_moco_grav10_mone              ,
        v_moco_grav5_mone               ,
        v_moco_grav10_mmnn              ,
        v_moco_grav5_mmnn               ,
        v_moco_iva10_mone               ,
        v_moco_iva5_mone                ,
        v_moco_conc_codi_impu           ,
        v_moco_tipo                     ,
        v_moco_prod_codi                ,
        v_moco_ortr_codi_fact           ,
        v_moco_iva10_mmnn               ,
        v_moco_iva5_mmnn                ,
        v_moco_exen_mone                ,
        v_moco_exen_mmnn                ,
        v_moco_empl_codi                ,
        v_moco_lote_codi                ,
        v_moco_bene_codi                ,
        v_moco_medi_codi                ,
        v_moco_cant_medi                ,
        v_moco_anex_codi                ,
        v_moco_indi_excl_cont           ,
        v_moco_anex_nume_item           ,
        v_moco_juri_codi             );
  end if;
  if nvl(brete.movi_impo_rete_rent, 0) > 0 then
    v_moco_conc_codi := parameter.p_codi_conc_rete_rent_emit;
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_impo_mmnn := round(nvl(brete.movi_impo_rete_rent, 0) *
                              bcab.movi_tasa_mone,
                              0); --v_movi_exen_mmnn;
    v_moco_impo_mone := nvl(brete.movi_impo_rete_rent, 0); --v_movi_exen_mone;
    v_moco_exen_mmnn := v_moco_impo_mmnn;
    v_moco_exen_mone := v_moco_impo_mone;
  
   pp_insert_movi_conc_deta(
        v_moco_movi_codi                ,
        v_moco_nume_item                ,
        v_moco_conc_codi                ,
        v_moco_cuco_codi                ,
        v_moco_impu_codi                ,
        v_moco_impo_mmnn                ,
        v_moco_impo_mmee                ,
        v_moco_impo_mone                ,
        v_moco_dbcr                     ,
        v_moco_base                     ,
        v_moco_desc                     ,
        v_moco_tiim_codi                ,
        v_moco_indi_fact_serv           ,
        v_moco_impo_mone_ii             ,
        v_moco_ortr_codi                ,
        v_moco_impo_codi                ,
        v_moco_cant                     ,
        v_moco_cant_pulg                ,
        v_moco_movi_codi_padr           ,
        v_moco_nume_item_padr           ,
        v_moco_ceco_codi                ,
        v_moco_orse_codi                ,
        v_moco_tran_codi                ,
        v_moco_bien_codi                ,
        v_moco_emse_codi                ,
        v_moco_impo_mmnn_ii             ,
        v_moco_sofa_sose_codi           ,
        v_moco_sofa_nume_item           ,
        v_moco_tipo_item                ,
        v_moco_clpr_codi                ,
        v_moco_prod_nume_item           ,
        v_moco_guia_nume                ,
        v_moco_grav10_ii_mone           ,
        v_moco_grav5_ii_mone            ,
        v_moco_grav10_ii_mmnn           ,
        v_moco_grav5_ii_mmnn            ,
        v_moco_grav10_mone              ,
        v_moco_grav5_mone               ,
        v_moco_grav10_mmnn              ,
        v_moco_grav5_mmnn               ,
        v_moco_iva10_mone               ,
        v_moco_iva5_mone                ,
        v_moco_conc_codi_impu           ,
        v_moco_tipo                     ,
        v_moco_prod_codi                ,
        v_moco_ortr_codi_fact           ,
        v_moco_iva10_mmnn               ,
        v_moco_iva5_mmnn                ,
        v_moco_exen_mone                ,
        v_moco_exen_mmnn                ,
        v_moco_empl_codi                ,
        v_moco_lote_codi                ,
        v_moco_bene_codi                ,
        v_moco_medi_codi                ,
        v_moco_cant_medi                ,
        v_moco_anex_codi                ,
        v_moco_indi_excl_cont           ,
        v_moco_anex_nume_item           ,
        v_moco_juri_codi             );
  end if;

  --detalle de impuestos
  /*
  pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                parameter.p_movi_codi_rete,
                                v_movi_exen_mmnn,
                                0,
                                0,
                                0,
                                v_movi_exen_mone,
                                0,
                                null,
                                v_movi_exen_mone,
                                v_movi_exen_mmnn,
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
                                v_moco_iva5_mmnn);
                                */
        pp_insert_come_movi_impu_deta(
        parameter.p_codi_impu_exen      ,
        parameter.p_movi_codi_rete      ,
        v_movi_exen_mmnn      ,--v_moim_impo_mmnn      ,
        null, --v_moim_impo_mmee      ,
        0, --v_moim_impu_mmnn      ,
        0, --v_moim_impu_mmee      ,
        v_movi_exen_mone, --v_moim_impo_mone      ,
        0, ---v_moim_impu_mone      ,
        parameter.p_codi_base, --v_moim_base           ,
        1, ---v_moim_tiim_codi      ,
        v_movi_exen_mone, ---v_moim_impo_mone_ii   ,
        v_movi_exen_mmnn, --v_moim_impo_mmnn_ii   ,
        0, --v_moim_grav10_ii_mone ,
        0, --v_moim_grav5_ii_mone  ,
        0,--v_moim_grav10_ii_mmnn ,
        0, --v_moim_grav5_ii_mmnn  ,
        0, --v_moim_grav10_mone    ,
        0, --v_moim_grav5_mone     ,
        0, --v_moim_grav10_mmnn    ,
        0, --v_moim_grav5_mmnn     ,
        0, --v_moim_iva10_mone     ,
        0, --v_moim_iva5_mone      ,
        0, --v_moim_iva10_mmnn     ,
        0, --v_moim_iva5_mmnn      ,
        v_movi_Exen_mone, --v_moim_exen_mone      ,
        v_movi_exen_mmnn); --v_moim_exen_mmnn      );                                
                                
                                
                                

  if nvl(brete.movi_impo_rete, 0) > 0 then
    update come_movi
       set movi_codi_rete = parameter.p_movi_codi_rete
     where movi_codi = bcab.movi_codi;
  
    v_more_movi_codi      := bcab.movi_codi;
    v_more_movi_codi_rete := v_movi_codi;
    v_more_tipo_rete      := parameter.p_form_calc_rete_emit;
    v_more_impo_mone      := brete.movi_impo_rete;
    v_more_impo_mmnn      := round((brete.movi_impo_rete * bcab.movi_tasa_mone),0);
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
       v_more_movi_codi,
       v_more_tipo_rete,
       v_more_impo_mone,
       v_more_impo_mmnn,
       v_more_tasa_mone);
  end if;
  pp_actu_secu_rete;
  
end pp_actualizar_rete;


procedure pp_actualiza_moimpu is

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
  group by a.moco_movi_codi,
            a.moco_impu_codi,
            a.moco_tiim_codi              
  order by a.moco_movi_codi, a.moco_impu_codi, a.moco_tiim_codi;


v_moim_impu_codi      number(10)  ;                         
v_moim_movi_codi      number(20)  ;                        
v_moim_impo_mmnn      number(20,4) ;                        
v_moim_impo_mmee      number(20,4) ;                         
v_moim_impu_mmnn      number(20,4) ;                         
v_moim_impu_mmee      number(20,4) ;                         
v_moim_impo_mone      number(20,4) ;                         
v_moim_impu_mone      number(20,4) ;                         
v_moim_base           number(2)    ;                         
v_moim_tiim_codi      number(10)   ;                
v_moim_impo_mone_ii   number(20,4) ;                         
v_moim_impo_mmnn_ii   number(20,4) ;                         
v_moim_grav10_ii_mone number(20,4) ;                         
v_moim_grav5_ii_mone  number(20,4) ;                         
v_moim_grav10_ii_mmnn number(20,4) ;                         
v_moim_grav5_ii_mmnn  number(20,4) ;                         
v_moim_grav10_mone    number(20,4) ;                         
v_moim_grav5_mone     number(20,4) ;                         
v_moim_grav10_mmnn    number(20,4) ;                         
v_moim_grav5_mmnn     number(20,4) ;                         
v_moim_iva10_mone     number(20,4) ;                         
v_moim_iva5_mone      number(20,4) ;                         
v_moim_iva10_mmnn     number(20,4) ;                         
v_moim_iva5_mmnn      number(20,4) ;                         
v_moim_exen_mone      number(20,4) ;                         
v_moim_exen_mmnn      number(20,4) ;


Begin
  
  /*if bcab.movi_timo_codi in (parameter.p_codi_timo_auto_fact_emit, parameter.p_codi_timo_auto_fact_emit_cr) and
      (nvl(bcab.s_impo_rete,0)+ nvl(bcab.s_impo_rete_rent,0)) > 0 and nvl(parameter.P_INDI_AUTO_FACT_IMPU_CALC, 'N') = 'S' then
     
         ----solo la retencion iva, se registra como iva 10%, calculando en forma invertida es decir a partir del iva 
        v_moim_impu_codi      := 2;
        v_moim_movi_codi      := bcab.movi_codi;                   
        
        v_moim_impo_mmee      := null;                    
        v_moim_impu_mmnn      := round((nvl(bcab.s_impo_rete,0)* bcab.movi_tasa_mone), parameter.p_cant_deci_mmnn);
        v_moim_impu_mmee      := null; 
        v_moim_impu_mone      := nvl(bcab.s_impo_rete,0);                   
        v_moim_base           := parameter.p_Codi_base;
        v_moim_tiim_codi      := 1;    
        v_moim_impo_mone_ii   := nvl(bcab.s_impo_rete_rent,0);                   
        v_moim_impo_mmnn_ii   := nvl(bcab.s_impo_rete_rent,0);                
        
        
        v_moim_impo_mmnn      := v_moim_impu_mmnn*10;       
        v_moim_impo_mone      := v_moim_impu_mone*10;
        
        
        v_moim_grav10_ii_mone := v_moim_impu_mone + v_moim_impo_mone;                
        v_moim_grav10_ii_mmnn := v_moim_impu_mmnn + v_moim_impo_mmnn;                
        
        
        v_moim_grav5_ii_mone  := 0;              
        v_moim_grav5_ii_mmnn  := 0;              
        
        v_moim_grav10_mone    := v_moim_impo_mone;               
        v_moim_grav10_mmnn    := v_moim_impo_mmnn;                  
        
        v_moim_grav5_mone     := 0;                 
        v_moim_grav5_mmnn     := 0;                 
        
        v_moim_iva10_mone     := v_moim_impu_mone;                  
        v_moim_iva10_mmnn     := v_moim_impu_mmnn;                   
        
        v_moim_iva5_mone      := 0;                  
        v_moim_iva5_mmnn      := 0;                  
        
        v_moim_exen_mone      := 0;                   
        v_moim_exen_mmnn      := 0;
          
          
        pp_insert_come_movi_impu_deta(
        v_moim_impu_codi      ,
        v_moim_movi_codi      ,
        v_moim_impo_mmnn      ,
        v_moim_impo_mmee      ,
        v_moim_impu_mmnn      ,
        v_moim_impu_mmee      ,
        v_moim_impo_mone      ,
        v_moim_impu_mone      ,
        v_moim_base           ,
        v_moim_tiim_codi      ,
        v_moim_impo_mone_ii   ,
        v_moim_impo_mmnn_ii   ,
        v_moim_grav10_ii_mone ,
        v_moim_grav5_ii_mone  ,
        v_moim_grav10_ii_mmnn ,
        v_moim_grav5_ii_mmnn  ,
        v_moim_grav10_mone    ,
        v_moim_grav5_mone     ,
        v_moim_grav10_mmnn    ,
        v_moim_grav5_mmnn     ,
        v_moim_iva10_mone     ,
        v_moim_iva5_mone      ,
        v_moim_iva10_mmnn     ,
        v_moim_iva5_mmnn      ,
        v_moim_exen_mone      ,
        v_moim_exen_mmnn      );
        
    
    
  else */ 
    for x in c_movi_conc(bcab.movi_codi) loop  
        v_moim_impu_codi      := x.moco_impu_codi;
        v_moim_movi_codi      := x.moco_movi_codi;                   
        v_moim_impo_mmnn      := x.moco_impo_mmnn                  ;
        v_moim_impo_mmee      := null;                    
        v_moim_impu_mmnn      := x.moco_iva10_mmnn+x.moco_iva5_mmnn;
        v_moim_impu_mmee      := null; 
        v_moim_impo_mone      := x.moco_impo_mone;
        v_moim_impu_mone      := x.moco_iva10_mone +x.moco_iva5_mone;                   
        v_moim_base           := parameter.p_Codi_base;
        v_moim_tiim_codi      := x.moco_tiim_codi;    
        v_moim_impo_mone_ii   := x.moco_impo_mone_ii;                   
        v_moim_impo_mmnn_ii   := x.moco_impo_mmnn_ii;                
        
        v_moim_grav10_ii_mone := x.moco_grav10_ii_mone;                
        v_moim_grav10_ii_mmnn := x.moco_grav10_ii_mmnn;               
        
        
        v_moim_grav5_ii_mone  := x.moco_grav5_ii_mone;              
        v_moim_grav5_ii_mmnn  := x.moco_grav5_ii_mmnn;              
        
        v_moim_grav10_mone    := x.moco_grav10_mone;               
        v_moim_grav10_mmnn    := x.moco_grav10_mmnn;                  
        
        v_moim_grav5_mone     := x.moco_grav5_mone;                 
        v_moim_grav5_mmnn     := x.moco_grav5_mmnn;                 
        
        v_moim_iva10_mone     := x.moco_iva10_mone;                  
        v_moim_iva10_mmnn     := x.moco_iva10_mmnn;                   
        
        v_moim_iva5_mone      := x.moco_iva5_mone;                  
        v_moim_iva5_mmnn      := x.moco_iva5_mmnn;                  
        
        v_moim_exen_mone      := x.moco_exen_mone;                   
        v_moim_exen_mmnn      := x.moco_exen_mmnn;
          
          
        insert into come_movi_impu_deta
                   (moim_impu_codi      ,
                    moim_movi_codi      ,
                    moim_impo_mmnn      , 
                    moim_impo_mmee      ,
                    moim_impu_mmnn      , 
                    moim_impu_mmee      , 
                    moim_impo_mone      , 
                    moim_impu_mone      , 
                    moim_base           , 
                    moim_tiim_codi      ,
                    moim_impo_mone_ii   ,
                    moim_impo_mmnn_ii   , 
                    moim_grav10_ii_mone , 
                    moim_grav5_ii_mone  , 
                    moim_grav10_ii_mmnn , 
                    moim_grav5_ii_mmnn  , 
                    moim_grav10_mone    , 
                    moim_grav5_mone     , 
                    moim_grav10_mmnn    , 
                    moim_grav5_mmnn     , 
                    moim_iva10_mone     , 
                    moim_iva5_mone      , 
                    moim_iva10_mmnn     , 
                    moim_iva5_mmnn      , 
                    moim_exen_mone      , 
                    moim_exen_mmnn      )  
         values    (v_moim_impu_codi      ,
                    v_moim_movi_codi      ,
                    v_moim_impo_mmnn      , 
                    v_moim_impo_mmee      ,
                    v_moim_impu_mmnn      , 
                    v_moim_impu_mmee      , 
                    v_moim_impo_mone      , 
                    v_moim_impu_mone      , 
                    v_moim_base           , 
                    v_moim_tiim_codi      ,
                    v_moim_impo_mone_ii   ,
                    v_moim_impo_mmnn_ii   , 
                    v_moim_grav10_ii_mone , 
                    v_moim_grav5_ii_mone  , 
                    v_moim_grav10_ii_mmnn , 
                    v_moim_grav5_ii_mmnn  , 
                    v_moim_grav10_mone    , 
                    v_moim_grav5_mone     , 
                    v_moim_grav10_mmnn    , 
                    v_moim_grav5_mmnn     , 
                    v_moim_iva10_mone     , 
                    v_moim_iva5_mone      , 
                    v_moim_iva10_mmnn     , 
                    v_moim_iva5_mmnn      , 
                    v_moim_exen_mone      , 
                    v_moim_exen_mmnn      );
    end loop;
 
end pp_actualiza_moimpu;

procedure pp_actualiza_gast_vehi is
v_gatr_movi_codi number;
v_gatr_tran_codi number;
v_gatr_litr_carg number;
v_gatr_kilo_actu number;

begin
  if nvl(bdet.conc_indi_kilo_vehi, 'N') in ('S' , 'M')  then 
    if bdet.moco_tran_codi is not null then
      v_gatr_movi_codi := bcab.movi_codi;
      v_gatr_tran_codi := bdet.moco_tran_codi;
      v_gatr_litr_carg := bdet.gatr_litr_carg;
      v_gatr_kilo_actu := bdet.gatr_kilo_actu;
      
   insert into come_movi_gast_tran 
    (gatr_movi_codi, 
     gatr_tran_codi, 
     gatr_litr_carg, 
     gatr_kilo_actu ) 
     values (
     v_gatr_movi_codi, 
     v_gatr_tran_codi, 
     v_gatr_litr_carg, 
     v_gatr_kilo_actu );
    end if;
  end if; 
  
end pp_actualiza_gast_vehi;

procedure pp_actualiza_moco is
v_moco_movi_codi                number(20);
v_moco_nume_item                number(10);
v_moco_conc_codi                number(10);
v_moco_cuco_codi                number(10);
v_moco_impu_codi                number(10);
v_moco_impo_mmnn                number(20,4);
v_moco_impo_mmee                number(20,4);
v_moco_impo_mone                number(20,4);
v_moco_dbcr                     varchar2(1);
v_moco_base                     number(2);
v_moco_desc                     varchar2(2000);
v_moco_tiim_codi                number(10);
v_moco_indi_fact_serv           varchar2(1);
v_moco_impo_mone_ii             number(20,4);
v_moco_ortr_codi                number(20);
v_moco_impo_codi                number(20);
v_moco_cant                     number(20,4);
v_moco_cant_pulg                number(20,4);
v_moco_movi_codi_padr           number(20);
v_moco_nume_item_padr           number(10);
v_moco_ceco_codi                number(20);
v_moco_orse_codi                number(20);
v_moco_tran_codi                number(20);
v_moco_bien_codi                number(20);
v_moco_emse_codi                number(4);
v_moco_impo_mmnn_ii             number(20,4);
v_moco_sofa_sose_codi           number(20);
v_moco_sofa_nume_item           number(20);
v_moco_tipo_item                varchar2(2);
v_moco_clpr_codi                number(20);
v_moco_prod_nume_item           number(20);
v_moco_guia_nume                number(20);
v_moco_grav10_ii_mone           number(20,4);
v_moco_grav5_ii_mone            number(20,4);
v_moco_grav10_ii_mmnn           number(20,4);
v_moco_grav5_ii_mmnn            number(20,4);
v_moco_grav10_mone              number(20,4);
v_moco_grav5_mone               number(20,4);
v_moco_grav10_mmnn              number(20,4);
v_moco_grav5_mmnn               number(20,4);
v_moco_iva10_mone               number(20,4);
v_moco_iva5_mone                number(20,4);
v_moco_conc_codi_impu           number(10);
v_moco_tipo                     varchar2(2);
v_moco_prod_codi                number(20);
v_moco_ortr_codi_fact           number(20);
v_moco_iva10_mmnn               number(20,4);
v_moco_iva5_mmnn                number(20,4);
v_moco_exen_mone                number(20,4);
v_moco_exen_mmnn                number(20,4);
v_moco_empl_codi                number(10);
v_moco_lote_codi                number(10);
v_moco_bene_codi                number(4);
v_moco_medi_codi                number(10);
v_moco_cant_medi                number(20,4);
v_moco_anex_codi                number(20);
v_moco_indi_excl_cont           varchar2(1);
v_moco_anex_nume_item           number(10);
v_moco_juri_codi                number(20);
  
  v_conc_iva            number;
  
begin
  v_moco_movi_codi := bcab.movi_codi;
  v_moco_nume_item := 0;
  
        v_moco_nume_item      := v_moco_nume_item + 1;
        v_moco_conc_codi      := bdet.moco_conc_codi;
        v_moco_cuco_codi      := null;
        v_moco_impu_codi      := bdet.moco_impu_codi;
        v_moco_impo_mmnn      := bdet.moco_impo_mmnn;
        v_moco_impo_mmee      := 0;
        v_moco_impo_mone      := bdet.moco_impo_mone;
        v_moco_dbcr           := bdet.moco_dbcr;      
  
        v_moco_base                     := parameter.p_codi_base;
        v_moco_desc                     := bdet.moco_desc;
        v_moco_tiim_codi                := bdet.moco_tiim_codi;
        v_moco_indi_fact_serv           := null;
        v_moco_impo_mone_ii             := bdet.moco_impo_mone_ii;
        v_moco_ortr_codi                := bdet.moco_ortr_codi;
        v_moco_impo_codi                := bdet.moco_impo_codi;
        v_moco_cant                     := 1;       
        v_moco_cant_pulg                := null;
        v_moco_movi_codi_padr           := null;
        v_moco_nume_item_padr           := null;
        v_moco_ceco_codi                := bdet.moco_ceco_codi;
        v_moco_orse_codi                := bdet.moco_orse_codi;
        v_moco_tran_codi                := bdet.moco_tran_codi;
        v_moco_bien_codi                := null;
        v_moco_emse_codi                := bdet.moco_emse_codi;
        v_moco_impo_mmnn_ii             := bdet.moco_impo_mmnn_ii;
        v_moco_sofa_sose_codi           := null;
        v_moco_sofa_nume_item           := null;
        v_moco_tipo_item                := 'C';  ---igual que moco_tipo
        v_moco_clpr_codi                := null;
        v_moco_prod_nume_item           := null;
        v_moco_guia_nume                := null;
        v_moco_grav10_ii_mone           := bdet.moco_grav10_ii_mone;
        v_moco_grav5_ii_mone            := bdet.moco_grav5_ii_mone;
        v_moco_grav10_ii_mmnn           := bdet.moco_grav10_ii_mmnn;
        v_moco_grav5_ii_mmnn            := bdet.moco_grav5_ii_mmnn;
        v_moco_grav10_mone              := bdet.moco_grav10_mone;
        v_moco_grav5_mone               := bdet.moco_grav5_mone;
        v_moco_grav10_mmnn              := bdet.moco_grav10_mmnn;
        v_moco_grav5_mmnn               := bdet.moco_grav5_mmnn;
        v_moco_iva10_mone               := bdet.moco_iva10_mone;
        v_moco_iva5_mone                := bdet.moco_iva5_mone;
        v_moco_conc_codi_impu           := bdet.moco_conc_codi_impu;
        v_moco_tipo                     := 'C'; --c= concepto P= producto O= Orden de trabajo
        v_moco_prod_codi                := null;
        v_moco_ortr_codi_fact           := null;
        v_moco_iva10_mmnn               := bdet.moco_iva10_mmnn;
        v_moco_iva5_mmnn                := bdet.moco_iva5_mmnn;
        v_moco_exen_mone                := bdet.moco_exen_mone;
        v_moco_exen_mmnn                := bdet.moco_exen_mmnn;
        v_moco_empl_codi                := null;
        v_moco_lote_codi                := null;
        v_moco_bene_codi                := null;
        v_moco_medi_codi                := null;
        v_moco_cant_medi                := null;
        v_moco_anex_codi                := null;
        v_moco_indi_excl_cont           := null;
        v_moco_anex_nume_item           := null;
        v_moco_juri_codi                := bdet.moco_juri_codi;
  
  
      
        pp_insert_movi_conc_deta(
        v_moco_movi_codi                ,
        v_moco_nume_item                ,
        v_moco_conc_codi                ,
        v_moco_cuco_codi                ,
        v_moco_impu_codi                ,
        v_moco_impo_mmnn                ,
        v_moco_impo_mmee                ,
        v_moco_impo_mone                ,
        v_moco_dbcr                     ,
        v_moco_base                     ,
        v_moco_desc                     ,
        v_moco_tiim_codi                ,
        v_moco_indi_fact_serv           ,
        v_moco_impo_mone_ii             ,
        v_moco_ortr_codi                ,
        v_moco_impo_codi                ,
        v_moco_cant                     ,
        v_moco_cant_pulg                ,
        v_moco_movi_codi_padr           ,
        v_moco_nume_item_padr           ,
        v_moco_ceco_codi                ,
        v_moco_orse_codi                ,
        v_moco_tran_codi                ,
        v_moco_bien_codi                ,
        v_moco_emse_codi                ,
        v_moco_impo_mmnn_ii             ,
        v_moco_sofa_sose_codi           ,
        v_moco_sofa_nume_item           ,
        v_moco_tipo_item                ,
        v_moco_clpr_codi                ,
        v_moco_prod_nume_item           ,
        v_moco_guia_nume                ,
        v_moco_grav10_ii_mone           ,
        v_moco_grav5_ii_mone            ,
        v_moco_grav10_ii_mmnn           ,
        v_moco_grav5_ii_mmnn            ,
        v_moco_grav10_mone              ,
        v_moco_grav5_mone               ,
        v_moco_grav10_mmnn              ,
        v_moco_grav5_mmnn               ,
        v_moco_iva10_mone               ,
        v_moco_iva5_mone                ,
        v_moco_conc_codi_impu           ,
        v_moco_tipo                     ,
        v_moco_prod_codi                ,
        v_moco_ortr_codi_fact           ,
        v_moco_iva10_mmnn               ,
        v_moco_iva5_mmnn                ,
        v_moco_exen_mone                ,
        v_moco_exen_mmnn                ,
        v_moco_empl_codi                ,
        v_moco_lote_codi                ,
        v_moco_bene_codi                ,
        v_moco_medi_codi                ,
        v_moco_cant_medi                ,
        v_moco_anex_codi                ,
        v_moco_indi_excl_cont           ,
        v_moco_anex_nume_item           ,
        v_moco_juri_codi             );
       
        if nvl(bdet.conc_indi_kilo_vehi, 'N') in ('S', 'M') then
          pp_actualiza_gast_vehi;
        end if;

end pp_actualiza_moco;

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
  v_movi_clpr_sucu_nume_item  number;
  v_movi_indi_apli_rrhh       varchar2(1);
  
begin
  --- asignar valores....
  bcab.movi_codi            := fa_sec_come_movi;
  bcab.movi_oper_codi       := null;
  bcab.movi_fech_grab       := sysdate;
  bcab.movi_user            := gen_user;
  v_movi_codi                := bcab.movi_codi;
  v_movi_timo_codi           := bcab.movi_timo_codi;
  v_movi_clpr_codi           := bcab.movi_clpr_codi;
  v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
  v_movi_depo_codi_orig      := null;
  v_movi_sucu_codi_dest      := null;
  v_movi_depo_codi_dest      := null;
  v_movi_oper_codi           := null;
  v_movi_cuen_codi           := null;
  v_movi_mone_codi           := bcab.movi_mone_codi;
  v_movi_nume                := bcab.movi_nume;
  v_movi_fech_emis           := bcab.movi_fech_emis;
  v_movi_fech_oper           := bcab.movi_fech_oper;
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
  v_movi_indi_iva_incl       := null;
  v_movi_empl_codi           := bcab.movi_empl_codi;
  v_movi_nume_timb           := bcab.movi_nume_timb;
  v_movi_fech_venc_timb      := bcab.fech_venc_timb;
  v_movi_codi_rete           := null; --se actualizara cuando se grabe la retencion
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
  v_movi_clpr_sucu_nume_item  := bcab.sucu_nume_item;
  v_movi_indi_apli_rrhh       := 'S';
  
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
                      v_movi_indi_apli_rrhh);

end pp_actualiza_come_movi;

procedure pp_calcular_importe_cab is

Begin
  
  bcab.movi_grav10_ii_mone := bcab.s_grav_10_ii;
  bcab.movi_grav5_ii_mone  := bcab.s_grav_5_ii;
  bcab.movi_exen_mone	    := bcab.s_exen;
  
  bcab.movi_impo_mone_ii := bcab.movi_grav10_ii_mone + bcab.movi_grav5_ii_mone + bcab.movi_exen_mone;
  bcab.s_total           := bcab.movi_impo_mone_ii;
  
  ---raise_application_error(-20001,bcab.s_grav_5_ii||'--'||bcab.movi_tasa_mone);
  ---importe iva incluido en mmnn
  bcab.movi_grav10_ii_mmnn := round((bcab.movi_grav10_ii_mone*bcab.movi_tasa_mone), parameter.p_cant_deci_mmnn);
  bcab.movi_grav5_ii_mmnn  := round((bcab.movi_grav5_ii_mone*bcab.movi_tasa_mone), parameter.p_cant_deci_mmnn);
  bcab.movi_exen_mmnn	    := round((bcab.movi_exen_mone*bcab.movi_tasa_mone), parameter.p_cant_deci_mmnn);
  
  bcab.movi_iva10_mone     := round((bcab.movi_grav10_ii_mone/11), bcab.movi_mone_cant_deci);
  bcab.movi_iva5_mone      := round((bcab.movi_grav5_ii_mone/21), bcab.movi_mone_cant_deci);
  
  bcab.s_iva_10             := bcab.movi_iva10_mone;
  bcab.s_iva_5	             := bcab.movi_iva5_mone;
  bcab.s_tot_iva            := bcab.movi_iva10_mone + bcab.movi_iva5_mone;
  
  bcab.movi_iva10_mmnn     := round((bcab.movi_grav10_ii_mmnn/11), parameter.p_cant_deci_mmnn);
  bcab.movi_iva5_mmnn      := round((bcab.movi_grav5_ii_mmnn/21), parameter.p_cant_deci_mmnn);
  
  bcab.movi_grav10_mone     := round((bcab.movi_grav10_ii_mone/1.1), bcab.movi_mone_cant_deci);
  bcab.movi_grav5_mone      := round((bcab.movi_grav5_ii_mone/1.05), bcab.movi_mone_cant_deci);
  
  bcab.movi_grav10_mmnn     := round((bcab.movi_grav10_ii_mmnn/1.1), parameter.p_cant_deci_mmnn);
  bcab.movi_grav5_mmnn      := round((bcab.movi_grav5_ii_mmnn/1.05), parameter.p_cant_deci_mmnn);
  
  bcab.movi_impo_mmnn_ii    := bcab.movi_grav10_ii_mmnn+ bcab.movi_grav5_ii_mmnn + bcab.movi_exen_mmnn;
         
  --importes netos
  bcab.movi_grav_mone     := bcab.movi_grav10_mone + bcab.movi_grav5_mone;     
  bcab.movi_iva_mone      := bcab.movi_iva10_mone + bcab.movi_iva5_mone;
  
  bcab.movi_grav_mmnn     := nvl(bcab.movi_grav10_mmnn,0) + nvl(bcab.movi_grav5_mmnn,0);     
  bcab.movi_iva_mmnn      := bcab.movi_iva10_mmnn + bcab.movi_iva5_mmnn;
  
  --saldo 
  if nvl(bcab.movi_timo_indi_sald, 'N') = 'N' then -- si no afecta el saldo del cliente o proveedor
    bcab.movi_sald_mone      := 0;
    bcab.movi_sald_mmnn      := 0;  
  else
  	bcab.movi_sald_mone  := bcab.movi_impo_mone_ii;
  	bcab.movi_sald_mmnn  := bcab.movi_impo_mmnn_ii;
  end if;
 
end pp_calcular_importe_cab;


procedure pp_calcular_importe_item is 


begin                                                     
 if nvl(parameter.p_vali_deta, 'N') = 'S' then
  bdet.moco_impo_mmnn_ii := round((bdet.moco_impo_mone_ii*bcab.movi_tasa_mone), parameter.p_cant_Deci_mmnn);  
        
  pa_devu_impo_calc(bdet.moco_impo_mone_ii,
                    bcab.movi_mone_cant_deci,
                    bdet.moco_impu_porc,
                    bdet.moco_impu_porc_base_impo,
                    bdet.moco_impu_indi_baim_impu_incl,
                    bdet.moco_impo_mone_ii,
                    bdet.moco_grav10_ii_mone,
                    bdet.moco_grav5_ii_mone,
                    bdet.moco_grav10_mone,
                    bdet.moco_grav5_mone,
                    bdet.moco_iva10_mone,
                    bdet.moco_iva5_mone,
                    bdet.moco_Exen_mone);
  
  pa_devu_impo_calc(bdet.moco_impo_mmnn_ii,
                    parameter.p_cant_deci_mmnn,
                    bdet.moco_impu_porc,
                    bdet.moco_impu_porc_base_impo,
                    bdet.moco_impu_indi_baim_impu_incl,
                    bdet.moco_impo_mmnn_ii,
                    bdet.moco_grav10_ii_mmnn,
                    bdet.moco_grav5_ii_mmnn,
                    bdet.moco_grav10_mmnn,
                    bdet.moco_grav5_mmnn,
                    bdet.moco_iva10_mmnn,
                    bdet.moco_iva5_mmnn,
                    bdet.moco_exen_mmnn);
    
  bdet.moco_impo_mmnn := bdet.moco_exen_mmnn + bdet.moco_grav10_mmnn + bdet.moco_grav5_mmnn;
  bdet.moco_impo_mone := bdet.moco_exen_mone + bdet.moco_grav10_mone + bdet.moco_grav5_mone;
 
 end if;

end pp_calcular_importe_item;   

procedure pp_ajustar_importes is
v_movi_impo_mmnn_ii           number := 0;
v_sum_moco_impo_mmnn_ii       number := 0;
v_movi_exen_mmnn              number := 0; 
v_sum_moco_exen_mmnn          number := 0;
v_movi_grav10_ii_mmnn         number := 0;
v_sum_moco_grav10_ii_mmnn     number := 0;
v_movi_grav5_ii_mmnn          number := 0;
v_sum_moco_grav5_ii_mmnn      number := 0;
v_movi_iva10_mmnn             number := 0;
v_sum_moco_iva10_mmnn         number := 0;
v_movi_iva5_mmnn              number := 0;
v_sum_moco_iva5_mmnn          number := 0;
v_movi_grav10_mmnn            number := 0;
v_sum_moco_grav10_mmnn        number := 0;
v_movi_grav5_mmnn             number := 0;
v_sum_moco_grav5_mmnn         number := 0;
v_nro_item                    number := 0;
v_movi_exen_mone              number := 0;
v_sum_moco_exen_mone          number := 0;
v_movi_grav10_ii_mone         number := 0;
v_sum_moco_grav10_ii_mone     number := 0;
v_movi_grav5_ii_mone          number := 0;
v_sum_moco_grav5_ii_mone      number := 0;
v_movi_iva10_mone             number := 0;
v_sum_moco_iva10_mone         number := 0;
v_movi_iva5_mone              number := 0;
v_sum_moco_iva5_mone          number := 0;
v_movi_grav10_mone            number := 0;
v_sum_moco_grav10_mone        number := 0;
v_movi_grav5_mone             number := 0;
v_sum_moco_grav5_mone         number := 0;

v_item_mayor number := 0;
v_impo_mayor number := 0;
begin
  
parameter.p_vali_deta := 'N';

v_impo_mayor := bdet.moco_impo_mone_ii;
v_item_mayor := 1;
---determinamos el mayor item
if bdet.moco_conc_codi is null then
   raise_application_error(-20001,'Debe ingresar al menos un item');
end if;

    v_nro_item := v_nro_item + 1;
    bdet.moco_nume_item := v_nro_item;
    pp_calcular_importe_item;
    if bdet.moco_impo_mone_ii > v_impo_mayor then
        v_impo_mayor := bdet.moco_impo_mone_ii;
        v_item_mayor := bdet.moco_nume_item;
    end if;   
 

pp_calcular_importe_cab; 
--pp_calcular_importe_cab_fp; 


v_movi_exen_mone      := bcab.movi_exen_mone;
v_sum_moco_exen_mone  := bdet.sum_moco_exen_mone;

if v_movi_exen_mone <> v_sum_moco_exen_mone then  
 bdet.moco_exen_mone :=  bdet.moco_exen_mone + (v_movi_exen_mone - v_sum_moco_exen_mone);
end if;


v_movi_grav10_ii_mone      := bcab.movi_grav10_ii_mone;
v_sum_moco_grav10_ii_mone  := bdet.sum_moco_grav10_ii_mone;

if v_movi_grav10_ii_mone <> v_sum_moco_grav10_ii_mone then  
 bdet.moco_grav10_ii_mone :=   bdet.moco_grav10_ii_mone + (v_movi_grav10_ii_mone - v_sum_moco_grav10_ii_mone);
end if;


v_movi_grav5_ii_mone      := bcab.movi_grav5_ii_mone;
v_sum_moco_grav5_ii_mone  := bdet.sum_moco_grav5_ii_mone;

if v_movi_grav5_ii_mone <> v_sum_moco_grav5_ii_mone then  
 bdet.moco_grav5_ii_mone :=  bdet.moco_grav5_ii_mone + (v_movi_grav5_ii_mone - v_sum_moco_grav5_ii_mone);
end if;


v_movi_iva10_mone      := bcab.movi_iva10_mone;
v_sum_moco_iva10_mone  := bdet.sum_moco_iva10_mone;


if v_movi_iva10_mone <> v_sum_moco_iva10_mone then  
 bdet.moco_iva10_mone :=   bdet.moco_iva10_mone + (v_movi_iva10_mone - v_sum_moco_iva10_mone);
end if;


v_movi_iva5_mone      := bcab.movi_iva5_mone;
v_sum_moco_iva5_mone  := bdet.sum_moco_iva5_mone;

if v_movi_iva5_mone <> v_sum_moco_iva5_mone then  
 bdet.moco_iva5_mone :=  bdet.moco_iva5_mone + (v_movi_iva5_mone - v_sum_moco_iva5_mone);
end if;



v_movi_grav10_mone      := bcab.movi_grav10_mone;
v_sum_moco_grav10_mone  := bdet.sum_moco_grav10_mone;

if v_movi_grav10_mone <> v_sum_moco_grav10_mone then  
 bdet.moco_grav10_mone :=  bdet.moco_grav10_mone + (v_movi_grav10_mone - v_sum_moco_grav10_mone);
end if;

v_movi_grav5_mone      := bcab.movi_grav5_mone;
v_sum_moco_grav5_mone  := bdet.sum_moco_grav5_mone;

if v_movi_grav5_mone <> v_sum_moco_grav5_mone then  
 bdet.moco_grav5_mone :=   bdet.moco_grav5_mone + (v_movi_grav5_mone - v_sum_moco_grav5_mone);
end if;



v_movi_impo_mmnn_ii     :=bcab.movi_impo_mmnn_ii;
v_sum_moco_impo_mmnn_ii :=bdet.sum_moco_impo_mmnn_ii;

if v_movi_impo_mmnn_ii <> v_sum_moco_impo_mmnn_ii then  
  bdet.moco_impo_mmnn_ii := bdet.moco_impo_mmnn_ii + (v_movi_impo_mmnn_ii - v_sum_moco_impo_mmnn_ii);
end if; 

v_movi_exen_mmnn     := bcab.movi_exen_mmnn;
v_sum_moco_exen_mmnn := bdet.sum_moco_exen_mmnn;

if v_movi_exen_mmnn <> v_sum_moco_exen_mmnn then  
 bdet.moco_exen_mmnn :=  bdet.moco_exen_mmnn + (v_movi_exen_mmnn - v_sum_moco_exen_mmnn);
end if;


v_movi_grav10_ii_mmnn     := bcab.movi_grav10_ii_mmnn;
v_sum_moco_grav10_ii_mmnn := bdet.sum_moco_grav10_ii_mmnn;

if v_movi_grav10_ii_mmnn <>v_sum_moco_grav10_ii_mmnn then 
  bdet.moco_grav10_ii_mmnn := bdet.moco_grav10_ii_mmnn + (v_movi_grav10_ii_mmnn - v_sum_moco_grav10_ii_mmnn);
end if; 



v_movi_grav5_ii_mmnn     := bcab.movi_grav5_ii_mmnn;
v_sum_moco_grav5_ii_mmnn := bdet.sum_moco_grav5_ii_mmnn;

if v_movi_grav5_ii_mmnn <>v_sum_moco_grav5_ii_mmnn then 
  bdet.moco_grav5_ii_mmnn := bdet.moco_grav5_ii_mmnn + (v_movi_grav5_ii_mmnn - v_sum_moco_grav5_ii_mmnn);
end if; 


  
v_movi_iva10_mmnn     := bcab.movi_iva10_mmnn;
v_sum_moco_iva10_mmnn := bdet.sum_moco_iva10_mmnn;

if v_movi_iva10_mmnn <>v_sum_moco_iva10_mmnn then 
  bdet.moco_iva10_mmnn := bdet.moco_iva10_mmnn + (v_movi_iva10_mmnn - v_sum_moco_iva10_mmnn);
end if; 
  

v_movi_iva5_mmnn     := bcab.movi_iva5_mmnn;
v_sum_moco_iva5_mmnn := bdet.sum_moco_iva5_mmnn;

if v_movi_iva5_mmnn <>v_sum_moco_iva5_mmnn then 
  bdet.moco_iva5_mmnn := bdet.moco_iva5_mmnn + (v_movi_iva5_mmnn - v_sum_moco_iva5_mmnn);
end if; 



v_movi_grav10_mmnn     := bcab.movi_grav10_mmnn;
v_sum_moco_grav10_mmnn := bdet.sum_moco_grav10_mmnn;

if v_movi_grav10_mmnn <>v_sum_moco_grav10_mmnn then 
  bdet.moco_grav10_mmnn := bdet.moco_grav10_mmnn + (v_movi_grav10_mmnn - v_sum_moco_grav10_mmnn);
end if; 


v_movi_grav5_mmnn     := bcab.movi_grav5_mmnn;
v_sum_moco_grav5_mmnn := bdet.sum_moco_grav5_mmnn;

if v_movi_grav5_mmnn <>v_sum_moco_grav5_mmnn then 
  bdet.moco_grav5_mmnn := bdet.moco_grav10_mmnn + (v_movi_grav5_mmnn - v_sum_moco_grav5_mmnn);
end if; 

  bdet.moco_impo_mmnn := bdet.moco_exen_mmnn + bdet.moco_grav10_mmnn + bdet.moco_grav5_mmnn;  
  bdet.moco_impo_mone := bdet.moco_exen_mone + bdet.moco_grav10_mone + bdet.moco_grav5_mone;

  
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
Begin
  pack_ortr.pa_agru_ortr_temp(null, null, 'D');

    if bdet.moco_ortr_codi is not null then
      pack_ortr.pa_agru_ortr_temp(bdet.moco_ortr_codi, bdet.moco_impo_mmnn_ii, 'I');
    end if;

  
  for x in c_ortr loop
    v_limi_cost := pack_ortr.fa_dev_limi_cost(x.ortr_codi);
    v_cost_actu := pack_ortr.fa_dev_cost_ortr(x.ortr_codi);
    
    if nvl(v_cost_actu,0) + nvl(x.impo ,0) > nvl(v_limi_cost,0) then
      raise_application_error(-20001,'El Costo de la OT '||x.ortr_nume||' supera el l?mite de Costo');
    end if;
  end loop;
  
end  pp_valida_limite_costo;


procedure pp_validar_conceptos is

v_indi_ot varchar2(1) :='n';
begin                 
    
    --validar gastos judiciales
    if nvl(lower(bdet.conc_indi_gast_judi), 'n') = 's' then
      if bdet.moco_juri_codi is null then
        raise_application_error(-20001,'Debe ingresar un nro de expediente judicial para el concepto '||bdet.moco_conc_codi||' '||bdet.moco_conc_desc);
      end if;
    else
       bdet.moco_juri_codi := null;  
       bdet.juri_nume      := null;  
    end if;    
    
    
    ---validar importaciones
    if nvl(lower(bdet.conc_indi_impo), 'n') = 's' then
      if bdet.moco_impo_codi is null then
        raise_application_error(-20001,'Debe ingresar una importacion para el concepto '||bdet.moco_conc_codi||' '||bdet.moco_conc_desc);
      end if;
    else
     bdet.moco_impo_codi := null;
     bdet.impo_nume      := null;
    end if;
   
     --validar centro de costos
    if lower(nvl(bdet.conc_indi_cent_cost, 'n')) = 's' then
      if bdet.moco_ceco_codi is null then
         raise_application_error(-20001,'Debe ingresar el centro de costo');
       end if;
    else
       bdet.moco_ceco_codi := null;
       bdet.ceco_nume      := null;       
    end if ;
    
    --validar Orden de servicio
     -----no se valida ------
    
    --validar secciones de empresa
    if nvl(lower(parameter.p_indi_most_secc_dbcr), 'n') = 's'  then
      if bdet.moco_emse_codi is null then
         raise_application_error(-20001,'Debe ingresar la seccion de la empresa');
      end if; 
    else
      bdet.moco_emse_codi := null;
    end if;
    
     --validar OT
    if nvl(lower(bdet.conc_indi_ortr), 'n') = 's' then
      if bdet.moco_ortr_codi is null then
        raise_application_error(-20001,'Debe ingresar el Nro de OT');
      end if; 
    else
       bdet.moco_ortr_codi := null;
       bdet.ortr_nume      := null;    
    end if; 
    
     ---validar gastos de veihicuos y km
    if nvl(lower(bdet.conc_indi_kilo_vehi), 'n') <> 'n'  then
       if nvl(lower(bdet.conc_indi_kilo_vehi), 'n') in ('s', 'sg')  then       
         if bdet.moco_tran_codi is null then
          raise_application_error(-20001,'Debe ingresar el codigo del vehiculo');
         end if;  
      end if; 
    else
      bdet.moco_tran_codi := null;   
      bdet.tran_codi_alte := null; 
    end if; 
    
    
    if bdet.moco_ortr_codi is not null then
     v_indi_ot := 's';
    end if;
  
  if v_indi_ot = 's' then  
    pp_valida_limite_costo;
  end if;
  
end pp_validar_conceptos;
                      
procedure pp_validar_importes is
begin             
                           
 if bcab.movi_timo_indi_caja = 'S' then --mov. q afecta a caja
    /*if bcab.movi_timo_codi in (parameterp_codi_timo_auto_fact_emit, parameterp_codi_timo_auto_fact_emit_cr) then
      if parameterp_indi_apli_rete_exen = 'S' and nvl(bcab.clpr_indi_clie_prov, 'C') = 'P' then
        if (nvl(bcab.s_impo_cheq,0) + nvl(bcab.s_impo_efec,0) +  nvl(bcab.s_impo_tarj,0) 
          + nvl(bcab.s_impo_adel,0) + nvl(bcab.s_impo_vale,0)) 
          + nvl(bcab.s_impo_rete_reci,0)
          + nvl(bcab.s_impo_viaj,0)
          <> (nvl(bcab.s_total,0) - nvl(bcab.s_impo_rete, 0) - nvl(bcab.s_impo_rete_rent, 0)) then
           pl_me ('El importe total de cheques + el importe en efectivo + el importe en tarjetas '||
                  '+ el importe en Vales a rendir + el importe de Retenciones Recibidas '||
                  'debe ser igual al importe del documento - las Retenciones');
        end if;     --no se agrego aun adelanto en el mensaje. 
      else        
        if (nvl(bcab.s_impo_cheq,0) + nvl(bcab.s_impo_efec,0) +  nvl(bcab.s_impo_tarj,0) 
          + nvl(bcab.s_impo_adel,0) + nvl(bcab.s_impo_vale,0)) 
          + nvl(bcab.s_impo_rete_reci,0)
          + nvl(bcab.s_impo_viaj,0)
          <> (nvl(bcab.s_total,0)) then
           pl_me ('El importe total de cheques + el importe en efectivo + el importe en tarjetas '||
                  '+ el importe en Vales a rendir + el importe de Retenciones Recibidas '||
                  'debe ser igual al importe del documento');
        end if;     --no se agrego aun adelanto en el mensaje.
      end if;
    else*/
     if nvl(bdet.moco_impo_mone_ii,0)/*(nvl(bcab.s_impo_cheq,0) + nvl(bcab.s_impo_efec,0) +  nvl(bcab.s_impo_tarj,0) 
        + nvl(bcab.s_impo_adel,0) + nvl(bcab.s_impo_vale,0)) 
        + nvl(bcab.s_impo_rete_reci,0)
        + nvl(bcab.s_impo_viaj,0)*/
        <> nvl(bcab.s_total,0) /*- nvl(bcab.s_impo_rete, 0) - nvl(bcab.s_impo_rete_rent, 0))*/ then
         raise_application_error (-20001, 'El importe total debe ser igual al importe del documento.');
     end if;      
   --end if;
 
   --valida que no cambio el codigo de cliente/proveedor en la cabecera luego de generar los cheques

  --pl_valida_clie_prov_cheq;
  
  /*if :bfp_cab.s_impo_sald <> 0 then
    pl_me('Existe una diferencia en montos. Saldo distinto a 0(cero).');
  end if;*/
  ---
  
 end if; 

end pp_validar_importes;

procedure pp_valida_totales is
begin
  if bdet.f_dif_impo <> 0 then
     raise_application_error(-20001,'Existe una diferencia entre el total importe y el detalle de conceptos');
  end if;

  if bdet.f_dif_impo_exen_mone <> 0 then
      raise_application_error(-20001,'Existe una diferencia entre el total exento y el detalle de conceptos');
  end if; 
  
  
  if bdet.f_dif_impo_grav5_ii_mone <> 0 then
      raise_application_error(-20001,'Existe una diferencia entre el total Grav5 y el detalle de conceptos');
  end if; 
    
    
  if bdet.f_dif_impo_grav10_ii_mone <> 0 then
      raise_application_error(-20001,'Existe una diferencia entre el total grav10 y el detalle de conceptos');
  end if; 
  
  /*if bcab.movi_afec_sald = 'N' then
    if nvl(:bfp.SUM_S_IMPO_MOVI,0) <> nvl(:bfp_cab.S_IMPO_MONE,0) then
      -- si existe diferencia y el documento es en gs. el pago es en otra moneda, 
      -- por ende se ajustar? en importe nacional si es menor a 100gs
      if bcab.movi_mone_codi = parameterp_codi_mone_mmnn then
        if :bfp.SUM_S_IMPO_DIFE_MMNN > 100 then
          pl_me('Existe una diferencia entre el total del movimiento y el detalle de pago en la forma de pago.');
        end if;
      else
      --si el documento es en otra moneda, el importe del movimiento debe coincidir si o si con el importe de forma de pago.
      --en caso de mas de un tipo de moneda, se ajustara en gs.   
        pl_me('Existe una diferencia entre el total del movimiento y el detalle de pago en la forma de pago.');
      end if;
    end if;
  end if;*/
end pp_valida_totales;                              


procedure pp_dele_cheq (p_movi_codi in number) is
  cursor c_cheq_movi  is
    select chmo_cheq_codi, chmo_movi_codi, chmo_esta_ante, chmo_cheq_secu, nvl(cheq_indi_ingr_manu, 'N') cheq_indi_ingr_manu
      from come_movi_cheq, come_cheq
     where cheq_codi = chmo_cheq_codi
       and chmo_movi_codi = p_movi_codi;

begin
  
  for x in c_cheq_movi loop
    update come_movi_cheq
       set chmo_base = parameter.p_codi_base
     where chmo_movi_codi = x.chmo_movi_codi
       and chmo_cheq_codi = x.chmo_cheq_codi;
    
    delete come_movi_cheq 
     where chmo_movi_codi = x.chmo_movi_codi
       and chmo_cheq_codi = x.chmo_cheq_codi; 
    
    --solo se debe borrar el cheque en caso q el estado anterior sea nulo, o sea q dio ingreso al cheq
    --y la secuencia sea 1, adem?s q no fuese ingresado manualmente...................................
    if x.chmo_esta_ante is null and x.chmo_cheq_secu = 1 and x.cheq_indi_ingr_manu = 'N' then 

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
          
          raise_application_error(-20001, 'Un cheque forma parte de un Cierre de Caja de Fecha: '||(v_caja_fech)||' Caja: '||v_caja_cuen_codi);
        end if;
      exception
        when no_data_found then
          null;
      end;
      
      update come_movi_cheq_canj c
         set c.canj_base = parameter.p_codi_base
       where c.canj_cheq_codi_entr = x.chmo_cheq_codi
         and c.canj_movi_codi = p_movi_codi;
      
      delete come_movi_cheq_canj c
       where c.canj_cheq_codi_entr = x.chmo_cheq_codi
         and c.canj_movi_codi = p_movi_codi;
      
      update come_cheq
         set cheq_base = parameter.p_codi_base
       where cheq_codi = x.chmo_cheq_codi;  
      
      delete come_cheq
       where cheq_codi = x.chmo_cheq_codi;  
         
    end if; 
      
  end loop;     
end pp_dele_cheq;



procedure pp_borrar_asiento (p_movi_codi in number) is

cursor c_moas is
    select moas_asie_codi, nvl(moas_tipo, 'A') moas_tipo
    from come_movi_asie
    where moas_movi_codi = p_movi_codi;
begin
  for x in c_moas loop
     if x.moas_tipo <> 'M'	then
       raise_application_error(-20001,'No se puede eliminar el Documento porque el asiento relacionado no fue generado desde un movimiento');
     else
       delete come_movi_asie 
       where moas_asie_codi = x.moas_asie_codi;
     	 
       delete come_asie_deta where deta_asie_codi = x.moas_asie_codi;
       delete come_asie where asie_codi = x.moas_asie_codi;
     end if;	
  end loop;
end pp_borrar_asiento;

procedure pp_borrar_movi_hijos (p_movi_codi in number)is

cursor c_hijos (p_codi in number)is
        select movi_codi
        from come_movi
        where movi_codi_padr = p_codi;

cursor c_nietos (p_codi in number)is
        select movi_codi
        from come_movi
        where movi_codi_padr = p_codi;

begin

  for x in c_hijos (p_movi_codi) loop    
     for y in c_nietos(x.movi_codi) loop

        update come_movi_prod_deta set deta_base=parameter.p_codi_base
        where deta_movi_codi = y.movi_codi;
        delete come_movi_prod_deta
        where deta_movi_codi = y.movi_codi;    
              
        update come_movi_ortr_deta set deta_base=parameter.p_codi_base
        where deta_movi_codi = y.movi_codi; 
        delete come_movi_ortr_deta
        where deta_movi_codi = y.movi_codi;
              
        update come_movi_cuot set cuot_base=parameter.p_codi_base
        where cuot_movi_codi = y.movi_codi;
        delete come_movi_cuot
        where cuot_movi_codi = y.movi_codi;       
  
        update come_movi_impu_deta set moim_base=parameter.p_codi_base
        where moim_movi_codi = y.movi_codi;
        delete come_movi_impu_deta
        where moim_movi_codi = y.movi_codi; 
        
        update come_movi_ortr_prod_deta set deta_base=parameter.p_codi_base
        where deta_movi_codi = y.movi_codi;
        delete come_movi_ortr_prod_deta
        where deta_movi_codi = y.movi_codi; 
        
        
        update come_movi 
           set movi_base = parameter.p_codi_base, 
               movi_codi_rete = null
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
                raise_application_error(-20001,'Un documento nieto forma parte de un Cierre de Caja de Fecha: '||(v_caja_fech)||' Caja: '||v_caja_cuen_codi);
          end if;
        exception
          when no_data_found then
            null;
        end;
        
        update come_movi_impo_deta set moim_base=parameter.p_codi_base
        where moim_movi_codi = y.movi_codi;
        delete come_movi_impo_deta
        where moim_movi_codi = y.movi_codi;         
--*****************************************
        
        update come_movi_conc_deta set moco_base=parameter.p_codi_base
        where moco_movi_codi = y.movi_codi;
        delete come_movi_conc_deta
        where moco_movi_codi = y.movi_codi;
       
  
        pp_dele_cheq(y.movi_codi);
        
        update come_movi_cuot_canc set canc_base=parameter.p_codi_base
        where canc_movi_codi = y.movi_codi;
        delete come_movi_cuot_canc 
        where canc_movi_codi = y.movi_codi;   
        
        update come_pres_clie 
           set pres_movi_codi = null,
               pres_base      = parameter.p_codi_base
        where pres_movi_codi = y.movi_codi;
        
        
        --borra detalle de contratos
        update come_movi_cont_deta set  como_base = parameter.p_codi_base
        where como_movi_codi = y.movi_codi;
        
        delete come_movi_cont_deta 
        where como_movi_codi = y.movi_codi;

        update come_movi set movi_base=parameter.p_codi_base
        where movi_codi = y.movi_codi;
        delete come_movi
        where movi_codi = y.movi_codi;            
     end loop;
     
   
      update come_movi_prod_deta set deta_base=parameter.p_codi_base
      where deta_movi_codi = x.movi_codi;
      delete come_movi_prod_deta
      where deta_movi_codi = x.movi_codi;       
   
      update come_movi_cuot set cuot_base=parameter.p_codi_base
      where cuot_movi_codi = x.movi_codi;
      delete come_movi_cuot
      where cuot_movi_codi = x.movi_codi;       
   
      update come_movi_impu_deta set moim_base=parameter.p_codi_base
      where moim_movi_codi = x.movi_codi;
      delete come_movi_impu_deta
      where moim_movi_codi = x.movi_codi;               
      
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
          raise_application_error(-20001,'Un documento hijo forma parte de un Cierre de Caja de Fecha: '||(v_caja_fech)||' Caja: '||v_caja_cuen_codi);
        end if;
      exception
        when no_data_found then
          null;
      end;
      update come_movi_impo_deta set moim_base=parameter.p_codi_base
      where moim_movi_codi = x.movi_codi;
      delete come_movi_impo_deta
      where moim_movi_codi = x.movi_codi;
--*****************************************
  
      update come_movi_conc_deta set moco_base=parameter.p_codi_base
      where moco_movi_codi = x.movi_codi;
      delete come_movi_conc_deta
      where moco_movi_codi = x.movi_codi;       
  
      pp_dele_cheq(x.movi_codi);
  
      update come_movi_cuot_canc set canc_base=parameter.p_codi_base
      where canc_movi_codi = x.movi_codi;
      delete come_movi_cuot_canc 
      where canc_movi_codi = x.movi_codi;   
      
      
   
       update come_pres_clie 
          set pres_movi_codi = null,
              pres_base      =parameter.p_codi_base
       where pres_movi_codi = x.movi_codi;
        
     --borra detalle de contratos
   
      update come_movi_cont_deta set  como_base = parameter.p_codi_base
      where como_movi_codi = x.movi_codi;
        
      delete come_movi_cont_deta 
      where como_movi_codi = x.movi_codi;

      update come_movi set movi_base=parameter.p_codi_base
      where movi_codi = x.movi_codi;
      delete come_movi
      where movi_codi = x.movi_codi;   
      
      
      update come_movi 
         set movi_base = parameter.p_codi_base, 
             movi_codi_rete = null
      where movi_codi_rete = x.movi_codi;               
       
     
  end loop; 
  
end pp_borrar_movi_hijos;

procedure pp_validar_asiento (p_movi_codi in number) is

cursor c_moas is
select moas_asie_codi, nvl(moas_tipo, 'A') moas_tipo
from come_movi_asie
where moas_movi_codi = p_movi_codi;
begin

  for x in c_moas loop
   if x.moas_tipo <> 'M'	then
      raise_application_error(-20001,'No se puede eliminar el Documento porque posee un asiento automatico. Primero debes borrar el asiento relacionado');
   end if;	
	
end loop;

end pp_validar_asiento;

procedure pp_borrar_registro(p_movi_codi in number) is
  salir exception;
  v_message varchar2(100) := 'Desea borrar definitivamente el documento?';
begin

    pp_borrar_Asiento(p_movi_codi);

    pp_borrar_movi_hijos (p_movi_codi);
    
    --Detalle de productos..................
    delete from  come_movi_prod_deta c
    where c.deta_movi_codi = p_movi_codi;
    --Detalle de Cuotas.....................
    delete from come_movi_cuot 
    where cuot_movi_codi = p_movi_codi;
    ---detalle de Impuestos.................
    delete come_movi_impu_deta
    where moim_movi_codi = p_movi_codi;
    
    ---detalle de conceptos.................
    delete come_movi_conc_deta
    where moco_movi_codi = p_movi_codi;
    
    --detalle de importes...
    delete come_movi_impo_deta
    where moim_movi_codi = p_movi_codi;
    
    --detalle de cheques
    pp_dele_cheq(p_movi_codi);
    
    delete come_movi
    where movi_codi = p_movi_codi;  
 
end pp_borrar_registro;
            
procedure pp_valida_fech_borr_apli (p_fech in date) is
begin               
 

  if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
  	raise_application_error(-20001,'La fecha de la aplicaci?n a eliminar debe estar comprendida entre..'||parameter.p_fech_inic||' y '||parameter.p_fech_fini);
  end if;	
                          
end pp_valida_fech_borr_apli;  

procedure pp_valida_asie_apli (p_apli_codi in number, p_apli_fech in date) is
v_Count number;
Begin
  
  select count(*)
  into v_Count
  from rrhh_movi_apli_liqu_asie
  where apas_apli_codi = p_apli_codi;
  
  if v_count > 0 then
  	  	raise_application_error(-20001,'La aplicacion '||p_apli_codi||' de fecha '||p_apli_fech||' ya posee asiento generado, para eliminar la aplicacion, primero se debe borrar el asiento generado' );
  end if;	
  
end pp_valida_asie_apli;  
  
procedure pp_validaciones is
  vbliqu_sum_saldo_sele number;
Begin
     select sum(nvl(c013,0))
      into vbliqu_sum_saldo_sele
      from apex_collections a
     where a.collection_name = 'DETALLE';
--raise_application_error(-20001,vbliqu_sum_saldo_sele||'--'||nvl(bcab.sald_apli_fact,0));
   if bsel.indi_regi_apli = 'A' then
    if bcab.movi_fech_apli is null then
    raise_application_error(-20001,'La fecha de la aplicacion no puede quedar vacia');
    end if;
      if nvl(vbliqu_sum_saldo_sele,0) <= 0 then
       raise_application_error(-20001,'Debe seleccionar al menos una Liquidacion');
      end if; 
      
      if nvl(vbliqu_sum_saldo_sele,0) > nvl(bcab.sald_apli_fact,0) then
       raise_application_error(-20001,'El total de Liquidaciones seleccionados supera el saldo de aplicacion de la Factura.');
      end if; 
      
      if nvl(bcab.sald_apli_fact,0) <= 0 then
       raise_application_error(-20001,'La Factura no posee saldo a aplicar!');
      end if; 
      
      if bcab.movi_codi is null then
          raise_application_error(-20001,'Debe seleccionar la Factura');
      end if; 
    
    
  elsif bsel.indi_regi_apli = 'E' then
   for bliqu in cur_det loop
      if bliqu.indi_elim = 'S' then
        pp_valida_fech_borr_apli(bliqu.apli_fech);
        pp_valida_asie_apli(bliqu.apli_codi, bliqu.apli_fech);
      end if;    
    end loop;

 end if;
end pp_validaciones;  

procedure pp_actualizar_apli is
  v_apli_codi              number(20);
  v_apli_fech              date;
  v_apli_fech_regi         date;
  v_apli_user_regi         varchar2(40);
  v_apli_movi_codi         number(20);
  v_apli_deta_liqu_codi    number(20);
  v_apli_deta_nume_item    number(20);
  v_apli_impo_mmnn         number(20);
  v_apli_impo_mone			   number(20,4);
  
BEGIN
	
  if bsel.indi_regi_apli = 'A' then
     for bliqu in cur_det loop
      if bliqu.indi = 'S' then
        if bliqu.saldo_sele > 0 then
        	
          v_apli_codi            := fa_sec_come_movi_apli_liqu;
          v_apli_fech            := bcab.movi_fech_apli;--:bsel_tick.fech;
          v_apli_fech_regi       := sysdate;
          v_apli_user_regi       := gen_user;
          v_apli_movi_codi       := bcab.movi_codi;
          v_apli_deta_liqu_codi  := bliqu.deta_liqu_codi;
          v_apli_deta_nume_item  := bliqu.deta_nume_item;
          v_apli_impo_mone       := bliqu.saldo_sele;
          v_apli_impo_mmnn       := v_apli_impo_mone * bcab.movi_tasa_mone;
        
          insert into rrhh_movi_apli_liqu
            (apli_codi,
             apli_fech,
             apli_fech_regi,
             apli_user_regi,
             apli_movi_codi,
             apli_deta_liqu_codi,
             apli_deta_nume_item,
             apli_impo_mmnn,
             apli_impo_mone)
          values
            (v_apli_codi,          
             v_apli_fech,          
             v_apli_fech_regi,     
             v_apli_user_regi,     
             v_apli_movi_codi,     
             v_apli_deta_liqu_codi,
             v_apli_deta_nume_item,
             v_apli_impo_mmnn,     
             v_apli_impo_mone);
        end if;
      end if;
    end loop;
    
  elsif bsel.indi_regi_apli = 'E' then
    --Anulacion de aplicaciones
    for bliqu in cur_det loop
      if bliqu.indi_elim = 'S' and bliqu.apli_codi is not null then
        delete rrhh_movi_apli_liqu where apli_codi = bliqu.apli_codi;
      end if;
     
    end loop;
  end if;
  
end pp_actualizar_apli;

procedure pp_actualizar_registro_apli is
begin

  pp_validaciones;
  
  pp_actualizar_apli;
end pp_actualizar_registro_apli;

procedure pp_actualizar_registro is   
     
v_record number;       
v_resp  varchar2(1000);                          
begin             

  if bcab.movi_codi is not null then
  
    pp_validar_asiento(bcab.movi_codi);
    pp_borrar_registro(bcab.movi_codi);
    bcab.movi_codi := null;
  end if;

  pp_valida_totales;

  if nvl(bcab.s_impo_rete, 0) > 0 /*or nvl(bcab.s_impo_rete_rent, 0) > 0)*/ and brete.movi_nume_timb_rete is null then
  --  go_item('brete.s_nro_3_rete');
    raise_application_error(-20001, 'Debe indicar un numero de timbrado para la retencion');
  end if;

  pp_validar_importes;  
  pp_validar_conceptos;
  pp_ajustar_importes;  

  if bcab.movi_codi is null then 
   --   raise_application_error(-20001, bcab.movi_grav_mmnn||'--'||v('p100_movi_grav_mmnn'));
      pp_actualiza_come_movi;     
      pp_actualiza_moco;      
      pp_actualiza_moimpu;  
      
      if nvl(bcab.s_impo_rete,0) > 0 /*or nvl(bcab.s_impo_rete_rent,0) > 0*/ then   
        pp_actualizar_rete;   
      end if;

      pp_gene_asie;
          

        if nvl(bcab.s_impo_rete,0) > 0 /*or nvl(bcab.s_impo_rete_rent,0) > 0*/ then
        null;--revisar para poder imprimir*****--  pp_impr_rete;
        end if;
        --Generar archivo tesaka
        if nvl(bcab.s_impo_rete, 0) > 0 then    
          if parameter.p_indi_rete_tesaka = 'S' then
            pp_generar_tesaka;
          end if;
        end if;
     
    
  else 
     raise_application_error(-20001, 'Error al actualizar el registro!!!!!!');
  end if; 
   -- raise_application_error(-20001, 'buen dia');                      

end pp_actualizar_registro;

procedure pp_set_variable is
  
begin

bsel.indi_regi_apli :=v('p100_indi_regi_apli');
-----------------
bcab.movi_codi                := V('P100_movi_codi');
bcab.movi_tasa_mone           := V('P100_movi_tasa_mone');
bcab.sald_apli_fact           := V('P100_sald_apli_fact');
bcab.movi_fech_apli       := V('P100_movi_fech_apli');
bcab.movi_mone_cant_deci  := V('P100_movi_mone_cant_deci');
bcab.movi_grav10_ii_mone := V('P100_movi_grav10_ii_mone');
bcab.movi_grav5_ii_mone  := V('P100_movi_grav5_ii_mone');
bcab.movi_exen_mone      := V('P100_movi_exen_mone');
bcab.movi_impo_mone_ii   := V('P100_movi_impo_mone_ii');
bcab.s_total             := V('P100_s_total');
bcab.movi_grav10_ii_mmnn := V('P100_movi_grav10_ii_mmnn');
bcab.movi_grav5_ii_mmnn  := V('P100_movi_grav5_ii_mmnn');
bcab.movi_exen_mmnn      := V('P100_movi_exen_mmnn');
bcab.movi_iva10_mone     := V('P100_movi_iva10_mone');
bcab.movi_iva5_mone      := V('P100_movi_iva5_mone');
bcab.s_grav_10_ii        := V('P100_s_grav_10_ii');
bcab.s_grav_5_ii         := V('P100_s_grav_5_ii');
bcab.s_exen              := nvl(V('P100_s_exen'),0);
bcab.s_iva_10            := nvl(V('P100_s_iva_10'),0);
bcab.s_iva_5             := nvl(V('P100_s_iva_5'),0);
bcab.s_tot_iva           := V('P100_s_tot_iva');
bcab.movi_iva10_mmnn     := V('P100_movi_iva10_mmnn');
bcab.movi_iva5_mmnn      := V('P100_movi_iva5_mmnn');
bcab.movi_grav10_mone    := V('P100_movi_grav10_mone');
bcab.movi_grav5_mone     := V('P100_movi_grav5_mone');
bcab.movi_grav10_mmnn    := V('P100_movi_grav10_mmnn');
bcab.movi_grav5_mmnn     := V('P100_movi_grav5_mmnn');
bcab.movi_impo_mmnn_ii   := V('P100_movi_impo_mmnn_ii');
bcab.movi_grav_mone      := V('P100_movi_grav_mone');    
bcab.movi_iva_mone       := V('P100_movi_iva_mone');
bcab.movi_grav_mmnn      := V('P100_movi_grav_mmnn');     
bcab.movi_iva_mmnn       := V('P100_movi_iva_mmnn');
bcab.movi_timo_indi_sald := V('P100_movi_timo_indi_sald');
bcab.movi_sald_mone      := V('P100_movi_sald_mone');
bcab.movi_sald_mmnn      := V('P100_movi_sald_mmnn');
bcab.movi_timo_indi_caja := V('P100_movi_timo_indi_caja');
bcab.s_impo_rete         := V('P100_s_impo_rete');
bcab.movi_oper_codi      := V('P100_movi_oper_codi');
bcab.movi_fech_grab      := V('P100_movi_fech_grab');
bcab.movi_user           := V('P100_movi_user');
bcab.movi_timo_codi      := V('P100_movi_timo_codi');
bcab.movi_clpr_codi      := V('P100_movi_clpr_codi');
bcab.movi_sucu_codi_orig := V('P100_movi_sucu_codi_orig');
bcab.movi_mone_codi      := V('P100_movi_mone_codi');
bcab.movi_nume           := V('P100_movi_nume');
bcab.movi_fech_emis      := V('P100_movi_fech_emis');
bcab.movi_fech_oper      := V('P100_movi_fech_oper');
bcab.movi_obse           := V('P100_movi_obse');
bcab.movi_stoc_suma_rest := V('P100_movi_stoc_suma_rest');
bcab.movi_clpr_dire      := V('P100_movi_clpr_dire');
bcab.movi_clpr_tele      := V('P100_movi_clpr_tele');
bcab.movi_clpr_ruc       := V('P100_movi_clpr_ruc');
bcab.movi_clpr_desc      := V('P100_movi_clpr_desc');
bcab.movi_emit_reci      := V('P100_movi_emit_reci');
bcab.movi_afec_sald      := V('P100_movi_afec_sald');
bcab.movi_dbcr           := V('P100_movi_dbcr');
bcab.movi_stoc_afec_cost_prom   := V('P100_movi_stoc_afec_cost_prom');
bcab.movi_empr_codi             := V('P100_movi_empr_codi');
bcab.fech_venc_timb             := V('P100_fech_venc_timb');
bcab.movi_nume_timb             := V('P100_movi_nume_timb');
bcab.sucu_nume_item             := V('P100_sucu_nume_item');
bcab.movi_empl_codi             := V('P100_movi_empl_codi');



-------------------------------------------------
bdet.f_dif_impo                    := V('P100_f_dif_impo');
bdet.f_dif_impo_exen_mone          := V('P100_f_dif_impo_exen_mone');
bdet.f_dif_impo_grav5_ii_mone      := V('P100_f_dif_impo_grav5_ii_mone');
bdet.f_dif_impo_grav10_ii_mone     := V('P100_f_dif_impo_grav10_ii_mone');
bdet.conc_indi_gast_judi           := V('P100_conc_indi_gast_judi');
bdet.moco_juri_codi                := V('P100_moco_juri_codi');
bdet.moco_conc_desc                := V('P100_moco_conc_desc');
bdet.juri_nume                     := V('P100_juri_nume');
bdet.conc_indi_impo                := V('P100_conc_indi_impo');
bdet.moco_impo_codi                := V('P100_moco_impo_codi');     
bdet.moco_nume_item                := V('P100_moco_nume_item');
bdet.impo_nume                     := V('P100_impo_nume');
bdet.conc_indi_cent_cost           := V('P100_conc_indi_cent_cost');
bdet.moco_ceco_codi                := V('P100_moco_ceco_codi');
bdet.ceco_nume                     := V('P100_ceco_nume');
bdet.moco_emse_codi                := V('P100_moco_emse_codi');
bdet.conc_indi_ortr                := V('P100_conc_indi_ortr');
bdet.moco_ortr_codi                := V('P100_moco_ortr_codi');
bdet.conc_indi_kilo_vehi           := V('P100_conc_indi_kilo_vehi');
bdet.moco_tran_codi                := V('P100_moco_tran_codi');
bdet.tran_codi_alte                := V('P100_tran_codi_alte');
bdet.moco_conc_codi                := V('P100_moco_conc_codi');
bdet.moco_impo_mmnn_ii             := V('P100_moco_impo_mmnn_ii');
bdet.moco_impu_porc                := V('P100_moco_impu_porc');
bdet.moco_impu_porc_base_impo      := V('P100_moco_impu_porc_base_impo');
bdet.moco_impu_indi_baim_impu_incl := V('P100_mi_indi_baim_impu_incl');
bdet.moco_impo_mone_ii             := V('P100_moco_impo_mone_ii');
bdet.moco_grav10_ii_mone           := V('P100_moco_grav10_ii_mone');
bdet.moco_grav5_ii_mone            := V('P100_moco_grav5_ii_mone');
bdet.moco_grav10_mone              := V('P100_moco_grav10_mone');
bdet.moco_grav5_mone               := V('P100_moco_grav5_mone');
bdet.moco_iva10_mone               := V('P100_moco_iva10_mone');
bdet.moco_iva5_mone                := V('P100_moco_iva5_mone');
bdet.moco_Exen_mone                := V('P100_moco_Exen_mone');
bdet.moco_grav10_ii_mmnn           := V('P100_moco_grav10_ii_mmnn');
bdet.moco_grav5_ii_mmnn            := V('P100_moco_grav5_ii_mmnn');
bdet.moco_grav10_mmnn              := V('P100_moco_grav10_mmnn');
bdet.moco_grav5_mmnn               := V('P100_moco_grav5_mmnn');
bdet.moco_iva10_mmnn               := V('P100_moco_iva10_mmnn');
bdet.moco_iva5_mmnn                := V('P100_moco_iva5_mmnn');
bdet.moco_exen_mmnn                := V('P100_moco_exen_mmnn');
bdet.moco_impo_mmnn                := V('P100_moco_impo_mmnn');
bdet.moco_impo_mone                := V('P100_moco_impo_mone');
bdet.sum_moco_exen_mone            := V('P100_sum_moco_exen_mone');
bdet.sum_moco_grav10_ii_mone       := V('P100_sum_moco_grav10_ii_mone');
bdet.sum_moco_grav5_ii_mone        := V('P100_sum_moco_grav5_ii_mone');
bdet.sum_moco_iva10_mone           := V('P100_sum_moco_iva10_mone');
bdet.sum_moco_iva5_mone            := V('P100_sum_moco_iva5_mone');
bdet.sum_moco_grav10_mone          := V('P100_sum_moco_grav10_mone');
bdet.sum_moco_grav5_mone           := V('P100_sum_moco_grav5_mone');
bdet.sum_moco_impo_mmnn_ii         := V('P100_sum_moco_impo_mmnn_ii');
bdet.sum_moco_exen_mmnn            := V('P100_sum_moco_exen_mmnn');
bdet.sum_moco_grav10_ii_mmnn       := V('P100_sum_moco_grav10_ii_mmnn');
bdet.sum_moco_grav5_ii_mmnn        := V('P100_sum_moco_grav5_ii_mmnn');
bdet.sum_moco_iva10_mmnn           := V('P100_sum_moco_iva10_mmnn');
bdet.sum_moco_iva5_mmnn            := V('P100_sum_moco_iva5_mmnn');
bdet.sum_moco_grav10_mmnn          := V('P100_sum_moco_grav10_mmnn');
bdet.sum_moco_grav5_mmnn           := V('P100_sum_moco_grav5_mmnn');
bdet.ortr_nume                     := V('P100_ortr_nume');
bdet.gatr_litr_carg                := V('P100_gatr_litr_carg');
bdet.gatr_kilo_actu                := V('P100_gatr_kilo_actu');
bdet.moco_impu_codi                := V('P100_moco_impu_codi');
bdet.moco_dbcr                     := V('P100_moco_dbcr');
bdet.moco_desc                     := V('P100_moco_desc');
bdet.moco_tiim_codi                := V('P100_moco_tiim_codi');
bdet.moco_orse_codi                := V('P100_moco_orse_codi');
bdet.moco_conc_codi_impu           := V('P100_moco_conc_codi_impu');

brete.movi_nume_timb_rete            :=v('p100_movi_nume_timb_rete');
brete.movi_nume_rete                 :=v('p100_movi_nume_rete'); 
brete.movi_impo_rete                 :=v('p100_movi_impo_rete');
brete.movi_impo_rete_rent            :=v('p100_movi_impo_rete_rent');
brete.movi_fech_venc_timb_rete       :=v('p100_movi_fech_venc_timb_rete');
brete.movi_fech_rete                 :=v('p100_movi_fech_rete');

end pp_set_variable;

procedure pp_actualizar  is
 
begin
  
    pp_set_variable;

    if bcab.movi_sucu_codi_orig is null then
      raise_application_error(-20001, 'Debe indicar una sucursal');
    end if;

    if bsel.indi_regi_apli in ('A', 'E') then 
      
      pp_actualizar_registro_apli;
    else
       
       pp_actualizar_registro;
    end if;
apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');

--pp_iniciar;      
end pp_actualizar;

procedure pp_iniciar (p_empresa             in number,
                      p_movi_empr_codi      out varchar2,
                      p_movi_empr_desc      out varchar2,
                      p_movi_sucu_desc_orig out varchar2,
                      p_movi_sucu_codi_orig out varchar2,
                      p_codi_timo_fcor      out varchar2,
                      p_codi_timo_fcrr      out varchar2,
                      p_codi_timo_pcor       out varchar2) is
begin
 



     parameter.p_empr_codi:= p_empresa;
     p_movi_empr_codi:= parameter.p_empr_codi;


  begin
    select nvl(e.empr_retentora, 'NO'), e.empr_desc
      into parameter.p_empr_retentora, p_movi_empr_desc
      from come_empr e
     where e.empr_codi = parameter.p_empr_codi;
  exception
    when no_data_found then
      raise_application_error(-20001, 'Empresa seleccionada inexistente');
  end;


  pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini );
  
  if upper(nvl(parameter.p_indi_perm_fech_futu_dbcr, 'N')) = 'S' then
     parameter.p_fech_fini := add_months(to_date(parameter.p_fech_fini),12);
  end if;
  
    
  p_movi_sucu_codi_orig := parameter.p_sucu_codi;
  bcab.movi_sucu_codi_orig := p_movi_sucu_codi_orig;
  
  if bcab.movi_sucu_codi_orig is not null then
    begin
     -- Call the procedure
      I020337.pp_buscar_sucursal(p_empr_codi => p_movi_empr_codi,
                                 p_sucu_codi => p_movi_sucu_codi_orig,
                                 p_sucu_desc => p_movi_sucu_desc_orig);
    end;

    null;-- pl_muestra_come_sucu(bcab.movi_sucu_codi_orig, bcab.movi_sucu_desc_orig),
  end if;
  
    parameter.p_vali_deta := 'S';
 
 
 if nvl(parameter.p_para_inic,'DBCR') = 'MDBCR' then
    parameter.p_indi_modi := 'S';
  else
    parameter.p_indi_modi := 'N';
  end if;
  p_codi_timo_fcor := parameter.p_codi_timo_fcor;
  p_codi_timo_fcrr := parameter.p_codi_timo_fcrr;
  p_codi_timo_pcor := parameter.p_codi_timo_pcor;
  
 end pp_iniciar;


procedure pp_validar (p_indi_regi_apli in varchar2) is

begin 
if p_indi_regi_apli in ('A', 'E') then
	parameter.p_vali_cabe := 'N';
	parameter.p_vali_deta := 'N';
  else
  parameter.p_vali_cabe := 'S';
	parameter.p_vali_deta := 'S';
  
end if; 
--raise_application_error(-20001, parameter.p_vali_cabe);
end pp_validar;
procedure pp_buscar_sucursal (p_empr_codi in number,
                              p_sucu_codi in number,
                              p_sucu_desc out varchar2)is
    v_retencion varchar2(200);                          
 begin
   
 --raise_application_error (-20001,p_empr_codi||'---'||p_sucu_codi );
     select s.sucu_desc,s.sucu_porc_rete
       into p_sucu_desc, v_retencion
        from come_sucu s
       where s.sucu_codi = p_sucu_codi
         and s.sucu_empr_codi = p_empr_codi;
         
 if upper(nvl(parameter.p_indi_porc_rete_sucu, upper('n'))) = upper('s') then
   parameter.p_porc_aplic_reten := v_retencion;
 
 end if;
 
 end pp_buscar_sucursal;
 
 
 procedure pp_muestra_empl (p_empl_codi_alte in varchar2,
                            p_empl_codi      out number,
                            p_empl_desc      out varchar2) is

v_empl_esta varchar2(1);

begin                    
  select empl_codi, empl_desc, empl_esta
  into   p_empl_codi, p_empl_desc, v_empl_esta 
  from   come_empl
  where  empl_codi_alte = p_empl_codi_alte;
  
  if v_empl_esta <> 'A' then
    raise_application_error (-20001, 'El empleado se encuentra Inactivo');
  end if;
  
  
Exception
  when no_data_found then
     p_empl_codi := null;
     p_empl_desc := null;
     raise_application_error (-20001,'Empleado Inexistente!');

end pp_muestra_empl;


procedure pp_buscar_tipo_mov(i_indi_regi_apli                     in varchar2,
                             i_movi_timo_codi                     in number,
                             o_movi_timo_desc                     out varchar2, 
                             o_movi_emit_reci                     out varchar2,
                             o_s_timo_calc_iva                    out varchar2, 
                             o_movi_oper_codi                     out varchar2,
                             o_movi_dbcr                          out varchar2,
                             o_mt_ingr_cheq_dbcr_vari             out varchar2,
                             o_movi_timo_indi_sald                out varchar2, 
                             o_movi_timo_indi_caja                out varchar2,
                             o_movi_timo_indi_adel                out varchar2,  
                             o_movi_timo_indi_ncr                 out varchar2, 
                             o_tico_codi                          out varchar2,
                             o_timo_dbcr_caja                     out varchar2, 
                             o_timo_tica_codi                     out varchar2,  
                             o_tico_indi_vali_nume                out varchar2,
                             o_tico_indi_vali_timb                out varchar2, 
                             o_tico_indi_habi_timb                out varchar2,
                             o_tico_indi_timb_auto                out varchar2, 
                             o_tico_fech_rein                     out varchar2, 
                             o_tico_indi_timb                     out varchar2,
                             o_timo_indi_apli_adel_fopa           out varchar2,
                             o_s_calc_rete                        out varchar2,
                             o_s_calc_rete_mini                   out varchar2)is

begin
 -- raise_application_error(-20001, i_indi_regi_apli);
if nvl(i_indi_regi_apli, 'A') = 'R' then
  if i_movi_timo_codi is not null then
    if i_movi_timo_codi in (parameter.p_codi_timo_fcor, parameter.p_codi_timo_pcor) then
  I020337.pp_mostrar_tipo_movi ( i_movi_timo_codi,
                                 o_movi_timo_desc, 
                                 o_movi_emit_reci,
                                 o_s_timo_calc_iva, 
                                 o_movi_oper_codi,
                                 o_movi_dbcr,
                                 o_mt_ingr_cheq_dbcr_vari,
                                 o_movi_timo_indi_sald, 
                                 o_movi_timo_indi_caja,
                                 o_movi_timo_indi_adel,  
                                 o_movi_timo_indi_ncr, 
                                 o_tico_codi,
                                 o_timo_dbcr_caja, 
                                 o_timo_tica_codi,  
                                 o_tico_indi_vali_nume,
                                 o_tico_indi_vali_timb, 
                                 o_tico_indi_habi_timb,
                                 o_tico_indi_timb_auto, 
                                 o_tico_fech_rein, 
                                 o_tico_indi_timb,
                                 o_timo_indi_apli_adel_fopa,
                                 o_s_calc_rete,
                                 o_s_calc_rete_mini);
     
    general_skn.pl_vali_user_tipo_movi(i_movi_timo_codi, parameter.p_indi_vali_timo);
     
        -- raise_application_error (-20001,  parameter.p_indi_vali_timo);  
      if upper(rtrim(ltrim(parameter.p_indi_vali_timo))) = 'N' then
       raise_application_error (-20001,'El usuario no posee permiso para ingresar movimientos de este tipo.');
      end if;
    else
      raise_application_error (-20001,'Solo se permiten Facturas Recibidas Contado.');
    end if;
  else
    raise_application_error (-20001,'Debe ingresar el tipo de Movimiento.');
  end if;
end if;

end pp_buscar_tipo_mov;


procedure pp_mostrar_tipo_movi ( i_movi_timo_codi                     in number,
                                 o_movi_timo_desc                     out varchar2, 
                                 o_movi_emit_reci                     out varchar2,
                                 o_s_timo_calc_iva                    out varchar2, 
                                 o_movi_oper_codi                     out varchar2,
                                 o_movi_dbcr                          out varchar2,
                                 o_mt_ingr_cheq_dbcr_vari             out varchar2,
                                 o_movi_timo_indi_sald                out varchar2, 
                                 o_movi_timo_indi_caja                out varchar2,
                                 o_movi_timo_indi_adel                out varchar2,  
                                 o_movi_timo_indi_ncr                 out varchar2, 
                                 o_tico_codi                          out varchar2,
                                 o_timo_dbcr_caja                     out varchar2, 
                                 o_timo_tica_codi                     out varchar2,  
                                 o_tico_indi_vali_nume                out varchar2,
                                 o_tico_indi_vali_timb                out varchar2, 
                                 o_tico_indi_habi_timb                out varchar2,
                                 o_tico_indi_timb_auto                out varchar2, 
                                 o_tico_fech_rein                     out varchar2, 
                                 o_tico_indi_timb                     out varchar2,
                                 o_timo_indi_apli_adel_fopa           out varchar2,
                                 o_s_calc_rete                        out varchar2,
                                 o_s_calc_rete_mini                   out varchar2)is        
  v_timo_ingr_dbcr_vari char(1);
begin                         

select timo_desc,             /*timo_afec_sald,*/       timo_emit_reci,
       nvl(timo_calc_iva, 'S'), timo_codi_oper      ,timo_dbcr       ,
       timo_ingr_dbcr_vari   , timo_ingr_cheq_dbcr_vari            ,
       nvl(timo_indi_sald, 'N')   , nvl(timo_indi_caja,'N')    ,
       nvl(timo_indi_adel,'N')   ,  nvl(timo_indi_ncr,'N')   , timo_tico_codi,
       nvl(timo_dbcr_caja,'N'), timo_tica_codi,      tico_indi_vali_nume       ,
       tico_indi_vali_timb, tico_indi_habi_timb              ,
       tico_indi_timb_auto, tico_fech_rein, tico_indi_timb,
       timo_indi_apli_adel_fopa
into   o_movi_timo_desc, /*o_movi_afec_sald,*/ o_movi_emit_reci,
       o_s_timo_calc_iva  , o_movi_oper_codi,o_movi_dbcr ,
       v_timo_ingr_dbcr_vari , o_mt_ingr_cheq_dbcr_vari ,
       o_movi_timo_indi_sald  , o_movi_timo_indi_caja  ,
       o_movi_timo_indi_adel ,  o_movi_timo_indi_ncr , o_tico_codi,
       o_timo_dbcr_caja, o_timo_tica_codi,  o_tico_indi_vali_nume ,
       o_tico_indi_vali_timb, o_tico_indi_habi_timb  ,
       o_tico_indi_timb_auto, o_tico_fech_rein, o_tico_indi_timb,
       o_timo_indi_apli_adel_fopa
from come_tipo_movi, come_tipo_comp
where timo_tico_codi = tico_codi(+)
and timo_codi = i_movi_timo_codi;

-- necesario para FP.
parameter.p_emit_reci := o_movi_emit_reci;
--
if nvl(v_timo_ingr_dbcr_vari,'N') = 'N' then
    raise_application_error(-20001, 'No se permite ingresar documentos con este tipo de movimiento desde esta pantalla');
end if; 
 

if i_movi_timo_codi in (parameter.p_codi_timo_fcor, parameter.p_codi_timo_pcor) then
   -- set_item_property('bcab.s_calc_rete', visible, property_true);
    if o_s_timo_calc_iva = 'S' then
      o_s_calc_rete := 'S';
     -- set_item_property('bcab.s_calc_rete', enabled, property_false);
      if nvl(parameter.p_indi_most_chec_rete_mini,'N') = 'N' then
      null;--  set_item_property('bcab.S_CALC_RETE_MINI', visible, property_false);
      else
     null;--    set_item_property('bcab.S_CALC_RETE_MINI', visible, property_true);
      --  set_item_property('bcab.S_CALC_RETE_MINI', enabled, property_true);
      end if;
    else
      if upper(nvl(parameter.p_apli_rete_exen_defe, 'n')) = upper('n') then
        o_s_calc_rete := 'N';
      elsif upper(nvl(parameter.p_apli_rete_exen_defe, 'n')) = upper('s') then
        o_s_calc_rete := 'S';
      end if;
     null;-- set_item_property('bcab.s_calc_rete', enabled, property_true);
    end if;
    o_s_calc_rete_mini := 'N';
else
  o_s_calc_rete := 'N';
  o_S_CALC_RETE_MINI := 'N';
end if; 

Exception
   when no_data_found then
     raise_application_error(-20001, 'Tipo de Movimiento inexistente.');
    When too_many_rows then
     raise_application_error(-20001,'Tipo de Movimiento duplicado.') ;
End pp_mostrar_tipo_movi ;

procedure pp_validar_fecha (p_fecha in out  date) is
  
begin
  --if nvl(parameter.p_vali_cabe, 'N') = 'S' then
    if p_fecha is null then 
       p_fecha := to_char(sysdate, 'dd-mm-yyyy');
    end if;          

  --  pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
     
   if p_fecha not between parameter.p_fech_inic and parameter.p_fech_fini then
  	raise_application_error(-20001,'La fecha del movimiento debe estar comprendida entre..'||to_char(parameter.p_fech_inic) 
  	                 ||' y '||(parameter.p_fech_fini));
  end if;	
       
--end if;


end pp_validar_fecha; 


Procedure pp_muestra_clpr (p_clpr_codi_alte    in number,
                           p_clpr_desc         out varchar2,
                           p_clpr_codi         out varchar2,
                           p_clpr_tele         out varchar2,
                           p_clpr_dire         out varchar2,
                           p_clpr_ruc          out varchar2,
                           p_clpr_prov_retener out varchar2,
                           p_indi_prov_rela    out varchar2,
                           p_indi_vali_subc    out varchar2,
                           p_sucu_nume_item    out varchar2,
                           p_sucu_desc         out varchar2) is
                           
v_cant  number := 0;
v_count number := 0;
begin     
  --raise_application_error(-20001, parameter.p_vali_cabe||'-'||p_clpr_codi_alte);
--if nvl(parameter.p_vali_cabe, 'N') = 'S' then   
     select clpr_desc,
            clpr_codi,
            rtrim(ltrim(substr(clpr_tele,1,50))) Tele,
            rtrim(ltrim(substr(clpr_dire,1,100))) dire ,
            rtrim(ltrim(substr(clpr_ruc,1,20))) Ruc,
            nvl(clpr_prov_retener, 'NO')
       into p_clpr_desc,
            p_clpr_codi,
            p_clpr_tele,
            p_clpr_dire,
            p_clpr_ruc,
            p_clpr_prov_retener
       from come_clie_prov
      where clpr_codi_alte = p_clpr_codi_alte
        and clpr_indi_clie_prov = 'P';

    begin
      select count(*)
        into v_cant
        from rrhh_plan_suel ps, come_empl e
       where e.empl_plsu_codi = ps.plsu_codi
         and e.empl_clpr_codi = p_clpr_codi;
         
         if v_cant > 0 then
           p_indi_prov_rela := 'S';
         else
           p_indi_prov_rela := 'N';
         end if;
    end;
    
    
    
--- pp_validar_sub_cuenta IS
          
        BEGIN
            select count(*)
              into v_count
              from come_clpr_sub_cuen
             where sucu_clpr_codi =p_clpr_codi;
          if v_count > 0 then
            p_indi_vali_subc := 'S';
         else
            p_sucu_nume_item := null;
            p_sucu_desc := null;
            p_indi_vali_subc := 'N';
          end if;
        END;
   
    
  --end if;                                       
Exception
  when no_data_found then
     raise_application_error(-20001, 'Proveedor inexistente!');
 
end pp_muestra_clpr;


                           
 procedure pp_muestra_sub_cuenta(p_clpr_codi       in number, 
                                 p_sucu_nume_item  in number, 
                                 p_sucu_desc       out varchar2)is
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
    raise_application_error(-20001,'SubCuenta inexistente');
 
end pp_muestra_sub_cuenta;



procedure pp_validar_nro_comp (i_movi_fech_emis in date,
                               i_tico_fech_rein in date,
                               i_movi_nume      in varchar2,
                               i_clpr_indi_clie_prov in varchar2,
                               i_movi_clpr_codi      in varchar2,
                               i_tico_codi           in varchar2, 
                               i_s_nro_1             in varchar2,
                               i_s_nro_2             in varchar2, 
                               o_movi_nume_timb      in out varchar2,
                               o_fech_venc_timb      in out varchar2,
                               i_tico_indi_timb      in varchar2,
                               i_movi_timo_codi      in varchar2,
                               i_tico_indi_vali_timb in varchar2,
                               i_tico_indi_timb_auto in varchar2,
                               i_s_clpr_codi_alte    in varchar2,
                               i_tico_indi_habi_timb in varchar2) is
                             -- i_movi_nume_timb      in varchar2,
                            --  i_fech_venc_timb      in varchar2)is

begin
  

-- raise_application_error(-20001,i_movi_fech_emis||'-'||i_tico_fech_rein||'-'||i_movi_nume||'-'||i_clpr_indi_clie_prov);
-- raise_application_error(-20001,i_movi_clpr_codi||'-'||i_tico_codi||'-'||i_s_nro_1||'-'||i_s_nro_2);
 -- raise_application_error(-20001,o_movi_nume_timb||'-'||o_fech_venc_timb||'-'||i_tico_indi_timb||'-'||i_movi_timo_codi);
 --  raise_application_error(-20001,i_tico_indi_vali_timb||'-'||i_tico_indi_timb_auto||'-'||i_s_clpr_codi_alte||'-'||i_tico_indi_habi_timb);
   

   I020337.pp_validar_nro(i_movi_fech_emis,
                            i_tico_fech_rein,
                            i_movi_nume,
                            i_clpr_indi_clie_prov,
                            i_movi_clpr_codi,
                            i_tico_codi );

      if i_tico_codi is not null then 
          I020337.pp_validar_timbrado (i_tico_codi, 
                                       i_s_nro_1,
                                       i_s_nro_2, 
                                       i_movi_clpr_codi, 
                                       i_movi_fech_emis, 
                                       o_movi_nume_timb, 
                                       o_fech_venc_timb,
                                       i_tico_indi_timb,
                                       i_clpr_indi_clie_prov,
                                       i_s_clpr_codi_alte,
                                       i_tico_indi_habi_timb,
                                       i_tico_indi_timb_auto,
                                       i_tico_indi_vali_timb);   
           
                           
      end if;
 -- raise_application_error(-20001,o_movi_nume_timb||'-'||o_fech_venc_timb||'-'||i_tico_indi_timb||'-'||i_movi_timo_codi);

    if i_tico_codi is not null and i_movi_timo_codi in (5, 6, 7, 8,9, 3,4,64,75) then 
      if nvl(upper(i_tico_indi_vali_timb), 'N') = 'S'
      and nvl(upper(i_tico_indi_timb_auto), 'N') = 'S' then
         I020337.pp_devu_timb (i_tico_codi,
                              i_s_nro_1,
                              i_s_nro_2,
                              i_movi_clpr_codi,
                              i_movi_fech_emis,
                              i_tico_indi_timb);
      end if;
    end if;

end pp_validar_nro_comp;

procedure pp_validar_nro(  i_movi_fech_emis in date,
                           i_tico_fech_rein in date,
                           i_movi_nume      in number,
                           i_clpr_indi_clie_prov in varchar2,
                           i_movi_clpr_codi      in varchar2,
                           i_tico_codi           in number) is
v_count number;
v_message varchar2(1000) := 'Nro de Comprobante Existente!!!!! , favor verifique!!';
salir exception;
                          
begin   

 if i_movi_fech_emis < i_tico_fech_rein  then
  select count(*)
    into v_count
    from come_movi, come_tipo_movi, come_tipo_comp
   where  movi_timo_codi = timo_codi
     and timo_tico_codi = tico_codi(+)
     and movi_nume = i_movi_nume
     and ((i_clpr_indi_clie_prov = 'P' and movi_clpr_codi  = i_movi_clpr_codi) or nvl(i_clpr_indi_clie_prov, 'N') = 'C')
     and timo_tico_codi = i_tico_codi
     and nvl(tico_indi_vali_nume, 'N') = 'S'
     and movi_fech_emis < i_tico_fech_rein;
  
 elsif i_movi_fech_emis > i_tico_fech_rein then
    select count(*)
  into v_count
  from come_movi, come_tipo_movi, come_tipo_comp
  where  movi_timo_codi = timo_codi
  and timo_tico_codi = tico_codi(+)
  and movi_nume = i_movi_nume
  and ((i_clpr_indi_clie_prov = 'P' and movi_clpr_codi  = i_movi_clpr_codi) or nvl(i_clpr_indi_clie_prov, 'N') = 'C')
  and timo_tico_codi = i_tico_codi
  and nvl(tico_indi_vali_nume, 'N') = 'S'
  and movi_fech_emis >= i_tico_fech_rein;
  
 end if; 
  
 if v_count > 0 then  
    raise_application_error(-20001,v_message);
 end if;   
  
  
                      
Exception
  when others then
    raise_application_error(-20001,'Reingrese el nro de comprobante');   
end pp_validar_nro;


procedure pp_validar_timbrado(p_tico_codi      in number,
                              p_esta           in number,
                              p_punt_expe      in number,
                              p_clpr_codi      in number,
                              p_fech_movi      in date,
                              p_timb           in out varchar2,
                              p_fech_venc      in out date,
                              p_tico_indi_timb in varchar2,
                              p_clpr_indi_clie_prov in varchar2,
                              i_s_clpr_codi_alte    in number,
                              i_tico_indi_habi_timb in varchar2,
                              i_tico_indi_timb_auto in varchar2,
                              i_tico_indi_vali_timb in varchar2) is

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

  v_indi_espo varchar2(1) := upper('n');
begin
  if p_clpr_indi_clie_prov = upper('p') then
    if i_s_clpr_codi_alte = parameter.p_codi_prov_espo then
      v_indi_espo := upper('s');
    end if;
  else
    if i_s_clpr_codi_alte = parameter.p_codi_clie_espo then
      v_indi_espo := upper('s');
    end if;
  end if;

  if nvl(i_TICO_INDI_HABI_TIMB, 'N') = 'N' then
 null; /*  set_item_property('bcab.movi_nume_timb', enabled, property_false);
    set_item_property('bcab.s_fech_venc_timb', enabled, property_false);*/
    if nvl(v_indi_espo, 'N') = 'S' then
     null; /*  set_item_property('bcab.movi_nume_timb', enabled, property_true);
      set_item_property('bcab.s_fech_venc_timb', enabled, property_true);
    
      set_item_property('bcab.movi_nume_timb', navigable, property_true);
      set_item_property('bcab.s_fech_venc_timb', navigable, property_true);*/
    end if;
  
  else
   null; /*  set_item_property('bcab.movi_nume_timb', enabled, property_true);
    set_item_property('bcab.s_fech_venc_timb', enabled, property_true);
  
    set_item_property('bcab.movi_nume_timb', navigable, property_true);
    set_item_property('bcab.s_fech_venc_timb', navigable, property_true);*/
  
  end if;
  
  if nvl(i_tico_indi_timb_auto, 'N') = 'S' then
    if nvl(p_tico_indi_timb, 'C') = 'P' then
  
    	
      if p_clpr_indi_clie_prov = upper('p') and nvl(v_indi_espo, 'N') = 'N' then
     
        for x in c_timb loop
          v_indi_entro := upper('s');
          
          if p_timb is not null then
            p_timb      := p_timb;--i_movi_nume_timb;
            p_fech_venc := p_fech_venc;--i_fech_venc_timb;
          else
            p_timb      := x.cptc_nume_timb;
            p_fech_venc := x.cptc_fech_venc;
          end if;
          exit;
        end loop;
      else
        v_indi_entro := upper('s');
        
      end if;
    elsif nvl(p_tico_indi_timb,'C') = 'C' then
      ---si es por tipo de comprobante
      for y in c_timb_2 loop
        v_indi_entro := upper('s');
        if p_timb is not null then
          p_timb      := p_timb;---i_movi_nume_timb;
          p_fech_venc := p_fech_venc;--i_fech_venc_timb;
        else
          p_timb      := y.deta_nume_timb;
          p_fech_venc := y.deta_fech_venc;
        end if;
        exit;
      end loop;
    elsif nvl(p_tico_indi_timb,'C') = 'S' then
     for x in c_timb_3 loop
        v_indi_entro := upper('s');
        if p_timb is not null then
          p_timb      := p_timb;
          p_fech_venc := p_fech_venc;
        else
          p_timb      := x.setc_nume_timb;
          p_fech_venc := x.setc_fech_venc;
        end if;
        exit;
      end loop;  	
    end if;
	end if;  
  
    if v_indi_entro = upper('n') and  nvl(upper(i_tico_indi_vali_timb), 'N') = 'S' then
      raise_application_error(-20001,'No existe registro de timbrado cargado para este proveedor, o el timbrado cargado se encuentra vencido!!!');
    end if;
  
end pp_validar_timbrado;




procedure pp_devu_timb ( p_tico_codi in number, 
                         p_esta      in number,
                         p_punt_expe in number, 
                         p_clpr_codi in number, 
                         p_fech_movi in date,
                         p_tico_indi_timb in varchar2
                               ) is
 v_nume_timb  varchar2(20);
 v_fech_venc  date;

begin
    if nvl(p_tico_indi_timb,'C') <> 'S' then
      select cptc_nume_timb, cptc_fech_venc
        into v_nume_timb, v_fech_venc
        from come_clpr_tipo_comp
       where cptc_clpr_codi = p_clpr_codi --proveedor, cliente
         and cptc_tico_codi = p_tico_codi --tipo de comprobante
         and cptc_esta      = p_esta      --establecimiento 
         and cptc_punt_expe = p_punt_expe --punto de expedicion
         and cptc_fech_venc >= p_fech_movi
       order by cptc_fech_venc;
    else
      select setc_nume_timb, setc_fech_venc
        into v_nume_timb, v_fech_venc
        from come_secu_tipo_comp
       where setc_secu_codi = (select p.peco_secu_codi from come_pers_comp p where p.peco_codi = parameter.p_peco_codi)
         and setc_tico_codi = p_tico_codi --tipo de comprobante
         and setc_esta      = p_esta      --establecimiento 
         and setc_punt_expe = p_punt_expe --punto de expedicion
         and setc_fech_venc >= p_fech_movi
       order by setc_fech_venc;
    end if;

exception
  when no_data_found then
     raise_application_error(-20001,'El proveedor no tiene un timbrado vigente. Favor verificar.');
  when others then
     raise_application_error(-20001,'Error al recuperar timbrado.');
end pp_devu_timb;


procedure pp_buscar_moneda (i_movi_mone_codi            in out number,
                            i_movi_fech_emis            in date,
                            o_movi_mone_desc            out varchar2,
                            o_movi_mone_desc_abre       out varchar2,
                            o_movi_mone_cant_deci       out varchar2,
                            o_movi_tasa_mone            out varchar2,
                            i_timo_tica_codi            in varchar2) is 
  begin
    
 
  --  if nvl(parameter.p_vali_cabe, 'N') = 'S' then
  if i_movi_mone_codi is  null then
      i_movi_mone_codi := parameter.p_codi_mone_mmnn;
  end if;          
  general_skn.pl_muestra_come_mone (i_movi_mone_codi,
                                    o_movi_mone_desc ,  
                                    o_movi_mone_desc_abre, 
                                    o_movi_mone_cant_deci);
                        
  I020337.pp_busca_tasa_mone(i_movi_mone_codi, 
                             i_movi_fech_emis, 
                             o_movi_tasa_mone,
                             i_timo_tica_codi);    
  
  if i_movi_mone_codi = parameter.p_codi_mone_mmnn  then
  null;--  set_item_property('bcab.movi_tasa_mone', enabled, property_false);
    o_movi_tasa_mone := 1;
  else
    null;-- set_item_property('bcab.movi_tasa_mone', enabled, property_true);
    --set_item_property('bcab.movi_tasa_mone', navigable, property_true);   
  end if; 
--end if;


--o_movi_tasa_mone := round (to_number(o_movi_tasa_mone),o_movi_mone_cant_deci);
--raise_application_error(-20001,o_movi_tasa_mone ||'--'||o_movi_mone_cant_deci          );
end pp_buscar_moneda;




procedure pp_busca_tasa_mone (p_mone_codi in number,
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
     where coti_mone      = p_mone_codi
       and coti_fech      = p_coti_fech 
       and coti_tica_codi = p_tica_codi;
  end if;

exception
  when no_data_found then
    raise_application_error(-20001, 'Cotizacion Inexistente para la fecha del documento.');
 
end pp_busca_tasa_mone;

procedure pp_muestra_come_empl (p_empl_codi_alte    in number,
                                p_empl_desc         out varchar2) is

begin                    
  select  empl_desc
    into  p_empl_desc
    from come_empl
   where empl_codi = p_empl_codi_alte;  
  
exception
  when no_data_found then
      raise_application_error(-20001,'Empleado Inexistente!');

end pp_muestra_come_empl;


procedure pp_vali_fech_apli  (i_indi_regi_apli in  varchar2,
                                 i_movi_fech_apli in out varchar2) is 
 
begin
if i_indi_regi_apli = 'A' then

  if i_movi_fech_apli is null then
    i_movi_fech_apli := trunc(sysdate);
  end if;
    
    if i_movi_fech_apli not between parameter.p_fech_inic and parameter.p_fech_fini then
  	  raise_application_error(-20001,'La fecha de aplicaci?n debe estar comprendida entre..'||(parameter.p_fech_inic) 
  	                 ||' y '||(parameter.p_fech_fini));
    end if;	
end if;

end pp_vali_fech_apli;

procedure pp_buscar_concepto (i_moco_conc_codi               in number, 
                              o_moco_conc_desc               out varchar2,
                              o_moco_dbcr                    out varchar2,
                              o_conc_indi_kilo_vehi          out varchar2, 
                              o_conc_indi_impo               out varchar2,
                              o_conc_indi_ortr               out varchar2,
                              o_conc_indi_gast_judi          out varchar2, 
                              o_conc_indi_cent_cost          out varchar2, 
                              o_conc_indi_acti_fijo          out varchar2, 
                              o_cuco_nume                    out varchar2, 
                              o_cuco_Desc                    out varchar2,
                              i_movi_sucu_codi_orig          in varchar2,
                              i_movi_dbcr                    in varchar2) is
  
begin
  --if nvl(parameter.p_vali_deta, 'N') = 'S' then
  if  i_moco_conc_codi is not null then             
    
   I020337.pp_muestra_come_conc (i_moco_conc_codi, 
                                o_moco_conc_desc, 
                                o_moco_dbcr, 
                                o_conc_indi_kilo_vehi, 
                                o_conc_indi_impo,
                                o_conc_indi_ortr,
                                o_conc_indi_gast_judi, 
                                o_conc_indi_cent_cost, 
                                o_conc_indi_acti_fijo, 
                                o_cuco_nume, 
                                o_cuco_Desc,
                                i_movi_sucu_codi_orig,
                                i_movi_dbcr ); 
                            
    I020337.pp_valida_conc_iva(i_moco_conc_codi);   
 --   pp_hab_desh_campos_Deta;
               
  -- permiso de usuario -- concepto
    pp_validar_user_conc(i_moco_conc_codi);
  
 /* if length(i_moco_conc_codi) >= 8 then
      pp_muestra_come_conc_cuco(:bdet.moco_conc_codi,
                                :bdet.moco_conc_codi,
                                :bdet.moco_conc_desc,
                                :bdet.moco_dbcr,
                                :bdet.conc_indi_kilo_vehi);
    end if;*/
  else                                     
    raise_application_error(-20001,'Debe ingresar el codigo del conceptoeeee.');
  end if;
--end if;

end pp_buscar_concepto;


procedure pp_muestra_come_conc (p_conc_codi           in number, 
                                p_conc_desc           out varchar2, 
                                p_conc_dbcr           out varchar2, 
                                p_conc_indi_kilo_vehi out varchar2, 
                                p_moco_indi_impo      out varchar2,
                                p_conc_indi_ortr      out varchar2,
                                p_conc_indi_gast_judi out varchar2, 
                                p_conc_indi_cent_cost out varchar2, 
                                p_conc_indi_acti_fijo out varchar2, 
                                p_cuco_nume           out varchar2, 
                                p_cuco_desc           out varchar2,
                                i_movi_sucu_codi_orig in varchar2,
                                i_movi_dbcr           in varchar2
                                ) is
  v_dbcr_desc char(7);
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
      raise_application_error(-20001,'El concepto seleccionado no pertenece a la sucursal!');
    end if;
  end if;
                                     
  if rtrim(ltrim(p_conc_dbcr)) <> rtrim(ltrim(i_movi_dbcr)) then
     if i_movi_dbcr = 'D' then
       v_dbcr_desc := 'Debito';
     else
       v_dbcr_desc := 'Credito';
     end if;   
     raise_application_error(-20001,'Debe ingresar un Concepto de tipo '||rtrim(ltrim(v_dbcr_desc)));
  end if;  
  
  
  if v_conc_indi_inac = 'S' then
    raise_application_error(-20001,'El concepto se encuentra inactivo');    
  end if; 
  

Exception
  when no_data_found then
    raise_application_error(-20001,'Concepto Inexistente!');

end pp_muestra_come_conc;



procedure pp_valida_conc_iva (p_conc_codi in number) is
--validar que no se seleccione un concepto de Tipo Iva..
                                 
Cursor c_conc_iva is
select impu_conc_codi_ivdb, impu_conc_codi_ivcr
from come_impu
order by 1;

begin
  
  for x in c_conc_iva loop
  	if x.impu_conc_codi_ivcr = p_conc_codi or x.impu_conc_codi_ivdb = p_conc_codi then
  		  raise_application_error(-20001,'No puede seleccionar un concepto de Tipo Iva');
  	end if;	  
  end loop;	
  
end pp_valida_conc_iva;    


procedure pp_validar_user_conc(p_conc_codi in number) is
	v_count number;
begin
  select count(*)
    into v_count
		from segu_user_conc,segu_user
	 where usco_user_codi = user_codi
	   and user_login = gen_user
	   and usco_conc_codi = p_conc_codi;
	if v_count > 0 then
		 raise_application_error(-20001, 'Concepto bloqueado. Favor verifique.');
	end if;
end pp_validar_user_conc;  
  
/*

procedure pp_muestra_come_conc_cuco (p_cuco_nume in number,
                                     p_conc_codi out number,
                                     p_conc_desc out char,
                                     p_conc_dbcr out char,
                                     p_conc_indi_kilo_vehi out varchar2) is
  v_dbcr_desc           char(7);
  v_conc_indi_ortr      varchar2(1);
  
  v_cant      number;
  v_cuco_codi number;
  
  v_conc_sucu_codi number;
begin
  select count(*)
    into v_cant
    from come_cuen_cont c
   where c.cuco_nume = p_cuco_nume;
  
  if v_cant = 1 then
    select c.cuco_codi
      into v_cuco_codi
      from come_cuen_cont c
     where c.cuco_nume = p_cuco_nume;
    
  elsif v_cant = 0 then
    select count(*)
      into v_cant
      from come_cuen_cont c
     where ltrim(rtrim(to_char(c.cuco_nume))) like ltrim(rtrim(to_char(p_cuco_nume)))||'%';
    
    if v_cant = 1 then
      select c.cuco_codi
        into v_cuco_codi
        from come_cuen_cont c
       where ltrim(rtrim(to_char(c.cuco_nume))) like ltrim(rtrim(to_char(p_cuco_nume)))||'%';
      
    elsif v_cant = 0 then
       raise_application_error(-20001,'No existen cuentas contables con este numero');
    else
     
      :bpie_cuco.buscador := p_cuco_nume;
      pp_buscar_cuco(:bpie_cuco.buscador, 'N');
    end if;
  else
   
    :bpie_cuco.buscador := p_cuco_nume;
    pp_buscar_cuco(:bpie_cuco.buscador, 'N');
  end if;
  
  :parameter.p_cuco_conc_codi := null;
  :parameter.p_cuco_conc_desc := null;
  
  if v_cuco_codi is not null then
    select count(*)
      into v_cant
      from come_conc c
     where c.conc_cuco_codi = v_cuco_codi;
    
    if v_cant = 0 then
       raise_application_error(-20001,'No existe ningun concepto relacionado a la cuenta');
    elsif v_cant = 1 then
      select c.conc_codi, c.conc_desc
        into p_conc_codi, p_conc_desc
        from come_conc c
       where c.conc_cuco_codi = v_cuco_codi;
      
      select conc_desc, rtrim(ltrim(conc_dbcr)), conc_indi_ortr,
             conc_indi_kilo_vehi, conc_sucu_codi
        into p_conc_desc, p_conc_dbcr, v_conc_indi_ortr,
             p_conc_indi_kilo_vehi, v_conc_sucu_codi
        from come_conc
       where conc_codi = p_conc_codi;
      
      if v_conc_sucu_codi is not null then
        if v_conc_sucu_codi <> :bcab.movi_sucu_codi_orig then
           raise_application_error(-20001,'El concepto seleccionado no pertenece a la sucursal!');
        end if;
      end if;
      
      if rtrim(ltrim(p_conc_dbcr)) <> rtrim(ltrim(:bcab.movi_dbcr)) then
        if i_movi_dbcr = 'D' then
          v_dbcr_desc := 'Debito';
        else
          v_dbcr_desc := 'Credito';
        end if;
         raise_application_error(-20001,'Debe ingresar un Concepto de tipo '||rtrim(ltrim(v_dbcr_desc)));
      end if;
      
      if nvl(v_conc_indi_ortr, 'N') = 'S' then
         raise_application_error(-20001,'No se puede utilizar este concepto porque debe estar relacionada a una OT');
      end if;
      
      begin
        select cc.cuco_nume, cc.cuco_desc
          into o_cuco_nume,o_cuco_desc
          from come_conc c, come_cuen_cont cc
         where c.conc_cuco_codi = cc.cuco_codi(+)
           and c.conc_codi = p_conc_codi;
      exception
        when no_data_found then
          o_cuco_nume := null;
          o_cuco_desc := null;
        when too_many_rows then
          o_cuco_nume := null;
          o_cuco_desc := null;
        
        when others then
         raise_application_error(-20001, 'Error');
      end;
      
      --do_key('next_item');
    else
      parameter.p_vali_deta := 'S';
      parameter.p_cuco_codi := v_cuco_codi;
      parameter.p_vali_deta := 'N';
    end if;
  end if;
  
exception
  when no_data_found then

     raise_application_error(-20001,'Concepto Inexistente!');
  
end pp_muestra_come_conc_cuco;*/



procedure pp_mostrar_impu(i_moco_impu_codi                in out number,
                          o_moco_impu_desc                out varchar2,
                          o_moco_impu_porc                out varchar2,
                          o_moco_impu_porc_base_impo      out varchar2,
                          o_mi_indi_baim_impu_incl        out varchar2,
                          o_moco_conc_codi_impu           out varchar2,
                          i_s_timo_calc_iva               in varchar2,
                          i_movi_dbcr                     in varchar2) is
begin

  --si el tipo de movimiento tiene el indicador de calculo de iva 'n'
  --entonces siempre ser? exento....
  if i_s_timo_calc_iva = 'N' then
    i_moco_impu_codi := parameter.p_codi_impu_exen;
  end if;

  select impu_desc,
         impu_porc,
         impu_porc_base_impo,
         nvl(impu_indi_baim_impu_incl,'S'), 
         decode(i_movi_dbcr, 'C', impu_conc_codi_ivcr, impu_conc_codi_ivdb)
    into o_moco_impu_desc,
         o_moco_impu_porc,
         o_moco_impu_porc_base_impo,
         o_mi_indi_baim_impu_incl, 
         o_moco_conc_codi_impu
    from come_impu
   where impu_codi = i_moco_impu_codi;

exception
  when no_data_found then
    raise_application_error(-20001,'Tipo de Impuesto inexistente');
  when too_many_rows then
   raise_application_error(-20001,'Tipo de Impuesto duplicado');
  when others then
   raise_application_error(-20001,'When others...');
end pp_mostrar_impu;


procedure pp_mostrar_tipo_impuesto (i_moco_tiim_codi in number, 
                                    o_tiim_desc out varchar2) is
begin
  

  select tiim_desc
  into o_tiim_desc
  from come_tipo_impu
  where tiim_codi = i_moco_tiim_codi;
  
Exception
	  When no_data_found then
	     raise_application_error(-20001,'Tipo de impuesto inexistente');

end pp_mostrar_tipo_impuesto;



                                    
 procedure pp_calcular_importe_cab (i_s_grav_10_ii     in number,
                                    i_s_grav_5_ii      in number,
                                    i_s_exen           in number,
                                    i_movi_tasa_mone   in number,
                                    i_movi_timo_indi_sald in varchar2,
                                    i_movi_mone_cant_deci in number,
                                    o_movi_grav10_ii_mone out number,
                                    o_movi_grav5_ii_mone  out number,
                                    o_movi_exen_mone      out number,
                                    o_movi_impo_mone_ii   out number,
                                    o_s_total             out number,
                                    o_movi_grav10_ii_mmnn out number,
                                    o_movi_grav5_ii_mmnn  out number,
                                    o_movi_exen_mmnn      out number,
                                    o_movi_iva10_mone     out number,
                                    o_movi_iva5_mone      out number,
                                    o_s_iva_10            out number,
                                    o_s_iva_5             out number,
                                    o_s_tot_iva           out number,
                                    o_movi_iva10_mmnn     out number,
                                    o_movi_iva5_mmnn      out number,
                                    o_movi_grav10_mone    out number,
                                    o_movi_grav5_mone     out number,
                                    o_movi_grav10_mmnn     out number,
                                    o_movi_grav5_mmnn      out number,
                                    o_movi_impo_mmnn_ii    out number,
                                    o_movi_grav_mone       out number,
                                    o_movi_iva_mone        out number,
                                    o_movi_grav_mmnn       out number,
                                    o_movi_iva_mmnn        out number,
                                    o_movi_sald_mone       out number,
                                    o_movi_sald_mmnn       out number) is

Begin
  
  o_movi_grav10_ii_mone := i_s_grav_10_ii;
  o_movi_grav5_ii_mone  := i_s_grav_5_ii;
  o_movi_exen_mone	    := i_s_exen;
  
  o_movi_impo_mone_ii := o_movi_grav10_ii_mone + o_movi_grav5_ii_mone + o_movi_exen_mone;
  o_s_total           := o_movi_impo_mone_ii;
  
  ---importe iva incluido en mmnn
  o_movi_grav10_ii_mmnn := round((o_movi_grav10_ii_mone*i_movi_tasa_mone), parameter.p_cant_deci_mmnn);
  o_movi_grav5_ii_mmnn  := round((o_movi_grav5_ii_mone*i_movi_tasa_mone), parameter.p_cant_deci_mmnn);
  o_movi_exen_mmnn	    := round((o_movi_exen_mone*i_movi_tasa_mone), parameter.p_cant_deci_mmnn);
  
  o_movi_iva10_mone     := round((o_movi_grav10_ii_mone/11), i_movi_mone_cant_deci);
  o_movi_iva5_mone      := round((o_movi_grav5_ii_mone/21), i_movi_mone_cant_deci);
  
  o_s_iva_10             := o_movi_iva10_mone;
  o_s_iva_5	             := o_movi_iva5_mone;
  o_s_tot_iva            := o_movi_iva10_mone + o_movi_iva5_mone;
  
  o_movi_iva10_mmnn     := round((o_movi_grav10_ii_mmnn/11), parameter.p_cant_deci_mmnn);
  o_movi_iva5_mmnn      := round((o_movi_grav5_ii_mmnn/21), parameter.p_cant_deci_mmnn);
  
  o_movi_grav10_mone     := round((o_movi_grav10_ii_mone/1.1), i_movi_mone_cant_deci);
  o_movi_grav5_mone      := round((o_movi_grav5_ii_mone/1.05), i_movi_mone_cant_deci);
  
  o_movi_grav10_mmnn     := round((o_movi_grav10_ii_mmnn/1.1), parameter.p_cant_deci_mmnn);
  o_movi_grav5_mmnn      := round((o_movi_grav5_ii_mmnn/1.05), parameter.p_cant_deci_mmnn);
  
  o_movi_impo_mmnn_ii    := o_movi_grav10_ii_mmnn+ o_movi_grav5_ii_mmnn + o_movi_exen_mmnn;
         
  --importes netos
  
  o_movi_grav_mone     := o_movi_grav10_mone + o_movi_grav5_mone;     
  o_movi_iva_mone      := o_movi_iva10_mone + o_movi_iva5_mone;
  
  o_movi_grav_mmnn     := o_movi_grav10_mmnn + o_movi_grav5_mmnn;     
  o_movi_iva_mmnn      := o_movi_iva10_mmnn + o_movi_iva5_mmnn;
 
  --saldo 
  if nvl(i_movi_timo_indi_sald, 'N') = 'N' then -- si no afecta el saldo del cliente o proveedor
    o_movi_sald_mone      := 0;
    o_movi_sald_mmnn      := 0;  
  else
    o_movi_sald_mone  := o_movi_impo_mone_ii;
    o_movi_sald_mmnn  := o_movi_impo_mmnn_ii;
  end if;
 
end pp_calcular_importe_cab;  


procedure pp_calcular_importe_item(i_moco_impo_mone_ii                 in number,
                                    i_movi_mone_cant_deci              in number,
                                    i_moco_impu_porc                   in number,
                                    i_moco_impu_porc_base_impo         in number,
                                    i_mi_indi_baim_impu_incl           in varchar2, 
                                    i_movi_tasa_mone                   in number,   
                                    o_moco_impo_mone_ii                out number,
                                    o_moco_grav10_ii_mone              out number,
                                    o_moco_grav5_ii_mone               out number,
                                    o_moco_grav10_mone                 out number,
                                    o_moco_grav5_mone                  out number,
                                    o_moco_iva10_mone                  out number,
                                    o_moco_iva5_mone                   out number,
                                    o_moco_Exen_mone                   out number,
                                    o_moco_impo_mmnn_ii                out number,
                                    o_moco_grav10_ii_mmnn              out number,
                                    o_moco_grav5_ii_mmnn               out number,
                                    o_moco_grav10_mmnn                 out number,
                                    o_moco_grav5_mmnn                  out number,
                                    o_moco_iva10_mmnn                  out number,
                                    o_moco_iva5_mmnn                   out number,
                                    o_moco_exen_mmnn                   out number,
                                    o_moco_impo_mmnn                   out number,
                                    o_moco_impo_mone                   out number) is 


begin       
                                               
 --if nvl(:parameter.p_vali_deta, 'N') = 'S' then
  o_moco_impo_mmnn_ii := round((i_moco_impo_mone_ii*i_movi_tasa_mone), parameter.p_cant_Deci_mmnn);  
        
  pa_devu_impo_calc(i_moco_impo_mone_ii,
  i_movi_mone_cant_deci,
  i_moco_impu_porc,
  i_moco_impu_porc_base_impo,
  i_mi_indi_baim_impu_incl,----------
  o_moco_impo_mone_ii,
  o_moco_grav10_ii_mone,
  o_moco_grav5_ii_mone,
  o_moco_grav10_mone,
  o_moco_grav5_mone,
  o_moco_iva10_mone,
  o_moco_iva5_mone,
  o_moco_Exen_mone);
  
  pa_devu_impo_calc(o_moco_impo_mmnn_ii,
  parameter.p_cant_deci_mmnn,
  i_moco_impu_porc,
  i_moco_impu_porc_base_impo,
  i_mi_indi_baim_impu_incl,----------
  o_moco_impo_mmnn_ii,
  o_moco_grav10_ii_mmnn,
  o_moco_grav5_ii_mmnn,
  o_moco_grav10_mmnn,
  o_moco_grav5_mmnn,
  o_moco_iva10_mmnn,
  o_moco_iva5_mmnn,
  o_moco_exen_mmnn);
    
  o_moco_impo_mmnn := o_moco_exen_mmnn + o_moco_grav10_mmnn + o_moco_grav5_mmnn;
  o_moco_impo_mone := o_moco_exen_mone + o_moco_grav10_mone + o_moco_grav5_mone;
  
 --end if;

end pp_calcular_importe_item;                                
                                 

procedure pp_cargar_documento(p_movi_codi           in number,
                              p_indi_regi_apli      in varchar2) is
 v_saldo_apli number;
 begin
    
  	 pp_cargar_fact(p_movi_codi);

	
  I020337.pp_cargar_liqu(p_indi_regi_apli     => p_indi_regi_apli,
                         p_movi_clpr_codi     => V('p100_movi_clpr_codi'),
                         p_s_indi_prov_rela   => V('p100_s_indi_prov_rela'),
                         p_movi_codi          => p_movi_codi);



 
 	v_saldo_apli  := fa_devu_sald_fact_apli('F', p_movi_codi, null, null) - nvl(V('p100_s_impo_rete'), 0);
 setitem('p100_sald_apli_fact', v_saldo_apli);
end pp_cargar_documento;  



procedure pp_cargar_fact (p_movi_codi in number)is

cursor c_movi is
   select m.movi_codi,
          m.movi_timo_codi,
          m.movi_fech_emis,
          m.movi_fech_oper,
          cp.clpr_codi_alte,
          m.movi_nume,
          m.movi_nume_timb,
          m.movi_fech_venc_timb,
          m.movi_mone_codi,
          m.movi_tasa_mone,
          m.movi_empl_codi,
          m.movi_obse
    from come_movi m, come_clie_prov cp
   where m.movi_clpr_codi = cp.clpr_codi
     and m.movi_codi = p_movi_codi;


v_movi_timo_desc              varchar2(60);
v_movi_emit_reci              varchar2(60);
v_s_timo_calc_iva             varchar2(60);
v_movi_oper_codi              varchar2(60);
v_movi_dbcr                   varchar2(60);
v_mt_ingr_cheq_dbcr_vari      varchar2(60);
v_movi_timo_indi_sald         varchar2(60);
v_movi_timo_indi_caja         varchar2(60);
v_movi_timo_indi_adel         varchar2(60);
v_movi_timo_indi_ncr          varchar2(60);
v_tico_codi                   varchar2(60);
v_timo_dbcr_caja              varchar2(60);
v_timo_tica_codi              varchar2(60);
v_tico_indi_vali_nume         varchar2(60);
v_tico_indi_vali_timb         varchar2(60);
v_tico_indi_habi_timb         varchar2(60);
v_tico_indi_timb_auto         varchar2(60);
v_tico_fech_rein              varchar2(60);
v_tico_indi_timb              varchar2(60);
v_timo_indi_apli_adel_fopa    varchar2(60);
v_s_calc_rete                 varchar2(60);
v_s_calc_rete_mini            varchar2(60);

v_movi_clpr_desc          varchar2(60);
v_movi_clpr_codi          varchar2(60);
v_movi_clpr_tele          varchar2(60);
v_movi_clpr_dire          varchar2(60);
v_movi_clpr_ruc           varchar2(60);
v_clpr_prov_retener       varchar2(60);
v_s_indi_prov_rela        varchar2(60);
v_s_indi_vali_subc        varchar2(60);
v_sucu_nume_item          varchar2(60);
v_sucu_desc               varchar2(60);

v_movi_mone_desc           varchar2(60);
v_movi_mone_desc_abre      varchar2(60);
v_movi_mone_cant_deci      varchar2(60);
v_movi_tasa_mone           varchar2(60);
v_mone_codi                varchar2(60);
v_empl_desc                varchar2(60);


V_MOCO_CONC_DESC           varchar2(60);
V_MOCO_DBCR                varchar2(60);
V_CONC_INDI_KILO_VEHI      varchar2(60);
V_CONC_INDI_IMPO           varchar2(60);
V_CONC_INDI_ORTR           varchar2(60);
V_CONC_INDI_GAST_JUDI      varchar2(60);
V_CONC_INDI_CENT_COST      varchar2(60);
V_CONC_INDI_ACTI_FIJO      varchar2(60);
V_CUCO_NUME                varchar2(60);
V_CUCO_DESC                varchar2(60);

v_moco_impu_desc                varchar2(60);
v_moco_impu_porc                varchar2(60);
v_moco_impu_porc_base_impo      varchar2(60);
v_mi_indi_baim_impu_incl        varchar2(60);
v_moco_conc_codi_impu           varchar2(60);
V_tiim_desc                     varchar2(60);
v_moco_impu_codi                varchar2(60);

v_movi_grav10_ii_mone     varchar2(60);
v_movi_grav5_ii_mone      varchar2(60);
v_movi_exen_mone          varchar2(60);
v_movi_impo_mone_ii       varchar2(60);
v_s_total                 varchar2(60);
v_movi_grav10_ii_mmnn     varchar2(60);
v_movi_grav5_ii_mmnn      varchar2(60);
v_movi_exen_mmnn          varchar2(60);
v_movi_iva10_mone         varchar2(60);
v_movi_iva5_mone          varchar2(60);
v_s_iva_10                varchar2(60);
v_s_iva_5                 varchar2(60);
v_s_tot_iva               varchar2(60);
v_movi_iva10_mmnn         varchar2(60);
v_movi_iva5_mmnn          varchar2(60);
v_movi_grav10_mone        varchar2(60);
v_movi_grav5_mone         varchar2(60);
v_movi_grav10_mmnn        varchar2(60);
v_movi_grav5_mmnn         varchar2(60);
v_movi_impo_mmnn_ii       varchar2(60);
v_movi_grav_mone          varchar2(60);
v_movi_iva_mone           varchar2(60);
v_movi_grav_mmnn          varchar2(60);
v_movi_iva_mmnn           varchar2(60);
v_movi_sald_mone          varchar2(60);
v_movi_sald_mmnn          varchar2(60);

v_moco_impo_mone_ii       varchar2(60);
v_moco_grav10_ii_mone     varchar2(60);
v_moco_grav5_ii_mone      varchar2(60);
v_moco_grav10_mone        varchar2(60);
v_moco_grav5_mone         varchar2(60);
v_moco_iva10_mone         varchar2(60);
v_moco_iva5_mone          varchar2(60);
v_moco_Exen_mone          varchar2(60);
v_moco_impo_mmnn_ii       varchar2(60);
v_moco_grav10_ii_mmnn     varchar2(60);
v_moco_grav5_ii_mmnn      varchar2(60);
v_moco_grav10_mmnn        varchar2(60);
v_moco_grav5_mmnn         varchar2(60);
v_moco_iva10_mmnn         varchar2(60);
v_moco_iva5_mmnn          varchar2(60);
v_moco_exen_mmnn          varchar2(60);
v_moco_impo_mmnn          varchar2(60);
v_moco_impo_mone          varchar2(60);


v_sum_moco_impo_mone_ii         varchar2(60);
v_sum_moco_exen_mone            varchar2(60);
v_sum_moco_grav5_ii_mone        varchar2(60);
v_sum_moco_grav10_ii_mone       varchar2(60);
begin

    
  for x in c_movi loop
     setitem('P100_movi_codi', x.movi_codi);
     setitem('P100_movi_timo_codi', x.movi_timo_codi);
     setitem('P100_movi_fech_emis', x.movi_fech_emis);
     setitem('P100_movi_fech_oper', x.movi_fech_oper);
     setitem('P100_s_clpr_codi_alte', x.clpr_codi_alte);
     setitem('P100_movi_nume', x.movi_nume);
     setitem('P100_movi_nume_timb', x.movi_nume_timb);
     setitem('P100_fech_venc_timb', x.movi_fech_venc_timb);
     setitem('P100_movi_mone_codi', x.movi_mone_codi);
     setitem('P100_movi_tasa_mone', x.movi_tasa_mone);
     setitem('P100_movi_empl_codi', x.movi_empl_codi);
  end loop;
  
  
  pp_cargar_importes(p_movi_codi);
  
  pp_cargar_detalle(p_movi_codi);


 --------------------------------
  if V('P100_movi_timo_codi') is not null then
    
  begin
  -- Call the procedure
  I020337.pp_mostrar_tipo_movi(i_movi_timo_codi            => V('P100_movi_timo_codi'),
                               o_movi_timo_desc           => v_movi_timo_desc,
                               o_movi_emit_reci           => v_movi_emit_reci,
                               o_s_timo_calc_iva          => v_s_timo_calc_iva,
                               o_movi_oper_codi           => v_movi_oper_codi,
                               o_movi_dbcr                => v_movi_dbcr,
                               o_mt_ingr_cheq_dbcr_vari   => v_mt_ingr_cheq_dbcr_vari,
                               o_movi_timo_indi_sald      => v_movi_timo_indi_sald,
                               o_movi_timo_indi_caja      => v_movi_timo_indi_caja,
                               o_movi_timo_indi_adel      => v_movi_timo_indi_adel,
                               o_movi_timo_indi_ncr       => v_movi_timo_indi_ncr,
                               o_tico_codi                => v_tico_codi,
                               o_timo_dbcr_caja           => v_timo_dbcr_caja,
                               o_timo_tica_codi           => v_timo_tica_codi,
                               o_tico_indi_vali_nume      => v_tico_indi_vali_nume,
                               o_tico_indi_vali_timb      => v_tico_indi_vali_timb,
                               o_tico_indi_habi_timb      => v_tico_indi_habi_timb,
                               o_tico_indi_timb_auto      => v_tico_indi_timb_auto,
                               o_tico_fech_rein           => v_tico_fech_rein,
                               o_tico_indi_timb           => v_tico_indi_timb,
                               o_timo_indi_apli_adel_fopa => v_timo_indi_apli_adel_fopa,
                               o_s_calc_rete              => v_s_calc_rete,
                               o_s_calc_rete_mini         => v_s_calc_rete_mini);
   end;                            
    setitem('P100_movi_timo_desc', v_movi_timo_desc);
    setitem('P100_movi_emit_reci', v_movi_emit_reci);
    setitem('P100_s_timo_calc_iva', v_s_timo_calc_iva);
    setitem('P100_movi_oper_codi', v_movi_oper_codi);
    setitem('P100_movi_dbcr', v_movi_dbcr);
    setitem('P100_mt_ingr_cheq_dbcr_vari', v_mt_ingr_cheq_dbcr_vari);
    setitem('P100_movi_timo_indi_sald', v_movi_timo_indi_sald);
    setitem('P100_movi_timo_indi_caja', v_movi_timo_indi_caja);
    setitem('P100_movi_timo_indi_adel', v_movi_timo_indi_adel);
    setitem('P100_movi_timo_indi_ncr', v_movi_timo_indi_ncr);
    setitem('P100_tico_codi', v_tico_codi);
    setitem('P100_timo_dbcr_caja', v_timo_dbcr_caja);
    setitem('P100_timo_tica_codi', v_timo_tica_codi);
    setitem('P100_tico_indi_vali_nume', v_tico_indi_vali_nume);
    setitem('P100_tico_indi_vali_timb', v_tico_indi_vali_timb);
    setitem('P100_tico_indi_habi_timb', v_tico_indi_habi_timb);
    setitem('P100_tico_indi_timb_auto', v_tico_indi_timb_auto);
    setitem('P100_tico_fech_rein', v_tico_fech_rein);
    setitem('P100_tico_indi_timb', v_tico_indi_timb);
    setitem('P100_timo_indi_apli_adel_fopa', v_timo_indi_apli_adel_fopa);
    setitem('P100_s_calc_rete', v_s_calc_rete);
    setitem('P100_s_calc_rete_mini', v_s_calc_rete_mini);                              
                               

    general_skn.pl_vali_user_tipo_movi(v('P100_movi_timo_codi'), parameter.p_indi_vali_timo);

  end if;

  if v('P100_s_clpr_codi_alte') is not null then
        begin

         I020337.pp_muestra_clpr(v('P100_s_clpr_codi_alte'),
                                  v_movi_clpr_desc,
                                  v_movi_clpr_codi,
                                  v_movi_clpr_tele,
                                  v_movi_clpr_dire,
                                  v_movi_clpr_ruc,
                                  v_clpr_prov_retener,
                                  v_s_indi_prov_rela,
                                  v_s_indi_vali_subc,
                                  v_sucu_nume_item,
                                  v_sucu_desc
                                 );  
        end;
  
  
  setitem('P100_movi_clpr_desc',v_movi_clpr_desc);
  setitem('P100_movi_clpr_codi',v_movi_clpr_codi);
  setitem('P100_movi_clpr_tele',v_movi_clpr_tele);
  setitem('P100_movi_clpr_dire',v_movi_clpr_dire);
  setitem('P100_movi_clpr_ruc',v_movi_clpr_ruc);
  setitem('P100_clpr_prov_retener',v_clpr_prov_retener);
  setitem('P100_s_indi_prov_rela',v_s_indi_prov_rela);
  setitem('p100_s_indi_vali_subc',v_s_indi_vali_subc);
  setitem('P100_sucu_nume_item',v_sucu_nume_item);
  setitem('P100_sucu_desc',v_sucu_desc);

  end if;
  -----                 
  if V('P100_movi_mone_codi') is not null then
    
  begin
   v_mone_codi:= V('p100_movi_mone_codi');
  I020337.pp_buscar_moneda(i_movi_mone_codi      => v_mone_codi,
                           i_movi_fech_emis      => V('p100_movi_fech_emis'),
                           o_movi_mone_desc      => v_movi_mone_desc,
                           o_movi_mone_desc_abre => v_movi_mone_desc_abre,
                           o_movi_mone_cant_deci => v_movi_mone_cant_deci,
                           o_movi_tasa_mone      => v_movi_tasa_mone,
                           i_timo_tica_codi      => V('P100_timo_tica_codi'));
end;
   setitem('P100_movi_mone_codi',v_mone_codi);
   setitem('P100_movi_mone_desc',v_movi_mone_desc);
   setitem('P100_movi_mone_desc_abre',v_movi_mone_desc_abre);
   setitem('P100_movi_mone_cant_deci',v_movi_mone_cant_deci);
   setitem('P100_movi_tasa_mone',v_movi_tasa_mone);
                         

  end if;

  if v('P100_MOVI_EMPL_CODI') is not null then

      begin
        I020337.pp_muestra_come_empl(p_empl_codi_alte => v('P100_MOVI_EMPL_CODI'),
                                     p_empl_desc      => v_empl_desc);
      end;
     setitem('P100_EMPL_DESC2',v_empl_desc);
end if;
  --------------------------------
  
if V('P100_MOCO_CONC_CODI') is not null then  
  BEGIN
  
  I020337.PP_BUSCAR_CONCEPTO(I_MOCO_CONC_CODI      => V('P100_MOCO_CONC_CODI'),
                             O_MOCO_CONC_DESC      => V_MOCO_CONC_DESC,
                             O_MOCO_DBCR           => V_MOCO_DBCR,
                             O_CONC_INDI_KILO_VEHI => V_CONC_INDI_KILO_VEHI,
                             O_CONC_INDI_IMPO      => V_CONC_INDI_IMPO,
                             O_CONC_INDI_ORTR      => V_CONC_INDI_ORTR,
                             O_CONC_INDI_GAST_JUDI => V_CONC_INDI_GAST_JUDI,
                             O_CONC_INDI_CENT_COST => V_CONC_INDI_CENT_COST,
                             O_CONC_INDI_ACTI_FIJO => V_CONC_INDI_ACTI_FIJO,
                             O_CUCO_NUME           => V_CUCO_NUME,
                             O_CUCO_DESC           => V_CUCO_DESC,
                             I_MOVI_SUCU_CODI_ORIG => V('P100_MOVI_SUCU_CODI_ORIG'),
                             I_MOVI_DBCR           => V('P100_MOVI_DBCR'));
END;

                             setitem('P100_MOCO_CONC_DESC',V_MOCO_CONC_DESC);
                             setitem('P100_MOCO_DBCR',V_MOCO_DBCR);
                             setitem('P100_CONC_INDI_KILO_VEHI',V_CONC_INDI_KILO_VEHI);
                             setitem('P100_CONC_INDI_IMPO',V_CONC_INDI_IMPO);
                             setitem('P100_CONC_INDI_ORTR',V_CONC_INDI_ORTR);
                             setitem('P100_CONC_INDI_GAST_JUDI',V_CONC_INDI_GAST_JUDI);
                             setitem('P100_CONC_INDI_CENT_COST',V_CONC_INDI_CENT_COST);
                             setitem('P100_CONC_INDI_ACTI_FIJO',V_CONC_INDI_ACTI_FIJO);
                             setitem('P100_CUCO_NUME',V_CUCO_NUME);
                             setitem('P100_CUCO_DESC',V_CUCO_DESC);


      begin
        v_moco_impu_codi := V('P100_moco_impu_codi');
        I020337.pp_mostrar_impu(i_moco_impu_codi           => v_moco_impu_codi,
                                o_moco_impu_desc           => v_moco_impu_desc,
                                o_moco_impu_porc           => v_moco_impu_porc,
                                o_moco_impu_porc_base_impo => v_moco_impu_porc_base_impo,
                                o_mi_indi_baim_impu_incl   => v_mi_indi_baim_impu_incl,
                                o_moco_conc_codi_impu      => v_moco_conc_codi_impu,
                                i_s_timo_calc_iva          => V('P100_s_timo_calc_iva'),
                                i_movi_dbcr                => V('P100_movi_dbcr'));
      end;
      

                    setitem('P100_moco_impu_codi',v_moco_impu_codi);
                    setitem('P100_moco_impu_desc',v_moco_impu_desc);
                    setitem('P100_moco_impu_porc', v_moco_impu_porc);
                    setitem('P100_moco_impu_porc_base_impo',v_moco_impu_porc_base_impo);
                    setitem('P100_mi_indi_baim_impu_incl',v_mi_indi_baim_impu_incl);
                    setitem('P100_moco_conc_codi_impu',v_moco_conc_codi_impu);

      begin
        -- Call the procedure
        I020337.pp_mostrar_tipo_impuesto(i_moco_tiim_codi => V('p100_moco_tiim_codi'),
                                         o_tiim_desc      => V_tiim_desc);
      end;
      
      setitem('p100_tiim_desc',V_tiim_desc);

  end if;
  begin
  -- Call the procedure
  I020337.pp_calcular_importe_cab(i_s_grav_10_ii        => nvl(v('P100_s_grav_10_ii'),0),
                                  i_s_grav_5_ii         => nvl(v('P100_s_grav_5_ii'),0),
                                  i_s_exen              => nvl(v('P100_s_exen'),0),
                                  i_movi_tasa_mone      => nvl(v('P100_movi_tasa_mone'),0),
                                  i_movi_timo_indi_sald => v('P100_movi_timo_indi_sald'),
                                  i_movi_mone_cant_deci => v('P100_movi_mone_cant_deci'),
                                  o_movi_grav10_ii_mone => v_movi_grav10_ii_mone,
                                  o_movi_grav5_ii_mone  => v_movi_grav5_ii_mone,
                                  o_movi_exen_mone      => v_movi_exen_mone,
                                  o_movi_impo_mone_ii   => v_movi_impo_mone_ii,
                                  o_s_total             => v_s_total,
                                  o_movi_grav10_ii_mmnn => v_movi_grav10_ii_mmnn,
                                  o_movi_grav5_ii_mmnn  => v_movi_grav5_ii_mmnn,
                                  o_movi_exen_mmnn      => v_movi_exen_mmnn,
                                  o_movi_iva10_mone     => v_movi_iva10_mone,
                                  o_movi_iva5_mone      => v_movi_iva5_mone,
                                  o_s_iva_10            => v_s_iva_10,
                                  o_s_iva_5             => v_s_iva_5,
                                  o_s_tot_iva           => v_s_tot_iva,
                                  o_movi_iva10_mmnn     => v_movi_iva10_mmnn,
                                  o_movi_iva5_mmnn      => v_movi_iva5_mmnn,
                                  o_movi_grav10_mone    => v_movi_grav10_mone,
                                  o_movi_grav5_mone     => v_movi_grav5_mone,
                                  o_movi_grav10_mmnn    => v_movi_grav10_mmnn,
                                  o_movi_grav5_mmnn     => v_movi_grav5_mmnn,
                                  o_movi_impo_mmnn_ii   => v_movi_impo_mmnn_ii,
                                  o_movi_grav_mone      => v_movi_grav_mone,
                                  o_movi_iva_mone       => v_movi_iva_mone,
                                  o_movi_grav_mmnn      => v_movi_grav_mmnn,
                                  o_movi_iva_mmnn       => v_movi_iva_mmnn,
                                  o_movi_sald_mone      => v_movi_sald_mone,
                                  o_movi_sald_mmnn      => v_movi_sald_mmnn);
end;


                                  setitem('p100_movi_grav10_ii_mone', v_movi_grav10_ii_mone);
                                  setitem('p100_movi_grav5_ii_mone', v_movi_grav5_ii_mone);
                                  setitem('p100_movi_exen_mone', v_movi_exen_mone);
                                  setitem('p100_movi_impo_mone_ii', v_movi_impo_mone_ii);
                                  setitem('p100_s_total', v_s_total);
                                  setitem('p100_movi_grav10_ii_mmnn', v_movi_grav10_ii_mmnn);
                                  setitem('p100_movi_grav5_ii_mmnn', v_movi_grav5_ii_mmnn);
                                  setitem('p100_movi_exen_mmnn', v_movi_exen_mmnn);
                                  setitem('p100_movi_iva10_mone', v_movi_iva10_mone);
                                  setitem('p100_movi_iva5_mone', v_movi_iva5_mone);
                                  setitem('p100_s_iva_10', v_s_iva_10);
                                  setitem('p100_s_iva_5', v_s_iva_5);
                                  setitem('p100_s_tot_iva', v_s_tot_iva);
                                  setitem('p100_movi_iva10_mmnn', v_movi_iva10_mmnn);
                                  setitem('p100_movi_iva5_mmnn', v_movi_iva5_mmnn);
                                  setitem('p100_movi_grav10_mone', v_movi_grav10_mone);
                                  setitem('p100_movi_grav5_mone', v_movi_grav5_mone);
                                  setitem('p100_movi_grav10_mmnn', v_movi_grav10_mmnn);
                                  setitem('p100_movi_grav5_mmnn', v_movi_grav5_mmnn);
                                  setitem('p100_movi_impo_mmnn_ii', v_movi_impo_mmnn_ii);
                                  setitem('p100_movi_grav_mone', v_movi_grav_mone);
                                  setitem('p100_movi_iva_mone', v_movi_iva_mone);
                                  setitem('p100_movi_grav_mmnn', v_movi_grav_mmnn);
                                  setitem('p100_movi_iva_mmnn', v_movi_iva_mmnn);
                                  setitem('p100_movi_sald_mone', v_movi_sald_mone);
                                  setitem('p100_movi_sald_mmnn', v_movi_sald_mmnn);

 begin
  I020337.pp_calcular_importe_item(i_moco_impo_mone_ii        => v('P100_moco_impo_mone_ii'),
                                   i_movi_mone_cant_deci      => v('P100_movi_mone_cant_deci'),
                                   i_moco_impu_porc           => v('P100_moco_impu_porc'),
                                   i_moco_impu_porc_base_impo => v('P100_moco_impu_porc_base_impo'),
                                   i_mi_indi_baim_impu_incl   => v('P100_mi_indi_baim_impu_incl'),
                                   i_movi_tasa_mone           => v('P100_movi_tasa_mone'),
                                   o_moco_impo_mone_ii        => v_moco_impo_mone_ii,
                                   o_moco_grav10_ii_mone      => v_moco_grav10_ii_mone,
                                   o_moco_grav5_ii_mone       => v_moco_grav5_ii_mone,
                                   o_moco_grav10_mone         => v_moco_grav10_mone,
                                   o_moco_grav5_mone          => v_moco_grav5_mone,
                                   o_moco_iva10_mone          => v_moco_iva10_mone,
                                   o_moco_iva5_mone           => v_moco_iva5_mone,
                                   o_moco_Exen_mone           => v_moco_Exen_mone,
                                   o_moco_impo_mmnn_ii        => v_moco_impo_mmnn_ii,
                                   o_moco_grav10_ii_mmnn      => v_moco_grav10_ii_mmnn,
                                   o_moco_grav5_ii_mmnn       => v_moco_grav5_ii_mmnn,
                                   o_moco_grav10_mmnn         => v_moco_grav10_mmnn,
                                   o_moco_grav5_mmnn          => v_moco_grav5_mmnn,
                                   o_moco_iva10_mmnn          => v_moco_iva10_mmnn,
                                   o_moco_iva5_mmnn           => v_moco_iva5_mmnn,
                                   o_moco_exen_mmnn           => v_moco_exen_mmnn,
                                   o_moco_impo_mmnn           => v_moco_impo_mmnn,
                                   o_moco_impo_mone           => v_moco_impo_mone);
end;


              setitem('p100_moco_impo_mone_ii', v_moco_impo_mone_ii);
              setitem('p100_moco_grav10_ii_mone', v_moco_grav10_ii_mone);
              setitem('p100_moco_grav5_ii_mone', v_moco_grav5_ii_mone);
              setitem('p100_moco_grav10_mone', v_moco_grav10_mone);
              setitem('p100_moco_grav5_mone', v_moco_grav5_mone);
              setitem('p100_moco_iva10_mone', v_moco_iva10_mone);
              setitem('p100_moco_iva5_mone', v_moco_iva5_mone);
              setitem('p100_moco_Exen_mone', v_moco_Exen_mone);
              setitem('p100_moco_impo_mmnn_ii', v_moco_impo_mmnn_ii);
              setitem('p100_moco_grav10_ii_mmnn', v_moco_grav10_ii_mmnn);
              setitem('p100_moco_grav5_ii_mmnn', v_moco_grav5_ii_mmnn);
              setitem('p100_moco_grav10_mmnn', v_moco_grav10_mmnn);
              setitem('p100_moco_grav5_mmnn', v_moco_grav5_mmnn);
              setitem('p100_moco_iva10_mmnn', v_moco_iva10_mmnn);
              setitem('p100_moco_iva5_mmnn', v_moco_iva5_mmnn);
              setitem('p100_moco_exen_mmnn', v_moco_exen_mmnn);
              setitem('p100_moco_impo_mmnn', v_moco_impo_mmnn);
              setitem('p100_moco_impo_mone', v_moco_impo_mone);
              
              
    select sum(nvl(v('P100_MOCO_IMPO_MONE_II'), 0)),
           sum(nvl(v('P100_MOCO_EXEN_MONE'), 0)),
           sum(nvl(v('P100_SUM_MOCO_GRAV5_II_MONE'), 0)),
           sum(nvl(v('P100_MOCO_GRAV10_II_MONE'), 0))

      into V_SUM_MOCO_IMPO_MONE_II,
           V_SUM_MOCO_EXEN_MONE,
           V_SUM_MOCO_GRAV5_II_MONE,
           V_SUM_MOCO_GRAV10_II_MONE
      from dual;


       setitem('P100_SUM_MOCO_IMPO_MONE_II', V_SUM_MOCO_IMPO_MONE_II);
       setitem('P100_SUM_MOCO_EXEN_MONE', V_SUM_MOCO_EXEN_MONE);
       setitem('P100_SUM_MOCO_GRAV5_II_MONE', V_SUM_MOCO_GRAV5_II_MONE);
       setitem('P100_SUM_MOCO_GRAV10_II_MONE', V_SUM_MOCO_GRAV10_II_MONE);

             

end pp_cargar_fact;



PROCEDURE pp_cargar_importes(p_movi_codi in number) IS
  v_s_exen        number;
  v_s_grav_10_ii  number;
  v_s_grav_5_ii   number;
BEGIN
  select sum(decode(i.moim_impu_codi, 1, (i.moim_impo_mone + i.moim_impu_mone), 0)) Exen,
         sum(decode(i.moim_impu_codi, 2, (i.moim_impo_mone + i.moim_impu_mone), 0)) Grav_10,
         sum(decode(i.moim_impu_codi, 3, (i.moim_impo_mone + i.moim_impu_mone), 0)) Grav_5
    into v_s_exen, v_s_grav_10_ii, v_s_grav_5_ii
    from come_movi_impu_deta i
   where i.moim_movi_codi = p_movi_codi;


     setitem('P100_s_exen', v_s_exen);
     setitem('P100_s_grav_10_ii', v_s_grav_10_ii);
     setitem('P100_s_grav_5_ii', v_s_grav_5_ii);
     
END pp_cargar_importes;
 

PROCEDURE pp_cargar_detalle(p_movi_codi in number) IS
    cursor det_comp is
      select moco_conc_codi,
             moco_impu_codi,
             moco_tiim_codi,
             moco_nume_item,             
             moco_impo_mone_ii, 
             moco_desc, 
             moco_impo_codi, 
             moco_juri_codi, 
             moco_orse_codi, 
             moco_ortr_codi, 
             moco_ceco_codi, 
             moco_tran_codi, 
             moco_emse_codi, 

             impo_nume, 
             ortr_nume, 
             orse_nume_char, 
             tran_codi_alte, 
             ceco_nume, 
             emse_codi_alte, 
             juri_nume

        from come_movi_conc_deta, 
              come_orde_trab, 
              come_impo, 
              come_orde_serv , 
              come_empr_secc, 
              come_cent_cost, 
              come_tran, 
              come_clie_juri
       where  moco_ortr_codi = ortr_codi(+)
       and moco_impo_codi = impo_codi(+)
       and moco_orse_codi = orse_codi(+)
       and moco_emse_codi = emse_codi(+)
       and moco_Ceco_codi = ceco_codi(+)
       and moco_tran_codi = tran_codi(+)
       and moco_juri_codi = juri_codi(+)
       and moco_movi_codi = p_movi_codi
         and moco_conc_codi not in
             (select impu_conc_codi_ivcr 
              from come_impu 
              where impu_conc_codi_ivcr is not null
              union
              select impu_conc_codi_ivdb
              from come_impu 
              where impu_conc_codi_ivdb is not null)
       order by moco_nume_item ;

BEGIN
  

  for x in det_comp loop
    
     setitem('P100_moco_nume_item',  x.moco_nume_item);
     setitem('P100_moco_conc_codi',  x.moco_conc_codi);
     setitem('P100_moco_impu_codi',  x.moco_impu_codi);
     setitem('P100_moco_tiim_codi',  x.moco_tiim_codi);
     setitem('P100_moco_impo_mone_ii',x.moco_impo_mone_ii);
 --    setitem('P100_moco_impo_codi',   x.moco_impo_codi);
     
    -- setitem('P100_moco_impo_codi', x.moco_impo_codi); 
    -- setitem('P100_impo_nume', x.impo_nume);
     
--     setitem('P100_moco_ceco_codi', x.moco_ceco_codi);
   /*  setitem('P100_ceco_nume', x.ceco_nume);
     
     setitem('P100_moco_ortr_codi', x.moco_ortr_codi);
     setitem('P100_ortr_nume', x.ortr_nume);*/
     
  /*   setitem('P100_moco_orse_codi', x.moco_orse_codi);
     setitem('P100_orse_nume_char', x.orse_nume_char);
      
     setitem('P100_moco_juri_codi', x.moco_juri_codi);
     setitem('P100_juri_nume',  x.juri_nume);
     
     setitem('P100_moco_emse_codi', x.moco_emse_codi);
     setitem('P100_emse_codi_alte', x.emse_codi_alte);
     
     setitem('P100_moco_tran_codi', x.moco_tran_codi);
     setitem('P100_tran_codi_alte',  x.tran_codi_alte);
     
     setitem('P100_moco_desc', x.moco_desc);*/
     
     
  end loop;
  
  

  
  
END pp_cargar_detalle;


procedure pp_cargar_liqu(p_indi_regi_apli      in varchar2,
                         p_movi_clpr_codi      in varchar2,
                         p_s_indi_prov_rela    in varchar2,
                         p_movi_codi           in varchar2) is

cursor c_liqu (p_clpr_codi in number, p_indi in varchar2) is
   select ld.deta_liqu_codi,
          ld.deta_nume_item,
          e.empl_codi_alte,
          e.empl_desc,
          l.liqu_nume,
          l.liqu_fech_emis,
          ld.deta_conc_codi conc_codi,
          rc.conc_desc,
          (nvl(ld.deta_impo_ingre,0) - nvl(ld.deta_impo_egre,0)) liqu_impo,
          (fa_devu_sald_fact_apli('L', ld.deta_liqu_codi, ld.deta_nume_item, null) - nvl(ld.deta_impo_desc_rete,0)) liqu_saldo,
          nvl(ld.deta_impo_desc_rete,0) rete_impo
     from rrhh_liqu l, 
          rrhh_conc_liqu_deta ld, 
          come_empl e, 
          rrhh_plan_suel ps, 
          rrhh_conc rc
          
    where l.liqu_codi = ld.deta_liqu_codi
      and l.liqu_empl_codi = e.empl_codi
      
      and e.empl_plsu_codi = ps.plsu_codi      
      and ld.deta_conc_codi = rc.conc_codi
      and rc.conc_codi in (select pd.plco_conc_codi from  rrhh_plan_suel_conc_deta pd where pd.plco_plsu_codi = ps.plsu_codi)
      and (fa_devu_sald_fact_apli('L', ld.deta_liqu_codi, ld.deta_nume_item, null) - nvl(ld.deta_impo_desc_rete,0)) > 0
      and ((e.empl_clpr_codi = p_clpr_codi and p_indi = 'S')
       or (e.empl_clpr_codi is null and p_indi = 'N'))
 order by l.liqu_fech_emis, e.empl_codi_alte;
 


cursor c_liqu_borr (p_movi_codi in number) is
select ma.apli_codi,
       ma.apli_fech,
       ld.deta_liqu_codi,
       ld.deta_nume_item,
       e.empl_codi_alte,
       e.empl_desc,
       l.liqu_nume,
       l.liqu_fech_emis,
       ps.plsu_conc_codi conc_codi,
       rc.conc_desc,
       (nvl(ld.deta_impo_ingre, 0) - nvl(ld.deta_impo_egre, 0)) liqu_impo,
       0 liqu_saldo,
       ma.apli_impo_mmnn saldo_sele,
       ld.deta_impo_desc_rete rete_impo
  from rrhh_liqu               l,
       rrhh_conc_liqu_deta     ld,
       come_empl               e,
       rrhh_plan_suel          ps,
       rrhh_conc               rc,
       rrhh_movi_apli_liqu     ma
 where l.liqu_codi = ld.deta_liqu_codi
 
   and l.liqu_empl_codi = e.empl_codi
   
   and e.empl_plsu_codi = ps.plsu_codi
   
   and ld.deta_conc_codi = rc.conc_codi   

   and ma.apli_movi_codi = p_movi_codi
   and ma.apli_deta_liqu_codi = ld.deta_liqu_codi
   and ma.apli_deta_nume_item = ld.deta_nume_item
order by ma.apli_codi, ma.apli_fech;
  
  v_count number := 0;
begin


 apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');


  if p_indi_regi_apli = 'A' then
    ---pl_mm('es una alicacion. clpr_codi: '||:bcab.movi_clpr_codi||' p_ind: '||:bcab.s_indi_prov_rela);
    
    for x in c_liqu (p_movi_clpr_codi, p_s_indi_prov_rela) loop
          v_count := v_count + 1;
     
         apex_collection.add_member(p_collection_name => 'DETALLE',
                                    p_c001          => null,--apli_codigo,
                                    p_c002          => null,--apli_fecha,
                                    p_c003          => x.deta_liqu_codi,
                                    p_c004          => x.deta_nume_item,
                                    p_c005          => x.empl_codi_alte,
                                    p_c006          => x.empl_desc,
                                    p_c007          => x.liqu_nume,
                                    p_c008          => x.liqu_fech_emis,
                                    p_c009          => x.conc_codi,
                                    p_c010          => x.conc_desc,
                                    p_c011          => x.liqu_impo,
                                    p_c012          => x.liqu_saldo,
                                    p_c013          => null,--saldo_select
                                    p_c014          => x.rete_impo,
                                    p_c015          => 'N'--indi
                                    );
      
    end loop;
    
  else
         
    for x in c_liqu_borr (p_movi_codi) loop
  
     apex_collection.add_member(p_collection_name => 'DETALLE',
                                p_c001          => x.apli_codi,
                                p_c002          => x.apli_fech,
                                p_c003          => x.deta_liqu_codi,
                                p_c004          => x.deta_nume_item,
                                p_c005          => x.empl_codi_alte,
                                p_c006          => x.empl_desc,
                                p_c007          => x.liqu_nume,
                                p_c008          => x.liqu_fech_emis,
                                p_c009          => x.conc_codi,
                                p_c010          => x.conc_desc,
                                p_c011          => x.liqu_impo,
                                p_c012          => x.liqu_saldo,
                                p_c013          => x.saldo_sele,
                                p_c014          => x.rete_impo,
                                p_c015          => 'S'
                                );
      

    end loop;

  end if;   
end pp_cargar_liqu;


procedure pp_editar_indi (p_seq_id  in number,
                          p_valor   in varchar2)is
 v_saldo number;
 begin
   
 APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME    => 'DETALLE',
                                            P_SEQ             => p_seq_id,
                                            P_ATTR_NUMBER     => 15,
                                            P_ATTR_VALUE      => p_valor);
  
 if p_valor  = 'N' then
   v_saldo := null;
 else                                         
     select c012
      into v_saldo
      from apex_collections
     where collection_name = 'DETALLE'
       and seq_id = p_seq_id;   
  end if;                                     
                                            
APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                          P_SEQ             => p_seq_id,
                                          P_ATTR_NUMBER     => 13,
                                          P_ATTR_VALUE      => v_saldo);


 end pp_editar_indi;


procedure pp_editar_importe (p_seq_id  in varchar2,
                             p_valor   in varchar2)is
 v_indica varchar2(20);
 v_saldo number;
 v_seq_id varchar2(20);
 begin
  v_seq_id := replace(p_seq_id,'f02_');

                                
     select c015
      into v_indica
      from apex_collections
     where collection_name = 'DETALLE'
       and seq_id = v_seq_id;   
   --raise_application_error(-20001,p_valor||'--'||v_seq_id||'--'||v_indica );                                  
   if v_indica  = 'S' then
     v_saldo := p_valor;
   else
     v_saldo := null;
   end if;                                   
APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETALLE',
                                          P_SEQ             => v_seq_id,
                                          P_ATTR_NUMBER     => 13,
                                          P_ATTR_VALUE      => v_saldo);


   
 end pp_editar_importe;
 
 
 
 
procedure pp_editar_indi_elim (p_seq_id  in number,
                              p_valor   in varchar2)is
 v_saldo number;
 begin
   
 APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME    => 'DETALLE',
                                            P_SEQ             => p_seq_id,
                                            P_ATTR_NUMBER     => 16,
                                            P_ATTR_VALUE      => p_valor);
  



 end pp_editar_indi_elim;


end I020337;
