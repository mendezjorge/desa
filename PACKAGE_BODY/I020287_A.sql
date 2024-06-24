
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020287_A" is
  e_sin_parametro exception;

  type r_parameter is record(
    -- p_codi_base    number     :=   pack_repl.fa_devu_codi_base;    
    p_indi_most_mens_sali varchar(200) := ltrim(rtrim((general_skn.fl_busca_parametro('p_indi_most_mens_sali')))),
    p_codi_tipo_empl_vend varchar(200) := ltrim(rtrim((general_skn.fl_busca_parametro('p_codi_tipo_empl_vend')))),
    
    p_conc_codi_anex_grua_vehi number := to_number(general_skn.fl_busca_parametro('p_conc_codi_anex_grua_vehi')),
    p_conc_codi_anex_rein_vehi number := to_number(general_skn.fl_busca_parametro('p_conc_codi_anex_rein_vehi')),
    p_indi_gene_plan_liqu_ot   varchar2(200) := ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_gene_plan_liqu_ot'))),
    p_peco_codi                number := 1,
    p_usuario                  varchar2(50) := fa_user,
    p_empr_codi                number := 1);
  parameter r_parameter;

  procedure pp_muestra_clie_alte(p_clpr_codi_alte in number,
                                 p_clpr_desc      out varchar2,
                                 p_clpr_codi      out number) is
  begin
    select clpr_desc, clpr_codi
      into p_clpr_desc, p_clpr_codi
      from come_clie_prov
     where clpr_indi_clie_prov = 'C'
       and clpr_codi_alte = p_clpr_codi_alte;
  
  exception
    when no_data_found then
      p_clpr_desc := null;
      p_clpr_codi := null;
      raise_application_error(-20001, 'Cliente Inexistente!');
    when others then
      raise_application_error(-20001, 'Error- ' || sqlerrm);
  end pp_muestra_clie_alte;

  procedure pp_mostrar_datos(p_sose_cod      in number,
                             p_sose_num      out number,
                             p_sose_est      out varchar2,
                             p_sose_fech     out varchar2,
                             p_clpr_cod_alte out number,
                             p_clpr_desc     out varchar,
                             p_suc_item      out number,
                             p_suc_desc      out varchar2,
                             p_emple_cod     out number,
                             p_desc_empl     out varchar2,
                             p_mon_cod       out number,
                             p_mone_desc     out varchar2,
                             p_valor_tota    out varchar2,
                             p_dura_cont     out number,
                             p_cant_movi     out number,
                             p_observacion   out varchar2,
                             p_user_regi     out varchar2,
                             p_user_modi     out varchar2,
                             p_user_auto     out varchar2,
                             p_fech_regi     out varchar2,
                             p_fech_modi     out varchar2,
                             p_fech_auto     out varchar2) is
  begin
    select sose_nume,
           decode(sose_esta,
                  'P',
                  'Pendiente',
                  'A',
                  'Autorizado',
                  'L',
                  'Liquidado') sose_esta,
           sose_fech_emis,
           c.clpr_codi_alte,
           c.clpr_desc,
           sose_sucu_nume_item,
           s.sucu_desc,
           m.mone_codi_alte,
           m.mone_desc_abre,
           sose_valo_tota,
           sose_dura_cont,
           sose_cant_movi,
           sose_obse,
           sose_user_regi,
           sose_user_modi,
           sose_user_auto,
           to_char(sose_fech_regi, 'DD/MM/YYYY HH24:MI:SS'),
           to_char(sose_fech_modi, 'DD/MM/YYYY HH24:MI:SS'),
           to_char(sose_fech_auto, 'DD/MM/YYYY HH24:MI:SS') /* ,
                                   sose_clpr_codi,*/
    
      into p_sose_num,
           p_sose_est,
           p_sose_fech,
           p_clpr_cod_alte,
           p_clpr_desc,
           p_suc_item,
           p_suc_desc,
           p_mon_cod,
           p_mone_desc,
           p_valor_tota,
           p_dura_cont,
           p_cant_movi,
           p_observacion,
           p_user_regi,
           p_user_modi,
           p_user_auto,
           p_fech_regi,
           p_fech_modi,
           p_fech_auto
    
      from come_soli_serv     f,
           come_clie_prov     c,
           come_clpr_sub_cuen s,
           come_mone          m
     where f.sose_clpr_codi = c.clpr_codi
       and f.sose_sucu_nume_item = s.sucu_nume_item(+)
       and f.sose_clpr_codi = s.sucu_clpr_codi(+)
       and f.sose_mone_codi = m.mone_codi
       and f.sose_codi = p_sose_cod;
  
  exception
    when no_data_found then
      raise_application_error(-20001, 'Contrato Inexistente');
    
    ---SETITEM('P53_P_INDI_CONS', 'S');
  end pp_mostrar_datos;

  procedure pp_consulta(p_sose_cod number) is
    cursor anex_deta is
      select sose_codi,
             sose_nume,
             sose_cant_movi,
             anex_codi,
             anex_sose_codi,
             anex_nume,
             anex_fech_emis,
             anex_user_regi,
             anex_fech_regi,
             anex_user_modi,
             anex_fech_modi,
             anex_esta,
             anex_tipo,
             anex_user_auto,
             anex_fech_auto,
             anex_prec_unit,
             anex_impo_mone_unic,
             anex_cant_movi,
             anex_dura_cont,
             anex_impo_mone,
             anex_cant_cuot_modu,
             anex_indi_fact_impo_unic,
             anex_esta estado_orig,
             sose_sucu_nume_item,
             sose_clpr_codi,
             anex_empl_codi
        from come_soli_serv, come_soli_serv_anex
       where sose_codi = anex_sose_codi
         and sose_codi = p_sose_cod
         and (v('P66_S_ANEX_NUME') is null or
             anex_codi = v('P66_S_ANEX_NUME'))
         and (v('P66_ANEX_ESTA') is null or anex_esta = v('P66_ANEX_ESTA'))
         and (v('p66_clpr_codi') is null or
             sose_clpr_codi = v('p66_clpr_codi'))
         and (v('p66_s_fech') is null or anex_fech_emis = v('p66_s_fech'));
  
  begin
  
    /*if not
        (apex_collection.collection_exists(p_collection_name => 'ANEXO_DET')) then
      apex_collection.create_collection(p_collection_name => 'ANEXO_DET');
    end if;*/
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'ANEXO_DET');
  
    for r in anex_deta loop
    
      apex_collection.add_member(p_collection_name => 'ANEXO_DET',
                                 p_c002            => r.sose_codi,
                                 p_c003            => r.sose_nume,
                                 p_c004            => r.sose_cant_movi,
                                 p_c005            => r.anex_codi,
                                 p_c006            => r.anex_sose_codi,
                                 p_c007            => r.anex_nume,
                                 p_c008            => r.anex_fech_emis,
                                 p_c009            => r.anex_user_regi,
                                 p_c010            => to_char(r.anex_fech_regi,
                                                              'DD/MM/YYYY HH24:MI:SS'),
                                 p_c011            => r.anex_user_modi,
                                 p_c012            => to_char(r.anex_fech_modi,
                                                              'DD/MM/YYYY HH24:MI:SS'),
                                 p_c013            => r.anex_esta,
                                 p_c014            => r.anex_tipo,
                                 p_c015            => r.anex_user_auto,
                                 p_c016            => r.anex_fech_auto,
                                 p_c017            => r.anex_prec_unit,
                                 p_c018            => r.anex_impo_mone_unic,
                                 p_c019            => r.anex_cant_movi,
                                 p_c020            => r.anex_dura_cont,
                                 p_c021            => r.anex_impo_mone,
                                 p_c022            => r.anex_cant_cuot_modu,
                                 p_c023            => r.anex_indi_fact_impo_unic,
                                 p_c024            => r.estado_orig,
                                 p_c025            => r.sose_sucu_nume_item,
                                 p_c026            => r.sose_clpr_codi,
                                 p_c027            => r.anex_empl_codi);
    end loop;
  
  end;

  procedure pp_veri_anex_modu(p_anex_codi in number, p_cantidad in number) is
  
    v_cant number;
    v_id   number;
  
  begin
  
    select count(*)
      into v_cant
      from come_soli_serv_anex_deta
     where deta_anex_codi = p_anex_codi
       and nvl(deta_indi_anex_modu, 'N') = 'S';
  
    select seq_id
      into v_id
      from apex_collections a
     where collection_name = 'ANEXO_DET'
       and c005 = p_anex_codi;
  
    if v_cant <= 0 then
      apex_collection.update_member_attribute(p_collection_name => 'ANEXO_DET',
                                              p_seq             => v_id,
                                              p_attr_number     => 22,
                                              p_attr_value      => null);
      raise_application_error(-20001,
                              'El Anexo no posee m?dulos a ser pagados en una o varias cuotas.');
    else
      apex_collection.update_member_attribute(p_collection_name => 'ANEXO_DET',
                                              p_seq             => v_id,
                                              p_attr_number     => 22,
                                              p_attr_value      => p_cantidad);
    end if;
  
  end pp_veri_anex_modu;


  function fp_get_anex_estado(i_anex_codi in number) return varchar2 is
    v_RETURN VARCHAR2(2);
  begin
    null;
  
    select nvl(anex_esta, 'P') estado
      INTO v_RETURN
      from come_soli_serv_anex
     where anex_codi = i_anex_codi;
    RETURN v_RETURN;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'P';
  end fp_get_anex_estado;
  
  
  procedure pp_actualizar_registro is
    cursor det is
      select c002 sose_codi,
             c003 sose_nume,
             c004 sose_cant_movi,
             c005 anex_codi,
             c006 anex_sose_codi,
             c007 anex_nume,
             c008 anex_fech_emis,
             c009 anex_user_regi,
             c010 fecha_registro,
             c011 anex_user_modi,
             c012 fecha_modificacion,
             c013 anex_esta,
             c014 anex_tipo,
             c015 anex_user_auto,
             c016 anex_fech_auto,
             c017 anex_prec_unit,
             c018 anex_impo_mone_unic,
             c019 anex_cant_movi,
             c020 duracion,
             c021 anex_impo_mone,
             c022 anex_cant_cuot_modu,
             c023 anex_indi_fact_impo_unic,
             c024 estado_orig,
             c025 sose_sucu_nume_item,
             c026 sose_clpr_codi,
             c027 anex_empl_codi
        from apex_collections a
       where collection_name = 'ANEXO_DET';
    verificado       number;
    v_empl_comi      number;
    v_sose_comi_anex number;
    V_ESTADO_ANTERIOR VARCHAR2(2);
  begin
    -- pp_validaciones;  
  
    i020287_a.pp_actualiza_datos_cliente(v('P66_CLPR_CODI'),
                                         v('P66_S_SOSE_NUME'));
  
  
  
    /*if V('P61_ANEX_EMPL_CODI') is null then
          raise_application_error(-20010, 'Debe Ingresar el Vendedor.');
    end if;*/
    for c in det loop
      -----------------------validar que todo fuera aprobado
      if c.anex_esta = 'A' then
        verificado := i020287_a.pp_buscar_estado(p_tipo_veh => 1,
                                                 p_anexo    => c.anex_codi);
      else
        verificado := 1;
      end if;
    
      if verificado = 2 then
      
        raise_application_error(-20001,
                                'El detalle no ha sido verificado, favor revisar');
        --- else
        --  raise_application_error(-20001, 'El detalle verificado');
      end if;
      -----------------------------------------
    
      ---validacion
      
      
    V_ESTADO_ANTERIOR := fp_get_anex_estado(i_anex_codi =>c.anex_codi);
   
      --if nvl(c.estado_orig, 'P') = 'A' and nvl(c.anex_esta, 'P') = 'P' then
      if nvl(V_ESTADO_ANTERIOR, 'P') = 'A' and nvl(c.anex_esta, 'P') = 'P' then
      
        pp_validar_ot(c.anex_codi);
      
        pp_valida_plan(c.anex_codi);
      
     -- elsif nvl(c.estado_orig, 'P') = 'P' and nvl(c.anex_esta, 'P') = 'A' then
        elsif nvl(V_ESTADO_ANTERIOR, 'P') = 'P' and nvl(c.anex_esta, 'P') = 'A' then 
      
        -- raise_application_error(-20001,v('P66_S_ANEX_FECH_AUTO')); 
        -- pp_valida_fech(nvl(to_d(v('P66_S_ANEX_FECH_AUTO'), sysdate), 'A');
        pp_valida_fech(trunc(sysdate), 'A');
      
        --A VERIFICAR si se autoriza no hay validaciones actualmente
      end if;
     
      --si estaba con estado A=Autorizado y ahora el marcador es igual a P
      --si estaba con estado P=Pendiente y ahora el marcador es igual a A
      --quiere decir que hubo cambio de estado y debe actualizar datos
    
      --FOR I IN 1..APEX_APPLICATION.G_F03.COUNT LOOP
      -- raise_application_error(-20001,APEX_APPLICATION.G_F03(I));
      
      
      
      --if nvl(c.estado_orig, 'P') = 'A' and nvl(c.anex_esta, 'P') = 'P' then 
      if nvl(V_ESTADO_ANTERIOR, 'P') = 'A' and nvl(c.anex_esta, 'P') = 'P' then
      
        pp_eliminar_anex_ot(c.anex_codi);
      
        update come_soli_serv_anex
           set anex_esta                = 'P',
               anex_cant_cuot_modu      = null,
               anex_indi_fact_impo_unic = null,
               anex_user_auto           = null,
               anex_fech_auto           = null,
               anex_user_modi           = parameter.p_usuario,
               anex_fech_modi           = sysdate
         where anex_codi = c.anex_codi;
      
        pp_auto_esta_sose(c.anex_sose_codi);
        pp_actu_vehi(c.anex_codi, c.anex_esta);
      
      
        i020287_a.pp_generar_plan_factura_grua(c.anex_codi,
                                               nvl(c.anex_fech_auto,
                                                   sysdate),
                                               c.anex_esta,
                                               c.anex_tipo);
      
     -- elsif nvl(c.estado_orig, 'P') = 'P' and nvl(c.anex_esta, 'P') = 'A' then
      elsif nvl(V_ESTADO_ANTERIOR, 'P') = 'P' and nvl(c.anex_esta, 'P') = 'A' then
     
     
     
        i020287_a.pp_generar_ot(c.anex_codi,
                                c.sose_sucu_nume_item,
                                c.sose_clpr_codi);
      
        pp_actu_vehi(c.anex_codi, c.anex_esta);
        pp_actu_sose(c.anex_sose_codi, null, c.anex_empl_codi, c.anex_codi);
      
        update come_soli_serv_anex
           set anex_esta                = 'A',
               anex_cant_cuot_modu      = c.anex_cant_cuot_modu,
               anex_indi_fact_impo_unic = c.anex_indi_fact_impo_unic,
               anex_user_auto           = parameter.p_usuario,
               anex_fech_auto           = nvl(c.anex_fech_auto, sysdate),
               anex_user_modi           = parameter.p_usuario,
               anex_fech_modi           = sysdate
         where anex_codi = c.anex_codi;
      
        --    raise_application_error(-20001, c.anex_codi||'--'||c.anex_fech_auto||'**'||c.anex_esta||'++'||c.anex_tipo);   
      
        i020287_a.pp_generar_plan_factura_grua(c.anex_codi,
                                               nvl(c.anex_fech_auto,
                                                   sysdate),
                                               c.anex_esta,
                                               c.anex_tipo);
      end if;
    
    
    end loop;
  
  
  exception
    when others then
      raise_application_error(-20001, sqlerrm);
    
  end pp_actualizar_registro;

  procedure pp_validar_ot(p_anex_codi in number) is
  
    cursor c_deta is
      select d.deta_codi, a.anex_nume, d.deta_nume_item
        from come_soli_serv_anex_deta d, come_soli_serv_anex a
       where d.deta_anex_codi = a.anex_codi
         and d.deta_anex_codi = p_anex_codi;
  
    v_ortr_nume      number;
    v_ortr_fech_emis date;
    v_esta           varchar2(20);
  begin
  
    for x in c_deta loop
    
      begin
        select ortr_nume
          into v_ortr_nume
          from come_orde_trab o
         where o.ortr_deta_codi = x.deta_codi
           and o.ortr_esta <> 'P';
      
        raise_application_error(-20001,
                                'El Anexo Nro ' || x.anex_nume ||
                                ', Nro item ' || x.deta_nume_item ||
                                ' esta relacionado a la OT ' || v_ortr_nume ||
                                ' que debe estar en estado Pendiente.');
      
      exception
        when no_data_found then
          begin
          
            select ortr_fech_emis, nvl(o.ortr_esta, 'P')
              into v_ortr_fech_emis, v_esta
              from come_orde_trab o
             where o.ortr_deta_codi = x.deta_codi
               and o.ortr_serv_tipo <> 'C';
          
            if v_esta = 'F' then
              pp_valida_fech(v_ortr_fech_emis, 'D');
            
            end if;
            --    raise_application_error(-20001,v_esta);
          exception
            when no_data_found then
              null;
          end;
        
        when too_many_rows then
          raise_application_error(-20001,
                                  'Existen OT relacionadas que deben estar en estado Pendiente.');
      end;
    
    end loop;
  end pp_validar_ot;

  procedure pp_valida_fech(p_fech      in date,
                           p_indi_auto in varchar2 default 'A') is
    p_fech_inic varchar2(20);
    p_fech_fini varchar2(20);
  
  begin
  
    pa_devu_fech_habi(p_fech_inic, p_fech_fini);
  
    if p_fech not between p_fech_inic and p_fech_fini then
    
      if p_indi_auto = 'A' then
      
        raise_application_error(-20001,
                                'La fecha de Autorizacion debe estar comprendida entre..' ||
                                (p_fech_inic) || ' y ' || (p_fech_fini));
      else
      
        raise_application_error(-20001,
                                'La fecha de la OT relacionada al Anexo a desautorizar debe estar comprendida entre..' ||
                                p_fech_inic || ' y ' ||
                                to_char(p_fech_fini, 'dd-mm-yyyy'));
      end if;
    end if;
  
  end;
  procedure pp_valida_plan(p_anex_codi in number) is
  
    v_anpl_nume number;
    v_anex_nume number;
  
  begin
  
    select anpl_nume, anex_nume
      into v_anpl_nume, v_anex_nume
      from come_soli_serv_anex_plan, come_soli_serv_anex
     where anpl_anex_codi = anex_codi
       and anpl_anex_codi = p_anex_codi
     group by anpl_nume, anex_nume;
  
    raise_application_error(-20001,
                            'El Anexo Nro ' || v_anex_nume ||
                            ' ya posee Plan de Facturacion Nro ' ||
                            v_anpl_nume ||
                            ' generada, para Desautorizar primero debe eliminar el Plan.');
  
  exception
    when no_data_found then
      null;
    when too_many_rows then
      raise_application_error(-20001,
                              'El anexo ya posee Plan de Facturaci?n, para Desautorizar primero debe eliminar el Plan.');
  end pp_valida_plan;

  procedure pp_eliminar_anex_ot(p_anex_codi in number) is
  
    cursor c_deta is
      select d.deta_codi
        from come_soli_serv_anex_deta d
       where d.deta_anex_codi = p_anex_codi;
  
    cursor c_ortr(p_deta_codi in number) is
      select o.ortr_codi
        from come_orde_trab o
       where o.ortr_deta_codi = p_deta_codi;
  
    v_cant      number;
    v_movi_codi number;
  begin
  
    for x in c_deta loop
    
      for y in c_ortr(x.deta_codi) loop
      
        begin
          select count(*)
            into v_cant
            from come_orde_trab
           where ortr_codi = y.ortr_codi
             and (ortr_esta = 'L' or ortr_esta_pre_liqu = 'S');
        
          if v_cant > 0 then
            raise_application_error(-20001,
                                    'No se puede cambiar estado de Anexo, posee OT que ya se encuentran Pre-liquidadas o Liquidadas!.');
          end if;
        end;
        update crm_neg_ticket t
           set t.ctn_ortr_codi = null
         where t.ctn_ortr_codi = y.ortr_codi;
        --  raise_application_error(-20001,'ad');
      
        -----------------------desde aqui***lv 19-04-2023
        begin
          select movi_codi
            into v_movi_codi
            from come_movi a
           where movi_ortr_codi = y.ortr_codi;
        
          delete come_movi_prod_deta where deta_movi_codi = v_movi_codi;
        
          delete come_movi a where a.movi_codi = v_movi_codi;
        
        exception
          when no_data_found then
            null;
        end;
        ------------------------------------ hasta aqui***lv 19-04-2023  
      
        delete come_orde_trab_vehi where vehi_ortr_codi = y.ortr_codi;
        delete come_orde_trab_cont where cont_ortr_codi = y.ortr_codi;
        delete come_orde_trab where ortr_codi = y.ortr_codi;
      end loop;
    
    end loop;
  
  end pp_eliminar_anex_ot;

  procedure pp_auto_esta_sose(p_sose_codi in number) is
  
    v_cant number := 0;
  
  begin
  
    select count(*)
      into v_cant
      from come_soli_serv_anex a
     where anex_sose_codi = p_sose_codi
       and anex_esta = 'A';
  
    if v_cant = 0 then
      update come_soli_serv
         set sose_esta = 'P'
       where sose_codi = p_sose_codi;
    end if;
  end pp_auto_esta_sose;

  procedure pp_actu_vehi(p_anex_codi in number, p_anex_esta in varchar2) is
  
    cursor c_deta is
      select deta_codi_anex_padr
        from come_soli_serv_anex_deta
       where deta_anex_codi = p_anex_codi
         and deta_conc_codi = parameter.p_conc_codi_anex_grua_vehi; ---concepto de grua
  
  begin
    for x in c_deta loop
      if p_anex_esta = 'A' then
        update come_vehi
           set vehi_indi_grua = 'S'
         where vehi_codi =
               (select deta_vehi_codi
                  from come_soli_serv_anex_deta
                 where deta_codi = x.deta_codi_anex_padr);
      else
        update come_vehi
           set vehi_indi_grua = 'N'
         where vehi_codi =
               (select deta_vehi_codi
                  from come_soli_serv_anex_deta
                 where deta_codi = x.deta_codi_anex_padr);
      end if;
    end loop;
  
  end pp_actu_vehi;

  procedure pp_actu_sose(p_anex_sose_codi      in number,
                         p_anex_empl_codi_orig in number,
                         p_anex_empl_codi      in number,
                         p_anex_codi           in number) is
  
    v_sose_esta varchar2(1);
  
  begin
  
    begin
      select sose_esta
        into v_sose_esta
        from come_soli_serv
       where sose_codi = p_anex_sose_codi;
    end;
  
    if v_sose_esta <> 'A' then
      update come_soli_serv
         set sose_esta      = 'A',
             sose_user_auto = parameter.p_usuario,
             sose_fech_auto = sysdate,
             sose_user_modi = parameter.p_usuario,
             sose_fech_modi = sysdate
       where sose_codi = p_anex_sose_codi;
    end if;
  
    if p_anex_empl_codi_orig <> p_anex_empl_codi then
      update come_soli_serv_anex
         set anex_empl_codi = p_anex_empl_codi_orig,
             anex_user_modi = parameter.p_usuario,
             anex_fech_modi = sysdate
       where anex_codi = p_anex_codi;
    
    end if;
  
  end pp_actu_sose;

  procedure pp_generar_ot(p_anex_codi      in number,
                          p_sose_tipo      in varchar2,
                          p_sose_clpr_codi in number) is
  
    cursor c_vehi is
      select vehi_codi,
             anex_tipo,
             anex_codi,
             vehi_vehi_codi,
             sose_codi_padr,
             sose_tipo,
             nvl(deta_iden, vehi_iden) deta_iden,
             deta_codi,
             deta_iden_ante,
             sose_codi,
             sose_nume,
             nvl(deta_indi_prom_pror, 'N') deta_indi_prom_pror,
             anex_empl_codi vendedor,
             nvl(anex_prec_unit,0) prec_unit
        from come_vehi,
             come_soli_serv_anex_deta,
             come_soli_serv_anex,
             come_soli_serv
       where sose_codi = anex_sose_codi
         and vehi_codi = deta_vehi_codi
         and deta_anex_codi = anex_codi
         and anex_codi = p_anex_codi
         and deta_conc_codi <> parameter.p_conc_codi_anex_rein_vehi;
  
    v_ortr_codi      number(20);
    v_ortr_nume      varchar2(20);
    v_ortr_fech_emis date;
    v_sysdate        date := sysdate;
    v_clpr_desc      varchar2(100);
    v_ortr_desc      varchar2(100);
    v_sose_tipo      varchar2(5);
  v_existe number;
  
       tiempo_inicial TIMESTAMP;
    tiempo_actual TIMESTAMP;
    espera NUMBER;
    tiempo_espera NUMBER := 3; -- Variable para controlar el tiempo de espera en segundos
    intervalo INTERVAL DAY TO SECOND; -- Variable para almacenar el intervalo de tiempo
  begin
  
    for r in c_vehi loop
    if r.prec_unit <= 0 then
      raise_application_error(-20001, 'Revisar anexo, el monto no fue cargado correctamente');
    end if;
      v_sose_tipo := nvl(r.anex_tipo, p_sose_tipo);
    
      select dom_descrip
        into v_ortr_desc
        from come_dominio
       where dom_param = 'SERV_TIPO'
         and dom_val_minimo = v_sose_tipo;
    
      ----------------OT----------------------
      begin
        select nvl(max(to_number(ortr_nume)), 0) + 1
          into v_ortr_nume
          from come_orde_trab;
      end;
  
      --suma 1 nro a la OT, para reservar el Nro de OT por desisntalacion, que se genera al liquidar la OT por Cambio                           
      if v_sose_tipo in ('T', 'R', 'S', 'RAS') then
        v_ortr_nume := v_ortr_nume + 1;
      end if;
    
      v_ortr_codi      := fa_sec_come_orde_trab;
      v_ortr_fech_emis := nvl(v('P66_S_ANEX_FECH_AUTO'), trunc(sysdate));
      
      BEGIN
                  tiempo_inicial := SYSTIMESTAMP; -- Obtener la marca de tiempo inicial
                  intervalo := NUMTODSINTERVAL(tiempo_espera, 'SECOND'); -- Convertir segundos a un intervalo de tiempo
                  LOOP
                      tiempo_actual := SYSTIMESTAMP; -- Obtener la marca de tiempo actual
                      EXIT WHEN (tiempo_actual - tiempo_inicial) >= intervalo; -- Salir del bucle despu?s de X segundos
                  END LOOP;    
      END;
                
                
      select count(*)
             into v_existe 
        from come_orde_trab
        where ortr_anex_codi = v('P66_S_ANEX_NUME');
     if v_existe = 0 then
      begin
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
         p_sose_clpr_codi,
         v_ortr_nume,
         v_ortr_fech_emis,
         v_sysdate,
         fa_user,
         'P',
         v_ortr_desc,
         1,
         1,
         1,
         0,
         1,
         v_sose_tipo,
         'P',
         'K',
         parameter.p_usuario,
         v_sysdate,
         v('P66_SOSE_SUCU_NUME_ITEM'),
         null,
         r.vehi_codi,
         null,
         r.anex_codi,
         r.deta_codi,
         r.deta_iden,
         r.deta_iden_ante);
         
         
      ------------------------------------------------------        
      
        select c.clpr_desc
          into v_clpr_desc
          from come_clie_prov c
         where c.clpr_codi = p_sose_clpr_codi;
      exception
        when others then
          v_clpr_desc := null;
      end;
      if v('P66_SOSE_SUCU_NUME_ITEM') is not null then
        v_clpr_desc := v_clpr_desc || '; SubCuenta (' ||
                       v('P66_SOSE_SUCU_NUME_ITEM') || ')';
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
         ('Se ha autorizado la solicitud de servicio Nro. ' ||
         v('P66_SOSE_NUME') || ' para el cliente ' || v_clpr_desc ||
         ', con fecha de emision ' || v('P66_SOSE_FECH_EMIS') || '.'),
         v('P66_SOSE_USER_REGI'),
         parameter.p_usuario,
         sysdate,
         'N',
         'SSI',
         r.sose_codi);
    
      --==inserta la OT de cobranza
      if v_sose_tipo = 'I' and r.deta_indi_prom_pror = 'N' then
      
        v_ortr_codi := fa_sec_come_orde_trab;
        v_ortr_nume := v_ortr_nume + 1;
      
        insert into come_orde_trab
          (ortr_codi,
           ortr_clpr_codi,
           --   ortr_empl_codi,
           ortr_nume,
           ortr_fech_emis,
           ortr_fech_grab,
           ortr_user,
           ortr_esta,
           ortr_desc,
           ortr_base,
           ortr_empr_codi,
           ortr_sucu_codi,
           ortr_mone_codi_prec,
           ortr_prec_vent,
           ortr_tipo_cost_tran,
           ortr_empl_codi_vend,
           ortr_serv_tipo,
           ortr_user_regi,
           ortr_fech_regi,
           ortr_serv_tipo_inst,
           ortr_esta_pre_liqu,
           ortr_indi_clie_veri_vehi,
           ortr_indi_cort_corr,
           ortr_sistema,
           ortr_anex_codi,
           ortr_deta_codi)
        values
          (v_ortr_codi, --v ok
           p_sose_clpr_codi, --v ok
           --    72,             --v
           v_ortr_nume, --v ok
           v_ortr_fech_emis, --v ok
           v_sysdate, --v ok
           fa_user, --v
           'P',
           'Cobranza',
           1,
           1,
           1,
           1,
           0,
           1,
           r.vendedor, --v ok
           'C',
           parameter.p_usuario, --v ok
           v_sysdate, --v ok
           'G',
           'N',
           'N',
           'N',
           'APEX',
           r.anex_codi,
           r.deta_codi);
      
      end if;
    end if;
    end loop;
  end;

  procedure pp_validar_checall(p_estado varchar2) is
    v_estado varchar2(30);
  begin
  
    if p_estado = 'true' then
      v_estado := 'A';
    else
      v_estado := 'P';
    end if;
  
    for i in (select seq_id
                from apex_collections a
               where collection_name = 'ANEXO_DET') loop
      --  raise_application_error(-20001,v_estado||' - '||I.SEQ_ID);
      apex_collection.update_member_attribute(p_collection_name => 'ANEXO_DET',
                                              p_seq             => i.seq_id,
                                              p_attr_number     => 13,
                                              p_attr_value      => v_estado);
    end loop;
  
  end pp_validar_checall;

  /*procedure pp_estado_check(p_id number,
                            p_estado varchar2) is
   
   v_estado varchar2(20);
   v_id_seq number; 
   v_exist number;                       
  begin
     begin
      select count(*),SEQ_ID
        into v_exist,v_id_seq
        from apex_collections
       where collection_name = 'estado'
         and n001 = p_id
       GROUP BY SEQ_ID;
       exception when others then
         v_exist:=0;
       end;
     if   p_estado='true' then
          v_estado:='A';
          else
          v_estado:='P'; 
           end if;
        raise_application_error(-20001,p_estado);
    
      if v_exist > 0 then
        APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'estado',
                                              P_SEQ             => v_id_seq,
                                              P_ATTR_NUMBER     => 2,
                                              P_ATTR_VALUE      => v_estado);
      
      else
      
        apex_collection.add_member(p_collection_name => 'estado',
                                   p_n001            => p_id,
                                   p_c001            => v_estado);
      
      end if;
    end pp_estado_check;*/

  procedure pp_act_estado_documento(p_anex_deta     in varchar2,
                                    p_anex_deta_req in varchar2,
                                    p_accion        in varchar2,
                                    p_stado         in varchar2) is
  
    v_codigo  number;
    v_existe  number;
    v_estado  varchar2(1);
    v_val_ant varchar2(100);
  begin
  
    if p_anex_deta is null then
      raise_application_error(-20001, 'error');
    end if;
    if p_anex_deta_req is null then
      raise_application_error(-20001, 'error');
    end if;
    /*if p_accion is  null then
      raise_application_error(-20001, 'error');
    end if;*/
    if p_stado is null then
      raise_application_error(-20001, 'error');
    end if;
    /*  if p_accion = 'true' and p_stado = 1 then
      v_estado := 'S';
    elsif p_accion = 'true' and p_stado = 2 then
      v_estado := 'R';
    else
      v_estado := 'N';
    end if;  */
  
    v_estado  := p_stado;
    v_val_ant := replace(p_accion, '*', ' ');
    begin
      select drvd_codi
        into v_existe
        from come_docu_requ_vehi_det
       where drvd_anex_deta_requ = p_anex_deta
         and drvd_anex_deta_requ_camp = p_anex_deta_req;
    exception
      when no_data_found then
        select nvl(max(drvd_codi), 0) + 1
          into v_codigo
          from come_docu_requ_vehi_det;
      
        insert into come_docu_requ_vehi_det
          (drvd_codi,
           drvd_anex_deta_requ,
           drvd_anex_deta_requ_camp,
           drvd_est)
        values
          (v_codigo, p_anex_deta, p_anex_deta_req, v_estado);
      
    end;
    update come_docu_requ_vehi_det
       set drvd_est = v_estado
     where drvd_codi = v_existe;
  
  end pp_act_estado_documento;

  function pp_buscar_estado(p_tipo_veh in number, p_anexo in number)
    return number is
  
    v_cantidad   number := 0;
    v_autorizado varchar2(2);
  begin
  
    --raise_application_error (-20001,p_anexo);
    for x in (select vehi_tive_codi
                from come_soli_serv_anex_deta b, come_vehi a
               where a.vehi_codi = b.deta_vehi_codi
                 and deta_anex_codi = p_anexo) loop
    
      select nvl(count(*), 0)
        into v_cantidad
        from (
              /*select s.reca_codi, 'S'
               from COME_TIPO_VEHI t, COME_DOCU_REQU_TIPO a, come_docu_requ_tipo_camp s---, come_docu_requ_vehi_det x
              where requ_tive_codi = tive_codi
                and a.requ_codi = s.reca_tipo_codi
                and tive_codi =x.vehi_tive_codi*/
              select x.reca_codi, 'S'
                from come_soli_serv           b,
                      come_soli_serv_anex      a,
                      come_soli_serv_anex_deta d,
                      come_docu_requ_vehi      c,
                      come_docu_requ_tipo      r,
                      files_archivos           f,
                      come_docu_requ_tipo_camp x
               where sose_codi = anex_sose_codi
                 and a.anex_codi = d.deta_anex_codi
                 and dove_anex_deta = d.deta_codi
                 and anex_codi = p_anexo
                 and c.dove_requ_codi = r.requ_codi
                 and c.dove_img = f.file_id
                 and x.reca_tipo_codi = requ_codi
                 and file_blob_content is not null
              --  and tive_codi =x.vehi_tive_codi
              
              minus
              select y.drvd_anex_deta_requ_camp, y.drvd_est
                from come_docu_requ_vehi_det y
               where y.drvd_anex_deta_requ = p_anexo);
    
      v_cantidad := v_cantidad + v_cantidad;
    
    end loop;
  
    select nvl(t.anex_info_auto, 'S')
      into v_autorizado
      from come_soli_serv_anex t
     where t.anex_codi = p_anexo;
  
    if v_cantidad = 0 and v_autorizado = 'S' then
    
      /*APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'ANEXO_DET',
      P_SEQ             => p_seq_id,
      P_ATTR_NUMBER     => 30,
      P_ATTR_VALUE      => 1);*/
      return 1;
    else
      /* APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(P_COLLECTION_NAME => 'ANEXO_DET',
      P_SEQ             => p_seq_id,
      P_ATTR_NUMBER     => 30,
      P_ATTR_VALUE      => 2);*/
      return 2;
    
    end if;
  
  end pp_buscar_estado;

  procedure pp_generar_plan_factura_grua(p_anex_codi in number,
                                         p_fech_auto in date,
                                         p_anex_esta in varchar2,
                                         p_anex_tipo in varchar2) is
    -- cursor de anexo para generar el plan
    cursor c_anex is
      select a.anex_codi,
             a.anex_fech_venc,
             a.anex_dura_cont,
             a.anex_cant_cuot_modu,
             a.anex_impo_mone_unic,
             a.anex_prec_unit,
             s.sose_tipo_fact,
             c.clpr_dia_tope_fact,
             'N' cuot_inic,
             nvl(cl.clas1_dias_venc_fact, 5) clas1_dias_venc_fact,
             a.anex_empr_codi,
             s.sose_sucu_nume_item,
             0 mone_cant_deci,
             a.anex_indi_fact_impo_unic,
             a.anex_cifa_codi,
             a.anex_cifa_tipo,
             a.anex_cifa_dia_fact,
             a.anex_cifa_dia_desd,
             a.anex_cifa_dia_hast,
             a.anex_aglu_cicl
        from come_soli_serv_anex      a,
             come_soli_serv_anex_deta d,
             come_soli_serv           s,
             come_clie_prov           c,
             come_clie_clas_1         cl
       where a.anex_sose_codi = s.sose_codi
         and c.clpr_indi_clie_prov = 'C'
         and s.sose_clpr_codi = c.clpr_codi
         and c.clpr_clie_clas1_codi = cl.clas1_codi
         and a.anex_codi = d.deta_anex_codi
         and a.anex_codi = p_anex_codi
       group by a.anex_codi,
                a.anex_fech_venc,
                a.anex_dura_cont,
                a.anex_cant_cuot_modu,
                a.anex_impo_mone_unic,
                a.anex_prec_unit,
                s.sose_tipo_fact,
                c.clpr_dia_tope_fact,
                nvl(cl.clas1_dias_venc_fact, 5),
                a.anex_empr_codi,
                s.sose_sucu_nume_item,
                a.anex_indi_fact_impo_unic,
                a.anex_cifa_codi,
                a.anex_cifa_tipo,
                a.anex_cifa_dia_fact,
                a.anex_cifa_dia_desd,
                a.anex_cifa_dia_hast,
                a.anex_aglu_cicl;
  
    -- cursor paga generar la factura
    cursor c_fact is
      select s.sose_clpr_codi,
             a.anex_cifa_codi,
             s.sose_codi,
             s.sose_nume,
             a.anex_codi,
             s.sose_tipo_fact,
             'A' agru_anex,
             nvl(v('P66_S_ANEX_FECH_AUTO'), sysdate) fech_fact_desd,
             nvl(v('P66_S_ANEX_FECH_AUTO'), sysdate) fech_fact_hast,
             nvl(v('P66_S_ANEX_FECH_AUTO'), sysdate) movi_fech_emis,
             1 sucu_codi,
             1 depo_codi,
             c.clpr_clie_clas1_codi clas1_codi,
             0 anpl_impo_reca_red_cobr,
             'N' indi_excl_clie_clas1_aseg,
             null v_faau_codi,
             null v_codresp,
             null v_descresp,
             null mov
        from come_soli_serv           s,
             come_soli_serv_anex      a,
             come_soli_serv_anex_deta d,
             come_clie_prov           c
       where s.sose_codi = a.anex_sose_codi
         and a.anex_codi = d.deta_anex_codi
         and s.sose_clpr_codi = c.clpr_codi
         and a.anex_codi = p_anex_codi;
  
    -- cursor para quitar el servicio de grua de la facturacion
    cursor c_grua is
      select dh.deta_codi, v.vehi_codi
        from come_soli_serv_anex_deta dh,
             come_soli_serv_anex_deta dp,
             come_vehi                v
       where dh.deta_codi_anex_padr = dp.deta_codi
         and dp.deta_vehi_codi = v.vehi_codi(+)
         and dh.deta_conc_codi = parameter.p_conc_codi_anex_grua_vehi
         and dh.deta_anex_codi = p_anex_codi
       order by dh.deta_codi, v.vehi_codi;
  
    v_sose_tipo varchar2(2);
    v_nume_item number;
  
    -- variables para generacion de plan y factura automatica
    v_codresp   number;
    v_descresp  varchar2(100);
    v_faau_codi number;
    v_user_codi number;
  
    v_plan number;
  
    v_fech_ulti_venc date;
    v_grua_si        number;
    v_grua_no        number;
  
    v_numero number;
  begin
    v_fech_ulti_venc := nvl(p_fech_auto, sysdate);
  
    -- si es instalacion
    if p_anex_tipo in ('T', 'I', 'RI', 'R') then
    
      if nvl(parameter.p_indi_gene_plan_liqu_ot, 'N') = 'S' then
        -- si el parametro esta en S para alarmas
        begin
          select count(*)
            into v_grua_si
            from come_soli_serv_anex_deta d
           where d.deta_conc_codi = parameter.p_conc_codi_anex_grua_vehi
             and d.deta_anex_codi = p_anex_codi;
        exception
          when others then
            v_grua_si := 0;
        end;
        begin
          select count(*)
            into v_grua_no
            from come_soli_serv_anex_deta d
           where d.deta_conc_codi != parameter.p_conc_codi_anex_grua_vehi
             and d.deta_anex_codi = p_anex_codi;
        exception
          when others then
            v_grua_no := 0;
        end;
      
        -- si el anexo solo tiene conceptos de grua
        if nvl(v_grua_si, 0) != 0 and nvl(v_grua_no, 0) = 0 then
          -- si esta autorizado se crea el plan y la facturacion
          if p_anex_esta = 'A' then
            begin
              -- verifica si ya tiene plan para generar al autorizar la grua
              select count(*) cant
                into v_plan
                from come_soli_serv_anex      a,
                     come_soli_serv_anex_deta d,
                     come_soli_serv_anex_plan p
               where a.anex_codi = p.anpl_anex_codi
                 and a.anex_codi = d.deta_anex_codi
                 and a.anex_codi = p_anex_codi;
            
            exception
              when others then
                v_plan := 0;
            end;
          
            if v_plan = 0 then
              -- procedimiento para generar el plan
              for x in c_anex loop
                begin
                  pack_fact_ciclo.pa_generar_detalle_plan(x.anex_codi,
                                                          v_fech_ulti_venc - 1, --se envia con fecha - 1 porque el proceso que usa hace fecha + 1
                                                          x.anex_dura_cont,
                                                          x.anex_cant_cuot_modu,
                                                          x.anex_impo_mone_unic,
                                                          x.anex_prec_unit,
                                                          x.sose_tipo_fact,
                                                          x.clpr_dia_tope_fact,
                                                          x.cuot_inic,
                                                          x.clas1_dias_venc_fact,
                                                          x.anex_empr_codi,
                                                          x.sose_sucu_nume_item,
                                                          x.mone_cant_deci,
                                                          x.anex_indi_fact_impo_unic,
                                                          x.anex_cifa_codi,
                                                          x.anex_cifa_tipo,
                                                          x.anex_cifa_dia_fact,
                                                          x.anex_cifa_dia_desd,
                                                          x.anex_cifa_dia_hast,
                                                          x.anex_aglu_cicl);
                exception
                
                  when others then
                    raise_application_error(-20001, sqlerrm);
                end;
              end loop;
            end if;
          
            -- genera la factura automatica     
            begin
              -- busca usuario
              select user_codi
                into v_user_codi
                from segu_user
               where user_login = fa_user;
            end;
          
            for x in c_fact loop
              begin
                pack_fact_ciclo.pa_gene_plan_fact_movi(x.sose_clpr_codi,
                                                       x.anex_cifa_codi,
                                                       x.sose_codi,
                                                       x.sose_nume,
                                                       x.anex_codi,
                                                       x.sose_tipo_fact,
                                                       x.agru_anex,
                                                       x.fech_fact_desd,
                                                       x.fech_fact_hast,
                                                       x.movi_fech_emis,
                                                       parameter.p_peco_codi,
                                                       v_user_codi,
                                                       x.sucu_codi,
                                                       x.depo_codi,
                                                       x.clas1_codi,
                                                       x.anpl_impo_reca_red_cobr,
                                                       x.indi_excl_clie_clas1_aseg,
                                                       v_faau_codi,
                                                       v_codresp,
                                                       v_descresp,
                                                       v_numero);
              
                -- si v_codResp es distinto a 1 significa que ocurri? una excepcion
                if nvl(v_codresp, 1) != 1 then
                  raise_application_error(-20001, v_descresp);
                end if;
              
              exception
              
                when others then
                  raise_application_error(-20001, sqlerrm);
              end;
            end loop;
            --     raise_application_error(-20001,123 );  
            -- si esta desautorizado se quita del plan y la facturacion
          else
            -- dar de baja los servicios de grua
            for k in c_grua loop
              update come_soli_serv_anex_deta d
                 set d.deta_esta_plan = 'N'
               where deta_codi = k.deta_codi;
            
              update come_soli_serv_anex_plan p
                 set p.anpl_deta_esta_plan = 'N'
               where p.anpl_deta_codi = k.deta_codi
                 and p.anpl_indi_fact = 'N';
            
              if k.vehi_codi is not null then
                update come_vehi v
                   set v.vehi_indi_grua = 'N'
                 where v.vehi_codi = k.vehi_codi
                   and v.vehi_indi_grua = 'S';
              end if;
            end loop;
          end if;
        end if;
      end if;
    
    end if;
    --raise_Application_error (-20001,'si');
  end;

  procedure pp_actualizar_vendedor(p_sose in number, p_anexo in number) is
  
    v_user     varchar2(60) := fa_user;
    v_empleado number;
  
    v_anex_empl number;
    v_sose_clie number;
  begin
  
    select anex_empl_codi, a.sose_clpr_codi
      into v_anex_empl, v_sose_clie
      from come_soli_serv a, come_soli_serv_anex
     where sose_codi = anex_sose_codi
       and a.sose_codi = p_sose
       and anex_codi = p_anexo;
  
    begin
      select a.empl_codi
        into v_empleado
        from come_empl a, segu_user b
       where empl_codi = user_empl_codi
         and b.user_login = fa_user;
    exception
      when others then
        --  v_empleado := 1;
        raise_application_error(-20001,
                                'Falta configurar el usuario con la ficha de empleados');
    end;
  
    update come_soli_serv_anex a
       set anex_empl_codi = v_empleado
     where a.anex_codi = p_anexo;
  
  end pp_actualizar_vendedor;

  procedure pp_actu_modi(p_contrato           in number,
                         p_anexo              in number,
                         p_soli_nombre        in varchar2,
                         p_soli_apellido      in varchar2,
                         p_soli_doc_nro       in varchar2,
                         p_soli_fech_naci     in varchar2,
                         p_soli_esta_civi     in varchar2,
                         p_soli_naci          in varchar2,
                         p_vehi               in varchar2,
                         p_vehi_tipo          in varchar2,
                         p_vehi_mode          in varchar2,
                         p_vehi_marca         in varchar2,
                         p_vehi_anho          in varchar2,
                         p_vehi_colo          in varchar2,
                         p_vehi_chass         in varchar2,
                         p_vehi_matr          in varchar2,
                         p_anex_auto_ci       in varchar2,
                         p_anex_auto_nombre   in varchar2,
                         p_anex_auto_fech_nac in varchar2,
                         p_anex_auto_fech_vto in varchar2,
                         p_anex_auto_nac      in varchar2,
                         p_anex_esta_civil    in varchar2,
                         p_promo_mes_libr     in varchar2) is
  
    v_soli_nombre        varchar2(100);
    v_soli_apellido      varchar2(100);
    v_soli_doc_nro       varchar2(100);
    v_soli_fech_naci     date;
    v_soli_esta_civi     varchar2(1);
    v_soli_naci          varchar2(100);
    v_vehi_tipo          varchar2(100);
    v_vehi_mode          varchar2(100);
    v_vehi_marca         varchar2(100);
    v_vehi_anho          varchar2(100);
    v_vehi_colo          varchar2(100);
    v_vehi_chass         varchar2(100);
    v_vehi_matr          varchar2(100);
    v_anex_auto_ci       varchar2(100);
    v_anex_auto_nombre   varchar2(100);
    v_anex_auto_fech_nac varchar2(100);
    --v_anex_auto_fech_vto
    v_anex_auto_nac   varchar2(100);
    v_anex_esta_civil varchar2(1);
    v_seq_codigo      number;
    v_user            varchar2(100) := fa_user;
    v_fecha           date := sysdate;
    v_promo_mes_libr  varchar2(2);
  begin
  
    if p_soli_nombre is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_soli_apellido is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_soli_doc_nro is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_soli_fech_naci is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_soli_esta_civi is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_soli_naci is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_vehi is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_vehi_tipo is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_vehi_mode is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_vehi_marca is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_vehi_anho is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_vehi_colo is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_vehi_chass is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
    if p_vehi_matr is null then
      raise_application_error(-20001, 'El campo no puede quedar vacio');
    end if;
  
    -- raise_application_error(-20001, 'adfadf');
    select sose_nomb,
           sose_apel,
           sose_docu,
           sose_fech_naci,
           sose_esta_civi,
           sose_naci_codi
      into v_soli_nombre,
           v_soli_apellido,
           v_soli_doc_nro,
           v_soli_fech_naci,
           v_soli_esta_civi,
           v_soli_naci
      from come_soli_serv_clie_dato
     where sose_codi = p_contrato;
  
    select t.vehi_tive_codi,
           t.vehi_mode,
           t.vehi_mave_codi,
           t.vehi_anho,
           t.vehi_colo,
           t.vehi_nume_chas,
           t.vehi_nume_pate,
           deta_indi_prom_pror
      into v_vehi_tipo,
           v_vehi_mode,
           v_vehi_marca,
           v_vehi_anho,
           v_vehi_colo,
           v_vehi_chass,
           v_vehi_matr,
           v_promo_mes_libr
      from come_vehi t, come_soli_serv_anex_deta s
     where t.vehi_codi = s.deta_vehi_codi
       and vehi_codi = p_vehi;
  
    select anex_auto_ci,
           anex_auto_nombre,
           anex_auto_fech_nac,
           -- anex_auto_fech_vto,
           anex_auto_nac,
           anex_esta_civil
      into v_anex_auto_ci,
           v_anex_auto_nombre,
           v_anex_auto_fech_nac,
           --v_anex_auto_fech_vto,
           v_anex_auto_nac,
           v_anex_esta_civil
      from come_soli_serv_anex
     where anex_codi = p_anexo;
  
    ----------------actualiza el solicitud
  
    if v_soli_nombre <> p_soli_nombre or v_soli_apellido <> p_soli_apellido then
      update come_soli_serv_clie_dato s
         set sose_desc = p_soli_nombre || ' ' || p_soli_apellido
       where sose_codi = p_contrato;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_clie_dato',
         'sose_desc',
         v_soli_nombre || ' ' || v_soli_apellido,
         p_soli_nombre || ' ' || p_soli_apellido,
         v_user,
         v_fecha);
    end if;
  
    if v_soli_nombre <> p_soli_nombre then
      update come_soli_serv_clie_dato
         set sose_nomb = p_soli_nombre
       where sose_codi = p_contrato;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_clie_dato',
         'sose_nomb',
         v_soli_nombre,
         p_soli_nombre,
         v_user,
         v_fecha);
    end if;
  
    if v_soli_apellido <> p_soli_apellido then
      update come_soli_serv_clie_dato
         set sose_apel = p_soli_apellido
       where sose_codi = p_contrato;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_clie_dato',
         'sose_apel',
         v_soli_apellido,
         p_soli_apellido,
         v_user,
         v_fecha);
    end if;
  
    if v_soli_doc_nro <> p_soli_doc_nro then
      update come_soli_serv_clie_dato
         set sose_docu = p_soli_doc_nro
       where sose_codi = p_contrato;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_clie_dato',
         'sose_docu',
         v_soli_doc_nro,
         p_soli_doc_nro,
         v_user,
         v_fecha);
    end if;
  
    if v_soli_fech_naci <> p_soli_fech_naci or v_soli_fech_naci is null then
      update come_soli_serv_clie_dato
         set sose_fech_naci = p_soli_fech_naci
       where sose_codi = p_contrato;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_clie_dato',
         'sose_fech_naci',
         v_soli_fech_naci,
         p_soli_fech_naci,
         v_user,
         v_fecha);
    end if;
  
    if v_soli_esta_civi <> p_soli_esta_civi then
      update come_soli_serv_clie_dato
         set sose_esta_civi = p_soli_esta_civi
       where sose_codi = p_contrato;

      select seq_remo.nextval into v_seq_codigo from dual;

      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_clie_dato',
         'sose_esta_civi',
         v_soli_esta_civi,
         p_soli_esta_civi,
         v_user,
         v_fecha);
    end if;
  
    if v_soli_naci <> p_soli_naci then
      update come_soli_serv_clie_dato
         set sose_naci_codi = p_soli_naci
       where sose_codi = p_contrato;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_clie_dato',
         'sose_naci_codi',
         v_soli_naci,
         p_soli_naci,
         v_user,
         v_fecha);
    end if;
  
    ----------------actualizar vehiculo 
    if v_vehi_tipo <> p_vehi_tipo then
      update come_vehi
         set vehi_tive_codi = p_vehi_tipo
       where vehi_codi = p_vehi;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_vehi',
         'vehi_tive_codi',
         v_vehi_tipo,
         p_vehi_tipo,
         v_user,
         v_fecha);
    end if;
  
    if v_vehi_mode <> p_vehi_mode then
      update come_vehi
         set vehi_mode = p_vehi_mode
       where vehi_codi = p_vehi;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_vehi',
         'vehi_mode',
         v_vehi_mode,
         p_vehi_mode,
         v_user,
         v_fecha);
    end if;
  
    if v_vehi_marca <> p_vehi_marca then
      update come_vehi
         set vehi_mave_codi = p_vehi_marca
       where vehi_codi = p_vehi;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_vehi',
         'vehi_mave_codi',
         v_vehi_marca,
         p_vehi_marca,
         v_user,
         v_fecha);
    end if;
  
    if v_vehi_chass <> p_vehi_chass then
      update come_vehi
         set vehi_nume_chas = p_vehi_chass
       where vehi_codi = p_vehi;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_vehi',
         'vehi_nume_chas',
         v_vehi_chass,
         p_vehi_chass,
         v_user,
         v_fecha);
    end if;
  
    if v_vehi_anho <> p_vehi_anho then
      update come_vehi
         set vehi_anho = p_vehi_anho
       where vehi_codi = p_vehi;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_vehi',
         'vehi_anho',
         v_vehi_anho,
         p_vehi_anho,
         v_user,
         v_fecha);
    end if;
  
    if v_vehi_colo <> p_vehi_colo then
      update come_vehi
         set vehi_colo = p_vehi_colo
       where vehi_codi = p_vehi;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_vehi',
         'vehi_colo',
         v_vehi_colo,
         p_vehi_colo,
         v_user,
         v_fecha);
    end if;
  
    if v_vehi_matr <> p_vehi_matr then
      update come_vehi
         set vehi_nume_pate = p_vehi_matr
       where vehi_codi = p_vehi;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_vehi',
         'vehi_nume_pate',
         v_vehi_matr,
         p_vehi_matr,
         v_user,
         v_fecha);
    end if;
  
    ---------------actualizar datos del autorizante
  
    if nvl(v_anex_auto_ci, '.') <> p_anex_auto_ci then
      --raise_application_error(-20001,p_anex_auto_ci);
      update come_soli_serv_anex t
         set anex_auto_ci = p_anex_auto_ci
       where anex_codi = p_anexo; ----p_vehi;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_anex',
         'anex_auto_ci',
         v_anex_auto_ci,
         p_anex_auto_ci,
         v_user,
         v_fecha);
      --commit;
    end if;
    --raise_application_error(-20001,'2'||p_anex_auto_ci);
    if nvl(v_anex_auto_nombre, '.') <> p_anex_auto_nombre then
      update come_soli_serv_anex t
         set anex_auto_nombre = p_anex_auto_nombre
       where anex_codi = p_anexo; -- p_vehi;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_anex',
         'anex_auto_nombre',
         v_anex_auto_nombre,
         p_anex_auto_nombre,
         v_user,
         v_fecha);
    end if;
  
    if nvl(v_anex_auto_fech_nac, '.') <> p_anex_auto_fech_nac then
      update come_soli_serv_anex t
         set anex_auto_fech_nac = p_anex_auto_fech_nac
       where anex_codi = p_anexo; --p_vehi;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_anex',
         'anex_auto_fech_nac',
         v_anex_auto_fech_nac,
         p_anex_auto_fech_nac,
         v_user,
         v_fecha);
    end if;
    /*update come_soli_serv_anex t
      set anex_auto_fech_vto = 
    where anex_codi = p_vehi;  */
  
    if nvl(v_anex_auto_nac, '.') <> p_anex_auto_nac then
      update come_soli_serv_anex t
         set anex_auto_nac = p_anex_auto_nac
       where anex_codi = p_anexo; --p_vehi;  
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_anex',
         'anex_auto_nac',
         p_anex_auto_nac,
         v_anex_auto_nac,
         v_user,
         v_fecha);
    end if;
  
    if nvl(v_anex_esta_civil, '.') <> p_anex_esta_civil then
      update come_soli_serv_anex t
         set anex_esta_civil = p_anex_esta_civil
       where anex_codi = p_anexo; -- p_vehi;
      select seq_remo.nextval into v_seq_codigo from dual;
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_anex',
         'anex_esta_civil',
         v_anex_esta_civil,
         p_anex_esta_civil,
         v_user,
         v_fecha);
    end if;
  
    if nvl(v_promo_mes_libr, '.') <> p_promo_mes_libr then
    
      update come_soli_serv_anex_deta s
         set deta_indi_prom_pror = p_promo_mes_libr
       where s.deta_anex_codi = p_anexo;
    
      select seq_remo.nextval into v_seq_codigo from dual;
    
      insert into sose_anex_vehi_modi
        (reca_codigo,
         reca_sose,
         reca_anex,
         reca_vehi,
         reca_tabla,
         reca_colu,
         reca_dato_ante,
         reca_dato_actu,
         reca_login,
         reca_fech)
      values
        (v_seq_codigo,
         p_contrato,
         p_anexo,
         p_vehi,
         'come_soli_serv_anex',
         'anex_esta_civil',
         v_anex_esta_civil,
         p_anex_esta_civil,
         v_user,
         v_fecha);
    end if;
  
  end pp_actu_modi;

  procedure pp_actualiza_datos_cliente(p_cliente   in number,
                                       p_solicitud in number) is
  
    g_soli_serv_clie_dato come_soli_serv_clie_dato%rowtype;
  begin
    select *
      into g_soli_serv_clie_dato
      from come_soli_serv_clie_dato a
     where a.sose_codi = p_solicitud;
  
    if g_soli_serv_clie_dato.sose_desc is not null then
      ---raise_application_error(-20001,g_soli_serv_clie_dato.sose_desc||'+++'|| p_cliente);
      update come_clie_prov
         set clpr_desc = g_soli_serv_clie_dato.sose_desc
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_nomb is not null then
      update come_clie_prov
         set clpr_nomb = g_soli_serv_clie_dato.sose_nomb
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_apel is not null then
      update come_clie_prov
         set clpr_apel = g_soli_serv_clie_dato.sose_apel
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_tipo_docu is not null then
      update come_clie_prov
         set clpr_tipo_docu = g_soli_serv_clie_dato.sose_tipo_docu
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_docu is not null then
      update come_clie_prov
         set clpr_docu = g_soli_serv_clie_dato.sose_docu,
             clpr_ruc  = g_soli_serv_clie_dato.sose_docu
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_esta_civi is not null then
      update come_clie_prov
         set clpr_esta_civi = g_soli_serv_clie_dato.sose_esta_civi
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_sexo is not null then
      update come_clie_prov
         set clpr_sexo = g_soli_serv_clie_dato.sose_sexo
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_fech_naci is not null then
      update come_clie_prov
         set clpr_fech_naci = g_soli_serv_clie_dato.sose_fech_naci
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_dire is not null then
      update come_clie_prov
         set clpr_dire = g_soli_serv_clie_dato.sose_dire
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_tele_part is not null then
      update come_clie_prov
         set clpr_tele = g_soli_serv_clie_dato.sose_tele_part
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_email is not null then
      update come_clie_prov
         set clpr_email = g_soli_serv_clie_dato.sose_email
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_email_fact is not null then
      update come_clie_prov
         set clpr_email_fact = g_soli_serv_clie_dato.sose_email_fact
       where clpr_codi = p_cliente;
    
      update come_clie_fact_pago
         set fapa_emai_fact = g_soli_serv_clie_dato.sose_email_fact
       where fapa_clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_mepa_codi is not null then
      update come_clie_prov
         set clpr_mepa_codi = g_soli_serv_clie_dato.sose_mepa_codi
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_naci_codi is not null then
      update come_clie_prov
         set clpr_naci_codi = g_soli_serv_clie_dato.sose_naci_codi
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_zona_codi is not null then
      update come_clie_prov
         set clpr_zona_codi = g_soli_serv_clie_dato.sose_zona_codi
       where clpr_codi = p_cliente;
    end if;
    /*
    if g_soli_serv_clie_dato.sose_ciud_codi is not null then
      update come_clie_prov
         set clpr_ciud_codi = g_soli_serv_clie_dato.sose_ciud_codi
       where clpr_codi = p_cliente;
    end if;*/
  
    if g_soli_serv_clie_dato.sose_barr_codi is not null then
      update come_clie_prov
         set clpr_barr_codi = g_soli_serv_clie_dato.sose_barr_codi
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_prop_nomb is not null then
      update come_clie_prov
         set clpr_prop_nomb = g_soli_serv_clie_dato.sose_prop_nomb
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_prop_docu is not null then
      update come_clie_prov
         set clpr_prop_docu = g_soli_serv_clie_dato.sose_prop_docu
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_prop_carg is not null then
      update come_clie_prov
         set clpr_prop_carg = g_soli_serv_clie_dato.sose_prop_carg
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_prof_codi is not null then
      update come_clie_prov
         set clpr_prof_codi = g_soli_serv_clie_dato.sose_prof_codi
       where clpr_codi = p_cliente;
    end if;
  
    /* if g_clpr_clie_clas1_codi is not null then
        update come_clie_prov
           set clpr_clie_clas1_codi = g_clpr_clie_clas1_codi
         where clpr_codi = p_cliente;
      end if;
    */
    if g_soli_serv_clie_dato.sose_prop_nomb_2 is not null then
      update come_clie_prov
         set clpr_prop_nomb_2 = g_soli_serv_clie_dato.sose_prop_nomb_2
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_prop_docu_2 is not null then
      update come_clie_prov
         set clpr_prop_docu_2 = g_soli_serv_clie_dato.sose_prop_docu_2
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_prop_carg_2 is not null then
      update come_clie_prov
         set clpr_prop_carg_2 = g_soli_serv_clie_dato.sose_prop_carg_2
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_cont_desc is not null then
      update come_clie_prov
         set clpr_cont_desc = g_soli_serv_clie_dato.sose_cont_desc
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_cont_tele is not null then
      update come_clie_prov
         set clpr_cont_tele = g_soli_serv_clie_dato.sose_cont_tele
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_cont_emai is not null then
      update come_clie_prov
         set clpr_cont_emai = g_soli_serv_clie_dato.sose_cont_emai
       where clpr_codi = p_cliente;
    end if;
  
    if g_soli_serv_clie_dato.sose_refe_dire is not null then
      update come_clie_prov
         set clpr_refe_dire = g_soli_serv_clie_dato.sose_refe_dire
       where clpr_codi = p_cliente;
    end if;
    --   raise_application_error(-20001,g_soli_serv_clie_dato.sose_desc);
    --commit;--raise_application_error(-20001,'adf');
  end pp_actualiza_datos_cliente;

  procedure pp_actualizar_informconf2(p_solicitud  in varchar2,
                                      p_anexo      in varchar2,
                                      p_estado     out varchar2,
                                      p_pint       out varchar2,
                                      p_pasa       out number,
                                      p_autorizado out varchar2) is
  
    v_codigo       number;
    v_existe       number;
    v_estado       varchar2(1);
    v_link         varchar2(2000);
    v_rowid        varchar2(1000);
    v_infor        varchar2(2);
    v_tipo_doc     varchar(20);
    v_nro_doc      varchar2(100);
    v_doc_consul   varchar2(1000);
    v_faja         varchar2(2);
    v_autorizacion varchar2(2);
  begin
    
 
    select anex_faja_info, nvl(anex_info_auto, 'N')
      into v_faja, v_autorizacion
      from come_soli_serv_anex a
     where a.anex_codi = p_anexo;
 
  
   select case
             when a.sose_tipo_docu = 'RUC' then
              substr(sose_docu, 1, length(sose_docu) - 2)
           
             else
              sose_docu
           end nro_doc,
           'P' --decode(d.extr_tipo_doc,1,'P','E')
      into v_nro_doc, v_tipo_doc
      from come_soli_serv_clie_dato a
     where sose_codi = p_solicitud;

    ----------revisamos si tiene consulta menos de 8 dias
    if v_tipo_doc = 'P' then
      v_doc_consul := rtrim(ltrim(to_char(to_number(v_nro_doc),
                                          '999G999G999G999G999G999G990')));
    else
      v_doc_consul := v_nro_doc;
    end if;
  
    begin
      select info_scor scoring
        into v_infor
        from come_cons_informconf
       where info_serv_tipo_audi in ('P', 'E')
         and trunc(info_fech_audi) >= trunc(sysdate) - 8
         and replace(info_nro_docu, '.', '') = v_nro_doc
       group by info_scor;
    exception
      when no_data_found then
        v_infor := null;
      when too_many_rows then
        select info_scor scoring
          into v_infor
          from come_cons_informconf
         where info_serv_tipo_audi = v_tipo_doc
           and trunc(info_fech_audi) >= trunc(sysdate) - 8
           and replace(info_nro_docu, '.', '') = v_nro_doc
           and info_fech_audi =
               (select max(info_fech_audi)
                  from come_cons_informconf
                 where info_serv_tipo_audi in ('P', 'E')
                   and trunc(info_fech_audi) >= trunc(sysdate) - 8
                   and replace(info_nro_docu, '.', '') = v_nro_doc)
         group by info_scor;
      
      when others then
        v_infor := null;
    end;
    
    ---------si no hay informacion reciente se consulta a inforcomf 
  
    if v_infor is null then
       
    
    /*  begin
      
        -- Call the procedure
        pack_consultas_informconf.pp_consultar(v_nro_docu  => v_nro_doc,
                                               v_usuario   => fa_user,
                                               v_tipo_cons => v_tipo_doc);
      end;
    */
     
      -----------nuevamente consultamos los registros guardados
      begin
        select info_scor scoring
          into v_infor
          from come_cons_informconf
         where info_serv_tipo_audi in ('P', 'E')
           and trunc(info_fech_audi) >= trunc(sysdate) - 8
           and replace(info_nro_docu, '.', '') = v_nro_doc;
      exception
        when no_data_found then
          v_infor := null;
        when too_many_rows then
            /* if gen_user = 'SKN' THEN
  raise_application_error(-20001, 'hoal'||v_tipo_doc||''||v_nro_doc);
  END IF;*/
          select info_scor scoring
            into v_infor
            from come_cons_informconf
           where info_serv_tipo_audi = v_tipo_doc
             and trunc(info_fech_audi) >= trunc(sysdate) - 8
             and replace(info_nro_docu, '.', '') = v_nro_doc
             and info_fech_audi =
                 (select max(info_fech_audi)
                    from come_cons_informconf
                   where info_serv_tipo_audi in ('P', 'E')
                     and trunc(info_fech_audi) >= trunc(sysdate) - 8
                     and replace(info_nro_docu, '.', '') = v_nro_doc);
        when others then
          v_infor := null;
      end;
    
    end if;
   v_infor := 'A';
   v_autorizacion := 'S';
    if v_faja is null then
    
      if v_infor not in ('M', 'N', 'X') then
        v_autorizacion := 'S';
      
      else
        v_autorizacion := 'N';
      end if;
      update come_soli_serv_anex
         set anex_faja_info = v_infor, anex_info_auto = v_autorizacion
       where anex_codi = p_anexo;
    elsif v_faja is not null and v_infor <> v_faja then
      if v_infor not in ('M', 'N', 'X') then
        v_autorizacion := 'S';
      
      else
        v_autorizacion := 'N';
      end if;
      update come_soli_serv_anex
         set anex_faja_info = v_infor, anex_info_auto = v_autorizacion
       where anex_codi = p_anexo;
    
    else
      v_infor := v_faja;
    If v_infor not in ('M', 'N', 'X') then
        v_autorizacion := 'S';
     ELSIF  v_infor  in ('M', 'N', 'X') AND v_autorizacion = 'S' then
        v_autorizacion := 'S'; 
       ELSIF  v_infor  in ('M', 'N', 'X') AND nvl(v_autorizacion,'S') <> 'S' then
        v_autorizacion := 'N';
      end if;
      
       
      update come_soli_serv_anex
         set anex_faja_info = v_infor, 
         anex_info_auto = v_autorizacion
       where anex_codi = p_anexo;
     
    end if;
    
  
  
    /*v_infor := 'X';
    
    v_autorizacion := 'S';*/
    /*IF GEN_USER = 'SKN' THEN
    RAISE_APPLICATION_ERROR(-20001,v_infor||''||v_autorizacion||v_faja );
    END IF;*/
    
 
    if v_infor is not null and v_infor not in ('M', 'N', 'X') then
      p_pint       := 'PASA INFORMCONF - FAJA: ' || v_infor;
      p_pasa       := 1;
      p_autorizado := 'S';
    else
      p_estado     := 'NO PASA INFORMCONF - FAJA: ' || v_infor;
      p_pasa       := 2;
      p_autorizado := 'N';
    end if;
  
    if /* v_infor is not null and */
     v_infor in ('M', 'N', 'X') and v_autorizacion = 'S' then
    
      p_estado     := 'NO PASA INFORMCONF - FAJA: ' || v_infor ||
                      ' -AUTORIZADO';
      p_pasa       := 2;
      p_autorizado := 'S';
    end if;
    
   
  
  end pp_actualizar_informconf2;
  
  -------------------------------------------------------------------------------**
   procedure pp_actualizar_informconf2_no(p_solicitud  in varchar2,
                                    p_anexo      in varchar2,
                                    p_estado     out varchar2,
                                    p_pint       out varchar2,
                                    p_pasa       out number,
                                    p_autorizado out varchar2) is
  
    v_codigo       number;
    v_existe       number;
    v_estado       varchar2(1);
    v_link         varchar2(2000);
    v_rowid        varchar2(1000);
    v_infor        varchar2(2);
    v_tipo_doc     varchar(20);
    v_nro_doc      varchar2(100);
    v_doc_consul   varchar2(1000);
    v_faja         varchar2(2);
    v_autorizacion varchar2(2);
  
    ---------------------------
    v_faja_autorizante varchar2(2);
    v_ci_autorizante   varchar2(100);
    v_autorizante      varchar2(2);
    v_tipo_doc_auto    varchar(20);
    v_infor_auto       varchar2(2);
    v_doc_consul_auto  varchar2(1000);
  
    v_esta_clie         varchar2(1);
    v_no_pasa_pero_auto varchar2(1);
    v_autorizacion_1    varchar2(1);
    v_anex_esta         varchar2(1);
  begin
  
    select anex_faja_info,
           nvl(anex_info_auto, 'N'),
           anex_faja_info_auto,
           anex_auto_ci,
           decode(anex_auto_ci, null, 'N', 'S') autorizante,
           anex_esta
      into v_faja,
           v_autorizacion,
           v_faja_autorizante,
           v_ci_autorizante,
           v_autorizante,
           v_anex_esta
      from come_soli_serv_anex a
     where a.anex_codi = p_anexo;
  
    if v_autorizacion = 'N' and v_anex_esta = 'P' then
    
      select case
               when a.sose_tipo_docu = 'RUC' then
                substr(sose_docu, 1, length(sose_docu) - 2)
             
               else
                sose_docu
             end nro_doc,
             'P' --decode(d.extr_tipo_doc,1,'P','E')
        into v_nro_doc, v_tipo_doc
        from come_soli_serv_clie_dato a
       where sose_codi = p_solicitud;
    
      ----------revisamos si tiene consulta menos de 8 dias
      if v_tipo_doc = 'P' then
        v_doc_consul := rtrim(ltrim(to_char(to_number(v_nro_doc),
                                            '999G999G999G999G999G999G990')));
      else
        v_doc_consul := v_nro_doc;
      end if;
    
      begin
        select info_scor scoring
          into v_infor
          from come_cons_informconf
         where info_serv_tipo_audi in ('P', 'E')
           and trunc(info_fech_audi) >= trunc(sysdate) - 8
           and replace(info_nro_docu, '.', '') = v_nro_doc
         group by info_scor;
      exception
        when no_data_found then
          v_infor := null;
        when too_many_rows then
          select info_scor scoring
            into v_infor
            from come_cons_informconf
           where info_serv_tipo_audi = v_tipo_doc
             and trunc(info_fech_audi) >= trunc(sysdate) - 8
             and replace(info_nro_docu, '.', '') = v_nro_doc
             and info_fech_audi =
                 (select max(info_fech_audi)
                    from come_cons_informconf
                   where info_serv_tipo_audi in ('P', 'E')
                     and trunc(info_fech_audi) >= trunc(sysdate) - 8
                     and replace(info_nro_docu, '.', '') = v_nro_doc)
           group by info_scor;
        
        when others then
          v_infor := null;
      end;
    
      ---------si no hay informacion reciente se consulta a inforcomf 
    
      if v_infor is null then
      
        begin
        
          -- Call the procedure
          pack_consultas_informconf.pp_consultar(v_nro_docu  => v_nro_doc,
                                                 v_usuario   => fa_user,
                                                 v_tipo_cons => v_tipo_doc);
        end;
      
        -----------nuevamente consultamos los registros guardados
      
        begin
          select info_scor scoring
            into v_infor
            from come_cons_informconf
           where info_serv_tipo_audi in ('P', 'E')
             and trunc(info_fech_audi) >= trunc(sysdate) - 8
             and replace(info_nro_docu, '.', '') = v_nro_doc;
        exception
          when no_data_found then
            v_infor := null;
          when too_many_rows then
            select info_scor scoring
              into v_infor
              from come_cons_informconf
             where info_serv_tipo_audi = v_tipo_doc
               and trunc(info_fech_audi) >= trunc(sysdate) - 8
               and replace(info_nro_docu, '.', '') = v_nro_doc
               and info_fech_audi =
                   (select max(info_fech_audi)
                      from come_cons_informconf
                     where info_serv_tipo_audi in ('P', 'E')
                       and trunc(info_fech_audi) >= trunc(sysdate) - 8
                       and replace(info_nro_docu, '.', '') = v_nro_doc);
          
          when others then
            v_infor := null;
        end;
      
      end if;
    
      /********************************************************************************************************
      ***********************************controlamos si tiene autorizante*************************************
      ********************************************************************************************************/
    
      if v_autorizante = 'S' then
      
        --ya que no contamos con el tipo de documento, si tiene - es ruc, sino ci
      
        if v_ci_autorizante like '%-%' then
          v_ci_autorizante := substr(v_ci_autorizante,
                                     1,
                                     length(v_ci_autorizante) - 2);
          v_tipo_doc_auto  := 'E';
        else
          v_ci_autorizante := v_ci_autorizante;
          v_tipo_doc_auto  := 'P';
        end if;
      
        ----------revisamos si tiene consulta menos de 8 dias
        if v_tipo_doc_auto = 'P' then
          v_doc_consul_auto := rtrim(ltrim(to_char(to_number(v_ci_autorizante),
                                                   '999G999G999G999G999G999G990')));
        else
          v_doc_consul_auto := v_ci_autorizante;
        end if;
      
        begin
          select info_scor scoring
            into v_infor_auto
            from come_cons_informconf
           where info_serv_tipo_audi in ('P', 'E')
             and trunc(info_fech_audi) >= trunc(sysdate) - 8
             and replace(info_nro_docu, '.', '') = v_ci_autorizante
           group by info_scor;
        exception
          when no_data_found then
            v_infor_auto := null;
          when too_many_rows then
            select info_scor scoring
              into v_infor_auto
              from come_cons_informconf
             where info_serv_tipo_audi = v_tipo_doc_auto
               and trunc(info_fech_audi) >= trunc(sysdate) - 8
               and replace(info_nro_docu, '.', '') = v_ci_autorizante
               and info_fech_audi =
                   (select max(info_fech_audi)
                      from come_cons_informconf
                     where info_serv_tipo_audi in ('P', 'E')
                       and trunc(info_fech_audi) >= trunc(sysdate) - 8
                       and replace(info_nro_docu, '.', '') =
                           v_ci_autorizante)
             group by info_scor;
          
          when others then
            v_infor_auto := null;
        end;
      
        ---------si no hay informacion reciente se consulta a inforcomf 
      
        if v_infor_auto is null then
        
          begin
          
            -- Call the procedure
            pack_consultas_informconf.pp_consultar(v_nro_docu  => v_ci_autorizante,
                                                   v_usuario   => fa_user,
                                                   v_tipo_cons => v_tipo_doc_auto);
          end;
        
          -----------nuevamente consultamos los registros guardados
        
          begin
            select info_scor scoring
              into v_infor_auto
              from come_cons_informconf
             where info_serv_tipo_audi in ('P', 'E')
               and trunc(info_fech_audi) >= trunc(sysdate) - 8
               and replace(info_nro_docu, '.', '') = v_ci_autorizante;
          exception
            when no_data_found then
              v_infor_auto := null;
            when too_many_rows then
              select info_scor scoring
                into v_infor_auto
                from come_cons_informconf
               where info_serv_tipo_audi = v_tipo_doc_auto
                 and trunc(info_fech_audi) >= trunc(sysdate) - 8
                 and replace(info_nro_docu, '.', '') = v_ci_autorizante
                 and info_fech_audi =
                     (select max(info_fech_audi)
                        from come_cons_informconf
                       where info_serv_tipo_audi in ('P', 'E')
                         and trunc(info_fech_audi) >= trunc(sysdate) - 8
                         and replace(info_nro_docu, '.', '') =
                             v_ci_autorizante);
            
            when others then
              v_infor_auto := null;
          end;
        
        end if;
      
      end if;
    
     
        -------------si no tiene autorizante sigue el proceso normal 
      
        if v_faja is null then
        
          if v_infor not in ('M', 'N', 'X') then
            v_autorizacion := 'S';
          else
            v_autorizacion := 'N';
          end if;
          
          update come_soli_serv_anex
             set anex_faja_info = v_infor, 
                 anex_info_auto = v_autorizacion
           where anex_codi = p_anexo;
           
        elsif v_faja is not null and v_infor <> v_faja then
          
          if v_infor not in ('M', 'N', 'X') then
            v_autorizacion := 'S';
          else
            v_autorizacion := 'N';
          end if;
          
          update come_soli_serv_anex
             set anex_faja_info = v_infor, 
                 anex_info_auto = v_autorizacion
           where anex_codi = p_anexo;
        
        else
           if v_infor not in ('M', 'N', 'X') then
            v_autorizacion := 'S';
          else
            v_autorizacion := 'N';
          end if;
           update come_soli_serv_anex
             set anex_faja_info = v_infor, 
                 anex_info_auto = v_autorizacion
           where anex_codi = p_anexo;
          v_infor := v_faja;
        end if;
      
      if v_autorizante = 'S' then
        
        if v_faja_autorizante is null then
        
          if v_infor_auto not in ('M', 'N', 'X') then
            v_autorizacion_1 := 'S';
          else
            v_autorizacion_1 := 'N';
          end if;
        
          update come_soli_serv_anex
             set anex_faja_info_auto = v_infor_auto
           where anex_codi = p_anexo;
        
        elsif  v_faja_autorizante is NOT null AND  v_infor_auto <> v_faja_autorizante then
          if v_infor_auto not in ('M', 'N', 'X') then
            v_autorizacion_1 := 'S';
          else
            v_autorizacion_1 := 'N';
          end if;
          
          update come_soli_serv_anex
             set anex_faja_info_auto = v_infor_auto
           where anex_codi = p_anexo;
        else
          if v_infor_auto not in ('M', 'N', 'X') then
            v_autorizacion_1 := 'S';
          else
            v_autorizacion_1 := 'N';
          end if;
          
          update come_soli_serv_anex
             set anex_faja_info_auto = v_infor_auto
           where anex_codi = p_anexo;
          v_infor_auto := v_faja_autorizante;
        end if;
        
    /*  if 'SKN' = FA_USER THEN
      dbms_output.put_line('HOLIS'||v_autorizacion_1||''||v_autorizacion);
      END IF;*/
        if v_autorizacion_1 = 'S' and v_autorizacion = 'S' then
          update come_soli_serv_anex
             set anex_info_auto = 'S'
           where anex_codi = p_anexo;
        
        else
          update come_soli_serv_anex
             set anex_info_auto = 'N'
           where anex_codi = p_anexo;
        
        end if;
      
      end if;
    else
      
    v_infor := v_faja;
    v_infor_auto :=v_faja_autorizante;
    end if;
 

    if v_infor is not null and v_infor not in ('M', 'N', 'X') then
      p_pint       := 'PASA INFORMCONF - FAJA: ' || v_infor;
      p_pasa       := 1;
      p_autorizado := 'S';
      v_esta_clie  := 'S';
    else
      p_estado     := 'NO PASA INFORMCONF - FAJA: ' || v_infor;
      p_pasa       := 2;
      p_autorizado := 'N';
      v_esta_clie  := 'N';
    end if;
  
    if v_infor in ('M', 'N', 'X') and v_autorizacion = 'S' then
    
      p_estado            := 'NO PASA INFORMCONF - FAJA: ' || v_infor || ' -AUTORIZADO';
      p_pasa              := 2;
      p_autorizado        := 'S';
      v_esta_clie         := 'S';
      v_no_pasa_pero_auto := 'S';
    end if;
  
    -----------------------------si tiene autorizante, validamos el inforconf del autorizante tambien
    if v_autorizante = 'S' then
 
     
      
        if v_esta_clie = 'N' then
        
          if /*v_infor_auto is not null and */v_infor_auto not in ('M', 'N', 'X') then
         --  raise_application_Error(-20001,v_infor_auto||'-'||v_esta_clie);
             p_estado       := 'CLIENTE: NO PASA INFORMCONF - FAJA: ' || v_infor ||
                             ' AUTORIZANTE: PASA INFORMCONF - FAJA: ' ||v_infor_auto;
            p_pasa       := 2;
            p_autorizado := 'N';
          else
            p_estado     := 'CLIENTE: NO PASA INFORMCONF - FAJA: ' || v_infor ||
                            ' AUTORIZANTE: NO PASA INFORMCONF - FAJA: ' ||v_infor_auto;
            p_pasa       := 2;
            p_autorizado := 'N';
          end if;
        
        else
          if nvl(v_no_pasa_pero_auto, 'N') = 'N' then
            ------SI EL CLIENTE PASA SIN NECESIDAD DE AUTORIZACION
            if v_infor_auto is not null and
               v_infor_auto not in ('M', 'N', 'X') then
              p_pint       := 'CLIENTE: PASA INFORMCONF - FAJA: ' ||v_infor ||' AUTORIZANTE: PASA INFORMCONF - FAJA: ' ||v_infor_auto;
              p_pasa       := 1;
              p_autorizado := 'S';
            else
              p_estado     := 'CLIENTE: PASA INFORMCONF - FAJA: ' ||v_infor ||
                              ' AUTORIZANTE: NO PASA INFORMCONF - FAJA: ' ||v_infor_auto;
              p_pasa       := 2;
              p_autorizado := 'N';
            end if;
          
          else
            -----------LA SOLICITUD PASO CON AUTORIZACIN 
          
            if v_infor_auto is not null and
               v_infor_auto not in ('M', 'N', 'X') then
              p_pint       := 'CLIENTE: NO PASA INFORMCONF - FAJA: ' ||v_infor ||
                              ' AUTORIZANTE: PASA INFORMCONF - FAJA: ' ||v_infor_auto || ' -AUTORIZADO';
              p_pasa       := 1;
              p_autorizado := 'S';
            else
              p_pint     := 'CLIENTE: NO PASA INFORMCONF - FAJA: ' || v_infor ||
                              ' AUTORIZANTE: NO PASA INFORMCONF - FAJA: ' ||v_infor_auto || ' -AUTORIZADO';
              p_pasa       := 1;
              p_autorizado := 'S';
            end if;
          
          end if;
        
        end if;
      
    end if;
  
   
  end pp_actualizar_informconf2_no;

end i020287_a;
