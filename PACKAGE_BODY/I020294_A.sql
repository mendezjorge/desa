
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020294_A" is

  type r_parameter is record(
    p_usuario                  varchar2(100) := fp_user,
    p_empr_codi                number := 1,
    p_codi_base                number := pack_repl.fa_devu_codi_base,
    p_indi_most_mens_sali      varchar(200) := ltrim(rtrim((general_skn.fl_busca_parametro('p_indi_most_mens_sali')))),
    p_codi_tipo_empl_vend      varchar(200) := ltrim(rtrim((general_skn.fl_busca_parametro('p_codi_tipo_empl_vend')))),
    p_impo_mone_anex_rein_vehi number := to_number(general_skn.fl_busca_parametro('p_impo_mone_anex_rein_vehi')),
    p_conc_codi_anex_rein_vehi number := to_number(general_skn.fl_busca_parametro('p_conc_codi_anex_rein_vehi')),
    p_conc_codi_serv_moni_anua number := to_number(general_skn.fl_busca_parametro('p_conc_codi_serv_moni_anua')),
    p_conc_codi_serv_moni_mens number := to_number(general_skn.fl_busca_parametro('p_conc_codi_serv_moni_mens')),
    p_conc_codi_anex_grua_vehi number := to_number(general_skn.fl_busca_parametro('p_conc_codi_anex_grua_vehi')),
    p_prec_unit_anex_grua_vehi number := to_number(general_skn.fl_busca_parametro('p_prec_unit_anex_grua_vehi')));
  parameter r_parameter;

  procedure pp_mostrar_datos(p_sode_clpr_codi      in number,
                             p_clpr_desc           out varchar2,
                             p_clpr_codi_alte      out number,
                             p_sode_sucu_nume_item in number,
                             p_sucu_desc           out varchar2,
                             p_sode_codi           in number,
                             p_anex_nume           out varchar2,
                             p_sose_nume           out varchar2,
                             p_deta_iden           out varchar2,
                             p_deta_nume_pate      out varchar2,
                             p_deta_mode           out varchar2,
                             p_mensaje             out varchar2) is
  begin
  
    ---traer los datos del cliente
    if p_sode_clpr_codi is not null then
      pp_muestra_come_clie_prov(p_sode_clpr_codi,
                                p_clpr_desc,
                                p_clpr_codi_alte);
    end if;
  
    ---traer los datos del subcuenta
    if p_sode_sucu_nume_item is not null then
      pp_muestra_come_clpr_sub_cuen(p_sode_clpr_codi,
                                    p_sode_sucu_nume_item,
                                    p_sucu_desc);
    end if;
  
    ---traer los datos del vehiculo y servicios
    -- raise_application_error(-20001,'lalala, solin ot--'||p_sode_codi); 
    if p_sode_codi is not null then
      pp_muestra_come_soli_serv_anex(p_sode_codi,
                                     p_anex_nume,
                                     p_sose_nume,
                                     p_deta_iden,
                                     p_deta_nume_pate,
                                     p_deta_mode);
    end if;
  
    ---validar ot
  
    i020294_a.pp_veri_ot_sode(p_sode_codi, p_mensaje);
  
    --  raise_application_error(-20001,'lalala, solin solito--'); 
  
  end pp_mostrar_datos;

  procedure pp_muestra_come_clie_prov(p_clpr_codi      in number,
                                      p_clpr_desc      out varchar2,
                                      p_clpr_codi_alte out number) is
  begin
    select clpr_desc, clpr_codi_alte
      into p_clpr_desc, p_clpr_codi_alte
      from come_clie_prov
     where clpr_codi = p_clpr_codi;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Cliente Inexistente');
  end pp_muestra_come_clie_prov;

  procedure pp_muestra_come_clpr_sub_cuen(p_clpr_codi      in number,
                                          p_sucu_nume_item in number,
                                          p_sucu_desc      out varchar2) is
  begin
    select sucu_desc
      into p_sucu_desc
      from come_clpr_sub_cuen
     where sucu_clpr_codi = p_clpr_codi
       and sucu_nume_item = p_sucu_nume_item;
  exception
    when no_data_found then
      raise_application_error(-20001, 'SubCuenta Inexistente');
  end pp_muestra_come_clpr_sub_cuen;

  procedure pp_muestra_come_soli_serv_anex(p_sode_codi      in number,
                                           p_anex_nume      out varchar2,
                                           p_sose_nume      out varchar2,
                                           p_deta_iden      out varchar2,
                                           p_deta_nume_pate out varchar2,
                                           p_deta_mode      out varchar2) is
  begin
  
    select anex_nume,
           sose_nume,
           vehi_iden      deta_iden,
           vehi_nume_pate deta_nume_pate,
           vehi_mode      deta_mode
      into p_anex_nume,
           p_sose_nume,
           p_deta_iden,
           p_deta_nume_pate,
           p_deta_mode
      from come_soli_desi,
           come_soli_serv,
           come_soli_serv_anex,
           come_soli_serv_anex_deta d,
           come_vehi
     where sode_vehi_codi = vehi_codi
       and vehi_codi = deta_vehi_codi
       and deta_anex_codi = anex_codi
       and anex_sose_codi = sose_codi
       and sode_codi = p_sode_codi
       and anex_codi = (select max(anex_codi)
                          from come_soli_desi,
                               come_soli_serv,
                               come_soli_serv_anex,
                               come_soli_serv_anex_deta d,
                               come_vehi
                         where sode_vehi_codi = vehi_codi
                           and vehi_codi = deta_vehi_codi
                           and deta_anex_codi = anex_codi
                           and anex_sose_codi = sose_codi
                           and sode_codi = p_sode_codi);
  
  exception
    when no_data_found then
      raise_application_error(-20001,
                              'Solicitud de Desinstalaci?n Inexistente');
    when others then
      raise_application_error(-20001, 'Error ' || sqlerrm);
  end pp_muestra_come_soli_serv_anex;

  procedure pp_actualizar_registro(p_sode_codi           in number,
                                   p_sode_esta           in varchar2,
                                   p_sode_esta_orig      in varchar2,
                                   p_sode_user_modi      in varchar2,
                                   p_sode_fech_modi      in varchar2,
                                   p_sode_clpr_codi      in number,
                                   p_sode_tipo_moti      in varchar2,
                                   p_sode_sucu_nume_item in number,
                                   p_sode_vehi_codi      in number,
                                   p_sode_deta_codi      in number,
                                   p_sode_nume           in number,
                                   p_sode_fech_emis      in varchar2,
                                   p_sode_user_regi      in varchar2,
                                   p_deta_iden           in varchar2) is
  
  begin
    
  
    -- Validar datos
    i020294_a.pp_validar(p_sode_codi, p_sode_esta, p_sode_esta_orig);
  
    update come_soli_desi f
       set sode_base      = parameter.p_codi_base,
           sode_esta      = nvl(p_sode_esta, 'P'),
           sode_user_modi = case
                              when p_sode_esta_orig <> p_sode_esta then
                               parameter.p_usuario
                              else
                               f.sode_user_modi
                            end,
           sode_fech_modi = case
                              when p_sode_esta_orig <> p_sode_esta then
                               sysdate
                              else
                               f.sode_fech_modi
                            end
     where f.sode_codi = p_sode_codi;
     
                         
       
    i020294_a.pp_generar_mensaje(p_sode_clpr_codi      => p_sode_clpr_codi,
                                 p_sode_tipo_moti      => p_sode_tipo_moti,
                                 p_sode_sucu_nume_item => p_sode_sucu_nume_item,
                                 p_sode_codi           => p_sode_codi,
                                 p_sode_vehi_codi      => p_sode_vehi_codi,
                                 p_sode_deta_codi      => p_sode_deta_codi,
                                 p_sode_nume           => p_sode_nume,
                                 p_sode_fech_emis      => p_sode_fech_emis,
                                 p_sode_user_regi      => p_sode_user_regi,
                                 p_sode_user_modi      => p_sode_user_modi,
                                 p_sode_esta           => p_sode_esta,
                                 p_deta_iden           => p_deta_iden);
  
    apex_application.g_print_success_message := 'Nro. Solicitud :' ||
                                                p_sode_nume ||
                                                ' ,Actualizado Correctamente';
 
/*if fp_user = 'SKN' THEN
      
    RAISE_APPLICATION_ERROR(-20001,'FINAL');
    END IF; */                          
  exception
    when others then
      raise_application_error(-20001, 'Error ' || sqlerrm);
  end pp_actualizar_registro;

  procedure pp_veri_ot_sode(p_sode_codi in number, p_mensaje out varchar2) is
  
    v_ortr_nume      number;
    v_ortr_desc      varchar2(500);
    v_ortr_codi_padr number;
  
  begin
  
    select ortr_nume, ortr_desc, ortr_codi_padr
      into v_ortr_nume, v_ortr_desc, v_ortr_codi_padr
      from come_orde_trab t
     where ortr_sode_codi = p_sode_codi;
  
    if v_ortr_codi_padr is not null then
      p_mensaje := 'No se podr?n realizar cambios a la Solicitud, porque fue generada desde la OT ' ||
                   v_ortr_nume || ' por ' || v_ortr_desc;
    
      /* if get_item_property('bpie.aceptar', enabled) = 'TRUE' then
        set_item_property('bpie.aceptar', enabled, property_false);
      end if;*/
      --else
      /*if get_item_property('bpie.aceptar', enabled) = 'FALSE' then
        set_item_property('bpie.aceptar', enabled, property_true);
        set_item_property('bpie.aceptar', navigable, property_true);
      end if;   */
    end if;
    p_mensaje :=null;
  
  exception
    when no_data_found then
      null;
  end pp_veri_ot_sode;

  procedure pp_validar(p_sode_codi      in number,
                       p_sode_esta      in varchar2,
                       p_sode_esta_orig in varchar2) is
    --V_COUNT NUMBER := 0;
  begin
   
    if p_sode_esta <> p_sode_esta_orig then
      if p_sode_esta = 'L' then
        raise_application_error(-20001,
                                'No se puede Liquidar una solicitud de Desinstalaci?n desde ?ste programa!');
      
      elsif p_sode_esta = 'P' then
        /*select count(*)
          into v_count
          from come_orde_trab
         where ortr_sode_codi = :babmc.sode_codi;
        
        if v_count > 0 then 
          pl_me('Existen '||v_count||' ordenes de trabajo que tienen asignados esta solicitud de desinstalacion.');
        end if;*/
      
        pp_eliminar_anex_ot(p_sode_codi);
      
      end if;
    end if;
  end pp_validar;

  procedure pp_eliminar_anex_ot(p_sode_codi in number) is
  
    /*cursor c_deta is
    select d.deta_codi
      from come_soli_serv_anex_deta d
     where d.deta_anex_codi = p_anex_codi;*/
  
    cursor c_ortr is --(p_deta_codi in number) is
      select o.ortr_codi
        from come_orde_trab o
       where o.ortr_sode_codi = p_sode_codi;
  
    v_cant      number;
    v_cout      number;
    v_codigo    number;
    v_movi_codi number;
  begin
   
    for y in c_ortr loop
      begin
        select count(*)
          into v_cant
          from come_orde_trab
         where ortr_codi = y.ortr_codi
           and (ortr_esta = 'L' or ortr_esta_pre_liqu = 'S');
      
        if v_cant > 0 then
          raise_application_error(-20001,
                                  'No se puede cambiar estado de la Solicitud, posee OT que ya se encuentran Pre-liquidadas o Liquidadas!.');
        end if;
      
        begin
          select count(*), max(h.ctn_codi) codigo
            into v_cout, v_codigo
            from crm_neg_ticket h
           where h.ctn_ortr_codi = y.ortr_codi;
        end;
      
        if v_cout > 0 then
          delete from crm_neg_ticket h where h.ctn_ortr_codi = y.ortr_codi;
        
          -- raise_application_error(-20001,'No se puede cambiar estado de la Solicitud, El orden de trabajo esta relacionado con una negociacion. Nro de Negociacio '||v_codigo);
        end if;
      
      end;
    
      -----------------------desde aqui***lv 19-04-2023
      begin
      
        --into v_movi_codi
        for c_movi in (select movi_codi
                         from come_movi a
                        where movi_ortr_codi = y.ortr_codi) loop
      
          delete come_movi_prod_deta
           where deta_movi_codi = c_movi.movi_codi;
           
           
          delete come_movi a where a.movi_codi = c_movi.movi_codi;
        
        
        end loop;
      
      exception
        when no_data_found then
          null;
      end;
      ------------------------------------ hasta aqui***lv 19-04-2023  
  
      delete come_comi_inst_alar t where t.coin_ortr_codi = y.ortr_codi;
      delete come_orde_trab_vehi where vehi_ortr_codi = y.ortr_codi;
      delete come_orde_trab_cont where cont_ortr_codi = y.ortr_codi;
      delete come_orde_trab where ortr_codi = y.ortr_codi;
    end loop;
  
  end pp_eliminar_anex_ot;

  procedure pp_generar_mensaje(p_sode_clpr_codi      in number,
                               p_sode_tipo_moti      in varchar2,
                               p_sode_sucu_nume_item in number,
                               p_sode_codi           in number,
                               p_sode_vehi_codi      in number,
                               p_sode_deta_codi      in number,
                               p_sode_nume           in number,
                               p_sode_fech_emis      in varchar2,
                               p_sode_user_regi      in varchar2,
                               p_sode_user_modi      in varchar2,
                               p_sode_esta           in varchar2,
                               p_deta_iden           in varchar2) is
    v_ortr_codi number;
    v_ortr_nume number;
    v_clpr_desc varchar2(100);
    v_count     number;
  
    --v_ortr_deta_codi number;
    --v_ortr_vehi_iden varchar2(100);
    v_anex_codi number;
    v_sose_codi number;
    --v_sode_codi      number;
    v_deta_codi_vehi number;
  begin
    if p_sode_esta = 'A' then
      select count(*)
        into v_count
        from come_orde_trab
       where ortr_sode_codi = p_sode_codi;
    
    
      --por cada vehiculo debe generar una OT
      if v_count = 0 then
     
        v_ortr_codi := fa_sec_come_orde_trab;
        begin
          select nvl(max(to_number(ortr_nume)), 0) + 1
            into v_ortr_nume
            from come_orde_trab;
        end;
      
        -- inserta la OT
        insert into come_orde_trab
          (ortr_codi,
           ortr_clpr_codi,
           ortr_nume,
           ortr_fech_emis,
           ortr_fech_grab,
           ortr_user,
           ortr_esta,
           ortr_desc,
           ortr_base,
           ortr_sucu_codi,
           ortr_mone_codi_prec,
           ortr_prec_vent,
           ortr_tipo_cost_tran,
           ortr_serv_tipo,
           ortr_serv_tipo_moti,
           ortr_serv_cate,
           ortr_serv_dato,
           ortr_user_regi,
           ortr_fech_regi,
           ortr_clpr_sucu_nume_item,
           ortr_sode_codi,
           ortr_vehi_codi,
           ortr_cant,
           ortr_deta_codi)
        values
          (v_ortr_codi,
           p_sode_clpr_codi,
           v_ortr_nume,
           to_date(sysdate, 'dd-mm-yyyy'),
           sysdate,
           parameter.p_usuario,
           'P',
           'Desinstalacion',
           1,
           1,
           1,
           0,
           1,
           'D',
           p_sode_tipo_moti,
           'P',
           'K',
           parameter.p_usuario,
           sysdate,
           p_sode_sucu_nume_item,
           p_sode_codi,
           p_sode_vehi_codi,
           null,
           p_sode_deta_codi);
   
 
     
        begin
          select c.clpr_desc
            into v_clpr_desc
            from come_clie_prov c
           where c.clpr_codi = p_sode_clpr_codi;
        exception
          when others then
            v_clpr_desc := null;
        end;
      
    
        if p_sode_sucu_nume_item is not null then
          v_clpr_desc := v_clpr_desc || '; SubCuenta (' ||
                         p_sode_sucu_nume_item || ')';
        end if;
      
        -- inserta el mensaje
        insert into come_mens_sist
          (mesi_codi,
           mesi_desc,
           mesi_user_dest,
           mesi_user_envi,
           mesi_fech,
           mesi_indi_leid,
           mesi_tipo_docu,
           mesi_docu_codi)
        values
          (sec_come_mens_sist.nextval,
           ('Se ha autorizado la solicitud de desinstalaci?n Nro. ' ||
           p_sode_nume || ' para el cliente ' || v_clpr_desc ||
           ', con fecha de emisi?n ' || p_sode_fech_emis || '.'),
           p_sode_user_regi,
           p_sode_user_modi,
           sysdate,
           'N',
           null,
           null);
      
        -- si es una reinstalacion al instante
        if p_sode_tipo_moti = 'RN' then
          --v_ortr_deta_codi := :babmc.sode_deta_codi;
          -- v_ortr_vehi_iden := p_deta_iden;
          --  v_sode_codi      := p_sode_codi;
        
          pp_generar_anex_rein(p_sode_deta_codi, --in
                               p_deta_iden, --in
                               v_anex_codi, --out
                               v_sose_codi, --out
                               v_deta_codi_vehi --out
                               );
        
          pp_generar_vehi(p_sode_codi, --in
                          v_sose_codi, --in
                          p_sode_deta_codi, --in
                          v_deta_codi_vehi, --in
                          p_sode_vehi_codi --in
                          );
          /*
          pp_generar_ot_rein(v_anex_codi, --in
                             v_sose_codi  --in
                             );*/
        end if;
      end if;
      
      else
 
       update come_orde_trab o
         set o.ORTR_SERV_TIPO_MOTI=p_sode_tipo_moti
       where o.ortr_sode_codi = p_sode_codi ;
       
       
 
      
    end if;
  end pp_generar_mensaje;

  procedure pp_generar_anex_rein(p_ortr_deta_codi in number,
                                 p_ortr_vehi_iden in varchar2,
                                 p_anex_codi      out number,
                                 p_sose_codi      out number,
                                 p_deta_codi_vehi out number) is
  
    v_anex_codi           number;
    v_anex_sose_codi      number;
    v_anex_nume           number;
    v_anex_dura_cont      number;
    v_anex_mone_codi      number;
    v_anex_tasa_mone      number;
    v_anex_impo_mone      number;
    v_anex_impo_mmnn      number;
    v_anex_prec_unit      number;
    v_anex_equi_prec      number;
    v_anex_fech_venc      date;
    v_anex_fech_inic_vige date;
    v_anex_nume_poli      varchar2(40);
    v_anex_nume_orde_serv varchar2(20);
    v_anex_fech_inic_poli date;
    v_anex_fech_fini_poli date;
  
    v_vehi_iden                varchar2(60);
    v_deta_nume_item           number(10);
    v_deta_base                number(10);
    v_deta_calc_gran           varchar2(1);
    v_deta_calc_pequ           varchar2(1);
    v_deta_ning_calc           varchar2(1);
    v_deta_indi_moni           varchar2(1);
    v_deta_indi_nexo_recu      varchar2(1);
    v_deta_indi_para_moto      varchar2(1);
    v_deta_indi_boto_esta      varchar2(1);
    v_deta_indi_acce_aweb      varchar2(1);
    v_deta_indi_roam           varchar2(1);
    v_deta_indi_boto_pani      varchar2(1);
    v_deta_indi_mant_equi      varchar2(1);
    v_deta_indi_cort_corr_auto varchar2(1);
    v_deta_tipo_roam           varchar2(1);
    v_deta_roam_fech_inic_vige date;
    v_deta_roam_fech_fini_vige date;
    v_deta_esta_vehi           varchar2(1);
    v_deta_esta                varchar2(1);
    v_deta_iden_ante           varchar2(60);
    v_deta_fech_vige_inic      date;
    v_deta_fech_vige_fini      date;
    v_vehi_codi                number(20);
    v_deta_indi_sens_tapa_tanq varchar2(1);
    v_deta_indi_sens_comb      varchar2(1);
    v_deta_indi_sens_temp      varchar2(1);
    v_deta_indi_aper_puer      varchar2(1);
    v_deta_impo_mone           number(20, 4);
    v_deta_esta_plan           varchar2(1);
    v_deta_indi_anex_vehi      varchar2(1);
    v_deta_indi_anex_requ_vehi varchar2(1);
    v_deta_indi_anex_requ_fech varchar2(1);
    v_deta_indi_anex_modu      varchar2(1);
    v_deta_indi_anex_sele_modu varchar2(1);
    v_deta_codi                number(10);
    v_deta_conc_codi           number(10);
    --v_deta_anex_codi_padr      number(10);
    v_deta_prec_unit number(20, 4);
    v_vehi_indi_grua varchar2(1);
  
    v_anex_codi_padr number;
    v_deta_codi_padr number;
    v_sose_tipo_fact varchar2(10);
    v_sose_tasa_mone number;
  
    v_deta_codi_anex_padr number(20);
  
  begin
    --recuperar datos de cabecera de anexo
    begin
      select anex_codi,
             anex_sose_codi,
             anex_dura_cont,
             nvl(anex_mone_codi, s.sose_mone_codi) anex_mone_codi,
             anex_tasa_mone,
             anex_impo_mone,
             anex_impo_mmnn,
             anex_prec_unit,
             anex_equi_prec,
             anex_fech_venc,
             anex_fech_inic_vige,
             anex_nume_poli,
             anex_nume_orde_serv,
             anex_fech_inic_poli,
             anex_fech_fini_poli,
             sose_tipo_fact,
             nvl(sose_tasa_mone, 1)
        into v_anex_codi_padr,
             v_anex_sose_codi,
             v_anex_dura_cont,
             v_anex_mone_codi,
             v_anex_tasa_mone,
             v_anex_impo_mone,
             v_anex_impo_mmnn,
             v_anex_prec_unit,
             v_anex_equi_prec,
             v_anex_fech_venc,
             v_anex_fech_inic_vige,
             v_anex_nume_poli,
             v_anex_nume_orde_serv,
             v_anex_fech_inic_poli,
             v_anex_fech_fini_poli,
             v_sose_tipo_fact,
             v_sose_tasa_mone
        from come_soli_serv           s,
             come_soli_serv_anex      a,
             come_soli_serv_anex_deta ad
       where s.sose_codi = a.anex_sose_codi
         and a.anex_codi = ad.deta_anex_codi
         and ad.deta_codi = p_ortr_deta_codi;
    end;
  
    p_sose_codi := v_anex_sose_codi;
  
    begin
      select nvl(max(anex_codi), 0) + 1
        into v_anex_codi
        from come_soli_serv_anex;
    exception
      when no_data_found then
        v_anex_codi := 1;
    end;
  
    p_anex_codi := v_anex_codi;
  
    begin
      select nvl(max(anex_nume), 0) + 1
        into v_anex_nume
        from come_soli_serv_anex
       where anex_sose_codi = v_anex_sose_codi;
    exception
      when no_data_found then
        v_anex_nume := 1;
    end;
  
    --insertar cabecera de anexo
    insert into come_soli_serv_anex
      (anex_empr_codi,
       anex_codi,
       anex_sose_codi,
       anex_nume,
       anex_fech_emis,
       anex_fech_venc,
       anex_fech_inic_vige,
       anex_base,
       anex_user_regi,
       anex_fech_regi,
       anex_user_modi,
       anex_fech_modi,
       anex_esta,
       anex_dura_cont,
       anex_mone_codi,
       anex_tasa_mone,
       anex_impo_mone,
       anex_impo_mmnn,
       anex_prec_unit,
       anex_entr_inic,
       anex_cant_movi,
       anex_tipo,
       anex_equi_prec,
       anex_impo_mone_unic,
       anex_nume_poli,
       anex_nume_orde_serv,
       anex_fech_inic_poli,
       anex_fech_fini_poli,
       anex_nume_refe,
       anex_cant_cuot_modu,
       anex_indi_fact_impo_unic,
       anex_user_auto,
       anex_fech_auto)
    values
      (nvl(parameter.p_empr_codi, 1),
       v_anex_codi,
       v_anex_sose_codi,
       v_anex_nume,
       trunc(sysdate), --ortr_fech_inst pendiente hacer update al liquidar ot
       v_anex_fech_venc,
       v_anex_fech_inic_vige,
       nvl(parameter.p_codi_base, 1),
       parameter.p_usuario,
       sysdate,
       null,
       null,
       'P', -- 'A', --ya se inserta autorizado
       v_anex_dura_cont,
       v_anex_mone_codi,
       v_anex_tasa_mone,
       v_anex_impo_mone,
       v_anex_impo_mmnn,
       v_anex_prec_unit,
       0,
       1,
       'RI',
       v_anex_equi_prec,
       nvl(parameter.p_impo_mone_anex_rein_vehi, 70000),
       v_anex_nume_poli,
       v_anex_nume_orde_serv,
       v_anex_fech_inic_poli,
       v_anex_fech_fini_poli,
       v_anex_nume,
       null,
       'N',
       parameter.p_usuario,
       sysdate);
  
    --recuperar datos de detalle de anexo, del vehiculo a reinstalar
    begin
      select deta_iden,
             deta_base,
             deta_calc_gran,
             deta_calc_pequ,
             deta_ning_calc,
             deta_indi_moni,
             deta_indi_nexo_recu,
             deta_indi_para_moto,
             deta_indi_boto_esta,
             deta_indi_acce_aweb,
             deta_indi_roam,
             deta_indi_boto_pani,
             deta_indi_mant_equi,
             deta_indi_cort_corr_auto,
             deta_tipo_roam,
             deta_roam_fech_inic_vige,
             deta_roam_fech_fini_vige,
             deta_esta_vehi,
             deta_esta,
             deta_iden_ante,
             deta_fech_vige_inic,
             deta_fech_vige_fini,
             deta_vehi_codi,
             deta_indi_sens_tapa_tanq,
             deta_indi_sens_comb,
             deta_indi_sens_temp,
             deta_indi_aper_puer,
             deta_impo_mone,
             deta_esta_plan,
             deta_indi_anex_vehi,
             deta_indi_anex_requ_vehi,
             deta_indi_anex_requ_fech,
             deta_indi_anex_modu,
             deta_indi_anex_sele_modu,
             deta_codi,
             deta_conc_codi,
             deta_prec_unit,
             vehi_indi_grua
        into v_vehi_iden,
             v_deta_base,
             v_deta_calc_gran,
             v_deta_calc_pequ,
             v_deta_ning_calc,
             v_deta_indi_moni,
             v_deta_indi_nexo_recu,
             v_deta_indi_para_moto,
             v_deta_indi_boto_esta,
             v_deta_indi_acce_aweb,
             v_deta_indi_roam,
             v_deta_indi_boto_pani,
             v_deta_indi_mant_equi,
             v_deta_indi_cort_corr_auto,
             v_deta_tipo_roam,
             v_deta_roam_fech_inic_vige,
             v_deta_roam_fech_fini_vige,
             v_deta_esta_vehi,
             v_deta_esta,
             v_deta_iden_ante,
             v_deta_fech_vige_inic,
             v_deta_fech_vige_fini,
             v_vehi_codi,
             v_deta_indi_sens_tapa_tanq,
             v_deta_indi_sens_comb,
             v_deta_indi_sens_temp,
             v_deta_indi_aper_puer,
             v_deta_impo_mone,
             v_deta_esta_plan,
             v_deta_indi_anex_vehi,
             v_deta_indi_anex_requ_vehi,
             v_deta_indi_anex_requ_fech,
             v_deta_indi_anex_modu,
             v_deta_indi_anex_sele_modu,
             v_deta_codi_padr,
             v_deta_conc_codi,
             v_deta_prec_unit,
             v_vehi_indi_grua
        from come_soli_serv_anex_deta, come_vehi
       where deta_vehi_codi = vehi_codi(+)
         and deta_codi = p_ortr_deta_codi;
    end;
  
    --segun tipo de factura, selecciona el codigo de concepto por instalacion de monitoreo
    if v_sose_tipo_fact = 'C' then
      v_deta_conc_codi := parameter.p_conc_codi_serv_moni_anua;
    else
      v_deta_conc_codi := parameter.p_conc_codi_serv_moni_mens;
    end if;
  
    --recupera datos de indicadores de concepto
    begin
      select nvl(conc_indi_anex_requ_vehi, 'V'),
             nvl(conc_indi_anex_requ_fech, 'N'),
             nvl(conc_indi_anex_modu, 'N'),
             nvl(conc_indi_anex_sele_modu, 'N')
        into v_deta_indi_anex_requ_vehi,
             v_deta_indi_anex_requ_fech,
             v_deta_indi_anex_modu,
             v_deta_indi_anex_sele_modu
        from come_conc
       where conc_codi = v_deta_conc_codi;
    end;
  
    v_deta_codi      := fa_sec_soli_serv_anex_deta;
    v_deta_nume_item := nvl(v_deta_nume_item, 0) + 1;
    p_deta_codi_vehi := v_deta_codi;
  
    --inserta datos de detalle de anexo
    insert into come_soli_serv_anex_deta
      (deta_anex_codi,
       deta_nume_item,
       deta_iden,
       deta_base,
       deta_calc_gran,
       deta_calc_pequ,
       deta_ning_calc,
       deta_indi_moni,
       deta_indi_nexo_recu,
       deta_indi_para_moto,
       deta_indi_boto_esta,
       deta_indi_acce_aweb,
       deta_indi_roam,
       deta_indi_boto_pani,
       deta_indi_mant_equi,
       deta_indi_cort_corr_auto,
       deta_tipo_roam,
       deta_roam_fech_inic_vige,
       deta_roam_fech_fini_vige,
       deta_esta_vehi,
       deta_esta,
       deta_iden_ante,
       deta_fech_vige_inic,
       deta_fech_vige_fini,
       deta_vehi_codi,
       deta_indi_sens_tapa_tanq,
       deta_indi_sens_comb,
       deta_indi_sens_temp,
       deta_indi_aper_puer,
       deta_impo_mone,
       deta_esta_plan,
       deta_indi_anex_vehi,
       deta_indi_anex_requ_vehi,
       deta_indi_anex_requ_fech,
       deta_indi_anex_modu,
       deta_indi_anex_sele_modu,
       deta_codi,
       deta_conc_codi,
       deta_anex_codi_padr,
       deta_prec_unit,
       deta_codi_anex_padr)
    values
      (v_anex_codi,
       v_deta_nume_item,
       p_ortr_vehi_iden, --guarda el identificador, ya que no se modificara en la reinstalacion
       v_deta_base,
       v_deta_calc_gran,
       v_deta_calc_pequ,
       v_deta_ning_calc,
       v_deta_indi_moni,
       v_deta_indi_nexo_recu,
       v_deta_indi_para_moto,
       v_deta_indi_boto_esta,
       v_deta_indi_acce_aweb,
       v_deta_indi_roam,
       v_deta_indi_boto_pani,
       v_deta_indi_mant_equi,
       v_deta_indi_cort_corr_auto,
       v_deta_tipo_roam,
       v_deta_roam_fech_inic_vige,
       v_deta_roam_fech_fini_vige,
       v_deta_esta_vehi,
       'P',
       v_deta_iden_ante,
       v_deta_fech_vige_inic,
       v_deta_fech_vige_fini,
       null,
       v_deta_indi_sens_tapa_tanq,
       v_deta_indi_sens_comb,
       v_deta_indi_sens_temp,
       v_deta_indi_aper_puer,
       v_deta_impo_mone,
       v_deta_esta_plan,
       v_deta_indi_anex_vehi,
       v_deta_indi_anex_requ_vehi,
       v_deta_indi_anex_requ_fech,
       v_deta_indi_anex_modu,
       v_deta_indi_anex_sele_modu,
       v_deta_codi,
       v_deta_conc_codi,
       v_anex_codi_padr,
       v_deta_prec_unit,
       v_deta_codi_padr);
  
    --si tenia servicio de grua
    if nvl(v_vehi_indi_grua, 'N') = 'S' then
      begin
        select nvl(c.conc_indi_anex_vehi, 'N'),
               nvl(c.conc_indi_anex_requ_vehi, 'N'),
               nvl(c.conc_indi_anex_requ_fech, 'N'),
               nvl(c.conc_indi_anex_modu, 'N'),
               nvl(c.conc_indi_anex_sele_modu, 'N')
          into v_deta_indi_anex_vehi,
               v_deta_indi_anex_requ_vehi,
               v_deta_indi_anex_requ_fech,
               v_deta_indi_anex_modu,
               v_deta_indi_anex_sele_modu
          from come_conc c
         where conc_codi = parameter.p_conc_codi_anex_grua_vehi;
      end;
    
      v_deta_codi_anex_padr := v_deta_codi;
      v_deta_codi           := fa_sec_soli_serv_anex_deta;
      v_deta_nume_item      := nvl(v_deta_nume_item, 0) + 1;
    
      --inserta datos de detalle de anexo
      insert into come_soli_serv_anex_deta
        (deta_anex_codi,
         deta_nume_item,
         deta_iden,
         deta_base,
         deta_calc_gran,
         deta_calc_pequ,
         deta_ning_calc,
         deta_indi_moni,
         deta_indi_nexo_recu,
         deta_indi_para_moto,
         deta_indi_boto_esta,
         deta_indi_acce_aweb,
         deta_indi_roam,
         deta_indi_boto_pani,
         deta_indi_mant_equi,
         deta_indi_cort_corr_auto,
         deta_tipo_roam,
         deta_esta_vehi,
         deta_fech_vige_inic,
         deta_fech_vige_fini,
         deta_indi_sens_tapa_tanq,
         deta_indi_sens_comb,
         deta_indi_sens_temp,
         deta_indi_aper_puer,
         deta_impo_mone,
         deta_esta_plan,
         deta_indi_anex_vehi,
         deta_indi_anex_requ_vehi,
         deta_indi_anex_requ_fech,
         deta_indi_anex_modu,
         deta_indi_anex_sele_modu,
         deta_codi,
         deta_conc_codi,
         deta_anex_codi_padr,
         deta_prec_unit,
         deta_codi_anex_padr)
      values
        (v_anex_codi,
         v_deta_nume_item,
         p_ortr_vehi_iden, --guarda el identificador, ya que no se modificara en la reinstalacion
         v_deta_base,
         v_deta_calc_gran,
         v_deta_calc_pequ,
         v_deta_ning_calc,
         v_deta_indi_moni,
         v_deta_indi_nexo_recu,
         v_deta_indi_para_moto,
         v_deta_indi_boto_esta,
         v_deta_indi_acce_aweb,
         v_deta_indi_roam,
         v_deta_indi_boto_pani,
         v_deta_indi_mant_equi,
         v_deta_indi_cort_corr_auto,
         v_deta_tipo_roam,
         v_deta_esta_vehi,
         v_deta_fech_vige_inic,
         v_deta_fech_vige_fini,
         v_deta_indi_sens_tapa_tanq,
         v_deta_indi_sens_comb,
         v_deta_indi_sens_temp,
         v_deta_indi_aper_puer,
         (nvl(parameter.p_prec_unit_anex_grua_vehi, 0) * v_anex_dura_cont),
         'S',
         v_deta_indi_anex_vehi,
         v_deta_indi_anex_requ_vehi,
         v_deta_indi_anex_requ_fech,
         v_deta_indi_anex_modu,
         v_deta_indi_anex_sele_modu,
         v_deta_codi,
         parameter.p_conc_codi_anex_grua_vehi,
         v_anex_codi_padr,
         nvl(parameter.p_prec_unit_anex_grua_vehi, 0),
         v_deta_codi_anex_padr);
    end if;
  
    v_deta_codi      := fa_sec_soli_serv_anex_deta;
    v_deta_nume_item := nvl(v_deta_nume_item, 0) + 1;
  
    --inserta detalle de anexo con concepto de reinstalacion
  
    -------------segun lo consultado no hace falta 
    /*insert into come_soli_serv_anex_deta
      (deta_anex_codi,
       deta_nume_item,
       deta_vehi_codi,
       deta_iden,
       deta_base,
       deta_roam_fech_inic_vige,
       deta_roam_fech_fini_vige,
       deta_conc_codi,
       deta_prec_unit,
       deta_indi_anex_vehi,
       deta_indi_anex_requ_vehi,
       deta_indi_anex_requ_fech,
       deta_indi_anex_modu,
       deta_indi_anex_sele_modu,
       deta_codi,
       deta_impo_mone,
       deta_esta_plan,
       deta_anex_codi_padr,
       deta_codi_anex_padr)
    values
      (v_anex_codi,
       v_deta_nume_item,
       null,
       null,
       v_deta_base,
       v_deta_roam_fech_inic_vige,
       v_deta_roam_fech_fini_vige,
       parameter.p_conc_codi_anex_rein_vehi,
       nvl(parameter.p_impo_mone_anex_rein_vehi, 70000),
       'S',
       'N',
       'N',
       'S',
       'N',
       v_deta_codi,
       nvl(parameter.p_impo_mone_anex_rein_vehi, 70000),
       'S',
       v_anex_codi_padr,
       v_deta_codi_padr);*/
  
    --actualiza importes de cabecera de anexo
    update come_soli_serv_anex
       set anex_impo_mone = v_deta_impo_mone,
           anex_impo_mmnn = round(v_deta_impo_mone * v_sose_tasa_mone, 0),
           anex_prec_unit = v_deta_prec_unit
     where anex_codi = v_anex_codi;
  
  end pp_generar_anex_rein;

  procedure pp_generar_vehi(p_sode_codi      in number,
                            p_sose_codi      in number,
                            p_ortr_deta_codi in number,
                            p_deta_codi_vehi in number,
                            p_sode_vehi_codi in number) is
    v_count number := 0;
  
    v_vehi_codi          number(20);
    v_vehi_iden_ante     varchar2(60);
    v_vehi_iden          varchar2(60);
    v_vehi_equi_mode     varchar2(40);
    v_vehi_equi_id       varchar2(20);
    v_vehi_equi_imei     varchar2(20);
    v_vehi_equi_sim_card varchar2(20);
    v_vehi_alar_id       number(20);
  
    v_reve_vehi_codi number(20);
    v_reve_tive_codi number(20);
    v_reve_mave_codi number(20);
    v_reve_mode      varchar2(60);
    v_reve_anho      varchar2(10);
    v_reve_colo      varchar2(60);
    v_reve_nume_chas varchar2(60);
    v_reve_nume_pate varchar2(60);
  
    v_sose_clpr_codi      number(20);
    v_sose_sucu_nume_item number(20);
    v_sose_dura_cont      number(3);
  begin
    v_vehi_codi := null;
    v_vehi_iden := null;
  
    begin
      select r.reve_vehi_codi,
             r.reve_tive_codi,
             r.reve_mave_codi,
             r.reve_mode,
             r.reve_anho,
             r.reve_colo,
             r.reve_nume_chas,
             r.reve_nume_pate
        into v_reve_vehi_codi,
             v_reve_tive_codi,
             v_reve_mave_codi,
             v_reve_mode,
             v_reve_anho,
             v_reve_colo,
             v_reve_nume_chas,
             v_reve_nume_pate
        from come_rein_inst_vehi r
       where r.reve_sode_codi = p_sode_codi;
    exception
      when no_data_found then
        v_reve_vehi_codi := null;
        v_reve_tive_codi := null;
        v_reve_mave_codi := null;
        v_reve_mode      := null;
        v_reve_anho      := null;
        v_reve_colo      := null;
        v_reve_nume_chas := null;
        v_reve_nume_pate := null;
    end;
  
    begin
      select s.sose_clpr_codi, s.sose_sucu_nume_item, s.sose_dura_cont
        into v_sose_clpr_codi, v_sose_sucu_nume_item, v_sose_dura_cont
        from come_soli_serv s
       where s.sose_codi = p_sose_codi;
    exception
      when no_data_found then
        v_sose_clpr_codi      := null;
        v_sose_sucu_nume_item := null;
        v_sose_dura_cont      := null;
    end;
  
    select count(*)
      into v_count
      from come_vehi
     where vehi_codi = v_reve_vehi_codi;
  
    if v_count = 0 then
      --se asume que que es tipo RI al entrar en este proceso
      --if nvl(:babmc.anex_sose_tipo, 'I') = 'RI' then
      --begin
      --  select deta_iden
      --    into v_vehi_iden
      --    from come_soli_serv_anex_deta d
      --   where deta_codi = p_ortr_deta_codi; --:bvehi.deta_codi_anex_padr;
      --end;
      begin
        select v.vehi_iden,
               v.vehi_equi_mode,
               v.vehi_equi_id,
               v.vehi_equi_imei,
               v.vehi_equi_sim_card,
               v.vehi_alar_id
          into v_vehi_iden,
               v_vehi_equi_mode,
               v_vehi_equi_id,
               v_vehi_equi_imei,
               v_vehi_equi_sim_card,
               v_vehi_alar_id
          from come_vehi v
         where v.vehi_codi = p_sode_vehi_codi;
      exception
        when no_data_found then
          begin
            select deta_iden
              into v_vehi_iden
              from come_soli_serv_anex_deta d
             where deta_codi = p_ortr_deta_codi; --:bvehi.deta_codi_anex_padr;
          end;
          v_vehi_equi_mode     := null;
          v_vehi_equi_id       := null;
          v_vehi_equi_imei     := null;
          v_vehi_equi_sim_card := null;
          v_vehi_alar_id       := null;
      end;
    
      v_vehi_iden_ante := null;
      --end if;
    
      v_vehi_codi := fa_sec_come_vehi;
    
      insert into come_vehi
        (vehi_codi,
         vehi_iden,
         vehi_esta,
         vehi_clpr_codi,
         vehi_clpr_sucu_nume_item,
         vehi_tive_codi,
         vehi_mave_codi,
         vehi_mode,
         vehi_anho,
         vehi_colo,
         vehi_nume_chas,
         vehi_nume_pate,
         vehi_fech_vige_inic,
         vehi_fech_vige_fini,
         vehi_iden_ante,
         vehi_base,
         vehi_user_regi,
         vehi_fech_regi,
         vehi_indi_old,
         vehi_indi_grua,
         vehi_equi_mode,
         vehi_equi_id,
         vehi_equi_imei,
         vehi_equi_sim_card,
         vehi_alar_id)
      values
        (v_vehi_codi,
         v_vehi_iden,
         'P',
         v_sose_clpr_codi,
         v_sose_sucu_nume_item,
         v_reve_tive_codi,
         v_reve_mave_codi,
         nvl(v_reve_mode, 'S/D'),
         nvl(v_reve_anho, 'S/D'),
         nvl(v_reve_colo, 'S/D'),
         nvl(v_reve_nume_chas, 'S/D'),
         nvl(v_reve_nume_pate, 'S/D'),
         trunc(sysdate), --:babmc.anex_fech_emis,
         add_months(trunc(sysdate), v_sose_dura_cont) - 1, --add_months(:babmc.anex_fech_emis, :babmc.sose_dura_cont) - 1,
         v_vehi_iden_ante,
         1,
         user,
         sysdate,
         'N',
         'N',
         v_vehi_equi_mode,
         v_vehi_equi_id,
         v_vehi_equi_imei,
         v_vehi_equi_sim_card,
         v_vehi_alar_id);
    
      begin
        update come_rein_inst_vehi r
           set r.reve_vehi_codi = v_vehi_codi
         where r.reve_sode_codi = p_sode_codi;
      exception
        when others then
          null;
      end;
      begin
        update come_soli_serv_anex_deta d
           set d.deta_vehi_codi = v_vehi_codi
         where d.deta_codi = p_deta_codi_vehi;
      exception
        when others then
          null;
      end;
    end if;
  end pp_generar_vehi;

  procedure pp_generar_ot_rein(p_anex_codi in number,
                               p_sose_codi in number) is
    cursor c_vehi is
      select vehi_codi,
             anex_tipo,
             anex_codi,
             vehi_vehi_codi,
             sose_codi_padr,
             nvl(deta_iden, vehi_iden) deta_iden,
             deta_codi,
             deta_iden_ante
        from come_vehi,
             come_soli_serv_anex_deta,
             come_soli_serv_anex,
             come_soli_serv
       where sose_codi = anex_sose_codi
         and vehi_codi = deta_vehi_codi
         and deta_anex_codi = anex_codi
         and anex_codi = p_anex_codi
         and deta_conc_codi <> parameter.p_conc_codi_anex_rein_vehi;
  
    cursor c_deta is
      select deta_codi_anex_padr
        from come_soli_serv_anex_deta
       where deta_anex_codi = p_anex_codi
         and deta_conc_codi = parameter.p_conc_codi_anex_grua_vehi; -- concepto de grua
  
    v_ortr_codi      number(20);
    v_ortr_clpr_codi number(20);
    v_ortr_nume      varchar2(20);
    v_ortr_desc      varchar2(1000);
  
    v_clpr_desc varchar2(100);
    v_sose_tipo varchar2(5);
  
    v_tipo_sose           varchar2(3);
    v_sose_clpr_codi      number(20);
    v_sose_sucu_nume_item number(20);
    v_sose_nume           varchar2(20);
    v_sose_fech_emis      date;
    v_sose_user_regi      varchar2(20);
    v_sose_esta           varchar2(1);
  begin
    for r in c_vehi loop
      --bloque OT inicio
      begin
        select s.sose_tipo,
               s.sose_clpr_codi,
               s.sose_sucu_nume_item,
               s.sose_nume,
               s.sose_fech_emis,
               s.sose_user_regi,
               s.sose_esta
          into v_tipo_sose,
               v_sose_clpr_codi,
               v_sose_sucu_nume_item,
               v_sose_nume,
               v_sose_fech_emis,
               v_sose_user_regi,
               v_sose_esta
          from come_soli_serv s
         where s.sose_codi = p_sose_codi;
      end;
    
      v_sose_tipo := nvl(r.anex_tipo, v_tipo_sose);
    
      select dom_descrip
        into v_ortr_desc
        from come_dominio
       where dom_param = 'SERV_TIPO'
         and dom_val_minimo = v_sose_tipo;
    
      begin
        select nvl(max(to_number(ortr_nume)), 0) + 1
          into v_ortr_nume
          from come_orde_trab;
      exception
        when no_data_found then
          v_ortr_nume := 1;
      end;
    
      --suma 1 nro a la ot, para reservar el nro de ot por desisntalacion, que se genera al liquidar la ot por cambio                           
      if v_sose_tipo in ('T', 'R', 'S', 'RAS') then
        v_ortr_nume := v_ortr_nume + 1;
      end if;
    
      v_ortr_codi      := fa_sec_come_orde_trab;
      v_ortr_clpr_codi := v_sose_clpr_codi;
    
      -- inserta la ot
      insert into come_orde_trab
        (ortr_codi,
         ortr_clpr_codi,
         ortr_nume,
         ortr_fech_emis,
         ortr_fech_grab,
         ortr_user,
         ortr_esta,
         ortr_desc,
         ortr_base,
         ortr_sucu_codi,
         ortr_mone_codi_prec,
         ortr_prec_vent,
         ortr_tipo_cost_tran,
         ortr_serv_tipo,
         ortr_serv_cate,
         ortr_serv_dato,
         ortr_user_regi,
         ortr_fech_regi,
         ortr_clpr_sucu_nume_item,
         ortr_sode_codi,
         ortr_vehi_codi,
         ortr_cant,
         ortr_anex_codi,
         ortr_deta_codi,
         ortr_vehi_iden,
         ortr_vehi_iden_ante)
      values
        (v_ortr_codi,
         v_ortr_clpr_codi,
         v_ortr_nume,
         trunc(sysdate),
         sysdate,
         parameter.p_usuario,
         'P',
         v_ortr_desc, --de la tabla de dominio,segun tipo de servicio
         1,
         1,
         1,
         0,
         1,
         v_sose_tipo,
         'P',
         'K',
         parameter.p_usuario,
         sysdate,
         v_sose_sucu_nume_item,
         null,
         r.vehi_codi,
         null,
         r.anex_codi,
         r.deta_codi,
         r.deta_iden,
         r.deta_iden_ante);
      --bloque OT fin
    
      begin
        select c.clpr_desc
          into v_clpr_desc
          from come_clie_prov c
         where c.clpr_codi = v_sose_clpr_codi;
      exception
        when others then
          v_clpr_desc := null;
      end;
      if v_sose_sucu_nume_item is not null then
        v_clpr_desc := v_clpr_desc || '; SubCuenta (' ||
                       v_sose_sucu_nume_item || ')';
      end if;
    
      -- inserta el mensaje
      insert into come_mens_sist
        (mesi_codi,
         mesi_desc,
         mesi_user_dest,
         mesi_user_envi,
         mesi_fech,
         mesi_indi_leid,
         mesi_tipo_docu,
         mesi_docu_codi)
      values
        (sec_come_mens_sist.nextval,
         ('Se ha autorizado la solicitud de servicio Nro. ' || v_sose_nume ||
         ' para el cliente ' || v_clpr_desc || ', con fecha de emisi?n ' ||
         to_char(v_sose_fech_emis, 'dd-mm-yyyy') || '.'),
         v_sose_user_regi,
         parameter.p_usuario,
         sysdate,
         'N',
         'SSI',
         p_sose_codi);
    end loop;
  
    --actualizar vehiculo si tiene grua
    for x in c_deta loop
      update come_vehi
         set vehi_indi_grua = 'S'
       where vehi_codi =
             (select deta_vehi_codi
                from come_soli_serv_anex_deta
               where deta_codi = x.deta_codi_anex_padr);
    end loop;
  
    --actualizar solicitud de servicio
    if v_sose_esta <> 'A' then
      update come_soli_serv
         set sose_esta      = 'A',
             sose_user_auto = nvl(parameter.p_usuario, user),
             sose_fech_auto = sysdate,
             sose_user_modi = nvl(parameter.p_usuario, user),
             sose_fech_modi = sysdate
       where sose_codi = p_sose_codi;
    end if;
  end pp_generar_ot_rein;

end i020294_a;
