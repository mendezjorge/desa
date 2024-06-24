
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020260" is

  /******DECLARACIONES DE PARAMETROS INICIALES ***********************/

  p_codi_oper_perd number := to_number(fa_busc_para('p_codi_oper_perd'));
  p_codi_oper_com  number := to_number(fa_busc_para('p_codi_oper_com'));
  p_peco           number := 1;
  p_form_cons_stoc varchar2(500) := fa_busc_para('p_form_cons_stoc');
  p_form_anul_stoc varchar2(500) := fa_busc_para('p_form_anul_stoc');
  p_repo_ajus      varchar2(500) := fa_busc_para('p_repo_ajus');
  p_form_abmc_prod varchar2(500) := ltrim(rtrim(fa_busc_para('p_form_abmc_prod')));

  p_codi_impu_exen           number := to_number(fa_busc_para('p_codi_impu_exen'));
  p_codi_base                number := pack_repl.fa_devu_codi_base;
  p_codi_mone_mmee           number := to_number(fa_busc_para('p_codi_mone_mmee'));
  p_cant_deci_mmee           number;
  p_codi_mone_mmnn           number := to_number(fa_busc_para('p_codi_mone_mmnn'));
  p_cant_deci_mmnn           number := to_number(fa_busc_para('p_cant_deci_mmnn'));
  p_cant_deci_prec_unit_comp number := to_number(fa_busc_para('p_cant_deci_prec_unit_comp'));

  p_fech_inic date;
  p_fech_fini date;

  p_sess      varchar2(500) := v('APP_SESSION');
  v_movi_codi number;

  /******************* ACTUALIZAR REGISTRO *******/

  procedure pp_actualizar_registro(ii_p_fech                   in date,
                                   ii_movi_sucu_codi_orig      in number,
                                   ii_movi_depo_codi_orig      in number,
                                   ii_movi_oper_codi           in number,
                                   ii_movi_mone_codi           in number,
                                   ii_movi_nume                in number,
                                   ii_movi_fech_emis           in date,
                                   ii_movi_tasa_mone           in number,
                                   ii_movi_tasa_mmee           in number,
                                   ii_movi_obse                in varchar2,
                                   ii_movi_stoc_suma_rest      in varchar2,
                                   ii_movi_stoc_afec_cost_prom in varchar2,
                                   ii_movi_mone_cant_deci      in number,
                                   ii_indi_venc                in varchar2) is
  begin
  
    --validar fecha
    I020260.pp_valida_fech(p_fech => ii_p_fech);
  
    -- cargamos decimal MMEE
    pp_muestra_desc_mone(p_codi_mone_mmee, p_cant_deci_mmee);
  
    --cargamos come-movi
    begin
      I020260.pp_actualiza_come_movi(i_movi_sucu_codi_orig      => ii_movi_sucu_codi_orig,
                                     i_movi_depo_codi_orig      => ii_movi_depo_codi_orig,
                                     i_movi_oper_codi           => ii_movi_oper_codi,
                                     i_movi_mone_codi           => ii_movi_mone_codi,
                                     i_movi_nume                => ii_movi_nume,
                                     i_movi_fech_emis           => ii_movi_fech_emis,
                                     i_movi_tasa_mone           => ii_movi_tasa_mone,
                                     i_movi_tasa_mmee           => ii_movi_tasa_mmee,
                                     i_movi_obse                => ii_movi_obse,
                                     i_movi_stoc_suma_rest      => ii_movi_stoc_suma_rest,
                                     i_movi_stoc_afec_cost_prom => ii_movi_stoc_afec_cost_prom);
    exception
      when others then
        raise_application_error(-20010,
                                'Error al momento de actualizar Come_Movi ' ||
                                sqlerrm);
      
    end;
  
    --cargamos come_movi_prod
    begin
      I020260.pp_actualiza_come_movi_prod(i_movi_codi           => v_movi_codi,
                                          i_movi_mone_cant_deci => ii_movi_mone_cant_deci,
                                          i_movi_tasa_mone      => ii_movi_tasa_mone,
                                          i_movi_tasa_mmee      => ii_movi_tasa_mmee,
                                          i_indi_venc           => ii_indi_venc);
    
    exception
      when others then
        raise_application_error(-20010,
                                'Error al momento de actualizar Come_Movi_Prod ' ||
                                sqlerrm);
    end;
  
    --actualizamos secuencias
    begin
      I020260.pp_actu_secu(i_movi_nume => ii_movi_nume);
    end;
    
    --generamos reporte
    begin
     I020260.pp_genera_reporte;
    end;

  end pp_actualizar_registro;

  procedure pp_actualiza_come_movi(i_movi_sucu_codi_orig      in number,
                                   i_movi_depo_codi_orig      in number,
                                   i_movi_oper_codi           in number,
                                   i_movi_mone_codi           in number,
                                   i_movi_nume                in number,
                                   i_movi_fech_emis           in date,
                                   i_movi_tasa_mone           in number,
                                   i_movi_tasa_mmee           in number,
                                   i_movi_obse                in varchar2,
                                   i_movi_stoc_suma_rest      in varchar2,
                                   i_movi_stoc_afec_cost_prom in varchar2) is
  
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
  
    v_movi_codi                := fa_sec_come_movi;
    v_movi_timo_codi           := null;
    v_movi_clpr_codi           := null;
    v_movi_sucu_codi_orig      := i_movi_sucu_codi_orig;
    v_movi_depo_codi_orig      := i_movi_depo_codi_orig;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := i_movi_oper_codi;
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := i_movi_mone_codi;
    v_movi_nume                := i_movi_nume;
    v_movi_fech_emis           := i_movi_fech_emis;
    v_movi_fech_grab           := sysdate;
    v_movi_user                := fa_user;
    v_movi_codi_padr           := null;
    v_movi_tasa_mone           := i_movi_tasa_mone;
    v_movi_tasa_mmee           := i_movi_tasa_mmee;
    v_movi_grav_mmnn           := null;
    v_movi_exen_mmnn           := null;
    v_movi_iva_mmnn            := null;
    v_movi_grav_mmee           := null;
    v_movi_exen_mmee           := null;
    v_movi_iva_mmee            := null;
    v_movi_grav_mone           := null;
    v_movi_exen_mone           := null;
    v_movi_iva_mone            := null;
    v_movi_obse                := i_movi_obse;
    v_movi_sald_mmnn           := null;
    v_movi_sald_mmee           := null;
    v_movi_sald_mone           := null;
    v_movi_stoc_suma_rest      := i_movi_stoc_suma_rest;
    v_movi_clpr_dire           := null;
    v_movi_clpr_tele           := null;
    v_movi_clpr_ruc            := null;
    v_movi_clpr_desc           := null;
    v_movi_emit_reci           := null;
    v_movi_afec_sald           := null;
    v_movi_dbcr                := null;
    v_movi_stoc_afec_cost_prom := i_movi_stoc_afec_cost_prom;
    v_movi_empr_codi           := fa_empresa;
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

  procedure pp_actualiza_come_movi_prod(i_movi_codi           in number,
                                        i_movi_mone_cant_deci in number,
                                        i_movi_tasa_mone      in number,
                                        i_movi_tasa_mmee      in number,
                                        i_indi_venc           in varchar2) is
    v_deta_movi_codi         number;
    v_deta_nume_item         number;
    v_deta_impu_codi         number;
    v_deta_prod_codi         number;
    v_deta_cant_medi         number;
    v_deta_cant              number;
    v_deta_medi_codi         number;
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
    v_deta_indi_venc         varchar2(1) := 'N';
    v_item                   number := 0;
  
    cursor c_deta is
      select taax_n001 v_prod_codi,
             taax_n002 v_moco_impu,
             taax_n003 v_medi_codi,
             taax_c001 v_medi_desc,
             taax_n004 v_deta_cant_medi,
             taax_n005 v_deta_prec_unit,
             taax_n006 v_total,
             taax_n007 v_deta_prod_codi_barr,
             taax_c002 v_deta_obse,
             taax_n008 v_prod_codi_alfa,
             taax_n009 v_deta_cant,
             taax_c003 v_prod_desc,
             taax_seq  v_seq
        from come_tabl_auxi
       where taax_sess = p_sess
         and taax_user = fa_user;
  
  begin
    v_deta_movi_codi := i_movi_codi;
  
    for i in c_deta loop
    
      v_item := v_item + 1;
    
      v_deta_nume_item := v_item;
      v_deta_impu_codi := 1;
      v_deta_prod_codi := i.v_prod_codi;
      v_deta_cant_medi := i.v_deta_cant_medi;
      v_deta_cant      := i.v_deta_cant;
      v_deta_obse      := 'Perdida. ' || i.v_deta_obse;
      v_deta_medi_codi := i.v_medi_codi;
    
      v_deta_porc_deto         := 0;
      v_deta_impo_mone         := round((i.v_deta_prec_unit *
                                        i.v_deta_cant_medi),
                                        i_movi_mone_cant_deci);
      v_deta_impo_mmnn         := round((v_deta_impo_mone *
                                        i_movi_tasa_mone),
                                        p_cant_deci_mmnn);
      v_deta_impo_mmee         := round((v_deta_impo_mmnn /
                                        i_movi_tasa_mmee),
                                        p_cant_deci_mmee);
      v_deta_iva_mmnn          := 0;
      v_deta_iva_mmee          := 0;
      v_deta_iva_mone          := 0;
      v_deta_prec_unit         := i.v_deta_prec_unit;
      v_deta_movi_codi_padr    := null;
      v_deta_nume_item_padr    := null;
      v_deta_impo_mone_deto_nc := null;
      v_deta_movi_codi_deto_nc := null;
      v_deta_list_codi         := null;
      v_deta_indi_venc         := nvl(i_indi_venc, 'N');
    
      pp_insert_come_movi_prod_deta(v_deta_movi_codi,
                                    v_deta_nume_item,
                                    v_deta_impu_codi,
                                    v_deta_prod_codi,
                                    v_deta_cant_medi,
                                    v_deta_cant,
                                    v_deta_obse,
                                    v_deta_medi_codi,
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
                                    v_deta_indi_venc);
    
    end loop;
  
  end pp_actualiza_come_movi_prod;

  procedure pp_actu_secu(i_movi_nume in number) is
  begin
    update come_secu
       set secu_nume_perd = i_movi_nume
     where secu_codi = (select peco_secu_codi
                          from come_pers_comp
                         where peco_codi = p_peco);
  
  end;

  /******************* VALIDACIONES **************/
  procedure pp_valida_nume(i_movi_nume in number) is
    v_count number;
  begin
  
    select count(*)
      into v_count
      from come_movi
     where movi_nume = i_movi_nume
       and movi_oper_codi in (p_codi_oper_perd);
  
    if v_count > 0 then
      raise_application_error(-20010, 'Nro de operaci¿n existente.');
    end if;
  end;

  procedure pp_valida_fech(p_fech in date) is
  begin
  
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
  
    if p_fech not between p_fech_inic and p_fech_fini then
    
      raise_application_error(-20010,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                              to_char(p_fech_fini, 'dd-mm-yyyy'));
    end if;
  
  end;

  /****************** CARGA DE DATOS  ************/

  procedure pp_buscar_nume(p_nume out number) is
  begin
  
    select (nvl(secu_nume_perd, 0) + 1) nume
      into p_nume
      from come_secu s, come_pers_comp t
     where s.secu_codi = t.peco_secu_codi
       and t.peco_codi = p_peco;
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Codigo de Secuencia no fue correctamente asignada a la terminal');
    when others then
      raise_application_error(-20010,
                              'Error al momento de buscar numero documento. ' ||
                              sqlerrm);
  end;

  procedure pp_busca_tasa_mone(i_movi_mone_codi in number,
                               i_movi_fech_emis in date,
                               p_mone_coti      out number) is
  begin
  
    if p_codi_mone_mmnn = i_movi_mone_codi then
      p_mone_coti := 1;
    else
      select coti_tasa
        into p_mone_coti
        from come_coti
       where coti_mone = i_movi_mone_codi
         and coti_fech = i_movi_fech_emis
         and coti_tica_codi = 2;
    end if;
  
  exception
    when no_data_found then
      p_mone_coti := null;
      raise_application_error(-20010,
                              'Cotizaciion Inexistente para la fecha del documento');
    when others then
      raise_application_error(-20010,
                              'Error al momento de buscar tasa. ' ||
                              sqlcode);
    
  end;

  procedure pp_mostrar_operacion(i_movi_oper_codi           in number,
                                 i_movi_oper_desc           out varchar2,
                                 i_movi_stoc_suma_rest      out varchar2,
                                 i_movi_stoc_afec_cost_prom out varchar2) is
  begin
  
    if i_movi_oper_codi not in (p_codi_oper_com, p_codi_oper_perd) then
      raise_application_error(-20010, 'Operacion no Valida');
    end if;
  
    select oper_desc, oper_stoc_suma_rest, oper_stoc_afec_cost_prom
      into i_movi_oper_desc,
           i_movi_stoc_suma_rest,
           i_movi_stoc_afec_cost_prom
      from come_stoc_oper
     where oper_codi = i_movi_oper_codi;
  
  exception
    when no_data_found then
      i_movi_oper_desc := null;
      raise_application_error(-20010, 'Operacion inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al momento de mostrar Operacion. ' ||
                              sqlerrm);
  end;

  procedure pp_busca_tasa_mmee(i_movi_fech_emis in date,
                               p_mone_coti      out number) is
  begin
  
    if p_codi_mone_mmnn = p_codi_mone_mmee then
      p_mone_coti := 1;
    else
      select coti_tasa
        into p_mone_coti
        from come_coti
       where coti_mone = p_codi_mone_mmee
         and coti_fech = i_movi_fech_emis
         and coti_tica_codi = 2;
    end if;
  
  exception
    when no_data_found then
      p_mone_coti := null;
      raise_application_error(-20010,
                              'Cotizaciion Inexistente para la moneda extranjera  ');
    when others then
      raise_application_error(-20010,
                              'Error al momento de buscar Tasa MMEE. ' ||
                              sqlerrm);
    
  end;

  procedure pp_mostrar_costo(p_prod_codi in number,
                             p_fech      in date,
                             p_cost_prom out number) is
  begin
    select round(prpe_cost_prom_fini_mmnn)
      into p_cost_prom
      from come_prod_peri p, come_peri e
     where p.prpe_peri_codi = peri_codi
       and p_fech between e.peri_fech_inic and e.peri_fech_fini
       and p.prpe_prod_codi = p_prod_codi;
  
  exception
    when no_data_found then
      p_cost_prom := 0;
    when others then
      raise_application_error(-20010,
                              'Error al recuperar el Costo promedio');
  end;

  procedure pp_inser_deta(i_prod_codi           in number,
                          i_deta_prod_codi_barr in number,
                          i_moco_impu           in number,
                          i_medi_codi           in number,
                          i_deta_cant_medi      in number,
                          i_deta_prec_unit      in number,
                          i_toTal               in number,
                          i_deta_cant           in number,
                          i_deta_obse           in varchar2,
                          i_indi                in varchar2,
                          i_Seq                 in number) is
  
    v_prod_codi_alfa come_prod.prod_codi_alfa%type;
    v_prod_desc      come_prod.prod_desc%type;
    v_prod_clco_codi come_prod.prod_desc%type;
    v_prod_impu_codi come_prod.prod_impu_codi%type;
  
    v_medi_desc varchar2(500);
    v_cant_prod number;
  
  begin
  
    /*raise_application_error(-20010, i_prod_codi||' => '||
    i_moco_impu||' => '||
    i_medi_codi||' => '||
    v_medi_desc||' => '||
    i_deta_cant_medi||' => '||
    i_deta_prec_unit||' => '||
    i_total||' => '||
    i_deta_prod_codi_barr||' => '||
    i_deta_obse||' => '||
    v_prod_codi_alfa||' => '||
    v_prod_desc||' => '||
    p_sess||' => '||
    fa_user||' => '||' INDI '||i_indi);*/
  
    --raise_application_error(-20010,'i_prod_codi: '||i_prod_codi);
    
    if i_indi != 'D' then
      select prod_codi_alfa, prod_desc, prod_clco_codi, prod_impu_codi
      into v_prod_codi_alfa,
           v_prod_desc,
           v_prod_clco_codi,
           v_prod_impu_codi
      from come_prod
     where prod_codi = i_prod_codi
       and nvl(prod_indi_inac, 'N') = 'N';
  
     if v_prod_impu_codi is null then
       v_prod_impu_codi := p_codi_impu_exen;
     end if;
  
      select ltrim(rtrim(medi_desc_abre))
        into v_medi_desc
        from come_unid_medi
       where medi_codi = i_medi_codi
         and medi_codi in (select coba_medi_codi
                             from come_prod_coba_deta
                            where coba_prod_codi = i_prod_codi);
    end if;
    
    if i_indi = 'N' then
    
      select count(*)
        into v_cant_prod
        from come_tabl_auxi
       where taax_sess = p_sess
         and taax_user = fa_user
         and taax_n001 = i_prod_codi;
    
      if v_cant_prod <> 0 then
        raise_application_error(-20010,
                                'Producto: Cod. ' || i_prod_codi || ' ' ||
                                v_prod_desc ||
                                ' duplicado asegurese de no introducir mas de una vez el mismo codigo!');
      end if;
    
      insert into come_tabl_auxi
        (taax_n001,
         taax_n002,
         taax_n003,
         taax_c001,
         taax_n004,
         taax_n005,
         taax_n006,
         taax_n007,
         taax_c002,
         taax_n008,
         taax_n009,
         taax_c003,
         taax_sess,
         taax_user,
         taax_seq)
      values
        (i_prod_codi,
         i_moco_impu,
         i_medi_codi,
         v_medi_desc,
         i_deta_cant_medi,
         i_deta_prec_unit,
         i_total,
         i_deta_prod_codi_barr,
         i_deta_obse,
         v_prod_codi_alfa,
         i_deta_cant,
         v_prod_desc,
         p_sess,
         fa_user,
         seq_come_tabl_auxi.nextval);
    
    elsif i_indi = 'U' then
    
      update come_tabl_auxi
         set taax_n001 = i_prod_codi,
             taax_n002 = i_moco_impu,
             taax_n003 = i_medi_codi,
             taax_c001 = v_medi_desc,
             taax_n004 = i_deta_cant_medi,
             taax_n005 = i_deta_prec_unit,
             taax_n006 = i_total,
             taax_n007 = i_deta_prod_codi_barr,
             taax_c002 = i_deta_obse,
             taax_n008 = v_prod_codi_alfa,
             taax_n009 = i_deta_cant,
             taax_c003 = v_prod_desc,
             taax_sess = p_sess,
             taax_user = fa_user
       where taax_seq = i_seq;
    
    elsif i_indi = 'D' then
    
      delete from come_tabl_auxi where taax_seq = i_seq;
    
    end if;
  
  end;

  procedure pp_buscar_prod_cod_barr(i_prod_codi_alfa      in number,
                                    i_moco_medi_codi      out number,
                                    i_deta_prod_codi_barr out number,
                                    i_coba_fact_conv      out number) is
    v_indi_inac char(1);
  begin
  
    select nvl(prod_indi_inac, 'N'),
           coba_medi_codi,
           coba_codi_barr,
           coba_fact_conv
      into v_indi_inac,
           i_moco_medi_codi,
           i_deta_prod_codi_barr,
           i_coba_fact_conv
      from come_prod, come_prod_coba_deta
     where upper(ltrim(rtrim(coba_codi_barr))) =
           upper(ltrim(rtrim(i_prod_codi_alfa)))
       and prod_codi = coba_prod_codi;
  
    if v_indi_inac = 'S' then
      raise_application_error(-20010,
                              'El producto se encuentra inactivo!!');
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'A ocurrido un error al momento de buscar Prod. Codi. Barra. ' ||
                              sqlcode);
  end;

  procedure pp_mostrar_codi_barr(i_deta_prod_codi_barr in number,
                                 i_deta_prod_codi      in number,
                                 i_moco_medi_codi      out come_prod_coba_deta.coba_medi_codi%type,
                                 i_coba_desc           out come_prod_coba_deta.coba_Desc%type,
                                 i_coba_fact_conv      out come_prod_coba_deta.coba_fact_conv%type) is
    v_prod_codi      number;
    v_moco_medi_codi come_prod_coba_deta.coba_medi_codi%type;
    v_coba_desc      come_prod_coba_deta.coba_Desc%type;
    v_coba_fact_conv come_prod_coba_deta.coba_fact_conv%type;
  
  begin
  
    /*raise_application_error(-20010,'i_deta_prod_codi_barr: '||i_deta_prod_codi_barr ||' ; '||
    'i_deta_prod_codi: '||i_deta_prod_codi
    );*/
    
    select coba_prod_codi, coba_medi_codi, coba_Desc, coba_fact_conv
      into v_prod_codi, v_moco_medi_codi, v_coba_desc, v_coba_fact_conv
      from come_prod_coba_deta
     where COBA_CODI_BARR = to_char(i_deta_prod_codi_barr);
    
    if v_prod_codi <> i_deta_prod_codi then
      raise_application_error(-20010,'El Codigo de barras no pertenece al producto seleecionado');
    end if;
  
    i_moco_medi_codi := v_moco_medi_codi;
    i_coba_desc      := v_coba_desc;
    i_coba_fact_conv := v_coba_fact_conv;
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Debe seleccionar el Codigo de barras');
    when too_many_rows then
      raise_application_error(-20010,
                              'Existe mas de un item con el codigo de barras');
    
  end;

  procedure pp_mostrar_medi(p_codi           in number,
                            i_deta_prod_codi in number,
                            p_desc           out varchar2) is
  begin
  
    select ltrim(rtrim(medi_desc_abre))
      into p_desc
      from come_unid_medi
     where medi_codi = p_codi
       and medi_codi in
           (select coba_medi_codi
              from come_prod_coba_deta
             where coba_prod_codi = i_deta_prod_codi);
  
  exception
    when no_data_found then
      p_desc := 'Unidad de medida inexistente para el producto seleccionado!';
    when others then
      raise_application_error(-20010,
                              'Error en momento de busca Unidad de medida. ' ||
                              sqlerrm);
  end;

  procedure pp_muestra_desc_mone(p_codi_mone in number,
                                 p_deci_mmee out number) is
  begin
    select mone_cant_deci
      into p_deci_mmee
      from come_mone
     where mone_codi = p_codi_mone;
  
  exception
    when others then
      raise_application_error(-20010,
                              'Error al momento de mostrar moneda.');
    
  end;

  /*****************INSERCIONES  ******************/
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
       movi_empl_codi
       --,movi_base
       )
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
       p_movi_empl_codi
       --,p_codi_base
       );
  
  end;

  procedure pp_insert_come_movi_prod_deta(p_deta_movi_codi         in number,
                                          p_deta_nume_item         in number,
                                          p_deta_impu_codi         in number,
                                          p_deta_prod_codi         in number,
                                          p_deta_cant_medi         in number,
                                          p_deta_cant              in number,
                                          p_deta_obse              in varchar2,
                                          p_deta_medi_codi         in number,
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
                                          p_deta_indi_venc         in varchar2) is
  begin
    insert into come_movi_prod_deta
      (deta_movi_codi,
       deta_nume_item,
       deta_impu_codi,
       deta_prod_codi,
       deta_cant_medi,
       deta_cant,
       deta_obse,
       deta_medi_codi,
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
       --deta_base,
       deta_indi_venc,
       deta_empr_codi)
    values
      (p_deta_movi_codi,
       p_deta_nume_item,
       p_deta_impu_codi,
       p_deta_prod_codi,
       p_deta_cant_medi,
       p_deta_cant,
       p_deta_obse,
       p_deta_medi_codi,
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
       --p_codi_base,
       p_deta_indi_venc,
       fa_empresa);
  end;

  /************** REPORTES  ******************/

  procedure pp_genera_reporte is
  
  
    NOMBRE       VARCHAR2(50);
    PARAMETROS   CLOB;
    CONTENEDORES CLOB;
  begin
      
    insert into come_tabl_auxi
      (taax_c001,
       taax_c002,
       taax_c003,
       taax_n001,
       taax_c004,
       taax_n002,
       taax_c005,
       taax_n003,
       taax_c006,
       
       taax_n004,
       taax_c007,
       taax_n005,
       taax_n006,
       taax_c008,
       taax_c009,
       taax_n007,
       taax_n008,
       taax_c010,
       
       taax_seq,
       taax_sess,
       taax_user)
    
      select
      --cabecera
       m.movi_nume,
       m.movi_fech_emis,
       m.movi_obse,
       o.oper_codi,
       o.oper_desc,
       s.sucu_codi,
       s.sucu_desc,
       d.depo_codi,
       d.depo_desc,
       --detalles  
       d.deta_nume_item,
       um.medi_desc_abre,
       d.deta_cant,
       d.deta_cant_medi,
       p.prod_codi_alfa,
       p.prod_desc,
       d.deta_prec_unit,
       nvl(d.deta_impo_mone, 0) + nvl(d.deta_iva_mmee, 0) impo_deta,
       d.deta_obse,
       
       seq_come_tabl_auxi.nextval,
       p_sess,
       fa_user
       
        from come_movi           m,
             come_stoc_oper      o,
             come_sucu           s,
             come_depo           d,
             come_movi_prod_deta d,
             come_prod           p,
             come_unid_medi      um
       where m.movi_oper_codi = o.oper_codi
         and m.movi_sucu_codi_orig = s.sucu_codi
         and m.movi_depo_codi_orig = d.depo_codi
         and d.depo_sucu_codi = s.sucu_codi
            
         and m.movi_codi = d.deta_movi_codi
         and d.deta_prod_codi = p.prod_codi
         and d.deta_medi_codi = um.medi_codi
         and m.movi_codi = v_movi_codi;
  
  
    nombre       := 'I020260';
    contenedores := 'p_app_session:p_app_user';
    parametros   := '' || (p_sess) || ':' || (fa_user)||'';
  
    delete from come_parametros_report where usuario = fa_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (parametros, fa_user, nombre, 'pdf', contenedores);
  
  
  end pp_genera_reporte;

  ---------------------------------------------------------------------------------------
  procedure pp_clear_come_tabl_auxi(i_session in number) is
  
  begin
    
    delete from come_tabl_auxi 
    where taax_sess = i_session
      and taax_user = fa_user;
      
  exception
    when others then
      raise_application_error(-20010,'Error al vaciar la grilla de detalles!. ');
  end pp_clear_come_tabl_auxi;
  
  ---------------------------------------------------------------------------------------
  function fp_get_depo_sucu(i_filtro in varchar2) return varchar2 is
  
    v_return varchar2(1000) := null;
  
  begin
  
    -- Busqueda por codigo alternativo
    begin
      select  depo_codi
         into v_return
         from come_depo d, come_sucu
        where depo_sucu_codi = sucu_codi
          and d.depo_codi_alte = i_filtro
          and d.depo_empr_codi = fa_empresa;
      return v_return;
    exception
      when no_data_found then
        null;
      when invalid_number then
        null;
      when others then
        return null;
    end;
  
    -- Busqueda por descripcion
    begin
      select  depo_codi
         into v_return
         from come_depo d, come_sucu
        where depo_sucu_codi = sucu_codi
          and d.depo_empr_codi = fa_empresa
          and upper(d.depo_desc) like '%' || upper(i_filtro) || '%';
      return v_return;
    exception
      when no_data_found then
        null;
      when others then
        return null;
    end;
  
    return null;
  
  end fp_get_depo_sucu;

  ---------------------------------------------------------------------------------------
  function fp_get_prod_s_pag_70(i_filtro in varchar2,
                                i_depo_codi in number) return varchar2 is
  
    v_return varchar2(1000) := null;
  
  begin
  
    -- Busqueda por codigo alternativo
    begin
      select p.prod_codi
        into v_return
        from come_prod           p,
             come_prod_depo      e,
             come_marc           m
       where nvl(p.prod_indi_inac, 'N') = 'N'
         and p.prod_codi = e.prde_prod_codi(+)
         and p.prod_marc_codi = m.marc_codi (+)
         and nvl(prde_Cant_venc,0) > 0
         and e.prde_depo_codi(+) = i_depo_codi
         and p.prod_codi_alfa = to_char(i_filtro)
         and p.prod_empr_codi = fa_empresa;
      return v_return;
    exception
      when no_data_found then
        null;
      when invalid_number then
        null;
      when others then
        return null;
    end;
  
    -- Busqueda por descripcion
    begin
      select p.prod_codi
        into v_return
        from come_prod           p,
             come_prod_depo      e,
             come_marc           m
       where nvl(p.prod_indi_inac, 'N') = 'N'
         and p.prod_codi = e.prde_prod_codi(+)
         and p.prod_marc_codi = m.marc_codi (+)
         and nvl(prde_Cant_venc,0) > 0
         and e.prde_depo_codi(+) = i_depo_codi
         and p.prod_empr_codi = fa_empresa
         and upper(p.prod_desc) like '%' || upper(i_filtro) || '%';
      return v_return;
    exception
      when no_data_found then
        null;
      when others then
        return null;
    end;
  
    return null;
  
  end fp_get_prod_s_pag_70;

  ---------------------------------------------------------------------------------------
  function fp_get_prod_pag_70(i_filtro in varchar2) return varchar2 is
  
    v_return varchar2(1000) := null;
  
  begin
  
    -- Busqueda por codigo alternativo
    begin
      select p.prod_codi
        into v_return
        from come_prod           p,
             come_prod_depo      e,
             come_marc           m
       where nvl(p.prod_indi_inac, 'N') = 'N'
         and p.prod_codi = e.prde_prod_codi(+)
         and p.prod_marc_codi = m.marc_codi (+)
         and p.prod_codi_alfa = to_char(i_filtro)
         and p.prod_empr_codi = fa_empresa;
      return v_return;
    exception
      when no_data_found then
        null;
      when invalid_number then
        null;
      when others then
        return null;
    end;
  
    -- Busqueda por descripcion
    begin
      select p.prod_codi
        into v_return
        from come_prod           p,
             come_prod_depo      e,
             come_marc           m
       where nvl(p.prod_indi_inac, 'N') = 'N'
         and p.prod_codi = e.prde_prod_codi(+)
         and p.prod_marc_codi = m.marc_codi (+)
         and p.prod_empr_codi = fa_empresa
         and upper(p.prod_desc) like '%' || upper(i_filtro) || '%';
      return v_return;
    exception
      when no_data_found then
        null;
      when others then
        return null;
    end;
  
    return null;
  
  end fp_get_prod_pag_70;

end I020260;
