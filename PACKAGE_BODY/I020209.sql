
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020209" is

  type r_parameter is record(
    p_inic_orpa_codi      number := null,
    p_codi_prov_espo      number := to_number(general_skn.fl_busca_parametro('p_codi_prov_espo')),
    p_codi_timo_rete_emit number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rete_emit')),
    p_codi_pais_loca      number := to_number(general_skn.fl_busca_parametro('p_codi_pais_loca')),
    p_porc_rete_emit      number := to_number(general_skn.fl_busca_parametro('p_porc_rete_emit')),
    p_codi_timo_reem      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_reem')),
    p_vali_mens_gene_rete varchar2(10) := ltrim(rtrim((general_skn.fl_busca_parametro('p_vali_mens_gene_rete')))),
    p_codi_tipo_empl_vend number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_vend')),
    p_formato_impresion   number,
    p_peco_codi           number:=1,
    p_codi_mone_mmnn      number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')));

  parameter r_parameter;

   p_taax_seq number := 0;
   p_cheque_dato varchar2(32672);

  cursor bdet is
    select seq_id numero_item,
           c001   cheq_serie,
           c002   cheq_nume,
           c003   cheq_cuen_codi,
           c004   cuen_desc,
           c005   cheq_fech_emis,
           c006   cheq_fech_venc,
           c007   cheq_impo_mone,
           c008   cheq_impo_mmnn,
           c009   mone_desc_abre,
           c010   estado,
           c011   cheq_orde,
           c012   cheq_nume_cuen,
           c013   cheq_banc_codi,
           c014   banc_desc,
           c015   cheq_codi,
           c016   cheq_clpr_codi,
           c017   mone_cant_deci,
           c018   cheq_mone_codi,
           c019   cheq_tasa_mone,
           c020   cheq_user,
           c021   cheq_orpa_codi,
           c022   cheq_indi_impr,
           c023   cheq_indi_dia_dife,
           c024   ind_marcado
      from apex_collections a
     where collection_name = 'DET_RETEN';

  procedure pp_cargar_detalle(p_clpr_codi     in number,
                              p_orden_esta    in varchar2,
                              p_orpa_fech_ini in date,
                              p_orpa_fech_fin in date,
                              p_cheq_impr     in varchar2) is
    cursor c_cheq is
      select c.cheq_codi,
             c.cheq_mone_codi,
             m.mone_desc_abre,
             m.mone_cant_deci,
             c.cheq_banc_codi,
             b.banc_desc,
             c.cheq_nume,
             c.cheq_serie,
             c.cheq_fech_emis,
             c.cheq_fech_venc,
             c.cheq_impo_mone,
             c.cheq_impo_mmnn,
             c.cheq_cuen_codi,
             c.cheq_nume_cuen,
             cb.cuen_desc,
             c.cheq_orde,
             c.cheq_clpr_codi,
             c.cheq_tasa_mone,
             c.cheq_user,
             c.cheq_orpa_codi,
             c.cheq_indi_impr,
             nvl(cheq_indi_dia_dife, 'DIFE') cheq_indi_dia_dife,
             decode(nvl(c.cheq_indi_impr, 'N'),
                    'N',
                    'Pendiente ',
                    'Impreso   ') estado
        from come_orde_pago           o,
             come_orde_pago_cheq_deta c,
             come_mone                m,
             come_cuen_banc           cb,
             come_banc                b
       where o.orpa_codi = c.cheq_orpa_codi
         and c.cheq_mone_codi = m.mone_codi
         and c.cheq_cuen_codi = cb.cuen_codi(+)
         and c.cheq_banc_codi = b.banc_codi(+)
         and (c.cheq_clpr_codi = p_clpr_codi or p_clpr_codi is null)
         and (nvl(o.orpa_estado, 'P') = p_orden_esta or p_orden_esta = 'T')
         and (nvl(c.cheq_indi_impr, 'N') = p_cheq_impr or p_cheq_impr = 'T')
         and (o.orpa_fech_emis >= p_orpa_fech_ini or
             p_orpa_fech_ini is null)
         and (o.orpa_fech_emis <= p_orpa_fech_fin or
             p_orpa_fech_fin is null)
       order by c.cheq_serie, c.cheq_nume, c.cheq_fech_emis;
  
    cursor c_cheq_para is
      select c.cheq_codi,
             c.cheq_mone_codi,
             m.mone_desc_abre,
             m.mone_cant_deci,
             c.cheq_banc_codi,
             b.banc_desc,
             c.cheq_nume,
             c.cheq_serie,
             c.cheq_fech_emis,
             c.cheq_fech_venc,
             c.cheq_impo_mone,
             c.cheq_impo_mmnn,
             c.cheq_cuen_codi,
             c.cheq_nume_cuen,
             cb.cuen_desc,
             c.cheq_orde,
             c.cheq_clpr_codi,
             c.cheq_tasa_mone,
             c.cheq_user,
             c.cheq_orpa_codi,
             c.cheq_indi_impr,
             nvl(cheq_indi_dia_dife, 'DIFE') cheq_indi_dia_dife,
             decode(nvl(c.cheq_indi_impr, 'N'),
                    'N',
                    'Pendiente ',
                    'Impreso   ') estado
        from --come_orde_pago           o,
             come_orde_pago_cheq_deta c,
             come_mone                m,
             come_cuen_banc           cb,
             come_banc                b
       where --o.orpa_codi = c.cheq_orpa_codi and
       c.cheq_mone_codi = m.mone_codi
       and c.cheq_cuen_codi = cb.cuen_codi(+)
       and c.cheq_banc_codi = b.banc_codi(+)
       and c.cheq_orpa_codi = parameter.p_inic_orpa_codi
       order by c.cheq_serie, c.cheq_nume, c.cheq_fech_emis;
  begin
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'DET_RETEN');
  
    if parameter.p_inic_orpa_codi is null then
      for k in c_cheq loop
      
        apex_collection.add_member(p_collection_name => 'DET_RETEN',
                                   p_c001            => k.cheq_serie,
                                   p_c002            => k.cheq_nume,
                                   p_c003            => k.cheq_cuen_codi,
                                   p_c004            => k.cuen_desc,
                                   p_c005            => k.cheq_fech_emis,
                                   p_c006            => k.cheq_fech_venc,
                                   p_c007            => k.cheq_impo_mone,
                                   p_c008            => k.cheq_impo_mmnn,
                                   p_c009            => k.mone_desc_abre,
                                   p_c010            => k.estado,
                                   p_c011            => k.cheq_orde,
                                   p_c012            => k.cheq_nume_cuen,
                                   p_c013            => k.cheq_banc_codi,
                                   p_c014            => k.banc_desc,
                                   p_c015            => k.cheq_codi,
                                   p_c016            => k.cheq_clpr_codi,
                                   p_c017            => k.mone_cant_deci,
                                   p_c018            => k.cheq_mone_codi,
                                   p_c019            => k.cheq_tasa_mone,
                                   p_c020            => k.cheq_user,
                                   p_c021            => k.cheq_orpa_codi,
                                   p_c022            => k.cheq_indi_impr,
                                   p_c023            => k.cheq_indi_dia_dife,
                                   p_c024            => 'N');
      
      end loop;
    
    else
    
      for k in c_cheq_para loop
      
        apex_collection.add_member(p_collection_name => 'DET_RETEN',
                                   p_c001            => k.cheq_serie,
                                   p_c002            => k.cheq_nume,
                                   p_c003            => k.cheq_cuen_codi,
                                   p_c004            => k.cuen_desc,
                                   p_c005            => k.cheq_fech_emis,
                                   p_c006            => k.cheq_fech_venc,
                                   p_c007            => k.cheq_impo_mone,
                                   p_c008            => k.cheq_impo_mmnn,
                                   p_c009            => k.mone_desc_abre,
                                   p_c010            => k.estado,
                                   p_c011            => k.cheq_orde,
                                   p_c012            => k.cheq_nume_cuen,
                                   p_c013            => k.cheq_banc_codi,
                                   p_c014            => k.banc_desc,
                                   p_c015            => k.cheq_codi,
                                   p_c016            => k.cheq_clpr_codi,
                                   p_c017            => k.mone_cant_deci,
                                   p_c018            => k.cheq_mone_codi,
                                   p_c019            => k.cheq_tasa_mone,
                                   p_c020            => k.cheq_user,
                                   p_c021            => k.cheq_orpa_codi,
                                   p_c022            => k.cheq_indi_impr,
                                   p_c023            => k.cheq_indi_dia_dife,
                                   p_c024            => 'N');
      
      end loop;
    
      -- :parameter.p_inic_orpa_codi := null;
    end if;
  
  end pp_cargar_detalle;

  procedure pp_actualizar_registro is
    salir exception;
  begin
    /*if fl_confirmar_reg('desea imprimir e ingresar al sistema los cheques marcados?')
    <> upper('confirmar') then
      raise salir;
    end if;*/
  
    --pp_actualizar_cheque_emit;
  
    null;
  
  exception
    when salir then
      null;
  end pp_actualizar_registro;

  procedure pp_actualizar_cheque_emit(p_cheq_codi in number) is
  
  begin
  
    -- loop
    ---  if :bdet.marca = 's' then       
    update come_orde_pago_cheq_deta
       set cheq_indi_impr = 'S'
     where cheq_codi = p_cheq_codi;
  
    /* if parameter.p_indi_impr_cheq_emit = 's' then
      pp_impr_cheq_emit;
    end if;*/
  
    --  end if;
    commit;
  end pp_actualizar_cheque_emit;

  procedure pl_separar_texto_lib(v_texto    in varchar2,
                                 v_tope_sup in number,
                                 v_tope_inf in number,
                                 v_texto_1  out varchar2,
                                 v_texto_2  out varchar2) is
    i     integer;
    v_txt varchar2(500) := v_texto;
  begin
    v_texto_1 := null;
    v_texto_2 := null;
    for i in reverse v_tope_inf .. v_tope_sup loop
      if substr(v_txt, i, 1) = ' ' then
        v_texto_1 := substr(v_txt, 1, i);
        v_texto_2 := substr(v_txt, i + 1, length(v_txt));
        exit;
      end if;
    end loop;
    if v_texto_1 is null then
      v_texto_1 := substr(v_txt, 1, v_tope_sup);
      v_texto_2 := substr(v_txt, v_tope_sup + 1, 500);
    end if;
  
  end pl_separar_texto_lib;
  /*
  procedure pp_actualizar_cheque_emit is
  
  begin
  
    for i in bdet loop
      if i.ind_marcado = 's' then
        update come_orde_pago_cheq_deta
           set cheq_indi_impr = 's'
         where cheq_codi = i.cheq_codi;
      
         if parameter.p_indi_impr_cheq_emit = 's' then
          pp_impr_cheq_emit;
        end if;
      
      end if;
    end loop;
  
  end pp_actualizar_cheque_emit;
  */

  function fl_formato(minomitem in varchar2, micantdecimales in number)
    return varchar2 is
  
    /* esta funcion la hice porque no funciona el get_item_property para
        obtener el format_mask de un item si es que el mismo se estableci?
        program?ticamente. esta funci?n es una peque?a variante de la
        procedure pp_format_mask y a diferencia de ?sta, devuelve el formato en
        vez de establecerlo.
    */
    milongmax      number; /* longitud m?xima */
    midecimales    varchar2(10); /* formato de decimales */
    mienteros      varchar2(20); /* formato de la parte entera */
    minuevoformato varchar2(20); /* nuevo formato de m?scara */
    micantmaxent   number := 0; /* cantidad m?xima de enteros */
    mitotdecimales number := 0;
  begin
  
    midecimales := 'D0000';
    mienteros   := '999G999G999G990';
  
    milongmax := 13; --length('999g999g999g990999g999g999g990');
  
    if micantdecimales > 0 then
      mitotdecimales := micantdecimales + 1; /* +1 por el punto decimal */
    end if;
  
    micantmaxent   := milongmax - micantdecimales - 1;
    minuevoformato := substr(mienteros, 15 - micantmaxent) ||
                      substr(midecimales, 1, mitotdecimales);
    if substr(minuevoformato, 1, 1) = 'G' then
      /* el primer caracter de formato no debe ser 'g' */
      minuevoformato := substr(mienteros, 15 - micantmaxent + 1) ||
                        substr(midecimales, 1, mitotdecimales);
    end if;
    return minuevoformato;
  end fl_formato;

  --imprimir los cheques emitidos directamente al puerto de la impresora
  /*procedure pp_impr_cheq_emit is
    v_impresora      text_io.file_type;
    v_path_impresora varchar2(60);
    v_cheq_codi      number;
    v_form_impr      number;
  begin
    /*go_block('bdet');
    first_record;
    loop*
      
    --  pp_buscar_formato_cheque(:bdet.cheq_cuen_codi, v_form_impr, v_path_impresora, :bdet.cheq_indi_dia_dife);
    
      
      
      if v_form_impr is not null and v_path_impresora is not null then
        
        declare
        impresoranoregistrada exception;
        pragma exception_init(impresoranoregistrada, -302000);
        v_alert number;
        salir exception;
        begin
          v_impresora := text_io.fopen(v_path_impresora, 'w'); --abrir puerto de impresora
          
          
          v_cheq_codi := :bdet.cheq_codi;
          
          pl_imprimir_cheque(v_impresora, v_cheq_codi, v_form_impr);
          
        exception
          when impresoranoregistrada then
            v_path_impresora := null;
            pl_mm('no se podr? imprimir el cheque.la impresora que desea utilizar no se encuentra. verifique los datos de la configuracion de cuentas bancarias');
          when salir then
            null;
        end;
      end if;
      text_io.fclose(v_impresora);--cierra impresora
  exception
    when no_data_found then
      null;
  end pp_impr_cheq_emit;
  */

  /*procedure pp_imprimir_cheques(p_empresa   in number,
                                  p_orden_de  in varchar2,
                                  p_moneda    in number,
                                  p_importe   in number,
                                  p_fecha     in date,
                                  p_cod_banco in number) is
      v_mes           varchar2(32767);
      v_dia           number;
      v_anho          number;
      v_monto         varchar2(32767);
      v_letras1       varchar2(32767);
      v_letras2       varchar2(32767);
      v_identificador varchar2(2) := '&';
      v_monto2        varchar2(32767);
      v_parametros    varchar2(32767);
      v_letra         varchar2(32767);
      v_letras        varchar2(32767);
      v_reporte       varchar2(32767);
    begin
      -- raise_application_error(-20001,p_cod_banco||'moneda=>'||p_moneda);
      if p_moneda = 1 then
  
        select ltrim(to_char(p_importe, '999g999g999'))
          into v_monto
          from dual;
  
        v_letras1 := rpad(substr(general_skn.fp_conv_nro_txt(p_importe, p_moneda),
                                 0,
                                 55),
                          55,
                          '-');
  
        v_letras2 := rpad(nvl(substr(general.fp_conv_nro_txt(p_importe,
                                                             p_moneda),
                                     56,
                                     500),
                              '-'),
                          80,
                          '-');
  
      else
  
        select ltrim(to_char(p_importe, '999g999g999d99'))
          into v_monto
          from dual;
        v_letras1 := rpad(substr(general.fp_conv_nro_txt(p_importe, p_moneda),
                                 0,
                                 37),
                          37,
                          '-');
  
        v_letras2 := rpad(nvl(substr(general.fp_conv_nro_txt(p_importe,
                                                             p_moneda),
                                     38,
                                     500),
                              '-'),
                          38,
                          '-');
  
      end if;
  /*
      if p_cod_banco = 2 then
  
        if p_moneda = 1 then
          v_letras1 := rpad(substr(general.fp_conv_nro_txt(p_importe,
                                                           p_moneda),
                                   1,
                                   61),
                            61,
                            '-');
  
          v_letras2 := rpad(nvl(substr(general.fp_conv_nro_txt(p_importe,
                                                               p_moneda),
                                       62,
                                       75),
                                '-'),
                            75,
                            '-');
          v_reporte := 'finm027bbva_gs';
        else
          v_reporte := 'finm027bbva_us';
          v_letras1 := rpad(substr(general.fp_conv_nro_txt(p_importe,
                                                           p_moneda),
                                   1,
                                   90),
                            90,
                            '-');
  
          v_letras2 := rpad(nvl(substr(general.fp_conv_nro_txt(p_importe,
                                                               p_moneda),
                                       91,
                                       150),
                                '-'),
                            150,
                            '-');
        end if;
      end if;
  
      if p_cod_banco = 13 then
        if p_moneda = 1 then
          v_reporte := 'finm027itau_gs';
        else
          v_reporte := 'finm027itau_us';
        end if;
      end if;
  
      if p_cod_banco = 3 then
        if p_moneda = 1 then
          v_reporte := 'finm027regi_gs';
        else
          v_reporte := 'finm027regi_us';
        end if;
      end if;
  
      if p_cod_banco = 18 then
        v_reporte := 'finm027fami_gs';
      end if;
  
      if p_cod_banco = 2 then
  
        select to_char(p_fecha, 'mm') into v_mes from dual;
        select to_char(p_fecha, 'dd') into v_dia from dual;
        select to_char(p_fecha, 'yy') into v_anho from dual;
      else
        select to_char(p_fecha, 'month', 'nls_date_language=spanish')
          into v_mes
          from dual;
        select to_char(p_fecha, 'dd') into v_dia from dual;
        select to_char(p_fecha, 'yy') into v_anho from dual;
  
      end if;
  
  
      select regexp_replace(v_monto || ' ', ' ', '.-')
        into v_monto2
        from dual;
  
      v_parametros := 'p_formato=' || url_encode('pdf');
      v_parametros := v_parametros || v_identificador || 'p_empresa=' ||
                      url_encode(p_empresa);
      v_parametros := v_parametros || v_identificador || 'p_dia=' ||
                      url_encode(v_dia);
      v_parametros := v_parametros || v_identificador || 'p_mes=' ||
                      url_encode(v_mes);
      v_parametros := v_parametros || v_identificador || 'p_anho=' ||
                      url_encode(v_anho);
      v_parametros := v_parametros || v_identificador || 'p_nombre=' ||
                      url_encode(p_orden_de);
      v_parametros := v_parametros || v_identificador || 'p_letras_1=' ||
                      url_encode(v_letras1);
      v_parametros := v_parametros || v_identificador || 'p_letras_2=' ||
                      url_encode(v_letras2);
      v_parametros := v_parametros || v_identificador || 'p_imp_aux=' ||
                      url_encode(v_monto2);
      v_parametros := v_parametros || v_identificador || 'p_moneda=' ||
                      url_encode(p_moneda);
  
      delete from gen_parametros_report where usuario = gen_devuelve_user;
      insert into gen_parametros_report
        (parametros, usuario, nombre_reporte, formato_salida)
      values
        (v_parametros, gen_devuelve_user, v_reporte, 'pdf');
      commit;
  
    end pp_imprimir_cheques;*/

  function fl_nro_to_txt(pnro number, pcantdeci number, pmsg out varchar2)
    return varchar2 is
    vtexto varchar2(6000);
  begin
    select pack_nume_to_text2.fa_conv_nume_text(pnro, pcantdeci)
      into vtexto
      from dual;
  
    return vtexto;
  
  exception
    when others then
      pmsg := sqlerrm;
      return null;
  end fl_nro_to_txt;

  procedure pl_select_cheques(p_clavecheque  in number,
                              pfecdoc        out date,
                              pfecvto        out date,
                              ptotmon        out number,
                              pbenef         out varchar2,
                              pobs           out varchar2,
                              pmondecimp     out number,
                              pnrocheq       out varchar2,
                              pserie         out varchar2,
                              pindi_dia_dife out varchar2) is
  
    v_fech_emis      date;
    v_fech_venc      date;
    v_tota           number;
    v_benef          varchar2(90);
    v_obse           varchar2(20);
    v_mone_cant_deci number;
    v_nro_cheq       varchar2(20);
    v_serie          varchar2(3);
    v_indi_dia_dife  varchar2(4);
  
  begin
  
    select cheq_fech_emis,
           cheq_fech_venc,
           cheq_impo_mone,
           substr(decode(c.cheq_orde,
                         null,
                         nvl(cp.clpr_desc, ' '),
                         nvl(c.cheq_orde, ' ')),
                  1,
                  90) cheq_orde,
           substr(nvl(movi_obse, ' '), 1, 20) obse,
           mone_cant_deci,
           cheq_nume,
           cheq_serie,
           cheq_indi_dia_dife
      into v_fech_emis,
           v_fech_venc,
           v_tota,
           v_benef,
           v_obse,
           v_mone_cant_deci,
           v_nro_cheq,
           v_serie,
           v_indi_dia_dife
      from come_movi      m,
           come_cheq      c,
           come_mone      mo,
           come_movi_cheq mc,
           come_clie_prov cp
     where m.movi_codi = mc.chmo_movi_codi
       and c.cheq_codi = mc.chmo_cheq_codi
       and c.cheq_mone_codi = mo.mone_codi
       and c.cheq_tipo = 'E'
       and c.cheq_clpr_codi = cp.clpr_codi(+)
       and c.cheq_codi = p_clavecheque;
  
    pfecdoc := v_fech_emis;
  
    pfecvto := v_fech_venc;
  
    ptotmon := v_tota;
  
    pbenef := v_benef;
  
    pobs := v_obse;
  
    pmondecimp := v_mone_cant_deci;
  
    pnrocheq := v_nro_cheq;
  
    pserie := v_serie;
  
    pindi_dia_dife := v_indi_dia_dife;
  
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Cheque no encontrado,   clave ' ||
                              to_char(p_clavecheque));
    when others then
      raise_application_error(-20001,
                              'Error encontrado al recuperar el cheque con clave ' ||
                              to_char(p_clavecheque));
  end pl_select_cheques;
  /*
    procedure pl_cheque_abn(v_tot_mon          in number,
                            p_obs              in varchar2,
                            p_mon_dec_imp      in number,
                            p_cli_nom          in varchar2,
                            p_ch_emit_fec_vto1 in varchar2) is
    
      v_num_txt   varchar2(200) := ' ';
      v_num_txt_1 varchar2(1000) := ' ';
      v_num_txt_2 varchar2(1050) := ' ';
      v_num_txt_3 varchar2(1050) := ' ';
    
      v_obs_txt   varchar2(40) := ' ';
      v_obs_txt_1 varchar2(1000) := ' ';
      v_obs_txt_2 varchar2(1000) := ' ';
      v_obs_txt_3 varchar2(1000) := ' ';
    
      v_formato varchar2(20);
      v_importe varchar2(2000);
      v_fecha   varchar2(2000);
    
      v_parametros   clob;
      v_contenedores clob;
    begin
    
      --convertir total factura a letras
      v_num_txt := general_skn.fl_conv_nro_txt(v_tot_mon);
      v_num_txt := v_num_txt || ' ' || '.-';
    
      if nvl(length(v_num_txt), 0) > 155 then
        raise_application_error(-20001,
                                'la descripci?n del importe total en letras es muy larga. no se puede imprimir!');
      end if;
    
      pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
      pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
    
      v_obs_txt := p_obs;
    
      pl_separar_texto_lib(v_obs_txt, 21, 21, v_obs_txt_1, v_obs_txt_2);
      pl_separar_texto_lib(v_obs_txt_2, 19, 10, v_obs_txt_2, v_obs_txt_3);
      -- se envia dos veces la misma instruccion, porque si se enciende
      -- la impresora despues de iniciado windows , entonces la primera
      -- instruccion no se ejecuta.
    
      --/*  text_io.new_line(v_impresora,1); -- 1 linea en blanco
    
      /* text_io.put_line(v_impresora, 
          lpad(to_char(to_date(name_in('bchemit.ch_emit_fec_vto1'),'dd/mon/yyyy'),'dd'),3, ' ')||'/'
          ||lpad(to_char(to_date(name_in('bchemit.ch_emit_fec_vto1'),'dd/mon/yyyy'),'mm'),2, ' ')||'/'
        );    ||lpad(to_char(to_date(name_in('bchemit.ch_emit_fec_vto1'),'dd/mon/yyyy'),'yyyy'),4, ' ')
      
    
      v_formato := fl_formato(v_tot_mon, p_mon_dec_imp);
      --   raise_application_error(-20001,v_formato);
    
      --monto total del cheque
      /*text_io.put_line(v_impresora,
        rpad(name_in('parameter.p_cli_nom'),23, ' ')
        ||lpad(' ', 90, ' ')
        ||lpad(nvl(to_char(v_tot_mon, v_formato, 'nls_numeric_characters = '',.'''), ' '), 16, '#')
        ||'#'
      );
    
      --fecha del cheque
      select (lpad(' ', 70, ' ') ||
             lpad(to_char(to_date(p_ch_emit_fec_vto1, 'dd/mm/yyyy'), 'dd'),
                   2,
                   ' ') || lpad(' ', 5, ' ') ||
             initcap(rpad(rtrim(to_char(to_date(p_ch_emit_fec_vto1,
                                                 'dd/mm/yyyy'),
                                         'month')),
                           11,
                           ' ')) ||
             lpad(to_char(to_date(p_ch_emit_fec_vto1, 'dd/mm/yyyy'), 'yyyy'),
                   18,
                   ' '))
        into v_fecha
        from dual;
    
      --text_io.new_line(v_impresora,1); -- 1 lineas en blanco
    
      --concepto
      select (lpad(' ', 2, ' ') || rpad(v_obs_txt_1, 21, ' '))
        into v_obs_txt_1
        from dual;
    
      if v_obs_txt_2 is null or v_obs_txt_2 = ' ' then
        select (rpad(' ', 48, ' ') || rpad(p_cli_nom, 40, ' '))
          into v_obs_txt_2
          from dual;
      else
        select (rpad(v_obs_txt_2, 23, ' ') || lpad(' ', 25, ' ') ||
               rpad(p_cli_nom, 40, ' '))
          into v_obs_txt_2
          from dual;
      end if;
    
      --- text_io.new_line(v_impresora,1); -- 1 lineas en blanco
    
      --total factura en letras (2da. linea)
      if v_num_txt_2 is null or v_num_txt_2 = ' ' then
        --total factura en letras
        select (lpad(' ', 47, ' ') || rpad(v_num_txt_1, 90, ' -'))
          into v_num_txt_1
          from dual;
      
        --  text_io.new_line(v_impresora,1); -- 1 linea en blanco
      
        select (lpad(' ', 27, ' ') ||
               '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - ' ||
               '- - - - - -')
          into v_num_txt_2
          from dual;
      else
      
        --total factura en letras
        select (lpad(' ', 47, ' ') || rpad(v_num_txt_1, 90, ' '))
          into v_num_txt_1
          from dual;
      
        --   text_io.new_line(v_impresora,1); -- 1 linea en blanco
      
        select (lpad(' ', 27, ' ') || rpad(v_num_txt_2, 69, ' -'))
          into v_num_txt_2
          from dual;
      end if;
    
      ---  -- 2 lineas en blanco
    
      --monto total del cheque
      select (lpad(' ', 3, ' ') || lpad(nvl(to_char(v_tot_mon,
                                                    v_formato,
                                                    'nls_numeric_characters = '',.'''),
                                            ' '),
                                        16,
                                        ' '))
        into v_importe
        from dual;
    
      --/*text_io.new_line(v_impresora,5); -- 5 lineas en blanco
    
      v_contenedores := 'p_letras_1:p_letras_2:p_imp_aux:p_fecha:p_obs_2:p_nombre';
      v_parametros   := v_num_txt_1 || ':' || v_num_txt_2 || ':' || v_importe || ':' ||
                        v_fecha || ':' || v_obs_txt_2 || ':' || v_obs_txt_1;
    
      delete from come_parametros_report where usuario = gen_user;
    
      insert into come_parametros_report
        (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
      values
        (v_parametros, gen_user, 'cheques', 'pdf', v_contenedores);
    
    end pl_cheque_abn;
  */

  --------------------------------pl_cheque_abn
  procedure pl_cheque_abn(vclavecheque in number, p_form_impr in number) is
  
    v_num_txt   varchar2(200) := ' ';
    v_num_txt_1 varchar2(100) := ' ';
    v_num_txt_2 varchar2(105) := ' ';
    v_num_txt_3 varchar2(105) := ' ';
  
    v_obs_txt   varchar2(40) := ' ';
    v_obs_txt_1 varchar2(21) := ' ';
    v_obs_txt_2 varchar2(19) := ' ';
    v_obs_txt_3 varchar2(19) := ' ';
  
    v_benef_txt_1 varchar2(20) := ' ';
    v_benef_txt_2 varchar2(20) := ' ';
  
    --v_formato      varchar2(20);
    --v_formato_loc  varchar2(20);
    --v_formato_cant varchar2(20);
  
    vformatocant varchar2(20);
    vformatoimp  varchar2(20);
  
    --datos que se obtienen del select
    vfecdoc        date;
    vfecvto        date;
    vtotmon        number;
    vbenef         varchar2(80);
    vmondecimp     number;
    vobs           varchar2(40);
    vnrocheq       number;
    vserie         varchar2(2);
    vindi_dia_dife varchar2(4);
  
    --variables para distici?n de monedas.
    c_dolares   constant varchar2(3) := 'U$S';
    c_guaranies constant varchar2(3) := 'GS';
    v_moneda varchar2(3);
  
    --variable creado para contener los errores de la funci?n de nro a txt.
    vmsg          varchar2(2000);
    p_cheque_dato varchar2(32672);
  begin
    --seleccionar los datos del cheque
    pl_select_cheques(vclavecheque,
                      vfecdoc,
                      vfecvto,
                      vtotmon,
                      vbenef,
                      vobs,
                      vmondecimp,
                      vnrocheq,
                      vserie,
                      vindi_dia_dife);
  
    /*if fl_confirmar_reg('?desea imprimir el cheque nro. '||vserie||'-'||vnrocheq||' ?') <> 'confirmar' then
      return;
    end if;  */
  
    --mascaras de formato
    --vformatocant := '99990D00';
    vformatoimp  := fl_formato(13, vmondecimp);
  
    --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
    v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg);
    if vmsg is not null then
      raise_application_error(-20001, vmsg);
    end if;
  
    v_num_txt := v_num_txt || ' ' || '.-';
  
    if nvl(length(v_num_txt), 0) > 155 then
      raise_application_error(-20001,
                              'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
    end if;
  
    pl_separar_texto_lib(v_num_txt, 87, 87, v_num_txt_1, v_num_txt_2);
    pl_separar_texto_lib(v_num_txt_2, 105, 87, v_num_txt_2, v_num_txt_3);
  
    v_obs_txt := vobs;
  
    v_obs_txt_1 := nvl(substr(v_obs_txt, 1, 20), ' ');
    v_obs_txt_2 := nvl(substr(v_obs_txt, 21, 40), ' ');
  
    --cortamos la descripcion del cliente.
    v_benef_txt_1 := nvl(substr(vbenef, 1, 20), ' ');
    v_benef_txt_2 := nvl(substr(vbenef, 21, 20), ' ');
  
    ----------------------------------------------------
    ---- asignamos la moneda en la que trabajaremos ----
    ----------------------------------------------------
    if p_form_impr = 1 then
      v_moneda := c_guaranies;
    elsif p_form_impr = 2 then
      v_moneda := c_dolares;
    end if;
  
    ----------------------------
    --moneda en dolares(u$s)...!
    ----------------------------
    if v_moneda = c_dolares then
    
      -- se envia dos veces la misma instruccion, porque si se enciende
      -- la impresora despues de iniciado windows , entonces la primera
      -- instruccion no se ejecuta.
    
      --p_cheque_dato:= p_cheque_dato||  p_cheque_dato:= p_cheque_dato|| chr(27)||chr(120)||'0'; --establecer modo draft
      --p_cheque_dato:= p_cheque_dato|| chr(27)||chr(64); -- inicializar impresora
      --p_cheque_dato:= p_cheque_dato|| chr(27)||chr(120)||'0'; --establecer modo draft
      --p_cheque_dato:= p_cheque_dato|| chr(27)||chr(80); --establecer 10 cpi
      --p_cheque_dato:= p_cheque_dato|| chr(15); --compactar(17 cpi(caracteres por pulgada))
      --p_cheque_dato:= p_cheque_dato|| chr(27)||'0'; --establecer 1/8 (inch line spacing)
    
      p_cheque_dato := p_cheque_dato || chr(10);
    
      --p_cheque_dato:= p_cheque_dato|| chr(27)||'2'; --establecer 1/6 (inch line spacing)
    
      --fecha del cheque en el talon
      p_cheque_dato := p_cheque_dato ||
                       lpad(to_char(vfecdoc, 'DD'), 3, ' ') || '/' ||
                       lpad(to_char(vfecdoc, 'MM'), 2, ' ') || '/' ||
                       lpad(to_char(vfecdoc, 'YYYY'), 4, ' ');
      p_cheque_dato := p_cheque_dato || chr(10) || chr(10) || chr(10);
      --text_io.new_line(v_impresora, 3);
    
      --p_cheque_dato:= p_cheque_dato|| chr(27)||'0'); --establecer 1/8 (inch line spacing)
    
      --orden en el tal?n, fecha en letras y monto del cheque
      p_cheque_dato := p_cheque_dato || rpad(v_benef_txt_1, 23, ' ') ||
                       lpad(' ', 41, ' ') ||
                       rpad(to_char(vfecdoc, 'DD'), 3, ' ') ||
                       lpad(' ', 4, ' ') ||
                       initcap(rpad(rtrim(to_char(vfecdoc, 'month')),
                                    12,
                                    ' ')) ||
                       lpad(to_char(vfecdoc, 'YYYY'), 19, ' ') ||
                       rpad(' ', 16, ' ') ||
                       lpad(nvl(to_char(vtotmon,
                                        vformatoimp,
                                        'NLS_NUMERIC_CHARACTERS = '',.'''),
                                ' '),
                            15,
                            '#') || '#';
    
      p_cheque_dato := p_cheque_dato || rpad(v_benef_txt_2, 23, ' ');
    
      --concepto 1ra. l?nea con beneficiario
      p_cheque_dato := p_cheque_dato || rpad(v_obs_txt_1, 21, ' ') ||
                       lpad(' ', 23, ' ') || rpad(vbenef, 100, ' ');
    
      --concepto 2da. l?nea
      p_cheque_dato := p_cheque_dato || rpad(v_obs_txt_2, 21, ' ')
      
       ;
    
      --monto del cheque en letras.
      p_cheque_dato := p_cheque_dato || chr(10);
      if v_num_txt_2 is null or v_num_txt_2 = ' ' then
        --monto del cheque en letras 1ra linea
        p_cheque_dato := p_cheque_dato || lpad(' ', 43, ' ') ||
                         rpad(v_num_txt_1, 88, ' -');
      
        --  text_io.new_line (v_impresora, 2); --2 lineas en blanco
        p_cheque_dato := p_cheque_dato || chr(10) || chr(10);
        p_cheque_dato := p_cheque_dato || lpad(' ', 26, ' ') ||
                         '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - ' ||
                         '- - - - - -';
      else
        --monto del cheque en letras 1ra linea
        p_cheque_dato := p_cheque_dato || lpad(' ', 43, ' ') ||
                         rpad(v_num_txt_1, 88, ' ');
      
        p_cheque_dato := p_cheque_dato || chr(10) || chr(10); --2 linea en blanco
      
        --monto del cheque en letras 2da linea
        p_cheque_dato := p_cheque_dato || lpad(' ', 26, ' ') ||
                         rpad(v_num_txt_2, 69, ' -');
      end if;
    
      --p_cheque_dato:= p_cheque_dato|| chr(27)||'2'; --1/6 
      p_cheque_dato := p_cheque_dato || chr(10); -- lineas en blanco
      --p_cheque_dato:= p_cheque_dato|| chr(27)||'0'); --1/8
    
      --monto del cheque en el tal?n
      p_cheque_dato := p_cheque_dato || lpad(' ', 2, ' ') ||
                       lpad(nvl(to_char(vtotmon,
                                        vformatoimp,
                                        'NLS_NUMERIC_CHARACTERS = '',.'''),
                                ' '),
                            16,
                            ' ');
    
      p_cheque_dato := p_cheque_dato || chr(10);
      --p_cheque_dato:= p_cheque_dato|| chr(27)||'2'); --1/6
      p_cheque_dato := p_cheque_dato || chr(10) || chr(10) || chr(10) ||
                       chr(10);
    
      -----------------------------
      --moneda en guaranies(gs)...!
      -----------------------------
    elsif v_moneda = c_guaranies then
    
      -- se envia dos veces la misma instruccion, porque si se enciende
      -- la impresora despues de iniciado windows , entonces la primera
      -- instruccion no se ejecuta.
    
      --p_cheque_dato:= p_cheque_dato|| chr(27)||chr(120)||'0'); --establecer modo draft
    
      --p_cheque_dato:= p_cheque_dato|| chr(27)||chr(64)); -- inicializar impresora
    
      --p_cheque_dato:= p_cheque_dato|| chr(27)||chr(120)||'0'); --establecer modo draft
    
      --p_cheque_dato:= p_cheque_dato|| chr(27)||chr(80)); --establecer 10 cpi
    
      -- p_cheque_dato:= p_cheque_dato|| chr(15)); --compactar(17 cpi(caracteres por pulgada))
    
      -- p_cheque_dato:= p_cheque_dato|| chr(27)||'0'); --establecer 1/8 (inch line spacing)
    
      p_cheque_dato := p_cheque_dato || chr(10);
    
      -- p_cheque_dato:= p_cheque_dato|| chr(27)||'2'); --establecer 1/6 (inch line spacing)
    
      --fecha del cheque en el talon
      p_cheque_dato := p_cheque_dato ||
                       lpad(to_char(vfecdoc, 'DD'), 3, ' ') || '/' ||
                       lpad(to_char(vfecdoc, 'MM'), 2, ' ') || '/' ||
                       lpad(to_char(vfecdoc, 'YYYY'), 4, ' ');
    
      p_cheque_dato := p_cheque_dato || chr(10) || chr(10) || chr(10);
    
      --p_cheque_dato:= p_cheque_dato|| chr(27)||'0'); --establecer 1/8 (inch line spacing)
    
      --orden en el tal?n, fecha en letras y monto del cheque
      p_cheque_dato := p_cheque_dato || rpad(v_benef_txt_1, 23, ' ') ||
                       lpad(' ', 42, ' ') ||
                       rpad(to_char(vfecdoc, 'DD'), 3, ' ') ||
                       lpad(' ', 4, ' ') ||
                       initcap(rpad(rtrim(to_char(vfecdoc, 'month')),
                                    12,
                                    ' ')) ||
                       lpad(to_char(vfecdoc, 'YYYY'), 17, ' ') ||
                       rpad(' ', 13, ' ') ||
                       lpad(nvl(to_char(vtotmon,
                                        vformatoimp,
                                        'NLS_NUMERIC_CHARACTERS = '',.'''),
                                ' '),
                            15,
                            '#') || '#';
    
      p_cheque_dato := p_cheque_dato || rpad(v_benef_txt_2, 23, ' ');
    
      --concepto 1ra. l?nea con beneficiario
      p_cheque_dato := p_cheque_dato || rpad(v_obs_txt_1, 21, ' ') ||
                       lpad(' ', 23, ' ') || rpad(vbenef, 100, ' ');
    
      --concepto 2da. l?nea
      p_cheque_dato := p_cheque_dato || rpad(v_obs_txt_2, 21, ' ');
    
      --monto del cheque en letras.
      p_cheque_dato := p_cheque_dato || chr(10);
      if v_num_txt_2 is null or v_num_txt_2 = ' ' then
        --monto del cheque en letras 1ra linea
        p_cheque_dato := p_cheque_dato || lpad(' ', 43, ' ') ||
                         rpad(v_num_txt_1, 89, ' -');
      
        p_cheque_dato := p_cheque_dato || chr(10) || chr(10); --2 lineas en blanco
      
        p_cheque_dato := p_cheque_dato || lpad(' ', 26, ' ') ||
                         '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - ' ||
                         '- - - - - -';
      else
        --monto del cheque en letras 1ra linea
        p_cheque_dato := p_cheque_dato || lpad(' ', 43, ' ') ||
                         rpad(v_num_txt_1, 89, ' ');
      
        p_cheque_dato := p_cheque_dato || chr(10) || chr(10); --1 linea en blanco
      
        --monto del cheque en letras 2da linea
        p_cheque_dato := p_cheque_dato || lpad(' ', 26, ' ') ||
                         rpad(v_num_txt_2, 69, ' -');
      end if;
    
      -- p_cheque_dato:= p_cheque_dato|| chr(27)||'2'); --1/6 
      p_cheque_dato := p_cheque_dato || chr(10); -- lineas en blanco
      -- p_cheque_dato:= p_cheque_dato|| chr(27)||'0'); --1/8
    
      --monto del cheque en el tal?n
      p_cheque_dato := p_cheque_dato || lpad(' ', 2, ' ') ||
                       lpad(nvl(to_char(vtotmon,
                                        vformatoimp,
                                        'NLS_NUMERIC_CHARACTERS = '',.'''),
                                ' '),
                            16,
                            ' ');
    
      p_cheque_dato := p_cheque_dato || chr(10);
      --p_cheque_dato:= p_cheque_dato|| chr(27)||'2'); --1/6
      p_cheque_dato := p_cheque_dato || chr(10) || chr(10) || chr(10) ||
                       chr(10);
    
    end if;
    p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
  end pl_cheque_abn;

  --------------------------------pl_cheque_continental
  procedure pl_cheque_continental1(vclavecheque in number,
                                   p_form_impr  in number) is
  
    v_num_txt varchar2(500) := ' ';
  
    v_obs_txt   varchar2(40) := ' ';
    v_obs_txt_1 varchar2(20) := ' ';
    v_obs_txt_2 varchar2(26) := ' ';
    v_obs_txt_3 varchar2(26) := ' ';
  
 
    salir          exception;
  
  
    vformatoimp  varchar2(20);
  
    -- datos que se obtienen del select
    vfecdoc        date;
    vfecvto        date;
    vtotmon        number;
    vbenef         varchar2(80);
    vmondecimp     number;
    vobs           varchar2(40);
    vnrocheq       varchar2(30);
    vserie         varchar2(2);
    vindi_dia_dife varchar2(4);
    p_cheque_dato  varchar2(32672);
  
    --variable creado para contener los errores de la funci?n de nro a txt.
    vmsg           varchar2(2000);
    v_parametros   clob;
    v_contenedores clob;
 
  
  begin
    -- seleccionar los datos del cheque
    pl_select_cheques(vclavecheque,
                      vfecdoc,
                      vfecvto,
                      vtotmon,
                      vbenef,
                      vobs,
                      vmondecimp,
                      vnrocheq,
                      vserie,
                      vindi_dia_dife);
  
    
  
    --mascaras de formato
    vformatoimp  := fl_formato(13, vmondecimp);
  
    --ba 09-05-2007: cambio de la funcion que busca el texto de algun numero.
    v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg) || ' ' || '.-';
    if vmsg is not null then
      raise_application_error(-20001, vmsg);
    end if;
  
    if nvl(length(v_num_txt), 0) > 138 then
      raise_application_error(-20001,
                              'La descripcion del importe total en letras es muy larga. No se puede imprimir!');
    end if;
    v_num_txt := rpad(v_num_txt, 145, ' -');
  
    -- se envia dos veces la misma instruccion, porque si se enciende
    -- la impresora despues de iniciado windows , entonces la primera
    -- instruccion no se ejecuta.
    --  p_cheque_dato:= chr(27)||chr(120)||'0';--establecer modo draft
    --  p_cheque_dato:= p_cheque_dato||' '||chr(27)||chr(64);-- inicializar impresora
    --  p_cheque_dato:= p_cheque_dato||' '||chr(27)||chr(120)||'0';--establecer modo draft
    --  p_cheque_dato:= p_cheque_dato||' '||chr(27)||chr(80); --establecer 10 cpi
    --  p_cheque_dato:= p_cheque_dato||' '||chr(15);--compactar(17 cpi(caracteres por pulgada))
    --  p_cheque_dato:= p_cheque_dato||' '|| chr(27)||'2';--establecer 1/6 (inch line spacing)
    p_cheque_dato := p_cheque_dato || chr(10); --1 linea en blanco

    --  p_cheque_dato:= p_cheque_dato||' '|| chr(27)||'0';--establecer 1/8 (inch line spacing)
    --  p_cheque_dato:= p_cheque_dato||' '|| chr(27)||'2';--establecer 1/6 (inch line spacing)
  
    --monto total del cheque
    if p_form_impr = 3 then
    
      p_cheque_dato := p_cheque_dato || lpad(' ', 110, ' ') ||
                       lpad(nvl(to_char(vtotmon,
                                        vformatoimp,
                                        'NLS_NUMERIC_CHARACTERS = '',.'''),
                                ' '),
                            19,
                            '#') || '#';
    
    else
      p_cheque_dato := p_cheque_dato || lpad(' ', 112, ' ') ||
                       lpad(nvl(to_char(vtotmon,
                                        vformatoimp,
                                        'NLS_NUMERIC_CHARACTERS = '',.'''),
                                ' '),
                            17,
                            '#') || '#';
    end if;
    
    p_cheque_dato := p_cheque_dato ||chr(13)||chr(13)|| chr(13);
  
 
  
    --fecha en el talon
    p_cheque_dato := p_cheque_dato || lpad(to_char(vfecdoc, 'DD'), 7, ' ') || '/' ||
                     lpad(to_char(vfecdoc, 'MM'), 2, ' ') || '/' ||
                     lpad(to_char(vfecdoc, 'YYYY'), 4, ' ');
    
   -- p_cheque_dato:= p_cheque_dato||' '|| chr(13);
 
    --orden en talon 
    --p_cheque_dato := p_cheque_dato || chr(13);
    
    -- fecha de operacion en letras
    p_cheque_dato := p_cheque_dato || lpad(' ', 90, ' ') ||
                     lpad(to_char(vfecdoc, 'DD'), 2, ' ') ||
                     lpad(' ', 10, ' ') ||
                     initcap(rpad(rtrim(to_char(vfecdoc, 'month')), 17, ' ')) ||
                     lpad(to_char(vfecdoc, 'YYYY'), 8, ' ');
        
     p_cheque_dato := p_cheque_dato || chr(13);            
    
     
     p_cheque_dato := p_cheque_dato ||
                     lpad(nvl(substr(vbenef, 1, 17), ' '), 17, ' ');
  
   
   --formato de concepto
     v_obs_txt := rtrim(vobs);
     pl_separar_texto_lib(v_obs_txt, 20, 20, v_obs_txt_1, v_obs_txt_2);
     pl_separar_texto_lib(v_obs_txt_2, 26, 16, v_obs_txt_2, v_obs_txt_3);
  
    v_obs_txt_1 := nvl(v_obs_txt_1, ' ');
    v_obs_txt_2 := nvl(v_obs_txt_2, ' ');
  
    --concepto en 1? linea
  
    
    p_cheque_dato := p_cheque_dato || rpad(v_obs_txt_1, 17, ' ');
  
    --2da. linea de concepto y orden en el cheque  
    -- p_cheque_dato:= p_cheque_dato||' '|| chr(27)||'0'; --establecer 1/6 (inch line spacing)
    
  
   
    p_cheque_dato := p_cheque_dato || rpad(v_obs_txt_2, 17, ' ') || lpad(' ', 25, ' ') || rpad(vbenef, 100, ' ');
  
    p_cheque_dato:= p_cheque_dato||' '|| chr(13);
  
    p_cheque_dato := p_cheque_dato || chr(13);
     --1ra. linea de numero en letras cerrada con - - -
    if p_form_impr = 3 then
      p_cheque_dato := p_cheque_dato || lpad(' ', 40, ' ') ||
                       substr(v_num_txt, 1, 88);
    else
      p_cheque_dato := p_cheque_dato || lpad(' ', 50, ' ') ||
                       substr(v_num_txt, 1, 80);
    end if;
    
    p_cheque_dato := p_cheque_dato || chr(13)|| chr(13);
  
  
    --2da. linea de numero en letras
    if p_form_impr = 3 then
      p_cheque_dato := p_cheque_dato || lpad(' ', 21, ' ') ||
                       substr(v_num_txt, 89, 57);
    else
      p_cheque_dato := p_cheque_dato || lpad(' ', 21, ' ') ||
                       substr(v_num_txt, 81, 57);
    end if;
  
    p_cheque_dato := p_cheque_dato || chr(13) || chr(13);
  
  
    --monto total del cheque
    p_cheque_dato := p_cheque_dato || lpad(' ', 4, ' ') ||
                     rpad(nvl(to_char(vtotmon,
                                      vformatoimp,
                                      'NLS_NUMERIC_CHARACTERS = '',.'''),
                              ' '),
                          22,
                          ' ');
  
  
    p_cheque_dato := p_cheque_dato || chr(13);
    p_cheque_dato := p_cheque_dato || chr(10) || chr(10) || chr(10) ||
                     chr(10); -- 4 lineas en blanco
  

 delete come_tabl_auxi
     where taax_sess = 13
       and taax_user = gen_user;
  
    p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
    delete from come_parametros_report where usuario = gen_user;
  
    insert into come_parametros_report
      (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
    values
      (v_parametros, gen_user, 'cheque_formato', 'pdf', v_contenedores);
  
  exception
    when salir then
      null;
  end pl_cheque_continental1;



--------------------------------pl_cheque_regional
procedure pl_cheque_regional(vclavecheque in number, 
                             p_form_impr  in number)
is
  
  v_num_txt            varchar2(200) := ' ';
  v_num_txt_1          varchar2(90) := ' ';
  v_num_txt_2          varchar2(105) := ' ';
  v_num_txt_3          varchar2(95) := ' ';
  
  v_obs_txt            varchar2(40) := ' ';
  v_obs_txt_1          varchar2(20) := ' ';
  v_obs_txt_2          varchar2(26) := ' ';
  v_obs_txt_3          varchar2(26) := ' ';
  
  v_formato            varchar2(20);
  v_formato_loc        varchar2(20);
  v_formato_cant       varchar2(20);
  
  vformatocant         varchar2(20);
  vformatoimp          varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc              date;
  vfecvto              date;
  vtotmon              number;
  vbenef               varchar2(80);
  vmondecimp           number;
  vobs                 varchar2(40);
  vnrocheq             varchar2(30);
  vserie               varchar2(2);
  vindi_dia_dife                varchar2(4);
  
  --variables para distici?n de monedas.
  c_dolares   constant varchar2(3) := 'U$S';
  c_guaranies constant varchar2(3) := 'GS';
  v_moneda             varchar2(3);

  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
  p_cheque_dato varchar2(32672);
    
begin
  -- seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
    
   
     
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  
  
  --ba 22-03-2007: distinci?n de monedas.
  ----------------------------------------------------
  ---- asignamos la moneda en la que trabajaremos ----
  ----------------------------------------------------
  if p_form_impr = 5 then
    v_moneda := c_guaranies;
  elsif p_form_impr = 6 then
    v_moneda := c_dolares;
  end if;
  
  
  -------------------------------
  --moneda en guaranies('gs')...!
  -------------------------------
  if v_moneda = c_guaranies then
    
    pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
    pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
    
    --se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato ||chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
    
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
    
    --monto total del cheque
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 113, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 20, '#')
       ||'#'
    ;
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10); -- 3 lineas en blanco
    
     --p_cheque_dato := p_cheque_dato || chr(27)||'2'); --establecer 1/6 (inch line spacing)*/
    
    --fecha en letras
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',89, ' ')
       ||lpad(to_char(vfecdoc,'DD'),2, ' ')
       ||lpad(' ', 6, ' ')
       ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 10, ' '))
       ||lpad(to_char(vfecdoc,'YYYY'), 26, ' ')
    ;
   -- p_cheque_dato := p_cheque_dato || chr(27)||'0'); --establecer 1/8 (inch line spacing)*/
    p_cheque_dato := p_cheque_dato || chr(13);
    --fecha en talon
    p_cheque_dato := p_cheque_dato ||
       lpad(to_char(vfecdoc,'DD'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'MM'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'YYYY'),4, ' ')
    ;
    
    --orden en talon y cheque.
    p_cheque_dato := p_cheque_dato ||
       rpad(nvl(substr(vbenef,1,19),' '), 19,' ')
       ||lpad(' ', 28, ' ')
       ||rpad(vbenef, 80, ' ')
    ;
    
   -- p_cheque_dato := p_cheque_dato || chr(27)||'2'); --establecer 1/6 (inch line spacing)  
  p_cheque_dato := p_cheque_dato || chr(13);
    
    --formato de concepto
    v_obs_txt   := rtrim(vobs);
    v_obs_txt_1 := nvl(ltrim(rtrim(substr(v_obs_txt,1, 19))),' ');
    v_obs_txt_2 := nvl(ltrim(rtrim(substr(v_obs_txt,20,19))),' ');
    
    --concepto en 1? linea
    p_cheque_dato := p_cheque_dato ||
      rpad(v_obs_txt_1,20, ' ')
    ;
    
    --total factura en letras (2da. linea)
    if v_num_txt_2 is null or v_num_txt_2 = ' ' then
      if v_obs_txt_2 is null or v_obs_txt_2 = ' ' then
        p_cheque_dato := p_cheque_dato ||
           lpad(' ', 40, ' ')
           ||rpad(v_num_txt_1, 93, ' -')
        ;
      
      p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
    
      else
        p_cheque_dato := p_cheque_dato ||
           rpad(v_obs_txt_2,20,' ')
           ||lpad(' ', 20, ' ')
           ||rpad(v_num_txt_1, 93, ' -')
        ;
       p_cheque_dato := p_cheque_dato || chr(13); -- 1 linea en blanco
      
      end if;
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 26, ' ')
         ||lpad('- ',55,'- ')||lpad(' ',53,' ')
      ;
    else
      if v_obs_txt_2 is null or v_obs_txt_2 = ' ' then
        p_cheque_dato := p_cheque_dato ||
           lpad(' ', 40, ' ')
           ||rpad(v_num_txt_1, 93, ' ')
        ;
        p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      else
        p_cheque_dato := p_cheque_dato ||
           rpad(v_obs_txt_2,19,' ')
           ||lpad(' ', 20, ' ')
           ||rpad(v_num_txt_1, 93, ' ')
        ;
        p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      end if;
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 30, ' ')
         ||rpad(v_num_txt_2,104,' -')
      ;
    end if;
    
   -- p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10); --2 lineas en blanco 
    
   -- p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
    
    --monto total del cheque.
    p_cheque_dato := p_cheque_dato ||
       lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 19, ' ')
    ;
    
   -- p_cheque_dato := p_cheque_dato || chr(27)||'0'); --establecer 1/8 (inch line spacing)
     p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10); --6 lineas en blanco

  
  
  ----------------------------
  --moneda en dolares(u$s)...!
  ----------------------------
  elsif v_moneda = c_dolares then
    
    pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
    pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
    
    --se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    --p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'); --establecer modo draft
    
    --p_cheque_dato := p_cheque_dato || chr(27)||chr(64)); -- inicializar impresora
    
    --p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'); --establecer modo draft
    
    --p_cheque_dato := p_cheque_dato || chr(27)||chr(80)); --establecer 10 cpi
    
   -- p_cheque_dato := p_cheque_dato || chr(15)); --compactar(17 cpi(caracteres por pulgada))
    
    --p_cheque_dato := p_cheque_dato || chr(27)||'0'); --establecer 1/8 (inch line spacing)
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
    
    --monto total del cheque
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 113, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 20, '#')
       ||'#'
    ;
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10); -- 3 lineas en blanco
    
    --p_cheque_dato := p_cheque_dato || chr(27)||'2'); --establecer 1/6 (inch line spacing)*/
    
    --fecha en letras
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',89, ' ')
       ||lpad(to_char(vfecdoc,'DD'),2, ' ')
       ||lpad(' ', 6, ' ')
       ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 10, ' '))
       ||lpad(to_char(vfecdoc,'YYYY'), 26, ' ')
    ;
 --   p_cheque_dato := p_cheque_dato || chr(27)||'0'); --establecer 1/8 (inch line spacing)*/
     p_cheque_dato := p_cheque_dato || chr(13);
    --fecha en talon
    p_cheque_dato := p_cheque_dato ||
       lpad(to_char(vfecdoc,'DD'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'MM'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'YYYY'),4, ' ')
    ;
    
    --orden en talon y cheque.
    p_cheque_dato := p_cheque_dato ||
       rpad(nvl(substr(vbenef,1,19),' '), 19,' ')
       ||lpad(' ', 28, ' ')
       ||rpad(vbenef, 80, ' ')
    ;
    p_cheque_dato := p_cheque_dato || chr(13);
   --p_cheque_dato := p_cheque_dato || chr(27)||'2'); --establecer 1/6 (inch line spacing)  
    --text_io.new_line(v_impresora,1); -- 1 lineas en blanco
    
    --formato de concepto
    v_obs_txt   := rtrim(vobs);
    v_obs_txt_1 := nvl(ltrim(rtrim(substr(v_obs_txt,1, 19))),' ');
    v_obs_txt_2 := nvl(ltrim(rtrim(substr(v_obs_txt,20,19))),' ');
    
    --concepto en 1? linea
    p_cheque_dato := p_cheque_dato ||
      rpad(v_obs_txt_1,20, ' ')
    ;
    
    --total factura en letras (2da. linea)
    if v_num_txt_2 is null or v_num_txt_2 = ' ' then
      if v_obs_txt_2 is null or v_obs_txt_2 = ' ' then
        p_cheque_dato := p_cheque_dato ||
           lpad(' ', 40, ' ')
           ||rpad(v_num_txt_1, 93, ' -')
        ;
      
        p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      else
        p_cheque_dato := p_cheque_dato ||
           rpad(v_obs_txt_2,20,' ')
           ||lpad(' ', 20, ' ')
           ||rpad(v_num_txt_1, 93, ' -')
        ;
        p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      end if;
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 26, ' ')
         ||lpad('- ',55,'- ')||lpad(' ',53,' ')
      ;
    else
      if v_obs_txt_2 is null or v_obs_txt_2 = ' ' then
        p_cheque_dato := p_cheque_dato ||
           lpad(' ', 40, ' ')
           ||rpad(v_num_txt_1, 93, ' ')
        ;
        p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      else
        p_cheque_dato := p_cheque_dato ||
           rpad(v_obs_txt_2,19,' ')
           ||lpad(' ', 20, ' ')
           ||rpad(v_num_txt_1, 93, ' ')
        ;
        p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      end if;
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 30, ' ')
         ||rpad(v_num_txt_2,104,' -')
      ;
    end if;
    
   -- p_cheque_dato := p_cheque_dato || chr(27)||'0'); --establecer 1/8 (inch line spacing)
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10); --2 lineas en blanco 
    
   -- p_cheque_dato := p_cheque_dato || chr(27)||'2'); --establecer 1/6 (inch line spacing)
    
    --monto total del cheque.
    p_cheque_dato := p_cheque_dato ||
       lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 19, ' ')
    ;
    
   -- p_cheque_dato := p_cheque_dato || chr(27)||'0'); --establecer 1/8 (inch line spacing)
     p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10); --6 lineas en blanco
    
  end if;
  
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
end;

--------------------------------

--------------------------------pl_cheque_continental_dif
procedure pl_cheque_continental_dif(
                                    vclavecheque in number, 
                                    p_form_impr  in number)
is
  
  v_num_txt       varchar2(500) := ' ';
  
  v_obs_txt       varchar2(40) := ' ';
  v_obs_txt_1     varchar2(20) := ' ';
  v_obs_txt_2     varchar2(26) := ' ';
  v_obs_txt_3     varchar2(26) := ' ';
  
  v_formato       varchar2(20);
  v_formato_loc   varchar2(20);
  v_formato_cant  varchar2(20);
  salir           exception;
    
  vformatocant    varchar2(20);
  vformatoimp     varchar2(20);
  
  --datos que se obtienen del select
  vfecdoc         date;
  vfecvto         date;
  vtotmon         number;
  vbenef          varchar2(80);
  vmondecimp      number;
  vobs            varchar2(40);
  vnrocheq        varchar2(30);
  vserie          varchar2(2);
  vindi_dia_dife           varchar2(4);

  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000); 
   p_cheque_dato varchar2(32672); 
begin
  -- seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  
 
  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 138 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  v_num_txt := rpad(v_num_txt, 145, ' -');
  
  -- se envia dos veces la misma instruccion, porque si se enciende
  -- la impresora despues de iniciado windows , entonces la primera
  -- instruccion no se ejecuta.

 -- p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'); --establecer modo draft
 
 -- p_cheque_dato := p_cheque_dato || chr(27)||chr(64)); -- inicializar impresora

 -- p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'); --establecer modo draft
  
  --p_cheque_dato := p_cheque_dato || chr(27)||chr(80)); --establecer 10 cpi
  
  --p_cheque_dato := p_cheque_dato || chr(15)); --compactar(17 cpi(caracteres por pulgada))
-- - 
 -- p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(21)); --interespaciado 1/6 *** 25
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
  
 -- p_cheque_dato := p_cheque_dato || chr(27)||'0'); --establecer 1/8 (inch line spacing)
  
  
  --fecha de operacion en letras
  p_cheque_dato := p_cheque_dato ||
     lpad(' ',91, ' ')
     ||lpad(to_char(vfecdoc,'DD'),2, ' ')
     ||lpad(' ', 10, ' ')
     ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 17, ' '))
     ||lpad(' ', 4, ' ')
     ||lpad(to_char(vfecdoc,'YYYY'), 5, ' ')
  ;
  
  p_cheque_dato := p_cheque_dato || chr(10); --1 lineas en blanco
  
  --fecha de vencimiento en el talon
  p_cheque_dato := p_cheque_dato ||
     lpad(' ',4, ' ')
     ||lpad(to_char(vfecvto,'DD'),7, ' ')||'/'
     ||lpad(to_char(vfecvto,'MM'),2, ' ')||'/'
     ||lpad(to_char(vfecvto,'YYYY'),4, ' ');
  
  --fecha de vencimiento y monto total del cheque
  p_cheque_dato := p_cheque_dato ||
     lpad(' ', 44, ' ')
     ||lpad(to_char(vfecvto,'DD'),2, ' ')
     ||lpad(' ', 10, ' ')
     ||initcap(rpad(rtrim(to_char(vfecvto,'month')), 18, ' '))
     ||lpad(to_char(vfecvto,'YYYY'), 7, ' ')
     ||lpad(' ', 29, ' ')
     ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 19, '#')
     ||'#'
  ;
  
  p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(16); --interespaciado 1/6 *** 20
  --orden en el talon
  p_cheque_dato := p_cheque_dato ||
    lpad(nvl(substr(vbenef,1,21),' '),21,' ');
  
   p_cheque_dato := p_cheque_dato || chr(10);
  
  --formato de concepto
  v_obs_txt := rtrim(vobs);
  pl_separar_texto_lib(v_obs_txt, 20, 20, v_obs_txt_1, v_obs_txt_2);
  pl_separar_texto_lib(v_obs_txt_2, 26, 16, v_obs_txt_2, v_obs_txt_3);
  v_obs_txt_1 := nvl(v_obs_txt_1, ' ');
  v_obs_txt_2 := nvl(v_obs_txt_2, ' ');
 ------------------------------------------------------------------------------------------------ 
  --concepto en 1? linea
  --orden en el cheque
  p_cheque_dato := p_cheque_dato ||
     rpad(v_obs_txt_1,20, ' ')
     ||lpad(' ',22,' ')
     ||rpad(vbenef, 80,' ')
  ;
  
  if v_obs_txt_2 is null then
    v_obs_txt_2 := ' '; --para que tenga algo que imprimir y rellenar con espacios
  end if;
  
     p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10);
  --------------------------------------------------------------------------------------------------
  --y 1ra. linea de numero en letras cerrada con - - -
   if p_form_impr = 7 then
      p_cheque_dato := p_cheque_dato ||
       lpad(' ', 44, ' ')
       ||substr(v_num_txt, 1, 88);
   else    
      p_cheque_dato := p_cheque_dato ||
       lpad(' ', 45, ' ')
       ||substr(v_num_txt, 1, 80);   
   end if;
   
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10); --1 lineas en blanco
  
  --2da. linea de numero en letras
  p_cheque_dato := p_cheque_dato ||
    lpad(' ', 26, ' ')
    ||substr(v_num_txt,89,57)
  ;
  
  p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(28); --interespaciado 1/6 *** 20
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
  --monto total del cheque
  p_cheque_dato := p_cheque_dato ||
   rpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 22, ' ')
  ;
  
   p_cheque_dato := p_cheque_dato || chr(10);
  p_cheque_dato := p_cheque_dato || chr(10); -- 1 lineas en blanco
  p_cheque_dato := p_cheque_dato || chr(27); --establecer 1/8 (inch line spacing)
   p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10); -- 4 lineas en blanco
   
  
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
exception
  when salir then null;
end;
--------------------------------

--------------------------------pl_cheque_fomento
procedure pl_cheque_fomento(
                            vclavecheque in number, 
                            p_form_impr  in number) is
  
  v_num_txt      varchar2(200) := ' ';
  v_num_txt_1    varchar2(100) := ' ';
  v_num_txt_2    varchar2(105) := ' ';
  v_num_txt_3    varchar2(105) := ' ';
  
  v_obs_txt      varchar2(40) := ' ';
  v_obs_txt_1    varchar2(21) := ' ';
  v_obs_txt_2    varchar2(19) := ' ';
  v_obs_txt_3    varchar2(19) := ' ';
  
  v_benef_txt_1  varchar2(20) := ' ';
  v_benef_txt_2  varchar2(20) := ' ';
  
  v_formato      varchar2(20);
  v_formato_loc  varchar2(20);
  v_formato_cant varchar2(20);
  
  vformatocant   varchar2(20);
  vformatoimp    varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc        date;
  vfecvto        date;
  vtotmon        number;
  vbenef         varchar2(80);
  vmondecimp     number;
  vobs           varchar2(40);
  vnrocheq       varchar2(30);
  vserie         varchar2(2);
  vindi_dia_dife          varchar2(4);
  
  --variables para distici?n de monedas.
  c_dolares   constant varchar2(3) := 'U$S';
  c_guaranies constant varchar2(3) := 'GS';
  v_moneda             varchar2(3);
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
   p_cheque_dato varchar2(32672);
  
begin
  --seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
     
 
  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  
  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
  
  v_obs_txt := vobs;
  
  pl_separar_texto_lib(v_obs_txt, 21, 21, v_obs_txt_1, v_obs_txt_2); 
  pl_separar_texto_lib(v_obs_txt_2,19, 10, v_obs_txt_2, v_obs_txt_3);
  
  ----------------------------------------------------
  ---- asignamos la moneda en la que trabajaremos ----
  ----------------------------------------------------
  if p_form_impr = 8 then
    v_moneda := c_guaranies;
  elsif p_form_impr = 9 then
    v_moneda := c_dolares;
  end if;
  
  ----------------------------
  --moneda en dolares(u$s)...!
  ----------------------------
  if v_moneda = c_dolares then
    --se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
      
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10); --3 linea en blanco
    
    p_cheque_dato := p_cheque_dato || 
       lpad(to_char(vfecdoc,'DD'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'MM'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'YYYY'),4, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
    
    -- orden del cheque en el talon
    
    v_benef_txt_1 := nvl(ltrim(rtrim(substr(vbenef,1,19))),' ');
    v_benef_txt_2 := nvl(ltrim(rtrim(substr(vbenef,20,19))),' ');
    
    p_cheque_dato := p_cheque_dato ||
       lpad(v_benef_txt_1,19, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)  
    
    --beneficiario en tal?n y monto total de cheque.
    p_cheque_dato := p_cheque_dato ||
       lpad(v_benef_txt_2,19,' ')
       ||lpad(' ',96, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 16, '#')
       ||'#'
    ;
    
    --fecha del cheque en letras
    p_cheque_dato := p_cheque_dato || 
       lpad(' ', 60, ' ')
       ||lpad(to_char(vfecdoc,'DD'),2, ' ')
       ||lpad(' ', 7, ' ')
       ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 13, ' '))
       ||lpad(to_char(vfecdoc,'YYYY'), 17, ' ')
    ;
    
    --concepto
    p_cheque_dato := p_cheque_dato ||
       rpad(v_obs_txt_1, 19, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)  
    
    -- p?guese a la orden de...
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 34, ' ')
       ||rpad(vbenef, 80, ' ')
    ;
  
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)  
    p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)  
  
    --total factura en letras (2da. linea) 
    if v_num_txt_2 is null or v_num_txt_2 = ' ' then
      --total factura en letras
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 42, ' ')
         ||rpad(v_num_txt_1, 93, ' -')
      ;
      
      p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 23, ' ')
         ||lpad('- ',66,'- ')
      ;
    else
      
      --total factura en letras
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 42, ' ')
         ||rpad(v_num_txt_1, 93, ' ')
      ;
      
      p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 23, ' ')
         ||rpad(v_num_txt_2,66,' -')
      ;
    end if;
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10); -- 2 lineas en blanco
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)  
    p_cheque_dato := p_cheque_dato || chr(10); -- 2 linea en blanco
    
    --monto total del cheque
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 1, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 16, ' ')
    ;
    
     p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10); -- 4 lineas en blanco
  
  -----------------------------
  --moneda en guaranies(gs)...!
  -----------------------------
  elsif v_moneda = c_guaranies then
    
    --se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
      
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10); --3 linea en blanco
    
    p_cheque_dato := p_cheque_dato || 
       lpad(to_char(vfecdoc,'DD'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'MM'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'YYYY'),4, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
    
    -- orden del cheque en el talon
    
    v_benef_txt_1 := nvl(ltrim(rtrim(substr(vbenef,1,19))),' ');
    v_benef_txt_2 := nvl(ltrim(rtrim(substr(vbenef,20,19))),' ');
    
    p_cheque_dato := p_cheque_dato ||
       lpad(v_benef_txt_1,19, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)  
    
    --beneficiario en tal?n y monto total de cheque.
    p_cheque_dato := p_cheque_dato ||
       lpad(v_benef_txt_2,19,' ')
       ||lpad(' ',94, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 16, '#')
       ||'#'
    ;
    
    --fecha del cheque en letras
    p_cheque_dato := p_cheque_dato || 
       lpad(' ', 60, ' ')
       ||lpad(to_char(vfecdoc,'DD'),2, ' ')
       ||lpad(' ', 7, ' ')
       ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 13, ' '))
       ||lpad(to_char(vfecdoc,'YYYY'), 17, ' ')
    ;
    
    --concepto
    p_cheque_dato := p_cheque_dato ||
       rpad(v_obs_txt_1, 19, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)  
    
    -- p?guese a la orden de...
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 34, ' ')
       ||rpad(vbenef, 80, ' ')
    ;
  
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)  
    p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)  
  
    --total factura en letras (2da. linea) 
    if v_num_txt_2 is null or v_num_txt_2 = ' ' then
      --total factura en letras
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 40, ' ')
         ||rpad(v_num_txt_1, 93, ' -')
      ;
      
      p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 23, ' ')
         ||lpad('- ',66,'- ')
      ;
    else
      
      --total factura en letras
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 40, ' ')
         ||rpad(v_num_txt_1, 93, ' ')
      ;
      
      p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 23, ' ')
         ||rpad(v_num_txt_2,66,' -')
      ;
    end if;
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10); -- 2 lineas en blanco
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)  
    p_cheque_dato := p_cheque_dato || chr(10); -- 2 linea en blanco
    
    --monto total del cheque
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 1, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 16, ' ')
    ;
    
     p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10); -- 4 lineas en blanco
  
  end if;
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
end;
--------------------------------

--------------------------------pl_cheque_interbanco
procedure pl_cheque_interbanco(
                               vclavecheque in number, 
                               p_form_impr  in number) is
  
  v_num_txt       varchar2(200) := ' ';
  v_num_txt_1     varchar2(90) := ' ';
  v_num_txt_2     varchar2(105) := ' ';
  v_num_txt_3     varchar2(95) := ' ';
  
  v_obs_txt       varchar2(40) := ' ';
  v_obs_txt_1     varchar2(14) := ' ';
  v_obs_txt_2     varchar2(26) := ' ';
  v_obs_txt_3     varchar2(26) := ' ';
  
  v_formato       varchar2(20);
  v_formato_loc   varchar2(20);
  v_formato_cant  varchar2(20);
  v_cli_txt       varchar2(50) := ' ';
  v_cli_txt_1     varchar2(19) := ' ';
  v_cli_txt_2     varchar2(21) := ' ';
  
  vformatocant    varchar2(20);
  vformatoimp     varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc         date;
  vfecvto         date;
  vtotmon         number;
  vbenef          varchar2(300);
  vmondecimp      number;
  vobs            varchar2(40);
  vnrocheq        varchar2(30);
  vserie          varchar2(2);
  vindi_dia_dife           varchar2(4);
  
  --bruno aguilera (impresion de cheques interbanco_gs e interbanco_us).
  --monedas a discriminar
  c_transaccion_guaranies     constant varchar2(2) := 'GS';
  c_transaccion_dolares       constant varchar2(2) := 'US';
  
  --variable que tomara el tipo de transaccion (moneda).
  v_transaccion_moneda                 varchar2(2);
  
  --variables para los totales en letras.
  v_num_txt_1_us                       v_num_txt_1%type := ' '; 
  v_num_txt_2_us                       v_num_txt_2%type := ' ';
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
   p_cheque_dato varchar2(32672);
  
begin
  --seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  
 
  
  --verificamos y definimos el modo de transaccion (moneda)
  if p_form_impr = 10 then
    --transaccion en guaranies.
    v_transaccion_moneda := c_transaccion_guaranies;
  else
    --obs: esta sgte. asignacion podriamos obviar para el caso de dos 
    --     monedas distintas, pero para mas ya es necesario...
    --transaccion en dolares "interbco$".
    v_transaccion_moneda := c_transaccion_dolares;
  end if;
  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
  
  --se envia dos veces la misma instruccion, porque si se enciende
  --la impresora despues de iniciado windows , entonces la primera
  --instruccion no se ejecuta.
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
  
  p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2';
  
  --text_io.new_line(v_impresora, 1);
  
   p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(30); --interespaciado 1/6 *** 25
  
  --fecha del cheque en el talon
  p_cheque_dato := p_cheque_dato ||
    --mascaras con espacio en blanco a la izquierda.
     rpad(to_char(vfecvto,' DD/MM/YYYY'),19, ' ')
  ;
  
   p_cheque_dato := p_cheque_dato || chr(10); --1 linea en blanco

    
  --separar "orden" para que imprima en 2 lineas
  v_cli_txt := ltrim(rtrim(vbenef)); --quitar espacios a la izquierda y a la derecha
  if v_cli_txt is null then
    v_cli_txt_1 := ' ';
    v_cli_txt_2 := ' ';
  else
    v_cli_txt_1 := substr(v_cli_txt, 1, 19);
    v_cli_txt_1 := ltrim(rtrim(v_cli_txt_1));
  end if;
  if length(v_cli_txt) > 19 then
    v_cli_txt_2 := substr(v_cli_txt, 20, 20);
    v_cli_txt_2 := ltrim(rtrim(v_cli_txt_2));
  end if;
  v_cli_txt_1 := nvl(v_cli_txt_1, ' ');
  v_cli_txt_2 := nvl(v_cli_txt_2, ' ');
  
  --orden1 en el talon
  p_cheque_dato := p_cheque_dato ||
     rpad(v_cli_txt_1, 19, ' ')
     ||lpad(' ', 46, ' ')
  ;
  
  -- fecha en letras y monto total del cheque
  if v_transaccion_moneda = c_transaccion_guaranies then
    p_cheque_dato := p_cheque_dato ||
       rpad(' ', 60, ' ')
       ||lpad(to_char(vfecvto,'DD'),4, ' ')
       ||lpad(' ', 11, ' ')
       ||initcap(rpad(rtrim(to_char(vfecvto,'month')), 10, ' '))||'  '
       ||lpad(to_char(vfecvto,'YYYY'), 14, ' ')    
       ||lpad(' ', 10, ' ')    
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#'
    ;
  else
    --transaccion en dolares.
    p_cheque_dato := p_cheque_dato ||
       rpad(' ', 60, ' ')
       ||lpad(to_char(vfecvto,'DD'),4, ' ')
       ||lpad(' ', 8, ' ')
       ||initcap(rpad(rtrim(to_char(vfecvto,'month')), 10, ' '))||'  '
       ||lpad(to_char(vfecvto,'YYYY'), 14, ' ')    
       ||lpad(' ', 15, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 15, '#')||'#'
    ;
  end if;
  
  --orden2 en el talon
  p_cheque_dato := p_cheque_dato ||
     rpad(v_cli_txt_2, 21, ' ')
  ;
  
  p_cheque_dato := p_cheque_dato || chr(10); -- 1 lineas en blanco
  
  --concepto
  v_obs_txt := rtrim(vobs);
  if v_obs_txt is null then
    v_obs_txt_1 := ' ';
    v_obs_txt_2 := ' ';
  else
    v_obs_txt_1 := substr(v_obs_txt, 1, 14);
    if length(v_obs_txt) > 14 then
      v_obs_txt_2 := substr(v_obs_txt, 15, 26);
    else
      v_obs_txt_2 := ' ';
    end if;
  end if;
  v_obs_txt_1 := nvl(v_obs_txt_1,' ');
  v_obs_txt_2 := nvl(v_obs_txt_2,' ');
  
  --concepto1 en el talon (14 primeras letras)
  p_cheque_dato := p_cheque_dato ||
     lpad(' ', 1,' ')
     ||rpad(v_obs_txt_1,14, ' ')
  ;
  
  p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(20); --interespaciado 1/6 *** 25
  
  --concepto2 en el talon y orden en el cheque
  p_cheque_dato := p_cheque_dato ||
     lpad(' ', 4, ' ')
     ||rpad(v_obs_txt_2, 32, ' ')
     ||rpad(vbenef, 100, ' ')
  ;
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10); -- 1 linea en blanco
  
  p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(25); --interespaciado 1/6 *** 25
  
  --total factura en letras (1ra. linea)
  if v_transaccion_moneda = c_transaccion_guaranies then
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 42, ' ')
       ||rpad(v_num_txt_1, 95, ' -')
    ;
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10); -- 2 linea en blanco
    
    --total factura en letras (2da. linea)
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 28, ' ')
       ||rpad(nvl(v_num_txt_2, '-'), 64, ' -')
    ;
  
  else
    --transaccion en dolares.
    if length(v_num_txt_1) > 85 then
      --supera los 95 caracteres utilizados en "gs", entonces lo 
      --cortamos (10 caracteres) y a?adimos en la segunda linea.
      v_num_txt_1_us := substr(v_num_txt_1,1,85);
      v_num_txt_2_us := substr(v_num_txt_1,86)||v_num_txt_2;
    else
      v_num_txt_1_us := v_num_txt_1;
      v_num_txt_2_us := v_num_txt_2;
    end if;
    
    --iniciamos la impresion del monto en letras.
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',45, ' ')
       ||rpad(v_num_txt_1_us, 85, ' -')
    ;
        
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10); --2 linea en blanco
    
    --la segunda linea no lo tocamos, queda como en la primitiva.     
    --total factura en letras (2da. linea)
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 28, ' ')
       ||rpad(nvl(v_num_txt_2_us, '-'), 64, ' -')
    ;
  end if;
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10); --3 lineas en blanco
  
  --monto total del cheque
  p_cheque_dato := p_cheque_dato ||
    --tres espacios en blanco a la izquierda porque imprime sobre 'cheque' "cheque xxx.xxx,00"'
    lpad(' ',3,' ')||rpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 20, ' ')
  ;
  
  --text_io.new_line(v_impresora,4); --4 lineas en blanco
  
  p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(25); --interespaciado 1/6 *** 25
  
 
   p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10);
  
  -----cargar  en la tabla
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
end;
--------------------------------

--------------------------------pl_cheque_interbanco_dif
procedure pl_cheque_interbanco_dif(
                                   vclavecheque in number, 
                                   p_form_impr  in number) is
  
  v_num_txt       varchar2(200) := ' ';
  v_num_txt_1     varchar2(90) := ' ';
  v_num_txt_2     varchar2(105) := ' ';
  v_num_txt_3     varchar2(95) := ' ';
  
  v_obs_txt       varchar2(40) := ' ';
  v_obs_txt_1     varchar2(20) := ' ';
  v_obs_txt_2     varchar2(26) := ' ';
  v_obs_txt_3     varchar2(26) := ' ';
  
  v_formato       varchar2(20);
  v_formato_loc   varchar2(20);
  v_formato_cant  varchar2(20);
  v_cli_txt       varchar2(50) := ' ';
  v_cli_txt_1     varchar2(20) := ' ';
  v_cli_txt_2     varchar2(21) := ' ';
  
  vformatocant    varchar2(20);
  vformatoimp     varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc         date;
  vfecvto         date;
  vtotmon         number;
  vbenef          varchar2(80);
  vmondecimp      number;
  vobs            varchar2(40);
  vnrocheq        varchar2(30);
  vserie          varchar2(2);
  vindi_dia_dife           varchar2(4);
  
  c_transaccion_guaranies     constant varchar2(2) := 'GS';
  c_transaccion_dolares       constant varchar2(2) := 'US';
  
  --variable que tomara el tipo de transaccion (moneda).
  v_transaccion_moneda                 varchar2(2);
  
  v_num_txt_1_us                       v_num_txt_1%type := ' '; 
  v_num_txt_2_us                       v_num_txt_2%type := ' ';
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
begin
  --seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);


  
  
  -------------------------------------------------------------------------------
  --------------------------      m  o  n  e  d  a     --------------------------
  -------------------------------------------------------------------------------
  -- ba: hoy dia 20-12-2006 tenemos una sola moneda para diferidos de interbanco.
  -- si es necesario, entonces estariamos utilizando la siguiente variable 
  -- "v_transaccion_moneda", por el momento no lo utilizamos pero ya lo prevemos.
  -------------------------------------------------------------------------------
  
  
  --verificamos el formato para conocer la moneda.
  if (PARAMETER.P_FORMATO_IMPRESION) = 'IBCO$_DIF' then
    --transaccion en dolares.
    v_transaccion_moneda := c_transaccion_dolares;
  else
    v_transaccion_moneda := c_transaccion_guaranies;
  end if;
  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
  
  --se envia dos veces la misma instruccion, porque si se enciende
  --la impresora despues de iniciado windows , entonces la primera
  --instruccion no se ejecuta.
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
  
  p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  
   p_cheque_dato := p_cheque_dato || chr(10);
  
  --fecha del cheque en el talon
  p_cheque_dato := p_cheque_dato ||
     --mascaras con espacio en blanco a la izquierda.
     rpad(to_char(vfecdoc,'DD/MM/YYYY'),21, ' ')
  ;
  
  p_cheque_dato := p_cheque_dato || chr(10); --1 linea en blanco
  
  --fecha de vencimiento en talon
  --fecha de emision en cheque.
  p_cheque_dato := p_cheque_dato ||
     rpad(to_char(vfecvto,'DD/MM/YYYY'),26,' ')
     ||lpad(' ',43,' ')
     ||lpad(to_char(vfecdoc,'DD'),4, ' ')
     ||lpad(' ', 6, ' ')
     ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 10, ' '))||'  '
     ||lpad(to_char(vfecdoc,'YYYY'), 12, ' ')    
  ;
    
  --separar "orden" para que imprima en 2 lineas
  v_cli_txt := ltrim(rtrim(vbenef)); --quitar espacios a la izquierda y a la derecha
  if v_cli_txt is null then
    v_cli_txt_1 := ' ';
    v_cli_txt_2 := ' ';
  else
    v_cli_txt_1 := substr(v_cli_txt, 1, 19);
  end if;
  if length(v_cli_txt) > 19 then
    v_cli_txt_2 := substr(v_cli_txt, 20, 21);
  end if;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --1/6.
  
  --orden1 en el talon.
  --monto del cheque.
  p_cheque_dato := p_cheque_dato ||
     rpad(v_cli_txt_1, 19, ' ')
     ||lpad(' ', 98,' ')
     ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#'
  ;
  
  v_obs_txt := rtrim(vobs);
  if v_obs_txt is null then
    v_obs_txt_1 := ' ';
    v_obs_txt_2 := ' ';
  else
    v_obs_txt_1 := substr(v_obs_txt, 1, 19);
    if length(v_obs_txt) > 19 then
      v_obs_txt_2 := substr(v_obs_txt, 20, 40);
    else
      v_obs_txt_2 := ' ';
    end if;
  end if;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --1/8.
  
  --concepto en talon.
  --fecha de vencimiento
  p_cheque_dato := p_cheque_dato ||
     rpad(v_obs_txt_1,19, ' ')
     ||lpad(' ', 50, ' ')
     ||lpad(to_char(vfecvto,'DD'),4, ' ')
     ||lpad(' ', 6, ' ')
     ||initcap(rpad(rtrim(to_char(vfecvto,'month')), 10, ' '))||'  '
     ||lpad(to_char(vfecvto,'YYYY'), 12, ' ')    
  ;
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2';
  
  --paguese a la orden de
  p_cheque_dato := p_cheque_dato ||
     lpad(' ',35,' ')
     ||rpad(vbenef, 80, ' ')
  ;
  
   p_cheque_dato := p_cheque_dato || chr(10);
  
  --total en letras.
  if v_num_txt_2 is null then
    p_cheque_dato := p_cheque_dato || 
       lpad(' ',43,' ')
       ||rpad(v_num_txt_1,90,' -')
    ;
     p_cheque_dato := p_cheque_dato || chr(10);
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',24,' ')
       ||lpad(' -',50,' -')
    ;
  else
    p_cheque_dato := p_cheque_dato || 
       lpad(' ',43,' ')
       ||v_num_txt_1
    ;
     p_cheque_dato := p_cheque_dato || chr(10);
    p_cheque_dato := p_cheque_dato || 
       lpad(' ',24,' ')
       ||v_num_txt_2
       ||lpad(' -',8,' -')
    ;
  end if;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --1/6.
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
  
  --monto total del cheque.
  p_cheque_dato := p_cheque_dato ||
    lpad(' ',3,' ')
    ||rpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 20, ' ')
  ;   
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10);
  
  
   -----cargar  en la tabla
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
end;
--------------------------------

--------------------------------pl_cheque_bbva
procedure pl_cheque_bbva( vclavecheque   in number, 
                         p_form_impr    in number) is
  
  v_num_txt      varchar2(200):= ' ';
  v_num_txt_1    varchar2(95):= ' ';
  v_num_txt_2    varchar2(105):= ' ';
  v_num_txt_3    varchar2(95):= ' ';
  
  v_obs_txt      varchar2(45):= ' ';
  v_obs_txt_1    varchar2(20):= ' ';
  v_obs_txt_2    varchar2(20):= ' ';
  v_obs_txt_3    varchar2(20):= ' ';
  
  v_formato      varchar2(20);
  v_formato_loc  varchar2(20);
  v_formato_cant varchar2(20);
  v_cli_txt      varchar2(60):= ' ';
  v_cli_txt_1    varchar2(27):= ' ';
  v_cli_txt_2    varchar2(27):= ' ';
  
  vformatocant   varchar2(20);
  vformatoimp    varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc        date;
  vfecvto        date;
  vtotmon        number;
  vbenef         varchar2(80);
  vmondecimp     number;
  vobs           varchar2(45);
  vnrocheq       number;
  vserie         varchar2(2);
  vindi_dia_dife          varchar2(4);
  
  --ba: 23-10-2006 (impresion de cheques bbva_gs y preparamos la opcion de us).
  c_transaccion_guaranies constant varchar2(2):= 'GS';
  c_transaccion_dolares   constant varchar2(2):= 'US';
  
  --variable que tomara el tipo de transaccion (moneda).
  v_transaccion_moneda varchar2(2);
  
  --variables para los totales en letras.
  v_num_txt_1_us       v_num_txt_1%type:= ' ';
  v_num_txt_2_us       v_num_txt_2%type:= ' ';
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
begin
  
  --buscamos los datos del cheque.
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  
  
  
  --verificamos y definimos el modo de transaccion (moneda)
  if p_form_impr = 13 then
    --transaccion en guaranies.
    v_transaccion_moneda := c_transaccion_guaranies;
  else
    
    --aqui preparo el programa para agregar la impresion con alguna
    --otra moneda que no fuese la de guaranies.
    ------------------------------------------------
    --v_transaccion_moneda := c_transaccion_dolares;
    ------------------------------------------------
    raise_application_error(-20001,'No existe otro formato de impresi?n en BBVA que no fuera Guaran?es.');
    return;
    
  end if;
  
  --mascara del formato.
  vformatocant := '99990D00';
  vformatoimp  := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  
  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
  

  --------------------------------------
  --primero trabajamos por la impresora.
  --------------------------------------
  --se envia dos veces la misma instruccion, porque si se enciende
  --la impresora despues de iniciado windows , entonces la primera
  --instruccion no se ejecuta.
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
 
  p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora

  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
  
  p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer a 1/6 (inch line spacing)
  
  
  --------------------------
  --luego con las variables.
  --------------------------
  --separamos la orden para que lo imprima en dos lineas.
  v_cli_txt := ltrim(rtrim(vbenef));
  if length(v_cli_txt) > 18 then
    v_cli_txt_1 := nvl(ltrim(rtrim(substr(v_cli_txt, 1, 18))),' ');
    v_cli_txt_2 := nvl(ltrim(rtrim(substr(v_cli_txt,19, 18))),' ');
  else
    v_cli_txt_1 := nvl(ltrim(rtrim(substr(v_cli_txt,1,18))),' ');
    v_cli_txt_2 := ' ';
  end if;
  
  --partimos el concepto(observacion 'doc_obs') en dos variables.
  v_obs_txt := rtrim(vobs);
  if v_obs_txt is null then
    v_obs_txt_1 := ' ';
    v_obs_txt_2 := ' ';
  else
    --si mayor a 14 caracteres lo partimos en dos.
    --estas lineas son a modo de entendimiento nada mas.
    if length(v_obs_txt) > 18 then
      v_obs_txt_1 := nvl(ltrim(rtrim(substr(v_obs_txt, 1, 18))),' ');
      v_obs_txt_2 := nvl(ltrim(rtrim(substr(v_obs_txt,19, 18))),' ');
    else
      v_obs_txt_1 := nvl(ltrim(rtrim(substr(v_obs_txt, 1, 18))),' ');
      v_obs_txt_2 := ' ';
    end if;
  end if;
  
  
  -----------------------------
  --ahora empezamos a imprimir.
  -----------------------------
  
  --------------------------
  --cheque : monto(numeros).
  --------------------------
  p_cheque_dato := p_cheque_dato || chr(10);
  p_cheque_dato := p_cheque_dato ||
    lpad(' ',117,' ')||
    lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#'
  ;
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  
  ----------------
  --talo : fecha.
  ----------------
  p_cheque_dato := p_cheque_dato ||
    rpad(to_char(vfecdoc,'DD/MM/YYYY'),19, ' ')
  ; 
  p_cheque_dato := p_cheque_dato || chr(10);
  ----------------------------
  --talo : cliente(linea uno).
  --cheque : fecha en letras.
  ----------------------------
  p_cheque_dato := p_cheque_dato ||
    rpad(v_cli_txt_1, 20, ' ')||
    rpad(' ', 64, ' ')||
    --fecha del cheque (dd/month/yyyy).
    lpad(to_char(vfecdoc,'DD'),4, ' ')||
    lpad(' ', 5, ' ')||
    initcap(rpad(rtrim(to_char(vfecdoc,'month')), 20, ' '))||
    lpad(' ', 9, ' ')||
    lpad(to_char(vfecdoc,'YYYY'), 10, ' ')
  ;
  
  ------------------------------
  --talo   : cliente(linea dos).
  ------------------------------
  p_cheque_dato := p_cheque_dato ||
    --cliente(segunda linea).
    v_cli_txt_2
  ;  
  
  ------------------------
  --cheque : beneficiario.
  ------------------------
  p_cheque_dato := p_cheque_dato ||
    lpad(' ', 38, ' ')||
    rpad(vbenef, 100, ' ')
  ;
  
  ----------------------------------------------
  --talon  : concepto(observacion del documento. 
  ----------------------------------------------
  p_cheque_dato := p_cheque_dato ||
    v_obs_txt_1
  ;

  -----------------------------------
  --talon  : concepto(segunda linea).
  -----------------------------------
  p_cheque_dato := p_cheque_dato ||
    v_obs_txt_2
  ;
  
  ---------------------------------
  --cheque : total factura(letras).
  ---------------------------------
  if v_transaccion_moneda = c_transaccion_guaranies then
    --guaranies.
    --en letras(1ra. linea).
    p_cheque_dato := p_cheque_dato ||
         lpad(' ', 38, ' ')||
         rpad(v_num_txt_1, 92, ' -')
        ;
    p_cheque_dato := p_cheque_dato || chr(10);
    --en letras(2da. linea).
    p_cheque_dato := p_cheque_dato ||
         lpad(' ', 25, ' ')||
         rpad(nvl(v_num_txt_2, '-'), 60, ' -')
        ;
        
  else
    --ba 23-10-2006: transaccion en alguna otra moneda.
    --no existe otra moneda con este banco(pero preparamos el programa para ello).
    null;
  end if;
  
  --5 lineas en blanco.
 
  p_cheque_dato := p_cheque_dato ||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10);
  
  --monto total del cheque en talo
  p_cheque_dato := p_cheque_dato ||
    lpad(nvl(to_char(vtotmon, vformatoimp,'NLS_NUMERIC_CHARACTERS = '',.''')||'.-',' '), 18, ' ');
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer a 1/6 (inch line spacing)
   p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10); --4 lineas en blanco
  
  
   -----cargar  en la tabla
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
end;
--------------------------------

--------------------------------pl_cheque_sudameris
procedure pl_cheque_sudameris(
                              vclavecheque   in number, 
                              p_form_impr    in number) is
  v_num_txt      varchar2(200):= ' ';
  v_num_txt_1    varchar2(90):= ' ';
  v_num_txt_2    varchar2(105):= ' ';
  v_num_txt_3    varchar2(95):= ' ';
  
  v_obs_txt      varchar2(40):= ' ';
  v_obs_txt_1    varchar2(20):= ' ';
  v_obs_txt_2    varchar2(26):= ' ';
  v_obs_txt_3    varchar2(26):= ' ';
  
  v_formato      varchar2(20);
  v_formato_loc  varchar2(20);
  v_formato_cant varchar2(20);
  v_cli_txt      varchar2(50):= ' ';
  v_cli_txt_1    varchar2(20):= ' ';
  v_cli_txt_2    varchar2(21):= ' ';
  
  vformatocant   varchar2(20);
  vformatoimp    varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc        date;
  vfecvto        date;
  vtotmon        number;
  vbenef         varchar2(80);
  vmondecimp     number;
  vobs           varchar2(40);
  vnrocheq       varchar2(30);
  vserie         varchar2(2);
  vindi_dia_dife          varchar2(4);

  --ba: 23-10-2006 (impresion de cheques sudameris us y preparamos la opcion de gs).
  c_transaccion_dolares   constant varchar2(2):= 'US';
  c_transaccion_guaranies constant varchar2(2):= 'GS';
  
  --variable que tomara el tipo de transaccion (moneda).
  v_transaccion_moneda varchar2(2);
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
begin
  --buscamos los datos del cheque.
  
  
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  
  
 
  
  
  --verificamos y definimos el modo de transaccion (moneda)
  if p_form_impr = 14 then
    --transaccion en dolares.
    v_transaccion_moneda := c_transaccion_dolares;
  else
    
    --aqui preparo el programa para agregar la impresion con alguna
    --otra moneda que no fuese la de dolares.
    ------------------------------------------------
    --v_transaccion_moneda := c_transaccion_guaranies;
    ------------------------------------------------
    raise_application_error(-20001,'No existe otro formato de impresi?n en BBVA que no fuera D?lares.');
    return;
    
  end if;
  
  
  --mascara del formato.
  vformatocant := '99990D00';
  vformatoimp  := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  
  pl_separar_texto_lib(v_num_txt, 85, 85, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 85, v_num_txt_2, v_num_txt_3);
  
  
  
  --------------------------------------
  --primero trabajamos por la impresora.
  --------------------------------------
  --se envia dos veces la misma instruccion, porque si se enciende
  --la impresora despues de iniciado windows , entonces la primera
  --instruccion no se ejecuta.

  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
  
  p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
  
  
  
  
  --------------------------
  --luego con las variables.
  --------------------------
  --separamos la orden para que lo imprima en dos lineas.
  v_cli_txt := ltrim(rtrim(vbenef));
  if v_cli_txt is null then
    v_cli_txt_1 := ' ';
    v_cli_txt_2 := ' ';
  else
    v_cli_txt_1 := substr(v_cli_txt, 1, 20);
  end if;
  
  if length(v_cli_txt) > 20 then
    v_cli_txt_2 := substr(v_cli_txt, 21, 20);
  end if;
  
  --separamos el concepto(observacion 'doc_obs') en dos variables.
  v_obs_txt := rtrim(vobs);
  if v_obs_txt is null then
    v_obs_txt_1 := ' ';
    v_obs_txt_2 := ' ';
  else
    --si mayor a 19 caracteres lo partimos en dos.
    --estas lineas son a modo de entendimiento nada mas.
    if length(v_obs_txt) > 19 then
      v_obs_txt_1 := substr(v_obs_txt, 1, 19);
      v_obs_txt_2 := substr(v_obs_txt, 20, 19);
    else
      v_obs_txt_1 := substr(v_obs_txt, 1, 19);
      v_obs_txt_2 := ' ';
    end if;
  end if;
  
  
  -----------------------------
  --ahora empezamos a imprimir.
  -----------------------------
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --1/6
  
   p_cheque_dato := p_cheque_dato || chr(10);
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  
  p_cheque_dato := p_cheque_dato || chr(10);-------2
  
  -----------------
  --talo : fecha.
  -----------------
  p_cheque_dato := p_cheque_dato ||
     lpad(' ',1,' ')
     ||rpad(to_char(vfecdoc,'DD/MM/YYYY'),19, ' ')
     ||lpad(' ',100,' ')
     --cheque : monto(numeros).
     ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#'
  ; 
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);--------1
  
  ----------------------------
  --talo : cliente(linea uno).
  ----------------------------
  p_cheque_dato := p_cheque_dato ||
     rpad(v_cli_txt_1, 20, ' ')
     ||lpad(' ',80,' ')---33
     --cheque : fecha en letras.
     ||lpad(to_char(vfecdoc,'DD'),4, ' ')
     ||lpad(' ', 8, ' ')---5
     ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 15, ' '))----18
     ||lpad(to_char(vfecdoc,'YYYY'), 10, ' ')
  ;
  
  ------------------------------
  --talo   : cliente(linea dos).
  ------------------------------
  p_cheque_dato := p_cheque_dato ||
     --cliente(segunda linea).
     rpad(v_cli_txt_2, 20, ' ')
  ;  
  
  
  ----------------------------------------------------------------------
  --talon  : concepto(observacion del documento 20 primeros caracteres).
  ----------------------------------------------------------------------
  p_cheque_dato := p_cheque_dato ||
     lpad(' ', 1, ' ')||
     rpad(v_obs_txt_1,20, ' ')
  ;

  -----------------------------------
  --talon  : concepto(segunda linea).
  --cheque : beneficiario.
  -----------------------------------
  p_cheque_dato := p_cheque_dato ||
     lpad(' ', 1, ' ')||
     rpad(v_obs_txt_2, 44, ' ')||-------37
     rpad(vbenef, 90, ' ')-------80
  ;
  --una linea en blanco.
  p_cheque_dato := p_cheque_dato || chr(10);
  
  ---------------------------------
  --cheque : total factura(letras).
  ---------------------------------
  if v_transaccion_moneda = c_transaccion_dolares then
    --dolares.
    --en letras(1ra. linea).
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 44, ' ')
       ||rpad(v_num_txt_1, 90, ' -')
    ;
    p_cheque_dato := p_cheque_dato || chr(10);
    --en letras(2da. linea).
    if length(nvl(v_num_txt_2,'-')) < 40 then
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 30, ' ')
         ||rpad(nvl(v_num_txt_2, '-'), 40, ' -')
      ;
    else
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 30, ' ')
         ||nvl(v_num_txt_2, '-')||rpad(' - ',5,' -')
      ;
    end if;
  else
    --ba 23-10-2006: transaccion en alguna otra moneda.
    --no existe otra moneda con este banco(pero preparamos el programa para ello).
    null;
  end if;
  
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --1/6
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --1/8
  
   p_cheque_dato := p_cheque_dato || chr(10);
  
  --monto total del cheque en talo
  p_cheque_dato := p_cheque_dato ||
     lpad(nvl(to_char(vtotmon,vformatoimp,'NLS_NUMERIC_CHARACTERS = '',.''')||'.-',' '),16,' ')
  ;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --1/6
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10);
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --1/8
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10); --2 lineas en blanco
  
  
  
   -----cargar  en la tabla
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
end;
--------------------------------

--------------------------------pl_cheque_fomento_dif
procedure pl_cheque_fomento_dif(vclavecheque  in number, 
                                p_form_impr   in number) is
/* ba 09-12-2006: 
 * formato de impresion realizado para casa centro.
 * banco nacional de fomento diferido.
 */
  v_num_txt        varchar2(200) := ' ';
  v_num_txt_1      varchar2(100) := ' ';
  v_num_txt_2      varchar2(105) := ' ';
  v_num_txt_3      varchar2(105) := ' ';
  
  v_obs_txt        varchar2(40) := ' ';
  v_obs_txt_1      varchar2(21) := ' ';
  v_obs_txt_2      varchar2(19) := ' ';
  v_obs_txt_3      varchar2(19) := ' ';
  
  v_formato        varchar2(20);
  v_formato_loc    varchar2(20);
  v_formato_cant   varchar2(20);
  
  vformatocant     varchar2(20);
  vformatoimp      varchar2(20);
  
  --datos que se obtienen del select
  vfecdoc          date;
  vfecvto          date;
  vtotmon          number;
  vbenef           varchar2(80);
  vmondecimp       number;
  vobs             varchar2(40);
  vnrocheq         varchar2(30);
  vserie           varchar2(2);
  vindi_dia_dife            varchar2(4);

  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);  
begin
  --select para datos del cheque.
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  

  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;

  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
 
  v_obs_txt := vobs;

  pl_separar_texto_lib(v_obs_txt, 21, 21, v_obs_txt_1, v_obs_txt_2); 
  pl_separar_texto_lib(v_obs_txt_2,19, 10, v_obs_txt_2, v_obs_txt_3);
  
  v_obs_txt_1 := nvl(v_obs_txt_1, ' ');
  v_obs_txt_2 := nvl(v_obs_txt_2, ' ');
  
  -- se envia dos veces la misma instruccion, porque si se enciende
  -- la impresora despues de iniciado windows , entonces la primera
  -- instruccion no se ejecuta.
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
  
  p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);--2 linea en blanco
  
  --fecha del documento y el monto del cheque.
  p_cheque_dato := p_cheque_dato || 
     lpad(to_char(vfecdoc,'DD'),2, ' ')||'/'
     ||lpad(to_char(vfecdoc,'MM'),2, ' ')||'/'
     ||lpad(to_char(vfecdoc,'YYYY'),4, ' ')
     ||lpad(' ',100,' ')
     ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 16, '#')
     ||'#'
  ;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
  
  --fecha de cobro del cheque.
  p_cheque_dato := p_cheque_dato ||
     lpad(to_char(vfecvto,'DD'),6, ' ')||'/'
     ||lpad(to_char(vfecvto,'MM'),2, ' ')||'/'
     ||lpad(to_char(vfecvto,'YYYY'),4, ' ')
  ;
  
  --orden del talonario con la fecha cheque y fecha cobro(pago).
  p_cheque_dato := p_cheque_dato ||
     --a la orden de...
     rpad(substr(vbenef,1,18),18,' ')
  ;
  
  --fecha de emision del cheque y fecha de pago (diferido).
    p_cheque_dato := p_cheque_dato ||
     lpad(substr(v_obs_txt_1,1,18),18,' ')||
     --fecha de documento.
     lpad(' ',23,' ')||
     lpad(to_char(vfecdoc,'DD'),2,' ')||
     lpad(' ',6,' ')||
     initcap(rpad(rtrim(to_char(vfecdoc,'month')), 26, ' '))||
     lpad(to_char(vfecdoc,'YYYY'), 4, ' ')||
     --fecha de pago.
     lpad(' ',23,' ')||
     lpad(to_char(vfecvto,'DD'),2,' ')||
     lpad(' ',5,' ')||
     initcap(rpad(rtrim(to_char(vfecvto,'month')), 21, ' '))||
     lpad(to_char(vfecvto,'YYYY'), 4, ' ')
  ;
  
  --una linea en blanco.
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
   p_cheque_dato := p_cheque_dato || chr(10);
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
  
  --paguese por este cheque a.
  p_cheque_dato := p_cheque_dato ||
     lpad(' ', 46, ' ')
     ||rpad(vbenef, 80, ' ')
  ;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
  
  --total factura en letras.
  if v_num_txt_2 is null or v_num_txt_2 = ' ' then
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 41, ' ')
       ||rpad(v_num_txt_1, 95, ' -')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
    
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 26, ' ')||
       lpad('- ',57,'- ')
    ;
  else
    
    --total monto en letras.
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 42, ' ')
       ||rpad(v_num_txt_1, 95, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
    
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 22, ' ')
       ||rpad(v_num_txt_2,70,' -')
    ;
  end if;
  
  --text_io.new_line(v_impresora,1);
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)  
  p_cheque_dato := p_cheque_dato || chr(10);
  
  --monto total del cheque en "menos este cheque".
  p_cheque_dato := p_cheque_dato ||
     lpad(' ',7,' ')||
     nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' ')
  ;
  --text_io.new_line(v_impresora,1);
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10);

end;
--------------------------------

--------------------------------pl_cheque_abn_dif
procedure pl_cheque_abn_dif(
                            vclavecheque in number, 
                            p_form_impr  in number) is
  
  v_num_txt        varchar2(200) := ' ';
  v_num_txt_1      varchar2(100) := ' ';
  v_num_txt_2      varchar2(105) := ' ';
  v_num_txt_3      varchar2(105) := ' ';
  
  v_obs_txt        varchar2(40) := ' ';
  v_obs_txt_1      varchar2(21) := ' ';
  v_obs_txt_2      varchar2(19) := ' ';
  v_obs_txt_3      varchar2(19) := ' ';
  
  v_benef_txt_1    varchar2(20) := ' ';
  v_benef_txt_2    varchar2(20) := ' ';
  
  v_formato        varchar2(20);
  v_formato_loc    varchar2(20);
  v_formato_cant   varchar2(20);
  
  vformatocant     varchar2(20);
  vformatoimp      varchar2(20);
  
  --datos que se obtienen del select
  vfecdoc          date;
  vfecvto          date;
  vtotmon          number;
  vbenef           varchar2(80);
  vmondecimp       number;
  vobs             varchar2(40);
  vnrocheq         number;
  vserie           varchar2(2);
  vindi_dia_dife            varchar2(4);
  
  --variables para distici?n de monedas.
  c_dolares   constant varchar2(3) := 'U$S';
  c_guaranies constant varchar2(3) := 'GS';
  v_moneda             varchar2(3);
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
begin
  --seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  
  
  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  
  pl_separar_texto_lib(v_num_txt, 87, 87, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 87, v_num_txt_2, v_num_txt_3);
  
  v_obs_txt := vobs;
  
  v_obs_txt_1 := nvl(substr(v_obs_txt, 1,20),' ');
  v_obs_txt_2 := nvl(substr(v_obs_txt,21,40), ' ');
  
  --cortamos la descripcion del cliente.
  v_benef_txt_1 := nvl(substr(vbenef, 1, 20),' ');
  v_benef_txt_2 := nvl(substr(vbenef,21, 20),' ');
  
  
  ----------------------------------------------------
  ---- asignamos la moneda en la que trabajaremos ----
  ----------------------------------------------------
  if p_form_impr = 22 then
    v_moneda := c_guaranies;
  elsif p_form_impr = 16 then
    v_moneda := c_dolares;
  end if;
  
  ----------------------------
  --moneda en dolares(u$s)...!
  ----------------------------
  
  if v_moneda = c_dolares then
  
    -- se envia dos veces la misma instruccion, porque si se enciende
    -- la impresora despues de iniciado windows , entonces la primera
    -- instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
    
     p_cheque_dato := p_cheque_dato || chr(10);
    
    --fecha del cheque en el talon
    p_cheque_dato := p_cheque_dato ||
       lpad(to_char(vfecdoc,'DD'),3, ' ')||'/'||
       lpad(to_char(vfecdoc,'MM'),2, ' ')||'/'||
       lpad(to_char(vfecdoc,'YYYY'),4, ' ')
    ;
    
     p_cheque_dato := p_cheque_dato || chr(10);
    
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
    
     p_cheque_dato := p_cheque_dato || chr(10);
    
    --orden en el tal?n, fecha en letras y monto del cheque
    p_cheque_dato := p_cheque_dato ||
      rpad(nvl(v_benef_txt_1,' '),23, ' ')||
      lpad(' ', 91, ' ')||
      lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 15, '#')||
      '#'
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2';
    p_cheque_dato := p_cheque_dato ||
       rpad(v_benef_txt_2, 23, ' ')
    ;
    p_cheque_dato := p_cheque_dato || chr(27)||'0';
    
    --concepto 1ra. l?nea
    p_cheque_dato := p_cheque_dato ||
       rpad(v_obs_txt_1, 21, ' ')||
       rpad(' ',19,' ')||
       rpad(to_char(vfecvto,'DD'),3, ' ')||lpad(' ', 4, ' ')||
       initcap(rpad(rtrim(to_char(vfecvto,'month')), 12, ' '))||
       lpad(to_char(vfecvto,'YYYY'), 10, ' ')||
       rpad(' ',25, ' ')|| 
       rpad(to_char(vfecdoc,'DD'),3, ' ')||lpad(' ', 4, ' ')||
       initcap(rpad(rtrim(to_char(vfecdoc,'month')), 12, ' '))||
       lpad(to_char(vfecdoc,'YYYY'), 14, ' ')
    ;
    
    --concepto 2da. l?nea
    p_cheque_dato := p_cheque_dato ||
       rpad(v_obs_txt_2, 21, ' ')
    ;
    
    --p?guese a la orden de.
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 44, ' ')||
       rpad(vbenef, 100, ' ')
    ;
    
    --monto del cheque en letras.
     p_cheque_dato := p_cheque_dato || chr(10);
    if v_num_txt_2 is null or v_num_txt_2 = ' ' then
      --monto del cheque en letras 1ra linea
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 44, ' ')
         ||rpad(v_num_txt_1, 88, ' -')
      ;
    
      p_cheque_dato := p_cheque_dato || chr(10); -- 1 lineas en blanco
    
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 27, ' ')
         ||'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - '
         ||'- - - - - -'
      ;
    else
      --monto del cheque en letras 1ra linea
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 44, ' ')
         ||rpad(v_num_txt_1, 88, ' ')
      ;
      
       p_cheque_dato := p_cheque_dato || chr(10); --1 linea en blanco
      
      --monto del cheque en letras 2da linea
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 26, ' ')
        ||rpad(v_num_txt_2,69,' -')
      ;
    end if;
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10); -- 2 lineas en blanco
    
    --monto del cheque en el tal?n
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 2, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 16, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --1/6
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10);
  
  
  -----------------------------
  --moneda en guaranies(gs)...!
  -----------------------------
  elsif v_moneda = c_guaranies then
    
    -------------------------------------------
    -- ba 29-01-2007: este formato no existe --
    -------------------------------------------
    
    -- se envia dos veces la misma instruccion, porque si se enciende
    -- la impresora despues de iniciado windows , entonces la primera
    -- instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
    
     p_cheque_dato := p_cheque_dato || chr(10);
    
    --fecha del cheque en el talon
    p_cheque_dato := p_cheque_dato || 
       rpad(' ',5,' ')
       ||lpad(to_char(vfecdoc,'DD'),3, ' ')||'/'
       ||lpad(to_char(vfecdoc,'MM'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'YYYY'),4, ' ')
    ;
    
     p_cheque_dato := p_cheque_dato || chr(10);
    
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
    
     p_cheque_dato := p_cheque_dato || chr(10);
    
    --orden en el tal?n, fecha en letras y monto del cheque
    p_cheque_dato := p_cheque_dato || 
      rpad(' ',5,' ')
      ||rpad(v_benef_txt_1,23, ' ')
      ||lpad(' ', 42, ' ')
      ||rpad(to_char(vfecdoc,'DD'),3, ' ')||lpad(' ', 4, ' ')
      ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 12, ' '))
      ||lpad(to_char(vfecdoc,'YYYY'), 17, ' ')
      ||rpad(' ',13, ' ')
      ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 15, '#')
      ||'#'
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2';
    p_cheque_dato := p_cheque_dato ||
       rpad(' ',5,' ')
       ||rpad(v_benef_txt_2, 23, ' ')
    ;
    p_cheque_dato := p_cheque_dato || chr(27)||'0';
    
    --concepto 1ra. l?nea
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 6, ' ')
       ||rpad(v_obs_txt_1, 21, ' ')
    ;
    
    --concepto 2da. l?nea
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 6, ' ')
       ||rpad(v_obs_txt_2, 21, ' ')
       ||lpad(' ',20,' ')
       ||rpad(vbenef, 100, ' ')
    ;
    
    --monto del cheque en letras.
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
    if v_num_txt_2 is null or v_num_txt_2 = ' ' then
      --monto del cheque en letras 1ra linea
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 46, ' ')
         ||rpad(v_num_txt_1, 89, ' -')
      ;
    
      p_cheque_dato := p_cheque_dato || chr(10); -- 1 lineas en blanco
    
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 30, ' ')
         ||'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - '
         ||'- - - - - -'
      ;
    else
      --monto del cheque en letras 1ra linea
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 46, ' ')
         ||rpad(v_num_txt_1, 89, ' ')
      ;
    
       p_cheque_dato := p_cheque_dato || chr(10); --1 linea en blanco
      
      --monto del cheque en letras 2da linea
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 30, ' ')
        ||rpad(v_num_txt_2,69,' -')
      ;
    end if;
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10); -- 2 lineas en blanco
    
    --monto del cheque en el tal?n
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 8, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 16, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --1/6
  
     p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10);
    
    
  end if;
   -----cargar  en la tabla
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
     
exception
  when others then
    raise_application_error(-20001,'Error en UP pl_cheque_abn_dif = '||sqlerrm);
end;
--------------------------------

--------------------------------pl_cheque_regional_dif
procedure pl_cheque_regional_dif(
                                 vclavecheque in number, 
                                 p_form_impr  in number) is
  
  v_num_txt            varchar2(200) := ' ';
  v_num_txt_1          varchar2(90) := ' ';
  v_num_txt_2          varchar2(105) := ' ';
  v_num_txt_3          varchar2(95) := ' ';
  
  v_obs_txt            varchar2(40) := ' ';
  v_obs_txt_1          varchar2(20) := ' ';
  v_obs_txt_2          varchar2(26) := ' ';
  v_obs_txt_3          varchar2(26) := ' ';
  
  v_formato            varchar2(20);
  v_formato_loc        varchar2(20);
  v_formato_cant       varchar2(20);
  v_cli_txt            varchar2(50) := ' ';
  v_cli_txt_1          varchar2(20) := ' ';
  v_cli_txt_2          varchar2(21) := ' ';
  
  vformatocant         varchar2(20);
  vformatoimp          varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc              date;
  vfecvto              date;
  vtotmon              number;
  vbenef               varchar2(80);
  vmondecimp           number;
  vobs                 varchar2(40);
  vnrocheq             varchar2(30);
  vserie               varchar2(2);
  vindi_dia_dife                varchar2(4);
  
  --variables para distici?n de monedas.
  c_dolares   constant varchar2(3) := 'U$S';
  c_guaranies constant varchar2(3) := 'GS';
  v_moneda             varchar2(3);
  
  v_num_txt_1_us       v_num_txt_1%type := ' '; 
  v_num_txt_2_us       v_num_txt_2%type := ' ';

  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg                 varchar2(2000);
    
begin
  --seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  
 
  
  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
  
  
  ----------------------------------------------------
  ---- asignamos la moneda en la que trabajaremos ----
  ----------------------------------------------------
  if p_form_impr = 17 then
    v_moneda := c_guaranies;
  elsif p_form_impr = 18 then
    v_moneda := c_dolares;
  end if;
  
  ----------------------------
  --moneda en dolares(u$s)...!
  ----------------------------
  if v_moneda = c_dolares then
    null;
  
  -----------------------------
  --moneda en guaranies(gs)...!
  -----------------------------
  elsif v_moneda = c_guaranies then
    --se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
    
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
    
    --separar "orden" para que imprima en 2 lineas
    v_cli_txt := ltrim(rtrim(vbenef)); --quitar espacios a la izquierda y a la derecha
    if v_cli_txt is null then
      v_cli_txt_1 := ' ';
      v_cli_txt_2 := ' ';
    else
      v_cli_txt_1 := substr(v_cli_txt, 1, 19);
    end if;
    if length(v_cli_txt) > 19 then
      v_cli_txt_2 := substr(v_cli_txt, 20, 21);
    end if;
        
    v_obs_txt := rtrim(vobs);
    if v_obs_txt is null then
      v_obs_txt_1 := ' ';
      v_obs_txt_2 := ' ';
    else
      v_obs_txt_1 := substr(v_obs_txt, 1, 19);
      if length(v_obs_txt) > 19 then
        v_obs_txt_2 := substr(v_obs_txt, 20, 40);
      else
        v_obs_txt_2 := ' ';
      end if;
    end if;
    
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
    
    
    --monto del cheque.
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 115,' ')||
       lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#'
    ;
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
    
    --fecha de emision en cheque.
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',86,' ')||
       lpad(to_char(vfecdoc,'DD'),4, ' ')||
       lpad(' ', 14, ' ')||
       initcap(rpad(rtrim(to_char(vfecdoc,'month')), 12, ' '))||'  '||
       lpad(' ', 14, ' ')||
       lpad(to_char(vfecdoc,'YYYY'), 5, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',10,' ')||
       to_char(vfecdoc,'DD/MM/YYYY')
    ;
    
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',13,' ')||to_char(vfecvto,'DD/MM/YYYY')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(26); --interespaciado 1/6 *** 25
    --orden en el talon y fecha vcto en el cheque
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',9,' ')||
       rpad(v_cli_txt_1, 14, ' ')||
       lpad(' ', 14,' ')||
       lpad(to_char(vfecvto,'DD'),4, ' ')||
       lpad(' ', 6, ' ')||
       initcap(rpad(rtrim(to_char(vfecvto,'month')), 14, ' '))||'  '||
       lpad(' ',7,' ')||
       to_char(vfecvto,'YYYY')||
       lpad(' ',24,' ')||
       rpad(vbenef, 80, ' ')
    ;
    
    --text_io.put(v_impresora, chr(27)||'2');
    --text_io.put(v_impresora, chr(27)|| '3' ||chr(20)); --interespaciado 1/6 *** 25
    p_cheque_dato := p_cheque_dato ||
       rpad(v_cli_txt_2, 19, ' ')
    ;
    
    --total en letras.
    if v_num_txt_2 is null then
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',49,' ')
         ||rpad(v_num_txt_1,90,' -')
      ;
       p_cheque_dato := p_cheque_dato || chr(10);
      p_cheque_dato := p_cheque_dato ||
         lpad(' ',34,' ')
         ||lpad(' -',50,' -')
      ;
    else
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',49,' ')
         ||v_num_txt_1
      ;
       p_cheque_dato := p_cheque_dato || chr(10);
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',34,' ')
         ||v_num_txt_2
         ||lpad(' -',8,' -')
      ;
    end if;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --1/6.
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
    
    --monto total del cheque.
    p_cheque_dato := p_cheque_dato ||
      lpad(' ',6,' ')
      ||rpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 20, ' ')
    ;   
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --1/8.
     p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10);
    
  end if;
  
end;
--------------------------------

--------------------------------pl_cheque_hsbc
procedure pl_cheque_hsbc(
                           vclavecheque in number, 
                           p_form_impr  in number) is

  v_num_txt      varchar2(200) := ' ';
  v_num_txt_1    varchar2(100) := ' ';
  v_num_txt_2    varchar2(105) := ' ';
  v_num_txt_3    varchar2(105) := ' ';
  
  v_obs_txt      varchar2(40) := ' ';
  v_obs_txt_1    varchar2(21) := ' ';
  v_obs_txt_2    varchar2(19) := ' ';
  v_obs_txt_3    varchar2(19) := ' ';
  
  v_benef_txt_1  varchar2(20) := ' ';
  v_benef_txt_2  varchar2(20) := ' ';
  
  v_formato      varchar2(20);
  v_formato_loc  varchar2(20);
  v_formato_cant varchar2(20);
  
  vformatocant   varchar2(20);
  vformatoimp    varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc        date;
  vfecvto        date;
  vtotmon        number;
  vbenef         varchar2(80);
  vmondecimp     number;
  vobs           varchar2(40);
  vnrocheq       varchar2(30);
  vserie         varchar2(2);
  vindi_dia_dife          varchar2(4);
  
  --variables para distici?n de monedas.
  c_dolares   constant varchar2(3) := 'U$S';
  c_guaranies constant varchar2(3) := 'GS';
  v_moneda             varchar2(3);
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
begin
  --seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
     
  
  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt  := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  
  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
  
  v_obs_txt := vobs;
  
  pl_separar_texto_lib(v_obs_txt, 21, 21, v_obs_txt_1, v_obs_txt_2); 
  pl_separar_texto_lib(v_obs_txt_2,19, 10, v_obs_txt_2, v_obs_txt_3);
  
  ----------------------------------------------------
  ---- asignamos la moneda en la que trabajaremos ----
  ----------------------------------------------------
  if p_form_impr = 19 then
    v_moneda := c_guaranies;
  elsif p_form_impr = 23 then
    v_moneda := c_dolares;
  end if;
  
  ----------------------------
  --moneda en dolares(u$s)...!
  ----------------------------
  if v_moneda = c_dolares then

    --se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
      
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
    
     p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10); --4 linea en blanco
    
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
    
    -- orden del cheque en el talon
    
    p_cheque_dato := p_cheque_dato || chr(10); --1 linea en blanco
    
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)  
    
    --beneficiario en tal?n y monto total de cheque.
    p_cheque_dato := p_cheque_dato ||
       lpad(to_char(vfecdoc,'DD'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'MM'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'YYYY'),4, ' ')
       ||lpad(' ', 57, ' ')
       ||lpad(to_char(vfecdoc,'DD'),2, ' ')
       ||lpad(' ', 8, ' ')
       ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 13, ' '))
       ||lpad(to_char(vfecdoc,'YYYY'), 10, ' ')
       ||lpad(' ',10, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 16, '#')
       ||'#'
    ;
    
    --beneficiario.
    v_benef_txt_1 := nvl(ltrim(rtrim(substr(vbenef,1,19))),' ');
    v_benef_txt_2 := nvl(ltrim(rtrim(substr(vbenef,20,19))),' ');
    
    p_cheque_dato := p_cheque_dato ||
       lpad(v_benef_txt_1,19, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato ||
       lpad(v_benef_txt_2,19,' ')
    ;
    
    --concepto
    p_cheque_dato := p_cheque_dato ||
       rpad(nvl(v_obs_txt_1,' '), 19, ' ')
       ||lpad(' ', 25, ' ')
       ||rpad(vbenef, 80, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)  
    p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)  
    
    --total factura en letras (2da. linea) 
    if v_num_txt_2 is null or v_num_txt_2 = ' ' then
      --total factura en letras
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 37, ' ')
         ||rpad(v_num_txt_1, 93, ' -')
      ;
      
      p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 25, ' ')
         ||lpad('- ',65,'- ')
      ;
    else
      
      --total factura en letras
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 37, ' ')
         ||rpad(v_num_txt_1, 93, ' ')
      ;
      
      p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 25, ' ')
         ||rpad(v_num_txt_2,65,' -')
      ;
    end if;
    
    p_cheque_dato := p_cheque_dato || chr(10); -- 1 lineas en blanco
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
    
    --monto total del cheque
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 1, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 16, ' ')
    ;
    
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10); -- 6 lineas en blanco
  
  -----------------------------
  --moneda en guaranies(gs)...!
  -----------------------------
  elsif v_moneda = c_guaranies then
    
    --se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
      
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
    
     p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10); --4 linea en blanco
    
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
    
    -- orden del cheque en el talon
    
    p_cheque_dato := p_cheque_dato || chr(10); --1 linea en blanco
    
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)  
    
    --beneficiario en tal?n y monto total de cheque.
    p_cheque_dato := p_cheque_dato ||
       lpad(to_char(vfecdoc,'DD'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'MM'),2, ' ')||'/'
       ||lpad(to_char(vfecdoc,'YYYY'),4, ' ')
       ||lpad(' ', 57, ' ')
       ||lpad(to_char(vfecdoc,'DD'),2, ' ')
       ||lpad(' ', 8, ' ')
       ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 13, ' '))
       ||lpad(to_char(vfecdoc,'YYYY'), 10, ' ')
       ||lpad(' ',10, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 16, '#')
       ||'#'
    ;
    
    --beneficiario.
    v_benef_txt_1 := nvl(ltrim(rtrim(substr(vbenef,1,19))),' ');
    v_benef_txt_2 := nvl(ltrim(rtrim(substr(vbenef,20,19))),' ');
    
    p_cheque_dato := p_cheque_dato ||
       lpad(v_benef_txt_1,19, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato ||
       lpad(v_benef_txt_2,19,' ')
    ;
    
    --concepto
    p_cheque_dato := p_cheque_dato ||
       rpad(nvl(v_obs_txt_1,' '), 19, ' ')
       ||lpad(' ', 25, ' ')
       ||rpad(vbenef, 80, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)  
    p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)  
    
    --total factura en letras (2da. linea) 
    if v_num_txt_2 is null or v_num_txt_2 = ' ' then
      --total factura en letras
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 37, ' ')
         ||rpad(v_num_txt_1, 93, ' -')
      ;
      
      p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 25, ' ')
         ||lpad('- ',65,'- ')
      ;
    else
      
      --total factura en letras
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 37, ' ')
         ||rpad(v_num_txt_1, 93, ' ')
      ;
      
      p_cheque_dato := p_cheque_dato || chr(10); -- 1 linea en blanco
      
      p_cheque_dato := p_cheque_dato ||
         lpad(' ', 25, ' ')
         ||rpad(v_num_txt_2,65,' -')
      ;
    end if;
    
    p_cheque_dato := p_cheque_dato || chr(10); -- 1 lineas en blanco
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
    
    --monto total del cheque
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 1, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 16, ' ')
    ;
    
     p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10); -- 6 lineas en blanco
    
  end if;
   -----cargar  en la tabla
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
end;
--------------------------------

--------------------------------pl_cheque_amambay_dif
procedure pl_cheque_amambay_dif(
                                vclavecheque in number, 
                                p_form_impr  in number) is
  v_num_txt            varchar2(200) := ' ';
  v_num_txt_1          varchar2(90) := ' ';
  v_num_txt_2          varchar2(105) := ' ';
  v_num_txt_3          varchar2(95) := ' ';
  
  v_obs_txt            varchar2(40) := ' ';
  v_obs_txt_1          varchar2(20) := ' ';
  v_obs_txt_2          varchar2(26) := ' ';
  v_obs_txt_3          varchar2(26) := ' ';
  
  v_formato            varchar2(20);
  v_formato_loc        varchar2(20);
  v_formato_cant       varchar2(20);
  v_cli_txt            varchar2(50) := ' ';
  v_cli_txt_1          varchar2(20) := ' ';
  v_cli_txt_2          varchar2(21) := ' ';
  
  vformatocant         varchar2(20);
  vformatoimp          varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc              date;
  vfecvto              date;
  vtotmon              number;
  vbenef               varchar2(80);
  vmondecimp           number;
  vobs                 varchar2(40);
  vnrocheq             number;
  vserie               varchar2(2);
  vindi_dia_dife                varchar2(4);
  
  --variables para distici?n de monedas.
  c_dolares   constant varchar2(3) := 'U$S';
  c_guaranies constant varchar2(3) := 'GS';
  v_moneda             varchar2(3);
  
  v_num_txt_1_us       v_num_txt_1%type := ' '; 
  v_num_txt_2_us       v_num_txt_2%type := ' ';
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg                 varchar2(2000);
begin
  --seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  
 
  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
    
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
  
  
  ----------------------------------------------------
  ---- asignamos la moneda en la que trabajaremos ----
  ----------------------------------------------------
  if p_form_impr = 20 then
    v_moneda := c_guaranies;
  elsif p_form_impr = 21 then
    v_moneda := c_dolares;
  end if;
  
  ----------------------------
  --moneda en dolares(u$s)...!
  ----------------------------
  if v_moneda = c_dolares then
    null;
  
  -----------------------------
  --moneda en guaranies(gs)...!
  -----------------------------
  elsif v_moneda = c_guaranies then
    --se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
    
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
    
    --separar "orden" para que imprima en 2 lineas
    v_cli_txt := ltrim(rtrim(vbenef)); --quitar espacios a la izquierda y a la derecha
    if v_cli_txt is null then
      v_cli_txt_1 := ' ';
      v_cli_txt_2 := ' ';
    else
      v_cli_txt_1 := substr(v_cli_txt, 1, 19);
    end if;
    if length(v_cli_txt) > 19 then
      v_cli_txt_2 := substr(v_cli_txt, 20, 21);
    end if;
        
    v_obs_txt := rtrim(vobs);
    if v_obs_txt is null then
      v_obs_txt_1 := ' ';
      v_obs_txt_2 := ' ';
    else
      v_obs_txt_1 := substr(v_obs_txt, 1, 19);
      if length(v_obs_txt) > 19 then
        v_obs_txt_2 := substr(v_obs_txt, 20, 40);
      else
        v_obs_txt_2 := ' ';
      end if;
    end if;
    
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
    
    --fecha de emisi?n en cheques.
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',3,' ')||
       to_char(vfecdoc,'DD/MM/YYYY')||
       lpad(' ',80,' ')||
       lpad(to_char(vfecdoc,'DD'),4, ' ')||
       lpad(' ', 5, ' ')||
       initcap(rpad(rtrim(to_char(vfecdoc,'month')), 15, ' '))||'  '||
       lpad(to_char(vfecdoc,'YYYY'), 5, ' ')
    ;
    
    --tal?n
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',3,' ')||to_char(vfecvto,'DD/MM/YYYY')
    ;
    
     p_cheque_dato := p_cheque_dato || chr(10);
    
    --cheque.
    p_cheque_dato := p_cheque_dato ||
       rpad(v_cli_txt_1, 19, ' ')||
       lpad(' ', 14,' ')||
       lpad(to_char(vfecvto,'DD'),4, ' ')||
       lpad(' ', 4, ' ')||
       initcap(rpad(rtrim(to_char(vfecvto,'month')), 14, ' '))||'  '||
       lpad(' ',5,' ')||
       to_char(vfecvto,'YYYY')||
       lpad(' ',43,' ')||
       lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#'
    ;
    
    --tal?n.
    p_cheque_dato := p_cheque_dato ||
       rpad(v_cli_txt_2, 19, ' ')
    ;
    
    p_cheque_dato := p_cheque_dato ||
       rpad(v_obs_txt_1, 19, ' ')
    ;
    
    --importe del cheque.
    p_cheque_dato := p_cheque_dato ||
       rpad(v_obs_txt_2, 35,' ')||
       rpad(vbenef, 100, ' ')
    ;
    
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2';
    
     p_cheque_dato := p_cheque_dato || chr(10);
    
    --totales en letras.
    if v_num_txt_2 is null then
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',35,' ')
         ||rpad(v_num_txt_1,90,' -')
      ;
       p_cheque_dato := p_cheque_dato || chr(10);
      p_cheque_dato := p_cheque_dato ||
         lpad(' ',24,' ')
         ||lpad(' -',50,' -')
      ;
    else
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',35,' ')
         ||v_num_txt_1
      ;
       p_cheque_dato := p_cheque_dato || chr(10);
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',24,' ')
         ||v_num_txt_2
         ||lpad(' -',8,' -')
      ;
    end if;
    
    p_cheque_dato := p_cheque_dato || chr(27)||'0'; --1/6.
    
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
    
    --monto total del cheque.
    p_cheque_dato := p_cheque_dato ||
      lpad(' ',6,' ')
      ||rpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 20, ' ')
    ;   
    
    p_cheque_dato := p_cheque_dato || chr(27)||'2'; --1/8.
     p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10);
    
  end if;
  
end;
--------------------------------

--------------------------------pl_cheque_atlas
procedure pl_cheque_atlas(
                                vclavecheque in number, 
                                p_form_impr  in number)
is
  
  v_num_txt      varchar2(500) := ' ';
  
  v_obs_txt      varchar2(40) := ' ';
  v_obs_txt_1    varchar2(20) := ' ';
  v_obs_txt_2    varchar2(26) := ' ';
  v_obs_txt_3    varchar2(26) := ' ';
  
  v_formato      varchar2(20);
  v_formato_loc  varchar2(20);
  v_formato_cant varchar2(20);
  salir          exception;
    
  vformatocant   varchar2(20);
  vformatoimp    varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc        date;
  vfecvto        date;
  vtotmon        number;
  vbenef         varchar2(80);
  vmondecimp     number;
  vobs           varchar2(40);
  vnrocheq       varchar2(30);
  vserie         varchar2(2);
  vindi_dia_dife          varchar2(4);

  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
    
begin
  -- seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
     
 
  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
    
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 138 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  v_num_txt := rpad(v_num_txt, 145, ' -');
  
  -- se envia dos veces la misma instruccion, porque si se enciende
  -- la impresora despues de iniciado windows , entonces la primera
  -- instruccion no se ejecuta.
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
  
  p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
  
  --text_io.put(v_impresora, chr(27)||'0'); --establecer 1/8 (inch line spacing)
  
 -- text_io.new_line(v_impresora, 1); --1 linea en blanco
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  
   p_cheque_dato := p_cheque_dato || chr(10); --1 linea en blanco
  
  p_cheque_dato := p_cheque_dato || chr(27)||'1'; --establecer 1/7 (inch line spacing)
  -- text_io.put(v_impresora, chr(27)|| '3' ||chr(40)); --interespaciado 1/6 *** 25
  --fecha en el talon
  p_cheque_dato := p_cheque_dato ||
     lpad(to_char(vfecdoc,'DD'),7, ' ')||'/'
     ||lpad(to_char(vfecdoc,'MM'),2, ' ')||'/'
     ||lpad(to_char(vfecdoc,'YYYY'),4, ' ');
  
  --text_io.put(v_impresora, chr(27)||'0'); --establecer 1/8 (inch line spacing)
  
  p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(25); --interespaciado 1/6 *** 25
  
  
  --fecha de operacion en letras
  p_cheque_dato := p_cheque_dato ||
     lpad(' ',56, ' ')
     ||lpad(to_char(vfecdoc,'DD'),2, ' ')
     ||lpad(' ', 18, ' ')
     ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 15, ' '))
     ||lpad(to_char(vfecdoc,'YYYY'), 10, ' ')
  ;
  


  --orden en talon ymonto total del cheque 
  if p_form_impr = 26 then
   p_cheque_dato := p_cheque_dato ||
       lpad(nvl(substr(vbenef,1,21),' '),21,' ')
       ||lpad(' ', 90, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 19, '#')
       ||'#'
    ;
  else
    p_cheque_dato := p_cheque_dato ||
       lpad(nvl(substr(vbenef,1,21),' '),21,' ')
       ||lpad(' ', 92, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 17, '#')
       ||'#'
    ;
  end if;
  
  p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(20); --interespaciado 1/6 *** 25
  
  --orden en el cheque

    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10);
  p_cheque_dato := p_cheque_dato ||
     lpad(' ', 32,' ')
     ||rpad(vbenef, 100,' ')
  ;
  
  
  
  --formato de concepto
  v_obs_txt := rtrim(vobs);
  pl_separar_texto_lib(v_obs_txt, 20, 20, v_obs_txt_1, v_obs_txt_2);
  pl_separar_texto_lib(v_obs_txt_2, 26, 16, v_obs_txt_2, v_obs_txt_3);
  
  v_obs_txt_1 := nvl(v_obs_txt_1, ' ');
  v_obs_txt_2 := nvl(v_obs_txt_2, ' ');
  
  --concepto en 1? linea
  p_cheque_dato := p_cheque_dato ||
     lpad(' ', 4, ' ')
     ||rpad(v_obs_txt_1,20, ' ')
  ;
  
  if v_obs_txt_2 is null then
    v_obs_txt_2 := ' '; --para que tenga algo que imprimir y rellenar con espacios
  end if;
 
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(20); --interespaciado 1/6 *** 25
  
  --2da. linea de concepto y 1ra. linea de numero en letras cerrada con - - -
  
  if p_form_impr = 26 then
    p_cheque_dato := p_cheque_dato ||
       rpad(v_obs_txt_2,22, ' ')
       ||lpad(' ', 17, ' ')
       ||substr(v_num_txt, 1, 88)
    ;
  else
    p_cheque_dato := p_cheque_dato ||
       rpad(v_obs_txt_2,22, ' ')
       ||lpad(' ',17, ' ')
       ||substr(v_num_txt, 1, 80)
    ;    
  end if;
  
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10);
  --2da. linea de numero en letras
  
  if p_form_impr = 26 then
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 23, ' ')
       ||substr(v_num_txt,89,57)
    ;
  else
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 23, ' ')
       ||substr(v_num_txt,81,57)
    ;
  end if;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
   p_cheque_dato := p_cheque_dato || chr(10); --1 lineas en blanco
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
  
  --monto total del cheque
  p_cheque_dato := p_cheque_dato ||
     lpad(' ', 4, ' ')
     ||rpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 22, ' ')
  ;
  
   p_cheque_dato := p_cheque_dato || chr(10);
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
   p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10); -- 4 lineas en blanco
   -----cargar  en la tabla
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
exception
  when salir then 
    null;
end;
--------------------------------

--------------------------------pl_cheque_atlas_dif
procedure pl_cheque_atlas_dif(
                            vclavecheque in number, 
                            p_form_impr  in number) is
  
  v_num_txt      varchar2(500) := ' ';
  
  v_obs_txt      varchar2(40) := ' ';
  v_obs_txt_1    varchar2(20) := ' ';
  v_obs_txt_2    varchar2(26) := ' ';
  v_obs_txt_3    varchar2(26) := ' ';
  
  v_formato      varchar2(20);
  v_formato_loc  varchar2(20);
  v_formato_cant varchar2(20);
  salir          exception;
    
  vformatocant   varchar2(20);
  vformatoimp    varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc        date;
  vfecvto        date;
  vtotmon        number;
  vbenef         varchar2(80);
  vmondecimp     number;
  vobs           varchar2(40);
  vnrocheq       varchar2(30);
  vserie         varchar2(2);
  vindi_dia_dife            varchar2(4);

  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
    
begin
  -- seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
     
   
  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
    
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 138 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  v_num_txt := rpad(v_num_txt, 145, ' -');
  
  -- se envia dos veces la misma instruccion, porque si se enciende
  -- la impresora despues de iniciado windows , entonces la primera
  -- instruccion no se ejecuta.
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
  
  p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
  
  --text_io.put(v_impresora, chr(27)||'0'); --establecer 1/8 (inch line spacing)
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  
  --text_io.new_line(v_impresora, 1); --1 linea en blanco
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/7 (inch line spacing)
 
  p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(15); --interespaciado 1/6 *** 25 
  
   p_cheque_dato := p_cheque_dato || chr(10); --1 linea en blanco
  
  
  --fecha en el talon y en el cheque
  p_cheque_dato := p_cheque_dato ||
     lpad(to_char(vfecdoc,'DD'),7, ' ')||'/'
     ||lpad(to_char(vfecdoc,'MM'),2, ' ')||'/'
     ||lpad(to_char(vfecdoc,'YYYY'),4, ' ')
     ||lpad(' ', 53, ' ')
     ||lpad(to_char(vfecdoc,'DD'),2, ' ')
     ||lpad(' ', 11, ' ')
     ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 18, ' '))
     ||lpad(to_char(vfecdoc,'YYYY'), 5, ' ');
  
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  --text_io.new_line(v_impresora,1);
  
  -- fech. vcto. talon.
  p_cheque_dato := p_cheque_dato ||
       lpad(to_char(vfecvto,'DD'),7, ' ')||'/'
       ||lpad(to_char(vfecvto,'MM'),2, ' ')||'/'
       ||lpad(to_char(vfecvto,'YYYY'),4, ' ');
       
  -- fech. vcto. del  cheque y monto total del cheque 
  if p_form_impr = 28 then  --gs
   p_cheque_dato := p_cheque_dato ||
       lpad(' ', 68, ' ')
       ||lpad(to_char(vfecvto,'DD'),2, ' ')
       ||lpad(' ', 11, ' ')
       ||initcap(rpad(rtrim(to_char(vfecvto,'month')), 18, ' '))
       ||lpad(to_char(vfecvto,'YYYY'), 5, ' ')
       ||lpad(' ', 7, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 19, '#')
       ||'#'
    ;
  else
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 68, ' ')
       ||lpad(to_char(vfecvto,'DD'),2, ' ')
       ||lpad(' ', 11, ' ')
       ||initcap(rpad(rtrim(to_char(vfecvto,'month')), 18, ' '))
       ||lpad(to_char(vfecvto,'YYYY'), 5, ' ')
       ||lpad(' ', 7, ' ')
       ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 17, '#')
       ||'#'
    ;
  end if;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  --orden del talon
  p_cheque_dato := p_cheque_dato ||
  lpad(nvl(substr(vbenef,1,19),' '),19,' ');
  
  
  
  p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(20); --interespaciado 1/6 *** 25  
   p_cheque_dato := p_cheque_dato || chr(10);
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing) 
  
  
  
  --orden en el cheque
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  p_cheque_dato := p_cheque_dato || chr(10);
  p_cheque_dato := p_cheque_dato ||
     lpad(' ',36,' ')
     ||rpad(vbenef, 100,' ')
  ;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  
  --formato de concepto
  v_obs_txt := rtrim(vobs);
  pl_separar_texto_lib(v_obs_txt, 20, 20, v_obs_txt_1, v_obs_txt_2);
  pl_separar_texto_lib(v_obs_txt_2, 26, 16, v_obs_txt_2, v_obs_txt_3);
  
  v_obs_txt_1 := nvl(v_obs_txt_1, ' ');
  v_obs_txt_2 := nvl(v_obs_txt_2, ' ');
  
  --concepto en 1? linea
  p_cheque_dato := p_cheque_dato ||
     lpad(v_obs_txt_1,20, ' ')
  ;
  
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/6 (inch line spacing)
  p_cheque_dato := p_cheque_dato || chr(10);
  
  if v_obs_txt_2 is null then
    v_obs_txt_2 := ' '; --para que tenga algo que imprimir y rellenar con espacios
  end if;
  
  
  p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(24); --interespaciado 1/6 *** 25    
  --2da. linea de concepto y 1ra. linea de numero en letras cerrada con - - -
 
 
  if p_form_impr = 28 then
    p_cheque_dato := p_cheque_dato ||
       lpad(v_obs_txt_2,20, ' ')
       ||lpad(' ', 24, ' ')
       ||substr(v_num_txt, 1, 88)
    ;
  else
    p_cheque_dato := p_cheque_dato ||
       lpad(v_obs_txt_2,20, ' ')
       ||lpad(' ',24, ' ')
       ||substr(v_num_txt, 1, 80)
    ;    
  end if;
  
  
 
  
  p_cheque_dato := p_cheque_dato || chr(10); --1 lineas en blanco
  
  --2da. linea de numero en letras
  p_cheque_dato := p_cheque_dato || chr(10); 
  if p_form_impr = 28 then
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 25, ' ')
       ||substr(v_num_txt,89,57)
    ;
  else
    p_cheque_dato := p_cheque_dato ||
       lpad(' ', 25, ' ')
       ||substr(v_num_txt,81,57)
    ;
  end if;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
   p_cheque_dato := p_cheque_dato || chr(10); --1 lineas en blanco
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
   p_cheque_dato := p_cheque_dato || chr(10);
  
  --monto total del cheque
  p_cheque_dato := p_cheque_dato ||
     lpad(' ', 4, ' ')
     ||rpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 22, ' ')
  ;
  
   p_cheque_dato := p_cheque_dato || chr(10);
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --establecer 1/6 (inch line spacing)
 p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10); -- 4 lineas en blanco
  
exception
  when salir then 
    null;
end;
--------------------------------
/*
--------------------------------pl_cheque_sudameris_hp
procedure pl_cheque_sudameris_hp(
                              vclavecheque   in number, 
                              p_form_impr    in number) is
 -- pl_id paramlist; 
  v_report varchar2(20);
  v_where   varchar2(500) := '';
  v_num_txt      varchar2(300):= ' ';
  v_num_txt_1    varchar2(180):= ' ';
  v_num_txt_2    varchar2(120):= ' ';
  v_num_txt_3    varchar2(120):= ' ';
  
  v_obs_txt      varchar2(40):= ' ';
  v_obs_txt_1    varchar2(20):= ' ';
  v_obs_txt_2    varchar2(26):= ' ';
  v_obs_txt_3    varchar2(26):= ' ';
  
  v_formato      varchar2(20);
  v_formato_loc  varchar2(20);
  v_formato_cant varchar2(20);
  v_cli_txt      varchar2(50):= ' ';
  v_cli_txt_1    varchar2(20):= ' ';
  v_cli_txt_2    varchar2(21):= ' ';
  
  vformatocant   varchar2(20);
  vformatoimp    varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc        date;
  vfecvto        date;
  vtotmon        number;
  vbenef         varchar2(80);
  vmondecimp     number;
  vobs           varchar2(40);
  vnrocheq       varchar2(30);
  vserie         varchar2(2);
  vindi_dia_dife          varchar2(4);

  --ba: 23-10-2006 (impresion de cheques sudameris us y preparamos la opcion de gs).
  c_transaccion_dolares   constant varchar2(2):= 'US';
  c_transaccion_guaranies constant varchar2(2):= 'GS';
  
  --variable que tomara el tipo de transaccion (moneda).
  v_transaccion_moneda varchar2(2);
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
begin
  --buscamos los datos del cheque.
  
  
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  
  
 
  
  ---crear la lista de parametros 
  pl_id := get_parameter_list(upper('paramtemp'));
  if not id_null(pl_id) then
     destroy_parameter_list(upper('paramtemp'));
  end if;
  pl_id := create_parameter_list(upper('paramtemp'));
  if id_null(pl_id) then
    raise_application_error(-20001,'Error al crear lista de parametros!');
  end if;
  
  v_report := 'sudameris_cheque';
  
  --construir el where que se enviar? al reporte...
  v_where  := 'and c.cheq_codi ='||to_char(vclavecheque)||'  ';   
 -- add_parameter(pl_id,upper('p_where'),text_parameter, v_where);   
  
  --mascara del formato.
  vformatocant := '99990D00';
  vformatoimp  := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 300 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  
  pl_separar_texto_lib(v_num_txt, 180, 180, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 300, 180, v_num_txt_2, v_num_txt_3);
   
  
  --separamos la orden para que lo imprima en dos lineas.
  v_cli_txt := ltrim(rtrim(vbenef));
  if v_cli_txt is null then
    v_cli_txt_1 := ' ';
    v_cli_txt_2 := ' ';
  else
    v_cli_txt_1 := substr(v_cli_txt, 1, 20);
  end if;
  
  if length(v_cli_txt) > 20 then
    v_cli_txt_2 := substr(v_cli_txt, 21, 20);
  end if;
  
  --separamos el concepto(observacion 'doc_obs') en dos variables.
  v_obs_txt := rtrim(vobs);
  if v_obs_txt is null then
    v_obs_txt_1 := ' ';
    v_obs_txt_2 := ' ';
  else
    --si mayor a 19 caracteres lo partimos en dos.
    --estas lineas son a modo de entendimiento nada mas.
    if length(v_obs_txt) > 19 then
      v_obs_txt_1 := substr(v_obs_txt, 1, 19);
      v_obs_txt_2 := substr(v_obs_txt, 20, 19);
    else
      v_obs_txt_1 := substr(v_obs_txt, 1, 19);
      v_obs_txt_2 := ' ';
    end if;
  end if;
     
  -----------------
  -- monto total
  -----------------

  add_parameter(pl_id,upper('vTotMon'),text_parameter, lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#'); 
  ----------------------------
  --talo : cliente(linea uno).
  ----------------------------
  add_parameter(pl_id,upper('V_CLI_TXT_1'),text_parameter, rpad(v_cli_txt_1, 20, ' ')); 
  
  ------------------------------
  --   : cliente(linea dos).
  ------------------------------
   --cliente(segunda linea).
    add_parameter(pl_id,upper('V_CLI_TXT_2'),text_parameter, rpad(v_cli_txt_2, 20, ' ')); 
  
  ---------------------------------
  --cheque : total factura(letras).
  ---------------------------------
    add_parameter(pl_id,upper('V_NUM_TXT_1'),text_parameter, rpad(v_num_txt_1, 180, ' -'));
   
    --en letras(2da. linea).
    if length(nvl(v_num_txt_2,'-')) < 0 then
    add_parameter(pl_id,upper('V_NUM_TXT_2'),text_parameter, rpad(nvl(v_num_txt_2, '-'), 100, ' -'));
    else
    add_parameter(pl_id,upper('V_NUM_TXT_2'),text_parameter, nvl(v_num_txt_2, '-')||rpad(' - ',100,' -'));  
    end if;
  
 
 
  --monto total del cheque en talo
  
  --lpad(nvl(to_char(vtotmon,vformatoimp,'nls_numeric_characters = '',.''')||'.-',' '),16,' ');
  --add_parameter(pl_id,upper('p_cant_deci'),text_parameter, vtotmon);   

  add_parameter(pl_id,upper('paramform'),text_parameter, upper('no')); 
  add_parameter(pl_id,upper('destype'),text_parameter, upper('preview'));
  run_product(reports,rtrim(ltrim(v_report))||'.rep',asynchronous,runtime,filesystem,pl_id,null);
    
   -----cargar  en la tabla
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
end;
--------------------------------
*/
/*--------------------------------pl_cheque_sudameris_dif
procedure pl_cheque_sudameris_dif(
                                vclavecheque in number, 
                                p_form_impr  in number) is
  v_num_txt            varchar2(200) := ' ';
  v_num_txt_1          varchar2(90) := ' ';
  v_num_txt_2          varchar2(105) := ' ';
  v_num_txt_3          varchar2(95) := ' ';
  
  v_obs_txt            varchar2(40) := ' ';
  v_obs_txt_1          varchar2(20) := ' ';
  v_obs_txt_2          varchar2(26) := ' ';
  v_obs_txt_3          varchar2(26) := ' ';
  
  v_formato            varchar2(20);
  v_formato_loc        varchar2(20);
  v_formato_cant       varchar2(20);
  v_cli_txt            varchar2(50) := ' ';
  v_cli_txt_1          varchar2(20) := ' ';
  v_cli_txt_2          varchar2(21) := ' ';
  
  vformatocant         varchar2(20);
  vformatoimp          varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc              date;
  vfecvto              date;
  vtotmon              number;
  vbenef               varchar2(80);
  vmondecimp           number;
  vobs                 varchar2(40);
  vnrocheq             number;
  vserie               varchar2(2);
  vindi_dia_dife                varchar2(4);
  
  --variables para distici?n de monedas.
  c_dolares   constant varchar2(3) := 'U$S';
  c_guaranies constant varchar2(3) := 'GS';
  v_moneda             varchar2(3);
  
  v_num_txt_1_us       v_num_txt_1%type := ' '; 
  v_num_txt_2_us       v_num_txt_2%type := ' ';
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg                 varchar2(2000);
begin
  --seleccionar los datos del cheque

  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  

  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
    
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
  
  
  ----------------------------------------------------
  ---- asignamos la moneda en la que trabajaremos ----
  ----------------------------------------------------
  if p_form_impr = 32 then
    v_moneda := c_guaranies;
  elsif p_form_impr = 33 then
    v_moneda := c_dolares;
  end if;
  
  ----------------------------
  --moneda en dolares(u$s)...!
  ----------------------------
  --if v_moneda = c_dolares then
  --  null;
  
  -----------------------------
  --moneda en guaranies(gs)...!
  -----------------------------
  --elsif v_moneda = c_guaranies then
    --se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
    
    p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(24); --interespaciado 1/6 *** 25 
    
    --separar "orden" para que imprima en 2 lineas
 
    v_cli_txt := ltrim(rtrim(vbenef)); --quitar espacios a la izquierda y a la derecha
    if v_cli_txt is null then
      v_cli_txt_1 := ' ';
      v_cli_txt_2 := ' ';
    else
      v_cli_txt_1 := substr(v_cli_txt, 1, 19);
    end if;
    if length(v_cli_txt) > 19 then
      v_cli_txt_2 := substr(v_cli_txt, 20, 21);
    end if;
        
    v_obs_txt := rtrim(vobs);
    if v_obs_txt is null then
      v_obs_txt_1 := ' ';
      v_obs_txt_2 := ' ';
    else
      v_obs_txt_1 := substr(v_obs_txt, 1, 19);
      if length(v_obs_txt) > 19 then
        v_obs_txt_2 := substr(v_obs_txt, 20, 40);
      else
        v_obs_txt_2 := ' ';
      end if;
    end if;
    
   
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10);
    
    --fecha talon y monto en cheques.
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',3,' ')||
       to_char(vfecdoc,'DD/MM/YYYY')||
       lpad(' ',98,' ')||
       lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#';
       
       
    --tal?n fecha vencimiento 
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',3,' ')||to_char(vfecvto,'DD/MM/YYYY')
    ;
   
     p_cheque_dato := p_cheque_dato || chr(10);
    
    --orden en el talon y fecha de emision y fecha pago en el cheque.
    p_cheque_dato := p_cheque_dato ||
       rpad(v_cli_txt_1, 19, ' ')||
       lpad(' ', 21,' ')||
       lpad(to_char(vfecdoc,'DD'),4, ' ')||
       lpad(' ', 14, ' ')||
       initcap(rpad(rtrim(to_char(vfecdoc,'month')), 14, ' '))||'  '||
       lpad(' ',2,' ')||
       to_char(vfecdoc,'YYYY')||
       lpad(' ',15,' ')||
       lpad(to_char(vfecvto,'DD'),4, ' ')||
       lpad(' ', 10, ' ')||
       initcap(rpad(rtrim(to_char(vfecvto,'month')), 15, ' '))||'  '||
       lpad(' ', 2, ' ')||
       lpad(to_char(vfecvto,'YYYY'), 5, ' ')
    ;
    
    
     p_cheque_dato := p_cheque_dato || chr(10);
     
    --concepto tal?n y orden del cheque.
    p_cheque_dato := p_cheque_dato ||
       rpad(v_cli_txt_2, 19, ' ');
       
    p_cheque_dato := p_cheque_dato ||
       rpad(v_obs_txt_1, 19, ' ')||
       rpad(v_obs_txt_2, 21,' ')||
       lpad(' ', 1, ' ')||
       rpad(vbenef, 80, ' ')
    
    ;
    
   
      
    p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(27); --interespaciado 1/6 *** 25
     p_cheque_dato := p_cheque_dato || chr(10);
    
    --totales en letras.
    if v_num_txt_2 is null then
      p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(22); --interespaciado 1/6 *** 25
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',41,' ')
         ||rpad(v_num_txt_1,90,' -')
      ;
        p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
      p_cheque_dato := p_cheque_dato ||
         lpad(' ',29,' ')
         ||lpad(' -',50,' -')
      ;
    else
      p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(22); --interespaciado 1/6 *** 25
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',41,' ')
         ||v_num_txt_1
      ;
        p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',29,' ')
         ||v_num_txt_2
         ||lpad(' -',8,' -')
      ;
    end if;

    
    p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(15); --interespaciado 1/6 *** 25
    
    
    --monto total del cheque.
    p_cheque_dato := p_cheque_dato ||
      lpad(' ',6,' ')
      ||rpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 20, ' ')
    ;   
    
    
    text_io.new_line(v_impresora, 20);
    
 -- end if;
  
end;
--------------------------------
*/
--------------------------------pl_cheque_bbva_dif
procedure pl_cheque_bbva_dif(
                                vclavecheque in number, 
                                p_form_impr  in number) is
  v_num_txt            varchar2(200) := ' ';
  v_num_txt_1          varchar2(90) := ' ';
  v_num_txt_2          varchar2(105) := ' ';
  v_num_txt_3          varchar2(95) := ' ';
  
  v_obs_txt            varchar2(40) := ' ';
  v_obs_txt_1          varchar2(20) := ' ';
  v_obs_txt_2          varchar2(26) := ' ';
  v_obs_txt_3          varchar2(26) := ' ';
  
  v_formato            varchar2(20);
  v_formato_loc        varchar2(20);
  v_formato_cant       varchar2(20);
  v_cli_txt            varchar2(50) := ' ';
  v_cli_txt_1          varchar2(20) := ' ';
  v_cli_txt_2          varchar2(21) := ' ';
  
  vformatocant         varchar2(20);
  vformatoimp          varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc              date;
  vfecvto              date;
  vtotmon              number;
  vbenef               varchar2(80);
  vmondecimp           number;
  vobs                 varchar2(40);
  vnrocheq             number;
  vserie               varchar2(2);
  vindi_dia_dife                varchar2(4);
  
  --variables para distici?n de monedas.
  c_dolares   constant varchar2(3) := 'U$S';
  c_guaranies constant varchar2(3) := 'GS';
  v_moneda             varchar2(3);
  
  v_num_txt_1_us       v_num_txt_1%type := ' '; 
  v_num_txt_2_us       v_num_txt_2%type := ' ';
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg                 varchar2(2000);
begin
  --seleccionar los datos del cheque

  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  

  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
    
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
  
  
  ----------------------------------------------------
  ---- asignamos la moneda en la que trabajaremos ----
  ----------------------------------------------------
  if p_form_impr = 34 then
    v_moneda := c_guaranies;
  elsif p_form_impr = 35 then
    v_moneda := c_dolares;
  end if;
  
  ----------------------------
  --moneda en dolares(u$s)...!
  ----------------------------
  --if v_moneda = c_dolares then
  --  null;
  
  -----------------------------
  --moneda en guaranies(gs)...!
  -----------------------------
  --elsif v_moneda = c_guaranies then
    --se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
    
    p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(26); --interespaciado 1/6 *** 25 
    
    --separar "orden" para que imprima en 2 lineas
 
    v_cli_txt := ltrim(rtrim(vbenef)); --quitar espacios a la izquierda y a la derecha
    if v_cli_txt is null then
      v_cli_txt_1 := ' ';
      v_cli_txt_2 := ' ';
    else
      v_cli_txt_1 := substr(v_cli_txt, 1, 19);
    end if;
    if length(v_cli_txt) > 19 then
      v_cli_txt_2 := substr(v_cli_txt, 20, 21);
    end if;
        
    v_obs_txt := rtrim(vobs);
    if v_obs_txt is null then
      v_obs_txt_1 := ' ';
      v_obs_txt_2 := ' ';
    else
      v_obs_txt_1 := substr(v_obs_txt, 1, 19);
      if length(v_obs_txt) > 19 then
        v_obs_txt_2 := substr(v_obs_txt, 20, 40);
      else
        v_obs_txt_2 := ' ';
      end if;
    end if;
    
   
     p_cheque_dato := p_cheque_dato || chr(10);
    
    --fecha talon y monto en cheques.
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',3,' ')||
       to_char(vfecdoc,'DD/MM/YYYY')||
       lpad(' ',102,' ')||
       lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#';
       
       
    --tal?n fecha vencimiento 
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',3,' ')||to_char(vfecvto,'DD/MM/YYYY')
    ;
   
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10);
    
    --orden en el talon y fecha de emision y fecha pago en el cheque.
    p_cheque_dato := p_cheque_dato ||
       rpad(v_cli_txt_1, 19, ' ')||
       lpad(' ', 16,' ')||
       lpad(to_char(vfecdoc,'DD'),4, ' ')||
       lpad(' ', 14, ' ')||
       initcap(rpad(rtrim(to_char(vfecdoc,'month')), 14, ' '))||'  '||
       lpad(' ',8,' ')||
       to_char(vfecdoc,'YYYY')||
       lpad(' ',20,' ')||
       lpad(to_char(vfecvto,'DD'),4, ' ')||
       lpad(' ', 10, ' ')||
       initcap(rpad(rtrim(to_char(vfecvto,'month')), 15, ' '))||'  '||
       --lpad(' ', 2, ' ')||
       lpad(to_char(vfecvto,'YYYY'), 5, ' ')
    ;
    
    
    p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(12); --interespaciado 1/6 *** 25 
     p_cheque_dato := p_cheque_dato || chr(10);
     
    --concepto tal?n y orden del cheque.
    p_cheque_dato := p_cheque_dato ||
       rpad(v_cli_txt_2, 19, ' ');
       
    p_cheque_dato := p_cheque_dato ||
       rpad(v_obs_txt_1, 19, ' ')||
       rpad(v_obs_txt_2, 21,' ')||
       lpad(' ', 7, ' ')||
       rpad(vbenef, 80, ' ')
    
    ;
    
   
      
    p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(27); --interespaciado 1/6 *** 25
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
    
    --totales en letras.
    if v_num_txt_2 is null then
      p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(22); --interespaciado 1/6 *** 25
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',48,' ')
         ||rpad(v_num_txt_1,90,' -')
      ;
       p_cheque_dato := p_cheque_dato || chr(10);
      p_cheque_dato := p_cheque_dato ||
         lpad(' ',29,' ')
         ||lpad(' -',50,' -')
      ;
    else
      p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(22); --interespaciado 1/6 *** 25
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',41,' ')
         ||v_num_txt_1
      ;
       p_cheque_dato := p_cheque_dato || chr(10);
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',29,' ')
         ||v_num_txt_2
         ||lpad(' -',8,' -')
      ;
    end if;

    
    p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(15); --interespaciado 1/6 *** 25
    
    
    --monto total del cheque.
    p_cheque_dato := p_cheque_dato ||
      lpad(' ',6,' ')
      ||rpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 20, ' ')
    ;   
    
    
    --text_io.new_line(v_impresora, 20);
    
 -- end if;
   -----cargar  en la tabla
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
end;
--------------------------------

--------------------------------pl_cheque_itau_dif
procedure pl_cheque_itau_dif(
                                   vclavecheque in number, 
                                   p_form_impr  in number) is
  
  v_num_txt       varchar2(200) := ' ';
  v_num_txt_1     varchar2(90) := ' ';
  v_num_txt_2     varchar2(105) := ' ';
  v_num_txt_3     varchar2(95) := ' ';
  
  v_obs_txt       varchar2(40) := ' ';
  v_obs_txt_1     varchar2(20) := ' ';
  v_obs_txt_2     varchar2(26) := ' ';
  v_obs_txt_3     varchar2(26) := ' ';
  
  v_formato       varchar2(20);
  v_formato_loc   varchar2(20);
  v_formato_cant  varchar2(20);
  v_cli_txt       varchar2(50) := ' ';
  v_cli_txt_1     varchar2(20) := ' ';
  v_cli_txt_2     varchar2(21) := ' ';
  
  vformatocant    varchar2(20);
  vformatoimp     varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc         date;
  vfecvto         date;
  vtotmon         number;
  vbenef          varchar2(80);
  vmondecimp      number;
  vobs            varchar2(40);
  vnrocheq        varchar2(30);
  vserie          varchar2(2);
  vindi_dia_dife           varchar2(4);
  
  c_transaccion_guaranies     constant varchar2(2) := 'GS';
  c_transaccion_dolares       constant varchar2(2) := 'US';
  
  --variable que tomara el tipo de transaccion (moneda).
  v_transaccion_moneda                 varchar2(2);
  
  v_num_txt_1_us                       v_num_txt_1%type := ' '; 
  v_num_txt_2_us                       v_num_txt_2%type := ' ';
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg             varchar2(2000);
begin
  --seleccionar los datos del cheque
  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  
   
  
  ----------------------------------------------------
  ---- asignamos la moneda en la que trabajaremos ----
  ----------------------------------------------------
  if p_form_impr = 36 then
    v_transaccion_moneda := c_transaccion_guaranies;
  elsif p_form_impr = 37 then
    v_transaccion_moneda := c_transaccion_dolares;
  end if;
  
  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
  
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
  
  --se envia dos veces la misma instruccion, porque si se enciende
  --la impresora despues de iniciado windows , entonces la primera
  --instruccion no se ejecuta.
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
  
  p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
  
  p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --establecer 1/8 (inch line spacing)
  
   p_cheque_dato := p_cheque_dato || chr(10);
  
  --fecha del cheque en el talon
  p_cheque_dato := p_cheque_dato ||
     --mascaras con espacio en blanco a la izquierda.
     rpad(to_char(vfecdoc,'DD/MM/YYYY'),21, ' ')
  ;
  
  p_cheque_dato := p_cheque_dato || chr(10); --1 linea en blanco
  
  --fecha de vencimiento en talon
  --fecha de emision en cheque.
  p_cheque_dato := p_cheque_dato ||
     rpad(to_char(vfecvto,'DD/MM/YYYY'),21,' ')---26
     ||lpad(' ',43,' ')
     ||lpad(to_char(vfecdoc,'DD'),4, ' ')
     ||lpad(' ', 6, ' ')
     ||initcap(rpad(rtrim(to_char(vfecdoc,'month')), 10, ' '))||'  '
     ||lpad(to_char(vfecdoc,'YYYY'), 12, ' ')    
  ;
    
  --separar "orden" para que imprima en 2 lineas
  v_cli_txt := ltrim(rtrim(vbenef)); --quitar espacios a la izquierda y a la derecha
  if v_cli_txt is null then
    v_cli_txt_1 := ' ';
    v_cli_txt_2 := ' ';
  else
    v_cli_txt_1 := substr(v_cli_txt, 1, 19);
  end if;
  if length(v_cli_txt) > 19 then
    v_cli_txt_2 := substr(v_cli_txt, 20, 21);
  end if;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2'; --1/6.
  
  --orden1 en el talon.
  --monto del cheque.
  p_cheque_dato := p_cheque_dato ||
     rpad(v_cli_txt_1, 19, ' ')
     ||lpad(' ', 98,' ')
     ||lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#'
  ;
  
  v_obs_txt := rtrim(vobs);
  if v_obs_txt is null then
    v_obs_txt_1 := ' ';
    v_obs_txt_2 := ' ';
  else
    v_obs_txt_1 := substr(v_obs_txt, 1, 19);
    if length(v_obs_txt) > 19 then
      v_obs_txt_2 := substr(v_obs_txt, 20, 40);
    else
      v_obs_txt_2 := ' ';
    end if;
  end if;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --1/8.
  
  --concepto en talon.
  --fecha de vencimiento
  p_cheque_dato := p_cheque_dato ||
     rpad(v_obs_txt_1,19, ' ')---19
     ||lpad(' ', 45, ' ')--50    41*
     ||lpad(to_char(vfecvto,'DD'),4, ' ')--4
     ||lpad(' ', 6, ' ')
     ||initcap(rpad(rtrim(to_char(vfecvto,'month')), 10, ' '))||'  '
     ||lpad(to_char(vfecvto,'YYYY'), 12, ' ')    
  ;
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
  
  p_cheque_dato := p_cheque_dato || chr(27)||'2';
  
  --paguese a la orden de
  p_cheque_dato := p_cheque_dato ||
     lpad(' ',35,' ')
     ||rpad(vbenef, 80, ' ')
  ;
  
   p_cheque_dato := p_cheque_dato || chr(10);
  
  --total en letras.
  if v_num_txt_2 is null then
    p_cheque_dato := p_cheque_dato || 
       lpad(' ',47,' ')---43
       ||rpad(v_num_txt_1,90,' -')
    ;
     p_cheque_dato := p_cheque_dato || chr(10);
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',24,' ')
       ||lpad(' -',50,' -')
    ;
  else
    p_cheque_dato := p_cheque_dato || 
       lpad(' ',47,' ')---43
       ||v_num_txt_1
    ;
     p_cheque_dato := p_cheque_dato || chr(10);
    p_cheque_dato := p_cheque_dato || 
       lpad(' ',24,' ')
       ||v_num_txt_2
       ||lpad(' -',8,' -')
    ;
  end if;
  
  p_cheque_dato := p_cheque_dato || chr(27)||'0'; --1/6.
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
  
  --monto total del cheque.
  p_cheque_dato := p_cheque_dato ||
    lpad(' ',3,' ')
    ||rpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 20, ' ')
  ;   
  
    p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10)||CHR(10);
  
end;
--------------------------------

--------------------------------pl_cheque_vision_dif
procedure pl_cheque_vision_dif(
                                vclavecheque in number, 
                                p_form_impr  in number) is
  v_num_txt            varchar2(200) := ' ';
  v_num_txt_1          varchar2(90) := ' ';
  v_num_txt_2          varchar2(105) := ' ';
  v_num_txt_3          varchar2(95) := ' ';
  
  v_obs_txt            varchar2(40) := ' ';
  v_obs_txt_1          varchar2(20) := ' ';
  v_obs_txt_2          varchar2(26) := ' ';
  v_obs_txt_3          varchar2(26) := ' ';
  
  v_formato            varchar2(20);
  v_formato_loc        varchar2(20);
  v_formato_cant       varchar2(20);
  v_cli_txt            varchar2(50) := ' ';
  v_cli_txt_1          varchar2(20) := ' ';
  v_cli_txt_2          varchar2(21) := ' ';
  
  vformatocant         varchar2(20);
  vformatoimp          varchar2(20);
  
  -- datos que se obtienen del select
  vfecdoc              date;
  vfecvto              date;
  vtotmon              number;
  vbenef               varchar2(80);
  vmondecimp           number;
  vobs                 varchar2(40);
  vnrocheq             number;
  vserie               varchar2(3);
  vindi_dia_dife                varchar2(4);
  
  --variables para distici?n de monedas.
  c_dolares   constant varchar2(3) := 'U$S';
  c_guaranies constant varchar2(3) := 'GS';
  v_moneda             varchar2(3);
  
  v_num_txt_1_us       v_num_txt_1%type := ' '; 
  v_num_txt_2_us       v_num_txt_2%type := ' ';
  
  --variable creado para contener los errores de la funci?n de nro a txt.
  vmsg                 varchar2(2000);
begin
  --seleccionar los datos del cheque

  pl_select_cheques(vclavecheque, vfecdoc, vfecvto, vtotmon, vbenef, vobs, vmondecimp, vnrocheq, vserie, vindi_dia_dife);
  

  
  --mascaras de formato
  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
    
  --ba 09-05-2007: cambio de la funci?n que busca el texto de alg?n n?mero.
  v_num_txt := fl_nro_to_txt(vtotmon, vmondecimp, vmsg)||' '||'.-';
  if vmsg is not null then
    raise_application_error(-20001,vmsg);
  end if;
  
  if nvl(length(v_num_txt), 0) > 155 then
    raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  end if;
  pl_separar_texto_lib(v_num_txt, 90, 90, v_num_txt_1, v_num_txt_2);
  pl_separar_texto_lib(v_num_txt_2, 105, 90, v_num_txt_2, v_num_txt_3);
  
  
  ----------------------------------------------------
  ---- asignamos la moneda en la que trabajaremos ----
  ----------------------------------------------------
  if p_form_impr = 38 then
    v_moneda := c_guaranies;
  elsif p_form_impr = 39 then
    v_moneda := c_dolares;
  end if;
  
  ----------------------------
  --moneda en dolares(u$s)...!
  ----------------------------
  --if v_moneda = c_dolares then
  --  null;
  
  -----------------------------
  --moneda en guaranies(gs)...!
  -----------------------------
  --elsif v_moneda = c_guaranies then
    --se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(64); -- inicializar impresora
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(120)||'0'; --establecer modo draft
    
    p_cheque_dato := p_cheque_dato || chr(27)||chr(80); --establecer 10 cpi
    
    p_cheque_dato := p_cheque_dato || chr(15); --compactar(17 cpi(caracteres por pulgada))
    
    p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(24); --interespaciado 1/6 *** 25 
    
    --separar "orden" para que imprima en 2 lineas
 
    v_cli_txt := ltrim(rtrim(vbenef)); --quitar espacios a la izquierda y a la derecha
    if v_cli_txt is null then
      v_cli_txt_1 := ' ';
      v_cli_txt_2 := ' ';
    else
      v_cli_txt_1 := substr(v_cli_txt, 1, 19);
    end if;
    if length(v_cli_txt) > 19 then
      v_cli_txt_2 := substr(v_cli_txt, 20, 21);
    end if;
        
    v_obs_txt := rtrim(vobs);
    if v_obs_txt is null then
      v_obs_txt_1 := ' ';
      v_obs_txt_2 := ' ';
    else
      v_obs_txt_1 := substr(v_obs_txt, 1, 19);
      if length(v_obs_txt) > 19 then
        v_obs_txt_2 := substr(v_obs_txt, 20, 40);
      else
        v_obs_txt_2 := ' ';
      end if;
    end if;
    
    p_cheque_dato := p_cheque_dato || rpad('',20,' ');------linea nueva
   
      p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10)||CHR(10);
    
    --fecha talon y monto en cheques.
    p_cheque_dato := p_cheque_dato ||
       lpad(' ',3,' ')||
      --- to_char(vfecdoc,'dd/mm/yyyy')||
       lpad(' ',115,' ')||---98
       lpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#';
       
       
    --tal?n fecha vencimiento 
    p_cheque_dato := p_cheque_dato ||
      -- lpad(' ',3,' ')||to_char(vfecvto,'dd/mm/yyyy')||          ---||
       lpad(' ',3,' ')||to_char(vfecdoc,'DD/MM/YYYY')          ---toda esta linea
    ;

    p_cheque_dato := p_cheque_dato || chr(10);-----1 agrege
  --  lpad(' ',3,' ')||to_char(vfecvto,'dd/mm/yyyy')); --agregue lpad(' ',3,' ')||to_char(vfecvto,'dd/mm/yyyy');
    
    --orden en el talon y fecha de emision y fecha pago en el cheque.
    p_cheque_dato := p_cheque_dato ||
       rpad(v_cli_txt_1, 19, ' ')||
       lpad(' ', 13,' ')||----21
       lpad(to_char(vfecdoc,'DD'),4, ' ')||
       lpad(' ', 14, ' ')||
       initcap(rpad(rtrim(to_char(vfecdoc,'month')), 14, ' '))||'  '||
       lpad(' ',2,' ')||
       to_char(vfecdoc,'YYYY')||
       lpad(' ',18,' ')||----15---8
       lpad(to_char(vfecvto,'DD'),4, ' ')||
       lpad(' ', 10, ' ')||
       initcap(rpad(rtrim(to_char(vfecvto,'month')), 15, ' '))||'  '||
       lpad(' ', 5, ' ')||-----2
       lpad(to_char(vfecvto,'YYYY'), 8, ' ')-----5
    ;
    
    
     p_cheque_dato := p_cheque_dato || chr(10);
     
    --concepto tal?n y orden del cheque.
    p_cheque_dato := p_cheque_dato ||
       rpad(v_cli_txt_2, 19, ' ');
       
    p_cheque_dato := p_cheque_dato ||
       rpad(v_obs_txt_1, 23, ' ')||---19
       rpad(v_obs_txt_2, 17,' ')||----21
       lpad(' ', 1, ' ')||
       rpad(vbenef, 80, ' ')
    
    ;
    
   
      
    p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(27); --interespaciado 1/6 *** 25
     p_cheque_dato := p_cheque_dato || chr(10);
    
    --totales en letras.
    if v_num_txt_2 is null then
      p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(22); --interespaciado 1/6 *** 25
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',45,' ')---41
         ||rpad(v_num_txt_1,86,' -')----90
      ;
        p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
      p_cheque_dato := p_cheque_dato ||
         lpad(' ',37,' ')---29
         ||lpad(' -',46,' -')----50
      ;
    else
      p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(22); --interespaciado 1/6 *** 25
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',47,' ')----41
         ||v_num_txt_1
      ;
        p_cheque_dato:= p_cheque_dato||CHR(10)||CHR(10);
      p_cheque_dato := p_cheque_dato || 
         lpad(' ',37,' ')---29
         ||v_num_txt_2
         ||lpad(' -',1,' -')---8
      ;
    end if;

    
    p_cheque_dato := p_cheque_dato || chr(27)|| '3' ||chr(15); --interespaciado 1/6 *** 25
    
    
    --monto total del cheque.
    p_cheque_dato := p_cheque_dato ||
      lpad(' ',6,' ')
      ||rpad(nvl(to_char(vtotmon, vformatoimp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 20, ' ')
    ;   
    
    
  --  text_io.new_line(v_impresora, 20);
    
 -- end if;
   -----cargar  en la tabla
      p_taax_seq := p_taax_seq + 1;
    insert into come_tabl_auxi
      (taax_seq, taax_c050, taax_sess, taax_user)
    values
      (p_taax_seq, p_cheque_dato, 13, gen_user);
    commit;
  
end;
--------------------------------

--------------------------------pl_cheque_estandar

--------------------------------PL_CHEQUE_ESTANDAR
PROCEDURE PL_CHEQUE_ESTANDAR(v_impresora  IN out clob,
                                vClaveCheque IN NUMBER, 
                                p_form_impr  in number) IS
  V_NUM_TXT            VARCHAR2(200) := ' ';
  V_NUM_TXT_1          VARCHAR2(90) := ' ';
  V_NUM_TXT_2          VARCHAR2(105) := ' ';
  V_NUM_TXT_3          VARCHAR2(95) := ' ';
  
  V_OBS_TXT            VARCHAR2(40) := ' ';
  V_OBS_TXT_1          VARCHAR2(20) := ' ';
  V_OBS_TXT_2          VARCHAR2(26) := ' ';
  V_OBS_TXT_3          VARCHAR2(26) := ' ';
  
  V_FORMATO            VARCHAR2(20);
  V_FORMATO_LOC        VARCHAR2(20);
  V_FORMATO_CANT       VARCHAR2(20);
  V_CLI_TXT            VARCHAR2(90) := ' ';
  
  V_CLI_TXT_1          VARCHAR2(90) := ' ';
  V_CLI_TXT_2          VARCHAR2(90) := ' ';
  
  V_FECH_DOCU          DATE;
  V_FECH_VENC          DATE;
  
  vFormatoCant         VARCHAR2(20);
  vFormatoImp          VARCHAR2(20);
  
  -- datos que se obtienen del select
  vFecDoc              date;
  vFecVto              date;
  vTotMon              number;
  vBenef               varchar2(90);
  vMonDecImp           number;
  vObs                 varchar2(40);
  vNroCheq             number;
  vSerie               varchar2(3);
  vIndi_dia_dife       varchar2(4);
  
  --Variables para Distici?n de Monedas.
  C_DOLARES   CONSTANT VARCHAR2(3) := 'U$S';
  C_GUARANIES CONSTANT VARCHAR2(3) := 'GS';
  V_MONEDA             VARCHAR2(3);
  
  V_NUM_TXT_1_US       V_NUM_TXT_1%TYPE := ' '; 
  V_NUM_TXT_2_US       V_NUM_TXT_2%TYPE := ' ';
  
  --Variable creado para contener los errores de la funci?n de nro a txt.
  vMsg                 VARCHAR2(2000);
  
  v_espacio_us varchar2(12);
  
  v_espa_mont_text number;

  v_espacio_lineas number;
  
  -------
   v_cheque_dato blob;
    v_bfile bfile;
  v_blob  blob;
  
  --v_fiup_filename varchar2(60):='impresora.txt';
BEGIN
  --Seleccionar los datos del cheque

  PL_SELECT_CHEQUES(vClaveCheque, vFecDoc, vFecVto, vTotMon, vBenef, vObs, vMonDecImp, vNroCheq, vSerie, vIndi_dia_dife);
 
 
  --mascaras de formato
 vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
    
  --BA 09-05-2007: Cambio de la funci?n que busca el texto de alg?n n?mero.
  
  V_NUM_TXT := fl_nro_to_txt(vTotMon, vMonDecImp, vMsg)||' '||'.-';
  IF vMsg IS NOT NULL THEN
    raise_application_error(-20001,vMsg);
  END IF;
  
  IF NVL(LENGTH(V_NUM_TXT), 0) > 155 THEN
     raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  END IF;
  
  
  IF p_form_impr = 40 THEN
    V_MONEDA := C_GUARANIES;
    v_espacio_us := '';
    v_espacio_lineas := 90;
    v_espa_mont_text := 4;
  ELSIF p_form_impr = 41 THEN
    V_MONEDA := C_DOLARES;
    v_espacio_us := '            ';
    v_espacio_lineas:=78;
    v_espa_mont_text := 6;
  END IF;
  
  
  if V_MONEDA = C_GUARANIES then
  PL_SEPARAR_TEXTO_LIB(V_NUM_TXT, 90, 90, V_NUM_TXT_1, V_NUM_TXT_2);
  PL_SEPARAR_TEXTO_LIB(V_NUM_TXT_2, 105, 90, V_NUM_TXT_2, V_NUM_TXT_3);
  else

  PL_SEPARAR_TEXTO_LIB(V_NUM_TXT, 78, 78, V_NUM_TXT_1, V_NUM_TXT_2);
  PL_SEPARAR_TEXTO_LIB(V_NUM_TXT_2, 105, 78, V_NUM_TXT_2, V_NUM_TXT_3);
    
  end if; 
  
  ----------------------------------------------------
  ---- ASIGNAMOS LA MONEDA EN LA QUE TRABAJAREMOS ----
  ----------------------------------------------------


    --Se envia dos veces la misma instruccion, porque si se enciende
    --la impresora despues de iniciado windows , entonces la primera
    --instruccion no se ejecuta.
    
    
    --print_tmu.PUT(V_IMPRESORA, CHR(27)||CHR(120)||'0'); --establecer modo DRAFT
    
    --print_tmu.PUT(V_IMPRESORA, CHR(27)||CHR(64)); -- inicializar impresora
    
    --print_tmu.PUT(V_IMPRESORA, CHR(27)||CHR(120)||'0'); --establecer modo DRAFT
    
    --print_tmu.PUT(V_IMPRESORA, CHR(27)||CHR(80)); --establecer 10 cpi
    
    --print_tmu.PUT(V_IMPRESORA, CHR(15)); --compactar(17 cpi(caracteres por pulgada))
    
   -- print_tmu.put(v_impresora, chr(27)|| '3' ||chr(24)); --interespaciado 1/6 *** 25 
    
    --separar "Orden" para que imprima en 2 lineas
  
    
    V_CLI_TXT := ltrim(rtrim(vBenef)); --quitar espacios a la izquierda y a la derecha
    IF V_CLI_TXT IS NULL THEN
      V_CLI_TXT_1 := ' ';
      V_CLI_TXT_2 := ' ';
    ELSE
      V_CLI_TXT_1 := SUBSTR(V_CLI_TXT, 1, 14);-------1 , 19 ---16 saque letras
    END IF;
    IF LENGTH(V_CLI_TXT) > 14 THEN  ------------19--16
      v_cli_txt_2 := null;
    END IF;
        
    V_OBS_TXT := rtrim(vObs);
    IF V_OBS_TXT IS NULL THEN
      V_OBS_TXT_1 := ' ';
      V_OBS_TXT_2 := ' ';
    ELSE
      V_OBS_TXT_1 := SUBSTR(V_OBS_TXT, 1, 14);-----19---16
      IF LENGTH(V_OBS_TXT) > 14 THEN------19---16
    V_OBS_TXT_2 :=  ' ';
      ELSE
        V_OBS_TXT_2 := ' ';
      END IF;
    END IF;
   
   
    
    print_tmu.NEW_LINE(V_IMPRESORA, 0);
    
    --Fecha TALON Y MONTO en cheques.
    print_tmu.PUT_LINE(V_IMPRESORA,
       LPAD(' ',3,' ')||
       LPAD(' ',115,' ')||
       LPAD(NVL(TO_CHAR(vTotMon, vFormatoImp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 14, '#')||'#');

       print_tmu.PUT_LINE(V_IMPRESORA, RPAD('',20,' '));
       print_tmu.PUT_LINE(V_IMPRESORA, RPAD('',20,' '));
       print_tmu.PUT_LINE(V_IMPRESORA, RPAD('',20,' '));
       
   if vIndi_dia_dife = 'DIFE' then 
     V_FECH_DOCU := vFecDoc;
     V_FECH_VENC := vFecVto;
   else
     V_FECH_DOCU := vFecVto;
     V_FECH_VENC := null;
   end if;
   
    
    --Tal?n FECHA vENCIMIENTO 
    print_tmu.PUT_LINE(V_IMPRESORA,
       LPAD(' ',3,' ')||RPAD(TO_CHAR(vFecDoc,'DD-MM-YYYY'),62, ' '));
    
    --ORDEN EN EL TALON Y FECHA DE EMISION Y FECHA PAGO EN EL CHEQUE.
   
   
    print_tmu.PUT_LINE(V_IMPRESORA,
       LPAD(' ',3,' ')||RPAD(' ',62, ' ')||
       LPAD(' ', 11,' ')||
       LPAD(TO_CHAR(V_FECH_DOCU,'DD'),3, ' ')||
       LPAD(' ', 5, ' ')||
       INITCAP(RPAD(RTRIM(TO_CHAR(V_FECH_DOCU,'MM')), 3, ' '))||'  '||----3
       LPAD(' ', 7,' ')||
       TO_CHAR(V_FECH_DOCU,'YY')||
       LPAD(' ', 14,' ')||
       LPAD(TO_CHAR(V_FECH_VENC,'DD'),4, ' ')||
       LPAD(' ', 4, ' ')||
       INITCAP(RPAD(RTRIM(TO_CHAR(V_FECH_VENC,'MM')), 3, ' '))||'  '||
       LPAD(' ', 7, ' ')||
       TO_CHAR(V_FECH_VENC,'YY')
       );
    
     print_tmu.PUT_LINE(V_IMPRESORA,
       RPAD(V_CLI_TXT_1, 62, ' '));
     
    --CONCEPTO Tal?n Y ORDEN DEL CHEQUE.
    print_tmu.PUT_LINE(V_IMPRESORA,
       RPAD(V_CLI_TXT_2, 14, ' '));
       
    print_tmu.PUT_LINE(V_IMPRESORA,
       RPAD(V_OBS_TXT_1, 17, ' ')||
       RPAD(V_OBS_TXT_2, 23,' ')||
       LPAD(' ', 2, ' ')||
       RPAD(vBenef, 90, ' ')  
    );
    
    --print_tmu.put(v_impresora, chr(27)|| '3' ||chr(27)); --interespaciado 1/6 *** 25
    print_tmu.NEW_LINE(V_IMPRESORA, 1);
 
    --Totales en Letras.
    IF V_NUM_TXT_2 IS NULL THEN
     -- print_tmu.put(v_impresora, chr(27)|| '3' ||chr(22)); --interespaciado 1/6 *** 25
      
      ------------ Fecha venc talon
     if V_FECH_VENC is not null then
      
      print_tmu.PUT_LINE(V_IMPRESORA,
       LPAD(' ',2,' ')||'V'||RPAD(TO_CHAR(V_FECH_VENC,'DD/MM/YYYY'),11, ' ')||
             ------------ Fecha venc talon
        LPAD(' ',27,' ')----41
         ||v_espacio_us
         ||RPAD(V_NUM_TXT_1,v_espacio_lineas,' -')
      );
      print_tmu.NEW_LINE(V_IMPRESORA, 2);
      print_tmu.PUT_LINE(V_IMPRESORA,
         LPAD(' ',29,' ')
         ||LPAD(' -',50,' -')
      );
     else
       print_tmu.PUT_LINE(V_IMPRESORA,
       LPAD(' ',2,' ')||'V'||RPAD('----------',11, ' ')||
      ------------ Fecha venc talon

         LPAD(' ',27,' ')-----41
         ||v_espacio_us||RPAD(V_NUM_TXT_1,v_espacio_lineas,' -')
      );
      print_tmu.NEW_LINE(V_IMPRESORA, 2);
      print_tmu.PUT_LINE(V_IMPRESORA,
         LPAD(' ',29,' ')
         ||LPAD(' -',50,' -')
      );
      end if;
    ELSE
   --   print_tmu.put(v_impresora, chr(27)|| '3' ||chr(22)); --interespaciado 1/6 *** 25
      print_tmu.PUT_LINE(V_IMPRESORA, 
         LPAD(' ',41,' ')
         ||v_espacio_us
         ||V_NUM_TXT_1
      );
      print_tmu.NEW_LINE(V_IMPRESORA, 2);
      print_tmu.PUT_LINE(V_IMPRESORA, 
         LPAD(' ',29,' ')
         ||V_NUM_TXT_2
         ||LPAD(' -',8,' -')
      );
    END IF;


    
   -- print_tmu.put(v_impresora, chr(27)|| '3' ||chr(15)); --interespaciado 1/6 *** 25

    print_tmu.NEW_LINE(V_IMPRESORA, 7);
   
    --MONTO TOTAL DEL CHEQUE.
    print_tmu.PUT_LINE(V_IMPRESORA,
      LPAD(' ',v_espa_mont_text,' ')--3--6--8
      ||RPAD(NVL(TO_CHAR(vTotMon, vFormatoImp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 20, ' ')
    );   
     
    --TEXT_IO.PUT(v_impresora, chr(27)|| '3' ||chr(37));----- interespaciado 1/6 *** 25
    print_tmu.NEW_LINE(V_IMPRESORA, 13);-----15
    
    
 -- END IF;
 
  
END PL_CHEQUE_ESTANDAR;


--------------------------------PL_CHEQUE_CONTINENTAL
PROCEDURE PL_CHEQUE_CONTINENTAL(v_impresora  IN out clob,
                                vClaveCheque IN NUMBER, 
                                p_form_impr  IN NUMBER)
IS
  
  V_NUM_TXT      VARCHAR2(500) := ' ';
  
  V_OBS_TXT      VARCHAR2(40) := ' ';
  V_OBS_TXT_1    VARCHAR2(20) := ' ';
  V_OBS_TXT_2    VARCHAR2(26) := ' ';
  V_OBS_TXT_3    VARCHAR2(26) := ' ';
  
  V_FORMATO      VARCHAR2(20);
  V_FORMATO_LOC  VARCHAR2(20);
  V_FORMATO_CANT VARCHAR2(20);
  SALIR          EXCEPTION;
    
  vFormatoCant   VARCHAR2(20);
  vFormatoImp    VARCHAR2(20);
  
  -- datos que se obtienen del select
  vFecDoc        date;
  vFecVto        date;
  vTotMon        number;
  vBenef         varchar2(80);
  vMonDecImp     number;
  vObs           varchar2(40);
  vNroCheq       varchar2(30);
  vSerie         varchar2(2);
  vIndi_dia_dife            varchar2(4);

  --Variable creado para contener los errores de la funci?n de nro a txt.
  vMsg             VARCHAR2(2000);
    
BEGIN
  -- Seleccionar los datos del cheque
  PL_SELECT_CHEQUES(vClaveCheque, vFecDoc, vFecVto, vTotMon, vBenef, vObs, vMonDecImp, vNroCheq, vSerie, vIndi_dia_dife);
     


  vformatocant := '99990D00';
  vformatoimp := fl_formato(13, vmondecimp);
    
  --BA 09-05-2007: Cambio de la funci?n que busca el texto de alg?n n?mero.
  V_NUM_TXT := fl_nro_to_txt(vTotMon, vMonDecImp, vMsg)||' '||'.-';
  IF vMsg IS NOT NULL THEN
    raise_application_error(-20001,vMsg);
  END IF;
  
  IF NVL(LENGTH(V_NUM_TXT), 0) > 138 THEN
       raise_application_error(-20001,'La descripci?n del importe total en letras es muy larga. No se puede imprimir!');
  END IF;
  V_NUM_TXT := RPAD(V_NUM_TXT, 145, ' -');
  
  -- Se envia dos veces la misma instruccion, porque si se enciende
  -- la impresora despues de iniciado windows , entonces la primera
  -- instruccion no se ejecuta.
  
  print_tmu.PUT(V_IMPRESORA, CHR(27)||CHR(120)||'0'); --establecer modo DRAFT
  
  print_tmu.PUT(V_IMPRESORA, CHR(27)||CHR(64)); -- inicializar impresora
  
  print_tmu.PUT(V_IMPRESORA, CHR(27)||CHR(120)||'0'); --establecer modo DRAFT
  
  print_tmu.PUT(V_IMPRESORA, CHR(27)||CHR(80)); --establecer 10 cpi
  
  print_tmu.PUT(V_IMPRESORA, CHR(15)); --compactar(17 cpi(caracteres por pulgada))
  
  print_tmu.PUT(V_IMPRESORA, CHR(27)||'2'); --establecer 1/6 (inch line spacing)
  
  print_tmu.NEW_LINE(V_IMPRESORA, 1); --1 linea en blanco
  
  print_tmu.PUT(V_IMPRESORA, CHR(27)||'0'); --establecer 1/8 (inch line spacing)
  
  --TEXT_IO.NEW_LINE(V_IMPRESORA, 1); --1 linea en blanco
  
  print_tmu.PUT(V_IMPRESORA, CHR(27)||'2'); --establecer 1/6 (inch line spacing)
  
  --Monto total del cheque
  IF p_form_impr = 3 THEN
    print_tmu.PUT_LINE(V_IMPRESORA,
       LPAD(' ', 110, ' ')
       ||LPAD(NVL(TO_CHAR(vTotMon, vFormatoImp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 19, '#')
       ||'#'
    );
  ELSE
    print_tmu.PUT_LINE(V_IMPRESORA,
       LPAD(' ', 112, ' ')
       ||LPAD(NVL(TO_CHAR(vTotMon, vFormatoImp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 17, '#')
       ||'#'
    );
  END IF;
  
   
 
  
  --fecha en el talon
  print_tmu.PUT_LINE(V_IMPRESORA,
     LPAD(TO_CHAR(vFecDoc,'DD'),7, ' ')||'/'
     ||LPAD(TO_CHAR(vFecDoc,'MM'),2, ' ')||'/'
     ||LPAD(TO_CHAR(vFecDoc,'YYYY'),4, ' '));
  
  print_tmu.put(v_impresora, chr(27)|| '3' ||chr(25)); --interespaciado 1/6 *** 25
  --orden en talon 
  print_tmu.PUT_LINE(V_IMPRESORA,
     LPAD(NVL(SUBSTR(vBenef,1,17),' '),17,' '));
 
  -- fecha de operacion en letras
  print_tmu.PUT_LINE(V_IMPRESORA, 
     LPAD(' ',90, ' ') 
     ||LPAD(TO_CHAR(vFecDoc,'DD'),2, ' ')
     ||LPAD(' ', 10, ' ')
     ||INITCAP(RPAD(RTRIM(TO_CHAR(vFecDoc,'month')), 17, ' '))
     ||LPAD(TO_CHAR(vFecDoc,'YYYY'), 8, ' '));
  
  --Formato de concepto
  V_OBS_TXT := rtrim(vObs);
  PL_SEPARAR_TEXTO_LIB(V_OBS_TXT, 20, 20, V_OBS_TXT_1, V_OBS_TXT_2);
  PL_SEPARAR_TEXTO_LIB(V_OBS_TXT_2, 26, 16, V_OBS_TXT_2, V_OBS_TXT_3);
  
  V_OBS_TXT_1 := NVL(V_OBS_TXT_1, ' ');
  V_OBS_TXT_2 := NVL(V_OBS_TXT_2, ' ');
  
  --concepto en 1? linea
  print_tmu.PUT_LINE(V_IMPRESORA,
     RPAD(V_OBS_TXT_1,17, ' ')
  );
  
  --2da. linea de concepto y orden en el cheque  
  print_tmu.PUT(V_IMPRESORA, CHR(27)||'0'); --establecer 1/6 (inch line spacing)
  print_tmu.PUT_LINE(V_IMPRESORA,
     RPAD(V_OBS_TXT_2,17, ' ')
     ||LPAD(' ',25,' ')
     ||RPAD(vBenef, 100,' ')
  );
  
    
  IF V_OBS_TXT_2 IS NULL THEN
    V_OBS_TXT_2 := ' '; --para que tenga algo que imprimir y rellenar con espacios
  END IF;
 
 
  --  1ra. linea de numero en letras cerrada con - - -
  IF p_form_impr = 3 THEN
    print_tmu.PUT_LINE(V_IMPRESORA,
    LPAD(' ',40,' ') 
    ||SUBSTR(V_NUM_TXT, 1, 88)
    );
  ELSE
    print_tmu.PUT_LINE(V_IMPRESORA,
       LPAD(' ', 50, ' ')
       ||SUBSTR(V_NUM_TXT, 1, 80)
    );    
  END IF;
  print_tmu.put(v_impresora, chr(27)|| '3' ||chr(40)); --interespaciado 1/6 *** 25
  print_tmu.PUT(V_IMPRESORA, CHR(27)||'0'); --establecer 1/8 (inch line spacing)
  
 
  print_tmu.NEW_LINE(V_IMPRESORA,2);
  --2da. linea de numero en letras
  IF p_form_impr = 3 THEN
    print_tmu.PUT_LINE(V_IMPRESORA,
       LPAD(' ', 21, ' ')
       ||SUBSTR(V_NUM_TXT,89,57)
    );
  ELSE
    print_tmu.PUT_LINE(V_IMPRESORA,
       LPAD(' ', 21, ' ')
       ||SUBSTR(V_NUM_TXT,81,57)
    );
  END IF;
  
  print_tmu.PUT(V_IMPRESORA, CHR(27)||'2'); --establecer 1/6 (inch line spacing)
  print_tmu.NEW_LINE(V_IMPRESORA, 1); --1 lineas en blanco
  print_tmu.PUT(V_IMPRESORA, CHR(27)||'0'); --establecer 1/8 (inch line spacing)
 
  
  --monto total del cheque
  print_tmu.PUT_LINE(V_IMPRESORA,
     LPAD(' ', 4, ' ')
     ||RPAD(NVL(TO_CHAR(vTotMon, vFormatoImp, 'NLS_NUMERIC_CHARACTERS = '',.'''), ' '), 22, ' ')
  );
  
  
  
  print_tmu.PUT(V_IMPRESORA, CHR(27)||'2'); --establecer 1/6 (inch line spacing)
  print_tmu.NEW_LINE(V_IMPRESORA,4); -- 4 lineas en blanco
  
EXCEPTION
  WHEN SALIR THEN 
    NULL;
END PL_CHEQUE_CONTINENTAL;





procedure pp_buscar_formato_cheque (p_cuen_banc      in number,                                     
                                    FormatoImpresion out number,
                                    v_Path_Impresora out varchar2, 
                                    p_indi_dia_dife varchar2) is
 -- v_impresora      clob;  
begin

  select decode(upper(p_indi_dia_dife), 'DIFE', cb.cuen_dife_foch_codi, cb.cuen_foch_codi), i.impr_ubic
    into FormatoImpresion, v_Path_Impresora
    from come_pers_comp pc, 
         come_impr i,
         come_cuen_peco cp,     
         come_cuen_banc cb
         
   where cp.cupe_peco_codi = pc.peco_codi
     and cp.cupe_impr_codi = i.impr_codi
     and cb.cuen_codi      = cp.cupe_cuen_codi

     and pc.peco_codi        = parameter.p_peco_codi     
     and cp.cupe_cuen_codi   = p_cuen_banc; 
     
    
  if formatoimpresion is null then
    raise_application_error(-20001,'Debe asignar un formato de impresi?n de cheque!');  
  end if;  

  if v_Path_Impresora is null then
     raise_application_error(-20001,'Debe asignar una direcci?n de impresora!');
  else  
    declare
      impresoranoregistrada exception;
      pragma exception_init(impresoranoregistrada, -302000);
      v_alert number;
      salir exception;
      begin
        --v_impresora := print_tmu.fopen('DIR_TEMP_ALARMAS',v_path_impresora, 'W'); --abrir puerto de impresora
      --  print_tmu.fclose(v_impresora); --cerrar impresora
      null;
      exception
        when impresoranoregistrada then
          v_Path_Impresora := null;
           raise_application_error(-20001,'No se podr? imprimir el cheque.la impresora que desea utilizar no se encuentra. verifique los datos de la configuracion de cuentas bancarias');
        when salir then
          raise_application_error(-20001,sqlerrm);
      end;
  end if;
 
exception
  when no_data_found then
    formatoimpresion := null;
    v_Path_Impresora        := null;
  when others then
    raise_application_error(-20001,sqlerrm);
end;

--imprimir los cheques emitidos directamente al puerto de la impresora
procedure pp_impr_cheq_emit is
  v_impresora      clob;
  v_path_impresora varchar2(60);
  v_cheq_codi      number;
  v_form_impr      number;
  v_cheque_dato blob;

  v_blob  blob;
  
  --v_fiup_filename varchar2(60):='impresora.txt';
begin
  




   I020209.pp_actualizar_cheque_emit(p_cheq_codi => v('P9_CLAVE_CHEQUE'));


    
    pp_buscar_formato_cheque(v('P9_CHEQ_CUEN_CODI'), v_form_impr, v_Path_Impresora, v('P9_CHEQ_INDI_DIA_DIFE'));
     --print_tmu.PUT_LINE(V_IMPRESORA, RPAD('',20,' '));
    
     --raise_application_error(-20001,v_Path_Impresora);
     --print_tmu.PUT_LINE(V_IMPRESORA, RPAD('',20,' '));
    if v_form_impr is not null and v_path_impresora is not null then
      
      declare
      impresoranoregistrada exception;
      pragma exception_init(impresoranoregistrada, -302000);
      v_alert number;
      salir exception;
      begin
     --   v_impresora := print_tmu.fopen('DIR_TEMP_ALARMAS',v_Path_Impresora, 'W'); --abrir puerto de impresora
        
        
       v_cheq_codi := v('P9_CLAVE_CHEQUE');--:bdet.cheq_codi;
      
       pl_imprimir_cheque(v_impresora, v_cheq_codi, v_form_impr);
        
    --RAISE_APPLICATION_ERROR(-20001,'THIS IS A FUKING PROODF...'||v_impresora);
      exception
        when impresoranoregistrada then
          v_Path_Impresora := null;
          raise_application_error(-20001,'No se podr? imprimir el cheque.la impresora que desea utilizar no se encuentra. verifique los datos de la configuracion de cuentas bancarias');
        when salir then
          null;
      end;
    end if;
    

    print_tmu.fclose(v_impresora);--cierra impresora
    
   -- RAISE_APPLICATION_ERROR(-20001,'THIS IS A FUKING PROODF...'||v_cheq_codi||v_impresora);
    
    
    
   


    
exception
  when no_data_found then
    null;
end pp_impr_cheq_emit;

PROCEDURE PL_IMPRIMIR_CHEQUE (v_impresora  IN out clob, 
                              vClaveCheque IN NUMBER,
                              p_form_impr  in number) 
IS
  SALIR EXCEPTION;
BEGIN
  
  
 /* IF  p_form_impr IN (1,2) THEN
    PL_CHEQUE_ABN(v_impresora, vClaveCheque, p_form_impr);
    
  ELS*/ 
 
    IF p_form_impr IN (3,4) THEN
     
    PL_CHEQUE_CONTINENTAL(v_impresora, vClaveCheque, p_form_impr);
    /*
  ELSIF p_form_impr IN (5,6) THEN
    PL_CHEQUE_REGIONAL(v_impresora, vClaveCheque, p_form_impr);
    
  ELSIF p_form_impr IN (7,31) THEN
    PL_CHEQUE_CONTINENTAL_DIF(v_impresora, vClaveCheque, p_form_impr);
    
  ELSIF p_form_impr IN (8,9) THEN
    PL_CHEQUE_FOMENTO(v_impresora, vClaveCheque, p_form_impr);
    
  ELSIF p_form_impr IN (10,11) THEN
    PL_CHEQUE_INTERBANCO(v_impresora, vClaveCheque, p_form_impr);
    
  ELSIF p_form_impr IN (12) THEN
    PL_CHEQUE_INTERBANCO_DIF(v_impresora, vClaveCheque, p_form_impr);
    
  ELSIF p_form_impr IN (13) THEN
    PL_CHEQUE_BBVA(v_impresora, vClaveCheque, p_form_impr);
  
  ELSIF p_form_impr IN (14,25) THEN
    PL_CHEQUE_SUDAMERIS(v_impresora, vClaveCheque, p_form_impr);
  
  ELSIF p_form_impr = 15 THEN
    PL_CHEQUE_FOMENTO_DIF(v_impresora, vClaveCheque, p_form_impr);
  
  ELSIF p_form_impr IN (16,22) THEN
    PL_CHEQUE_ABN_DIF(v_impresora, vClaveCheque, p_form_impr);
  
  ELSIF p_form_impr IN (17,18) THEN
    PL_CHEQUE_REGIONAL_DIF(v_impresora, vClaveCheque, p_form_impr);
    
  ELSIF p_form_impr IN (19) THEN
    PL_CHEQUE_HSBC(v_impresora, vClaveCheque, p_form_impr);
    
  ELSIF p_form_impr IN (20,21) THEN
    PL_CHEQUE_AMAMBAY_DIF(v_impresora, vClaveCheque, p_form_impr);
  
  ELSIF p_form_impr IN (26,27) THEN 
    PL_CHEQUE_ATLAS(v_impresora, vClaveCheque, p_form_impr);
  
  ELSIF p_form_impr IN (28,29) THEN 
    PL_CHEQUE_ATLAS_DIF(v_impresora, vClaveCheque, p_form_impr); 
  
  ELSIF p_form_impr IN (30) THEN 
    PL_CHEQUE_SUDAMERIS_HP(v_impresora, vClaveCheque, p_form_impr);   
      
  ELSIF p_form_impr IN (32,33) THEN 
    PL_CHEQUE_SUDAMERIS_DIF(v_impresora, vClaveCheque, p_form_impr);
  
  ELSIF p_form_impr IN (34,35) THEN 
    PL_CHEQUE_BBVA_DIF(v_impresora, vClaveCheque, p_form_impr);  
    
  ELSIF p_form_impr IN (36,37) THEN 
    PL_CHEQUE_ITAU_DIF(v_impresora, vClaveCheque, p_form_impr);  
      
  ELSIF p_form_impr IN (38,39) THEN 
    PL_CHEQUE_VISION_DIF(v_impresora, vClaveCheque, p_form_impr); 
    */
    
    
  ELSIF p_form_impr IN (40,41) THEN 
   
    PL_CHEQUE_ESTANDAR(v_impresora, vClaveCheque, p_form_impr);
    
  ELSE
    raise_application_error(-20001,'Debe definir un formato para la impresion de cheque en el Mantenimiento de Cuentas Bancarias. '|| p_form_impr);
    RAISE SALIR;
  END IF;
  
EXCEPTION
  WHEN SALIR THEN
   NULL;
END PL_IMPRIMIR_CHEQUE;




end i020209;
