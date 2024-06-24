
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020210" is
  type r_parameter is record(
    p_codi_base           number := pack_repl.fa_devu_codi_base,
    p_peco_codi           number := 1,
    p_indi_most_mens_sali varchar2(20) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_mens_sali'))),
    p_indi_impr_cheq_emit varchar2(20) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_impr_cheq_emit'))),
    p_form_calc_rete_emit number := to_number(general_skn.fl_busca_parametro('p_form_calc_rete_emit')),
    p_codi_timo_rete_emit number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rete_emit')),
    p_imp_min_aplic_reten number := to_number(general_skn.fl_busca_parametro('p_imp_min_aplic_reten')),
    p_porc_aplic_reten    number := to_number(general_skn.fl_busca_parametro('p_porc_aplic_reten')),
    p_codi_conc_rete_emit number := to_number(general_skn.fl_busca_parametro('p_codi_conc_rete_emit')),
    p_form_impr_rete      varchar2(20) := ltrim(rtrim(general_skn.fl_busca_parametro('p_form_impr_rete'))),
    
    p_codi_impu_exen number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_movi_codi_rete number := null,
    p_movi_nume_rete number := null,
    p_codi_prov_espo number := to_number(general_skn.fl_busca_parametro('p_codi_prov_espo')));

  parameter r_parameter;

  cursor c_rete is
    select seq_id numero_item,
           c001   orpa_nume,
           c002   orpa_cuen_codi,
           c003   cuen_desc,
           --c004   deta_impo_mone,--no corresponde verificar
           c005 orpa_fech_emis,
           c006 orpa_rete_mone,
           c007 orpa_rete_mmnn,
           c008 mone_desc_abre,
           c009 estado,
           c010 orpa_codi,
           c011 orpa_clpr_codi,
           c012 mone_cant_deci,
           c013 orpa_mone_codi,
           c014 orpa_tasa_mone,
           c015 orpa_user,
           c016 orpa_rete_movi_codi,
           c017 movi_codi_orpa,
           c018 ind_marcado,
           c019 movi_nume, --nro de documento
           c020 movi_fech_emis, ---fecha de emision de la factura
           c021 clpr_codi_alte,
           c022 clpr_desc
      from apex_collections a
     where collection_name = 'DET_RETENCION';

  function fp_secu_nume_reten(p_item_reten in number) return number is
    v_secu_nume_reten number;
  begin
    select nvl(secu_nume_reten, 0) --+ 1
      into v_secu_nume_reten
      from come_secu
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  
    v_secu_nume_reten := v_secu_nume_reten + p_item_reten;
  
    return v_secu_nume_reten;
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Codigo de Secuencia de Retenciones inexistente');
    
    when others then
      raise_application_error(-20001, sqlerrm);
  end fp_secu_nume_reten;

  procedure pp_cargar_detalle(p_orpa_fech_fin in date,
                              p_orpa_fech_ini in date,
                              p_rete_impr     in varchar2,
                              p_orden_esta    in varchar2,
                              p_clpr_codi     in number,
                              p_orpa_nume_ini in number,
                              p_orpa_nume_fin in number) is

  
    cursor c_orden is
      select o.orpa_codi,
             o.orpa_nume,
             o.orpa_clpr_codi,
             o.orpa_fech_emis,
             o.orpa_cuen_codi,
             o.orpa_mone_codi,
             o.orpa_tasa_mone,
             o.orpa_user,
             o.orpa_rete_mone,
             o.orpa_rete_mmnn,
             o.orpa_rete_movi_codi,
             c.cuen_desc,
             m.mone_desc_abre,
             m.mone_cant_deci,
             decode(o.orpa_rete_movi_codi, null, 'Pendiente ', 'Impreso   ') estado,
             op.movi_codi movi_codi_orpa,
             cp.clpr_codi_alte,
             cp.clpr_desc
        from come_orde_pago o, 
             come_cuen_banc c, 
             come_mone m, 
             come_movi op,
             come_clie_prov cp
       where o.orpa_rete_mone <> 0
         and o.orpa_cuen_codi = c.cuen_codi(+)
         and o.orpa_mone_codi = m.mone_codi
         and op.movi_orpa_codi = o.orpa_codi
         and op.movi_clpr_codi=cp.clpr_codi
         and (o.orpa_clpr_codi = p_clpr_codi or p_clpr_codi is null)
         and (nvl(o.orpa_estado, 'P') = p_orden_esta or p_orden_esta = 'T')
         and ((o.orpa_rete_movi_codi is null and p_rete_impr = 'P') or
             (o.orpa_rete_movi_codi is not null and p_rete_impr = 'I') or
             (p_rete_impr = 'T'))
         and (o.orpa_fech_emis >= p_orpa_fech_ini or
             p_orpa_fech_ini is null)
         and (o.orpa_fech_emis <= p_orpa_fech_fin or
             p_orpa_fech_fin is null)
         and (o.orpa_nume >= p_orpa_nume_ini or p_orpa_nume_ini is null)
         and (o.orpa_nume <= p_orpa_nume_fin or p_orpa_nume_fin is null)
       order by o.orpa_nume, o.orpa_fech_emis;
  
    /* cursor c_orden_para is
    select o.orpa_codi,
           o.orpa_nume,
           o.orpa_clpr_codi,
           o.orpa_fech_emis,
           o.orpa_cuen_codi,
           o.orpa_mone_codi,
           o.orpa_tasa_mone,
           o.orpa_user,
           o.orpa_rete_mone,
           o.orpa_rete_mmnn,
           o.orpa_rete_movi_codi,
           c.cuen_desc,
           m.mone_desc_abre,
           m.mone_cant_deci,
           decode(o.orpa_rete_movi_codi, null, 'pendiente ', 'impreso   ') estado,
           op.movi_codi movi_codi_orpa
      from come_orde_pago o, come_cuen_banc c, come_mone m,
           come_movi op
     where o.orpa_rete_mone <> 0
       and op.movi_orpa_codi = o.orpa_codi
       and o.orpa_cuen_codi = c.cuen_codi(+)
       and o.orpa_mone_codi = m.mone_codi
       and o.orpa_codi = parameter.p_inic_orpa_codi
     order by o.orpa_nume, o.orpa_fech_emis;
    */
    v_movi_nume      number;
    v_movi_fech_emis date;
  
  begin
  


    apex_collection.create_or_truncate_collection(p_collection_name => 'DET_RETENCION');
  
  
  
    for k in c_orden loop
    
      if k.orpa_rete_movi_codi is not null then
        begin
          select m.movi_nume, m.movi_fech_emis
            into v_movi_nume, v_movi_fech_emis
            from come_movi m
           where m.movi_codi = k.orpa_rete_movi_codi;
        
        exception
          when others then
          null;
        end;
        else
           v_movi_nume:= null;
           v_movi_fech_emis:=null;
      end if;
    
      apex_collection.add_member(p_collection_name => 'DET_RETENCION',
                                 p_c001            => k.orpa_nume,
                                 p_c002            => k.orpa_cuen_codi,
                                 p_c003            => k.cuen_desc,
                                 p_c004            => null, --k.deta_impo_mone,
                                 p_c005            => k.orpa_fech_emis,
                                 p_c006            => k.orpa_rete_mone,
                                 p_c007            => k.orpa_rete_mmnn,
                                 p_c008            => k.mone_desc_abre,
                                 p_c009            => k.estado,
                                 p_c010            => k.orpa_codi,
                                 p_c011            => k.orpa_clpr_codi,
                                 p_c012            => k.mone_cant_deci,
                                 p_c013            => k.orpa_mone_codi,
                                 p_c014            => k.orpa_tasa_mone,
                                 p_c015            => k.orpa_user,
                                 p_c016            => k.orpa_rete_movi_codi,
                                 p_c017            => k.movi_codi_orpa,
                                 p_c018            => 'N',
                                 p_c019            => v_movi_nume,
                                 p_c020            => v_movi_fech_emis,
                                 p_c021            => k.clpr_codi_alte,
                                 p_c022            => k.clpr_desc);
    
      
      
   
      
    end loop;
  
    /* else
    for k in c_orden_para loop
    
      :bdet.orpa_nume           := k.orpa_nume;
      :bdet.orpa_cuen_codi      := k.orpa_cuen_codi;
      :bdet.cuen_desc           := k.cuen_desc;
      :bdet.orpa_fech_emis      := k.orpa_fech_emis;
      :bdet.orpa_rete_mone      := k.orpa_rete_mone;
      :bdet.orpa_rete_mmnn      := k.orpa_rete_mmnn;
      :bdet.mone_desc_abre      := k.mone_desc_abre;
      :bdet.estado              := k.estado;
      :bdet.orpa_codi           := k.orpa_codi;
      :bdet.orpa_clpr_codi      := k.orpa_clpr_codi;
      :bdet.mone_cant_deci      := k.mone_cant_deci;
      :bdet.orpa_mone_codi      := k.orpa_mone_codi;
      :bdet.orpa_tasa_mone      := k.orpa_tasa_mone;
      :bdet.orpa_user           := k.orpa_user;
      :bdet.orpa_rete_movi_codi := k.orpa_rete_movi_codi;
      :bdet.marca               := 'n';
      :bdet.movi_codi_orpa      := k.movi_codi_orpa;
     
    
    
    
      
      if :bdet.orpa_rete_movi_codi is not null then
        begin
          select m.movi_nume, m.movi_fech_emis
            into :bdet.movi_nume, :bdet.movi_fech_emis
            from come_movi m
           where m.movi_codi = :bdet.orpa_rete_movi_codi;
          :bdet.s_movi_fech_emis := to_char(:bdet.movi_fech_emis, 'dd-mm-yyyy');
        exception
          when others then
            null;
        end;
      end if;
    
    end loop;
    parameter.p_inic_orpa_codi := null;*/
    --end if;
  
  end pp_cargar_detalle;

  procedure pp_actualizar_registro is
    salir       exception;
    v_movi_codi number;
  begin
    
 
  
  
    for i in c_rete loop
      if i.ind_marcado = 'S' then
        if nvl(i.orpa_rete_mone, 0) > 0 and i.orpa_rete_movi_codi is null then
          if i.movi_nume is null or i.movi_fech_emis is null then
            raise_application_error(-20001,
                                    'Debe indicar el numero de Numero y la Fecha de la Retencion!');
          end if;
          
         -- raise_application_error(-20001,i.orpa_fech_emis);
          pp_validar_nume_rete(i.movi_nume, i.movi_fech_emis);
          pp_actualizar_come_movi_rete(i.movi_nume,
                                       i.orpa_clpr_codi,
                                       i.orpa_mone_codi,
                                       i.movi_fech_emis,--i.orpa_fech_emis,----verificacion de version anteriores 
                                       i.movi_codi_orpa,
                                       i.clpr_codi_alte,
                                       i.orpa_tasa_mone,
                                       i.orpa_rete_mmnn,
                                       i.orpa_rete_mone,
                                       i.orpa_nume,
                                       i.clpr_desc,
                                       v_movi_codi);
          pp_actualizar_moco_rete(i.orpa_rete_mmnn, i.orpa_rete_mone);
          pp_actualizar_moimpu_rete(i.orpa_rete_mmnn, i.orpa_rete_mone);
        
        
          pp_actu_orden(i.orpa_codi);
          pp_actu_fact(v_movi_codi,
                       i.orpa_codi,
                       i.movi_codi_orpa,
                       i.orpa_tasa_mone,
                       i.orpa_rete_mone,
                       i.orpa_rete_mmnn);
          pp_actu_secu_rete(i.movi_nume);
          
        end if;
      end if;
    end loop;
  
  exception
    when salir then
      null;
  end pp_actualizar_registro;

  procedure pp_validar_nume_rete(p_nume           in number,
                                 p_movi_fech_emis in date) is
    v_timo_tico_codi number;
    v_tico_fech_rein date;
    v_cant_repe      number;
  begin
    begin
      select timo_tico_codi, tico_fech_rein
        into v_timo_tico_codi, v_tico_fech_rein
        from come_tipo_movi, come_tipo_comp
       where timo_tico_codi = tico_codi
         and timo_codi = parameter.p_codi_timo_rete_emit;
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'Tipo de movimiento configurado como Retencion Emitida no posee Tipo de Comprobante');
    end;
  
    if p_movi_fech_emis >=
       nvl(v_tico_fech_rein, to_date('01-01-1990', 'dd-mm-yyyy')) then
      begin
        select count(*)
          into v_cant_repe
          from come_movi m, come_tipo_movi t
         where m.movi_timo_codi = t.timo_codi
           and t.timo_tico_codi = v_timo_tico_codi
           and m.movi_fech_emis >=
               nvl(v_tico_fech_rein, to_date('01-01-1990', 'dd-mm-yyyy'))
           and m.movi_nume = p_nume;
      exception
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    else
      begin
        select count(*)
          into v_cant_repe
          from come_movi m, come_tipo_movi t
         where m.movi_timo_codi = t.timo_codi
           and t.timo_tico_codi = v_timo_tico_codi
           and m.movi_fech_emis <
               nvl(v_tico_fech_rein, to_date('01-01-1990', 'dd-mm-yyyy'))
           and m.movi_nume = p_nume;
      exception
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    end if;
  
    if nvl(v_cant_repe, 0) > 0 then
      raise_application_error(-20001,
                              'El numero de comprobante de Retencion ya ha sido registrado previamente.');
    end if;
  end pp_validar_nume_rete;

  procedure pp_actualizar_come_movi_rete(p_movi_nume      in number,
                                         p_orpa_clpr_codi in number,
                                         p_orpa_mone_codi in number,
                                         p_orpa_fech_emis in date,
                                         p_movi_codi_orpa in number,
                                         p_clpr_codi_alte in number,
                                         p_orpa_tasa_mone in number,
                                         p_orpa_rete_mmnn in number,
                                         p_orpa_rete_mone in number,
                                         p_orpa_nume      in number,
                                         p_clpr_desc      in varchar2,
                                         p_movi_codi      out number) is
    v_movi_codi                number;
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
    v_movi_excl_cont           varchar2(1);
  
    v_timo_tico_codi      number;
    v_tico_indi_timb      varchar2(1);
    v_nro_1               varchar2(3);
    v_nro_2               varchar2(3);
    v_movi_nume_timb      varchar2(20);
    v_movi_fech_venc_timb date;
  
  begin
    --- asignar valores....
    select timo_tico_codi,
           tico_indi_timb,
           timo_emit_reci,
           timo_afec_sald,
           timo_dbcr
      into v_timo_tico_codi,
           v_tico_indi_timb,
           v_movi_emit_reci,
           v_movi_afec_sald,
           v_movi_dbcr
      from come_tipo_movi, come_tipo_comp
     where timo_tico_codi = tico_codi(+)
       and timo_codi = parameter.p_codi_timo_rete_emit;
  
    --v_movi_nume := fp_secu_nume_reten;
    v_movi_nume := p_movi_nume;
    v_nro_1     := substr(rtrim(ltrim(to_char(v_movi_nume, '0000000000000'))),
                          1,
                          3);
    v_nro_2     := substr(rtrim(ltrim(to_char(v_movi_nume, '0000000000000'))),
                          4,
                          3);
  
    pp_validar_timbrado_rete(v_timo_tico_codi,
                             v_nro_1,
                             v_nro_2,
                             p_orpa_clpr_codi,
                             p_orpa_fech_emis,
                             v_movi_nume_timb,
                             v_movi_fech_venc_timb,
                             v_tico_indi_timb,
                             p_clpr_codi_alte);
  
    v_movi_codi                := fa_sec_come_movi;
    parameter.p_movi_codi_rete := v_movi_codi;
    v_movi_timo_codi           := parameter.p_codi_timo_rete_emit;
    v_movi_clpr_codi           := p_orpa_clpr_codi;
    v_movi_sucu_codi_orig      := null;
    v_movi_depo_codi_orig      := null;
    v_movi_sucu_codi_dest      := null;
    v_movi_depo_codi_dest      := null;
    v_movi_oper_codi           := null;
    v_movi_cuen_codi           := null;
    v_movi_mone_codi           := p_orpa_mone_codi;
   
    v_movi_fech_emis      := p_orpa_fech_emis; -- p_movi_fech_emis;--to_date(to_char(sysdate, 'dd-mm-yyyy'), 'dd-mm-yyyy');--:bcab.movi_fech_emis;
    v_movi_fech_grab      := sysdate; 
    v_movi_user           := gen_user; 
    v_movi_codi_padr      := p_movi_codi_orpa;
    v_movi_tasa_mone      := p_orpa_tasa_mone;
    v_movi_tasa_mmee      := null;
    v_movi_grav_mmnn      := 0;
    v_movi_exen_mmnn      := p_orpa_rete_mmnn;
    v_movi_iva_mmnn       := 0; 
    v_movi_grav_mmee      := null;
    v_movi_exen_mmee      := null;
    v_movi_iva_mmee       := null;
    v_movi_grav_mone      := 0; 
    v_movi_exen_mone      := p_orpa_rete_mone;
    v_movi_iva_mone       := 0; 
    v_movi_obse           := 'Retencion a OP ' || p_orpa_nume;
    v_movi_sald_mmnn      := 0;
    v_movi_sald_mmee      := 0;
    v_movi_sald_mone      := 0;
    v_movi_stoc_suma_rest := null;
  
    v_movi_clpr_dire := null;
    v_movi_clpr_tele := null;
    v_movi_clpr_ruc  := null;
    v_movi_clpr_desc := p_clpr_desc;
  
    v_movi_stoc_afec_cost_prom := null;
    v_movi_empr_codi           := null;
    v_movi_clave_orig          := null;
    v_movi_clave_orig_padr     := null;
    v_movi_indi_iva_incl       := null;
    v_movi_empl_codi           := null;
    v_movi_excl_cont           := 'S';
  
    p_movi_codi := v_movi_codi;
  
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
                        v_movi_nume_timb,
                        v_movi_fech_venc_timb,
                        v_movi_excl_cont);
  
  end pp_actualizar_come_movi_rete;

  procedure pp_validar_timbrado_rete(p_tico_codi      in number,
                                     p_esta           in number,
                                     p_punt_expe      in number,
                                     p_clpr_codi      in number,
                                     p_fech_movi      in date,
                                     p_timb           out varchar2,
                                     p_fech_venc      out date,
                                     p_tico_indi_timb in varchar2,
                                     p_clpr_codi_alte in number) is
  
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
  
    cursor c_timb_3 is
      select setc_nume_timb, setc_fech_venc
        from come_secu_tipo_comp
       where setc_secu_codi =
             (select peco_secu_codi
                from come_pers_comp
               where peco_codi = parameter.p_peco_codi)
         and setc_tico_codi = p_tico_codi --tipo de comprobante
         and setc_esta = p_esta --establecimiento 
         and setc_punt_expe = p_punt_expe --punto de expedicion
         and setc_fech_venc >= p_fech_movi
       order by setc_fech_venc;
  
    v_indi_entro varchar2(1) := 'N';
    v_indi_espo  varchar2(1) := 'N';
  
    v_tico_indi_habi_timb varchar2(10);
    v_tico_indi_timb_auto varchar2(10);
  begin
    if p_clpr_codi_alte = parameter.p_codi_prov_espo then
      v_indi_espo := 'S';
    end if;
  
    begin
      select tico_indi_habi_timb, tico_indi_timb_auto
        into v_tico_indi_habi_timb, v_tico_indi_timb_auto
        from come_tipo_movi, come_tipo_comp
       where timo_tico_codi = tico_codi(+)
         and timo_codi = parameter.p_codi_timo_rete_emit;
    exception
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
    if nvl(v_tico_indi_timb_auto, 'N') = 'S' then
      if nvl(p_tico_indi_timb, 'C') = 'P' then
        if nvl(v_indi_espo, 'N') = 'N' then
          for x in c_timb loop
            v_indi_entro := 'S';
            p_timb       := x.cptc_nume_timb;
            p_fech_venc  := x.cptc_fech_venc;
            exit;
          end loop;
        end if;
      elsif nvl(p_tico_indi_timb, 'C') = 'C' then
        ---si es por tipo de comprobante
        for y in c_timb_2 loop
          v_indi_entro := 'S';
          p_timb       := y.deta_nume_timb;
          p_fech_venc  := y.deta_fech_venc;
          exit;
        end loop;
      elsif nvl(p_tico_indi_timb, 'C') = 'S' then
        ---si es por tipo de secuencia
        if nvl(v_indi_espo, 'N') = 'N' then
          for x in c_timb_3 loop
            v_indi_entro := 'S';
            p_timb       := x.setc_nume_timb;
            p_fech_venc  := x.setc_fech_venc;
            exit;
          end loop;
        end if;
      end if;
    
      if v_indi_entro = 'N' then
        raise_application_error(-20001,
                                'No existe registro de timbrado cargado para este proveedor, o el timbrado cargado se encuentra vencido!!!');
      end if;
    end if;
  
  end pp_validar_timbrado_rete;

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
                                p_movi_nume_timb           in varchar2,
                                p_movi_fech_venc_timb      in date,
                                p_movi_excl_cont           in varchar2) is
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
       movi_nume_timb,
       movi_fech_venc_timb,
       movi_base,
       movi_excl_cont)
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
       p_movi_nume_timb,
       p_movi_fech_venc_timb,
       parameter.p_codi_base,
       p_movi_excl_cont);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_come_movi;

  procedure pp_actualizar_moco_rete(p_orpa_rete_mmnn in number,
                                    p_orpa_rete_mone in number) is
  
    --variables para moco
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr      char(1);
  
    v_conc_indi_ortr varchar2(1);
  begin
    begin
      select rtrim(ltrim(conc_dbcr)), conc_indi_ortr
        into v_moco_dbcr, v_conc_indi_ortr
        from come_conc
       where conc_codi = parameter.p_codi_conc_rete_emit;
    
      if nvl(v_conc_indi_ortr, 'N') = 'S' then
        raise_application_error(-20001,
                                'No se puede utilizar el concepto configurado para retenciones porque debe estar relacionada a una OT');
      end if;
    
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'Concepto configurado para retenciones inexistente!.');
      
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
    ----actualizar moco.... 
    v_moco_movi_codi := parameter.p_movi_codi_rete;
    v_moco_nume_item := 0;
    v_moco_conc_codi := parameter.p_codi_conc_rete_emit;
  
    v_moco_nume_item := v_moco_nume_item + 1;
    v_moco_cuco_codi := null;
    v_moco_impu_codi := parameter.p_codi_impu_exen;
    v_moco_impo_mmnn := p_orpa_rete_mmnn;
    v_moco_impo_mmee := 0;
    v_moco_impo_mone := p_orpa_rete_mone;
  
    pp_insert_movi_conc_deta(v_moco_movi_codi,
                             v_moco_nume_item,
                             v_moco_conc_codi,
                             v_moco_cuco_codi,
                             v_moco_impu_codi,
                             v_moco_impo_mmnn,
                             v_moco_impo_mmee,
                             v_moco_impo_mone,
                             v_moco_dbcr);
  end pp_actualizar_moco_rete;

  procedure pp_actualizar_moimpu_rete(p_orpa_rete_mmnn in number,
                                      p_orpa_rete_mone in number) is
  begin
    --actualizar moim...
    pp_insert_come_movi_impu_deta(to_number(parameter.p_codi_impu_exen),
                                  parameter.p_movi_codi_rete,
                                  p_orpa_rete_mmnn,
                                  0,
                                  0,
                                  0,
                                  p_orpa_rete_mone,
                                  0);
  end pp_actualizar_moimpu_rete;

  procedure pp_actu_orden(p_orpa_codi in number) is
  begin
    update come_orde_pago
       set orpa_rete_movi_codi = parameter.p_movi_codi_rete
     where orpa_codi = p_orpa_codi;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actu_orden;

  procedure pp_actu_fact(p_movi_codi      in number,
                         p_orpa_codi      in number,
                         p_movi_codi_orpa in number,
                         p_orpa_tasa_mone in number,
                         p_orpa_rete_mone in number,
                         p_orpa_rete_mmnn in number) is
    cursor c_movi is
      select d.deta_cuot_movi_codi movi_codi,
             sum(d.deta_rete_iva_mone) deta_rete_iva_mone
        from come_orde_pago_deta d
       where d.deta_orpa_codi = p_orpa_codi
       group by d.deta_cuot_movi_codi;
  
  begin
    for k in c_movi loop
      update come_movi
         set movi_codi_rete = parameter.p_movi_codi_rete
       where movi_codi = k.movi_codi;
    end loop;
    for k in c_movi loop
      if k.deta_rete_iva_mone > 0 then
        insert into come_movi_rete
          (more_movi_codi,
           more_movi_codi_rete,
           more_tipo_rete,
           more_impo_mone,
           more_impo_mmnn,
           more_tasa_mone,
           more_movi_codi_pago,
           more_orpa_codi)
        values
          (k.movi_codi,
           p_movi_codi,
           parameter.p_form_calc_rete_emit,
           p_orpa_rete_mone,
           p_orpa_rete_mmnn,
           p_orpa_tasa_mone,
           p_movi_codi_orpa,
           null);
      end if;
    end loop;
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actu_fact;

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
       moco_dbcr)
    values
      (p_moco_movi_codi,
       p_moco_nume_item,
       p_moco_conc_codi,
       p_moco_cuco_codi,
       p_moco_impu_codi,
       p_moco_impo_mmnn,
       p_moco_impo_mmee,
       p_moco_impo_mone,
       p_moco_dbcr);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_movi_conc_deta;

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
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_insert_come_movi_impu_deta;

  procedure pp_actu_secu_rete(p_movi_nume_rete in number) is
  begin
    update come_secu
       set secu_nume_reten = p_movi_nume_rete
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  end pp_actu_secu_rete;

  procedure pp_reenumerar_retencion is
    v_item_reten number := 0;
  begin
  
    for k in c_rete loop
      if k.ind_marcado = 'S' then
        if k.orpa_rete_movi_codi is null -- and nvl(:bdet.w_indi_modi, 'N') = 'N' 
         then
          v_item_reten := v_item_reten + 1;
        
          apex_collection.UPDATE_MEMBER(p_collection_name => 'DET_RETENCION',
                                        p_seq             => k.numero_item,
                                        p_c001            => k.orpa_nume,
                                        p_c002            => k.orpa_cuen_codi,
                                        p_c003            => k.cuen_desc,
                                        p_c004            => null, --k.deta_impo_mone,
                                        p_c005            => k.orpa_fech_emis,
                                        p_c006            => k.orpa_rete_mone,
                                        p_c007            => k.orpa_rete_mmnn,
                                        p_c008            => k.mone_desc_abre,
                                        p_c009            => k.estado,
                                        p_c010            => k.orpa_codi,
                                        p_c011            => k.orpa_clpr_codi,
                                        p_c012            => k.mone_cant_deci,
                                        p_c013            => k.orpa_mone_codi,
                                        p_c014            => k.orpa_tasa_mone,
                                        p_c015            => k.orpa_user,
                                        p_c016            => k.orpa_rete_movi_codi,
                                        p_c017            => k.movi_codi_orpa,
                                        p_c018            => k.ind_marcado,
                                        p_c019            => fp_secu_nume_reten(v_item_reten),
                                        p_c020            => to_char(sysdate, 'dd-mm-yyyy'),
                                        p_c021            => k.clpr_codi_alte,
                                        p_c022            => k.clpr_desc);
        end if;
      else
        if k.orpa_rete_movi_codi is null then
        
          apex_collection.UPDATE_MEMBER(p_collection_name => 'DET_RETENCION',
                                        p_seq             => k.numero_item,
                                        p_c001            => k.orpa_nume,
                                        p_c002            => k.orpa_cuen_codi,
                                        p_c003            => k.cuen_desc,
                                        p_c004            => null, --k.deta_impo_mone,
                                        p_c005            => k.orpa_fech_emis,
                                        p_c006            => k.orpa_rete_mone,
                                        p_c007            => k.orpa_rete_mmnn,
                                        p_c008            => k.mone_desc_abre,
                                        p_c009            => k.estado,
                                        p_c010            => k.orpa_codi,
                                        p_c011            => k.orpa_clpr_codi,
                                        p_c012            => k.mone_cant_deci,
                                        p_c013            => k.orpa_mone_codi,
                                        p_c014            => k.orpa_tasa_mone,
                                        p_c015            => k.orpa_user,
                                        p_c016            => k.orpa_rete_movi_codi,
                                        p_c017            => k.movi_codi_orpa,
                                        p_c018            => k.ind_marcado,
                                        p_c019            => null,
                                        p_c020            => null,
                                        p_c021            => k.clpr_codi_alte,
                                        p_c022            => k.clpr_desc);
        
        end if;
      end if;
    
    end loop;
  
  end pp_reenumerar_retencion;

end i020210;
