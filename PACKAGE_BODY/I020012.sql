
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020012" is

  -- Private type declarations
  bcab come_movi%rowtype;
  moco come_movi_conc_deta%rowtype;
  type r_cabecera is record(
    
    timo_tico_codi        number,
    s_movi_codi_fact      number,
    s_movi_nume_fact      number,
    s_total               number,
    SUM_MOCO_IMPO_MONE_II number,
    tico_indi_vali_nume   varchar2(2),
    fech_inic_timb        date,
    fech_venc_timb        date,
    movi_nume_auto_impr   number,
    movi_nume_orig        number,
    movi_node_codi        number,
    movi_timo_indi_sald   varchar2(2),
    movi_timo_indi_caja   varchar2(2),
    s_timo_afec_sald      varchar(2),
    movi_codi_apli        number,
    s_movi_sald_mone      number,
    movi_obse             varchar2(2000));

  bcab1 r_cabecera;

  type r_variable is record(
    p_indi_solo_serv varchar2(1) := 'N',
    
    p_codi_oper_com    number := to_number(general_skn.fl_busca_parametro('p_codi_oper_com')),
    p_codi_oper_vta    number := to_number(general_skn.fl_busca_parametro('p_codi_oper_vta')),
    p_codi_oper_dcom   number := to_number(general_skn.fl_busca_parametro('p_codi_oper_dcom')),
    p_codi_oper_dvta   number := to_number(general_skn.fl_busca_parametro('p_codi_oper_dvta')),
    p_codi_timo_cnncre number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnncre')),
    p_codi_timo_cnncrr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnncrr')),
    p_codi_timo_cnfcre number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnfcre')),
    p_codi_timo_cnfcrr number := to_number(general_skn.fl_busca_parametro('p_codi_timo_cnfcrr')),
    p_indi_actu_secu   varchar2(2),
    p_codi_oper        number := to_number(general_skn.fl_busca_parametro('p_codi_oper_dvta')),
    p_emit_reci        varchar2(2) := 'E',
    p_disp_actu_regi   varchar2(2) := 'N',
    p_clie_prov        varchar2(2) := 'C',
    --p_peco_codi        number := 1,
    p_codi_impu_exen number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')), 
    p_codi_mone_mmnn number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_cant_deci_mmnn number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_codi_impu_ortr      number := to_number(general_skn.fl_busca_parametro('p_codi_impu_ortr')),
    p_codi_mone_dola      number := to_number(general_skn.fl_busca_parametro('p_codi_mone_dola')), 
    p_indi_modi_nume_fact varchar2(10) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_modi_nume_fact'))),
    p_codi_base number := pack_repl.fa_devu_codi_base,
    p_codi_clie_espo      number := to_number(general_skn.fl_busca_parametro('p_codi_clie_espo')),
    p_indi_vali_cuen_banc varchar2(2) := 'S',
    p_obli_nota_devu  varchar2(10)    := (general_skn.fl_busca_parametro('p_obli_nota_devu')),
    p_indi_entr_depo      varchar2(2) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_entr_depo'))),
    p_indi_perm_timo_bole varchar2(2) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_perm_timo_bole'))),
    p_codi_timo_pcoe      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_pcoe')),
    p_codi_timo_pcre      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_pcre')),
    p_obli_fact_emit      varchar2(10) := general_skn.fl_busca_parametro('p_obli_fact_emit'),
    p_indi_apli_ncre_fcre varchar2(12) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_apli_ncre_fcre')))
    );
  parameter r_variable;
  cursor c(p_seq_id number default null) is
    select seq_id, --MOCO_NUME_ITEM
           
           c001 s_item,
           c002 indi_prod_ortr,
           c003 deta_prod_codi,
           c004 prod_codi_alfa,
           c005 s_producto_desc,
           c006 prod_codi_alfa_orig,
           c007 moco_impu_codi,
           c008 moco_cant,
           c009 moco_cant_orig,
           c010 deta_prec_unit,
           c011 moco_porc_deto,
           c012 deta_movi_codi_padr,
           c013 deta_nume_item_padr,
           c014 moco_medi_codi,
           c015 deta_medi_codi,
           c016 DETA_PROD_CODI_BARR,
           c017 deta_lote_codi,
           c018 coba_fact_conv,
           c019 impu_desc,
           c020 moco_impu_porc,
           c021 moco_impu_porc_base_impo,
           c022 moco_impu_indi_baim_impu_incl,
           c023 moco_conc_codi_impu,
           c024 moco_cant_medi,
           c025 moco_dbcr,
           c026 moco_impo_mmee,
           c027 moco_impo_mone_ii,
           c028 moco_impo_mmnn_ii,
           c029 moco_grav10_ii_mone,
           c030 moco_conc_codi,
           c031 moco_grav5_ii_mone,
           c032 moco_grav10_ii_mmnn,
           c033 moco_grav5_ii_mmnn,
           c034 moco_grav10_mone,
           c035 moco_grav5_mone,
           c036 moco_grav10_mmnn,
           c037 moco_grav5_mmnn,
           c038 moco_iva10_mone,
           c039 moco_iva5_mone,
           c040 moco_iva10_mmnn,
           c041 moco_iva5_mmnn,
           c042 moco_exen_mone,
           c043 moco_exen_mmnn,
           c044 deta_prod_clco,
           c045 indi_venc,
           c046 sofa_nume_item,
           c047 ortr_desc,
           c048 w_movi_codi_cabe,
           n001 moco_impo_mone,
           n002 moco_iva_mone,
           n003 moco_iva_mmee,
           n004 moco_iva_mmnn,
           n005 moco_impo_mmnn
    
      from apex_collections a
     where collection_name = 'BDETALLE'
       and (seq_id = p_seq_id or p_seq_id is null);

  procedure pp_valida_fech(p_fech in date) is
    v_fech_inic date;
    v_fech_fini date;
  begin
    pa_devu_fech_habi(v_fech_inic, v_fech_fini);
    if p_fech not between v_fech_inic and v_fech_fini then
      raise_application_error(-20001,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(v_fech_inic, 'dd/mm/yyyy') || ' y ' ||
                              to_char(v_fech_fini, 'dd/mm/yyyy'));
    end if;
  
  end pp_valida_fech;

  Procedure pp_mostrar_clpr(p_clpr_codi_alte in number,
                            p_clpr_desc      out varchar2,
                            p_clpr_codi      out varchar2,
                            p_clpr_indi_exen out varchar2,
                            p_clpr_ruc       out varchar2,
                            p_clpr_dire      out varchar2,
                            p_clpr_tele      out varchar2,
                            p_clpr_empl_codi out number) is
  begin
    select clpr_desc,
           clpr_codi,
           nvl(clpr_indi_exen,'N'),
           clpr_ruc,
           clpr_dire,
           clpr_tele,
           clpr_empl_codi
      into p_clpr_desc,
           p_clpr_codi,
           p_clpr_indi_exen,
           p_clpr_ruc,
           p_clpr_dire,
           p_clpr_tele,
           p_clpr_empl_codi
      from come_clie_prov
     where clpr_codi_alte = p_clpr_codi_alte
       and clpr_indi_clie_prov = 'C';
  
  exception
    when no_data_found then
      p_clpr_desc      := null;
      p_clpr_ruc       := null;
      p_clpr_dire      := null;
      p_clpr_tele      := null;
      p_clpr_empl_codi := null;
    
      raise_application_error(-20001, 'Cliente inexistente!');
    
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_mostrar_clpr;

  procedure pp_validar_tipo_mov(p_movi_timo_codi           in number,
                                p_movi_afec_sald           out varchar2,
                                p_movi_emit_reci           out varchar2,
                                p_s_timo_calc_iva          out varchar2,
                                p_movi_oper_codi           out number,
                                p_movi_dbcr                out varchar2,
                                p_timo_tica_codi           out number,
                                p_s_timo_indi_caja         out varchar2,
                                p_tico_codi                out number,
                                p_timo_indi_apli_adel_fopa out varchar2,
                                p_tico_indi_vali_nume      out varchar2,
                                p_timo_dbcr_caja           out varchar2,
                                p_tico_indi_timb           out varchar2,
                                p_TICO_INDI_HABI_TIMB      out varchar2,
                                p_tico_indi_timb_auto      out varchar2,
                                p_tico_indi_vali_timb      out varchar2,
                                p_movi_timo_indi_caja      out varchar2,
                                p_movi_tica_codi           out number,
                                p_movi_timo_indi_sald      out varchar2,
                                p_timo_tico_codi           out number,
                                p_movi_nume                in out varchar,
                                p_s_nro_1                  out varchar2,
                                p_s_nro_2                  out varchar2,
                                p_s_nro_3                  out varchar2,
                                p_movi_nume_orig           out varchar2,
                                p_s_movi_nume              out varchar2) is
  
    v_movi_nume varchar2(200);
  begin
    -- raise_application_error(-20001,'Una bala un muerto...');
  
    if p_movi_timo_codi is not null then
      pp_muestra_tipo_movi(p_movi_timo_codi,
                           p_movi_afec_sald,
                           p_movi_emit_reci,
                           p_s_timo_calc_iva,
                           p_movi_oper_codi,
                           p_movi_dbcr,
                           p_timo_tica_codi,
                           p_s_timo_indi_caja,
                           p_tico_codi,
                           p_timo_indi_apli_adel_fopa,
                           p_tico_indi_vali_nume,
                           p_timo_dbcr_caja,
                           p_tico_indi_timb,
                           p_TICO_INDI_HABI_TIMB,
                           p_tico_indi_timb_auto,
                           p_tico_indi_vali_timb,
                           p_movi_timo_indi_caja,
                           p_movi_tica_codi,
                           p_movi_timo_indi_sald,
                           p_timo_tico_codi);
      -- pp_hab_des_cr_co(p_movi_afec_sald); --validar en accion dinamica
    
    else
      raise_application_error(-20001,
                              'Debe ingresar el tipo de Movimiento');
    end if;
  
    if rtrim(ltrim(parameter.p_emit_reci)) = 'E' then
      -- if p_movi_nume is null then
      pp_busca_secu(p_movi_nume,
                    p_s_nro_1,
                    p_s_nro_2,
                    p_s_nro_3,
                    p_movi_nume_orig,
                    v_movi_nume,
                    p_s_movi_nume);
      -- end if;
    end if;
    
    --raise_application_error(-20001,'p_s_nro_1: '||p_s_nro_1);
    
  end pp_validar_tipo_mov;

  procedure pp_hab_des_cr_co is
  
    --habilitar o desabilitar campos 
    --dependiendo de la operacion Contado y Credito...
  
  begin
  
    /* if p_ind_cr_co = 'N' then --es contado
      if get_item_property('bcab.movi_mone_codi', enabled) = upper('true') then
         set_item_property('bcab.movi_mone_codi', enabled,  property_false);
      end if;
     
      if get_item_property('bcab.movi_cuen_codi', enabled) = upper('false') then
         set_item_property('bcab.movi_cuen_codi', enabled,  property_true);
         set_item_property('bcab.movi_cuen_codi', navigable, property_true);
      end if;
      
       
    else --es credito
      if get_item_property('bcab.movi_mone_codi', enabled) = upper('false') then
         set_item_property('bcab.movi_mone_codi', enabled,  property_true);
         set_item_property('bcab.movi_mone_codi', navigable, property_true);
      end if;
      
      if get_item_property('bcab.movi_cuen_codi', enabled) = upper('true') then
         set_item_property('bcab.movi_cuen_codi', enabled,  property_false);
      end if;
      p_movi_cuen_codi := null;
      p_movi_cuen_desc := null;
      :bcab.movi_banc_codi := null;
      :bcab.movi_banc_desc := null;                   
    end if; */
  
    null;
  
  end;

  procedure pp_busca_secu(p_nume           out number,
                          p_s_nro_1        out varchar2,
                          p_s_nro_2        out varchar2,
                          p_s_nro_3        out varchar2,
                          p_movi_nume_orig out varchar2,
                          p_movi_nume      out varchar2,
                          p_s_movi_nume    out varchar2) is
  begin
  
    select (nvl(secu_nume_nota_cred, 0) + 1)
      into p_nume
      from come_secu
     where secu_codi =
           (select f.user_secu_codi
                          from segu_user f
                         where user_login = fa_user);
  
    p_s_nro_1 := substr(lpad(p_nume, 13, '0'), 1, 3);
    p_s_nro_2 := substr(lpad(p_nume, 13, '0'), 4, 3);
    p_s_nro_3 := substr(lpad(p_nume, 13, '0'), 7, 7);
  
    p_movi_nume      := to_number((p_s_nro_1 || p_s_nro_2 || p_s_nro_3));
    p_s_movi_nume    := (p_s_nro_1 || '-' || p_s_nro_2 || '-' || p_s_nro_3);
    p_movi_nume_orig := p_movi_nume;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

  procedure pp_muestra_tipo_movi(p_movi_timo_codi           in number,
                                 p_movi_afec_sald           out varchar2,
                                 p_movi_emit_reci           out varchar2,
                                 p_s_timo_calc_iva          out varchar2,
                                 p_movi_oper_codi           out number,
                                 p_movi_dbcr                out varchar2,
                                 p_timo_tica_codi           out number,
                                 p_s_timo_indi_caja         out varchar2,
                                 p_tico_codi                out number,
                                 p_timo_indi_apli_adel_fopa out varchar2,
                                 p_tico_indi_vali_nume      out varchar2,
                                 p_timo_dbcr_caja           out varchar2,
                                 p_tico_indi_timb           out varchar2,
                                 p_TICO_INDI_HABI_TIMB      out varchar2,
                                 p_tico_indi_timb_auto      out varchar2,
                                 p_tico_indi_vali_timb      out varchar2,
                                 p_movi_timo_indi_caja      out varchar2,
                                 p_movi_tica_codi           out number,
                                 p_movi_timo_indi_sald      out varchar2,
                                 p_timo_tico_codi           out number) is
  begin
    select --timo_desc,
     timo_afec_sald,
     timo_emit_reci,
     nvl(timo_calc_iva, 'S'),
     timo_codi_oper,
     timo_dbcr,
     timo_tica_codi,
     timo_indi_caja,
     timo_tico_codi,
     timo_indi_apli_adel_fopa,
     tico_indi_vali_nume,
     timo_dbcr_caja,
     tico_indi_timb,
     TICO_INDI_HABI_TIMB,
     tico_indi_timb_auto,
     tico_indi_vali_timb,
     nvl(timo_indi_caja, 'N'),
     timo_tica_codi,
     nvl(timo_indi_sald, 'N'),
     timo_tico_codi
      into --p_movi_timo_desc,
           p_movi_afec_sald,
           p_movi_emit_reci,
           p_s_timo_calc_iva,
           p_movi_oper_codi,
           p_movi_dbcr,
           p_timo_tica_codi,
           p_s_timo_indi_caja,
           p_tico_codi,
           p_timo_indi_apli_adel_fopa,
           p_tico_indi_vali_nume,
           p_timo_dbcr_caja,
           p_tico_indi_timb,
           p_TICO_INDI_HABI_TIMB,
           p_tico_indi_timb_auto,
           p_tico_indi_vali_timb,
           p_movi_timo_indi_caja,
           p_movi_tica_codi,
           p_movi_timo_indi_sald,
           p_timo_tico_codi
      from come_tipo_movi, come_tipo_comp a
     where timo_tico_codi = tico_codi(+)
       and timo_codi_oper = parameter.p_codi_oper
       and timo_codi = p_movi_timo_codi;
  
    if p_movi_emit_reci <> parameter.p_emit_reci then
      --p_movi_timo_desc  := null;
      p_movi_afec_sald  := null;
      p_movi_emit_reci  := null;
      p_s_timo_calc_iva := null;
      raise_application_error(-20001,
                              'Tipo de Movimiento no valido para esta operacion');
    end if;
  
    if p_movi_oper_codi <> parameter.p_codi_oper then
      raise_application_error(-20001,
                              'Tipo de Movimiento no valido para esta operacion');
    end if;
  
    if nvl(upper(parameter.p_indi_perm_timo_bole), 'S') = 'N' then
      if p_movi_timo_codi in
         (parameter.p_codi_timo_pcoe, parameter.p_codi_timo_pcre) then
        raise_application_error(-20001,
                                'El tipo de movimiento ' ||
                                p_movi_timo_codi || ' no esta permitido');
      end if;
    end if;
  
  exception
    when no_data_found then
      --p_movi_timo_desc  := null;
      p_movi_afec_sald  := null;
      p_movi_emit_reci  := null;
      p_s_timo_calc_iva := null;
      raise_application_error(-20001, 'Tipo de Movimiento inexistente3');
    when too_many_rows then
      raise_application_error(-20001, 'Tipo de Movimiento duplicado');
  end;

  procedure pp_validar_timbrado(p_tico_codi           in number,
                                p_esta                in number,
                                p_punt_expe           in number,
                                p_clpr_codi           in number,
                                p_fech_movi           in date,
                                p_timb                out varchar2,
                                p_fech_venc           in out date,
                                p_fech_inic           in out date,
                                p_nume_auto_impr      in out varchar2,
                                p_tico_indi_timb      in varchar2,
                                p_clpr_codi_alte      in number,
                                p_tico_indi_timb_auto in varchar2,
                                p_movi_nume_timb      in varchar2,
                                p_tico_indi_vali_timb in varchar2,
                                p_s_obse_timb         out varchar2) is
  
    cursor c_timb is
      select cptc_nume_timb,
             cptc_fech_venc,
             CPTC_FECH_INIC,
             CPTC_NUME_AUTO_IMPR
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
             SETC_NUME_AUTO_IMPR,
             SETC_FECH_INIC
        from come_secu_tipo_comp
       where setc_secu_codi =
             (select f.user_secu_codi
                          from segu_user f
                         where user_login = fa_user)
         and setc_tico_codi = p_tico_codi --tipo de comprobante
         and setc_esta = p_esta --establecimiento 
         and setc_punt_expe = p_punt_expe --punto de expedicion
         and setc_fech_venc >= p_fech_movi
       order by setc_fech_venc;
  
    v_indi_entro varchar2(1) := 'N';
    --v_ind_color  varchar2(1);
    --v_indi_espo  varchar2(1) := 'N';
  begin
  
    if p_clpr_codi_alte = parameter.p_codi_clie_espo then
      --v_indi_espo := upper('s');
      NULL;
    end if;
  

  
   
  
    if nvl(p_tico_indi_timb_auto, 'N') = 'S' then
    
      if nvl(p_tico_indi_timb, 'C') = 'C' then
        ---si es por tipo de comprobante
        for y in c_timb_2 loop
          v_indi_entro := 'S';
          if p_movi_nume_timb is not null then
            p_timb      := p_movi_nume_timb;
            p_fech_venc := p_fech_venc;
          else
            p_timb      := y.deta_nume_timb;
            p_fech_venc := y.deta_fech_venc;
          end if;
          exit;
        end loop;
      elsif nvl(p_tico_indi_timb, 'C') = 'S' then
        --SI ES POR SECUENCIA 
      
        for x in c_timb_3 loop
        
          v_indi_entro := upper('s');
        
          if p_movi_nume_timb is not null then
            p_timb           := p_movi_nume_timb;
            p_fech_venc      := p_fech_venc;
            p_fech_inic      := p_fech_inic;
            p_nume_auto_impr := p_nume_auto_impr;
          
          else
          
            p_timb           := x.setc_nume_timb;
            p_fech_venc      := x.setc_fech_venc;
            p_fech_inic      := x.setc_fech_inic;
            p_nume_auto_impr := x.SETC_NUME_AUTO_IMPR;
          
          end if;
        
          exit;
        end loop;
      ELSE
        --SI ES POR PROVEEDOR O CLIENTE
        for x in c_timb loop
        
          v_indi_entro := upper('s');
        
          if p_movi_nume_timb is not null then
            p_timb           := p_movi_nume_timb;
            p_fech_venc      := p_fech_venc;
            p_fech_inic      := p_fech_inic;
            p_nume_auto_impr := p_nume_auto_impr;
          
          else
          
            p_timb           := x.cptc_nume_timb;
            p_fech_venc      := x.cptc_fech_venc;
            p_fech_inic      := x.cptc_fech_INIC;
            p_nume_auto_impr := x.cptc_NUME_AUTO_IMPR;
          
          end if;
        
          exit;
        end loop;
      
      end if;
    end if;
  
    if v_indi_entro = 'N' and nvl(upper(p_tico_indi_vali_timb), 'N') = 'S' then
      raise_application_error(-20001,
                              'No existe registro de timbrado, o el timbrado cargado se encuentra vencido!!!');
    end if;
  
    if round(trunc(p_fech_venc) - trunc(sysdate)) > 0 then
      p_s_obse_timb := 'El timbrado ' || p_timb || ' vence en ' ||
                       round(trunc(p_fech_venc) - trunc(sysdate)) ||
                       ' d?as!!!';
      if round(trunc(p_fech_venc) - trunc(sysdate)) <= 30 then
        --v_ind_color := 'S';
        -- set_item_property('bcab.s_obse_timb', current_record_attribute, 'visual_reg_amarillo');
        NULL;
      end if;
    end if;
  end;

  procedure pp_validar_nro_3(P_movi_nume      IN out varchar2,
                             P_timo_tico_codi in number,
                             P_MOVI_NUME_TIMB in number,
                             P_s_nro_1        in varchar2,
                             P_s_nro_2        in varchar2,
                             P_s_nro_3        in varchar2,
                             P_s_movi_nume    in out varchar2) is
  begin
    if p_movi_nume is null then
      raise_application_error(-20001,
                              'Debe ingresar el n?mero de factura.!');
    else
      if parameter.p_disp_actu_regi = 'S' then
        I020012.pp_valida_nume_fact_fini(p_movi_nume      => p_movi_nume,
                                         p_timo_tico_codi => p_timo_tico_codi,
                                         p_movi_nume_timb => p_movi_nume_timb,
                                         p_s_nro_1        => p_s_nro_1,
                                         p_s_nro_2        => p_s_nro_2,
                                         p_s_nro_3        => p_s_nro_3,
                                         p_s_movi_nume    => p_s_movi_nume);
      
      else
      
        I020012.pp_valida_nume_fact(p_movi_nume      => p_movi_nume,
                                    p_timo_tico_codi => p_timo_tico_codi,
                                    p_movi_nume_timb => p_movi_nume_timb);
      
      end if;
    end if;
  
    /*if nvl(:parameter.p_emit_reci, 'E') = 'E' then 
      if p_tico_codi is not null then
          if get_item_property('bcab.movi_nume_timb', visible) = 'FALSE' then
            set_item_property('bcab.movi_nume_timb', visible, property_true);
            set_item_property('bcab.s_fech_venc_timb', visible, property_true);
            set_item_property('bcab.s_fech_inic_timb', visible, property_true);
            set_item_property('bcab.movi_nume_auto_impr', visible, property_true);
          end if;        
              
      else
        :bcab.movi_nume_timb     := null; 
        :bcab.fech_venc_timb     := null;
        :bcab.s_fech_venc_timb   := null; 
        :bcab.fech_inic_timb   := null; 
        :bcab.s_fech_inic_timb   := null; 
        :bcab.movi_nume_auto_impr   := null;  
        
        if get_item_property('bcab.movi_nume_timb', visible) = 'TRUE' then
          set_item_property('bcab.movi_nume_timb', visible, property_false);
          set_item_property('bcab.s_fech_venc_timb', visible, property_false);
          
          set_item_property('bcab.s_fech_inic_timb', visible, property_false);
          set_item_property('bcab.movi_nume_auto_impr', visible, property_false);
          
          
        end if;
        if get_item_property('bcab.s_obse_timb', visible) = 'TRUE' then
          set_item_property('bcab.s_obse_timb', visible, property_false);
        end if;
      end if;
    end if;*/
  
  end pp_validar_nro_3;

  procedure pp_valida_nume_fact_fini(P_movi_nume      IN out varchar2,
                                     P_timo_tico_codi in number,
                                     P_MOVI_NUME_TIMB in number,
                                     P_s_nro_1        in varchar2,
                                     P_s_nro_2        in varchar2,
                                     P_s_nro_3        in varchar2,
                                     P_s_movi_nume    out varchar2) is
    v_count number;
    --v_message varchar2(1000) := 'Nro de Comprobante Existente!!!!! , favor verifique!!';
    salir exception;
  
  begin
    select count(*)
      into v_count
      from come_movi, come_tipo_movi, come_tipo_comp
     where movi_timo_codi = timo_codi
       and timo_tico_codi = tico_codi(+)
       and movi_nume = P_movi_nume
       and timo_tico_codi = P_timo_tico_codi
       AND NVL(MOVI_NUME_TIMB, '0') = NVL(P_MOVI_NUME_TIMB, '0')
       and nvl(tico_indi_vali_nume, 'N') = 'S';
  
    if v_count > 0 then
      P_movi_nume   := to_number((P_s_nro_1 || P_s_nro_2 || P_s_nro_3));
      P_s_movi_nume := (P_s_nro_1 || '-' || P_s_nro_2 || '-' || P_s_nro_3);
    end if;
  
  exception
    when salir then
      RAISE_APPLICATION_ERROR(-20001, 'Reingrese el nro de comprobante');
  end pp_valida_nume_fact_fini;

  procedure pp_valida_nume_fact(p_movi_nume      in number,
                                p_timo_tico_codi in number,
                                p_MOVI_NUME_TIMB in number) is
    v_count   number;
    v_message varchar2(1000) := 'Nro de Comprobante Existente!!!!! , favor verifique!!';
    salir     exception;
  begin
  
    select count(*)
      into v_count
      from come_movi, come_tipo_movi, come_tipo_comp
     where movi_timo_codi = timo_codi
       and timo_tico_codi = tico_codi(+)
       and movi_nume = p_movi_nume
       and timo_tico_codi = p_timo_tico_codi
       and nvl(tico_indi_vali_nume, 'N') = 'S'
       AND NVL(MOVI_NUME_TIMB, '0') = p_MOVI_NUME_TIMB;
  
    if v_count > 0 then
      raise_application_error(-20001, v_message);
    end if;
  
  exception
    when salir then
      raise_application_error(-20001, 'Reingrese el nro de comprobante');
  end pp_valida_nume_fact;

  PROCEDURE pp_validar_sub_cuenta(p_movi_clpr_codi in number,
                                  p_indi_vali_subc out varchar2) IS
    v_count number := 0;
  BEGIN
    select count(*)
      into v_count
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_movi_clpr_codi;
    if v_count > 0 then
      p_indi_vali_subc := 'S';
    else
      p_indi_vali_subc := 'N';
    end if;
  END pp_validar_sub_cuenta;

  procedure pp_valida_cuen_banc(p_movi_mone_codi in number,
                                p_movi_cuen_codi in number) is
    v_count number := 0;
  
  begin
  
    select count(*)
      into v_count
      from come_cuen_banc
     where cuen_codi = p_movi_cuen_codi
       and (cuen_mone_codi = p_movi_mone_codi or p_movi_mone_codi is null);
  
    if v_count <= 0 then
      raise_application_error(-20001,
                              'La Tipo de moneda de la Cuenta debe ser igual al de la Nota de Credito');
    end if;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_valida_cuen_banc;

  procedure pl_muestra_come_cuen_banc(p_cuen_codi      in number,
                                      p_cuen_desc      out varchar2,
                                      p_cuen_mone_codi out number,
                                      p_banc_codi      out number,
                                      p_banc_desc      out varchar2,
                                      p_cuen_nume      out varchar2) is
  begin
    select cuen_desc, cuen_mone_codi, banc_codi, banc_desc, cuen_nume
      into p_cuen_desc,
           p_cuen_mone_codi,
           p_banc_codi,
           p_banc_desc,
           p_cuen_nume
      from come_cuen_banc, come_banc
     where cuen_banc_codi = banc_codi(+)
       and cuen_codi = p_cuen_codi;
  
  Exception
    when no_data_found then
      p_cuen_desc := null;
      p_banc_codi := null;
      p_banc_desc := null;
      --pl_mostrar_error ('Cuenta Bancaria Inexistente');
  
    when others then
      raise_application_error(-20010,
                              'Error al buscar Cuenta Bancaria! ' ||
                              sqlerrm);
  end pl_muestra_come_cuen_banc;

  procedure pp_validar_caja_cuen(P_s_movi_node_nume    in number,
                                 P_movi_afec_sald      in varchar2,
                                 P_movi_cuen_codi      in number,
                                 P_movi_fech_emis      in date,
                                 P_movi_tica_codi      in number,
                                 P_movi_mone_codi      in out number,
                                 P_movi_cuen_desc      out varchar2,
                                 P_movi_tasa_mone      out varchar2,
                                 P_movi_banc_desc      out varchar2,
                                 P_movi_mone_desc_abre out varchar2,
                                 P_movi_mone_cant_deci out varchar2,
                                 P_movi_banc_codi      out number,
                                 P_movi_nume_cuen      out varchar2) is
  begin
  
    if P_movi_afec_sald = 'N' then
      --si es contado
      if parameter.p_indi_vali_cuen_banc = 'S' then
        if P_movi_cuen_codi is not null then
        
          if P_s_movi_node_nume is null and P_movi_mone_codi is not null then
            P_movi_mone_codi      := null;
            P_movi_tasa_mone      := null;
            P_movi_mone_cant_deci := null;
            P_movi_mone_desc_abre := null;
          end if;
          pp_valida_cuen_banc(p_movi_mone_codi, p_movi_cuen_codi);
        
          pl_muestra_come_cuen_banc(P_movi_cuen_codi,
                                    P_movi_cuen_desc,
                                    P_movi_mone_codi,
                                    P_movi_banc_codi,
                                    P_movi_banc_desc,
                                    P_movi_nume_cuen);
        
          if nvl(parameter.p_clie_prov, 'C') = 'C' then
            if not general_skn.fl_vali_user_cuen_banc_cred(P_movi_cuen_codi) then
              Raise_application_error(-20001,
                                      'No posee permiso para ingresar en la caja seleccionada. !!!');
            end if;
          else
            if not general_skn.fl_vali_user_cuen_banc_debi(P_movi_cuen_codi) then
              Raise_application_error(-20001,
                                      'No posee permiso para ingresar en la caja seleccionada. !!!');
            end if;
          end if;
        
          if P_movi_mone_codi is null then
            P_movi_mone_codi := parameter.p_codi_mone_mmnn;
          end if;
          pp_mostrar_mone(P_movi_mone_codi,
                          P_movi_mone_desc_abre,
                          P_movi_mone_cant_deci);
          -- pp_formatear_importes;
          /*pp_busca_tasa_mone(P_movi_mone_codi,
                             P_movi_fech_emis,
                             P_movi_tasa_mone,
                             P_movi_tica_codi);*/
        else
          Raise_application_error(-20001,
                                  'Debe ingresar la Cuenta Bancaria');
        end if;
      end if;
    else
      --P_movi_cuen_codi    := null;
      P_movi_cuen_desc := null;
      P_movi_banc_codi := null;
      P_movi_banc_desc := null;
    end if;
  end pp_validar_caja_cuen;

  procedure pp_mostrar_deposito(p_codi_depo in number,
                                p_codi_sucu out number,
                                p_desc_depo out varchar2,
                                p_desc_sucu out varchar2) is
  
  begin
  
    select sucu_desc, sucu_codi, depo_desc, sucu_desc
      into p_desc_sucu, p_codi_sucu, p_desc_depo, p_desc_sucu
      from come_depo, come_sucu
     where depo_sucu_codi = sucu_codi
       and depo_indi_fact = 'S'
       and depo_codi = p_codi_depo;
  
  Exception
    when no_data_found then
      p_desc_depo := null;
      p_desc_sucu := null;
      p_codi_sucu := null;
      raise_application_error(-20001,
                              'Deposito inexistente o no facturable!');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_mostrar_deposito;

  procedure pp_mostrar_mone(p_mone_codi      in number,
                            p_mone_desc_abre out varchar2,
                            p_mone_cant_deci out varchar2) is
  begin
  
    -- raise_application_error(-20001,p_mone_codi);
    select mone_desc_abre, mone_cant_deci
      into p_mone_desc_abre, p_mone_cant_deci
      from come_mone
     where mone_codi = p_mone_codi;
  
  Exception
    when no_data_found then
      p_mone_desc_abre := null;
      p_mone_cant_deci := null;
      Raise_application_error(-20001, 'Moneda Inexistente!');
    when others then
      Raise_application_error(-20001, sqlerrm);
  end pp_mostrar_mone;

  procedure pp_busca_tasa_mone(p_mone_codi in number,
                               p_coti_fech in date,
                               p_mone_coti out number,
                               p_tica_codi in number) is
  begin
  
    if p_mone_codi = parameter.p_codi_mone_mmnn then
      p_mone_coti := 1;
    else
      begin
        select coti_tasa
          into p_mone_coti
          from come_coti
         where coti_mone = p_mone_codi
           and coti_fech = p_coti_fech
           and coti_tica_codi = p_tica_codi;
      
      exception
        when no_data_found then
          p_mone_coti := null;
          Raise_application_error(-20001,
                                  'Cotizacion Inexistente para la fecha del documento.');
      end;
    end if;
  exception
    when others then
      --  Raise_application_error(-20001,  parameter.p_codi_mone_mmnn||'-'||p_mone_codi);
      Raise_application_error(-20001, sqlerrm);
    
  end;

  procedure pp_ejecutar_consulta_codi(p_s_movi_codi_fact in number,
                                      p_movi_fech_emis   in date,
                                      p_movi_clpr_codi   in number,
                                      p_movi_mone_codi   in number,
                                      p_sucu_nume_item   in number,
                                      p_movi_empl_codi   in out varchar2,
                                      p_s_timo_afec_sald out varchar2) is
    v_movi_codi      number;
    v_movi_clpr_codi number;
    v_movi_empl_codi number;
    v_movi_mone_codi number;
    v_movi_fech_emis date;
    v_sucu_nume_item number;
  begin
    select movi_codi,
           movi_clpr_codi,
           movi_empl_codi,
           movi_mone_codi,
           movi_fech_emis,
           timo_afec_sald,
           movi_clpr_sucu_nume_item
      into v_movi_codi,
           v_movi_clpr_codi,
           v_movi_empl_codi,
           v_movi_mone_codi,
           v_movi_fech_emis,
           p_s_timo_afec_sald,
           v_sucu_nume_item
      from come_movi, come_tipo_movi
     where movi_codi = p_s_movi_codi_fact
       and movi_timo_codi = timo_codi;
  
    if v_movi_fech_emis > p_movi_fech_emis then
      raise_application_error(-20001,
                              'La factura no debe tener una fecha posterior a la fecha de la Nota de Cr?dito.');
    end if;
    if v_movi_clpr_codi <> p_movi_clpr_codi then
      raise_application_error(-20001,
                              'La factura no corresponde al Proveedor/Cliente ');
    end if;
  
    if v_movi_mone_codi <> p_movi_mone_codi then
      raise_application_error(-20001,
                              'El codigo de la moneda de la factura no corresponde al de la Nota de Credito');
    end if;
  
    if p_sucu_nume_item = 0 then
      if v_sucu_nume_item is not null then
        raise_application_error(-20001,
                                'El documento seleccionado pertenece a una Subcuenta');
      end if;
    elsif nvl(p_sucu_nume_item, 0) <> 0 then
      if v_sucu_nume_item <> p_sucu_nume_item then
        raise_application_error(-20001,
                                'El documento seleccionado pertenece a una Subcuenta distinta a la seleccionada');
      end if;
    end if;
  
    --p_s_movi_codi_fact := v_movi_codi;
    if v_movi_empl_codi is not null then
      p_movi_empl_codi := v_movi_empl_codi;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Movimiento Inexistente');
    when too_many_rows then
      raise_application_error(-20001,
                              'Existen dos facturas con el mismo Codigo, aviste a su administrador');
      --no deber?a entrar ak..... 
  end pp_ejecutar_consulta_codi;

  --cargar los item de la factura a devolver....
  procedure pp_carga_fact_adev(p_movi_codi        in number,
                               p_s_timo_calc_iva  in varchar2,
                               p_movi_dbcr        in varchar2,
                               p_s_movi_sald_mone out number) is
    cursor c_fac_adev is
      select 'P' tipo,
             dp.deta_movi_codi,
             dp.DETA_NUME_ITEM,
             dp.deta_prod_codi,
             p.prod_codi_alfa,
             p.prod_desc,
             dp.deta_impu_codi,
             dp.deta_impo_mone,
             dp.deta_iva_mone,
             dp.deta_prec_unit,
             dp.deta_porc_deto,
             nvl(fa_dev_sald_cant_adev(dp.deta_movi_codi, dp.DETA_NUME_ITEM),
                 0) cant_dev,
             dp.deta_cant,
             dp.deta_cant_medi,
             dp.deta_medi_codi,
             dp.DETA_PROD_CODI_BARR,
             dp.deta_lote_codi
            
      
        from come_movi_prod_deta dp, come_prod p
       where dp.deta_prod_codi = p.prod_codi
         and nvl(p.prod_indi_inac, 'N') = 'N'
         and dp.deta_movi_codi = p_movi_codi
      
      union all
      select 'O' tipo,
             do.deta_movi_codi,
             do.DETA_NUME_ITEM,
             do.deta_ortr_codi,
             o.ortr_nume,
             substr(o.ortr_desc, 1, 500),
             do.deta_impu_codi,
             do.deta_impo_mone,
             do.deta_iva_mone,
             do.deta_prec_unit,
             do.deta_porc_deto,
             nvl(fa_devu_sald_cant_adev_ortr(do.deta_movi_codi,
                                             do.DETA_NUME_ITEM),
                 0) cant_dev,
             do.deta_cant,
             null,
             null,
             null,
             null
        from come_movi_ortr_deta do, come_orde_trab o
       where do.deta_ortr_codi = o.ortr_codi
         and do.deta_movi_codi = p_movi_codi
      union all
      select 'S' tipo,
             dc.moco_movi_codi,
             dc.moco_nume_item,
             dc.moco_conc_codi,
             to_char(c.conc_codi),
             dc.moco_desc,
             dc.moco_impu_codi,
             dc.moco_impo_mone_ii moco_impo_mone,
             0,
             dc.moco_impo_mone_ii / dc.moco_cant moco_prec_unit,
             0,
             nvl(fa_devu_sald_cant_adev_moco(dc.moco_movi_codi,
                                             dc.moco_nume_item),
                 0) cant_dev,
             dc.moco_cant,
             null,
             null,
             null,
             null
        from come_movi_conc_deta dc, come_conc c
       where dc.moco_conc_codi = c.conc_codi
         and nvl(dc.moco_indi_fact_serv, 'N') = 'S'
         and dc.moco_movi_codi = p_movi_codi
       order by 3;
  
    v_indi_prod_ortr           varchar2(1);
    v_deta_cant_sald           number;
    v_deta_prod_codi           number;
    v_deta_impu_codi           number;
    v_deta_impo_mone           number;
    v_deta_iva_mone            number;
    v_deta_prec_unit           number;
    v_deta_porc_deto           number;
    v_prod_codi_alfa           varchar2(500);
    v_deta_prod_desc           varchar2(500);
    v_medi_desc_abre           varchar2(500);
    v_impu_desc                varchar2(500);
    v_moco_impu_porc           varchar2(500);
    v_moco_impu_porc_base_impo varchar2(500);
    v_impu_indi_baim_impu_incl varchar2(500);
    v_MOCO_CONC_CODI_IMPU      varchar2(500);
    v_deta_movi_codi_padr      number;
    v_deta_NUME_ITEM_padr      number;
    v_deta_cant_orig           number;
    v_deta_medi_codi           number;
    v_DETA_PROD_CODI_BARR      varchar2(30);
    v_deta_lote_codi           number;
    v_coba_fact_conv           number;
    v_moco_cant_medi           number;
  
    v_ind_entro char(1) := 'N';
  begin
    --primero verificar si existe por lo menos un item a devolver...
    for x in c_fac_adev loop
      if (x.deta_cant - x.cant_dev) > 0 then
        v_ind_entro := 'S';
      end if;
    end loop;
  
    if v_ind_entro = 'N' then
      raise_application_error(-20001,
                              'La factura no posee items pendientes a devolver');
    end if;
    -- recuperar el saldo total de la factura. Para saber hasta que monto se puede aplicar y si hay saldo dejar pendiente de aplicacion.
    begin
      select sum(cuot_sald_mone)
        into p_s_movi_sald_mone
        from come_movi_cuot
       where cuot_movi_codi = p_movi_codi;
    end;
    --go_block('bdet');
    --clear_block(no_validate);
    --first_record;
    
    
    apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
    for x in c_fac_adev loop
      v_indi_prod_ortr := x.tipo;
      v_deta_cant_sald := x.deta_cant - x.cant_dev;
      v_deta_prod_codi := x.deta_prod_codi;
    
      if p_s_timo_calc_iva = 'S' then
        v_deta_impu_codi := x.deta_impu_codi;
      else
        v_deta_impu_codi := parameter.p_codi_impu_exen;
      end if;
      
      v_deta_impo_mone      := x.deta_impo_mone;
      v_deta_iva_mone       := x.deta_iva_mone;
      v_deta_prec_unit      := x.deta_prec_unit;
      v_deta_porc_deto      := x.deta_porc_deto;
      v_prod_codi_alfa      := x.prod_codi_alfa;
      v_deta_prod_desc      := x.prod_desc;
      v_deta_movi_codi_padr := x.deta_movi_codi;
      v_deta_NUME_ITEM_padr := x.DETA_NUME_ITEM;
      v_deta_cant_orig      := v_deta_cant_sald;
      v_deta_medi_codi      := x.deta_medi_codi;
      v_DETA_PROD_CODI_BARR := x.DETA_PROD_CODI_BARR;
      v_deta_lote_codi      := x.deta_lote_codi;
    
    -----------------------
    
    
    
    
      if nvl(v_deta_cant_sald, 0) > 0 then
      
        if v_DETA_PROD_CODI_BARR is null then
          pp_asig_codi_barr(v_deta_prod_codi,
                            v_deta_medi_codi,
                            v_DETA_PROD_CODI_BARR,
                            v_coba_fact_conv);
        end if;
      
        if v_deta_medi_codi is not null then
          pp_mostrar_unid_medi(v_deta_medi_codi, v_medi_desc_abre);
          v_deta_medi_codi := v_deta_medi_codi;
        end if;
      
        if v_coba_fact_conv is null then
          v_coba_fact_conv := 1;
        end if;
      
        v_moco_cant_medi := v_deta_cant_sald / v_coba_fact_conv;
      
        if v_deta_impu_codi is not null then
          pp_muestra_impu(p_s_timo_calc_iva,
                          v_deta_impu_codi,
                          p_movi_dbcr,
                          v_impu_desc,
                          v_moco_impu_porc,
                          v_moco_impu_porc_base_impo,
                          v_impu_indi_baim_impu_incl,
                          v_MOCO_CONC_CODI_IMPU);
        
        end if;
      
        apex_collection.add_member(p_collection_name => 'BDETALLE',
                                   p_c001            => null, ---ind_marcado
                                   p_c002            => v_indi_prod_ortr,
                                   p_c003            => v_deta_prod_codi,
                                   p_c004            => v_prod_codi_alfa,
                                   p_c005            => v_deta_prod_desc,
                                   p_c006            => v_prod_codi_alfa,
                                   p_c007            => v_deta_impu_codi,
                                   p_c008            => v_deta_cant_sald,
                                   p_c009            => v_deta_cant_sald,
                                   p_c010            => v_deta_prec_unit,
                                   p_c011            => v_deta_porc_deto,
                                   p_c012            => v_deta_movi_codi_padr,
                                   p_c013            => v_deta_NUME_ITEM_padr,
                                   p_c014            => v_deta_medi_codi,
                                   p_c015            => v_deta_medi_codi,
                                   p_c016            => v_DETA_PROD_CODI_BARR,
                                   p_c017            => v_deta_lote_codi,
                                   p_c018            => v_coba_fact_conv,
                                   p_c019            => v_impu_desc,
                                   p_c020            => v_moco_impu_porc,
                                   p_c021            => v_moco_impu_porc_base_impo,
                                   p_c022            => v_impu_indi_baim_impu_incl,
                                   p_c023            => v_MOCO_CONC_CODI_IMPU,
                                   p_c024            => v_moco_cant_medi);
      
      end if;
    
    end loop;
  

  end pp_carga_fact_adev;

  PROCEDURE pp_asig_codi_barr(p_prod_codi      in number,
                              p_medi_codi      in number,
                              p_coba_codi_barr out varchar2,
                              p_coba_fact_conv out number) IS
  
  BEGIN
  
    select COBA_CODI_BARR, coba_fact_conv
      into p_coba_codi_barr, p_coba_fact_conv
      from come_prod_coba_deta
     where coba_prod_codi = p_prod_codi
       and coba_medi_codi = p_medi_codi
       and rownum = 1;
  
  exception
    When others then
      p_coba_codi_barr := null;
      p_coba_fact_conv := 1;
  END pp_asig_codi_barr;

  procedure pp_muestra_impu(p_s_timo_calc_iva          in varchar2,
                            p_moco_impu_codi           in out number,
                            p_movi_dbcr                in varchar2,
                            p_impu_desc                out varchar2,
                            p_moco_impu_porc           out varchar2,
                            p_moco_impu_porc_base_impo out varchar2,
                            p_impu_indi_baim_impu_incl out varchar2,
                            p_MOCO_CONC_CODI_IMPU      out varchar2) is
  begin
  
    --si El tipo de movimiento tiene el indicador de calculo de iva 'N'
    --entonces siempre ser? exento....
    if p_s_timo_calc_iva = 'N' then
      p_moco_impu_codi := parameter.p_codi_impu_exen;
    end if;
  
    select impu_desc,
           impu_porc,
           impu_porc_base_impo,
           nvl(impu_indi_baim_impu_incl, 'S'),
           decode(p_movi_dbcr,
                  'C',
                  IMPU_CONC_CODI_IVCR,
                  IMPU_CONC_CODI_IVDB)
      into p_impu_desc,
           p_moco_impu_porc,
           p_moco_impu_porc_base_impo,
           p_impu_indi_baim_impu_incl,
           p_MOCO_CONC_CODI_IMPU
      from come_impu
     where impu_codi = p_moco_impu_codi;
  
  Exception
    when no_data_found then
      raise_application_error(-20001, 'Tipo de Impuesto inexistente');
    When too_many_rows then
      raise_application_error(-20001, 'Tipo de Impuesto duplicado');
    when others then
      raise_application_error(-20001, 'When others...');
  end pp_muestra_impu;
  
  
  
  
    procedure pp_muestra_impu_iva(
                            p_moco_impu_codi           in number,
                            p_movi_dbcr                in varchar2,
                            p_impu_desc                out varchar2,
                            p_moco_impu_porc           out varchar2,
                            p_moco_impu_porc_base_impo out varchar2,
                            p_impu_indi_baim_impu_incl out varchar2,
                            p_MOCO_CONC_CODI_IMPU      out varchar2) is
  begin

  
    select impu_desc,
           impu_porc,
           impu_porc_base_impo,
           nvl(impu_indi_baim_impu_incl, 'S'),
           decode(p_movi_dbcr,
                  'C',
                  IMPU_CONC_CODI_IVCR,
                  IMPU_CONC_CODI_IVDB)
      into p_impu_desc,
           p_moco_impu_porc,
           p_moco_impu_porc_base_impo,
           p_impu_indi_baim_impu_incl,
           p_MOCO_CONC_CODI_IMPU
      from come_impu
     where impu_codi = p_moco_impu_codi;
  
  Exception
    when no_data_found then
      raise_application_error(-20001, 'Tipo de Impuesto inexistente');
    When too_many_rows then
      raise_application_error(-20001, 'Tipo de Impuesto duplicado');
    when others then
      raise_application_error(-20001, 'When others...');
  end pp_muestra_impu_iva;
  
  

  procedure pp_mostrar_unid_medi(p_codi in out number, p_desc out varchar2) is
  
  begin
    select ltrim(rtrim(medi_desc_abre))
      into p_desc
      from come_unid_medi m
     where m.medi_codi = p_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Unidad de medida inexistente');
    
  end pp_mostrar_unid_medi;

  procedure pp_mostrar_ot(p_prod_codi_alfa      in number,
                          p_movi_oper_codi      in number,
                          p_movi_mone_codi      in number,
                          p_movi_tasa_mone      in number,
                          p_movi_mone_cant_deci in number,
                          p_movi_clpr_codi      in number,
                          p_deta_prec_unit      in out number,
                          p_moco_conc_codi      out number,
                          p_moco_dbcr           out varchar2,
                          p_deta_prod_codi      out number,
                          p_deta_prod_clco      out varchar2,
                          p_s_producto_desc     out varchar2) is
    v_clpr_codi number;
    --v_cant           number;
    v_prec_vent      number;
    v_mone_codi_prec number;
    v_prec_unit      number;
    v_excl_fact      varchar2(1);
    v_indi_fact      varchar2(1);
  
  begin
    begin
      select ortr_codi,
             ortr_desc,
             ortr_clpr_codi,
             ortr_clco_codi,
             nvl(ORTR_MONE_CODI_PREC, parameter.p_codi_mone_mmnn),
             ORTR_PREC_VENT,
             nvl(ortr_excl_fact, 'N'),
             nvl(ortr_indi_fact, 'N')
        into p_deta_prod_codi,
             p_s_producto_desc,
             v_clpr_codi,
             p_deta_prod_clco,
             v_mone_codi_prec,
             v_prec_vent,
             v_excl_fact,
             v_indi_fact
        from come_orde_trab
       where ortr_nume = p_prod_codi_alfa;
    
  
    
      if p_deta_prod_clco is not null then
        pp_busca_conce_prod(p_deta_prod_clco,
                            p_movi_oper_codi,
                            p_moco_conc_codi,
                            p_moco_dbcr);
      end if;
    
      if v_excl_fact = upper('s') then
        raise_application_error(-20001,
                                'No se puede Facturar la OT porque est? excluida de Facturaci?n ');
      end if;
    
      if v_indi_fact <> upper('s') then
        raise_application_error(-20001,
                                'No se puede aplicar Nota de Credito porque la OT no ha sido Facturada ');
      end if;
    
      if v_mone_codi_prec = p_movi_mone_codi then
        v_prec_unit := v_prec_vent;
      else
        if p_movi_mone_codi = parameter.p_codi_mone_mmnn then
          v_prec_unit := round((v_prec_vent * p_movi_tasa_mone),
                               p_movi_mone_cant_deci);
        elsif p_movi_mone_codi = parameter.p_codi_mone_dola then
          v_prec_unit := round((v_prec_vent / p_movi_tasa_mone),
                               p_movi_mone_cant_deci);
        end if;
      end if;
    
      if nvl(p_deta_prec_unit, 0) <= 0 then
        p_deta_prec_unit := v_prec_unit;
      end if;
    
      --verificar que la orden de trabajo pertenezca al cliente...
      if v_clpr_codi <> p_movi_clpr_codi then
        raise_application_error(-20001,
                                'La orden de trabajo no pertenece al cliente/proveedor, Favor Verifique!!!');
      end if;
    
    exception
      when no_data_found then
        raise_application_error(-20001, 'Orden de trabajo inexistente!');
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_mostrar_ot;

  procedure pp_traer_desc_prod(p_prod_codi_alfa        in number,
                               p_movi_dbcr             in varchar2,
                               p_s_timo_calc_iva       in varchar2,
                               p_movi_oper_codi        in number,
                               p_deta_prod_codi        out varchar2,
                               p_moco_conc_codi        out varchar2,
                               p_s_producto_desc       out varchar2,
                               p_impu_desc             out varchar2,
                               p_deta_prod_clco        out varchar2,
                               p_imp_ind_baim_imp_incl out varchar2,
                               p_impu_porc_base_impo   out varchar2,
                               p_impu_porc             out varchar2,
                               p_MOCO_CONC_CODI_IMPU   out varchar2,
                               p_moco_impu_codi        in out varchar2) is
    v_deta_impu_codi number;
    v_indi_lote      varchar2(1);
    v_moco_dbcr      varchar2(10);
  begin
    
    select prod_codi,
           prod_desc,
           prod_clco_codi,
           prod_impu_codi,
           nvl(prod_indi_lote, 'N')
      into p_deta_prod_codi,
           p_s_producto_desc,
           p_deta_prod_clco,
           v_deta_impu_codi,
           v_indi_lote
      from come_prod
     where prod_codi_alfa = to_char(p_prod_codi_alfa)
       and nvl(prod_indi_inac, 'N') = 'N';
  
    if v_indi_lote = 'S' then
   
    
      null;
    end if;
  
    if p_moco_impu_codi is null then
      p_moco_impu_codi := v_deta_impu_codi;
      pp_muestra_impu(p_s_timo_calc_iva,
                      p_moco_impu_codi,
                      p_movi_dbcr,
                      p_impu_desc,
                      p_impu_porc,
                      p_impu_porc_base_impo,
                      p_imp_ind_baim_imp_incl,
                      p_MOCO_CONC_CODI_IMPU);
    else
      if p_s_timo_calc_iva = 'N' then
        p_moco_impu_codi := parameter.p_codi_impu_exen;
      end if;
    end if;
  
    pp_busca_conce_prod(p_deta_prod_clco,
                        p_movi_oper_codi,
                        p_moco_conc_codi,
                        v_moco_dbcr);
  
    if p_deta_prod_clco is null then
      raise_application_error(-20001,
                              'El producto no tiene definido la Clasificacion de Conceptos');
    end if;
  
  setitem('P128_MOCO_DBCR',v_moco_dbcr);
  exception
    when no_data_found then
      raise_application_error(-20001, 'Producto inexistente!');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_traer_desc_prod;

  procedure pp_validar_cant_medi(p_moco_cant_medi in number,
                                 p_coba_fact_conv in number,
                                 p_moco_cant_orig in number,
                                 p_indi_prod_ortr in varchar2,
                                 p_moco_cant      out number) is
  begin
  
    if p_moco_cant_medi is null then
      raise_application_error(-20001,
                              'Debe ingresar un valor para el campo Cantidad');
    elsif p_moco_cant_medi < 0 then
      raise_application_error(-20001, 'La Cantidad debe ser mayor a cero');
    end if;
  
    p_moco_cant := p_moco_cant_medi * NVL(p_coba_fact_conv, 1);
  
    if p_moco_cant > p_moco_cant_orig then
      raise_application_error(-20001,
                              'No se puede devolver una cantidad superior al saldo del producto ' ||
                              to_char(p_moco_cant_orig));
    end if;
  
    if p_indi_prod_ortr in ('O') then
      p_moco_cant := 1;
    end if;
  end pp_validar_cant_medi;

  procedure pp_validar_dto(p_s_movi_nume_fact in number,
                           p_indi_tipo_devo   in varchar2,
                           p_s_porcen_dto     in number,
                           p_moco_cant        in number,
                           p_deta_prec_unit   in number,
                           p_moco_porc_deto   in out number,
                           p_s_descuento      out number) is
  begin
  
    if p_s_movi_nume_fact is not null and p_indi_tipo_devo = 'D' then
      p_moco_porc_deto := 0;
    end if;
  
    if p_moco_porc_deto is null then
      p_moco_porc_deto := 0;
    end if;
  
    if p_s_porcen_dto is not null then
      p_moco_porc_deto := p_s_porcen_dto;
    end if;
  
    if nvl(p_moco_porc_deto, 0) >= 100 then
      raise_application_error(-20001, 'Debe ser menor a 100');
    elsif nvl(p_moco_porc_deto, 0) < 0 then
      raise_application_error(-20001, 'Debe ser mayor o igual a 0');
    elsif nvl(p_moco_porc_deto, 0) > 0 then
      p_s_descuento := round((nvl(p_moco_cant, 0) *
                             nvl(p_deta_prec_unit, 0) * p_moco_porc_deto / 100),
                             0);
    else
      -- si es igual a 0
      p_s_descuento := 0;
    end if;
  
  end pp_validar_dto;

  procedure pp_traer_desc_conce(p_codi      in number,
                                p_movi_dbcr in varchar2,
                                p_desc      out varchar2,
                                p_impu_codi out number) is
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
  
    v_indi_fact varchar2(1);
  begin
  
    for x in c_conc_iva(p_codi) loop
      raise_application_error(-20001,
                              'No puede seleccionar un concepto de IVA');
    end loop;
  
    select conc_desc, conc_dbcr, conc_impu_codi, nvl(conc_indi_fact, 'N')
      into p_desc, v_conc_dbcr, p_impu_codi, v_indi_fact
      from come_conc
     where conc_codi = p_codi;
  
    if v_indi_fact = 'N' then
      raise_application_error(-20001,
                              'Debe ingresar un concepto con el indicador Incluir en facturacion = Si');
    end if;
  
    if p_impu_codi is null then
      p_impu_codi := parameter.p_codi_impu_ortr;
    end if;

    setitem('P128_CONC_DBCR', v_conc_dbcr);
    setitem('P128_MOCO_DBCR', v_conc_dbcr);
    
  exception
    when no_data_found then
      raise_application_error(-20001, 'Concepto inexistente!');
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

  procedure pp_calcular_importe_item(p_movi_mone_cant_deci in number) is
  
    v_s_descuento       number;
    v_moco_iva_mone     number;
    v_moco_iva_mmnn     number;
    v_moco_impo_mmee_ii number;
    v_moco_grav10_mmee  number;
    v_moco_grav5_mmee   number;
    v_moco_iva10_mmee   number;
    v_moco_iva5_mmee    number;
  
  begin

 
    for bdet in c loop
    
      if (bdet.s_item = 'X') then
      
        v_s_descuento := round((bdet.deta_prec_unit * bdet.moco_cant_medi *
                               NVL(bdet.moco_porc_deto,0) / 100),
                               p_movi_mone_cant_deci);
   
        if bdet.moco_cant_medi > 0 then
          moco.moco_impo_mone_ii := round((nvl(bdet.deta_prec_unit, 0) *
                                          (1 -
                                          (nvl(bdet.moco_porc_deto, 0) / 100)) *
                                          nvl(bdet.moco_cant_medi, 0)),
                                          p_movi_mone_cant_deci);
                                         
         
                                          
 
        else
          moco.moco_impo_mone_ii := round((nvl(bdet.deta_prec_unit, 0) *
                                          (1 -
                                          (nvl(bdet.moco_porc_deto, 0) / 100))),
                                          p_movi_mone_cant_deci);
        end if;
        moco.moco_impo_mmnn_ii := round((moco.moco_impo_mone_ii *
                                        bcab.movi_tasa_mone),
                                        parameter.p_cant_Deci_mmnn);
                                        
                                       
    
                                        
     
        pa_devu_impo_calc(moco.moco_impo_mone_ii,
                          p_movi_mone_cant_deci,
                          bdet.moco_impu_porc,
                          bdet.moco_impu_porc_base_impo,
                          bdet.moco_impu_indi_baim_impu_incl,
                          -----out
                          moco.moco_impo_mone_ii,
                          moco.moco_grav10_ii_mone,
                          moco.moco_grav5_ii_mone,
                          moco.moco_grav10_mone,
                          moco.moco_grav5_mone,
                          moco.moco_iva10_mone,
                          moco.moco_iva5_mone,
                          moco.moco_Exen_mone);
                         
       
     
        pa_devu_impo_calc(moco.moco_impo_mmnn_ii,
                          parameter.p_cant_deci_mmnn,
                          bdet.moco_impu_porc,
                          bdet.moco_impu_porc_base_impo,
                          bdet.moco_impu_indi_baim_impu_incl,
                          --out
                          moco.moco_impo_mmnn_ii,
                          moco.moco_grav10_ii_mmnn,
                          moco.moco_grav5_ii_mmnn,
                          moco.moco_grav10_mmnn,
                          moco.moco_grav5_mmnn,
                          moco.moco_iva10_mmnn,
                          moco.moco_iva5_mmnn,
                          moco.moco_exen_mmnn);
      
        v_moco_iva_mone := nvl(moco.moco_iva10_mone, 0) +
                           nvl(moco.moco_iva5_mone, 0);
        v_moco_iva_mmnn := moco.moco_iva10_mmnn + moco.moco_iva5_mmnn;
       --  :bdet.moco_iva_mone := nvl(:bdet.moco_iva10_mone, 0) + nvl(:bdet.moco_iva5_mone, 0);
      
        -- :bdet.s_deta_exen_nc        := :bdet.moco_exen_mone;
        -- :bdet.s_deta_grav_5_ii_nc   := :bdet.moco_grav5_ii_mone;
        --:bdet.s_deta_grav_10_ii_nc  := :bdet.moco_grav10_ii_mone;
        -- :bdet.s_descuento_nc        := :bdet.s_descuento;
      
        moco.moco_impo_mmnn := moco.moco_exen_mmnn + moco.moco_grav10_mmnn + moco.moco_grav5_mmnn;
     
       
        moco.moco_impo_mone := moco.moco_exen_mone + moco.moco_grav10_mone +
                               moco.moco_grav5_mone;
                              
 
                               
                              
          
      else
        moco.moco_impo_mone_ii   := 0;
        moco.moco_grav10_ii_mone := 0;
        moco.moco_grav5_ii_mone  := 0;
        moco.moco_grav10_mone    := 0;
        moco.moco_grav5_mone     := 0;
        moco.moco_iva10_mone     := 0;
        moco.moco_iva5_mone      := 0;
        moco.moco_exen_mone      := 0;
        moco.moco_impo_mmnn_ii   := 0;
        moco.moco_grav10_ii_mmnn := 0;
        moco.moco_grav5_ii_mmnn  := 0;
        moco.moco_grav10_mmnn    := 0;
        moco.moco_grav5_mmnn     := 0;
        moco.moco_iva10_mmnn     := 0;
        moco.moco_iva5_mmnn      := 0;
        moco.moco_exen_mmnn      := 0;
        v_moco_impo_mmee_ii      := 0;
        v_moco_grav10_mmee       := 0;
        v_moco_grav5_mmee        := 0;
        v_moco_iva10_mmee        := 0;
        v_moco_iva5_mmee         := 0;
        -- v_moco_exen_mmee      := 0;
      
        -- :bdet.s_deta_exen_nc        := 0;
        -- v_s_deta_grav_5_ii_nc   := 0;
        --   v_s_deta_grav_10_ii_nc  := 0;
        --  v_s_descuento_nc        := 0;
      
        moco.moco_impo_mmnn := 0;
        moco.moco_impo_mone := 0;
      
      end if;
    
      ------actualiza todo los datos 
       --RAISE_APPLICATION_ERROR(-20001,'ONE BULLET ONE DEATH '||   moco.moco_impo_mone_ii );
      apex_collection.UPDATE_MEMBER(p_collection_name => 'BDETALLE',
                                    p_seq             => bdet.seq_id,
                                    p_c001            => bdet.s_item,
                                    p_c002            => bdet.indi_prod_ortr,
                                    p_c003            => bdet.deta_prod_codi,
                                    p_c004            => bdet.prod_codi_alfa,
                                    p_c005            => bdet.s_producto_desc,
                                    p_c006            => bdet.prod_codi_alfa_orig,
                                    p_c007            => bdet.moco_impu_codi,
                                    p_c008            => bdet.moco_cant,
                                    p_c009            => bdet.moco_cant_orig,
                                    p_c010            => bdet.deta_prec_unit,
                                    p_c011            => bdet.moco_porc_deto,
                                    p_c012            => bdet.deta_movi_codi_padr,
                                    p_c013            => bdet.deta_nume_item_padr,
                                    p_c014            => bdet.moco_medi_codi,
                                    p_c015            => bdet.deta_medi_codi,
                                    p_c016            => bdet.DETA_PROD_CODI_BARR,
                                    p_c017            => bdet.deta_lote_codi,
                                    p_c018            => bdet.coba_fact_conv,
                                    p_c019            => bdet.impu_desc,
                                    p_c020            => bdet.moco_impu_porc,
                                    p_c021            => bdet.moco_impu_porc_base_impo,
                                    p_c022            => bdet.moco_impu_indi_baim_impu_incl,
                                    p_c023            => bdet.MOCO_CONC_CODI_IMPU,
                                    p_c024            => bdet.moco_cant_medi,
                                    p_c025            => bdet.moco_dbcr,
                                    p_c026            => moco.moco_impo_mmee,
                                    p_c027            => moco.moco_impo_mone_ii,
                                    p_c028            => moco.moco_impo_mmnn_ii,
                                    p_c029            => moco.moco_grav10_ii_mone,
                                    p_c030            => bdet.moco_conc_codi,
                                    p_c031            => moco.moco_grav5_ii_mone,
                                    p_c032            => moco.moco_grav10_ii_mmnn,
                                    p_c033            => moco.moco_grav5_ii_mmnn,
                                    p_c034            => moco.moco_grav10_mone,
                                    p_c035            => moco.moco_grav5_mone,
                                    p_c036            => moco.moco_grav10_mmnn,
                                    p_c037            => moco.moco_grav5_mmnn,
                                    p_c038            => moco.moco_iva10_mone,
                                    p_c039            => moco.moco_iva5_mone,
                                    p_c040            => moco.moco_iva10_mmnn,
                                    p_c041            => moco.moco_iva5_mmnn,
                                    p_c042            => moco.moco_exen_mone,
                                    p_c043            => moco.moco_exen_mmnn,
                                    p_c044            => bdet.deta_prod_clco,
                                    p_c045            => bdet.indi_venc,
                                    p_c046            => bdet.sofa_nume_item,
                                    p_c047            => bdet.ortr_desc,
                                    p_c048            => bdet.w_movi_codi_cabe,
                                    p_n001             =>moco.moco_impo_mone,
                                    p_n002            => v_moco_iva_mone,
                                    p_n003            => bdet.moco_iva_mmee,
                                    p_n004            => v_moco_iva_mmnn,
                                    p_n005            => moco.moco_impo_mmnn);
                                   
  
    
    end loop;
  end pp_calcular_importe_item;

  procedure ADD_MEMBER(p_movi_mone_cant_deci in number,
                       p_seq_id              in number,
                       p_s_item              in varchar2,
                       p_indi_prod_ortr      in varchar2,
                       P_deta_prec_unit      in number,
                       P_moco_cant_medi      in number,
                       p_movi_tasa_mone      in number,
                       P_moco_porc_deto      in number,
                       p_moco_impu_porc      in number,
                       p_deta_prod_codi      in number,
                       -- P_moco_cant in number,
                       p_moco_impu_porc_base_impo in number,
                       p_imp_ind_baim_impu_incl   in varchar2) is
  
    v_s_descuento       number;
    v_moco_iva_mone     number;
    v_moco_iva_mmnn     number;
   
   
 
 
 
    v_deta_movi_codi_padr number;
    v_deta_nume_item_padr number;
    v_moco_medi_codi number;
    v_deta_medi_codi number;
    v_coba_fact_conv number;
  
  begin

 if v('P128_PROD_CODI_ALFA') is null then
    raise_application_error(-20001,'El campo Prod\Conc\OT no puede ser nulo.');
    end if;
  
    if v('p128_conc_dbcr') = 'D' and v('p128_movi_dbcr') = 'C' then
      raise_application_error(-20001,
                              'Debe ingresar un concepto de tipo Egreso ');
    elsif v('p128_conc_dbcr') = 'C' and v('p128_movi_dbcr') = 'D' then
      raise_application_error(-20001,
                              'Debe ingresar un concepto de tipo ingreso ');
    end if;
  
    if p_moco_cant_medi is null then
      raise_application_error(-20001,
                              'Debe ingresar un valor para el campo Cantidad');
    elsif p_moco_cant_medi < 0 then
      raise_application_error(-20001, 'La Cantidad debe ser mayor a cero');
    end if;
  
  
    if to_number(v('p128_moco_cant')) > v('p128_moco_cant_orig') then
      raise_application_error(-20001,
                              'No se puede devolver una cantidad superior al saldo del producto ' ||
                              to_char(v('p128_moco_cant_orig')));
    end if;
  
    if p_deta_prec_unit is null then
      raise_application_error(-20001, 'El precio no puede ser nulo');
    elsif p_deta_prec_unit <= 0 then
      raise_application_error(-20001,
                              'El precio no puede ser menor a cero');
    end if;
  
  
  
  
  
   
      if p_s_item = 'X' then
      
      
        v_s_descuento := round((P_deta_prec_unit * P_moco_cant_medi *
                               P_moco_porc_deto / 100),
                               p_movi_mone_cant_deci);
      
        if p_moco_cant_medi > 0 then
          moco.moco_impo_mone_ii := round(((nvl(p_deta_prec_unit, 0) *
                                          (1 -
                                          (nvl(p_moco_porc_deto, 0) / 100))) *
                                          nvl(p_moco_cant_medi, 0)),
                                          nvl(p_movi_mone_cant_deci, 0));
        
 

        else
          moco.moco_impo_mone_ii := round((nvl(p_deta_prec_unit, 0) *
                                          (1 -
                                          (nvl(p_moco_porc_deto, 0) / 100))),
                                          nvl(p_movi_mone_cant_deci, 0));
        end if;
      
        moco.moco_impo_mmnn_ii := round((moco.moco_impo_mone_ii *
                                        p_movi_tasa_mone),
                                        parameter.p_cant_Deci_mmnn);
      
    
        pa_devu_impo_calc(moco.moco_impo_mone_ii,
                          nvl(p_movi_mone_cant_deci, 0),
                          p_moco_impu_porc,
                          p_moco_impu_porc_base_impo,
                          p_imp_ind_baim_impu_incl,
                          -----out
                          moco.moco_impo_mone_ii,
                          moco.moco_grav10_ii_mone,
                          moco.moco_grav5_ii_mone,
                          moco.moco_grav10_mone,
                          moco.moco_grav5_mone,
                          moco.moco_iva10_mone,
                          moco.moco_iva5_mone,
                          moco.moco_Exen_mone);
                          
                      
      
        pa_devu_impo_calc(moco.moco_impo_mmnn_ii,
                          parameter.p_cant_deci_mmnn,
                          p_moco_impu_porc,
                          p_moco_impu_porc_base_impo,
                          p_imp_ind_baim_impu_incl,
                          --out
                          moco.moco_impo_mmnn_ii,
                          moco.moco_grav10_ii_mmnn,
                          moco.moco_grav5_ii_mmnn,
                          moco.moco_grav10_mmnn,
                          moco.moco_grav5_mmnn,
                          moco.moco_iva10_mmnn,
                          moco.moco_iva5_mmnn,
                          moco.moco_exen_mmnn);
                          
                          
      
        v_moco_iva_mone := nvl(moco.moco_iva10_mone, 0) +
                           nvl(moco.moco_iva5_mone, 0);
        v_moco_iva_mmnn := moco.moco_iva10_mmnn + moco.moco_iva5_mmnn;
      
      
      
        moco.moco_impo_mmnn := moco.moco_exen_mmnn + moco.moco_grav10_mmnn +
                               moco.moco_grav5_mmnn;
        moco.moco_impo_mone := moco.moco_exen_mone + moco.moco_grav10_mone +
                               moco.moco_grav5_mone;
      else
        moco.moco_impo_mone_ii   := 0;
        moco.moco_grav10_ii_mone := 0;
        moco.moco_grav5_ii_mone  := 0;
        moco.moco_grav10_mone    := 0;
        moco.moco_grav5_mone     := 0;
        moco.moco_iva10_mone     := 0;
        moco.moco_iva5_mone      := 0;
        moco.moco_exen_mone      := 0;
        moco.moco_impo_mmnn_ii   := 0;
        moco.moco_grav10_ii_mmnn := 0;
        moco.moco_grav5_ii_mmnn  := 0;
        moco.moco_grav10_mmnn    := 0;
        moco.moco_grav5_mmnn     := 0;
        moco.moco_iva10_mmnn     := 0;
        moco.moco_iva5_mmnn      := 0;
        moco.moco_exen_mmnn      := 0;
        
        
      
       
    
    
      
        moco.moco_impo_mmnn := 0;
        moco.moco_impo_mone := 0;
      
      end if;
    
      ------actualiza todo los datos 
      if p_seq_id is not null then
     for bdet in c(p_seq_id) loop
      apex_collection.UPDATE_MEMBER(p_collection_name => 'BDETALLE',
                                    p_seq             => p_seq_id,
                                    p_c001            => p_s_item, --bdet.s_item, ---ind_marcado
                                    p_c002            => p_indi_prod_ortr,
                                    p_c003            => p_deta_prod_codi,
                                    p_c004            => v('p128_prod_codi_alfa'),
                                    p_c005            => v('p128_s_producto_desc'),
                                    p_c006            => bdet.prod_codi_alfa_orig,
                                    p_c007            =>v('p128_moco_impu_codi')  ,
                                    p_c008            => to_number(v('p128_moco_cant')),
                                    p_c009            => bdet.moco_cant_orig,
                                    p_c010            => p_deta_prec_unit,
                                    p_c011            => p_moco_porc_deto,
                                    p_c012            => bdet.deta_movi_codi_padr,
                                    p_c013            => bdet.deta_nume_item_padr,
                                    p_c014            => bdet.moco_medi_codi,
                                    p_c015            => bdet.deta_medi_codi,
                                    p_c016            => bdet.DETA_PROD_CODI_BARR,
                                    p_c017            => bdet.deta_lote_codi,
                                    p_c018            => bdet.coba_fact_conv,
                                    p_c019            =>v('P128_IMPU_DESC')   ,
                                    p_c020            => p_moco_impu_porc,
                                    p_c021            => p_moco_impu_porc_base_impo,
                                    p_c022            => p_imp_ind_baim_impu_incl,
                                    p_c023            => bdet.MOCO_CONC_CODI_IMPU,
                                    p_c024            => p_moco_cant_medi,
                                    p_c025            =>  v('p128_moco_dbcr') ,
                                    p_c026            => moco.moco_impo_mmee,
                                    p_c027            => moco.moco_impo_mone_ii,
                                    p_c028            => moco.moco_impo_mmnn_ii,
                                    p_c029            => moco.moco_grav10_ii_mone,
                                    p_c030            =>V('P128_MOCO_CONC_CODI'),-- bdet.moco_conc_codi,
                                    p_c031            => moco.moco_grav5_ii_mone,
                                    p_c032            => moco.moco_grav10_ii_mmnn,
                                    p_c033            => moco.moco_grav5_ii_mmnn,
                                    p_c034            => moco.moco_grav10_mone,
                                    p_c035            => moco.moco_grav5_mone,
                                    p_c036            => moco.moco_grav10_mmnn,
                                    p_c037            => moco.moco_grav5_mmnn,
                                    p_c038            => moco.moco_iva10_mone,
                                    p_c039            => moco.moco_iva5_mone,
                                    p_c040            => moco.moco_iva10_mmnn,
                                    p_c041            => moco.moco_iva5_mmnn,
                                    p_c042            => moco.moco_exen_mone,
                                    p_c043            => moco.moco_exen_mmnn,
                                    p_c044            => v('P128_DETA_PROD_CLCO'),
                                    p_c045            => v('P128_indi_venc'),
                                    p_c046            => bdet.sofa_nume_item,
                                    p_c047            => bdet.ortr_desc,
                                    p_c048            => bdet.w_movi_codi_cabe,
                                    p_n001            => moco.moco_impo_mmnn,
                                    p_n002            => v_moco_iva_mone,
                                    p_n003            => bdet.moco_iva_mmee,
                                    p_n004            => v_moco_iva_mmnn,
                                    p_n005            => moco.moco_impo_mmnn);
    
    end loop;
    else
      --raise_application_error(-20001,p_seq_id);
   -- if p_seq_id is null then
    
     apex_collection.add_member(p_collection_name => 'BDETALLE',
                                    p_c001            => p_s_item, 
                                    p_c002            => p_indi_prod_ortr,
                                    p_c003            => p_deta_prod_codi,
                                    p_c004            => v('P128_PROD_CODI_ALFA'),
                                    p_c005            => v('P128_S_PRODUCTO_DESC'),
                                    p_c006            => v('P128_PROD_CODI_ALFA_ORIG'),
                                    p_c007            =>v('P128_MOCO_IMPU_CODI')  ,
                                    p_c008            => to_number(v('P128_MOCO_CANT')),
                                    p_c009            => v('P128_MOCO_CANT_ORIG'),
                                    p_c010            => p_deta_prec_unit,
                                    p_c011            => p_moco_porc_deto,
                                    p_c012            => v_deta_movi_codi_padr,
                                    p_c013            => v_deta_nume_item_padr,
                                    p_c014            => v_moco_medi_codi,
                                    p_c015            => v_deta_medi_codi,
                                    p_c016            => v('P128_DETA_PROD_CODI_BARR'),
                                    p_c017            => v('P128_DETA_LOTE_CODI'),
                                    p_c018            => v_coba_fact_conv,
                                    p_c019            =>v('P128_IMPU_DESC')   ,
                                    p_c020            => p_moco_impu_porc,
                                    p_c021            => p_moco_impu_porc_base_impo,
                                    p_c022            => p_imp_ind_baim_impu_incl,
                                    p_c023            => v('P128_MOCO_CONC_CODI_IMPU'),
                                    p_c024            => p_moco_cant_medi,
                                    p_c025            =>  v('P128_MOCO_DBCR') ,
                                    p_c026            => null,--bdet.moco_impo_mmee,
                                    p_c027            => moco.moco_impo_mone_ii,
                                    p_c028            => moco.moco_impo_mmnn_ii,
                                    p_c029            => moco.moco_grav10_ii_mone,
                                    p_c030            => v('P128_MOCO_CONC_CODI'),
                                    p_c031            => moco.moco_grav5_ii_mone,
                                    p_c032            => moco.moco_grav10_ii_mmnn,
                                    p_c033            => moco.moco_grav5_ii_mmnn,
                                    p_c034            => moco.moco_grav10_mone,
                                    p_c035            => moco.moco_grav5_mone,
                                    p_c036            => moco.moco_grav10_mmnn,
                                    p_c037            => moco.moco_grav5_mmnn,
                                    p_c038            => moco.moco_iva10_mone,
                                    p_c039            => moco.moco_iva5_mone,
                                    p_c040            => moco.moco_iva10_mmnn,
                                    p_c041            => moco.moco_iva5_mmnn,
                                    p_c042            => moco.moco_exen_mone,
                                    p_c043            => moco.moco_exen_mmnn,
                                    p_c044            => v('P128_DETA_PROD_CLCO'),--bdet.deta_prod_clco,
                                    p_c045            => v('P128_indi_venc'),
                                    p_c046            => null,--bdet.sofa_nume_item,
                                    p_c047            => null,--bdet.ortr_desc,
                                    p_c048            => null,--bdet.w_movi_codi_cabe,
                                    p_n001            => moco.moco_impo_mmnn,
                                    p_n002            => v_moco_iva_mone,
                                    p_n003            =>null,--- bdet.moco_iva_mmee,
                                    p_n004            => v_moco_iva_mmnn,
                                    p_n005            => moco.moco_impo_mmnn);
      end if;
    
    
    
    
    
  end ADD_MEMBER;
  
  
  PROCEDURE pp_traer_datos_codi_barr(p_prod_codi      in number, 
                                   p_medi_codi      in number, 
                                   p_codi_barr_in  in varchar2,  
                                   p_codi_barr     out varchar2, 
                                   p_fact_conv     out number) IS
BEGIN
  
  
  select d.coba_codi_barr, d.coba_fact_conv
    into p_codi_barr, p_fact_conv
    from come_prod_coba_deta d
   where d.coba_prod_codi=p_prod_codi
     and d.coba_medi_codi=p_medi_codi
     and (d.COBA_CODI_BARR = p_codi_barr_in or p_codi_barr_in is null);
  
Exception
  when no_data_found then
    p_codi_barr:= null;
    p_fact_conv:= null;
  when too_many_rows then
   begin 
     select d.coba_codi_barr, d.coba_fact_conv
      into p_codi_barr, p_fact_conv
     from come_prod_coba_deta d
     where d.coba_prod_codi=p_prod_codi
     and d.coba_medi_codi=p_medi_codi
     and d.coba_nume_item = 1;
   end;
  when others then
    raise_application_error(-20001,sqlerrm);
END pp_traer_datos_codi_barr;

  PROCEDURE pp_valida_vigencia_timbrado(p_tico_indi_timb in varchar2,
                                        p_tico_codi      in number,
                                        p_esta           in number,
                                        p_punt_expe      in number,
                                        p_fech_movi      in date,
                                        p_timb_nume      in number) IS
    v_count number := 0;
  BEGIN
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
        raise_application_error(-20001,
                                'Timbrado inexistente. Verifique el mantenimiento de Comprobantes.');
      end if;
    elsif nvl(p_tico_indi_timb, 'C') = 'S' then
      select count(*)
        into v_count
        from come_secu_tipo_comp
       where setc_secu_codi =
               (select f.user_secu_codi
                          from segu_user f
                         where user_login = fa_user)
         and setc_tico_codi = p_tico_codi --tipo de comprobante
         and setc_esta = p_esta --establecimiento 
         and setc_punt_expe = p_punt_expe --punto de expedicion
         and setc_fech_venc >= p_fech_movi
         and setc_nume_timb = p_timb_nume;
      if v_count = 0 then
        raise_application_error(-20001,
                                'Timbrado inexistente. Verifique la secuencia de documentos.');
      end if;
    end if;
  END pp_valida_vigencia_timbrado;
  
  
  
  procedure pp_ejecutar_consulta_node_deta(p_s_movi_node_nume in number) is

  cursor c_node_deta (p_node_nume in number) is
select nd.node_nume_item,
       nd.node_indi_ortr,
       nvl(nd.node_prod_codi, nvl(nd.node_ortr, nd.node_conc_codi)) node_prod_codi,
       nvl(p.prod_codi_alfa, nvl(ot.ortr_nume, c.conc_codi_alte)) prod_codi_alfa,
       nvl(p.prod_desc, nvl(ot.ortr_desc, c.conc_desc)) prod_desc,
       nd.node_cant,
       nd.node_medi_codi,
       nd.node_prec_unit,
       nd.node_impo_mone, 
       nd.NODE_PROD_CODI_BARR,
       c.conc_impu_codi
  from come_nota_devu_deta nd,
       come_nota_devu      n,
       come_prod           p,
       come_orde_trab      ot,
       come_conc           c
 where n.node_nume = p_node_nume 
   and nd.node_nota_codi = n.node_codi
   and p.prod_codi(+) = nd.node_prod_codi
   and ot.ortr_codi(+) = nd.node_ortr
   and c.conc_codi(+) = nd.node_conc_codi
order by nd.node_nume_item;


    v_cant_coba number := 0;
    v_indi_prod_ortr           varchar2(1);
    v_deta_cant_sald           number;
    v_deta_prod_codi           number;
    v_moco_impu_codi           number;
    v_deta_prec_unit           number;
    v_deta_porc_deto           number;
    v_prod_codi_alfa           varchar2(500);
    v_medi_desc_abre           varchar2(500); 
    v_moco_medi_codi           number;
    v_DETA_PROD_CODI_BARR      varchar2(30);
    v_moco_nume_item   varchar2(30);
    v_s_producto_desc           varchar2(500);
    v_moco_impu_porc number;
    v_impu_desc     varchar2(500);
    v_impu_indi_baim_impu_incl varchar2(2);
    v_deta_lote_codi           number;
    v_coba_fact_conv           number;
    v_moco_cant_medi           number;
    v_moco_impu_porc_base_impo NUMBER;
    v_MOCO_CONC_CODI_IMPU NUMBER;
begin

    apex_collection.create_or_truncate_collection(p_collection_name => 'BDETALLE');
    
  for x in c_node_deta (p_s_movi_node_nume) loop
    v_indi_prod_ortr      := x.node_indi_ortr;
    v_moco_nume_item      := x.node_nume_item;
    v_s_producto_desc     := x.prod_desc;
    v_deta_prod_codi      := x.node_prod_codi; 
    v_prod_codi_alfa      := x.prod_codi_alfa;
    v_moco_medi_codi      := x.node_medi_codi;
    v_moco_cant_medi      := x.node_cant;
    v_deta_prec_unit      := x.node_prec_unit;
    v_deta_prod_codi_barr := x.NODE_PROD_CODI_BARR;
    v_moco_impu_codi := x.conc_impu_codi;
    
    begin
      select count(*)
        into v_cant_coba
        from come_prod_coba_deta
       where coba_codi_barr = x.NODE_PROD_CODI_BARR
         and coba_prod_codi = (select prod_codi
                                 from come_prod
                                where prod_codi_alfa = x.prod_codi_alfa);
          
          if v_cant_coba > 0 then 
            v_deta_prod_codi_barr := x.NODE_PROD_CODI_BARR;
          else
            begin
              select coba_codi_barr
                into v_deta_prod_codi_barr
                from come_prod_coba_deta
               where coba_nume_item = 1
                 and coba_prod_codi = (select prod_codi
                                         from come_prod
                                        where prod_codi_alfa = x.prod_codi_alfa);
            exception
              when no_data_found then
                v_deta_prod_codi_barr := null;
            end;
            
          end if;
    end;
    
    if v_moco_medi_codi is not null then
      pp_mostrar_unid_medi(v_moco_medi_codi, v_medi_desc_abre);
      pp_traer_datos_codi_barr(v_deta_prod_codi, 
                                   v_moco_medi_codi, 
                                   v_deta_prod_codi_barr, 
                                   v_deta_prod_codi_barr, 
                                   v_coba_fact_conv);
    end if;
    
     if v_moco_impu_codi is not null then
          pp_muestra_impu(V('P128_S_TIMO_CALC_IVA'),
                          v_moco_impu_codi,
                          'P128_MOVI_DBCR',
                          v_impu_desc,
                          v_moco_impu_porc,
                          v_moco_impu_porc_base_impo,
                          v_impu_indi_baim_impu_incl,
                          v_MOCO_CONC_CODI_IMPU);
        
        end if;
    
    

          
        apex_collection.add_member(p_collection_name => 'BDETALLE',
                                   p_c001            => 'X', ---ind_marcado
                                   p_c002            => v_indi_prod_ortr,
                                   p_c003            => v_deta_prod_codi,
                                   p_c004            => v_prod_codi_alfa,
                                   p_c005            => v_s_producto_desc,
                                   p_c006            => v_prod_codi_alfa,
                                   p_c007            => v_moco_impu_codi,
                                   p_c008            => v_deta_cant_sald,
                                   p_c009            => v_deta_cant_sald,
                                   p_c010            => v_deta_prec_unit,
                                   p_c011            => v_deta_porc_deto,
                                   p_c012            => null,
                                   p_c013            => null,
                                   p_c014            => v_moco_medi_codi,
                                   p_c015            => v_moco_medi_codi,
                                   p_c016            => v_DETA_PROD_CODI_BARR,
                                   p_c017            => v_deta_lote_codi,
                                   p_c018            => v_coba_fact_conv,
                                   p_c019            => v_impu_desc,
                                   p_c020            => v_moco_impu_porc,
                                   p_c021            => v_moco_impu_porc_base_impo,
                                   p_c022            => v_impu_indi_baim_impu_incl,
                                   p_c023            => v_MOCO_CONC_CODI_IMPU ,
                                   p_c024            => v_moco_cant_medi,
                                   p_c047            => v_s_producto_desc);
  
  
  end loop;
  
 


  
exception
  when no_data_found then
    null;
  when others then
    raise_Application_error(-20001,sqlerrm); 
end pp_ejecutar_consulta_node_deta;

procedure pp_valida_nota_devu(p_s_movi_node_nume in number,
                              p_movi_empr_codi in number,
                              p_indi_vali_cuen_banc out varchar2,
                              p_movi_node_codi out number,
                              p_movi_clpr_codi out number,
                              p_movi_depo_codi_orig out number,
                              p_movi_obse out varchar2,
                              p_movi_empl_codi_orig out number,
                              p_movi_mone_codi out number,
                               p_movi_nume_fact out number) is
  v_cont number;
  V_movi_mone_desc_abre VARCHAR2(200);
  V_movi_mone_cant_deci NUMBER;
    
begin 
  select count(*)
    into v_cont
    from come_nota_devu
   where node_nume = p_s_movi_node_nume
     and nvl(node_empr_codi,1) = nvl(p_movi_empr_codi,1)
     and node_esta = 'A';
  
  if v_cont =  1 then

    pp_ejecutar_consulta_node_nume(p_s_movi_node_nume,
                                   p_movi_node_codi,
                                   p_movi_clpr_codi,
                                   p_movi_depo_codi_orig,
                                   p_movi_obse,
                                   p_movi_empl_codi_orig,
                                   p_movi_mone_codi,
                                   p_movi_nume_fact);
    p_indi_vali_cuen_banc := 'N';
    pp_ejecutar_consulta_node_deta(p_s_movi_node_nume);
       if p_movi_mone_codi is not null then
       pp_mostrar_mone (p_movi_mone_codi, V_movi_mone_desc_abre, V_movi_mone_cant_deci);
            pp_busca_tasa_mone(p_movi_mone_codi, v('P128_S_MOVI_FECH_EMIS'), bcab.movi_tasa_mone, v('P128_MOVI_TICA_CODI'));
       end if;
        I020012.pp_calcular_importe_item(P_movi_mone_cant_deci => V_movi_mone_cant_deci);
   
    p_indi_vali_cuen_banc := 'S';
    
    
    
  elsif v_cont > 1 then  
    raise_Application_error(-20001,'Nro de devoluci?n Duplicada!!');
  else
  
    raise_Application_error(-20001,'Devoluci?n Inexistente o No Autorizada');

  end if;    
exception
  when no_data_found then
   raise_Application_error(-20001,'Devoluci?n Inexistente');
end pp_valida_nota_devu;

  
  procedure pp_ejecutar_consulta_node_nume(p_s_movi_node_nume in number,
                                         p_movi_node_codi out number,
                                         p_movi_clpr_codi out number,
                                         p_movi_depo_codi_orig out number,
                                         p_movi_obse out varchar2,
                                         p_movi_empl_codi_orig out number,
                                         p_movi_mone_codi out number,
                                         p_movi_nume_fact out number) is
  cursor c_nota_devu is
    select node_codi,
           node_nume,
           node_clpr_codi,
           node_empr_codi,
           node_sucu_codi,
           node_depo_codi,
           node_obse,
           node_empl_codi,
           node_mone_codi,
           node_fact_codi,
           j.clpr_codi_alte
      from come_nota_devu, 
           come_clie_prov j
     where  node_clpr_codi=j.clpr_codi
     and node_nume = p_s_movi_node_nume;
     
    

begin

  for x in c_nota_devu loop
    p_movi_node_codi            :=       x.node_codi;
    p_movi_clpr_codi            :=       x.clpr_codi_alte;
    p_movi_depo_codi_orig       :=       x.node_depo_codi;
    p_movi_obse                 :=       x.node_obse;
    p_movi_empl_codi_orig       :=       x.node_empl_codi;
    p_movi_mone_codi            :=       x.node_mone_codi;
    p_movi_nume_fact            :=       x.node_fact_codi;

  end loop;

exception
  when no_data_found then
    raise_application_error(-20001,'Devolucion Inexistente');
  when too_many_rows then
    raise_application_error(-20001,'Existen dos contratos con el mismo numero, avise a su administrador');
end pp_ejecutar_consulta_node_nume;

  
  
  procedure pp_recupera_datos(p_seq_id              in number,
                              p_indi_prod_ortr      out varchar2,
                              p_deta_prod_codi      out number,
                              p_prod_codi_alfa      out varchar2,
                              p_s_producto_desc     out varchar2,
                              p_moco_impu_codi      out varchar2,
                              p_deta_prec_unit      out varchar2,
                              p_moco_porc_deto      out varchar2,
                              p_DETA_PROD_CODI_BARR out varchar2,
                              p_moco_cant_medi      out varchar2,
                              p_moco_conc_codi  out varchar2,
                              p_indi_ven out varchar2) is
    v_moco_cant_orig number;
    v_MOCO_CANT      number;
    v_coba_fact_conv number;
    v_deta_medi_codi number;
  begin
  
    select c002 indi_prod_ortr,
           c003 deta_prod_codi,
           c004 prod_codi_alfa,
           c005 s_producto_desc,
           c007 moco_impu_codi,
           c008 MOCO_CANT,
           c009 moco_cant_orig,
           c010 deta_prec_unit,
           c011 moco_porc_deto,
           c015 deta_medi_codi,
           c016 DETA_PROD_CODI_BARR,
           c018 coba_fact_conv,
           c024 moco_cant_medi,
           c030 moco_conc_codi,
           c045 indi_venc
      into p_indi_prod_ortr,
           p_deta_prod_codi,
           p_prod_codi_alfa,
           p_s_producto_desc,
           p_moco_impu_codi,
           v_MOCO_CANT,
           v_moco_cant_orig,
           p_deta_prec_unit,
           p_moco_porc_deto,
           v_deta_medi_codi,
           p_DETA_PROD_CODI_BARR,
           v_coba_fact_conv,
           p_moco_cant_medi,
           p_moco_conc_codi,
           p_indi_ven
    
      from apex_collections a
     where collection_name = 'BDETALLE'
       and seq_id = p_seq_id;
       
    setitem('P128_deta_medi_codi',v_deta_medi_codi);
    setitem('p128_moco_cant_orig', v_moco_cant_orig);
    setitem('P128_MOCO_CANT', v_MOCO_CANT);
    setitem('P128_coba_fact_conv', v_coba_fact_conv);
  
  end pp_recupera_datos;

  procedure pp_validar_prod_conp(p_indi_prod_ortr        in varchar2,
                                 p_clpr_indi_exen        in varchar2,
                                 P_movi_mone_codi        in number,
                                 P_movi_tasa_mone        in number,
                                 p_movi_clpr_codi        in number,
                                 P_movi_mone_cant_deci   in number,
                                 p_deta_prec_unit        in out number,
                                 p_s_item                in varchar2,
                                 p_prod_codi_alfa        in out number,
                                 p_prod_codi_alfa_orig   in number,
                                 p_movi_dbcr             in varchar2,
                                 p_moco_dbcr             out varchar2,
                                 p_s_timo_calc_iva       in varchar2,
                                 p_movi_oper_codi        in number,
                                 p_deta_prod_codi        out varchar2,
                                 p_moco_conc_codi        out varchar2,
                                 p_s_producto_desc        out varchar2,
                                 p_impu_desc             out varchar2,
                                 p_deta_prod_clco        out varchar2,
                                 p_imp_ind_baim_imp_incl out varchar2,
                                 p_impu_porc_base_impo   out varchar2,
                                 p_impu_porc             out varchar2,
                                 p_MOCO_CONC_CODI_IMPU   out varchar2,
                                 p_ortr_desc             out varchar2,
                                 p_moco_impu_codi        in out varchar2) is
  begin
  
    if p_indi_prod_ortr = 'P' then
      if p_prod_codi_alfa <> p_prod_codi_alfa_orig then
        raise_application_error(-20001,
                                'No se puede modificar el producto.');
        p_prod_codi_alfa := p_prod_codi_alfa_orig;
      end if;
    
   
      begin
        -- Call the procedure
        I020012.pp_traer_desc_prod(p_prod_codi_alfa,
                                   p_movi_dbcr,
                                   p_s_timo_calc_iva,
                                   p_movi_oper_codi,
                                   p_deta_prod_codi,
                                   p_moco_conc_codi,
                                   p_s_producto_desc,
                                   p_impu_desc,
                                   p_deta_prod_clco,
                                   p_imp_ind_baim_imp_incl,
                                   p_impu_porc_base_impo,
                                   p_impu_porc,
                                   p_MOCO_CONC_CODI_IMPU,
                                   p_moco_impu_codi);
      end;
      p_ortr_desc := null;
    
    elsif p_indi_prod_ortr = 'O' then
      p_moco_impu_codi := parameter.p_codi_impu_ortr;
      if nvl(p_clpr_indi_exen, 'N') = 'S' then
        p_moco_impu_codi := parameter.p_codi_impu_exen;
      end if;
      if p_prod_codi_alfa <> p_prod_codi_alfa_orig then
        raise_application_error(-20001,
                                'No se puede modificar la Orden de Trabajo.');
        p_prod_codi_alfa := p_prod_codi_alfa_orig;
      end if;
    
      -- pp_mostrar_ot;   
      I020012.pp_mostrar_ot(p_prod_codi_alfa,
                            p_movi_oper_codi,
                            P_movi_mone_codi,
                            P_movi_tasa_mone,
                            P_movi_mone_cant_deci,
                            p_movi_clpr_codi,
                            p_deta_prec_unit,
                            p_moco_conc_codi,
                            p_moco_dbcr,
                            p_deta_prod_codi,
                            p_deta_prod_clco,
                            p_s_producto_desc);
    
    elsif p_indi_prod_ortr = 'S' then
      

      if p_ortr_desc is null and p_s_item = 'X' then
      
        pp_traer_desc_conce(p_prod_codi_alfa,
                            p_movi_dbcr,
                            p_ortr_desc,
                            p_moco_impu_codi);
      
      end if;
      
      
      p_deta_prod_codi  := p_prod_codi_alfa;
      p_s_producto_desc := p_ortr_desc;
   
     
      if nvl(p_clpr_indi_exen, 'N') = 'S' then
        p_moco_impu_codi := parameter.p_codi_impu_exen;
      end if;
    end if;
    
  end pp_validar_prod_conp;

  procedure pp_calcular_importe_cab(p_movi_timo_indi_sald in varchar2,
                                    p_movi_tasa_mone      in number,
                                    p_movi_mone_cant_deci in number,
                                    P_movi_grav10_ii_mone out number,
                                    P_movi_grav5_ii_mone  out number,
                                    P_movi_exen_mone      out number,
                                    p_movi_impo_mone_ii   out number,
                                    p_s_total             out number,
                                    p_movi_grav10_ii_mmnn out number,
                                    p_movi_grav5_ii_mmnn  out number,
                                    p_movi_exen_mmnn      out number,
                                    p_movi_iva10_mone     out number,
                                    p_movi_iva5_mone      out number,
                                    p_s_iva_10            out number,
                                    p_s_iva_5             out number,
                                    p_s_tot_iva           out number,
                                    p_movi_iva10_mmnn     out number,
                                    p_movi_iva5_mmnn      out number,
                                    p_movi_grav10_mone    out number,
                                    p_movi_grav5_mone     out number,
                                    p_movi_grav10_mmnn    out number,
                                    p_movi_grav5_mmnn     out number,
                                    p_movi_impo_mmnn_ii   out number,
                                    p_movi_grav_mone      out number,
                                    p_movi_iva_mone       out number,
                                    p_movi_grav_mmnn      out number,
                                    p_movi_sald_mone      out number,
                                    p_movi_sald_mmnn      out number,
                                    p_movi_iva_mmnn       out number) is
  
    V_s_exen       NUMBER;
    V_s_grav_10_ii NUMBER;
    V_s_grav_5_ii  NUMBER;
    v_movi_tasa_mone number;
  Begin
  
    select sum(c029) moco_grav10_ii_mone,
           sum(c031) moco_grav5_ii_mone,
           sum(c042) moco_exen_mone
      INTO V_s_grav_10_ii, V_s_grav_5_ii, V_s_exen
    
      from apex_collections a
     where collection_name = 'BDETALLE'
       and c001 = 'X';
  
    setitem('P128_S_EXEN', V_s_exen);
    setitem('P128_S_GRAV_5_II', V_s_grav_5_ii);
    setitem('P128_S_GRAV_10_II', V_s_grav_10_ii);
  
    P_movi_grav10_ii_mone := V_s_grav_10_ii;
    P_movi_grav5_ii_mone  := V_s_grav_5_ii;
    P_movi_exen_mone      := V_s_exen;
  
    p_movi_impo_mone_ii := p_movi_grav10_ii_mone + p_movi_grav5_ii_mone +
                           p_movi_exen_mone;
    p_s_total           := p_movi_impo_mone_ii;
    
    ----buscar tasa en caso de que el parametro este nulo
    if p_movi_tasa_mone is null then
    I020012.pp_busca_tasa_mone(v('p128_movi_mone_codi'), v('p128_s_movi_fech_emis'), v_movi_tasa_mone, v('p128_movi_tica_codi'));

   end if;
    ---importe iva incluido en mmnn
  
    p_movi_grav10_ii_mmnn := round((p_movi_grav10_ii_mone *
                                   nvl(p_movi_tasa_mone,v_movi_tasa_mone)),
                                   parameter.p_cant_deci_mmnn);
    p_movi_grav5_ii_mmnn  := round((p_movi_grav5_ii_mone *  nvl(p_movi_tasa_mone,v_movi_tasa_mone)),
                                   parameter.p_cant_deci_mmnn);
                                   
    p_movi_exen_mmnn      := round((p_movi_exen_mone *  nvl(p_movi_tasa_mone,v_movi_tasa_mone)),
                                   parameter.p_cant_deci_mmnn);
                                  
   -- raise_application_error(-20001,V_s_exen||' power '||p_movi_exen_mmnn);
  
    p_movi_iva10_mone := round((p_movi_grav10_ii_mone / 11),
                               p_movi_mone_cant_deci);
    p_movi_iva5_mone  := round((p_movi_grav5_ii_mone / 21),
                               p_movi_mone_cant_deci);
  
    p_s_iva_10  := p_movi_iva10_mone;
    p_s_iva_5   := p_movi_iva5_mone;
    p_s_tot_iva := p_movi_iva10_mone + p_movi_iva5_mone;
  
    p_movi_iva10_mmnn := round((p_movi_grav10_ii_mmnn / 11),
                               parameter.p_cant_deci_mmnn);
    p_movi_iva5_mmnn  := round((p_movi_grav5_ii_mmnn / 21),
                               parameter.p_cant_deci_mmnn);
  
    p_movi_grav10_mone := round((p_movi_grav10_ii_mone / 1.1),
                                p_movi_mone_cant_deci);
    p_movi_grav5_mone  := round((p_movi_grav5_ii_mone / 1.05),
                                p_movi_mone_cant_deci);
  
    p_movi_grav10_mmnn := round((p_movi_grav10_ii_mmnn / 1.1),
                                parameter.p_cant_deci_mmnn);
    p_movi_grav5_mmnn  := round((p_movi_grav5_ii_mmnn / 1.05),
                                parameter.p_cant_deci_mmnn);
  
    p_movi_impo_mmnn_ii := p_movi_grav10_ii_mmnn + p_movi_grav5_ii_mmnn +
                           p_movi_exen_mmnn;
  
    --importes netos
    p_movi_grav_mone := p_movi_grav10_mone + p_movi_grav5_mone;
    p_movi_iva_mone  := p_movi_iva10_mone + p_movi_iva5_mone;
  
    p_movi_grav_mmnn := p_movi_grav10_mmnn + p_movi_grav5_mmnn;
    p_movi_iva_mmnn  := p_movi_iva10_mmnn + p_movi_iva5_mmnn;
  
    --saldo 
    if nvl(p_movi_timo_indi_sald, 'N') = 'N' then
      -- si no afecta el saldo del cliente o proveedor
      p_movi_sald_mone := 0;
      p_movi_sald_mmnn := 0;
    else
      p_movi_sald_mone := p_movi_impo_mone_ii;
      p_movi_sald_mmnn := p_movi_impo_mmnn_ii;
    end if;
  
  end pp_calcular_importe_cab;
  
  
  
  PROCEDURE pp_mostrar_codi_barr(P_deta_prod_codi_barr in number,
                                 P_deta_prod_codi in number,
                                 P_coba_fact_conv out number,
                                 P_moco_medi_codi out number) IS
  v_prod_codi number;
BEGIN

  select coba_prod_codi, coba_medi_codi, /*coba_Desc,*/ coba_fact_conv
    into v_prod_codi, P_moco_medi_codi,/* P_coba_desc,*/ P_coba_fact_conv
    from come_prod_coba_deta
   where COBA_CODI_BARR = P_deta_prod_codi_barr;

  if v_prod_codi <> P_deta_prod_codi then
    raise_application_error(-20001,
                            'El Codigo de barras no pertenece al producto seleecionado');
  end if;

exception
  When no_data_found then
    raise_application_error(-20001, 'Debe seleccionar el Codigo de barras');
  When too_many_rows then
    raise_application_error(-20001,
                            'Existe mas de un item con el codigo de barras');
  
END pp_mostrar_codi_barr;



procedure pp_mostrar_medi (p_codi in number,
                           p_deta_prod_codi in number,
                           p_desc out varchar2) is
begin  
         
  select ltrim(rtrim(medi_desc_abre)) 
    into p_desc
    from come_unid_medi
   where medi_codi= p_codi
     and medi_codi in ( select coba_medi_codi 
                          from come_prod_coba_deta
                         where coba_prod_codi=p_deta_prod_codi);   

exception
   when no_data_found then
      p_desc := 'Unidad de medida inexistente para el producto seleccionado!';
   when others then
      raise_application_error(-20001,sqlerrm);   
end pp_mostrar_medi;




  procedure pp_validaciones is
    v_indi_item varchar2(1);
    v_indi_prod varchar2(1);
    v_conc_dbcr varchar2(1);
  begin

    
    if bcab.movi_tasa_mone is null then
      raise_application_error(-20001,
                              'Debe indicar al tasa de moneda para realizar la Nota de Cr?dito.');
    end if;
  
    if nvl(parameter.p_obli_fact_emit, 'N') = 'S' then
      if bcab1.s_movi_nume_fact is null then
        raise_application_error(-20001, 'Debe ingresar la Factura Emitida.');
      end if;
    end if;
    
    
    if bcab.movi_afec_sald ='N' then
      if  bcab.movi_cuen_codi is null then
         raise_application_error(-20001, 'Debe ingresar Cuenta Bancaria.');
        end if;
      end if; 
  
  if bcab.movi_depo_codi_orig is null then
     raise_application_error(-20001, 'Debe ingresar el codigo del Deposito.');
    end if;
    v_indi_item := 'N';
    v_indi_prod := 'N';
    for bdet in c loop
      if bdet.s_item is not null then
        v_indi_item := 'S';
      
        if bdet.indi_prod_ortr = 'P' and bdet.moco_medi_codi is null then
          raise_application_error(-20001,
                                  'El producto no posee unidad de medida,favor verifique!!');
        end if;
        if bdet.indi_prod_ortr is not null and bdet.moco_cant_medi is null then
          raise_application_error(-20001,
                                  'El producto no posee cantidad,favor verifique!!');
        end if;
        if bdet.indi_prod_ortr is not null and bdet.deta_prec_unit is null then
          raise_application_error(-20001,
                                  'El producto no posee precio unitario,favor verifique!!');
        end if;
        if bdet.indi_prod_ortr is not null and
           (bdet.moco_impo_mone_ii is null or bdet.moco_impo_mone_ii <= 0) then
          raise_application_error(-20001,
                                  'El debe ingresar el total del producto,favor verifique!!'||bdet.moco_impo_mone_ii);
        end if;
      
        begin
          select conc_dbcr
            into v_conc_dbcr
            from come_conc
           where conc_codi = bdet.moco_conc_codi;
        
          if v_conc_dbcr = 'D' and bcab.movi_dbcr = 'C' then
            raise_application_error(-20001,
                                    'Debe ingresar un concepto de tipo Egreso ');
          elsif v_conc_dbcr = 'C' and bcab.movi_dbcr = 'D' then
            raise_application_error(-20001,
                                    'Debe ingresar un concepto de tipo ingreso ');
          end if;
        exception
          when no_data_found then
            null;
        end;
      
      end if;
    
      if bdet.indi_prod_ortr is not null then
        v_indi_prod := 'S';
      end if;
    
    end loop;
  
    if v_indi_item = 'N' then
      raise_application_error(-20001,
                              'Debe indicar al menos un item para realizar la Nota de Credito ');
    end if;
    if v_indi_prod = 'N' then
      raise_application_error(-20001,
                              'Debe indicar al menos un Producto,Orden o Servicio para realizar la Nota de Cr?dito');
    end if;
    
    
  
  end pp_validaciones;

  procedure pp_valida_nume_fact is
    v_count   number;
    v_message varchar2(1000) := 'Nro de Comprobante Existente!!!!! , favor verifique!!';
    salir     exception;
  begin
  
    select count(*)
      into v_count
      from come_movi, come_tipo_movi, come_tipo_comp
     where movi_timo_codi = timo_codi
       and timo_tico_codi = tico_codi(+)
       and movi_nume = bcab.movi_nume
       and timo_tico_codi = bcab1.timo_tico_codi
       and nvl(tico_indi_vali_nume, 'N') = 'S'
       AND NVL(MOVI_NUME_TIMB, '0') = BCAB.MOVI_NUME_TIMB;
  
    if v_count > 0 then
      raise_application_error(-20001, v_message);
    end if;
  
  exception
    when salir then
      raise_application_error(-20001, 'Reingrese el nro de comprobante');
  end pp_valida_nume_fact;

  procedure pp_validar_importes is
  begin
  
    if nvl(bcab1.s_total, 0) <> 
       bcab1.SUM_MOCO_IMPO_MONE_II then
      raise_application_error(-20001,
                              'El Importe total de cabecera en la Nota de Credito debe ser igual al total de items en el detalle,favor verifique!!');
    else
      if bcab1.s_total <= 0 then
        raise_application_error(-20001,
                                'El Importe total de cabecera en la Nota de Creditod debe ser mayor a 0 ,favor verifique!!');
      end if;
    end if;
  End pp_validar_importes;

  procedure pp_veri_nume(p_nume in out number, p_tico_codi in number) is
    v_nume number;
  Begin
    v_nume := p_nume;
  
    if nvl(bcab1.tico_indi_vali_nume, 'N') = 'S' then
    
      loop
        begin
          select movi_nume
            into v_nume
            from come_movi, come_tipo_movi
           where movi_timo_codi = timo_codi
             and movi_nume = v_nume
             AND NVL(MOVI_NUME_TIMB, '0') = NVL(BCAB.MOVI_NUME_TIMB, '0')
             and timo_tico_codi = p_tico_codi;
        
          v_nume := v_nume + 1;
        Exception
          when no_data_found then
            exit;
          when too_many_rows then
            v_nume := v_nume + 1;
        end;
      end loop;
    end if;
    p_nume := v_nume;
  end pp_veri_nume;

  PROCEDURE pp_veri_nume_dife(p_movi_nume in number) IS
    v_count number := 0;
  BEGIN
    if nvl(bcab1.tico_indi_vali_nume, 'N') = 'S' then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi
       where movi_nume = p_movi_nume
         and movi_timo_codi = timo_codi
         AND NVL(MOVI_NUME_TIMB, '0') = NVL(BCAB.MOVI_NUME_TIMB, '0')
         and timo_tico_codi = bcab1.timo_tico_codi;
    
    end if;
    if v_count > 0 then
      raise_application_error(-20001,
                              'Numero de comprobante ya existe. Favor verifique!');
    end if;
  END pp_veri_nume_dife;

  procedure pp_mostrar_oper_stoc(p_oper_codi      in number,
                                 p_suma_rest      out char,
                                 p_afec_cost_prom out char) is
  begin
    select oper_stoc_suma_rest, oper_stoc_afec_cost_prom
      into p_suma_rest, p_afec_cost_prom
      from come_stoc_oper
     where oper_codi = p_oper_codi;
  
  Exception
    when no_data_found then
      p_suma_rest := null;
      raise_application_error(-20001, 'Operacion de Stock inexistente!');
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_mostrar_oper_stoc;

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
      raise_application_error(-20001,
                              'Concepto de producto no encontrado!');
    
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_busca_conce_prod;

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
    v_movi_nume_timb      varchar2(20);
    v_movi_fech_venc_timb date;
    v_movi_fech_inic_timb date;
    v_movi_nume_auto_impr number(20);
  
    v_movi_fech_oper date;
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
    v_movi_fact_codi           number;
    v_movi_nota_devu_codi      number;
    v_movi_clpr_sucu_nume_item number;
    v_movi_codi_rete           number;
    v_movi_excl_cont           varchar2(1);
    v_movi_estado_fact         varchar2(1);
  begin
  
    --- asignar valores....
  
    bcab.movi_codi      := fa_sec_come_movi;
    bcab.movi_oper_codi := parameter.p_codi_oper;
    bcab.movi_fech_grab := sysdate;
    bcab.movi_user      := fa_user;
    pp_mostrar_oper_stoc(parameter.p_codi_oper,
                         bcab.movi_stoc_suma_rest,
                         bcab.movi_stoc_afec_cost_prom);
  
    v_movi_codi      := bcab.movi_codi;
    v_movi_timo_codi := bcab.movi_timo_codi;
    v_movi_clpr_codi := bcab.movi_clpr_codi;
  
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig := bcab.movi_depo_codi_orig;
    v_movi_sucu_codi_dest := null;
    v_movi_depo_codi_dest := null;
    --------------------------------------------------------------------
  
    v_movi_oper_codi := parameter.p_codi_oper;
  
    v_movi_cuen_codi           := bcab.movi_cuen_codi;
    v_movi_mone_codi           := bcab.movi_mone_codi;
    v_movi_nume                := bcab.movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := bcab.movi_fech_grab;
    v_movi_user                := bcab.movi_user;
    v_movi_codi_padr           := null;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := bcab.movi_tasa_mmee;
    v_movi_grav_mmnn           := bcab.movi_grav_mmnn;
    v_movi_iva_mmnn            := bcab.movi_iva_mmnn;
    v_movi_exen_mmnn           := bcab.movi_exen_mmnn;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := bcab.movi_grav_mone;
    v_movi_iva_mone            := bcab.movi_iva_mone;
    v_movi_exen_mone           := bcab.movi_exen_mone;
    v_movi_obse                := bcab.movi_obse;
    v_movi_sald_mmnn           := bcab.movi_impo_mmnn_ii;
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := bcab.movi_impo_mone_ii;
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
  

    v_movi_nume_timb      := bcab.movi_nume_timb;
    v_movi_fech_venc_timb := bcab1.fech_venc_timb;
    v_movi_fech_inic_timb := bcab1.fech_inic_timb;
    v_movi_nume_auto_impr := bcab.movi_nume_auto_impr;
  
  
    v_movi_impo_mone_ii   := bcab.movi_impo_mone_ii;
    v_movi_impo_mmnn_ii   := bcab.movi_impo_mmnn_ii;
    v_movi_grav10_ii_mone := bcab.movi_grav10_ii_mone;
    v_movi_grav5_ii_mone  := bcab.movi_grav5_ii_mone;
    v_movi_grav10_ii_mmnn := bcab.movi_grav10_ii_mmnn;
    v_movi_grav5_ii_mmnn  := bcab.movi_grav5_ii_mmnn;
    v_movi_grav10_mone    := bcab.movi_grav10_mone;
    v_movi_grav5_mone     := bcab.movi_grav5_mone;
    v_movi_grav10_mmnn    := bcab.movi_grav10_mmnn;
    v_movi_grav5_mmnn     := bcab.movi_grav5_mmnn;
    v_movi_iva10_mone     := bcab.movi_iva10_mone;
    v_movi_iva5_mone      := bcab.movi_iva5_mone;
    v_movi_iva10_mmnn     := bcab.movi_iva10_mmnn;
    v_movi_iva5_mmnn      := bcab.movi_iva5_mmnn;
  
    v_movi_fact_codi      := bcab1.s_movi_codi_fact;
    v_movi_nota_devu_codi := bcab1.movi_node_codi;
  
    v_movi_clpr_sucu_nume_item := bcab.movi_clpr_sucu_nume_item;
    v_movi_estado_fact         := 'S';
  
    if v_movi_clpr_sucu_nume_item = 0 then
      --la subcuenta cero nada mas es para filtrar.
      v_movi_clpr_sucu_nume_item := null;
    end if;
 -- raise_application_error(-20001,'pasa aca '||v_movi_nume_timb);
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
                        v_movi_fech_inic_timb,
                        v_movi_nume_auto_impr,
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
                        v_movi_fact_codi,
                        v_movi_nota_devu_codi,
                        v_movi_estado_fact);
  
    --  env_fact_sifen.pp_get_json_fact(v_movi_codi);
  end pp_actualiza_come_movi;
  --------------------------------------------------------------------------------------------------------------

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
                                
                                p_movi_fech_inic_timb in date,
                                p_movi_nume_auto_impr in number,
                                
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
                                p_movi_fact_codi           in number,
                                p_movi_nota_devu_codi      in number,
                                p_movi_estado_fac          in varchar2) is
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
       movi_fech_inic_timb,
       movi_nume_auto_impr,
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
       movi_fact_codi,
       movi_nota_devu_codi,
       movi_estado_fac_elec)
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
       p_movi_fech_inic_timb,
       p_movi_nume_auto_impr,
       
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
       p_movi_fact_codi,
       p_movi_nota_devu_codi,
       p_movi_estado_fac);
  
  Exception
    when others then
      raise_application_Error(-20001, sqlerrm);
  end pp_insert_come_movi;

  procedure pp_actualiza_come_movi_prod is
    v_deta_movi_codi         number;
    v_MOCO_NUME_ITEM         number;
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
    v_deta_NUME_ITEM_padr    number;
    v_deta_impo_mone_deto_nc number;
    v_deta_movi_codi_deto_nc number;
    v_deta_list_codi         number;
    v_deta_medi_codi         number;
    v_deta_cant_medi         number;
  
    v_deta_impo_mone_ii   number;
    v_deta_impo_mmnn_ii   number;
    v_deta_grav10_ii_mone number;
    v_deta_grav5_ii_mone  number;
    v_deta_grav10_ii_mmnn number;
    v_deta_grav5_ii_mmnn  number;
    v_deta_grav10_mone    number;
    v_deta_grav5_mone     number;
    v_deta_grav10_mmnn    number;
    v_deta_grav5_mmnn     number;
    v_deta_iva10_mone     number;
    v_deta_iva5_mone      number;
    v_deta_iva10_mmnn     number;
    v_deta_iva5_mmnn      number;
    v_deta_exen_mone      number;
    v_deta_exen_mmnn      number;
  
    v_deta_lote_codi number;
  
    v_DETA_PROD_CODI_BARR varchar2(30);
    v_deta_indi_venc      varchar2(1);
  begin
    v_deta_movi_codi := bcab.movi_codi;
    v_MOCO_NUME_ITEM := 0;
    for bdet in c loop
      if bdet.s_item = 'X' then
        v_MOCO_NUME_ITEM         := v_MOCO_NUME_ITEM + 1;
        v_deta_impu_codi         := bdet.moco_impu_codi;
        v_deta_prod_codi         := bdet.deta_prod_codi;
        v_deta_lote_codi         := bdet.deta_lote_codi;
        v_deta_cant              := bdet.moco_cant;
        v_deta_cant_medi         := bdet.moco_cant * bdet.coba_fact_conv;
        v_deta_obse              := null;
        v_deta_porc_deto         := bdet.moco_porc_deto;
        v_deta_impo_mone         := bdet.moco_impo_mone;
        v_deta_impo_mmnn         := bdet.moco_impo_mmnn;
        v_deta_impo_mmee         := bdet.moco_impo_mmee;
        v_deta_iva_mmnn          := bdet.moco_iva_mmnn;
        v_deta_iva_mmee          := bdet.moco_iva_mmee;
        v_deta_iva_mone          := bdet.moco_iva_mone;
        v_deta_prec_unit         := bdet.deta_prec_unit;
        v_deta_movi_codi_padr    := bdet.deta_movi_codi_padr;
        v_deta_NUME_ITEM_padr    := bdet.deta_NUME_ITEM_padr;
        v_deta_impo_mone_deto_nc := null;
        v_deta_movi_codi_deto_nc := null;
        v_deta_list_codi         := null;
        v_deta_medi_codi         := bdet.moco_medi_codi;
      
        v_DETA_PROD_CODI_BARR := bdet.DETA_PROD_CODI_BARR;
      
        v_deta_impo_mone_ii   := bdet.moco_impo_mone_ii;
        v_deta_impo_mmnn_ii   := bdet.moco_impo_mmnn_ii;
        v_deta_grav10_ii_mone := bdet.moco_grav10_ii_mone;
        v_deta_grav5_ii_mone  := bdet.moco_grav5_ii_mone;
        v_deta_grav10_ii_mmnn := bdet.moco_grav10_ii_mmnn;
        v_deta_grav5_ii_mmnn  := bdet.moco_grav5_ii_mmnn;
        v_deta_grav10_mone    := bdet.moco_grav10_mone;
        v_deta_grav5_mone     := bdet.moco_grav5_mone;
        v_deta_grav10_mmnn    := bdet.moco_grav10_mmnn;
        v_deta_grav5_mmnn     := bdet.moco_grav5_mmnn;
        v_deta_iva10_mone     := bdet.moco_iva10_mone;
        v_deta_iva5_mone      := bdet.moco_iva5_mone;
        v_deta_iva10_mmnn     := bdet.moco_iva10_mmnn;
        v_deta_iva5_mmnn      := bdet.moco_iva5_mmnn;
        v_deta_exen_mone      := bdet.moco_exen_mone;
        v_deta_exen_mmnn      := bdet.moco_exen_mmnn;
      
        v_deta_indi_venc := nvl(bdet.indi_venc, 'N');
      
        if bdet.indi_prod_ortr = 'P' then
        
          insert into come_movi_prod_deta
            (deta_movi_codi,
             DETA_NUME_ITEM,
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
             DETA_NUME_ITEM_padr,
             deta_impo_mone_deto_nc,
             deta_movi_codi_deto_nc,
             deta_list_codi,
             deta_medi_codi,
             deta_cant_medi,
             deta_base,
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
             DETA_PROD_CODI_BARR,
             DETA_INDI_VENC,
             deta_lote_codi)
          values
            (v_deta_movi_codi,
             v_MOCO_NUME_ITEM,
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
             v_deta_NUME_ITEM_padr,
             v_deta_impo_mone_deto_nc,
             v_deta_movi_codi_deto_nc,
             v_deta_list_codi,
             v_deta_medi_codi,
             v_deta_cant_medi,
             parameter.p_codi_base,
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
             v_DETA_PROD_CODI_BARR,
             v_deta_indi_venc,
             v_Deta_lote_codi);
        
        elsif bdet.indi_prod_ortr = 'O' then
          pp_insert_come_movi_ortr_deta(v_deta_movi_codi,
                                        v_MOCO_NUME_ITEM,
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
                                        v_deta_NUME_ITEM_padr,
                                        v_deta_obse,
                                        v_deta_impo_mone_ii,
                                        v_deta_impo_mmnn_ii);
        end if;
      end if;
    
    end loop;
  end pp_actualiza_come_movi_prod;

  procedure pp_insert_come_movi_ortr_deta(p_deta_movi_codi      in number,
                                          p_MOCO_NUME_ITEM      in number,
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
                                          p_MOCO_NUME_ITEM_padr in number,
                                          p_deta_obse           in varchar2,
                                          p_deta_impo_mone_ii   in number,
                                          p_deta_impo_mmnn_ii   in number) is
  
  begin
    insert into come_movi_ortr_deta
      (deta_movi_codi,
       DETA_NUME_ITEM,
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
       DETA_NUME_ITEM_padr,
       deta_obse,
       deta_base,
       deta_impo_mone_ii,
       deta_impo_mmnn_ii)
    values
      (p_deta_movi_codi,
       p_MOCO_NUME_ITEM,
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
       p_MOCO_NUME_ITEM_padr,
       p_deta_obse,
       parameter.p_codi_base,
       p_deta_impo_mone_ii,
       p_deta_impo_mmnn_ii);
  
  exception
  
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

  procedure pp_actualiza_come_nota_devu(p_movi_codi      in number,
                                        p_node_esta      in varchar2,
                                        p_movi_node_codi in number) is
  begin
  
    update come_nota_devu
       set node_movi_codi = p_movi_codi, node_esta = p_node_esta
     where node_codi = p_movi_node_codi;
  
  end pp_actualiza_come_nota_devu;

  procedure pp_actualiza_come_movi_cuot is
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
  
    v_cuot_fech_venc := bcab.movi_fech_emis;
    v_cuot_nume      := 1;
    v_cuot_impo_mone := bcab1.s_total;
    v_cuot_impo_mmnn := round((bcab1.s_total * bcab.movi_tasa_mone),
                              parameter.p_cant_deci_mmnn);
    v_cuot_impo_mmee := null;
    v_cuot_sald_mone := v_cuot_impo_mone;
    v_cuot_sald_mmnn := v_cuot_impo_mmnn;
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
  
  end;

  --actualizar la tabla moimpo , efectivo, cheques dif, cheques dia, y vuelto (para el caso de las cobranzas) 
  procedure pp_actualiza_moimpo is
  
    v_moim_movi_codi number;
    v_moim_nume_item number := 0;
    v_moim_tipo      char(20);
    v_moim_cuen_codi number;
    v_moim_dbcr      char(1);
    v_moim_afec_caja char(1);
    v_moim_fech      date;
    v_moim_fech_oper date;
    v_moim_impo_mone number;
    v_moim_impo_mmnn number;
  
  begin
  
    if bcab1.movi_timo_indi_caja = 'S' then
      --solo si afecta a caja
      ---clientes -- mov. emitidos..
      if bcab.movi_emit_reci = 'E' then
        v_moim_movi_codi := bcab.movi_codi;
        v_moim_nume_item := v_moim_nume_item + 1;
        v_moim_tipo      := 'Efectivo';
        v_moim_cuen_codi := bcab.movi_cuen_codi;
        v_moim_dbcr      := bcab.movi_dbcr;
        v_moim_afec_caja := 'S';
        v_moim_fech      := bcab.movi_fech_emis;
        v_moim_fech_oper := bcab.movi_fech_emis;
        v_moim_impo_mone := bcab1.s_total;
        v_moim_impo_mmnn := round((bcab1.s_total * bcab.movi_tasa_mone),
                                  parameter.p_cant_deci_mmnn);
      
        pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                      v_moim_nume_item,
                                      v_moim_tipo,
                                      v_moim_cuen_codi,
                                      v_moim_dbcr,
                                      v_moim_afec_caja,
                                      v_moim_fech,
                                      v_moim_fech_oper,
                                      v_moim_impo_mone,
                                      v_moim_impo_mmnn);
      end if;
      --Proveedores.........  
      if bcab.movi_emit_reci = 'R' then
        v_moim_movi_codi := bcab.movi_codi;
        v_moim_nume_item := v_moim_nume_item + 1;
        v_moim_tipo      := 'Efectivo';
        v_moim_cuen_codi := bcab.movi_cuen_codi;
        v_moim_dbcr      := bcab.movi_dbcr;
        v_moim_afec_caja := 'S';
        v_moim_fech      := bcab.movi_fech_emis;
        v_moim_fech_oper := bcab.movi_fech_emis;
        v_moim_impo_mone := bcab1.s_total;
        v_moim_impo_mmnn := round((bcab1.s_total * bcab.movi_tasa_mone),
                                  parameter.p_cant_deci_mmnn);
      
        pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                      v_moim_nume_item,
                                      v_moim_tipo,
                                      v_moim_cuen_codi,
                                      v_moim_dbcr,
                                      v_moim_afec_caja,
                                      v_moim_fech,
                                      v_moim_fech_oper,
                                      v_moim_impo_mone,
                                      v_moim_impo_mmnn);
      end if;
    end if;
  end;

  procedure pp_insert_come_movi_impo_deta(p_moim_movi_codi in number,
                                          p_moim_nume_item in number,
                                          p_moim_tipo      in char,
                                          p_moim_cuen_codi in number,
                                          p_moim_dbcr      in char,
                                          p_moim_afec_caja in char,
                                          p_moim_fech      in date,
                                          p_moim_fech_oper in date,
                                          p_moim_impo_mone in number,
                                          p_moim_impo_mmnn in number) is
  begin
    insert into come_movi_impo_deta
      (moim_movi_codi,
       moim_nume_item,
       moim_tipo,
       moim_cuen_codi,
       moim_dbcr,
       moim_afec_caja,
       moim_fech,
       moim_fech_oper,
       moim_impo_mone,
       moim_impo_mmnn,
       moim_base)
    values
      (
       
       p_moim_movi_codi,
       p_moim_nume_item,
       p_moim_tipo,
       p_moim_cuen_codi,
       p_moim_dbcr,
       p_moim_afec_caja,
       p_moim_fech,
       p_moim_fech_oper,
       p_moim_impo_mone,
       p_moim_impo_mmnn,
       parameter.p_codi_base);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_come_movi_impo_deta;

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

  procedure pp_actualiza_moco is
    v_moco_movi_codi      number;
    v_moco_nume_item      number;
    v_moco_conc_codi      number;
    v_moco_cuco_codi      number;
    v_moco_impu_codi      number;
    v_moco_impo_mmnn      number;
    v_moco_impo_mmee      number;
    v_moco_impo_mone      number;
    v_moco_dbcr           char(1);
    v_moco_desc           varchar(500);
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
    v_moco_base           number(2);
    v_moco_tiim_codi      number(10);
    v_moco_ortr_codi      number(20);
    v_moco_impo_codi      number(20);
    v_moco_cant_pulg      number(20, 4);
    v_moco_movi_codi_padr number(20);
    v_moco_nume_item_padr number(10);
    v_moco_ceco_codi      number(20);
    v_moco_orse_codi      number(20);
    v_moco_tran_codi      number(20);
    v_moco_bien_codi      number(20);
    v_moco_emse_codi      number(4);
    v_moco_tipo_item      varchar2(2);
    v_moco_clpr_codi      number(20);
    v_moco_prod_nume_item number(20);
    v_moco_guia_nume      number(20);
    v_moco_empl_codi      number(10);
    v_moco_lote_codi      number(10);
    v_moco_bene_codi      number(4);
    v_moco_medi_codi      number(10);
    v_moco_cant_medi      number(20, 4);
    v_moco_anex_codi      number(20);
    v_moco_indi_excl_cont varchar2(1);
    v_moco_anex_nume_item number(10);
    v_moco_juri_codi      number(20);
  begin
    v_moco_movi_codi := bcab.movi_codi;
    v_moco_nume_item := 0;
    for bdet in c loop
      if bdet.S_ITEM = 'X' then
    
    
        if bdet.indi_prod_ortr = 'P' then
         -- raise_application_error(-20001 ,bdet.moco_conc_codi);
           pp_busca_conce_prod( bdet.deta_prod_clco,
                        bcab.movi_oper_codi,
                        v_moco_conc_codi,
                        v_moco_dbcr);
          v_moco_conc_codi      := bdet.moco_conc_codi;
          --v_moco_dbcr           := bdet.moco_dbcr;
          v_moco_indi_fact_serv := 'N';
          v_moco_desc           := null;
          v_moco_tipo           := 'P';
          v_moco_prod_codi      := bdet.deta_prod_codi;
          v_moco_ortr_codi_fact := null;
          v_moco_sofa_sose_codi := null;
          v_moco_sofa_nume_item := null;
        elsif bdet.indi_prod_ortr = 'O' then
          v_moco_indi_fact_serv := 'N';
          v_moco_desc           := null;
          v_moco_tipo           := 'O';
          v_moco_prod_codi      := null;
          v_moco_ortr_codi_fact := bdet.deta_prod_codi;
          v_moco_sofa_sose_codi := null;
          v_moco_sofa_nume_item := null;
        
          v_moco_conc_codi := bdet.moco_conc_codi;
          --v_moco_dbcr      := bdet.moco_dbcr;
        
        elsif bdet.indi_prod_ortr = 'C' then
          pp_busca_conce_prod(bdet.deta_prod_clco,
                              bcab.movi_oper_codi,
                              v_moco_conc_codi,
                              v_moco_dbcr);
        
          v_moco_indi_fact_serv := 'N';
          v_moco_desc           := nvl( bdet.ortr_desc,bdet.s_producto_desc);
          v_moco_tipo           := 'C';
          v_moco_prod_codi      := null;
          v_moco_ortr_codi_fact := null;
          v_moco_sofa_sose_codi := bdet.deta_prod_codi;
          v_moco_sofa_nume_item := bdet.sofa_nume_item;
        elsif bdet.indi_prod_ortr = 'S' then
          -- si es servicio
          v_moco_conc_codi      := bdet.prod_codi_alfa;
          v_moco_dbcr           := 'D';
          v_moco_indi_fact_serv := 'S';
          v_moco_desc           := nvl( bdet.ortr_desc,bdet.s_producto_desc);
          v_moco_tipo           := 'C';
          v_moco_prod_codi      := null;
          v_moco_ortr_codi_fact := null;
          v_moco_sofa_sose_codi := null;
          v_moco_sofa_nume_item := null;
        else
          raise_application_error(-20001,
                                  'Error al recuperar el tipo de Item');
        end if;
      
        if bdet.w_movi_codi_cabe is not null then
          v_moco_movi_codi := bdet.w_movi_codi_cabe;
          if nvl(v_moco_movi_codi_ante, 0) <> v_moco_movi_codi then
            v_moco_nume_item      := 0;
            v_moco_movi_codi_ante := v_moco_movi_codi;
          end if;
        end if;
     
        v_moco_base           := parameter.p_codi_base;
        v_moco_nume_item      := v_moco_nume_item + 1;
        v_moco_cuco_codi      := null;
        v_moco_impu_codi      := bdet.moco_impu_codi;
        v_moco_impo_mmnn      := (bdet.moco_impo_mmnn);
        v_moco_impo_mmee      := 0;
        v_moco_impo_mone      := (bdet.moco_impo_mone);
        v_moco_impo_mone_ii   := bdet.moco_impo_mone_ii;
        v_moco_cant           := bdet.moco_cant_medi;
        v_moco_impo_mmnn_ii   := bdet.moco_impo_mmnn_ii;
        v_moco_grav10_ii_mone := bdet.moco_grav10_ii_mone;
        v_moco_grav5_ii_mone  := bdet.moco_grav5_ii_mone; --:bdet.moco_grav5_mone_ii;
        v_moco_grav10_ii_mmnn := bdet.moco_grav10_ii_mmnn;
        v_moco_grav5_ii_mmnn  := bdet.moco_grav5_ii_mmnn;
        v_moco_grav10_mone    := bdet.moco_grav10_mone;
        v_moco_grav5_mone     := bdet.moco_grav5_mone;
        v_moco_grav10_mmnn    := bdet.moco_grav10_mmnn;
        v_moco_grav5_mmnn     := bdet.moco_grav5_mmnn;
        v_moco_iva10_mone     := bdet.moco_iva10_mone;
        v_moco_iva5_mone      := bdet.moco_iva5_mone;
        v_moco_iva10_mmnn     := bdet.moco_iva10_mmnn;
        v_moco_iva5_mmnn      := bdet.moco_iva5_mmnn;
        v_moco_exen_mone      := bdet.moco_exen_mone;
        v_moco_exen_mmnn      := bdet.moco_exen_mmnn;
      
        v_moco_conc_codi_impu := bdet.moco_conc_codi_impu;
        
      --  raise_application_error(-20001,bdet.moco_impo_mone);
      
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
                                 v_moco_indi_excl_cont,
                                 v_moco_anex_nume_item,
                                 v_moco_juri_codi);
      
      end if;
    end loop;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

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
  
  end;
  procedure pp_actu_secu(p_indi in varchar2) is
  begin
  
    if p_indi = 'S' then
      if rtrim(ltrim(parameter.p_emit_reci)) = 'E' then
      
        update come_secu
           set secu_nume_nota_cred = bcab.movi_nume
         where secu_codi =
                 (select f.user_secu_codi
                          from segu_user f
                         where user_login = fa_user);
      
      end if;
    end if;
  end pp_actu_secu;

  procedure pp_actualiza_moimpu is
  
    cursor c_movi_conc(p_movi_codi in number) is
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
         and a.moco_movi_codi = p_movi_codi
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
    v_moim_exen_mone      number := 0;
    v_moim_exen_mmnn      number := 0;
    v_moim_impo_mmnn number(20, 4);
    v_moim_impu_mmnn number(20, 4);
    v_moim_impu_mmee number(20, 4);
    v_moim_impo_mone number(20, 4);
    v_moim_impu_mone number(20, 4);
    v_moim_base      number(2);
    v_moim_tiim_codi number(10);
    v_moim_impo_mmee number(20, 4);
  
  Begin
    for x in c_movi_conc(bcab.movi_codi) loop
      v_impoii_mmnn         := x.moco_impo_mmnn_ii;
      v_impoii_mmee         := x.moco_impo_mmee;
      v_impoii_mone         := x.moco_impo_mone_ii;
      v_impo_grav           := x.moco_grav10_mone + x.moco_grav5_mone;
      v_impo_iva            := x.moco_iva10_mone + x.moco_iva5_mone;
      v_impo_exen           := x.moco_impo_mone_ii -
                               (v_impo_grav + v_impo_iva);
      v_moim_impo_mmee      := 0;
      v_moim_impu_mmee      := 0;
      v_moim_impo_mone      := v_impo_grav + v_impo_exen;
      v_moim_impu_mone      := v_impo_iva;
      v_moim_impu_mmnn      := x.moco_iva10_mmnn + x.moco_iva5_mmnn;
      v_moim_impo_mmnn      := x.moco_impo_mmnn_ii - v_moim_impu_mmnn;
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
  end;
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
  
  end;

  procedure pp_actualiza_canc is
    --insertar los recibos de cancelaciones
    --Cancelacion de la NC/Adel..................
    --Cancelacion de la Factura/Nota de Debito....
    v_movi_codi           number;
    v_movi_timo_codi      number;
    v_movi_timo_desc      varchar2(60);
    v_movi_timo_desc_abre varchar2(10);
    v_movi_clpr_codi      number;
    v_movi_sucu_codi_orig number;
    v_movi_mone_codi      number;
    v_movi_nume           number;
    v_movi_fech_emis      date;
    v_movi_fech_grab      date;
    v_movi_user           char(20);
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
    v_movi_clpr_desc      char(80);
    v_movi_emit_reci      char(1);
    v_movi_afec_sald      char(1);
    v_movi_dbcr           char(1);
    v_movi_empr_codi      number;
    v_movi_nume_timb      varchar2(20);
    v_movi_fech_venc_timb date;
    v_movi_impo_mone_ii   number;
    v_movi_impo_mmnn_ii   number;
    v_movi_grav10_ii_mone number;
    v_movi_grav5_ii_mone  number;
    v_movi_grav10_ii_mmnn number;
    v_movi_grav5_ii_mmnn  number;
    v_movi_grav10_mone    number;
    v_movi_grav5_mone     number;
    v_movi_grav10_mmnn    number;
    v_movi_grav5_mmnn     number;
    v_movi_iva10_mone     number;
    v_movi_iva5_mone      number;
    v_movi_iva10_mmnn     number;
    v_movi_iva5_mmnn      number;
    v_movi_fact_codi      number;
    v_movi_nota_devu_codi number;
  
    v_movi_depo_codi_orig number;
    v_movi_sucu_codi_dest number;
    v_movi_depo_codi_dest number;
    v_movi_oper_codi      number;
    v_movi_cuen_codi      number;
    v_movi_obse           varchar2(2000);
  
    v_movi_sald_mmnn           number;
    v_movi_sald_mmee           number;
    v_movi_sald_mone           number;
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(80);
    v_movi_clpr_tele           varchar2(80);
    v_movi_clpr_ruc            varchar2(80);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           number;
    v_movi_fech_oper           date;
    v_movi_excl_cont           varchar2(1);
    v_movi_clpr_sucu_nume_item number;
  
    --variables para come_movi_cuot_canc...
    v_canc_movi_codi      number;
    v_canc_cuot_movi_codi number;
    v_canc_cuot_fech_venc date;
    v_canc_fech_pago      date;
    v_canc_impo_mone      number;
    v_canc_impo_mmnn      number;
    v_canc_impo_mmee      number;
    v_canc_impo_dife_camb number := 0;
    v_movi_codi_rete      number;
  
    cursor c_movi_cuot(p_movi_codi in number) is
      select cuot_movi_codi, cuot_fech_venc, cuot_sald_mone
        from come_movi_cuot
       where cuot_movi_codi = p_movi_codi
         and cuot_sald_mone > 0
       order by cuot_fech_venc;
  
  
    v_sald_apli number;
  
    v_indi_adel char(1);
    v_indi_ncr  char(1);
  begin
    --  |------------------------------------------------------------|
    --  |-Insertar la cancelacion de la nota de Credito...|
    --  |------------------------------------------------------------|  
  
    --Determinar el Tipo de movimiento.......
    --Primero determinamos si el documento es emitido o Recibido...
  
    if parameter.p_emit_reci = 'E' then
      v_movi_timo_codi := parameter.p_codi_timo_cnncre; --es emitido
    else
      v_movi_timo_codi := parameter.p_codi_timo_cnncrr; --si es Recibido
    end if;
  
    pp_muestra_come_tipo_movi(v_movi_timo_codi,
                              v_movi_timo_desc,
                              v_movi_timo_desc_abre,
                              v_movi_afec_sald,
                              v_movi_dbcr,
                              v_indi_adel,
                              v_indi_ncr,
                              'N');
  
    -- saldo de la factura.
    if bcab1.s_movi_sald_mone > bcab1.SUM_MOCO_IMPO_MONE_II then
    
      v_movi_exen_mmnn := round((bcab1.SUM_MOCO_IMPO_MONE_II *
                                bcab.movi_tasa_mone),
                                parameter.p_cant_deci_mmnn);
      v_movi_exen_mone := nvl(bcab1.SUM_MOCO_IMPO_MONE_II, 0);
    else
      v_movi_exen_mmnn := round((bcab1.s_movi_sald_mone *
                                bcab.movi_tasa_mone),
                                parameter.p_cant_deci_mmnn);
      v_movi_exen_mone := bcab1.s_movi_sald_mone;
    end if;
  
    v_movi_codi           := fa_sec_come_movi;
    bcab1.movi_codi_apli  := v_movi_codi;
    v_movi_clpr_codi      := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    v_movi_mone_codi      := bcab.movi_mone_codi;
    v_movi_nume           := bcab.movi_nume;
    v_movi_fech_emis      := bcab.movi_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := fa_user;
    v_movi_codi_padr      := null;
    v_movi_tasa_mone      := bcab.movi_tasa_mone;
    v_movi_tasa_mmee      := 0;
    v_movi_grav_mmnn      := 0;
    v_movi_iva_mmnn       := 0;
    v_movi_grav_mmee      := 0;
    v_movi_exen_mmee      := 0;
    v_movi_iva_mmee       := 0;
    v_movi_grav_mone      := 0;
  
    v_movi_iva_mone       := 0;
    v_movi_clpr_desc      := bcab.movi_clpr_desc;
    v_movi_emit_reci      := parameter.p_emit_reci;
    v_movi_empr_codi      := bcab.movi_empr_codi;
    v_movi_fact_codi      := bcab1.s_movi_codi_fact;
    v_movi_nota_devu_codi := bcab1.movi_node_codi;
  
    v_movi_depo_codi_orig      := null;
    v_movi_clpr_sucu_nume_item := bcab.movi_clpr_sucu_nume_item;
  
    if v_movi_clpr_sucu_nume_item = 0 then
      --la subcuenta cero nada mas es para filtrar.
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
                        null,
                        null,
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
                        v_movi_fact_codi,
                        v_movi_nota_devu_codi,
                        null);
  
    --Obse. Las notas de creditos tendr?n siempre una sola cuota..
    --con fecha de vencimiento igual a la fecha del documento.................
  
    v_canc_movi_codi      := v_movi_codi; --clave del recibo de cn de nc
    v_canc_cuot_movi_codi := bcab.movi_codi; --clave de la nota de credito
    v_canc_cuot_fech_venc := bcab.movi_fech_emis; --fecha de venc. de la cuota de NC (= a la fecha de la nc)
    v_canc_fech_pago      := bcab.movi_fech_emis; --fecha de aplicacion de la cuota de NC (= a la fecha de la nc)
    v_canc_impo_mone      := v_movi_exen_mone; --siempre el importe de cancelacion ser? exento...
    v_canc_impo_mmnn      := v_movi_exen_mmnn;
    v_canc_impo_mmee      := v_movi_exen_mmee;
    v_canc_impo_dife_camb := 0;
  
    pp_insert_come_movi_cuot_canc(v_canc_movi_codi,
                                  v_canc_cuot_movi_codi,
                                  v_canc_cuot_fech_venc,
                                  v_canc_fech_pago,
                                  v_canc_impo_mone,
                                  v_canc_impo_mmnn,
                                  v_canc_impo_mmee,
                                  0);
  
    -----------------------------------------------------------------------------------------------------------------------
    --Fin de la cancelacion de la nota de credito...
    -----------------------------------------------------------------------------------------------------------------------
  
    ------------------------------------------------------------------------------------------------------------------------
    ---insertar la cancelacion de la/s Factura/s........................................................
    ------------------------------------------------------------------------------------------------------------------------
    --Determinar el Tipo de movimiento.......
    --Primero determinamos si el documento es emitido o Recibido..
    if parameter.p_emit_reci = 'E' then
      v_movi_timo_codi := parameter.p_codi_timo_cnfcre; --es emitido
    else
      v_movi_timo_codi := parameter.p_codi_timo_cnfcrr; --si es Recibido
    end if;
  
    pp_muestra_come_tipo_movi(v_movi_timo_codi,
                              v_movi_timo_desc,
                              v_movi_timo_desc_abre,
                              v_movi_afec_sald,
                              v_movi_dbcr,
                              v_indi_adel,
                              v_indi_ncr,
                              'N');
  
    v_movi_codi_padr      := v_movi_codi; --clave de la cancelacion de la Nota de Credito
    v_movi_codi           := fa_sec_come_movi;
    v_movi_clpr_codi      := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    v_movi_mone_codi      := bcab.movi_mone_codi;
    v_movi_nume           := bcab.movi_nume;
    v_movi_fech_emis      := bcab.movi_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := fa_user;
    v_movi_tasa_mone      := bcab.movi_tasa_mone;
    v_movi_tasa_mmee      := 0;
    v_movi_grav_mmnn      := 0;
    --v_movi_exen_mmnn      := round((:bdet.sum_s_total_item_marc * :bcab.movi_tasa_mone), :parameter.p_cant_deci_mmnn);
    v_movi_iva_mmnn  := 0;
    v_movi_grav_mmee := 0;
    v_movi_exen_mmee := 0;
    v_movi_iva_mmee  := 0;
    v_movi_grav_mone := 0;
 
    v_movi_iva_mone            := 0;
    v_movi_clpr_desc           := bcab.movi_clpr_desc;
    v_movi_emit_reci           := parameter.p_emit_reci;
    v_movi_empr_codi           := bcab.movi_empr_codi;
    v_movi_fact_codi           := bcab1.s_movi_codi_fact;
    v_movi_nota_devu_codi      := bcab1.movi_node_codi;
    v_movi_clpr_sucu_nume_item := bcab.movi_clpr_sucu_nume_item;
  
    if v_movi_clpr_sucu_nume_item = 0 then
      --la subcuenta cero nada mas es para filtrar.
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
                        null,
                        null,
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
                        v_movi_fact_codi,
                        v_movi_nota_devu_codi,
                        null);
  
    if nvl(bcab1.SUM_MOCO_IMPO_MONE_II, 0) > 0 then
      v_sald_apli := v_movi_exen_mone; --:bdet.sum_s_total_item;
      for r in c_movi_cuot(bcab1.s_movi_codi_fact) loop
        if v_sald_apli > 0 then
          if r.cuot_sald_mone < v_sald_apli then
            v_canc_impo_mone := r.cuot_sald_mone;
            v_sald_apli      := v_sald_apli - v_canc_impo_mone;
          else
            v_canc_impo_mone := v_sald_apli;
            v_sald_apli      := 0;
          end if;
          v_canc_movi_codi      := v_movi_codi; --clave del recibo de cn de Fac
          v_canc_cuot_movi_codi := bcab1.s_movi_codi_fact;
          v_canc_cuot_fech_venc := r.cuot_fech_venc;
          v_canc_fech_pago      := bcab.movi_fech_emis; --fecha de cancelacion de la cuota de NC (= a la fecha de la nc)      
          v_canc_impo_mmnn      := round((v_canc_impo_mone *
                                         bcab.movi_tasa_mone),
                                         parameter.p_cant_deci_mmnn);
          v_canc_impo_mmee      := 0;
          v_canc_impo_dife_camb := 0;
        
          pp_insert_come_movi_cuot_canc(v_canc_movi_codi,
                                        v_canc_cuot_movi_codi,
                                        v_canc_cuot_fech_venc,
                                        v_canc_fech_pago,
                                        v_canc_impo_mone,
                                        v_canc_impo_mmnn,
                                        v_canc_impo_mmee,
                                        v_canc_impo_dife_camb);
        else
          exit;
        end if;
      end loop;
    end if;
    -----------------------------------------------------------------------------------------------------------------------
    --Fin de la cancelacion de la/s Factura/s  
    -----------------------------------------------------------------------------------------------------------------------
  
    --    |-------------------------------------------------------------|
    --    |Obse. Los movimientos de tipo cance., no afectan caja, ni    |
    --    |tampoco tienen saldo, sirven unicamente para la aplicacion   |
    --    |conrrespondiente de los adelantos y Notas de Creditos,       |
    --    |-------------------------------------------------------------|
  Exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

  procedure pp_insert_come_movi_cuot_canc(p_canc_movi_codi      in number,
                                          p_canc_cuot_movi_codi in number,
                                          p_canc_cuot_fech_venc in date,
                                          p_canc_fech_pago      in date,
                                          p_canc_impo_mone      in number,
                                          p_canc_impo_mmnn      in number,
                                          p_canc_impo_mmee      in number,
                                          p_canc_impo_dife_camb in number
                                          
                                          ) is
  begin
    insert into come_movi_cuot_canc
      (canc_movi_codi,
       canc_cuot_movi_codi,
       canc_cuot_fech_venc,
       canc_fech_pago,
       canc_impo_mone,
       canc_impo_mmnn,
       canc_impo_mmee,
       canc_impo_dife_camb,
       canc_base)
    values
      (p_canc_movi_codi,
       p_canc_cuot_movi_codi,
       p_canc_cuot_fech_venc,
       p_canc_fech_pago,
       p_canc_impo_mone,
       p_canc_impo_mmnn,
       p_canc_impo_mmee,
       p_canc_impo_dife_camb,
       parameter.p_codi_base);
  Exception
  
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end;

  procedure pp_muestra_come_tipo_movi(p_timo_codi      in number,
                                      p_timo_Desc      out varchar2,
                                      p_timo_Desc_abre out varchar2,
                                      p_timo_afec_sald out varchar2,
                                      p_timo_dbcr      out varchar2,
                                      p_timo_indi_adel out varchar2,
                                      p_timo_indi_ncr  out varchar2,
                                      p_indi_vali      in varchar2) is
  
    v_dbcr varchar2(1);
  begin
  
    select timo_desc,
           timo_desc_abre,
           timo_afec_sald,
           timo_dbcr,
           nvl(timo_indi_adel, 'N'),
           nvl(timo_indi_ncr, 'N')
      into p_timo_desc,
           p_timo_desc_abre,
           p_timo_afec_sald,
           p_timo_dbcr,
           p_timo_indi_adel,
           p_timo_indi_ncr
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
    if p_indi_vali = 'S' then
      if p_timo_indi_adel = 'N' and p_timo_indi_ncr = 'N' then
        raise_application_error(-20001,
                                'Solo se pueden ingresar movimientos del tipo Adelantos/Notas de Creditos');
      end if;
    
      if p_timo_indi_adel = 'S' and p_timo_indi_ncr = 'S' then
        raise_application_error(-20001,
                                'El tipo de movimiento esta configurado como Adelanto y Nota de Credito al mismo tiempo, Favor Verificar..');
      end if;
    end if;
    if parameter.p_emit_reci = 'R' then
      v_dbcr := 'D';
    else
      v_dbcr := 'C';
    end if;
  
    if p_indi_vali = 'S' then
      if p_timo_dbcr <> v_dbcr then
        raise_application_error(-20001, 'Tipo de Movimiento incorrecto');
      end if;
    end if;
  
  Exception
    when no_data_found then
      p_timo_desc_abre := null;
      p_timo_desc      := null;
      p_timo_afec_sald := null;
      p_timo_dbcr      := null;
      p_timo_indi_adel := null;
      p_timo_indi_ncr  := null;
      raise_application_error(-20001, 'Tipo de Movimiento Inexistente!');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_come_tipo_movi;

  procedure pp_set_variable is
  begin
  
    bcab.movi_tasa_mone      := v('P128_MOVI_TASA_MONE');
    bcab.movi_nume           := v('P128_MOVI_NUME');
    bcab.movi_fech_emis      := v('P128_S_MOVI_FECH_EMIS');
    BCAB.MOVI_NUME_TIMB      := v('P128_MOVI_NUME_TIMB');
    bcab.movi_clpr_desc      := v('P128_MOVI_CLPR_DESC');
    bcab.movi_timo_codi      := v('P128_MOVI_TIMO_CODI');
    bcab.movi_clpr_codi      := v('P128_MOVI_CLPR_CODI');
    bcab.movi_sucu_codi_orig := v('P128_MOVI_SUCU_CODI_ORIG');
    bcab.movi_depo_codi_orig := v('P128_MOVI_DEPO_CODI_ORIG');
    bcab.movi_cuen_codi      := v('P128_MOVI_CUEN_CODI');
    bcab.movi_mone_codi      := v('P128_MOVI_MONE_CODI');
    bcab.movi_tasa_mmee      := v('P128_MOVI_TASA_MMEE');
    bcab.movi_obse           := v('P128_MOVI_OBSE');
    bcab.movi_clpr_dire      := v('P128_MOVI_CLPR_DIRE');
    bcab.movi_clpr_tele      := v('P128_MOVI_CLPR_TELE');
    bcab.movi_clpr_ruc       := v('P128_MOVI_CLPR_RUC');
    bcab.movi_emit_reci      := v('P128_MOVI_EMIT_RECI');
    bcab.movi_afec_sald      := v('P128_MOVI_AFEC_SALD');
    bcab.movi_dbcr           := v('P128_MOVI_DBCR');
    bcab.movi_empr_codi      := fa_empresa;
    bcab.movi_empl_codi      := v('P128_MOVI_EMPL_CODI');
    bcab.movi_nume_auto_impr := v('P128_MOVI_NUME_AUTO_IMPR');
    bcab.movi_exen_mmnn      := v('P128_MOVI_EXEN_MMNN');
    bcab.movi_iva_mmnn       := v('P128_MOVI_IVA_MMNN');
    bcab.movi_grav_mmnn      := v('P128_MOVI_GRAV_MMNN');
    bcab.movi_grav_mone      := v('P128_MOVI_GRAV_MONE');
    bcab.movi_iva_mone       := v('P128_MOVI_IVA_MONE');
    bcab.movi_exen_mone      := v('P128_MOVI_EXEN_MONE');
    bcab.movi_impo_mmnn_ii   := v('P128_MOVI_IMPO_MMNN_II');
    bcab.movi_impo_mone_ii   := v('P128_MOVI_IMPO_MONE_II');
    bcab.movi_grav10_ii_mmnn := v('P128_MOVI_GRAV10_II_MMNN');
    bcab.movi_grav5_ii_mmnn := v('P128_MOVI_GRAV5_II_MMNN');
    bcab.movi_grav5_ii_mone := v('P128_MOVI_GRAV5_II_MONE');
    bcab.movi_grav10_mone  := v('P128_MOVI_GRAV10_MONE');
    bcab.movi_grav10_ii_mone:= v('P128_MOVI_GRAV10_II_MONE');
    bcab.movi_grav5_mone:= v('P128_MOVI_GRAV5_MONE');
    bcab.movi_grav10_mmnn:= v('P128_MOVI_GRAV10_MMNN');
    bcab.movi_grav5_mmnn:= v('P128_MOVI_GRAV5_MMNN');
    bcab.movi_iva10_mone:= v('P128_MOVI_IVA10_MONE');
    bcab.movi_iva5_mone:= v('P128_MOVI_IVA5_MONE');
    bcab.movi_iva10_mmnn:= v('P128_MOVI_IVA10_MMNN');
    bcab.movi_iva5_mmnn:= v('P128_MOVI_IVA5_MMNN');
    
    --bcab1.movi_node_codi;
  
    bcab.movi_clpr_sucu_nume_item := v('P128_SUCU_NUME_ITEM');
  
    ----
    bcab1.s_movi_nume_fact    := v('P128_S_MOVI_CODI_FACT');
    bcab1.tico_indi_vali_nume := v('P128_TICO_INDI_VALI_NUME');
    bcab1.movi_timo_indi_sald := v('P128_MOVI_TIMO_INDI_SALD');
    bcab1.timo_tico_codi      := v('P128_TIMO_TICO_CODI');
    bcab1.movi_nume_orig      := v('P128_MOVI_NUME_ORIG');
    bcab1.s_movi_codi_fact    := v('P128_S_MOVI_CODI_FACT');
    bcab1.s_total             := v('P128_S_TOTAL');
    bcab1.fech_venc_timb      := v('P128_FECH_VENC_TIMB');
    bcab1.fech_inic_timb      := v('P128_FECH_INIC_TIMB');
    bcab1.s_timo_afec_sald      := v('P128_S_TIMO_AFEC_SALD');
    bcab1.movi_timo_indi_caja := v('P128_MOVI_TIMO_INDI_CAJA'); 
    
    

   
   
     select nvl(sum(c027),0) MOCO_IMPO_MONE_II
      into   bcab1.SUM_MOCO_IMPO_MONE_II
        from apex_collections a
     where collection_name = 'BDETALLE'
       and c001='X';
   
 
   

    bcab1.movi_node_codi   := v('P128_MOVI_NODE_CODI');
    bcab1.s_movi_sald_mone := v('P128_S_MOVI_SALD_MONE');
    
    
     bcab.movi_nume_timb:= v('P128_MOVI_NUME_TIMB') ;
     bcab1.fech_venc_timb:= v('P128_S_FECH_VENC_TIMB') ;
     bcab1.fech_inic_timb:= v('P128_S_FECH_INIC_TIMB') ;
     bcab.movi_nume_auto_impr:=v('P128_MOVI_NUME_AUTO_IMPR') ;
  
  
  end pp_set_variable;

  procedure pp_Actualizar_registro is
    salir exception;
  begin
    pp_set_variable;
    pp_validaciones;
    pp_valida_nume_fact;
    pp_valida_fech(bcab.movi_fech_emis);
    pp_validar_importes;
  
    --pp_ajustar_importes; verificar validacion
  
    ---*****Verificacion de duplicacion de comprobante
    if parameter.p_indi_modi_nume_fact = 'N' then
      -- si el usuario tiene permiso o no de modificar el numero de factura.
      pp_veri_nume(bcab.movi_nume, bcab1.timo_tico_codi); -- verifica el numero de comprobante.. en caso que exista hace                                                    -- un loop y devuelve el siguiente numero libre..                                                          
      parameter.p_indi_actu_secu := 'S';
    else
    
      if bcab.movi_nume <> bcab1.movi_nume_orig then
        -- si el numero de comprobante es distinto al numero traido de secuencia
        -- se esta cargando en diferido entonces no se actualiza secuencia. Pero verifica si existe!!!
        pp_veri_nume_dife(bcab.movi_nume);
        parameter.p_indi_actu_secu := 'N';
      else
      
        pp_veri_nume(bcab.movi_nume, bcab1.timo_tico_codi);
        -- verifica el numero de comprobante.. en caso que exista hace                                                  
        -- un loop y devuelve el siguiente numero libre..              
        parameter.p_indi_actu_secu := 'S';
      end if;
    end if;
  
    ---*****
  
    if bcab.movi_codi is null then
      pp_actualiza_come_movi;
      pp_actualiza_come_movi_prod;
    
      if bcab1.movi_node_codi is not null then
        pp_actualiza_come_nota_devu(bcab.movi_codi,
                                    'F',
                                    bcab1.movi_node_codi);
      end if;
    
      if nvl(bcab1.movi_timo_indi_sald, 'N') = 'S' then
        ---si no es contado
        pp_actualiza_come_movi_cuot;
      end if;
    
      pp_actualiza_moimpo;
      pp_actualiza_moco;
      pp_actualiza_moimpu;
      pp_actu_secu(parameter.p_indi_actu_secu);
      --aplicacion
      if parameter.p_indi_apli_ncre_fcre = 'S' then
        if bcab1.s_movi_codi_fact is not null then
          if nvl(bcab1.s_timo_afec_sald, 'N') <> 'N' then
            --21/05/2015
            -- se debe tener en cuenta el saldo de la factura, en caso que no tenga saldo ya no se genera la 
            --aplicacion, en caso que tenga, se genera por el saldo nada mas...
            if nvl(bcab1.s_movi_sald_mone, 0) > 0 then
              pp_actualiza_canc;
            end if;
          end if;
        end if;
      end if;
    
      commit;
    
    
    I020012.pp_llamar_reporte(bcab.movi_codi);


      --     pp_impr_nota_cred;
    
    else
      raise_application_error(-20001,
                              'El movimiento ya ha sido ingresado.');
    end if;
  
  end pp_Actualizar_registro;
  
  
procedure pp_llamar_reporte(p_come_movi in varchar) is
  
    v_parametros   clob;
    v_contenedores clob;
  
  begin
  

    v_contenedores := 'p_movi_codi';
    v_parametros   := p_come_movi;
  
    delete from come_parametros_report where usuario = v('APP_USER');
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, v('APP_USER'), 'I020012_alar', 'pdf', v_contenedores);
  
  end pp_llamar_reporte;
  
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
  
    procedure pp_borrar_det(i_seq in number) as
  begin
    apex_collection.delete_member(p_collection_name => 'BDETALLE',
                                  p_seq             => i_seq);
    apex_collection.resequence_collection(p_collection_name => 'BDETALLE');
  
  end pp_borrar_det;
   
end I020012;
