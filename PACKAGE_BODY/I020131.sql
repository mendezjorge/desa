
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020131" is
  /************ carga de parametros ***************/

  p_indi_apli_adel    varchar2(1) := 'N';
  p_codi_base         number := pack_repl.fa_devu_codi_base;
  p_codi_timo_deuimp  number := fa_busc_para('p_codi_timo_deuimp');
  p_codi_timo_rcnadlr number := fa_busc_para('p_codi_timo_rcnadlr');
  p_codi_timo_cnfcrr  number := fa_busc_para('p_codi_timo_cnfcrr');

  p_codi_conc_com_imp number := fa_busc_para('p_codi_conc_com_imp');
  p_codi_impu_exen    number := to_number(fa_busc_para('p_codi_impu_exen'));
  p_codi_oper_com     number := to_number(fa_busc_para('p_codi_oper_com'));

  p_cant_deci_mmee number := to_number(fa_busc_para('p_cant_deci_mmee'));
  p_cant_deci_mmnn number := to_number(fa_busc_para('p_cant_deci_mmnn'));

  p_cant_deci_cant_impo number := to_number(fa_busc_para('p_cant_deci_cant_impo'));

  p_codi_mone_mmnn number := to_number(fa_busc_para('p_codi_mone_mmnn'));

  p_indi_most_mens_sali varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_most_mens_sali')));
  p_indi_modi_coti_deud varchar2(500) := ltrim(rtrim(fa_busc_para('p_indi_modi_coti_deud')));
  p_query               varchar2(1) := 'N';
  p_emit_reci           come_tipo_movi.timo_emit_reci%type;
  p_timo_dbcr           come_tipo_movi.timo_dbcr%type;

  p_sess      varchar2(500) := nvl(v('APP_SESSION'), '1');
  p_empr_codi number := v('AI_EMPR_CODI');
  p_sucu_codi number := v('AI_SUCU_CODI');
  v_movi_codi number;
  p_fech_inic date;
  p_fech_fini date;

  v_imfa_codi number;
  p_movi_codi_deud number;

  /************* actualizar registros **************/

  procedure pp_actualizar_registro(ii_imfa_nume           come_impo_fact.imfa_nume%type,
                                   ii_imfa_movi_codi      come_impo_fact.imfa_movi_codi%type,
                                   ii_imfa_fech           come_impo_fact.imfa_fech%type,
                                   ii_imfa_obse           come_impo_fact.imfa_obse%type,
                                   ii_imfa_clpr_codi      come_impo_fact.imfa_clpr_codi%type,
                                   ii_imfa_tipo           come_impo_fact.imfa_tipo%type,
                                   ii_imfa_mone_codi      come_impo_fact.imfa_mone_codi%type,
                                   ii_imfa_impo_codi      come_impo_fact.imfa_impo_codi%type,
                                   ii_imfa_indi_ingr_stoc come_impo_fact.imfa_indi_ingr_stoc%type,
                                   ii_imfa_tasa_mone_deud come_impo_fact.imfa_tasa_mone_deud%type,
                                   ii_imfa_tasa_mmee_deud come_impo_fact.imfa_tasa_mmee_deud%type,
                                   ii_imfa_fech_deud      come_impo_fact.imfa_fech_deud%type,
                                   ii_imfa_fech_deud_venc come_impo_fact.imfa_fech_deud_venc%type) is
  v_exis number;
  begin
  
  --*esto es para saber la existencia del registro en caso de edicion
  begin
    
  select count(*) into v_exis from come_impo_fact j where j.imfa_nume =  ii_imfa_nume;
  exception 
    when others then 
      v_exis := 0;
    end;
    

  if v('P16_INDI_COST') = 'N' and  v_exis = 0 then 
    
    begin
      I020131.pp_eliminar_come_fact(i_imfa_codi => v('P16_IMFA_CODI'));
    end;

  
  end if;
    
    --cargar cabecera
    begin
      I020131.pp_insert_come_fact(i_imfa_nume           => ii_imfa_nume,
                                  i_imfa_movi_codi      => ii_imfa_movi_codi,
                                  i_imfa_fech           => ii_imfa_fech,
                                  i_imfa_obse           => ii_imfa_obse,
                                  i_imfa_clpr_codi      => ii_imfa_clpr_codi,
                                  i_imfa_tipo           => ii_imfa_tipo,
                                  i_imfa_mone_codi      => ii_imfa_mone_codi,
                                  i_imfa_impo_codi      => ii_imfa_impo_codi,
                                  i_imfa_indi_ingr_stoc => ii_imfa_indi_ingr_stoc,
                                  i_imfa_tasa_mone_deud => ii_imfa_tasa_mone_deud,
                                  i_imfa_tasa_mmee_deud => ii_imfa_tasa_mmee_deud,
                                  i_imfa_fech_deud      => ii_imfa_fech_deud,
                                  i_imfa_fech_deud_venc => ii_imfa_fech_deud_venc);
    
    exception
      when others then
        raise_application_error(-20010,
                                'Error al momento de procesar come_impo_fact');
      
    end;
  
    --cargar detalles
    begin
      I020131.pp_inserta_come_fact_deta(i_imfa_tasa_mone_deud => ii_imfa_tasa_mone_deud);
    
    exception
      when others then
        raise_application_error(-20010,
                                'Error al momento de procesar come_impo_fact_deta');
      
    end;
  
    --borramos el detalle
    pack_mane_tabl_auxi.pp_trunc_table(i_taax_sess => p_sess,
                                       i_taax_user => gen_user);
  

  
  end;

  procedure pp_actualiza_canc(i_imfa_clpr_codi      in number,
                              i_imfa_mone_codi      in number,
                              i_imfa_nume           in number,
                              i_imfa_fech_deud      in date,
                              i_imfa_fech_deud_venc in date,
                              i_imfa_tasa_mone_deud in number) is
  
    --insertar los recibos de cancelaciones
    --cancelacion de la nc/adel..................
    --cancelacion de la factura/nota de debito....
    v_movi_codi           number;
    v_movi_timo_codi      number;
    v_movi_timo_desc      varchar2(60);
    v_movi_timo_desc_abre varchar2(10);
    v_movi_clpr_codi      number;
    v_movi_sucu_codi_orig number;
    v_movi_mone_codi      number;
    v_movi_nume           number;
    v_movi_fech_emis      date;
    v_movi_fech_grab      date;
    v_movi_user           char(20);
    v_movi_codi_padr      number;
    v_movi_tasa_mone      number;
    v_movi_tasa_mmee      number;
    v_movi_grav_mmnn      number;
    v_movi_exen_mmnn      number;
    v_movi_iva_mmnn       number;
    v_movi_grav_mmee      number;
    v_movi_exen_mmee      number;
    v_movi_iva_mmee       number;
    v_movi_grav_mone      number;
    v_movi_exen_mone      number;
    v_movi_iva_mone       number;
    v_movi_clpr_desc      char(80);
    v_movi_emit_reci      char(1);
    v_movi_afec_sald      char(1);
    v_movi_dbcr           char(1);
    v_movi_empr_codi      number;
  
    v_movi_depo_codi_orig number;
    v_movi_sucu_codi_dest number;
    v_movi_depo_codi_dest number;
    v_movi_oper_codi      number;
    v_movi_cuen_codi      number;
    v_movi_obse           varchar2(2000);
  
    v_movi_sald_mmnn           number;
    v_movi_sald_mmee           number;
    v_movi_sald_mone           number;
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(80);
    v_movi_clpr_tele           varchar2(80);
    v_movi_clpr_ruc            varchar2(80);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_clave_orig          number;
    v_movi_clave_orig_padr     number;
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           number;
    v_movi_nume_timb           number;
    v_movi_fech_venc_timb      date;
    v_movi_fech_oper           date;
    v_movi_excl_cont           varchar2(1);
  
    --variables para come_movi_cuot_canc...
  
    v_canc_movi_codi           number(20);
    v_canc_cuot_movi_codi      number(20);
    v_canc_cuot_fech_venc      date;
    v_canc_fech_pago           date;
    v_canc_base                number(2);
    v_canc_impo_mone           number(20, 4);
    v_canc_impo_mmee           number(20, 4);
    v_canc_impo_mmnn           number(20, 4);
    v_canc_impo_dife_camb      number(20, 4);
    v_canc_asie_codi           number(20);
    v_canc_indi_afec_sald      varchar2(1);
    v_canc_impu_mone           number(20, 4);
    v_canc_impu_mmnn           number(20, 4);
    v_canc_cuot_codi           number(20);
    v_canc_impu_codi           number(10);
    v_canc_desc                varchar2(60);
    v_canc_impo_rete_mone      number(20, 4);
    v_canc_impo_rete_mmnn      number(20, 4);
    v_canc_indi_refi_tran      varchar2(1);
    v_canc_tipo                varchar2(1);
    v_canc_grav10_ii_mone      number(20, 4);
    v_canc_grav5_ii_mone       number(20, 4);
    v_canc_exen_mone           number(20, 4);
    v_canc_iva10_mone          number(20, 4);
    v_canc_iva5_mone           number(20, 4);
    v_canc_grav10_ii_mmnn      number(20, 4);
    v_canc_grav5_ii_mmnn       number(20, 4);
    v_canc_exen_mmnn           number(20, 4);
    v_canc_iva10_mmnn          number(20, 4);
    v_canc_iva5_mmnn           number(20, 4);
    v_canc_grav10_mone         number(20, 4);
    v_canc_grav5_mone          number(20, 4);
    v_canc_grav10_mmnn         number(20, 4);
    v_canc_grav5_mmnn          number(20, 4);
    v_canc_impo_inte_mora_acob number(20, 4);
    v_canc_impo_inte_mora_cobr number(20, 4);
    v_canc_impo_inte_puni_acob number(20, 4);
    v_canc_impo_inte_puni_cobr number(20, 4);
    v_canc_impo_gast_admi_acob number(20, 4);
    v_canc_impo_gast_admi_cobr number(20, 4);
  
    v_impo_canc number;
    v_impo_deto number;
  
    v_indi_adel char(1);
    v_indi_ncr  char(1);
    v_movi_base number;
    v_total     number(20, 4);
    i_clpr_desc varchar2(500);
  
    cursor c_adel is
      select taax_n001 cuot_tasa_mone,
             taax_n002 cuot_movi_codi,
             taax_d001 cuot_fech_venc,
             taax_n003 cuot_impo_mone,
             taax_n004 cuot_sald_mone,
             taax_n005 movi_nume,
             taax_c001 timo_desc,
             taax_d002 movi_fech_emis,
             taax_n006 clpr_codi,
             taax_n007 impo_pago,
             taax_c002 cuot_tipo
        from come_tabl_auxi
       where taax_sess = p_sess
         and taax_user = gen_user
         and taax_c050 = 'ADEL'
         and taax_c003 = 'S';
  
  begin
    --  |------------------------------------------------------------|
    --  |-insertar la cancelacion de la nota de credito/o adelanto...|
    --  |------------------------------------------------------------|  
  
    --determinar el tipo de movimiento.......
    if p_emit_reci = 'R' then
      --es recibido
      v_movi_timo_codi := p_codi_timo_rcnadlr;
    end if;
  
  select clpr_desc into i_clpr_desc from come_clie_prov where clpr_codi = i_imfa_clpr_codi;
  
  
  
    pp_muestra_come_tipo_movi(v_movi_timo_codi,
                              v_movi_timo_desc,
                              v_movi_timo_desc_abre,
                              v_movi_afec_sald,
                              v_movi_dbcr,
                              v_indi_adel,
                              v_indi_ncr,
                              'N');
    --obtenemos el total 
    select sum(taax_n014)
      into v_total
      from come_tabl_auxi
     where taax_sess = p_sess
       and taax_user = gen_user;
  
    v_movi_codi := fa_sec_come_movi;
    --i_movi_codi_apli               := v_movi_codi;
    v_movi_clpr_codi      := i_imfa_clpr_codi;
    v_movi_sucu_codi_orig := p_sucu_codi; --i_movi_sucu_codi_orig;
    v_movi_mone_codi      := i_imfa_mone_codi;
    v_movi_nume           := i_imfa_nume;
    v_movi_fech_emis      := i_imfa_fech_deud;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_codi_padr      := null;
    v_movi_tasa_mone      := i_imfa_tasa_mone_deud;
    v_movi_tasa_mmee      := 0;
    v_movi_grav_mmnn      := 0;
    v_movi_exen_mmnn      := round((v_total * i_imfa_tasa_mone_deud),
                                   p_cant_deci_mmnn);
    v_movi_iva_mmnn       := 0;
    v_movi_grav_mmee      := 0;
    v_movi_exen_mmee      := 0;
    v_movi_iva_mmee       := 0;
    v_movi_grav_mone      := 0;
    v_movi_exen_mone      := nvl(v_total, 0);
    v_movi_iva_mone       := 0;
    v_movi_clpr_desc      := i_clpr_desc;
    v_movi_emit_reci      := p_emit_reci;
    v_movi_empr_codi      := p_empr_codi; --i_movi_empr_codi;
    v_movi_depo_codi_orig := null;
    v_movi_base           := p_codi_base;
  
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
                        v_movi_base,
                        null, --v_movi_indi_conta                                    ,
                        null, --v_movi_ortr_codi                                     ,
                        null); --v_movi_impo_codi                                     );
  
    --obse. los adelantos y notas de creditos tendrán siempre una sola cuota..
    --con fecha de vencimiento igual a la fecha del documento.................
  
    for i in c_adel loop
    
      v_canc_movi_codi      := v_movi_codi; --clave del recibo de cn de nc/adel
      v_canc_cuot_movi_codi := i.cuot_movi_codi; --clave de la nota de credito/ adel
      v_canc_cuot_fech_venc := i.cuot_fech_venc; --fecha de venc. de la cuota de nc/adel (= a la fecha de la nc/adel)
      v_canc_fech_pago      := i_imfa_fech_deud; --fecha de aplicacion de la cuota de nc (= a la fecha de la nc)
      v_canc_impo_mone      := i.impo_pago; --siempre el importe de cancelacion será exento...
      v_canc_impo_mmnn      := round((i.impo_pago * i_imfa_tasa_mone_deud),
                                     p_cant_deci_mmnn);
      v_canc_impo_mmee      := 0;
      v_canc_impo_dife_camb := 0; ---round(((i_imfa_tasa_mone_deud - i.cuot_tasa_mone)* v_canc_impo_mone),0);
    
      v_canc_tipo := i.cuot_tipo;
    
      insert into come_movi_cuot_canc
        (canc_movi_codi,
         canc_cuot_movi_codi,
         canc_cuot_fech_venc,
         canc_fech_pago,
         canc_impo_mone,
         canc_impo_mmee,
         canc_impo_mmnn,
         canc_impo_dife_camb,
         canc_asie_codi,
         canc_indi_afec_sald,
         canc_impu_mone,
         canc_impu_mmnn,
         canc_cuot_codi,
         canc_impu_codi,
         canc_desc,
         canc_impo_rete_mone,
         canc_impo_rete_mmnn,
         canc_indi_refi_tran,
         canc_tipo,
         canc_grav10_ii_mone,
         canc_grav5_ii_mone,
         canc_exen_mone,
         canc_iva10_mone,
         canc_iva5_mone,
         canc_grav10_ii_mmnn,
         canc_grav5_ii_mmnn,
         canc_exen_mmnn,
         canc_iva10_mmnn,
         canc_iva5_mmnn,
         canc_grav10_mone,
         canc_grav5_mone,
         canc_grav10_mmnn,
         canc_grav5_mmnn,
         canc_impo_inte_mora_acob,
         canc_impo_inte_mora_cobr,
         canc_impo_inte_puni_acob,
         canc_impo_inte_puni_cobr,
         canc_impo_gast_admi_acob,
         canc_impo_gast_admi_cobr)
      values
        (v_canc_movi_codi,
         v_canc_cuot_movi_codi,
         v_canc_cuot_fech_venc,
         v_canc_fech_pago,
         v_canc_impo_mone,
         v_canc_impo_mmee,
         v_canc_impo_mmnn,
         v_canc_impo_dife_camb,
         v_canc_asie_codi,
         v_canc_indi_afec_sald,
         v_canc_impu_mone,
         v_canc_impu_mmnn,
         v_canc_cuot_codi,
         v_canc_impu_codi,
         v_canc_desc,
         v_canc_impo_rete_mone,
         v_canc_impo_rete_mmnn,
         v_canc_indi_refi_tran,
         v_canc_tipo,
         v_canc_grav10_ii_mone,
         v_canc_grav5_ii_mone,
         v_canc_exen_mone,
         v_canc_iva10_mone,
         v_canc_iva5_mone,
         v_canc_grav10_ii_mmnn,
         v_canc_grav5_ii_mmnn,
         v_canc_exen_mmnn,
         v_canc_iva10_mmnn,
         v_canc_iva5_mmnn,
         v_canc_grav10_mone,
         v_canc_grav5_mone,
         v_canc_grav10_mmnn,
         v_canc_grav5_mmnn,
         v_canc_impo_inte_mora_acob,
         v_canc_impo_inte_mora_cobr,
         v_canc_impo_inte_puni_acob,
         v_canc_impo_inte_puni_cobr,
         v_canc_impo_gast_admi_acob,
         v_canc_impo_gast_admi_cobr);
    
    end loop;
    -----------------------------------------------------------------------------------------------------------------------
    --fin de la cancelacion de la nota de credito  / adelanto...
    -----------------------------------------------------------------------------------------------------------------------
  
    ------------------------------------------------------------------------------------------------------------------------
    ---insertar la cancelacion de la/s factura/s..../ notas de debitos......................................................
    ------------------------------------------------------------------------------------------------------------------------
    --determinar el tipo de movimiento.......
    --primero determinamos si el documento es emitido o recibido y luego si es una nota de credito o un adelanto....
    if p_emit_reci = 'R' then
      --es recibido
      v_movi_timo_codi := p_codi_timo_cnfcrr;
    end if;
  
    pp_muestra_come_tipo_movi(v_movi_timo_codi,
                              v_movi_timo_desc,
                              v_movi_timo_desc_abre,
                              v_movi_afec_sald,
                              v_movi_dbcr,
                              v_indi_adel,
                              v_indi_ncr,
                              'N');
  
    v_movi_codi_padr      := v_movi_codi; --clave de la cancelacion del adel/nota de credito
    v_movi_codi           := fa_sec_come_movi;
    v_movi_clpr_codi      := i_imfa_clpr_codi;
    v_movi_sucu_codi_orig := p_sucu_codi;
    v_movi_mone_codi      := i_imfa_mone_codi;
    v_movi_nume           := i_imfa_nume;
    v_movi_fech_emis      := i_imfa_fech_deud;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_tasa_mone      := i_imfa_tasa_mone_deud;
    v_movi_tasa_mmee      := 0;
    v_movi_grav_mmnn      := 0;
    v_movi_exen_mmnn      := round((v_total * i_imfa_tasa_mone_deud),
                                   p_cant_deci_mmnn);
    v_movi_iva_mmnn       := 0;
    v_movi_grav_mmee      := 0;
    v_movi_exen_mmee      := 0;
    v_movi_iva_mmee       := 0;
    v_movi_grav_mone      := 0;
    v_movi_exen_mone      := v_total;
    v_movi_iva_mone       := 0;
    v_movi_clpr_desc      := i_clpr_desc;
    v_movi_emit_reci      := p_emit_reci;
    v_movi_empr_codi      := p_empr_codi;
  
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
                        v_movi_base,
                        null, --v_movi_indi_conta                                    ,
                        null, --v_movi_ortr_codi                                     ,
                        null); --v_movi_impo_codi                                     );
  
    -----
  
    v_canc_movi_codi      := v_movi_codi;
    v_canc_cuot_movi_codi := p_movi_codi_deud;
    v_canc_cuot_fech_venc := i_imfa_fech_deud_venc;
    v_canc_fech_pago      := i_imfa_fech_deud;
    v_canc_impo_mone      := v_total; --siempre el importe de cancelacion será exento...
    v_canc_impo_mmnn      := round((v_total * i_imfa_tasa_mone_deud),
                                   p_cant_deci_mmnn);
    v_canc_impo_mmee      := 0;
    v_canc_impo_dife_camb := 0;
    v_canc_tipo           := 'C';
  
    insert into come_movi_cuot_canc
      (canc_movi_codi,
       canc_cuot_movi_codi,
       canc_cuot_fech_venc,
       canc_fech_pago,
       canc_impo_mone,
       canc_impo_mmee,
       canc_impo_mmnn,
       canc_impo_dife_camb,
       canc_asie_codi,
       canc_indi_afec_sald,
       canc_impu_mone,
       canc_impu_mmnn,
       canc_cuot_codi,
       canc_impu_codi,
       canc_desc,
       canc_impo_rete_mone,
       canc_impo_rete_mmnn,
       canc_indi_refi_tran,
       canc_tipo,
       canc_grav10_ii_mone,
       canc_grav5_ii_mone,
       canc_exen_mone,
       canc_iva10_mone,
       canc_iva5_mone,
       canc_grav10_ii_mmnn,
       canc_grav5_ii_mmnn,
       canc_exen_mmnn,
       canc_iva10_mmnn,
       canc_iva5_mmnn,
       canc_grav10_mone,
       canc_grav5_mone,
       canc_grav10_mmnn,
       canc_grav5_mmnn,
       canc_impo_inte_mora_acob,
       canc_impo_inte_mora_cobr,
       canc_impo_inte_puni_acob,
       canc_impo_inte_puni_cobr,
       canc_impo_gast_admi_acob,
       canc_impo_gast_admi_cobr)
    values
      (v_canc_movi_codi,
       v_canc_cuot_movi_codi,
       v_canc_cuot_fech_venc,
       v_canc_fech_pago,
       v_canc_impo_mone,
       v_canc_impo_mmee,
       v_canc_impo_mmnn,
       v_canc_impo_dife_camb,
       v_canc_asie_codi,
       v_canc_indi_afec_sald,
       v_canc_impu_mone,
       v_canc_impu_mmnn,
       v_canc_cuot_codi,
       v_canc_impu_codi,
       v_canc_desc,
       v_canc_impo_rete_mone,
       v_canc_impo_rete_mmnn,
       v_canc_indi_refi_tran,
       v_canc_tipo,
       v_canc_grav10_ii_mone,
       v_canc_grav5_ii_mone,
       v_canc_exen_mone,
       v_canc_iva10_mone,
       v_canc_iva5_mone,
       v_canc_grav10_ii_mmnn,
       v_canc_grav5_ii_mmnn,
       v_canc_exen_mmnn,
       v_canc_iva10_mmnn,
       v_canc_iva5_mmnn,
       v_canc_grav10_mone,
       v_canc_grav5_mone,
       v_canc_grav10_mmnn,
       v_canc_grav5_mmnn,
       v_canc_impo_inte_mora_acob,
       v_canc_impo_inte_mora_cobr,
       v_canc_impo_inte_puni_acob,
       v_canc_impo_inte_puni_cobr,
       v_canc_impo_gast_admi_acob,
       v_canc_impo_gast_admi_cobr);
  
    -----------------------------------------------------------------------------------------------------------------------
    --fin de la cancelacion de la/s factura/s  
    -----------------------------------------------------------------------------------------------------------------------
    --    |-------------------------------------------------------------|
    --    |obse. los movimientos de tipo cance., no afectan caja, ni    |
    --    |tampoco tienen saldo, sirven unicamente para la aplicacion   |
    --    |conrrespondiente de los adelantos y notas de creditos,       |
    --    |-------------------------------------------------------------|
  
  exception
  
    when others then
      raise_application_error(-20010,
                              'Error al momento de Actualizar Cancelacion ' ||
                              sqlerrm);
    
  end pp_actualiza_canc;

  /************* carga de datos ********************/

  procedure pp_veri_asig_lote(p_imfa_codi in number,
                              p_indi_lote out varchar2) is
  
    v_cant number := 0;
  
  begin
    select count(*)
      into v_cant
      from come_impo_fact_deta_lote dl
     where dl.delo_imfa_codi = p_imfa_codi
       and dl.delo_lote_codi not in
           (select l.lote_codi
              from come_lote l
             where l.lote_desc = '000000'
                or l.lote_obse = 'Lote Generico');
  
    if v_cant > 0 then
      p_indi_lote := 'S';
    else
      p_indi_lote := 'N';
    end if;
  
  exception
    when no_data_found then
      p_indi_lote := 'N';
  end;

  procedure pp_valida_nume_impo(p_impo_nume           in varchar2,
                                p_impo_codi           out number,
                                p_impo_obse           out varchar2,
                                p_tasa_mone           in out number,
                                i_imfa_indi_ingr_stoc in varchar2,
                                i_imfa_clpr_codi      in number,
                                i_imfa_mone_codi      in number) is
  
    v_indi_ingr_stoc varchar2(1);
    v_clpr_codi      number;
    v_indi_cost      varchar2(1);
    v_impo_mone_codi number;
    v_tasa_mone      number;
  
  begin
  
    -- raise_application_error(-20010, 'HOLA');
    select i.impo_codi,
           i.impo_obse,
           i.impo_indi_ingr_stoc,
           impo_clpr_codi,
           impo_indi_cost,
           impo_Tasa_mone,
           impo_mone_codi
      into p_impo_codi,
           p_impo_obse,
           v_indi_ingr_stoc,
           v_clpr_codi,
           v_indi_cost,
           v_tasa_mone,
           v_impo_mone_codi
      from come_impo i
     where i.impo_nume = p_impo_nume;
  
    if p_tasa_mone is null then
      p_Tasa_mone := v_tasa_mone;
    end if;
    if nvl(i_imfa_indi_ingr_stoc, 'N') = 'N' then
      if nvl(v_indi_ingr_stoc, 'N') <> 'N' then
        raise_application_error(-20010,
                                'La importación ya fue ingresada al stock');
      end if;
    end if;
  
    if v_clpr_codi <> i_imfa_clpr_codi then
      raise_application_error(-20010,
                              'La importacion no corresponde al proveedor');
    end if;
  
    if v_impo_mone_codi <> i_imfa_mone_codi then
      raise_application_error(-20010,
                              'La moneda ingresada no corresponde a la moneada de la Importación');
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20010, 'Nro de importacion Inexistente.');
    when too_many_rows then
      raise_application_error(-20010, 'Nro de Importacion duplicado.');
  end;

  procedure pp_ejecutar_consulta_adelantos(i_imfa_mone_codi in number,
                                           i_imfa_clpr_codi in number) is
    cursor cv_adel is
      select movi_codi,
             movi_nume,
             timo_desc,
             movi_fech_emis,
             cuot_fech_venc,
             cuot_impo_mone,
             cuot_sald_mone,
             cuot_tipo,
             movi_tasa_mone cuot_tasa_mone,
             movi_clpr_codi clpr_codi
        from come_movi a, come_movi_cuot, come_tipo_movi
       where movi_codi = cuot_movi_codi
         and movi_timo_codi = 31
         and movi_timo_codi = timo_codi
         and nvl(movi_sald_mone, 0) <> 0
         and movi_clpr_codi = i_imfa_clpr_codi
         and movi_mone_codi = i_imfa_mone_codi;
  begin
  
    for r in cv_adel loop
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_n001,
         taax_n002,
         taax_c001,
         taax_n003,
         taax_n004,
         taax_n005,
         taax_c002,
         taax_c003,
         taax_n006,
         taax_n007,
         taax_c004,
         taax_c050)
      values
        (p_sess,
         gen_user,
         seq_come_tabl_auxi.nextval,
         r.cuot_tasa_mone,
         r.movi_codi,
         r.cuot_fech_venc,
         r.cuot_impo_mone,
         r.cuot_sald_mone,
         r.movi_nume,
         r.timo_desc,
         r.movi_fech_emis,
         r.clpr_codi,
         0,
         r.cuot_tipo,
         'A');
    
    end loop;
  
  end;

  /****************** VALIDACIONES EN EL BOTON  ******************/
  /*if i_impo_nume is not null then
    pp_valida_nume_impo (i_impo_nume, i_imfa_impo_codi, i_impo_obse, i_IMFA_TASA_MONE_DEUD);
    
    if nvl(p_indi_modi_coti_deud,'N') = 'S' then
      if get_item_property('bcab.imfa_tasa_mone_deud', enabled) = 'FALSE' then
         set_item_property('bcab.imfa_tasa_mone_deud', enabled, property_true) ;
      end if;
    else
      if get_item_property('bcab.imfa_tasa_mone_deud', enabled) = 'TRUE' then
         set_item_property('bcab.imfa_tasa_mone_deud', enabled, property_false);
      end if;
    end if;
    
  else
    if i_imfa_tipo <> 1 then
      raise_application_error(-20010, 'Debe ingresar el Nro de Importación!!');
    end if;
  end if;*/

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

  procedure pp_validar_producto(i_prod_codi      in number,
                                i_prod_codi_barr in number,
                                i_prod_codi_alfa in number) is
    salir exception;
  begin
  
    --buscar articulo por codigo de fabrica
    if fp_buscar_prod_cod_fabr(i_prod_codi) then
      raise salir;
    end if;
  
    --buscar articulo por codigo de barras
    if fp_buscar_prod_cod_barr(i_prod_codi_barr) then
      raise salir;
    end if;
    -----------------------------------------------------
  
    --buscar articulo por codigo alfanumerico
    if fp_buscar_prod_cod_alfa(i_prod_codi_alfa) then
      raise salir;
    end if;
  
  exception
    when salir then
      null;
  end;

  function fp_buscar_prod_cod_fabr(i_prod_codi in number) return boolean is
    v_indi_inac varchar2(1);
  begin
    select nvl(prod_indi_inac, 'N')
      into v_indi_inac
      from come_prod
     where prod_codi = i_prod_codi;
  
    if v_indi_inac = 'S' then
      raise_application_error(-20010, 'El producto se encuentra inactivo');
    end if;
  
    return true;
  
  exception
    when no_data_found then
      return false;
  end;

  function fp_buscar_prod_cod_barr(i_prod_codi_barr in number) return boolean is
    v_indi_inac varchar2(1);
  begin
    select nvl(prod_indi_inac, 'N')
      into v_indi_inac
      from come_prod
     where prod_codi_barr = i_prod_codi_barr;
  
    if v_indi_inac = 'S' then
      raise_application_error(-20010, 'El producto se encuentra inactivo');
    end if;
  
    return true;
  
  exception
    when no_data_found then
      return false;
  end;

  function fp_buscar_prod_cod_alfa(i_prod_codi_alfa in number) return boolean is
    v_indi_inac varchar2(1);
  begin
    select nvl(prod_indi_inac, 'N')
      into v_indi_inac
      from come_prod
     where prod_codi_alfa = i_prod_codi_alfa;
  
    if v_indi_inac = 'S' then
      raise_application_error(-20010, 'El producto se encuentra inactivo');
    end if;
  
    return true;
  
  exception
    when no_data_found then
      return false;
  end;

  function fp_devu_cuco_conc(p_conc_codi in number) return number is
    v_cuco_codi number;
  begin
  
    select conc_cuco_codi
      into v_cuco_codi
      from come_conc
     where conc_codi = p_conc_codi;
  
    return v_cuco_codi;
  
  exception
    when no_data_found then
      return null;
    
  end;

  procedure pp_buscar_costo_prod(p_prod_codi      in number,
                                 i_imfa_mone_codi in number,
                                 p_cost_mone      out number,
                                 p_cost_mone_ante out number) is
    vulco_cost_mmnn number;
  begin
  
    select max(d.imde_prec_unit_mone), max(d.imde_prec_unit_mone)
      into p_cost_mone, p_cost_mone_ante
      from come_impo_fact f, come_impo_fact_deta d
     where f.imfa_codi = d.imde_imfa_codi
       and f.imfa_tipo = 3 -- factura comercial
       and f.imfa_movi_codi is not null -- deuda generada
       and d.imde_prod_codi = p_prod_codi
       and f.imfa_mone_codi = i_imfa_mone_codi
       and f.imfa_fech =
           (select max(a.imfa_fech)
              from come_impo_fact a, come_impo_fact_deta b
             where a.imfa_codi = b.imde_imfa_codi
               and a.imfa_tipo = 3
               and a.imfa_movi_codi is not null
               and b.imde_prod_codi = p_prod_codi
               and a.imfa_mone_codi = i_imfa_mone_codi);
  
  exception
    when no_data_found then
      p_cost_mone      := 0;
      p_cost_mone_ante := 0;
    when others then
      raise_application_error(-2000, sqlerrm);
  end;

  /*********** inserciones  ********************/
  procedure pp_inser_deta(i_indi                in varchar2,
                          i_prod_codi           in number,
                          i_Seq                 in varchar2,
                          i_imde_cant           in number, -- cantidad
                          i_imde_cant_stk       in number,
                          i_imde_prec_unit_ante in number,
                          i_imde_porc_vari_prec in number,
                          i_imde_prec_unit_mone in number, --precio unitario
                          i_imde_deto_reca      in number, -- deto/reca
                          i_imde_porc_reca      in number,
                          i_imde_tota_mone_brut in number,
                          i_imde_tota_mone      in number) is
  
    v_marc_desc      come_marc.marc_desc%type;
    v_prod_codi_alfa come_prod.prod_codi_alfa%type;
    v_prod_codi_fabr come_prod.prod_codi_fabr%type;
    v_prod_codi_barr come_prod.prod_codi_barr%type;
    v_medi_codi      come_unid_medi.medi_codi%type;
    v_prod_fact_conv come_prod.prod_fact_conv%type;
    v_prod_desc      come_prod.prod_desc%type;
    v_medi_desc      come_unid_medi.medi_desc%type;
  
  begin
  
    -- Raise_application_error(-20010,'Holassss' ||i_indi);
  
    if i_indi = 'N' then
    
      select m.marc_desc,
             p.prod_codi_alfa,
             p.prod_codi_fabr,
             p.prod_codi_barr,
             u.medi_codi,
             p.prod_fact_conv,
             p.prod_desc,
             u.medi_desc
        into v_marc_desc,
             v_prod_codi_alfa,
             v_prod_codi_fabr,
             v_prod_codi_barr,
             v_medi_codi,
             v_prod_fact_conv,
             v_prod_desc,
             v_medi_desc
        from come_prod p, come_unid_medi u, come_marc m
       where nvl(p.prod_indi_inac, 'N') = 'N'
         and p.prod_marc_codi = m.marc_codi(+)
         and p.prod_medi_codi = u.medi_codi
         and p.prod_codi = i_prod_codi;
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_c001,
         taax_c002,
         taax_n001,
         taax_n002,
         taax_n003,
         taax_n004,
         taax_c003,
         taax_n005,
         taax_c004,
         taax_n006,
         taax_n007,
         taax_n008,
         taax_n009,
         taax_n010,
         taax_n011,
         taax_n012,
         taax_n013,
         taax_n014)
      values
        (p_sess,
         gen_user,
         seq_come_tabl_auxi.nextval,
         v_prod_desc,
         v_marc_desc,
         i_prod_codi,
         v_prod_codi_alfa,
         v_prod_codi_barr,
         v_medi_codi,
         v_medi_desc,
         v_prod_fact_conv,
         v_prod_codi_fabr,
         i_imde_cant, -- cantidad
         i_imde_cant_stk,
         i_imde_prec_unit_ante,
         i_imde_porc_vari_prec,
         i_imde_prec_unit_mone, --precio unitario
         i_imde_deto_reca, -- deto/reca
         i_imde_porc_reca,
         i_imde_tota_mone_brut,
         i_imde_tota_mone);
    
    elsif i_indi = 'U' then
    
      select m.marc_desc,
             p.prod_codi_alfa,
             p.prod_codi_fabr,
             p.prod_codi_barr,
             u.medi_codi,
             p.prod_fact_conv,
             p.prod_desc,
             u.medi_desc
        into v_marc_desc,
             v_prod_codi_alfa,
             v_prod_codi_fabr,
             v_prod_codi_barr,
             v_medi_codi,
             v_prod_fact_conv,
             v_prod_desc,
             v_medi_desc
        from come_prod p, come_unid_medi u, come_marc m
       where nvl(p.prod_indi_inac, 'N') = 'N'
         and p.prod_marc_codi = m.marc_codi(+)
         and p.prod_medi_codi = u.medi_codi
         and p.prod_codi = i_prod_codi;
    
      update come_tabl_auxi
         set taax_c001 = v_prod_desc,
             taax_c002 = v_marc_desc,
             taax_n001 = i_prod_codi,
             taax_n002 = v_prod_codi_alfa,
             taax_n003 = v_prod_codi_barr,
             taax_n004 = v_medi_codi,
             taax_c003 = v_medi_desc,
             taax_n005 = v_prod_fact_conv,
             taax_c004 = v_prod_codi_fabr,
             taax_n006 = i_imde_cant,
             taax_n007 = i_imde_cant_stk,
             taax_n008 = i_imde_prec_unit_ante,
             taax_n009 = i_imde_porc_vari_prec,
             taax_n010 = i_imde_prec_unit_mone,
             taax_n011 = i_imde_deto_reca,
             taax_n012 = i_imde_porc_reca,
             taax_n013 = i_imde_tota_mone_brut,
             taax_n014 = i_imde_tota_mone
       where taax_seq = i_seq;
    
    elsif i_indi = 'D' then
      delete from come_tabl_auxi where taax_seq = i_seq;
    
    end if;
  
  end pp_inser_deta;

  procedure pp_insert_come_fact(i_imfa_nume           come_impo_fact.imfa_nume%type,
                                i_imfa_movi_codi      come_impo_fact.imfa_movi_codi%type,
                                i_imfa_fech           come_impo_fact.imfa_fech%type,
                                i_imfa_obse           come_impo_fact.imfa_obse%type,
                                i_imfa_clpr_codi      come_impo_fact.imfa_clpr_codi%type,
                                i_imfa_tipo           come_impo_fact.imfa_tipo%type,
                                i_imfa_mone_codi      come_impo_fact.imfa_mone_codi%type,
                                i_imfa_impo_codi      come_impo_fact.imfa_impo_codi%type,
                                i_imfa_indi_ingr_stoc come_impo_fact.imfa_indi_ingr_stoc%type,
                                i_imfa_tasa_mone_deud come_impo_fact.imfa_tasa_mone_deud%type,
                                i_imfa_tasa_mmee_deud come_impo_fact.imfa_tasa_mmee_deud%type,
                                i_imfa_fech_deud      come_impo_fact.imfa_fech_deud%type,
                                i_imfa_fech_deud_venc come_impo_fact.imfa_fech_deud_venc%type) is
  
  begin
  
    select nvl(max(imfa_codi), 0) + 1 into v_imfa_codi from come_impo_fact;
  
    insert into come_impo_fact
      (imfa_codi,
       imfa_nume,
       imfa_movi_codi,
       imfa_fech,
       imfa_fech_grab,
       imfa_user,
       imfa_obse,
       imfa_clpr_codi,
       imfa_tipo,
       imfa_mone_codi,
       imfa_impo_codi,
       imfa_base,
       imfa_indi_ingr_stoc,
       imfa_tasa_mone_deud,
       imfa_tasa_mmee_deud,
       imfa_fech_deud,
       imfa_fech_deud_venc)
    values
      (v_imfa_codi,
       i_imfa_nume,
       i_imfa_movi_codi,
       i_imfa_fech,
       sysdate,
       gen_user,
       i_imfa_obse,
       i_imfa_clpr_codi,
       i_imfa_tipo,
       i_imfa_mone_codi,
       i_imfa_impo_codi,
       p_codi_base,
       i_imfa_indi_ingr_stoc,
       i_imfa_tasa_mone_deud,
       i_imfa_tasa_mmee_deud,
       i_imfa_fech_deud,
       i_imfa_fech_deud_venc);
  
  end pp_insert_come_fact;

  procedure pp_inserta_come_fact_deta(i_imfa_tasa_mone_deud in number) is
  
    v_cant_reg number; --cantidad de registros en el bloque
    i          number;
    j          number;
    salir      exception;
    v_ant_art  number;
  
    cursor c_deta is
      select taax_c001 v_prod_desc,
             taax_c002 v_marc_desc,
             taax_n001 v_imde_prod_codi,
             taax_n002 v_prod_codi_alfa,
             taax_n003 v_prod_codi_barr,
             taax_n004 v_medi_codi,
             taax_c003 v_medi_desc,
             taax_n005 v_prod_fact_conv,
             taax_c004 v_prod_codi_fabr,
             taax_n006 v_imde_cant, -- cantidad
             taax_n007 v_imde_cant_stk,
             taax_n008 v_imde_prec_unit_ante,
             taax_n009 v_imde_porc_vari_prec,
             taax_n010 v_imde_prec_unit_mone, --precio unitari
             taax_n011 v_imde_deto_reca, -- deto/reca
             taax_n012 v_imde_porc_reca,
             taax_n013 v_imde_tota_mone_brut,
             taax_n014 v_imde_tota_mone
        from come_tabl_auxi
       where taax_sess = p_sess
         and taax_user = gen_user;
  
    v_imde_imfa_codi come_impo_fact_deta.imde_imfa_codi%type;
    v_imde_nume_item come_impo_fact_deta.imde_nume_item%type := 0;
    v_imde_tota_mmnn come_impo_fact_deta.imde_tota_mmnn%type;
  
  begin
  
    for i in c_deta loop
    
      v_imde_nume_item := v_imde_nume_item + 1;
    
      v_imde_tota_mmnn := round((i.v_imde_tota_mone * i_imfa_tasa_mone_deud),
                                0);
    
      insert into come_impo_fact_deta
        (imde_imfa_codi,
         imde_nume_item,
         imde_prod_codi,
         imde_cant,
         imde_cant_stk,
         imde_prec_unit_mone,
         imde_porc_reca,
         imde_tota_mone,
         imde_tota_mmnn,
         imde_base,
         imde_iden_reca,
         imde_deto_reca,
         imde_tota_mone_brut,
         imde_medi_codi,
         --imde_tota_mmee,
         -- imde_indi_gene,
         -- imde_impo_reca_mone,
         -- imde_impo_reca_mmnn,
         imde_prec_unit_ante,
         imde_porc_vari_prec)
      values
        (v_imfa_codi,
         v_imde_nume_item,
         i.v_imde_prod_codi,
         i.v_imde_cant,
         i.v_imde_cant_stk,
         i.v_imde_prec_unit_mone,
         i.v_imde_porc_reca,
         i.v_imde_tota_mone,
         v_imde_tota_mmnn,
         p_codi_base,
         1,
         i.v_imde_deto_reca,
         i.v_imde_tota_mone_brut,
         i.v_medi_codi,
         --i.v_imde_tota_mmee,
         -- i.v_imde_indi_gene,
         -- i.v_imde_impo_reca_mone,
         -- i.v_imde_impo_reca_mmnn,
         i.v_imde_prec_unit_ante,
         i.v_imde_porc_vari_prec);
    
    end loop;
  
  end;

  procedure pp_eliminar_come_fact(i_imfa_codi in number) is
  begin
  
    delete come_impo_fact_deta where imde_imfa_codi = i_imfa_codi;
  
    delete come_impo_fact where imfa_codi = i_imfa_codi;
  
  end pp_eliminar_come_fact;

  /**************SECCION DE DEUDAS **********************/
  procedure pp_gene_deud is
  
    v_message varchar2(70) := '¿Desea Aplicar Adelantos?';
    v_count   number := 0;
  begin
    null;
  
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
  
    /*if v_count > 0 then
      if  fl_confirmar_reg(v_message) = upper('confirmar') then
        go_block('bdet');
        show_window('win_apli');
        pp_ejecutar_consulta_adelantos;
      else
        pp_genera_deuda;
      end if;
    else
      pp_genera_deuda;
    end if;*/
  
  end pp_gene_deud;

  procedure pp_valida_borrar_deuda(i_imfa_movi_codi in number,
                                   i_imfa_fech_deud in date) is
    v_count number;
  
  begin
  
    if i_imfa_movi_codi is null then
      raise_application_error(-20010, 'La deuda no fue generada aún..');
    end if;
  
    --validar que la deuda no tenga pagos asignados
    begin
      select count(*)
        into v_count
        from come_movi_cuot_canc
       where canc_cuot_movi_codi = i_imfa_movi_codi;
    
      if v_count > 0 then
        raise_application_error(-20010,
                                'Primero debe borrar los pagos asignados a esta deuda!!!');
      end if;
    end;
  
    --validar que la deuda no tenga diferencias de cambio
    begin
      select count(*)
        into v_count
        from come_movi_dife_camb
       where dica_movi_codi = i_imfa_movi_codi;
    
      if v_count > 0 then
        raise_application_error(-20010,
                                'No puede ser borrada esta deuda porque tiene Diferencias de Cambio ya procesadas!!!');
      end if;
    
    end;
  
    pp_valida_fech(i_imfa_fech_deud);
  
  end pp_valida_borrar_deuda;

  procedure pp_borrar_deuda(i_imfa_movi_codi in number,
                            i_imfa_codi      in number) is
    v_count     number;
    v_message   varchar2(70) := '¿Realmente desea borrar la deuda generada para esta factura?';
    v_imfa_codi number;
    v_movi_codi number;
  begin
  
    v_movi_codi := i_imfa_movi_codi;
    v_imfa_codi := i_imfa_codi;
  
    update come_impo_fact
       set imfa_movi_codi      = null,
           imfa_fech_deud      = null,
           imfa_fech_deud_venc = null
     where imfa_codi = v_imfa_Codi;
  
    delete come_movi_conc_deta where moco_movi_codi = v_movi_codi;
    delete come_movi_cuot where cuot_movi_codi = v_movi_codi;
    delete come_movi_impu_deta where moim_movi_codi = v_movi_codi;
    delete come_movi where movi_codi = v_movi_codi;
  
  end pp_borrar_deuda;

  procedure pp_valida_genera_deuda(i_imfa_movi_codi      in number,
                                   i_imfa_tipo           in number,
                                   i_imfa_fech_deud      in date,
                                   i_imfa_fech_deud_venc in date,
                                   i_imfa_tasa_mone_deud in number) is
  begin
  
    --Realizar las validaciones necesarias.. 
    if i_imfa_movi_codi is not null then
      raise_application_error(-20010,
                              'La deuda por esta Factura ya fue generada');
    end if;
  
    if i_imfa_tipo <> '3' then
      raise_application_error(-20010,
                              'Para generar la Deuda el documento debe ser del tipo Factura Comercial!!!');
    end if;
  
    if i_imfa_fech_deud is null then
      raise_application_error(-20010, 'Debe ingresar la fecha de la Deuda');
    end if;
  
    if i_imfa_fech_deud_venc is null then
      raise_application_error(-20010,
                              'Debe ingresar la fecha de Vencimiento de la Deuda');
    end if;
  
    if i_imfa_tasa_mone_deud is null then
      raise_application_error(-20010,
                              'Debe ingresar la tasa de la moneda de la Factura');
    end if;
  
    pp_valida_fech(i_imfa_fech_deud);
  
  end pp_valida_genera_deuda;

  procedure pp_genera_deuda(ii_imfa_codi           come_impo_fact.imfa_codi%type,
                            ii_imfa_movi_codi      come_impo_fact.imfa_movi_codi%type,
                            ii_imfa_tipo           come_impo_fact.imfa_tipo%type,
                            ii_imfa_fech_deud      come_impo_fact.imfa_fech_deud%type,
                            ii_imfa_fech_deud_venc come_impo_fact.imfa_fech_deud_venc%type,
                            ii_imfa_tasa_mone_deud come_impo_fact.imfa_tasa_mone_deud%type,
                            ii_imfa_tasa_mmee_deud come_impo_fact.imfa_tasa_mmee_deud%type,
                            ii_imfa_clpr_codi      come_impo_fact.imfa_clpr_codi%type,
                            ii_imfa_mone_codi      come_impo_fact.imfa_mone_codi%type,
                            ii_imfa_nume           come_impo_fact.imfa_nume%type,
                            ii_indi_apli_adel      in varchar2) is
  
    v_imfa_codi           number;
    v_imfa_fech_deud_venc date;
    v_imfa_fech_deud      date;
  
    v_IMFA_TASA_MONE_DEUD number;
  
    -- variable come_movi
  
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
    v_movi_obse                varchar2(2000);
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_dire           varchar2(100);
    v_movi_clpr_tele           varchar2(50);
    v_movi_clpr_ruc            varchar2(20);
    v_movi_clpr_desc           varchar2(80);
    v_movi_emit_reci           varchar2(1);
    v_movi_afec_sald           varchar2(1);
    v_movi_dbcr                varchar2(1);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_empr_codi           number(2);
    v_movi_clave_orig          number(20);
    v_movi_clave_orig_padr     number(20);
    v_movi_indi_iva_incl       varchar2(1);
    v_movi_empl_codi           number(10);
    v_movi_base                number(2);
    v_movi_indi_conta          varchar2(1);
    v_movi_ortr_codi           number(20);
    v_movi_impo_codi           number(20);
  
    v_movi_grav_mmnn number(20, 4);
    v_movi_exen_mmnn number(20, 4);
    v_movi_iva_mmnn  number(20, 4);
  
    v_movi_grav_mmee number(20, 4);
    v_movi_exen_mmee number(20, 4);
    v_movi_iva_mmee  number(20, 4);
  
    v_movi_grav_mone number(20, 4);
    v_movi_exen_mone number(20, 4);
    v_movi_iva_mone  number(20, 4);
  
    v_movi_sald_mmnn    number(20, 4);
    v_movi_sald_mmee    number(20, 4);
    v_movi_sald_mone    number(20, 4);
    v_movi_impo_mone_ii number(20, 4);
  
    v_movi_impo_mmnn_ii   number(20, 4);
    v_movi_grav10_ii_mone number(20, 4);
    v_movi_grav5_ii_mone  number(20, 4);
    v_movi_grav10_ii_mmnn number(20, 4);
    v_movi_grav5_ii_mmnn  number(20, 4);
    v_movi_grav10_mone    number(20, 4);
    v_movi_grav5_mone     number(20, 4);
    v_movi_grav10_mmnn    number(20, 4);
    v_movi_grav5_mmnn     number(20, 4);
    v_movi_iva10_mone     number(20, 4);
    v_movi_iva5_mone      number(20, 4);
    v_movi_iva10_mmnn     number(20, 4);
    v_movi_iva5_mmnn      number(20, 4);
  
    --variables come_movi_conc_deta
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_dbcr      char(1);
  
    v_moco_impo_mmnn      number(20, 4);
    v_moco_impo_mmee      number(20, 4);
    v_moco_impo_mone      number(20, 4);
    v_moco_impo_mone_ii   number(20, 4);
    v_moco_impo_mmnn_ii   number(20, 4);
    v_moco_grav10_ii_mone number(20, 4);
    v_moco_grav5_ii_mone  number(20, 4);
    v_moco_grav10_ii_mmnn number(20, 4);
    v_moco_grav5_ii_mmnn  number(20, 4);
    v_moco_grav10_mone    number(20, 4);
    v_moco_grav5_mone     number(20, 4);
    v_moco_grav10_mmnn    number(20, 4);
    v_moco_grav5_mmnn     number(20, 4);
    v_moco_iva10_mone     number(20, 4);
    v_moco_iva5_mone      number(20, 4);
    v_moco_iva10_mmnn     number(20, 4);
    v_moco_iva5_mmnn      number(20, 4);
    v_moco_exen_mone      number(20, 4);
    v_moco_exen_mmnn      number(20, 4);
  
    -- variable come_movi_cuot 
    v_cuot_fech_venc           date;
    v_cuot_nume                number(4);
    v_cuot_impo_mone           number(20, 4);
    v_cuot_impo_mmnn           number(20, 4);
    v_cuot_impo_mmee           number(20, 4);
    v_cuot_sald_mone           number(20, 4);
    v_cuot_sald_mmnn           number(20, 4);
    v_cuot_sald_mmee           number(20, 4);
    v_cuot_movi_codi           number(20);
    v_cuot_base                number(2);
    v_cuot_impo_dife_camb      number(20, 4);
    v_cuot_indi_proc_dife_camb varchar2(1);
    v_cuot_impo_dife_camb_sald number(20, 4);
    v_cuot_tasa_dife_camb      number(20, 4);
    v_cuot_orpa_codi           number(20);
    v_cuot_indi_refi           varchar2(1);
    v_cuot_codi                number(10);
    v_cuot_desc                varchar2(60);
    v_cuot_impu_codi           number(10);
    v_cuot_tipo                varchar2(1);
    v_cuot_nume_desc           varchar2(10);
    v_cuot_corr_mes            date;
    v_cuot_obse                varchar2(100);
    v_cuot_esta_gene_plan      varchar2(1);
    v_cuot_fpj_codi            number(10);
    v_cuot_id                  number(10);
    --variables de come_movi_impu_deta
  
    v_moim_impu_codi      number(10);
    v_moim_movi_codi      number(20);
    v_moim_impo_mmnn      number(20, 4);
    v_moim_impo_mmee      number(20, 4);
    v_moim_impu_mmnn      number(20, 4);
    v_moim_impu_mmee      number(20, 4);
    v_moim_impo_mone      number(20, 4);
    v_moim_impu_mone      number(20, 4);
    v_moim_base           number(2);
    v_moim_tiim_codi      number(10);
    v_moim_impo_mone_ii   number(20, 4);
    v_moim_impo_mmnn_ii   number(20, 4);
    v_moim_grav10_ii_mone number(20, 4);
    v_moim_grav5_ii_mone  number(20, 4);
    v_moim_grav10_ii_mmnn number(20, 4);
    v_moim_grav5_ii_mmnn  number(20, 4);
    v_moim_grav10_mone    number(20, 4);
    v_moim_grav5_mone     number(20, 4);
    v_moim_grav10_mmnn    number(20, 4);
    v_moim_grav5_mmnn     number(20, 4);
    v_moim_iva10_mone     number(20, 4);
    v_moim_iva5_mone      number(20, 4);
    v_moim_iva10_mmnn     number(20, 4);
    v_moim_iva5_mmnn      number(20, 4);
    v_moim_exen_mone      number(20, 4);
    v_moim_exen_mmnn      number(20, 4);
  
    v_imfa_tasa_mmee_deud come_impo_fact.imfa_tasa_mmee_deud%type;
  
  begin
  
    -- validamos todo antes
    I020131.pp_valida_genera_deuda(i_imfa_movi_codi      => ii_imfa_movi_codi,
                                   i_imfa_tipo           => ii_imfa_tipo,
                                   i_imfa_fech_deud      => ii_imfa_fech_deud,
                                   i_imfa_fech_deud_venc => ii_imfa_fech_deud_venc,
                                   i_imfa_tasa_mone_deud => ii_imfa_tasa_mone_deud);
  
    if ii_imfa_tasa_mmee_deud is null then
      --     raise_application_error(-20010,'Debe ingresar la tasa de la moneda extranjera');
      v_imfa_tasa_mmee_deud := ii_imfa_tasa_mone_deud;
    else
      v_imfa_tasa_mmee_deud := ii_imfa_tasa_mmee_deud;
    end if;
  
    --obtenemos el total 
    select sum(taax_n014)
      into v_movi_exen_mone
      from come_tabl_auxi
     where taax_sess = p_sess
       and taax_user = gen_user;
  
    v_movi_codi := fa_sec_come_movi;
    p_movi_codi_deud := v_movi_codi;
    v_movi_timo_codi      := p_codi_timo_deuimp;
    v_movi_clpr_codi      := ii_imfa_clpr_codi;
    v_movi_sucu_codi_orig := p_sucu_codi;
    v_movi_depo_codi_orig := null;
    v_movi_sucu_codi_dest := null;
    v_movi_depo_codi_dest := null;
    v_movi_oper_codi      := null; --no genera movimiento de stoc
    v_movi_cuen_codi      := null; --no afecta caja..
    v_movi_mone_codi      := ii_imfa_mone_codi;
    v_movi_nume           := ii_imfa_nume;
    v_movi_fech_emis      := ii_imfa_fech_deud;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_codi_padr      := null;
    v_movi_tasa_mone      := ii_imfa_tasa_mone_deud;
    v_movi_tasa_mmee      := v_imfa_tasa_mmee_deud;
  
    v_movi_grav_mmnn := 0;
    v_movi_iva_mmnn  := 0;
    v_movi_grav_mmee := 0;
    v_movi_iva_mmee  := 0;
    v_movi_grav_mone := 0;
    v_movi_iva_mone  := 0;
  
    v_movi_exen_mmnn := round((v_movi_exen_mone * ii_imfa_tasa_mone_deud),
                              p_cant_deci_mmnn); --i_mone_cant_deci);
  
    v_movi_exen_mmee := round((v_movi_exen_mmnn / v_imfa_tasa_mmee_deud),
                              p_cant_deci_mmee);
  
    v_movi_obse                := null;
    v_movi_sald_mmnn           := v_movi_exen_mmnn;
    v_movi_sald_mmee           := v_movi_exen_mmee;
    v_movi_sald_mone           := v_movi_exen_mone;
    v_movi_stoc_suma_rest      := null;
    v_movi_clpr_dire           := null;
    v_movi_clpr_tele           := null;
    v_movi_clpr_ruc            := null;
    v_movi_clpr_desc           := null;
    v_movi_emit_reci           := 'R';
    v_movi_afec_sald           := 'P';
    v_movi_dbcr                := 'C';
    v_movi_stoc_afec_cost_prom := 'N';
    v_movi_empr_codi           := p_empr_codi;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := 'N';
    v_movi_empl_codi           := null;
    v_movi_base                := p_codi_base;
    v_movi_indi_conta          := 'N';
    v_movi_ortr_codi           := null;
    v_movi_impo_codi           := null;
  
    v_movi_grav_mmnn := 0;
    --v_movi_exen_mmnn                number(20,4);
    v_movi_iva_mmnn := 0;
  
    v_movi_grav_mmee := 0;
    --v_movi_exen_mmee                number(20,4);
    v_movi_iva_mmee := 0;
  
    v_movi_grav_mone := 0;
    --v_movi_exen_mone                number(20,4);
    v_movi_iva_mone := 0;
  
    --v_movi_sald_mmnn                number(20,4);
    --v_movi_sald_mmee                number(20,4);
    --v_movi_sald_mone                number(20,4);
  
    v_movi_impo_mone_ii   := v_movi_exen_mone;
    v_movi_impo_mmnn_ii   := v_movi_exen_mmnn;
    v_movi_grav10_ii_mone := 0;
    v_movi_grav5_ii_mone  := 0;
    v_movi_grav10_ii_mmnn := 0;
    v_movi_grav5_ii_mmnn  := 0;
    v_movi_grav10_mone    := 0;
    v_movi_grav5_mone     := 0;
    v_movi_grav10_mmnn    := 0;
    v_movi_grav5_mmnn     := 0;
    v_movi_iva10_mone     := 0;
    v_movi_iva5_mone      := 0;
    v_movi_iva10_mmnn     := 0;
    v_movi_iva5_mmnn      := 0;
  
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
       movi_base,
       movi_indi_conta,
       movi_ortr_codi,
       movi_impo_codi,
       movi_impo_mone_ii,
       movi_impo_mmnn_ii,
       movi_grav10_ii_mone,
       movi_grav5_ii_mone,
       movi_grav10_ii_mmnn,
       movi_grav5_ii_mmnn,
       movi_grav10_mone,
       movi_grav5_mone,
       movi_grav10_mmnn,
       movi_grav5_mmnn,
       movi_iva10_mone,
       movi_iva5_mone,
       movi_iva10_mmnn,
       movi_iva5_mmnn)
    values
      (v_movi_codi,
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
       v_movi_base,
       v_movi_indi_conta,
       v_movi_ortr_codi,
       v_movi_impo_codi,
       v_movi_impo_mone_ii,
       v_movi_impo_mmnn_ii,
       v_movi_grav10_ii_mone,
       v_movi_grav5_ii_mone,
       v_movi_grav10_ii_mmnn,
       v_movi_grav5_ii_mmnn,
       v_movi_grav10_mone,
       v_movi_grav5_mone,
       v_movi_grav10_mmnn,
       v_movi_grav5_mmnn,
       v_movi_iva10_mone,
       v_movi_iva5_mone,
       v_movi_iva10_mmnn,
       v_movi_iva5_mmnn);
  
    ----actualizar come_movi_conc_deta.... 
  
    v_moco_movi_codi := v_movi_codi;
    v_moco_nume_item := 0;
    v_moco_conc_codi := p_codi_conc_com_imp;
    v_moco_dbcr      := 'C';
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := fp_devu_cuco_conc(v_moco_conc_codi);
  
    v_moco_impu_codi := p_codi_impu_exen;
  
    v_moco_impo_mmnn := v_movi_exen_mmnn;
    v_moco_impo_mmee := v_movi_exen_mmee;
    v_moco_impo_mone := v_movi_exen_mone;
  
    v_moco_impo_mone_ii   := v_moco_impo_mone;
    v_moco_impo_mmnn_ii   := v_moco_impo_mmnn;
    v_moco_grav10_ii_mone := 0;
    v_moco_grav5_ii_mone  := 0;
    v_moco_grav10_ii_mmnn := 0;
    v_moco_grav5_ii_mmnn  := 0;
    v_moco_grav10_mone    := 0;
    v_moco_grav5_mone     := 0;
    v_moco_grav10_mmnn    := 0;
    v_moco_grav5_mmnn     := 0;
    v_moco_iva10_mone     := 0;
    v_moco_iva5_mone      := 0;
    v_moco_iva10_mmnn     := 0;
    v_moco_iva5_mmnn      := 0;
    v_moco_exen_mone      := v_movi_exen_mone;
    v_moco_exen_mmnn      := v_movi_exen_mmnn;
  
    insert into come_movi_conc_deta
      (moco_movi_codi,
       moco_nume_item,
       moco_conc_codi,
       moco_cuco_codi,
       moco_impu_codi,
       moco_impo_mmnn,
       moco_impo_mmee,
       moco_impo_mone,
       moco_dbcr,
       moco_base,
       moco_impo_mone_ii,
       moco_impo_mmnn_ii,
       moco_grav10_ii_mone,
       moco_grav5_ii_mone,
       moco_grav10_ii_mmnn,
       moco_grav5_ii_mmnn,
       moco_grav10_mone,
       moco_grav5_mone,
       moco_grav10_mmnn,
       moco_grav5_mmnn,
       moco_iva10_mone,
       moco_iva5_mone,
       moco_iva10_mmnn,
       moco_iva5_mmnn,
       moco_exen_mone,
       moco_exen_mmnn)
    values
      (v_moco_movi_codi,
       v_moco_nume_item,
       v_moco_conc_codi,
       v_moco_cuco_codi,
       v_moco_impu_codi,
       v_moco_impo_mmnn,
       v_moco_impo_mmee,
       v_moco_impo_mone,
       v_moco_dbcr,
       1,
       v_moco_impo_mone_ii,
       v_moco_impo_mmnn_ii,
       v_moco_grav10_ii_mone,
       v_moco_grav5_ii_mone,
       v_moco_grav10_ii_mmnn,
       v_moco_grav5_ii_mmnn,
       v_moco_grav10_mone,
       v_moco_grav5_mone,
       v_moco_grav10_mmnn,
       v_moco_grav5_mmnn,
       v_moco_iva10_mone,
       v_moco_iva5_mone,
       v_moco_iva10_mmnn,
       v_moco_iva5_mmnn,
       v_moco_exen_mone,
       v_moco_exen_mmnn);
  
    ----actualizar come_movi_cuot
    v_cuot_fech_venc := ii_imfa_fech_deud_venc;
    v_cuot_nume      := 1;
    v_cuot_impo_mone := v_movi_exen_mone;
    v_cuot_impo_mmnn := v_movi_exen_mmnn;
    v_cuot_impo_mmee := v_movi_exen_mmee;
  
    v_cuot_sald_mone := v_cuot_impo_mone;
    v_cuot_sald_mmnn := v_cuot_impo_mmnn;
    v_cuot_sald_mmee := v_cuot_impo_mmee;
  
    v_cuot_movi_codi := v_movi_codi;
    v_cuot_tipo      := 'C';
    v_cuot_codi      := 1;
  
    v_imfa_fech_deud      := ii_imfa_fech_deud;
    v_imfa_fech_deud_venc := ii_imfa_fech_deud_venc;
  
    v_imfa_codi := ii_imfa_codi;
  
    v_imfa_tasa_mone_deud := ii_imfa_tasa_mone_deud;
  
    insert into come_movi_cuot
      (cuot_fech_venc,
       cuot_nume,
       cuot_impo_mone,
       cuot_impo_mmnn,
       cuot_impo_mmee,
       cuot_sald_mone,
       cuot_sald_mmnn,
       cuot_sald_mmee,
       cuot_movi_codi,
       cuot_base,
       cuot_impo_dife_camb,
       cuot_indi_proc_dife_camb,
       cuot_impo_dife_camb_sald,
       cuot_tasa_dife_camb,
       cuot_orpa_codi,
       cuot_indi_refi,
       cuot_codi,
       cuot_desc,
       cuot_impu_codi,
       cuot_tipo,
       cuot_nume_desc,
       cuot_corr_mes,
       cuot_obse,
       cuot_esta_gene_plan,
       cuot_fpj_codi,
       cuot_id)
    values
      (v_cuot_fech_venc,
       v_cuot_nume,
       v_cuot_impo_mone,
       v_cuot_impo_mmnn,
       v_cuot_impo_mmee,
       v_cuot_sald_mone,
       v_cuot_sald_mmnn,
       v_cuot_sald_mmee,
       v_cuot_movi_codi,
       v_cuot_base,
       v_cuot_impo_dife_camb,
       v_cuot_indi_proc_dife_camb,
       v_cuot_impo_dife_camb_sald,
       v_cuot_tasa_dife_camb,
       v_cuot_orpa_codi,
       v_cuot_indi_refi,
       v_cuot_codi,
       v_cuot_desc,
       v_cuot_impu_codi,
       v_cuot_tipo,
       v_cuot_nume_desc,
       v_cuot_corr_mes,
       v_cuot_obse,
       v_cuot_esta_gene_plan,
       v_cuot_fpj_codi,
       v_cuot_id);
  
    v_moim_impu_codi      := p_codi_impu_exen;
    v_moim_movi_codi      := v_movi_codi;
    v_moim_impo_mmnn      := v_moco_exen_mmnn;
    v_moim_impo_mmee      := v_movi_exen_mmee;
    v_moim_impu_mmnn      := 0;
    v_moim_impu_mmee      := 0;
    v_moim_impo_mone      := v_moco_impo_mone;
    v_moim_impu_mone      := 0;
    v_moim_base           := 1;
    v_moim_tiim_codi      := 1;
    v_moim_impo_mone_ii   := v_moco_exen_mone;
    v_moim_impo_mmnn_ii   := v_moco_exen_mmnn;
    v_moim_grav10_ii_mone := 0;
    v_moim_grav5_ii_mone  := 0;
    v_moim_grav10_ii_mmnn := 0;
    v_moim_grav5_ii_mmnn  := 0;
    v_moim_grav10_mone    := 0;
    v_moim_grav5_mone     := 0;
    v_moim_grav10_mmnn    := 0;
    v_moim_grav5_mmnn     := 0;
    v_moim_iva10_mone     := 0;
    v_moim_iva5_mone      := 0;
    v_moim_iva10_mmnn     := 0;
    v_moim_iva5_mmnn      := 0;
    v_moim_exen_mone      := v_moco_exen_mone;
    v_moim_exen_mmnn      := v_moco_exen_mmnn;
  
    insert into come_movi_impu_deta
      (moim_impu_codi,
       moim_movi_codi,
       moim_impo_mmnn,
       moim_impo_mmee,
       moim_impu_mmnn,
       moim_impu_mmee,
       moim_impo_mone,
       moim_impu_mone,
       moim_base,
       moim_tiim_codi,
       moim_impo_mone_ii,
       moim_impo_mmnn_ii,
       moim_grav10_ii_mone,
       moim_grav5_ii_mone,
       moim_grav10_ii_mmnn,
       moim_grav5_ii_mmnn,
       moim_grav10_mone,
       moim_grav5_mone,
       moim_grav10_mmnn,
       moim_grav5_mmnn,
       moim_iva10_mone,
       moim_iva5_mone,
       moim_iva10_mmnn,
       moim_iva5_mmnn,
       moim_exen_mone,
       moim_exen_mmnn)
    values
      (v_moim_impu_codi,
       v_moim_movi_codi,
       v_moim_impo_mmnn,
       v_moim_impo_mmee,
       v_moim_impu_mmnn,
       v_moim_impu_mmee,
       v_moim_impo_mone,
       v_moim_impu_mone,
       v_moim_base,
       v_moim_tiim_codi,
       v_moim_impo_mone_ii,
       v_moim_impo_mmnn_ii,
       v_moim_grav10_ii_mone,
       v_moim_grav5_ii_mone,
       v_moim_grav10_ii_mmnn,
       v_moim_grav5_ii_mmnn,
       v_moim_grav10_mone,
       v_moim_grav5_mone,
       v_moim_grav10_mmnn,
       v_moim_grav5_mmnn,
       v_moim_iva10_mone,
       v_moim_iva5_mone,
       v_moim_iva10_mmnn,
       v_moim_iva5_mmnn,
       v_moim_exen_mone,
       v_moim_exen_mmnn);
  
    if ii_indi_apli_adel = 'S' then
      if ii_IMFA_FECH_DEUD is not null and  ii_IMFA_FECH_DEUD_VENC is not null then

  I020131.pp_actualiza_canc(i_imfa_clpr_codi      => ii_imfa_clpr_codi,
                            i_imfa_mone_codi      => ii_imfa_mone_codi,
                            i_imfa_nume           => ii_imfa_nume,
                            i_imfa_fech_deud      => ii_imfa_fech_deud,
                            i_imfa_fech_deud_venc => ii_imfa_fech_deud_venc,
                            i_imfa_tasa_mone_deud => ii_imfa_tasa_mone_deud);


      end if;
    end if;
  
    commit;
  
    update come_impo_fact
       set imfa_movi_codi      = v_movi_codi,
           imfa_fech_deud      = v_imfa_fech_deud,
           imfa_fech_deud_venc = v_imfa_fech_deud_venc,
           IMFA_TASA_MONE_DEUD = v_imfa_tasa_mone_deud,
           IMFA_TASA_MMEE_DEUD = v_imfa_tasa_mone_deud
     where imfa_codi = v_imfa_codi;
  
    commit;
  
  end pp_genera_deuda;

  procedure pp_ejecutar_consulta_adelantos(i_imfa_clpr_codi in number,
                                           i_imfa_mone_codi in number) is
    cursor cv_adel is
      select movi_codi,
             movi_nume,
             timo_desc,
             movi_fech_emis,
             cuot_fech_venc,
             cuot_impo_mone,
             cuot_sald_mone,
             cuot_tipo,
             movi_tasa_mone cuot_tasa_mone,
             movi_clpr_codi clpr_codi
        from come_movi a, come_movi_cuot, come_tipo_movi
       where movi_codi = cuot_movi_codi
         and movi_timo_codi = 31
         and movi_timo_codi = timo_codi
         and nvl(movi_sald_mone, 0) <> 0
         and movi_clpr_codi = i_imfa_clpr_codi
         and movi_mone_codi = i_imfa_mone_codi;
  begin
  
    --raise_application_error(-20010, i_imfa_clpr_codi||' + '||i_imfa_mone_codi);
  
    delete from come_tabl_auxi
     where taax_sess = p_sess
       and taax_user = gen_user
       and taax_c050 = 'ADEL';
  
    for r in cv_adel loop
    
      insert into come_tabl_auxi
        (taax_sess,
         taax_user,
         taax_seq,
         taax_n001,
         taax_n002,
         taax_d001,
         taax_n003,
         taax_n004,
         taax_n005,
         taax_c001,
         taax_d002,
         taax_n006,
         taax_n007,
         taax_c002,
         taax_c003,
         taax_c050)
      values
        (p_sess,
         gen_user,
         seq_come_tabl_auxi.nextval,
         r.cuot_tasa_mone,
         r.movi_codi,
         r.cuot_fech_venc,
         r.cuot_impo_mone,
         r.cuot_sald_mone,
         r.movi_nume,
         r.timo_desc,
         r.movi_fech_emis,
         r.clpr_codi,
         0,
         r.cuot_tipo,
         'N',
         'ADEL');
    
    end loop;
  
  end;

  procedure pp_muestra_come_tipo_movi(p_timo_codi      in number,
                                      p_timo_Desc      out char,
                                      p_timo_Desc_abre out char,
                                      p_timo_afec_sald out char,
                                      p_timo_dbcr      out char,
                                      p_timo_indi_adel out char,
                                      p_timo_indi_ncr  out char,
                                      p_indi_vali      in char) is
  
    v_dbcr varchar2(1);
  begin
  
    select timo_desc,
           timo_desc_abre,
           timo_afec_sald,
           timo_dbcr,
           nvl(timo_indi_adel, 'N'),
           nvl(timo_indi_ncr, 'N')
      into p_timo_desc,
           p_timo_desc_abre,
           p_timo_afec_sald,
           p_timo_dbcr,
           p_timo_indi_adel,
           p_timo_indi_ncr
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
    if p_indi_vali = 'S' then
      if p_timo_indi_adel = 'N' and p_timo_indi_ncr = 'N' then
        raise_application_error(-20010,
                                'Solo se pueden ingresar movimientos del tipo Adelantos/Notas de Creditos');
      end if;
    
      if p_timo_indi_adel = 'S' and p_timo_indi_ncr = 'S' then
        raise_application_error(-20010,
                                'El tipo de movimiento esta configurado como Adelanto y Nota de Credito al mismo tiempo, Favor Verificar..');
      end if;
    end if;
    if p_emit_reci = 'R' then
      v_dbcr := 'D';
    else
      v_dbcr := 'C';
    end if;
  
    if p_indi_vali = 'S' then
      if p_timo_dbcr <> v_dbcr then
        raise_application_error(-20010, 'Tipo de Movimiento incorrecto');
      end if;
    end if;
  
  exception
    when no_data_found then
      p_timo_desc_abre := null;
      p_timo_desc      := null;
      p_timo_afec_sald := null;
      p_timo_dbcr      := null;
      p_timo_indi_adel := null;
      p_timo_indi_ncr  := null;
      raise_application_error(-20010, 'Tipo de Movimiento Inexistente!');
    when others then
      raise_application_error(-20010, 'Error gral en Movi Tipo');
    
  end pp_muestra_come_tipo_movi;

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
                                p_movi_base                in number,
                                p_movi_indi_conta          in varchar2,
                                p_movi_ortr_codi           in number,
                                p_movi_impo_codi           in number) is
  
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
       movi_base,
       movi_indi_conta,
       movi_ortr_codi,
       movi_impo_codi)
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
       p_movi_base,
       p_movi_indi_conta,
       p_movi_ortr_codi,
       p_movi_impo_codi);
  
  end;

begin

  begin
    select timo_emit_reci, timo_dbcr
      into p_emit_reci, p_timo_dbcr
      from come_tipo_movi
     where timo_codi = p_codi_timo_deuimp;
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Debe configurar correctamente el parametro p_codi_timo_deuimp. Tipo de movimiento inexistente.');
    when others then
      raise_application_error(-20010,
                              'Error en el parametro p_codi_timo_deuimp. Tipo de movimiento inexistente.');
  end;

end I020131;
