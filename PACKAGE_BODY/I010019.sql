
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010019" is

  -- Private type declarations
  type r_parameter is record(
      p_indi_cons varchar2(1),
      p_ulti_nume_prov number:= to_number(general_skn.fl_busca_parametro('p_ulti_nume_prov')),
      p_codi_base      number:= pack_repl.fa_devu_codi_base,
      p_indi_pasa_capi varchar2(1):=ltrim(rtrim(general_skn.fl_busca_parametro ('p_indi_pasa_capi'))),
      p_empr_codi      number := V('AI_EMPR_CODI'),
      collection_name1       varchar2(30):='COLL_BTIMB_MR',
      p_indi_permi_ruc_dupli varchar2(1):= ltrim(rtrim(general_skn.fl_busca_parametro('p_indi_permi_ruc_dupli')))
  );
  parameter r_parameter;
  
  type r_babmc is record(
     clpr_empr_codi number,
      empr_desc      varchar2(100),
      clpr_codi      number,
      clpr_codi_alte varchar2(20),
      clpr_tipo_pers varchar2(1),
      clpr_desc      varchar2(100),
      pais_codi_alte varchar2(10),
      clpr_pais_codi number,
      pais_desc      varchar2(100),
      clpr_tipo_docu varchar2(10), 
      clpr_ruc       varchar2(20), 
      clpr_tele      varchar2(50), 
      clpr_fax       varchar2(50), 
      clpr_dire      varchar2(100),
      clpr_pers_cont varchar2(60),
      clpr_obse      varchar2(200),
      clpr_email     varchar2(50), 
      clpr_indi_clie_prov varchar2(1),
      clpr_prov_clas1_codi number, 
      clpr_capr_codi       number, 
      clas1_codi_alte      number,
      capr_codi_alte       number,
      clas1_desc           varchar2(100),
      capr_desc            varchar2(100),
      clpr_limi_auto_fact_mens_mmnn number,
      clpr_cant_mes_stoc_idea       number,
      clpr_indi_chac                varchar2(1),
      clpr_indi_flet                varchar2(1),
      clpr_esta                     varchar2(1),
      clpr_mes_stoc_desd            number,
      clpr_mes_stoc_hast            number,
      clpr_prov_retener             varchar2(2),
      clpr_prov_despachante         varchar2(2),
      clpr_base                     number,
      clpr_user_regi                varchar2(20),
      clpr_fech_regi                date,
      clpr_user_modi                varchar2(20),
      clpr_fech_modi                date
     
  );
  babmc r_babmc;
  
  type r_btimb_mr is record (
     cptc_clpr_codi number, 
      cptc_tico_codi varchar2(10), 
      tico_codi_alte varchar2(10),
      tico_desc      varchar2(100),
      cptc_esta      number, 
      cptc_punt_expe number, 
      cptc_nume_timb varchar2(20), 
      cptc_fech_venc date
  );
  btimb_mr r_btimb_mr;
  
  
-----------------------------------------------
  procedure pp_genera_codi is
  begin
    babmc.clpr_codi := fa_sec_come_clie_prov;
  end pp_genera_codi;

-----------------------------------------------
  procedure pp_enviar_datos is
    
  begin
    SETITEM('P16_CLPR_TIPO_PERS',BABMC.CLPR_TIPO_PERS);
    SETITEM('P16_CLPR_DESC',BABMC.CLPR_DESC);
    SETITEM('P16_PAIS_CODI_ALTE',BABMC.CLPR_PAIS_CODI);
    SETITEM('P16_CLPR_TIPO_DOCU',BABMC.CLPR_TIPO_DOCU);
    SETITEM('P16_CLPR_RUC',BABMC.CLPR_RUC);
    SETITEM('P16_CLPR_TELE',BABMC.CLPR_TELE);
    SETITEM('P16_CLPR_FAX',BABMC.CLPR_FAX);
    SETITEM('P16_CLPR_DIRE',BABMC.CLPR_DIRE);
    SETITEM('P16_CLPR_PERS_CONT',BABMC.CLPR_PERS_CONT);
    SETITEM('P16_CLPR_OBSE',BABMC.CLPR_OBSE);
    SETITEM('P16_CLPR_EMAIL',BABMC.CLPR_EMAIL);
    SETITEM('P16_CLPR_PROV_CLAS1_CODI',BABMC.CLPR_PROV_CLAS1_CODI);
    SETITEM('P16_CLPR_LIMI_AUTO_FACT_MENS_MMNN',BABMC.CLPR_LIMI_AUTO_FACT_MENS_MMNN);
    SETITEM('P16_CLPR_USER_REGI',BABMC.CLPR_USER_REGI);
    SETITEM('P16_CLPR_FECH_REGI',to_char(BABMC.CLPR_FECH_REGI, 'DD/MM/YYYY HH24:MI:SS'));--BABMC.CLPR_FECH_REGI
    SETITEM('P16_CLPR_ESTA',BABMC.CLPR_ESTA);
    SETITEM('P16_CLPR_USER_MODI',BABMC.CLPR_USER_MODI);
    SETITEM('P16_CLPR_FECH_MODI',to_char(BABMC.CLPR_FECH_MODI, 'DD/MM/YYYY HH24:MI:SS'));--BABMC.CLPR_FECH_MODI
    SETITEM('P16_CLAS1_CODI_ALTE',BABMC.CLAS1_CODI_ALTE);
    SETITEM('P16_CAPR_CODI_ALTE',BABMC.CLPR_CAPR_CODI);
    --SETITEM('',);
    
    
/*    
    babmc.clas1_desc, 
*/    
  end pp_enviar_datos;
  
-----------------------------------------------
  procedure pl_muestra_come_empr (p_empr_codi in number, p_empr_desc out char) is
  begin	                      
    select empr_desc
    into   p_empr_desc
    from   come_empr
    where  empr_codi = p_empr_codi;  
  Exception
    when no_data_found then                       
       p_empr_desc := null;
       raise_application_error(-20010,'Empresa Inexistente!');
    when others then
       raise_application_error(-20010,'Error al buscar Empresa!');
  end pl_muestra_come_empr;

-----------------------------------------------
  procedure pp_muestra_prov_clas1 (p_clas1_codi in number, 
                                   p_clas1_desc out varchar2,
                                   p_clas1_codi_alte out varchar2) is
  begin           
    select clas1_desc, clas1_codi_alte
    into   p_clas1_desc, p_clas1_codi_alte
    from   come_prov_clas_1
    where  clas1_codi = p_clas1_codi;  
    
  Exception
    when no_data_found then
       p_clas1_desc := null;     
       p_clas1_codi_alte := null;
       raise_application_error(-20010,'Clasificacion del Proveedor Inexistente!');
    when others then
       raise_application_error(-20010,'Error al buscar Clasificacion del Proveedor!');
  end pp_muestra_prov_clas1;
  
-----------------------------------------------
  procedure pp_muestra_prov_cate  (p_codi in number, 
                                   p_desc out char,
                                   p_codi_alte out char) is
  begin           
    select capr_desc, capr_codi_alte
    into   p_desc, p_codi_alte
    from   come_prov_cate
    where  capr_codi = p_codi;  
    
  Exception
    when no_data_found then
       p_desc := null;     
       p_codi_alte := null;
       raise_application_error(-20010,'Categoria del Proveedor Inexistente!');
    when others then
       raise_application_error(-20010,'Error al buscar Categoria del Proveedor!');
  end pp_muestra_prov_cate;  
  
-----------------------------------------------
  procedure pp_muestra_pais (p_codi in number, p_desc out char, p_codi_alte out char) is
  begin	          
    select pais_desc, pais_codi_alte
    into   p_desc, p_codi_alte
    from   come_pais
    where  pais_codi = p_codi;  
    
  Exception
    when no_data_found then
       p_desc := null;     
       p_codi_alte := null;
       raise_application_error(-20010,'Pais Inexistente!');
    when others then
       raise_application_error(-20010,'Error al buscar Pais!');
  end pp_muestra_pais;
  
-----------------------------------------------
  procedure pp_ejecutar_consulta(i_clpr_codi in number) is
  
  begin

     select clpr_empr_codi,clpr_codi,clpr_codi_alte,clpr_tipo_pers,clpr_desc,clpr_pais_codi,clpr_tipo_docu,
            clpr_ruc,clpr_tele,clpr_fax,clpr_dire,clpr_pers_cont,clpr_obse,clpr_email,clpr_indi_clie_prov,
            clpr_prov_clas1_codi,clpr_capr_codi,clpr_limi_auto_fact_mens_mmnn,clpr_cant_mes_stoc_idea,clpr_indi_chac,clpr_indi_flet,clpr_esta,clpr_mes_stoc_desd,
            clpr_mes_stoc_hast,clpr_prov_retener,clpr_prov_despachante,clpr_base,clpr_user_regi,clpr_fech_regi,clpr_user_modi,clpr_fech_modi
      
      into  babmc.clpr_empr_codi,babmc.clpr_codi,babmc.clpr_codi_alte,babmc.clpr_tipo_pers,babmc.clpr_desc,babmc.clpr_pais_codi,babmc.clpr_tipo_docu,
            babmc.clpr_ruc,babmc.clpr_tele,babmc.clpr_fax,babmc.clpr_dire,babmc.clpr_pers_cont,babmc.clpr_obse,babmc.clpr_email,babmc.clpr_indi_clie_prov,
            babmc.clpr_prov_clas1_codi,babmc.clpr_capr_codi,babmc.clpr_limi_auto_fact_mens_mmnn,babmc.clpr_cant_mes_stoc_idea,babmc.clpr_indi_chac,babmc.clpr_indi_flet,
            babmc.clpr_esta,babmc.clpr_mes_stoc_desd,babmc.clpr_mes_stoc_hast,babmc.clpr_prov_retener,babmc.clpr_prov_despachante,babmc.clpr_base,babmc.clpr_user_regi,
            babmc.clpr_fech_regi,babmc.clpr_user_modi,babmc.clpr_fech_modi
      from come_clie_prov
      where  clpr_codi = i_clpr_codi
      and clpr_indi_clie_prov = 'P';
      
      parameter.p_indi_cons := 'S';
      
      ----------
      if babmc.clpr_empr_codi is not null then
        pl_muestra_come_empr(babmc.clpr_empr_codi, babmc.empr_desc);
      end if; 

      --raise_application_error(-20010,'babmc.clpr_prov_clas1_codi: '||babmc.clpr_prov_clas1_codi);
     
      if babmc.clpr_prov_clas1_codi is not null then
         pp_muestra_prov_clas1(babmc.clpr_prov_clas1_codi, babmc.clas1_desc, babmc.clas1_codi_alte);
      end if;

      if babmc.clpr_capr_codi is not null then
         pp_muestra_prov_cate (babmc.clpr_capr_codi, babmc.capr_desc, babmc.capr_codi_alte);
      end if;

      if babmc.clpr_pais_codi is not null then
         pp_muestra_pais(babmc.clpr_pais_codi, babmc.pais_desc, babmc.pais_codi_alte);
      end if;

      parameter.p_indi_cons := 'N';      
      
      pp_enviar_datos;
      pp_mostrar_imagen;

  Exception
    when others then
      --pl_mostrar_error_plsql;
      raise_application_error(-20010, 'Error al consultar! ' || sqlerrm);
  end pp_ejecutar_consulta;
  
-----------------------------------------------
  procedure pp_valida_codi_alte is
  v_count number;
  begin
    select count(*)
    into  v_count
    from come_clie_prov
    where clpr_codi_alte = babmc.clpr_codi_alte
    and clpr_indi_clie_prov = 'P';
    
  if v_count > 0 then
       raise_application_error(-20010,'Codigo de cliente Existente.. Favor cancele la operacion y vuelva a cargar los datos');
    end if;
    
  end pp_valida_codi_alte;
  
-----------------------------------------------
  procedure pp_actualizar_registro is
  begin
    
    if babmc.clpr_codi is null then
      pp_valida_codi_alte;
    end if;

    --go_block('babmc');
/*
    if (get_block_property('babmc', status)) = upper('changed') or 
      (get_block_property('btimb', status)) = upper('changed') then
      --commit_form;
      if not form_success then
        clear_block(no_validate);
        message('Registro no actualizado.');
      else
        message('Registro actualizado.');
        :global.g_clpr_codi_alte := :babmc.clpr_codi_alte;
        clear_block(no_validate);
      end if;
      if form_failure then
        raise form_trigger_failure;
      end if;
    end if;  
*/

  end pp_actualizar_registro;

-----------------------------------------------
  procedure pp_genera_codi_alte(clpr_codi_alte out number) is
    v_nume number;
  Begin

    v_nume := parameter.p_ulti_nume_prov;

    loop
      begin
        select clpr_codi_alte
          into v_nume
          from come_clie_prov
         where clpr_indi_clie_prov = 'P'
           and clpr_codi_alte = v_nume;
      
        v_nume := v_nume + 1;
      
      Exception
        when no_data_found then
          exit;
        when too_many_rows then
          v_nume := v_nume + 1;
      end;
    end loop;

    clpr_codi_alte := v_nume;
    --raise_application_error(-20010,'clpr_codi_alte: '||clpr_codi_alte);

  end pp_genera_codi_alte;

-----------------------------------------------
  procedure pp_validar_clie_prov(p_busc_dato           in varchar2,
                                 p_clpr_indi_clie_prov in varchar2) is
    salir  exception;
    v_cant number;
  begin
    select count(*)
      into v_cant
      from come_clie_prov cp
     where cp.clpr_indi_clie_prov = p_clpr_indi_clie_prov
       and cp.clpr_codi = p_busc_dato;

    if v_cant <= 0 then
      raise_application_error(-20010, 'Proveedor inexistente');
    end if;

  exception
    when salir then
      null;
    when others then
      --pl_me(sqlerrm);
      raise_application_error(-20010,'Error al validar Proveedor! ' || sqlerrm);
    
  end pp_validar_clie_prov;

-----------------------------------------------
  procedure pp_validar_codi(clpr_codi_alte in varchar2,
                            codi_alte out number,
                            cons_esta out varchar2) is 
    
  begin
    
   -- apex_application.g_printer_friendly_template:= 'Tipo de Comprobante Inexistente!';
    
    if clpr_codi_alte is null then
       pp_genera_codi_alte(codi_alte);
       cons_esta:= 'I';
    else
      pp_validar_clie_prov(clpr_codi_alte, 'P');
      codi_alte:=clpr_codi_alte;
      --pp_ejecutar_consulta(codi_alte);
      cons_esta:= 'U';
    end if;
    
    --pp_ejecutar_consulta;
    
  end pp_validar_codi;

-----------------------------------------------
  procedure pp_muestra_tipo_comp(p_codi      in number,
                                 p_desc      out varchar2,
                                 p_codi_alte out varchar2) is
  begin
    select tico_desc, tico_codi_alte
      into p_desc, p_codi_alte
      from come_tipo_comp
     where tico_codi = p_codi;

  Exception
    when no_data_found then
      p_desc      := null;
      p_codi_alte := null;
      raise_application_error(-20010,'Tipo de Comprobante Inexistente!');
    when others then
      raise_application_error(-20010,'Error al buscar Tipo de Comprobante! ' ||sqlerrm);
  end pp_muestra_tipo_comp;

-----------------------------------------------
  procedure pp_cargar_btimb_mr(i_clpr_codi in number) is
  
    cursor c_btimb_mr(v_clpr_codi in number) is 
     select cptc_clpr_codi,
           cptc_tico_codi,
           cptc_esta,
           cptc_punt_expe,
           cptc_nume_timb,
           cptc_fech_venc,
           cptc_user_regi,
           cptc_fech_regi
      from come_clpr_tipo_comp
     where cptc_clpr_codi = v_clpr_codi;
  
  begin
    
    for x in c_btimb_mr(i_clpr_codi) loop
      
      if x.cptc_tico_codi is not null then
        pp_muestra_tipo_comp(to_number(x.cptc_tico_codi), btimb_mr.tico_desc, btimb_mr.tico_codi_alte);
      end if;	
      
      apex_collection.add_member(p_collection_name => parameter.collection_name1,
                                 p_c001 => x.cptc_clpr_codi,
                                  p_c002 => x.cptc_tico_codi,
                                  p_c003 => x.cptc_esta,
                                  p_c004 => x.cptc_punt_expe,
                                  p_c005 => x.cptc_nume_timb,
                                  p_c006 => x.cptc_fech_venc,
                                  p_c007 => btimb_mr.tico_desc, 
                                  p_c008 => btimb_mr.tico_codi_alte,
                                  p_c009 => x.cptc_user_regi,
                                  p_c010 => TO_CHAR(x.cptc_fech_regi, 'DD/MM/YYYY HH24:MI:SS')
                               );   
      
    end loop;
    
  end;
  
-----------------------------------------------
  procedure pp_muestra_tipo_comp_alte(p_codi_alte in varchar2,
                                      --p_desc out char, 
                                      p_empr_codi in number,
                                      p_codi      out number) is
  begin
    select tico_codi --tico_desc, 
      into p_codi --p_desc, 
      from come_tipo_comp
     where rtrim(ltrim(tico_codi_alte)) = rtrim(ltrim(p_codi_alte))
       and tico_empr_codi = p_empr_codi;

  Exception
    when no_data_found then
      --p_desc := null;
      p_codi := null;
      raise_application_error(-20010, 'Tipo de Comprobante Inexistente!');
    when others then
      raise_application_error(-20010,'Error al buscar Tipo de Comprobante! ' ||sqlerrm);
  end pp_muestra_tipo_comp_alte;


-----------------------------------------------
  procedure pp_insert_timb(i_cptc_clpr_codi in number,
                           i_cptc_tico_codi in number,
                           i_cptc_nume_timb  in varchar2,
                           i_cptc_fech_venc in date,
                           i_cptc_esta      in number,
                           i_cptc_punt_expe in number) is            
   cant number;
  begin
  
    select count(*)
    into cant
     from come_clpr_tipo_comp
     where cptc_clpr_codi = i_cptc_clpr_codi
       and cptc_tico_codi = i_cptc_tico_codi
       and cptc_fech_venc = to_date(i_cptc_fech_venc, 'dd/mm/yyyy')
       and cptc_esta = i_cptc_esta
       and cptc_punt_expe = i_cptc_punt_expe
       and cptc_nume_timb = i_cptc_nume_timb;

    if cant >=1 then
      raise_application_error(-20010,'Error, el registro a ser insertado ya existe! ');
    else
      
      insert into come_clpr_tipo_comp
        (cptc_clpr_codi,
         cptc_tico_codi,
         cptc_nume_timb,
         cptc_fech_venc,
         cptc_base,
         cptc_esta,
         cptc_punt_expe)
      values
        (i_cptc_clpr_codi,
         i_cptc_tico_codi,
         i_cptc_nume_timb,
         i_cptc_fech_venc,
         parameter.p_codi_base,
         i_cptc_esta,
         i_cptc_punt_expe);
         
       commit;
       
       apex_application.g_print_success_message := 'Registro agregado correctamente!';
       
    end if;
  
  exception
    when others then
      raise_application_error(-20010,'Error al insertar Timbrado! ' || sqlerrm); 
  end;
  
-----------------------------------------------
  procedure pp_delete_timb(i_cptc_clpr_codi in number,
                           i_cptc_tico_codi in number,
                           i_cptc_nume_timb  in varchar2,
                           i_cptc_fech_venc in date,
                           i_cptc_esta      in number,
                           i_cptc_punt_expe in number) is
    cant number;
  begin
    
    select count(*)
    into cant
     from come_clpr_tipo_comp
     where cptc_clpr_codi = i_cptc_clpr_codi
       and cptc_tico_codi = i_cptc_tico_codi
       and cptc_fech_venc = to_date(i_cptc_fech_venc, 'dd/mm/yyyy')
       and cptc_esta = i_cptc_esta
       and cptc_punt_expe = i_cptc_punt_expe
       and cptc_nume_timb = i_cptc_nume_timb;

    if cant <=0 then
      raise_application_error(-20010,'Error, el registro a ser eliminado no existe! ');
    else
      delete come_clpr_tipo_comp
       where cptc_clpr_codi = i_cptc_clpr_codi
         and cptc_tico_codi = i_cptc_tico_codi
         and cptc_fech_venc = i_cptc_fech_venc
         and cptc_esta      = i_cptc_esta
         and cptc_punt_expe = i_cptc_punt_expe
         and cptc_nume_timb = i_cptc_nume_timb;
         
         commit;
         
         apex_application.g_print_success_message := 'Registro eliminado correctamente!';
         
     end if; 
      
  exception
    when others then
      raise_application_error(-20010,'Error al eliminar Timbrado! ' || sqlerrm);  
  end;
  
-----------------------------------------------
  procedure pp_update_timb(i_cptc_clpr_codi in number,
                           i_cptc_tico_codi in number,
                           i_cptc_nume_timb  in varchar2,
                           i_cptc_fech_venc in date,
                           i_cptc_esta      in number,
                           i_cptc_punt_expe in number,
                           i_cptc_user_regi in varchar2,
                           i_cptc_fech_regi in varchar2
                           ) is
   cant number;
                           
  begin
    
    select count(*)
    into cant
     from come_clpr_tipo_comp
     where  cptc_clpr_codi = i_cptc_clpr_codi
       and cptc_user_regi = i_cptc_user_regi
       and to_char(cptc_fech_regi, 'DD/MM/YYYY HH24:MI:SS') = i_cptc_fech_regi;

    if cant <=0 then
      raise_application_error(-20010,'Error, el registro a ser editado no existe! ');
    else
      
      update come_clpr_tipo_comp
       set cptc_clpr_codi = i_cptc_clpr_codi,
           cptc_tico_codi = i_cptc_tico_codi,
           cptc_nume_timb = i_cptc_nume_timb,
           cptc_fech_venc = i_cptc_fech_venc,
           cptc_esta = i_cptc_esta,
           cptc_punt_expe = i_cptc_punt_expe           
     where cptc_clpr_codi = i_cptc_clpr_codi
       and cptc_user_regi = i_cptc_user_regi
       and to_char(cptc_fech_regi, 'DD/MM/YYYY HH24:MI:SS') = i_cptc_fech_regi;
      commit;
      
      apex_application.g_print_success_message := 'Registro modificado correctamente!';
    end if;
    
  exception
    when others then
      raise_application_error(-20010,'Error al editar Timbrado! ' || sqlerrm);
      
  end;

-----------------------------------------------   
  procedure pp_validar_nulos(i_clpr_desc in varchar2,
                              i_pais_codi_alte in varchar2,
                              i_clpr_tipo_docu in varchar2,
                              i_clpr_ruc in varchar2,
                              i_clpr_tele in varchar2,
                              i_clpr_dire in varchar2,
                              i_clas1_codi_alte in number) is
    
  begin
    
    if i_clpr_desc is null then
       raise_application_error(-20010, 'Debe ingresar la Razon Social del proveedor');
    end if;	
    
    if i_pais_codi_alte is null then
       raise_application_error(-20010, 'Debe ingresar el codigo del Pais');
    end if;
    
    if i_clpr_tipo_docu is null then
      raise_application_error(-20010, 'Debe ingresar el Tipo de Documento!');
    end if;
    
    if i_clpr_ruc is null then
      raise_application_error(-20010, 'Debe ingresar el ruc del proveedor!');
    end if;
    
    if i_clpr_tele is null then
      raise_application_error(-20010, 'Debe ingresar el telefono del proveedor');
    end if;
    
    if i_clpr_dire is null then
      raise_application_error(-20010, 'Debe ingresar la direccion del proveedor');
    end if;
    
    if i_clas1_codi_alte is null then
       raise_application_error(-20010, 'Debe ingresar la clasificacion del Proveedor');
    end if;
    
  end;
  
-----------------------------------------------
  procedure pp_actu_secu is
  begin
  	
    update come_para set  para_valo = babmc.clpr_codi_alte
    where upper(ltrim(rtrim(para_nomb))) = upper('p_ulti_nume_prov');
    
    Exception
      when others then
        raise_application_error(-20010, 'Error al actualizar la secuencia! '||sqlerrm);
    
  end pp_actu_secu;
  
-----------------------------------------------
  procedure pp_insert_prov is
    
    cant number;
  begin
    pp_genera_codi_alte( babmc.clpr_codi_alte);
   -- babmc.clpr_codi_alte           := V('P16_CLPR_CODI_ALTE');
    babmc.clpr_desc                := V('P16_CLPR_DESC');
    babmc.pais_codi_alte           := V('P16_PAIS_CODI_ALTE');
    babmc.clpr_tipo_docu           := V('P16_CLPR_TIPO_DOCU');
    babmc.clpr_ruc                 := V('P16_CLPR_RUC');
    babmc.clpr_tele                := V('P16_CLPR_TELE');
    babmc.clpr_dire                := V('P16_CLPR_DIRE');
    babmc.clpr_empr_codi           := V('AI_EMPR_CODI');
    babmc.clas1_codi_alte          := V('P16_CLAS1_CODI_ALTE');
    babmc.clpr_pers_cont           := V('P16_CLPR_PERS_CONT');
    babmc.clpr_fax                 := V('P16_CLPR_FAX');
    babmc.clpr_obse                := V('P16_CLPR_OBSE');
    babmc.clpr_email               := V('P16_CLPR_EMAIL');
    babmc.capr_codi_alte           := V('P16_CAPR_CODI_ALTE');
    babmc.clpr_limi_auto_fact_mens_mmnn := V('P16_CLPR_LIMI_AUTO_FACT_MENS_MMNN');
    babmc.clpr_esta                     := V('P16_CLPR_ESTA');
    babmc.clpr_tipo_pers                := V('P16_CLPR_TIPO_PERS');
    
                         
    if babmc.clpr_codi_alte is null then
      raise_application_error(-20010, 'El Codigo no puede estar vacio!');
    end if;
    
    select count(*)
    into cant
    from come_clie_prov c
    where c.clpr_indi_clie_prov='P'
    and c.clpr_codi_alte = babmc.clpr_codi_alte;
    
    if cant >= 1 then
      raise_application_error(-20010, 'Ya existe un registro con este codigo!');
    else
         
      pp_validar_nulos(babmc.clpr_desc,babmc.pais_codi_alte,babmc.clpr_tipo_docu,babmc.clpr_ruc,
                        babmc.clpr_tele,babmc.clpr_dire,babmc.clas1_codi_alte);
                        
      pp_valida_ruc(babmc.clpr_ruc,
                    babmc.clpr_codi_alte,
                    babmc.clpr_tipo_docu,
                    babmc.pais_codi_alte
                    );      

      babmc.clpr_indi_chac:='N';
      babmc.clpr_indi_clie_prov := 'P';
      babmc.clpr_base := parameter.p_codi_base;
      --babmc.clpr_user_regi := gen_user;
      --babmc.clpr_fech_regi := sysdate;

      pp_genera_codi;
      --pp_genera_codi_alte;
      
      if parameter.p_indi_pasa_capi = 'S' then
       babmc.clpr_desc      := fa_pasa_capital(babmc.clpr_desc);
       babmc.clpr_pers_cont := fa_pasa_capital(babmc.clpr_pers_cont);
      elsif parameter.p_indi_pasa_capi = 'M' then
       babmc.clpr_desc      := upper(babmc.clpr_desc);
       babmc.clpr_pers_cont := upper(babmc.clpr_pers_cont);
      end if;
      
      insert into come_clie_prov
        (clpr_codi,
         clpr_codi_alte,
         clpr_tipo_pers,
         clpr_desc,
         clpr_pais_codi,
         clpr_tipo_docu,
         clpr_ruc,
         clpr_tele,
         clpr_fax,
         clpr_dire,
         clpr_empr,
         clpr_pers_cont,
         clpr_obse,
         clpr_email,
         clpr_indi_clie_prov,
         clpr_prov_clas1_codi,
         clpr_capr_codi,
         clpr_limi_auto_fact_mens_mmnn,
         clpr_indi_chac,
         clpr_esta,
         clpr_base)
      values
        (babmc.clpr_codi,
         babmc.clpr_codi_alte,
         babmc.clpr_tipo_pers,
         babmc.clpr_desc,
         babmc.pais_codi_alte,
         babmc.clpr_tipo_docu,
         babmc.clpr_ruc,
         babmc.clpr_tele,
         babmc.clpr_fax,
         babmc.clpr_dire,
         babmc.clpr_empr_codi,
         babmc.clpr_pers_cont,
         babmc.clpr_obse,
         babmc.clpr_email,
         babmc.clpr_indi_clie_prov,
         babmc.clas1_codi_alte,
         babmc.capr_codi_alte,
         babmc.clpr_limi_auto_fact_mens_mmnn,
         babmc.clpr_indi_chac,
         babmc.clpr_esta,
         babmc.clpr_base
         );       
       
       COMMIT;
       
       --ACTUALIZAR SECUENCIA
       pp_actu_secu;
       pp_actualizar_imagen;
       apex_application.g_print_success_message := 'Registro agregado correctamente!';
       
     
    
    end if;

  exception
    when others then
      raise_application_error(-20010, 'Error al insertar registro! '|| sqlerrm);
  end;
  
-----------------------------------------------
  procedure pp_update_prov is
    
    cant number;
    
  begin
  
    babmc.clpr_codi                := V('P16_CLPR_CODI_ALTE');
    babmc.clpr_desc                := V('P16_CLPR_DESC');
    babmc.pais_codi_alte           := V('P16_PAIS_CODI_ALTE');
    babmc.clpr_tipo_docu           := V('P16_CLPR_TIPO_DOCU');
    babmc.clpr_ruc                 := V('P16_CLPR_RUC');
    babmc.clpr_tele                := V('P16_CLPR_TELE');
    babmc.clpr_dire                := V('P16_CLPR_DIRE');
    babmc.clpr_empr_codi           := V('AI_EMPR_CODI');
    babmc.clas1_codi_alte          := V('P16_CLAS1_CODI_ALTE');
    babmc.clpr_pers_cont           := V('P16_CLPR_PERS_CONT');
    babmc.clpr_fax                 := V('P16_CLPR_FAX');
    babmc.clpr_obse                := V('P16_CLPR_OBSE');
    babmc.clpr_email               := V('P16_CLPR_EMAIL');
    babmc.capr_codi_alte           := V('P16_CAPR_CODI_ALTE');
    babmc.clpr_limi_auto_fact_mens_mmnn := V('P16_CLPR_LIMI_AUTO_FACT_MENS_MMNN');
    babmc.clpr_esta                     := V('P16_CLPR_ESTA');
    babmc.clpr_tipo_pers                := V('P16_CLPR_TIPO_PERS');

    select count(*)
    into cant
    from come_clie_prov
    where clpr_codi = babmc.clpr_codi
     and clpr_indi_clie_prov = 'P';
     
    if cant <= 0 then
      raise_application_error(-20010, 'Error, registro inexistente! ');
    else
       
                    
      babmc.clpr_base := parameter.p_codi_base;
      --:babmc.clpr_user_modi := gen_user;
      --:babmc.clpr_fech_modi :=sysdate;
      if parameter.p_indi_pasa_capi = 'S' then
       babmc.clpr_desc      := fa_pasa_capital(babmc.clpr_desc);
       babmc.clpr_pers_cont := fa_pasa_capital(babmc.clpr_pers_cont);
      elsif parameter.p_indi_pasa_capi = 'M' then
       babmc.clpr_desc      := upper(babmc.clpr_desc);
       babmc.clpr_pers_cont := upper(babmc.clpr_pers_cont);
      end if;
      
      update come_clie_prov
       set clpr_tipo_pers = babmc.clpr_tipo_pers,
           clpr_desc = babmc.clpr_desc,
           clpr_pais_codi = babmc.pais_codi_alte,
           clpr_tipo_docu = babmc.clpr_tipo_docu,
           clpr_ruc = babmc.clpr_ruc,
           clpr_tele = babmc.clpr_tele,
           clpr_fax = babmc.clpr_fax,
           clpr_dire = babmc.clpr_dire,
           clpr_pers_cont = babmc.clpr_pers_cont,
           clpr_obse = babmc.clpr_obse,
           clpr_email = babmc.clpr_email,
           clpr_prov_clas1_codi = babmc.clas1_codi_alte,
           clpr_capr_codi = babmc.capr_codi_alte,
           clpr_limi_auto_fact_mens_mmnn = babmc.clpr_limi_auto_fact_mens_mmnn,
           clpr_esta = babmc.clpr_esta,
           clpr_base = babmc.clpr_base
     where clpr_codi = babmc.clpr_codi
       and clpr_indi_clie_prov = 'P';
     
     commit;
     pp_actualizar_imagen;
      apex_application.g_print_success_message :='Registro modificado correctamente!';
      
    end if;
 
  exception
    when others then
      raise_application_error(-20010, 'Error al editar registro! '|| sqlerrm);
      
  end;

-----------------------------------------------
  procedure pp_valida_ruc(p_clpr_ruc       in char,
                          p_clpr_codi      in number,
                          p_clpr_tipo_docu in varchar2,
                          p_clpr_pais_codi in number) is
    v_count number;
    v_ruc   number;
    v_dv    number;
    v_dv2   number;
    v_nro   varchar2(20);
  begin
    begin
      select count(*)
        into v_count
        from come_clie_prov
       where clpr_ruc = p_clpr_ruc
         and (p_clpr_codi is null or p_clpr_codi <> clpr_codi)
         and clpr_indi_clie_prov = 'P';
    
      if v_count > 0 and nvl(p_clpr_ruc, '-1') <> '44444401-7' then
        if nvl(p_clpr_ruc, '-1') <> '99999901-0' then
          if parameter.p_indi_permi_ruc_dupli = 'N' then
            raise_application_error(-20010,
                                    'Atencion!!! El numero de ' ||
                                    nvl(p_clpr_tipo_docu, 'R.U.C.') ||
                                    ' ingresado se encuentra asignado a otro Proveedor');
          else
            raise_application_error(-20010,
                                    'Atencion!!! El numero de ' ||
                                    nvl(p_clpr_tipo_docu, 'R.U.C.') ||
                                    ' ingresado se encuentra asignado a otro Proveedor');
          end if;
        elsif p_clpr_pais_codi = 1 then
          if parameter.p_indi_permi_ruc_dupli = 'N' then
            raise_application_error(-20010,
                                    'Atencion!!! El numero de ' ||
                                    nvl(p_clpr_tipo_docu, 'R.U.C.') ||
                                    ' ingresado pertenese a Proveedores del Exterior');
          else
            raise_application_error(-20010,
                                    'Atencion!!! El numero de ' ||
                                    nvl(p_clpr_tipo_docu, 'R.U.C.') ||
                                    ' ingresado pertenese a Proveedores del Exterior');
          end if;
        end if;
      end if;
    
    exception
      when no_data_found then
        null;
      when others then
        raise_application_error(-20010, 'Error, al validar RUC! ' || sqlerrm);
    end;

    if upper(p_clpr_tipo_docu) = upper('ruc') then
    
      begin
        v_nro := substr(rtrim(ltrim(p_clpr_ruc)),
                        1,
                        length(rtrim(ltrim(p_clpr_ruc))) - 2);
        v_ruc := to_number(v_nro);
      
        begin
          if p_clpr_ruc is not null then
            v_ruc := substr(rtrim(ltrim(p_clpr_ruc)),
                            1,
                            length(rtrim(ltrim(p_clpr_ruc))) - 2);
            v_dv  := substr(rtrim(ltrim(p_clpr_ruc)),
                            length(rtrim(ltrim(p_clpr_ruc))),
                            1);
          
            v_dv2 := Pa_Calcular_Dv_11_A(v_ruc);
          
            if v_dv <> v_dv2 then
              raise_application_error(-20010,'Atencion!!!! Digito verificador incorrecto, debe ser ' ||to_char(v_dv2) || '!');
            end if;
          end if;
        
        exception
          when others then
            raise_application_error(-20010,'Error al validar el RUC, Favor verifique!!!');
        end;
      
      exception
        when others then
          -- el ruc tiene algun digito alfanumerico
          null; --pl_me(sqlerrm);
          raise_application_error(-20010,'Atencion! Ruc con digito alfanumerico, verifique el RUC si esta correcto!.');
        
      end;
    elsif upper(p_clpr_tipo_docu) = upper('ci') then
      begin
        select to_number(rtrim(ltrim(p_clpr_ruc))) into v_ruc from dual;
      exception
        when invalid_number then
          raise_application_error(-20010,'Para Tipo de Documento C.I. debe ingresar solo numeros');
        when others then
          raise_application_error(-20010,'Error, al validar RUC! ' || sqlerrm);
      end;
    end if;
    
  end pp_valida_ruc;

-----------------------------------------------
  procedure pp_validar_borrado(i_clpr_codi in number) is
    v_count number(6);
  begin
    select count(*)
      into v_count
      from come_prod
     where prod_clpr_codi = i_clpr_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'productos asignados a este proveedor. primero debe borrarlos o asignarlos a otro');
    end if;

    v_count := 0;
    select count(*)
      into v_count
      from come_movi
     where movi_clpr_codi = i_clpr_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'movimientos asignados a este proveedor. primero debe borrarlos o asignarlos a otro');
    end if;

    v_count := 0;
    select count(*)
      into v_count
      from come_movi_anul
     where anul_clpr_codi = i_clpr_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'movimientos anulados asignados a este proveedor. primero debe borrarlos o asignarlos a otro');
    end if;

    v_count := 0;
    select count(*)
      into v_count
      from prod_tick
     where tick_clpr_codi = i_clpr_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Tickets asignados a este proveedor. primero debe borrarlos o asignarlos a otro');
    end if;

    v_count := 0;
    select count(*)
      into v_count
      from come_bien
     where bien_clpr_codi = i_clpr_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Bienes (Activo Fijo) asignados a este proveedor. primero debe borrarlos o asignarlos a otro');
    end if;

    v_count := 0;
    select count(*)
      into v_count
      from chac_cont
     where cont_clpr_codi = i_clpr_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Contratos (Chacra) asignados a este proveedor. primero debe borrarlos o asignarlos a otro');
    end if;

    v_count := 0;
    select count(*)
      into v_count
      from come_impo_fact
     where imfa_clpr_codi = i_clpr_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'Facturas  (Importaciones) asignados a este proveedor. primero debe borrarlos o asignarlos a otro');
    end if;

    v_count := 0;
    select count(*)
      into v_count
      from come_cheq
     where cheq_clpr_codi = i_clpr_codi;

    if v_count > 0 then
      raise_application_error(-20010,
                              'Existen' || '  ' || v_count || ' ' ||
                              'cheques emitidos  asignados a este proveedor. primero debe borrarlos o asignarlos a otro');
    end if;

  Exception
    when others then
      raise_application_error(-20010,
                              'Error al validar borrado! ' || sqlerrm);
    
  end pp_validar_borrado;

-----------------------------------------------
  procedure pp_borrar_registro(i_clpr_codi in number) is
    
    cant number;

  begin
    

    if i_clpr_codi is null then
      raise_application_error(-20010, 'Error, no se ha seleccionado ningun registro! ');
    end if;
    
    select count(*)
    into cant
    from come_clie_prov
    where clpr_codi = i_clpr_codi
     and clpr_indi_clie_prov = 'P';
     
    if cant <= 0 then
      raise_application_error(-20010, 'Error, registro inexistente! ');
    else
      
      pp_validar_borrado(i_clpr_codi);
      
      delete come_clie_prov
        where clpr_codi = i_clpr_codi
        and clpr_indi_clie_prov = 'P';
      
      commit;
      
      apex_application.g_print_success_message :='Registro eliminado correctamente!';
      
    end if;
    
  exception
    when others then
      raise_application_error(-20010,'Error al eliminar registro! ' || sqlerrm);
    
  end pp_borrar_registro;
-----------------------------------------------

procedure pp_mostrar_imagen
  is
 cursor datos is
 select PRRF_CLPR_CODI,
       PRRF_NUME_ITEM,
       PRRF_FILE,
       PRRF_DESC,
       PRRF_IMAGE
      -- dbms_lob.getlength(PRRF_IMAGE) img,
      -- rowid
  from COME_PROV_REGI_FIRM
where PRRF_CLPR_CODI= babmc.clpr_codi;
  begin
    
      apex_collection.create_or_truncate_collection(p_collection_name => 'COLL_IMAGEN');
      for i in  datos loop
            apex_collection.add_member(p_collection_name => 'COLL_IMAGEN', 
                               p_n001 => i.PRRF_NUME_ITEM, 
                               p_c002 => i.PRRF_FILE,
                               p_c003=> i.PRRF_DESC,
                               p_c004=> i.PRRF_CLPR_CODI,
                               p_blob001 => i.PRRF_IMAGE
                               );
        end loop;
    end;


---------------
  procedure pp_cargar_item_img (p_img in varchar2,
                                p_nume_item in number,
                                p_seq_id in number) is
    v_cant number;
    v_nume_item number;
    v_archivo blob;
    v_filename varchar2(500);
  begin
     
     if not apex_collection.collection_exists('COLL_IMAGEN') then
       apex_collection.create_collection('COLL_IMAGEN');
     end if;
   
    
   begin
      select blob_content, filename --, mime_type
        into v_archivo , v_filename--,v_mime_type
        from apex_application_temp_files a
       where a.name = p_img
         and rownum = 1;
    exception
      when others then
        null;
    end;
    if p_nume_item is null then
    apex_collection.add_member(p_collection_name => 'COLL_IMAGEN', 
                               p_c001 => p_nume_item, 
                               p_c002 => v_filename,
                               p_blob001 => v_archivo
                             ); 
                            
    else
                             
          apex_collection.update_member(p_collection_name => 'COLL_IMAGEN',
                                  p_seq             => p_seq_id,
                                  p_c001            => p_nume_item,
                                  p_c002            => v_filename,
                                  p_blob001         => v_archivo
                                  );
                             
                             
    end if;                         
  
     
  end pp_cargar_item_img;
---------------


  procedure pp_actualizar_imagen is
    cursor dato is 
    select 
       c001 PRRF_NUME_ITEM,
       c002 PRRF_FILE,
       c003 PRRF_DESC,
       c004 PRRF_CLPR_CODI,
       blob001 PRRF_IMAGE,
       dbms_lob.getlength(blob001)  img
       from apex_collections a
       where collection_name = 'COLL_IMAGEN';
  begin
  
  
 for i in  dato loop
 update come_prov_regi_firm
    set
        prrf_file = i.prrf_file,
        prrf_desc = i.prrf_desc,
        prrf_image =i.prrf_image 
  where prrf_clpr_codi = babmc.clpr_codi
  and  prrf_nume_item = i.prrf_nume_item;
 
       
       
  
    if sql%rowcount = 0 then
    
    insert into come_prov_regi_firm
      (prrf_clpr_codi, prrf_nume_item, prrf_file, prrf_desc, prrf_base, prrf_image)
    values
      (babmc.clpr_codi, (select nvl(max(prrf_nume_item), 0) + 1
            from come_prov_regi_firm
          where prrf_clpr_codi = babmc.clpr_codi), i.prrf_file,  i.prrf_desc, 1, i.prrf_image );
    
    
    end if;
    end loop;
  exception
    when others then
      raise_application_error(-20001, 'Error ' || sqlerrm);
    
  end ;

procedure pp_eliminar_imagen(p_clpr_codi in number,
                             p_prrf_nume_item in number,
                             p_seq_id in number)
  is 
  begin
    
  
  

    apex_collection.delete_member(p_collection_name => 'COLL_IMAGEN',
                                  p_seq             => p_seq_id);
    apex_collection.resequence_collection(p_collection_name => 'COLL_IMAGEN');
 
  
  
  delete come_prov_regi_firm
     where prrf_clpr_codi = p_clpr_codi
  and  prrf_nume_item = p_prrf_nume_item; 
    end pp_eliminar_imagen;
  
end I010019;
