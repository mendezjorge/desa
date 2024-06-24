
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020058" is

  type r_parameter is record(
    p_codi_oper_tras_mas number := to_number(general_skn.fl_busca_parametro('p_codi_oper_tras_mas')),
    p_codi_oper_tras_men number := to_number(general_skn.fl_busca_parametro('p_codi_oper_tras_men')),
    p_perm_stoc_nega     varchar2(500) := ltrim(rtrim(general_skn.fl_busca_parametro('p_perm_stoc_nega'))),
    
    p_codi_base number := pack_repl.fa_devu_codi_base);

  parameter r_parameter;

  type r_bcab is record(
    movi_codi           come_movi.movi_codi%type,
    movi_user           come_movi.movi_user%type,
    movi_codi_padr      come_movi.movi_codi_padr%type,
    movi_sucu_codi_dest come_movi.movi_sucu_codi_dest%type,
    movi_depo_codi_dest come_movi.movi_depo_codi_dest%type,
    movi_sucu_codi_orig come_movi.movi_sucu_codi_orig%type,
    movi_depo_codi_orig come_movi.movi_depo_codi_orig%type,
    movi_nume           come_movi.movi_nume%type,
    movi_fech_emis      come_movi.movi_fech_emis%type,
    movi_fech_grab      come_movi.movi_fech_grab%type,
    movi_empr_codi      come_movi.movi_empr_codi%type,
    movi_obse           come_movi.movi_obse%type);

  bcab r_bcab;

  cursor cur_bdet is
    select seq_id deta_nume_item,
           c001   deta_prod_codi,
           c002   deta_lote_codi,
           c003   deta_cant,
           c004   deta_medi_codi,
           c005   deta_cant_medi
      from apex_collections a
     where a.collection_name = 'CUR_BDET';

  procedure pl_me(i_texto in varchar2) is
  begin
    raise_application_error(-20010, i_texto);
  end pl_me;

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
                                p_movi_empl_codi           in number) is
  
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
       movi_base)
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
       parameter.p_codi_base);
  
  end pp_insert_come_movi;

  procedure pp_insert_come_movi_prod_deta(p_deta_movi_codi         in number,
                                          p_deta_nume_item         in number,
                                          p_deta_impu_codi         in number,
                                          p_deta_prod_codi         in number,
                                          p_deta_lote_codi         in number,
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
                                          p_deta_list_codi         in number) is
  begin
    insert into come_movi_prod_deta
      (deta_movi_codi,
       deta_nume_item,
       deta_impu_codi,
       deta_prod_codi,
       deta_lote_codi,
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
       deta_base)
    values
      (p_deta_movi_codi,
       p_deta_nume_item,
       p_deta_impu_codi,
       p_deta_prod_codi,
       p_deta_lote_codi,
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
       parameter.p_codi_base);
  end pp_insert_come_movi_prod_deta;

  function fp_dev_indi_suma_rest(p_oper_codi in number) return varchar2 is
    v_stoc_suma_rest varchar2(1);
  begin
    select oper_stoc_suma_rest
      into v_stoc_suma_rest
      from come_stoc_oper
     where oper_codi = p_oper_codi;
  
    return v_stoc_suma_rest;
  exception
    when no_data_found then
      pl_me('Codigo de Operacion Inexistente');
  end fp_dev_indi_suma_rest;

  procedure pp_reenumerar_nro_item is
  
  begin
    null;
    /* go_block('bdet');
      first_record;
      if bdet.deta_prod_codi is null then
         pl_me('debe ingresar al menos un item');
      end if;
      loop
         v_nro_item := v_nro_item + 1;
        bdet.deta_nume_item := v_nro_item;
        exit when :system.last_record = upper('true');
        next_record;
      end loop;
    */
  end pp_reenumerar_nro_item;

  procedure pp_validar_repeticion_prod is
  
    i          number;
    j          number;
    salir      exception;
    v_ant_art  number;
    v_ant_lote number;
  
    type t_cursor is table of cur_bdet%rowtype;
    bull_cur t_cursor;
  
  begin
  
    open cur_bdet;
  
    -- fetch rows from the cursor into the collection
    fetch cur_bdet bulk collect
      into bull_cur;
  
    -- close the cursor
    close cur_bdet;
  
    for i in 1 .. bull_cur.count loop
      v_ant_art  := bull_cur(i).deta_prod_codi;
      v_ant_lote := bull_cur(i).deta_lote_codi;
      for j in 1 .. bull_cur.count loop
        if v_ant_art = bull_cur(j).deta_prod_codi and
           v_ant_lote = bull_cur(j).deta_lote_codi and bull_cur(i).deta_nume_item <> bull_cur(j).deta_nume_item and bull_cur(i).deta_lote_codi <> bull_cur(j).deta_lote_codi then
          pl_me('El codigo de Producto del item ' ||
                to_char(bull_cur(i).deta_nume_item) ||
                ' se repite con el del item ' ||
                to_char(bull_cur(j).deta_nume_item) ||
                '. asegurese de no introducir mas de una' ||
                ' vez el mismo codigo!');
        end if;
      end loop;
    end loop;
  
    if bull_cur.count = 0 then
      pl_me('Debe ingresar al menos un item');
    end if;
  
  exception
    when salir then
      null;
  end pp_validar_repeticion_prod;

  procedure pp_veri_nume(p_nume in out number) is
    v_nume number;
  begin
    v_nume := p_nume;
    loop
      begin
        select movi_nume
          into v_nume
          from come_movi
         where movi_nume = v_nume
           and movi_oper_codi = 3;
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          exit;
        when too_many_rows then
          v_nume := v_nume + 1;
      end;
    end loop;
    p_nume := v_nume;
  end pp_veri_nume;

  procedure pp_buscar_nume(p_nume out number) is
  begin
  
    select (nvl(max(movi_nume), 0) + 1) nume
      into p_nume
      from come_movi
     where movi_oper_codi = 3;
  
    pp_veri_nume(p_nume);
  
  exception
    when no_data_found then
      pl_me('Codigo de Secuencia no fue correctamente asignada a la terminal');
  end pp_buscar_nume;

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

  
  
  
  begin
  
    ---primero insertar el traslado mas
  
    --- asignar valores....
    bcab.movi_codi      := fa_sec_come_movi;
    bcab.movi_fech_grab := sysdate;
    bcab.movi_user      := fa_user;
    bcab.movi_codi_padr := null;
  
    v_movi_codi      := bcab.movi_codi;
    v_movi_timo_codi := null;
    v_movi_clpr_codi := null;
  
    --invertido para el traslado(+) -----------------------------------
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_dest;
    v_movi_depo_codi_orig := bcab.movi_depo_codi_dest;
    v_movi_sucu_codi_dest := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_dest := bcab.movi_depo_codi_orig;
    --------------------------------------------------------------------
  
    v_movi_oper_codi := parameter.p_codi_oper_tras_mas;
  
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := null;
    v_movi_nume                := bcab.movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := bcab.movi_fech_grab;
    v_movi_user                := bcab.movi_user;
    v_movi_codi_padr           := bcab.movi_codi_padr;
    v_movi_tasa_mone           := null;
    v_movi_tasa_mmee           := null;
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
    v_movi_stoc_suma_rest      := fp_dev_indi_suma_rest(parameter.p_codi_oper_tras_mas);
    v_movi_clpr_dire           := null;
    v_movi_clpr_tele           := null;
    v_movi_clpr_ruc            := null;
    v_movi_clpr_desc           := null;
    v_movi_emit_reci           := null;
    v_movi_afec_sald           := null;
    v_movi_dbcr                := null;
    v_movi_stoc_afec_cost_prom := 'N';
    v_movi_empr_codi           := bcab.movi_empr_codi;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := null;
  
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
                        v_movi_empl_codi);
    --------------------------------------------------------------------------------------------------------------
    --  ahora insertar el traslado menos
  
    --- asignar valores....
    bcab.movi_codi_padr := bcab.movi_codi;
    bcab.movi_codi      := fa_sec_come_movi;
    bcab.movi_fech_grab := sysdate;
    bcab.movi_user      := fa_user;
  
    v_movi_codi      := bcab.movi_codi;
    v_movi_timo_codi := null;
    v_movi_clpr_codi := null;
  
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    v_movi_depo_codi_orig := bcab.movi_depo_codi_orig;
    v_movi_sucu_codi_dest := bcab.movi_sucu_codi_dest;
    v_movi_depo_codi_dest := bcab.movi_depo_codi_dest;
    --------------------------------------------------------------------
  
    v_movi_oper_codi := parameter.p_codi_oper_tras_men;
  
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := null;
    v_movi_nume                := bcab.movi_nume;
    v_movi_fech_emis           := bcab.movi_fech_emis;
    v_movi_fech_grab           := bcab.movi_fech_grab;
    v_movi_user                := bcab.movi_user;
    v_movi_codi_padr           := bcab.movi_codi_padr;
    v_movi_tasa_mone           := null;
    v_movi_tasa_mmee           := null;
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
    v_movi_stoc_suma_rest      := fp_dev_indi_suma_rest(parameter.p_codi_oper_tras_men);
    v_movi_clpr_dire           := null;
    v_movi_clpr_tele           := null;
    v_movi_clpr_ruc            := null;
    v_movi_clpr_desc           := null;
    v_movi_emit_reci           := null;
    v_movi_afec_sald           := null;
    v_movi_dbcr                := null;
    v_movi_stoc_afec_cost_prom := 'N';
    v_movi_empr_codi           := bcab.movi_empr_codi;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := null;

 
 
  
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
                        v_movi_empl_codi);
  
  end pp_actualiza_come_movi;

  procedure pp_actualiza_come_movi_prod is
    v_deta_movi_codi         number;
    v_deta_nume_item         number;
    v_deta_impu_codi         number;
    v_deta_prod_codi         number;
    v_deta_lote_codi         number;
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
    -----------------------------------
    v_deta_movi_codi2 number;
    -----------------------------------
  
  begin
    ----insertar el detalle para el traslado (+) y (-)
  
    v_deta_movi_codi  := bcab.movi_codi;
    v_deta_movi_codi2 := bcab.movi_codi_padr;
  
    for bdet in cur_bdet loop
      v_deta_nume_item         := bdet.deta_nume_item;
      v_deta_impu_codi         := null;
      v_deta_prod_codi         := bdet.deta_prod_codi;
      v_deta_lote_codi         := bdet.deta_lote_codi;
      v_deta_cant              := bdet.deta_cant;
      v_deta_obse              := null;
      v_deta_porc_deto         := null;
      v_deta_impo_mone         := null;
      v_deta_impo_mmnn         := null;
      v_deta_impo_mmee         := null;
      v_deta_iva_mmnn          := null;
      v_deta_iva_mmee          := null;
      v_deta_iva_mone          := null;
      v_deta_prec_unit         := 0;
      v_deta_movi_codi_padr    := null;
      v_deta_nume_item_padr    := null;
      v_deta_impo_mone_deto_nc := null;
      v_deta_movi_codi_deto_nc := null;
      v_deta_list_codi         := null;
    
      pp_insert_come_movi_prod_deta(v_deta_movi_codi,
                                    v_deta_nume_item,
                                    v_deta_impu_codi,
                                    v_deta_prod_codi,
                                    v_deta_lote_codi,
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
                                    v_deta_list_codi);
    
      pp_insert_come_movi_prod_deta(v_deta_movi_codi2,
                                    v_deta_nume_item,
                                    v_deta_impu_codi,
                                    v_deta_prod_codi,
                                    v_deta_lote_codi,
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
                                    v_deta_list_codi);
    
    -- exit when :system.last_record = upper('true');
    -- next_record;
    end loop;
  
  end pp_actualiza_come_movi_prod;

  procedure pp_validar_existencia(i_prod_codi in number,
                                  i_deta_cant in number,
                                  i_lote_codi in number,
                                  i_depo_codi in number) is
  
    v_existencia number;
    e_salir      exception;
    v_prod_desc  varchar2(50);
  begin
  
    if parameter.p_perm_stoc_nega = 'N' then
      if i_depo_codi is null then
        pl_me('El deposito no puede ser nulo');
      end if;
    
      select substr(t.prod_desc, 0, 20)
        into v_prod_desc
        from COME_PROD t
       where t.prod_codi = i_prod_codi;
    
      -- call the function
      v_existencia := fa_dev_stoc_actu_lote(p_prod_codi => i_prod_codi,
                                            p_depo_codi => i_depo_codi,
                                            p_lote_codi => i_lote_codi);
    
      if nvl(v_existencia, 0) - nvl(i_deta_cant, 0) < 0 then
        raise_application_error(-20010,
                                'ATENCION!!!, El producto:' || v_prod_desc ||
                                ',no permite stock en negativo cantidad actual :' ||
                                v_existencia);
      end if;
    end if;
  
  end pp_validar_existencia;

  procedure pp_add_det(i_deta_prod_codi in number,
                       i_deta_cant      in number,
                       i_deta_lote_codi in number,
                       i_deta_medi_codi in number,
                       i_depo_codi_orig in number) is
  
    v_deta_cant_medi number;
    v_fact_conv      number;
  begin
  
    if i_deta_prod_codi is null then
      pl_me('El codigo del producto no puede ser nulo. WV');
    end if;
  
    if nvl(i_deta_cant, 0) <= 0 then
      pl_me('Cantidad a trasladar. Debe ser mayor a 0');
    end if;
  
    if i_deta_lote_codi is null then
      pl_me('Debe ingresar el lote!');
    end if;
  
    if i_deta_medi_codi is null then
      pl_me('Debe ingresar unidad de medida');
    end if;
  
    select min(nvl(d.coba_fact_conv, 1))
      into v_fact_conv
      from come_prod_coba_deta d
     where d.coba_medi_codi = i_deta_medi_codi
       and d.coba_prod_codi = i_deta_prod_codi;
    -- pl_me(i_deta_lote_codi);
    pp_validar_existencia(i_prod_codi => i_deta_prod_codi,
                          i_deta_cant => i_deta_cant,
                          i_lote_codi => i_deta_lote_codi,
                          i_depo_codi => i_depo_codi_orig);
  
    v_deta_cant_medi := i_deta_cant;
  
    apex_collection.add_member(p_collection_name => 'CUR_BDET',
                               p_c001            => i_deta_prod_codi, --deta_prod_codi
                               p_c002            => i_deta_lote_codi, --deta_lote_codi
                               p_c003            => i_deta_cant, --deta_cant
                               p_c004            => i_deta_medi_codi, --deta_medi_codi
                               p_c005            => v_deta_cant_medi --deta_cant_medi
                               );
  
  end pp_add_det;

  procedure pp_borrar_det(i_seq_id in number) is
   
  begin
    null;
  
    apex_collection.delete_member(p_collection_name => 'CUR_BDET',
                                  p_seq             => i_seq_id);
  
    apex_collection.resequence_collection(p_collection_name => 'CUR_BDET');
  
  end pp_borrar_det;

  procedure pp_set_variable is
  begin
  
    bcab.movi_nume           := v('P61_MOVI_NUME');
    bcab.movi_fech_emis      := v('P61_MOVI_FECH_EMIS');
    bcab.movi_depo_codi_orig := v('P61_MOVI_DEPO_CODI_ORIG');
    bcab.movi_sucu_codi_orig := v('P61_MOVI_SUCU_CODI_ORIG');
    bcab.movi_depo_codi_dest := v('P61_MOVI_DEPO_CODI_DEST');
    bcab.movi_sucu_codi_dest := v('P61_MOVI_SUCU_CODI_DEST');
    bcab.movi_codi           := v('P61_MOVI_CODI');
    bcab.movi_empr_codi      := v('P61_MOVI_EMPR_CODI');
    bcab.movi_obse           := v('P61_MOVI_OBSE');
  
  end pp_set_variable;

  procedure pp_validar is
  begin
    if bcab.movi_fech_emis is null then
      pl_me('La fecha no puede ser nulo');
    end if;
  
    if bcab.movi_depo_codi_orig is null then
      pl_me('El deposito origen no puede ser nulo');
    end if;
  
    if bcab.movi_depo_codi_dest is null then
      pl_me('El deposito destino no puede ser nulo');
    end if;
  
  end pp_validar;

  procedure pp_iniciar is
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_BDET');
  end pp_iniciar;

  procedure pp_llamar_reporte(i_clave in number) as
  begin
    null;
  end pp_llamar_reporte;

  procedure pp_imprimir_reporte(i_movi_codi in varchar2) is
    v_report       varchar2(50);
    v_parametros   clob;
    v_contenedores clob;
  
  begin
    --60503701
    v_contenedores := 'p_movi_codi';
    v_parametros   := i_movi_codi;
    v_report       := 'I020002';
  
    delete from come_parametros_report where usuario = fa_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, fa_user, v_report, 'pdf', v_contenedores);
  
    commit;
  end pp_imprimir_reporte;

  procedure pp_exist_dep(i_dep_codi in number) as
    cursor cur_exist is
      select t.prod_codi,
             t.prde_cant_actu,
             t.lote_codi,
             t.prod_medi_codi,
             depo_codi
        from v_come_depo_sucu_prod_lote t
       where t.depo_codi = i_dep_codi
         and t.prde_cant_actu > 0;
  
  begin
  
    if i_dep_codi is null then
      pl_me('Debe cargar el deposito origen');
    end if;
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'CUR_BDET');
  
    for c in cur_exist loop
      -- call the procedure
      pp_add_det(i_deta_prod_codi => c.prod_codi,
                 i_deta_cant      => c.prde_cant_actu,
                 i_deta_lote_codi => c.lote_codi,
                 i_deta_medi_codi => c.prod_medi_codi,
                 i_depo_codi_orig => c.depo_codi);
    end loop;
  end pp_exist_dep;

  procedure pp_validar_detalle is
  begin
  
    for bdet in (select c001 deta_prod_codi,
                        c002 deta_lote_codi,
                        sum(c003) deta_cant
                   from apex_collections a
                  where a.collection_name = 'CUR_BDET'
                  group by c001, c002) loop
    
      pp_validar_existencia(i_prod_codi => bdet.deta_prod_codi,
                            i_deta_cant => bdet.deta_cant,
                            i_lote_codi => bdet.deta_lote_codi,
                            i_depo_codi => bcab.movi_depo_codi_orig);
    
    end loop;
  
  end pp_validar_detalle;

  procedure pp_actualizar_registro is
  begin
  
    pp_set_variable;
    pp_validar;
    pp_validar_detalle;
    pp_reenumerar_nro_item;
    pp_validar_repeticion_prod;
    pp_buscar_nume(bcab.movi_nume);
    pp_actualiza_come_movi;
    pp_actualiza_come_movi_prod;
  
    /*  commit_form;
    
      if not form_success then
        clear_form(no_validate);
        message('registro no actualizado !', no_acknowledge);
      else
        pp_llama_reporte;
        clear_form(no_validate);
        message('registro actualizado.', no_acknowledge);
        go_block('bcab');
      end if;
    
      if form_failure then
        raise form_trigger_failure;
      end if;
      pp_iniciar;
    */
  
    apex_application.g_print_success_message := 'Registro actualizado.
                                                <a href="javascript:$s(''P61_MOVI_CODI_IMPRIMIR'',' ||
                                                bcab.movi_codi || ');">' ||
                                                bcab.movi_nume || '</a>';
  
  end pp_actualizar_registro;

end i020058;
