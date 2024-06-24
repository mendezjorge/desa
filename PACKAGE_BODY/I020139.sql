
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020139" is

  type r_parameter is record(
    p_codi_impu_exen      number := to_number(fa_busc_para('p_codi_impu_exen')),
    p_codi_impu_grav10    number := to_number(fa_busc_para('p_codi_impu_grav10')),
    p_codi_impu_grav5     number := to_number(fa_busc_para('p_codi_impu_grav5')),
    p_cant_deci_porc      number := to_number(fa_busc_para('p_cant_deci_porc')),
    p_cant_deci_mmnn      number := to_number(fa_busc_para('p_cant_deci_mmnn')),
    p_cant_deci_mmee      number := to_number(fa_busc_para('p_cant_deci_mmee')),
    p_cant_deci_cant      number := to_number(fa_busc_para('p_cant_deci_cant')),
    p_cant_deci_prec_unit number := to_number(fa_busc_para('p_cant_deci_prec_unit')),
    
    p_habi_camp_cent_cost_dbcr varchar2(5000) := rtrim(ltrim(fa_busc_para('p_habi_camp_cent_cost_dbcr'))),
    p_indi_most_secc_dbcr      varchar2(5000) := ltrim(rtrim(fa_busc_para('p_indi_most_secc_dbcr'))),
    p_indi_rela_nume_serv      varchar2(5000) := ltrim(rtrim(fa_busc_para('p_indi_rela_nume_serv'))),
    p_codi_impu_grav10_bi25    number := to_number(fa_busc_para('p_codi_impu_grav10_bi25')),
    p_codi_impu_grav10_bi7_5   number := to_number(fa_busc_para('p_codi_impu_grav10_bi7_5')),
    p_indi_vali                varchar2(50) := 'N',
    p_codi_oper_tick_ese       number := to_number(fa_busc_para('p_codi_oper_tick_ese')),
    
    p_codi_base           number := pack_repl.fa_devu_codi_base,
    p_indi_vali_secc_dbcr varchar2(5000) := ltrim(rtrim(fa_busc_para('P_INDI_VALI_SECC_DBCR'))));
  parameter r_parameter;

  type r_bcab is record(
    movi_codi      number,
    timo_dbcr      varchar2(3),
    movi_oper_codi number,
    movi_iva_mone  number,
    movi_timo_codi number,
    movi_grav_mone number,
    movi_exen_mone number,
    s_total        number);
  bcab r_bcab;

  type r_fbdet is record(
    f_dif_impo       number,
    f_dif_iva        number,
    f_dif_tot_item   number,
    sum_s_moco_impo  number,
    sum_s_moco_iva   number,
    sum_s_total_item number);

  fbdet r_fbdet;

  cursor cur_bdet(i_seq_id in number default null) is
    select seq_id moco_nume_item,
           ---*** mecesarios para validacion
           c001 conc_indi_cent_cost,
           c002 conc_indi_kilo_vehi,
           c003 gatr_tran_codi,
           c004 moco_conc_desc,
           ---*** mecesarios para guardado
           c005 conc_indi_impo,
           c006 conc_indi_ortr,
           c007 moco_ceco_codi,
           c008 moco_conc_codi,
           c009 moco_dbcr,
           c010 moco_emse_codi,
           c011 moco_grav10_mmnn,
           c012 moco_grav10_mmnn_ii,
           c013 moco_grav10_mone,
           c014 moco_grav10_mone_ii,
           c015 moco_grav5_mmnn,
           c016 moco_grav5_mmnn_ii,
           c017 moco_grav5_mone,
           c018 moco_grav5_mone_ii,
           c019 moco_impo_codi,
           c020 moco_impo_mmnn_ii,
           c021 moco_impo_mone_ii,
           c022 moco_impu_codi,
           c023 moco_iva10_mmnn,
           c024 moco_iva10_mone,
           c025 moco_iva5_mmnn,
           c026 moco_iva5_mone,
           c027 orse_codi,
           c028 ortr_codi,
           c029 s_moco_impo,
           c030 s_moco_impo_exen,
           c031 s_moco_impo_exen_mmnn,
           c032 s_moco_impo_mmnn,
           c033 tiim_codi,
           ----***** datos para mostrar
           c034 cent_cost_nume,
           --c035 conc_desc,
           -- c036 emse_codi_alte,
           c037 emse_desc,
           c038 impo_nume,
           -- c039 impu_desc,
           c040 impu_porc,
           c041 impu_porc_base_impo,
           c042 moco_impu_desc,
           c043 moco_impu_porc,
           c044 moco_impu_porc_base_impo,
           --c045 moco_movi_codi,
           c046 orse_nume_char,
           c047 ortr_nume,
           to_number(c048) s_moco_impo_ii,
           c049 tiim_desc,
           to_number(c050) s_moco_iva
      from apex_collections a
     where a.collection_name = 'COLL_BDET'
       and (seq_id = i_seq_id or i_seq_id is null);

  procedure pp_cargar_nuevo_detalle(i_movi_codi in number) is
    cursor cur_bdet3 is
      select moco.moco_movi_codi,
             moco.moco_nume_item,
             moco.moco_conc_codi,
             moco.moco_cuco_codi,
             moco.moco_impu_codi,
             moco.moco_impo_mmnn,
             moco.moco_impo_mmee,
             moco.moco_impo_mone,
             moco.moco_dbcr,
             moco.moco_base,
             moco.moco_desc,
             moco.moco_tiim_codi,
             moco.moco_indi_fact_serv,
             moco.moco_impo_mone_ii,
             moco.moco_cant,
             moco.moco_cant_pulg,
             moco.moco_ortr_codi,
             moco.moco_movi_codi_padr,
             moco.moco_nume_item_padr,
             moco.moco_impo_codi,
             moco.moco_ceco_codi,
             moco.moco_orse_codi,
             moco.moco_tran_codi,
             moco.moco_bien_codi,
             moco.moco_tipo_item,
             moco.moco_clpr_codi,
             moco.moco_prod_nume_item,
             moco.moco_guia_nume,
             moco.moco_emse_codi,
             moco.moco_impo_mmnn_ii,
             moco.moco_grav10_ii_mone,
             moco.moco_grav5_ii_mone,
             moco.moco_grav10_ii_mmnn,
             moco.moco_grav5_ii_mmnn,
             moco.moco_grav10_mone,
             moco.moco_grav5_mone,
             moco.moco_grav10_mmnn,
             moco.moco_grav5_mmnn,
             moco.moco_iva10_mone,
             moco.moco_iva5_mone,
             moco.moco_conc_codi_impu,
             moco.moco_tipo,
             moco.moco_prod_codi,
             moco.moco_ortr_codi_fact,
             moco.moco_iva10_mmnn,
             moco.moco_iva5_mmnn,
             moco.moco_sofa_sose_codi,
             moco.moco_sofa_nume_item,
             moco.moco_exen_mone,
             moco.moco_exen_mmnn,
             moco.moco_empl_codi,
             moco.moco_anex_codi,
             moco.moco_lote_codi,
             moco.moco_bene_codi,
             moco.moco_medi_codi,
             moco.moco_cant_medi,
             moco.moco_indi_excl_cont,
             moco.moco_anex_nume_item,
             moco.moco_juri_codi,
             moco.moco_impo_diar_mone,
             moco.moco_coib_codi,
             moco.moco_envi_codi,
             moco.moco_anpl_codi,
             moco.moco_indi_orse_adm,
             moco.moco_osli_codi,
             moco.moco_sucu_codi,
             moco.moco_codi,
             moco.moco_sofa_codi,
             moco.moco_maqu_codi,
             moco.moco_fech_emis,
             moco.moco_gatr_codi,
             moco.moco_porc_dist
        from come_movi_conc_deta moco
       where moco_movi_codi = i_movi_codi;
  
    bdet cur_bdet%rowtype;
  
    v_tot_grav_mone number := 0;
    v_tot_grav_mmnn number := 0;
    v_tot_iva_mone  number := 0;
    v_tot_iva_mmnn  number := 0;
  
  begin
  
    pp_iniciar_collection;
  
    for bdet3 in cur_bdet3 loop
    
      if not (fp_valida_conc_iva(bdet3.moco_conc_codi)) then
      
        bdet.moco_ceco_codi        := bdet3.moco_ceco_codi;
        bdet.moco_conc_codi        := bdet3.moco_conc_codi;
        bdet.moco_dbcr             := bdet3.moco_dbcr;
        bdet.moco_emse_codi        := bdet3.moco_emse_codi;
        bdet.moco_grav10_mmnn      := bdet3.moco_grav10_mmnn;
        bdet.moco_grav10_mmnn_ii   := bdet3.moco_grav10_ii_mmnn;
        bdet.moco_grav10_mone      := bdet3.moco_grav10_mone;
        bdet.moco_grav10_mone_ii   := bdet3.moco_grav10_ii_mone;
        bdet.moco_grav5_mmnn       := bdet3.moco_grav5_mmnn;
        bdet.moco_grav5_mmnn_ii    := bdet3.moco_grav5_ii_mmnn;
        bdet.moco_grav5_mone       := bdet3.moco_grav5_mone;
        bdet.moco_grav5_mone_ii    := bdet3.moco_grav5_ii_mone;
        bdet.moco_impo_codi        := bdet3.moco_impo_codi;
        bdet.moco_impo_mmnn_ii     := bdet3.moco_impo_mone_ii;
        bdet.moco_impo_mone_ii     := bdet3.moco_impo_mone_ii;
        bdet.moco_impu_codi        := bdet3.moco_impu_codi;
        bdet.moco_iva10_mmnn       := bdet3.moco_iva10_mmnn;
        bdet.moco_iva10_mone       := bdet3.moco_iva10_mone;
        bdet.moco_iva5_mmnn        := bdet3.moco_iva5_mmnn;
        bdet.moco_iva5_mone        := bdet3.moco_iva5_mone;
        bdet.orse_codi             := bdet3.moco_orse_codi;
        bdet.ortr_codi             := bdet3.moco_ortr_codi;
        bdet.s_moco_impo_exen      := bdet3.moco_exen_mone;
        bdet.s_moco_impo           := bdet3.moco_impo_mone;
        bdet.s_moco_impo_exen_mmnn := bdet3.moco_exen_mmnn;
        bdet.s_moco_impo_mmnn      := bdet3.moco_impo_mmnn;
        bdet.tiim_codi             := nvl(bdet3.moco_tiim_codi, 1);
      
        select t.tiim_desc
          into bdet.tiim_desc
          from come_tipo_impu t
         where t.tiim_codi = bdet.tiim_codi;
      
        if bdet.moco_emse_codi is not null then
          select a.emse_desc
            into bdet.emse_desc
            from come_empr_secc a
           where a.emse_codi = bdet.moco_emse_codi;
        end if;
      
        if bdet.moco_impo_codi is not null then
          select impo_nume
            into bdet.impo_nume
            from come_impo impo
           where impo.impo_codi = bdet.moco_impo_codi;
        end if;
      
        if bdet.moco_impu_codi is not null then
          select impu.impu_desc, impu.impu_porc_base_impo, impu.impu_porc
            into bdet.moco_impu_desc,
                 bdet.moco_impu_porc_base_impo,
                 bdet.moco_impu_porc
            from come_impu impu
           where impu.impu_codi = bdet.moco_impu_codi;
        end if;
      
        if bdet.moco_conc_codi is not null then
          select c.conc_indi_impo,
                 c.conc_indi_ortr,
                 c.conc_indi_cent_cost,
                 c.conc_indi_kilo_vehi,
                 c.conc_desc
            into bdet.conc_indi_impo,
                 bdet.conc_indi_ortr,
                 bdet.conc_indi_cent_cost,
                 bdet.conc_indi_kilo_vehi,
                 bdet.moco_conc_desc
            from come_conc c
           where c.conc_codi = bdet.moco_conc_codi;
        end if;
      
        -- select  * from come_orde_trab ort where ort.ortr_codi = bdet.ortr_codi;
        --come_cent_cost, 
        --come_orde_serv
        /*bdet.orse_nume_char := bdet3.orse_nume_char;
          bdet.cent_cost_nume := bdet3.ceco_nume;
        */
      
        if bdet3.moco_impo_mone_ii is not null then
          bdet.s_moco_impo_ii := bdet3.moco_impo_mone_ii;
        else
          if bdet3.moco_impu_codi = 1 then
            bdet.s_moco_impo_ii := bdet3.moco_impo_mone;
          elsif bdet3.moco_impu_codi = 2 then
            bdet.s_moco_impo_ii := bdet3.moco_impo_mone +
                                   (bdet3.moco_impo_mone * 10 / 100);
          elsif bdet3.moco_impu_codi = 3 then
            bdet.s_moco_impo_ii := bdet3.moco_impo_mone +
                                   (bdet3.moco_impo_mone * 5 / 100);
          end if;
        end if;
      
        v_tot_grav_mone := bdet.moco_grav10_mone + bdet.moco_grav5_mone;
        v_tot_iva_mone  := bdet.moco_iva10_mone + bdet.moco_iva5_mone;
        -- bdet.s_moco_impo_grav := v_tot_grav_mone;
        --bdet.s_moco_impo_iva  := v_tot_iva_mone;
        bdet.s_moco_iva  := v_tot_iva_mone;
        bdet.s_moco_impo := nvl(bdet.s_moco_impo_ii, 0) -
                            nvl(bdet.s_moco_iva, 0);
      
        apex_collection.add_member(p_collection_name => 'COLL_BDET',
                                   p_c001            => bdet.conc_indi_cent_cost,
                                   p_c002            => bdet.conc_indi_kilo_vehi,
                                   p_c003            => bdet.gatr_tran_codi,
                                   p_c004            => bdet.moco_conc_desc,
                                   ---*=> bdet.* mecesarios para guardado
                                   p_c005 => bdet.conc_indi_impo,
                                   p_c006 => bdet.conc_indi_ortr,
                                   p_c007 => bdet.moco_ceco_codi,
                                   p_c008 => bdet.moco_conc_codi,
                                   p_c009 => bdet.moco_dbcr,
                                   p_c010 => bdet.moco_emse_codi,
                                   p_c011 => bdet.moco_grav10_mmnn,
                                   p_c012 => bdet.moco_grav10_mmnn_ii,
                                   p_c013 => bdet.moco_grav10_mone,
                                   p_c014 => bdet.moco_grav10_mone_ii,
                                   p_c015 => bdet.moco_grav5_mmnn,
                                   p_c016 => bdet.moco_grav5_mmnn_ii,
                                   p_c017 => bdet.moco_grav5_mone,
                                   p_c018 => bdet.moco_grav5_mone_ii,
                                   p_c019 => bdet.moco_impo_codi,
                                   p_c020 => bdet.moco_impo_mmnn_ii,
                                   p_c021 => bdet.moco_impo_mone_ii,
                                   p_c022 => bdet.moco_impu_codi,
                                   p_c023 => bdet.moco_iva10_mmnn,
                                   p_c024 => bdet.moco_iva10_mone,
                                   p_c025 => bdet.moco_iva5_mmnn,
                                   p_c026 => bdet.moco_iva5_mone,
                                   p_c027 => bdet.orse_codi,
                                   p_c028 => bdet.ortr_codi,
                                   p_c029 => bdet.s_moco_impo,
                                   p_c030 => bdet.s_moco_impo_exen,
                                   p_c031 => bdet.s_moco_impo_exen_mmnn,
                                   p_c032 => bdet.s_moco_impo_mmnn,
                                   p_c033 => bdet.tiim_codi,
                                   ----=> bdet.**** datos para mostrar
                                   p_c034 => bdet.cent_cost_nume,
                                   --  p_c035 => bdet.conc_desc,
                                   --p_c036 => bdet.emse_codi_alte,
                                   p_c037 => bdet.emse_desc,
                                   p_c038 => bdet.impo_nume,
                                   -- p_c039 => bdet.impu_desc,
                                   p_c040 => bdet.impu_porc,
                                   p_c041 => bdet.impu_porc_base_impo,
                                   p_c042 => bdet.moco_impu_desc,
                                   p_c043 => bdet.moco_impu_porc,
                                   p_c044 => bdet.moco_impu_porc_base_impo,
                                   --p_c045 => bdet.moco_movi_codi,
                                   p_c046 => bdet.orse_nume_char,
                                   p_c047 => bdet.ortr_nume,
                                   p_c048 => bdet.s_moco_impo_ii,
                                   p_c049 => bdet.tiim_desc,
                                   p_c050 => bdet.s_moco_iva);
      
      end if;
    end loop;
  end pp_cargar_nuevo_detalle;

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
                                          p_moim_iva5_mmnn      in number) is
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
       parameter.p_codi_base);
  
  end pp_insert_come_movi_impu_deta;

  procedure pp_insert_movi_conc_deta(p_moco_movi_codi in number,
                                     p_moco_nume_item in number,
                                     p_moco_conc_codi in number,
                                     p_moco_cuco_codi in number,
                                     p_moco_impu_codi in number,
                                     p_moco_impo_mmnn in number,
                                     p_moco_impo_mmee in number,
                                     p_moco_impo_mone in number,
                                     p_moco_dbcr      in char,
                                     p_moco_tiim_codi in number,
                                     --p_moco_impo_mone_ii in number,
                                     p_moco_impo_codi      in number,
                                     p_moco_ceco_codi      in number,
                                     p_moco_orse_codi      in number,
                                     p_moco_ortr_codi      in number,
                                     p_moco_emse_codi      in number,
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
                                     p_moco_tipo           in char,
                                     p_moco_prod_codi      in number,
                                     p_moco_ortr_codi_fact in number) is
  
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
       --moco_impo_mone_ii,
       moco_impo_codi,
       moco_ceco_codi,
       moco_orse_codi,
       moco_ortr_codi,
       moco_emse_codi,
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
       moco_prod_codi,
       moco_ortr_codi_fact,
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
       --p_moco_impo_mone_ii,
       p_moco_impo_codi,
       p_moco_ceco_codi,
       p_moco_orse_codi,
       p_moco_ortr_codi,
       p_moco_emse_codi,
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
       p_moco_prod_codi,
       p_moco_ortr_codi_fact,
       parameter.p_codi_base);
  
  end pp_insert_movi_conc_deta;

  procedure pp_actualiza_moco is
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      char(1);
    v_moco_tiim_codi number;
    v_moco_ceco_codi number;
    v_moco_impo_codi number;
  
    v_moco_orse_codi      number;
    v_moco_ortr_codi      number;
    v_moco_emse_codi      number;
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
    v_moco_conc_codi_impu number(20);
    v_moco_tipo           char(1);
    v_moco_prod_codi      number(20);
    v_moco_ortr_codi_fact number(20);
    v_conc_iva            number;
    v_conc_iva_fact       number;
  
    cursor c_movi(p_movi_codi in number) is
      select movi_codi, c.moco_tiim_codi
        from come_movi m, come_movi_conc_deta c
       where m.movi_codi = c.moco_movi_codi
         and movi_timo_codi in (5, 6)
         and movi_codi = p_movi_codi
       group by movi_codi, c.moco_tiim_codi
       order by movi_codi, c.moco_tiim_codi;
  
  begin
  
    update come_movi_conc_deta
       set moco_base = parameter.p_codi_base
     where moco_movi_codi = bcab.movi_codi;
  
    delete come_movi_conc_deta where moco_movi_codi = bcab.movi_codi;
  
    update come_movi_impu_deta
       set moim_base = parameter.p_codi_base
     where moim_movi_codi = bcab.movi_codi;
  
    delete come_movi_impu_deta where moim_movi_codi = bcab.movi_codi;
  
    v_moco_movi_codi := bcab.movi_codi;
    v_moco_nume_item := 0;
  
    for bdet in cur_bdet loop
    
      v_moco_nume_item := v_moco_nume_item + 1;
      v_moco_conc_codi := bdet.moco_conc_codi;
      v_moco_cuco_codi := null;
      v_moco_impu_codi := bdet.moco_impu_codi;
      v_moco_impo_mmnn := bdet.s_moco_impo_mmnn;
      v_moco_impo_mmee := 0;
      v_moco_impo_mone := bdet.s_moco_impo;
      v_moco_dbcr      := bdet.moco_dbcr;
      v_moco_tiim_codi := bdet.tiim_codi;
    
      if bdet.conc_indi_impo = 'S' then
        v_moco_impo_codi := bdet.moco_impo_codi;
      else
        v_moco_impo_codi := null;
      end if;
    
      v_moco_ceco_codi := bdet.moco_ceco_codi;
      v_moco_orse_codi := bdet.orse_codi;
    
      if bdet.conc_indi_ortr = 'S' then
        v_moco_ortr_codi := bdet.ortr_codi;
      else
        v_moco_ortr_codi := null;
      end if;
    
      v_moco_emse_codi      := bdet.moco_emse_codi;
      v_moco_impo_mone_ii   := bdet.moco_impo_mone_ii;
      v_moco_impo_mmnn_ii   := bdet.moco_impo_mmnn_ii;
      v_moco_grav10_ii_mone := bdet.moco_grav10_mone_ii;
      v_moco_grav5_ii_mone  := bdet.moco_grav5_mone_ii;
      v_moco_grav10_ii_mmnn := bdet.moco_grav10_mmnn_ii;
      v_moco_grav5_ii_mmnn  := bdet.moco_grav5_mmnn_ii;
      v_moco_grav10_mone    := bdet.moco_grav10_mone;
      v_moco_grav5_mone     := bdet.moco_grav5_mone;
      v_moco_grav10_mmnn    := bdet.moco_grav10_mmnn;
      v_moco_grav5_mmnn     := bdet.moco_grav5_mmnn;
      v_moco_iva10_mone     := bdet.moco_iva10_mone;
      v_moco_iva5_mone      := bdet.moco_iva5_mone;
      v_moco_iva10_mmnn     := bdet.moco_iva10_mmnn;
      v_moco_iva5_mmnn      := bdet.moco_iva5_mmnn;
      v_moco_exen_mone      := bdet.s_moco_impo_exen;
      v_moco_exen_mmnn      := bdet.s_moco_impo_exen_mmnn;
    
      --verificar si el tipo de impuesto tiene un concepto de impuesto
      begin
        select decode(bcab.timo_dbcr,
                      'C',
                      impu_conc_codi_ivcr,
                      impu_conc_codi_ivdb) conc_iva,
               decode(bcab.timo_dbcr,
                      'C',
                      i.impu_conc_codi_ivcr_afac,
                      i.impu_conc_codi_ivdb_afac) conc_iva_fact
          into v_conc_iva, v_conc_iva_fact
          from come_impu i
         where impu_codi = v_moco_impu_codi;
      exception
        when no_data_found then
          pl_me('Concepto Inexistente');
      end;
      if bcab.movi_oper_codi = parameter.p_codi_oper_tick_ese then
        v_moco_conc_codi_impu := v_conc_iva_fact;
      else
        v_moco_conc_codi_impu := v_conc_iva;
      end if;
      v_moco_tipo           := 'C';
      v_moco_prod_codi      := null;
      v_moco_ortr_codi_fact := null;
    
      pp_insert_movi_conc_deta(v_moco_movi_codi,
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
                               v_moco_ceco_codi,
                               v_moco_orse_codi,
                               v_moco_ortr_codi,
                               v_moco_emse_codi,
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
                               v_moco_tipo,
                               v_moco_prod_codi,
                               v_moco_ortr_codi_fact);
    
    end loop;
  
    for x in c_movi(v_moco_movi_codi) loop
      update come_movi_impu_deta b
         set b.moim_tiim_codi = x.moco_tiim_codi
       where b.moim_movi_codi = x.movi_codi;
    end loop;
  
  end pp_actualiza_moco;

  procedure pp_valida_totales is
    v_mensaje varchar2(500) := ' ';
  begin
    if nvl(fbdet.f_dif_impo, 0) <> 0 then
      v_mensaje := 'Existe una diferencia entre el total importe y el detalle de conceptos.';
      pl_me(v_mensaje);
    end if;
    if nvl(fbdet.f_dif_iva, 0) <> 0 then
      v_mensaje := ('Existe una diferencia entre el total iva y el detalle de conceptos.');
      pl_me(v_mensaje);
    end if;
    if nvl(fbdet.f_dif_tot_item, 0) <> 0 then
      v_mensaje := ('Existe una diferencia entre el total del movimiento y el detalle de conceptos');
      pl_me(v_mensaje);
    end if;
  end pp_valida_totales;

  procedure pp_validar_conceptos is
  
  begin
  
    for bdet in cur_bdet loop
      if bdet.conc_indi_impo = 'S' then
        if bdet.moco_impo_codi is null then
          pl_me('Debe ingresar una importacion para el concepto ' ||
                bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
        end if;
      end if;
      if bdet.conc_indi_ortr = 'S' then
        if bdet.ortr_codi is null then
          pl_me('Debe ingresar un Nro de OT para el concepto ' ||
                bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
        end if;
      end if;
    
      if nvl(parameter.p_indi_vali_secc_dbcr, 'N') = 'S' then
        if bdet.moco_emse_codi is null then
          pl_me('Debe ingresar la Sección para el concepto ' ||
                bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
        end if;
      end if;
    
      if bdet.conc_indi_cent_cost = 'S' then
        if bdet.moco_ceco_codi is null then
          pl_me('Debe ingresar el centro de costo para el concepto ' ||
                bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
        end if;
      end if;
    
      if bdet.conc_indi_kilo_vehi in ('S', 'M') then
        if bdet.gatr_tran_codi is null then
          pl_me('Debe ingresar el codigo del vehiculo para el concepto ' ||
                bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
        end if;
      end if;
    
    end loop;
  end pp_validar_conceptos;

  procedure pp_actualiza_moimpu2 is
    v_total              number := 0;
    v_total_grav         number := 0;
    v_total_iva          number := 0;
    v_total_grav_5       number := 0;
    v_total_grav_10      number := 0;
    v_total_grav_5_mmnn  number := 0;
    v_total_grav_10_mmnn number := 0;
    v_total_iva_5        number := 0;
    v_total_iva_10       number := 0;
    v_total_iva_5_mmnn   number := 0;
    v_total_iva_10_mmnn  number := 0;
    v_total_grav_5_ii    number := 0;
    v_total_grav_10_ii   number := 0;
    --importes ya con el descuento incluido......
    v_total_neto_grav_5_ii       number := 0;
    v_total_neto_grav_10_ii      number := 0;
    v_total_neto_grav_ii         number := 0;
    v_total_neto_grav_5_ii_mmnn  number := 0;
    v_total_neto_grav_10_ii_mmnn number := 0;
    --------------------------------------------
    v_total_exen      number := 0;
    v_total_exen_mmnn number := 0;
  
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
             sum(a.moco_iva5_mmnn) moco_iva5_mmnn
        from come_movi_conc_deta a
       where a.moco_movi_codi = p_movi_codi
       group by a.moco_movi_codi, a.moco_impu_codi, a.moco_tiim_codi
       order by a.moco_movi_codi, a.moco_impu_codi, a.moco_tiim_codi;
  
    v_impoii_mmnn         number := 0;
    v_impoii_mmee         number := 0;
    v_impoii_mone         number := 0;
    v_impo_mmnn           number := 0;
    v_impu_mmnn           number := 0;
    v_impo_mmee           number := 0;
    v_impu_mmee           number := 0;
    v_impo_mone           number := 0;
    v_impu_mone           number := 0;
    v_impo_grav           number := 0;
    v_impo_iva            number := 0;
    v_impo_exen           number := 0;
    v_moim_impo_mone_ii   number := 0;
    v_moim_impo_mmnn_ii   number := 0;
    v_moim_grav10_ii_mone number := 0;
    v_moim_grav10_ii_mmnn number := 0;
    v_moim_grav5_ii_mone  number := 0;
    v_moim_grav5_ii_mmnn  number := 0;
    v_moim_grav10_mone    number := 0;
    v_moim_grav5_mone     number := 0;
    v_moim_grav10_mmnn    number := 0;
    v_moim_grav5_mmnn     number := 0;
    v_moim_iva10_mone     number := 0;
    v_moim_iva5_mone      number := 0;
    v_moim_iva10_mmnn     number := 0;
    v_moim_iva5_mmnn      number := 0;
    v_impo                number := 0;
    v_dife                number := 0;
  
  begin
    for x in c_movi_conc(bcab.movi_codi) loop
      v_impoii_mmnn := x.moco_impo_mmnn;
      v_impoii_mmee := x.moco_impo_mmee;
      v_impoii_mone := x.moco_impo_mone;
    
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
                                    v_moim_iva5_mmnn);
    
    end loop;
  end pp_actualiza_moimpu2;

  procedure pp_valida_concepto is
    v_count number;
  begin
  
    for bdet in cur_bdet loop
      if bdet.moco_conc_codi is not null then
        if bdet.moco_impu_codi is null then
          pl_me('Debe ingresar el código de impuesto');
        end if;
        if bdet.tiim_codi is null then
          pl_me('Debe ingresar el tipo de impuesto');
        end if;
        if nvl(bdet.s_moco_impo_ii, 0) <= 0 then
          pl_me('Debe ingresar el importe del concepto');
        end if;
      end if;
    end loop;
  
    --validar que no posea detalle de productos
    select count(*)
      into v_count
      from come_movi_prod_deta
     where deta_movi_codi = bcab.movi_codi;
  
    if bcab.movi_timo_codi = 7 and bcab.movi_oper_codi = 43 then
      null; --no debe validar
    else
      if v_count > 0 then
        --perdida
        pl_me('Solo se pueden modificar Documentos que no posean detalle de productos');
      end if;
    end if;
  end pp_valida_concepto;

  procedure pp_set_variable is
  begin
    null;
  
    bcab.movi_codi      := v('P46_MOVI_CODI');
    bcab.timo_dbcr      := v('P46_TIMO_DBCR');
    bcab.movi_oper_codi := v('P46_MOVI_OPER_CODI');
    bcab.movi_iva_mone  := v('P46_MOVI_IVA_MONE');
    bcab.movi_grav_mone := v('P46_MOVI_GRAV_MONE');
    bcab.movi_exen_mone := v('P46_MOVI_EXEN_MONE');
    bcab.s_total        := v('P46_S_TOTAL');
    bcab.movi_timo_codi := v('P46_MOVI_TIMO_CODI_I');
  
    pp_traer_suma_detalle(o_sum_s_moco_impo  => fbdet.sum_s_moco_impo,
                          o_sum_s_moco_iva   => fbdet.sum_s_moco_iva,
                          o_sum_s_total_item => fbdet.sum_s_total_item);
  
    fbdet.f_dif_impo     := nvl(bcab.movi_iva_mone, 0) +
                            nvl(bcab.movi_grav_mone, 0) +
                            nvl(bcab.movi_exen_mone, 0) -
                            nvl(fbdet.sum_s_moco_impo, 0);
    fbdet.f_dif_iva      := nvl(bcab.movi_iva_mone, 0) -
                            nvl(fbdet.sum_s_moco_iva, 0);
    fbdet.f_dif_tot_item := nvl(bcab.s_total, 0) -
                            nvl(fbdet.sum_s_total_item, 0);
  
    --pl_me(bcab.movi_codi || ' - ' || bcab.timo_dbcr || ' - ' ||
    --      bcab.movi_oper_codi);
  
  end pp_set_variable;

  procedure pp_actualiza_registro is
  begin
    pp_set_variable;
    pp_valida_concepto;
    pp_veri_movi_rrhh(p_movi_codi => bcab.movi_codi);
    pp_busca_asie(p_movi_codi => bcab.movi_codi);
    pp_valida_totales;
    pp_validar_conceptos;
    pp_actualiza_moco;
    pp_actualiza_moimpu2;
  
  end pp_actualiza_registro;

  procedure pp_most_op(p_codi in number, p_nume out varchar2) is
  begin
    select orpa_nume
      into p_nume
      from come_orde_pago
     where orpa_codi = p_codi;
  
  exception
    when no_data_found then
      p_nume := null;
  end pp_most_op;

  procedure pp_mues_asie_nume(p_codi in number, p_nume out number) is
  
  begin
  
    select asie_nume into p_nume from come_asie where asie_codi = p_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Número de asiento inexistente!');
  end pp_mues_asie_nume;

  procedure pl_muestra_come_clpr_query(p_ind_clpr  out char,
                                       p_clpr_codi in char) is
    v_tipo_razo      varchar2(1);
    p_clpr_desc      varchar2(1000);
    p_clpr_codi_alte number;
  begin
  
    select nvl(clpr_desc, '0'),
           clpr_codi_alte,
           clpr_indi_clie_prov,
           clpr_tipo_razo
      into p_clpr_desc, p_clpr_codi_alte, p_ind_clpr, v_tipo_razo
      from come_clie_prov
     where clpr_codi = p_clpr_codi;
  
    if p_clpr_desc = '0' then
      if v_tipo_razo = 'F' then
        select upper(clpr_nomb) || ' ' || upper(clpr_apel)
          into p_clpr_desc
          from come_clie_prov
         where clpr_codi = p_clpr_codi;
      
      else
        select clpr_empr
          into p_clpr_desc
          from come_clie_prov
         where clpr_codi = p_clpr_codi;
      end if;
    end if;
  
  exception
    when no_data_found then
      p_ind_clpr := null;
    when others then
      raise_application_error(-20010,
                              'Error el momento de cargar clie/prov: ' ||
                              sqlcode);
  end;

  procedure pp_carg_conc_tabl_auxi(i_movi_codi in number) is
  begin
  
    --pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => v('app_session'),
    --                                   i_taax_user => gen_user);
  
    pp_cargar_nuevo_detalle(i_movi_codi);
  
  exception
    when others then
      raise_application_error(-20010,
                              'Error al momento de cargar concepto deta: ' ||
                              sqlcode);
  end pp_carg_conc_tabl_auxi;

  procedure pp_suma_conc_deta(i_movi_codi in number,
                              o_impo      out number,
                              o_iva       out number) is
  
    v_impo number;
    v_iva  number;
  
  begin
  
    select sum(nvl(moco_impo_mone, 0)),
           sum(nvl(moco_iva10_mmnn, 0) + nvl(moco_iva5_mmnn, 0))
      into v_impo, v_iva
      from come_movi_conc_deta,
           come_conc,
           come_impu,
           come_cent_cost,
           come_empr_secc,
           come_orde_trab,
           come_orde_serv
     where conc_codi(+) = moco_conc_codi
       and impu_codi(+) = moco_impu_codi
       and ceco_codi(+) = moco_ceco_codi
       and emse_codi(+) = moco_emse_codi
       and ortr_codi(+) = moco_ortr_codi
       and orse_codi(+) = moco_orse_codi
       and moco_movi_codi = i_movi_codi;
  
    o_impo := v_impo;
    o_iva  := v_iva;
  
  exception
    when others then
      raise_application_error(-20010,
                              'Error al momento de totalizar: ' || sqlerrm);
    
  end pp_suma_conc_deta;

  procedure pl_muestra_come_tipo_movi(p_timo_codi      in number,
                                      p_timo_desc      out char,
                                      p_timo_desc_abre out char,
                                      p_timo_afec_sald out char,
                                      p_timo_dbcr      out char) is
  
  begin
  
    select timo_desc, timo_desc_abre, timo_afec_sald, timo_dbcr
      into p_timo_desc, p_timo_desc_abre, p_timo_afec_sald, p_timo_dbcr
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
  exception
    when no_data_found then
      p_timo_desc_abre := null;
      p_timo_desc      := null;
      p_timo_afec_sald := null;
      p_timo_dbcr      := null;
    
      raise_application_error(-20010,
                              'Tipo de Movimiento Inexistente!' ||
                              p_timo_codi);
    when others then
      raise_application_error(-20010, 'Error el momento de mostrar TM');
  end;

  procedure pp_muestra_come_conc(p_conc_codi           in number,
                                 i_movi_sucu_codi_orig in number,
                                 i_timo_dbcr           in varchar2,
                                 p_conc_desc           out varchar2,
                                 p_conc_dbcr           out varchar2,
                                 p_conc_indi_kilo_vehi out varchar2,
                                 p_moco_indi_impo      out varchar2,
                                 p_conc_indi_ortr      out varchar2,
                                 p_conc_indi_ceco      out varchar2,
                                 o_cuco_nume           out varchar2,
                                 o_cuco_desc           out varchar2,
                                 o_resp_codi           out number) is
    v_dbcr_desc      char(7);
    v_conc_sucu_codi number;
    v_conc_indi_inac varchar2(1);
    e_salir          exception;
  begin
  
    if p_conc_codi is null then
      raise e_salir;
    end if;
    select conc_desc,
           rtrim(ltrim(conc_dbcr)),
           conc_indi_kilo_vehi,
           conc_sucu_codi,
           nvl(conc_indi_inac, 'N'),
           nvl(conc_indi_impo, 'N'),
           nvl(conc_indi_ortr, 'N'),
           nvl(conc_indi_cent_cost, 'N')
      into p_conc_desc,
           p_conc_dbcr,
           p_conc_indi_kilo_vehi,
           v_conc_sucu_codi,
           v_conc_indi_inac,
           p_moco_indi_impo,
           p_conc_indi_ortr,
           p_conc_indi_ceco
      from come_conc
     where conc_codi = p_conc_codi;
  
    if v_conc_sucu_codi is not null then
      if v_conc_sucu_codi <> i_movi_sucu_codi_orig then
        o_resp_codi := 1;
        raise_application_error(-20010,
                                'El concepto seleccionado no pertenece a la sucursal!');
      end if;
    end if;
  
    if rtrim(ltrim(p_conc_dbcr)) <> rtrim(ltrim(i_timo_dbcr)) then
      if i_timo_dbcr = 'D' then
        v_dbcr_desc := 'Debito';
      else
        v_dbcr_desc := 'Credito';
      end if;
      o_resp_codi := 1;
      raise_application_error(-20010,
                              'Debe ingresar un Concepto de tipo ' ||
                              rtrim(ltrim(v_dbcr_desc)));
    end if;
  
    if v_conc_indi_inac = 'S' then
      o_resp_codi := 1;
      raise_application_error(-20010, 'El concepto se encuentra inactivo');
    end if;
  
    begin
      select cc.cuco_nume, cc.cuco_desc
        into o_cuco_nume, o_cuco_desc
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
        o_resp_codi := 1;
        raise_application_error(-20010,
                                'Error al momento de cargar nro de cuenta: ' ||
                                sqlerrm);
    end;
  
    o_resp_codi := 0;
  
  exception
    when e_salir then
      null;
    when no_data_found then
      p_conc_desc := null;
      p_conc_dbcr := null;
      o_resp_codi := 1;
      raise_application_error(-20010, 'Concepto Inexistente!');
  end;

  procedure pp_mostrar_impu(i_moco_impu_codi           in number,
                            o_moco_impu_porc           out number,
                            o_moco_impu_porc_base_impo out number,
                            o_moco_impu_indi_baim_incl out varchar2) is
  begin
  
    --si el tipo de movimiento tiene el indicador de calculo de iva 'n'
    --entonces siempre será exento....
  
    select impu_porc,
           impu_porc_base_impo,
           nvl(impu_indi_baim_impu_incl, 'S')
      into o_moco_impu_porc,
           o_moco_impu_porc_base_impo,
           o_moco_impu_indi_baim_incl
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

  procedure pp_busca_asie(p_movi_codi in number) is
    v_count number := 0;
  begin
  
    select count(*)
      into v_count
      from come_asie a, come_movi m, come_movi_asie e
     where m.movi_codi = e.moas_movi_codi
       and e.moas_asie_codi = a.asie_codi
       and m.movi_codi = p_movi_codi;
  
    if v_count >= 1 then
      raise_application_error(-20010,
                              'No se puede Modificar el Movimiento porque Posee Asientos Contables');
    end if;
  end;

  function fp_valida_conc_iva(p_conc_codi in number) return boolean is
    --validar que no se seleccione un concepto de tipo iva..
    cursor c_conc_iva is
      select nvl(i.impu_conc_codi_ivdb, -1) impu_conc_codi_ivdb,
             nvl(i.impu_conc_codi_ivcr, -1) impu_conc_codi_ivcr
        from come_impu i
      union
      select nvl(a.conc_codi_ivdb, -1) impu_conc_codi_ivdb,
             nvl(a.conc_codi_ivcr, -1) impu_conc_codi_ivcr
        from come_conc_auxi_iva a
       order by 1;
    v_indi_iva varchar2(1);
  begin
    v_indi_iva := 'N';
    for x in c_conc_iva loop
      if x.impu_conc_codi_ivcr = p_conc_codi or
         x.impu_conc_codi_ivdb = p_conc_codi then
        --no puede seleccionar un concepto de tipo iva
        v_indi_iva := 'S';
      end if;
    end loop;
  
    if v_indi_iva = 'N' then
      return false;
    else
      return true;
    end if;
  end;

  procedure pp_veri_movi_rrhh(p_movi_codi in number) is
  
    v_cant number := 0;
  
  begin
  
    select count(*)
      into v_cant
      from come_movi
     where movi_codi = p_movi_codi
       and movi_rrhh_movi_codi is not null;
  
    if v_cant > 0 then
      raise_application_error(-20010,
                              'El documento no puede ser modificado debido a que ha sido generado desde el modulo de Recursos Humanos');
    end if;
  
  end pp_veri_movi_rrhh;

  procedure pp_validar_conceptos_a is
  
  begin
  
    for bdet in cur_bdet
    
     loop
      if bdet.conc_indi_impo = 'S' then
        if bdet.moco_impo_codi is null then
          pl_me('Debe ingresar una importacion para el concepto ' ||
                bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
        end if;
      end if;
      if bdet.conc_indi_ortr = 'S' then
        if bdet.ortr_codi is null then
          pl_me('Debe ingresar un Nro de OT para el concepto ' ||
                bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
        end if;
      end if;
    
      if nvl(parameter.p_indi_vali_secc_dbcr, 'N') = 'S' then
        if bdet.moco_emse_codi is null then
          pl_me('Debe ingresar la Sección para el concepto ' ||
                bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
        end if;
      end if;
    
      if bdet.conc_indi_cent_cost = 'S' then
        if bdet.moco_ceco_codi is null then
          pl_me('Debe ingresar el centro de costo para el concepto ' ||
                bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
        end if;
      end if;
    
      if bdet.conc_indi_kilo_vehi in ('S', 'M') then
        if bdet.gatr_tran_codi is null then
          pl_me('Debe ingresar el codigo del vehiculo para el concepto ' ||
                bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
        end if;
      end if;
    end loop;
  end;

  procedure pp_delete_members(i_seq_id in number) as
  begin
    apex_collection.delete_member(p_collection_name => 'COLL_BDET',
                                  p_seq             => i_seq_id);

    apex_collection.resequence_collection(p_collection_name => 'COLL_BDET');

  end pp_delete_members;

  procedure pp_agregar_det(i_seq_id              in number,
                           i_movi_cant_deci      in number,
                           i_moco_conc_codi      in number,
                           i_moco_impu_codi      in number,
                           i_tiim_codi           in number,
                           i_moco_impo_ii        in number,
                           i_moco_iva            in number,
                           i_moco_impo_codi      in number,
                           i_moco_ceco_codi      in number,
                           i_det_gatr_tran_codi  in number,
                           i_det_gatr_litr_carg  in number,
                           i_det_gatr_kilo_actu  in number,
                           i_ortr_codi           in number,
                           i_moco_emse_codi      in number,
                           i_moco_orse_codi      in number,
                           i_movi_tasa_mone      in number,
                           i_movi_sucu_codi_orig in number,
                           i_timo_dbcr           in varchar2) as
  
    bdet   cur_bdet%rowtype;
    v_moco come_impu%rowtype;
  
    v_tot_grav_mone  number := 0;
    v_tot_grav_mmnn  number := 0;
    v_tot_iva_mone   number := 0;
    v_tot_iva_mmnn   number := 0;
    v_conc_sucu_codi number;
    v_dbcr_desc      varchar2(20);
    v_conc_indi_inac varchar2(20);
  begin
    --pl_me('aca');
  
    bdet.moco_conc_codi := i_moco_conc_codi;
    bdet.tiim_codi      := i_tiim_codi;
    bdet.moco_impu_codi := i_moco_impu_codi;
    bdet.moco_ceco_codi := i_moco_ceco_codi;
    bdet.ortr_codi      := i_ortr_codi;
    bdet.moco_emse_codi := i_moco_emse_codi;
    bdet.moco_impo_codi := i_moco_impo_codi;
    bdet.orse_codi      := i_moco_orse_codi;
  
    ---***
  
    bdet.s_moco_impo_ii := i_moco_impo_ii;
    bdet.s_moco_iva     := i_moco_iva;
    ----***
  
    if nvl(bdet.s_moco_impo_ii, 0) <= 0 then
      pl_me('Debe ingresar el importe del concepto');
    end if;
  
    pp_mostrar_impu(i_moco_impu_codi           => bdet.moco_impu_codi,
                    o_moco_impu_porc           => v_moco.impu_porc,
                    o_moco_impu_porc_base_impo => v_moco.impu_porc_base_impo,
                    o_moco_impu_indi_baim_incl => v_moco.impu_indi_baim_impu_incl);
  
    select impu_desc, impu_porc, impu_porc_base_impo
      into bdet.moco_impu_desc,
           bdet.moco_impu_porc,
           bdet.moco_impu_porc_base_impo
      from come_impu
     where impu_codi = bdet.moco_impu_codi;
  
    pa_devu_impo_calc(bdet.s_moco_impo_ii,
                      i_movi_cant_deci,
                      v_moco.impu_porc,
                      v_moco.impu_porc_base_impo,
                      v_moco.impu_indi_baim_impu_incl,
                      bdet.moco_impo_mone_ii,
                      bdet.moco_grav10_mone_ii,
                      bdet.moco_grav5_mone_ii,
                      bdet.moco_grav10_mone,
                      bdet.moco_grav5_mone,
                      bdet.moco_iva10_mone,
                      bdet.moco_iva5_mone,
                      bdet.s_moco_impo_exen);
  
    v_tot_grav_mone := bdet.moco_grav10_mone + bdet.moco_grav5_mone;
    v_tot_iva_mone  := bdet.moco_iva10_mone + bdet.moco_iva5_mone;
  
    --   bdet.s_moco_impo_ii := nvl(bdet.s_moco_impo_grav, 0) +
    --                          nvl(bdet.s_moco_impo_iva, 0) +
    --                         nvl(bdet.s_moco_impo_exen, 0);
    -- bdet.s_moco_iva     := bdet.s_moco_impo_iva;
    -- bdet.s_moco_impo    := nvl(bdet.s_moco_impo_ii, 0) -
    --                       nvl(bdet.s_moco_iva, 0);
    ---bdet.s_total_item   := nvl(bdet.s_moco_impo, 0) +
    --                      nvl(bdet.s_moco_iva, 0);
  
    pa_devu_impo_calc(bdet.s_moco_impo_ii * i_movi_tasa_mone,
                      parameter.p_cant_deci_mmnn,
                      bdet.moco_impu_porc,
                      bdet.moco_impu_porc_base_impo,
                      v_moco.impu_indi_baim_impu_incl,
                      bdet.moco_impo_mmnn_ii,
                      bdet.moco_grav10_mmnn_ii,
                      bdet.moco_grav5_mmnn_ii,
                      bdet.moco_grav10_mmnn,
                      bdet.moco_grav5_mmnn,
                      bdet.moco_iva10_mmnn,
                      bdet.moco_iva5_mmnn,
                      bdet.s_moco_impo_exen_mmnn);
  
    v_tot_grav_mmnn := bdet.moco_grav10_mmnn + bdet.moco_grav5_mmnn;
    v_tot_iva_mmnn  := bdet.moco_iva10_mmnn + bdet.moco_iva5_mmnn;
  
    select tiim_desc
      into bdet.tiim_desc
      from come_tipo_impu
     where tiim_codi = bdet.tiim_codi;
  
    select conc_desc,
           conc_dbcr,
           conc_indi_impo,
           conc_indi_ortr,
           conc_indi_cent_cost,
           conc_sucu_codi,
           conc_indi_inac
      into bdet.moco_conc_desc,
           bdet.moco_dbcr,
           bdet.conc_indi_impo,
           bdet.conc_indi_ortr,
           bdet.conc_indi_cent_cost,
           v_conc_sucu_codi,
           v_conc_indi_inac
      from come_conc
     where conc_codi = bdet.moco_conc_codi;
  
    if bdet.conc_indi_impo = 'S' then
      if bdet.moco_impo_codi is null then
        pl_me('Debe ingresar una importacion para el concepto ' ||
              bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
      end if;
    end if;
  
    if bdet.conc_indi_ortr = 'S' then
      if bdet.ortr_codi is null then
        pl_me('Debe ingresar un Nro de OT para el concepto ' ||
              bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
      end if;
    end if;
  
    if nvl(parameter.P_INDI_VALI_SECC_DBCR, 'N') = 'S' then
      if bdet.moco_emse_codi is null then
        pl_me('Debe ingresar la Sección para el concepto ' ||
              bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
      end if;
    end if;
  
    if bdet.conc_indi_cent_cost = 'S' then
      if bdet.moco_ceco_codi is null then
        pl_me('Debe ingresar el centro de costo para el concepto ' ||
              bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
      end if;
    end if;
  
    if bdet.conc_indi_kilo_vehi in ('S', 'M') then
      if bdet.gatr_tran_codi is null then
        pl_me('Debe ingresar el codigo del vehiculo para el concepto ' ||
              bdet.moco_conc_codi || ' ' || bdet.moco_conc_desc);
      end if;
    end if;
  
    if v_conc_sucu_codi is not null then
      if v_conc_sucu_codi <> i_movi_sucu_codi_orig then
        raise_application_error(-20010,
                                'El concepto seleccionado no pertenece a la sucursal!');
      end if;
    end if;
  
    if rtrim(ltrim(bdet.moco_dbcr)) <> rtrim(ltrim(i_timo_dbcr)) then
      if i_timo_dbcr = 'D' then
        v_dbcr_desc := 'Debito';
      else
        v_dbcr_desc := 'Credito';
      end if;
      pl_me('Debe ingresar un Concepto de tipo ' ||
            rtrim(ltrim(v_dbcr_desc)));
    end if;
  
    if v_conc_indi_inac = 'S' then
      pl_me('El concepto se encuentra inactivo');
    end if;
  
    --
    -- bdet.s_moco_iva_mmnn  := (bdet.moco_iva10_mmnn + bdet.moco_iva5_mmnn);
    bdet.s_moco_impo      := nvl(bdet.s_moco_impo_ii, 0) -
                             nvl(bdet.s_moco_iva, 0);
    bdet.s_moco_impo_mmnn := bdet.moco_impo_mmnn_ii -
                             (bdet.moco_iva10_mmnn + bdet.moco_iva5_mmnn);
    if i_seq_id is not null then
      apex_collection.update_member(p_collection_name => 'COLL_BDET',
                                    p_seq             => i_seq_id,
                                    p_c001            => bdet.conc_indi_cent_cost,
                                    p_c002            => bdet.conc_indi_kilo_vehi,
                                    p_c003            => bdet.gatr_tran_codi,
                                    p_c004            => bdet.moco_conc_desc,
                                    ---*=> bdet.* mecesarios para guardado
                                    p_c005 => bdet.conc_indi_impo,
                                    p_c006 => bdet.conc_indi_ortr,
                                    p_c007 => bdet.moco_ceco_codi,
                                    p_c008 => bdet.moco_conc_codi,
                                    p_c009 => bdet.moco_dbcr,
                                    p_c010 => bdet.moco_emse_codi,
                                    p_c011 => bdet.moco_grav10_mmnn,
                                    p_c012 => bdet.moco_grav10_mmnn_ii,
                                    p_c013 => bdet.moco_grav10_mone,
                                    p_c014 => bdet.moco_grav10_mone_ii,
                                    p_c015 => bdet.moco_grav5_mmnn,
                                    p_c016 => bdet.moco_grav5_mmnn_ii,
                                    p_c017 => bdet.moco_grav5_mone,
                                    p_c018 => bdet.moco_grav5_mone_ii,
                                    p_c019 => bdet.moco_impo_codi,
                                    p_c020 => bdet.moco_impo_mmnn_ii,
                                    p_c021 => bdet.moco_impo_mone_ii,
                                    p_c022 => bdet.moco_impu_codi,
                                    p_c023 => bdet.moco_iva10_mmnn,
                                    p_c024 => bdet.moco_iva10_mone,
                                    p_c025 => bdet.moco_iva5_mmnn,
                                    p_c026 => bdet.moco_iva5_mone,
                                    p_c027 => bdet.orse_codi,
                                    p_c028 => bdet.ortr_codi,
                                    p_c029 => bdet.s_moco_impo,
                                    p_c030 => bdet.s_moco_impo_exen,
                                    p_c031 => bdet.s_moco_impo_exen_mmnn,
                                    p_c032 => bdet.s_moco_impo_mmnn,
                                    p_c033 => bdet.tiim_codi,
                                    
                                    ----=> bdet.**** datos para mostrar
                                    p_c034 => bdet.cent_cost_nume,
                                    --  p_c035 => bdet.conc_desc,
                                    --p_c036 => bdet.emse_codi_alte,
                                    p_c037 => bdet.emse_desc,
                                    p_c038 => bdet.impo_nume,
                                    --p_c039 => bdet.impu_desc,
                                    p_c040 => bdet.impu_porc,
                                    p_c041 => bdet.impu_porc_base_impo,
                                    p_c042 => bdet.moco_impu_desc,
                                    p_c043 => bdet.moco_impu_porc,
                                    p_c044 => bdet.moco_impu_porc_base_impo,
                                    -- p_c045 => bdet.moco_movi_codi,
                                    p_c046 => bdet.orse_nume_char,
                                    p_c047 => bdet.ortr_nume,
                                    p_c048 => bdet.s_moco_impo_ii,
                                    p_c049 => bdet.tiim_desc,
                                    p_c050 => bdet.s_moco_iva);
    else
      apex_collection.add_member(p_collection_name => 'COLL_BDET',
                                 p_c001            => bdet.conc_indi_cent_cost,
                                 p_c002            => bdet.conc_indi_kilo_vehi,
                                 p_c003            => bdet.gatr_tran_codi,
                                 p_c004            => bdet.moco_conc_desc,
                                 ---*=> bdet.* mecesarios para guardado
                                 p_c005 => bdet.conc_indi_impo,
                                 p_c006 => bdet.conc_indi_ortr,
                                 p_c007 => bdet.moco_ceco_codi,
                                 p_c008 => bdet.moco_conc_codi,
                                 p_c009 => bdet.moco_dbcr,
                                 p_c010 => bdet.moco_emse_codi,
                                 p_c011 => bdet.moco_grav10_mmnn,
                                 p_c012 => bdet.moco_grav10_mmnn_ii,
                                 p_c013 => bdet.moco_grav10_mone,
                                 p_c014 => bdet.moco_grav10_mone_ii,
                                 p_c015 => bdet.moco_grav5_mmnn,
                                 p_c016 => bdet.moco_grav5_mmnn_ii,
                                 p_c017 => bdet.moco_grav5_mone,
                                 p_c018 => bdet.moco_grav5_mone_ii,
                                 p_c019 => bdet.moco_impo_codi,
                                 p_c020 => bdet.moco_impo_mmnn_ii,
                                 p_c021 => bdet.moco_impo_mone_ii,
                                 p_c022 => bdet.moco_impu_codi,
                                 p_c023 => bdet.moco_iva10_mmnn,
                                 p_c024 => bdet.moco_iva10_mone,
                                 p_c025 => bdet.moco_iva5_mmnn,
                                 p_c026 => bdet.moco_iva5_mone,
                                 p_c027 => bdet.orse_codi,
                                 p_c028 => bdet.ortr_codi,
                                 p_c029 => bdet.s_moco_impo,
                                 p_c030 => bdet.s_moco_impo_exen,
                                 p_c031 => bdet.s_moco_impo_exen_mmnn,
                                 p_c032 => bdet.s_moco_impo_mmnn,
                                 p_c033 => bdet.tiim_codi,
                                 
                                 ----=> bdet.**** datos para mostrar
                                 p_c034 => bdet.cent_cost_nume,
                                 --  p_c035 => bdet.conc_desc,
                                 --p_c036 => bdet.emse_codi_alte,
                                 p_c037 => bdet.emse_desc,
                                 p_c038 => bdet.impo_nume,
                                 --p_c039 => bdet.impu_desc,
                                 p_c040 => bdet.impu_porc,
                                 p_c041 => bdet.impu_porc_base_impo,
                                 p_c042 => bdet.moco_impu_desc,
                                 p_c043 => bdet.moco_impu_porc,
                                 p_c044 => bdet.moco_impu_porc_base_impo,
                                 -- p_c045 => bdet.moco_movi_codi,
                                 p_c046 => bdet.orse_nume_char,
                                 p_c047 => bdet.ortr_nume,
                                 p_c048 => bdet.s_moco_impo_ii,
                                 p_c049 => bdet.tiim_desc,
                                 p_c050 => bdet.s_moco_iva);
    
    end if;
  
  end;

  procedure pp_recuperar_detalle(i_seq_id             in number,
                                 o_moco_conc_codi     out number,
                                 o_moco_impu_codi     out number,
                                 o_tiim_codi          out number,
                                 o_moco_impo_ii       out number,
                                 o_moco_iva           out number,
                                 o_moco_impo_codi     out number,
                                 o_moco_ceco_codi     out number,
                                 o_det_gatr_tran_codi out number,
                                 o_det_gatr_litr_carg out number,
                                 o_det_gatr_kilo_actu out number,
                                 o_ortr_codi          out number,
                                 o_moco_emse_codi     out number,
                                 o_moco_orse_codi     out number) is
    e_salir exception;
  begin
  
    if i_seq_id is null then
      raise e_salir;
    end if;
  
    for bdet in cur_bdet(i_seq_id => i_seq_id) loop
      o_moco_conc_codi     := bdet.moco_conc_codi;
      o_moco_impu_codi     := bdet.moco_impu_codi;
      o_tiim_codi          := bdet.tiim_codi;
      o_moco_impo_ii       := bdet.s_moco_impo_ii;
      o_moco_iva           := bdet.s_moco_iva;
      o_moco_impo_codi     := bdet.moco_impo_codi;
      o_moco_ceco_codi     := bdet.moco_ceco_codi;
      o_det_gatr_tran_codi := bdet.gatr_tran_codi;
      o_ortr_codi          := bdet.ortr_codi;
      o_moco_emse_codi     := bdet.moco_emse_codi;
      o_moco_orse_codi     := bdet.orse_codi;
    end loop;
  exception
    when e_salir then
      null;
  end pp_recuperar_detalle;

  procedure pp_traer_suma_detalle(o_sum_s_moco_impo  out number,
                                  o_sum_s_moco_iva   out number,
                                  o_sum_s_total_item out number) is
    v_sum_s_moco_impo  number := 0;
    v_sum_s_moco_iva   number := 0;
    v_sum_s_total_item number := 0;
  
  begin
    for bdet in cur_bdet loop
      v_sum_s_moco_impo  := v_sum_s_moco_impo + nvl(bdet.s_moco_impo_ii, 0);
      v_sum_s_moco_iva   := v_sum_s_moco_iva + nvl(bdet.s_moco_iva, 0);
      v_sum_s_total_item := v_sum_s_total_item + nvl(bdet.s_moco_impo, 0) +
                            nvl(bdet.s_moco_iva, 0);
    end loop;
  
    o_sum_s_moco_impo  := v_sum_s_moco_impo;
    o_sum_s_moco_iva   := v_sum_s_moco_iva;
    o_sum_s_total_item := v_sum_s_total_item;
  
  end pp_traer_suma_detalle;

  procedure pp_iniciar_collection is
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'COLL_BDET');
  end pp_iniciar_collection;

end i020139;
