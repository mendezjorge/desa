
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010346" is


 g_come_movi      come_movi%rowtype;

  type r_parameter is record(
    p_empr_codi number := 1,
    p_codi_base number := pack_repl.fa_devu_codi_base,
    ----parametro de cliente
    p_etiq_clpr_vat            varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_etiq_clpr_vat'))),
    p_indi_bloq_camp_clie      varchar2(2) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_bloq_camp_clie'))),
    p_codi_situ_clie_defe      number := to_number(general_skn.fl_busca_parametro('p_codi_situ_clie_defe')),
    p_cant_deci_mmnn           number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmnn')),
    p_cant_deci_mmee           number := to_number(general_skn.fl_busca_parametro('p_cant_deci_mmee')),
    p_codi_impu_exen           number := to_number(general_skn.fl_busca_parametro('p_codi_impu_exen')),
    p_codi_mone_dola           number := to_number(general_skn.fl_busca_parametro('p_codi_mone_dola')),
    p_indi_perm_timo_bole      varchar2(20) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_perm_timo_bole'))),
    p_codi_tipo_empl_vend      number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_vend')),
    p_codi_tipo_empl_mark      number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_mark')),
    p_codi_tipo_empl_recl      number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_recl')),
    p_indi_tabla_gene_cuot     varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_tabla_gene_cuot'))),
    p_codi_conc_info_cobr      number := to_number(general_skn.fl_busca_parametro('p_codi_conc_info_cobr')),
    p_codi_form_pago_defa      number := to_number(general_skn.fl_busca_parametro('p_codi_form_pago_defa')),
    p_indi_obli_form_pago      varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_obli_form_pago'))),
    p_indi_most_form_pago      varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_most_form_pago'))),
    p_codi_impu_info_cobr      varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_codi_impu_info_cobr'))),
    p_codi_conc_pago_prov      number := to_number(general_skn.fl_busca_parametro('p_codi_conc_pago_prov')),
    p_codi_timo_rere           number := to_number(general_skn.fl_busca_parametro('p_codi_timo_rere')),
    p_indi_modi_auto_tele_clie varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_modi_auto_tele_clie'))),
    p_peco_codi               number := 1,
    
    ---cliente
    p_para_inic     varchar2(2) := 'C',
    p_emit_reci     varchar2(2) := 'E',
    p_clie_prov     varchar2(2) := 'C',
    p_codi_conc     number := to_number(general_skn.fl_busca_parametro('p_codi_conc_cobr_clie')),
    p_codi_timo     number := to_number(general_skn.fl_busca_parametro('p_codi_timo_reem')),
    p_codi_oper_vta number := to_number(general_skn.fl_busca_parametro('p_codi_oper_vta')),
    p_codi_oper     number := to_number(general_skn.fl_busca_parametro('p_codi_oper_vta')),
    
    p_codi_mone_mmnn      number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn')),
    p_cant_deci_cant      number := to_number(general_skn.fl_busca_parametro('p_cant_deci_cant')),
    p_codi_timo_pcoe      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_pcoe')),
    p_codi_tipo_empl_cobr number := to_number(general_skn.fl_busca_parametro('p_codi_tipo_empl_cobr')),
    p_codi_timo_pcre      number := to_number(general_skn.fl_busca_parametro('p_codi_timo_pcre')));

  parameter r_parameter;

  procedure pp_cargar_nomb_apel(p_clpr_desc in varchar2,
                                p_clpr_nomb out varchar2,
                                p_clpr_apel out varchar2) is
    v_cant number := 0;
    v_posi number := 1;
  
  begin
  
    loop
      if (instr(p_clpr_desc, ' ', v_posi)) <> 0 then
        v_cant := v_cant + 1;
        v_posi := (instr(p_clpr_desc, ' ', v_posi) + 1);
      else
        v_posi := 0;
      end if;
    
      exit when v_posi = 0;
    end loop;
  
    if v_cant in (1, 2) then
      p_clpr_nomb := substr(p_clpr_desc, 1, instr(p_clpr_desc, ' ', 1) - 1);
      p_clpr_apel := substr(p_clpr_desc,
                            (instr(p_clpr_desc, ' ', 1) + 1),
                            100);
    elsif v_cant = 3 or v_cant > 3 then
      p_clpr_nomb := substr(p_clpr_desc, 1, instr(p_clpr_desc, ' ', 1) - 1) || ' ' ||
                     substr(p_clpr_desc,
                            (instr(p_clpr_desc, ' ', 1) + 1),
                            (instr(p_clpr_desc,
                                   ' ',
                                   instr(p_clpr_desc, ' ', 1) + 1)) -
                            ((instr(p_clpr_desc, ' ', 1) + 1)));
    
      p_clpr_apel := substr(p_clpr_desc,
                            (instr(p_clpr_desc,
                                   ' ',
                                   instr(p_clpr_desc, ' ', 1) + 1) + 1),
                            100);
    end if;
  
  end pp_cargar_nomb_apel;

  procedure pp_mostrar_refe_tra(p_clpr_codi           in number,
                                p_clpr_luga_trab      out varchar2,
                                p_clpr_pues_trab      out varchar2,
                                p_clpr_dire_trab      out varchar2,
                                p_clpr_anti           out varchar2,
                                p_clpr_ciud_codi      out varchar2,
                                p_clpr_barr_codi      out varchar2,
                                p_clpr_nomb_cony      out varchar2,
                                p_clpr_tele_cony      out varchar2,
                                p_clpr_cedu_cony      out varchar2,
                                p_clpr_acti_cony      out varchar2,
                                p_clpr_luga_trab_cony out varchar2,
                                p_clpr_naci_codi_cony out varchar2,
                                p_clpr_esta_civi_cony out varchar2) is
  begin
    select clpr_luga_trab,
           clpr_pues_trab,
           clpr_dire_trab,
           clpr_anti,
           clpr_ciud_codi,
           clpr_barr_codi,
           clpr_nomb_cony,
           clpr_tele_cony,
           clpr_cedu_cony,
           clpr_acti_cony,
           clpr_luga_trab_cony,
           clpr_naci_codi_cony,
           clpr_esta_civi_cony
      into p_clpr_luga_trab,
           p_clpr_pues_trab,
           p_clpr_dire_trab,
           p_clpr_anti,
           p_clpr_ciud_codi,
           p_clpr_barr_codi,
           p_clpr_nomb_cony,
           p_clpr_tele_cony,
           p_clpr_cedu_cony,
           p_clpr_acti_cony,
           p_clpr_luga_trab_cony,
           p_clpr_naci_codi_cony,
           p_clpr_esta_civi_cony
      from come_clie_prov_dato c
     where c.clpr_codi = p_clpr_codi;
  exception
    when others then
      null;
    
  end pp_mostrar_refe_tra;

  procedure predelete(p_clpr_codi in number) is
  begin
  
    /*update come_clie_prov set clpr_base = :parameter.p_codi_base
    where clpr_codi = p_clpr_codi;--*/
  
    begin
    
      delete from come_clie_refe c where c.clre_clpr_codi = p_clpr_codi;
    
      delete from come_clie_refe c where c.clre_clpr_codi = p_clpr_codi;
    
      delete from come_clie_refe c where c.clre_clpr_codi = p_clpr_codi;
    
      delete from come_clie_ingr_egre c
       where c.ineg_clpr_codi = p_clpr_codi;
    
      delete from come_clie_prov_imag c
       where c.cpim_clpr_codi = p_clpr_codi;
    
      delete from come_info c where c.info_clpr_codi = p_clpr_codi;
    
      delete from come_info c where c.info_clpr_codi = p_clpr_codi;
    
      delete from come_clpr_sub_cuen c
       where c.sucu_clpr_codi = p_clpr_codi;
    
      delete from come_clie_cuen c where c.clcu_clpr_codi = p_clpr_codi;
    
      delete from come_clie_prov_dato c where c.clpr_codi = p_clpr_codi;
    
    end;
  
  end predelete;

  procedure pp_valida(p_clpr_nomb            in varchar2,
                      p_clpr_ruc             in varchar2,
                      p_naci_codi_alte       in varchar2,
                      p_clpr_dire            in varchar2,
                      p_clpr_tele            in varchar2,
                      p_clpr_clie_clas1_codi in varchar2) is
  begin
  
    if p_clpr_nomb is null then
      raise_application_error(-20001,
                              'Debe Ingresar el Nombre del Cliente!');
    end if;
    if p_clpr_ruc is null then
      raise_application_error(-20001,
                              'Debe Ingresar el Nro. de Documento del Cliente!');
    end if;
    if p_naci_codi_alte is null then
      raise_application_error(-20001, 'Debe ingresar la nacionalidad');
    end if;
    if p_clpr_dire is null then
      raise_application_error(-20001,
                              'Debe Ingresar la direcci?n del Cliente!');
    end if;
    if p_clpr_tele is null then
      raise_application_error(-20001,
                              'Debe Ingresar n?mero telef?nico del Cliente!');
    end if;
    if p_clpr_clie_clas1_codi is null then
      raise_application_error(-20001,
                              'Debe Ingresar una Clasificaci?n para el Cliente!');
    end if;
  
  end pp_valida;

  procedure pp_carga_secu(p_secu_clie out number) is
  begin
  
    p_secu_clie := to_number(general_skn.fl_busca_parametro('p_secu_nume_clie')) + 1;
   update come_para
 set para_valo = p_secu_clie
 where upper(para_nomb) = upper('p_secu_nume_clie');
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Codigo de Secuencia de cliente inexistente ....');
    
  end pp_carga_secu;

  procedure pp_actu_secu(p_clpr_codi in number, p_clpr_codi_alte in number) is
  begin
  
    if p_clpr_codi is null then
      update come_para
         set para_valo = p_clpr_codi_alte
       where ltrim(rtrim(upper(para_nomb))) = upper('p_secu_nume_clie');
    
    end if;
  
  end pp_actu_secu;

  procedure pp_insert_dato_extra(p_clpr_codi           in number,
                                 p_clpr_inmu_prop      in varchar2,
                                 p_clpr_nomb_cony      in varchar2,
                                 p_clpr_nume_finc      in varchar2,
                                 p_clpr_luga_trab      in varchar2,
                                 p_clpr_tele_trab      in varchar2,
                                 p_clpr_anti           in varchar2,
                                 p_clpr_pues_trab      in varchar2,
                                 p_clpr_tele_cony      in varchar2,
                                 p_clpr_cedu_cony      in varchar2,
                                 p_clpr_acti_cony      in varchar2,
                                 p_clpr_luga_trab_cony in varchar2,
                                 p_clpr_dire_trab      in varchar2,
                                 p_clpr_ciud_trab      in varchar2,
                                 p_clpr_barr_codi      in varchar2,
                                 p_clpr_ciud_codi      in varchar2,
                                 p_clpr_esta_civi_cony in varchar2,
                                 p_clpr_naci_codi_cony in varchar2) is
  begin
  
    update come_clie_prov_dato
       set clpr_inmu_prop      = p_clpr_inmu_prop,
           clpr_nume_finc      = p_clpr_nume_finc,
           clpr_luga_trab      = p_clpr_luga_trab,
           clpr_tele_trab      = p_clpr_tele_trab,
           clpr_anti           = p_clpr_anti,
           clpr_pues_trab      = p_clpr_pues_trab,
           clpr_nomb_cony      = fa_pasa_capital(p_clpr_nomb_cony),
           clpr_tele_cony      = p_clpr_tele_cony,
           clpr_cedu_cony      = p_clpr_cedu_cony,
           clpr_acti_cony      = p_clpr_acti_cony,
           clpr_luga_trab_cony = p_clpr_luga_trab_cony,
           clpr_dire_trab      = p_clpr_dire_trab,
           clpr_ciud_trab      = p_clpr_ciud_trab,
           clpr_barr_codi      = p_clpr_barr_codi,
           clpr_ciud_codi      = p_clpr_ciud_codi,
           clpr_esta_civi_cony = p_clpr_esta_civi_cony,
           clpr_naci_codi_cony = p_clpr_naci_codi_cony
     where clpr_codi = p_clpr_codi;
  
    if sql%rowcount = 0 then
      insert into come_clie_prov_dato
        (clpr_codi,
         clpr_inmu_prop,
         clpr_nume_finc,
         clpr_luga_trab,
         clpr_tele_trab,
         clpr_anti,
         clpr_pues_trab,
         clpr_nomb_cony,
         clpr_tele_cony,
         clpr_cedu_cony,
         clpr_acti_cony,
         clpr_luga_trab_cony,
         clpr_dire_trab,
         clpr_ciud_trab,
         clpr_barr_codi,
         clpr_ciud_codi,
         clpr_esta_civi_cony,
         clpr_naci_codi_cony)
      values
        (p_clpr_codi,
         p_clpr_inmu_prop,
         p_clpr_nume_finc,
         p_clpr_luga_trab,
         p_clpr_tele_trab,
         p_clpr_anti,
         p_clpr_pues_trab,
         fa_pasa_capital(p_clpr_nomb_cony),
         p_clpr_tele_cony,
         p_clpr_cedu_cony,
         p_clpr_acti_cony,
         p_clpr_luga_trab_cony,
         p_clpr_dire_trab,
         p_clpr_ciud_trab,
         p_clpr_barr_codi,
         p_clpr_ciud_codi,
         p_clpr_esta_civi_cony,
         p_clpr_naci_codi_cony);
    end if;
  
  end pp_insert_dato_extra;

  procedure pp_cargar_vehiculo(p_vehi_codi      in number,
                               p_vehi_tive_codi out varchar2,
                               p_vehi_mave_codi out varchar2,
                               p_vehi_mode      out varchar2,
                               p_vehi_anho      out varchar2,
                               p_vehi_colo      out varchar2,
                               p_vehi_nume_chas out varchar2,
                               p_vehi_nume_pate out varchar2,
                               p_vehi_iden_ante out varchar2,
                               p_vehi_esta      out varchar2,
                               p_vehi_esta_vehi out varchar2,
                               p_vehi_esta_ante out varchar2) is
  begin
    select --vehi_iden,
     vehi_tive_codi,
     vehi_mave_codi,
     vehi_mode,
     vehi_anho,
     vehi_colo,
     vehi_nume_chas,
     vehi_nume_pate,
     vehi_iden_ante,
     vehi_esta,
     vehi_esta_vehi
      into p_vehi_tive_codi,
           p_vehi_mave_codi,
           p_vehi_mode,
           p_vehi_anho,
           p_vehi_colo,
           p_vehi_nume_chas,
           p_vehi_nume_pate,
           p_vehi_iden_ante,
           p_vehi_esta,
           p_vehi_esta_vehi
      from come_vehi
     where vehi_codi = p_vehi_codi;
    p_vehi_esta_ante := p_vehi_esta;
  exception
    when no_data_found then
      raise_application_error(-20001, 'Veh?culo Inexistente');
    
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_cargar_vehiculo;

  procedure pp_atualizar_vehi(p_vehi_codi      in number,
                              p_vehi_tive_codi in number,
                              p_vehi_mave_codi in number,
                              p_vehi_mode      in varchar2,
                              p_vehi_anho      in varchar2,
                              p_vehi_colo      in varchar2,
                              p_vehi_nume_chas in varchar2,
                              p_vehi_nume_pate in varchar2,
                              p_vehi_iden_ante in varchar2,
                              p_vehi_esta      in varchar2,
                              p_vehi_esta_vehi in varchar2,
                              p_vehi_esta_ante in varchar2) is
  begin
  
    if p_vehi_codi is not null then
      pp_veri_nume_chas(p_vehi_codi,
                        p_vehi_nume_chas,
                        p_vehi_esta,
                        p_vehi_esta_ante);
    
      update come_vehi
         set --vehi_iden  = p_vehi_iden, 
             vehi_tive_codi = p_vehi_tive_codi,
             vehi_mave_codi = p_vehi_mave_codi,
             vehi_mode      = p_vehi_mode,
             vehi_anho      = p_vehi_anho,
             vehi_colo      = p_vehi_colo,
             vehi_nume_chas = p_vehi_nume_chas,
             vehi_nume_pate = p_vehi_nume_pate,
             vehi_iden_ante = p_vehi_iden_ante,
             vehi_esta      = p_vehi_esta,
             vehi_esta_vehi = p_vehi_esta_vehi
       where vehi_codi = p_vehi_codi;
    end if;
  end pp_atualizar_vehi;

  procedure pp_veri_nume_chas(p_vehi_codi      in number,
                              p_vehi_nume_chas in varchar2,
                              p_vehi_esta      in varchar2,
                              p_vehi_esta_ant  in varchar2) is
  
    v_count       number := 0;
    v_sose_nume   number;
    v_clpr_codi   varchar2(200);
    v_sose_numero varchar2(200);
  
    cursor c_come_vehi is
      select s.sose_nume, clpr_codi_alte
        from come_vehi                v,
             come_soli_serv_anex_deta d,
             come_soli_serv_anex      a,
             come_soli_serv           s,
             come_clie_prov           c
       where v.vehi_codi = d.deta_vehi_codi
         and d.deta_anex_codi = a.anex_codi
         and a.anex_sose_codi = s.sose_codi
         and s.sose_clpr_codi = c.clpr_codi
         and v.vehi_esta <> 'D'
         and d.deta_esta_vehi <> 'D'
         and v.vehi_nume_chas = p_vehi_nume_chas;
  
  begin
    select count(*)
      into v_count
      from come_vehi v
     where vehi_codi <> p_vehi_codi
          
       and v.vehi_alar_id is null
       and v.vehi_esta <> 'D'
       and upper(ltrim(rtrim(vehi_nume_chas))) =
           upper(ltrim(rtrim(p_vehi_nume_chas)));
  
    if v_count > 0 then
      if p_vehi_nume_chas <> 'S/D' then
        select s.sose_nume
          into v_sose_nume
          from come_vehi                v,
               come_soli_serv_anex_deta d,
               come_soli_serv_anex      a,
               come_soli_serv           s
         where v.vehi_codi = d.deta_vehi_codi
           and d.deta_anex_codi = a.anex_codi
           and a.anex_sose_codi = s.sose_codi
           and v.vehi_esta <> 'D'
           and d.deta_esta_vehi <> 'D'
           and v.vehi_nume_chas = p_vehi_nume_chas;
      
        if p_vehi_esta_ant = 'D' then
          if p_vehi_esta in ('I', 'P') then
            raise_application_error(-20001,
                                    'No se puede actualizar datos del vehiculo,la serie de Chasis Nro ' ||
                                    p_vehi_nume_chas ||
                                    ' ya existe para un vehiculo en la Solicitud Nro ' ||
                                    v_sose_nume || ', favor verifique.');
          end if;
        else
          raise_application_error(-20001,
                                  'No se puede actualizar datos del vehiculo,la serie de Chasis Nro ' ||
                                  p_vehi_nume_chas ||
                                  ' ya existe para un vehiculo en la Solicitud Nro ' ||
                                  v_sose_nume || ', favor verifique.');
        end if;
      
      end if;
    end if;
  
  exception
    when too_many_rows then
    
      for x in c_come_vehi loop
        v_sose_numero := v_sose_numero || x.sose_nume || ' / ';
        v_clpr_codi   := v_clpr_codi || x.clpr_codi_alte || ' / ';
      end loop;
    
      raise_application_error(-20001,
                              'Nro de chasis duplicado en las solicitudes nros ' ||
                              v_sose_numero || ' de los clientes ' ||
                              v_clpr_codi);
    
    when no_data_found then
      null;
    
  end;

  procedure pp_eliminar_vehi(p_vehi_codi in number) is
  
    v_count number := 0;
  begin
    if p_vehi_codi is not null then
      select count(deta_vehi_codi)
        into v_count
        from come_soli_serv_anex_deta
       where deta_vehi_codi = p_vehi_codi;
      if v_count > 0 then
        raise_application_error(-20001,
                                'Existe(n) ' || v_count ||
                                ' detalle(s) en anexo relacionado(s) al veh?culo.');
      end if;
      v_count := 0;
      select count(ortr_vehi_codi)
        into v_count
        from come_orde_trab
       where ortr_vehi_codi = p_vehi_codi;
      if v_count > 0 then
        raise_application_error(-20001,
                                'Existe(n) ' || v_count ||
                                ' ?rden(es) de Trabajo relacionado(s) al veh?culo.');
      end if;
    
      delete from come_vehi where vehi_codi = p_vehi_codi;
    end if;
  end pp_eliminar_vehi;

  procedure pp_actualizar_fac_pago(p_fapa_clpr_codi           in number,
                                   p_fapa_codi                in number,
                                   p_fapa_nomb_pago           in varchar2,
                                   p_fapa_tele_pago           in varchar2,
                                   p_fapa_celu_pago           in varchar2,
                                   p_fapa_emai_pago           in varchar2,
                                   p_fapa_nomb_fact           in varchar2,
                                   p_fapa_tele_fact           in varchar2,
                                   p_fapa_celu_fact           in varchar2,
                                   p_fapa_emai_fact           in varchar2,
                                   p_fapa_conf_emai_fact      in varchar2,
                                   p_fapa_dire_emai_fact      in varchar2,
                                   p_fapa_refe_dire_fact      in varchar2,
                                   p_fapa_dia_tope_fact       in varchar2,
                                   p_fapa_form_impr_fact      in varchar2,
                                   p_fapa_excl_vali_sose_poli in varchar2,
                                   p_fapa_empr_codi           in varchar2) is
  begin
  
    if p_fapa_codi is null then
      ---insert
      if (p_fapa_nomb_pago is not null or p_fapa_nomb_fact is not null) then
      
        insert into come_clie_fact_pago
          (fapa_codi,
           fapa_clpr_codi,
           fapa_nomb_pago,
           fapa_tele_pago,
           fapa_celu_pago,
           fapa_emai_pago,
           fapa_nomb_fact,
           fapa_tele_fact,
           fapa_celu_fact,
           fapa_emai_fact,
           fapa_conf_emai_fact,
           fapa_dire_emai_fact,
           fapa_refe_dire_fact,
           fapa_dia_tope_fact,
           fapa_form_impr_fact,
           fapa_indi_excl_vali_sose_poli,
           fapa_user_regi,
           fapa_fech_regi,
           fapa_empr_codi,
           fapa_base)
        values
          (fa_sec_come_clie_fact_pago,
           p_fapa_clpr_codi,
           p_fapa_nomb_pago,
           p_fapa_tele_pago,
           p_fapa_celu_pago,
           p_fapa_emai_pago,
           p_fapa_nomb_fact,
           p_fapa_tele_fact,
           p_fapa_celu_fact,
           p_fapa_emai_fact,
           p_fapa_conf_emai_fact,
           p_fapa_dire_emai_fact,
           p_fapa_refe_dire_fact,
           p_fapa_dia_tope_fact,
           p_fapa_form_impr_fact,
           p_fapa_excl_vali_sose_poli,
           fa_user,
           sysdate,
           p_fapa_empr_codi,
           1);
      end if;
    else
      ----update
    
      update come_clie_fact_pago
         set fapa_nomb_pago                = p_fapa_nomb_pago,
             fapa_tele_pago                = p_fapa_tele_pago,
             fapa_celu_pago                = p_fapa_celu_pago,
             fapa_emai_pago                = p_fapa_emai_pago,
             fapa_nomb_fact                = p_fapa_nomb_fact,
             fapa_tele_fact                = p_fapa_tele_fact,
             fapa_celu_fact                = p_fapa_celu_fact,
             fapa_emai_fact                = p_fapa_emai_fact,
             fapa_conf_emai_fact           = p_fapa_conf_emai_fact,
             fapa_dire_emai_fact           = p_fapa_dire_emai_fact,
             fapa_refe_dire_fact           = p_fapa_refe_dire_fact,
             fapa_dia_tope_fact            = p_fapa_dia_tope_fact,
             fapa_form_impr_fact           = p_fapa_form_impr_fact,
             fapa_indi_excl_vali_sose_poli = p_fapa_excl_vali_sose_poli,
             fapa_user_modi                = fa_user,
             fapa_fech_modi                = sysdate
       where fapa_codi = p_fapa_codi;
    
    end if;
  
    -----
    update come_clie_prov
       set clpr_email_fact               = p_fapa_emai_fact,
           clpr_dia_tope_fact            = p_fapa_dia_tope_fact,
           clpr_form_impr_fact           = p_fapa_form_impr_fact,
           clpr_indi_excl_vali_sose_poli = p_fapa_excl_vali_sose_poli
     where clpr_codi = p_fapa_clpr_codi;
  
  exception
    when others then
      raise_application_error(-20001,
                              'Error en pp_actualizar_fac_pago ' || sqlerrm);
    
  end pp_actualizar_fac_pago;

  procedure pp_actu_soli_serv_cont(p_clpr_codi      in number,
                                   p_cont_apel      in varchar2,
                                   p_cont_emai      in varchar2,
                                   p_cont_pass      in varchar2,
                                   p_cont_nume_docu in varchar2,
                                   p_cont_vinc      in varchar2,
                                   p_cont_nume_item in varchar2,
                                   p_cont_sose_codi in varchar2) is
    --v_cont_sose_codi number(20);
    v_count     number;
    v_sose_codi number;
    v_indi_soli varchar2(2);
  
  begin
  
    select count(*), max(s.sose_codi) sose_codi
      into v_count, v_sose_codi
      from come_soli_serv s, come_clie_prov c
     where s.sose_clpr_codi = c.clpr_codi
       and c.clpr_indi_clie_prov = 'C'
       and c.clpr_codi = p_clpr_codi;
  
    if v_count > 0 then
      v_indi_soli := 'S';
    else
      v_indi_soli := 'N';
    end if;
  
    if v_indi_soli = 'S' then
      delete from come_soli_serv_cont
       where cont_sose_codi = v_sose_codi
         and cont_tipo = 'H';
    
      if p_cont_apel is not null then
        insert into come_soli_serv_cont
          (cont_sose_codi,
           cont_nume_item,
           cont_apel,
           cont_nomb,
           cont_vinc,
           cont_nume_docu,
           cont_pass,
           cont_emai,
           cont_tipo)
        values
          (v_sose_codi,
           p_cont_nume_item,
           p_cont_apel,
           p_cont_apel,
           p_cont_vinc,
           p_cont_nume_docu,
           p_cont_pass,
           p_cont_emai,
           'H');
      end if;
    end if;
  
  end pp_actu_soli_serv_cont;

  procedure pp_actu_soli_serv_clie_refe(p_sose_codi in number,
                                        p_indi_tipo in varchar2,
                                        p_clpr_codi in number) is
  
    v_refe_indi_dato varchar2(1);
    v_refe_tipo      varchar2(1);
    v_refe_desc      varchar2(100);
  
    v_sose_codi number(20);
  
  begin
  
    delete from come_soli_serv_refe where refe_sose_codi = p_sose_codi;
  
    for i in (select *
                from come_clie_refe f
               where f.clre_clpr_codi = p_clpr_codi
                 and clre_tipo = 'P') loop
      if i.clre_desc is not null then
        v_sose_codi := p_sose_codi;
      
        v_refe_indi_dato := 'D';
        v_refe_tipo      := 'P';
        v_refe_desc      := fa_pasa_capital(i.clre_desc);
      
        insert into come_soli_serv_refe
          (refe_sose_codi,
           refe_nume_item,
           refe_indi_dato,
           refe_tipo,
           refe_desc,
           refe_tele)
        values
          (p_sose_codi,
           i.clre_nume_item,
           v_refe_indi_dato,
           v_refe_tipo,
           v_refe_desc,
           i.clre_tele);
      
      end if;
    end loop;
  
  end pp_actu_soli_serv_clie_refe;

  procedure pp_actu_dato_soli(p_clpr_codi        in number,
                              p_clpr_desc        in varchar2,
                              p_clpr_nomb        in varchar2,
                              p_clpr_apel        in varchar2,
                              p_clpr_tipo_docu   in varchar2,
                              p_clpr_ruc         in varchar2,
                              p_clpr_esta_civi   in varchar2,
                              p_clpr_fech_naci   in varchar2,
                              p_clpr_dire        in varchar2,
                              p_clpr_refe_dire   in varchar2,
                              p_clpr_prop_carg_2 in varchar2,
                              p_clpr_prop_docu_2 in varchar2,
                              p_clpr_prop_nomb_2 in varchar2,
                              p_clpr_prop_docu   in varchar2,
                              p_clpr_prop_nomb   in varchar2,
                              p_clpr_barr_codi   in varchar2,
                              p_clpr_ciud_codi   in varchar2,
                              p_clpr_zona_codi   in varchar2,
                              p_clpr_naci_codi   in varchar2,
                              p_clpr_mepa_codi   in number,
                              p_clpr_email_fact  in varchar2,
                              p_clpr_email       in varchar2,
                              p_clpr_tele        in varchar2) is
    v_indi_soli varchar2(1) := 'N';
    v_sose_codi number;
    v_count     number := 0;
  
  begin
  
    select count(*), max(s.sose_codi) sose_codi
      into v_count, v_sose_codi
      from come_soli_serv s, come_clie_prov c
     where s.sose_clpr_codi = c.clpr_codi
       and c.clpr_indi_clie_prov = 'C'
       and c.clpr_codi = p_clpr_codi;
  
    if v_count > 0 then
      v_indi_soli := 'S';
    else
      v_indi_soli := 'N';
    end if;
  
    if v_indi_soli = 'S' then
      pp_actu_serv_clie_dato(v_sose_codi,
                             p_clpr_desc,
                             p_clpr_nomb,
                             p_clpr_apel,
                             p_clpr_tipo_docu,
                             p_clpr_ruc,
                             p_clpr_esta_civi,
                             p_clpr_fech_naci,
                             p_clpr_dire,
                             p_clpr_refe_dire,
                             p_clpr_prop_carg_2,
                             p_clpr_prop_docu_2,
                             p_clpr_prop_nomb_2,
                             p_clpr_prop_docu,
                             p_clpr_prop_nomb,
                             p_clpr_barr_codi,
                             p_clpr_ciud_codi,
                             p_clpr_zona_codi,
                             p_clpr_naci_codi,
                             p_clpr_mepa_codi,
                             p_clpr_email_fact,
                             p_clpr_email,
                             p_clpr_tele);
    end if;
  
    if v_indi_soli = 'S' then
      pp_actu_soli_serv_clie_refe(v_sose_codi, 'P', p_clpr_codi);
    end if;
  
  exception
    when others then
      raise_application_error(-20001,
                              'No se puedo actualizar los datos de las directivas');
  end pp_actu_dato_soli;

  procedure pp_actu_serv_clie_dato(p_sose_sodi        in number,
                                   p_clpr_desc        in varchar2,
                                   p_clpr_nomb        in varchar2,
                                   p_clpr_apel        in varchar2,
                                   p_clpr_tipo_docu   in varchar2,
                                   p_clpr_ruc         in varchar2,
                                   p_clpr_esta_civi   in varchar2,
                                   p_clpr_fech_naci   in varchar2,
                                   p_clpr_dire        in varchar2,
                                   p_clpr_refe_dire   in varchar2,
                                   p_clpr_prop_carg_2 in varchar2,
                                   p_clpr_prop_docu_2 in varchar2,
                                   p_clpr_prop_nomb_2 in varchar2,
                                   p_clpr_prop_docu   in varchar2,
                                   p_clpr_prop_nomb   in varchar2,
                                   p_clpr_barr_codi   in varchar2,
                                   p_clpr_ciud_codi   in varchar2,
                                   p_clpr_zona_codi   in varchar2,
                                   p_clpr_naci_codi   in varchar2,
                                   p_clpr_mepa_codi   in number,
                                   p_clpr_email_fact  in varchar2,
                                   p_clpr_email       in varchar2,
                                   p_clpr_tele        in varchar2) is
  
  begin
  
    update come_soli_serv_clie_dato
       set sose_desc        = p_clpr_desc,
           sose_nomb        = p_clpr_nomb,
           sose_apel        = p_clpr_apel,
           sose_tipo_docu   = p_clpr_tipo_docu,
           sose_docu        = p_clpr_ruc,
           sose_esta_civi   = p_clpr_esta_civi,
           sose_fech_naci   = p_clpr_fech_naci,
           sose_dire        = p_clpr_dire,
           sose_tele_part   = p_clpr_tele,
           sose_email       = p_clpr_email,
           sose_email_fact  = p_clpr_email_fact,
           sose_mepa_codi   = p_clpr_mepa_codi,
           sose_naci_codi   = p_clpr_naci_codi,
           sose_zona_codi   = p_clpr_zona_codi,
           sose_ciud_codi   = p_clpr_ciud_codi,
           sose_barr_codi   = p_clpr_barr_codi,
           sose_prop_nomb   = p_clpr_prop_nomb,
           sose_prop_docu   = p_clpr_prop_docu,
           sose_prop_nomb_2 = p_clpr_prop_nomb_2,
           sose_prop_docu_2 = p_clpr_prop_docu_2,
           sose_prop_carg_2 = p_clpr_prop_carg_2,
           sose_refe_dire   = p_clpr_refe_dire
     where sose_codi = p_sose_sodi;
  
  end pp_actu_serv_clie_dato;

  procedure pp_mostrar_fac_pag(p_fapa_clpr_codi           in number,
                               p_fapa_codi                out number,
                               p_fapa_nomb_pago           out varchar2,
                               p_fapa_tele_pago           out varchar2,
                               p_fapa_celu_pago           out varchar2,
                               p_fapa_emai_pago           out varchar2,
                               p_fapa_nomb_fact           out varchar2,
                               p_fapa_tele_fact           out varchar2,
                               p_fapa_celu_fact           out varchar2,
                               p_fapa_emai_fact           out varchar2,
                               p_fapa_conf_emai_fact      out varchar2,
                               p_fapa_dire_emai_fact      out varchar2,
                               p_fapa_refe_dire_fact      out varchar2,
                               p_fapa_dia_tope_fact       out varchar2,
                               p_fapa_form_impr_fact      out varchar2,
                               p_fapa_excl_vali_sose_poli out varchar2,
                               p_fapa_user_modi           out varchar2,
                               p_fapa_fech_modi           out varchar2,
                               p_fapa_user_regi           out varchar2,
                               p_fapa_fech_regi           out varchar2,
                               p_fapa_empr_codi           out varchar2,
                               p_fapa_base                out varchar2) is
  begin
  
    select fapa_codi,
           fapa_nomb_pago,
           fapa_tele_pago,
           fapa_celu_pago,
           fapa_emai_pago,
           fapa_nomb_fact,
           fapa_tele_fact,
           fapa_celu_fact,
           fapa_emai_fact,
           fapa_conf_emai_fact,
           fapa_dire_emai_fact,
           fapa_refe_dire_fact,
           fapa_dia_tope_fact,
           fapa_form_impr_fact,
           fapa_indi_excl_vali_sose_poli,
           fapa_user_modi,
           fapa_fech_modi,
           fapa_user_regi,
           fapa_fech_regi,
           fapa_empr_codi,
           fapa_base
      into p_fapa_codi,
           p_fapa_nomb_pago,
           p_fapa_tele_pago,
           p_fapa_celu_pago,
           p_fapa_emai_pago,
           p_fapa_nomb_fact,
           p_fapa_tele_fact,
           p_fapa_celu_fact,
           p_fapa_emai_fact,
           p_fapa_conf_emai_fact,
           p_fapa_dire_emai_fact,
           p_fapa_refe_dire_fact,
           p_fapa_dia_tope_fact,
           p_fapa_form_impr_fact,
           p_fapa_excl_vali_sose_poli,
           p_fapa_user_modi,
           p_fapa_fech_modi,
           p_fapa_user_regi,
           p_fapa_fech_regi,
           p_fapa_empr_codi,
           p_fapa_base
      from come_clie_fact_pago
     where fapa_clpr_codi = p_fapa_clpr_codi;
  exception
    when others then
      null;
    
  end pp_mostrar_fac_pag;

  procedure pp_cargar_imagen(p_img            in varchar2,
                             p_cpim_clpr_codi in number,
                             p_cpim_requ_codi in number,
                             p_cpim_nume_item in number) is
    v_archivo blob;
  begin
  
    begin
      select blob_content --, mime_type, filename
        into v_archivo --,v_mime_type, v_filename
        from apex_application_temp_files a
       where a.name = p_img
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    update come_clie_prov_imag
       set cpim_requ_codi = p_cpim_requ_codi,
           cpim_imagen    = v_archivo,
           cpim_user_modi = fa_user,
           cpim_fech_modi = sysdate
     where cpim_clpr_codi = p_cpim_clpr_codi
       and cpim_nume_item = p_cpim_nume_item;
  
    if sql%rowcount = 0 then
      insert into come_clie_prov_imag
        (cpim_clpr_codi,
         cpim_nume_item,
         cpim_requ_codi,
         cpim_imagen,
         cpim_fecha,
         cpim_user_regi,
         cpim_fech_regi)
      values
        (p_cpim_clpr_codi,
         (select max(nvl(cpim_nume_item, 0)) + 1
            from come_clie_prov_imag
           where cpim_clpr_codi = p_cpim_clpr_codi),
         p_cpim_requ_codi,
         v_archivo,
         sysdate,
         fa_user,
         sysdate);
    end if;
  exception
    when others then
      raise_application_error(-20001, 'Error ' || sqlerrm);
    
  end pp_cargar_imagen;
  
  procedure pp_mostrar_info(p_info_codi in number,
                          p_info_fech_oper out varchar2,
                          p_info_tipo_oper out varchar2,
                          p_info_obse out varchar2,
                          p_info_mone_codi out varchar2,
                          p_info_impo out varchar2,
                          p_info_user_regi out varchar2,
                          p_info_user_modi out varchar2,
                          p_info_codi_alte out varchar2,
                          p_info_fech_modi out varchar2,
                          p_info_fech_regi out varchar2) is
                         
  begin
select info_fech_oper,
       info_tipo_oper,
       info_obse,
       info_mone_codi,
       info_impo,
       info_user_regi,
       info_user_modi,
       info_codi_alte,
       info_fech_modi,
       info_fech_regi
       
  into 
       p_info_fech_oper,
       p_info_tipo_oper,
       p_info_obse,
       p_info_mone_codi,
       p_info_impo,
       p_info_user_regi,
       p_info_user_modi,
       p_info_codi_alte,
       p_info_fech_modi,
       p_info_fech_regi
  from come_info
 where info_codi = p_info_codi;
 end pp_mostrar_info;

  
 

procedure pp_actualizar_info(p_info_clpr_codi  in number,
                             p_info_fech_oper in date,
                             p_info_tipo_oper in varchar2,
                             p_info_obse in varchar2,
                             p_info_mone_codi in number,
                             p_info_impo in number,
                             p_info_codi_alte in number,
                             p_info_codi in number,
                             p_info_empr_codi in number) is
                            
begin
update come_info
   set 
       info_clpr_codi = p_info_clpr_codi,
       info_fech_oper = p_info_fech_oper,
       info_tipo_oper = p_info_tipo_oper,
       info_obse = p_info_obse,
       info_mone_codi = p_info_mone_codi,
       info_impo = p_info_impo,
       info_user_modi = fa_user,
       info_codi_alte = p_info_codi_alte,
       info_empr_codi = p_info_empr_codi,
       info_base = 1,
       info_fech_modi = sysdate
 where info_codi = p_info_codi;


if sql%rowcount = 0 then
insert into come_info
  (info_codi,
   info_clpr_codi,
   info_fech_oper,
   info_tipo_oper,
   info_obse,
   info_mone_codi,
   info_impo,
   info_user_regi,
   info_codi_alte,
   info_empr_codi,
   info_base,
   info_fech_regi
   )
values
  (( SELECT NVL(MAX(to_number(info_codi)),0)+1
	 FROM come_info
	 where info_empr_codi = p_info_empr_codi),
   p_info_clpr_codi,
   p_info_fech_oper,
   p_info_tipo_oper,
   p_info_obse,
   p_info_mone_codi,
   p_info_impo,
   fa_user,
   ( SELECT NVL(MAX(to_number(info_codi_alte)),0)+1
	 FROM come_info
	 where info_empr_codi = p_info_empr_codi),
   p_info_empr_codi,
   1,
   sysdate);
   
   end if;
   end  pp_actualizar_info;
   
   
   

  --------gastos administrativo---------

  procedure pp_muestra_tipo_movi_inte(p_movi_timo_codi           in number,
                                      p_movi_timo_desc           out varchar2,
                                      p_movi_afec_sald           out varchar2,
                                      p_movi_emit_reci           out varchar2,
                                      p_s_timo_calc_iva          out varchar2,
                                      p_movi_oper_codi           out varchar2,
                                      p_movi_dbcr                out varchar2,
                                      p_timo_tica_codi           out number,
                                      p_timo_indi_caja           out varchar2,
                                      p_tico_codi                out number,
                                      p_tico_fech_rein           out varchar2,
                                      p_timo_indi_apli_adel_fopa out varchar2,
                                      p_tico_indi_vali_nume      out varchar2,
                                      p_timo_dbcr_caja           out varchar2) is
  
  begin
    select timo_desc,
           timo_afec_sald,
           timo_emit_reci,
           nvl(timo_calc_iva, 'S'),
           timo_codi_oper,
           timo_dbcr,
           timo_tica_codi,
           timo_indi_caja,
           timo_tico_codi,
           tico_fech_rein,
           timo_indi_apli_adel_fopa,
           tico_indi_vali_nume,
           timo_dbcr_caja
      into p_movi_timo_desc,
           p_movi_afec_sald,
           p_movi_emit_reci,
           p_s_timo_calc_iva,
           p_movi_oper_codi,
           p_movi_dbcr,
           p_timo_tica_codi,
           p_timo_indi_caja,
           p_tico_codi,
           p_tico_fech_rein,
           p_timo_indi_apli_adel_fopa,
           p_tico_indi_vali_nume,
           p_timo_dbcr_caja
      from come_tipo_movi, come_tipo_comp a
     where timo_tico_codi = tico_codi(+)
       and timo_codi_oper = parameter.p_codi_oper
       and timo_codi = p_movi_timo_codi;
  
    if p_movi_emit_reci <> parameter.p_emit_reci then
      p_movi_timo_desc  := null;
      p_movi_afec_sald  := null;
      p_movi_emit_reci  := null;
      p_s_timo_calc_iva := null;
      raise_application_error(-20001,
                              'Tipo de Movimiento no valido para esta operacion');
    end if;
  
    if p_movi_oper_codi <> parameter.p_codi_oper then
      raise_application_error(-20001,
                              'Tipo de Movimiento no valido para esta operacion');
    end if;
  
    if nvl(upper(parameter.p_indi_perm_timo_bole), 'S') = 'N' then
      if p_movi_timo_codi in
         (parameter.p_codi_timo_pcoe, parameter.p_codi_timo_pcre) then
        raise_application_error(-20001,
                                'El tipo de movimiento ' ||
                                p_movi_timo_codi || ' no esta permitido');
      end if;
    end if;
  
  exception
    when no_data_found then
      p_movi_timo_desc  := null;
      p_movi_afec_sald  := null;
      p_movi_emit_reci  := null;
      p_s_timo_calc_iva := null;
      raise_application_error(-20001, 'Tipo de Movimiento inexistente');
    when too_many_rows then
      raise_application_error(-20001, 'Tipo de Movimiento duplicado');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_tipo_movi_inte;

  procedure pp_valida_fech(p_fech in date) is
    p_fech_inic date;
    p_fech_fini date;
  begin
  
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
    if p_fech not between p_fech_inic and p_fech_fini then
      raise_application_error(-20001,
                              'La fecha del movimiento debe estar comprendida entre..' ||
                              to_char(p_fech_inic, 'dd-mm-yyyy') || ' y ' ||
                              to_char(p_fech_fini, 'dd-mm-yyyy'));
    end if;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_valida_fech;

  procedure pp_carga_secu_inte(p_timo_calc_iva  in varchar2,
                               p_peco_codi      in number,
                               p_secu_nume_fact out number) is
  begin
    if nvl(p_timo_calc_iva, 'N') = 'N' then
      --solo para fact en negro  
      select nvl(secu_nume_fact_negr, 0) + 1
        into p_secu_nume_fact
        from come_secu
       where secu_codi = (select peco_secu_codi
                            from come_pers_comp
                           where peco_codi = p_peco_codi);
    else
    
      select nvl(secu_nume_fact, 0) + 1
        into p_secu_nume_fact
        from come_secu
       where secu_codi = (select peco_secu_codi
                            from come_pers_comp
                           where peco_codi = p_peco_codi);
    end if;
  
    /*p_nro_1 := substr(lpad(p_secu_nume_fact, 13, '0'), 1, 3);
    p_nro_2 := substr(lpad(p_secu_nume_fact, 13, '0'), 4, 3);
    p_nro_3 := substr(lpad(p_secu_nume_fact, 13, '0'), 7, 7);*/
  
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Codigo de Secuencia de Facturacion inexistente');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_carga_secu_inte;

  procedure pp_veri_nume_inte(p_nume                in out number,
                              p_tico_codi           in number,
                              p_tico_indi_vali_nume in varchar2) is
    v_nume number;
  begin
    v_nume := p_nume;
    if nvl(p_tico_indi_vali_nume, 'N') = 'S' then
      -- loop             
      begin
        select movi_nume
          into v_nume
          from come_movi, come_tipo_movi
         where movi_timo_codi = timo_codi
           and movi_nume = v_nume
           and timo_tico_codi = p_tico_codi;
      
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          null;
        when too_many_rows then
          v_nume := v_nume + 1;
      end;
      -- end loop;  
    end if;
    p_nume := v_nume;
  end pp_veri_nume_inte;

  procedure pp_mostrar_clpr(p_ind_clpr  in char,
                            p_clpr_codi in number,
                            p_clpr_desc out varchar2,
                            --  p_clpr_codi                out varchar2, 
                            p_indi_vali_limi_cred      out varchar2,
                            p_clpr_ruc                 out varchar2,
                            p_clpr_dire                out varchar2,
                            p_clpr_tele                out varchar2,
                            p_clpr_cli_situ_codi       out number,
                            p_clpr_indi_vali_situ_clie out varchar2,
                            p_clpr_indi_exen           out varchar2,
                            p_clpr_indi_list_negr      out varchar2,
                            p_clpr_indi_exce           out varchar2,
                            p_clpr_maxi_porc_deto      out number,
                            p_clpr_segm_codi           out number,
                            p_clpr_lipr_codi           out number,
                            p_clpr_clie_clas1_codi     out number) is
    v_clpr_esta char(1);
  
  begin
    select clpr_esta,
           clpr_desc, /*clpr_codi  ,*/
           clpr_indi_vali_limi_cred,
           clpr_ruc,
           clpr_dire,
           clpr_tele,
           clpr_cli_situ_codi,
           nvl(clpr_indi_vali_situ_clie, 'S'),
           nvl(clpr_indi_exen, 'N'),
           clpr_indi_list_negr,
           clpr_indi_exce,
           clpr_maxi_porc_deto,
           clpr_segm_codi,
           clpr_list_codi,
           clpr_clie_clas1_codi
      into v_clpr_esta,
           p_clpr_desc, /* p_clpr_codi,*/
           p_indi_vali_limi_cred,
           p_clpr_ruc,
           p_clpr_dire,
           p_clpr_tele,
           p_clpr_cli_situ_codi,
           p_clpr_indi_vali_situ_clie,
           p_clpr_indi_exen,
           p_clpr_indi_list_negr,
           p_clpr_indi_exce,
           p_clpr_maxi_porc_deto,
           p_clpr_segm_codi,
           p_clpr_lipr_codi,
           p_clpr_clie_clas1_codi
      from come_clie_prov
     where clpr_codi = p_clpr_codi
       and clpr_indi_clie_prov = p_ind_clpr;
  
    if v_clpr_esta = 'I' then
      raise_application_error(-20001, 'El cliente se encuentra Inactivo');
    end if;
  
    if p_clpr_lipr_codi is null then
      p_clpr_lipr_codi := 1;
    end if;
  
    if nvl(p_clpr_indi_list_negr, 'N') = 'S' then
      if nvl(p_clpr_indi_exce, 'N') = 'S' then
        -- si esta en excepcion solo se advierte
        raise_application_error(-20001,
                                'Atencion, El cliente se encuentra en Lista Negra.');
      else
        raise_application_error(-20001,
                                'Atencion, No se puede facturar al cliente!!! Se encuentra en Lista Negra.');
      end if;
    end if;
  
  exception
    when no_data_found then
      p_clpr_desc := null;
      if p_ind_clpr = 'P' then
        raise_application_error(-20001, 'Proveedor inexistente!');
      else
        raise_application_error(-20001, 'Cliente inexistente!');
      end if;
    when others then
      raise_application_error(-20001,
                              'Error en pp_mostrar_clpr ' || sqlerrm);
  end pp_mostrar_clpr;

  procedure pp_muestra_clpr_agen(p_clpr_codi      in number,
                                 p_clpr_agen_codi out number,
                                 p_clpr_agen_desc out varchar2,
                                 p_empl_codi_alte out varchar2) is
  begin
    select clpr_empl_codi, empl_desc, empl_codi_alte
      into p_clpr_agen_codi, p_clpr_agen_desc, p_empl_codi_alte
      from come_clie_prov, come_empl
     where clpr_empl_codi = empl_codi
       and clpr_codi = p_clpr_codi;
  
  exception
    when no_data_found then
      p_clpr_agen_codi := null;
      p_clpr_agen_desc := 'No tiene agente asignado';
      p_empl_codi_alte := null;
    
    when others then
      raise_application_error(-20001,
                              'Error pp_muestra_clpr_agen ' || sqlerrm);
  end pp_muestra_clpr_agen;

  procedure pp_deter_situ_clie(p_clpr_codi                in number,
                               p_situ_actu                in varchar2,
                               p_indi_afec_sald           in char,
                               p_clpr_indi_vali_situ_clie in char,
                               p_clpr_indi_exce           in char) is
    v_dias_atra number;
    --v_situ_codi      number;
    v_situ_indi_auma varchar2(1);
    v_situ_indi_fact varchar2(1);
  
    v_situ_colo varchar2(1);
    v_situ_desc varchar2(60);
  begin
    --- primero determinamos si la situacion actual es o no manual
  
    if p_situ_actu is not null then
      begin
        select situ_indi_auma, situ_indi_fact, situ_colo, situ_desc
          into v_situ_indi_auma, v_situ_indi_fact, v_situ_colo, v_situ_desc
          from come_situ_clie
         where situ_codi = p_situ_actu;
      
      exception
        when others then
          v_situ_indi_auma := 'A';
          v_situ_indi_fact := null;
          v_situ_colo      := null;
          v_situ_desc      := null;
        
      end;
    else
      v_situ_indi_auma := 'A';
      v_situ_indi_fact := null;
      v_situ_colo      := null;
      v_situ_desc      := null;
    end if;
  
    if v_situ_indi_auma = 'A' then
      --si es automatico se realiza un refresh para determinar la situacion en el momento    
      v_dias_atra := fa_devu_dias_atra_clie(p_clpr_codi);
      begin
        select situ_colo, situ_indi_fact, situ_desc
          into v_situ_colo, v_situ_indi_fact, v_situ_desc
          from come_situ_clie
         where v_dias_atra between situ_dias_atra_desd and
               situ_dias_atra_hast;
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'No existe ninguna siuacion para los dias d atraso');
          v_situ_colo      := 'B';
          v_situ_indi_fact := 'S';
          v_situ_desc      := ' ';
      end;
      ---setear el color 
    
      /* if v_situ_colo = 'r' then --rojo
       set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_rojo');
      elsif v_situ_colo = 'g' then
       set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_gris');
      elsif v_situ_colo = 'a' then --amarillo
       set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_amarillo');
      elsif v_situ_colo = 'b' then --blanco
       set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_blanco');     
      elsif v_situ_colo = 'z' then --azul
        set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_azul');              
      elsif v_situ_colo = 'n' then --naranja
        set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_naranja');                   
      else
        set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_blanco');    
      end if;         
      synchronize;*/
    
      --mensaje de alerta!!
      if nvl(p_clpr_indi_vali_situ_clie, 'S') = 'S' then
        if nvl(v_situ_indi_fact, 'N') = 'N' then
          if p_indi_afec_sald = 'C' then
            if nvl(p_clpr_indi_exce, 'N') = 'S' then
              -- si esta en excepcion solo se advierte
              raise_application_error(-20001,
                                      'Atencion, El cliente se encuentra en la Situacion. ' ||
                                      v_situ_desc);
            else
              raise_application_error(-20001,
                                      'Atencion, No se puede facturar al cliente a Credito !!!, Se encuentra en la Situacion. ' ||
                                      v_situ_desc);
            end if;
          else
            raise_application_error(-20001,
                                    'Atencion, El cliente se encuentra en la Situacion. ' ||
                                    v_situ_desc);
          end if;
        end if;
      end if;
    else
      --si es manual se toma los datos de la situacion actual  
    
      /* if v_situ_colo = 'r' then --rojo
        set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_rojo');
      elsif v_situ_colo = 'g' then
        set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_gris');
      elsif v_situ_colo = 'a' then --amarillo
        set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_amarillo');
      elsif v_situ_colo = 'b' then --blanco
        set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_blanco');    
      elsif v_situ_colo = 'z' then --azul
        set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_azul');  
      elsif v_situ_colo = 'n' then --naranja
         set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_naranja');                       
      else
        set_item_property('binte.clpr_codi_alte', current_record_attribute, 'visual_reg_blanco');    
      end if;*/
      --  synchronize;  
    
      if nvl(p_clpr_indi_vali_situ_clie, 'S') = 'S' then
        if nvl(v_situ_indi_fact, 'N') = 'N' then
          if p_indi_afec_sald = 'C' then
            if nvl(p_clpr_indi_exce, 'N') = 'S' then
              -- si esta en excepcion solo se advierte
              raise_application_error(-20001,
                                      'Atencion, El cliente se encuentra en la Situacion. ' ||
                                      v_situ_desc);
            else
              raise_application_error(-20001,
                                      'Atencion, No se puede facturar al cliente a Credito !!!, Se encuentra en la Situacion. ' ||
                                      v_situ_desc);
            end if;
          else
            raise_application_error(-20001,
                                    'Atencion, El cliente se encuentra en la Situacion. ' ||
                                    v_situ_desc);
          end if;
        end if;
      end if;
    
    end if;
  exception
    when others then
      raise_application_error(-20001,
                              'Error pp_deter_situ_clie ' || sqlerrm);
  end pp_deter_situ_clie;

  procedure pp_cargar_datos(p_movi_timo_codi           in number,
                            p_movi_fech_emis           in date,
                            p_peco_codi                in number,
                            p_clpr_codi                in number,
                            p_secu_nume_fact           out varchar2,
                            p_movi_timo_desc           out varchar2,
                            p_movi_afec_sald           out varchar2,
                            p_movi_emit_reci           out varchar2,
                            p_s_timo_calc_iva          out varchar2,
                            p_movi_oper_codi           out varchar2,
                            p_movi_dbcr                out varchar2,
                            p_timo_tica_codi           out number,
                            p_timo_indi_caja           out varchar2,
                            p_tico_codi                out number,
                            p_tico_fech_rein           out varchar2,
                            p_timo_indi_apli_adel_fopa out varchar2,
                            p_tico_indi_vali_nume      out varchar2,
                            p_timo_dbcr_caja           out varchar2,
                            p_clpr_desc                out varchar2,
                            p_indi_vali_limi_cred      out varchar2,
                            p_clpr_ruc                 out varchar2,
                            p_clpr_dire                out varchar2,
                            p_clpr_tele                out varchar2,
                            p_clpr_cli_situ_codi       out number,
                            p_clpr_indi_vali_situ_clie out varchar2,
                            p_clpr_indi_exen           out varchar2,
                            p_clpr_indi_list_negr      out varchar2,
                            p_clpr_indi_exce           out varchar2,
                            p_clpr_maxi_porc_deto      out number,
                            p_clpr_segm_codi           out number,
                            p_clpr_lipr_codi           out number,
                            p_clpr_clie_clas1_codi     out number,
                            p_clpr_agen_codi           out number,
                            p_clpr_agen_desc           out varchar2,
                            p_empl_codi_alte           out varchar2,
                            p_movi_orte_codi           out number) is
  
    v_nume_fact varchar2(20);
  begin
  
    if p_movi_timo_codi is not null then
      if p_movi_timo_codi in (2, 4) then
      
        i010346.pp_muestra_tipo_movi_inte(p_movi_timo_codi,
                                          p_movi_timo_desc,
                                          p_movi_afec_sald,
                                          p_movi_emit_reci,
                                          p_s_timo_calc_iva,
                                          p_movi_oper_codi,
                                          p_movi_dbcr,
                                          p_timo_tica_codi,
                                          p_timo_indi_caja,
                                          p_tico_codi,
                                          p_tico_fech_rein,
                                          p_timo_indi_apli_adel_fopa,
                                          p_tico_indi_vali_nume,
                                          p_timo_dbcr_caja);
      
      else
        raise_application_error(-20001,
                                'Tipo de Movimiento no valido para esta operacion');
      end if;
      -- pp_hab_des_cr_co(p_movi_afec_sald);  descartar por el momento
    else
      raise_application_error(-20001,
                              'Debe ingresar el tipo de Movimiento');
    end if;
  
    if nvl(p_timo_indi_caja, 'N') = 'S' then
      if parameter.p_indi_most_form_pago = 'S' and
         parameter.p_indi_obli_form_pago = 'S' then
        p_movi_orte_codi := parameter.p_codi_form_pago_defa;
        --pp_trae_form_pago;
      end if;
    
      /*/*if nvl(:parameter.p_indi_most_form_pago, 's') = 'n' then
        set_item_property('binte.movi_orte_codi', displayed, property_false);
        set_item_property('binte.s_orte_desc',    displayed, property_false);
      end if;*/
    
    else
      /* if nvl(:parameter.p_indi_most_form_pago, 's') = 's' then
        set_item_property('binte.movi_orte_codi', displayed, property_true);
        set_item_property('binte.movi_orte_codi', enabled,   property_true);
        set_item_property('binte.movi_orte_codi', navigable, property_true);
        set_item_property('binte.s_orte_desc',    displayed, property_true);
      else
        set_item_property('binte.movi_orte_codi', displayed, property_false);
        set_item_property('binte.s_orte_desc',    displayed, property_false);
      end if;*/
      null;
    end if;
  
    pp_valida_fech(p_movi_fech_emis);
  
    pp_carga_secu_inte(p_s_timo_calc_iva, parameter.p_peco_codi, v_nume_fact);
  
    i010346.pp_veri_nume_inte(v_nume_fact,
                              p_tico_codi,
                              p_tico_indi_vali_nume);
  
    p_secu_nume_fact := v_nume_fact;
  
    pp_mostrar_clpr('C',
                    p_clpr_codi,
                    p_clpr_desc,
                    p_indi_vali_limi_cred,
                    p_clpr_ruc,
                    p_clpr_dire,
                    p_clpr_tele,
                    p_clpr_cli_situ_codi,
                    p_clpr_indi_vali_situ_clie,
                    p_clpr_indi_exen,
                    p_clpr_indi_list_negr,
                    p_clpr_indi_exce,
                    p_clpr_maxi_porc_deto,
                    p_clpr_segm_codi,
                    p_clpr_lipr_codi,
                    p_clpr_clie_clas1_codi);
  
    pp_muestra_clpr_agen(p_clpr_codi,
                         p_clpr_agen_codi,
                         p_clpr_agen_desc,
                         p_empl_codi_alte);
  
    pp_deter_situ_clie(p_clpr_codi,
                       p_clpr_cli_situ_codi,
                       p_movi_afec_sald,
                       p_clpr_indi_vali_situ_clie,
                       p_clpr_indi_exce);
  
  exception
    when others then
      raise_application_error(-20001, 'error pp_cargar_datos ' || sqlerrm);
  end pp_cargar_datos;

  procedure pp_carg_dat(p_movi_timo_codi      in number,
                        p_clpr_empl_codi      in number,
                        p_sucu_codi           in number,
                        p_movi_sucu_codi_orig out number,
                        p_movi_sucu_desc_orig out varchar2,
                        p_movi_empl_codi      out number,
                        p_movi_mone_codi      out number) is
    --v_nave_det  varchar2(1);
    v_form_impr number;
  begin
    if p_movi_timo_codi in (1, 3) then
      begin
        select sucu_codi, sucu_desc, sucu_form_impr_fact
          into p_movi_sucu_codi_orig, p_movi_sucu_desc_orig, v_form_impr
          from come_sucu
         where sucu_codi = p_sucu_codi;
      
      exception
        when no_data_found then
          null;
      end;
      if p_clpr_empl_codi is not null then
      
        p_movi_empl_codi := p_clpr_empl_codi;
      
      else
        begin
          select user_empl_codi --, a.empl_desc
            into p_movi_empl_codi --, p_movi_empl_desc
            from segu_user, come_empl a
           where user_login = fa_user
             and a.empl_codi = user_empl_codi;
        exception
          when no_data_found then
            null;
        end;
      end if;
    
    else
      begin
        select sucu_codi, sucu_desc, sucu_form_impr_fact
          into p_movi_sucu_codi_orig, p_movi_sucu_desc_orig, v_form_impr
          from come_sucu
         where sucu_codi = p_sucu_codi;
      
      exception
        when no_data_found then
          null;
      end;
    
      if p_clpr_empl_codi is not null then
      
        p_movi_empl_codi := p_clpr_empl_codi;
      
        begin
          select user_empl_codi --, a.empl_desc
            into p_movi_empl_codi --, p_movi_empl_desc
            from segu_user, come_empl a
           where user_login = fa_user
             and a.empl_codi = user_empl_codi;
        exception
          when no_data_found then
            null;
        end;
      end if;
    
      p_movi_mone_codi := 1;
    
    end if;
  
  end pp_carg_dat;

  procedure pp_valida_nume_fact_fini(p_movi_fech_emis in date,
                                     p_tico_fech_rein in date,
                                     p_tico_codi      in number,
                                     p_movi_nume      in number,
                                     p_info_fech_oper in date) is
    v_count number;
  
    salir exception;
  
  begin
    if p_movi_fech_emis < p_tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = p_movi_nume
         and timo_tico_codi = p_tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis < p_tico_fech_rein;
    
    elsif p_info_fech_oper > p_tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = p_movi_nume
         and timo_tico_codi = p_tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis >= p_tico_fech_rein;
    
    end if;
  
    if v_count > 0 then
      --p_movi_nume   := to_number((p_s_nro_1||p_s_nro_2||p_s_nro_3));
      --  p_s_movi_nume := (p_s_nro_1||'-'||p_s_nro_2||'-'||p_s_nro_3);
      raise_application_error(-20001,
                              'Nro de Comprobante Existente!!!!! , favor verifique!!');
    end if;
  
  exception
    when salir then
      raise_application_error(-20001, 'Reingrese el nro de comprobante');
  end pp_valida_nume_fact_fini;

  procedure pp_valida_nume_fact(p_movi_fech_emis in date,
                                p_tico_fech_rein in date,
                                p_tico_codi      in number,
                                p_movi_nume      in number) is
    v_count   number;
    v_message varchar2(1000) := 'Nro de Comprobante Existente!!!!! , favor verifique!!';
    salir     exception;
  
  begin
    if p_movi_fech_emis < p_tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = p_movi_nume
         and timo_tico_codi = p_tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis < p_tico_fech_rein;
    
    elsif p_movi_fech_emis >= p_tico_fech_rein then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi, come_tipo_comp
       where movi_timo_codi = timo_codi
         and timo_tico_codi = tico_codi(+)
         and movi_nume = p_movi_nume
         and timo_tico_codi = p_tico_codi
         and nvl(tico_indi_vali_nume, 'N') = 'S'
         and movi_fech_emis >= p_tico_fech_rein;
    
    end if;
  
    if v_count > 0 then
      raise_application_error(-20001, v_message);
    end if;
  
  exception
    when salir then
      raise_application_error(-20001, 'Reigrese el nro de comprobante');
  end pp_valida_nume_fact;

  procedure pp_veri_nume_dife(p_movi_nume           in number,
                              p_tico_codi           in number,
                              p_tico_indi_vali_nume in varchar2) is
    v_count number := 0;
  begin
    if nvl(p_tico_indi_vali_nume, 'N') = 'S' then
      select count(*)
        into v_count
        from come_movi, come_tipo_movi
       where movi_nume = p_movi_nume
         and movi_timo_codi = timo_codi
         and timo_tico_codi = p_tico_codi;
    end if;
    if v_count > 0 then
      raise_application_error(-20001,
                              'Numero de comprobante ya existe. Favor verifique!');
    end if;
  
  end pp_veri_nume_dife;

  procedure pp_validar_numero(p_movi_fech_emis      in date,
                              p_tico_fech_rein      in date,
                              p_tico_codi           in number,
                              p_movi_nume           in number,
                              p_info_fech_oper      in date,
                              p_tico_indi_vali_nume in varchar2,
                              p_disp_actu_regi      in varchar2)
  
   is
  begin
  
    if p_movi_nume is null then
      raise_application_error(-20001,
                              'Debe ingresar el n?mero de factura.!');
    else
      if p_disp_actu_regi = 'S' then
        pp_valida_nume_fact_fini(p_movi_fech_emis,
                                 p_tico_fech_rein,
                                 p_tico_codi,
                                 p_movi_nume,
                                 p_info_fech_oper);
      else
        pp_valida_nume_fact(p_movi_fech_emis,
                            p_tico_fech_rein,
                            p_tico_codi,
                            p_movi_nume);
      end if;
    end if;
  
    --
    if ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_modi_nume_fact'))) = 'S' then
      pp_veri_nume_dife(p_movi_nume, p_tico_codi, p_tico_indi_vali_nume);
    end if;
  exception
    when others then
      null;
    
  end pp_validar_numero;

  procedure pp_busca_tasa_mone(p_mone_codi      in number,
                               p_coti_fech      in date,
                               p_mone_coti      out number,
                               p_tica_codi      in number,
                               p_info_tasa_mone in number) is
  begin
  
    if parameter.p_codi_mone_mmnn = p_mone_codi then
      p_mone_coti := 1;
    
    else
      begin
        select coti_tasa
          into p_mone_coti
          from come_coti
         where coti_mone = p_mone_codi
           and coti_fech = p_coti_fech
           and coti_tica_codi = p_tica_codi;
      exception
        when no_data_found then
          p_mone_coti := p_info_tasa_mone;
          raise_application_error(-20001,
                                  'Cotizacion Inexistente para la fecha del documento.' ||
                                  p_coti_fech || ' ' || p_mone_codi || ' ' ||
                                  p_tica_codi);
      end;
    end if;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_busca_tasa_mone;

  procedure pp_validar_moneda(p_movi_clpr_codi in number,
                              p_info_tasa_mone in number,
                              p_movi_afec_sald in varchar,
                              p_movi_mone_codi in out number,
                              p_limi_cred_mone out number,
                              p_movi_fech_emis in date,
                              p_sald_clie_mone out number,
                              p_sald_limi_cred out number,
                              p_timo_tica_codi in number,
                              p_movi_tasa_mone out number,
                              p_movi_tasa_us   out number) is
  begin
    if p_movi_mone_codi is null then
      p_movi_mone_codi := parameter.p_codi_mone_mmnn;
    else
      p_movi_mone_codi := p_movi_mone_codi;
    end if;
    --pl_muestra_come_mone (p_movi_mone_codi, p_movi_mone_desc, p_movi_mone_desc_abre, p_movi_mone_cant_deci);
  
    pp_busca_tasa_mone(p_movi_mone_codi,
                       p_movi_fech_emis,
                       p_movi_tasa_mone,
                       p_timo_tica_codi,
                       p_info_tasa_mone);
    pp_busca_tasa_mone(parameter.p_codi_mone_dola,
                       p_movi_fech_emis,
                       p_movi_tasa_us,
                       p_timo_tica_codi,
                       p_info_tasa_mone);
  
    --cargar el limite de credito del cliente, solo si es credito....
  
    if nvl(p_movi_afec_sald, 'N') = 'C' then
      pa_devu_limi_cred_clie(p_movi_clpr_codi,
                             p_movi_mone_codi,
                             p_limi_cred_mone,
                             p_sald_clie_mone,
                             p_sald_limi_cred);
    
    end if;
  end pp_validar_moneda;

  procedure pp_cargar_detalle is
    v_desc                     varchar2(1000);
    v_impu                     number;
    v_timo_calc_iva            varchar2(20);
    v_impu_desc                varchar2(1000);
    v_impu_porc                varchar2(20);
    v_impu_porc_base_impo      varchar2(20);
    v_impu_indi_baim_impu_incl varchar2(20);
  begin
    pp_traer_desc_conce(parameter.p_codi_conc_info_cobr, v_desc, v_impu);
  
    pp_muestra_impu(v_impu,
                    v_timo_calc_iva,
                    v_impu_desc,
                    v_impu_porc,
                    v_impu_porc_base_impo,
                    v_impu_indi_baim_impu_incl);
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'IN_GASTO_DET');
  
    apex_collection.add_member(p_collection_name => 'IN_GASTO_DET',
                               p_c001            => 'S',
                               p_c002            => parameter.p_codi_conc_info_cobr,
                               p_c003            => v_desc,
                               p_c004            => 1,
                               p_c005            => null,
                               p_c006            => null,
                               p_c007            => null,
                               p_c008            => null,
                               p_c009            => v_impu,
                               p_c010            => v_impu_desc,
                               p_c011            => v_impu_porc,
                               p_c012            => v_impu_porc_base_impo,
                               p_c013            => v_impu_indi_baim_impu_incl);
  
  end pp_cargar_detalle;

  procedure pp_traer_desc_conce(p_codi in number,
                                p_desc out varchar2,
                                p_impu out number) is
    v_conc_dbcr varchar2(1);
  
    cursor c_conc_iva(p_conc_codi in number) is
      select conc_codi
        from (select nvl(impu_conc_codi_ivdb, -1) conc_codi
                from come_impu
              union
              select nvl(impu_conc_codi_ivcr, -1) conc_codi
                from come_impu)
       where conc_codi = p_conc_codi
       order by 1;
  
  begin
    for x in c_conc_iva(p_codi) loop
      raise_application_error(-20001,
                              'No puede seleccionar un concepto de IVA');
    end loop;
  
    select conc_desc, conc_dbcr, conc_impu_codi
      into p_desc, v_conc_dbcr, p_impu
      from come_conc
     where conc_codi = p_codi
       and nvl(conc_indi_fact, 'N') = 'S';
  
    if v_conc_dbcr = 'C' then
      raise_application_error(-20001,
                              'Debe ingresar un conceto de tipo Ingreso');
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Concepto inexistente o no es facturable!');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_traer_desc_conce;

  procedure pp_calcular_importe_item_3(p_deta_prec_unit      in number,
                                       p_movi_mone_cant_deci in number,
                                       p_seq_id              in number,
                                       p_movi_tasa_mone      in number,
                                       p_s_exen              out number,
                                       p_s_iva_10            out number,
                                       p_s_grav_10_ii        out number,
                                       p_s_iva_5             out number,
                                       p_s_grav_5_ii         out number,
                                       p_s_total             out number,
                                       p_s_grav              out number,
                                       p_s_iva               out number --,
                                       --  p_s_total_dto   out number
                                       
                                       ) is
  
    v_impo_tota       number;
    v_total_item      number;
    v_deta_grav_10_ii number;
    v_deta_grav_5_ii  number;
    v_deta_grav_10    number;
    v_deta_grav_5     number;
    v_deta_iva_10     number;
    v_deta_iva_5      number;
    v_deta_exen       number;
    v_deta_impo_mone  number;
    v_deta_impo_mmnn  number;
    v_deta_iva_mone   number;
    v_deta_iva_mmnn   number;
    deta_porc_deto    number;
  begin
  
    for i in (select seq_id,
                     c001   ind_tipo,
                     c002   concepto,
                     c003   concdesc,
                     c004   cant,
                     c009   impu,
                     c010   impu_desc,
                     c011   impu_porc,
                     c012   impu_porc_base_impo,
                     c013   impu_indi_baim_impu_incl
                from apex_collections a
               where collection_name = 'IN_GASTO_DET'
                 and seq_id = p_seq_id) loop
    
      v_impo_tota := round((nvl(p_deta_prec_unit, 0) *
                           (1 - (nvl(deta_porc_deto, 0) / 100)) *
                           nvl(i.cant, 0)),
                           nvl(p_movi_mone_cant_deci, 0));
    
      --raise_application_error(-20001,v_impo_tota);                 
      pa_devu_impo_calc(v_impo_tota,
                        nvl(p_movi_mone_cant_deci, 0),
                        i.impu_porc,
                        i.impu_porc_base_impo,
                        i.impu_indi_baim_impu_incl,
                        
                        v_total_item,
                        v_deta_grav_10_ii,
                        v_deta_grav_5_ii,
                        v_deta_grav_10,
                        v_deta_grav_5,
                        v_deta_iva_10,
                        v_deta_iva_5,
                        v_deta_exen);
    
      v_deta_impo_mone := v_deta_exen + v_deta_grav_10 + v_deta_grav_5;
      v_deta_impo_mmnn := round(v_deta_impo_mone * p_movi_tasa_mone,
                                parameter.p_cant_deci_mmnn);
      v_deta_iva_mone  := p_s_iva_10 + p_s_iva_5;
      v_deta_iva_mmnn  := round(v_deta_iva_mone * p_movi_tasa_mone,
                                parameter.p_cant_deci_mmnn);
    
      p_s_exen       := nvl(v_deta_exen, 0);
      p_s_iva_10     := nvl(v_deta_iva_10, 0);
      p_s_grav_10_ii := nvl(v_deta_grav_10_ii, 0);
      p_s_iva_5      := nvl(v_deta_iva_5, 0);
      p_s_grav_5_ii  := nvl(v_deta_grav_5_ii, 0);
      p_s_total      := v_total_item;
      p_s_grav       := p_s_grav_10_ii + p_s_grav_5_ii - p_s_iva_10 -
                        p_s_iva_5;
      p_s_iva        := p_s_iva_10 + p_s_iva_5;
      -- p_s_total_dto    := p_descuento;
    
      /* :bdetinte.deta_impo_deto_mone := round(nvl(:bdetinte.deta_prec_unit_list, 0) *
      nvl(:bdetinte.deta_cant_medi, 0),
      p_movi_mone_cant_deci) -
       round(nvl(:bdetinte.deta_impo_mone, 0) +
      nvl(:bdetinte.deta_iva_mone, 0),
      p_movi_mone_cant_deci);*/
    
      apex_collection.update_member(p_collection_name => 'IN_GASTO_DET',
                                    p_seq             => i.seq_id,
                                    p_c001            => i.ind_tipo,
                                    p_c002            => i.concepto,
                                    p_c003            => i.concdesc,
                                    p_c004            => i.cant,
                                    p_c005            => p_deta_prec_unit,
                                    p_c006            => v_impo_tota,
                                    p_c007            => null,
                                    p_c008            => v_total_item,
                                    p_c009            => i.impu,
                                    p_c010            => i.impu_desc,
                                    p_c011            => i.impu_porc,
                                    p_c012            => i.impu_porc_base_impo,
                                    p_c013            => i.impu_indi_baim_impu_incl,
                                    p_c014            => v_deta_grav_10_ii,
                                    p_c015            => v_deta_grav_5_ii,
                                    p_c016            => v_deta_grav_10,
                                    p_c017            => v_deta_grav_5,
                                    p_c018            => v_deta_iva_10,
                                    p_c019            => v_deta_iva_5,
                                    p_c020            => v_deta_exen,
                                    p_c021            => v_deta_impo_mone,
                                    p_c022            => v_deta_impo_mmnn,
                                    p_c023            => v_deta_iva_mone,
                                    p_c024            => v_deta_iva_mmnn);
    
    end loop;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

  procedure pp_muestra_impu(p_deta_impu_codi           in out number,
                            p_timo_calc_iva            in varchar,
                            p_impu_desc                out varchar2,
                            p_impu_porc                out varchar2,
                            p_impu_porc_base_impo      out varchar2,
                            p_impu_indi_baim_impu_incl out varchar2) is
  begin
    select impu_desc,
           impu_porc,
           impu_porc_base_impo,
           impu_indi_baim_impu_incl
      into p_impu_desc,
           p_impu_porc,
           p_impu_porc_base_impo,
           p_impu_indi_baim_impu_incl
      from come_impu
     where impu_codi = p_deta_impu_codi;
  
    --si El tipo de movimiento tiene el indicador de calculo de iva 'N'
    --entonces siempre ser? exento....
    if p_timo_calc_iva = 'N' then
      p_deta_impu_codi      := parameter.p_codi_impu_exen;
      p_impu_porc           := 0;
      p_impu_porc_base_impo := 0;
    end if;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Tipo de Impuesto inexistente');
    when too_many_rows then
      raise_application_error(-20001, 'Tipo de Impuesto duplicado');
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_muestra_impu;

  procedure pp_generar_cuotas(p_cant_cuotas         in number,
                              p_total               in number,
                              p_movi_mone_cant_deci in number,
                              p_movi_fech_emis      in date,
                              p_dias                in number) is
    v_dias        number;
    v_importe     number;
    v_cant_cuotas number;
    v_entrega     number := 0;
    v_vto         number;
    v_diferencia  number;
    v_count       number := 0;
    v_nume_cuot   number;
  begin
  
    --v_vto := 30;
  
    v_dias       := p_dias;
    v_entrega    := 0;
    v_importe    := round(p_total / p_cant_cuotas, p_movi_mone_cant_deci);
    v_diferencia := (p_total - (v_importe * p_cant_cuotas));
    v_nume_cuot  := 0;
  
    --raise_application_error(-20001,p_cant_cuotas);
    apex_collection.create_or_truncate_collection(p_collection_name => 'IN_CANT_CUOT');
    for x in 1 .. p_cant_cuotas loop
    
      apex_collection.add_member(p_collection_name => 'IN_CANT_CUOT',
                                 p_c001            => v_dias,
                                 p_c002            => v_importe,
                                 p_c003            => v_nume_cuot + 1,
                                 p_c004            => v_nume_cuot + 1,
                                 p_c005            => v_dias + v_vto,
                                 p_c006            => p_movi_fech_emis +
                                                      v_dias);
    
    /*  if v_count = v_cant_cuotas then
               next_record;
            end if;*/
    
    end loop;
  
    ---------------------
    /*if v_diferencia <> 0 then
      --sumar la diferencia a la ultima cuota   
      last_record;
      :bcuota.cuot_impo_mone := :bcuota.cuot_impo_mone + v_diferencia;
    end if;*/
  
    ------------------
  
  exception
  
    when others then
      raise_application_error(-20001,
                              'Error pp_generar_cuotas ' || sqlerrm);
  end pp_generar_cuotas;
 

  procedure pp_actualizar_registro_inte(p_movi_nume           in number,
                                        p_tico_codi           in number,
                                        p_tico_indi_vali_nume in varchar2,
                                        p_movi_fech_emis      in date,
                                        p_movi_afec_sald      in varchar2,
                                        p_movi_tasa_mone      number,
                                        p_movi_mone_cant_deci in number,
                                        p_timo_calc_iva in varchar2,
                                        p_peco_codi in number) is
    salir             exception;
    v_record          number;
    v_movi_nume_nuevo number := p_movi_nume;
    v_indi_actu_secu  varchar2(2);
    v_movi_codi       number;
  begin
  
  
  
    --  :parameter.p_disp_actu_regi := 'S';
  
    ---*****Verificacion de duplicacion de comprobante
    if ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_modi_nume_fact'))) = 'N' then
      -- si el usuario tiene permiso o no de modificar el numero de factura.
      -- verifica el numero de comprobante.. en caso que exista hace 
    
      i010346.pp_veri_nume_inte(v_movi_nume_nuevo,
                                p_tico_codi,
                                p_tico_indi_vali_nume); -- un loop y devuelve el siguiente numero libre..                                                          
      v_indi_actu_secu := 'S';
    else
     
      if v_movi_nume_nuevo <> p_movi_nume then
        -- si el numero de comprobante es distinto al numero traido de secuencia
        -- se esta cargando en diferido entonces no se actualiza secuencia.
        -- Pero verifica si existe!!!
        
        pp_veri_nume_dife(v_movi_nume_nuevo,
                          p_tico_codi,
                          p_tico_indi_vali_nume);
        v_indi_actu_secu := 'N';
        
      else
      
        pp_veri_nume_inte(v_movi_nume_nuevo,
                          p_tico_codi,
                          p_tico_indi_vali_nume); -- verifica el numero de comprobante.. en caso que exista hace 
        -- un loop y devuelve el siguiente numero libre..              
        v_indi_actu_secu := 'S';
      end if;
      
    end if;
    ---*****
   
    pp_valida_fech(p_movi_fech_emis);
    
    --puede que cuando se cargue toda la factura modifiquen el indicador de lim de credito
    --o bien pudieron asignarle mas limite de credito en ese momento...
    ----------------------------------------------------------------------------------------------------------------------------------------------------
  
    ----------------------------------------------------------------------------------------------------------------------------------------------------
  
    /* if nvl(p_movi_afec_sald, 'N') = 'C'  then
    
    /*pp_mostrar_clpr ('C', 
                     :binte.clpr_codi_alte, 
                     :binte.movi_clpr_desc, 
                     :binte.movi_clpr_codi, 
                     :binte.clpr_indi_vali_limi_cred,
                     :binte.movi_clpr_ruc, 
                     :binte.movi_clpr_dire,
                     :binte.movi_clpr_tele,
                     :binte.clpr_cli_situ_codi,
                     :binte.clpr_indi_vali_situ_clie, 
                     :binte.clpr_indi_exen,
                     :binte.clpr_indi_list_negr,
                     :binte.clpr_indi_exce,
                     :binte.clpr_maxi_porc_deto,
                     :binte.clpr_segm_codi,
                     :binte.list_codi,
                     :binte.clpr_clie_clas1_codi);
    end if;*/
  
    --  pp_muestra_clpr_agen(:binte.movi_clpr_codi, :binte.s_clpr_agen_codi, :binte.clpr_agen_desc, :binte.s_agen_codi_alte); 
  
    /* if nvl(p_movi_afec_sald, 'N') = 'C' then
      --pp_carga_limi_cred(:binte.movi_clpr_codi, :binte.movi_tasa_mone, :binte.s_limi_cred_mone);
      --pp_carga_sald_clie(:binte.movi_clpr_codi, :binte.movi_tasa_mone, :binte.s_sald_clie_mone);
      pa_devu_limi_cred_clie(:binte.movi_clpr_codi,
                             :binte.movi_mone_codi,
                             :binte.s_limi_cred_mone,
                             :binte.s_sald_clie_mone,
                             :binte.s_sald_limi_cred);
    end if; */
    -----------------------------------------------------------------------------------------------------------------------------------------------------
  
    -- Volver a verificar para evitar que otro usuario registre al mismo tiempo
    --    pp_valida_nume_fact_fini;
    --
    /* if nvl(:binte.s_timo_calc_iva, 'N') = 'N' then --solo para fact en negro
      pp_busca_nume_movi_inte;
    end if;*/
  
    --pp_calcular_importe_cab_inte; 
  
    -- if p_movi_codi is null then    
    -- Si la cantidad de registros no supera a limite de impresion el proceso es normal
    -- pp_actualiza_come_movi_inte;
     /* I010346.pp_actualiza_come_movi_inte(p_movi_codi => v_movi_codi,
                                      P_movi_timo_codi => v('P92_MOVI_TIMO_CODI'),
                                      p_movi_clpr_codi => v('p92_clpr_codi'),
                                      p_movi_sucu_codi_orig => v('p92_movi_sucu_codi_orig'),
                                      p_movi_mone_codi => v('p92_movi_mone_codi'),
                                      p_movi_nume => v_movi_nume_nuevo,
                                      p_movi_fech_emis => p_movi_fech_emis,
                                      p_movi_tasa_mone => p_movi_tasa_mone,
                                      p_movi_grav_mmnn => v('p92_movi_grav_mmnn'),
                                      p_movi_exen_mmnn => 0,--:p_movi_exen_mmnn,
                                      p_movi_iva_mmnn => :p_movi_iva_mmnn,
                                      p_movi_grav_mone => :p_movi_grav_mone,
                                      p_movi_exen_mone => :p_movi_exen_mone,
                                      p_movi_iva_mone => :p_movi_iva_mone,
                                      p_movi_obse => :p_movi_obse,
                                      p_movi_sald_mmnn => :p_movi_sald_mmnn,
                                      p_movi_sald_mone => :p_movi_sald_mone,
                                      p_movi_clpr_dire => :p_movi_clpr_dire,
                                      p_movi_clpr_tele => :p_movi_clpr_tele,
                                      p_movi_clpr_ruc => :p_movi_clpr_ruc,
                                      P_movi_emit_reci => :P_movi_emit_reci,
                                      p_movi_afec_sald => :p_movi_afec_sald,
                                      P_movi_dbcr => :P_movi_dbcr,
                                      p_movi_empl_codi => :p_movi_empl_codi,
                                      p_movi_orte_codi => :p_movi_orte_codi,
                                      p_s_grav_10_ii => :p_s_grav_10_ii,
                                      p_s_grav_5_ii => :p_s_grav_5_ii,
                                      p_s_iva_10 => :p_s_iva_10,
                                      p_s_iva_5 => :p_s_iva_5,
                                      p_movi_form_entr_codi => :p_movi_form_entr_codi)*/
  
    if rtrim(ltrim(p_movi_afec_sald)) <> 'N' then
   
      if upper(parameter.p_indi_tabla_gene_cuot) = 'COME_MOVI_CUOT_PRES' then
      
        I010346.pp_actu_come_movi_cuot_pres(v_movi_codi,
                                            P_movi_afec_sald,
                                            p_movi_tasa_mone);
                                            
      else
      
        pp_actualiza_come_movi_cuot(p_movi_afec_sald,
                                    p_movi_tasa_mone,
                                    v_movi_codi);
      
      end if;
    end if;
  
    pp_actualizar_moco_inte(v_movi_codi,
                            p_movi_tasa_mone,
                            p_movi_mone_cant_deci);
    pp_actualiza_moimpu_2_inte(v_movi_codi);
     pp_actu_secu_inte(v_indi_actu_secu,
                       v_movi_codi,
                       p_timo_calc_iva,
                       parameter.p_peco_codi);
    
  
    --end if;
  
  end;

  procedure pp_insert_come_movi_inte(p_movi_codi                in number,
                                     p_movi_timo_codi           in number,
                                     p_movi_clpr_codi           in number,
                                     p_movi_sucu_codi_orig      in number,
                                     p_movi_oper_codi           in number,
                                     p_movi_mone_codi           in number,
                                     p_movi_nume                in number,
                                     p_movi_fech_emis           in date,
                                     p_movi_fech_grab           in date,
                                     p_movi_user                in varchar2,
                                     p_movi_tasa_mone           in number,
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
                                     p_movi_orte_codi           in number,
                                     p_movi_form_entr_codi      in number,
                                     p_movi_sub_clpr_codi       in number,
                                     p_movi_info_codi           in number,
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
                                     p_movi_iva5_mmnn           in number) is
  begin
  
    insert into come_movi
      (movi_codi,
       movi_timo_codi,
       movi_clpr_codi,
       movi_sucu_codi_orig,
       movi_oper_codi,
       movi_mone_codi,
       movi_nume,
       movi_fech_emis,
       movi_fech_grab,
       movi_user,
       movi_tasa_mone,
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
       movi_orte_codi,
       movi_form_entr_codi,
       movi_info_codi,
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
      (p_movi_codi,
       p_movi_timo_codi,
       p_movi_clpr_codi,
       p_movi_sucu_codi_orig,
       p_movi_oper_codi,
       p_movi_mone_codi,
       p_movi_nume,
       p_movi_fech_emis,
       p_movi_fech_grab,
       p_movi_user,
       p_movi_tasa_mone,
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
       p_movi_orte_codi,
       p_movi_form_entr_codi,
       p_movi_info_codi,
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
       p_movi_iva5_mmnn);
  
  Exception
    when others then
      raise_application_error(-20001, sqlerrm);
      
      
    
  end pp_insert_come_movi_inte;

  procedure pp_actualiza_come_movi_inte(p_movi_codi           out number,
                                        p_movi_timo_codi      in number,
                                        p_movi_clpr_codi      in number,
                                        p_movi_sucu_codi_orig in number,
                                        p_movi_mone_codi      in number,
                                        p_movi_nume           in number,
                                        p_movi_fech_emis      in date,
                                        p_movi_tasa_mone      in number,
                                        p_movi_grav_mmnn      in number,
                                        p_movi_exen_mmnn      in number,
                                        p_movi_iva_mmnn       in number,
                                        p_movi_grav_mone      in number,
                                        p_movi_exen_mone      in number,
                                        p_movi_iva_mone       in number,
                                        p_movi_obse           in varchar2,
                                        p_movi_sald_mmnn      in number,
                                        p_movi_sald_mone      in number,
                                        p_movi_clpr_dire      in varchar2,
                                        p_movi_clpr_tele      in varchar2,
                                        p_movi_clpr_ruc       in varchar2,
                                        p_movi_emit_reci      in varchar2,
                                        p_movi_afec_sald      in varchar2,
                                        p_movi_dbcr           in varchar2,
                                        p_movi_empl_codi      in number,
                                        p_movi_orte_codi      in number,
                                        p_s_grav_10_ii        in number,
                                        p_s_grav_5_ii         in number,
                                        p_s_iva_10            in number,
                                        p_s_iva_5             in number,
                                        p_movi_form_entr_codi in number) is
    v_movi_stoc_suma_rest      varchar2(1);
    v_movi_clpr_desc           varchar2(80);
    v_movi_stoc_afec_cost_prom varchar2(1);
    v_movi_empr_codi           number;
  
    v_movI_info_codi number;
  
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
  
  begin
  
    --- asignar valores....
    p_movi_codi := fa_sec_come_movi;
  
    --pl_muestra_come_stoc_oper (:parameter.p_codi_oper, p_movi_oper_desc, p_movi_oper_desc_abre, p_movi_stoc_suma_rest, p_movi_stoc_afec_cost_prom )  ;
  
    --:parameter.p_movi_nume            := p_s_movi_nume;
  
    --v_movi_stoc_suma_rest             := p_movi_stoc_suma_rest;
  
    --v_movi_clpr_desc                  := p_movi_clpr_desc;
    --v_movi_stoc_afec_cost_prom        := p_movi_stoc_afec_cost_prom;
    v_movi_impo_mone_ii   := p_movi_grav_mone + p_movi_exen_mone +
                             p_movi_iva_mone;
    v_movi_impo_mmnn_ii   := p_movi_grav_mmnn + p_movi_exen_mmnn +
                             p_movi_iva_mmnn;
    v_movi_grav10_ii_mone := p_s_grav_10_ii;
    v_movi_grav5_ii_mone  := p_s_grav_5_ii;
    v_movi_grav10_ii_mmnn := round((v_movi_grav10_ii_mone *
                                   p_movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_movi_grav5_ii_mmnn  := round((v_movi_grav5_ii_mone * p_movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_movi_grav10_mone    := p_s_grav_10_ii - p_s_iva_10;
    v_movi_grav5_mone     := p_s_grav_5_ii - p_s_iva_5;
    v_movi_grav10_mmnn    := round((v_movi_grav10_mone * p_movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_movi_grav5_mmnn     := round((v_movi_grav5_mone * p_movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_movi_iva10_mone     := p_s_iva_10;
    v_movi_iva5_mone      := p_s_iva_5;
    v_movi_iva10_mmnn     := round((v_movi_iva10_mone * p_movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);
    v_movi_iva5_mmnn      := round((v_movi_iva5_mone * p_movi_tasa_mone),
                                   parameter.p_cant_deci_mmnn);

    pp_insert_come_movi_inte(p_movi_codi,
                             p_movi_timo_codi,
                             p_movi_clpr_codi,
                             p_movi_sucu_codi_orig,
                             parameter.p_codi_oper,
                             p_movi_mone_codi,
                             p_movi_nume,
                             p_movi_fech_emis,
                             sysdate,
                             fa_user,
                             p_movi_tasa_mone,
                             p_movi_grav_mmnn,
                             p_movi_exen_mmnn,
                             p_movi_iva_mmnn,
                             null,
                             null,
                             null,
                             p_movi_grav_mone,
                             p_movi_exen_mone,
                             p_movi_iva_mone,
                             p_movi_obse,
                             p_movi_sald_mmnn,
                             null,
                             p_movi_sald_mone,
                             v_movi_stoc_suma_rest,
                             p_movi_clpr_dire,
                             p_movi_clpr_tele,
                             p_movi_clpr_ruc,
                             v_movi_clpr_desc,
                             p_movi_emit_reci,
                             p_movi_afec_sald,
                             p_movi_dbcr,
                             v_movi_stoc_afec_cost_prom,
                             v_movi_empr_codi,
                             null,
                             null,
                             'S',
                             p_movi_empl_codi,
                             p_movi_orte_codi,
                             p_movi_form_entr_codi,
                             null,
                             v_movi_info_codi,
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
    --------------------------------------------------------------------------------------------------------------
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualiza_come_movi_inte;

  procedure pp_actu_come_movi_cuot_pres(p_movi_codi      in number,
                                        p_movi_afec_sald in varchar2,
                                        p_movi_tasa_mone in number) is
    v_cuot_fech_venc      date;
    v_cuot_nume           number;
    v_cuot_impo_mone      number;
    v_cuot_impo_mmnn      number;
    v_cuot_impo_mmee      number;
    v_cuot_sald_mone      number;
    v_cuot_sald_mmnn      number;
    v_cuot_sald_mmee      number;
    v_cuot_impo_gaad_mone number;
    v_cuot_impo_gaad_mmnn number;
    v_cuot_sald_gaad_mone number;
    v_cuot_sald_gaad_mmnn number;
  begin
  
    if rtrim(ltrim(p_movi_afec_sald)) <> 'N' then
    
      for i in (select seq_id,
                       c001   dia,
                       c002   importe,
                       c003   cuot_nume,
                       c004   fecha_vencimiento
                  from apex_collections a
                 where collection_name = 'IN_CANT_CUOT') loop
      
        v_cuot_impo_mmnn := round((i.importe * p_movi_tasa_mone),
                                  parameter.p_cant_deci_mmnn);
        v_cuot_sald_mone := i.importe;
        v_cuot_sald_mmnn := round((v_cuot_sald_mone * p_movi_tasa_mone),
                                  parameter.p_cant_deci_mmnn);
      
        v_cuot_fech_venc := i.fecha_vencimiento;
        v_cuot_nume      := i.cuot_nume;
        v_cuot_impo_mone := i.importe;
      
        v_cuot_impo_gaad_mone := v_cuot_impo_mone;
        v_cuot_impo_gaad_mmnn := v_cuot_impo_mmnn;
        v_cuot_sald_gaad_mone := v_cuot_sald_mone;
        v_cuot_sald_gaad_mmnn := v_cuot_sald_mmnn;
      
        pp_inse_come_movi_cuot_pres(v_cuot_fech_venc,
                                    v_cuot_nume,
                                    v_cuot_impo_mone,
                                    v_cuot_impo_mmnn,
                                    v_cuot_impo_mmee,
                                    v_cuot_sald_mone,
                                    v_cuot_sald_mmnn,
                                    v_cuot_sald_mmee,
                                    v_cuot_impo_gaad_mone,
                                    v_cuot_impo_gaad_mmnn,
                                    v_cuot_sald_gaad_mone,
                                    v_cuot_sald_gaad_mmnn,
                                    p_movi_codi);
      
      end loop;
    end if;
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actu_come_movi_cuot_pres;

  procedure PP_INSE_COME_MOVI_CUOT_PRES(p_cuot_fech_venc      in date,
                                        p_cuot_nume           in number,
                                        p_cuot_impo_mone      in number,
                                        p_cuot_impo_mmnn      in number,
                                        p_cuot_impo_mmee      in number,
                                        p_cuot_sald_mone      in number,
                                        p_cuot_sald_mmnn      in number,
                                        p_cuot_sald_mmee      in number,
                                        p_cuot_impo_gaad_mone in number,
                                        p_cuot_impo_gaad_mmnn in number,
                                        p_cuot_sald_gaad_mone in number,
                                        p_cuot_sald_gaad_mmnn in number,
                                        p_cuot_movi_codi      in number) is
  begin
  
    insert into come_movi_cuot_pres
      (cupe_fech_venc,
       CUPE_NUME_CUOT,
       cupe_impo_mone,
       cupe_impo_mmnn,
       cupe_impo_mmee,
       cupe_sald_mone,
       cupe_sald_mmnn,
       cupe_sald_mmee,
       cupe_impo_gaad_mone,
       cupe_impo_gaad_mmnn,
       cupe_sald_gaad_mone,
       cupe_sald_gaad_mmnn,
       cupe_movi_codi,
       cupe_base)
    values
      (p_cuot_fech_venc,
       p_cuot_nume,
       p_cuot_impo_mone,
       p_cuot_impo_mmnn,
       p_cuot_impo_mmee,
       p_cuot_sald_mone,
       p_cuot_sald_mmnn,
       p_cuot_sald_mmee,
       p_cuot_impo_gaad_mone,
       p_cuot_impo_gaad_mmnn,
       p_cuot_sald_gaad_mone,
       p_cuot_sald_gaad_mmnn,
       p_cuot_movi_codi,
       1);
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

  procedure pp_actualiza_come_movi_cuot(p_movi_afec_sald in varchar2,
                                        p_movi_tasa_mone in number,
                                        p_movi_codi      in number) is
    v_cuot_fech_venc date;
    v_cuot_nume      number;
    v_cuot_impo_mone number;
    v_cuot_impo_mmnn number;
    v_cuot_impo_mmee number;
    v_cuot_sald_mone number;
    v_cuot_sald_mmnn number;
    v_cuot_sald_mmee number;
  begin
  
    if rtrim(ltrim(p_movi_afec_sald)) <> 'N' then
    
      for i in (select seq_id,
                       c001   dia,
                       c002   importe,
                       c003   cuot_nume,
                       c006   fecha_vencimiento
                  from apex_collections a
                 where collection_name = 'IN_CANT_CUOT') loop
                 
                   
      
        v_cuot_impo_mmnn := round((i.importe * p_movi_tasa_mone),
                                  parameter.p_cant_deci_mmnn);
        v_cuot_sald_mone := i.importe;
        v_cuot_sald_mmnn := round((i.importe * p_movi_tasa_mone),
                                  parameter.p_cant_deci_mmnn);
      
        v_cuot_fech_venc := i.fecha_vencimiento;
        v_cuot_nume      := i.cuot_nume;
        v_cuot_impo_mone := i.importe;
      
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
           cuot_base)
        values
          (v_cuot_fech_venc,
           v_cuot_nume,
           v_cuot_impo_mone,
           v_cuot_impo_mmnn,
           v_cuot_impo_mmee,
           v_cuot_sald_mone,
           v_cuot_sald_mmnn,
           v_cuot_sald_mmee,
           p_movi_codi,
           1);
      
      end loop;
    end if;
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end pp_actualiza_come_movi_cuot;

  procedure pp_actualizar_moco_inte(p_movi_codi           in number,
                                    p_movi_tasa_mone      in number,
                                    p_movi_mone_cant_deci in number) is
    v_moco_movi_codi      number(20);
    v_moco_nume_item      number(10);
    v_moco_conc_codi      number(10);
    v_moco_cuco_codi      number(10);
    v_moco_impu_codi      number(10);
    v_moco_impo_mmnn      number(20, 4);
    v_moco_impo_mmee      number(20, 4);
    v_moco_impo_mone      number(20, 4);
    v_moco_dbcr           varchar2(1);
    v_moco_base           number(2);
    v_moco_desc           varchar2(2000);
    v_moco_tiim_codi      number(10);
    v_moco_indi_fact_serv varchar2(1);
    v_moco_impo_mone_ii   number(20, 4);
    v_moco_cant           number(20, 4);
    v_moco_cant_pulg      number(20, 4);
    v_moco_ortr_codi      number(20);
    v_moco_movi_codi_padr number(20);
    v_moco_nume_item_padr number(10);
    v_moco_impo_codi      number(20);
    v_moco_ceco_codi      number(20);
    v_moco_orse_codi      number(20);
    v_moco_tran_codi      number(20);
    v_moco_bien_codi      number(20);
    v_moco_tipo_item      varchar2(2);
    v_moco_clpr_codi      number(20);
    v_moco_prod_nume_item number(20);
    v_moco_guia_nume      number(20);
    v_moco_emse_codi      number(4);
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
    v_moco_conc_codi_impu number(10);
    v_moco_tipo           varchar2(2);
    v_moco_prod_codi      number(20);
    v_moco_ortr_codi_fact number(20);
    v_moco_iva10_mmnn     number(20, 4);
    v_moco_iva5_mmnn      number(20, 4);
    v_moco_sofa_sose_codi number(20);
    v_moco_sofa_nume_item number(20);
    v_moco_exen_mone      number(20, 4);
    v_moco_exen_mmnn      number(20, 4);
    v_moco_empl_codi      number(10);
    v_moco_anex_codi      number(20);
    v_moco_lote_codi      number(10);
    v_moco_bene_codi      number(4);
    v_moco_medi_codi      number(10);
    v_moco_cant_medi      number(20, 4);
    v_moco_indi_excl_cont varchar2(1);
    v_moco_anex_nume_item number(10);
    v_moco_juri_codi      number(20);
    v_moco_impo_diar_mone number(20, 4);
    v_moco_coib_codi      number(20);
  
    v_moco_movi_codi_ante number;
  
  begin
  
    v_moco_movi_codi := p_movi_codi;
    v_moco_nume_item := 0;
  
    for i in (select c001 INDI_PROD_ORTR,
                     c002 PROD_CODI_ALFA,
                     c003 PROD_DESC,
                     c004 DETA_CANT_MEDI,
                     c005 tota_item,
                     c009 impu,
                     c010 impu_desc,
                     c011 impu_porc,
                     c012 impu_porc_base_impo,
                     c013 impu_indi_baim_impu_incl,
                     c014 deta_grav_10_ii,
                     c015 deta_grav_5_ii,
                     c016 deta_grav_10,
                     c017 deta_grav_5,
                     c018 deta_iva_10,
                     c019 deta_iva_5,
                     c020 deta_exen,
                     c021 deta_impo_mone,
                     c022 deta_impo_mmnn,
                     c023 deta_iva_mone,
                     c024 deta_iva_mmnn
                from apex_collections a
               where collection_name = 'IN_GASTO_DET') loop
    
      if i.indi_prod_ortr = 'S' then
        v_moco_conc_codi      := i.prod_codi_alfa;
        v_moco_dbcr           := 'D';
        v_moco_indi_fact_serv := 'S';
        v_moco_desc           := i.PROD_DESC;
      end if;
    
      if p_movi_codi is not null then
        v_moco_movi_codi := p_movi_codi;
        if nvl(v_moco_movi_codi_ante, 0) <> v_moco_movi_codi then
          v_moco_nume_item      := 0;
          v_moco_movi_codi_ante := v_moco_movi_codi;
        end if;
      end if;
    
      v_moco_nume_item := v_moco_nume_item + 1;
      v_moco_cuco_codi := null;
      v_moco_impu_codi := i.impu;
    
      begin
        select IMPU_CONC_CODI_IVDB
          into v_moco_conc_codi_impu
          from come_impu
         where impu_codi = v_moco_impu_codi;
      exception
        when others then
          null;
      end;
    
      v_moco_impo_mone_ii := i.tota_item;
      v_moco_impo_mmnn_ii := round(v_moco_impo_mone_ii *
                                   nvl(p_movi_tasa_mone, 1),
                                   nvl(parameter.p_cant_deci_mmnn, 0));
      v_moco_cant         := i.deta_cant_medi;
    
      pa_devu_impo_calc(v_moco_impo_mone_ii,
                        p_movi_mone_cant_deci,
                        i.impu_porc,
                        i.impu_porc_base_impo,
                        i.impu_indi_baim_impu_incl,
                        v_moco_impo_mone_ii,
                        v_moco_grav10_ii_mone,
                        v_moco_grav5_ii_mone,
                        v_moco_grav10_mone,
                        v_moco_grav5_mone,
                        v_moco_iva10_mone,
                        v_moco_iva5_mone,
                        v_moco_exen_mone);
    
      pa_devu_impo_calc(v_moco_impo_mmnn_ii,
                        0,
                        i.impu_porc,
                        i.impu_porc_base_impo,
                        i.impu_indi_baim_impu_incl,
                        v_moco_impo_mmnn_ii,
                        v_moco_grav10_ii_mmnn,
                        v_moco_grav5_ii_mmnn,
                        v_moco_grav10_mmnn,
                        v_moco_grav5_mmnn,
                        v_moco_iva10_mmnn,
                        v_moco_iva5_mmnn,
                        v_moco_exen_mmnn);
    
      v_moco_impo_mmnn := v_moco_exen_mmnn + v_moco_grav10_mmnn +
                          v_moco_grav5_mmnn;
      v_moco_impo_mmee := 0;
      v_moco_impo_mone := v_moco_exen_mone + v_moco_grav10_mone +
                          v_moco_grav5_mone;
    
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
         moco_desc,
         moco_tiim_codi,
         moco_indi_fact_serv,
         moco_impo_mone_ii,
         moco_cant,
         moco_cant_pulg,
         moco_ortr_codi,
         moco_movi_codi_padr,
         moco_nume_item_padr,
         moco_impo_codi,
         moco_ceco_codi,
         moco_orse_codi,
         moco_tran_codi,
         moco_bien_codi,
         moco_tipo_item,
         moco_clpr_codi,
         moco_prod_nume_item,
         moco_guia_nume,
         moco_emse_codi,
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
         moco_conc_codi_impu,
         moco_tipo,
         moco_prod_codi,
         moco_ortr_codi_fact,
         moco_iva10_mmnn,
         moco_iva5_mmnn,
         moco_sofa_sose_codi,
         moco_sofa_nume_item,
         moco_exen_mone,
         moco_exen_mmnn,
         moco_empl_codi,
         moco_anex_codi,
         moco_lote_codi,
         moco_bene_codi,
         moco_medi_codi,
         moco_cant_medi,
         moco_indi_excl_cont,
         moco_anex_nume_item,
         moco_juri_codi,
         moco_impo_diar_mone,
         moco_coib_codi)
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
         v_moco_base,
         v_moco_desc,
         v_moco_tiim_codi,
         v_moco_indi_fact_serv,
         v_moco_impo_mone_ii,
         v_moco_cant,
         v_moco_cant_pulg,
         v_moco_ortr_codi,
         v_moco_movi_codi_padr,
         v_moco_nume_item_padr,
         v_moco_impo_codi,
         v_moco_ceco_codi,
         v_moco_orse_codi,
         v_moco_tran_codi,
         v_moco_bien_codi,
         v_moco_tipo_item,
         v_moco_clpr_codi,
         v_moco_prod_nume_item,
         v_moco_guia_nume,
         v_moco_emse_codi,
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
         v_moco_conc_codi_impu,
         v_moco_tipo,
         v_moco_prod_codi,
         v_moco_ortr_codi_fact,
         v_moco_iva10_mmnn,
         v_moco_iva5_mmnn,
         v_moco_sofa_sose_codi,
         v_moco_sofa_nume_item,
         v_moco_exen_mone,
         v_moco_exen_mmnn,
         v_moco_empl_codi,
         v_moco_anex_codi,
         v_moco_lote_codi,
         v_moco_bene_codi,
         v_moco_medi_codi,
         v_moco_cant_medi,
         v_moco_indi_excl_cont,
         v_moco_anex_nume_item,
         v_moco_juri_codi,
         v_moco_impo_diar_mone,
         v_moco_coib_codi);
    end loop;
  
  end pp_actualizar_moco_inte;

  procedure pp_actualiza_moimpu_2_inte(p_movi_codi in number) is
  
    cursor c_movi_conc is
      select a.moco_movi_codi,
             a.moco_impu_codi,
             a.moco_tiim_codi,
             sum(a.moco_impo_mmnn) moco_impo_mmnn,
             sum(a.moco_impo_mmee) moco_impo_mmee,
             sum(a.moco_impo_mone) moco_impo_mone,
             sum(a.moco_impo_mone_ii) moco_impo_mone_ii,
             sum(a.moco_impo_mmnn_ii) moco_impo_mmnn_ii,
             sum(a.moco_grav10_ii_mone) moco_grav10_ii_mone,
             sum(a.moco_grav10_ii_mmnn) moco_grav10_ii_mmnn,
             sum(a.moco_grav5_ii_mone) moco_grav5_ii_mone,
             sum(a.moco_grav5_ii_mmnn) moco_grav5_ii_mmnn,
             sum(a.moco_grav10_mone) moco_grav10_mone,
             sum(a.moco_grav10_mmnn) moco_grav10_mmnn,
             sum(a.moco_grav5_mone) moco_grav5_mone,
             sum(a.moco_grav5_mmnn) moco_grav5_mmnn,
             sum(a.moco_iva10_mone) moco_iva10_mone,
             sum(a.moco_iva10_mmnn) moco_iva10_mmnn,
             sum(a.moco_iva5_mone) moco_iva5_mone,
             sum(a.moco_iva5_mmnn) moco_iva5_mmnn,
             sum(a.moco_exen_mone) moco_exen_mone,
             sum(a.moco_exen_mmnn) moco_Exen_mmnn
        from come_movi_conc_deta a
       where a.moco_movi_codi = p_movi_codi
       group by a.moco_movi_codi, a.moco_impu_codi, a.moco_tiim_codi
       order by a.moco_movi_codi, a.moco_impu_codi, a.moco_tiim_codi;
  
  begin
    for x in c_movi_conc loop
    
      -- v_moim_base           := :parameter.p_Codi_base;
    
      pp_insert_come_movi_impu_deta(x.moco_impu_codi,
                                    x.moco_movi_codi,
                                    x.moco_impo_mmnn,
                                    null,
                                    x.moco_iva10_mmnn + x.moco_iva5_mmnn,
                                    null,
                                    x.moco_impo_mone,
                                    x.moco_iva10_mone + x.moco_iva5_mone,
                                    1,
                                    x.moco_tiim_codi,
                                    x.moco_impo_mone_ii,
                                    x.moco_impo_mmnn_ii,
                                    x.moco_grav10_ii_mone,
                                    x.moco_grav5_ii_mone,
                                    x.moco_grav10_ii_mmnn,
                                    x.moco_grav5_ii_mmnn,
                                    x.moco_grav10_mone,
                                    x.moco_grav5_mone,
                                    x.moco_grav10_mmnn,
                                    x.moco_grav5_mmnn,
                                    x.moco_iva10_mone,
                                    x.moco_iva5_mone,
                                    x.moco_iva10_mmnn,
                                    x.moco_iva5_mmnn,
                                    x.moco_exen_mone,
                                    x.moco_exen_mmnn);
    end loop;
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
  end;

  procedure pp_insert_come_movi_impu_deta(p_moim_impu_codi      in number,
                                          p_moim_movi_codi      in number,
                                          p_moim_impo_mmnn      in number,
                                          p_moim_impo_mmee      in number,
                                          p_moim_impu_mmnn      in number,
                                          p_moim_impu_mmee      in number,
                                          p_moim_impo_mone      in number,
                                          p_moim_impu_mone      in number,
                                          p_moim_base           in number,
                                          p_moim_tiim_codi      in number,
                                          p_moim_impo_mone_ii   in number,
                                          p_moim_impo_mmnn_ii   in number,
                                          p_moim_grav10_ii_mone in number,
                                          p_moim_grav5_ii_mone  in number,
                                          p_moim_grav10_ii_mmnn in number,
                                          p_moim_grav5_ii_mmnn  in number,
                                          p_moim_grav10_mone    in number,
                                          p_moim_grav5_mone     in number,
                                          p_moim_grav10_mmnn    in number,
                                          p_moim_grav5_mmnn     in number,
                                          p_moim_iva10_mone     in number,
                                          p_moim_iva5_mone      in number,
                                          p_moim_iva10_mmnn     in number,
                                          p_moim_iva5_mmnn      in number,
                                          p_moim_exen_mone      in number,
                                          p_moim_exen_mmnn      in number) is
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
      (p_moim_impu_codi,
       p_moim_movi_codi,
       p_moim_impo_mmnn,
       p_moim_impo_mmee,
       p_moim_impu_mmnn,
       p_moim_impu_mmee,
       p_moim_impo_mone,
       p_moim_impu_mone,
       p_moim_base,
       p_moim_tiim_codi,
       p_moim_impo_mone_ii,
       p_moim_impo_mmnn_ii,
       p_moim_grav10_ii_mone,
       p_moim_grav5_ii_mone,
       p_moim_grav10_ii_mmnn,
       p_moim_grav5_ii_mmnn,
       p_moim_grav10_mone,
       p_moim_grav5_mone,
       p_moim_grav10_mmnn,
       p_moim_grav5_mmnn,
       p_moim_iva10_mone,
       p_moim_iva5_mone,
       p_moim_iva10_mmnn,
       p_moim_iva5_mmnn,
       p_moim_exen_mone,
       p_moim_exen_mmnn);
  end;

  procedure pp_actu_secu_inte(p_indi          in char,
                              p_movi_nume     in number,
                              p_timo_calc_iva in varchar2,
                              p_peco_codi     in number) is
  begin
  
    if p_indi = 'S' then
      if nvl(p_timo_calc_iva, 'N') = 'N' then
        update come_secu
           set secu_nume_fact_negr = p_movi_nume
         where secu_codi = (select peco_secu_codi
                              from come_pers_comp
                             where peco_codi = p_peco_codi);
      
      else
      
        update come_secu
           set secu_nume_fact = p_movi_nume
         where secu_codi = (select peco_secu_codi
                              from come_pers_comp
                             where peco_codi = p_peco_codi);
      
      end if;
    end if;
  end pp_actu_secu_inte;




procedure pp_valida_ruc(p_nume_docu in varchar2, p_tipo_docu in varchar2, p_clpr_codi in number) is
  v_count number;
  v_ruc   number;
  v_dv    number;
  v_dv2   number;
  v_nro   varchar2(20);
  
  e_dig_inco exception;
  e_vali_ruc exception;
  e_digi_alfa exception;
begin
	begin
    select count(*)
      into v_count
      from come_clie_prov
     where clpr_ruc = p_nume_docu
       and (p_clpr_codi is null or p_clpr_codi <> clpr_codi)
       and clpr_indi_clie_prov = 'C';
       
     select count(*)
     into v_count
    from come_clie_prov a
   where a.clpr_indi_clie_prov = 'C'
    and (p_clpr_codi is null or p_clpr_codi <> clpr_codi)
     and REGEXP_REPLACE(CASE WHEN INSTR(a.clpr_ruc, '-') > 0 THEN
                             SUBSTR(a.clpr_ruc, 1, INSTR(a.clpr_ruc, '-') - 1)
                            ELSE
                             a.clpr_ruc
                          END,'[^0-9]','') = REGEXP_REPLACE(CASE WHEN INSTR(p_nume_docu, '-') > 0 THEN
                                                                SUBSTR(p_nume_docu, 1, INSTR(p_nume_docu, '-') - 1)
                                                                 ELSE
                                                                  p_nume_docu
                                                               END, '[^0-9]','');
  
       
       
       
  
    if v_count > 0 and nvl(p_nume_docu, '-1') <> '44444401-7' then
     raise_application_error(-20001,'Atencion!!! El numero de ' ||
            nvl(p_tipo_docu, 'R.U.C.') ||
            ' ingresado se encuentra asignado a otro Cliente');
    end if;
  
  exception
    when no_data_found then
      null;
 
   /* when others then
    raise_application_error(-20001,'Error1');*/
  end;

  if upper(p_tipo_docu) = upper('ruc') then
    begin
      v_nro := substr(rtrim(ltrim(p_nume_docu)), 1, length(rtrim(ltrim(p_nume_docu))) - 2);
      v_ruc := to_number(v_nro);
    
      begin
        if p_nume_docu is not null then
          v_ruc := substr(rtrim(ltrim(p_nume_docu)), 1, length(rtrim(ltrim(p_nume_docu))) - 2);
          v_dv  := substr(rtrim(ltrim(p_nume_docu)), length(rtrim(ltrim(p_nume_docu))), 1);
          v_dv2 := Pa_Calcular_Dv_11_A(v_ruc);
        
          if v_dv <> v_dv2 then
            raise e_dig_inco;
--            pl_me('Atenci?n!!!! Digito verificador incorrecto!!');
          end if;
        end if;
      
      exception
        when others then
          --pl_me('Error al validar el RUC, Favor verifique!!!');
          raise e_vali_ruc;
      end;
    
    exception
      when others then
        -- el ruc tiene algun digito alfanumerico
        null; --pl_me(sqlerrm);
        --pl_me('Atencion! Ruc con digito alfanum?rico, verifique el RUC si esta correcto!.');
        raise e_digi_alfa;
    end;
  
  elsif upper(p_tipo_docu) = upper('ci') then
    begin
      select to_number(rtrim(ltrim(p_nume_docu)))
        into v_ruc
        from dual;
    exception
      when invalid_number then
         raise_application_error(-20001,'Para Tipo de Documento C.I. debe ingresar solo numeros');
     
      when others then
         raise_application_error(-20001,'Error2');
    end;
  
  end if;
exception
	when e_dig_inco then
		 raise_application_error(-20001,'Atenci?n!!!! Digito verificador incorrecto!!');
	when e_vali_ruc then
		 raise_application_error(-20001,'Error al validar el RUC, Favor verifique!!!');
	when e_digi_alfa then
		 raise_application_error(-20001,'Atencion! Ruc con digito alfanum?rico, verifique el RUC si esta correcto!.');
end;



end i010346;
