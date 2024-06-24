
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020002" is
  g_come_movi         come_movi%rowtype;
  come_movi_prod_deta come_movi%rowtype;

  type r_parameter is record(
    
    p_movi_codi          number,
    p_fech_inic          date,
    p_fech_fini          date,
    p_cant_remi_pend     number,
    p_codi_oper_tras_mas number := to_number(general_skn.fl_busca_parametro('p_codi_oper_tras_mas')),
    p_codi_oper_tras_men number := to_number(general_skn.fl_busca_parametro('p_codi_oper_tras_men')),
    p_peco               number := 1,
    p_para_inic          number,
    p_codi_base          number := 1,
    p_codi_oper          number := 4);

  parameter r_parameter;

  cursor g_cur_det is
    select a.seq_id nro,
           a.seq_id deta_nume_item,
           a.c001   deta_prod_codi,
           a.c002   s_producto_desc,
           a.c003   deta_cant_actu,
           a.c004   deta_stoc_mini,
           a.c005   deta_cant,
           a.c006   deta_prec_unit
      from apex_collections a
     where a.collection_name = 'DET_TRASLADOS';

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
           and movi_oper_codi = parameter.p_codi_oper_tras_men;
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          exit;
        when too_many_rows then
          v_nume := v_nume + 1;
      end;
    end loop;
    p_nume := v_nume;
  end;
  procedure pp_cargar_prod_stoc_mini(p_movi_depo_codi_dest in number) is
  
    cursor c_prod is
      select p.prod_codi,
             p.prod_codi_alfa,
             p.prod_desc,
             d.prde_cant_actu,
             d.prde_stoc_mini,
             (nvl(prde_stoc_mini, 0) - nvl(prde_cant_actu, 0)) cantidad
        from come_prod_depo d, come_prod p
       where p.prod_codi = d.prde_prod_codi
         and d.prde_depo_codi = p_movi_depo_codi_dest
         and nvl(d.prde_stoc_mini, 0) > nvl(d.prde_cant_actu, 0)
         and nvl(d.prde_stoc_mini, 0) > 0;
  
  begin
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'DET_TRASLADOS');
    for x in c_prod loop
    
      apex_collection.add_member(p_collection_name => 'DET_TRASLADOS',
                                 p_c001            => x.prod_codi,
                                 p_c002            => x.prod_desc,
                                 p_c003            => x.prde_cant_actu,
                                 p_c004            => x.prde_stoc_mini,
                                 p_c005            => x.cantidad,
                                 p_c006            => null,
                                 p_c007            => x.prod_codi_alfa);
    
    end loop;
  
  Exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_cargar_prod_stoc_mini;
  procedure pp_cargar_prod_stoc_mini_fuer(p_movi_depo_codi_dest in number) is
  
    cursor c_prod is
      select p.prod_codi,
             p.prod_codi_alfa,
             p.prod_desc,
             d.prde_cant_actu,
             d.prde_stoc_mini_fuer,
             (nvl(prde_stoc_mini_fuer, 0) - nvl(prde_cant_actu, 0)) cantidad
        from come_prod_depo d, come_prod p
       where p.prod_codi = d.prde_prod_codi
         and d.prde_depo_codi = p_movi_depo_codi_dest
         and nvl(d.prde_stoc_mini_fuer, 0) > nvl(d.prde_cant_actu, 0)
         and nvl(d.prde_stoc_mini_fuer, 0) > 0;
  
  begin
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'DET_TRASLADOS');
    for x in c_prod loop
    
      apex_collection.add_member(p_collection_name => 'DET_TRASLADOS',
                                 p_c001            => x.prod_codi,
                                 p_c002            => x.prod_desc,
                                 p_c003            => x.prde_cant_actu,
                                 p_c004            => x.prde_stoc_mini_fuer,
                                 p_c005            => x.cantidad,
                                 p_c006            => null,
                                 p_c007            => x.prod_codi_alfa);
    end loop;
  
  Exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_cargar_prod_stoc_mini_fuer;

  function fp_dev_indi_suma_rest(p_oper_codi in number) return varchar is
    v_stoc_suma_rest varchar2(1);
  begin
    select oper_stoc_suma_rest
      into v_stoc_suma_rest
      from come_stoc_oper
     where oper_codi = p_oper_codi;
  
    return v_stoc_suma_rest;
  exception
    when no_data_found then
      raise_application_error(-20010, 'Codigo de Operacion Inexistente');
  end;

  procedure pp_reenumerar_nro_item is
    v_count_item number := 0;
  begin
  
    for c_deta_trasl in g_cur_det loop
      v_count_item := v_count_item + 1;
    end loop;
  
    if v_count_item < 1 then
      raise_application_error(-20010, 'Debe ingresar al menos un item');
    end if;
  
  end pp_reenumerar_nro_item;

  procedure pp_buscar_nume(p_nume out number) is
  begin
  
    select (nvl(secu_nume_tras, 0) + 1) nume
      into p_nume
      from come_secu s, come_pers_comp t
     where s.secu_codi = t.peco_secu_codi
       and t.peco_codi = parameter.p_peco;
  
    pp_veri_nume(p_nume);
  
  exception
    when no_data_found then
      raise_application_error(-200001,
                              'Codigo de Secuencia no fue correctamente asignada a la terminal');
      /*when form_trigger_failure then
      raise form_trigger_failure;*/
    when others then
      raise_application_error(-200001,
                              'Codigo de Secuencia no fue correctamente asignada a la terminal');
      --pl_mostrar_error_plsql;
  end pp_buscar_nume;

  procedure pp_validar_repeticion_prod is
    salir exception;
  begin
    null;
    for c in (select c001 codi_prod, count(*)
                from apex_collections
               where collection_name = 'DETALLE'
               group by c001
              having count(*) > 1) loop
    
      null;
      /*  raise_application_error(-20010,
      'El codigo de Producto del item ' ||
      to_char(i) || ' se repite con el del item ' ||
      to_char(j) ||
      '. asegurese de no introducir mas de una' ||
      ' vez el mismo codigo!');*/
    
    end loop;
  
    /* if not form_success then
        raise form_trigger_failure;
      end if;
      last_record;
      v_cant_reg := to_number(:system.cursor_record);
      if v_cant_reg <= 1 then raise salir; end if;
    
      for i in 1 .. v_cant_reg - 1 loop
        go_record(i);
        v_ant_art := bdet.deta_prod_codi;
        for j in i+1 .. v_cant_reg loop
          go_record(j);
          if v_ant_art = bdet.deta_prod_codi then
             raise_application_error(-20010,'El codigo de Producto del item '
                 ||to_char(i)||' se repite con el del item '
                 ||to_char(j)||'. asegurese de no introducir mas de una'
                 ||' vez el mismo codigo!');
          end if;
        end loop;
      end loop;
    */
  exception
    when salir then
      null;
  end;

  procedure pp_validar_nro(i_movi_nume in number) is
    v_nro number;
  begin
  
    select movi_nume
      into v_nro
      from come_movi
     where movi_nume = i_movi_nume
       and movi_oper_codi = parameter.p_codi_oper_tras_men;
  
    if v_nro is not null then
      raise_application_error(-200001, 'Nro de Traslado Existente');
    end if;
  
  exception
    when no_data_found then
      null;
    when too_many_rows then
      raise_application_error(-200001, 'Nro de traslado duplicado');
      /*when form_trigger_failure then
        raise form_trigger_failure;
      when others then
        pl_mostrar_error_plsql;*/
  end pp_validar_nro;

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
                                          p_deta_list_codi         in number) is
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
       parameter.p_codi_base);
  end;

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
  
  end pp_insert_come_movi;

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
    -----------------------------------
    v_deta_movi_codi2 number;
    -----------------------------------
  
  begin
    ----insertar el detalle para el traslado (+) y (-)
  
    v_deta_movi_codi  := g_come_movi.movi_codi;
    v_deta_movi_codi2 := g_come_movi.movi_codi_padr;
  
    for bdet in g_cur_det loop
      v_deta_nume_item         := bdet.deta_nume_item;
      v_deta_impu_codi         := null;
      v_deta_prod_codi         := bdet.deta_prod_codi;
      v_deta_cant              := bdet.deta_cant;
      v_deta_obse              := null;
      v_deta_porc_deto         := null;
      v_deta_impo_mone         := null;
      v_deta_impo_mmnn         := null;
      v_deta_impo_mmee         := null;
      v_deta_iva_mmnn          := null;
      v_deta_iva_mmee          := null;
      v_deta_iva_mone          := null;
      v_deta_prec_unit         := bdet.deta_prec_unit;
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
                                    v_deta_list_codi);
    
      pp_insert_come_movi_prod_deta(v_deta_movi_codi2,
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
                                    v_deta_list_codi);
    
    end loop;
  
    ---en caso q se desee ordenar por un campo distinto al nume de item
    ---lo q hacemos es volver a insertar los registros de detalle, previamente
    ---ordenado por el campo q se selecciono..
    ---para eso utilizaremos una tabla pl, para guardar temporalmente los datos
  
  end;

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
    g_come_movi.movi_codi      := fa_sec_come_movi;
    g_come_movi.movi_fech_grab := sysdate;
    g_come_movi.movi_user      := fa_user;
    g_come_movi.movi_codi_padr := null;
  
    v_movi_codi      := g_come_movi.movi_codi;
    v_movi_timo_codi := null;
    v_movi_clpr_codi := null;
  
    --invertido para el traslado(+) -----------------------------------
    v_movi_sucu_codi_orig := g_come_movi.movi_sucu_codi_dest;
    v_movi_depo_codi_orig := g_come_movi.movi_depo_codi_dest;
    v_movi_sucu_codi_dest := g_come_movi.movi_sucu_codi_orig;
    v_movi_depo_codi_dest := g_come_movi.movi_depo_codi_orig;
    --------------------------------------------------------------------
  
    v_movi_oper_codi := parameter.p_codi_oper_tras_mas;
  
    v_movi_nume                := g_come_movi.movi_nume;
    v_movi_fech_emis           := g_come_movi.movi_fech_emis;
    v_movi_fech_grab           := g_come_movi.movi_fech_grab;
    v_movi_user                := g_come_movi.movi_user;
    v_movi_codi_padr           := g_come_movi.movi_codi_padr;
    v_movi_obse                := g_come_movi.movi_obse;
    v_movi_stoc_suma_rest      := fp_dev_indi_suma_rest(parameter.p_codi_oper_tras_mas);
    v_movi_stoc_afec_cost_prom := 'N';
  
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
    g_come_movi.movi_codi_padr := g_come_movi.movi_codi;
    g_come_movi.movi_codi      := fa_sec_come_movi;
    g_come_movi.movi_fech_grab := sysdate;
    g_come_movi.movi_user      := fa_user;
  
    v_movi_codi      := g_come_movi.movi_codi;
    v_movi_timo_codi := null;
    v_movi_clpr_codi := null;
  
    v_movi_sucu_codi_orig := g_come_movi.movi_sucu_codi_orig;
    v_movi_depo_codi_orig := g_come_movi.movi_depo_codi_orig;
    v_movi_sucu_codi_dest := g_come_movi.movi_sucu_codi_dest;
    v_movi_depo_codi_dest := g_come_movi.movi_depo_codi_dest;
    --------------------------------------------------------------------
  
    v_movi_oper_codi := parameter.p_codi_oper_tras_men;
  
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := null;
    v_movi_nume                := g_come_movi.movi_nume;
    v_movi_fech_emis           := g_come_movi.movi_fech_emis;
    v_movi_fech_grab           := g_come_movi.movi_fech_grab;
    v_movi_user                := g_come_movi.movi_user;
    v_movi_codi_padr           := g_come_movi.movi_codi_padr;
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
    v_movi_obse                := g_come_movi.movi_obse;
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
  
  end;

  procedure pp_mostrar_producto(i_prod_codi      in number,
                                o_prod_desc      out varchar2,
                                o_deta_precio    out number,
                                o_prod_codi_alfa out varchar2) as
    v_ind_inactivo varchar2(10);
  begin
    if i_prod_codi is null then
      raise_application_error(-20005, 'Favor seleccionar un producto');
    end if;
    select prod_desc, nvl(prod_indi_inac, 'N'), prod_prec, prod_codi_alfa
      into o_prod_desc, v_ind_inactivo, o_deta_precio, o_prod_codi_alfa
      from come_prod c
     where prod_codi = i_prod_codi;
  
    if v_ind_inactivo = 'S' then
      raise_application_error(-20010, 'El producto se encuentra inactivo');
    end if;
  exception
    when no_Data_found then
      raise_application_error(-20010, 'Error al traer producto');
    
  end;

  procedure pp_add_det(i_prod_cod in number, i_prod_cant in number) as
    v_prod come_prod%rowtype;
  begin
  
    if i_prod_cant < 0 then
      raise_application_error(-20001, 'La Cantidad no puede ser negativa');
    end if;
  
    begin
      -- Call the procedure
      i020002.pp_mostrar_producto(i_prod_codi      => i_prod_cod,
                                  o_prod_desc      => v_prod.prod_desc,
                                  o_deta_precio    => v_prod.prod_prec,
                                  o_prod_codi_alfa => v_prod.prod_codi_alfa);
    end;
  
    apex_collection.add_member(p_collection_name => 'DET_TRASLADOS',
                               p_c001            => i_prod_cod,
                               p_c002            => v_prod.prod_desc,
                               p_c005            => i_prod_cant,
                               p_c006            => v_prod.prod_prec,
                               p_c007            => v_prod.prod_codi_alfa);
  
 
  
  end pp_add_det;

  procedure pp_actu_secu is
  begin
    update come_secu
       set secu_nume_tras = g_come_movi.movi_nume
     where secu_codi = (select peco_secu_codi
                          from come_pers_comp
                         where peco_codi = parameter.p_peco);
  
  end;

  procedure pp_set_variables as
  begin
    -- g_come_movi.PROD_COD_ALFA       := V('P44_PROD_COD_ALFA');
    g_come_movi.MOVI_NUME := V('P44_MOVI_NUME');
    -- g_come_movi.PROD_DESCRIPCION    := V('P44_PROD_DESCRIPCION');
    -- g_come_movi.STOCK_MINIMO        := V('P44_STOCK_MINIMO');
    -- g_come_movi.PROD_COD            := V('P44_PROD_COD');
    g_come_movi.MOVI_FECH_EMIS := V('P44_MOVI_FECH_EMIS');
    -- g_come_movi.DIAS                := V('P44_DIAS');
    -- g_come_movi.PROD_CANT_ACTUAL    := V('P44_PROD_CANT_ACTUAL');
    -- g_come_movi.PROD_CANT_MINIMA    := V('P44_PROD_CANT_MINIMA');
    -- g_come_movi.MOVI_CODI := V('P44_MOVI_CODI');
    -- g_come_movi.PROD_CANTIDAD       := V('P44_PROD_CANTIDAD');
    g_come_movi.MOVI_DEPO_CODI_ORIG := V('P44_MOVI_DEPO_CODI_ORIG');
    -- g_come_movi.MOVI_DEPO_DESC_ORIG := V('P44_MOVI_DEPO_DESC_ORIG');
    -- g_come_movi.MOVI_SUCU_DESC_ORIG := V('P44_MOVI_SUCU_DESC_ORIG');
    g_come_movi.MOVI_SUCU_CODI_ORIG := V('P44_MOVI_SUCU_CODI_ORIG');
    g_come_movi.MOVI_DEPO_CODI_DEST := V('P44_MOVI_DEPO_CODI_DEST');
    -- g_come_movi.MOVI_DEPO_DESC_DEST := V('P44_MOVI_DEPO_DESC_DEST');
    -- g_come_movi.MOVI_SUCU_DESC_DEST := V('P44_MOVI_SUCU_DESC_DEST');
    g_come_movi.MOVI_SUCU_CODI_DEST := V('P44_MOVI_SUCU_CODI_DEST');
    g_come_movi.MOVI_OBSE           := V('P44_MOVI_OBSE');
  
  end;

  procedure pp_imprimir_reporte(i_movi_codi in varchar2) is
    v_report       VARCHAR2(50);
    v_parametros   CLOB;
    v_contenedores CLOB;
  
  begin
  
    V_CONTENEDORES := 'p_movi_codi';
    V_PARAMETROS   := i_movi_codi;
    v_report       := 'I020002';
  
    delete from come_parametros_report where usuario = fa_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, fa_user, v_report, 'pdf', v_contenedores);
  
    commit;
  end pp_imprimir_reporte;

  procedure pp_validar_campos is
  begin
    if V('P44_MOVI_DEPO_CODI_ORIG') is null then
      raise_application_error(-20002,
                              'Debe ingresar el codigo del deposito origen');
    end if;
  
    if V('P44_MOVI_DEPO_CODI_DEST') is null then
      raise_application_error(-20003,
                              'Debe ingresar el codigo del deposito destino');
    end if;
  
    if V('P44_MOVI_DEPO_CODI_ORIG') = V('P44_MOVI_DEPO_CODI_DEST') then
      raise_application_error(-20004,
                              'El deposito origen no puede ser igual al destino, Favor Verifique');
    end if;
  end pp_validar_campos;

  procedure pp_borrar_deta(i_seq_id in number) as
  begin
  
    apex_collection.delete_member(p_collection_name => 'DET_TRASLADOS',
                                  p_seq             => i_seq_id);
  
    apex_collection.resequence_collection(p_collection_name => 'DET_TRASLADOS');
  end pp_borrar_deta;

  procedure pp_actualizar_registro is
  begin
    pp_validar_campos;
    pp_set_variables;
    if g_come_movi.movi_codi is null then
      pp_reenumerar_nro_item;
      pp_validar_repeticion_prod;
      pp_veri_nume(g_come_movi.movi_nume);
      pp_actualiza_come_movi;
      pp_actualiza_come_movi_prod;
    
      pp_actu_secu;
    
    end if;
  
    select t.movi_codi
      into parameter.p_movi_codi
      from come_movi t
     where t.movi_nume = g_come_movi.movi_nume
       and t.movi_oper_codi = parameter.p_codi_oper
       and t.movi_user = fa_user;
    pp_imprimir_reporte(parameter.p_movi_codi);
    --  message('Registro no actualizado !', no_acknowledge);
  end pp_actualizar_registro;

  procedure pp_mostrar_deposito(i_MOVI_DEPO_CODI in number,
                                i_empr_codi in number,
                                o_MOVI_DEPO_DESc out varchar2,
                                o_MOVI_SUCU_CODI out number,
                                o_MOVI_SUCU_DESC out varchar2) is
  begin
    select depo_desc, sucu_codi, sucu_desc
      into o_MOVI_DEPO_DESC,
           o_MOVI_SUCU_CODI,
           o_MOVI_SUCU_DESC
      from come_depo, come_sucu
     where depo_sucu_codi = sucu_codi
       and depo_codi = i_MOVI_DEPO_CODI
       and depo_empr_codi=i_empr_codi;
  exception
    when no_data_found then
      raise_application_error(-20001, 'No existe el deposito ingresado..');
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_mostrar_deposito;

end i020002;
