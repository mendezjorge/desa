
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020001" is

  bcab come_movi%rowtype;
  --bdet come_movi_prod_deta%rowtype;

  type r_parameter is record(
    p_peco               number := 1,
    p_codi_oper_ajus_mas number := to_number(general_skn.fl_busca_parametro('p_codi_oper_ajus_mas')),
    p_codi_oper_ajus_men number := to_number(general_skn.fl_busca_parametro('p_codi_oper_ajus_men')),
    p_fech_inic          date,
    p_fech_fini          date,
    collection_name      varchar2(25) := 'AJUSTES_DET',
    p_codi_base          number := 1,
    p_movi_codi          number,
    p_codi_peri_actu     number := general_skn.fl_busca_parametro('p_codi_peri_actu'));
  parameter r_parameter;

  cursor g_cursor_det is
    select det.seq_id deta_nume_item,
           det.c001   deta_prod_codi,
           det.c002   s_producto_cf,
           det.c003   s_producto_desc,
           det.c004   deta_cant,
           det.c005   deta_lote_codi
      from apex_collections det
     where det.collection_name = parameter.collection_name;

  --begin

  -----------------------------------------------
  procedure pp_set_variable is
  begin
    -- bcab.movi_codi_imprimir       := v('p43_movi_codi_imprimir');
    bcab.movi_nume           := v('P43_MOVI_NUME');
    bcab.movi_oper_codi      := v('P43_MOVI_OPER_CODI');
    bcab.movi_fech_emis      := v('P43_MOVI_FECH_EMIS');
    bcab.movi_depo_codi_orig := v('P43_MOVI_DEPO_CODI_ORIG');
    bcab.movi_sucu_codi_orig := v('P43_MOVI_SUCU_CODI_ORIG');
    --bcab.movi_sucu_desc_orig      := v('p43_movi_sucu_desc_orig');
    bcab.movi_obse                := v('P43_MOVI_OBSE');
    bcab.movi_stoc_suma_rest      := v('P43_MOVI_STOC_SUMA_REST');
    bcab.movi_stoc_afec_cost_prom := v('P43_MOVI_STOC_AFEC_COST_PROM');
  
  end pp_set_variable;

  -----------------------------------------------
  procedure pp_buscar_nume(p_nume out number) is
  begin
    --pp_cargar_parametros
    select (nvl(secu_nume_ajus, 0) + 1) nume
      into p_nume
      from come_secu s, come_pers_comp t
     where s.secu_codi = t.peco_secu_codi
       and t.peco_codi = parameter.p_peco;
  
    begin
      loop
        begin
          select movi_nume
            into p_nume
            from come_movi
           where movi_nume = p_nume
             and movi_oper_codi in
                 (parameter.p_codi_oper_ajus_mas,
                  parameter.p_codi_oper_ajus_men);
          p_nume := p_nume + 1;
        
        exception
          when no_data_found then
            exit;
          when too_many_rows then
            p_nume := p_nume + 1;
        end;
      end loop;
      --:bcab.movi_nume := p_nume;
    end;
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Codigo de Secuencia no fue correctamente asignada a la terminal');
    when others then
      raise_application_error(-20010, 'Error; ' || sqlerrm);
  end pp_buscar_nume;

  -----------------------------------------------
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
       parameter.p_codi_base);
  
    parameter.p_movi_codi := p_movi_codi;
  
  exception
    when others then
      raise_application_error(-20010,
                              'Error en la insercion de datos! ' || sqlerrm);
  end pp_insert_come_movi;

  -----------------------------------------------
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
                                          p_deta_lote_codi         in number,
                                          p_deta_base              in number) is
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
       parameter.p_codi_base);
  
  end pp_insert_come_movi_prod_deta;

  -----------------------------------------------
  procedure pp_mostrar_operacion(i_movi_oper_codi           in number,
                                 i_movi_stoc_suma_rest      out varchar2,
                                 i_movi_stoc_afec_cost_prom out varchar2) is
  begin
  
    if i_movi_oper_codi not in
       (parameter.p_codi_oper_ajus_mas, parameter.p_codi_oper_ajus_men) then
      raise_application_error(-20010, 'Operacion no Valida');
    end if;
  
    select oper_stoc_suma_rest, oper_stoc_afec_cost_prom
      into i_movi_stoc_suma_rest, i_movi_stoc_afec_cost_prom
      from come_stoc_oper
     where oper_codi = i_movi_oper_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Operacion inexistente!');
    when others then
      raise_application_error(-20010, 'Error!. ' || sqlerrm);
  end pp_mostrar_operacion;

  -----------------------------------------------
  procedure pp_valida_nume is
    v_count number;
  begin
  
    select count(*)
      into v_count
      from come_movi
     where movi_nume = bcab.movi_nume
       and movi_oper_codi in
           (parameter.p_codi_oper_ajus_mas, parameter.p_codi_oper_ajus_men);
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Atencion! El n?mero de ajuste ingresado ya existe!');
    end if;
  end pp_valida_nume;

  -----------------------------------------------
  procedure pp_valida_fech(p_fech in date) is
  begin
  
    pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
  
    if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
    
      raise_application_error(-20010,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(parameter.p_fech_inic, 'dd-mm-yyyy') ||
                              ' y ' ||
                              to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
    end if;
  
  end pp_valida_fech;

  -----------------------------------------------
  procedure pp_reenumerar_nro_item is
    v_nro_item number := 0;
  
  begin
    null;
    /*for bdet in g_cursor_det loop
      v_nro_item          := v_nro_item + 1;
      bdet.deta_nume_item := v_nro_item;
    end loop;
    
    if v_nro_item < 1 then
      raise_application_error(-20010, 'debe ingresar al menos un item');
    end if;*/
  
  end pp_reenumerar_nro_item;

  -----------------------------------------------
  procedure pp_validar_repeticion_prod is
    v_cant_reg number; --cantidad de registros en el bloque
    i          number;
    j          number;
    salir      exception;
    v_ant_art  number;
    v_ant_lote number;
  
    type t_cursor is table of g_cursor_det%rowtype;
    bull_cur t_cursor;
  
  begin
  
    open g_cursor_det;
  
    -- fetch rows from the cursor into the collection
    fetch g_cursor_det bulk collect
      into bull_cur;
  
    -- close the cursor
    close g_cursor_det;
  
    for i in 1 .. bull_cur.count loop
      v_ant_art  := bull_cur(i).deta_prod_codi;
      v_ant_lote := bull_cur(i).deta_lote_codi;
      for j in 1 .. bull_cur.count loop
        if v_ant_art = bull_cur(j).deta_prod_codi and
           v_ant_lote = bull_cur(j).deta_lote_codi and bull_cur(i).deta_nume_item <> bull_cur(j).deta_nume_item and bull_cur(i).deta_lote_codi <> bull_cur(j).deta_lote_codi then
          raise_application_error(-20010,
                                  'El codigo de Producto del item ' ||
                                  to_char(bull_cur(i).deta_nume_item) ||
                                  ' se repite con el del item ' ||
                                  to_char(bull_cur(j).deta_nume_item) ||
                                  '. asegurese de no introducir mas de una' ||
                                  ' vez el mismo codigo!');
        end if;
      end loop;
    end loop;
  
    if bull_cur.count = 0 then
      raise_application_error(-20010, 'Debe ingresar al menos un item');
    end if;
  
  exception
    when salir then
      null;
  end pp_validar_repeticion_prod;

  -----------------------------------------------
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
  
    --- asignar valores....
    bcab.movi_codi      := fa_sec_come_movi;
    bcab.movi_fech_grab := sysdate;
    bcab.movi_user      := gen_user;
  
    ---------------------------------------
    v_movi_codi                := bcab.movi_codi;
    v_movi_timo_codi           := null;
    v_movi_clpr_codi           := null;
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
  exception
    when others then
      raise_application_error(-20010, 'Error. ' || sqlerrm);
  end pp_actualiza_come_movi;

  -----------------------------------------------
  function fp_devu_lote_000000(p_prod_codi in number) return number is
    v_lote_codi number;
  begin
  
    select lote_codi
      into v_lote_codi
      from come_lote
     where lote_prod_codi = p_prod_codi
       and lote_desc = '000000';
    return v_lote_codi;
  exception
    when no_data_found then
      return v_lote_codi;
  end fp_devu_lote_000000;

  -----------------------------------------------
  procedure pp_actualiza_come_movi_prod is
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
    v_nro_item               number := 0;
  begin
  
    v_deta_movi_codi := bcab.movi_codi;
    --raise_application_error(-20010,'bcab.movi_codi: '||bcab.movi_codi);
  
    for bdet in g_cursor_det loop
    
      v_deta_nume_item         := bdet.deta_nume_item; --bdet.nro;--deta_nume_item;      
      v_deta_prod_codi         := bdet.deta_prod_codi;
      v_deta_cant              := bdet.deta_cant;
      v_deta_lote_codi         := bdet.deta_lote_codi; --fp_devu_lote_000000(v_deta_prod_codi);
      v_deta_impu_codi         := null;
      v_deta_obse              := null;
      v_deta_porc_deto         := null;
      v_deta_impo_mone         := null;
      v_deta_impo_mmnn         := null;
      v_deta_impo_mmee         := null;
      v_deta_iva_mmnn          := null;
      v_deta_iva_mmee          := null;
      v_deta_iva_mone          := null;
      v_deta_prec_unit         := null;
      v_deta_movi_codi_padr    := null;
      v_deta_nume_item_padr    := null;
      v_deta_impo_mone_deto_nc := null;
      v_deta_movi_codi_deto_nc := null;
      v_deta_list_codi         := null;
    
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
                                    v_deta_lote_codi,
                                    parameter.p_codi_base);
    
    end loop;
  
  exception
    when others then
      raise_application_error(-20010, 'Error. ' || sqlerrm);
  end pp_actualiza_come_movi_prod;

  -----------------------------------------------
  procedure pp_actu_secu is
  begin
  
    update come_secu
       set secu_nume_ajus = bcab.movi_nume
     where secu_codi = (select peco_secu_codi
                          from come_pers_comp
                         where peco_codi = parameter.p_peco);
  
  end pp_actu_secu;

  -----------------------------------------------
  procedure pp_buscar_prod_desc(i_deta_prod_codi  in number,
                                o_s_producto_desc out varchar2,
                                o_s_producto_cf   out number) is
  
  begin
  
    select prod_desc, prod_codi_alfa
      into o_s_producto_desc, o_s_producto_cf
      from come_prod
     where nvl(prod_indi_inac, 'N') = 'N'
       and prod_codi = i_deta_prod_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'No existe el producto seleccionado' ||
                              i_deta_prod_codi);
    when others then
      raise_application_error(-20010, 'Error, ' || sqlerrm);
  end pp_buscar_prod_desc;

  -----------------------------------------------
  procedure pp_add_det(i_deta_prod_codi in number,
                       i_deta_cant      in number,
                       i_prod_ind_lote  in varchar2,
                       i_deta_lote_codi in number) is
  
    v_producto_cf   varchar2(300);
    v_producto_desc varchar2(300);
    v_lote_codi     number;
  begin
  
    if i_deta_prod_codi is null then
      raise_application_error(-20010, 'Debe de seleccionar un producto! ');
    end if;
  
    if nvl(i_deta_cant, 0) <= 0 then
      raise_application_error(-20010, 'La cantidad debe de ser mayor a 0!');
    end if;
    if nvl(i_prod_ind_lote, 'N') = 'S' then
      v_lote_codi := i_deta_lote_codi;
    else
      v_lote_codi := fp_devu_lote_000000(p_prod_codi => i_deta_prod_codi);
    end if;
  
    if v_lote_codi is null then
      raise_application_error(-20010, 'Error lote no valido');
    
    end if;
  
    pp_buscar_prod_desc(i_deta_prod_codi  => i_deta_prod_codi,
                        o_s_producto_desc => v_producto_desc,
                        o_s_producto_cf   => v_producto_cf);
  
    apex_collection.add_member(p_collection_name => parameter.collection_name,
                               p_c001            => i_deta_prod_codi,
                               p_c002            => v_producto_cf,
                               p_c003            => v_producto_desc,
                               p_c004            => i_deta_cant,
                               p_c005            => v_lote_codi);
  
  end pp_add_det;

  procedure pp_borrar_det(i_seq_id in number) as
  begin
    apex_collection.delete_member(p_collection_name => parameter.collection_name,
                                  p_seq             => i_seq_id);
    apex_collection.resequence_collection(p_collection_name => parameter.collection_name);
  end pp_borrar_det;

  -----------------------------------------------
  procedure pp_valida_cabecera(i_movi_nume           in number,
                               i_movi_codi           in number,
                               i_movi_fech_emis      in date,
                               i_movi_depo_codi_orig in number) is
  begin
    if i_movi_nume is null then
      raise_application_error(-20010,
                              'El Nro de ajuste no puede estar vacio!');
    end if;
  
    if i_movi_codi is null then
      raise_application_error(-20010, 'La Operacion no puede estar vacio!');
    end if;
  
    if i_movi_fech_emis is null then
      raise_application_error(-20010, 'La Fecha no puede estar vacio!');
    end if;
  
    if i_movi_depo_codi_orig is null then
      raise_application_error(-20010, 'El Deposito no puede estar vacio!');
    end if;
  
  end pp_valida_cabecera;

  -----------------------------------------------
  procedure pp_actualizar_registro is
  begin
  
    pp_set_variable;
    -- raise_application_error(-20010, v('p43_movi_nume'));
  
    pp_valida_fech(bcab.movi_fech_emis);
    pp_reenumerar_nro_item;
    pp_validar_repeticion_prod;
    pp_valida_cabecera(bcab.movi_nume,
                       bcab.movi_oper_codi,
                       bcab.movi_fech_emis,
                       bcab.movi_depo_codi_orig);
  
    --valida nro. ajuste
    pp_valida_nume;
  
    --  pp_verifica_nume;
  
    pp_actualiza_come_movi;
    pp_actualiza_come_movi_prod;
    pp_actu_secu;
    --pp_imprimir_reportes(i_movi_codi => bcab.movi_codi);
  
    apex_application.g_print_success_message := 'Registro actualizado.
                                                <a href="javascript:$s(''P43_MOVI_CODI_IMPRIMIR'',' ||
                                                bcab.movi_codi || ');">' ||
                                                bcab.movi_nume || '</a>';
  
    /* apex_application.g_print_success_message := 'registro actualizado nro : ' ||
    bcab.movi_nume;*/
  
    /*
        registro actualizado
    <br>
    <a href="f?p=104:1000:&session.::::::" target="_blank">imprimir</a>
        */
  
  end pp_actualizar_registro;

  -----------------------------------------------
  procedure pp_imprimir_reportes(i_movi_codi in number) is
    v_report       varchar2(50);
    v_parametros   clob;
    v_contenedores clob;
    v_011          varchar2(200);
    v_012          varchar2(1000);
  
  begin
  
    if i_movi_codi is null then
      raise_application_error(-20010,
                              'Error, debe de generar un registro!');
    end if;
  
    v_contenedores := 'p_codi_peri_actu:p_movi_codi';
    --v_parametros   := i_codi_peri_actu || ':' || i_movi_codi;
    v_parametros := parameter.p_codi_peri_actu || ':' || i_movi_codi; -- 52085801
    v_report     := 'i020001';
  
    delete from come_parametros_report where usuario = gen_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, gen_user, v_report, 'pdf', v_contenedores);
  
    --  commit;
  
    --busca paquetes
    /*
      select --p.pant_codi, p.pant_desc, p.pant_nomb, p.pant_file, c.clas_desc,m.modu_desc
           p.*
    from segu_pant p
         ,segu_clas_pant c
         ,segu_modu m
    where pant_file like '%i020001%'
    and p.pant_clas= c.clas_codi
    and p.pant_modu= m.modu_codi
      */
  
  end pp_imprimir_reportes;

  procedure pp_ajustar_todo(i_MOVI_DEPO_CODI_ORIG in number,
                            i_movi_oper_codi      in number) as
    cursor cur_exist is
      select t.prod_codi, t.prde_cant_actu, t.lote_codi, t.prod_medi_codi
        from v_come_depo_sucu_prod_lote t
       where t.depo_codi = i_MOVI_DEPO_CODI_ORIG
         and i_movi_oper_codi = case
               when t.prde_cant_actu < 0 then
                1
               when t.prde_cant_actu > 0 then
                2
               else
                -99
             end
         and t.prde_cant_actu <> 0;
    v_cantidad   number;
    v_ajuste_mas varchar2(2);
  begin
  
    /*
    1 1-ajuste (+)  1
    2 2-ajuste (-)  2
    */
  
    if i_movi_oper_codi = 1 then
      v_ajuste_mas := 'S';
    else
      v_ajuste_mas := 'N';
    end if;
  
    if i_MOVI_DEPO_CODI_ORIG is null then
      pl_me('Debe cargar el deposito origen');
    end if;
  
    if i_movi_oper_codi is null then
      pl_me('Debe cargar el codigo de operacion');
    end if;
  
    if gen_user <> 'SKN' then
      pl_me('No tiene permiso para usar');
    end if;
  
    apex_collection.create_or_truncate_collection(p_collection_name => parameter.collection_name);
  
    for c in cur_exist loop
      -- control para que pase al siguiente registro 
      /*if v_ajuste_mas = 'S' then
        if c.prde_cant_actu > 0 then
          continue;
        end if;
      else
        if c.prde_cant_actu < 0 then
          continue;
        end if;
      end if;*/
    
      if v_ajuste_mas = 'S' then
        v_cantidad := c.prde_cant_actu * (-1);
      else
        v_cantidad := c.prde_cant_actu;
      end if;
    
      i020001.pp_add_det(i_deta_prod_codi => c.prod_codi,
                         i_deta_cant      => v_cantidad,
                         i_prod_ind_lote  => 'S',
                         i_deta_lote_codi => c.lote_codi);
    end loop;
  
  end pp_ajustar_todo;

end i020001;
