
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010234" is

  -- Private type declarations
  type r_parameter is record(
     p_indi_consulta varchar2(1) := 'N',
     p_codi_base_orig number,
     p_prod_tipo_orig varchar2(1),
     p_indi_prod_pesa number:= ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_prod_pesa'))),
     p_indi_prod_unid number:= ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_prod_unid'))),
     p_indi_gene_codi_pesa varchar2(1):='N',
     coll_name1 varchar2(30):= 'COLL_BCOBA',
     p_indi_obli_list_base varchar2(1):= ltrim(rtrim((general_skn.fl_busca_parametro ('p_indi_obli_list_base')))),
     coll_name2 varchar2(30):= 'COLL_BPROV',
     p_indi_vali_nume      varchar2(1):= ltrim(rtrim((general_skn.fl_busca_parametro('p_indi_vali_nume')))),
     p_ind_validar_cab     varchar2(1):= 'S',
     p_clas2_label         varchar2(30):= ltrim(rtrim((general_skn.fl_busca_parametro ('p_clas2_label')))),
     p_impu_porc           number,
     p_impu_porc_base_impo number,
     coll_name3 varchar2(30):= 'COLL_BANAL',
     coll_name4 varchar2(30):= 'COLL_BCOMP',
     p_codi_base number := pack_repl.fa_devu_codi_base,
     p_indi_pasa_capi varchar2(1):= ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_pasa_capi'))),
     coll_name5 varchar2(30):= 'COLL_BABMC_IMAG',
     p_prod_gene_codi_comp varchar2(1):= ltrim(rtrim((general_skn.fl_busca_parametro('p_prod_gene_codi_comp'))))
     
     
  );
  parameter r_parameter;
  
  type r_babmc is record(
   prod_codi                      come_prod.prod_codi%type,--varchar(20),--come_prod%rowtype,
    prod_codi_alfa                come_prod.prod_codi_alfa%type,
    prod_clas1                    come_prod.prod_clas1%type,
    prod_clas2                    come_prod.prod_clas2%type,
    prod_clas3                    come_prod%rowtype,
    prod_desc                     come_prod.prod_desc%type,
    prod_clas4                    come_prod%rowtype,
    prod_prec                     come_prod.prod_prec%type,
    prod_maxi_porc_desc           come_prod.prod_maxi_porc_desc%type,
    prod_obse                     come_prod.prod_obse%type,
    prod_desc_exte                come_prod.prod_desc_exte%type,
    prod_exis_min                 come_prod.prod_exis_min%type,
    prod_clco_codi                come_prod.prod_clco_codi%type,
    prod_clpr_codi                come_prod.prod_clpr_codi%type,
    prod_codi_fabr                come_prod.prod_codi_fabr%type,
    prod_impu_codi                come_prod.prod_impu_codi%type,
    prod_marc_codi                come_prod.prod_marc_codi%type,
    prod_medi_codi                come_prod.prod_medi_codi%type,
    prod_indi_inac                come_prod.prod_indi_inac%type,
    prod_clre_codi                come_prod.prod_clre_codi%type,
    prod_codi_barr                come_prod.prod_codi_barr%type,
    prod_base                     come_prod.prod_base%type,
    prod_prtr_codi                come_prod.prod_prtr_codi%type,
    prod_tipo                     come_prod.prod_tipo%type,
    prod_indi_mate_prim           come_prod.prod_indi_mate_prim%type,
    prod_indi_vent                come_prod.prod_indi_vent%type,
    prod_codi_orig                come_prod.prod_codi_orig%type,
    prod_fact_conv                come_prod.prod_fact_conv%type,
    prod_indi_kitt                come_prod.prod_indi_kitt%type,
    prod_indi_inac_old            come_prod.prod_indi_inac_old%type,
    prod_prlp_codi                come_prod.prod_prlp_codi%type,
    prod_tara                     come_prod.prod_tara%type,
    prod_cas                      come_prod.prod_cas%type,
    prod_htsn                     come_prod.prod_htsn%type,
    prod_mult_rect                come_prod.prod_mult_rect%type,
    prod_indi_fact_sub_cost       come_prod.prod_indi_fact_sub_cost%type,
    prod_peso_kilo                come_prod.prod_peso_kilo%type,
    prod_cost_inic                come_prod.prod_cost_inic%type,
    prod_indi_devo_sin_soli       come_prod.prod_indi_devo_sin_soli%type,
    prod_imag_desc                come_prod.prod_imag_desc%type,
    prod_anch_pulg                come_prod.prod_anch_pulg%type,
    prod_alto_pulg                come_prod.prod_alto_pulg%type,
    prod_indi_fact_nega           come_prod.prod_indi_fact_nega%type,
    prod_medi_alte_equi           come_prod.prod_medi_alte_equi%type,
    prod_medi_codi_alte           come_prod.prod_medi_codi_alte%type,
    prod_user_regi                come_prod.prod_user_regi%type,
    prod_fech_regi                come_prod.prod_fech_regi%type,
    prod_user_modi                come_prod.prod_user_modi%type,
    prod_fech_modi                come_prod.prod_fech_modi%type,
    prod_indi_auto_fact           come_prod.prod_indi_auto_fact%type,
    prod_user_auto_fact           come_prod.prod_user_auto_fact%type,
    prod_fech_auto_fact           come_prod.prod_fech_auto_fact%type,
    prod_nume_orde                come_prod.prod_nume_orde%type,
    prod_packaging                come_prod.prod_packaging%type,
    prod_empr_codi                come_prod.prod_empr_codi%type,
    prod_colo_codi                come_prod.prod_colo_codi%type,
    prod_espe                     come_prod.prod_espe%type,
    prod_imag                     come_prod.prod_imag%type,
    prod_indi_lote                come_prod.prod_indi_lote%type,
    prod_prod_aro_codi            come_prod.prod_prod_aro_codi%type,
    prod_prod_medi_codi           come_prod.prod_prod_medi_codi%type,
    prod_prod_cara_codi           come_prod.prod_prod_cara_codi%type,
    prod_liba_codi                come_prod.prod_liba_codi%type,
    prod_etiq_codi                come_prod.prod_etiq_codi%type,
    prod_prop_ship_name           come_prod.prod_prop_ship_name%type,
    prod_peli_clas                come_prod.prod_peli_clas%type,
    prod_peli_pack_grou           come_prod.prod_peli_pack_grou%type,
    prod_peli_un                  come_prod.prod_peli_un%type,
    prod_tunn_rest                come_prod.prod_tunn_rest%type,
    prod_ems                      come_prod.prod_ems%type,
    prod_mari_poll                come_prod.prod_mari_poll%type,
    prod_chem_name                come_prod.prod_chem_name%type,
    prod_nume_ec                  come_prod.prod_nume_ec%type,
    prod_reac_regi                come_prod.prod_reac_regi%type,
    prod_haza_simb                come_prod.prod_haza_simb%type,
    prod_risk_phra                come_prod.prod_risk_phra%type,
    prod_haza_stat                come_prod.prod_haza_stat%type,
    prod_prec_stat                come_prod.prod_prec_stat%type,
    prod_porc_reca                come_prod.prod_porc_reca%type,
    prod_prgr_codi                come_prod.prod_prgr_codi%type,
    prod_bota_name                come_prod.prod_bota_name%type,
    prod_coun_orig                come_prod.prod_coun_orig%type,
    prod_cas_eine                 come_prod.prod_cas_eine%type,
    prod_eine_elin                come_prod.prod_eine_elin%type,
    prod_fda                      come_prod.prod_fda%type,
    prod_fema                     come_prod.prod_fema%type,
    prod_tari                     come_prod.prod_tari%type,
    prod_prod_base_codi           come_prod.prod_prod_base_codi%type,
    prod_indi_envi_bala           come_prod.prod_indi_envi_bala%type,
    prod_coso_codi                come_prod.prod_coso_codi%type,
    prod_indi_kitt_list_prec_comp come_prod.prod_indi_kitt_list_prec_comp%type,
    prod_indi                     come_prod.prod_indi%type,
    prod_indi_rota                come_prod.prod_indi_rota%type,
    prod_indi_fuera_linea         come_prod.prod_indi_fuera_linea%type,
    prod_pais_codi                come_prod.prod_pais_codi%type,
    prod_dise_codi                come_prod.prod_dise_codi%type,
    prod_indi_venc_lote           come_prod.prod_indi_venc_lote%type,
    prod_indi_iccid_lote_obli     come_prod.prod_indi_iccid_lote_obli%type,
    prod_indi_lote_nume_tele       come_prod.prod_indi_lote_nume_tele%type,
    --
    indi_inac_orig                varchar2(1),
    liba_codi_alte                varchar2(20),
    liba_desc                     varchar2(100),
    clpr_codi_alte                number,
    prod_prov_desc                varchar2(100),
    marc_codi_alte                varchar2(20),
    prod_marc_desc                varchar2(100),
    clas2_codi_alte               varchar2(20),
    prod_clas2_desc               varchar2(100),
    clas1_codi_alte               varchar2(20),
    prod_clas1_desc               varchar2(100),
    medi_codi_alte                varchar2(20),
    medi_desc                     varchar2(100),
    medi_desc_abre                varchar2(100),
    impu_codi_alte                varchar2(20),
    prod_impu_desc                varchar2(100),
    clco_codi_alte                varchar2(20),
    prod_clco_desc                varchar2(100),
    clre_codi_alte                varchar2(20),
    prod_clre_desc                varchar2(100),
    prod_base_codi_alte           varchar2(20),
    prod_base_desc                varchar2(100),
    coso_codi_alte                varchar2(20),
    coso_desc                     varchar2(100),
    coso_porc_impu                number,
    pais_desc                     varchar2(100)
    

  );
  babmc r_babmc;
  
  type r_bcoba_princ is record(
    coba_prod_codi number,
    coba_desc varchar2(80),
    coba_medi_codi number,
    coba_nume_item number,--come_prod_coba_deta%rowtype, 
    --ba_prod_codi come_prod_coba_deta%rowtype, 
    --coba_desc come_prod_coba_deta%rowtype, 
    coba_tipo number,--come_prod_coba_deta%rowtype, 
    coba_codi_barr varchar2(30),--come_prod_coba_deta%rowtype, 
    --coba_medi_codi come_prod_coba_deta%rowtype, 
    coba_fact_conv number,--come_prod_coba_deta%rowtype, 
    coba_user_regi come_prod_coba_deta%rowtype, 
    coba_fech_regi come_prod_coba_deta%rowtype, 
    coba_user_modi come_prod_coba_deta%rowtype, 
    coba_fech_modi come_prod_coba_deta%rowtype, 
    coba_base come_prod_coba_deta%rowtype, 
    coba_codi come_prod_coba_deta%rowtype,
    --
    medi_desc_abre varchar2(20)

    
  );
  bcoba_princ r_bcoba_princ;
  
  type r_bcoba is record(
     coba_codi_barr varchar2(30), --bd
     coba_desc varchar2(80), --bd
     coba_fact_conv number, --bd
     coba_medi_codi number, --bd
     coba_tipo number --bd
  );
  bcoba r_bcoba;
  
  --CURSOR CODIGO DE BARRAS
  cursor cur_bcoba is
    select a.seq_id,
           a.c001 coba_nume_item,
           a.c002 coba_prod_codi,
           a.c003 coba_desc,
           a.c004 coba_tipo,
           a.c005 coba_codi_barr,
           a.c006 coba_medi_codi,
           a.c007 coba_fact_conv,
           a.c008 coba_user_regi,
           a.c009 coba_fech_regi,
           a.c010 coba_user_modi,
           a.c011 coba_fech_modi,
           a.c012 medi_desc_abre,
           a.c013 coba_indi
      from apex_collections a
     where a.collection_name = 'COLL_BCOBA';
  
  --CURSOR PROVEEDORES   
  cursor cur_bprov is
    select det.seq_id nro,
         c001 prod_prov_nume_item, 
         c002 prod_prov_prod_codi, 
         c003 prod_prov_clpr_codi, 
         c004 prod_prov_user_regi, 
         c005 prod_prov_fech_regi, 
         c006 prod_prov_user_modi, 
         c007 prod_prov_fech_modi,
         c008 clpr_desc,
         c009 prod_indi
   from apex_collections det
    where det.collection_name= 'COLL_BPROV';
  
  --CURSOR ANALISIS
  cursor cur_banal is
    select det.seq_id nro,
         c001 prti_prod_codi, 
         c002 prti_tian_codi, 
         c003 prti_base, 
         c004 prti_rang_mini, 
         c005 prti_rang_maxi, 
         c006 prti_orde,
         c007 tian_desc,
         c008 prti_indi
   from apex_collections det
    where det.collection_name= 'COLL_BANAL';
  
  --CURSOR COMPONENTES
  cursor cur_bcomp is
    select det.seq_id nro,
         c001 comp_nume_item, 
         c002 comp_prod_codi, 
         c003 comp_desc, 
         c004 comp_base,
         c005 comp_indi
   from apex_collections det
    where det.collection_name= 'COLL_BCOMP';
    
  cursor cur_babmc_imag is
  select det.seq_id nro,
       c001 prim_prod_codi, 
       c002 prim_nume_item, 
       blob001 prim_imag,
       c004 prim_fech,
       c005 indi_img
 from apex_collections det
  where det.collection_name= 'COLL_BABMC_IMAG';
    

-----------------------------------------------
 procedure pp_genera_codi(p_codi_alfa out varchar2) is

  begin

    select nvl(max(to_number(PROD_CODI_ALFA)), 0) + 1 prod_codi_alfa
        into p_codi_alfa
        from come_prod
       where prod_empr_codi = babmc.prod_empr_codi
       and regexp_like(prod_codi_alfa, '^[0-9]+$');

  exception
    when others then
      raise_application_error(-20010, 'Error al generar codigo! ' || sqlerrm);
  end pp_genera_codi;

-----------------------------------------------
 procedure pp_send_values is
   
 begin
   
    setitem('P72_PROD_CODI_ALFA',babmc.prod_codi_alfa);
    setitem('P72_PROD_CODI',babmc.prod_codi);
    setitem('P72_PROD_DESC',babmc.prod_desc);
    setitem('P72_PROD_MAXI_PORC_DESC',babmc.prod_maxi_porc_desc);
    setitem('P72_PROD_OBSE',babmc.prod_obse);
    setitem('P72_PROD_DESC_EXTE',babmc.prod_desc_exte);
    setitem('P72_PROD_EXIS_MIN',babmc.prod_exis_min);
    setitem('P72_PROD_CODI_FABR',babmc.prod_codi_fabr);
    setitem('P72_PROD_INDI_INAC',babmc.prod_indi_inac);
    setitem('P72_PROD_TIPO',babmc.prod_tipo);
    setitem('P72_PROD_FACT_CONV',babmc.prod_fact_conv);
    setitem('P72_PROD_INDI_KITT',babmc.prod_indi_kitt);
    setitem('P72_PROD_CAS',babmc.prod_cas);
    setitem('P72_PROD_HTSN',babmc.prod_htsn);
    setitem('P72_PROD_INDI_FACT_SUB_COST',babmc.prod_indi_fact_sub_cost);
    setitem('P72_PROD_PESO_KILO',babmc.prod_peso_kilo);
    setitem('P72_PROD_IMAG_DESC',babmc.prod_imag_desc);
    setitem('P72_PROD_ANCH_PULG',babmc.prod_anch_pulg);
    setitem('P72_PROD_ALTO_PULG',babmc.prod_alto_pulg);
    setitem('P72_PROD_MEDI_ALTE_EQUI',babmc.prod_medi_alte_equi);
    setitem('P72_PROD_USER_REGI',babmc.prod_user_regi);
    setitem('P72_PROD_FECH_REGI',to_char(babmc.prod_fech_regi, 'dd/mm/yyyy hh24:mi:ss'));
    setitem('P72_PROD_USER_MODI',babmc.prod_user_modi);
    setitem('P72_PROD_FECH_MODI',to_char(babmc.prod_fech_modi, 'dd/mm/yyyy hh24:mi:ss'));
    setitem('P72_PROD_NUME_ORDE',babmc.prod_nume_orde);
    setitem('P72_PROD_PACKAGING',babmc.prod_packaging);
    setitem('P72_PROD_ESPE',babmc.prod_espe);
    setitem('P72_PROD_INDI_LOTE',babmc.prod_indi_lote);
    setitem('P72_PROD_PROP_SHIP_NAME',babmc.prod_prop_ship_name);
    setitem('P72_PROD_PELI_CLAS',babmc.prod_peli_clas);
    setitem('P72_PROD_PELI_PACK_GROU',babmc.prod_peli_pack_grou);
    setitem('P72_PROD_PELI_UN',babmc.prod_peli_un);
    setitem('P72_PROD_TUNN_REST',babmc.prod_tunn_rest);
    setitem('P72_PROD_EMS',babmc.prod_ems);
    setitem('P72_PROD_MARI_POLL',babmc.prod_mari_poll);
    setitem('P72_PROD_CHEM_NAME',babmc.prod_chem_name);
    setitem('P72_PROD_NUME_EC',babmc.prod_nume_ec);
    setitem('P72_PROD_REAC_REGI',babmc.prod_reac_regi);
    setitem('P72_PROD_HAZA_SIMB',babmc.prod_haza_simb);
    setitem('P72_PROD_RISK_PHRA',babmc.prod_risk_phra);
    setitem('P72_PROD_HAZA_STAT',babmc.prod_haza_stat);
    setitem('P72_PROD_PREC_STAT',babmc.prod_prec_stat);
    setitem('P72_PROD_PORC_RECA',babmc.prod_porc_reca);
    setitem('P72_PROD_INDI_ENVI_BALA',babmc.prod_indi_envi_bala);
    setitem('P72_PROD_INDI_KITT_LIST_PREC_COMP',babmc.prod_indi_kitt_list_prec_comp);
    setitem('P72_PROD_INDI_ROTA',babmc.prod_indi_rota);
    setitem('P72_PROD_INDI_FUERA_LINEA',babmc.prod_indi_fuera_linea);
    setitem('P72_INDI','U');
       
    setitem('P72_PROD_CLPR_CODI',babmc.PROD_CLPR_CODI);
    setitem('P72_PROD_CLRE_CODI',babmc.prod_clre_codi);
    setitem('P72_PROD_MARC_CODI',babmc.prod_marc_codi);
    setitem('P72_PROD_PROD_BASE_CODI',babmc.prod_prod_base_codi);
    setitem('P72_PROD_CLAS2',babmc.prod_clas2);
    setitem('P72_PROD_MEDI_CODI',babmc.prod_medi_codi);
    setitem('P72_PROD_IMPU_CODI',babmc.prod_impu_codi);
    setitem('P72_PROD_CLCO_CODI',babmc.prod_clco_codi);
    setitem('P72_PROD_INDI_VENC_LOTE',babmc.prod_indi_venc_lote);
    setitem('P72_PROD_INDI_ICCID_LOTE_OBLI',babmc.prod_indi_iccid_lote_obli);
    setitem('P72_PROD_INDI_LOTE_NUME_TELE',babmc.prod_indi_lote_nume_tele);
   
   --setitem('',);
   
 exception
    when others then
        raise_application_error(-20010,'Error al cargar datos! '|| sqlerrm );
        
 end pp_send_values;

-----------------------------------------------
 procedure pp_cargar_collection(i_sql             in varchar2,
                                v_where           in varchar2,
                                i_collection_name in varchar2) is
    v_sql varchar2(4000);
  begin

     v_sql := i_sql || v_where;
     
     if apex_collection.collection_exists(p_collection_name => i_collection_name) then
       apex_collection.delete_collection(p_collection_name => i_collection_name);
     end if;

     apex_collection.create_collection_from_query(p_collection_name => i_collection_name,
                                                  p_query           => v_sql);

  exception
    when others then
        raise_application_error(-20010,'Error al cargar la collection! '|| sqlerrm );
  end pp_cargar_collection;
  
-----------------------------------------------
  procedure pp_cargar_collection_imagen is

    cursor cur_imag is
      select prim_prod_codi, 
             prim_nume_item, 
             prim_imag, 
             to_char(prim_fech,'dd/mm/yyyy hh24:mi:ss') prim_fech
        from come_prod_imag
       where prim_prod_codi = babmc.prod_codi;
  begin
    
    if apex_collection.collection_exists(p_collection_name => parameter.coll_name5) then
       apex_collection.truncate_collection (parameter.coll_name5);
    else
      apex_collection.create_collection(parameter.coll_name5);
    end if;
    
    for x in cur_imag loop
      
      apex_collection.add_member(p_collection_name => parameter.coll_name5,
                                 p_c001 => x.prim_prod_codi, 
                                 p_c002 => x.prim_nume_item, 
                                 p_blob001 => x.prim_imag,
                                 p_c004 => x.prim_fech
                               );   

    end loop;
      
  exception
    when others then
        raise_application_error(-20010,'Error al cargar la collection de imagenes! '|| sqlerrm );
          
  end pp_cargar_collection_imagen;
  
-----------------------------------------------
 procedure pp_ejecutar_consulta is
    
    v_sql       varchar2(4000);
    v_where     varchar2(100);
    v_prod_codi number;
  begin

    select prod_codi
      into v_prod_codi
      from come_prod
     where prod_codi_alfa = babmc.prod_codi_alfa
       and prod_empr_codi = babmc.prod_empr_codi;

    parameter.p_indi_consulta := 'S';
    
   -- raise_application_error(-20010, 'v_prod_codi: '||v_prod_codi);

    select prod_codi,
           prod_codi_alfa,
           prod_clas1,
           prod_clas2,
           --prod_clas3,
           prod_desc,
           --prod_clas4,
           prod_prec,
           prod_maxi_porc_desc,
           prod_obse,
           prod_desc_exte,
           prod_exis_min,
           prod_clco_codi,
           prod_clpr_codi,
           prod_codi_fabr,
           prod_impu_codi,
           prod_marc_codi,
           prod_medi_codi,
           prod_indi_inac,
           prod_clre_codi,
           prod_codi_barr,
           prod_base,
           prod_prtr_codi,
           prod_tipo,
           prod_indi_mate_prim,
           prod_indi_vent,
           prod_codi_orig,
           prod_fact_conv,
           prod_indi_kitt,
           prod_indi_inac_old,
           prod_prlp_codi,
           prod_tara,
           prod_cas,
           prod_htsn,
           prod_mult_rect,
           prod_indi_fact_sub_cost,
           prod_peso_kilo,
           prod_cost_inic,
           prod_indi_devo_sin_soli,
           prod_imag_desc,
           prod_anch_pulg,
           prod_alto_pulg,
           prod_indi_fact_nega,
           prod_medi_alte_equi,
           prod_medi_codi_alte,
           prod_user_regi,
           prod_fech_regi,
           prod_user_modi,
           prod_fech_modi,
           prod_indi_auto_fact,
           prod_user_auto_fact,
           prod_fech_auto_fact,
           prod_nume_orde,
           prod_packaging,
           prod_empr_codi,
           prod_colo_codi,
           prod_espe,
           prod_imag,
           prod_indi_lote,
           prod_prod_aro_codi,
           prod_prod_medi_codi,
           prod_prod_cara_codi,
           prod_liba_codi,
           prod_etiq_codi,
           prod_prop_ship_name,
           prod_peli_clas,
           prod_peli_pack_grou,
           prod_peli_un,
           prod_tunn_rest,
           prod_ems,
           prod_mari_poll,
           prod_chem_name,
           prod_nume_ec,
           prod_reac_regi,
           prod_haza_simb,
           prod_risk_phra,
           prod_haza_stat,
           prod_prec_stat,
           prod_porc_reca,
           prod_prgr_codi,
           prod_bota_name,
           prod_coun_orig,
           prod_cas_eine,
           prod_eine_elin,
           prod_fda,
           prod_fema,
           prod_tari,
           prod_prod_base_codi,
           prod_indi_envi_bala,
           prod_coso_codi,
           prod_indi_kitt_list_prec_comp,
           prod_indi,
           prod_indi_rota,
           prod_indi_fuera_linea,
           prod_pais_codi,
           prod_dise_codi,
           prod_indi_venc_lote,
           prod_indi_iccid_lote_obli,
           prod_indi_lote_nume_tele
      into babmc.prod_codi,      
           babmc.prod_codi_alfa,
           babmc.prod_clas1,
           babmc.prod_clas2,
           --babmc.prod_clas3,
           babmc.prod_desc,
           --babmc.prod_clas4,
           babmc.prod_prec,
           babmc.prod_maxi_porc_desc,
           babmc.prod_obse,
           babmc.prod_desc_exte,
           babmc.prod_exis_min,
           babmc.prod_clco_codi,
           babmc.prod_clpr_codi,
           babmc.prod_codi_fabr,
           babmc.prod_impu_codi,
           babmc.prod_marc_codi,
           babmc.prod_medi_codi,
           babmc.prod_indi_inac,
           babmc.prod_clre_codi,
           babmc.prod_codi_barr,
           babmc.prod_base,
           babmc.prod_prtr_codi,
           babmc.prod_tipo,
           babmc.prod_indi_mate_prim,
           babmc.prod_indi_vent,
           babmc.prod_codi_orig,
           babmc.prod_fact_conv,
           babmc.prod_indi_kitt,
           babmc.prod_indi_inac_old,
           babmc.prod_prlp_codi,
           babmc.prod_tara,
           babmc.prod_cas,
           babmc.prod_htsn,
           babmc.prod_mult_rect,
           babmc.prod_indi_fact_sub_cost,
           babmc.prod_peso_kilo,
           babmc.prod_cost_inic,
           babmc.prod_indi_devo_sin_soli,
           babmc.prod_imag_desc,
           babmc.prod_anch_pulg,
           babmc.prod_alto_pulg,
           babmc.prod_indi_fact_nega,
           babmc.prod_medi_alte_equi,
           babmc.prod_medi_codi_alte,
           babmc.prod_user_regi,
           babmc.prod_fech_regi,
           babmc.prod_user_modi,
           babmc.prod_fech_modi,
           babmc.prod_indi_auto_fact,
           babmc.prod_user_auto_fact,
           babmc.prod_fech_auto_fact,
           babmc.prod_nume_orde,
           babmc.prod_packaging,
           babmc.prod_empr_codi,
           babmc.prod_colo_codi,
           babmc.prod_espe,
           babmc.prod_imag,
           babmc.prod_indi_lote,
           babmc.prod_prod_aro_codi,
           babmc.prod_prod_medi_codi,
           babmc.prod_prod_cara_codi,
           babmc.prod_liba_codi,
           babmc.prod_etiq_codi,
           babmc.prod_prop_ship_name,
           babmc.prod_peli_clas,
           babmc.prod_peli_pack_grou,
           babmc.prod_peli_un,
           babmc.prod_tunn_rest,
           babmc.prod_ems,
           babmc.prod_mari_poll,
           babmc.prod_chem_name,
           babmc.prod_nume_ec,
           babmc.prod_reac_regi,
           babmc.prod_haza_simb,
           babmc.prod_risk_phra,
           babmc.prod_haza_stat,
           babmc.prod_prec_stat,
           babmc.prod_porc_reca,
           babmc.prod_prgr_codi,
           babmc.prod_bota_name,
           babmc.prod_coun_orig,
           babmc.prod_cas_eine,
           babmc.prod_eine_elin,
           babmc.prod_fda,
           babmc.prod_fema,
           babmc.prod_tari,
           babmc.prod_prod_base_codi,
           babmc.prod_indi_envi_bala,
           babmc.prod_coso_codi,
           babmc.prod_indi_kitt_list_prec_comp,
           babmc.prod_indi,
           babmc.prod_indi_rota,
           babmc.prod_indi_fuera_linea,
           babmc.prod_pais_codi,
           babmc.prod_dise_codi,
           babmc.prod_indi_venc_lote,
           babmc.prod_indi_iccid_lote_obli,
           babmc.prod_indi_lote_nume_tele

      from come_prod
     where prod_codi = v_prod_codi;

    parameter.p_prod_tipo_orig := babmc.prod_tipo;
    babmc.prod_desc            := rtrim(ltrim(babmc.prod_desc));
    

    --PP_HABI_DESH_CAMP_COD_BARR;
    --pp_habi_desh_camp (:babmc.prod_indi_kitt);  

    --CARGA DATOS
    pp_send_values;
    
    --CARGA CODIGO DE BARRAS
    v_sql:='select coba_nume_item, coba_prod_codi, coba_desc, coba_tipo, coba_codi_barr, 
       coba_medi_codi, coba_fact_conv, coba_user_regi, 
       to_char(coba_fech_regi, '||chr(39)||'dd/mm/yyyy hh24:mi:ss'||chr(39)||') coba_fech_regi, 
       coba_user_modi, 
       to_char(coba_fech_modi, '||chr(39)||'dd/mm/yyyy hh24:mi:ss'||chr(39)||') coba_fech_modi,
       u.medi_desc_abre
       from come_prod_coba_deta, come_unid_medi u
       where u.medi_codi = coba_medi_codi ';
    
    v_where := ' and coba_prod_codi = '||babmc.prod_codi;
   
    pp_cargar_collection(v_sql, v_where, parameter.coll_name1);
    
    --CARGA PROVEEDORES
    v_sql:='select prod_prov_nume_item, 
       prod_prov_prod_codi, 
       prod_prov_clpr_codi, 
       prod_prov_user_regi, 
       to_char(prod_prov_fech_regi,'||chr(39)||'dd/mm/yyyy hh24:mi:ss'||chr(39)||') prod_prov_fech_regi, 
       prod_prov_user_modi, 
       to_char(prod_prov_fech_modi,'||chr(39)||'dd/mm/yyyy hh24:mi:ss'||chr(39)||') prod_prov_fech_modi,
       p.clpr_desc
     from come_prod_prov_deta, come_clie_prov p
     where prod_prov_clpr_codi = clpr_codi ';
    
    v_where := ' and prod_prov_prod_codi = '||babmc.prod_codi;
   
    pp_cargar_collection(v_sql, v_where, parameter.coll_name2);
    
    --CARGA ANALISIS
    v_sql:='select prti_prod_codi, 
       prti_tian_codi, 
       prti_base, 
       prti_rang_mini, 
       prti_rang_maxi, 
       prti_orde,
       an.tian_desc
    from come_prod_tipo_anal, come_tipo_anal an
   where an.tian_codi = PRTI_TIAN_CODI ';
    
    v_where := ' and prti_prod_codi = '||babmc.prod_codi;
   
    pp_cargar_collection(v_sql, v_where, parameter.coll_name3);
    
    --CARGA COMPONENTES
    v_sql:='select comp_nume_item, 
               comp_prod_codi, 
               comp_desc, 
               comp_base
          from come_prod_comp ';
    
    v_where := ' where comp_prod_codi = '||babmc.prod_codi;
   
    pp_cargar_collection(v_sql, v_where, parameter.coll_name4);
    
    --CARGA IMAGEN
    pp_cargar_collection_imagen;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Codigo de producto inexistente');
    when others then
      raise_application_error(-20010, 'Error al Consultar! ' || sqlerrm);
  end pp_ejecutar_consulta;

-----------------------------------------------
 procedure pp_validar_producto is
  
    v_cant number := 0;
  begin

    
    select count(*)
    into v_cant
    from come_prod p
     where prod_empr_codi = babmc.prod_empr_codi
      and p.prod_codi_alfa = babmc.prod_codi_alfa;
    
    --raise_application_error(-20010,'v_cant: ' || v_cant);
    
    if v_cant <= 0 then
      raise_application_error(-20010,'Producto inexistente!');
    end if;
    
  exception
    when others then
       raise_application_error(-20010,'Error al Validar Producto! ' || sqlerrm);
  end pp_validar_producto;
-----------------------------------------------
  PROCEDURE pp_validar_numero IS
  v_codi_alfa number := 0;
  BEGIN
      select to_number(rtrim(ltrim(babmc.prod_codi_alfa)))
          into v_codi_alfa
          from dual;
      exception
        when invalid_number then
          raise_application_error(-20010,'Para el campo "Codigo" debe ingresar solo numeros');
        when others then
          raise_application_error(-20010,'Error al validar Codigo! ' || sqlerrm);

  END pp_validar_numero;
  
-----------------------------------------------
  procedure pp_validar_codigo(i_codi_alfa in varchar2,
                              i_empr_codi   in number,
                              i_indi        in varchar2
                              ) is

  begin
    
    babmc.prod_codi_alfa:= i_codi_alfa;
    babmc.prod_empr_codi := i_empr_codi;

    --raise_application_error(-20010,'babmc.prod_codi_alfa: '||babmc.prod_codi_alfa);
    
    if babmc.prod_codi_alfa is not null and nvl(i_indi,'I') <> 'I' 
      then
      if parameter.p_indi_consulta = 'N' then
        if parameter.p_indi_vali_nume = 'S' then
          if parameter.p_prod_gene_codi_comp = 'N' then
            pp_validar_numero;
          end if;
        end if;
      end if;
      pp_validar_producto;
      pp_ejecutar_consulta;
    
    else 
      
      if parameter.p_prod_gene_codi_comp = 'S' then
        --raise_application_error(-20010, 'p_prod_gene_codi_comp :'||parameter.p_prod_gene_codi_comp);
        null;
      else
        
        pp_genera_codi(babmc.prod_codi_alfa);
        
        setitem('P72_PROD_CODI_ALFA',babmc.prod_codi_alfa);
        setitem('P72_INDI','I');
        
      end if;
      
    end if;
    
  end pp_validar_codigo;

-----------------------------------------------
  procedure pp_validar_cod_alfa(i_cod_alfa in varchar2) is
    v_cant number;
  begin
    
    if  i_cod_alfa is null then
      raise_application_error(-20010,'Error, codigo no calculado!' );
    else
      
      if parameter.p_prod_gene_codi_comp = 'N' then
        babmc.prod_codi_alfa := i_cod_alfa;
        pp_validar_numero;
      end if;
        
      select count(*)
       into v_cant
      from come_prod
       where ltrim(rtrim(upper(prod_codi_alfa))) = ltrim(rtrim(upper(i_cod_alfa)));
       
      if  v_cant >=1 then
        raise_application_error(-20010,'Ya existe un producto con este mismo codigo!' );
      end if;
    end if;
      
  end pp_validar_cod_alfa;

-----------------------------------------------
  procedure pp_validar_cod_alfa_ins(i_cod_alfa in varchar2) is
    v_cant number;
  begin
    
    if  i_cod_alfa is null then
      raise_application_error(-20010,'Error, codigo no calculado!' );
    else
      
      if parameter.p_prod_gene_codi_comp = 'N' then
        babmc.prod_codi_alfa := i_cod_alfa;
        pp_validar_numero;
      end if;
        
      select count(*)
       into v_cant
      from come_prod
       where ltrim(rtrim(upper(prod_codi_alfa))) = ltrim(rtrim(upper(i_cod_alfa)));
       
      if  v_cant >=1 then
        if parameter.p_prod_gene_codi_comp = 'N' then
          pp_genera_codi(babmc.prod_codi_alfa);
        else
          raise_application_error(-20010,'Ya existe un producto con este mismo codigo!' );
        end if;
      end if;
    end if;
      
  end pp_validar_cod_alfa_ins;
-----------------------------------------------
  procedure pp_validar_descrip(i_prod_desc in varchar2) is
    
  begin
    
    babmc.prod_desc:=i_prod_desc;
    
    if nvl(parameter.p_ind_validar_cab, 'S') = 'S' then
      if  babmc.prod_desc is null then
        raise_application_error(-20010,'Debe ingresar la Descripcion del producto!' );
      else
        babmc.prod_desc := rtrim(ltrim(babmc.prod_desc));
      end if;
    end if;
    
  end pp_validar_descrip;
  
-----------------------------------------------
  procedure pp_validar_clie_prov_prod(p_busc_dato           in varchar2,
                                      p_clpr_indi_clie_prov in varchar2) is
    salir  exception;
    v_cant number;
  begin
    select count(*)
      into v_cant
      from come_clie_prov cp
     where cp.clpr_indi_clie_prov = p_clpr_indi_clie_prov
       and cp.clpr_codi = p_busc_dato;

    if v_cant >= 1 then
      raise salir;
    end if;

    if p_clpr_indi_clie_prov = 'C' then
      raise_application_error(-20010, 'Cliente inexistente');
    else
      raise_application_error(-20010, 'Proveedor inexistente');
    end if;

  exception
    when salir then
      null;
    when others then
      raise_application_error(-20010,'Error al validar Proveedor!' || sqlerrm);
  end pp_validar_clie_prov_prod;

-----------------------------------------------
  procedure pp_veri_codi_prov(p_busc_dato in number) is
    salir  exception;
    v_cant number := 0;
  begin
    select count(*)
      into v_cant
      from come_prod_prov_deta d
     where d.prod_prov_clpr_codi = p_busc_dato
       and d.prod_prov_prod_codi = babmc.prod_codi;

    if v_cant > 0 then
      raise_application_error(-20010,'El Proveedor ' || babmc.prod_prov_desc ||' ya esta asignado a este producto.');
    end if;

  exception
    when others then
      raise_application_error(-20010,'Error al verificar codigo del proveedor!' ||sqlerrm);
  end pp_veri_codi_prov;

-----------------------------------------------
  procedure pp_validar_prov(i_prod_clpr_codi in number) is
    
  begin
    
    babmc.prod_clpr_codi := i_prod_clpr_codi;
    
    
    if babmc.prod_clpr_codi is not null then
       pp_validar_clie_prov_prod(babmc.prod_clpr_codi, 'P');
       --verificar
       --pp_veri_codi_prov(babmc.prod_clpr_codi);
    else
      null;
    end if;
    
  end pp_validar_prov;
    
-----------------------------------------------
  procedure pp_validar_prov_prov (i_prod_clpr_codi in number,
                                  o_prod_prov_desc out varchar2) is
    
  begin
    
    pp_validar_prov(i_prod_clpr_codi);
    
    select cp.clpr_desc
      into o_prod_prov_desc
      from come_clie_prov cp
     where cp.clpr_indi_clie_prov = 'P'
       and cp.clpr_codi = i_prod_clpr_codi;
    
  end pp_validar_prov_prov;
-----------------------------------------------
  procedure pp_muestra_come_marc(p_marc_codi in varchar2,
                                 p_marc_empr_codi in number) is
  v_cant number;
  
  begin
    select count(*)
      into v_cant
      from come_marc m
     where m.marc_codi = p_marc_codi
       and m.marc_empr_codi = p_marc_empr_codi;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Marca inexistente!.');
    when others then
      raise_application_error(-20010, 'Error al buscar Marca!' || sqlerrm);
  end pp_muestra_come_marc;

-----------------------------------------------
  procedure pp_validar_marca(i_prod_marc_codi in number,
                             i_prod_empr_codi in number) is

  begin
    
    babmc.prod_marc_codi := i_prod_marc_codi;
    babmc.prod_empr_codi := i_prod_empr_codi;
    
    if nvl(parameter.p_ind_validar_cab, 'S') = 'S' then
      
      if babmc.prod_marc_codi is null then
        raise_application_error(-20010,'Debe ingresar la marca del producto!');
      end if;

      pp_muestra_come_marc(babmc.prod_marc_codi,
                           babmc.prod_empr_codi);
    end if;
    

  end pp_validar_marca;

-----------------------------------------------
  procedure pp_muestra_come_prod_clas2(p_clas2_codi in varchar2,
                                       p_clas2_empr_codi in number,
                                       p_clas2_desc      out varchar2,
                                       p_clas1_codi_alte out varchar2,
                                       p_clas1_codi      out number,
                                       p_clas1_desc      out varchar2
                                       ) is

  begin
    select 
           c2.clas2_desc,
           c1.clas1_codi_alte,
           c1.clas1_codi,
           c1.clas1_codi_alte ||' - '||c1.clas1_desc clas1_desc
      into 
           p_clas2_desc,
           p_clas1_codi_alte,
           p_clas1_codi,
           p_clas1_desc
      from come_prod_clas_1 c1, come_prod_clas_2 c2
     where c2.clas1_codi = c1.clas1_codi
       and c2.clas2_codi = p_clas2_codi
       and c2.clas2_empr_codi = p_clas2_empr_codi;

  exception
    when no_data_found then
      p_clas2_desc      := null;
      p_clas1_codi_alte := null;
      p_clas1_codi      := null;
      p_clas1_desc      := null;
      raise_application_error(-20010, 'Sub Familia inexistente!.');
    when others then
      raise_application_error(-20010,'Error al buscar Sub Familia!' || sqlerrm);
  end pp_muestra_come_prod_clas2;
  
-----------------------------------------------
  procedure pp_valida_sub_familia(i_prod_clas2 in number,
                                  i_prod_empr_codi  in number,
                                  p_clas1_codi      out number,
                                  p_clas1_desc      out varchar2) is
    
                                       
  begin
    
    babmc.prod_clas2:= i_prod_clas2;
    babmc.prod_empr_codi := i_prod_empr_codi;
    
    if nvl(parameter.p_ind_validar_cab, 'S') = 'S' then
     
     if babmc.prod_clas2 is not null then

        pp_muestra_come_prod_clas2(babmc.prod_clas2,
                                   babmc.prod_empr_codi,
                                   babmc.prod_clas2_desc,
                                   babmc.clas1_codi_alte,
                                   babmc.prod_clas1,
                                   babmc.prod_clas1_desc);
                                   
        p_clas1_codi := babmc.prod_clas1;
        p_clas1_desc := babmc.prod_clas1_desc;
                                  
      else
        raise_application_error(-20010,'Debe ingresar el codigo de '||parameter.p_clas2_label);
      end if;
      
      
          
      null;
      --pp_veri_abre_clas1;
    end if;
    
  end pp_valida_sub_familia;
  
-----------------------------------------------
  procedure pp_muestra_come_unid_medi(p_medi_codi in varchar2,
                                      p_medi_empr_codi in number,
                                      p_medi_desc_abre out varchar2) is
  begin
    select  m.medi_desc_abre
      into  p_medi_desc_abre
      from come_unid_medi m
     where m.medi_codi = p_medi_codi
       and m.medi_empr_codi = p_medi_empr_codi;

  exception
    when no_data_found then
      p_medi_desc_abre := null;
      raise_application_error(-20010, 'Unidad de medida inexistente!.');
    when others then
      raise_application_error(-20010,'Error al validar la Unidad de medida!' ||sqlerrm);
  end pp_muestra_come_unid_medi;

-----------------------------------------------
  procedure pp_validar_unid_medida(i_prod_medi_codi in number,
                                   i_medi_empr_codi in number,
                                   o_medi_desc_abre   out varchar2) is
    
  begin
    
    babmc.prod_medi_codi  := i_prod_medi_codi;
    babmc.prod_empr_codi := i_medi_empr_codi;
    
    if nvl(parameter.p_ind_validar_cab, 'S') = 'S' then
      if babmc.prod_medi_codi is not null then 
        pp_muestra_come_unid_medi(babmc.prod_medi_codi,
                                  babmc.prod_empr_codi,
                                  babmc.medi_desc_abre);
      else
        babmc.medi_Desc      := null;
        babmc.medi_desc_abre := null;
        babmc.prod_medi_codi := null;
        
        raise_application_error(-20010,'Debe ingresar el Codigo de Unidad de Medida');
      end if;
      
      o_medi_desc_abre   := babmc.medi_desc_abre;
      
    end if;
    
  end pp_validar_unid_medida;
  
-----------------------------------------------
  procedure pp_muestra_come_impu(p_impu_codi      in varchar2,
                                 p_impu_empr_codi      in number,
                                 p_impu_porc           out number,
                                 p_impu_porc_base_impo out number) is
  begin
    select i.impu_porc, i.impu_porc_base_impo
      into p_impu_porc, p_impu_porc_base_impo
      from come_impu i
     where i.impu_codi = p_impu_codi
       and i.impu_empr_codi = p_impu_empr_codi;

  exception
    when no_data_found then
      p_impu_porc           := null;
      p_impu_porc_base_impo := null;
      raise_application_error(-20010, 'Impuesto inexistente!.');
    when others then
      raise_application_error(-20010,'Error al validar Impuesto!' || sqlerrm);
  end pp_muestra_come_impu;
  
-----------------------------------------------
  procedure pp_validar_impuesto(i_prod_impu_codi in number,
                                i_medi_empr_codi in number) is
    
  begin
    
    babmc.prod_impu_codi := i_prod_impu_codi;
    babmc.prod_empr_codi := i_medi_empr_codi;
    
    if nvl(parameter.p_ind_validar_cab, 'S') = 'S' then
      if babmc.prod_impu_codi is not null then
        pp_muestra_come_impu(babmc.prod_impu_codi,
                             babmc.prod_empr_codi,
                             parameter.p_impu_porc,
                             parameter.p_impu_porc_base_impo);
      else
        raise_application_error(-20010,'Debe ingresar el Codigo de Impuesto');
      end if;
      
      
    end if;
    
  end pp_validar_impuesto;
  
-----------------------------------------------
  procedure pp_muestra_clas_prod_conc(p_clco_codi in varchar2,
                                      p_clco_empr_codi in number) is
  v_cant number;
  begin
    select COUNT(*)
      into v_cant
      from come_prod_clas_conc c
     where c.clco_codi = p_clco_codi
       and c.clco_empr_codi = p_clco_empr_codi;
       
    if v_cant <= 0 then
      raise_application_error(-20010,'Clasificacion de concepto inexistente!.');
    end if;

  exception
    when no_data_found then
      raise_application_error(-20010,'Clasificacion de concepto inexistente!.');
    when others then
      raise_application_error(-20010,'Error al buscar Clasificacion de concepto!' ||sqlerrm);
  end pp_muestra_clas_prod_conc;

-----------------------------------------------
  procedure pp_validar_concepto(i_prod_clco_codi in number,
                                i_medi_empr_codi in number) is
    
  begin
    
    babmc.prod_clco_codi := i_prod_clco_codi;
    babmc.prod_empr_codi := i_medi_empr_codi;
    
    if nvl(parameter.p_ind_validar_cab, 'S') = 'S' then
      
      if babmc.prod_clco_codi is null then
        raise_application_error(-20010,'Debe ingresar la Clasif. de producto por Concepto!' );
      else
        pp_muestra_clas_prod_conc(babmc.prod_clco_codi,
                                  babmc.prod_empr_codi);
      end if;

    end if;

  end pp_validar_concepto;
  
-----------------------------------------------
  procedure pp_muestra_prod_clas_resp(p_clre_codi in number,
                                      p_clre_empr_codi in number) is
  v_cant number;
  begin
    select count(*)
      into v_cant
      from come_prod_clas_resp r
     where r.clre_codi = p_clre_codi
       and r.clre_empr_codi = p_clre_empr_codi;
     if v_cant <= 0 then
      raise_application_error(-20010, 'Clasificacion respaldo inexistente!.'); 
     end if;
     
  exception
    when no_data_found then
     raise_application_error(-20010, 'Clasificacion respaldo inexistente!.');  
    when others then
      raise_application_error(-20010,'Error al validar Clasificacion respaldo!' ||sqlerrm);
  end pp_muestra_prod_clas_resp;

-----------------------------------------------
  procedure pp_validar_respaldo(i_clre_codi in number,
                                i_prod_empr_codi in number) is
    
  begin
    
    babmc.prod_clre_codi := i_clre_codi;
    babmc.prod_empr_codi := i_prod_empr_codi;
                                  
    if nvl(parameter.p_ind_validar_cab, 'S') = 'S' then
      if babmc.prod_clre_codi is not null then
        
        pp_muestra_prod_clas_resp(babmc.prod_clre_codi,
                                  babmc.prod_empr_codi);
      end if; 
      
    end if;

  end pp_validar_respaldo;
  
-----------------------------------------------
  procedure pp_validar_tipo(i_prod_tipo in varchar2) is
    
  begin
    babmc.prod_tipo := i_prod_tipo;
    
    if babmc.prod_prod_base_codi is not null then
      if babmc.prod_tipo is null or babmc.prod_tipo not in ('P', 'U') then
      raise_application_error(-20010,'Se asigno una Seccion de Balanza, codigo generado!! Debe cancelar la operacion !');
      end if;
        
    else
        if parameter.p_indi_gene_codi_pesa = 'S' then
            raise_application_error(-20010,'Se genero un codigo de Balanza!! Debe cancelar la operacion!');
        end if;
          
    end if;
    
    if babmc.prod_tipo in ('P', 'U') then
       if parameter.p_indi_consulta = 'S' then
        babmc.prod_tipo := parameter.p_prod_tipo_orig;
        raise_application_error(-20010,'No se puede editar la seccion de balanza de un producto existente '); 
       end if;
    end if;

    if parameter.p_indi_consulta = 'S' then
        if babmc.prod_base_codi_alte is not null then
            babmc.prod_tipo := parameter.p_prod_tipo_orig;
            raise_application_error(-20010,'No se puede editar la seccion de balanza de un producto existente '); 
        end if;
    end if;

    /*
    pp_habi_desh_camp_cod_barr;

     if :babmc.prod_tipo in ('P', 'U') then 
        if get_item_property('babmc.prod_base_codi_alte', enabled) = 'FALSE' then
          set_item_property('babmc.prod_base_codi_alte', enabled, property_true);
          set_item_property('babmc.prod_base_codi_alte', navigable, property_true);
          set_item_property('babmc.prod_base_codi_alte', updateable, property_true);
        end if;
     else
          
        if get_item_property('babmc.prod_base_codi_alte', enabled) = 'TRUE' then
          set_item_property('babmc.prod_base_codi_alte', enabled, property_false);
        end if;

     end if;
    */ 

  end pp_validar_tipo;

-----------------------------------------------
  procedure pp_gene_codi_barr_pesa_unid_1 is
    v_rang_desd number;
    v_rang_hast number;
    v_codi_barr number;
    v_indi      varchar2(1) := 'N';
  begin
    begin
      select prod_base_rang_desd, prod_base_rang_hast
        into v_rang_desd, v_rang_hast
        from come_prod_bala_secc
       where prod_base_codi = babmc.prod_prod_base_codi;
    exception
      when no_data_found then
        v_rang_desd := 1;
        v_rang_hast := 9999;
      when too_many_rows then
        raise_application_error(-20010,
                                'Codigo de seccion de balanza duplicado');
    end;

    begin
      select substr(min(cb.coba_codi_barr), 3, length(min(cb.coba_codi_barr)))
        into v_codi_barr
        from come_prod_coba_deta cb, come_prod p
       where cb.coba_tipo in (7, 9)
         and cb.coba_prod_codi = p.prod_codi
         and substr(cb.coba_codi_barr, 3, length(cb.coba_codi_barr)) between
             v_rang_desd and v_rang_hast;
    exception
      when no_data_found then
        v_codi_barr := v_rang_desd;
        v_indi      := 'S';
      when too_many_rows then
        raise_application_error(-20010,
                                'Rango de seccion de balanza duplicado');
    end;

    while v_indi = 'N' loop
      begin
        select substr(cb.coba_codi_barr, 3, length(cb.coba_codi_barr)) + 1
          into v_codi_barr
          from come_prod_coba_deta cb, come_prod p
         where cb.coba_tipo in (7, 9)
           and cb.coba_prod_codi = p.prod_codi
           and substr(cb.coba_codi_barr, 3, length(cb.coba_codi_barr)) =
               v_codi_barr;
      exception
        when no_data_found then
          v_indi := 'S';
        when too_many_rows then
          v_codi_barr := v_codi_barr + 1;
      end;
    
      if v_codi_barr > v_rang_hast then
        babmc.prod_prod_base_codi := parameter.p_codi_base_orig;
        raise_application_error(-20010,
                                'La numeracion para la Seccion de Balanza seleccionado ha superado en rango asignado, desde: ' ||
                                v_rang_desd || ', hasta: ' || v_rang_hast ||
                                ', favor verifique!');
      end if;
    end loop;

    if parameter.p_prod_tipo_orig in ('P', 'U') or
       bcoba_princ.coba_tipo in (7, 9) then
      if babmc.prod_tipo = 'P' then
        bcoba_princ.coba_tipo := 7;
        if v_codi_barr <> lpad(substr(bcoba_princ.coba_codi_barr,
                                      3,
                                      length(bcoba_princ.coba_codi_barr)),
                               4,
                               0) then
          bcoba_princ.coba_codi_barr := parameter.p_indi_prod_pesa ||
                                        lpad(v_codi_barr, 4, 0);
        else
          bcoba_princ.coba_codi_barr := parameter.p_indi_prod_pesa ||
                                        lpad(substr(bcoba_princ.coba_codi_barr,
                                                    3,
                                                    length(bcoba_princ.coba_codi_barr)),
                                             4,
                                             0);
        end if;
      
      else
        bcoba_princ.coba_tipo := 9;
        if v_codi_barr <> lpad(substr(bcoba_princ.coba_codi_barr,
                                      3,
                                      length(bcoba_princ.coba_codi_barr)),
                               4,
                               0) then
          bcoba_princ.coba_codi_barr := parameter.p_indi_prod_unid ||
                                        lpad(v_codi_barr, 4, 0);
        else
          bcoba_princ.coba_codi_barr := parameter.p_indi_prod_unid ||
                                        lpad(substr(bcoba_princ.coba_codi_barr,
                                                    3,
                                                    length(bcoba_princ.coba_codi_barr)),
                                             4,
                                             0);
        end if;
      end if;
    else
      if babmc.prod_tipo = 'P' then
        bcoba_princ.coba_tipo      := 7;
        bcoba_princ.coba_codi_barr := parameter.p_indi_prod_pesa ||
                                      lpad(v_codi_barr, 4, 0);
      else
        bcoba_princ.coba_tipo      := 9;
        bcoba_princ.coba_codi_barr := parameter.p_indi_prod_unid ||
                                      lpad(v_codi_barr, 4, 0);
      end if;
    end if;

    if bcoba_princ.coba_codi_barr <> babmc.prod_codi_alfa then
      babmc.prod_codi_alfa := bcoba_princ.coba_codi_barr;
      --pp_valida_prod_codi;
    end if;

    parameter.p_indi_gene_codi_pesa := 'S';

  end pp_gene_codi_barr_pesa_unid_1;

-----------------------------------------------
  procedure pp_muestra_come_prod_base(p_prod_base_codi in varchar2,
                                      p_prod_base_empr_codi in number) is
  v_cant number;
  begin
    select count(*)
      into v_cant
      from come_prod_bala_secc
     where prod_base_codi = p_prod_base_codi
       and prod_base_empr_codi = p_prod_base_empr_codi;
       
     if v_cant <= 0 then
       raise_application_error(-20010, 'Seccion de Balanza inexistente!.');
     end if;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Seccion de Balanza inexistente!.');
    when others then
      raise_application_error(-20010,'Error al buscar Seccion de Balanza!' ||sqlerrm);
  end pp_muestra_come_prod_base;

-----------------------------------------------
  procedure pp_validar_balanza(i_prod_prod_base_codi in number,
                               i_prod_empr_codi      in number
                               ) is
    
  begin
    
    babmc.prod_prod_base_codi := i_prod_prod_base_codi;
    babmc.prod_empr_codi      := i_prod_empr_codi;
    
    if nvl(parameter.p_ind_validar_cab, 'S') = 'S' then  
      if babmc.prod_prod_base_codi is not null then 

        pp_muestra_come_prod_base(babmc.prod_prod_base_codi,
                                  babmc.prod_empr_codi);
      /*else
          babmc.prod_prod_base_codi := null;
          babmc.prod_base_desc := null;*/
      end if;
      
      /*o_prod_base_desc := babmc.prod_base_desc;
      o_prod_prod_base_codi := babmc.prod_prod_base_codi;*/
      
      if babmc.prod_prod_base_codi is not null then
        if babmc.prod_tipo is null or babmc.prod_tipo not in ('P', 'U') then
          raise_application_error(-20010,'Se asigno una Seccion de Balanza, codigo generado!! Debe cancelar la operacion !');
        else
          if parameter.p_indi_consulta = 'N' then
            pp_gene_codi_barr_pesa_unid_1;
            parameter.p_codi_base_orig := babmc.prod_base_codi_alte;
            parameter.p_prod_tipo_orig := babmc.prod_tipo;
          end if;
        end if;
      end if;
    end if;

  end pp_validar_balanza;
  
-----------------------------------------------
  procedure pp_valida_codi_fabr is
    v_count number;
  begin
    select count(*)
      into v_count
      from come_prod
     where prod_codi_fabr = babmc.prod_codi_fabr
       and (babmc.prod_codi is null or babmc.prod_codi <> prod_codi);

    if v_count > 0 then
      raise_application_error(-20010,'El codigo de fabrica ingresado se encuentra asignado a otro producto');
    end if;

  Exception
    When no_data_found then
      null;
    When too_many_rows then
      raise_application_error(-20010, 'Codigo de Fabrica inexistente');
    when others then
      raise_application_error(-20010,'Error al validar Codigo de Fabrica!' ||sqlerrm);
  end pp_valida_codi_fabr;

-----------------------------------------------
  procedure pp_muestra_prod_clas_resp_qry(p_clre_codi in number) is
  v_cant number;
  begin
    select count(*)
      into v_cant
      from come_prod_clas_resp r
     where r.clre_codi = p_clre_codi;
     
    if v_cant <= 0 then
      raise_application_error(-20010, 'Clasificacion respaldo inexistente!.');
    end if;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Clasificacion respaldo inexistente!.');
    when others then
      raise_application_error(-20010,'Error al buscar Clasificacion respaldo!' || sqlerrm);
  end pp_muestra_prod_clas_resp_qry;

-----------------------------------------------
  procedure pp_validar_cod_fabrica(i_prod_codi_fabr in varchar2,
                                   i_prod_codi      in number) is
    
  begin
    
    babmc.prod_codi_fabr:= i_prod_codi_fabr; 
    babmc.prod_codi     := i_prod_codi;
    
    if nvl(parameter.p_ind_validar_cab, 'S') = 'S' then
      if babmc.prod_codi_fabr is not null then
        pp_valida_codi_fabr;
      end if;
      
      if babmc.prod_clre_codi is not null then
        pp_muestra_prod_clas_resp_qry(babmc.prod_clre_codi);                       
      end if;  
    end if;
  end pp_validar_cod_fabrica;
  
-----------------------------------------------
  procedure pp_validar_lote(i_prod_indi_lote in varchar2,
                            i_prod_codi      in number
                            ) is
    
  begin
    
    babmc.prod_indi_lote := i_prod_indi_lote;
    babmc.prod_codi      := i_prod_codi;
    
    if nvl(babmc.prod_indi_lote, 'N') = 'N' then
      if babmc.prod_codi is not null then
        declare
          v_count number;
        begin
          select count(*)
            into v_count
            from come_prod_depo_lote d, come_lote l
           where d.prde_lote_codi = l.lote_codi
             and l.lote_desc <> '000000'
             and l.lote_obse <> 'Lote Generico'
             and d.prde_cant_actu <> 0
             and d.prde_prod_codi = babmc.prod_codi;
          if v_count > 0 then
            babmc.prod_indi_lote := 'S';
            raise_application_error(-20010,'El producto posee existencias en sus lotes. '|| 'Debe dejarlos en cero para realizar este cambio');
          end if;
        end;
      end if;
    end if;

  end pp_validar_lote;

-----------------------------------------------
  procedure pp_muestra_come_codi_sofi(p_coso_codi_alte in varchar2,
                                      p_coso_empr_codi in number,
                                      p_coso_desc      out varchar2,
                                      p_coso_codi      out number,
                                      p_coso_porc_impu out number) is
  begin
    select c.coso_codi, c.coso_desc, c.coso_porc_impu
      into p_coso_codi, p_coso_desc, p_coso_porc_impu
      from come_codi_sofi c
     where c.coso_codi_alte = p_coso_codi_alte
       and c.coso_empr_codi = p_coso_empr_codi;

  exception
    when no_data_found then
      p_coso_desc      := null;
      p_coso_codi      := null;
      p_coso_porc_impu := null;
      raise_application_error(-20010, 'Codigo Sofia inexistente!.');
    when others then
      raise_application_error(-20010,'Error al validar Codigo Sofia!' || sqlerrm);
  end pp_muestra_come_codi_sofi;

-----------------------------------------------
  procedure pp_validar_cod_sofia(i_coso_codi_alte in number,
                                 i_prod_empr_codi in number,
                                 o_prod_coso_codi out number,
                                 o_coso_desc      out varchar2,
                                 o_coso_porc_impu out number
                                 ) is
    
  begin
    
    babmc.coso_codi_alte := i_coso_codi_alte;
    babmc.prod_empr_codi := i_prod_empr_codi;
      
    if babmc.coso_codi_alte is null then
      babmc.prod_coso_codi := null;
      babmc.coso_desc      := null;
      babmc.coso_porc_impu := null;
    else
      pp_muestra_come_codi_sofi(babmc.coso_codi_alte,
                                babmc.prod_empr_codi,
                                babmc.coso_desc,
                                babmc.prod_coso_codi,
                                babmc.coso_porc_impu);
    end if;
    
    o_prod_coso_codi := babmc.prod_coso_codi;
    o_coso_desc      := babmc.coso_desc;
    o_coso_porc_impu := babmc.coso_porc_impu;
    
  end pp_validar_cod_sofia;
  
-----------------------------------------------
  procedure pp_muestra_come_pais(p_pais_codi      in number,
                                 p_pais_empr_codi in number,
                                 p_pais_desc      out varchar2) is
  begin
    select p.pais_desc
      into p_pais_desc
      from come_pais p
     where p.pais_codi = p_pais_codi
       and p.pais_empr_codi = p_pais_empr_codi;

  exception
    when no_data_found then
      p_pais_desc := null;
      raise_application_error(-20010, 'Pais inexistente!.');
    when others then
      raise_application_error(-20010, 'Error al buscar Pais!' || sqlerrm);
  end pp_muestra_come_pais;

-----------------------------------------------
  procedure pp_validar_pais(i_prod_pais_codi in number,
                            i_prod_empr_codi in number,
                            o_pais_desc      out varchar2
                            ) is
    
  begin
    
    babmc.prod_pais_codi := i_prod_pais_codi;
    babmc.prod_empr_codi := i_prod_empr_codi;
    
    if babmc.prod_pais_codi is null then
      babmc.pais_desc      := null;
    else
      pp_muestra_come_pais(babmc.prod_pais_codi,
                           babmc.prod_empr_codi,
                           babmc.pais_desc);
    end if; 
    
    o_pais_desc := babmc.pais_desc;

  end;

-----------------------------------------------
  procedure pp_muestra_come_colo(p_colo_codi      in number,
                                 p_colo_empr_codi in number) is

    v_colo_codi number;

  begin

    select c.colo_codi
      into v_colo_codi
      from come_colo c
     where c.colo_codi = p_colo_codi
       and c.colo_empr_codi = p_colo_empr_codi;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Color inexistente!.');
    when others then
      raise_application_error(-20010, 'Error al buscar Color!' || sqlerrm);
  end pp_muestra_come_colo;

-----------------------------------------------
  procedure pp_validar_color(i_prod_colo_codi in number,
                             i_prod_empr_codi in number
                             ) is
    
  begin
    
    if babmc.prod_colo_codi is null then
      null;
    else
      pp_muestra_come_colo(babmc.prod_colo_codi,
                           babmc.prod_empr_codi);
    end if; 
    
  end pp_validar_color;
  
-----------------------------------------------
  procedure pp_validar_aro(i_prod_aro  in number,
                           i_prod_empr_codi in number) is
    salir  exception;
    v_cant number;
  begin

    begin
      select count(*)
        into v_cant
        from come_prod_aro a
       where a.prod_aro_empr_codi = i_prod_empr_codi
         and a.prod_aro_codi = i_prod_aro;
    end;

    if v_cant >= 1 then
      raise salir; --o si o si se encuentra
    end if;
    raise_application_error(-20010, 'Aro inexistente');
  exception
    when salir then
      null;
    when others then
      raise_application_error(-20010, 'Error al validar Aro!' || sqlerrm);
  end pp_validar_aro;

-----------------------------------------------
  procedure pp_validar_cod_aro(i_prod_aro_codi  in number,
                           i_prod_empr_codi in number) is
    
  begin
    
    babmc.prod_prod_aro_codi := i_prod_aro_codi;
    babmc.prod_empr_codi := i_prod_empr_codi;
    
    if babmc.prod_prod_aro_codi is null then
      null;
    else
      pp_validar_aro(babmc.prod_prod_aro_codi,babmc.prod_empr_codi);
    end if;
    
  end pp_validar_cod_aro;
  
-----------------------------------------------
  procedure pp_validar_prod_medi(i_prod_prod_medi_codi in number,
                                 i_prod_empr_codi in number
                                 ) is
    salir exception;
    v_cant number;
  begin
    
    begin
      select count(*)
        into v_cant
        from come_prod_medi m
       where m.prod_medi_empr_codi = i_prod_empr_codi 
         and m.prod_medi_codi = i_prod_prod_medi_codi;
    end;

    if v_cant >= 1 then
          raise salir;
    end if;

    raise_application_error(-20010,'Medida inexistente');
    
  exception
    when salir then
      null;
    when others then
      raise_application_error(-20010,'Error al validar Medida!' ||sqlerrm);
  end pp_validar_prod_medi;

-----------------------------------------------
  procedure pp_validar_medida(i_prod_prod_medi_codi in number,
                              i_prod_empr_codi        in number
                              ) is
    
  begin
    
    babmc.prod_prod_medi_codi := i_prod_prod_medi_codi;
    babmc.prod_empr_codi      := i_prod_empr_codi;

    if babmc.prod_prod_medi_codi is null then
      null;
    else
      pp_validar_prod_medi(babmc.prod_prod_medi_codi,babmc.prod_empr_codi);
    end if;
  end pp_validar_medida;
  
-----------------------------------------------
  procedure pp_validar_prod_cara(i_prod_cara_codi in number,
                                 i_prod_cara_empr_codi in number
                                 ) is
    salir exception;
    v_cant number;
  begin
    
    begin
      select count(*)
        into v_cant
        from come_prod_cara ar
       where ar.prod_cara_empr_codi = i_prod_cara_empr_codi
         and ar.prod_cara_codi      = i_prod_cara_codi;
    end;

    if v_cant >= 1 then
          raise salir; --o si o si se encuentra
    end if;

    raise_application_error(-20010,'Caracteristica inexistente');

  exception
    when salir then
      null;
    when others then
      raise_application_error(-20010,'Error al validar Caracteristica!' ||sqlerrm);
  end pp_validar_prod_cara;

-----------------------------------------------
  procedure pp_validar_cara(i_prod_prod_cara_codi in number,
                            i_prod_empr_codi      in number
                            ) is
    
  begin
    
    babmc.prod_prod_cara_codi := i_prod_prod_cara_codi;
    babmc.prod_empr_codi      := i_prod_empr_codi;

    if babmc.prod_prod_cara_codi is null then
      null;
    else
      pp_validar_prod_cara(babmc.prod_prod_cara_codi,babmc.prod_empr_codi);
    end if; 

  end pp_validar_cara;
  
-----------------------------------------------
  procedure pp_validar_list_base(i_liba_codi in number,
                                 i_liba_empr_codi in number
                                 ) is
    salir exception;
    v_cant number;
  begin
   
    begin
      select count(*)
        into v_cant
        from come_list_prec_base b
       where b.liba_empr_codi = i_liba_empr_codi
         and b.liba_codi      = i_liba_codi;
    end;

    if v_cant >= 1 then
      raise salir; 
    end if;

    raise_application_error(-20010,'Lista base inexistente');

  exception
    when salir then
      null;
    when others then
      raise_application_error(-20010,'Error al validar Lista base!' ||sqlerrm);
  end pp_validar_list_base;

-----------------------------------------------
  procedure pp_validar_list_base_codi(i_prod_liba_codi in number,
                                 i_prod_empr_codi in number) is
    
  begin
    babmc.prod_liba_codi := i_prod_liba_codi;
    babmc.prod_empr_codi := i_prod_empr_codi;

    if babmc.prod_liba_codi is null then
      if parameter.p_indi_obli_list_base = 'S' then
        raise_application_error(-20010,'Debe ingresar el codigo de Lista Base');
      else
        null;
      end if;
    else
      pp_validar_list_base(babmc.prod_liba_codi,babmc.prod_empr_codi);
    end if; 
  end pp_validar_list_base_codi;
    
-----------------------------------------------
  procedure pp_muestra_come_prod_grup(i_prgr_codi      in number,
                                      i_prgr_empr_codi in number) is
  
  v_prgr_codi number;
  
  begin
    select pg.prgr_codi
      into v_prgr_codi
      from come_prod_grup pg
     where pg.prgr_codi = i_prgr_codi
       and pg.prgr_empr_codi = i_prgr_empr_codi;

  exception
    when no_data_found then
      raise_application_error(-20010, 'Grupo de producto inexistente.');
    when others then
      raise_application_error(-20010,'Error al validar Grupo de producto!' ||sqlerrm);
  end pp_muestra_come_prod_grup;

-----------------------------------------------
  procedure pp_validar_prod_grup(i_prod_prgr_codi in number,
                                 i_prod_empr_codi in number) is
    
  begin
    
    babmc.prod_prgr_codi := i_prod_prgr_codi;
    babmc.prod_empr_codi := i_prod_empr_codi;
    
    if babmc.prod_prgr_codi is null then
       null;
    else
      pp_muestra_come_prod_grup(babmc.prod_prgr_codi,babmc.prod_empr_codi);
    end if; 

  end pp_validar_prod_grup;
  
-----------------------------------------------
  procedure pp_muestra_unid_medi(p_codi in number, p_desc out varchar) is

  begin

    select medi_desc_abre
      into p_desc
      from come_unid_medi
     where medi_codi = p_codi;

  Exception
    when no_data_found then
      raise_application_error(-20010, 'Unidad de medida Inexistente');
    when others then
      raise_application_error(-20010,'Error al buscar Unidad de medida!' || sqlerrm);
  end pp_muestra_unid_medi;

-----------------------------------------------
  procedure pp_validar_unid_medi(i_coba_medi_codi in number,
                                 o_medi_desc_abre out varchar2
                                 ) is
    
  begin
    
    bcoba_princ.coba_medi_codi := i_coba_medi_codi;
    
    if bcoba_princ.coba_medi_codi is not null then 
      pp_muestra_unid_medi(bcoba_princ.coba_medi_codi, bcoba_princ.medi_desc_abre);
      o_medi_desc_abre := bcoba_princ.medi_desc_abre;
      
    end if;
    
  end pp_validar_unid_medi;
  
-----------------------------------------------
  procedure pp_valida_prod_codi is
    v_prod_codi number;
  begin
    
    if babmc.prod_codi_alfa is null then
      raise_application_error(-20010,'Debe generar el Codigo alfanumerico!!');
    end if;

    if babmc.prod_codi is null then
      select prod_codi
        into v_prod_codi
        from come_prod
       where prod_codi_alfa = babmc.prod_codi_alfa;
    
      if v_prod_codi is not null then
        raise_application_error(-20010, 'Codigo de producto Existente');
      end if;
    end if;

  exception
    when no_data_found then
      null;
    when too_many_rows then
      raise_application_error(-20010,'Codigo de producto Existente. Duplicado');
    when others then
      raise_application_error(-20010,'Error al validar Producto! ' || sqlerrm);
  end pp_valida_prod_codi;

-----------------------------------------------
  PROCEDURE pp_nuevo_codigo_barra IS
    v_nume_item number := 0;
    v_cant      number;
  BEGIN

    --go_block('bcoba_princ');
    --first_record;
    if babmc.prod_prod_base_codi is not null then
      if babmc.prod_tipo is null or babmc.prod_tipo not in ('P', 'U') then
        raise_application_error(-20010,'Se asigno una Seccion de Balanza, debe ser de Tipo Pesable o Por Unidad!');
      else
        pp_gene_codi_barr_pesa_unid_1;
      end if;
    else
      if babmc.prod_tipo in ('P', 'U') then
        raise_application_error(-20010,'Debe ingresar la seccion de balanza cuando un producto es "Pesable o "Por Unidad"');
      end if;
      if bcoba_princ.coba_codi_barr is null then
        bcoba_princ.coba_codi_barr := babmc.prod_codi_alfa;
      end if;
      if bcoba_princ.coba_tipo is null then
        bcoba_princ.coba_tipo := 4;
      end if;
    
    end if;
    bcoba_princ.coba_prod_codi := babmc.prod_codi;
    bcoba_princ.coba_nume_item := 1;
    bcoba_princ.coba_desc      := babmc.prod_desc;
    bcoba_princ.coba_medi_codi := babmc.prod_medi_codi;
    bcoba_princ.coba_fact_conv := 1;

  END pp_nuevo_codigo_barra;

-----------------------------------------------
  procedure pp_validar_inac is

    cursor c_exist is
      select dl.prde_cant_actu, dl.prde_depo_codi
        from come_prod_depo dl
       where dl.prde_prod_codi = babmc.prod_codi
         and dl.prde_cant_actu <> 0
       order by 1;
  Begin

    if babmc.prod_codi is not null then
    
      if nvl(babmc.indi_inac_orig, 'N') <> nvl(babmc.prod_indi_inac, 'N') then
        if nvl(babmc.prod_indi_inac, 'N') = 'S' then
          for x in c_exist loop
            raise_application_error(-20010,
                                    'No se puede inactivar el producto porque poseee existencia ' ||
                                    x.prde_cant_actu || ' en el deposito ' ||
                                    x.prde_depo_codi);
          end loop;
        
        end if;
      
      end if;
    end if;

  end pp_validar_inac;
  
-----------------------------------------------
  PROCEDURE pp_valida_fact_conv IS
  BEGIN
    
    for bcoba in cur_bcoba loop 
      
      if bcoba.coba_codi_barr is not null then
        if bcoba.coba_desc is null then
          raise_application_error(-20010,'Debe ingresar Descripcion de codigo de barra!');
        end if;
        if bcoba.coba_fact_conv is null or bcoba.coba_fact_conv <= 0 then
          raise_application_error(-20010,'El factor de conversion debe ser mayor a cero!');
        end if;
      end if;
      if bcoba.coba_fact_conv is not null and bcoba.coba_medi_codi is null then
        raise_application_error(-20010,'Debe ingresar una unidad de medida para el Factor de Conversion!');
      end if;
    
      if bcoba.coba_codi_barr is null and
         (bcoba.coba_desc is not null or bcoba.coba_tipo is not null) then
        raise_application_error(-20010,'Debe ingresar ingresar un codigo de barras a la descripcion!');
      end if;
    
      end loop;
      
    END pp_valida_fact_conv;

-----------------------------------------------
    procedure pp_validar_repeticion(p_indi in char) is
      v_cant_reg number; --cantidad de registros en el bloque
      i          number;
      j          number;
      salir      exception;
      v_ant_art  varchar2(30);
      v_art_prin varchar2(30);
    begin

      for bcoba in cur_bcoba loop
        i := bcoba.seq_id;
      
        if p_indi = 'coba' then
          -- codigo de barra
          v_ant_art := bcoba.coba_codi_barr;
        elsif p_indi = 'faco' then
          --factor de conversion
          v_ant_art := bcoba.coba_fact_conv;
        elsif p_indi = 'medi' then
          --unidad de medida
          v_ant_art := bcoba.coba_medi_codi;
        elsif p_indi = 'tipo' then
          --tipo codigo de barra
          v_ant_art := bcoba.coba_tipo;
        end if;
      
        for j in i + 1 .. v_cant_reg loop
          --go_record(j);
          if p_indi = 'coba' then
            if v_ant_art = bcoba.coba_codi_barr then
              raise_application_error(-20010,'El codigo de Barras del item ' || to_char(i + 1) ||
                    ' se repite con el del item ' || to_char(j + 1) ||
                    '. asegurese de no introducir mas de una' ||
                    ' vez el mismo codigo!');
            end if;
          elsif p_indi = 'faco' then
            if v_ant_art = bcoba.coba_fact_conv then
              if bcoba.coba_fact_conv <> '1' then
                null;
              end if;
            end if;
          elsif p_indi = 'medi' then
            if v_ant_art = bcoba.coba_medi_codi then
              if bcoba.coba_fact_conv <> '1' then
                null;
              
              end if;
            end if;
          elsif p_indi = 'tipo' then
            if v_ant_art = bcoba.coba_tipo then
              null;
            end if;
          end if;
        end loop;
      end loop;

      --Validar con el bloque principal

      if p_indi = 'coba' then
        --codigo de barra
        v_art_prin := bcoba_princ.coba_codi_barr;
      elsif p_indi = 'faco' then
        --factor de conversion
        v_art_prin := bcoba_princ.coba_fact_conv;
      elsif p_indi = 'medi' then
        --unidad de medida
        v_ant_art := bcoba_princ.coba_medi_codi;
      elsif p_indi = 'tipo' then
        --tipo de codigo de barra
        v_ant_art := bcoba_princ.coba_tipo;
      end if;

      for bcoba in cur_bcoba loop
      
        if p_indi = 'coba' then
          if v_art_prin = bcoba.coba_codi_barr then
            raise_application_error(-20010,'El codigo de Barras del item ' || bcoba.coba_nume_item ||
                  ' se repite con el del item  1' ||
                  '. asegurese de no introducir mas de una' ||
                  ' vez el mismo codigo!');
          end if;
        elsif p_indi = 'faco' then
          if v_art_prin = bcoba.coba_fact_conv then
            if bcoba.coba_fact_conv <> '1' then
              null;
            end if;
          
          end if;
        elsif p_indi = 'medi' then
          if v_ant_art = bcoba.coba_medi_codi then
            if bcoba.coba_fact_conv <> '1' then
              null;
            end if;
          
          end if;
        elsif v_art_prin = 'tipo' then
          if v_ant_art = bcoba.coba_tipo then
            null;
          end if;
        end if;
       
      end loop;

    exception
      when salir then
        null;
    end pp_validar_repeticion;

-----------------------------------------------
  PROCEDURE pp_vali_codi_barr IS
    v_count     number;
    v_arti      varchar2(20);
    v_arti_desc varchar2(80);
  BEGIN
/*
    for bcoba in cur_bcoba loop
      select count(*)
        into v_count
        from come_prod_coba_deta c, come_prod p
       where c.coba_prod_codi = p.prod_codi
         and c.coba_codi_barr = bcoba.coba_codi_barr
         and p.prod_empr_codi = babmc.prod_empr_codi
         and ((p.prod_codi = babmc.prod_codi and
             c.coba_nume_item <> bcoba.coba_nume_item) or
             (p.prod_codi <> babmc.prod_codi));
      
      if v_count > 0 then
        begin
          select p.prod_codi_alfa, p.prod_desc
            into v_arti, v_arti_desc
            from come_prod_coba_deta c, come_prod p
           where c.coba_prod_codi = p.prod_codi
             and c.coba_codi_barr = bcoba.coba_codi_barr
             and p.prod_empr_codi = babmc.prod_empr_codi
             and ((p.prod_codi = babmc.prod_codi and
                 c.coba_nume_item <> bcoba.coba_nume_item) or
                 (p.prod_codi <> babmc.prod_codi));
          raise_application_error(-20010, 'Este codigo de barra ya ha sido asignado al articulo ' ||
                                  v_arti || '(' || v_arti_desc || ').');
        exception
          when too_many_rows then
            raise_application_error(-20010, 'Este codigo de barras ha sido asignado a varios articulos');
        end;
      end if;
      
    end loop;
*/    

    select count(*)
      into v_count
      from come_prod_coba_deta c, come_prod p
     where c.coba_prod_codi = p.prod_codi
       and c.coba_codi_barr = bcoba_princ.coba_codi_barr
       and p.prod_empr_codi = babmc.prod_empr_codi
       and ((p.prod_codi = babmc.prod_codi and
           c.coba_nume_item <> bcoba_princ.coba_nume_item) or
           (p.prod_codi <> babmc.prod_codi));

    if v_count > 0 then
      begin
        select p.prod_codi_alfa, p.prod_desc
          into v_arti, v_arti_desc
          from come_prod_coba_deta c, come_prod p
         where c.coba_prod_codi = p.prod_codi
           and c.coba_codi_barr = bcoba_princ.coba_codi_barr
           and p.prod_empr_codi = babmc.prod_empr_codi
           and ((p.prod_codi = babmc.prod_codi and
               c.coba_nume_item <> bcoba_princ.coba_nume_item) or
               (p.prod_codi <> babmc.prod_codi));
        raise_application_error(-20010, 'Este codigo de barra ya ha sido asignado al articulo 1 ' ||
                                v_arti || '(' || v_arti_desc || ').');
      exception
        when too_many_rows then
          raise_application_error(-20010, 'Este codigo de barras ha sido asignado a varios articulos 2');
      end;
    end if;

  EXCEPTION

    when no_data_found then
      null;
    when others then
      raise_application_error(-20010,'Error al Validar Codigo de Barras!' || sqlerrm);
      
  END pp_vali_codi_barr;

-----------------------------------------------
  procedure pp_validar_repeticion_um_fc is
    v_cant_reg  number; --cantidad de registros en el bloque
    i           number;
    j           number;
    salir       exception;
    v_medi_ante number;
    v_faco_ante number;
  begin

    for bcoba in cur_bcoba loop
      i := bcoba.seq_id;
      v_medi_ante := bcoba.coba_medi_codi;
      v_faco_ante := bcoba.coba_fact_conv;
      
      for j in i + 1 .. v_cant_reg loop
        if v_medi_ante = bcoba.coba_medi_codi then
          if v_faco_ante <> bcoba.coba_fact_conv then
            raise_application_error(-20010,
                                    'El FC y UM  del item ' || to_char(i) ||
                                    ' se repite con el del item ' ||
                                    to_char(j) ||
                                    '. asegurese de no introducir mas de una' ||
                                    ' vez el mismo codigo!');
          end if;
        end if;
      end loop;
    end loop;

    v_medi_ante := bcoba_princ.coba_medi_codi;
    v_faco_ante := bcoba_princ.coba_fact_conv;

    for bcoba in cur_bcoba loop
      if v_medi_ante = bcoba.coba_medi_codi then
        if v_faco_ante <> bcoba.coba_fact_conv then
          raise_application_error(-20010,
                                  'El FC y UM  del item ' || to_char(i) ||
                                  ' se repite con el del item ' || to_char(j) ||
                                  '. asegurese de no introducir mas de una' ||
                                  ' vez el mismo codigo!');
        end if;
      end if;
    
    end loop;

  exception
    when salir then
      null;
  end pp_validar_repeticion_um_fc;

-----------------------------------------------
  procedure pp_veri_abre_clas1 is
    v_desc_abre varchar2(5);
    v_indi_actu varchar2(1);
    v_long      number;
    v_desc      varchar2(5);

  begin
    select ltrim(rtrim(c.clas1_desc_abre)), nvl(c.clas1_indi_actu_desc, 'N')
      into v_desc_abre, v_indi_actu
      from come_prod_clas_1 c
     where c.clas1_codi = babmc.prod_clas1;

    if v_indi_actu = 'S' and v_desc_abre is not null then
      v_long := length(v_desc_abre);
      v_desc := substr(babmc.prod_desc, 1, v_long);
      if lower(v_desc) <> lower(v_desc_abre) then
        babmc.prod_desc := substr(v_desc_abre || ' ' || babmc.prod_desc,
                                  1,
                                  80);
      end if;
    end if;

  exception
    when no_data_found then
      null;
    when others then
      raise_application_error(-20010,'Error al verificar Clase !' || sqlerrm);
  end pp_veri_abre_clas1;

-----------------------------------------------
  procedure pp_vali_carac is

  begin
    if babmc.liba_codi_alte is null then
      if parameter.p_indi_obli_list_base = 'S' then
        raise_application_error(-20010,'Debe ingresar el codigo de Lista Base');
      else
        babmc.prod_liba_codi := null;
        babmc.liba_desc      := null;
      end if;
    end if;
  end pp_vali_carac;

-----------------------------------------------
  procedure pp_actualiza_prod_prov_clpr is
    v_indi_exis varchar2(1);
  begin

    v_indi_exis := 'N';
    for bprov in cur_bprov loop
      /*
      if bprov.clpr_codi_alte = babmc.clpr_codi_alte then
        v_indi_exis := 'S';
        exit;
      end if;
      */
      null;
    end loop;

    if v_indi_exis = 'N' then
      apex_collection.add_member(p_collection_name => parameter.coll_name2,
                                 p_c002            => babmc.prod_clpr_codi,
                                 p_c003            => babmc.clpr_codi_alte
                                 );
    end if;

  exception
    when others then
      raise_application_error(-20010,'Error al actualizar prod_prov_clpr!' || sqlerrm);
  end pp_actualiza_prod_prov_clpr;

-----------------------------------------------
  procedure pp_cargar_item is
    
   v_indi varchar2(2);
   
  begin
/*    
    babmc.prod_codi                     := V('P45_PROD_CODI');
    babmc.prod_codi_alfa                := V('P45_PROD_CODI_ALFA');
    --babmc.prod_clas1                    := V('P45_PROD_CLAS1');
    babmc.prod_clas2                    := V('P45_PROD_CLAS2');
    --babmc.prod_clas3                    := V('P45_PROD_CLAS3');--ERROR
    babmc.prod_desc                     := V('P45_PROD_DESC');
    --babmc.prod_clas4                    := V('P45_PROD_CLAS4');--ERROR
    --babmc.prod_prec                     := V('P45_PROD_PREC');
    babmc.prod_maxi_porc_desc           := V('P45_PROD_MAXI_PORC_DESC');
    babmc.prod_obse                     := V('P45_PROD_OBSE');
    babmc.prod_desc_exte                := V('P45_PROD_DESC_EXTE');
    babmc.prod_exis_min                 := V('P45_PROD_EXIS_MIN');
    babmc.prod_clco_codi                := V('P45_PROD_CLCO_CODI');
    babmc.prod_clpr_codi                := V('P45_PROD_CLPR_CODI');
    babmc.prod_codi_fabr                := V('P45_PROD_CODI_FABR');
    babmc.prod_impu_codi                := V('P45_PROD_IMPU_CODI');
    babmc.prod_marc_codi                := V('P45_PROD_MARC_CODI');
    babmc.prod_medi_codi                := V('P45_PROD_MEDI_CODI');
    babmc.prod_indi_inac                := V('P45_PROD_INDI_INAC');
    babmc.prod_clre_codi                := V('P45_PROD_CLRE_CODI');
    --babmc.prod_codi_barr                := V('P45_PROD_CODI_BARR');
    --babmc.prod_base                     := V('P45_PROD_BASE');
    --babmc.prod_prtr_codi                := V('P45_PROD_PRTR_CODI');
    babmc.prod_tipo                     := V('P45_PROD_TIPO');
    --babmc.prod_indi_mate_prim           := V('P45_PROD_INDI_MATE_PRIM');
    --babmc.prod_indi_vent                := V('P45_PROD_INDI_VENT');
    --babmc.prod_codi_orig                := V('P45_PROD_CODI_ORIG');
    babmc.prod_fact_conv                := V('P45_PROD_FACT_CONV');
    babmc.prod_indi_kitt                := V('P45_PROD_INDI_KITT');
    --babmc.prod_indi_inac_old            := V('P45_PROD_INDI_INAC_OLD');
    --babmc.prod_prlp_codi                := V('P45_PROD_PRLP_CODI');
    --babmc.prod_tara                     := V('P45_PROD_TARA');
    babmc.prod_cas                      := V('P45_PROD_CAS');
    babmc.prod_htsn                     := V('P45_PROD_HTSN');
    --babmc.prod_mult_rect                := V('P45_PROD_MULT_RECT');
    babmc.prod_indi_fact_sub_cost       := V('P45_PROD_INDI_FACT_SUB_COST');
    babmc.prod_peso_kilo                := V('P45_PROD_PESO_KILO');
    --babmc.prod_cost_inic                := V('P45_PROD_COST_INIC');
    --babmc.prod_indi_devo_sin_soli       := V('P45_PROD_INDI_DEVO_SIN_SOLI');
    babmc.prod_imag_desc                := V('P45_PROD_IMAG_DESC');
    babmc.prod_anch_pulg                := V('P45_PROD_ANCH_PULG');
    babmc.prod_alto_pulg                := V('P45_PROD_ALTO_PULG');
    --babmc.prod_indi_fact_nega           := V('P45_PROD_INDI_FACT_NEGA');
    babmc.prod_medi_alte_equi           := V('P45_PROD_MEDI_ALTE_EQUI');
    --babmc.prod_medi_codi_alte           := V('P45_PROD_MEDI_CODI_ALTE');
    babmc.prod_user_regi                := V('P45_PROD_USER_REGI');
    babmc.prod_fech_regi                := V('P45_PROD_FECH_REGI');
    babmc.prod_user_modi                := V('P45_PROD_USER_MODI');
    babmc.prod_fech_modi                := V('P45_PROD_FECH_MODI');
    --babmc.prod_indi_auto_fact           := V('P45_PROD_INDI_AUTO_FACT');
    --babmc.prod_user_auto_fact           := V('P45_PROD_USER_AUTO_FACT');
    --babmc.prod_fech_auto_fact           := V('P45_PROD_FECH_AUTO_FACT');
    babmc.prod_nume_orde                := V('P45_PROD_NUME_ORDE');
    babmc.prod_packaging                := V('P45_PROD_PACKAGING');
    --babmc.prod_empr_codi                := V('P45_PROD_EMPR_CODI');
    --babmc.prod_colo_codi                := V('P45_PROD_COLO_CODI');
    babmc.prod_espe                     := V('P45_PROD_ESPE');
    --babmc.prod_imag                     := V('P45_PROD_IMAG');--ERROR
    babmc.prod_indi_lote                := V('P45_PROD_INDI_LOTE');
    babmc.prod_prod_aro_codi            := V('P45_PROD_PROD_ARO_CODI');
    babmc.prod_prod_medi_codi           := V('P45_PROD_PROD_MEDI_CODI');
    --babmc.prod_prod_cara_codi           := V('P45_PROD_PROD_CARA_CODI');
    --babmc.prod_liba_codi                := V('P45_PROD_LIBA_CODI');
    --babmc.prod_etiq_codi                := V('P45_PROD_ETIQ_CODI');
    babmc.prod_prop_ship_name           := V('P45_PROD_PROP_SHIP_NAME');
    babmc.prod_peli_clas                := V('P45_PROD_PELI_CLAS');
    babmc.prod_peli_pack_grou           := V('P45_PROD_PELI_PACK_GROU');
    babmc.prod_peli_un                  := V('P45_PROD_PELI_UN');
    babmc.prod_tunn_rest                := V('P45_PROD_TUNN_REST');
    babmc.prod_ems                      := V('P45_PROD_EMS');
    babmc.prod_mari_poll                := V('P45_PROD_MARI_POLL');
    babmc.prod_chem_name                := V('P45_PROD_CHEM_NAME');
    babmc.prod_nume_ec                  := V('P45_PROD_NUME_EC');
    babmc.prod_reac_regi                := V('P45_PROD_REAC_REGI');
    babmc.prod_haza_simb                := V('P45_PROD_HAZA_SIMB');
    babmc.prod_risk_phra                := V('P45_PROD_RISK_PHRA');
    babmc.prod_haza_stat                := V('P45_PROD_HAZA_STAT');
    babmc.prod_prec_stat                := V('P45_PROD_PREC_STAT');
    babmc.prod_porc_reca                := V('P45_PROD_PORC_RECA');
    --babmc.prod_prgr_codi                := V('P45_PROD_PRGR_CODI');
    --babmc.prod_bota_name                := V('P45_PROD_BOTA_NAME');
    --babmc.prod_coun_orig                := V('P45_PROD_COUN_ORIG');
    --babmc.prod_cas_eine                 := V('P45_PROD_CAS_EINE');
    --babmc.prod_eine_elin                := V('P45_PROD_EINE_ELIN');
    --babmc.prod_fda                      := V('P45_PROD_FDA');
    --babmc.prod_fema                     := V('P45_PROD_FEMA');
    --babmc.prod_tari                     := V('P45_PROD_TARI');
    babmc.prod_prod_base_codi           := V('P45_PROD_PROD_BASE_CODI');
    babmc.prod_indi_envi_bala           := V('P45_PROD_INDI_ENVI_BALA');
    babmc.prod_coso_codi                := V('P45_PROD_COSO_CODI');
    babmc.prod_indi_kitt_list_prec_comp := V('P45_PROD_INDI_KITT_LIST_PREC_COMP');
    --babmc.prod_indi                     := V('P45_PROD_INDI');
    babmc.prod_indi_rota                := V('P45_PROD_INDI_ROTA');
    babmc.prod_indi_fuera_linea         := V('P45_PROD_INDI_FUERA_LINEA');
    --babmc.prod_pais_codi                := V('P45_PROD_PAIS_CODI');
    --babmc.prod_dise_codi                := V('P45_PROD_DISE_CODI');
*/
    
    babmc.prod_codi                     := V('P72_PROD_CODI');
    babmc.prod_codi_alfa                := ltrim(rtrim(upper(V('P72_PROD_CODI_ALFA'))));
    babmc.prod_clas2                    := V('P72_PROD_CLAS2');
    babmc.prod_desc                     := V('P72_PROD_DESC');
    babmc.prod_maxi_porc_desc           := V('P72_PROD_MAXI_PORC_DESC');
    babmc.prod_obse                     := V('P72_PROD_OBSE');
    babmc.prod_desc_exte                := V('P72_PROD_DESC_EXTE');
    babmc.prod_exis_min                 := V('P72_PROD_EXIS_MIN');
    babmc.prod_clco_codi                := V('P72_PROD_CLCO_CODI');
    babmc.prod_clpr_codi                := V('P72_PROD_CLPR_CODI');
    babmc.prod_codi_fabr                := V('P72_PROD_CODI_FABR');
    babmc.prod_impu_codi                := V('P72_PROD_IMPU_CODI');
    babmc.prod_marc_codi                := V('P72_PROD_MARC_CODI');
    babmc.prod_medi_codi                := V('P72_PROD_MEDI_CODI');
    babmc.prod_indi_inac                := V('P72_PROD_INDI_INAC');
    babmc.prod_clre_codi                := V('P72_PROD_CLRE_CODI');
    babmc.prod_tipo                     := V('P72_PROD_TIPO');
    babmc.prod_fact_conv                := V('P72_PROD_FACT_CONV');
    babmc.prod_indi_kitt                := V('P72_PROD_INDI_KITT');
    babmc.prod_cas                      := V('P72_PROD_CAS');
    babmc.prod_htsn                     := V('P72_PROD_HTSN');
    babmc.prod_indi_fact_sub_cost       := V('P72_PROD_INDI_FACT_SUB_COST');
    babmc.prod_peso_kilo                := V('P72_PROD_PESO_KILO');
    babmc.prod_imag_desc                := V('P72_PROD_IMAG_DESC');
    babmc.prod_anch_pulg                := V('P72_PROD_ANCH_PULG');
    babmc.prod_alto_pulg                := V('P72_PROD_ALTO_PULG');
    babmc.prod_medi_alte_equi           := V('P72_PROD_MEDI_ALTE_EQUI');
    babmc.prod_user_regi                := V('P72_PROD_USER_REGI');
    --babmc.prod_fech_regi                := V('P72_PROD_FECH_REGI');
    babmc.prod_user_modi                := V('P72_PROD_USER_MODI');
    --babmc.prod_fech_modi                := V('P72_PROD_FECH_MODI');
    babmc.prod_nume_orde                := V('P72_PROD_NUME_ORDE');
    babmc.prod_packaging                := V('P72_PROD_PACKAGING');
    babmc.prod_espe                     := V('P72_PROD_ESPE');
    babmc.prod_indi_lote                := V('P72_PROD_INDI_LOTE');
    babmc.prod_prod_aro_codi            := V('P72_PROD_PROD_ARO_CODI');
    babmc.prod_prod_medi_codi           := V('P72_PROD_PROD_MEDI_CODI');
    babmc.prod_prop_ship_name           := V('P72_PROD_PROP_SHIP_NAME');
    babmc.prod_peli_clas                := V('P72_PROD_PELI_CLAS');
    babmc.prod_peli_pack_grou           := V('P72_PROD_PELI_PACK_GROU');
    babmc.prod_peli_un                  := V('P72_PROD_PELI_UN');
    babmc.prod_tunn_rest                := V('P72_PROD_TUNN_REST');
    babmc.prod_ems                      := V('P72_PROD_EMS');
    babmc.prod_mari_poll                := V('P72_PROD_MARI_POLL');
    babmc.prod_chem_name                := V('P72_PROD_CHEM_NAME');
    babmc.prod_nume_ec                  := V('P72_PROD_NUME_EC');
    babmc.prod_reac_regi                := V('P72_PROD_REAC_REGI');
    babmc.prod_haza_simb                := V('P72_PROD_HAZA_SIMB');
    babmc.prod_risk_phra                := V('P72_PROD_RISK_PHRA');
    babmc.prod_haza_stat                := V('P72_PROD_HAZA_STAT');
    babmc.prod_prec_stat                := V('P72_PROD_PREC_STAT');
    babmc.prod_porc_reca                := V('P72_PROD_PORC_RECA');
    babmc.prod_prod_base_codi           := V('P72_PROD_PROD_BASE_CODI');
    babmc.prod_indi_envi_bala           := V('P72_PROD_INDI_ENVI_BALA');
    babmc.prod_coso_codi                := V('P72_PROD_COSO_CODI');
    babmc.prod_indi_kitt_list_prec_comp := V('P72_PROD_INDI_KITT_LIST_PREC_COMP');
    babmc.prod_indi_rota                := V('P72_PROD_INDI_ROTA');
    babmc.prod_indi_fuera_linea         := V('P72_PROD_INDI_FUERA_LINEA');
    babmc.prod_empr_codi                := V('AI_EMPR_CODI');
    babmc.prod_indi_venc_lote           := V('P72_PROD_INDI_VENC_LOTE');
    babmc.prod_indi_iccid_lote_obli     := V('P72_PROD_INDI_ICCID_LOTE_OBLI');      
    babmc.prod_indi_lote_nume_tele      := V('P72_PROD_INDI_LOTE_NUME_TELE');
    
    v_indi := V('P72_INDI');--V('P45_INDI');
    if v_indi = 'I' then
      parameter.p_indi_consulta := 'N';
    else
      parameter.p_indi_consulta := 'S';
    end if;
    
    if babmc.prod_codi_alfa is null then
      pp_genera_codi(babmc.prod_codi_alfa);
      --raise_application_error(-20010,'babmc.prod_codi_alfa: ' || babmc.prod_codi_alfa);
    end if;
    
  end;
  
-----------------------------------------------
  procedure pp_validar_items_nulos is
    
  begin
    
    --pp_validar_cod_alfa(babmc.prod_codi_alfa);
    pp_validar_cod_alfa_ins(babmc.prod_codi_alfa);
    pp_validar_descrip(babmc.prod_desc);
    
    /*pp_validar_prov(V('P45_PROD_CLPR_CODI'));
    pp_validar_respaldo(V('P45_PROD_CLRE_CODI'), V('AI_EMPR_CODI'));
    pp_validar_marca(V('P45_PROD_MARC_CODI'), V('AI_EMPR_CODI'));
    pp_validar_tipo(V('P45_PROD_TIPO'));
    pp_validar_balanza(V('P45_PROD_PROD_BASE_CODI'), V('AI_EMPR_CODI'));
    pp_valida_sub_familia(V('P45_PROD_CLAS2'), V('AI_EMPR_CODI'));
    pp_validar_unid_medida(V('P45_PROD_MEDI_CODI'), V('AI_EMPR_CODI'), babmc.medi_desc_abre);
    pp_validar_impuesto(V('P45_PROD_IMPU_CODI'), V('AI_EMPR_CODI'));
    pp_validar_concepto(V('P45_PROD_CLCO_CODI'), V('AI_EMPR_CODI'));
    pp_validar_cod_fabrica(V('P45_PROD_CODI_FABR'), V('P45_PROD_CODI'));
    pp_validar_lote(V('P45_PROD_INDI_LOTE'), V('P45_PROD_CODI')); */
    
    --raise_application_error(-20010,'items nulos');
    pp_validar_prov(V('P72_PROD_CLPR_CODI'));
    
    pp_validar_respaldo(V('P72_PROD_CLRE_CODI'), V('AI_EMPR_CODI'));
    pp_validar_marca(V('P72_PROD_MARC_CODI'), V('AI_EMPR_CODI'));
    pp_validar_tipo(V('P72_PROD_TIPO'));
    pp_validar_balanza(V('P72_PROD_PROD_BASE_CODI'), V('AI_EMPR_CODI'));
    pp_valida_sub_familia(V('P72_PROD_CLAS2'), V('AI_EMPR_CODI'),babmc.prod_clas1,babmc.prod_clas1_desc);
        
    pp_validar_unid_medida(V('P72_PROD_MEDI_CODI'), V('AI_EMPR_CODI'), babmc.medi_desc_abre);
    pp_validar_impuesto(V('P72_PROD_IMPU_CODI'), V('AI_EMPR_CODI'));
    pp_validar_concepto(V('P72_PROD_CLCO_CODI'), V('AI_EMPR_CODI'));
    pp_validar_cod_fabrica(V('P72_PROD_CODI_FABR'), V('P72_PROD_CODI'));
    pp_validar_lote(V('P72_PROD_INDI_LOTE'), V('P72_PROD_CODI'));
      
  end pp_validar_items_nulos;
  
-----------------------------------------------
  procedure pp_generar_lote_generico(p_prod_codi in number) is
    v_lote_codi           number(10);
    v_lote_desc           varchar2(60);
    v_lote_prod_codi      number(20);
    v_lote_fech_elab      date;
    v_lote_fech_venc      date;
    v_lote_esta           varchar2(1);
    v_lote_base           number(2);
    v_lote_obse           varchar2(200);
    v_lote_prec_unit      number(20, 4);
    v_lote_cost_prom_mmnn number(20, 4);

  begin

    --generar el max codigo de lote
    select nvl(max(lote_codi), 0) + 1 into v_lote_codi from come_lote;

    v_lote_desc           := '000000';
    v_lote_prod_codi      := p_prod_codi;
    v_lote_fech_elab      := sysdate;
    v_lote_fech_venc      := sysdate + (365 * 10);
    v_lote_esta           := 'A';
    v_lote_base           := parameter.p_codi_base;
    v_lote_obse           := 'Lote Generico';
    v_lote_prec_unit      := 0;
    v_lote_cost_prom_mmnn := 0;

    insert into come_lote
      (lote_codi,
       lote_desc,
       lote_prod_codi,
       lote_fech_elab,
       lote_fech_venc,
       lote_esta,
       lote_base,
       lote_obse,
       lote_prec_unit,
       lote_cost_prom_mmnn)
    values
      (v_lote_codi,
       v_lote_desc,
       v_lote_prod_codi,
       v_lote_fech_elab,
       v_lote_fech_venc,
       v_lote_esta,
       v_lote_base,
       v_lote_obse,
       v_lote_prec_unit,
       v_lote_cost_prom_mmnn);

  end pp_generar_lote_generico;

-----------------------------------------------
  PROCEDURE pp_genera_orden IS
  BEGIN

    if babmc.prod_nume_orde is null then
      babmc.prod_nume_orde := to_number(babmc.prod_codi_alfa);
    end if;

  exception
    when others then
      babmc.prod_nume_orde := null;
  END;

-----------------------------------------------
  procedure pp_insertar_cod_barras is
    v_cant number;
  begin
    
    select count(*)
     into v_cant
    from apex_collections a
    where a.collection_name = 'COLL_BCOBA';
    
    if nvl(v_cant,0) = 0 then
      null;
      /*
      insert into come_prod_coba_deta
          (coba_nume_item,
           coba_prod_codi,
           coba_desc,
           coba_tipo,
           coba_codi_barr,
           coba_medi_codi,
           coba_fact_conv,
           coba_user_regi,
           coba_fech_regi,
           --coba_user_modi,
           --coba_fech_modi,
           coba_base--,coba_codi
           )
        values
          (bcoba.coba_nume_item,
           babmc.prod_codi,
           fa_pasa_capital(bcoba.coba_desc),
           bcoba.coba_tipo,
           bcoba.coba_codi_barr,
           bcoba.coba_medi_codi,
           bcoba.coba_fact_conv,
           fp_user,
           sysdate,
           --coba_user_modi,
           --coba_fech_modi,
           babmc.prod_base--,bcoba.coba_codi
           );
*/           
    else
      
      for bcoba in cur_bcoba loop
        
        insert into come_prod_coba_deta
          (coba_nume_item,
           coba_prod_codi,
           coba_desc,
           coba_tipo,
           coba_codi_barr,
           coba_medi_codi,
           coba_fact_conv,
           coba_user_regi,
           coba_fech_regi,
           --coba_user_modi,
           --coba_fech_modi,
           coba_base--,coba_codi
           )
        values
          (bcoba.coba_nume_item,
           babmc.prod_codi,
           fa_pasa_capital(bcoba.coba_desc),
           bcoba.coba_tipo,
           bcoba.coba_codi_barr,
           bcoba.coba_medi_codi,
           bcoba.coba_fact_conv,
           fp_user,
           sysdate,
           --coba_user_modi,
           --coba_fech_modi,
           babmc.prod_base--,bcoba.coba_codi
           );
           
      end loop;
      
    end if; 
    
  exception
    when others then
      raise_application_error(-20010, 'Error al insertar codigo de barras!. '||sqlerrm);
  end pp_insertar_cod_barras;

-----------------------------------------------
  procedure pp_insertar_proveedores is
    
  begin
    
    for bprov in cur_bprov loop
      insert into come_prod_prov_deta
        (prod_prov_nume_item,
         prod_prov_prod_codi,
         prod_prov_clpr_codi,
         prod_prov_user_regi,
         prod_prov_fech_regi)
      values
        (bprov.prod_prov_nume_item,
         babmc.prod_codi,
         bprov.prod_prov_clpr_codi,
         fp_user,
         sysdate);
    end loop;
  
  exception
    when others then
      raise_application_error(-20010, 'Error al insertar proveedores!. '||sqlerrm);
  end pp_insertar_proveedores;
  
-----------------------------------------------
  procedure pp_insertar_analisis is
    
  begin
    for banal in cur_banal loop
      
      insert into come_prod_tipo_anal
        (prti_prod_codi,
         prti_tian_codi,
         prti_base,
         prti_rang_mini,
         prti_rang_maxi,
         prti_orde)
      values
        (babmc.prod_codi,
         banal.prti_tian_codi,
         babmc.prod_base,
         banal.prti_rang_mini,
         banal.prti_rang_maxi,
         banal.prti_orde);
         
    end loop;
    
  exception
    when others then
      raise_application_error(-20010, 'Error al insertar analisis!. '||sqlerrm);
  end pp_insertar_analisis;
  
-----------------------------------------------
  procedure pp_inserta_componentes is
    
  begin
    
    for bcomp in cur_bcomp loop
      insert into come_prod_comp
        (comp_nume_item, 
        comp_prod_codi, 
        comp_desc, 
        comp_base)
      values
        (bcomp.comp_nume_item, 
        babmc.prod_codi, 
        bcomp.comp_desc, 
        babmc.prod_base);
    end loop;
    
  exception
    when others then
      raise_application_error(-20010, 'Error al insertar componentes!. '||sqlerrm);
      
  end pp_inserta_componentes;
  
-----------------------------------------------
  procedure pp_inserta_img is
  
  begin
  
    for babmc_imag in cur_babmc_imag loop
      
      insert into come_prod_imag
        (prim_prod_codi, prim_nume_item, prim_imag, prim_fech)
      values
        (babmc.prod_codi,
         babmc_imag.prim_nume_item,
         babmc_imag.prim_imag,
         sysdate);
         
    end loop;
  
  exception
    when others then
      raise_application_error(-20010, 'Error al insertar imagen!. ' || sqlerrm);
    
  end pp_inserta_img;
  
-----------------------------------------------
  procedure pp_insertar_registros is
    
  begin
    
    babmc.prod_base := parameter.p_codi_base;
    babmc.prod_codi := fa_sec_come_prod; 
    --
    babmc.prod_indi_fact_nega := 'S';
    babmc.prod_indi_auto_fact := 'S';
    pp_genera_orden;
    --
    if parameter.p_indi_pasa_capi = 'S' then
       babmc.prod_desc       := fa_pasa_capital(babmc.prod_desc);
       babmc.prod_desc_exte  := fa_pasa_capital(babmc.prod_desc_exte);
    elsif parameter.p_indi_pasa_capi = 'M' then
       babmc.prod_desc       := upper(babmc.prod_desc);
       babmc.prod_desc_exte  := upper(babmc.prod_desc_exte);
    end if;
    
    insert into come_prod
    (prod_codi,
     prod_codi_alfa,
     prod_clas1,
     prod_clas2,
     --prod_clas3,
     prod_desc,
     --prod_clas4,
     prod_prec,
     prod_maxi_porc_desc,
     prod_obse,
     prod_desc_exte,
     prod_exis_min,
     prod_clco_codi,
     prod_clpr_codi,
     prod_codi_fabr,
     prod_impu_codi,
     prod_marc_codi,
     prod_medi_codi,
     prod_indi_inac,
     prod_clre_codi,
     prod_codi_barr,
     prod_base,
     prod_prtr_codi,
     prod_tipo,
     prod_indi_mate_prim,
     prod_indi_vent,
     prod_codi_orig,
     prod_fact_conv,
     prod_indi_kitt,
     prod_indi_inac_old,
     prod_prlp_codi,
     prod_tara,
     prod_cas,
     prod_htsn,
     prod_mult_rect,
     prod_indi_fact_sub_cost,
     prod_peso_kilo,
     prod_cost_inic,
     prod_indi_devo_sin_soli,
     prod_imag_desc,
     prod_anch_pulg,
     prod_alto_pulg,
     prod_indi_fact_nega,
     prod_medi_alte_equi,
     prod_medi_codi_alte,
     prod_user_regi,
     prod_fech_regi,
     --prod_user_modi,
     --prod_fech_modi,
     prod_indi_auto_fact,
     prod_user_auto_fact,
     prod_fech_auto_fact,
     prod_nume_orde,
     prod_packaging,
     prod_empr_codi,
     prod_colo_codi,
     prod_espe,
     prod_imag,
     prod_indi_lote,
     prod_prod_aro_codi,
     prod_prod_medi_codi,
     prod_prod_cara_codi,
     prod_liba_codi,
     prod_etiq_codi,
     prod_prop_ship_name,
     prod_peli_clas,
     prod_peli_pack_grou,
     prod_peli_un,
     prod_tunn_rest,
     prod_ems,
     prod_mari_poll,
     prod_chem_name,
     prod_nume_ec,
     prod_reac_regi,
     prod_haza_simb,
     prod_risk_phra,
     prod_haza_stat,
     prod_prec_stat,
     prod_porc_reca,
     prod_prgr_codi,
     prod_bota_name,
     prod_coun_orig,
     prod_cas_eine,
     prod_eine_elin,
     prod_fda,
     prod_fema,
     prod_tari,
     prod_prod_base_codi,
     prod_indi_envi_bala,
     prod_coso_codi,
     prod_indi_kitt_list_prec_comp,
     prod_indi,
     prod_indi_rota,
     prod_indi_fuera_linea,
     prod_pais_codi,
     prod_dise_codi,
     prod_indi_venc_lote,
     prod_indi_iccid_lote_obli,
     prod_indi_lote_nume_tele)
  values
    (babmc.prod_codi,
     babmc.prod_codi_alfa,
     babmc.prod_clas1,
     babmc.prod_clas2,
     --babmc.prod_clas3,
     babmc.prod_desc,
     --babmc.prod_clas4,
     babmc.prod_prec,
     babmc.prod_maxi_porc_desc,
     babmc.prod_obse,
     babmc.prod_desc_exte,
     babmc.prod_exis_min,
     babmc.prod_clco_codi,
     babmc.prod_clpr_codi,
     babmc.prod_codi_fabr,
     babmc.prod_impu_codi,
     babmc.prod_marc_codi,
     babmc.prod_medi_codi,
     babmc.prod_indi_inac,
     babmc.prod_clre_codi,
     babmc.prod_codi_barr,
     babmc.prod_base,
     babmc.prod_prtr_codi,
     babmc.prod_tipo,
     babmc.prod_indi_mate_prim,
     babmc.prod_indi_vent,
     babmc.prod_codi_orig,
     babmc.prod_fact_conv,
     babmc.prod_indi_kitt,
     babmc.prod_indi_inac_old,
     babmc.prod_prlp_codi,
     babmc.prod_tara,
     babmc.prod_cas,
     babmc.prod_htsn,
     babmc.prod_mult_rect,
     babmc.prod_indi_fact_sub_cost,
     babmc.prod_peso_kilo,
     babmc.prod_cost_inic,
     babmc.prod_indi_devo_sin_soli,
     babmc.prod_imag_desc,
     babmc.prod_anch_pulg,
     babmc.prod_alto_pulg,
     babmc.prod_indi_fact_nega,
     babmc.prod_medi_alte_equi,
     babmc.prod_medi_codi_alte,
     fp_user,--babmc.prod_user_regi,
     sysdate,--babmc.prod_fech_regi,
     --babmc.prod_user_modi,
     --babmc.prod_fech_modi,
     babmc.prod_indi_auto_fact,
     babmc.prod_user_auto_fact,
     babmc.prod_fech_auto_fact,
     babmc.prod_nume_orde,
     babmc.prod_packaging,
     babmc.prod_empr_codi,
     babmc.prod_colo_codi,
     babmc.prod_espe,
     babmc.prod_imag,
     babmc.prod_indi_lote,
     babmc.prod_prod_aro_codi,
     babmc.prod_prod_medi_codi,
     babmc.prod_prod_cara_codi,
     babmc.prod_liba_codi,
     babmc.prod_etiq_codi,
     babmc.prod_prop_ship_name,
     babmc.prod_peli_clas,
     babmc.prod_peli_pack_grou,
     babmc.prod_peli_un,
     babmc.prod_tunn_rest,
     babmc.prod_ems,
     babmc.prod_mari_poll,
     babmc.prod_chem_name,
     babmc.prod_nume_ec,
     babmc.prod_reac_regi,
     babmc.prod_haza_simb,
     babmc.prod_risk_phra,
     babmc.prod_haza_stat,
     babmc.prod_prec_stat,
     babmc.prod_porc_reca,
     babmc.prod_prgr_codi,
     babmc.prod_bota_name,
     babmc.prod_coun_orig,
     babmc.prod_cas_eine,
     babmc.prod_eine_elin,
     babmc.prod_fda,
     babmc.prod_fema,
     babmc.prod_tari,
     babmc.prod_prod_base_codi,
     babmc.prod_indi_envi_bala,
     babmc.prod_coso_codi,
     babmc.prod_indi_kitt_list_prec_comp,
     babmc.prod_indi,
     babmc.prod_indi_rota,
     babmc.prod_indi_fuera_linea,
     babmc.prod_pais_codi,
     babmc.prod_dise_codi,
     babmc.prod_indi_venc_lote,
     babmc.prod_indi_iccid_lote_obli,
     babmc.prod_indi_lote_nume_tele);

     pp_generar_lote_generico(babmc.prod_codi);
     
     --INSERTA CODIGO DE BARRAS
     pp_insertar_cod_barras;
     
     --INSERTA PROVEEDORES
     pp_insertar_proveedores;
     
     --INSERTA ANALISIS
     pp_insertar_analisis;
     
     --INSERTA COMPONENTES
     pp_inserta_componentes;
     
     --INSERTA IMAGEN
     pp_inserta_img;
     
     
     --apex_application.g_print_success_message :='Registro insertado correctamente!';
     
  exception
    when others then
      raise_application_error(-20010,'Error al insertar registro.! '||sqlerrm);
  end pp_insertar_registros;
  
-----------------------------------------------
  procedure pp_update_cod_barras is
    v_cant number;
    e_delete exception;
    --v_item number;
  begin
    v_cant:=0;
    for bcoba in cur_bcoba loop
/*      
      select count(*)
        into v_cant 
       from come_prod_coba_deta
       where coba_nume_item = bcoba.coba_nume_item
         and coba_prod_codi = babmc.prod_codi;
      
      if bcoba.coba_nume_item = '2' then
        raise_application_error(-20010,'v_cant : '||v_cant );
      end if;
*/      
      
    
      --if bcoba.coba_prod_codi is null then
      if nvl(bcoba.coba_indi,'S') = 'I' then
      --if v_cant <= 0 then
        select nvl(max(coba_nume_item),0) +1
          into v_cant 
         from come_prod_coba_deta
         where coba_prod_codi = babmc.prod_codi;
        
        insert into come_prod_coba_deta
          (coba_nume_item,
           coba_prod_codi,
           coba_desc,
           coba_tipo,
           coba_codi_barr,
           coba_medi_codi,
           coba_fact_conv,
           coba_user_regi,
           coba_fech_regi,
           coba_base)
        values
          (v_cant ,--bcoba.coba_nume_item,
           babmc.prod_codi,
           fa_pasa_capital(bcoba.coba_desc),
           bcoba.coba_tipo,
           bcoba.coba_codi_barr,
           bcoba.coba_medi_codi,
           bcoba.coba_fact_conv,
           fp_user,
           sysdate,
           babmc.prod_base);
      
      else
         
        if bcoba.coba_indi = 'U' then
          
          update come_prod_coba_deta
           set coba_desc      = fa_pasa_capital(bcoba.coba_desc),
               coba_tipo      = bcoba.coba_tipo,
               coba_codi_barr = bcoba.coba_codi_barr,
               coba_medi_codi = bcoba.coba_medi_codi,
               coba_fact_conv = bcoba.coba_fact_conv,
               coba_user_modi = fp_user,
               coba_fech_modi = sysdate,
               coba_base      = babmc.prod_base
         where coba_nume_item = bcoba.coba_nume_item
           and coba_prod_codi = babmc.prod_codi; 
          
        elsif bcoba.coba_indi = 'D' then
          --raise e_delete;
          
          delete come_prod_coba_deta
           where coba_nume_item = bcoba.coba_nume_item
             and coba_prod_codi = babmc.prod_codi;
             
        end if;
        

      end if;

    --v_cant:= v_cant +1 ;
    end loop;
    --raise_application_error(-20010, 'v_cant: ' || v_cant);

  exception
    when e_delete then
      raise_application_error(-20010, 'Borrando registro ');
    when others then
      raise_application_error(-20010, 'Error al actualizar codigo de barras!. ' || sqlerrm);
  end pp_update_cod_barras;

-----------------------------------------------
  procedure pp_update_proveedores is
    
    v_cant number;
  
  begin
  
    for bprov in cur_bprov loop
    
      /*select count(*)
        into v_cant
        from come_prod_prov_deta
       where prod_prov_nume_item = bprov.prod_prov_nume_item
         and prod_prov_prod_codi = babmc.prod_codi;*/
    
      --if v_cant <= 0 then
      if nvl(bprov.prod_indi,'S') = 'I' then
        
        select nvl(max(prod_prov_nume_item),0) +1
         into v_cant
         from come_prod_prov_deta
        where prod_prov_prod_codi = babmc.prod_codi;
        
        insert into come_prod_prov_deta
          (prod_prov_nume_item,
           prod_prov_prod_codi,
           prod_prov_clpr_codi,
           prod_prov_user_regi,
           prod_prov_fech_regi)
        values
          (v_cant,--bprov.prod_prov_nume_item,
           babmc.prod_codi,
           bprov.prod_prov_clpr_codi,
           fp_user,
           sysdate);
      else
        if bprov.prod_indi = 'U' then
          
          update come_prod_prov_deta
           set prod_prov_clpr_codi = bprov.prod_prov_clpr_codi,
               prod_prov_user_modi = fp_user,
               prod_prov_fech_modi = sysdate
         where prod_prov_nume_item = bprov.prod_prov_nume_item
           and prod_prov_prod_codi = babmc.prod_codi;
          
        elsif bprov.prod_indi = 'D' then
          
          delete come_prod_prov_deta
           where prod_prov_nume_item = bprov.prod_prov_nume_item
             and prod_prov_prod_codi = babmc.prod_codi;
             
        end if;
        
      end if;
    
    end loop;
  
  exception
    when others then
      raise_application_error(-20010,'Error al actualizar proveedores!. ' ||sqlerrm);
    
  end pp_update_proveedores;
   
-----------------------------------------------
  procedure pp_update_analisis is
    v_cant number;

  begin
    for banal in cur_banal loop
      
      /*
      select count(*)
        into v_cant
        from come_prod_tipo_anal
       where prti_prod_codi = babmc.prod_codi
         and prti_tian_codi = banal.prti_tian_codi;
    
      if nvl(v_cant,0) <= 0 then
        
      else
        
      end if;*/
      
      if nvl(banal.prti_indi,'S') = 'I' then
        
          select nvl(max(prti_tian_codi),0) + 1
          into v_cant
          from come_prod_tipo_anal
         where prti_prod_codi = babmc.prod_codi;
        
        insert into come_prod_tipo_anal
          (prti_prod_codi,
           prti_tian_codi,
           prti_base,
           prti_rang_mini,
           prti_rang_maxi,
           prti_orde)
        values
          (babmc.prod_codi,
           v_cant,--banal.prti_tian_codi,
           babmc.prod_base,
           banal.prti_rang_mini,
           banal.prti_rang_maxi,
           banal.prti_orde);
      else
        
        if banal.prti_indi = 'U' then
          
          update come_prod_tipo_anal
           set prti_base      = babmc.prod_base,
               prti_rang_mini = banal.prti_rang_mini,
               prti_rang_maxi = banal.prti_rang_maxi,
               prti_orde      = banal.prti_orde
         where prti_prod_codi = babmc.prod_codi
           and prti_tian_codi = banal.prti_tian_codi;
          
        elsif banal.prti_indi = 'D' then
          delete come_prod_tipo_anal
           where prti_prod_codi = babmc.prod_codi
             and prti_tian_codi = banal.prti_tian_codi;
        end if;
        
        
      
      end if;
    
    end loop;

  exception
    when others then
      raise_application_error(-20010,'Error al actualizar analisis!. ' || sqlerrm);

  end pp_update_analisis;

-----------------------------------------------
  procedure pp_update_componentes is

    v_cant number;

  begin

    for bcomp in cur_bcomp loop
    
      /*select count(*)
       into v_cant
       from come_prod_comp
      where comp_nume_item = bcomp.comp_nume_item
        and comp_prod_codi = babmc.prod_codi;
    
      
      if v_cant <= 0 then*/
      if nvl(bcomp.comp_indi,'S') = 'I' then
        
        select nvl(max(comp_nume_item),0) +1
         into v_cant
         from come_prod_comp
        where comp_prod_codi = babmc.prod_codi;

        insert into come_prod_comp
          (comp_nume_item, comp_prod_codi, comp_desc, comp_base)
        values
          (v_cant,--bcomp.comp_nume_item,
           babmc.prod_codi,
           bcomp.comp_desc,
           babmc.prod_base);
      
      else
        if bcomp.comp_indi = 'U' then
          update come_prod_comp
           set comp_desc = bcomp.comp_desc, 
               comp_base = bcomp.comp_base
         where comp_nume_item = bcomp.comp_nume_item
           and comp_prod_codi = babmc.prod_codi;
          
        elsif bcomp.comp_indi = 'D' then
          delete come_prod_comp
           where comp_nume_item = bcomp.comp_nume_item
             and comp_prod_codi = babmc.prod_codi;
          
          
        end if;
        
      end if;
    
    end loop;

  exception
    when others then
      raise_application_error(-20010, 'Error al actualizar componentes!. ' || sqlerrm);
    
  end pp_update_componentes;

-----------------------------------------------
  procedure pp_update_img is
    v_cant number;
  begin

    for babmc_imag in cur_babmc_imag loop
    /*
      select count(*)
       into v_cant
       from come_prod_imag
      where prim_prod_codi = babmc.prod_codi
       and prim_nume_item = babmc_imag.prim_nume_item;
    
      if v_cant <= 0 then*/
      if nvl(babmc_imag.indi_img,'S') = 'I' then
        
        select nvl(max(prim_nume_item),0) + 1
         into v_cant
         from come_prod_imag
        where prim_prod_codi = babmc.prod_codi;

        insert into come_prod_imag
          (prim_prod_codi, prim_nume_item, prim_imag, prim_fech)
        values
          (babmc.prod_codi,
           v_cant,--babmc_imag.prim_nume_item,
           babmc_imag.prim_imag,
           sysdate);
      
      else
        if babmc_imag.indi_img = 'U' then
          update come_prod_imag
             set prim_imag = babmc_imag.prim_imag, prim_fech = sysdate
           where prim_prod_codi = babmc.prod_codi
             and prim_nume_item = babmc_imag.prim_nume_item;
             
        elsif babmc_imag.indi_img = 'D' then
          delete come_prod_imag
           where prim_prod_codi = babmc.prod_codi
             and prim_nume_item = babmc_imag.prim_nume_item;
        end if;
      
      end if;
    
    end loop;

  exception
    when others then
      raise_application_error(-20010,'Error al actualizar imagen!. ' || sqlerrm);
    
  end pp_update_img;

-----------------------------------------------
  procedure pp_update_registros is
    
  begin
    babmc.prod_base := parameter.p_codi_base;  

    if nvl(babmc.prod_indi_lote, 'N') = 'N' then
      if babmc.prod_codi is not null then
        declare
          v_count number;
        begin
          select count(*)
            into v_count
            from come_prod_depo_lote d, come_lote l
           where d.prde_lote_codi = l.lote_codi
             and l.lote_desc <> '000000'
             and l.lote_obse <> 'Lote Generico'
             and d.prde_cant_actu <> 0
             and d.prde_prod_codi = babmc.prod_codi;
          if v_count > 0 then
            babmc.prod_indi_lote := 'S';
            raise_application_error(-20010,'El producto posee existencias en sus lotes. '|| 'Debe dejarlos en cero para realizar este cambio');
          end if;
        end;
      end if;
    end if;

    babmc.prod_user_modi := fp_user;
    babmc.prod_fech_modi := sysdate;
    
    update come_prod
       set --prod_codi = v_prod_codi,               
           prod_clas1                    = babmc.prod_clas1,
           prod_clas2                    = babmc.prod_clas2,
           prod_desc                     = babmc.prod_desc,
           prod_maxi_porc_desc           = babmc.prod_maxi_porc_desc,
           prod_obse                     = babmc.prod_obse,
           prod_desc_exte                = babmc.prod_desc_exte,
           prod_exis_min                 = babmc.prod_exis_min,
           prod_clco_codi                = babmc.prod_clco_codi,
           prod_clpr_codi                = babmc.prod_clpr_codi,
           prod_codi_fabr                = babmc.prod_codi_fabr,
           prod_impu_codi                = babmc.prod_impu_codi,
           prod_marc_codi                = babmc.prod_marc_codi,
           prod_medi_codi                = babmc.prod_medi_codi,
           prod_indi_inac                = babmc.prod_indi_inac,
           prod_clre_codi                = babmc.prod_clre_codi,
           prod_tipo                     = babmc.prod_tipo,
           prod_fact_conv                = babmc.prod_fact_conv,
           prod_indi_kitt                = babmc.prod_indi_kitt,
           prod_cas                      = babmc.prod_cas,
           prod_htsn                     = babmc.prod_htsn,
           prod_indi_fact_sub_cost       = babmc.prod_indi_fact_sub_cost,
           prod_peso_kilo                = babmc.prod_peso_kilo,
           prod_imag_desc                = babmc.prod_imag_desc,
           prod_anch_pulg                = babmc.prod_anch_pulg,
           prod_alto_pulg                = babmc.prod_alto_pulg,
           prod_medi_alte_equi           = babmc.prod_medi_alte_equi,
           prod_nume_orde                = babmc.prod_nume_orde,
           prod_packaging                = babmc.prod_packaging,
           prod_espe                     = babmc.prod_espe,
           prod_indi_lote                = babmc.prod_indi_lote,
           prod_prod_aro_codi            = babmc.prod_prod_aro_codi,
           prod_prod_medi_codi           = babmc.prod_prod_medi_codi,
           prod_prop_ship_name           = babmc.prod_prop_ship_name,
           prod_peli_clas                = babmc.prod_peli_clas,
           prod_peli_pack_grou           = babmc.prod_peli_pack_grou,
           prod_peli_un                  = babmc.prod_peli_un,
           prod_tunn_rest                = babmc.prod_tunn_rest,
           prod_ems                      = babmc.prod_ems,
           prod_mari_poll                = babmc.prod_mari_poll,
           prod_chem_name                = babmc.prod_chem_name,
           prod_nume_ec                  = babmc.prod_nume_ec,
           prod_reac_regi                = babmc.prod_reac_regi,
           prod_haza_simb                = babmc.prod_haza_simb,
           prod_risk_phra                = babmc.prod_risk_phra,
           prod_haza_stat                = babmc.prod_haza_stat,
           prod_prec_stat                = babmc.prod_prec_stat,
           prod_porc_reca                = babmc.prod_porc_reca,
           prod_prod_base_codi           = babmc.prod_prod_base_codi,
           prod_indi_envi_bala           = babmc.prod_indi_envi_bala,
           prod_coso_codi                = babmc.prod_coso_codi,
           prod_indi_kitt_list_prec_comp = babmc.prod_indi_kitt_list_prec_comp,
           prod_indi_rota                = babmc.prod_indi_rota,
           prod_indi_fuera_linea         = babmc.prod_indi_fuera_linea,
           prod_user_modi                = babmc.prod_user_modi,
           prod_fech_modi                = babmc.prod_fech_modi,
           prod_indi_venc_lote           = babmc.prod_indi_venc_lote,
           prod_indi_iccid_lote_obli     = babmc.prod_indi_iccid_lote_obli,
           prod_indi_lote_nume_tele      =babmc.prod_indi_lote_nume_tele
     where prod_codi = babmc.prod_codi;
    
    
    --ACTUALIZA CODIGO DE BARRAS
     pp_update_cod_barras;
     
     --ACTUALIZA PROVEEDORES
     pp_update_proveedores;
     
     --ACTUALIZA ANALISIS
     pp_update_analisis;
     
     --ACTUALIZA COMPONENTES
     pp_update_componentes;
     
     --ACTUALIZA IMAGEN
     pp_update_img;
     
    --apex_application.g_print_success_message :='Registro actualizado correctamente!';
    
  end pp_update_registros; 
  
-----------------------------------------------
  PROCEDURE PP_ACTUALIZAR_REGISTRO IS
  BEGIN
    
    pp_cargar_item;
    pp_validar_items_nulos;
    
    
    babmc.prod_desc := rtrim(ltrim(babmc.prod_desc));
    
    --raise_application_error(-20010,'');
    --raise_application_error(-20010,'parameter.p_indi_consulta : '||parameter.p_indi_consulta );
    
    if babmc.prod_tipo is null then
      raise_application_error(-20010,'Debe indicar el Tipo de Producto!');
    end if;
    
    if babmc.prod_prod_base_codi is not null then
      if babmc.prod_tipo is null or babmc.prod_tipo not in ('P', 'U') then
        raise_application_error(-20010,'Se asigno una Seccion de Balanza, codigo generado!! Debe cancelar la operacion !');
      end if;
    end if;
    
    if babmc.prod_tipo in ('P', 'U') then
      if babmc.prod_prod_base_codi is null then
        raise_application_error(-20010,'El producto es Tipo Pesable o Por Unidad!. Debe asignarle una Seccion de Balanza');
      end if;
    end if;
        
    if bcoba_princ.coba_prod_codi is not null then
      bcoba_princ.coba_desc := babmc.prod_desc;
      bcoba_princ.coba_medi_codi := babmc.prod_medi_codi;
    end if;

    pp_valida_fact_conv; --revisar       
    pp_valida_prod_codi;
    pp_validar_inac;
    
/*    
    if parameter.p_indi_consulta = 'N' then 
      pp_nuevo_codigo_barra;
    end if;
    
    pp_validar_repeticion('coba');
    pp_vali_codi_barr;
    pp_validar_repeticion('faco');    
    pp_validar_repeticion('medi');    
    pp_validar_repeticion_um_fc;
*/    
    
    pp_veri_abre_clas1;
    pp_vali_carac;
    --pp_actualiza_prod_prov_clpr;
        
    --pp_reenumerar_nro_item;
    
    if parameter.p_indi_consulta = 'N' then
      pp_insertar_registros;
    else
      pp_update_registros;
    end if;

  END PP_ACTUALIZAR_REGISTRO;
  
-----------------------------------------------
  PROCEDURE pp_valida_fact_conv_coll(coba_codi_barr in varchar2,
                                     coba_desc      in varchar2,
                                     coba_fact_conv in number,
                                     coba_medi_codi in number,
                                     coba_tipo      in number) IS
  BEGIN

    if coba_codi_barr is not null then
      if coba_desc is null then
        raise_application_error(-20010,'Debe ingresar Descripcion de codigo de barra!');
      end if;
      if coba_fact_conv is null or coba_fact_conv <= 0 then
        raise_application_error(-20010,'El factor de conversion debe ser mayor a cero!');
      end if;
    end if;
    if coba_fact_conv is not null and coba_medi_codi is null then
      raise_application_error(-20010,'Debe ingresar una unidad de medida para el Factor de Conversion!');
    end if;

    if coba_codi_barr is null and
       (coba_desc is not null or coba_tipo is not null) then
      raise_application_error(-20010,'Debe ingresar ingresar un codigo de barras a la descripcion!');
    end if;

  END pp_valida_fact_conv_coll;

-----------------------------------------------
  PROCEDURE pp_vali_codi_barr_coll(i_coba_codi_barr in varchar2,
                                   i_coba_nume_item in number,
                                   i_prod_empr_codi in number,
                                   i_prod_codi      in number
                                   ) IS
    v_count     number:=0;
    v_arti      varchar2(20);
    v_arti_desc varchar2(80);
  BEGIN

    if i_coba_nume_item  is null then
      raise_application_error(-20010, 'El numero del item no puede ser nulo!');
    end if;
    
    select count(*)
      into v_count
      from come_prod_coba_deta c, come_prod p
     where c.coba_prod_codi = p.prod_codi
       and c.coba_codi_barr = i_coba_codi_barr
       and p.prod_empr_codi = i_prod_empr_codi
       and ((p.prod_codi = i_prod_codi and
           c.coba_nume_item <> i_coba_nume_item) or
           (p.prod_codi <> i_prod_codi));

    if v_count > 0 then
      begin
        select p.prod_codi_alfa, p.prod_desc
          into v_arti, v_arti_desc
          from come_prod_coba_deta c, come_prod p
         where c.coba_prod_codi = p.prod_codi
           and c.coba_codi_barr = i_coba_codi_barr
           and p.prod_empr_codi = i_prod_empr_codi
           and ((p.prod_codi = i_prod_codi and
               c.coba_nume_item <> i_coba_nume_item) or
               (p.prod_codi <> i_prod_codi));
        raise_application_error(-20010, 'Este codigo de barra ya ha sido asignado al articulo ' ||
                                v_arti || '(' || v_arti_desc || ').');
      exception
        when too_many_rows then
          raise_application_error(-20010, 'Este codigo de barras ha sido asignado a varios articulos!');
      end;
    end if;
    

  EXCEPTION

    when no_data_found then
      null;
    when others then
      raise_application_error(-20010, 'Error al Validar Codigo de Barras!' || sqlerrm);
    
  END pp_vali_codi_barr_coll;

-----------------------------------------------
  procedure pp_validar_repeticion_coll(p_indi in varchar2,
                                       v_bcoba in varchar2) is
                                       
    v_cant_reg number; --cantidad de registros en el bloque
    salir      exception;
    v_ant_art  varchar2(30);
    v_cant     number := 0;
  begin

    if p_indi = 'coba' then
      -- codigo de barra
      v_ant_art := v_bcoba;
    elsif p_indi = 'faco' then
      --factor de conversion
      v_ant_art := v_bcoba;
    elsif p_indi = 'medi' then
      --unidad de medida
      v_ant_art := v_bcoba;
    end if;

    if p_indi = 'coba' then
        
      select count(*)
        into v_cant
        from apex_collections a
       where a.collection_name = 'COLL_BCOBA'
         and a.c005 = v_ant_art;
       
      if v_cant > 0 then
        raise_application_error(-20010, 'El codigo de Barras del item se repite. Asegurese de no introducir mas de una vez el mismo codigo!');
      end if;
    
    elsif p_indi = 'faco' then
      select count(*)
        into v_cant
        from apex_collections a
       where a.collection_name = 'COLL_BCOBA'
         and a.c007 = v_ant_art;
      if v_cant <> 1 then
        null;
      end if;    
    
    elsif p_indi = 'medi' then
      select count(*)
        into v_cant
        from apex_collections a
       where a.collection_name = 'COLL_BCOBA'
         and a.c006 = v_ant_art;
      if v_cant <> 1 then
        null;
      end if;
    
    end if;
    
  exception
    when salir then
      null;
  end pp_validar_repeticion_coll;

-----------------------------------------------
  procedure pp_validar_repeticion_coll_up(p_indi    in varchar2,
                                          v_bcoba   in varchar2,
                                          nume_item in varchar2) is

    v_cant_reg number; --cantidad de registros en el bloque
    salir      exception;
    v_ant_art  varchar2(30);
    v_cant     number := 0;
  begin

    if p_indi = 'coba' then
      -- codigo de barra
      v_ant_art := v_bcoba;
    elsif p_indi = 'faco' then
      --factor de conversion
      v_ant_art := v_bcoba;
    elsif p_indi = 'medi' then
      --unidad de medida
      v_ant_art := v_bcoba;
    end if;

    if p_indi = 'coba' then
    
      select count(*)
        into v_cant
        from apex_collections a
       where a.collection_name = 'COLL_BCOBA'
         and a.c005 = v_ant_art
         and a.c001 not in nume_item;
    
      if v_cant > 0 then
        raise_application_error(-20010,
                                'El codigo de Barras del item se repite. Asegurese de no introducir mas de una vez el mismo codigo!');
      end if;
    
    elsif p_indi = 'faco' then
      select count(*)
        into v_cant
        from apex_collections a
       where a.collection_name = 'COLL_BCOBA'
         and a.c007 = v_ant_art
         and a.c001 not in nume_item;
      if v_cant <> 1 then
        null;
      end if;
    
    elsif p_indi = 'medi' then
      select count(*)
        into v_cant
        from apex_collections a
       where a.collection_name = 'COLL_BCOBA'
         and a.c006 = v_ant_art
         and a.c001 not in nume_item;
    
      if v_cant <> 1 then
        null;
      end if;
    
    end if;

  exception
    when salir then
      null;
  end pp_validar_repeticion_coll_up;

-----------------------------------------------
  procedure pp_validar_repet_um_fc_coll(coba_medi_codi in number,
                                        coba_fact_conv in number,
                                        coba_nume_item in number) is

    --i          number;
    --j          number;
    salir exception;
    --v_medi_ante number;
    --v_faco_ante number;

    v_cant_medi number;
    v_cant_faco number;

  begin

    --v_medi_ante := :bcoba_princ.coba_medi_codi;
    --v_faco_ante := :bcoba_princ.coba_fact_conv;

    select count(*)
      into v_cant_medi
      from apex_collections a
     where a.collection_name = 'COLL_BCOBA'
       and a.c006 = coba_medi_codi
       and a.seq_id <> coba_nume_item;

    --if v_medi_ante = :bcoba.coba_medi_codi then
    if v_cant_medi >= 1 then
      select count(*)
        into v_cant_faco
        from apex_collections a
       where a.collection_name = 'COLL_BCOBA'
         and a.c007 = coba_fact_conv
         and a.seq_id <> coba_nume_item;
    
      --if v_faco_ante <> :bcoba.coba_fact_conv then
      if v_cant_faco <> 1 then
        raise_application_error(-20010, 'El FC y UM del item se repite. Asegurese de no introducir mas de una vez el mismo codigo!');
      end if;
    end if;

  exception
    when salir then
      null;
  end pp_validar_repet_um_fc_coll;

-----------------------------------------------
  procedure pp_gene_codi_barr_pesa_unid_2(i_prod_prod_base_codi in number,
                                          i_coba_tipo           in number,
                                          o_coba_codi_barr      out number) is
    v_rang_desd number;
    v_rang_hast number;
    v_codi_barr number;
    v_indi      varchar2(1) := 'N';
  begin
    babmc.prod_prod_base_codi := i_prod_prod_base_codi;
    bcoba.coba_tipo           := i_coba_tipo;

    begin
      select prod_base_rang_desd, prod_base_rang_hast
        into v_rang_desd, v_rang_hast
        from come_prod_bala_secc
       where prod_base_codi = babmc.prod_prod_base_codi;
    exception
      when no_data_found then
        v_rang_desd := 1;
        v_rang_hast := 9999;
      when too_many_rows then
        raise_application_error(-20010,
                                'Codigo de seccion de balanza duplicado');
    end;

    begin
      select substr(min(cb.coba_codi_barr), 3, length(min(cb.coba_codi_barr)))
        into v_codi_barr
        from come_prod_coba_deta cb, come_prod p
       where cb.coba_tipo in (7, 9)
         and cb.coba_prod_codi = p.prod_codi
         and substr(cb.coba_codi_barr, 3, length(cb.coba_codi_barr)) between
             v_rang_desd and v_rang_hast;
    exception
      when no_data_found then
        v_codi_barr := v_rang_desd;
        v_indi      := 'S';
      when too_many_rows then
        raise_application_error(-20010,
                                'Rango de seccion de balanza duplicado');
    end;

    while v_indi = 'N' loop
      begin
        select substr(cb.coba_codi_barr, 3, length(cb.coba_codi_barr)) + 1
          into v_codi_barr
          from come_prod_coba_deta cb, come_prod p
         where cb.coba_tipo in (7, 9)
           and cb.coba_prod_codi = p.prod_codi
           and substr(cb.coba_codi_barr, 3, length(cb.coba_codi_barr)) =
               v_codi_barr;
      exception
        when no_data_found then
          v_indi := 'S';
        when too_many_rows then
          v_codi_barr := v_codi_barr + 1;
        
      end;
    
      if v_codi_barr > v_rang_hast then
        raise_application_error(-20010,
                                'La numeracion para la Seccion de Balanza seleccionado ha superado en rango asignado, desde: ' ||
                                v_rang_desd || ', hasta: ' || v_rang_hast ||
                                ', favor verifique!');
      end if;
    end loop;

    if bcoba.coba_tipo = 7 then
      bcoba.coba_codi_barr := parameter.p_indi_prod_pesa ||
                              lpad(v_codi_barr, 4, 0);
    else
      bcoba.coba_codi_barr := parameter.p_indi_prod_unid ||
                              lpad(v_codi_barr, 4, 0);
    end if;
    
    o_coba_codi_barr := bcoba.coba_codi_barr;

  end pp_gene_codi_barr_pesa_unid_2;

-----------------------------------------------
  procedure pp_validar_coba_barra(i_prod_prod_base_codi in number,
                                  i_coba_tipo           in number
                                  ) is

  v_coba_codi_barr number;
  
  begin

    babmc.prod_prod_base_codi := i_prod_prod_base_codi; --P72_PROD_PROD_BASE_CODI
    bcoba.coba_tipo           := i_coba_tipo; --P72_COBA_TIPO

    --return bcoba.coba_codi_barr
    --raise_application_error(-20010,'bcoba.coba_tipo: '||bcoba.coba_tipo);

    if bcoba.coba_tipo in (7, 9) then
      if babmc.prod_prod_base_codi is not null then
        pp_gene_codi_barr_pesa_unid_2(babmc.prod_prod_base_codi,
                                      bcoba.coba_tipo,
                                      v_coba_codi_barr);
      else
        raise_application_error(-20010,'El producto no posee una seccion de balanza');
      end if;
    end if;

  end pp_validar_coba_barra;

-----------------------------------------------
  procedure pp_cargar_item_bcoba(coba_codi_barr in varchar2,
                                 coba_desc      in varchar2,
                                 coba_fact_conv in number,
                                 coba_medi_codi in number,
                                 coba_tipo      in number,
                                 prod_empr_codi in number,
                                 prod_codi      in number,
                                 medi_desc_abre in varchar2) is
  
    v_cant           number;
    v_coba_nume_item number;
    v_max_nume_item  number;
  begin
  
    if coba_desc is null then
     raise_application_error(-20010,'Debe ingresar una Descripcion para el codigo de barras!'); 
    end if;
    
    if coba_codi_barr is null then
      raise_application_error(-20010,'Debe ingresar un Codigo de Barras a la descripcion!');
    end if;
    
    if coba_medi_codi is null then
      raise_application_error(-20010,'Debe ingresar una unidad de medida para el Factor de Conversion!');
    end if;
    
    if nvl(coba_fact_conv,0) = 0 then
      raise_application_error(-20010,'El Factor de Conversipn debe ser mayora cero!');
    end if;
    
    if not apex_collection.collection_exists(parameter.coll_name1) then
      apex_collection.create_collection(parameter.coll_name1);
    end if;
  
    pp_valida_fact_conv_coll(coba_codi_barr,
                             coba_desc,
                             coba_fact_conv,
                             coba_medi_codi,
                             coba_tipo);
  
    select count(*)
      into v_cant
      from apex_collections a
     where a.collection_name = 'COLL_BCOBA';
  
    --raise_application_error(-20010,'cant: '||v_cant);
    if v_cant > 0 then
    
      select max(to_number(c001)) + 1
        into v_max_nume_item
        from apex_collections a
       where a.collection_name = 'COLL_BCOBA';
    
      pp_validar_repeticion_coll('coba', coba_codi_barr);
      pp_validar_repeticion_coll('faco', coba_fact_conv);
      pp_validar_repeticion_coll('medi', coba_medi_codi);
      pp_validar_repet_um_fc_coll(coba_medi_codi, coba_fact_conv,v_max_nume_item);
      
      pp_vali_codi_barr_coll(coba_codi_barr,
                             v_max_nume_item,
                             prod_empr_codi,
                             prod_codi);
    else
      v_max_nume_item := 1;
      pp_vali_codi_barr_coll(coba_codi_barr,
                             v_max_nume_item,
                             prod_empr_codi,
                             prod_codi);
    end if;
  
    apex_collection.add_member(p_collection_name => parameter.coll_name1,
                               p_c001            => v_max_nume_item, --coba_nume_item,
                               --p_c002 => coba_prod_codi,                                
                               p_c003 => coba_desc,
                               p_c004 => coba_tipo,
                               p_c005 => coba_codi_barr,
                               p_c006 => coba_medi_codi,
                               p_c007 => coba_fact_conv,
                               /*p_c008 => fp_user,-- coba_user_regi,
                               p_c009 => sysdate, --coba_fech_regi
                               p_c010 => coba_user_modi,
                               p_c011 => coba_fech_modi,*/
                               p_c012 => medi_desc_abre,
                               p_c013 => 'I');

  
  end pp_cargar_item_bcoba;

-----------------------------------------------
  procedure pp_update_item_bcoba(coba_codi_barr in varchar2,
                                 coba_desc      in varchar2,
                                 coba_fact_conv in number,
                                 coba_medi_codi in number,
                                 coba_tipo      in number,
                                 prod_empr_codi in number,
                                 prod_codi      in number,
                                 medi_desc_abre in varchar2,
                                 coba_nume_item in varchar2,
                                 coll_seq       in number,
                                 coba_prod_codi in varchar2,
                                 i_indi_coba    in varchar2) is

  v_indi_coba varchar2(2);
  
  begin

    if coba_desc is null then
     raise_application_error(-20010,'Debe ingresar una Descripcion para el codigo de barras!'); 
    end if;
        
    if coba_codi_barr is null then
      raise_application_error(-20010,'Debe ingresar un Codigo de Barras a la descripcion!');
    end if;
        
    if coba_medi_codi is null then
      raise_application_error(-20010,'Debe ingresar una unidad de medida para el Factor de Conversion!');
    end if;
        
    if nvl(coba_fact_conv,0) = 0 then
      raise_application_error(-20010,'El Factor de Conversipn debe ser mayora cero!');
    end if;

    pp_valida_fact_conv_coll(coba_codi_barr,
                             coba_desc,
                             coba_fact_conv,
                             coba_medi_codi,
                             coba_tipo);


    pp_validar_repeticion_coll_up('coba', coba_codi_barr,coba_nume_item);
    pp_validar_repeticion_coll_up('faco', coba_fact_conv,coba_nume_item);
    pp_validar_repeticion_coll_up('medi', coba_medi_codi,coba_nume_item);
    --
    /*pp_validar_repeticion_coll('coba', coba_codi_barr);
    pp_validar_repeticion_coll('faco', coba_fact_conv);
    pp_validar_repeticion_coll('medi', coba_medi_codi);*/
    pp_validar_repet_um_fc_coll(coba_medi_codi, coba_fact_conv,coll_seq);

    pp_vali_codi_barr_coll(coba_codi_barr,
                           coba_nume_item,
                           prod_empr_codi,
                           prod_codi);

    select c013
      into v_indi_coba
      from apex_collections a
     where a.collection_name = 'COLL_BCOBA'
       and a.seq_id = coll_seq;
    
    if nvl(v_indi_coba,'U') = 'I' then
      v_indi_coba := 'I';
    else
      v_indi_coba := 'U';
    end if;
    
    apex_collection.update_member(p_collection_name => parameter.coll_name1,
                                  p_seq             => coll_seq,
                                  p_c001 => coba_nume_item,
                                  p_c002 => coba_prod_codi,
                                  p_c003 => coba_desc,
                                  p_c004 => coba_tipo,
                                  p_c005 => coba_codi_barr,
                                  p_c006 => coba_medi_codi,
                                  p_c007 => coba_fact_conv,
                                  p_c012 => medi_desc_abre,
                                  p_c013 => v_indi_coba--i_indi_coba
                                  );

  end pp_update_item_bcoba;
  
-----------------------------------------------
  procedure pp_delete_item_bcoba(coll_seq       in number,
                                 i_indi_coba    in varchar2,
                                 i_coba_nume_item in number) is
                                 
  v_indi_coba varchar2(2);
  e_indi exception;
  begin

    if coll_seq = 1 then
      raise e_indi;
    else
      select nvl(c013,'S') coba_indi
       into v_indi_coba
       from apex_collections det
        where det.collection_name= parameter.coll_name1
          and det.seq_id = coll_seq;
      
      --raise_application_error(-20010,'v_indi_coba: '||v_indi_coba);
      
      if v_indi_coba = 'I' then
        apex_collection.delete_member(p_collection_name => parameter.coll_name1,
                                                  p_seq => coll_seq);
      else
        apex_collection.update_member(p_collection_name => parameter.coll_name1,
                                      p_seq             => coll_seq,
                                      p_c013            => i_indi_coba,
                                      p_c001            => i_coba_nume_item);
      end if;    
    end if;
                                  
  exception
    when e_indi then
      raise_application_error(-20010,'No se puede eliminar el codigo de barras por defecto! Solo se podra editar!');
    when others then
      raise_application_error(-20010,'Error al intentar borrar el Codigo de Barras! ');--||v_indi_coba ||';'||i_indi_coba
    
  end pp_delete_item_bcoba;
  
-----------------------------------------------
  procedure pp_cargar_item_bprov(i_prov_clpr_codi in number,
                                 i_prov_clpr_desc in varchar2) is
    
    v_cant number;
    v_max_nume_item number;
    v_prov_clpr_desc varchar2(2000);
  
  begin
    
    if i_prov_clpr_codi is null then
      raise_application_error(-20010,'Debe de seleccionar un proveedor!');
    end if;
    
    if i_prov_clpr_desc is null then
      pp_validar_prov_prov(i_prov_clpr_codi,v_prov_clpr_desc);
    else
      v_prov_clpr_desc := i_prov_clpr_desc;
    end if;
    
    if not apex_collection.collection_exists(parameter.coll_name2) then
      apex_collection.create_collection(parameter.coll_name2);
    end if;
    
     select count(*)
      into v_cant
      from apex_collections a
     where a.collection_name = parameter.coll_name2;
  
    if v_cant > 0 then
    
      select max(to_number(c001)) + 1
        into v_max_nume_item
        from apex_collections a
       where a.collection_name = parameter.coll_name2;
    
    else
      v_max_nume_item := 1;
    end if;
    
    apex_collection.add_member(p_collection_name => parameter.coll_name2,
                               p_c001            => v_max_nume_item,
                               --p_c002 => prod_prov_prod_codi,
                               p_c003 => i_prov_clpr_codi,
                               /*p_c004 => prod_prov_user_regi,
                               p_c005 => prod_prov_fech_regi,
                               p_c006 => prod_prov_user_modi,
                               p_c007 => prod_prov_fech_modi*/
                               p_c008 => v_prov_clpr_desc,--i_prov_clpr_desc
                               p_c009 => 'I'
                               );
    
  end pp_cargar_item_bprov;

-----------------------------------------------
  procedure pp_update_item_bprov(i_prov_clpr_codi      in number,
                                 i_prov_clpr_desc      in varchar2,
                                 coll_seq              in number,
                                 i_prod_prov_prod_codi in varchar2,
                                 i_prod_prov_nume_item in varchar2,
                                 i_prod_indi           in varchar2) is

    v_prod_indi varchar2(2);

  begin

    if i_prov_clpr_codi is null then
      raise_application_error(-20010, 'Debe de seleccionar un proveedor!');
    end if;
    
    select c009
      into v_prod_indi
      from apex_collections a
     where a.collection_name = parameter.coll_name2
       and a.seq_id = coll_seq;

    if nvl(v_prod_indi,'U') = 'I' then
      v_prod_indi := 'I';
    else
      v_prod_indi := 'U';
    end if;
    
    apex_collection.update_member(p_collection_name => parameter.coll_name2,
                                  p_seq             => coll_seq,
                                  p_c001            => i_prod_prov_nume_item,
                                  p_c002            => i_prod_prov_prod_codi,
                                  p_c003            => i_prov_clpr_codi,
                                  p_c008            => i_prov_clpr_desc,
                                  p_c009            => v_prod_indi--i_prod_indi
                                  );

  end pp_update_item_bprov;
  
-----------------------------------------------
  procedure pp_delete_item_bprov(coll_seq              in number,
                                 i_prod_indi           in varchar2,
                                 i_prov_nume_item      in number
                                 ) is

    
    v_prod_indi     varchar2(2);

  begin

    select nvl(c009,'S') prod_indi
      into v_prod_indi 
      from apex_collections det
      where det.collection_name= parameter.coll_name2
        and det.seq_id= coll_seq;
  
  
    if v_prod_indi = 'I' then
      apex_collection.delete_member(p_collection_name => parameter.coll_name2,
                                                p_seq => coll_seq);
    else
      apex_collection.update_member(p_collection_name => parameter.coll_name2,
                                  p_seq             => coll_seq,
                                  p_c001            => i_prov_nume_item,
                                  p_c009            => i_prod_indi
                                  );
    end if;
    

  exception
    when others then
    raise_application_error(-20010,'Error al intentar borrar el Proveedor!');
  end pp_delete_item_bprov;

-----------------------------------------------
  procedure pp_cargar_item_img (p_img in varchar2)is
    v_cant number;
    v_nume_item number;
    v_archivo blob;
  begin
     
     if not apex_collection.collection_exists(parameter.coll_name5) then
       apex_collection.create_collection(parameter.coll_name5);
     else
       null;
     end if;
      
     select count(*)
      into v_cant
      from apex_collections a
     where a.collection_name = parameter.coll_name5;
     
    if v_cant > 0 then
      
      select max(to_number(c002))+1
        into v_nume_item
        from apex_collections a
       where a.collection_name = parameter.coll_name5;
    else
      v_nume_item := 1;
    end if;
    
    begin
      select blob_content --, mime_type, filename
        into v_archivo --,v_mime_type, v_filename
        from apex_application_temp_files a
       where a.name = p_img
         and rownum = 1;
    exception
      when others then
        null;
        --raise_application_error(-20010,'Error al cargar Imagen!');
    end;
    
    if v_archivo is null then
      raise_application_error(-20010,'Debe de seleccionar una Imagen!');
    end if;
    --raise_application_error(-20010,'v_nume_item = '||v_nume_item);
    
    apex_collection.add_member(p_collection_name => parameter.coll_name5,
                             --p_c001 => prim_prod_codi, 
                             p_c002 => v_nume_item, 
                             p_blob001 => v_archivo,
                             --,p_c004 => prim_fech
                             p_c005    => 'I'
                             ); 
  
  exception
     when others then
        raise_application_error(-20010,'Error al cargar Imagen!');  
  end pp_cargar_item_img;
  
-----------------------------------------------
  procedure pp_update_item_img(p_img          in varchar2,
                               prim_prod_codi in varchar2,
                               prim_nume_item in varchar2,
                               coll_seq       in number,
                               i_indi_img     in varchar2) is
    v_cant      number;
    v_nume_item number;
    v_archivo   blob;
    v_indi_img varchar2(2);
  begin

    begin
      select blob_content --, mime_type, filename
        into v_archivo --,v_mime_type, v_filename
        from apex_application_temp_files a
       where a.name = p_img
         and rownum = 1;
    exception
      when others then
        null;
    end;

    select c005
      into v_indi_img
      from apex_collections a
     where a.collection_name = parameter.coll_name5
     and a.seq_id = coll_seq;
     
    if nvl(v_indi_img,'U') = 'I' then
      v_indi_img :='I';
    else
      v_indi_img := 'U';
    end if;
     
    apex_collection.update_member(p_collection_name => parameter.coll_name5,
                                  p_seq             => coll_seq,
                                  p_c001            => prim_prod_codi,
                                  p_c002            => prim_nume_item,
                                  p_blob001         => v_archivo,
                                  p_c005            => v_indi_img--i_indi_img
                                  --,p_c004 => prim_fech
                                  );

  end pp_update_item_img;
  
-----------------------------------------------
  procedure pp_delete_item_img(coll_seq       in number,
                               i_indi_img     in varchar2,
                               i_prim_nume_item in number) is
    v_i_indi_img varchar2(2);
  begin

    select nvl(c005,'S') indi_img    
      into v_i_indi_img
      from apex_collections det
     where det.collection_name = parameter.coll_name5
       and det.seq_id = coll_seq;
    
    
    if v_i_indi_img = 'I' then
      apex_collection.delete_member(p_collection_name => parameter.coll_name5,
                                                p_seq => coll_seq);
    else
      apex_collection.update_member(p_collection_name => parameter.coll_name5,
                                  p_seq             => coll_seq,
                                  p_c002            => i_prim_nume_item,
                                  p_c005            => i_indi_img
                                  );
    end if;
    

  end pp_delete_item_img;

-----------------------------------------------
  procedure pp_validar_tipo_anal(p_codi in number,
                                 p_desc out varchar2) is
    
  begin

    Select tian_desc
      into p_desc
      from come_tipo_anal
     where tian_codi = p_codi;

  Exception
    when no_data_found then
      raise_application_error(-20010, 'Tipo de Analisis Inexistente');
    when others then
      raise_application_error(-20010,'Error al validar Tipo de analisis.! ' ||sqlerrm);
  end pp_validar_tipo_anal;

-----------------------------------------------
  procedure pp_validar_analisis_coll(i_prti_tian_codi in number) is
    v_cant number;
  begin
    
    select count(*)
        into v_cant
        from apex_collections a
       where a.collection_name = parameter.coll_name3
         and a.c002 = i_prti_tian_codi;
    
    if v_cant >= 1 then
      raise_application_error(-20010,'El codigo del Tipo de Analisis del item se repite. Asegurese de no introducir mas de una vez el mismo codigo!');
    end if;
    
  end pp_validar_analisis_coll;
  
-----------------------------------------------
    procedure pp_validar_analisis_coll_up(i_prti_tian_codi in number,
                                          coll_seq         in number
                                          ) is
      v_cant number:=0;
    begin
      
      select count(*)
          into v_cant
          from apex_collections a
         where a.collection_name = parameter.coll_name3
           and to_number(a.c002) = i_prti_tian_codi
           and a.seq_id <> coll_seq;
      
      
      if v_cant >= 1 then
        raise_application_error(-20010,'El codigo del Tipo de Analisis del item se repite. Asegurese de no introducir mas de una vez el mismo codigo!');
      end if;
      
    end pp_validar_analisis_coll_up;
    
-----------------------------------------------
  procedure pp_cargar_item_banal(i_prti_tian_codi in number,
                                 i_prti_rang_mini in varchar2,
                                 i_prti_rang_maxi in varchar2,
                                 i_prti_orde      in number,
                                 i_tian_desc      in varchar2
                                 ) is
    
    v_cant number;
    
  begin
    
    if i_prti_tian_codi is null then
      raise_application_error(-20010, 'Debe de seleccionar un Tipo de Analisis!');
    end if;
    
    if not apex_collection.collection_exists(parameter.coll_name3) then
      apex_collection.create_collection(parameter.coll_name3);
    end if;
    
    pp_validar_analisis_coll(i_prti_tian_codi);
    
    apex_collection.add_member(p_collection_name => parameter.coll_name3,
                               --p_c001 => prti_prod_codi, 
                               p_c002 => i_prti_tian_codi, 
                               --p_c003 => prti_base, 
                               p_c004 => i_prti_rang_mini, 
                               p_c005 => i_prti_rang_maxi, 
                               p_c006 => i_prti_orde,
                               p_c007 => i_tian_desc,
                               p_c008 => 'I'
                               );
    
  end pp_cargar_item_banal;
  
-----------------------------------------------
  procedure pp_update_item_banal(i_prti_tian_codi in number,
                                 i_prti_rang_mini in varchar2,
                                 i_prti_rang_maxi in varchar2,
                                 i_prti_orde      in number,
                                 i_tian_desc      in varchar2,
                                 coll_seq         in number,
                                 i_prti_prod_codi in varchar2,
                                 i_prti_indi      in varchar2) is

    --v_cant number;
    v_prti_indi varchar2(2);

  begin

    if i_prti_tian_codi is null then
      raise_application_error(-20010,'Debe de seleccionar un Tipo de Analisis!');
    end if;

    pp_validar_analisis_coll_up(i_prti_tian_codi, coll_seq);
    
    select c008
    into v_prti_indi
     from apex_collections det
      where det.collection_name= parameter.coll_name3
        and det.seq_id = coll_seq;

    if nvl(v_prti_indi,'U') = 'I' then
      v_prti_indi := 'I';
    else
      v_prti_indi := 'U';
    end if;
    
    apex_collection.update_member(p_collection_name => parameter.coll_name3,
                                  p_seq             => coll_seq,
                                  p_c001            => i_prti_prod_codi,
                                  p_c002            => i_prti_tian_codi,
                                  --p_c003 => prti_base, 
                                  p_c004 => i_prti_rang_mini,
                                  p_c005 => i_prti_rang_maxi,
                                  p_c006 => i_prti_orde,
                                  p_c007 => i_tian_desc,
                                  p_c008 => v_prti_indi--i_prti_indi
                                  );

  end pp_update_item_banal;
  
-----------------------------------------------
  procedure pp_delete_item_banal(coll_seq         in number,
                                 i_prti_indi      in varchar2,
                                 i_prti_tian_codi in number) is

    v_prti_indi varchar2(2);

  begin

    select nvl(c008, 'S') prti_indi
      into v_prti_indi
     from apex_collections det
      where det.collection_name= parameter.coll_name3
        and det.seq_id = coll_seq;
  
    if v_prti_indi = 'I' then
      apex_collection.delete_member(p_collection_name => parameter.coll_name3,
                                                p_seq => coll_seq);
    else
      apex_collection.update_member(p_collection_name => parameter.coll_name3,
                                  p_seq             => coll_seq,
                                  p_c002            => i_prti_tian_codi,
                                  p_c008            => i_prti_indi);
    end if;
    

  end pp_delete_item_banal;
  
-----------------------------------------------
  procedure pp_cargar_item_bcomp(i_comp_desc in varchar2) is
    
    v_cant          number;
    v_max_nume_item number;
    
  begin
    
    if i_comp_desc is null then
      raise_application_error(-20010, 'Debe ingresar la descripcion del componente!');
    end if;
    
    if not apex_collection.collection_exists(parameter.coll_name4) then
      apex_collection.create_collection(parameter.coll_name4);
    end if;
    
    select count(*)
      into v_cant
      from apex_collections a
     where a.collection_name = parameter.coll_name4;
  
    if v_cant > 0 then
    
      select max(to_number(c001)) + 1
        into v_max_nume_item
        from apex_collections a
       where a.collection_name = parameter.coll_name4;
    
    else
      v_max_nume_item := 1;
    end if;
    
    apex_collection.add_member(p_collection_name => parameter.coll_name4,
                               p_c001 => v_max_nume_item,--comp_nume_item, 
                               --p_c002 => comp_prod_codi, 
                               p_c003 => i_comp_desc,
                               --p_c004 => comp_base,
                               p_c005 => 'I'
                               );
                               
  end pp_cargar_item_bcomp;
  
-----------------------------------------------
  procedure pp_update_item_bcomp(i_comp_desc    in varchar2,
                                 comp_nume_item in varchar2,
                                 comp_prod_codi in varchar2,
                                 comp_base      in varchar2,
                                 coll_seq       in number,
                                 i_comp_indi    in varchar2) is

  v_comp_indi varchar(2);
  
  begin

    if i_comp_desc is null then
      raise_application_error(-20010,'Debe ingresar la descripcion del componente!');
    end if;
    
    select c005
      into v_comp_indi
      from apex_collections a
     where a.collection_name = parameter.coll_name4
      and a.seq_id = coll_seq;
    
    if nvl(v_comp_indi,'U') = 'I' then
      v_comp_indi := 'I';
    else 
      v_comp_indi := 'U';
    end if;

    
    apex_collection.update_member(p_collection_name => parameter.coll_name4,
                                  p_seq             => coll_seq,
                                  p_c001            => comp_nume_item,
                                  p_c002            => comp_prod_codi,
                                  p_c003            => i_comp_desc,
                                  p_c004            => comp_base,
                                  p_c005            => v_comp_indi--i_comp_indi
                                  );

  end pp_update_item_bcomp;
  
-----------------------------------------------
  procedure pp_delete_item_bcomp(coll_seq       in number,
                                 i_comp_indi    in varchar2,
                                 i_comp_nume_item in number) is

  v_comp_indi varchar2(2);
  
  begin

    select nvl(c005,'S') comp_indi
      into v_comp_indi
      from apex_collections det
     where det.collection_name= parameter.coll_name4
     and   det.seq_id = coll_seq;
  
    if v_comp_indi = 'I' then
      apex_collection.delete_member(p_collection_name => parameter.coll_name4,
                                                p_seq => coll_seq);
    else
      apex_collection.update_member(p_collection_name => parameter.coll_name4,
                                  p_seq             => coll_seq,
                                  p_c001            => i_comp_nume_item,
                                  p_c005            => i_comp_indi);
    end if;
    

  end pp_delete_item_bcomp;

-----------------------------------------------
  procedure pp_validar_borrado is
    v_count number(4);
  begin

    --validar que el producto posea momiviento  
    select count(*)
      into v_count
      from come_movi_prod_deta
     where deta_prod_codi = babmc.prod_codi;

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque posee movimiento');
    end if;

    --validar que el producto posea movimiento en el detalle de inventario
    select count(*)
      into v_count
      from come_inve_deta
     where deta_prod_codi = babmc.prod_codi;

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque posee movimiento en el detalle de inventario');
    end if;

    --validar que no se encuentre en una lista de precios
    select count(*)
      into v_count
      from come_list_prec_deta
     where lide_prod_codi = babmc.prod_codi;

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque se encuentra registrado en alguna lista de precios');
    end if;

    --validar que no se encuentre como un kit de Producto
    select count(*)
      into v_count
      from come_kitt_deta
     where kide_prod_codi = babmc.prod_codi;

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque se encuentra registrado en un Kit');
    end if;

    --validar que no se encuentre en un envio de muestra
    select count(*)
      into v_count
      from come_envi_mues_deta
     where mude_prod_codi = babmc.prod_codi;

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque se encuentra registrado en un Envio de Muestra');
    end if;

    --validar que no se encuentre en una orden de pedido
    select count(*)
      into v_count
      from come_orde_pedi_deta
     where deta_prod_codi = babmc.prod_codi;

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque se encuentra registrado en un Orden de Pedido');
    end if;

    --validar que no se encuentre en una orden de pedido loca
    select count(*)
      into v_count
      from come_orde_pedi_loca_deta
     where deta_prod_codi = babmc.prod_codi;

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque se encuentra registrado en un Orden de Pedido');
    end if;

    --validar que no se encuentre en una orden de equipamiento
    select count(*)
      into v_count
      from come_orde_trab_equi
     where (equi_prod_codi_gps = babmc.prod_codi or
           equi_prod_codi_chip = babmc.prod_codi);

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque se encuentra registrado en un Orden de Equipamiento');
    end if;

    --validar que no se encuentre en una deposito lote
    select count(*)
      into v_count
      from come_prod_depo_lote
     where prde_prod_codi = babmc.prod_codi
       and prde_cant_actu <> 0;

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque se encuentra registrado en un Deposito de lote');
    end if;

    --validar que no se encuentre en una deposito lote exte
    select count(*)
      into v_count
      from come_prod_depo_lote_exte
     where prde_prod_codi = babmc.prod_codi;

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque se encuentra registrado en un Deposito de lote');
    end if;

    --validar que no se encuentre en un detalle de remision
    select count(*)
      into v_count
      from come_remi_deta
     where deta_prod_codi = babmc.prod_codi;

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque se encuentra registrado en un Remision');
    end if;

    --validar que no se encuentre en productos analizados
    select count(*)
      into v_count
      from prod_anal
     where pran_prod_codi = babmc.prod_codi;

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque se encuentra registrado en Productos Analizados');
    end if;

    --validar que no se encuentre en un detalle de remision
    select count(*)
      into v_count
      from prod_movi
     where (movi_entr_prod_codi = babmc.prod_codi or
           movi_sali_prod_codi = babmc.prod_codi);

    if v_count > 0 then
      raise_application_error(-20010, 'No se puede eliminar este producto porque tiene movimientos de Entrada o Salida');
    end if;

    -- si el producto no tuvo movimiento, entonces se debe de borrar todos los registros
    -- de la tabla producto_deposito (por la integridad referencial)

    delete come_prod_depo where prde_prod_codi = babmc.prod_codi;
    delete come_prod_depo_hist where prde_prod_codi = babmc.prod_codi;
    delete come_prod_peri_oper where oppp_prod_codi = babmc.prod_codi;
    delete come_prod_peri where prpe_prod_codi = babmc.prod_codi;
    delete come_prod_peri_lote where pelo_prod_codi = babmc.prod_codi;
    delete come_prod_peri_oper_lote where oppp_prod_codi = babmc.prod_codi;
    delete come_prod_depo_lote where prde_prod_codi = babmc.prod_codi;
    delete come_prod_depo_hist_lote where prde_prod_codi = babmc.prod_codi;
    delete come_lote where lote_prod_codi = babmc.prod_codi;
    delete come_prod_coba_deta where coba_prod_codi = babmc.prod_codi;

  exception
    when others then
      raise_application_error(-20010,'Error al validar el borrado del registro!' ||sqlerrm);
  end pp_validar_borrado;

-----------------------------------------------
  procedure pp_pre_delete is

  begin

    update come_lote
       set lote_base = parameter.p_codi_base
     where lote_prod_codi = babmc.prod_codi;

    delete from come_prod_peri_lote where pelo_prod_codi = babmc.prod_codi;

    delete come_lote where lote_prod_codi = babmc.prod_codi;

    update come_prod
       set prod_base = parameter.p_codi_base
     where prod_codi = babmc.prod_codi;

    --
    -- Begin default relation program section
    --
    BEGIN
      --
      -- Begin BCOBA detail program section
      --
      DELETE FROM come_prod_coba_deta c
       WHERE c.COBA_PROD_CODI = BABMC.PROD_CODI;
      --
      -- End BCOBA detail program section
      --
      --
      -- Begin BIMAGEN detail program section
      --
      DELETE FROM come_prod_imag c WHERE c.PRIM_PROD_CODI = BABMC.PROD_CODI;
      --
      -- End BIMAGEN detail program section
      --
      --
      -- Begin BABMC_IMAG detail program section
      --
      DELETE FROM come_prod_imag c WHERE c.PRIM_PROD_CODI = BABMC.PROD_CODI;
      --
      -- End BABMC_IMAG detail program section
      --
      --
      -- Begin BPROV detail program section
      --
      DELETE FROM come_prod_prov_deta c
       WHERE c.PROD_PROV_PROD_CODI = BABMC.PROD_CODI;
      --
      -- End BPROV detail program section
      --
      --
      -- Begin BANAL detail program section
      --
      DELETE FROM come_prod_tipo_anal c
       WHERE c.PRTI_PROD_CODI = BABMC.PROD_CODI;
      --
      -- End BANAL detail program section
      --
      --
      -- Begin BCOMP detail program section
      --
      DELETE FROM come_prod_comp c WHERE c.COMP_PROD_CODI = BABMC.PROD_CODI;
      --
      -- End BCOMP detail program section
      --
      --ELIMINA REGISTROS DEL PRODUCTO
      delete come_prod
      where prod_codi = BABMC.PROD_CODI;

    END;
    --
    -- End default relation program section
    --
  exception
    when others then
      raise_application_error(-20010,'Error en el pre-borrado del registro!' ||sqlerrm);
  end pp_pre_delete;

-----------------------------------------------
  procedure pp_borrar_registro is
  begin

    babmc.prod_codi := V('P72_PROD_CODI');

    --raise_application_error(-20010, 'Borrando: '||babmc.prod_codi);
    
    if babmc.prod_codi is null then
      raise_application_error(-20010, 'Primero debe seleccionar un Producto');
    else
      pp_validar_borrado;
      pp_pre_delete;
      --commit;
      --apex_application.g_print_success_message :='Registro eliminado correctamente!';
    end if;
    
  exception
    when others then
      raise_application_error(-20010,'Error al borrar el registro!' ||sqlerrm);
  end;
  
-----------------------------------------------
  procedure pp_pre_carga_cod_barra(i_prod_codi_alfa in varchar2,
                                   i_coba_desc      in varchar2,
                                   i_coba_medi_codi in number,
                                   i_medi_desc_abre in varchar2,
                                   i_indi           in varchar2
                                   ) is
    v_cant number;
  
  begin
    
    if nvl(i_indi,'U') = 'I' then
      
      if i_coba_desc is null then
        raise_application_error(-20010,'Debe ingresar una Descripcion del producto!');
      end if;
      
      if i_coba_medi_codi is null then
        raise_application_error(-20010,'Debe ingresar una Unidad de Medida para el producto!');
      end if;

      if not apex_collection.collection_exists(parameter.coll_name1) then
        apex_collection.create_collection(parameter.coll_name1);
      else
        apex_collection.truncate_collection(parameter.coll_name1);
      end if;
      
      select count(*)
       into v_cant
      from apex_collections a
      where a.collection_name = 'COLL_BCOBA';
      
      --raise_application_error(-20010,'i_medi_desc_abre: '||i_medi_desc_abre);
      
      if nvl(v_cant,0) = 0 then
        
        apex_collection.add_member(p_collection_name => parameter.coll_name1,
                                 p_c001 => 1, --coba_nume_item,
                                 p_c003 => i_coba_desc,
                                 p_c004 => 4,
                                 p_c005 => i_prod_codi_alfa,
                                 p_c006 => i_coba_medi_codi,
                                 p_c007 => 1,
                                 p_c012 => i_medi_desc_abre,
                                 p_c013 => 'I');

      end if;
      
    end if;
      
  end pp_pre_carga_cod_barra;

-----------------------------------------------


  
  
end I010234;
