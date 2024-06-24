
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."GENERAL_SKN" is

  function fl_peri_act_ini return date is
    v_fecha_ini date;
  begin
    select a.peri_fech_inic
      into v_fecha_ini
      from come_peri a
     where a.peri_codi = general_skn.fl_busca_parametro('p_codi_peri_actu');
    return v_fecha_ini;
  end;

  function fl_peri_sgt_fin return date is
    v_fecha_fin date;
  begin
    select a.peri_fech_fini
      into v_fecha_fin
      from come_peri a
     where a.peri_codi = general_skn.fl_busca_parametro('p_codi_peri_sgte');
    return v_fecha_fin;
  end;

  function fl_busca_parametro(p_para_nomb in varchar2) return varchar2 is
    v_para_valo varchar2(100);
  begin
    select para_valo
      into v_para_valo
      from come_para
     where upper(para_nomb) = upper(p_para_nomb);
  
    return ltrim(rtrim(v_para_valo));
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Falta registrar el Parametro..' ||
                              p_para_nomb);
    when too_many_rows then
      raise_application_error(-20010,
                              'El parametro ' || p_para_nomb ||
                              ' esta duplicado, Avise a su Administrador');
    when others then
      raise_application_error(-20010, sqlerrm);
  end fl_busca_parametro;

  function fecha_meses_atras(cant number) return date as
    v_fecha date;
  begin
  
    select add_months(trunc(sysdate, 'mm'), -cant) into v_fecha from dual;
  
    return v_fecha;
  
  end;

  function extrae_solo_nros(i_texto in varchar2) return varchar2 is
  
    v_resultado varchar2(500);
    v_letra     varchar2(1);
    v_nro       number;
  begin
    for x in 1 .. length(i_texto) loop
      v_letra := substr(i_texto, x, 1);
      begin
        v_nro       := to_number(v_letra);
        v_resultado := v_resultado || v_letra;
      exception
        when others then
          null;
      end;
    end loop;
    return v_resultado;
  end;

  procedure pl_calc_rete(p_form_rete           in number,
                         p_empr_codi           in number,
                         p_sucu_codi           in number,
                         p_movi_codi           in number,
                         p_apli_rete           in varchar2,
                         p_impo_mone           in number,
                         p_impo_mmnn           in number,
                         p_tota_mmnn           in number,
                         p_rete_mone           out number,
                         p_rete_mmnn           out number,
                         p_tota_mone           in number default 0,
                         p_iva_mone            in number default 0,
                         p_iva_mmnn            in number default 0,
                         p_cant_deci           in number default 0,
                         p_iva10_mone          in number,
                         p_iva10_mmnn          in number,
                         p_iva5_mone           in number,
                         p_iva5_mmnn           in number,
                         p_apli_rete_impo_mini in char default 'N') is
  
    salir exception;
  begin
    if p_form_rete = 1 then
      pl_calc_rete_sobre_cien(p_empr_codi,
                              p_sucu_codi,
                              p_movi_codi,
                              p_apli_rete,
                              p_rete_mone,
                              p_rete_mmnn,
                              p_impo_mone,
                              p_impo_mmnn,
                              p_tota_mone,
                              p_tota_mmnn,
                              p_iva_mone,
                              p_iva_mmnn,
                              p_cant_deci,
                              p_apli_rete_impo_mini);
    elsif p_form_rete = 2 then
      pl_calc_rete_prorrateo(p_empr_codi,
                             p_sucu_codi,
                             p_movi_codi,
                             p_apli_rete,
                             p_impo_mone,
                             p_impo_mmnn,
                             p_tota_mmnn,
                             p_rete_mone,
                             p_rete_mmnn,
                             p_tota_mone,
                             p_iva_mone,
                             p_iva_mmnn,
                             p_cant_deci,
                             p_apli_rete_impo_mini);
    elsif p_form_rete = 3 then
      pl_calc_rete_prorxfact(p_empr_codi,
                             p_sucu_codi,
                             p_movi_codi,
                             p_apli_rete,
                             p_impo_mone,
                             p_impo_mmnn,
                             p_tota_mmnn,
                             p_rete_mone,
                             p_rete_mmnn,
                             p_tota_mone,
                             p_iva_mone,
                             p_iva_mmnn,
                             p_cant_deci,
                             p_apli_rete_impo_mini);
    elsif p_form_rete = 4 then
      pl_calc_rete_prorrateo_pand(p_empr_codi,
                                  p_sucu_codi,
                                  p_movi_codi,
                                  p_apli_rete,
                                  p_impo_mone,
                                  p_impo_mmnn,
                                  p_tota_mmnn,
                                  p_rete_mone,
                                  p_rete_mmnn,
                                  p_tota_mone,
                                  p_iva_mone,
                                  p_iva_mmnn,
                                  p_cant_deci,
                                  p_apli_rete_impo_mini);
    elsif p_form_rete = 5 then
      pl_calc_rete_sobre_cien_tesaka(p_empr_codi,
                                     p_sucu_codi,
                                     p_movi_codi,
                                     p_apli_rete,
                                     p_rete_mone,
                                     p_rete_mmnn,
                                     p_impo_mone,
                                     p_impo_mmnn,
                                     p_tota_mone,
                                     p_tota_mmnn,
                                     p_iva_mone,
                                     p_iva_mmnn,
                                     p_cant_deci,
                                     p_iva10_mone,
                                     p_iva10_mmnn,
                                     p_iva5_mone,
                                     p_iva5_mmnn,
                                     p_apli_rete_impo_mini);
    elsif p_form_rete = 6 then
      pl_calc_rete_cien_tesa_v2(p_empr_codi,
                                p_sucu_codi,
                                p_movi_codi,
                                p_apli_rete,
                                p_rete_mone,
                                p_rete_mmnn,
                                p_impo_mone,
                                p_impo_mmnn,
                                p_tota_mone,
                                p_tota_mmnn,
                                p_iva_mone,
                                p_iva_mmnn,
                                p_cant_deci,
                                p_iva10_mone,
                                p_iva10_mmnn,
                                p_iva5_mone,
                                p_iva5_mmnn,
                                p_apli_rete_impo_mini);
    end if;
  end pl_calc_rete;

  procedure pl_calc_rete_sobre_cien(p_empr_codi           in number,
                                    p_sucu_codi           in number,
                                    p_movi_codi           in number,
                                    p_apli_rete           in varchar2,
                                    p_rete_mone           out number,
                                    p_rete_mmnn           out number,
                                    p_impo_mone           in number,
                                    p_impo_mmnn           in number,
                                    p_tota_mone           in number,
                                    p_tota_mmnn           in number,
                                    p_iva_mone            in number,
                                    p_iva_mmnn            in number,
                                    p_cant_deci           in number,
                                    p_apli_rete_impo_mini in char) is
  
    cursor c_impu(p_codi in number) is
      select i.impu_porc,
             i.impu_porc_base_impo,
             nvl(i.impu_indi_baim_impu_incl, 'S') impu_indi_baim_impu_incl
      --into v_porc_impu, v_porc_base_impo, v_indi_baim_impu
        from come_movi_impu_deta mi, come_impu i
       where mi.moim_impu_codi = i.impu_codi
         and mi.moim_movi_codi = p_codi;
  
    v_empr_retentora varchar2(30);
    v_impo_vali      number;
  
    v_movi_codi_rete number;
    v_movi_exen_mmnn number;
    v_movi_grav_mmnn number;
    v_movi_iva_mmnn  number;
    v_movi_exen_mone number;
    v_movi_grav_mone number;
    v_movi_iva_mone  number;
  
    v_mone_cant_deci number;
    v_cant_deci_mmnn number;
  
    v_impo_rete_mmnn number;
    v_impo_rete_mone number;
  
    v_imp_min_aplic_reten number;
    v_porc_aplic_reten    number;
    v_indi_porc_rete_sucu varchar2(30);
    v_count               number := 0;
  
    v_canc_impo_mone number;
    v_canc_impo_mmnn number;
    v_porc_impu      number;
    v_porc_base_impo number;
    v_indi_baim_impu varchar2(2);
  
    v_nc_movi_exen_mmnn  number;
    v_nc_movi_grav_mmnn  number;
    v_nc_movi_iva_mmnn   number;
    v_nc_movi_exen_mone  number;
    v_nc_movi_grav_mone  number;
    v_nc_movi_iva_mone   number;
    v_nc_movi_iva10_mone number;
    v_nc_movi_iva5_mone  number;
    v_nc_movi_iva10_mmnn number;
    v_nc_movi_iva5_mmnn  number;
  
    v_nc_canc_impo_mmnn number;
    v_nc_grav10_mmnn_ii number;
    v_nc_grav5_mmnn_ii  number;
    v_nc_grav10_mmnn    number;
    v_nc_grav5_mmnn     number;
    v_nc_canc_impo_mone number;
    v_nc_grav10_mone_ii number;
    v_nc_grav5_mone_ii  number;
    v_nc_grav10_mone    number;
    v_nc_grav5_mone     number;
  
    v_porc_iva10_mone number;
    v_porc_iva10_mmnn number;
    v_porc_iva5_mone  number;
    v_porc_iva5_mmnn  number;
  
    salir exception;
  begin
  
    begin
      select e.empr_retentora
        into v_empr_retentora
        from come_empr e
       where e.empr_codi = p_empr_codi;
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'La empresa ' || p_empr_codi ||
                                ' no existe!.');
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
    if p_movi_codi is not null then
      begin
        select m.movi_codi_rete,
               m.movi_exen_mmnn,
               m.movi_grav_mmnn,
               m.movi_iva_mmnn,
               m.movi_exen_mone,
               m.movi_grav_mone,
               m.movi_iva_mone,
               n.mone_cant_deci
          into v_movi_codi_rete,
               v_movi_exen_mmnn,
               v_movi_grav_mmnn,
               v_movi_iva_mmnn,
               v_movi_exen_mone,
               v_movi_grav_mone,
               v_movi_iva_mone,
               v_mone_cant_deci
          from come_movi m, come_mone n
         where m.movi_mone_codi = n.mone_codi
           and m.movi_codi = p_movi_codi;
      
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'El documento con clave ' || p_movi_codi ||
                                  ' no existe!.');
        
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
      begin
        select count(*) --, nvl(sum(more_impo_mone),0) rete_mone, nvl(sum(more_impo_mmnn),0) rete_mmnn
          into v_count --, v_rete_mone, v_rete_mmnn
          from come_movi_rete
         where more_movi_codi = p_movi_codi;
      end;
    
      ---notas de creditos aplicadas a la factura
      for x in c_impu(p_movi_codi) loop
        begin
          select nvl(sum(mc.canc_impo_mone), 0) canc_impo_mone,
                 nvl(sum(mc.canc_impo_mmnn), 0) canc_impo_mmnn
            into v_canc_impo_mone, v_canc_impo_mmnn
            from come_movi_cuot_canc mc,
                 (select m.movi_codi
                    from come_movi m,
                         (select cc.canc_movi_codi
                            from come_movi_cuot_canc cc
                           where cc.canc_cuot_movi_codi in
                                 (select mo.movi_codi
                                    from come_movi mo
                                   where mo.movi_timo_codi in (11, 17))
                           group by cc.canc_movi_codi) canc_nc
                   where m.movi_codi_padr = canc_nc.canc_movi_codi
                   group by m.movi_codi) canc
           where mc.canc_movi_codi = canc.movi_codi
             and mc.canc_cuot_movi_codi = p_movi_codi;
        
          v_porc_impu      := x.impu_porc;
          v_porc_base_impo := x.impu_porc_base_impo;
          v_indi_baim_impu := x.impu_indi_baim_impu_incl;
        
          if v_porc_impu = 10 then
            v_canc_impo_mone := round((v_canc_impo_mone * v_porc_iva10_mone) / 100,
                                      0);
            v_canc_impo_mmnn := round((v_canc_impo_mmnn * v_porc_iva10_mmnn) / 100,
                                      0);
          elsif v_porc_impu = 5 then
            v_canc_impo_mone := round((v_canc_impo_mone * v_porc_iva5_mone) / 100,
                                      0);
            v_canc_impo_mmnn := round((v_canc_impo_mmnn * v_porc_iva5_mmnn) / 100,
                                      0);
          end if;
        
          pa_devu_impo_calc(v_canc_impo_mone,
                            v_mone_cant_deci,
                            v_porc_impu,
                            v_porc_base_impo,
                            v_indi_baim_impu,
                            v_nc_canc_impo_mone,
                            v_nc_grav10_mone_ii,
                            v_nc_grav5_mone_ii,
                            v_nc_grav10_mone,
                            v_nc_grav5_mone,
                            v_nc_movi_iva10_mone,
                            v_nc_movi_iva5_mone,
                            v_nc_movi_exen_mone);
        
          v_nc_movi_grav_mone := v_nc_grav10_mone + v_nc_grav5_mone;
          v_nc_movi_iva_mone  := v_nc_movi_iva10_mone + v_nc_movi_iva5_mone;
        
          pa_devu_impo_calc(v_canc_impo_mmnn,
                            v_mone_cant_deci,
                            v_porc_impu,
                            v_porc_base_impo,
                            v_indi_baim_impu,
                            v_nc_canc_impo_mmnn,
                            v_nc_grav10_mmnn_ii,
                            v_nc_grav5_mmnn_ii,
                            v_nc_grav10_mmnn,
                            v_nc_grav5_mmnn,
                            v_nc_movi_iva10_mmnn,
                            v_nc_movi_iva5_mmnn,
                            v_nc_movi_exen_mmnn);
        
          v_nc_movi_grav_mmnn := v_nc_grav10_mmnn + v_nc_grav5_mmnn;
          v_nc_movi_iva_mmnn  := v_nc_movi_iva10_mmnn + v_nc_movi_iva5_mmnn;
        
        exception
          when no_data_found then
            v_nc_movi_exen_mmnn  := 0;
            v_nc_movi_grav_mmnn  := 0;
            v_nc_movi_iva_mmnn   := 0;
            v_nc_movi_exen_mone  := 0;
            v_nc_movi_grav_mone  := 0;
            v_nc_movi_iva_mone   := 0;
            v_nc_movi_iva10_mone := 0;
            v_nc_movi_iva5_mone  := 0;
            v_nc_movi_iva10_mmnn := 0;
            v_nc_movi_iva5_mmnn  := 0;
            v_nc_canc_impo_mmnn  := 0;
            v_nc_grav10_mmnn_ii  := 0;
            v_nc_grav5_mmnn_ii   := 0;
            v_nc_grav10_mmnn     := 0;
            v_nc_grav5_mmnn      := 0;
            v_nc_canc_impo_mone  := 0;
            v_nc_grav10_mone_ii  := 0;
            v_nc_grav5_mone_ii   := 0;
            v_nc_grav10_mone     := 0;
            v_nc_grav5_mone      := 0;
          when others then
            raise_application_error(-20001, sqlerrm);
        end;
        ------------********--------------
        v_movi_exen_mmnn := v_movi_exen_mmnn - v_nc_movi_exen_mmnn;
        v_movi_grav_mmnn := v_movi_grav_mmnn - v_nc_movi_grav_mmnn;
        v_movi_iva_mmnn  := v_movi_iva_mmnn - v_nc_movi_iva_mmnn;
        v_movi_exen_mone := v_movi_exen_mone - v_nc_movi_exen_mone;
        v_movi_grav_mone := v_movi_grav_mone - v_nc_movi_grav_mone;
        v_movi_iva_mone  := v_movi_iva_mone - v_nc_movi_iva_mone;
        --v_movi_iva10_mone  := v_movi_iva10_mone - v_nc_movi_iva10_mone;
      --v_movi_iva5_mone   := v_movi_iva5_mone  - v_nc_movi_iva5_mone ;
      --v_movi_iva10_mmnn  := v_movi_iva10_mmnn - v_nc_movi_iva10_mmnn;
      --v_movi_iva5_mmnn   := v_movi_iva5_mmnn  - v_nc_movi_iva5_mmnn ;
      end loop;
    
    else
      v_movi_codi_rete := null;
      v_movi_exen_mmnn := nvl(p_tota_mmnn, 0) - nvl(p_impo_mmnn, 0) -
                          nvl(p_iva_mmnn, 0);
      v_movi_grav_mmnn := nvl(p_impo_mmnn, 0);
      v_movi_iva_mmnn  := nvl(p_iva_mmnn, 0);
      v_movi_exen_mone := nvl(p_tota_mone, 0) - nvl(p_impo_mone, 0) -
                          nvl(p_iva_mone, 0);
      v_movi_grav_mone := nvl(p_impo_mone, 0);
      v_movi_iva_mone  := nvl(p_iva_mone, 0);
      v_mone_cant_deci := p_cant_deci;
    end if;
  
    if upper(nvl(v_empr_retentora, 'no')) = upper('no') or
       v_movi_codi_rete is not null or v_count > 0 or
       upper(nvl(p_apli_rete, 's')) = upper('n') then
      v_impo_rete_mone := 0;
      v_impo_rete_mmnn := 0;
      p_rete_mone      := v_impo_rete_mone;
      p_rete_mmnn      := v_impo_rete_mmnn;
      raise salir;
    end if;
  
    v_imp_min_aplic_reten := to_number(fl_busca_parametro('p_imp_min_aplic_reten'));
    v_porc_aplic_reten    := to_number(fl_busca_parametro('p_porc_aplic_reten'));
    v_indi_porc_rete_sucu := ltrim(rtrim(fl_busca_parametro('p_indi_porc_rete_sucu')));
    v_cant_deci_mmnn      := to_number(fl_busca_parametro('p_cant_deci_mmnn'));
  
    if upper(nvl(v_indi_porc_rete_sucu, upper('n'))) = upper('s') then
      begin
        select s.sucu_porc_rete
          into v_porc_aplic_reten
          from come_sucu s
         where s.sucu_codi = p_sucu_codi
           and s.sucu_empr_codi = p_empr_codi;
      
        if v_porc_aplic_reten is null then
          raise_application_error(-20001,
                                  'Se debe configurar el parametro porcentaje de retencion ' ||
                                  'a ser aplicado en la sucursal ' ||
                                  p_sucu_codi);
        end if;
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'La sucursal ' || p_sucu_codi ||
                                  ' no existe!.');
        when others then
          raise_application_error(-20001, 'Error ' || sqlerrm);
      end;
    end if;
  
    if v_imp_min_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_IMP_MIN_APLIC_RETEN ' ||
                              'con el importe minimo para aplicar retenciones');
    end if;
  
    if v_porc_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_PORC_APLIC_RETEN ' ||
                              'con el porcentaje de retencion a ser aplicado');
    end if;
  
    v_impo_vali := p_impo_mmnn;
  
    if v_impo_vali >= v_imp_min_aplic_reten or
       p_tota_mmnn >= v_imp_min_aplic_reten or p_apli_rete_impo_mini = 'S' then
      v_impo_rete_mmnn := round((nvl(v_movi_iva_mmnn, 0) *
                                nvl(v_porc_aplic_reten, 0) / 100),
                                v_cant_deci_mmnn);
      v_impo_rete_mone := round((nvl(v_movi_iva_mone, 0) *
                                nvl(v_porc_aplic_reten, 0) / 100),
                                v_mone_cant_deci);
    else
      v_impo_rete_mone := 0;
      v_impo_rete_mmnn := 0;
    end if;
  
    p_rete_mone := v_impo_rete_mone;
    p_rete_mmnn := v_impo_rete_mmnn;
  exception
    when salir then
      null;
  end pl_calc_rete_sobre_cien;

  procedure pl_calc_rete_prorrateo(p_empr_codi           in number,
                                   p_sucu_codi           in number,
                                   p_movi_codi           in number,
                                   p_apli_rete           in varchar2,
                                   p_impo_mone           in number,
                                   p_impo_mmnn           in number,
                                   p_tota_mmnn           in number,
                                   p_rete_mone           out number,
                                   p_rete_mmnn           out number,
                                   p_tota_mone           in number,
                                   p_iva_mone            in number,
                                   p_iva_mmnn            in number,
                                   p_cant_deci           in number,
                                   p_apli_rete_impo_mini in char) is
  
    v_empr_retentora varchar2(30);
    v_impo_vali      number;
    v_impo_mmnn      number;
    v_impo_mone      number;
  
    v_movi_codi_rete number;
    v_movi_exen_mmnn number;
    v_movi_grav_mmnn number;
    v_movi_iva_mmnn  number;
    v_movi_exen_mone number;
    v_movi_grav_mone number;
    v_movi_iva_mone  number;
    v_tota_mmnn      number;
    v_tota_mone      number;
    v_mone_cant_deci number;
    v_cant_deci_mmnn number;
  
    v_impo_rete_mmnn number;
    v_impo_rete_mone number;
  
    v_impo_nocr_iva_mmnn number;
    v_impo_nocr_iva_mone number;
  
    v_imp_min_aplic_reten number;
    v_porc_aplic_reten    number;
    v_indi_porc_rete_sucu varchar2(30);
  
    v_porc_tota_iva number;
    v_impo_iva_mmnn number;
    v_impo_iva_mone number;
  
    salir exception;
  begin
    begin
      select e.empr_retentora
        into v_empr_retentora
        from come_empr e
       where e.empr_codi = p_empr_codi;
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'La empresa ' || p_empr_codi ||
                                ' no existe!.');
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
    if p_movi_codi is not null then
      v_tota_mmnn := p_tota_mmnn;
      v_tota_mone := p_tota_mone;
    
      v_impo_mmnn := v_tota_mmnn; --p_tota_mmnn
      v_impo_mone := v_tota_mone; --p_tota_mone
    
      begin
        select m.movi_codi_rete,
               m.movi_exen_mmnn,
               m.movi_grav_mmnn,
               m.movi_iva_mmnn,
               m.movi_exen_mone,
               m.movi_grav_mone,
               m.movi_iva_mone,
               n.mone_cant_deci
          into v_movi_codi_rete,
               v_movi_exen_mmnn,
               v_movi_grav_mmnn,
               v_movi_iva_mmnn,
               v_movi_exen_mone,
               v_movi_grav_mone,
               v_movi_iva_mone,
               v_mone_cant_deci
          from come_movi m, come_mone n
         where m.movi_mone_codi = n.mone_codi
           and m.movi_codi = p_movi_codi;
        v_impo_mmnn := p_impo_mmnn;
        v_impo_mone := p_impo_mone;
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'El documento con clave ' || p_movi_codi ||
                                  ' no existe!.');
        
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    else
    
      v_movi_exen_mmnn := nvl(p_tota_mmnn, 0) - nvl(p_impo_mmnn, 0) /*gravado*/
                          -nvl(p_iva_mmnn, 0);
      v_movi_grav_mmnn := nvl(p_impo_mmnn, 0);
      v_movi_iva_mmnn  := nvl(p_iva_mmnn, 0);
      v_movi_exen_mone := nvl(p_tota_mone, 0) - nvl(p_impo_mone, 0) -
                          nvl(p_iva_mone, 0);
      v_movi_grav_mone := nvl(p_impo_mone, 0);
      v_movi_iva_mone  := nvl(p_iva_mone, 0);
      v_mone_cant_deci := p_cant_deci;
    
      v_tota_mmnn := p_impo_mmnn;
      v_tota_mone := p_impo_mone;
    
      v_impo_mmnn := p_tota_mmnn;
      v_impo_mone := p_tota_mone;
    
    end if;
  
    if upper(nvl(v_empr_retentora, 'no')) = upper('no')
      
       or upper(nvl(p_apli_rete, 's')) = upper('n') then
    
      v_impo_rete_mone := 0;
      v_impo_rete_mmnn := 0;
    
      p_rete_mone := v_impo_rete_mone;
      p_rete_mmnn := v_impo_rete_mmnn;
    
      raise salir;
    end if;
  
    v_imp_min_aplic_reten := to_number(fl_busca_parametro('p_imp_min_aplic_reten'));
    v_porc_aplic_reten    := to_number(fl_busca_parametro('p_porc_aplic_reten'));
    v_indi_porc_rete_sucu := ltrim(rtrim(fl_busca_parametro('p_indi_porc_rete_sucu')));
    v_cant_deci_mmnn      := to_number(fl_busca_parametro('p_cant_deci_mmnn'));
  
    if upper(nvl(v_indi_porc_rete_sucu, upper('n'))) = upper('s') then
      begin
        select s.sucu_porc_rete
          into v_porc_aplic_reten
          from come_sucu s
         where s.sucu_codi = p_sucu_codi
           and s.sucu_empr_codi = p_empr_codi;
      
        if v_porc_aplic_reten is null then
          raise_application_error(-20001,
                                  'Se debe configurar el parametro porcentaje de retencion ' ||
                                  'a ser aplicado en la sucursal ' ||
                                  p_sucu_codi);
        end if;
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'La sucursal ' || p_sucu_codi ||
                                  ' no existe!.');
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    end if;
  
    if v_imp_min_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_IMP_MIN_APLIC_RETEN ' ||
                              'con el importe minimo para aplicar retenciones');
    end if;
    if v_porc_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_PORC_APLIC_RETEN ' ||
                              'con el porcentaje de retencion a ser aplicado');
    end if;
  
    v_impo_vali := nvl(v_movi_grav_mmnn, 0);
  
    if v_impo_vali >= v_imp_min_aplic_reten or
       v_tota_mmnn >= v_imp_min_aplic_reten or p_apli_rete_impo_mini = 'S' then
      v_porc_tota_iva := v_movi_iva_mone * 100 / (nvl(v_movi_exen_mone, 0) +
                         nvl(v_movi_grav_mone, 0) +
                         nvl(v_movi_iva_mone, 0));
    
      v_impo_iva_mmnn := v_impo_mmnn * v_porc_tota_iva / 100;
      v_impo_iva_mone := v_impo_mone * v_porc_tota_iva / 100;
    
      v_impo_rete_mmnn := round(((nvl(v_impo_iva_mmnn, 0) -
                                nvl(v_impo_nocr_iva_mmnn, 0)) *
                                nvl(v_porc_aplic_reten, 0) / 100),
                                v_cant_deci_mmnn);
      v_impo_rete_mone := round(((nvl(v_impo_iva_mone, 0) -
                                nvl(v_impo_nocr_iva_mone, 0)) *
                                nvl(v_porc_aplic_reten, 0) / 100),
                                v_mone_cant_deci);
    end if;
  
    p_rete_mone := nvl(v_impo_rete_mone, 0);
    p_rete_mmnn := nvl(v_impo_rete_mmnn, 0);
  
  exception
    when salir then
      null;
  end pl_calc_rete_prorrateo;

  procedure pl_calc_rete_prorxfact(p_empr_codi           in number,
                                   p_sucu_codi           in number,
                                   p_movi_codi           in number,
                                   p_apli_rete           in varchar2,
                                   p_impo_mone           in number,
                                   p_impo_mmnn           in number,
                                   p_tota_mmnn           in number,
                                   p_rete_mone           out number,
                                   p_rete_mmnn           out number,
                                   p_tota_mone           in number,
                                   p_iva_mone            in number,
                                   p_iva_mmnn            in number,
                                   p_cant_deci           in number,
                                   p_apli_rete_impo_mini in char) is
  
    v_empr_retentora varchar2(30);
    v_impo_vali      number;
    v_impo_mmnn      number;
    v_impo_mone      number;
  
    v_movi_codi_rete number;
    v_movi_exen_mmnn number;
    v_movi_grav_mmnn number;
    v_movi_iva_mmnn  number;
    v_movi_exen_mone number;
    v_movi_grav_mone number;
    v_movi_iva_mone  number;
  
    v_mone_cant_deci number;
    v_cant_deci_mmnn number;
  
    v_impo_rete_mmnn number;
    v_impo_rete_mone number;
  
    v_impo_nocr_iva_mmnn number;
    v_impo_nocr_iva_mone number;
  
    v_imp_min_aplic_reten number;
    v_porc_aplic_reten    number;
    v_indi_porc_rete_sucu varchar2(30);
  
    v_porc_tota_iva number;
    v_impo_iva_mmnn number;
    v_impo_iva_mone number;
  
    salir exception;
  begin
    begin
      select e.empr_retentora
        into v_empr_retentora
        from come_empr e
       where e.empr_codi = p_empr_codi;
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'La empresa ' || p_empr_codi ||
                                ' no existe!.');
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
    if p_movi_codi is not null then
      begin
        select m.movi_codi_rete,
               m.movi_exen_mmnn,
               m.movi_grav_mmnn,
               m.movi_iva_mmnn,
               m.movi_exen_mone,
               m.movi_grav_mone,
               m.movi_iva_mone,
               n.mone_cant_deci
          into v_movi_codi_rete,
               v_movi_exen_mmnn,
               v_movi_grav_mmnn,
               v_movi_iva_mmnn,
               v_movi_exen_mone,
               v_movi_grav_mone,
               v_movi_iva_mone,
               v_mone_cant_deci
          from come_movi m, come_mone n
         where m.movi_mone_codi = n.mone_codi
           and m.movi_codi = p_movi_codi;
        v_impo_mmnn := p_impo_mmnn;
        v_impo_mone := p_impo_mone;
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'El documento con clave ' || p_movi_codi ||
                                  ' no existe!.');
        
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    else
    
      v_movi_exen_mmnn := nvl(p_tota_mmnn, 0) - nvl(p_impo_mmnn, 0) -
                          nvl(p_iva_mmnn, 0);
      v_movi_grav_mmnn := nvl(p_impo_mmnn, 0);
      v_movi_iva_mmnn  := nvl(p_iva_mmnn, 0);
      v_movi_exen_mone := nvl(p_tota_mone, 0) - nvl(p_impo_mone, 0) -
                          nvl(p_iva_mone, 0);
      v_movi_grav_mone := nvl(p_impo_mone, 0);
      v_movi_iva_mone  := nvl(p_iva_mone, 0);
      v_mone_cant_deci := p_cant_deci;
      v_impo_mmnn      := p_tota_mmnn;
      v_impo_mone      := p_tota_mone;
    end if;
  
    if upper(nvl(v_empr_retentora, 'no')) = upper('no')
      --or v_movi_codi_rete is not null
       or upper(nvl(p_apli_rete, 's')) = upper('n') then
      v_impo_rete_mone := 0;
      v_impo_rete_mmnn := 0;
    
      p_rete_mone := v_impo_rete_mone;
      p_rete_mmnn := v_impo_rete_mmnn;
    
      raise salir;
    end if;
  
    v_imp_min_aplic_reten := to_number(fl_busca_parametro('p_imp_min_aplic_reten'));
    v_porc_aplic_reten    := to_number(fl_busca_parametro('p_porc_aplic_reten'));
    v_indi_porc_rete_sucu := ltrim(rtrim(fl_busca_parametro('p_indi_porc_rete_sucu')));
    v_cant_deci_mmnn      := to_number(fl_busca_parametro('p_cant_deci_mmnn'));
  
    if upper(nvl(v_indi_porc_rete_sucu, upper('n'))) = upper('s') then
      begin
        select s.sucu_porc_rete
          into v_porc_aplic_reten
          from come_sucu s
         where s.sucu_codi = p_sucu_codi
           and s.sucu_empr_codi = p_empr_codi;
      
        if v_porc_aplic_reten is null then
          raise_application_error(-20001,
                                  'Se debe configurar el parametro porcentaje de retencion ' ||
                                  'a ser aplicado en la sucursal ' ||
                                  p_sucu_codi);
        end if;
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'La sucursal ' || p_sucu_codi ||
                                  ' no existe!.');
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    end if;
  
    if v_imp_min_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_IMP_MIN_APLIC_RETEN ' ||
                              'con el importe minimo para aplicar retenciones');
    end if;
    if v_porc_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_PORC_APLIC_RETEN ' ||
                              'con el porcentaje de retencion a ser aplicado');
    end if;
  
    --pp_calcular_notacred(v_impo_nocr_iva_mone, v_impo_nocr_iva_mmnn, v_impo_nocr_mone, v_impo_nocr_mmnn);
    --v_impo_valido := nvl(fp_calcular_acumulado, 0) + nvl(v_movi_grav_mmnn, 0) - nvl(v_impo_nocr_mmnn, 0);
    v_impo_vali := nvl(v_movi_grav_mmnn, 0);
  
    if v_impo_vali >= v_imp_min_aplic_reten or p_apli_rete_impo_mini = 'S' then
      v_porc_tota_iva := v_movi_iva_mone * 100 / (nvl(v_movi_exen_mone, 0) +
                         nvl(v_movi_grav_mone, 0) +
                         nvl(v_movi_iva_mone, 0));
    
      v_impo_iva_mmnn := v_impo_mmnn * v_porc_tota_iva / 100;
      v_impo_iva_mone := v_impo_mone * v_porc_tota_iva / 100;
    
      v_impo_rete_mmnn := round(((nvl(v_impo_iva_mmnn, 0) -
                                nvl(v_impo_nocr_iva_mmnn, 0)) *
                                nvl(v_porc_aplic_reten, 0) / 100),
                                v_cant_deci_mmnn);
      v_impo_rete_mone := round(((nvl(v_impo_iva_mone, 0) -
                                nvl(v_impo_nocr_iva_mone, 0)) *
                                nvl(v_porc_aplic_reten, 0) / 100),
                                v_mone_cant_deci);
    end if;
  
    p_rete_mone := nvl(v_impo_rete_mone, 0);
    p_rete_mmnn := nvl(v_impo_rete_mmnn, 0);
  
  exception
    when salir then
      null;
  end pl_calc_rete_prorxfact;

  procedure pl_calc_rete_prorrateo_pand(p_empr_codi           in number,
                                        p_sucu_codi           in number,
                                        p_movi_codi           in number,
                                        p_apli_rete           in varchar2,
                                        p_impo_mone           in number,
                                        p_impo_mmnn           in number,
                                        p_tota_mmnn           in number,
                                        p_rete_mone           out number,
                                        p_rete_mmnn           out number,
                                        p_tota_mone           in number,
                                        p_iva_mone            in number,
                                        p_iva_mmnn            in number,
                                        p_cant_deci           in number,
                                        p_apli_rete_impo_mini in char) is
  
    v_empr_retentora varchar2(30);
    v_impo_vali      number;
    v_impo_mmnn      number;
    v_impo_mone      number;
  
    v_movi_codi_rete number;
    v_movi_exen_mmnn number;
    v_movi_grav_mmnn number;
    v_movi_iva_mmnn  number;
    v_movi_exen_mone number;
    v_movi_grav_mone number;
    v_movi_iva_mone  number;
  
    v_mone_cant_deci      number;
    v_cant_deci_mmnn      number;
    v_impo_rete_mmnn      number;
    v_impo_rete_mone      number;
    v_imp_min_aplic_reten number;
    v_porc_aplic_reten    number;
    v_indi_porc_rete_sucu varchar2(30);
    v_movi_impo_reca      number;
    v_movi_impo_ncrr      number;
    v_porc_tota_iva       number;
    v_impo_iva_mmnn       number;
    v_impo_iva_mone       number;
  
    v_tasa_mone number;
  
    salir exception;
  begin
  
    begin
      select e.empr_retentora
        into v_empr_retentora
        from come_empr e
       where e.empr_codi = p_empr_codi;
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'La empresa ' || p_empr_codi ||
                                ' no existe!.');
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
    if p_movi_codi is not null then
      begin
        select m.movi_codi_rete,
               m.movi_exen_mmnn,
               m.movi_grav_mmnn,
               m.movi_iva_mmnn,
               m.movi_exen_mone,
               m.movi_grav_mone,
               m.movi_iva_mone,
               n.mone_cant_deci,
               m.movi_impo_reca,
               fa_devu_impo_nota_cred_reci(m.movi_codi, m.movi_mone_codi),
               movi_tasa_mone
          into v_movi_codi_rete,
               v_movi_exen_mmnn,
               v_movi_grav_mmnn,
               v_movi_iva_mmnn,
               v_movi_exen_mone,
               v_movi_grav_mone,
               v_movi_iva_mone,
               v_mone_cant_deci,
               v_movi_impo_reca,
               v_movi_impo_ncrr,
               v_tasa_mone
          from come_movi m, come_mone n
         where m.movi_mone_codi = n.mone_codi
           and m.movi_codi = p_movi_codi;
      
        v_impo_mmnn := p_impo_mmnn;
        v_impo_mone := p_impo_mone;
      
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'El documento con clave ' || p_movi_codi ||
                                  ' no existe!.');
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    else
      v_movi_exen_mmnn := nvl(p_tota_mmnn, 0) - nvl(p_impo_mmnn, 0) -
                          nvl(p_iva_mmnn, 0);
      v_movi_grav_mmnn := nvl(p_impo_mmnn, 0);
      v_movi_iva_mmnn  := nvl(p_iva_mmnn, 0);
      v_movi_exen_mone := nvl(p_tota_mone, 0) - nvl(p_impo_mone, 0) -
                          nvl(p_iva_mone, 0);
      v_movi_grav_mone := nvl(p_impo_mone, 0);
      v_movi_iva_mone  := nvl(p_iva_mone, 0);
      v_mone_cant_deci := p_cant_deci;
      v_impo_mmnn      := p_tota_mmnn;
      v_impo_mone      := p_tota_mone;
    end if;
  
    if upper(nvl(v_empr_retentora, 'no')) = upper('no')
      --or v_movi_codi_rete is not null
       or upper(nvl(p_apli_rete, 's')) = upper('n') then
      v_impo_rete_mone := 0;
      v_impo_rete_mmnn := 0;
    
      p_rete_mone := v_impo_rete_mone;
      p_rete_mmnn := v_impo_rete_mmnn;
    
      raise salir;
    end if;
  
    v_imp_min_aplic_reten := to_number(fl_busca_parametro('p_imp_min_aplic_reten'));
    v_porc_aplic_reten    := to_number(fl_busca_parametro('p_porc_aplic_reten'));
    v_indi_porc_rete_sucu := ltrim(rtrim(fl_busca_parametro('p_indi_porc_rete_sucu')));
    v_cant_deci_mmnn      := to_number(fl_busca_parametro('p_cant_deci_mmnn'));
  
    if upper(nvl(v_indi_porc_rete_sucu, upper('n'))) = upper('s') then
      begin
        select s.sucu_porc_rete
          into v_porc_aplic_reten
          from come_sucu s
         where s.sucu_codi = p_sucu_codi
           and s.sucu_empr_codi = p_empr_codi;
      
        if v_porc_aplic_reten is null then
          raise_application_error(-20001,
                                  'Se debe configurar el parametro porcentaje de retencion ' ||
                                  'a ser aplicado en la sucursal ' ||
                                  p_sucu_codi);
        end if;
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'La sucursal ' || p_sucu_codi ||
                                  ' no existe!.');
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    end if;
  
    if v_imp_min_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_IMP_MIN_APLIC_RETEN ' ||
                              'con el importe minimo para aplicar retenciones');
    end if;
    if v_porc_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_PORC_APLIC_RETEN ' ||
                              'con el porcentaje de retencion a ser aplicado');
    end if;
  
    v_impo_vali := nvl(v_movi_exen_mone, 0) + nvl(v_movi_grav_mone, 0) +
                   nvl(v_movi_iva_mone, 0) - nvl(v_movi_impo_reca, 0) -
                   nvl(v_movi_impo_ncrr, 0);
  
    if v_impo_vali <> 0 then
      if v_impo_vali * v_tasa_mone >= v_imp_min_aplic_reten or
         p_tota_mmnn >= v_imp_min_aplic_reten or
         p_apli_rete_impo_mini = 'S' then
      
        v_porc_tota_iva  := pa_calc_impo(v_impo_vali,
                                         p_cant_deci,
                                         10,
                                         100,
                                         'S',
                                         'IVA') * 100 / (v_impo_vali);
        v_impo_iva_mmnn  := round(v_impo_mmnn * v_porc_tota_iva / 100,
                                  p_cant_deci);
        v_impo_iva_mone  := round(v_impo_mone * v_porc_tota_iva / 100,
                                  p_cant_deci);
        v_impo_rete_mmnn := round(((nvl(v_impo_iva_mmnn, 0)) *
                                  nvl(v_porc_aplic_reten, 0) / 100),
                                  v_cant_deci_mmnn);
        v_impo_rete_mone := round(((nvl(v_impo_iva_mone, 0)) *
                                  nvl(v_porc_aplic_reten, 0) / 100),
                                  v_mone_cant_deci);
      end if;
    end if;
    p_rete_mone := nvl(v_impo_rete_mone, 0);
    p_rete_mmnn := nvl(v_impo_rete_mmnn, 0);
  
  exception
    when salir then
      null;
  end pl_calc_rete_prorrateo_pand;

  procedure pl_calc_rete_sobre_cien_tesaka(p_empr_codi           in number,
                                           p_sucu_codi           in number,
                                           p_movi_codi           in number,
                                           p_apli_rete           in varchar2,
                                           p_rete_mone           out number,
                                           p_rete_mmnn           out number,
                                           p_impo_mone           in number,
                                           p_impo_mmnn           in number,
                                           p_tota_mone           in number,
                                           p_tota_mmnn           in number,
                                           p_iva_mone            in number,
                                           p_iva_mmnn            in number,
                                           p_cant_deci           in number,
                                           p_iva10_mone          in number,
                                           p_iva10_mmnn          in number,
                                           p_iva5_mone           in number,
                                           p_iva5_mmnn           in number,
                                           p_apli_rete_impo_mini in char) is
  
    cursor c_impu(p_codi in number) is
      select i.impu_porc,
             i.impu_porc_base_impo,
             nvl(i.impu_indi_baim_impu_incl, 'S') impu_indi_baim_impu_incl
        from come_movi_impu_deta mi, come_impu i
       where mi.moim_impu_codi = i.impu_codi
         and mi.moim_movi_codi = p_codi;
  
    v_empr_retentora varchar2(30);
    v_impo_vali      number;
  
    v_movi_codi_rete  number;
    v_movi_exen_mmnn  number;
    v_movi_grav_mmnn  number;
    v_movi_iva_mmnn   number;
    v_movi_exen_mone  number;
    v_movi_grav_mone  number;
    v_movi_iva_mone   number;
    v_movi_iva10_mone number;
    v_movi_iva5_mone  number;
    v_movi_iva10_mmnn number;
    v_movi_iva5_mmnn  number;
    v_mone_cant_deci  number;
    v_cant_deci_mmnn  number;
    v_impo_rete_mmnn  number;
    v_impo_rete_mone  number;
  
    v_imp_min_aplic_reten    number;
    v_porc_aplic_reten       number;
    v_porc_aplic_reten_iva10 number;
    v_porc_aplic_reten_iva5  number;
    v_indi_porc_rete_sucu    varchar2(30);
    v_impo_retenido_mone     number;
    v_impo_retenido_mmnn     number;
  
    v_canc_impo_mone number;
    v_canc_impo_mmnn number;
    v_porc_impu      number;
    v_porc_base_impo number;
    v_indi_baim_impu varchar2(2);
  
    v_nc_movi_exen_mmnn  number;
    v_nc_movi_grav_mmnn  number;
    v_nc_movi_iva_mmnn   number;
    v_nc_movi_exen_mone  number;
    v_nc_movi_grav_mone  number;
    v_nc_movi_iva_mone   number;
    v_nc_movi_iva10_mone number;
    v_nc_movi_iva5_mone  number;
    v_nc_movi_iva10_mmnn number;
    v_nc_movi_iva5_mmnn  number;
  
    v_nc_canc_impo_mmnn number;
    v_nc_grav10_mmnn_ii number;
    v_nc_grav5_mmnn_ii  number;
    v_nc_grav10_mmnn    number;
    v_nc_grav5_mmnn     number;
    v_nc_canc_impo_mone number;
    v_nc_grav10_mone_ii number;
    v_nc_grav5_mone_ii  number;
    v_nc_grav10_mone    number;
    v_nc_grav5_mone     number;
  
    v_porc_iva10_mone number;
    v_porc_iva10_mmnn number;
    v_porc_iva5_mone  number;
    v_porc_iva5_mmnn  number;
  
    salir exception;
  
  begin
  
    begin
      select e.empr_retentora
        into v_empr_retentora
        from come_empr e
       where e.empr_codi = p_empr_codi;
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'La empresa ' || p_empr_codi ||
                                ' no existe!.');
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
    if p_movi_codi is not null then
      begin
        select m.movi_codi_rete,
               m.movi_exen_mmnn,
               m.movi_grav_mmnn,
               m.movi_iva_mmnn,
               m.movi_exen_mone,
               m.movi_grav_mone,
               m.movi_iva_mone,
               n.mone_cant_deci,
               m.movi_iva10_mone,
               m.movi_iva5_mone,
               m.movi_iva10_mmnn,
               m.movi_iva5_mmnn
          into v_movi_codi_rete,
               v_movi_exen_mmnn,
               v_movi_grav_mmnn,
               v_movi_iva_mmnn,
               v_movi_exen_mone,
               v_movi_grav_mone,
               v_movi_iva_mone,
               v_mone_cant_deci,
               v_movi_iva10_mone,
               v_movi_iva5_mone,
               v_movi_iva10_mmnn,
               v_movi_iva5_mmnn
          from come_movi m, come_mone n
         where m.movi_mone_codi = n.mone_codi
           and m.movi_codi = p_movi_codi;
      
        if v_movi_iva10_mone = 0 then
          v_porc_iva10_mone := 0;
        else
          v_porc_iva10_mone := round((v_movi_iva10_mone * 100) /
                                     v_movi_iva_mone,
                                     0);
        end if;
      
        if v_movi_iva_mmnn = 0 then
          v_porc_iva10_mmnn := 0;
        else
          v_porc_iva10_mmnn := round((v_movi_iva10_mmnn * 100) /
                                     v_movi_iva_mmnn,
                                     0);
        end if;
      
        if v_movi_iva_mone = 0 then
          v_porc_iva5_mone := 0;
        else
          v_porc_iva5_mone := round((v_movi_iva5_mone * 100) /
                                    v_movi_iva_mone,
                                    0);
        end if;
      
        if v_movi_iva_mmnn = 0 then
          v_porc_iva5_mmnn := 0;
        else
          v_porc_iva5_mmnn := round((v_movi_iva5_mmnn * 100) /
                                    v_movi_iva_mmnn,
                                    0);
        end if;
      
        if (v_porc_iva10_mone + v_porc_iva5_mone) <> 100 then
          if v_porc_iva10_mone > v_porc_iva5_mone then
            v_porc_iva10_mone := v_porc_iva10_mone +
                                 (100 -
                                 (v_porc_iva10_mone + v_porc_iva5_mone));
            v_porc_iva10_mmnn := v_porc_iva10_mmnn +
                                 (100 -
                                 (v_porc_iva10_mmnn + v_porc_iva5_mmnn));
          else
            v_porc_iva5_mone := v_porc_iva5_mone + (100 - (v_porc_iva10_mone +
                                v_porc_iva5_mone));
            v_porc_iva5_mmnn := v_porc_iva5_mmnn + (100 - (v_porc_iva10_mmnn +
                                v_porc_iva5_mmnn));
          end if;
        end if;
      
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'El documento con clave ' || p_movi_codi ||
                                  ' no existe!.');
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    
      ---notas de creditos aplicadas a la factura
      for x in c_impu(p_movi_codi) loop
        begin
          select nvl(sum(mc.canc_impo_mone), 0) canc_impo_mone,
                 nvl(sum(mc.canc_impo_mmnn), 0) canc_impo_mmnn
            into v_canc_impo_mone, v_canc_impo_mmnn
            from come_movi_cuot_canc mc,
                 (select m.movi_codi
                    from come_movi m,
                         (select cc.canc_movi_codi
                            from come_movi_cuot_canc cc
                           where cc.canc_cuot_movi_codi in
                                 (select mo.movi_codi
                                    from come_movi mo
                                   where mo.movi_timo_codi in (11, 17))
                           group by cc.canc_movi_codi) canc_nc
                   where m.movi_codi_padr = canc_nc.canc_movi_codi
                   group by m.movi_codi) canc
           where mc.canc_movi_codi = canc.movi_codi
             and mc.canc_cuot_movi_codi = p_movi_codi;
        
          v_porc_impu      := x.impu_porc;
          v_porc_base_impo := x.impu_porc_base_impo;
          v_indi_baim_impu := x.impu_indi_baim_impu_incl;
        
          if v_porc_impu = 10 then
            v_canc_impo_mone := round((v_canc_impo_mone * v_porc_iva10_mone) / 100,
                                      0);
            v_canc_impo_mmnn := round((v_canc_impo_mmnn * v_porc_iva10_mmnn) / 100,
                                      0);
          elsif v_porc_impu = 5 then
            v_canc_impo_mone := round((v_canc_impo_mone * v_porc_iva5_mone) / 100,
                                      0);
            v_canc_impo_mmnn := round((v_canc_impo_mmnn * v_porc_iva5_mmnn) / 100,
                                      0);
          end if;
        
          pa_devu_impo_calc(v_canc_impo_mone,
                            v_mone_cant_deci,
                            v_porc_impu,
                            v_porc_base_impo,
                            v_indi_baim_impu,
                            v_nc_canc_impo_mone,
                            v_nc_grav10_mone_ii,
                            v_nc_grav5_mone_ii,
                            v_nc_grav10_mone,
                            v_nc_grav5_mone,
                            v_nc_movi_iva10_mone,
                            v_nc_movi_iva5_mone,
                            v_nc_movi_exen_mone);
        
          v_nc_movi_grav_mone := v_nc_grav10_mone + v_nc_grav5_mone;
          v_nc_movi_iva_mone  := v_nc_movi_iva10_mone + v_nc_movi_iva5_mone;
        
          pa_devu_impo_calc(v_canc_impo_mmnn,
                            v_mone_cant_deci,
                            v_porc_impu,
                            v_porc_base_impo,
                            v_indi_baim_impu,
                            v_nc_canc_impo_mmnn,
                            v_nc_grav10_mmnn_ii,
                            v_nc_grav5_mmnn_ii,
                            v_nc_grav10_mmnn,
                            v_nc_grav5_mmnn,
                            v_nc_movi_iva10_mmnn,
                            v_nc_movi_iva5_mmnn,
                            v_nc_movi_exen_mmnn);
        
          v_nc_movi_grav_mmnn := v_nc_grav10_mmnn + v_nc_grav5_mmnn;
          v_nc_movi_iva_mmnn  := v_nc_movi_iva10_mmnn + v_nc_movi_iva5_mmnn;
        
        exception
          when no_data_found then
            v_nc_movi_exen_mmnn  := 0;
            v_nc_movi_grav_mmnn  := 0;
            v_nc_movi_iva_mmnn   := 0;
            v_nc_movi_exen_mone  := 0;
            v_nc_movi_grav_mone  := 0;
            v_nc_movi_iva_mone   := 0;
            v_nc_movi_iva10_mone := 0;
            v_nc_movi_iva5_mone  := 0;
            v_nc_movi_iva10_mmnn := 0;
            v_nc_movi_iva5_mmnn  := 0;
            v_nc_canc_impo_mmnn  := 0;
            v_nc_grav10_mmnn_ii  := 0;
            v_nc_grav5_mmnn_ii   := 0;
            v_nc_grav10_mmnn     := 0;
            v_nc_grav5_mmnn      := 0;
            v_nc_canc_impo_mone  := 0;
            v_nc_grav10_mone_ii  := 0;
            v_nc_grav5_mone_ii   := 0;
            v_nc_grav10_mone     := 0;
            v_nc_grav5_mone      := 0;
          when others then
            raise_application_error(-20001, sqlerrm);
        end;
        ------------********--------------
        v_movi_exen_mmnn  := v_movi_exen_mmnn - v_nc_movi_exen_mmnn;
        v_movi_grav_mmnn  := v_movi_grav_mmnn - v_nc_movi_grav_mmnn;
        v_movi_iva_mmnn   := v_movi_iva_mmnn - v_nc_movi_iva_mmnn;
        v_movi_exen_mone  := v_movi_exen_mone - v_nc_movi_exen_mone;
        v_movi_grav_mone  := v_movi_grav_mone - v_nc_movi_grav_mone;
        v_movi_iva_mone   := v_movi_iva_mone - v_nc_movi_iva_mone;
        v_movi_iva10_mone := v_movi_iva10_mone - v_nc_movi_iva10_mone;
        v_movi_iva5_mone  := v_movi_iva5_mone - v_nc_movi_iva5_mone;
        v_movi_iva10_mmnn := v_movi_iva10_mmnn - v_nc_movi_iva10_mmnn;
        v_movi_iva5_mmnn  := v_movi_iva5_mmnn - v_nc_movi_iva5_mmnn;
      end loop;
    else
      v_movi_codi_rete  := null;
      v_movi_exen_mmnn  := nvl(p_tota_mmnn, 0) - nvl(p_impo_mmnn, 0) -
                           nvl(p_iva_mmnn, 0);
      v_movi_grav_mmnn  := nvl(p_impo_mmnn, 0);
      v_movi_iva_mmnn   := nvl(p_iva_mmnn, 0);
      v_movi_exen_mone  := nvl(p_tota_mone, 0) - nvl(p_impo_mone, 0) -
                           nvl(p_iva_mone, 0);
      v_movi_grav_mone  := nvl(p_impo_mone, 0);
      v_movi_iva_mone   := nvl(p_iva_mone, 0);
      v_mone_cant_deci  := p_cant_deci;
      v_movi_iva10_mone := nvl(p_iva10_mone, 0);
      v_movi_iva10_mmnn := nvl(p_iva10_mmnn, 0);
      v_movi_iva5_mone  := nvl(p_iva5_mone, 0);
      v_movi_iva5_mmnn  := nvl(p_iva5_mmnn, 0);
    end if;
  
    v_imp_min_aplic_reten    := to_number(fl_busca_parametro('p_imp_min_aplic_reten'));
    v_porc_aplic_reten       := to_number(fl_busca_parametro('p_porc_aplic_reten'));
    v_porc_aplic_reten_iva10 := to_number(fl_busca_parametro('p_porc_aplic_reten_iva10'));
    v_porc_aplic_reten_iva5  := to_number(fl_busca_parametro('p_porc_aplic_reten_iva5'));
    v_indi_porc_rete_sucu    := ltrim(rtrim(fl_busca_parametro('p_indi_porc_rete_sucu')));
    v_cant_deci_mmnn         := to_number(fl_busca_parametro('p_cant_deci_mmnn'));
  
    if upper(nvl(v_indi_porc_rete_sucu, upper('n'))) = upper('s') then
      begin
        select s.sucu_porc_rete
          into v_porc_aplic_reten
          from come_sucu s
         where s.sucu_codi = p_sucu_codi
           and s.sucu_empr_codi = p_empr_codi;
      
        if v_porc_aplic_reten is null then
          raise_application_error(-20001,
                                  'Se debe configurar el parametro porcentaje de retencion ' ||
                                  'a ser aplicado en la sucursal ' ||
                                  p_sucu_codi);
        end if;
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'La sucursal ' || p_sucu_codi ||
                                  ' no existe!.');
        
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    end if;
  
    if v_imp_min_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_IMP_MIN_APLIC_RETEN ' ||
                              'con el importe minimo para aplicar retenciones');
    end if;
  
    if v_porc_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_PORC_APLIC_RETEN ' ||
                              'con el porcentaje de retencion a ser aplicado');
    end if;
  
    if v_porc_aplic_reten_iva10 is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_PORC_APLIC_RETEN_IVA10 ' ||
                              'con el porcentaje de retencion a ser aplicado');
    end if;
  
    if v_porc_aplic_reten_iva5 is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_PORC_APLIC_RETEN_IVA5 ' ||
                              'con el porcentaje de retencion a ser aplicado');
    end if;
    if upper(nvl(v_empr_retentora, 'no')) = upper('no') or
       v_movi_codi_rete is not null or
       upper(nvl(p_apli_rete, 's')) = upper('n') then
      v_impo_rete_mone := 0;
      v_impo_rete_mmnn := 0;
    
      p_rete_mone := v_impo_rete_mone;
      p_rete_mmnn := v_impo_rete_mmnn;
    
      raise salir;
    end if;
    v_impo_vali := nvl(v_movi_grav_mmnn, 0);
  
    if v_impo_vali >= v_imp_min_aplic_reten or p_apli_rete_impo_mini = 'S' then
      if p_movi_codi is not null then
        begin
          select sum(more_impo_mone) impo_rete_mone,
                 sum(more_impo_mmnn) impo_rete_mmnn
            into v_impo_retenido_mone, v_impo_retenido_mmnn
            from come_movi_rete a
           where more_movi_codi = p_movi_codi;
        end;
      end if;
    
      v_impo_rete_mmnn := round((nvl(v_movi_iva10_mmnn, 0) *
                                nvl(v_porc_aplic_reten_iva10, 0) / 100),
                                v_cant_deci_mmnn) +
                          round((nvl(v_movi_iva5_mmnn, 0) *
                                nvl(v_porc_aplic_reten_iva5, 0) / 100),
                                v_cant_deci_mmnn);
    
      v_impo_rete_mmnn := nvl(v_impo_rete_mmnn, 0) -
                          nvl(v_impo_retenido_mmnn, 0);
    
      v_impo_rete_mone := round((nvl(v_movi_iva10_mone, 0) *
                                nvl(v_porc_aplic_reten_iva10, 0) / 100),
                                v_mone_cant_deci) +
                          round((nvl(v_movi_iva5_mone, 0) *
                                nvl(v_porc_aplic_reten_iva5, 0) / 100),
                                v_mone_cant_deci);
    
      v_impo_rete_mone := nvl(v_impo_rete_mone, 0) -
                          nvl(v_impo_retenido_mone, 0);
    
    else
      v_impo_rete_mmnn := 0;
      v_impo_rete_mone := 0;
    end if;
  
    p_rete_mone := v_impo_rete_mone;
    p_rete_mmnn := v_impo_rete_mmnn;
  
  exception
    when salir then
      null;
  end pl_calc_rete_sobre_cien_tesaka;

  procedure pl_calc_rete_cien_tesa_v2(p_empr_codi           in number,
                                      p_sucu_codi           in number,
                                      p_movi_codi           in number,
                                      p_apli_rete           in varchar2,
                                      p_rete_mone           out number,
                                      p_rete_mmnn           out number,
                                      p_impo_mone           in number,
                                      p_impo_mmnn           in number,
                                      p_tota_mone           in number,
                                      p_tota_mmnn           in number,
                                      p_iva_mone            in number,
                                      p_iva_mmnn            in number,
                                      p_cant_deci           in number,
                                      p_iva10_mone          in number,
                                      p_iva10_mmnn          in number,
                                      p_iva5_mone           in number,
                                      p_iva5_mmnn           in number,
                                      p_apli_rete_impo_mini in char) is
  
    cursor c_impu(p_codi in number) is
      select i.impu_porc,
             i.impu_porc_base_impo,
             nvl(i.impu_indi_baim_impu_incl, 'S') impu_indi_baim_impu_incl
        from come_movi_impu_deta mi, come_impu i
       where mi.moim_impu_codi = i.impu_codi
         and mi.moim_movi_codi = p_codi;
  
    v_empr_retentora varchar2(30);
    v_impo_vali      number;
  
    v_movi_codi_rete  number;
    v_movi_exen_mmnn  number;
    v_movi_grav_mmnn  number;
    v_movi_iva_mmnn   number;
    v_movi_exen_mone  number;
    v_movi_grav_mone  number;
    v_movi_iva_mone   number;
    v_movi_iva10_mone number;
    v_movi_iva5_mone  number;
    v_movi_iva10_mmnn number;
    v_movi_iva5_mmnn  number;
    v_mone_cant_deci  number;
    v_cant_deci_mmnn  number;
    v_impo_rete_mmnn  number;
    v_impo_rete_mone  number;
  
    v_imp_min_aplic_reten    number;
    v_porc_aplic_reten       number;
    v_porc_aplic_reten_iva10 number;
    v_porc_aplic_reten_iva5  number;
    v_indi_porc_rete_sucu    varchar2(30);
    v_impo_retenido_mone     number;
    v_impo_retenido_mmnn     number;
  
    v_canc_impo_mone number;
    v_canc_impo_mmnn number;
    v_porc_impu      number;
    v_porc_base_impo number;
    v_indi_baim_impu varchar2(2);
  
    v_nc_movi_exen_mmnn  number;
    v_nc_movi_grav_mmnn  number;
    v_nc_movi_iva_mmnn   number;
    v_nc_movi_exen_mone  number;
    v_nc_movi_grav_mone  number;
    v_nc_movi_iva_mone   number;
    v_nc_movi_iva10_mone number;
    v_nc_movi_iva5_mone  number;
    v_nc_movi_iva10_mmnn number;
    v_nc_movi_iva5_mmnn  number;
  
    v_nc_canc_impo_mmnn number;
    v_nc_grav10_mmnn_ii number;
    v_nc_grav5_mmnn_ii  number;
    v_nc_grav10_mmnn    number;
    v_nc_grav5_mmnn     number;
    v_nc_canc_impo_mone number;
    v_nc_grav10_mone_ii number;
    v_nc_grav5_mone_ii  number;
    v_nc_grav10_mone    number;
    v_nc_grav5_mone     number;
  
    v_porc_iva10_mone number;
    v_porc_iva10_mmnn number;
    v_porc_iva5_mone  number;
    v_porc_iva5_mmnn  number;
  
    salir exception;
  
  begin
  
    begin
      select e.empr_retentora
        into v_empr_retentora
        from come_empr e
       where e.empr_codi = p_empr_codi;
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'La empresa ' || p_empr_codi ||
                                ' no existe!.');
      when others then
        raise_application_error(-20001, sqlerrm);
    end;
  
    if p_movi_codi is not null then
      begin
        select m.movi_codi_rete,
               m.movi_exen_mmnn,
               m.movi_grav_mmnn,
               m.movi_iva_mmnn,
               m.movi_exen_mone,
               m.movi_grav_mone,
               m.movi_iva_mone,
               n.mone_cant_deci,
               m.movi_iva10_mone,
               m.movi_iva5_mone,
               m.movi_iva10_mmnn,
               m.movi_iva5_mmnn
          into v_movi_codi_rete,
               v_movi_exen_mmnn,
               v_movi_grav_mmnn,
               v_movi_iva_mmnn,
               v_movi_exen_mone,
               v_movi_grav_mone,
               v_movi_iva_mone,
               v_mone_cant_deci,
               v_movi_iva10_mone,
               v_movi_iva5_mone,
               v_movi_iva10_mmnn,
               v_movi_iva5_mmnn
          from come_movi m, come_mone n
         where m.movi_mone_codi = n.mone_codi
           and m.movi_codi = p_movi_codi;
      
        if v_movi_iva10_mone = 0 then
          v_porc_iva10_mone := 0;
        else
          v_porc_iva10_mone := round((v_movi_iva10_mone * 100) /
                                     v_movi_iva_mone,
                                     0);
        end if;
      
        if v_movi_iva_mmnn = 0 then
          v_porc_iva10_mmnn := 0;
        else
          v_porc_iva10_mmnn := round((v_movi_iva10_mmnn * 100) /
                                     v_movi_iva_mmnn,
                                     0);
        end if;
      
        if v_movi_iva_mone = 0 then
          v_porc_iva5_mone := 0;
        else
          v_porc_iva5_mone := round((v_movi_iva5_mone * 100) /
                                    v_movi_iva_mone,
                                    0);
        end if;
      
        if v_movi_iva_mmnn = 0 then
          v_porc_iva5_mmnn := 0;
        else
          v_porc_iva5_mmnn := round((v_movi_iva5_mmnn * 100) /
                                    v_movi_iva_mmnn,
                                    0);
        end if;
      
        if (v_porc_iva10_mone + v_porc_iva5_mone) <> 100 then
          if v_porc_iva10_mone > v_porc_iva5_mone then
            v_porc_iva10_mone := v_porc_iva10_mone +
                                 (100 -
                                 (v_porc_iva10_mone + v_porc_iva5_mone));
            v_porc_iva10_mmnn := v_porc_iva10_mmnn +
                                 (100 -
                                 (v_porc_iva10_mmnn + v_porc_iva5_mmnn));
          else
            v_porc_iva5_mone := v_porc_iva5_mone + (100 - (v_porc_iva10_mone +
                                v_porc_iva5_mone));
            v_porc_iva5_mmnn := v_porc_iva5_mmnn + (100 - (v_porc_iva10_mmnn +
                                v_porc_iva5_mmnn));
          end if;
        end if;
      
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'El documento con clave ' || p_movi_codi ||
                                  ' no existe!.');
        
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    
      ---notas de creditos aplicadas a la factura
      for x in c_impu(p_movi_codi) loop
        begin
          select nvl(sum(mc.canc_impo_mone), 0) canc_impo_mone,
                 nvl(sum(mc.canc_impo_mmnn), 0) canc_impo_mmnn
            into v_canc_impo_mone, v_canc_impo_mmnn
            from come_movi_cuot_canc mc,
                 (select m.movi_codi
                    from come_movi m,
                         (select cc.canc_movi_codi
                            from come_movi_cuot_canc cc
                           where cc.canc_cuot_movi_codi in
                                 (select mo.movi_codi
                                    from come_movi mo
                                   where mo.movi_timo_codi in (11, 17))
                           group by cc.canc_movi_codi) canc_nc
                   where m.movi_codi_padr = canc_nc.canc_movi_codi
                   group by m.movi_codi) canc
           where mc.canc_movi_codi = canc.movi_codi
             and mc.canc_cuot_movi_codi = p_movi_codi;
        
          v_porc_impu      := x.impu_porc;
          v_porc_base_impo := x.impu_porc_base_impo;
          v_indi_baim_impu := x.impu_indi_baim_impu_incl;
        
          if v_porc_impu = 10 then
            v_canc_impo_mone := round((v_canc_impo_mone * v_porc_iva10_mone) / 100,
                                      0);
            v_canc_impo_mmnn := round((v_canc_impo_mmnn * v_porc_iva10_mmnn) / 100,
                                      0);
          elsif v_porc_impu = 5 then
            v_canc_impo_mone := round((v_canc_impo_mone * v_porc_iva5_mone) / 100,
                                      0);
            v_canc_impo_mmnn := round((v_canc_impo_mmnn * v_porc_iva5_mmnn) / 100,
                                      0);
          end if;
        
          pa_devu_impo_calc(v_canc_impo_mone,
                            v_mone_cant_deci,
                            v_porc_impu,
                            v_porc_base_impo,
                            v_indi_baim_impu,
                            v_nc_canc_impo_mone,
                            v_nc_grav10_mone_ii,
                            v_nc_grav5_mone_ii,
                            v_nc_grav10_mone,
                            v_nc_grav5_mone,
                            v_nc_movi_iva10_mone,
                            v_nc_movi_iva5_mone,
                            v_nc_movi_exen_mone);
        
          v_nc_movi_grav_mone := v_nc_grav10_mone + v_nc_grav5_mone;
          v_nc_movi_iva_mone  := v_nc_movi_iva10_mone + v_nc_movi_iva5_mone;
        
          pa_devu_impo_calc(v_canc_impo_mmnn,
                            v_mone_cant_deci,
                            v_porc_impu,
                            v_porc_base_impo,
                            v_indi_baim_impu,
                            v_nc_canc_impo_mmnn,
                            v_nc_grav10_mmnn_ii,
                            v_nc_grav5_mmnn_ii,
                            v_nc_grav10_mmnn,
                            v_nc_grav5_mmnn,
                            v_nc_movi_iva10_mmnn,
                            v_nc_movi_iva5_mmnn,
                            v_nc_movi_exen_mmnn);
        
          v_nc_movi_grav_mmnn := v_nc_grav10_mmnn + v_nc_grav5_mmnn;
          v_nc_movi_iva_mmnn  := v_nc_movi_iva10_mmnn + v_nc_movi_iva5_mmnn;
        
        exception
          when no_data_found then
            v_nc_movi_exen_mmnn  := 0;
            v_nc_movi_grav_mmnn  := 0;
            v_nc_movi_iva_mmnn   := 0;
            v_nc_movi_exen_mone  := 0;
            v_nc_movi_grav_mone  := 0;
            v_nc_movi_iva_mone   := 0;
            v_nc_movi_iva10_mone := 0;
            v_nc_movi_iva5_mone  := 0;
            v_nc_movi_iva10_mmnn := 0;
            v_nc_movi_iva5_mmnn  := 0;
            v_nc_canc_impo_mmnn  := 0;
            v_nc_grav10_mmnn_ii  := 0;
            v_nc_grav5_mmnn_ii   := 0;
            v_nc_grav10_mmnn     := 0;
            v_nc_grav5_mmnn      := 0;
            v_nc_canc_impo_mone  := 0;
            v_nc_grav10_mone_ii  := 0;
            v_nc_grav5_mone_ii   := 0;
            v_nc_grav10_mone     := 0;
            v_nc_grav5_mone      := 0;
          
          when others then
            raise_application_error(-20001, sqlerrm);
        end;
        ------------********--------------
        v_movi_exen_mmnn  := v_movi_exen_mmnn - v_nc_movi_exen_mmnn;
        v_movi_grav_mmnn  := v_movi_grav_mmnn - v_nc_movi_grav_mmnn;
        v_movi_iva_mmnn   := v_movi_iva_mmnn - v_nc_movi_iva_mmnn;
        v_movi_exen_mone  := v_movi_exen_mone - v_nc_movi_exen_mone;
        v_movi_grav_mone  := v_movi_grav_mone - v_nc_movi_grav_mone;
        v_movi_iva_mone   := v_movi_iva_mone - v_nc_movi_iva_mone;
        v_movi_iva10_mone := v_movi_iva10_mone - v_nc_movi_iva10_mone;
        v_movi_iva5_mone  := v_movi_iva5_mone - v_nc_movi_iva5_mone;
        v_movi_iva10_mmnn := v_movi_iva10_mmnn - v_nc_movi_iva10_mmnn;
        v_movi_iva5_mmnn  := v_movi_iva5_mmnn - v_nc_movi_iva5_mmnn;
      end loop;
    else
      v_movi_codi_rete  := null;
      v_movi_exen_mmnn  := nvl(p_tota_mmnn, 0) - nvl(p_impo_mmnn, 0) -
                           nvl(p_iva_mmnn, 0);
      v_movi_grav_mmnn  := nvl(p_impo_mmnn, 0);
      v_movi_iva_mmnn   := nvl(p_iva_mmnn, 0);
      v_movi_exen_mone  := nvl(p_tota_mone, 0) - nvl(p_impo_mone, 0) -
                           nvl(p_iva_mone, 0);
      v_movi_grav_mone  := nvl(p_impo_mone, 0);
      v_movi_iva_mone   := nvl(p_iva_mone, 0);
      v_mone_cant_deci  := p_cant_deci;
      v_movi_iva10_mone := nvl(p_iva10_mone, 0);
      v_movi_iva10_mmnn := nvl(p_iva10_mmnn, 0);
      v_movi_iva5_mone  := nvl(p_iva5_mone, 0);
      v_movi_iva5_mmnn  := nvl(p_iva5_mmnn, 0);
    end if;
  
    v_imp_min_aplic_reten    := to_number(fl_busca_parametro('p_imp_min_aplic_reten'));
    v_porc_aplic_reten       := to_number(fl_busca_parametro('p_porc_aplic_reten'));
    v_porc_aplic_reten_iva10 := to_number(fl_busca_parametro('p_porc_aplic_reten_iva10'));
    v_porc_aplic_reten_iva5  := to_number(fl_busca_parametro('p_porc_aplic_reten_iva5'));
    v_indi_porc_rete_sucu    := ltrim(rtrim(fl_busca_parametro('p_indi_porc_rete_sucu')));
    v_cant_deci_mmnn         := to_number(fl_busca_parametro('p_cant_deci_mmnn'));
  
    if upper(nvl(v_indi_porc_rete_sucu, upper('n'))) = upper('s') then
      begin
        select s.sucu_porc_rete
          into v_porc_aplic_reten
          from come_sucu s
         where s.sucu_codi = p_sucu_codi
           and s.sucu_empr_codi = p_empr_codi;
      
        if v_porc_aplic_reten is null then
          raise_application_error(-20001,
                                  'Se debe configurar el parametro porcentaje de retencion ' ||
                                  'a ser aplicado en la sucursal ' ||
                                  p_sucu_codi);
        end if;
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'La sucursal ' || p_sucu_codi ||
                                  ' no existe!.');
        when others then
          raise_application_error(-20001, sqlerrm);
      end;
    end if;
  
    if v_imp_min_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_IMP_MIN_APLIC_RETEN ' ||
                              'con el importe minimo para aplicar retenciones');
    end if;
  
    if v_porc_aplic_reten is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_PORC_APLIC_RETEN ' ||
                              'con el porcentaje de retencion a ser aplicado');
    end if;
  
    if v_porc_aplic_reten_iva10 is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_PORC_APLIC_RETEN_IVA10 ' ||
                              'con el porcentaje de retencion a ser aplicado');
    end if;
  
    if v_porc_aplic_reten_iva5 is null then
      raise_application_error(-20001,
                              'Se debe configurar el parametro P_PORC_APLIC_RETEN_IVA5 ' ||
                              'con el porcentaje de retencion a ser aplicado');
    end if;
  
    if upper(nvl(v_empr_retentora, 'no')) = upper('no') or
       v_movi_codi_rete is not null or
       upper(nvl(p_apli_rete, 's')) = upper('n') then
      v_impo_rete_mone := 0;
      v_impo_rete_mmnn := 0;
    
      p_rete_mone := v_impo_rete_mone;
      p_rete_mmnn := v_impo_rete_mmnn;
    
      raise salir;
    end if;
  
    --v_impo_vali := nvl(v_movi_grav_mmnn, 0);
    v_impo_vali := p_tota_mmnn;
  
    if v_impo_vali >= v_imp_min_aplic_reten or p_apli_rete_impo_mini = 'S' then
      if p_movi_codi is not null then
        begin
          select sum(more_impo_mone) impo_rete_mone,
                 sum(more_impo_mmnn) impo_rete_mmnn
            into v_impo_retenido_mone, v_impo_retenido_mmnn
            from come_movi_rete a
           where more_movi_codi = p_movi_codi;
        end;
      end if;
    
      v_impo_rete_mmnn := round((nvl(v_movi_iva10_mmnn, 0) *
                                nvl(v_porc_aplic_reten_iva10, 0) / 100),
                                v_cant_deci_mmnn) +
                          round((nvl(v_movi_iva5_mmnn, 0) *
                                nvl(v_porc_aplic_reten_iva5, 0) / 100),
                                v_cant_deci_mmnn);
    
      v_impo_rete_mmnn := nvl(v_impo_rete_mmnn, 0) -
                          nvl(v_impo_retenido_mmnn, 0);
    
      v_impo_rete_mone := round((nvl(v_movi_iva10_mone, 0) *
                                nvl(v_porc_aplic_reten_iva10, 0) / 100),
                                v_mone_cant_deci) +
                          round((nvl(v_movi_iva5_mone, 0) *
                                nvl(v_porc_aplic_reten_iva5, 0) / 100),
                                v_mone_cant_deci);
    
      v_impo_rete_mone := nvl(v_impo_rete_mone, 0) -
                          nvl(v_impo_retenido_mone, 0);
    
    else
      v_impo_rete_mmnn := 0;
      v_impo_rete_mone := 0;
    end if;
  
    p_rete_mone := v_impo_rete_mone;
    p_rete_mmnn := v_impo_rete_mmnn;
  
  exception
    when salir then
      null;
  end pl_calc_rete_cien_tesa_v2;

  --el objetivo de este procedimiento es validar que el usuario posea el........
  --permiso correspondiente para operar con un deposito determintado............
  --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
  --de seguridad, que esta por debajo del nivel de pantallas....................

  function fl_vali_user_depo_orig(p_depo_codi in number) return boolean is
    v_depo_codi number;
  begin
    select udor_depo_codi
      into v_depo_codi
      from segu_user, segu_user_depo_orig
     where user_codi = udor_user_codi
       and upper(rtrim(ltrim(user_login))) = upper(fp_user)
       and udor_depo_codi = p_depo_codi;
  
    return true;
  
  exception
    when no_data_found then
      return false;
    when others then
      raise_application_error(-20010, sqlerrm);
  end fl_vali_user_depo_orig;

  --el objetivo de este procedimiento es validar que el usuario posea el........
  --permiso correspondiente para operar con un deposito determintado............
  --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
  --de seguridad, que esta por debajo del nivel de pantallas....................

  function fl_vali_user_depo_dest(p_depo_codi in number) return boolean is
    v_depo_codi number;
  begin
    select udes_depo_codi
      into v_depo_codi
      from segu_user, segu_user_depo_dest
     where user_codi = udes_user_codi
       and upper(rtrim(ltrim(user_login))) = upper(fp_user)
       and udes_depo_codi = p_depo_codi;
  
    return true;
  
  exception
    when no_data_found then
      return false;
    when others then
      raise_application_error(-20010, sqlerrm);
  end fl_vali_user_depo_dest;

  procedure pl_muestra_come_mone(p_mone_codi      in number,
                                 p_mone_desc      out char,
                                 p_mone_desc_abre out char,
                                 p_mone_cant_deci out number) is
  begin
    select mone_desc, mone_desc_abre, mone_cant_deci
      into p_mone_desc, p_mone_desc_abre, p_mone_cant_deci
      from come_mone
     where mone_codi = p_mone_codi;
  exception
    when no_data_found then
      p_mone_desc := null;
      raise_application_error(-20010, 'Moneda Inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al buscar detalles de moneda!. ' ||
                              sqlerrm);
    
  end pl_muestra_come_mone;

  procedure pl_muestra_come_depo(p_codi_depo in number,
                                 p_codi_sucu out number,
                                 p_desc_depo out char,
                                 p_desc_sucu out char) is
  
  begin
  
    select sucu_desc, sucu_codi, depo_desc
      into p_desc_sucu, p_codi_sucu, p_desc_depo
      from come_depo, come_sucu
     where depo_sucu_codi = sucu_codi
       and depo_codi = p_codi_depo;
  
  exception
    when no_data_found then
      p_desc_depo := null;
      p_desc_sucu := null;
      p_codi_sucu := null;
    
      raise_application_error(-20010, 'Deposito inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al buscar deposito!. ' || sqlerrm);
  end pl_muestra_come_depo;

  procedure pl_muestra_come_stoc_oper(p_oper_codi      in number,
                                      p_oper_desc      out varchar2,
                                      p_oper_desc_abre out varchar2,
                                      p_suma_rest      out varchar2,
                                      p_afec_cost_prom out varchar2) is
  begin
    select oper_desc,
           oper_desc_abre,
           oper_stoc_suma_rest,
           oper_stoc_afec_cost_prom
      into p_oper_desc, p_oper_desc_abre, p_suma_rest, p_afec_cost_prom
      from come_stoc_oper
     where oper_codi = p_oper_codi;
  exception
    when no_data_found then
      raise_application_error(-20010, 'Operacion de Stock Inexistente!');
    when others then
      raise_application_error(-20010, sqlerrm);
  end pl_muestra_come_stoc_oper;

  procedure pl_muestra_come_conc(p_conc_codi in number,
                                 p_conc_desc out varchar2,
                                 p_conc_dbcr out varchar2) is
  begin
    select conc_desc, conc_dbcr
      into p_conc_desc, p_conc_dbcr
      from come_conc
     where conc_codi = p_conc_codi;
  
  exception
    when no_data_found then
      p_conc_desc := null;
      p_conc_dbcr := null;
      raise_application_error(-20010, 'Concepto Inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al buscar Concepto.! ' || sqlerrm);
    
  end pl_muestra_come_conc;

  procedure pl_muestra_come_impu(p_impu_codi           in number,
                                 p_impu_desc           out varchar2,
                                 p_impu_porc           out number,
                                 p_impu_porc_base_impo out number) is
  begin
    select impu_desc, impu_porc, impu_porc_base_impo
      into p_impu_desc, p_impu_porc, p_impu_porc_base_impo
      from come_impu
     where impu_codi = p_impu_codi;
  
  exception
    when no_data_found then
      p_impu_desc           := null;
      p_impu_porc           := null;
      p_impu_porc_base_impo := null;
      raise_application_error(-20010, 'Impuesto inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al buscae Impuesto.! ' || sqlerrm);
  end pl_muestra_come_impu;

  --el objetivo de este procedimiento es validar que el usuario posea el........
  --permiso correspondiente para insertar o anular una operacion de stock......
  --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
  --de seguridad, que esta por debajo del nivl de pantallas.....................

  procedure pl_vali_user_stoc_oper(p_oper_codi  in number,
                                   p_indi_si_no out char) is
    v_oper_codi number;
  begin
  
    select usop_oper_codi
      into v_oper_codi
      from segu_user, segu_user_stoc_oper
     where user_codi = usop_user_codi
       and upper(rtrim(ltrim(user_login))) = upper(fp_user)
       and usop_oper_codi = p_oper_codi;
  
    p_indi_si_no := 'S';
  
  exception
    when no_data_found then
      p_indi_si_no := 'N'; --no tiene habilitado
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end;

  --el objetivo de este procedimiento es validar que el usuario posea el........
  --permiso correspondiente para insertar o anular un tipo de movimiento dado...
  --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
  --de seguridad, que esta por debajo del nivl de pantallas.....................

  procedure pl_vali_user_tipo_movi(p_timo_codi  in number,
                                   p_indi_si_no out char) is
    v_timo_codi number;
  begin
  
    select usmo_timo_codi
      into v_timo_codi
      from segu_user, segu_user_tipo_movi
     where user_codi = usmo_user_codi
       and upper(rtrim(ltrim(user_login))) = upper(fp_user)
       and usmo_timo_codi = p_timo_codi;
  
    p_indi_si_no := 'S';
  
  exception
    when no_data_found then
      p_indi_si_no := 'N'; --no tiene habilitado
    when others then
      raise_application_error(-20010, sqlerrm);
    
  end;

  ----------------- funcion para retornar numero formateados -------------------
  function pl_form_nume(i_nume in number, i_cant_deci in number)
    return number is
  
    v_nume number;
  begin
  
    if i_cant_deci = 0 then
    
      --select to_char(i_nume, '') from dual;
    
      select to_number(i_nume,
                       '9999999999999D9999',
                       'NLS_NUMERIC_CHARACTERS='',.''')
        into v_nume
        from dual;
    
    end if;
  
    return v_nume;
  
  end pl_form_nume;

  function fl_conv_nro_txt(v_numero in number) return varchar2 is
    v_texto varchar2(1000) := null;
    v_milm  number;
    v_mill  number;
    v_mile  number;
    v_cent  number;
  
    v_num_ent_txt varchar2(13);
    v_num_dec_txt varchar2(20);
    v_num_dec     number;
  begin
  
    if v_numero = 0 then
      return 'CERO';
    end if;
  
    /*    if v_numero > 999999999 then
        return 'numero es muy grande';
    end if;*/
    --cambiado por eitel el 6-05-2001
    if v_numero > 999999999999 then
      return 'NUMERO ES MUY GRANDE';
    end if;
  
    -- antes v_num_ent_txt := lpad(to_char(trunc(v_numero)),10,'0');
    v_num_ent_txt := lpad(to_char(trunc(v_numero)), 13, '0');
  
    /* hallar la parte milmillon?sima de v_num_ent_txt */
    v_milm := to_number(substr(v_num_ent_txt, 2, 3));
    if v_milm > 0 then
      pl_conv_nro_tres_dig(v_texto, lpad(to_char(v_milm), 3, '0'), ' MIL');
    end if;
  
    /* hallar la parte millon?sima de v_num_ent_txt */
    v_mill := to_number(substr(v_num_ent_txt, 5, 3));
    if v_mill > 0 then
      pl_conv_nro_tres_dig(v_texto,
                           lpad(to_char(v_mill), 3, '0'),
                           ' MILLON');
      if v_mill > 1 or v_milm > 0 then
        v_texto := v_texto || 'ES';
      end if;
    end if;
  
    /* hallar la parte mil?sima de v_num_ent_txt */
    v_mile := to_number(substr(v_num_ent_txt, 8, 3));
    if v_mile > 0 then
      pl_conv_nro_tres_dig(v_texto, lpad(to_char(v_mile), 3, '0'), ' MIL');
    end if;
  
    /* hallar la parte cent?sima de v_num_ent_txt */
    v_cent := to_number(substr(v_num_ent_txt, 11, 3));
    if v_cent > 0 then
      pl_conv_nro_tres_dig(v_texto, lpad(to_char(v_cent), 3, '0'), null);
      if upper(substr(v_texto, nvl(length(v_texto), 0) - 1, 2)) = 'UN' then
        v_texto := v_texto || 'O';
      end if;
    end if;
  
    /* hallar la parte de los decimales */
    v_num_dec := v_numero - trunc(v_numero);
    if v_num_dec = 0 then
      return v_texto;
    else
      v_texto := v_texto || ' CON ';
    end if;
    v_num_dec_txt := to_char(v_num_dec);
    if nvl(length(v_num_dec_txt), 0) = 2 then
      v_texto := v_texto || substr(v_num_dec_txt, 2, 1) || '/10';
    elsif nvl(length(v_num_dec_txt), 0) = 3 then
      v_texto := v_texto || substr(v_num_dec_txt, 2, 2) || '/100';
    elsif nvl(length(v_num_dec_txt), 0) = 4 then
      v_texto := v_texto || substr(v_num_dec_txt, 2, 3) || '/1000';
    else
      v_texto := v_texto || substr(v_num_dec_txt, 2, 4) || '/10000';
    end if;
  
    return v_texto;
  
  end fl_conv_nro_txt;

  procedure pl_conv_nro_tres_dig(v_texto  in out varchar2,
                                 v_numero in varchar2,
                                 v_param  in varchar2) is
  
    v_cent number;
    v_deci number;
    v_unit number;
  
  begin
    v_cent := to_number(substr(v_numero, 1, 1)); --v_cent = digito centecimal
    if nvl(v_cent, 0) > 0 then
      pl_conv_nro_centenas(v_texto, v_cent);
    end if;
    if v_cent = 1 and to_number(v_numero) > 100 then
      v_texto := v_texto || 'TO';
    end if;
    v_unit := 0;
    v_deci := to_number(substr(v_numero, 2, 1)); --v_deci = digito decimal
    if v_deci = 1 or v_deci = 2 then
      pl_conv_nro_unit(v_texto, to_number(substr(v_numero, 2, 2)));
    else
      if v_deci > 0 then
        pl_conv_nro_decimas(v_texto, v_deci);
      end if;
      v_unit := to_number(substr(v_numero, 3, 1));
      if v_unit > 0 then
        if v_deci > 2 then
          v_texto := v_texto || ' Y';
        end if;
        pl_conv_nro_unit(v_texto, v_unit);
      end if;
    end if;
    if v_param is not null then
      v_texto := v_texto || v_param;
    end if;
  
  end;
  procedure pl_conv_nro_agregar_txt(v_texto_old in out varchar2,
                                    v_texto_new in varchar2) is
  begin
    if v_texto_old is null then
      v_texto_old := v_texto_new;
    else
      v_texto_old := v_texto_old || ' ' || v_texto_new;
    end if;
  end pl_conv_nro_agregar_txt;

  procedure pl_conv_nro_centenas(v_texto in out varchar2, v_nro in number) is
  begin
    if v_nro = 1 then
      pl_conv_nro_agregar_txt(v_texto, 'CIEN');
    elsif v_nro = 2 then
      pl_conv_nro_agregar_txt(v_texto, 'DOSCIENTOS');
    elsif v_nro = 3 then
      pl_conv_nro_agregar_txt(v_texto, 'TRESCIENTOS');
    elsif v_nro = 4 then
      pl_conv_nro_agregar_txt(v_texto, 'CUATROCIENTOS');
    elsif v_nro = 5 then
      pl_conv_nro_agregar_txt(v_texto, 'QUINIENTOS');
    elsif v_nro = 6 then
      pl_conv_nro_agregar_txt(v_texto, 'SEISCIENTOS');
    elsif v_nro = 7 then
      pl_conv_nro_agregar_txt(v_texto, 'SETECIENTOS');
    elsif v_nro = 8 then
      pl_conv_nro_agregar_txt(v_texto, 'OCHOCIENTOS');
    elsif v_nro = 9 then
      pl_conv_nro_agregar_txt(v_texto, 'NOVECIENTOS');
    end if;
  end pl_conv_nro_centenas;

  procedure pl_conv_nro_unit(v_texto in out varchar2, v_nro in number) is
  begin
    if v_nro = 1 then
      pl_conv_nro_agregar_txt(v_texto, 'UN');
    elsif v_nro = 2 then
      pl_conv_nro_agregar_txt(v_texto, 'DOS');
    elsif v_nro = 3 then
      pl_conv_nro_agregar_txt(v_texto, 'TRES');
    elsif v_nro = 4 then
      pl_conv_nro_agregar_txt(v_texto, 'CUATRO');
    elsif v_nro = 5 then
      pl_conv_nro_agregar_txt(v_texto, 'CINCO');
    elsif v_nro = 6 then
      pl_conv_nro_agregar_txt(v_texto, 'SEIS');
    elsif v_nro = 7 then
      pl_conv_nro_agregar_txt(v_texto, 'SIETE');
    elsif v_nro = 8 then
      pl_conv_nro_agregar_txt(v_texto, 'OCHO');
    elsif v_nro = 9 then
      pl_conv_nro_agregar_txt(v_texto, 'NUEVE');
    elsif v_nro = 10 then
      pl_conv_nro_agregar_txt(v_texto, 'DIEZ');
    elsif v_nro = 11 then
      pl_conv_nro_agregar_txt(v_texto, 'ONCE');
    elsif v_nro = 12 then
      pl_conv_nro_agregar_txt(v_texto, 'DOCE');
    elsif v_nro = 13 then
      pl_conv_nro_agregar_txt(v_texto, 'TRECE');
    elsif v_nro = 14 then
      pl_conv_nro_agregar_txt(v_texto, 'CATORCE');
    elsif v_nro = 15 then
      pl_conv_nro_agregar_txt(v_texto, 'QUINCE');
    elsif v_nro = 16 then
      pl_conv_nro_agregar_txt(v_texto, 'DIECISEIS');
    elsif v_nro = 17 then
      pl_conv_nro_agregar_txt(v_texto, 'DIECISIETE');
    elsif v_nro = 18 then
      pl_conv_nro_agregar_txt(v_texto, 'DIECIOCHO');
    elsif v_nro = 19 then
      pl_conv_nro_agregar_txt(v_texto, 'DIECINUEVE');
    elsif v_nro = 20 then
      pl_conv_nro_agregar_txt(v_texto, 'VEINTE');
    elsif v_nro = 21 then
      pl_conv_nro_agregar_txt(v_texto, 'VEINTIUN');
    elsif v_nro = 22 then
      pl_conv_nro_agregar_txt(v_texto, 'VEINTIDOS');
    elsif v_nro = 23 then
      pl_conv_nro_agregar_txt(v_texto, 'VEINTITRES');
    elsif v_nro = 24 then
      pl_conv_nro_agregar_txt(v_texto, 'VEINTICUATRO');
    elsif v_nro = 25 then
      pl_conv_nro_agregar_txt(v_texto, 'VEINTICINCO');
    elsif v_nro = 26 then
      pl_conv_nro_agregar_txt(v_texto, 'VEINTISEIS');
    elsif v_nro = 27 then
      pl_conv_nro_agregar_txt(v_texto, 'VEINTISIETE');
    elsif v_nro = 28 then
      pl_conv_nro_agregar_txt(v_texto, 'VEINTIOCHO');
    elsif v_nro = 29 then
      pl_conv_nro_agregar_txt(v_texto, 'VEINTINUEVE');
    end if;
  end;

  procedure pl_conv_nro_decimas(v_texto in out varchar2, v_nro in number) is
  begin
    if v_nro = 1 then
      pl_conv_nro_agregar_txt(v_texto, 'DIEZ');
    elsif v_nro = 2 then
      pl_conv_nro_agregar_txt(v_texto, 'VEINTE');
    elsif v_nro = 3 then
      pl_conv_nro_agregar_txt(v_texto, 'TREINTA');
    elsif v_nro = 4 then
      pl_conv_nro_agregar_txt(v_texto, 'CUARENTA');
    elsif v_nro = 5 then
      pl_conv_nro_agregar_txt(v_texto, 'CINCUENTA');
    elsif v_nro = 6 then
      pl_conv_nro_agregar_txt(v_texto, 'SESENTA');
    elsif v_nro = 7 then
      pl_conv_nro_agregar_txt(v_texto, 'SETENTA');
    elsif v_nro = 8 then
      pl_conv_nro_agregar_txt(v_texto, 'OCHENTA');
    elsif v_nro = 9 then
      pl_conv_nro_agregar_txt(v_texto, 'NOVENTA');
    end if;
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
  
  Exception
    when no_data_found then
      p_cuen_desc := null;
      p_banc_codi := null;
      p_banc_desc := null;
      --pl_mostrar_error ('Cuenta Bancaria Inexistente');
  
    when others then
      raise_application_error(-20010,
                              'Error al buscar Cuenta Bancaria! ' ||
                              sqlerrm);
  end pl_muestra_come_cuen_banc;

  function fl_vali_user_cuen_banc_cons(p_cuen_codi in number) return boolean is
    --El objetivo de este procedimiento es validar que el usuario posea el........
    --permiso correspondiente para una consultar una caja determintada...
    --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
    --de seguridad, que est? por debajo del nivl de pantallas.....................
    v_cuen_codi number;
  begin
  
    select uscb_cuen_codi
      into v_cuen_codi
      from segu_user, segu_user_cuen_banc
     where user_codi = uscb_user_codi
       and upper(rtrim(ltrim(user_login))) = upper(fp_user)
       and uscb_cuen_Codi = p_cuen_codi;
  
    return true;
  
  Exception
    When no_data_found then
      return false;
    when others then
      raise_application_error(-20010,
                              'Error al validar usuario! ' || sqlerrm);
  end fl_vali_user_cuen_banc_cons;

  procedure pl_muestra_come_tipo_movi(p_timo_codi      in number,
                                      p_timo_Desc      out char,
                                      p_timo_Desc_abre out char,
                                      p_timo_afec_sald out char,
                                      p_timo_dbcr      out char) is
  
  begin
  
    select timo_desc, timo_desc_abre, timo_afec_sald, timo_dbcr
      into p_timo_desc, p_timo_desc_abre, p_timo_afec_sald, p_timo_dbcr
      from come_tipo_movi
     where timo_codi = p_timo_codi;
  
  Exception
    when no_data_found then
      p_timo_desc_abre := null;
      p_timo_desc      := null;
      p_timo_afec_sald := null;
      p_timo_dbcr      := null;
    
      raise_application_error(-20010, 'Tipo de Movimiento Inexistente!');
    when others then
      raise_application_error(-20010,
                              'Error al buscar Tipo de Movimiento! ' ||
                              sqlerrm);
    
  end pl_muestra_come_tipo_movi;

  --El objetivo de este procedimiento es validar que el usuario posea el........ 
  --permiso correspondiente para transferir una caja determintada a otra...
  --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
  --de seguridad, que est? por debajo del nivl de pantallas.....................

  function fl_vali_user_cuen_banc_cred(p_cuen_codi in number,
                                       p_fech      in date default sysdate,
                                       p_fech_oper in date default sysdate)
    return boolean is
    v_cuen_codi      number;
    v_indi_cier_caja varchar2(1);
  begin
    select uc.usco_cuen_codi, c.cuen_indi_cier_caja
      into v_cuen_codi, v_indi_cier_caja
      from segu_user u, segu_user_cuen_orig uc, come_cuen_banc c
     where u.user_codi = uc.usco_user_codi
       and upper(rtrim(ltrim(u.user_login))) = upper(fp_user)
       and usco_cuen_codi = p_cuen_codi
       and uc.usco_cuen_codi = c.cuen_codi;
  
    pl_vali_cier_caja(p_cuen_codi, p_fech, v_indi_cier_caja);
    pl_vali_cier_caja_oper(p_cuen_codi, p_fech_oper);
  
    return true;
  
  exception
    when no_data_found then
      return false;
    
    when others then
      raise_application_error(-20010, sqlerrm);
  end;
  procedure pl_vali_cier_caja(p_cuen_codi      in number,
                              p_fech           in date default sysdate,
                              p_indi_cier_caja in char) is
    v_cant      number;
    v_cant_movi number;
    v_hora_oper date;
    v_hora_sist date;
  
    v_indi_vali_cier_caja varchar2(30);
    v_cant_cier_caja      number := 0;
  begin
  
    v_indi_vali_cier_caja := ltrim(rtrim(fl_busca_parametro('p_indi_vali_cier_caja')));
    v_cant_cier_caja      := ltrim(rtrim(fl_busca_parametro('p_cant_cier_caja')));
  
    if nvl(upper(v_indi_vali_cier_caja), 'N') = 'S' then
      if p_indi_cier_caja = 'S' then
        --Verifica si existe cierre de caja para el dia anterior
        select count(*)
          into v_cant
          from come_cier_caja c
         where c.caja_cuen_codi = p_cuen_codi
           and c.caja_fech = trunc(p_fech) - 1;
      
        select count(*)
          into v_cant_movi
          from come_movi, come_movi_impo_deta
         where moim_movi_codi = movi_codi
           and moim_cuen_codi = p_cuen_codi
           and moim_fech_oper = trunc(p_fech) - 1;
      
        if v_cant = 0 then
          -- No existe cierre de caja para la fecha
          select count(*)
            into v_cant
            from come_movi m
           where m.movi_cuen_codi = p_cuen_codi
             and m.movi_fech_oper = trunc(p_fech) - 1;
        
          if v_cant <> 0 then
            -- Existen movimientos del dia anterior
            v_hora_oper := to_date('09:00:00', 'hh24:mi:ss');
            v_hora_sist := to_date(to_char(sysdate, 'hh24:mi:ss'),
                                   'hh24:mi:ss');
          
            if v_hora_sist > v_hora_oper and v_cant_movi > 0 then
              -- Si la hora paso las 9 de la ma?ana
              raise_application_error(-20010,
                                      'No se puede realizar operaciones hasta realizar el cierre de Caja ' ||
                                      p_cuen_codi || ' de fecha ' ||
                                      to_char((trunc(p_fech) - 1),
                                              'dd-mm-yyyy')); --'del dia anterior');
            end if;
          
          end if;
        
        end if;
      end if;
    end if;
  end;

  procedure pl_vali_cier_caja_oper(p_cuen_codi in number,
                                   p_fech      in date default sysdate) is
    v_cant      number;
    v_hora_oper date;
    v_hora_sist date;
  
    v_indi_vali_cier_caja varchar2(30);
    v_cant_cier_caja      number := 0;
  begin
  
    v_indi_vali_cier_caja := ltrim(rtrim(fl_busca_parametro('p_indi_vali_cier_caja')));
    v_cant_cier_caja      := ltrim(rtrim(fl_busca_parametro('p_cant_cier_caja')));
  
    if nvl(upper(v_indi_vali_cier_caja), 'N') = 'S' then
      --Verifica si existe cierre en la fecha que se quiere cargar el movimiento.
      select count(*)
        into v_cant
        from come_cier_caja c
       where c.caja_cuen_codi = p_cuen_codi
         and c.caja_fech = trunc(p_fech);
    
      if v_cant > 0 and v_cant >= v_cant_cier_caja then
        -- Si ya se realizaron todos los cierres correspondientes, no debe permitir ingresar mas movimientos.      
        raise_application_error(-20010,
                                'No se puede realizar operaciones en esta caja. Existe(n) ' ||
                                v_cant ||
                                ' cierre(s) de caja para la fecha de operaci?n cargada.');
      end if;
    end if;
  end;

  procedure pl_exhibir_error_plsql is
  
    v_message varchar2(200);
  begin
    v_message := 'Error ora: ' || sqlcode || ' - ' || sqlerrm;
    raise_application_error(-20001, v_message);
  
  end pl_exhibir_error_plsql;

  -------------------------------------
  --El objetivo de este procedimiento es validar que el usuario posea el........ 
  --permiso correspondiente para transferir una caja determintada a otra...
  --independientemente de la pantalla en la q se encuentre, es solo otro nivel..
  --de seguridad, que est? por debajo del nivl de pantallas.....................

  function fl_vali_user_cuen_banc_debi(p_cuen_codi in number,
                                       p_fech      in date default sysdate,
                                       p_fech_oper in date default sysdate)
    return boolean is
    v_cuen_codi      number;
    v_indi_cier_caja varchar2(1);
  begin
    select uc.uscd_cuen_codi, c.cuen_indi_cier_caja
      into v_cuen_codi, v_indi_cier_caja
      from segu_user u, segu_user_cuen_dest uc, come_cuen_banc c
     where u.user_codi = uc.uscd_user_codi
       and upper(rtrim(ltrim(u.user_login))) = upper(fp_user)
       and uc.uscd_cuen_Codi = p_cuen_codi
       and uc.uscd_cuen_codi = c.cuen_codi;
  
    --valida si existe cierre en el dia anterior.
    pl_vali_cier_caja(p_cuen_codi, p_fech, v_indi_cier_caja);
  
    pl_vali_cier_caja_oper(p_cuen_codi, p_fech_oper);
  
    return true;
  
  Exception
    When no_data_found then
      return false;
    when others then
      pl_exhibir_error_plsql;
  end fl_vali_user_cuen_banc_debi;

end general_skn;
