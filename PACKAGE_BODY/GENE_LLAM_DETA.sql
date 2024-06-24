
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."GENE_LLAM_DETA" is

  procedure pa_gene_llam_deta(p_clpr_codi              in number,
                              p_llam_cont_codi         in number,
                              p_llam_meco_codi         in number,
                              p_llam_fech_prox         in date,
                              p_llam_fech_prom_pago    in date,
                              p_llam_tema_trata        in varchar2,
                              p_llam_codi_err          in number default null,
                              p_ind_emple              in varchar2 default 'N',
                              p_llam_lote_err          in varchar2 default null,
                              p_mensaje                in varchar2 default null,
                              p_mens_rest              in varchar2 default null,
                              p_llam_nro_tele          in varchar2 default null,
                              p_user                   in varchar2 default null,
                              p_llam_fech_grab         in varchar2 default null,
                              p_indi_gene_por_cons_api in varchar2 default null,
                              p_time_call_dura         in varchar2 default null,
                              p_llam_conn_id           in varchar2 default null) is
  
    cursor c_dato_cuot(p_codi_clpr in number) is
      select cu.cuot_fech_venc, cu.cuot_id
        from come_movi_cuot cu, come_movi m
       where cu.cuot_movi_codi = m.movi_codi
         and cu.cuot_sald_mone > 0
         and cu.cuot_fech_venc < trunc(sysdate)
         and m.movi_clpr_codi = p_codi_clpr
       order by cu.cuot_fech_venc;
  
    v_llam_nume_item      number(20);
    v_llam_clpr_codi      number(20);
    v_llam_cope_nume_item number(10);
    v_llam_indi_tipo      varchar2(2);
    v_llam_fech           date;
    v_llam_hora           date;
    v_llam_pers           varchar2(100);
    v_llam_tema_trata     varchar2(2000);
    v_llam_tele           varchar2(50);
    v_llam_base           number(2);
    v_llam_fech_visi      date;
    v_llam_fech_prox      date;
    v_llam_indi_real      varchar2(1);
    v_llam_indi_cobr      varchar2(1);
    v_llam_indi_prob      varchar2(1);
    v_llam_fech_reco      date;
    v_llam_reco_obse      varchar2(500);
    v_llam_empl_codi      number(10);
    v_llam_user_regi      varchar2(200);
    v_llam_fech_regi      date;
    v_llam_user_modi      varchar2(20);
    v_llam_fech_modi      date;
    v_llam_cont_codi      number(20);
    v_llam_empr_codi      number(20);
    v_llam_juri_codi      number(20);
    v_llam_nume_item_orig number(20);
    v_llam_inve_codi      number(20);
    v_llam_rell_codi      number(20);
    v_llam_movi_codi      number(20);
    v_llam_proc_id        number(20);
    v_llam_fech_prom_pago date;
    v_llam_meco_codi      number(20);
  
    v_deta_codi number;
  
  begin
  
    if p_ind_emple = 'N' or p_ind_emple is null then
      begin
        select u.user_empl_codi
          into v_llam_empl_codi
          from segu_user u
         where lower(u.user_login) = lower(gen_user);
      
      exception
        when others then
          v_llam_empl_codi := null;
      end;
      
    elsif p_ind_emple is not null then -- esto es enviado directo desde la sincronizacion de wolkvox/walrus el codigo del empleado 
      v_llam_empl_codi := p_ind_emple;
    else
      
      begin
        select f.clpr_empl_codi_recl
          into v_llam_empl_codi
          from come_clie_prov f
         where f.clpr_codi = p_clpr_codi;
      exception
        when others then
          v_llam_empl_codi := null;
      end;
    end if;
  
    v_llam_clpr_codi      := p_clpr_codi;
    v_llam_cope_nume_item := null;
    v_llam_indi_tipo      := 'C';
    v_llam_fech           := case when p_llam_conn_id is null then sysdate else to_date(p_llam_fech_grab,'yyyy-mm-dd hh24:mi:ss') end;
    v_llam_hora           := to_date('01' ||
                                     to_char(sysdate, '/mm/yyyy hh24:mi:ss'),
                                     'dd/mm/yyyy hh24:mi:ss');
    v_llam_pers           := null;
    v_llam_tema_trata     := p_llam_tema_trata;
    v_llam_tele           := null;
    v_llam_base           := 1;
    v_llam_fech_visi      := null;
    v_llam_fech_prox      := p_llam_fech_prox;
    v_llam_indi_real      := 'N';
    v_llam_indi_cobr      := 'N';
    v_llam_indi_prob      := 'N';
    v_llam_fech_reco      := null;
    v_llam_reco_obse      := null;
    v_llam_user_regi      := nvl(p_user, gen_user);
    v_llam_fech_regi      := sysdate;
    v_llam_user_modi      := null;
    v_llam_fech_modi      := null;
    v_llam_cont_codi      := p_llam_cont_codi;
    v_llam_empr_codi      := 1;
    v_llam_juri_codi      := null;
    v_llam_nume_item_orig := null;
    v_llam_inve_codi      := null;
    v_llam_rell_codi      := null;
    v_llam_movi_codi      := null;
    v_llam_proc_id        := null;
    v_llam_fech_prom_pago := p_llam_fech_prom_pago;
    v_llam_meco_codi      := p_llam_meco_codi;
  
    begin
      
    --le damos prioridodad a este procedimiento
    lock table come_clie_llam_cobr in exclusive mode;
      
    
      select nvl(max(llam_nume_item), 0) + 1
        into v_llam_nume_item
        from come_clie_llam_cobr;
    end;
  
    insert into come_clie_llam_cobr
      (llam_nume_item,
       llam_clpr_codi,
       llam_cope_nume_item,
       llam_indi_tipo,
       llam_fech,
       llam_hora,
       llam_pers,
       llam_tema_trata,
       llam_tele,
       llam_base,
       llam_fech_visi,
       llam_fech_prox,
       llam_indi_real,
       llam_indi_cobr,
       llam_indi_prob,
       llam_fech_reco,
       llam_reco_obse,
       llam_empl_codi,
       llam_user_regi,
       llam_fech_regi,
       llam_user_modi,
       llam_fech_modi,
       llam_cont_codi,
       llam_empr_codi,
       llam_juri_codi,
       llam_nume_item_orig,
       llam_inve_codi,
       llam_rell_codi,
       llam_movi_codi,
       llam_proc_id,
       llam_fech_prom_pago,
       llam_meco_codi,
       llam_codi_err,
       llam_lote_err,
       llam_mens_envi,
       llam_mens_resp,
       llam_nro_tele,
       llam_indi_gene_por_cons_api,
       llam_time_call_dura,
       llam_conn_id)
    values
      (v_llam_nume_item,
       v_llam_clpr_codi,
       v_llam_cope_nume_item,
       v_llam_indi_tipo,
       v_llam_fech,
       v_llam_hora,
       v_llam_pers,
       v_llam_tema_trata,
       v_llam_tele,
       v_llam_base,
       v_llam_fech_visi,
       v_llam_fech_prox,
       v_llam_indi_real,
       v_llam_indi_cobr,
       v_llam_indi_prob,
       v_llam_fech_reco,
       v_llam_reco_obse,
       v_llam_empl_codi,
       v_llam_user_regi,
       v_llam_fech_regi,
       v_llam_user_modi,
       v_llam_fech_modi,
       v_llam_cont_codi,
       v_llam_empr_codi,
       v_llam_juri_codi,
       v_llam_nume_item_orig,
       v_llam_inve_codi,
       v_llam_rell_codi,
       v_llam_movi_codi,
       v_llam_proc_id,
       v_llam_fech_prom_pago,
       v_llam_meco_codi,
       p_llam_codi_err,
       p_llam_lote_err,
       p_mensaje,
       p_mens_rest,
       p_llam_nro_tele,
       p_indi_gene_por_cons_api,
       p_time_call_dura,
       p_llam_conn_id);
  
    for x in c_dato_cuot(p_clpr_codi) loop
      begin
        select nvl(max(deta_codi), 0) + 1
          into v_deta_codi
          from come_clie_llam_cobr_deta;
      end;
    
      insert into come_clie_llam_cobr_deta
        (deta_codi, deta_cuot_id, deta_llam_nume_item)
      values
        (v_deta_codi, x.cuot_id, v_llam_nume_item);
    end loop;
  
    commit;
  
  exception
    when no_data_found then
      null;
  end pa_gene_llam_deta;

  procedure pp_enviar_mensaje(p_cliente   in number,
                              p_mensaje   in varchar2,
                              p_telefono  out varchar2,
                              p_respuesta out varchar2) is
  
    v_telefono            number;
    v_estado              varchar2(2000);
    v_remitente           number;
    v_respuesta           varchar2(2000);
    v_cant_vari           varchar2(2000);
    v_leng                number;
    v_text                varchar2(5000);
    v_text_desc           varchar2(500);
    v_response            varchar2(500);
    v_ensm_codi           number(20);
    v_ensm_fech_envi      date;
    v_ensm_user_envi      varchar2(20);
    v_ensm_clpr_codi      number(20);
    v_ensm_clpr_tele      varchar2(50);
    v_ensm_text           varchar2(4000);
    v_ensm_resp           varchar2(4000);
    v_ensm_tipo           varchar2(2);
    v_ensm_indi_envi      varchar2(1);
    v_ensm_fech_regi      date;
    v_ensm_tipo_desc      varchar2(100);
    v_ensm_dias_atra      number(10);
    v_ensm_cuot_fech_venc date;
    v_ensm_cant_cuot_venc number(10);
    v_ensm_clpr_desc      varchar2(200);
    v_ensm_clpr_codi_alte number(20);
    v_ensm_smco_codi      number(10);
    v_ensm_indi_omit_sms  varchar2(1);
  
  begin
    if p_cliente is null then
      raise_application_error(-20001,
                              'Debe elegir un cliente para enviar un mensaje');
    end if;
  
    select fa_devu_tele_form(nvl(cp.clpr_celu, cp.clpr_tele)) clpr_tele,
           clpr_codi,
           clpr_desc,
           clpr_codi_alte
      into v_telefono,
           v_ensm_clpr_codi,
           v_ensm_clpr_desc,
           v_ensm_clpr_codi_alte
      from come_clie_prov cp
     where clpr_codi = p_cliente;
  
    v_remitente := fa_busc_para('P_SMS_CONF_NUME_FROM');
  
    if p_mensaje is null then
      raise_application_error(-20001, 'El mensaje no puede quedar vacio');
    end if;
  
    if p_mensaje is not null then
      v_cant_vari := gene_llam_deta.controlar_campos(i_texto => p_mensaje);
    
      if v_cant_vari is not null then
        raise_application_error(-20001,
                                'Existen caracteres que no corresponden ' ||
                                v_cant_vari);
      end if;
    end if;
  
    v_ensm_codi      := sec_come_envi_sms.nextval;
    v_ensm_user_envi := gen_user;
    v_ensm_clpr_tele := v_telefono;
    v_ensm_text      := p_mensaje;
    v_ensm_tipo      := 'A';
    v_ensm_indi_envi := 'N';
    v_ensm_fech_regi := sysdate;
    v_ensm_tipo_desc := 'Enviado desde Buzon';
  
    insert into come_envi_sms
      (ensm_codi,
       ensm_fech_envi,
       ensm_user_envi,
       ensm_clpr_codi,
       ensm_clpr_tele,
       ensm_text,
       ensm_resp,
       ensm_tipo,
       ensm_indi_envi,
       ensm_fech_regi,
       ensm_tipo_desc,
       ensm_dias_atra,
       ensm_cuot_fech_venc,
       ensm_cant_cuot_venc,
       ensm_clpr_desc,
       ensm_clpr_codi_alte,
       ensm_smco_codi,
       ensm_indi_omit_sms)
    values
      (v_ensm_codi,
       v_ensm_fech_envi,
       v_ensm_user_envi,
       v_ensm_clpr_codi,
       v_ensm_clpr_tele,
       v_ensm_text,
       v_ensm_resp,
       v_ensm_tipo,
       v_ensm_indi_envi,
       v_ensm_fech_regi,
       v_ensm_tipo_desc,
       v_ensm_dias_atra,
       v_ensm_cuot_fech_venc,
       v_ensm_cant_cuot_venc,
       v_ensm_clpr_desc,
       v_ensm_clpr_codi_alte,
       v_ensm_smco_codi,
       v_ensm_indi_omit_sms);
  
    commit;
  
    if v_telefono is not null then
      begin
        pack_envi_sms.pa_send_twilio_msg(msgbody  => p_mensaje,
                                         msgto    => v_telefono,
                                         msgfrom  => v_remitente,
                                         response => v_respuesta);
      
      end;
    
      p_telefono  := v_telefono;
      p_respuesta := v_estado;
    end if;
  
    v_leng := length(replace(v_respuesta, '"', '')); -- esto hacemos para saber si el envio retorno "0" o algun error html por eso la expresion >35
  
    if v_leng = 1 or v_leng >= 35 then
    
      update come_envi_sms
         set ensm_fech_envi = sysdate,
             ensm_resp      = v_respuesta,
             ensm_indi_envi = 'N'
       where ensm_codi = v_ensm_codi;
    
    else
    
      update come_envi_sms
         set ensm_fech_envi = sysdate,
             ensm_resp      = v_respuesta,
             ensm_indi_envi = 'S'
       where ensm_codi = v_ensm_codi;
    
    end if;
  
    commit;
  
    if v_estado = '400' or v_respuesta is not null then
    
      if v_respuesta like '%{"code": 21211%' then
        raise_application_error(-20001,
                                'Mensaje no enviado, numero inexistente');
      elsif v_respuesta = '"0"' or v_respuesta = '0' then
        raise_application_error(-20001,
                                'Mensaje no enviado ' || v_respuesta);
      end if;
    else
      v_estado := 'Enviado';
    end if;
  end pp_enviar_mensaje;

  function controlar_campos(i_texto in varchar2) return varchar2 is
  
    v_resultado  varchar2(500);
    v_letra      varchar2(1);
    v_nro        number;
    v_caracteres varchar2(3000);
    v_contador   number;
  begin
    v_caracteres := '!???#?$?%?&???(?)?*?+?,???.?/?{?|?}?~?[?\?]?^?0?1?2?3?4?5?6?7?8?9?:?;?<?=?>???@?A?B?C?D?E?F?G?H?I?J?K?L?M?N?O?P?
Q?R?S?T?U?V?W?X?Y?Z?_?a?b?c?d?e?f?g?h?i?j?k?l?m?n?o?p?q?r?s?t?u?v?w?x?y?z???????????????????????????????????????????????
?????????????????';
  
    for x in 1 .. length(i_texto) loop
      v_letra := substr(i_texto, x, 1);
      if v_letra <> ' ' then
        select count(caracteres)
          into v_contador
          from (select regexp_substr(v_caracteres, '[^?]+', 1, level) caracteres
                  from dual
                connect by regexp_substr(v_caracteres, '[^?]+', 1, level) is not null)
         where caracteres = v_letra;
      end if;
      if v_contador = 0 then
        v_resultado := v_resultado || v_letra;
      end if;
    
    end loop;
    return v_resultado;
  end controlar_campos;

end gene_llam_deta;
