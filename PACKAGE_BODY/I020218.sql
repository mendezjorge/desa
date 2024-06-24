
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020218" is
  g_come_remi      come_remi%rowtype;
  g_come_remi_deta come_remi_deta%rowtype;

  type r_parameter is record(
    p_fech_inic          date,
    p_fech_fini          date,
    p_cant_remi_pend     number,
    p_codi_oper_tras_mas number := to_number(GENERAL_SKN.fl_busca_parametro('p_codi_oper_tras_mas')),
    p_codi_oper_tras_men number := to_number(GENERAL_SKN.fl_busca_parametro('p_codi_oper_tras_men')),
    p_peco               number := 1,
    p_para_inic          number);

  parameter r_parameter;

  cursor g_cur_det is
    select a.seq_id nro,
           a.seq_id deta_nume_item,
           a.c001   deta_ortr_prod,
           a.c002   prod_codi_alfa,
           a.c003   deta_prod_codi_barr,
           a.c004   prod_desc,
           a.c005   medi_desc_abre,
           a.c006   lote_desc_visual,
           a.c007   deta_prod_peso_kilo,
           a.c008   deta_cant_medi,
           a.c009   deta_lote_codi,
           a.c010   deta_prod_codi,
           a.c008   deta_cant,
           a.c012   deta_medi_codi,
           a.c013   deta_coba_codi,
           a.c014   deta_pulg_unit,
           a.c015   fact_deta_movi_codi,
           a.c016   fact_deta_nume_item
      from apex_collections a
     where a.collection_name = 'REMI_DET';

  procedure pp_actualiza_come_remi is
    v_remi_codi                   number(20);
    v_remi_clpr_codi_acop         number(20);
    v_code_cont_codi              number(20);
    v_remi_prde_prod_codi         number(20);
    v_remi_tire_codi              number(4);
    v_remi_camp_codi              number(4);
    v_remi_fech                   date;
    v_remi_sucu_codi              number(20);
    v_remi_nume                   number(20);
    v_remi_empl_codi              number(20);
    v_remi_esta                   varchar2(1);
    v_remi_tipo                   varchar2(1);
    v_remi_codi_padr              number(20);
    v_remi_base                   number(2);
    v_remi_fech_anal              date;
    v_remi_basc_dest              varchar2(20);
    v_remi_peso_brut              number(20, 4);
    v_remi_peso_neto              number(20, 4);
    v_remi_peso_tara              number(20, 4);
    v_remi_peso_fina              number(20, 4);
    v_remi_clpr_codi_flet         number(20);
    v_remi_clpr_codi              number(20);
    v_remi_peso_deto              number(20, 4);
    v_remi_dest_codi              number(4);
    v_remi_depo_codi              number(4);
    v_remi_sucu_codi_dest         number(4);
    v_remi_depo_codi_dest         number(4);
    v_remi_mone_codi              number(4);
    v_remi_tasa_mone              number(20, 2);
    v_remi_fech_grab              date;
    v_remi_user                   varchar2(20);
    v_remi_impo_mone              number(20, 2);
    v_remi_obse                   varchar2(3000);
    v_remi_fech_inic_tras         date;
    v_remi_fech_term_tras         date;
    v_remi_marc_vehi              varchar2(500);
    v_remi_nomb_tran              varchar2(100);
    v_remi_nomb_cond              varchar2(100);
    v_remi_nume_chap              varchar2(20);
    v_remi_ruc_tran               varchar2(20);
    v_remi_cedu_tran              number(20);
    v_remi_moti_tras              varchar2(2);
    v_remi_dire_cond              varchar2(300);
    v_remi_otro_moti              varchar2(30);
    v_remi_tran_codi              number(4);
    v_remi_cond_empl_codi         number(20);
    v_remi_cond_cedu_nume         varchar2(20);
    v_remi_sucu_codi_movi         number(20);
    v_remi_depo_codi_movi         number(20);
    v_remi_movi_codi              number(20);
    v_remi_come_movi_rece         number(20);
    v_remi_sotr_codi              number(20);
    v_remi_clpr_sucu_nume_item    number(20);
    v_remi_clpr_codi_orig         number(20);
    v_remi_clpr_sucu_nume_item_or number(20);
    v_remi_empr_codi              number(20);
    v_remi_clpr_ruc               varchar2(20);
    v_remi_clpr_desc              varchar2(200);
    v_remi_clpr_tele              varchar2(50);
    v_remi_clpr_dire              varchar2(500);
  
    v_deta_remi_codi      number;
    v_deta_nume_item      number;
    v_deta_prod_codi      number;
    v_deta_desc           varchar2(100);
    v_deta_cant           number;
    v_deta_obse           varchar2(500);
    v_deta_impo_mone      number;
    --v_deta_prec_unit      number;
    v_deta_lote_codi      number;
    v_deta_conc_codi      number;
    v_deta_ortr_prod      varchar2(1);
    v_deta_pulg_unit      number;
    v_deta_cant_medi      number;
    v_deta_medi_codi      number;
    v_deta_cant_sald      number;
    v_deta_prod_codi_barr varchar2(30);
    --v_deta_prod_peso_kilo number;
  
    v_deta_coba_codi number(10);
  
    ---para la confirmacion
    --v_conf_sotr_codi      number(10);
    --v_conf_sotr_nume_item number(10);
    --v_conf_remi_codi      number(20);
    --v_conf_remi_nume_item number(10);
    --v_conf_cant_remi      number(20, 4);
    --v_conf_depo_codi      number(10);
    --v_conf_prod_codi      number(20);
    --v_conf_lote_codi      number(10);
  
  begin
    select sec_come_remi.nextval into g_come_remi.remi_codi from dual;
  
    v_remi_codi           := g_come_remi.remi_codi;
    v_remi_clpr_codi_acop := null;
    v_code_cont_codi      := null;
    v_remi_prde_prod_codi := null;
    v_remi_tire_codi      := null;
    v_remi_camp_codi      := null;
    v_remi_fech           := g_come_remi.remi_fech;
    v_remi_sucu_codi      := g_come_remi.remi_sucu_codi;
    v_remi_nume           := g_come_remi.remi_nume;
    v_remi_empl_codi      := null; --g_come_remi.remi_empl_codi;
    v_remi_esta           := 'P';
    
    v_remi_tipo           := g_come_remi.remi_moti_tras;
    v_remi_codi_padr      := null;
    v_remi_base           := 1;
    v_remi_fech_anal      := null; --fecha de analisis
    v_remi_basc_dest      := null;
    v_remi_peso_brut      := null;
    v_remi_peso_neto      := null;
    v_remi_peso_tara      := null;
    v_remi_peso_fina      := null;
    v_remi_clpr_codi_flet := null;
    v_remi_clpr_codi      := g_come_remi.remi_clpr_codi;
    v_remi_peso_deto      := null;
    v_remi_dest_codi      := null;
    v_remi_depo_codi      := g_come_remi.remi_depo_codi;
    v_remi_sucu_codi_dest := g_come_remi.remi_sucu_codi_dest;
    v_remi_depo_codi_dest := g_come_remi.remi_depo_codi_dest;
    v_remi_mone_codi      := null;
    v_remi_tasa_mone      := null;
    v_remi_fech_grab      := sysdate;
    v_remi_user           := fa_user;
 
    v_remi_impo_mone      := null;
    v_remi_obse           := g_come_remi.remi_obse;
    
    v_remi_fech_inic_tras := g_come_remi.remi_fech_inic_tras;
    v_remi_fech_term_tras := g_come_remi.remi_fech_term_tras;
    v_remi_marc_vehi      := g_come_remi.remi_marc_vehi;
    v_remi_nomb_tran      := g_come_remi.remi_nomb_tran;
    v_remi_nomb_cond      := g_come_remi.remi_nomb_cond;
    v_remi_nume_chap      := g_come_remi.remi_nume_chap;
    v_remi_ruc_tran       := g_come_remi.remi_ruc_tran;
    v_remi_cedu_tran      := null; --g_come_remi.remi_cedu_tran;
    
    v_remi_moti_tras      := g_come_remi.remi_moti_tras;
    v_remi_dire_cond      := g_come_remi.remi_dire_cond;
    v_remi_otro_moti      := null;
    v_remi_tran_codi      := g_come_remi.remi_tran_codi;
    v_remi_cond_empl_codi := g_come_remi.remi_cond_empl_codi;
    v_remi_cond_cedu_nume := g_come_remi.remi_cond_cedu_nume;
    v_remi_sucu_codi_movi := g_come_remi.remi_sucu_codi_movi;
    v_remi_depo_codi_movi := g_come_remi.remi_depo_codi_movi;
    v_remi_movi_codi      := g_come_remi.remi_movi_codi;
    v_remi_come_movi_rece := null; --siempre sera nulo, porque es el registro de la remision 
  
    v_remi_sotr_codi              := g_come_remi.remi_sotr_codi; --codigo de la solicitud de pedido
    v_remi_clpr_sucu_nume_item    := null;
    v_remi_clpr_codi_orig         := null;
    v_remi_clpr_sucu_nume_item_or := null;
    v_remi_empr_codi              := g_come_remi.remi_empr_codi;
    v_remi_clpr_ruc               := g_come_remi.remi_clpr_ruc;
    v_remi_clpr_desc              := g_come_remi.remi_clpr_desc;
    v_remi_clpr_tele              := g_come_remi.remi_clpr_tele;
    v_remi_clpr_dire              := g_come_remi.remi_clpr_dire;
  
    insert into come_remi
      (remi_codi,
       remi_clpr_codi_acop,
       code_cont_codi,
       remi_prde_prod_codi,
       remi_tire_codi,
       remi_camp_codi,
       remi_fech,
       remi_sucu_codi,
       remi_nume,
       remi_empl_codi,
       remi_esta,
       remi_tipo,
       remi_codi_padr,
       remi_base,
       remi_fech_anal,
       remi_basc_dest,
       remi_peso_brut,
       remi_peso_neto,
       remi_peso_tara,
       remi_peso_fina,
       remi_clpr_codi_flet,
       remi_clpr_codi,
       remi_peso_deto,
       remi_dest_codi,
       remi_depo_codi,
       remi_sucu_codi_dest,
       remi_depo_codi_dest,
       remi_mone_codi,
       remi_tasa_mone,
       remi_fech_grab,
       remi_user,
       remi_impo_mone,
       remi_obse,
       remi_fech_inic_tras,
       remi_fech_term_tras,
       remi_marc_vehi,
       remi_nomb_tran,
       remi_nomb_cond,
       remi_nume_chap,
       remi_ruc_tran,
       remi_cedu_tran,
       remi_moti_tras,
       remi_dire_cond,
       remi_otro_moti,
       remi_tran_codi,
       remi_cond_empl_codi,
       remi_cond_cedu_nume,
       remi_sucu_codi_movi,
       remi_depo_codi_movi,
       remi_movi_codi,
       remi_come_movi_rece,
       remi_sotr_codi,
       remi_clpr_sucu_nume_item,
       remi_clpr_codi_orig,
       remi_clpr_sucu_nume_item_orig,
       remi_empr_codi,
       remi_clpr_ruc,
       remi_clpr_desc,
       remi_clpr_tele,
       remi_clpr_dire,
       remi_timbrado,
       REMI_TIM_FECH_INI,
       REMI_TIM_FECH_fin)
    values
      (v_remi_codi,
       v_remi_clpr_codi_acop,
       v_code_cont_codi,
       v_remi_prde_prod_codi,
       v_remi_tire_codi,
       v_remi_camp_codi,
       v_remi_fech,
       v_remi_sucu_codi,
       v_remi_nume,
       v_remi_empl_codi,
       v_remi_esta,
       v_remi_tipo,
       v_remi_codi_padr,
       v_remi_base,
       v_remi_fech_anal,
       v_remi_basc_dest,
       v_remi_peso_brut,
       v_remi_peso_neto,
       v_remi_peso_tara,
       v_remi_peso_fina,
       v_remi_clpr_codi_flet,
       v_remi_clpr_codi,
       v_remi_peso_deto,
       v_remi_dest_codi,
       v_remi_depo_codi,
       v_remi_sucu_codi_dest,
       v_remi_depo_codi_dest,
       v_remi_mone_codi,
       v_remi_tasa_mone,
       v_remi_fech_grab,
       v_remi_user,
       v_remi_impo_mone,
       v_remi_obse,
       v_remi_fech_inic_tras,
       v_remi_fech_term_tras,
       v_remi_marc_vehi,
       v_remi_nomb_tran,
       v_remi_nomb_cond,
       v_remi_nume_chap,
       v_remi_ruc_tran,
       v_remi_cedu_tran,
       v_remi_moti_tras,
       v_remi_dire_cond,
       v_remi_otro_moti,
       v_remi_tran_codi,
       v_remi_cond_empl_codi,
       v_remi_cond_cedu_nume,
       v_remi_sucu_codi_movi,
       v_remi_depo_codi_movi,
       v_remi_movi_codi,
       v_remi_come_movi_rece,
       v_remi_sotr_codi,
       v_remi_clpr_sucu_nume_item,
       v_remi_clpr_codi_orig,
       v_remi_clpr_sucu_nume_item_or,
       v_remi_empr_codi,
       v_remi_clpr_ruc,
       v_remi_clpr_desc,
       v_remi_clpr_tele,
       v_remi_clpr_dire,
       g_come_remi.remi_timbrado,
       g_come_remi.REMI_TIM_FECH_INI,
       g_come_remi.REMI_TIM_FECH_fin);
  
    v_deta_remi_codi := v_remi_codi;
   
      
    for c_bdet in g_cur_det loop
      
      v_deta_nume_item := c_bdet.deta_nume_item;
      if c_bdet.deta_ortr_prod = 'P' then
        v_deta_conc_codi := null;
        v_deta_prod_codi := c_bdet.deta_prod_codi;
        --v_deta_lote_codi := c_bdet.deta_lote_codi;
      else
        /*deta_conc_codi =prod_codi_alfa*/
        --v_deta_conc_codi := c_bdet.prod_codi_alfa;
        v_deta_prod_codi := null;
        --v_deta_lote_codi := null;
      
      end if;
      
      --   v_deta_desc           := c_bdet.prod_desc;
      -- v_deta_prod_peso_kilo := c_bdet.deta_prod_peso_kilo;
      
      v_deta_cant      := c_bdet.deta_cant;
      v_deta_obse      := null;
      v_deta_impo_mone := null;
      
      v_deta_lote_codi := c_bdet.deta_lote_codi;
      
      v_deta_ortr_prod := c_bdet.deta_ortr_prod;
      v_deta_pulg_unit := c_bdet.deta_pulg_unit;
    
      v_deta_cant_medi := c_bdet.deta_cant_medi;
      v_deta_medi_codi := c_bdet.deta_medi_codi;
    
      /*if c_bdet.fact_deta_movi_codi is not null then
        v_deta_cant_sald := 0;
      else
        v_deta_cant_sald := c_bdet.deta_cant;
      end if;*/
    
      v_deta_prod_codi_barr := c_bdet.deta_prod_codi_barr;
      --    v_deta_coba_codi      := c_bdet.deta_coba_codi;
    
      insert into come_remi_deta
        (deta_remi_codi,
         deta_nume_item,
         deta_prod_codi,
         deta_desc,
         deta_cant,
         deta_obse,
         deta_lote_codi,
         deta_conc_codi,
         deta_ortr_prod,
         deta_pulg_unit,
         deta_cant_medi,
         deta_medi_codi,
         deta_cant_sald,
         deta_prod_codi_barr,
         deta_coba_codi)
      values
        (v_deta_remi_codi,
         v_deta_nume_item,
         v_deta_prod_codi,
         v_deta_desc,
         v_deta_cant,
         v_deta_obse,
         v_deta_lote_codi,
         v_deta_conc_codi,
         v_deta_ortr_prod,
         v_deta_pulg_unit,
         v_deta_cant_medi,
         v_deta_medi_codi,
         v_deta_cant_sald,
         v_deta_prod_codi_barr,
         v_deta_coba_codi
         
         );
    
    /*if c_bdet.sotr_nume_item is not null and
                                                                                g_come_remi.remi_sotr_codi is not null then
                                                                                v_conf_sotr_codi      := g_come_remi.remi_sotr_codi;
                                                                                v_conf_sotr_nume_item := c_bdet.sotr_nume_item; --nro item original de la solicitud
                                                                                v_conf_remi_codi      := v_remi_codi;
                                                                                v_conf_remi_nume_item := c_bdet.deta_nume_item; --nro item de remision
                                                                                v_conf_cant_remi      := c_bdet.deta_cant_medi;
                                                                                v_conf_depo_codi      := g_come_remi.remi_depo_codi;
                                                                                v_conf_prod_codi      := c_bdet.deta_prod_codi;
                                                                                v_conf_lote_codi      := c_bdet.deta_lote_codi;
                                                                                                                                                                  
                                                                                insert into come_remi_conf_soli_tras
                                                                                (conf_sotr_codi,
                                                                                conf_sotr_nume_item,
                                                                                conf_remi_codi,
                                                                                conf_remi_nume_item,
                                                                                conf_cant_remi,
                                                                                conf_depo_codi,
                                                                                conf_prod_codi,
                                                                                conf_lote_codi)
                                                                                values
                                                                                (v_conf_sotr_codi,
                                                                                v_conf_sotr_nume_item,
                                                                                v_conf_remi_codi,
                                                                                v_conf_remi_nume_item,
                                                                                v_conf_cant_remi,
                                                                                v_conf_depo_codi,
                                                                                v_conf_prod_codi,
                                                                                v_conf_lote_codi);
                                                                                                                                                                  
                                                                                end if;*/
    
    end loop;
  
  end pp_actualiza_come_remi;

  procedure pp_reenumerar_nro_item is
    --v_nro_item   number := 0;
    v_count_item number := 0;
  begin
    for c_remi_deta in g_cur_det loop
      v_count_item := v_count_item + 1;
     
     /*if c_remi_deta.deta_lote_codi is null then
        raise_application_error(-20010, 'Debe asignar un lote al producto');
      end if;*/
      
    end loop;
  
    if v_count_item < 1 then
      raise_application_error(-20010, 'Debe ingresar al menos un item');
    end if;
    /*
    v_nro_item                      := v_nro_item + 1;
    c_bdet.deta_nume_item := v_nro_item;*/
  
  end pp_reenumerar_nro_item;

  function fp_devu_cant_remi_pend return number is
    v_cant number;
  begin
  
    select count(*)
      into v_cant
      from come_remi r,
           come_clie_prov,
           (select deta_remi_codi, sum(deta_cant_sald) cant_sald
              from come_remi_deta
             group by deta_remi_codi) x
     where remi_clpr_codi = clpr_codi
       and remi_codi = x.deta_remi_codi
       and r.remi_clpr_codi = g_come_remi.remi_clpr_codi
       and x.cant_sald > 0
       and upper(r.remi_moti_tras) = 'V';
  
    return v_cant;
  
  exception
    when others then
      return 0;
  end fp_devu_cant_remi_pend;

  procedure pp_validar_deposito(p_depo_codi in number, p_tipo in varchar2) is
    v_depo_maxi_dias_rece number;
    v_depo_indi_movi      varchar2(1);
    v_cant_pend           number;
  begin
  
    begin
      select d.depo_maxi_dias_rece, d.depo_indi_movi
        into v_depo_maxi_dias_rece, v_depo_indi_movi
        from come_depo d
       where d.depo_codi = p_depo_codi;
    exception
      when no_data_found then
        raise_application_error(-20010, 'Deposito inexistente');
      
      when others then
        raise_application_error(-20010, sqlerrm);
    end;
  
    if upper(p_tipo) = upper('o') then
      if upper(nvl(v_depo_indi_movi, 'n')) = upper('s') then
        raise_application_error(-20010,
                                'El deposito de partida no puede ser de tipo movil');
      end if;
    elsif upper(p_tipo) = upper('d') then
      if upper(nvl(v_depo_indi_movi, 'n')) = upper('s') then
        raise_application_error(-20010,
                                'El deposito de llegada no puede ser de tipo movil');
      end if;
      select count(*)
        into v_cant_pend
        from come_remi
       where remi_depo_codi_dest = p_depo_codi
         and decode(nvl(remi_esta, 'P'), 'R', -1, remi_come_movi_rece) is null
         and remi_moti_tras = 'T'
         and remi_fech < (trunc(sysdate) - nvl(v_depo_maxi_dias_rece, 0));
    
      if v_cant_pend > 0 then
        raise_application_error(-20010,
                                'El deposito de llegada tiene ' ||
                                v_cant_pend ||
                                ' recepciones pendientes a la fecha!');
      end if;
    
    elsif upper(p_tipo) = upper('m') then
      if upper(nvl(v_depo_indi_movi, 'n')) = upper('n') then
        raise_application_error(-20010,
                                'El deposito indicado como movil no es de tipo movil');
      end if;
    
    end if;
  
  end pp_validar_deposito;

  procedure pp_valida_datos is
  begin
  
    ---validar que el deposito no quede nulo
    if g_come_remi.remi_depo_codi is null then
      raise_application_error(-20010,
                              'Debe ingresar el codigo del Deposito Partida');
    end if;
    
    	if g_come_remi.remi_depo_codi = g_come_remi.remi_depo_codi_dest then
		  raise_application_error(-20010,'Los depositos de partida y llegada deben ser diferentes!');
	    end if;
  
    ---esto esta fuera porque es tanto para traslado como para venta
    --validar que posea permiso en el deposito origen
    if not general_skn.fl_vali_user_depo_orig(g_come_remi.remi_depo_codi) then
      raise_application_error(-20010,
                              'El usuario no tiene permisos para trabajar con el Deposito de Partida');
    end if;
  
    --aqui solo valida que no sea de tipo movil
    pp_validar_deposito(g_come_remi.remi_depo_codi, 'o');
  
    if upper(g_come_remi.remi_moti_tras) = upper('v') then
      --validar el maximo de remisiones pendientes
      if fp_devu_cant_remi_pend >= parameter.p_cant_remi_pend then
        raise_application_error(-20010,
                                'Este cliente llego al maximo permitido de remisiones pendientes por ventas');
      end if;
    
      ---validar que el cliente no quede nulo
      /* if g_come_remi.clpr_codi_alte is null then
        raise_application_error(-20010, 'Debe ingresar el Cliente.!');
      end if;*/
    
    else
      ---si es traslado
    
      if g_come_remi.remi_depo_codi_dest is null then
        raise_application_error(-20010,
                                'Debe ingresar el codigo del Deposito Llegada');
      end if;
    
      if g_come_remi.remi_depo_codi_movi is null then
        raise_application_error(-20010,
                                'Debe ingresar el codigo del Deposito Movil');
      end if;
      	if g_come_remi.remi_depo_codi = g_come_remi.remi_depo_codi_movi then
		    raise_application_error(-20010,'Los depositos de partida y movil deben ser diferentes!');
	     end if;
	
	     if g_come_remi.remi_depo_codi_dest = g_come_remi.remi_depo_codi_movi then
		   raise_application_error(-20010,'Los depositos de llegada y movi deben ser diferentes!');
	     end if;
    
      ---validar 
      if not
          general_skn.fl_vali_user_depo_dest(g_come_remi.remi_depo_codi_dest) then
        raise_application_error(-20010,
                                'El usuario no tiene permisos para trabajar con el Deposito de destino');
      end if;
    
      if not
          general_skn.fl_vali_user_depo_orig(g_come_remi.remi_depo_codi_movi) then
        raise_application_error(-20010,
                                'El usuario no tiene permisos para trabajar con el Deposito de Movil');
      end if;
      --valida que no sea de tipo movil el deposito destino
      --tambien que el depo destino no supere el nro maximo de remisiones pendientes de recepcion   
      pp_validar_deposito(g_come_remi.remi_depo_codi_dest, 'd');
    
    end if;
  
  end pp_valida_datos;

  procedure pp_validar_repeticion_prod is
    --v_cant_reg number; --cantidad de registros en el bloque
    --i          number;
    --j          number;
    salir exception;
    --v_ant_art number;
  begin
    null;
    ---- 
    /* go_block('bdet');
    if not form_success then
      raise form_trigger_failure;
    end if;
    last_record;
    v_cant_reg := to_number(:system.cursor_record);
    if v_cant_reg <= 1 then
      raise salir;
    end if;
    for i in 1 .. v_cant_reg - 1 loop
      go_record(i);
      v_ant_art := c_bdet.deta_lote_codi;
      for j in i + 1 .. v_cant_reg loop
        go_record(j);
        if v_ant_art = c_bdet.deta_lote_codi then
          raise_application_error(-20010,'El codigo de Lote del item ' || to_char(i) ||
                ' se repite con el del item ' || to_char(j) ||
                '. asegurese de no introducir mas de una' ||
                ' vez el mismo codigo!');
        end if;
      end loop;
    end loop;*/
  
  exception
    when salir then
      null;
  end pp_validar_repeticion_prod;

  procedure pp_valida_nume_remi(p_nume in number) is
    v_count number;
  begin
    select count(*) into v_count from come_remi where remi_nume = p_nume
    and remi_timbrado=g_come_remi.remi_timbrado;
    if v_count > 0 then
      raise_application_error(-20010,
                              'Nro de remision Existente, favor verifique la secuencia');
    end if;
  
  end pp_valida_nume_remi;

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

  procedure pp_actualiza_factura is
  begin
    for c_bdet in g_cur_det loop
    
      if c_bdet.fact_deta_movi_codi is not null then
        update come_movi_prod_deta
           set deta_remi_codi      = g_come_remi.remi_codi,
               deta_remi_nume_item = c_bdet.deta_nume_item
         where deta_movi_codi = c_bdet.fact_deta_movi_codi
           and deta_nume_item = c_bdet.fact_deta_nume_item;
      
        --para que se dispare el trigger come_remi_deta_afidu y actualiza come_prod_depo y come_prod_depo_lote
        update come_remi_deta
           set deta_cant_sald = 0
         where deta_remi_codi = g_come_remi.remi_codi
           and deta_nume_item = c_bdet.deta_nume_item;
      
      end if;
    
    end loop;
  end pp_actualiza_factura;

  procedure pp_actualiza_come_secu(p_nume in number) is
    --v_nume number;
  
  begin
  
    update come_secu
       set secu_nume_remi_clie = g_come_remi.remi_nume
     where secu_codi = (select peco_secu_codi
                          from come_pers_comp, come_secu
                         where peco_codi = parameter.p_peco
                           and peco_secu_codi = secu_codi);
  
  end pp_actualiza_come_secu;
  

  procedure pp_genera_traslado is
    v_movi_codi                number;
    v_movi_timo_codi           number;
    v_movi_clpr_codi           number;
    v_movi_sucu_codi_orig      number;
    v_movi_depo_codi_orig      number;
    v_movi_sucu_codi_dest      number;
    v_movi_depo_codi_dest      number;
    v_movi_sucu_codi_movi      number;
    v_movi_depo_codi_movi      number;
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
    --v_movi_nume_orpa           number;
    --v_movi_orpa_esta           varchar2(1);
    --v_movi_fech_orpa           date;
  
    v_movi_fech_inic_tras date;
    v_movi_fech_term_tras date;
    v_movi_tran_codi      number;
    v_movi_vehi_marc      varchar2(50);
    v_movi_vehi_chap      varchar2(20);
    v_movi_cont_tran_nomb varchar2(100);
    v_movi_cont_tran_ruc  varchar2(20);
    v_movi_cond_empl_codi number;
    v_movi_cond_nomb      varchar2(100);
    v_movi_cond_cedu_nume varchar2(20);
    v_movi_cond_dire      varchar2(200);
  
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
    v_deta_cant_medi         number;
    v_deta_medi_codi         number;
    v_deta_lote_codi         number;
  
    v_deta_coba_codi      number(10);
    v_deta_prod_codi_barr varchar2(30);
  
    -----------------------------------
    v_deta_movi_codi2 number;
    -----------------------------------
  
  begin
    ---primero insertar el traslado mas
  
    v_movi_codi                := fa_sec_come_movi;
    g_come_remi.remi_movi_codi := v_movi_codi;
    v_movi_timo_codi           := null;
    v_movi_clpr_codi           := null;
  
    --invertido para el traslado(+) -----------------------------------
    v_movi_sucu_codi_orig := g_come_remi.remi_sucu_codi_movi; ---movil
    v_movi_depo_codi_orig := g_come_remi.remi_depo_codi_movi; ---movil
  
    v_movi_sucu_codi_dest := g_come_remi.remi_sucu_codi; --sucursal origen 
    v_movi_depo_codi_dest := g_come_remi.remi_depo_codi; --deposito origen
  
    v_movi_sucu_codi_movi := null;
    v_movi_depo_codi_movi := null;
    --------------------------------------------------------------------
  
    v_movi_oper_codi := parameter.p_codi_oper_tras_mas;
  
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := null;
    v_movi_nume                := g_come_remi.remi_nume;
    v_movi_fech_emis           := g_come_remi.remi_fech;
    v_movi_fech_grab           := sysdate;
    v_movi_user                := user;
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
    v_movi_obse                := g_come_remi.remi_obse;
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
    v_movi_empr_codi           := null;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := null;
  
    v_movi_fech_inic_tras := g_come_remi.remi_fech_inic_tras;
    v_movi_fech_term_tras := g_come_remi.remi_fech_term_tras;
    v_movi_tran_codi      := g_come_remi.remi_tran_codi;
    v_movi_vehi_marc      := g_come_remi.remi_marc_vehi;
    v_movi_vehi_chap      := g_come_remi.remi_nume_chap;
    v_movi_cont_tran_nomb := g_come_remi.remi_nomb_tran;
    v_movi_cont_tran_ruc  := g_come_remi.remi_ruc_tran;
    v_movi_cond_empl_codi := g_come_remi.remi_cond_empl_codi;
    v_movi_cond_nomb      := g_come_remi.remi_nomb_cond;
    v_movi_cond_cedu_nume := g_come_remi.remi_cond_cedu_nume;
    v_movi_cond_dire      := g_come_remi.remi_dire_cond;
  
    insert into come_movi
      (movi_codi,
       movi_timo_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
       movi_depo_codi_orig,
       movi_sucu_codi_dest,
       movi_depo_codi_dest,
       movi_sucu_codi_movi,
       movi_depo_codi_movi,
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
       movi_fech_inic_tras,
       movi_fech_term_tras,
       movi_tran_codi,
       movi_vehi_marc,
       movi_vehi_chap,
       movi_cont_tran_nomb,
       movi_cont_tran_ruc,
       movi_cond_empl_codi,
       movi_cond_nomb,
       movi_cond_cedu_nume,
       movi_cond_dire)
    values
      (v_movi_codi,
       v_movi_timo_codi,
       v_movi_clpr_codi,
       v_movi_sucu_codi_orig,
       v_movi_depo_codi_orig,
       v_movi_sucu_codi_dest,
       v_movi_depo_codi_dest,
       v_movi_sucu_codi_movi,
       v_movi_depo_codi_movi,
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
       v_movi_fech_inic_tras,
       v_movi_fech_term_tras,
       v_movi_tran_codi,
       v_movi_vehi_marc,
       v_movi_vehi_chap,
       v_movi_cont_tran_nomb,
       v_movi_cont_tran_ruc,
       v_movi_cond_empl_codi,
       v_movi_cond_nomb,
       v_movi_cond_cedu_nume,
       v_movi_cond_dire);
  
    --------------------------------------------------------------------------------------------------------------
    --  ahora insertar el traslado menos
  
    --- asignar valores....
    v_movi_codi_padr := v_movi_codi;
  
    v_movi_codi      := fa_sec_come_movi;
    v_movi_timo_codi := null;
    v_movi_clpr_codi := null;
  
    --------------------------------------------------------------------
    v_movi_sucu_codi_orig := g_come_remi.remi_sucu_codi; ---el orige
    v_movi_depo_codi_orig := g_come_remi.remi_depo_codi;
  
    v_movi_sucu_codi_dest := g_come_remi.remi_sucu_codi_movi; ---el destino es el movil
    v_movi_depo_codi_dest := g_come_remi.remi_depo_codi_movi;
  
    v_movi_sucu_codi_movi := g_come_remi.remi_sucu_codi_movi;
    v_movi_depo_codi_movi := g_come_remi.remi_depo_codi_movi;
    --------------------------------------------------------------------
  
    v_movi_oper_codi := parameter.p_codi_oper_tras_men;
  
    v_movi_cuen_codi := null;
    v_movi_mone_codi := null;
    v_movi_nume      := g_come_remi.remi_nume;
    v_movi_fech_emis := g_come_remi.remi_fech;
    v_movi_fech_grab := sysdate;
    v_movi_user      := user;
  
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
    v_movi_obse                := g_come_remi.remi_obse;
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
    --v_movi_nume_orpa           := null;
    --v_movi_orpa_esta           := null;
    --v_movi_fech_orpa           := null;
  
    v_movi_fech_inic_tras := g_come_remi.remi_fech_inic_tras;
    v_movi_fech_term_tras := g_come_remi.remi_fech_term_tras;
    v_movi_tran_codi      := g_come_remi.remi_tran_codi;
    v_movi_vehi_marc      := g_come_remi.remi_marc_vehi;
    v_movi_vehi_chap      := g_come_remi.remi_nume_chap;
    v_movi_cont_tran_nomb := g_come_remi.remi_nomb_tran;
    v_movi_cont_tran_ruc  := g_come_remi.remi_ruc_tran;
    v_movi_cond_empl_codi := g_come_remi.remi_cond_empl_codi;
    v_movi_cond_nomb      := g_come_remi.remi_nomb_cond;
    v_movi_cond_cedu_nume := g_come_remi.remi_cond_cedu_nume;
    v_movi_cond_dire      := g_come_remi.remi_dire_cond;
  
  
  
    insert into come_movi
      (movi_codi,
       movi_timo_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
       movi_depo_codi_orig,
       movi_sucu_codi_dest,
       movi_depo_codi_dest,
       movi_sucu_codi_movi,
       movi_depo_codi_movi,
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
       movi_fech_inic_tras,
       movi_fech_term_tras,
       movi_tran_codi,
       movi_vehi_marc,
       movi_vehi_chap,
       movi_cont_tran_nomb,
       movi_cont_tran_ruc,
       movi_cond_empl_codi,
       movi_cond_nomb,
       movi_cond_cedu_nume,
       movi_cond_dire)
    values
      (v_movi_codi,
       v_movi_timo_codi,
       v_movi_clpr_codi,
       v_movi_sucu_codi_orig,
       v_movi_depo_codi_orig,
       v_movi_sucu_codi_dest,
       v_movi_depo_codi_dest,
       v_movi_sucu_codi_movi,
       v_movi_depo_codi_movi,
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
       v_movi_fech_inic_tras,
       v_movi_fech_term_tras,
       v_movi_tran_codi,
       v_movi_vehi_marc,
       v_movi_vehi_chap,
       v_movi_cont_tran_nomb,
       v_movi_cont_tran_ruc,
       v_movi_cond_empl_codi,
       v_movi_cond_nomb,
       v_movi_cond_cedu_nume,
       v_movi_cond_dire);

    ----insertar el detalle para el traslado (+) y (-)
    v_deta_movi_codi  := v_movi_codi;
    v_deta_movi_codi2 := v_movi_codi_padr;
  
    for c_bdet in g_cur_det loop
     
      v_deta_nume_item         := c_bdet.deta_nume_item;
      v_deta_impu_codi         := null;
      v_deta_prod_codi         := c_bdet.deta_prod_codi;
      v_deta_cant              := c_bdet.deta_cant;
      v_deta_obse              := null;
      v_deta_porc_deto         := null;
      v_deta_impo_mone         := null;
      v_deta_impo_mmnn         := null;
      v_deta_impo_mmee         := null;
      v_deta_iva_mmnn          := null;
      v_deta_iva_mmee          := null;
      v_deta_iva_mone          := null;
      v_deta_prec_unit         := null; --c_bdet.deta_prec_unit;
      v_deta_movi_codi_padr    := null;
      v_deta_nume_item_padr    := null;
      v_deta_impo_mone_deto_nc := null;
      v_deta_movi_codi_deto_nc := null;
      v_deta_list_codi         := null;
      v_deta_cant_medi         := c_bdet.deta_cant_medi;
      v_deta_medi_codi         := c_bdet.deta_medi_codi;
      v_deta_lote_codi         := c_bdet.deta_lote_codi;
      v_deta_coba_codi         := c_bdet.deta_coba_codi;
      v_deta_prod_codi_barr    := c_bdet.deta_prod_codi_barr;
    
    
   
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
         deta_cant_medi,
         deta_medi_codi,
         deta_lote_codi,
         deta_prod_codi_barr)
      values
        (v_deta_movi_codi,
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
         v_deta_cant_medi,
         v_deta_medi_codi,
         v_deta_lote_codi,
         v_deta_prod_codi_barr);
     --raise_application_error(-20001,'kssskkk');
  
    
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
         deta_cant_medi,
         deta_medi_codi,
         deta_lote_codi)
      values
        (v_deta_movi_codi2,
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
         v_deta_cant_medi,
         v_deta_medi_codi,
         v_deta_lote_codi);
    end loop;
   
   
  end pp_genera_traslado;

  procedure pp_set_variable is
  begin
    null;
  
    g_come_remi.remi_codi                     := v('P50_REMI_CODI');
    g_come_remi.remi_clpr_codi_acop           := v('P50_REMI_CLPR_CODI_ACOP');
    g_come_remi.code_cont_codi                := v('P50_CODE_CONT_CODI');
    g_come_remi.remi_prde_prod_codi           := v('P50_REMI_PRDE_PROD_CODI');
    g_come_remi.remi_tire_codi                := v('P50_REMI_TIRE_CODI');
    g_come_remi.remi_camp_codi                := v('P50_REMI_CAMP_CODI');
    g_come_remi.remi_fech                     := v('P50_REMI_FECH');
    g_come_remi.remi_sucu_codi                := v('P50_REMI_SUCU_CODI');
    g_come_remi.remi_nume                     := v('P50_REMI_NUME');
    g_come_remi.remi_empl_codi                := v('P50_REMI_EMPL_CODI');
    g_come_remi.remi_esta                     := v('P50_REMI_ESTA');
    g_come_remi.remi_tipo                     := v('P50_REMI_TIPO');
    g_come_remi.remi_codi_padr                := v('P50_REMI_CODI_PADR');
    g_come_remi.remi_base                     := v('P50_REMI_BASE');
    g_come_remi.remi_fech_anal                := v('P50_REMI_FECH_ANAL');
    g_come_remi.remi_basc_dest                := v('P50_REMI_BASC_DEST');
    g_come_remi.remi_peso_brut                := v('P50_REMI_PESO_BRUT');
    g_come_remi.remi_peso_neto                := v('P50_REMI_PESO_NETO');
    g_come_remi.remi_peso_tara                := v('P50_REMI_PESO_TARA');
    g_come_remi.remi_peso_fina                := v('P50_REMI_PESO_FINA');
    g_come_remi.remi_clpr_codi_flet           := v('P50_REMI_CLPR_CODI_FLET');
    g_come_remi.remi_clpr_codi                := v('P50_REMI_CLPR_CODI');
    g_come_remi.remi_peso_deto                := v('P50_REMI_PESO_DETO');
    g_come_remi.remi_dest_codi                := v('P50_REMI_DEST_CODI');
    g_come_remi.remi_depo_codi                := v('P50_REMI_DEPO_CODI');
    g_come_remi.remi_sucu_codi_dest           := v('P50_REMI_SUCU_CODI_DEST');
    g_come_remi.remi_depo_codi_dest           := v('P50_REMI_DEPO_CODI_DEST');
    g_come_remi.remi_mone_codi                := v('P50_REMI_MONE_CODI');
    g_come_remi.remi_tasa_mone                := v('P50_REMI_TASA_MONE');
    g_come_remi.remi_fech_grab                := v('P50_REMI_FECH_GRAB');
    g_come_remi.remi_user                     := v('P50_REMI_USER');
    g_come_remi.remi_impo_mone                := v('P50_REMI_IMPO_MONE');
    g_come_remi.remi_obse                     := v('P50_REMI_OBSE');
    g_come_remi.remi_fech_inic_tras           := v('P50_REMI_FECH_INIC_TRAS');
    g_come_remi.remi_fech_term_tras           := v('P50_REMI_FECH_TERM_TRAS');
    g_come_remi.remi_marc_vehi                := v('P50_REMI_MARC_VEHI');
    g_come_remi.remi_nomb_tran                := v('P50_REMI_NOMB_TRAN');
    g_come_remi.remi_nomb_cond                := v('P50_REMI_NOMB_COND');
    g_come_remi.remi_nume_chap                := v('P50_REMI_NUME_CHAP');
    g_come_remi.remi_ruc_tran                 := v('P50_REMI_RUC_TRAN');
    g_come_remi.remi_cedu_tran                := v('P50_REMI_CEDU_TRAN');
    g_come_remi.remi_moti_tras                := v('P50_REMI_MOTI_TRAS');
    g_come_remi.remi_dire_cond                := v('P50_REMI_DIRE_COND');
    g_come_remi.remi_otro_moti                := v('P50_REMI_OTRO_MOTI');
    g_come_remi.remi_tran_codi                := v('P50_REMI_TRAN_CODI');
    g_come_remi.remi_cond_empl_codi           := v('P50_REMI_COND_EMPL_CODI');
    g_come_remi.remi_cond_cedu_nume           := v('P50_REMI_COND_CEDU_NUME');
    g_come_remi.remi_sucu_codi_movi           := v('P50_REMI_SUCU_CODI_MOVI');
    g_come_remi.remi_depo_codi_movi           := v('P50_REMI_DEPO_CODI_MOVI');
    g_come_remi.remi_movi_codi                := v('P50_REMI_MOVI_CODI');
    g_come_remi.remi_come_movi_rece           := v('P50_REMI_COME_MOVI_RECE');
    g_come_remi.remi_sotr_codi                := v('P50_REMI_SOTR_CODI');
    g_come_remi.remi_clpr_sucu_nume_item      := v('P50_REMI_CLPR_SUCU_NUME_ITEM');
    g_come_remi.remi_clpr_codi_orig           := v('P50_REMI_CLPR_CODI_ORIG');
    g_come_remi.remi_clpr_sucu_nume_item_orig := v('P50_REMI_CLPR_SUCU_NUME_ITEM_ORIG');
    g_come_remi.remi_empr_codi                := v('P50_REMI_EMPR_CODI');
    g_come_remi.remi_clpr_ruc                 := v('P50_REMI_CLPR_RUC');
    g_come_remi.remi_clpr_desc                := v('P50_REMI_CLPR_DESC');
    g_come_remi.remi_clpr_tele                := v('P50_REMI_CLPR_TELE');
    g_come_remi.remi_clpr_dire                := v('P50_REMI_CLPR_DIRE');
    g_come_remi.remi_timbrado                 := v('P50_REMI_TIM');
  --  g_come_remi.remi_tim_fech_ini             := null;
  --  g_come_remi.remi_tim_fech_fin             := null;
    begin
       select /*setc_nume_timb, */setc_fech_venc, setc_fech_inic
             into /*o_remi_tim,*/ g_come_remi.remi_tim_fech_fin  , g_come_remi.remi_tim_fech_ini  
          from come_secu_tipo_comp
         where setc_secu_codi =
               (select peco_secu_codi
                  from come_pers_comp
                 where peco_codi = 1)
           and setc_tico_codi = 15 --tipo de comprobante
         --  and setc_esta = 001 --establecimiento
         --  and setc_punt_expe = 001 --punto de expedicion
           and setc_fech_venc >= to_date(sysdate,'dd/mm/yyyy')
         order by setc_fech_venc;
         exception when others then
           null;
        end;
  
  end pp_set_variable;

  procedure pp_actualizar_registro is
    --v_existe    varchar2(2);
    --v_sucu_orig number;
    --v_sucu_dest number;
    v_nume_orig number;
  begin
  
    null;
  
    pp_set_variable;
    
  
    v_nume_orig := g_come_remi.remi_nume;
    pp_valida_fech(g_come_remi.remi_fech);
    pp_valida_fech(g_come_remi.remi_fech_inic_tras);
    pp_valida_fech(g_come_remi.remi_fech_term_tras);
    
    
  
    pp_valida_nume_remi(v_nume_orig);

    pp_valida_datos;
    pp_reenumerar_nro_item;
    pp_validar_repeticion_prod;
 
    if upper(g_come_remi.remi_moti_tras) = upper('t') then
      ---si es de tipo traslado    
      --genera el traslado de entrada y salida
         
      pp_genera_traslado;
 
    end if;
  
    pp_actualiza_come_remi; ---cabecera y detalle de la remision    
     --
    pp_actualiza_come_secu(g_come_remi.remi_nume);
  
    /* if upper(g_come_remi.remi_moti_tras) = upper('v') then
      ---si de tipo venta
      if g_come_remi.s_comp_vent_codi is not null then
        pp_actualiza_factura; ---aqui no se dispara ningun trigger, el for update de come_movi_prod_deta no tiene nada
      end if;
    end if;*/
  
    --     message('Registro no actualizado !', no_acknowledge);
  
    if g_come_remi.remi_nume <> v_nume_orig then
      null;
      --message('La remision se guardo con el Nro. ' || g_come_remi.remi_nume);
    end if;
   --raise_application_error(-20010, upper(nvl(parameter.p_para_inic, 'TRAS')) ||' then end');
    if nvl(upper(parameter.p_para_inic), 'TRAS') <> 'RECE' then
         pp_impr_remi(g_come_remi.remi_codi);
    end if;
  
  end pp_actualizar_registro;

  procedure pp_add_det(i_deta_ortr_prod in varchar2,
                       i_deta_codi_alfa in number,
                       i_deta_desc      in varchar2,
                       i_codi_barr      in varchar2,
                       i_deta_medi_codi in number,
                       i_deta_medi_DES in varchar2,
                       i_deta_prod_codi in number,
                       i_deta_cant_medi in number) as
  begin
  
    /*
    a.seq_id nro,
           a.seq_id deta_nume_item,
           a.c001   deta_ortr_prod,
           a.c002   prod_codi_alfa,
           a.c003   deta_prod_codi_barr,
           a.c004   prod_desc,
           a.c005   medi_desc_abre,
           a.c006   lote_desc_visual,
           a.c007   deta_prod_peso_kilo,
           a.c008   deta_cant_medi,
           a.c009   deta_lote_codi,
           a.c010   deta_prod_codi,
           a.c011   deta_cant,
           a.c012   deta_medi_codi,
           a.c013   deta_coba_codi,
           a.c014   deta_pulg_unit,
           a.c015   fact_deta_movi_codi,
           a.c016   fact_deta_nume_item
    
    
    */
    if nvl(i_deta_cant_medi,0)<= 0 then
      raise_application_error(-20001,'La Cantidad debe ser mayor a 0 ');
      end if;
  
    apex_collection.add_member(p_collection_name => 'REMI_DET',
                               p_c001            => i_deta_ortr_prod,
                               p_c002            => i_deta_codi_alfa,
                               p_c003            => i_codi_barr,
                               p_c004            => i_deta_desc,
                               p_c005            => i_deta_medi_DES,
                               p_c006            => v('P51_LOTE_DESC_VISUAL'),
                               p_c007            => v('P51_DETA_PROD_PESO_KILO'),
                               p_c008            => i_deta_cant_medi,
                               P_c009            => v('P51_CODI_LOTE'),
                               P_c010            => i_deta_prod_codi,
                               P_c012            => i_deta_medi_codi,
                               p_c013            => v('P51_COBA_CODI'));
  
  end pp_add_det;

  procedure pp_generar_nume(o_remi_nume out number,
                            o_remi_tim out number) is
  
    v_remi_nume      number;
    v_remi_nume_orig number;
    v_count          number;
    --v_num_timb       number;
  begin
    select nvl(secu_nume_remi_clie, 0) + 1
      into v_remi_nume
      from come_secu
     where secu_codi =  (select f.user_secu_codi
                          from segu_user f
                         where user_login = fa_user);
                          
                        
     -----comparacion con numero de timbrado
     begin
       select setc_nume_timb, setc_fech_venc, setc_fech_inic
             into o_remi_tim, g_come_remi.remi_tim_fech_fin  , g_come_remi.remi_tim_fech_ini  
          from come_secu_tipo_comp
         where setc_secu_codi =
               (select peco_secu_codi
                  from come_pers_comp
                 where peco_codi = 1)
           and setc_tico_codi = 15 --tipo de comprobante
         --  and setc_esta = 001 --establecimiento
         --  and setc_punt_expe = 001 --punto de expedicion
           and setc_fech_venc >= to_date(sysdate,'dd/mm/yyyy')
         order by setc_fech_venc;
         exception when no_data_found then
           null;
        end; 
         
  
    v_remi_nume_orig := v_remi_nume;
    loop
      select count(*)
        into v_count
        from come_remi
       where remi_nume = v_remi_nume
       and remi_timbrado=o_remi_tim;
    
      if v_count = 0 then
        exit;
      else
        v_remi_nume := v_remi_nume + 1;
      end if;
    end loop;
  
    o_remi_nume := v_remi_nume;
  
    if v_remi_nume_orig <> v_remi_nume then
      raise_application_error(-20010,
                              'Antencion, la correlatividad de la remision ha cambiado, Favor verifique el Nro pre - impreso');
    end if;
  
  end pp_generar_nume;

  procedure pp_busca_transpor(i_empr_codi in number,
                              p_nombre    out varchar2,
                              p_ruc       out varchar2) is
  begin
    ---el transportista por defecto es la misma empresa
  
    select empr_desc, empr_ruc
      into p_nombre, p_ruc
      from come_empr
     where empr_codi = i_empr_codi;
  exception
    when others then
      null;
  end pp_busca_transpor;
  
  
   procedure pp_borrar_det is
    v_seq_id         number := v('P50_SEQ_ID');
    begin
  
    apex_collection.delete_member(p_collection_name => 'REMI_DET',
                                  p_seq             => v_seq_id);  
    apex_collection.resequence_collection(p_collection_name => 'REMI_DET');
    

  end pp_borrar_det;
  
  
  procedure pp_buscar_cod_barra(p_prod_codi_alfa in number,
                                p_coba_codi_barr out  varchar2,
                                p_coba_Codi out varchar2) is
    v_coba_codi      number(10);
    begin
       select d.coba_codi_barr, d.coba_codi
         into p_coba_codi_barr, p_coba_Codi
         from come_prod, come_prod_coba_deta d
        where prod_codi = d.coba_prod_codi
          and prod_codi_alfa = p_prod_codi_alfa;
          exception when TOO_MANY_ROWS then
            null;
           when others then
            raise_Application_error(-20001, sqlerrm);
      end pp_buscar_cod_barra;
  
  PROCEDURE PP_MOSTRAR_LOTE (P_LOTE_CODI IN NUMBER,
                           P_PROD_CODI IN NUMBER,
                           P_LOTE_DESC OUT VARCHAR2,
                           p_lote_fech_elab OUT VARCHAR2,
                           p_lote_fech_venc OUT VARCHAR2 )IS
V_LOTE_PROD_CODI number(20);
BEGIN
  
  SELECT  LOTE_DESC, LOTE_PROD_CODI, lote_fech_elab, lote_fech_venc  
  INTO P_LOTE_DESC, V_LOTE_PROD_CODI,p_lote_fech_elab, p_lote_fech_venc 
  FROM COME_LOTE
  WHERE LOTE_CODI = P_LOTE_CODI;
  
  IF V_LOTE_PROD_CODI  <> P_PROD_CODI THEN
      raise_application_error(-20001,'El lote no corresponde al Producto');
  END IF;
  
  EXCEPTION  
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20001,'Codigo de lote/Tonalidad no encontrado');
        
    
END PP_MOSTRAR_LOTE;
  
  procedure pp_impr_remi(p_remi_codi varchar2) is 
   v_parametros   clob;
   v_contenedores clob;
   begin
  

   v_contenedores :='p_movi_codi';
   v_parametros :=  p_remi_codi;


   delete from come_parametros_report  where usuario = v('APP_USER');

   insert into come_parametros_report
   (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
   values
   (v_parametros, fa_user, 'I020212_ATL', 'pdf', v_contenedores);
   
  end pp_impr_remi;

end i020218;
