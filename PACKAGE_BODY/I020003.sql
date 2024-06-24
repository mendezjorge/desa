
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020003" is

  g_user varchar2(100) := gen_user;

  type t_parameter is record(
    p_cant_dias_feri              number := 0,
    p_cant_deci_mmee              number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmee')),
    p_cant_deci_mmnn              number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_clpr_indi_clie_prov         number,
    p_codi_base                   number := pack_repl.fa_devu_codi_base,
    p_codi_conc_rete_emit         number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_emit')),
    p_codi_impu_exen              number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_codi_impu_grav5             number := to_number(general_skn.fl_busca_parametro('p_codi_impu_grav5')),
    p_codi_mone_mmee              number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmee')),
    p_codi_mone_mmnn              number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_codi_oper                   number := to_number(general_skn.fl_busca_parametro('p_codi_oper_com')),
    p_codi_oper_com               number := to_number(general_skn.fl_busca_parametro('p_codi_oper_com')),
    p_codi_oper_dvta              number,
    p_codi_oper_sprod             number := to_number(general_skn.fl_busca_parametro('p_codi_oper_sprod')),
    p_codi_timo_auto_fact_emit    number := to_number(general_skn.fl_busca_parametro('p_codi_timo_auto_fact_emit')),
    p_codi_timo_auto_fact_emit_cr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_auto_fact_emit_cr')),
    p_codi_timo_rete_emit         number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rete_emit')),
    p_emit_reci                   varchar2(200) := 'R',
    p_empr_codi                   number,
    p_fech_fini                   date,
    p_fech_inic                   date,
    
    p_form_calc_rete_emit    number := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_calc_rete_emit'))),
    p_indi_apli_rete_exen    varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_apli_rete_exen'))),
    p_indi_impr_cheq_emit    varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_impr_cheq_emit'))),
    p_indi_impr_etiq_comp    varchar2(200),
    p_indi_impr_repo_vta_com varchar2(200) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_impr_repo_vta_com'))),
    p_indi_most_secc_dbcr    varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_secc_dbcr'))),
    p_indi_rete_tesaka       varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_rete_tesaka'))),
    p_indi_vali_repe_cheq    varchar2(5) := general_skn.fl_busca_parametro('p_indi_vali_repe_cheq'),
    p_ind_validar_det_lote   varchar2(1) := 'S',
    p_indi_gene_lote_desc    varchar2(1) := 'A',
    p_movi_codi              number,
    p_movi_codi_rete         number,
    p_orco_codi              number,
    p_para_inic              varchar2(500) := 'COM',
    p_peco_codi              number,
    p_secu_sesi_user_comp    varchar2(200) := v('APP_SESSION'));

  parameter t_parameter;

  type t_bcab is record(
    fech_venc_timb           date,
    impo_brut_mmnn           number,
    impo_brut_mone           number,
    impo_deto_mone           number,
    impo_reca_mone           number,
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
    movi_timo_codi           come_movi.movi_timo_codi%type,
    movi_timo_indi_adel      varchar2(200),
    movi_timo_indi_ncr       varchar2(200),
    movi_timo_indi_sald      varchar2(200),
    movi_user                come_movi.movi_user%type,
    orco_codi                number,
    tico_indi_vali_timb      varchar2(1),
    tico_indi_timb_auto      varchar2(1),
    s_impo_adel              number,
    s_impo_cheq              number,
    s_impo_efec              number,
    s_impo_rete              number,
    s_impo_rete_reci         number,
    s_impo_rete_rent         number,
    s_impo_tarj              number,
    s_impo_vale              number,
    s_impo_viaj              number,
    s_movi_codi_a_modi       number,
    s_tot_iva                number);

  bcab t_bcab;

  type t_bdet is record(
    f_dif_grav_5_ii         number,
    f_dif_grav_10_ii        number,
    f_dif_exen              number,
    f_dif_tot_item          number,
    f_dif_mone_ii_bruto     number,
    sum_deta_impo_mone_ii   number,
    sum_impo_mone_ii_bruto  number,
    sum_deta_grav5_ii_mone  number,
    sum_deta_grav10_ii_mone number,
    sum_deta_exen_mone      number);

  fbdet t_bdet;

  type t_brete is record(
    movi_fech_venc_timb_rete date,
    movi_impo_rete           number,
    movi_nume_rete           number,
    movi_nume_timb_rete      number);

  brete t_brete;

  type t_bcuota is record(
    sum_cuot_impo_mone number,
    sum_cuot_impo_mmnn number);
  fbcuota t_bcuota;

  --pack_fpago.fp_calc_ingreso_egreso;

  type t_bfp_cab is record(
    s_impo_mmnn              number,
    s_impo_mone              number,
    tota_adel_egre_movi      number,
    tota_adel_ingr_movi      number,
    tota_cheq_egre_movi      number,
    tota_cheq_ingr_movi      number,
    tota_efec_egre_movi      number,
    tota_efec_ingr_movi      number,
    tota_rete_reci_egre_movi number,
    tota_rete_reci_ingr_movi number,
    tota_tarj_egre_movi      number,
    tota_tarj_ingr_movi      number,
    tota_vale_egre_movi      number,
    tota_vale_ingr_movi      number,
    tota_viaj_egre_movi      number,
    tota_viaj_ingr_movi      number);

  bfp_cab t_bfp_cab;

  cursor cur_bdet is
    select *
      from (select seq_id deta_nume_item_codi,
                   c001   indi_prod_gast,
                   c002   deta_cant,
                   c003   deta_clpr_codi,
                   c004   deta_coba_codi,
                   c005   deta_conc_codi,
                   c006   deta_exen_mmnn,
                   c007   deta_exen_mone,
                   c008   deta_grav10_ii_mmnn,
                   c009   deta_grav10_ii_mone,
                   c010   deta_grav10_mmnn,
                   c011   deta_grav10_mone,
                   c012   deta_grav5_ii_mmnn,
                   c013   deta_grav5_ii_mone,
                   c014   deta_grav5_mmnn,
                   c015   deta_grav5_mone,
                   c016   deta_impo_mmnn,
                   c017   deta_impo_mmnn_ii,
                   c018   deta_impo_mone,
                   c019   deta_impo_mone_ii,
                   c020   deta_impu_codi,
                   c021   deta_iva10_mmnn,
                   c022   deta_iva10_mone,
                   c023   deta_iva5_mmnn,
                   c024   deta_iva5_mone,
                   c026   deta_prec_unit,
                   c027   deta_prod_codi,
                   c028   fact_conv,
                   c029   impo_mone_ii_bruto,
                   c030   s_descuento,
                   c031   s_recargo,
                   c035   deta_prod_desc,
                   c036   medi_codi,
                   c037   prod_indi_lote,
                   c038   deta_lote_codi,
                   ---******
                   c040 moco_seq_id,
                   c041 conc_seq_id,
                   c042 impu_seq_id,
                   c043 otro_seq_id
              from apex_collections a
             where a.collection_name = 'CUR_DET') deta,
           (select seq_id seq_id_moco,
                   c001   moco_ceco_codi,
                   c002   moco_conc_codi_impu,
                   c003   moco_dbcr,
                   c004   moco_desc,
                   c005   moco_emse_codi,
                   c006   moco_impo_codi,
                   c007   moco_juri_codi,
                   c008   moco_orse_codi,
                   c009   moco_ortr_codi,
                   c010   moco_tran_codi
              from apex_collections
             where collection_name = 'CUR_MOCO') moco,
           (select seq_id seq_id_conc,
                   c001   conc_dbcr,
                   c002   conc_indi_impo,
                   c003   conc_indi_kilo_vehi,
                   c004   conc_indi_ortr,
                   c005   conc_indi_gast_judi,
                   c006   conc_indi_cent_cost,
                   c007   conc_indi_acti_fijo,
                   c008   cuco_nume,
                   c009   cuco_desc
              from apex_collections
             where collection_name = 'CUR_CONC') conc,
           (select seq_id seq_id_impu,
                   c002   impu_indi_baim_impu_incl,
                   c003   impu_porc,
                   c004   impu_porc_base_impo
              from apex_collections
             where collection_name = 'CUR_IMPU') impu,
           (select seq_id seq_id_otro,
                   c001   bien_codi,
                   c019   gatr_kilo_actu,
                   c020   gatr_litr_carg,
                   c040   ortr_sali_mate_codi
              from apex_collections
             where collection_name = 'CUR_REST') otro
     where deta.moco_seq_id = moco.seq_id_moco(+)
       and deta.conc_seq_id = conc.seq_id_conc(+)
       and deta.impu_seq_id = impu.seq_id_impu(+)
       and deta.otro_seq_id = otro.seq_id_otro(+);

  --cursor cur_bdet is 

  /*
  ,c002   ceco_nume,
  c005   conc_indi_cent_cost,
  c009   conc_indi_ortr,
  c011   deta_clpr_codi,
  c021   impo_nume,
  c023   juri_nume,
  c028   moco_conc_desc,                                                   
  c037   movi_dbcr,
  c038   movo_orse_codi,
  c039   ortr_nume,
  c041   prod_codi_alfa,
  c042   tran_codi_alte,
  c049   deta_descripcion
  */

  cursor cur_bfp is
    select c001 fopa_codi,
           c002 cheq_nume,
           c003 cheq_serie,
           c004 cheq_banc_codi,
           c005 vale_codi,
           c006 adel_codi
      from apex_collections a
     where a.collection_name = 'CHEQUE';

  cursor cur_bcuota is
    select c001 cuot_impo_mmnn,
           c002 cuot_fech_venc,
           c003 cuot_impo_mone,
           c004 dias
      from apex_collections a
     where a.collection_name = 'BCUOTA';

  cursor cur_lote is
    select seq_id,
           c001   lote_desc,
           c002   lote_codi_barr,
           c003   lote_cant_medi,
           c004   lote_codi,
           c005   deta_prod_codi,
           c006   deta_nume_item_codi,
           c007   deta_exen_mmnn,
           c008   deta_exen_mone,
           c009   deta_grav10_ii_mmnn,
           c010   deta_grav10_ii_mone,
           c011   deta_grav10_mmnn,
           c012   deta_grav10_mone,
           c013   deta_grav5_ii_mmnn,
           c014   deta_grav5_ii_mone,
           c015   deta_grav5_mmnn,
           c016   deta_grav5_mone,
           c017   deta_impo_mmnn,
           c018   deta_impo_mmnn_ii,
           c019   deta_impo_mone,
           c020   deta_impo_mone_ii,
           c021   deta_iva10_mmnn,
           c022   deta_iva10_mone,
           c023   deta_iva5_mmnn,
           c024   deta_iva5_mone,
           c025   indi_manu_auto,
           c026   s_descuento,
           c027   s_recargo,
           c028   selo_desc_abre,
           c029   selo_ulti_nume,
           c030   lote_ulti_regi,
           c031   impo_mone_ii_bruto,
           c032   deta_prec_unit,
           d001   lote_fech_elab,
           d002   lote_fech_venc
      from apex_collections a
     where a.collection_name = 'COMPRA_DET_LOTE'
       and c006 = 0; -- deta_nume_item_codi;

  procedure pp_cargar_parametros is
  begin
    /*if parameter.p_secu_sesi_user_comp is not null then
      pack_compra_temp.pa_eliminar_lote_temp(parameter.p_secu_sesi_user_comp,
                                             null,
                                             'T');
    end if;*/
    -- parameter.p_secu_sesi_user_comp := fa_sec_sesi_user_comp;
  
    /*   if rtrim(ltrim(upper(parameter.p_para_inic))) =
         rtrim(ltrim(upper('com'))) then
        parameter.p_codi_oper := parameter.p_codi_oper_com;
        parameter.p_emit_reci := 'R';
      elsif rtrim(ltrim(upper(parameter.p_para_inic))) =
            rtrim(ltrim(upper('mcom'))) then
        parameter.p_codi_oper := parameter.p_codi_oper_com;
        parameter.p_emit_reci := 'R';
      elsif rtrim(ltrim(upper(parameter.p_para_inic))) =
            rtrim(ltrim(upper('vta'))) then
        parameter.p_emit_reci := 'E';
      elsif rtrim(ltrim(upper(parameter.p_para_inic))) =
            rtrim(ltrim(upper('dcom'))) then
        parameter.p_emit_reci := 'R';
      elsif rtrim(ltrim(upper(parameter.p_para_inic))) =
            rtrim(ltrim(upper('dvta'))) then
        parameter.p_codi_oper := parameter.p_codi_oper_dvta;
        parameter.p_emit_reci := 'E';
      end if;
    */
    pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
  
  end pp_cargar_parametros;

  function p_emit_reci return varchar2 as
  begin
    return parameter.p_emit_reci;
  end p_emit_reci;

  function p_codi_oper return number as
  begin
    return parameter.p_codi_oper;
  end p_codi_oper;

  procedure pl_mm(i_mensaje varchar2) is
  begin
    null; --- mensaje
  end pl_mm;

  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010, v_mensaje);
  end pl_me;

  procedure pp_dele_cheq(p_movi_codi in number) is
    cursor c_cheq_movi is
      select chmo_cheq_codi, chmo_movi_codi
        from come_movi_cheq
       where chmo_movi_codi = p_movi_codi;
  
  begin
    for x in c_cheq_movi loop
      delete come_movi_cheq
       where chmo_movi_codi = x.chmo_movi_codi
         and chmo_cheq_codi = x.chmo_cheq_codi;
    
      delete come_cheq where cheq_codi = x.chmo_cheq_codi;
    end loop;
  end pp_dele_cheq;

  procedure pp_borrar_movi_hijos(p_movi_codi in number) is
  
    cursor c_hijos(p_codi in number) is
      select movi_codi from come_movi where movi_codi_padr = p_codi;
  
    cursor c_nietos(p_codi in number) is
      select movi_codi from come_movi where movi_codi_padr = p_codi;
  
  begin
  
    for x in c_hijos(p_movi_codi) loop
      for y in c_nietos(x.movi_codi) loop
        delete come_movi_prod_deta where deta_movi_codi = y.movi_codi;
      
        delete come_movi_cuot where cuot_movi_codi = y.movi_codi;
      
        delete come_movi_impu_deta where moim_movi_codi = y.movi_codi;
      
        delete come_movi_impo_deta where moim_movi_codi = y.movi_codi;
      
        delete come_movi_conc_deta where moco_movi_codi = y.movi_codi;
      
        pp_dele_cheq(y.movi_codi);
      
        delete come_movi where movi_codi = y.movi_codi;
      
      end loop;
      delete come_movi_prod_deta where deta_movi_codi = x.movi_codi;
    
      delete come_movi_cuot where cuot_movi_codi = x.movi_codi;
    
      delete come_movi_impu_deta where moim_movi_codi = x.movi_codi;
    
      delete come_movi_impo_deta where moim_movi_codi = x.movi_codi;
    
      delete come_movi_conc_deta where moco_movi_codi = x.movi_codi;
    
      pp_dele_cheq(x.movi_codi);
    
      delete come_movi where movi_codi = x.movi_codi;
    
    end loop;
  
  end pp_borrar_movi_hijos;

  procedure pp_dele_movi_orig(p_movi_codi in number) is
    v_rete_codi number := 0;
  begin
    begin
      select more_movi_codi_rete
        into v_rete_codi
        from come_movi_rete
       where more_movi_codi = p_movi_codi;
    
      delete from come_movi_impo_deta where moim_movi_codi = v_rete_codi;
      delete from come_movi_impu_deta where moim_movi_codi = v_rete_codi;
      delete from come_movi_conc_deta where moco_movi_codi = v_rete_codi;
      delete from come_movi_rete where more_movi_codi_rete = v_rete_codi;
      delete from come_movi where movi_codi = v_rete_codi;
    
    exception
      when others then
        null;
    end;
  
    begin
    
      select orco_codi
        into parameter.p_orco_codi
        from come_orde_comp
       where orco_movi_codi = parameter.p_movi_codi;
    
    exception
      when others then
        parameter.p_orco_codi := null;
    end;
  
    update come_orde_comp a
       set a.orco_movi_codi = null
     where a.orco_movi_codi = parameter.p_movi_codi;
  
    pp_borrar_movi_hijos(p_movi_codi);
  
    update come_orde_comp a
       set a.orco_movi_codi = null
     where a.orco_codi = bcab.orco_codi;
  
    --detalle de productos..................
    delete from come_movi_prod_deta c where c.deta_movi_codi = p_movi_codi;
    --detalle de cuotas.....................
    delete from come_movi_cuot where cuot_movi_codi = p_movi_codi;
    ---detalle de impuestos.................
    delete come_movi_impu_deta where moim_movi_codi = p_movi_codi;
  
    ---detalle de conceptos.................
    delete come_movi_conc_deta where moco_movi_codi = p_movi_codi;
  
    --detalle de importes...
    delete come_movi_impo_deta where moim_movi_codi = p_movi_codi;
  
    --detalle de cheques
    pp_dele_cheq(p_movi_codi);
  
    --detalle de gastos de transporte
    delete come_movi_gast_tran where gatr_movi_codi = p_movi_codi;
  
    delete come_movi where movi_codi = p_movi_codi;
  
    --post;
  
  end pp_dele_movi_orig;

  procedure pp_calcular_importe_cab is
  begin
    bcab.movi_impo_mone_ii := bcab.movi_grav10_ii_mone +
                              bcab.movi_grav5_ii_mone + bcab.movi_exen_mone;
    bcab.movi_impo_mone_ii := bcab.movi_impo_mone_ii;
    bcab.impo_brut_mone    := bcab.movi_impo_mone_ii + bcab.impo_deto_mone -
                              bcab.impo_reca_mone;
  
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
    bcab.movi_iva10_mone     := round((bcab.movi_grav10_ii_mone / 11),
                                      bcab.movi_mone_cant_deci);
    bcab.movi_iva5_mone      := round((bcab.movi_grav5_ii_mone / 21),
                                      bcab.movi_mone_cant_deci);
  
    bcab.s_tot_iva         := bcab.movi_iva10_mone + bcab.movi_iva5_mone;
    bcab.movi_iva10_mmnn   := round((bcab.movi_grav10_ii_mmnn / 11),
                                    parameter.p_cant_deci_mmnn);
    bcab.movi_iva5_mmnn    := round((bcab.movi_grav5_ii_mmnn / 21),
                                    parameter.p_cant_deci_mmnn);
    bcab.movi_grav10_mone  := round((bcab.movi_grav10_ii_mone / 1.1),
                                    bcab.movi_mone_cant_deci);
    bcab.movi_grav5_mone   := round((bcab.movi_grav5_ii_mone / 1.05),
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
  
    /*if bcab.timo_dbcr_caja = 'C' then
         bcab.s_impo_efec    := -nvl(bfp.tota_efec_ingr,0) + nvl(bfp.tota_efec_egre,0);-- - nvl(brete.movi_impo_rete, 0);
      else
         bcab.s_impo_efec    := nvl(bfp.tota_efec_ingr,0) - nvl(bfp.tota_efec_egre,0);
      end if; 
        
     bcab.s_impo_cheq    := nvl(bfp.tota_cheq_egre,0) - nvl(bfp.tota_cheq_ingr,0);
     bcab.s_impo_adel    := nvl(bfp.tota_adel_egre,0) - nvl(bfp.tota_adel_ingr,0);
     bcab.s_impo_vale    := nvl(bfp.tota_vale_egre,0) - nvl(bfp.tota_vale_ingr,0);
    --
    -- pago
     bfp.tota_fact := nvl(bcab.movi_impo_mone_ii,0) - nvl(bcab.s_impo_rete,0);
     bfp.tota_fact_mmnn := nvl(bcab.movi_impo_mmnn_ii,0) - round((nvl(bcab.s_impo_rete,0) * bcab.movi_tasa_mone), parameter.p_cant_deci_mmnn);
    */
  end pp_calcular_importe_cab;

  procedure pp_validar_importes is
  begin
  
    if fbdet.f_dif_mone_ii_bruto <> 0 then
      pl_me('Diferencia entre total Bruto y detalle.');
    end if;
  
    if fbdet.f_dif_exen <> 0 then
      pl_me('Diferencia entre total Exento y detalle.');
    end if;
  
    if fbdet.f_dif_grav_5_ii <> 0 then
      pl_me('Diferencia entre total Gravado 5% y detalle.');
    end if;
  
    if fbdet.f_dif_grav_10_ii <> 0 then
      pl_me('Diferencia entre total Gravado 10% y detalle.');
    end if;
  
    if fbdet.f_dif_tot_item <> 0 then
      pl_me('Diferencia entre total Item y detalle.');
    end if;
  
    if bcab.movi_afec_sald = 'N' then
      -- si es contado
      if (nvl(bcab.s_impo_cheq, 0) + nvl(bcab.s_impo_efec, 0) +
         nvl(bcab.s_impo_adel, 0) + nvl(bcab.s_impo_vale, 0)) <>
         (nvl(bcab.movi_impo_mone_ii, 0) - nvl(bcab.s_impo_rete, 0)) then
        pl_me('El importe total de cheques + el importe en efectivo + el importe en adelanto + el importe de vales debe ser igual al importe del documento - la retencion');
      end if;
    end if;
  
    -- solo para validar cuotas en caso que sea credito
    if bcab.movi_afec_sald = 'N' then
      ---si es contado
      null;
    else
      --si es credito
      if nvl(bcab.movi_timo_indi_adel, 'N') = 'S' or
         nvl(bcab.movi_timo_indi_ncr, 'N') = 'S' then
        null;
      else
        if nvl(bcab.movi_impo_mone_ii, 0) <>
           nvl(fbcuota.sum_cuot_impo_mone, 0) then
          pl_me('Diferencia entre el total de la factura y el total de las cuotas, Favor Verificar');
        end if;
      end if;
    end if;
  
  exception
    when others then
      pl_me(sqlerrm);
  end pp_validar_importes;

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
  
    if parameter.p_indi_vali_repe_cheq = 'S' then
      pl_me('Atencion!!! Cheque existente... Numero' || p_cheq_nume ||
            ' Serie' || p_cheq_serie || ' Banco ' || v_banc_desc);
    else
      pl_mm('Atencion!!! Cheque existente... Numero' || p_cheq_nume ||
            ' Serie' || p_cheq_serie || ' Banco ' || v_banc_desc);
    end if;
  
  exception
    when no_data_found then
      null;
    when too_many_rows then
      if parameter.p_indi_vali_repe_cheq = 'S' then
        pl_me('Atencion!!! Cheque existente... Numero' || p_cheq_nume ||
              ' Serie' || p_cheq_serie || ' Banco ' || v_banc_desc);
      else
        pl_mm('Atencion!!! Cheque existente... Numero' || p_cheq_nume ||
              ' Serie' || p_cheq_serie || ' Banco ' || v_banc_desc);
      end if;
    
  end pp_valida_nume_cheq;

  procedure pp_validar_desc_lote(i_lote_desc      in varchar2,
                                 i_lote_prod      in number,
                                 o_lote_codi      out number,
                                 o_lote_fech_elab out date,
                                 o_lote_fech_venc out date) is
    v_count number;
  begin
    select lote_codi, lote_fech_elab, lote_fech_venc
      into o_lote_codi, o_lote_fech_elab, o_lote_fech_venc
      from come_lote l
     where l.lote_prod_codi = i_lote_prod
       and ltrim(rtrim(upper(l.lote_desc))) =
           ltrim(rtrim(upper(i_lote_desc)))
       and nvl(lote_esta, 'A') <> 'I';
  
  exception
    when no_data_found then
      o_lote_codi := null;
  end;

  procedure pp_valida_cheques is
  begin
  
    if parameter.p_indi_vali_repe_cheq = 'S' then
      if parameter.p_emit_reci = 'E' then
        --go_block('bfp');
        --first_record;
        for bfp in cur_bfp loop
          if bfp.fopa_codi = '2' then
            pp_valida_nume_cheq(bfp.cheq_nume,
                                bfp.cheq_serie,
                                bfp.cheq_banc_codi);
          end if;
        
        end loop;
      end if;
    end if;
  
    if parameter.p_emit_reci = 'R' then
      if bcab.movi_banc_codi is not null then
        for bfp in cur_bfp loop
          if bfp.fopa_codi = '4' then
            pp_valida_nume_cheq(bfp.cheq_nume,
                                bfp.cheq_serie,
                                bfp.cheq_banc_codi);
          end if;
        
        end loop;
      end if;
    end if;
  exception
    when others then
      pl_me(sqlerrm);
  end pp_valida_cheques;

  procedure pp_validar_registro_duplicado(p_indi in char) is
    v_cant_reg number; --cantidad de registros en el bloque
    i          number;
    j          number;
    salir exception;
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

  procedure pp_valida_limite_costo is
    cursor c_ortr is
      select t.ortr_codi, o.ortr_nume, sum(t.ortr_impo) impo
        from come_ortr_impo_temp t, come_orde_trab o
       where o.ortr_codi = t.ortr_codi
       group by t.ortr_codi, o.ortr_nume
       order by t.ortr_codi, o.ortr_nume;
  
    v_limi_cost number;
    v_cost_actu number;
  begin
    pack_ortr.pa_agru_ortr_temp(null, null, 'D');
    for bdet in cur_bdet
    
     loop
      if bdet.ortr_sali_mate_codi is not null then
        pack_ortr.pa_agru_ortr_temp(bdet.ortr_sali_mate_codi,
                                    bdet.deta_impo_mmnn_ii,
                                    'I');
      end if;
    
    end loop;
  
    for x in c_ortr loop
      v_limi_cost := pack_ortr.fa_dev_limi_cost(x.ortr_codi);
      v_cost_actu := pack_ortr.fa_dev_cost_ortr(x.ortr_codi);
    
      if nvl(v_cost_actu, 0) + nvl(x.impo, 0) > nvl(v_limi_cost, 0) then
        pl_me('El Costo de la OT ' || x.ortr_nume ||
              ' supera el limite de Costo');
      end if;
    end loop;
  
    pack_ortr.pa_agru_ortr_temp(null, null, 'D');
    for bdet in cur_bdet loop
      if bdet.moco_ortr_codi is not null then
        pack_ortr.pa_agru_ortr_temp(bdet.moco_ortr_codi,
                                    bdet.deta_impo_mmnn_ii,
                                    'I');
      end if;
    
    end loop;
  
    for x in c_ortr loop
      v_limi_cost := pack_ortr.fa_dev_limi_cost(x.ortr_codi);
      v_cost_actu := pack_ortr.fa_dev_cost_ortr(x.ortr_codi);
    
      if nvl(v_cost_actu, 0) + nvl(x.impo, 0) > nvl(v_limi_cost, 0) then
        pl_me('El Costo de la OT ' || x.ortr_nume ||
              ' supera el limite de Costo');
      end if;
    end loop;
  
  end pp_valida_limite_costo;

  procedure pp_validar_conceptos is
    v_indi_ot        varchar2(1) := 'n';
    v_conc           come_conc%rowtype;
    v_moco_conc_desc varchar2(200);
  begin
  
    --go_block('bdet');
    --   first_record;
    for bdet in cur_bdet loop
      begin
        select c.*
          into v_conc
          from come_conc c, come_cuen_cont cc
         where c.conc_cuco_codi = cc.cuco_codi(+)
           and conc_codi = bdet.deta_conc_codi;
      exception
        when no_data_found then
          null;
      end;
    
      --validar gastos judiciales
      if nvl(lower(v_conc.conc_indi_gast_judi), 'n') = 's' then
        if bdet.moco_juri_codi is null then
          pl_me('Debe ingresar un nro de expediente judicial para el concepto ' ||
                bdet.deta_conc_codi || ' ' || v_moco_conc_desc);
        end if;
      else
        bdet.moco_juri_codi := null;
      end if;
    
      ---validar importaciones
      if nvl(lower(bdet.conc_indi_impo), 'n') = 's' then
        if bdet.moco_impo_codi is null then
          pl_me('Debe ingresar una importacion para el concepto ' ||
                bdet.deta_conc_codi || ' ' || v_moco_conc_desc);
        end if;
      else
        bdet.moco_impo_codi := null;
        --bdet.impo_nume      := null;
      end if;
    
      --validar centro de costos
      if lower(nvl(v_conc.conc_indi_cent_cost, 'n')) = 's' then
        if bdet.moco_ceco_codi is null then
          pl_me('Debe ingresar el centro de costo');
        end if;
      else
        bdet.moco_ceco_codi := null;
        --bdet.ceco_nume      := null;
      end if;
    
      --validar orden de servicio
      -----no se valida ------
    
      --validar secciones de empresa
      if nvl(lower(parameter.p_indi_most_secc_dbcr), 'n') = 's' then
        if bdet.moco_emse_codi is null then
          pl_me('Debe ingresar la seccion de la empresa');
        end if;
      else
        bdet.moco_emse_codi := null;
      end if;
    
      --validar ot
      if nvl(lower(v_conc.conc_indi_ortr), 'n') = 's' then
        if bdet.moco_ortr_codi is null then
          pl_me('Debe ingresar el Nro de OT');
        end if;
      else
        bdet.moco_ortr_codi := null;
        --bdet.ortr_nume      := null;
      end if;
    
      ---validar gastos de veihicuos y km
      if nvl(lower(v_conc.conc_indi_kilo_vehi), 'n') <> 'n' then
        if nvl(lower(v_conc.conc_indi_kilo_vehi), 'n') in ('s', 'sg') then
          if bdet.moco_tran_codi is null then
            pl_me('Debe ingresar el codigo del vehiculo');
          end if;
        end if;
      else
        bdet.moco_tran_codi := null;
        --bdet.tran_codi_alte := null;
      end if;
    
      if bdet.moco_ortr_codi is not null then
        v_indi_ot := 's';
      end if;
      --  exit when :system.last_record = upper('true');
    --next_record;
    end loop;
  
    if lower(v_indi_ot) = 's' then
      pp_valida_limite_costo;
    end if;
  end pp_validar_conceptos;

  procedure pp_calcular_importe_cab_fp is
  begin
    bcab.s_impo_cheq      := -nvl(bfp_cab.tota_cheq_egre_movi, 0) +
                             nvl(bfp_cab.tota_cheq_ingr_movi, 0);
    bcab.s_impo_efec      := nvl(bfp_cab.tota_efec_ingr_movi, 0) -
                             nvl(bfp_cab.tota_efec_egre_movi, 0);
    bcab.s_impo_tarj      := -nvl(bfp_cab.tota_tarj_egre_movi, 0) +
                             nvl(bfp_cab.tota_tarj_ingr_movi, 0);
    bcab.s_impo_adel      := -nvl(bfp_cab.tota_adel_egre_movi, 0) +
                             nvl(bfp_cab.tota_adel_ingr_movi, 0);
    bcab.s_impo_vale      := -nvl(bfp_cab.tota_vale_egre_movi, 0) +
                             nvl(bfp_cab.tota_vale_ingr_movi, 0);
    bcab.s_impo_rete_reci := nvl(bfp_cab.tota_rete_reci_ingr_movi, 0) -
                             nvl(bfp_cab.tota_rete_reci_egre_movi, 0);
    bcab.s_impo_viaj      := nvl(bfp_cab.tota_viaj_ingr_movi, 0) -
                             nvl(bfp_cab.tota_viaj_egre_movi, 0);
  
    -- pago
    if bcab.movi_timo_codi in
       (parameter.p_codi_timo_auto_fact_emit,
        parameter.p_codi_timo_auto_fact_emit_cr) then
      if parameter.p_indi_apli_rete_exen = 'S' and
         nvl(parameter.p_clpr_indi_clie_prov, 'C') = 'P' then
        bfp_cab.s_impo_mone := nvl(bcab.movi_impo_mone_ii, 0) -
                               nvl(bcab.s_impo_rete, 0) -
                               nvl(bcab.s_impo_rete_rent, 0);
        bfp_cab.s_impo_mmnn := round((nvl(bcab.movi_impo_mone_ii, 0) -
                                     nvl(bcab.s_impo_rete, 0) -
                                     nvl(bcab.s_impo_rete_rent, 0)) *
                                     bcab.movi_tasa_mone,
                                     parameter.p_cant_deci_mmnn);
      else
        bfp_cab.s_impo_mone := nvl(bcab.movi_impo_mone_ii, 0);
        bfp_cab.s_impo_mmnn := round(nvl(bcab.movi_impo_mone_ii, 0) *
                                     bcab.movi_tasa_mone,
                                     parameter.p_cant_deci_mmnn);
      end if;
    else
      bfp_cab.s_impo_mone := nvl(bcab.movi_impo_mone_ii, 0) -
                             nvl(bcab.s_impo_rete, 0) -
                             nvl(bcab.s_impo_rete_rent, 0);
      bfp_cab.s_impo_mmnn := round(((nvl(bcab.movi_impo_mone_ii, 0) -
                                   nvl(bcab.s_impo_rete, 0) -
                                   nvl(bcab.s_impo_rete_rent, 0)) *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    end if;
  end pp_calcular_importe_cab_fp;

  procedure pp_ajustar_importes_lote is
  
    v_movi_impo_mmnn_ii       number := 0;
    v_sum_moco_impo_mmnn_ii   number := 0;
    v_movi_exen_mmnn          number := 0;
    v_sum_moco_exen_mmnn      number := 0;
    v_movi_grav10_ii_mmnn     number := 0;
    v_sum_moco_grav10_ii_mmnn number := 0;
    v_movi_grav5_ii_mmnn      number := 0;
    v_sum_moco_grav5_ii_mmnn  number := 0;
    v_movi_iva10_mmnn         number := 0;
    v_sum_moco_iva10_mmnn     number := 0;
    v_movi_iva5_mmnn          number := 0;
    v_sum_moco_iva5_mmnn      number := 0;
    v_movi_grav10_mmnn        number := 0;
    v_sum_moco_grav10_mmnn    number := 0;
    v_movi_grav5_mmnn         number := 0;
    v_sum_moco_grav5_mmnn     number := 0;
    v_movi_exen_mone          number := 0;
    v_sum_moco_exen_mone      number := 0;
    v_movi_grav10_ii_mone     number := 0;
    v_sum_moco_grav10_ii_mone number := 0;
    v_movi_grav5_ii_mone      number := 0;
    v_sum_moco_grav5_ii_mone  number := 0;
    v_movi_iva10_mone         number := 0;
    v_sum_moco_iva10_mone     number := 0;
    v_movi_iva5_mone          number := 0;
    v_sum_moco_iva5_mone      number := 0;
    v_movi_grav10_mone        number := 0;
    v_sum_moco_grav10_mone    number := 0;
    v_movi_grav5_mone         number := 0;
    v_sum_moco_grav5_mone     number := 0;
  
    v_item_mayor number;
    v_impo_mayor number;
  
    cursor c_lote is
      select telo_lote_desc,
             telo_codi,
             telo_deta_impo_mone_ii,
             telo_deta_impo_mmnn_ii
        from come_lote_temp
       where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp;
  
    cursor c_lote_sum is
      select sum(telo_deta_impo_mone_ii) sum_deta_impo_mone_ii,
             sum(telo_deta_impo_mmnn_ii) sum_deta_impo_mmnn_ii,
             sum(telo_deta_grav10_ii_mone) sum_deta_grav10_ii_mone,
             sum(telo_deta_grav5_ii_mone) sum_deta_grav5_ii_mone,
             sum(telo_deta_grav10_ii_mmnn) sum_deta_grav10_ii_mmnn,
             sum(telo_deta_grav5_ii_mmnn) sum_deta_grav5_ii_mmnn,
             sum(telo_deta_grav10_mone) sum_deta_grav10_mone,
             sum(telo_deta_grav5_mone) sum_deta_grav5_mone,
             sum(telo_deta_grav10_mmnn) sum_deta_grav10_mmnn,
             sum(telo_deta_grav5_mmnn) sum_deta_grav5_mmnn,
             sum(telo_deta_iva10_mone) sum_deta_iva10_mone,
             sum(telo_deta_iva5_mone) sum_deta_iva5_mone,
             sum(telo_deta_iva10_mmnn) sum_deta_iva10_mmnn,
             sum(telo_deta_iva5_mmnn) sum_deta_iva5_mmnn,
             sum(telo_deta_exen_mone) sum_deta_exen_mone,
             sum(telo_deta_exen_mmnn) sum_deta_exen_mmnn,
             sum(telo_deta_impo_mone) sum_deta_impo_mone,
             sum(telo_deta_impo_mmnn) sum_deta_impo_mmnn
        from come_lote_temp
       where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp;
  
  begin
    v_impo_mayor := 0;
    v_item_mayor := 1;
  
    for x in c_lote loop
      if x.telo_deta_impo_mone_ii > v_impo_mayor then
        v_impo_mayor := x.telo_deta_impo_mone_ii;
        v_item_mayor := x.telo_codi;
      end if;
    end loop;
  
    -----
    pp_calcular_importe_cab;
    pp_calcular_importe_cab_fp;
  
    for x in c_lote_sum loop
      v_movi_exen_mone     := bcab.movi_exen_mone;
      v_sum_moco_exen_mone := x.sum_deta_exen_mone;
    
      if v_movi_exen_mone <> v_sum_moco_exen_mone then
        update come_lote_temp
           set telo_deta_exen_mone = telo_deta_exen_mone +
                                     (v_movi_exen_mone -
                                     v_sum_moco_exen_mone)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_grav10_ii_mone     := bcab.movi_grav10_ii_mone;
      v_sum_moco_grav10_ii_mone := x.sum_deta_grav10_ii_mone;
      if v_movi_grav10_ii_mone <> v_sum_moco_grav10_ii_mone then
        update come_lote_temp
           set telo_deta_grav10_ii_mone = telo_deta_grav10_ii_mone +
                                          (v_movi_grav10_ii_mone -
                                          v_sum_moco_grav10_ii_mone)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_grav5_ii_mone     := bcab.movi_grav5_ii_mone;
      v_sum_moco_grav5_ii_mone := x.sum_deta_grav5_ii_mone;
      if v_movi_grav5_ii_mone <> v_sum_moco_grav5_ii_mone then
        update come_lote_temp
           set telo_deta_grav5_ii_mone = telo_deta_grav5_ii_mone +
                                         (v_movi_grav5_ii_mone -
                                         v_sum_moco_grav5_ii_mone)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_iva10_mone     := bcab.movi_iva10_mone;
      v_sum_moco_iva10_mone := x.sum_deta_iva10_mone;
      if v_movi_iva10_mone <> v_sum_moco_iva10_mone then
        update come_lote_temp
           set telo_deta_iva10_mone = telo_deta_iva10_mone +
                                      (v_movi_iva10_mone -
                                      v_sum_moco_iva10_mone)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_iva5_mone     := bcab.movi_iva5_mone;
      v_sum_moco_iva5_mone := x.sum_deta_iva5_mone;
      if v_movi_iva5_mone <> v_sum_moco_iva5_mone then
        update come_lote_temp
           set telo_deta_iva5_mone = telo_deta_iva5_mone +
                                     (v_movi_iva5_mone -
                                     v_sum_moco_iva5_mone)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_grav10_mone     := bcab.movi_grav10_mone;
      v_sum_moco_grav10_mone := x.sum_deta_grav10_mone;
      if v_movi_grav10_mone <> v_sum_moco_grav10_mone then
        update come_lote_temp
           set telo_deta_grav10_mone = telo_deta_grav10_mone +
                                       (v_movi_grav10_mone -
                                       v_sum_moco_grav10_mone)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_grav5_mone     := bcab.movi_grav5_mone;
      v_sum_moco_grav5_mone := x.sum_deta_grav5_mone;
      if v_movi_grav5_mone <> v_sum_moco_grav5_mone then
        update come_lote_temp
           set telo_deta_grav5_mone = telo_deta_grav5_mone +
                                      (v_movi_grav5_mone -
                                      v_sum_moco_grav5_mone)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_impo_mmnn_ii     := bcab.movi_impo_mmnn_ii;
      v_sum_moco_impo_mmnn_ii := x.sum_deta_impo_mmnn_ii;
      if v_movi_impo_mmnn_ii <> v_sum_moco_impo_mmnn_ii then
        update come_lote_temp
           set telo_deta_impo_mmnn_ii = telo_deta_impo_mmnn_ii +
                                        (v_movi_impo_mmnn_ii -
                                        v_sum_moco_impo_mmnn_ii)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_exen_mmnn     := bcab.movi_exen_mmnn;
      v_sum_moco_exen_mmnn := x.sum_deta_exen_mmnn;
      if v_movi_exen_mmnn <> v_sum_moco_exen_mmnn then
        update come_lote_temp
           set telo_deta_exen_mmnn = telo_deta_exen_mmnn +
                                     (v_movi_exen_mmnn -
                                     v_sum_moco_exen_mmnn)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_grav10_ii_mmnn     := bcab.movi_grav10_ii_mmnn;
      v_sum_moco_grav10_ii_mmnn := x.sum_deta_grav10_ii_mmnn;
      if v_movi_grav10_ii_mmnn <> v_sum_moco_grav10_ii_mmnn then
        update come_lote_temp
           set telo_deta_grav10_ii_mmnn = telo_deta_grav10_ii_mmnn +
                                          (v_movi_grav10_ii_mmnn -
                                          v_sum_moco_grav10_ii_mmnn)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_grav5_ii_mmnn     := bcab.movi_grav5_ii_mmnn;
      v_sum_moco_grav5_ii_mmnn := x.sum_deta_grav5_ii_mmnn;
      if v_movi_grav5_ii_mmnn <> v_sum_moco_grav5_ii_mmnn then
        update come_lote_temp
           set telo_deta_grav5_ii_mmnn = telo_deta_grav5_ii_mmnn +
                                         (v_movi_grav5_ii_mmnn -
                                         v_sum_moco_grav5_ii_mmnn)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_iva10_mmnn     := bcab.movi_iva10_mmnn;
      v_sum_moco_iva10_mmnn := x.sum_deta_iva10_mmnn;
      if v_movi_iva10_mmnn <> v_sum_moco_iva10_mmnn then
        update come_lote_temp
           set telo_deta_iva10_mmnn = telo_deta_iva10_mmnn +
                                      (v_movi_iva10_mmnn -
                                      v_sum_moco_iva10_mmnn)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_iva5_mmnn     := bcab.movi_iva5_mmnn;
      v_sum_moco_iva5_mmnn := x.sum_deta_iva5_mmnn;
      if v_movi_iva5_mmnn <> v_sum_moco_iva5_mmnn then
        update come_lote_temp
           set telo_deta_iva5_mmnn = telo_deta_iva5_mmnn +
                                     (v_movi_iva5_mmnn -
                                     v_sum_moco_iva5_mmnn)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_grav10_mmnn     := bcab.movi_grav10_mmnn;
      v_sum_moco_grav10_mmnn := x.sum_deta_grav10_mmnn;
      if v_movi_grav10_mmnn <> v_sum_moco_grav10_mmnn then
        update come_lote_temp
           set telo_deta_grav10_mmnn = telo_deta_grav10_mmnn +
                                       (v_movi_grav10_mmnn -
                                       v_sum_moco_grav10_mmnn)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      v_movi_grav5_mmnn     := bcab.movi_grav5_mmnn;
      v_sum_moco_grav5_mmnn := x.sum_deta_grav5_mmnn;
      if v_movi_grav5_mmnn <> v_sum_moco_grav5_mmnn then
        update come_lote_temp
           set telo_deta_grav5_mmnn = telo_deta_grav5_mmnn +
                                      (v_movi_grav5_mmnn -
                                      v_sum_moco_grav5_mmnn)
         where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
           and telo_codi = v_item_mayor;
      end if;
    
      update come_lote_temp
         set telo_deta_impo_mmnn = telo_deta_exen_mmnn +
                                   telo_deta_grav10_mmnn +
                                   telo_deta_grav5_mmnn,
             telo_deta_impo_mone = telo_deta_exen_mone +
                                   telo_deta_grav10_mone +
                                   telo_deta_grav5_mone
       where telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
         and telo_codi = v_item_mayor;
    end loop;
  end pp_ajustar_importes_lote;

  procedure pp_valida_fech(p_fech in date) is
  begin
    if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
      pl_me('La fecha del movimiento debe estar comprendida entre..' ||
            to_char(parameter.p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
            to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
    end if;
  
  exception
  
    when others then
      pl_me(sqlerrm);
    
  end pp_valida_fech;

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
                                p_movi_impo_reca           in number,
                                p_movi_excl_cont           in varchar2,
                                p_movi_impo_deto           in number,
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
                                p_movi_indi_cons           in varchar2) is
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
       movi_impo_reca,
       movi_excl_cont,
       movi_impo_deto,
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
       movi_indi_cons)
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
       p_movi_impo_reca,
       p_movi_excl_cont,
       p_movi_impo_deto,
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
       p_movi_indi_cons);
  
  exception
    when others then
      pl_me(sqlerrm);
  end pp_insert_come_movi;

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
    v_movi_clpr_desc           varchar2(120);
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
  
    v_movi_impo_reca number;
    v_movi_impo_deto number;
  
    v_movi_indi_cons varchar2(1);
  
  begin
  
    --- asignar valores....
    bcab.movi_codi      := fa_sec_come_movi;
    bcab.movi_fech_grab := sysdate;
    bcab.movi_user      := g_user;
  
    v_movi_codi           := bcab.movi_codi;
    v_movi_timo_codi      := bcab.movi_timo_codi;
    v_movi_clpr_codi      := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig := bcab.movi_depo_codi_orig;
    v_movi_sucu_codi_dest := null;
    v_movi_depo_codi_dest := null;
    v_movi_oper_codi      := bcab.movi_oper_codi;
    v_movi_cuen_codi      := null;
    v_movi_mone_codi      := bcab.movi_mone_codi;
    v_movi_nume           := bcab.movi_nume;
    v_movi_fech_emis      := bcab.movi_fech_emis;
    v_movi_fech_grab      := bcab.movi_fech_grab;
    v_movi_user           := bcab.movi_user;
    v_movi_codi_padr      := null;
    v_movi_tasa_mone      := bcab.movi_tasa_mone;
    v_movi_tasa_mmee      := bcab.movi_tasa_mmee;
  
    v_movi_grav_mmnn := bcab.movi_grav_mmnn;
    v_movi_exen_mmnn := bcab.movi_exen_mmnn;
    v_movi_iva_mmnn  := bcab.movi_iva_mmnn;
  
    v_movi_grav_mmee := round(bcab.movi_grav_mmee,
                              parameter.p_cant_deci_mmee);
    v_movi_exen_mmee := round(bcab.movi_exen_mmnn,
                              parameter.p_cant_deci_mmee);
    v_movi_iva_mmee  := round(bcab.movi_iva_mmnn,
                              parameter.p_cant_deci_mmee);
  
    v_movi_grav_mone := bcab.movi_grav_mone;
    v_movi_exen_mone := bcab.movi_exen_mone;
    v_movi_iva_mone  := bcab.movi_iva_mone;
  
    v_movi_obse := bcab.movi_obse;
  
    v_movi_sald_mmnn           := bcab.movi_sald_mmnn;
    v_movi_sald_mmee           := bcab.movi_sald_mmee;
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
    v_movi_empl_codi           := null;
    v_movi_nume_timb           := bcab.movi_nume_timb;
    v_movi_fech_venc_timb      := bcab.fech_venc_timb;
    v_movi_fech_oper           := bcab.movi_fech_oper;
  
    v_movi_impo_reca := nvl(bcab.impo_reca_mone, 0);
    v_movi_impo_deto := nvl(bcab.impo_deto_mone, 0);
  
    v_movi_impo_mone_ii := bcab.movi_impo_mone_ii;
    v_movi_impo_mmnn_ii := bcab.movi_impo_mmnn_ii;
  
    v_movi_grav10_ii_mone := bcab.movi_grav10_ii_mone;
    v_movi_grav5_ii_mone  := bcab.movi_grav5_ii_mone;
  
    v_movi_grav10_ii_mmnn := bcab.movi_grav10_ii_mmnn;
    v_movi_grav5_ii_mmnn  := bcab.movi_grav5_ii_mmnn;
  
    v_movi_grav10_mone := bcab.movi_grav10_mone;
    v_movi_grav5_mone  := bcab.movi_grav5_mone;
    v_movi_grav10_mmnn := bcab.movi_grav10_mmnn;
    v_movi_grav5_mmnn  := bcab.movi_grav5_mmnn;
    v_movi_iva10_mone  := bcab.movi_iva10_mone;
    v_movi_iva5_mone   := bcab.movi_iva5_mone;
    v_movi_iva10_mmnn  := bcab.movi_iva10_mmnn;
    v_movi_iva5_mmnn   := bcab.movi_iva5_mmnn;
  
    v_movi_indi_cons := bcab.movi_indi_cons;
  
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
                        v_movi_impo_reca,
                        v_movi_excl_cont,
                        v_movi_impo_deto,
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
                        v_movi_indi_cons);
  end pp_actualiza_come_movi;

  procedure pp_insert_come_movi_soli(p_movi_codi                in number,
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
                                     p_movi_ortr_codi           in number) is
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
       movi_ortr_codi,
       
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
       p_movi_ortr_codi,
       
       parameter.p_codi_base);
  
  end pp_insert_come_movi_soli;

  procedure pp_insert_movi_prod_deta_soli(p_deta_movi_codi         in number,
                                          p_deta_nume_item         in number,
                                          p_deta_impu_codi         in number,
                                          p_deta_prod_codi         in number,
                                          p_deta_cant              in number,
                                          p_deta_obse              in varchar2,
                                          p_deta_porc_deto         in number,
                                          p_deta_impo_mone         in number,
                                          p_deta_impo_mmnn         in number,
                                          p_deta_impo_mmee         in number,
                                          p_deta_iva_mmnn          in number,
                                          p_deta_iva_mmee          in number,
                                          p_deta_iva_mone          in number,
                                          p_deta_prec_unit         in number,
                                          p_deta_movi_codi_padr    in number,
                                          p_deta_nume_item_padr    in number,
                                          p_deta_impo_mone_deto_nc in number,
                                          p_deta_movi_codi_deto_nc in number,
                                          p_deta_list_codi         in number,
                                          p_deta_lote_codi         in number,
                                          p_deta_bien_codi         in number) is
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
       deta_bien_codi,
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
       p_deta_bien_codi,
       parameter.p_codi_base);
  
  end pp_insert_movi_prod_deta_soli;

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
       parameter.p_codi_base);
  
  end pp_insert_come_movi_cuot;

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
  
  end pp_insert_come_movi_impu_deta;

  procedure pp_actu_soli_mate(p_deta_prod_codi in number,
                              p_deta_lote_codi in number,
                              p_deta_cant      in number,
                              p_deta_impo_mone in number,
                              p_deta_impo_mmnn in number,
                              p_deta_impo_mmee in number,
                              p_deta_ortr_codi in number,
                              p_deta_prec_unit in number,
                              p_movi_codi_fact in number) is
  
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
    v_movi_clpr_desc           varchar2(120);
    v_movi_emit_reci           varchar2(1);
    v_movi_afec_sald           varchar2(1);
    v_movi_dbcr                varchar2(1);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_empr_codi           number;
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           number;
    v_movi_ortr_codi           number;
  
    v_deta_movi_codi         number;
    v_deta_nume_item         number;
    v_deta_impu_codi         number;
    v_deta_prod_codi         number;
    v_deta_cant              number;
    v_deta_obse              varchar2(2000);
    v_deta_porc_deto         number;
    v_deta_impo_mone         number;
    v_deta_impo_mmnn         number;
    v_deta_impo_mmee         number;
    v_deta_iva_mmnn          number;
    v_deta_iva_mmee          number;
    v_deta_iva_mone          number;
    v_deta_prec_unit         number;
    v_deta_movi_codi_padr    number;
    v_deta_nume_item_padr    number;
    v_deta_impo_mone_deto_nc number;
    v_deta_movi_codi_deto_nc number;
    v_deta_list_codi         number;
    v_deta_lote_codi         number;
    v_deta_bien_codi         number;
  begin
  
    v_movi_codi                := fa_sec_come_movi;
    v_movi_timo_codi           := null;
    v_movi_clpr_codi           := null;
    v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig      := bcab.movi_depo_codi_orig;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := parameter.p_codi_oper_sprod;
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := null;
    v_movi_nume                := bcab.movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := sysdate;
    v_movi_user                := g_user;
    v_movi_codi_padr           := p_movi_codi_fact;
    v_movi_tasa_mone           := 1; --tasa mmnn
    v_movi_tasa_mmee           := bcab.movi_tasa_mmee;
    v_movi_grav_mmnn           := null;
    v_movi_exen_mmnn           := null;
    v_movi_iva_mmnn            := null;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := null;
    v_movi_exen_mone           := null;
    v_movi_iva_mone            := null;
    v_movi_obse                := 'Salida por Compra nro' || bcab.movi_nume;
    v_movi_sald_mmnn           := null;
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := null;
    v_movi_stoc_suma_rest      := 'R';
    v_movi_clpr_dire           := bcab.movi_clpr_dire;
    v_movi_clpr_tele           := bcab.movi_clpr_tele;
    v_movi_clpr_ruc            := bcab.movi_clpr_ruc;
    v_movi_clpr_desc           := bcab.movi_clpr_desc;
    v_movi_emit_reci           := null;
    v_movi_afec_sald           := null;
    v_movi_dbcr                := null;
    v_movi_stoc_afec_cost_prom := 'N';
    v_movi_empr_codi           := null;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := null;
    v_movi_ortr_codi           := p_deta_ortr_codi;
  
    pp_insert_come_movi_soli(v_movi_codi,
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
                             v_movi_ortr_codi);
  
    v_deta_movi_codi := v_movi_codi;
  
    v_deta_nume_item         := 1;
    v_deta_impu_codi         := 1; --exento
    v_deta_prod_codi         := p_deta_prod_codi;
    v_deta_cant              := p_deta_cant;
    v_deta_obse              := null;
    v_deta_porc_deto         := null;
    v_deta_impo_mone         := p_deta_impo_mone;
    v_deta_impo_mmnn         := p_deta_impo_mmnn;
    v_deta_impo_mmee         := p_deta_impo_mmee;
    v_deta_iva_mmnn          := 0;
    v_deta_iva_mmee          := 0;
    v_deta_iva_mone          := 0;
    v_deta_prec_unit         := p_deta_prec_unit;
    v_deta_movi_codi_padr    := null;
    v_deta_nume_item_padr    := null;
    v_deta_impo_mone_deto_nc := null;
    v_deta_movi_codi_deto_nc := null;
    v_deta_list_codi         := null;
    v_deta_lote_codi         := p_deta_lote_codi;
  
    pp_insert_movi_prod_deta_soli(v_deta_movi_codi,
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
                                  v_deta_bien_codi);
  
  end pp_actu_soli_mate;

  procedure pp_genera_codi_lote(p_codi in out number) is
  begin
    select nvl(max(lote_codi), 0) + 1 into p_codi from come_lote;
  end pp_genera_codi_lote;

  procedure pp_insertar_lote(p_lote_codi      in out number,
                             p_lote_prod_codi in number,
                             p_lote_desc      in varchar2,
                             p_lote_codi_barr in varchar2,
                             p_lote_fech_elab in date,
                             p_lote_fech_venc in date) is
  
    v_lote_codi           number(10);
    v_lote_desc           varchar2(60);
    v_lote_codi_barr      varchar2(60);
    v_lote_prod_codi      number(20);
    v_lote_fech_elab      date;
    v_lote_fech_venc      date;
    v_lote_esta           varchar2(1);
    v_lote_base           number(2);
    v_lote_obse           varchar2(200);
    v_lote_prec_unit      number(20, 4);
    v_lote_cost_prom_mmnn number(20, 4);
    v_lote_obse_etiq      varchar2(100);
    v_lote_medi_larg      number(20, 4);
    v_lote_user_regi      varchar2(20);
    v_lote_fech_regi      date;
    v_lote_user_modi      varchar2(20);
    v_lote_fech_modi      date;
    v_lote_empr_codi      number(10);
    v_lote_codi_auxi      number(10);
    v_lote_tibo_codi      number(10);
    v_lote_desc_abre      varchar2(60);
    v_lote_tele           varchar2(20);
    v_lote_id             varchar2(60);
  
  begin
    --generar el max codigo de lote
    select nvl(max(lote_codi), 0) + 1 into v_lote_codi from come_lote;
  
    p_lote_codi := v_lote_codi;
  
    v_lote_desc           := p_lote_desc;
    v_lote_codi_barr      := p_lote_codi_barr;
    v_lote_prod_codi      := p_lote_prod_codi;
    v_lote_fech_elab      := p_lote_fech_elab;
    v_lote_fech_venc      := p_lote_fech_venc;
    v_lote_esta           := 'A';
    v_lote_base           := parameter.p_codi_base;
    v_lote_obse           := null;
    v_lote_prec_unit      := null;
    v_lote_cost_prom_mmnn := null;
    v_lote_obse_etiq      := null;
    v_lote_medi_larg      := null;
    v_lote_user_regi      := g_user;
    v_lote_fech_regi      := sysdate;
    v_lote_user_modi      := null;
    v_lote_fech_modi      := null;
    v_lote_empr_codi      := parameter.p_empr_codi;
    v_lote_codi_auxi      := null;
    v_lote_tibo_codi      := null;
    v_lote_desc_abre      := null;
    v_lote_tele           := null; --bdet.lote_tele;
    v_lote_id             := null; --bdet.lote_id;
  
    insert into come_lote
      (lote_codi,
       lote_desc,
       lote_codi_barr,
       lote_prod_codi,
       lote_fech_elab,
       lote_fech_venc,
       lote_esta,
       lote_base,
       lote_obse,
       lote_prec_unit,
       lote_cost_prom_mmnn,
       lote_obse_etiq,
       lote_medi_larg,
       lote_user_regi,
       lote_fech_regi,
       lote_user_modi,
       lote_fech_modi,
       lote_empr_codi,
       lote_codi_auxi,
       lote_tibo_codi,
       lote_desc_abre,
       lote_tele,
       lote_id)
    values
      (v_lote_codi,
       v_lote_desc,
       v_lote_codi_barr,
       v_lote_prod_codi,
       v_lote_fech_elab,
       v_lote_fech_venc,
       v_lote_esta,
       v_lote_base,
       v_lote_obse,
       v_lote_prec_unit,
       v_lote_cost_prom_mmnn,
       v_lote_obse_etiq,
       v_lote_medi_larg,
       v_lote_user_regi,
       v_lote_fech_regi,
       v_lote_user_modi,
       v_lote_fech_modi,
       v_lote_empr_codi,
       v_lote_codi_auxi,
       v_lote_tibo_codi,
       v_lote_desc_abre,
       v_lote_tele,
       v_lote_id);
  
  end pp_insertar_lote;

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
                                     p_moco_tipo           in varchar,
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
                                     p_moco_juri_codi      in number) is
  
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
       moco_juri_codi)
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
       p_moco_juri_codi);
  
  end pp_insert_movi_conc_deta;

  procedure pp_insert_come_movi_prod_deta(p_deta_movi_codi         in number,
                                          p_deta_nume_item         in number,
                                          p_deta_impu_codi         in number,
                                          p_deta_prod_codi         in number,
                                          p_deta_cant              in number,
                                          p_deta_obse              in varchar2,
                                          p_deta_porc_deto         in number,
                                          p_deta_impo_mone         in number,
                                          p_deta_impo_mmnn         in number,
                                          p_deta_impo_mmee         in number,
                                          p_deta_iva_mmnn          in number,
                                          p_deta_iva_mmee          in number,
                                          p_deta_iva_mone          in number,
                                          p_deta_prec_unit         in number,
                                          p_deta_movi_codi_padr    in number,
                                          p_deta_nume_item_padr    in number,
                                          p_deta_impo_mone_deto_nc in number,
                                          p_deta_movi_codi_deto_nc in number,
                                          p_deta_list_codi         in number,
                                          p_deta_movi_clave_orig   in number,
                                          p_deta_impo_mmnn_deto_nc in number,
                                          p_deta_base              in number,
                                          p_deta_lote_codi         in number,
                                          p_deta_movi_orig_codi    in number,
                                          p_deta_movi_orig_item    in number,
                                          p_deta_impo_mmee_deto_nc in number,
                                          p_deta_asie_codi         in number,
                                          p_deta_cant_medi         in number,
                                          p_deta_medi_codi         in number,
                                          p_deta_remi_codi         in number,
                                          p_deta_remi_nume_item    in number,
                                          p_deta_bien_codi         in number,
                                          p_deta_prec_unit_list    in number,
                                          p_deta_impo_deto_mone    in number,
                                          p_deta_porc_deto_prec    in number,
                                          p_deta_ceco_codi         in number,
                                          p_deta_clpr_codi         in number,
                                          p_deta_bene_codi         in number,
                                          p_deta_impo_mone_ii      in number,
                                          p_deta_impo_mmnn_ii      in number,
                                          p_deta_grav10_ii_mone    in number,
                                          p_deta_grav5_ii_mone     in number,
                                          p_deta_grav10_ii_mmnn    in number,
                                          p_deta_grav5_ii_mmnn     in number,
                                          p_deta_grav10_mone       in number,
                                          p_deta_grav5_mone        in number,
                                          p_deta_grav10_mmnn       in number,
                                          p_deta_grav5_mmnn        in number,
                                          p_deta_iva10_mone        in number,
                                          p_deta_iva5_mone         in number,
                                          p_deta_iva10_mmnn        in number,
                                          p_deta_iva5_mmnn         in number,
                                          p_deta_exen_mone         in number,
                                          p_deta_exen_mmnn         in number,
                                          p_deta_emse_codi         in number,
                                          p_deta_prod_codi_barr    in varchar2,
                                          p_deta_coba_codi         in number
                                          
                                          ) is
  
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
       deta_movi_clave_orig,
       deta_impo_mmnn_deto_nc,
       deta_base,
       deta_lote_codi,
       deta_movi_orig_codi,
       deta_movi_orig_item,
       deta_impo_mmee_deto_nc,
       deta_asie_codi,
       deta_cant_medi,
       deta_medi_codi,
       deta_remi_codi,
       deta_remi_nume_item,
       deta_bien_codi,
       deta_prec_unit_list,
       deta_impo_deto_mone,
       deta_porc_deto_prec,
       deta_ceco_codi,
       deta_clpr_codi,
       deta_bene_codi,
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
       deta_emse_codi,
       deta_prod_codi_barr
       
       )
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
       p_deta_movi_clave_orig,
       p_deta_impo_mmnn_deto_nc,
       p_deta_base,
       p_deta_lote_codi,
       p_deta_movi_orig_codi,
       p_deta_movi_orig_item,
       p_deta_impo_mmee_deto_nc,
       p_deta_asie_codi,
       p_deta_cant_medi,
       p_deta_medi_codi,
       p_deta_remi_codi,
       p_deta_remi_nume_item,
       p_deta_bien_codi,
       p_deta_prec_unit_list,
       p_deta_impo_deto_mone,
       p_deta_porc_deto_prec,
       p_deta_ceco_codi,
       p_deta_clpr_codi,
       p_deta_bene_codi,
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
       p_deta_emse_codi,
       p_deta_prod_codi_barr);
  end pp_insert_come_movi_prod_deta;

  procedure pp_insert_come_movi_gast_tran(p_gatr_movi_codi in number,
                                          p_gatr_tran_codi in number,
                                          p_gatr_litr_carg in number,
                                          p_gatr_kilo_actu in number) is
  begin
  
    insert into come_movi_gast_tran
      (gatr_movi_codi, gatr_tran_codi, gatr_litr_carg, gatr_kilo_actu)
    values
      (p_gatr_movi_codi,
       p_gatr_tran_codi,
       p_gatr_litr_carg,
       p_gatr_kilo_actu);
  
  end pp_insert_come_movi_gast_tran;

  procedure pp_actualiza_gast_vehi(i_bdet in cur_bdet%rowtype) is
    v_gatr_movi_codi number;
    v_gatr_tran_codi number;
    v_gatr_litr_carg number;
    v_gatr_kilo_actu number;
  
  begin
    if nvl(i_bdet.conc_indi_kilo_vehi, 'N') in ('S', 'M') then
      if i_bdet.moco_tran_codi is not null then
        v_gatr_movi_codi := bcab.movi_codi;
        v_gatr_tran_codi := i_bdet.moco_tran_codi;
        v_gatr_litr_carg := i_bdet.gatr_litr_carg;
        v_gatr_kilo_actu := i_bdet.gatr_kilo_actu;
      
        pp_insert_come_movi_gast_tran(v_gatr_movi_codi,
                                      v_gatr_tran_codi,
                                      v_gatr_litr_carg,
                                      v_gatr_kilo_actu);
      end if;
    end if;
  
  end pp_actualiza_gast_vehi;

  procedure pp_actualiza_come_movi_prod is
    --come_movi_prod_deta
    v_deta_movi_codi         number(20);
    v_deta_nume_item         number(5);
    v_deta_impu_codi         number(10);
    v_deta_prod_codi         number(20);
    v_deta_cant              number(20, 4);
    v_deta_obse              varchar2(2000);
    v_deta_porc_deto         number(20, 6);
    v_deta_impo_mone         number(20, 4);
    v_deta_impo_mmnn         number(20, 4);
    v_deta_impo_mmee         number(20, 4);
    v_deta_iva_mmnn          number(20, 4);
    v_deta_iva_mmee          number(20, 4);
    v_deta_iva_mone          number(20, 4);
    v_deta_prec_unit         number(20, 4);
    v_deta_movi_codi_padr    number(20);
    v_deta_nume_item_padr    number(5);
    v_deta_impo_mone_deto_nc number(20, 4);
    v_deta_movi_codi_deto_nc number(20);
    v_deta_list_codi         number(4);
    v_deta_movi_clave_orig   number(20);
    v_deta_impo_mmnn_deto_nc number(20, 4);
    v_deta_base              number(2);
    v_deta_lote_codi         number(10);
    v_deta_movi_orig_codi    number(20);
    v_deta_movi_orig_item    number(4);
    v_deta_impo_mmee_deto_nc number(20, 4);
    v_deta_asie_codi         number(10);
    v_deta_cant_medi         number(20, 4);
    v_deta_medi_codi         number(10);
    v_deta_remi_codi         number(20);
    v_deta_remi_nume_item    number(5);
    v_deta_bien_codi         number(20);
    v_deta_prec_unit_list    number(20, 4);
    v_deta_impo_deto_mone    number(20, 4);
    v_deta_porc_deto_prec    number(20, 6);
    v_deta_ceco_codi         number(20);
    v_deta_clpr_codi         number(20);
    v_deta_bene_codi         number(4);
    v_deta_impo_mone_ii      number(20, 4);
    v_deta_impo_mmnn_ii      number(20, 4);
    v_deta_grav10_ii_mone    number(20, 4);
    v_deta_grav5_ii_mone     number(20, 4);
    v_deta_grav10_ii_mmnn    number(20, 4);
    v_deta_grav5_ii_mmnn     number(20, 4);
    v_deta_grav10_mone       number(20, 4);
    v_deta_grav5_mone        number(20, 4);
    v_deta_grav10_mmnn       number(20, 4);
    v_deta_grav5_mmnn        number(20, 4);
    v_deta_iva10_mone        number(20, 4);
    v_deta_iva5_mone         number(20, 4);
    v_deta_iva10_mmnn        number(20, 4);
    v_deta_iva5_mmnn         number(20, 4);
    v_deta_exen_mone         number(20, 4);
    v_deta_exen_mmnn         number(20, 4);
    v_deta_emse_codi         number;
  
    v_deta_coba_codi      number(10);
    v_deta_prod_codi_barr varchar2(40);
  
    --come_movi_conc_deta
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
    v_moco_cant           number(20, 4);
    v_moco_cant_pulg      number(20, 4);
    v_moco_ortr_codi      number(20);
    v_moco_movi_codi_padr number(20);
    v_moco_nume_item_padr number(10);
    v_moco_impo_codi      number(20);
    v_moco_ceco_codi      number(20);
    v_moco_orse_codi      number(20);
    v_moco_bien_codi      number(20);
    v_moco_tipo_item      varchar2(2);
    v_moco_clpr_codi      number(20);
    v_moco_prod_nume_item number(20);
    v_moco_tran_codi      number(20);
    v_moco_guia_nume      number(20);
    v_moco_emse_codi      number(4);
    v_moco_impo_mmnn_ii   number(20, 4);
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
    v_moco_sofa_sose_codi number(20);
    v_moco_sofa_nume_item number(20);
    v_moco_exen_mone      number(20, 4);
    v_moco_exen_mmnn      number(20, 4);
    v_moco_empl_codi      number(10);
    v_moco_medi_codi      number(10);
    v_moco_lote_codi      number(10);
    v_moco_cant_medi      number(20, 4);
    v_moco_bene_codi      number(4);
    v_moco_anex_codi      number(20);
    v_moco_juri_codi      number;
  
    cursor c_lote(p_prod_codi in number, p_nume_item_codi in number) is
      select telo_prod_codi,
             --telo_indi_ortr,
             telo_item_nume,
             telo_item_nume_codi,
             telo_selo_desc,
             telo_selo_nume,
             telo_fech_elab,
             telo_fech_venc,
             telo_cant_medi,
             telo_user_regi,
             telo_lote_desc,
             telo_lote_codi_barr,
             telo_lote_codi,
             telo_indi_auto_manu,
             telo_deta_impo_mone_ii,
             telo_deta_impo_mmnn_ii,
             telo_deta_grav10_ii_mone,
             telo_deta_grav5_ii_mone,
             telo_deta_grav10_ii_mmnn,
             telo_deta_grav5_ii_mmnn,
             telo_deta_grav10_mone,
             telo_deta_grav5_mone,
             telo_deta_grav10_mmnn,
             telo_deta_grav5_mmnn,
             telo_deta_iva10_mone,
             telo_deta_iva5_mone,
             telo_deta_iva10_mmnn,
             telo_deta_iva5_mmnn,
             telo_deta_exen_mone,
             telo_deta_exen_mmnn,
             telo_deta_impo_mone,
             telo_deta_impo_mmnn
        from come_lote_temp
       where telo_prod_codi = p_prod_codi
            --and telo_indi_ortr = p_indi_ortr
         and telo_item_nume_codi = p_nume_item_codi
         and telo_sesi_user_comp = parameter.p_secu_sesi_user_comp
       order by telo_item_nume_codi, telo_codi;
    -----------------------------------
  begin
    v_deta_movi_codi := bcab.movi_codi;
    v_deta_nume_item := 0;
    v_moco_movi_codi := bcab.movi_codi;
    v_moco_nume_item := 0;
  
    for bdet in cur_bdet loop
      if bdet.indi_prod_gast = 'P' then
        --if nvl(bdet.prod_indi_lote, 'N') = 'S' then
        ----se cambio por el bloque de lotes y siempre se ingresa desde este bloque los importes
        for x in c_lote(bdet.deta_prod_codi, bdet.deta_nume_item_codi) loop
          if x.telo_lote_codi is null then
            -- si es loteable, caso contrario ya carga el lote0000, al recuperar el producto 
            pp_genera_codi_lote(v_deta_lote_codi);
            pp_insertar_lote(v_deta_lote_codi,
                             bdet.deta_prod_codi,
                             x.telo_lote_desc,
                             x.telo_lote_codi_barr,
                             x.telo_fech_elab,
                             x.telo_fech_venc);
          
            if x.telo_selo_nume is not null and
               x.telo_selo_desc is not null then
              update come_lote_secu_alia
                 set selo_ulti_nume = x.telo_selo_nume
               where selo_desc_abre = x.telo_selo_desc;
            end if;
          else
            v_deta_lote_codi := x.telo_lote_codi;
          end if;
        
          v_deta_nume_item := v_deta_nume_item + 1;
          v_deta_impu_codi := bdet.deta_impu_codi;
          v_deta_prod_codi := bdet.deta_prod_codi;
          v_deta_cant_medi := x.telo_cant_medi;
          v_deta_medi_codi := bdet.medi_codi;
          v_deta_cant      := x.telo_cant_medi * nvl(bdet.fact_conv, 1); --lo que afecta realmente al stock
          v_deta_obse      := null;
          v_deta_porc_deto := null; --bdet.deta_porc_deto;
          v_deta_impo_mone := x.telo_deta_impo_mone;
          v_deta_impo_mmnn := x.telo_deta_impo_mmnn;
        
          if bcab.movi_mone_codi = parameter.p_codi_mone_mmnn then
            v_deta_impo_mmee := x.telo_deta_impo_mmnn / bcab.movi_tasa_mmee; -- importe mmee
          else
            v_deta_impo_mmee := x.telo_deta_impo_mone; -- importe mmee
          end if;
        
          v_deta_iva_mmnn          := x.telo_deta_iva10_mmnn +
                                      x.telo_deta_iva5_mmnn; --bdet.deta_iva_mmnn_neto;
          v_deta_iva_mmee          := 0; --x.telo_deta_iva10_mmee + x.telo_deta_iva5_mmee; -- iva mmee
          v_deta_iva_mone          := x.telo_deta_iva10_mone +
                                      x.telo_deta_iva5_mone; --bdet.deta_iva_mone_neto;
          v_deta_prec_unit         := bdet.deta_prec_unit;
          v_deta_movi_codi_padr    := null;
          v_deta_nume_item_padr    := null;
          v_deta_impo_mone_deto_nc := null;
          v_deta_movi_codi_deto_nc := null;
          v_deta_list_codi         := null;
          v_deta_bien_codi         := bdet.bien_codi;
          v_deta_ceco_codi         := bdet.moco_ceco_codi;
          v_deta_clpr_codi         := bdet.deta_clpr_codi;
        
          v_deta_impo_mone_ii   := x.telo_deta_impo_mone_ii;
          v_deta_impo_mmnn_ii   := x.telo_deta_impo_mmnn_ii;
          v_deta_grav10_ii_mone := x.telo_deta_grav10_ii_mone;
          v_deta_grav10_ii_mmnn := x.telo_deta_grav10_ii_mmnn;
          v_deta_grav5_ii_mone  := x.telo_deta_grav5_ii_mone;
          v_deta_grav5_ii_mmnn  := x.telo_deta_grav5_ii_mmnn;
          v_deta_grav10_mone    := x.telo_deta_grav10_mone;
          v_deta_grav10_mmnn    := x.telo_deta_grav10_mmnn;
          v_deta_grav5_mone     := x.telo_deta_grav5_mone;
          v_deta_grav5_mmnn     := x.telo_deta_grav5_mmnn;
          v_deta_iva10_mone     := x.telo_deta_iva10_mone;
          v_deta_iva10_mmnn     := x.telo_deta_iva10_mmnn;
          v_deta_iva5_mone      := x.telo_deta_iva5_mone;
          v_deta_iva5_mmnn      := x.telo_deta_iva5_mmnn;
          v_deta_exen_mone      := x.telo_deta_exen_mone;
          v_deta_exen_mmnn      := x.telo_deta_exen_mmnn;
        
          v_deta_base      := parameter.p_codi_base;
          v_deta_emse_codi := bdet.moco_emse_codi;
          v_deta_coba_codi := bdet.deta_coba_codi;
          -- v_deta_prod_codi_barr := bdet.coba_codi_barr;
        
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
                                        v_deta_movi_clave_orig,
                                        v_deta_impo_mmnn_deto_nc,
                                        v_deta_base,
                                        v_deta_lote_codi,
                                        v_deta_movi_orig_codi,
                                        v_deta_movi_orig_item,
                                        v_deta_impo_mmee_deto_nc,
                                        v_deta_asie_codi,
                                        v_deta_cant_medi,
                                        v_deta_medi_codi,
                                        v_deta_remi_codi,
                                        v_deta_remi_nume_item,
                                        v_deta_bien_codi,
                                        v_deta_prec_unit_list,
                                        v_deta_impo_deto_mone,
                                        v_deta_porc_deto_prec,
                                        v_deta_ceco_codi,
                                        v_deta_clpr_codi,
                                        v_deta_bene_codi,
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
                                        v_deta_emse_codi,
                                        v_deta_prod_codi_barr,
                                        v_deta_coba_codi);
        
          ---conceptos
          v_moco_dbcr           := bdet.moco_dbcr;
          v_moco_prod_nume_item := v_deta_nume_item; --bdet.deta_nume_item;
          v_moco_tipo           := 'P';
          v_moco_tipo_item      := 'P';
          v_moco_prod_codi      := bdet.deta_prod_codi;
          v_moco_ortr_codi_fact := null;
        
          v_moco_ortr_codi := bdet.moco_ortr_codi;
          v_moco_conc_codi := bdet.deta_conc_codi;
          v_moco_nume_item := v_deta_nume_item; --v_moco_nume_item + 1;
          v_moco_cuco_codi := null;
          v_moco_impu_codi := bdet.deta_impu_codi;
          v_moco_ceco_codi := bdet.moco_ceco_codi;
          v_moco_clpr_codi := bdet.deta_clpr_codi;
          v_moco_bien_codi := bdet.bien_codi;
        
          v_moco_impo_mmnn := x.telo_deta_impo_mmnn;
          v_moco_impo_mone := x.telo_deta_impo_mone;
        
          if bcab.movi_mone_codi = parameter.p_codi_mone_mmnn then
            v_moco_impo_mmee := x.telo_deta_impo_mmnn / bcab.movi_tasa_mmee;
          else
            v_moco_impo_mmee := x.telo_deta_impo_mone;
          end if;
        
          v_moco_impo_mone_ii   := x.telo_deta_impo_mone_ii;
          v_moco_impo_mmnn_ii   := x.telo_deta_impo_mmnn_ii;
          v_moco_grav10_ii_mone := x.telo_deta_grav10_ii_mone;
          v_moco_grav10_ii_mmnn := x.telo_deta_grav10_ii_mmnn;
          v_moco_grav5_ii_mone  := x.telo_deta_grav5_ii_mone;
          v_moco_grav5_ii_mmnn  := x.telo_deta_grav5_ii_mmnn;
          v_moco_grav10_mone    := x.telo_deta_grav10_mone;
          v_moco_grav10_mmnn    := x.telo_deta_grav10_mmnn;
          v_moco_grav5_mone     := x.telo_deta_grav5_mone;
          v_moco_grav5_mmnn     := x.telo_deta_grav5_mmnn;
          v_moco_iva10_mone     := x.telo_deta_iva10_mone;
          v_moco_iva10_mmnn     := x.telo_deta_iva10_mmnn;
          v_moco_iva5_mone      := x.telo_deta_iva5_mone;
          v_moco_iva5_mmnn      := x.telo_deta_iva5_mmnn;
          v_moco_exen_mone      := x.telo_deta_exen_mone;
          v_moco_exen_mmnn      := x.telo_deta_exen_mmnn;
          v_moco_tiim_codi      := 1; --directo por defecto    
        
          v_moco_lote_codi      := v_deta_lote_codi; --bdet.deta_lote_codi;
          v_moco_medi_codi      := bdet.medi_codi;
          v_moco_cant_medi      := x.telo_cant_medi; --bdet.deta_cant;
          v_moco_cant           := x.telo_cant_medi *
                                   nvl(bdet.fact_conv, 1); --lo que afecta realmente al stock
          v_moco_impo_codi      := bdet.moco_impo_codi;
          v_moco_orse_codi      := bdet.moco_orse_codi;
          v_moco_bene_codi      := null; --beneficiario de ganaderia no aplica
          v_moco_anex_codi      := null; --no aplica en compras
          v_moco_conc_codi_impu := bdet.moco_conc_codi_impu; -- concepto del impuesto.
          v_moco_base           := parameter.p_codi_base;
          v_moco_desc           := bdet.moco_desc;
          v_moco_emse_codi      := bdet.moco_emse_codi;
          v_moco_juri_codi      := bdet.moco_juri_codi;
          v_moco_tran_codi      := bdet.moco_tran_codi;
        
          pp_insert_movi_conc_deta(v_moco_movi_codi,
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
                                   null,
                                   null,
                                   v_moco_juri_codi);
        end loop;
        if bdet.ortr_sali_mate_codi is not null then
          pp_actu_soli_mate(v_deta_prod_codi,
                            v_deta_lote_codi,
                            v_deta_cant,
                            v_deta_impo_mone,
                            v_deta_impo_mmnn,
                            v_deta_impo_mmee,
                            bdet.ortr_sali_mate_codi,
                            v_deta_prec_unit,
                            v_deta_movi_codi);
        end if;
      else
      
        for x in c_lote(nvl(bdet.deta_prod_codi, bdet.deta_conc_codi),
                        bdet.deta_nume_item_codi) loop
          v_deta_nume_item := v_deta_nume_item + 1;
        
          v_moco_dbcr           := bdet.conc_dbcr;
          v_moco_prod_nume_item := null;
          v_moco_tipo           := 'C';
          v_moco_tipo_item      := 'C';
          v_moco_prod_codi      := null;
          v_moco_ortr_codi_fact := null;
        
          v_moco_ortr_codi := bdet.moco_ortr_codi;
          v_moco_conc_codi := bdet.deta_conc_codi;
          v_moco_nume_item := v_deta_nume_item; --v_moco_nume_item + 1;
          v_moco_cuco_codi := null;
          v_moco_impu_codi := bdet.deta_impu_codi;
          v_moco_ceco_codi := bdet.moco_ceco_codi;
          v_moco_clpr_codi := bdet.deta_clpr_codi;
          v_moco_bien_codi := bdet.bien_codi;
        
          v_moco_impo_mmnn := x.telo_deta_impo_mmnn;
          v_moco_impo_mone := x.telo_deta_impo_mone;
        
          --v_moco_impo_mmee      := bdet.deta_impo_mmee;
          if bcab.movi_mone_codi = parameter.p_codi_mone_mmnn then
            v_moco_impo_mmee := x.telo_deta_impo_mmnn / bcab.movi_tasa_mmee;
          else
            v_moco_impo_mmee := x.telo_deta_impo_mone;
          end if;
        
          v_moco_impo_mone_ii   := x.telo_deta_impo_mone_ii;
          v_moco_impo_mmnn_ii   := x.telo_deta_impo_mmnn_ii;
          v_moco_grav10_ii_mone := x.telo_deta_grav10_ii_mone;
          v_moco_grav10_ii_mmnn := x.telo_deta_grav10_ii_mmnn;
          v_moco_grav5_ii_mone  := x.telo_deta_grav5_ii_mone;
          v_moco_grav5_ii_mmnn  := x.telo_deta_grav5_ii_mmnn;
          v_moco_grav10_mone    := x.telo_deta_grav10_mone;
          v_moco_grav10_mmnn    := x.telo_deta_grav10_mmnn;
          v_moco_grav5_mone     := x.telo_deta_grav5_mone;
          v_moco_grav5_mmnn     := x.telo_deta_grav5_mmnn;
          v_moco_iva10_mone     := x.telo_deta_iva10_mone;
          v_moco_iva10_mmnn     := x.telo_deta_iva10_mmnn;
          v_moco_iva5_mone      := x.telo_deta_iva5_mone;
          v_moco_iva5_mmnn      := x.telo_deta_iva5_mmnn;
          v_moco_exen_mone      := x.telo_deta_exen_mone;
          v_moco_exen_mmnn      := x.telo_deta_exen_mmnn;
        
          v_moco_lote_codi      := null; --bdet.deta_lote_codi;
          v_moco_medi_codi      := bdet.medi_codi;
          v_moco_cant_medi      := x.telo_cant_medi; --bdet.deta_cant;
          v_moco_cant           := x.telo_cant_medi *
                                   nvl(bdet.fact_conv, 1); --lo que afecta realmente al stock
          v_moco_impo_codi      := bdet.moco_impo_codi;
          v_moco_orse_codi      := bdet.moco_orse_codi;
          v_moco_bene_codi      := null; --beneficiario de ganaderia no aplica
          v_moco_anex_codi      := null; --no aplica en compras
          v_moco_conc_codi_impu := bdet.moco_conc_codi_impu; -- concepto del impuesto.
          v_moco_base           := parameter.p_codi_base;
          v_moco_desc           := bdet.moco_desc;
          v_moco_emse_codi      := bdet.moco_emse_codi;
          v_moco_juri_codi      := bdet.moco_juri_codi;
          v_moco_tran_codi      := bdet.moco_tran_codi;
          v_moco_tiim_codi      := 1; ---directo por defecto
        
          pp_insert_movi_conc_deta(v_moco_movi_codi,
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
                                   null,
                                   null,
                                   v_moco_juri_codi);
        end loop;
      end if;
    
      if nvl(bdet.conc_indi_kilo_vehi, 'N') in ('S', 'M') then
        pp_actualiza_gast_vehi(bdet);
      end if;
    end loop;
  
  end pp_actualiza_come_movi_prod;

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
             sum(a.moco_exen_mmnn) moco_exen_mmnn
      
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
  
    for x in c_movi_conc(bcab.movi_codi) loop
    
      v_moim_impu_codi    := x.moco_impu_codi;
      v_moim_movi_codi    := x.moco_movi_codi;
      v_moim_impo_mmnn    := x.moco_impo_mmnn;
      v_moim_impo_mmee    := null;
      v_moim_impu_mmnn    := x.moco_iva10_mmnn + x.moco_iva5_mmnn;
      v_moim_impu_mmee    := null;
      v_moim_impo_mone    := x.moco_impo_mone;
      v_moim_impu_mone    := x.moco_iva10_mone + x.moco_iva5_mone;
      v_moim_base         := parameter.p_codi_base;
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
  end pp_actualiza_moimpu;

  procedure pp_gene_cuot_adel_ncr is
    --genera cuotas para notas de creditos y adelantos...
    --una sola cuota, con fec. venc igual a la fec. del..
    --documento.....
  begin
    null;
    /*go_block('bcuota');
     clear_block(no_validate);  
    first_record;
    create_record;
    bcuota.dias           := 0;
    bcuota.cuot_fech_venc := bcab.movi_fech_emis;
    bcuota.cuot_impo_mone := bcab.movi_impo_mone_ii;
    go_block('bcab');   */
  end pp_gene_cuot_adel_ncr;

  procedure pp_actu_secu_rete is
  begin
  
    if nvl(bcab.s_impo_rete, 0) > 0 then
      update come_secu
         set secu_nume_reten = brete.movi_nume_rete
       where secu_codi =
             (select peco_secu_codi
                from come_pers_comp
               where peco_codi = parameter.p_peco_codi);
    end if;
  
  end pp_actu_secu_rete;

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
    v_movi_clpr_desc           varchar2(120);
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
    v_timo_tico_codi           number;
    v_tico_indi_timb           varchar2(1);
    v_nro_1                    varchar2(3);
    v_nro_2                    varchar2(3);
    v_movi_nume_timb           varchar2(20);
    v_movi_fech_venc_timb      date;
    v_movi_impo_reca           number;
    v_movi_impo_deto           number;
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
    v_moco_cant           number(20, 4);
    v_moco_cant_pulg      number(20, 4);
    v_moco_ortr_codi      number(20);
    v_moco_movi_codi_padr number(20);
    v_moco_nume_item_padr number(10);
    v_moco_impo_codi      number(20);
    v_moco_ceco_codi      number(20);
    v_moco_orse_codi      number(20);
    v_moco_bien_codi      number(20);
    v_moco_tipo_item      varchar2(2);
    v_moco_clpr_codi      number(20);
    v_moco_prod_nume_item number(20);
    v_moco_tran_codi      number(20);
    v_moco_guia_nume      number(20);
    v_moco_emse_codi      number(4);
    v_moco_impo_mmnn_ii   number(20, 4);
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
    v_moco_sofa_sose_codi number(20);
    v_moco_sofa_nume_item number(20);
    v_moco_exen_mone      number(20, 4);
    v_moco_exen_mmnn      number(20, 4);
    v_moco_empl_codi      number(10);
    v_moco_medi_codi      number(10);
    v_moco_lote_codi      number(10);
    v_moco_cant_medi      number(20, 4);
    v_moco_bene_codi      number(4);
    v_moco_anex_codi      number(20);
  
    -- movi_rete
    v_more_movi_codi      number;
    v_more_movi_codi_rete number;
    v_more_tipo_rete      number;
    v_more_impo_mone      number;
    v_more_impo_mmnn      number;
    v_more_tasa_mone      number;
  
    v_resp varchar2(1000);
  begin
  
    --- asignar valores....
    select timo_emit_reci, timo_afec_sald, timo_dbcr
      into v_movi_emit_reci, v_movi_afec_sald, v_movi_dbcr
      from come_tipo_movi, come_tipo_comp
     where timo_tico_codi = tico_codi(+)
       and timo_codi = parameter.p_codi_timo_rete_emit;
  
    v_movi_nume                := brete.movi_nume_rete;
    v_movi_nume_timb           := brete.movi_nume_timb_rete;
    v_movi_fech_venc_timb      := brete.movi_fech_venc_timb_rete;
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
    v_movi_fech_emis           := bcab.movi_fech_emis; --to_date(to_char(sysdate, 'dd-mm-yyyy'), 'dd-mm-yyyy');--bcab.movi_fech_emis;
    v_movi_fech_grab           := sysdate; --bcab.movi_fech_grab;
    v_movi_user                := g_user; --bcab.movi_user;
    v_movi_codi_padr           := bcab.movi_codi; --codigo de la factura
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := null;
    v_movi_grav_mmnn           := 0; --bcab.movi_grav_mmnn;
    v_movi_exen_mmnn           := round(brete.movi_impo_rete *
                                        bcab.movi_tasa_mone,
                                        parameter.p_cant_deci_mmnn); --bcab.movi_exen_mmnn;
    v_movi_iva_mmnn            := 0; --bcab.movi_iva_mmnn;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := 0; --bcab.movi_grav_mone;
    v_movi_exen_mone           := brete.movi_impo_rete; --bcab.movi_exen_mone;
    v_movi_iva_mone            := 0; --bcab.movi_iva_mone;
    v_movi_obse                := 'Retencion Factura Nro. ' ||
                                  bcab.movi_nume;
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
    v_movi_impo_deto           := 0;
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
                        v_movi_impo_reca,
                        v_movi_excl_cont,
                        v_movi_impo_deto,
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
                        null);
    ----detalle de caja
  
    v_moim_movi_codi := parameter.p_movi_codi_rete;
    v_moim_dbcr      := v_movi_dbcr;
    v_moim_nume_item := v_moim_nume_item + 1;
    v_moim_cuen_codi := null; --bcab.movi_cuen_codi;
    v_moim_afec_caja := 'S'; --si es cheque dif emitido debe afectar caja... pero tniendo en cuenta la fecha de venc.
    v_moim_fech      := bcab.movi_fech_emis;
    v_moim_tipo      := 'Efectivo            ';
    v_moim_impo_mone := v_movi_exen_mone;
    v_moim_impo_mmnn := v_movi_exen_mmnn;
    v_moim_fech_oper := v_movi_fech_oper;
    ----detalle de conceptos
    v_moco_movi_codi      := parameter.p_movi_codi_rete;
    v_moco_nume_item      := 0;
    v_moco_conc_codi      := parameter.p_codi_conc_rete_emit;
    v_moco_dbcr           := v_movi_dbcr;
    v_moco_nume_item      := v_moco_nume_item + 1;
    v_moco_cuco_codi      := null;
    v_moco_impu_codi      := parameter.p_codi_impu_exen;
    v_moco_impo_mmnn      := v_movi_exen_mmnn;
    v_moco_impo_mmee      := 0;
    v_moco_impo_mone      := v_movi_exen_mmnn;
    v_moco_ortr_codi      := null;
    v_moco_ceco_codi      := null;
    v_moco_prod_nume_item := null;
    v_moco_bien_codi      := null;
    v_moco_impo_mone_ii   := v_movi_exen_mone;
    v_moco_impo_mmnn_ii   := v_movi_exen_mmnn;
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
    v_moco_exen_mone      := v_movi_exen_mone;
    v_moco_exen_mmnn      := v_movi_exen_mmnn;
    v_moco_conc_codi_impu := null;
    v_moco_tipo           := 'C';
    v_moco_prod_codi      := null;
    v_moco_ortr_codi_fact := null;
    v_moco_base           := parameter.p_codi_base;
  
    pp_insert_movi_conc_deta(v_moco_movi_codi,
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
                                  v_moco_base,
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
                                  v_moco_iva5_mmnn,
                                  v_moco_exen_mone,
                                  v_moco_exen_mmnn);
  
    if nvl(bcab.s_impo_rete, 0) > 0 then
      update come_movi
         set movi_codi_rete = parameter.p_movi_codi_rete
       where movi_codi = bcab.movi_codi;
    
      v_more_movi_codi      := bcab.movi_codi;
      v_more_movi_codi_rete := v_movi_codi;
      v_more_tipo_rete      := parameter.p_form_calc_rete_emit;
      v_more_impo_mone      := brete.movi_impo_rete;
      v_more_impo_mmnn      := round((brete.movi_impo_rete *
                                     bcab.movi_tasa_mone),
                                     0);
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

  procedure pp_actualiza_come_movi_cuot is
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
    v_movi_impo_mmnn number := bcab.movi_impo_mmnn_ii;
    v_impo_cuot_mmnn number := 0;
    v_cuot_mmnn      number := 0;
    v_dife           number := 0;
    ---
  begin
    if bcab.movi_timo_indi_sald = 'S' then
    
      for bcuota in cur_bcuota loop
        bcuota.cuot_impo_mmnn := round((bcuota.cuot_impo_mone *
                                       bcab.movi_tasa_mone),
                                       parameter.p_cant_deci_mmnn);
      
      end loop;
      --last_record;
    
      /*   if bcab.movi_impo_mmnn_ii <> fbcuota.sum_cuot_impo_mmnn then
          bcuota.cuot_impo_mmnn := bcuota.cuot_impo_mmnn +
                                   (bcab.movi_impo_mmnn_ii -
                                   bcuota.sum_cuot_impo_mmnn);
        end if;
      */
      -- first_record;
      for bcuota in cur_bcuota loop
      
        v_cuot_fech_venc := bcuota.cuot_fech_venc;
        v_cuot_nume      := v_cuot_nume + 1;
        v_cuot_impo_mone := bcuota.cuot_impo_mone;
        v_cuot_impo_mmnn := bcuota.cuot_impo_mmnn;
        v_cuot_impo_mmee := null;
        v_cuot_sald_mone := bcuota.cuot_impo_mone;
        v_cuot_sald_mmnn := bcuota.cuot_impo_mmnn;
        v_cuot_sald_mmee := null;
        v_cuot_movi_codi := bcab.movi_codi;
      
        pp_insert_come_movi_cuot(v_cuot_fech_venc,
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
  end pp_actualiza_come_movi_cuot;

  procedure pp_actualiza_orden_compra(p_movi_codi in number) is
  begin
    update come_orde_comp
       set orco_movi_codi = p_movi_codi, orco_esta = 'F'
     where orco_codi = bcab.orco_codi;
  
  end pp_actualiza_orden_compra;

  procedure pp_calcular_importe_item_lote(i_deta_cant                in number,
                                          i_deta_prec_unit           in number,
                                          i_impu_indi_baim_impu_incl in varchar2,
                                          i_impu_porc                in number,
                                          i_impu_porc_base_impo      in number,
                                          i_movi_mone_cant_deci      in number,
                                          i_movi_tasa_mone           in number,
                                          i_s_descuento              in number,
                                          i_s_recargo                in number,
                                          bdet_lote                  in out cur_lote%rowtype) is
  
  begin
  
    if nvl(parameter.p_ind_validar_det_lote, 'N') = 'S' then
      if nvl(bdet_lote.lote_ulti_regi, 'N') = 'N' then
        if nvl(bdet_lote.lote_cant_medi, 0) <= 0 then
          pl_me('La Cantidad del Lote debe ser mayor a 0.');
        else
          bdet_lote.deta_prec_unit := i_deta_prec_unit;
          bdet_lote.s_descuento    := round((i_s_descuento / i_deta_cant),
                                            i_movi_mone_cant_deci) *
                                      bdet_lote.lote_cant_medi;
          bdet_lote.s_recargo      := round((i_s_recargo / i_deta_cant),
                                            i_movi_mone_cant_deci) *
                                      bdet_lote.lote_cant_medi;
        
          bdet_lote.impo_mone_ii_bruto := round(bdet_lote.lote_cant_medi *
                                                bdet_lote.deta_prec_unit,
                                                i_movi_mone_cant_deci);
        end if;
      else
        if nvl(bdet_lote.lote_cant_medi, 0) <= 0 then
          pl_me('La Cantidad del Lote debe ser mayor a 0.');
        else
          bdet_lote.deta_prec_unit := i_deta_prec_unit;
          bdet_lote.s_descuento    := round((i_s_descuento / i_deta_cant),
                                            i_movi_mone_cant_deci) *
                                      bdet_lote.lote_cant_medi;
          bdet_lote.s_recargo      := round((i_s_recargo / i_deta_cant),
                                            i_movi_mone_cant_deci) *
                                      bdet_lote.lote_cant_medi;
        
          bdet_lote.impo_mone_ii_bruto := round(bdet_lote.lote_cant_medi *
                                                bdet_lote.deta_prec_unit,
                                                i_movi_mone_cant_deci);
        end if;
      end if;
    
      bdet_lote.deta_impo_mone_ii := bdet_lote.impo_mone_ii_bruto +
                                     nvl(bdet_lote.s_recargo, 0) -
                                     nvl(bdet_lote.s_descuento, 0);
      bdet_lote.deta_impo_mmnn_ii := round((bdet_lote.deta_impo_mone_ii *
                                           i_movi_tasa_mone),
                                           parameter.p_cant_deci_mmnn);
    
      pa_devu_impo_calc(bdet_lote.deta_impo_mone_ii,
                        i_movi_mone_cant_deci,
                        i_impu_porc,
                        i_impu_porc_base_impo,
                        i_impu_indi_baim_impu_incl,
                        bdet_lote.deta_impo_mone_ii,
                        bdet_lote.deta_grav10_ii_mone,
                        bdet_lote.deta_grav5_ii_mone,
                        bdet_lote.deta_grav10_mone,
                        bdet_lote.deta_grav5_mone,
                        bdet_lote.deta_iva10_mone,
                        bdet_lote.deta_iva5_mone,
                        bdet_lote.deta_exen_mone);
    
      pa_devu_impo_calc(bdet_lote.deta_impo_mmnn_ii,
                        parameter.p_cant_deci_mmnn,
                        i_impu_porc,
                        i_impu_porc_base_impo,
                        i_impu_indi_baim_impu_incl,
                        bdet_lote.deta_impo_mmnn_ii,
                        bdet_lote.deta_grav10_ii_mmnn,
                        bdet_lote.deta_grav5_ii_mmnn,
                        bdet_lote.deta_grav10_mmnn,
                        bdet_lote.deta_grav5_mmnn,
                        bdet_lote.deta_iva10_mmnn,
                        bdet_lote.deta_iva5_mmnn,
                        bdet_lote.deta_exen_mmnn);
    
      bdet_lote.deta_impo_mmnn := bdet_lote.deta_exen_mmnn +
                                  bdet_lote.deta_grav10_mmnn +
                                  bdet_lote.deta_grav5_mmnn;
      bdet_lote.deta_impo_mone := bdet_lote.deta_exen_mone +
                                  bdet_lote.deta_grav10_mone +
                                  bdet_lote.deta_grav5_mone;
    
    end if;
  
  end pp_calcular_importe_item_lote;

  procedure pp_impr_rete is
    salir exception;
  
  begin
  
    null;
    /*
    while  fl_confirmar_reg('Desea imprimir la Retencion?') = upper('confirmar') loop
      pl_impr_rete(parameter.p_movi_codi_rete, parameter.p_form_impr_rete);   
    end loop;*/
  
  exception
    when salir then
      null;
  end pp_impr_rete;

  procedure pp_generar_etiqueta is
  
    cursor c_lote is
      select lote_codi,
             replace(replace(lote_desc, ',', '.'), chr(34), chr(39)) lote_desc,
             lote_codi_barr,
             'N?.' ||
             substr(movi_nume, length(movi_nume) - 3, length(movi_nume)) movi_nume,
             to_char(movi_fech_emis, 'DD/MON/YY') movi_fech_emis,
             prod_codi_alfa,
             replace(replace(prod_desc, ',', '.'), chr(34), chr(39)) prod_desc
        from come_lote, come_movi, come_movi_prod_deta, come_prod
       where movi_codi = deta_movi_codi
         and deta_prod_codi = prod_codi
         and deta_lote_codi = lote_codi
         and movi_codi = bcab.movi_codi
       order by deta_nume_item, lote_codi;
  
    --  archivo   text_io.file_type;
    v_destino varchar2(500);
  
    v_titulo varchar2(5000);
    v_deta   varchar2(5000);
  
    v_etiqueta varchar2(500);
  
    v_delete varchar2(500);
  
    v_delimitador varchar2(1);
  
  begin
    begin
      select ltrim(rtrim(para_valo))
        into v_delimitador
        from come_para
       where ltrim(rtrim(upper(para_nomb))) = 'P_ETIQ_SIGN_DELI_TXT';
    
    exception
      when others then
        v_delimitador := ';';
    end;
    /*
    v_destino := parameter.p_path_etiq_ot||'\'||parameter.p_nomb_etiq_ot||'.TXT';
    
    v_delete := 'DEL '||v_destino;
    
    host(v_delete, no_screen);
    
    
    archivo := text_io.fopen(v_destino, 'W'); --abrir puerto de impresora 
    
    
    
    v_titulo  := chr(34)||'LOTE_CODI'||chr(34)||v_delimitador|| -- coma ;
             chr(34)||'MEDIDA'||chr(34)||v_delimitador||
             chr(34)||'LOTE_CODI_BARR'||chr(34)||v_delimitador||
             chr(34)||'MOVI_NUME'||chr(34)||v_delimitador||
             chr(34)||'MOVI_FECH_EMIS'||chr(34)||v_delimitador||
             chr(34)||'PROD_CODI_ALFA'||chr(34)||v_delimitador||           
             chr(34)||'PROD_DESC'||chr(34);
    text_io.put_line(archivo, v_titulo);
          
            
      for x in c_lote loop
    
    
        
       v_deta := chr(34)||x.lote_codi||chr(34)||v_delimitador|| --punto y coma ;
                 chr(34)||' '||chr(34)||v_delimitador||
                 chr(34)||x.lote_codi_barr||chr(34)||v_delimitador||
                 chr(34)||x.movi_nume||chr(34)||v_delimitador||
                 chr(34)||x.movi_fech_emis||chr(34)||v_delimitador||
                 chr(34)||x.prod_codi_alfa||chr(34)||v_delimitador||
                 chr(34)||x.prod_desc||chr(34)
                 ;
        
        text_io.put_line(archivo, v_deta);
      end loop;
    
    text_io.fclose(archivo); --cerrar archivo
    
    
    v_etiqueta := parameter.p_path_etiq_ot||'\'||parameter.p_nomb_etiq_ot||'.IDA';
    
    host(v_etiqueta, no_screen);
    */
  
  end pp_generar_etiqueta;

  procedure pp_generar_tesaka is
    salir exception;
    v_resp varchar2(1000);
  begin
    --preguntar si se desea imprimir el reporte...  
    null;
    /* if fl_confirmar_reg('Desea generar el Archivo para Tesaka?') <>
       upper('confirmar') then
      raise salir;
    end if;
    
    pa_gene_tesaka('COMPRA_' || i_movi_nume || '_' ||
                   i_movi_clpr_desc || '_' ||
                   to_char(i_movi_fech_emis, 'yyyymmdd') || '.txt',
                   null,
                   null,
                   i_movi_codi,
                   null,
                   null,
                   null,
                   null,
                   v_resp);*/
  exception
    when salir then
      null;
  end pp_generar_tesaka;

  --imprimir los cheques emitidos directamente al puerto de la impresora
  procedure pp_impr_cheq_emit is
    cursor c_cheq_emit(p_movi_codi in number) is
      select c.cheq_codi
        from come_movi m, come_movi_cheq mc, come_cheq c
       where m.movi_codi = mc.chmo_movi_codi
         and c.cheq_codi = mc.chmo_cheq_codi
         and m.movi_codi = p_movi_codi
         and rtrim(ltrim(c.cheq_tipo)) = 'E';
  
    v_path_impresora varchar2(60);
    v_cheq_codi      number;
    v_form_impr      number;
  begin
  
    null;
  end pp_impr_cheq_emit;

  procedure pp_validar_prod_cons(bdet in cur_bdet%rowtype) is
  
    v_prod_indi_cons varchar2(1);
  begin
    null;
    /*
    begin
    
      -- la columna no existe
      select nvl(prod_indi_cons, 'N')
        into v_prod_indi_cons
        from come_prod
       where prod_codi = bdet.deta_prod_codi;
    exception
      when no_data_found then
        v_prod_indi_cons := 'N';
    end;
    if bcab.movi_indi_cons = 'S' then
      if v_prod_indi_cons = 'N' then
        pl_me('No se puede seleccionar el producto ' ||
              bdet.deta_prod_codi ||
              ' debido a que no es un producto a Consignacion');
      end if;
    else
      if v_prod_indi_cons = 'S' then
        pl_me('No se puede seleccionar el producto ' ||
              bdet.deta_prod_codi ||
              ' debido a que es un producto a Consignacion');
      end if;
    end if;*/
  
  end;

  procedure pp_muestra_come_conc(i_conc_codi           in number,
                                 i_movi_sucu_codi_orig in number,
                                 i_movi_dbcr           in varchar2,
                                 
                                 o_conc_desc           out varchar2,
                                 o_conc_dbcr           out varchar2,
                                 o_conc_indi_kilo_vehi out varchar2,
                                 o_moco_indi_impo      out varchar2,
                                 o_conc_indi_ortr      out varchar2,
                                 o_conc_indi_gast_judi out varchar2,
                                 o_conc_indi_cent_cost out varchar2,
                                 o_conc_indi_acti_fijo out varchar2,
                                 o_cuco_nume           out varchar2,
                                 o_cuco_desc           out varchar2) is
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
           nvl(conc_indi_cent_cost, 'N'),
           nvl(conc_indi_acti_fijo, 'N'),
           cuco_nume,
           cuco_desc
      into o_conc_desc,
           o_conc_dbcr,
           o_conc_indi_kilo_vehi,
           v_conc_sucu_codi,
           v_conc_indi_inac,
           o_moco_indi_impo,
           o_conc_indi_ortr,
           o_conc_indi_gast_judi,
           o_conc_indi_cent_cost,
           o_conc_indi_acti_fijo,
           o_cuco_nume,
           o_cuco_desc
      from come_conc c, come_cuen_cont cc
     where c.conc_cuco_codi = cc.cuco_codi(+)
       and conc_codi = i_conc_codi;
  
    if v_conc_sucu_codi is not null then
      if v_conc_sucu_codi <> i_movi_sucu_codi_orig then
        pl_me('El concepto seleccionado no pertenece a la sucursal!');
      end if;
    end if;
  
    if rtrim(ltrim(upper(o_conc_dbcr))) <> rtrim(ltrim(upper(i_movi_dbcr))) then
      if i_movi_dbcr = 'D' then
        v_dbcr_desc := 'Debito';
      else
        v_dbcr_desc := 'Credito';
      end if;
      pl_me('Debe ingresar un Concepto de tipo' ||
            rtrim(ltrim(v_dbcr_desc)));
    end if;
  
    if v_conc_indi_inac = 'S' then
      pl_me('El concepto se encuentra inactivo');
    end if;
  
  exception
    when no_data_found then
      pl_me('Concepto Inexistente!');
  end pp_muestra_come_conc;

  procedure pp_cargar_bloque_lote(bdet                  in out cur_bdet%rowtype,
                                  i_movi_mone_cant_deci in number,
                                  i_movi_tasa_mone      in number) is
  
    v_lote_codi number;
  
    bdet_lote cur_lote%rowtype;
  
  begin
  
    if nvl(bdet.prod_indi_lote, 'N') = 'S' and bdet.deta_lote_codi is null then
      null;
    else
      apex_collection.create_or_truncate_collection(p_collection_name => 'COMPRA_DET_LOTE');
    
      bdet_lote.deta_prod_codi         := nvl(bdet.deta_prod_codi,
                                              bdet.deta_conc_codi);
      bdet_lote.lote_cant_medi         := bdet.deta_cant;
      bdet_lote.deta_prec_unit         := bdet.deta_prec_unit;
      bdet_lote.s_descuento            := bdet.s_descuento;
      bdet_lote.s_recargo              := bdet.s_recargo;
      bdet_lote.indi_manu_auto         := 'M';
      bdet_lote.impo_mone_ii_bruto     := round(bdet_lote.lote_cant_medi *
                                                bdet_lote.deta_prec_unit,
                                                i_movi_mone_cant_deci);
      parameter.p_ind_validar_det_lote := 'N';
      -- go_block('bdet_lote');
      --clear_block(no_validate);
      --first_record;
      parameter.p_ind_validar_det_lote := 'S';
    
      if bdet.indi_prod_gast = 'P' then
        ---solo para los productos--
        if bdet.deta_lote_codi is null then
          begin
            select lote_desc, lote_codi
              into bdet_lote.lote_desc, v_lote_codi
              from come_lote
             where lote_prod_codi = bdet.deta_prod_codi
               and lote_desc = '000000'
               and nvl(lote_esta, 'A') <> 'I';
          exception
            when no_data_found then
              bdet_lote.lote_desc := '000000';
              v_lote_codi         := null;
          end;
        else
        
          begin
            select lote_desc, lote_codi
              into bdet_lote.lote_desc, v_lote_codi
              from come_lote
             where lote_prod_codi = bdet.deta_prod_codi
               and lote_codi = bdet.deta_lote_codi
               and nvl(lote_esta, 'A') <> 'I';
          
          exception
            when no_data_found then
              bdet_lote.lote_desc := '000000';
              v_lote_codi         := null;
          end;
        end if;
        ---bdet.deta_lote_codi  := null;
      else
        bdet.deta_lote_codi := null;
        bdet_lote.lote_desc := '000000';
        v_lote_codi         := null;
      end if;
    
      if v_lote_codi is not null then
        pp_validar_desc_lote(i_lote_desc      => bdet_lote.lote_desc,
                             i_lote_prod      => bdet.deta_prod_codi,
                             o_lote_codi      => bdet_lote.lote_codi,
                             o_lote_fech_elab => bdet_lote.lote_fech_elab,
                             o_lote_fech_venc => bdet_lote.lote_fech_venc);
      else
        bdet_lote.lote_codi      := null;
        bdet_lote.lote_fech_elab := trunc(sysdate);
        bdet_lote.lote_fech_venc := add_months(trunc(sysdate), 24);
      end if;
    
      /*     go_block('bpie_lote');
              pp_validar_importes_lotes;
              pp_validar_repeticion_lote;
              pp_validar_lotes;
              pp_generar_lote_temp;
      */
    
      pp_calcular_importe_item_lote(i_deta_cant                => bdet.deta_cant,
                                    i_deta_prec_unit           => bdet.deta_prec_unit,
                                    i_impu_indi_baim_impu_incl => bdet.impu_indi_baim_impu_incl, --i_impu_indi_baim_impu_incl
                                    i_impu_porc                => bdet.impu_porc, --i_impu_porc,
                                    i_impu_porc_base_impo      => bdet.impu_porc_base_impo, --i_impu_porc_base_impo,
                                    i_movi_mone_cant_deci      => i_movi_mone_cant_deci,
                                    i_movi_tasa_mone           => i_movi_tasa_mone, --i_movi_tasa_mone,
                                    i_s_descuento              => bdet.s_descuento,
                                    i_s_recargo                => bdet.s_recargo,
                                    bdet_lote                  => bdet_lote);
    
      apex_collection.add_member(p_collection_name => 'COMPRA_DET_LOTE',
                                 p_c001            => bdet_lote.lote_desc,
                                 p_c002            => bdet_lote.lote_codi_barr,
                                 p_c003            => bdet_lote.lote_cant_medi,
                                 p_c004            => bdet_lote.lote_codi,
                                 p_c005            => bdet_lote.deta_prod_codi,
                                 p_c006            => 0, --bdet_lote.deta_nume_item_codi,
                                 p_c007            => bdet_lote.deta_exen_mmnn,
                                 p_c008            => bdet_lote.deta_exen_mone,
                                 p_c009            => bdet_lote.deta_grav10_ii_mmnn,
                                 p_c010            => bdet_lote.deta_grav10_ii_mone,
                                 p_c011            => bdet_lote.deta_grav10_mmnn,
                                 p_c012            => bdet_lote.deta_grav10_mone,
                                 p_c013            => bdet_lote.deta_grav5_ii_mmnn,
                                 p_c014            => bdet_lote.deta_grav5_ii_mone,
                                 p_c015            => bdet_lote.deta_grav5_mmnn,
                                 p_c016            => bdet_lote.deta_grav5_mone,
                                 p_c017            => bdet_lote.deta_impo_mmnn,
                                 p_c018            => bdet_lote.deta_impo_mmnn_ii,
                                 p_c019            => bdet_lote.deta_impo_mone,
                                 p_c020            => bdet_lote.deta_impo_mone_ii,
                                 p_c021            => bdet_lote.deta_iva10_mmnn,
                                 p_c022            => bdet_lote.deta_iva10_mone,
                                 p_c023            => bdet_lote.deta_iva5_mmnn,
                                 p_c024            => bdet_lote.deta_iva5_mone,
                                 p_c025            => bdet_lote.indi_manu_auto,
                                 p_c026            => bdet_lote.s_descuento,
                                 p_c027            => bdet_lote.s_recargo,
                                 p_c028            => bdet_lote.selo_desc_abre,
                                 p_c029            => bdet_lote.selo_ulti_nume,
                                 p_c030            => bdet_lote.lote_ulti_regi,
                                 p_c031            => bdet_lote.impo_mone_ii_bruto,
                                 p_c032            => bdet_lote.deta_prec_unit,
                                 p_d001            => bdet_lote.lote_fech_elab,
                                 p_d002            => bdet_lote.lote_fech_venc);
    
    end if;
  
  end pp_cargar_bloque_lote;

  procedure pp_cargar_lote_edit(i_seq_id in number) as
    bdet_lote cur_lote%rowtype;
  begin
  
    /*
      select t.telo_prod_codi,
             t.telo_fech_elab,
             t.telo_fech_venc,
             t.telo_cant_medi,
             t.telo_lote_desc,
             t.telo_lote_codi,
             t.telo_indi_auto_manu,
             t.telo_deta_exen_mmnn,
             t.telo_deta_exen_mone,
             t.telo_deta_grav10_ii_mmnn,
             t.telo_deta_grav10_ii_mone,
             t.telo_deta_grav10_mmnn,
             t.telo_deta_grav10_mone,
             t.telo_deta_grav5_ii_mmnn,
             t.telo_deta_grav5_ii_mone,
             t.telo_deta_grav5_mmnn,
             t.telo_deta_grav5_mone,
             t.telo_deta_impo_mmnn,
             t.telo_deta_impo_mmnn_ii,
             t.telo_deta_impo_mone,
             t.telo_deta_impo_mone_ii,
             t.telo_deta_iva10_mmnn,
             t.telo_deta_iva10_mone,
             t.telo_deta_iva5_mmnn,
             t.telo_deta_iva5_mone,
             t.telo_lote_desc,
             'N' lote_ulti_regi,
             t.telo_s_descuento,
             t.telo_s_recargo
        into bdet_lote.deta_prod_codi,
             bdet_lote.lote_fech_elab,
             bdet_lote.lote_fech_venc,
             bdet_lote.lote_cant_medi,
             bdet_lote.lote_desc,
             bdet_lote.lote_codi,
             bdet_lote.indi_manu_auto,
             bdet_lote.deta_exen_mmnn,
             bdet_lote.deta_exen_mone,
             bdet_lote.deta_grav10_ii_mmnn,
             bdet_lote.deta_grav10_ii_mone,
             bdet_lote.deta_grav10_mmnn,
             bdet_lote.deta_grav10_mone,
             bdet_lote.deta_grav5_ii_mmnn,
             bdet_lote.deta_grav5_ii_mone,
             bdet_lote.deta_grav5_mmnn,
             bdet_lote.deta_grav5_mone,
             bdet_lote.deta_impo_mmnn,
             bdet_lote.deta_impo_mmnn_ii,
             bdet_lote.deta_impo_mone,
             bdet_lote.deta_impo_mone_ii,
             bdet_lote.deta_iva10_mmnn,
             bdet_lote.deta_iva10_mone,
             bdet_lote.deta_iva5_mmnn,
             bdet_lote.deta_iva5_mone,
             bdet_lote.lote_codi_barr,
             bdet_lote.lote_ulti_regi,
             bdet_lote.s_descuento,
             bdet_lote.s_recargo
        from come_lote_temp t
       where t.telo_item_nume_codi = i_seq_id
         and t.telo_sesi_user_comp = parameter.p_secu_sesi_user_comp;
    */
    /*
    bdet_lote.deta_prec_unit,
    bdet_lote.impo_mone_ii_bruto,
    */
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'COMPRA_DET_LOTE');
  
    for c in (select 'N' lote_ulti_regi,
                     t.telo_cant_medi,
                     t.telo_deta_exen_mmnn,
                     t.telo_deta_exen_mone,
                     t.telo_deta_grav10_ii_mmnn,
                     t.telo_deta_grav10_ii_mone,
                     t.telo_deta_grav10_mmnn,
                     t.telo_deta_grav10_mone,
                     t.telo_deta_grav5_ii_mmnn,
                     t.telo_deta_grav5_ii_mone,
                     t.telo_deta_grav5_mmnn,
                     t.telo_deta_grav5_mone,
                     t.telo_deta_impo_mmnn,
                     t.telo_deta_impo_mmnn_ii,
                     t.telo_deta_impo_mone,
                     t.telo_deta_impo_mone_ii,
                     t.telo_deta_iva10_mmnn,
                     t.telo_deta_iva10_mone,
                     t.telo_deta_iva5_mmnn,
                     t.telo_deta_iva5_mone,
                     t.telo_fech_elab,
                     t.telo_fech_venc,
                     t.telo_indi_auto_manu,
                     t.telo_lote_codi,
                     t.telo_lote_desc,
                     t.telo_prod_codi,
                     t.telo_s_descuento,
                     t.telo_s_recargo
                from come_lote_temp t
               where t.telo_item_nume_codi = i_seq_id
                 and t.telo_sesi_user_comp = parameter.p_secu_sesi_user_comp) loop
    
      bdet_lote.deta_prod_codi      := c.telo_prod_codi;
      bdet_lote.lote_fech_elab      := c.telo_fech_elab;
      bdet_lote.lote_fech_venc      := c.telo_fech_venc;
      bdet_lote.lote_cant_medi      := c.telo_cant_medi;
      bdet_lote.lote_desc           := c.telo_lote_desc;
      bdet_lote.lote_codi           := c.telo_lote_codi;
      bdet_lote.indi_manu_auto      := c.telo_indi_auto_manu;
      bdet_lote.deta_exen_mmnn      := c.telo_deta_exen_mmnn;
      bdet_lote.deta_exen_mone      := c.telo_deta_exen_mone;
      bdet_lote.deta_grav10_ii_mmnn := c.telo_deta_grav10_ii_mmnn;
      bdet_lote.deta_grav10_ii_mone := c.telo_deta_grav10_ii_mone;
      bdet_lote.deta_grav10_mmnn    := c.telo_deta_grav10_mmnn;
      bdet_lote.deta_grav10_mone    := c.telo_deta_grav10_mone;
      bdet_lote.deta_grav5_ii_mmnn  := c.telo_deta_grav5_ii_mmnn;
      bdet_lote.deta_grav5_ii_mone  := c.telo_deta_grav5_ii_mone;
      bdet_lote.deta_grav5_mmnn     := c.telo_deta_grav5_mmnn;
      bdet_lote.deta_grav5_mone     := c.telo_deta_grav5_mone;
      bdet_lote.deta_impo_mmnn      := c.telo_deta_impo_mmnn;
      bdet_lote.deta_impo_mmnn_ii   := c.telo_deta_impo_mmnn_ii;
      bdet_lote.deta_impo_mone      := c.telo_deta_impo_mone;
      bdet_lote.deta_impo_mone_ii   := c.telo_deta_impo_mone_ii;
      bdet_lote.deta_iva10_mmnn     := c.telo_deta_iva10_mmnn;
      bdet_lote.deta_iva10_mone     := c.telo_deta_iva10_mone;
      bdet_lote.deta_iva5_mmnn      := c.telo_deta_iva5_mmnn;
      bdet_lote.deta_iva5_mone      := c.telo_deta_iva5_mone;
      bdet_lote.lote_codi_barr      := c.telo_lote_desc;
      bdet_lote.lote_ulti_regi      := 'N';
      bdet_lote.s_descuento         := c.telo_s_descuento;
      bdet_lote.s_recargo           := c.telo_s_recargo;
    
      apex_collection.add_member(p_collection_name => 'COMPRA_DET_LOTE',
                                 p_c001            => bdet_lote.lote_desc,
                                 p_c002            => bdet_lote.lote_codi_barr,
                                 p_c003            => bdet_lote.lote_cant_medi,
                                 p_c004            => bdet_lote.lote_codi,
                                 p_c005            => bdet_lote.deta_prod_codi,
                                 p_c006            => 0, --bdet_lote.deta_nume_item_codi,
                                 p_c007            => bdet_lote.deta_exen_mmnn,
                                 p_c008            => bdet_lote.deta_exen_mone,
                                 p_c009            => bdet_lote.deta_grav10_ii_mmnn,
                                 p_c010            => bdet_lote.deta_grav10_ii_mone,
                                 p_c011            => bdet_lote.deta_grav10_mmnn,
                                 p_c012            => bdet_lote.deta_grav10_mone,
                                 p_c013            => bdet_lote.deta_grav5_ii_mmnn,
                                 p_c014            => bdet_lote.deta_grav5_ii_mone,
                                 p_c015            => bdet_lote.deta_grav5_mmnn,
                                 p_c016            => bdet_lote.deta_grav5_mone,
                                 p_c017            => bdet_lote.deta_impo_mmnn,
                                 p_c018            => bdet_lote.deta_impo_mmnn_ii,
                                 p_c019            => bdet_lote.deta_impo_mone,
                                 p_c020            => bdet_lote.deta_impo_mone_ii,
                                 p_c021            => bdet_lote.deta_iva10_mmnn,
                                 p_c022            => bdet_lote.deta_iva10_mone,
                                 p_c023            => bdet_lote.deta_iva5_mmnn,
                                 p_c024            => bdet_lote.deta_iva5_mone,
                                 p_c025            => bdet_lote.indi_manu_auto,
                                 p_c026            => bdet_lote.s_descuento,
                                 p_c027            => bdet_lote.s_recargo,
                                 p_c028            => bdet_lote.selo_desc_abre,
                                 p_c029            => bdet_lote.selo_ulti_nume,
                                 p_c030            => bdet_lote.lote_ulti_regi,
                                 p_c031            => bdet_lote.impo_mone_ii_bruto,
                                 p_c032            => bdet_lote.deta_prec_unit,
                                 p_d001            => bdet_lote.lote_fech_elab,
                                 p_d002            => bdet_lote.lote_fech_venc);
    end loop;
  
  end;

  procedure pp_validar_detalle is
  
    v_nro_item  number := 0;
    v_cant      number := 0;
    v_cant_lote number := 0;
    v_nro_reg   number := 0;
  begin
    if fbdet.sum_deta_impo_mone_ii <= 0 then
      pl_me('Debe ingresar al menos un item.');
    end if;
  
    /*if bdet.prod_codi_alfa is null then
      pl_me('Debe ingresar al menos un item.');
    end if;*/
  
    for bdet in cur_bdet loop
      v_nro_reg := v_nro_reg + 1;
      if bdet.deta_prod_codi is null and bdet.deta_conc_codi is null then
        pl_me('Debe ingresar el codigo del producto.');
      end if;
    
      if bdet.indi_prod_gast = 'P' then
        v_cant := v_cant + 1;
        if bdet.medi_codi is null then
          --      bdet.medi_desc_abre := null;
          pl_me('Unidad de medida no puede ser nula');
        end if;
        pp_validar_prod_cons(bdet);
      
      end if;
    
      if bdet.deta_cant is null then
        pl_me('Debe ingresar un valor para el campo Cantidad.');
      elsif bdet.deta_cant <= 0 then
        pl_me('La Cantidad debe ser mayor a cero.');
      end if;
    
      if bdet.indi_prod_gast = 'G' then
        if nvl(bdet.deta_prec_unit, 0) <= 0 then
          pl_me('El precio no puede ser menor o igual a cero.');
        end if;
      end if;
      ---verifica que existan datos cargados en la tabla temporal de lotes, sino genera el registro en la tabla
    end loop;
    /*begin
      select count(*)
        into v_cant_lote
        from come_lote_temp
       where telo_prod_codi = bdet.deta_prod_codi
         and telo_sesi_user_comp = parameter.p_secu_sesi_user_comp;
    
      if v_cant_lote <= 0 then
        pack_compra_temp.pa_eliminar_lote_temp(parameter.p_secu_sesi_user_comp,
                                               bdet.deta_nume_item_codi,
                                               'I');
        pp_cargar_bloque_lote('N', bdet);
      end if;
    end;*/
    --------
  
    if v_nro_reg <= 0 then
      pl_me('Debe ingresar al menos un item.');
    end if;
  
    if v_cant > 0 and bcab.movi_depo_codi_orig is null then
      pl_me('Debe ingresar el codigo de Deposito.');
    end if;
  
  end pp_validar_detalle;

  procedure pp_set_variable is
  begin
    bcab.fech_venc_timb      := v('P30_FECH_VENC_TIMB');
    bcab.impo_brut_mmnn      := v('P30_IMPO_BRUT_MMNN');
    bcab.impo_brut_mone      := v('P30_IMPO_BRUT_MONE');
    bcab.impo_reca_mone      := v('P30_IMPO_RECA_MONE');
    bcab.movi_afec_sald      := v('P30_MOVI_AFEC_SALD');
    bcab.movi_banc_codi      := v('P30_MOVI_BANC_CODI');
    bcab.movi_clpr_codi      := v('P30_MOVI_CLPR_CODI');
    bcab.movi_clpr_desc      := v('P30_MOVI_CLPR_DESC');
    bcab.movi_clpr_dire      := v('P30_MOVI_CLPR_DIRE');
    bcab.movi_clpr_ruc       := v('P30_MOVI_CLPR_RUC');
    bcab.movi_clpr_tele      := v('P30_MOVI_CLPR_TELE');
    bcab.movi_codi           := v('P30_MOVI_CODI');
    bcab.movi_dbcr           := v('P30_MOVI_DBCR');
    bcab.movi_depo_codi_orig := v('P30_MOVI_DEPO_CODI_ORIG');
    bcab.movi_emit_rec       := v('P30_MOVI_EMIT_REC');
    bcab.movi_emit_reci      := v('P30_MOVI_EMIT_RECI');
    bcab.movi_empr_codi      := v('P30_MOVI_EMPR_CODI');
    bcab.movi_exen_mmnn      := v('P30_MOVI_EXEN_MMNN');
    bcab.movi_exen_mone      := v('P30_MOVI_EXEN_MONE');
    bcab.movi_fech_emis      := v('P30_MOVI_FECH_EMIS');
    bcab.movi_fech_grab      := v('P30_MOVI_FECH_GRAB');
    bcab.movi_fech_oper      := v('P30_MOVI_FECH_OPER');
    bcab.movi_grav_mmee      := v('P30_MOVI_GRAV_MMEE');
  
    bcab.movi_grav_mmnn := v('P30_MOVI_GRAV_MMNN');
    bcab.movi_grav_mone := v('P30_MOVI_GRAV_MONE');
  
    bcab.movi_grav10_ii_mmnn := v('P30_MOVI_GRAV10_II_MMNN');
    bcab.movi_grav10_ii_mone := v('P30_MOVI_GRAV10_II_MONE');
    bcab.movi_grav10_mmnn    := v('P30_MOVI_GRAV10_MMNN');
    bcab.movi_grav10_mone    := v('P30_MOVI_GRAV10_MONE');
    bcab.movi_grav5_ii_mmnn  := v('P30_MOVI_GRAV5_II_MMNN');
    bcab.movi_grav5_ii_mone  := v('P30_MOVI_GRAV5_II_MONE');
    bcab.movi_grav5_mmnn     := v('P30_MOVI_GRAV5_MMNN');
    bcab.movi_grav5_mone     := v('P30_MOVI_GRAV5_MONE');
  
    bcab.movi_impo_mmnn_ii        := v('P30_MOVI_IMPO_MMNN_II');
    bcab.movi_impo_mone_ii        := v('P30_MOVI_IMPO_MONE_II');
    bcab.movi_indi_cons           := v('P30_MOVI_INDI_CONS');
    bcab.movi_iva_mmnn            := v('P30_MOVI_IVA_MMNN');
    bcab.movi_iva_mone            := v('P30_MOVI_IVA_MONE');
    bcab.movi_iva10_ii_mmnn       := v('P30_MOVI_IVA10_II_MMNN');
    bcab.movi_iva10_ii_mone       := v('P30_MOVI_IVA10_II_MONE');
    bcab.movi_iva10_mmnn          := v('P30_MOVI_IVA10_MMNN');
    bcab.movi_iva10_mone          := v('P30_MOVI_IVA10_MONE');
    bcab.movi_iva5_ii_mmnn        := v('P30_MOVI_IVA5_II_MMNN');
    bcab.movi_iva5_ii_mone        := v('P30_MOVI_IVA5_II_MONE');
    bcab.movi_iva5_mmnn           := v('P30_MOVI_IVA5_MMNN');
    bcab.movi_iva5_mone           := v('P30_MOVI_IVA5_MONE');
    bcab.movi_mone_cant_deci      := v('P30_MOVI_MONE_CANT_DECI');
    bcab.movi_mone_codi           := v('P30_MOVI_MONE_CODI');
    bcab.movi_nume                := v('P30_MOVI_NUME');
    bcab.movi_nume_timb           := v('P30_MOVI_NUME_TIMB');
    bcab.movi_obse                := v('P30_MOVI_OBSE');
    bcab.movi_oper_codi           := v('P30_MOVI_OPER_CODI');
    bcab.movi_sald_mmee           := v('P30_MOVI_SALD_MMEE');
    bcab.movi_sald_mmnn           := v('P30_MOVI_SALD_MMNN');
    bcab.movi_sald_mone           := v('P30_MOVI_SALD_MONE');
    bcab.movi_stoc_afec_cost_prom := v('P30_MOVI_STOC_AFEC_COST_PROM');
    bcab.movi_stoc_suma_rest      := v('P30_MOVI_STOC_SUMA_REST');
    bcab.movi_sucu_codi_orig      := v('P30_MOVI_SUCU_CODI_ORIG');
    bcab.movi_tasa_mmee           := v('P30_MOVI_TASA_MMEE');
    bcab.movi_tasa_mone           := v('P30_MOVI_TASA_MONE');
    bcab.movi_timo_codi           := v('P30_MOVI_TIMO_CODI');
    bcab.movi_timo_indi_adel      := v('P30_MOVI_TIMO_INDI_ADEL');
    bcab.movi_timo_indi_ncr       := v('P30_MOVI_TIMO_INDI_NCR');
    bcab.movi_timo_indi_sald      := v('P30_MOVI_TIMO_INDI_SALD');
    bcab.movi_user                := v('P30_MOVI_USER');
    bcab.orco_codi                := v('P30_ORCO_CODI');
    bcab.s_impo_adel              := v('P30_S_IMPO_ADEL');
    bcab.s_impo_cheq              := v('P30_S_IMPO_CHEQ');
    bcab.s_impo_efec              := v('P30_S_IMPO_EFEC');
    bcab.s_impo_rete              := v('P30_S_IMPO_RETE');
    bcab.s_impo_rete_reci         := v('P30_S_IMPO_RETE_RECI');
    bcab.s_impo_rete_rent         := v('P30_S_IMPO_RETE_RENT');
    bcab.s_impo_tarj              := v('P30_S_IMPO_TARJ');
    bcab.s_impo_vale              := v('P30_S_IMPO_VALE');
    bcab.s_impo_viaj              := v('P30_S_IMPO_VIAJ');
    bcab.s_movi_codi_a_modi       := v('P30_S_MOVI_CODI_A_MODI');
    bcab.s_tot_iva                := v('P30_S_TOT_IVA');
    bcab.tico_indi_vali_timb      := v('P30_TICO_INDI_VALI_TIMB');
  
    for cuo in cur_bcuota loop
      fbcuota.sum_cuot_impo_mone := nvl(fbcuota.sum_cuot_impo_mone, 0) +
                                    nvl(cuo.cuot_impo_mone, 0);
      fbcuota.sum_cuot_impo_mmnn := nvl(fbcuota.sum_cuot_impo_mone, 0) +
                                    nvl(cuo.cuot_impo_mmnn, 0);
    end loop;
  
    for c in cur_bdet loop
    
      fbdet.sum_deta_impo_mone_ii   := nvl(fbdet.sum_deta_impo_mone_ii, 0) +
                                       nvl(c.deta_impo_mone_ii, 0);
      fbdet.sum_impo_mone_ii_bruto  := nvl(fbdet.sum_impo_mone_ii_bruto, 0) +
                                       nvl(c.impo_mone_ii_bruto, 0);
      fbdet.sum_deta_grav5_ii_mone  := nvl(fbdet.sum_deta_grav5_ii_mone, 0) +
                                       nvl(c.deta_grav5_ii_mone, 0);
      fbdet.sum_deta_grav10_ii_mone := nvl(fbdet.sum_deta_grav10_ii_mone, 0) +
                                       nvl(c.deta_grav10_ii_mone, 0);
      fbdet.sum_deta_exen_mone      := nvl(fbdet.sum_deta_exen_mone, 0) +
                                       nvl(c.deta_exen_mone, 0);
    
    end loop;
  
    fbdet.f_dif_mone_ii_bruto := nvl(bcab.impo_brut_mone, 0) -
                                 nvl(fbdet.sum_impo_mone_ii_bruto, 0);
    fbdet.f_dif_grav_5_ii     := nvl(bcab.movi_grav5_ii_mone, 0) -
                                 nvl(fbdet.sum_deta_grav5_ii_mone, 0);
    fbdet.f_dif_grav_10_ii    := nvl(bcab.movi_grav10_ii_mone, 0) -
                                 nvl(fbdet.sum_deta_grav10_ii_mone, 0);
    fbdet.f_dif_exen          := nvl(bcab.movi_exen_mone, 0) -
                                 nvl(fbdet.sum_deta_exen_mone, 0);
    fbdet.f_dif_tot_item      := nvl(bcab.movi_impo_mone_ii, 0) -
                                 nvl(fbdet.sum_deta_impo_mone_ii, 0);
    fbdet.f_dif_mone_ii_bruto := nvl(bcab.impo_brut_mone, 0) -
                                 nvl(fbdet.sum_impo_mone_ii_bruto, 0);
  
  exception
    when others then
      pl_me('Error en asignacion de variables' || sqlerrm);
  end pp_set_variable;

  procedure pp_valida_conc_iva(i_conc_codi in number) is
    --validar que no se seleccione un concepto de tipo iva..
    cursor c_conc_iva is
      select impu_conc_codi_ivdb, impu_conc_codi_ivcr
        from come_impu
       order by 1;
  
  begin
  
    for x in c_conc_iva loop
      if x.impu_conc_codi_ivcr = i_conc_codi or
         x.impu_conc_codi_ivdb = i_conc_codi then
        pl_me('No puede seleccionar un concepto de Tipo Iva');
      end if;
    end loop;
  
  end pp_valida_conc_iva;

  procedure pp_validar is
  begin
    if bcab.movi_timo_codi is null then
      pl_me('Debe ingresar el tipo movimiento');
    end if;
  
    if bcab.movi_fech_emis is null then
      pl_me('Debe ingresar la fecha emision');
    end if;
    if bcab.movi_fech_oper is null then
      pl_me('Debe ingresar la fecha operacion');
    end if;
  
    if bcab.movi_clpr_codi is null then
      pl_me('Debe ingresar el proveedor');
    end if;
  
    if bcab.movi_nume_timb is not null then
      if length(bcab.movi_nume_timb) <> 8 then
        pl_me('El timbrado debe contener como minimo 8 caracteres.');
      end if;
    end if;
  
    if nvl(bcab.tico_indi_vali_timb, 'N') = 'S' then
      if bcab.movi_nume_timb is null then
        pl_me('Debe ingresar el nro de Timbrado!!!');
      end if;
    end if;
  
  end pp_validar;

  procedure pp_muestra_impu(io_deta_impu_codi          in out number,
                            i_movi_dbcr                in varchar2,
                            i_s_timo_calc_iva          in varchar2,
                            o_impu_desc                out varchar2,
                            o_impu_porc                out number,
                            o_impu_porc_base_impo      out number,
                            o_moco_conc_codi_impu      out number,
                            o_impu_indi_baim_impu_incl out varchar2) is
    e_sin_parametro exception;
  begin
  
    if io_deta_impu_codi is null then
      raise e_sin_parametro;
    end if;
    --si el tipo de movimiento tiene el indicador de calculo de iva 'N'
    --entonces siempre sera exento....
    if i_s_timo_calc_iva = 'N' then
      io_deta_impu_codi := parameter.p_codi_impu_exen;
    end if;
  
    select impu_codi || ' - ' || impu_desc descripcion,
           impu_porc,
           impu_porc_base_impo,
           nvl(impu_indi_baim_impu_incl, 'S')
      into o_impu_desc,
           o_impu_porc,
           o_impu_porc_base_impo,
           o_impu_indi_baim_impu_incl
      from come_impu
     where impu_codi = io_deta_impu_codi;
  
    begin
      select decode(i_movi_dbcr,
                    'C',
                    impu_conc_codi_ivcr,
                    impu_conc_codi_ivdb) conc_iva
        into o_moco_conc_codi_impu
        from come_impu
       where impu_codi = io_deta_impu_codi;
    exception
      when no_data_found then
        pl_me('Concepto de impuesto Inexistente');
    end;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      pl_me('Tipo de Impuesto inexistente');
    when too_many_rows then
      pl_me('Tipo de Impuesto duplicado');
    when others then
      pl_me('When others...');
  end pp_muestra_impu;

  procedure pp_validar_user_conc(p_conc_codi in number) is
    v_count number;
  begin
    select count(*)
      into v_count
      from segu_user_conc, segu_user
     where usco_user_codi = user_codi
       and user_login = g_user
       and usco_conc_codi = p_conc_codi;
    if v_count > 0 then
      pl_me('Concepto bloqueado. Favor verifique.');
    end if;
  end pp_validar_user_conc;

  procedure pp_validar_importes_lotes(bdet in cur_bdet%rowtype) is
    v_sum_lote_cant_medi     number := 0;
    v_sum_s_descuento        number := 0;
    v_sum_s_recargo          number := 0;
    v_sum_impo_mone_ii_bruto number := 0;
    v_last_record            number := 0;
    bdet_lote                cur_lote%rowtype;
  begin
  
    for c in cur_lote loop
      v_sum_lote_cant_medi := v_sum_lote_cant_medi + c.lote_cant_medi; -- +c.
      v_sum_s_descuento    := v_sum_s_descuento + c.s_descuento;
      v_sum_s_recargo      := v_sum_s_recargo + c.s_recargo;
      if v_last_record < c.seq_id then
        v_last_record := c.seq_id;
      end if;
    end loop;
  
    if v_sum_lote_cant_medi <> bdet.deta_cant then
      pl_me('La Cantidad total de Lotes no puede ser distinta a la Cantidad del item.');
    end if;
  
    if v_sum_s_descuento <> bdet.s_descuento then
      --go_block('bdet_lote');
      --last_record;
      if v_sum_s_descuento > bdet.s_descuento then
        bdet_lote.s_descuento := bdet_lote.s_descuento -
                                 (v_sum_s_descuento - bdet.s_descuento);
      else
        bdet_lote.s_descuento := bdet_lote.s_descuento +
                                 (bdet.s_descuento - v_sum_s_descuento);
      end if;
    end if;
  
    if v_sum_s_recargo <> bdet.s_recargo then
      --   go_block('bdet_lote');
      -- last_record;
      if v_sum_s_recargo > bdet.s_recargo then
        bdet_lote.s_recargo := bdet_lote.s_recargo -
                               (v_sum_s_recargo - bdet.s_recargo);
      else
        bdet_lote.s_recargo := bdet_lote.s_recargo +
                               (bdet.s_recargo - v_sum_s_recargo);
      end if;
    end if;
  
    if v_sum_impo_mone_ii_bruto <> bdet.impo_mone_ii_bruto then
      --   go_block('bdet_lote');
      -- last_record;
      if v_sum_impo_mone_ii_bruto > bdet.impo_mone_ii_bruto then
        bdet_lote.impo_mone_ii_bruto := bdet_lote.impo_mone_ii_bruto -
                                        (v_sum_impo_mone_ii_bruto -
                                        bdet.impo_mone_ii_bruto);
      
        if bdet_lote.deta_exen_mone > 0 then
          bdet_lote.deta_exen_mone := bdet_lote.deta_exen_mone -
                                      (v_sum_impo_mone_ii_bruto -
                                      bdet.impo_mone_ii_bruto);
          bdet_lote.deta_exen_mmnn := bdet_lote.deta_exen_mmnn -
                                      (v_sum_impo_mone_ii_bruto -
                                      bdet.impo_mone_ii_bruto);
        elsif bdet_lote.deta_grav10_ii_mone > 0 then
          bdet_lote.deta_grav10_ii_mone := bdet_lote.deta_grav10_ii_mone -
                                           (v_sum_impo_mone_ii_bruto -
                                           bdet.impo_mone_ii_bruto);
          bdet_lote.deta_grav10_ii_mmnn := bdet_lote.deta_grav10_ii_mmnn -
                                           (v_sum_impo_mone_ii_bruto -
                                           bdet.impo_mone_ii_bruto);
        else
          bdet_lote.deta_grav5_ii_mone := bdet_lote.deta_grav5_ii_mone -
                                          (v_sum_impo_mone_ii_bruto -
                                          bdet.impo_mone_ii_bruto);
          bdet_lote.deta_grav5_ii_mmnn := bdet_lote.deta_grav5_ii_mmnn -
                                          (v_sum_impo_mone_ii_bruto -
                                          bdet.impo_mone_ii_bruto);
        end if;
      
        bdet_lote.deta_impo_mone_ii := bdet_lote.deta_impo_mone_ii -
                                       (v_sum_impo_mone_ii_bruto -
                                       bdet.impo_mone_ii_bruto);
        bdet_lote.deta_impo_mmnn_ii := bdet_lote.deta_impo_mmnn_ii -
                                       (v_sum_impo_mone_ii_bruto -
                                       bdet.impo_mone_ii_bruto);
      
      else
        bdet_lote.impo_mone_ii_bruto := bdet_lote.impo_mone_ii_bruto +
                                        (bdet.impo_mone_ii_bruto -
                                        v_sum_impo_mone_ii_bruto);
      
        if bdet_lote.deta_exen_mone > 0 then
          bdet_lote.deta_exen_mone := bdet_lote.deta_exen_mone +
                                      (bdet.impo_mone_ii_bruto -
                                      v_sum_impo_mone_ii_bruto);
          bdet_lote.deta_exen_mmnn := bdet_lote.deta_exen_mmnn +
                                      (bdet.impo_mone_ii_bruto -
                                      v_sum_impo_mone_ii_bruto);
        elsif bdet_lote.deta_grav10_ii_mone > 0 then
          bdet_lote.deta_grav10_ii_mone := bdet_lote.deta_grav10_ii_mone +
                                           (bdet.impo_mone_ii_bruto -
                                           v_sum_impo_mone_ii_bruto);
          bdet_lote.deta_grav10_ii_mmnn := bdet_lote.deta_grav10_ii_mmnn +
                                           (bdet.impo_mone_ii_bruto -
                                           v_sum_impo_mone_ii_bruto);
        else
          bdet_lote.deta_grav5_ii_mone := bdet_lote.deta_grav5_ii_mone +
                                          (bdet.impo_mone_ii_bruto -
                                          v_sum_impo_mone_ii_bruto);
          bdet_lote.deta_grav5_ii_mmnn := bdet_lote.deta_grav5_ii_mmnn +
                                          (bdet.impo_mone_ii_bruto -
                                          v_sum_impo_mone_ii_bruto);
        end if;
      
        bdet_lote.deta_impo_mone_ii := bdet_lote.deta_impo_mone_ii +
                                       (bdet.impo_mone_ii_bruto -
                                       v_sum_impo_mone_ii_bruto);
        bdet_lote.deta_impo_mmnn_ii := bdet_lote.deta_impo_mmnn_ii +
                                       (bdet.impo_mone_ii_bruto -
                                       v_sum_impo_mone_ii_bruto);
      
      end if;
    end if;
  end;

  procedure pp_validar_repeticion_lote(bdet in cur_bdet%rowtype) is
    v_cant_reg number; --cantidad de registros en el bloque
    x          number;
    y          number;
    salir exception;
    v_lote_desc varchar2(60);
    v_lote_codi number;
    v_cant      number;
    r           number;
  begin
    null;
    /*go_block('bdet_lote');
      if not form_success then
        raise form_trigger_failure;
      end if;
      last_record;
      v_cant_reg := to_number(:system.cursor_record);
      if v_cant_reg <= 1 then
        raise salir;
      end if;
      r := v_cant_reg;
      
      for x in 1 .. v_cant_reg - 1 loop
        go_record(x);
        if :bdet_lote.lote_desc is null then
          pl_me('No se asigno descripcion de lote, favor verifique.');
        end if;
        
        v_lote_desc := :bdet_lote.lote_desc;
        v_lote_codi := :bdet_lote.lote_codi;
        v_cant := 0;
        
        for y in x .. r loop
          go_record(y);
          if y <> x then  
            if v_lote_desc = :bdet_lote.lote_desc and (:bdet_lote.lote_codi is null and v_lote_codi is null)then
              v_cant := v_cant + 1;
              r := r - 1;
            end if;
          end if;
        end loop;
        if v_cant <> 0 then
          pl_me('El Lote a generar '||v_lote_desc||' se repite varias veces. Favor verifique o unifique cantidades.');
          go_record(x);
        end if;
      end loop;
    */
  exception
    when salir then
      null;
  end;

  procedure pp_validar_lotes(bdet in cur_bdet%rowtype) is
    v_cant     number := 0;
    v_cant_reg number := 0;
  begin
  
    for bdet_lote in cur_lote loop
      v_cant_reg := v_cant_reg + 1;
      if bdet_lote.lote_codi is null then
        begin
          select count(*)
            into v_cant
            from come_lote_temp t
           where upper(ltrim(rtrim(t.telo_lote_desc))) =
                 ltrim(rtrim(bdet_lote.lote_desc));
        end;
        if v_cant > 0 then
          if nvl(bdet.prod_indi_lote, 'N') = 'S' then
            pl_me('El siguiente Lote ya se esta por generar en otra compra: ' ||
                  bdet_lote.lote_desc);
          end if;
          exit;
        end if;
      
        if bdet.indi_prod_gast = 'P' then
          ---solo para los productos--
          begin
            select count(*)
              into v_cant
              from come_lote l
             where upper(ltrim(rtrim(l.lote_desc))) =
                   ltrim(rtrim(bdet_lote.lote_desc))
               and l.lote_prod_codi = bdet.deta_prod_codi
               and nvl(l.lote_esta, 'A') <> 'I';
          end;
          if v_cant > 0 then
            if nvl(bdet.prod_indi_lote, 'N') = 'S' then
              pl_me('El siguiente Lote: ' || bdet_lote.lote_desc ||
                    ' ya ha sido generado para el producto asignado.');
            end if;
            exit;
          end if;
        end if;
      end if;
    end loop;
    if v_cant_reg < 1 then
      pl_me('No existen Lotes cargados para generar.');
    end if;
  end;

  procedure pp_busca_conce_prod(i_clco_codi in number,
                                i_oper_codi in number,
                                o_conc_codi out number) is
  begin
  
    select deta_conc_codi
      into o_conc_codi
      from come_prod_clas_conc, come_prod_clas_conc_deta
     where clco_codi = deta_clco_codi
       and deta_oper_codi = i_oper_codi
       and deta_clco_codi = i_clco_codi;
  
  exception
    when no_data_found then
      pl_me('Concepto de producto no encontrado!');
    when too_many_rows then
      pl_me('La Operacion tiene mas de un concepto asignado, verifique la configuracion del mismo!.');
  end pp_busca_conce_prod;

  procedure pp_calcular_importe_item(bdet in out cur_bdet%rowtype) is
  begin
  
    bdet.deta_impo_mone_ii := bdet.impo_mone_ii_bruto + bdet.s_recargo -
                              bdet.s_descuento;
  
    bdet.deta_impo_mmnn_ii := round((bdet.deta_impo_mone_ii *
                                    bcab.movi_tasa_mone),
                                    parameter.p_cant_deci_mmnn);
  
    pa_devu_impo_calc(bdet.deta_impo_mone_ii,
                      bcab.movi_mone_cant_deci,
                      bdet.impu_porc,
                      bdet.impu_porc_base_impo,
                      bdet.impu_indi_baim_impu_incl,
                      
                      bdet.deta_impo_mone_ii,
                      bdet.deta_grav10_ii_mone,
                      bdet.deta_grav5_ii_mone,
                      bdet.deta_grav10_mone,
                      bdet.deta_grav5_mone,
                      bdet.deta_iva10_mone,
                      bdet.deta_iva5_mone,
                      bdet.deta_exen_mone);
  
    pa_devu_impo_calc(bdet.deta_impo_mmnn_ii,
                      parameter.p_cant_deci_mmnn,
                      bdet.impu_porc,
                      bdet.impu_porc_base_impo,
                      bdet.impu_indi_baim_impu_incl,
                      
                      bdet.deta_impo_mmnn_ii,
                      bdet.deta_grav10_ii_mmnn,
                      bdet.deta_grav5_ii_mmnn,
                      bdet.deta_grav10_mmnn,
                      bdet.deta_grav5_mmnn,
                      bdet.deta_iva10_mmnn,
                      bdet.deta_iva5_mmnn,
                      bdet.deta_exen_mmnn);
  
    bdet.deta_impo_mmnn := bdet.deta_exen_mmnn + bdet.deta_grav10_mmnn +
                           bdet.deta_grav5_mmnn;
  
    bdet.deta_impo_mone := bdet.deta_exen_mone + bdet.deta_grav10_mone +
                           bdet.deta_grav5_mone;
  
  end pp_calcular_importe_item;

  procedure pp_add_det(i_deta_cant               in number,
                       i_deta_conc_codi          in number,
                       i_deta_impo_mone_ii_bruto in number,
                       i_deta_impu_codi          in number,
                       i_deta_medi_codi          in number,
                       i_deta_medi_desc_abre     in varchar2,
                       i_deta_prec_unit          in number,
                       i_deta_prod_codi          in number,
                       i_deta_s_descuento        in number,
                       i_deta_s_recargo          in number,
                       i_indi_prod_gast          in varchar2,
                       i_movi_dbcr               in varchar2,
                       i_movi_mone_cant_deci     in number,
                       i_movi_tasa_mone          in number,
                       i_movi_sucu_codi_orig     in number,
                       i_movi_oper_codi          in number,
                       i_prec_ulti_comp          in varchar2,
                       i_s_timo_calc_iva         in varchar2,
                       i_seq_id                  in number) as
  
    bdet             cur_bdet%rowtype;
    v_impu_desc      varchar2(200);
    v_prod_clco_codi number;
    v_deta_nume_item number;
    v_prod_indi_lote varchar2(2) := 'N';
    v_desc_conc      varchar2(500);
    v_desc_prod      varchar2(500);
    v_prod_codi_alfa varchar2(500);
  begin
    null;
  
    if not
        (apex_collection.collection_exists(p_collection_name => 'CUR_DET')) then
      apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_DET');
    end if;
    if not
        (apex_collection.collection_exists(p_collection_name => 'CUR_CONC')) then
      apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_CONC');
    end if;
    if not
        (apex_collection.collection_exists(p_collection_name => 'CUR_IMPU')) then
      apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_IMPU');
    end if;
    if not
        (apex_collection.collection_exists(p_collection_name => 'CUR_MOCO')) then
      apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_MOCO');
    end if;
  
    if not
        (apex_collection.collection_exists(p_collection_name => 'CUR_REST')) then
      apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_REST');
    end if;
  
    if upper(i_indi_prod_gast) = 'P' then
      if i_deta_prod_codi is null then
        pl_me('El codigo del producto no puede ser nulo');
      end if;
      if i_deta_medi_codi is null then
        pl_me('Debe ingresar La unidad de Medida');
      end if;
    
      select prod_desc, prod_clco_codi, prod_indi_lote, p.prod_codi_alfa
        into v_desc_prod,
             v_prod_clco_codi,
             v_prod_indi_lote,
             v_prod_codi_alfa
        from come_prod p
       where p.prod_codi = i_deta_prod_codi;
    
      pp_busca_conce_prod(i_clco_codi => v_prod_clco_codi,
                          i_oper_codi => i_movi_oper_codi,
                          o_conc_codi => bdet.deta_conc_codi);
    
    else
      pp_validar_user_conc(p_conc_codi => i_deta_conc_codi);
      bdet.deta_conc_codi := i_deta_conc_codi;
    
    end if;
  
    if i_deta_cant is null then
      pl_me('Debe ingresar un valor para el campo Cantidad');
    elsif i_deta_cant <= 0 then
      pl_me('La Cantidad debe ser mayor a cero');
    end if;
  
    pp_muestra_come_conc(i_conc_codi           => bdet.deta_conc_codi,
                         i_movi_sucu_codi_orig => i_movi_sucu_codi_orig,
                         i_movi_dbcr           => i_movi_dbcr,
                         o_conc_desc           => v_desc_conc,
                         o_conc_dbcr           => bdet.conc_dbcr,
                         o_conc_indi_kilo_vehi => bdet.conc_indi_kilo_vehi,
                         o_moco_indi_impo      => bdet.conc_indi_impo,
                         o_conc_indi_ortr      => bdet.conc_indi_ortr,
                         o_conc_indi_gast_judi => bdet.conc_indi_gast_judi,
                         o_conc_indi_cent_cost => bdet.conc_indi_cent_cost,
                         o_conc_indi_acti_fijo => bdet.conc_indi_acti_fijo,
                         o_cuco_nume           => bdet.cuco_nume,
                         o_cuco_desc           => bdet.cuco_desc);
    bdet.moco_dbcr := bdet.conc_dbcr;
    --pl_me(i_seq_id);
  
    bdet.prod_indi_lote      := v_prod_indi_lote;
    bcab.movi_tasa_mone      := i_movi_tasa_mone;
    bdet.deta_impu_codi      := i_deta_impu_codi;
    bdet.impo_mone_ii_bruto  := i_deta_impo_mone_ii_bruto;
    bdet.s_descuento         := nvl(i_deta_s_descuento, 0);
    bdet.s_recargo           := nvl(i_deta_s_recargo, 0);
    bdet.indi_prod_gast      := i_indi_prod_gast;
    bdet.deta_prod_codi      := i_deta_prod_codi;
    bdet.deta_impu_codi      := i_deta_impu_codi;
    bdet.deta_prec_unit      := i_deta_prec_unit;
    bdet.deta_cant           := i_deta_cant;
    bcab.movi_mone_cant_deci := i_movi_mone_cant_deci;
    bdet.deta_impo_mone_ii   := i_deta_impo_mone_ii_bruto;
    bdet.medi_codi           := i_deta_medi_codi;
  
    pp_muestra_impu(io_deta_impu_codi          => bdet.deta_impu_codi,
                    i_movi_dbcr                => i_movi_dbcr,
                    i_s_timo_calc_iva          => i_s_timo_calc_iva,
                    o_impu_desc                => v_impu_desc,
                    o_impu_porc                => bdet.impu_porc,
                    o_impu_porc_base_impo      => bdet.impu_porc_base_impo,
                    o_moco_conc_codi_impu      => bdet.moco_conc_codi_impu,
                    o_impu_indi_baim_impu_incl => bdet.impu_indi_baim_impu_incl);
  
    if upper(i_indi_prod_gast) = 'P' then
      bdet.deta_prod_desc := v_prod_codi_alfa || ' - ' || v_desc_prod;
    else
      bdet.deta_prod_desc := v_desc_conc;
    end if;
  
    if i_seq_id is not null then
      pack_compra_temp.pa_eliminar_lote_temp(parameter.p_secu_sesi_user_comp,
                                             i_seq_id,
                                             'I');
      apex_collection.delete_member(p_collection_name => 'CUR_DET',
                                    p_seq             => i_seq_id);
      apex_collection.resequence_collection(p_collection_name => 'CUR_DET');
    end if;
  
    pp_calcular_importe_item(bdet);
  
    pp_cargar_bloque_lote(bdet                  => bdet,
                          i_movi_mone_cant_deci => i_movi_mone_cant_deci,
                          i_movi_tasa_mone      => i_movi_tasa_mone);
  
    if bdet.deta_impo_mone_ii is null then
      pl_me('Error el importe es nulo favor revisar');
    end if;
  
    pp_validar_importes_lotes(bdet);
    pp_validar_repeticion_lote(bdet);
    /*pp_generar_lote_temp;*/
    pp_validar_lotes(bdet);
  
    -- pl_me('add_Det');
    if bdet.deta_conc_codi is not null then
      bdet.conc_seq_id := apex_collection.add_member(p_collection_name => 'CUR_CONC',
                                                     p_c001            => bdet.conc_dbcr,
                                                     p_c002            => bdet.conc_indi_impo,
                                                     p_c003            => bdet.conc_indi_kilo_vehi,
                                                     p_c004            => bdet.conc_indi_ortr,
                                                     p_c005            => bdet.conc_indi_gast_judi,
                                                     p_c006            => bdet.conc_indi_cent_cost,
                                                     p_c007            => bdet.conc_indi_acti_fijo,
                                                     p_c008            => bdet.cuco_nume,
                                                     p_c009            => bdet.cuco_desc);
    end if;
  
    bdet.impu_seq_id := apex_collection.add_member(p_collection_name => 'CUR_IMPU',
                                                   p_c002            => bdet.impu_indi_baim_impu_incl,
                                                   p_c003            => bdet.impu_porc,
                                                   p_c004            => bdet.impu_porc_base_impo);
  
    bdet.moco_seq_id := apex_collection.add_member(p_collection_name => 'CUR_MOCO',
                                                   p_c001            => bdet.moco_ceco_codi,
                                                   p_c002            => bdet.moco_conc_codi_impu,
                                                   p_c003            => bdet.moco_dbcr,
                                                   p_c004            => bdet.moco_desc,
                                                   p_c005            => bdet.moco_emse_codi,
                                                   p_c006            => bdet.moco_impo_codi,
                                                   p_c007            => bdet.moco_juri_codi,
                                                   p_c008            => bdet.moco_orse_codi,
                                                   p_c009            => bdet.moco_ortr_codi,
                                                   p_c010            => bdet.moco_tran_codi);
  
    v_deta_nume_item := apex_collection.add_member(p_collection_name => 'CUR_DET',
                                                   p_c001            => bdet.indi_prod_gast,
                                                   p_c002            => bdet.deta_cant,
                                                   p_c003            => bdet.deta_clpr_codi,
                                                   p_c004            => bdet.deta_coba_codi,
                                                   p_c005            => bdet.deta_conc_codi,
                                                   p_c006            => bdet.deta_exen_mmnn,
                                                   p_c007            => bdet.deta_exen_mone,
                                                   p_c008            => bdet.deta_grav10_ii_mmnn,
                                                   p_c009            => bdet.deta_grav10_ii_mone,
                                                   p_c010            => bdet.deta_grav10_mmnn,
                                                   p_c011            => bdet.deta_grav10_mone,
                                                   p_c012            => bdet.deta_grav5_ii_mmnn,
                                                   p_c013            => bdet.deta_grav5_ii_mone,
                                                   p_c014            => bdet.deta_grav5_mmnn,
                                                   p_c015            => bdet.deta_grav5_mone,
                                                   p_c016            => bdet.deta_impo_mmnn,
                                                   p_c017            => bdet.deta_impo_mmnn_ii,
                                                   p_c018            => bdet.deta_impo_mone,
                                                   p_c019            => bdet.deta_impo_mone_ii,
                                                   p_c020            => bdet.deta_impu_codi,
                                                   p_c021            => bdet.deta_iva10_mmnn,
                                                   p_c022            => bdet.deta_iva10_mone,
                                                   p_c023            => bdet.deta_iva5_mmnn,
                                                   p_c024            => bdet.deta_iva5_mone,
                                                   p_c026            => bdet.deta_prec_unit,
                                                   p_c027            => bdet.deta_prod_codi,
                                                   p_c028            => bdet.fact_conv,
                                                   p_c029            => bdet.impo_mone_ii_bruto,
                                                   p_c030            => bdet.s_descuento,
                                                   p_c031            => bdet.s_recargo,
                                                   p_c035            => bdet.deta_prod_desc,
                                                   p_c036            => bdet.medi_codi,
                                                   p_c037            => v_prod_indi_lote,
                                                   p_c040            => bdet.moco_seq_id,
                                                   p_c041            => bdet.conc_seq_id,
                                                   p_c042            => bdet.impu_seq_id);
  
    for bdet_lote in cur_lote loop
      bdet_lote.deta_nume_item_codi := v_deta_nume_item;
      pack_compra_temp.pa_generar_lote_temp(p_telo_lote_codi           => bdet_lote.lote_codi,
                                            p_telo_prod_codi           => bdet_lote.deta_prod_codi,
                                            p_telo_item_nume           => bdet_lote.seq_id,
                                            p_telo_selo_desc           => bdet_lote.selo_desc_abre,
                                            p_telo_selo_nume           => bdet_lote.selo_ulti_nume,
                                            p_telo_lote_desc           => bdet_lote.lote_desc,
                                            p_telo_fech_elab           => bdet_lote.lote_fech_elab,
                                            p_telo_fech_venc           => bdet_lote.lote_fech_venc,
                                            p_telo_cant_medi           => bdet_lote.lote_cant_medi,
                                            p_telo_user_regi           => gen_user,
                                            p_telo_indi_auto_manu      => bdet_lote.indi_manu_auto,
                                            p_telo_deta_impo_mone_ii   => bdet_lote.deta_impo_mone_ii,
                                            p_telo_deta_impo_mmnn_ii   => bdet_lote.deta_impo_mmnn_ii,
                                            p_telo_deta_grav10_ii_mone => bdet_lote.deta_grav10_ii_mone,
                                            p_telo_deta_grav5_ii_mone  => bdet_lote.deta_grav5_ii_mone,
                                            p_telo_deta_grav10_ii_mmnn => bdet_lote.deta_grav10_ii_mmnn,
                                            p_telo_deta_grav5_ii_mmnn  => bdet_lote.deta_grav5_ii_mmnn,
                                            p_telo_deta_grav10_mone    => bdet_lote.deta_grav10_mone,
                                            p_telo_deta_grav5_mone     => bdet_lote.deta_grav5_mone,
                                            p_telo_deta_grav10_mmnn    => bdet_lote.deta_grav10_mmnn,
                                            p_telo_deta_grav5_mmnn     => bdet_lote.deta_grav5_mmnn,
                                            p_telo_deta_iva10_mone     => bdet_lote.deta_iva10_mone,
                                            p_telo_deta_iva5_mone      => bdet_lote.deta_iva5_mone,
                                            p_telo_deta_iva10_mmnn     => bdet_lote.deta_iva10_mmnn,
                                            p_telo_deta_iva5_mmnn      => bdet_lote.deta_iva5_mmnn,
                                            p_telo_deta_exen_mone      => bdet_lote.deta_exen_mone,
                                            p_telo_deta_exen_mmnn      => bdet_lote.deta_exen_mmnn,
                                            p_telo_deta_impo_mone      => bdet_lote.deta_impo_mone,
                                            p_telo_deta_impo_mmnn      => bdet_lote.deta_impo_mmnn,
                                            p_telo_s_descuento         => bdet_lote.s_descuento,
                                            p_telo_s_recargo           => bdet_lote.s_recargo,
                                            p_telo_sesi_user_comp      => parameter.p_secu_sesi_user_comp,
                                            p_telo_item_nume_codi      => bdet_lote.deta_nume_item_codi);
    end loop;
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'COMPRA_DET_LOTE');
  end pp_add_det;

  procedure pp_borrar_deta(i_seq_id in number) as
  begin
    pack_compra_temp.pa_eliminar_lote_temp(parameter.p_secu_sesi_user_comp,
                                           i_seq_id,
                                           'I');
    apex_collection.delete_member(p_collection_name => 'CUR_DET',
                                  p_seq             => i_seq_id);
  
    apex_collection.resequence_collection(p_collection_name => 'CUR_DET');
  end pp_borrar_deta;

  function fp_devu_ult_prec_comp(i_prod_codi           in number,
                                 i_movi_mone_cant_deci in number,
                                 i_impu_porc_base_impo in number,
                                 i_impu_porc           in number)
    return number is
  
    v_prec number;
  
    v_impo_mone      number;
    v_porc_base_exen number;
    v_impo_exen      number;
    v_impo_grav      number;
    v_impo_grav_ii   number;
    v_prec_defi      number;
  
  begin
    select nvl(ulco_cost_mmnn, 0)
      into v_prec
      from come_prod_cost_ulti_comp
     where ulco_prod_codi = i_prod_codi;
  
    v_impo_mone      := v_prec;
    v_porc_base_exen := nvl(1 - (i_impu_porc_base_impo / 100), 0);
    v_impo_exen      := v_impo_mone * v_porc_base_exen;
    v_impo_grav      := v_impo_mone - v_impo_exen;
    v_impo_grav_ii   := v_impo_grav + (v_impo_grav * i_impu_porc / 100);
  
    v_prec_defi := round((v_impo_grav_ii + v_impo_exen),
                         nvl(i_movi_mone_cant_deci, 0));
  
    return v_prec_defi;
  exception
    when others then
      return 0;
  end fp_devu_ult_prec_comp;

  function fp_retorna_impu(i_impu_codi       in number,
                           i_s_timo_calc_iva in varchar2) return number as
    v_deta_impu_codi number;
  begin
  
    if nvl(i_s_timo_calc_iva, 'N') = 'N' then
      v_deta_impu_codi := parameter.p_codi_impu_exen;
    else
      v_deta_impu_codi := i_impu_codi;
    end if;
    return v_deta_impu_codi;
  end fp_retorna_impu;

  procedure pp_actualizar_registro is
    salir exception;
    v_record number;
    v_resp   varchar2(1000);
  begin
    pp_set_variable;
    pp_validar;
  
    if parameter.p_codi_mone_mmnn <> bcab.movi_mone_codi then
      if nvl(bcab.movi_tasa_mone, 0) in (1, 0) then
        pl_me('Debe indicar una tasa valida la para la moneda');
      end if;
    end if;
  
    pp_validar_detalle;
  
    if bcab.movi_nume is null then
      pl_me('Debe indicar el Numero de Comprobante');
    end if;
  
    if bcab.s_movi_codi_a_modi is not null then
      pp_dele_movi_orig(bcab.s_movi_codi_a_modi); --borrar compra anterior en caso que exista.
    end if;
  
    pp_calcular_importe_cab;
    pp_validar_importes;
  
    pp_valida_cheques;
    pp_validar_registro_duplicado('cheq');
  
    pp_validar_conceptos;
    pp_ajustar_importes_lote;
    --
  
    -- pl_me('aca');
  
    if bcab.movi_codi is null then
    
      pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
      pp_valida_fech(bcab.movi_fech_emis);
      pp_valida_fech(bcab.movi_fech_oper);
    
      pp_actualiza_come_movi;
      pp_actualiza_come_movi_prod;
      pp_actualiza_moimpu;
    
      if bcab.movi_afec_sald = 'N' then
        ---si es contado
        /*go_block('bcuota');
        clear_block(no_validate);*/
      
        begin
          -- call the procedure
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
        end;
      
      else
        --si es credito
        if bcab.movi_timo_indi_adel = 'S' or bcab.movi_timo_indi_ncr = 'S' then
          pp_gene_cuot_adel_ncr;
        end if;
        pp_actualiza_come_movi_cuot;
      end if;
    
      if nvl(bcab.s_impo_rete, 0) > 0 then
        pp_actualizar_rete;
      end if;
    
      if parameter.p_orco_codi is not null then
        bcab.orco_codi := parameter.p_orco_codi;
      end if;
    
      if bcab.orco_codi is not null then
        pp_actualiza_orden_compra(bcab.movi_codi);
      end if;
      --   go_block('bpie');
      --   commit_form;
    
      /*if parameter.p_secu_sesi_user_comp is not null then
        pack_compra_temp.pa_eliminar_lote_temp(parameter.p_secu_sesi_user_comp,
                                               null,
                                               'T');
      end if;*/
    
      -- pl_me('casi');
    
      if rtrim(ltrim(parameter.p_indi_impr_repo_vta_com)) = 'S' then
        --pp_llama_reporte;
        null;
      end if;
      if nvl(parameter.p_indi_impr_cheq_emit, 'N') = 'S' then
        pp_impr_cheq_emit;
      end if;
    
      if nvl(bcab.s_impo_rete, 0) > 0 then
        pp_impr_rete;
      end if;
    
      --generar archivo tesaka
      if nvl(bcab.s_impo_rete, 0) > 0 then
        if parameter.p_indi_rete_tesaka = 'S' then
          pp_generar_tesaka;
        end if;
      end if;
    
      if nvl(parameter.p_indi_impr_etiq_comp, 'N') = 'S' then
        --if fl_confirmar_reg('Desea imprimir las Etiquetas?') =
        --   upper('confirmar') then
        pp_generar_etiqueta;
        -- end if;
      end if;
    
      --        message('Registro actualizado.');
    
    else
      /* if parameter.p_secu_sesi_user_comp is not null then
        pack_compra_temp.pa_eliminar_lote_temp(parameter.p_secu_sesi_user_comp,
                                               null,
                                               'T');
      end if;*/
    
      pl_me('El registro ya fue ingresado, favor verifique la compra!!!!');
    end if;
  
    -- pl_me('Paso todo');
  
    apex_application.g_print_success_message := 'Compra registrado correctamente </br>
    <a onclick="javascript:$s(''P30_IMPRIMIR_COMPRA'',''' ||
                                                bcab.movi_codi ||
                                                ''');">Imprimir documento</a> ';
  exception
    when salir then
      null;
      /*when others then
      if parameter.p_secu_sesi_user_comp is not null then
      
        pack_compra_temp.pa_eliminar_lote_temp(parameter.p_secu_sesi_user_comp,
                                               null,
                                               'T');
      end if;*/
    --message('Registro no actualizado.');
    when others then
      pl_me('-' || dbms_utility.format_error_backtrace || ' * ' || sqlerrm);
  end pp_actualizar_registro;

  function fp_ind_ocasional(i_clpr_codi_alte in number) return varchar2 is
    v_codigo number;
  begin
    v_codigo := to_number(general_skn.fl_busca_parametro('p_codi_prov_espo'));
    if i_clpr_codi_alte = v_codigo then
      return 'S';
    else
      return 'N';
    end if;
  end fp_ind_ocasional;

  procedure pp_busca_tasa_mone(i_mone_codi         in number,
                               i_fech              in date,
                               i_tica_codi         in number,
                               o_tasa_mone         out number,
                               o_tasa_mmee         out number,
                               o_ind_not_coti      out varchar2,
                               o_ind_hab_tasa_mone out varchar2) is
    v_tasa_mone     number;
    v_ind_tasa_mone varchar2(20);
  begin
    if i_mone_codi = parameter.p_codi_mone_mmnn then
      -- set_item_property('bcab.movi_tasa_mone', enabled, property_false);
      --i_movi_tasa_mone := 1;
      null;
    else
      v_ind_tasa_mone := 'S';
    end if;
  
    if parameter.p_codi_mone_mmnn = i_mone_codi then
      o_tasa_mone := 1;
    else
      select coti_tasa
        into v_tasa_mone
        from come_coti
       where coti_mone = i_mone_codi
         and coti_tica_codi = i_tica_codi
         and coti_fech = i_fech;
    
      o_tasa_mone := v_tasa_mone;
      o_tasa_mmee := v_tasa_mone;
    end if;
  
  exception
    when no_data_found then
      o_ind_hab_tasa_mone := v_ind_tasa_mone;
      o_ind_not_coti      := 'S';
      /* pl_me('Cotizacion inexistente para la moneda ' || i_mone_codi ||
      ' - ' || i_tica_codi || ' - ' || ' en fecha ' ||
      to_char(i_fech, 'dd-mm-yyyy'));*/
  end pp_busca_tasa_mone;

  procedure pp_come_mone_dec(i_mone_codi                   in number,
                             i_mone_cant_deci              out number,
                             i_mone_cant_deci_prec_unit_co out number) is
  begin
  
    select mone_cant_deci, mone_cant_deci_prec_unit_comp
      into i_mone_cant_deci, i_mone_cant_deci_prec_unit_co
      from come_mone
     where mone_codi = i_mone_codi;
  
  exception
    when no_data_found then
      pl_me('moneda inexistente!');
  end pp_come_mone_dec;

  procedure pp_generar_cuotas(i_s_entrega           in number,
                              i_s_cant_cuotas       in number,
                              i_s_tipo_vto          in varchar2,
                              i_movi_mone_cant_deci in number,
                              i_movi_fech_emis      in date,
                              i_movi_impo_mone_ii   in number) is
    v_dias        number;
    v_importe     number;
    v_cant_cuotas number;
    v_entrega     number := 0;
    v_vto         number;
    v_diferencia  number;
    v_count       number := 0;
    v_fech_venc   date;
    bcuota        cur_bcuota%rowtype;
  begin
  
    if i_s_entrega is null or i_s_entrega < 0 then
      v_entrega := 0;
    else
      v_entrega := i_s_entrega;
    end if;
  
    if i_s_cant_cuotas is null or i_s_cant_cuotas <= 0 then
      pl_me('la cantidad de cuotas debe ser mayor a cero');
    end if;
  
    --if not
    --    (apex_collection.collection_exists(p_collection_name => 'BCUOTA')) then
    apex_collection.create_or_truncate_collection(p_collection_name => 'BCUOTA');
    --  end if;
  
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
      v_importe     := round(i_movi_impo_mone_ii / v_cant_cuotas,
                             i_movi_mone_cant_deci);
      v_diferencia  := (i_movi_impo_mone_ii - (v_importe * v_cant_cuotas));
    
      --   go_block('bcuota');
      --  first_record;
      for x in 1 .. v_cant_cuotas loop
        --create_record;
      
        v_fech_venc := i_movi_fech_emis + v_dias;
        v_dias      := v_dias + parameter.p_cant_dias_feri;
      
        bcuota.dias           := v_dias;
        bcuota.cuot_impo_mone := v_importe;
        v_dias                := v_dias + v_vto -
                                 parameter.p_cant_dias_feri;
        v_count               := v_count + 1;
        if v_count = v_cant_cuotas then
        
          if v_diferencia <> 0 then
            bcuota.cuot_impo_mone := bcuota.cuot_impo_mone + v_diferencia;
          
          end if;
        end if;
      
        apex_collection.add_member(p_collection_name => 'BCUOTA',
                                   p_c001            => bcuota.cuot_impo_mmnn,
                                   p_c002            => v_fech_venc,
                                   p_c003            => bcuota.cuot_impo_mone,
                                   p_c004            => bcuota.dias);
      
      end loop;
    
      ----------------------
    else
      --si tiene entrega
      v_dias        := 0;
      v_cant_cuotas := i_s_cant_cuotas;
      v_importe     := round((i_movi_impo_mone_ii - v_entrega) /
                             v_cant_cuotas,
                             i_movi_mone_cant_deci);
      v_diferencia  := (i_movi_impo_mone_ii -
                       ((v_importe * v_cant_cuotas) + v_entrega));
    
      if v_importe < 1 then
        pl_me('Importe no valido para generar cuota');
      end if;
    
      v_fech_venc := i_movi_fech_emis + v_dias;
      --pp_veri_fech_venc_feri(v_fech_venc);
      v_dias := v_dias + parameter.p_cant_dias_feri;
    
      bcuota.dias           := v_dias; --0;    
      bcuota.cuot_impo_mone := v_entrega;
      v_dias                := v_vto - parameter.p_cant_dias_feri;
    
      apex_collection.add_member(p_collection_name => 'BCUOTA',
                                 p_c001            => bcuota.cuot_impo_mmnn,
                                 p_c002            => v_fech_venc,
                                 p_c003            => bcuota.cuot_impo_mone,
                                 p_c004            => bcuota.dias);
      for x in 1 .. v_cant_cuotas loop
        v_fech_venc := i_movi_fech_emis + v_dias;
        --pp_veri_fech_venc_feri(v_fech_venc);
        v_dias := v_dias + parameter.p_cant_dias_feri;
      
        bcuota.dias           := v_dias;
        bcuota.cuot_impo_mone := v_importe;
        v_dias                := v_dias + v_vto -
                                 parameter.p_cant_dias_feri;
        v_count               := v_count + 1;
      
        if v_count = v_cant_cuotas then
        
          if v_diferencia <> 0 then
            bcuota.cuot_impo_mone := bcuota.cuot_impo_mone + v_diferencia;
          
          end if;
        end if;
      
        apex_collection.add_member(p_collection_name => 'BCUOTA',
                                   p_c001            => bcuota.cuot_impo_mmnn,
                                   p_c002            => v_fech_venc,
                                   p_c003            => bcuota.cuot_impo_mone,
                                   p_c004            => bcuota.dias);
      
      end loop;
    end if;
  
  end pp_generar_cuotas;

  procedure pp_get_cuota(i_seq_id         in number,
                         o_fech_venc      out date,
                         o_cuot_impo_mone out number) is
  begin
  
    select c002 cuot_fech_venc, c003 cuot_impo_mone
    -- c001 cuot_impo_mmnn,
    --c004 dias
      into o_fech_venc, o_cuot_impo_mone
      from apex_collections a
     where a.collection_name = 'BCUOTA'
       and seq_id = i_seq_id;
  exception
    when no_data_found then
      null;
    
  end pp_get_cuota;

  procedure pp_edit_cuota(i_seq_id         in number,
                          i_movi_fech_emis in date,
                          i_fech_venc      in date,
                          i_cuot_impo_mone in number) is
    v_dias number;
  begin
  
    if i_seq_id is null then
      pl_me('Elige la cuota a modificar');
    end if;
  
    if i_fech_venc is null then
      pl_me('Debe ingresar la Fecha de Vencimiento');
    end if;
  
    if i_fech_venc < i_movi_fech_emis then
      pl_me('Fecha de vencimiento debe ser mayor a la fecha del documento');
    end if;
  
    v_dias := round(i_fech_venc - i_movi_fech_emis);
  
    apex_collection.update_member(p_collection_name => 'BCUOTA',
                                  p_seq             => i_seq_id,
                                  p_c001            => 0,
                                  p_c002            => i_fech_venc,
                                  p_c003            => i_cuot_impo_mone,
                                  p_c004            => v_dias);
  
  end pp_edit_cuota;

  procedure pp_validar_cant_lote(i_cant_cab in number,
                                 i_cant_det in number) as
    v_cant_total number := 0;
  begin
    if i_cant_cab is null then
      raise_application_error(-20010, 'Debe cargar primero la cantidad');
    end if;
  
    for c in cur_lote loop
      v_cant_total := v_cant_total + c.lote_cant_medi;
    end loop;
  
    if (nvl(v_cant_total, 0) + nvl(i_cant_det, 0)) > nvl(i_cant_cab, 0) then
      raise_application_error(-20010,
                              'La Cantidad total de Lotes no puede ser distinta a la Cantidad del item.');
    end if;
  
  end pp_validar_cant_lote;

  procedure pp_validar_lote_repetido(i_lote_desc in varchar2) is
  begin
    for c in cur_lote loop
      if c.lote_desc = i_lote_desc then
        raise_application_error(-20010,
                                'Este lote ya fue cargado, favor validar');
      end if;
    end loop;
  end pp_validar_lote_repetido;

  procedure pp_borrar_lote_det(i_seq in number) as
  begin
    apex_collection.delete_member(p_collection_name => 'COMPRA_DET_LOTE',
                                  p_seq             => i_seq);
    --- comentario
    apex_collection.resequence_collection(p_collection_name => 'COMPRA_DET_LOTE');
  end pp_borrar_lote_det;

  procedure pp_carga_deta_lote(i_cant_lote                in number,
                               i_deta_cant                in number,
                               i_deta_prec_unit           in number,
                               i_deta_prod_codi           in number,
                               i_impu_indi_baim_impu_incl in varchar2,
                               i_impu_porc                in number,
                               i_impu_porc_base_impo      in number,
                               i_indi_manu_auto           in varchar2,
                               i_movi_mone_cant_deci      in number,
                               i_movi_tasa_mone           in number,
                               i_prod_codi_alfa           in number,
                               i_s_descuento              in number,
                               i_s_nro_3                  in number,
                               i_s_recargo                in number,
                               i_secu_manu                in number,
                               i_selo_codi                in number,
                               i_selo_desc_abre           in varchar2,
                               i_selo_ulti_nume           in number,
                               i_deta_lote_codi           in number) is
  
    v_cant          number := 1;
    v_sum_cant_medi number := 0;
    v_sum_recarga   number := 0;
    v_sum_descuento number := 0;
    v_count         number := 0;
    v_cant_secu     number := 0;
    v_sec_barr_lote number;
  
    bdet_lote cur_lote%rowtype;
  begin
  
    parameter.p_ind_validar_det_lote := 'S';
  
    if i_cant_lote is null then
      pl_me('Debe ingresar la Cantidad en que se dividira cada Lote.');
    elsif i_cant_lote < 1 then
      pl_me('La Cantidad en que se dividira cada Lote debe ser mayor a 0.');
    elsif i_cant_lote > i_deta_cant then
      pl_me('La Cantidad en que se dividira cada Lote no puede ser mayor a la Cantidad del item: ' ||
            i_deta_cant || '.');
    end if;
  
    if nvl(i_indi_manu_auto, 'M') = 'A' then
      if nvl(parameter.p_indi_gene_lote_desc, 'E') = 'E' then
        if i_selo_codi is null then
          pl_me('Debe ingresar el codigo de la Secuencia del Lote.');
        end if;
      end if;
    end if;
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'COMPRA_DET_LOTE');
    loop
      if nvl(i_indi_manu_auto, 'M') = 'A' then
        if nvl(parameter.p_indi_gene_lote_desc, 'E') = 'E' then
          bdet_lote.selo_desc_abre := i_selo_desc_abre;
          bdet_lote.selo_ulti_nume := i_selo_ulti_nume + v_cant;
          bdet_lote.lote_desc      := i_selo_desc_abre ||
                                      bdet_lote.selo_ulti_nume;
          --verificar tabla de lotes temporales si no se esta por generar la misma descripcion de lote
          loop
            begin
              select count(*)
                into v_count
                from come_lote_temp t
               where upper(ltrim(rtrim(t.telo_lote_desc))) =
                     ltrim(rtrim(bdet_lote.lote_desc));
            end;
          
            if v_count > 0 then
              v_cant                   := v_cant + 1;
              bdet_lote.selo_ulti_nume := i_selo_ulti_nume + v_cant;
              bdet_lote.lote_desc      := i_selo_desc_abre ||
                                          bdet_lote.selo_ulti_nume;
            end if;
            exit when v_count = 0;
          end loop;
        
          --verificar tabla de lotes si no se ha generado ya la misma descripcion de lote para el producto ingresado
          loop
            begin
              select count(*)
                into v_count
                from come_lote l
               where upper(ltrim(rtrim(l.lote_desc))) =
                     ltrim(rtrim(bdet_lote.lote_desc))
                 and lote_prod_codi = i_deta_prod_codi
                 and nvl(lote_esta, 'A') <> 'I';
            end;
          
            if v_count > 0 then
              v_cant                   := v_cant + 1;
              bdet_lote.selo_ulti_nume := i_selo_ulti_nume + v_cant;
              bdet_lote.lote_desc      := i_selo_desc_abre ||
                                          bdet_lote.selo_ulti_nume;
            end if;
            exit when v_count = 0;
          end loop;
        
        else
          --para ecoservice
        
          v_sec_barr_lote     := fa_sec_codi_barr_lote; --falta funcion
          bdet_lote.lote_desc := lpad(substr(i_prod_codi_alfa,
                                             length(i_prod_codi_alfa) - 3,
                                             length(i_prod_codi_alfa)),
                                      4,
                                      0) || substr(i_s_nro_3, 4, 7) ||
                                 lpad(substr(v_sec_barr_lote,
                                             length(v_sec_barr_lote) - 3,
                                             4),
                                      4,
                                      0);
        
          bdet_lote.lote_codi_barr := bdet_lote.lote_desc;
          --verificar tabla de lotes temporales si no se esta por generar la misma descripcion de lote
          --loop    
          begin
            select count(*)
              into v_count
              from come_lote_temp t
             where upper(ltrim(rtrim(t.telo_lote_desc))) =
                   ltrim(rtrim(bdet_lote.lote_desc));
          end;
        
          if v_count > 0 then
            pl_me('El Lote ' || bdet_lote.lote_desc ||
                  ' ya se esta por generar, favor verifique.');
          end if;
        
          --verificar tabla de lotes si no se ha generado ya la misma descripcion de lote para el producto ingresado
          --loop
          begin
            select count(*)
              into v_count
              from come_lote l
             where upper(ltrim(rtrim(l.lote_desc))) =
                   ltrim(rtrim(bdet_lote.lote_desc))
               and lote_prod_codi = i_deta_prod_codi
               and nvl(lote_esta, 'A') <> 'I';
          end;
        
          if v_count > 0 then
            pl_me('El Lote ' || bdet_lote.lote_desc ||
                  ' ya se esta por generar, favor verifique.');
          end if;
        end if;
      
      end if;
    
      if nvl(i_indi_manu_auto, 'M') = 'M' then
        if i_secu_manu is not null and i_secu_manu > 0 then
          bdet_lote.lote_desc      := i_secu_manu + v_cant_secu;
          bdet_lote.lote_codi_barr := i_secu_manu + v_cant_secu;
          v_cant_secu              := v_cant_secu + 1;
        else
          v_sec_barr_lote     := fa_sec_codi_barr_lote; --falta funcion
          bdet_lote.lote_desc := lpad(substr(i_prod_codi_alfa,
                                             length(i_prod_codi_alfa) - 3,
                                             length(i_prod_codi_alfa)),
                                      4,
                                      0) || substr(i_s_nro_3, 4, 7) ||
                                 lpad(substr(v_sec_barr_lote,
                                             length(v_sec_barr_lote) - 3,
                                             4),
                                      4,
                                      0);
        
          bdet_lote.lote_codi_barr := bdet_lote.lote_desc;
        end if;
      end if;
    
      -------------------
      bdet_lote.lote_fech_elab := trunc(sysdate);
      bdet_lote.lote_fech_venc := add_months(sysdate, 24);
      bdet_lote.deta_prec_unit := i_deta_prec_unit;
    
      ---dividir cantidades por item
      if (i_deta_cant - v_sum_cant_medi) < i_cant_lote then
        bdet_lote.lote_cant_medi     := i_deta_cant - v_sum_cant_medi;
        bdet_lote.impo_mone_ii_bruto := round(bdet_lote.lote_cant_medi *
                                              bdet_lote.deta_prec_unit,
                                              i_movi_mone_cant_deci);
      else
        bdet_lote.lote_cant_medi     := i_cant_lote;
        bdet_lote.impo_mone_ii_bruto := round(bdet_lote.lote_cant_medi *
                                              bdet_lote.deta_prec_unit,
                                              i_movi_mone_cant_deci);
      end if;
      ---dividir descuento por item
      if i_s_descuento <> 0 then
        if (i_s_descuento - v_sum_descuento) <
           (round((i_s_descuento / i_deta_cant), i_movi_mone_cant_deci) *
           bdet_lote.lote_cant_medi) then
          bdet_lote.s_descuento := i_s_descuento - v_sum_descuento;
        else
          bdet_lote.s_descuento := round((i_s_descuento / i_deta_cant),
                                         i_movi_mone_cant_deci) *
                                   bdet_lote.lote_cant_medi;
        end if;
      else
        bdet_lote.s_descuento := 0;
      end if;
      ---dividir recarga por item
      if i_s_recargo <> 0 then
        if (i_s_recargo - v_sum_recarga) <
           (round((i_s_recargo / i_deta_cant), i_movi_mone_cant_deci) *
           bdet_lote.lote_cant_medi) then
          bdet_lote.s_recargo := i_s_recargo - v_sum_recarga;
        else
          bdet_lote.s_recargo := round((i_s_recargo / i_deta_cant),
                                       i_movi_mone_cant_deci) *
                                 bdet_lote.lote_cant_medi;
        end if;
      else
        bdet_lote.s_recargo := 0;
      end if;
    
      v_cant                   := v_cant + 1;
      v_sum_cant_medi          := v_sum_cant_medi +
                                  bdet_lote.lote_cant_medi;
      v_sum_descuento          := v_sum_descuento + bdet_lote.s_descuento;
      v_sum_recarga            := v_sum_recarga + bdet_lote.s_recargo;
      bdet_lote.deta_prod_codi := i_deta_prod_codi;
    
      if v_sum_cant_medi = i_deta_cant then
        bdet_lote.lote_ulti_regi := 'S';
        if i_s_descuento <> v_sum_descuento then
          bdet_lote.s_descuento := bdet_lote.s_descuento +
                                   (i_s_descuento - v_sum_descuento);
        end if;
        if i_s_recargo <> v_sum_recarga then
          bdet_lote.s_recargo := bdet_lote.s_recargo +
                                 (i_s_recargo - v_sum_recarga);
        end if;
      else
        bdet_lote.lote_ulti_regi := 'N';
      end if;
    
      bdet_lote.indi_manu_auto := i_indi_manu_auto;
      bdet_lote.s_descuento    := i_s_descuento;
      bdet_lote.s_recargo      := i_s_recargo;
    
      pp_calcular_importe_item_lote(i_deta_cant                => i_deta_cant,
                                    i_deta_prec_unit           => i_deta_prec_unit,
                                    i_impu_indi_baim_impu_incl => i_impu_indi_baim_impu_incl, --i_impu_indi_baim_impu_incl
                                    i_impu_porc                => i_impu_porc, --i_impu_porc,
                                    i_impu_porc_base_impo      => i_impu_porc_base_impo, --i_impu_porc_base_impo,
                                    i_movi_mone_cant_deci      => i_movi_mone_cant_deci,
                                    i_movi_tasa_mone           => i_movi_tasa_mone, --i_movi_tasa_mone,
                                    i_s_descuento              => i_s_descuento,
                                    i_s_recargo                => i_s_recargo,
                                    bdet_lote                  => bdet_lote);
    
      apex_collection.add_member(p_collection_name => 'COMPRA_DET_LOTE',
                                 p_c001            => bdet_lote.lote_desc,
                                 p_c002            => bdet_lote.lote_codi_barr,
                                 p_c003            => bdet_lote.lote_cant_medi,
                                 p_c004            => bdet_lote.lote_codi,
                                 p_c005            => bdet_lote.deta_prod_codi,
                                 p_c006            => 0, --bdet_lote.deta_nume_item_codi,
                                 p_c007            => bdet_lote.deta_exen_mmnn,
                                 p_c008            => bdet_lote.deta_exen_mone,
                                 p_c009            => bdet_lote.deta_grav10_ii_mmnn,
                                 p_c010            => bdet_lote.deta_grav10_ii_mone,
                                 p_c011            => bdet_lote.deta_grav10_mmnn,
                                 p_c012            => bdet_lote.deta_grav10_mone,
                                 p_c013            => bdet_lote.deta_grav5_ii_mmnn,
                                 p_c014            => bdet_lote.deta_grav5_ii_mone,
                                 p_c015            => bdet_lote.deta_grav5_mmnn,
                                 p_c016            => bdet_lote.deta_grav5_mone,
                                 p_c017            => bdet_lote.deta_impo_mmnn,
                                 p_c018            => bdet_lote.deta_impo_mmnn_ii,
                                 p_c019            => bdet_lote.deta_impo_mone,
                                 p_c020            => bdet_lote.deta_impo_mone_ii,
                                 p_c021            => bdet_lote.deta_iva10_mmnn,
                                 p_c022            => bdet_lote.deta_iva10_mone,
                                 p_c023            => bdet_lote.deta_iva5_mmnn,
                                 p_c024            => bdet_lote.deta_iva5_mone,
                                 p_c025            => bdet_lote.indi_manu_auto,
                                 p_c026            => bdet_lote.s_descuento,
                                 p_c027            => bdet_lote.s_recargo,
                                 p_c028            => bdet_lote.selo_desc_abre,
                                 p_c029            => bdet_lote.selo_ulti_nume,
                                 p_c030            => bdet_lote.lote_ulti_regi,
                                 p_c031            => bdet_lote.impo_mone_ii_bruto,
                                 p_c032            => bdet_lote.deta_prec_unit,
                                 p_d001            => bdet_lote.lote_fech_elab,
                                 p_d002            => bdet_lote.lote_fech_venc);
    
      exit when v_sum_cant_medi = i_deta_cant;
      --  next_record;
    end loop;
    --first_record;
  
    parameter.p_ind_validar_det_lote := 'S';
  end;

  procedure pp_carga_deta_lote_manual(i_seq_id                   in number,
                                      i_lote_desc                in varchar2,
                                      i_lote_fech_elab           in date,
                                      i_lote_fech_venc           in date,
                                      i_cant_lote                in number,
                                      i_deta_cant                in number,
                                      i_deta_prec_unit           in number,
                                      i_deta_prod_codi           in number,
                                      i_impu_indi_baim_impu_incl in varchar2,
                                      i_impu_porc                in number,
                                      i_impu_porc_base_impo      in number,
                                      i_movi_mone_cant_deci      in number,
                                      i_movi_tasa_mone           in number,
                                      i_prod_codi_alfa           in number,
                                      i_s_descuento              in number,
                                      i_s_nro_3                  in number,
                                      i_s_recargo                in number) is
  
    v_cant          number := 1;
    v_count         number := 0;
    v_cant_secu     number := 0;
    v_sec_barr_lote number;
    bdet_lote       cur_lote%rowtype;
  begin
  
    parameter.p_ind_validar_det_lote := 'S';
  
    if i_cant_lote is null then
      pl_me('Debe ingresar la Cantidad en que se dividira cada Lote.');
    elsif i_cant_lote < 1 then
      pl_me('La Cantidad en que se dividira cada Lote debe ser mayor a 0.');
    elsif i_cant_lote > i_deta_cant then
      pl_me('La Cantidad en que se dividira cada Lote no puede ser mayor a la Cantidad del item: ' ||
            i_deta_cant || '.');
    end if;
  
    --  apex_collection.create_or_truncate_collection(p_collection_name => 'COMPRA_DET_LOTE');
  
    bdet_lote.lote_desc      := i_lote_desc;
    bdet_lote.lote_codi_barr := i_lote_desc;
    bdet_lote.lote_fech_elab := i_lote_fech_elab;
    bdet_lote.lote_fech_venc := i_lote_fech_venc;
    --verificar tabla de lotes temporales 
    --si no se esta por generar la misma descripcion de lote
  
    begin
      select count(*)
        into v_count
        from come_lote_temp t
       where upper(ltrim(rtrim(t.telo_lote_desc))) =
             ltrim(rtrim(bdet_lote.lote_desc));
    end;
  
    if v_count > 0 then
      pl_me('El Lote ' || bdet_lote.lote_desc ||
            ' ya se esta por generar, favor verifique.');
    end if;
  
    --verificar tabla de lotes si no se ha generado ya la misma descripcion de lote para el producto ingresado
    --loop    
    begin
      select count(*)
        into v_count
        from come_lote l
       where upper(ltrim(rtrim(l.lote_desc))) =
             ltrim(rtrim(bdet_lote.lote_desc))
         and lote_prod_codi = i_deta_prod_codi
         and nvl(lote_esta, 'A') <> 'I';
    end;
  
    if v_count > 0 then
      pl_me('El Lote ' || bdet_lote.lote_desc ||
            ' ya se esta por generar, favor verifique.');
    end if;
  
    -------------------
    bdet_lote.deta_prec_unit := i_deta_prec_unit;
  
    bdet_lote.lote_cant_medi     := i_cant_lote;
    bdet_lote.impo_mone_ii_bruto := round(bdet_lote.lote_cant_medi *
                                          bdet_lote.deta_prec_unit,
                                          i_movi_mone_cant_deci);
  
    ---dividir descuento por item
    if i_s_descuento <> 0 then
      bdet_lote.s_descuento := round((i_s_descuento / i_deta_cant),
                                     i_movi_mone_cant_deci) *
                               bdet_lote.lote_cant_medi;
    else
      bdet_lote.s_descuento := 0;
    end if;
    ---dividir recarga por item
    if i_s_recargo <> 0 then
      bdet_lote.s_recargo := round((i_s_recargo / i_deta_cant),
                                   i_movi_mone_cant_deci) *
                             bdet_lote.lote_cant_medi;
    
    else
      bdet_lote.s_recargo := 0;
    end if;
  
    bdet_lote.deta_prod_codi := i_deta_prod_codi;
  
    bdet_lote.lote_ulti_regi := 'N';
    bdet_lote.indi_manu_auto := 'M';
  
    pp_calcular_importe_item_lote(i_deta_cant                => i_deta_cant,
                                  i_deta_prec_unit           => i_deta_prec_unit,
                                  i_impu_indi_baim_impu_incl => i_impu_indi_baim_impu_incl, --i_impu_indi_baim_impu_incl
                                  i_impu_porc                => i_impu_porc, --i_impu_porc,
                                  i_impu_porc_base_impo      => i_impu_porc_base_impo, --i_impu_porc_base_impo,
                                  i_movi_mone_cant_deci      => i_movi_mone_cant_deci,
                                  i_movi_tasa_mone           => i_movi_tasa_mone, --i_movi_tasa_mone,
                                  i_s_descuento              => i_s_descuento,
                                  i_s_recargo                => i_s_recargo,
                                  bdet_lote                  => bdet_lote);
  
    apex_collection.update_member(p_collection_name => 'COMPRA_DET_LOTE',
                                  p_seq             => i_seq_id,
                                  p_c001            => bdet_lote.lote_desc,
                                  p_c002            => bdet_lote.lote_codi_barr,
                                  p_c003            => bdet_lote.lote_cant_medi,
                                  p_c004            => bdet_lote.lote_codi,
                                  p_c005            => bdet_lote.deta_prod_codi,
                                  p_c006            => 0, --bdet_lote.deta_nume_item_codi,
                                  p_c007            => bdet_lote.deta_exen_mmnn,
                                  p_c008            => bdet_lote.deta_exen_mone,
                                  p_c009            => bdet_lote.deta_grav10_ii_mmnn,
                                  p_c010            => bdet_lote.deta_grav10_ii_mone,
                                  p_c011            => bdet_lote.deta_grav10_mmnn,
                                  p_c012            => bdet_lote.deta_grav10_mone,
                                  p_c013            => bdet_lote.deta_grav5_ii_mmnn,
                                  p_c014            => bdet_lote.deta_grav5_ii_mone,
                                  p_c015            => bdet_lote.deta_grav5_mmnn,
                                  p_c016            => bdet_lote.deta_grav5_mone,
                                  p_c017            => bdet_lote.deta_impo_mmnn,
                                  p_c018            => bdet_lote.deta_impo_mmnn_ii,
                                  p_c019            => bdet_lote.deta_impo_mone,
                                  p_c020            => bdet_lote.deta_impo_mone_ii,
                                  p_c021            => bdet_lote.deta_iva10_mmnn,
                                  p_c022            => bdet_lote.deta_iva10_mone,
                                  p_c023            => bdet_lote.deta_iva5_mmnn,
                                  p_c024            => bdet_lote.deta_iva5_mone,
                                  p_c025            => bdet_lote.indi_manu_auto,
                                  p_c026            => bdet_lote.s_descuento,
                                  p_c027            => bdet_lote.s_recargo,
                                  p_c028            => bdet_lote.selo_desc_abre,
                                  p_c029            => bdet_lote.selo_ulti_nume,
                                  p_c030            => bdet_lote.lote_ulti_regi,
                                  p_c031            => bdet_lote.impo_mone_ii_bruto,
                                  p_c032            => bdet_lote.deta_prec_unit,
                                  p_d001            => bdet_lote.lote_fech_elab,
                                  p_d002            => bdet_lote.lote_fech_venc);
  
  end;

  procedure pp_iniciar_colecciones as
  begin
    null;
    apex_collection.delete_all_collections_session;
    apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_DET');
    apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_MOCO');
    apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_CONC');
    apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_IMPU');
    apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_REST');
    apex_collection.create_or_truncate_collection(p_collection_name => 'COMPRA_DET_LOTE');
    pack_compra_temp.pa_eliminar_lote_temp(parameter.p_secu_sesi_user_comp,
                                           null,
                                           'T');
  end pp_iniciar_colecciones;

  function fp_get_url_lote(i_movi_mone_cant_deci      in number,
                           i_movi_deta_prod_codi      in number,
                           i_movi_s_recargo           in number,
                           i_impu_indi_baim_impu_incl in varchar2,
                           i_impu_porc                in number,
                           i_impu_porc_base_impo      in number,
                           i_movi_s_descuento         in number,
                           i_movi_deta_precio_unit    in number,
                           i_movi_deta_cant           in number,
                           i_movi_tasa_mone           in number,
                           i_seq_id                   in number)
    return varchar2 as
  
    v_return     varchar2(3000);
    v_parametros varchar2(3000);
    v_valores    varchar2(3000);
  begin
  
    /* pl_me('i_deta_prec_unit=' || i_movi_deta_precio_unit ||
    'i_impu_indi_baim_impu_incl=' || i_impu_indi_baim_impu_incl ||
    'i_impu_porc     =' || i_impu_porc ||
    'i_impu_porc_base_impo    =' || i_impu_porc_base_impo ||
    'i_movi_mone_cant_deci    =' || i_movi_mone_cant_deci ||
    'i_movi_tasa_mone          =' || i_movi_tasa_mone ||
    'i_s_descuento              =' || i_movi_s_descuento ||
    'i_s_recargo                =' || i_movi_s_recargo);*/
  
    v_parametros := 'P3_MOVI_MONE_CANT_DECI';
    v_parametros := v_parametros || ',P3_MOVI_DETA_PROD_CODI';
    v_parametros := v_parametros || ',P3_MOVI_S_RECARGO';
    v_parametros := v_parametros || ',P3_MOVI_S_DESCUENTO';
    v_parametros := v_parametros || ',P3_MOVI_DETA_PRECIO_UNIT';
    v_parametros := v_parametros || ',P3_MOVI_DETA_CANT';
    v_parametros := v_parametros || ',P3_MOVI_DETA_SEQ_ID';
  
    v_parametros := v_parametros || ',P3_IMPU_PORC';
    v_parametros := v_parametros || ',P3_IMPU_PORC_BASE_IMPO';
    v_parametros := v_parametros || ',P3_IMPU_INDI_BAIM_IMPU_INCL';
  
    v_valores := i_movi_mone_cant_deci;
    v_valores := v_valores || ',' || i_movi_deta_prod_codi;
    v_valores := v_valores || ',' || i_movi_s_recargo;
    v_valores := v_valores || ',' || i_movi_s_descuento;
    v_valores := v_valores || ',' || i_movi_deta_precio_unit;
    v_valores := v_valores || ',' || i_movi_deta_cant;
    v_valores := v_valores || ',' || 0;
    --  v_valores := v_valores || ',' || i_seq_id;
  
    v_valores := v_valores || ',' || i_impu_porc;
    v_valores := v_valores || ',' || i_impu_porc_base_impo;
    v_valores := v_valores || ',' || i_impu_indi_baim_impu_incl;
  
    select apex_page.get_url(p_application        => 120,
                             p_page               => 3,
                             p_triggering_element => 'P30_URL_PANT_LOTE',
                             -- p_triggering_element => upper(i_item_name),
                             p_items  => v_parametros,
                             p_values => v_valores) f_url_1
      into v_return
      from dual;
    return v_return;
  end fp_get_url_lote;

  function fp_get_url_cuota(i_movi_mone_cant_deci in number,
                            i_movi_fech_emis      in date,
                            i_movi_impo_mone_ii   in number) return varchar2 as
  
    v_return      varchar2(3000);
    v_parametros  varchar2(3000);
    v_app_id      number := v('APP_ID');
    v_app_page_id number := v('APP_PAGE_ID');
  begin
  
    v_parametros := 'P32_MOVI_MONE_CANT_DECI';
    v_parametros := v_parametros || ',P32_MOVI_FECH_EMIS';
    v_parametros := v_parametros || ',P32_MOVI_IMPO_MONE_II';
    v_parametros := v_parametros || ',P32_APP_ID_ORIG';
    v_parametros := v_parametros || ',P32_PAGE_ID_ORIG';
  
    select apex_page.get_url(p_application => 120,
                             p_page        => 32,
                             --p_triggering_element => 'P30_URL_MODAL',
                             -- p_triggering_element => upper(i_item_name),
                             p_items  => v_parametros,
                             p_values => i_movi_mone_cant_deci || ',' ||
                                         i_movi_fech_emis || ',' ||
                                         i_movi_impo_mone_ii || ',' ||
                                         v_app_id || ',' || v_app_page_id) f_url_1
    
      into v_return
      from dual;
    return v_return;
  end fp_get_url_cuota;

  procedure pp_devu_timb(i_tico_codi       in number,
                         i_esta            in number,
                         i_punt_expe       in number,
                         i_clpr_codi       in number,
                         i_fech_movi       in date,
                         i_tico_indi_timb  in char,
                         o_nume_timb       out varchar2,
                         o_ind_varios_timb out varchar2) is
  
    v_nume_timb varchar2(20);
    v_fech_venc date;
    v_indi_espo varchar2(1) := upper('n');
  begin
    if nvl(i_tico_indi_timb, 'C') <> 'S' then
      select cptc_nume_timb, cptc_fech_venc
        into v_nume_timb, v_fech_venc
        from come_clpr_tipo_comp
       where cptc_clpr_codi = i_clpr_codi --proveedor, cliente
         and cptc_tico_codi = i_tico_codi --tipo de comprobante
         and cptc_esta = i_esta --establecimiento 
         and cptc_punt_expe = i_punt_expe --punto de expedicion
         and cptc_fech_venc >= i_fech_movi
       order by cptc_fech_venc;
    
    else
      select setc_nume_timb, setc_fech_venc
        into v_nume_timb, v_fech_venc
        from come_secu_tipo_comp
       where setc_secu_codi =
             (select peco_secu_codi
                from come_pers_comp
               where peco_codi = parameter.p_peco_codi)
         and setc_tico_codi = i_tico_codi --tipo de comprobante
         and setc_esta = i_esta --establecimiento 
         and setc_punt_expe = i_punt_expe --punto de expedicion
         and setc_fech_venc >= i_fech_movi
       order by setc_fech_venc;
    end if;
    o_nume_timb       := v_nume_timb;
    o_ind_varios_timb := 'N';
    --o_ind_varios_timb := 'S';
  exception
    when no_data_found then
      pl_me('El proveedor no tiene un timbrado vigente. Favor verificar.');
    when too_many_rows then
      null;
      o_ind_varios_timb := 'S';
    
    /*
    set_item_property('bcab.s_nro_3', lov_name, 'lov_nume_timb');
    list_values;
    if :parameter.p_clie_prov = upper('p') then
      if :bcab.s_clpr_codi_alte = :parameter.p_codi_prov_espo then
        v_indi_espo := upper('s');
      end if;
    else
      if :bcab.s_clpr_codi_alte = :parameter.p_codi_clie_espo then
        v_indi_espo := upper('s');
      end if;
    end if;
    if nvl(:bcab.tico_indi_habi_timb, 'N') = 'N' then
      set_item_property('bcab.movi_nume_timb', enabled, property_false);
      set_item_property('bcab.s_fech_venc_timb', enabled, property_false);
      if nvl(v_indi_espo, 'N') = 'S' then
        set_item_property('bcab.movi_nume_timb', enabled, property_true);
        set_item_property('bcab.s_fech_venc_timb',
                          enabled,
                          property_true);
        set_item_property('bcab.movi_nume_timb',
                          navigable,
                          property_true);
        set_item_property('bcab.s_fech_venc_timb',
                          navigable,
                          property_true);
      end if;
    else
      set_item_property('bcab.movi_nume_timb', enabled, property_true);
      set_item_property('bcab.s_fech_venc_timb', enabled, property_true);
    
      set_item_property('bcab.movi_nume_timb', navigable, property_true);
      set_item_property('bcab.s_fech_venc_timb',
                        navigable,
                        property_true);
    end if;
    */
    when others then
      pl_me('Error al recuperar timbrado.');
  end pp_devu_timb;

  procedure pp_validar_timbrado(p_tico_codi      in number,
                                p_esta           in number,
                                p_punt_expe      in number,
                                p_clpr_codi      in number,
                                p_fech_movi      in date,
                                p_timb           out varchar2,
                                p_fech_venc      out date,
                                p_tico_indi_timb in varchar2) is
  
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
  begin
  
    --p30_p_ind_clpr
  
    /*if nvl(bcab.tico_indi_timb_auto, 'N') = 'S' then
      if nvl(p_tico_indi_timb, 'C') = 'P' then
        if parameter.p_clie_prov = upper('p') and
           nvl(v_indi_espo, 'N') = 'N' then
          for x in c_timb loop
            v_indi_entro := upper('s');
            if bcab.movi_nume_timb is not null then
              p_timb      := bcab.movi_nume_timb;
              p_fech_venc := bcab.fech_venc_timb;
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
          if bcab.movi_nume_timb is not null then
            p_timb      := bcab.movi_nume_timb;
            p_fech_venc := bcab.fech_venc_timb;
          else
            p_timb      := y.deta_nume_timb;
            p_fech_venc := y.deta_fech_venc;
          end if;
          exit;
        end loop;
      elsif nvl(p_tico_indi_timb, 'C') = 'S' then
        for x in c_timb_3 loop
          v_indi_entro := upper('s');
          if bcab.movi_nume_timb is not null then
            p_timb      := bcab.movi_nume_timb;
            p_fech_venc := bcab.fech_venc_timb;
          else
            p_timb      := x.setc_nume_timb;
            p_fech_venc := x.setc_fech_venc;
          end if;
          exit;
        end loop;
      end if;
    end if;
    
    if v_indi_entro = upper('n') and
       nvl(upper(bcab.tico_indi_vali_timb), 'N') = 'S' then
      pl_me('No existe registro de timbrado cargado para este proveedor, o el timbrado cargado se encuentra vencido!!!');
    end if;*/
    null;
  end;

  function fp_ind_hab_timbrado(i_ind_ocasional       in varchar2,
                               i_tico_indi_habi_timb in varchar2)
    return varchar2 is
    v_indi_espo varchar2(1);
    v_return    varchar2(1) := 'N';
  begin
    --    set_item_property('bcab.s_nro_3', lov_name, 'lov_nume_timb');
  
    v_indi_espo := upper(nvl(i_ind_ocasional, 'N'));
  
    if nvl(i_tico_indi_habi_timb, 'N') = 'N' then
      /* set_item_property('bcab.movi_nume_timb', enabled, property_false);
      set_item_property('bcab.s_fech_venc_timb', enabled, property_false);*/
      v_return := 'N';
      if nvl(v_indi_espo, 'N') = 'S' then
        /* set_item_property('bcab.movi_nume_timb', enabled, property_true);
        set_item_property('bcab.s_fech_venc_timb', enabled, property_true);
        set_item_property('bcab.movi_nume_timb', navigable, property_true);
        set_item_property('bcab.s_fech_venc_timb',
                          navigable,
                          property_true);*/
        v_return := 'S';
      end if;
    else
      /* set_item_property('bcab.movi_nume_timb', enabled, property_true);
      set_item_property('bcab.s_fech_venc_timb', enabled, property_true);
      set_item_property('bcab.movi_nume_timb', navigable, property_true);
      set_item_property('bcab.s_fech_venc_timb', navigable, property_true);*/
      v_return := 'S';
    end if;
    return v_return;
  end fp_ind_hab_timbrado;

  procedure pp_validar_nro(i_movi_nume           in number,
                           i_movi_oper_codi      in number,
                           i_emit_reci           in varchar2,
                           i_tico_fech_rein      in date,
                           i_tico_indi_vali_nume in varchar2,
                           i_movi_clpr_codi      in number,
                           o_msj_val_nro         out varchar2) is
    v_count   number;
    v_message varchar2(100);
    salir exception;
  
  begin
  
    --pl_me('*'||i_emit_reci||'*');
    if i_emit_reci = 'R' then
      select count(*)
        into v_count
        from come_movi
       where movi_nume = i_movi_nume
         and movi_clpr_codi = i_movi_clpr_codi
         and movi_oper_codi = i_movi_oper_codi
         and movi_fech_emis >
             nvl(i_tico_fech_rein, to_date('01/01/1000', 'dd/mm/yyyy'));
    
      if nvl(i_tico_indi_vali_nume, 'N') = 'S' then
        v_message := 'Ya existe un comprobante con este nro para este proveedor, favor verifique!!';
        if v_count > 0 then
          o_msj_val_nro := rtrim(ltrim(v_message));
          --pl_me(rtrim(ltrim(v_message)));
        end if;
      end if;
    elsif i_emit_reci = 'E' then
      select count(*)
        into v_count
        from come_movi
       where movi_nume = i_movi_nume
         and movi_oper_codi = i_movi_oper_codi
         and movi_fech_emis >
             nvl(i_tico_fech_rein, to_date('01/01/1000', 'dd/mm/yyyy'));
      if nvl(i_tico_indi_vali_nume, 'N') = 'S' then
        v_message := 'Ya existe un comprobante con esta operacion, favor verifique!!';
        if v_count > 0 then
          o_msj_val_nro := rtrim(ltrim(v_message));
          --pl_mm(rtrim(ltrim(v_message)));
        end if;
      end if;
    end if;
  exception
    when salir then
      pl_me('Reigrese el nro de comprobante');
  end pp_validar_nro;

  procedure pp_llamar_reporte(i_movi_codi in number) is
    cursor cur_doc is
      select movi_nume,
             movi_fech_emis,
             movi_obse,
             movi_user,
             oper_codi,
             oper_desc,
             sucu_codi,
             sucu_desc,
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
             exen_mone,
             grav10_mone,
             grav5_mone,
             iva10_mone,
             iva5_mone,
             tot_iva,
             tot_mone,
             movi_fech_grab,
             deta_nume_item,
             deta_cant,
             deta_prec_unit,
             importe_desc,
             prec_unit_desc,
             tot_item,
             prod_codi_alfa,
             prod_desc,
             medi_desc_abre,
             deta_cant_medi,
             lote_desc
        from (select m.movi_codi,
                     (substr(lpad(to_char(m.movi_nume), 13, '0'), 1, 3) || '-' ||
                     substr(lpad(to_char(m.movi_nume), 13, '0'), 4, 3) || '-' ||
                     substr(lpad(to_char(m.movi_nume), 13, '0'), 7, 8)) movi_nume,
                     m.movi_fech_emis,
                     m.movi_obse,
                     m.movi_user,
                     o.oper_codi,
                     o.oper_desc,
                     so.sucu_codi sucu_codi,
                     so.sucu_desc sucu_desc,
                     do.depo_codi depo_codi,
                     do.depo_desc depo_desc,
                     t.timo_codi,
                     t.timo_desc,
                     e.empr_codi,
                     e.empr_desc,
                     o.mone_codi,
                     o.mone_desc,
                     o.mone_cant_deci,
                     cb.cuen_codi,
                     cb.cuen_desc,
                     cp.clpr_codi_alte clpr_codi,
                     cp.clpr_desc,
                     decode(cp.clpr_indi_clie_prov,
                            'C',
                            'Cliente',
                            'P',
                            'Proveedor',
                            null) clpr_label,
                     sum(decode(ip.moim_impu_codi, 1, ip.moim_impo_mone, 0)) exen_mone,
                     sum(decode(ip.moim_impu_codi, 2, ip.moim_impo_mone, 0)) grav10_mone,
                     sum(decode(ip.moim_impu_codi, 3, ip.moim_impo_mone, 0)) grav5_mone,
                     sum(decode(ip.moim_impu_codi, 2, ip.moim_impu_mone, 0)) iva10_mone,
                     sum(decode(ip.moim_impu_codi, 3, ip.moim_impu_mone, 0)) iva5_mone,
                     sum(ip.moim_impu_mone) tot_iva,
                     sum(ip.moim_impu_mone + ip.moim_impo_mone) tot_mone,
                     m.movi_fech_grab
                from come_movi           m,
                     come_stoc_oper      o,
                     come_sucu           so,
                     come_depo           do,
                     come_tipo_movi      t,
                     come_empr           e,
                     come_mone           o,
                     come_clie_prov      cp,
                     come_movi_impu_deta ip,
                     come_cuen_banc      cb
               where m.movi_oper_codi = o.oper_codi
                 and m.movi_sucu_codi_orig = so.sucu_codi
                 and m.movi_depo_codi_orig = do.depo_codi
                 and m.movi_timo_codi = t.timo_codi(+)
                 and m.movi_empr_codi = e.empr_codi(+)
                 and m.movi_mone_codi = o.mone_codi(+)
                 and m.movi_clpr_codi = cp.clpr_codi(+)
                 and m.movi_cuen_codi = cb.cuen_codi(+)
                 and m.movi_codi = ip.moim_movi_codi(+)
               group by m.movi_codi,
                        m.movi_nume,
                        m.movi_fech_emis,
                        m.movi_obse,
                        m.movi_user,
                        o.oper_codi,
                        o.oper_desc,
                        so.sucu_codi,
                        so.sucu_desc,
                        do.depo_codi,
                        do.depo_desc,
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
                        decode(cp.clpr_indi_clie_prov,
                               'C',
                               'Cliente',
                               'P',
                               'Proveedor',
                               null),
                        m.movi_fech_grab) cab,
             (select d.deta_nume_item,
                     d.deta_cant,
                     d.deta_prec_unit,
                     ((((d.deta_prec_unit) * d.deta_cant) -
                     (d.deta_impo_mone_ii)) / d.deta_cant) importe_desc,
                     ((d.deta_prec_unit) -
                     ((((d.deta_prec_unit) * d.deta_cant) -
                     (d.deta_impo_mone_ii)) / d.deta_cant)) prec_unit_desc,
                     (nvl(d.deta_impo_mone, 0) +
                     nvl((d.deta_iva5_mone + d.deta_iva10_mone), 0)) tot_item,
                     p.prod_codi_alfa,
                     p.prod_desc,
                     u.medi_desc_abre,
                     d.deta_cant_medi,
                     l.lote_desc,
                     m.movi_codi
                from come_movi           m,
                     come_movi_prod_deta d,
                     come_prod           p,
                     come_unid_medi      u,
                     come_lote           l
               where m.movi_codi = d.deta_movi_codi
                 and d.deta_prod_codi = p.prod_codi
                 and d.deta_medi_codi = u.medi_codi(+)
                 and d.deta_lote_codi = l.lote_codi(+)) det
       where cab.movi_codi = det.movi_codi
         and cab.movi_codi = i_movi_codi;
  
    v_parametros   clob;
    v_contenedores clob;
    v_session      number := v('APP_SESSION');
    v_user         varchar2(100) := gen_user;
  begin
  
    begin
      -- Call the procedure
      pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => v_session,
                                         i_taax_user => v_user);
    end;
  
    /*
     delete come_tabl_auxi
    where taax_sess = i_app_session
      and taax_user = gen_user;*/
  
    for c in cur_doc loop
      -- Call the procedure
      pack_mane_tabl_auxi.pp_add_members(i_taax_sess => v_session,
                                         i_taax_user => v_user,
                                         i_taax_c001 => c.movi_nume,
                                         i_taax_c002 => c.movi_fech_emis,
                                         i_taax_c003 => c.movi_obse,
                                         i_taax_c004 => c.movi_user,
                                         i_taax_c005 => c.oper_codi,
                                         i_taax_c006 => c.oper_desc,
                                         i_taax_c007 => c.sucu_codi,
                                         i_taax_c008 => c.sucu_desc,
                                         i_taax_c009 => c.depo_codi,
                                         i_taax_c010 => c.depo_desc,
                                         i_taax_c011 => c.timo_codi,
                                         i_taax_c012 => c.timo_desc,
                                         i_taax_c013 => c.empr_codi,
                                         i_taax_c014 => c.empr_desc,
                                         i_taax_c015 => c.mone_codi,
                                         i_taax_c016 => c.mone_desc,
                                         i_taax_c017 => c.mone_cant_deci,
                                         i_taax_c018 => c.cuen_codi,
                                         i_taax_c019 => c.cuen_desc,
                                         i_taax_c020 => c.clpr_codi,
                                         i_taax_c021 => c.clpr_desc,
                                         i_taax_c022 => c.clpr_label,
                                         i_taax_c023 => c.exen_mone,
                                         i_taax_c024 => c.grav10_mone,
                                         i_taax_c025 => c.grav5_mone,
                                         i_taax_c026 => c.iva10_mone,
                                         i_taax_c027 => c.iva5_mone,
                                         i_taax_c028 => c.tot_iva,
                                         i_taax_c029 => c.tot_mone,
                                         i_taax_c030 => c.movi_fech_grab,
                                         i_taax_c031 => c.deta_nume_item,
                                         i_taax_c032 => c.deta_cant,
                                         i_taax_c033 => c.deta_prec_unit,
                                         i_taax_c034 => c.importe_desc,
                                         i_taax_c035 => c.prec_unit_desc,
                                         i_taax_c036 => c.tot_item,
                                         i_taax_c037 => c.prod_codi_alfa,
                                         i_taax_c038 => c.prod_desc,
                                         i_taax_c039 => c.medi_desc_abre,
                                         i_taax_c040 => c.deta_cant_medi,
                                         i_taax_c041 => c.lote_desc);
    
    end loop;
  
    v_contenedores := 'p_app_session:p_app_user';
  
    v_parametros := v_session || ':' || chr(39) || gen_user || chr(39);
  
    delete from come_parametros_report where usuario = v_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, v_user, 'I020003', 'pdf', v_contenedores);
  
    -- commit;
    null;
  end pp_llamar_reporte;

begin
  pp_cargar_parametros;
end i020003;
