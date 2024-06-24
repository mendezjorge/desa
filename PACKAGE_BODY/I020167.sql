
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020167" is

  p_codi_timo_contr varchar2(500) := to_number(fa_busc_para('p_codi_timo_contr'));
  p_codi_timo_reem  varchar2(500) := to_number(fa_busc_para('p_codi_timo_reem'));

  p_codi_clie_espo varchar2(500) := to_number(fa_busc_para('p_codi_clie_espo'));
  p_codi_prov_espo varchar2(500) := to_number(fa_busc_para('p_codi_prov_espo'));
  p_codi_base      varchar2(500) := pack_repl.fa_devu_codi_base;
  p_fech_inic      date;
  p_fech_fini      date;

  p_indi_vali_repe_cheq          varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_vali_repe_cheq')));
  p_indi_most_mens_sali          varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_most_mens_sali')));
  p_codi_timo_rete_emit          varchar2(500) := to_number(fa_busc_para('p_codi_timo_rete_emit'));
  p_codi_timo_rere               varchar2(500) := to_number(fa_busc_para('p_codi_timo_rere'));
  p_codi_timo_orde_pago          varchar2(500) := to_number(fa_busc_para('p_codi_timo_orde_pago'));
  p_codi_timo_depo_banc          varchar2(500) := to_number(fa_busc_para('p_codi_timo_depo_banc'));
  p_codi_timo_adlr               varchar2(500) := to_number(fa_busc_para('p_codi_timo_adlr'));
  p_codi_timo_pcor               varchar2(500) := to_number(fa_busc_para('p_codi_timo_pcor'));
  p_codi_timo_pago_pres          varchar2(500) := to_number(fa_busc_para('p_codi_timo_pago_pres'));
  p_indi_moti_anul_obli          varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_moti_anul_obli')));
  p_indi_perm_borr_reci_plan_cer varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_perm_borr_reci_plan_cer')));

  p_codi_timo_rcnadlr varchar2(500) := to_number(fa_busc_para('p_codi_timo_rcnadlr'));

  p_indi_perm_fech_futu_dbcr varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_perm_fech_futu_dbcr')));

  type r_bcab is record(
    
    prod_codi           number,
    s_cant              number,
    prod_cost_prom_tota number,
    prod_cost_prom      number,
    prod_cost_prom_actu number,
    indi_arma_desa      varchar2(10),
    
    movi_codi      come_movi.movi_codi%type,
    movi_nume      come_movi.movi_nume%type,
    movi_timo_codi come_movi.movi_timo_codi%type,
    
    movi_clpr_codi      come_movi.movi_clpr_codi%type,
    movi_clpr_desc      come_movi.movi_clpr_desc%type,
    movi_nume_timb      come_movi.movi_nume_timb%type,
    movi_clpr_dire      come_movi.movi_clpr_dire%type,
    movi_clpr_tele      come_movi.movi_clpr_tele%type,
    movi_clpr_ruc       come_movi.movi_clpr_ruc%type,
    movi_fech_emis      come_movi.movi_fech_emis%type,
    movi_fech_oper      come_movi.movi_fech_oper%type,
    movi_empl_codi      come_movi.movi_empl_codi%type,
    movi_oper_codi      come_movi.movi_oper_codi%type,
    movi_depo_codi_orig come_movi.movi_depo_codi_orig%type,
    movi_depo_codi_dest come_movi.movi_depo_codi_dest%type,
    movi_obse           come_movi.movi_obse%type,
    movi_mone_codi      come_movi.movi_mone_codi%type,
    movi_tasa_mone      come_movi.movi_tasa_mone%type,
    movi_tasa_mmee      come_movi.movi_tasa_mmee%type,
    movi_sucu_codi_orig come_movi.movi_sucu_codi_orig%type,
    movi_sucu_codi_dest come_movi.movi_sucu_codi_dest%type,
    movi_fech_grab      come_movi.movi_fech_grab%type,
    movi_user           come_movi.movi_user%type,
    movi_grav10_ii_mone come_movi.movi_grav10_ii_mone%type,
    movi_grav5_ii_mone  come_movi.movi_grav5_ii_mone%type,
    movi_exen_mone      come_movi.movi_exen_mone%type,
    movi_grav10_ii_mmnn come_movi.movi_grav10_ii_mmnn%type,
    movi_grav5_ii_mmnn  come_movi.movi_grav5_ii_mmnn%type,
    movi_exen_mmnn      come_movi.movi_exen_mmnn%type,
    movi_sald_mone      come_movi.movi_sald_mone%type,
    movi_sald_mmnn      come_movi.movi_sald_mmnn%type,
    movi_grav_mone      come_movi.movi_grav_mone%type,
    movi_grav_mmnn      come_movi.movi_grav_mmnn%type,
    movi_ortr_codi      come_movi.movi_ortr_codi%type,
    movi_orpa_codi      come_movi.movi_orpa_codi%type,
    movi_soco_codi      come_movi.movi_soco_codi%type,
    tico_codi           number,
    movi_indi_cobr_dife come_movi.movi_indi_cobr_dife%type,
    movi_rrhh_movi_codi come_movi.movi_rrhh_movi_codi%type,
    movi_apci_codi      come_movi.movi_apci_codi%type,
    movi_codi_padr      come_movi.movi_codi_padr%type,
    
    movi_iva_mone come_movi.movi_iva_mone%type,
    movi_iva_mmnn come_movi.movi_iva_mmnn%type);

  bcab r_bcab;

  v_erro_codi number; -- codigo de error de retorno
  v_erro_desc varchar2(5000); -- descripcion de error de retorno    
  v_count     number;
  v_cant_regi number;
  salir       exception;

  ta_movi_anul pack_anul.tt_movi_anul;

  /**********************************************************************/
  /*************** proceso de anulacion  y borrado **********************/
  /**********************************************************************/

  procedure pp_ot_estado(i_ortr_codi in number, i_movi_oper_codi in number) is
    v_oper_codi number;
  begin
    -- validar que sea sal_prod, dev_prod
    select t.oper_codi
      into v_oper_codi
      from come_stoc_oper t
     where t.oper_codi in (13, 12)
       and t.oper_codi = i_movi_oper_codi;
  
    update come_orde_trab o
       set o.ortr_fech_liqu = null, o.ortr_esta = 'P'
     where ortr_codi = i_ortr_codi;
  exception
    when no_data_found then
      null;
    when others then
      null;
  end pp_ot_estado;

  procedure pp_proc_borr(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
  
    cursor c_deta_movi is
      select movi_codi,
             movi_nume,
             movi_timo_codi,
             movi_clpr_codi,
             movi_clpr_desc,
             movi_nume_timb,
             movi_clpr_dire,
             case
               when movi_clpr_ruc like '%-%' then
                movi_clpr_ruc
               else
                ltrim(to_char(movi_clpr_ruc, '999G999G999G999G999G999G990'))
             end movi_clpr_ruc,
             movi_fech_emis,
             movi_fech_oper,
             movi_empl_codi,
             oper_desc,
             oper_codi,
             do.depo_codi movi_depo_codi_orig,
             dd.depo_desc movi_depo_codi_dest,
             movi_obse,
             movi_mone_codi,
             movi_tasa_mone,
             movi_tasa_mmee,
             movi_sucu_codi_orig,
             movi_sucu_codi_dest,
             movi_fech_grab,
             movi_user,
             movi_grav10_ii_mone,
             movi_grav5_ii_mone,
             movi_exen_mone,
             movi_grav10_ii_mmnn,
             movi_grav5_ii_mmnn,
             movi_exen_mmnn,
             movi_sald_mone,
             movi_sald_mmnn,
             nvl(movi_grav10_ii_mone, 0) + nvl(movi_grav5_ii_mone, 0) movi_grav_mone,
             nvl(movi_grav10_ii_mone, 0) + nvl(movi_grav5_ii_mone, 0) movi_grav_mmnn,
             movi_ortr_codi,
             movi_orpa_codi,
             movi_soco_codi,
             movi_empr_codi,
             movi_inve_codi,
             movi_cuen_codi,
             movi_codi_padr,
             nvl(movi_iva10_mmnn, 0) + nvl(movi_iva5_mmnn, 0) movi_iva_mmnn,
             nvl(movi_iva10_mone, 0) + nvl(movi_iva5_mone, 0) movi_iva_mone,
             movi_grav_mmee,
             movi_exen_mmee,
             movi_iva_mmee,
             movi_sald_mmee,
             movi_stoc_suma_rest,
             movi_emit_reci,
             movi_afec_sald,
             movi_dbcr,
             movi_stoc_afec_cost_prom,
             movi_indi_iva_incl,
             movi_orpe_codi,
             timo_codi tico_codi,
             movi_indi_cobr_dife,
             movi_rrhh_movi_codi,
             movi_apci_codi,
             movi_inmu_codi,
             movi_inmu_esta_ante,
             clpr_codi_alte || '-' || clpr_desc cliente,
             empl_desc,
             mone_desc,
             timo_desc,
             movi_clpr_tele,
             movi_oper_codi
        from come_movi,
             come_tipo_movi,
             come_clie_prov,
             come_empl,
             come_mone,
             come_depo      dd,
             come_depo      do,
             come_sucu      sd,
             come_sucu      so,
             come_stoc_oper
       where movi_timo_codi = timo_codi(+)
         and movi_clpr_codi = clpr_codi(+)
         and movi_empl_codi = empl_codi(+)
         and movi_mone_codi = mone_codi(+)
         and movi_depo_codi_dest = dd.depo_codi(+)
         and movi_depo_codi_orig = do.depo_codi(+)
         and movi_oper_codi = oper_codi(+)
         and movi_sucu_codi_orig = so.sucu_codi(+)
         and movi_sucu_codi_dest = sd.sucu_codi(+)
         and movi_codi = i_movi_codi;
  
  begin
  
    if p_indi_moti_anul_obli = 'S' then
      if v('P34_ANUL_OBSE') is null then
        pp_get_erro(i_resp_codi      => 60,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_codi := 60;
      
      end if;
    end if;
  
    setitem('P34_PROGRESS_BAR_PORC', 100);
    setitem('P34_PROGRESS_BAR_DESC', 'Borrando movimiento..');
  
    for x in c_deta_movi loop
    
      ta_movi_anul(1).movi_codi := x.movi_codi;
      ta_movi_anul(1).movi_clpr_codi := x.movi_clpr_codi;
      ta_movi_anul(1).movi_nume := x.movi_nume;
      ta_movi_anul(1).movi_nume_timb := x.movi_nume_timb;
      ta_movi_anul(1).movi_fech_emis := x.movi_fech_emis;
      ta_movi_anul(1).movi_timo_codi := x.movi_timo_codi;
      ta_movi_anul(1).movi_oper_codi := x.movi_oper_codi;
      ta_movi_anul(1).movi_empr_codi := x.movi_empr_codi;
      ta_movi_anul(1).movi_sucu_codi_orig := x.movi_sucu_codi_orig;
      ta_movi_anul(1).movi_inve_codi := x.movi_inve_codi;
      ta_movi_anul(1).movi_soco_codi := x.movi_soco_codi;
      ta_movi_anul(1).movi_depo_codi_orig := x.movi_depo_codi_orig;
      ta_movi_anul(1).movi_sucu_codi_dest := x.movi_sucu_codi_dest;
      ta_movi_anul(1).movi_depo_codi_dest := x.movi_depo_codi_dest;
      ta_movi_anul(1).movi_cuen_codi := x.movi_cuen_codi;
      ta_movi_anul(1).movi_mone_codi := x.movi_mone_codi;
      ta_movi_anul(1).movi_fech_grab := x.movi_fech_grab;
      ta_movi_anul(1).movi_user := x.movi_user;
      ta_movi_anul(1).movi_codi_padr := x.movi_codi_padr;
      ta_movi_anul(1).movi_tasa_mone := x.movi_tasa_mone;
      ta_movi_anul(1).movi_tasa_mmee := x.movi_tasa_mmee;
      ta_movi_anul(1).movi_grav_mmnn := x.movi_grav_mmnn;
      ta_movi_anul(1).movi_exen_mmnn := x.movi_exen_mmnn;
      ta_movi_anul(1).movi_iva_mmnn := x.movi_iva_mmnn;
      ta_movi_anul(1).movi_grav_mone := x.movi_grav_mone;
      ta_movi_anul(1).movi_exen_mone := x.movi_exen_mone;
      ta_movi_anul(1).movi_iva_mone := x.movi_iva_mone;
      ta_movi_anul(1).movi_grav_mmee := x.movi_grav_mmee;
      ta_movi_anul(1).movi_exen_mmee := x.movi_exen_mmee;
      ta_movi_anul(1).movi_iva_mmee := x.movi_iva_mmee;
      ta_movi_anul(1).movi_obse := x.movi_obse;
      ta_movi_anul(1).movi_sald_mmnn := x.movi_sald_mmnn;
      ta_movi_anul(1).movi_sald_mone := x.movi_sald_mone;
      ta_movi_anul(1).movi_sald_mmee := x.movi_sald_mmee;
      ta_movi_anul(1).movi_stoc_suma_rest := x.movi_stoc_suma_rest;
      ta_movi_anul(1).movi_clpr_dire := x.movi_clpr_dire;
      ta_movi_anul(1).movi_clpr_tele := x.movi_clpr_tele;
      ta_movi_anul(1).movi_clpr_ruc := x.movi_clpr_ruc;
      ta_movi_anul(1).movi_clpr_desc := x.movi_clpr_desc;
      ta_movi_anul(1).movi_emit_reci := x.movi_emit_reci;
      ta_movi_anul(1).movi_afec_sald := x.movi_afec_sald;
      ta_movi_anul(1).movi_dbcr := x.movi_dbcr;
      ta_movi_anul(1).movi_stoc_afec_cost_prom := x.movi_stoc_afec_cost_prom;
      ta_movi_anul(1).movi_empl_codi := x.movi_empl_codi;
      ta_movi_anul(1).movi_indi_iva_incl := x.movi_indi_iva_incl;
      ta_movi_anul(1).movi_orpe_codi := x.movi_orpe_codi;
      ta_movi_anul(1).movi_ortr_codi := x.movi_ortr_codi;
      ta_movi_anul(1).movi_orpa_codi := x.movi_orpa_codi;
      ta_movi_anul(1).ortr_esta := v('P34_ORTR_ESTA');
      ta_movi_anul(1).apli_codi := v('P34_APLI_CODI');
    
      ta_movi_anul(1).indi_anul := v('P34_MOVI_INDI_ANUL');
      ta_movi_anul(1).obse_anul := v('P34_ANUL_OBSE');
      ta_movi_anul(1).indi_borr_hijos := v('P34_INDI_BORR_DOCU_HIJO');
    
      ta_movi_anul(1).tico_codi := x.tico_codi;
      ta_movi_anul(1).movi_inmu_codi := x.movi_inmu_codi;
      ta_movi_anul(1).movi_inmu_esta_ante := x.movi_inmu_esta_ante;
    
    end loop;
  
    --pl_me('aca'||ta_movi_anul(1).movi_ortr_codi);
  
    -- insert into come_concat (campo1, otro) values (v('p34_movi_indi_anul')||' - '||v('p34_anul_obse')||' - '||v('p34_indi_borr_docu_hijo')||' - '||v('p34_ortr_esta')||' - '||v('p34_apli_codi'), 'valoreeees');
    pp_ot_estado(i_ortr_codi      => ta_movi_anul(1).movi_ortr_codi,
                 i_movi_oper_codi => ta_movi_anul(1).movi_oper_codi);
  
    pack_anul.pa_borra_movi(ta_movi_anul);
    ta_movi_anul.delete;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      raise_application_error(-20010,
                              dbms_utility.format_error_backtrace ||
                              ' NO SE PUDO BORRAR EL REGISTRO ' || sqlerrm);
    
  end pp_proc_borr;

  /**********************************************************************/
  /******************* c a r g a  de  d a t o s *************************/
  /**********************************************************************/

  procedure pp_mues_asie_nume(p_codi in number, p_nume out number) is
  
  begin
  
    select asie_nume into p_nume from come_asie where asie_codi = p_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Numero de asiento inexistente!');
  end pp_mues_asie_nume;

  procedure pp_most_op(p_codi in number, p_nume out varchar2) is
  begin
    select orpa_nume
      into p_nume
      from come_orde_pago
     where orpa_codi = p_codi;
  
  exception
    when no_data_found then
      p_nume := null;
  end pp_most_op;

  procedure pp_most_apli_codi(p_movi_codi in number,
                              p_apli_codi out number) is
  begin
  
    select apli_codi
      into p_apli_codi
      from come_apli_cost
     where apli_movi_codi = p_movi_codi;
  
  exception
    when no_data_found then
      null;
    when too_many_rows then
      raise_application_error(-20010, 'Codigo duplicado en Costo!');
    
  end pp_most_apli_codi;

  /**********************************************************************/
  /*************************   validaciones  ****************************/
  /**********************************************************************/

  --detalle de importes...
  procedure pp_vali_impo(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
  
    v_caja_codi      number;
    v_caja_cuen_codi number;
    v_caja_fech      date;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 5);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando cierre de caja..');
  
    select max(d.moim_caja_codi)
      into v_caja_codi
      from come_movi_impo_deta d
     where d.moim_movi_codi = i_movi_codi
       and d.moim_caja_codi is not null;
  
    if v_caja_codi is not null then
    
      select c.caja_cuen_codi, c.caja_fech
        into v_caja_cuen_codi, v_caja_fech
        from come_cier_caja c
       where c.caja_codi = v_caja_codi;
    
      -- este solo tiene que ser un mensaje
      pp_get_erro(i_resp_codi      => 1,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 1;
      v_erro_desc := replace(replace(v_erro_desc,
                                     'P_FECHA',
                                     to_char(v_caja_fech, 'dd-mm-yyyy')),
                             'P_CAJA',
                             v_caja_cuen_codi);
    
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when no_data_found then
      null;
  end;

  --validar bloqueo de logistic
  procedure pp_vali_logi(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
    v_cont number;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 6);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando preparacion de entregas..');
  
    select count(*)
      into v_cont
      from come_movi_entr_deta
     where deta_movi_codi = i_movi_codi
       and nvl(deta_indi_impr_logi, 'N') = 'S'
       and nvl(deta_indi_soli_anul, 'N') = 'N';
  
    if v_cont > 0 then
    
      pp_get_erro(i_resp_codi      => 2,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 2;
      raise salir;
    
    end if;
  
    select count(*)
      into v_cont
      from come_movi_entr_deta
     where deta_movi_codi = i_movi_codi
       and nvl(deta_indi_impr_logi, 'N') = 'S'
       and nvl(deta_indi_soli_anul, 'N') = 'P';
  
    if v_cont > 0 then
    
      pp_get_erro(i_resp_codi      => 2,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 2;
    
    end if;
  
  exception
    when others then
      pp_get_erro(i_resp_codi      => 3,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      o_resp_codi := 3;
      o_resp_desc := v_erro_desc;
    
  end pp_vali_logi;

  -- validamos cierre de os
  procedure pp_vali_cier_os(i_movi_codi in number,
                            o_resp_codi out number,
                            o_resp_desc out varchar2) is
    v_cont      number;
    v_orse_nume varchar2(20);
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 8);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando cierre de OS..');
  
    select s.orse_nume_char
      into v_orse_nume
      from come_orde_serv s, come_orde_serv_fact f
     where s.orse_codi = f.oscl_orse_codi
       and s.orse_esta <> 'P'
       and f.oscl_movi_codi = i_movi_codi;
  
    if v_orse_nume is not null then
    
      pp_get_erro(i_resp_codi      => 4,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 4;
      v_erro_desc := replace(v_erro_desc, 'P_NRO_OS', v_orse_nume);
      raise salir;
    
    end if;
  
  exception
    when no_data_found then
      null;
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      pp_get_erro(i_resp_codi      => 5,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 5;
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
  end;

  --validar modulo de rrhh   
  procedure pp_vali_modu_rrhh(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    v_movi_rrhh_movi_codi number;
    v_movi_timo_codi      number;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 10);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Modulo RRHH..');
  
    select movi_timo_codi, movi_rrhh_movi_codi
      into v_movi_timo_codi, v_movi_rrhh_movi_codi
      from come_movi,
           come_tipo_movi,
           come_clie_prov,
           come_empl,
           come_mone,
           come_depo      dd,
           come_depo      do,
           come_sucu      sd,
           come_sucu      so,
           come_stoc_oper
     where movi_timo_codi = timo_codi(+)
       and movi_clpr_codi = clpr_codi(+)
       and movi_empl_codi = empl_codi(+)
       and movi_mone_codi = mone_codi(+)
       and movi_depo_codi_dest = dd.depo_codi(+)
       and movi_depo_codi_orig = do.depo_codi(+)
       and movi_oper_codi = oper_codi(+)
       and movi_sucu_codi_orig = so.sucu_codi(+)
       and movi_sucu_codi_dest = sd.sucu_codi(+)
       and movi_codi = i_movi_codi;
  
    if v_movi_rrhh_movi_codi is not null or v_movi_timo_codi = 33 then
    
      pp_get_erro(i_resp_codi      => 6,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 6;
      raise salir;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      pp_get_erro(i_resp_codi      => 9,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 9;
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
  end pp_vali_modu_rrhh;

  --validando pago de impuestos inmobiliarios.         
  procedure pp_vali_impu_inmo(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    v_cont number;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 12);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando Pago de Impuestos Inmobiliarios..');
  
    select count(*)
      into v_cont
      from roga_prof_imin
     where prim_movi_codi = i_movi_codi;
  
    if v_cont > 0 then
    
      pp_get_erro(i_resp_codi      => 7,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 7;
      raise salir;
    
    end if;
  
  exception
    when no_data_found then
      null;
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      pp_get_erro(i_resp_codi      => 8,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 9;
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
  end;

  --validando post de ventas..
  procedure pp_vali_movi_post(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
  
    v_movi_timo_codi number;
    v_movi_apci_codi number;
    v_apci_esta      come_aper_cier_caja.apci_esta%type;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 14);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando post de ventas..');
  
    select movi_timo_codi, movi_apci_codi
      into v_movi_timo_codi, v_movi_apci_codi
      from come_movi, come_tipo_movi
     where movi_timo_codi = timo_codi(+)
       and movi_codi = i_movi_codi;
  
    if v_movi_timo_codi = 27 and v_movi_apci_codi is not null then
    
      pp_get_erro(i_resp_codi      => 10,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 10;
      raise salir;
    
    end if;
  
    if v_movi_timo_codi = 28 and v_movi_apci_codi is not null then
    
      select apci.apci_esta
        into v_apci_esta
        from come_aper_cier_caja apci
       where apci_codi = v_movi_apci_codi;
    
      if nvl(v_apci_esta, 'P') = 'C' then
      
        pp_get_erro(i_resp_codi      => 11,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_codi := 11;
        raise salir;
      
      end if;
    end if;
  
    if v_movi_apci_codi is not null then
    
      select apci.apci_esta
        into v_apci_esta
        from come_aper_cier_caja apci
       where apci_codi = v_movi_apci_codi;
    
      if nvl(v_apci_esta, 'P') = 'C' then
      
        pp_get_erro(i_resp_codi      => 11,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_codi := 11;
        raise salir;
      
      end if;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    
  end pp_vali_movi_post;

  --validando fecha..  
  procedure pp_vali_fech(i_fech      in date,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 15);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando fecha..');
  
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
  
    if i_fech not between p_fech_inic and p_fech_fini then
      pp_get_erro(i_resp_codi      => 12,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_desc := replace(replace(v_erro_desc, 'P_FECHA1', p_fech_inic),
                             'P_FECHA2',
                             p_fech_fini);
      v_erro_codi := 12;
    
      raise salir;
    
    end if;
  
  exception
    when salir then
      o_resp_desc := v_erro_desc;
      o_resp_codi := v_erro_codi;
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end pp_vali_fech;

  --validando factura electronica..
  procedure pp_vali_fact_elec(i_tipo_movi in number,
                              i_fech      in date,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    v_count  number;
    v_estado varchar2(100);
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 17);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Factura Electronica..');
  
    if i_tipo_movi in (1, 2, 9) /*and gen_user <> 'skn' */
     then
    
      begin
        select count(*), nvl(f.elfa_estado, 'S')
          into v_count, v_estado
          from come_elec_fact f
         where f.elfa_come_mov_cod = v('P34_MOVI_CODI_I')
         group by f.elfa_estado;
      exception
        when no_data_found then
          v_count := 0;
        when too_many_rows then
          v_count := 1;
      end;
    
      if v_count > 0 and v_estado <> 'Rechazado' then
        if i_fech < trunc(sysdate) - 2 then
          pp_get_erro(i_resp_codi      => 13,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          v_erro_codi := 13;
        
          raise salir;
        
          raise salir;
        end if;
      
      elsif v_count > 0 and v_estado = 'Rechazado' and
            v('P34_MOVI_INDI_INUTILIZACION') = 'S' then
      
        begin
          -- call the procedure
          env_fact_sifen.pp_inutilizar_nro_doc(p_movi_codi => v('P34_MOVI_CODI_I'));
        end;
      
      elsif v('P34_MOVI_INDI_ANUL') = 'S' and v_count = 0 then
      
        pp_get_erro(i_resp_codi      => 95,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_codi := 95;
      
        raise salir;
      
        raise salir;
      
      end if;
      else
       begin
        select count(*), nvl(f.elfa_estado, 's')
          into v_count, v_estado
          from come_elec_fact f, come_movi ff
         where ff.movi_codi=f.elfa_come_mov_cod
          and ff.movi_codi_padr=v('P34_MOVI_CODI_I')
         group by f.elfa_estado;
      exception
        when no_data_found then
          v_count := 0;
        when too_many_rows then
          v_count := 1;
      end;
      
       if v_count > 0 and v_estado <> 'Rechazado' then
        if i_fech < trunc(sysdate) - 2 then
           
        pp_get_erro(i_resp_codi      => 96,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
        --  pl_me('El recibo está asociado a una factura que ha excedido el plazo de 48 horas permitido para su anulación.');
        v_erro_codi := 96;
      
        raise salir;
      
        raise salir;
        end if;
     end if;
    end if;
  exception
    when salir then
      o_resp_desc := v_erro_desc;
      o_resp_codi := v_erro_codi;
    when others then
      o_resp_desc := 'Error en Factura Electronica: ' || sqlcode;
      o_resp_codi := 1000;
  end pp_vali_fact_elec;

  --validando secuencia de inmuebles..
  procedure pp_vali_inmu_esta(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
  
    v_moin_secu      number;
    v_moin_inmu_codi number;
    v_max_moin_secu  number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 19);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando secuencia de inmuebles..');
  
    select moin_secu, moin_inmu_codi
      into v_moin_secu, v_moin_inmu_codi
      from come_movi_inmu_esta
     where moin_movi_codi = i_movi_codi;
  
    if v_moin_inmu_codi is not null then
    
      select max(moin_secu)
        into v_max_moin_secu
        from come_movi_inmu_esta
       where moin_inmu_codi = v_moin_inmu_codi;
    
      if v_max_moin_secu = v_moin_secu then
        null;
      else
        pp_get_erro(i_resp_codi      => 13,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_codi := 13;
        raise salir;
      
      end if;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      null;
  end pp_vali_inmu_esta;

  --validando cobro diferido
  procedure pp_vali_cobr_dife(i_movi_indi_cobr_dife in varchar2,
                              o_resp_codi           out number,
                              o_resp_desc           out varchar2) is
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 20);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Cobro diferido..');
  
    if nvl(i_movi_indi_cobr_dife, 'N') = 'C' then
      pp_get_erro(i_resp_codi      => 15,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 15;
      raise salir;
    end if;
  
  exception
    when salir then
      o_resp_desc := v_erro_desc;
      o_resp_codi := v_erro_codi;
    when others then
      o_resp_desc := 'Error al momento de Validad Cobro en diferido: ' ||
                     sqlcode;
      o_resp_codi := 1000;
  end pp_vali_cobr_dife;

  --validando asientos 
  procedure pp_vali_asie(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
    cursor c_deta_asien is
      select taax_c001 codi,
             taax_c002 tipo,
             taax_c003 numero,
             taax_c004 fech,
             taax_c005 obs
        from come_tabl_auxi
       where taax_user = v('APP_USER')
         and taax_sess = v('APP_SESSION');
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 22);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Asientos..');
  
    i020167.pp_carg_asie(i_movi_codi => i_movi_codi);
  
    for x in c_deta_asien loop
      if x.codi is not null and nvl(x.tipo, 'A') <> 'M' then
      
        pp_get_erro(i_resp_codi      => 61,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_codi := 61;
        raise salir;
      
      end if;
    end loop;
  
  exception
    when salir then
      o_resp_desc := v_erro_desc;
      o_resp_codi := v_erro_codi;
    when others then
      o_resp_desc := 'Error al momento de Validar Asientos: ' || sqlcode;
      o_resp_codi := 1000;
    
  end pp_vali_asie;

  --validando permisos de usuarios..
  procedure pp_vali_perm_usua(i_movi_oper_codi in number,
                              i_movi_timo_codi in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is
  
    v_indi_borra varchar2(5);
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 24);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando permisos de usuarios..');
  
    if i_movi_oper_codi is not null then
    
      begin
        general_skn.pl_vali_user_stoc_oper(p_oper_codi  => i_movi_oper_codi,
                                           p_indi_si_no => v_indi_borra);
      end;
    
      if upper(rtrim(ltrim(v_indi_borra))) = 'N' then
      
        pp_get_erro(i_resp_codi      => 16,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_codi := 16;
        raise salir;
      
      end if;
    
      if i_movi_timo_codi is not null then
        begin
          general_skn.pl_vali_user_tipo_movi(p_timo_codi  => i_movi_timo_codi,
                                             p_indi_si_no => v_indi_borra);
        end;
      
        if upper(rtrim(ltrim(v_indi_borra))) = 'N' then
        
          pp_get_erro(i_resp_codi      => 17,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          v_erro_codi := 17;
          raise salir;
        
        end if;
      
      end if;
    
    end if;
  
  exception
    when salir then
      o_resp_desc := v_erro_desc;
      o_resp_codi := v_erro_codi;
    when others then
      o_resp_desc := 'Error en validacion de Permiso de Usuario: ' ||
                     sqlcode;
      o_resp_codi := 1000;
    
  end pp_vali_perm_usua;

  --validando documento padre..
  procedure pp_vali_docu_padr(i_movi_codi_padr in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar) is
  
    v_oper_desc_padr  varchar2(500);
    v_timo_desc_padre varchar2(500);
    v_movi_nume_padr  come_movi.movi_nume%type;
    v_timo_tico_codi  come_tipo_movi.timo_tico_codi%type;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 26);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando documento padre..');
  
    if i_movi_codi_padr is not null then
    
      begin
        v_oper_desc_padr  := ' ';
        v_timo_desc_padre := ' ';
      
        select oper_desc, movi_nume, timo_desc, timo_tico_codi
          into v_oper_desc_padr,
               v_movi_nume_padr,
               v_timo_desc_padre,
               v_timo_tico_codi
          from come_movi, come_stoc_oper, come_tipo_movi
         where movi_timo_codi = timo_codi(+)
           and movi_oper_codi = oper_codi(+)
           and movi_codi = i_movi_codi_padr;
      
        if v_timo_tico_codi = 4 then
          begin
            select count(*)
              into v_count
              from come_movi_cheq
             where chmo_movi_codi = i_movi_codi_padr;
          
            if v_count > 0 then
            
              pp_get_erro(i_resp_codi      => 18,
                          i_resp_orig      => 1,
                          i_resp_segu_pant => 116,
                          o_resp_desc      => v_erro_desc);
            
              v_erro_desc := replace(v_erro_desc, 'P_CANT', v_count);
              v_erro_codi := 18;
              raise salir;
            
            end if;
          
          end;
        
        else
        
          pp_get_erro(i_resp_codi      => 19,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          v_erro_desc := replace(replace(replace(v_erro_desc,
                                                 'P_OPER_DESC',
                                                 rtrim(ltrim(v_oper_desc_padr))),
                                         'P_NUME_PADRE',
                                         to_char(v_movi_nume_padr)),
                                 'P_TICO_DESC',
                                 rtrim(ltrim(v_timo_desc_padre)));
          v_erro_codi := 19;
          raise salir;
        end if;
      
      exception
        when too_many_rows then
        
          pp_get_erro(i_resp_codi      => 20,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          v_erro_desc := replace(replace(v_erro_desc,
                                         'P_OPER_DESC',
                                         rtrim(ltrim(v_oper_desc_padr))),
                                 'P_NUME_PADR',
                                 to_char(v_movi_nume_padr));
          v_erro_codi := 20;
          raise salir;
        
      end;
    
    else
    
      begin
      
        select count(*)
          into v_count
          from come_movi_rete
         where more_movi_codi_rete = i_movi_codi_padr; ----- reeeeeeeeeeeeeeevisar esto i_movi_codi;
      
        if v_count > 0 then
        
          pp_get_erro(i_resp_codi      => 21,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          v_erro_codi := 21;
          raise salir;
        
        end if;
      
      end;
    
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      pp_get_erro(i_resp_codi      => 22,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      o_resp_codi := 22;
      o_resp_desc := v_erro_desc || ' ' || sqlcode;
    
  end pp_vali_docu_padr;

  --validando pagares..
  procedure pp_vali_paga(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
  
    v_copa_nume number;
  
  begin
    -- validar que no existan impresiones de contratos y pagares
    setitem('P34_PROGRESS_BAR_PORC', 27);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando pagares..');
  
    select c.copa_nume
      into v_copa_nume
      from come_cont_paga c, come_cont_paga_deta d
     where c.copa_codi = d.deta_copa_codi
       and d.deta_movi_codi = i_movi_codi
       and rownum = 1;
  
    if v_copa_nume is not null then
    
      pp_get_erro(i_resp_codi      => 23,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_desc := replace(v_erro_desc, 'P_NRO_PAGA', v_copa_nume);
      v_erro_codi := 23;
      raise salir;
    
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when no_data_found then
      null;
    
  end pp_vali_paga;

  --validando documentos hijos..'
  procedure pp_vali_docu_hijo(i_movi_codi      in number,
                              i_movi_timo_codi in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is
  
    cursor c_hijos(p_codi in number) is
      select movi_codi
        from come_movi
       where movi_codi_padr = p_codi
       order by movi_codi desc;
  
    cursor c_nietos(p_codi in number) is
      select movi_codi
        from come_movi
       where movi_codi_padr = p_codi
       order by movi_codi desc;
  
    --que no se pueda borrar si tiene un hijo de validacion
    cursor c_hijo_vali(p_codi in number) is
      select movi_codi
        from come_movi
       where movi_codi_padr_vali = p_codi
       order by movi_codi desc;
  
    v_o_codi number;
    v_cont   number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 48);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Documentos Hijos..');
  
    ---validar que el movimiento en caso que sea credito, las cuotas no tengan pagos/cance asignados..
    ---o en el caso q sea contado, (si tiene cheques), que los mismos no tengan movimientos posteriores. ej. un deposito...
  
    for x in c_hijos(i_movi_codi) loop
    
      -- validar cancelacion de hijos  
      begin
        i020167.pp_vali_movi_canc(i_movi_codi      => x.movi_codi,
                                  i_movi_codi_padr => i_movi_codi,
                                  o_codi           => v_o_codi);
      
        if v_o_codi in (1, 2) then
          v_erro_codi := 24;
          pp_get_erro(i_resp_codi      => 24,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          raise salir;
        end if;
      
      end;
    
      if i_movi_timo_codi <> 78 then
      
        select count(*)
          into v_cont
          from come_movi_cuot_pres_canc
         where canc_cupe_movi_codi = x.movi_codi;
      
        if v_cont > 0 then
          v_erro_codi := 25;
          pp_get_erro(i_resp_codi      => 25,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
          raise salir;
        end if;
      
      end if;
    
      -- planilla chica de cobradores    
      begin
      
        select count(*)
          into v_cont
          from come_cobr_cred_deta
         where deta_movi_codi = x.movi_codi
           and deta_indi_pago = 'S';
      
        if nvl(p_indi_perm_borr_reci_plan_cer, 'N') = 'N' then
          if v_cont > 0 then
            pp_get_erro(i_resp_codi      => 26,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
            v_erro_codi := 26;
            raise salir;
          end if;
        end if;
      
      end;
    
      -- planilla chica de clientes
      begin
      
        select count(*)
          into v_cont
          from come_cobr_clie_deta
         where deta_movi_codi = x.movi_codi
           and deta_indi_pago = 'S';
      
        if nvl(p_indi_perm_borr_reci_plan_cer, 'N') = 'N' then
          if v_cont > 0 then
            pp_get_erro(i_resp_codi      => 27,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
            v_erro_codi := 27;
            raise salir;
          end if;
        end if;
      
      end;
    
      --validar que los cheques relacionados con el documento, no posea operaciones posteriores.....................   
      -- cheques
      begin
        i020167.pp_vali_cheq(i_movi_codi => x.movi_codi,
                             o_erro_desc => v_erro_desc,
                             o_erro_codi => v_erro_codi);
      
        if v_erro_codi = 28 then
          raise salir;
        end if;
      
      end;
    
      -- cheques diferidos
      begin
        i020167.pp_vali_cheq_dife(i_movi_codi => x.movi_codi,
                                  o_erro_desc => v_erro_desc,
                                  o_erro_codi => v_erro_codi);
      
        if v_erro_codi = 29 then
          raise salir;
        end if;
      
      end;
    
      -- validacion de retencion      
      begin
        i020167.pp_vali_rete(i_movi_codi => x.movi_codi,
                             o_erro_desc => v_erro_desc,
                             o_erro_codi => v_erro_codi);
      
        if v_erro_codi = 30 then
          raise salir;
        end if;
      
      end;
    
      -- validacion de cupo de tarjeta
      begin
        i020167.pp_vali_tarj_cupo(i_movi_codi => x.movi_codi,
                                  o_erro_desc => v_erro_desc,
                                  o_erro_codi => v_erro_codi);
      
        if v_erro_codi = 31 then
          raise salir;
        end if;
      end;
    
      --descuentos de cheques - factura interes. 
      begin
        i020167.pp_vali_fact_depo(i_movi_codi => x.movi_codi,
                                  o_erro_desc => v_erro_desc,
                                  o_erro_codi => v_erro_codi);
      
        if v_erro_codi = 32 then
          raise salir;
        end if;
      
      end;
    
      --validacion de op.
      begin
        i020167.pp_vali_orde_pago(i_movi_codi => x.movi_codi,
                                  o_erro_desc => v_erro_desc,
                                  o_erro_codi => v_erro_codi);
      
        if v_erro_codi = 33 then
          raise salir;
        end if;
      
      end;
    
      -- validar que no existan impresiones de contratos y pagares
      declare
        v_copa_nume come_cont_paga.copa_nume%type;
      begin
        select c.copa_nume
          into v_copa_nume
          from come_cont_paga c, come_cont_paga_deta d
         where c.copa_codi = d.deta_copa_codi
           and d.deta_movi_codi = x.movi_codi
           and rownum = 1;
      
        if v_copa_nume is not null then
        
          pp_get_erro(i_resp_codi      => 35,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          v_erro_desc := replace(v_erro_desc, 'P_NUME_CHEQ', v_copa_nume);
          v_erro_codi := 35;
        
          raise salir;
        end if;
      exception
        when no_data_found then
          null;
      end;
    
      --validando secuencia de inmuebles..'        
      declare
      
        v_moin_secu      number;
        v_moin_inmu_codi number;
        v_max_moin_secu  number;
      
      begin
      
        select moin_secu, moin_inmu_codi
          into v_moin_secu, v_moin_inmu_codi
          from come_movi_inmu_esta
         where moin_movi_codi = x.movi_codi;
      
        if v_moin_inmu_codi is not null then
        
          select max(moin_secu)
            into v_max_moin_secu
            from come_movi_inmu_esta
           where moin_inmu_codi = v_moin_inmu_codi;
        
          if v_max_moin_secu = v_moin_secu then
            null;
          else
            pp_get_erro(i_resp_codi      => 36,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
          
            v_erro_codi := 36;
            raise salir;
          end if;
        end if;
      
      exception
        when no_data_found then
          null;
      end;
    
      for y in c_nietos(x.movi_codi) loop
        -- cancelaciones
        begin
          i020167.pp_vali_movi_canc(i_movi_codi      => y.movi_codi,
                                    i_movi_codi_padr => x.movi_codi,
                                    o_codi           => v_o_codi);
        
          if v_o_codi in (1, 2) then
            pp_get_erro(i_resp_codi      => 24,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
            v_erro_codi := 24;
            raise salir;
          end if;
        end;
      
        -- cheques
        begin
          i020167.pp_vali_cheq(i_movi_codi => y.movi_codi,
                               o_erro_desc => v_erro_desc,
                               o_erro_codi => v_erro_codi);
        
          if v_erro_codi = 28 then
            raise salir;
          end if;
        
        end;
      
        -- cheques diferidos
        begin
          i020167.pp_vali_cheq_dife(i_movi_codi => y.movi_codi,
                                    o_erro_desc => v_erro_desc,
                                    o_erro_codi => v_erro_codi);
        
          if v_erro_codi = 29 then
            raise salir;
          end if;
        
        end;
      
        -- validacion de retencion      
        begin
          i020167.pp_vali_rete(i_movi_codi => y.movi_codi,
                               o_erro_desc => v_erro_desc,
                               o_erro_codi => v_erro_codi);
        
          if v_erro_codi = 30 then
            raise salir;
          end if;
        
        end;
      
        --descuentos de cheques - factura interes. 
        begin
          i020167.pp_vali_fact_depo(i_movi_codi => y.movi_codi,
                                    o_erro_desc => v_erro_desc,
                                    o_erro_codi => v_erro_codi);
        
          if v_erro_codi = 32 then
            raise salir;
          end if;
        
        end;
      
        -- validacion de cupo de tarjeta
        begin
          i020167.pp_vali_tarj_cupo(i_movi_codi => y.movi_codi,
                                    o_erro_desc => v_erro_desc,
                                    o_erro_codi => v_erro_codi);
        
          if v_erro_codi = 31 then
            raise salir;
          end if;
        end;
      
        --validacion de op.
        begin
          i020167.pp_vali_orde_pago(i_movi_codi => y.movi_codi,
                                    o_erro_desc => v_erro_desc,
                                    o_erro_codi => v_erro_codi);
        
          if v_erro_codi = 33 then
            raise salir;
          end if;
        
        end;
      
        -- validar que no existan impresiones de contratos y pagares
        declare
          v_copa_nume come_cont_paga.copa_nume%type;
        begin
          select c.copa_nume
            into v_copa_nume
            from come_cont_paga c, come_cont_paga_deta d
           where c.copa_codi = d.deta_copa_codi
             and d.deta_movi_codi = x.movi_codi
             and rownum = 1;
        
          if v_copa_nume is not null then
          
            pp_get_erro(i_resp_codi      => 35,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
          
            v_erro_desc := replace(v_erro_desc, 'P_NUME_CHEQ', v_copa_nume);
            v_erro_codi := 35;
          
            raise salir;
          end if;
        exception
          when no_data_found then
            null;
        end;
      
      end loop;
    
    end loop;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error al momento de Validacion de Documento Hijo:' ||
                     sqlcode;
  end pp_vali_docu_hijo;

  --validado ots
  procedure pp_vali_ots(i_movi_ortr_codi in number,
                        i_ortr_nume      in number,
                        o_resp_codi      out number,
                        o_resp_desc      out varchar2) is
  
    v_ortr_fech_liqu come_orde_trab.ortr_fech_liqu%type;
  
  begin
    setitem('P34_PROGRESS_BAR_PORC', 29);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando OTs..');
  
    -- si esta relacionado a una o.t., verificar que no se pueda anular si la o.t. esta liquidada
  
    if i_movi_ortr_codi is not null then
      begin
        select ortr_fech_liqu
          into v_ortr_fech_liqu
          from come_orde_trab
         where ortr_codi = i_movi_ortr_codi;
      
        if v_ortr_fech_liqu is not null then
        
          pp_get_erro(i_resp_codi      => 37,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          v_erro_desc := replace(v_erro_desc, 'P_NRO', i_ortr_nume);
          v_erro_codi := 37;
          raise salir;
        end if;
      end;
    end if;
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error al momento de validar OT: ' || sqlcode;
  end pp_vali_ots;

  --validando documentos hijos de validacion..
  procedure pp_vali_docu_hi2(i_movi_codi in number,
                             o_resp_codi out number,
                             o_resp_desc out varchar2) is
  
    --que no se pueda borrar si tiene un hijo de validacion
    cursor c_hijo_vali(p_codi in number) is
      select movi_codi
        from come_movi
       where movi_codi_padr_vali = p_codi
       order by movi_codi desc;
  
    v_movi_nume_hijo come_movi.movi_nume%type;
    v_oper_desc_hijo come_stoc_oper.oper_desc_abre%type;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 30);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando Documentos hijos de validacion..');
  
    for x in c_hijo_vali(i_movi_codi) loop
    
      begin
        select movi_nume, nvl(oper_desc_abre, ' ')
          into v_movi_nume_hijo, v_oper_desc_hijo
          from come_movi, come_stoc_oper
         where movi_oper_codi = oper_codi(+)
           and movi_codi = x.movi_codi;
      
        pp_get_erro(i_resp_codi      => 38,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_desc := replace(v_erro_desc,
                               'P_NRO',
                               v_movi_nume_hijo || ' ' || v_oper_desc_hijo || '.');
        v_erro_codi := 38;
        raise salir;
      
      exception
        when salir then
          o_resp_codi := v_erro_codi;
          o_resp_desc := v_erro_desc;
        when too_many_rows then
          o_resp_codi := v_erro_codi;
          o_resp_desc := v_erro_desc;
        when others then
          o_resp_codi := 1000;
          o_resp_desc := 'Error en validacion de documentos hijo 2: ' ||
                         sqlcode;
      end;
    end loop;
  
  end pp_vali_docu_hi2;

  -- validacion consumo interno y  nota de devolucion...
  procedure pp_vali_cons_nota_devu(i_movi_codi in number,
                                   o_resp_codi out number,
                                   o_resp_desc out varchar2) is
  
    v_movi_codi_cons_inte come_movi.movi_codi_padr_vali%type;
    v_cant_node           number;
    v_node_nume           come_nota_devu.node_nume%type;
    v_node_fech_emis      come_nota_devu.node_fech_emis%type;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 33);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Nota de Devolucion...');
  
    ---consumo interno
    begin
      select movi_codi_padr_vali
        into v_movi_codi_cons_inte
        from come_movi
       where movi_timo_codi = 35
         and movi_codi = i_movi_codi;
    
      update come_movi
         set movi_indi_pago_cons_inte = 'N'
       where movi_codi = v_movi_codi_cons_inte;
    
    exception
      when others then
        v_movi_codi_cons_inte := null;
    end;
  
    -- nota de devolucion
  
    select count(*)
      into v_cant_node
      from come_nota_devu nd
     where nd.node_fact_codi = i_movi_codi;
  
    if v_cant_node > 0 then
      begin
        select node_nume, node_fech_emis
          into v_node_nume, v_node_fech_emis
          from come_nota_devu nd
         where nd.node_fact_codi = i_movi_codi;
      
        pp_get_erro(i_resp_codi      => 39,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_desc := replace(replace(v_erro_desc, 'P_NRO', v_node_nume),
                               'P_FECHA',
                               to_char(v_node_fech_emis, 'dd-mm-yyyy'));
        v_erro_codi := 39;
        raise salir;
      end;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when no_data_found then
      null;
    when too_many_rows then
      pp_get_erro(i_resp_codi      => 39,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_desc := replace(replace(v_erro_desc, 'P_NRO', v_node_nume),
                             'P_FECHA',
                             to_char(v_node_fech_emis, 'dd-mm-yyyy'));
      v_erro_codi := 39;
    
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    
    when others then
      pp_get_erro(i_resp_codi      => 39,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_desc := replace(replace(v_erro_desc, 'P_NRO', v_node_nume),
                             'P_FECHA',
                             to_char(v_node_fech_emis, 'dd-mm-yyyy'));
      v_erro_codi := 39;
    
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    
  end pp_vali_cons_nota_devu;

  --validando conciliacion bancaria..
  procedure pp_vali_conc_banc(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
  
    v_cuen_codi number;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 35);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Conciliacion Bancaria..');
  
    select max(moim_cuen_codi)
      into v_cuen_codi
      from come_movi_impo_deta
     where moim_movi_codi = i_movi_codi
       and moim_indi_conc = 'S';
  
    if v_cuen_codi is not null then
    
      pp_get_erro(i_resp_codi      => 40,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_desc := replace(v_erro_desc, 'P_CAJA', v_cuen_codi);
      v_erro_codi := 40;
      raise salir;
    
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error al momento de validar conciliacion bancaria: ' ||
                     sqlcode;
    
  end pp_vali_conc_banc;

  --validando cancelacion de cuotas..
  procedure pp_vali_canc_cuot(i_movi_timo_codi in number,
                              i_movi_codi      in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is
    v_resp_desc varchar2(5000);
    v_resp_codi number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 40);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando cancelacion de cuotas..');
  
    --devolucion de adelantos de clientes y prov 
    if i_movi_timo_codi not in (56, 57) then
    
      i020167.pp_vali_movi_canc(i_movi_codi,
                                i_movi_codi,
                                v_resp_codi,
                                v_resp_desc);
    
      if v_resp_codi is not null then
        raise salir;
      elsif v_resp_codi is null then
        o_resp_codi := null;
        o_resp_desc := null;
      end if;
    
    end if;
  
  exception
    when salir then
      o_resp_codi := v_resp_codi;
      o_resp_desc := v_resp_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Cancelacion de Cuotas: ' ||
                     sqlcode;
    
  end pp_vali_canc_cuot;

  --validando cancelacion de prestamos..
  procedure pp_vali_canc_pres(i_movi_timo_codi in number,
                              i_movi_codi      in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is
  
    v_cont number;
  begin
    setitem('P34_PROGRESS_BAR_PORC', 42);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando cancelacion de prestamos..');
  
    if i_movi_timo_codi <> 78 then
    
      select count(*)
        into v_cont
        from come_movi_cuot_pres_canc
       where canc_cupe_movi_codi = i_movi_codi;
    
      if v_cont > 0 then
      
        pp_get_erro(i_resp_codi      => 25,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_codi := 25;
        raise salir;
      
      end if;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error al momento de validar cancelacion de prestamos: ' ||
                     sqlcode;
    
  end pp_vali_canc_pres;

  --validando logistica..
  procedure pp_vali_logi_entr(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
  
    v_count number := 0;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 43);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando logistica..');
  
    select count(ende_deta_movi_codi)
      into v_count
      from come_entr_sali_deta
     where ende_deta_movi_codi = i_movi_codi;
  
    if v_count > 0 then
      pp_get_erro(i_resp_codi      => 41,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 41;
      raise salir;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en validacion de logistica entrada: ' ||
                     sqlcode;
    
  end pp_vali_logi_entr;

  --validando cancelacion de adelantos..
  procedure pp_vali_canc_adel(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    v_cont number;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 44);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando cancelacion de adelantos..');
  
    select count(*)
      into v_cont
      from come_movi_adel_prod_canc
     where canc_movi_codi_adel = i_movi_codi;
  
    if v_cont > 0 then
      pp_get_erro(i_resp_codi      => 25,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 25;
      raise salir;
    
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Cancelacion de Adelantos: ' ||
                     sqlcode;
    
  end pp_vali_canc_adel;

  --validando carga de camion..
  procedure pp_vali_carg_cami(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
  
    cursor c_carg_movi is
      select c.carg_codi, c.carg_nume, mc.camo_carg_secu
        from come_movi_carg mc, come_carg_cami c
       where mc.camo_carg_codi = c.carg_codi
         and mc.camo_movi_codi = i_movi_codi;
  
    v_count number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 45);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando carga de camion..');
  
    -- validar que las cargas relacionados con el documento, no posea operaciones posteriores.........
  
    for x in c_carg_movi loop
    
      select count(*)
        into v_count
        from come_movi_carg
       where camo_carg_codi = x.carg_codi;
    
      if v_count > x.camo_carg_secu then
      
        pp_get_erro(i_resp_codi      => 42,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_desc := replace(v_erro_desc, 'P_NRO', x.carg_nume);
        v_erro_codi := 42;
        raise salir;
      
      end if;
    end loop;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error al momento de validar Carga Camiones: ' ||
                     sqlcode;
    
  end pp_vali_carg_cami;

  --validando cheques gral..
  procedure pp_vali_cheq_gral(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
  
    v_erro_desc varchar2(5000);
    v_erro_codi number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 48);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando cancelacion de prestamos..');
    --validar que los cheques relacionados con el documento, no posea operaciones posteriores.....................   
    -- cheques
    begin
      i020167.pp_vali_cheq(i_movi_codi => i_movi_codi,
                           o_erro_desc => v_erro_desc,
                           o_erro_codi => v_erro_codi);
    
      if v_erro_codi = 28 then
        raise salir;
      end if;
    
    end;
  
    -- cheques diferidos
    begin
      i020167.pp_vali_cheq_dife(i_movi_codi => i_movi_codi,
                                o_erro_desc => v_erro_desc,
                                o_erro_codi => v_erro_codi);
    
      if v_erro_codi = 29 then
        raise salir;
      end if;
    
    end;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en validacion de Cheques/Cheques Diferidos: ' ||
                     sqlcode;
    
  end pp_vali_cheq_gral;

  --validando retenciones..
  procedure pp_vali_rete_gral(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    v_erro_codi number;
    v_erro_desc varchar2(5000);
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 50);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando cancelacion de prestamos..');
  
    i020167.pp_vali_rete(i_movi_codi => i_movi_codi,
                         o_erro_desc => v_erro_desc,
                         o_erro_codi => v_erro_codi);
  
    if v_erro_codi is not null then
      raise salir;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en validacion de retenecion gral: ' || sqlcode;
    
  end pp_vali_rete_gral;

  --validando facturas de depostio bancario e intereses..';
  procedure pp_vali_fact_depo_gral(i_movi_codi in number,
                                   o_resp_codi out number,
                                   o_resp_desc out varchar2) is
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 55);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando cancelacion de prestamos..');
  
    i020167.pp_vali_fact_depo(i_movi_codi => i_movi_codi,
                              o_erro_desc => v_erro_desc,
                              o_erro_codi => v_erro_codi);
  
    if v_erro_codi = 32 then
      raise salir;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en validacion de Facturas con deposito bancarios e intereses: ' ||
                     sqlcode;
    
  end pp_vali_fact_depo_gral;

  --validando tarjetas de creditos..
  procedure pp_vali_tarj_cred_gral(i_movi_codi in number,
                                   o_resp_codi out number,
                                   o_resp_desc out varchar2) is
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 58);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando tarjetas de creditos..');
  
    -- validacion de cupo de tarjeta
    begin
      i020167.pp_vali_tarj_cupo(i_movi_codi => i_movi_codi,
                                o_erro_desc => v_erro_desc,
                                o_erro_codi => v_erro_codi);
    
      if v_erro_codi = 31 then
        raise salir;
      end if;
    end;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en validacion de tarjetas de creditos: ' ||
                     sqlcode;
  end pp_vali_tarj_cred_gral;

  --validando notas de creditos..
  procedure pp_vali_nc(i_movi_codi in number,
                       o_resp_codi out number,
                       o_resp_desc out varchar2) is
  
    --validar que el detalle de los productos no tngan registros relacionados por ejemplo en el caso de compras, notas de creditos.....................
    cursor c_movi(p_movi_codi_cur in number) is
      select movi_nume, movi_timo_codi, movi_oper_codi
        from come_movi, come_movi_prod_deta
       where movi_codi = deta_movi_codi
         and deta_movi_codi_padr = p_movi_codi_cur;
  
    v_count number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 60);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando NC..');
  
    select count(*)
      into v_count
      from come_movi_prod_deta
     where deta_movi_codi_padr = i_movi_codi;
  
    if v_count > 0 then
      for x in c_movi(i_movi_codi) loop
      
        pp_get_erro(i_resp_codi      => 403,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_desc := replace(replace(replace(v_erro_desc,
                                               'P_NRO',
                                               to_char(x.movi_nume)),
                                       'P_OPER',
                                       to_char(x.movi_oper_codi)),
                               'P_TM',
                               to_char(x.movi_timo_codi));
        v_erro_codi := 43;
        raise salir;
      
      end loop;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en validacion de NC: ' || sqlcode;
    
  end pp_vali_nc;

  --validando contratos de chacra..
  procedure pp_vali_cont_chac(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    v_count number;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 61);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando Contratos de chacra..');
  
    select count(*)
      into v_count
      from come_movi_cont_deta a
     where a.como_movi_codi_desh = i_movi_codi;
  
    if v_count > 0 then
    
      pp_get_erro(i_resp_codi      => 44,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 44;
      raise salir;
    
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Contrato de Chacra: ' || sqlcode;
  end pp_vali_cont_chac;

  --validando movimientos de salida de produccion..
  procedure pp_vali_movi_sali_prod(i_movi_codi in number,
                                   o_resp_codi out number,
                                   o_resp_desc out varchar2) is
  
    v_cont number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 62);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando movimientos de salida de produccion..');
  
    select count(*)
      into v_cont
      from prod_movi
     where movi_come_codi_sali = i_movi_codi;
  
    if v_cont > 0 then
    
      pp_get_erro(i_resp_codi      => 46,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 46;
      raise salir;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Movimiento  de salida de Produccion: ' ||
                     sqlcode;
    
  end pp_vali_movi_sali_prod;

  --validando movimientos de entrada de produccion..
  procedure pp_vali_movi_entr_prod(i_movi_codi in number,
                                   o_resp_codi out number,
                                   o_resp_desc out varchar2) is
  
    v_cont number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 62);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando movimientos de entrada de produccion..');
  
    select count(*)
      into v_cont
      from prod_movi
     where movi_come_codi_entr = i_movi_codi;
  
    if v_cont > 0 then
    
      pp_get_erro(i_resp_codi      => 46,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 46;
      raise salir;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Movimiento de entrada de Produccion: ' ||
                     sqlcode;
    
  end pp_vali_movi_entr_prod;

  --validando limite de costo..
  procedure pp_vali_limi_cost(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
  
    cursor c_limi is
      select ortr_nume
        from come_ortr_limi_cost, come_orde_trab
       where lico_ortr_codi = ortr_codi
         and lico_movi_codi_fact = i_movi_codi
       order by ortr_nume;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 65);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando movimientos de entrada de produccion..');
  
    for x in c_limi loop
    
      pp_get_erro(i_resp_codi      => 46,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_desc := replace(v_erro_desc, 'P_NRO', x.ortr_nume);
      v_erro_codi := 46;
      raise salir;
    
    end loop;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Limite de Costo: ' || sqlcode;
    
  end pp_vali_limi_cost;

  --validando diferencia de cambios..';
  procedure pp_vali_dife_camb(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    cursor c_dife_camb is
      select dica_fech_hasta
        from come_movi_dife_camb
       where dica_movi_codi = i_movi_codi
       order by 1;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 66);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando movimientos de entrada de produccion..');
    --validar que la factura/adelanto o nota de credito no posea diferencia  de cambio por saldos
    for x in c_dife_camb loop
      pp_get_erro(i_resp_codi      => 47,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_desc := replace(v_erro_desc,
                             'P_PERIODO',
                             to_char(x.dica_fech_hasta, 'mm-yyyy'));
      v_erro_codi := 46;
      raise salir;
    
    end loop;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Diferencia de Cambio: ' ||
                     sqlcode;
  end pp_vali_dife_camb;

  --validando diferencia de cambios de cheques..';
  procedure pp_vali_dife_cheq(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    cursor c_cheq is
      select cheq_codi, cheq_nume, cheq_fech_emis
        from come_movi_cheq, come_cheq
       where chmo_cheq_codi = cheq_codi
         and chmo_movi_codi = i_movi_codi;
  
    v_count number;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 68);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando movimientos de entrada de produccion..');
    for x in c_cheq loop
      select count(*)
        into v_count
        from come_cheq_dife_camb
       where dica_cheq_codi = x.cheq_codi;
    
      if v_count > 0 then
        pp_get_erro(i_resp_codi      => 48,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        v_erro_desc := replace(v_erro_desc, 'P_NRO', x.cheq_nume);
        v_erro_codi := 48;
        raise salir;
      
      end if;
    end loop;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Diferencia de Cheque: ' ||
                     sqlcode;
    
  end pp_vali_dife_cheq;

  --validando plan de facturacion..
  procedure pp_vali_plan_fact(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
    v_indi_mail varchar2(1);
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 69);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando movimientos de entrada de produccion..');
  
    select deta_indi_mail
      into v_indi_mail
      from come_fact_auto_deta
     where deta_movi_codi = i_movi_codi;
  
    if nvl(v_indi_mail, 'N') = 'S' then
      pp_get_erro(i_resp_codi      => 49,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 49;
      raise salir;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when no_data_found then
      null;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Plan de Facturacion: ' ||
                     sqlcode;
    
  end pp_vali_plan_fact;

  --validando cierre de planilla..
  procedure pp_cier_plan(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
  
    v_deta_cocr_codi number;
    v_deta_nume_item number;
    v_count          number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 70);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando movimientos de entrada de produccion..');
  
    begin
      select deta_cocr_codi
        into v_deta_cocr_codi
        from come_cobr_cred_deta z, come_cobr_cred c
       where cocr_codi = z.deta_cocr_codi
         and z.deta_movi_codi = i_movi_codi
         and nvl(c.cocr_esta, 'P') = 'P'
         and rownum = 1;
    
    exception
      when no_data_found then
        select count(deta_cocr_codi)
          into v_count
          from come_cobr_cred_deta z, come_cobr_cred c
         where cocr_codi = z.deta_cocr_codi
           and z.deta_movi_codi = i_movi_codi
           and nvl(c.cocr_esta, 'P') = 'C';
      
        if nvl(p_indi_perm_borr_reci_plan_cer, 'N') = 'N' then
          if v_count > 0 then
            pp_get_erro(i_resp_codi      => 50,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
          
            v_erro_codi := 50;
            raise salir;
          end if;
        end if;
    end;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion en cierre de Planilla Cobradores: ' ||
                     sqlcode;
  end pp_cier_plan;

  --validando cierre de planilla de clientes..
  procedure pp_vali_cier_plan_clie(i_movi_codi in number,
                                   o_resp_codi out number,
                                   o_resp_desc out varchar2) is
  
    v_deta_cocl_codi number;
    v_deta_nume_item number;
    v_count          number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 74);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando movimientos de entrada de produccion..');
  
    begin
      select deta_cocl_codi
        into v_deta_cocl_codi
        from come_cobr_clie_deta z, come_cobr_clie c
       where cocl_codi = z.deta_cocl_codi
         and z.deta_movi_codi_reci = i_movi_codi
         and nvl(c.cocl_esta, 'P') = 'P'
         and rownum = 1;
    
    exception
      when no_data_found then
        select count(deta_cocl_codi)
          into v_count
          from come_cobr_clie_deta z, come_cobr_clie c
         where cocl_codi = z.deta_cocl_codi
           and z.deta_movi_codi_reci = i_movi_codi
           and nvl(c.cocl_esta, 'P') = 'C';
      
        if nvl(p_indi_perm_borr_reci_plan_cer, 'N') = 'N' then
          if v_count > 0 then
            pp_get_erro(i_resp_codi      => 51,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
          
            v_erro_codi := 51;
            raise salir;
          
          end if;
        end if;
    end;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion en cierre de Planilla Cliente: ' ||
                     sqlcode;
  end pp_vali_cier_plan_clie;

  --validando viaje..
  procedure pp_vali_viaj(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
  
    v_count number := 0;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 77);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando movimientos de entrada de produccion..');
  
    select count(*)
      into v_count
      from come_movi_impo_deta, tran_viaj
     where moim_viaj_codi = viaj_codi
       and viaj_esta = 'L'
       and moim_movi_codi = i_movi_codi;
  
    if v_count > 0 then
      pp_get_erro(i_resp_codi      => 52,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 52;
      raise salir;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Viaje: ' || sqlcode;
    
  end pp_vali_viaj;

  --validando orden de pago..';
  procedure pp_vali_op(i_movi_codi in number,
                       o_resp_codi out number,
                       o_resp_desc out varchar2) is
  
    --descuentos de cheques - factura interes.
    cursor c_cuot is
      select o.orpa_nume
        from come_orde_pago o, come_orde_pago_deta d
       where o.orpa_codi = d.deta_orpa_codi
         and d.deta_cuot_movi_codi = i_movi_codi;
  
    cursor c_auto is
      select o.orpa_nume
        from come_orde_pago o, come_orde_pago_deta d, come_orde_pago_auto a
       where o.orpa_codi = d.deta_orpa_codi
         and o.orpa_codi = a.auto_orpa_codi
         and a.auto_esta = 'A'
         and d.deta_cuot_movi_codi = i_movi_codi;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 79);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando movimientos de entrada de produccion..');
  
    for k in c_cuot loop
    
      pp_get_erro(i_resp_codi      => 53,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_desc := replace(v_erro_desc, 'P_NRO', k.orpa_nume || '.');
      v_erro_codi := 53;
      raise salir;
    
    end loop;
  
    for k in c_auto loop
      pp_get_erro(i_resp_codi      => 53,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_desc := replace(v_erro_desc, 'P_NRO', k.orpa_nume || '.');
      v_erro_codi := 53;
      raise salir;
    end loop;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de OP: ' || sqlcode;
    
  end pp_vali_op;

  --validando remisiones..';
  procedure pp_vali_remi(i_movi_codi in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
  
    v_cont number(2);
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 82);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando remisiones..');
  
    select count(*)
      into v_cont
      from come_remi r
     where r.remi_come_movi_rece is not null
       and r.remi_movi_codi = i_movi_codi;
  
    if v_cont >= 1 then
      pp_get_erro(i_resp_codi      => 54,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 54;
      raise salir;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Remision: ' || sqlcode;
  end pp_vali_remi;

  --ultimas validaciones generales 
  procedure pp_vali_rela_op(i_movi_codi      in number,
                            i_movi_timo_codi in number,
                            o_resp_codi      out number,
                            o_resp_desc      out varchar2) is
  
    v_orpa_estado come_orde_pago.orpa_estado%type;
    v_cant_auto   number;
  
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 85);
    setitem('P34_PROGRESS_BAR_DESC',
            'Validando relaciones de Orden de Pago..');
  
    if i_movi_timo_codi = p_codi_timo_orde_pago then
      begin
        select nvl(o.orpa_estado, 'P')
          into v_orpa_estado
          from come_movi m, come_orde_pago o
         where m.movi_orpa_codi = o.orpa_codi
           and m.movi_timo_codi = p_codi_timo_orde_pago
           and m.movi_codi = i_movi_codi;
      
        if v_orpa_estado = 'F' then
          pp_get_erro(i_resp_codi      => 55,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          v_erro_codi := 55;
          raise salir;
        end if;
      exception
        when no_data_found then
          null;
      end;
    
      begin
        select count(*)
          into v_cant_auto
          from come_movi m, come_orde_pago o, come_orde_pago_auto a
         where m.movi_orpa_codi = o.orpa_codi
           and o.orpa_codi = a.auto_orpa_codi
           and m.movi_timo_codi = p_codi_timo_orde_pago
           and m.movi_codi = i_movi_codi
           and nvl(a.auto_esta, 'P') = 'A';
      
        if v_cant_auto > 0 then
          pp_get_erro(i_resp_codi      => 56,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          v_erro_codi := 56;
          raise salir;
        end if;
      exception
        when no_data_found then
          null;
      end;
    
    end if;
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de relacionamiento de OP: ' ||
                     sqlcode;
  end pp_vali_rela_op;

  --validando retencion emitida..
  procedure pp_vali_rete_emit(i_movi_codi      in number,
                              i_movi_timo_codi in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is
  
    v_cont number;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 88);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando retencion emitida..');
  
    if i_movi_timo_codi = p_codi_timo_rete_emit then
    
      begin
        select count(*)
          into v_cont
          from come_orde_pago o
         where o.orpa_rete_movi_codi = i_movi_codi;
      
        if nvl(v_cont, 0) > 0 then
          pp_get_erro(i_resp_codi      => 57,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          v_erro_codi := 57;
          raise salir;
        end if;
      exception
        when no_data_found then
          null;
      end;
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de retenciones emitidas: ' ||
                     sqlcode;
  end pp_vali_rete_emit;

  --validando desembolso de rrhh..';
  procedure pp_vali_dese_rrhh(i_movi_codi in number,
                              o_resp_codi out number,
                              o_resp_desc out varchar2) is
  
    v_count number;
  begin
  
    setitem('P34_PROGRESS_BAR_PORC', 90);
    setitem('P34_PROGRESS_BAR_DESC', 'Validando desembolso de rrhh..');
  
    ---validar que no sea un mov. de desembolso de rrhh
    select count(*)
      into v_count
      from rrhh_liqu
     where liqu_come_movi_codi = i_movi_codi;
  
    if v_count > 0 then
    
      pp_get_erro(i_resp_codi      => 58,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 58;
      raise salir;
    
    end if;
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      o_resp_codi := 1000;
      o_resp_desc := 'Error en Validacion de Desembolso de RRHH: ' ||
                     sqlcode;
  end pp_vali_dese_rrhh;

  /**********************************************************************/
  /************************* sub  validaciones  *************************/
  /**********************************************************************/

  procedure pp_vali_movi_canc(i_movi_codi      in number,
                              i_movi_codi_padr in number,
                              o_codi           out number) is
    v_cont number;
    salir  exception;
  begin
  
    o_codi := 0;
  
    select count(*)
      into v_cont
      from come_movi_cuot_canc, come_movi
     where canc_cuot_movi_codi = i_movi_codi
       and movi_codi = canc_movi_codi
       and canc_movi_codi not in
           (select movi_codi
              from come_movi
             where movi_codi = i_movi_codi_padr
                or movi_codi_padr = i_movi_codi_padr);
  
    if v_cont > 0 then
      o_codi := 1;
    end if;
  
    select count(*)
      into v_cont
      from roga_cuot_canc
     where canc_cuot_movi_codi = i_movi_codi;
  
    if v_cont > 0 then
      o_codi := 2;
    end if;
  
  end pp_vali_movi_canc;

  procedure pp_vali_cheq(i_movi_codi in number,
                         o_erro_desc out varchar2,
                         o_erro_codi out number) is
  
    cursor c_cheq_movi is
      select c.cheq_codi,
             c.cheq_nume,
             b.banc_desc,
             c.cheq_serie,
             mc.chmo_cheq_secu,
             m.movi_cuen_codi_reca,
             m.movi_fech_oper,
             c.cheq_cuen_codi
        from come_movi_cheq mc, come_cheq c, come_banc b, come_movi m
       where mc.chmo_cheq_codi = c.cheq_codi
         and b.banc_codi = c.cheq_banc_codi
         and mc.chmo_movi_codi = m.movi_codi
         and mc.chmo_movi_codi = i_movi_codi;
  
    cursor c_cheq(p_cheq_codi in number) is
      select i.moim_cuen_codi, i.moim_fech_oper
        from come_movi_impo_deta i
       where i.moim_cheq_codi = p_cheq_codi;
  
    v_count          number;
    v_caja_cuen_codi number;
    v_caja_fech      date;
    salir            exception;
  
    v_erro_cheq_desc varchar2(1000);
  
  begin
    for x in c_cheq_movi loop
    
      select count(*)
        into v_count
        from come_movi_cheq
       where chmo_cheq_codi = x.cheq_codi;
    
      if v_count > x.chmo_cheq_secu then
      
        pp_get_erro(i_resp_codi      => 28,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_cheq_desc);
      
        o_erro_desc := replace(replace(replace(v_erro_cheq_desc,
                                               'P_NUME_CHEQ',
                                               x.cheq_nume),
                                       'P_NUME_SERI',
                                       x.cheq_serie),
                               'P_BANC_DESC',
                               x.banc_desc);
        o_erro_codi := 28;
      
      end if;
    
    -- esto ya estaba comentado en el mismo forms juan britez 21/02/2022 
    /*if x.movi_cuen_codi_reca is not null then
                                                                                                  begin
                                                                                                    select c.caja_cuen_codi, c.caja_fech
                                                                                                      into v_caja_cuen_codi, v_caja_fech
                                                                                                      from come_cier_caja c
                                                                                                     where c.caja_cuen_codi = x.movi_cuen_codi_reca
                                                                                                       and c.caja_fech = x.movi_fech_oper;
                                                                                                    
                                                                                                    if v_caja_cuen_codi is not null then
                                                                                                      pl_mm('el documento forma parte de un cierre de caja de fecha: ' ||
                                                                                                            to_char(v_caja_fech, 'dd-mm-yyyy') || ' caja: ' || v_caja_cuen_codi);
                                                                                                      pack_general.g_indi_borrado := 'n';
                                                                                                      raise salir;
                                                                                                    end if;
                                                                                                    
                                                                                                  exception
                                                                                                    when no_data_found then
                                                                                                      null;
                                                                                                  end;
                                                                                              end if;*/
    
    /*if x.cheq_cuen_codi is not null then
                                                                                                  begin
                                                                                                    select c.caja_cuen_codi, c.caja_fech
                                                                                                      into v_caja_cuen_codi, v_caja_fech
                                                                                                      from come_cier_caja c
                                                                                                     where c.caja_cuen_codi = x.cheq_cuen_codi
                                                                                                       and c.caja_fech = x.movi_fech_oper;
                                                                                                    
                                                                                                    if v_caja_cuen_codi is not null then
                                                                                                      pl_mm('el documento forma parte de un cierre de caja de fecha: ' ||
                                                                                                            to_char(v_caja_fech, 'dd-mm-yyyy') || ' caja: ' || v_caja_cuen_codi);
                                                                                                      pack_general.g_indi_borrado := 'n';
                                                                                                      raise salir;
                                                                                                    end if;
                                                                                                    
                                                                                                  exception
                                                                                                    when no_data_found then
                                                                                                      null;
                                                                                                  end;
                                                                                              end if;*/
    
    /*for k in c_cheq(x.cheq_codi) loop
                                                                                                if k.moim_cuen_codi is not null then
                                                                                                    begin
                                                                                                      select c.caja_cuen_codi, c.caja_fech
                                                                                                        into v_caja_cuen_codi, v_caja_fech
                                                                                                        from come_cier_caja c
                                                                                                       where c.caja_cuen_codi = k.moim_cuen_codi
                                                                                                         and c.caja_fech = k.moim_fech_oper;
                                                                                                      
                                                                                                      if v_caja_cuen_codi is not null then
                                                                                                        pl_mm('el documento forma parte de un cierre de caja de fecha: ' ||
                                                                                                              to_char(v_caja_fech, 'dd-mm-yyyy') || ' caja: ' || v_caja_cuen_codi);
                                                                                                        pack_general.g_indi_borrado := 'n';
                                                                                                        raise salir;
                                                                                                      end if;
                                                                                                      
                                                                                                    exception
                                                                                                      when no_data_found then
                                                                                                        null;
                                                                                                    end;
                                                                                                end if;
                                                                                            end loop;*/
    
    end loop;
  
  end pp_vali_cheq;

  procedure pp_vali_cheq_dife(i_movi_codi in number,
                              o_erro_desc out varchar2,
                              o_erro_codi out number) is
  
    cursor c_cheq_movi_dife is
      select c.cheq_codi,
             c.cheq_nume,
             b.banc_desc,
             c.cheq_serie,
             mc.chmo_cheq_secu,
             m.movi_cuen_codi_reca,
             m.movi_fech_oper,
             c.cheq_cuen_codi
        from come_movi_cheq      mc,
             come_cheq           c,
             come_banc           b,
             come_movi           m,
             come_movi_dife_camb d
       where mc.chmo_cheq_codi = c.cheq_codi
         and b.banc_codi = c.cheq_banc_codi
         and mc.chmo_movi_codi = m.movi_codi
         and m.movi_codi = d.dica_movi_codi
         and mc.chmo_movi_codi = i_movi_codi;
  
    v_count          number;
    v_erro_cheq_desc varchar2(5000);
  
  begin
    for x in c_cheq_movi_dife loop
    
      select count(*)
        into v_count
        from come_movi_cheq
       where chmo_cheq_codi = x.cheq_codi;
    
      if v_count > 0 then
      
        pp_get_erro(i_resp_codi      => 29,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_cheq_desc);
      
        o_erro_desc := replace(replace(replace(v_erro_cheq_desc,
                                               'P_NUME_CHEQ',
                                               x.cheq_nume),
                                       'P_NUME_SERI',
                                       x.cheq_serie),
                               'P_BANC_DESC',
                               x.banc_desc);
        o_erro_codi := 29;
      
      end if;
    
    end loop;
  
  end pp_vali_cheq_dife;

  procedure pp_vali_rete(i_movi_codi in number,
                         o_erro_desc out varchar2,
                         o_erro_codi out number) is
  
    cursor c_rete_movi is
      select r.movi_codi, r.movi_nume, i.moim_cuen_codi, i.moim_fech_oper
        from come_movi_rete      mr,
             come_movi           m,
             come_movi           r,
             come_movi_impo_deta i
       where mr.more_movi_codi = m.movi_codi
         and mr.more_movi_codi_rete = r.movi_codi
         and r.movi_codi = i.moim_movi_codi
         and mr.more_movi_codi = i_movi_codi;
  
    cursor c_rete is
      select i.moim_cuen_codi, i.moim_fech_oper
        from come_movi_impo_deta i
       where lower(i.moim_tipo) like '%reten%'
         and i.moim_movi_codi = i_movi_codi;
  
    v_count          number;
    v_caja_cuen_codi number;
    v_caja_fech      date;
    v_erro_cheq_desc varchar2(5000);
  
    salir exception;
  
  begin
  
    for x in c_rete_movi loop
      if x.moim_cuen_codi is not null then
        begin
        
          select c.caja_cuen_codi, c.caja_fech
            into v_caja_cuen_codi, v_caja_fech
            from come_cier_caja c
           where c.caja_cuen_codi = x.moim_cuen_codi
             and c.caja_fech = x.moim_fech_oper;
        
          if v_caja_cuen_codi is not null then
          
            pp_get_erro(i_resp_codi      => 30,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_desc);
          
            o_erro_desc := replace(replace(v_erro_desc,
                                           'P_FECHA',
                                           to_char(v_caja_fech, 'dd-mm-yyyy')),
                                   'P_CAJA',
                                   v_caja_cuen_codi);
            o_erro_codi := 30;
          
          end if;
        
        exception
          when no_data_found then
            null;
        end;
      end if;
    
    end loop;
  
    for x in c_rete loop
      if x.moim_cuen_codi is not null then
        begin
        
          select c.caja_cuen_codi, c.caja_fech
            into v_caja_cuen_codi, v_caja_fech
            from come_cier_caja c
           where c.caja_cuen_codi = x.moim_cuen_codi
             and c.caja_fech = x.moim_fech_oper;
        
          if v_caja_cuen_codi is not null then
          
            pp_get_erro(i_resp_codi      => 30,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 116,
                        o_resp_desc      => v_erro_cheq_desc);
          
            o_erro_desc := replace(replace(v_erro_cheq_desc,
                                           'P_FECHA',
                                           to_char(v_caja_fech, 'dd-mm-yyyy')),
                                   'P_CAJA',
                                   v_caja_cuen_codi);
            o_erro_codi := 30;
          
          end if;
        
        exception
          when no_data_found then
            null;
        end;
      
      end if;
    end loop;
  
  end pp_vali_rete;

  procedure pp_vali_tarj_cupo(i_movi_codi in number,
                              o_erro_desc out varchar2,
                              o_erro_codi out number) is
  
    cursor c_cupo_movi is
      select mota_tacu_codi, mota_movi_codi, mota_esta_ante, mota_nume_orde
        from come_movi_tarj_cupo, come_tarj_cupo
       where mota_tacu_codi = tacu_codi
         and mota_movi_codi = i_movi_codi;
  
    v_count number;
    salir   exception;
  
    v_movi_codi number;
    v_movi_nume number;
    v_movi_fech varchar2(20);
  
  begin
  
    for x in c_cupo_movi loop
      select count(*)
        into v_count
        from come_movi_tarj_cupo
       where mota_tacu_codi = x.mota_tacu_codi;
    
      if v_count > x.mota_nume_orde then
      
        begin
        
          select mota_movi_codi
            into v_movi_codi
            from come_movi_tarj_cupo
           where mota_tacu_codi = x.mota_tacu_codi
             and mota_nume_orde =
                 (select max(mota_nume_orde)
                    from come_movi_tarj_cupo
                   where mota_tacu_codi = x.mota_tacu_codi);
        
          select movi_nume, to_char(movi_fech_emis, 'dd-mm-yyyy')
            into v_movi_nume, v_movi_fech
            from come_movi
           where movi_codi = v_movi_codi;
        
          pp_get_erro(i_resp_codi      => 31,
                      i_resp_orig      => 1,
                      i_resp_segu_pant => 116,
                      o_resp_desc      => v_erro_desc);
        
          o_erro_desc := replace(replace(v_erro_desc, 'P_NRO', v_movi_nume),
                                 'P_FECHA',
                                 v_movi_fech);
          o_erro_codi := 31;
        end;
      
      end if;
    end loop;
  
  end pp_vali_tarj_cupo;

  procedure pp_vali_fact_depo(i_movi_codi in number,
                              o_erro_desc out varchar2,
                              o_erro_codi out number) is
  
    cursor c_movi_depo is
      select f.movi_codi, f.movi_nume
        from come_movi f, come_movi_fact_depo fd
       where f.movi_codi = fd.fade_movi_codi_fact -- factura
         and fd.fade_movi_codi_depo = i_movi_codi; -- deposito
  
    v_count number;
  begin
    --- verifica si deposito tiene factura..
    for x in c_movi_depo loop
      select count(*)
        into v_count
        from come_movi_fact_depo
       where fade_movi_codi_fact = x.movi_codi;
    
      if nvl(v_count, 0) > 0 then
      
        pp_get_erro(i_resp_codi      => 32,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 116,
                    o_resp_desc      => v_erro_desc);
      
        o_erro_desc := replace(v_erro_desc, 'P_NRO', x.movi_nume);
        o_erro_codi := 32;
      
      end if;
    end loop;
  
  end pp_vali_fact_depo;

  procedure pp_vali_orde_pago(i_movi_codi in number,
                              o_erro_desc out varchar2,
                              o_erro_codi out number) is
  
    cursor c_cuot is
      select o.orpa_nume
        from come_orde_pago o, come_orde_pago_deta d
       where o.orpa_codi = d.deta_orpa_codi
         and d.deta_cuot_movi_codi = i_movi_codi;
  
    cursor c_auto is
      select o.orpa_nume
        from come_orde_pago o, come_orde_pago_deta d, come_orde_pago_auto a
       where o.orpa_codi = d.deta_orpa_codi
         and o.orpa_codi = a.auto_orpa_codi
         and a.auto_esta = 'A'
         and d.deta_cuot_movi_codi = i_movi_codi;
  
  begin
  
    for k in c_cuot loop
    
      pp_get_erro(i_resp_codi      => 33,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      o_erro_desc := replace(v_erro_desc, 'P_NRO', k.orpa_nume);
      o_erro_codi := 33;
    
    end loop;
  
    for k in c_auto loop
    
      pp_get_erro(i_resp_codi      => 34,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      o_erro_desc := replace(v_erro_desc, 'P_NRO', k.orpa_nume);
      o_erro_codi := 34;
    
    end loop;
  
  end pp_vali_orde_pago;

  procedure pp_vali_movi_canc(i_movi_codi      in number,
                              i_movi_codi_padr in number,
                              o_resp_codi      out number,
                              o_resp_desc      out varchar2) is
    v_cont number;
  begin
  
    select count(*)
      into v_cont
      from come_movi_cuot_canc, come_movi
     where canc_cuot_movi_codi = i_movi_codi
       and movi_codi = canc_movi_codi
       and canc_movi_codi not in
           (select movi_codi
              from come_movi
             where movi_codi = i_movi_codi_padr
                or movi_codi_padr = i_movi_codi_padr);
  
    if v_cont > 0 then
    
      pp_get_erro(i_resp_codi      => 24,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      o_resp_codi := 24;
      o_resp_desc := v_erro_desc;
    
    end if;
  
    select count(*)
      into v_cont
      from roga_cuot_canc
     where canc_cuot_movi_codi = i_movi_codi;
  
    if v_cont > 0 then
    
      pp_get_erro(i_resp_codi      => 24,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      o_resp_codi := 24;
      o_resp_desc := v_erro_desc;
    
    end if;
  
  end pp_vali_movi_canc;

  /**********************************************************************/
  /************************ m o d a l e s *******************************/
  /**********************************************************************/

  procedure pp_carg_asie(i_movi_codi in number) is
  
    cursor c_movi_asie is
      select moas_asie_codi, moas_tipo
        from come_movi_asie
       where moas_movi_codi = i_movi_codi;
    --------
    cursor c_movi_cheq is
      select chmo_cheq_codi
        from come_movi_cheq mc
       where chmo_movi_codi = i_movi_codi;
  
    cursor c_movi_cheq_asie(p_cheq_codi in number) is
      select chas_asie_codi
        from come_movi_cheq_asie a
       where chas_chmo_movi_codi = i_movi_codi
         and chas_chmo_cheq_codi = p_cheq_codi;
    ---------  
    cursor c_movi_impo_asie(p_nume_item in number) is
      select asim_asie_codi
        from come_movi_impo_deta_asie
       where asim_movi_codi = i_movi_codi
         and asim_nume_item = p_nume_item;
    ---------
    cursor c_movi_codi_padr is
      select movi_codi_padr
        from come_movi m
       where m.movi_codi = i_movi_codi;
  
    cursor c_movi_impo_asie_02(p_movi_codi_padr in number,
                               p_nume_item      in number) is
      select asim_asie_codi
        from come_movi_impo_deta_asie
       where asim_movi_codi = p_movi_codi_padr
         and asim_nume_item = p_nume_item;
    ----------
    cursor c_movi_cuot_canc is
      select canc_cuot_movi_codi, canc_cuot_fech_venc
        from come_movi m, come_movi_cuot_canc
       where movi_codi = i_movi_codi
         and movi_codi = canc_movi_codi;
  
    cursor c_movi_cuot_canc_asie(p_movi_codi_canc in number,
                                 p_fech_venc      in date) is
      select caas_asie_codi
        from come_movi_cuot_canc_asie
       where caas_canc_movi_codi = i_movi_codi
         and caas_canc_cuot_movi_codi = p_movi_codi_canc
         and caas_canc_cuot_fech_venc = p_fech_venc;
    ----------     
    cursor c_movi_prod_asie(p_nume_item in number) is
      select deas_asie_codi
        from come_movi_prod_deta_asie a
       where deas_movi_codi = i_movi_codi
         and deas_nume_item = p_nume_item;
    ----------
    cursor c_movi_pres_deve_asie(p_nume_item in number) is
      select deas_asie_codi
        from come_movi_cuot_pres_deve_asie
       where deas_cude_movi_codi = i_movi_codi
         and deas_cude_nume_item = p_nume_item;
    ----------
    cursor c_movi_apli_tick_asie is
      select tias_asie_codi
        from come_movi_apli_tick_asie
       where tias_moti_codi = i_movi_codi;
    ----------
  
    v_cant_item number := 0;
  
  begin
  
    begin
      pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => v('APP_SESSION'),
                                         i_taax_user => gen_user);
    end;
  
    -----------come_movi_asie-------------------------------  
    for x in c_movi_asie loop
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006)
        select v('APP_SESSION'),
               gen_user,
               seq_come_tabl_auxi.nextval,
               to_char(x.moas_asie_codi),
               nvl(x.moas_tipo, 'A'),
               to_char(asie_nume),
               to_char(asie_fech_emis),
               to_char(asie_obse),
               'ASIENTO'
          from come_asie
         where asie_codi = x.moas_asie_codi;
    
    end loop;
  
    -----------come_movi_cheq-------------------------------  
    for y in c_movi_cheq loop
      for x in c_movi_cheq_asie(y.chmo_cheq_codi) loop
      
        insert into come_tabl_auxi
          (taax_sess,
           taax_user,
           taax_seq,
           taax_c001,
           taax_c002,
           taax_c003,
           taax_c004,
           taax_c005,
           taax_c006)
          select v('APP_SESSION'),
                 gen_user,
                 seq_come_tabl_auxi.nextval,
                 to_char(x.chas_asie_codi),
                 null,
                 to_char(asie_nume),
                 to_char(asie_fech_emis),
                 to_char(asie_obse),
                 'ASIENTO'
            from come_asie
           where asie_codi = x.chas_asie_codi;
      
      end loop;
    end loop;
  
    -----------come_movi_impo_deta--------------------------  
    begin
      select max(moim_nume_item)
        into v_cant_item
        from come_movi_impo_deta
       where moim_movi_codi = i_movi_codi;
    exception
      when no_data_found then
        v_cant_item := 0;
    end;
  
    if v_cant_item <> 0 then
      for y in 1 .. v_cant_item loop
        for x in c_movi_impo_asie(y) loop
        
          insert into come_tabl_auxi
            (taax_sess,
             taax_user,
             taax_seq,
             taax_c001,
             taax_c002,
             taax_c003,
             taax_c004,
             taax_c005,
             taax_c006)
            select v('APP_SESSION'),
                   gen_user,
                   seq_come_tabl_auxi.nextval,
                   to_char(x.asim_asie_codi),
                   null,
                   to_char(asie_nume),
                   to_char(asie_fech_emis),
                   to_char(asie_obse),
                   'ASIENTO'
              from come_asie
             where asie_codi = x.asim_asie_codi;
        
        end loop;
      end loop;
    end if;
  
    -----------come_movi_impo_deta_02-------------------------- 
    for z in c_movi_codi_padr loop
      begin
        select max(moim_nume_item)
          into v_cant_item
          from come_movi_impo_deta
         where moim_movi_codi = z.movi_codi_padr;
      exception
        when no_data_found then
          v_cant_item := 0;
      end;
    
      if v_cant_item <> 0 then
        for y in 1 .. v_cant_item loop
          for x in c_movi_impo_asie_02(z.movi_codi_padr, y) loop
          
            insert into come_tabl_auxi
              (taax_sess,
               taax_user,
               taax_seq,
               taax_c001,
               taax_c002,
               taax_c003,
               taax_c004,
               taax_c005,
               taax_c006)
              select v('APP_SESSION'),
                     gen_user,
                     seq_come_tabl_auxi.nextval,
                     to_char(x.asim_asie_codi),
                     null,
                     to_char(asie_nume),
                     to_char(asie_fech_emis),
                     to_char(asie_obse),
                     'ASIENTO'
                from come_asie
               where asie_codi = x.asim_asie_codi;
          
          end loop;
        end loop;
      end if;
    end loop;
  
    -----------come_movi_cuot_canc------------------------------- 
    for y in c_movi_cuot_canc loop
      for x in c_movi_cuot_canc_asie(y.canc_cuot_movi_codi, y.canc_cuot_fech_venc) loop
      
        insert into come_tabl_auxi
          (taax_sess,
           taax_user,
           taax_seq,
           taax_c001,
           taax_c002,
           taax_c003,
           taax_c004,
           taax_c005,
           taax_c006)
          select v('APP_SESSION'),
                 gen_user,
                 seq_come_tabl_auxi.nextval,
                 to_char(x.caas_asie_codi),
                 null,
                 to_char(asie_nume),
                 to_char(asie_fech_emis),
                 to_char(asie_obse),
                 'ASIENTO'
            from come_asie
           where asie_codi = x.caas_asie_codi;
      
      end loop;
    end loop;
  
    -----------come_movi_prod_deta--------------------------  
    begin
      select max(deta_nume_item)
        into v_cant_item
        from come_movi_prod_deta
       where deta_movi_codi = i_movi_codi;
    exception
      when no_data_found then
        v_cant_item := 0;
    end;
  
    if v_cant_item <> 0 then
      for y in 1 .. v_cant_item loop
        for x in c_movi_prod_asie(y) loop
        
          insert into come_tabl_auxi
            (taax_sess,
             taax_user,
             taax_seq,
             taax_c001,
             taax_c002,
             taax_c003,
             taax_c004,
             taax_c005,
             taax_c006)
            select v('APP_SESSION'),
                   gen_user,
                   seq_come_tabl_auxi.nextval,
                   to_char(x.deas_asie_codi),
                   null,
                   to_char(asie_nume),
                   to_char(asie_fech_emis),
                   to_char(asie_obse),
                   'ASIENTO'
              from come_asie
             where asie_codi = x.deas_asie_codi;
        
        end loop;
      end loop;
    end if;
  
    -----------come_movi_cuot_pres_deve-------------------------- 
    begin
      select max(cude_nume_item)
        into v_cant_item
        from come_movi_cuot_pres_deve
       where cude_movi_codi = i_movi_codi;
    exception
      when no_data_found then
        v_cant_item := 0;
    end;
  
    if v_cant_item <> 0 then
      for y in 1 .. v_cant_item loop
        for x in c_movi_pres_deve_asie(y) loop
        
          insert into come_tabl_auxi
            (taax_sess,
             taax_user,
             taax_seq,
             taax_c001,
             taax_c002,
             taax_c003,
             taax_c004,
             taax_c005,
             taax_c006)
            select v('APP_SESSION'),
                   gen_user,
                   seq_come_tabl_auxi.nextval,
                   to_char(x.deas_asie_codi),
                   null,
                   to_char(asie_nume),
                   to_char(asie_fech_emis),
                   to_char(asie_obse),
                   'ASIENTO'
              from come_asie
             where asie_codi = x.deas_asie_codi;
        
        end loop;
      end loop;
    end if;
  
    -----------come_movi_apli_tick-------------------------------  
    for x in c_movi_apli_tick_asie loop
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006)
        select v('APP_SESSION'),
               gen_user,
               seq_come_tabl_auxi.nextval,
               to_char(x.tias_asie_codi),
               null,
               to_char(asie_nume),
               to_char(asie_fech_emis),
               to_char(asie_obse),
               'ASIENTO'
          from come_asie
         where asie_codi = x.tias_asie_codi;
    
    end loop;
  
  exception
    when others then
      raise_application_error(-20010,
                              'Error al momento de cargar Asientos. ' ||
                              sqlcode);
  end pp_carg_asie;

  procedure pp_carg_caja(i_movi_codi in number) is
  
    type tr_caja is record(
      session        number,
      login          varchar2(50),
      moim_movi_codi come_movi_impo_deta.moim_movi_codi%type,
      moim_nume_item come_movi_impo_deta.moim_nume_item%type,
      moim_tipo      come_movi_impo_deta.moim_tipo%type,
      moim_cuen_codi come_movi_impo_deta.moim_cuen_codi%type,
      moim_dbcr      varchar2(500),
      moim_afec_caja come_movi_impo_deta.moim_afec_caja%type,
      moim_fech      come_movi_impo_deta.moim_fech%type,
      moim_asie_codi come_movi_impo_deta.moim_asie_codi%type,
      moim_impo_mone come_movi_impo_deta.moim_impo_mone%type,
      moim_impo_mmnn come_movi_impo_deta.moim_impo_mmnn%type,
      secuencia      number);
  
    type tt_caja is table of tr_caja index by binary_integer;
    ta_caja tt_caja;
  
    e_caja exception;
  
    asie_nume         come_asie.asie_nume%type;
    moim_impo_mone_db come_movi_impo_deta.moim_impo_mone%type;
    moim_impo_mone_cr come_movi_impo_deta.moim_impo_mone%type;
    moim_impo_mmnn_db come_movi_impo_deta.moim_impo_mmnn%type;
    moim_impo_mmnn_cr come_movi_impo_deta.moim_impo_mmnn%type;
    v_cant_regi       number;
  
  begin
  
    select v('APP_SESSION'),
           gen_user,
           d.moim_movi_codi,
           d.moim_nume_item,
           d.moim_tipo,
           d.moim_cuen_codi,
           decode(d.moim_dbcr, 'C', 'Credito', 'D', 'Debito') moim_dbcr,
           d.moim_afec_caja,
           d.moim_fech,
           d.moim_asie_codi,
           d.moim_impo_mone,
           d.moim_impo_mmnn,
           seq_come_tabl_auxi.nextval
      bulk collect
      into ta_caja
      from come_movi_impo_deta d, come_movi m
     where d.moim_movi_codi = m.movi_codi
       and m.movi_codi = i_movi_codi;
  
    pack_mane_tabl_auxi.pp_trunc_table(v('APP_SESSION'), gen_user);
  
    --cargar importe solamente si tiene paga en efectivo
    v_cant_regi := ta_caja.count;
  
    for x in 1 .. v_cant_regi loop
    
      if ta_caja(x).moim_asie_codi is not null then
      
        begin
        
          select asie_nume
            into asie_nume
            from come_asie
           where asie_codi = ta_caja(x).moim_asie_codi;
        
        exception
          when no_data_found then
            raise e_caja;
        end;
      
        if ta_caja(x).moim_dbcr = 'Debito' then
          moim_impo_mone_db := ta_caja(x).moim_impo_mone;
          moim_impo_mone_cr := 0;
          moim_impo_mmnn_db := ta_caja(x).moim_impo_mmnn;
          moim_impo_mmnn_cr := 0;
        else
          moim_impo_mone_cr := ta_caja(x).moim_impo_mone;
          moim_impo_mone_db := 0;
          moim_impo_mmnn_cr := ta_caja(x).moim_impo_mmnn;
          moim_impo_mmnn_db := 0;
        end if;
      
      end if;
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006,
         taax_c007,
         taax_c008,
         taax_c009,
         taax_c010,
         taax_c011,
         taax_c012,
         taax_c013,
         taax_c014,
         taax_c015,
         taax_seq)
      values
        (ta_caja          (x).session,
         ta_caja          (x).login,
         ta_caja          (x).moim_movi_codi,
         ta_caja          (x).moim_nume_item,
         ta_caja          (x).moim_tipo,
         ta_caja          (x).moim_cuen_codi,
         ta_caja          (x).moim_dbcr,
         ta_caja          (x).moim_afec_caja,
         ta_caja          (x).moim_fech,
         ta_caja          (x).moim_asie_codi,
         ta_caja          (x).moim_impo_mone,
         ta_caja          (x).moim_impo_mmnn,
         moim_impo_mone_db,
         moim_impo_mone_cr,
         moim_impo_mmnn_db,
         moim_impo_mmnn_cr,
         asie_nume,
         ta_caja          (x).secuencia);
    
    end loop;
  
    /*  :bcaja.s_neto      := nvl(:bcaja.s_total_importe_db, 0) -
                            nvl(:bcaja.s_total_importe_cr, 0);
      :bcaja.s_neto_mmnn := nvl(:bcaja.s_tota_importe_db_mmnn, 0) -
                            nvl(:bcaja.s_total_importe_cr_mmnn, 0);
      pp_muestra_cuen_banc(:bcaja.moim_cuen_codi, :bcaja.moim_cuen_desc);
    */
  
  exception
    when e_caja then
      raise_application_error(-20010, 'Numero de asiento inexistente!');
    
  end pp_carg_caja;

  procedure pp_carg_impu(i_impu_codi in number) is
  
    type tr_impu is record(
      session        number,
      login          varchar2(50),
      moim_movi_codi come_movi_impu_deta.moim_movi_codi%type,
      moim_impu_codi come_movi_impu_deta.moim_impu_codi%type,
      impu_desc      come_impu.impu_desc%type,
      moim_tiim_desc come_tipo_impu.tiim_desc%type,
      moim_impo_mone come_movi_impu_deta.moim_impo_mone%type,
      moin_impu_mone come_movi_impu_deta.moim_impu_mone%type,
      moin_impo_mmnn come_movi_impu_deta.moim_impo_mmnn%type,
      moin_impu_mmnn come_movi_impu_deta.moim_impu_mmnn%type,
      moin_impo_mmee come_movi_impu_deta.moim_impo_mmee%type,
      moin_impu_mmee come_movi_impu_deta.moim_impu_mmee%type,
      secuencia      number);
  
    type tt_impu is table of tr_impu index by binary_integer;
    ta_impu tt_impu;
  
  begin
  
    select v('APP_SESSION'),
           gen_user login,
           moim_movi_codi,
           moim_impu_codi,
           case
             when moim_impu_codi is not null then
              (select impu_desc
                 from come_impu
                where impu_codi = moim_impu_codi)
             else
              null
           end,
           case
             when moim_tiim_codi is not null then
              (select tiim_desc
                 from come_tipo_impu
                where tiim_codi = moim_tiim_codi)
             else
              null
           end,
           moim_impo_mone,
           moim_impu_mone,
           moim_impo_mmnn,
           moim_impu_mmnn,
           moim_impo_mmee,
           moim_impu_mmee,
           seq_come_tabl_auxi.nextval secuencia
      bulk collect
      into ta_impu
      from come_movi_impu_deta
     where moim_movi_codi = i_impu_codi;
  
    pack_mane_tabl_auxi.pp_trunc_table(v('APP_SESSION'), gen_user);
  
    v_cant_regi := ta_impu.count;
  
    for x in 1 .. v_cant_regi loop
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006,
         taax_c007,
         taax_c008,
         taax_c009,
         taax_c010,
         taax_seq)
      values
        (ta_impu(x).session,
         ta_impu(x).login,
         ta_impu(x).moim_movi_codi,
         ta_impu(x).moim_impu_codi,
         ta_impu(x).impu_desc,
         ta_impu(x).moim_tiim_desc,
         ta_impu(x).moim_impo_mone,
         ta_impu(x).moin_impu_mone,
         ta_impu(x).moin_impo_mmnn,
         ta_impu(x).moin_impu_mmnn,
         ta_impu(x).moin_impo_mmee,
         ta_impu(x).moin_impu_mmee,
         ta_impu(x).secuencia);
    
    end loop;
  
  end pp_carg_impu;

  procedure pp_carg_canc(i_canc_movi_codi in number) is
  
    type tr_canc is record(
      session             number,
      login               varchar2(50),
      canc_cuot_movi_codi come_movi_cuot_canc.canc_cuot_movi_codi%type,
      canc_asie_codi      come_movi_cuot_canc.canc_asie_codi%type,
      canc_movi_codi      come_movi_cuot_canc.canc_movi_codi%type,
      canc_fech_pago      come_movi_cuot_canc.canc_fech_pago%type,
      canc_cuot_fech_venc come_movi_cuot_canc.canc_cuot_fech_venc%type,
      canc_impo_mone      come_movi_cuot_canc.canc_impo_mone%type,
      canc_impo_mmnn      come_movi_cuot_canc.canc_impo_mmnn%type,
      canc_impo_mmee      come_movi_cuot_canc.canc_impo_mmee%type,
      canc_impo_dife_camb come_movi_cuot_canc.canc_impo_dife_camb%type,
      --  asie_nume           come_asie.asie_nume%type,
      secuencia number);
  
    type tt_canc is table of tr_canc index by binary_integer;
    ta_canc tt_canc;
  
  begin
  
    select v('APP_SESSION'),
           gen_user,
           canc_cuot_movi_codi,
           canc_asie_codi,
           canc_movi_codi,
           canc_fech_pago,
           canc_cuot_fech_venc,
           canc_impo_mone,
           canc_impo_mmnn,
           canc_impo_mmee,
           canc_impo_dife_camb,
           seq_come_tabl_auxi.nextval
      bulk collect
      into ta_canc
      from come_movi_cuot_canc
     where canc_movi_codi = i_canc_movi_codi;
  
    pack_mane_tabl_auxi.pp_trunc_table(v('APP_SESSION'), gen_user);
  
    --cargar en la tabla temporal las cancelaciones
    v_cant_regi := ta_canc.count;
  
    for x in 1 .. v_cant_regi loop
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006,
         taax_c007,
         taax_c008,
         taax_c009,
         taax_seq)
      values
        (ta_canc(x).session,
         ta_canc(x).login,
         ta_canc(x).canc_cuot_movi_codi,
         ta_canc(x).canc_asie_codi,
         ta_canc(x).canc_movi_codi,
         ta_canc(x).canc_fech_pago,
         ta_canc(x).canc_cuot_fech_venc,
         ta_canc(x).canc_impo_mone,
         ta_canc(x).canc_impo_mmnn,
         ta_canc(x).canc_impo_mmee,
         ta_canc(x).canc_impo_dife_camb,
         ta_canc(x).secuencia);
    
    end loop;
  
  end pp_carg_canc;

  procedure pp_carg_conc(i_movi_codi in number) is
  
    type tr_conc is record(
      session             number,
      login               varchar2(50),
      moco_nume_item      come_movi_conc_deta.moco_nume_item%type,
      moco_conc_codi      come_movi_conc_deta.moco_conc_codi%type,
      moco_dbcr           come_movi_conc_deta.moco_dbcr%type,
      tiim_desc           come_tipo_impu.tiim_desc%type,
      impu_desc           come_impu.impu_desc%type,
      impu_porc_base_impo come_impu.impu_porc_base_impo%type,
      impu_porc           come_impu.impu_porc%type,
      moco_impo_mone      come_movi_conc_deta.moco_impo_mone%type,
      moco_impo_mmnn      come_movi_conc_deta.moco_impo_mmnn%type,
      conc_dbcr           come_conc.conc_dbcr%type,
      conc_desc           come_conc.conc_desc%type,
      secuencia           number);
  
    type tt_conc is table of tr_conc index by binary_integer;
    ta_conc tt_conc;
  
  begin
  
    select v('APP_SESSION'),
           gen_user,
           moco_nume_item,
           moco_conc_codi,
           moco_dbcr,
           (select tiim_desc
              from come_tipo_impu
             where tiim_codi = moco_tiim_codi),
           (select impu_desc from come_impu where impu_codi = moco_impu_codi),
           (select impu_porc_base_impo
              from come_impu
             where impu_codi = moco_impu_codi),
           (select impu_porc from come_impu where impu_codi = moco_impu_codi),
           moco_impo_mone,
           moco_impo_mmnn,
           (select conc_dbcr from come_conc where conc_codi = moco_conc_codi),
           (select conc_desc from come_conc where conc_codi = moco_conc_codi),
           seq_come_tabl_auxi.nextval
      bulk collect
      into ta_conc
      from come_movi_conc_deta
     where moco_movi_codi = i_movi_codi;
  
    pack_mane_tabl_auxi.pp_trunc_table(v('APP_SESSION'), gen_user);
    --cargar en la tabla temporal el concepto
    v_cant_regi := ta_conc.count;
  
    for x in 1 .. v_cant_regi loop
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006,
         taax_c007,
         taax_c008,
         taax_c009,
         taax_c010,
         taax_c011,
         taax_seq)
      values
        (ta_conc(x).session,
         ta_conc(x).login,
         ta_conc(x).moco_nume_item,
         ta_conc(x).moco_conc_codi,
         ta_conc(x).moco_dbcr,
         ta_conc(x).tiim_desc,
         ta_conc(x).impu_desc,
         ta_conc(x).impu_porc_base_impo,
         ta_conc(x).impu_porc,
         ta_conc(x).moco_impo_mone,
         ta_conc(x).moco_impo_mmnn,
         ta_conc(x).conc_dbcr,
         ta_conc(x).conc_desc,
         ta_conc(x).secuencia);
    
    end loop;
  
  end pp_carg_conc;

  procedure pp_carg_prod(i_movi_codi in number) is
  
    type tr_prod is record(
      session        number,
      login          varchar2(50),
      deta_nume_item come_movi_prod_deta.deta_nume_item%type,
      deta_cant      come_movi_prod_deta.deta_cant%type,
      deta_prec_unit come_movi_prod_deta.deta_prec_unit%type,
      deta_porc_deto come_movi_prod_deta.deta_porc_deto%type,
      deta_impu_codi come_movi_prod_deta.deta_impu_codi%type,
      lote_desc      come_lote.lote_desc%type,
      deta_impo_mone come_movi_prod_deta.deta_impo_mone%type,
      deta_iva_mone  come_movi_prod_deta.deta_iva_mone%type,
      prod_codi_alfa come_prod.prod_codi_alfa%type,
      prod_desc      come_prod.prod_desc%type,
      impu_desc      come_impu.impu_desc%type,
      secuencia      number);
  
    type tt_prod is table of tr_prod index by binary_integer;
    ta_prod tt_prod;
  
  begin
  
    select v('APP_SESSION'),
           gen_user,
           deta_nume_item,
           deta_cant,
           deta_prec_unit,
           deta_porc_deto,
           deta_impu_codi,
           (select lote_desc from come_lote where lote_codi = deta_lote_codi),
           deta_impo_mone,
           deta_iva_mone,
           (select prod_codi_alfa
              from come_prod
             where prod_codi = deta_prod_codi),
           (select prod_desc from come_prod where prod_codi = deta_prod_codi),
           (select impu_desc from come_impu where impu_codi = deta_impu_codi),
           seq_come_tabl_auxi.nextval
      bulk collect
      into ta_prod
      from come_movi_prod_deta
     where deta_movi_codi = i_movi_codi;
  
    pack_mane_tabl_auxi.pp_trunc_table(v('APP_SESSION'), gen_user);
    --cargar en la tabla temporal el concepto
    v_cant_regi := ta_prod.count;
  
    for x in 1 .. v_cant_regi loop
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006,
         taax_c007,
         taax_c008,
         taax_c009,
         taax_c010,
         taax_c011,
         taax_seq)
      values
        (ta_prod(x).session,
         ta_prod(x).login,
         ta_prod(x).deta_nume_item,
         ta_prod(x).deta_cant,
         ta_prod(x).deta_prec_unit,
         ta_prod(x).deta_porc_deto,
         ta_prod(x).deta_impu_codi,
         ta_prod(x).lote_desc,
         ta_prod(x).deta_impo_mone,
         ta_prod(x).deta_iva_mone,
         ta_prod(x).prod_codi_alfa,
         ta_prod(x).prod_desc,
         ta_prod(x).impu_desc,
         ta_prod(x).secuencia);
    
    end loop;
  
  end pp_carg_prod;

  procedure pp_carg_prod_ortr(i_movi_codi in number) is
  
    type tr_prod is record(
      session        number,
      login          varchar2(50),
      deta_nume_item come_movi_prod_deta.deta_nume_item%type,
      deta_cant      come_movi_prod_deta.deta_cant%type,
      deta_prec_unit come_movi_prod_deta.deta_prec_unit%type,
      deta_porc_deto come_movi_prod_deta.deta_porc_deto%type,
      deta_impu_codi come_movi_prod_deta.deta_impu_codi%type,
      deta_impo_mone come_movi_prod_deta.deta_impo_mone%type,
      deta_iva_mone  come_movi_prod_deta.deta_iva_mone%type,
      prod_codi_alfa come_prod.prod_codi_alfa%type,
      prod_desc      come_prod.prod_desc%type,
      impu_desc      come_impu.impu_desc%type,
      secuencia      number);
  
    type tt_prod is table of tr_prod index by binary_integer;
    ta_prod tt_prod;
  
  begin
  
    select v('APP_SESSION'),
           gen_user,
           deta_nume_item,
           deta_cant,
           deta_prec_unit,
           deta_porc_deto,
           deta_impu_codi,
           deta_impo_mone,
           deta_iva_mone,
           (select prod_codi_alfa
              from come_prod
             where prod_codi = deta_prod_codi),
           (select prod_desc from come_prod where prod_codi = deta_prod_codi),
           (select impu_desc from come_impu where impu_codi = deta_impu_codi),
           seq_come_tabl_auxi.nextval
      bulk collect
      into ta_prod
      from come_movi_ortr_prod_deta
     where deta_movi_codi = i_movi_codi;
  
    pack_mane_tabl_auxi.pp_trunc_table(v('APP_SESSION'), gen_user);
    --cargar en la tabla temporal el concepto
    v_cant_regi := ta_prod.count;
  
    for x in 1 .. v_cant_regi loop
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006,
         taax_c007,
         taax_c008,
         taax_c009,
         taax_c010,
         taax_seq)
      values
        (ta_prod(x).session,
         ta_prod(x).login,
         ta_prod(x).deta_nume_item,
         ta_prod(x).deta_cant,
         ta_prod(x).deta_prec_unit,
         ta_prod(x).deta_porc_deto,
         ta_prod(x).deta_impu_codi,
         ta_prod(x).deta_impo_mone,
         ta_prod(x).deta_iva_mone,
         ta_prod(x).prod_codi_alfa,
         ta_prod(x).prod_desc,
         ta_prod(x).impu_desc,
         ta_prod(x).secuencia);
    
    end loop;
  
  end pp_carg_prod_ortr;

  /**********************************************************************/
  /***********************r e p o r t e s *******************************/
  /**********************************************************************/

  procedure pp_carg_repo_asie(i_nume_asie in number) is
  
    type tr_asie_repo is record(
      session        number,
      login          varchar2(50),
      asie_codi      come_asie.asie_codi%type,
      asie_nume      come_asie.asie_nume%type,
      asie_fech_emis come_asie.asie_fech_emis%type,
      asie_obse      come_asie.asie_obse%type,
      asie_indi_manu come_asie.asie_indi_manu%type,
      cuco_nume      come_cuen_cont.cuco_nume%type,
      cuco_desc      come_cuen_cont.cuco_desc%type,
      movi_obse      varchar2(500),
      movi_clpr_codi number,
      deta_indi_dbcr varchar2(50),
      debe_mmnn      number,
      habe_mmnn      number,
      debe_mmee      number,
      habe_mmee      number,
      deta_nume_item come_asie_deta.deta_nume_item%type,
      movi_clpr_desc varchar2(500),
      secuencia      number);
  
    type tt_asien is table of tr_asie_repo index by binary_integer;
    ta_asien tt_asien;
  
    v_cant_regi number := 0;
    v_para      varchar2(500);
    v_cont      varchar2(500);
    v_repo      varchar2(500);
  
  begin
  
    begin
      pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => v('APP_SESSION'),
                                         i_taax_user => gen_user);
    end;
  
    select v('APP_SESSION'),
           gen_user,
           asie_codi,
           asie_nume,
           asie_fech_emis,
           asie_obse,
           asie_indi_manu,
           cuco_nume,
           cuco_desc,
           movi_obse,
           movi_clpr_codi,
           deta_indi_dbcr,
           debe_mmnn,
           habe_mmnn,
           debe_mmee,
           habe_mmee,
           deta_nume_item,
           movi_clpr_desc,
           seq_come_tabl_auxi.nextval
      bulk collect
      into ta_asien
      from (select a.asie_codi,
                   a.asie_nume,
                   a.asie_fech_emis,
                   a.asie_obse,
                   a.asie_indi_manu,
                   c.cuco_nume,
                   c.cuco_desc,
                   m.movi_obse,
                   m.movi_clpr_codi,
                   decode(d.deta_indi_dbcr, ' D ', ' Debe ', ' H ', 'Haber') deta_indi_dbcr,
                   decode(d.deta_indi_dbcr,
                          ' D ',
                          nvl(d.deta_impo_mmnn, 0),
                          0) debe_mmnn,
                   decode(d.deta_indi_dbcr,
                          ' H ',
                          nvl(d.deta_impo_mmnn, 0),
                          0) habe_mmnn,
                   decode(d.deta_indi_dbcr,
                          ' D ',
                          nvl(d.deta_impo_mmee, 0),
                          0) debe_mmee,
                   decode(d.deta_indi_dbcr,
                          ' H ',
                          nvl(d.deta_impo_mmee, 0),
                          0) habe_mmee,
                   d.deta_nume_item,
                   m.movi_clpr_desc
              from come_asie a,
                   come_asie_deta d,
                   come_orde_trab ot,
                   come_cuen_cont c,
                   (select movi_obse,
                           movi_nume,
                           clpr_desc,
                           moa.moas_asie_codi,
                           movi_timo_codi,
                           movi_clpr_desc,
                           movi_clpr_codi
                      from come_movi      mo,
                           come_movi_asie moa,
                           come_clie_prov cl
                     where mo.movi_codi = moa.moas_movi_codi
                       and mo.movi_clpr_codi = cl.clpr_codi(+)) m
             where a.asie_codi = d.deta_asie_codi
               and c.cuco_codi = d.deta_cuco_codi
               and asie_codi = m.moas_asie_codi(+)
               and deta_ortr_codi = ot.ortr_codi(+)
               and asie_nume = i_nume_asie
             order by asie_fech_emis,
                      asie_nume,
                      deta_indi_dbcr,
                      deta_nume_item) cuco;
  
    v_cant_regi := ta_asien.count;
  
    for x in 1 .. v_cant_regi loop
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_c001,
         taax_c002,
         taax_c003,
         taax_c004,
         taax_c005,
         taax_c006,
         taax_c007,
         taax_c008,
         taax_c009,
         taax_c010,
         taax_c011,
         taax_c012,
         taax_c013,
         taax_c014,
         taax_c015,
         taax_c016,
         taax_seq)
      values
        (ta_asien(x).session,
         ta_asien(x).login,
         ta_asien(x).asie_codi,
         ta_asien(x).asie_nume,
         ta_asien(x).asie_fech_emis,
         ta_asien(x).asie_obse,
         ta_asien(x).asie_indi_manu,
         ta_asien(x).cuco_nume,
         ta_asien(x).cuco_desc,
         ta_asien(x).movi_obse,
         ta_asien(x).movi_clpr_codi,
         ta_asien(x).deta_indi_dbcr,
         ta_asien(x).debe_mmnn,
         ta_asien(x).habe_mmnn,
         ta_asien(x).debe_mmee,
         ta_asien(x).habe_mmee,
         ta_asien(x).deta_nume_item,
         ta_asien(x).movi_clpr_desc,
         ta_asien(x).secuencia);
    
    end loop;
  
    v_cont := 'p_app_session:p_app_user';
    v_para := v('APP_SESSION') || ':' || gen_user;
    v_repo := 'I020167_ASIENTOS';
  
    delete from come_parametros_report where usuario = gen_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_para, gen_user, v_repo, 'pdf', v_cont);
  
    commit;
  
  end pp_carg_repo_asie;

  /*********************************************************************/
  /******************* solicitud de desbloqueo ************************/
  /*******************************************************************/
  procedure pp_soli_desb(i_movi_codi in number,
                         i_movi_nume in number,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
    v_cont number;
  begin
  
    -- insert into come_concat (otro) values ('paso por aca 1 --- ');
    -- commit;
  
    select count(*)
      into v_cont
      from come_movi_entr_deta
     where deta_movi_codi = i_movi_codi
       and nvl(deta_indi_impr_logi, 'N') = 'N';
  
    if v_cont > 0 then
    
      pp_get_erro(i_resp_codi      => 62,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 62;
      raise salir;
    
    end if;
  
    -- insert into come_concat (otro) values ('paso por aca 2 --- ');
    -- commit;
  
    select count(*)
      into v_cont
      from come_movi_entr_deta
     where deta_movi_codi = i_movi_codi
       and nvl(deta_indi_impr_logi, 'N') = 'S'
       and nvl(deta_indi_soli_anul, 'N') = 'P';
  
    if v_cont > 0 then
      pp_get_erro(i_resp_codi      => 63,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 63;
      raise salir;
    end if;
  
    --insert into come_concat (otro) values ('paso por aca 3 --- ');
    --commit;
  
    select count(*)
      into v_cont
      from come_movi_entr_deta
     where deta_movi_codi = i_movi_codi
       and nvl(deta_indi_impr_logi, 'N') = 'S'
       and nvl(deta_indi_soli_anul, 'N') = 'P';
  
    if v_cont > 0 then
      pp_get_erro(i_resp_codi      => 64,
                  i_resp_orig      => 1,
                  i_resp_segu_pant => 116,
                  o_resp_desc      => v_erro_desc);
    
      v_erro_codi := 64;
      raise salir;
    end if;
  
    --insert into come_concat (otro) values ('paso por aca 4 --- ');
    --commit;
  
    update come_movi_entr_deta
       set deta_indi_soli_anul = 'P',
           deta_user_soli_anul = gen_user,
           deta_fech_soli_anul = sysdate
     where deta_movi_codi = i_movi_codi;
  
    -- insert into come_concat (otro) values ('paso por aca 5 --- ');
    -- commit;
  
    insert into come_movi_soli_anul
      (soan_movi_codi, soan_movi_nume, soan_user_soli, soan_fech_soli)
    values
      (i_movi_codi, i_movi_nume, gen_user, sysdate);
  
  exception
    when salir then
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when others then
      rollback;
      o_resp_codi := 1000;
      o_resp_desc := ('No se pudo actualizar el registro, al momento de solicitar desbloqueo: ' ||
                     sqlcode);
  end;

  procedure pp_valida_fech_fact_elec(p_fech in date, p_tipo_mov in number) is
    salir   exception;
    v_count number;
    v_estado varchar2(500);
  begin
  
    begin
      select count(*)
        into v_count
        from come_elec_fact f
       where f.elfa_come_mov_cod = bcab.movi_codi;
    end;
  
    if p_tipo_mov in (1, 2, 9) and gen_user <> 'SKN' and v_count > 0 then
      if p_fech < trunc(sysdate) - 2 then
        raise_application_error(-20001,
                                'La factura electronica solo se puede anular hasta 48 horas despues de la emision');
      end if;
    
    end if;
    
    
     begin
        select count(*), nvl(f.elfa_estado, 's')
          into v_count, v_estado
          from come_elec_fact f, come_movi ff
         where ff.movi_codi=f.elfa_come_mov_cod
          and ff.movi_codi_padr=bcab.movi_codi
         group by f.elfa_estado;
      exception
        when no_data_found then
          v_count := 0;
        when too_many_rows then
          v_count := 1;
      end;
      
       if v_count > 0 and v_estado <> 'Rechazado' then
        if p_fech < trunc(sysdate) - 2 then
          pl_me('El recibo está asociado a una factura que ha excedido el plazo de 48 horas permitido para su anulación.');
        end if;
     -- elsif bpie.movi_indi_anul = 'S' and v_count = 0 then
       -- pl_me('No se puede anular una factura que no ha sido presentada en la SIFEN.');
      end if;
  exception
    when salir then
      null;
    
  end pp_valida_fech_fact_elec;

  --validando factura electronica..
  procedure pp_inutilizar_nro_documento(i_movi_codi in number,
                                        i_tipo_movi in number) is
    v_count   number;
    v_estado  varchar2(100);
    v_bandera varchar2(2) := 'N';
  begin
  
    if i_tipo_movi in (1, 2, 9) then
    
      begin
        select count(*), nvl(f.elfa_estado, 'S')
          into v_count, v_estado
          from come_elec_fact f
         where f.elfa_come_mov_cod = i_movi_codi
         group by f.elfa_estado;
      exception
        when no_data_found then
          v_count := 0;
        when too_many_rows then
          v_count := 1;
      end;
    
      if v_count > 0 and v_estado = 'Rechazado' then
      
        v_bandera := 'S';
        env_fact_sifen.pp_inutilizar_nro_doc(p_movi_codi => i_movi_codi);
      end if;
    end if;
  
    if v_bandera = 'S' then
      dbms_output.put_line('Si entro en proceso de inutilizar nro doc');
    else
      dbms_output.put_line('No entro en proceso de inutilizar nro doc');
    end if;
  
  exception
    when others then
      pl_me('Error en Factura Electronica: ');
  end pp_inutilizar_nro_documento;

  procedure pp_borrado_manual(i_movi_codi      in number,
                              i_ind_inutilizar in varchar2,
                              i_movi_obse      in varchar2) as
  
    cursor c_deta_movi is
      select movi_codi,
             movi_nume,
             movi_timo_codi,
             movi_clpr_codi,
             movi_clpr_desc,
             movi_nume_timb,
             movi_clpr_dire,
             case
               when movi_clpr_ruc like '%-%' then
                movi_clpr_ruc
               else
                ltrim(to_char(movi_clpr_ruc, '999G999G999G999G999G999G990'))
             end movi_clpr_ruc,
             movi_fech_emis,
             movi_fech_oper,
             movi_empl_codi,
             oper_desc,
             oper_codi,
             do.depo_codi movi_depo_codi_orig,
             dd.depo_desc movi_depo_codi_dest,
             movi_obse,
             movi_mone_codi,
             movi_tasa_mone,
             movi_tasa_mmee,
             movi_sucu_codi_orig,
             movi_sucu_codi_dest,
             movi_fech_grab,
             movi_user,
             movi_grav10_ii_mone,
             movi_grav5_ii_mone,
             movi_exen_mone,
             movi_grav10_ii_mmnn,
             movi_grav5_ii_mmnn,
             movi_exen_mmnn,
             movi_sald_mone,
             movi_sald_mmnn,
             nvl(movi_grav10_ii_mone, 0) + nvl(movi_grav5_ii_mone, 0) movi_grav_mone,
             nvl(movi_grav10_ii_mone, 0) + nvl(movi_grav5_ii_mone, 0) movi_grav_mmnn,
             movi_ortr_codi,
             movi_orpa_codi,
             movi_soco_codi,
             movi_empr_codi,
             movi_inve_codi,
             movi_cuen_codi,
             movi_codi_padr,
             nvl(movi_iva10_mmnn, 0) + nvl(movi_iva5_mmnn, 0) movi_iva_mmnn,
             nvl(movi_iva10_mone, 0) + nvl(movi_iva5_mone, 0) movi_iva_mone,
             movi_grav_mmee,
             movi_exen_mmee,
             movi_iva_mmee,
             movi_sald_mmee,
             movi_stoc_suma_rest,
             movi_emit_reci,
             movi_afec_sald,
             movi_dbcr,
             movi_stoc_afec_cost_prom,
             movi_indi_iva_incl,
             movi_orpe_codi,
             timo_codi tico_codi,
             movi_indi_cobr_dife,
             movi_rrhh_movi_codi,
             movi_apci_codi,
             movi_inmu_codi,
             movi_inmu_esta_ante,
             clpr_codi_alte || '-' || clpr_desc cliente,
             empl_desc,
             mone_desc,
             timo_desc,
             movi_clpr_tele,
             movi_oper_codi
        from come_movi,
             come_tipo_movi,
             come_clie_prov,
             come_empl,
             come_mone,
             come_depo      dd,
             come_depo      do,
             come_sucu      sd,
             come_sucu      so,
             come_stoc_oper
       where movi_timo_codi = timo_codi(+)
         and movi_clpr_codi = clpr_codi(+)
         and movi_empl_codi = empl_codi(+)
         and movi_mone_codi = mone_codi(+)
         and movi_depo_codi_dest = dd.depo_codi(+)
         and movi_depo_codi_orig = do.depo_codi(+)
         and movi_oper_codi = oper_codi(+)
         and movi_sucu_codi_orig = so.sucu_codi(+)
         and movi_sucu_codi_dest = sd.sucu_codi(+)
         and movi_codi = i_movi_codi;
  
    v_movi_obse           varchar2(100);
    v_movi_indi_anul      varchar2(2) := 'N'; --'s';
    v_indi_borr_docu_hijo varchar2(2) := 'N'; --'s';
    v_apli_codi           varchar2(100);
    v_ortr_esta           varchar2(100);
  begin
    if i_ind_inutilizar not in ('N', 'S') then
      pl_me('Opcion incorrecta i_ind_inutilizar = S O N');
    end if;
  
    v_movi_obse := 'Borrado manual*' || i_movi_obse;
  
    dbms_output.put_line('EMPIEZA BORRADO');
  
    for x in c_deta_movi loop
    
      pp_most_apli_codi(p_movi_codi => x.movi_codi,
                        p_apli_codi => v_apli_codi);
    
      ta_movi_anul(1).movi_codi := x.movi_codi;
      ta_movi_anul(1).movi_clpr_codi := x.movi_clpr_codi;
      ta_movi_anul(1).movi_nume := x.movi_nume;
      ta_movi_anul(1).movi_nume_timb := x.movi_nume_timb;
      ta_movi_anul(1).movi_fech_emis := x.movi_fech_emis;
      ta_movi_anul(1).movi_timo_codi := x.movi_timo_codi;
      ta_movi_anul(1).movi_oper_codi := x.movi_oper_codi;
      ta_movi_anul(1).movi_empr_codi := x.movi_empr_codi;
      ta_movi_anul(1).movi_sucu_codi_orig := x.movi_sucu_codi_orig;
      ta_movi_anul(1).movi_inve_codi := x.movi_inve_codi;
      ta_movi_anul(1).movi_soco_codi := x.movi_soco_codi;
      ta_movi_anul(1).movi_depo_codi_orig := x.movi_depo_codi_orig;
      ta_movi_anul(1).movi_sucu_codi_dest := x.movi_sucu_codi_dest;
      ta_movi_anul(1).movi_depo_codi_dest := x.movi_depo_codi_dest;
      ta_movi_anul(1).movi_cuen_codi := x.movi_cuen_codi;
      ta_movi_anul(1).movi_mone_codi := x.movi_mone_codi;
      ta_movi_anul(1).movi_fech_grab := x.movi_fech_grab;
      ta_movi_anul(1).movi_user := x.movi_user;
      ta_movi_anul(1).movi_codi_padr := x.movi_codi_padr;
      ta_movi_anul(1).movi_tasa_mone := x.movi_tasa_mone;
      ta_movi_anul(1).movi_tasa_mmee := x.movi_tasa_mmee;
      ta_movi_anul(1).movi_grav_mmnn := x.movi_grav_mmnn;
      ta_movi_anul(1).movi_exen_mmnn := x.movi_exen_mmnn;
      ta_movi_anul(1).movi_iva_mmnn := x.movi_iva_mmnn;
      ta_movi_anul(1).movi_grav_mone := x.movi_grav_mone;
      ta_movi_anul(1).movi_exen_mone := x.movi_exen_mone;
      ta_movi_anul(1).movi_iva_mone := x.movi_iva_mone;
      ta_movi_anul(1).movi_grav_mmee := x.movi_grav_mmee;
      ta_movi_anul(1).movi_exen_mmee := x.movi_exen_mmee;
      ta_movi_anul(1).movi_iva_mmee := x.movi_iva_mmee;
      ta_movi_anul(1).movi_obse := x.movi_obse;
      ta_movi_anul(1).movi_sald_mmnn := x.movi_sald_mmnn;
      ta_movi_anul(1).movi_sald_mone := x.movi_sald_mone;
      ta_movi_anul(1).movi_sald_mmee := x.movi_sald_mmee;
      ta_movi_anul(1).movi_stoc_suma_rest := x.movi_stoc_suma_rest;
      ta_movi_anul(1).movi_clpr_dire := x.movi_clpr_dire;
      ta_movi_anul(1).movi_clpr_tele := x.movi_clpr_tele;
      ta_movi_anul(1).movi_clpr_ruc := x.movi_clpr_ruc;
      ta_movi_anul(1).movi_clpr_desc := x.movi_clpr_desc;
      ta_movi_anul(1).movi_emit_reci := x.movi_emit_reci;
      ta_movi_anul(1).movi_afec_sald := x.movi_afec_sald;
      ta_movi_anul(1).movi_dbcr := x.movi_dbcr;
      ta_movi_anul(1).movi_stoc_afec_cost_prom := x.movi_stoc_afec_cost_prom;
      ta_movi_anul(1).movi_empl_codi := x.movi_empl_codi;
      ta_movi_anul(1).movi_indi_iva_incl := x.movi_indi_iva_incl;
      ta_movi_anul(1).movi_orpe_codi := x.movi_orpe_codi;
      ta_movi_anul(1).movi_ortr_codi := x.movi_ortr_codi;
    
      if x.movi_ortr_codi is not null then
        select ortr_esta
          into v_ortr_esta
          from come_orde_trab
         where ortr_codi = x.movi_ortr_codi;
      end if;
    
      ta_movi_anul(1).movi_orpa_codi := x.movi_orpa_codi;
      ta_movi_anul(1).ortr_esta := v_ortr_esta;
      ta_movi_anul(1).apli_codi := v_apli_codi;
      ta_movi_anul(1).indi_anul := v_movi_indi_anul;
      ta_movi_anul(1).obse_anul := v_movi_obse;
      ta_movi_anul(1).indi_borr_hijos := v_indi_borr_docu_hijo;
      ta_movi_anul(1).tico_codi := x.tico_codi;
      ta_movi_anul(1).movi_inmu_codi := x.movi_inmu_codi;
      ta_movi_anul(1).movi_inmu_esta_ante := x.movi_inmu_esta_ante;
    
    end loop;
  
    if i_ind_inutilizar = 'S' then
      dbms_output.put_line('Inutilizar numero documento');
      pp_inutilizar_nro_documento(i_movi_codi => ta_movi_anul(1).movi_codi,
                                  i_tipo_movi => ta_movi_anul(1).movi_timo_codi);
    end if;
  
    pack_anul.pa_borra_movi(ta_movi_anul);
    ta_movi_anul.delete;
  
    dbms_output.put_line('Fin del borrado');
  
  end pp_borrado_manual;

end i020167;
