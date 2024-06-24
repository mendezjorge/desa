
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020040" is

  type t_parameter is record(
    p_indi_vali_limi_costo varchar2(2) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_limi_costo'))),
    p_fech_inic            date,
    p_fech_fini            date,
    p_codi_mone_mmee       number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmee')),
    p_codi_mone_mmnn       number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_tica_codi_soli_mate  number := general_skn.fl_busca_parametro('p_tica_codi_soli_mate'),
    p_codi_oper_sprod      number := to_number(general_skn.fl_busca_parametro('p_codi_oper_sprod')),
    p_codi_base            number := pack_repl.fa_devu_codi_base,
    p_cant_deci_mmee       number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmee')),
    p_peco                 number := 1);

  --pp_formatear_importes;

  parameter t_parameter;

  type t_bcab is record(
    movi_fech_emis           come_movi.movi_fech_emis%type,
    movi_nume                come_movi.movi_nume%type,
    movi_codi                come_movi.movi_codi%type,
    movi_fech_grab           come_movi.movi_fech_grab%type,
    movi_user                come_movi.movi_user%type,
    movi_oper_codi           come_movi.movi_oper_codi%type,
    movi_sucu_codi_orig      come_movi.movi_sucu_codi_orig%type,
    movi_depo_codi_orig      come_movi.movi_depo_codi_orig%type,
    movi_stoc_suma_rest      come_movi.movi_stoc_suma_rest%type,
    movi_tasa_mmee           come_movi.movi_tasa_mmee%type,
    movi_obse                come_movi.movi_obse%type,
    movi_stoc_afec_cost_prom come_movi.movi_stoc_afec_cost_prom%type,
    movi_empl_codi           come_movi.movi_empl_codi%type,
    movi_ortr_codi           come_movi.movi_ortr_codi%type,
    movi_soma_codi           come_movi.movi_soma_codi%type,
    movi_clpr_codi           come_movi.movi_clpr_codi%type,
    w_soma_indi_espe         varchar2(5),
    g_ind_salta_set          varchar2(1) := 'N');
  bcab t_bcab;

  type t_det is record(
    
    sum_deta_impo_mmnn number);
  g_bdet t_det;

  cursor cur_det is
    select seq_id,
           c001   deta_prod_codi,
           seq_id deta_nume_item,
           c002   deta_cant,
           c003   deta_medi_codi,
           c004   prod_indi_lote,
           c005   deta_lote_codi,
           c006   deta_cant_medi,
           c007   deta_prec_unit,
           c008   deta_prec_unit_mmee
      from apex_collections a
     where a.collection_name = 'DETALLE';

  procedure pp_valida_fech(p_fech in date) is
  begin
    if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
    
      raise_application_error(-20010,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(parameter.p_fech_inic, 'dd-mm-yyyy') ||
                              ' y ' ||
                              to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
    end if;
  
  end pp_valida_fech;

  procedure pp_reenumerar_nro_item(p_indi_cant in varchar2) is
    v_nro_item number := 0;
  begin
  
    for bdet in cur_det loop
      if bdet.deta_prod_codi is null then
        raise_application_error(-20010, 'Debe ingresar al menos un item');
      end if;
      v_nro_item          := v_nro_item + 1;
      bdet.deta_nume_item := v_nro_item;
    
      if nvl(p_indi_cant, 'N') = 'S' then
        bdet.deta_cant_medi := bdet.deta_cant_medi;
        if bdet.deta_medi_codi is null then
          raise_application_error(-20010,
                                  'Debe indicar una unidad de medida para el producto');
        end if;
      end if;
    
      if nvl(bdet.prod_indi_lote, 'N') = 'S' and
         bdet.deta_lote_codi is null then
        raise_application_error(-20010,
                                'Debe indicar un lote para el producto');
      end if;
    
    end loop;
  end pp_reenumerar_nro_item;

  procedure pp_validar_repeticion_prod is
    v_cant_reg number; --cantidad de registros en el bloque
    i          number;
    j          number;
    salir      exception;
    v_ant_art  number;
    v_ant_lot  number;
  begin
    null;
    /*
    go_block('bdet'); if not form_success then raise form_trigger_failure;
    end if; last_record; v_cant_reg := to_number(:system.cursor_record); if v_cant_reg <= 1 then raise salir;
    end if;
    
    for i in 1 .. v_cant_reg - 1 loop go_record(i); v_ant_art := bdet.deta_prod_codi; v_ant_lot := nvl(bdet.deta_lote_codi, -1); for j in i + 1 .. v_cant_reg loop go_record(j); if v_ant_art = bdet.deta_prod_codi and v_ant_lot = nvl(bdet.deta_lote_codi, -1) then raise_application_error(-20010,'El codigo de Producto y Lote del item ' || to_char(i) || ' se repite con el del item ' || to_char(j) || '. asegurese de no introducir mas de una' || ' vez el mismo codigo!');
    end if;
    end loop;
    end loop;*/
  
  exception
    when salir then
      null;
  end pp_validar_repeticion_prod;

  procedure pp_validar_limi_cost(p_ortr_codi in number, p_impo in number) is
    v_limi_cost number;
    v_cost_actu number;
  begin
  
    v_limi_cost := pack_ortr.fa_dev_limi_cost(p_ortr_codi);
    v_cost_actu := pack_ortr.fa_dev_cost_ortr(p_ortr_codi);
  
    if nvl(v_cost_actu, 0) + nvl(p_impo, 0) > nvl(v_limi_cost, 0) then
      raise_application_error(-20010,
                              'El Costo de la OT supera el límite de Costo');
    end if;
  
  end pp_validar_limi_cost;

  procedure pp_verifica_nume is
    v_nume number;
  begin
    v_nume := bcab.movi_nume;
    loop
      begin
        select movi_nume
          into v_nume
          from come_movi
         where movi_nume = v_nume
           and movi_oper_codi = parameter.p_codi_oper_sprod;
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          exit;
        when too_many_rows then
          v_nume := v_nume + 1;
      end;
    end loop;
    bcab.movi_nume := v_nume;
  end pp_verifica_nume;

  procedure pp_mostrar_operacion is
  begin
  
    select oper_stoc_suma_rest, oper_stoc_afec_cost_prom
      into bcab.movi_stoc_suma_rest, bcab.movi_stoc_afec_cost_prom
      from come_stoc_oper
     where oper_codi = bcab.movi_oper_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Operacion inexistente!');
  end pp_mostrar_operacion;

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
                                p_movi_ortr_codi           in number,
                                p_movi_soma_codi           in number) is
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
       movi_soma_codi,
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
       p_movi_soma_codi,
       parameter.p_codi_base);
  
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
    v_movi_ortr_codi           number;
    v_movi_soma_codi           number;
  begin
  
    --- asignar valores....
    bcab.movi_codi      := fa_sec_come_movi;
    bcab.movi_fech_grab := sysdate;
    bcab.movi_user      := fp_user;
  
    bcab.movi_oper_codi := parameter.p_codi_oper_sprod;
    pp_mostrar_operacion;
  
    v_movi_codi                := bcab.movi_codi;
    v_movi_timo_codi           := null;
    v_movi_clpr_codi           := bcab.movi_clpr_codi;
    v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig      := bcab.movi_depo_codi_orig;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := bcab.movi_oper_codi;
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := null;
    v_movi_nume                := bcab.movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := bcab.movi_fech_grab;
    v_movi_user                := bcab.movi_user;
    v_movi_codi_padr           := null;
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
    v_movi_obse                := bcab.movi_obse;
    v_movi_sald_mmnn           := null;
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := null;
    v_movi_stoc_suma_rest      := bcab.movi_stoc_suma_rest;
    v_movi_clpr_dire           := null;
    v_movi_clpr_tele           := null;
    v_movi_clpr_ruc            := null;
    v_movi_clpr_desc           := null;
    v_movi_emit_reci           := null;
    v_movi_afec_sald           := null;
    v_movi_dbcr                := null;
    v_movi_stoc_afec_cost_prom := bcab.movi_stoc_afec_cost_prom;
    v_movi_empr_codi           := null;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := bcab.movi_empl_codi;
    v_movi_ortr_codi           := bcab.movi_ortr_codi;
    v_movi_soma_codi           := bcab.movi_soma_codi;
  
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
                        v_movi_ortr_codi,
                        v_movi_soma_codi);
  
  end pp_actualiza_come_movi;

  procedure pp_insert_come_movi_prod_deta(p_deta_movi_codi         in number,
                                          p_deta_nume_item         in number,
                                          p_deta_impu_codi         in number,
                                          p_deta_prod_codi         in number,
                                          p_deta_medi_codi         in number,
                                          p_deta_cant              in number,
                                          p_deta_cant_medi         in number,
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
                                          p_deta_lote_codi         in number) is
  begin
    insert into come_movi_prod_deta
      (deta_movi_codi,
       deta_nume_item,
       deta_impu_codi,
       deta_prod_codi,
       deta_medi_codi,
       deta_cant,
       deta_cant_medi,
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
       deta_base)
    values
      (p_deta_movi_codi,
       p_deta_nume_item,
       p_deta_impu_codi,
       p_deta_prod_codi,
       p_deta_medi_codi,
       p_deta_cant,
       p_deta_cant_medi,
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
       parameter.p_codi_base);
  end pp_insert_come_movi_prod_deta;

  procedure pp_actualiza_come_movi_prod is
    v_deta_movi_codi         number;
    v_deta_nume_item         number;
    v_deta_impu_codi         number;
    v_deta_prod_codi         number;
    v_deta_medi_codi         number;
    v_deta_cant              number;
    v_deta_cant_medi         number;
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
  
  begin
    v_deta_movi_codi := bcab.movi_codi;
    for bdet in cur_det loop
      v_deta_nume_item         := bdet.deta_nume_item;
      v_deta_impu_codi         := 1; --exento
      v_deta_prod_codi         := bdet.deta_prod_codi;
      v_deta_medi_codi         := bdet.deta_medi_codi;
      v_deta_cant              := bdet.deta_cant;
      v_deta_cant_medi         := bdet.deta_cant_medi;
      v_deta_obse              := null;
      v_deta_porc_deto         := null;
      v_deta_impo_mone         := round((bdet.deta_prec_unit *
                                        bdet.deta_cant_medi),
                                        0);
      v_deta_impo_mmnn         := v_deta_impo_mone;
      v_deta_impo_mmee         := round((bdet.deta_prec_unit_mmee *
                                        bdet.deta_cant_medi),
                                        parameter.p_cant_deci_mmee);
      v_deta_iva_mmnn          := 0;
      v_deta_iva_mmee          := 0;
      v_deta_iva_mone          := 0;
      v_deta_prec_unit         := bdet.deta_prec_unit;
      v_deta_movi_codi_padr    := null;
      v_deta_nume_item_padr    := null;
      v_deta_impo_mone_deto_nc := null;
      v_deta_movi_codi_deto_nc := null;
      v_deta_list_codi         := null;
      --v_deta_lote_codi          := fp_devu_lote_000000(bdet.deta_prod_codi);
      v_deta_lote_codi := bdet.deta_lote_codi;
    
      pp_insert_come_movi_prod_deta(v_deta_movi_codi,
                                    v_deta_nume_item,
                                    v_deta_impu_codi,
                                    v_deta_prod_codi,
                                    v_deta_medi_codi,
                                    v_deta_cant,
                                    v_deta_cant_medi,
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
                                    v_deta_lote_codi);
    
    end loop;
  
  end pp_actualiza_come_movi_prod;

  procedure pp_actu_pres_esta_pres(p_pres_codi in number) is
  begin
    update come_pres_clie a
       set a.pres_esta_pres = 'F'
     where pres_codi = p_pres_codi
       and pres_esta_pres = 'P';
  exception
    when others then
      raise_application_error(-20010,
                              'Error al actualizar el estado del presupuesto.');
  end pp_actu_pres_esta_pres;

  procedure pp_actu_secu is
  begin
    update come_secu
       set secu_nume_soli_mate = bcab.movi_nume
     where secu_codi = (select peco_secu_codi
                          from come_pers_comp
                         where peco_codi = parameter.p_peco);
  
  end pp_actu_secu;

  procedure pp_actu_cant_usad_pres is
    v_ortr_pres_codi number;
  begin
    begin
      select ortr_pres_codi
        into v_ortr_pres_codi
        from come_orde_trab
       where ortr_codi = bcab.movi_ortr_codi;
    exception
      when no_data_found then
        raise_application_error(-20010,
                                'Ot no esta relacionada a un presupuesto.');
    end;
  
    for bdet in cur_det loop
      update come_pres_clie_deta
         set dpre_cant_usad =
             (nvl(dpre_cant_usad, 0) + nvl(bdet.deta_cant, 0))
       where dpre_pres_codi = v_ortr_pres_codi
         and nvl(dpre_ortr, 'P') = 'P'
         and dpre_prod_codi = bdet.deta_prod_codi;
    
    end loop;
  
    pp_actu_pres_esta_pres(v_ortr_pres_codi); -- actualiza el estado del presupuesto;
  
  end pp_actu_cant_usad_pres;

  procedure pp_actu_sald_soli_mate(p_soma_codi in number,
                                   p_indi_oper in varchar2) is
  begin
    for bdet in cur_det loop
      if p_indi_oper = 'I' then
        update come_soli_mate_deta d
           set d.deta_cant_sald = nvl(d.deta_cant_sald, nvl(d.deta_cant, 0)) -
                                  bdet.deta_cant
         where d.deta_soma_codi = p_soma_codi
           and d.deta_prod_codi = bdet.deta_prod_codi;
      
      elsif p_indi_oper = 'D' then
        update come_soli_mate_deta d
           set d.deta_cant_sald = nvl(d.deta_cant_sald, nvl(d.deta_cant, 0)) +
                                  bdet.deta_cant
         where d.deta_soma_codi = p_soma_codi
           and d.deta_prod_codi = bdet.deta_prod_codi;
      
      end if;
    
    end loop;
  
  exception
    when no_data_found then
      null;
  end pp_actu_sald_soli_mate;

  procedure pp_actu_cant_usad_pres_ortr is
    v_ortr_pres_codi number;
  begin
  
    for bdet in cur_det loop
      update come_orde_trab_pres_prod_deta d
         set otpr_cant_usad =
             (nvl(otpr_cant_usad, 0) + nvl(bdet.deta_cant, 0))
       where otpr_ortr_codi = bcab.movi_ortr_codi
         and otpr_prod_codi = bdet.deta_prod_codi;
    
    end loop;
  
  end pp_actu_cant_usad_pres_ortr;

  procedure pp_buscar_nume(p_nume out number) is
  begin
    select (nvl(secu_nume_soli_mate, 0) + 1) nume
      into p_nume
      from come_secu s, come_pers_comp t
     where s.secu_codi = t.peco_secu_codi
       and t.peco_codi = parameter.p_peco;
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Codigo de Secuencia no fue correctamente asignada a la terminal');
  end pp_buscar_nume;

  procedure pp_busca_costo_prome(p_prod_codi in number,
                                 p_fech_movi in date,
                                 p_fact_conv in number,
                                 p_cost_mmnn out number,
                                 p_cost_mmee out number) is
    v_cost_mmnn number := 0;
    v_cost_mmee number := 0;
    v_fact_conv number;
  begin
  
    select pp.prpe_cost_prom_fini_mmnn, pp.prpe_cost_prom_fini_mmee
      into v_cost_mmnn, v_cost_mmee
      from come_prod_peri pp, come_peri p
     where pp.prpe_peri_codi = p.peri_codi
       and p_fech_movi between p.peri_fech_inic and p.peri_fech_fini
       and pp.prpe_prod_codi = p_prod_codi;
  
    if nvl(p_fact_conv, 0) <= 0 then
      v_fact_conv := 1;
    else
      v_fact_conv := p_fact_conv;
    end if;
    p_cost_mmnn := v_cost_mmnn * nvl(v_fact_conv, 1);
    p_cost_mmee := v_cost_mmee * nvl(v_fact_conv, 1);
  
  exception
    when no_data_found then
      null;
    /*  raise_application_error(-20010,
                              'Atención avise al administrador!!!, el producto' ||
                              p_prod_codi ||
                              ' no tiene registro alguno para este periodo!!!');*/
  end pp_busca_costo_prome;

  procedure pp_traer_datos_codi_barr(p_prod_codi in number,
                                     p_medi_codi in number,
                                     p_codi_barr out varchar2,
                                     p_fact_conv out number) is
  begin
  
    select d.coba_codi_barr, d.coba_fact_conv
      into p_codi_barr, p_fact_conv
      from come_prod_coba_deta d
     where d.coba_prod_codi = p_prod_codi
       and d.coba_medi_codi = p_medi_codi;
  
  exception
    when no_data_found then
      null;
  end pp_traer_datos_codi_barr;

  procedure pp_busca_tasa_mmee(p_mone_codi in number,
                               p_mone_coti out number,
                               p_fech      in date) is
  begin
  
    if parameter.p_codi_mone_mmnn = p_mone_codi then
      p_mone_coti := 1;
    else
      select coti_tasa
        into p_mone_coti
        from come_coti
       where coti_mone = p_mone_codi
         and coti_fech = p_fech
         and coti_tica_codi = parameter.p_tica_codi_soli_mate;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Cotizaciion Inexistente para la moneda extranjera  ' ||
                              parameter.p_codi_mone_mmee);
  end pp_busca_tasa_mmee;

  procedure pp_borrar_det(i_seq_id in number) as
  begin
    apex_collection.delete_member(p_collection_name => 'DETALLE',
                                  p_seq             => i_seq_id);
    apex_collection.resequence_collection(p_collection_name => 'DETALLE');
  
  end pp_borrar_det;

  procedure pp_add_det(i_det_prod_codi  in number,
                       i_det_prod_lote  in number,
                       i_movi_fech_emis in date,
                       i_det_cant       in number,
                       i_prod_medi_codi in number) as
  
    v_deta_medi_codi      number;
    v_prod_indi_lote      varchar2(2);
    v_deta_lote_codi      varchar2(2);
    v_deta_cant_medi      number;
    v_deta_prec_unit      number;
    v_deta_prec_unit_mmee number;
    v_prod_desc           come_prod.prod_desc%type;
    v_prod_codi_barr      come_prod.prod_desc%type;
    v_coba_fact_conv      number;
  
    procedure pp_trae_unid_medi is
    begin
      select medi_codi
        into v_deta_medi_codi
        from come_unid_medi
       where medi_codi = i_prod_medi_codi; /*in
                                                                             (select coba_medi_codi
                                                                                from come_prod_coba_deta
                                                                               where coba_prod_codi = i_det_prod_codi);*/
    end pp_trae_unid_medi;
  
    procedure pp_mostrar_producto is
      v_ind_inactivo char(1);
    begin
      select prod_desc,
             -- prod_codi,
             nvl(prod_indi_inac, 'N'),
             prod_codi_barr,
             --prod_codi_fabr,
             nvl(prod_indi_lote, 'N')
        into v_prod_desc,
             --:bdet.deta_prod_codi,
             v_ind_inactivo,
             v_prod_codi_barr,
             --:bdet.prod_codi_fabr,
             v_prod_indi_lote
        from come_prod
       where prod_codi = i_det_prod_codi;
    
      if v_ind_inactivo = 'S' then
        raise_application_error(-20010,
                                'El producto se encuentra inactivo');
      end if;
    
    exception
      when no_data_found then
        raise_application_error(-20010, 'Producto inexistente!');
    end pp_mostrar_producto;
  
  begin
    if not
        (apex_collection.collection_exists(p_collection_name => 'DETALLE')) then
      apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');
    end if;
  
    if i_prod_medi_codi is null then
      raise_application_error(-20010,
                              'La unidad de medida no puede ser nulo');
    end if;
  
    pp_trae_unid_medi;
    pp_mostrar_producto;
  
    pp_traer_datos_codi_barr(p_prod_codi => i_det_prod_codi,
                             p_medi_codi => v_deta_medi_codi,
                             p_codi_barr => v_prod_codi_barr,
                             p_fact_conv => v_coba_fact_conv);
  
    pp_busca_costo_prome(p_prod_codi => i_det_prod_codi,
                         p_fech_movi => nvl(i_movi_fech_emis, trunc(sysdate)),
                         p_fact_conv => v_coba_fact_conv,
                         p_cost_mmnn => v_deta_prec_unit,
                         p_cost_mmee => v_deta_prec_unit_mmee);
  
    apex_collection.add_member(p_collection_name => 'DETALLE',
                               p_c001            => i_det_prod_codi,
                               p_c002            => i_det_cant *
                                                    nvl(v_coba_fact_conv, 1),
                               p_c003            => v_deta_medi_codi,
                               p_c004            => v_prod_indi_lote,
                               p_c005            => i_det_prod_lote, --v_deta_lote_codi,
                               p_c006            => i_det_cant,
                               p_c007            => v_deta_prec_unit,
                               p_c008            => v_deta_prec_unit_mmee);
  
  end pp_add_det;

  procedure pp_set_variable is
  begin
  
    bcab.movi_fech_emis      := v('P92_MOVI_FECH_EMIS');
    bcab.movi_nume           := v('P92_MOVI_NUME');
    bcab.movi_sucu_codi_orig := v('P92_MOVI_SUCU_CODI_ORIG');
    bcab.movi_depo_codi_orig := v('P92_MOVI_DEPO_CODI_ORIG');
    bcab.movi_obse           := v('P92_MOVI_OBSE');
    bcab.movi_empl_codi      := v('P92_MOVI_EMPL_CODI');
    bcab.movi_ortr_codi      := v('P92_MOVI_ORTR_CODI');
    bcab.movi_tasa_mmee      := v('P92_MOVI_TASA_MMEE');
    pp_buscar_nume(p_nume => bcab.movi_nume);
  
    /*  bcab.movi_fech_grab           := v('P92_MOVI_FECH_GRAB');
    
    bcab.movi_codi           := v('P92_MOVI_CODI');
    bcab.movi_user                := v('P92_MOVI_USER');
    bcab.movi_oper_codi           := v('P92_MOVI_OPER_CODI');
    bcab.movi_stoc_suma_rest      := v('P92_MOVI_STOC_SUMA_REST');
    bcab.movi_stoc_afec_cost_prom := v('P92_MOVI_STOC_AFEC_COST_PROM');
    bcab.movi_soma_codi           := v('P92_MOVI_SOMA_CODI');*/
    bcab.w_soma_indi_espe := 'N';
  
  end pp_set_variable;

  procedure pp_validacion is
  begin
    if bcab.movi_fech_emis is null then
      raise_application_error(-20010, 'Debe ingresar la fecha');
    end if;
  
    if bcab.movi_depo_codi_orig is null then
      raise_application_error(-20010,
                              'Debe ingresar el codigo del Deposito');
    end if;
  
    if bcab.movi_sucu_codi_orig is null then
      raise_application_error(-20010,
                              'Debe ingresar el codigo de Sucursal');
    end if;
  
    if bcab.movi_empl_codi is null then
      raise_application_error(-20010, 'Debe ingresar el responsable');
    end if;
  
    if bcab.movi_ortr_codi is null then
      raise_application_error(-20010,
                              'Debe ingresar el Numero de Orden de trabajo');
    end if;
  
    --    bcab.movi_obse      := v('P92_MOVI_OBSE');
    --    bcab.movi_tasa_mmee := v('P92_MOVI_TASA_MMEE');
  
  end;

  procedure pp_actualizar_registro is
  begin
    if bcab.g_ind_salta_set = 'N' then
      pp_set_variable;
    end if;
  
    pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
    pp_validacion;
    pp_valida_fech(bcab.movi_fech_emis);
    pp_reenumerar_nro_item('S');
    pp_validar_repeticion_prod;
  
    if nvl(parameter.p_indi_vali_limi_costo, 'N') = 'S' and
       bcab.g_ind_salta_set = 'N' then
      pp_validar_limi_cost(bcab.movi_ortr_codi,
                           nvl(g_bdet.sum_deta_impo_mmnn, 0));
    end if;
    pp_verifica_nume;
  
    pp_actualiza_come_movi;
  
    --raise_application_error(-20010, 'aca');
  
    pp_actualiza_come_movi_prod;
  
    pp_actu_secu;
    if nvl(bcab.w_soma_indi_espe, 'N') = 'N' and bcab.g_ind_salta_set = 'N' then
      pp_actu_cant_usad_pres; --actualiza cantidad usada en presupuesto.
    end if;
    if bcab.movi_soma_codi is not null then
      pp_actu_sald_soli_mate(bcab.movi_soma_codi, 'I');
    end if;
    pp_actu_cant_usad_pres_ortr;
    -- pp_llama_reporte;     
  end pp_actualizar_registro;

  procedure pp_generar_salida_producto(i_ortr_codi        in number,
                                       i_ortr_serv_obse   in varchar2,
                                       i_ortr_form_insu   in number,
                                       i_ortr_empl_codi   in number,
                                       i_ortr_lote_equipo in number,
                                       i_ortr_clpr_codi   in number,
                                       i_ortr_nume        in number) is
  
    v_orde_trab_vehi come_orde_trab_vehi%rowtype;
    v_bandera_det    number;
    v_lote_codi      number;
    v_fecha_inst     date;
  
    cursor cur_form is
      select t.cofid_codi,
             t.cofid_prod_codi,
             t.cofid_cant,
             t.cofid_reutiilizable,
             t.cofid_medi_codi
        from come_ortr_form_insu_det t
       where t.cofid_codi = i_ortr_form_insu;
  
    function fp_buscar_lote(i_product_codi in number) return number is
      v_return number;
    begin
      select t.lote_codi
        into v_return
        from come_lote t
       where t.lote_codi = i_ortr_lote_equipo
         and t.lote_prod_codi = i_product_codi;
      return v_return;
    exception
      when no_data_found then
        return null;
    end fp_buscar_lote;
  
  begin
  
    if i_ortr_form_insu is null then
      raise_application_error(-20010, 'La formula no puede ser nulo');
    end if;
  
    if i_ortr_empl_codi is null then
      raise_application_error(-20010, 'El tecnico no puede ser nulo');
    end if;
  
    select t.ortr_fech_inst
      into v_fecha_inst
      from COME_ORDE_TRAB t
     where t.ortr_codi = i_ortr_codi;
  
    select *
      into v_orde_trab_vehi
      from come_orde_trab_vehi t
     where t.vehi_ortr_codi = i_ortr_codi;
  
    select t.user_depo_codi
      into bcab.movi_depo_codi_orig
      from segu_user t
     where t.user_empl_codi = v_orde_trab_vehi.vehi_empl_codi;
  
    select t.depo_sucu_codi
      into bcab.movi_sucu_codi_orig
      from come_depo t
     where t.depo_codi = bcab.movi_depo_codi_orig;
  
    -- pp_buscar_nume(p_nume => bcab.movi_nume);
  
    bcab.movi_fech_emis      := trunc(v_fecha_inst);
    bcab.movi_nume           := i_ortr_nume;
    bcab.movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    bcab.movi_depo_codi_orig := bcab.movi_depo_codi_orig;
    bcab.movi_obse           := 'Salida de producto' ||
                                substr(i_ortr_serv_obse, 0, 20);
    bcab.movi_empl_codi      := v_orde_trab_vehi.vehi_empl_codi;
    bcab.movi_ortr_codi      := i_ortr_codi;
    bcab.movi_tasa_mmee      := null;
    bcab.g_ind_salta_set     := 'S';
    bcab.movi_clpr_codi      := i_ortr_clpr_codi;
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');
  
    for x in cur_form loop
      v_bandera_det := 1;
    
      v_lote_codi := fp_buscar_lote(i_product_codi => x.cofid_prod_codi);
    
      i020040.pp_add_det(i_det_prod_codi  => x.cofid_prod_codi,
                         i_det_prod_lote  => v_lote_codi,
                         i_movi_fech_emis => trunc(v_fecha_inst),
                         i_det_cant       => x.cofid_cant,
                         i_prod_medi_codi => x.cofid_medi_codi);
    end loop;
  
    if v_bandera_det = 0 then
      raise_application_error(-20010, 'La formula no tiene ningun item');
    end if;
  
    pp_actualizar_registro;
  
  end pp_generar_salida_producto;

end i020040;
