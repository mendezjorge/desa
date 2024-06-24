
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010057" is

  procedure PP_GENERA_CODI_ALTE(o_secu_codi_alte out number) is
  begin
    select NVL(max(to_number(secu_codi_alte)), 0) + 1
      into o_secu_codi_alte
      from come_secu
     where secu_empr_codi = v('AI_EMPR_CODI');
  
  exception
    when others then
      null;
    
  end;

  procedure pp_actualizar_regis(p_indi                in varchar2,
                                p_secu_codi           in number,
                                p_secu_desc           in varchar2,
                                p_secu_nume_fact      in number,
                                p_secu_nume_tras      in number,
                                p_secu_nume_cobr      in number,
                                p_secu_nume_pres_clie in number,
                                p_secu_nume_fact_negr in number,
                                p_secu_nume_remi_clie in number,
                                p_secu_nume_ajus      in number,
                                p_secu_nume_orco      in number,
                                p_secu_nume_apli      in number,
                                p_secu_nume_nota_cred in number,
                                p_secu_nume_ortr      in number,
                                p_secu_nume_inte_orpe in number,
                                p_secu_nume_ortr_aste in number,
                                p_secu_nume_ortr_seex in number,
                                p_secu_nume_soli_mate in number,
                                p_secu_nume_devu_mate in number,
                                p_secu_nume_mano_obra in number,
                                p_secu_nume_reoc      in number,
                                p_secu_nume_entr      in number,
                                p_secu_nume_prov      in number,
                                p_secu_nume_prod      in number,
                                p_secu_nume_prod_lote in number,
                                p_secu_nume_lote      in number,
                                p_secu_nume_orpe_nume in number,
                                p_secu_nume_clie      in number,
                                p_secu_soci_nume      in number,
                                p_secu_cuen_soci_nume in number,
                                p_secu_cope_movi_nume in number,
                                p_secu_cope_cont_nume in number,
                                p_secu_cope_sopr_nume in number,
                                p_secu_nume_orpa      in number,
                                p_secu_nume_reten     in number,
                                p_secu_nume_orse      in number,
                                p_secu_nume_cons_inte in number,
                                p_secu_nume_auto_fact in number,
                                p_secu_form_impr_fact in varchar2,
                                p_secu_cant_line_fact in number,
                                p_secu_cant_cara_fact in number) is
  begin
  
    -- RAISE_APPLICATION_ERROR(-20010, p_indi);
  
    if p_indi = 'N' then
    
      -- insertar nuevo registro
      insert into come_secu
        (secu_codi,
         secu_desc,
         secu_user_regi,
         secu_fech_regi,
         --secu_user_modi,
         --secu_fech_modi,
         secu_nume_fact,
         secu_nume_tras,
         secu_nume_cobr,
         secu_nume_pres_clie,
         secu_nume_fact_negr,
         secu_nume_remi_clie,
         secu_nume_ajus,
         secu_nume_orco,
         secu_nume_apli,
         secu_nume_nota_cred,
         secu_nume_ortr,
         secu_nume_inte_orpe,
         secu_nume_ortr_aste,
         secu_nume_ortr_seex,
         secu_nume_soli_mate,
         secu_nume_devu_mate,
         secu_nume_mano_obra,
         secu_nume_reoc,
         secu_nume_entr,
         secu_nume_prov,
         secu_nume_prod,
         secu_nume_prod_lote,
         secu_nume_lote,
         secu_nume_orpe_nume,
         secu_nume_clie,
         secu_soci_nume,
         secu_cuen_soci_nume,
         secu_cope_movi_nume,
         secu_cope_cont_nume,
         secu_cope_sopr_nume,
         secu_nume_orpa,
         secu_nume_reten,
         secu_nume_orse,
         secu_nume_cons_inte,
         secu_nume_auto_fact,
         secu_form_impr_fact,
         secu_cant_line_fact,
         secu_cant_cara_fact,
         secu_empr_codi)
      values
        (p_secu_codi,
         p_secu_desc,
         gen_user,
         sysdate,
         --p_secu_user_modi,
         --p_secu_fech_modi,
         p_secu_nume_fact,
         p_secu_nume_tras,
         p_secu_nume_cobr,
         p_secu_nume_pres_clie,
         p_secu_nume_fact_negr,
         p_secu_nume_remi_clie,
         p_secu_nume_ajus,
         p_secu_nume_orco,
         p_secu_nume_apli,
         p_secu_nume_nota_cred,
         p_secu_nume_ortr,
         p_secu_nume_inte_orpe,
         p_secu_nume_ortr_aste,
         p_secu_nume_ortr_seex,
         p_secu_nume_soli_mate,
         p_secu_nume_devu_mate,
         p_secu_nume_mano_obra,
         p_secu_nume_reoc,
         p_secu_nume_entr,
         p_secu_nume_prov,
         p_secu_nume_prod,
         p_secu_nume_prod_lote,
         p_secu_nume_lote,
         p_secu_nume_orpe_nume,
         p_secu_nume_clie,
         p_secu_soci_nume,
         p_secu_cuen_soci_nume,
         p_secu_cope_movi_nume,
         p_secu_cope_cont_nume,
         p_secu_cope_sopr_nume,
         p_secu_nume_orpa,
         p_secu_nume_reten,
         p_secu_nume_orse,
         p_secu_nume_cons_inte,
         p_secu_nume_auto_fact,
         p_secu_form_impr_fact,
         p_secu_cant_line_fact,
         p_secu_cant_cara_fact,
         v('AI_EMPR_CODI'));
    
    elsif p_indi = 'U' then
    
      -- actualizar registro existente
      update come_secu
         set secu_desc           = p_secu_desc,
             secu_user_modi      = gen_user,
             secu_nume_fact      = p_secu_nume_fact,
             secu_fech_modi      = sysdate,
             secu_nume_tras      = p_secu_nume_tras,
             secu_nume_cobr      = p_secu_nume_cobr,
             secu_nume_pres_clie = p_secu_nume_pres_clie,
             secu_nume_fact_negr = p_secu_nume_fact_negr,
             secu_nume_remi_clie = p_secu_nume_remi_clie,
             secu_nume_ajus      = p_secu_nume_ajus,
             secu_nume_orco      = p_secu_nume_orco,
             secu_nume_apli      = p_secu_nume_apli,
             secu_nume_nota_cred = p_secu_nume_nota_cred,
             secu_nume_ortr      = p_secu_nume_ortr,
             secu_nume_inte_orpe = p_secu_nume_inte_orpe,
             secu_nume_ortr_aste = p_secu_nume_ortr_aste,
             secu_nume_ortr_seex = p_secu_nume_ortr_seex,
             secu_nume_soli_mate = p_secu_nume_soli_mate,
             secu_nume_devu_mate = p_secu_nume_devu_mate,
             secu_nume_mano_obra = p_secu_nume_mano_obra,
             secu_nume_reoc      = p_secu_nume_reoc,
             secu_nume_entr      = p_secu_nume_entr,
             secu_nume_prov      = p_secu_nume_prov,
             secu_nume_prod      = p_secu_nume_prod,
             secu_nume_prod_lote = p_secu_nume_prod_lote,
             secu_nume_lote      = p_secu_nume_lote,
             secu_nume_orpe_nume = p_secu_nume_orpe_nume,
             secu_nume_clie      = p_secu_nume_clie,
             secu_soci_nume      = p_secu_soci_nume,
             secu_cuen_soci_nume = p_secu_cuen_soci_nume,
             secu_cope_movi_nume = p_secu_cope_movi_nume,
             secu_cope_cont_nume = p_secu_cope_cont_nume,
             secu_cope_sopr_nume = p_secu_cope_sopr_nume,
             secu_nume_orpa      = p_secu_nume_orpa,
             secu_nume_reten     = p_secu_nume_reten,
             secu_nume_orse      = p_secu_nume_orse,
             secu_nume_cons_inte = p_secu_nume_cons_inte,
             secu_nume_auto_fact = p_secu_nume_auto_fact,
             secu_form_impr_fact = p_secu_form_impr_fact,
             secu_cant_line_fact = p_secu_cant_line_fact,
             secu_cant_cara_fact = p_secu_cant_cara_fact
       where secu_codi = p_secu_codi;
    
    elsif p_indi = 'D' then
    
      delete from come_secu where secu_codi = p_secu_codi;
    
    else
    
      raise_application_error(-20010, 'Operacion no soportada');
    end if;
  
    begin
      I010057.pp_actualizar_timb(p_SETC_SECU_CODI => p_secu_codi);
    end;
  
  end;

  --------------------------------------

  procedure pp_cargar_timbrado(p_secuencia in number) is
  
    cursor timbrado is
      select SETC_SECU_CODI,
             SETC_TICO_CODI,
             SETC_ESTA,
             SETC_PUNT_EXPE,
             SETC_NUME_TIMB,
             SETC_FECH_INIC,
             SETC_FECH_VENC,
             SETC_BASE,
             SETC_NUME_AUTO_IMPR
        from COME_SECU_TIPO_COMP
       where setc_secu_codi = p_secuencia;
  
    v_desc varchar2(200);
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'TIMBRADO');
  
    for x in timbrado loop
    
      apex_collection.add_member(p_collection_name => 'TIMBRADO',
                                 p_c001            => x.SETC_SECU_CODI,
                                 p_c002            => x.SETC_TICO_CODI,
                                 p_c003            => x.SETC_ESTA,
                                 p_c004            => x.SETC_PUNT_EXPE,
                                 p_c005            => x.SETC_NUME_TIMB,
                                 p_c006            => x.SETC_FECH_INIC,
                                 p_c007            => x.SETC_FECH_VENC,
                                 p_c008            => x.SETC_BASE,
                                 p_c009            => x.SETC_NUME_AUTO_IMPR,
                                 p_c011            => x.SETC_TICO_CODI,
                                 p_c012            => x.SETC_ESTA,
                                 p_c013            => x.SETC_PUNT_EXPE,
                                 p_c014            => x.SETC_NUME_TIMB,
                                 p_c015            => x.SETC_FECH_INIC,
                                 p_c016            => x.SETC_FECH_VENC,
                                 p_c017            => x.SETC_BASE);
    
    end loop;
  
  end pp_cargar_timbrado;

  ------------------------------------------------

  PROCEDURE pp_editar_timb(SEC_ID         in number,
                           SETC_TICO_CODI in number,
                           SETC_ESTA      in number,
                           SETC_PUNT_EXPE in number,
                           SETC_NUME_TIMB in number,
                           SETC_FECH_INIC in date,
                           SETC_FECH_VENC in date) IS
  
    v_SETC_SECU_CODI      number;
    v_SETC_BASE           number;
    v_SETC_NUME_AUTO_IMPR varchar2(60);
    v_setc_punt_expe      number := setc_punt_expe;
    v_setc_tico_codi      number := setc_tico_codi;
    v_setc_esta           number := setc_esta;
    v_count               number := 0;
  
  BEGIN
  
    begin
    
      select c001 SETC_SECU_CODI
        into v_SETC_SECU_CODI
        from apex_collections
       where collection_name = 'TIMBRADO'
         and seq_id = seq_id;
    exception
      when no_data_found then
        v_SETC_SECU_CODI := null;
      
    end;
    if setc_tico_codi is not null then
      if setc_esta is null then
        raise_application_error(-20010,
                                'Debe ingresar un Establecimiento.');
      end if;
      if setc_punt_expe is null then
        raise_application_error(-20010,
                                'Debe ingresar un Punto de Expedicion.');
      end if;
      if setc_nume_timb is null then
        raise_application_error(-20010,
                                'Debe ingresar un Numero de Timbrado.');
      end if;
      if setc_fech_venc is null then
        raise_application_error(-20010,
                                'Debe ingresar una Fecha de Vencimiento de Timbrado.');
      end if;
    end if;
  
    if v_setc_punt_expe is not null then
      select count(*)
        into v_count
        from come_secu_tipo_comp
       where setc_secu_codi = v_setc_SECU_codi
         and setc_tico_codi = v_setc_tico_codi --tipo de comprobante
         and setc_esta      = v_setc_esta      --establecimiento 
         and setc_punt_expe = v_setc_punt_expe --punto de expedicion
         and setc_fech_venc > sysdate;
    
      if v_count > 0 then
        raise_application_error(-20010,
                                'Existe un timbrado vigente para ese tipo de comprobante.');
      end if;
    end if;
  
    if SEC_ID is not null then
      apex_collection.update_member_attribute(p_collection_name => 'TIMBRADO',
                                              p_seq             => sec_id,
                                              p_attr_number     => 2,
                                              p_attr_value      => SETC_TICO_CODI);
    
      apex_collection.update_member_attribute(p_collection_name => 'TIMBRADO',
                                              p_seq             => sec_id,
                                              p_attr_number     => 3,
                                              p_attr_value      => SETC_ESTA);
      apex_collection.update_member_attribute(p_collection_name => 'TIMBRADO',
                                              p_seq             => sec_id,
                                              p_attr_number     => 4,
                                              p_attr_value      => SETC_PUNT_EXPE);
    
      apex_collection.update_member_attribute(p_collection_name => 'TIMBRADO',
                                              p_seq             => sec_id,
                                              p_attr_number     => 5,
                                              p_attr_value      => SETC_NUME_TIMB);
      apex_collection.update_member_attribute(p_collection_name => 'TIMBRADO',
                                              p_seq             => sec_id,
                                              p_attr_number     => 6,
                                              p_attr_value      => SETC_FECH_INIC);
    
      apex_collection.update_member_attribute(p_collection_name => 'TIMBRADO',
                                              p_seq             => sec_id,
                                              p_attr_number     => 7,
                                              p_attr_value      => SETC_FECH_VENC);
    
      apex_collection.update_member_attribute(p_collection_name => 'TIMBRADO',
                                              p_seq             => sec_id,
                                              p_attr_number     => 10,
                                              p_attr_value      => 'ED');
    
    else
    
      apex_collection.add_member(p_collection_name => 'TIMBRADO',
                                 p_c001            => v_SETC_SECU_CODI,
                                 p_c002            => SETC_TICO_CODI,
                                 p_c003            => SETC_ESTA,
                                 p_c004            => SETC_PUNT_EXPE,
                                 p_c005            => SETC_NUME_TIMB,
                                 p_c006            => SETC_FECH_INIC,
                                 p_c007            => SETC_FECH_VENC,
                                 p_c008            => v_SETC_BASE,
                                 p_c009            => v_SETC_NUME_AUTO_IMPR,
                                 p_c010            => 'I');
    
    end if;
  
  END pp_editar_timb;

  -----------------------------------------------------------

  PROCEDURE pp_actualizar_timb(p_SETC_SECU_CODI in number) is
    p_codi_base number := 1;
    v_count     number := 0;
  
    cursor timbrado is
    
      select c001 SETC_SECU_CODI,
             c002 SETC_TICO_CODI,
             c002 SETC_TICO_CODI_2,
             c003 SETC_ESTA,
             c004 SETC_PUNT_EXPE,
             c005 SETC_NUME_TIMB,
             c006 SETC_FECH_INIC,
             c007 SETC_FECH_VENC,
             c008 SETC_BASE,
             c009 SETC_NUME_AUTO_IMPR,
             c010 ACCION,
             c011 SETC_TICO_CODI_1,
             c012 SETC_ESTA_1,
             c013 SETC_PUNT_EXPE_1,
             c014 SETC_NUME_TIMB_1,
             c015 SETC_FECH_INIC_1,
             c016 SETC_FECH_VENC_1,
             c017 SETC_BASE_1
        from apex_collections
       where collection_name = 'TIMBRADO';
  
  begin
  
    for x in timbrado loop
      if x.accion = 'I' or x.SETC_SECU_CODI is null then
        insert into come_secu_tipo_comp
          (setc_secu_codi,
           setc_tico_codi,
           setc_nume_timb,
           setc_fech_venc,
           setc_base,
           setc_esta,
           setc_punt_expe,
           setc_fech_inic,
           setc_nume_auto_impr)
        values
          (p_SETC_SECU_CODI,
           x.setc_tico_codi,
           x.setc_nume_timb,
           x.setc_fech_venc,
           p_codi_base,
           x.setc_esta,
           x.setc_punt_expe,
           x.setc_fech_inic,
           x.setc_nume_auto_impr);
      
      elsif x.accion = 'ED' then
        --raise_application_error(-20010, 'Operacion no soportada');
        update come_secu_tipo_comp
           set setc_tico_codi = x.setc_tico_codi,
               setc_nume_timb = x.setc_nume_timb,
               setc_fech_venc = x.setc_fech_venc,
               setc_esta      = x.setc_esta,
               setc_punt_expe = x.setc_punt_expe,
               setc_fech_inic = x.setc_fech_inic
         where setc_secu_codi = p_SETC_SECU_CODI
           and setc_tico_codi = x.setc_tico_codi_1
           and setc_fech_venc = x.setc_fech_venc_1
           and setc_esta = x.setc_esta_1
           and setc_punt_expe = x.setc_punt_expe_1;
      
      elsif x.accion = 'E' then
        delete come_secu_tipo_comp
         where setc_secu_codi = p_SETC_SECU_CODI
           and setc_tico_codi = x.setc_tico_codi_1
           and setc_fech_venc = x.setc_fech_venc_1
           and setc_esta = x.setc_esta_1
           and setc_punt_expe = x.setc_punt_expe_1;
      
      end if;
    
    end loop;
  
  end pp_actualizar_timb;

end i010057;
