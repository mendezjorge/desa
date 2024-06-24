
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020225" is

  v_movi_emit_reci char(1);
  v_movi_afec_sald char(1);
  v_movi_dbcr      char(1);
  p_fech_inic      date;
  p_fech_fini      date;

  type t_parameter is record(
    
    p_codi_timo_depo_tarj number := to_number(fa_busc_para('p_codi_timo_depo_tarj')),
    p_cant_deci_mmnn      number := to_number(fa_busc_para('p_cant_deci_mmnn')),
    p_codi_mone_mmnn      number := to_number(fa_busc_para('p_codi_mone_mmnn')),
    p_codi_conc           number := to_number(fa_busc_para('p_codi_conc_depo_tarj')),
    p_codi_impu_exen      number := to_number(fa_busc_para('p_codi_impu_exen')),
    p_codi_base           number := 1,
    p_timo_tica_codi      number);

  parameter t_parameter;

  type t_cabe is record(
    DEFI_TACU_IMPO_COMI           number,
    DEFI_TACU_IMPO_IVA            number,
    DEFI_TACU_IMPO_IVA_RETE_RENT  number,
    DEFI_TACU_IMPO_RETE_RENT      number,
    INDI_TARJ_DEBI                varchar2(50),
    MONE_CANT_DECI                number,
    MOVI_BANC_CODI                number,
    movi_codi                     number,
    movi_dbcr                     varchar2(50),
    MOVI_CUEN_CODI                number,
    MOVI_CUEN_DESC                varchar2(500),
    movi_mone_cant_deci           number,
    MOVI_CUEN_NUME                number,
    MOVI_FECH_EMIS                date,
    MOVI_FECH_OPER                date,
    MOVI_MONE_CODI                number,
    MOVI_NUME                     number,
    MOVI_OBSE                     varchar2(500),
    MOVI_SUCU_CODI_ORIG           number,
    MOVI_TASA_MONE                number,
    SUM_IMPO_DETO                 number(20, 4),
    SUM_S_IMPO_DETO               number(20, 4),
    SUM_S_TACU_IMPO_COMI          number(20, 4),
    SUM_S_TACU_IMPO_IVA           number(20, 4),
    SUM_S_TACU_IMPO_IVA_RETE_RENT number(20, 4),
    SUM_S_TACU_IMPO_MONE          number(20, 4),
    SUM_S_TACU_IMPO_MONE_NETO     number(20, 4),
    SUM_S_TACU_IMPO_RETE_RENT     number(20, 4),
    SUM_TACU_IMPO_MONE_NETO       number(20, 4),
    SUM_W_TACU_IMPO_MONE          number(20, 4),
    TACU_FECH_VENC_DESD           date,
    TACU_FECH_VENC_HAST           date,
    TADE_CODI                     number,
    TAPR_CODI                     number,
    TAPR_PORC_COMI                number,
    TAPR_PORC_IVA                 number,
    TAPR_PORC_RETE_IVA            number,
    TAPR_PORC_RETE_RENT           number);

  bcab t_cabe;

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
    bcab.DEFI_TACU_IMPO_COMI           := replace(v('P86_DEFI_TACU_IMPO_COMI'),
                                                  '.',
                                                  '');
    bcab.DEFI_TACU_IMPO_IVA            := replace(v('P86_DEFI_TACU_IMPO_IVA'),
                                                  '.',
                                                  '');
    bcab.DEFI_TACU_IMPO_IVA_RETE_RENT  := replace(v('P86_DEFI_TACU_IMPO_IVA_RETE'),
                                                  '.',
                                                  '');
    bcab.DEFI_TACU_IMPO_RETE_RENT      := replace(v('P86_DEFI_TACU_IMPO_RETE_RENT'),
                                                  '.',
                                                  '');
    bcab.INDI_TARJ_DEBI                := v('P86_INDI_TARJ_DEBI');
    bcab.MONE_CANT_DECI                := v('P86_MONE_CANT_DECI');
    bcab.MOVI_BANC_CODI                := v('P86_MOVI_BANC_CODI');
    bcab.MOVI_CUEN_CODI                := v('P86_MOVI_CUEN_CODI');
    bcab.MOVI_CUEN_NUME                := v('P86_MOVI_CUEN_NUME');
    bcab.MOVI_FECH_EMIS                := v('P86_MOVI_FECH_EMIS');
    bcab.MOVI_FECH_OPER                := v('P86_MOVI_FECH_OPER');
    bcab.MOVI_MONE_CODI                := v('P86_MOVI_MONE_CODI');
    bcab.MOVI_NUME                     := v('P86_MOVI_NUME');
    bcab.MOVI_OBSE                     := v('P86_MOVI_OBSE');
    bcab.MOVI_SUCU_CODI_ORIG           := v('P86_MOVI_SUCU_CODI_ORIG');
    bcab.MOVI_TASA_MONE                := v('P86_MOVI_TASA_MONE');
    bcab.SUM_IMPO_DETO                 := replace(v('P86_SUM_IMPO_DETO'),
                                                  '.',
                                                  '');
    bcab.SUM_S_IMPO_DETO               := replace(v('P86_SUM_S_IMPO_DETO'),
                                                  '.',
                                                  '');
    bcab.SUM_S_TACU_IMPO_COMI          := replace(v('P86_SUM_S_TACU_IMPO_COMI'),
                                                  '.',
                                                  '');
    bcab.SUM_S_TACU_IMPO_IVA           := replace(v('P86_SUM_S_TACU_IMPO_IVA'),
                                                  '.',
                                                  '');
    bcab.SUM_S_TACU_IMPO_IVA_RETE_RENT := replace(v('P86_SUM_S_TACU_IMPO_IVA_RETE'),
                                                  '.',
                                                  '');
    bcab.SUM_S_TACU_IMPO_MONE          := replace(v('P86_SUM_S_TACU_IMPO_MONE'),
                                                  '.',
                                                  '');
    bcab.SUM_S_TACU_IMPO_MONE_NETO     := replace(v('P86_SUM_S_TACU_IMPO_MONE_NETO'),
                                                  '.',
                                                  '');
    bcab.SUM_S_TACU_IMPO_RETE_RENT     := replace(v('P86_SUM_S_TACU_IMPO_RETE_RENT'),
                                                  '.',
                                                  '');
    bcab.SUM_TACU_IMPO_MONE_NETO       := replace(v('P86_SUM_TACU_IMPO_MONE_NETO'),
                                                  '.',
                                                  '');
    bcab.SUM_W_TACU_IMPO_MONE          := replace(v('P86_SUM_W_TACU_IMPO_MONE'),
                                                  '.',
                                                  '');
    bcab.TACU_FECH_VENC_DESD           := v('P86_TACU_FECH_VENC_DESD');
    bcab.TACU_FECH_VENC_HAST           := v('P86_TACU_FECH_VENC_HAST');
    bcab.TADE_CODI                     := v('P86_TADE_CODI');
    bcab.TAPR_CODI                     := replace(v('P86_TAPR_CODI'),
                                                  '.',
                                                  '');
    bcab.TAPR_PORC_COMI                := replace(v('P86_TAPR_PORC_COMI'),
                                                  '.',
                                                  '');
    bcab.TAPR_PORC_IVA                 := replace(v('P86_TAPR_PORC_IVA'),
                                                  '.',
                                                  '');
    bcab.TAPR_PORC_RETE_IVA            := replace(v('P86_TAPR_PORC_RETE_IVA'),
                                                  '.',
                                                  '');
    bcab.TAPR_PORC_RETE_RENT           := replace(v('P86_TAPR_PORC_RETE_RENT'),
                                                  '.',
                                                  '');
  exception
    when others then
      raise_application_error(-20010,
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' ' ||
                              v('P86_DEFI_TACU_IMPO_COMI') || ' ' ||
                              sqlerrm);
  end;

  /******************** ACTUALIZAR REGISTRO ******************************/
  procedure pp_actualizar_registros is
  begin
  
    if nvl(bcab.sum_w_tacu_impo_mone, 0) = 0 then
      pl_mostrar_error('Debe seleccionar por lo menos un cupon.');
    end if;
  
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
                                sqlerrm || ' ' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                'pp_actualiza_moco');
    end;
  
    begin
      pp_actualiza_moimpo;
    exception
      when others then
        raise_application_error(-20010,
                                sqlerrm || ' ' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                'pp_actualiza_moimpo');
    end;
  
    begin
      pp_actualiza_moimpu;
    exception
      when others then
        raise_application_error(-20010,
                                sqlerrm || ' ' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                'pp_actualiza_moimpu');
    end;
  
    begin
      pp_actualiza_tarjeta;
    exception
      when others then
        raise_application_error(-20010,
                                sqlerrm || ' ' ||
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
    v_movi_fech_emis          date;
    v_movi_fech_oper          date;
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
    v_movi_clpr_desc          char(80);
    v_movi_emit_reci          char(1);
    v_movi_afec_sald          char(1);
    v_movi_dbcr               char(1);
    v_movi_empr_codi          number;
    v_movi_obse               varchar2(2000);
    v_movi_tacu_comi          number;
    v_movi_tacu_iva           number;
    v_movi_tacu_rete_rent     number;
    v_movi_tacu_iva_rete_rent number;
  
  begin
  
    --insertar la cabecera del deposito bancario.................................
    pp_muestra_tipo_movi(parameter.p_codi_timo_depo_tarj,
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr);
  
    v_movi_codi               := fa_sec_come_movi;
    bcab.movi_codi            := v_movi_codi;
    v_movi_timo_codi          := parameter.p_codi_timo_depo_tarj;
    v_movi_clpr_codi          := null;
    v_movi_cuen_codi          := bcab.movi_cuen_codi;
    bcab.movi_dbcr            := v_movi_dbcr;
    v_movi_sucu_codi_orig     := bcab.movi_sucu_codi_orig;
    v_movi_mone_codi          := bcab.movi_mone_codi;
    v_movi_nume               := bcab.movi_nume;
    v_movi_fech_emis          := bcab.movi_fech_emis;
    v_movi_fech_oper          := bcab.movi_fech_emis;
    v_movi_fech_grab          := sysdate; ---to_date(to_char(sysdate, 'dd-mm-yyyy'), 'dd-mm-yyyy');
    v_movi_user               := gen_user;
    v_movi_codi_padr          := null;
    v_movi_tasa_mone          := bcab.movi_tasa_mone;
    v_movi_tasa_mmee          := 0;
    v_movi_grav_mmnn          := 0;
    v_movi_exen_mmnn          := round((bcab.SUM_TACU_IMPO_MONE_NETO *
                                       bcab.movi_tasa_mone),
                                       parameter.p_cant_deci_mmnn);
    v_movi_iva_mmnn           := 0;
    v_movi_grav_mmee          := 0;
    v_movi_exen_mmee          := 0;
    v_movi_iva_mmee           := 0;
    v_movi_grav_mone          := 0;
    v_movi_exen_mone          := bcab.SUM_TACU_IMPO_MONE_NETO;
    v_movi_iva_mone           := 0;
    v_movi_clpr_desc          := null;
    v_movi_empr_codi          := null;
    v_movi_obse               := bcab.movi_obse;
    v_movi_tacu_comi          := bcab.defi_tacu_impo_comi;
    v_movi_tacu_iva           := bcab.defi_tacu_impo_iva;
    v_movi_tacu_rete_rent     := bcab.defi_tacu_impo_rete_rent;
    v_movi_tacu_iva_rete_rent := bcab.defi_tacu_impo_iva_rete_rent;
  
    pp_insert_come_movi(v_movi_codi,
                        v_movi_cuen_codi,
                        v_movi_timo_codi,
                        v_movi_clpr_codi,
                        v_movi_sucu_codi_orig,
                        v_movi_mone_codi,
                        v_movi_nume,
                        v_movi_fech_emis,
                        v_movi_fech_oper,
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
                        v_movi_clpr_desc,
                        v_movi_emit_reci,
                        v_movi_afec_sald,
                        v_movi_dbcr,
                        v_movi_empr_codi,
                        v_movi_obse,
                        v_movi_tacu_comi,
                        v_movi_tacu_iva,
                        v_movi_tacu_rete_rent,
                        v_movi_tacu_iva_rete_rent);
  
  end;

  procedure pp_actualiza_moco is
  
    --variables para moco
    v_moco_movi_codi number;
    v_moco_nume_item number := 0;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      char(1);
  
  begin
  
    ----actualizar moco.... 
    v_moco_movi_codi := bcab.movi_codi;
    v_moco_conc_codi := parameter.p_codi_conc;
    v_moco_dbcr      := 'D';
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_exen;
    v_moco_impo_mmnn := round((bcab.SUM_TACU_IMPO_MONE_NETO *
                              bcab.movi_tasa_mone),
                              parameter.p_cant_deci_mmnn);
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := bcab.SUM_TACU_IMPO_MONE_NETO;
  
    pp_insert_movi_conc_deta(v_moco_movi_codi,
                             v_moco_nume_item,
                             v_moco_conc_codi,
                             v_moco_cuco_codi,
                             v_moco_impu_codi,
                             v_moco_impo_mmnn,
                             v_moco_impo_mmee,
                             v_moco_impo_mone,
                             v_moco_dbcr);
  end;

  --actualizar la tabla moimpo , efectivo, cheques dif, cheques dia, y vuelto (para el caso de las cobranzas) 
  procedure pp_actualiza_moimpo is
  
    v_moim_movi_codi      number;
    v_moim_nume_item      number := 0;
    v_moim_tipo           char(20);
    v_moim_cuen_codi      number;
    v_moim_dbcr           char(1);
    v_moim_afec_caja      char(1);
    v_moim_fech           date;
    v_moim_impo_mone      number;
    v_moim_impo_mmnn      number;
    v_MOIM_TARJ_CUPO_CODI number;
  
    cursor cDeta is
      select to_number(taax_c001) tacu_codi,
             to_number(taax_c008) v_tacu_impo_mone
        from come_tabl_auxi
       where taax_user = gen_user
         and taax_sess = v('APP_SESSION')
         and taax_c011 = 'S';
  
  begin
  
    for i in cDeta loop
      v_moim_movi_codi      := bcab.movi_codi;
      v_moim_nume_item      := v_moim_nume_item + 1;
      v_moim_tipo           := 'Dep. de Tarj.';
      v_moim_cuen_codi      := bcab.movi_cuen_codi;
      v_moim_dbcr           := bcab.movi_dbcr;
      v_moim_afec_caja      := 'S';
      v_moim_fech           := bcab.movi_fech_emis;
      v_moim_tarj_cupo_codi := i.tacu_codi;
      v_moim_impo_mone      := 0;
      v_moim_impo_mmnn      := 0;
    
      v_moim_impo_mone := bcab.sum_tacu_impo_mone_neto;
    
      v_moim_impo_mmnn := round((v_moim_impo_mone * bcab.movi_tasa_mone),
                                parameter.p_cant_deci_mmnn);
      v_moim_impo_mone := round(v_moim_impo_mone, bcab.MONE_CANT_DECI);
    
      pp_insert_come_movi_impo_deta(v_moim_movi_codi,
                                    v_moim_nume_item,
                                    v_moim_tipo,
                                    v_moim_cuen_codi,
                                    v_moim_dbcr,
                                    v_moim_afec_caja,
                                    v_moim_fech,
                                    v_moim_impo_mone,
                                    v_moim_impo_mmnn,
                                    v_moim_tarj_cupo_codi);
    end loop;
  
  end;

  procedure pp_actualiza_moimpu is
  begin
    --actualizar moim...
    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  bcab.movi_codi,
                                  round((bcab.sum_tacu_impo_mone_neto *
                                        bcab.movi_tasa_mone),
                                        parameter.p_cant_deci_mmnn),
                                  0,
                                  0,
                                  0,
                                  bcab.sum_tacu_impo_mone_neto,
                                  0);
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
    v_maxi_impo      number;
    v_maxi_codi      number;
    v_maxi_orde      number;
    v_impo_defi      number;
    v_impo_calc      number;
    v_impo_dife      number;
  
    cursor cDeta is
      select taax_c001 tacu_codi,
             taax_c002 tacu_tapr_codi,
             taax_c003 tapr_desc,
             taax_c004 tacu_tade_codi,
             taax_c005 tacu_tarj_nume,
             taax_c006 tacu_fech_emis,
             taax_c007 tacu_fech_venc,
             round(to_number(taax_c008), bcab.MONE_CANT_DECI) tacu_impo_mone,
             round(to_number(taax_c009), bcab.MONE_CANT_DECI) tacu_impo_mmnn,
             taax_c010 tacu_clpr_codi,
             taax_c011 s_depo,
             taax_seq seq_id
        from come_tabl_auxi
       where taax_user = gen_user
         and taax_sess = v('APP_SESSSION');
  
  begin
    v_maxi_impo := -9999999;
    for i in cDeta loop
      if i.s_depo = 'S' then
        v_tacu_codi := i.tacu_codi;
        v_tacu_esta := 'D';
      
        update come_tarj_cupo
           set tacu_esta      = v_tacu_esta,
               tacu_fech_depo = bcab.movi_fech_emis
         where tacu_codi = v_tacu_codi;
      
        select max(nvl(mota_nume_orde, 0)) + 1
          into v_mota_nume_orde
          from come_movi_tarj_cupo
         where mota_tacu_codi = v_tacu_codi;
      
        v_mota_movi_codi := bcab.movi_codi;
        v_mota_tacu_codi := v_tacu_codi;
        v_mota_esta_ante := 'I';
        v_mota_impo_mmnn := nvl(i.tacu_impo_mone, 0) -
                            (nvl(bcab.DEFI_TACU_IMPO_COMI, 0) +
                             nvl(bcab.DEFI_TACU_IMPO_IVA, 0) +
                             nvl(bcab.DEFI_TACU_IMPO_IVA_RETE_RENT, 0) +
                             nvl(bcab.DEFI_TACU_IMPO_RETE_RENT, 0));
        v_mota_sald_mmnn := nvl(i.tacu_impo_mone, 0) -
                            nvl(v_mota_impo_mmnn, 0);
      
        if v_maxi_impo < v_mota_impo_mmnn then
          v_maxi_codi := v_mota_tacu_codi;
          v_maxi_orde := v_mota_nume_orde;
          v_maxi_impo := v_mota_impo_mmnn;
        end if;
      
        pp_insert_come_movi_tarj_cupo(v_mota_movi_codi,
                                      v_mota_tacu_codi,
                                      v_mota_esta_ante,
                                      v_mota_nume_orde,
                                      v_mota_impo_mmnn,
                                      v_mota_sald_mmnn);
      end if;
    end loop;
  
    v_impo_defi := nvl(bcab.sum_tacu_impo_mone_neto, 0);
    v_impo_calc := nvl(bcab.SUM_W_TACU_IMPO_MONE, 0) -
                   (nvl(bcab.defi_tacu_impo_comi, 0) +
                    nvl(bcab.defi_tacu_impo_iva, 0) +
                    nvl(bcab.defi_tacu_impo_rete_rent, 0) +
                    nvl(bcab.defi_tacu_impo_iva_rete_rent, 0));
  
    v_impo_dife := v_impo_defi - v_impo_calc;
  
    if v_impo_dife <> 0 then
      update come_movi_tarj_cupo
         set mota_impo_mmnn = mota_impo_mmnn + v_impo_dife,
             mota_sald_mmnn = mota_sald_mmnn - v_impo_dife
       where mota_tacu_codi = v_maxi_codi
         and mota_nume_orde = v_maxi_orde;
    end if;
  end;

  procedure pp_busca_tasa_mone(p_mone_codi in number,
                               p_mone_coti out number) is
  begin
    if parameter.p_codi_mone_mmnn = bcab.movi_mone_codi then
      p_mone_coti := 1;
    else
      select coti_tasa
        into p_mone_coti
        from come_coti
       where coti_mone = p_mone_codi
         and coti_fech = bcab.movi_fech_emis
         and coti_tica_codi = parameter.p_timo_tica_codi;
    end if;
  
  exception
    when no_data_found then
      p_mone_coti := null;
      pl_mostrar_error('Cotizaciion Inexistente para la fecha del documento');
    when others then
      pl_mostrar_error_plsql;
    
  end;

  procedure pp_insert_come_movi(p_movi_codi               in number,
                                p_movi_cuen_codi          in number,
                                p_movi_timo_codi          in number,
                                p_movi_clpr_codi          in number,
                                p_movi_sucu_codi_orig     in number,
                                p_movi_mone_codi          in number,
                                p_movi_nume               in number,
                                p_movi_fech_emis          in date,
                                p_movi_fech_oper          in date,
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
                                p_movi_clpr_desc          in char,
                                p_movi_emit_reci          in char,
                                p_movi_afec_sald          in char,
                                p_movi_dbcr               in char,
                                p_movi_empr_codi          in number,
                                p_movi_obse               in varchar2,
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
       movi_fech_emis,
       movi_fech_oper,
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
       movi_clpr_desc,
       movi_emit_reci,
       movi_afec_sald,
       movi_dbcr,
       movi_empr_codi,
       movi_obse,
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
       p_movi_fech_emis,
       p_movi_fech_oper,
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
       p_movi_clpr_desc,
       p_movi_emit_reci,
       p_movi_afec_sald,
       p_movi_dbcr,
       p_movi_empr_codi,
       p_movi_obse,
       p_movi_tacu_comi,
       p_movi_tacu_iva,
       p_movi_tacu_rete_rent,
       p_movi_tacu_iva_rete_rent,
       parameter.p_codi_base);
  
  end;

  procedure pp_insert_movi_conc_deta(p_moco_movi_codi number,
                                     p_moco_nume_item number,
                                     p_moco_conc_codi number,
                                     p_moco_cuco_codi number,
                                     p_moco_impu_codi number,
                                     p_moco_impo_mmnn number,
                                     p_moco_impo_mmee number,
                                     p_moco_impo_mone number,
                                     p_moco_dbcr      char) is
  
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
       moco_dbcr,
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
       p_moco_dbcr,
       parameter.p_codi_base);
  
  end;

  procedure pp_insert_come_movi_impo_deta(p_moim_movi_codi      in number,
                                          p_moim_nume_item      in number,
                                          p_moim_tipo           in char,
                                          p_moim_cuen_codi      in number,
                                          p_moim_dbcr           in char,
                                          p_moim_afec_caja      in char,
                                          p_moim_fech           in date,
                                          p_moim_impo_mone      in number,
                                          p_moim_impo_mmnn      in number,
                                          p_MOIM_TARJ_CUPO_CODI in number) is
  begin
    insert into come_movi_impo_deta
      (moim_movi_codi,
       moim_nume_item,
       moim_tipo,
       moim_cuen_codi,
       moim_dbcr,
       moim_afec_caja,
       moim_fech,
       moim_impo_mone,
       moim_impo_mmnn,
       MOIM_TARJ_CUPO_CODI,
       moim_base)
    values
      (p_moim_movi_codi,
       p_moim_nume_item,
       p_moim_tipo,
       p_moim_cuen_codi,
       p_moim_dbcr,
       p_moim_afec_caja,
       p_moim_fech,
       p_moim_impo_mone,
       p_moim_impo_mmnn,
       p_MOIM_TARJ_CUPO_CODI,
       parameter.p_codi_base);
  
  end;

  procedure pp_insert_come_movi_impu_deta(p_moim_impu_codi in number,
                                          p_moim_movi_codi in number,
                                          p_moim_impo_mmnn in number,
                                          p_moim_impo_mmee in number,
                                          p_moim_impu_mmnn in number,
                                          p_moim_impu_mmee in number,
                                          p_moim_impo_mone in number,
                                          p_moim_impu_mone in number) is
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

  procedure pl_muestra_come_cuen_banc(p_cuen_codi      in number,
                                      p_cuen_desc      out char,
                                      p_cuen_mone_codi out number,
                                      p_banc_codi      out number,
                                      p_banc_desc      out char,
                                      p_cuen_nume      out char) is
  begin
    select cuen_desc, cuen_mone_codi, banc_codi, banc_desc, cuen_nume
      into p_cuen_desc,
           p_cuen_mone_codi,
           p_banc_codi,
           p_banc_desc,
           p_cuen_nume
      from come_cuen_banc, come_banc
     where cuen_banc_codi = banc_codi(+)
       and cuen_codi = p_cuen_codi;
  
  exception
    when no_data_found then
      p_cuen_desc := null;
      p_banc_codi := null;
      p_banc_desc := null;
      pl_mostrar_error('Cuenta Bancaria Inexistente');
    
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

/***** INICIO *****/
begin

  pp_muestra_tipo_movi(parameter.p_codi_timo_depo_tarj,
                       v_movi_afec_sald,
                       v_movi_emit_reci,
                       v_movi_dbcr);

  pa_devu_fech_habi(p_fech_inic, p_fech_fini);

  select m.timo_tica_codi
    into parameter.p_timo_tica_codi
    from come_tipo_movi m
   where m.timo_codi = parameter.p_codi_timo_depo_tarj;

  pp_set_variable;

  parameter.p_codi_timo_depo_tarj := to_number(fa_busc_para('p_codi_timo_depo_tarj'));
  parameter.p_cant_deci_mmnn      := to_number(fa_busc_para('p_cant_deci_mmnn'));
  parameter.p_codi_mone_mmnn      := to_number(fa_busc_para('p_codi_mone_mmnn'));
  parameter.p_codi_conc           := to_number(fa_busc_para('p_codi_conc_depo_tarj'));
  parameter.p_codi_impu_exen      := to_number(fa_busc_para('p_codi_impu_exen'));
  parameter.p_codi_base           := 1;

end i020225;
