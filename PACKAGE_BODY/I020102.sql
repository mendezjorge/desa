
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020102" is
type r_parameter is record(
   
  p_codi_base varchar2(60) := pack_repl.fa_devu_codi_base,
  p_emit_reci      varchar2(60) := 'E',
  p_clie_prov      varchar2(60) := 'C',  
  p_indi_exis_prod    varchar2(60),       
  p_codi_impu_exen     varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_codi_impu_exen')),                        
  p_codi_impu_grav10   varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_codi_impu_grav10')),   
  p_codi_impu_grav5    varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_codi_impu_grav5')),   
  p_codi_mone_mmnn     varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_codi_mone_mmnn')),   
  p_cant_deci_mmnn     varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_cant_deci_mmnn')), 
  
  p_codi_timo_rete_emit varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_codi_timo_rete_emit')), 
  p_codi_prov_espo     varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_codi_prov_espo')), 
  p_codi_clie_espo     varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_codi_clie_espo')), 
  
  p_codi_conc_iva_10cr   varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_codi_conc_iva_10cr')),   
  p_codi_conc_iva_05cr   varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_codi_conc_iva_05cr')),   
  
  p_codi_timo_fcre      varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_codi_timo_fcre')),
  p_codi_timo_pres_emit varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_codi_timo_pres_emit')),  
  p_cant_cier_caja      varchar2(60) := to_number(general_skn.fl_busca_parametro ('p_cant_cier_caja')),
  p_empr_codi 					varchar2(60) := v('AI_EMPR_CODI'),
  p_ortr_codi           varchar2(60) ,
  p_fech_inic           date ,
  p_fech_fini           date 
  ---pa_devu_fech_habi(p_fech_inic,p_fech_fini ),

 );
  
  parameter r_parameter;
  
  
 type r_bcab is record( 
        movi_base               varchar2(200),
        movi_codi               varchar2(200),
        movi_empr_codi          varchar2(200),
        movi_sucu_codi_orig     varchar2(200),
        movi_timo_codi          varchar2(200),
        movi_nume               varchar2(200),
        movi_clpr_codi          varchar2(200),
        movi_clpr_sucu_nume_item varchar2(200),
        movi_fech_emis           varchar2(200),
        movi_fech_oper           varchar2(200),
        movi_fech_orig           varchar2(200),
        movi_oper_codi           varchar2(200),
        movi_mone_codi           varchar2(200),
        movi_mone_cant_deci      varchar2(200),
        movi_tasa_mone           varchar2(200),
        movi_indi_inte           varchar2(200),
        movi_obse                varchar2(200),
        movi_nume_timb           varchar2(200),
        movi_ortr_codi           varchar2(200),
        movi_clpr_ruc            varchar2(200),
        movi_empl_codi           varchar2(200),
        movi_impo_codi           varchar2(200),
        movi_depo_codi_orig      varchar2(200),
        movi_orpa_codi           varchar2(200),
        movi_depo_codi_alte      varchar2(200),
        movi_codi_rete           varchar2(200),
        movi_fech_grab           varchar2(200),
        movi_user                varchar2(200),
        movi_exen_mone           varchar2(200),
        movi_exen_mmnn           varchar2(200),
        movi_grav_mone           varchar2(200),
        movi_grav_mmnn           varchar2(200),
        movi_iva_mone            varchar2(200),
        movi_iva_mmnn            varchar2(200),
        fecha                    varchar2(200),
        clpr_codi_alte_nvo       varchar2(200),
        clpr_codi_alte           varchar2(200),
        s_movi_depo_codi_orig    varchar2(200),
        movi_clpr_desc           varchar2(200),
        clpr_desc_nvo            varchar2(200),
        clpr_codi_rete           varchar2(200),
        fech                     varchar2(200),
        timo_indi_caja           varchar2(200),
        movi_codi_padr           varchar2(200),
        clpr_codi_nvo            varchar2(200),
        deta_ortr_codi           number        
  );
   bcab r_bcab; 
  
  
 cursor cur_bprod is
 select seq_id,
        c001 deta_nume_item,     
        c002 deta_movi_codi,
        c003 deta_impu_codi,
        c004 prod_codi_alfa,  
        c005 prod_desc,
        c006 deta_lote_codi_alte,
        c007 lote_desc,
        c008 deta_prod_codi,
        c009 deta_prod_codi_orig,
        c010 deta_cant,
        c011 deta_obse,
        c012 deta_prec_unit,
        c013 deta_impo_mone_ii,
        c014 deta_lote_codi,
        c015 deta_lote_codi_orig
   
       /* C001 deta_movi_codi       , 
        C002 deta_nume_item        ,---
        C003 deta_impu_codi        ,
        C004 deta_prod_codi        ,
        C005 deta_cant             ,
        C006 deta_obse             ,
        C007 deta_porc_deto        ,
        C008 deta_impo_mone        ,
        C009 deta_impo_mmnn        ,
        C010 deta_impo_mmee        ,
        C011 deta_iva_mmnn         ,
        C012 deta_iva_mmee         ,
        C013 deta_iva_mone         ,
        C014 deta_prec_unit        ,
        C015 deta_movi_codi_padr   ,
        C016 deta_nume_item_padr   ,
        C017 deta_impo_mone_deto_nc,
        C018 deta_movi_codi_deto_nc,
        C019 deta_list_codi        ,
        C020 deta_movi_clave_orig  ,
        C021 deta_impo_mmnn_deto_nc,
        C022 deta_base             ,
        C023 deta_lote_codi        ,
        C024 deta_movi_orig_codi   ,
        C025 deta_movi_orig_item   ,
        C026 deta_impo_mmee_deto_nc,
        C027 deta_asie_codi        ,
        C028 deta_cant_medi        ,
        C029 deta_medi_codi        ,
        C030 deta_remi_codi        ,
        C031 deta_remi_nume_item   ,
        C032 deta_bien_codi        ,
        C033 deta_prec_unit_list   ,
        C034 deta_impo_deto_mone   ,
        C035 deta_porc_deto_prec   ,
        C036 deta_bene_codi        ,
        C037 deta_ceco_codi        ,
        C038 deta_clpr_codi        ,
        C039 deta_impo_mone_ii     ,
        C040 deta_impo_mmnn_ii     ,
        C041 deta_grav10_ii_mone   ,
        C042 deta_grav5_ii_mone    ,
        C043 deta_grav10_ii_mmnn   ,
        C044 deta_grav5_ii_mmnn    ,
        C045 deta_grav10_mone      ,
        C046 deta_grav5_mone       ,
        C047 deta_grav10_mmnn      ,
        C048 deta_grav5_mmnn       ,
        C049 deta_iva10_mone       ,
        C050 deta_iva5_mone        ,
        C001 deta_iva10_mmnn       ,
        C001 deta_iva5_mmnn        ,
        C001 deta_exen_mone        ,
        C001 deta_exen_mmnn        ,
        C001 deta_indi_cost        ,
        C001 deta_exde_codi        ,
        C001 deta_exde_tipo        ,
        C001 deta_impo_inte_mone   ,
        C001 deta_impo_inte_mmnn   ,
        C001 deta_emse_codi        ,
        c001 deta_prod_codi_orig   ,
        c001 deta_lote_codi_orig   
       */
from apex_collections
where collection_name = 'DETA_ARTI';

 cursor cur_bconc is
select 
    c001 moco_nume_item,
    c002 moco_movi_codi,
    c003 moco_conc_codi,
    c004 conc_dbcr,
    c005 conc_indi_impo,
    c006 moco_dbcr,
    c007 moco_impu_codi,
    c008 moco_impu_desc,
    c009 impo_nume,
    c010 ceco_nume,
    c011 ortr_nume,
    c012 juri_nume,
    c013 tran_codi_alte,
    c014 moco_impo_codi,
    c015 moco_ortr_codi,
    c016 moco_ceco_codi,
    c017 moco_tran_codi,
    c018 moco_juri_codi,
    c019 impu_porc_base_impo,
    c020 impu_porc,
    c021 moco_impo_mone,
    c022 moco_impo_mmnn,
    c023 moco_conc_desc
from apex_collections
where collection_name = 'DETA_CONC';

procedure pp_actualizar_come_movi is

begin
      update come_movi
         set movi_base                = bcab.movi_base,
             movi_empr_codi           = bcab.movi_empr_codi,
             movi_sucu_codi_orig      = bcab.movi_sucu_codi_orig,
             movi_timo_codi           = bcab.movi_timo_codi,
             movi_nume                = bcab.movi_nume,
             movi_clpr_codi           = bcab.movi_clpr_codi,
             movi_clpr_sucu_nume_item = bcab.movi_clpr_sucu_nume_item,
             movi_fech_emis           = bcab.movi_fech_emis,
             movi_fech_oper           = bcab.movi_fech_oper,
          --   movi_fech_orig           = bcab.movi_fech_orig,
             movi_oper_codi           = bcab.movi_oper_codi,
             movi_mone_codi           = bcab.movi_mone_codi,
            -- movi_mone_cant_deci      = bcab.movi_mone_cant_deci,
             movi_tasa_mone           = bcab.movi_tasa_mone,
             movi_indi_inte           = bcab.movi_indi_inte,
             movi_obse                = bcab.movi_obse,
             movi_nume_timb           = bcab.movi_nume_timb,
             movi_ortr_codi           = bcab.movi_ortr_codi,
             movi_clpr_ruc            = bcab.movi_clpr_ruc,
             movi_empl_codi           = bcab.movi_empl_codi,
             movi_impo_codi           = bcab.movi_impo_codi,
             movi_depo_codi_orig      = bcab.movi_depo_codi_orig,
             movi_orpa_codi           = bcab.movi_orpa_codi,
          --   movi_depo_codi_alte      = bcab.movi_depo_codi_alte,
             movi_codi_rete           = bcab.movi_codi_rete,
             movi_fech_grab           = bcab.movi_fech_grab,
             movi_user                = bcab.movi_user,
             movi_exen_mone           = bcab.movi_exen_mone,
             movi_exen_mmnn           = bcab.movi_exen_mmnn,
             movi_grav_mone           = bcab.movi_grav_mone,
             movi_grav_mmnn           = bcab.movi_grav_mmnn,
             movi_iva_mone            = bcab.movi_iva_mone,
             movi_iva_mmnn            = bcab.movi_iva_mmnn
       where movi_codi = bcab.movi_codi;


end pp_actualizar_come_movi;


procedure pp_actualizar_conc_deta is
  
begin
  
    for bcom in cur_bconc loop
        update come_movi_conc_deta
           set moco_nume_item = bcom.moco_nume_item,
               moco_movi_codi = bcom.moco_movi_codi,
               moco_conc_codi = bcom.moco_conc_codi,
               moco_dbcr      = bcom.moco_dbcr,
               moco_impu_codi = bcom.moco_impu_codi,
              -- moco_impu_desc = bcom.moco_impu_desc,
               moco_impo_codi = bcom.moco_impo_codi,
               moco_ortr_codi = bcom.moco_ortr_codi,
               moco_ceco_codi = bcom.moco_ceco_codi,
               moco_tran_codi = bcom.moco_tran_codi,
               moco_juri_codi = bcom.moco_juri_codi,
               moco_impo_mone = bcom.moco_impo_mone,
               moco_impo_mmnn = bcom.moco_impo_mmnn
             --  moco_conc_desc = bcom.moco_conc_desc
         where moco_movi_codi = bcab.movi_codi;
    end loop;
    
end pp_actualizar_conc_deta;

procedure pp_actualizar_depo_prod is

cursor cur_bprod1 is (select b.deta_movi_codi,
       a.deta_nume_item,
       a.deta_impu_codi,
       a.deta_prod_codi,
       a.deta_cant,
       a.deta_obse,
       b.deta_porc_deto,
       b.deta_impo_mone,
       b.deta_impo_mmnn,
       b.deta_impo_mmee,
       b.deta_iva_mmnn,
       b.deta_iva_mmee,
       b.deta_iva_mone,
       a.deta_prec_unit,
       b.deta_movi_codi_padr,
       b.deta_nume_item_padr,
       b.deta_impo_mone_deto_nc,
       b.deta_movi_codi_deto_nc,
       b.deta_list_codi,
       b.deta_movi_clave_orig,
       b.deta_impo_mmnn_deto_nc,
       b.deta_base,
       a.deta_lote_codi,
       b.deta_movi_orig_codi,
       b.deta_movi_orig_item,
       b.deta_impo_mmee_deto_nc,
       b.deta_asie_codi,
       b.deta_cant_medi,
       b.deta_medi_codi,
       b.deta_remi_codi,
       b.deta_remi_nume_item,
       b.deta_bien_codi,
       b.deta_prec_unit_list,
       b.deta_impo_deto_mone,
       b.deta_porc_deto_prec,
       b.deta_bene_codi,
       b.deta_ceco_codi,
       b.deta_clpr_codi,
       a.deta_impo_mone_ii,
       b.deta_impo_mmnn_ii,
       b.deta_grav10_ii_mone,
       b.deta_grav5_ii_mone,
       b.deta_grav10_ii_mmnn,
       b.deta_grav5_ii_mmnn,
       b.deta_grav10_mone,
       b.deta_grav5_mone,
       b.deta_grav10_mmnn,
       b.deta_grav5_mmnn,
       b.deta_iva10_mone,
       b.deta_iva5_mone,
       b.deta_iva10_mmnn,
       b.deta_iva5_mmnn,
       b.deta_exen_mone,
       b.deta_exen_mmnn,
       b.deta_indi_cost,
       b.deta_exde_codi,
       b.deta_exde_tipo,
       b.deta_impo_inte_mone,
       b.deta_impo_inte_mmnn,
       b.deta_emse_codi,
       b.deta_prod_codi_barr,
       b.deta_prod_prec_maxi_deto,
       b.deta_prod_prec_maxi_deto_exce,
       b.deta_indi_venc,
       b.deta_impo_cost_dire_mmee,
       b.deta_impo_cost_dire_mmnn,
       b.deta_tran_codi,
       a.prod_codi_alfa,
       a.prod_desc,
       a.deta_lote_codi_alte,
       a.lote_desc,
       a.deta_prod_codi_orig,
       a.deta_lote_codi_orig,
       a.seq_id
       
from 
 (select seq_id,
        c001 deta_nume_item,     
        c002 deta_movi_codi,
        c003 deta_impu_codi,
        c004 prod_codi_alfa,  
        c005 prod_desc,
        c006 deta_lote_codi_alte,
        c007 lote_desc,
        c008 deta_prod_codi,
        c009 deta_prod_codi_orig,
        c010 deta_cant,
        c011 deta_obse,
        c012 deta_prec_unit,
        c013 deta_impo_mone_ii,
        c014 deta_lote_codi,
        c015 deta_lote_codi_orig
from apex_collections
where collection_name = 'DETA_ARTI') a,  come_movi_prod_deta b
where a.deta_movi_codi=b.deta_movi_codi
 and b.deta_movi_codi = bcab.movi_codi);
                      
                      
v_indi_modi_prod varchar2(1) := 'N';
v_indi_modi_lote varchar2(1) := 'N';
v_indi_modi_depo varchar2(1) := 'N';

begin
  if nvl(parameter.p_indi_exis_prod,'N') = 'S' then

        for bprod in cur_bprod1 loop
            if  bprod.seq_id = 1 then
                if bprod.deta_prod_codi <> bprod.deta_prod_codi_orig then
                  v_indi_modi_prod := 'S';
                end if;
                
                if bprod.deta_lote_codi <> bprod.deta_lote_codi_orig then
                  v_indi_modi_lote := 'S';
                end if;
           end if;
        end loop;

    
    if bcab.s_movi_depo_codi_orig is not null and bcab.s_movi_depo_codi_orig <> bcab.movi_depo_codi_orig then
      v_indi_modi_depo := 'S';
    end if;
    
    if nvl(v_indi_modi_prod, 'N') = 'S' or nvl(v_indi_modi_lote, 'N') = 'S' or nvl(v_indi_modi_depo, 'N') = 'S' then

       delete come_movi_prod_deta 
        where deta_movi_codi = bcab.movi_codi;
      
      if nvl(v_indi_modi_depo, 'N') = 'S' then
        update come_movi 
           set movi_depo_codi_orig = bcab.s_movi_depo_codi_orig 
           where movi_codi = bcab.movi_codi;
      end if;
      
    for bprod in cur_bprod1 loop
        insert into come_movi_prod_deta(
            deta_movi_codi        , 
            deta_nume_item        ,
            deta_impu_codi        ,
            deta_prod_codi        ,
            deta_cant             ,
            deta_obse             ,
            deta_porc_deto        ,
            deta_impo_mone        ,
            deta_impo_mmnn        ,
            deta_impo_mmee        ,
            deta_iva_mmnn         ,
            deta_iva_mmee         ,
            deta_iva_mone         ,
            deta_prec_unit        ,
            deta_movi_codi_padr   ,
            deta_nume_item_padr   ,
            deta_impo_mone_deto_nc,
            deta_movi_codi_deto_nc,
            deta_list_codi        ,
            deta_movi_clave_orig  ,
            deta_impo_mmnn_deto_nc,
            deta_base             ,
            deta_lote_codi        ,
            deta_movi_orig_codi   ,
            deta_movi_orig_item   ,
            deta_impo_mmee_deto_nc,
            deta_asie_codi        ,
            deta_cant_medi        ,
            deta_medi_codi        ,
            deta_remi_codi        ,
            deta_remi_nume_item   ,
            deta_bien_codi        ,
            deta_prec_unit_list   ,
            deta_impo_deto_mone   ,
            deta_porc_deto_prec   ,
            deta_bene_codi        ,
            deta_ceco_codi        ,
            deta_clpr_codi        ,
            deta_impo_mone_ii     ,
            deta_impo_mmnn_ii     ,
            deta_grav10_ii_mone   ,
            deta_grav5_ii_mone    ,
            deta_grav10_ii_mmnn   ,
            deta_grav5_ii_mmnn    ,
            deta_grav10_mone      ,
            deta_grav5_mone       ,
            deta_grav10_mmnn      ,
            deta_grav5_mmnn       ,
            deta_iva10_mone       ,
            deta_iva5_mone        ,
            deta_iva10_mmnn       ,
            deta_iva5_mmnn        ,
            deta_exen_mone        ,
            deta_exen_mmnn        ,
            deta_indi_cost        ,
            deta_exde_codi        ,
            deta_exde_tipo        ,
            deta_impo_inte_mone   ,
            deta_impo_inte_mmnn   ,
            deta_emse_codi
            )values(
            bprod.deta_movi_codi       , 
            bprod.deta_nume_item        ,
            bprod.deta_impu_codi        ,
            bprod.deta_prod_codi        ,
            bprod.deta_cant             ,
            bprod.deta_obse             ,
            bprod.deta_porc_deto        ,
            bprod.deta_impo_mone        ,
            bprod.deta_impo_mmnn        ,
            bprod.deta_impo_mmee        ,
            bprod.deta_iva_mmnn         ,
            bprod.deta_iva_mmee         ,
            bprod.deta_iva_mone         ,
            bprod.deta_prec_unit        ,
            bprod.deta_movi_codi_padr   ,
            bprod.deta_nume_item_padr   ,
            bprod.deta_impo_mone_deto_nc,
            bprod.deta_movi_codi_deto_nc,
            bprod.deta_list_codi        ,
            bprod.deta_movi_clave_orig  ,
            bprod.deta_impo_mmnn_deto_nc,
            bprod.deta_base             ,
            bprod.deta_lote_codi        ,
            bprod.deta_movi_orig_codi   ,
            bprod.deta_movi_orig_item   ,
            bprod.deta_impo_mmee_deto_nc,
            bprod.deta_asie_codi        ,
            bprod.deta_cant_medi        ,
            bprod.deta_medi_codi        ,
            bprod.deta_remi_codi        ,
            bprod.deta_remi_nume_item   ,
            bprod.deta_bien_codi        ,
            bprod.deta_prec_unit_list   ,
            bprod.deta_impo_deto_mone   ,
            bprod.deta_porc_deto_prec   ,
            bprod.deta_bene_codi        ,
            bprod.deta_ceco_codi        ,
            bprod.deta_clpr_codi        ,
            bprod.deta_impo_mone_ii     ,
            bprod.deta_impo_mmnn_ii     ,
            bprod.deta_grav10_ii_mone   ,
            bprod.deta_grav5_ii_mone    ,
            bprod.deta_grav10_ii_mmnn   ,
            bprod.deta_grav5_ii_mmnn    ,
            bprod.deta_grav10_mone      ,
            bprod.deta_grav5_mone       ,
            bprod.deta_grav10_mmnn      ,
            bprod.deta_grav5_mmnn       ,
            bprod.deta_iva10_mone       ,
            bprod.deta_iva5_mone        ,
            bprod.deta_iva10_mmnn       ,
            bprod.deta_iva5_mmnn        ,
            bprod.deta_exen_mone        ,
            bprod.deta_exen_mmnn        ,
            bprod.deta_indi_cost        ,
            bprod.deta_exde_codi        ,
            bprod.deta_exde_tipo        ,
            bprod.deta_impo_inte_mone   ,
            bprod.deta_impo_inte_mmnn   ,
            bprod.deta_emse_codi);
            

      end loop;
      
      ----Se vuelve a realizar el cambio al deposito original,y luego en el bloque se cambia al nuevo deposito que corresponde,
      ----esto para que al realizar el commit_form encuentre cambios en el bloque
      if nvl(v_indi_modi_depo, 'N') = 'S' then
          update come_movi
             set movi_depo_codi_orig = bcab.movi_depo_codi_orig
           where movi_codi = bcab.movi_codi;
           
          bcab.movi_depo_codi_orig := bcab.s_movi_depo_codi_orig;
          
      end if;
    end if;
  end if; 
end; 
 
 
procedure pp_actualizar_movi_impo is
  v_movi_timo_codi number;
 
  
begin
  if bcab.fech <> bcab.movi_fech_orig then
   
    if bcab.timo_indi_caja = 'S' then
        update come_movi_impo_deta
           set moim_fech = bcab.fech, 
               moim_fech_oper = bcab.fech
         where moim_movi_codi = bcab.movi_codi;
    end if;	
    
    if bcab.movi_timo_codi = parameter.p_codi_timo_fcre then   -- si es una factura credito emitida
      if bcab.movi_codi_padr is not null then
        begin
          select m.movi_timo_codi
            into v_movi_timo_codi
            from come_movi m
           where m.movi_codi = bcab.movi_codi_padr;
          
          -- si el padre de la factura es una liquidacion de prestamo
          if v_movi_timo_codi = parameter.p_codi_timo_pres_emit then
            update come_movi m
               set m.movi_fech_emis = bcab.fech,
                   m.movi_fech_oper = bcab.fech
             where m.movi_codi = bcab.movi_codi_padr;
            
            update come_movi_impo_deta d          
               set d.moim_fech = bcab.fech,  
                   d.moim_fech_oper = bcab.fech
             where d.moim_movi_codi = bcab.movi_codi_padr;
             
          end if;
        exception
          when no_data_found then
            null;
        end;
      end if;
    end if;
  end if;
end pp_actualizar_movi_impo;

 
procedure pp_actualizar_orpa(p_orpa_codi in number) is
begin
  update come_orde_pago
     set orpa_nume = bcab.movi_nume
   where orpa_codi = p_orpa_codi;
exception
	when others then
		null;
end pp_actualizar_orpa;

procedure pp_validar_ot (p_codi in number)is
v_esta varchar2(1);
begin
 
  select nvl(ortr_esta, 'P')
  into v_esta
  from come_orde_trab
  where ortr_codi = p_codi;
  
  if nvl(parameter.p_ortr_codi,0) <> nvl(bcab.movi_ortr_codi,0) then
	  if v_esta = 'L' then
	  	 raise_application_error(-20001,'La orden de trabajo se encuentra liquidada');
	  end if;	 	  	 
  end if;	
  
  exception
  	 when no_data_found then
  	    null;
  
end pp_validar_ot;

procedure pp_set_variables is

begin
  

bcab.movi_base                :=V('P20_MOVI_BASE');
bcab.movi_codi                :=V('P20_MOVI_CODI');
bcab.movi_empr_codi           :=V('P20_MOVI_EMPR_CODI');
bcab.movi_sucu_codi_ORIG      :=V('P20_MOVI_SUCU_CODI_ORIG');
bcab.movi_timo_codi           :=V('P20_MOVI_TIMO_CODI');
bcab.movi_nume                :=V('P20_MOVI_NUME');
bcab.movi_clpr_codi           :=V('P20_MOVI_CLPR_CODI');
bcab.movi_fech_oper           :=V('P20_MOVI_FECH_OPER');
bcab.movi_clpr_sucu_nume_item :=V('P20_MOVI_CLPR_SUCU_NUME_ITEM');
bcab.movi_fech_orig           :=V('P20_MOVI_FECH_ORIG');
bcab.movi_fech_emis           :=V('P20_MOVI_FECH_EMIS');
bcab.movi_oper_codi           :=V('P20_MOVI_OPER_CODI');
bcab.movi_mone_codi           :=V('P20_MOVI_MONE_CODI');
bcab.movi_mone_cant_deci      :=V('P20_MOVI_MONE_CANT_DECI');
--bcab.movi_mone_desc_abre      :=V('P20_MOVI_MONE_DESC_ABRE');
bcab.movi_tasa_mone           :=V('P20_MOVI_TASA_MONE');
bcab.movi_indi_inte           :=V('P20_MOVI_INDI_INTE');
bcab.movi_obse                :=V('P20_MOVI_OBSE');
bcab.movi_nume_timb           :=V('P20_MOVI_NUME_TIMB');
bcab.movi_ortr_codi           :=V('P20_MOVI_ORTR_CODI');
bcab.movi_clpr_ruc            :=V('P20_MOVI_CLPR_RUC');
bcab.movi_empl_codi           :=V('P20_MOVI_EMPL_CODI');
bcab.movi_orpa_codi           :=V('P20_MOVI_ORPA_CODI');
bcab.movi_impo_codi           :=V('P20_MOVI_IMPO_CODI');
bcab.movi_depo_codi_alte      :=V('P20_MOVI_DEPO_CODI_ALTE');
bcab.movi_depo_codi_orig      :=V('P20_MOVI_DEPO_CODI_ORIG');
--bcab.movi_depo_desc           :=V('P20_MOVI_DEPO_DESC');
bcab.movi_codi_rete           :=V('P20_MOVI_CODI_RETE');
--bcab.movi_mone_desc           :=V('P20_MOVI_MONE_DESC');
bcab.movi_fech_grab           :=V('P20_MOVI_FECH_GRAB');
bcab.movi_user                :=V('P20_MOVI_USER');
bcab.movi_exen_mone           :=V('P20_MOVI_EXEN_MONE');
bcab.movi_exen_mmnn           :=V('P20_MOVI_EXEN_MMNN');
bcab.movi_grav_mone           :=V('P20_MOVI_GRAV_MONE');
bcab.movi_grav_mmnn           :=V('P20_MOVI_GRAV_MMNN');
bcab.movi_iva_mone            :=V('P20_MOVI_IVA_MONE');
bcab.movi_iva_mmnn            :=V('P20_MOVI_IVA_MMNN');



--bcab.s_timo_codi              :=V('P20_S_TIMO_CODI');
--bcab.s_mes                    :=V('P20_S_MES');
--bcab.s_anho                   :=V('P20_S_ANHO');
--bcab.s_fech                   :=V('P20_S_FECH');
--bcab.sucu_desc                :=V('P20_SUCU_DESC');
--bcab.s_cod_documento          :=V('P20_S_COD_DOCUMENTO');
--bcab.s_timo_desc_abre         :=V('P20_S_TIMO_DESC_ABRE');
--bcab.timo_desc                :=V('P20_TIMO_DESC');
--bcab.s_nro_1                  :=V('P20_S_NRO_1');
--bcab.s_nro_2                  :=V('P20_S_NRO_2');
--bcab.s_nro_3                  :=V('P20_S_NRO_3');
--bcab.subc_desc                :=V('P20_SUBC_DESC');
--bcab.empl_desc                :=V('P20_EMPL_DESC');


bcab.timo_indi_caja           :=V('P20_TIMO_INDI_CAJA');

--bcab.timo_afec_sald           :=V('P20_TIMO_AFEC_SALD');

--bcab.s_timo_afec_sald         :=V('P20_S_TIMO_AFEC_SALD');

--bcab.s_timo_dbcr              :=V('P20_S_TIMO_DBCR');

bcab.clpr_codi_alte           :=V('P20_CLPR_CODI_ALTE');
--bcab.clpr_desc                :=V('P20_CLPR_DESC');
bcab.clpr_codi_nvo            :=V('P20_CLPR_CODI_NVO');
--bcab.s_clpr_desc              :=V('P20_S_CLPR_DESC');
---bcab.timo_emit_reci           :=V('P20_TIMO_EMIT_RECI');

bcab.fech                     :=V('P20_FECH');
--bcab.ortr_nume                :=V('P20_ORTR_NUME');

--bcab.impo_nume                :=V('P20_IMPO_NUME');
bcab.deta_ortr_codi           :=V('P20_DETA_ORTR_CODI');
--bcab.deta_ortr_nume           :=V('P20_DETA_ORTR_NUME');
--bcab.deta_ortr_codi_orig      :=V('P20_DETA_ORTR_CODI_ORIG');
--bcab.s_movi_depo_codi_alte    :=V('P20_S_MOVI_DEPO_CODI_ALTE');
--bcab.depo_codi_alte           :=V('P20_DEPO_CODI_ALTE');
bcab.s_movi_depo_codi_orig    :=V('P20_S_MOVI_DEPO_CODI_ORIG');
--bcab.nume_rete                 :=V('P20_NUME_RETE');
--bcab.indi_bloq                 :=V('P20_INDI_BLOQ');
--bcab.indi_clie_prov            :=V('P20_INDI_CLIE_PROV');
--bcab.s_movi_depo_desc          :=V('P20_S_MOVI_DEPO_DESC');
bcab.clpr_codi_rete            :=V('P20_CLPR_CODI_RETE');
--bcab.impo_rete                 :=V('P20_IMPO_RETE');
--bcab.p_codi_timo_rete_emit     :=V('P20_P_CODI_TIMO_RETE_EMIT');
/*bcab.s_exen                    :=V('P20_S_EXEN');
bcab.s_grav_5_ii               :=V('P20_S_GRAV_5_II');
bcab.s_grav_10_ii              :=V('P20_S_GRAV_10_II');
bcab.s_iva_5                   :=V('P20_S_IVA_5');
bcab.s_iva_10                  :=V('P20_S_IVA_10');
bcab.s_tot_exen                :=V('P20_S_TOT_EXEN');
bcab.s_tot_grav_10             :=V('P20_S_TOT_GRAV_10');
bcab.s_tot_iva                 :=V('P20_S_TOT_IVA');
bcab.s_total                   :=V('P20_S_TOTAL');
bcab.s_tot_grav_5              :=V('P20_S_TOT_GRAV_5');*/







end pp_set_variables;
procedure pp_actualizar_registro is
begin
  pp_set_variables;
/*  if :bcab.fech is not null then

  if :bcab.fech <> :bcab.movi_fech_emis then
  	begin
  -- Call the procedure
  I020102.pp_validar_fecha(p_movi_codi      => :p20_movi_codi,
                           p_fech           => :p20_fech,
                           p_movi_fech_emis => :p20_movi_fech_emis,
                           p_movi_timo_codi => :p20_movi_timo_codi,
                           p_movi_fech_orig => :p20_movi_fech_orig,
                           p_s_fech         => :p20_s_fech);
end;

  	
    :bcab.movi_fech_emis := :bcab.fech;
    :bcab.movi_fech_oper := :bcab.fech;
    :bcab.s_movi_fech_emis := to_char(:bcab.movi_fech_emis, 'dd-mm-yyyy');
  end if;
end if;*/

if nvl(bcab.movi_tasa_mone,0) <= 0 then
	raise_application_error(-20001, 'La cotizacion debe ser mayor a cero');
end if;        

  if bcab.clpr_codi_alte <> parameter.p_codi_prov_espo then
    if bcab.movi_clpr_codi <> bcab.clpr_codi_rete then
      raise_application_Error(-20001,'El codigo del proveedor de la factura no coincide con el prov. de la retencion');
    end if;   
  end if; 

  if bcab.movi_ortr_codi is not null then
    pp_validar_ot(bcab.movi_ortr_codi);
  end if;

  if bcab.movi_timo_codi in (5,43) then
    if bcab.clpr_codi_alte_nvo is not null then
      if bcab.clpr_codi_alte_nvo <> bcab.clpr_codi_alte then
        bcab.movi_clpr_codi := bcab.clpr_codi_nvo;
        bcab.movi_clpr_desc := bcab.clpr_desc_nvo;
      end if; 
    end if; 
  elsif bcab.movi_timo_codi in (59) then
    pp_actualizar_orpa(bcab.movi_orpa_codi);
  end if;
      
  pp_actualizar_movi_impo;
  pp_actualizar_depo_prod;
  pp_actualizar_come_movi;
  
  -------update come_movi_conc_deta
  ----moco_movi_codi = :bcab.movi_codi
-- update movi_codi
  --where movi_codi = :bcab.movi_codi

    
 
end pp_actualizar_registro;




procedure pp_consultar_docu (p_movi_codi in number)is

v_movi_base               varchar2(200);
v_movi_codi               varchar2(200);
v_movi_empr_codi          varchar2(200);
v_movi_sucu_codi_orig     varchar2(200);
v_movi_timo_codi          varchar2(200);
v_movi_nume               varchar2(200);
v_movi_clpr_codi          varchar2(200);
v_movi_clpr_sucu_nume_item varchar2(200);
v_movi_fech_emis           date;
v_movi_fech_oper           date;
v_movi_fech_orig           date;
v_movi_oper_codi           varchar2(200);
v_movi_mone_codi           varchar2(200);
v_movi_mone_cant_deci      varchar2(200);
v_movi_tasa_mone           varchar2(200);
v_movi_indi_inte           varchar2(200);
v_movi_obse                varchar2(200);
v_movi_nume_timb           varchar2(200);
v_movi_ortr_codi           varchar2(200);
v_movi_clpr_ruc            varchar2(200);
v_movi_empl_codi           varchar2(200);
v_movi_impo_codi           varchar2(200);
v_movi_depo_codi_orig      varchar2(200);
v_movi_orpa_codi           varchar2(200);
v_movi_depo_codi_alte      varchar2(200);
v_movi_codi_rete           varchar2(200);
v_movi_fech_grab           date;
v_movi_user                varchar2(200);
v_movi_exen_mone           varchar2(200);
v_movi_exen_mmnn           varchar2(200);
v_movi_grav_mone           varchar2(200);
v_movi_grav_mmnn           varchar2(200);
v_movi_iva_mone            varchar2(200);
v_movi_iva_mmnn            varchar2(200);
v_movi_codi_padr           varchar2(200);
v_sucu_desc                varchar2(100);  
v_movi_depo_desc           varchar2(100);  
--v_movi_depo_codi_alte      varchar2(100);  


v_clpr_desc                varchar2(100); 
v_clpr_codi_alte           varchar2(100);    
v_indi_clie_prov           varchar2(100); 

v_subc_desc                varchar2(100); 


 
v_s_nro_1                 varchar2(100); 
v_s_nro_2                 varchar2(100); 
v_s_nro_3                 varchar2(100); 


v_movi_mone_desc           varchar2(100); 
v_movi_mone_desc_abre      varchar2(100); 

v_nume_rete                varchar2(100); 
v_impo_rete                varchar2(100);

v_empl_desc                varchar2(100); 

v_deta_ortr_nume           varchar2(100);
v_deta_ortr_codi           varchar2(100);

v_ortr_nume                varchar2(100);
v_indi_bloq                varchar2(100);

v_s_exen                   varchar2(100);
v_s_grav_10_ii             varchar2(100);
v_s_grav_5_ii              varchar2(100);
v_s_iva_10                 varchar2(100);
v_s_iva_5                  varchar2(100);   

v_timo_desc       varchar2(100);           
v_timo_emit_reci  varchar2(100); 
--v_movi_oper_codi  varchar2(100); 
v_timo_indi_caja  varchar2(100);
v_timo_afec_sald  varchar2(100);  
v_count           number;  
v_cier_nume   number;
v_fech_cier   date; 

v_s_tot_iva     varchar2(100);
v_s_total        varchar2(100);
v_fech           date;
begin
  
select movi_base,
       movi_codi,
       movi_empr_codi,
       movi_sucu_codi_orig,
       movi_timo_codi,
       movi_nume,
       movi_clpr_codi,
       movi_clpr_sucu_nume_item,
       movi_fech_emis,
       movi_fech_oper,
       --movi_fech_orig,
       movi_oper_codi,
       movi_mone_codi,
       --movi_mone_cant_deci,
       movi_tasa_mone,
       movi_indi_inte,
       movi_obse,
       movi_nume_timb,
       movi_ortr_codi,
       movi_clpr_ruc,
       movi_empl_codi,
       movi_impo_codi,
       movi_depo_codi_orig,
       movi_orpa_codi,
       --movi_depo_codi_alte,
       movi_codi_rete,
       movi_fech_grab,
       movi_user,
       movi_exen_mone,
       movi_exen_mmnn,
       movi_grav_mone,
       movi_grav_mmnn,
       movi_iva_mone,
       movi_iva_mmnn
  into v_movi_base,
       v_movi_codi,
       v_movi_empr_codi,
       v_movi_sucu_codi_orig,
       v_movi_timo_codi,
       v_movi_nume,
       v_movi_clpr_codi,
       v_movi_clpr_sucu_nume_item,
       v_movi_fech_emis,
       v_movi_fech_oper,
    --v_movi_fech_orig,
       v_movi_oper_codi,
       v_movi_mone_codi,
    --   v_movi_mone_cant_deci,
       v_movi_tasa_mone,
       v_movi_indi_inte,
       v_movi_obse,
       v_movi_nume_timb,
       v_movi_ortr_codi,
       v_movi_clpr_ruc,
       v_movi_empl_codi,
       v_movi_impo_codi,
       v_movi_depo_codi_orig,
       v_movi_orpa_codi,
      -- v_movi_depo_codi_alte,
       v_movi_codi_rete,
       v_movi_fech_grab,
       v_movi_user,
       v_movi_exen_mone,
       v_movi_exen_mmnn,
       v_movi_grav_mone,
       v_movi_grav_mmnn,
       v_movi_iva_mone,
       v_movi_iva_mmnn
  from come_movi
 where movi_codi =p_movi_codi;

pa_devu_fech_habi(parameter.p_fech_inic,parameter.p_fech_fini );



  v_fech := v_movi_fech_oper;
  v_movi_fech_orig := v_movi_fech_emis;
   SETITEM('P20_FECH', V_FECH);
   SETITEM('P20_MOVI_FECH_ORIG', V_MOVI_FECH_ORIG);
    
if V_MOVI_TIMO_CODI is not null then 
   i020102.pp_muestra_tipo_movi(v_movi_timo_codi,
                                v_timo_desc      ,           
                                v_timo_emit_reci , 
                                v_movi_oper_codi , 
                                v_timo_indi_caja ,
                                v_timo_afec_sald );

    SETITEM('P20_TIMO_DESC', v_timo_desc);
    SETITEM('P20_TIMO_EMIT_RECI', V_TIMO_EMIT_RECI);
    SETITEM('P20_MOVI_OPER_CODI', V_MOVI_OPER_CODI);
    SETITEM('P20_TIMO_INDI_CAJA', V_TIMO_INDI_CAJA);
    SETITEM('P20_TIMO_AFEC_SALD', V_TIMO_AFEC_SALD);
end if;

if v_movi_sucu_codi_orig is not null then
  i020102.pp_mostrar_sucursal(p_sucu_codi => v_movi_sucu_codi_orig,
                              p_sucu_desc => v_sucu_desc);
   SETITEM('P20_SUCU_DESC', V_SUCU_DESC);
end if;


if v_movi_depo_codi_orig is not null then
  I020102.pp_mostrar_depo_orig(p_depo_codi              => v_movi_depo_codi_orig,
                               p_depo_desc              => v_movi_depo_desc,
                               p_depo_codi_alte         => v_movi_depo_codi_alte);
    SETITEM('P20_MOVI_DEPO_DESC', v_movi_depo_desc);
    SETITEM('P20_DEPO_CODI_ALTE', v_movi_depo_codi_alte);

end if;


if v_movi_clpr_codi is not null then
  I020102.pp_mostrar_clpr_query(p_clpr_codi      => v_movi_clpr_codi,
                                p_clpr_desc      => v_clpr_desc,
                                p_clpr_codi_alte => v_clpr_codi_alte,
                                p_indi_clie_prov => v_indi_clie_prov);
                                
                                
    SETITEM('P20_CLPR_DESC', V_CLPR_DESC);                             
    SETITEM('P20_CLPR_CODI_ALTE', V_CLPR_CODI_ALTE);                            
    SETITEM('P20_INDI_CLIE_PROV', V_INDI_CLIE_PROV);                           
end if;        

if v_movi_clpr_sucu_nume_item is not null then

  I020102.pp_muestra_clpr_sub_cuenta(p_cliente                  => v_movi_clpr_codi,
                                     p_movi_clpr_sucu_nume_item => v_movi_clpr_sucu_nume_item,
                                     p_subc_desc                => v_subc_desc);
   SETITEM('P20_SUBC_DESC', V_SUBC_DESC);                                  
end if;
                

if v_movi_nume is not null then
  pp_mostrar_numero (v_movi_nume, 
                     v_s_nro_1, 
                     v_s_nro_2, 
                     v_s_nro_3 );
                     
        SETITEM('P20_S_NRO_1', V_S_NRO_1); 
        SETITEM('P20_S_NRO_2', V_S_NRO_2); 
        SETITEM('P20_S_NRO_3', V_S_NRO_3);              
          
end if;
  
  if v_movi_mone_codi is not null then
    general_skn.pl_muestra_come_mone (v_movi_mone_codi,
                                      v_movi_mone_desc ,  
                                      v_movi_mone_desc_abre, 
                                      v_movi_mone_cant_deci);
                                      
                 
        SETITEM('P20_MOVI_MONE_DESC', V_MOVI_MONE_DESC); 
        SETITEM('P20_MOVI_MONE_DESC_ABRE', V_MOVI_MONE_DESC_ABRE); 
        SETITEM('P20_MOVI_MONE_CANT_DECI', V_MOVI_MONE_CANT_DECI);              
                                             
                                      
  end if;

 
  if v_movi_codi_rete is not null then
      I020102.pp_mostrar_rete(p_movi_codi_rete => v_movi_codi_rete,
                              p_nume_rete      => v_nume_rete,
                              p_impo_rete      => v_impo_rete);
                              
      
      SETITEM('P20_NUME_RETE', V_NUME_RETE);
      SETITEM('P20_IMPO_RETE', V_IMPO_RETE);                          
  end if; 


   if v_movi_empl_codi  is not null then
    I020102.pp_mostrar_empleado(v_movi_empl_codi, v_empl_desc);
    SETITEM('P20_EMPL_DESC', V_EMPL_DESC); 
  end if;
  

  if v_movi_ortr_codi is not null then
    I020102.pp_mostrar_ot_query (v_ortr_nume, v_movi_ortr_codi);
    parameter.p_ortr_codi := v_movi_ortr_codi;
    SETITEM('P20_ORTR_NUME', V_ORTR_NUME); 
    
  end if;
  
  if v_movi_timo_codi in (1,2,39,45) then
   I020102.pp_mostrar_nume_ot_fact(v_movi_codi,  v_deta_ortr_nume, v_deta_ortr_codi);
  SETITEM('P20_DETA_ORTR_NUME', V_DETA_ORTR_NUME); 
  SETITEM('P20_DETA_ORTR_CODI', V_DETA_ORTR_CODI); 
  SETITEM('P20_DETA_ORTR_CODI_ORIG', V_DETA_ORTR_CODI); 
  end if; 
  
 
   I020102.pp_validar_tipo_movi(v_movi_timo_codi,
                                v_movi_codi_padr);
  

  I020102.pp_mostrar_importe (v_movi_codi     ,
                              v_s_exen        ,
                              v_s_grav_10_ii  ,
                              v_s_grav_5_ii   ,
                              v_s_iva_10      ,
                              v_s_iva_5       ,
                              v_s_tot_iva     ,
                              v_s_total);
                                  
                                  
        SETITEM('P20_S_EXEN', V_S_EXEN);
        SETITEM('P20_S_GRAV_10_II', V_S_GRAV_10_II);
        SETITEM('P20_S_GRAV_5_II', V_S_GRAV_5_II);
        SETITEM('P20_S_IVA_10', V_S_IVA_10);
        SETITEM('P20_S_IVA_5', V_S_IVA_5); 
        SETITEM('P20_S_TOT_IVA', V_S_TOT_IVA);
        SETITEM('P20_S_TOTAL', V_S_TOTAL);                        
                                  
 ---bloquear cualquier modificaci?n si est? fuera del rango de fecha permitida
   if v_movi_fech_emis not between parameter.p_fech_inic and parameter.p_fech_fini then
      apex_application.g_print_success_message := 'Periodo no este habilitado,no se podra realizar modificaciones!';
     v_indi_bloq := 'S';
      SETITEM('P20_INDI_BLOQ', v_INDI_BLOQ); 
      
  end if;
  
  
  ---si afecta caja, y si el detalle no es solo efectivo, tampoco se podr? modificar
 if nvl(v_timo_indi_caja, 'N')  = 'S' then
    select count(*)
    into v_count
    from come_movi_impo_deta
    where upper(substr(ltrim(rtrim(moim_tipo)),1,3)) <> 'EFE'
    and moim_movi_codi =v_movi_codi;
    
    if v_count > 0 then
      apex_application.g_print_success_message :='Solo se pueden modificar movimientos con forma de pago Efectivo';
        v_indi_bloq := 'S';
    end if; 
 
 
      ---si al menos existe un detalle de impo_deta que este en un cierre de caja
      select count(*)
      into v_count
      from come_movi_impo_deta
      where moim_movi_codi = v_movi_codi
      and moim_caja_codi is not null;
      
      if v_count > 0 then
        select c.caja_nume, c.caja_fech
          into v_cier_nume, v_fech_cier
          from come_cier_caja c, come_cier_caja_deta a
         where c.caja_codi = a.cade_caja_codi
           and a.cade_moim_movi_codi =v_movi_codi
        group by c.caja_nume, c.caja_fech;
        
         apex_application.g_print_success_message :='El Documento no se puede modificar, debido que se encuentre relacionado al cierre de la caja '||v_cier_nume||' con fecha '||to_char(v_fech_cier,'dd-mm-yyyy')||'.';       
          v_indi_bloq := 'S';  
      end if; 
 end if;  
  
SETITEM('P20_MOVI_BASE', V_MOVI_BASE);
SETITEM('P20_MOVI_CODI', V_MOVI_CODI);
SETITEM('P20_MOVI_EMPR_CODI', V_MOVI_EMPR_CODI);
SETITEM('P20_MOVI_SUCU_CODI_ORIG', V_MOVI_SUCU_CODI_ORIG);
SETITEM('P20_MOVI_TIMO_CODI', V_MOVI_TIMO_CODI);
SETITEM('P20_MOVI_NUME', V_MOVI_NUME);
SETITEM('P20_MOVI_CLPR_CODI', V_MOVI_CLPR_CODI);
SETITEM('P20_MOVI_CLPR_SUCU_NUME_ITEM', V_MOVI_CLPR_SUCU_NUME_ITEM);
SETITEM('P20_MOVI_FECH_EMIS', V_MOVI_FECH_EMIS);
SETITEM('P20_MOVI_FECH_OPER', V_MOVI_FECH_EMIS);----------fecha emi
SETITEM('P20_MOVI_FECH_ORIG', V_MOVI_FECH_ORIG);
SETITEM('P20_MOVI_OPER_CODI', V_MOVI_OPER_CODI);
SETITEM('P20_MOVI_MONE_CODI', V_MOVI_MONE_CODI);
SETITEM('P20_MOVI_MONE_CANT_DECI', V_MOVI_MONE_CANT_DECI);
SETITEM('P20_MOVI_TASA_MONE', V_MOVI_TASA_MONE);
SETITEM('P20_MOVI_INDI_INTE', V_MOVI_INDI_INTE);
SETITEM('P20_MOVI_OBSE', V_MOVI_OBSE);
SETITEM('P20_MOVI_NUME_TIMB', V_MOVI_NUME_TIMB);
SETITEM('P20_MOVI_ORTR_CODI', V_MOVI_ORTR_CODI);
SETITEM('P20_MOVI_CLPR_RUC', V_MOVI_CLPR_RUC);
SETITEM('P20_MOVI_EMPL_CODI', V_MOVI_EMPL_CODI);
SETITEM('P20_MOVI_IMPO_CODI', V_MOVI_IMPO_CODI);
SETITEM('P20_MOVI_DEPO_CODI_ORIG', V_MOVI_DEPO_CODI_ORIG);
SETITEM('P20_MOVI_ORPA_CODI', V_MOVI_ORPA_CODI);
SETITEM('P20_MOVI_DEPO_CODI_ALTE', V_MOVI_DEPO_CODI_ALTE);
SETITEM('P20_MOVI_CODI_RETE', V_MOVI_CODI_RETE);
SETITEM('P20_MOVI_FECH_GRAB', V_MOVI_FECH_GRAB);
SETITEM('P20_MOVI_USER', V_MOVI_USER);
SETITEM('P20_MOVI_EXEN_MONE', V_MOVI_EXEN_MONE);
SETITEM('P20_MOVI_EXEN_MMNN', V_MOVI_EXEN_MMNN);
SETITEM('P20_MOVI_GRAV_MONE', V_MOVI_GRAV_MONE);
SETITEM('P20_MOVI_GRAV_MMNN', V_MOVI_GRAV_MMNN);
SETITEM('P20_MOVI_IVA_MONE', V_MOVI_IVA_MONE);
SETITEM('P20_MOVI_IVA_MMNN', V_MOVI_IVA_MMNN);


  APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name =>'DETA_ARTI');
  APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name =>'DETA_CONC');


  I020102.pp_cargar_bloq_prod(p_movi_codi => p_movi_codi,
                              p_cant_deci => v_movi_mone_cant_deci);

  I020102.pp_cargar_bloq_conc(p_movi_codi => p_movi_codi,
                              p_cant_deci => v_movi_mone_cant_deci);


end pp_consultar_docu;

/*
declare
  v_count       number;
  v_cier_nume   number;
  v_fech_cier   date;
  v_indi_bloq   varchar2(1) := 'N';
begin
  
 --*if :bcab.movi_fech_emis is not null then
  --* :bcab.s_movi_fech_emis  := to_char(:bcab.movi_fech_emis , 'dd-mm-yyyy');  
 --*  :bcab.s_fech := to_char(:bcab.movi_fech_emis , 'dd-mm-yyyy');
   :bcab.fech := :bcab.movi_fech_emis;----------------revisar
   
  --* :bcab.movi_fech_orig := :bcab.movi_fech_emis;
  --*end if;

\*  if :bcab.movi_depo_codi_orig is not null then
     pp_mostrar_depo_orig(:bcab.movi_depo_codi_orig, :bcab.movi_depo_desc, :bcab.movi_depo_codi_alte); 
  else
    :bcab.movi_depo_desc := null;
  end if;*\

 --* if :bcab.movi_clpr_codi is not null then   
  --*  pp_mostrar_clpr_query ( :bcab.movi_clpr_codi, :bcab.clpr_desc, :bcab.clpr_codi_alte, :bcab.indi_clie_prov);    
  ---*end if;

  --if :bcab.movi_timo_codi is not null then
   --  pp_muestra_tipo_movi;
 -- end if;
  
 -- if :bcab.movi_clpr_sucu_nume_item is not null then
  --   pp_muestra_clpr_sub_cuenta;
 -- end if;
  
 -- if :bcab.movi_nume is not null then
 --   pp_mostrar_numero (:bcab.movi_nume, :bcab.s_nro_1, :bcab.s_nro_2, :bcab.s_nro_3 );  
--  end if;
  
--  if :bcab.movi_mone_codi is not null then
 --   pl_muestra_come_mone (:bcab.movi_mone_codi,:bcab.movi_mone_desc ,  :bcab.movi_mone_desc_abre, :bcab.movi_mone_cant_deci);
  --end if;

 -- if :bcab.movi_empr_codi is not null then
 --    pp_mostrar_empresa(:bcab.movi_empr_codi, :bcab.empr_desc);
 --end if; 
  
 -- if:bcab.movi_codi_rete is not null then
  --   pp_mostrar_rete;
 -- end if; 

  if :bcab.movi_timo_codi in (5,6,51) then
    set_item_property('bcab.nume_rete', enabled, property_true);
    set_item_property('bcab.nume_rete', navigable, property_true);
  else  
    set_item_property('bcab.nume_rete', enabled, property_false);
  end if; 
  
  if :bcab.movi_timo_codi in (5,43) then
    set_item_property('bcab.clpr_codi_alte_nvo', enabled, property_true);
    set_item_property('bcab.clpr_codi_alte_nvo', navigable, property_true);
  else
    set_item_property('bcab.clpr_codi_alte_nvo', enabled, property_false);
    set_item_property('bcab.clpr_desc_nvo', enabled, property_false);
  end if; 

  if :bcab.movi_timo_codi in (1,2,3,4,29) then
    set_item_property('bcab.MOVI_CLPR_SUCU_NUME_ITEM', enabled, property_true);
    set_item_property('bcab.MOVI_CLPR_SUCU_NUME_ITEM', navigable, property_true);
  else
    set_item_property('bcab.MOVI_CLPR_SUCU_NUME_ITEM', enabled, property_false);
  end if; 
  
  if :bcab.movi_oper_codi in (5,6) then
    if get_item_property('bcab.s_movi_depo_codi_alte', enabled) = 'FALSE' then
      set_item_property('bcab.s_movi_depo_codi_alte', enabled, property_true);
      set_item_property('bcab.s_movi_depo_codi_alte', navigable, property_true);
      set_item_property('bpie.articulos', enabled, property_true);
    end if;
  else
    if get_item_property('bcab.s_movi_depo_codi_alte', enabled) = 'TRUE' then
      set_item_property('bcab.s_movi_depo_codi_alte', enabled, property_false);
      set_item_property('bpie.articulos', enabled, property_false);
    end if;
  end if; 

  --if :bcab.movi_empl_codi  is not null then
 --   pp_mostrar_empleado(:bcab.movi_empl_codi, :bcab.empl_desc);
--  else
  --  :bcab.empl_desc := null;
 -- end if;
  
 -- if :bcab.movi_sucu_codi_orig  is not null then
  --  pp_mostrar_sucursal(:bcab.movi_sucu_codi_orig, :bcab.sucu_desc);
 -- else
 --   :bcab.sucu_desc := null;
 -- end if;

 --if :bcab.movi_ortr_codi is not null then
 --   pp_mostrar_ot_query (:bcab.ortr_nume, :bcab.movi_ortr_codi);
 --   :parameter.p_ortr_codi := :bcab.movi_ortr_codi;
 -- end if;

  if :bcab.movi_timo_codi in (1,2,39,45) then
   set_item_property('bcab.deta_ortr_nume', enabled, property_true);
   set_item_property('bcab.deta_ortr_nume', update_allowed, property_true);
   
   set_item_property('bcab.ortr_nume', enabled, property_false);
   
   set_item_property('bpie.borrar_ot', enabled, property_true);
   set_item_property('bpie.guardar_ot', enabled, property_true);
   
  --- pp_mostrar_nume_ot_fact(:bcab.movi_codi,  :bcab.deta_ortr_nume, :bcab.deta_ortr_codi);
   :bcab.deta_ortr_codi_orig := :bcab.deta_ortr_codi;
   
   if :bcab.deta_ortr_codi_orig is null then
     set_item_property('bcab.deta_ortr_nume', enabled, property_true);
   else
    set_item_property('bcab.deta_ortr_nume', enabled, property_false);
    set_item_property('bpie.borrar_ot', enabled, property_true);
    set_item_property('bpie.guardar_ot', enabled, property_true);
   end if;  
  else
   set_item_property('bcab.deta_ortr_nume', enabled, property_false);
   set_item_property('bcab.ortr_nume', enabled, property_true);
  end if; 
  
  if :bsel.s_timo_codi in (1,2,4,5,6,7,8,39) then
      --bloquera modificacion de fecha si est? fuera del rango permitido
      if :bcab.movi_fech_emis not between :parameter.p_fech_inic and :parameter.p_fech_fini then
        set_item_property('bcab.s_fech', enabled, property_false) ;
      else
        set_item_property('bcab.s_fech', enabled, property_true);
      end if; 
  else
    set_item_property('bcab.s_fech', enabled, property_false);
  end if;

  pp_validar_tipo_movi;
  
  pp_mostrar_importe (:bcab.movi_codi);
  pp_formatear_importes;

--pl_mm(':parameter.p_fech_inic '||:parameter.p_fech_inic);
--pl_mm(':parameter.p_fech_fini '||:parameter.p_fech_fini);

---bloquear cualquier modificaci?n si est? fuera del rango de fecha permitida
  if :bcab.movi_fech_emis not between :parameter.p_fech_inic and :parameter.p_fech_fini then
      pl_mm('Periodo no est? habilitado,no se podr? realizar modificaciones!');
      v_indi_bloq := 'S';
  end if;
  
---si afecta caja, y si el detalle no es solo efectivo, tampoco se podr? modificar
 if nvl(:bcab.timo_indi_caja, 'N')  = 'S' then
    select count(*)
    into v_count
    from come_movi_impo_deta
    where upper(substr(ltrim(rtrim(moim_tipo)),1,3)) <> 'EFE'
    and moim_movi_codi = :bcab.movi_codi;
    
    if v_count > 0 then
        pl_mm('Solo se pueden modificar movimientos con forma de pago Efectivo');
        v_indi_bloq := 'S';
        set_item_property('bcab.s_fech', enabled, property_false);
    end if; 
 
 
      ---si al menos existe un detalle de impo_deta que est? en un cierre de caja
      select count(*)
      into v_count
      from come_movi_impo_deta
      where moim_movi_codi = :bcab.movi_codi
      and moim_caja_codi is not null;
      
      if v_count > 0 then
        select c.caja_nume, c.caja_fech
          into v_cier_nume, v_fech_cier
          from come_cier_caja c, come_cier_caja_deta a
         where c.caja_codi = a.cade_caja_codi
           and a.cade_moim_movi_codi = :bcab.movi_codi
        group by c.caja_nume, c.caja_fech;
        
          pl_mm('El Documento no se puede modificar, debido que se encuentre relacionado al cierre de la caja '||v_cier_nume||' con fecha '||to_char(v_fech_cier,'dd-mm-yyyy')||'.');       
          v_indi_bloq := 'S';
          set_item_property('bcab.s_fech', enabled, property_false);        
      end if; 

      if nvl(v_indi_bloq, 'N') = 'S' then
          set_item_property('bpie.aceptar', enabled, property_false) ;
          set_item_property('bpie.CONCEPTO', enabled, property_false) ;
          set_item_property('bpie.ARTICULOS', enabled, property_false) ;
          set_item_property('bpie.BORRAR_OT', enabled, property_false) ;
          set_item_property('bpie.GUARDAR_OT', enabled, property_false) ;
      else
          set_item_property('bpie.aceptar', enabled, property_true);
          set_item_property('bpie.CONCEPTO', enabled, property_true) ;
          set_item_property('bpie.ARTICULOS', enabled, property_true) ;     
          set_item_property('bpie.BORRAR_OT', enabled, property_true) ;
          set_item_property('bpie.GUARDAR_OT', enabled, property_true) ;
      end if; 

 end if;  
 
end;
*/

procedure pp_muestra_tipo_movi (p_tipo_movi      in number,
                                p_timo_desc      out varchar2,           
                                p_timo_emit_reci out varchar2, 
                                p_movi_oper_codi out varchar2, 
                                p_timo_indi_caja out varchar2,
                                p_timo_afec_sald out varchar2) is
                    
begin

    select a.timo_desc, 
           a.timo_emit_reci, 
           a.timo_codi_oper, 
           a.timo_indi_caja, 
           a.timo_afec_sald
    into   p_timo_desc, 
           p_timo_emit_reci, 
           p_movi_oper_codi, 
           p_timo_indi_caja, 
           p_timo_afec_sald          
    from come_tipo_movi a
    where  timo_codi = p_tipo_movi;

Exception
   when no_data_found then
     raise_application_error(-20001, 'Tipo de Movimiento inexistente o no habilitada para esta pantalla');

End;

procedure pp_mostrar_sucursal (p_sucu_codi in number, p_sucu_desc out varchar2) is
begin
 
  select b.sucu_desc
  into p_sucu_desc
  from come_sucu b
  where b.sucu_codi = p_sucu_codi;
  
exception
	  when no_data_found then
	     raise_application_error(-20001, 'Sucursal inexistente');

end pp_mostrar_sucursal;

procedure pp_mostrar_depo_orig (p_depo_codi      in number,
                                p_depo_desc      out varchar2,
                                p_depo_codi_alte  out varchar2) is
begin
 
  select d.depo_desc, d.depo_codi_alte
    into p_depo_desc, p_depo_codi_alte
    from come_depo d 
   where d.depo_codi = p_depo_codi;
  
Exception
    When no_data_found then
       raise_application_error(-20001, 'Deposito inexistente');
  
  
end pp_mostrar_depo_orig;

Procedure pp_mostrar_clpr_query(p_clpr_codi      in number,
                                p_clpr_desc      out char,
                                p_clpr_codi_alte out char,
                                p_indi_clie_prov out varchar2) is
begin
  select clpr_desc, clpr_codi_alte, clpr_indi_clie_prov
    into p_clpr_desc, p_clpr_codi_alte, p_indi_clie_prov
    from come_clie_prov
   where clpr_codi = p_clpr_codi;

Exception
  when no_data_found then
  
    raise_application_error(-20001, 'Cliente/Proveedor inexistente!');
  
end pp_mostrar_clpr_query;

Procedure pp_muestra_clpr_sub_cuenta(p_cliente                  in number,
                                     p_movi_clpr_sucu_nume_item in number,
                                     p_subc_desc                out varchar2) is
begin
	select sucu_desc
		into p_subc_desc
	  from come_clpr_sub_cuen
	 where sucu_clpr_codi = p_cliente
	   and sucu_nume_item = p_movi_clpr_sucu_nume_item;

Exception
  when no_data_found then
      raise_application_error(-20001, 'SubCuenta de Cliente inexistente!');

end pp_muestra_clpr_sub_cuenta;

procedure pp_mostrar_numero (p_anul_nume in number, 
                             p_nume_1    out varchar2, 
                             p_nume_2    out varchar2, 
                             p_nume_3    out varchar2 ) is
v_anul_nume varchar2(13);
begin
 
  
 v_anul_nume := lpad(to_char (p_anul_nume),13,'0');
 

 p_nume_1 := substr(v_anul_nume,1, 3);
 p_nume_2 := substr(v_anul_nume,4, 3); 
 p_nume_3 := substr(v_anul_nume,7, 7);

Exception
  when no_data_found then
       raise_application_error(-20001,'N?mero inexistente!');

end pp_mostrar_numero;

procedure pp_mostrar_rete (p_movi_codi_rete in varchar2,
                           p_nume_rete      out varchar2,
                           p_impo_rete      out varchar2) is
begin
  
  select movi_nume, movi_exen_mone
  into p_nume_rete, p_impo_rete
  from come_movi
  where movi_codi = p_movi_codi_rete;
  
Exception
	 When no_data_found then
	  raise_application_error(-20001,'Retenci?n inexistente');
  
end pp_mostrar_rete;

procedure pp_mostrar_empleado (p_codi in number, p_desc out varchar2) is
begin
  select  empl_desc
  into p_desc
  from come_empl
  where empl_codi = p_codi;
  
Exception
	  When no_data_found then
	    raise_application_error(-20001, 'Empleado inexistente');

end pp_mostrar_empleado;

Procedure pp_mostrar_ot_query (p_ortr_nume out varchar2, p_ortr_codi in number) is
begin
     select ortr_nume
     into   p_ortr_nume
     from   come_orde_trab
     where  ortr_codi = p_ortr_codi;
                    
Exception
  when no_data_found then
     raise_application_error(-20001, 'N? de Ot inexistente');
 
end pp_mostrar_ot_query;

procedure pp_mostrar_nume_ot_fact (p_movi_codi in number, p_ortr_nume out varchar2, p_ortr_codi out number) is
v_ortr_codi number;

Begin
   select deta_ortr_codi
     into v_ortr_codi
    from come_movi_ortr_deta
    where deta_movi_codi = p_movi_codi;
   
        begin
         select ortr_nume
         into p_ortr_nume
         from come_orde_trab
         where  ortr_codi = v_ortr_codi;
           p_ortr_codi := v_ortr_codi;
        Exception
            when no_data_found then
               p_ortr_codi := null;
               p_ortr_nume := null;
        end;

   
   Exception
      When no_data_found then
        p_ortr_codi := null;
        p_ortr_nume := null;
   
end pp_mostrar_nume_ot_fact;

procedure pp_validar_tipo_movi (p_movi_timo_codi  in number,
                                p_movi_codi_padr  in number) is
  v_movi_timo_codi number;
begin
  -- si es una factura credito emitida
  if p_movi_timo_codi = parameter.p_codi_timo_fcre then
    if p_movi_codi_padr is not null then
      begin
        select m.movi_timo_codi
          into v_movi_timo_codi
          from come_movi m
         where m.movi_codi = p_movi_codi_padr;
        
        -- si el padre de la factura es una liquidacion de prestamo
        if v_movi_timo_codi = parameter.p_codi_timo_pres_emit then
          null;
         -- set_item_property('bcab.s_fech', enabled   , property_true);
         -- set_item_property('bcab.s_fech', updateable, property_true);
        end if;
      exception
        when no_data_found then
          null;
      end;
    end if;
  end if;
end pp_validar_tipo_movi;


procedure pp_mostrar_importe (p_movi_codi     in number,
                              p_s_exen        out varchar2,
                              p_s_grav_10_ii  out varchar2,
                              p_s_grav_5_ii   out varchar2,
                              p_s_iva_10      out varchar2,
                              p_s_iva_5       out varchar2,
                              p_s_total       out varchar2,
                              p_s_tot_iva     out varchar2) is 

cursor c_impo is 
  
  select moim_impu_codi,
         nvl(moim_impo_mone, 0) moim_impo_mone,
         nvl(moim_impu_mone, 0) moim_impu_mone
  from   come_movi_impu_deta
  where  moim_movi_codi = p_movi_codi
  order by moim_impu_codi;
   
begin
p_s_exen        := 0;
p_s_grav_10_ii  := 0;
p_s_grav_5_ii   := 0;
p_s_iva_10      := 0;
p_s_iva_5       := 0;

    
    for x in c_impo loop
      if x.moim_impu_codi = 1 then
        p_s_exen := (x.moim_impo_mone + x.moim_impu_mone);
        
      elsif x.moim_impu_codi = 2 then
        p_s_grav_10_ii  := (x.moim_impo_mone + x.moim_impu_mone);
        p_s_iva_10      := x.moim_impu_mone;
      elsif x.moim_impu_codi = 3 then
        p_s_grav_5_ii   := (x.moim_impo_mone + x.moim_impu_mone);
        p_s_iva_5       := x.moim_impu_mone;
      end if;
    end loop;



    p_s_total   := nvl(p_s_exen,0)+ nvl(p_s_grav_10_ii,0) +nvl(p_s_grav_5_ii,0) ;
    p_s_tot_iva :=nvl(p_s_iva_5,0) + nvl(p_s_iva_10,0);
Exception
  when no_data_found then
      raise_application_error(-20001, 'Importe inexistente!');
end pp_mostrar_importe;

procedure pp_validar_nro (p_movi_nume in number,
                          p_movi_timo_codi in number,
                          p_movi_empr_codi in number) is
v_count number;
salir exception;
  
begin                                   
    select count(*)
    into v_count
    from come_movi
    where  movi_nume = p_movi_nume    
    and movi_timo_codi = p_movi_timo_codi
    and nvl(movi_empr_codi,1) = nvl(p_movi_empr_codi,1);
   
    
    if v_count > 0 then  
       raise_application_error(-20001, 'Atencion!!! . Ya existe un comprobante vigente en el sistema con este n?mero, favor verifique!!');
    end if;    
   
    select count(*)
    into v_count
    from come_movi_anul
    where  anul_nume =p_movi_nume    
    and anul_timo_codi = p_movi_timo_codi
    and nvl(anul_empr_codi,1) = nvl(p_movi_empr_codi,1);
   
   
     if v_count > 0 then  
       raise_application_error(-20001, 'Atencion!!! . Ya existe un comprobante registrado como anulado  con este n?mero, favor verifique!!');
    end if;  

--exception    
	--when others then
  -- raise_application_error(-20001,'Reingrese el nro de comprobante'); 
  
end pp_validar_nro;


Procedure pp_mostrar_clpr (p_indi_clie_prov in char, 
                           p_clpr_codi in number, 
                           p_clpr_desc out char) is
v_clpr_codi_alte_nvo number;
begin 
  if p_clpr_codi is not null then
    
     select clpr_desc, clpr_codi_alte
     into   p_clpr_desc, v_clpr_codi_alte_nvo
     from   come_clie_prov
     where  clpr_codi = p_clpr_codi
     and    clpr_indi_clie_prov  = p_indi_clie_prov;
end if; 

if p_indi_clie_prov = 'C' then
  if v_clpr_codi_alte_nvo = parameter.p_codi_clie_espo then
    null;--set_item_property('bcab.clpr_desc_nvo', enabled, property_true);
     null;--set_item_property('bcab.clpr_desc_nvo', navigable, property_true);    
  else
    null;--  set_item_property('bcab.clpr_desc_nvo', enabled, property_false);
  end if; 
  
elsif p_indi_clie_prov = 'P'   then

  if v_clpr_codi_alte_nvo = parameter.p_codi_prov_espo then
   null;-- set_item_property('bcab.clpr_desc_nvo', enabled, property_true);
    null;-- set_item_property('bcab.clpr_desc_nvo', navigable, property_true);    
  else
    null;--  set_item_property('bcab.clpr_desc_nvo', enabled, property_false);
  end if; 

end if; 
Exception
  when no_data_found then
   
     if p_indi_clie_prov = 'P' then
       raise_application_error(-20001,'Proveedor inexistente!');
     else
     	raise_application_error(-20001,'Cliente inexistente!');
     end if;	 

end pp_mostrar_clpr;





procedure pp_validar_fecha (p_movi_codi        in number,
                            p_fech             in out date,
                            p_movi_fech_emis   in date,
                            p_movi_timo_codi   in number,
                            p_movi_fech_orig   in date,
                            p_s_fech           out date ) is
  

  v_movi_timo_codi number;
  v_mini_fech_venc date;
  cursor c_moim is 
  select moim_cuen_codi, moim_fech
  from come_movi_impo_deta
  where moim_movi_codi = p_movi_codi;
  
  v_Count number;
begin

             
  if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
  	 	raise_application_error(-20001,'La fecha del movimiento debe estar comprendida entre..'||
  	      to_char(parameter.p_fech_inic, 'dd-mm-yyyy') 
  	      ||' y '||to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
  end if;	
                          

  
  if p_fech is not null then
    if p_fech <> p_movi_fech_emis then
       
      -- si es una factura credito emitida
     for x in c_moim loop
        
        select count(*)
        into v_count
        from come_cier_caja
        where caja_cuen_codi = x.moim_cuen_codi
        and caja_fech = p_fech;
        
        if v_count >= parameter.p_cant_cier_caja then
            	raise_application_error(-20001,'Ya existe/n '||v_count||' cierre/s de caja/s para esta fecha');
        end if; 
        
        
     end loop;
      
      if p_movi_timo_codi in (2,4,6,8) then
      --if :bcab.movi_timo_codi = :parameter.p_codi_timo_fcre then
        /*if :bcab.movi_codi_padr is not null then
            begin
              select m.movi_timo_codi
                into v_movi_timo_codi
                from come_movi m
               where m.movi_codi = :bcab.movi_codi_padr;            
            exception
              when no_data_found then
                v_movi_timo_codi := null;
            end;
            
            -- si el padre de la factura es una liquidacion de prestamo
            if v_movi_timo_codi = :parameter.p_codi_timo_pres_emit then*/
              
      --------- buscamos el primer vencimiento de las cuotas -----------------
              begin
                select min(c.cuot_fech_venc)
                  into v_mini_fech_venc
                  from come_movi_cuot c
                 where c.cuot_movi_codi = p_movi_codi;
              
                if v_mini_fech_venc is null then
                  begin
                    select min(c.cupe_fech_venc)
                      into v_mini_fech_venc
                      from come_movi_cuot_pres c
                     where c.cupe_movi_codi = p_movi_codi;
                  exception
                    when no_data_found then
                      v_mini_fech_venc := null;
                  end;
                end if;
              exception
                when no_data_found then
                  begin
                    select min(c.cupe_fech_venc)
                      into v_mini_fech_venc
                      from come_movi_cuot_pres c
                     where c.cupe_movi_codi = p_movi_codi;
                  exception
                    when no_data_found then
                      v_mini_fech_venc := null;
                  end;
              end;
       
              if v_mini_fech_venc is not null then
                if p_fech > v_mini_fech_venc then
                  	raise_application_error(-20001,'La fecha indicada no puede ser mayor al primer vencimiento de cuotas');
                  if p_movi_fech_orig is not null then
                    p_s_fech := to_char(p_movi_fech_orig , 'dd-mm-yyyy');
                    p_fech   := p_movi_fech_orig;
                  end if;
                end if;
                
              end if;
            --end if;
        --end if;
      end if;
    end if;
  end if;
  
end pp_validar_fecha;

procedure pp_mostrar_ot (p_ortr_nume in varchar2, p_ortr_codi out number) is
begin
     select ortr_codi
     into   p_ortr_codi
     from   come_orde_trab
     where  ortr_nume = p_ortr_nume;

                        
Exception
  when no_data_found then
    raise_application_error(-20001,'N? de Ot inexistente');

end;


procedure pp_mostrar_importacion (p_nume in number, p_codi out number) is
begin
  select  impo_codi
  into p_codi
  from come_impo
  where impo_nume = p_nume;
  
Exception
	  When no_data_found then
	    raise_application_error(-20001,'Importacion inexistente');    
  
end pp_mostrar_importacion;

procedure pp_nuevo_deposito ( p_s_movi_depo_codi_alte   in varchar2,
                              p_movi_depo_codi_alte     in varchar2,
                              p_s_movi_depo_codi_orig   out varchar2,
                              p_s_movi_depo_desc        out varchar2)is
  
begin
if p_s_movi_depo_codi_alte is not null then
  if p_s_movi_depo_codi_alte <> p_movi_depo_codi_alte then
    
    declare
      v_depo_codi number;
    begin
      select depo_codi, depo_desc
        into p_s_movi_depo_codi_orig, p_s_movi_depo_desc
        from come_depo 
       where depo_codi_alte = p_s_movi_depo_codi_alte;
           
        ------------  pp_cargar_bloq_prod;------------revisar luego
          if nvl(parameter.p_indi_exis_prod,'N') = 'S' then
            null;
          else
             raise_application_error(-20001,'El Documento no posee articulos asignados,no se puede modificar el deposito!');
          end if;

    exception
      when no_data_found then
        raise_application_error(-20001,'Deposito Inexistente!');
    end;
 
  end if;
end if;

end pp_nuevo_deposito;
/*
procedure pp_cargar_bloq_prod is

cursor c_movi_prod is
   select deta_movi_codi        , 
          deta_nume_item        ,
          deta_impu_codi        ,
          deta_prod_codi        ,
          deta_cant             ,
          deta_obse             ,
          deta_porc_deto        ,
          deta_impo_mone        ,
          deta_impo_mmnn        ,
          deta_impo_mmee        ,
          deta_iva_mmnn         ,
          deta_iva_mmee         ,
          deta_iva_mone         ,
          deta_prec_unit        ,
          deta_movi_codi_padr   ,
          deta_nume_item_padr   ,
          deta_impo_mone_deto_nc,
          deta_movi_codi_deto_nc,
          deta_list_codi        ,
          deta_movi_clave_orig  ,
          deta_impo_mmnn_deto_nc,
          deta_base             ,
          deta_lote_codi        ,
          deta_movi_orig_codi   ,
          deta_movi_orig_item   ,
          deta_impo_mmee_deto_nc,
          deta_asie_codi        ,
          deta_cant_medi        ,
          deta_medi_codi        ,
          deta_remi_codi        ,
          deta_remi_nume_item   ,
          deta_bien_codi        ,
          deta_prec_unit_list   ,
          deta_impo_deto_mone   ,
          deta_porc_deto_prec   ,
          deta_bene_codi        ,
          deta_ceco_codi        ,
          deta_clpr_codi        ,
          deta_impo_mone_ii     ,
          deta_impo_mmnn_ii     ,
          deta_grav10_ii_mone   ,
          deta_grav5_ii_mone    ,
          deta_grav10_ii_mmnn   ,
          deta_grav5_ii_mmnn    ,
          deta_grav10_mone      ,
          deta_grav5_mone       ,
          deta_grav10_mmnn      ,
          deta_grav5_mmnn       ,
          deta_iva10_mone       ,
          deta_iva5_mone        ,
          deta_iva10_mmnn       ,
          deta_iva5_mmnn        ,
          deta_exen_mone        ,
          deta_exen_mmnn        ,
          deta_indi_cost        ,
          deta_exde_codi        ,
          deta_exde_tipo        ,
          deta_impo_inte_mone   ,
          deta_impo_inte_mmnn   ,
          deta_emse_codi
    from come_movi_prod_deta p
   where deta_movi_codi = :bcab.movi_codi
order by deta_nume_item;

begin
  :parameter.p_indi_exis_prod := 'N';
  go_block('bprod');
  clear_block(no_validate);
  first_record;
  for x in c_movi_prod loop
     :parameter.p_indi_exis_prod := 'S';
     :bprod.deta_movi_codi           := x.deta_movi_codi         ;  
     :bprod.deta_nume_item           := x.deta_nume_item         ;
     :bprod.deta_impu_codi           := x.deta_impu_codi         ;
     :bprod.deta_prod_codi           := x.deta_prod_codi         ;
     :bprod.deta_prod_codi_orig      := x.deta_prod_codi         ;
     :bprod.deta_cant                := x.deta_cant              ;
     :bprod.deta_obse                := x.deta_obse              ;
     :bprod.deta_porc_deto           := x.deta_porc_deto         ;
     :bprod.deta_impo_mone           := x.deta_impo_mone         ;
     :bprod.deta_impo_mmnn           := x.deta_impo_mmnn         ;
     :bprod.deta_impo_mmee           := x.deta_impo_mmee         ;
     :bprod.deta_iva_mmnn            := x.deta_iva_mmnn          ;
     :bprod.deta_iva_mmee            := x.deta_iva_mmee          ;
     :bprod.deta_iva_mone            := x.deta_iva_mone          ;
     :bprod.deta_prec_unit           := x.deta_prec_unit         ;
     :bprod.deta_movi_codi_padr      := x.deta_movi_codi_padr    ;
     :bprod.deta_nume_item_padr      := x.deta_nume_item_padr    ;
     :bprod.deta_impo_mone_deto_nc   := x.deta_impo_mone_deto_nc ;
     :bprod.deta_movi_codi_deto_nc   := x.deta_movi_codi_deto_nc ;
     :bprod.deta_list_codi           := x.deta_list_codi         ;
     :bprod.deta_movi_clave_orig     := x.deta_movi_clave_orig   ;
     :bprod.deta_impo_mmnn_deto_nc   := x.deta_impo_mmnn_deto_nc ;
     :bprod.deta_base                := x.deta_base              ;
     :bprod.deta_lote_codi           := x.deta_lote_codi         ;
     :bprod.deta_lote_codi_orig      := x.deta_lote_codi         ;
     :bprod.deta_movi_orig_codi      := x.deta_movi_orig_codi    ;
     :bprod.deta_movi_orig_item      := x.deta_movi_orig_item    ;
     :bprod.deta_impo_mmee_deto_nc   := x.deta_impo_mmee_deto_nc ;
     :bprod.deta_asie_codi           := x.deta_asie_codi         ;
     :bprod.deta_cant_medi           := x.deta_cant_medi         ;
     :bprod.deta_medi_codi           := x.deta_medi_codi         ;
     :bprod.deta_remi_codi           := x.deta_remi_codi         ;
     :bprod.deta_remi_nume_item      := x.deta_remi_nume_item    ;
     :bprod.deta_bien_codi           := x.deta_bien_codi         ;
     :bprod.deta_prec_unit_list      := x.deta_prec_unit_list    ;
     :bprod.deta_impo_deto_mone      := x.deta_impo_deto_mone    ;
     :bprod.deta_porc_deto_prec      := x.deta_porc_deto_prec    ;
     :bprod.deta_bene_codi           := x.deta_bene_codi         ;
     :bprod.deta_ceco_codi           := x.deta_ceco_codi         ;
     :bprod.deta_clpr_codi           := x.deta_clpr_codi         ;
     :bprod.deta_impo_mone_ii        := x.deta_impo_mone_ii      ;
     :bprod.deta_impo_mmnn_ii        := x.deta_impo_mmnn_ii      ;
     :bprod.deta_grav10_ii_mone      := x.deta_grav10_ii_mone    ;
     :bprod.deta_grav5_ii_mone       := x.deta_grav5_ii_mone     ;
     :bprod.deta_grav10_ii_mmnn      := x.deta_grav10_ii_mmnn    ;
     :bprod.deta_grav5_ii_mmnn       := x.deta_grav5_ii_mmnn     ;
     :bprod.deta_grav10_mone         := x.deta_grav10_mone       ;
     :bprod.deta_grav5_mone          := x.deta_grav5_mone        ;
     :bprod.deta_grav10_mmnn         := x.deta_grav10_mmnn       ;
     :bprod.deta_grav5_mmnn          := x.deta_grav5_mmnn        ;
     :bprod.deta_iva10_mone          := x.deta_iva10_mone        ;
     :bprod.deta_iva5_mone           := x.deta_iva5_mone         ;
     :bprod.deta_iva10_mmnn          := x.deta_iva10_mmnn        ;
     :bprod.deta_iva5_mmnn           := x.deta_iva5_mmnn         ;
     :bprod.deta_exen_mone           := x.deta_exen_mone         ;
     :bprod.deta_exen_mmnn           := x.deta_exen_mmnn         ;
     :bprod.deta_indi_cost           := x.deta_indi_cost         ;
     :bprod.deta_exde_codi           := x.deta_exde_codi         ;
     :bprod.deta_exde_tipo           := x.deta_exde_tipo         ;
     :bprod.deta_impo_inte_mone      := x.deta_impo_inte_mone    ;
     :bprod.deta_impo_inte_mmnn      := x.deta_impo_inte_mmnn    ;
     :bprod.deta_emse_codi           := x.deta_emse_codi         ;
     
     if :bprod.deta_prod_codi is not null then
       pp_muestra_come_prod(:bprod.deta_prod_codi, :bprod.prod_desc, :bprod.prod_codi_alfa);
       
       pp_muestra_lote_qry(:bprod.deta_lote_codi, :bprod.deta_lote_codi_alte);
       
       :parameter.p_indi_cons := 'S';
       
     end if;

  end loop;
 
  
end pp_cargar_bloq_prod;
*/


procedure pp_ejecutar_consulta_nume_rete (p_nume_rete            in varchar2,
                                          p_clpr_codi_alte       in varchar2,
                                          p_movi_clpr_codi       in varchar2,
                                          p_movi_codi_rete       out varchar2,
                                          p_impo_rete            out varchar2,
                                          p_clpr_codi_rete       out varchar2
                                          ) is
v_movi_codi number;
Begin
 
 select movi_codi, movi_exen_mone, movi_clpr_codi
   into p_movi_codi_rete, p_impo_rete, p_clpr_codi_rete
   from come_movi
  where (movi_timo_codi = parameter.p_codi_timo_rete_emit)
    and (movi_nume||'-'||movi_codi = p_nume_rete);
 
  
   if p_clpr_codi_alte <> parameter.p_codi_prov_espo then
   if p_movi_clpr_codi <> p_clpr_codi_rete then
     raise_application_error(-20001, 'El codigo del proveedor de la factura no coincide con el prov. de la retencion');
   end if;    
 end if;  
  
  
Exception
   When no_data_found then
     raise_application_error(-20001, 'Movimiento de retenci?n Inexistente');    
   When too_many_rows then
     raise_application_error(-20001, 'Existen dos Movimientos con el mismo numero, aviste a su administrador');     
     --aca deberia consultar todos los ajustes con el mismo nro..            
  
End pp_ejecutar_consulta_nume_rete;


procedure pp_borrar_ortr_deta (p_movi_codi               in number,
                               p_movi_timo_codi          in number,
                               p_deta_ortr_codi_orig     in number)is
v_count number;
begin
---raise_application_error(-20001,p_movi_codi||'--'||p_movi_timo_codi||'--'||p_deta_ortr_codi_orig);
if p_movi_timo_codi not in (1,2,3,4) then
	 raise_application_error(-20001,'El movimiento debe ser de tipo venta');
end if;
  select count(*)
  into v_count
  from come_movi_ortr_deta
  where deta_movi_codi =p_movi_codi;
  
  if v_count = 0 then 
  raise_application_error(-20001,'El documento no esta vinculado a ninguna OT');
  else
  if p_deta_ortr_codi_orig is not null then
  	  delete come_movi_ortr_deta
  	  where deta_movi_codi = p_movi_codi;
      
    apex_application.g_print_success_message :='La Ot fue desvinculada de la factura!!!';
  	    
  end if;	
  
  end if;

  --apex_application.g_print_success_message := 'Registro Actualizado';
end pp_borrar_ortr_deta;

procedure pp_actu_ortr_deta  is
  

v_deta_movi_codi      number(20);                              
v_deta_nume_item      number(5);                               
v_deta_ortr_codi      number(20);                         
v_deta_impu_codi      number(10);                         
v_deta_cant           number(20,4);                         
v_deta_porc_deto      number(5,2);                         
v_deta_impo_mone      number(20,4);                         
v_deta_impo_mmnn      number(20,4);                         
v_deta_impo_mmee      number(20,4);                         
v_deta_iva_mone       number(20,4);                         
v_deta_iva_mmnn       number(20,4);                         
v_deta_iva_mmee       number(20,4);                         
v_deta_prec_unit      number(20,4);                         
v_deta_movi_codi_padr number(20);                         
v_deta_nume_item_padr number(5);                         
v_deta_base           number(2);                         
v_deta_obse           varchar2(500);  


v_count number;

v_clpr_codi number;

Begin
  
  pp_set_variables;
   --primero verificar que esa ot no est? registrada en otra factura
   if bcab.movi_timo_codi not in (1,2,3,4) then
     raise_application_error(-20001,'El movimiento debe ser de tipo venta') ;
   end if;
	
  if bcab.deta_ortr_codi is null then
		 raise_application_error(-20001,'Debe seleccionar una OT para asignar a una Factura');
  end if;

   select count(*)
     into v_count
     from come_movi_ortr_deta
    where deta_ortr_codi = bcab.deta_ortr_codi;
   
   select ortr_clpr_codi
     into v_clpr_codi
     from come_orde_trab
    where ortr_codi = bcab.deta_ortr_codi;

   if v_clpr_codi <> bcab.movi_clpr_codi then
      raise_application_error(-20001,'EL cliente de la Ot debe ser igual al cliente de la Factura!!!');
   end if;  
   
 
   if v_count > 0 then
      raise_application_error(-20001,'La OT ya esta asociada a una factura');
   else   
   
    v_deta_movi_codi      := bcab.movi_codi;
    v_deta_nume_item      := 1;                      
    v_deta_ortr_codi      := bcab.deta_ortr_codi;
    
    if nvl(bcab.movi_iva_mone,0) > 0 then
      v_deta_impu_codi      := 2;
    else
      v_deta_impu_codi      := 1;
    end if; 
    
    v_deta_cant           := 1;
    v_deta_porc_deto      := 0;
    v_deta_impo_mone      := bcab.movi_exen_mone + bcab.movi_grav_mone;
    v_deta_impo_mmnn      := bcab.movi_exen_mmnn + bcab.movi_grav_mmnn;
    v_deta_impo_mmee      := null;               
    v_deta_iva_mone       := bcab.movi_iva_mone;                        
    v_deta_iva_mmnn       := bcab.movi_iva_mmnn;               
    v_deta_iva_mmee       := null;               
    v_deta_prec_unit      := v_deta_impo_mone + v_deta_iva_mone;
    v_deta_movi_codi_padr := null;
    v_deta_nume_item_padr := null;
    v_deta_base           := bcab.movi_base;
    v_deta_obse           := 'Agregado manualmente';
   
    
     --raise_application_error(-20001,v_deta_movi_codi);    
    insert into come_movi_ortr_deta  (
        deta_movi_codi      ,
        deta_nume_item      ,
        deta_ortr_codi      ,
        deta_impu_codi      ,
        deta_cant           ,
        deta_porc_deto      ,
        deta_impo_mone      ,
        deta_impo_mmnn      ,
        deta_impo_mmee      ,
        deta_iva_mone       ,
        deta_iva_mmnn       ,
        deta_iva_mmee       ,
        deta_prec_unit      ,
        deta_movi_codi_padr ,
        deta_nume_item_padr ,
        deta_base           ,
        deta_obse           )  values (    
        v_deta_movi_codi      ,
        v_deta_nume_item      ,
        v_deta_ortr_codi      ,
        v_deta_impu_codi      ,
        v_deta_cant           ,
        v_deta_porc_deto      ,
        v_deta_impo_mone      ,
        v_deta_impo_mmnn      ,
        v_deta_impo_mmee      ,
        v_deta_iva_mone       ,
        v_deta_iva_mmnn       ,
        v_deta_iva_mmee       ,
        v_deta_prec_unit      ,
        v_deta_movi_codi_padr ,
        v_deta_nume_item_padr ,
        v_deta_base           ,
        v_deta_obse           ) ;
       
       apex_application.g_print_success_message := 'Registro Actualizado';
 
  end if;
 ---raise_application_error(-20001,'Nopu');       
end pp_actu_ortr_deta;



procedure pp_muestra_come_prod (p_prod_codi in number,
                                p_prod_desc out varchar2,
                                p_prod_codi_alfa out varchar2) is
begin           
  select prod_desc, prod_codi_alfa
  into   p_prod_desc, p_prod_codi_alfa
  from   come_prod
  where  prod_codi = p_prod_codi;  
  
Exception
  when no_data_found then
     raise_application_error(-20001,'Producto Inexistente!');

end pp_muestra_come_prod;

procedure pp_muestra_lote_qry (p_lote_codi in number, p_lote_codi_alte out number, p_lote_desc out varchar2) is

begin
  select lote_codi, a.lote_desc
    into p_lote_codi_alte, p_lote_desc
    from come_lote a
   where lote_codi = p_lote_codi;
  
exception
	when no_data_found then
	 raise_application_error(-20001,'Lote Inexistente');
  
end pp_muestra_lote_qry;




procedure pp_cargar_bloq_prod (p_movi_codi    in number,
                               p_cant_deci    in number) is
 
cursor c_movi_prod is
  select deta_nume_item,     
         deta_movi_codi,
         deta_impu_codi,
       --  prod_codi_alfa,  
       --  prod_desc,
         --deta_lote_codi_alte,
        --- lote_desc,
         deta_prod_codi,
     --    deta_prod_codi_orig,
         deta_cant,
         deta_obse,
         deta_prec_unit,
         deta_impo_mone_ii,
         deta_lote_codi
  from come_movi_prod_deta p
   where deta_movi_codi = p_movi_codi;
   
   
v_prod_desc             varchar2(300);
v_prod_codi_alfa        varchar2(100);
v_deta_lote_codi_alte   varchar2(100);  
v_lote_desc             varchar2(100); 
v_deta_impo_mone_ii     varchar2(100);  
v_deta_prec_unit        varchar2(100);
begin
 
   -- :parameter.p_indi_exis_prod := 'N';

  for x in c_movi_prod loop
    
    if x.deta_prod_codi is not null then
       pp_muestra_come_prod(x.deta_prod_codi,v_prod_desc, v_prod_codi_alfa);
       
       pp_muestra_lote_qry(x.deta_lote_codi, v_deta_lote_codi_alte,v_lote_desc);
       
      -- :parameter.p_indi_cons := 'S';
       
     end if;
     
     
     if p_cant_deci = 0 then
         v_deta_prec_unit :=  to_char(x.deta_prec_unit,'999G999G999G999');
         v_deta_impo_mone_ii := to_char(x.deta_impo_mone_ii,'999G999G999G999');
     else
        v_deta_prec_unit :=  to_char(x.deta_prec_unit,'999G999G999G990D99');
        v_deta_impo_mone_ii := to_char(x.deta_impo_mone_ii,'999G999G999G990D99');
     
     end if;
      
      

     apex_collection.add_member(p_collection_name => 'DETA_ARTI',                               
                                p_c001      => x.deta_nume_item,     
                                p_c002      => x.deta_movi_codi,
                                p_c003      => x.deta_impu_codi,
                                p_c004      => v_prod_codi_alfa,  
                                p_c005      => v_prod_desc,
                                p_c006      => v_deta_lote_codi_alte,
                                p_c007      => v_lote_desc,
                                p_c008      => x.deta_prod_codi,
                                p_c009      => x.deta_prod_codi,--_orgi,
                                p_c010      => x.deta_cant,
                                p_c011      => x.deta_obse,
                                p_c012      => v_deta_prec_unit,
                                p_c013      => v_deta_impo_mone_ii,
                                p_c014      => x.deta_lote_codi,
                                p_c015      => x.deta_lote_codi);--_orig);
                                                         
  end loop;
 
end pp_cargar_bloq_prod;

procedure pp_mostrar_producto (p_prod_codi      in varchar2,
                               p_prod_codi_alfa out number,
                               p_prod_desc      out varchar2
                               ) is
begin           
  select prod_desc, prod_codi_alfa
  into   p_prod_desc, p_prod_codi_alfa
  from   come_prod
  where  prod_codi = p_prod_codi;  
  
Exception
  when no_data_found then
     raise_application_error(-20001, 'Producto Inexistente!');
  
end;

procedure pp_muestra_lote (p_lote_codi in number, p_lote_desc out varchar2, p_lote_codi_alte out number, p_deta_prod_codi in number) is
v_lote_prod_codi number;

begin
  select lote_desc, lote_codi, lote_prod_codi
    into p_lote_desc, p_lote_codi_alte, v_lote_prod_codi
    from come_lote
   where lote_codi = p_lote_codi;
   
   if v_lote_prod_codi <> p_deta_prod_codi then
     raise_application_error(-20001,'El lote asignado no corresponde al producto');
   end if;
  
exception
	when no_data_found then
	 raise_application_error(-20001,'Lote Inexistente');
 
end;


procedure pp_editar_arti (p_seq_id  in number,
                          p_prod    in number,
                          p_lote    in number) is
 v_prod_codi_alfa   varchar2(300);
 v_prod_desc        varchar2(200); 
 v_lote_desc        varchar2(200); 
 v_lote_codi_alte   varchar2(200);                                     
begin          
 
  if p_prod is null then
    raise_application_error(-20001,'El producto no puede quedar vacio');
  end if;
         
   if p_lote is null then
    raise_application_error(-20001,'El lote no puede quedar vacio');
  end if;
         
  pp_mostrar_producto(p_prod, v_prod_codi_alfa, v_prod_desc);
   
  pp_muestra_lote(p_lote, v_lote_desc, v_lote_codi_alte,p_prod );
  
	
  
---------producto
  APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETA_ARTI',
                                          P_SEQ             => p_seq_id,
                                          P_ATTR_NUMBER     => 4,
                                          P_ATTR_VALUE      => v_prod_codi_alfa);
 
  APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETA_ARTI',
                                          P_SEQ             => p_seq_id,
                                          P_ATTR_NUMBER     => 5,
                                          P_ATTR_VALUE      => v_prod_desc);                                        
                                          
  APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETA_ARTI',
                                          P_SEQ             => p_seq_id,
                                          P_ATTR_NUMBER     => 8,
                                          P_ATTR_VALUE      => p_prod);
                                          
----------lote                                          
  APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETA_ARTI',
                                          P_SEQ             => p_seq_id,
                                          P_ATTR_NUMBER     => 6,
                                          P_ATTR_VALUE      => v_lote_codi_alte);   
                                                                                 
  APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETA_ARTI',
                                          P_SEQ             => p_seq_id,
                                          P_ATTR_NUMBER     => 7,
                                          P_ATTR_VALUE      => v_lote_desc);
                                          
  APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME   => 'DETA_ARTI',
                                          P_SEQ             => p_seq_id,
                                          P_ATTR_NUMBER     => 14,
                                          P_ATTR_VALUE      => p_lote);                                                                                    
 end pp_editar_arti;
 
 
 
procedure pp_muestra_come_conc(p_conc_codi      in number,
                               p_conc_desc      out char,
                               p_conc_dbcr      out char,
                               p_conc_indi_impo out char) is
begin
  select conc_desc, conc_dbcr, conc_indi_impo
    into p_conc_desc, p_conc_dbcr, p_conc_indi_impo
    from come_conc
   where conc_codi = p_conc_codi;

exception
  when no_data_found then
   raise_application_error(-20001,'Concepto Inexistente!');
end;

procedure pp_muestra_come_impo(p_impo_codi in number, p_impo_nume out number) is
begin
  select impo_nume
    into p_impo_nume
    from come_impo
   where impo_codi = p_impo_codi;
exception
	when no_data_found then
   p_impo_nume := null;
end pp_muestra_come_impo;
 
procedure pp_cargar_bloq_conc (p_movi_codi in number,
                               p_cant_deci in number) is
  
cursor concepto is (
select moco_nume_item,
       moco_movi_codi,
       moco_conc_codi,
       moco_dbcr,
       moco_impu_codi,
       moco_impo_codi,
       moco_ortr_codi,
       moco_ceco_codi,
       moco_tran_codi,
       moco_juri_codi,
       moco_impo_mone,
       moco_impo_mmnn
  from come_movi_conc_deta 
  where moco_movi_codi =  p_movi_codi
  and moco_conc_codi not in (parameter.p_codi_conc_iva_10cr,parameter.p_codi_conc_iva_05cr));
  
  v_moco_conc_desc   varchar2(200);
  v_conc_dbcr        varchar2(200);
  v_conc_indi_impo   varchar2(200);
  v_moco_impu_desc   varchar2(200);
  v_impu_porc        varchar2(200);
  v_impu_porc_base_impo  varchar2(200);
  v_impo_nume            varchar2(200); 
begin

for bconc in concepto loop
if bconc.moco_conc_codi is not null then
   pp_muestra_come_conc(bconc.moco_conc_codi, v_moco_conc_desc, v_conc_dbcr, v_conc_indi_impo);
end if;

if bconc.moco_impu_codi is not null then
   general_skn.pl_muestra_come_impu(bconc.moco_impu_codi, v_moco_impu_desc, v_impu_porc,v_impu_porc_base_impo);
end if;


if bconc.moco_impo_codi is not null then
   pp_muestra_come_impo(bconc.moco_impo_codi, v_impo_nume);
end if;


 apex_collection.add_member(p_collection_name => 'DETA_CONC',           
                           p_c001      => bconc.moco_nume_item,
                           p_c002      => bconc.moco_movi_codi,
                           p_c003      => bconc.moco_conc_codi,
                           p_c004      => v_conc_dbcr,
                           p_c005      => v_conc_indi_impo,
                           p_c006      => bconc.moco_dbcr,
                           p_c007      => bconc.moco_impu_codi,
                           p_c008      => v_moco_impu_desc,
                           p_c009      => v_impo_nume,
                           p_c010      => null,--bconc.ceco_nume,
                           p_c011      => null,--bconc.ortr_nume,
                           p_c012      => null,--bconc.juri_nume,
                           p_c013      => null,--bconc.tran_codi_alte,
                           p_c014      => bconc.moco_impo_codi,
                           p_c015      => bconc.moco_ortr_codi,
                           p_c016      => bconc.moco_ceco_codi,
                           p_c017      => bconc.moco_tran_codi,
                           p_c018      => bconc.moco_juri_codi,
                           p_c019      => v_impu_porc_base_impo,
                           p_c020      => v_impu_porc,
                           p_c021      => bconc.moco_impo_mone,
                           p_c022      => bconc.moco_impo_mmnn,
                           p_c023      => v_moco_conc_desc);







end loop;
/*
if :bconc.moco_impo_codi is null then
  set_item_property('bconc.impo_nume', enabled, property_false);
else
  set_item_property('bconc.impo_nume', enabled, property_true);
  set_item_property('bconc.impo_nume', updateable, property_true);
end if;

if :bconc.moco_ceco_codi is null then
  set_item_property('bconc.ceco_nume', enabled, property_false);
else
  set_item_property('bconc.ceco_nume', enabled, property_true);
  set_item_property('bconc.ceco_nume', updateable, property_true);
end if;

if :bconc.moco_ortr_codi is null then
  set_item_property('bconc.ortr_nume', enabled, property_false);
else
  set_item_property('bconc.ortr_nume', enabled, property_true);
  set_item_property('bconc.ortr_nume', updateable, property_true);
end if;

if :bconc.moco_juri_codi is null then
  set_item_property('bconc.juri_nume', enabled, property_false);
else
  set_item_property('bconc.juri_nume', enabled, property_true);
  set_item_property('bconc.juri_nume', updateable, property_true);
end if;

if :bconc.moco_tran_codi is null then
  set_item_property('bconc.tran_codi_alte', enabled, property_false);
else
  set_item_property('bconc.tran_codi_alte', enabled, property_true);
  set_item_property('bconc.tran_codi_alte', updateable, property_true);
end if;*/
end pp_cargar_bloq_conc;
 
 
 
end I020102;
--raise_application_error(-20001, 
