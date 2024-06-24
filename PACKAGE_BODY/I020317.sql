
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020317" is

  type r_bcab is record(
    movi_codi           number,
    movi_fech_emis      date,
    movi_nume           number,
    movi_sucu_codi_orig number,
    movi_depo_codi_orig number,
    movi_obse           varchar2(50),
    movi_empr_codi      number,
    prod_codi           number,
    s_cant              number,
    prod_cost_prom_tota number,
    prod_cost_prom      number,
    prod_cost_prom_actu number,
    prod_lote_codi      number,
    indi_arma_desa      varchar2(10));

  bcab r_bcab;

  type r_bdet is record(
    deta_movi_codi     number,
    sum_cost_prom_tota number := 0);

  g_bdet r_bdet;

  type r_parameter is record(
    p_empr_codi               number := 1,
    p_indi_gene_lote_desc     varchar2(3),
    p_codi_oper_arma          number := to_number(general_skn.fl_busca_parametro('p_codi_oper_arma')),
    p_codi_oper_desa          number := to_number(general_skn.fl_busca_parametro('p_codi_oper_desa')),
    p_codi_mone_mmnn          number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_cant_deci_cant          number := to_number(general_skn.fl_busca_parametro('p_cant_deci_cant')),
    p_codi_clas1_clie_subclie number := to_number(general_skn.fl_busca_parametro('p_codi_clas1_clie_subclie')),
    p_codi_peri_sgte          number := to_number(general_skn.fl_busca_parametro('p_codi_peri_sgte')),
    p_perm_stoc_nega          varchar2(2) := ltrim(rtrim(general_skn.fl_busca_parametro('p_perm_stoc_nega'))),
    p_indi_most_mens_aler     varchar2(2) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_aler'))),
    p_peco_codi               number := 1,
    p_ind_validar_det         varchar2(2) := 'S',
    p_fech_inic               date,
    p_fech_fini               date,
    p_codi_base               number := pack_repl.fa_devu_codi_base);

  parameter r_parameter;

  cursor cur_det is
    select a.seq_id,
           a.seq_id deta_nume_item,
           a.c001 deta_prod_codi,
           a.c009 deta_prod_desc,
           to_number(a.c002) deta_cant,
           to_number(a.c003) deta_cost_prom_tota,
           to_number(a.c005) deta_cost_unit_actu,
           to_number(a.c006) deta_cost_unit,
           a.c007 prod_lote_codi,
           a.c010 prod_lote_desc,
           to_number(a.c008) deta_porc_cost,
           to_number(a.c011) deta_dife_costo,
           c012 deta_prod_codi_alfa,
           count(*) over() total_rows,
           sum(a.c002) over() sum_deta_cant
      from apex_collections a
     where a.collection_name = 'DETALLE';

  cursor cur_lote is
    select c001 lote_desc,
           c002 lote_codi_barr,
           c003 lote_cant_medi,
           c004 lote_codi,
           c005 deta_prod_codi,
           d001 lote_fech_elab,
           d002 lote_fech_venc,
           c006 lote_iccid,
           C007 lote_nro_linea,
           C008 lote_simc_codi
      from apex_collections a
     where a.collection_name = 'COMPRA_DET_LOTE';

  /*select c001 selo_desc_abre,
        c002 selo_ulti_nume,
        c003 lote_desc,
        c004 lote_codi_barr,
        c005 lote_fech_elab,
        c006 lote_fech_venc,
        c007 lote_cant_medi,
        c008 deta_impo_mone_ii,
        c009 deta_impo_mmnn_ii,
        c010 deta_grav10_ii_mone,
        c011 deta_grav5_ii_mone,
        c012 deta_grav10_ii_mmnn,
        c013 deta_grav5_ii_mmnn,
        c014 deta_grav10_mone,
        c015 deta_grav5_mone,
        c016 deta_grav10_mmnn,
        c017 deta_grav5_mmnn,
        c018 deta_iva10_mone,
        c019 deta_iva5_mone,
        c020 deta_iva10_mmnn,
        c021 deta_iva5_mmnn,
        c022 deta_exen_mone,
        c023 deta_exen_mmnn,
        c024 deta_impo_mone,
        c025 deta_impo_mmnn,
        c026 s_descuento,
        c027 s_recargo,
        c028 lote_codi,
        c029 deta_prod_codi,
        c030 deta_nume_item,
        c031 deta_nume_item_codi,
        c032 indi_manu_auto,
        c033 deta_prec_unit,
        c034 impo_mone_ii_bruto,
        c035 lote_ulti_regi
   from apex_collections a
  where a.collection_name = 'COMPRA_DET_LOTE';*/

  function fp_ind_lote_prod(i_prod_codi in number) return boolean is
    v_ind_lote varchar2(5);
  begin
    null;
  
    select t.prod_indi_lote
      into v_ind_lote
      from come_prod t
     where t.prod_codi = i_prod_codi;
  
    if v_ind_lote = 'S' then
      return true;
    else
      return false;
    end if;
  end fp_ind_lote_prod;

  procedure pp_validar_lote_repetido(i_lote_desc in varchar2) is
  begin
    for c in cur_lote loop
      if c.lote_desc = i_lote_desc then
        raise_application_error(-20010,
                                'Este lote ya fue cargado, favor validar');
      end if;
    end loop;
  end pp_validar_lote_repetido;
  
   procedure pp_validar_ICCID_repetido(i_lote_ICCID in varchar2) is
  begin
    for c in cur_lote loop
      if c.lote_ICCID = i_lote_ICCID then
        raise_application_error(-20010,
                                'Este ICCID ya fue cargado, favor validar');
      end if;
    end loop;
  end pp_validar_ICCID_repetido;

  procedure pp_genera_codi_lote(p_codi      in out number,
                                i_prod_codi in number,
                                i_lote_desc in varchar2,
                                o_exist     out varchar2) is
    v_lote_codi number;
  begin
  
    begin
      select l.lote_codi
        into v_lote_codi
        from come_lote l
       where upper(ltrim(rtrim(l.lote_desc))) = ltrim(rtrim(i_lote_desc))
         and lote_prod_codi = i_prod_codi
         and nvl(lote_esta, 'A') <> 'I';
    exception
      when no_data_found then
        null;
    end;
  
    if v_lote_codi is not null then
      o_exist := 'S';
      p_codi  := v_lote_codi;
    else
      o_exist := 'N';
      select nvl(max(lote_codi), 0) + 1 into p_codi from come_lote;
    end if;
  
  exception
    when too_many_rows then
      raise_application_error(-20010,
                              'Error el lote =' || i_lote_desc ||
                              ',esta registrado mas de una vez');
  end pp_genera_codi_lote;

  procedure pp_insertar_lote(p_lote_codi      in out number,
                             p_lote_prod_codi in number,
                             p_lote_desc      in varchar2,
                             p_lote_codi_barr in varchar2,
                             p_lote_fech_elab in date,
                             p_lote_fech_venc in date,
                             p_lote_simc_codi in number) is
  
    v_lote_codi           number(10);
    v_lote_desc           varchar2(60);
    v_lote_codi_barr      varchar2(60);
    v_lote_prod_codi      number(20);
    v_lote_fech_elab      date;
    v_lote_fech_venc      date;
    v_lote_esta           varchar2(1);
    v_lote_base           number(2);
    v_lote_obse           varchar2(200);
    v_lote_prec_unit      number(20, 4);
    v_lote_cost_prom_mmnn number(20, 4);
    v_lote_obse_etiq      varchar2(100);
    v_lote_medi_larg      number(20, 4);
    v_lote_user_regi      varchar2(20);
    v_lote_fech_regi      date;
    v_lote_user_modi      varchar2(20);
    v_lote_fech_modi      date;
    v_lote_empr_codi      number(10);
    v_lote_codi_auxi      number(10);
    v_lote_tibo_codi      number(10);
    v_lote_desc_abre      varchar2(60);
    v_lote_tele           varchar2(20);
    v_lote_id             varchar2(60);
    v_lote_simc_codi      number;
  begin
    --generar el max codigo de lote
    select nvl(max(lote_codi), 0) + 1 into v_lote_codi from come_lote;
  
    p_lote_codi := v_lote_codi;
  
    v_lote_desc           := p_lote_desc;
    v_lote_codi_barr      := p_lote_codi_barr;
    v_lote_prod_codi      := p_lote_prod_codi;
    v_lote_fech_elab      := p_lote_fech_elab;
    v_lote_fech_venc      := p_lote_fech_venc;
    v_lote_esta           := 'A';
    v_lote_base           := parameter.p_codi_base;
    v_lote_empr_codi      := parameter.p_empr_codi;
    v_lote_obse           := null;
    v_lote_prec_unit      := null;
    v_lote_cost_prom_mmnn := null;
    v_lote_obse_etiq      := null;
    v_lote_medi_larg      := null;
    v_lote_user_regi      := user;
    v_lote_fech_regi      := sysdate;
    v_lote_user_modi      := null;
    v_lote_fech_modi      := null;
    v_lote_codi_auxi      := null;
    v_lote_tibo_codi      := null;
    v_lote_desc_abre      := null;
    v_lote_tele           := null; --bdet.lote_tele;
    v_lote_id             := null; --bdet.lote_id;
    v_lote_simc_codi      := p_lote_simc_codi;
    insert into come_lote
      (lote_codi,
       lote_desc,
       lote_codi_barr,
       lote_prod_codi,
       lote_fech_elab,
       lote_fech_venc,
       lote_esta,
       lote_base,
       lote_obse,
       lote_prec_unit,
       lote_cost_prom_mmnn,
       lote_obse_etiq,
       lote_medi_larg,
       lote_user_regi,
       lote_fech_regi,
       lote_user_modi,
       lote_fech_modi,
       lote_empr_codi,
       lote_codi_auxi,
       lote_tibo_codi,
       lote_desc_abre,
       lote_tele,
       lote_id,
       lote_simc_codi)
    values
      (v_lote_codi,
       v_lote_desc,
       v_lote_codi_barr,
       v_lote_prod_codi,
       v_lote_fech_elab,
       v_lote_fech_venc,
       v_lote_esta,
       v_lote_base,
       v_lote_obse,
       v_lote_prec_unit,
       v_lote_cost_prom_mmnn,
       v_lote_obse_etiq,
       v_lote_medi_larg,
       v_lote_user_regi,
       v_lote_fech_regi,
       v_lote_user_modi,
       v_lote_fech_modi,
       v_lote_empr_codi,
       v_lote_codi_auxi,
       v_lote_tibo_codi,
       v_lote_desc_abre,
       v_lote_tele,
       v_lote_id,
       v_lote_simc_codi);
       
       
          update come_lote_simc
             set simc_esta      = 'I',
                 simc_user_modi = fp_user,
                 simc_fech_modi = sysdate
           where simc_codi = v_lote_simc_codi;
  
  end pp_insertar_lote;

  function fa_sec_codi_barr_lote return number is
  begin
    return dbms_random.value;
  end fa_sec_codi_barr_lote;

  procedure pp_add_lote(i_lote_codi      in number,
                        i_lote_prod_codi in number,
                        i_lote_desc      in varchar2,
                        i_lote_codi_barr in varchar2,
                        i_lote_fech_elab in date,
                        i_lote_fech_venc in date,
                        i_lote_cantidad  in number,
                        i_lote_iccid     in varchar2,
                        i_lote_nro_line  in varchar2,
                        i_lote_simc_codi in number) is
  begin
    apex_collection.add_member(p_collection_name => 'COMPRA_DET_LOTE',
                               p_c001            => i_lote_desc,
                               
                               p_c002 => i_lote_codi_barr,
                               p_c003 => i_lote_cantidad,
                               p_c004 => i_lote_codi,
                               p_c005 => i_lote_prod_codi,
                               p_d001 => i_lote_fech_elab,
                               p_d002 => i_lote_fech_venc,
                               p_c006 => i_lote_iccid,
                               p_c007 => i_lote_nro_line,
                               p_c008 => i_lote_simc_codi );
  end pp_add_lote;

  procedure pp_carga_lote_manual(i_deta_prod_codi in number,
                                 i_lote_desc      in number,
                                 i_lote_fech_elab in date,
                                 i_lote_fech_venc in date,
                                 i_lote_cant_medi in number,
                                 i_lote_ICCID     in varchar2,
                                 i_lote_nro_linea in varchar2,
                                 i_lote_simc_codi in varchar2) is
  
    --v_sec_barr_lote number;
    v_bdet_lote cur_lote%rowtype;
    v_prod_indi_venc_lote        varchar2(1);
    v_prod_indi_iccid_lote_obli  varchar2(1);
    v_prod_indi_lote_nume_tele   varchar2(1);
  begin
     
    if i_deta_prod_codi is null then
      raise_application_error(-20010,
                              'Producto no encontrado, favor verificar datos');
    end if;
  
    if i_lote_desc is null then
      raise_application_error(-20010, 'Lote no puede quedar nulo');
    end if;
  
    if i_lote_fech_elab is null then
      raise_application_error(-20010,
                              'Fecha elaboracion no puede quedar nulo');
    end if;
  
    if i_lote_fech_venc is null then
      raise_application_error(-20010,
                              'Fecha vencimiento no puede quedar nulo');
    end if;
  
    if i_lote_fech_venc < i_lote_fech_elab then
      raise_application_error(-20010,
                              'La fecha de vencimiento no puede ser menor a la fecha de elaboracion ');
    end if;
  
    if i_lote_cant_medi is null then
      raise_application_error(-20010, 'Debe ingresar la Cantidad');
    elsif i_lote_cant_medi < 1 then
      raise_application_error(-20010, 'La Cantidad debe ser mayor a 0.');
    end if;
    
 --raise_application_error(-20010,i_deta_prod_codi);
          begin
              select nvl(prod_indi_venc_lote,'N'),
                     nvl(prod_indi_iccid_lote_obli,'N'),
                     nvl(prod_indi_lote_nume_tele,'N')
                into   v_prod_indi_venc_lote, v_prod_indi_iccid_lote_obli, v_prod_indi_lote_nume_tele
                from come_prod a
               where prod_codi = i_deta_prod_codi;

              if v_prod_indi_iccid_lote_obli = 'S'  and i_lote_ICCID is null then
              raise_application_error(-20010,'El ICCID  no puede quedar vacio');
                
              end if;

          end ;

  
  
    if not
        (apex_collection.collection_exists(p_collection_name => 'COMPRA_DET_LOTE')) then
      apex_collection.create_or_truncate_collection(p_collection_name => 'COMPRA_DET_LOTE');
    end if;
  
    --verificar tabla de lotes si no se ha generado ya la misma descripcion de lote para el producto ingresado
  
    v_bdet_lote.lote_desc      := i_lote_desc;
    v_bdet_lote.lote_codi_barr := i_lote_desc;
  
    pp_validar_lote_repetido(i_lote_desc => v_bdet_lote.lote_desc);
    pp_validar_ICCID_repetido(i_lote_ICCID => v_bdet_lote.lote_desc);
    --  v_bdet_lote.lote_fech_elab := to_char(sysdate, 'dd-mm-yyyy');
    v_bdet_lote.lote_fech_elab := i_lote_fech_elab;
    v_bdet_lote.lote_fech_venc := i_lote_fech_venc; --'03-02-2022';
    v_bdet_lote.deta_prod_codi := i_deta_prod_codi;
  
    v_bdet_lote.lote_cant_medi := i_lote_cant_medi;
    
    v_bdet_lote.lote_iccid     := i_lote_ICCID;
    v_bdet_lote.lote_nro_linea  := i_lote_nro_linea;
    v_bdet_lote.lote_simc_codi := i_lote_simc_codi;
  
    pp_add_lote(i_lote_codi      => v_bdet_lote.lote_codi,
                i_lote_prod_codi => v_bdet_lote.deta_prod_codi,
                i_lote_desc      => v_bdet_lote.lote_desc,
                i_lote_codi_barr => v_bdet_lote.lote_codi_barr,
                i_lote_fech_elab => v_bdet_lote.lote_fech_elab,
                i_lote_fech_venc => v_bdet_lote.lote_fech_venc,
                i_lote_cantidad  => v_bdet_lote.lote_cant_medi,
                i_lote_iccid     => v_bdet_lote.lote_ICCID,
                i_lote_nro_line  => v_bdet_lote.lote_nro_linea,
                i_lote_simc_codi => v_bdet_lote.lote_simc_codi);
  
  end pp_carga_lote_manual;

  procedure pp_carga_deta_lote(i_deta_prod_codi number,
                               i_selo_codi      number,
                               i_deta_cant      number,
                               i_cant_lote      number) is
  
    --v_sec_barr_lote number;
    v_bdet_lote     cur_lote%rowtype;
    v_cant_secu     number := 0;
    v_sum_cant_medi number := 0;
    v_cant          number := 0;
  
    v_selo_desc_abre varchar2(200);
    v_selo_ulti_nume number;
  
  begin
    if i_deta_prod_codi is null then
      raise_application_error(-20010,
                              'Producto no encontrado, favor verificar datos');
    end if;
  
    if i_cant_lote is null then
      raise_application_error(-20010,
                              'Debe ingresar la Cantidad en que se dividira cada Lote.');
    elsif i_cant_lote < 1 then
      raise_application_error(-20010,
                              'La Cantidad en que se dividira cada Lote debe ser mayor a 0.');
    elsif i_cant_lote > i_deta_cant then
      raise_application_error(-20010,
                              'La Cantidad en que se dividira cada Lote no puede ser mayor a la Cantidad del item: ' ||
                              i_deta_cant || '.');
    end if;
  
    if i_deta_cant is null then
      raise_application_error(-20010,
                              'La cantidad del producto no puede ser nulo');
    end if;
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'COMPRA_DET_LOTE');
  
    select selo_desc_abre, selo_ulti_nume
      into v_selo_desc_abre, v_selo_ulti_nume
      from come_lote_secu_alia
     where selo_codi = i_selo_codi
       and selo_empr_codi = 1;
  
    loop
    
      v_bdet_lote.deta_prod_codi := i_deta_prod_codi;
    
      --v_bdet_lote.lote_codi_barr := v_bdet_lote.lote_desc;
      --verificar tabla de lotes si no se ha generado ya la misma descripcion de lote para el producto ingresado
    
      v_cant_secu      := v_cant_secu + 1;
      v_selo_ulti_nume := v_selo_ulti_nume + v_cant_secu;
    
      v_bdet_lote.lote_codi_barr := v_selo_ulti_nume;
      v_bdet_lote.lote_desc      := v_selo_desc_abre || v_selo_ulti_nume;
    
      pp_validar_lote_repetido(i_lote_desc => v_bdet_lote.lote_desc);
      -------------------
      --  v_bdet_lote.lote_fech_elab := to_char(sysdate, 'dd-mm-yyyy');
      v_bdet_lote.lote_fech_elab := trunc(sysdate);
    
      v_bdet_lote.lote_fech_venc := add_months(trunc(sysdate), 24); --'03-02-2022';
      --v_bdet_lote.lote_fech_venc := v_bdet_lote.lote_fech_venc;
    
      ---dividir cantidades por item
      if (i_deta_cant - v_sum_cant_medi) < i_cant_lote then
        v_bdet_lote.lote_cant_medi := i_deta_cant - v_sum_cant_medi;
      else
        v_bdet_lote.lote_cant_medi := i_cant_lote;
      end if;
    
      v_cant          := v_cant + 1;
      v_sum_cant_medi := v_sum_cant_medi + v_bdet_lote.lote_cant_medi;
    
      v_bdet_lote.lote_ICCID     := null;
      v_bdet_lote.lote_nro_linea := null;
      v_bdet_lote.lote_simc_codi := null;
                  
      pp_add_lote(i_lote_codi      => v_bdet_lote.lote_codi,
                  i_lote_prod_codi => v_bdet_lote.deta_prod_codi,
                  i_lote_desc      => v_bdet_lote.lote_desc,
                  i_lote_codi_barr => v_bdet_lote.lote_codi_barr,
                  i_lote_fech_elab => v_bdet_lote.lote_fech_elab,
                  i_lote_fech_venc => v_bdet_lote.lote_fech_venc,
                  i_lote_cantidad  => v_bdet_lote.lote_cant_medi,
                  i_lote_iccid     => v_bdet_lote.lote_ICCID,
                  i_lote_nro_line  => v_bdet_lote.lote_nro_linea,
                  i_lote_simc_codi => v_bdet_lote.lote_simc_codi
                  );
    
      exit when v_sum_cant_medi = i_deta_cant;
    
    end loop;
  
    --:parameter.p_ind_validar_det_lote := 'S';
  
  end pp_carga_deta_lote;

  function fp_dev_indi_suma_rest(p_oper_codi in number) return char is
    v_stoc_suma_rest char(1);
  begin
    select oper_stoc_suma_rest
      into v_stoc_suma_rest
      from come_stoc_oper
     where oper_codi = p_oper_codi;
  
    return v_stoc_suma_rest;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Codigo de Operacion Inexistente');
  end fp_dev_indi_suma_rest;

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
                                p_movi_stoc_afec_cost_prom in varchar2,
                                p_movi_empr_codi           in number,
                                p_movi_base                in number,
                                p_movi_fech_oper           in date,
                                p_movi_impo_mone_ii        in number,
                                p_movi_impo_mmnn_ii        in number,
                                p_movi_grav5_mone          in number,
                                p_movi_grav5_mmnn          in number,
                                p_movi_grav10_mone         in number,
                                p_movi_grav10_mmnn         in number,
                                p_movi_iva5_mone           in number,
                                p_movi_iva5_mmnn           in number,
                                p_movi_iva10_mone          in number,
                                p_movi_iva10_mmnn          in number,
                                p_movi_grav5_ii_mone       in number,
                                p_movi_grav5_ii_mmnn       in number,
                                p_movi_grav10_ii_mone      in number,
                                p_movi_grav10_ii_mmnn      in number) is
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
       movi_stoc_afec_cost_prom,
       movi_empr_codi,
       movi_base,
       movi_fech_oper,
       movi_impo_mone_ii,
       movi_impo_mmnn_ii,
       movi_grav5_mone,
       movi_grav5_mmnn,
       movi_grav10_mone,
       movi_grav10_mmnn,
       movi_iva5_mone,
       movi_iva5_mmnn,
       movi_iva10_mone,
       movi_iva10_mmnn,
       movi_grav5_ii_mone,
       movi_grav5_ii_mmnn,
       movi_grav10_ii_mone,
       movi_grav10_ii_mmnn)
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
       p_movi_stoc_afec_cost_prom,
       p_movi_empr_codi,
       p_movi_base,
       p_movi_fech_oper,
       p_movi_impo_mone_ii,
       p_movi_impo_mmnn_ii,
       p_movi_grav5_mone,
       p_movi_grav5_mmnn,
       p_movi_grav10_mone,
       p_movi_grav10_mmnn,
       p_movi_iva5_mone,
       p_movi_iva5_mmnn,
       p_movi_iva10_mone,
       p_movi_iva10_mmnn,
       p_movi_grav5_ii_mone,
       p_movi_grav5_ii_mmnn,
       p_movi_grav10_ii_mone,
       p_movi_grav10_ii_mmnn);
  
  exception
  
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_insert_come_movi;

  procedure pp_veri_prod_arma_desa is
    v_nro_item number := 0;
  begin
    null;
    /*
    go_block('bdet');
    first_record;
    if bdet.deta_prod_codi is null then
      raise_application_error(-20010,'Debe ingresar al menos un item.');
    end if;
    loop
      if bdet.deta_prod_codi = bcab.prod_codi then
        raise_application_error(-20010,'No se puede ingresar como parte del Detalle el mismo producto a ser Armado/Desarmado. Item nro: ' ||
              bdet.deta_nume_item || '.');
      end if;
      exit when :system.last_record = 'TRUE';
      next_record;
    end loop;*/
  
  end pp_veri_prod_arma_desa;

  procedure pp_valida_stock(p_prod      in number,
                            p_depo      in number,
                            p_cant      in number,
                            p_prod_desc in varchar2,
                            p_prod_alfa in varchar2) is
    v_stock          number;
    v_indi_fact_nega varchar2(1);
  begin
    begin
    
      select p.prod_indi_fact_nega
        into v_indi_fact_nega
        from come_prod p
       where p.prod_codi = p_prod;
    exception
      when others then
        raise_application_error(-20010, sqlerrm);
    end;
  
    v_stock := fa_dev_stoc_actu(p_prod, p_depo); -- recupera la existencia en deposito
  
    if p_cant > v_stock then
      if upper(nvl(parameter.p_perm_stoc_nega, 's')) = upper('s') then
        if upper(nvl(v_indi_fact_nega, 'n')) = upper('s') then
          if upper(nvl(parameter.p_indi_most_mens_aler, 's')) = upper('s') then
            null;
            --   raise_application_error(-20010,'Atencion!! La cantidad del articulo ' || p_prod_alfa || ' ' ||
            --         p_prod_desc || ' supera el Stock!!!');
          end if;
        else
          raise_application_error(-20010,
                                  'Atencion!! La cantidad del articulo ' ||
                                  p_prod_alfa || ' ' || p_prod_desc ||
                                  ' supera el Stock!!!');
        end if;
      else
        raise_application_error(-20010,
                                'Atencion!! La cantidad del articulo ' ||
                                p_prod_alfa || ' ' || p_prod_desc ||
                                ' supera el Stock!!!');
      end if;
    end if;
  end pp_valida_stock;

  procedure pp_validar_repeticion_prod is
    v_cant_reg number; --cantidad de registros en el bloque
    --i          number;
    -- j          number;
    salir exception;
    v_ant_art number;
  
    type t_cur is table of cur_det%rowtype;
    v_cur t_cur;
  begin
  
    open cur_det;
    fetch cur_det bulk collect
      into v_cur;
    close cur_det;
  
    for i in 1 .. v_cur.last loop
      for j in 1 .. v_cur.last loop
        if v_cur(i).deta_prod_codi = v_cur(j).deta_prod_codi and v_cur(i)
           .prod_lote_codi = v_cur(j).prod_lote_codi and v_cur(i)
           .seq_id <> v_cur(j).seq_id then
          raise_application_error(-20010,
                                  'El codigo de Producto del item ' ||
                                  to_char(v_cur(i).seq_id) ||
                                  ' se repite con el del item ' ||
                                  to_char(v_cur(j).seq_id) ||
                                  '. asegurese de no introducir mas de una' ||
                                  ' vez el mismo codigo!');
        end if;
      end loop;
    end loop;
    --  raise_application_error(-20010, 'Pasa');
  
  exception
    when salir then
      null;
  end pp_validar_repeticion_prod;

  procedure pp_reenumerar_nro_item is
    v_nro_item number := 0;
    v_cant_det number := 0;
  begin
  
    /* go_block('bdet');
    first_record;
    if bdet.deta_prod_codi is null then
      raise_application_error(-20010,'Debe ingresar al menos un item.');
    end if;*/
    for bdet in cur_det loop
      v_cant_det          := v_cant_det + 1;
      v_nro_item          := v_nro_item + 1;
      bdet.deta_nume_item := v_nro_item;
    
      if bcab.indi_arma_desa = 'A' then
        null;
        pp_valida_stock(bdet.deta_prod_codi,
                        bcab.movi_depo_codi_orig,
                        nvl(bdet.deta_cant, 0),
                        bdet.deta_prod_desc,
                        bdet.deta_prod_codi_alfa);
      else
        if bdet.deta_porc_cost is null or bdet.deta_porc_cost = 0 then
          raise_application_error(-20010,
                                  'El item Nro ' || bdet.deta_nume_item ||
                                  ' no posee % de Distribucion.');
        end if;
      end if;
    end loop;
  
    if v_cant_det = 0 then
      raise_application_error(-20010, 'Debe ingresar al menos un item.');
    end if;
  end pp_reenumerar_nro_item;

  procedure pp_validar is
    v_sum_porc           number := 0;
    v_cant_det           number := 0;
    v_sum_lote_cant_medi number := 0;
    v_ind_lote           varchar2(2);
  begin
    if bcab.prod_codi is null then
      raise_application_error(-20010,
                              'Debe indicar el Producto para el Armado/Desarmado.');
    end if;
  
    if bcab.s_cant is null then
      raise_application_error(-20010,
                              'Debe indicar la Cantidad del Producto para el Armado/Desarmado.');
    end if;
  
    if bcab.indi_arma_desa = 'D' then
      for c in cur_det loop
        v_cant_det := v_cant_det + 1;
        v_sum_porc := v_sum_porc + nvl(c.deta_porc_cost, 0);
      end loop;
    
      if v_cant_det = 0 then
        raise_application_error(-20010, 'Debe ingresar al menos un item.');
      end if;
      if v_sum_porc <> 100 then
        raise_application_error(-20010,
                                'El % Total de Distribucion debe ser igual al 100% en el detalle.');
      end if;
      if fp_ind_lote_prod(i_prod_codi => bcab.prod_codi) then
        if bcab.prod_lote_codi is null then
          raise_application_error(-20010,
                                  'Debe ingresar lote del producto');
        end if;
      end if;
    else
      if fp_ind_lote_prod(i_prod_codi => bcab.prod_codi) then
        for c in cur_lote loop
          v_sum_lote_cant_medi := v_sum_lote_cant_medi + c.lote_cant_medi;
        end loop;
        if v_sum_lote_cant_medi <> bcab.s_cant then
          raise_application_error(-20010,
                                  'La Cantidad total de Lotes no puede ser distinta a la Cantidad del item.');
        end if;
      end if;
    end if;
  
    if fp_ind_lote_prod(i_prod_codi => bcab.prod_codi) then
      v_ind_lote := 'S';
    else
      v_ind_lote := 'N';
    end if;
  
    -- call the procedure
    i020317.pp_precio_producto(i_prod_codi           => bcab.prod_codi,
                               i_prod_ind_lote       => v_ind_lote,
                               i_prod_lote_codi      => bcab.prod_lote_codi,
                               i_indi_arma_desa      => bcab.indi_arma_desa,
                               o_prod_cost_prom_actu => bcab.prod_cost_prom_actu);
  
  end pp_validar;

  procedure pp_actualiza_come_movi is
    v_movi_codi                number(20);
    v_movi_timo_codi           number(10);
    v_movi_clpr_codi           number(20);
    v_movi_sucu_codi_orig      number(10);
    v_movi_depo_codi_orig      number(10);
    v_movi_sucu_codi_dest      number(10);
    v_movi_depo_codi_dest      number(10);
    v_movi_oper_codi           number(10);
    v_movi_cuen_codi           number(4);
    v_movi_mone_codi           number(4);
    v_movi_nume                number(20);
    v_movi_fech_emis           date;
    v_movi_fech_grab           date;
    v_movi_user                varchar2(20);
    v_movi_codi_padr           number(20);
    v_movi_tasa_mone           number(20, 4);
    v_movi_tasa_mmee           number(20, 4);
    v_movi_grav_mmnn           number(20, 4);
    v_movi_exen_mmnn           number(20, 4);
    v_movi_iva_mmnn            number(20, 4);
    v_movi_grav_mmee           number(20, 4);
    v_movi_exen_mmee           number(20, 4);
    v_movi_iva_mmee            number(20, 4);
    v_movi_grav_mone           number(20, 4);
    v_movi_exen_mone           number(20, 4);
    v_movi_iva_mone            number(20, 4);
    v_movi_obse                varchar2(2000);
    v_movi_sald_mmnn           number(20, 4);
    v_movi_sald_mmee           number(20, 4);
    v_movi_sald_mone           number(20, 4);
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_empr_codi           number(2);
    v_movi_base                number(2);
    v_movi_fech_oper           date;
    v_movi_impo_mone_ii        number(20, 4);
    v_movi_impo_mmnn_ii        number(20, 4);
    v_movi_grav5_mone          number(20, 4);
    v_movi_grav5_mmnn          number(20, 4);
    v_movi_grav10_mone         number(20, 4);
    v_movi_grav10_mmnn         number(20, 4);
    v_movi_iva5_mone           number(20, 4);
    v_movi_iva5_mmnn           number(20, 4);
    v_movi_iva10_mone          number(20, 4);
    v_movi_iva10_mmnn          number(20, 4);
    v_movi_grav5_ii_mone       number(20, 4);
    v_movi_grav5_ii_mmnn       number(20, 4);
    v_movi_grav10_ii_mone      number(20, 4);
    v_movi_grav10_ii_mmnn      number(20, 4);
  
  begin
    -- si es armado primero se inserta la cabecera, si es desarmado primero se ingresa primero el detalle
    if bcab.indi_arma_desa = 'A' then
      -- asignar valores del armado(cabecera)....
      bcab.movi_codi             := fa_sec_come_movi;
      v_movi_codi                := bcab.movi_codi;
      v_movi_timo_codi           := null;
      v_movi_clpr_codi           := null;
      v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
      v_movi_depo_codi_orig      := bcab.movi_depo_codi_orig;
      v_movi_sucu_codi_dest      := null;
      v_movi_depo_codi_dest      := null;
      v_movi_oper_codi           := parameter.p_codi_oper_arma;
      v_movi_cuen_codi           := null;
      v_movi_mone_codi           := parameter.p_codi_mone_mmnn;
      v_movi_nume                := bcab.movi_nume;
      v_movi_fech_emis           := bcab.movi_fech_emis;
      v_movi_fech_grab           := sysdate;
      v_movi_user                := fp_user;
      v_movi_codi_padr           := null;
      v_movi_tasa_mone           := 1;
      v_movi_tasa_mmee           := null;
      v_movi_grav_mmnn           := 0;
      v_movi_exen_mmnn           := round(nvl(bcab.prod_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_iva_mmnn            := 0;
      v_movi_grav_mmee           := 0;
      v_movi_exen_mmee           := 0;
      v_movi_iva_mmee            := 0;
      v_movi_grav_mone           := 0;
      v_movi_exen_mone           := round(nvl(bcab.prod_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_iva_mone            := 0;
      v_movi_obse                := bcab.movi_obse;
      v_movi_sald_mmnn           := 0;
      v_movi_sald_mmee           := 0;
      v_movi_sald_mone           := 0;
      v_movi_stoc_suma_rest      := fp_dev_indi_suma_rest(parameter.p_codi_oper_arma);
      v_movi_stoc_afec_cost_prom := 'S';
      v_movi_empr_codi           := bcab.movi_empr_codi;
      v_movi_base                := parameter.p_codi_base;
      v_movi_fech_oper           := bcab.movi_fech_emis;
      v_movi_impo_mone_ii        := round(nvl(bcab.prod_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_impo_mmnn_ii        := round(nvl(bcab.prod_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_grav5_mone          := 0;
      v_movi_grav5_mmnn          := 0;
      v_movi_grav10_mone         := 0;
      v_movi_grav10_mmnn         := 0;
      v_movi_iva5_mone           := 0;
      v_movi_iva5_mmnn           := 0;
      v_movi_iva10_mone          := 0;
      v_movi_iva10_mmnn          := 0;
      v_movi_grav5_ii_mone       := 0;
      v_movi_grav5_ii_mmnn       := 0;
      v_movi_grav10_ii_mone      := 0;
      v_movi_grav10_ii_mmnn      := 0;
    
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
                          v_movi_stoc_afec_cost_prom,
                          v_movi_empr_codi,
                          v_movi_base,
                          v_movi_fech_oper,
                          v_movi_impo_mone_ii,
                          v_movi_impo_mmnn_ii,
                          v_movi_grav5_mone,
                          v_movi_grav5_mmnn,
                          v_movi_grav10_mone,
                          v_movi_grav10_mmnn,
                          v_movi_iva5_mone,
                          v_movi_iva5_mmnn,
                          v_movi_iva10_mone,
                          v_movi_iva10_mmnn,
                          v_movi_grav5_ii_mone,
                          v_movi_grav5_ii_mmnn,
                          v_movi_grav10_ii_mone,
                          v_movi_grav10_ii_mmnn);
    
      ----luego se ingresa el detalle-------------
      -- asignar valores del desarmado(detalle)....
      g_bdet.deta_movi_codi      := fa_sec_come_movi;
      v_movi_codi                := g_bdet.deta_movi_codi;
      v_movi_timo_codi           := null;
      v_movi_clpr_codi           := null;
      v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
      v_movi_depo_codi_orig      := bcab.movi_depo_codi_orig;
      v_movi_sucu_codi_dest      := null;
      v_movi_depo_codi_dest      := null;
      v_movi_oper_codi           := parameter.p_codi_oper_desa;
      v_movi_cuen_codi           := null;
      v_movi_mone_codi           := parameter.p_codi_mone_mmnn;
      v_movi_nume                := bcab.movi_nume;
      v_movi_fech_emis           := bcab.movi_fech_emis;
      v_movi_fech_grab           := sysdate;
      v_movi_user                := fp_user;
      v_movi_codi_padr           := bcab.movi_codi;
      v_movi_tasa_mone           := 1;
      v_movi_tasa_mmee           := null;
      v_movi_grav_mmnn           := 0;
      v_movi_exen_mmnn           := round(nvl(g_bdet.sum_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_iva_mmnn            := 0;
      v_movi_grav_mmee           := 0;
      v_movi_exen_mmee           := 0;
      v_movi_iva_mmee            := 0;
      v_movi_grav_mone           := 0;
      v_movi_exen_mone           := round(nvl(g_bdet.sum_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_iva_mone            := 0;
      v_movi_obse                := bcab.movi_obse;
      v_movi_sald_mmnn           := 0;
      v_movi_sald_mmee           := 0;
      v_movi_sald_mone           := 0;
      v_movi_stoc_suma_rest      := fp_dev_indi_suma_rest(parameter.p_codi_oper_desa);
      v_movi_stoc_afec_cost_prom := 'N';
      v_movi_empr_codi           := bcab.movi_empr_codi;
      v_movi_base                := parameter.p_codi_base;
      v_movi_fech_oper           := bcab.movi_fech_emis;
      v_movi_impo_mone_ii        := round(nvl(g_bdet.sum_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_impo_mmnn_ii        := round(nvl(g_bdet.sum_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_grav5_mone          := 0;
      v_movi_grav5_mmnn          := 0;
      v_movi_grav10_mone         := 0;
      v_movi_grav10_mmnn         := 0;
      v_movi_iva5_mone           := 0;
      v_movi_iva5_mmnn           := 0;
      v_movi_iva10_mone          := 0;
      v_movi_iva10_mmnn          := 0;
      v_movi_grav5_ii_mone       := 0;
      v_movi_grav5_ii_mmnn       := 0;
      v_movi_grav10_ii_mone      := 0;
      v_movi_grav10_ii_mmnn      := 0;
    
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
                          v_movi_stoc_afec_cost_prom,
                          v_movi_empr_codi,
                          v_movi_base,
                          v_movi_fech_oper,
                          v_movi_impo_mone_ii,
                          v_movi_impo_mmnn_ii,
                          v_movi_grav5_mone,
                          v_movi_grav5_mmnn,
                          v_movi_grav10_mone,
                          v_movi_grav10_mmnn,
                          v_movi_iva5_mone,
                          v_movi_iva5_mmnn,
                          v_movi_iva10_mone,
                          v_movi_iva10_mmnn,
                          v_movi_grav5_ii_mone,
                          v_movi_grav5_ii_mmnn,
                          v_movi_grav10_ii_mone,
                          v_movi_grav10_ii_mmnn);
    
    elsif bcab.indi_arma_desa = 'D' then
      -- asignar valores del armado(detalle)....
      g_bdet.deta_movi_codi      := fa_sec_come_movi;
      v_movi_codi                := g_bdet.deta_movi_codi;
      v_movi_timo_codi           := null;
      v_movi_clpr_codi           := null;
      v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
      v_movi_depo_codi_orig      := bcab.movi_depo_codi_orig;
      v_movi_sucu_codi_dest      := null;
      v_movi_depo_codi_dest      := null;
      v_movi_oper_codi           := parameter.p_codi_oper_arma;
      v_movi_cuen_codi           := null;
      v_movi_mone_codi           := parameter.p_codi_mone_mmnn;
      v_movi_nume                := bcab.movi_nume;
      v_movi_fech_emis           := bcab.movi_fech_emis;
      v_movi_fech_grab           := sysdate;
      v_movi_user                := fp_user;
      v_movi_codi_padr           := null;
      v_movi_tasa_mone           := 1;
      v_movi_tasa_mmee           := null;
      v_movi_grav_mmnn           := 0;
      v_movi_exen_mmnn           := round(nvl(g_bdet.sum_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_iva_mmnn            := 0;
      v_movi_grav_mmee           := 0;
      v_movi_exen_mmee           := 0;
      v_movi_iva_mmee            := 0;
      v_movi_grav_mone           := 0;
      v_movi_exen_mone           := round(nvl(g_bdet.sum_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_iva_mone            := 0;
      v_movi_obse                := bcab.movi_obse;
      v_movi_sald_mmnn           := 0;
      v_movi_sald_mmee           := 0;
      v_movi_sald_mone           := 0;
      v_movi_stoc_suma_rest      := fp_dev_indi_suma_rest(parameter.p_codi_oper_arma);
      v_movi_stoc_afec_cost_prom := 'S';
      v_movi_empr_codi           := bcab.movi_empr_codi;
      v_movi_base                := parameter.p_codi_base;
      v_movi_fech_oper           := bcab.movi_fech_emis;
      v_movi_impo_mone_ii        := round(nvl(g_bdet.sum_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_impo_mmnn_ii        := round(nvl(g_bdet.sum_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_grav5_mone          := 0;
      v_movi_grav5_mmnn          := 0;
      v_movi_grav10_mone         := 0;
      v_movi_grav10_mmnn         := 0;
      v_movi_iva5_mone           := 0;
      v_movi_iva5_mmnn           := 0;
      v_movi_iva10_mone          := 0;
      v_movi_iva10_mmnn          := 0;
      v_movi_grav5_ii_mone       := 0;
      v_movi_grav5_ii_mmnn       := 0;
      v_movi_grav10_ii_mone      := 0;
      v_movi_grav10_ii_mmnn      := 0;
    
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
                          v_movi_stoc_afec_cost_prom,
                          v_movi_empr_codi,
                          v_movi_base,
                          v_movi_fech_oper,
                          v_movi_impo_mone_ii,
                          v_movi_impo_mmnn_ii,
                          v_movi_grav5_mone,
                          v_movi_grav5_mmnn,
                          v_movi_grav10_mone,
                          v_movi_grav10_mmnn,
                          v_movi_iva5_mone,
                          v_movi_iva5_mmnn,
                          v_movi_iva10_mone,
                          v_movi_iva10_mmnn,
                          v_movi_grav5_ii_mone,
                          v_movi_grav5_ii_mmnn,
                          v_movi_grav10_ii_mone,
                          v_movi_grav10_ii_mmnn);
    
      ----luego se ingresa la cabecera-----------
      -- asignar valores del desarmado(cabecera)....
      bcab.movi_codi             := fa_sec_come_movi;
      v_movi_codi                := bcab.movi_codi;
      v_movi_timo_codi           := null;
      v_movi_clpr_codi           := null;
      v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
      v_movi_depo_codi_orig      := bcab.movi_depo_codi_orig;
      v_movi_sucu_codi_dest      := null;
      v_movi_depo_codi_dest      := null;
      v_movi_oper_codi           := parameter.p_codi_oper_desa;
      v_movi_cuen_codi           := null;
      v_movi_mone_codi           := parameter.p_codi_mone_mmnn;
      v_movi_nume                := bcab.movi_nume;
      v_movi_fech_emis           := bcab.movi_fech_emis;
      v_movi_fech_grab           := sysdate;
      v_movi_user                := fp_user;
      v_movi_codi_padr           := g_bdet.deta_movi_codi;
      v_movi_tasa_mone           := 1;
      v_movi_tasa_mmee           := null;
      v_movi_grav_mmnn           := 0;
      v_movi_exen_mmnn           := round(nvl(bcab.prod_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_iva_mmnn            := 0;
      v_movi_grav_mmee           := 0;
      v_movi_exen_mmee           := 0;
      v_movi_iva_mmee            := 0;
      v_movi_grav_mone           := 0;
      v_movi_exen_mone           := round(nvl(bcab.prod_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_iva_mone            := 0;
      v_movi_obse                := bcab.movi_obse;
      v_movi_sald_mmnn           := 0;
      v_movi_sald_mmee           := 0;
      v_movi_sald_mone           := 0;
      v_movi_stoc_suma_rest      := fp_dev_indi_suma_rest(parameter.p_codi_oper_desa);
      v_movi_stoc_afec_cost_prom := 'S';
      v_movi_empr_codi           := bcab.movi_empr_codi;
      v_movi_base                := parameter.p_codi_base;
      v_movi_fech_oper           := bcab.movi_fech_emis;
      v_movi_impo_mone_ii        := round(nvl(bcab.prod_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_impo_mmnn_ii        := round(nvl(bcab.prod_cost_prom_tota, 0),
                                          parameter.p_cant_deci_cant);
      v_movi_grav5_mone          := 0;
      v_movi_grav5_mmnn          := 0;
      v_movi_grav10_mone         := 0;
      v_movi_grav10_mmnn         := 0;
      v_movi_iva5_mone           := 0;
      v_movi_iva5_mmnn           := 0;
      v_movi_iva10_mone          := 0;
      v_movi_iva10_mmnn          := 0;
      v_movi_grav5_ii_mone       := 0;
      v_movi_grav5_ii_mmnn       := 0;
      v_movi_grav10_ii_mone      := 0;
      v_movi_grav10_ii_mmnn      := 0;
    
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
                          v_movi_stoc_afec_cost_prom,
                          v_movi_empr_codi,
                          v_movi_base,
                          v_movi_fech_oper,
                          v_movi_impo_mone_ii,
                          v_movi_impo_mmnn_ii,
                          v_movi_grav5_mone,
                          v_movi_grav5_mmnn,
                          v_movi_grav10_mone,
                          v_movi_grav10_mmnn,
                          v_movi_iva5_mone,
                          v_movi_iva5_mmnn,
                          v_movi_iva10_mone,
                          v_movi_iva10_mmnn,
                          v_movi_grav5_ii_mone,
                          v_movi_grav5_ii_mmnn,
                          v_movi_grav10_ii_mone,
                          v_movi_grav10_ii_mmnn);
    end if;
  
  end pp_actualiza_come_movi;

  procedure pp_insert_come_movi_prod_deta(p_deta_movi_codi      in number,
                                          p_deta_nume_item      in number,
                                          p_deta_impu_codi      in number,
                                          p_deta_prod_codi      in number,
                                          p_deta_cant           in number,
                                          p_deta_impo_mone      in number,
                                          p_deta_impo_mmnn      in number,
                                          p_deta_impo_mmee      in number,
                                          p_deta_iva_mmnn       in number,
                                          p_deta_iva_mmee       in number,
                                          p_deta_iva_mone       in number,
                                          p_deta_prec_unit      in number,
                                          p_deta_base           in number,
                                          p_deta_impo_mone_ii   in number,
                                          p_deta_impo_mmnn_ii   in number,
                                          p_deta_exen_mone      in number,
                                          p_deta_exen_mmnn      in number,
                                          p_deta_grav5_mone     in number,
                                          p_deta_grav5_mmnn     in number,
                                          p_deta_grav10_mone    in number,
                                          p_deta_grav10_mmnn    in number,
                                          p_deta_iva5_mone      in number,
                                          p_deta_iva5_mmnn      in number,
                                          p_deta_iva10_mone     in number,
                                          p_deta_iva10_mmnn     in number,
                                          p_deta_grav5_ii_mone  in number,
                                          p_deta_grav5_ii_mmnn  in number,
                                          p_deta_grav10_ii_mone in number,
                                          p_deta_grav10_ii_mmnn in number,
                                          p_deta_lote_codi      in number) is
  begin
    insert into come_movi_prod_deta
      (deta_movi_codi,
       deta_nume_item,
       deta_impu_codi,
       deta_prod_codi,
       deta_cant,
       deta_lote_codi,
       deta_impo_mone,
       deta_impo_mmnn,
       deta_impo_mmee,
       deta_iva_mmnn,
       deta_iva_mmee,
       deta_iva_mone,
       deta_prec_unit,
       deta_base,
       deta_impo_mone_ii,
       deta_impo_mmnn_ii,
       deta_exen_mone,
       deta_exen_mmnn,
       deta_grav5_mone,
       deta_grav5_mmnn,
       deta_grav10_mone,
       deta_grav10_mmnn,
       deta_iva5_mone,
       deta_iva5_mmnn,
       deta_iva10_mone,
       deta_iva10_mmnn,
       deta_grav5_ii_mone,
       deta_grav5_ii_mmnn,
       deta_grav10_ii_mone,
       deta_grav10_ii_mmnn)
    values
      (p_deta_movi_codi,
       p_deta_nume_item,
       p_deta_impu_codi,
       p_deta_prod_codi,
       p_deta_cant,
       p_deta_lote_codi,
       p_deta_impo_mone,
       p_deta_impo_mmnn,
       p_deta_impo_mmee,
       p_deta_iva_mmnn,
       p_deta_iva_mmee,
       p_deta_iva_mone,
       p_deta_prec_unit,
       p_deta_base,
       p_deta_impo_mone_ii,
       p_deta_impo_mmnn_ii,
       p_deta_exen_mone,
       p_deta_exen_mmnn,
       p_deta_grav5_mone,
       p_deta_grav5_mmnn,
       p_deta_grav10_mone,
       p_deta_grav10_mmnn,
       p_deta_iva5_mone,
       p_deta_iva5_mmnn,
       p_deta_iva10_mone,
       p_deta_iva10_mmnn,
       p_deta_grav5_ii_mone,
       p_deta_grav5_ii_mmnn,
       p_deta_grav10_ii_mone,
       p_deta_grav10_ii_mmnn);
  
  exception
  
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_insert_come_movi_prod_deta;

  procedure pp_actualiza_come_movi_prod is
    v_deta_movi_codi      number(20);
    v_deta_nume_item      number(5);
    v_deta_impu_codi      number(10);
    v_deta_prod_codi      number(20);
    v_deta_cant           number(20, 4);
    v_deta_impo_mone      number(20, 4);
    v_deta_impo_mmnn      number(20, 4);
    v_deta_impo_mmee      number(20, 4);
    v_deta_iva_mmnn       number(20, 4);
    v_deta_iva_mmee       number(20, 4);
    v_deta_iva_mone       number(20, 4);
    v_deta_prec_unit      number(20, 4);
    v_deta_base           number(2);
    v_deta_impo_mone_ii   number(20, 4);
    v_deta_impo_mmnn_ii   number(20, 4);
    v_deta_exen_mone      number(20, 4);
    v_deta_exen_mmnn      number(20, 4);
    v_deta_grav5_mone     number(20, 4);
    v_deta_grav5_mmnn     number(20, 4);
    v_deta_grav10_mone    number(20, 4);
    v_deta_grav10_mmnn    number(20, 4);
    v_deta_iva5_mone      number(20, 4);
    v_deta_iva5_mmnn      number(20, 4);
    v_deta_iva10_mone     number(20, 4);
    v_deta_iva10_mmnn     number(20, 4);
    v_deta_grav5_ii_mone  number(20, 4);
    v_deta_grav5_ii_mmnn  number(20, 4);
    v_deta_grav10_ii_mone number(20, 4);
    v_deta_grav10_ii_mmnn number(20, 4);
    v_exist_lote_cab      varchar2(2);
    v_deta_lote_codi      number;
    v_bandera_lote_cab    varchar2(5) := 'N';
  
    procedure pp_llama_insert is
    begin
      pp_insert_come_movi_prod_deta(v_deta_movi_codi,
                                    v_deta_nume_item,
                                    v_deta_impu_codi,
                                    v_deta_prod_codi,
                                    v_deta_cant,
                                    v_deta_impo_mone,
                                    v_deta_impo_mmnn,
                                    v_deta_impo_mmee,
                                    v_deta_iva_mmnn,
                                    v_deta_iva_mmee,
                                    v_deta_iva_mone,
                                    v_deta_prec_unit,
                                    v_deta_base,
                                    v_deta_impo_mone_ii,
                                    v_deta_impo_mmnn_ii,
                                    v_deta_exen_mone,
                                    v_deta_exen_mmnn,
                                    v_deta_grav5_mone,
                                    v_deta_grav5_mmnn,
                                    v_deta_grav10_mone,
                                    v_deta_grav10_mmnn,
                                    v_deta_iva5_mone,
                                    v_deta_iva5_mmnn,
                                    v_deta_iva10_mone,
                                    v_deta_iva10_mmnn,
                                    v_deta_grav5_ii_mone,
                                    v_deta_grav5_ii_mmnn,
                                    v_deta_grav10_ii_mone,
                                    v_deta_grav10_ii_mmnn,
                                    v_deta_lote_codi);
    end pp_llama_insert;
  begin
  
    --raise_application_error(-20010, 'x');
  
    -- insertar el detalle para el armado/desarmado--
    -- asignar valores de la cabecera----------------
  
    v_deta_nume_item := 0;
  
    --raise_application_error(-20010, bcab.movi_codi);
    v_deta_movi_codi := bcab.movi_codi;
    v_deta_impu_codi := null;
    v_deta_prod_codi := bcab.prod_codi;
  
    v_deta_impo_mone := round(nvl(bcab.prod_cost_prom_tota, 0),
                              parameter.p_cant_deci_cant);
    v_deta_impo_mmnn := round(nvl(bcab.prod_cost_prom_tota, 0),
                              parameter.p_cant_deci_cant);
    v_deta_impo_mmee := 0;
    v_deta_iva_mmnn  := 0;
    v_deta_iva_mmee  := 0;
    v_deta_iva_mone  := 0;
  
    v_deta_base           := parameter.p_codi_base;
    v_deta_impo_mone_ii   := round(nvl(bcab.prod_cost_prom_tota, 0),
                                   parameter.p_cant_deci_cant);
    v_deta_impo_mmnn_ii   := round(nvl(bcab.prod_cost_prom_tota, 0),
                                   parameter.p_cant_deci_cant);
    v_deta_exen_mone      := round(nvl(bcab.prod_cost_prom_tota, 0),
                                   parameter.p_cant_deci_cant);
    v_deta_exen_mmnn      := round(nvl(bcab.prod_cost_prom_tota, 0),
                                   parameter.p_cant_deci_cant);
    v_deta_grav5_mone     := 0;
    v_deta_grav5_mmnn     := 0;
    v_deta_grav10_mone    := 0;
    v_deta_grav10_mmnn    := 0;
    v_deta_iva5_mone      := 0;
    v_deta_iva5_mmnn      := 0;
    v_deta_iva10_mone     := 0;
    v_deta_iva10_mmnn     := 0;
    v_deta_grav5_ii_mone  := 0;
    v_deta_grav5_ii_mmnn  := 0;
    v_deta_grav10_ii_mone := 0;
    v_deta_grav10_ii_mmnn := 0;
  
    v_deta_cant      := round(nvl(bcab.s_cant, 0),
                              parameter.p_cant_deci_cant);
    v_deta_nume_item := v_deta_nume_item + 1;
    v_deta_prec_unit := round(bcab.prod_cost_prom,
                              parameter.p_cant_deci_cant);
  
    if bcab.indi_arma_desa = 'A' then
      if fp_ind_lote_prod(i_prod_codi => bcab.prod_codi) then
        for c in cur_lote loop
          v_bandera_lote_cab := 'S';
          pp_genera_codi_lote(p_codi      => v_deta_lote_codi,
                              i_prod_codi => bcab.prod_codi,
                              i_lote_desc => c.lote_desc,
                              o_exist     => v_exist_lote_cab);
        
          if v_exist_lote_cab = 'N' then
            pp_insertar_lote(p_lote_codi      => v_deta_lote_codi,
                             p_lote_prod_codi => bcab.prod_codi,
                             p_lote_desc      => c.lote_desc,
                             p_lote_codi_barr => c.lote_codi_barr,
                             p_lote_fech_elab => c.lote_fech_elab,
                             p_lote_fech_venc => c.lote_fech_venc,
                             p_lote_simc_codi => c.lote_simc_codi);
                             
                             
          
          end if;
        
          v_deta_cant := round(nvl(c.lote_cant_medi, 0),
                               parameter.p_cant_deci_cant);
          pp_llama_insert;
          v_deta_nume_item := v_deta_nume_item + 1;
        end loop;
        if v_bandera_lote_cab = 'N' then
          raise_application_error(-20010,
                                  'Debe cargar lote para el producto a armar');
        end if;
      else
        pp_llama_insert;
      end if;
    else
      v_deta_lote_codi := bcab.prod_lote_codi;
      pp_llama_insert;
    end if;
  
    ---asignar valores del detalle----------------
    v_deta_movi_codi := g_bdet.deta_movi_codi;
  
    for bdet in cur_det loop
    
      v_deta_nume_item := bdet.deta_nume_item;
      v_deta_impu_codi := null;
      v_deta_prod_codi := bdet.deta_prod_codi;
      v_deta_cant      := round(nvl(bdet.deta_cant, 1),
                                parameter.p_cant_deci_cant);
      v_deta_impo_mone := round(nvl(bdet.deta_cost_prom_tota, 0),
                                parameter.p_cant_deci_cant);
      v_deta_impo_mmnn := round(nvl(bdet.deta_cost_prom_tota, 0),
                                parameter.p_cant_deci_cant);
      v_deta_lote_codi := bdet.prod_lote_codi;
      v_deta_impo_mmee := 0;
      v_deta_iva_mmnn  := 0;
      v_deta_iva_mmee  := 0;
      v_deta_iva_mone  := 0;
    
      if bcab.indi_arma_desa = 'A' then
        v_deta_prec_unit := round(bdet.deta_cost_unit_actu,
                                  parameter.p_cant_deci_cant);
      else
        v_deta_prec_unit := round(bdet.deta_cost_unit,
                                  parameter.p_cant_deci_cant);
      end if;
    
      v_deta_base           := parameter.p_codi_base;
      v_deta_impo_mone_ii   := round(nvl(bdet.deta_cost_prom_tota, 0),
                                     parameter.p_cant_deci_cant);
      v_deta_impo_mmnn_ii   := round(nvl(bdet.deta_cost_prom_tota, 0),
                                     parameter.p_cant_deci_cant);
      v_deta_exen_mone      := round(nvl(bdet.deta_cost_prom_tota, 0),
                                     parameter.p_cant_deci_cant);
      v_deta_exen_mmnn      := round(nvl(bdet.deta_cost_prom_tota, 0),
                                     parameter.p_cant_deci_cant);
      v_deta_grav5_mone     := 0;
      v_deta_grav5_mmnn     := 0;
      v_deta_grav10_mone    := 0;
      v_deta_grav10_mmnn    := 0;
      v_deta_iva5_mone      := 0;
      v_deta_iva5_mmnn      := 0;
      v_deta_iva10_mone     := 0;
      v_deta_iva10_mmnn     := 0;
      v_deta_grav5_ii_mone  := 0;
      v_deta_grav5_ii_mmnn  := 0;
      v_deta_grav10_ii_mone := 0;
      v_deta_grav10_ii_mmnn := 0;
    
      pp_insert_come_movi_prod_deta(v_deta_movi_codi,
                                    v_deta_nume_item,
                                    v_deta_impu_codi,
                                    v_deta_prod_codi,
                                    v_deta_cant,
                                    v_deta_impo_mone,
                                    v_deta_impo_mmnn,
                                    v_deta_impo_mmee,
                                    v_deta_iva_mmnn,
                                    v_deta_iva_mmee,
                                    v_deta_iva_mone,
                                    v_deta_prec_unit,
                                    v_deta_base,
                                    v_deta_impo_mone_ii,
                                    v_deta_impo_mmnn_ii,
                                    v_deta_exen_mone,
                                    v_deta_exen_mmnn,
                                    v_deta_grav5_mone,
                                    v_deta_grav5_mmnn,
                                    v_deta_grav10_mone,
                                    v_deta_grav10_mmnn,
                                    v_deta_iva5_mone,
                                    v_deta_iva5_mmnn,
                                    v_deta_iva10_mone,
                                    v_deta_iva10_mmnn,
                                    v_deta_grav5_ii_mone,
                                    v_deta_grav5_ii_mmnn,
                                    v_deta_grav10_ii_mone,
                                    v_deta_grav10_ii_mmnn,
                                    v_deta_lote_codi);
    
    end loop;
  
  end pp_actualiza_come_movi_prod;

  procedure pp_actu_secu is
  begin
    update come_secu
       set secu_nume_arma_desa = bcab.movi_nume
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  
  end pp_actu_secu;

  function fp_carga_secu return number is
    v_secu_nume_prod number;
  begin
    select nvl(secu_nume_arma_desa, 0) + 1
      into v_secu_nume_prod
      from come_secu
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
    return v_secu_nume_prod;
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Codigo de Secuencia de Armado/Desarmado de Productos inexistente');
  end fp_carga_secu;

  procedure pp_set_variable is
  begin
  
    bcab.movi_codi := v('P52_MOVI_CODI');
    -- bcab.det_codi_barr       := v('P52_DET_CODI_BARR');
    bcab.movi_empr_codi := v('P52_MOVI_EMPR_CODI');
    -- bcab.det_prod_codi       := v('P52_DET_PROD_CODI');
    -- bcab.det_prod_ind_lote   := v('P52_DET_PROD_IND_LOTE');
    -- bcab.empr_desc           := v('P52_EMPR_DESC');
    bcab.movi_nume := v('P52_MOVI_NUME');
    -- bcab.det_prod_desc  := v('P52_DET_PROD_DESC');
    bcab.indi_arma_desa := v('P52_INDI_ARMA_DESA');
    bcab.movi_fech_emis := v('P52_MOVI_FECH_EMIS');
    -- bcab.lote_desc_visual    := v('P52_LOTE_DESC_VISUAL');
    bcab.movi_depo_codi_orig := v('P52_MOVI_DEPO_CODI_ORIG');
    --bcab.sucu_desc           := v('P52_SUCU_DESC');
    --bcab.det_cantidad        := v('P52_DET_CANTIDAD');
    bcab.movi_sucu_codi_orig := v('P52_MOVI_SUCU_CODI_ORIG');
    bcab.movi_obse           := v('P52_MOVI_OBSE');
    bcab.prod_codi           := v('P52_PROD_CODI');
    bcab.s_cant              := v('P52_S_CANT');
    bcab.prod_cost_prom_actu := v('P52_PROD_COST_PROM_ACTU');
    bcab.prod_cost_prom      := v('P52_PROD_COST_PROM');
    bcab.prod_cost_prom_tota := v('P52_PROD_COST_PROM_TOTA');
    bcab.prod_lote_codi      := v('P52_PROD_LOTE_CODI');
    pa_devu_fech_habi(p_fech_inic => parameter.p_fech_inic,
                      p_fech_fini => parameter.p_fech_fini);
  
    for c in cur_det loop
      g_bdet.sum_cost_prom_tota := g_bdet.sum_cost_prom_tota +
                                   c.deta_cost_prom_tota;
    end loop;
  
  end pp_set_variable;

  procedure pp_borrar_det(i_seq in number) is
  begin
    apex_collection.delete_member(p_collection_name => 'DETALLE',
                                  p_seq             => i_seq);
    --- comentario
    apex_collection.resequence_collection(p_collection_name => 'DETALLE');
  end pp_borrar_det;

  procedure pp_borrar_lote_det(i_seq in number) as
  begin
    apex_collection.delete_member(p_collection_name => 'COMPRA_DET_LOTE',
                                  p_seq             => i_seq);
    --- comentario
    apex_collection.resequence_collection(p_collection_name => 'COMPRA_DET_LOTE');
  end pp_borrar_lote_det;

  function fp_devu_lote_generico(p_prod_codi in number) return number is
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
      raise_application_error(-20010,
                              'Lote de producto ' || p_prod_codi ||
                              ' no encontrado');
    
  end fp_devu_lote_generico;

  procedure pp_precio_producto(i_prod_codi           in number,
                               i_prod_ind_lote       in varchar2,
                               i_prod_lote_codi      in number,
                               i_indi_arma_desa      in varchar2,
                               o_prod_cost_prom_actu out number) as
  
    v_lote_codi           number;
    v_prod_cost_prom_actu number;
  begin
    if parameter.p_ind_validar_det = 'S' then
      if i_indi_arma_desa = 'D' then
        if i_prod_ind_lote = 'N' then
          v_lote_codi := fp_devu_lote_generico(i_prod_codi);
        else
          if i_prod_lote_codi is null then
            raise_application_error(-20010, 'Debe elegir un lote');
          else
            v_lote_codi := i_prod_lote_codi;
          end if;
        end if;
      
        v_prod_cost_prom_actu := fa_devu_cost_prom_lote(v_lote_codi,
                                                        parameter.p_codi_peri_sgte);
      
        if v_prod_cost_prom_actu <= 0 then
          raise_application_error(-20010,
                                  'El producto no posee Costo Promedio,no puede ingresar para el Desarmado de Productos!');
        end if;
      end if;
    end if;
    o_prod_cost_prom_actu := v_prod_cost_prom_actu;
  end pp_precio_producto;

  procedure pp_calcula_precio_armado(i_indi_arma_desa      in varchar2,
                                     i_s_cant              in number,
                                     o_prod_cost_prom      out number,
                                     o_prod_cost_prom_tota out number) as
    v_sum_cost_prom_tota number := 0;
  
  begin
    if parameter.p_ind_validar_det = 'S' then
      if i_indi_arma_desa = 'A' then
        for c in cur_det loop
          v_sum_cost_prom_tota := v_sum_cost_prom_tota +
                                  c.deta_cost_prom_tota;
        end loop;
        o_prod_cost_prom      := round(nvl(v_sum_cost_prom_tota, 0) /
                                       nvl(i_s_cant, 1),
                                       4);
        o_prod_cost_prom_tota := nvl(v_sum_cost_prom_tota, 0);
      end if;
    end if;
  end pp_calcula_precio_armado;

  procedure pp_valida_fech(p_fech in date) is
    v_count number;
  begin
    if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
      raise_application_error(-20010,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(parameter.p_fech_inic, 'dd-mm-yyyy') ||
                              ' y ' ||
                              to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
    end if;
  
    select count(*)
      into v_count
      from rrhh_liqu l, rrhh_peri_sema p
     where l.liqu_peri_codi_sema = p.peri_codi
       and p_fech between p.peri_fech_desd and p.peri_fech_hast;
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'No se pueden registrar ni borrar ingresos para la fecha.' ||
                              chr(10) ||
                              'Ya se realizo la liquidacion del periodo.');
    end if;
  end pp_valida_fech;

  procedure pp_validar_cant_lote(i_cant_cab in number,
                                 i_cant_det in number) as
    v_cant_total number := 0;
  begin
    if i_cant_cab is null then
      raise_application_error(-20010, 'Debe cargar primero la cantidad');
    end if;
  
    for c in cur_lote loop
      v_cant_total := v_cant_total + c.lote_cant_medi;
    end loop;
  
    if (nvl(v_cant_total, 0) + nvl(i_cant_det, 0)) > nvl(i_cant_cab, 0) then
      raise_application_error(-20010,
                              'La Cantidad total de Lotes no puede ser distinta a la Cantidad del item.');
    end if;
  
  end pp_validar_cant_lote;

  procedure pp_add_det(i_deta_prod_codi      in number,
                       i_deta_prod_desc      in varchar2,
                       i_deta_cant           in number,
                       i_deta_cost_prom_tota in number,
                       i_deta_cost_unit_actu in number,
                       i_deta_cost_unit      in number,
                       i_prod_lote_codi      in number,
                       i_prod_lote_desc      in varchar2,
                       i_deta_porc_cost      in number,
                       i_prod_ind_lote       in varchar2,
                       i_ind_arma_desa       in varchar2,
                       i_deta_prod_codi_alfa in number,
                       i_movi_depo_codi_orig in number) as
  
    v_costo_unit          number;
    v_lote_codi           number;
    v_deta_cost_unit_actu number;
    v_deta_cost_prom_tota number;
  begin
  
    if not
        (apex_collection.collection_exists(p_collection_name => 'DETALLE')) then
      apex_collection.create_collection(p_collection_name => 'DETALLE');
    end if;
  
    if i_deta_prod_codi is null and i_deta_prod_desc is null then
      raise_application_error(-20010, 'Debe elegir un producto');
    end if;
  
    if nvl(i_deta_cant, 0) <= 0 then
      raise_application_error(-20010,
                              'La cantidad debe ser mayor a 0 cero');
    end if;
  
    if i_prod_ind_lote = 'N' then
      v_lote_codi := fp_devu_lote_generico(i_deta_prod_codi);
    else
      if i_prod_lote_codi is null then
        raise_application_error(-20010, 'Debe elegir un lote');
      else
        v_lote_codi := i_prod_lote_codi;
      end if;
    end if;
  
    if i_deta_porc_cost < 0 then
      raise_application_error(-20010,
                              'No puede ingresar un % Distribucion inferior a 0.');
    elsif i_deta_porc_cost is not null then
      v_deta_cost_prom_tota := round(((nvl(i_deta_porc_cost, 0) *
                                     nvl(i_deta_cost_prom_tota, 0)) / 100),
                                     0);
      v_costo_unit          := v_deta_cost_prom_tota / nvl(i_deta_cant, 1);
    end if;
  
    v_deta_cost_unit_actu := round(fa_devu_cost_prom_lote(p_lote => v_lote_codi,
                                                          p_peri => parameter.p_codi_peri_sgte),
                                   4);
  
    if i_ind_arma_desa = 'A' then
      v_deta_cost_prom_tota := round(v_deta_cost_unit_actu *
                                     nvl(i_deta_cant, 1),
                                     0);
      pp_valida_stock(i_deta_prod_codi,
                      i_movi_depo_codi_orig,
                      nvl(i_deta_cant, 0),
                      i_deta_prod_desc,
                      i_deta_prod_codi_alfa);
    else
      if nvl(i_deta_cost_prom_tota, 0) = 0 then
        raise_application_error(-20010,
                                'El producto no posee Costo Promedio,no puede ingresar para el Desarmado de Producto!');
      end if;
    end if;
    if nvl(v_deta_cost_unit_actu, 0) <= 0 then
      if i_ind_arma_desa = 'A' then
    --   raise_application_error(-20010,
      --                        'El producto no posee Costo Promedio,no puede ingresar como parte del Armado de Productos!');
    null;
      end if;
    end if;
  
    apex_collection.add_member(p_collection_name => 'DETALLE',
                               p_c001            => i_deta_prod_codi,
                               p_c002            => i_deta_cant,
                               p_c003            => v_deta_cost_prom_tota,
                               p_c005            => v_deta_cost_unit_actu,
                               p_c006            => v_costo_unit,
                               p_c007            => v_lote_codi,
                               p_c008            => i_deta_porc_cost,
                               p_c009            => i_deta_prod_desc,
                               p_c010            => i_prod_lote_desc,
                               p_c011            => nvl(v_costo_unit, 0) -
                                                    nvl(v_deta_cost_unit_actu,
                                                        0),
                               p_c012            => i_deta_prod_codi_alfa);
  
  end pp_add_det;

  procedure pp_prorratear_costo(i_prod_costo_prom_tota in number) is
    v_prod_costo_prom_tota number := 0;
    v_cost_item            number;
    v_total_auxi           number := 0;
    v_dife                 number := 0;
    v_rows                 number := 0;
  
  begin
    v_prod_costo_prom_tota := i_prod_costo_prom_tota;
  
    /* go_block('bdet');
    first_record;
    if bdet.prod_codi_alfa is null then
      raise_application_error(-20010,'Debe ingresar al menos un item!');
    else*/
    for bdet in cur_det loop
      v_rows                   := v_rows + 1;
      v_cost_item              := round((bdet.deta_cant * 100) /
                                        bdet.sum_deta_cant,
                                        4);
      v_total_auxi             := v_total_auxi + v_cost_item;
      bdet.deta_porc_cost      := v_cost_item;
      bdet.deta_cost_prom_tota := round(((nvl(bdet.deta_porc_cost, 0) *
                                        nvl(v_prod_costo_prom_tota, 0)) / 100),
                                        0);
      bdet.deta_cost_unit      := round(bdet.deta_cost_prom_tota /
                                        nvl(bdet.deta_cant, 1),
                                        4);
    
      if bdet.total_rows = v_rows then
        if v_total_auxi < 100 then
          v_dife                   := 100 - nvl(v_total_auxi, 0);
          v_cost_item              := v_cost_item + nvl(v_dife, 0);
          bdet.deta_porc_cost      := v_cost_item;
          bdet.deta_cost_prom_tota := round(((nvl(bdet.deta_porc_cost, 0) *
                                            nvl(v_prod_costo_prom_tota, 0)) / 100),
                                            0);
          bdet.deta_cost_unit      := bdet.deta_cost_prom_tota /
                                      nvl(bdet.deta_cant, 1);
        end if;
      end if;
    
      apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                              p_seq             => bdet.seq_id,
                                              p_attr_number     => 6,
                                              p_attr_value      => bdet.deta_cost_unit);
      apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                              p_seq             => bdet.seq_id,
                                              p_attr_number     => 8,
                                              p_attr_value      => bdet.deta_porc_cost);
      apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                              p_seq             => bdet.seq_id,
                                              p_attr_number     => 3,
                                              p_attr_value      => bdet.deta_cost_prom_tota);
    
      apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                              p_seq             => bdet.seq_id,
                                              p_attr_number     => 11,
                                              p_attr_value      => nvl(bdet.deta_cost_unit,
                                                                       0) -
                                                                   nvl(bdet.deta_cost_unit_actu,
                                                                       0));
    
    end loop;
  
    if v_rows = 0 then
      raise_application_error(-20010, 'Debe ingresar al menos un item!');
    end if;
  
    /*
        select a.seq_id,
             a.seq_id deta_nume_item,
             a.c001 deta_prod_codi,
             a.c009 deta_prod_desc,
             to_number(a.c002) deta_cant,
             to_number(a.c003) deta_cost_prom_tota,
             to_number(a.c005) deta_cost_unit_actu,
             to_number(a.c006) deta_cost_unit,
             a.c007 prod_lote_codi,
             a.c010 prod_lote_desc,
             to_number(a.c008) deta_porc_cost,
             to_number(a.c011) deta_dife_costo,
             c012 deta_prod_codi_alfa,
             count(*) over() total_rows
        from apex_collections a
       where a.collection_name = 'DETALLE';
    */
  
  exception
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_prorratear_costo;

  procedure pp_actualizar_registro is
  begin
  
    pp_set_variable;
  
    pp_valida_fech(bcab.movi_fech_emis);
    pp_validar;
  
    pp_reenumerar_nro_item;
    pp_validar_repeticion_prod;
    pp_veri_prod_arma_desa;
  
    /*   if bdet.sum_porc_cost = 100 and
       bdet.sum_cost_prom_tota <> bcab.prod_cost_prom_tota then
      pp_ajustar_importes;
    end if;*/
  
    pp_actualiza_come_movi;
  
    pp_actualiza_come_movi_prod;
  
    pp_actu_secu;
    /*  
       message('Registro actualizado.', no_acknowledge);
    */
  end pp_actualizar_registro;
  
  
  procedure pp_buscar_iccid (p_lote_iccid in varchar2,
                             p_lote_nro_linea out varchar2,
                             p_lote_simc_codi out number) is
                             
 begin
   
select simc_nume_tele, t.simc_codi
  into p_lote_nro_linea, p_lote_simc_codi
  from come_lote_simc t
 where t.simc_esta = 'P'
   and simc_iccid = p_lote_iccid;

exception 
  when others then
  raise_application_error(-20001, 'No existe ICCID');  
  
 end pp_buscar_iccid;                            

end i020317;
