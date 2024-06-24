
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020218R" is

  type t_enca is record(
    fech_rece date);
  benca t_enca;

  type t_cab is record(
    remi_codi           come_remi.remi_codi%type,
    remi_depo_codi_dest come_remi.remi_depo_codi_dest%type,
    remi_sucu_codi_dest come_remi.remi_sucu_codi_dest%type,
    remi_sucu_codi_movi come_remi.remi_sucu_codi_movi%type,
    remi_depo_codi_movi come_remi.remi_depo_codi_movi%type,
    remi_sucu_codi      come_remi.remi_sucu_codi%type,
    remi_depo_codi      come_remi.remi_depo_codi%type,
    remi_moti_tras      come_remi.remi_moti_tras%type,
    remi_fech_grab      come_remi.remi_fech_grab%type,
    remi_user           come_remi.remi_user%type,
    
    remi_nume           come_remi.remi_nume%type,
    remi_obse           come_remi.remi_obse%type,
    remi_fech_inic_tras come_remi.remi_fech_inic_tras%type,
    remi_tran_codi      come_remi.remi_tran_codi%type,
    remi_fech_term_tras come_remi.remi_fech_term_tras%type,
    remi_marc_vehi      come_remi.remi_marc_vehi%type,
    remi_nume_chap      come_remi.remi_nume_chap%type,
    remi_nomb_tran      come_remi.remi_nomb_tran%type,
    remi_ruc_tran       come_remi.remi_ruc_tran%type,
    remi_nomb_cond      come_remi.remi_nomb_cond%type,
    remi_cond_cedu_nume come_remi.remi_cond_cedu_nume%type,
    remi_dire_cond      come_remi.remi_dire_cond%type,
    remi_fech           come_remi.remi_fech%type,
    depo_desc           varchar2(50),
    depo_desc_dest      varchar2(50),
    depo_desc_movi      varchar2(50),
    sucu_desc           varchar2(50),
    sucu_desc_dest      varchar2(50),
    sucu_desc_movi      varchar2(50));
  bcab t_cab;

  type r_parameter is record(
    p_codi_base          number := pack_repl.fa_devu_codi_base,
    p_fech_inic          date,
    p_fech_fini          date,
    p_codi_oper_tras_mas number := to_number(general_skn.fl_busca_parametro('p_codi_oper_tras_mas')),
    p_codi_oper_tras_men number := to_number(general_skn.fl_busca_parametro('p_codi_oper_tras_men')));

  parameter r_parameter;

  cursor cur_bdet is
    select c001 deta_nume_item,
           c002 deta_ortr_prod,
           c003 prod_codi_alfa,
           c004 deta_prod_codi,
           c005 deta_prod_codi_barr,
           c006 prod_desc,
           c007 deta_lote_codi,
           c008 lote_desc,
           c009 medi_desc_abre,
           c010 deta_prod_peso_kilo,
           c011 deta_cant_medi,
           
           c012 deta_coba_codi,
           c013 deta_cant,
           c014 deta_medi_codi,
           c015 lote_medi_larg,
           c016 coba_fact_conv,
           c017 deta_pulg_unit,
           c018 deta_remi_codi,
           c019 prod_codi_ante,
           c020 prod_alfa_ante,
           c021 coba_codi_barr_ante
      from apex_collections a
     where a.collection_name = 'DETA_REMI';

  function fp_dev_indi_suma_rest(p_oper_codi in number) return varchar2 is
    v_stoc_suma_rest varchar2(1);
  begin
    select oper_stoc_suma_rest
      into v_stoc_suma_rest
      from come_stoc_oper
     where oper_codi = p_oper_codi
       and oper_empr_codi = fa_empresa;
  
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
                                p_movi_sucu_codi_movi      in number,
                                p_movi_depo_codi_movi      in number,
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
                                p_movi_fech_inic_tras      in date,
                                p_movi_fech_term_tras      in date,
                                p_movi_tran_codi           in number,
                                p_movi_vehi_marc           in varchar2,
                                p_movi_vehi_chap           in varchar2,
                                p_movi_cont_tran_nomb      in varchar2,
                                p_movi_cont_tran_ruc       in varchar2,
                                p_movi_cond_empl_codi      in number,
                                p_movi_cond_nomb           in varchar2,
                                p_movi_cond_cedu_nume      in varchar2,
                                p_movi_cond_dire           in varchar2) is
  begin
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
       movi_cond_dire,
       movi_base)
    values
      (p_movi_codi,
       p_movi_timo_codi,
       p_movi_clpr_codi,
       p_movi_sucu_codi_orig,
       p_movi_depo_codi_orig,
       p_movi_sucu_codi_dest,
       p_movi_depo_codi_dest,
       p_movi_sucu_codi_movi,
       p_movi_depo_codi_movi,
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
       p_movi_fech_inic_tras,
       p_movi_fech_term_tras,
       p_movi_tran_codi,
       p_movi_vehi_marc,
       p_movi_vehi_chap,
       p_movi_cont_tran_nomb,
       p_movi_cont_tran_ruc,
       p_movi_cond_empl_codi,
       p_movi_cond_nomb,
       p_movi_cond_cedu_nume,
       p_movi_cond_dire,
       parameter.p_codi_base);
  
  end pp_insert_come_movi;

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
                                          p_deta_cant_medi         in number,
                                          p_deta_medi_codi         in number,
                                          p_deta_lote_codi         in number,
                                          p_deta_prod_codi_barr    in varchar2,
                                          p_deta_coba_codi         in number) is
  
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
       deta_cant_medi,
       deta_medi_codi,
       deta_lote_codi,
       deta_prod_codi_barr,
       --deta_coba_codi,
       deta_base --,
       --deta_empr_codi
       )
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
       p_deta_cant_medi,
       p_deta_medi_codi,
       p_deta_lote_codi,
       p_deta_prod_codi_barr,
       --p_deta_coba_codi,
       
       parameter.p_codi_base --,
       --fa_empresa
       );
  end pp_insert_come_movi_prod_deta;

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

  procedure pp_valida_recepcion is
  begin
  
    if not general_skn.fl_vali_user_depo_orig(bcab.remi_depo_codi_dest) then
      raise_application_error(-20010,
                              'El usuario no tiene permisos para Recepcionar en el deposito Destino');
    end if;
  
  end pp_valida_recepcion;

  function fp_ind_permiso_dep(i_depo_codi in number) return boolean is
    v_depo_codi number;
  begin
  
    select depo_codi
      into v_depo_codi
      from come_depo, come_sucu, segu_user, segu_user_depo_dest
     where depo_sucu_codi = sucu_codi
       and depo_codi = i_depo_codi
       and udes_depo_codi = depo_codi
       and user_codi = udes_user_codi
       and depo_empr_codi = fa_empresa
       and user_login = fa_user;
    return true;
  exception
    when no_data_found then
      return false;
  end fp_ind_permiso_dep;

  procedure pp_mostrar_depo_sucu(i_depo_codi in number,
                                 o_depo_desc out varchar2,
                                 o_sucu_codi out number,
                                 o_sucu_desc out varchar2) is
  begin
  
    select depo_desc, sucu_codi, sucu_desc
      into o_depo_desc, o_sucu_codi, o_sucu_desc
      from come_depo, come_sucu
     where depo_sucu_codi = sucu_codi
       and depo_empr_codi = sucu_empr_codi
       and depo_empr_codi = fa_empresa
       and depo_codi      = i_depo_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Deposito Partida ' || i_depo_codi ||
                              ' inexistente.');
  end pp_mostrar_depo_sucu;

  procedure pp_mostrar_depo_sucu_dest(i_depo_codi in number,
                                      o_depo_desc out varchar2,
                                      o_sucu_codi out number,
                                      o_sucu_desc out varchar2) is
  begin
  
    select depo_desc, sucu_codi, sucu_desc
      into o_depo_desc, o_sucu_codi, o_sucu_desc
      from come_depo, come_sucu, segu_user, segu_user_depo_dest
     where depo_sucu_codi = sucu_codi
       and depo_empr_codi = sucu_empr_codi
       and depo_codi = i_depo_codi
       and udes_depo_codi = depo_codi
       and user_codi = udes_user_codi
       and depo_empr_codi = fa_empresa
       and user_login = fa_user;
  
  exception
    when no_data_found then
      begin
        select depo_desc, sucu_codi, sucu_desc
          into o_depo_desc, o_sucu_codi, o_sucu_desc
          from come_depo, come_sucu
         where depo_sucu_codi = sucu_codi
           and depo_empr_codi = fa_empresa
           and depo_codi = i_depo_codi;
      exception
        when no_data_found then
          raise_application_error(-20010,
                                  'Deposito Llegada ' || i_depo_codi ||
                                  ' inexistente.');
      end;
  end pp_mostrar_depo_sucu_dest;

  procedure pp_mostrar_depo_sucu_movi(i_depo_codi in number,
                                      i_depo_desc out varchar2,
                                      i_sucu_codi out number,
                                      i_sucu_desc out varchar2) is
  
  begin
  
    select depo_desc, sucu_codi, sucu_desc
      into i_depo_desc, i_sucu_codi, i_sucu_desc
      from come_depo, come_sucu, segu_user, segu_user_depo_orig
     where depo_sucu_codi = sucu_codi
       and depo_empr_codi = sucu_empr_codi
       and depo_codi = i_depo_codi
       and depo_empr_codi = fa_empresa
       and udor_depo_codi = depo_codi
       and user_codi = udor_user_codi
       and user_login = fa_user
       and depo_indi_movi = 'S';
  
  exception
    when no_data_found then
      begin
        select depo_desc, sucu_codi, sucu_desc
          into i_depo_desc, i_sucu_codi, i_sucu_desc
          from come_depo, come_sucu
         where depo_sucu_codi = sucu_codi
           and depo_empr_codi = fa_empresa
           and depo_codi = i_depo_codi;
      exception
        when no_data_found then
          raise_application_error(-20010,
                                  'Deposito Movil ' || i_depo_codi ||
                                  ' inexistente.');
      end;
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_mostrar_depo_sucu_movi;

  procedure pp_genera_recepcion is
    v_movi_codi                number;
    v_movi_timo_codi           number;
    v_movi_clpr_codi           number;
    v_movi_sucu_codi_orig      number;
    v_movi_depo_codi_orig      number;
    v_movi_sucu_codi_dest      number;
    v_movi_depo_codi_dest      number;
    v_movi_sucu_codi_movi      number;
    v_movi_cuen_codi           number;
    v_movi_depo_codi_movi      number;
    v_movi_oper_codi           number;
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
  
    --- asignar valores....
    v_movi_codi      := fa_sec_come_movi;
    v_movi_codi_padr := null;
  
    v_movi_timo_codi := null;
    v_movi_clpr_codi := null;
  
    ---del movil al destino
    --invertido para el traslado(+) -----------------------------------
    v_movi_sucu_codi_orig := bcab.remi_sucu_codi_dest;
    v_movi_depo_codi_orig := bcab.remi_depo_codi_dest;
  
    v_movi_sucu_codi_dest := bcab.remi_sucu_codi_movi;
    v_movi_depo_codi_dest := bcab.remi_depo_codi_movi;
  
    v_movi_sucu_codi_movi := null;
    v_movi_depo_codi_movi := null;
    --------------------------------------------------------------------
  
    v_movi_oper_codi := parameter.p_codi_oper_tras_mas;
  
    v_movi_cuen_codi := null;
    v_movi_mone_codi := null;
    v_movi_nume      := bcab.remi_nume;
    v_movi_fech_emis := benca.fech_rece;
  
    v_movi_fech_grab           := sysdate;
    v_movi_user                := fa_user;
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
    v_movi_obse                := bcab.remi_obse;
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
    v_movi_empr_codi           := fa_empresa;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := null;
  
    v_movi_fech_inic_tras := bcab.remi_fech_inic_tras;
    v_movi_fech_term_tras := bcab.remi_fech_term_tras;
    v_movi_tran_codi      := bcab.remi_tran_codi;
    v_movi_vehi_marc      := bcab.remi_marc_vehi;
    v_movi_vehi_chap      := bcab.remi_nume_chap;
    v_movi_cont_tran_nomb := bcab.remi_nomb_tran;
    v_movi_cont_tran_ruc  := bcab.remi_ruc_tran;
    v_movi_cond_empl_codi := bcab.remi_tran_codi;
    v_movi_cond_nomb      := bcab.remi_nomb_cond;
    v_movi_cond_cedu_nume := bcab.remi_cond_cedu_nume;
    v_movi_cond_dire      := bcab.remi_dire_cond;
  
    pp_insert_come_movi(v_movi_codi,
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
  
    update come_remi r
       set r.remi_come_movi_rece = v_movi_codi
     where r.remi_codi = bcab.remi_codi
      and  r.remi_empr_codi=fa_empresa;
  
    --------------------------------------------------------------------------------------------------------------
    --  ahora insertar el traslado menos
  
    --- asignar valores....
    v_movi_codi_padr := v_movi_codi;
    v_movi_codi      := fa_sec_come_movi;
  
    v_movi_timo_codi := null;
    v_movi_clpr_codi := null;
  
    --------------------------------------------------------------------
    v_movi_sucu_codi_orig := bcab.remi_sucu_codi_movi;
    v_movi_depo_codi_orig := bcab.remi_depo_codi_movi;
  
    v_movi_sucu_codi_dest := bcab.remi_sucu_codi_dest;
    v_movi_depo_codi_dest := bcab.remi_depo_codi_dest;
  
    v_movi_sucu_codi_movi := null;
    v_movi_depo_codi_movi := null;
    --------------------------------------------------------------------
  
    v_movi_oper_codi := parameter.p_codi_oper_tras_men;
  
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := null;
    v_movi_nume                := bcab.remi_nume;
    v_movi_fech_emis           := benca.fech_rece;
    v_movi_fech_grab           := sysdate;
    v_movi_user                := fa_user;
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
    v_movi_obse                := bcab.remi_obse;
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
    v_movi_empr_codi           := fa_empresa;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := null;
  
    v_movi_fech_inic_tras := bcab.remi_fech_inic_tras;
    v_movi_fech_term_tras := bcab.remi_fech_term_tras;
    v_movi_tran_codi      := bcab.remi_tran_codi;
    v_movi_vehi_marc      := bcab.remi_marc_vehi;
    v_movi_vehi_chap      := bcab.remi_nume_chap;
    v_movi_cont_tran_nomb := bcab.remi_nomb_tran;
    v_movi_cont_tran_ruc  := bcab.remi_ruc_tran;
    v_movi_cond_empl_codi := bcab.remi_tran_codi;
    v_movi_cond_nomb      := bcab.remi_nomb_cond;
    v_movi_cond_cedu_nume := bcab.remi_cond_cedu_nume;
    v_movi_cond_dire      := bcab.remi_dire_cond;
  
    pp_insert_come_movi(v_movi_codi,
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
  
    for bdet in cur_bdet loop
    
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
      v_deta_prec_unit         := null;
      v_deta_movi_codi_padr    := null;
      v_deta_nume_item_padr    := null;
      v_deta_impo_mone_deto_nc := null;
      v_deta_movi_codi_deto_nc := null;
      v_deta_list_codi         := null;
      v_deta_cant_medi         := bdet.deta_cant_medi;
      v_deta_medi_codi         := bdet.deta_medi_codi;
      v_deta_lote_codi         := bdet.deta_lote_codi;
      v_deta_coba_codi         := bdet.deta_coba_codi;
      v_deta_prod_codi_barr    := bdet.deta_prod_codi_barr;
    
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
                                    v_deta_cant_medi,
                                    v_deta_medi_codi,
                                    v_deta_lote_codi,
                                    v_deta_prod_codi_barr,
                                    v_deta_coba_codi);
    
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
                                    v_deta_list_codi,
                                    v_deta_cant_medi,
                                    v_deta_medi_codi,
                                    v_deta_lote_codi,
                                    v_deta_prod_codi_barr,
                                    v_deta_coba_codi);
    
    end loop;
  
  end pp_genera_recepcion;

  procedure pp_cargar_detalle(bdet in cur_bdet%rowtype) is
  begin
  
    apex_collection.add_member(p_collection_name => 'DETA_REMI',
                               p_c001            => bdet.deta_nume_item,
                               p_c002            => bdet.deta_ortr_prod,
                               p_c003            => bdet.prod_codi_alfa,
                               p_c004            => bdet.deta_prod_codi,
                               p_c005            => bdet.deta_prod_codi_barr,
                               p_c006            => bdet.prod_desc,
                               p_c007            => bdet.deta_lote_codi,
                               p_c008            => bdet.lote_desc,
                               p_c009            => bdet.medi_desc_abre,
                               p_c010            => bdet.deta_prod_peso_kilo,
                               p_c011            => bdet.deta_cant_medi,
                               p_c012            => bdet.deta_coba_codi,
                               p_c013            => bdet.deta_cant,
                               p_c014            => bdet.deta_medi_codi,
                               p_c015            => bdet.lote_medi_larg,
                               p_c016            => bdet.coba_fact_conv,
                               p_c017            => bdet.deta_pulg_unit,
                               p_c018            => bdet.deta_remi_codi,
                               p_c019            => bdet.prod_codi_ante,
                               p_c020            => bdet.prod_alfa_ante,
                               p_c021            => bdet.coba_codi_barr_ante);
  end pp_cargar_detalle;

  procedure pp_cargar_remision(p_remi_codi in number) is
  
    cursor c_remi is
      select remi_fech,
             remi_sucu_codi,
             remi_nume,
             remi_codi,
             null clpr_codi_alte,
             remi_depo_codi,
             remi_depo_codi_dest,
             remi_depo_codi_movi,
             remi_mone_codi,
             remi_fech_inic_tras,
             remi_fech_term_tras,
             remi_marc_vehi,
             remi_nomb_tran,
             remi_nomb_cond,
             remi_dire_cond,
             remi_nume_chap,
             remi_ruc_tran,
             remi_cedu_tran,
             nvl(remi_moti_tras, 'V') remi_moti_tras,
             remi_obse,
             remi_cond_cedu_nume,
             remi_fech_grab,
             remi_user
        from come_remi r, come_depo do, come_depo dd, come_depo dm
       where remi_depo_codi = do.depo_codi(+)
         and remi_depo_codi_dest = dd.depo_codi(+)
         and remi_depo_codi_movi = dm.depo_codi(+)
         and remi_codi = p_remi_codi;
  
    cursor c_remi_deta is
      select deta_ortr_prod,
             deta_prod_codi,
             p.prod_codi_alfa,
             deta_conc_codi,
             deta_desc,
             deta_lote_codi,
             deta_medi_codi,
             deta_long,
             deta_cant,
             deta_cant_medi,
             deta_pulg_unit,
             deta_nume_item,
             p.prod_peso_kilo,
             nvl(deta_prod_codi_barr, prod_codi_alfa) deta_prod_codi_barr,
             coba_fact_conv,
             medi_desc_abre,
             lote_desc
        from come_remi_deta,
             come_prod           p,
             come_conc           c,
             come_prod_coba_deta,
             come_unid_medi,
             come_lote           l
       where deta_prod_codi = p.prod_codi(+)
         and deta_conc_codi = c.conc_codi(+)
         and deta_prod_codi_barr = coba_codi_barr(+)
         and deta_prod_codi = coba_prod_codi(+)
         and deta_medi_codi = medi_codi(+)
         and deta_lote_codi = lote_codi(+)
         and deta_remi_codi = p_remi_codi
       order by deta_nume_item;
  
    bdet cur_bdet%rowtype;
  begin
  
   

    for x in c_remi loop
      bcab.remi_fech           := x.remi_fech;
      bcab.remi_sucu_codi      := x.remi_sucu_codi;
      bcab.remi_nume           := x.remi_nume;
      bcab.remi_codi           := x.remi_codi;
      bcab.remi_depo_codi      := x.remi_depo_codi;
      bcab.remi_depo_codi_dest := x.remi_depo_codi_dest;
      bcab.remi_depo_codi_movi := x.remi_depo_codi_movi;
      bcab.remi_fech_inic_tras := x.remi_fech_inic_tras;
      bcab.remi_fech_term_tras := x.remi_fech_term_tras;
      bcab.remi_marc_vehi      := x.remi_marc_vehi;
      bcab.remi_nomb_tran      := x.remi_nomb_tran;
      bcab.remi_nomb_cond      := x.remi_nomb_cond;
      bcab.remi_dire_cond      := x.remi_dire_cond;
      bcab.remi_nume_chap      := x.remi_nume_chap;
      bcab.remi_ruc_tran       := x.remi_ruc_tran;
      bcab.remi_cond_cedu_nume := x.remi_cedu_tran;
      bcab.remi_moti_tras      := x.remi_moti_tras;
      bcab.remi_obse           := x.remi_obse;
      bcab.remi_cond_cedu_nume := x.remi_cond_cedu_nume;
      bcab.remi_fech_grab      := x.remi_fech_grab;
      bcab.remi_user           := x.remi_user;
    
      pp_mostrar_depo_sucu(bcab.remi_depo_codi,
                           bcab.depo_desc,
                           bcab.remi_sucu_codi,
                           bcab.sucu_desc);
                          
      
      pp_mostrar_depo_sucu_dest(bcab.remi_depo_codi_dest,
                                bcab.depo_desc_dest,
                                bcab.remi_sucu_codi_dest,
                                bcab.sucu_desc_dest);
                              
      pp_mostrar_depo_sucu_movi(bcab.remi_depo_codi_movi,
                                bcab.depo_desc_movi,
                                bcab.remi_sucu_codi_movi,
                                bcab.sucu_desc_movi);
    
     
      setitem('P57_DEPO_DESC', bcab.depo_desc);
      setitem('P57_SUCU_DESC', bcab.sucu_desc);
      ---Deposito Destino
      setitem('P57_DEPO_DESC_DEST', bcab.depo_desc_dest);
      setitem('P57_SUCU_DESC_DEST', bcab.sucu_desc_dest);
      ---Deposito Movil
      setitem('P57_DEPO_DESC_MOVI', bcab.depo_desc_movi);
      setitem('P57_SUCU_DESC_MOVI', bcab.sucu_desc_movi);
    
      setitem('P57_REMI_NUME', bcab.remi_nume);
      setitem('P57_S_REMI_CODI', bcab.remi_codi);
      setitem('P57_REMI_OBSE', bcab.remi_obse);
      setitem('P57_REMI_FECH_INIC_TRAS', bcab.remi_fech_inic_tras);
      setitem('P57_REMI_FECH_TERM_TRAS', bcab.remi_fech_term_tras);
      setitem('P57_REMI_USER', bcab.remi_user);
      setitem('P57_REMI_MOTI_TRAS', bcab.remi_moti_tras);
      setitem('P57_REMI_FECH', bcab.remi_fech);
      --setitem('P57_CLPR_CODI_ALTE', bcab.clpr_codi_alte);
    
      setitem('P57_REMI_SUCU_CODI', bcab.remi_sucu_codi);
      setitem('P57_REMI_DEPO_CODI', bcab.remi_depo_codi);
      setitem('P57_REMI_SUCU_CODI_DEST', bcab.remi_sucu_codi_dest);
      setitem('P57_REMI_DEPO_CODI_DEST', bcab.remi_depo_codi_dest);
      setitem('P57_REMI_SUCU_CODI_MOVI', bcab.remi_sucu_codi_movi);
    
      --setitem('P57_REMI_MONE_CODI', bcab.remi_mone_codi);
      setitem('P57_REMI_NOMB_TRAN', bcab.remi_nomb_tran);
      setitem('P57_REMI_NUME_CHAP', bcab.remi_nume_chap);
      setitem('P57_REMI_RUC_TRAN', bcab.remi_ruc_tran);
      setitem('P57_REMI_NOMB_COND', bcab.remi_nomb_cond);
      setitem('P57_REMI_MARC_VEHI', bcab.remi_marc_vehi);
      setitem('P57_REMI_TRAN_CODI', bcab.remi_tran_codi);
      setitem('P57_REMI_DEPO_CODI_MOVI', bcab.remi_depo_codi_movi);
      setitem('P57_REMI_COND_CEDU_NUME', bcab.remi_cond_cedu_nume);
      setitem('P57_REMI_DIRE_COND', bcab.remi_dire_cond);
      setitem('P57_REMI_FECH_GRAB',
              to_char(bcab.remi_fech_grab, 'dd/mm/yyyy hh24:mi:ss'));
    
      for z in c_remi_deta loop
        bdet.deta_nume_item      := z.deta_nume_item;
        bdet.deta_ortr_prod      := nvl(z.deta_ortr_prod, 'P');
        bdet.prod_codi_alfa      := z.prod_codi_alfa;
        bdet.deta_prod_codi      := z.deta_prod_codi;
        bdet.deta_lote_codi      := z.deta_lote_codi;
        bdet.deta_prod_codi_barr := z.deta_prod_codi_barr;
        bdet.deta_medi_codi      := z.deta_medi_codi;
        bdet.prod_desc           := z.deta_desc;
        bdet.deta_prod_peso_kilo := z.prod_peso_kilo;
        bdet.lote_medi_larg      := z.deta_long;
        bdet.deta_cant           := z.deta_cant;
        bdet.deta_cant_medi      := z.deta_cant_medi;
        bdet.coba_fact_conv      := z.coba_fact_conv;
        bdet.deta_pulg_unit      := z.deta_pulg_unit;
        bdet.deta_remi_codi      := bcab.remi_codi;
        bdet.medi_desc_abre      := z.medi_desc_abre;
        bdet.lote_desc           := z.lote_desc;
        bdet.prod_codi_ante      := bdet.deta_prod_codi;
        bdet.prod_alfa_ante      := bdet.prod_codi_alfa;
        bdet.coba_codi_barr_ante := bdet.deta_prod_codi_barr;
        pp_cargar_detalle(bdet);
      end loop;
    end loop;
  end pp_cargar_remision;

  procedure pp_set_variable is
  begin
    -- bcab.s_remi_codi         := v('P57_S_REMI_CODI');
    bcab.remi_obse           := v('P57_REMI_OBSE');
    bcab.remi_fech_inic_tras := v('P57_REMI_FECH_INIC_TRAS');
    --  bcab.menu_sucu_codi      := v('P57_MENU_SUCU_CODI');
    benca.fech_rece          := v('P57_FECH_RECE');
    bcab.remi_fech_grab      := to_date(v('P57_REMI_FECH_GRAB'),
                                        'dd/mm/yyyy hh24:mi:ss');
    bcab.remi_codi           := v('P57_REMI_CODI');
    bcab.remi_fech_term_tras := v('P57_REMI_FECH_TERM_TRAS');
    bcab.remi_user           := v('P57_REMI_USER');
    bcab.remi_tran_codi      := v('P57_REMI_TRAN_CODI');
    bcab.remi_moti_tras      := v('P57_REMI_MOTI_TRAS');
    bcab.remi_nume           := v('P57_REMI_NUME');
    bcab.remi_marc_vehi      := v('P57_REMI_MARC_VEHI');
    bcab.remi_fech           := v('P57_REMI_FECH');
    --bcab.clpr_codi_alte      := v('P57_CLPR_CODI_ALTE');
    bcab.remi_nume_chap := v('P57_REMI_NUME_CHAP');
    bcab.remi_depo_codi := v('P57_REMI_DEPO_CODI');
    --  bcab.remi_mone_codi      := v('P57_REMI_MONE_CODI');
    bcab.depo_desc           := v('P57_DEPO_DESC');
    bcab.remi_nomb_tran      := v('P57_REMI_NOMB_TRAN');
    bcab.remi_ruc_tran       := v('P57_REMI_RUC_TRAN');
    bcab.remi_sucu_codi      := v('P57_REMI_SUCU_CODI');
    bcab.sucu_desc           := v('P57_SUCU_DESC');
    bcab.remi_nomb_cond      := v('P57_REMI_NOMB_COND');
    bcab.remi_depo_codi_dest := v('P57_REMI_DEPO_CODI_DEST');
    bcab.remi_cond_cedu_nume := v('P57_REMI_COND_CEDU_NUME');
    bcab.depo_desc_dest      := v('P57_DEPO_DESC_DEST');
    bcab.remi_dire_cond      := v('P57_REMI_DIRE_COND');
    bcab.remi_sucu_codi_dest := v('P57_REMI_SUCU_CODI_DEST');
    bcab.sucu_desc_dest      := v('P57_SUCU_DESC_DEST');
    bcab.remi_depo_codi_movi := v('P57_REMI_DEPO_CODI_MOVI');
    bcab.depo_desc_movi      := v('P57_DEPO_DESC_MOVI');
    bcab.remi_sucu_codi_movi := v('P57_REMI_SUCU_CODI_MOVI');
    bcab.sucu_desc_movi      := v('P57_SUCU_DESC_MOVI');
  
  end pp_set_variable;

  procedure pp_validar is
  begin
    null;
  
    if benca.fech_rece is null then
      raise_application_error(-20010,
                              'Debe ingresar la fecha de recepcion');
    end if;
  
    if not (fp_ind_permiso_dep(bcab.remi_depo_codi_dest)) then
      raise_application_error(-20010,
                              'El usuario no tiene permiso sobre el Deposito Llegada.');
    end if;
  
    if not (fp_ind_permiso_dep(bcab.remi_depo_codi_movi)) then
      raise_application_error(-20010,
                              'El usuario no tiene permiso sobre el Deposito Movil.');
    end if;
  
  end pp_validar;

  procedure pp_actualizar_registro is
    v_mensaje varchar2(500);
  begin
    pp_set_variable;
  
    pp_validar;
    --fecha de la recepcion
    pp_valida_fech(benca.fech_rece);
  
    pp_valida_recepcion;
    pp_genera_recepcion;
  
    v_mensaje                                := 'Registro actualizado correctamente';
    apex_application.g_print_success_message := v_mensaje;
  
  end pp_actualizar_registro;

  procedure pp_iniciar is
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'DETA_REMI');
  end pp_iniciar;

begin
  pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);


end i020218r;
