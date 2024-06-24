
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020324" is

  bcab come_movi%rowtype;

  type b_cabecera is record(
    
    p_clpr_codi           number,
    s_clpr_codi           number,
    s_clpr_codi_alte      number,
    s_codi_movi           number,
    s_movi_codi           number,
    s_nume                number,
    movi_fech_emis_rete   date,
    s_fech_venc_timb_movi date,
    fech_emis_movi        date,
    fech_oper_movi        date,
    s_clpr_desc           varchar2(50),
    movi_sucu_desc_orig   varchar2(50),
    tico_codi             come_tipo_comp.tico_codi%type,
    tico_indi_timb        come_tipo_comp.tico_indi_timb%type,
    tico_fech_rein        come_tipo_comp.tico_fech_rein%type,
    tico_indi_habi_timb   come_tipo_comp.tico_indi_habi_timb%type,
    tico_indi_timb_auto   come_tipo_comp.tico_indi_timb_auto%type,
    tico_indi_vali_timb   come_tipo_comp.tico_indi_vali_timb%type,
    clpr_indi_clie_prov   come_clie_prov.clpr_indi_clie_prov%type,
    movi_mone_desc_abre   come_mone.mone_desc_abre%type,
    movi_mone_cant_deci   come_mone.mone_cant_deci%type);

  bcab1 b_cabecera;

  type r_cabecera is record(
    
    sum_w_impo_rete_rent     number,
    sum_w_impo_iva_rete_rent number,
    sum_w_impo_mone          number,
    movi_codi_check          varchar2(20));

  bdatos r_cabecera;

  type d_cabecera is record(
    
    tapr_codi           come_tarj_proc.tapr_codi%type,
    tapr_desc           come_tarj_proc.tapr_desc%type,
    tapr_porc_comi      come_tarj_proc.tapr_porc_comi%type,
    tapr_porc_iva       come_tarj_proc.tapr_porc_iva%type,
    tapr_porc_rete_iva  come_tarj_proc.tapr_porc_rete_iva%type,
    tapr_porc_rete_rent come_tarj_proc.tapr_porc_rete_rent%type,
    movi_fech_emis_desd date,
    movi_fech_emis_hast date);

  bsel d_cabecera;

  type r_variable is record(
    p_movi_dbcr_rete               char,
    p_clpr_codi                    number,
    p_movi_codi_rete               number,
    p_timo_tica_codi               come_tipo_movi.timo_tica_codi%type,
    p_cant_deci_mmnn               number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_codi_mone_mmnn               number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_codi_impu_grav10             number := to_number(general_skn.fl_busca_parametro('p_codi_impu_grav10')),
    p_codi_impu_exen               number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_codi_timo_depo_tarj          number := to_number(general_skn.fl_busca_parametro('p_codi_timo_depo_tarj')),
    p_codi_timo_liqu_tarj          number := to_number(general_skn.fl_busca_parametro('p_codi_timo_fcor')),
    p_codi_timo_rete_reci          number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rete_reci')),
    p_form_calc_rete_emit          number := to_number(general_skn.fl_busca_parametro('p_form_calc_rete_emit')),
    p_codi_conc_iva_comi_liqu      number := to_number(general_skn.fl_busca_parametro('p_codi_conc_iva_comi_liqu')),
    p_codi_conc_rete_rent_liqu     number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_rent_liqu')),
    p_codi_conc_iva_rete_rent_liqu number := to_number(general_skn.fl_busca_parametro('p_codi_conc_iva_rete_rent_liqu')),
    p_codi_base                    number := pack_repl.fa_devu_codi_base);
  parameter r_variable;

  procedure pp_iniciar is
  begin
    select timo_codi,
           m.timo_tica_codi,
           m.timo_dbcr,
           m.timo_tico_codi,
           tico_indi_timb,
           tico_fech_rein,
           tico_indi_habi_timb,
           tico_indi_timb_auto,
           tico_indi_vali_timb
      into bcab.movi_timo_codi,
           parameter.p_timo_tica_codi,
           bcab.movi_dbcr,
           bcab1.tico_codi,
           bcab1.tico_indi_timb,
           bcab1.tico_fech_rein,
           bcab1.tico_indi_habi_timb,
           bcab1.tico_indi_timb_auto,
           bcab1.tico_indi_vali_timb
      from come_tipo_movi m, come_tipo_comp
     where timo_tico_codi = tico_codi(+)
       and timo_codi = parameter.p_codi_timo_rete_reci; --:parameter.p_codi_timo_liqu_tarj;
  
    if parameter.p_timo_tica_codi is null then
      raise_application_error(-20001,
                              'Debe configurar el tipo de cambio para el tipo de movimiento ' ||
                              parameter.p_codi_timo_rete_reci); --:parameter.p_codi_timo_liqu_tarj);
    end if;
  
    if bcab1.tico_codi is null then
      raise_application_error(-20001,
                              'Debe configurar el tipo de comprobante para el tipo de movimiento' ||
                              parameter.p_codi_timo_rete_reci); --:parameter.p_codi_timo_liqu_tarj);
    end if;
  exception
    when no_data_found then
      raise_application_error(-20001, 'El tipo de movimiento no existe.');
    when others then
      raise_application_error(-20001, sqlcode || sqlerrm);
  end pp_iniciar;

  procedure pp_valida_fech(p_fech in date) is
    v_fech_inic date;
    v_fech_fini date;
  begin
    pa_devu_fech_habi(v_fech_inic, v_fech_fini);
    if p_fech not between v_fech_inic and v_fech_fini then
      raise_application_error(-20001,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(v_fech_inic, 'dd/mm/yyyy') || ' y ' ||
                              to_char(v_fech_fini, 'dd/mm/yyyy'));
    end if;
  
  end pp_valida_fech;

  procedure pp_muestra_clpr(p_clpr_codi_alte      in number,
                            p_clpr_desc           out varchar2,
                            p_clpr_codi           out number,
                            p_tapr_codi           out number,
                            p_clpr_indi_clie_prov out varchar2) is
  begin
    select clpr_desc, clpr_codi, tapr_codi, clpr_indi_clie_prov
      into p_clpr_desc, p_clpr_codi, p_tapr_codi, p_clpr_indi_clie_prov
      from come_clie_prov, come_tarj_proc
     where clpr_codi = tapr_clpr_codi
       and clpr_codi_alte = p_clpr_codi_alte;
  
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Proveedor inexistente o no esta Relacionado a una Procesadora.');
    when others then
      raise_application_error(-20001, sqlcode || sqlerrm);
  end pp_muestra_clpr;

  procedure pp_valida_importes is
  begin
    if nvl(bdatos.sum_w_impo_mone, 0) = 0 then
      raise_application_error(-20001,
                              'Debe seleccionar por lo menos un deposito.');
    end if;
  end pp_valida_importes;

  procedure pp_muestra_tipo_movi(p_timo_codi      in number,
                                 p_timo_afec_sald out varchar2,
                                 p_timo_emit_reci out varchar2,
                                 p_timo_dbcr      out varchar2) is
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
      raise_application_error(-20001, 'Tipo de Movimiento inexistente');
    when too_many_rows then
      raise_application_error(-20001, 'Tipo de Movimiento duplicado');
  end pp_muestra_tipo_movi;

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
                                p_movi_user               in varchar2,
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
                                p_movi_clpr_desc          in varchar2,
                                p_movi_emit_reci          in varchar2,
                                p_movi_afec_sald          in varchar2,
                                p_movi_dbcr               in varchar2,
                                p_movi_empr_codi          in number,
                                p_movi_obse               in varchar2,
                                p_movi_indi_liqu_tarj     in varchar2,
                                p_movi_tacu_comi          in number,
                                p_movi_tacu_iva           in number,
                                p_movi_tacu_rete_rent     in number,
                                p_movi_tacu_iva_rete_rent in number,
                                p_movi_codi_padr_vali     in number) is
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
       movi_codi_padr_vali,
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
       p_movi_codi_padr_vali,
       parameter.p_codi_base);
  
  end pp_insert_come_movi;

  procedure pp_actualiza_movi_rete is
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
    v_movi_codi_padr_vali     number;
  
  begin
    --insertar la cabecera del deposito bancario.................................
    pp_muestra_tipo_movi(parameter.p_codi_timo_rete_reci,
                         v_movi_afec_sald,
                         v_movi_emit_reci,
                         v_movi_dbcr);
  
    parameter.p_movi_dbcr_rete := v_movi_dbcr;
    v_movi_codi                := fa_sec_come_movi;
    parameter.p_movi_codi_rete := v_movi_codi;
    v_movi_timo_codi           := parameter.p_codi_timo_rete_reci;
    v_movi_clpr_codi           := bcab1.p_clpr_codi; --bcab.clpr_codi;
    v_movi_cuen_codi           := null;
    bcab.movi_dbcr             := v_movi_dbcr;
    v_movi_sucu_codi_orig      := bcab.movi_sucu_codi_orig;
    v_movi_mone_codi           := bcab.movi_mone_codi;
    v_movi_nume                := bcab.movi_nume;
    v_movi_nume_timb           := bcab.movi_nume_timb;
    v_movi_fech_emis           := bcab1.movi_fech_emis_rete; --bcab.movi_fech_emis;
    v_movi_fech_grab           := to_date(to_char(sysdate, 'dd-mm-yyyy'),
                                          'dd-mm-yyyy');
    v_movi_user                := user;
    v_movi_codi_padr           := null; --bcab.movi_codi;
    v_movi_tasa_mone           := bcab.movi_tasa_mone;
    v_movi_tasa_mmee           := 0;
    v_movi_codi_padr_vali      := bcab1.s_codi_movi;
    v_movi_grav_mmnn           := 0;
    v_movi_exen_mmnn           := round(((bdatos.SUM_W_IMPO_RETE_RENT +
                                        bdatos.SUM_W_IMPO_IVA_RETE_RENT) *
                                        bcab.movi_tasa_mone),
                                        parameter.p_cant_deci_mmnn);
    v_movi_iva_mmnn            := 0;
    v_movi_grav_mmee           := 0;
    v_movi_exen_mmee           := 0;
    v_movi_iva_mmee            := 0;
    v_movi_grav_mone           := 0;
    v_movi_exen_mone           := round((bdatos.SUM_W_IMPO_RETE_RENT +
                                        bdatos.SUM_W_IMPO_IVA_RETE_RENT),
                                        bcab1.movi_mone_cant_deci);
    v_movi_iva_mone            := 0;
    v_movi_impo_mone_ii        := round((bdatos.SUM_W_IMPO_RETE_RENT +
                                        bdatos.SUM_W_IMPO_IVA_RETE_RENT),
                                        bcab1.movi_mone_cant_deci);
    v_movi_impo_mmnn_ii        := round(((bdatos.SUM_W_IMPO_RETE_RENT +
                                        bdatos.SUM_W_IMPO_IVA_RETE_RENT) *
                                        bcab.movi_tasa_mone),
                                        parameter.p_cant_deci_mmnn);
    v_movi_grav10_ii_mone      := 0;
    v_movi_grav10_ii_mmnn      := 0;
    v_movi_grav5_ii_mone       := 0;
    v_movi_grav5_ii_mmnn       := 0;
    v_movi_grav10_mone         := 0;
    v_movi_grav10_mmnn         := 0;
    v_movi_grav5_mone          := 0;
    v_movi_grav5_mmnn          := 0;
    v_movi_iva10_mone          := 0;
    v_movi_iva10_mmnn          := 0;
    v_movi_iva5_mone           := 0;
    v_movi_iva5_mmnn           := 0;
    v_movi_clpr_desc           := null;
    v_movi_empr_codi           := null;
    v_movi_obse                := bcab.movi_obse;
    v_movi_indi_liqu_tarj      := 'S';
    v_movi_tacu_comi           := null;
    v_movi_tacu_iva            := null;
    v_movi_tacu_rete_rent      := null;
    v_movi_tacu_iva_rete_rent  := null;
  
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
                        v_movi_tacu_iva_rete_rent,
                        v_movi_codi_padr_vali);
  end pp_actualiza_movi_rete;

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
                                     p_moco_dbcr           in char) is
  
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
       parameter.p_codi_base);
  
  end pp_insert_movi_conc_deta;

  procedure pp_actualiza_moco_rete is
  
    --variables para moco
    v_moco_movi_codi      number;
    v_moco_nume_item      number := 0;
    v_moco_conc_codi      number;
    v_moco_cuco_codi      number;
    v_moco_impu_codi      number;
    v_moco_impo_mmnn      number;
    v_moco_impo_mmee      number;
    v_moco_impo_mone      number;
    v_moco_impo_mone_ii   number;
    v_moco_impo_mmnn_ii   number;
    v_moco_exen_mone      number;
    v_moco_exen_mmnn      number;
    v_moco_grav10_ii_mone number;
    v_moco_grav10_ii_mmnn number;
    v_moco_grav5_ii_mone  number;
    v_moco_grav5_ii_mmnn  number;
    v_moco_grav10_mone    number;
    v_moco_grav10_mmnn    number;
    v_moco_grav5_mone     number;
    v_moco_grav5_mmnn     number;
    v_moco_iva10_mone     number;
    v_moco_iva10_mmnn     number;
    v_moco_iva5_mone      number;
    v_moco_iva5_mmnn      number;
    v_moco_dbcr           char(1);
  
  begin
  
    v_moco_movi_codi := parameter.p_movi_codi_rete;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_exen;
    v_moco_impo_mmee := 0;
    v_moco_dbcr      := parameter.p_movi_dbcr_rete;
  
    ----actualizar moco Renta
    if nvl(bdatos.sum_w_impo_rete_rent, 0) > 0 then
      v_moco_conc_codi      := parameter.p_codi_conc_rete_rent_liqu;
      v_moco_nume_item      := v_moco_nume_item + 1;
      v_moco_impo_mmnn      := round((bdatos.sum_w_impo_rete_rent *
                                     bcab.movi_tasa_mone),
                                     parameter.p_cant_deci_mmnn);
      v_moco_impo_mone      := round(bdatos.sum_w_impo_rete_rent,
                                     bcab1.movi_mone_cant_deci);
      v_moco_impo_mone_ii   := round(bdatos.sum_w_impo_rete_rent,
                                     bcab1.movi_mone_cant_deci);
      v_moco_impo_mmnn_ii   := round(bdatos.sum_w_impo_rete_rent,
                                     parameter.p_cant_deci_mmnn);
      v_moco_exen_mone      := round(bdatos.sum_w_impo_rete_rent,
                                     bcab1.movi_mone_cant_deci);
      v_moco_exen_mmnn      := round(bdatos.sum_w_impo_rete_rent,
                                     parameter.p_cant_deci_mmnn);
      v_moco_grav10_ii_mone := 0;
      v_moco_grav10_ii_mmnn := 0;
      v_moco_grav5_ii_mone  := 0;
      v_moco_grav5_ii_mmnn  := 0;
      v_moco_grav10_mone    := 0;
      v_moco_grav10_mmnn    := 0;
      v_moco_grav5_mone     := 0;
      v_moco_grav5_mmnn     := 0;
      v_moco_iva10_mone     := 0;
      v_moco_iva10_mmnn     := 0;
      v_moco_iva5_mone      := 0;
      v_moco_iva5_mmnn      := 0;
    
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
                               v_moco_dbcr);
    end if;
  
    ----actualizar moco IVA S/Rent
    if nvl(bdatos.sum_w_impo_iva_rete_rent, 0) > 0 then
      v_moco_conc_codi      := parameter.p_codi_conc_iva_rete_rent_liqu;
      v_moco_nume_item      := v_moco_nume_item + 1;
      v_moco_impo_mmnn      := round((bdatos.sum_w_impo_iva_rete_rent *
                                     bcab.movi_tasa_mone),
                                     parameter.p_cant_deci_mmnn);
      v_moco_impo_mone      := round(bdatos.sum_w_impo_iva_rete_rent,
                                     bcab1.movi_mone_cant_deci);
      v_moco_impo_mone_ii   := round(bdatos.sum_w_impo_iva_rete_rent,
                                     bcab1.movi_mone_cant_deci);
      v_moco_impo_mmnn_ii   := round(bdatos.sum_w_impo_iva_rete_rent,
                                     parameter.p_cant_deci_mmnn);
      v_moco_exen_mone      := round(bdatos.sum_w_impo_iva_rete_rent,
                                     bcab1.movi_mone_cant_deci);
      v_moco_exen_mmnn      := round(bdatos.sum_w_impo_iva_rete_rent,
                                     parameter.p_cant_deci_mmnn);
      v_moco_grav10_ii_mone := 0;
      v_moco_grav10_ii_mmnn := 0;
      v_moco_grav5_ii_mone  := 0;
      v_moco_grav5_ii_mmnn  := 0;
      v_moco_grav10_mone    := 0;
      v_moco_grav10_mmnn    := 0;
      v_moco_grav5_mone     := 0;
      v_moco_grav5_mmnn     := 0;
      v_moco_iva10_mone     := 0;
      v_moco_iva10_mmnn     := 0;
      v_moco_iva5_mone      := 0;
      v_moco_iva5_mmnn      := 0;
    
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
                               v_moco_dbcr);
    end if;
  end pp_actualiza_moco_rete;

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
  
  end pp_insert_come_movi_impu_deta;

  procedure pp_actualiza_moimpu_rete is
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
    v_moim_impu_codi      := parameter.p_codi_impu_exen;
    v_moim_movi_codi      := parameter.p_movi_codi_rete;
    v_moim_impo_mmnn      := round(((bdatos.SUM_W_IMPO_RETE_RENT +
                                   bdatos.SUM_W_IMPO_IVA_RETE_RENT) *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_moim_impo_mmee      := 0;
    v_moim_impu_mmnn      := 0;
    v_moim_impu_mmee      := 0;
    v_moim_impo_mone      := round((bdatos.SUM_W_IMPO_RETE_RENT +
                                   bdatos.SUM_W_IMPO_IVA_RETE_RENT),
                                   bcab1.movi_mone_cant_deci);
    v_moim_impu_mone      := 0;
    v_moim_impo_mone_ii   := round((bdatos.SUM_W_IMPO_RETE_RENT +
                                   bdatos.SUM_W_IMPO_IVA_RETE_RENT),
                                   bcab1.movi_mone_cant_deci);
    v_moim_impo_mmnn_ii   := round(((bdatos.SUM_W_IMPO_RETE_RENT +
                                   bdatos.SUM_W_IMPO_IVA_RETE_RENT) *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_moim_exen_mone      := round((bdatos.SUM_W_IMPO_RETE_RENT +
                                   bdatos.SUM_W_IMPO_IVA_RETE_RENT),
                                   bcab1.movi_mone_cant_deci);
    v_moim_exen_mmnn      := round(((bdatos.SUM_W_IMPO_RETE_RENT +
                                   bdatos.SUM_W_IMPO_IVA_RETE_RENT) *
                                   bcab.movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_moim_grav10_ii_mone := 0;
    v_moim_grav10_ii_mmnn := 0;
    v_moim_grav5_ii_mone  := 0;
    v_moim_grav5_ii_mmnn  := 0;
    v_moim_grav10_mone    := 0;
    v_moim_grav10_mmnn    := 0;
    v_moim_grav5_mone     := 0;
    v_moim_grav5_mmnn     := 0;
    v_moim_iva10_mone     := 0;
    v_moim_iva10_mmnn     := 0;
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
  end pp_actualiza_moimpu_rete;

  procedure pp_actualiza_depositos is
  
  begin
  
    update come_movi_tarj_cupo
       set mota_codi_rete_liqu = parameter.p_movi_codi_rete
     where mota_movi_codi = bdatos.movi_codi_check
       and mota_nume_orde = 2;
  end pp_actualiza_depositos;

  procedure pl_muestra_come_sucu(p_sucu_codi in number,
                                 p_sucu_desc out varchar2) is
  
  begin
  
    select sucu_desc
      into p_sucu_desc
      from come_sucu
     where sucu_codi = p_sucu_codi;
  
  Exception
    when no_data_found then
      raise_application_error(-20001, 'Sucursal inexistente!');
    when others then
      raise_application_error(-20001, sqlcode || sqlerrm);
  end pl_muestra_come_sucu;

  procedure pp_mostrar_mone(p_mone_codi      in number,
                            p_mone_desc_abre out varchar2,
                            p_mone_cant_deci out varchar2) is
  begin
    select mone_desc_abre, mone_cant_deci
      into p_mone_desc_abre, p_mone_cant_deci
      from come_mone
     where mone_codi = p_mone_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Moneda Inexistente!');
    when others then
      raise_application_error(-20001, sqlcode || sqlerrm);
  end pp_mostrar_mone;

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
      raise_application_error(-20001,
                              'Cotizaciion Inexistente para la fecha del documento');
    when others then
      raise_application_error(-20001, sqlcode || sqlcode);
  end pp_busca_tasa_mone;

  procedure pp_muestra_clpr_qry(p_clpr_codi           in number,
                                p_clpr_desc           out varchar2,
                                p_clpr_codi_alte      out varchar2,
                                p_tapr_codi           out number,
                                p_clpr_indi_clie_prov out varchar2) is
  begin
    select clpr_desc, clpr_codi_alte, tapr_codi, clpr_indi_clie_prov
      into p_clpr_desc,
           p_clpr_codi_alte,
           p_tapr_codi,
           p_clpr_indi_clie_prov
      from come_clie_prov, come_tarj_proc
     where clpr_codi = tapr_clpr_codi
       and clpr_codi = p_clpr_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Proveedor inexistente o no esta Relacionado a una Procesadora.');
    when others then
      raise_application_error(-20001, sqlcode || sqlerrm);
  end pp_muestra_clpr_qry;

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
      raise_application_error(-20001, 'Procesadora inexistente.');
    when others then
      raise_application_error(-20001, sqlcode || sqlerrm);
  end pp_muestra_come_tarj_proc;

  procedure pp_cargar_movi_codi is
  
  begin
    select movi_codi,
           movi_fech_emis,
           movi_fech_oper,
           movi_clpr_codi,
           movi_nume,
           movi_nume_timb,
           to_char(movi_fech_venc_timb, 'dd-mm-yyyy'),
           movi_mone_codi,
           movi_obse,
           movi_sucu_codi_orig
      into bcab1.s_codi_movi,
           bcab1.fech_emis_movi,
           bcab1.fech_oper_movi,
           bcab1.s_clpr_codi,
           bcab.movi_nume,
           bcab.movi_nume_timb,
           bcab1.s_fech_venc_timb_movi,
           bcab.movi_mone_codi,
           bcab.movi_obse,
           bcab.movi_sucu_codi_orig
      from come_movi
     where movi_codi = bcab1.s_movi_codi;
  
    if bcab.movi_sucu_codi_orig is not null then
      pl_muestra_come_sucu(bcab.movi_sucu_codi_orig,
                           bcab1.movi_sucu_desc_orig);
    end if;
    if bcab.movi_mone_codi is not null then
      pp_mostrar_mone(bcab.movi_mone_codi,
                      bcab1.movi_mone_desc_abre,
                      bcab1.movi_mone_cant_deci);
      pp_busca_tasa_mone(bcab.movi_mone_codi, bcab.movi_tasa_mone);
      --pp_formatear_importes;
    end if;
  
    if bcab1.s_clpr_codi is not null then
      --pl_mm('bcab.s_codi_clpr:  ' || bcab.s_clpr_codi);
    
      pp_muestra_clpr_qry(bcab1.s_clpr_codi,
                          bcab1.s_clpr_desc,
                          bcab1.s_clpr_codi_alte,
                          bsel.tapr_codi,
                          bcab1.clpr_indi_clie_prov);
    
      pp_muestra_come_tarj_proc(bsel.tapr_codi,
                                bsel.tapr_desc,
                                bsel.tapr_porc_comi,
                                bsel.tapr_porc_iva,
                                bsel.tapr_porc_rete_iva,
                                bsel.tapr_porc_rete_rent);
    else
      bcab1.s_clpr_codi         := null;
      bcab1.s_clpr_desc         := null;
      bsel.tapr_codi            := null;
      bcab1.clpr_indi_clie_prov := null;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Nro de movimiento Inexistente.');
    when too_many_rows then
      raise_application_error(-20001,
                              'Existen dos Movimientos con el mismo numero, avise a su administrador');
      --aca deberia consultar todos los ajustes con el mismo nro..            
  end pp_cargar_movi_codi;

  procedure pp_cargar_movi_nume is
  
  begin
    select movi_codi,
           movi_fech_emis,
           movi_fech_oper,
           movi_clpr_codi,
           movi_nume,
           movi_nume_timb,
           to_char(movi_fech_venc_timb, 'dd-mm-yyyy'),
           movi_mone_codi,
           movi_obse,
           movi_sucu_codi_orig
      into bcab1.s_codi_movi,
           bcab1.fech_emis_movi,
           bcab1.fech_oper_movi,
           bcab1.s_clpr_codi,
           bcab.movi_nume,
           bcab.movi_nume_timb,
           bcab1.s_fech_venc_timb_movi,
           bcab.movi_mone_codi,
           bcab.movi_obse,
           bcab.movi_sucu_codi_orig
      from come_movi
     where movi_timo_codi = parameter.p_codi_timo_liqu_tarj
       and (bcab.movi_fech_emis is null or
           movi_fech_emis = bcab.movi_fech_emis)
       and (bcab.movi_fech_oper is null or
           movi_fech_oper = bcab.movi_fech_oper)
       and (bcab1.p_clpr_codi is null or movi_clpr_codi = bcab1.p_clpr_codi)
       and (bcab1.s_nume is null or movi_nume = bcab1.s_nume)
       and movi_indi_liqu_tarj = 'S';
  
    if bcab.movi_sucu_codi_orig is not null then
      pl_muestra_come_sucu(bcab.movi_sucu_codi_orig,
                           bcab1.movi_sucu_desc_orig);
    end if;
    if bcab.movi_mone_codi is not null then
      pp_mostrar_mone(bcab.movi_mone_codi,
                      bcab1.movi_mone_desc_abre,
                      bcab1.movi_mone_cant_deci);
      pp_busca_tasa_mone(bcab.movi_mone_codi, bcab.movi_tasa_mone);
      --pp_formatear_importes;
    end if;
  
    if bcab1.s_clpr_codi is not null then
      --pl_mm('bcab.s_codi_clpr:  ' || bcab.s_clpr_codi);
    
      pp_muestra_clpr_qry(bcab1.s_clpr_codi,
                          bcab1.s_clpr_desc,
                          bcab1.s_clpr_codi_alte,
                          bsel.tapr_codi,
                          bcab1.clpr_indi_clie_prov);
    
      pp_muestra_come_tarj_proc(bsel.tapr_codi,
                                bsel.tapr_desc,
                                bsel.tapr_porc_comi,
                                bsel.tapr_porc_iva,
                                bsel.tapr_porc_rete_iva,
                                bsel.tapr_porc_rete_rent);
    else
      bcab1.s_clpr_codi         := null;
      bcab1.s_clpr_desc         := null;
      bsel.tapr_codi            := null;
      bcab1.clpr_indi_clie_prov := null;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Nro de movimiento Inexistente.');
    when too_many_rows then
      raise_application_error(-20001,
                              'Existen dos Movimientos con el mismo numero, avise a su administrador');
      --aca deberia consultar todos los ajustes con el mismo nro..            
  end pp_cargar_movi_nume;

  procedure pp_validar_movi is
    salir exception;
    v_nume varchar2(200);
    v_cant number := 0;
  
  begin
    pp_iniciar;
    --pp_set_variable;
    if bcab1.s_movi_codi is not null then
      null;
      pp_cargar_movi_codi;
    else
      v_nume := bcab1.s_nume;
      --set_item_property('bcab1.s_nume', lov_name, 'lov_nume');
      begin
        select count(*)
          into v_cant
          from come_movi
         where movi_timo_codi = parameter.p_codi_timo_liqu_tarj
           and (bcab.movi_fech_emis is null or
               movi_fech_emis = bcab.movi_fech_emis)
           and (bcab.movi_fech_oper is null or
               movi_fech_oper = bcab.movi_fech_oper)
           and (bcab1.s_nume is null or movi_nume = bcab1.s_nume);
      end;
    
      if v_cant > 1 then
        --si existe mas de una liquidacion con el mismo nro
        bcab1.s_nume      := v_nume; --para que muestre la lista de acuerdo al nuevo string
        bcab1.s_movi_codi := null; --para ver si se acepto un valor o no despues del list_values
        --list_values;
        if bcab1.s_movi_codi is not null then
          pp_cargar_movi_codi; --pp_ejecutar_consulta_codi;
        end if;
      elsif v_cant = 1 then
        pp_cargar_movi_nume; --pp_ejecutar_consulta_nume; 
      elsif v_cant = 0 then
        raise_application_error(-20001, 'Nro de movimiento inexistente.');
      end if;
    end if;
  
  exception
    when salir then
      null;
  end pp_validar_movi;

  procedure pp_validar_nro is
    v_count   number;
    v_message varchar2(1000) := 'Nro de Comprobante Existente!!!!! , favor verifique!!';
    salir exception;
  
  begin
  
    if bcab1.fech_emis_movi < bcab1.tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = bcab.movi_nume
         and ((bcab1.clpr_indi_clie_prov = 'P' and
             movi_clpr_codi = bcab1.s_clpr_codi) or
             nvl(bcab1.clpr_indi_clie_prov, 'N') = 'C')
         and timo_tico_codi = bcab1.tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis < bcab1.tico_fech_rein;
    
    elsif bcab1.fech_emis_movi > bcab1.tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = bcab.movi_nume
         and ((bcab1.clpr_indi_clie_prov = 'P' and
             movi_clpr_codi = bcab1.s_clpr_codi) or
             nvl(bcab1.clpr_indi_clie_prov, 'N') = 'C')
         and timo_tico_codi = bcab1.tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis >= bcab1.tico_fech_rein;
    end if;
  
    if v_count > 0 then
      raise_application_error(-20001, v_message);
    end if;
  
  exception
    when salir then
      raise_application_error(-20001, 'Reingrese el nro de comprobante');
  end pp_validar_nro;
  procedure pp_devu_timb(i_tico_codi in number,
                         i_esta      in number,
                         i_punt_expe in number,
                         i_clpr_codi in number,
                         i_fech_movi in date,
                         o_nume_timb out varchar,
                         o_fech_venc out date) is
  
  begin
    select cptc_nume_timb, cptc_fech_venc
      into o_nume_timb, o_fech_venc
      from come_clpr_tipo_comp
     where cptc_clpr_codi = i_clpr_codi --proveedor, cliente
       and cptc_tico_codi = i_tico_codi --tipo de comprobante
       and cptc_esta = i_esta --establecimiento 
       and cptc_punt_expe = i_punt_expe --punto de expedicion
       and cptc_fech_venc >= i_fech_movi
     order by cptc_fech_venc;
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'El proveedor no tiene un timbrado vigente. Favor verificar.');
      /*when too_many_rows then
      set_item_property('bcab.s_nro_3', lov_name, 'lov_nume_timb');
      list_values;*/
    when others then
      raise_application_error(-20001, 'Error al recuperar timbrado.');
  end;

  procedure pp_ejecutar_consulta(i_tapr_codi           in number,
                                 i_movi_fech_emis_desd in date,
                                 i_movi_fech_emis_hast in date) is
    l_query varchar2(5000);
    p_where varchar2(5000) := ' and 1 = 1 ';
  begin
    if i_tapr_codi is not null then
      p_where := p_where || ' and c.tacu_tapr_codi = bsel.tapr_codi ';
    end if;
  
    if i_movi_fech_emis_desd is not null then
      p_where := p_where ||
                 ' a.movi_fech_emis >= bsel.movi_fech_emis_desd ';
    end if;
  
    if i_movi_fech_emis_hast is not null then
      p_where := p_where ||
                 ' a.movi_fech_emis <= bsel.movi_fech_emis_hast ';
    end if;
  
    l_query := 'select movi_codi,
           movi_nume,
           movi_fech_emis,
           movi_fech_oper,
           sum(tacu_impo_mone) impo_mone,
           max(movi_tacu_comi) movi_tacu_comi,
           max(movi_tacu_iva) movi_tacu_iva,
           max(movi_tacu_rete_rent) movi_tacu_rete_rent,
           max(movi_tacu_iva_rete_rent) movi_tacu_iva_rete_rent
      from come_movi           a,
           come_movi_tarj_cupo b,
           come_tarj_cupo      c,
           come_movi_tarj_cupo b2
     where a.movi_codi = b.mota_movi_codi
       and b.mota_tacu_codi = c.tacu_codi
       /*and c.tacu_esta = ' || chr(39) || 'L' || chr(39) || '
       and a.movi_timo_codi = ' ||
               parameter.p_codi_timo_depo_tarj || '
       and b.mota_nume_orde = 2
       and b.mota_codi_rete_liqu is null
       and b.mota_tacu_codi = b2.mota_tacu_codi
       and b2.mota_movi_codi = bcab1.s_codi_movi
       and b2.mota_nume_orde = 3*/
       ' || p_where || '
     group by a.movi_codi, a.movi_nume, a.movi_fech_emis, a.movi_fech_oper
     order by a.movi_fech_emis, a.movi_nume';
  
--    insert into come_concat (campo1, otro) values (l_query, 'CONSULTA_DL');
  --  COMMIT;
  
    if (apex_collection.collection_exists(p_collection_name => 'bdatos')) then
      APEX_COLLECTION.DELETE_COLLECTION(p_collection_name => 'bdatos');
    end if;
  
    APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY(p_collection_name   => 'bdatos',
                                                 p_query             => l_query,
                                                 p_generate_md5      => 'NO');
  
  end pp_ejecutar_consulta;

  procedure pp_actualiza_registro is
  begin
    --pp_set_variable;
    if bcab1.movi_fech_emis_rete is null then
      raise_application_error(-20001,
                              'Debe ingresar la fecha de emision para la retención.');
    end if;
  
    pp_valida_fech(bcab1.movi_fech_emis_rete);
    pp_valida_importes;
    ----TM42 
    pp_actualiza_movi_rete;
    pp_actualiza_moco_rete;
    pp_actualiza_moimpu_rete;
    --pp_actualiza_come_movi_rete;
    pp_actualiza_depositos;
  
    -- Actualizar datos de la Retencion en la Liquidacion
    update come_movi m
       set m.movi_tacu_rete_rent     = round(nvl(m.movi_tacu_rete_rent, 0) +
                                             nvl(bdatos.sum_w_impo_rete_rent,
                                                 0),
                                             bcab1.movi_mone_cant_deci),
           m.movi_tacu_iva_rete_rent = round(nvl(m.movi_tacu_iva_rete_rent,
                                                 0) + nvl(bdatos.sum_w_impo_iva_rete_rent,
                                                          0),
                                             bcab1.movi_mone_cant_deci)
     where m.movi_codi = bcab1.s_codi_movi;
  
    --commit_form;
    --clear_form(no_validate);
    --message('Registro Actualizado');
  
  end pp_actualiza_registro;

end I020324;
