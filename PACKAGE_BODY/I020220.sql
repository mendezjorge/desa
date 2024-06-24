
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020220" is

  type r_parameter is record(
    p_peco_codi           number := 1,
    p_vali_dife_cost_impo varchar2(10) := general_skn.fl_busca_parametro('p_vali_dife_cost_impo'),
    p_prorrateo           varchar2(2) := 'N'
    
    );

  parameter r_parameter;

  type r_dato_cab is record(
    impo_dife_camb          number,
    impo_codi               number,
    impo_tasa_fact          number,
    impo_tasa_mone          number,
    sum_moco_impo_mmnn_dife number,
    impo_tasa_mmee          number,
    sum_impo_apli_mmnn      number,
    sum_porc                number);
  bsel r_dato_cab;
  cursor d_gasto is
    select seq_id,
           c001   moco_movi_codi,
           c002   moco_nume_item,
           c003   movi_nume,
           c004   clpr_desc,
           c005   movi_obse,
           c006   movi_fech_emis,
           c007   moco_impo_mmnn
    --  c008   moco_impo_mmnn
      from apex_collections
     where collection_name = 'BDET_GASTOS';

  cursor c_fac is
    select c001   imfa_nume,
           c002   imfa_fech,
           c003   prod_codi_alfa,
           c004   prod_desc,
           c005   prod_codi,
           c006   imde_cant,
           c007   imde_prec_unit_mone,
           c008   imde_porc_reca,
           c009   imde_porc_reca_ante,
           c010   imde_tota_mone,
           c011   imde_tota_mmnn,
           c012   imde_nume_item,
           c013   imde_imfa_codi,
           c014   impo_apli_mmnn, --imde_impo_reca_mmnn ,
           c015   impo_apli_mmnn_ante,
           c016   porc,
           c017   porc_gast,
           c018   porc_gast_ante,
           c019   item_mayo,
           seq_id
      from apex_collections
     where collection_name = 'BDET_FACT';

  procedure pp_mostrar_impo(p_impo_nume      in number,
                            p_clpr_codi      in number,
                            p_impo_codi      out number,
                            p_mone_desc_abre out varchar2,
                            p_mone_cant_deci out number,
                            p_indi_cost      out varchar2,
                            p_tasa_mone      out number,
                            p_tasa_mmee      out number,
                            p_impo_mone_codi out number,
                            p_ind_cost       out varchar2,
                            p_ind_ele        out varchar2,
                            p_ind_stock      out varchar) is
    v_clpr_codi number;
    v_indi      varchar2(1);
    v_indi_cost varchar2(1);
  
  begin
  
    select impo_codi,
           impo_clpr_codi,
           impo_indi_ingr_stoc,
           impo_mone_codi,
           impo_indi_cost,
           mone_desc_abre,
           mone_cant_deci,
           impo_tasa_mone,
           impo_tasa_mmee
      into p_impo_codi,
           v_clpr_codi,
           v_indi,
           p_impo_mone_codi,
           v_indi_cost,
           p_mone_desc_abre,
           p_mone_cant_deci,
           p_tasa_mone,
           p_tasa_mmee
      from come_impo, come_mone
     where impo_mone_codi = mone_codi
       and impo_nume = p_impo_nume;
  
    if p_clpr_codi is not null then
      if v_clpr_codi <> p_clpr_codi then
        raise_application_error(-20001,
                                'La importacion no corresponde al proveedor seleccionado.');
      end if;
    end if;
  
    if v_indi = 'S' then
      raise_application_error(-20001,
                              'Esta importacion ya fue ingresada al stock');
    end if;
  
    if v_indi_cost = 'S' then
      /* p_ind_ele*/
      p_ind_cost := 'S';
    else
      p_ind_cost := 'N';
    end if;
  
    if v_indi = 'S' then
      p_ind_stock := 'N';
    end if;
  
    p_indi_cost := v_indi_cost;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Numero de Importacion inexistente');
    when too_many_rows then
      raise_application_error(-20001, 'Importacion duplicada');
  end pp_mostrar_impo;

  procedure pp_calc_impo_dife_tasa(p_impo_codi      in number,
                                   p_impo_tasa_mone in number,
                                   p_impo_tasa_fact out number,
                                   p_impo_tasa_dife out number) is
  
  begin
  
    select f.imfa_tasa_mone_deud
      into p_impo_tasa_fact
      from come_impo_fact f, come_impo i
     where f.imfa_impo_codi = i.impo_codi
       and impo_codi = p_impo_codi;
  
    if nvl(p_impo_tasa_fact, 0) <> nvl(p_impo_tasa_mone, 0) then
      p_impo_tasa_dife := nvl(p_impo_tasa_fact, 0) -
                          nvl(p_impo_tasa_mone, 0);
    else
      p_impo_tasa_dife := 0;
    end if;
  
  exception
    when others then
      p_impo_tasa_dife := 0;
  end pp_calc_impo_dife_tasa;

  procedure pp_validar_loteo(p_impo_codi in number, p_indi out varchar2) is
  
    cursor c_deta is
      select imde_nume_item, imde_imfa_codi, prod_codi_alfa, prod_desc
        from come_impo_fact, come_impo_fact_deta, come_prod
       where imfa_codi = imde_imfa_codi
         and imde_prod_codi = prod_codi
         and nvl(prod_indi_lote, 'N') = 'S'
         and imfa_impo_codi = p_impo_codi
       order by imde_nume_item;
  
    v_count number;
    v_indi  varchar2(1) := 'S';
  begin
  
    for x in c_deta loop
      select count(*)
        into v_count
        from come_impo_fact_deta_lote
       where delo_imfa_codi = x.imde_imfa_codi
         and delo_nume_item = x.imde_nume_item;
    
      if v_count = 0 then
        v_indi := 'N';
      
        raise_application_error(-20001,
                                'PRIMERO DEBE GENERAR LOS LOTES DEL PRODUCTO ' ||
                                x.prod_codi_alfa || '  ' || x.prod_desc);
        exit;
      end if;
    
    end loop;
  
    p_indi := v_indi;
  end pp_validar_loteo;

  procedure pp_carga_bloque_gastos(p_impo_codi in number) is
  
    cursor c_gastos is
      select m.movi_nume,
             c.clpr_desc,
             m.movi_obse,
             d.moco_nume_item,
             d.moco_movi_codi,
             decode(m.movi_timo_codi,
                    11,
                    -d.moco_impo_mmnn,
                    12,
                    -d.moco_impo_mmnn,
                    17,
                    -d.moco_impo_mmnn,
                    18,
                    -d.moco_impo_mmnn,
                    d.moco_impo_mmnn) moco_impo_mmnn,
             m.movi_fech_emis
        from come_movi           m,
             come_movi_conc_deta d,
             come_clie_prov      c,
             come_conc           co
       where m.movi_codi = d.moco_movi_codi
         and m.movi_clpr_codi = c.clpr_codi
         and co.conc_codi = d.moco_conc_codi
         and c.clpr_indi_clie_prov = 'P'
         and d.moco_conc_codi not in
             (select nvl(impu_conc_codi_ivdb, -1)
                from come_impu
              union
              select nvl(impu_conc_codi_ivcr, -1)
                from come_impu)
         and (m.movi_impo_codi = p_impo_codi or
             moco_impo_codi = p_impo_codi)
      
       order by m.movi_fech_emis;
  
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDET_GASTOS');
  
    for x in c_gastos loop
    
      apex_collection.add_member(p_collection_name => 'BDET_GASTOS',
                                 p_c001            => x.moco_movi_codi,
                                 p_c002            => x.moco_nume_item,
                                 p_c003            => x.movi_nume,
                                 p_c004            => x.clpr_desc,
                                 p_c005            => x.movi_obse,
                                 p_c006            => x.movi_fech_emis,
                                 p_c007            => x.moco_impo_mmnn /*,
                                                                                                   p_c008            => x.moco_impo_mmnn*/);
    
    end loop;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_carga_bloque_gastos;

  procedure pp_carga_item_fact(p_impo_codi      in number,
                               p_impo_tasa_mone in number) is
  
    cursor c_impo is
      select f.imfa_nume,
             f.imfa_fech,
             p.prod_codi_alfa,
             p.prod_desc,
             p.prod_codi,
             d.imde_cant,
             d.imde_prec_unit_mone,
             
             d.imde_nume_item,
             d.imde_imfa_codi,
             d.imde_porc_reca,
             d.imde_tota_mone_brut,
             d.imde_deto_reca,
             imde_impo_reca_mmnn,
             imde_impo_reca_mone,
             
             imde_tota_mone, ---el total neto, pero sin el costeo
             imde_tota_mmnn,
             imde_tota_mmee
      
        from come_impo_fact f, come_impo_fact_deta d, come_prod p
       where f.imfa_codi = d.imde_imfa_codi
         and d.imde_prod_codi = p.prod_codi
         and f.imfa_impo_codi = p_impo_codi
       order by imde_nume_item;
  
    v_sum_imde_tota_mone      number := 0;
    v_sum_imde_impo_reca_mmnn number := 0;
  
    v_sum_porc      number := 0;
    v_sum_porc_gast number := 0;
  
    v_item_mayo      number := 0;
    v_impo_mayo      number := 0;
    v_porc           number;
    v_porc_gast      number;
    v_porc_gast_ante number;
    v_seq_id         number;
  
    --v_porc number;
  
  begin
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDET_FACT');
  
    for x in c_impo loop
      v_sum_imde_tota_mone      := v_sum_imde_tota_mone +
                                   nvl(x.imde_tota_mone, 0);
      v_sum_imde_impo_reca_mmnn := v_sum_imde_impo_reca_mmnn +
                                   nvl(x.imde_impo_reca_mmnn, 0);
    
    --  raise_application_error(-20001,'ddd '||v_sum_imde_impo_reca_mmnn);
    end loop;
  
    for x in c_impo loop
    
      if v_sum_imde_tota_mone > 0 then
        v_porc := round((x.imde_tota_mone * 100 / v_sum_imde_tota_mone), 6);
      end if;
      if v_sum_imde_impo_reca_mmnn > 0 then
        v_porc_gast := round((x.imde_impo_reca_mmnn * 100 /
                             v_sum_imde_impo_reca_mmnn),
                             6);
      
        v_porc_gast_ante := v_porc_gast;
      end if;
    
      v_sum_porc      := v_sum_porc + v_porc;
      v_sum_porc_gast := v_sum_porc_gast + v_porc_gast;
    
      if x.imde_tota_mone > v_impo_mayo then
        v_item_mayo := v_item_mayo + 1;
        v_impo_mayo := x.imde_tota_mone;
      end if;
    
      apex_collection.add_member(p_collection_name => 'BDET_FACT',
                                 p_c001            => x.imfa_nume,
                                 p_c002            => x.imfa_fech,
                                 p_c003            => x.prod_codi_alfa,
                                 p_c004            => x.prod_desc,
                                 p_c005            => x.prod_codi,
                                 p_c006            => x.imde_cant,
                                 p_c007            => x.imde_prec_unit_mone,
                                 p_c008            => x.imde_porc_reca,
                                 p_c009            => x.imde_porc_reca, ----imde_porc_reca_anterior
                                 p_c010            => x.imde_tota_mone,
                                 p_c011            => round(x.imde_tota_mone *
                                                            p_impo_tasa_mone,
                                                            0), --imde_tota_mmnn
                                 p_c012            => x.imde_nume_item,
                                 p_c013            => x.imde_imfa_codi,
                                 p_c014            => x.imde_impo_reca_mmnn,
                                 p_c015            => x.imde_impo_reca_mmnn, ---impo_apli_mmnn_ante
                                 p_c016            => v_porc,
                                 p_c017            => v_porc_gast,
                                 p_c018            => v_porc_gast_ante,
                                 p_c019            => v_item_mayo);
    
    end loop;
  
    if v_sum_imde_tota_mone > 0 then
    
      if v_sum_porc <> 100 then
      
        ----go_record(v_item_mayo);
        select seq_id, c016 porc
          into v_seq_id, v_porc
          from apex_collections
         where collection_name = 'BDET_FACT'
           and seq_id = v_item_mayo;
        --:bdet_fact.porc := v_porc + (100-v_sum_porc);  
      
        i020220.pp_update_member('BDET_FACT',
                                 v_seq_id,
                                 v_porc + (100 - v_sum_porc),
                                 16);
      
      end if;
    end if;
  
    if v_sum_imde_impo_reca_mmnn > 0 then
    
      if v_sum_porc_gast <> 100 then
        select seq_id, c017 porc
          into v_seq_id, v_porc
          from apex_collections
         where collection_name = 'BDET_FACT'
           and seq_id = v_item_mayo;
      
        i020220.pp_update_member('BDET_FACT',
                                 v_seq_id,
                                 v_porc + (100 - v_sum_porc_gast),
                                 17);
      
        i020220.pp_update_member('BDET_FACT',
                                 v_seq_id,
                                 v_porc + (100 - v_sum_porc_gast),
                                 18);
      
        --  :bdet_fact.porc_gast      := :bdet_fact.porc_gast + (100-v_sum_porc_gast);  
        --  :bdet_fact.porc_gast_ante := :bdet_fact.porc_gast; 
      
      end if;
    end if;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_carga_item_fact;

  procedure pp_update_member(p_name_collection in varchar2,
                             p_seq_id          in number,
                             p_valor           in varchar2,
                             p_nro_upd         in number) is
  begin
    apex_collection.update_member_attribute(p_collection_name => p_name_collection,
                                            p_seq             => p_seq_id,
                                            p_attr_number     => p_nro_upd,
                                            p_attr_value      => p_valor);
  end pp_update_member;

  procedure pp_prorratear_importes(p_impo_dife_camb in number,
                                   p_impo_tasa_mone in number) is
    v_sum_moco_impo_mmnn number;
  
    v_tota_porc               number;
    v_tota_porc_gast          number;
    v_sum_moco_impo_mmnn_dife number;
  
    v_sum_impo_apli_mmnn number := 0;
  
    v_item_mayor          number := 0;
    v_impo_mayor          number := 0;
    v_IMDE_PORC_RECA      number := 0;
    v_IMDE_PORC_RECA_ante number := 0;
    p_prorrateo           varchar2(2) := 'S';
    v_sum_imde_tota_mone  number;
    v_impo_apli_mmnn      number;
    v_PORC_GAST           number;
    v_PORC_GAST_ante      number;
    v_IMPO_APLI_MMNN_ANTE number;
    v_porc                number;
    v_seq_id              number;
  begin
  
    parameter.p_prorrateo := 'S';
    --- raise_application_error(-20001,'ddd');
    ---v_sum_moco_impo_mmnn := :bdet_gastos.sum_moco_impo_mmnn_dife;
    select sum(c007) + (nvl(p_impo_dife_camb, 0))
      into v_sum_moco_impo_mmnn
      from apex_collections
     where collection_name = 'BDET_GASTOS';
  
    ---v_sum_moco_impo_mmnn := :bdet_gastos.sum_moco_impo_mmnn_dife;
    select sum(c010) imde_tota_mone
      into v_sum_imde_tota_mone
      from apex_collections
     where collection_name = 'BDET_FACT';
  
    v_tota_porc      := 0;
    v_tota_porc_gast := 0;
    for bdet_fact in c_fac loop
    
      v_PORC := round((nvl(bdet_fact.imde_tota_mone, 0) * 100 /
                      nvl(v_sum_imde_tota_mone, 1)),
                      6);
      i020220.pp_update_member('BDET_FACT', bdet_fact.seq_id, v_PORC, 16);
    
      --  :bdet_fact.porc       :=  round((nvl(bdet_fact.imde_tota_mone,0) * 100 / nvl(v_sum_imde_tota_mone,1)),6);
    
      v_tota_porc := v_tota_porc + v_porc;
    
      if bdet_fact.imde_tota_mone > v_impo_mayor then
        v_item_mayor := v_item_mayor + 1; --bdet_fact.imde_nume_item;
        v_impo_mayor := bdet_fact.imde_tota_mone;
      
      end if;
    end loop;
  
    if v_tota_porc <> 100 then
    
      declare
        v_porc   number;
        v_seq_id number;
      begin
      
        select seq_id, c016 porc
          into v_seq_id, v_porc
          from apex_collections
         where collection_name = 'BDET_FACT'
           and v_seq_id = v_item_mayor;
      
        i020220.pp_update_member('BDET_FACT',
                                 v_seq_id,
                                 v_porc + (100 - v_tota_porc),
                                 16);
      exception
        when no_data_found then
          null;
        when others then
          raise_application_error(-20001, 'Error  ' || sqlerrm);
          -- :bdet_fact.porc := :bdet_fact.porc + (100-v_tota_porc)  ;   
      end;
    end if;
  
    --  first_record; 
    -- v_sum_impo_apli_mmnn := 0;
    ---validar y actualizar en forma
    /*
    for bdet_fact in c_fac loop
    
      bdet_fact.impo_apli_mmnn      := round(v_sum_moco_impo_mmnn *
                                             bdet_fact.porc / 100,
                                             0);
      bdet_fact.impo_apli_mmnn_ante := bdet_fact.impo_apli_mmnn;
    
      v_sum_impo_apli_mmnn := v_sum_impo_apli_mmnn +
                              nvl(bdet_fact.impo_apli_mmnn, 0);
    
      if nvl(v_sum_moco_impo_mmnn, 0) = 0 then
        v_sum_moco_impo_mmnn_dife := 1;
      else
        v_sum_moco_impo_mmnn_dife := v_sum_moco_impo_mmnn;
      end if;
    
      bdet_fact.porc_gast      := bdet_fact.porc; --round((:bdet_fact.impo_apli_mmnn  * 100 / v_sum_moco_impo_mmnn_dife),6); --- la veriable se usa para evitar un error no divisible entre cero
      bdet_fact.porc_gast_ante := bdet_fact.porc_gast;
    
      v_tota_porc_gast := v_tota_porc_gast + bdet_fact.porc_gast;
    
      bdet_fact.imde_porc_reca      := round(((bdet_fact.impo_apli_mmnn /
                                             p_impo_tasa_mone) * 100) /
                                             bdet_fact.imde_tota_mone,
                                             4);
      bdet_fact.imde_porc_reca_ante := bdet_fact.imde_porc_reca;
    
    end loop;
    
     */
  
    for bdet_fact in c_fac LOOP
    
      v_IMPO_APLI_MMNN      := ROUND(V_SUM_MOCO_IMPO_MMNN * BDET_FACT.PORC / 100,
                                     0);
      v_IMPO_APLI_MMNN_ANTE := v_IMPO_APLI_MMNN;
    
      V_SUM_IMPO_APLI_MMNN := V_SUM_IMPO_APLI_MMNN +
                              NVL(v_IMPO_APLI_MMNN, 0);
    
      IF NVL(v_SUM_MOCO_IMPO_MMNN_DIFE, 0) = 0 THEN
        V_SUM_MOCO_IMPO_MMNN_DIFE := 1;
      ELSE
        V_SUM_MOCO_IMPO_MMNN_DIFE := v_SUM_MOCO_IMPO_MMNN_DIFE;
      END IF;
    
      v_PORC_GAST      := BDET_FACT.PORC; --ROUND((:BDET_FACT.IMPO_APLI_MMNN  * 100 / V_SUM_MOCO_IMPO_MMNN_DIFE),6); --- LA VERIABLE SE USA PARA EVITAR UN ERROR NO DIVISIBLE ENTRE CERO
      v_PORC_GAST_ANTE := v_PORC_GAST;
    
      V_TOTA_PORC_GAST := V_TOTA_PORC_GAST + v_PORC_GAST;
    
      v_IMDE_PORC_RECA      := ROUND(((v_IMPO_APLI_MMNN / p_IMPO_TASA_MONE) * 100) /
                                     BDET_FACT.IMDE_TOTA_MONE,
                                     4);
      v_IMDE_PORC_RECA_ANTE := v_IMDE_PORC_RECA;
    
      i020220.pp_update_member('BDET_FACT',
                               bdet_fact.seq_id,
                               v_IMDE_PORC_RECA,
                               8);
      i020220.pp_update_member('BDET_FACT',
                               bdet_fact.seq_id,
                               v_IMDE_PORC_RECA,
                               9);
      i020220.pp_update_member('BDET_FACT',
                               bdet_fact.seq_id,
                               v_IMPO_APLI_MMNN,
                               14);
    
      i020220.pp_update_member('BDET_FACT',
                               bdet_fact.seq_id,
                               v_IMPO_APLI_MMNN_ANTE,
                               15);
    
      i020220.pp_update_member('BDET_FACT',
                               bdet_fact.seq_id,
                               v_PORC_GAST,
                               17);
    
      i020220.pp_update_member('BDET_FACT',
                               bdet_fact.seq_id,
                               v_PORC_GAST,
                               18);
    END LOOP;
    if (v_tota_porc_gast <> 100 or
       v_sum_impo_apli_mmnn <> v_sum_moco_impo_mmnn) then
      --  go_record(v_item_mayor);
      --  raise_application_error(-20001,'ridiculaaass....'||v_item_mayor);
      begin
        select seq_id, c017 porc, c014 impo_apli_mmnn
          into v_seq_id, v_porc, v_impo_apli_mmnn
          from apex_collections
         where collection_name = 'BDET_FACT'
           and v_seq_id = v_item_mayor;
      exception
        when others then
          null;
      end;
    
      -- raise_application_error(-20001,'ridicula,,,');
      if v_seq_id is not null then
        i020220.pp_update_member('BDET_FACT',
                                 v_seq_id,
                                 v_porc + (100 - v_tota_porc_gast),
                                 17);
      
        i020220.pp_update_member('BDET_FACT',
                                 v_seq_id,
                                 v_porc + (100 - v_tota_porc_gast),
                                 18);
      
        i020220.pp_update_member('BDET_FACT',
                                 v_seq_id,
                                 v_impo_apli_mmnn + (v_sum_moco_impo_mmnn -
                                 v_sum_impo_apli_mmnn),
                                 14);
      
        i020220.pp_update_member('BDET_FACT',
                                 v_seq_id,
                                 v_impo_apli_mmnn + (v_sum_moco_impo_mmnn -
                                 v_sum_impo_apli_mmnn),
                                 15);
      
      end if;
    
    end if;
  
    parameter.p_prorrateo := 'N';
  
  exception
    when no_data_found then
      null;
    when others then
      raise_application_error(-20001,
                              'Error pp_prorratear_importes ' || sqlerrm);
  end pp_prorratear_importes;

  procedure pp_validaciones is
  begin
  
    if bsel.impo_tasa_mone is null then
      raise_application_error(-20001,
                              'Debe ingresar la tasa de la moneda de la importacion ');
    end if;
  
    if bsel.impo_tasa_mmee is null then
      raise_application_error(-20001,
                              'Debe ingresar la tasa de la moneda extranjera Us');
    end if;
  
    if nvl(bsel.sum_moco_impo_mmnn_dife, 0) <>
       nvl(bsel.sum_impo_apli_mmnn, 0) then
      if parameter.p_vali_dife_cost_impo = 'S' then
        raise_application_error(-20001,
                                'El total aplicado debe ser igual al total del bloque de gastos!');
        /* else
        raise_application_error(-20001, 'El total aplicado debe ser igual al total del bloque de gastos!');*/
      end if;
    end if;
  
    if round(bsel.sum_porc, 0) <> 100 then
      raise_application_error(-20001, 'El porcentaje debe ser 100%!!');
    end if;
  
  end pp_validaciones;
  /*
  procedure pp_costear_importacion is
  
    cursor c_lote(p_imde_imfa_codi in number, p_imde_nume_item in number) is
      select delo_imfa_codi,
             delo_nume_item,
             delo_lote_codi,
             delo_cant,
             delo_prec_unit,
             delo_deto_reca,
             delo_tota_brut,
             delo_tota_mone,
             delo_tota_mmnn,
             delo_base,
             delo_user_regi,
             delo_fech_regi,
             delo_empr_codi,
             delo_lote_desc,
             delo_lote_fech_elab,
             delo_lote_fech_venc,
             delo_sesi_user_imfa,
             delo_prod_codi,
             delo_tota_reca_mone,
             delo_tota_reca_mmnn,
             delo_cant_stock,
             delo_porc_reca,
             delo_lote_codi_barr,
             
             delo_codi
        from come_impo_fact_deta_lote
       where delo_imfa_codi = p_imde_imfa_codi
         and delo_nume_item = p_imde_nume_item
       order by delo_lote_codi;
  
    v_imde_tota_mmnn      number;
    v_imde_impo_reca_mmnn number;
    v_imde_impo_reca_mone number;
  
    v_delo_porc_reca          number(20, 4);
    v_delo_tota_reca_mone     number(20, 4);
    v_delo_tota_reca_mmnn     number(20, 4);
    v_delo_tota_mmnn          number(20, 4);
    v_sum_delo_tota_reca_mone number(20, 4);
    v_sum_delo_tota_reca_mmnn number(20, 4);
    v_sum_delo_tota_mmnn      number(20, 4);
  
    type tr_come_impo_fact_deta is record(
      imde_impo_reca_mmnn number(20, 4),
      imde_impo_reca_mone number(20, 4),
      
      imde_tota_mone number(20, 4),
      imde_tota_mmnn number(20, 4),
      
      imde_porc_reca number(20, 6),
      imde_imfa_codi number(10),
      imde_nume_item number(10));
    v_imde_tota_mone number(20, 4);
  
    type tt_come_impo_fact_deta is table of tr_come_impo_fact_deta index by binary_integer;
  
    ta_come_impo_fact_deta tt_come_impo_fact_deta;
  
    v_idx number := 0;
  
    v_sum_moco_impo_mone_dife number;
  
    v_item_mayo number;
    v_impo_mayo number := 0;
  
    v_sum_imde_impo_reca_mone number := 0;
  
    cursor c_fact(p_impo_codi in number) is
      select imfa_codi, imfa_tasa_mone_deud, impo_tasa_mone
        from come_impo_fact, come_impo
       where imfa_impo_codi = impo_codi
         and impo_codi = p_impo_codi
       order by imfa_codi;
  
    cursor c_deta(p_imfa_codi in number) is
      select imde_nume_item,
             imde_imfa_codi,
             imde_impo_reca_mmnn,
             imde_impo_reca_mone,
             imde_tota_mmnn,
             imde_tota_mone,
             imde_porc_reca
        from come_impo_fact, come_impo_fact_deta
       where imfa_codi = imde_imfa_codi
         and imfa_codi = p_imfa_codi;
  
    v_idx_mayo           number;
    v_tota_mayo          number := 0;
    v_sum_imde_tota_mone number := 0;
    v_sum_imde_tota_mmnn number := 0;
    v_tota_gs            number;
  
    v_delo_porc number;
  
  begin
    ---actualizar la tasa y si ya fue costeada la importacion
    update come_impo
       set impo_indi_cost = 'S',
           impo_dife_camb = nvl(bsel.impo_dife_camb, 0),
           impo_tasa_fact = nvl(bsel.impo_tasa_fact, 1)
     where impo_codi = bsel.impo_codi;
  
    ---primero asignamos el importe de recargo en mmnn en la tabla.. luego ya haremos el resto directamente desde la tabla
    v_idx := 0;
  
    v_item_mayo := null;
    v_idx_mayo  := null;
    v_impo_mayo := 0;
  
    --asigna el importe de recargo en mmnn
    --go_block('bdet_fact');
    --first_record;
    for bdet_fact in c_fac loop
      v_idx := v_idx + 1;
      ta_come_impo_fact_deta(v_idx).imde_impo_reca_mmnn := bdet_fact.impo_apli_mmnn;
    
      ta_come_impo_fact_deta(v_idx).imde_tota_mone := bdet_fact.imde_tota_mone;
      ta_come_impo_fact_deta(v_idx).imde_porc_reca := bdet_fact.imde_porc_reca;
    
      ta_come_impo_fact_deta(v_idx).imde_imfa_codi := bdet_fact.imde_imfa_codi;
      ta_come_impo_fact_deta(v_idx).imde_nume_item := bdet_fact.imde_nume_item;
    
      if ta_come_impo_fact_deta(v_idx).imde_tota_mone > v_impo_mayo then
        v_idx_mayo  := v_idx;
        v_item_mayo := ta_come_impo_fact_deta(v_idx).imde_nume_item;
        v_impo_mayo := ta_come_impo_fact_deta(v_idx).imde_tota_mone;
      end if;
    
    end loop;
  
    if v_sum_imde_impo_reca_mone <> v_sum_moco_impo_mone_dife then
      ta_come_impo_fact_deta(v_idx_mayo).imde_impo_reca_mone := ta_come_impo_fact_deta(v_idx_mayo).imde_impo_reca_mone +
                                                                 (v_sum_moco_impo_mone_dife -
                                                                                                    v_sum_imde_impo_reca_mone);
    end if;
  
    for x in 1 .. ta_come_impo_fact_deta.count loop
    
      update come_impo_fact_deta
         set imde_impo_reca_mmnn = ta_come_impo_fact_deta(x).imde_impo_reca_mmnn,
             imde_porc_reca      = ta_come_impo_fact_deta(x).imde_porc_reca
       where imde_imfa_codi = ta_come_impo_fact_deta(x).imde_imfa_codi
         and imde_nume_item = ta_come_impo_fact_deta(x).imde_nume_item;
    
    end loop;
    commit;
  
    v_sum_imde_impo_reca_mone := 0;
  
    for z in c_fact(bsel.impo_codi) loop
      v_sum_imde_tota_mone := 0;
      v_sum_imde_tota_mmnn := 0;
      v_tota_mayo          := 0;
      v_idx_mayo           := null;
    
      for x in c_deta(z.imfa_codi) loop
        v_sum_imde_tota_mone      := v_sum_imde_tota_mone +
                                     nvl(x.imde_tota_mone, 0);
        v_imde_tota_mmnn          := round((nvl(x.imde_tota_mone, 0) *
                                           z.impo_tasa_mone),
                                           0);
        v_sum_imde_tota_mmnn      := v_sum_imde_tota_mmnn +
                                     v_imde_tota_mmnn;
        v_imde_impo_reca_mone     := round((x.imde_impo_reca_mmnn /
                                           bsel.impo_tasa_mone),
                                           2);
        v_sum_imde_impo_reca_mone := v_sum_imde_impo_reca_mone +
                                     v_imde_impo_reca_mone;
      
        update come_impo_fact_deta
           set imde_tota_mmnn      = v_imde_tota_mmnn,
               imde_impo_reca_mone = v_imde_impo_reca_mone
         where imde_imfa_codi = x.imde_imfa_codi
           and imde_nume_item = x.imde_nume_item;
      
        if x.imde_tota_mone > v_tota_mayo then
          v_idx_mayo  := x.imde_nume_item;
          v_tota_mayo := nvl(x.imde_tota_mone, 0);
        end if;
      end loop;
    
      v_tota_gs := round((v_sum_imde_tota_mone * z.impo_tasa_mone), 0);
    
      if v_tota_gs <> v_sum_imde_tota_mmnn then
        update come_impo_fact_deta
           set imde_tota_mmnn = imde_tota_mmnn +
                                (v_tota_gs - v_sum_imde_tota_mmnn)
         where imde_imfa_codi = z.imfa_codi
           and imde_nume_item = v_item_mayo;
      end if;
    
      v_sum_moco_impo_mone_dife := round(( ---:bdet_gastos.
                                          bsel.sum_moco_impo_mmnn_dife /
                                          bsel.impo_tasa_mone),
                                         2);
    
      if v_sum_moco_impo_mone_dife <> v_sum_imde_impo_reca_mone then
        update come_impo_fact_deta
           set imde_impo_reca_mone = imde_impo_reca_mone +
                                     (v_sum_moco_impo_mone_dife -
                                     v_sum_imde_impo_reca_mone)
         where imde_imfa_codi = z.imfa_codi
           and imde_nume_item = v_item_mayo;
      end if;
    
    end loop;
  
    commit;
  
    ---ahora hay que hacer lo mismo pero por item de lotes.
  
    for z in c_fact(bsel.impo_codi) loop
      for x in c_deta(z.imfa_codi) loop
        v_imde_tota_mmnn      := x.imde_tota_mmnn;
        v_imde_impo_reca_mmnn := x.imde_impo_reca_mmnn;
        v_imde_impo_reca_mone := x.imde_impo_reca_mone;
        v_imde_tota_mone      := x.imde_tota_mone;
      
        v_sum_delo_tota_mmnn      := 0;
        v_sum_delo_tota_reca_mmnn := 0;
        v_sum_delo_tota_reca_mone := 0;
      
        v_item_mayo := null;
        v_impo_mayo := 0;
      
        for y in c_lote(x.imde_imfa_codi, x.imde_nume_item) loop
          v_delo_porc           := y.delo_tota_mone * 100 /
                                   v_imde_tota_mone;
          v_delo_porc_reca      := x.imde_porc_reca;
          v_delo_tota_mmnn      := round((y.delo_tota_mone *
                                         bsel.impo_tasa_mone),
                                         0);
          v_delo_tota_reca_mmnn := round((v_imde_impo_reca_mmnn *
                                         v_delo_porc / 100),
                                         0);
          v_delo_tota_reca_mone := round((v_delo_tota_reca_mmnn /
                                         bsel.impo_tasa_mone),
                                         2);
        
          v_sum_delo_tota_mmnn      := v_sum_delo_tota_mmnn +
                                       v_delo_tota_mmnn;
          v_sum_delo_tota_reca_mmnn := v_sum_delo_tota_reca_mmnn +
                                       v_delo_tota_reca_mmnn;
          v_sum_delo_tota_reca_mone := v_sum_delo_tota_reca_mone +
                                       v_delo_tota_reca_mone;
        
          if y.delo_tota_mone > v_impo_mayo then
            v_item_mayo := y.delo_codi;
            v_impo_mayo := y.delo_tota_mone;
          end if;
        
          update come_impo_fact_deta_lote
             set delo_tota_mmnn      = v_delo_tota_mmnn,
                 delo_tota_reca_mone = v_delo_tota_reca_mone,
                 delo_tota_reca_mmnn = v_delo_tota_reca_mmnn,
                 delo_porc_reca      = v_delo_porc_reca
           where delo_codi = y.delo_codi;
        end loop; --c_lote
      
        if v_imde_tota_mmnn <> v_sum_delo_tota_mmnn then
          update come_impo_fact_deta_lote
             set delo_tota_mmnn = delo_tota_mmnn +
                                  (v_imde_tota_mmnn - v_sum_delo_tota_mmnn)
           where delo_codi = v_item_mayo;
        end if;
      
        if v_imde_impo_reca_mmnn <> v_sum_delo_tota_reca_mmnn then
          update come_impo_fact_deta_lote
             set delo_tota_reca_mmnn = delo_tota_reca_mmnn +
                                       (v_imde_impo_reca_mmnn -
                                       v_sum_delo_tota_reca_mmnn)
           where delo_codi = v_item_mayo;
        end if;
      
        if v_imde_impo_reca_mone <> v_sum_delo_tota_reca_mone then
          update come_impo_fact_deta_lote
             set delo_tota_reca_mone = delo_tota_reca_mone +
                                       (v_imde_impo_reca_mone -
                                       v_sum_delo_tota_reca_mone)
           where delo_codi = v_item_mayo;
        end if;
      
      end loop; ---c_deta
    end loop; ---c_fact 
  
    commit;
  
  end pp_costear_importacion;
  
  
  
  */

  PROCEDURE PP_COSTEAR_IMPORTACION IS
  
    CURSOR C_LOTE(P_IMDE_IMFA_CODI IN NUMBER, P_IMDE_NUME_ITEM IN NUMBER) IS
      SELECT DELO_IMFA_CODI,
             DELO_NUME_ITEM,
             DELO_LOTE_CODI,
             DELO_CANT,
             DELO_PREC_UNIT,
             DELO_DETO_RECA,
             DELO_TOTA_BRUT,
             DELO_TOTA_MONE,
             DELO_TOTA_MMNN,
             DELO_BASE,
             DELO_USER_REGI,
             DELO_FECH_REGI,
             DELO_EMPR_CODI,
             DELO_LOTE_DESC,
             DELO_LOTE_FECH_ELAB,
             DELO_LOTE_FECH_VENC,
             DELO_SESI_USER_IMFA,
             DELO_PROD_CODI,
             DELO_TOTA_RECA_MONE,
             DELO_TOTA_RECA_MMNN,
             DELO_CANT_STOCK,
             DELO_PORC_RECA,
             DELO_LOTE_CODI_BARR,
             
             DELO_CODI
        FROM COME_IMPO_FACT_DETA_LOTE
       WHERE DELO_IMFA_CODI = P_IMDE_IMFA_CODI
         AND DELO_NUME_ITEM = P_IMDE_NUME_ITEM
       ORDER BY DELO_LOTE_CODI;
  
    V_IMDE_PORC_RECA      NUMBER;
    V_IMDE_TOTA_MMEE      NUMBER;
    V_IMDE_TOTA_MMNN      NUMBER;
    V_IMDE_IMPO_RECA_MMNN NUMBER;
    V_IMDE_IMPO_RECA_MONE NUMBER;
  
    V_CANT NUMBER;
    V_ITEM NUMBER := 0;
  
    V_DELO_PORC_RECA          NUMBER(20, 4);
    V_DELO_TOTA_RECA_MONE     NUMBER(20, 4);
    V_DELO_TOTA_RECA_MMNN     NUMBER(20, 4);
    V_DELO_TOTA_MONE          NUMBER(20, 4);
    V_DELO_TOTA_MMNN          NUMBER(20, 4);
    V_SUM_DELO_PORC_RECA      NUMBER(20, 4);
    V_SUM_DELO_TOTA_RECA_MONE NUMBER(20, 4);
    V_SUM_DELO_TOTA_RECA_MMNN NUMBER(20, 4);
    V_SUM_DELO_TOTA_MONE      NUMBER(20, 4);
    V_SUM_DELO_TOTA_MMNN      NUMBER(20, 4);
  
    TYPE TR_COME_IMPO_FACT_DETA IS RECORD(
      IMDE_IMPO_RECA_MMNN NUMBER(20, 4),
      IMDE_IMPO_RECA_MONE NUMBER(20, 4),
      
      IMDE_TOTA_MONE NUMBER(20, 4),
      IMDE_TOTA_MMNN NUMBER(20, 4),
      
      IMDE_PORC_RECA NUMBER(20, 6),
      IMDE_IMFA_CODI NUMBER(10),
      IMDE_NUME_ITEM NUMBER(10));
    V_IMDE_TOTA_MONE NUMBER(20, 4);
  
    TYPE TT_COME_IMPO_FACT_DETA IS TABLE OF TR_COME_IMPO_FACT_DETA INDEX BY BINARY_INTEGER;
  
    TA_COME_IMPO_FACT_DETA TT_COME_IMPO_FACT_DETA;
  
    V_IDX NUMBER := 0;
  
    V_SUM_MOCO_IMPO_MONE_DIFE NUMBER;
  
    V_ITEM_MAYO NUMBER;
    V_IMPO_MAYO NUMBER := 0;
  
    V_SUM_IMDE_IMPO_RECA_MONE NUMBER := 0;
  
    CURSOR C_FACT(P_IMPO_CODI IN NUMBER) IS
      SELECT IMFA_CODI, IMFA_TASA_MONE_DEUD, IMPO_TASA_MONE
        FROM COME_IMPO_FACT, COME_IMPO
       WHERE IMFA_IMPO_CODI = IMPO_CODI
         AND IMPO_CODI = P_IMPO_CODI
       ORDER BY IMFA_CODI;
  
    CURSOR C_DETA(P_IMFA_CODI IN NUMBER) IS
      SELECT IMDE_NUME_ITEM,
             IMDE_IMFA_CODI,
             IMDE_IMPO_RECA_MMNN,
             IMDE_IMPO_RECA_MONE,
             IMDE_TOTA_MMNN,
             IMDE_TOTA_MONE,
             IMDE_PORC_RECA
        FROM COME_IMPO_FACT, COME_IMPO_FACT_DETA
       WHERE IMFA_CODI = IMDE_IMFA_CODI
         AND IMFA_CODI = P_IMFA_CODI;
  
    V_IDX_MAYO           NUMBER;
    V_TOTA_MAYO          NUMBER := 0;
    V_SUM_IMDE_TOTA_MONE NUMBER := 0;
    V_SUM_IMDE_TOTA_MMNN NUMBER := 0;
    V_TOTA_GS            NUMBER;
  
    V_DELO_PORC NUMBER;
  
  BEGIN
    ---ACTUALIZAR LA TASA Y SI YA FUE COSTEADA LA IMPORTACION
    UPDATE COME_IMPO
       SET IMPO_INDI_COST = 'S',
           IMPO_DIFE_CAMB = NVL(BSEL.IMPO_DIFE_CAMB, 0),
           IMPO_TASA_FACT = NVL(BSEL.IMPO_TASA_FACT, 1)
     WHERE IMPO_CODI = BSEL.IMPO_CODI;
  
    ---PRIMERO ASIGNAMOS EL IMPORTE DE RECARGO EN MMNN EN LA TABLA.. LUEGO YA HAREMOS EL RESTO DIRECTAMENTE DESDE LA TABLA
    V_IDX := 0;
  
    V_ITEM_MAYO := NULL;
    V_IDX_MAYO  := NULL;
    V_IMPO_MAYO := 0;
  
    --ASIGNA EL IMPORTE DE RECARGO EN MMNN
    -- GO_BLOCK('BDET_FACT');
    ---FIRST_RECORD;
    for BDET_FACT in c_fac LOOP
      V_IDX := V_IDX + 1;
      TA_COME_IMPO_FACT_DETA(V_IDX).IMDE_IMPO_RECA_MMNN := BDET_FACT.IMPO_APLI_MMNN;
    
      TA_COME_IMPO_FACT_DETA(V_IDX).IMDE_TOTA_MONE := BDET_FACT.IMDE_TOTA_MONE;
      TA_COME_IMPO_FACT_DETA(V_IDX).IMDE_PORC_RECA := BDET_FACT.IMDE_PORC_RECA;
    
      TA_COME_IMPO_FACT_DETA(V_IDX).IMDE_IMFA_CODI := BDET_FACT.IMDE_IMFA_CODI;
      TA_COME_IMPO_FACT_DETA(V_IDX).IMDE_NUME_ITEM := BDET_FACT.IMDE_NUME_ITEM;
    
      IF TA_COME_IMPO_FACT_DETA(V_IDX).IMDE_TOTA_MONE > V_IMPO_MAYO THEN
        V_IDX_MAYO  := V_IDX;
        V_ITEM_MAYO := TA_COME_IMPO_FACT_DETA(V_IDX).IMDE_NUME_ITEM;
        V_IMPO_MAYO := TA_COME_IMPO_FACT_DETA(V_IDX).IMDE_TOTA_MONE;
      END IF;
    
    END LOOP;
  
    IF V_SUM_IMDE_IMPO_RECA_MONE <> V_SUM_MOCO_IMPO_MONE_DIFE THEN
      TA_COME_IMPO_FACT_DETA(V_IDX_MAYO).IMDE_IMPO_RECA_MONE := TA_COME_IMPO_FACT_DETA(V_IDX_MAYO).IMDE_IMPO_RECA_MONE +
                                                                 (V_SUM_MOCO_IMPO_MONE_DIFE -
                                                                                                    V_SUM_IMDE_IMPO_RECA_MONE);
    END IF;
  
    FOR X IN 1 .. TA_COME_IMPO_FACT_DETA.COUNT LOOP
    
      UPDATE COME_IMPO_FACT_DETA
         SET IMDE_IMPO_RECA_MMNN = TA_COME_IMPO_FACT_DETA(X).IMDE_IMPO_RECA_MMNN,
             IMDE_PORC_RECA      = TA_COME_IMPO_FACT_DETA(X).IMDE_PORC_RECA
       WHERE IMDE_IMFA_CODI = TA_COME_IMPO_FACT_DETA(X).IMDE_IMFA_CODI
         AND IMDE_NUME_ITEM = TA_COME_IMPO_FACT_DETA(X).IMDE_NUME_ITEM;
    
    END LOOP;
    COMMIT;
  
    V_SUM_IMDE_IMPO_RECA_MONE := 0;
  
    FOR Z IN C_FACT(BSEL.IMPO_CODI) LOOP
      V_SUM_IMDE_TOTA_MONE := 0;
      V_SUM_IMDE_TOTA_MMNN := 0;
      V_TOTA_MAYO          := 0;
      V_IDX_MAYO           := NULL;
    
      FOR X IN C_DETA(Z.IMFA_CODI) LOOP
        V_SUM_IMDE_TOTA_MONE      := V_SUM_IMDE_TOTA_MONE +
                                     NVL(X.IMDE_TOTA_MONE, 0);
        V_IMDE_TOTA_MMNN          := ROUND((NVL(X.IMDE_TOTA_MONE, 0) *
                                           Z.IMPO_TASA_MONE),
                                           0);
        V_SUM_IMDE_TOTA_MMNN      := V_SUM_IMDE_TOTA_MMNN +
                                     V_IMDE_TOTA_MMNN;
        V_IMDE_IMPO_RECA_MONE     := ROUND((X.IMDE_IMPO_RECA_MMNN /
                                           BSEL.IMPO_TASA_MONE),
                                           2);
        V_SUM_IMDE_IMPO_RECA_MONE := V_SUM_IMDE_IMPO_RECA_MONE +
                                     V_IMDE_IMPO_RECA_MONE;
      
        UPDATE COME_IMPO_FACT_DETA
           SET IMDE_TOTA_MMNN      = V_IMDE_TOTA_MMNN,
               IMDE_IMPO_RECA_MONE = V_IMDE_IMPO_RECA_MONE
         WHERE IMDE_IMFA_CODI = X.IMDE_IMFA_CODI
           AND IMDE_NUME_ITEM = X.IMDE_NUME_ITEM;
      
        IF X.IMDE_TOTA_MONE > V_TOTA_MAYO THEN
          V_IDX_MAYO  := X.IMDE_NUME_ITEM;
          V_TOTA_MAYO := NVL(X.IMDE_TOTA_MONE, 0);
        END IF;
      END LOOP;
    
      V_TOTA_GS := ROUND((V_SUM_IMDE_TOTA_MONE * Z.IMPO_TASA_MONE), 0);
    
      IF V_TOTA_GS <> V_SUM_IMDE_TOTA_MMNN THEN
        UPDATE COME_IMPO_FACT_DETA
           SET IMDE_TOTA_MMNN = IMDE_TOTA_MMNN +
                                (V_TOTA_GS - V_SUM_IMDE_TOTA_MMNN)
         WHERE IMDE_IMFA_CODI = Z.IMFA_CODI
           AND IMDE_NUME_ITEM = V_ITEM_MAYO;
      END IF;
    
      V_SUM_MOCO_IMPO_MONE_DIFE := ROUND((BSEL.SUM_MOCO_IMPO_MMNN_DIFE /
                                         BSEL.IMPO_TASA_MONE),
                                         2);
    
      IF V_SUM_MOCO_IMPO_MONE_DIFE <> V_SUM_IMDE_IMPO_RECA_MONE THEN
        UPDATE COME_IMPO_FACT_DETA
           SET IMDE_IMPO_RECA_MONE = IMDE_IMPO_RECA_MONE +
                                     (V_SUM_MOCO_IMPO_MONE_DIFE -
                                     V_SUM_IMDE_IMPO_RECA_MONE)
         WHERE IMDE_IMFA_CODI = Z.IMFA_CODI
           AND IMDE_NUME_ITEM = V_ITEM_MAYO;
      END IF;
    
    END LOOP;
  
    COMMIT;
  
    ---AHORA HAY QUE HACER LO MISMO PERO POR ITEM DE LOTES.
  
    FOR Z IN C_FACT(BSEL.IMPO_CODI) LOOP
      FOR X IN C_DETA(Z.IMFA_CODI) LOOP
        V_IMDE_TOTA_MMNN      := X.IMDE_TOTA_MMNN;
        V_IMDE_IMPO_RECA_MMNN := X.IMDE_IMPO_RECA_MMNN;
        V_IMDE_IMPO_RECA_MONE := X.IMDE_IMPO_RECA_MONE;
        V_IMDE_TOTA_MONE      := X.IMDE_TOTA_MONE;
      
        V_SUM_DELO_TOTA_MMNN      := 0;
        V_SUM_DELO_TOTA_RECA_MMNN := 0;
        V_SUM_DELO_TOTA_RECA_MONE := 0;
      
        V_ITEM_MAYO := NULL;
        V_IMPO_MAYO := 0;
      
        FOR Y IN C_LOTE(X.IMDE_IMFA_CODI, X.IMDE_NUME_ITEM) LOOP
          V_DELO_PORC           := Y.DELO_TOTA_MONE * 100 /
                                   V_IMDE_TOTA_MONE;
          V_DELO_PORC_RECA      := X.IMDE_PORC_RECA;
          V_DELO_TOTA_MMNN      := ROUND((Y.DELO_TOTA_MONE *
                                         BSEL.IMPO_TASA_MONE),
                                         0);
          V_DELO_TOTA_RECA_MMNN := ROUND((V_IMDE_IMPO_RECA_MMNN *
                                         V_DELO_PORC / 100),
                                         0);
          V_DELO_TOTA_RECA_MONE := ROUND((V_DELO_TOTA_RECA_MMNN /
                                         BSEL.IMPO_TASA_MONE),
                                         2);
        
          V_SUM_DELO_TOTA_MMNN      := V_SUM_DELO_TOTA_MMNN +
                                       V_DELO_TOTA_MMNN;
          V_SUM_DELO_TOTA_RECA_MMNN := V_SUM_DELO_TOTA_RECA_MMNN +
                                       V_DELO_TOTA_RECA_MMNN;
          V_SUM_DELO_TOTA_RECA_MONE := V_SUM_DELO_TOTA_RECA_MONE +
                                       V_DELO_TOTA_RECA_MONE;
        
          IF Y.DELO_TOTA_MONE > V_IMPO_MAYO THEN
            V_ITEM_MAYO := Y.DELO_CODI;
            V_IMPO_MAYO := Y.DELO_TOTA_MONE;
          END IF;
        
          UPDATE COME_IMPO_FACT_DETA_LOTE
             SET DELO_TOTA_MMNN      = V_DELO_TOTA_MMNN,
                 DELO_TOTA_RECA_MONE = V_DELO_TOTA_RECA_MONE,
                 DELO_TOTA_RECA_MMNN = V_DELO_TOTA_RECA_MMNN,
                 DELO_PORC_RECA      = V_DELO_PORC_RECA
           WHERE DELO_CODI = Y.DELO_CODI;
        END LOOP; --C_LOTE
      
        IF V_IMDE_TOTA_MMNN <> V_SUM_DELO_TOTA_MMNN THEN
          UPDATE COME_IMPO_FACT_DETA_LOTE
             SET DELO_TOTA_MMNN = DELO_TOTA_MMNN +
                                  (V_IMDE_TOTA_MMNN - V_SUM_DELO_TOTA_MMNN)
           WHERE DELO_CODI = V_ITEM_MAYO;
        END IF;
      
        IF V_IMDE_IMPO_RECA_MMNN <> V_SUM_DELO_TOTA_RECA_MMNN THEN
          UPDATE COME_IMPO_FACT_DETA_LOTE
             SET DELO_TOTA_RECA_MMNN = DELO_TOTA_RECA_MMNN +
                                       (V_IMDE_IMPO_RECA_MMNN -
                                       V_SUM_DELO_TOTA_RECA_MMNN)
           WHERE DELO_CODI = V_ITEM_MAYO;
        END IF;
      
        IF V_IMDE_IMPO_RECA_MONE <> V_SUM_DELO_TOTA_RECA_MONE THEN
          UPDATE COME_IMPO_FACT_DETA_LOTE
             SET DELO_TOTA_RECA_MONE = DELO_TOTA_RECA_MONE +
                                       (V_IMDE_IMPO_RECA_MONE -
                                       V_SUM_DELO_TOTA_RECA_MONE)
           WHERE DELO_CODI = V_ITEM_MAYO;
        END IF;
      
      END LOOP; ---C_DETA
    END LOOP; ---C_FACT 
  
    COMMIT;
  
  END;
  procedure pp_validar_recargo(p_seq_id         in number,
                               p_impo_apli_mmnn in number,
                               p_impo_indi_cost in varchar2,
                               p_impo_tasa_mone in number,
                               p_impo_dife_camb in number) is
    v_sum_moco_impo_mmnn_dife number;
  
  begin
  
    select nvl(sum(c007), 0) + (nvl(p_impo_dife_camb, 0))
      into v_sum_moco_impo_mmnn_dife
      from apex_collections
     where collection_name = 'BDET_GASTOS';
  
    -- raise_application_error(-20001,v_sum_moco_impo_mmnn_dife||' - '||P_IMPO_DIFE_CAMB);
  
    for bdet_fact in (select c008 imde_porc_reca,
                             c009 imde_porc_reca_ante,
                             c010 imde_tota_mone,
                             c013 imde_imfa_codi,
                             nvl(c014, 0) impo_apli_mmnn, --imde_impo_reca_mmnn ,
                             c015 impo_apli_mmnn_ante,
                             c016 porc,
                             c017 porc_gast,
                             c018 porc_gast_ante,
                             seq_id
                        from apex_collections
                       where collection_name = 'BDET_FACT'
                         and seq_id = p_seq_id) loop
      if bdet_fact.imde_imfa_codi is not null then
        if parameter.p_prorrateo = 'N' then
          if nvl(p_impo_indi_cost, 'N') = 'S' then
            if nvl(p_impo_apli_mmnn, 0) <>
               nvl(bdet_fact.impo_apli_mmnn_ante, 0) then
              --bdet_fact.impo_apli_mmnn := bdet_fact.impo_apli_mmnn_ante;
              raise_application_error(-20001,
                                      'La importacion ya fue costeada, impo apli');
            end if;
          end if;
        end if;
      
        if nvl(p_impo_indi_cost, 'N') = 'N' and parameter.p_prorrateo = 'N' then
          if nvl(p_impo_apli_mmnn, 0) <>
             nvl(bdet_fact.impo_apli_mmnn_ante, 0) then
            i020220.pp_update_member('BDET_FACT',
                                     p_seq_id,
                                     p_impo_apli_mmnn,
                                     14);
            -- bdet_fact.impo_apli_mmnn_ante := p_impo_apli_mmnn;
            i020220.pp_update_member('BDET_FACT',
                                     p_seq_id,
                                     p_impo_apli_mmnn,
                                     15);
          
            -- bdet_fact.imde_porc_reca      := round(((bdet_fact.impo_apli_mmnn /p_impo_tasa_mone) * 100) / bdet_fact.imde_tota_mone,6);
            i020220.pp_update_member('BDET_FACT',
                                     p_seq_id,
                                     round(((p_impo_apli_mmnn /
                                           p_impo_tasa_mone) * 100) /
                                           bdet_fact.imde_tota_mone,
                                           6),
                                     8);
            --bdet_fact.imde_porc_reca_ante := bdet_fact.imde_porc_reca;
          
            i020220.pp_update_member('BDET_FACT',
                                     p_seq_id,
                                     bdet_fact.imde_porc_reca,
                                     9);
          
            if nvl(v_sum_moco_impo_mmnn_dife, 0) <> 0 then
              --bdet_fact.porc_gast      := round((bdet_fact.impo_apli_mmnn * 100 /v_sum_moco_impo_mmnn_dife), 6);
              i020220.pp_update_member('BDET_FACT',
                                       p_seq_id,
                                       round((p_impo_apli_mmnn * 100 /
                                             v_sum_moco_impo_mmnn_dife),
                                             6),
                                       17);
            
              -- raise_application_error(-20001,bdet_fact.impo_apli_mmnn);
              -- bdet_fact.porc_gast_ante := bdet_fact.porc_gast;
              i020220.pp_update_member('BDET_FACT',
                                       p_seq_id,
                                       bdet_fact.porc_gast,
                                       18);
            else
              --  bdet_fact.porc_gast      := 0;
              i020220.pp_update_member('BDET_FACT',
                                       p_seq_id,
                                       bdet_fact.porc_gast,
                                       17);
              -- bdet_fact.porc_gast_ante := 0;
              i020220.pp_update_member('BDET_FACT',
                                       p_seq_id,
                                       bdet_fact.porc_gast,
                                       18);
            end if;
          
          end if;
        end if;
      
      end if;
    
    end loop;
  end pp_validar_recargo;

  procedure pp_validar_gasto(p_seq_id         in number,
                             p_impo_tasa_mone in number,
                             p_impo_indi_cost in varchar2,
                             p_impo_dife_camb in number,
                             p_porc_gast      in number) is
    v_sum_moco_impo_mmnn_dife number := 0;
  begin
  
    select nvl(sum(c007), 0) + (nvl(p_impo_dife_camb, 0))
      into v_sum_moco_impo_mmnn_dife
      from apex_collections
     where collection_name = 'BDET_GASTOS';
  
    for bdet_fact in (select c008 imde_porc_reca,
                             c009 imde_porc_reca_ante,
                             c010 imde_tota_mone,
                             c011 imde_tota_mmnn,
                             c012 imde_nume_item,
                             c013 imde_imfa_codi,
                             c014 impo_apli_mmnn, --imde_impo_reca_mmnn ,
                             c015 impo_apli_mmnn_ante,
                             c016 porc,
                             c017 porc_gast,
                             nvl(c018, 0) porc_gast_ante,
                             seq_id
                        from apex_collections
                       where collection_name = 'BDET_FACT'
                         and seq_id = p_seq_id) loop
    
      if bdet_fact.imde_imfa_codi is not null then
      
        if parameter.p_prorrateo = 'N' then
          if nvl(p_impo_indi_cost, 'N') = 'S' then
            if nvl(p_porc_gast, 0) <> nvl(bdet_fact.porc_gast_ante, 0) then
              --bdet_fact.porc_gast := bdet_fact.porc_gast_ante;
              raise_application_error(-20001,
                                      'La importacion ya fue costeada, porc Gasto');
            end if;
          end if;
        end if;
      
        if nvl(p_impo_indi_cost, 'N') = 'N' and parameter.p_prorrateo = 'N' then
          if nvl(p_porc_gast, 0) <> nvl(bdet_fact.porc_gast_ante, 0) then
            i020220.pp_update_member('BDET_FACT',
                                     p_seq_id,
                                     p_porc_gast,
                                     17);
            -- bdet_fact.porc_gast_ante := bdet_fact.porc_gast;
            i020220.pp_update_member('BDET_FACT',
                                     p_seq_id,
                                     p_porc_gast,
                                     18);
          
            --bdet_fact.impo_apli_mmnn      := round((v_sum_moco_impo_mmnn_dife *bdet_fact.porc_gast / 100),0);
          
            /*  i020220.pp_update_member('BDET_FACT',
            p_seq_id,
            round((v_sum_moco_impo_mmnn_dife *
                  p_porc_gast / 100),
                  0),
            14);*/
          
            /*raise_application_error(-20001, round((v_sum_moco_impo_mmnn_dife *
              p_porc_gast / 100),
              0) 
            --  p_porc_gast
              );*/
          
            -- bdet_fact.impo_apli_mmnn_ante := bdet_fact.impo_apli_mmnn;
            /*i020220.pp_update_member('BDET_FACT',p_seq_id,
            bdet_fact.impo_apli_mmnn,
            15);*/
            /* bdet_fact.imde_porc_reca      := round(((bdet_fact.impo_apli_mmnn /
            p_impo_tasa_mone) * 100) /
            bdet_fact.imde_tota_mone,
            6);*/
          
            i020220.pp_update_member('BDET_FACT',
                                     p_seq_id,
                                     round(((bdet_fact.impo_apli_mmnn /
                                           p_impo_tasa_mone) * 100) /
                                           bdet_fact.imde_tota_mone,
                                           6),
                                     8);
          
            --bdet_fact.imde_porc_reca_ante := bdet_fact.imde_porc_reca;
            i020220.pp_update_member('BDET_FACT',
                                     p_seq_id,
                                     bdet_fact.imde_porc_reca,
                                     9);
          
          end if;
        end if;
      end if;
    
    end loop;
  
  end pp_validar_gasto;

  procedure pp_set_variable is
  begin
  
    bsel.impo_dife_camb := v('P14_IMPO_DIFE_CAMB');
    bsel.impo_codi      := v('P14_IMPO_CODI');
  
    --raise_application_error(-20001,''||v('P14_IMPO_TASA_MONE')||' '||v('P14_IMPO_TASA_MMEE')); 
  
    bsel.impo_tasa_fact := v('P14_IMPO_TASA_FACT');
    bsel.impo_tasa_mone := v('P14_IMPO_TASA_MONE');
    bsel.impo_tasa_mmee := v('P14_IMPO_TASA_MMEE');
  
    select sum(c007) + (nvl(bsel.impo_dife_camb, 0))
      into bsel.sum_moco_impo_mmnn_dife
      from apex_collections
     where collection_name = 'BDET_GASTOS';
  
    select sum(c014) impo_apli_mmnn, sum(c016) sporc
      into bsel.sum_impo_apli_mmnn, bsel.sum_porc
      from apex_collections
     where collection_name = 'BDET_FACT';
  
  end pp_set_variable;

  procedure pp_actualizar_registro is
  begin
  
    pp_set_variable;
  
    pp_validaciones;
  
    pp_costear_importacion;
  
    --  pp_llama_reporte;     
  end;

  PROCEDURE pp_borrar_costeo(p_impo_codi in number) IS
  
  Begin
  
    --pp_valida_borrado;
  
    for bdet_fact in c_fac loop
      update come_impo_fact_deta
         set imde_impo_reca_mmnn = 0,
             imde_impo_reca_mone = 0,
             imde_porc_reca      = 0,
             imde_tota_mone     =
             (imde_tota_mone_brut + nvl(imde_deto_reca, 0)),
             imde_tota_mmnn      = null,
             imde_tota_mmee      = null
       where imde_imfa_codi = bdet_fact.imde_imfa_codi
         and imde_nume_item = bdet_fact.imde_nume_item;
    
    end loop;
  
    update come_impo
       set impo_indi_cost = 'N'
     where impo_codi = p_impo_codi;
  
    commit;
  
  END pp_borrar_costeo;

  procedure pp_imprimir_reportes(p_clave in VARCHAR2) is
    v_report       VARCHAR2(50);
    v_parametros   CLOB;
    v_contenedores CLOB;
  begin
  
    if p_clave is null then
      raise_application_error(-20001,
                              'Debe seleccionar un Costeo de importaci?n.');
    end if;
  
    V_CONTENEDORES := 'p_impo_codi:p_titulo';
    V_PARAMETROS   := p_clave || ':' || 'Reporte de Importaciones';
  
    DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = v('APP_USER');
  
    INSERT INTO COME_PARAMETROS_REPORT
      (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
    VALUES
      (V_PARAMETROS, v('APP_USER'), 'I020220', 'pdf', V_CONTENEDORES);
  
    commit;
  end pp_imprimir_reportes;

end i020220;
