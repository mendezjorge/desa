
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020271_A" is


  g_anex come_soli_serv_anex%rowtype;
  g_sose come_soli_serv%rowtype;
  g_vehi come_vehi%rowtype;
  g_mone come_mone%rowtype;
  g_deta come_soli_serv_anex_deta%rowtype;
  g_conc come_conc%rowtype;

  g_vehi_o come_vehi%rowtype;
  g_deta_o come_soli_serv_anex_deta%rowtype;

  e_sin_parametro exception;

  type r_parameter is record(
    p_empr_codi                number := 1,
    p_indi_nuev_regi           varchar2(2),
    p_indi_most_cicl_anex      varchar2(2),
   -- p_sose_codi_actu           number,
    p_conc_codi_anex_rein_vehi number,
    p_fech_inic                date,
    p_sose_codi_actu          number,
    p_prec_unit_anex_moni_vehi number := to_number(general_skn.fl_busca_parametro('p_prec_unit_anex_moni_vehi')),
    p_prec_unit_anex_grua_vehi number := to_number(general_skn.fl_busca_parametro('p_prec_unit_anex_grua_vehi')),
    p_conc_codi_anex_grua_vehi number := to_number(general_skn.fl_busca_parametro('p_conc_codi_anex_grua_vehi')),
    p_anex_prec_equi_como_dato number := to_number(general_skn.fl_busca_parametro('p_anex_prec_equi_como_dato')),
    p_anex_mone_equi_como_dato number := to_number(general_skn.fl_busca_parametro('p_anex_mone_equi_como_dato')),
    p_fech_fini                date,
    p_secu_sesi_user_comp      varchar2(100),
    p_codi_clas1_clie_subclie  number := to_number(general_skn.fl_busca_parametro('p_codi_clas1_clie_subclie')),
    p_peco_codi                number := 1,
    p_codi_base                number := pack_repl.fa_devu_codi_base,
    p_sucu_codi                number,
    deta_indi_borr             varchar2(2),
    indi_anex_inst             varchar2(2),
    p_codi_mone_mmnn           number := to_number(general_skn.fl_busca_parametro('p_codi_mone_mmnn'))
    
    ----------
  --  p_empr_codi               number := 1,
    
  );

  parameter r_parameter;

  cursor g_cur_col_det is
    select seq_id numero_item,
           c002   conc_codi_alte,
           c003   conc_desc,
           c004   deta_prec_unit,
           c005   deta_impo_mone,
           c006   anex_nume,
           c007   sose_nume,
           c008   vehi_iden,
           c009   deta_roam_fech_inic_vige,
           c010   deta_roam_fech_fini_vige,
           c011   deta_vehi_indi_grua,
           c012   deta_anho,
           c013   tive_codi_alte,
           c014   mave_codi_alte,
           c015   vehi_marc,
           c016   deta_nume_pate,
           c017   deta_colo,
           c018   deta_iden,
           c019   deta_mode,
           c020   deta_nume_chas,
           c021   deta_esta,
           c022   vehi_desc,
           c023   deta_codi,
           c024   deta_nume_item,
           c025   vehi_deta_codi,
           c026   ind_borrar,
           c027   nro_next,
           c030   anex_codi,
           c031   extr_vehi_ciud,
           c032   extr_vehi_barr,
           c033   extr_vehi_dire,
           c034   extr_vehi_ubic,
           c035   extr_vehi_refe,
           c036   ind_prorrateo,
           c037   ind_chapa_prov,
           c038   extr_vehi_ciud_codi                    
      from apex_collections a
     where collection_name = 'ANEXO_CONC';


  g_come_soli_serv      come_soli_serv%rowtype;
  g_soli_serv_clie_dato come_soli_serv_clie_dato%rowtype;

  w_indi_oper            varchar2(2);
  g_clpr_clie_clas1_codi number;

  g_s_sose_estado       varchar2(2);
  g_sose_nume_padr      number;
  g_clpr_codi_alte_orig number;
  g_sucu_nume_item_orig number;
  g_clpr_codi_alte      number;
  g_sucu_nume_item      number;
  g_mepa_codi_alte      number;
  g_naci_codi_alte      number;
  g_zona_codi_alte      number;
  g_prof_codi_alte      number;
  g_ciud_codi_alte      number;
  g_clas1_codi_alte     number;
  g_barr_codi_alte      number;
  g_sose_indi_tipo_fact varchar2(2) := 'C';
  --g_sose_mepa_codi_desc      := v('P47_SOSE_MEPA_CODI_DESC');
  --g_sose_empl_desc           := v('P47_SOSE_EMPL_DESC');
  --g_clpr_codi_alte_desc      := v('P47_CLPR_CODI_ALTE_DESC');
  --g_clpr_codi_alte_orig_desc := v('P47_CLPR_CODI_ALTE_ORIG_DESC');


  cursor g_cur_ref is
    select a.seq_id borrar,
           a.seq_id seq,
           a.c001   nombre_apellido,
           a.c002   telefono_celular
      from apex_collections a
     where a.collection_name = 'SOL_REF';

  procedure pp_barrio_alte(i_barr_codi      in number,
                           o_barr_codi_alte out number) is
  begin
    if i_barr_codi is null then
      raise e_sin_parametro;
    end if;
    select barr_codi_alte
      into o_barr_codi_alte
      from come_barr
     where barr_codi = i_barr_codi;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_barrio_alte;

  procedure pp_come_medi_pago_alte(i_mepa_codi      in number,
                                   o_mepa_codi_alte out number) is
  begin
    if i_mepa_codi is null then
      raise e_sin_parametro;
    end if;
  
    select mepa_codi_alte
      into o_mepa_codi_alte
      from come_medi_pago
     where mepa_codi = i_mepa_codi;
  
  exception
  
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_come_medi_pago_alte;

  procedure pp_ciudad_alte(i_ciud_codi      in number,
                           o_ciud_codi_alte out number) is
  begin
  
    if i_ciud_codi is null then
      raise e_sin_parametro;
    end if;
  
    select ciud_codi_alte
      into o_ciud_codi_alte
      from come_ciud
     where ciud_codi = i_ciud_codi;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_ciudad_alte;

  procedure pp_cliente_alte(i_sose_clpr_codi in number,
                            o_clpr_codi_alte out number) is
  begin
    if i_sose_clpr_codi is null then
      raise e_sin_parametro;
    end if;
  
    select t.clpr_codi_alte
      into o_clpr_codi_alte
      from come_clie_prov t
     where clpr_codi = i_sose_clpr_codi
       and clpr_indi_clie_prov = 'C';
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_cliente_alte;

  procedure pp_nacionalidad_alte(i_naci_codi      in number,
                                 o_naci_codi_alte out number) is
  begin
  
    if i_naci_codi is null then
      raise e_sin_parametro;
    end if;
  
    select naci_codi_alte
      into o_naci_codi_alte
      from come_naci
     where naci_codi = i_naci_codi;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_nacionalidad_alte;

  procedure pp_zona_cli_alte(i_zona_codi      in number,
                             o_zona_codi_alte out number) is
  begin
  
    if i_zona_codi is null then
      raise e_sin_parametro;
    end if;
  
    select zona_codi_alte
      into o_zona_codi_alte
      from come_zona_clie
     where zona_codi = i_zona_codi;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_zona_cli_alte;

  procedure pp_profesion_alte(i_prof_codi      in number,
                              o_prof_codi_alte out number) is
  begin
    if i_prof_codi is null then
      raise e_sin_parametro;
    end if;
    select prof_codi_alte
      into o_prof_codi_alte
      from come_prof
     where prof_codi = i_prof_codi;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_profesion_alte;

  procedure pp_clie_clas1_alte(i_clas1_codi      in number,
                               o_clas1_codi_alte out number) is
  begin
    if i_clas1_codi is null then
      raise e_sin_parametro;
    end if;
  
    select clas1_codi_alte
      into o_clas1_codi_alte
      from come_clie_clas_1
     where clas1_codi = i_clas1_codi;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_clie_clas1_alte;

  procedure pp_barrio_codi(i_barr_codi_alte in number,
                           o_barr_codi      out number) is
  begin
    if i_barr_codi_alte is null then
      raise e_sin_parametro;
    end if;
    select barr_codi
      into o_barr_codi
      from come_barr
     where barr_codi_alte = i_barr_codi_alte;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_barrio_codi;

  procedure pp_cliente_codi(i_clpr_codi_alte in number,
                            o_sose_clpr_codi out number) is
  begin
    if i_clpr_codi_alte is null then
      raise e_sin_parametro;
    end if;
  
    select t.clpr_codi
      into o_sose_clpr_codi
      from come_clie_prov t
     where clpr_codi_alte = i_clpr_codi_alte
       and clpr_indi_clie_prov = 'C';
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_cliente_codi;

  procedure pp_come_medi_pago_codi(i_mepa_codi_alte in number,
                                   o_mepa_codi      out number) is
  begin
    if i_mepa_codi_alte is null then
      raise e_sin_parametro;
    end if;
  
    select mepa_codi
      into o_mepa_codi
      from come_medi_pago
     where mepa_codi_alte = i_mepa_codi_alte;
  
  exception
  
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_come_medi_pago_codi;

  procedure pp_nacionalidad_codi(i_naci_codi_alte in number,
                                 o_naci_codi      out number) is
  begin
  
    if i_naci_codi_alte is null then
      raise e_sin_parametro;
    end if;
  
    select naci_codi
      into o_naci_codi
      from come_naci
     where naci_codi_alte = i_naci_codi_alte;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_nacionalidad_codi;

  procedure pp_ciudad_codi(i_ciud_codi_alte in number,
                           o_ciud_codi      out char) is
  begin
  
    if i_ciud_codi_alte is null then
      raise e_sin_parametro;
    end if;
  
    select ciud_codi
      into o_ciud_codi
      from come_ciud
     where ciud_codi_alte = i_ciud_codi_alte;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_ciudad_codi;

  procedure pp_zona_cli_codi(i_zona_codi_alte in number,
                             o_zona_codi      out number) is
  begin
  
    if i_zona_codi_alte is null then
      raise e_sin_parametro;
    end if;
  
    select zona_codi
      into o_zona_codi
      from come_zona_clie
     where zona_codi_alte = i_zona_codi_alte;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_zona_cli_codi;

  procedure pp_profesion_codi(i_prof_codi_alte in number,
                              o_prof_codi      out number) is
  begin
    if i_prof_codi_alte is null then
      raise e_sin_parametro;
    end if;
    select prof_codi
      into o_prof_codi
      from come_prof
     where prof_codi_alte = i_prof_codi_alte;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_profesion_codi;

  procedure pp_clie_clas1_codi(i_clas1_codi_alte in number,
                               o_clas1_codi      out number) is
  begin
    if i_clas1_codi_alte is null then
      raise e_sin_parametro;
    end if;
  
    select clas1_codi
      into o_clas1_codi
      from come_clie_clas_1
     where clas1_codi_alte = i_clas1_codi_alte;
  
  exception
    when e_sin_parametro then
      null;
    when no_data_found then
      null;
  end pp_clie_clas1_codi;

  procedure pp_veri_nume(io_nume in out number) is
    v_nume number;
  begin
    v_nume := io_nume;
    loop
      begin
        select sose_nume
          into v_nume
          from come_soli_serv
         where sose_nume = v_nume;
      
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          exit;
        when too_many_rows then
          v_nume := v_nume + 1;
      end;
    end loop;
    io_nume := v_nume;
  end pp_veri_nume;

  procedure pp_carga_secu(o_secu_movi_nume out number) is
  begin
    select nvl(secu_come_sose_nume, 0) + 1
      into o_secu_movi_nume
      from come_secu
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  
  exception
    when no_data_found then
      raise_application_error(-20010,
                              'Codigo de Secuencia de Prestamo inexistente');
  end pp_carga_secu;

  procedure pp_busca_docu_duplicado(i_nume_docu      in varchar2,
                                    i_clpr_codi      in number,
                                    o_clpr_codi_alte out number) as
    v_codi_alte number;
  begin
  
    if nvl(i_nume_docu, '-1') <> '44444401-7' then
      null;
    end if;
  
    select max(p.clpr_codi_alte) a
      into v_codi_alte
      from come_clie_prov p
     where clpr_ruc = i_nume_docu
       and (i_clpr_codi is null or i_clpr_codi <> clpr_codi)
       and clpr_indi_clie_prov = 'C';
  
    if v_codi_alte is not null then
      o_clpr_codi_alte := v_codi_alte;
    end if;
  exception
    when no_data_found then
      null;
  end pp_busca_docu_duplicado;

  procedure pp_valida_ruc(i_nume_docu in varchar2,
                          i_tipo_docu in varchar2,
                          i_clpr_codi in number) is
    v_count number;
    v_ruc   number;
    v_dv    number;
    v_dv2   number;
    v_nro   varchar2(20);
    e_dig_inco  exception;
    e_vali_ruc  exception;
    e_digi_alfa exception;
  begin
    begin
      select count(*)
        into v_count
        from come_clie_prov
       where clpr_ruc = i_nume_docu
         and (i_clpr_codi is null or i_clpr_codi <> clpr_codi)
         and clpr_indi_clie_prov = 'C';
    
    if v_count > 0 and nvl(i_nume_docu, '-1') <> '44444401-7' then
       null;
       
       
          end if;
    
    exception
      when no_data_found then
        null;
      when others then
        raise_application_error(-20010, sqlerrm);
    end;
  
    if upper(i_tipo_docu) = upper('ruc') then
      begin
        v_nro := substr(rtrim(ltrim(i_nume_docu)),
                        1,
                        length(rtrim(ltrim(i_nume_docu))) - 2);
        v_ruc := to_number(v_nro);
      
        begin
          if i_nume_docu is not null then
            v_ruc := substr(rtrim(ltrim(i_nume_docu)),
                            1,
                            length(rtrim(ltrim(i_nume_docu))) - 2);
            v_dv  := substr(rtrim(ltrim(i_nume_docu)),
                            length(rtrim(ltrim(i_nume_docu))),
                            1);
            v_dv2 := pa_calcular_dv_11_a(v_ruc);
          
            if v_dv <> v_dv2 then
              raise e_dig_inco;
              --            raise_application_error(-20010,'Atencion!!!! Digito verificador incorrecto!!');
            end if;
          end if;
        
        exception
          when others then
            --raise_application_error(-20010,'Error al validar el RUC, Favor verifique!!!');
            raise e_vali_ruc;
        end;
      exception
        when others then
          -- el ruc tiene algun digito alfanumerico
          null; --raise_application_error(-20010,sqlerrm);
          --raise_application_error(-20010,'Atencion! Ruc con digito alfanumerico, verifique el RUC si esta correcto!.');
          raise e_digi_alfa;
      end;
    
    elsif upper(i_tipo_docu) = upper('ci') then
      begin
        select to_number(rtrim(ltrim(i_nume_docu))) into v_ruc from dual;
      exception
        when invalid_number then
          raise_application_error(-20010,
                                  'Para Tipo de Documento C.I. debe ingresar solo numeros');
        when others then
          raise_application_error(-20010, sqlerrm);
      end;
    
    end if;
  exception
    when e_dig_inco then
      raise_application_error(-20010,
                              'Atencion!!!! Digito verificador incorrecto!!');
    when e_vali_ruc then
      raise_application_error(-20010,
                              'Error al validar el RUC, Favor verifique!!!');
    when e_digi_alfa then
      raise_application_error(-20010,
                              'Atencion! Ruc con digito alfanumerico, verifique el RUC si esta correcto!.');
  end pp_valida_ruc;

  procedure pp_veri_cont_pend(i_sose_clpr_codi in number,
                              i_sucu_nume_item in number,
                              i_sose_codi      in number) is
  
    v_cant number;
  
  begin
  
    select count(*)
      into v_cant
      from come_soli_serv s
     where s.sose_clpr_codi = i_sose_clpr_codi
          --and (i_sucu_nume_item is null or (i_sucu_nume_item is not null and s.sose_sucu_nume_item = i_sucu_nume_item))
       and s.sose_sucu_nume_item = i_sucu_nume_item
       and s.sose_codi <> nvl(i_sose_codi, -9999)
       and s.sose_codi not in
           (select anex_sose_codi from come_soli_serv_anex a);
  
    if v_cant > 0 then
      select max(sose_nume)
        into g_come_soli_serv.sose_nume
        from come_soli_serv s
       where s.sose_clpr_codi = i_sose_clpr_codi
            --and (i_sucu_nume_item is null or (i_sucu_nume_item is not null and s.sose_sucu_nume_item = i_sucu_nume_item))
         and s.sose_sucu_nume_item = i_sucu_nume_item
         and s.sose_codi <> nvl(i_sose_codi, -9999)
         and s.sose_codi not in
             (select anex_sose_codi from come_soli_serv_anex a);
    
      raise_application_error(-20010,
                              'El cliente ya posee una Solicitud Nro ' ||
                              g_come_soli_serv.sose_nume ||
                              ' sin anexos asignados.');
    end if;
  
  end pp_veri_cont_pend;

  procedure pp_validar_refe_pers is
    v_cant_cont number := 0;
  begin
    for c in g_cur_ref loop
      if ltrim(rtrim(c.nombre_apellido)) is not null then
        v_cant_cont := nvl(v_cant_cont, 0) + 1;
      end if;
    end loop;
/*    if v_cant_cont < 1 then
      raise_application_error(-20010,
                              'Debe asignar al menos 2 Referencias Personaless.');
    end if;*/
  end pp_validar_refe_pers;

  procedure pp_validaciones is
  
  begin
    -- :parameter.p_validar_campo := 'S';
  
    --verificar si ya tiene solicitud el cliente, sin generar sus anexos
    pp_veri_cont_pend(i_sose_clpr_codi => g_come_soli_serv.sose_clpr_codi,
                      i_sucu_nume_item => g_come_soli_serv.sose_sucu_nume_item,
                      i_sose_codi      => g_come_soli_serv.sose_codi);
  
    --verificar si el cliente, tiene vehiculos pendientes de reinstalacion
    --pp_veri_soli_desi_rein(i_sose_clpr_codi, i_s_sucu_nume_item);
  
    ---validar cantidad de personas habilitadas,minimo 1 debe ingresar
    --  pp_validar_pers_habi;
    ---validar cantidad de personas a contactar,minimo 3 debe ingresar
    --  pp_validar_pers_cont;
    ---validar cantidad de referencias personales,minimo 2 debe ingresar
    pp_validar_refe_pers;
  
    --if i_empl_codi_alte is null then
    if g_anex.anex_empl_codi is null then
      if w_indi_oper = 'I' then
        raise_application_error(-20010, 'Debe ingresar el vendedor!');
      end if;
    end if;
  
    if w_indi_oper = 'I' then
      if g_clas1_codi_alte is null then
        raise_application_error(-20010,
                                'Debe Ingresar la Clasificacion del Cliente.');
      end if;
    end if;
  
    if w_indi_oper = 'U' then
      if g_come_soli_serv.sose_clpr_codi is null then
        raise_application_error(-20010, 'Debe Ingresar un Cliente.');
      end if;
    end if;
  
    if g_anex.anex_empl_codi is null then
      raise_application_error(-20010, 'Debe Ingresar el Vendedor.');
    end if;
  
    if g_come_soli_serv.sose_mone_codi is null then
      raise_application_error(-20010,
                              'Debe Ingresar la moneda de la Solicitud.');
    end if;
  
    if g_anex.anex_empl_codi is null then
      raise_application_error(-20010, 'Debe Ingresar el Vendedor.');
    end if;
  
    /*if i_clpr_clie_clas1_codi = :parameter.p_codi_clas1_clie_subclie then
      if nvl(i_clpr_indi_excl_vali_sose_poli, 'N') = 'N' then
        if i_sose_nume_poli is null then
          raise_application_error(-20010,
                                  'Debe ingresar Poliza de Seguro.');
        end if;
        if i_sose_nume_orde_serv is null then
          raise_application_error(-20010, 'Debe ingresar Orden de Seguro.');
        end if;
        if i_sose_fech_inic_poli is null then
          raise_application_error(-20010,
                                  'Debe ingresar fecha Inicio vigencia Poliza.');
        end if;
        if i_sose_fech_fini_poli is null then
          raise_application_error(-20010,
                                  'Debe ingresar fecha Fin vigencia Poliza.');
        end if;
      end if;
    end if;*/
  
    --
    if nvl(g_come_soli_serv.sose_esta, 'P') <> 'P' then
      raise_application_error(-20010,
                              'Solo se puede modificar si la solicitud esta en pendiente');
    end if;
  
    if g_soli_serv_clie_dato.sose_nomb is null then
      raise_application_error(-20010,
                              'Debe Ingresar el nombre del Cliente.');
    end if;
    if g_soli_serv_clie_dato.sose_apel is null then
      raise_application_error(-20010,
                              'Debe Ingresar el apellido del Cliente.');
    end if;
    if g_soli_serv_clie_dato.sose_docu is null then
      raise_application_error(-20010,
                              'Debe Ingresar el Nro. de Documento del Cliente!');
    end if;
    if g_soli_serv_clie_dato.sose_email is null then
    
      raise_application_error(-20010,
                              'Debe Ingresar el Email del Cliente!');
    end if;
    if g_soli_serv_clie_dato.sose_email_fact is null then
      raise_application_error(-20010,
                              'Debe Ingresar el Email de Facturacion del Cliente!');
    end if;
    if g_soli_serv_clie_dato.sose_mepa_codi is null then
      raise_application_error(-20010,
                              'Debe Ingresar el Medio de Pago del Cliente!');
    end if;
    if g_soli_serv_clie_dato.sose_ciud_codi is null then
      raise_application_error(-20010,
                              'Debe Ingresar la Ciudad del Cliente!');
    end if;
    if g_soli_serv_clie_dato.sose_dire is null then
    
      raise_application_error(-20010,
                              'Debe Ingresar la direccion del Cliente!');
    end if;
    if g_soli_serv_clie_dato.sose_tele_part is null then
      raise_application_error(-20010,
                              'Debe Ingresar numero telefonico del Cliente!');
    end if;
    if g_soli_serv_clie_dato.sose_sexo is null then
      raise_application_error(-20010, 'Debe seleccionar sexo del Cliente!');
    end if;
/*    if nvl(g_soli_serv_clie_dato.sose_tipo_pers, 'F') = 'J' then
      if g_soli_serv_clie_dato.sose_prop_nomb is null then
        raise_application_error(-20010,
                                'Debe Indicar el Nombre del Responsable.');
      end if;
      if g_soli_serv_clie_dato.sose_prop_docu is null then
        raise_application_error(-20010,
                                'Debe Indicar el Documento del Responsable.');
      end if;
      if g_soli_serv_clie_dato.sose_prop_carg is null then
        raise_application_error(-20010,
                                'Debe Indicar el Cargo del Responsable.');
      end if;
    end if;*/
  


------------------ticket 349
  /*  if g_soli_serv_clie_dato.sose_luga_trab is null then
      raise_application_error(-20010,
                              'Debe Ingresar el Lugar de Trabajo del Cliente!');
    end if;
    if g_soli_serv_clie_dato.sose_pues_trab is null then
      raise_application_error(-20010,
                              'Debe Ingresar el Puesto de Trabajo del Cliente!');
    end if;
    if g_soli_serv_clie_dato.sose_tele_trab is null then
      raise_application_error(-20010,
                              'Debe Ingresar el Telef. Laboral del Cliente!');
    end if;
    if g_soli_serv_clie_dato.sose_anti is null then
      raise_application_error(-20010,
                              'Debe Ingresar la Antiguedad del Cliente!');
    end if;
 */ 
  --  if g_soli_serv_clie_dato.sose_barr_codi is null then
  --    raise_application_error(-20010, 'Barrio es requerido');
  --  end if;
  
    pp_valida_ruc(g_soli_serv_clie_dato.sose_docu,
                  g_soli_serv_clie_dato.sose_tipo_docu,
                  g_come_soli_serv.sose_clpr_codi);
  end pp_validaciones;

  procedure pp_valida_borrado (p_solicitud in number,
                               p_cont    out number) is
    v_count number;
    v_nro number :=0;
  begin
  
    begin
      select count(*)
        into v_count
        from come_soli_serv_anex
       where anex_sose_codi = p_solicitud;--g_come_soli_serv.sose_codi;
    
      if v_count <> 0 then
        v_nro := v_nro+1;
        /*raise_application_error(-20010,
                                'La solicitud no puede ser eliminada. Existe(n) Anexo(s) relacionado(s) a este Contrato!');
 */     end if;
    end;
  
    begin
      select count(*)
        into v_count
        from come_soli_desi
       where sode_deta_codi in
             (select deta_codi
                from come_soli_serv_anex_deta, come_soli_serv_anex
               where anex_codi = deta_anex_codi
                 and anex_sose_codi = p_solicitud--g_come_soli_serv.sose_codi
                 );
      if v_count <> 0 then
         v_nro := v_nro+1;
       /* raise_application_error(-20010,
                                'La solicitud no puede ser eliminada. Existe(n) solicitud(es) de desinstalacion relacionada(s) a vehiculos del Contrato!');
 */     end if;
    end;
  
    begin
      select count(*)
        into v_count
        from come_orde_trab
       where ortr_deta_codi in
             (select deta_codi
                from come_soli_serv_anex_deta,
                     come_soli_serv_anex,
                     come_soli_serv
               where sose_codi = anex_sose_codi
                 and anex_codi = deta_anex_codi
                 and anex_sose_codi = p_solicitud--g_come_soli_serv.sose_codi
                 );
      --and sose_tipo not in ('N', 'T', 'R', 'RAS', 'S'));
      if v_count <> 0 then
         v_nro := v_nro+1;
      /*  raise_application_error(-20010,
                                'La solicitud no puede ser eliminada. Existe(n) Orden(es) de Trabajo relacionada(s) a vehiculos del Contrato!');
   */   end if;
    end;
  
    begin
      select count(*)
        into v_count
        from come_soli_serv_fact_deta sf
       where sf.sofa_indi_fact <> 'N'
         and sf.sofa_sose_codi =p_solicitud---- g_come_soli_serv.sose_codi
         ;
    
      if v_count <> 0 then
         v_nro := v_nro+1;
     /*   raise_application_error(-20010,
                                'La solicitud no puede ser eliminada,ya que posee cuotas facturadas');
    */  end if;
    end;
    p_cont := v_nro;
    
  end pp_valida_borrado;

  procedure pp_verificar_numero(i_numero_solicitud in out number) is
    v_nume number;
  begin
    v_nume := i_numero_solicitud;
    loop
      begin
        select sose_nume
          into v_nume
          from come_soli_serv
         where sose_nume = v_nume;
      
        v_nume := v_nume + 1;
      exception
        when no_data_found then
          exit;
        when too_many_rows then
          v_nume := v_nume + 1;
      end;
    end loop;
    i_numero_solicitud := v_nume;
  end pp_verificar_numero;

  procedure pp_add_referencia(i_ref_desc in varchar2,
                              i_ref_tel  in varchar2) as
    --v_count number;
  begin
    -- raise_application_error(-20010,'aca');
  
  
    apex_collection.add_member(p_collection_name => 'SOL_REF',
                               p_c001            => substr(i_ref_desc, 0, 90),
                               p_c002            => substr(i_ref_tel, 0, 60));
  
  end pp_add_referencia;

  procedure pp_genera_subcuenta(o_sucu_nume_item out number) is
  begin
    select nvl(max(sucu_nume_item), 0) + 1
      into o_sucu_nume_item
      from come_clpr_sub_cuen
     where sucu_clpr_codi = g_come_soli_serv.sose_clpr_codi;
  
    /*insert into come_clpr_sub_cuen
      (sucu_clpr_codi,
       sucu_nume_item,
       sucu_desc,
       sucu_dire,
       sucu_tele,
       sucu_base,
       sucu_nume_cedu,
       sucu_ruc,
       sucu_esta,
       sucu_user_regi,
       sucu_fech_regi,
       sucu_nomb,
       sucu_apel,
       sucu_sexo,
       sucu_celu,
       sucu_barr_codi,
       sucu_ciud_codi,
       sucu_prof_codi,
       sucu_emai)
    values
      (g_come_soli_serv.sose_clpr_codi,
       p_sucu_nume_item,
       g_come_soli_serv.s_sucu_desc_orig,
       g_come_soli_serv.s_sucu_dire_orig,
       g_come_soli_serv.s_sucu_tele_orig,
       g_come_soli_serv.sose_base,
       g_come_soli_serv.s_sucu_nume_cedu_orig,
       g_come_soli_serv.s_sucu_ruc_orig,
       'A',
       gen_user,
       sysdate,
       g_come_soli_serv.s_sucu_nomb_orig,
       g_come_soli_serv.s_sucu_apel_orig,
       g_come_soli_serv.s_sucu_sexo_orig,
       g_come_soli_serv.s_sucu_celu_orig,
       g_come_soli_serv.s_sucu_barr_codi_orig,
       g_come_soli_serv.s_sucu_ciud_codi_orig,
       g_come_soli_serv.s_sucu_prof_codi_orig,
       g_come_soli_serv.s_sucu_emai_orig);*/
  
  end pp_genera_subcuenta;

  procedure pp_genera_nuevo_cliente(i_empresa in number default 1) is
    v_sose_clpr_codi number(20);
    v_clpr           come_clie_prov%rowtype;
    v_sose_inmu_prop varchar2(2) := 'N';
  
  begin
    v_sose_clpr_codi                := fa_sec_come_clie_prov;
    g_come_soli_serv.sose_clpr_codi := v_sose_clpr_codi;
    v_clpr.clpr_nomb                := fa_pasa_capital(g_soli_serv_clie_dato.sose_nomb);
    v_clpr.clpr_apel                := fa_pasa_capital(g_soli_serv_clie_dato.sose_apel);
    v_clpr.clpr_dire                := fa_pasa_capital(g_soli_serv_clie_dato.sose_dire);
    v_clpr.clpr_cony_desc           := fa_pasa_capital(g_soli_serv_clie_dato.sose_nomb_cony);
    v_clpr.clpr_base                := g_soli_serv_clie_dato.sose_base;
    v_clpr.clpr_desc                := fa_pasa_capital(rtrim(ltrim(g_soli_serv_clie_dato.sose_nomb || ' ' ||
                                                                   g_soli_serv_clie_dato.sose_apel)));
    v_clpr.clpr_fech_ingr           := sysdate;
    v_clpr.clpr_clie_clas1_codi     := g_clpr_clie_clas1_codi;
    v_clpr.clpr_obse                := 'Cliente Generado en Solicitud de Servicios';
    v_clpr.clpr_esta                := 'A';
    v_clpr.clpr_prop_nomb           := fa_pasa_capital(g_soli_serv_clie_dato.sose_prop_nomb);
    v_clpr.clpr_sucu_codi           := parameter.p_sucu_codi;
  
    if g_come_soli_serv.sose_indi_timo = 'C' then
      v_clpr.clpr_orte_codi := 1;
    else
      if g_sose_indi_tipo_fact = 'C' then
        v_clpr.clpr_orte_codi := 3;
      else
        v_clpr.clpr_orte_codi := 2;
      end if;
    end if;
  
    begin
      select max(clpr_codi_alte) + 1
        into v_clpr.clpr_codi_alte
        from come_clie_prov
       where clpr_indi_clie_prov = 'C'
         and clpr_empr_codi = i_empresa;
    end;
  
    insert into come_clie_prov
      (clpr_codi,
       clpr_indi_clie_prov,
       clpr_codi_alte,
       clpr_tipo_pers,
       clpr_nomb,
       clpr_apel,
       clpr_tipo_docu,
       clpr_docu,
       clpr_esta_civi,
       clpr_fech_naci,
       clpr_dire,
       clpr_refe_dire,
       clpr_tele,
       clpr_mepa_codi,
       clpr_naci_codi,
       clpr_zona_codi,
       clpr_barr_codi,
       clpr_ciud_codi,
       clpr_sexo,
       clpr_email,
       clpr_email_fact,
       clpr_prof_codi,
       clpr_desc,
       clpr_ruc,
       clpr_fech_ingr,
       clpr_clie_clas1_codi,
       clpr_obse,
       clpr_esta,
       clpr_empl_codi,
       clpr_user_regi,
       clpr_fech_regi,
       clpr_prop_nomb,
       clpr_prop_docu,
       clpr_prop_nomb_2,
       clpr_prop_docu_2,
       clpr_orte_codi,
       clpr_sucu_codi,
       clpr_form_impr_fact,
       clpr_indi_excl_vali_sose_poli,
       clpr_base,
       clrp_ubicacion)
    values
      (v_sose_clpr_codi,
       'C',
       v_clpr.clpr_codi_alte,
       g_soli_serv_clie_dato.sose_tipo_pers,
       v_clpr.clpr_nomb,
       v_clpr.clpr_apel,
       g_soli_serv_clie_dato.sose_tipo_docu,
       g_soli_serv_clie_dato.sose_docu,
       g_soli_serv_clie_dato.sose_esta_civi,
       g_soli_serv_clie_dato.sose_fech_naci,
       v_clpr.clpr_dire,
       g_soli_serv_clie_dato.sose_refe_dire,
       g_soli_serv_clie_dato.sose_tele_part,
       g_soli_serv_clie_dato.sose_mepa_codi,
       g_soli_serv_clie_dato.sose_naci_codi,
       g_soli_serv_clie_dato.sose_zona_codi,
       g_soli_serv_clie_dato.sose_barr_codi,
       g_soli_serv_clie_dato.sose_ciud_codi,
       g_soli_serv_clie_dato.sose_sexo,
       g_soli_serv_clie_dato.sose_email,
       g_soli_serv_clie_dato.sose_email_fact,
       g_soli_serv_clie_dato.sose_prof_codi,
       v_clpr.clpr_desc,
       g_soli_serv_clie_dato.sose_docu,
       v_clpr.clpr_fech_ingr,
       v_clpr.clpr_clie_clas1_codi,
       v_clpr.clpr_obse,
       v_clpr.clpr_esta,
       g_anex.anex_empl_codi,
       gen_user,
       sysdate,
       g_soli_serv_clie_dato.sose_prop_nomb,
       g_soli_serv_clie_dato.sose_prop_docu,
       g_soli_serv_clie_dato.sose_prop_nomb_2,
       g_soli_serv_clie_dato.sose_prop_docu_2,
       v_clpr.clpr_orte_codi,
       v_clpr.clpr_sucu_codi,
       1,
       'N',
       v_clpr.clpr_base,
       g_soli_serv_clie_dato.sose_ubicacion);
  
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
       clpr_esta_civi_cony,
       clpr_base)
    values
      (v_sose_clpr_codi,
       nvl(v_sose_inmu_prop, 'N'),
       g_soli_serv_clie_dato.sose_nume_finc,
       g_soli_serv_clie_dato.sose_luga_trab,
       g_soli_serv_clie_dato.sose_tele_trab,
       g_soli_serv_clie_dato.sose_anti,
       g_soli_serv_clie_dato.sose_pues_trab,
       v_clpr.clpr_cony_desc,
       g_soli_serv_clie_dato.sose_tele_cony,
       g_soli_serv_clie_dato.sose_cedu_cony,
       g_soli_serv_clie_dato.sose_acti_cony,
       g_soli_serv_clie_dato.sose_luga_trab_cony,
       'S',
       v_clpr.clpr_base);
  
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
       fapa_user_modi,
       fapa_fech_modi,
       fapa_user_regi,
       fapa_fech_regi,
       fapa_empr_codi,
       fapa_base)
    values
      (fa_sec_come_clie_fact_pago,
       v_sose_clpr_codi,
       null, --fapa_nomb_pago,
       null, --fapa_tele_pago,
       null, --fapa_celu_pago,
       null, --fapa_emai_pago,
       null, --fapa_nomb_fact,
       null, --fapa_tele_fact,
       null, --fapa_celu_fact,
       g_soli_serv_clie_dato.sose_email_fact, --fapa_emai_fact,
       'N', --fapa_conf_emai_fact,
       null, --fapa_dire_emai_fact,
       null, --fapa_refe_dire_fact,
       null, --fapa_dia_tope_fact,
       1, --fapa_form_impr_fact,
       'N', --fapa_indi_excl_valg_soli_serv_clie_dato.sosepoli,
       null, --fapa_user_modi,
       null, --fapa_fech_modi,
       gen_user, --fapa_user_regi,
       sysdate, --fapa_fech_regi,
       nvl(i_empresa, 1), --fapa_empr_codi,
       v_clpr.clpr_base --fapa_base
       );
  
  end pp_genera_nuevo_cliente;

/*  procedure pp_borrar_ref(i_seq_id in number) as
  begin
  
    apex_collection.delete_member(p_collection_name => 'SOL_REF',
                                  p_seq             => i_seq_id);
    apex_collection.resequence_collection(p_collection_name => 'SOL_REF');
  
  end pp_borrar_ref;*/

  procedure pp_veri_soli_serv is
    v_count number;
    v_nume  number;
  begin
    v_nume := g_come_soli_serv.sose_nume;
    loop
      select count(*)
        into v_count
        from come_soli_serv
       where sose_nume = v_nume
         and sose_empr_codi = parameter.p_empr_codi;
    
      if v_count > 0 then
        v_nume := v_nume + 1;
      else
        if g_come_soli_serv.sose_nume <> v_nume then
          null;
          --    raise_application_error(-20010,
          --   'La solicitud ' ||
          --   g_come_soli_serv.sose_nume ||
          --  ' ya existe. La nueva solicitud se guardara con el numero ' ||
          --   v_nume || '.');
        end if;
        g_come_soli_serv.sose_nume := v_nume;
        exit;
      end if;
    end loop;
  end pp_veri_soli_serv;

  procedure pp_inse_soli_serv_clie_dato(p_sose_codi in number,
                                        p_indi_dato in char) is
    --v_sose_codi           number;
    --v_sose_indi_dato      varchar2(1);
    v_sose_barr_codi   number;
    v_sose_ciud_codi   number;
    v_sose_dist        varchar(80);
    v_sose_inmu_prop   varchar(1);
    v_sose_tele_trab   varchar(60);
    v_sose_anti        varchar(80);
    v_sose_pues_trab   varchar(80);
    v_sose_tele_cony   varchar(60);
    v_sose_cedu_cony   varchar(20);
    v_sose_acti_cony   varchar(40);
    v_sose_prop_nomb   varchar2(50);
    v_sose_prop_docu   varchar2(20);
    v_sose_prop_nomb_2 varchar2(50);
    v_sose_prop_docu_2 varchar2(20);
    v_sose_cont_desc   varchar2(80);
    v_sose_cont_tele   varchar2(50);
    v_sose_cont_emai   varchar2(2000);
  
    --v_count number;
  begin
    if p_indi_dato = 'D' then
      -- si es deudor
      --v_sose_indi_dato      := p_indi_dato; --indicador de codeudor
      g_soli_serv_clie_dato.sose_refe_dire := g_soli_serv_clie_dato.sose_refe_dire;
      v_sose_barr_codi                     := g_soli_serv_clie_dato.sose_barr_codi;
      v_sose_ciud_codi                     := g_soli_serv_clie_dato.sose_ciud_codi;
      v_sose_dist                          := g_soli_serv_clie_dato.sose_dist;
      v_sose_tele_trab                     := g_soli_serv_clie_dato.sose_tele_trab;
      v_sose_anti                          := g_soli_serv_clie_dato.sose_anti;
    
      --insertar
      insert into come_soli_serv_clie_dato
        (sose_codi,
         sose_indi_dato,
         sose_nomb,
         sose_apel,
         sose_tipo_docu,
         sose_docu,
         sose_esta_civi,
         sose_fech_naci,
         sose_dire,
         sose_refe_dire,
         sose_tele_part,
         sose_naci_codi,
         sose_zona_codi,
         sose_barr_codi,
         sose_ciud_codi,
         sose_dist,
         sose_inmu_prop,
         sose_nume_finc,
         sose_luga_trab,
         sose_tele_trab,
         sose_anti,
         sose_pues_trab,
         sose_nomb_cony,
         sose_tele_cony,
         sose_cedu_cony,
         sose_acti_cony,
         sose_luga_trab_cony,
         sose_prop_nomb,
         sose_prop_docu,
         sose_prop_nomb_2,
         sose_prop_docu_2,
         sose_cont_desc,
         sose_cont_tele,
         sose_cont_emai,
         sose_base,
         sose_barrio_des,
         sose_ubicacion)
      values
        (p_sose_codi,
         p_indi_dato,
         fa_pasa_capital(g_soli_serv_clie_dato.sose_nomb),
         fa_pasa_capital(g_soli_serv_clie_dato.sose_apel),
         g_soli_serv_clie_dato.sose_tipo_docu,
         g_soli_serv_clie_dato.sose_docu,
         g_soli_serv_clie_dato.sose_esta_civi,
         g_soli_serv_clie_dato.sose_fech_naci,
         g_soli_serv_clie_dato.sose_dire,
         g_soli_serv_clie_dato.sose_refe_dire,
         g_soli_serv_clie_dato.sose_tele_part,
         g_soli_serv_clie_dato.sose_naci_codi,
         g_soli_serv_clie_dato.sose_zona_codi,
         v_sose_barr_codi,
         v_sose_ciud_codi,
         v_sose_dist,
         v_sose_inmu_prop,
         g_soli_serv_clie_dato.sose_nume_finc,
         g_soli_serv_clie_dato.sose_luga_trab,
         v_sose_tele_trab,
         v_sose_anti,
         g_soli_serv_clie_dato.sose_pues_trab,
         initcap(g_soli_serv_clie_dato.sose_nomb_cony),
         g_soli_serv_clie_dato.sose_tele_cony,
         g_soli_serv_clie_dato.sose_cedu_cony,
         g_soli_serv_clie_dato.sose_acti_cony,
         g_soli_serv_clie_dato.sose_luga_trab_cony,
         g_soli_serv_clie_dato.sose_prop_nomb,
         g_soli_serv_clie_dato.sose_prop_docu,
         g_soli_serv_clie_dato.sose_prop_nomb_2,
         g_soli_serv_clie_dato.sose_prop_docu_2,
         g_soli_serv_clie_dato.sose_cont_desc,
         g_soli_serv_clie_dato.sose_cont_tele,
         g_soli_serv_clie_dato.sose_cont_emai,
         g_soli_serv_clie_dato.sose_base,
         g_soli_serv_clie_dato.sose_barrio_des,
         g_soli_serv_clie_dato.sose_ubicacion);
    end if;
  end pp_inse_soli_serv_clie_dato;

  procedure pp_inse_dato_soli_serv is
  
  begin
  
    g_come_soli_serv.sose_codi := fa_sec_come_pres_codi;
  
    g_come_soli_serv.sose_base := parameter.p_codi_base;
  
    if g_come_soli_serv.sose_tipo = 'S' then
      if g_come_soli_serv.sose_sucu_nume_item is null then
        pp_genera_subcuenta(g_come_soli_serv.sose_sucu_nume_item);
        --g_sucu_nume_item := v_sose_sucu_nume_item;
      end if;
    end if;
    if g_come_soli_serv.sose_clpr_codi is null then
      
      pp_genera_nuevo_cliente;
      -- v_sose_clpr_codi := g_come_soli_serv.sose_clpr_codi;
    end if;
  
    insert into come_soli_serv
      (sose_codi,
       sose_nume,
       sose_fech_emis,
       sose_clpr_codi,
       sose_sucu_nume_item,
       sose_obse,
       sose_base,
       sose_entr_inic,
       sose_mone_codi,
       sose_tasa_mone,
       sose_impo_mone,
       sose_empr_codi,
       sose_user_regi,
       sose_fech_regi,
       sose_esta,
       sose_clpr_codi_aseg,
       sose_indi_timo,
       sose_tipo,
       sose_tipo_acce,
       sose_nume_poli,
       sose_esta_veri,
       sose_nume_orde_serv,
       sose_fech_inic_poli,
       sose_fech_fini_poli,
       sose_dura_cont,
       sose_cant_movi,
       sose_equi_prec,
       sose_tipo_fact,
       sose_calc_gran,
       sose_calc_pequ,
       sose_ning_calc,
       sose_indi_moni,
       sose_indi_nexo_recu,
       sose_indi_para_moto,
       sose_indi_boto_esta,
       sose_indi_acce_aweb,
       sose_indi_roam,
       sose_tipo_roam,
       sose_indi_boto_pani,
       sose_indi_mant_equi,
       sose_indi_cort_corr_auto,
       sose_indi_avis_poli,
       sose_indi_auto_dete_vehi,
       sose_inst_espe,
       sose_prec_unit,
       sose_valo_tota,
       sose_fech_vige,
       sose_roam_fech_inic_vige,
       sose_roam_fech_fini_vige,
       sose_clpr_codi_orig,
       sose_sucu_nume_item_orig,
       sose_codi_ante,
       sose_indi_sens_tapa_tanq,
       sose_indi_sens_comb,
       sose_indi_sens_temp,
       sose_indi_aper_puer,
       sose_clav_conf,
       sose_corr_info_even,
       sose_dire_obse,
       sose_codi_padr,
       sose_clpr_codi_refe)
    values
      (g_come_soli_serv.sose_codi,
       g_come_soli_serv.sose_nume,
       g_come_soli_serv.sose_fech_emis,
       g_come_soli_serv.sose_clpr_codi,
       g_come_soli_serv.sose_sucu_nume_item,
       g_come_soli_serv.sose_obse,
       g_come_soli_serv.sose_base,
       g_come_soli_serv.sose_entr_inic,
       g_come_soli_serv.sose_mone_codi,
       g_come_soli_serv.sose_tasa_mone,
       g_come_soli_serv.sose_impo_mone,
       g_come_soli_serv.sose_empr_codi,
       gen_user,
       sysdate,
       g_come_soli_serv.sose_esta,
       g_come_soli_serv.sose_clpr_codi_aseg,
       g_come_soli_serv.sose_indi_timo,
       g_come_soli_serv.sose_tipo,
       g_come_soli_serv.sose_tipo_acce,
       g_come_soli_serv.sose_nume_poli,
       nvl(g_come_soli_serv.sose_esta_veri, 'P'),
       g_come_soli_serv.sose_nume_orde_serv,
       g_come_soli_serv.sose_fech_inic_poli,
       g_come_soli_serv.sose_fech_fini_poli,
       g_come_soli_serv.sose_dura_cont,
       g_come_soli_serv.sose_cant_movi,
       g_come_soli_serv.sose_equi_prec,
       g_come_soli_serv.sose_tipo_fact,
       g_come_soli_serv.sose_calc_gran,
       g_come_soli_serv.sose_calc_pequ,
       g_come_soli_serv.sose_ning_calc,
       g_come_soli_serv.sose_indi_moni,
       g_come_soli_serv.sose_indi_nexo_recu,
       g_come_soli_serv.sose_indi_para_moto,
       g_come_soli_serv.sose_indi_boto_esta,
       g_come_soli_serv.sose_indi_acce_aweb,
       g_come_soli_serv.sose_indi_roam,
       g_come_soli_serv.sose_tipo_roam,
       g_come_soli_serv.sose_indi_boto_pani,
       g_come_soli_serv.sose_indi_mant_equi,
       g_come_soli_serv.sose_indi_cort_corr_auto,
       g_come_soli_serv.sose_indi_avis_poli,
       g_come_soli_serv.sose_indi_auto_dete_vehi,
       g_come_soli_serv.sose_inst_espe,
       g_come_soli_serv.sose_prec_unit,
       g_come_soli_serv.sose_valo_tota,
       g_come_soli_serv.sose_fech_vige,
       g_come_soli_serv.sose_roam_fech_inic_vige,
       g_come_soli_serv.sose_roam_fech_fini_vige,
       g_come_soli_serv.sose_clpr_codi_orig,
       g_come_soli_serv.sose_sucu_nume_item_orig,
       g_come_soli_serv.sose_codi_ante,
       g_come_soli_serv.sose_indi_sens_tapa_tanq,
       g_come_soli_serv.sose_indi_sens_comb,
       g_come_soli_serv.sose_indi_sens_temp,
       g_come_soli_serv.sose_indi_aper_puer,
       g_come_soli_serv.sose_clav_conf,
       g_come_soli_serv.sose_corr_info_even,
       g_come_soli_serv.sose_dire_obse,
       g_come_soli_serv.sose_codi_padr,
       g_come_soli_serv.sose_clpr_codi_refe);
  
  end pp_inse_dato_soli_serv;

 /* procedure pp_ejecuta_consulta_soli_dato(i_sose_codi           in number,
                                          o_clpr_codi_alte      out number,
                                          o_clpr_codi_alte_orig out number,
                                          o_sucu_nume_item_orig out number,
                                          o_sucu_nume_item      out number,
                                          o_mepa_codi_alte      out number,
                                          o_naci_codi_alte      out number,
                                          o_zona_codi_alte      out number,
                                          o_prof_codi_alte      out number,
                                          o_ciud_codi_alte      out number,
                                          o_clas1_codi_alte     out number,
                                          o_barr_codi_alte      out number,
                                          o_clpr_codi_alte_refe out number) is
  
    cursor cv_refe is
      select refe_sose_codi,
             refe_nume_item,
             refe_indi_dato,
             refe_tipo,
             refe_desc,
             refe_tele
        from come_soli_serv_refe
       where refe_indi_dato = 'D'
         and refe_sose_codi = i_sose_codi;
  
    --v_exist         varchar2(1) := 'N';
    v_sol_serv come_soli_serv%rowtype;
    --v_cli_prov      come_clie_prov%rowtype;
    v_sol_clie_dato come_soli_serv_clie_dato%rowtype;
    --v_clpr_codi_alte_refe number;
  begin
  
    if i_sose_codi is null then
      raise e_sin_parametro;
    end if;
  
    select *
      into v_sol_serv
      from come_soli_serv t
     where t.sose_codi = i_sose_codi;
  
    select *
      into v_sol_clie_dato
      from come_soli_serv_clie_dato
     where sose_indi_dato = 'D'
       and sose_codi = i_sose_codi;
  
    --o_sose_nume_padr      := v_cli_prov.clpr_codi_alte;
    --  o_clpr_codi_alte_orig := v_cli_prov.clpr_codi_alte;
  
    \* o_sucu_nume_item_orig := v_cli_prov.clpr_codi_alte;
    o_sucu_nume_item      := v_cli_prov.clpr_codi_alte;
    o_clas1_codi_alte     := v_cli_prov.clpr_codi_alte;*\
    for r in cv_refe loop
    
      pp_add_referencia(i_ref_desc => r.refe_desc,
                        i_ref_tel  => r.refe_tele);
    end loop;
  
    \*   select clpr_desc clpr_desc,
            nvl(clpr_tipo_pers, 'F') tipo_persona,
            clpr_clie_clas1_codi clasificacion
       from come_clie_prov
      where clpr_indi_clie_prov = 'C'
        and clpr_codi = :p47_sose_clpr_codi;
    *\
  
    \*pp_setear_tipo_persona;*\
  
    pp_cliente_alte(v_sol_serv.sose_clpr_codi, o_clpr_codi_alte);
  
    pp_cliente_alte(v_sol_serv.sose_clpr_codi_orig, o_clpr_codi_alte_orig);
  
    pp_cliente_alte(v_sol_serv.sose_clpr_codi_refe, o_clpr_codi_alte_refe);
  
    -- v('P47_CLPR_CODI_ALTE_REFE') 
    -- v('P47_SOSE_CLPR_CODI_REFE');
  
    pp_clie_clas1_alte(i_clas1_codi      => 1,
                       o_clas1_codi_alte => o_clas1_codi_alte);
  
    pp_come_medi_pago_alte(v_sol_clie_dato.sose_mepa_codi,
                           o_mepa_codi_alte);
  
    pp_nacionalidad_alte(v_sol_clie_dato.sose_naci_codi, o_naci_codi_alte);
  
    pp_ciudad_alte(v_sol_clie_dato.sose_ciud_codi, o_ciud_codi_alte);
  
    pp_zona_cli_alte(v_sol_clie_dato.sose_zona_codi, o_zona_codi_alte);
  
    pp_barrio_alte(v_sol_clie_dato.sose_barr_codi, o_barr_codi_alte);
  
    pp_profesion_alte(v_sol_clie_dato.sose_prof_codi, o_prof_codi_alte);
  
  exception
    when e_sin_parametro then
      o_clas1_codi_alte := 1;
      null;
  end pp_ejecuta_consulta_soli_dato;*/

  procedure pp_generar_mensaje is
  
    cursor c_user_i is
      select us.user_login
        from come_admi_mens m, come_admi_mens_user u, segu_user us
       where m.adme_codi = u.meus_adme_codi
         and u.meus_user_codi = us.user_codi
         and m.adme_procedure = 'PA_GENE_MENS_AUTO_SOLI_SERV';
  
    v_clpr_desc varchar2(200);
    --v_ortr_codi      number;
    --v_ortr_nume      number;
    --v_ortr_fech_emis date;
    --v_ortr_desc      varchar2(100);
  begin
    if g_sucu_nume_item is not null then
      v_clpr_desc := g_soli_serv_clie_dato.sose_desc || '; SubCuenta (' ||
                     g_sucu_nume_item || ')';
    else
      v_clpr_desc := g_soli_serv_clie_dato.sose_desc;
    end if;
  
    if w_indi_oper = 'I' then
      if g_come_soli_serv.sose_esta = 'P' then
        for x in c_user_i loop
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
             ('Se ha generado la solicitud de servicio Nro. ' ||
             g_come_soli_serv.sose_nume || ' para el cliente ' ||
             v_clpr_desc || ', con fecha de emision ' ||
             g_come_soli_serv.sose_fech_emis),
             x.user_login,
             gen_user,
             sysdate,
             'N',
             'SSA',
             g_come_soli_serv.sose_codi);
        end loop;
      
      end if;
    end if;
  end pp_generar_mensaje;

  procedure pp_actu_dato_soli_serv(p_sose_codi in number) is
    v_sose_codi           number;
    v_sose_fech_emis      date;
    v_sose_clpr_codi      number;
    v_sose_obse           varchar2(2000);
    v_sose_base           number;
    v_sose_entr_inic      number;
    v_sose_mone_codi      number;
    v_sose_tasa_mone      number;
    v_sose_impo_mone      number;
    v_sose_empr_codi      number;
    v_anex_empl_codi      number;
    v_sose_user_modi      varchar2(20);
    v_sose_fech_modi      date;
    v_sose_clpr_codi_aseg number;
    v_sose_indi_timo      varchar2(1);
    v_sose_tipo           varchar2(3);
    v_sose_tipo_acce      varchar2(1);
    v_sose_esta_veri      varchar2(1);
    v_sose_dura_cont      number(20);
    v_sose_cant_movi      number(20);
    v_sose_equi_prec      number(20);
    v_sose_tipo_fact      varchar2(1);
  
    v_sose_calc_gran           varchar2(1);
    v_sose_calc_pequ           varchar2(1);
    v_sose_ning_calc           varchar2(1);
    v_sose_indi_moni           varchar2(1);
    v_sose_indi_nexo_recu      varchar2(1);
    v_sose_indi_para_moto      varchar2(1);
    v_sose_indi_boto_esta      varchar2(1);
    v_sose_indi_acce_aweb      varchar2(1);
    v_sose_indi_roam           varchar2(1);
    v_sose_tipo_roam           varchar2(1);
    v_sose_indi_boto_pani      varchar2(1);
    v_sose_indi_mant_equi      varchar2(1);
    v_sose_indi_sens_tapa_tanq varchar2(1);
    v_sose_indi_sens_comb      varchar2(1);
    v_sose_indi_sens_temp      varchar2(1);
    v_sose_indi_aper_puer      varchar2(1);
    v_sose_codi_padr           number;
  
    v_sose_indi_cort_corr_auto varchar2(1);
    v_sose_indi_avis_poli      varchar2(1);
    v_sose_indi_auto_dete_vehi varchar2(1);
    v_sose_inst_espe           varchar2(1000);
    v_sose_prec_unit           number(20);
    v_sose_fech_inic_vige      date;
    v_sose_fech_vige           date;
    v_sose_valo_tota           number(20);
    v_sose_roam_fech_inic_vige date;
    v_sose_roam_fech_fini_vige date;
    v_sose_sucu_nume_item      number;
    v_sose_fech_inic_poli      date;
    v_sose_fech_fini_poli      date;
    v_sose_clpr_codi_orig      number;
    v_sose_sucu_nume_item_orig number;
    v_sose_codi_ante           number;
    v_sose_corr_info_even      varchar2(1000);
    v_sose_clav_conf           varchar2(1000);
  begin
  
    v_sose_codi                     := p_sose_codi;
    g_come_soli_serv.sose_nume      := g_come_soli_serv.sose_nume;
    v_sose_fech_emis                := g_come_soli_serv.sose_fech_emis;
    v_sose_clpr_codi                := g_come_soli_serv.sose_clpr_codi;
    v_sose_obse                     := g_come_soli_serv.sose_obse;
    v_sose_base                     := g_come_soli_serv.sose_base;
    v_sose_entr_inic                := null; --g_come_soli_serv.sose_entr_inic;
    v_sose_mone_codi                := g_come_soli_serv.sose_mone_codi;
    v_sose_tasa_mone                := g_come_soli_serv.sose_tasa_mone;
    v_sose_impo_mone                := null;
    v_sose_empr_codi                := g_come_soli_serv.sose_empr_codi;
    v_sose_user_modi                := gen_user;
    v_sose_fech_modi                := sysdate;
    v_sose_clpr_codi_aseg           := g_come_soli_serv.sose_clpr_codi_aseg;
    v_sose_indi_timo                := g_come_soli_serv.sose_indi_timo;
    v_sose_tipo                     := g_come_soli_serv.sose_tipo;
    g_come_soli_serv.sose_nume_poli := g_come_soli_serv.sose_nume_poli;
    v_sose_esta_veri                := g_come_soli_serv.sose_esta_veri;
    v_sose_dura_cont                := g_come_soli_serv.sose_dura_cont;
    v_sose_cant_movi                := g_come_soli_serv.sose_cant_movi;
    v_sose_equi_prec                := null; --g_come_soli_serv.sose_equi_prec;
    v_sose_clpr_codi_orig           := g_come_soli_serv.sose_clpr_codi_orig;
    v_sose_sucu_nume_item           := g_come_soli_serv.sose_sucu_nume_item;
    v_sose_tipo_fact                := g_come_soli_serv.sose_tipo_fact;
    v_sose_sucu_nume_item_orig      := g_come_soli_serv.sose_sucu_nume_item_orig;
    v_sose_codi_ante                := g_come_soli_serv.sose_codi_ante;
  
    v_sose_calc_gran                     := null;
    v_sose_calc_pequ                     := null;
    v_sose_ning_calc                     := null;
    v_sose_indi_moni                     := null;
    v_sose_indi_nexo_recu                := null;
    v_sose_indi_para_moto                := null;
    v_sose_indi_boto_esta                := null;
    v_sose_indi_acce_aweb                := null;
    v_sose_indi_roam                     := null;
    v_sose_tipo_roam                     := null;
    v_sose_indi_boto_pani                := null;
    v_sose_indi_mant_equi                := null;
    v_sose_indi_sens_tapa_tanq           := null;
    v_sose_indi_sens_comb                := null;
    v_sose_indi_sens_temp                := null;
    v_sose_indi_aper_puer                := null;
    v_sose_indi_cort_corr_auto           := null;
    v_sose_prec_unit                     := null;
    v_sose_fech_inic_vige                := null;
    v_sose_fech_vige                     := null;
    v_sose_valo_tota                     := null;
    v_sose_roam_fech_inic_vige           := null;
    v_sose_roam_fech_fini_vige           := null;
    g_come_soli_serv.sose_nume_orde_serv := g_come_soli_serv.sose_nume_orde_serv;
    v_sose_fech_inic_poli                := g_come_soli_serv.sose_fech_inic_poli;
    v_sose_fech_fini_poli                := g_come_soli_serv.sose_fech_fini_poli;
    v_sose_codi_padr                     := g_come_soli_serv.sose_codi_padr;
  
    update come_soli_serv
       set sose_nume                = g_come_soli_serv.sose_nume,
           sose_fech_emis           = v_sose_fech_emis,
           sose_clpr_codi           = v_sose_clpr_codi,
           sose_sucu_nume_item      = v_sose_sucu_nume_item,
           sose_clpr_codi_orig      = v_sose_clpr_codi_orig,
           sose_sucu_nume_item_orig = v_sose_sucu_nume_item_orig,
           sose_obse                = v_sose_obse,
           sose_base                = v_sose_base,
           sose_entr_inic           = v_sose_entr_inic,
           sose_mone_codi           = v_sose_mone_codi,
           sose_tasa_mone           = v_sose_tasa_mone,
           sose_impo_mone           = v_sose_impo_mone,
           sose_empr_codi           = v_sose_empr_codi,
           sose_user_modi           = v_sose_user_modi,
           sose_fech_modi           = v_sose_fech_modi,
           sose_clpr_codi_aseg      = v_sose_clpr_codi_aseg,
           sose_indi_timo           = v_sose_indi_timo,
           sose_tipo                = v_sose_tipo,
           sose_tipo_acce           = v_sose_tipo_acce,
           sose_nume_poli           = g_come_soli_serv.sose_nume_poli,
           sose_esta_veri           = v_sose_esta_veri,
           sose_nume_orde_serv      = g_come_soli_serv.sose_nume_orde_serv,
           sose_fech_inic_poli      = v_sose_fech_inic_poli,
           sose_fech_fini_poli      = v_sose_fech_fini_poli,
           sose_dura_cont           = v_sose_dura_cont,
           sose_cant_movi           = v_sose_cant_movi,
           sose_equi_prec           = v_sose_equi_prec,
           sose_tipo_fact           = v_sose_tipo_fact,
           sose_calc_gran           = v_sose_calc_gran,
           sose_calc_pequ           = v_sose_calc_pequ,
           sose_ning_calc           = v_sose_ning_calc,
           sose_indi_moni           = v_sose_indi_moni,
           sose_indi_nexo_recu      = v_sose_indi_nexo_recu,
           sose_indi_para_moto      = v_sose_indi_para_moto,
           sose_indi_boto_esta      = v_sose_indi_boto_esta,
           sose_indi_acce_aweb      = v_sose_indi_acce_aweb,
           sose_indi_roam           = v_sose_indi_roam,
           sose_tipo_roam           = v_sose_tipo_roam,
           sose_indi_boto_pani      = v_sose_indi_boto_pani,
           sose_indi_mant_equi      = v_sose_indi_mant_equi,
           sose_indi_cort_corr_auto = v_sose_indi_cort_corr_auto,
           sose_indi_avis_poli      = v_sose_indi_avis_poli,
           sose_indi_auto_dete_vehi = v_sose_indi_auto_dete_vehi,
           sose_corr_info_even      = v_sose_corr_info_even,
           sose_dire_obse           = g_come_soli_serv.sose_dire_obse,
           sose_inst_espe           = v_sose_inst_espe,
           sose_clav_conf           = v_sose_clav_conf,
           sose_prec_unit           = v_sose_prec_unit,
           sose_valo_tota           = v_sose_valo_tota,
           sose_fech_inic_vige      = v_sose_fech_inic_vige,
           sose_fech_vige           = v_sose_fech_vige,
           sose_roam_fech_inic_vige = v_sose_roam_fech_inic_vige,
           sose_roam_fech_fini_vige = v_sose_roam_fech_fini_vige,
           sose_codi_ante           = v_sose_codi_ante,
           sose_indi_sens_tapa_tanq = v_sose_indi_sens_tapa_tanq,
           sose_indi_sens_comb      = v_sose_indi_sens_comb,
           sose_indi_sens_temp      = v_sose_indi_sens_temp,
           sose_indi_aper_puer      = v_sose_indi_aper_puer,
           sose_codi_padr           = v_sose_codi_padr,
           sose_clpr_codi_refe      = g_come_soli_serv.sose_clpr_codi_refe
     where sose_codi = v_sose_codi;
  end pp_actu_dato_soli_serv;

  procedure pp_actu_soli_serv_cont(p_sose_codi in number,
                                   p_indi_tipo in char) is
    /*v_cont_sose_codi number(20);
    v_cont_nume_item number(20);
    v_cont_tipo      varchar2(1);
    v_cont_apel      varchar2(40);
    v_cont_nomb      varchar2(40);
    v_cont_vinc      varchar2(40);
    v_cont_nume_docu varchar2(20);
    v_cont_pass      varchar2(20);
    v_cont_tele      varchar2(40);
    v_cont_celu      varchar2(40);
    v_cont_hora      varchar2(20);
    v_cont_emai      varchar2(2000);
    v_count          number;*/
  
    --v_cant_cont number;
  begin
    null;
    /* if p_indi_tipo = 'H' then
       delete from come_soli_serv_cont
        where cont_sose_codi = p_sose_codi
          and cont_tipo = p_indi_tipo;
     
    --   go_block('babmc_deud_habi');
       first_record;
       v_cont_sose_codi := p_sose_codi;
       --loop
         if :babmc_deud_habi.cont_apel is not null then
           v_cont_nume_item := :babmc_deud_habi.cont_nume_item;
           v_cont_tipo      := p_indi_tipo;
           v_cont_apel      := :babmc_deud_habi.cont_apel;
           v_cont_nomb      := :babmc_deud_habi.cont_nomb;
           v_cont_vinc      := :babmc_deud_habi.cont_vinc;
           v_cont_nume_docu := :babmc_deud_habi.cont_nume_docu;
           v_cont_emai      := :babmc_deud_habi.cont_emai;
           v_cont_pass      := :babmc_deud_habi.cont_pass;
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
             (v_cont_sose_codi,
              v_cont_nume_item,
              v_cont_apel,
              v_cont_nomb,
              v_cont_vinc,
              v_cont_nume_docu,
              v_cont_pass,
              v_cont_emai,
              v_cont_tipo);
         end if;
       
       end loop;
       
     elsif p_indi_tipo = 'C' then
       delete from come_soli_serv_cont
        where cont_sose_codi = p_sose_codi
          and cont_tipo = p_indi_tipo;
     
       v_cont_sose_codi := p_sose_codi;
       loop
         if :babmc_deud_cont.cont_apel is not null then
           v_cont_nume_item := :babmc_deud_cont.cont_nume_item;
           v_cont_tipo      := p_indi_tipo;
           v_cont_apel      := :babmc_deud_cont.cont_apel;
           v_cont_nomb      := :babmc_deud_cont.cont_nomb;
           v_cont_tele      := :babmc_deud_cont.cont_tele;
           v_cont_celu      := :babmc_deud_cont.cont_celu;
           v_cont_hora      := :babmc_deud_cont.cont_hora;
           v_cont_emai      := :babmc_deud_habi.cont_emai;
         
           insert into come_soli_serv_cont
             (cont_sose_codi,
              cont_nume_item,
              cont_apel,
              cont_nomb,
              cont_tele,
              cont_celu,
              cont_hora,
              cont_emai,
              cont_tipo)
           values
             (v_cont_sose_codi,
              v_cont_nume_item,
              v_cont_apel,
              v_cont_nomb,
              v_cont_tele,
              v_cont_celu,
              v_cont_hora,
              v_cont_emai,
              v_cont_tipo);
         
         end if;
    
       end loop;
     end if;*/
  
  end pp_actu_soli_serv_cont;

  procedure pp_actualiza_datos_cliente is
  begin
    --actualiza datos del cliente solo en caso que no sea una aseguradora.
    if g_clpr_clie_clas1_codi <> parameter.p_codi_clas1_clie_subclie then
      /*if g_soli_serv_clie_dato.sose_desc is not null then
        update come_clie_prov
           set clpr_desc = g_soli_serv_clie_dato.sose_desc
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_nomb is not null then
        update come_clie_prov
           set clpr_nomb = g_soli_serv_clie_dato.sose_nomb
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_apel is not null then
        update come_clie_prov
           set clpr_apel = g_soli_serv_clie_dato.sose_apel
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;*/
    /*
      if g_soli_serv_clie_dato.sose_tipo_docu is not null then
        update come_clie_prov
           set clpr_tipo_docu = g_soli_serv_clie_dato.sose_tipo_docu
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_docu is not null then
        update come_clie_prov
           set clpr_docu = g_soli_serv_clie_dato.sose_docu,
               clpr_ruc  = g_soli_serv_clie_dato.sose_docu
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;*/
    
      if g_soli_serv_clie_dato.sose_esta_civi is not null then
        update come_clie_prov
           set clpr_esta_civi = g_soli_serv_clie_dato.sose_esta_civi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
     /* if g_soli_serv_clie_dato.sose_sexo is not null then
        update come_clie_prov
           set clpr_sexo = g_soli_serv_clie_dato.sose_sexo
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;*/
    
    /*  if g_soli_serv_clie_dato.sose_fech_naci is not null then
        update come_clie_prov
           set clpr_fech_naci = g_soli_serv_clie_dato.sose_fech_naci
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;*/
    
      if g_soli_serv_clie_dato.sose_dire is not null then
        update come_clie_prov
           set clpr_dire = g_soli_serv_clie_dato.sose_dire
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_tele_part is not null then
        update come_clie_prov
           set clpr_tele = g_soli_serv_clie_dato.sose_tele_part
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_email is not null then
        update come_clie_prov
           set clpr_email = g_soli_serv_clie_dato.sose_email
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_email_fact is not null then
        update come_clie_prov
           set clpr_email_fact = g_soli_serv_clie_dato.sose_email_fact
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      
  /*      update come_clie_fact_pago
           set fapa_emai_fact = g_soli_serv_clie_dato.sose_email_fact
         where fapa_clpr_codi = g_come_soli_serv.sose_clpr_codi;
    */  end if;
    
    /*  if g_soli_serv_clie_dato.sose_mepa_codi is not null then
        update come_clie_prov
           set clpr_mepa_codi = g_soli_serv_clie_dato.sose_mepa_codi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_naci_codi is not null then
        update come_clie_prov
           set clpr_naci_codi = g_soli_serv_clie_dato.sose_naci_codi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;*/
    
     /* if g_soli_serv_clie_dato.sose_zona_codi is not null then
        update come_clie_prov
           set clpr_zona_codi = g_soli_serv_clie_dato.sose_zona_codi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;*/
    
      if g_soli_serv_clie_dato.sose_ciud_codi is not null then
        update come_clie_prov
           set clpr_ciud_codi = g_soli_serv_clie_dato.sose_ciud_codi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_barr_codi is not null then
        update come_clie_prov
           set clpr_barr_codi = g_soli_serv_clie_dato.sose_barr_codi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
     /* if g_soli_serv_clie_dato.sose_prop_nomb is not null then
        update come_clie_prov
           set clpr_prop_nomb = g_soli_serv_clie_dato.sose_prop_nomb
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_prop_docu is not null then
        update come_clie_prov
           set clpr_prop_docu = g_soli_serv_clie_dato.sose_prop_docu
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_prop_carg is not null then
        update come_clie_prov
           set clpr_prop_carg = g_soli_serv_clie_dato.sose_prop_carg
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;*/
    
      /*if g_soli_serv_clie_dato.sose_prof_codi is not null then
        update come_clie_prov
           set clpr_prof_codi = g_soli_serv_clie_dato.sose_prof_codi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_clpr_clie_clas1_codi is not null then
        update come_clie_prov
           set clpr_clie_clas1_codi = g_clpr_clie_clas1_codi
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_prop_nomb_2 is not null then
        update come_clie_prov
           set clpr_prop_nomb_2 = g_soli_serv_clie_dato.sose_prop_nomb_2
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_prop_docu_2 is not null then
        update come_clie_prov
           set clpr_prop_docu_2 = g_soli_serv_clie_dato.sose_prop_docu_2
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_prop_carg_2 is not null then
        update come_clie_prov
           set clpr_prop_carg_2 = g_soli_serv_clie_dato.sose_prop_carg_2
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_cont_desc is not null then
        update come_clie_prov
           set clpr_cont_desc = g_soli_serv_clie_dato.sose_cont_desc
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_cont_tele is not null then
        update come_clie_prov
           set clpr_cont_tele = g_soli_serv_clie_dato.sose_cont_tele
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    
      if g_soli_serv_clie_dato.sose_cont_emai is not null then
        update come_clie_prov
           set clpr_cont_emai = g_soli_serv_clie_dato.sose_cont_emai
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;*/
    
      if g_soli_serv_clie_dato.sose_refe_dire is not null then
        update come_clie_prov
           set clpr_refe_dire = g_soli_serv_clie_dato.sose_refe_dire
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
      
      if g_soli_serv_clie_dato.sose_refe_dire is not null then
        update come_clie_prov d
           set d.clrp_ubicacion = g_soli_serv_clie_dato.sose_ubicacion
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    end if;
  end;

  procedure pp_actu_secu is
  begin
  
    update come_secu
       set secu_come_sose_nume = g_come_soli_serv.sose_nume
     where secu_codi =
           (select peco_secu_codi
              from come_pers_comp
             where peco_codi = parameter.p_peco_codi);
  
  exception
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_actu_secu;

  procedure pp_actu_soli_serv_clie_dato(p_sose_codi in number,
                                        p_indi_dato in char) is
  
    v_sose_barr_codi number;
    v_sose_ciud_codi number;
    v_sose_dist      varchar(80);
    v_sose_inmu_prop varchar(1) := 'N';
    v_sose_tele_trab varchar(60);
    v_sose_anti      varchar(80);
    v_sose_pues_trab varchar(80);
  
    v_sose_tele_cony  varchar(60);
    v_sose_cedu_cony  varchar(20);
    v_sose_acti_cony  varchar(40);
    v_sose_sexo       varchar2(1);
    v_sose_email      varchar2(2000);
    v_sose_email_fact varchar2(2000);
    v_sose_prof_codi  number(20);
    v_sose_base       number;
  
    v_clpr_prop_nomb   varchar2(50);
    v_clpr_prop_docu   varchar2(20);
    v_clpr_prop_carg   varchar2(40);
    v_clpr_prop_nomb_2 varchar2(50);
    v_clpr_prop_docu_2 varchar2(20);
    v_clpr_prop_carg_2 varchar2(40);
    v_clpr_cont_desc   varchar2(80);
    v_clpr_cont_tele   varchar2(50);
    v_clpr_cont_emai   varchar2(2000);
    --v_count               number;
    v_clpr_esta_civi_cony varchar2(1);
  
    v_refe_sose_codi number(20);
    v_refe_nume_item number(20);
    v_refe_indi_dato varchar2(1);
    v_refe_tipo      varchar2(1);
    v_refe_desc      varchar2(100);
    v_refe_tele      varchar2(60);
  
    v_cant_refe number;
    v_cant_dato number;
  
  begin
    begin
      select nvl(clpr_esta_civi_cony, 'S')
        into v_clpr_esta_civi_cony
        from come_clie_prov_dato
       where clpr_codi = g_come_soli_serv.sose_clpr_codi;
    exception
      when no_data_found then
        v_clpr_esta_civi_cony := 'S';
    end;
  
    delete from come_soli_serv_clie_dato where sose_codi = p_sose_codi;
  
    --delete from come_clie_prov_dato where clpr_codi = g_come_soli_serv.sose_clpr_codi;
  
    --v_sose_indi_dato      := p_indi_dato; 
    g_soli_serv_clie_dato.sose_zona_codi      := g_soli_serv_clie_dato.sose_zona_codi;
    v_sose_barr_codi                          := g_soli_serv_clie_dato.sose_barr_codi;
    v_sose_ciud_codi                          := g_soli_serv_clie_dato.sose_ciud_codi;
    v_sose_dist                               := g_soli_serv_clie_dato.sose_dist;
    g_soli_serv_clie_dato.sose_luga_trab      := g_soli_serv_clie_dato.sose_luga_trab;
    v_sose_tele_trab                          := g_soli_serv_clie_dato.sose_tele_trab;
    v_sose_anti                               := g_soli_serv_clie_dato.sose_anti;
    v_sose_pues_trab                          := g_soli_serv_clie_dato.sose_pues_trab;
    v_sose_tele_cony                          := g_soli_serv_clie_dato.sose_tele_cony;
    v_sose_cedu_cony                          := g_soli_serv_clie_dato.sose_cedu_cony;
    v_sose_acti_cony                          := g_soli_serv_clie_dato.sose_acti_cony;
    g_soli_serv_clie_dato.sose_luga_trab_cony := g_soli_serv_clie_dato.sose_luga_trab_cony;
    v_sose_sexo                               := g_soli_serv_clie_dato.sose_sexo;
    v_sose_email                              := g_soli_serv_clie_dato.sose_email;
    v_sose_email_fact                         := g_soli_serv_clie_dato.sose_email_fact;
    v_sose_prof_codi                          := g_soli_serv_clie_dato.sose_prof_codi;
    v_sose_base                               := parameter.p_codi_base;
    g_soli_serv_clie_dato.sose_refe_dire      := g_soli_serv_clie_dato.sose_refe_dire;
  
    v_clpr_prop_nomb   := g_soli_serv_clie_dato.sose_prop_nomb;
    v_clpr_prop_docu   := g_soli_serv_clie_dato.sose_prop_docu;
    v_clpr_prop_carg   := g_soli_serv_clie_dato.sose_prop_carg;
    v_clpr_prop_nomb_2 := g_soli_serv_clie_dato.sose_prop_nomb_2;
    v_clpr_prop_docu_2 := g_soli_serv_clie_dato.sose_prop_docu_2;
    v_clpr_prop_carg_2 := g_soli_serv_clie_dato.sose_prop_carg_2;
    v_clpr_cont_desc   := g_soli_serv_clie_dato.sose_cont_desc;
    v_clpr_cont_tele   := g_soli_serv_clie_dato.sose_cont_tele;
    v_clpr_cont_emai   := g_soli_serv_clie_dato.sose_cont_emai;
  
    insert into come_soli_serv_clie_dato
      (sose_codi,
       sose_indi_dato,
       sose_desc,
       sose_tipo_pers,
       sose_nomb,
       sose_apel,
       sose_tipo_docu,
       sose_docu,
       sose_esta_civi,
       sose_fech_naci,
       sose_dire,
       sose_tele_part,
       sose_celu,
       sose_mepa_codi,
       sose_naci_codi,
       sose_zona_codi,
       sose_barr_codi,
       sose_ciud_codi,
       sose_dist,
       sose_inmu_prop,
       sose_nume_finc,
       sose_luga_trab,
       sose_tele_trab,
       sose_anti,
       sose_pues_trab,
       sose_nomb_cony,
       sose_tele_cony,
       sose_cedu_cony,
       sose_acti_cony,
       sose_luga_trab_cony,
       sose_sexo,
       sose_email,
       sose_email_fact,
       sose_prof_codi,
       sose_prop_nomb,
       sose_prop_docu,
       sose_prop_carg,
       sose_prop_nomb_2,
       sose_prop_docu_2,
       sose_prop_carg_2,
       sose_cont_desc,
       sose_cont_tele,
       sose_cont_emai,
       sose_base,
       sose_refe_dire,
       sose_barrio_des,
       sose_ubicacion)
    values
      (p_sose_codi,
       p_indi_dato,
       g_soli_serv_clie_dato.sose_desc,
       g_soli_serv_clie_dato.sose_tipo_pers,
       fa_pasa_capital(g_soli_serv_clie_dato.sose_nomb),
       fa_pasa_capital(g_soli_serv_clie_dato.sose_apel),
       g_soli_serv_clie_dato.sose_tipo_docu,
       g_soli_serv_clie_dato.sose_docu,
       g_soli_serv_clie_dato.sose_esta_civi,
       g_soli_serv_clie_dato.sose_fech_naci,
       g_soli_serv_clie_dato.sose_dire,
       g_soli_serv_clie_dato.sose_tele_part,
       g_soli_serv_clie_dato.sose_celu,
       g_soli_serv_clie_dato.sose_mepa_codi,
       g_soli_serv_clie_dato.sose_naci_codi,
       g_soli_serv_clie_dato.sose_zona_codi,
       v_sose_barr_codi,
       v_sose_ciud_codi,
       v_sose_dist,
       v_sose_inmu_prop,
       g_soli_serv_clie_dato.sose_nume_finc,
       g_soli_serv_clie_dato.sose_luga_trab,
       v_sose_tele_trab,
       v_sose_anti,
       v_sose_pues_trab,
       fa_pasa_capital(g_soli_serv_clie_dato.sose_nomb_cony),
       v_sose_tele_cony,
       v_sose_cedu_cony,
       v_sose_acti_cony,
       g_soli_serv_clie_dato.sose_luga_trab_cony,
       v_sose_sexo,
       v_sose_email,
       v_sose_email_fact,
       v_sose_prof_codi,
       v_clpr_prop_nomb,
       v_clpr_prop_docu,
       v_clpr_prop_carg,
       v_clpr_prop_nomb_2,
       v_clpr_prop_docu_2,
       v_clpr_prop_carg_2,
       v_clpr_cont_desc,
       v_clpr_cont_tele,
       v_clpr_cont_emai,
       v_sose_base,
       g_soli_serv_clie_dato.sose_refe_dire,
       g_soli_serv_clie_dato.sose_barrio_des,
       g_soli_serv_clie_dato.sose_ubicacion);
  
    begin
      select count(*)
        into v_cant_dato
        from come_clie_prov_dato
       where clpr_codi = g_come_soli_serv.sose_clpr_codi;
    
      if v_cant_dato = 0 then
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
           clpr_base,
           clpr_sala_trab,
           clpr_firm_cert_trab,
           clpr_dato_conf_trab,
           clpr_dire_trab,
           clpr_ciud_trab,
           clpr_rela_ingr_trab,
           clpr_hora_disp_conf_trab,
           clpr_hora_aten,
           clpr_barr_codi,
           clpr_ciud_codi,
           clpr_esta_civi_cony,
           clpr_naci_codi_cony)
           
        values
          (g_come_soli_serv.sose_clpr_codi,
           nvl(v_sose_inmu_prop, 'N'),
           g_soli_serv_clie_dato.sose_nume_finc,
           g_soli_serv_clie_dato.sose_luga_trab,
           v_sose_tele_trab,
           v_sose_anti,
           v_sose_pues_trab,
           fa_pasa_capital(g_soli_serv_clie_dato.sose_nomb_cony),
           v_sose_tele_cony,
           v_sose_cedu_cony,
           v_sose_acti_cony,
           g_soli_serv_clie_dato.sose_luga_trab_cony,
           v_sose_base,
           null, --clpr_sala_trab,
           null, --clpr_firm_cert_trab,
           null, --clpr_dato_conf_trab,
           null, --clpr_dire_trab,
           null, --clpr_ciud_trab,
           null, --clpr_rela_ingr_trab,
           null, --clpr_hora_disp_conf_trab,
           null, --clpr_hora_aten,
           null, --clpr_barr_codi,
           null, --clpr_ciud_codi,
           v_clpr_esta_civi_cony, --clpr_esta_civi_cony,
           null --clpr_naci_codi_cony
           );
      else
        update come_clie_prov_dato
           set clpr_inmu_prop      = nvl(v_sose_inmu_prop, 'N'),
               clpr_nume_finc      = g_soli_serv_clie_dato.sose_nume_finc,
               clpr_luga_trab      = g_soli_serv_clie_dato.sose_luga_trab,
               clpr_tele_trab      = v_sose_tele_trab,
               clpr_anti           = v_sose_anti,
               clpr_pues_trab      = v_sose_pues_trab,
               clpr_nomb_cony      = fa_pasa_capital(g_soli_serv_clie_dato.sose_nomb_cony),
               clpr_tele_cony      = v_sose_tele_cony,
               clpr_cedu_cony      = v_sose_cedu_cony,
               clpr_acti_cony      = v_sose_acti_cony,
               clpr_luga_trab_cony = g_soli_serv_clie_dato.sose_luga_trab_cony
         where clpr_codi = g_come_soli_serv.sose_clpr_codi;
      end if;
    end;
  
    delete from come_soli_serv_refe where refe_sose_codi = p_sose_codi;
  
    for c in g_cur_ref loop
      if c.nombre_apellido is not null then
      
        v_refe_sose_codi := g_come_soli_serv.sose_codi;
        v_refe_nume_item := c.seq;
        v_refe_indi_dato := 'D';
        v_refe_tipo      := 'P';
        v_refe_desc      := fa_pasa_capital(c.nombre_apellido);
        v_refe_tele      := c.telefono_celular;
      
        insert into come_soli_serv_refe
          (refe_sose_codi,
           refe_nume_item,
           refe_indi_dato,
           refe_tipo,
           refe_desc,
           refe_tele)
        values
          (v_refe_sose_codi,
           v_refe_nume_item,
           v_refe_indi_dato,
           v_refe_tipo,
           v_refe_desc,
           v_refe_tele);
      
        begin
          select count(*)
            into v_cant_refe
            from come_clie_refe
           where clre_clpr_codi = g_come_soli_serv.sose_clpr_codi
             and clre_tipo = 'P'
             and clre_nume_item = v_refe_nume_item;
        
          if v_cant_refe = 0 then
            insert into come_clie_refe
              (clre_clpr_codi,
               clre_nume_item,
               clre_tipo,
               clre_desc,
               clre_tele)
            values
              (g_come_soli_serv.sose_clpr_codi,
               v_refe_nume_item,
               v_refe_tipo,
               v_refe_desc,
               v_refe_tele);
          else
            update come_clie_refe
               set clre_desc = v_refe_desc, clre_tele = v_refe_tele
             where clre_clpr_codi = g_come_soli_serv.sose_clpr_codi
               and clre_tipo = 'P'
               and clre_nume_item = v_refe_nume_item;
          end if;
        end;
      end if;
    end loop;
  end pp_actu_soli_serv_clie_dato;

  procedure pp_actualiza_come_soli_serv is
    --v_indi varchar2(1);
  begin
    
  
    --si no es un cliente nuevo debe actualizar los datos
    if g_come_soli_serv.sose_clpr_codi is not null  then
       --g_come_soli_serv.sose_clpr_codi
     pp_actualiza_datos_cliente ;
    end if;
  
    if w_indi_oper = 'I' or (g_come_soli_serv.sose_codi is null and
       g_come_soli_serv.sose_nume is not null) then
      pp_inse_dato_soli_serv;
    elsif w_indi_oper = 'U' or (g_come_soli_serv.sose_codi is not null and
          g_come_soli_serv.sose_nume is not null) then
      pp_actu_dato_soli_serv(g_come_soli_serv.sose_codi); --actualiza datos de cabecera de solicitud
    end if;
  
    pp_actu_soli_serv_clie_dato(g_come_soli_serv.sose_codi, 'D'); -- actualiza datos de deudor
  
    --   if g_come_soli_serv.sose_tipo = 'N' then
    --    v_indi := 'N';
    --  else
    --    v_indi := 'S';
    --  end if;
  
    pp_actu_soli_serv_cont(g_come_soli_serv.sose_codi, 'H');
    pp_actu_soli_serv_cont(g_come_soli_serv.sose_codi, 'C');
  
  end pp_actualiza_come_soli_serv;

  procedure pp_set_variables (p_cliente in number) as---------------------si se deja

v_extr_clen_nomb varchar2(100);
v_extr_clen_ape varchar2(100);
v_extr_sexo varchar2(100);
v_extr_tipo_doc varchar2(100);
v_extr_clien_docu varchar2(100);
v_extr_esta_civi varchar2(100);
v_extr_fech_naci varchar2(100);
v_extr_naci_codi varchar2(100);
v_extr_email varchar2(100);
v_extr_prof_codi varchar2(100);
v_extr_clien__tele varchar2(100);
v_extr_dire varchar2(2000);
v_extr_tele_part varchar2(100);
v_extr_barr_codi varchar2(100);
v_extr_ciud_codi varchar2(100);
v_extr_dist varchar2(100);
v_extr_luga_trab varchar2(100);
v_extr_tele_trab varchar2(100);
v_extr_anti varchar2(100);
v_extr_pues_trab varchar2(100);
v_extr_nomb_cony varchar2(100);
v_extr_tele_cony varchar2(100);
v_extr_cedu_cony varchar2(100);
v_extr_acti_cony varchar2(100);
v_extr_luga_trab_cony varchar2(100);
v_extr_ubicacion  varchar2(1000);
v_extr_email_fact  varchar2(1000);
v_count  number;  
v_clpr_codigo number;

p_clpr_ruc varchar2(20);
v_extr_cod_barrio number;
v_empleado varchar2(100);
  v_codi_alte varchar2(100);
  begin
    
  begin
  select a.empl_codi
  into v_empleado 
from COME_EMPL a, SEGU_USER b
where empl_codi = user_empl_codi
and b.user_login = fp_user;
exception 
  when others then
    v_empleado := 1;
end;
  
    

      select  extr_clen_nomb,
              extr_clen_ape,
              extr_sexo,
              extr_tipo_doc,
              extr_clien_docu,
              extr_esta_civi,
              extr_fech_naci,
              extr_naci_codi,
              extr_email,
              /*case when extr_prof_codi = 1 then
                'Funcionario'
                when extr_prof_codi = 2 then
                  'Independiente'
                  end*/ extr_prof_codi,
              extr_clien__tele,
              extr_dire,
              extr_tele_part,
              extr_barr_codi,
              extr_ciud_codi,
              extr_dist,
              NULL,--nvl(extr_luga_trab,'Independiente'),
              NULL,--nvl(extr_tele_trab,'--'),
              NULL,--nvl(extr_anti,'--'),
              NULL,--nvl(extr_pues_trab,'--'),
              extr_nomb_cony,
              extr_tele_cony,
              extr_cedu_cony,
              extr_acti_cony,
              extr_luga_trab_cony,
              extr_ubicacion ,
              extr_email_fact,
              extr_cod_barrio
       
         into v_extr_clen_nomb,
              v_extr_clen_ape,
              v_extr_sexo,
              v_extr_tipo_doc,
              v_extr_clien_docu,
              v_extr_esta_civi,
              v_extr_fech_naci,
              v_extr_naci_codi,
              v_extr_email,
              v_extr_prof_codi,
              v_extr_clien__tele,
              v_extr_dire,
              v_extr_tele_part,
              v_extr_barr_codi,
              v_extr_ciud_codi,
              v_extr_dist,
              v_extr_luga_trab,
              v_extr_tele_trab,
              v_extr_anti,
              v_extr_pues_trab,
              v_extr_nomb_cony,
              v_extr_tele_cony,
              v_extr_cedu_cony,
              v_extr_acti_cony,
              v_extr_luga_trab_cony,
              v_extr_ubicacion ,
              v_extr_email_fact,
              v_extr_cod_barrio
         from extr_cliente
        where extr_clen_codi = p_cliente;
        
      p_clpr_ruc:=  v_extr_clien_docu;
  
     --------------validamos si el cliente existe 
     begin
         select clpr_codi, s.clpr_codi_alte
        into v_clpr_codigo, v_codi_alte
          from come_clie_prov s
         where (clpr_ruc  = p_clpr_ruc
            or substr(p_clpr_ruc,1, instr(p_clpr_ruc,'-',1)-1) = substr(clpr_ruc,1, instr(clpr_ruc,'-',1)-1)
            or p_clpr_ruc = substr(clpr_ruc,1, instr(clpr_ruc,'-',1)-1)
            or substr(p_clpr_ruc,1, instr(p_clpr_ruc,'-',1)-1) = clpr_ruc)
           and clpr_indi_clie_prov = 'C';
     exception 
       when no_data_found  then
         v_clpr_codigo := null;
       end;
     --------------   
    
           
        
    g_come_soli_serv.sose_codi                := null;
    g_come_soli_serv.sose_clpr_codi           := v_clpr_codigo;
    g_come_soli_serv.sose_nume                := null;
    g_come_soli_serv.sose_desc                := null;
    g_come_soli_serv.sose_fech_emis           := trunc(sysdate);
    g_come_soli_serv.sose_mone_codi           := 1; ---valor estatico
    g_come_soli_serv.sose_impo_mone           := null;
    g_come_soli_serv.sose_impo_mmnn           := null;
    g_come_soli_serv.sose_tasa_mone           := null;
    g_come_soli_serv.sose_sucu_codi           := null;
    g_come_soli_serv.sose_movi_codi           := null;
    g_come_soli_serv.sose_obse                := '1- LOS PRECIOS DETALLADOS INCLUYEN I.V.A. 2- EL FIRMANTE ACEPTA LOS T?RMINOS Y CONDICIONES ESTABLECIDOS AL DORSO DE ESTA SOLICITUD DE SERVICIO';
    g_come_soli_serv.sose_user_regi           := gen_user;
    g_come_soli_serv.sose_fech_regi           := sysdate;
    g_come_soli_serv.sose_user_modi           := null;
    g_come_soli_serv.sose_fech_modi           := null;
    g_come_soli_serv.sose_esta                := 'P';--pendiente
    g_come_soli_serv.sose_clpr_codi_aseg      := null;
    g_come_soli_serv.sose_indi_timo           := 'F';--por defecto estaba f
    g_come_soli_serv.sose_tipo                := 'I';--solo instalacion
    g_come_soli_serv.sose_nume_poli           := null;
    g_come_soli_serv.sose_orte_codi           := null;
    g_come_soli_serv.sose_calc_gran           := null;
    g_come_soli_serv.sose_calc_pequ           := null;
    g_come_soli_serv.sose_ning_calc           := null;
    g_come_soli_serv.sose_indi_moni           := null;
    g_come_soli_serv.sose_indi_nexo_recu      := null;
    g_come_soli_serv.sose_indi_para_moto      := null;
    g_come_soli_serv.sose_indi_boto_esta      := null;
    g_come_soli_serv.sose_indi_acce_aweb      := null;
    g_come_soli_serv.sose_indi_roam           := null;
    g_come_soli_serv.sose_tipo_roam           := null;
    g_come_soli_serv.sose_indi_boto_pani      := null;
    g_come_soli_serv.sose_indi_mant_equi      := null;
    g_come_soli_serv.sose_indi_cort_corr_auto := null;
    g_come_soli_serv.sose_indi_avis_poli      := null;
    g_come_soli_serv.sose_indi_auto_dete_vehi := null;
    g_come_soli_serv.sose_inst_espe           := null;
    g_come_soli_serv.sose_prec_unit           := null;
    g_come_soli_serv.sose_valo_tota           := null;
    g_come_soli_serv.sose_fech_vige           := null;
    g_come_soli_serv.sose_dura_cont           := 12;
    g_come_soli_serv.sose_cant_movi           := 1;--v('P47_SOSE_CANT_MOVI');
    g_come_soli_serv.sose_equi_prec           := null;
    g_come_soli_serv.sose_tipo_fact           := 'M';
    g_come_soli_serv.sose_entr_inic           := null;
    g_come_soli_serv.sose_impu_codi           := null;
    g_come_soli_serv.sose_cost_mone_pres      := null;
    g_come_soli_serv.sose_impo_mone_fact      := null;
    g_come_soli_serv.sose_impo_mone_fact_ii   := null;
    g_come_soli_serv.sose_porc_cost           := null;
    g_come_soli_serv.sose_tipo_serv           := 'S';
    g_come_soli_serv.sose_clco_codi           := null;
    g_come_soli_serv.sose_fech_liqu           := null;
    g_come_soli_serv.sose_asie_codi_liqu      := null;
    g_come_soli_serv.sose_cost_mone_pres_ii   := null;
    g_come_soli_serv.sose_nume_orde_serv      := null;
    g_come_soli_serv.sose_clpr_codi_orig      := null;
    g_come_soli_serv.sose_sucu_nume_item_orig := null;
    g_come_soli_serv.sose_roam_fech_inic_vige := null;
    g_come_soli_serv.sose_roam_fech_fini_vige := null;
    g_come_soli_serv.sose_sucu_nume_item      := null;
    g_come_soli_serv.sose_fech_inic_vige      := null;
    g_come_soli_serv.sose_codi_ante           := null;
    g_come_soli_serv.sose_tipo_acce           := null;
    g_come_soli_serv.sose_indi_sens_tapa_tanq := null;
    g_come_soli_serv.sose_indi_sens_comb      := null;
    g_come_soli_serv.sose_indi_sens_temp      := null;
    g_come_soli_serv.sose_indi_aper_puer      := null;
    g_come_soli_serv.sose_clav_conf           := null;
    g_come_soli_serv.sose_corr_info_even      := null;
    g_come_soli_serv.sose_esta_veri           := 'P';
    g_come_soli_serv.sose_dire_obse           := null;
    g_come_soli_serv.sose_fech_auto           := null;
    g_come_soli_serv.sose_user_auto           := null;
    g_come_soli_serv.sose_codi_padr           := null;
    g_come_soli_serv.sose_fech_inic_poli      := null;
    g_come_soli_serv.sose_fech_fini_poli      := null;
    g_come_soli_serv.sose_indi_migr           := 'S';--por que se migra de otro lado
    g_come_soli_serv.sose_indi_reno           := null;
    g_come_soli_serv.sose_orcl_codi           := null;
    g_come_soli_serv.sose_base                := parameter.p_codi_base;
    g_come_soli_serv.sose_empr_codi           := parameter.p_empr_codi;

    --v('P47_SOSE_EMPR_CODI');
  
   if v_extr_tipo_doc = 1 then
     v_extr_tipo_doc :='CI';
   else
     v_extr_tipo_doc :='RUC';
   end if;

    ----------**************************
    g_soli_serv_clie_dato.sose_codi           := null;
    g_soli_serv_clie_dato.sose_indi_dato      := 'D';
    g_soli_serv_clie_dato.sose_nomb           := v_extr_clen_nomb;
    g_soli_serv_clie_dato.sose_apel           := v_extr_clen_ape;
    g_soli_serv_clie_dato.sose_tipo_docu      := v_extr_tipo_doc;---decode ci, ruc
    g_soli_serv_clie_dato.sose_docu           := v_extr_clien_docu;
    g_soli_serv_clie_dato.sose_esta_civi      := v_extr_esta_civi;
    g_soli_serv_clie_dato.sose_fech_naci      := v_extr_fech_naci;
    g_soli_serv_clie_dato.sose_dire           := v_extr_dire;
    g_soli_serv_clie_dato.sose_tele_part      := v_extr_tele_part;
    g_soli_serv_clie_dato.sose_naci_codi      := v_extr_naci_codi;
    g_soli_serv_clie_dato.sose_zona_codi      := null;
    g_soli_serv_clie_dato.sose_ubicacion      := v_extr_ubicacion;

  
    g_soli_serv_clie_dato.sose_barr_codi      := v_extr_cod_barrio;
    g_soli_serv_clie_dato.sose_barrio_des      := v_extr_barr_codi;
    g_soli_serv_clie_dato.sose_ciud_codi      := v_extr_ciud_codi;
    g_soli_serv_clie_dato.sose_dist           := v_extr_dist;
    g_soli_serv_clie_dato.sose_inmu_prop      := null;
    g_soli_serv_clie_dato.sose_nume_finc      := null;
    g_soli_serv_clie_dato.sose_luga_trab      := v_extr_luga_trab;
    g_soli_serv_clie_dato.sose_tele_trab      := v_extr_tele_trab;
    g_soli_serv_clie_dato.sose_anti           := v_extr_anti;
    g_soli_serv_clie_dato.sose_pues_trab      := v_extr_pues_trab;
    g_soli_serv_clie_dato.sose_nomb_cony      := v_extr_nomb_cony;
    g_soli_serv_clie_dato.sose_tele_cony      := v_extr_tele_cony;
    g_soli_serv_clie_dato.sose_cedu_cony      := v_extr_cedu_cony;
    g_soli_serv_clie_dato.sose_acti_cony      := v_extr_acti_cony;
    g_soli_serv_clie_dato.sose_luga_trab_cony := v_extr_luga_trab_cony;
    g_soli_serv_clie_dato.sose_sexo           := v_extr_sexo;
    g_soli_serv_clie_dato.sose_email          := v_extr_email;
      
    g_soli_serv_clie_dato.sose_prof_codi      := v_extr_prof_codi;---decode (2 'Independiente, 'Funcionario')
    
    g_soli_serv_clie_dato.sose_prop_nomb      := null;
    g_soli_serv_clie_dato.sose_prop_docu      := null;
    g_soli_serv_clie_dato.sose_prop_nomb_2    := null;
    g_soli_serv_clie_dato.sose_prop_docu_2    := null;
    g_soli_serv_clie_dato.sose_prop_carg      := null;
    g_soli_serv_clie_dato.sose_prop_carg_2    := null;
    g_soli_serv_clie_dato.sose_tipo_pers      := fp_asignar_tipo_persona(v_extr_clien_docu);--'F';--fisica
    g_soli_serv_clie_dato.sose_mepa_codi      := 3;--Red de Cobranzas Externas
    g_soli_serv_clie_dato.sose_celu           := null;
    g_soli_serv_clie_dato.sose_cont_desc      := null;
    g_soli_serv_clie_dato.sose_cont_tele      := null;
    g_soli_serv_clie_dato.sose_cont_emai      := null;
    g_soli_serv_clie_dato.sose_email_fact     := v_extr_email_fact;
    g_soli_serv_clie_dato.sose_refe_dire      := null;
    g_soli_serv_clie_dato.sose_base           := parameter.p_codi_base;
    --g_soli_serv_clie_dato.sose_desc := v('P47_SOSE_DESC');
    g_soli_serv_clie_dato.sose_desc := g_soli_serv_clie_dato.sose_nomb || ' ' ||
                                       g_soli_serv_clie_dato.sose_apel;
    
    
     
    ------*******************************
    --g_borrar_ref               := v('P47_BORRAR_REF');
    g_s_sose_estado       := 'P';
    g_sose_nume_padr      := null;
    g_clpr_codi_alte_orig := null;
    --g_clpr_codi_alte_orig_desc := v('P47_CLPR_CODI_ALTE_ORIG_DESC');
    g_sucu_nume_item_orig := null;
    g_clpr_codi_alte      :=v_codi_alte;-- null;
    --g_clpr_codi_alte_desc      := v('P47_CLPR_CODI_ALTE_DESC');
    g_sucu_nume_item := null;
    g_mepa_codi_alte := 3;
    --g_sose_mepa_codi_desc      := v('P47_SOSE_MEPA_CODI_DESC');
    --g_sose_empl_desc           := v('P47_SOSE_EMPL_DESC');

   g_naci_codi_alte  := v_extr_naci_codi;
    g_zona_codi_alte  := null;
    g_prof_codi_alte  := v_extr_prof_codi;
    g_ciud_codi_alte  := v_extr_ciud_codi;
    g_clas1_codi_alte := 1;
   -- g_barr_codi_alte  := v_extr_barr_codi;
  
  
      w_indi_oper := 'I';
    ---*******
    
    pp_cliente_codi(g_clpr_codi_alte, g_come_soli_serv.sose_clpr_codi);
  
    pp_cliente_codi(g_clpr_codi_alte_orig,
                    g_come_soli_serv.sose_clpr_codi_orig);
  
    pp_come_medi_pago_codi(g_mepa_codi_alte,
                           g_soli_serv_clie_dato.sose_mepa_codi);
  
    pp_nacionalidad_codi(g_naci_codi_alte,
                         g_soli_serv_clie_dato.sose_naci_codi);
  
    pp_clie_clas1_codi(g_clas1_codi_alte, g_clpr_clie_clas1_codi);
  
    pp_ciudad_codi(g_ciud_codi_alte, g_soli_serv_clie_dato.sose_ciud_codi);
  
    pp_zona_cli_codi(g_zona_codi_alte,
                     g_soli_serv_clie_dato.sose_zona_codi);
  
   -- pp_barrio_codi(g_barr_codi_alte, g_soli_serv_clie_dato.sose_barr_codi);
  
    pp_profesion_codi(g_prof_codi_alte,
                      g_soli_serv_clie_dato.sose_prof_codi);
 
    pp_cliente_codi(i_clpr_codi_alte => null,--v('P47_CLPR_CODI_ALTE_REFE'),
                    o_sose_clpr_codi => g_come_soli_serv.sose_clpr_codi_refe);
  
    -- v('P47_SOSE_CLPR_CODI_REFE');
 
  
  end pp_set_variables;

  procedure pp_actualizar_registro(p_cliente in number) is
    salir exception;
    v_sose_codi number;
  begin
  
    pp_set_variables(p_cliente);
  
    
    if g_come_soli_serv.sose_nume is null then
      pp_carga_secu(g_come_soli_serv.sose_nume);
      pp_veri_nume(g_come_soli_serv.sose_nume);
      --g_come_soli_serv. sose_nume_orig := g_come_soli_serv.sose_nume;
    end if;
  
    --  g_clas1_codi_alte := v('P47_CLAS1_CODI_ALTE');
  
    pp_validaciones;
  
    if w_indi_oper = 'I' then
      pp_veri_soli_serv;
    end if;
  
    pp_actualiza_come_soli_serv;
  
    parameter.p_sose_codi_actu := g_come_soli_serv.sose_codi;
  
    if w_indi_oper = 'I' then
      pp_actu_secu;
      pp_generar_mensaje;
    end if;
  
    v_sose_codi                              := parameter.p_sose_codi_actu;
    parameter.p_sose_codi_actu               := v_sose_codi;
    apex_application.g_print_success_message := 'Solicitud :' ||
                                                g_come_soli_serv.sose_nume ||
                                                ' actualizado correctamente';
  end pp_actualizar_registro;

/*  procedure pp_borrar_registro is
    salir exception;
    --v_message varchar(70) := '?Realmente desea Borrar la Solicitud?';
    --v_count   number(20);
  begin
  
    pp_set_variables;
  
    pp_valida_borrado;
  
    delete from come_soli_serv_fact_deta
     where sofa_sose_codi = g_come_soli_serv.sose_codi;
    delete from come_soli_serv_clie_dato
     where sose_codi = g_come_soli_serv.sose_codi;
    delete from come_soli_serv_deta
     where deta_sose_codi = g_come_soli_serv.sose_codi;
    delete from come_soli_serv_vehi
     where vehi_sose_codi = g_come_soli_serv.sose_codi;
    delete from come_soli_serv_cont
     where cont_sose_codi = g_come_soli_serv.sose_codi;
    delete from come_soli_serv_refe
     where refe_sose_codi = g_come_soli_serv.sose_codi;
  
    delete from come_soli_serv
     where sose_codi = g_come_soli_serv.sose_codi;
  
    if g_come_soli_serv.sose_tipo = 'N' then
      update come_soli_serv
         set sose_indi_reno = null
       where sose_nume = g_come_soli_serv.sose_nume
         and sose_codi =
             (select max(sose_codi)
                from come_soli_serv
               where sose_nume = g_come_soli_serv.sose_nume
                 and sose_codi <> g_come_soli_serv.sose_codi);
    end if;
  
    apex_application.g_print_success_message := 'Registro eliminado.';
  
  exception
    when salir then
      null;
  end pp_borrar_registro;*/

  procedure pp_carga_dato_clie(i_clpr_codi_alte      in number,
                               o_zona_codi_alte      out varchar2,
                               o_sose_tipo_pers      out varchar2,
                               o_sose_tipo_docu      out varchar2,
                               o_sose_tele_trab      out varchar2,
                               o_sose_tele_part      out varchar2,
                               o_sose_tele_cony      out varchar2,
                               o_sose_refe_dire      out varchar2,
                               o_sose_pues_trab      out varchar2,
                               o_sose_prop_nomb_2    out varchar2,
                               o_sose_prop_nomb      out varchar2,
                               o_sose_prop_docu_2    out varchar2,
                               o_sose_prop_docu      out varchar2,
                               o_sose_prop_carg_2    out varchar2,
                               o_sose_prop_carg      out varchar2,
                               o_sose_nomb_cony      out varchar2,
                               o_sose_nomb           out varchar2,
                               o_sose_luga_trab_cony out varchar2,
                               o_sose_luga_trab      out varchar2,
                               o_sose_esta_civi      out varchar2,
                               o_sose_email_fact     out varchar2,
                               o_sose_email          out varchar2,
                               o_sose_docu           out varchar2,
                               o_sose_dire           out varchar2,
                               o_sose_desc           out varchar2,
                               o_sose_cont_tele      out varchar2,
                               o_sose_cont_emai      out varchar2,
                               o_sose_cont_desc      out varchar2,
                               o_sose_celu           out varchar2,
                               o_sose_cedu_cony      out varchar2,
                               o_sose_apel           out varchar2,
                               o_sose_anti           out varchar2,
                               o_sose_acti_cony      out varchar2,
                               o_sose_fech_naci      out date,
                               o_naci_codi_alte      out varchar2,
                               o_mepa_codi_alte      out varchar2,
                               o_clas1_codi_alte     out varchar2,
                               o_ciud_codi_alte      out varchar2,
                               o_barr_codi_alte      out varchar2) is
  
    v_clpr come_clie_prov%rowtype;
    v_dato come_clie_prov_dato%rowtype;
  
    cursor cur_ref(ic_clpr_codi in number) is
      select clre_nume_item,
             'D' refe_indi_dato,
             clre_tipo,
             clre_desc,
             clre_tele
        from come_clie_refe
       where clre_tipo = 'P'
         and clre_clpr_codi = ic_clpr_codi
       order by clre_nume_item;
  
  begin
  
    if i_clpr_codi_alte is null then
      raise e_sin_parametro;
    end if;
    /*clpr_desc,
    
    clpr_tipo_pers,
    substr(clpr_nomb, 1, 40) clpr_nomb,
    substr(clpr_apel, 1, 40) clpr_apel,
    nvl(clpr_tipo_docu, 'CI') clpr_tipo_docu,
    decode(clpr_tipo_docu,
           'CI',
           nvl(clpr_docu, clpr_ruc),
           nvl(clpr_ruc, clpr_docu)) clpr_docu,*/
  
    select clpr.*
      into v_clpr
      from come_clie_prov clpr
     where clpr.clpr_codi_alte = i_clpr_codi_alte
       and clpr.clpr_indi_clie_prov = 'C';
  
    begin
      select dato.*
        into v_dato
        from come_clie_prov_dato dato
       where dato.clpr_codi = v_clpr.clpr_codi;
    exception
      when no_data_found then
        null;
    end;
  
    if v_clpr.clpr_desc is null then
      o_sose_desc := v_clpr.clpr_desc;
    end if;
  
    if v_clpr.clpr_nomb is null then
      o_sose_nomb := substr(v_clpr.clpr_desc,
                            1,
                            instr(v_clpr.clpr_desc, ' ', 1) - 1) || ' ' ||
                     substr(v_clpr.clpr_desc,
                            instr(v_clpr.clpr_desc, ' ', 1) + 1,
                            instr(v_clpr.clpr_desc,
                                  ' ',
                                  instr(v_clpr.clpr_desc, ' ', 1) + 1) -
                            (instr(v_clpr.clpr_desc, ' ', 1) + 1));
    else
      o_sose_nomb := v_clpr.clpr_nomb;
    end if;
  
    if v_clpr.clpr_apel is null then
      o_sose_apel := substr(v_clpr.clpr_desc,
                            instr(v_clpr.clpr_desc,
                                  ' ',
                                  instr(v_clpr.clpr_desc, ' ', 1) + 1) + 1,
                            40);
    else
      o_sose_apel := v_clpr.clpr_apel;
    end if;
  
    if v_clpr.clpr_mepa_codi is not null then
      pp_come_medi_pago_alte(v_clpr.clpr_mepa_codi, o_mepa_codi_alte);
    end if;
  
    if v_clpr.clpr_naci_codi is not null then
      pp_nacionalidad_alte(v_clpr.clpr_naci_codi, o_naci_codi_alte);
    
    end if;
  
    if v_clpr.clpr_zona_codi is not null then
      pp_zona_cli_alte(v_clpr.clpr_zona_codi, o_zona_codi_alte);
    
    end if;
  
    if v_clpr.clpr_barr_codi is not null then
      pp_barrio_alte(v_clpr.clpr_barr_codi, o_barr_codi_alte);
    
    end if;
  
    if v_clpr.clpr_ciud_codi is not null then
      pp_ciudad_alte(v_clpr.clpr_ciud_codi, o_ciud_codi_alte);
    
    end if;
  
    if v_clpr.clpr_clie_clas1_codi is not null then
      pp_clie_clas1_alte(v_clpr.clpr_clie_clas1_codi, o_clas1_codi_alte);
    
    end if;
  
    o_sose_tipo_pers      := v_clpr.clpr_tipo_pers;
    o_sose_tipo_docu      := v_clpr.clpr_tipo_docu;
    o_sose_docu           := v_clpr.clpr_docu;
    o_sose_esta_civi      := v_clpr.clpr_esta_civi;
    o_sose_fech_naci      := to_char(v_clpr.clpr_fech_naci, 'dd-mm-yyyy');
    o_sose_dire           := v_clpr.clpr_dire;
    o_sose_refe_dire      := v_clpr.clpr_refe_dire;
    o_sose_tele_part      := v_clpr.clpr_tele;
    o_sose_celu           := v_clpr.clpr_celu;
    o_sose_email          := v_clpr.clpr_email;
    o_sose_email_fact     := v_clpr.clpr_email_fact;
    o_sose_prop_nomb      := v_clpr.clpr_prop_nomb;
    o_sose_prop_docu      := v_clpr.clpr_prop_docu;
    o_sose_prop_carg      := v_clpr.clpr_prop_carg;
    o_sose_prop_nomb_2    := v_clpr.clpr_prop_nomb_2;
    o_sose_prop_docu_2    := v_clpr.clpr_prop_docu_2;
    o_sose_prop_carg_2    := v_clpr.clpr_prop_carg_2;
    o_sose_cont_desc      := v_clpr.clpr_cont_desc;
    o_sose_cont_tele      := v_clpr.clpr_cont_tele;
    o_sose_cont_emai      := v_clpr.clpr_cont_emai;
    o_sose_nomb_cony      := v_dato.clpr_nomb_cony;
    o_sose_tele_cony      := v_dato.clpr_tele_cony;
    o_sose_cedu_cony      := v_dato.clpr_cedu_cony;
    o_sose_acti_cony      := v_dato.clpr_acti_cony;
    o_sose_luga_trab_cony := v_dato.clpr_luga_trab_cony;
    o_sose_luga_trab      := v_dato.clpr_luga_trab;
    o_sose_tele_trab      := v_dato.clpr_tele_trab;
    o_sose_pues_trab      := v_dato.clpr_pues_trab;
    o_sose_anti           := v_dato.clpr_anti;
  
    for c in cur_ref(ic_clpr_codi => v_clpr.clpr_codi) loop
      pp_add_referencia(i_ref_desc => c.clre_desc,
                        i_ref_tel  => c.clre_tele);
    end loop;
  
  exception
    when e_sin_parametro then
      null;
    when others then
      raise_application_error(-20010, sqlerrm);
  end pp_carga_dato_clie;

  function fp_asignar_tipo_persona(i_nro_docu in varchar2) return varchar2 is
    v_return   varchar2(2) := 'F';
    v_nro_docu number;
  begin
    v_nro_docu := regexp_replace(i_nro_docu, '[^0-9]');
  
    if v_nro_docu > 800000000 then
      v_return := 'J';
    end if;
    return v_return;
  end fp_asignar_tipo_persona;
  
  
  
  
  procedure pp_nueva_solicitud (p_cod_req in number,
                                p_cod_cli in number)is
   
  
  v_cant_vehi number;
  v_clpr_codigo number;
  v_sose_codigo number;
  p_clpr_ruc varchar2(60);
  v_sose_nume number;
  v_cli_completo number;
  v_vehi_completo number;
  begin
  
  -------------revisamos si todos los datos estan cargados
  select case when t.extr_clen_nomb is null or
        t.extr_clien_docu is null or
        t.extr_clien__tele is null or
        t.extr_esta_civi is null or
        t.extr_fech_naci is null or
        t.extr_dire is null or
        t.extr_tele_part is null or
        t.extr_naci_codi is null or
        t.extr_barr_codi is null or
        t.extr_ciud_codi is null or
        t.extr_sexo is null or
        t.extr_email is null or
        t.extr_email_fact is null or
        t.extr_clen_ape is null or
        t.extr_tipo_doc is null or
        t.extr_ubicacion is null or
        t.extr_ciudad is null or
        t.extr_cod_barrio is null then
           1
        else
           0 
        end codigo
  into v_cli_completo
  from extr_cliente t
 where t.extr_clen_codi = p_cod_cli;

  if v_cli_completo = 1 then
    raise_application_error (-20001, 'Falta completar los datos del CLIENTE');
  end if;
  --------------------------
        select sum(case when t.extr_vehi_codigo is null or
             t.extr_vehi_desc is null or
             t.extr_vehi_item is null or
             t.extr_vehi_tipo is null or
             t.extr_vehi_pro is null or
             t.extr_vehi_comp is null or
             t.extr_vehi_clien is null or
             t.extr_vehi_rege is null or
             t.extr_vehi_ciud is null or
             t.extr_vehi_ubic is null or
             t.extr_vehi_marc is null or
             t.extr_vehi_mode is null or
             t.extr_vehi_anho is null or
             t.extr_vehi_colo is null or
             t.extr_vehi_chas is null or
             t.extr_vehi_pate is null or
             t.extr_vehi_indi_grua is null or
             t.extr_indi_prom_pror is null or
             t.extr_precio is null or
             t.extr_ind_chap_prov is null or
             t.extr_vehi_ciud_codi  is null then
             1
             else
               0
             end)  vehi
        into v_vehi_completo
      from extr_vehi t
      where t.extr_vehi_clien = p_cod_cli
      and t.extr_vehi_rege = p_cod_req;

   if v_vehi_completo = 1 then
    raise_application_error (-20001, 'Falta completar los datos del VEHICULO');
  end if;
  
    --------------------------
     select extr_clien_docu
       into p_clpr_ruc
       from extr_cliente 
      where extr_clen_codi = p_cod_cli;
  ----------verificamos si el cliente existe 
  
  

     begin
     select clpr_codi
     into v_clpr_codigo
      from come_clie_prov
     where (clpr_ruc  = p_clpr_ruc
        or substr(p_clpr_ruc,1, instr(p_clpr_ruc,'-',1)-1) = substr(clpr_ruc,1, instr(clpr_ruc,'-',1)-1)
        or p_clpr_ruc = substr(clpr_ruc,1, instr(clpr_ruc,'-',1)-1)
        or substr(p_clpr_ruc,1, instr(p_clpr_ruc,'-',1)-1) = clpr_ruc)
       and clpr_indi_clie_prov = 'C';
     exception 
       when no_data_found then
         v_clpr_codigo := null;
         when others then
         v_clpr_codigo := null;
       end;
 

  --------------si existe cliente verificamos la solicitud ---------------
  if v_clpr_codigo is not null then
    
  ------para saber si esta activo revisamos si por lo menos tiene un movil instalado
      select count(*)
        into v_cant_vehi
        from COME_VEHI a
       where a.vehi_clpr_codi = v_clpr_codigo
         and vehi_esta = 'I';
      
        if v_cant_vehi >= 0 then
          begin
          select max(sose_codi), max(sose_nume)
            into v_sose_codigo, v_sose_nume
            from come_soli_serv 
             where sose_clpr_codi = v_clpr_codigo
               and sose_tipo = 'I';
            exception when no_data_found then
              v_sose_codigo := null;
              when others  then
               v_sose_codigo := null;
            end;  
        end if;
  end if;
  --raise_application_error (-20001,v_sose_codigo);
  
    apex_collection.create_or_truncate_collection(p_collection_name => 'SOL_REF');

    apex_collection.create_or_truncate_collection(p_collection_name => 'ANEXO_CONC');

    apex_collection.create_or_truncate_collection(p_collection_name => 'ANEXO_TIPO_DOC');
   
    for x in (select t.refe_registro,
                       t.refe_cliente,
                       t.refe_codigo,
                       t.refe_nombre,
                       t.refe_telefono
                from extr_referencia t
                where refe_cliente = p_cod_cli)loop 
      
    I020271_A.PP_ADD_REFERENCIA(I_REF_DESC => x.refe_nombre,
                            I_REF_TEL  => x.refe_telefono);
                            
                        
  
     end loop;
     
     if v_sose_codigo is null then
   
         I020271_A.PP_ACTUALIZAR_REGISTRO(p_cod_cli);
     end if;

-------------------------------anexo 
begin
 
  I020271_A.pp_add_anex_det(p_registro => p_cod_req,
                            p_cliente => p_cod_cli);
end;
  

  if v_sose_codigo is not null then
     v_sose_codigo := v_sose_codigo;
     v_sose_nume := v_sose_nume;
  else
    v_sose_codigo :=g_come_soli_serv.sose_codi;
    v_sose_nume :=g_come_soli_serv.sose_nume;
  end if;
    
     I020271_A.pp_actualizar_registro_anex(p_sose_codi => v_sose_codigo);
 
   
  update extr_rege_link
     set regi_expo_soli = 'S',
         regi_expo_fec  = sysdate,
         REGI_EXPO_SOL  = v_sose_nume,--g_come_soli_serv.sose_nume,
         REGI_EXPO_ANEX = g_anex.anex_codi,
         REGI_SOLICITUD = v_sose_codigo
   where regi_codigo = p_cod_req;
   
  -- raise_application_error(-20001,'siii');
  end pp_nueva_solicitud;



  procedure pp_actualizar_registro_anex (p_sose_codi in number) is
    --v_count number := 0;
  begin
  
    pp_set_variables_anex(p_sose_codi);
  
    pp_validaciones_anex;
  
    -- 
  
    if g_anex.anex_codi is null then
    --  raise_application_error (-20001,'bla bala bla');
      g_anex.anex_base      := parameter.p_codi_base;
      g_anex.anex_user_regi := gen_user;
      g_anex.anex_fech_regi := sysdate;
      select nvl(max(anex_codi), 0) + 1
      into g_anex.anex_codi
      from come_soli_serv_anex;
     
    end if;
  --  raise_application_error (-20001,'kk');
    pp_actualiza_anex(g_anex.anex_codi);
  
    pp_actualiza_deta(g_anex.anex_codi);
  

    --message('registro no actualizado.');
  
    apex_application.g_print_success_message := 'Contrato :' ||
                                                g_sose.sose_nume ||
                                                ' anexo:' ||
                                                g_anex.anex_nume ||
                                                ' ,actualizado correctamente';
  end pp_actualizar_registro_anex;
  
  
 procedure pp_set_variables_anex (p_sose_codi in number)is
   
 v_empleado number;
  begin
    
  
      begin
        select a.empl_codi
          into v_empleado
          from COME_EMPL a, SEGU_USER b
         where empl_codi = user_empl_codi
           and b.user_login = fp_user;
      exception
        when others then
          v_empleado := 1;
      end;
        
  
    g_anex.anex_empr_codi := parameter.p_empr_codi; --v('p61_anex_empr_codi');
    g_anex.anex_sose_codi := p_sose_codi;
  
  
--  se tiene que revisar si ya tuvo anexo anterior
    g_anex.anex_nume_refe := NULL;--v('P61_ANEX_NUME_REFE');
    
    g_anex.anex_dura_cont := 12;--v('P61_ANEX_DURA_CONT');
    g_anex.anex_codi      := null;--v('P61_ANEX_CODI');
  
    g_anex.anex_mone_codi := 1; ---guaranies
    g_anex.anex_nume_poli := null;
    g_anex.anex_tipo      := 'I';
  
    g_anex.anex_nume_orde_serv := null;
  
    g_anex.anex_user_regi           := gen_user;
    g_anex.anex_equi_prec           := 350;
    g_anex.anex_user_modi           := null;
    g_anex.anex_user_auto           := null;
    g_anex.anex_fech_fini_poli      := null;
    g_anex.anex_base                := 1;
    g_anex.anex_cant_cuot_modu      := null;
    g_anex.anex_indi_fact_impo_unic := null;
    g_anex.anex_indi_reno           := null;
  
    g_anex.anex_fech_inst := null;
    
    g_anex.anex_fech_regi      := sysdate;
    g_anex.anex_fech_modi      := null;
    g_anex.anex_fech_auto      := null;
    g_anex.anex_fech_emis      := trunc(sysdate);
    g_anex.anex_fech_vige      := null;
    g_anex.anex_fech_inic_vige := trunc(sysdate);
    g_anex.anex_fech_venc      := trunc(sysdate)+365;
    g_anex.anex_fech_inic_poli := null;
  
    g_anex.anex_esta := 'P';
  
  
  
   g_anex.anex_auto_ci   := null;
   g_anex.anex_auto_nombre := null;
   g_anex.anex_auto_fech_nac := null;
   g_anex.anex_auto_fech_vto := null;
   g_anex.anex_auto_nac  := null;
   g_anex.anex_esta_civil  := null;
   g_anex.anex_empl_codi  := v_empleado;
    --  raise_application_error(-20010, g_anex.anex_esta);
  
    -- g_anex.anex_cant_movi      := v('p61_anex_cant_movi');
  
    select count(*) cantidad_movil,
           sum(c004) deta_prec_unit,
           sum(c005) deta_impo_mone
      into g_anex.anex_cant_movi,
           g_anex.anex_prec_unit,
           g_anex.anex_impo_mone
      from apex_collections a
     where collection_name = 'ANEXO_CONC';
  
    if g_anex.anex_prec_unit > 0 then
      g_anex.anex_entr_inic := g_anex.anex_prec_unit;
    else
      g_anex.anex_prec_unit := 0;
    end if;
  
    g_anex.anex_aglu_cicl := 'N';
  
    select c.cifa_codi,
           c.cifa_tipo,
           c.cifa_dia_fact,
           c.cifa_dia_desd,
           c.cifa_dia_hast
      into g_anex.anex_cifa_codi,
           g_anex.anex_cifa_tipo,
           g_anex.anex_cifa_dia_fact,
           g_anex.anex_cifa_dia_desd,
           g_anex.anex_cifa_dia_hast
      from come_cicl_fact c
     where ltrim(ltrim(cifa_nume)) = 3 --- por defecto 3
       and cifa_empr_codi = 1;
  
  
    select *
      into g_sose
      from come_soli_serv a
     where a.sose_codi = g_anex.anex_sose_codi;
  
    select *
      into g_mone
      from come_mone t
     where t.mone_codi = g_anex.anex_mone_codi;
  
    pack_anex_cont.pp_busca_tasa_mone(i_mone_codi => g_anex.anex_mone_codi,
                                 i_coti_fech => g_anex.anex_fech_emis,
                                 o_mone_coti => g_anex.anex_tasa_mone,
                                 i_tica_codi => 2);
  
    g_anex.anex_nume := null;--v('P61_ANEX_NUME');
  
    if g_anex.anex_nume is null then

            begin
              select nvl(max(anex_nume), 0) + 1
                into g_anex.anex_nume
                from come_soli_serv_anex
               where anex_empr_codi = 1
                 and anex_sose_codi = g_anex.anex_sose_codi;
           
            exception
              when others then
                raise_application_error(-20010, 'Error en generar numero anexo');
            end ;
    
    
    end if;
  end pp_set_variables_anex; 
  
    procedure pp_validaciones_anex is
  
    v_cant_movi number;
  
  begin
 if nvl(g_anex.anex_fech_emis, sysdate) not between parameter.p_fech_inic and parameter.p_fech_fini then
      raise_application_error(-20010,
                              'La fecha de emision debe estar comprendida entre..' ||
                              to_char(parameter.p_fech_inic, 'dd-mm-yyyy') ||
                              ' y ' ||
                              to_char(parameter.p_fech_fini, 'dd-mm-yyyy'));
    end if;
    
    
    ----------
  
    if nvl(g_anex.anex_cant_movi, 0) <= 0 then
      v_cant_movi := 1;
    end if;
  
    if g_sose.sose_sucu_nume_item is not null then
      if g_anex.anex_nume_poli is null or
         g_anex.anex_nume_orde_serv is null or
         g_anex.anex_fech_inic_poli is null or
         g_anex.anex_fech_fini_poli is null then
        raise_application_error(-20010,
                                'Debe ingresar todos los datos de la Poliza para los Anexos de Seguros.');
      end if;
    end if;
  
    if nvl(parameter.p_indi_most_cicl_anex, 'N') = 'N' then
      if g_anex.anex_cifa_codi is null then
        raise_application_error(-20010, 'Debe ingresar codigo de ciclo.');
      end if;
    end if;
  
  end pp_validaciones_anex; 
  
  
   procedure pp_actualiza_anex(p_anex_codi in number) is
  
    v_count     number;
    v_cant_movi number := 1;
    v_sose_tipo varchar2(20);
  
  begin
  
   
      parameter.p_indi_nuev_regi := 'S'; --indica que se esta registrando aora el anexo
    
      if nvl(parameter.indi_anex_inst, 'N') = 'S' then
        v_sose_tipo := 'I';
      else
        v_sose_tipo := g_sose.sose_tipo;
      end if;
    
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
         anex_cifa_codi,
         anex_cifa_tipo,
         anex_cifa_dia_fact,
         anex_cifa_dia_desd,
         anex_cifa_dia_hast,
         anex_aglu_cicl,
         anex_auto_ci,       
         anex_auto_nombre,   
         anex_auto_fech_nac, 
         anex_auto_fech_vto,
         anex_auto_nac,  
         anex_esta_civil)
      values
        (g_anex.anex_empr_codi,
         g_anex.anex_codi,
         g_anex.anex_sose_codi,
         g_anex.anex_nume,
         g_anex.anex_fech_emis,
         add_months(g_anex.anex_fech_emis, g_sose.sose_dura_cont) - 1,
         g_anex.anex_fech_emis,
         g_anex.anex_base,
         g_anex.anex_user_regi,
         g_anex.anex_fech_regi,
         g_anex.anex_user_modi,
         g_anex.anex_fech_modi,
         g_anex.anex_esta,
         nvl(g_anex.anex_dura_cont, g_sose.sose_dura_cont),
         g_anex.anex_mone_codi,
         g_anex.anex_tasa_mone,
         g_anex.anex_impo_mone,
         round(g_anex.anex_impo_mone * g_anex.anex_tasa_mone,
               g_mone.mone_cant_deci),
         round(g_anex.anex_prec_unit, g_mone.mone_cant_deci),
         g_anex.anex_entr_inic,
         g_anex.anex_cant_movi,
         v_sose_tipo,
         g_anex.anex_equi_prec,
         round(g_anex.anex_impo_mone_unic, g_mone.mone_cant_deci),
         g_anex.anex_nume_poli,
         g_anex.anex_nume_orde_serv,
         g_anex.anex_fech_inic_poli,
         g_anex.anex_fech_fini_poli,
         g_anex.anex_nume, ---todos los nuevos anexos coincidiran en anex_nume y anex_nume_refe
         g_anex.anex_cifa_codi,
         g_anex.anex_cifa_tipo,
         g_anex.anex_cifa_dia_fact,
         g_anex.anex_cifa_dia_desd,
         g_anex.anex_cifa_dia_hast,
         g_anex.anex_aglu_cicl,
         g_anex.anex_auto_ci,       
         g_anex.anex_auto_nombre,   
         g_anex.anex_auto_fech_nac, 
         g_anex.anex_auto_fech_vto,
         g_anex.anex_auto_nac,  
         g_anex.anex_esta_civil);

  end pp_actualiza_anex;
  
    procedure pp_actualiza_deta(p_anex_codi in number) is
  
    cursor cv_deta(p_deta_codi in number) is
      select d.deta_vehi_codi,
             d.deta_codi,
             a.anex_tipo,
             s.sose_codi_padr,
             d.deta_codi_anex_padr
        from come_soli_serv_anex_deta d,
             come_soli_serv_anex      a,
             come_soli_serv           s
       where a.anex_codi = d.deta_anex_codi
         and a.anex_sose_codi = s.sose_codi
         and d.deta_codi = p_deta_codi;
  
    cursor c_temo(p_deta_nume_item_codi in number) is
      select temo_modu_codi, temo_deta_prec_unit
        from come_modu_anex_temp
       where temo_item_nume_codi = p_deta_nume_item_codi
         and temo_sesi_user_comp = parameter.p_secu_sesi_user_comp
       order by temo_item_nume_codi;
  
    v_ortr_codi_rein           number;
    v_vehi_codi_orig           number;
    v_vehi_iden_orig           varchar2(20);
    v_count                    number := 0;
    v_vehi_codi                number;
    v_vehi_iden                varchar2(20);
    v_vehi_iden_ante           varchar2(20);
    v_seal_desc                varchar2(10);
    v_seal_ulti_nume           number;
    v_seal_codi                number;
    v_deta_codi                number;
    v_cant_anex                number;
    v_cant                     number;
    v_cant_grua                number;
    v_deta_nume_item           number;
    v_deta_codi_anex_padr      number;
    v_indi_gene_anex_grua      varchar2(1);
    v_conc_indi_anex_vehi      varchar2(1);
    v_conc_indi_anex_requ_vehi varchar2(1);
    v_conc_indi_anex_requ_fech varchar2(1);
    v_conc_indi_anex_modu      varchar2(1);
    v_conc_indi_anex_sele_modu varchar2(1);
    v_deta_prec_unit           number;
    v_deta_impo_mone           number;
    v_vehi_codi_grua           number;
    v_codi                     number;
  
    v_desc_impo_grua number;
  begin
  
   
      for c in g_cur_col_det loop
      v_vehi_codi := null;
      v_vehi_iden := null;
    v_vehi_codi:= null;
      --g_deta_o

      if c.deta_codi is not null then
        select *
          into g_deta_o
          from come_soli_serv_anex_deta t
         where t.deta_codi = c.deta_codi;
      end if;
    
      if c.vehi_deta_codi is not null then
        select *
          into g_vehi_o
          from come_vehi t
         where vehi_codi = c.vehi_deta_codi;
      end if;
    
      g_deta.deta_mode      := c.deta_mode;
      g_deta.deta_anho      := c.deta_anho;
      g_deta.deta_colo      := c.deta_colo;
      g_deta.deta_nume_chas := c.deta_nume_chas;
      g_deta.deta_nume_pate := c.deta_nume_pate;
      g_vehi.vehi_indi_grua := c.deta_vehi_indi_grua;
      g_deta.deta_tive_codi := fp_tive_codi(c.tive_codi_alte);
      g_deta.deta_mave_codi := fp_mave_codi(c.mave_codi_alte);
      g_deta.deta_impo_mone := c.deta_impo_mone;
      g_deta.deta_prec_unit := c.deta_prec_unit;
      g_deta.deta_base      := 1;
      g_deta.deta_codi      := c.deta_codi;
      g_deta.deta_vehi_codi := c.vehi_deta_codi;
      g_deta.deta_nume_item := nvl(c.deta_nume_item, c.numero_item);
      v_vehi_codi           := g_deta.deta_vehi_codi;
      v_vehi_iden           := g_deta.deta_iden;
      g_deta.deta_codi_anex_padr := c.anex_codi;
      pp_conc_codi_alte2(c.conc_codi_alte);
  
      
          --si el concepto requiere vehiculo o anexo/contrato es por que ira ligado a algun vehiculo
        --entonces se verifica si existe el vehiculo, para generar o no nuevo vehiculo
    --RAISE_APPLICATION_ERROR (-20001,g_deta.deta_vehi_codi||'**'||g_conc.conc_codi||'**'||parameter.p_conc_codi_anex_grua_vehi); 
        
        if nvl(g_conc.conc_indi_anex_requ_vehi, 'N') in ('V', 'A') then
         
         
                --sino tiene aun vehiculo
            if g_conc.conc_codi <> parameter.p_conc_codi_anex_grua_vehi then
   
                begin
                
                  select seal_desc_abre,
                         nvl(seal_ulti_nume, 0) + 1,
                         seal_codi
                    into v_seal_desc, v_seal_ulti_nume, v_seal_codi
                    from come_clie_secu_alia
                   where ((seal_clpr_codi = g_sose.sose_clpr_codi) or
                         (seal_clpr_codi is null and
                         g_sose.sose_clpr_codi is null));
                exception
                  when no_data_found then
                    begin
                      select seal_desc_abre,
                             nvl(seal_ulti_nume, 0) + 1,
                             seal_codi
                        into v_seal_desc, v_seal_ulti_nume, v_seal_codi
                        from come_clie_secu_alia
                       where seal_desc_abre = 'RPY'
                         and seal_clpr_codi is null;
                    exception
                      when others then
                        v_seal_desc      := null;
                        v_seal_ulti_nume := null;
                        v_seal_codi      := null;
                    end;
                end;
                v_vehi_iden      := v_seal_desc || '-' || v_seal_ulti_nume;
                v_vehi_iden_ante := null;
              
                --actualizar secuencia
                update come_clie_secu_alia s
                   set s.seal_ulti_nume = v_seal_ulti_nume
                 where seal_codi = v_seal_codi;
              
             if v_vehi_iden is null then
               raise_application_error(-20001, 'El identificador no puede quedar vacio');
             end if;
            
            
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
                 vehi_indi_chap_prov
                 )
              values
                (v_vehi_codi,
                 v_vehi_iden,
                 'P',
                 g_sose.sose_clpr_codi,
                 g_sose.sose_sucu_nume_item,
                 g_deta.deta_tive_codi,
                 g_deta.deta_mave_codi,
                 nvl(g_deta.deta_mode, 'S/D'),
                 nvl(g_deta.deta_anho, 'S/D'),
                 nvl(g_deta.deta_colo, 'S/D'),
                 nvl(g_deta.deta_nume_chas, 'S/D'),
                 nvl(g_deta.deta_nume_pate, 'S/D'),
                 g_anex.anex_fech_emis, --nvl(g_deta.deta_fech_inic_vige, g_anex.anex_fech_emis),
                 add_months(g_anex.anex_fech_emis, g_sose.sose_dura_cont) - 1, --nvl(g_deta.deta_fech_fini_vige, g_anex.anex_fech_venc),
                 v_vehi_iden_ante,
                 1,
                 gen_user,
                 sysdate,
                 'N',
                 nvl(g_vehi.vehi_indi_grua, 'N'),
                 c.ind_chapa_prov);
                 
            end if;
        end if;
      
        ----------------------------------------------------------------------
        ----------------------------------------------------------------------
     
        
   
          v_deta_codi := fa_sec_soli_serv_anex_deta;
          begin
            select count(*)
              into v_cant
              from come_soli_serv_anex_deta d
             where deta_anex_codi = p_anex_codi
               and deta_nume_item = g_deta.deta_nume_item;
          
            if v_cant > 0 then
              select max(deta_nume_item) + 1
                into v_deta_nume_item
                from come_soli_serv_anex_deta d
               where deta_anex_codi = p_anex_codi;
            else
              v_deta_nume_item := g_deta.deta_nume_item;
            end if;
          end;
            

    
          if g_conc.conc_codi <> parameter.p_conc_codi_anex_grua_vehi and
             g_vehi.vehi_indi_grua = 'S' then
             v_indi_gene_anex_grua := 'N';
        
            begin
              select count(*)
                into v_cant_grua
                from come_vehi v, come_soli_serv_anex_deta
               where deta_vehi_codi = vehi_codi
                 and deta_anex_codi <> p_anex_codi
                 and vehi_codi = v_vehi_codi
                 and vehi_indi_grua = 'S';
            
              if v_cant_grua > 0 then
                v_indi_gene_anex_grua := 'N';
              else
                v_indi_gene_anex_grua := 'S';
              end if;
            end;
           
           if v_indi_gene_anex_grua = 'S' then
              v_desc_impo_grua := nvl(parameter.p_prec_unit_anex_grua_vehi,
                                      0);
            else
              v_desc_impo_grua := 0;
            end if;
          else
            v_desc_impo_grua := 0;
          end if;
    
          insert into come_soli_serv_anex_deta
            (deta_anex_codi,
             deta_nume_item,
             deta_vehi_codi,
             deta_iden,
             deta_base,
             deta_roam_fech_inic_vige,
             deta_roam_fech_fini_vige,
             deta_fech_vige_inic,
             deta_fech_vige_fini,
             deta_conc_codi,
             deta_codi_anex_padr,
             deta_prec_unit,
             deta_indi_anex_vehi,
             deta_indi_anex_requ_vehi,
             deta_indi_anex_requ_fech,
             deta_indi_anex_modu,
             deta_indi_anex_sele_modu,
             deta_codi,
             deta_impo_mone,
             deta_esta_plan,
             deta_iden_ante,
             deta_inst_ciud, 
             deta_inst_barrio,
             deta_inst_dire,
             deta_inst_ubi,
             deta_inst_refe,
             deta_indi_prom_pror,
             deta_inst_ciud_codi)
          values
            (p_anex_codi,
             v_deta_nume_item, --g_deta.deta_nume_item,
             v_vehi_codi,
             v_vehi_iden,
             g_deta.deta_base,
             g_deta.deta_roam_fech_inic_vige,
             g_deta.deta_roam_fech_fini_vige,
             g_anex.anex_fech_emis,
             add_months(g_anex.anex_fech_emis, g_sose.sose_dura_cont) - 1,
             g_conc.conc_codi,
             g_deta.deta_codi_anex_padr,
             nvl(g_deta.deta_prec_unit, 0) - nvl(v_desc_impo_grua, 0),
             g_conc.conc_indi_anex_vehi,
             g_conc.conc_indi_anex_requ_vehi,
             g_conc.conc_indi_anex_requ_fech,
             g_conc.conc_indi_anex_modu,
             g_conc.conc_indi_anex_sele_modu,
             v_deta_codi,
             g_deta.deta_impo_mone,
             'S',
             v_vehi_iden_ante,
             c.extr_vehi_ciud,
             c.extr_vehi_barr,
             c.extr_vehi_dire,
             c.extr_vehi_ubic,
             c.extr_vehi_refe, 
             c.ind_prorrateo,
             c.extr_vehi_ciud_codi);
             
           -----si es nuevo
          if v_vehi_codi is not null  then 
          
          I020271_A.pp_actualizar_tipo_doc(v_vehi_codi,v_deta_codi,c.nro_next,g_deta.deta_tive_codi);
          end if;
          
        
          v_deta_prec_unit := nvl(g_deta.deta_prec_unit, 0) -
                              nvl(v_desc_impo_grua, 0);
        
          if g_conc.conc_codi <> parameter.p_conc_codi_anex_grua_vehi and
             g_vehi.vehi_indi_grua = 'S' then
            v_indi_gene_anex_grua := 'N';
             
            begin
              select count(*)
                into v_cant_grua
                from come_vehi v, come_soli_serv_anex_deta
               where deta_vehi_codi = vehi_codi
                 and deta_anex_codi <> p_anex_codi
                 and vehi_codi = v_vehi_codi
                 and vehi_indi_grua = 'S';
            
              if v_cant_grua > 0 then
                v_indi_gene_anex_grua := 'N';
              else
                v_indi_gene_anex_grua := 'S';
              end if;
            end;


     
    
          
            if v_indi_gene_anex_grua = 'S' then
              v_deta_codi_anex_padr := v_deta_codi;
              v_deta_codi           := fa_sec_soli_serv_anex_deta;
       --   raise_application_error(-20001,v_deta_codi_anex_padr||p_anex_codi);   
              begin
                select count(*)
                  into v_cant
                  from come_soli_serv_anex_deta d
                 where deta_anex_codi = p_anex_codi
                   and deta_nume_item = g_deta.deta_nume_item;
              
                if v_cant > 0 then
                  select max(deta_nume_item) + 1
                    into v_deta_nume_item
                    from come_soli_serv_anex_deta d
                   where deta_anex_codi = p_anex_codi;
                else
                  v_deta_nume_item := g_deta.deta_nume_item;
                end if;
              end;
            
              begin
                select nvl(c.conc_indi_anex_vehi, 'N'),
                       nvl(c.conc_indi_anex_requ_vehi, 'N'),
                       nvl(c.conc_indi_anex_requ_fech, 'N'),
                       nvl(c.conc_indi_anex_modu, 'N'),
                       nvl(c.conc_indi_anex_sele_modu, 'N')
                  into v_conc_indi_anex_vehi,
                       v_conc_indi_anex_requ_vehi,
                       v_conc_indi_anex_requ_fech,
                       v_conc_indi_anex_modu,
                       v_conc_indi_anex_sele_modu
                  from come_conc c
                 where conc_codi = parameter.p_conc_codi_anex_grua_vehi;
              end;
          
              insert into come_soli_serv_anex_deta
                (deta_anex_codi,
                 deta_nume_item,
                 deta_vehi_codi,
                 deta_iden,
                 deta_base,
                 deta_roam_fech_inic_vige,
                 deta_roam_fech_fini_vige,
                 deta_fech_vige_inic,
                 deta_fech_vige_fini,
                 deta_conc_codi,
                 deta_codi_anex_padr,
                 deta_prec_unit,
                 deta_indi_anex_vehi,
                 deta_indi_anex_requ_vehi,
                 deta_indi_anex_requ_fech,
                 deta_indi_anex_modu,
                 deta_indi_anex_sele_modu,
                 deta_codi,
                 deta_impo_mone,
                 deta_esta_plan,
                 deta_iden_ante,
                 deta_indi_prom_pror)
              values
                (p_anex_codi,
                 v_deta_nume_item,
                 null, --v_vehi_codi,
                 v_vehi_iden,
                 g_deta.deta_base,
                 null,
                 null,
                 g_anex.anex_fech_emis,
                 add_months(g_anex.anex_fech_emis, g_sose.sose_dura_cont) - 1,
                 parameter.p_conc_codi_anex_grua_vehi,
                 NVL(V('P65_ANEX_NUME'),v_deta_codi_anex_padr),
                 nvl(parameter.p_prec_unit_anex_grua_vehi, 0), --v_deta_prec_unit - nvl(parameter.p_prec_unit_anex_moni_vehi, 0),
                 v_conc_indi_anex_vehi,
                 v_conc_indi_anex_requ_vehi,
                 v_conc_indi_anex_requ_fech,
                 v_conc_indi_anex_modu,
                 v_conc_indi_anex_sele_modu,
                 v_deta_codi,
                 (nvl(parameter.p_prec_unit_anex_grua_vehi, 0) *
                 g_sose.sose_dura_cont),
                 --(nvl(v_deta_prec_unit - nvl(parameter.p_prec_unit_anex_moni_vehi, 0), 0) * g_sose.sose_dura_cont),
                 'S',
                 null,
                 g_deta.deta_indi_prom_pror);
            
            end if;



          
          end if;
        
          if nvl(g_conc.conc_indi_anex_sele_modu, 'N') = 'S' then
            null;
           
          end if;
   
    end loop;
      --------------prueba en primera face........
    declare
    v_prec_unit number;
    v_impo_mone number;
        begin
    select sum(c004)   deta_prec_unit,sum(c005)   deta_impo_mone 
    into v_prec_unit, v_impo_mone
      from apex_collections a
     where collection_name = 'ANEXO_CONC';
     
       update come_soli_serv_anex a
                 set a.anex_prec_unit = nvl(v_prec_unit, 0),
                     a.anex_impo_mone = nvl(v_impo_mone, 0),
                     a.anex_impo_mmnn = round(nvl(v_impo_mone, 0) * g_anex.anex_tasa_mone, g_mone.mone_cant_deci)
               where a.anex_codi = p_anex_codi;
               
        end;  
 -- raise_application_error (-20001, 'fin');
  end pp_actualiza_deta;
  
  procedure pp_conc_codi_alte(i_codi_alte in number) as
  begin
    select *
      into g_conc
      from come_conc c
     where c.conc_codi_alte = i_codi_alte
       and c.conc_empr_codi = 1;
  
  end pp_conc_codi_alte;



  procedure pp_add_anex_det (p_registro in number,
                             p_cliente  in number) is
    
    v_tive_codi_alte           varchar2(100);-- := v('P65_TIVE_CODI_ALTE');
    v_conc_codi_alte           varchar2(100);-- := v('P65_CONC_CODI_ALTE');
    v_vehi_desc                varchar2(100) :=null;-- v('P65_VEHI_DESC');
    v_conc_desc                varchar2(100) := null; -- v('P65_CONC_DESC');
    v_sose_nume                varchar2(100) := null;--v('P65_SOSE_NUME');
    v_deta_anho                varchar2(100) := null;--v('P65_DETA_ANHO');
    v_deta_prec_unit           varchar2(100) := 99000;-- v('P65_DETA_PREC_UNIT');
    v_deta_nume_pate           varchar2(100) := null;--v('P65_DETA_NUME_PATE');
    v_deta_impo_mone           varchar2(100) := 1188000;--v('P65_DETA_IMPO_MONE');
    v_deta_vehi_indi_grua      varchar2(100) := 'N';--v('P65_DETA_VEHI_INDI_GRUA');
    v_anex_nume                varchar2(100) := null;--v('P65_ANEX_NUME');
    v_anex_codi                varchar2(100) := null; --v('P65_ANEX_CODI');
    v_vehi_iden                varchar2(100) := null;--v('P65_VEHI_IDEN');
    v_mave_codi_alte           varchar2(100) := null;--v('P65_MAVE_CODI_ALTE');
    v_vehi_marc                varchar2(100) := null;--v('P65_VEHI_MARC');
    v_deta_roam_fech_inic_vige varchar2(100) := null;--v('P65_DETA_ROAM_FECH_INIC_VIGE');
    v_deta_colo                varchar2(100) := null;--v('P65_DETA_COLO');
    v_deta_roam_fech_fini_vige varchar2(100) := null; --v('P65_DETA_ROAM_FECH_FINI_VIGE');
    v_deta_iden                varchar2(100) := null;--v('P65_DETA_IDEN');
    v_deta_mode                varchar2(100) := 1;--v('P65_DETA_MODE');
    v_deta_nume_chas           varchar2(100) := null;--v('P65_DETA_NUME_CHAS');
    v_deta_esta                varchar2(100) := null; --v('P65_DETA_ESTA');
    v_vehi_deta_codi           number := null;--v('P65_DETA_VEHI_CODI');
    v_seq_id                   number := null;--v('P65_SEQ_ID');
    v_deta_codi                number := null;--v('P65_DETA_CODI');
    v_deta_nume_item           number := null;--v('P65_DETA_NUME_ITEM');
    v_nro_sigiete              number:= null;--v('p65_nro_sig');
    
       xnum number:=0; 
    
          procedure pp_validar_det is
          begin
            if fp_tive_codi(v_tive_codi_alte) is null then
              raise_application_error(-20010, 'Error en tipo de vehiculo');
            end if;

            begin
              select t.conc_desc
                into v_conc_desc
                from come_conc t
               where t.conc_codi_alte = v_conc_codi_alte;
            exception
              when no_data_found then
                raise_application_error(-20010,
                                        'Error en validacion de concepto');
            end conc_val;
          end pp_validar_det;
          
    
  begin
 
 
 for x in ( select  case when t.extr_vehi_tipo = 1 and t.extr_vcod_new is not null then 
                 extr_vcod_new
               when t.extr_vehi_tipo = 1 and t.extr_vcod_new is null then
                   1
               when t.extr_vehi_tipo = 2 and t.extr_vcod_new is not null then 
                  extr_vcod_new
                 when t.extr_vehi_tipo = 2 and t.extr_vcod_new is  null then 
                  3
                  end tive_codi_alte,
                 case when t.extr_vehi_tipo = 1 then 
                 101
                 else
                 102 end conc_codi_alte,
                 
                 t.extr_vehi_comp,
                 t.extr_vehi_codigo,
                 t.extr_vehi_item, 
                 t.extr_vehi_ciud,
                 t.extr_vehi_barr,
                 t.extr_vehi_dire,
                 t.extr_vehi_refe,
                 t.extr_vehi_ubic,
                 t.extr_vehi_marc,
                 t.extr_vehi_mode,
                 t.extr_vehi_anho,
                 t.extr_vehi_colo,
                 t.extr_vehi_chas,
                 t.extr_vehi_pate,
                 t.extr_vehi_indi_grua,
                 t.extr_indi_prom_pror, 
                 t.extr_precio, 
                 t.extr_ind_chap_prov, 
                 t.extr_vehi_ciud_codi
                from EXTR_VEHI t
             where t.extr_vehi_rege = p_registro
              and t.extr_vehi_clien = p_cliente
                  ) loop
         xnum :=xnum+1;          
             v_tive_codi_alte  :=x.tive_codi_alte;
                 v_conc_codi_alte := x.conc_codi_alte;
   pp_validar_det;
      if v_deta_codi is not null then
        declare
          v_cant number := 0;
        begin
          select count(*)
            into v_cant
            from come_soli_serv_anex_deta d
           where d.deta_codi_anex_padr = v_deta_codi;
        
          if v_cant > 0 then
            raise_application_error(-20010,
                                    'El item por Concepto de Servicio de Grua ya fue generado, debe eliminar ese item!');
          end if;
        end;
      end if;
   
   
      I020271_A.pp_consultar_tip_doc(p_tipo_vehi   => x.tive_codi_alte,
                                     p_dove_anex_deta => v_anex_codi,
                                     p_comprobante => x.extr_vehi_comp,
                                     p_clave       => x.extr_vehi_codigo,
                                      p_item     => x.extr_vehi_item,
                                     p_nro_sig => xnum);
  



if nvl(x.extr_vehi_indi_grua,'N') = 'S' then
  
v_deta_prec_unit := x.extr_precio+41000; --140000;-- v('P65_DETA_PREC_UNIT');
v_deta_impo_mone := x.extr_precio*12; 
else        
v_deta_prec_unit := x.extr_precio;-- v('P65_DETA_PREC_UNIT');
v_deta_impo_mone := x.extr_precio*12; 
  
end if;    
      apex_collection.add_member(p_collection_name => 'ANEXO_CONC',
                                 p_c002            => x.conc_codi_alte,
                                 p_c003            => v_conc_desc,
                                 p_c004            => v_deta_prec_unit,
                                 p_c005            => v_deta_impo_mone,
                                 p_c006            => v_anex_nume,
                                 p_c007            => v_sose_nume,
                                 p_c008            => v_vehi_iden,
                                 p_c009            => v_deta_roam_fech_inic_vige,
                                 p_c010            => v_deta_roam_fech_fini_vige,
                                 p_c011            => x.extr_vehi_indi_grua,--v_deta_vehi_indi_grua,
                                 p_c012            => x.extr_vehi_anho,--v_deta_anho,
                                 p_c013            => x.tive_codi_alte,
                                 p_c014            => x.extr_vehi_marc,--v_mave_codi_alte,
                                 p_c015            => v_vehi_marc,
                                 p_c016            => x.extr_vehi_pate,--v_deta_nume_pate,
                                 p_c017            => x.extr_vehi_colo,--v_deta_colo,
                                 p_c018            => v_deta_iden,
                                 p_c019            => x.extr_vehi_mode,--v_deta_mode,
                                 p_c020            => x.extr_vehi_chas,--v_deta_nume_chas,
                                 p_c021            => v_deta_esta,
                                 p_c022            => v_vehi_desc,
                                 p_c023            => v_deta_codi,
                                 p_c024            => v_deta_nume_item,
                                 p_c025            => v_vehi_deta_codi,
                                 p_c027            => xnum,--v_nro_sigiete,
                                 p_c030            => v_anex_codi, 
                                 p_c031            => x.extr_vehi_ciud,
                                 p_c032            => x.extr_vehi_barr,
                                 p_c033            => x.extr_vehi_dire,
                                 p_c034            => x.extr_vehi_ubic,
                                 p_c035            => x.extr_vehi_refe,
                                 p_c036            => x.extr_indi_prom_pror, 
                                 p_c037            => x.extr_ind_chap_prov,
                                 p_c038            => x.extr_vehi_ciud_codi
                                 );
 

 end loop;   
  end pp_add_anex_det;
  
  
  
  
 procedure pp_actualizar_tipo_doc(p_dove_vehi_codi in number,
                                  p_dove_anex_deta in number,
                                  p_nro_next in number,
                                  p_tive_cod in number)
  is
  cursor c_tipo_doc is 
  select --a.seq_id nro_item,
       a.c001  dove_codi,
       a.c002  requ_codi,
       a.c003  requ_desc,
       a.c004  requ_tive_codi,
       a.c005  tive_desc,
       nvl(a.c006,'NO')  estado,
       a.c007  clave_img,
       a.c008  vehi_cod ,
       a.c009 anexo,
       a.c010 filename,
       a.c011 mimetype,
       BLOB001  DOVE_IMG,
       c013 nro 
from apex_collections a
where collection_name = 'ANEXO_TIPO_DOC'
and a.c013 = p_nro_next
and  a.c004 = p_tive_cod
order by to_number(c002) ;


v_file_id number;
v_dove_codi number;

v_cant number := 0;
  begin
    

     
   for i in  c_tipo_doc loop 
 ---------------insertar imagen

    begin
      select  files_archivos_seq.nextval d
        into v_file_id
        from dual d;
    exception
      when no_data_found then
        v_file_id := null;
    end;
 /*   insert into come_concat
    (campo1, orden, nombre, otro, numerico)
  values
    ( p_dove_vehi_codi||'req'||i.requ_codi, null, null, 'loll', null);
  commit;  */
    
 insert into files_archivos
   (file_id,
    file_created_by,
    file_created_on,
    file_blob_content,
    FILE_NAME,
    FILE_MIME_TYPE
    )
 values
   (v_file_id,
    gen_user,
    sysdate,
    i.DOVE_IMG,
    i.filename,
    i.mimetype);


  
  --------------------
  

   
  begin
      select nvl(max(d.dove_codi), 0)+i.nro--1
        into v_dove_codi
        from come_docu_requ_vehi d;
    exception
      when no_data_found then
        v_dove_codi := 1;
    end;
      --    v_dove_codi:= v_dove_codi+p_nro_next;
         insert into come_docu_requ_vehi
           (dove_codi,
            dove_vehi_codi,
            dove_requ_codi,
            dove_esta,
            dove_user_regi,
            dove_fech_regi,
            dove_anex_deta,
            dove_img)
         values
           (v_dove_codi,
            p_dove_vehi_codi,
            i.requ_codi,
            i.estado,
            gen_user,
            sysdate,
            p_dove_anex_deta,
            nvl(i.clave_img,v_file_id));
           
            --  raise_application_error(-20001,p_dove_anex_deta||'----');
           

v_file_id:=null;

end loop;


end pp_actualizar_tipo_doc;
 function fp_tive_codi(i_codi_alte in number) return number as
    v_return number;
  begin
  
    select tive_codi
      into v_return
      from come_tipo_vehi
     where tive_empr_codi = 1
       and tive_codi_alte = i_codi_alte;
  
    return v_return;
  exception
    when no_data_found then
      return null;
  end fp_tive_codi;

function fp_mave_codi(i_codi_alte in number) return number as
    v_return number;
  begin
    null;
  
    select mave_codi
      into v_return
      from come_marc_vehi
     where mave_empr_codi = 1
       and mave_codi_alte = i_codi_alte;
  
    return v_return;
  exception
    when no_data_found then
      return null;
  end fp_mave_codi;
  
   procedure pp_conc_codi_alte2(i_codi_alte in number) as
  begin
    select *
      into g_conc
      from come_conc c
     where c.conc_codi_alte = i_codi_alte
       and c.conc_empr_codi = 1;
  
  end pp_conc_codi_alte2;
  
  
  
  
procedure pp_consultar_tip_doc(p_tipo_vehi in number,
                               p_dove_anex_deta in number,
                               p_comprobante in number,
                               p_clave       in number,
                               p_item        in number,
                               p_nro_sig in out number) is
                                
  cursor c is 
 select tp.requ_codi,
       tp.requ_desc,
       tp.requ_tive_codi,
       tv.tive_desc,
       estado,
       dove_img,
       clave_img,
       dove_vehi_codi,
       dove_requ_codi,
       dove_codi,
       dove_anex_deta,
       file_name,
       file_mime_type,
       tp.requ_orden
  from come_docu_requ_tipo tp,
       come_tipo_vehi tv,
       (select 'SI' estado,
               t.vdet_file dove_img,
               null clave_img,
               null dove_vehi_codi,
               c.tdoc_codigo dove_requ_codi,
               null dove_codi,
               null dove_anex_deta,
               t.vdet_file_name file_name,
               t.vdet_file_mime_type file_mime_type
        
          from extr_vehi_det t, extr_vehi_req b, extr_vehi_tipo_doc c
         where t.vdet_codigo = p_clave
           and t.vdet_req = b.tipo_req
           and b.tipo_vehi_comp = p_comprobante
           and b.tipo_req = c.tdoc_codigo
           and t.vdet_item = p_item
           and t.vdet_cant =1
        
        )
 where tp.requ_externo = dove_requ_codi(+)
   and tp.requ_tive_codi = tv.tive_codi
   and tp.requ_tive_codi = p_tipo_vehi;
 V_ITEM NUMBER:=0;
 v_nro_nex number;
 begin




 
    --- apex_collection.create_or_truncate_collection(p_collection_name => 'ANEXO_TIPO_DOC');  
     for i in c loop  
          
      apex_collection.add_member(p_collection_name => 'ANEXO_TIPO_DOC',
                                 p_c001            => i.dove_codi,
                                 p_c002            => i.requ_codi,
                                 p_c003            => i.requ_desc,
                                 p_c004            => i.requ_tive_codi,
                                 p_c005            => i.tive_desc,
                                 p_c006            => i.estado,
                                 p_c007            => i.clave_img,
                                 p_c008            => i.dove_vehi_codi,
                                 p_c009            => i.dove_anex_deta,
                                 p_C010            => i.file_name,
                                 p_C011            => i.file_mime_type,
                                 p_c012            => i.REQU_ORDEN,
                                 P_c013            => nvl(p_nro_sig,1),
                                 p_BLOB001         => i.DOVE_IMG
                                 );
      
   ---prueba   
  V_ITEM:=V_ITEM+1;                        
  
    
 end loop;
    
    
end pp_consultar_tip_doc;
  
  
 

procedure pp_generar_pri_link is
  
v_clave number;
v_cod_user number;
v_link varchar2(2000);
v_rowid varchar2(1000);
v_clave_nro varchar2(3000);
v_cod_empl number;
v_cod_sup number;
begin
  select extr_link_clave.nextval 
    into v_clave 
    from dual;

select t.user_codi, t.user_empl_codi
 into v_cod_user, v_cod_empl
from SEGU_USER t
where t.user_login = gen_user;
 select  lower(standard_hash(v_clave, 'SHA512'))
into v_clave_nro
from dual;


if v_cod_empl is not null then
  begin 
select t.empl_sup_inm 
into v_cod_sup 
from come_empl t 
where t.empl_codi = v_cod_empl;
exception 
  when others then
    v_cod_sup := null;
  null;  
 end; 
end if;
insert into extr_rege_link
  (regi_codigo, regi_asesor, regi_link, regi_fech_grab, regi_user, regi_clave_es,regi_supervisor)
values
  (v_clave, v_cod_user, null, sysdate, gen_user, v_clave_nro,v_cod_sup);
 -- commit;
 select rowid 
   into v_rowid
  from extr_rege_link
  where regi_codigo = v_clave;

if trunc(sysdate) > '28/11/2022' then
 v_link :='https://micuenta.alarmas.com.py/ords/walrusws/r/aplicacion-publica/dato-cliente?P20_P='||v_clave_nro;


else

  v_link :='https://micuenta.alarmas.com.py/ords/walrusws/r/aplicacion-publica/dato-cliente?P20_P='||v_rowid;

end if;
---v_link := 'http://168.138.147.91:8080/ords/walrusws/r/aplicacion-publica/dato-cliente?P20_P='||v_rowid;

--v_link := 'http://168.138.147.91:8080/ords/walrusws/r/aplicacion-publica/info-cliente?P300_P='||v_rowid;

--v_link := 'http://168.138.147.91:8080/ords/f?p=116:300:::::P300_P:'||v_rowid;

update extr_rege_link
  set regi_link = v_link
 where rowid = v_rowid;
--raise_application_error(-20001,'jkafhdlkas');


end pp_generar_pri_link;


procedure pp_actualizar_informconf2(p_codigo         in varchar2,
                                    p_cliente        in varchar2)is
 
 v_codigo number;
 v_existe number;
 v_estado varchar2(1);
 v_link   varchar2(2000);
 v_rowid  varchar2(1000);
 v_infor varchar2(2);
 v_tipo_doc varchar(20);
 v_nro_doc varchar2(100);
 v_doc_consul varchar2(1000);
 begin
   --raise_application_error(-20001,'adfa');
   select rowid 
   into v_rowid
  from extr_rege_link
  where regi_codigo = p_codigo;
  
  select case when extr_tipo_doc = 2 then
    SUBSTR(extr_clien_docu,1,LENGTH(extr_clien_docu)-2) 
    
    else
      extr_clien_docu
    
    end nro_doc, 'P'--decode(d.extr_tipo_doc,1,'P','E')
  
  
  
  into v_nro_doc, v_tipo_doc
  from extr_cliente d
  where d.extr_clen_codi = p_cliente;
  
  
  ----------revisamos si tiene consulta menos de 8 dias
 if v_tipo_doc = 'P' then  
   v_doc_consul:=rtrim(ltrim(to_char(to_number(v_nro_doc),
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
   and replace(info_nro_docu,'.','') =v_nro_doc;
  exception when no_data_found then
    v_infor :=null;
     when too_many_rows then
       select info_scor scoring
         into v_infor
         from come_cons_informconf
        where info_serv_tipo_audi = v_tipo_doc
          and trunc(info_fech_audi) >= trunc(sysdate) - 8
          and replace(info_nro_docu,'.','') = v_nro_doc
          and info_fech_audi =(select max(info_fech_audi)
                                 from come_cons_informconf
                                where info_serv_tipo_audi in ('P', 'E')
                                  and trunc(info_fech_audi) >= trunc(sysdate) - 8
                                  and replace(info_nro_docu,'.','') = v_nro_doc);
  
  when others then
     v_infor :=null;
  end;      
    
  ---------si no hay informacion reciente se consulta a inforcomf 
   
  
  if v_infor is null  then
 

   
    BEGIN

      -- Call the procedure
      PACK_CONSULTAS_INFORMCONF.PP_CONSULTAR(V_NRO_DOCU      => v_nro_doc,
                                             V_USUARIO       => gen_user,
                                             V_TIPO_CONS     => v_tipo_doc);
    END;

   
  -----------nuevamente consultamos los registros guardados
  
  
 begin
  select info_scor scoring
  into v_infor
  from come_cons_informconf
 where info_serv_tipo_audi in ('P', 'E')
   and trunc(info_fech_audi) >= trunc(sysdate) - 8
   and replace(info_nro_docu,'.','') =v_nro_doc;
  exception when no_data_found then
    v_infor :=null;
     when too_many_rows then
       select info_scor scoring
         into v_infor
         from come_cons_informconf
        where info_serv_tipo_audi = v_tipo_doc
          and trunc(info_fech_audi) >= trunc(sysdate) - 8
          and replace(info_nro_docu,'.','') = v_nro_doc
          and info_fech_audi =(select max(info_fech_audi)
                                 from come_cons_informconf
                                where info_serv_tipo_audi in ('P', 'E')
                                  and trunc(info_fech_audi) >= trunc(sysdate) - 8
                                  and replace(info_nro_docu,'.','') = v_nro_doc);

  when others then
     v_infor :=null;
  end; 

end if;



If v_infor is not null and v_infor not in ('M','N','X') then
   v_estado := 'S';
   v_link := 'https://micuenta.alarmas.com.py/ords/walrusws/r/aplicacion-publica/actualizar-documentos1?P502_S='||v_rowid;
  -- v_link := 'https://micuenta.alarmas.com.py/ords/walrusws/r/aplicacion-publica/actualizar-documentos?P502_S='||v_rowid;

  --v_link := 'http://140.238.186.240:8080/ords/walrusws/r/aplicacion-publica/actualizar-documentos1?P502_S='||v_rowid;
--v_link := 'http://168.138.147.91:8080/ords/f?p=116:502:::::P502_S:'||v_rowid;
else
   v_estado := 'R';
end if;


update extr_rege_link a
  set  a.regi_informconf  = v_estado,
       regi_fecha_inform  = sysdate,
   --    a.regi_link_doc    = v_link, 
       regi_faja_infor = v_infor
where regi_codigo = p_codigo;

end pp_actualizar_informconf2;




  procedure pp_llamar_reporte(p_cod       in varchar2,
                              p_req       in varchar2) is
  v_nombre       varchar2(50);
  v_parametros   clob;
  v_contenedores clob;
  
   begin
  


   --v_nombre:=  'comisioncobranzas'; comisioninstalaciones
  --v_nombre:=  'comisioncobranzas'; comisioninstalaciones
   v_contenedores :='p_cod:p_req';
   v_parametros :=  p_cod||':'||p_req||':';




delete from come_parametros_report  where usuario = gen_user;

insert into come_parametros_report
  (parametros, usuario, nombre_reporte, formato_salida, nom_parametros)
values
  (v_parametros,gen_user, 'pruebaaaaaa', 'pdf', v_contenedores);

end pp_llamar_reporte;



                            
   procedure pp_eliminar (p_registro in number)is
     
   
   v_cod_cliente number;
   v_cod_vehiculo number;
   v_soli_nro number;
   begin
     
   
  select r.regi_solicitud
    into  v_soli_nro
    from extr_rege_link r
   where regi_codigo = p_registro;
   
   if v_soli_nro is not null then
     raise_application_error(-20001,'El registro tiene solicitud no se puede eliminar, primero elimine la solicitud');
   
   end if;
   
   begin 
   select regi_cliente
    into v_cod_cliente
    from extr_rege_link
   where regi_codigo = p_registro;
   exception when no_data_found then
     v_cod_cliente := null;
   end;
   
   begin
   select a.extr_vehi_codigo
     into v_cod_vehiculo 
     from extr_vehi a
    where a.extr_vehi_rege= p_registro;
   exception when no_data_found then
     v_cod_vehiculo := null;
   end;
   
   

   delete extr_referencia r
   where r.refe_registro = p_registro;
   
   
    delete extr_vehi_det vd
    where vd.vdet_codigo = v_cod_vehiculo;
   
   
    delete extr_vehi v
   where v.extr_vehi_rege = p_registro
   and v.extr_vehi_codigo= v_cod_vehiculo;
  
  


   
     delete extr_rege_link
   where regi_codigo = p_registro;
   
   delete extr_cliente c
   where c.extr_clen_codi = v_cod_cliente;


 
   
   end  pp_eliminar;       
  

procedure pp_ubi_instalacion (p_registro in number,
                              p_cliente  in number,
                              p_opcion   in varchar2,
                              p_estado   in varchar2)is
v_opcion varchar2(10);
v_link varchar2(1000);
v_rowid varchar2(1000);
 v_cant_vehi   number;
  v_clpr_codigo number;
  v_sose_codigo number;
  p_clpr_ruc varchar2(60);
  v_sose_nume number;
  
  clpr_email_fact varchar2(600);
  clpr_dire varchar2(600);
  clpr_ciud_codi varchar2(600); 
  clpr_ciud_desc varchar2(600);
  clpr_fech_naci varchar2(600);
  clpr_naci_codi varchar2(600);
  clpr_sexo varchar2(600);
  clpr_pais_codi varchar2(600);
  clpr_esta_civi varchar2(600);
  clpr_barr_Codi varchar2(600);
  clpr_barr_desc varchar2(600);
  exite number;
  clrp_ubicacion varchar2(600);
  clpr_email varchar2(600);
  V_CLIENTE NUMBER;
  v_clave_reg varchar2(3000);
begin
  
if p_opcion = 1 then
  v_opcion := 'S';
else
  v_opcion := 'N';
end if;
  

 select rowid, s.regi_cliente, regi_clave_es
   into v_rowid, v_cliente, v_clave_reg
  from extr_rege_link s
  where regi_codigo = p_registro;
/*
begin
  i020271_a.pp_actualizar_informconf2(p_codigo  => p_registro,
                                      p_cliente => p_cliente);
end;
*/


  
  
  
     select extr_clien_docu
       into p_clpr_ruc
       from extr_cliente 
      where extr_clen_codi = v_cliente;
      
    
  ----------verificamos si el cliente existe 
     begin
       select clpr_codi,
              clpr_email_fact,
              clpr_dire,
              clpr_ciud_codi,
              clpr_fech_naci,
              clpr_naci_codi,
              clpr_sexo,
              clpr_pais_codi,
              clpr_esta_civi,
              clpr_barr_Codi,
              clrp_ubicacion,
              clpr_email
         into v_clpr_codigo,
              clpr_email_fact,
              clpr_dire,
              clpr_ciud_codi,
              clpr_fech_naci,
              clpr_naci_codi,
              clpr_sexo,
              clpr_pais_codi,
              clpr_esta_civi,
              clpr_barr_Codi,
              clrp_ubicacion,
              clpr_email
         from come_clie_prov
        where (clpr_ruc = p_clpr_ruc or
              substr(p_clpr_ruc, 1, instr(p_clpr_ruc, '-', 1) - 1) =
              substr(clpr_ruc, 1, instr(clpr_ruc, '-', 1) - 1) or
              p_clpr_ruc =
              substr(clpr_ruc, 1, instr(clpr_ruc, '-', 1) - 1) or
              substr(p_clpr_ruc, 1, instr(p_clpr_ruc, '-', 1) - 1) =
              clpr_ruc)
          and clpr_indi_clie_prov = 'C';
     exception
       when no_data_found then
         v_clpr_codigo := null;
       when others then
         v_clpr_codigo := null;
     end;

 
  --------------si existe cliente verificamos la solicitud ---------------
  if v_clpr_codigo is not null then
     
  ------para saber si esta activo revisamos si por lo menos tiene un movil instalado
      select count(*)
        into v_cant_vehi
        from COME_VEHI a
       where a.vehi_clpr_codi = v_clpr_codigo
         and vehi_esta = 'I';
      
        if v_cant_vehi >= 0 then
             if clpr_barr_Codi is not null then
              
              select ciud_desc
              into clpr_ciud_desc
              from come_ciud d
              where ciud_empr_codi  =  1
              and ciud_codi =clpr_ciud_codi;

          end if;
          
            if clpr_barr_Codi is not null then

                select barr_desc
                into clpr_barr_desc
                from come_barr
                where barr_empr_codi = 1
                 and barr_codi  = clpr_barr_Codi;
            end if;
        
         
        update extr_cliente
           set extr_esta_civi      = clpr_esta_civi,
               extr_fech_naci      = clpr_fech_naci,--v_extr_fech_naci,
               extr_dire           = clpr_dire,
               extr_naci_codi      = clpr_pais_codi,
               extr_barr_codi      = clpr_barr_desc,
               extr_ciud_codi      = clpr_ciud_codi,
               extr_sexo           = clpr_sexo,
               extr_email          = clpr_email,
               extr_ubicacion      = clrp_ubicacion,
               extr_email_fact     = clpr_email_fact,
               extr_ciudad         = clpr_ciud_desc,
               extr_cod_barrio     = clpr_barr_Codi,
               extr_cli_existe     = 1
         where extr_clen_codi      = v_cliente;
        
        end if;
end if;

 

 -- v_link := 'http://168.138.147.91:8080/ords/walrusws/r/aplicacion-publica/actualizar-documento?P21_S='||v_rowid;
if trunc(sysdate) > '28/11/2022' then
  
v_link := 'https://micuenta.alarmas.com.py/ords/walrusws/r/aplicacion-publica/actualizar-documento?P21_S='||v_clave_reg;


else
  
v_link := 'https://micuenta.alarmas.com.py/ords/walrusws/r/aplicacion-publica/actualizar-documento?P21_S='||v_rowid;
end if;
update extr_rege_link 
  set  regi_ubi_inst = v_opcion,
       regi_link_doc    = v_link 
where regi_codigo = p_registro;


--raise_application_error (-20001,v_opcion );

end pp_ubi_instalacion;





FUNCTION FP_DATOS_HTML(p_clave    NUMBER default null,
                       p_cliente   NUMBER DEFAULT NULL) RETURN VARCHAR2 IS
    V_ADJUNTO VARCHAR(32000);
     CURSOR C_REGISTRO IS
                  (select nvl(a.regi_ubi_inst, 'N') Ubi_instalacion,
                          regi_codigo,
                          ' ' rellenar
                    from extr_rege_link a
                   where a.regi_codigo = p_clave
                     and a.regi_cliente = p_cliente);
                   
     
 
v_descripcion varchar2(32000);
     
v_where number;     
v_dato  varchar2(32000);    
v_tabla varchar2(32000);
sql_stmt varchar2(32000);

v_cambia varchar2(32000);
v_id     varchar2(32000);

v_dato2 varchar2(1000);
 begin
  v_adjunto := v_adjunto ||'<PRE style="font-size:12px;">';
  
   V_ADJUNTO := V_ADJUNTO || '<b>'||RPAD('Si', 8, ' ')||RPAD('No', 9, ' ')||'</b><br><br>' ;
  for r in c_registro  loop

     V_ADJUNTO := V_ADJUNTO||'<input type="checkbox"'||r.Ubi_instalacion||' onchange=javascript:$s("P300_ESTADO",this.checked);javascript:$s("P300_ID",'||R.regi_codigo||');javascript:$s("P300_TIPO",'||1||')>'||RPAD(r.rellenar,5,' ')||'<input type="checkbox" '||r.Ubi_instalacion||' onchange=javascript:$s("P300_ESTADO",this.checked);javascript:$s("P300_ID",'||R.regi_codigo||');javascript:$s("P300_TIPO",'||2||')><br>' ;
  
  end loop;
     V_ADJUNTO := V_ADJUNTO ||'</PRE>';
 
 
  RETURN V_ADJUNTO;

  
  
 END FP_DATOS_HTML;


procedure pp_generar_negociacion (p_solicitud  in number,
                                  p_anexo      in number,
                                  p_regi       in number)is
  
v_ctn_sose_codi   varchar2(1000);
v_ctn_clpr_codi   varchar2(1000);
v_promo           varchar2(1000);
v_ctn_ciudad      varchar2(1000);
v_ctn_ubicacion   varchar2(1000);
v_ctn_vehi_codi   varchar2(1000);
v_ctn_importe     varchar2(1000);
v_empleado        number;
v_cnt_codigo      varchar2(1000):=crm_neg_ticket_seq.nextval;

begin
    
        begin
        select a.empl_codi
        into v_empleado 
      from COME_EMPL a, SEGU_USER b
      where empl_codi = user_empl_codi
      and b.user_login = gen_user;
      exception 
        when others then
          v_empleado := 1;
      end;
        
 select a.sose_codi,
        a.sose_clpr_codi,
        decode(v.deta_indi_prom_pror, 'S', 'Promo mes libre') promo,
        v.deta_inst_ciud_codi,
        v.deta_inst_ubi,
        v.deta_vehi_codi,
        v.deta_prec_unit
       
   into v_ctn_sose_codi,
        v_ctn_clpr_codi,
        v_promo,
        v_ctn_ciudad,
        v_ctn_ubicacion,
        v_ctn_vehi_codi,
        v_ctn_importe        
   from come_soli_serv_anex t, 
        come_soli_serv a, 
        come_soli_serv_anex_deta v
  where a.sose_codi = t.anex_sose_codi
    and t.anex_codi = v.deta_anex_codi
    and sose_codi = p_solicitud
    and anex_codi = p_anexo
    and deta_vehi_codi is not null;


        insert into crm_neg_ticket 
          (ctn_codi,
           ctn_tickt_embu,
           ctn_clpr_codi,
           ctn_etap_codi,
           ctn_sose_codi,
           ctn_ubicacion,
           ctn_vehi_codi,
           ctn_ciudad,
           ctn_importe,
           ctn_tipo_serv,
           ctn_promo,
           ctn_user_codi)
        values
          (v_cnt_codigo,
           1,--v_ctn_tickt_embu,
           v_ctn_clpr_codi,
           1,--v_ctn_etap_codi,
           v_ctn_sose_codi,
           v_ctn_ubicacion,
           v_ctn_vehi_codi,
           v_ctn_ciudad,
           v_ctn_importe,
           'I',
           v_promo,
           v_empleado);
  
  update extr_rege_link 
     set regi_expo_nego = v_cnt_codigo
   where regi_codigo = p_regi;
   
   
--raise_application_error(-20001, 'adffsadf');

end pp_generar_negociacion;


procedure pp_editar_imagen (p_id       in varchar2,
                            p_imagen   in varchar2, 
                            p_tipo_doc in varchar2,
                            p_clave    in number,
                            p_items    in number) is
  
 v_archivo blob;
 v_mime_type varchar2(2000);
 v_filename varchar2(2000);
  v_cantidad number;
  v_extr_vehi_cod number;
begin
   -- raise_application_error (-20001,p_id||'--'||p_imagen );

  if p_imagen is null then
    
  raise_application_error(-20001, 'La imagen no puede quedar vacia');
  end if;

  begin
   SELECT blob_content, mime_type, filename
      INTO v_archivo,v_mime_type, v_filename
      FROM APEX_APPLICATION_FILES A
     WHERE A.NAME = p_imagen 
       AND ROWNUM = 1;
       exception when others then
         null;
         end;
       
if p_id is not null then     
/* update extr_vehi_det
    set vdet_file = v_archivo,
        vdet_file_mime_type = v_mime_type,
        vdet_file_name = v_filename,
        VDET_FEC_ACT = sysdate
 where vdet_id_file = p_id;*/
 
 delete extr_vehi_det
 where vdet_id_file = p_id;
 --commit;
 
   select extr_vehi_cod.nextval +100
      into v_extr_vehi_cod 
      from dual;
   -- raise_application_error(-20001,p_items||'++'||p_clave||'++'||p_tipo_doc);   
    insert into extr_vehi_det
      (vdet_codigo,
       vdet_req,
       vdet_cant,
       vdet_file,
       vdet_fec_grab,
       vdet_item,
       vdet_file_mime_type,
       vdet_file_name,
       vdet_id_file,
       VDET_FEC_ACT) 
       values
      (p_clave,
       p_tipo_doc,
       1,
       v_archivo,
       sysdate,
       p_items,
       v_mime_type,
       v_filename,
       v_extr_vehi_cod,
       sysdate);
     
 end if;
 
 if p_id is null and p_tipo_doc is null then
   raise_application_error(-20001, 'Debe elegir el tipo de documento');
 end if;

 if p_id is null and p_tipo_doc is not null then
 select count(*)
   into v_cantidad
 from extr_vehi_det s
 where  vdet_req = p_tipo_doc
   and s.vdet_codigo = p_clave
   and s.vdet_item= p_items; 
  raise_application_error(-20001, 'Ya existe el documento cargado');
 
 if v_cantidad  >0 then
   raise_application_error(-20001, 'Ya existe el documento cargado');
 end if;
   
   select extr_vehi_cod.nextval 
      into v_extr_vehi_cod 
      from dual;
      
    insert into extr_vehi_det
      (vdet_codigo,
       vdet_req,
       vdet_cant,
       vdet_file,
       vdet_fec_grab,
       vdet_item,
       vdet_file_mime_type,
       vdet_file_name,
       vdet_id_file,
       VDET_FEC_ACT) 
       values
      (p_clave,
       p_tipo_doc,
       1,
       v_archivo,
       sysdate,
       p_items,
       v_mime_type,
       v_filename,
       v_extr_vehi_cod,
       sysdate);
end if;
end pp_editar_imagen;





  procedure pp_valida_chasis_duplicado1(i_nume_chas      in varchar2) is
  
    v_count     number := 0;
    v_sose_nume number;
  
  begin

    select count(*)
      into v_count
      from come_vehi v, come_soli_serv_anex_deta d
     where v.vehi_codi = d.deta_vehi_codi
      and v.vehi_esta <> 'D'
      and v.vehi_nume_chas = i_nume_chas;
  
    if v_count > 0 then
      if i_nume_chas <> 'S/D' then
        --- raise_application_error(-20010, i_nume_chas||' lalalalalalal');
      
      
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
           and v.vehi_nume_chas = i_nume_chas;
             
        raise_application_error(-20010,
                                'La serie de Chasis Nro ' || i_nume_chas ||
                                ' ya existe para un vehiculo en la Solicitud Nro ' ||
                                v_sose_nume || ', favor verifique.');
      end if;
    end if;
  end pp_valida_chasis_duplicado1;
  
  
  
   procedure pp_valida_patente_duplicado1(i_nume_pate in varchar2) is
  
    v_count number := 0;
  
  begin
    
  

  
    select count(*)
      into v_count
      from come_vehi
     where I020271_A.pp_caract_espec(p_varible => vehi_nume_pate) =
    I020271_A.pp_caract_espec(p_varible => i_nume_pate)
    -- vehi_nume_pate = i_nume_pate
       and nvl(vehi_esta_vehi, 'A') = 'A'
       and nvl(vehi_esta, 'I') <> 'D';
  
  --raise_application_error (-20001,v('P65_CONC_CODI_ALTE'));
  if v('P65_CONC_CODI_ALTE') <> 239 then
    if v_count > 0 then
      if i_nume_pate <> 'S/D' then
        raise_application_error(-20010,
                                'La serie de Patente ingresada ya existe. Favor verifique.');
      end if;
    end if;
  end if;
  end pp_valida_patente_duplicado1;


function pp_caract_espec (p_varible varchar2) return varchar2 is
  v_resultado varchar2(1000);
begin
  select lower(regexp_replace(regexp_replace(p_varible, '[(][A-Z]+[)]', ''), '[^a-zA-Z-0-9]', '')) 
   into v_resultado
   from dual;
   
 return v_resultado;
end pp_caract_espec;



  procedure pp_borrar_registro_anex (p_anex_codi in number) is
    --v_message varchar2(70) := '?realmente desea borrar el registro?';
  begin
  
    --pp_set_variables_anex(p_anex_codi);
  
    pp_valida_anexo(p_anex_codi);
    pp_borrar_anexo(p_anex_codi);
  
  end pp_borrar_registro_anex;


 procedure pp_borrar_anexo(i_anex_codi in number) is
  
    salir exception;
    --v_vehi_esta      varchar2(1);
    v_ortr_codi_rein number;
    --v_count          number;
  
    cursor cv_deta is
      select d.deta_vehi_codi,
             d.deta_codi,
             a.anex_tipo,
             s.sose_codi_padr,
             d.deta_codi_anex_padr
        from come_soli_serv_anex_deta d,
             come_soli_serv_anex      a,
             come_soli_serv           s
       where a.anex_codi = d.deta_anex_codi
         and a.anex_sose_codi = s.sose_codi
         and deta_anex_codi = i_anex_codi;
  
    cursor cv_deta_reno(p_deta_anex_codi in number, p_vehi_codi in number) is
      select d.deta_codi, d.deta_anex_codi
        from come_soli_serv_anex_deta d, come_soli_serv_anex a
       where a.anex_codi = d.deta_anex_codi
         and d.deta_vehi_codi = p_vehi_codi
         and d.deta_anex_codi =
             (select max(deta_anex_codi)
                from come_soli_serv_anex_deta
               where deta_vehi_codi = p_vehi_codi
                 and deta_anex_codi <> p_deta_anex_codi);
  
  begin
  
    for r in cv_deta loop
      if g_sose.sose_tipo = 'N' then
        for z in cv_deta_reno(i_anex_codi, r.deta_vehi_codi) loop
          update come_soli_serv_anex
             set anex_indi_reno = null
           where anex_codi = z.deta_anex_codi;
        
          update come_soli_serv_anex_deta
             set deta_esta = 'I'
           where deta_codi = z.deta_codi;
        
        end loop;
      end if;
      
    
      update come_soli_serv_anex_deta
         set deta_vehi_codi = null
       where deta_codi = r.deta_codi;
    
      --la 'i' instalacion o 'ri' reinstalacion generan vehiculos, al eliminar anexo debe borrar estos vehiculos.
      if nvl(r.anex_tipo, 'I') in ('I', 'RI') then
        delete come_vehi where vehi_codi = r.deta_vehi_codi;
      
        begin
          select max(ortr_codi)
            into v_ortr_codi_rein
            from come_orde_trab t
           where t.ortr_deta_codi = r.deta_codi_anex_padr
             and t.ortr_serv_tipo = 'D'
             and t.ortr_serv_tipo_moti = 'RF';
        exception
          when no_data_found then
            v_ortr_codi_rein := null;
        end;
      
        if v_ortr_codi_rein is not null then
          update come_orde_trab
             set ortr_indi_rein_futu_gene = 'N'
           where ortr_codi = v_ortr_codi_rein;
        end if;
      end if;
    
      delete from come_soli_serv_anex_modu
       where anmo_deta_codi = r.deta_codi;
    
    end loop;
  
    delete from come_soli_serv_anex_deta
     where deta_anex_codi = i_anex_codi;
    delete from come_soli_serv_anex where anex_codi = i_anex_codi;
  
  exception
    when no_data_found then
      null;
  end pp_borrar_anexo;

  procedure pp_valida_anexo(i_anex_codi in number) is
    v_count number;
  begin
  
    /*select count(ortr_codi)
     into v_count
     from come_orde_trab
    where ortr_serv_tipo = v_soli.sose_tipo
      and ortr_codi in (select deta_codi
                          from come_soli_serv_anex_deta
                         where deta_anex_codi = i_anex_codi);*/
  
    if v_count > 0 then
      raise_application_error(-20010,
                              'Existe(n) ' || v_count ||
                              ' orden(es) de Trabajo relacionadas al anexo.');
    end if;
  
  end pp_valida_anexo;
  
    procedure pp_borrar_soli (p_solicitud in number,
                              p_soli_nro  in varchar2)is
    salir exception;
    --v_message varchar(70) := '?Realmente desea Borrar la Solicitud?';
    --v_count   number(20);
    v_nro  number;
  begin
  
  --  pp_set_variables(p_cliente);
  
    pp_valida_borrado (p_solicitud,
                       v_nro);
  if v_nro = 0 then
    delete from come_soli_serv_fact_deta
     where sofa_sose_codi =p_solicitud;-- g_come_soli_serv.sose_codi;
    delete from come_soli_serv_clie_dato
     where sose_codi = p_solicitud;-- g_come_soli_serv.sose_codi;
    delete from come_soli_serv_deta
     where deta_sose_codi = p_solicitud;-- g_come_soli_serv.sose_codi;
    delete from come_soli_serv_vehi
     where vehi_sose_codi = p_solicitud;-- g_come_soli_serv.sose_codi;
    delete from come_soli_serv_cont
     where cont_sose_codi = p_solicitud;-- g_come_soli_serv.sose_codi;
    delete from come_soli_serv_refe
     where refe_sose_codi = p_solicitud;-- g_come_soli_serv.sose_codi;
  
    delete from come_soli_serv
     where sose_codi = p_solicitud;-- g_come_soli_serv.sose_codi;
  
    if g_come_soli_serv.sose_tipo = 'N' then
      update come_soli_serv
         set sose_indi_reno = null
       where sose_nume = p_soli_nro--g_come_soli_serv.sose_nume
         and sose_codi =
             (select max(sose_codi)
                from come_soli_serv
               where sose_nume = p_soli_nro-- g_come_soli_serv.sose_nume
                 and sose_codi <> p_solicitud-- g_come_soli_serv.sose_codi
                 );
    end if;
  
    apex_application.g_print_success_message := 'Registro eliminado.';
end if;
  exception
    when salir then
      null;
  end pp_borrar_soli;
  
  
  procedure pp_eliminar_soli_anex_nego (p_registro in number,
                                        p_opcion   in varchar2)is
  v_cliente     number;
  v_soli_clave  number;
  v_soli_nro    varchar2(100);
  v_anex        number;
  v_nego        number;
  v_etapa       number;
  v_anex_esta   varchar2(2);
  begin
  select r.regi_cliente,
         r.regi_solicitud,
         r.regi_expo_soli,
         r.regi_expo_anex,
         r.regi_expo_nego
    into v_cliente, v_soli_clave, v_soli_nro, v_anex, v_nego
    from extr_rege_link r
   where regi_codigo = p_registro;
   
    --  raise_application_error(-20001,p_registro||'-'||p_opcion||'-'||v_nego );
   
 if v_nego is not null then  
   
 select  ctn_etap_codi
   into v_etapa
  from crm_neg_ticket
  where ctn_codi = v_nego;
 
 else
   v_etapa := 1;
 end if;
 
 
    select a.anex_esta
      into v_anex_esta
      from come_soli_serv_anex a
     where a.anex_codi = v_anex;
 
 
 if v_etapa = 1 and p_opcion  = 3 and nvl(v_anex_esta,'P') = 'P' then
  
   I020271_A.pp_borrar_registro_anex(p_anex_codi => v_anex);
     
   I020271_A.pp_borrar_soli(p_solicitud => v_soli_clave,
                              p_soli_nro  => v_soli_nro);                          
  delete crm_neg_ticket
  where ctn_codi = v_nego;
  
  update extr_rege_link r
     set r.regi_solicitud = null,
         r.regi_expo_soli = null,
         r.regi_expo_anex = null,
         r.regi_expo_nego = null
   where regi_codigo = p_registro;
  
  end if;
  
  
   if v_etapa = 1 and p_opcion  = 2 then                      
      delete crm_neg_ticket
      where ctn_codi = v_nego;
      
      update extr_rege_link r
         set r.regi_expo_nego = null
       where regi_codigo = p_registro;
  end if;
  
 if v_etapa = 1 and p_opcion  = 1 and v_nego is  null and nvl(v_anex_esta,'P') = 'P' then
  
   I020271_A.pp_borrar_registro_anex(p_anex_codi => v_anex);
     
   I020271_A.pp_borrar_soli(p_solicitud => v_soli_clave,
                              p_soli_nro  => v_soli_nro);                          
  
  update extr_rege_link r
     set r.regi_solicitud = null,
         r.regi_expo_soli = null,
         r.regi_expo_anex = null
   where regi_codigo = p_registro;
  
  end if;
  
  if  nvl(v_anex_esta,'P') = 'A' and p_opcion  in(1,3)  then
    
  raise_application_error(-20001,'El anexo ya esta aprobado, no se puede modificar');
  end if;
 --raise_application_error(-20001,v_anex_esta);
  end pp_eliminar_soli_anex_nego;

end I020271_A;
