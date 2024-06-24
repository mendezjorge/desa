
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020226" is

  type t_parameter is record(
    
    p_cant_deci_mmnn               number := to_number(fa_busc_para('p_cant_deci_mmnn')),
    p_codi_mone_mmnn               number := to_number(fa_busc_para('p_codi_mone_mmnn')),
    p_codi_impu_grav10             number := to_number(fa_busc_para('p_codi_impu_grav10')),
    p_codi_impu_exen               number := to_number(fa_busc_para('p_codi_impu_exen')),
    p_codi_timo_depo_tarj          number := to_number(fa_busc_para('p_codi_timo_depo_tarj')),
    p_codi_timo_liqu_tarj          number := to_number(fa_busc_para('p_codi_timo_fcor')),
    p_codi_timo_rete_reci          number := to_number(fa_busc_para('p_codi_timo_rete_reci')),
    p_codi_conc_iva_comi_liqu      number := to_number(fa_busc_para('p_codi_conc_iva_comi_liqu')),
    p_codi_conc_rete_rent_liqu     number := to_number(fa_busc_para('p_codi_conc_rete_rent_liqu')),
    p_codi_conc_iva_rete_rent_liqu number := to_number(fa_busc_para('p_codi_conc_iva_rete_rent_liqu')),
    p_fech_inic                    date,
    p_fech_fini                    date,
    p_codi_base                    number := 1);

  parameter t_parameter;

  type t_cabe_1 is record(
    
    movi_mone_cant_deci      number,
    movi_codi                number,
    CLPR_CODI_ALTE           number,
    CLPR_CODI                number,
    CLPR_INDI_CLIE_PROV      varchar2(100),
    CLPR_PROV_RETENER        varchar2(100),
    MOVI_CONC_CODI           number,
    MOVI_DBCR                varchar2(100),
    MOVI_FECH_EMIS           date,
    MOVI_FECH_EMIS_DESD      date,
    MOVI_FECH_EMIS_HAST      date,
    MOVI_FECH_OPER           date,
    MOVI_MONE_CODI           number,
    MOVI_NUME                number,
    MOVI_NUME_TIMB           number,
    MOVI_OBSE                varchar2(100),
    MOVI_SUCU_CODI_ORIG      number,
    MOVI_TASA_MONE           number,
    MOVI_TIMO_CODI           number,
    SUM_IMPO_DETO            number,
    SUM_IMPO_MONE_NETO       number,
    SUM_S_IMPO_COMI          number,
    SUM_S_IMPO_DETO          number,
    SUM_S_IMPO_IVA           number,
    SUM_S_IMPO_IVA_RETE_RENT number,
    SUM_S_IMPO_MONE          number,
    SUM_S_IMPO_MONE_NETO     number,
    SUM_S_IMPO_RETE_RENT     number,
    SUM_W_IMPO_COMI          number,
    SUM_W_IMPO_IVA           number,
    SUM_W_IMPO_IVA_RETE_RENT number,
    SUM_W_IMPO_MONE          number,
    SUM_W_IMPO_RETE_RENT     number,
    FECH_VENC_TIMB           date,
    S_NRO_1                  number,
    S_NRO_2                  number,
    S_NRO_3                  number,
    TAPR_CODI                number,
    TAPR_PORC_COMI           number,
    TAPR_PORC_IVA            number,
    TAPR_PORC_RETE_IVA       number,
    TAPR_PORC_RETE_RENT      number,
    TICO_CODI                number,
    TICO_FECH_REIN           date,
    TICO_INDI_HABI_TIMB      varchar2(50),
    TICO_INDI_TIMB           varchar2(50),
    TICO_INDI_TIMB_AUTO      varchar2(50),
    TICO_INDI_VALI_TIMB      varchar2(50)
    
    );
  bcab t_cabe_1;

  /********************** funciones reutilizadas **************************/
  procedure pl_me(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010,
                            dbms_utility.format_error_backtrace || ' ' ||
                            v_mensaje);
  end pl_me;

  procedure pp_actualiza_registro is
  begin
  
    pp_valida_fech(bcab.movi_fech_emis);
    pp_valida_importes;
  
    --TM63
    begin
      pp_actualiza_movi;
    exception
      when others then
        raise_application_error(-20010,
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                'pp_actualiza_movi');
    end;
  
    begin
      pp_actualiza_moco;
    exception
      when others then
        raise_application_error(-20010,
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                'pp_actualiza_moco');
    end;
  
    begin
      pp_actualiza_moimpu;
    exception
      when others then
        raise_application_error(-20010,
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                'pp_actualiza_moimpu');
    end;
  
    begin
      pp_actualiza_tarjeta;
    exception
      when others then
        raise_application_error(-20010,
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                'pp_actualiza_tarjeta');
    end;
  
  end;

  procedure pp_actualiza_movi is
    v_movi_codi               number;
    v_movi_cuen_codi          number;
    v_movi_timo_codi          number;
    v_movi_clpr_codi          number;
    v_movi_sucu_codi_orig     number;
    v_movi_mone_codi          number;
    v_movi_nume               number;
    v_movi_nume_timb          number;
    v_movi_fech_emis          date;
    v_movi_fech_grab          date;
    v_movi_user               char(20);
    v_movi_codi_padr          number;
    v_movi_tasa_mone          number;
    v_movi_tasa_mmee          number;
    v_movi_grav_mmnn          number;
    v_movi_exen_mmnn          number;
    v_movi_iva_mmnn           number;
    v_movi_grav_mmee          number;
    v_movi_exen_mmee          number;
    v_movi_iva_mmee           number;
    v_movi_grav_mone          number;
    v_movi_exen_mone          number;
    v_movi_iva_mone           number;
    v_movi_impo_mone_ii       number;
    v_movi_impo_mmnn_ii       number;
    v_movi_grav10_ii_mone     number;
    v_movi_grav10_ii_mmnn     number;
    v_movi_grav5_ii_mone      number;
    v_movi_grav5_ii_mmnn      number;
    v_movi_grav10_mone        number;
    v_movi_grav10_mmnn        number;
    v_movi_grav5_mone         number;
    v_movi_grav5_mmnn         number;
    v_movi_iva10_mone         number;
    v_movi_iva10_mmnn         number;
    v_movi_iva5_mone          number;
    v_movi_iva5_mmnn          number;
    v_movi_clpr_desc          char(80);
    v_movi_emit_reci          char(1);
    v_movi_afec_sald          char(1);
    v_movi_dbcr               char(1);
    v_movi_empr_codi          number;
    v_movi_obse               varchar2(2000);
    v_movi_indi_liqu_tarj     varchar2(1);
    v_movi_tacu_comi          number;
    v_movi_tacu_iva           number;
    v_movi_tacu_rete_rent     number;
    v_movi_tacu_iva_rete_rent number;
  
  begin
  
    --insertar la cabecera del deposito bancario.................................
    pp_muestra_tipo_movi(parameter.p_codi_timo_liqu_tarj,
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr);
  
    v_movi_codi           := fa_sec_come_movi;
    bcab.movi_codi        := v_movi_codi;
    v_movi_timo_codi      := parameter.p_codi_timo_liqu_tarj;
    v_movi_clpr_codi      := bcab.clpr_codi;
    v_movi_cuen_codi      := null;
    bcab.movi_dbcr        := v_movi_dbcr;
    v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
    v_movi_mone_codi      := bcab.movi_mone_codi;
    v_movi_nume           := bcab.movi_nume;
    v_movi_nume_timb      := bcab.movi_nume_timb;
    v_movi_fech_emis      := bcab.movi_fech_emis;
    v_movi_fech_grab      := sysdate;
    v_movi_user           := gen_user;
    v_movi_codi_padr      := null;
    v_movi_tasa_mone      := bcab.movi_tasa_mone;
    v_movi_tasa_mmee      := 0;
  
    v_movi_grav_mmnn          := round((bcab.SUM_W_IMPO_COMI *
                                       bcab.movi_tasa_mone),
                                       parameter.p_cant_deci_mmnn);
    v_movi_exen_mmnn          := 0;
    v_movi_iva_mmnn           := round((bcab.SUM_W_IMPO_IVA *
                                       bcab.movi_tasa_mone),
                                       parameter.p_cant_deci_mmnn);
    v_movi_grav_mmee          := 0;
    v_movi_exen_mmee          := 0;
    v_movi_iva_mmee           := 0;
    v_movi_grav_mone          := round(bcab.SUM_W_IMPO_COMI,
                                       bcab.movi_mone_cant_deci);
    v_movi_exen_mone          := 0;
    v_movi_iva_mone           := round(bcab.SUM_W_IMPO_IVA,
                                       bcab.movi_mone_cant_deci);
    v_movi_impo_mone_ii       := round((bcab.SUM_W_IMPO_COMI +
                                       bcab.SUM_W_IMPO_IVA),
                                       bcab.movi_mone_cant_deci);
    v_movi_impo_mmnn_ii       := round(((bcab.SUM_W_IMPO_COMI +
                                       bcab.SUM_W_IMPO_IVA) *
                                       bcab.movi_tasa_mone),
                                       parameter.p_cant_deci_mmnn);
    v_movi_grav10_ii_mone     := round((bcab.SUM_W_IMPO_COMI +
                                       bcab.SUM_W_IMPO_IVA),
                                       bcab.movi_mone_cant_deci);
    v_movi_grav10_ii_mmnn     := round(((bcab.SUM_W_IMPO_COMI +
                                       bcab.SUM_W_IMPO_IVA) *
                                       bcab.movi_tasa_mone),
                                       parameter.p_cant_deci_mmnn);
    v_movi_grav5_ii_mone      := 0;
    v_movi_grav5_ii_mmnn      := 0;
    v_movi_grav10_mone        := round(bcab.SUM_W_IMPO_COMI,
                                       bcab.movi_mone_cant_deci);
    v_movi_grav10_mmnn        := round((bcab.SUM_W_IMPO_COMI *
                                       bcab.movi_tasa_mone),
                                       parameter.p_cant_deci_mmnn);
    v_movi_grav5_mone         := 0;
    v_movi_grav5_mmnn         := 0;
    v_movi_iva10_mone         := round(bcab.SUM_W_IMPO_IVA,
                                       bcab.movi_mone_cant_deci);
    v_movi_iva10_mmnn         := round((bcab.SUM_W_IMPO_IVA *
                                       bcab.movi_tasa_mone),
                                       parameter.p_cant_deci_mmnn);
    v_movi_iva5_mone          := 0;
    v_movi_iva5_mmnn          := 0;
    v_movi_clpr_desc          := null;
    v_movi_empr_codi          := null;
    v_movi_obse               := bcab.movi_obse;
    v_movi_indi_liqu_tarj     := 'S';
    v_movi_tacu_comi          := round(bcab.sum_w_impo_comi,
                                       bcab.movi_mone_cant_deci);
    v_movi_tacu_iva           := round(bcab.sum_w_impo_iva,
                                       bcab.movi_mone_cant_deci);
    v_movi_tacu_rete_rent     := null; --bcab.sum_w_impo_rete_rent;
    v_movi_tacu_iva_rete_rent := null; --bcab.sum_w_impo_iva_rete_rent;
  
    pp_insert_come_movi(v_movi_codi,
                        v_movi_cuen_codi,
                        v_movi_timo_codi,
                        v_movi_clpr_codi,
                        v_movi_sucu_codi_orig,
                        v_movi_mone_codi,
                        v_movi_nume,
                        v_movi_nume_timb,
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
                        v_movi_impo_mone_ii,
                        v_movi_impo_mmnn_ii,
                        v_movi_grav10_ii_mone,
                        v_movi_grav10_ii_mmnn,
                        v_movi_grav5_ii_mone,
                        v_movi_grav5_ii_mmnn,
                        v_movi_grav10_mone,
                        v_movi_grav10_mmnn,
                        v_movi_grav5_mone,
                        v_movi_grav5_mmnn,
                        v_movi_iva10_mone,
                        v_movi_iva10_mmnn,
                        v_movi_iva5_mone,
                        v_movi_iva5_mmnn,
                        v_movi_clpr_desc,
                        v_movi_emit_reci,
                        v_movi_afec_sald,
                        v_movi_dbcr,
                        v_movi_empr_codi,
                        v_movi_obse,
                        v_movi_indi_liqu_tarj,
                        v_movi_tacu_comi,
                        v_movi_tacu_iva,
                        v_movi_tacu_rete_rent,
                        v_movi_tacu_iva_rete_rent);
  
  end;

  procedure pp_actualiza_moco is
  
    --variables para moco
    v_moco_movi_codi           number;
    v_moco_nume_item           number := 0;
    v_moco_conc_codi           number;
    v_moco_cuco_codi           number;
    v_moco_impu_codi           number;
    v_moco_impo_mmnn           number;
    v_moco_impo_mmee           number;
    v_moco_impo_mone           number;
    v_moco_impo_mone_ii        number;
    v_moco_impo_mmnn_ii        number;
    v_moco_exen_mone           number;
    v_moco_exen_mmnn           number;
    v_moco_grav10_ii_mone      number;
    v_moco_grav10_ii_mmnn      number;
    v_moco_grav5_ii_mone       number;
    v_moco_grav5_ii_mmnn       number;
    v_moco_grav10_mone         number;
    v_moco_grav10_mmnn         number;
    v_moco_grav5_mone          number;
    v_moco_grav5_mmnn          number;
    v_moco_iva10_mone          number;
    v_moco_iva10_mmnn          number;
    v_moco_iva5_mone           number;
    v_moco_iva5_mmnn           number;
    v_moco_dbcr                varchar(1);
    v_moco_conc_codi_impu      number;
    v_impu_porc                number;
    v_impu_porc_base_impo      number;
    v_impu_indi_baim_impu_incl varchar(1);
  
  begin
  
    ----actualizar moco comision
    ----actualizar moco cabecera
    v_moco_movi_codi := bcab.movi_codi;
    v_moco_conc_codi := bcab.movi_conc_codi;
    v_moco_dbcr      := bcab.movi_dbcr;
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_grav10;
  
    pp_busca_Datos_impu(v_moco_impu_codi,
                        v_moco_dbcr,
                        v_impu_porc,
                        v_impu_porc_base_impo,
                        v_impu_indi_baim_impu_incl,
                        v_moco_conc_codi_impu);
  
    v_moco_impo_mone_ii := round((bcab.sum_w_impo_comi +
                                 bcab.sum_w_impo_iva),
                                 bcab.movi_mone_cant_deci);
    v_moco_impo_mmnn_ii := round(((v_moco_impo_mone_ii) *
                                 bcab.movi_tasa_mone),
                                 parameter.p_cant_deci_mmnn);
  
    pa_devu_impo_calc(v_moco_impo_mone_ii,
                      bcab.movi_mone_cant_deci,
                      v_impu_porc,
                      v_impu_porc_base_impo,
                      v_impu_indi_baim_impu_incl,
                      v_moco_impo_mone_ii,
                      v_moco_grav10_ii_mone,
                      v_moco_grav5_ii_mone,
                      v_moco_grav10_mone,
                      v_moco_grav5_mone,
                      v_moco_iva10_mone,
                      v_moco_iva5_mone,
                      v_moco_Exen_mone);
  
    pa_devu_impo_calc(v_moco_impo_mmnn_ii,
                      0,
                      v_impu_porc,
                      v_impu_porc_base_impo,
                      v_impu_indi_baim_impu_incl,
                      v_moco_impo_mmnn_ii,
                      v_moco_grav10_ii_mmnn,
                      v_moco_grav5_ii_mmnn,
                      v_moco_grav10_mmnn,
                      v_moco_grav5_mmnn,
                      v_moco_iva10_mmnn,
                      v_moco_iva5_mmnn,
                      v_moco_Exen_mmnn);
  
    v_moco_impo_mmnn := v_moco_grav10_mmnn + v_moco_Exen_mmnn +
                        v_moco_grav5_mmnn;
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := v_moco_grav10_mone + v_moco_Exen_mone +
                        v_moco_grav5_mone;
  
    pp_insert_movi_conc_deta(v_moco_movi_codi,
                             v_moco_nume_item,
                             v_moco_conc_codi,
                             v_moco_cuco_codi,
                             v_moco_impu_codi,
                             v_moco_impo_mmnn,
                             v_moco_impo_mmee,
                             v_moco_impo_mone,
                             v_moco_impo_mone_ii,
                             v_moco_impo_mmnn_ii,
                             v_moco_exen_mone,
                             v_moco_exen_mmnn,
                             v_moco_grav10_ii_mone,
                             v_moco_grav10_ii_mmnn,
                             v_moco_grav5_ii_mone,
                             v_moco_grav5_ii_mmnn,
                             v_moco_grav10_mone,
                             v_moco_grav10_mmnn,
                             v_moco_grav5_mone,
                             v_moco_grav5_mmnn,
                             v_moco_iva10_mone,
                             v_moco_iva10_mmnn,
                             v_moco_iva5_mone,
                             v_moco_iva5_mmnn,
                             v_moco_dbcr,
                             v_moco_conc_codi_impu);
  
  end;

  procedure pp_actualiza_moimpu is
    v_moim_impu_codi      number;
    v_moim_movi_codi      number;
    v_moim_impo_mmnn      number;
    v_moim_impo_mmee      number;
    v_moim_impu_mmnn      number;
    v_moim_impu_mmee      number;
    v_moim_impo_mone      number;
    v_moim_impu_mone      number;
    v_moim_impo_mone_ii   number;
    v_moim_impo_mmnn_ii   number;
    v_moim_exen_mone      number;
    v_moim_exen_mmnn      number;
    v_moim_grav10_ii_mone number;
    v_moim_grav10_ii_mmnn number;
    v_moim_grav5_ii_mone  number;
    v_moim_grav5_ii_mmnn  number;
    v_moim_grav10_mone    number;
    v_moim_grav10_mmnn    number;
    v_moim_grav5_mone     number;
    v_moim_grav5_mmnn     number;
    v_moim_iva10_mone     number;
    v_moim_iva10_mmnn     number;
    v_moim_iva5_mone      number;
    v_moim_iva5_mmnn      number;
  
  begin
    --actualizar moimpu
    v_moim_impu_codi := parameter.p_codi_impu_grav10;
  
    v_moim_movi_codi      := bcab.movi_codi;
    v_moim_impo_mmnn      := round((bcab.sum_w_impo_comi *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_moim_impo_mmee      := 0;
    v_moim_impu_mmnn      := round((bcab.sum_w_impo_iva *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_moim_impu_mmee      := 0;
    v_moim_impo_mone      := round(bcab.sum_w_impo_comi,
                                   bcab.movi_mone_cant_deci);
    v_moim_impu_mone      := round(bcab.sum_w_impo_iva,
                                   bcab.movi_mone_cant_deci);
    v_moim_impo_mone_ii   := round((bcab.sum_w_impo_comi +
                                   bcab.sum_w_impo_iva),
                                   bcab.movi_mone_cant_deci);
    v_moim_impo_mmnn_ii   := round(((bcab.sum_w_impo_comi +
                                   bcab.sum_w_impo_iva) *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_moim_exen_mone      := 0;
    v_moim_exen_mmnn      := 0;
    v_moim_grav10_ii_mone := round((bcab.sum_w_impo_comi +
                                   bcab.sum_w_impo_iva),
                                   bcab.movi_mone_cant_deci);
    v_moim_grav10_ii_mmnn := round(((bcab.sum_w_impo_comi +
                                   bcab.sum_w_impo_iva) *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_moim_grav5_ii_mone  := 0;
    v_moim_grav5_ii_mmnn  := 0;
    v_moim_grav10_mone    := round(bcab.sum_w_impo_comi,
                                   bcab.movi_mone_cant_deci);
    v_moim_grav10_mmnn    := round((bcab.sum_w_impo_comi *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_moim_grav5_mone     := 0;
    v_moim_grav5_mmnn     := 0;
    v_moim_iva10_mone     := round(bcab.sum_w_impo_iva,
                                   bcab.movi_mone_cant_deci);
    v_moim_iva10_mmnn     := round((bcab.sum_w_impo_iva *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_moim_iva5_mone      := 0;
    v_moim_iva5_mmnn      := 0;
  
    pp_insert_come_movi_impu_deta(v_moim_impu_codi,
                                  v_moim_movi_codi,
                                  v_moim_impo_mmnn,
                                  v_moim_impo_mmee,
                                  v_moim_impu_mmnn,
                                  v_moim_impu_mmee,
                                  v_moim_impo_mone,
                                  v_moim_impu_mone,
                                  v_moim_impo_mone_ii,
                                  v_moim_impo_mmnn_ii,
                                  v_moim_exen_mone,
                                  v_moim_exen_mmnn,
                                  v_moim_grav10_ii_mone,
                                  v_moim_grav10_ii_mmnn,
                                  v_moim_grav5_ii_mone,
                                  v_moim_grav5_ii_mmnn,
                                  v_moim_grav10_mone,
                                  v_moim_grav10_mmnn,
                                  v_moim_grav5_mone,
                                  v_moim_grav5_mmnn,
                                  v_moim_iva10_mone,
                                  v_moim_iva10_mmnn,
                                  v_moim_iva5_mone,
                                  v_moim_iva5_mmnn);
  end;

  procedure pp_actualiza_tarjeta is
    v_tacu_codi      number;
    v_tacu_tapr_codi number;
    v_tacu_tane_codi number;
    v_tacu_tade_codi number;
    v_tacu_tarj_nume number;
    v_tacu_impo_mone number;
    v_tacu_impo_mmnn number;
    v_tacu_coti_mone number;
    v_tacu_clpr_codi number;
    v_tacu_fech_emis date;
    v_tacu_fech_venc date;
    v_tacu_esta      varchar2(1);
    v_mota_movi_codi number;
    v_mota_tacu_codi number;
    v_mota_esta_ante varchar2(1);
    v_mota_nume_orde number;
    v_mota_impo_mmnn number;
    v_mota_sald_mmnn number;
  
    cursor c_depo_cupo(p_movi_codi in number) is
      select mota_tacu_codi,
             mota_esta_ante,
             (nvl(mota_nume_orde, 0) + 1) mota_nume_orde,
             mota_sald_mmnn
        from come_movi_tarj_cupo
       where mota_movi_codi = p_movi_codi;
  
    cursor cDeta is
      select c001 movi_codi,
             c002 movi_nume,
             c003 movi_fech_emis,
             c004 movi_fech_oper,
             to_number(c005) impo_mone,
             to_number(c006) movi_tacu_comi,
             to_number(c007) movi_tacu_iva,
             to_number(c008) movi_tacu_rete_rent,
             to_number(c009) movi_tacu_iva_rete_rent,
             c010 s_depo,
             seq_id
        from apex_collections
       where collection_name = 'I020226';
  
  begin
  
    for i in cDeta loop
      if i.s_depo = 'S' then
        v_mota_movi_codi := bcab.movi_codi;
      
        for r in c_depo_cupo(i.movi_codi) loop
        
          if r.mota_esta_ante = 'I' then
            -- si anterior a Depositado es ingresado
            v_tacu_esta      := 'L'; -- actual 
            v_mota_esta_ante := 'D'; -- anterior a liquidado.
            v_mota_impo_mmnn := r.mota_sald_mmnn;
            v_mota_sald_mmnn := 0;
          else
            v_mota_impo_mmnn := null;
            v_mota_sald_mmnn := null;
          end if;
        
          v_mota_tacu_codi := r.mota_tacu_codi;
          v_mota_nume_orde := r.mota_nume_orde;
        
          update come_tarj_cupo
             set tacu_esta      = v_tacu_esta,
                 tacu_fech_liqu = bcab.movi_fech_emis
           where tacu_codi = v_mota_tacu_codi
             and tacu_base = parameter.p_codi_base;
        
          pp_insert_come_movi_tarj_cupo(v_mota_movi_codi,
                                        v_mota_tacu_codi,
                                        v_mota_esta_ante,
                                        v_mota_nume_orde,
                                        v_mota_impo_mmnn,
                                        v_mota_sald_mmnn);
        end loop;
      end if;
    end loop;
  
  end;

  procedure pp_busca_Datos_impu(p_impu_codi                in number,
                                p_dbcr                     in varchar2,
                                p_impu_porc                out number,
                                p_impu_porc_base_impo      out number,
                                p_impu_indi_baim_impu_incl out varchar2,
                                p_impu_conc_codi           out number) is
  
  begin
  
    select impu_porc,
           impu_porc_base_impo,
           impu_indi_baim_impu_incl,
           decode(p_dbcr, 'D', impu_conc_codi_ivdb, impu_conc_codi_ivcr)
      into p_impu_porc,
           p_impu_porc_base_impo,
           p_impu_indi_baim_impu_incl,
           p_impu_conc_codi
      from come_impu
     where impu_codi = p_impu_codi;
  
  exception
    when no_Data_found then
      pl_me('Codigo de impuesto inexistente');
    when others then
      pl_me('Problemas al cargar datos del impuesto');
    
  end;

  procedure pp_insert_come_movi(p_movi_codi               in number,
                                p_movi_cuen_codi          in number,
                                p_movi_timo_codi          in number,
                                p_movi_clpr_codi          in number,
                                p_movi_sucu_codi_orig     in number,
                                p_movi_mone_codi          in number,
                                p_movi_nume               in number,
                                p_movi_nume_timb          in number,
                                p_movi_fech_emis          in date,
                                p_movi_fech_grab          in date,
                                p_movi_user               in char,
                                p_movi_codi_padr          in number,
                                p_movi_tasa_mone          in number,
                                p_movi_tasa_mmee          in number,
                                p_movi_grav_mmnn          in number,
                                p_movi_exen_mmnn          in number,
                                p_movi_iva_mmnn           in number,
                                p_movi_grav_mmee          in number,
                                p_movi_exen_mmee          in number,
                                p_movi_iva_mmee           in number,
                                p_movi_grav_mone          in number,
                                p_movi_exen_mone          in number,
                                p_movi_iva_mone           in number,
                                p_movi_impo_mone_ii       in number,
                                p_movi_impo_mmnn_ii       in number,
                                p_movi_grav10_ii_mone     in number,
                                p_movi_grav10_ii_mmnn     in number,
                                p_movi_grav5_ii_mone      in number,
                                p_movi_grav5_ii_mmnn      in number,
                                p_movi_grav10_mone        in number,
                                p_movi_grav10_mmnn        in number,
                                p_movi_grav5_mone         in number,
                                p_movi_grav5_mmnn         in number,
                                p_movi_iva10_mone         in number,
                                p_movi_iva10_mmnn         in number,
                                p_movi_iva5_mone          in number,
                                p_movi_iva5_mmnn          in number,
                                p_movi_clpr_desc          in char,
                                p_movi_emit_reci          in char,
                                p_movi_afec_sald          in char,
                                p_movi_dbcr               in char,
                                p_movi_empr_codi          in number,
                                p_movi_obse               in varchar2,
                                p_movi_indi_liqu_tarj     in varchar2,
                                p_movi_tacu_comi          in number,
                                p_movi_tacu_iva           in number,
                                p_movi_tacu_rete_rent     in number,
                                p_movi_tacu_iva_rete_rent in number) is
  begin
  
    insert into come_movi
      (movi_codi,
       movi_cuen_codi,
       movi_timo_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
       movi_mone_codi,
       movi_nume,
       movi_nume_timb,
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
       movi_impo_mone_ii,
       movi_impo_mmnn_ii,
       movi_grav10_ii_mone,
       movi_grav10_ii_mmnn,
       movi_grav5_ii_mone,
       movi_grav5_ii_mmnn,
       movi_grav10_mone,
       movi_grav10_mmnn,
       movi_grav5_mone,
       movi_grav5_mmnn,
       movi_iva10_mone,
       movi_iva10_mmnn,
       movi_iva5_mone,
       movi_iva5_mmnn,
       movi_clpr_desc,
       movi_emit_reci,
       movi_afec_sald,
       movi_dbcr,
       movi_empr_codi,
       movi_obse,
       movi_indi_liqu_tarj,
       movi_tacu_comi,
       movi_tacu_iva,
       movi_tacu_rete_rent,
       movi_tacu_iva_rete_rent,
       movi_base)
    values
      (p_movi_codi,
       p_movi_cuen_codi,
       p_movi_timo_codi,
       p_movi_clpr_codi,
       p_movi_sucu_codi_orig,
       p_movi_mone_codi,
       p_movi_nume,
       p_movi_nume_timb,
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
       p_movi_impo_mone_ii,
       p_movi_impo_mmnn_ii,
       p_movi_grav10_ii_mone,
       p_movi_grav10_ii_mmnn,
       p_movi_grav5_ii_mone,
       p_movi_grav5_ii_mmnn,
       p_movi_grav10_mone,
       p_movi_grav10_mmnn,
       p_movi_grav5_mone,
       p_movi_grav5_mmnn,
       p_movi_iva10_mone,
       p_movi_iva10_mmnn,
       p_movi_iva5_mone,
       p_movi_iva5_mmnn,
       p_movi_clpr_desc,
       p_movi_emit_reci,
       p_movi_afec_sald,
       p_movi_dbcr,
       p_movi_empr_codi,
       p_movi_obse,
       p_movi_indi_liqu_tarj,
       p_movi_tacu_comi,
       p_movi_tacu_iva,
       p_movi_tacu_rete_rent,
       p_movi_tacu_iva_rete_rent,
       parameter.p_codi_base);
  
  end;

  procedure pp_insert_movi_conc_deta(p_moco_movi_codi      in number,
                                     p_moco_nume_item      in number,
                                     p_moco_conc_codi      in number,
                                     p_moco_cuco_codi      in number,
                                     p_moco_impu_codi      in number,
                                     p_moco_impo_mmnn      in number,
                                     p_moco_impo_mmee      in number,
                                     p_moco_impo_mone      in number,
                                     p_moco_impo_mone_ii   in number,
                                     p_moco_impo_mmnn_ii   in number,
                                     p_moco_exen_mone      in number,
                                     p_moco_exen_mmnn      in number,
                                     p_moco_grav10_ii_mone in number,
                                     p_moco_grav10_ii_mmnn in number,
                                     p_moco_grav5_ii_mone  in number,
                                     p_moco_grav5_ii_mmnn  in number,
                                     p_moco_grav10_mone    in number,
                                     p_moco_grav10_mmnn    in number,
                                     p_moco_grav5_mone     in number,
                                     p_moco_grav5_mmnn     in number,
                                     p_moco_iva10_mone     in number,
                                     p_moco_iva10_mmnn     in number,
                                     p_moco_iva5_mone      in number,
                                     p_moco_iva5_mmnn      in number,
                                     p_moco_dbcr           in varchar2,
                                     p_moco_conc_codi_impu in number) is
  
  begin
    insert into come_movi_conc_deta
      (moco_movi_codi,
       moco_nume_item,
       moco_conc_codi,
       moco_cuco_codi,
       moco_impu_codi,
       moco_impo_mmnn,
       moco_impo_mmee,
       moco_impo_mone,
       moco_impo_mone_ii,
       moco_impo_mmnn_ii,
       moco_exen_mone,
       moco_exen_mmnn,
       moco_grav10_ii_mone,
       moco_grav10_ii_mmnn,
       moco_grav5_ii_mone,
       moco_grav5_ii_mmnn,
       moco_grav10_mone,
       moco_grav10_mmnn,
       moco_grav5_mone,
       moco_grav5_mmnn,
       moco_iva10_mone,
       moco_iva10_mmnn,
       moco_iva5_mone,
       moco_iva5_mmnn,
       moco_dbcr,
       moco_conc_codi_impu,
       moco_base)
    values
      (p_moco_movi_codi,
       p_moco_nume_item,
       p_moco_conc_codi,
       p_moco_cuco_codi,
       p_moco_impu_codi,
       p_moco_impo_mmnn,
       p_moco_impo_mmee,
       p_moco_impo_mone,
       p_moco_impo_mone_ii,
       p_moco_impo_mmnn_ii,
       p_moco_exen_mone,
       p_moco_exen_mmnn,
       p_moco_grav10_ii_mone,
       p_moco_grav10_ii_mmnn,
       p_moco_grav5_ii_mone,
       p_moco_grav5_ii_mmnn,
       p_moco_grav10_mone,
       p_moco_grav10_mmnn,
       p_moco_grav5_mone,
       p_moco_grav5_mmnn,
       p_moco_iva10_mone,
       p_moco_iva10_mmnn,
       p_moco_iva5_mone,
       p_moco_iva5_mmnn,
       p_moco_dbcr,
       p_moco_conc_codi_impu,
       parameter.p_codi_base);
  
  end;

  procedure pp_insert_come_movi_impu_deta(p_moim_impu_codi      in number,
                                          p_moim_movi_codi      in number,
                                          p_moim_impo_mmnn      in number,
                                          p_moim_impo_mmee      in number,
                                          p_moim_impu_mmnn      in number,
                                          p_moim_impu_mmee      in number,
                                          p_moim_impo_mone      in number,
                                          p_moim_impu_mone      in number,
                                          p_moim_impo_mone_ii   in number,
                                          p_moim_impo_mmnn_ii   in number,
                                          p_moim_exen_mone      in number,
                                          p_moim_exen_mmnn      in number,
                                          p_moim_grav10_ii_mone in number,
                                          p_moim_grav10_ii_mmnn in number,
                                          p_moim_grav5_ii_mone  in number,
                                          p_moim_grav5_ii_mmnn  in number,
                                          p_moim_grav10_mone    in number,
                                          p_moim_grav10_mmnn    in number,
                                          p_moim_grav5_mone     in number,
                                          p_moim_grav5_mmnn     in number,
                                          p_moim_iva10_mone     in number,
                                          p_moim_iva10_mmnn     in number,
                                          p_moim_iva5_mone      in number,
                                          p_moim_iva5_mmnn      in number) is
  begin
    insert into come_movi_impu_deta
      (moim_impu_codi,
       moim_movi_codi,
       moim_impo_mmnn,
       moim_impo_mmee,
       moim_impu_mmnn,
       moim_impu_mmee,
       moim_impo_mone,
       moim_impu_mone,
       moim_impo_mone_ii,
       moim_impo_mmnn_ii,
       moim_exen_mone,
       moim_exen_mmnn,
       moim_grav10_ii_mone,
       moim_grav10_ii_mmnn,
       moim_grav5_ii_mone,
       moim_grav5_ii_mmnn,
       moim_grav10_mone,
       moim_grav10_mmnn,
       moim_grav5_mone,
       moim_grav5_mmnn,
       moim_iva10_mone,
       moim_iva10_mmnn,
       moim_iva5_mone,
       moim_iva5_mmnn,
       moim_base)
    values
      (p_moim_impu_codi,
       p_moim_movi_codi,
       p_moim_impo_mmnn,
       p_moim_impo_mmee,
       p_moim_impu_mmnn,
       p_moim_impu_mmee,
       p_moim_impo_mone,
       p_moim_impu_mone,
       p_moim_impo_mone_ii,
       p_moim_impo_mmnn_ii,
       p_moim_exen_mone,
       p_moim_exen_mmnn,
       p_moim_grav10_ii_mone,
       p_moim_grav10_ii_mmnn,
       p_moim_grav5_ii_mone,
       p_moim_grav5_ii_mmnn,
       p_moim_grav10_mone,
       p_moim_grav10_mmnn,
       p_moim_grav5_mone,
       p_moim_grav5_mmnn,
       p_moim_iva10_mone,
       p_moim_iva10_mmnn,
       p_moim_iva5_mone,
       p_moim_iva5_mmnn,
       parameter.p_codi_base);
  
  end;

  procedure pp_insert_come_movi_tarj_cupo(p_mota_movi_codi in number,
                                          p_mota_tacu_codi in number,
                                          p_mota_esta_ante in varchar2,
                                          p_mota_nume_orde in number,
                                          p_mota_impo_mmnn in number,
                                          p_mota_sald_mmnn in number) is
  begin
    insert into come_movi_tarj_cupo
      (mota_movi_codi,
       mota_tacu_codi,
       mota_esta_ante,
       mota_nume_orde,
       mota_impo_mmnn,
       mota_sald_mmnn,
       mota_base)
    values
      (p_mota_movi_codi,
       p_mota_tacu_codi,
       p_mota_esta_ante,
       p_mota_nume_orde,
       p_mota_impo_mmnn,
       p_mota_sald_mmnn,
       parameter.p_codi_base);
  exception
    when others then
      pl_me(sqlerrm);
  end;

  procedure pl_mostrar_error(i_mensaje varchar2) is
    v_mensaje varchar2(3000);
  begin
    v_mensaje := i_mensaje;
    if instr(v_mensaje, '10:', -1) > 0 then
      v_mensaje := substr(v_mensaje, instr(v_mensaje, '10:', -1) + 4);
    end if;
    raise_application_error(-20010,
                            dbms_utility.format_error_backtrace || ' ' ||
                            v_mensaje);
  end pl_mostrar_error;

  procedure pl_mostrar_error_plsql is
  
  begin
  
    raise_application_error(-20010, sqlerrm);
  
  end pl_mostrar_error_plsql;

  procedure pp_set_variable is
  begin
  
    bcab.CLPR_CODI_ALTE           := v('P85_CLPR_CODI_ALTE');
    bcab.CLPR_CODI                := v('P85_CLPR_CODI_ALTE');
    bcab.CLPR_INDI_CLIE_PROV      := v('P85_CLPR_INDI_CLIE_PROV');
    bcab.CLPR_PROV_RETENER        := v('P85_CLPR_PROV_RETENER');
    bcab.MOVI_CONC_CODI           := v('P85_MOVI_CONC_CODI');
    bcab.MOVI_DBCR                := v('P85_MOVI_DBCR');
    bcab.MOVI_FECH_EMIS           := v('P85_MOVI_FECH_EMIS');
    bcab.MOVI_FECH_EMIS_DESD      := v('P85_MOVI_FECH_EMIS_DESD');
    bcab.MOVI_FECH_EMIS_HAST      := v('P85_MOVI_FECH_EMIS_HAST');
    bcab.MOVI_FECH_OPER           := v('P85_MOVI_FECH_OPER');
    bcab.MOVI_MONE_CODI           := v('P85_MOVI_MONE_CODI');
    bcab.MOVI_NUME                := v('P85_MOVI_NUME');
    bcab.MOVI_NUME_TIMB           := v('P85_MOVI_NUME_TIMB');
    bcab.MOVI_OBSE                := v('P85_MOVI_OBSE');
    bcab.MOVI_SUCU_CODI_ORIG      := v('P85_MOVI_SUCU_CODI_ORIG');
    bcab.MOVI_TASA_MONE           := v('P85_MOVI_TASA_MONE');
    bcab.MOVI_TIMO_CODI           := v('P85_MOVI_TIMO_CODI');
    bcab.movi_mone_cant_deci      := v('P85_MONE_CANT_DECI');
    bcab.SUM_IMPO_DETO            := v('P85_SUM_IMPO_DETO');
    bcab.SUM_IMPO_MONE_NETO       := v('P85_SUM_IMPO_MONE_NETO');
    bcab.SUM_S_IMPO_COMI          := v('P85_SUM_S_IMPO_COMI');
    bcab.SUM_S_IMPO_DETO          := v('P85_SUM_S_IMPO_DETO');
    bcab.SUM_S_IMPO_IVA           := v('P85_SUM_S_IMPO_IVA');
    bcab.SUM_S_IMPO_IVA_RETE_RENT := v('P85_SUM_S_IMPO_IVA_RETE_RENT');
    bcab.SUM_S_IMPO_MONE          := v('P85_SUM_S_IMPO_MONE');
    bcab.SUM_S_IMPO_MONE_NETO     := v('P85_SUM_S_IMPO_MONE_NETO');
    bcab.SUM_S_IMPO_RETE_RENT     := v('P85_SUM_S_IMPO_RETE_RENT');
    bcab.SUM_W_IMPO_COMI          := v('P85_SUM_W_IMPO_COMI');
    bcab.SUM_W_IMPO_IVA           := v('P85_SUM_W_IMPO_IVA');
    bcab.SUM_W_IMPO_IVA_RETE_RENT := v('P85_SUM_W_IMPO_IVA_RETE_RENT');
    bcab.SUM_W_IMPO_MONE          := v('P85_SUM_W_IMPO_MONE');
    bcab.SUM_W_IMPO_RETE_RENT     := v('P85_SUM_W_IMPO_RETE_RENT');
    bcab.FECH_VENC_TIMB           := v('P85_FECH_VENC_TIMB');
    bcab.S_NRO_1                  := v('P85_S_NRO_1');
    bcab.S_NRO_2                  := v('P85_S_NRO_2');
    bcab.S_NRO_3                  := v('P85_S_NRO_3');
    bcab.TAPR_CODI                := v('P85_TAPR_CODI');
    bcab.TAPR_PORC_COMI           := v('P85_TAPR_PORC_COMI');
    bcab.TAPR_PORC_IVA            := v('P85_TAPR_PORC_IVA');
    bcab.TAPR_PORC_RETE_IVA       := v('P85_TAPR_PORC_RETE_IVA');
    bcab.TAPR_PORC_RETE_RENT      := v('P85_TAPR_PORC_RETE_RENT');
    bcab.TICO_CODI                := v('P85_TICO_CODI');
    bcab.TICO_FECH_REIN           := v('P85_TICO_FECH_REIN');
    bcab.TICO_INDI_HABI_TIMB      := v('P85_TICO_INDI_HABI_TIMB');
    bcab.TICO_INDI_TIMB           := v('P85_TICO_INDI_TIMB');
    bcab.TICO_INDI_TIMB_AUTO      := v('P85_TICO_INDI_TIMB_AUTO');
    bcab.TICO_INDI_VALI_TIMB      := v('P85_TICO_INDI_VALI_TIMB');
  
  end;

  procedure pp_muestra_clpr(p_clpr_codi_alte      in number,
                            p_clpr_desc           out varchar2,
                            p_clpr_codi           out varchar2,
                            p_clpr_tele           out varchar2,
                            p_clpr_dire           out varchar2,
                            p_clpr_ruc            out varchar2,
                            p_clpr_prov_retener   out varchar2,
                            p_tapr_codi           in out number,
                            p_clpr_indi_clie_prov out varchar2) is
  begin
    select clpr_desc,
           clpr_codi,
           rtrim(ltrim(substr(clpr_tele, 1, 50))) Tele,
           rtrim(ltrim(substr(clpr_dire, 1, 100))) dire,
           rtrim(ltrim(substr(clpr_ruc, 1, 20))) Ruc,
           nvl(clpr_prov_retener, 'NO'),
           max(tapr_codi) TARJ_CODI,
           clpr_indi_clie_prov
      into p_clpr_desc,
           p_clpr_codi,
           p_clpr_tele,
           p_clpr_dire,
           p_clpr_ruc,
           p_clpr_prov_retener,
           p_tapr_codi,
           p_clpr_indi_clie_prov
      from come_clie_prov, come_tarj_proc
     where clpr_codi = tapr_clpr_codi
       and clpr_codi = p_clpr_codi_alte
       and (p_tapr_codi is null or tapr_codi = p_tapr_codi)
     group by clpr_desc,
              clpr_codi,
              rtrim(ltrim(substr(clpr_tele, 1, 50))),
              rtrim(ltrim(substr(clpr_dire, 1, 100))),
              rtrim(ltrim(substr(clpr_ruc, 1, 20))),
              nvl(clpr_prov_retener, 'NO'),
              clpr_indi_clie_prov;
  
  exception
    when no_data_found then
      p_clpr_desc := null;
      pl_me('Proveedor inexistente o no esta Relacionado a una Procesadora.');
    when others then
      pl_me(sqlerrm);
  end;

  procedure pp_muestra_come_tarj_proc(p_tapr_codi           in number,
                                      p_tapr_desc           out varchar2,
                                      p_tapr_porc_comi      out number,
                                      p_tapr_porc_iva       out number,
                                      p_tapr_porc_rete_iva  out number,
                                      p_tapr_porc_rete_rent out number) is
  begin
    select tapr_desc,
           tapr_porc_comi,
           tapr_porc_iva,
           tapr_porc_rete_iva,
           tapr_porc_rete_rent
      into p_tapr_desc,
           p_tapr_porc_comi,
           p_tapr_porc_iva,
           p_tapr_porc_rete_iva,
           p_tapr_porc_rete_rent
      from come_tarj_proc
     where tapr_codi = p_tapr_codi;
  exception
    when no_data_found then
      p_tapr_desc           := null;
      p_tapr_porc_comi      := null;
      p_tapr_porc_iva       := null;
      p_tapr_porc_rete_iva  := null;
      p_tapr_porc_rete_rent := null;
      pl_mostrar_error('Procesadora inexistente.');
    when others then
      pl_mostrar_error_plsql;
  end;

  procedure pp_muestra_tipo_movi(p_timo_codi      in number,
                                 p_timo_afec_sald out char,
                                 p_timo_emit_reci out char,
                                 p_timo_dbcr      out char) is
  begin
  
    select timo_afec_sald, timo_emit_reci, timo_dbcr
      into p_timo_afec_sald, p_timo_emit_reci, p_timo_dbcr
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
  exception
    when no_data_found then
      p_timo_afec_sald := null;
      p_timo_emit_reci := null;
      p_timo_dbcr      := null;
      pl_mostrar_error('Tipo de Movimiento inexistente');
    when too_many_rows then
      pl_mostrar_error('Tipo de Movimiento duplicado');
  end;

  procedure pp_validar_timbrado(p_tico_codi      in number,
                                p_esta           in number,
                                p_punt_expe      in number,
                                p_clpr_codi      in number,
                                p_fech_movi      in date,
                                p_timb           out varchar2,
                                p_fech_venc      out date,
                                p_tico_indi_timb in varchar2) is
  
    cursor c_timb is
      select cptc_nume_timb, cptc_fech_venc
        from come_clpr_tipo_comp
       where cptc_clpr_codi = p_clpr_codi --proveedor, cliente
         and cptc_tico_codi = p_tico_codi --tipo de comprobante
         and cptc_esta = p_esta --establecimiento 
         and cptc_punt_expe = p_punt_expe --punto de expedicion
         and cptc_fech_venc >= p_fech_movi
       order by cptc_fech_venc;
  
    cursor c_timb_2 is
      select deta_nume_timb, deta_fech_venc
        from come_tipo_comp_deta
       where deta_tico_codi = p_tico_codi --tipo de comprobante
         and deta_esta = p_esta --establecimiento 
         and deta_punt_expe = p_punt_expe --punto de expedicion
         and deta_fech_venc >= p_fech_movi
       order by deta_fech_venc;
  
    v_indi_entro varchar2(1) := upper('n');
    v_indi_espo  varchar2(1) := upper('n');
  
  begin
  
    if nvl(bcab.tico_indi_timb_auto, 'N') = 'S' then
    
      if nvl(p_tico_indi_timb, 'C') = 'P' then
        if bcab.clpr_indi_clie_prov = upper('p') and
           nvl(v_indi_espo, 'N') = 'N' then
          for x in c_timb loop
            v_indi_entro := upper('s');
            if bcab.movi_nume_timb is not null then
              p_timb      := bcab.movi_nume_timb;
              p_fech_venc := bcab.fech_venc_timb;
            else
              p_timb      := x.cptc_nume_timb;
              p_fech_venc := x.cptc_fech_venc;
            end if;
            exit;
          end loop;
        end if;
      else
        ---si es por tipo de comprobante
        for y in c_timb_2 loop
          v_indi_entro := upper('s');
          if bcab.movi_nume_timb is not null then
            p_timb      := bcab.movi_nume_timb;
            p_fech_venc := bcab.fech_venc_timb;
          else
            p_timb      := y.deta_nume_timb;
            p_fech_venc := y.deta_fech_venc;
          end if;
          exit;
        end loop;
      end if;
      if v_indi_entro = upper('n') and
         nvl(upper(bcab.tico_indi_vali_timb), 'N') = 'S' then
        pl_me('No existe registro de timbrado cargado para este proveedor, o el timbrado cargado se encuentra vencido!!!');
      end if;
    end if;
  
  end;

  procedure pp_valida_fech(p_fech in date) is
  begin
    if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
    
      pl_mostrar_error('La fecha del movimiento debe estar comprendida entre..' ||
                       to_char(parameter.p_fech_inic, 'dd-mm-yyyy') ||
                       ' y ' ||
                       to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
    end if;
  
  end;

  procedure pp_valida_importes is
  begin
    if nvl(bcab.sum_w_impo_mone, 0) = 0 then
      pl_mostrar_error('Debe seleccionar por lo menos un deposito.');
    end if;
  
  end;

/*********************** inicio **********************/
begin
  pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);

  I020226.pp_set_variable;

end I020226;
