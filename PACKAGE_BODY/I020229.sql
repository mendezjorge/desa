
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020229" is

  type r_parameter is record(
    
    p_indi_vali_repe_cheq varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_vali_repe_cheq'))),
    p_codi_impu_exen      varchar2(100) := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_codi_impu_grav10    varchar2(100) := to_number(general_skn.fl_busca_parametro('p_codi_impu_grav10')),
    p_codi_impu_grav5     varchar2(100) := to_number(general_skn.fl_busca_parametro('p_codi_impu_grav5')),
    p_codi_mone_mmnn      varchar2(100) := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_codi_mone_mmee      varchar2(100) := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmee')),
    p_codi_clie_espo      varchar2(100) := to_number(general_skn.fl_busca_parametro('p_codi_clie_espo')),
    -- pp_muestra_desc_monevarchar2(100) (p_codi_mone_mmee, p_desc_mone_mmee, p_cant_deci_mmee),
    
    p_cant_deci_porc varchar2(100) := to_number(general_skn.fl_busca_parametro('p_cant_deci_porc')),
    p_cant_deci_mmnn varchar2(100) := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_cant_deci_mmee varchar2(100) := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmee')),
    p_cant_deci_cant varchar2(100) := to_number(general_skn.fl_busca_parametro('p_cant_deci_cant')),
    
    p_emit_reci         varchar2(100) := 'R',
    p_clie_prov         varchar2(100) := 'P',
    p_codi_conc         varchar2(100) ,--:= p_codi_conc_pago_prov,
    p_codi_conc_pago_prov varchar2(100),
    p_codi_timo_rcnadle varchar2(100) := to_number(general_skn.fl_busca_parametro('p_codi_timo_rcnadle')),
    p_codi_timo_rcnadlr varchar2(100) := to_number(general_skn.fl_busca_parametro('p_codi_timo_rcnadlr')),
    p_codi_timo_adlr    varchar2(100) := to_number(general_skn.fl_busca_parametro('p_codi_timo_adlr')),
    p_codi_timo_adle    varchar2(100) := to_number(general_skn.fl_busca_parametro('p_codi_timo_adle')),
    
    p_empr_codi         varchar2(100) := V('AI_EMPR_CODI'),
    p_sucu_codi         varchar2(100) := V('AI_SUCU_CODI'),
    p_codi_base         varchar2(100) := pack_repl.fa_devu_codi_base,
    p_peco_codi         varchar2(100) := 1,
    p_indi_carg_deta    varchar2(100) := 'N',
    p_fech_inic         varchar2(100),
    p_fech_fini         varchar2(100),
    p_indi_calc_mora_mult  varchar2(100),
    p_indi_fopa_chta_caja varchar2(100) := ltrim(rtrim(general_skn.fl_busca_parametro ('p_indi_fopa_chta_caja'))),
    p_codi_timo_extr_banc varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_timo_extr_banc')),
    p_codi_conc_cheq_cred varchar2(100) := to_number(general_skn.fl_busca_parametro ('p_codi_conc_cheq_cred'))
    	

    
    );

  parameter r_parameter;

  cursor g_cur_bdet is
    select SEQ_ID,
           c001   movi_nume,
           c002   mone_codi,
           c003   movi_fech_emis,
           c004   cupe_fech_venc,
           c005   cupe_impo_mone,
           c006   cupe_sald_mone,
           c007   cupe_movi_codi,
           c008   cupe_tasa_mone,
           c009   clpr_codi,
           c010   clpr_codi_alte,
           c011   s_movi_iva_mone,
           c012   s_marca,
           c013   impo_pago, --monto,
           c014   saldo,
           c015   movi_indi_tipo_pres,
           c016   cupe_impo_capi_mone, ---no se usa
           c017   cupe_impo_inte_mone,
           c018   cupe_nume_cuot,
           c019   cupe_sald_capi_mone,
           c020   cupe_sald_inte_mone,
           c021   s_impo_pago_inte,---revisar
           c022   s_impo_pago_capi,---revisar
           c023   s_impo_inte_doca_rend
      from apex_collections
     where collection_name = 'DETALLE';

  

  type r_bcab is record(
    p_emit_reci              varchar2(300),
    p_cant_deci_mmnn         varchar2(300),
    buscar                   varchar2(300),
    p_clie_prov              varchar2(300),
    movi_sucu_codi_orig      varchar2(300),
    indi_carg_deta           varchar2(300),
    movi_sucu_desc_orig      varchar2(300),
    movi_mone_cant_deci      varchar2(300),
    movi_clpr_codi           varchar2(300),
    s_clpr_codi_alte         varchar2(300),
    movi_codi                varchar2(300),
    movi_clpr_desc           varchar2(300),
    movi_codi_adel           varchar2(300),
    movi_fech_emis           varchar2(300),
    movi_timo_codi           varchar2(300),
    movi_fech_oper           varchar2(300),
    movi_timo_desc           varchar2(300),
    movi_nume                varchar2(300),
    movi_timo_desc_abre      varchar2(300),
    movi_tico_codi           varchar2(300),
    movi_mone_codi           varchar2(300),
    timo_indi_apli_adel_fopa varchar2(300),
    tica_codi                varchar2(300),
    timo_tica_codi           varchar2(300),
    s_dife                   varchar2(300),
    timo_dbcr_caja           varchar2(300),
    movi_tare_codi           varchar2(300),
    movi_mone_desc_abre      varchar2(300),
    clpr_prov_retener        varchar2(300),
    tica_desc                varchar2(300),
    movi_clpr_ruc            varchar2(300),
    movi_clpr_tele           varchar2(300),
    movi_clpr_dire           varchar2(300),
    movi_mone_desc           varchar2(300),
    movi_tasa_mone           number,
    movi_cuen_nume           varchar2(300),
    movi_tasa_mmee           number,
    movi_fech_grab           varchar2(300),
    s_impo_efec              varchar2(300),
    movi_grav_mmnn           number,
    movi_iva_mmnn            number,
    movi_exen_mone           number,
    movi_grav_mmee           number,
    movi_exen_mmnn           number,
    movi_exen_mmee           number,
    s_impo_cheq              varchar2(100),
    movi_iva_mmee            number,
    movi_grav_mone           number,
    movi_obse                varchar2(300),
    movi_iva_mone            number,
    movi_sald_mone           number,
    movi_sald_mmee           number,
    movi_sald_mmnn           number,
    movi_afec_sald           varchar2(100),
    movi_dbcr                varchar2(300),
    movi_user                varchar2(300),
    movi_emit_reci           varchar2(300),
    clpr_indi_clie_prov      varchar2(100),
    s_impo_tarj              varchar2(300),
    s_impo_adel              varchar2(300),
    sum_impo_pago            number,
    movi_empr_codi           number,
    timo_calc_iva            varchar(100),
    movi_oper_codi           number,
    timo_indi_sald           varchar(100),
    timo_indi_caja           varchar(100),
    s_total_neto             number,
    s_impo_mora              number,
    sum_s_impo_inte_doca_rend number,
    clpr_dire                varchar(1000),
    clpr_tele                varchar(100),
    clpr_ruc                 varchar(100),
    sum_s_imp_pago               number);
  bcab r_bcab;

 procedure pp_iniciar(p_clpr_indi_clie_prov        out varchar2,
                      P_movi_sucu_codi_orig        out number,
                      p_movi_sucu_desc_orig        out varchar2,
                      p_movi_emit_reci             out varchar2,
                      p_indi_carg_deta             out varchar2,
                      p_movi_timo_codi             out varchar2,
                      p_tica_codi                  out varchar2,
                      p_movi_tico_codi             out varchar2,
                      p_timo_indi_apli_adel_fopa   out varchar2,
                      p_timo_tica_codi             out varchar2, 
                      p_timo_dbcr_caja             out varchar2,
                      p_tica_desc                  out varchar2,
                      p_emit_reci                  out varchar2,
                      p_clie_prov                  out varchar2,
                      p_movi_dbcr                  out varchar2,
                      p_movi_afec_sald             out varchar2) is
                      
  begin
  
    --empresa, sucursal  
  
    bcab.movi_empr_codi      := parameter.p_empr_codi;
    bcab.movi_sucu_codi_orig := parameter.p_sucu_codi;
  
    -- tm
    bcab.movi_timo_codi := to_number(general_skn.fl_busca_parametro('p_codi_timo_pago_pres'));
  
    if bcab.movi_timo_codi is not null then
      pp_mostrar_tipo_movi(bcab.movi_timo_codi,
                           bcab.movi_afec_sald,
                           bcab.movi_emit_reci,
                           bcab.timo_calc_iva,
                           bcab.movi_oper_codi,
                           bcab.movi_dbcr,
                           bcab.timo_indi_sald,
                           bcab.timo_indi_caja,
                           bcab.timo_dbcr_caja,
                           bcab.timo_tica_codi,
                           bcab.timo_indi_apli_adel_fopa);
    else
      raise_application_error(-20001,
                              'Falta configurar Tipo de Movimiento para Pago de prestamos Bancarios.');
    end if;
   
    parameter.p_codi_conc      := parameter.p_codi_conc_pago_prov;
    pa_devu_fech_habi(parameter.p_fech_inic, parameter.p_fech_fini);
    bcab.clpr_indi_clie_prov := 'P';
    
    
    
    p_clpr_indi_clie_prov       := 'P';
    P_movi_sucu_codi_orig       := parameter.p_sucu_codi;
    p_movi_sucu_desc_orig       := NULL;
    p_movi_emit_reci            := bcab.movi_emit_reci;
    p_indi_carg_deta            := parameter.p_indi_carg_deta;
    p_movi_timo_codi            := bcab.movi_timo_codi;
    p_tica_codi                 := bcab.timo_tica_codi;
    p_movi_tico_codi            := NULL;
    p_timo_indi_apli_adel_fopa  := bcab.timo_indi_apli_adel_fopa;
    p_timo_tica_codi            := bcab.timo_tica_codi;
    p_timo_dbcr_caja            := bcab.timo_indi_caja;
    p_tica_desc                 := NULL;
    p_emit_reci                 := parameter.p_emit_reci;
    p_clie_prov                 := 'P';
    
    p_movi_dbcr                 := bcab.movi_dbcr;
    p_movi_afec_sald            := bcab.movi_afec_sald;
     APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name => 'DETALLE');
  end pp_iniciar;

  procedure pp_mostrar_tipo_movi(p_codi                     in number,
                                 p_afec_sald                out varchar2,
                                 p_emit_reci                out varchar2,
                                 p_calc_iva                 out varchar2,
                                 p_oper_codi                out number,
                                 p_dbcr                     out varchar2,
                                 p_indi_sald                out varchar2,
                                 p_indi_caja                out varchar2,
                                 p_dbcr_caja                out varchar2,
                                 p_tica_codi                out number,
                                 p_timo_indi_apli_adel_fopa out varchar2) is
  begin
  
    select timo_afec_sald,
           timo_emit_reci,
           nvl(timo_calc_iva, 'S'),
           timo_codi_oper,
           timo_dbcr,
           nvl(timo_indi_sald, 'N'),
           nvl(timo_indi_caja, 'N'),
           timo_dbcr_caja,
           timo_tica_codi,
           timo_indi_apli_adel_fopa
      into p_afec_sald,
           p_emit_reci,
           p_calc_iva,
           p_oper_codi,
           p_dbcr,
           p_indi_sald,
           p_indi_caja,
           p_dbcr_caja,
           p_tica_codi,
           p_timo_indi_apli_adel_fopa
      from come_tipo_movi
     where timo_codi = p_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Tipo de Movimiento inexistente');
    when too_many_rows then
      raise_application_error(-20001, 'Tipo de Movimiento duplicado');
    
  end pp_mostrar_tipo_movi;


Procedure pp_muestra_clpr(p_ind_clpr          in varchar2,
                          p_clpr_codi         in number,
                          p_clpr_desc         out varchar2,
                          p_clpr_codi_alte    out varchar2,
                          p_clpr_tele         out varchar2,
                          p_clpr_dire         out varchar2,
                          p_clpr_ruc          out varchar2,
                          p_clpr_prov_retener out varchar2) is
begin
  select clpr_desc,
         clpr_codi_alte,
         rtrim(ltrim(substr(clpr_tele, 1, 50))) Tele,
         rtrim(ltrim(substr(clpr_dire, 1, 100))) dire,
         rtrim(ltrim(substr(clpr_ruc, 1, 20))) Ruc,
         nvl(clpr_prov_retener, 'NO')
    into p_clpr_desc,
         p_clpr_codi_alte,
         p_clpr_tele,
         p_clpr_dire,
         p_clpr_ruc,
         p_clpr_prov_retener
    from come_clie_prov
   where clpr_codi = p_clpr_codi
     and clpr_indi_clie_prov = p_ind_clpr;
APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name => 'DETALLE');
Exception
  when no_data_found then
    if p_ind_clpr = 'P' then
      raise_application_error(-20001, 'Proveedor inexistente!');
    else
      raise_application_error(-20001, 'Cliente inexistente!');
    end if;
    
      
end pp_muestra_clpr;
  
  
procedure pp_valida_fech(p_fech in date) is
begin
  if p_fech not between parameter.p_fech_inic and parameter.p_fech_fini then
    raise_application_error(-20001,
                            'La fecha del movimiento debe estar comprendida entre..' ||
                            to_char(parameter.p_fech_inic, 'dd-mm-yyyy') ||
                            ' y ' ||
                            to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
  end if;

end pp_valida_fech;

procedure pp_carga_secu(p_secu_nume_cobr out number,
                        p_movi_timo_codi in number) is
begin
  --raise_application_error(-20001,p_movi_timo_codi);
  select nvl(max(movi_nume), 0) + 1
    into p_secu_nume_cobr
    from come_movi
   where movi_timo_codi = p_movi_timo_codi;

Exception
  When no_data_found then
    raise_application_error(-20001,
                            'Codigo de Secuencia de Cobranzas inexistente');
  
end pp_carga_secu;


procedure pp_validar_numero_documento(p_movi_nume      in number,
                                      p_movi_timo_codi in number) is
  v_count number;
begin
  select count(*)
    into v_count
    from come_movi
   where movi_nume = p_movi_nume
     and movi_timo_codi = p_movi_timo_codi;

  if v_count > 0 then
    raise_application_error(-20001,
                            'El numero de comprobante ya existe. Asigne otro numero al Documento.');
  end if;

end pp_validar_numero_documento;

procedure pp_busca_tasa_mmee(p_mone_codi      in number,
                             p_mone_coti      out number,
                             p_tica_codi      in number,
                             p_movi_fech_emis in date) is
begin

  if parameter.p_codi_mone_mmnn = p_mone_codi then
    p_mone_coti := 1;
  else
    select coti_tasa
      into p_mone_coti
      from come_coti
     where coti_mone = p_mone_codi
       and coti_tica_codi = p_tica_codi
       and coti_fech = p_movi_fech_emis;
  end if;

Exception
  When no_data_found then
  
    raise_application_error(-20001,
                            'Cotizacion Inexistente para la moneda extranjera');
  
end pp_busca_tasa_mmee;
 
procedure pp_busca_tasa_mone(p_mone_codi      in number,
                             p_mone_coti      out number,
                             p_tica_codi      in number,
                             p_movi_fech_emis in date) is
begin

  if parameter.p_codi_mone_mmnn = p_mone_codi then
    p_mone_coti := 1;
  else
    select coti_tasa
      into p_mone_coti
      from come_coti
     where coti_mone = p_mone_codi
       and coti_tica_codi = p_tica_codi
       and coti_fech = p_movi_fech_emis;
  end if;

Exception
  When no_data_found then
    raise_application_error(-20001,
                            'Cotizacion Inexistente para la fecha del documento');
  
end pp_busca_tasa_mone;

procedure pp_buscar_moneda(p_movi_mone_codi      in number,
                           p_movi_fech_emis      in date,
                           p_tica_codi           in number,
                           p_movi_mone_desc      out varchar2,
                           p_movi_mone_desc_abre out varchar2,
                           p_movi_mone_cant_deci out varchar2,
                           p_movi_tasa_mone      out varchar2,
                           p_movi_tasa_mmee      out varchar2,
                           p_indi_carg_deta      out varchar) is

begin

  general_skn.pl_muestra_come_mone(p_movi_mone_codi,
                                   p_movi_mone_desc,
                                   p_movi_mone_desc_abre,
                                   p_movi_mone_cant_deci);

  pp_busca_tasa_mone(p_movi_mone_codi,
                     p_movi_tasa_mone,
                     p_tica_codi,
                     p_movi_fech_emis);
 /* pp_busca_tasa_mmee(parameter.p_codi_mone_mmee,
                     p_movi_tasa_mmee,
                     p_tica_codi,
                     p_movi_fech_emis);*/
  p_indi_carg_deta := 'N';

end pp_buscar_moneda;


procedure pp_cargar_bloque_det(p_movi_clpr_codi in varchar2,
                               p_movi_mone_codi in varchar2,
                               p_movi_fech_emis in varchar2,
                               p_movi_nume      in varchar2,
                               p_movi_tasa_mone in varchar2) is

  cursor c_vto is
    select movi_mone_codi,
           movi_nume,
           movi_fech_emis,
           movi_indi_tipo_pres,
           cupe_fech_venc,
           cupe_impo_mone,
           cupe_sald_mone,
           movi_codi,
           movi_tasa_mone,
           cupe_impo_capi_mone,
           cupe_impo_inte_mone,
           cupe_nume_cuot,
           cupe_sald_capi_mone,
           cupe_sald_inte_mone,
           movi_clpr_codi
    
      from come_movi, come_movi_cuot_pres a
     where movi_codi = cupe_movi_codi
       and movi_clpr_codi = p_movi_clpr_codi
       and cupe_sald_mone > 0
       and movi_mone_codi = p_movi_mone_codi
     order by cupe_fech_venc, movi_fech_emis, movi_nume;

  v_count  number := 0;
  v_count2 number := 0;
  v_indi   varchar2(1);
  v_existe number := 0;
begin
  

  if p_movi_clpr_codi is null then
    raise_application_error(-20001, 'Debe ingresar El codigo del CLPRo');
  end if;

  if p_movi_fech_emis is null then
    raise_application_error(-20001, 'Debe ingresar la fecha del documento');
  end if;

  if p_movi_nume is null then
    raise_application_error(-20001,
                            'Debe ingresar el n?mero del documento');
  end if;

  if p_movi_tasa_mone is null then
    raise_application_error(-20001,
                            'Debe ingresar la cotizacion del documento');
  end if;

  APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name => 'DETALLE');

  v_indi := parameter.p_indi_calc_mora_mult; --aca cargue el parametro en una variable char

  if nvl(parameter.p_indi_carg_deta, 'N') = 'N' then
 
    for x in c_vto loop
    
      apex_collection.add_member(p_collection_name => 'DETALLE',
                                 p_c001            => x.movi_nume,
                                 p_c002            => x.movi_mone_codi,
                                 p_c003            => x.movi_fech_emis,
                                 p_c004            => x.cupe_fech_venc,
                                 p_c005            => x.cupe_impo_mone,
                                 p_c006            => x.cupe_sald_mone,
                                 p_c007            => x.movi_codi,
                                 p_c008            => x.movi_tasa_mone,
                                 p_c009            => x.movi_clpr_codi,
                                 p_c010            => null, ---no se usa
                                 p_c011            => null,
                                 p_c012            => null,
                                 p_c013            => null,
                                 p_c014            => x.cupe_sald_mone,
                                 p_c015            => x.movi_indi_tipo_pres,
                                 p_c016            => x.cupe_impo_capi_mone, ---no se usa
                                 p_c017            => x.cupe_impo_inte_mone,
                                 p_c018            => x.cupe_nume_cuot,
                                 p_c019            => x.cupe_sald_capi_mone,
                                 p_c020            => x.cupe_sald_inte_mone
                                 ---no se usa
                                 );
    
    end loop;
    
    select count(seq_id)
      into v_existe
      from apex_collections
     where collection_name = 'DETALLE';
  
    if v_existe  = 0 then
       raise_application_error(-20001,
                               'El Proveedor no posee comprobantes pendientes!');
    
    end if;
    parameter.p_indi_carg_deta := 'S';
  
  end if;

end pp_cargar_bloque_det;



procedure pp_distribuir_pagos(p_importe_pago          in number,
                              p_cupe_sald_inte_mone   in number,
                              p_s_impo_pago_inte      out number,
                              p_movi_indi_tipo_pres   in number,
                              p_s_impo_inte_doca_rend out number,
                              p_cupe_sald_capi_mone   in number,
                              p_s_impo_pago_capi      out number) is

  v_saldo number;

begin

  v_saldo := p_importe_pago;

  if v_saldo >= p_cupe_sald_inte_mone then
  
    p_s_impo_pago_inte := nvl(p_cupe_sald_inte_mone, 0);
    v_saldo            := v_saldo - p_s_impo_pago_inte;
  
    if p_movi_indi_tipo_pres = '02' then
      p_s_impo_inte_doca_rend := p_s_impo_pago_inte;
    end if;
  
  else
    p_s_impo_pago_inte := v_saldo;
    v_saldo            := 0;
  end if;

  if v_saldo >= p_cupe_sald_capi_mone then
    p_s_impo_pago_capi := nvl(p_cupe_sald_capi_mone, 0);
    v_saldo            := v_saldo - p_s_impo_pago_capi;
  else
    p_s_impo_pago_capi := v_saldo;
    v_saldo            := 0;
  end if;

end pp_distribuir_pagos;


procedure pp_editar_indi(p_seq_id in number,
                         p_valor  in varchar2,
                         p_s_dife out varchar2) is

  v_saldo          number;
  v_impo_pago      number;
  v_movi_fech_emis date;

  v_saldo_tot number;
  v_saldo_dif number;
  v_cupe_sald_capi_mone number; 
  v_cupe_sald_inte_mone number;
  v_movi_indi_tipo_pres varchar2(5);
  
  o_s_impo_pago_inte      number;               
  o_s_impo_inte_doca_rend number;
  o_s_impo_pago_capi        number; 
begin

  --raise_application_error(-20001,'adfa');

  apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                          p_seq             => p_seq_id,
                                          p_attr_number     => 12,
                                          p_attr_value      => p_valor);

  if p_valor = 'N' then
    select to_number(c006)
      into v_saldo
      from apex_collections
     where collection_name = 'DETALLE'
       and seq_id = p_seq_id;
       
        o_s_impo_pago_inte      :=0;          
        o_s_impo_inte_doca_rend :=0;
        o_s_impo_pago_capi      :=0;  
  else
    select to_number(c006), to_date(c003),  to_number(c019)   cupe_sald_capi_mone, to_number(c020)   cupe_sald_inte_mone,  c015   movi_indi_tipo_pres
      into v_saldo, v_movi_fech_emis, v_cupe_sald_capi_mone, v_cupe_sald_inte_mone, v_movi_indi_tipo_pres
      from apex_collections
     where collection_name = 'DETALLE'
       and seq_id = p_seq_id;
  
    if nvl(v('P130_MOVI_EXEN_MONE'), 0) <> 0 then
      if v('P130_S_DIFE') < 0 then
        raise_application_error(-20001,
                                'El importe de la distribucion de pagos es mayor al importe del recibo');
      end if;
    
      if v_saldo <= v('P130_S_DIFE') then
        v_impo_pago := v_saldo;
      else
        v_impo_pago := v('P130_S_DIFE');
      end if;
    end if;
  
    if v_movi_fech_emis > to_Date(v('P130_MOVI_FECH_EMIS')) then
      raise_application_error(-20001, 'La fecha de pago debe ser mayor o igual a la factura a pagar');
    end if;
   pp_distribuir_pagos(p_importe_pago          => v_impo_pago,
                       p_cupe_sald_inte_mone   => v_cupe_sald_inte_mone ,
                       p_s_impo_pago_inte      => o_s_impo_pago_inte,
                       p_movi_indi_tipo_pres   => v_movi_indi_tipo_pres,
                       p_s_impo_inte_doca_rend => o_s_impo_inte_doca_rend,
                       p_cupe_sald_capi_mone   => v_cupe_sald_capi_mone,
                       p_s_impo_pago_capi      => o_s_impo_pago_capi) ;  
                                           
  end if;

  apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                          p_seq             => p_seq_id,
                                          p_attr_number     => 13,
                                          p_attr_value      => v_impo_pago);

  apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                          p_seq             => p_seq_id,
                                          p_attr_number     => 14,
                                          p_attr_value      => nvl(v_saldo,0) -nvl(v_impo_pago,0));
            
   
                                              
                                                               
    apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                          p_seq             => p_seq_id,
                                          p_attr_number     => 21,
                                          p_attr_value      => o_s_impo_pago_inte);
                                                                          
  
   apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                          p_seq             => p_seq_id,
                                          p_attr_number     => 22,
                                          p_attr_value      => o_s_impo_pago_capi);
                                                               
   apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                          p_seq             => p_seq_id,
                                          p_attr_number     => 23,
                                          p_attr_value      => o_s_impo_inte_doca_rend);
                                                               

  select nvl(sum(c013), 0)
    into v_saldo_tot
    from apex_collections
   where collection_name = 'DETALLE';

   v_saldo_dif := nvl(v('P130_MOVI_EXEN_MONE'), 0) - (v_saldo_tot+ nvl(v('P130_S_TOTAL_NETO'),0));

  p_s_dife := v_saldo_dif;
  
end pp_editar_indi;


procedure pp_editar_importe(p_seq_id in varchar2,
                            p_valor  in varchar2,
                            p_S_DIFE out varchar2) is

  v_indica    varchar2(20);
  v_saldo     varchar2(20);
  v_seq_id    varchar2(20);
  v_Saldo_cuo number;

  v_saldo_tot number;
  v_saldo_dif number;
  v_cupe_sald_capi_mone number; 
  v_cupe_sald_inte_mone number;
  v_movi_indi_tipo_pres varchar2(5);
  o_s_impo_pago_inte        number;               
  o_s_impo_inte_doca_rend   number;
  o_s_impo_pago_capi        number; 
  
begin
  
  v_seq_id := replace(p_seq_id, 'f02_');

  select c012, to_number(c006),to_number(c019)   cupe_sald_capi_mone, to_number(c020)   cupe_sald_inte_mone,  c015   movi_indi_tipo_pres
    into v_indica, v_Saldo_cuo, v_cupe_sald_capi_mone, v_cupe_sald_inte_mone, v_movi_indi_tipo_pres
    from apex_collections
   where collection_name = 'DETALLE'
     and seq_id = v_seq_id;
                           
  if v_indica = 'S' then
    v_saldo := p_valor;
     if nvl(v_saldo,0) <=0 then
    
     raise_application_error(-20001,'El importe debe ser mayor a cero!.');
  end if;
     pp_distribuir_pagos(p_importe_pago          => v_saldo,
                         p_cupe_sald_inte_mone   => v_cupe_sald_inte_mone ,
                         p_s_impo_pago_inte      => o_s_impo_pago_inte,
                         p_movi_indi_tipo_pres   => v_movi_indi_tipo_pres,
                         p_s_impo_inte_doca_rend => o_s_impo_inte_doca_rend,
                         p_cupe_sald_capi_mone   => v_cupe_sald_capi_mone,
                         p_s_impo_pago_capi      => o_s_impo_pago_capi) ;  
  else
    v_saldo := 0;
    o_s_impo_pago_inte      :=0;          
    o_s_impo_inte_doca_rend :=0;
    o_s_impo_pago_capi      :=0;     
      
  end if;
   if nvl(v_saldo,0) > nvl(v_Saldo_cuo,0) then
    
     raise_application_error(-20001,'El importe de pago no puede sobrepasar el saldo de la cuota!.');
  end if;
   
 
  
  APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'DETALLE',
                                          P_SEQ             => v_seq_id,
                                          P_ATTR_NUMBER     => 13,
                                          P_ATTR_VALUE      => v_saldo);

  APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'DETALLE',
                                          P_SEQ             => v_seq_id,
                                          P_ATTR_NUMBER     => 14,
                                          P_ATTR_VALUE      => nvl(v_Saldo_cuo,0) -nvl(v_saldo,0));
   
  
    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'DETALLE',
                                          P_SEQ             => v_seq_id,
                                          P_ATTR_NUMBER     => 14,
                                          P_ATTR_VALUE      => nvl(v_Saldo_cuo,0) -nvl(v_saldo,0));
                                                                                                                             
      apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                          p_seq             => v_seq_id,
                                          p_attr_number     => 21,
                                          p_attr_value      => o_s_impo_pago_inte);
                                                                               
 
   apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                          p_seq             => v_seq_id,
                                          p_attr_number     => 22,
                                          p_attr_value      => o_s_impo_pago_capi);
           
                                      
                                                                    
   apex_collection.update_member_attribute(p_collection_name => 'DETALLE',
                                          p_seq             => v_seq_id,
                                          p_attr_number     => 23,
                                          p_attr_value      => o_s_impo_inte_doca_rend);
 
  select nvl(sum(c013), 0)
    into v_saldo_tot
    from apex_collections
   where collection_name = 'DETALLE';

  v_saldo_dif := nvl(v('P130_MOVI_EXEN_MONE'), 0) - (v_saldo_tot+ nvl(v('P130_S_TOTAL_NETO'),0));

  p_s_dife := v_saldo_dif;

end pp_editar_importe;
 

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
                              p_movi_impo_mone_ii        in number,
                              p_movi_impo_mmnn_ii        in number,
                              p_movi_grav10_ii_mone      in number,
                              p_movi_grav5_ii_mone       in number,
                              p_movi_grav10_ii_mmnn      in number,
                              p_movi_grav5_ii_mmnn       in number,
                              p_movi_grav10_mone         in number,
                              p_movi_grav5_mone          in number,
                              p_movi_grav10_mmnn         in number,
                              p_movi_grav5_mmnn          in number,
                              p_movi_iva10_mone          in number,
                              p_movi_iva5_mone           in number,
                              p_movi_iva10_mmnn          in number,
                              p_movi_iva5_mmnn           in number,
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
                              p_movi_nume_timb           in varchar2,
                              p_movi_fech_oper           in date,
                              p_movi_fech_venc_timb      in date,
                              p_movi_codi_rete           in number,
                              p_movi_excl_cont           in varchar2,
                              p_movi_impo_deto_mone      in number) is
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
     movi_iva5_mmnn,
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
     movi_nume_timb,
     movi_fech_oper,
     movi_fech_venc_timb,
     movi_codi_rete,
     movi_excl_cont,
     movi_impo_deto_mone)
  values
    (
     
     p_movi_codi,
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
     sysdate,
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
     p_movi_grav5_ii_mone,
     p_movi_grav10_ii_mmnn,
     p_movi_grav5_ii_mmnn,
     p_movi_grav10_mone,
     p_movi_grav5_mone,
     p_movi_grav10_mmnn,
     p_movi_grav5_mmnn,
     p_movi_iva10_mone,
     p_movi_iva5_mone,
     p_movi_iva10_mmnn,
     p_movi_iva5_mmnn,
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
     parameter.p_codi_base,
     p_movi_nume_timb,
     p_movi_fech_oper,
     p_movi_fech_venc_timb,
     p_movi_codi_rete,
     p_movi_excl_cont,
     p_movi_impo_deto_mone);

end pp_insert_come_movi;



-------------------------------------------------------------------
procedure pp_insertar_canc_pres is
begin

  for bdet in g_cur_bdet loop
    if bdet.impo_pago > 0 then
      --bdet.s_marca = upper('x') then
      if bcab.sum_s_imp_pago > 0 then
        insert into come_movi_cuot_pres_canc
          (canc_movi_codi,
           canc_cupe_movi_codi,
           canc_cupe_fech_venc,
           canc_fech_pago,
           canc_impo_mone,
           canc_impo_mmnn,
           canc_impo_mmee,
           canc_base,
           canc_impo_dife_camb,
           canc_impo_capi_mone,
           canc_impo_capi_mmnn,
           canc_impo_inte_mone,
           canc_impo_inte_mmnn)
        values
          (bcab.movi_codi,
           bdet.cupe_movi_codi,
           bdet.cupe_fech_venc,
           bcab.movi_fech_emis,
           bdet.impo_pago,
           round((bdet.impo_pago * bcab.movi_tasa_mone), 0),
           0,
           parameter.p_codi_base,
           round(((nvl(bcab.movi_tasa_mone, 0) -
                 nvl(bdet.cupe_tasa_mone, 0)) * bdet.impo_pago),
                 0),
           bdet.s_impo_pago_capi,
           round((bdet.s_impo_pago_capi * bcab.movi_tasa_mone), 0),
           bdet.s_impo_pago_inte,
           round((bdet.s_impo_pago_inte * bcab.movi_tasa_mone), 0));
      end if;
    end if;
  
  end loop;
end pp_insertar_canc_pres;


procedure pp_actualiza_come_movi is
  v_movi_codi           number;
  v_movi_timo_codi      number;
  v_movi_clpr_codi      number;
  v_movi_sucu_codi_orig number;
  v_movi_depo_codi_orig number;
  v_movi_sucu_codi_dest number;
  v_movi_depo_codi_dest number;
  v_movi_oper_codi      number;
  v_movi_cuen_codi      number;
  v_movi_mone_codi      number;
  v_movi_nume           number;
  v_movi_fech_emis      date;
  v_movi_fech_grab      date;
  v_movi_user           varchar2(20);
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

  v_movi_impo_mone_ii   number;
  v_movi_impo_mmnn_ii   number;
  v_movi_grav10_ii_mone number;
  v_movi_grav5_ii_mone  number;
  v_movi_grav10_ii_mmnn number;
  v_movi_grav5_ii_mmnn  number;
  v_movi_grav10_mone    number;
  v_movi_grav5_mone     number;
  v_movi_grav10_mmnn    number;
  v_movi_grav5_mmnn     number;
  v_movi_iva10_mone     number;
  v_movi_iva5_mone      number;
  v_movi_iva10_mmnn     number;
  v_movi_iva5_mmnn      number;

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
  v_movi_nume_timb           varchar2(20);
  v_movi_fech_oper           date;
  v_movi_fech_venc_timb      date;
  v_movi_codi_rete           number;
  v_movi_excl_cont           varchar2(1);
  v_movi_impo_deto_mone      number;

begin

  --- asignar valores....
  bcab.movi_codi      := fa_sec_come_movi;
  bcab.movi_oper_codi := null;
  bcab.movi_fech_grab := sysdate;
  bcab.movi_user      := gen_user;

  v_movi_codi           := bcab.movi_codi;
  v_movi_timo_codi      := bcab.movi_timo_codi;
  v_movi_clpr_codi      := bcab.movi_clpr_codi;
  v_movi_sucu_codi_orig := bcab.movi_sucu_codi_orig;
  v_movi_depo_codi_orig := null;
  v_movi_sucu_codi_dest := null;
  v_movi_depo_codi_dest := null;
  v_movi_oper_codi      := null;
  v_movi_cuen_codi      := null; --bcab.movi_cuen_codi;
  v_movi_mone_codi      := bcab.movi_mone_codi;
  v_movi_nume           := bcab.movi_nume;
  v_movi_fech_emis      := bcab.movi_fech_emis;
  v_movi_fech_oper      := bcab.movi_fech_emis;
  v_movi_fech_grab      := bcab.movi_fech_grab;
  v_movi_user           := bcab.movi_user;
  v_movi_codi_padr      := null;
  v_movi_tasa_mone      := bcab.movi_tasa_mone;
  v_movi_tasa_mmee      := null;
  v_movi_grav_mmnn      := 0;
  v_movi_exen_mmnn      := bcab.movi_exen_mmnn;
  v_movi_iva_mmnn       := 0;
  v_movi_grav_mmee      := 0;
  v_movi_exen_mmee      := 0;
  v_movi_iva_mmee       := 0;
  v_movi_grav_mone      := 0;
  v_movi_exen_mone      := bcab.movi_exen_mone;
  v_movi_iva_mone       := 0;

  v_movi_impo_mone_ii   := bcab.movi_exen_mone;
  v_movi_impo_mmnn_ii   := bcab.movi_exen_mmnn;
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

  v_movi_obse                := bcab.movi_obse;
  v_movi_sald_mmnn           := 0;
  v_movi_sald_mmee           := 0;
  v_movi_sald_mone           := 0;
  v_movi_stoc_suma_rest      := null;
  v_movi_clpr_dire           := bcab.clpr_dire;
  v_movi_clpr_tele           := bcab.clpr_tele;
  v_movi_clpr_ruc            := bcab.clpr_ruc;
  v_movi_clpr_desc           := bcab.movi_clpr_desc;
  v_movi_emit_reci           := bcab.movi_emit_reci;
  v_movi_afec_sald           := bcab.movi_afec_sald;
  v_movi_dbcr                := bcab.movi_dbcr;
  v_movi_stoc_afec_cost_prom := null;
  v_movi_empr_codi           := bcab.movi_empr_codi;
  v_movi_clave_orig          := null;
  v_movi_clave_orig_padr     := null;
  v_movi_indi_iva_incl       := null;
  v_movi_empl_codi           := null;
  v_movi_nume_timb           := null;
  v_movi_fech_venc_timb      := null;
  v_movi_codi_rete           := null; --se actualizara cuando se grabe la retencion
  v_movi_impo_deto_mone      := nvl(bcab.sum_s_impo_inte_doca_rend, 0) +
                                nvl(bcab.s_impo_mora, 0);

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
                      v_movi_iva5_mmnn,
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
                      v_movi_nume_timb,
                      v_movi_fech_oper,
                      v_movi_fech_venc_timb,
                      v_movi_codi_rete,
                      v_movi_excl_cont,
                      v_movi_impo_deto_mone);

end pp_actualiza_come_movi;



procedure pp_valida_importes is
begin           	
                           
	if nvl(bcab.s_impo_cheq,0) + nvl(bcab.s_impo_efec,0) <> nvl(bcab.movi_exen_mone,0) then
		raise_application_error(-20001,'El importe total de cheques + el importe en efectivo debe ser igual al importe neto del Prestamo');
	end if;
 
  /* if :bfp_cab.s_impo_sald <> 0 then
    pl_me('Existe una diferencia en montos. Saldo distinto a 0(cero).');
  end if;*/
end;

procedure pp_set_variables is
  
begin
  
  bcab.p_emit_reci              := v('P130_P_EMIT_RECI');
  bcab.p_cant_deci_mmnn         := v('P130_P_CANT_DECI_MMNN');
  bcab.buscar                   := v('P130_BUSCAR');
  bcab.p_clie_prov              := v('P130_P_CLIE_PROV');
    
  bcab.movi_sucu_codi_orig      := v('P130_MOVI_SUCU_CODI_ORIG');
  bcab.indi_carg_deta           := v('P130_INDI_CARG_DETA');
  bcab.movi_sucu_desc_orig      := v('P130_MOVI_SUCU_DESC_ORIG');
  bcab.movi_mone_cant_deci      := v('P130_MOVI_MONE_CANT_DECI');
 
  bcab.movi_clpr_codi           := v('P130_MOVI_CLPR_CODI');
   
  bcab.s_clpr_codi_alte         := v('P130_S_CLPR_CODI_ALTE');
  
  bcab.movi_codi                := v('P130_MOVI_CODI');

  bcab.movi_clpr_desc           := v('P130_MOVI_CLPR_DESC');
  bcab.movi_codi_adel           := v('P130_MOVI_CODI_ADEL');
  bcab.movi_fech_emis           := v('P130_MOVI_FECH_EMIS');
  bcab.movi_timo_codi           := v('P130_MOVI_TIMO_CODI');
  bcab.movi_fech_oper           := v('P130_MOVI_FECH_OPER');
  bcab.movi_timo_desc           := v('P130_MOVI_TIMO_DESC');
  bcab.movi_nume                := v('P130_MOVI_NUME');
   
  bcab.movi_timo_desc_abre      := v('P130_MOVI_TIMO_DESC_ABRE');
  bcab.movi_tico_codi           := v('P130_MOVI_TICO_CODI');
  bcab.movi_mone_codi           := v('P130_MOVI_MONE_CODI');
  bcab.timo_indi_apli_adel_fopa := v('P130_TIMO_INDI_APLI_ADEL_FOPA');
  bcab.tica_codi                := v('P130_TICA_CODI');
  bcab.timo_tica_codi           := v('P130_TIMO_TICA_CODI');
  bcab.s_dife                   := nvl(v('P130_S_DIFE'),0);
 
  bcab.timo_dbcr_caja           := v('P130_TIMO_DBCR_CAJA');
  bcab.movi_tare_codi           := v('P130_MOVI_TARE_CODI');
      
  bcab.movi_mone_desc_abre      := v('P130_MOVI_MONE_DESC_ABRE');
--  raise_application_error(-20001,'el importe'|| v('p130_movi_mone_desc_abre'));
  bcab.clpr_prov_retener        := v('P130_CLPR_PROV_RETENER');
  bcab.tica_desc                := v('P130_TICA_DESC');

  bcab.movi_clpr_ruc            := v('P130_MOVI_CLPR_RUC');
  bcab.movi_clpr_tele           := v('P130_MOVI_CLPR_TELE');
  bcab.movi_clpr_dire           := v('P130_MOVI_CLPR_DIRE');
  bcab.movi_mone_desc           := v('P130_MOVI_MONE_DESC');
  bcab.movi_tasa_mone           := nvl(v('P130_MOVI_TASA_MONE'),0);
  bcab.movi_cuen_nume           := v('P130_MOVI_CUEN_NUME');
  bcab.movi_tasa_mmee           := nvl(v('P130_MOVI_TASA_MMEE'),0);
  bcab.movi_fech_grab           := v('P130_MOVI_FECH_GRAB');
  bcab.s_impo_efec              := v('P130_S_IMPO_EFEC');
  bcab.movi_grav_mmnn           := nvl(v('P130_MOVI_GRAV_MMNN'),0);
  bcab.movi_iva_mmnn            := nvl(v('P130_MOVI_IVA_MMNN'),0);
  bcab.movi_exen_mone           := nvl(v('P130_MOVI_EXEN_MONE'),0);
  bcab.movi_grav_mmee           := nvl(v('P130_MOVI_GRAV_MMEE'),0);
  bcab.movi_exen_mmnn           := nvl(v('P130_MOVI_EXEN_MMNN'),0);
  bcab.movi_exen_mmee           := nvl(v('P130_MOVI_EXEN_MMEE'),0);
  bcab.s_impo_cheq              := nvl(v('P130_S_IMPO_CHEQ'),0);
  bcab.movi_iva_mmee            := nvl(v('P130_MOVI_IVA_MMEE'),0);
  bcab.movi_grav_mone           := nvl(v('P130_MOVI_GRAV_MONE'),0);
  bcab.movi_obse                := v('P130_MOVI_OBSE');
  bcab.movi_iva_mone            := nvl(v('P130_MOVI_IVA_MONE'),0);
  bcab.movi_sald_mone           := nvl(v('P130_MOVI_SALD_MONE'),0);
  bcab.movi_sald_mmee           := nvl(v('P130_MOVI_SALD_MMEE'),0);
  bcab.movi_sald_mmnn           := nvl(v('P130_MOVI_SALD_MMNN'),0);
  bcab.movi_afec_sald           := v('P130_MOVI_AFEC_SALD');
  bcab.movi_dbcr                := v('P130_MOVI_DBCR');
  bcab.movi_user                := v('P130_MOVI_USER');
  bcab.movi_emit_reci           := v('P130_MOVI_EMIT_RECI');
  bcab.clpr_indi_clie_prov      := v('P130_CLPR_INDI_CLIE_PROV');
  bcab.s_impo_tarj              := v('P130_S_IMPO_TARJ');
  bcab.s_impo_adel              := v('P130_S_IMPO_ADEL');
  bcab.movi_empr_codi           := parameter.p_empr_codi;
  bcab.s_total_neto             := v('P130_S_TOTAL_NETO');
  bcab.s_impo_mora              := v('P130_S_IMPO_MORA');  
  bcab.clpr_dire                := v('P130_MOVI_CLPR_DIRE');
  bcab.clpr_tele                := v('P130_MOVI_CLPR_TELE');
  bcab.clpr_ruc                 := v('P130_MOVI_CLPR_RUC');
end pp_set_variables;

procedure pp_actualiza_registro is

  v_sum_s_impo_inte_doca_rend number;
  v_clie_dife                 number;
  v_mone_dife                 number;
  v_cant_elegida              number;
  v_total                     number;
  v_impo_pago                 number;
begin

  pp_set_variables;

  pp_valida_importes;

  if bcab.movi_fech_emis is null then
    raise_application_error(-20001, 'Debe ingresar la fecha del recibo!.');
  end if;

  if bcab.movi_sucu_codi_orig is null then
    raise_application_error(-20001, 'La sucursal no puede quedar vacia');
  end if;
  if bcab.movi_fech_emis is null then
    raise_application_error(-20001, 'La fecha no puede quedar vacia');
  end if;

  if bcab.movi_nume is null then
    raise_application_error(-20001,
                            'El nro. documento no puede quedar vacio');
  end if;
  if bcab.movi_mone_codi is null then
    raise_application_error(-20001, 'La moneda no puede quedar vacia');
  end if;

  if bcab.movi_tasa_mone is null then
    raise_application_error(-20001, 'La tasa no puede quedar vacia');
  end if;

  if bcab.movi_exen_mone is null then
    raise_application_error(-20001, ' El importe no puede quedar vacio');
  end if;

  if bcab.movi_exen_mone <= 0then
   raise_application_error(-20001, ' El importe debe ser mayor a 0') ; end if ;
  

   if bcab.s_dife <> 0 then
    raise_application_error(-20001,
                            'Existe diferencia entre el importe del recibo y el detalle de cuotas canceladas');
  end if;

  select nvl(sum(case
                   when bcab.movi_clpr_codi <> c009 then
                    1
                   else
                    0
                 end),
             0) clie_dife,
         nvl(count(c012), 0) cant_elegida,
         nvl(sum(case
                   when bcab.movi_mone_codi <> c002 then
                    1
                   else
                    0
                 end),
             0) mone_dife,
         nvl(sum(c013), 0),
         sum(c025)
  
    into v_clie_dife,
         v_cant_elegida,
         v_mone_dife,
         v_impo_pago,
         v_sum_s_impo_inte_doca_rend
    from apex_collections
   where collection_name = 'DETALLE'
     and c012 = 'S';


  bcab.sum_s_imp_pago := v_impo_pago;
  v_total         := bcab.s_impo_efec + bcab.s_impo_cheq + bcab.s_impo_adel;

  bcab.sum_impo_pago := v_total;

  bcab.sum_s_impo_inte_doca_rend := v_sum_s_impo_inte_doca_rend;
  if v_clie_dife > 0 then
    raise_application_error(-20001,
                            'Atencion ! El codigo de proveedor ha cambiado, debe cancelar la operacion !!');
  end if;

  if v_mone_dife > 0 then
    raise_application_error(-20001,
                            'La moneda de las cuotas a cancelar no coincide con la moneda seleccionada en la cabecera');
  end if;

  if v_impo_pago <= 0 then
    raise_application_error(-20001,
                            'El pago debe asignarse por lo menos a un documento!');
  end if;

  if v_total <= 0 then
    raise_application_error(-20001,
                            'Tiene que cargar el importe del pago.');
  end if;

  ---verifica saldo distinto de cero.
  if (bcab.movi_exen_mone - v_total) <> 0 then
    raise_application_error(-20001,
                            'Existe una diferencia en montos. Saldo distinto a 0(cero).');
  end if;
  ---

  --------------pp_valida_campo_marcado
  if v_cant_elegida <= 0 then
    raise_application_error(-20001,
                            'No existe comprobante marcado para su cancelacion. Favor, seleccione el(los) documento(s) a cancelar.!');
  end if;
  ----pp_valida_forma_pago
  if v_total <= 0 then
    raise_application_error(-20001,
                            'No existe Forma de pago para su cancelacion.');
  end if;

  if nvl(bcab.s_total_neto, 0) <> nvl(bcab.movi_exen_mone, 0) then
    raise_application_error(-20001,
                            'Existen diferencias entre el importe del pago y los importes de los documentos asignados!');
  end if;

  if nvl(bcab.s_impo_efec, 0) + nvl(bcab.s_impo_cheq, 0) +
     nvl(bcab.s_impo_adel, 0) <> nvl(bcab.s_total_neto, 0) then
    raise_application_error(-20001,
                            'Existe diferencia entre el importe del recibo y el total en Formas de Pago.');
  end if;

  pp_actualiza_come_movi;
  pp_insertar_canc_pres;
  --pp_actualiza_moimpo;
  pack_fpago.pl_fp_actualiza_moimpo(i_movi_clpr_codi      => bcab.movi_clpr_codi,
                                    i_movi_clpr_desc      => bcab.movi_clpr_desc,
                                    i_movi_clpr_ruc       => bcab.movi_clpr_ruc,
                                    i_movi_codi           => bcab.movi_codi,
                                    i_movi_dbcr           => bcab.movi_dbcr,
                                    i_movi_emit_reci      => bcab.movi_emit_reci,
                                    i_movi_empr_codi      => bcab.movi_empr_codi,
                                    i_movi_fech_emis      => bcab.movi_fech_emis,
                                    i_movi_fech_oper      => bcab.movi_fech_oper,
                                    i_movi_mone_cant_deci => bcab.movi_mone_cant_deci,
                                    i_movi_sucu_codi_orig => bcab.movi_sucu_codi_orig,
                                    i_movi_tasa_mone      => bcab.movi_tasa_mone,
                                    i_movi_timo_codi      => bcab.movi_timo_codi,
                                    i_s_impo_rete         => null, --bcab.s_impo_rete,
                                    i_s_impo_rete_rent    => null --bcab.s_impo_rete_rent
                                    );
  ----***----

  /*if nvl(:bdeta1.sum_s_total_item,0) <> 0 then --TM 5 O 7
    pp_actualiza_come_movi_inte;
    pp_actualiza_moco_inte;
    pp_actualiza_moimpu_inte;
    pp_actualiza_movi_fact_depo('1');
  end if;
  
  if nvl(:bdeta2.sum_s_total_item,0) <> 0 then --TM 5 O 7
    pp_actualiza_come_movi_gast;
    pp_actualiza_moco_gast;
    pp_actualiza_moimpu_gast;
    pp_actualiza_movi_fact_depo('2');
  end if; */

  ----***----

  ----eeste pp_llama_reporte;
 pp_llama_reporte;
end pp_actualiza_registro;

 procedure pp_llama_reporte is
    nombre       varchar2(50);
    parametros   varchar2(50);
    contenedores clob;
  begin
  
    nombre       := 'I020229op';
    contenedores := 'p_movi_codi';
    parametros   := bcab.movi_codi;
  
    delete from come_parametros_report where usuario = gen_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (parametros, gen_user, nombre, 'pdf', contenedores);
  
  end pp_llama_reporte;
  
  
end I020229;
