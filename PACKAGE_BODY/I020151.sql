
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020151" is

  type r_bcab is record(
    s_moco_iva_mmnn          number,
    movi_mone_cant_deci      number,
    movi_timo_indi_caja      varchar2(2),
    s_tot_iva                number,
    f_dif_iva                number,
    sum_s_moco_iva           number := 0,
    movi_oper_codi           come_movi.movi_oper_codi%type,
    movi_timo_codi           come_movi.movi_timo_codi%type,
    movi_codi                come_movi.movi_codi%type,
    movi_clpr_codi           come_movi.movi_clpr_codi%type,
    movi_sucu_codi_orig      come_movi.movi_sucu_codi_orig%type,
    movi_cuen_codi           come_movi.movi_cuen_codi%type,
    movi_mone_codi           come_movi.movi_mone_codi%type,
    movi_nume                come_movi.movi_nume%type,
    movi_fech_emis           come_movi.movi_fech_emis%type,
    movi_fech_grab           come_movi.movi_fech_grab%type,
    movi_user                come_movi.movi_user%type,
    movi_tasa_mone           come_movi.movi_tasa_mone%type,
    movi_iva_mmnn            come_movi.movi_iva_mmnn%type,
    movi_iva_mone            come_movi.movi_iva_mone%type,
    movi_obse                come_movi.movi_obse%type,
    movi_stoc_suma_rest      come_movi.movi_stoc_suma_rest%type,
    movi_clpr_dire           come_movi.movi_clpr_dire%type,
    movi_clpr_tele           come_movi.movi_clpr_tele%type,
    movi_clpr_ruc            come_movi.movi_clpr_ruc%type,
    movi_clpr_desc           come_movi.movi_clpr_desc%type,
    movi_emit_reci           come_movi.movi_emit_reci%type,
    movi_afec_sald           come_movi.movi_afec_sald%type,
    movi_dbcr                come_movi.movi_dbcr%type,
    movi_stoc_afec_cost_prom come_movi.movi_stoc_afec_cost_prom%type,
    movi_empr_codi           come_movi.movi_empr_codi%type,
    movi_nume_timb           come_movi.movi_nume_timb%type);

  bcab r_bcab;

  type r_parameter is record(
    p_codi_impu_grav10    number := to_number(general_skn.fl_busca_parametro('p_codi_impu_grav10')),
    p_indi_vali_timo      varchar2(1),
    p_empr_codi           number := to_number(general_skn.fl_busca_parametro('p_codi_empr')),
    p_codi_base           number := pack_repl.fa_devu_codi_base,
    p_codi_oper_com       number := to_number(general_skn.fl_busca_parametro('p_codi_oper_com')),
    p_cant_deci_mmnn      number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_cant_deci_mmee      number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmee')),
    p_codi_mone_mmnn      number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_codi_impu_grav5     number := to_number(general_skn.fl_busca_parametro('p_codi_impu_grav5')),
    p_codi_impu_exen      number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_codi_timo_decl_jura number := to_number(general_skn.fl_busca_parametro('p_codi_timo_decl_jura')));

  parameter r_parameter;

  cursor cur_det is
    select seq_id,
           c001   moco_conc_codi,
           c002   moco_impu_codi,
           c003   s_moco_iva_mmnn,
           c004   s_moco_iva,
           c005   moco_dbcr,
           c006   tiim_codi,
           c007   moco_conc_desc
      from apex_collections a
     where a.collection_name = 'CONC_DETA';

  procedure pl_me(i_msj in varchar2) is
  begin
    raise_application_error(-20010, i_msj);
  end pl_me;

  procedure pp_iniciar is
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'CONC_DETA');
  end pp_iniciar;

  procedure pp_mostrar_tipo_movi is
    v_timo_ingr_dbcr_vari char(1);
  begin
  
    select timo_afec_sald,
           timo_emit_reci,
           timo_codi_oper,
           timo_dbcr,
           timo_ingr_dbcr_vari,
           nvl(timo_indi_caja, 'N')
      into bcab.movi_afec_sald,
           bcab.movi_emit_reci,
           bcab.movi_oper_codi,
           bcab.movi_dbcr,
           v_timo_ingr_dbcr_vari,
           bcab.movi_timo_indi_caja
      from come_tipo_movi
     where timo_codi = bcab.movi_timo_codi;
  
    if nvl(v_timo_ingr_dbcr_vari, 'N') = 'N' then
      pl_me('No se permite ingresar documentos con este tipo de movimiento desde esta pantalla');
    end if;
  
  exception
    when no_data_found then
      bcab.movi_afec_sald      := null;
      bcab.movi_emit_reci      := null;
      bcab.movi_timo_indi_caja := null;
      pl_me('Tipo de Movimiento inexistente');
    when too_many_rows then
      pl_me('Tipo de Movimiento duplicado');
  end pp_mostrar_tipo_movi;

  procedure pp_valida_totales is
  begin
  
    if bcab.f_dif_iva <> 0 then
      raise_application_error(-20010,
                              'Existe una diferencia entre el total iva y el detalle de conceptos...');
    end if;
  end pp_valida_totales;

  procedure pp_insert_movi_conc_deta(p_moco_movi_codi in number,
                                     p_moco_nume_item in number,
                                     p_moco_conc_codi in number,
                                     p_moco_cuco_codi in number,
                                     p_moco_impu_codi in number,
                                     p_moco_impo_mmnn in number,
                                     p_moco_impo_mmee in number,
                                     p_moco_impo_mone in number,
                                     p_moco_dbcr      in char,
                                     p_moco_tiim_codi in number) is
  
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
       parameter.p_codi_base);
  
  end pp_insert_movi_conc_deta;

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
                                p_movi_nume_timb           in varchar2) is
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
       movi_nume_timb)
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
       p_movi_nume_timb);
  
  end pp_insert_come_movi;

  procedure pp_insert_come_movi_impo_deta(p_moim_movi_codi in number,
                                          p_moim_nume_item in number,
                                          p_moim_tipo      in char,
                                          p_moim_cuen_codi in number,
                                          p_moim_dbcr      in char,
                                          p_moim_afec_caja in char,
                                          p_moim_fech      in date,
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
       p_moim_impo_mone,
       p_moim_impo_mmnn,
       parameter.p_codi_base);
  
  end pp_insert_come_movi_impo_deta;

  procedure pp_reenumerar_nro_item is
    v_nro_item number := 0;
  begin
    null;
    /* go_block('bdet');
    first_record;                
    if bdet.moco_conc_codi is null then
       raise_application_error(-20010,'Debe ingresar al menos un item');
    end if;
    loop
       v_nro_item := v_nro_item + 1;
      bdet.moco_nume_item := v_nro_item;
      if  :system.last_record = 'TRUE' then
        exit;
      end if;
      next_record;
    end loop;*/
  end pp_reenumerar_nro_item;

  function fa_devu_dbcr_caja(p_timo_codi in number) return char is
    v_dbcr_caja char(1);
  begin
    select nvl(timo_dbcr_caja, timo_dbcr)
      into v_dbcr_caja
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
    return v_dbcr_caja;
  
  exception
    when no_data_found then
      return null;
    
  end fa_devu_dbcr_caja;

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
  
  begin
  
    --- asignar valores....
    bcab.movi_codi      := fa_sec_come_movi;
    bcab.movi_oper_codi := null;
    bcab.movi_fech_grab := sysdate;
    bcab.movi_user      := gen_user;
  
    v_movi_codi                := bcab.movi_codi;
    v_movi_timo_codi           := parameter.p_codi_timo_decl_jura;
    v_movi_clpr_codi           := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig      := null;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := null;
    v_movi_cuen_codi           := bcab.movi_cuen_codi;
    v_movi_mone_codi           := bcab.movi_mone_codi;
    v_movi_nume                := bcab.movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := bcab.movi_fech_grab;
    v_movi_user                := bcab.movi_user;
    v_movi_codi_padr           := null;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := null;
    v_movi_grav_mmnn           := 0;
    v_movi_exen_mmnn           := 0;
    v_movi_iva_mmnn            := bcab.movi_iva_mmnn;
    v_movi_grav_mmee           := 0;
    v_movi_exen_mmee           := 0;
    v_movi_iva_mmee            := 0;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := 0;
    v_movi_iva_mone            := bcab.movi_iva_mone;
    v_movi_obse                := bcab.movi_obse;
    v_movi_sald_mmnn           := 0;
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := 0;
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
    v_movi_empl_codi           := null;
    v_movi_nume_timb           := bcab.movi_nume_timb;
  
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
                        v_movi_nume_timb);
  
  end pp_actualiza_come_movi;

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
  
    cursor c_conc_iva is
      select decode(bcab.movi_dbcr,
                    'C',
                    impu_conc_codi_ivcr,
                    impu_conc_codi_ivdb) conc_iva
        from come_impu
       order by 1;
  
    v_conc_iva number;
  
  begin
    v_moco_movi_codi := bcab.movi_codi;
    v_moco_nume_item := 0;
    for bdet in cur_det loop
    
      v_moco_nume_item := v_moco_nume_item + 1;
      v_moco_conc_codi := bdet.moco_conc_codi;
      v_moco_cuco_codi := null;
      v_moco_impu_codi := bdet.moco_impu_codi;
      v_moco_impo_mmnn := bdet.s_moco_iva_mmnn;
      v_moco_impo_mmee := 0;
      v_moco_impo_mone := bdet.s_moco_iva;
      v_moco_dbcr      := bdet.moco_dbcr;
      v_moco_tiim_codi := bdet.tiim_codi;
    
      pp_insert_movi_conc_deta(v_moco_movi_codi,
                               v_moco_nume_item,
                               v_moco_conc_codi,
                               v_moco_cuco_codi,
                               v_moco_impu_codi,
                               v_moco_impo_mmnn,
                               v_moco_impo_mmee,
                               v_moco_impo_mone,
                               v_moco_dbcr,
                               v_moco_tiim_codi);
    
    end loop;
  
  end pp_actualiza_moco;

  procedure pp_actualiza_moimpu is
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
  
    v_grav_05_mone number := 0;
    v_impu_05_mone number := 0;
    v_grav_10_mone number := 0;
    v_impu_10_mone number := 0;
    v_grav_05_mmnn number := 0;
    v_impu_05_mmnn number := 0;
    v_grav_10_mmnn number := 0;
    v_impu_10_mmnn number := 0;
  
    v_impoii_mmnn number := 0;
    v_impoii_mmee number := 0;
    v_impoii_mone number := 0;
    v_impo_mmnn   number := 0;
    v_impu_mmnn   number := 0;
    v_impo_mmee   number := 0;
    v_impu_mmee   number := 0;
    v_impo_mone   number := 0;
    v_impu_mone   number := 0;
  
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
      v_impoii_mmnn := x.moco_impo_mmnn;
      v_impoii_mmee := x.moco_impo_mmee;
      v_impoii_mone := x.moco_impo_mone; 
      if x.moco_impu_codi = to_number(parameter.p_codi_impu_grav5) then
        v_impo_mmnn := 0;
        v_impu_mmnn := round(v_impoii_mmnn, parameter.p_cant_deci_mmnn);
        v_impo_mmee := 0;
        v_impu_mmee := round(v_impoii_mmee, parameter.p_cant_deci_mmee);
        v_impo_mone := 0;
        v_impu_mone := round(v_impoii_mone, bcab.movi_mone_cant_deci);
      
        v_grav_05_mone := round(v_impoii_mone * 100 / 5,
                                bcab.movi_mone_cant_deci);
        v_impu_05_mone := v_impu_mone;
        v_grav_10_mone := 0;
        v_impu_10_mone := 0;
        v_grav_05_mmnn := round(v_impoii_mmnn * 100 / 5,
                                parameter.p_cant_deci_mmnn);
        v_impu_05_mmnn := v_impu_mmnn;
        v_grav_10_mmnn := 0;
        v_impu_10_mmnn := 0;
      end if;
    
      if x.moco_impu_codi = to_number(parameter.p_codi_impu_grav10) then
        v_impo_mmnn := 0;
        v_impu_mmnn := round(v_impoii_mmnn, parameter.p_cant_deci_mmnn);
        v_impo_mmee := 0;
        v_impu_mmee := round(v_impoii_mmee, parameter.p_cant_deci_mmee);
        v_impo_mone := 0;
        v_impu_mone := round(v_impoii_mone, bcab.movi_mone_cant_deci);
      
        v_grav_05_mone := 0;
        v_impu_05_mone := 0;
        v_grav_10_mone := round(v_impoii_mone * 100 / 10,
                                bcab.movi_mone_cant_deci);
        v_impu_10_mone := v_impu_mone;
        v_grav_05_mmnn := 0;
        v_impu_05_mmnn := 0;
        v_grav_10_mmnn := round(v_impoii_mmnn * 100 / 10,
                                parameter.p_cant_deci_mmnn);
        v_impu_10_mmnn := v_impu_mmnn;
      end if;
    
      if x.moco_impu_codi = to_number(parameter.p_codi_impu_exen) then
        v_impo_mmnn := 0;
        v_impu_mmnn := 0;
        v_impo_mmee := 0;
        v_impu_mmee := 0;
        v_impo_mone := 0;
        v_impu_mone := 0;
      
        v_grav_05_mone := 0;
        v_impu_05_mone := 0;
        v_grav_10_mone := 0;
        v_impu_10_mone := 0;
        v_grav_05_mmnn := 0;
        v_impu_05_mmnn := 0;
        v_grav_10_mmnn := 0;
        v_impu_10_mmnn := 0;
      end if;
    
      v_moim_impu_codi      := x.moco_impu_codi;
      v_moim_movi_codi      := x.moco_movi_codi;
      v_moim_impo_mmnn      := v_grav_05_mmnn + v_grav_10_mmnn;
      v_moim_impo_mmee      := v_impo_mmee;
      v_moim_impu_mmnn      := v_impu_05_mmnn + v_impu_10_mmnn;
      v_moim_impu_mmee      := v_impu_mmee;
      v_moim_impo_mone      := v_grav_05_mone + v_grav_10_mone;
      v_moim_impu_mone      := v_impu_05_mone + v_impu_10_mone;
      v_moim_base           := parameter.p_codi_base;
      v_moim_tiim_codi      := x.moco_tiim_codi;
      v_moim_impo_mone_ii   := v_moim_impo_mone + v_moim_impu_mone;
      v_moim_impo_mmnn_ii   := v_moim_impo_mmnn + v_moim_impu_mmnn;
      v_moim_grav10_ii_mone := v_grav_10_mone + v_impu_10_mone;
      v_moim_grav5_ii_mone  := v_grav_05_mone + v_impu_05_mone;
      v_moim_grav10_ii_mmnn := v_grav_10_mmnn + v_impu_10_mmnn;
      v_moim_grav5_ii_mmnn  := v_grav_05_mmnn + v_impu_05_mmnn;
      v_moim_grav10_mone    := v_grav_10_mone;
      v_moim_grav5_mone     := v_grav_05_mone;
      v_moim_grav10_mmnn    := v_grav_10_mmnn;
      v_moim_grav5_mmnn     := v_grav_05_mmnn;
      v_moim_iva10_mone     := v_impu_10_mone;
      v_moim_iva5_mone      := v_impu_05_mone;
      v_moim_iva10_mmnn     := v_impu_10_mmnn;
      v_moim_iva5_mmnn      := v_impu_05_mmnn;
      v_moim_exen_mone      := 0;
      v_moim_exen_mmnn      := 0;
    
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

  --actualizar la tabla moimpo , efectivo, cheques dif, cheques dia, y vuelto (para el caso de las cobranzas) 
  procedure pp_actualiza_moimpo is
  
    v_moim_movi_codi number;
    v_moim_nume_item number := 0;
    v_moim_tipo      char(20);
    v_moim_cuen_codi number;
    v_moim_dbcr      char(1);
    v_moim_afec_caja char(1);
    v_moim_fech      date;
    v_moim_impo_mone number;
    v_moim_impo_mmnn number;
  
  begin
    --raise_application_error(-20010, bcab.movi_timo_indi_caja);
  
    if bcab.movi_timo_indi_caja = 'S' then
      --solo si afecta a caja
    
      --proveedores.........  
      if bcab.movi_emit_reci = 'R' then
        v_moim_movi_codi := bcab.movi_codi;
        v_moim_nume_item := v_moim_nume_item + 1;
        v_moim_tipo      := 'Efectivo';
        v_moim_cuen_codi := bcab.movi_cuen_codi;
        v_moim_dbcr      := rtrim(ltrim(nvl(fa_devu_dbcr_caja(bcab.movi_timo_codi),
                                            bcab.movi_dbcr)));
        v_moim_afec_caja := 'S';
        v_moim_fech      := bcab.movi_fech_emis;
        v_moim_impo_mone := bcab.s_tot_iva;
        v_moim_impo_mmnn := round((bcab.s_tot_iva * bcab.movi_tasa_mone),
                                  parameter.p_cant_deci_mmnn);
      
        pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                      v_moim_nume_item,
                                      v_moim_tipo,
                                      v_moim_cuen_codi,
                                      v_moim_dbcr,
                                      v_moim_afec_caja,
                                      v_moim_fech,
                                      v_moim_impo_mone,
                                      v_moim_impo_mmnn);
      end if;
    
    end if;
  
  end pp_actualiza_moimpo;

  procedure pp_borrar_det(i_seq in number) as
  begin
    apex_collection.delete_member(p_collection_name => 'CONC_DETA',
                                  p_seq             => i_seq);
    apex_collection.resequence_collection(p_collection_name => 'CONC_DETA');
  
  end pp_borrar_det;

  procedure pp_add_det(i_det_conc_codi       in number,
                       i_det_impu_codi       in number,
                       i_det_tiim_codi       in number,
                       i_det_s_moco_iva      in number,
                       i_movi_mone_cant_deci in number) is
  
    v_conc_dbcr      varchar2(10);
    v_moco_conc_desc come_conc.conc_desc%type;
  begin
  
    if i_det_conc_codi is null then
      raise_application_error(-20010, 'Debe ingresar el concepto');
    end if;
  
    if i_det_impu_codi is null then
      raise_application_error(-20010, 'Debe ingresar el impuesto');
    end if;
  
    if i_det_tiim_codi is null then
      raise_application_error(-20010, 'Debe ingresar el tipo de impuesto');
    end if;
  
    if i_det_impu_codi = parameter.p_codi_impu_exen then
      raise_application_error(-20010,
                              'Debe seleccionar un codigo de impuesto distinto al exento!!');
    end if;
  
    select rtrim(ltrim(conc_dbcr)) dbcr, a.conc_desc
      into v_conc_dbcr, v_moco_conc_desc
      from come_conc a
     where conc_codi = i_det_conc_codi;
  
    /* select c001 moco_conc_codi,
          c002 moco_impu_codi,
          c003 s_moco_iva_mmnn,
          c004 s_moco_iva,
          c005 moco_dbcr,
          c006 tiim_codi
     from apex_collections a
    where a.collection_name = 'CONC_DETA'*/
  
    apex_collection.add_member(p_collection_name => 'CONC_DETA',
                               p_c001            => i_det_conc_codi,
                               p_c002            => i_det_impu_codi,
                               p_c003            => 0,
                               p_c004            => i_det_s_moco_iva,
                               p_c005            => v_conc_dbcr,
                               p_c006            => i_det_tiim_codi,
                               p_c007            => v_moco_conc_desc);
  end pp_add_det;

  procedure pp_calcular_importe_item is
    v_bandera       number := 0;
    v_moco_iva_mmnn number := 0;
  begin
    for bdet in cur_det loop
      v_bandera := 1;
      null;
    
      bcab.sum_s_moco_iva := bcab.sum_s_moco_iva + bdet.s_moco_iva;
    
      v_moco_iva_mmnn := round((bdet.s_moco_iva * bcab.movi_tasa_mone),
                               parameter.p_cant_deci_mmnn);
    
      apex_collection.update_member_attribute(p_collection_name => 'CONC_DETA',
                                              p_seq             => bdet.seq_id,
                                              p_attr_number     => 3,
                                              p_attr_value      => v_moco_iva_mmnn);
    
    end loop;
  
    if v_bandera = 0 then
      raise_application_error(-20010, 'Debe ingresar al menos un item');
    end if;
  
    select nvl(round(bcab.s_tot_iva, bcab.movi_mone_cant_deci), 0) -
           nvl(round(bcab.sum_s_moco_iva, bcab.movi_mone_cant_deci), 0)
      into bcab.f_dif_iva
      from dual;
  
  end pp_calcular_importe_item;

  function fp_codi_timo_decl_jura return number is
  begin
    return parameter.p_codi_timo_decl_jura;
  end fp_codi_timo_decl_jura;

  procedure pp_set_variable is
  begin
    bcab.movi_sucu_codi_orig := v('P9_MOVI_SUCU_CODI_ORIG');
    bcab.movi_fech_emis      := v('P9_MOVI_FECH_EMIS');
    bcab.movi_clpr_codi      := v('P9_MOVI_CLPR_CODI');
    bcab.movi_clpr_desc      := v('P9_MOVI_CLPR_DESC');
    bcab.movi_clpr_ruc       := v('P9_MOVI_CLPR_RUC');
    bcab.movi_clpr_tele      := v('P9_MOVI_CLPR_TELE');
    bcab.movi_nume_timb      := v('P9_MOVI_NUME_TIMB');
    bcab.movi_clpr_dire      := v('P9_MOVI_CLPR_DIRE');
    --bcab.s_nro_1             := v('P9_S_NRO_1');
    --bcab.s_nro_2             := v('P9_S_NRO_2');
    -- bcab.s_nro_3             := v('P9_S_NRO_3');
    bcab.movi_nume      := v('P9_MOVI_NUME');
    bcab.movi_cuen_codi := v('P9_MOVI_CUEN_CODI');
    --bcab.s_cuenta_desc  := v('P9_S_CUENTA_DESC');
    --bcab.s_banco_desc   := v('P9_S_BANCO_DESC');
    bcab.movi_mone_codi      := v('P9_MOVI_MONE_CODI');
    bcab.movi_tasa_mone      := v('P9_MOVI_TASA_MONE');
    bcab.movi_obse           := v('P9_MOVI_OBSE');
    bcab.movi_dbcr           := v('P9_MOVI_DBCR');
    bcab.movi_afec_sald      := v('P9_MOVI_AFEC_SALD');
    bcab.movi_emit_reci      := v('P9_MOVI_EMIT_RECI');
    bcab.s_tot_iva           := v('P9_S_TOT_IVA');
    bcab.movi_mone_cant_deci := v('P9_MOVI_MONE_CANT_DECI');
  
    if bcab.movi_mone_cant_deci is null then
      bcab.movi_mone_cant_deci := 0;
    end if;
  
    --  raise_application_Error(-20010, bcab.movi_mone_cant_deci);
    --bcab.s_iva_5             := v('P9_S_IVA_5');
    --bcab.s_iva_10            := v('P9_S_IVA_10');
  
    bcab.movi_iva_mone := bcab.s_tot_iva;
    bcab.movi_iva_mmnn := round((bcab.movi_iva_mone * bcab.movi_tasa_mone),
                                parameter.p_cant_deci_mmnn);
  
    --pp_cargar_parametros;
    --pp_muestra_clpr_label;
  
    bcab.movi_timo_codi := parameter.p_codi_timo_decl_jura;
  
    if bcab.movi_timo_codi is not null then
      pp_mostrar_tipo_movi;
    
      general_skn.pl_vali_user_tipo_movi(bcab.movi_timo_codi,
                                         parameter.p_indi_vali_timo);
    
      if upper(rtrim(ltrim(parameter.p_indi_vali_timo))) = 'N' then
        pl_me('El usuario no posee permiso para ingresar movimientos de este tipo');
      end if;
    else
      pl_me('Debe ingresar el tipo de Movimiento');
    end if;
  
    if bcab.movi_empr_codi is null then
      bcab.movi_empr_codi := parameter.p_empr_codi;
    end if;
  
  end pp_set_variable;

  procedure pp_validar is
  begin
  
    if bcab.movi_sucu_codi_orig is null then
      raise_application_error(-20010,
                              'Debe ingresar el codigo de la sucursal');
    end if;
  
    if bcab.movi_fech_emis is null then
      raise_application_error(-20010, 'Debe ingresar la fecha');
    end if;
  
    if bcab.movi_clpr_codi is null then
      raise_application_error(-20010, 'Debe ingresar el proveedor');
    end if;
  
    if bcab.movi_cuen_codi is null then
      raise_application_error(-20010, 'Debe ingresar la cuenta bancaria');
    end if;
  
    if bcab.movi_mone_codi = parameter.p_codi_mone_mmnn then
      bcab.movi_tasa_mone := 1;
    end if;
  
    if nvl(bcab.movi_tasa_mone, 0) <= 0 then
      raise_application_error(-20010,
                              'La cotizacion debe ser mayor a cero');
    end if;
  end pp_validar;

  procedure pp_busca_tasa_mone(i_mone_codi      in number,
                               i_movi_fech_emis in date,
                               o_mone_coti      out number) is
  begin
    if parameter.p_codi_mone_mmnn = i_mone_codi then
      o_mone_coti := 1;
    else
      select coti_tasa
        into o_mone_coti
        from come_coti
       where coti_mone = i_mone_codi
         and coti_fech = i_movi_fech_emis;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Cotizaciion Inexistente para la fecha del documento');
  end pp_busca_tasa_mone;

  procedure pp_mone_dec(i_mone_codi in number, o_mone_cant_deci out number) is
  begin
    select mone_cant_deci
      into o_mone_cant_deci
      from come_mone
     where mone_codi = i_mone_codi;
  exception
    when no_data_found then
      raise_application_error(-20010, 'Moneda Inexistente!');
  end pp_mone_dec;

  procedure pp_llamar_reporte(i_movi_codi in varchar2) is
    v_nombre       varchar2(50);
    v_parametros   clob;
    v_contenedores clob;
  begin
  
    begin
      -- Call the procedure
      i020009.pp_reporte(i_movi_codi      => i_movi_codi,
                         i_movi_timo_codi => parameter.p_codi_timo_decl_jura);
    end;
  
    /*
    
    --v_nombre:=  'comisionCobranzas'; comisioninstalaciones
    v_contenedores := 'p_movi_codi';
    v_parametros   := i_movi_codi;
    
    delete from come_parametros_report where usuario = gen_user;
    
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, gen_user, 'I020009', 'pdf', v_contenedores);*/
  
  end pp_llamar_reporte;

  procedure pp_validar_nro(i_movi_nume      in number,
                           i_movi_clpr_codi in number) is
    v_count   number;
    v_message varchar2(1000) := 'ya existe un comprobante con este nro para este proveedor, favor verifique!!';
  
  begin
  
    select count(*)
      into v_count
      from come_movi
     where movi_nume = i_movi_nume
       and movi_clpr_codi = i_movi_clpr_codi
       and movi_oper_codi = parameter.p_codi_oper_com;
  
    --  raise_application_error(-20010, parameter.p_codi_oper_com);
  
    if v_count > 0 then
      raise_application_error(-20010, v_message);
    end if;
  end pp_validar_nro;

  procedure pp_actualizar_registro is
    salir exception;
    v_record  number;
    v_mensaje varchar2(500);
  begin
  
    pp_set_variable;
  
    pp_validar;
    pp_calcular_importe_item;
    pp_valida_totales;
  
    -- raise_application_error(-20010, bcab.f_dif_iva);
    ---obs. en algun lugar .....................................
    -- se pierde el valor de p_indi_habi_vuelto y da un error...
    -- por eso volvemos a rehasignar.............................
  
    if rtrim(ltrim(bcab.movi_timo_indi_caja)) = 'S' then
      if bcab.movi_cuen_codi is null then
        raise_application_error(-20010,
                                'Debe ingresar el codigo de la Caja');
      end if;
    end if;
  
    -- pp_validar_importes;
    pp_reenumerar_nro_item;
    pp_actualiza_come_movi;
    pp_actualiza_moco;
    pp_actualiza_moimpu;
    pp_actualiza_moimpo;
  
    v_mensaje := ' Registro actualizado correctamente</br>
                                                <a href="javascript:$s(''P9_IMPRIMIR_MOVI_CODI'',' ||
                 bcab.movi_codi || ');">Imprimir</a> ';
    --v_mensaje                                := ' Registro actualizado correctamente';
    apex_application.g_print_success_message := v_mensaje;
  
  exception
    when salir then
      null;
  end pp_actualizar_registro;

end i020151;
