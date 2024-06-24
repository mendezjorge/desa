
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020089" is

  type r_variable is record(
    orpa_codi        number,
    s_indi_dife      varchar2(2),
    orpa_nume        number,
    orpa_nume_orig   number,
    movi_fech_emis   date,
    s_impo_mone1     number,
    s_impo_sald      number:=0,
    operacion        varchar2(4),
    s_impo_rete      number,
    s_impo_rete_rent number,
    
    ----------
    movi_codi number,
    orpa_empr_codi      number,
    orpa_sucu_codi      number,
    orpa_impo_mone      number,
    orpa_impo_mmnn      number,
    orpa_user           varchar2(20),
    orpa_rete_mone      number,
    orpa_rete_mmnn      number,
    orpa_base           number,
    orpa_estado         varchar2(100),
    orpa_obse           varchar2(500),
    orpa_tasa_mmee      number,
    orpa_ind_planif     varchar2(2),
    orpa_rete_movi_codi number,
    movi_clpr_ruc       varchar(100),
    movi_emit_reci      varchar(100),
    movi_empr_codi      number,
    movi_sucu_codi_orig number,
    movi_timo_codi      number,
    ---suma del detalle 
    
    SUM_S_MOCO_IMPO      number,
    F_TOT_DETA_IMPO_MONE number,
    
    ---suma de importe
    s_impo_tarj          number,
    s_impo_adel          number,
    s_impo_efec          number,
    s_impo_cheq          number,
    s_impo_mmnn2         number,
    s_impo_mone2         number,
    s_cuen_codi2         number,
    s_mone_codi2         number,
    s_tasa_mone2         number,
    s_impo_mmnn1         number,
    cont_codi            number,
    f_diferencia         number,
    f_tot_retencion_mone number,
    
    ---Suma de forma de pago
    
    tota_efec_ingr number,
    tota_efec_egre number,
    tota_cheq_ingr number,
    tota_cheq_egre number,
    tota_fact      number,
    
    movi_mone_codi      number,
    movi_fech_oper      date,
    movi_tasa_mone      number:= v('P14_MOVI_TASA_MONE'),
    movi_exen_mmnn      number,
    movi_exen_mone      number,
    movi_cuen_codi      number,
    movi_clpr_codi      number,
    movi_clpr_desc      varchar2(500),
    movi_dbcr           varchar2(2),
    movi_mone_cant_deci number,
    
    ---recibo
    reci_fech   date,
    s_reci_nume number,
    
    ----tipo movimiento
    timo_dbcr_caja varchar2(10),
    movi_dbcr_caja varchar2(10)
    
    );
  bcab r_variable;

  type r_rete is record(
    movi_nume_rete           number,
    movi_nume_timb_rete      number,
    movi_fech_venc_timb_rete date);
  brete r_rete;

  type r_parameter is record(
    p_codi_base           number := pack_repl.fa_devu_codi_base,
    p_peco_codi           number := 1,
    p_empr_codi           number := v('AI_EMPR_CODI'),
    p_sucu_codi           number := v('AI_SUCU_CODI'),
    p_indi_most_mens_sali varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_sali'))),
    p_form_impr_fact      varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_fact'))),
    p_codi_tipo_empl_vend number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_vend')),
    p_codi_impu_inte_cobr number := to_number(general_skn.fl_busca_parametro('p_codi_impu_inte_cobr')),
    
    p_codi_tipo_empl_cobr number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_cobr')),
    p_indi_impr_cheq_emit varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_impr_cheq_emit'))),
    p_indi_most_form_entr varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_form_entr'))),
    p_indi_obli_form_entr varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_obli_form_entr'))),
    p_codi_conc_inte_cobr number := to_number(general_skn.fl_busca_parametro('p_codi_conc_inte_cobr')),
    
    p_codi_mone_dola      number := to_number(general_skn.fl_busca_parametro('p_codi_mone_dola')),
    p_codi_form_pago_defa number := to_number(general_skn.fl_busca_parametro('p_codi_form_pago_defa')),
    p_indi_perm_timo_bole varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_perm_timo_bole'))),
    p_codi_timo_pcoe      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_pcoe')),
    p_codi_timo_pcre      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_pcre')),
    p_codi_clie_espo      number := to_number(general_skn.fl_busca_parametro('p_codi_clie_espo')),
    
    p_indi_nave_form_pago varchar2(50) := 'N',
    p_indi_most_form_pago varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_form_pago'))),
    p_vali_deto_matr_prec varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_vali_deto_matr_prec'))),
    
    --p_codi_timo_reem       := to_number(general_skn.fl_busca_parametro('p_codi_timo_reem')),
    p_codi_timo_rere              number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rere')),
    p_codi_conc_rete_reci_rent    number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_reci_rent')),
    p_codi_conc_rete_reci_ley_530 number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_reci_ley_530_37')),
    
    p_indi_vali_repe_cheq varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_repe_cheq'))),
    
    p_codi_conc_pago_prov number := to_number(general_skn.fl_busca_parametro('p_codi_conc_pago_prov')),
    --p_codi_conc_cobr_clie  := to_number(general_skn.fl_busca_parametro('p_codi_conc_cobr_clie')),
    
    p_codi_impu_grav10 number := to_number(general_skn.fl_busca_parametro('p_codi_impu_grav10')),
    p_codi_impu_grav5  number := to_number(general_skn.fl_busca_parametro('p_codi_impu_grav5')),
    
    p_codi_impu_exen number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_codi_mone_mmnn number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_codi_mone_mmee number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmee')),
    
    p_cant_deci_porc number := to_number(general_skn.fl_busca_parametro('p_cant_deci_porc')),
    p_cant_deci_mmnn number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_cant_deci_mmee number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmee')),
    p_cant_deci_cant number := to_number(general_skn.fl_busca_parametro('p_cant_deci_cant')),
    
    p_codi_timo_rete_emit number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rete_emit')),
    p_codi_timo_pago_pres number := to_number(general_skn.fl_busca_parametro('p_codi_timo_pago_pres')),
    
    p_imp_min_aplic_reten number := to_number(general_skn.fl_busca_parametro('p_imp_min_aplic_reten')),
    p_porc_aplic_reten    number := to_number(general_skn.fl_busca_parametro('p_porc_aplic_reten')),
    p_codi_conc_rete_emit number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_emit')),
    
    p_codi_conc_rete_reci number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_reci')),
    
    p_codi_timo_rete_reci number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rete_reci')),
    
    p_codi_prov_espo number := to_number(general_skn.fl_busca_parametro('p_codi_prov_espo')),
    
    p_codi_timo_depo_banc number := to_number(general_skn.fl_busca_parametro('p_codi_timo_depo_banc')),
    p_codi_timo_extr_banc number := to_number(general_skn.fl_busca_parametro('p_codi_timo_extr_banc')),
    p_codi_conc_depo_mone number := to_number(general_skn.fl_busca_parametro('p_codi_conc_depo_mone')),
    p_codi_conc_extr_mone number := to_number(general_skn.fl_busca_parametro('p_codi_conc_extr_mone')),
    p_codi_timo_orde_pago number := to_number(general_skn.fl_busca_parametro('p_codi_timo_orde_pago')),
    p_codi_conc_orde_pago number := to_number(general_skn.fl_busca_parametro('p_codi_conc_orde_pago')),
    p_codi_conc_pago_pres number := to_number(general_skn.fl_busca_parametro('p_codi_conc_pago_pres')),
    
    p_codi_conc_cheq_cred number := to_number(general_skn.fl_busca_parametro('p_codi_conc_cheq_cred')),
    
    p_indi_fopa_chta_caja varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_fopa_chta_caja'))),
    
    p_indi_obli_form_pago varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_obli_form_pago'))),
    
    /*pp_muestra_desc_mone(p_codi_mone_mmee,
                                                       p_desc_mone_mmee,
                                                       p_cant_deci_mmee),*/
    
    p_codi_timo_rcnadle number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rcnadle')),
    p_codi_timo_cnncre  number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnncre')),
    p_codi_timo_rcnadlr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rcnadlr')),
    p_codi_timo_cnncrr  number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnncrr')),
    p_codi_timo_pcor    number := to_number(general_skn.fl_busca_parametro('p_codi_timo_pcor')),
    
    p_emit_reci varchar2(10) := 'R',
    
    p_codi_conc number := to_number(general_skn.fl_busca_parametro('p_codi_conc_pago_prov')),
    
    p_indi_porc_rete_sucu      varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_porc_rete_sucu'))),
    p_soli_impr_rete_cheq      varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_soli_impr_rete_cheq'))),
    p_nave_dato_rete           varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_nave_dato_rete'))),
    p_indi_nave_dato_rete      varchar2(50) := 'N',
    p_form_calc_rete_emit      number := to_number(general_skn.fl_busca_parametro('p_form_calc_rete_emit')),
    p_form_impr_orde_pago      varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_orde_pago'))),
    p_form_impr_orde_pago_pres varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_orde_pago_pres'))),
    p_form_impr_orde_pago_fini varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_orde_pago_fini'))),
    
    p_form_impr_bole_gast_prov varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_bole_gast_prov'))),
    
    p_form_impr_adel_prov varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_adel_prov'))),
    p_codi_timo_adle      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_adle')),
    p_codi_timo_adlr      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_adlr')),
    p_codi_conc_adlr      number := to_number(general_skn.fl_busca_parametro('p_codi_conc_adlr')),
    
    p_codi_timo_valr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_valr')),
    
    p_codi_timo_auto_fact_emit    number := to_number(general_skn.fl_busca_parametro('p_codi_timo_auto_fact_emit')),
    p_codi_timo_auto_fact_emit_cr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_auto_fact_emit_cr')),
    
    p_indi_apli_rete_exen varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_apli_rete_exen'))),
    
    p_indi_perm_fech_vale_supe varchar2(50) := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_perm_fech_vale_supe'))),
    
    p_habi_camp_cent_cost_dbcr varchar2(50) := rtrim(ltrim(general_skn.fl_busca_parametro('p_habi_camp_cent_cost_dbcr'))),
    p_auto_gene_fini_orde_pago varchar2(50) := rtrim(ltrim(general_skn.fl_busca_parametro('p_auto_gene_fini_orde_pago'))),
    
    p_codi_oper_vta number := to_number(general_skn.fl_busca_parametro('p_codi_oper_vta')),
    --  p_codi_oper     := p_codi_oper_vta,
    
    p_form_impr_rete number := to_number(general_skn.fl_busca_parametro('p_form_impr_rete')),
    
    p_modi_fech_fopa_dife varchar2(50) := ltrim(rtrim(general_skn.fl_busca_parametro('p_modi_fech_fopa_dife'))),
    
    p_form_impr_op_tv  varchar2(50) := ltrim(rtrim((general_skn.fl_busca_parametro('p_form_impr_op_tv')))),
    p_impr_cheq_op     varchar2(50) := upper(ltrim(rtrim((general_skn.fl_busca_parametro('p_impr_cheq_op'))))),
    p_indi_rete_tesaka varchar2(50) := ltrim(rtrim((general_skn.fl_busca_parametro('p_indi_rete_tesaka')))),
    
    --pa_devu_fech_habi(p_fech_inic, p_fech_fini),
    
    p_indi_vali_auto_firm_cheq_op varchar2(50) := ltrim(rtrim((general_skn.fl_busca_parametro('p_indi_vali_auto_firm_cheq_op')))),
    
    p_indi_exis_orpa      varchar2(50):=v('P14_INDI_EXIS_ORPA'),
    p_movi_codi_rete_auxi number,
    p_movi_codi_orde      number,
    p_movi_codi_rete      number,
    p_movi_nume_rete      number,
    p_movi_codi_rere      number,
    p_movi_codi_rere_pa   number,
    p_movi_codi_trva      number,
    p_movi_codi_adpr      number,
    p_movi_codi_pcor      number,
    p_para_inic           varchar2(10):=v('P14_PARA_INIC'),
    p_indi_perm_modi_fech varchar2(10),
    p_movi_timo_codi      number,
    p_movi_codi_vale      number
    
    );
  parameter r_parameter;

  cursor forma_pago is
    select seq_id,
           c001 fopa_codi,
           c002 fopa_dbcr,
           c003 fopa_desc,
           c004 fopa_indi_afec_caja,
           c005 fopa_suma_rest,
           c006 moim_cuen_codi
      from apex_collections_full
     where collection_name = 'FORMA_PAGO'
       and c049 =v('APP_ID')
       and c050 = v('APP_PAGE_ID');

      
      
      
     

  cursor detalle is
    select seq_id deta_item,
           c001 ind_marcado,
           c002 s_movi_nume,
           c003 s_movi_fech_emis,
           c004 deta_cuot_fech_venc,
           c005 s_cuot_impo_mone,
           c006 s_cuot_sald_mone,
           c007 deta_cuot_movi_codi,
           c008 s_timo_desc_abre,
           c009 s_movi_grav_mone,
           c010 s_movi_grav_mmnn,
           c012 s_movi_iva_mone,
           c013 s_movi_iva_mmnn,
           c014 s_movi_codi_rete,
           nvl(c015, parameter.p_codi_base) deta_base,
           c016 deta_orpa_codi,
           c017 deta_impo_mone,
           nvl(round((c017 * bcab.movi_tasa_mone),
                     parameter.p_cant_deci_mmnn),
               0) deta_impo_mmnn,
           --c018   deta_impo_mmnn,
           c019 deta_rete_iva_mone,
           nvl(round((c019 * bcab.movi_tasa_mone),
                     parameter.p_cant_deci_mmnn),
               0) deta_rete_iva_mmnn,
           --c020   deta_rete_iva_mmnn,
           c021 deta_rete_ren_mone,
           nvl(round((c021 * bcab.movi_tasa_mone),
                     parameter.p_cant_deci_mmnn),
               0) deta_rete_ren_mmnn,
           --c022   deta_rete_ren_mmnn,
           c023 moim_tasa_mone,
           c024 S_RETENCION_MONE,
           c025 RETE_NUME,
           c026 S_RECI_NUME_DETA,
          case when c001='X' then
             nvl(c027,'S' )
             else c027 end apli_rete
      from apex_collections a
     where collection_name = 'BDETALLE'
       and c001 = 'X';

  cursor deta is
    select c001 moco_conc_codi,
           c002 moco_impu_codi,
           c003 s_moco_impo,
           c004 moco_dbcr,
           c005 tiim_codi,
           c006 moco_impo_codi,
           c007 cent_cost_codi,
           c008 s_cuco_nume,
           c009 s_cuco_desc,
           c010 s_moco_impo_ii,
           c011 s_moco_iva,
           c012 s_total_item
      from apex_collections a
     where collection_name = 'BCONCEPTO';

  procedure pp_muestra_tipo_movi(p_timo_codi      in number,
                                 p_timo_afec_sald out varchar2,
                                 p_timo_emit_reci out varchar2,
                                 p_timo_dbcr      out varchar2,
                                 p_tica_codi      out number) is
  begin
    select timo_afec_sald, timo_emit_reci, timo_dbcr, timo_tica_codi
      into p_timo_afec_sald, p_timo_emit_reci, p_timo_dbcr, p_tica_codi
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
  exception
    when no_data_found then
      p_timo_afec_sald := null;
      p_timo_emit_reci := null;
      p_timo_dbcr      := null;
      raise_application_error(-20001, 'Tipo de Movimiento inexistente');
    when too_many_rows then
      raise_application_error(-20001, 'Tipo de Movimiento duplicado');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_tipo_movi;

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
      --if :bcab.movi_tasa_mone is not null then
      --p_mone_coti := :bcab.movi_tasa_mone;
      --else
      p_mone_coti := null;
      raise_application_error(-20001,
                              'Cotizacion Inexistente para la fecha del documento!!!'); --, debe ingresar la tasa manualmente!!!!');
    --end if;
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

  procedure pp_veri_perm_modi_fech(p_indi out varchar2) is
  
  begin
  
    select nvl(user_indi_modi_fech_orpa, 'N')
      into p_indi
      from segu_user s
     where s.user_login = gen_user;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_veri_perm_modi_fech;

  PROCEDURE pp_valida_operacion(p_operacion                in varchar2,
                                p_timo_tica_codi           out number,
                                p_TIMO_INDI_APLI_ADEL_FOPA out varchar2,
                                p_movi_dbcr                out varchar2,
                                p_movi_dbcr_caja           out varchar2,
                                p_s_timo_calc_iva          out varchar2,
                                p_movi_timo_codi           out varchar2) IS
  BEGIN
    if p_operacion = 'OP' then
    
      begin
        select m.timo_tica_codi,
               TIMO_INDI_APLI_ADEL_FOPA,
               timo_dbcr,
               timo_dbcr_caja,
               timo_calc_iva,
               timo_codi
          into p_timo_tica_codi,
               p_TIMO_INDI_APLI_ADEL_FOPA,
               p_movi_dbcr,
               p_movi_dbcr_caja,
               p_s_timo_calc_iva,
               p_movi_timo_codi
          from come_tipo_movi m
         where m.timo_codi = parameter.p_codi_timo_orde_pago;
      
        if p_timo_tica_codi is null then
          raise_application_error(-20001,
                                  'Debe configurar el tipo de cambio para el tipo de movimiento ' ||
                                  parameter.p_codi_timo_orde_pago);
        end if;
      
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'El tipo de movimiento configurado para ordenes de pagos no existe!.');
        
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    
    elsif p_operacion = 'TV' then
    
      begin
        select m.timo_tica_codi,
               timo_dbcr_caja,
               timo_dbcr,
               timo_calc_iva,
               timo_codi
          into p_timo_tica_codi,
               p_movi_dbcr_caja,
               p_movi_dbcr,
               p_s_timo_calc_iva,
               p_movi_timo_codi
          from come_tipo_movi m
         where m.timo_codi = parameter.p_codi_timo_extr_banc;
      
        if p_timo_tica_codi is null then
          raise_application_error(-20001,
                                  'Debe configurar el tipo de cambio para el tipo de movimiento ' ||
                                  parameter.p_codi_timo_extr_banc);
        end if;
      
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'El tipo de movimiento configurado para extraccion bancaria no existe!.');
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    
    elsif p_operacion = 'AP' then
    
      begin
        select m.timo_tica_codi,
               timo_dbcr_caja,
               timo_dbcr,
               timo_calc_iva,
               timo_codi
          into p_timo_tica_codi,
               p_movi_dbcr_caja,
               p_movi_dbcr,
               p_s_timo_calc_iva,
               p_movi_timo_codi
          from come_tipo_movi m
         where m.timo_codi = parameter.p_codi_timo_adlr;
      
        if p_timo_tica_codi is null then
          raise_application_error(-20001,
                                  'Debe configurar el tipo de cambio para el tipo de movimiento ' ||
                                  parameter.p_codi_timo_adlr);
        end if;
      
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'El tipo de movimiento configurado para extraccion bancaria no existe!.');
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    
    elsif p_operacion = 'VB' then
      --VB
      begin
        select m.timo_tica_codi,
               timo_dbcr_caja,
               timo_dbcr,
               timo_calc_iva,
               timo_codi
          into p_timo_tica_codi,
               p_movi_dbcr_caja,
               p_movi_dbcr,
               p_s_timo_calc_iva,
               p_movi_timo_codi
          from come_tipo_movi m
         where m.timo_codi = parameter.p_codi_timo_pcor;
      
        if p_timo_tica_codi is null then
          raise_application_error(-20001,
                                  'Debe configurar el tipo de cambio para el tipo de movimiento ' ||
                                  parameter.p_codi_timo_pcor);
        end if;
      
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'El tipo de movimiento configurado para extraccion bancaria no existe!.');
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    end if;
  END pp_valida_operacion;

  procedure pp_vali_cont_chac(p_cont_codi      in number,
                              p_movi_clpr_codi in number) is
    v_clpr_codi      number;
    v_cont_indi_acti varchar2(1) := 'S';
  begin
    select cont_clpr_codi, nvl(cont_indi_acti, 'S')
      into v_clpr_codi, v_cont_indi_acti
      from chac_cont
     where cont_codi = p_cont_codi;
  
    if v_clpr_codi <> p_movi_clpr_codi then
      raise_application_error(-20001,
                              'El proveedor del adelanto no coincide con el proveedor del contrato seleccionado!!');
    end if;
  
    if v_cont_indi_acti = 'N' then
      raise_application_error(-20001,
                              'El contrato no se encuentra activo!!');
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Contrato de Chacra Inexistente!!');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_vali_cont_chac;

  procedure pp_validar_fec_emi(p_movi_fech_emis date,
                               p_ejec_cons      in out varchar2) is
  begin
  
    if parameter.p_para_inic <> 'FINI' then
      pp_veri_perm_modi_fech(parameter.p_indi_perm_modi_fech);
      if parameter.p_indi_perm_modi_fech = 'S' then
        if nvl(parameter.p_indi_exis_orpa, 'N') = 'N' then
          pp_valida_fech(p_movi_fech_emis);
        end if;
      else
        if p_ejec_cons = 'N' then
          if p_movi_fech_emis <> to_char(sysdate, 'dd-mm-yyyy') then
            raise_application_error(-20001,
                                    'El usuario no tiene permiso para modificar la fecha de la OP');
          end if;
        else
          p_ejec_cons := 'N';
        end if;
      end if;
    else
      if nvl(parameter.p_indi_exis_orpa, 'N') = 'N' then
        pp_valida_fech(p_movi_fech_emis);
      end if;
    end if;
  end pp_validar_fec_emi;

  procedure pp_carga_secu(p_secu_nume_orpa out number) is
  begin
    select nvl(secu_nume_orpa, 0) + 1
      into p_secu_nume_orpa
      from come_secu
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Codigo de Secuencia de Ordenes de Pago inexistente');
  end pp_carga_secu;

  procedure pp_validar_op_fini(p_movi_clpr_codi in number) is
    --v_peri_actu number;
    v_fech_inic date;
    v_fech_fini date;
    v_cant      number := 0;
  
    v_orpa_nume      number;
    v_orpa_fech_emis date;
    v_movi_orpa_codi number;
  
    v_msg_02 varchar2(1000) := 'Se encuentran pendientes de Finiquito las Ordenes de Pago Nro. ';
    v_msg_01 varchar2(1000) := 'La orden de pago Nro. ';
  
  begin
  
    v_fech_inic := to_date('01-' || to_char(add_months(trunc(sysdate), -1),
                                            'mm-yyyy'),
                           'dd-mm-yyyy');
    v_fech_fini := last_day(add_months(trunc(sysdate), -1));
  
    begin
      select count(*)
        into v_cant
        from come_movi m,
             (select op.orpa_clpr_codi, op.orpa_codi
                from come_orde_pago op
               where op.orpa_estado = 'P'
                 and op.orpa_fech_emis >= v_fech_inic
                 and op.orpa_fech_emis <= v_fech_fini
               group by op.orpa_clpr_codi, op.orpa_codi) orde_pago
       where m.movi_timo_codi = 59
         and m.movi_orpa_codi = orde_pago.orpa_codi
         and m.movi_clpr_codi = orde_pago.orpa_clpr_codi
         and m.movi_clpr_codi = p_movi_clpr_codi;
    
      if v_cant > 2 then
        raise_application_error(-20001,
                                'Se encuentran pendientes de Finiquito m?s de 2 Ordenes de Pago.');
      elsif v_cant = 2 then
        declare
          cursor c_movi_op is
            select m.movi_orpa_codi
              from come_movi m,
                   (select op.orpa_clpr_codi, op.orpa_codi
                      from come_orde_pago op
                     where op.orpa_estado = 'P'
                       and op.orpa_fech_emis >= v_fech_inic
                       and op.orpa_fech_emis <= v_fech_fini
                     group by op.orpa_clpr_codi, op.orpa_codi) orde_pago
             where m.movi_timo_codi = 59
               and m.movi_orpa_codi = orde_pago.orpa_codi
               and m.movi_clpr_codi = orde_pago.orpa_clpr_codi
               and m.movi_clpr_codi = p_movi_clpr_codi;
        
        begin
          for x in c_movi_op loop
            select op.orpa_nume, op.orpa_fech_emis
              into v_orpa_nume, v_orpa_fech_emis
              from come_orde_pago op
             where orpa_codi = x.movi_orpa_codi;
          
            v_msg_02 := v_msg_02 || v_orpa_nume || ', de fecha ' ||
                        to_char(v_orpa_fech_emis, 'dd-mm-yyyy') ||
                        ' y la orden de pago Nro. ';
          end loop;
        end;
        v_msg_02 := substr(v_msg_02, 1, length(v_msg_02) - 25) || '.';
        raise_application_error(-20001, v_msg_02);
      elsif v_cant = 1 then
        begin
          select m.movi_orpa_codi
            into v_movi_orpa_codi
            from come_movi m,
                 (select op.orpa_clpr_codi, op.orpa_codi
                    from come_orde_pago op
                   where op.orpa_estado = 'P'
                     and op.orpa_fech_emis >= v_fech_inic
                     and op.orpa_fech_emis <= v_fech_fini
                   group by op.orpa_clpr_codi, op.orpa_codi) orde_pago
           where m.movi_timo_codi = 59
             and m.movi_orpa_codi = orde_pago.orpa_codi
             and m.movi_clpr_codi = orde_pago.orpa_clpr_codi
             and m.movi_clpr_codi = p_movi_clpr_codi;
        end;
      
        begin
          select op.orpa_nume, op.orpa_fech_emis
            into v_orpa_nume, v_orpa_fech_emis
            from come_orde_pago op
           where orpa_codi = v_movi_orpa_codi;
        
          v_msg_01 := v_msg_01 || v_orpa_nume || ', de fecha ' ||
                      to_char(v_orpa_fech_emis, 'dd-mm-yyyy') ||
                      ' se encuentra pendiente de Finiquito.';
        end;
        raise_application_error(-20001, v_msg_01);
      end if;
    exception
      when no_data_found then
        begin
          select count(*)
            into v_cant
            from come_movi m,
                 (select op.orpa_clpr_codi, op.orpa_codi
                    from come_orde_pago op
                   where op.orpa_estado = 'P'
                     and op.orpa_fech_emis < v_fech_inic
                   group by op.orpa_clpr_codi, op.orpa_codi) orde_pago
           where m.movi_timo_codi = 59
             and m.movi_orpa_codi = orde_pago.orpa_codi
             and m.movi_clpr_codi = orde_pago.orpa_clpr_codi
             and m.movi_clpr_codi = p_movi_clpr_codi;
        
          if v_cant > 0 then
            declare
              cursor c_movi_op is
                select m.movi_orpa_codi
                  from come_movi m,
                       (select op.orpa_clpr_codi, op.orpa_codi
                          from come_orde_pago op
                         where op.orpa_estado = 'P'
                           and op.orpa_fech_emis < v_fech_inic
                         group by op.orpa_clpr_codi, op.orpa_codi) orde_pago
                 where m.movi_timo_codi = 59
                   and m.movi_orpa_codi = orde_pago.orpa_codi
                   and m.movi_clpr_codi = orde_pago.orpa_clpr_codi
                   and m.movi_clpr_codi = p_movi_clpr_codi;
            
            begin
              for x in c_movi_op loop
                select op.orpa_nume, op.orpa_fech_emis
                  into v_orpa_nume, v_orpa_fech_emis
                  from come_orde_pago op
                 where orpa_codi = x.movi_orpa_codi;
              
                v_msg_02 := v_msg_02 || v_orpa_nume || ', de fecha ' ||
                            to_char(v_orpa_fech_emis, 'dd-mm-yyyy') ||
                            ' y la orden de pago Nro. ';
              end loop;
            end;
            v_msg_02 := substr(v_msg_02, 1, length(v_msg_02) - 25) || '.';
            raise_application_error(-20001, v_msg_02);
          end if;
        end;
    end;
  end pp_validar_op_fini;

  procedure pp_validar_caja_orig(p_operacion           in varchar2,
                                 p_movi_cuen_codi      in number,
                                 --p_movi_fech_emis      in date,
                                 --p_timo_tica_codi      in varchar2,
                                 p_s_cuen_desc         out varchar2,
                                 p_movi_mone_codi      out number,
                                 p_s_banc_codi         out number,
                                 p_s_banc_desc         out varchar2,
                                 p_s_cuen_nume         out varchar2,
                                 p_movi_tasa_mone      out varchar2,
                                 p_s_mone_desc_abre    out varchar2,
                                 p_movi_mone_cant_deci out varchar2,
                                 p_s_mone_desc         out varchar2)
  
   is
  begin
  
    if p_operacion = 'TV' then
      -- ya no se valida en caso que sea Orden de Pago.
    
      if p_movi_cuen_codi is not null then
        general_skn.pl_muestra_come_cuen_banc(p_movi_cuen_codi,
                                              p_s_cuen_desc,
                                              p_movi_mone_codi,
                                              p_s_banc_codi,
                                              p_s_banc_desc,
                                              p_s_cuen_nume);
        general_skn.pl_muestra_come_mone(p_movi_mone_codi,
                                         p_s_mone_desc,
                                         p_s_mone_desc_abre,
                                         p_movi_mone_cant_deci);
        if p_movi_tasa_mone is null then
          /*pp_busca_tasa_mone(p_movi_mone_codi,
          p_movi_fech_emis,
          p_movi_tasa_mone,
          p_timo_tica_codi);*/
          null;
        end if;
      
        -- raise_application_error(-20001,p_movi_cuen_codi);
        if not general_skn.fl_vali_user_cuen_banc_cred(p_movi_cuen_codi) then
          raise_application_error(-20001,
                                  'No posee permiso para realizar una extracci?n en la caja seleccionada. !!!');
        end if;
      
      else
        raise_application_error(-20001, 'Debe ingresar la Cuenta Bancaria');
      end if;
    end if;
  end pp_validar_caja_orig;

  procedure pp_validar_caja_dest(p_operacion            in varchar2,
                                 p_s_cuen_codi2         in number,
                                 --p_movi_fech_emis       in date,
                                 --p_timo_tica_codi       in number,
                                 p_s_cuen_desc2         out varchar2,
                                 p_s_mone_codi2         out number,
                                 p_s_banc_codi2         out number,
                                 p_s_banc_desc2         out varchar2,
                                 p_s_cuen_nume2         out varchar2,
                                 p_s_mone_desc2         out varchar2,
                                 p_s_mone_desc_abre2    out varchar2,
                                 p_movi_mone_cant_deci2 out varchar2--,
                                 --p_s_tasa_mone2         out number
                                 ) is
  begin
  
    if p_s_cuen_codi2 is not null then
      general_skn.pl_muestra_come_cuen_banc(p_s_cuen_codi2,
                                            p_s_cuen_desc2,
                                            p_s_mone_codi2,
                                            p_s_banc_codi2,
                                            p_s_banc_desc2,
                                            p_s_cuen_nume2);
      general_skn.pl_muestra_come_mone(p_s_mone_codi2,
                                       p_s_mone_desc2,
                                       p_s_mone_desc_abre2,
                                       p_movi_mone_cant_deci2);
    
      /*pp_busca_tasa_mone(p_s_mone_codi2,
      p_movi_fech_emis,
      p_s_tasa_mone2,
      p_timo_tica_codi);*/
    
      if p_operacion = 'TV' then
        -- raise_application_error(-20001,p_s_cuen_codi2);
        if not general_skn.fl_vali_user_cuen_banc_debi(p_s_cuen_codi2) then
          raise_application_error(-20001,
                                  'No posee permiso para realizar un deposito en la caja seleccionada. !!!');
        end if;
        null;
      end if;
    
    else
      if p_operacion = 'TV' then
        raise_application_error(-20001,
                                'Debe ingresar la Cuenta Bancaria Destino');
      end if;
    end if;
  end pp_validar_caja_dest;

  procedure pp_validar_moneda(p_operacion           in varchar2,
                              p_movi_mone_codi      in number,
                              --p_movi_fech_emis      in date,
                              --p_timo_tica_codi      in number,
                              p_s_mone_desc         out varchar2,
                              p_s_mone_desc_abre    out varchar2,
                              p_movi_mone_cant_deci out varchar2--,
                              --p_movi_tasa_mone      out varchar2
                              )
  
   is
  begin
    if p_operacion in ('OP', 'AP', 'VB') then
      if p_movi_mone_codi is not null then
      
        general_skn.pl_muestra_come_mone(p_movi_mone_codi,
                                         p_s_mone_desc,
                                         p_s_mone_desc_abre,
                                         p_movi_mone_cant_deci);
       
      
      /* pp_busca_tasa_mone(p_movi_mone_codi,
                           p_movi_fech_emis,
                           p_movi_tasa_mone,
                           p_timo_tica_codi);*/
      
      else
      
        raise_application_error(-20001, 'Debe ingresar la Moneda');
      
      end if;
    end if;
  
  end pp_validar_moneda;

  procedure pp_mostrar_cliente(p_clpr_codi_alte      in number,
                               p_operacion           in varchar2,
                               p_movi_clpr_codi      out varchar2,
                               p_clpr_desc           out varchar2,
                               p_s_clpr_indi_chac    out varchar2,
                               p_s_clpr_prov_retener out varchar2,
                               p_movi_clpr_ruc       out varchar2) is
  Begin
  
    select clpr_codi, h.clpr_desc
      into p_movi_clpr_codi, p_clpr_desc
      from come_clie_prov h
     where h.clpr_indi_clie_prov = 'P'
       and h.clpr_codi_alte = p_clpr_codi_alte;
  
    begin
      select p.clpr_indi_chac, p.clpr_prov_retener, clpr_ruc
        into p_s_clpr_indi_chac, p_s_clpr_prov_retener, p_movi_clpr_ruc
        from come_clie_prov p
       where p.clpr_codi = p_movi_clpr_codi;
    exception
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
    if nvl(parameter.p_para_inic, 'X') <> 'FINI' then
      if p_operacion in ('OP', 'AP') then
        I020089.pp_validar_op_fini(p_movi_clpr_codi => p_movi_clpr_codi);
      end if;
    end if;
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_mostrar_cliente;

  procedure pp_cargar_bloque_det(p_movi_clpr_codi in number,
                                 p_movi_mone_codi in number,
                                 p_orden          in varchar2,
                                 p_fech_venc_inic in date,
                                 p_fech_venc_fini in date,
                                 p_fech_emis_inic in date,
                                 p_fech_emis_fini in date) is
  
    cursor c_vto_nume is
      select movi_nume,
             movi_fech_emis,
             cuot_fech_venc,
             cuot_impo_mone,
             cuot_sald_mone,
             movi_codi,
             timo_desc_abre,
             movi_grav_mone,
             movi_grav_mmnn,
             movi_iva_mone,
             movi_iva_mmnn,
             movi_codi_rete
        from come_movi, come_movi_cuot, come_tipo_movi
       where movi_codi = cuot_movi_codi
         and movi_clpr_codi = p_movi_clpr_codi
         and cuot_sald_mone > 0
         and movi_mone_codi = p_movi_mone_codi
         and movi_dbcr = 'C' --decode('R', 'E', 'D', 'R', 'C')
         and movi_timo_codi = timo_codi
         and cuot_orpa_codi is null
         and (cuot_fech_venc >= p_fech_venc_inic or
             p_fech_venc_inic is null)
         and (cuot_fech_venc <= p_fech_venc_fini or
             p_fech_venc_fini is null)
         and (movi_fech_emis >= p_fech_emis_inic or
             p_fech_emis_inic is null)
         and (movi_fech_emis <= p_fech_emis_fini or
             p_fech_emis_fini is null)
       order by movi_nume, movi_fech_emis, cuot_fech_venc;
  
    cursor c_vto_emis is
      select movi_nume,
             movi_fech_emis,
             cuot_fech_venc,
             cuot_impo_mone,
             cuot_sald_mone,
             movi_codi,
             timo_desc_abre,
             movi_grav_mone,
             movi_grav_mmnn,
             movi_iva_mone,
             movi_iva_mmnn,
             movi_codi_rete
        from come_movi, come_movi_cuot, come_tipo_movi
       where movi_codi = cuot_movi_codi
         and movi_clpr_codi = p_movi_clpr_codi
         and cuot_sald_mone > 0
         and movi_mone_codi = p_movi_mone_codi
         and movi_dbcr = 'C' --decode('R', 'E', 'D', 'R', 'C')
         and movi_timo_codi = timo_codi
         and cuot_orpa_codi is null
         and (cuot_fech_venc >= p_fech_venc_inic or
             p_fech_venc_inic is null)
         and (cuot_fech_venc <= p_fech_venc_fini or
             p_fech_venc_fini is null)
         and (movi_fech_emis >= p_fech_emis_inic or
             p_fech_emis_inic is null)
         and (movi_fech_emis <= p_fech_emis_fini or
             p_fech_emis_fini is null)
       order by movi_fech_emis, movi_nume, cuot_fech_venc;
  
    cursor c_vto_venc is
      select movi_nume,
             movi_fech_emis,
             cuot_fech_venc,
             cuot_impo_mone,
             cuot_sald_mone,
             movi_codi,
             timo_desc_abre,
             movi_grav_mone,
             movi_grav_mmnn,
             movi_iva_mone,
             movi_iva_mmnn,
             movi_codi_rete
        from come_movi, come_movi_cuot, come_tipo_movi
       where movi_codi = cuot_movi_codi
         and movi_clpr_codi = p_movi_clpr_codi
         and cuot_sald_mone > 0
         and movi_mone_codi = p_movi_mone_codi
         and movi_dbcr = 'C' --decode('R', 'E', 'D', 'R', 'C')
         and movi_timo_codi = timo_codi
         and cuot_orpa_codi is null
         and (cuot_fech_venc >= p_fech_venc_inic or
             p_fech_venc_inic is null)
         and (cuot_fech_venc <= p_fech_venc_fini or
             p_fech_venc_fini is null)
         and (movi_fech_emis >= p_fech_emis_inic or
             p_fech_emis_inic is null)
         and (movi_fech_emis <= p_fech_emis_fini or
             p_fech_emis_fini is null)
       order by cuot_fech_venc, movi_nume, movi_fech_emis;
  
    --v_rete_nume number;
  
  begin
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
  
    if p_orden = 'V' then
      for x in c_vto_venc loop
      
        apex_collection.add_member(p_collection_name => 'BDETALLE',
                                   p_c001            => null, ---ind_marcado                            
                                   p_c002            => x.movi_nume,
                                   p_c003            => x.movi_fech_emis,
                                   p_c004            => x.cuot_fech_venc,
                                   p_c005            => x.cuot_impo_mone,
                                   p_c006            => x.cuot_sald_mone,
                                   p_c007            => x.movi_codi,
                                   p_c008            => x.timo_desc_abre,
                                   p_c009            => x.movi_grav_mone,
                                   p_c010            => x.movi_grav_mmnn,
                                   p_c012            => x.movi_iva_mone,
                                   p_c013            => x.movi_iva_mmnn,
                                   p_c014            => x.movi_codi_rete);
      
      end loop;
    
    elsif p_orden = 'E' then
      for x in c_vto_emis loop
        apex_collection.add_member(p_collection_name => 'BDETALLE',
                                   p_c001            => null, ---ind_marcado                            
                                   p_c002            => x.movi_nume,
                                   p_c003            => x.movi_fech_emis,
                                   p_c004            => x.cuot_fech_venc,
                                   p_c005            => x.cuot_impo_mone,
                                   p_c006            => x.cuot_sald_mone,
                                   p_c007            => x.movi_codi,
                                   p_c008            => x.timo_desc_abre,
                                   p_c009            => x.movi_grav_mone,
                                   p_c010            => x.movi_grav_mmnn,
                                   p_c012            => x.movi_iva_mone,
                                   p_c013            => x.movi_iva_mmnn,
                                   p_c014            => x.movi_codi_rete);
      
      end loop;
    
    elsif p_orden = 'N' then
      for x in c_vto_nume loop
      
        apex_collection.add_member(p_collection_name => 'BDETALLE',
                                   p_c001            => null, ---ind_marcado                            
                                   p_c002            => x.movi_nume,
                                   p_c003            => x.movi_fech_emis,
                                   p_c004            => x.cuot_fech_venc,
                                   p_c005            => x.cuot_impo_mone,
                                   p_c006            => x.cuot_sald_mone,
                                   p_c007            => x.movi_codi,
                                   p_c008            => x.timo_desc_abre,
                                   p_c009            => x.movi_grav_mone,
                                   p_c010            => x.movi_grav_mmnn,
                                   p_c012            => x.movi_iva_mone,
                                   p_c013            => x.movi_iva_mmnn,
                                   p_c014            => x.movi_codi_rete);
      
      end loop;
    
    end if;
  
    declare
      v_count number;
    begin
      select count(c007) movi_codi
        into v_count
        from apex_collections a
       where collection_name = 'BDETALLE';
    
      if v_count = 0 then
        raise_application_error(-20001,
                                'El Proveedor no posee comprobantes pendientes!');
      
      end if;
    end;
  
  end pp_cargar_bloque_det;

  procedure pp_validar_tasa2(p_operacion            in varchar2,
                             p_s_tasa_mone2         in number,
                             p_movi_mone_codi       in number,
                             p_s_impo_mone1         in number,
                             p_s_mone_codi2         in number,
                             p_movi_tasa_mone       in number,
                             p_s_impo_mmnn1         in number,
                             p_movi_mone_cant_deci2 in number,
                             p_s_impo_mone2         out number,
                             p_s_impo_mmnn2         out number) is
  
  begin
    if p_operacion = 'TV' then
      if p_s_tasa_mone2 is null then
        raise_application_error(-20001,
                                'Debe ingresar la Cotizacion de la Moneda');
      end if;
    
      if p_movi_mone_codi = p_s_mone_codi2 then
        p_s_impo_mone2 := p_s_impo_mone1;
      else
        p_s_impo_mone2 := 0;
      end if;
    
      -- raise_application_error(-20001,parameter.p_codi_mone_mmnn);
      if p_s_mone_codi2 = parameter.p_codi_mone_mmnn then
        p_s_impo_mone2 := round((p_s_impo_mone1 * p_movi_tasa_mone),
                                parameter.p_cant_deci_mmnn);
      else
        p_s_impo_mone2 := round((p_s_impo_mmnn1 / p_s_tasa_mone2),
                                p_movi_mone_cant_deci2);
      end if;
      p_s_impo_mmnn2 := round(p_s_impo_mone1 * p_movi_tasa_mone,
                              parameter.p_cant_deci_mmnn);
    end if;
  end pp_validar_tasa2;

  procedure pp_validar_imp_pago(p_seq_id         in number,
                                p_orpa_estado    in varchar2,
                                p_deta_impo_mone in number)
  
   is
    v_cuot_sald_mone number;
  begin
  
    begin
      select c006 s_cuot_sald_mone
        into v_cuot_sald_mone
        from apex_collections a
       where collection_name = 'BDETALLE'
         and seq_id = p_seq_id;
    exception
      when others then
        null;
    end;
  
    if p_deta_impo_mone > 0 or p_deta_impo_mone < 0 then
    
      if p_deta_impo_mone > v_cuot_sald_mone then
        if nvl(p_orpa_estado, 'P') <> 'F' then
          raise_Application_error(-20001,
                                  'El importe de pago no puede sobrepasar el saldo de la cuota!.');
        end if;
      end if;
    end if;
  
    if p_deta_impo_mone > v_cuot_sald_mone then
    
      if nvl(p_orpa_estado, 'P') <> 'F' then
        raise_Application_error(-20001,
                                'El importe de pago no puede sobrepasar el saldo de la cuota!.');
      end if;
    end if;
  
    I020089.pp_update_member(p_seq_id, 17, p_deta_impo_mone);
  
  end pp_validar_imp_pago;

  procedure pp_validar_marcado(p_seq_id         in number,
                               p_movi_fech_emis in date) is
  
  begin
  
    for i in (select c003 s_movi_fech_emis,
                     c017 deta_impo_mone,
                     c006 s_cuot_sald_mone,
                     c001 ind_macado
                from apex_collections a
               where collection_name = 'BDETALLE'
                 and seq_id = p_seq_id) loop
    
      if i.ind_macado = 'X' then
        if i.deta_impo_mone is null then
          I020089.pp_update_member(p_seq_id, 17, i.s_cuot_sald_mone);
        end if;
        if i.s_movi_fech_emis > p_movi_fech_emis then
          raise_application_error(-20001,
                                  'La fecha de pago debe ser mayor o igual a la factura a pagar');
        end if;
      else
        I020089.pp_update_member(p_seq_id, 17, null);
      end if;
    end loop;
  end pp_validar_marcado;

  procedure pp_update_member(p_seq_id  in number,
                             p_nro_upd in number,
                             p_valor   in varchar2) is
  begin
    apex_collection.update_member_attribute(p_collection_name => 'BDETALLE',
                                            p_seq             => p_seq_id,
                                            p_attr_number     => p_nro_upd,
                                            p_attr_value      => p_valor);
  end pp_update_member;
  
   procedure pp_calcular_retencion(p_seq_id              in number,
                                  p_movi_clpr_codi      in number,
                                  p_fecha_emis          in date,
                                  p_movi_mone_cant_deci in number,
                                  p_s_movi_iva_mmnn     in number,
                                  p_s_movi_iva_mone     in number,
                                  p_empr_retentora      in varchar2,
                                  p_s_movi_codi_rete    in number,
                                  p_s_apli_rete         in varchar2,
                                  p_S_CALC_RETE_MINI    in varchar2,
                                  P_RETE_NUME out number) is
    v_impo_rete_mone_docu_mmnn number := 0;
    v_impo_rete_mone_docu_mone number := 0;
    v_impo_rete_ncred_tot_mmnn number := 0;
    v_impo_rete_ncred_iva_mmnn number := 0;
    v_impo_rete_ncred_iva_mone number := 0;
    v_impo_valido              number := 0;
    v_tot_retencion_mone number := 0;
  
    v_tot_deta_impo_mmnn number;
  
    salir exception;
  begin
   
  
    if upper(nvl(p_empr_retentora, 'NO')) = 'NO' or
       p_s_movi_codi_rete is not null or nvl(p_s_apli_rete, 'S') = 'N' then
    
      I020089.pp_update_member(p_seq_id, 24, 0); --s_retencion_mone
      I020089.pp_update_member(p_seq_id, 19, 0); --deta_rete_iva_mone
      I020089.pp_update_member(p_seq_id, 20, 0); --deta_rete_iva_mmnn
      I020089.pp_update_member(p_seq_id, 25, null); --rete_nume
    
      raise salir;
    end if;
    
    select  sum(nvl(round((c017 * bcab.movi_tasa_mone),
                     parameter.p_cant_deci_mmnn),
               0)) deta_impo_mmnn
               into v_tot_deta_impo_mmnn
      from apex_collections a
     where collection_name = 'BDETALLE'
       and c001 = 'X'
       and seq_id=p_seq_id;
  
    --pp_calcular_notacred(v_impo_rete_ncred_iva, v_impo_rete_ncred_tot_mmnn);
    --v_impo_valido := nvl(fp_calcular_acumulado, 0) + nvl(:bdet.f_tot_movi_grav_mmnn, 0) - nvl(v_impo_rete_ncred_tot_mmnn, 0);
    v_impo_valido := nvl(fp_calcular_acumulado(p_movi_clpr_codi,
                                               p_fecha_emis),
                         0) + nvl(v_tot_deta_impo_mmnn, 0) -
                     nvl(v_impo_rete_ncred_tot_mmnn, 0);
                    
    
 --raise_application_error(-20001,v_tot_deta_impo_mmnn);
    if v_impo_valido >= parameter.p_imp_min_aplic_reten then
      v_impo_rete_mone_docu_mmnn := round(((p_s_movi_iva_mmnn -
                                          v_impo_rete_ncred_iva_mmnn) *
                                          parameter.p_porc_aplic_reten / 100),
                                          parameter.p_cant_deci_mmnn);
      v_impo_rete_mone_docu_mone := round(((p_s_movi_iva_mone -
                                          v_impo_rete_ncred_iva_mone) *
                                          parameter.p_porc_aplic_reten / 100),
                                          p_movi_mone_cant_deci);
    else
      if nvl(p_S_CALC_RETE_MINI, 'N') = 'N' then
      
        I020089.pp_update_member(p_seq_id, 24, 0); --s_retencion_mone
        I020089.pp_update_member(p_seq_id, 19, 0); --deta_rete_iva_mone
        I020089.pp_update_member(p_seq_id, 20, 0); --deta_rete_iva_mmnn
        I020089.pp_update_member(p_seq_id, 25, 0); --rete_nume
      
        --v_impo_rete_mone_docu_mone := 0;
        v_impo_rete_mone_docu_mmnn := 0;
        v_impo_rete_mone_docu_mone := 0;
      end if;
    end if;
    -- p_deta_rete_iva_mone := v_impo_rete_mone_docu_mone;
    -- p_deta_rete_iva_mmnn := v_impo_rete_mone_docu_mmnn;
    -- p_s_retencion_mone   := v_impo_rete_mone_docu_mone;
  
  --  I020089.pp_update_member(p_seq_id, 24, v_impo_rete_mone_docu_mone); --s_retencion_mone
    I020089.pp_update_member(p_seq_id, 20, v_impo_rete_mone_docu_mmnn); --deta_rete_iva_mmnn
    I020089.pp_update_member(p_seq_id, 19, v_impo_rete_mone_docu_mone); --deta_rete_iva_mone
  
 
   select  sum(c024)  retencion_mone
               into v_tot_retencion_mone
      from apex_collections a
     where collection_name = 'BDETALLE'
       and c001 = 'X'
       and seq_id=p_seq_id
       ;
    if nvl(v_tot_retencion_mone, 0) > 0 then
   --raise_application_error(-20001,p_seq_id);
        I020089.pp_cargar_nro_rete(P_RETE_NUME);
        I020089.pp_update_member(p_seq_id, 25, P_RETE_NUME);

    end if;
 
  exception
    when salir then
      null;
  end pp_calcular_retencion;


/*procedure pp_calcular_retencion(p_empr_retentora      in varchar2,
                                p_S_CALC_RETE_MINI    in varchar2, 
                                p_movi_clpr_codi      in number,
                                p_fecha_emis          in date,
                                p_s_apli_rete         in varchar2) is
  v_impo_rete_mone_docu_mmnn  number := 0;
  v_impo_rete_mone_docu_mone  number := 0;
  v_impo_rete_ncred_tot_mmnn  number := 0;
  v_impo_rete_ncred_iva_mmnn  number := 0;
  v_impo_rete_ncred_iva_mone  number := 0;
  v_impo_valido               number := 0;
  
  salir exception;
begin
  for bdet in detalle loop
  if upper(nvl(p_empr_retentora, 'NO')) = 'NO'
  or bdet.s_movi_codi_rete is not null
  or nvl(p_s_apli_rete, 'S') = 'N' then
  
    
      I020089.pp_update_member(bdet.deta_item, 24, 0); --s_retencion_mone
      I020089.pp_update_member(bdet.deta_item, 19, 0); --deta_rete_iva_mone
      I020089.pp_update_member(bdet.deta_item, 20, 0); --deta_rete_iva_mmnn
      I020089.pp_update_member(bdet.deta_item, 25, null); --rete_nume
    raise salir;
  end if;
  
   v_impo_valido := nvl(fp_calcular_acumulado(p_movi_clpr_codi,p_fecha_emis), 0) + nvl(bdet.deta_impo_mmnn, 0) - nvl(v_impo_rete_ncred_tot_mmnn, 0);
  
  if v_impo_valido >= parameter.p_imp_min_aplic_reten then
    v_impo_rete_mone_docu_mmnn := round(((bdet.s_movi_iva_mmnn - v_impo_rete_ncred_iva_mmnn) * parameter.p_porc_aplic_reten / 100), parameter.p_cant_deci_mmnn);
    v_impo_rete_mone_docu_mone := round(((bdet.s_movi_iva_mone - v_impo_rete_ncred_iva_mone) * parameter.p_porc_aplic_reten / 100), bcab.movi_mone_cant_deci);
  else
    if nvl(p_S_CALC_RETE_MINI,'N') = 'N' then
   
      I020089.pp_update_member(bdet.deta_item, 24, 0); --s_retencion_mone
      I020089.pp_update_member(bdet.deta_item, 19, 0); --deta_rete_iva_mone
      I020089.pp_update_member(bdet.deta_item, 20, 0); --deta_rete_iva_mmnn
      I020089.pp_update_member(bdet.deta_item, 25, null); --rete_nume
      v_impo_rete_mone_docu_mone := 0;
      v_impo_rete_mone_docu_mmnn := 0;
      v_impo_rete_mone_docu_mone := 0;
    end if;
  end if;  
      I020089.pp_update_member(bdet.deta_item, 24, v_impo_rete_mone_docu_mone); --s_retencion_mone
    I020089.pp_update_member(bdet.deta_item, 20, v_impo_rete_mone_docu_mmnn); --deta_rete_iva_mmnn
    I020089.pp_update_member(bdet.deta_item, 19, v_impo_rete_mone_docu_mone); --deta_rete_iva_mone
  --bdet.deta_rete_iva_mone = v_impo_rete_mone_docu_mone;
  --bdet.deta_rete_iva_mmnn = v_impo_rete_mone_docu_mmnn;
  --bdet.s_retencion_mone   = v_impo_rete_mone_docu_mone;
  
 /* if nvl(bdet.s_retencion_mone, 0) > 0 then
    pp_cargar_nro_rete;
  end if;

    end loop;
    exception

  when salir then
    null;
end pp_calcular_retencion;*/


 procedure pp_calcular_importe_det(p_deta_impo_mone     in number,
                                    p_movi_tasa_mone     in number,
                                    p_orpa_impo_mone     in out number,
                                    p_tot_deta_impo_mone in number) is
   -- v_deta_impo_mmnn number;
    --v_orpa_impo_mone number;
    v_orpa_impo_mmnn number;
    v_tot_deta_impo_mone number;
  begin
   -- v_deta_impo_mmnn := round((p_deta_impo_mone * p_movi_tasa_mone), parameter.p_cant_deci_mmnn);
    p_orpa_impo_mone := p_tot_deta_impo_mone;
    v_orpa_impo_mmnn := round((p_orpa_impo_mone * p_movi_tasa_mone),
                              parameter.p_cant_deci_mmnn);
  
    --  pp_calc_grav_deta; falta validar
  
  end pp_calcular_importe_det;

  procedure pp_calc_grav_deta(p_deta_cuot_movi_codi in number,
                              p_movi_tasa_mone      in number,
                              p_deta_impo_mone      in number,
                              p_movi_mone_cant_deci in number,
                              p_s_timo_desc_abre    in varchar2,
                              p_s_apli_rete         in varchar2) is
    v_movi_exen_mone number;
    v_movi_grav_mone number;
    v_movi_iva_mone  number;
    v_movi_exen_mmnn number;
    v_movi_grav_mmnn number;
    v_movi_iva_mmnn  number;
    v_impo_mone      number;
    v_impo_mmnn      number;
    v_porc_grav      number;
  
    v_w_deta_grav_mone number;
    v_w_deta_grav_mmnn number;
    v_w_deta_impo_mone number;
    v_w_deta_impo_mmnn number;
    v_cant             number;
  begin
    if nvl(p_deta_impo_mone, 0) = 0 or p_deta_cuot_movi_codi is null then
      v_w_deta_grav_mone := 0;
      v_w_deta_grav_mmnn := 0;
      v_w_deta_impo_mone := 0;
      v_w_deta_impo_mmnn := 0;
    else
      begin
        select m.movi_exen_mone,
               m.movi_grav_mone,
               m.movi_iva_mone,
               m.movi_exen_mmnn,
               m.movi_grav_mmnn,
               m.movi_iva_mmnn
          into v_movi_exen_mone,
               v_movi_grav_mone,
               v_movi_iva_mone,
               v_movi_exen_mmnn,
               v_movi_grav_mmnn,
               v_movi_iva_mmnn
          from come_movi m
         where m.movi_codi = p_deta_cuot_movi_codi;
      end;
    
      v_impo_mone := nvl(v_movi_exen_mone, 0) + nvl(v_movi_grav_mone, 0) +
                     nvl(v_movi_iva_mone, 0);
      v_impo_mmnn := nvl(v_movi_exen_mmnn, 0) + nvl(v_movi_grav_mmnn, 0) +
                     nvl(v_movi_iva_mmnn, 0);
    
      begin
        select count(*)
          into v_cant
          from come_movi_rete a
         where more_movi_codi = p_deta_cuot_movi_codi;
      end;
    
      if p_s_apli_rete = 'S' and v_cant = 0 and
         p_s_timo_desc_abre <> 'PCRR' then
        v_w_deta_impo_mone := v_impo_mone;
        v_w_deta_impo_mmnn := v_impo_mmnn;
      end if;
    
      v_porc_grav := nvl(v_movi_grav_mone, 0) * 100 / v_impo_mone;
    
      v_w_deta_grav_mone := round(p_deta_impo_mone * v_porc_grav / 100,
                                  p_movi_mone_cant_deci);
      v_w_deta_grav_mmnn := round((p_deta_impo_mone * p_movi_tasa_mone) *
                                  v_porc_grav / 100,
                                  parameter.p_cant_deci_mmnn);
    end if;
  end pp_calc_grav_deta;

  procedure pp_rete_impot_min(p_fecha_emis          in date,
                              p_movi_clpr_codi      in number,
                              p_movi_mone_cant_deci in number,
                              p_empr_retentora      in varchar,
                              p_S_CALC_RETE_MINI    in varchar2,
                              p_movi_tasa_mone      in number,
                              p_orpa_impo_mone      in out number,
                              p_s_clpr_prov_retener in varchar2,
                              p_sucu_codi           number,
                              p_empr_codi           number,
                              p_orpa_rete_mone      in out number,
                              p_orpa_rete_mmnn      in out number,
                              P_RETE_NUME out number) is
  
    v_tot_deta_impo_mone number;
    v_W_TOTA_GRAV_MONE   number;
    v_W_TOTA_GRAV_MMNN   number;
    v_w_total_impo_mmnn  number;
    v_w_total_impo_mone  number;
    v_tot_retencion_mone number;
  begin
  
    for i in detalle loop
    
    
    
    
      pp_calcular_retencion(i.deta_item, --secuencia de collection
                            p_movi_clpr_codi,
                            p_fecha_emis,
                            p_movi_mone_cant_deci,
                            i.s_movi_iva_mmnn,
                            i.s_movi_iva_mone,
                            p_empr_retentora,
                            i.s_movi_codi_rete,
                            i.apli_rete,
                            p_S_CALC_RETE_MINI,
                            P_RETE_NUME);
                           
          select  sum(nvl(c017,0)) deta_impo_mmnn,  sum(nvl(c024,0)) retencion_mone
               into v_tot_deta_impo_mone,v_tot_retencion_mone
      from apex_collections a
     where collection_name = 'BDETALLE'
      and c001 = 'X'
      and seq_id=i.deta_item;
    
      pp_calcular_importe_det(i.deta_impo_mone,
                              p_movi_tasa_mone,
                              p_orpa_impo_mone,
                              v_tot_deta_impo_mone);
    
   
     pp_calcular_importe_rete(i.ind_marcado,
                               p_S_CALC_RETE_MINI,
                               i.deta_impo_mone, ---imp_pago
                               p_movi_tasa_mone,
                               v_W_TOTA_GRAV_MONE,
                               v_W_TOTA_GRAV_MMNN,
                               p_movi_mone_cant_deci,
                               p_s_clpr_prov_retener,
                               p_sucu_codi,
                               p_empr_codi,
                               v_w_total_impo_mmnn,
                               i.deta_cuot_movi_codi,
                               v_w_total_impo_mone,
                               i.apli_rete,
                               v_tot_retencion_mone, -- in out 
                               i.s_retencion_mone, --in out 
                               i.deta_rete_iva_mmnn, --in out 
                               i.deta_rete_iva_mone, --in out 
                               P_RETE_NUME,--i.rete_nume, --out 
                               p_orpa_rete_mone, --out 
                               p_orpa_rete_mmnn, --out 
                               i.deta_item);
    end loop;
   select   sum(nvl(c024,0)) retencion_mone,sum(nvl(c017,0))  orpa_impo_mone
               into p_orpa_rete_mone,p_orpa_impo_mone
      from apex_collections a
     where collection_name = 'BDETALLE'
      and c001 = 'X';
      
  end pp_rete_impot_min;

  procedure pp_calcular_importe_rete(p_marca               in varchar2,
                                     p_S_CALC_RETE_MINI    in varchar2,
                                     p_deta_impo_mone      in number, ---imp_pago
                                     p_movi_tasa_mone      in number,
                                     P_W_TOTA_GRAV_MONE    in number,
                                     p_W_TOTA_GRAV_MMNN    in number,
                                     p_movi_mone_cant_deci in number,
                                     p_s_clpr_prov_retener in varchar2,
                                     p_sucu_codi           in number,
                                     p_empr_codi           number,
                                     p_w_total_impo_mmnn   in number,
                                     p_deta_cuot_movi_codi in number,
                                     p_w_total_impo_mone   in number,
                                     p_s_apli_rete         in out varchar2,
                                     p_tot_retencion_mone  in out number,
                                     p_s_retencion_mone    in out number,
                                     p_deta_rete_iva_mmnn  out number,
                                     p_deta_rete_iva_mone  in out number,
                                     p_rete_nume           out number,
                                     p_orpa_rete_mone      out number,
                                     p_orpa_rete_mmnn      out number,
                                     p_seq_id in number) is
  
    v_impo_pago_mone     number;
    v_impo_pago_mmnn     number;
    v_impo_tota_mmnn     number;
    v_impo_tota_mone     number;
    v_tot_retencion_mone number;
  
  begin
   
  
    if p_marca = 'X' and nvl(p_deta_impo_mone, 0) <> 0 then
    
      v_impo_pago_mone := 0;
      v_impo_pago_mone := p_deta_impo_mone;
    
      v_impo_pago_mmnn := round((p_deta_impo_mone * p_movi_tasa_mone),
                                parameter.p_cant_deci_mmnn);
    
      v_impo_tota_mmnn := P_W_TOTA_GRAV_MONE;
      v_impo_tota_mmnn := round(p_W_TOTA_GRAV_MMNN,
                                parameter.p_cant_deci_mmnn);
    
      if nvl(parameter.p_form_calc_rete_emit, 1) = 2 then
        --Formula de calculo de retencion prorrateada 
        p_s_apli_rete := 'S';
      end if;
    
      --pp_calcular_retencion;
      if lower(nvl(p_s_clpr_prov_retener, 'no')) <> 'no' then
        if parameter.p_form_calc_rete_emit = 6 then
          general_skn.pl_calc_rete(parameter.p_form_calc_rete_emit,
                                   p_empr_codi,
                                   p_sucu_codi,
                                   p_deta_cuot_movi_codi,
                                   p_s_apli_rete,
                                   v_impo_pago_mone,
                                   v_impo_pago_mmnn,
                                   p_w_total_impo_mmnn, --total de documentos moneda nacional
                                   p_deta_rete_iva_mone, --out
                                   p_deta_rete_iva_mmnn, --out
                                   p_w_total_impo_mone, --total de documentos moneda
                                   0,
                                   0,
                                   p_movi_mone_cant_deci,
                                   null,
                                   null,
                                   null,
                                   null,
                                   nvl(p_S_CALC_RETE_MINI, 'N'));
        else
          general_skn.pl_calc_rete(parameter.p_form_calc_rete_emit,
                                   p_empr_codi,
                                   p_sucu_codi,
                                   p_deta_cuot_movi_codi,
                                   p_s_apli_rete,
                                   v_impo_pago_mone,
                                   v_impo_pago_mmnn,
                                   v_impo_tota_mmnn,
                                   p_deta_rete_iva_mone, --out
                                   p_deta_rete_iva_mmnn, --out
                                   v_impo_tota_mone,
                                   0,
                                   0,
                                   p_movi_mone_cant_deci,
                                   null,
                                   null,
                                   null,
                                   null,
                                   nvl(p_S_CALC_RETE_MINI, 'N'));
        end if;
      end if;
      if parameter.p_indi_exis_orpa = 'N' then
        p_s_retencion_mone := p_deta_rete_iva_mone;
      
      end if;
      if nvl(p_s_retencion_mone, 0) > 0 then
         pp_cargar_nro_rete(p_rete_nume);
         I020089.pp_update_member(p_seq_id, 25, p_rete_nume);
      else
        p_rete_nume := null;
      end if;
    
    else
      p_s_retencion_mone   := 0;
      p_deta_rete_iva_mone := 0;
      p_deta_rete_iva_mmnn := 0;
      p_rete_nume          := null;
    end if;
   --raise_application_error(-20001,p_tot_retencion_mone);
    p_orpa_rete_mone := p_tot_retencion_mone;
    p_orpa_rete_mmnn := round((p_tot_retencion_mone * p_movi_tasa_mone),
                              parameter.p_cant_deci_mmnn);
  
  
    I020089.pp_update_member(p_seq_id, 24, p_s_retencion_mone); --s_retencion_mone
    I020089.pp_update_member(p_seq_id, 20, p_deta_rete_iva_mmnn); --deta_rete_iva_mmnn
    I020089.pp_update_member(p_seq_id, 19, p_deta_rete_iva_mone); --deta_rete_iva_mone
  
  
  
  end pp_calcular_importe_rete;

  procedure pp_cargar_nro_rete(p_movi_nume_rete in out number) is
  begin
    if p_movi_nume_rete is null then
      pp_carga_secu_rete(p_movi_nume_rete);
      --    :brete.s_nro_1_rete := substr(lpad(to_char(:brete.movi_nume_rete), 13, '0'),1,3);
      --    :brete.s_nro_2_rete := substr(lpad(to_char(:brete.movi_nume_rete), 13, '0'),4,3);
      --    :brete.s_nro_3_rete := substr(lpad(to_char(:brete.movi_nume_rete), 13, '0'),7,7);  
    end if;
  
    pp_validar_nume_rete(p_movi_nume_rete);
    -- pp_cargar_timb_rete;
  
  end pp_cargar_nro_rete;

  procedure pp_cargar_timb_rete(p_s_nro_1_rete             in number,
                                p_s_nro_2_rete             in number,
                                p_movi_clpr_codi           in number,
                                p_movi_fech_emis           in date,
                                p_tico_codi_rete           out number,
                                p_movi_nume_timb_rete      out varchar2,
                                p_movi_fech_venc_timb_rete out varchar2) is
    --v_tico_codi number          := 3;
    v_tico_indi_timb varchar2(1) := 'C';
  begin
  
    begin
      select timo_tico_codi, tico_indi_timb
        into p_tico_codi_rete, v_tico_indi_timb
        from come_tipo_movi, come_tipo_comp
       where timo_tico_codi = tico_codi
         and timo_codi = parameter.p_codi_timo_rete_emit;
    
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'Tipo de comprobante no configurado!');
    end;
  
    pp_validar_timbrado_rete(p_tico_codi_rete,
                             to_number(p_s_nro_1_rete),
                             to_number(p_s_nro_2_rete),
                             p_movi_clpr_codi,
                             p_movi_fech_emis,
                             p_movi_nume_timb_rete,
                             p_movi_fech_venc_timb_rete,
                             v_tico_indi_timb); --validar
  
  end pp_cargar_timb_rete;

  procedure pp_validar_timbrado_rete(p_tico_codi      in number,
                                     p_esta           in number,
                                     p_punt_expe      in number,
                                     p_clpr_codi      in number,
                                     p_fech_movi      in date,
                                     p_timb           in out varchar2,
                                     p_fech_venc      in out date,
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
  
    v_tico_indi_habi_timb varchar2(10);
    v_tico_indi_timb_auto varchar2(10);
  begin
    /* if p_clpr_codi_alte = parameter.p_codi_prov_espo then
      v_indi_espo := upper('s');
    end if;*/
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

  procedure pp_carga_secu_rete(p_secu out number) is
  begin
    select nvl(secu_nume_reten, 0) + 1
      into p_secu
      from come_secu
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Codigo de Secuencia de Cobranzas inexistente');
  end pp_carga_secu_rete;

  FUNCTION fp_calcular_acumulado(p_movi_clpr_codi in number,
                                 p_movi_fech_emis in date) RETURN number IS
    v_return number;
  BEGIN
    select sum(c.canc_impo_mmnn)
      into v_return
      from come_movi_cuot_canc c, come_movi m
     where c.canc_fech_pago >= '01' || substr(p_movi_fech_emis, 3)
       and c.canc_fech_pago <= /*last_day(*/
           p_movi_fech_emis /*)*/
       and c.canc_cuot_movi_codi = m.movi_codi
       and m.movi_clpr_codi = p_movi_clpr_codi;
  
    return v_return;
  
  exception
    when no_data_found then
      return 0;
  END fp_calcular_acumulado;

  procedure pp_veri_nume(p_nume in out number) is
    v_nume number;
  Begin
    v_nume := p_nume;
  
    loop
      begin
        select movi_nume
          into v_nume
          from come_movi
         where movi_nume = v_nume
           and movi_timo_codi in
               (parameter.p_codi_timo_pcor,
                parameter.p_codi_timo_adlr,
                parameter.p_codi_timo_extr_banc,
                parameter.p_codi_timo_orde_pago);
        v_nume := v_nume + 1;
      Exception
        when no_data_found then
          exit;
        when too_many_rows then
          v_nume := v_nume + 1;
      end;
    end loop;
  
    p_nume := v_nume;
  end pp_veri_nume;

  procedure pp_valida_nume_cheq(p_cheq_nume      in varchar2,
                                p_cheq_serie     in varchar2,
                                p_cheq_banc_codi in number,
                                p_go_item        in varchar default null) is
    v_banc_desc varchar2(60);
  begin
    select banc_desc
      into v_banc_desc
      from come_cheq, come_banc
     where cheq_banc_codi = banc_codi
       and rtrim(ltrim(cheq_nume)) = rtrim(ltrim(p_cheq_nume))
       and rtrim(ltrim(cheq_serie)) = rtrim(ltrim(p_cheq_serie))
       and cheq_banc_codi = p_cheq_banc_codi;
  
    if parameter.p_indi_exis_orpa = 'N' then
      if parameter.p_indi_vali_repe_cheq = 'S' then
      
        /*/ if p_go_item = 'S' then
         -- go_item('bcheq_emit.cheq_nume');
        end if;*/
      
        raise_application_error(-20001,
                                'Atenci?n!!! Cheque existente... Numero' ||
                                p_cheq_nume || ' Serie' || p_cheq_serie ||
                                ' Banco ' || v_banc_desc);
      else
        if p_go_item = 'S' then
          --go_item('bcheq_emit.cheq_nume');
          null;
        end if;
        raise_application_error(-20001,
                                'Atenci?n!!! Cheque existente... Numero' ||
                                p_cheq_nume || ' Serie' || p_cheq_serie ||
                                ' Banco ' || v_banc_desc);
      end if;
    end if;
  exception
    when no_data_found then
      null;
    when too_many_rows then
      if parameter.p_indi_vali_repe_cheq = 'S' then
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
/*
  procedure pp_valida_cheques is
  begin
    if parameter.p_indi_vali_repe_cheq = 'S' then
      -- go_block('bfp');
      --- first_record;
      for bfp in forma_pago loop
        if bfp.fopa_codi in ('4') then
          pp_valida_nume_cheq(bfp.cheq_nume,
                              bfp.cheq_serie,
                              bfp.cheq_banc_codi,
                              'N');
        end if;
      end loop;
    end if;
  end pp_valida_cheques;
*/
 

 procedure pp_valida_fech(p_fech in date) is
    v_fech_inic date;
    v_fech_fini date;
  begin
    pa_devu_fech_habi(v_fech_inic, v_fech_fini);
    if p_fech not between v_fech_inic and v_fech_fini then
      raise_application_error(-20001,
                              'La fecha de la orden debe estar comprendida entre..' ||
                              to_char(v_fech_inic, 'dd/mm/yyyy') || ' y ' ||
                              to_char(v_fech_fini, 'dd/mm/yyyy'));
    end if;
  
  end pp_valida_fech;

  procedure pp_valida_importes is
  begin
  
    if bcab.orpa_codi is null then
       
      if bcab.operacion <> 'TV' then
        if nvl(round( bcab.s_impo_sald, 2), 0) <> 0 then
          raise_application_error(-20001,
                                  'Existe diferencia entre los importes en la Forma de Pago. Favor verificar. '||bcab.s_impo_sald);
        end if;
      end if;
      if bcab.operacion = 'VB' then
        if nvl(bcab.SUM_S_MOCO_IMPO, 0) <> bcab.s_impo_mone1 then
          raise_application_error(-20001,
                                  'Existe diferencia entre los importes de concepto y el monto del documento. Favor verificar.');
        end if;
      end if;
    end if;
  
  end pp_valida_importes;

  procedure pp_preparar_cabecera is
  begin
    if bcab.movi_fech_emis is null then
      raise_application_error(-20001,
                              'Debe ingresar la fecha de la orden!.');
    end if;
  
    bcab.orpa_empr_codi := v('AI_EMPR_CODI');
    bcab.orpa_sucu_codi := v('AI_SUCU_CODI');
    bcab.orpa_user      := upper(gen_user);
    bcab.movi_fech_oper := sysdate;
    --  raise_application_error(-20001,'------'||bcab.orpa_impo_mone);
    bcab.orpa_impo_mone := nvl(bcab.orpa_impo_mone, 0);
    bcab.orpa_impo_mmnn := nvl(round((bcab.orpa_impo_mone *
                                     bcab.movi_tasa_mone),
                                     parameter.p_cant_deci_mmnn),
                               0);
    bcab.orpa_rete_mone := nvl(bcab.orpa_rete_mone, 0);
    bcab.orpa_rete_mmnn := nvl(round((bcab.orpa_rete_mone *
                                     bcab.movi_tasa_mone),
                                     parameter.p_cant_deci_mmnn),
                               0);
    bcab.orpa_base      := parameter.p_codi_base;
  
    if bcab.orpa_codi is null then
      bcab.orpa_codi := fa_sec_come_orde_pago;
    end if;
  
    if bcab.orpa_estado is null then
      bcab.orpa_estado := 'P';
    end if;
  
    if bcab.operacion in ('OP') then
      --go_block('bdet');
      --first_record;
      for bdet in detalle loop
        --bdet.deta_base      := parameter.p_codi_base;
        --bdet.deta_orpa_codi := bcab.orpa_codi;
        pp_update_member(bdet.deta_item, 16, bcab.orpa_codi);
      
      end loop;
    end if;
  
  end pp_preparar_cabecera;

  procedure pp_preparar_detalles is
    v_ind_mov varchar2(1) := 'S';
  begin
  
    -- go_block('bdet');
    while v_ind_mov = 'S' loop
      v_ind_mov := 'N';
      --first_record;
      for bdet in detalle loop
        -- bdet.deta_item      := :system.trigger_record;
        -- bdet.deta_impo_mone     := nvl(bdet.deta_impo_mone, 0); --nlv 0
        bdet.deta_impo_mmnn := nvl(round((bdet.deta_impo_mone *
                                         bcab.movi_tasa_mone),
                                         parameter.p_cant_deci_mmnn),
                                   0);
        ---bdet.deta_rete_iva_mone := nvl(bdet.deta_rete_iva_mone, 0);
        bdet.deta_rete_iva_mmnn := nvl(round((bdet.deta_rete_iva_mone *
                                             bcab.movi_tasa_mone),
                                             parameter.p_cant_deci_mmnn),
                                       0);
        --  bdet.deta_rete_ren_mone := nvl(bdet.deta_rete_ren_mone, 0);
        bdet.deta_rete_ren_mmnn := nvl(round((bdet.deta_rete_ren_mone *
                                             bcab.movi_tasa_mone),
                                             parameter.p_cant_deci_mmnn),
                                       0);
      
        I020089.pp_update_member(bdet.deta_item, 18, bdet.deta_impo_mmnn);
        I020089.pp_update_member(bdet.deta_item,
                                 20,
                                 bdet.deta_rete_iva_mmnn);
        I020089.pp_update_member(bdet.deta_item,
                                 22,
                                 bdet.deta_rete_ren_mmnn);
      
      end loop;
    
    end loop;
  end pp_preparar_detalles;

  procedure pp_calcular_importe_cab is
   v_tot pack_fpago.t_fptot;
   v_impo_mone number;
  begin
  
    v_tot := pack_fpago.fp_calc_ingreso_egreso;
  
    --  bcab.movi_exen_mone_adel := bcab.movi_exen_mone ;
    --  bcab.movi_exen_mmnn_adel := round(((bcab.movi_exen_mone_adel)*bcab.movi_tasa_mone), :parameter.p_cant_deci_mmnn);
    bcab.movi_exen_mmnn := round(((bcab.movi_exen_mone) *
                                 bcab.movi_tasa_mone),
                                 parameter.p_cant_deci_mmnn);
  --if parameter.p_emit_reci = 'E'  then
   bcab.s_impo_efec    := nvl(v_tot.s_efec_ingr_movi,0) - nvl(v_tot.s_efec_egre_movi,0); -----  - nvl(:brete.movi_impo_rete, 0);
   bcab.s_impo_cheq    := nvl(v_tot.s_cheq_ingr_movi,0) - nvl(v_tot.s_cheq_egre_movi,0);
   bcab.s_impo_tarj    := nvl(v_tot.s_tarj_ingr_movi,0) - nvl(v_tot.s_tarj_egre_movi,0);
   bcab.s_impo_adel    := nvl(v_tot.s_adel_ingr_movi,0) - nvl(v_tot.s_adel_egre_movi,0);
/* elsif parameter.p_emit_reci = 'R'  then                                         
   bcab.s_impo_efec    := nvl(v_tot.s_efec_egre_movi,0) - nvl(v_tot.s_efec_ingr_movi,0); -----  - nvl(:brete.movi_impo_rete, 0);
   bcab.s_impo_cheq    := nvl(v_tot.s_cheq_egre_movi,0) - nvl(v_tot.s_cheq_ingr_movi,0);
   bcab.s_impo_tarj    := nvl(v_tot.s_tarj_egre_movi,0) - nvl(v_tot.s_tarj_ingr_movi,0);
   bcab.s_impo_adel    := nvl(v_tot.s_adel_egre_movi,0) - nvl(v_tot.s_adel_ingr_movi,0);
   --raise_application_error(-20001,bcab.s_impo_efec);
  end if;*/
    -- pago
    bcab.tota_fact := nvl(bcab.movi_exen_mone, 0);
 -- pago
 --retencion en GS
 bcab.orpa_impo_mmnn := round((bcab.orpa_impo_mone * bcab.movi_tasa_mone), parameter.p_cant_deci_mmnn);
 --raise_application_error(-20001,(nvl(bcab.s_impo_efec,0)+nvl(bcab.s_impo_cheq,0)+nvl(bcab.s_impo_tarj,0)+nvl(bcab.s_impo_adel,0) )||' - '||parameter.p_emit_reci);
  
  
     if (bcab.OPERACION) in ('OP') then
    v_impo_mone := round(bcab.ORPA_IMPO_MONE,bcab.MOVI_MONE_CANT_DECI) - nvl(bcab.ORPA_RETE_MONE, 0);
  elsif (bcab.OPERACION) = 'TV' then
    v_impo_mone:= nvl(bcab.S_IMPO_MONE1, 0);
  elsif (bcab.OPERACION) in ('AP','VB') then
    v_impo_mone:= nvl(bcab.S_IMPO_MONE1, 0);
  end if;
  bcab.s_impo_sald:= v_impo_mone-(nvl(bcab.s_impo_efec,0)+nvl(bcab.s_impo_cheq,0)+nvl(bcab.s_impo_tarj,0)+nvl(bcab.s_impo_adel,0) );

 if bcab.operacion='TV'/* or  bcab.operacion='AP'*/  then
 
 if (nvl(bcab.s_impo_efec,0)+nvl(bcab.s_impo_cheq,0)+nvl(bcab.s_impo_tarj,0)+nvl(bcab.s_impo_adel,0) )<>bcab.s_impo_mmnn1 then
   raise_application_error(-20001,'El importe del documento y el importe del forma de pago es diferente favor verificar.');
   end if;
   end if;
  end pp_calcular_importe_cab;

  procedure pp_actualizar_come_orde_pago is
    --cabecera
    v_orpa_codi           number;
    v_orpa_empr_codi      number;
    v_orpa_sucu_codi      number;
    v_orpa_fech_emis      date;
    v_movi_cuen_codi      number;
    v_orpa_obse           varchar2(100);
    v_movi_tasa_mone      number;
    v_orpa_tasa_mmee      number;
    v_orpa_rete_mone      number;
    v_orpa_rete_mmnn      number;
    v_orpa_estado         varchar2(2);
    v_orpa_ind_planif     varchar2(2);
    v_orpa_rete_movi_codi varchar2(20);
    v_orpa_nume           number;
    v_movi_clpr_codi      number;
    v_orpa_fech_grab      date;
    v_orpa_mone_codi      number;
    v_orpa_impo_mone      number;
    v_orpa_impo_mmnn      number;
    v_orpa_user           varchar2(20);
    v_orpa_base           number;
  
    --detalle
    v_deta_orpa_codi           number;
    v_deta_item                number;
    v_deta_cuot_movi_codi      number;
    v_deta_cuot_fech_venc      date;
    v_deta_impo_mone           number;
    v_deta_impo_mmnn           number;
    v_deta_rete_iva_mone       number;
    v_deta_rete_iva_mmnn       number;
    v_deta_rete_ren_mone       number;
    v_deta_rete_ren_mmnn       number;
    v_deta_base                number;
    v_deta_cuot_pres_movi_codi number;
  
  begin
  
    --cabecera
    v_orpa_codi       := bcab.orpa_codi;
    v_orpa_empr_codi  := parameter.p_empr_codi;
    v_orpa_sucu_codi  := bcab.orpa_sucu_codi;
    v_orpa_fech_emis  := bcab.movi_fech_emis;
    v_movi_cuen_codi  := bcab.movi_cuen_codi;
    v_orpa_obse       := bcab.orpa_obse;
    v_movi_tasa_mone  := bcab.movi_tasa_mone;
    v_orpa_tasa_mmee  := nvl(bcab.orpa_tasa_mmee, bcab.movi_tasa_mone);
    v_orpa_rete_mone  := bcab.orpa_rete_mone;
    v_orpa_rete_mmnn  := bcab.orpa_rete_mmnn;
    v_orpa_estado     := bcab.orpa_estado;
    v_orpa_ind_planif := bcab.orpa_ind_planif;
  
    v_orpa_rete_movi_codi := parameter.p_movi_codi_rete_auxi; --bcab.orpa_rete_movi_codi;
  
    v_orpa_nume      := bcab.orpa_nume;
    v_movi_clpr_codi := bcab.movi_clpr_codi;
    v_orpa_fech_grab := bcab.movi_fech_oper;
    v_orpa_mone_codi := bcab.movi_mone_codi;
    if bcab.operacion in ('AP', 'VB') then
      v_orpa_impo_mone := bcab.s_impo_mone1;
      v_orpa_impo_mmnn := bcab.s_impo_mone1 * nvl(bcab.movi_tasa_mone, 1);
    elsif bcab.operacion in ('OP') then
      v_orpa_impo_mone := bcab.orpa_impo_mone;
      v_orpa_impo_mmnn := bcab.orpa_impo_mmnn;
    elsif bcab.operacion = 'TV' then
      v_orpa_impo_mone := bcab.s_impo_mmnn2;
      v_orpa_impo_mmnn := bcab.s_impo_mone2;
    end if;
    v_orpa_user := bcab.orpa_user;
    v_orpa_base := bcab.orpa_base;
  
    pp_insert_come_orde_pago(v_orpa_codi,
                             v_orpa_empr_codi,
                             v_orpa_sucu_codi,
                             v_orpa_fech_emis,
                             v_movi_cuen_codi,
                             v_orpa_obse,
                             v_movi_tasa_mone,
                             v_orpa_tasa_mmee,
                             v_orpa_rete_mone,
                             v_orpa_rete_mmnn,
                             v_orpa_estado,
                             v_orpa_ind_planif,
                             v_orpa_rete_movi_codi,
                             v_orpa_nume,
                             v_movi_clpr_codi,
                             v_orpa_fech_grab,
                             v_orpa_mone_codi,
                             v_orpa_impo_mone,
                             v_orpa_impo_mmnn,
                             v_orpa_user,
                             v_orpa_base);
  
    if bcab.operacion in ('OP') then
      --detalle corriespondiente al block bdet
    
      for bdet in detalle loop
        v_deta_orpa_codi := bdet.deta_orpa_codi;
        v_deta_item      := bdet.deta_item;
        if bcab.operacion in ('OP') then
          v_deta_cuot_movi_codi      := bdet.deta_cuot_movi_codi;
          v_deta_cuot_pres_movi_codi := null;
        else
          v_deta_cuot_movi_codi      := null;
          v_deta_cuot_pres_movi_codi := bdet.deta_cuot_movi_codi;
        end if;
        v_deta_cuot_fech_venc := bdet.deta_cuot_fech_venc;
        v_deta_impo_mone      := bdet.deta_impo_mone;
        v_deta_impo_mmnn      := bdet.deta_impo_mmnn;
        v_deta_rete_iva_mone  := bdet.deta_rete_iva_mone;
        v_deta_rete_iva_mmnn  := bdet.deta_rete_iva_mmnn;
        v_deta_rete_ren_mone  := bdet.deta_rete_ren_mone;
        v_deta_rete_ren_mmnn  := bdet.deta_rete_ren_mmnn;
        v_deta_base           := bdet.deta_base;
      
        pp_insert_come_orde_pago_deta(v_deta_orpa_codi,
                                      v_deta_item,
                                      v_deta_cuot_movi_codi,
                                      v_deta_cuot_fech_venc,
                                      v_deta_impo_mone,
                                      v_deta_impo_mmnn,
                                      v_deta_rete_iva_mone,
                                      v_deta_rete_iva_mmnn,
                                      v_deta_rete_ren_mone,
                                      v_deta_rete_ren_mmnn,
                                      v_deta_cuot_pres_movi_codi,
                                      v_deta_base);
      
      end loop;
    end if;
  end pp_actualizar_come_orde_pago;

  procedure pp_insert_come_orde_pago(p_orpa_codi           in number,
                                     p_orpa_empr_codi      in number,
                                     p_orpa_sucu_codi      in number,
                                     p_orpa_fech_emis      in date,
                                     p_movi_cuen_codi      in number,
                                     p_orpa_obse           in varchar2,
                                     p_movi_tasa_mone      in number,
                                     p_orpa_tasa_mmee      in number,
                                     p_orpa_rete_mone      in number,
                                     p_orpa_rete_mmnn      in number,
                                     p_orpa_estado         in varchar2,
                                     p_orpa_ind_planif     in varchar2,
                                     p_orpa_rete_movi_codi in varchar2,
                                     p_orpa_nume           in number,
                                     p_movi_clpr_codi      in number,
                                     p_orpa_fech_grab      in date,
                                     p_orpa_mone_codi      in number,
                                     p_orpa_impo_mone      in number,
                                     p_orpa_impo_mmnn      in number,
                                     p_orpa_user           in varchar2,
                                     p_orpa_base           in number) is
  begin
    insert into come_orde_pago
      (orpa_codi,
       orpa_empr_codi,
       orpa_sucu_codi,
       orpa_fech_emis,
       orpa_cuen_codi,
       orpa_obse,
       orpa_tasa_mone,
       orpa_tasa_mmee,
       orpa_rete_mone,
       orpa_rete_mmnn,
       orpa_estado,
       orpa_ind_planif,
       orpa_rete_movi_codi,
       orpa_nume,
       orpa_clpr_codi,
       orpa_fech_grab,
       orpa_mone_codi,
       orpa_impo_mone,
       orpa_impo_mmnn,
       orpa_user,
       orpa_base)
    values
      (p_orpa_codi,
       p_orpa_empr_codi,
       p_orpa_sucu_codi,
       p_orpa_fech_emis,
       p_movi_cuen_codi,
       p_orpa_obse,
       p_movi_tasa_mone,
       p_orpa_tasa_mmee,
       p_orpa_rete_mone,
       p_orpa_rete_mmnn,
       p_orpa_estado,
       p_orpa_ind_planif,
       p_orpa_rete_movi_codi,
       p_orpa_nume,
       p_movi_clpr_codi,
       p_orpa_fech_grab,
       p_orpa_mone_codi,
       p_orpa_impo_mone,
       p_orpa_impo_mmnn,
       p_orpa_user,
       p_orpa_base);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_come_orde_pago;

  procedure pp_insert_come_orde_pago_deta(p_deta_orpa_codi           in number,
                                          p_deta_item                in number,
                                          p_deta_cuot_movi_codi      in number,
                                          p_deta_cuot_fech_venc      in date,
                                          p_deta_impo_mone           in number,
                                          p_deta_impo_mmnn           in number,
                                          p_deta_rete_iva_mone       in number,
                                          p_deta_rete_iva_mmnn       in number,
                                          p_deta_rete_ren_mone       in number,
                                          p_deta_rete_ren_mmnn       in number,
                                          p_deta_cuot_pres_movi_codi in number,
                                          p_deta_base                in number) is
  
  begin
    insert into come_orde_pago_deta
      (deta_orpa_codi,
       deta_item,
       deta_cuot_movi_codi,
       deta_cuot_fech_venc,
       deta_impo_mone,
       deta_impo_mmnn,
       deta_rete_iva_mone,
       deta_rete_iva_mmnn,
       deta_rete_ren_mone,
       deta_rete_ren_mmnn,
       deta_cuot_pres_movi_codi,
       deta_base)
    values
      (p_deta_orpa_codi,
       p_deta_item,
       p_deta_cuot_movi_codi,
       p_deta_cuot_fech_venc,
       p_deta_impo_mone,
       p_deta_impo_mmnn,
       p_deta_rete_iva_mone,
       p_deta_rete_iva_mmnn,
       p_deta_rete_ren_mone,
       p_deta_rete_ren_mmnn,
       p_deta_cuot_pres_movi_codi,
       p_deta_base);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_come_orde_pago_deta;

  procedure pp_actualizar_cuotas(p_oper in varchar2) is
  begin
  
    if p_oper = 'FINI' then
    
      for bdet in detalle loop
        update come_movi_cuot
           set cuot_orpa_codi = null
         where cuot_movi_codi = bdet.deta_cuot_movi_codi
           and cuot_fech_venc = bdet.deta_cuot_fech_venc;
      end loop;
    
    elsif p_oper = 'ORPA' then
      for bdet in detalle loop
        if bdet.ind_marcado = 'X' then
          update come_movi_cuot
             set cuot_orpa_codi = bcab.orpa_codi
           where cuot_movi_codi = bdet.deta_cuot_movi_codi
             and cuot_fech_venc = bdet.deta_cuot_fech_venc;
        end if;
      end loop;
    
    elsif p_oper = 'PRES' then
    
      for bdet in detalle loop
        if bdet.ind_marcado = 'X' then
          update come_movi_cuot_pres
             set cupe_orpa_codi = bcab.orpa_codi
           where cupe_movi_codi = bdet.deta_cuot_movi_codi
             and cupe_fech_venc = bdet.deta_cuot_fech_venc;
        end if;
      
      end loop;
    elsif p_oper = 'BORR' then
    
      for bdet in detalle loop
        update come_movi_cuot
           set cuot_orpa_codi = null
         where cuot_orpa_codi = bcab.orpa_codi;
      end loop;
    
    end if;
  
  end pp_actualizar_cuotas;

  procedure pp_actualiza_come_movi_orde is
    v_movi_codi                number;
    v_movi_timo_codi           number;
    v_movi_clpr_codi           number;
    v_movi_sucu_codi_orig      number;
    v_movi_cuen_codi           number;
    v_movi_mone_codi           number;
    v_movi_nume                number;
    v_movi_fech_emis           date;
    v_movi_fech_grab           date;
    v_movi_fech_oper           date;
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
    v_movi_clpr_desc           varchar2(120);
    v_movi_emit_reci           varchar2(1);
    v_movi_afec_sald           varchar2(1);
    v_movi_dbcr                varchar2(1);
    v_movi_empr_codi           number;
    v_movi_obse                varchar2(100);
    v_tica_codi                number;
    v_movi_depo_codi_orig      number;
    v_movi_depo_codi_dest      number;
    v_movi_sucu_codi_dest      number;
    v_movi_oper_codi           number;
    v_movi_sald_mmnn           number;
    v_movi_sald_mmee           number;
    v_movi_sald_mone           number;
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(100);
    v_movi_clpr_tele           varchar2(50);
    v_movi_clpr_ruc            varchar2(50);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           varchar2(1);
    v_movi_nume_timb           varchar2(20);
    v_movi_fech_venc_timb      date;
    v_movi_orpa_codi           number;
    v_movi_excl_cont           number;
    v_movi_codi_rete           number;
  
  begin
    --insertar el movimiento de salida (extraccion)
    pp_muestra_tipo_movi(parameter.p_codi_timo_orde_pago,
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr,
                         v_tica_codi);
  
    v_movi_codi_padr           := null; --v_movi_codi;
    v_movi_codi                := fa_sec_come_movi;
   bcab.movi_codi :=v_movi_codi;
    parameter.p_movi_codi_orde := v_movi_codi;
    bcab.movi_codi := v_movi_codi;
    v_movi_timo_codi           := to_number(parameter.p_codi_timo_orde_pago);
    v_movi_cuen_codi           := bcab.movi_cuen_codi;
    v_movi_clpr_codi           := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig      := parameter.p_sucu_codi; --:parameter.p_codi_sucu_defa;
    v_movi_mone_codi           := bcab.movi_mone_codi;
    v_movi_nume                := bcab.orpa_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := sysdate;
    v_movi_fech_oper           := bcab.movi_fech_emis;
    v_movi_user                := gen_user;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
  
    --busca la tasa de la moneda extranjera para la fecha de la operaci?n
  
    pp_busca_tasa_mone(bcab.movi_mone_codi,
                       v_movi_fech_emis,
                       v_movi_tasa_mmee,
                       v_tica_codi);
    --pp_busca_tasa_mone (:parameter.p_codi_mone_mmnn, v_movi_fech_emis, v_movi_tasa_mmnn, v_tica_codi);
    --:parameter.p_movi_tasa_mmnn := v_movi_tasa_mmnn;
  
    v_movi_grav_mmnn := 0;
    v_movi_exen_mmnn := bcab.orpa_impo_mmnn;
    v_movi_iva_mmnn  := 0;
    v_movi_grav_mmee := 0;
    v_movi_exen_mmee := round(bcab.orpa_impo_mmnn / v_movi_tasa_mmee,
                              parameter.p_cant_deci_mmee);
    v_movi_iva_mmee  := 0;
    v_movi_grav_mone := 0;
    v_movi_exen_mone := bcab.orpa_impo_mone;
    v_movi_iva_mone  := 0;
    v_movi_clpr_desc := null;
    v_movi_empr_codi := null;
    v_movi_obse      := bcab.orpa_obse || ' - OP Nro ' || v_movi_nume;
    v_movi_orpa_codi := bcab.orpa_codi;
    v_movi_excl_cont := null;
    v_movi_codi_rete := null;
  
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
                        v_movi_fech_oper,
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
                        v_movi_orpa_codi,
                        v_movi_excl_cont,
                        v_movi_codi_rete);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualiza_come_movi_orde;

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
                                p_movi_fech_oper           in date,
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
                                p_movi_orpa_codi           in number,
                                p_movi_excl_cont           in varchar2,
                                p_movi_codi_rete           in number) is
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
       movi_fech_oper,
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
       movi_nume_timb,
       movi_fech_venc_timb,
       movi_orpa_codi,
       movi_excl_cont,
       movi_codi_rete,
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
       p_movi_fech_oper,
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
       p_movi_nume_timb,
       p_movi_fech_venc_timb,
       p_movi_orpa_codi,
       p_movi_excl_cont,
       p_movi_codi_rete,
       parameter.p_codi_base);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_come_movi;

  procedure pp_actualizar_moco_orde is
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      varchar2(1);
  begin
    --actualizar come_movi_conc_deta
    v_moco_movi_codi := parameter.p_movi_codi_orde;
    v_moco_nume_item := 0;
    v_moco_conc_codi := parameter.p_codi_conc_orde_pago;
    v_moco_dbcr      := 'C';
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_exen;
    v_moco_impo_mmnn := bcab.orpa_impo_mmnn;
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := bcab.orpa_impo_mone;
  
    pp_insert_movi_conc_deta(v_moco_movi_codi,
                             v_moco_nume_item,
                             v_moco_conc_codi,
                             v_moco_cuco_codi,
                             v_moco_impu_codi,
                             v_moco_impo_mmnn,
                             v_moco_impo_mmee,
                             v_moco_impo_mone,
                             v_moco_dbcr);
  end pp_actualizar_moco_orde;

  procedure pp_insert_movi_conc_deta(p_moco_movi_codi number,
                                     p_moco_nume_item number,
                                     p_moco_conc_codi number,
                                     p_moco_cuco_codi number,
                                     p_moco_impu_codi number,
                                     p_moco_impo_mmnn number,
                                     p_moco_impo_mmee number,
                                     p_moco_impo_mone number,
                                     p_moco_dbcr      varchar2) is
  
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
       moco_dbcr)
    values
      (p_moco_movi_codi,
       p_moco_nume_item,
       p_moco_conc_codi,
       p_moco_cuco_codi,
       p_moco_impu_codi,
       p_moco_impo_mmnn,
       p_moco_impo_mmee,
       p_moco_impo_mone,
       p_moco_dbcr);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_movi_conc_deta;

  procedure pp_actualizar_moimpu_orde is
    v_moim_impu_codi number;
    v_moim_movi_codi number;
    v_moim_impo_mmnn number;
    v_moim_impo_mmee number;
    v_moim_impu_mmnn number;
    v_moim_impu_mmee number;
    v_moim_impo_mone number;
    v_moim_impu_mone number;
  
  begin
    --actualizar come_movi_impu_deta
    v_moim_impu_codi := to_number(parameter.p_codi_impu_exen);
    v_moim_movi_codi := parameter.p_movi_codi_orde;
    v_moim_impo_mmnn := bcab.orpa_impo_mmnn;
    v_moim_impo_mmee := 0;
    v_moim_impu_mmnn := 0;
    v_moim_impu_mmee := 0;
    v_moim_impo_mone := bcab.orpa_impo_mone;
    v_moim_impu_mone := 0;
  
    pp_insert_come_movi_impu_deta(v_moim_impu_codi,
                                  v_moim_movi_codi,
                                  v_moim_impo_mmnn,
                                  v_moim_impo_mmee,
                                  v_moim_impu_mmnn,
                                  v_moim_impu_mmee,
                                  v_moim_impo_mone,
                                  v_moim_impu_mone);
  end pp_actualizar_moimpu_orde;

  procedure pp_insert_come_movi_impu_deta(p_moim_impu_codi in number,
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
       parameter.p_codi_base);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_insert_come_movi_impu_deta;


  PROCEDURE pp_asig_indi_dbcr(p_fopa_codi      in number,
                              p_pago_cobr_indi out varchar2) IS
  BEGIN
    ----indicador ingreso o egreso
  
    if p_fopa_codi = '1' then
      if bcab.movi_dbcr_caja = 'C' then
        p_pago_cobr_indi := 'C';
      else
        p_pago_cobr_indi := 'D';
      end if;
    elsif p_fopa_codi = '4' then
      p_pago_cobr_indi := 'C';
    elsif p_fopa_codi = '5' then
      if bcab.movi_dbcr_caja = 'C' then
        p_pago_cobr_indi := 'D';
      else
        p_pago_cobr_indi := 'C';
      end if;
    end if;
  
  END pp_asig_indi_dbcr;

  procedure pp_validar_nume_rete(p_nume in number) is
    v_timo_tico_codi number;
    v_tico_fech_rein date;
    v_cant_repe      number;
  begin
    begin
      select timo_tico_codi, tico_fech_rein
        into v_timo_tico_codi, v_tico_fech_rein
        from come_tipo_movi, come_tipo_comp
       where timo_tico_codi = tico_codi
         and timo_codi = parameter.p_codi_timo_rete_emit;
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'Tipo de movimiento configurado como Retencion Emitida no posee Tipo de Comprobante');
    end;
  
    if bcab.movi_fech_emis >=
       nvl(v_tico_fech_rein, to_date('01-01-1990', 'dd-mm-yyyy')) then
      begin
        select count(*)
          into v_cant_repe
          from come_movi m, come_tipo_movi t
         where m.movi_timo_codi = t.timo_codi
           and t.timo_tico_codi = v_timo_tico_codi
           and m.movi_fech_emis >=
               nvl(v_tico_fech_rein, to_date('01-01-1990', 'dd-mm-yyyy'))
           and m.movi_nume = p_nume;
      exception
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    else
      begin
        select count(*)
          into v_cant_repe
          from come_movi m, come_tipo_movi t
         where m.movi_timo_codi = t.timo_codi
           and t.timo_tico_codi = v_timo_tico_codi
           and m.movi_fech_emis <
               nvl(v_tico_fech_rein, to_date('01-01-1990', 'dd-mm-yyyy'))
           and m.movi_nume = p_nume;
      exception
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    end if;
  
    if nvl(v_cant_repe, 0) > 0 then
      if parameter.p_indi_exis_orpa = 'N' then
        raise_application_error(-20001,
                                'El numero de comprobante de Retencion ya ha sido registrado previamente.');
      end if;
    end if;
  end pp_validar_nume_rete;

  procedure pp_actualiza_come_movi_rete is
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
    v_movi_fech_oper           date;
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
    v_movi_orpa_codi           number;
    v_movi_excl_cont           varchar2(1);
  
    v_timo_tico_codi number;
    v_tico_indi_timb varchar2(1);
    --v_nro_1               varchar2(3);
    --v_nro_2               varchar2(3);
    v_movi_nume_timb      varchar2(20);
    v_movi_fech_venc_timb date;
    v_movi_codi_rete      number;
  
  begin
    --- asignar valores....
    select timo_tico_codi,
           tico_indi_timb,
           timo_emit_reci,
           timo_afec_sald,
           timo_dbcr
      into v_timo_tico_codi,
           v_tico_indi_timb,
           v_movi_emit_reci,
           v_movi_afec_sald,
           v_movi_dbcr
      from come_tipo_movi, come_tipo_comp
     where timo_tico_codi = tico_codi(+)
       and timo_codi = parameter.p_codi_timo_rete_emit;
  
    --v_movi_nume := fp_secu_nume_reten;
    v_movi_nume           := brete.movi_nume_rete;
    v_movi_nume_timb      := brete.movi_nume_timb_rete;
    v_movi_fech_venc_timb := brete.movi_fech_venc_timb_rete;
    --v_movi_fech_oper         :=     bcab.orpa_fech_oper;
  
    /*
    v_nro_1     := substr(rtrim(ltrim(to_char(v_movi_nume, '0000000000000'))), 1, 3);
    v_nro_2     := substr(rtrim(ltrim(to_char(v_movi_nume, '0000000000000'))), 4, 3);
    
    pp_validar_timbrado_rete (v_timo_tico_codi, 
                       v_nro_1,
                       v_nro_2, 
                       bcab.movi_clpr_codi, 
                       bcab.movi_fech_emis, 
                       v_movi_nume_timb, 
                       v_movi_fech_venc_timb,
                       v_tico_indi_timb);
      */
  
    v_movi_codi                     := fa_sec_come_movi;
    parameter.p_movi_codi_rete      := v_movi_codi;
    parameter.p_movi_codi_rete_auxi := v_movi_codi;
    v_movi_timo_codi                := parameter.p_codi_timo_rete_emit;
    v_movi_clpr_codi                := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig           := null;
    v_movi_depo_codi_orig           := null;
    v_movi_sucu_codi_dest           := null;
    v_movi_depo_codi_dest           := null;
    v_movi_oper_codi                := null;
    v_movi_cuen_codi                := null; --:bdet.movi_cuen_codi;
    v_movi_mone_codi                := bcab.movi_mone_codi;
    --v_movi_nume                       := :bdet.movi_nume;
    parameter.p_movi_nume_rete := v_movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis; --to_date(to_char(sysdate, 'dd-mm-yyyy'), 'dd-mm-yyyy');--bcab.movi_fech_emis;
    v_movi_fech_grab           := sysdate; --bcab.movi_fech_grab;
    v_movi_fech_oper           := bcab.movi_fech_emis; --to_date(to_char(sysdate, 'dd-mm-yyyy'), 'dd-mm-yyyy');--bcab.movi_fech_emis;
    v_movi_user                := gen_user; --bcab.movi_user;
    v_movi_codi_padr           := parameter.p_movi_codi_orde; --null;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := null;
    v_movi_grav_mmnn           := 0; --bcab.movi_grav_mmnn;
    v_movi_exen_mmnn           := bcab.orpa_rete_mmnn; --bcab.movi_exen_mmnn;
    v_movi_iva_mmnn            := 0; --bcab.movi_iva_mmnn;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := 0; --bcab.movi_grav_mone;
    v_movi_exen_mone           := bcab.orpa_rete_mone; --bcab.movi_exen_mone;
    v_movi_iva_mone            := 0; --bcab.movi_iva_mone;
    v_movi_obse                := 'Retencion a OP ' || bcab.orpa_nume;
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
    v_movi_orpa_codi           := null;
    v_movi_excl_cont           := 'S';
    v_movi_codi_rete           := null;
  
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
                        v_movi_fech_oper,
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
                        v_movi_orpa_codi,
                        v_movi_excl_cont,
                        v_movi_codi_rete);
  end pp_actualiza_come_movi_rete;

  procedure pp_actualizar_moco_rete is
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      varchar2(1);
  
    v_conc_indi_ortr varchar2(1);
  
  begin
    begin
      select rtrim(ltrim(conc_dbcr)), conc_indi_ortr
        into v_moco_dbcr, v_conc_indi_ortr
        from come_conc
       where conc_codi = parameter.p_codi_conc_rete_emit;
    
      if nvl(v_conc_indi_ortr, 'N') = 'S' then
        raise_application_error(-20001,
                                'No se puede utilizar el concepto configurado para retenciones porque debe estar relacionada a una OT');
      end if;
    
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'Concepto configurado para retenciones inexistente!.');
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
    ----actualizar moco.... 
    v_moco_movi_codi := parameter.p_movi_codi_rete;
    v_moco_nume_item := 0;
    v_moco_conc_codi := parameter.p_codi_conc_rete_emit;
    --v_moco_dbcr      := 'D';
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_exen;
    v_moco_impo_mmnn := bcab.orpa_rete_mmnn;
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := bcab.orpa_rete_mone;
  
    pp_insert_movi_conc_deta(v_moco_movi_codi,
                             v_moco_nume_item,
                             v_moco_conc_codi,
                             v_moco_cuco_codi,
                             v_moco_impu_codi,
                             v_moco_impo_mmnn,
                             v_moco_impo_mmee,
                             v_moco_impo_mone,
                             v_moco_dbcr);
  
  end pp_actualizar_moco_rete;

  procedure pp_actualizar_moimpu_rete is
    v_moim_impu_codi number;
    v_moim_movi_codi number;
    v_moim_impo_mmnn number;
    v_moim_impo_mmee number;
    v_moim_impu_mmnn number;
    v_moim_impu_mmee number;
    v_moim_impo_mone number;
    v_moim_impu_mone number;
  begin
    --actualizar come_movi_impu_deta
    v_moim_impu_codi := to_number(parameter.p_codi_impu_exen);
    v_moim_movi_codi := parameter.p_movi_codi_rete;
    v_moim_impo_mmnn := bcab.orpa_rete_mmnn;
    v_moim_impo_mmee := 0;
    v_moim_impu_mmnn := 0;
    v_moim_impu_mmee := 0;
    v_moim_impo_mone := bcab.orpa_rete_mone;
    v_moim_impu_mone := 0;
  
    pp_insert_come_movi_impu_deta(v_moim_impu_codi,
                                  v_moim_movi_codi,
                                  v_moim_impo_mmnn,
                                  v_moim_impo_mmee,
                                  v_moim_impu_mmnn,
                                  v_moim_impu_mmee,
                                  v_moim_impo_mone,
                                  v_moim_impu_mone);
  end pp_actualizar_moimpu_rete;

  procedure pp_actu_secu_rete is
  begin
    update come_secu
       set secu_nume_reten = parameter.p_movi_nume_rete
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  end pp_actu_secu_rete;

  procedure pp_actu_fact is
    cursor c_movi is
      select deta_cuot_movi_codi movi_codi,
             sum(deta_rete_iva_mone) deta_rete_iva_mone,
             sum(deta_rete_iva_mmnn) deta_rete_iva_mmnn
        from come_orde_pago_deta d
       where d.deta_orpa_codi = bcab.orpa_codi
         and nvl(d.deta_rete_iva_mone, 0) <> 0
       group by deta_cuot_movi_codi;
  
  begin
    if nvl(parameter.p_form_calc_rete_emit, 1) = 1 then
      -- Formula que retiene una sola vez por toda la factura
      for k in c_movi loop
        if k.deta_rete_iva_mone > 0 or k.deta_rete_iva_mmnn > 0 then
          update come_movi
             set movi_codi_rete = parameter.p_movi_codi_rete
           where movi_codi = k.movi_codi;
        end if;
      end loop;
    end if;
    if parameter.p_indi_rete_tesaka = 'N' then
      for k in c_movi loop
        if k.deta_rete_iva_mone > 0 then
          insert into come_movi_rete
            (more_movi_codi,
             more_movi_codi_rete,
             more_tipo_rete,
             more_impo_mone,
             more_impo_mmnn,
             more_tasa_mone,
             more_movi_codi_pago,
             more_orpa_codi)
          values
            (k.movi_codi,
             parameter.p_movi_codi_rete,
             parameter.p_form_calc_rete_emit,
             k.deta_rete_iva_mone,
             (k.deta_rete_iva_mone * bcab.movi_tasa_mone),
             bcab.movi_tasa_mone,
             parameter.p_movi_codi_orde,
             bcab.orpa_codi);
        end if;
      end loop;
    end if;
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actu_fact;

  procedure pp_actualiza_come_movi_rere(p_movi_nume      in number,
                                        p_tota_impo_mone in number,
                                        p_indi_reci_padr in varchar2) is
  
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
    v_movi_fech_oper           date;
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
  
    v_timo_tico_codi      number;
    v_tico_indi_timb      varchar2(1);
    v_movi_nume_timb      varchar2(20);
    v_movi_fech_venc_timb date;
    v_movi_orpa_codi      number;
    v_movi_excl_cont      varchar2(1);
    v_movi_codi_rete      number;
  
  begin
    -- asignar valores
    select timo_tico_codi,
           tico_indi_timb,
           timo_emit_reci,
           timo_afec_sald,
           timo_dbcr
      into v_timo_tico_codi,
           v_tico_indi_timb,
           v_movi_emit_reci,
           v_movi_afec_sald,
           v_movi_dbcr
      from come_tipo_movi, come_tipo_comp
     where timo_tico_codi = tico_codi(+)
       and timo_codi = parameter.p_codi_timo_rere;
  
    v_movi_codi                := fa_sec_come_movi;
    parameter.p_movi_codi_rere := v_movi_codi;
    v_movi_timo_codi           := parameter.p_codi_timo_rere;
    v_movi_clpr_codi           := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig      := null;
    v_movi_depo_codi_orig      := null;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := null;
    v_movi_cuen_codi           := bcab.movi_cuen_codi;
    v_movi_mone_codi           := bcab.movi_mone_codi;
    v_movi_nume                := p_movi_nume; --:bpie.s_reci_nume;--bcab.movi_nume;
    v_movi_fech_emis           :=  /*:bpie.*/
     bcab.reci_fech; --bcab.movi_fech_emis;
    v_movi_fech_grab           := sysdate; --bcab.movi_fech_grab;
    v_movi_fech_oper           :=  /*:bpie.*/
     bcab.reci_fech; --bcab.movi_fech_emis;
    v_movi_user                := gen_user; --bcab.movi_user;
  
    if nvl(p_indi_reci_padr, 's') = 's' then
      v_movi_codi_padr              := null;
      parameter.p_movi_codi_rere_pa := parameter.p_movi_codi_rere;
    else
      v_movi_codi_padr := parameter.p_movi_codi_rere_pa;
    end if;
  
    v_movi_tasa_mone      := bcab.movi_tasa_mone;
    v_movi_tasa_mmee      := null;
    v_movi_grav_mmnn      := 0; --bcab.movi_grav_mmnn;
    v_movi_exen_mmnn      := round(p_tota_impo_mone * bcab.movi_tasa_mone,
                                   parameter.p_cant_deci_mmnn); --bcab.orpa_impo_mmnn;--bcab.movi_exen_mmnn;
    v_movi_iva_mmnn       := 0; --bcab.movi_iva_mmnn;
    v_movi_grav_mmee      := null;
    v_movi_exen_mmee      := null;
    v_movi_iva_mmee       := null;
    v_movi_grav_mone      := 0; --bcab.movi_grav_mone;
    v_movi_exen_mone      := p_tota_impo_mone; --bcab.orpa_impo_mone;--bcab.movi_exen_mone;
    v_movi_iva_mone       := 0; --bcab.movi_iva_mone;
    v_movi_obse           := 'Pago por OP ' || bcab.orpa_nume;
    v_movi_sald_mmnn      := 0;
    v_movi_sald_mmee      := 0;
    v_movi_sald_mone      := 0;
    v_movi_stoc_suma_rest := null;
  
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
    v_movi_nume_timb           := null;
    v_movi_fech_venc_timb      := null;
  
    v_movi_orpa_codi := bcab.orpa_codi;
    v_movi_excl_cont := null;
    if nvl(parameter.p_form_calc_rete_emit, 1) = 2 then
      -- Formula que retiene iva prorrateado
      v_movi_codi_rete := bcab.orpa_rete_movi_codi;
    else
      v_movi_codi_rete := null;
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
                        v_movi_fech_oper,
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
                        v_movi_orpa_codi,
                        v_movi_excl_cont,
                        v_movi_codi_rete);
  end pp_actualiza_come_movi_rere;

  procedure pp_auto_insertar_cance_rere is
  begin
    -- go_block('bdet');
    -- first_record;
    for bdet in detalle loop
      if bdet.deta_impo_mone > 0 and nvl(bdet.ind_marcado, 'n') = 'X' then
        insert into come_movi_cuot_canc
          (canc_movi_codi,
           canc_cuot_movi_codi,
           canc_cuot_fech_venc,
           canc_fech_pago,
           canc_impo_mone,
           canc_impo_mmnn,
           canc_impo_mmee)
        values
          (parameter.p_movi_codi_rere,
           bdet.deta_cuot_movi_codi,
           bdet.deta_cuot_fech_venc,
           /* bpie*/
           bcab.reci_fech,
           bdet.deta_impo_mone,
           bdet.deta_impo_mmnn,
           0);
      end if;
    end loop;
  end pp_auto_insertar_cance_rere;

  procedure pp_actualizar_moco_rere(p_tota_impo_mone in number) is
  
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      varchar2(1);
  
  begin
    --actualizar moco.... 
    v_moco_movi_codi := parameter.p_movi_codi_rere;
    v_moco_nume_item := 0;
    v_moco_conc_codi := parameter.p_codi_conc;
    v_moco_dbcr      := 'D';
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_exen;
    v_moco_impo_mmnn := round(p_tota_impo_mone * bcab.movi_tasa_mone,
                              parameter.p_cant_deci_mmnn); --bcab.orpa_impo_mmnn;
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := p_tota_impo_mone; --bcab.orpa_impo_mone;  
  
    pp_insert_movi_conc_deta(v_moco_movi_codi,
                             v_moco_nume_item,
                             v_moco_conc_codi,
                             v_moco_cuco_codi,
                             v_moco_impu_codi,
                             v_moco_impo_mmnn,
                             v_moco_impo_mmee,
                             v_moco_impo_mone,
                             v_moco_dbcr);
  end pp_actualizar_moco_rere;

  procedure pp_actualizar_moimpu_rere(p_tota_impo_mone in number) is
    v_impo_mmnn number;
  begin
    v_impo_mmnn := round(p_tota_impo_mone * bcab.movi_tasa_mone,
                         parameter.p_cant_deci_mmnn);
  
    --actualizar moim...
    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  parameter.p_movi_codi_rere,
                                  v_impo_mmnn,
                                  0,
                                  0,
                                  0,
                                  p_tota_impo_mone,
                                  0);
  
  end pp_actualizar_moimpu_rere;

  procedure pp_auto_generar_recibos is
    v_movi_nume      number;
    v_tota_impo_mone number;
    v_indi_reci_padr varchar2(1);
  begin
    v_indi_reci_padr := 's';
    --v_movi_nume      := null;
  
    v_movi_nume      :=  /*:bpie.*/
     bcab.s_reci_nume;
    v_tota_impo_mone :=  /*:bdet*/
     bcab.F_TOT_DETA_IMPO_MONE;
  
    pp_actualiza_come_movi_rere(v_movi_nume,
                                v_tota_impo_mone,
                                v_indi_reci_padr);
    pp_auto_insertar_cance_rere;
    pp_actualizar_moco_rere(v_tota_impo_mone);
    pp_actualizar_moimpu_rere(v_tota_impo_mone);
  
  end;

  procedure pp_auto_confirmar_orden_pago is
    salir exception;
  begin
  
    pp_preparar_cabecera;
    --pp_preparar_detalles; validar en la consula de collection...
  
    if /*:bpie.*/
     bcab.s_reci_nume is null then
      /* :bpie.*/
      bcab.s_reci_nume := bcab.orpa_nume;
    end if;
    if /*:bpie.*/
     bcab.reci_fech is null then
      /* :bpie.*/
      bcab.reci_fech := bcab.movi_fech_emis;
    end if;
  
    -- go_block('bpie');
    pp_calcular_importe_cab;
    pp_auto_generar_recibos;
    pp_actualizar_cuotas('FINI');
  
    update come_orde_pago
       set orpa_estado = 'F'
     where orpa_codi = bcab.orpa_codi;
  
  exception
    when salir then
      null;
  end pp_auto_confirmar_orden_pago;

  procedure pp_actu_orden is
  begin
    update come_orde_pago
       set orpa_rete_movi_codi = parameter.p_movi_codi_rete
     where orpa_codi = bcab.orpa_codi;
  
    update come_orde_pago_deta d
       set d.deta_rete_movi_codi = parameter.p_movi_codi_rete
     where d.deta_orpa_codi = bcab.orpa_codi
       and nvl(d.deta_rete_iva_mone, 0) <> 0;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actu_orden;

  procedure pp_insert_come_movi_impo_deta(p_moim_movi_codi      in number,
                                          p_moim_nume_item      in number,
                                          p_moim_tipo           in varchar2,
                                          p_moim_cuen_codi      in number,
                                          p_moim_dbcr           in varchar2,
                                          p_moim_afec_caja      in varchar2,
                                          p_moim_fech           in date,
                                          p_moim_impo_mone      in number,
                                          p_moim_impo_mmnn      in number,
                                          p_moim_fech_oper      in date,
                                          p_moim_cheq_codi      in number,
                                          p_moim_tarj_cupo_codi in number,
                                          p_moim_movi_codi_vale in number,
                                          p_moim_form_pago      in number) is
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
       moim_cheq_codi,
       moim_tarj_cupo_codi,
       moim_movi_codi_vale,
       moim_form_pago)
    values
      (
       
       p_moim_movi_codi,
       p_moim_nume_item,
       p_moim_tipo,
       p_moim_cuen_codi,
       p_moim_dbcr,
       p_moim_afec_caja,
       p_moim_fech,
       p_moim_impo_mone,
       p_moim_impo_mmnn,
       parameter.p_codi_base,
       p_moim_fech_oper,
       p_moim_cheq_codi,
       p_moim_tarj_cupo_codi,
       p_moim_movi_codi_vale,
       p_moim_form_pago);
  
    if p_moim_form_pago in (1, 5) then
      update come_movi
         set movi_cuen_codi = p_moim_cuen_codi
       where movi_codi = p_moim_movi_codi;
    end if;
  end;

  procedure pp_insert_movi_conc_deta_rete(p_moco_movi_codi in number,
                                          p_moco_nume_item in number,
                                          p_moco_conc_codi in number,
                                          p_moco_cuco_codi in number,
                                          p_moco_impu_codi in number,
                                          p_moco_impo_mmnn in number,
                                          p_moco_impo_mmee in number,
                                          p_moco_impo_mone in number,
                                          p_moco_dbcr      in varchar2,
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
       parameter.p_codi_base);
  
  exception
  
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_movi_conc_deta_rete;

  procedure pp_insert_come_movi_impu_rete(p_moim_impu_codi in number,
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
       parameter.p_codi_base);
  
  Exception
    when others then
      general_skn.pl_exhibir_error_plsql;
  end pp_insert_come_movi_impu_rete;

  procedure pp_actu_secu_rete_tesa(p_movi_nume in number) is
  begin
    update come_secu
       set SECU_NUME_RETEN = p_movi_nume
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  end pp_actu_secu_rete_tesa;

  procedure pp_insert_come_movi_rete(p_movi_codi                in number,
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
       parameter.p_codi_base,
       p_movi_nume_timb,
       p_movi_fech_oper,
       p_movi_fech_venc_timb,
       p_movi_codi_rete,
       p_movi_excl_cont,
       p_movi_clpr_situ,
       p_movi_clpr_empl_codi_recl,
       p_movi_clpr_sucu_nume_item);
  
  Exception
  
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_come_movi_rete;

  PROCEDURE pp_actualizar_rete_tesaka(p_orpa_codi      in number,
                                      p_canc_movi_codi in number) IS
    cursor cv_canc is
      select deta_orpa_codi,
             deta_cuot_movi_codi,
             movi_nume fact_nume,
             sum(deta_rete_iva_mone) rete_impo_mone,
             sum(deta_rete_iva_mmnn) rete_impo_mmnn
        from come_orde_pago_deta, come_movi
       where deta_cuot_movi_codi = movi_codi
         and deta_orpa_codi = p_orpa_codi
         and nvl(deta_rete_iva_mone, 0) > 0
       group by deta_orpa_codi, deta_cuot_movi_codi, movi_nume;
  
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
    v_movi_impo_reca           number;
    v_movi_clpr_situ           number;
    v_movi_clpr_empl_codi_recl number;
    v_movi_clpr_sucu_nume_item number;
  
    --v_timo_tico_codi      number;
    v_tico_indi_timb varchar2(1);
    --v_nro_1               varchar2(3);
    --v_nro_2               varchar2(3);
    v_movi_nume_timb      varchar2(20);
    v_movi_fech_venc_timb date;
  
    v_moim_movi_codi number;
    v_moim_nume_item number := 0;
    v_moim_tipo      varchar2(20);
    v_moim_cuen_codi number;
    v_moim_dbcr      varchar2(1);
    v_moim_afec_caja varchar2(1);
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
    v_moco_dbcr      varchar2(1);
    --v_conc_indi_ortr varchar2(1);
    v_tico_codi number;
    v_esta      number;
    v_expe      number;
    v_nume      number;
  
    v_more_movi_codi      number;
    v_more_movi_codi_rete number;
    v_more_movi_codi_pago number;
    v_more_orpa_codi      number;
    v_more_tipo_rete      varchar2(2);
    v_more_impo_mone      number(20, 4);
    v_more_impo_mmnn      number(20, 4);
    v_more_tasa_mone      number(20, 4);
    --v_resp  varchar2(1000);
    e_secu_nume exception;
    e_timb      exception;
  
  BEGIN
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
      v_movi_codi           := fa_sec_come_movi;
      v_movi_timo_codi      := parameter.p_codi_timo_rete_emit;
      v_movi_clpr_codi      := bcab.movi_clpr_codi;
      v_movi_sucu_codi_orig := null;
      v_movi_depo_codi_orig := null;
      v_movi_sucu_codi_dest := null;
      v_movi_depo_codi_dest := null;
      v_movi_oper_codi      := null;
      v_movi_cuen_codi      := null;
      v_movi_mone_codi      := bcab.movi_mone_codi;
      v_movi_fech_emis      := bcab.movi_fech_emis;
      v_movi_fech_oper      := bcab.movi_fech_emis;
      v_movi_fech_grab      := sysdate;
      v_movi_user           := gen_user;
      v_movi_codi_padr      := null;
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
      v_movi_obse           := 'Retenci?n Factura Nro. ' || r.fact_nume;
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
      v_movi_clpr_situ           := null;
      v_movi_clpr_empl_codi_recl := null;
      v_movi_clpr_sucu_nume_item := null;
    
      pp_insert_come_movi_rete(v_movi_codi,
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
    
      pp_insert_movi_conc_deta_rete(v_moco_movi_codi,
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
    
      pp_insert_come_movi_impu_rete(to_number(parameter.p_codi_impu_exen),
                                    v_movi_codi,
                                    v_movi_exen_mmnn,
                                    0,
                                    0,
                                    0,
                                    v_movi_exen_mone,
                                    0,
                                    null);
    
      pp_actu_secu_rete_tesa(v_movi_nume);
    
      v_more_movi_codi      := r.deta_cuot_movi_codi;
      v_more_movi_codi_rete := v_movi_codi;
      v_more_movi_codi_pago := parameter.p_movi_codi_orde;
      v_more_orpa_codi      := p_orpa_codi;
      v_more_tipo_rete      := parameter.p_form_calc_rete_emit;
      v_more_impo_mone      := r.rete_impo_mone;
      v_more_impo_mmnn      := r.rete_impo_mmnn;
      v_more_tasa_mone      := bcab.movi_tasa_mone;
    
      insert into come_movi_rete
        (more_movi_codi,
         more_movi_codi_rete,
         more_movi_codi_pago,
         more_orpa_codi,
         more_tipo_rete,
         more_impo_mone,
         more_impo_mmnn,
         more_tasa_mone)
      values
        (v_more_movi_codi,
         v_more_movi_codi_rete,
         v_more_movi_codi_pago,
         v_more_orpa_codi,
         v_more_tipo_rete,
         v_more_impo_mone,
         v_more_impo_mmnn,
         v_more_tasa_mone);
    
      update come_orde_pago_deta d
         set d.deta_rete_movi_codi = v_more_movi_codi_rete
       where d.deta_orpa_codi = bcab.orpa_codi
         and d.deta_cuot_movi_codi = v_more_movi_codi
         and nvl(d.deta_rete_iva_mone, 0) <> 0;
    end loop;
  
  exception
    when e_secu_nume then
      raise_application_error(-20001,
                              'Error al recuperar la Secuencia de Retencion Emitida.');
    when e_timb then
      raise_application_error(-20001,
                              'Error al recuperar Timbrado de Retencion Emitida');
  END pp_actualizar_rete_tesaka;

  PROCEDURE pp_generar_tesaka IS
    salir  exception;
    v_resp varchar2(1000);
  BEGIN
    --Preguntar si se desea imprimir el reporte... 
    /*  if fl_confirmar_reg('Desea generar el Archivo para Tesaka?') <> upper('confirmar') then
      raise salir;
    end if;*/
  
    pa_gene_tesaka('OP_' || bcab.orpa_nume || '_' || bcab.movi_clpr_desc || '_' ||
                   to_char(bcab.movi_fech_emis, 'dd_mm_yyyy') || '.txt',
                   null,
                   null,
                   null,
                   null,
                   bcab.orpa_codi,
                   null,
                   null,
                   v_resp);
  EXCEPTION
    when salir then
      null;
  END pp_generar_tesaka;

  procedure pp_valida_cuen_tv is
  
  begin
    for bfp in forma_pago loop
      if nvl(bcab.movi_cuen_codi, 0) <> nvl(bfp.moim_cuen_codi, 0) then
        raise_application_error(-20001,
                                'Las cajas de FP deben ser igual a la Caja de origen para Transferencia de Valores, favor verifique.');
      end if;
    end loop;
  
  end pp_valida_cuen_tv;

  procedure pp_actualizar_movi_tv is
  
    v_movi_codi           number;
    v_movi_timo_codi      number;
    v_movi_clpr_codi      number;
    v_movi_sucu_codi_orig number;
    v_movi_cuen_codi      number;
    v_movi_mone_codi      number;
    v_movi_nume           number;
    v_movi_fech_emis      date;
    v_movi_fech_grab      date;
    v_movi_fech_oper      date;
    v_movi_user           varchar2(20);
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
    v_movi_clpr_desc      varchar2(120);
    v_movi_emit_reci      varchar2(1);
    v_movi_afec_sald      varchar2(1);
    v_movi_dbcr           varchar2(1);
    v_movi_empr_codi      number;
    v_movi_obse           varchar2(100);
    v_tica_codi           number;
  
    --variables para moco
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      varchar2(1);
  
    --variables para moimpo 
    --v_moim_movi_codi number;
    --v_moim_nume_item number := 0;
    --v_moim_tipo      varchar2(20);
    --v_moim_cuen_codi number;
    --v_moim_dbcr      varchar2(1);
    --v_moim_afec_caja varchar2(1);
    --v_moim_fech      date;
    --v_moim_fech_oper date;
    --v_moim_impo_mone number;
    --v_moim_impo_mmnn number;
    --v_moim_cheq_codi number;
  
    --variables para moimpu
    v_movi_depo_codi_orig      number;
    v_movi_depo_codi_dest      number;
    v_movi_sucu_codi_dest      number;
    v_movi_oper_codi           number;
    v_movi_sald_mmnn           number;
    v_movi_sald_mmee           number;
    v_movi_sald_mone           number;
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(100);
    v_movi_clpr_tele           varchar2(50);
    v_movi_clpr_ruc            varchar2(50);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           varchar2(1);
    v_movi_nume_timb           varchar2(20);
    v_movi_fech_venc_timb      date;
    v_movi_orpa_codi           number;
    v_movi_excl_cont           varchar2(1);
    v_movi_codi_rete           number;
    --v_moim_tarj_codi           number;
    --v_moim_tarj_cupo_codi number;
    --v_moim_form_pago      number;
  
  begin
  
    ---insertar el movimiento de entrada (destino)  (deposito)
    pp_muestra_tipo_movi(to_number(parameter.p_codi_timo_depo_banc),
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr,
                         v_tica_codi);
  
    v_movi_codi           := fa_sec_come_movi;
    v_movi_timo_codi      := parameter.p_codi_timo_depo_banc;
    v_movi_cuen_codi      := bcab.s_cuen_codi2;
    v_movi_clpr_codi      := null;
    v_movi_sucu_codi_orig := parameter.p_sucu_codi; --:parameter.p_codi_sucu_defa;
    v_movi_mone_codi      := bcab.s_mone_codi2;
    v_movi_nume           := bcab.orpa_nume;
    v_movi_fech_emis      := bcab.movi_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_fech_oper      := bcab.movi_fech_emis;
    v_movi_user           := gen_user;
    v_movi_codi_padr      := null;
    v_movi_tasa_mone      := bcab.s_tasa_mone2;
    v_movi_tasa_mmee      := 0;
    v_movi_grav_mmnn      := 0;
    v_movi_exen_mmnn      := bcab.s_impo_mmnn2;
    v_movi_iva_mmnn       := 0;
    v_movi_grav_mmee      := 0;
    v_movi_exen_mmee      := 0;
    v_movi_iva_mmee       := 0;
    v_movi_grav_mone      := 0;
    v_movi_exen_mone      := bcab.s_impo_mone2;
    v_movi_iva_mone       := 0;
    v_movi_clpr_desc      := null;
    v_movi_empr_codi      := parameter.p_empr_codi;
    v_movi_obse           := bcab.orpa_obse;
  
    v_movi_orpa_codi := bcab.orpa_codi;
    v_movi_excl_cont := null;
    v_movi_codi_rete := null;
  
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
                        v_movi_fech_oper,
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
                        v_movi_orpa_codi,
                        v_movi_excl_cont,
                        v_movi_codi_rete);
  
    ----actualizar moco.... 
    v_moco_movi_codi := v_movi_codi;
    v_moco_nume_item := 0;
    v_moco_conc_codi := parameter.p_codi_conc_depo_mone;
    v_moco_dbcr      := 'D';
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
                             v_moco_dbcr);
  
    ----actualizar moimpu...
    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  v_movi_codi,
                                  v_movi_exen_mmnn,
                                  0,
                                  0,
                                  0,
                                  v_movi_exen_mone,
                                  0);
  
    ------
    --v_moim_movi_codi := v_movi_codi;
    --go_block('bfp');
  /*  --first_record;
    for bfp in forma_pago loop
      v_moim_nume_item      := v_moim_nume_item + 1;
      v_moim_cuen_codi      := bcab.s_cuen_codi2;
      v_moim_dbcr           := 'D';
      v_moim_tipo           := 'Efec. Deposito';
      v_moim_afec_caja      := 'S';
      v_moim_cheq_codi      := null;
      v_moim_tarj_cupo_codi := null;
      if bfp.fopa_codi in ('1') then
        v_moim_fech      := bcab.movi_fech_emis;
        v_moim_fech_oper := bcab.movi_fech_emis;
      elsif bfp.fopa_codi in ('4') then
        v_moim_fech      := bfp.cheq_fech_venc; --bcab.movi_fech_emis;--:bfp.cheq_fech_venc; A pedido de Jose Rolon..
        v_moim_fech_oper := bfp.cheq_fech_venc; --bcab.movi_fech_emis;--:bfp.cheq_fech_emis; A pedido de Jose Rolon..
      end if;
    
      if bfp.mone_codi_alte <> bcab.s_mone_codi2 then
        if bfp.mone_codi_alte = parameter.p_codi_mone_mmnn then
          v_moim_impo_mone := bfp.moim_impo_mone / bcab.s_tasa_mone2; --v_movi_exen_mone; 
        else
          v_moim_impo_mone := bfp.moim_impo_mone * bfp.moim_tasa_mone; --v_movi_exen_mone;
        end if;
      else
        v_moim_impo_mone := bfp.moim_impo_mone;
      end if;
    
      v_moim_impo_mmnn := round(bfp.s_impo_mmnn, parameter.p_cant_deci_mmnn); --v_movi_exen_mmnn;
      v_moim_form_pago := to_number(bfp.fopa_codi);
    
      pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                    v_moim_nume_item,
                                    v_moim_tipo,
                                    v_moim_cuen_codi,
                                    v_moim_dbcr,
                                    v_moim_afec_caja,
                                    v_moim_fech,
                                    v_moim_impo_mone,
                                    v_moim_impo_mmnn,
                                    v_moim_fech_oper,
                                    v_moim_cheq_codi,
                                    v_moim_tarj_cupo_codi,
                                    --v_moim_movi_codi_vale
                                    null,
                                    v_moim_form_pago);
    end loop;
  
  */
  
      
        pack_fpago.pl_fp_actualiza_moimpo(i_movi_clpr_codi      => bcab.movi_clpr_codi,
                                          i_movi_clpr_desc      => bcab.movi_clpr_desc,
                                          i_movi_clpr_ruc       => bcab.movi_clpr_ruc,
                                          i_movi_codi           => v_movi_codi,
                                          i_movi_dbcr           => 'D',--bcab.movi_dbcr,
                                          i_movi_emit_reci      => bcab.movi_emit_reci,
                                          i_movi_empr_codi      => bcab.movi_empr_codi,
                                          i_movi_fech_emis      => bcab.movi_fech_emis,
                                          i_movi_fech_oper      => bcab.movi_fech_oper,
                                          i_movi_mone_cant_deci => bcab.movi_mone_cant_deci,
                                          i_movi_sucu_codi_orig => bcab.movi_sucu_codi_orig,
                                          i_movi_tasa_mone      => bcab.movi_tasa_mone,
                                          i_movi_timo_codi      => bcab.movi_timo_codi,
                                          i_s_impo_rete         => bcab.s_impo_rete,
                                          i_s_impo_rete_rent    => bcab.s_impo_rete_rent,
                                          I_moim_tipo    => 'Efec. Deposito',
                                          I_moim_cuen_codi =>  bcab.s_cuen_codi2);
    --v_moim_nume_item := 0;
    ---insertar el movimiento de salida (origen) (extracci?n)
    pp_muestra_tipo_movi(parameter.p_codi_timo_extr_banc,
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr,
                         v_tica_codi);
  
    v_movi_codi_padr           := v_movi_codi;
    v_movi_codi                := fa_sec_come_movi;
    parameter.p_movi_codi_trva := v_movi_codi;
    v_movi_timo_codi           := to_number(parameter.p_codi_timo_extr_banc);
    v_movi_cuen_codi           := bcab.movi_cuen_codi;
    v_movi_clpr_codi           := null;
    v_movi_sucu_codi_orig      := parameter.p_sucu_codi; --:parameter.p_codi_sucu_defa;
    v_movi_mone_codi           := bcab.movi_mone_codi;
    v_movi_nume                := bcab.orpa_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := sysdate;
    v_movi_fech_oper           := bcab.movi_fech_emis;
    v_movi_user                := gen_user;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    --busca la tasa de la moneda extranjera para la fecha de la operaci?n
    --raise_Application_error(-20001,bcab.movi_mone_codi);
    pp_busca_tasa_mone(bcab.movi_mone_codi,
                       bcab.movi_fech_emis,
                       v_movi_tasa_mmee,
                       v_tica_codi);
  
    v_movi_grav_mmnn := 0;
    v_movi_exen_mmnn := bcab.s_impo_mmnn1;
    v_movi_iva_mmnn  := 0;
    v_movi_grav_mmee := 0;
    v_movi_exen_mmee := round(bcab.s_impo_mmnn1 / v_movi_tasa_mmee,
                              parameter.p_cant_deci_mmee);
    v_movi_iva_mmee  := 0;
    v_movi_grav_mone := 0;
    v_movi_exen_mone := bcab.s_impo_mone1;
    v_movi_iva_mone  := 0;
    v_movi_clpr_desc := null;
    v_movi_empr_codi := null;
    v_movi_obse      := bcab.orpa_obse;
    v_movi_orpa_codi := null;
    v_movi_codi_rete := null;
  
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
                        v_movi_fech_oper,
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
                        v_movi_orpa_codi,
                        v_movi_excl_cont,
                        v_movi_codi_rete);
  
    ----actualizar moco.... 
    v_moco_movi_codi := v_movi_codi;
    v_moco_nume_item := 0;
    v_moco_conc_codi := parameter.p_codi_conc_extr_mone;
    v_moco_dbcr      := 'C';
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
                             v_moco_dbcr);
    --actualizar moimpu.
    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  v_movi_codi,
                                  v_movi_exen_mmnn,
                                  0,
                                  0,
                                  0,
                                  v_movi_exen_mone,
                                  0);
  
    --v_moim_movi_codi := v_movi_codi;
    --  go_block('bfp');
    --  first_record;
   /* for bfp in forma_pago loop
      v_moim_nume_item := v_moim_nume_item + 1;
      v_moim_cuen_codi := bcab.movi_cuen_codi;
      v_moim_dbcr      := 'C';
      if bfp.fopa_codi in ('1') then
        v_moim_cheq_codi      := null;
        v_moim_tarj_cupo_codi := null;
        --v_moim_movi_codi_vale  := null;
        v_moim_afec_caja := 'S';
        v_moim_fech      := bcab.movi_fech_emis;
        v_moim_fech_oper := bcab.movi_fech_emis;
        v_moim_tipo      := 'Efec. Extraccion';
      elsif bfp.fopa_codi in ('4') then
        v_moim_cheq_codi      := null;
        v_moim_tarj_cupo_codi := null;
        --v_moim_movi_codi_vale  := null;
        --pp_actualiza_cheque_emit_tv(v_moim_cheq_codi);  validar despues de tener la pantalla
        v_moim_fech      := bfp.cheq_fech_venc; --bcab.movi_fech_emis;--:bfp.cheq_fech_venc; A pedido de Jose Rolon 
        v_moim_fech_oper := bfp.cheq_fech_venc; --bcab.movi_fech_emis;--:bfp.cheq_fech_emis; A pedido de Jose Rolon
        if bfp.cheq_fech_venc > bfp.cheq_fech_emis then
          --cheq. dif 
          v_moim_tipo      := 'Cheq. Dif. Emit.';
          v_moim_afec_caja := 'S';
        else
          --cheque dia
          v_moim_tipo      := 'Cheq. D?a. Emit.';
          v_moim_afec_caja := 'S';
        end if;
      end if;
    
      v_moim_impo_mone := bfp.moim_impo_mone;
      v_moim_impo_mmnn := round(bfp.s_impo_mmnn, parameter.p_cant_deci_mmnn);
      v_moim_form_pago := to_number(bfp.fopa_codi);
    
      pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                    v_moim_nume_item,
                                    v_moim_tipo,
                                    v_moim_cuen_codi,
                                    v_moim_dbcr,
                                    v_moim_afec_caja,
                                    v_moim_fech,
                                    v_moim_impo_mone,
                                    v_moim_impo_mmnn,
                                    v_moim_fech_oper,
                                    v_moim_cheq_codi,
                                    v_moim_tarj_cupo_codi,
                                    --v_moim_movi_codi_vale
                                    null,
                                    v_moim_form_pago);
    
    end loop;
    
     */ 
       pack_fpago.pl_fp_actualiza_moimpo(i_movi_clpr_codi      => bcab.movi_clpr_codi,
                                          i_movi_clpr_desc      => bcab.movi_clpr_desc,
                                          i_movi_clpr_ruc       => bcab.movi_clpr_ruc,
                                          i_movi_codi           =>v_movi_codi,
                                          i_movi_dbcr           =>  'C',--bcab.movi_dbcr,
                                          i_movi_emit_reci      => bcab.movi_emit_reci,
                                          i_movi_empr_codi      => bcab.movi_empr_codi,
                                          i_movi_fech_emis      => bcab.movi_fech_emis,
                                          i_movi_fech_oper      => bcab.movi_fech_oper,
                                          i_movi_mone_cant_deci => bcab.movi_mone_cant_deci,
                                          i_movi_sucu_codi_orig => bcab.movi_sucu_codi_orig,
                                          i_movi_tasa_mone      => bcab.movi_tasa_mone,
                                          i_movi_timo_codi      => bcab.movi_timo_codi,
                                          i_s_impo_rete         => bcab.s_impo_rete,
                                          i_s_impo_rete_rent    => bcab.s_impo_rete_rent,
                                          I_moim_tipo    => 'Efec. Extraccion',
                                          I_moim_cuen_codi =>bcab.movi_cuen_codi
                                          );
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualizar_movi_tv;

  procedure pp_actualizar_movi_ap is
  
    v_movi_codi           number;
    v_movi_timo_codi      number;
    v_movi_clpr_codi      number;
    v_movi_sucu_codi_orig number;
    v_movi_cuen_codi      number;
    v_movi_mone_codi      number;
    v_movi_nume           number;
    v_movi_fech_emis      date;
    v_movi_fech_grab      date;
    v_movi_fech_oper      date;
    v_movi_user           varchar2(20);
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
    v_movi_clpr_desc      varchar2(120);
    v_movi_emit_reci      varchar2(1);
    v_movi_afec_sald      varchar2(1);
    v_movi_dbcr           varchar2(1);
    v_movi_empr_codi      number;
    v_movi_obse           varchar2(100);
    v_tica_codi           number;
  
    --variables para moco
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      varchar2(1);
  
    --variables para moimpo 
    --v_moim_movi_codi number;
    --v_moim_nume_item number := 0;
    --v_moim_tipo      varchar2(20);
    --v_moim_cuen_codi number;
    --v_moim_dbcr      varchar2(1);
    --v_moim_afec_caja varchar2(1);
    --v_moim_fech      date;
    --v_moim_fech_oper date;
    --v_moim_impo_mone number;
    --v_moim_impo_mmnn number;
    --v_moim_cheq_codi number;
    --v_moim_form_pago number;
  
    --variables para moimpu
    v_movi_depo_codi_orig      number;
    v_movi_depo_codi_dest      number;
    v_movi_sucu_codi_dest      number;
    v_movi_oper_codi           number;
    v_movi_sald_mmnn           number;
    v_movi_sald_mmee           number;
    v_movi_sald_mone           number;
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(100);
    v_movi_clpr_tele           varchar2(50);
    v_movi_clpr_ruc            varchar2(50);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           varchar2(1);
    v_movi_nume_timb           varchar2(20);
    v_movi_fech_venc_timb      date;
    v_movi_orpa_codi           number;
    v_movi_excl_cont           varchar2(1);
    v_movi_codi_rete           number;
    --v_moim_tarj_codi           number;
    --v_moim_tarj_cupo_codi number;
  
    -- cuota
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
  
    ---insertar el movimiento de entrada (destino)  (deposito)
    pp_muestra_tipo_movi(to_number(parameter.p_codi_timo_adlr),
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr,
                         v_tica_codi);
  
    v_movi_codi                := fa_sec_come_movi;
    parameter.p_movi_codi_adpr := v_movi_codi;
    v_movi_timo_codi           := parameter.p_codi_timo_adlr;
    v_movi_cuen_codi           := bcab.movi_cuen_codi;
    v_movi_clpr_codi           := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig      := parameter.p_sucu_codi; --:parameter.p_codi_sucu_defa;
    v_movi_mone_codi           := bcab.movi_mone_codi;
    v_movi_nume                := bcab.orpa_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := sysdate;
    v_movi_fech_oper           := bcab.movi_fech_emis;
    v_movi_user                := gen_user;
    v_movi_codi_padr           := null;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := 0;
    v_movi_grav_mmnn           := 0;
    v_movi_exen_mmnn           := bcab.s_impo_mone1 *
                                  nvl(bcab.movi_tasa_mone, 1);
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := 0;
    v_movi_exen_mmee           := 0;
    v_movi_iva_mmee            := 0;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := bcab.s_impo_mone1;
    v_movi_iva_mone            := 0;
    v_movi_clpr_desc           := null;
    v_movi_empr_codi           := parameter.p_empr_codi;
    v_movi_obse                := bcab.orpa_obse;
    v_movi_sald_mmnn           := v_movi_exen_mmnn;
    v_movi_sald_mmee           := 0;
    v_movi_sald_mone           := v_movi_exen_mone;
  
    if bcab.cont_codi is not null then
      v_movi_obse := bcab.orpa_obse || ' Cont N. ' ||
                     to_char(nvl(bcab.cont_codi, ' '));
    else
      v_movi_obse := bcab.orpa_obse;
    end if;
  
    v_movi_orpa_codi := bcab.orpa_codi;
    v_movi_excl_cont := null;
    v_movi_codi_rete := null;
  
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
                        v_movi_fech_oper,
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
                        v_movi_orpa_codi,
                        v_movi_excl_cont,
                        v_movi_codi_rete);
  
    ----actualizar moco.... 
    v_moco_movi_codi := v_movi_codi;
    v_moco_nume_item := 0;
    v_moco_conc_codi := parameter.p_codi_conc_adlr;
    v_moco_dbcr      := 'D';
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
                             v_moco_dbcr);
  
    --actualizar moimpu...
    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  v_movi_codi,
                                  v_movi_exen_mone *
                                  nvl(bcab.movi_tasa_mone, 1),
                                  0,
                                  0,
                                  0,
                                  v_movi_exen_mone,
                                  0);
  
    --actualizar moimpo  
  
    --v_moim_movi_codi := v_movi_codi;
    --  go_block('bfp');
    -- first_record;
 /*   for bfp in forma_pago loop
      --  pp_asig_indi_dbcr; ----validar al tener la pantalla
      v_moim_nume_item := v_moim_nume_item + 1;
      v_moim_cuen_codi := bfp.cuen_codi_alte;
      v_moim_dbcr      := bfp.pago_cobr_indi;
      if bfp.fopa_codi in ('1') then
        v_moim_cheq_codi      := null;
        v_moim_tarj_cupo_codi := null;
        --v_moim_movi_codi_vale  := null;
        v_moim_afec_caja := 'S';
        v_moim_fech      := bcab.movi_fech_emis;
        v_moim_fech_oper := bcab.movi_fech_emis;
        v_moim_tipo      := 'Efectivo';
      elsif bfp.fopa_codi in ('2') then
        v_moim_cheq_codi      := null;
        v_moim_tarj_cupo_codi := null;
        --v_moim_movi_codi_vale  := null;
        --pp_actualiza_cheque_reci(v_moim_cheq_codi);-- validar despue de tener la pantall
        v_moim_fech      := bfp.cheq_fech_emis;
        v_moim_fech_oper := bfp.cheq_fech_emis;
        if bfp.cheq_fech_venc > bfp.cheq_fech_emis then
          --cheq. dif           
          v_moim_tipo      := 'Cheq. Dif. Rec.';
          v_moim_afec_caja := 'N';
        else
          --cheque dia
          v_moim_tipo      := 'Cheq. Dia. Rec.';
          v_moim_afec_caja := 'N';
        end if;
      elsif bfp.fopa_codi in ('3') then
        v_moim_cheq_codi      := null;
        v_moim_tarj_cupo_codi := null;
        --v_moim_movi_codi_vale  := null;     
        --pp_actualiza_tarjeta(v_moim_tarj_cupo_codi);  --  validar despue de tener la pantall  
        v_moim_fech      := bfp.tarj_fech_emis;
        v_moim_fech_oper := bfp.tarj_fech_venc;
        v_moim_tipo      := 'Tarjeta';
        v_moim_afec_caja := 'N';
      elsif bfp.fopa_codi in ('4') then
        v_moim_cheq_codi      := null;
        v_moim_tarj_cupo_codi := null;
        --v_moim_movi_codi_vale  := null;
        -- pp_actualiza_cheque_emit(v_moim_cheq_codi);--validar despue de tener la pantall
        v_moim_fech      := bfp.cheq_fech_venc;
        v_moim_fech_oper := bfp.cheq_fech_venc;
        if bfp.cheq_fech_venc > bfp.cheq_fech_emis then
          --cheq. dif 
          v_moim_tipo      := 'Cheq. Dif. Emit.';
          v_moim_afec_caja := 'S';
        else
          --cheque dia
          v_moim_tipo      := 'Cheq. D?a. Emit.';
          v_moim_afec_caja := 'S';
        end if;
      elsif bfp.fopa_codi in ('5') then
        v_moim_cheq_codi      := null;
        v_moim_tarj_cupo_codi := null;
        --v_moim_movi_codi_vale  := null;               
        v_moim_afec_caja := 'S';
        v_moim_fech      := bcab.movi_fech_emis;
        v_moim_fech_oper := bcab.movi_fech_emis;
        v_moim_tipo      := 'Vuelto';
      elsif bfp.fopa_codi in ('6') then
        v_moim_cheq_codi      := null;
        v_moim_tarj_cupo_codi := null;
        --v_moim_movi_codi_vale  := null;             
        v_moim_afec_caja := 'N';
        v_moim_fech      := bcab.movi_fech_emis;
        v_moim_fech_oper := bcab.movi_fech_emis;
        v_moim_tipo      := 'Adelanto';
        -- pp_actualiza_canc(v_moim_movi_codi);--validar despue de tener la pantall
      end if;
    
      v_moim_impo_mone := bfp.moim_impo_mone;
      v_moim_impo_mmnn := round(bfp.s_impo_mmnn, parameter.p_cant_deci_mmnn);
      v_moim_form_pago := to_number(bfp.fopa_codi);
    
      pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                    v_moim_nume_item,
                                    v_moim_tipo,
                                    v_moim_cuen_codi,
                                    v_moim_dbcr,
                                    v_moim_afec_caja,
                                    v_moim_fech,
                                    v_moim_impo_mone,
                                    v_moim_impo_mmnn,
                                    v_moim_fech_oper,
                                    v_moim_cheq_codi,
                                    v_moim_tarj_cupo_codi,
                                    --v_moim_movi_codi_vale
                                    null,
                                    v_moim_form_pago);
    end loop;
    --
   */ 
    
    
            pack_fpago.pl_fp_actualiza_moimpo(i_movi_clpr_codi      => bcab.movi_clpr_codi,
                                          i_movi_clpr_desc      => bcab.movi_clpr_desc,
                                          i_movi_clpr_ruc       => bcab.movi_clpr_ruc,
                                          i_movi_codi           =>v_movi_codi,
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
    --Generar una cuota con f. de venc igual a la fecha del documento  
    v_cuot_fech_venc := bcab.movi_fech_emis;
    v_cuot_nume      := 1;
    v_cuot_impo_mone := bcab.s_impo_mone1;
    v_cuot_impo_mmnn := round((bcab.s_impo_mone1 * bcab.movi_tasa_mone),
                              parameter.p_cant_deci_mmnn);
    v_cuot_impo_mmee := null;
    v_cuot_sald_mone := v_cuot_impo_mone;
    v_cuot_sald_mmnn := round(v_cuot_impo_mone * bcab.movi_tasa_mone,
                              parameter.p_cant_deci_mmnn);
    v_cuot_sald_mmee := null;
    v_cuot_movi_codi := v_movi_codi;
  
    pp_insert_come_movi_cuot(v_cuot_fech_venc,
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
      raise_application_error(-20001, sqlerrm);
  end pp_actualizar_movi_ap;

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
    --v_como_base            number;
  
  begin
  
    v_como_movi_codi := parameter.p_movi_codi_adpr;
    v_como_nume_item := 1;
    v_como_cont_codi := bcab.cont_codi;
  
    v_como_impo_mmnn := round((bcab.s_impo_mone1 * bcab.movi_tasa_mone),
                              parameter.p_cant_deci_mmnn);
    v_como_impo_mmee := 0;
    v_como_impo_mone := bcab.s_impo_mone1;
  
    pp_insert_movi_cont_deta(v_como_movi_codi,
                             v_como_cont_codi,
                             v_como_nume_item,
                             v_como_impo_mone,
                             v_como_impo_mmnn,
                             v_como_impo_mmee,
                             v_como_cant,
                             v_como_movi_codi_desh,
                             v_como_impo_uni);
  
  Exception
    when others then
      general_skn.pl_exhibir_error_plsql;
    
  end pp_actualiza_como;

  procedure pp_insert_movi_cont_deta(p_como_movi_codi      in number,
                                     p_como_cont_codi      in number,
                                     p_como_nume_item      in number,
                                     p_como_impo_mone      in number,
                                     p_como_impo_mmnn      in number,
                                     p_como_impo_mmee      in number,
                                     p_como_cant           in number,
                                     p_como_movi_codi_desh in number,
                                     p_como_impo_uni       in number) is
  
  begin
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
      (p_como_movi_codi,
       p_como_cont_codi,
       p_como_nume_item,
       p_como_impo_mone,
       p_como_impo_mmnn,
       p_como_impo_mmee,
       p_como_cant,
       p_como_movi_codi_desh,
       p_como_impo_uni,
       parameter.p_codi_base);
  
  end pp_insert_movi_cont_deta;

  procedure pp_actualiza_moco_vb is
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      varchar2(1);
    v_moco_tiim_codi number;
    v_moco_impo_codi number;
    v_moco_ceco_codi number;
  
    /*cursor c_conc_iva is
      select decode(bcab.movi_dbcr,
                    'C',
                    impu_conc_codi_ivcr,
                    impu_conc_codi_ivdb) conc_iva
        from come_impu
       order by 1;*/
  
    --v_conc_iva number;
  
  begin
    v_moco_movi_codi := parameter.p_movi_codi_pcor;
    v_moco_nume_item := 0;
    -- go_block('bdeta');
    --first_Record;
    for bdeta in deta loop
    
      v_moco_nume_item := v_moco_nume_item + 1;
      v_moco_conc_codi := bdeta.moco_conc_codi;
      v_moco_cuco_codi := null;
      v_moco_impu_codi := bdeta.moco_impu_codi;
      v_moco_impo_mmnn := round(bdeta.s_moco_impo * bcab.movi_tasa_mone);
      v_moco_impo_mmee := 0;
      v_moco_impo_mone := bdeta.s_moco_impo;
      v_moco_dbcr      := bdeta.moco_dbcr;
      v_moco_tiim_codi := bdeta.tiim_codi;
      v_moco_impo_codi := bdeta.moco_impo_codi;
      v_moco_ceco_codi := bdeta.cent_cost_codi;
      --raise_application_error(-20001, bdeta.tiim_codi);
      pp_insert_movi_conc_deta_vb(v_moco_movi_codi,
                                  v_moco_nume_item,
                                  v_moco_conc_codi,
                                  v_moco_cuco_codi,
                                  v_moco_impu_codi,
                                  v_moco_impo_mmnn,
                                  v_moco_impo_mmee,
                                  v_moco_impo_mone,
                                  v_moco_dbcr,
                                  v_moco_tiim_codi,
                                  v_moco_impo_codi,
                                  v_moco_ceco_codi);
    
    end loop;
  
  end pp_actualiza_moco_vb;

  procedure pp_insert_movi_conc_deta_vb(p_moco_movi_codi in number,
                                        p_moco_nume_item in number,
                                        p_moco_conc_codi in number,
                                        p_moco_cuco_codi in number,
                                        p_moco_impu_codi in number,
                                        p_moco_impo_mmnn in number,
                                        p_moco_impo_mmee in number,
                                        p_moco_impo_mone in number,
                                        p_moco_dbcr      in varchar2,
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
       parameter.p_codi_base);
  
    --- raise_application_error(-20001, p_moco_tiim_codi);
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_movi_conc_deta_vb;

  procedure pp_actualiza_come_movi_vb is
    v_movi_codi           number;
    v_movi_timo_codi      number;
    v_movi_clpr_codi      number;
    v_movi_sucu_codi_orig number;
    v_movi_cuen_codi      number;
    v_movi_mone_codi      number;
    v_movi_nume           number;
    v_movi_fech_emis      date;
    v_movi_fech_grab      date;
    v_movi_fech_oper      date;
    v_movi_user           varchar2(20);
    v_movi_codi_padr      number;
    v_movi_tasa_mone      number;
    v_movi_tasa_mmee      number;
    --v_movi_tasa_mmnn      number;
    v_movi_grav_mmnn number;
    v_movi_exen_mmnn number;
    v_movi_iva_mmnn  number;
    v_movi_grav_mmee number;
    v_movi_exen_mmee number;
    v_movi_iva_mmee  number;
    v_movi_grav_mone number;
    v_movi_exen_mone number;
    v_movi_iva_mone  number;
    v_movi_clpr_desc varchar2(120);
    v_movi_emit_reci varchar2(1);
    v_movi_afec_sald varchar2(1);
    v_movi_dbcr      varchar2(1);
    v_movi_empr_codi number;
    v_movi_obse      varchar2(100);
    v_tica_codi      number;
    --v_movi_cant_deci      number;
  
    v_movi_depo_codi_orig      number;
    v_movi_depo_codi_dest      number;
    v_movi_sucu_codi_dest      number;
    v_movi_oper_codi           number;
    v_movi_sald_mmnn           number;
    v_movi_sald_mmee           number;
    v_movi_sald_mone           number;
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(100);
    v_movi_clpr_tele           varchar2(50);
    v_movi_clpr_ruc            varchar2(50);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           varchar2(1);
    v_movi_nume_timb           varchar2(20);
    v_movi_fech_venc_timb      date;
    v_movi_orpa_codi           number;
    v_movi_excl_cont           number;
    v_movi_codi_rete           number;
  
  begin
    --insertar el movimiento de salida (extracci?n)
    pp_muestra_tipo_movi(parameter.p_codi_timo_pcor,
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr,
                         v_tica_codi);
  
    v_movi_codi_padr           := null; --v_movi_codi;
    v_movi_codi                := fa_sec_come_movi;
    bcab.movi_codi             := v_movi_codi;
    parameter.p_movi_codi_pcor := v_movi_codi;
    v_movi_timo_codi           := parameter.p_codi_timo_pcor;
    v_movi_cuen_codi           := bcab.movi_cuen_codi;
    v_movi_clpr_codi           := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig      := parameter.p_sucu_codi; --:parameter.p_codi_sucu_defa;
    v_movi_mone_codi           := bcab.movi_mone_codi;
    v_movi_nume                := bcab.orpa_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := sysdate;
    v_movi_fech_oper           := bcab.movi_fech_emis;
    v_movi_user                := gen_user;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
  
    --busca la tasa de la moneda extranjera para la fecha de la operaci?n
    pp_busca_tasa_mone(bcab.movi_mone_codi,
                       v_movi_fech_emis,
                       v_movi_tasa_mmee,
                       v_tica_codi);
    --pp_busca_tasa_mone (:parameter.p_codi_mone_mmnn, v_movi_fech_emis, v_movi_tasa_mmnn, v_tica_codi);
    --:parameter.p_movi_tasa_mmnn := v_movi_tasa_mmnn;
  
    v_movi_grav_mmnn := 0;
    v_movi_exen_mmnn := bcab.s_impo_mone1 * nvl(bcab.movi_tasa_mone, 1);
    v_movi_iva_mmnn  := 0;
    v_movi_grav_mmee := 0;
    v_movi_exen_mmee := 0;
    v_movi_iva_mmee  := 0;
    v_movi_grav_mone := 0;
    v_movi_exen_mone := bcab.s_impo_mone1;
    v_movi_iva_mone  := 0;
    v_movi_clpr_desc := null;
    v_movi_empr_codi := parameter.p_empr_codi;
    v_movi_obse      := bcab.orpa_obse;
    v_movi_orpa_codi := bcab.orpa_codi;
    v_movi_excl_cont := null;
    v_movi_codi_rete := null;
  
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
                        v_movi_fech_oper,
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
                        v_movi_orpa_codi,
                        v_movi_excl_cont,
                        v_movi_codi_rete);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualiza_come_movi_vb;

  procedure pp_actualizar_moimpu_vb is
  
    --v_total number := 0;
  
    --v_total_grav number := 0;
    --v_total_iva  number := 0;
  
    --v_total_grav_5  number := 0;
    --v_total_grav_10 number := 0;
  
    --v_total_grav_5_mmnn  number := 0;
    --v_total_grav_10_mmnn number := 0;
    --v_total_iva_5        number := 0;
    --v_total_iva_10       number := 0;
  
    --v_total_iva_5_mmnn  number := 0;
    --v_total_iva_10_mmnn number := 0;
  
    --v_total_grav_5_ii  number := 0;
    --v_total_grav_10_ii number := 0;
  
    --importes ya con el descuento incluido......
    --v_total_neto_grav_5_ii  number := 0;
    --v_total_neto_grav_10_ii number := 0;
  
    --v_total_neto_grav_ii number := 0;
  
    --v_total_neto_grav_5_ii_mmnn  number := 0;
    --v_total_neto_grav_10_ii_mmnn number := 0;
  
    --------------------------------------------
  
    --v_total_exen      number := 0;
    --v_total_exen_mmnn number := 0;
  
    cursor c_movi_conc(p_movi_codi in number) is
      select a.moco_movi_codi,
             a.moco_impu_codi,
             a.moco_tiim_codi,
             sum(a.moco_impo_mmnn) moco_impo_mmnn,
             sum(a.moco_impo_mmee) moco_impo_mmee,
             sum(a.moco_impo_mone) moco_impo_mone
      
        from come_movi_conc_deta a
       where a.moco_movi_codi = p_movi_codi
       group by a.moco_movi_codi, a.moco_impu_codi, a.moco_tiim_codi
       order by a.moco_movi_codi, a.moco_impu_codi, a.moco_tiim_codi;
  
    v_impoii_mmnn number := 0;
    v_impoii_mmee number := 0;
    v_impoii_mone number := 0;
  
    v_impo_mmnn number := 0;
    v_impu_mmnn number := 0;
  
    v_impo_mmee number := 0;
    v_impu_mmee number := 0;
  
    v_impo_mone number := 0;
    v_impu_mone number := 0;
  
  Begin
  
    for x in c_movi_conc(parameter.p_movi_codi_pcor) loop
    
      v_impoii_mmnn := x.moco_impo_mmnn;
      v_impoii_mmee := x.moco_impo_mmee;
      v_impoii_mone := x.moco_impo_mone;
    
      if x.moco_impu_codi = to_number(parameter.p_codi_impu_grav5) then
        v_impo_mmnn := round((v_impoii_mmnn / 1.05),
                             parameter.p_cant_deci_mmnn);
        v_impu_mmnn := round((v_impoii_mmnn / 21),
                             parameter.p_cant_deci_mmnn);
      
        v_impo_mmee := round((v_impoii_mmee / 1.05),
                             parameter.p_cant_deci_mmee);
        v_impu_mmee := round((v_impoii_mmee / 21),
                             parameter.p_cant_deci_mmee);
      
        v_impo_mone := round((v_impoii_mone / 1.05),
                             bcab.movi_mone_cant_deci);
        v_impu_mone := round((v_impoii_mone / 21), bcab.movi_mone_cant_deci);
      end if;
    
      if x.moco_impu_codi = to_number(parameter.p_codi_impu_grav10) then
        v_impo_mmnn := round((v_impoii_mmnn / 1.1),
                             parameter.p_cant_deci_mmnn);
        v_impu_mmnn := round((v_impoii_mmnn / 11),
                             parameter.p_cant_deci_mmnn);
      
        v_impo_mmee := round((v_impoii_mmee / 1.1),
                             parameter.p_cant_deci_mmee);
        v_impu_mmee := round((v_impoii_mmee / 11),
                             parameter.p_cant_deci_mmee);
      
        v_impo_mone := round((v_impoii_mone / 1.1),
                             bcab.movi_mone_cant_deci);
        v_impu_mone := round((v_impoii_mone / 11), bcab.movi_mone_cant_deci);
      end if;
    
      if x.moco_impu_codi = to_number(parameter.p_codi_impu_exen) then
        v_impo_mmnn := v_impoii_mmnn;
        v_impu_mmnn := 0;
      
        v_impo_mmee := v_impoii_mmee;
        v_impu_mmee := 0;
      
        v_impo_mone := v_impoii_mone;
        v_impu_mone := 0;
      end if;
    
      pp_insert_come_moimpu_deta_vb(x.moco_impu_codi,
                                    x.moco_movi_codi,
                                    v_impo_mmnn,
                                    v_impo_mmee,
                                    v_impu_mmnn,
                                    v_impu_mmee,
                                    v_impo_mone,
                                    v_impu_mone,
                                    x.moco_tiim_codi);
    
    end loop;
  
  end pp_actualizar_moimpu_vb;

  procedure pp_insert_come_moimpu_deta_vb(p_moim_impu_codi in number,
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
       parameter.p_codi_base);
  
  Exception
    when others then
      general_skn.pl_exhibir_error_plsql;
  end;


  procedure pp_validar_impo1(p_s_impo_mone1   in number,
                             p_movi_tasa_mone in number,
                             p_operacion      in varchar2,
                             p_s_impo_mmnn1   out number) is
  begin
    if p_operacion = 'TV' then
      if nvl(p_s_impo_mone1, 0) <= 0 then
        raise_application_error(-20001,
                                'Debe ingresar el importe de la transferencia');
      end if;
    
      p_s_impo_mmnn1 := round(p_s_impo_mone1 * p_movi_tasa_mone,
                              parameter.p_cant_deci_mmnn);
    end if;
  end pp_validar_impo1;

  FUNCTION fp_carga_caja_orig(p_timo_codi in number, p_movi_codi in number)
    return varchar2 IS
  
    v_desc_orig varchar2(200);
    cursor c_cuen is
      select (ed.moim_cuen_codi || '   ' || co.cuen_desc || '   ' ||
             eb.banc_desc || '   ' || 'Moneda: ' || mo.mone_desc_abre) cuen_desc
        from come_movi           e,
             come_movi           d,
             come_movi_impo_deta ed,
             come_movi_impo_deta dd,
             come_cuen_banc      co,
             come_cuen_banc      cd,
             come_mone           mo,
             come_mone           md,
             come_banc           eb,
             come_banc           db
      
       where e.movi_codi_padr = d.movi_codi
         and ed.moim_movi_codi = e.movi_codi
         and dd.moim_movi_codi = d.movi_codi
         and ed.moim_cuen_codi = co.cuen_codi
         and dd.moim_cuen_codi = cd.cuen_codi
         and e.movi_mone_codi = mo.mone_codi
         and d.movi_mone_codi = md.mone_codi
         and co.cuen_banc_codi = eb.banc_codi(+)
         and cd.cuen_banc_codi = db.banc_codi(+)
            
         and e.movi_timo_codi = 28
         and d.movi_timo_codi = 27
         and decode(p_timo_codi, 28, e.movi_codi, d.movi_codi) =
             p_movi_codi
       order by 1;
  
  begin
  
    for x in c_cuen loop
      v_desc_orig := x.cuen_Desc;
      exit;
    end loop;
  
    return v_desc_orig;
  
  exception
    when no_data_found then
      return ' ';
  end fp_carga_caja_orig;

  FUNCTION fp_carga_caja_dest(p_timo_codi in number, p_movi_codi in number)
    return varchar2 IS
  
    v_desc_dest varchar2(200);
    cursor c_cuen is
      select (dd.moim_cuen_codi || '   ' || cd.cuen_desc || '   ' ||
             db.banc_desc || '   ' || 'Moneda: ' || md.mone_desc_abre) cuen_Desc
        from come_movi           e,
             come_movi           d,
             come_movi_impo_deta ed,
             come_movi_impo_deta dd,
             come_cuen_banc      co,
             come_cuen_banc      cd,
             come_mone           mo,
             come_mone           md,
             come_banc           eb,
             come_banc           db
      
       where e.movi_codi_padr = d.movi_codi
         and ed.moim_movi_codi = e.movi_codi
         and dd.moim_movi_codi = d.movi_codi
         and ed.moim_cuen_codi = co.cuen_codi
         and dd.moim_cuen_codi = cd.cuen_codi
         and e.movi_mone_codi = mo.mone_codi
         and d.movi_mone_codi = md.mone_codi
         and co.cuen_banc_codi = eb.banc_codi(+)
         and cd.cuen_banc_codi = db.banc_codi(+)
            
         and e.movi_timo_codi = 28
         and d.movi_timo_codi = 27
         and decode(p_timo_codi, 28, e.movi_codi, d.movi_codi) =
             p_movi_codi
       order by 1;
  
  begin
  
    for x in c_cuen loop
      v_desc_dest := x.cuen_desc;
      exit;
    end loop;
  
    return v_desc_dest;
  exception
    when no_data_found then
      return ' ';
  end fp_carga_caja_dest;

  procedure pp_muestra_come_conc(p_conc_codi           in number,
                                 p_movi_dbcr           in varchar2,
                                 p_conc_desc           out varchar2,
                                 p_conc_dbcr           out varchar2,
                                 p_conc_indi_kilo_vehi out varchar2,
                                 p_moco_indi_impo      out varchar2,
                                 p_s_cuco_nume         out number,
                                 p_s_cuco_desc         out varchar2) is
    v_dbcr_desc      varchar2(7);
    v_conc_indi_ortr varchar2(1);
    v_conc_sucu_codi number;
    v_conc_indi_inac varchar2(1);
  begin
    select conc_desc,
           rtrim(ltrim(conc_dbcr)),
           conc_indi_ortr,
           conc_indi_kilo_vehi,
           conc_sucu_codi,
           nvl(conc_indi_inac, 'N'),
           nvl(conc_indi_impo, 'N')
      into p_conc_desc,
           p_conc_dbcr,
           v_conc_indi_ortr,
           p_conc_indi_kilo_vehi,
           v_conc_sucu_codi,
           v_conc_indi_inac,
           p_moco_indi_impo
      from come_conc
     where conc_codi = p_conc_codi;
  
    if rtrim(ltrim(p_conc_dbcr)) <> rtrim(ltrim(p_movi_dbcr)) then
      if p_movi_dbcr = 'D' then
        v_dbcr_desc := 'Debito';
      else
        v_dbcr_desc := 'Credito';
      end if;
      raise_application_error(-20001,
                              'Debe ingresar un Concepto de tipo ' ||
                              rtrim(ltrim(v_dbcr_desc)));
    end if;
  
    if nvl(v_conc_indi_ortr, 'N') = 'S' then
      raise_application_error(-20001,
                              'No se puede utilizar este concepto porque debe estar relacionada a una OT');
    end if;
  
    if v_conc_indi_inac = 'S' then
      raise_application_error(-20001, 'El concepto se encuentra inactivo');
    end if;
  
    begin
      select cc.cuco_nume, cc.cuco_desc
        into p_s_cuco_nume, p_s_cuco_desc
        from come_conc c, come_cuen_cont cc
       where c.conc_cuco_codi = cc.cuco_codi(+)
         and c.conc_codi = p_conc_codi;
    exception
      when no_data_found then
        p_s_cuco_nume := null;
        p_s_cuco_desc := null;
      when too_many_rows then
        p_s_cuco_nume := null;
        p_s_cuco_desc := null;
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
  Exception
    when no_data_found then
      p_conc_desc := null;
      p_conc_dbcr := null;
      raise_application_error(-20001, 'Concepto Inexistente!');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_come_conc;

  procedure pp_valida_conc_iva(p_conc_codi in number) is
    --validar que no se seleccione un concepto de Tipo Iva..                                
    Cursor c_conc_iva is
      select impu_conc_codi_ivdb, impu_conc_codi_ivcr
        from come_impu
       order by 1;
  
  begin
  
    for x in c_conc_iva loop
      if x.impu_conc_codi_ivcr = p_conc_codi or
         x.impu_conc_codi_ivdb = p_conc_codi then
        raise_application_error(-20001,
                                'No puede seleccionar un concepto de Tipo Iva');
      end if;
    end loop;
  
  end pp_valida_conc_iva;

  procedure pp_mostrar_impu(p_s_timo_calc_iva          in varchar2,
                            p_moco_impu_codi           in number,
                            p_moco_impu_desc           out varchar2,
                            p_moco_impu_porc           out varchar2,
                            p_moco_impu_porc_base_impo out varchar2) is
  begin
  
    select impu_desc, impu_porc, impu_porc_base_impo
      into p_moco_impu_desc, p_moco_impu_porc, p_moco_impu_porc_base_impo
      from come_impu
     where impu_codi = p_moco_impu_codi;
  
  Exception
    when no_data_found then
      raise_application_error(-20001, 'Tipo de Impuesto inexistente');
    When too_many_rows then
      raise_application_error(-20001, 'Tipo de Impuesto duplicado');
    when others then
      raise_application_error(-20001, 'When others...');
  end pp_mostrar_impu;

  procedure pp_validar_conc_imp(p_moco_impu_codi      in number,
                                p_s_moco_impo_ii      in number,
                                p_moco_impu_porc      in number,
                                p_movi_mone_cant_deci in number,
                                p_s_moco_impo         out number,
                                p_s_moco_iva          out number,
                                p_s_total_item        out number) is
  begin
    if p_moco_impu_codi is null then
      p_s_moco_impo := 0;
    else
      if nvl(p_s_moco_impo_ii, 0) <= 0 then
        raise_application_error(-20001,
                                'Debe ingresar el importe del concepto');
      end if;
    
      if p_s_moco_iva is null then
        if p_moco_impu_porc > 0 then
          p_s_moco_iva := round((nvl(p_s_moco_impo_ii, 0) /
                                ((100 / nvl(p_moco_impu_porc, 0)) + 1)),
                                p_movi_mone_cant_deci);
        else
          p_s_moco_iva := 0;
        end if;
      end if;
    
      p_s_moco_impo  := nvl(p_s_moco_impo_ii, 0) - nvl(p_s_moco_iva, 0);
      p_s_total_item := nvl(p_s_moco_impo, 0) + nvl(p_s_moco_iva, 0);
    
    end if;
  
  end pp_validar_conc_imp;

  procedure pp_validar_conc_iva(p_s_moco_impo_ii in number,
                                p_s_moco_iva     in out number,
                                p_moco_impu_porc in number,
                                p_s_moco_impo    out number,
                                p_s_total_item   out number) is
  begin
    if nvl(p_s_moco_iva, 0) = 0 then
      if p_moco_impu_porc = 0 then
        p_s_moco_iva := 0;
      else
        p_s_moco_iva := round(nvl(p_s_moco_impo_ii, 0) /
                              ((100 / p_moco_impu_porc) + 1));
      end if;
    end if;
    p_s_moco_impo  := nvl(p_s_moco_impo_ii, 0) - nvl(p_s_moco_iva, 0);
    p_s_total_item := nvl(p_s_moco_impo, 0) + nvl(p_s_moco_iva, 0);
  
  end pp_validar_conc_iva;

  procedure pp_validar_cent_cost(p_ceco_nume in number,
                                 p_ceco_codi out number,
                                 p_ceco_desc out varchar2) is
  begin
    select ceco_codi, ceco_desc
      into p_ceco_codi, p_ceco_desc
      from come_cent_cost
     where ceco_nume = p_ceco_nume
       and ceco_empr_codi = nvl(parameter.p_empr_codi, 0)
       and nvl(ceco_indi_impu, 'N') = 'S';
  
  exception
    when no_data_found then
      p_ceco_codi := null;
      p_ceco_desc := null;
      raise_application_error(-20001,
                              'Centro de Costo inexistente o no es imputable');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_validar_cent_cost;

  procedure pp_agregar_concepto(p_moco_conc_codi in varchar2,
                                p_moco_impu_codi in varchar2,
                                p_s_moco_impo    in varchar2,
                                p_moco_dbcr      in varchar2,
                                p_tiim_codi      in varchar2,
                                p_moco_impo_codi in varchar2,
                                p_cent_cost_codi in varchar2,
                                p_s_cuco_nume    in varchar2,
                                p_s_cuco_desc    in varchar2,
                                p_s_moco_impo_ii in varchar2,
                                p_s_moco_iva     in varchar2,
                                p_s_total_item   in varchar2) is
  begin
  
    if p_moco_conc_codi is null then
      raise_application_error(-20001,
                              'Debe ingresar el codigo del concepto');
    end if;
  
    if p_moco_impu_codi is null then
      raise_application_error(-20001,
                              'Debe ingresar el c?digo de impuesto');
    end if;
  
    if p_tiim_codi is  null then
      raise_application_error(-20001, 'Debe ingresar el tipo de impuesto');
    end if;
  
    if nvl(p_s_moco_impo_ii, 0) <= 0 then
      raise_application_error(-20001,
                              'Debe ingresar el importe del concepto');
    end if;
  
    if not
        apex_collection.collection_exists(p_collection_name => 'BCONCEPTO') then
      apex_collection.create_or_truncate_collection(p_collection_name => 'BCONCEPTO');
    end if;
  
    if (to_number(p_moco_impu_codi) = parameter.p_codi_impu_exen) and
       (p_s_moco_iva > 0) then
      raise_application_error(-20001,
                              'El importe del Iva no puede ser mayor a cero');
    end if;
  
    -- raise_application_error(-20001,length(p_moco_impu_codi));
  
    apex_collection.add_member(p_collection_name => 'BCONCEPTO',
                               p_c001            => p_moco_conc_codi,
                               p_c002            => p_moco_impu_codi,
                               p_c003            => p_s_moco_impo,
                               p_c004            => p_moco_dbcr,
                               p_c005            => p_tiim_codi,
                               p_c006            => p_moco_impo_codi,
                               p_c007            => p_cent_cost_codi,
                               p_c008            => p_s_cuco_nume,
                               p_c009            => p_s_cuco_desc,
                               p_c010            => p_s_moco_impo_ii,
                               p_c011            => p_s_moco_iva,
                               p_c012            => p_s_total_item,
                               p_c013            => v('p14_moco_conc_desc'),
                               p_c014            => v('p14_moco_impu_desc'),
                               p_c015            => v('P14_TIIM_DESC'));
  
  end pp_agregar_concepto;

  procedure pp_borrar_det(p_seq_id in number) is
  
  begin
  
    apex_collection.delete_member(p_collection_name => 'BCONCEPTO',
                                  p_seq             => p_seq_id);
    apex_collection.resequence_collection(p_collection_name => 'BCONCEPTO');
  
  end pp_borrar_det;

  procedure pp_validar_cabecera is
    --v_count number;
  begin
    if nvl(bcab.f_tot_retencion_mone, 0) >
       nvl(bcab.f_tot_deta_impo_mone, 0) then
      raise_application_error(-20001,
                              'El importe a pagar es menor al importe retenido!!!');
    end if;
  
    if parameter.p_para_inic <> 'FINI' then
      if bcab.orpa_codi is null then
      
       pp_valida_forma_pago;
      
      end if;
    end if;
  
  end pp_validar_cabecera;

  procedure pp_actu_secu is
  begin
    update come_secu
       set secu_nume_orpa = bcab.orpa_nume
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  end pp_actu_secu;

  procedure pp_set_variable is
  begin
  
    bcab.orpa_codi       := v('P14_ORPA_CODI');
    bcab.s_indi_dife     := v('P14_INDI_DIFE');
    bcab.orpa_nume       := v('P14_ORPA_NUME');
    bcab.orpa_nume_orig  := v('P14_ORPA_NUME_ORIG');
    bcab.movi_fech_emis  := v('P14_S_MOVI_FECH_EMIS');
    bcab.operacion       := v('P14_OPERACION');
    bcab.movi_tasa_mone  := v('P14_MOVI_TASA_MONE');
    bcab.orpa_rete_mone  := v('P14_ORPA_RETE_MONE');
    bcab.orpa_rete_mmnn  := v('P14_ORPA_RETE_MMNN');
    bcab.orpa_impo_mone  := v('P14_ORPA_IMPO_MONE');
    bcab.orpa_user       := gen_user;
    bcab.s_cuen_codi2    := v('P14_S_CUEN_CODI2');
    bcab.s_impo_mmnn2    := v('P14_S_IMPO_MMNN2');
    bcab.s_impo_mone2    := v('P14_S_IMPO_MONE2');
    bcab.s_tasa_mone2    := v('P14_S_TASA_MONE2');
    bcab.s_impo_mmnn1    := v('P14_S_IMPO_MMNN1');
    bcab.s_mone_codi2    := v('P14_S_MONE_CODI2');
    bcab.movi_cuen_codi  := v('P14_MOVI_CUEN_CODI');
    bcab.orpa_estado     := v('P14_ORPA_ESTADO');
    bcab.orpa_sucu_codi  := V('AI_SUCU_CODI');
    bcab.orpa_ind_planif := V('P14_ORPA_IND_PLANIF');
    bcab.movi_clpr_codi  := V('P14_ORPA_CLPR_CODI');
    bcab.movi_empr_codi  := V('AI_EMPR_CODI');
    -- bcab.movi_fech_oper             := V('P14_MOVI_FECH_OPER');
    bcab.movi_mone_codi := V('P14_MOVI_MONE_CODI');
    bcab.s_impo_mone1   := V('P14_S_IMPO_MONE1');
    bcab.orpa_obse      := V('P14_ORPA_OBSE');
    bcab.movi_exen_mone := v('P14_ORPA_IMPO_MONE');
    bcab.movi_clpr_desc := v('P14_MOVI_CLPR_DESC');
    bcab.movi_dbcr_caja := v('P14_MOVI_DBCR_CAJA');
    bcab.movi_clpr_ruc  := v('P14_MOVI_CLPR_RUC');
    parameter.p_para_inic:=v('P14_PARA_INIC');
    bcab.MOVI_MONE_CANT_DECI:=v('P14_MOVI_MONE_CANT_DECI');
  
    bcab.orpa_impo_mmnn := round((bcab.orpa_impo_mone * bcab.movi_tasa_mone),
                                 parameter.p_cant_deci_mmnn);
    --  bcab.orpa_impo_mmnn             := v('P14_ORPA_IMPO_MONE');---cambiar
    -- bcab.orpa_tasa_mmee
  
    begin
      select sum(c017) deta_impo_mone,
             (sum(c017) - nvl(v('P14_ORPA_IMPO_MONE'), 0)) diferencia,
             sum(c024) sum_impo_rete_mone
        into bcab.f_tot_deta_impo_mone,
             bcab.f_diferencia,
             bcab.f_tot_retencion_mone
        from apex_collections a
       where collection_name = 'BDETALLE'
         and c001 = 'X';
    exception
      when others then
        null;
    end;
  
    begin
      select sum(c003) s_MOCO_IMPO
        into bcab.SUM_S_MOCO_IMPO
        from apex_collections a
       where collection_name = 'BCONCEPTO';
    exception
      when others then
        null;
    end;
  
    ---raise_application_error(-20001,bcab.SUM_S_MOCO_IMPO);
  
  end pp_set_variable;

  procedure pp_actualizar_registro is
    salir  exception;
    v_cant number;
  begin
    
    pp_set_variable;
    pp_calcular_importe_cab;
    pp_validar_cabecera;
  

  
    if bcab.orpa_codi is null then
    
      --valida si ya existe numero de OP
      --carga nuevamente el ultimo numero de OP + 1
       pp_valida_importes; --ok
      if nvl(bcab.s_indi_dife, 'N') = 'N' then
      
        pp_carga_secu(bcab.orpa_nume);
        pp_veri_nume(bcab.orpa_nume);
      
        if bcab.orpa_nume_orig <> bcab.orpa_nume then
          raise_application_error(-20001,
                                  'La OP ' || bcab.orpa_nume_orig ||
                                  ' ya ha sido generada, Esta OP se guardar? con el Nro ' ||
                                  bcab.orpa_nume || '.');
        end if;
      end if;
    
     
     -- pp_valida_cheques; ---verificar una vez este la pantalla
      pp_valida_fech(bcab.movi_fech_emis); --ok
    
      if bcab.operacion = 'OP' then
        -- pago a proveedor..
        begin
          select count(*)
            into v_cant
            from come_orde_pago p
           where p.orpa_codi = bcab.orpa_codi;
        exception
          when others then
            v_cant := 0;
        end;
        if v_cant > 0 then
          raise_application_error(-20001,
                                  'La ordenes de pago no pueden ser modificadas');
        end if;
        
          if bcab.movi_clpr_codi is null then
          raise_Application_error(-20001,
                                  'El proveedor no puede ser nulo.');
        end if;
      
        if bcab.movi_mone_codi is null then
          raise_Application_error(-20001, 'La moneda no puede ser nulo.');
        end if;
      
        pp_preparar_cabecera; --ok
        --pp_preparar_detalles; ---valida en la consulta principal del detalle eliminar de la lista una vez terminada
      
        if nvl(bcab.f_tot_deta_impo_mone, 0) = 0 then
        
          raise_application_error(-20001,
                                  'El pago debe asignarse por lo menos a un documento!');
        end if;
        if nvl(bcab.f_diferencia, 0) <> 0 then
          raise_application_error(-20001,
                                  'Existe diferencia entre el importe de la orden y el detalle de cuotas a cancelar' ||
                                  bcab.f_diferencia);
        end if;
        if nvl(bcab.f_tot_deta_impo_mone, 0) <> nvl(bcab.orpa_impo_mone, 0) then
          raise_application_error(-20001,
                                  'Existen diferencias entre el importe del pago y los importes de los documentos asignados!' ||
                                  bcab.orpa_impo_mone);
        end if;
      
        pp_calcular_importe_cab; ----verificar la validacion al terminar la pantalla
        pp_actualizar_come_orde_pago; --ok
        pp_actualizar_cuotas('ORPA'); --ok
      
        begin
          select count(*)
            into v_cant
            from come_movi m
           where m.movi_timo_codi = parameter.p_codi_timo_orde_pago
             and m.movi_orpa_codi = bcab.orpa_codi;
        exception
          when others then
            raise_application_error(-20001, sqlerrm);
        end;
      
        if nvl(v_cant, 0) = 0 then
          --Movimiento Orden de Pago
          pp_actualiza_come_movi_orde; --ok
          pp_actualizar_moco_orde; --ok
          pp_actualizar_moimpu_orde; --ok
        
          -- pp_actualizar_moimpo_orde; ----falta el forma de pago
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
        
          --auto-finiquitar si o no?
          if nvl(parameter.p_auto_gene_fini_orde_pago, 'N') = 'S' then
            if nvl(bcab.f_tot_retencion_mone, 0) > 0 then
              --Movimiento Retencion
              if parameter.p_indi_rete_tesaka = 'N' then
                pp_validar_nume_rete(brete.movi_nume_rete); --ok
                pp_actualiza_come_movi_rete; --ok
                pp_actualizar_moco_rete; --ok
                pp_actualizar_moimpu_rete; --ok
                pp_actu_secu_rete; --ok
                pp_actu_orden; ---ok
                pp_actu_fact; --ok
              end if;
            end if;
          
            pp_auto_confirmar_orden_pago; --ok
          
            if parameter.p_indi_rete_tesaka = 'S' then
              pp_actualizar_rete_tesaka(bcab.orpa_codi,
                                        parameter.p_movi_codi_orde); --:parameter.p_movi_codi_rere); --ok
            end if;
          
          else
            if parameter.p_indi_rete_tesaka = 'N' then
              if upper(nvl(parameter.p_soli_impr_rete_cheq, 'S')) = 'N' and
                 nvl( /*:bdet.*/ bcab.f_tot_retencion_mone, 0) > 0 then
                if brete.movi_nume_timb_rete is null then
                  -- go_item('brete.s_nro_3_rete');
                  raise_application_error(-20001,
                                          'Debe indicar un numero de timbrado para la retencion');
                end if;
                --Movimiento Retencion
                pp_validar_nume_rete(brete.movi_nume_rete); ----ok
                pp_actualiza_come_movi_rete; --ok
                pp_actualizar_moco_rete; --ok
                pp_actualizar_moimpu_rete; --ok
                pp_actu_orden; --ok
                pp_actu_fact; ---ok
                pp_actu_secu_rete; --ok
              end if;
            else
              if nvl( /*:bdet.*/ bcab.f_tot_retencion_mone, 0) > 0 then
                pp_actualizar_rete_tesaka(bcab.orpa_codi,
                                          parameter.p_movi_codi_orde); --ok
              end if;
            end if;
          end if;
        end if;
      
        if nvl(parameter.p_auto_gene_fini_orde_pago, 'N') = 'S' then
          pp_actualizar_cuotas('FINI'); ---ok
        end if;
      
        --Generar archivo tesaka
        if nvl( /*:bdet.*/ bcab.f_tot_retencion_mone, 0) > 0 then
          if parameter.p_indi_rete_tesaka = 'S' and v('P14_CREAR_ARCHIVO_TESAKA')='S' then
            
            pp_generar_tesaka; --ok
          end if;
        end if;
      
      elsif bcab.operacion = 'TV' then
        if nvl(bcab.s_tasa_mone2, 0) <= 0 then
          raise_application_error(-20001,
                                  'La tasa debe ser mayor a cero....');
        end if;
        
      
        if nvl(bcab.s_cuen_codi2, 0) = nvl(bcab.movi_cuen_codi, 0) then
          raise_application_error(-20001,
                                  'Las cajas origen y destino, no pueden ser iguales');
        end if;
      
       -- pp_valida_cuen_tv; ---ok
      
        if nvl(bcab.s_impo_mmnn1, 0) <> nvl(bcab.s_impo_mmnn2, 0) then
          raise_application_error(-20001,
                                  'Moneda 1. ' || bcab.s_impo_mmnn1 || ' ' ||
                                  'Moneda 2. ' || bcab.s_impo_mmnn2);
          raise_application_error(-20001,
                                  'Los importes en moneda nacional de origen y destino deben ser iguales');
        end if;
      
        if nvl(bcab.s_impo_mone1, 0) <= 0 then
          raise_application_error(-20001,
                                  'Debe ingresar el importe de la transferencia');
        end if;
        pp_valida_forma_pago;
        pp_preparar_cabecera;
        pp_calcular_importe_cab;
        pp_actualizar_come_orde_pago;
      
        pp_actualizar_movi_tv;
      
      elsif bcab.operacion = 'AP' then
      
        if bcab.movi_clpr_codi is null then
          raise_Application_error(-20001,
                                  'El proveedor no puede ser nulo.');
        end if;
      
        if bcab.movi_mone_codi is null then
          raise_Application_error(-20001, 'La moneda no puede ser nulo.');
        end if;
        if (bcab.s_impo_mone1 is null or bcab.s_impo_mone1 <= 0) then
          raise_Application_error(-20001,
                                  'El importe no puede ser nulo o menor a 0.');
        end if;
        pp_valida_forma_pago;
        pp_preparar_cabecera;
        pp_calcular_importe_cab;
        pp_actualizar_come_orde_pago;
        pp_actualizar_movi_ap; ---ok
        if bcab.cont_codi is not null then
          pp_actualiza_como; ---ok
        end if;
      elsif bcab.operacion = 'VB' then
        
          if bcab.movi_clpr_codi is null then
          raise_Application_error(-20001,
                                  'El proveedor no puede ser nulo.');
        end if;
      
        if bcab.movi_mone_codi is null then
          raise_Application_error(-20001, 'La moneda no puede ser nulo.');
        end if;
        
           if (bcab.s_impo_mone1 is null or bcab.s_impo_mone1 <= 0) then
          raise_Application_error(-20001,
                                  'El importe no puede ser nulo o menor a 0.');
        end if;
       
      
        pp_calcular_importe_cab;
        pp_preparar_cabecera;
       
        pp_actualizar_come_orde_pago;
        pp_actualiza_come_movi_vb; --ok
        pp_actualiza_moco_vb; --ok
        pp_actualizar_moimpu_vb; --ok
        --pp_actualizar_moimpo_vb; ---verificar despues de trabajar por la forma de pago
      
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
      end if;
      if nvl(bcab.s_indi_dife, 'N') = 'N' then
        pp_actu_secu;
      end if;
    
      ----hacer reporte
      if bcab.operacion = 'OP' then
        pp_llamar_reporte(parameter.p_form_impr_orde_pago,
                          parameter.p_movi_codi_orde,
                          'ORDEN DE PAGO');
      
        /* if parameter.p_impr_cheq_op = 'S' then
          pp_impr_cheq;
        end if;
        if parameter.p_indi_rete_tesaka = 'N' then
          if nvl(bcab.f_tot_retencion_mone, 0) > 0 then
            pp_impr_rete;
          end if;
        else
          pp_impr_rete_tesaka(bcab.orpa_codi);
        end if;*/
      
      elsif bcab.operacion = 'AP' then
        pp_llamar_reporte(parameter.p_form_impr_adel_prov,
                          parameter.p_movi_codi_adpr,
                          'Adelanto a Proveedor');
      
      elsif bcab.operacion = 'TV' then
      
        pp_llamar_reporte(parameter.p_form_impr_op_tv,
                          parameter.P_MOVI_CODI_TRVA,
                          'TRANSFERENCIA DE VALORES');
      
      elsif bcab.operacion = 'VB' then
      
        pp_llamar_reporte(parameter.p_form_impr_bole_gast_prov,
                          parameter.p_movi_codi_pcor,
                          'Gastos Varios Boleta');
      end if;
    
    else
    
      parameter.p_movi_timo_codi := v('P14_MOVI_TIMO_CODI');
      if parameter.p_movi_timo_codi = parameter.p_codi_timo_orde_pago then
        --- pp_llama_reporte_op;
        pp_llamar_reporte(parameter.p_form_impr_orde_pago,
                          parameter.p_movi_codi_orde,
                          'ORDEN DE PAGO');
      elsif bcab.operacion = 'TV' then
        -- pp_llama_reporte_TV;
        pp_llamar_reporte(parameter.p_form_impr_op_tv,
                          parameter.P_MOVI_CODI_TRVA,
                          'TRANSFERENCIA DE VALORES');
      elsif parameter.p_movi_timo_codi = parameter.p_codi_timo_adlr then
        -- pp_llama_reporte_ap;
        pp_llamar_reporte(parameter.p_form_impr_adel_prov,
                          parameter.p_movi_codi_adpr,
                          'Adelanto a Proveedor');
      elsif parameter.p_movi_timo_codi = parameter.p_codi_timo_pcor then
      
        pp_llamar_reporte(parameter.p_form_impr_bole_gast_prov,
                          parameter.p_movi_codi_pcor,
                          'Gastos Varios Boleta');
      end if;
    
    end if;
  exception
    when salir then
      null;
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualizar_registro;

  function pp_identificar_ope(p_movi_timo_codi in number) return varchar2 is ------verifica a que tipo de operacion corresponde..
  begin
    if p_movi_timo_codi = parameter.p_codi_timo_orde_pago then
      return 'OP';
    elsif p_movi_timo_codi = parameter.p_codi_timo_adlr then
      return 'AP';
    elsif p_movi_timo_codi = parameter.p_codi_timo_pcor then
      return 'VB';
    else
      return 'TV';
    end if;
  exception
    when others then
      return null;
  end pp_identificar_ope;

  procedure pp_execute_query is
    v_clave               number := v('P14_ORPA_CODI');
    v_movi_codi           number;
    v_movi_timo_codi      number;
    V_deta_cuot_movi_codi number;
    v_deta_cuot_fech_venc date;
    v_movi_nume           number;
    v_movi_iva_mmnn       number;
    v_movi_fech_emis      date;
    v_movi_iva_mone       number;
    v_cuot_impo_mone      number;
    v_cuot_sald_mone      number;
    v_movi_grav_mone      number;
    v_movi_grav_mmnn      number;
    v_timo_desc_abre      varchar2(200);
    cursor c_cab is
      select orpa_codi,
             orpa_empr_codi,
             orpa_sucu_codi,
             orpa_fech_emis,
             orpa_cuen_codi,
             orpa_obse,
             orpa_tasa_mone,
             orpa_tasa_mmee,
             orpa_rete_mone,
             orpa_rete_mmnn,
             orpa_estado,
             orpa_ind_planif,
             orpa_rete_movi_codi,
             orpa_nume,
             orpa_clpr_codi,
             orpa_fech_grab,
             orpa_mone_codi,
             orpa_impo_mone,
             orpa_impo_mmnn,
             orpa_user,
             orpa_base,
             g.clpr_codi_alte,
             g.clpr_desc,
             f.mone_desc,
             f.mone_cant_deci
        from come_orde_pago, 
        come_clie_prov g,
        come_mone f
       where orpa_codi = v_clave
       and  f.mone_codi=orpa_mone_codi
         and g.clpr_codi(+) = orpa_clpr_codi;
  
    cursor c_det is
      select deta_orpa_codi,
             deta_item,
             nvl(deta_cuot_movi_codi, deta_cuot_pres_movi_codi) deta_cuot_movi_codi,
             deta_cuot_fech_venc,
             deta_impo_mone,
             deta_impo_mmnn,
             deta_rete_iva_mone,
             deta_rete_iva_mmnn,
             deta_rete_ren_mone,
             deta_rete_ren_mmnn,
             deta_base,
             deta_rete_movi_codi
        from come_orde_pago_deta 
       where deta_orpa_codi = v_clave
       order by deta_item;
  
   /* cursor c_form_pago(p_movi_codi in number) is
      select moim_form_pago,
             cuen_mone_codi,
             moim_cuen_codi,
             moim_impo_mone,
             moim_cheq_codi,
             moim_movi_codi
        from come_movi_impo_deta, come_cuen_banc
       where moim_movi_codi = p_movi_codi
         and moim_cuen_codi = cuen_codi(+)
         and lower(substr(moim_tipo, 1, 4)) <> 'rete';*/
  v_nume_rete varchar2(20);
  v_cuen_desc varchar2(200);
  v_banc_desc varchar2(200);
  v_mone_desc varchar2(200);
   v_movi_cuen_codi number;
                      v_movi_tasa_mone number;
                    v_movi_mone_codi number;
  begin
  
  
    begin
      select movi_codi, movi_timo_codi
        into v_movi_codi, v_movi_timo_codi
        from come_movi
       where movi_orpa_codi = v_clave
         and movi_timo_codi <> 14;
    
      parameter.p_movi_timo_codi := v_movi_timo_codi;
      parameter.p_movi_codi_orde := v_movi_codi; --Op   
      parameter.p_movi_codi_adpr := v_movi_codi; -- adelanto
      parameter.p_movi_codi_pcor := v_movi_codi; -- transferencia 
      parameter.p_movi_codi_trva := v_movi_codi; -- transferencia 
    
    exception
      when others then
        null;
    end;
  
    ----**
  
    if v_clave is not null then
      parameter.p_indi_exis_orpa := 'S'; --- se utilizara para validar o no por ejemplo repeticion de cheques y retencionen
    end if;
  


  
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
    for k in c_cab loop
      
    
    
      setitem('P14_S_MOVI_FECH_EMIS', k.orpa_fech_emis);
      setitem('P14_orpa_rete_mone', k.orpa_rete_mone);
      setitem('P14_MOVI_CUEN_CODI', k.orpa_cuen_codi);
      setitem('P14_orpa_obse', k.orpa_obse);
      setitem('P14_movi_tasa_mone', k.orpa_tasa_mone);
      setitem('P14_orpa_tasa_mmee', k.orpa_tasa_mmee);
      setitem('P14_orpa_rete_mmnn', k.orpa_rete_mmnn);
      setitem('P14_orpa_tasa_mmee', k.orpa_tasa_mmee);
      setitem('P14_orpa_tasa_mmee', k.orpa_tasa_mmee);
      setitem('P14_orpa_estado', k.orpa_estado);
      setitem('P14_orpa_ind_planif', k.orpa_ind_planif);
      setitem('P14_orpa_rete_movi_codi', k.orpa_rete_movi_codi);
      setitem('P14_orpa_nume', k.orpa_nume);
      setitem('P14_orpa_clpr_codi', k.orpa_clpr_codi);
      setitem('P14_S_CLPR_CODI_ALTE', k.clpr_codi_alte);
      setitem('P14_MOVI_CLPR_DESC', k.clpr_desc);
    
      setitem('P14_movi_fech_oper', k.orpa_fech_grab);
      setitem('P14_movi_mone_codi', k.orpa_mone_codi);
      setitem('P14_orpa_impo_mone', k.orpa_impo_mone);
      setitem('P14_s_impo_mone2', k.orpa_impo_mone);
      setitem('P14_s_impo_mone1', k.orpa_impo_mone);
      setitem('p14_orpa_impo_mmnn', k.orpa_impo_mmnn);
      setitem('p14_orpa_user', k.orpa_user);
      setitem('p14_orpa_user', k.orpa_user);
      setitem('p14_movi_timo_codi', v_movi_timo_codi);
      setitem('p14_movi_mone_cant_deci',  k.mone_cant_deci);
      setitem('P14_S_MONE_DESC',  k.mone_desc);
      
       begin
          select p.movi_cuen_codi,
                 co.cuen_desc,
                 ba.banc_desc,
                 p.movi_tasa_mone,
                 p.movi_mone_codi,
                 mo.mone_desc
                 into v_movi_cuen_codi,
                      v_cuen_desc,
                      v_banc_desc,
                      v_movi_tasa_mone,
                      v_movi_mone_codi,
                      v_mone_desc
          from come_movi p,
             come_cuen_banc      co,
             come_mone           mo,
              come_banc ba
 
         where movi_orpa_codi=v_clave
         and p.movi_cuen_codi=co.cuen_codi
         and movi_mone_codi = mo.mone_codi
         and cuen_banc_codi = banc_codi(+);
         exception when others then
           null;
         end;
           setitem('P14_S_CUEN_CODI2',  v_movi_cuen_codi);
           setitem('P14_S_MONE_CODI2',  v_movi_mone_codi);
           setitem('P14_S_TASA_MONE2', v_movi_tasa_mone);
           setitem('P14_S_CUEN_DESC2',  v_cuen_desc);
           setitem('P14_S_BANC_DESC2',  v_banc_desc);
           setitem('P14_S_MONE_DESC2', v_mone_desc);
    end loop;
    
  
  
    for k in c_det loop
    
      V_deta_cuot_movi_codi := k.deta_cuot_movi_codi;
      v_deta_cuot_fech_venc := k.deta_cuot_fech_venc;
     
    begin
     select  f.movi_nume 
     into v_nume_rete
      from come_movi f
      where f.movi_codi=k.deta_rete_movi_codi;
      exception when others then
        v_nume_rete:=null;
      end;
      --
      -- :bdet.s_retencion_mone     := k.deta_rete_iva_mone;
      --  
    
      if v_deta_cuot_movi_codi is not null then
      
        begin
          select movi_nume,
                 movi_fech_emis,
                 movi_iva_mmnn,
                 movi_iva_mone,
                 cuot_impo_mone,
                 cuot_sald_mone,
                 timo_desc_abre
            into v_movi_nume,
                 v_movi_fech_emis,
                 v_movi_iva_mmnn,
                 v_movi_iva_mone,
                 v_cuot_impo_mone,
                 v_cuot_sald_mone,
                 v_timo_desc_abre
            from come_movi, come_movi_cuot, come_tipo_movi
           where movi_codi = cuot_movi_codi
             and movi_timo_codi = timo_codi
             and cuot_movi_codi = v_deta_cuot_movi_codi
             and cuot_fech_venc = v_deta_cuot_fech_venc;
        
        exception
          when no_data_found then
            -- entonces es prestamo
            begin
              select movi_nume,
                     movi_fech_emis,
                     movi_iva_mmnn,
                     movi_iva_mone,
                     cupe_impo_mone,
                     cupe_sald_mone,
                     timo_desc_abre
                into v_movi_nume,
                     v_movi_fech_emis,
                     v_movi_iva_mmnn,
                     v_movi_iva_mone,
                     v_cuot_impo_mone,
                     v_cuot_sald_mone,
                     v_timo_desc_abre
                from come_movi, come_movi_cuot_pres, come_tipo_movi
               where movi_codi = cupe_movi_codi
                 and movi_timo_codi = timo_codi
                 and cupe_movi_codi = v_deta_cuot_movi_codi
                 and cupe_fech_venc = v_deta_cuot_fech_venc;
            
            exception
              when others then
                null;
            end;
          when others then
            null;
        end;
      end if;
    
      apex_collection.add_member(p_collection_name => 'BDETALLE',
                                 p_c001            => 'X', ---ind_marcado                            
                                 p_c002            => v_movi_nume,
                                 p_c003            => v_movi_fech_emis,
                                 p_c004            =>  k.deta_cuot_fech_venc,
                                 p_c005            => v_cuot_impo_mone,
                                 p_c006            => v_cuot_sald_mone,
                                 p_c007            => v_movi_codi,
                                 p_c008            => v_timo_desc_abre,
                                 p_c009            => v_movi_grav_mone,
                                 p_c010            => v_movi_grav_mmnn,
                                 p_c012            => v_movi_iva_mone,
                                 p_c013            => v_movi_iva_mmnn,
                                 -- p_c014            => k.movi_codi_rete,
                                 p_c015 => k.deta_orpa_codi,
                                 p_c016 => k.deta_item,
                                 p_c017 => k.deta_impo_mone,
                                 p_c018 => k.deta_impo_mmnn,
                                 p_c019 => k.deta_rete_iva_mone,
                                 p_c020 => k.deta_rete_iva_mmnn,
                                 p_c021 => k.deta_rete_ren_mone,
                                 p_c022 => k.deta_rete_ren_mmnn,
                                 p_c023 => 0,--v_cuot_impo_mone,
                                 p_c024 => k.deta_rete_iva_mone,--v_cuot_sald_mone
                                 p_c025 => v_nume_rete
                                  );
    end loop;
  
    /*  for i in c_form_pago(v_movi_codi) loop
      :bfp.cuen_codi_alte := i.moim_cuen_codi;
      :bfp.mone_codi_alte       := i.cuen_mone_codi;
      :bfp.moim_impo_mone := i.moim_impo_mone;
      :bfp.fopa_codi      := to_char(i.moim_form_pago);
      do_key('next_item');    
      --validar cheque
    if i.moim_cheq_codi is not null then
        begin
          select cheq_serie,
                 cheq_nume,
                 cheq_cuen_codi,
                 cheq_banc_codi,
                 cheq_nume_cuen,
                 cheq_impo_mone,
                 nvl(cheq_orde, cheq_titu) cheq_titu,
                 to_char(cheq_fech_emis,'dd-mm-yyyy') cheq_fech_emis,
                 to_char(cheq_fech_venc,'dd-mm-yyyy') cheq_fech_venc
            into :bfp.cheq_serie,
                 :bfp.cheq_nume,
                 :bfp.cheq_cuen_codi,
                 :bfp.cheq_banc_codi,
                 :bfp.cheq_nume_cuen,
                 :bfp.cheq_impo_mone,
                 :bfp.cheq_titu,
                 :bfp.s_cheq_fech_emis,
                 :bfp.s_cheq_fech_venc
            from come_cheq
           where cheq_codi = i.moim_cheq_codi;
        exception
          when others then
            null;
        end;   
      end if;
      next_record;
    end loop;
    if :bfp.fopa_codi is null then
      delete_record;
    end if;*/
  
    if parameter.p_movi_timo_codi = parameter.p_codi_timo_orde_pago then
      setitem('P14_OPERACION', 'OP');
    elsif parameter.p_movi_timo_codi = parameter.p_codi_timo_adlr then
      setitem('P14_OPERACION', 'AP');
    elsif parameter.p_movi_timo_codi = parameter.p_codi_timo_pcor then
      setitem('P14_OPERACION', 'VB');
    else
      setitem('P14_OPERACION', 'TV');
    end if;
  
  exception
    when no_data_found then
    
      null;
      --se esta cargando una orden de pago en diferido y se carga la secuencia para saber 
    --si se actualiza o no la secuencia al final de la transaccion.
    when others then
      raise_application_error(-20001, 'pp_execute_query ' || sqlerrm);
  end pp_execute_query;

  procedure pp_imprimir_reporte(p_operacion in varchar2,
                                p_movi_codi in number) is
  
    v_movi_codi number;
  begin
  
    begin
      select movi_codi --, movi_timo_codi
        into v_movi_codi --, v_movi_timo_codi
        from come_movi
       where movi_orpa_codi = p_movi_codi
         and movi_timo_codi <> 14;
    
      /* parameter.p_movi_timo_codi := v_movi_timo_codi;
         parameter.p_movi_codi_orde := v_movi_codi; --Op   
      -- parameter.p_movi_codi_pres := v_movi_codi; --PP
         parameter.p_movi_codi_adpr := v_movi_codi; -- adelanto
         parameter.p_movi_codi_pcor := v_movi_codi; -- transferencia 
         parameter.p_movi_codi_trva := v_movi_codi; -- transferencia */
    
    exception
      when others then
        null;
    end;
  
    if p_operacion = 'OP' then
    
      pp_llamar_reporte(parameter.p_form_impr_orde_pago,
                        v_movi_codi,
                        'ORDEN DE PAGO');
    elsif p_operacion = 'TV' then
    
      pp_llamar_reporte(parameter.p_form_impr_op_tv,
                        v_movi_codi,
                        'TRANSFERENCIA DE VALORES');
    elsif p_operacion = 'AP' then
      pp_llamar_reporte(parameter.p_form_impr_adel_prov,
                        v_movi_codi,
                        'Adelanto a Proveedor');
    elsif p_operacion = 'VB' then
    
      pp_llamar_reporte(parameter.p_form_impr_bole_gast_prov,
                        v_movi_codi,
                        'Gastos Varios Boleta');
    end if;
    
  end pp_imprimir_reporte;

  procedure pp_llamar_reporte(p_reporte   in varchar2,
                              p_movi_codi in number,
                              p_title     in varchar2) is
  
    v_parametros   clob;
    v_contenedores clob;
  begin
  
    v_contenedores := 'p_movi_codi:p_titulo';
    v_parametros   := p_movi_codi || ':' || p_title;
  
    delete from come_parametros_report where usuario = gen_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, gen_user, p_reporte, 'pdf', v_contenedores);
  
  
  end pp_llamar_reporte;
  
  
PROCEDURE pp_valida_forma_pago IS
  v_count number := 0;
BEGIN

  select count(*)
    into v_count
      from apex_collections_full
     where collection_name = 'FORMA_PAGO'
       and c049 =v('APP_ID')
       and c050 = v('APP_PAGE_ID');
       
  if nvl(v_count,0) = 0 then
    raise_application_error(-20001,'No existe Forma de pago para su cancelacion.');
  end if;
  
END pp_valida_forma_pago;

procedure pp_confirmar_orden_pago is
  salir exception;
begin
  pp_preparar_cabecera;
  pp_preparar_detalles;
  
  pp_validar_orden;

  if nvl(bcab.f_tot_deta_impo_mone,0) = 0 then
     raise_application_error(-20001,'El pago debe asignarse por lo menos a un documento!');
  end if;
  
  if nvl(bcab.f_diferencia,0) <> 0 then
     raise_application_error(-20001,'Existe diferencia entre el importe de la orden y el detalle de cuotas a cancelar');
  end if;
  
  if nvl(bcab.f_tot_deta_impo_mone,0) <> nvl(bcab.orpa_impo_mone,0) then
     raise_application_error(-20001,'Existen diferencias entre el importe del pago y los importes de los documentos asignados!');
  end if;
  
  if bcab.s_reci_nume is null or bcab.reci_fech is null then
     raise_application_error(-20001,'Debe indicar el Numero de Recibo y su Fecha de Emision!');
  end if;
  

  pp_calcular_importe_cab;
  pp_auto_generar_recibos;
  pp_actualizar_cuotas('FINI');
  
  update come_orde_pago
     set orpa_estado = 'F'
   where orpa_codi = bcab.orpa_codi;
   
 
  
  
  --- pp_llama_reporte_fini;

  
exception
  when salir then
    null;
end pp_confirmar_orden_pago;
PROCEDURE pp_validar_orden IS
  v_cant        number;
  v_cant_cheq   number;
  v_cant_firm   number;
  
BEGIN
  select count(*)
    into v_cant
    from come_orde_pago_cheq_deta c
   where nvl(c.cheq_indi_impr, 'N') = 'N'
     and c.cheq_orpa_codi = bcab.orpa_codi;
   
  if v_cant > 0 then
     raise_application_error(-20001,'No se puede finiquitar la orden. Existen cheques pendientes de impresion.');
  end if;

  select count(*)
    into v_cant_cheq
    from come_orde_pago_cheq_deta c
   where c.cheq_orpa_codi = bcab.orpa_codi;
   
  if v_cant_cheq > 0 then
    
   if nvl(parameter.p_indi_vali_auto_firm_cheq_op, 'N') = 'S'   then
    begin
      select count(*)
        into v_cant_firm
        from come_orde_pago o
       where nvl(o.orpa_esta_auto_cheq, 'N') = 'N'
         and o.orpa_codi = bcab.orpa_codi;
       
      if v_cant_firm > 0 then
         raise_application_error(-20001,'No se puede finiquitar la orden. Falta que todos los Firmantes Autorizen los Cheques.');
      end if;
    end;
  end if;
end if;

  if /*:bcab.orpa_rete_movi_codi is null and*/ bcab.orpa_rete_mone > 0 then
    begin
      select o.orpa_rete_movi_codi
        into bcab.orpa_rete_movi_codi
        from come_orde_pago o
       where o.orpa_codi = bcab.orpa_codi;
      
      if parameter.p_indi_rete_tesaka = 'N' then
        if bcab.orpa_rete_movi_codi is null then
           raise_application_error(-20001,'No se puede finiquitar la orden. La retencion esta pendiente de impresion.');
        end if;
      end if;
    end;
  end if;
END pp_validar_orden;



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
end I020089;
