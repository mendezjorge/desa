
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020261" is

  type t_parameter is record(
    p_cant_deci_cant  number := general_skn.fl_busca_parametro('p_cant_deci_cant'),
    p_codi_base       number := pack_repl.fa_devu_codi_base,
    p_empresa         number := 1,
    p_fech_inic       date,
    p_fech_fini       date,
    p_ind_validar_det varchar2(2) := 'S',
    p_indi_ejec_cons  varchar2(2) := 'S',
    p_perm_stoc_nega  varchar2(2) := ltrim(rtrim(general_skn.fl_busca_parametro('p_perm_stoc_nega'))));

  parameter t_parameter;

  type t_bcab is record(
    sotr_base           number,
    sotr_cant           number,
    sotr_cant_remi      number,
    sotr_cant_sald      number,
    sotr_codi           number,
    sotr_depo_codi_orig number,
    sotr_esta           varchar2(100),
    sotr_empr_codi      number,
    sotr_fech_emis      date,
    sotr_sucu_codi_orig number,
    sotr_cant_canc      number,
    sotr_sucu_codi_dest number,
    sotr_depo_codi_dest number,
    sotr_obse           varchar2(1000),
    sotr_fech_modi      date,
    sotr_fech_regi      date,
    sotr_nume           number,
    sotr_user_modi      varchar2(100),
    sotr_user_regi      varchar2(100));
  bcab t_bcab;

  type t_bdet is record(
    sum_deta_cant_sald number,
    sum_deta_cant_medi number);

  fbdet t_bdet;

  cursor cur_bdet(i_seq_id number default null) is
    select seq_id item,
           c001   prod_codi_alfa,
           c002   deta_prod_codi_barr,
           c003   deta_medi_codi,
           c004   prod_desc,
           c005   deta_cant_medi,
           c006   deta_cant_sald,
           c007   deta_prod_peso,
           c008   tota_deta_prod_peso,
           c009   deta_cant,
           c010   deta_prod_codi,
           c015   prod_desc_exte,
           c016   prod_indi_fact_nega,
           c017   prod_indi_auto_fact,
           c018   prod_indi_lote,
           c019   prod_indi_kitt,
           c020   coba_fact_conv,
           c021   deta_cant_remi,
           c022   deta_lote_codi,
           c023   medi_desc_abre
      from apex_collections a
     where a.collection_name = 'DETALLE'
       and (seq_id = i_seq_id or i_seq_id is null);

  procedure pl_me(i_msg in varchar2) is
  begin
    raise_application_error(-20010, i_msg);
  end pl_me;

  function fp_dev_stoc_neto(p_lote_codi in number,
                            p_depo_codi in number,
                            p_codi      in number) return number is
    v_stoc_actu number;
    v_cant_pedi number := 0;
  begin
  
    select nvl((nvl(a.prde_cant_actu, 0) - nvl(a.prde_cant_pedi, 0) -
               nvl(a.prde_cant_remi, 0) - nvl(a.prde_cant_pedi_sucu, 0)),
               0)
      into v_stoc_actu
      from come_prod_depo_lote a
     where a.prde_lote_codi = p_lote_codi
       and a.prde_depo_codi = p_depo_codi;
  
    if p_codi is not null then
      select nvl(sum(deta_cant), 0)
        into v_cant_pedi
        from come_soli_tras_depo_deta d
       where d.deta_sotr_codi = p_codi
         and deta_lote_codi = p_lote_codi;
    
    end if;
    return(v_stoc_actu + v_cant_pedi);
  exception
    when no_data_found then
      return 0;
  end fp_dev_stoc_neto;

  procedure pp_generar_nume(p_sotr_nume out number) is
  begin
    select nvl(max(s.sotr_nume), 0) + 1
      into p_sotr_nume
      from come_soli_tras_depo s
     where nvl(s.sotr_empr_codi, 1) = nvl(parameter.p_empresa, 1);
  
  exception
    when others then
      pl_me(sqlerrm);
  end pp_generar_nume;

  procedure pp_veri_nume_pedi(p_nume in out number) is
    v_nume number;
  begin
    v_nume := p_nume;
  
    if v_nume is null then
      v_nume := 1;
    end if;
  
    loop
      begin
        select sotr_nume
          into v_nume
          from come_soli_tras_depo
         where sotr_nume = v_nume;
      
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          exit;
        when too_many_rows then
          v_nume := v_nume + 1;
      end;
    end loop;
  
    p_nume := v_nume;
  
  end pp_veri_nume_pedi;

  procedure pp_reenumerar_nro_item is
    v_nume_item number := 0;
  begin
    null;
    /*go_block('bdet');
    first_record;
    if :bdet.deta_prod_codi is null then
      pl_me('debe ingresar al menos un item');
    end if;
    loop
      v_nume_item           := v_nume_item + 1;
      :bdet.deta_nume_item := v_nume_item;
      if :system.last_record = upper('true') then
        exit;
      end if;
      next_record;
    end loop;
    next_record;
    clear_record;*/
  end;

  procedure pp_validar_repeticion_lote is
    v_cant_reg number; --cantidad de registros en el bloque
    i          number;
    j          number;
    salir      exception;
    v_ant_art  number;
    v_cant_reg number; --cantidad de registros en el bloque
    v_ant_art  number;
    type t_cur is table of cur_bdet%rowtype;
    v_cur t_cur;
  begin
  
    open cur_bdet;
    fetch cur_bdet bulk collect
      into v_cur;
    close cur_bdet;
  
    if v_cur.count = 0 then
      pl_me('Debe seleccionar por lo menos un item');
    end if;
  
    for i in 1 .. v_cur.last loop
      for j in 1 .. v_cur.last loop
        if v_cur(i).deta_prod_codi = v_cur(j).deta_prod_codi and v_cur(i).deta_lote_codi = v_cur(j).deta_lote_codi and v_cur(i).item <> v_cur(j).item then
          raise_application_error(-20010,
                                  'El codigo de Producto del item ' ||
                                  to_char(v_cur(i).item) ||
                                  ' se repite con el del item ' ||
                                  to_char(v_cur(j).item) ||
                                  '. asegurese de no introducir mas de una' ||
                                  ' vez el mismo codigo!');
        end if;
      end loop;
    end loop;
  
  exception
    when salir then
      null;
  end pp_validar_repeticion_lote;

  procedure pp_borrar_det(i_seq_id in number) is
  begin
    apex_collection.delete_member(p_collection_name => 'DETALLE',
                                  p_seq             => i_seq_id);
    apex_collection.resequence_collection(p_collection_name => 'DETALLE');
  
  end pp_borrar_det;

  procedure pp_mostrar_come_unid_medi(i_medi_codi in number,
                                      i_prod_codi in number,
                                      i_codi_barr in varchar2,
                                      o_desc_abre out varchar2,
                                      o_fact_conv out number) is
  begin
    begin
      select ltrim(rtrim(medi_desc_abre))
        into o_desc_abre
        from come_unid_medi m
       where m.medi_codi = i_medi_codi;
    exception
      when no_data_found then
        o_desc_abre := null;
        o_fact_conv := 1;
        pl_me('Unidad de medida inexistente');
    end;
  
    if i_codi_barr is null then
      begin
        select nvl(d.coba_fact_conv, 1)
          into o_fact_conv
          from come_prod_coba_deta d
         where d.coba_medi_codi = i_medi_codi
           and d.coba_prod_codi = i_prod_codi;
      exception
        when no_data_found then
          o_fact_conv := 1;
          pl_me('Unidad de medida inexistente para el producto seleccionado!!!');
        when too_many_rows then
          o_fact_conv := 1;
          pl_me('Existe mas de un codigo de barra con la misma unidad de medida!.');
      end;
    else
      --- para las consultas con productos con codigo de barras distintas y misma unidad de medida
      begin
        select nvl(d.coba_fact_conv, 1)
          into o_fact_conv
          from come_prod_coba_deta d
         where d.coba_medi_codi = i_medi_codi
           and d.coba_prod_codi = i_prod_codi
           and d.coba_codi_barr = i_codi_barr;
      exception
        when no_data_found then
          o_fact_conv := 1;
          pl_me('Unidad de medida inexistente para el producto seleccionado!!!');
        when too_many_rows then
          o_fact_conv := 1;
          pl_me('Existe mas de un codigo de barra con la misma unidad de medida!.');
      end;
    end if;
  exception
    when others then
      pl_me(sqlerrm);
  end pp_mostrar_come_unid_medi;

  procedure pp_add_det(i_deta_prod_codi      in number,
                       i_deta_medi_codi      in number,
                       i_deta_cant_medi      in number,
                       i_deta_lote_codi      in number,
                       i_sotr_depo_codi_orig in number,
                       i_sotr_codi           in number,
                       i_seq_id              in number) is
  
    bdet cur_bdet%rowtype;
  
    procedure pp_validar_stock is
      v_cant_actu number;
    begin
      null;
      if nvl(parameter.p_perm_stoc_nega, 'N') = 'N' then
        v_cant_actu := fp_dev_stoc_neto(bdet.deta_lote_codi,
                                        i_sotr_depo_codi_orig,
                                        i_sotr_codi);
        if bdet.deta_cant > nvl(v_cant_actu, 0) then
          pl_me('La cantidad supera la existencia actual en el deposito');
        end if;
      end if;
    end pp_validar_stock;
  
    procedure pp_traer_desc_prod is
      v_prod_indi_inac char(1);
      v_dbcr           char(1);
      v_prod_codi      number;
    begin
    
      bdet.deta_cant_medi := i_deta_cant_medi;
      bdet.deta_medi_codi := i_deta_medi_codi;
    
      select prod_codi,
             prod_desc,
             nvl(prod_desc_exte, prod_desc),
             prod_indi_inac,
             prod_indi_fact_nega,
             nvl(prod_indi_auto_fact, 'S'),
             nvl(prod_indi_lote, 'N'),
             nvl(prod_indi_kitt, 'N'),
             prod_peso_kilo,
             p.prod_codi_alfa,
             p.prod_codi_barr
        into bdet.deta_prod_codi,
             bdet.prod_desc,
             bdet.prod_desc_exte,
             v_prod_indi_inac,
             bdet.prod_indi_fact_nega,
             bdet.prod_indi_auto_fact,
             bdet.prod_indi_lote,
             bdet.prod_indi_kitt,
             bdet.deta_prod_peso,
             bdet.prod_codi_alfa,
             bdet.deta_prod_codi_barr
        from come_prod p
       where prod_codi = i_deta_prod_codi;
    
      if v_prod_codi <> nvl(bdet.deta_prod_codi, -99999) then
        bdet.deta_prod_codi := v_prod_codi;
      end if;
    
      if v_prod_indi_inac = 'S' then
        pl_me('El producto se encuentra inactivo');
      end if;
    
    exception
      when no_data_found then
        pl_me('Producto inexistente.');
      when others then
        pl_me(sqlerrm);
    end pp_traer_desc_prod;
  
  begin
    if not
        (apex_collection.collection_exists(p_collection_name => 'DETALLE')) then
      null;
      apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');
    end if;
  
    pp_traer_desc_prod;
  
    if nvl(bdet.prod_indi_lote, 'N') = 'N' then
      bdet.deta_lote_codi := fa_devu_lote_000000(bdet.deta_prod_codi);
    
    else
      if i_deta_lote_codi is null then
        pl_me('Tiene que seleccionar el lote');
      end if;
      bdet.deta_lote_codi := i_deta_lote_codi;
    end if;
  
    pp_mostrar_come_unid_medi(i_medi_codi => bdet.deta_medi_codi,
                              i_prod_codi => bdet.deta_prod_codi,
                              i_codi_barr => bdet.deta_prod_codi_barr,
                              o_desc_abre => bdet.medi_desc_abre,
                              o_fact_conv => bdet.coba_fact_conv);
  
    if parameter.p_ind_validar_det = 'S' then
      if bdet.deta_cant_medi is null then
        bdet.deta_cant_medi := 0;
      end if;
    
      if nvl(bdet.deta_cant_medi, 0) <= 0 then
        pl_me('La Cantidad debe ser mayor a 0');
      end if;
    
      bdet.deta_cant := round((nvl(bdet.deta_cant_medi, 0) *
                              nvl(bdet.coba_fact_conv, 1)),
                              parameter.p_cant_deci_cant);
    
      if nvl(bdet.deta_cant_remi, 0) = 0 then
        bdet.deta_cant_sald := bdet.deta_cant_medi;
      end if;
    
      if parameter.p_indi_ejec_cons = 'N' then
        pp_validar_stock;
      end if;
    end if;
  
    bdet.tota_deta_prod_peso := nvl(bdet.deta_cant_medi, 0) *
                                nvl(bdet.deta_prod_peso, 0);
    if i_seq_id is null then
      apex_collection.add_member(p_collection_name => 'DETALLE',
                                 p_c001            => bdet.prod_codi_alfa,
                                 p_c002            => bdet.deta_prod_codi_barr,
                                 p_c003            => bdet.deta_medi_codi,
                                 p_c004            => bdet.prod_desc,
                                 p_c005            => bdet.deta_cant_medi,
                                 p_c006            => bdet.deta_cant_sald,
                                 p_c007            => bdet.deta_prod_peso,
                                 p_c008            => bdet.tota_deta_prod_peso,
                                 p_c009            => bdet.deta_cant,
                                 
                                 p_c010 => bdet.deta_prod_codi,
                                 p_c015 => bdet.prod_desc_exte,
                                 p_c016 => bdet.prod_indi_fact_nega,
                                 p_c017 => bdet.prod_indi_auto_fact,
                                 p_c018 => bdet.prod_indi_lote,
                                 p_c019 => bdet.prod_indi_kitt,
                                 p_c020 => bdet.coba_fact_conv,
                                 p_c021 => bdet.deta_cant_remi,
                                 p_c022 => bdet.deta_lote_codi,
                                 p_c023 => bdet.medi_desc_abre);
    else
      apex_collection.update_member(p_collection_name => 'DETALLE',
                                    p_seq             => i_seq_id,
                                    p_c001            => bdet.prod_codi_alfa,
                                    p_c002            => bdet.deta_prod_codi_barr,
                                    p_c003            => bdet.deta_medi_codi,
                                    p_c004            => bdet.prod_desc,
                                    p_c005            => bdet.deta_cant_medi,
                                    p_c006            => bdet.deta_cant_sald,
                                    p_c007            => bdet.deta_prod_peso,
                                    p_c008            => bdet.tota_deta_prod_peso,
                                    p_c009            => bdet.deta_cant,
                                    
                                    p_c010 => bdet.deta_prod_codi,
                                    p_c015 => bdet.prod_desc_exte,
                                    p_c016 => bdet.prod_indi_fact_nega,
                                    p_c017 => bdet.prod_indi_auto_fact,
                                    p_c018 => bdet.prod_indi_lote,
                                    p_c019 => bdet.prod_indi_kitt,
                                    p_c020 => bdet.coba_fact_conv,
                                    p_c021 => bdet.deta_cant_remi,
                                    p_c022 => bdet.deta_lote_codi,
                                    p_c023 => bdet.medi_desc_abre);
    end if;
  end pp_add_det;

  procedure pp_actualizar_soli_tras_cab is
  
    v_sotr_codi           come_soli_tras_depo.sotr_codi%type;
    v_sotr_nume           come_soli_tras_depo.sotr_nume%type;
    v_sotr_fech_emis      come_soli_tras_depo.sotr_fech_emis%type;
    v_sotr_empr_codi      come_soli_tras_depo.sotr_empr_codi%type;
    v_sotr_sucu_codi_orig come_soli_tras_depo.sotr_sucu_codi_orig%type;
    v_sotr_depo_codi_orig come_soli_tras_depo.sotr_depo_codi_orig%type;
    v_sotr_sucu_codi_dest come_soli_tras_depo.sotr_sucu_codi_dest%type;
    v_sotr_depo_codi_dest come_soli_tras_depo.sotr_depo_codi_dest%type;
    v_sotr_esta           come_soli_tras_depo.sotr_esta%type;
    v_sotr_obse           come_soli_tras_depo.sotr_obse%type;
    v_sotr_user_regi      come_soli_tras_depo.sotr_user_regi%type;
    v_sotr_fech_regi      come_soli_tras_depo.sotr_fech_regi%type;
    v_sotr_user_modi      come_soli_tras_depo.sotr_user_modi%type;
    v_sotr_fech_modi      come_soli_tras_depo.sotr_fech_modi%type;
    v_sotr_base           come_soli_tras_depo.sotr_base%type;
    v_sotr_cant           come_soli_tras_depo.sotr_cant%type;
    v_sotr_cant_remi      come_soli_tras_depo.sotr_cant_remi%type;
    v_sotr_cant_sald      come_soli_tras_depo.sotr_cant_sald%type;
    v_sotr_cant_canc      come_soli_tras_depo.sotr_cant_canc%type;
  
  begin
  
    if bcab.sotr_codi is null then
      bcab.sotr_codi      := fa_sec_come_soli_tras_depo;
      bcab.sotr_esta      := 'P';
      bcab.sotr_user_regi := gen_user;
      bcab.sotr_fech_regi := sysdate;
      bcab.sotr_base      := parameter.p_codi_base;
      bcab.sotr_cant      := fbdet.sum_deta_cant_medi;
      bcab.sotr_cant_remi := 0;
      bcab.sotr_cant_sald := fbdet.sum_deta_cant_medi;
    end if;
  
    bcab.sotr_user_modi := gen_user;
    bcab.sotr_fech_modi := sysdate;
  
    v_sotr_codi           := bcab.sotr_codi;
    v_sotr_nume           := bcab.sotr_nume;
    v_sotr_fech_emis      := bcab.sotr_fech_emis;
    v_sotr_empr_codi      := bcab.sotr_empr_codi;
    v_sotr_sucu_codi_orig := bcab.sotr_sucu_codi_orig;
    v_sotr_depo_codi_orig := bcab.sotr_depo_codi_orig;
    v_sotr_sucu_codi_dest := bcab.sotr_sucu_codi_dest;
    v_sotr_depo_codi_dest := bcab.sotr_depo_codi_dest;
    v_sotr_esta           := bcab.sotr_esta;
    v_sotr_obse           := bcab.sotr_obse;
    v_sotr_user_regi      := bcab.sotr_user_regi;
    v_sotr_fech_regi      := bcab.sotr_fech_regi;
    v_sotr_user_modi      := bcab.sotr_user_modi;
    v_sotr_fech_modi      := bcab.sotr_fech_modi;
    v_sotr_base           := bcab.sotr_base;
    v_sotr_cant           := bcab.sotr_cant;
    v_sotr_cant_remi      := bcab.sotr_cant_remi;
    v_sotr_cant_sald      := bcab.sotr_cant_sald;
    v_sotr_cant_canc      := bcab.sotr_cant_canc;
  
    update come_soli_tras_depo
       set sotr_nume           = v_sotr_nume,
           sotr_fech_emis      = v_sotr_fech_emis,
           sotr_empr_codi      = v_sotr_empr_codi,
           sotr_sucu_codi_orig = v_sotr_sucu_codi_orig,
           sotr_depo_codi_orig = v_sotr_depo_codi_orig,
           sotr_sucu_codi_dest = v_sotr_sucu_codi_dest,
           sotr_depo_codi_dest = v_sotr_depo_codi_dest,
           sotr_esta           = v_sotr_esta,
           sotr_obse           = v_sotr_obse,
           sotr_user_regi      = v_sotr_user_regi,
           sotr_fech_regi      = v_sotr_fech_regi,
           sotr_user_modi      = v_sotr_user_modi,
           sotr_fech_modi      = v_sotr_fech_modi,
           sotr_base           = v_sotr_base,
           sotr_cant           = v_sotr_cant,
           sotr_cant_remi      = v_sotr_cant_remi,
           sotr_cant_sald      = v_sotr_cant_sald,
           sotr_cant_canc      = v_sotr_cant_canc
     where sotr_codi = v_sotr_codi;
  
    if sql%notfound then
      insert into come_soli_tras_depo
        (sotr_codi,
         sotr_nume,
         sotr_fech_emis,
         sotr_empr_codi,
         sotr_sucu_codi_orig,
         sotr_depo_codi_orig,
         sotr_sucu_codi_dest,
         sotr_depo_codi_dest,
         sotr_esta,
         sotr_obse,
         sotr_user_regi,
         sotr_fech_regi,
         sotr_user_modi,
         sotr_fech_modi,
         sotr_base,
         sotr_cant,
         sotr_cant_remi,
         sotr_cant_sald,
         sotr_cant_canc)
      values
        (v_sotr_codi,
         v_sotr_nume,
         v_sotr_fech_emis,
         v_sotr_empr_codi,
         v_sotr_sucu_codi_orig,
         v_sotr_depo_codi_orig,
         v_sotr_sucu_codi_dest,
         v_sotr_depo_codi_dest,
         v_sotr_esta,
         v_sotr_obse,
         v_sotr_user_regi,
         v_sotr_fech_regi,
         v_sotr_user_modi,
         v_sotr_fech_modi,
         v_sotr_base,
         v_sotr_cant,
         v_sotr_cant_remi,
         v_sotr_cant_sald,
         v_sotr_cant_canc);
    end if;
  
  end pp_actualizar_soli_tras_cab;

  procedure pp_actualizar_soli_tras_det is
  
    v_deta_sotr_codi      come_soli_tras_depo_deta.deta_sotr_codi%type;
    v_deta_nume_item      come_soli_tras_depo_deta.deta_nume_item%type;
    v_deta_prod_codi      come_soli_tras_depo_deta.deta_prod_codi%type;
    v_deta_medi_codi      come_soli_tras_depo_deta.deta_medi_codi%type;
    v_deta_cant_medi      come_soli_tras_depo_deta.deta_cant_medi%type;
    v_deta_cant           come_soli_tras_depo_deta.deta_cant%type;
    v_deta_user_regi      come_soli_tras_depo_deta.deta_user_regi%type;
    v_deta_fech_regi      come_soli_tras_depo_deta.deta_fech_regi%type;
    v_deta_user_modi      come_soli_tras_depo_deta.deta_user_modi%type;
    v_deta_fech_modi      come_soli_tras_depo_deta.deta_fech_modi%type;
    v_deta_base           come_soli_tras_depo_deta.deta_base%type;
    v_deta_sotr_esta      come_soli_tras_depo_deta.deta_sotr_esta%type;
    v_deta_lote_codi      come_soli_tras_depo_deta.deta_lote_codi%type;
    v_deta_depo_codi      come_soli_tras_depo_deta.deta_depo_codi%type;
    v_deta_cant_sald      come_soli_tras_depo_deta.deta_cant_sald%type;
    v_deta_cant_remi      come_soli_tras_depo_deta.deta_cant_remi%type;
    v_deta_prod_codi_barr come_soli_tras_depo_deta.deta_prod_codi_barr%type;
    v_deta_cant_canc      come_soli_tras_depo_deta.deta_cant_canc%type;
  
  begin
  
    delete from come_soli_tras_depo_deta
     where deta_sotr_codi = bcab.sotr_codi;
  
    for bdet in cur_bdet loop
    
      v_deta_base := parameter.p_codi_base;
      v_deta_cant := bdet.deta_cant;
      --v_deta_cant_canc      := bdet.deta_cant_canc;
      v_deta_cant_medi      := bdet.deta_cant_medi;
      v_deta_cant_remi      := bdet.deta_cant_remi;
      v_deta_cant_sald      := v_deta_cant_medi;
      v_deta_depo_codi      := bcab.sotr_depo_codi_orig;
      v_deta_fech_modi      := sysdate;
      v_deta_fech_regi      := sysdate;
      v_deta_lote_codi      := bdet.deta_lote_codi;
      v_deta_medi_codi      := bdet.deta_medi_codi;
      v_deta_nume_item      := bdet.item;
      v_deta_prod_codi      := bdet.deta_prod_codi;
      v_deta_prod_codi_barr := bdet.deta_prod_codi_barr;
      v_deta_sotr_codi      := bcab.sotr_codi;
      v_deta_sotr_esta      := 'P';
      v_deta_user_modi      := gen_user;
      v_deta_user_regi      := gen_user;
    
      insert into come_soli_tras_depo_deta
        (deta_sotr_codi,
         deta_nume_item,
         deta_prod_codi,
         deta_medi_codi,
         deta_cant_medi,
         deta_cant,
         deta_user_regi,
         deta_fech_regi,
         deta_user_modi,
         deta_fech_modi,
         deta_base,
         deta_sotr_esta,
         deta_lote_codi,
         deta_depo_codi,
         deta_cant_sald,
         deta_cant_remi,
         deta_prod_codi_barr,
         deta_cant_canc)
      values
        (v_deta_sotr_codi,
         v_deta_nume_item,
         v_deta_prod_codi,
         v_deta_medi_codi,
         v_deta_cant_medi,
         v_deta_cant,
         v_deta_user_regi,
         v_deta_fech_regi,
         v_deta_user_modi,
         v_deta_fech_modi,
         v_deta_base,
         v_deta_sotr_esta,
         v_deta_lote_codi,
         v_deta_depo_codi,
         v_deta_cant_sald,
         v_deta_cant_remi,
         v_deta_prod_codi_barr,
         v_deta_cant_canc);
    end loop;
  
  end pp_actualizar_soli_tras_det;

  procedure pp_valida_fech(p_fech in date) is
  begin
    if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
      pl_me('La fecha del movimiento debe estar comprendida entre..' ||
            to_char(parameter.p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
            to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
    end if;
  end pp_valida_fech;

  procedure pp_variables is
  begin
    bcab.sotr_codi      := v('P83_SOTR_CODI');
    bcab.sotr_empr_codi := v('P83_SOTR_EMPR_CODI');
    --  bcab.sotr_empr_desc      := v('p83_sotr_empr_desc');
    --   bcab.menu_sucu_codi      := v('p83_menu_sucu_codi');
    --   bcab.menu_sucu_desc      := v('p83_menu_sucu_desc');
    bcab.sotr_nume           := v('P83_SOTR_NUME');
    bcab.sotr_fech_emis      := v('P83_SOTR_FECH_EMIS');
    bcab.sotr_depo_codi_dest := v('P83_SOTR_DEPO_CODI_DEST');
    bcab.sotr_sucu_codi_dest := v('P83_SOTR_SUCU_CODI_DEST');
    --bcab.sotr_sucu_desc_dest := v('p83_sotr_sucu_desc_dest');
    bcab.sotr_depo_codi_orig := v('P83_SOTR_DEPO_CODI_ORIG');
    bcab.sotr_sucu_codi_orig := v('P83_SOTR_SUCU_CODI_ORIG');
    --bcab.sotr_sucu_desc_orig := v('p83_sotr_sucu_desc_orig');
    bcab.sotr_obse      := v('P83_SOTR_OBSE');
    bcab.sotr_user_regi := v('P83_SOTR_USER_REGI');
    bcab.sotr_fech_regi := v('P83_SOTR_FECH_REGI');
    bcab.sotr_esta      := v('P83_SOTR_ESTA');
    bcab.sotr_user_modi := v('P83_SOTR_USER_MODI');
    bcab.sotr_fech_modi := v('P83_SOTR_FECH_MODI');
    bcab.sotr_base      := v('P83_SOTR_BASE');
    bcab.sotr_cant      := v('P83_SOTR_CANT');
    bcab.sotr_cant_remi := v('P83_SOTR_CANT_REMI');
    bcab.sotr_cant_sald := v('P83_SOTR_CANT_SALD');
    bcab.sotr_cant_canc := v('P83_SOTR_CANT_CANC');
  
    for bdet in cur_bdet loop
      fbdet.sum_deta_cant_sald := nvl(fbdet.sum_deta_cant_sald, 0) +
                                  nvl(bdet.deta_cant_sald, 0);
      fbdet.sum_deta_cant_medi := nvl(fbdet.sum_deta_cant_medi, 0) +
                                  nvl(bdet.deta_cant_medi, 0);
    end loop;
  end pp_variables;

  procedure pp_validar is
  begin
  
    if bcab.sotr_depo_codi_dest is null then
      pl_me('Debe indicar el deposito que solicita');
    end if;
  
    if not general_skn.fl_vali_user_depo_orig(bcab.sotr_depo_codi_dest) then
      pl_me('El usuario no tiene permisos para trabajar con el deposito que solicita');
    end if;
  
    if bcab.sotr_depo_codi_dest = bcab.sotr_depo_codi_orig then
      pl_me('El deposito que solicita y el que envia no pueden ser iguales');
    end if;
  
    if bcab.sotr_depo_codi_orig is null then
      pl_me('Debe indicar el deposito que envia');
    end if;
  
  end pp_validar;

  procedure pp_actualizar_registro is
    v_mensaje varchar2(1000);
  begin
    ---
    pp_variables;
    
    pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
  
    pp_valida_fech(bcab.sotr_fech_emis);
  
    if bcab.sotr_codi is null then
      pp_veri_nume_pedi(bcab.sotr_nume);
    end if;
    
    pp_validar;
  
    pp_reenumerar_nro_item;
    pp_validar_repeticion_lote;
  
    declare
      v_sotr_esta varchar2(2);
    begin
      select nvl(s.sotr_esta, 'P')
        into v_sotr_esta
        from come_soli_tras_depo s
       where s.sotr_codi = bcab.sotr_codi;
      if v_sotr_esta = 'C' then
        pl_me('La solicitud ya fue confirmada por otro usuario. No se pueden guardar cambios');
      end if;
    exception
      when no_data_found then
        null;
      when others then
        pl_me(sqlerrm);
    end;
  
    if nvl(bcab.sotr_cant_sald, 0) <> nvl(fbdet.sum_deta_cant_sald, 0) or
       nvl(bcab.sotr_cant, 0) <> nvl(fbdet.sum_deta_cant_medi, 0) then
      bcab.sotr_cant_sald := fbdet.sum_deta_cant_sald;
      bcab.sotr_cant      := fbdet.sum_deta_cant_medi;
    end if;
  
    pp_actualizar_soli_tras_cab;
    pp_actualizar_soli_tras_det;
  
    v_mensaje := 'Registrado nro: ' || bcab.sotr_nume || ' </br>';
  
    v_mensaje := v_mensaje ||
                 '<a onclick="javascript:$s(''P83_IMPRIMIR_REPORTE'',''' ||
                 bcab.sotr_codi || ''');">Imprimir comprobante</a> ';
  
    apex_application.g_print_success_message := v_mensaje;
  
  end pp_actualizar_registro;

  procedure pp_llamar_reporte(i_sotr_codi in number) as
  
    v_user         varchar2(100) := gen_user;
    v_contenedores varchar2(1000);
    v_parametros   varchar2(1000);
    v_report       varchar2(100) := 'I020261'; --'i020003';
  begin
    v_contenedores := 'P_CLAVE';
    v_parametros   := i_sotr_codi;
  
    delete from come_parametros_report where usuario = v_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, v_user, v_report, 'pdf', v_contenedores);
  
  end pp_llamar_reporte;

  procedure pp_iniciar is
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'DETALLE');
  end pp_iniciar;

  procedure pp_borrar_registro(i_sotr_codi in number) is
    salir exception;
  begin
   
    if i_sotr_codi is not null then
    
      delete come_soli_tras_depo_deta d
       where d.deta_sotr_codi = i_sotr_codi;
    
      delete come_soli_tras_depo where sotr_codi = i_sotr_codi;
    
      apex_application.g_print_success_message := 'registro borrado.';
    
    end if;
  
  exception
    when salir then
      null;
  end pp_borrar_registro;

  procedure pp_ejecutar_consulta is
    v_sotr_codi number := v('P83_SOTR_CODI');
  begin
    if v_sotr_codi is not null then
      select a.sotr_codi,
             a.sotr_base,
             a.sotr_cant,
             a.sotr_cant_remi,
             a.sotr_cant_sald,
             a.sotr_depo_codi_orig,
             a.sotr_esta,
             a.sotr_empr_codi,
             a.sotr_fech_emis,
             a.sotr_sucu_codi_orig,
             a.sotr_cant_canc,
             a.sotr_sucu_codi_dest,
             a.sotr_depo_codi_dest,
             a.sotr_obse,
             a.sotr_fech_modi,
             a.sotr_fech_regi,
             a.sotr_nume,
             a.sotr_user_modi,
             a.sotr_user_regi
        into bcab.sotr_codi,
             bcab.sotr_base,
             bcab.sotr_cant,
             bcab.sotr_cant_remi,
             bcab.sotr_cant_sald,
             bcab.sotr_depo_codi_orig,
             bcab.sotr_esta,
             bcab.sotr_empr_codi,
             bcab.sotr_fech_emis,
             bcab.sotr_sucu_codi_orig,
             bcab.sotr_cant_canc,
             bcab.sotr_sucu_codi_dest,
             bcab.sotr_depo_codi_dest,
             bcab.sotr_obse,
             bcab.sotr_fech_modi,
             bcab.sotr_fech_regi,
             bcab.sotr_nume,
             bcab.sotr_user_modi,
             bcab.sotr_user_regi
        from come_soli_tras_depo a
       where a.sotr_codi = v_sotr_codi;
    
    end if;
    --  setitem('p83_sotr_codi', bcab.sotr_codi);
    setitem('P83_SOTR_EMPR_CODI', bcab.sotr_empr_codi);
    setitem('P83_SOTR_NUME', bcab.sotr_nume);
    setitem('P83_SOTR_FECH_EMIS', bcab.sotr_fech_emis);
    setitem('P83_SOTR_DEPO_CODI_DEST', bcab.sotr_depo_codi_dest);
    setitem('P83_SOTR_SUCU_CODI_DEST', bcab.sotr_sucu_codi_dest);
    setitem('P83_SOTR_DEPO_CODI_ORIG', bcab.sotr_depo_codi_orig);
    setitem('P83_SOTR_SUCU_CODI_ORIG', bcab.sotr_sucu_codi_orig);
    setitem('P83_SOTR_OBSE', bcab.sotr_obse);
    setitem('P83_SOTR_USER_REGI', bcab.sotr_user_regi);
    setitem('P83_SOTR_FECH_REGI', bcab.sotr_fech_regi);
    setitem('P83_SOTR_ESTA', bcab.sotr_esta);
    setitem('P83_SOTR_USER_MODI', bcab.sotr_user_modi);
    setitem('P83_SOTR_FECH_MODI', bcab.sotr_fech_modi);
    setitem('P83_SOTR_BASE', bcab.sotr_base);
    setitem('P83_SOTR_CANT', bcab.sotr_cant);
    setitem('P83_SOTR_CANT_REMI', bcab.sotr_cant_remi);
    setitem('P83_SOTR_CANT_SALD', bcab.sotr_cant_sald);
    setitem('P83_SOTR_CANT_CANC', bcab.sotr_cant_canc);
  
    for c in (select t.deta_prod_codi,
                     t.deta_medi_codi,
                     t.deta_lote_codi,
                     t.deta_cant_medi
                from come_soli_tras_depo_deta t
               where t.deta_sotr_codi = bcab.sotr_codi) loop
    
      pp_add_det(i_deta_prod_codi      => c.deta_prod_codi,
                 i_deta_medi_codi      => c.deta_medi_codi,
                 i_deta_cant_medi      => c.deta_cant_medi,
                 i_deta_lote_codi      => c.deta_lote_codi,
                 i_sotr_depo_codi_orig => bcab.sotr_depo_codi_orig,
                 i_sotr_codi           => bcab.sotr_codi,
                 i_seq_id              => null);
    end loop;
  
  end pp_ejecutar_consulta;

  function fp_prod_ind_medi_codi(i_prod_codi in number) return varchar2 is
    v_return varchar2(2) := 'N';
  begin
    select case
             when count(*) > 1 then
              'S'
             else
              'N'
           end ind_medi_codi
      into v_return
      from come_prod_coba_deta
     where coba_prod_codi = i_prod_codi;
    return v_return;
  exception
    when no_data_found then
      return v_return;
  end fp_prod_ind_medi_codi;

  function fp_prod_ind_lote(i_prod_codi in number) return varchar2 is
    v_return varchar2(2) := 'N';
  begin
  
    select nvl(prod_indi_lote, 'N') prod_indi_lote
      into v_return
      from come_prod p
     where prod_codi = i_prod_codi;
  
    return v_return;
  exception
    when no_data_found then
      return v_return;
  end fp_prod_ind_lote;

  procedure pp_get_det_edit(i_seq_id         in number,
                            o_deta_prod_codi out number,
                            o_deta_medi_codi out number,
                            o_deta_cant_medi out number,
                            o_deta_lote_codi out number) as
    e_salir exception;
  begin
    if i_seq_id is null then
      raise e_salir;
    end if;
    for c in cur_bdet(i_seq_id) loop
      o_deta_prod_codi := c.deta_prod_codi;
      o_deta_medi_codi := c.deta_medi_codi;
      o_deta_cant_medi := c.deta_cant_medi;
      o_deta_lote_codi := c.deta_lote_codi;
    end loop;
  exception
    when e_salir then
      null;
  end pp_get_det_edit;

end i020261;
